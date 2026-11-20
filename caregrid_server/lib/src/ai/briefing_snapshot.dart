import 'dart:convert';

import '../generated/protocol.dart';

/// Explicit input allowlist. No member names, free text, exact locations,
/// camera/track identifiers, clinical observations or raw evidence leave SQL.
class BriefingSnapshot {
  BriefingSnapshot.fromRecords(Incident incident, List<Dispatch> dispatches)
    : incidentCode = incident.code,
      sourceUpdatedAt = incident.updatedAt,
      facts = Map.unmodifiable({
        'event_type': incident.eventType.name,
        'recorded_state': incident.state.name,
        'recorded_severity': incident.severity.name,
        'signal_source': incident.source.name,
        'simulation': (incident.scenarioRunId != null).toString(),
        'requires_human_review': incident.needsHumanReview.toString(),
        'assignments_total': '${dispatches.length}',
        'acknowledgements_recorded':
            '${dispatches.where((d) => d.acknowledgedAt != null).length}',
        'arrivals_recorded':
            '${dispatches.where((d) => d.onSceneAt != null).length}',
        'care_starts_recorded':
            '${dispatches.where((d) => d.careAt != null).length}',
        'hospital_prealert_recorded': incident.hospitalNotified.toString(),
        'hospital_ready_recorded': incident.hospitalReady.toString(),
      }),
      _incidentId = incident.id;

  final String incidentCode;
  final DateTime sourceUpdatedAt;
  final Map<String, String> facts;
  final int? _incidentId;

  // The cache includes version and dispatch facts; incident id stays local.
  String get cacheKey =>
      '$_incidentId:${sourceUpdatedAt.toIso8601String()}:${jsonEncode(facts)}';
}
