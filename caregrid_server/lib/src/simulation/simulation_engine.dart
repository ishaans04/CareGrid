import 'package:serverpod/serverpod.dart' hide Responder;

import '../agent/incident_agent.dart';
import '../core/access.dart';
import '../core/clock.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import 'scenario_library.dart';

/// Plays seeded scenarios through the live pipeline by emitting their signals
/// on schedule, exactly as an edge gateway would.
///
/// Pending steps live in memory: this prototype runs a single server
/// instance. A multi-instance deployment would schedule steps as future calls.
class SimulationEngine {
  SimulationEngine._();

  static final Map<int, List<_Pending>> _pending = {};

  static Future<ScenarioRun> start(
    Session session,
    String code, {
    required bool autopilot,
    required Actor actor,
  }) async {
    final def = ScenarioLibrary.byCode(code);
    if (def == null) throw notFound('Scenario $code');
    await _prepareTwin(session);

    final now = CampusClock.now();
    final run = await ScenarioRun.db.insertRow(
      session,
      ScenarioRun(
        scenarioCode: def.code,
        title: def.title,
        startedAt: now,
        startedBy: actor.label,
        autopilot: autopilot,
        status: 'running',
        stepsTotal: def.steps.length,
        stepsEmitted: 0,
        faults: def.faults,
      ),
    );
    _pending[run.id!] = [
      for (final step in def.steps)
        _Pending(now.add(Duration(seconds: step.atSecond)), step.input),
    ];
    await OpsBus.publish(session, 'scenario', message: 'Started ${def.title}');
    await tick(session);
    return (await ScenarioRun.db.findById(session, run.id!))!;
  }

  /// Emits every step that is due. Called by the ops ticker each second.
  static Future<void> tick(Session session) async {
    if (_pending.isEmpty) return;
    final now = CampusClock.now();
    for (final runId in [..._pending.keys]) {
      final steps = _pending[runId]!;
      final due = steps.where((s) => !s.due.isAfter(now)).toList();
      if (due.isEmpty) continue;
      steps.removeWhere(due.contains);
      final run = await ScenarioRun.db.findById(session, runId);
      if (run == null || run.status != 'running') {
        _pending.remove(runId);
        continue;
      }
      for (final step in due) {
        await IncidentAgent.ingest(session, step.input, scenarioRunId: runId);
        run.stepsEmitted += 1;
      }
      if (steps.isEmpty) {
        run.status = 'completed';
        _pending.remove(runId);
      }
      await ScenarioRun.db.updateRow(session, run);
      await OpsBus.publish(session, 'scenario');
    }
  }

  static Future<ScenarioRun> stop(Session session, int runId) async {
    _pending.remove(runId);
    final run = await ScenarioRun.db.findById(session, runId);
    if (run == null) throw notFound('Scenario run $runId');
    if (run.status == 'running') {
      run.status = 'stopped';
      await ScenarioRun.db.updateRow(session, run);
    }
    await OpsBus.publish(session, 'scenario');
    return run;
  }

  /// After a restart, in-memory steps are gone: close orphaned runs.
  static Future<void> closeOrphans(Session session) async {
    await ScenarioRun.db.updateWhere(
      session,
      columnValues: (t) => [t.status('stopped')],
      where: (t) => t.status.equals('running'),
    );
  }

  /// Frees units left unreachable by an earlier fault scenario so demos can
  /// be repeated.
  static Future<void> _prepareTwin(Session session) async {
    final stuck = await Responder.db.find(
      session,
      where: (t) => t.status.equals(ResponderStatus.offline),
    );
    for (final r in stuck.where(
      (r) => (r.statusNote ?? '').startsWith('Missed acknowledgement'),
    )) {
      r
        ..status = ResponderStatus.available
        ..statusNote = null
        ..zoneCode = r.baseZoneCode;
      await Responder.db.updateRow(session, r);
    }
  }
}

class _Pending {
  _Pending(this.due, this.input);

  final DateTime due;
  final SignalInput input;
}
