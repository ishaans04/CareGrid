/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:caregrid_client/src/protocol/protocol.dart' as _i3n4vhm4;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../enums/event_family.dart' as _idlnttep;
import '../enums/event_type.dart' as _ikhu1dq5;
import '../enums/incident_state.dart' as _i15vj9fk;
import '../enums/observability.dart' as _iz9xj5p4;
import '../enums/severity.dart' as _i55c3ufc;
import '../enums/signal_source.dart' as _ixv6cj1v;

/// One owned, traceable incident. Every meaningful signal becomes (or joins) an incident; nothing waits in an alert queue.
abstract class Incident
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Incident._({
    this.id,
    required this.code,
    required this.title,
    required this.eventType,
    required this.family,
    required this.severity,
    required this.state,
    required this.zoneCode,
    this.locationDetail,
    this.primaryCameraCode,
    this.trackId,
    required this.source,
    required this.confidence,
    bool? corroborated,
    _iz9xj5p4.Observability? observability,
    required this.consequence,
    this.policyCode,
    required this.reasoning,
    required this.negativeEvidence,
    this.nextAction,
    this.parentIncidentId,
    int? escalationLevel,
    bool? needsHumanReview,
    this.ownerName,
    bool? hospitalNotified,
    bool? hospitalReady,
    this.scenarioRunId,
    this.contextHour,
    required this.onsetAt,
    required this.detectedAt,
    this.verifiedAt,
    this.dispatchedAt,
    this.acknowledgedAt,
    this.enRouteAt,
    this.onSceneAt,
    this.careAt,
    this.resolvedAt,
    this.dismissedAt,
    this.closureNote,
    this.nextDeadline,
    this.nextDeadlineLabel,
    required this.updatedAt,
    int? revision,
  }) : corroborated = corroborated ?? false,
       observability = observability ?? _iz9xj5p4.Observability.full,
       escalationLevel = escalationLevel ?? 0,
       needsHumanReview = needsHumanReview ?? false,
       hospitalNotified = hospitalNotified ?? false,
       hospitalReady = hospitalReady ?? false,
       revision = revision ?? 0;

  factory Incident({
    int? id,
    required String code,
    required String title,
    required _ikhu1dq5.EventType eventType,
    required _idlnttep.EventFamily family,
    required _i55c3ufc.Severity severity,
    required _i15vj9fk.IncidentState state,
    required String zoneCode,
    String? locationDetail,
    String? primaryCameraCode,
    String? trackId,
    required _ixv6cj1v.SignalSource source,
    required double confidence,
    bool? corroborated,
    _iz9xj5p4.Observability? observability,
    required String consequence,
    String? policyCode,
    required List<String> reasoning,
    required List<String> negativeEvidence,
    String? nextAction,
    int? parentIncidentId,
    int? escalationLevel,
    bool? needsHumanReview,
    String? ownerName,
    bool? hospitalNotified,
    bool? hospitalReady,
    int? scenarioRunId,
    int? contextHour,
    required DateTime onsetAt,
    required DateTime detectedAt,
    DateTime? verifiedAt,
    DateTime? dispatchedAt,
    DateTime? acknowledgedAt,
    DateTime? enRouteAt,
    DateTime? onSceneAt,
    DateTime? careAt,
    DateTime? resolvedAt,
    DateTime? dismissedAt,
    String? closureNote,
    DateTime? nextDeadline,
    String? nextDeadlineLabel,
    required DateTime updatedAt,
    int? revision,
  }) = _IncidentImpl;

  factory Incident.fromJson(Map<String, dynamic> jsonSerialization) {
    return Incident(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      eventType: _ikhu1dq5.EventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      family: _idlnttep.EventFamily.fromJson(
        (jsonSerialization['family'] as String),
      ),
      severity: _i55c3ufc.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      state: _i15vj9fk.IncidentState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      zoneCode: jsonSerialization['zoneCode'] as String,
      locationDetail: jsonSerialization['locationDetail'] as String?,
      primaryCameraCode: jsonSerialization['primaryCameraCode'] as String?,
      trackId: jsonSerialization['trackId'] as String?,
      source: _ixv6cj1v.SignalSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      corroborated: jsonSerialization['corroborated'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['corroborated']),
      observability: jsonSerialization['observability'] == null
          ? null
          : _iz9xj5p4.Observability.fromJson(
              (jsonSerialization['observability'] as String),
            ),
      consequence: jsonSerialization['consequence'] as String,
      policyCode: jsonSerialization['policyCode'] as String?,
      reasoning: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['reasoning'],
      ),
      negativeEvidence: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['negativeEvidence'],
      ),
      nextAction: jsonSerialization['nextAction'] as String?,
      parentIncidentId: jsonSerialization['parentIncidentId'] as int?,
      escalationLevel: jsonSerialization['escalationLevel'] as int?,
      needsHumanReview: jsonSerialization['needsHumanReview'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['needsHumanReview'],
            ),
      ownerName: jsonSerialization['ownerName'] as String?,
      hospitalNotified: jsonSerialization['hospitalNotified'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['hospitalNotified'],
            ),
      hospitalReady: jsonSerialization['hospitalReady'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['hospitalReady']),
      scenarioRunId: jsonSerialization['scenarioRunId'] as int?,
      contextHour: jsonSerialization['contextHour'] as int?,
      onsetAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['onsetAt'],
      ),
      detectedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['detectedAt'],
      ),
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['verifiedAt'],
            ),
      dispatchedAt: jsonSerialization['dispatchedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['dispatchedAt'],
            ),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      enRouteAt: jsonSerialization['enRouteAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['enRouteAt']),
      onSceneAt: jsonSerialization['onSceneAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['onSceneAt']),
      careAt: jsonSerialization['careAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['careAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt'],
            ),
      dismissedAt: jsonSerialization['dismissedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['dismissedAt'],
            ),
      closureNote: jsonSerialization['closureNote'] as String?,
      nextDeadline: jsonSerialization['nextDeadline'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextDeadline'],
            ),
      nextDeadlineLabel: jsonSerialization['nextDeadlineLabel'] as String?,
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      revision: jsonSerialization['revision'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Human readable id, e.g. INC-1042.
  String code;

  String title;

  _ikhu1dq5.EventType eventType;

  _idlnttep.EventFamily family;

  _i55c3ufc.Severity severity;

  _i15vj9fk.IncidentState state;

  String zoneCode;

  /// Floor / corridor / landmark, e.g. 'Block B, ground floor, corridor 2'.
  String? locationDetail;

  String? primaryCameraCode;

  /// Anonymous track id from edge inference. No facial recognition.
  String? trackId;

  _ixv6cj1v.SignalSource source;

  double confidence;

  bool corroborated;

  _iz9xj5p4.Observability observability;

  /// What could happen if nobody acts, e.g. 'Potential medical emergency'. Never a diagnosis.
  String consequence;

  String? policyCode;

  /// The agent's explanation, one line per reasoning step.
  List<String> reasoning;

  /// Evidence that argues against an emergency.
  List<String> negativeEvidence;

  /// The single next action the operator should take.
  String? nextAction;

  /// Parent incident for multi-victim events (this row is a victim sub-record).
  int? parentIncidentId;

  int escalationLevel;

  bool needsHumanReview;

  String? ownerName;

  bool hospitalNotified;

  /// Hospital acknowledged it is ready to receive the patient.
  bool hospitalReady;

  int? scenarioRunId;

  /// Simulated local hour used by scenarios (e.g. 2 for the 02:17 hostel scenario).
  int? contextHour;

  DateTime onsetAt;

  DateTime detectedAt;

  DateTime? verifiedAt;

  DateTime? dispatchedAt;

  DateTime? acknowledgedAt;

  DateTime? enRouteAt;

  DateTime? onSceneAt;

  DateTime? careAt;

  DateTime? resolvedAt;

  DateTime? dismissedAt;

  /// Outcome on resolution or reason on dismissal.
  String? closureNote;

  /// The next milestone Proof-of-Response expects, and when.
  DateTime? nextDeadline;

  String? nextDeadlineLabel;

  DateTime updatedAt;

  /// Optimistic concurrency: every save must start from the latest revision, so a stale copy (for example a watchdog pass that began before an operator dispatched) can never overwrite newer state.
  int revision;

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Incident copyWith({
    int? id,
    String? code,
    String? title,
    _ikhu1dq5.EventType? eventType,
    _idlnttep.EventFamily? family,
    _i55c3ufc.Severity? severity,
    _i15vj9fk.IncidentState? state,
    String? zoneCode,
    String? locationDetail,
    String? primaryCameraCode,
    String? trackId,
    _ixv6cj1v.SignalSource? source,
    double? confidence,
    bool? corroborated,
    _iz9xj5p4.Observability? observability,
    String? consequence,
    String? policyCode,
    List<String>? reasoning,
    List<String>? negativeEvidence,
    String? nextAction,
    int? parentIncidentId,
    int? escalationLevel,
    bool? needsHumanReview,
    String? ownerName,
    bool? hospitalNotified,
    bool? hospitalReady,
    int? scenarioRunId,
    int? contextHour,
    DateTime? onsetAt,
    DateTime? detectedAt,
    DateTime? verifiedAt,
    DateTime? dispatchedAt,
    DateTime? acknowledgedAt,
    DateTime? enRouteAt,
    DateTime? onSceneAt,
    DateTime? careAt,
    DateTime? resolvedAt,
    DateTime? dismissedAt,
    String? closureNote,
    DateTime? nextDeadline,
    String? nextDeadlineLabel,
    DateTime? updatedAt,
    int? revision,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'eventType': eventType.toJson(),
      'family': family.toJson(),
      'severity': severity.toJson(),
      'state': state.toJson(),
      'zoneCode': zoneCode,
      if (locationDetail != null) 'locationDetail': locationDetail,
      if (primaryCameraCode != null) 'primaryCameraCode': primaryCameraCode,
      if (trackId != null) 'trackId': trackId,
      'source': source.toJson(),
      'confidence': confidence,
      'corroborated': corroborated,
      'observability': observability.toJson(),
      'consequence': consequence,
      if (policyCode != null) 'policyCode': policyCode,
      'reasoning': reasoning.toJson(),
      'negativeEvidence': negativeEvidence.toJson(),
      if (nextAction != null) 'nextAction': nextAction,
      if (parentIncidentId != null) 'parentIncidentId': parentIncidentId,
      'escalationLevel': escalationLevel,
      'needsHumanReview': needsHumanReview,
      if (ownerName != null) 'ownerName': ownerName,
      'hospitalNotified': hospitalNotified,
      'hospitalReady': hospitalReady,
      if (scenarioRunId != null) 'scenarioRunId': scenarioRunId,
      if (contextHour != null) 'contextHour': contextHour,
      'onsetAt': onsetAt.toJson(),
      'detectedAt': detectedAt.toJson(),
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (dispatchedAt != null) 'dispatchedAt': dispatchedAt?.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (enRouteAt != null) 'enRouteAt': enRouteAt?.toJson(),
      if (onSceneAt != null) 'onSceneAt': onSceneAt?.toJson(),
      if (careAt != null) 'careAt': careAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (dismissedAt != null) 'dismissedAt': dismissedAt?.toJson(),
      if (closureNote != null) 'closureNote': closureNote,
      if (nextDeadline != null) 'nextDeadline': nextDeadline?.toJson(),
      if (nextDeadlineLabel != null) 'nextDeadlineLabel': nextDeadlineLabel,
      'updatedAt': updatedAt.toJson(),
      'revision': revision,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Incident',
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'eventType': eventType.toJson(),
      'family': family.toJson(),
      'severity': severity.toJson(),
      'state': state.toJson(),
      'zoneCode': zoneCode,
      if (locationDetail != null) 'locationDetail': locationDetail,
      if (primaryCameraCode != null) 'primaryCameraCode': primaryCameraCode,
      if (trackId != null) 'trackId': trackId,
      'source': source.toJson(),
      'confidence': confidence,
      'corroborated': corroborated,
      'observability': observability.toJson(),
      'consequence': consequence,
      if (policyCode != null) 'policyCode': policyCode,
      'reasoning': reasoning.toJson(),
      'negativeEvidence': negativeEvidence.toJson(),
      if (nextAction != null) 'nextAction': nextAction,
      if (parentIncidentId != null) 'parentIncidentId': parentIncidentId,
      'escalationLevel': escalationLevel,
      'needsHumanReview': needsHumanReview,
      if (ownerName != null) 'ownerName': ownerName,
      'hospitalNotified': hospitalNotified,
      'hospitalReady': hospitalReady,
      if (scenarioRunId != null) 'scenarioRunId': scenarioRunId,
      if (contextHour != null) 'contextHour': contextHour,
      'onsetAt': onsetAt.toJson(),
      'detectedAt': detectedAt.toJson(),
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (dispatchedAt != null) 'dispatchedAt': dispatchedAt?.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (enRouteAt != null) 'enRouteAt': enRouteAt?.toJson(),
      if (onSceneAt != null) 'onSceneAt': onSceneAt?.toJson(),
      if (careAt != null) 'careAt': careAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (dismissedAt != null) 'dismissedAt': dismissedAt?.toJson(),
      if (closureNote != null) 'closureNote': closureNote,
      if (nextDeadline != null) 'nextDeadline': nextDeadline?.toJson(),
      if (nextDeadlineLabel != null) 'nextDeadlineLabel': nextDeadlineLabel,
      'updatedAt': updatedAt.toJson(),
      'revision': revision,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentImpl extends Incident {
  _IncidentImpl({
    int? id,
    required String code,
    required String title,
    required _ikhu1dq5.EventType eventType,
    required _idlnttep.EventFamily family,
    required _i55c3ufc.Severity severity,
    required _i15vj9fk.IncidentState state,
    required String zoneCode,
    String? locationDetail,
    String? primaryCameraCode,
    String? trackId,
    required _ixv6cj1v.SignalSource source,
    required double confidence,
    bool? corroborated,
    _iz9xj5p4.Observability? observability,
    required String consequence,
    String? policyCode,
    required List<String> reasoning,
    required List<String> negativeEvidence,
    String? nextAction,
    int? parentIncidentId,
    int? escalationLevel,
    bool? needsHumanReview,
    String? ownerName,
    bool? hospitalNotified,
    bool? hospitalReady,
    int? scenarioRunId,
    int? contextHour,
    required DateTime onsetAt,
    required DateTime detectedAt,
    DateTime? verifiedAt,
    DateTime? dispatchedAt,
    DateTime? acknowledgedAt,
    DateTime? enRouteAt,
    DateTime? onSceneAt,
    DateTime? careAt,
    DateTime? resolvedAt,
    DateTime? dismissedAt,
    String? closureNote,
    DateTime? nextDeadline,
    String? nextDeadlineLabel,
    required DateTime updatedAt,
    int? revision,
  }) : super._(
         id: id,
         code: code,
         title: title,
         eventType: eventType,
         family: family,
         severity: severity,
         state: state,
         zoneCode: zoneCode,
         locationDetail: locationDetail,
         primaryCameraCode: primaryCameraCode,
         trackId: trackId,
         source: source,
         confidence: confidence,
         corroborated: corroborated,
         observability: observability,
         consequence: consequence,
         policyCode: policyCode,
         reasoning: reasoning,
         negativeEvidence: negativeEvidence,
         nextAction: nextAction,
         parentIncidentId: parentIncidentId,
         escalationLevel: escalationLevel,
         needsHumanReview: needsHumanReview,
         ownerName: ownerName,
         hospitalNotified: hospitalNotified,
         hospitalReady: hospitalReady,
         scenarioRunId: scenarioRunId,
         contextHour: contextHour,
         onsetAt: onsetAt,
         detectedAt: detectedAt,
         verifiedAt: verifiedAt,
         dispatchedAt: dispatchedAt,
         acknowledgedAt: acknowledgedAt,
         enRouteAt: enRouteAt,
         onSceneAt: onSceneAt,
         careAt: careAt,
         resolvedAt: resolvedAt,
         dismissedAt: dismissedAt,
         closureNote: closureNote,
         nextDeadline: nextDeadline,
         nextDeadlineLabel: nextDeadlineLabel,
         updatedAt: updatedAt,
         revision: revision,
       );

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Incident copyWith({
    Object? id = _Undefined,
    String? code,
    String? title,
    _ikhu1dq5.EventType? eventType,
    _idlnttep.EventFamily? family,
    _i55c3ufc.Severity? severity,
    _i15vj9fk.IncidentState? state,
    String? zoneCode,
    Object? locationDetail = _Undefined,
    Object? primaryCameraCode = _Undefined,
    Object? trackId = _Undefined,
    _ixv6cj1v.SignalSource? source,
    double? confidence,
    bool? corroborated,
    _iz9xj5p4.Observability? observability,
    String? consequence,
    Object? policyCode = _Undefined,
    List<String>? reasoning,
    List<String>? negativeEvidence,
    Object? nextAction = _Undefined,
    Object? parentIncidentId = _Undefined,
    int? escalationLevel,
    bool? needsHumanReview,
    Object? ownerName = _Undefined,
    bool? hospitalNotified,
    bool? hospitalReady,
    Object? scenarioRunId = _Undefined,
    Object? contextHour = _Undefined,
    DateTime? onsetAt,
    DateTime? detectedAt,
    Object? verifiedAt = _Undefined,
    Object? dispatchedAt = _Undefined,
    Object? acknowledgedAt = _Undefined,
    Object? enRouteAt = _Undefined,
    Object? onSceneAt = _Undefined,
    Object? careAt = _Undefined,
    Object? resolvedAt = _Undefined,
    Object? dismissedAt = _Undefined,
    Object? closureNote = _Undefined,
    Object? nextDeadline = _Undefined,
    Object? nextDeadlineLabel = _Undefined,
    DateTime? updatedAt,
    int? revision,
  }) {
    return Incident(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      eventType: eventType ?? this.eventType,
      family: family ?? this.family,
      severity: severity ?? this.severity,
      state: state ?? this.state,
      zoneCode: zoneCode ?? this.zoneCode,
      locationDetail: locationDetail is String?
          ? locationDetail
          : this.locationDetail,
      primaryCameraCode: primaryCameraCode is String?
          ? primaryCameraCode
          : this.primaryCameraCode,
      trackId: trackId is String? ? trackId : this.trackId,
      source: source ?? this.source,
      confidence: confidence ?? this.confidence,
      corroborated: corroborated ?? this.corroborated,
      observability: observability ?? this.observability,
      consequence: consequence ?? this.consequence,
      policyCode: policyCode is String? ? policyCode : this.policyCode,
      reasoning: reasoning ?? this.reasoning.map((e0) => e0).toList(),
      negativeEvidence:
          negativeEvidence ?? this.negativeEvidence.map((e0) => e0).toList(),
      nextAction: nextAction is String? ? nextAction : this.nextAction,
      parentIncidentId: parentIncidentId is int?
          ? parentIncidentId
          : this.parentIncidentId,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      needsHumanReview: needsHumanReview ?? this.needsHumanReview,
      ownerName: ownerName is String? ? ownerName : this.ownerName,
      hospitalNotified: hospitalNotified ?? this.hospitalNotified,
      hospitalReady: hospitalReady ?? this.hospitalReady,
      scenarioRunId: scenarioRunId is int? ? scenarioRunId : this.scenarioRunId,
      contextHour: contextHour is int? ? contextHour : this.contextHour,
      onsetAt: onsetAt ?? this.onsetAt,
      detectedAt: detectedAt ?? this.detectedAt,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      dispatchedAt: dispatchedAt is DateTime?
          ? dispatchedAt
          : this.dispatchedAt,
      acknowledgedAt: acknowledgedAt is DateTime?
          ? acknowledgedAt
          : this.acknowledgedAt,
      enRouteAt: enRouteAt is DateTime? ? enRouteAt : this.enRouteAt,
      onSceneAt: onSceneAt is DateTime? ? onSceneAt : this.onSceneAt,
      careAt: careAt is DateTime? ? careAt : this.careAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      dismissedAt: dismissedAt is DateTime? ? dismissedAt : this.dismissedAt,
      closureNote: closureNote is String? ? closureNote : this.closureNote,
      nextDeadline: nextDeadline is DateTime?
          ? nextDeadline
          : this.nextDeadline,
      nextDeadlineLabel: nextDeadlineLabel is String?
          ? nextDeadlineLabel
          : this.nextDeadlineLabel,
      updatedAt: updatedAt ?? this.updatedAt,
      revision: revision ?? this.revision,
    );
  }
}
