import 'package:serverpod/serverpod.dart';

import '../core/clock.dart';
import '../generated/protocol.dart';

/// After-action analytics. MTTC is measured from event onset to care
/// initiated, stage by stage; "alert sent" is never counted as success.
class MetricsService {
  MetricsService._();

  static Future<OpsMetrics> compute(Session session) async {
    final incidents = await Incident.db.find(
      session,
      where: (t) => t.parentIncidentId.equals(null),
    );
    final zones = {for (final z in await Zone.db.find(session)) z.code: z.name};

    double? mean(Iterable<double> values) {
      final list = values.toList();
      if (list.isEmpty) return null;
      return list.reduce((a, b) => a + b) / list.length;
    }

    double? stage(
      DateTime? Function(Incident) from,
      DateTime? Function(Incident) to,
    ) => mean(
      incidents
          .where((i) => from(i) != null && to(i) != null)
          .map((i) => to(i)!.difference(from(i)!).inMilliseconds / 1000),
    );

    final stages = <(String, double?, String)>[
      (
        'Detection',
        stage((i) => i.onsetAt, (i) => i.detectedAt),
        'Event onset to incident created',
      ),
      (
        'Verification',
        stage((i) => i.detectedAt, (i) => i.verifiedAt),
        'Incident created to verified',
      ),
      (
        'Dispatch',
        stage((i) => i.verifiedAt, (i) => i.dispatchedAt),
        'Verified to responder assigned',
      ),
      (
        'Acknowledgement',
        stage((i) => i.dispatchedAt, (i) => i.acknowledgedAt),
        'Dispatch to responder accepts',
      ),
      (
        'Arrival',
        stage((i) => i.acknowledgedAt, (i) => i.onSceneAt),
        'Accepted to verified on scene',
      ),
      (
        'Care start',
        stage((i) => i.onSceneAt, (i) => i.careAt),
        'On scene to care / action started',
      ),
    ];

    final mttc = stage((i) => i.onsetAt, (i) => i.careAt);

    // Response Completion Integrity: dispatched and closed incidents whose
    // whole chain (ack, arrival, care) was verified.
    final dispatchedClosed = incidents
        .where((i) => i.dispatchedAt != null && !i.state.open)
        .toList();
    final complete = dispatchedClosed.where(
      (i) =>
          i.acknowledgedAt != null &&
          i.onSceneAt != null &&
          i.careAt != null &&
          i.state == IncidentState.resolved,
    );
    final rci = dispatchedClosed.isEmpty
        ? null
        : complete.length / dispatchedClosed.length * 100;

    final verified = incidents.where((i) => i.verifiedAt != null).toList();
    final falseEscalations = verified
        .where((i) => i.state == IncidentState.dismissed)
        .length;
    final blind = incidents
        .where((i) => i.observability != Observability.full)
        .length;

    final dismissReasons = <String, int>{};
    for (final i in incidents.where(
      (i) => i.state == IncidentState.dismissed,
    )) {
      final note = i.closureNote ?? 'No reason';
      final key = note.contains(':') ? note.split(':').first : note;
      dismissReasons[key] = (dismissReasons[key] ?? 0) + 1;
    }

    Map<String, int> countBy(String Function(Incident) key) {
      final map = <String, int>{};
      for (final i in incidents) {
        map[key(i)] = (map[key(i)] ?? 0) + 1;
      }
      return map;
    }

    return OpsMetrics(
      generatedAt: CampusClock.now(),
      mttcSeconds: mttc,
      stages: [
        for (final (label, value, note) in stages)
          if (value != null)
            StageEstimate(label: label, seconds: value, note: note),
      ],
      rciPercent: rci,
      falseEscalationPercent: verified.isEmpty
          ? null
          : falseEscalations / verified.length * 100,
      blindSpotPercent: incidents.isEmpty
          ? null
          : blind / incidents.length * 100,
      incidentsTotal: incidents.length,
      resolved: incidents
          .where((i) => i.state == IncidentState.resolved)
          .length,
      dismissed: incidents
          .where((i) => i.state == IncidentState.dismissed)
          .length,
      open: incidents.where((i) => i.state.open).length,
      escalations: incidents.fold(0, (sum, i) => sum + i.escalationLevel),
      dismissReasons: dismissReasons,
      byFamily: countBy((i) => i.family.label),
      bySeverity: countBy((i) => i.severity.label),
      byZone: countBy((i) => zones[i.zoneCode] ?? i.zoneCode),
    );
  }
}
