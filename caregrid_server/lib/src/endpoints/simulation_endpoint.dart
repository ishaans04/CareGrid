import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/audit.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';
import '../simulation/scenario_library.dart';
import '../simulation/simulation_engine.dart';

/// Simulation Lab: plays seeded emergencies through the live pipeline.
class SimulationEndpoint extends Endpoint {
  static const _roles = {UserRole.command, UserRole.admin};

  Future<SimulationStatus> status(Session session) async {
    await Access.require(session, _roles);
    final runs = await ScenarioRun.db.find(
      session,
      orderBy: (t) => t.startedAt.desc(),
      limit: 15,
    );
    return SimulationStatus(
      scenarios: ScenarioLibrary.all.map((s) => s.toInfo()).toList(),
      runs: runs,
    );
  }

  Future<ScenarioRun> start(
    Session session,
    String code,
    bool autopilot,
  ) async {
    final actor = await Access.require(session, _roles);
    final run = await SimulationEngine.start(
      session,
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
    final actor = await Access.require(session, _roles);
    final run = await SimulationEngine.stop(session, runId);
    await Audit.log(session, actor, 'scenario-stop', target: run.scenarioCode);
    return run;
  }

  /// Stands down every open scenario incident so demos can be repeated.
  Future<int> clear(Session session) async {
    final actor = await Access.require(session, _roles);
    final open = await Incident.db.find(
      session,
      where: (t) =>
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
      where: (t) => t.status.equals('running'),
    );
    for (final run in running) {
      await SimulationEngine.stop(session, run.id!);
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
