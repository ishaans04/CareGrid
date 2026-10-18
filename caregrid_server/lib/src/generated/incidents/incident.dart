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
import 'package:caregrid_server/src/generated/protocol.dart' as _ighx06pg;
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/event_family.dart' as _idlnttep;
import '../enums/event_type.dart' as _ikhu1dq5;
import '../enums/incident_state.dart' as _i15vj9fk;
import '../enums/observability.dart' as _iz9xj5p4;
import '../enums/severity.dart' as _i55c3ufc;
import '../enums/signal_source.dart' as _ixv6cj1v;

/// One owned, traceable incident. Every meaningful signal becomes (or joins) an incident; nothing waits in an alert queue.
abstract class Incident
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    this.reporterUserId,
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
  }) : corroborated = corroborated ?? false,
       observability = observability ?? _iz9xj5p4.Observability.full,
       escalationLevel = escalationLevel ?? 0,
       needsHumanReview = needsHumanReview ?? false,
       hospitalNotified = hospitalNotified ?? false,
       hospitalReady = hospitalReady ?? false;

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
    int? reporterUserId,
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
          : _is.BoolJsonExtension.fromJson(jsonSerialization['corroborated']),
      observability: jsonSerialization['observability'] == null
          ? null
          : _iz9xj5p4.Observability.fromJson(
              (jsonSerialization['observability'] as String),
            ),
      consequence: jsonSerialization['consequence'] as String,
      policyCode: jsonSerialization['policyCode'] as String?,
      reasoning: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['reasoning'],
      ),
      negativeEvidence: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['negativeEvidence'],
      ),
      nextAction: jsonSerialization['nextAction'] as String?,
      parentIncidentId: jsonSerialization['parentIncidentId'] as int?,
      escalationLevel: jsonSerialization['escalationLevel'] as int?,
      needsHumanReview: jsonSerialization['needsHumanReview'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['needsHumanReview'],
            ),
      ownerName: jsonSerialization['ownerName'] as String?,
      hospitalNotified: jsonSerialization['hospitalNotified'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['hospitalNotified'],
            ),
      hospitalReady: jsonSerialization['hospitalReady'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['hospitalReady']),
      reporterUserId: jsonSerialization['reporterUserId'] as int?,
      scenarioRunId: jsonSerialization['scenarioRunId'] as int?,
      contextHour: jsonSerialization['contextHour'] as int?,
      onsetAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['onsetAt']),
      detectedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['detectedAt'],
      ),
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      dispatchedAt: jsonSerialization['dispatchedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dispatchedAt'],
            ),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      enRouteAt: jsonSerialization['enRouteAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['enRouteAt']),
      onSceneAt: jsonSerialization['onSceneAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['onSceneAt']),
      careAt: jsonSerialization['careAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['careAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      dismissedAt: jsonSerialization['dismissedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dismissedAt'],
            ),
      closureNote: jsonSerialization['closureNote'] as String?,
      nextDeadline: jsonSerialization['nextDeadline'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextDeadline'],
            ),
      nextDeadlineLabel: jsonSerialization['nextDeadlineLabel'] as String?,
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = IncidentTable();

  static const db = IncidentRepository._();

  @override
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

  /// Campus member who raised an SOS. Never sent to any client.
  int? reporterUserId;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
    int? reporterUserId,
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
      if (reporterUserId != null) 'reporterUserId': reporterUserId,
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
    };
  }

  static IncidentInclude include() {
    return IncidentInclude._();
  }

  static IncidentIncludeList includeList({
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    IncidentInclude? include,
  }) {
    return IncidentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
    int? reporterUserId,
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
         reporterUserId: reporterUserId,
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
       );

  /// Returns a shallow copy of this [Incident]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
    Object? reporterUserId = _Undefined,
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
      reporterUserId: reporterUserId is int?
          ? reporterUserId
          : this.reporterUserId,
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
    );
  }
}

class IncidentUpdateTable extends _is.UpdateTable<IncidentTable> {
  IncidentUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<_ikhu1dq5.EventType, _ikhu1dq5.EventType> eventType(
    _ikhu1dq5.EventType value,
  ) => _is.ColumnValue(
    table.eventType,
    value,
  );

  _is.ColumnValue<_idlnttep.EventFamily, _idlnttep.EventFamily> family(
    _idlnttep.EventFamily value,
  ) => _is.ColumnValue(
    table.family,
    value,
  );

  _is.ColumnValue<_i55c3ufc.Severity, _i55c3ufc.Severity> severity(
    _i55c3ufc.Severity value,
  ) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<_i15vj9fk.IncidentState, _i15vj9fk.IncidentState> state(
    _i15vj9fk.IncidentState value,
  ) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<String, String> zoneCode(String value) => _is.ColumnValue(
    table.zoneCode,
    value,
  );

  _is.ColumnValue<String, String> locationDetail(String? value) =>
      _is.ColumnValue(
        table.locationDetail,
        value,
      );

  _is.ColumnValue<String, String> primaryCameraCode(String? value) =>
      _is.ColumnValue(
        table.primaryCameraCode,
        value,
      );

  _is.ColumnValue<String, String> trackId(String? value) => _is.ColumnValue(
    table.trackId,
    value,
  );

  _is.ColumnValue<_ixv6cj1v.SignalSource, _ixv6cj1v.SignalSource> source(
    _ixv6cj1v.SignalSource value,
  ) => _is.ColumnValue(
    table.source,
    value,
  );

  _is.ColumnValue<double, double> confidence(double value) => _is.ColumnValue(
    table.confidence,
    value,
  );

  _is.ColumnValue<bool, bool> corroborated(bool value) => _is.ColumnValue(
    table.corroborated,
    value,
  );

  _is.ColumnValue<_iz9xj5p4.Observability, _iz9xj5p4.Observability>
  observability(_iz9xj5p4.Observability value) => _is.ColumnValue(
    table.observability,
    value,
  );

  _is.ColumnValue<String, String> consequence(String value) => _is.ColumnValue(
    table.consequence,
    value,
  );

  _is.ColumnValue<String, String> policyCode(String? value) => _is.ColumnValue(
    table.policyCode,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> reasoning(List<String> value) =>
      _is.ColumnValue(
        table.reasoning,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> negativeEvidence(
    List<String> value,
  ) => _is.ColumnValue(
    table.negativeEvidence,
    value,
  );

  _is.ColumnValue<String, String> nextAction(String? value) => _is.ColumnValue(
    table.nextAction,
    value,
  );

  _is.ColumnValue<int, int> parentIncidentId(int? value) => _is.ColumnValue(
    table.parentIncidentId,
    value,
  );

  _is.ColumnValue<int, int> escalationLevel(int value) => _is.ColumnValue(
    table.escalationLevel,
    value,
  );

  _is.ColumnValue<bool, bool> needsHumanReview(bool value) => _is.ColumnValue(
    table.needsHumanReview,
    value,
  );

  _is.ColumnValue<String, String> ownerName(String? value) => _is.ColumnValue(
    table.ownerName,
    value,
  );

  _is.ColumnValue<bool, bool> hospitalNotified(bool value) => _is.ColumnValue(
    table.hospitalNotified,
    value,
  );

  _is.ColumnValue<bool, bool> hospitalReady(bool value) => _is.ColumnValue(
    table.hospitalReady,
    value,
  );

  _is.ColumnValue<int, int> reporterUserId(int? value) => _is.ColumnValue(
    table.reporterUserId,
    value,
  );

  _is.ColumnValue<int, int> scenarioRunId(int? value) => _is.ColumnValue(
    table.scenarioRunId,
    value,
  );

  _is.ColumnValue<int, int> contextHour(int? value) => _is.ColumnValue(
    table.contextHour,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> onsetAt(DateTime value) =>
      _is.ColumnValue(
        table.onsetAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> detectedAt(DateTime value) =>
      _is.ColumnValue(
        table.detectedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> verifiedAt(DateTime? value) =>
      _is.ColumnValue(
        table.verifiedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> dispatchedAt(DateTime? value) =>
      _is.ColumnValue(
        table.dispatchedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> acknowledgedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acknowledgedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> enRouteAt(DateTime? value) =>
      _is.ColumnValue(
        table.enRouteAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> onSceneAt(DateTime? value) =>
      _is.ColumnValue(
        table.onSceneAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> careAt(DateTime? value) =>
      _is.ColumnValue(
        table.careAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> dismissedAt(DateTime? value) =>
      _is.ColumnValue(
        table.dismissedAt,
        value,
      );

  _is.ColumnValue<String, String> closureNote(String? value) => _is.ColumnValue(
    table.closureNote,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> nextDeadline(DateTime? value) =>
      _is.ColumnValue(
        table.nextDeadline,
        value,
      );

  _is.ColumnValue<String, String> nextDeadlineLabel(String? value) =>
      _is.ColumnValue(
        table.nextDeadlineLabel,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class IncidentTable extends _is.Table<int?> {
  IncidentTable({super.tableRelation}) : super(tableName: 'incident') {
    updateTable = IncidentUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    eventType = _is.ColumnEnum(
      'eventType',
      this,
      _is.EnumSerialization.byName,
    );
    family = _is.ColumnEnum(
      'family',
      this,
      _is.EnumSerialization.byName,
    );
    severity = _is.ColumnEnum(
      'severity',
      this,
      _is.EnumSerialization.byName,
    );
    state = _is.ColumnEnum(
      'state',
      this,
      _is.EnumSerialization.byName,
    );
    zoneCode = _is.ColumnString(
      'zoneCode',
      this,
    );
    locationDetail = _is.ColumnString(
      'locationDetail',
      this,
    );
    primaryCameraCode = _is.ColumnString(
      'primaryCameraCode',
      this,
    );
    trackId = _is.ColumnString(
      'trackId',
      this,
    );
    source = _is.ColumnEnum(
      'source',
      this,
      _is.EnumSerialization.byName,
    );
    confidence = _is.ColumnDouble(
      'confidence',
      this,
    );
    corroborated = _is.ColumnBool(
      'corroborated',
      this,
      hasDefault: true,
    );
    observability = _is.ColumnEnum(
      'observability',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    consequence = _is.ColumnString(
      'consequence',
      this,
    );
    policyCode = _is.ColumnString(
      'policyCode',
      this,
    );
    reasoning = _is.ColumnSerializable<List<String>>(
      'reasoning',
      this,
    );
    negativeEvidence = _is.ColumnSerializable<List<String>>(
      'negativeEvidence',
      this,
    );
    nextAction = _is.ColumnString(
      'nextAction',
      this,
    );
    parentIncidentId = _is.ColumnInt(
      'parentIncidentId',
      this,
    );
    escalationLevel = _is.ColumnInt(
      'escalationLevel',
      this,
      hasDefault: true,
    );
    needsHumanReview = _is.ColumnBool(
      'needsHumanReview',
      this,
      hasDefault: true,
    );
    ownerName = _is.ColumnString(
      'ownerName',
      this,
    );
    hospitalNotified = _is.ColumnBool(
      'hospitalNotified',
      this,
      hasDefault: true,
    );
    hospitalReady = _is.ColumnBool(
      'hospitalReady',
      this,
      hasDefault: true,
    );
    reporterUserId = _is.ColumnInt(
      'reporterUserId',
      this,
    );
    scenarioRunId = _is.ColumnInt(
      'scenarioRunId',
      this,
    );
    contextHour = _is.ColumnInt(
      'contextHour',
      this,
    );
    onsetAt = _is.ColumnDateTime(
      'onsetAt',
      this,
    );
    detectedAt = _is.ColumnDateTime(
      'detectedAt',
      this,
    );
    verifiedAt = _is.ColumnDateTime(
      'verifiedAt',
      this,
    );
    dispatchedAt = _is.ColumnDateTime(
      'dispatchedAt',
      this,
    );
    acknowledgedAt = _is.ColumnDateTime(
      'acknowledgedAt',
      this,
    );
    enRouteAt = _is.ColumnDateTime(
      'enRouteAt',
      this,
    );
    onSceneAt = _is.ColumnDateTime(
      'onSceneAt',
      this,
    );
    careAt = _is.ColumnDateTime(
      'careAt',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
    dismissedAt = _is.ColumnDateTime(
      'dismissedAt',
      this,
    );
    closureNote = _is.ColumnString(
      'closureNote',
      this,
    );
    nextDeadline = _is.ColumnDateTime(
      'nextDeadline',
      this,
    );
    nextDeadlineLabel = _is.ColumnString(
      'nextDeadlineLabel',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final IncidentUpdateTable updateTable;

  /// Human readable id, e.g. INC-1042.
  late final _is.ColumnString code;

  late final _is.ColumnString title;

  late final _is.ColumnEnum<_ikhu1dq5.EventType> eventType;

  late final _is.ColumnEnum<_idlnttep.EventFamily> family;

  late final _is.ColumnEnum<_i55c3ufc.Severity> severity;

  late final _is.ColumnEnum<_i15vj9fk.IncidentState> state;

  late final _is.ColumnString zoneCode;

  /// Floor / corridor / landmark, e.g. 'Block B, ground floor, corridor 2'.
  late final _is.ColumnString locationDetail;

  late final _is.ColumnString primaryCameraCode;

  /// Anonymous track id from edge inference. No facial recognition.
  late final _is.ColumnString trackId;

  late final _is.ColumnEnum<_ixv6cj1v.SignalSource> source;

  late final _is.ColumnDouble confidence;

  late final _is.ColumnBool corroborated;

  late final _is.ColumnEnum<_iz9xj5p4.Observability> observability;

  /// What could happen if nobody acts, e.g. 'Potential medical emergency'. Never a diagnosis.
  late final _is.ColumnString consequence;

  late final _is.ColumnString policyCode;

  /// The agent's explanation, one line per reasoning step.
  late final _is.ColumnSerializable<List<String>> reasoning;

  /// Evidence that argues against an emergency.
  late final _is.ColumnSerializable<List<String>> negativeEvidence;

  /// The single next action the operator should take.
  late final _is.ColumnString nextAction;

  /// Parent incident for multi-victim events (this row is a victim sub-record).
  late final _is.ColumnInt parentIncidentId;

  late final _is.ColumnInt escalationLevel;

  late final _is.ColumnBool needsHumanReview;

  late final _is.ColumnString ownerName;

  late final _is.ColumnBool hospitalNotified;

  /// Hospital acknowledged it is ready to receive the patient.
  late final _is.ColumnBool hospitalReady;

  /// Campus member who raised an SOS. Never sent to any client.
  late final _is.ColumnInt reporterUserId;

  late final _is.ColumnInt scenarioRunId;

  /// Simulated local hour used by scenarios (e.g. 2 for the 02:17 hostel scenario).
  late final _is.ColumnInt contextHour;

  late final _is.ColumnDateTime onsetAt;

  late final _is.ColumnDateTime detectedAt;

  late final _is.ColumnDateTime verifiedAt;

  late final _is.ColumnDateTime dispatchedAt;

  late final _is.ColumnDateTime acknowledgedAt;

  late final _is.ColumnDateTime enRouteAt;

  late final _is.ColumnDateTime onSceneAt;

  late final _is.ColumnDateTime careAt;

  late final _is.ColumnDateTime resolvedAt;

  late final _is.ColumnDateTime dismissedAt;

  /// Outcome on resolution or reason on dismissal.
  late final _is.ColumnString closureNote;

  /// The next milestone Proof-of-Response expects, and when.
  late final _is.ColumnDateTime nextDeadline;

  late final _is.ColumnString nextDeadlineLabel;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    title,
    eventType,
    family,
    severity,
    state,
    zoneCode,
    locationDetail,
    primaryCameraCode,
    trackId,
    source,
    confidence,
    corroborated,
    observability,
    consequence,
    policyCode,
    reasoning,
    negativeEvidence,
    nextAction,
    parentIncidentId,
    escalationLevel,
    needsHumanReview,
    ownerName,
    hospitalNotified,
    hospitalReady,
    reporterUserId,
    scenarioRunId,
    contextHour,
    onsetAt,
    detectedAt,
    verifiedAt,
    dispatchedAt,
    acknowledgedAt,
    enRouteAt,
    onSceneAt,
    careAt,
    resolvedAt,
    dismissedAt,
    closureNote,
    nextDeadline,
    nextDeadlineLabel,
    updatedAt,
  ];
}

class IncidentInclude extends _is.IncludeObject {
  IncidentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Incident.t;
}

class IncidentIncludeList extends _is.IncludeList {
  IncidentIncludeList._({
    _is.WhereExpressionBuilder<IncidentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Incident.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Incident.t;
}

class IncidentRepository {
  const IncidentRepository._();

  /// Returns a list of [Incident]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Incident>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Incident>(
      where: where?.call(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Incident] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Incident?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Incident>(
      where: where?.call(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Incident] by its [id] or null if no such row exists.
  Future<Incident?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Incident>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Incident]s in the list and returns the inserted rows.
  ///
  /// The returned [Incident]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> insert(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Incident>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Incident] and returns the inserted row.
  ///
  /// The returned [Incident] will have its `id` field set.
  Future<Incident> insertRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Incident>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Incident]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Incident]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> upsert(
    _is.DatabaseSession session,
    List<Incident> rows, {
    required _is.ColumnSelections<IncidentTable> conflictColumns,
    _is.ColumnSelections<IncidentTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Incident>(
      rows,
      conflictColumns: conflictColumns(Incident.t),
      updateColumns: updateColumns?.call(Incident.t),
      updateWhere: updateWhere?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Incident] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Incident] will have its `id` field set.
  Future<Incident?> upsertRow(
    _is.DatabaseSession session,
    Incident row, {
    required _is.ColumnSelections<IncidentTable> conflictColumns,
    _is.ColumnSelections<IncidentTable>? updateColumns,
    _is.WhereExpressionBuilder<IncidentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Incident>(
      row,
      conflictColumns: conflictColumns(Incident.t),
      updateColumns: updateColumns?.call(Incident.t),
      updateWhere: updateWhere?.call(Incident.t),
      transaction: transaction,
    );
  }

  /// Updates all [Incident]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> update(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.ColumnSelections<IncidentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Incident>(
      rows,
      columns: columns?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Incident]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Incident> updateRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.ColumnSelections<IncidentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Incident>(
      row,
      columns: columns?.call(Incident.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Incident] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Incident?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IncidentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Incident>(
      id,
      columnValues: columnValues(Incident.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Incident]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IncidentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<IncidentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Incident>(
      columnValues: columnValues(Incident.t.updateTable),
      where: where(Incident.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Incident]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> delete(
    _is.DatabaseSession session,
    List<Incident> rows, {
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Incident>(
      rows,
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Incident].
  Future<Incident> deleteRow(
    _is.DatabaseSession session,
    Incident row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Incident>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Incident>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentTable> where,
    _is.OrderByBuilder<IncidentTable>? orderBy,
    _is.OrderByListBuilder<IncidentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Incident>(
      where: where(Incident.t),
      orderBy: orderBy?.call(Incident.t),
      orderByList: orderByList?.call(Incident.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IncidentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Incident>(
      where: where?.call(Incident.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Incident] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IncidentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Incident>(
      where: where(Incident.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
