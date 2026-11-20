import 'package:serverpod/serverpod.dart' hide Responder;

import '../core/access.dart';
import '../core/audit.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import '../readiness/stress_test_engine.dart';
import '../twin/twin_snapshot.dart';

/// Readiness Lab: rehearse compound failures before the emergency happens,
/// and apply the fixes the Stress-Test Engine finds to the live twin. Every
/// scenario, run and fix belongs to the caller's campus.
class ReadinessEndpoint extends Endpoint {
  static const _readers = {UserRole.admin, UserRole.command};

  Future<List<StressScenario>> scenarios(Session session) async {
    final actor = await Access.require(session, _readers);
    return StressScenario.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId),
      orderBy: (t) => t.id,
    );
  }

  Future<StressTestRun> run(Session session, String scenarioCode) async {
    final actor = await Access.require(session, _readers);
    final scenario = await StressScenario.db.findFirstRow(
      session,
      where: (t) =>
          t.campusId.equals(actor.campusId) & t.code.equals(scenarioCode),
    );
    if (scenario == null) throw notFound('Stress scenario $scenarioCode');
    return _execute(session, actor, scenario);
  }

  /// Run an ad-hoc scenario built in the Readiness Lab form. Saved for reuse.
  Future<StressTestRun> runCustom(
    Session session,
    StressScenario scenario,
  ) async {
    final actor = await Access.require(session, {UserRole.admin});
    final twin = await TwinSnapshot.load(session, actor.campusId);
    if (twin.zone(scenario.zoneCode) == null) {
      throw badRequest('Unknown zone ${scenario.zoneCode}.');
    }
    if (scenario.hour < 0 || scenario.hour > 23) {
      throw badRequest('Hour must be 0-23.');
    }
    if (scenario.failures.length > 8) {
      throw badRequest('Rehearse at most eight simultaneous failures.');
    }
    for (final f in scenario.failures) {
      final known = switch (f.kind) {
        StressFailureKind.responderBusy => twin.responders.containsKey(
          f.target,
        ),
        StressFailureKind.gateClosed =>
          twin.zone(f.target)?.type == ZoneType.gate,
        StressFailureKind.roadBlocked => twin.roads.any(
          (r) => r.code == f.target,
        ),
        StressFailureKind.cameraDegraded ||
        StressFailureKind.cameraOffline => twin.cameras.containsKey(f.target),
      };
      if (!known) {
        throw badRequest('Unknown ${f.kind.name} target ${f.target}.');
      }
    }
    final saved = await StressScenario.db.insertRow(
      session,
      scenario.copyWith(
        id: null,
        campusId: actor.campusId,
        code: 'ST-CUSTOM-${DateTime.now().millisecondsSinceEpoch}',
        builtIn: false,
      ),
    );
    return _execute(session, actor, saved);
  }

  Future<ReadinessSummary> runAll(Session session) async {
    final actor = await Access.require(session, _readers);
    final scenarios = await StressScenario.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId) & t.builtIn.equals(true),
      orderBy: (t) => t.id,
    );
    final runs = <StressTestRun>[];
    for (final s in scenarios) {
      runs.add(await _execute(session, actor, s, publish: false));
    }
    await OpsBus.publish(session, 'readiness', campusId: actor.campusId);
    final passed = runs.where((r) => r.verdict == Verdict.pass).length;
    return ReadinessSummary(
      scorePercent: runs.isEmpty ? 0 : (passed * 100 / runs.length).round(),
      passed: passed,
      total: runs.length,
      runs: runs,
    );
  }

  Future<List<StressTestRun>> history(Session session, int limit) async {
    final actor = await Access.require(session, _readers);
    return StressTestRun.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId),
      orderBy: (t) => t.ranAt.desc(),
      limit: limit.clamp(1, 100),
    );
  }

  /// Applies a fix found by the engine to the live twin. Codes:
  /// gate-override:ZONE, restage:RESPONDER:ZONE, restore-camera:CAMERA.
  Future<String> applyFix(Session session, String fixCode) async {
    final actor = await Access.require(session, {UserRole.admin});
    final campus = actor.campusId;
    final parts = fixCode.split(':');
    String message;
    switch (parts.first) {
      case 'gate-override' when parts.length == 2:
        final gate = await Zone.db.findFirstRow(
          session,
          where: (t) => t.campusId.equals(campus) & t.code.equals(parts[1]),
        );
        if (gate == null || gate.type != ZoneType.gate) {
          throw notFound('Gate ${parts[1]}');
        }
        gate.emergencyOverride = true;
        await Zone.db.updateRow(session, gate);
        message = 'Emergency override pre-authorized on ${gate.name}.';
      case 'restage' when parts.length == 3:
        final r = await Responder.db.findFirstRow(
          session,
          where: (t) => t.campusId.equals(campus) & t.code.equals(parts[1]),
        );
        if (r == null) throw notFound('Responder ${parts[1]}');
        final base = await Zone.db.findFirstRow(
          session,
          where: (t) => t.campusId.equals(campus) & t.code.equals(parts[2]),
        );
        if (base == null) throw notFound('Zone ${parts[2]}');
        r.baseZoneCode = base.code;
        if (r.status != ResponderStatus.assigned) r.zoneCode = base.code;
        await Responder.db.updateRow(session, r);
        message = '${r.name} re-staged at ${base.name}.';
      case 'restore-camera' when parts.length == 2:
        final c = await Camera.db.findFirstRow(
          session,
          where: (t) => t.campusId.equals(campus) & t.code.equals(parts[1]),
        );
        if (c == null) throw notFound('Camera ${parts[1]}');
        c.health = AssetHealth.online;
        await Camera.db.updateRow(session, c);
        message = '${c.code} marked restored (work order closed).';
      default:
        throw badRequest('Unknown fix $fixCode.');
    }
    await Audit.log(
      session,
      actor,
      'apply-fix',
      target: fixCode,
      detail: message,
    );
    await OpsBus.publish(session, 'twin', campusId: campus, message: message);
    return message;
  }

  Future<StressTestRun> _execute(
    Session session,
    Actor actor,
    StressScenario scenario, {
    bool publish = true,
  }) async {
    final twin = await TwinSnapshot.load(session, actor.campusId);
    final result = StressTestEngine(twin).run(scenario, actor.label);
    final saved = await StressTestRun.db.insertRow(session, result);
    if (publish) {
      await OpsBus.publish(session, 'readiness', campusId: actor.campusId);
    }
    return saved;
  }
}
