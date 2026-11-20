import 'package:serverpod/serverpod.dart' hide Responder;

import '../analytics/metrics_service.dart';
import '../core/access.dart';
import '../core/audit.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';

/// Network operations: one de-identified picture across every campus (for a
/// university group, district or city hub). Counts and timings only; no
/// incident codes, locations, people or evidence leave a campus this way.
class NetworkEndpoint extends Endpoint {
  Future<NetworkOverview> overview(Session session) async {
    final actor = await Access.require(session, {UserRole.network});
    final now = CampusClock.now();
    final window = now.subtract(const Duration(days: 30));
    final campuses = await Campus.db.find(session, orderBy: (t) => t.id);
    final pulses = <CampusPulse>[];
    for (final campus in campuses) {
      final id = campus.id!;
      final open = await Incident.db.find(
        session,
        where: (t) =>
            t.campusId.equals(id) &
            t.parentIncidentId.equals(null) &
            t.resolvedAt.equals(null) &
            t.dismissedAt.equals(null),
      );
      final units = await Responder.db.find(
        session,
        where: (t) => t.campusId.equals(id),
      );
      final cameras = await Camera.db.find(
        session,
        where: (t) => t.campusId.equals(id),
      );
      final metrics = await MetricsService.compute(
        session,
        id,
        since: window,
      );
      final readiness = await _latestReadiness(session, id);
      pulses.add(
        CampusPulse(
          code: campus.code,
          name: campus.name,
          shortName: campus.shortName,
          city: campus.city,
          fictional: campus.fictional,
          attribution: campus.attribution,
          openIncidents: open.length,
          urgentOpen: open
              .where(
                (i) => i.severity == Severity.p0 || i.severity == Severity.p1,
              )
              .length,
          escalatedOpen: open.where((i) => i.escalationLevel > 0).length,
          overdueOpen: open
              .where(
                (i) => i.nextDeadline != null && now.isAfter(i.nextDeadline!),
              )
              .length,
          unitsAvailable: units
              .where((u) => u.status == ResponderStatus.available)
              .length,
          unitsTotal: units.length,
          camerasDegraded: cameras
              .where((c) => c.health != AssetHealth.online)
              .length,
          camerasTotal: cameras.length,
          mttcSeconds: metrics.mttcSeconds?.round(),
          rciPercent: metrics.rciPercent,
          resolved30d: metrics.resolved,
          readinessPercent: readiness?.$1,
          readinessRanAt: readiness?.$2,
        ),
      );
    }
    await Audit.log(session, actor, 'network-overview');
    return NetworkOverview(generatedAt: now, campuses: pulses);
  }

  /// Score of the most recent built-in suite run: the share of the campus's
  /// built-in rehearsals whose latest run passed.
  static Future<(int, DateTime)?> _latestReadiness(
    Session session,
    int campusId,
  ) async {
    final builtIn = await StressScenario.db.find(
      session,
      where: (t) => t.campusId.equals(campusId) & t.builtIn.equals(true),
    );
    if (builtIn.isEmpty) return null;
    var passed = 0;
    DateTime? latest;
    for (final scenario in builtIn) {
      final run = await StressTestRun.db.findFirstRow(
        session,
        where: (t) =>
            t.campusId.equals(campusId) & t.scenarioCode.equals(scenario.code),
        orderBy: (t) => t.ranAt.desc(),
      );
      if (run == null) return null; // Suite not fully run yet.
      if (run.verdict == Verdict.pass) passed++;
      if (latest == null || run.ranAt.isAfter(latest)) latest = run.ranAt;
    }
    return ((passed * 100 / builtIn.length).round(), latest!);
  }
}
