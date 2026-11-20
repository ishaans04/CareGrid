import 'package:serverpod/serverpod.dart';

import '../agent/incident_agent.dart';
import '../core/access.dart';
import '../core/audit.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';
import '../twin/twin_snapshot.dart';

/// Campus member SOS: the human signal channel, with closed-loop feedback
/// ("help is on the way") and no access to anyone else's data.
class SosEndpoint extends Endpoint {
  Future<SosStatus> raise(
    Session session,
    String zoneCode,
    String? locationDetail,
    String? note,
    bool forSelf,
  ) async {
    final actor = await Access.require(session, {UserRole.member});
    final event = await IncidentAgent.ingest(
      session,
      SignalInput(
        source: SignalSource.sos,
        eventType: EventType.sosRequest,
        zoneCode: zoneCode,
        confidence: 0.95,
        detail: [
          forSelf ? 'Reporter needs help' : 'Reporter is helping someone',
          if (note != null && note.trim().isNotEmpty) note.trim(),
        ].join(': '),
        locationDetail: locationDetail,
      ),
      reporterUserId: actor.id,
    );
    await Audit.log(session, actor, 'sos-raised', target: zoneCode);
    final incident = await Orchestrator.load(session, event.incidentId!);
    return _status(session, incident, await TwinSnapshot.load(session));
  }

  Future<List<SosStatus>> mine(Session session) async {
    final actor = await Access.require(session, {UserRole.member});
    final twin = await TwinSnapshot.load(session);
    final events = await SensorEvent.db.find(
      session,
      where: (t) => t.reporterUserId.equals(actor.id),
      orderBy: (t) => t.observedAt.desc(),
      limit: 10,
    );
    final ids = events.map((e) => e.incidentId).nonNulls.toSet();
    final result = <SosStatus>[];
    for (final id in ids) {
      final incident = await Incident.db.findById(session, id);
      if (incident != null) result.add(await _status(session, incident, twin));
    }
    return result;
  }

  /// Reporter withdraws the SOS. This is negative evidence bound to their own
  /// incident: before dispatch it stands the incident down only if nobody
  /// else (camera, sensor, another member) supports it; after dispatch a
  /// human decides.
  Future<SosStatus> cancel(
    Session session,
    int incidentId,
    String reason,
  ) async {
    final actor = await Access.require(session, {UserRole.member});
    final mineEvent = await SensorEvent.db.findFirstRow(
      session,
      where: (t) =>
          t.incidentId.equals(incidentId) & t.reporterUserId.equals(actor.id),
    );
    if (mineEvent == null) {
      throw CareGridException(message: 'Not your SOS.', code: 'forbidden');
    }
    final incident = await Orchestrator.load(session, incidentId);
    await IncidentAgent.ingest(
      session,
      SignalInput(
        source: SignalSource.sos,
        eventType: EventType.reporterCancelled,
        zoneCode: incident.zoneCode,
        confidence: 0.9,
        detail: reason.trim().isEmpty
            ? 'Reporter says help is no longer needed'
            : reason.trim(),
      ),
      reporterUserId: actor.id,
      targetIncidentId: incident.id,
    );
    await Audit.log(session, actor, 'sos-cancelled', target: incident.code);
    return _status(
      session,
      await Orchestrator.load(session, incidentId),
      await TwinSnapshot.load(session),
    );
  }

  Future<SosStatus> _status(
    Session session,
    Incident i,
    TwinSnapshot twin,
  ) async {
    final dispatches = (await Orchestrator.dispatchesOf(
      session,
      i.id!,
    )).where((d) => d.status.active).toList();
    DateTime? eta;
    for (final d in dispatches.where((d) => d.onSceneAt == null)) {
      final start = d.enRouteAt ?? d.acknowledgedAt ?? d.offeredAt;
      final at = start.add(Duration(seconds: d.etaSeconds));
      if (eta == null || at.isBefore(eta)) eta = at;
    }
    final message = switch (i.state) {
      IncidentState.detected ||
      IncidentState.review ||
      IncidentState.verified =>
        'Received. The command center is reviewing '
            'your request now.',
      IncidentState.dispatched =>
        'Help has been assigned and is being '
            'contacted.',
      IncidentState.acknowledged || IncidentState.enRoute =>
        'Help is on the way. Stay where you are if '
            'it is safe.',
      IncidentState.onScene => 'Help has arrived.',
      IncidentState.care => 'Care is in progress.',
      IncidentState.resolved => 'Closed. Take care.',
      IncidentState.dismissed => 'Stood down: ${i.closureNote ?? ''}',
    };
    return SosStatus(
      incidentId: i.id!,
      code: i.code,
      state: i.state,
      zoneName: twin.zoneName(i.zoneCode),
      raisedAt: i.onsetAt,
      message: message,
      responders: dispatches
          .map((d) => '${d.responderType.label}: ${d.status.label}')
          .toList(),
      sceneEta: eta != null && eta.isAfter(CampusClock.now()) ? eta : null,
    );
  }
}
