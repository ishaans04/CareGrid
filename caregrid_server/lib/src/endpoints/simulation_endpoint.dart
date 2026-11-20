import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/audit.dart';
import '../core/runtime_policy.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';
import '../simulation/simulation_engine.dart';

/// Simulation Lab: plays the caller's campus's seeded emergencies through the
/// live pipeline.
class SimulationEndpoint extends Endpoint {
  static const _roles = {UserRole.command, UserRole.admin};

  Future<SimulationStatus> status(Session session) async {
    RuntimePolicy.requireDemo(session);
    final actor = await Access.require(session, _roles);
    final runs = await ScenarioRun.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId),
      orderBy: (t) => t.startedAt.desc(),
      limit: 15,
    );
    final catalogue = await SimulationEngine.catalogue(
      session,
      actor.campusId,
    );
    return SimulationStatus(
      scenarios: catalogue.map((s) => s.toInfo()).toList(),
      runs: runs,
    );
  }

  Future<ScenarioRun> start(
    Session session,
    String code,
    bool autopilot,
  ) async {
    RuntimePolicy.requireDemo(session);
    final actor = await Access.require(session, _roles);
    final run = await SimulationEngine.start(
      session,
      actor.campusId,
      code,
      autopilot: autopilot,
      actor: actor,
    );
    await Audit.log(
      session,
      actor,
      'scenario-start',
      target: code,
      detail: autopilot ? 'autopilot' : 'manual',
    );
    return run;
  }

  Future<ScenarioRun> stop(Session session, int runId) async {
    RuntimePolicy.requireDemo(session);
    final actor = await Access.require(session, _roles);
    final existing = await ScenarioRun.db.findById(session, runId);
    if (existing == null || existing.campusId != actor.campusId) {
      throw notFound('Scenario run $runId');
    }
    final run = await SimulationEngine.stop(session, existing);
    await Audit.log(session, actor, 'scenario-stop', target: run.scenarioCode);
    return run;
  }

  /// Stands down every open scenario incident on this campus so demos can be
  /// repeated. Member SOS requests and other campuses are untouched.
  Future<int> clear(Session session) async {
    RuntimePolicy.requireDemo(session);
    final actor = await Access.require(session, _roles);
    final open = await Incident.db.find(
      session,
      where: (t) =>
          t.campusId.equals(actor.campusId) &
          t.scenarioRunId.notEquals(null) &
          t.parentIncidentId.equals(null) &
          t.resolvedAt.equals(null) &
          t.dismissedAt.equals(null),
    );
    for (final incident in open) {
      await Orchestrator.dismiss(
        session,
        incident,
        'Simulation cleanup',
        actor.label,
      );
    }
    final running = await ScenarioRun.db.find(
      session,
      where: (t) =>
          t.campusId.equals(actor.campusId) & t.status.equals('running'),
    );
    for (final run in running) {
      await SimulationEngine.stop(session, run);
    }
    await Audit.log(
      session,
      actor,
      'scenario-clear',
      detail: '${open.length} incidents stood down',
    );
    return open.length;
  }
}
