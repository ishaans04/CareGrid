import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/audit.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';
import '../twin/twin_snapshot.dart';

/// Hospital / Care Console API: incoming emergency context, location, ETA
/// and handoff state. No camera evidence: clinicians get what care needs.
class CareEndpoint extends Endpoint {
  Future<List<CareCase>> cases(Session session) async {
    await Access.require(session, {UserRole.medical, UserRole.command});
    final twin = await TwinSnapshot.load(session);
    final since = CampusClock.now().subtract(const Duration(hours: 12));
    final incidents = await Incident.db.find(
      session,
      where: (t) =>
          t.hospitalNotified.equals(true) &
          t.parentIncidentId.equals(null) &
          ((t.resolvedAt.equals(null) & t.dismissedAt.equals(null)) |
              (t.updatedAt > since)),
      orderBy: (t) => t.onsetAt.desc(),
    );
    final result = <CareCase>[];
    for (final i in incidents) {
      final dispatches = await Orchestrator.dispatchesOf(session, i.id!);
      final ambulance = dispatches
          .where((d) => d.responderType == ResponderType.ambulance)
          .lastOrNull;
      final notes = await TimelineEntry.db.find(
        session,
        where: (t) =>
            t.incidentId.equals(i.id) & t.kind.equals(TimelineKind.care),
        orderBy: (t) => t.at,
      );
      DateTime? sceneEta;
      for (final d in dispatches.where((d) => d.status.active)) {
        if (d.onSceneAt != null) continue;
        final start = d.enRouteAt ?? d.acknowledgedAt ?? d.offeredAt;
        final eta = start.add(Duration(seconds: d.etaSeconds));
        if (sceneEta == null || eta.isBefore(sceneEta)) sceneEta = eta;
      }
      result.add(
        CareCase(
          incidentId: i.id!,
          code: i.code,
          severity: i.severity,
          state: i.state,
          nature: '${i.consequence} (${i.eventType.label.toLowerCase()})',
          zoneName: twin.zoneName(i.zoneCode),
          locationDetail: i.locationDetail,
          onsetAt: i.onsetAt,
          handoffState: _handoff(i),
          hospitalReady: i.hospitalReady,
          ambulanceCode: ambulance?.responderCode,
          ambulanceStatus: ambulance?.status.label,
          sceneEta: sceneEta,
          responders: dispatches
              .where((d) => d.status.active)
              .map((d) => '${d.responderName}: ${d.status.label}')
              .toList(),
          careNotes: notes.map((n) => '${n.actor}: ${n.message}').toList(),
        ),
      );
    }
    return result;
  }

  String _handoff(Incident i) => switch (i.state) {
    IncidentState.detected ||
    IncidentState.review ||
    IncidentState.verified => 'Pre-alert',
    IncidentState.dispatched ||
    IncidentState.acknowledged ||
    IncidentState.enRoute => 'Units en route',
    IncidentState.onScene => 'On scene',
    IncidentState.care => 'Care in progress',
    IncidentState.resolved => 'Closed: ${i.closureNote ?? ''}',
    IncidentState.dismissed => 'Stood down',
  };

  /// The hospital confirms a bay and team are ready to receive.
  Future<void> markReady(Session session, int incidentId) async {
    final actor = await Access.require(session, {UserRole.medical});
    final incident = await Orchestrator.load(session, incidentId);
    incident.hospitalReady = true;
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.care,
      actor.label,
      'Hospital ready to receive: bay and team prepared.',
    );
    await Orchestrator.save(session, incident);
    await Audit.log(session, actor, 'hospital-ready', target: incident.code);
  }
}
