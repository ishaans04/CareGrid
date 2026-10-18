import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../twin/twin_snapshot.dart';

/// Builds role-appropriate views of incidents. Least privilege is enforced
/// here, on the server: each role gets only the context its job needs.
class IncidentViews {
  IncidentViews._();

  static Future<List<IncidentSummary>> summaries(
    Session session,
    List<Incident> incidents,
    TwinSnapshot twin,
  ) async {
    if (incidents.isEmpty) return [];
    final ids = incidents.map((i) => i.id!).toSet();
    final dispatches = await Dispatch.db.find(
      session,
      where: (t) => t.incidentId.inSet(ids),
    );
    final victims = await Incident.db.find(
      session,
      where: (t) => t.parentIncidentId.inSet(ids),
    );
    return [
      for (final i in incidents)
        summary(
          i,
          twin.zoneName(i.zoneCode),
          dispatches
              .where((d) => d.incidentId == i.id && d.status.active)
              .map((d) => '${d.responderName}: ${d.status.label}')
              .toList(),
          victims.where((v) => v.parentIncidentId == i.id).length,
        ),
    ];
  }

  static IncidentSummary summary(
    Incident i,
    String zoneName,
    List<String> responders,
    int victimCount,
  ) => IncidentSummary(
    id: i.id!,
    code: i.code,
    title: i.title,
    eventType: i.eventType,
    family: i.family,
    severity: i.severity,
    state: i.state,
    zoneCode: i.zoneCode,
    zoneName: zoneName,
    locationDetail: i.locationDetail,
    confidence: i.confidence,
    observability: i.observability,
    escalationLevel: i.escalationLevel,
    needsHumanReview: i.needsHumanReview,
    nextAction: i.nextAction,
    nextDeadline: i.nextDeadline,
    nextDeadlineLabel: i.nextDeadlineLabel,
    onsetAt: i.onsetAt,
    updatedAt: i.updatedAt,
    responders: responders,
    victimCount: victimCount,
    parentIncidentId: i.parentIncidentId,
    fromScenario: i.scenarioRunId != null,
  );

  /// Most urgent first: severity, escalation, nearest deadline, oldest onset.
  static int byUrgency(IncidentSummary a, IncidentSummary b) {
    final s = a.severity.rank.compareTo(b.severity.rank);
    if (s != 0) return s;
    final e = b.escalationLevel.compareTo(a.escalationLevel);
    if (e != 0) return e;
    final ad = a.nextDeadline;
    final bd = b.nextDeadline;
    if (ad != null && bd != null) {
      final d = ad.compareTo(bd);
      if (d != 0) return d;
    } else if (ad != null) {
      return -1;
    } else if (bd != null) {
      return 1;
    }
    return a.onsetAt.compareTo(b.onsetAt);
  }

  /// Returns a copy of [i] with fields the [role] must not see removed, and
  /// the list of what was hidden (shown to the user for transparency).
  static (Incident, List<String>) redact(Incident i, UserRole role) {
    switch (role) {
      case UserRole.command:
        return (i.copyWith(), const []);
      case UserRole.medical:
        return (
          i.copyWith(
            primaryCameraCode: null,
            trackId: null,
            reasoning: i.reasoning.where((r) => !r.contains('CAM-')).toList(),
          ),
          const [
            'Camera ids and anonymous track ids (not needed for care)',
            'Raw signals and camera evidence',
          ],
        );
      case UserRole.admin:
        return (
          i.copyWith(
            primaryCameraCode: null,
            trackId: null,
            locationDetail: null,
          ),
          const [
            'Exact location detail, camera and track ids '
                '(administration sees governance data, not live evidence)',
          ],
        );
      case UserRole.responder:
      case UserRole.member:
        return (
          i.copyWith(
            primaryCameraCode: null,
            trackId: null,
            reasoning: [],
            negativeEvidence: [],
          ),
          const ['Agent reasoning, camera evidence and other units\' detail'],
        );
    }
  }
}
