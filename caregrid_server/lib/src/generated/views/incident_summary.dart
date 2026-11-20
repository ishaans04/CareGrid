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

/// Compact incident row for queues, maps and lists.
abstract class IncidentSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IncidentSummary._({
    required this.id,
    required this.code,
    required this.title,
    required this.eventType,
    required this.family,
    required this.severity,
    required this.state,
    required this.zoneCode,
    required this.zoneName,
    this.locationDetail,
    required this.confidence,
    required this.observability,
    required this.escalationLevel,
    required this.needsHumanReview,
    this.nextAction,
    this.nextDeadline,
    this.nextDeadlineLabel,
    required this.onsetAt,
    required this.updatedAt,
    required this.responders,
    required this.unitsAssigned,
    required this.unitsArrived,
    required this.victimCount,
    this.parentIncidentId,
    required this.fromScenario,
  });

  factory IncidentSummary({
    required int id,
    required String code,
    required String title,
    required _ikhu1dq5.EventType eventType,
    required _idlnttep.EventFamily family,
    required _i55c3ufc.Severity severity,
    required _i15vj9fk.IncidentState state,
    required String zoneCode,
    required String zoneName,
    String? locationDetail,
    required double confidence,
    required _iz9xj5p4.Observability observability,
    required int escalationLevel,
    required bool needsHumanReview,
    String? nextAction,
    DateTime? nextDeadline,
    String? nextDeadlineLabel,
    required DateTime onsetAt,
    required DateTime updatedAt,
    required List<String> responders,
    required int unitsAssigned,
    required int unitsArrived,
    required int victimCount,
    int? parentIncidentId,
    required bool fromScenario,
  }) = _IncidentSummaryImpl;

  factory IncidentSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentSummary(
      id: jsonSerialization['id'] as int,
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
      zoneName: jsonSerialization['zoneName'] as String,
      locationDetail: jsonSerialization['locationDetail'] as String?,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      observability: _iz9xj5p4.Observability.fromJson(
        (jsonSerialization['observability'] as String),
      ),
      escalationLevel: jsonSerialization['escalationLevel'] as int,
      needsHumanReview: _is.BoolJsonExtension.fromJson(
        jsonSerialization['needsHumanReview'],
      ),
      nextAction: jsonSerialization['nextAction'] as String?,
      nextDeadline: jsonSerialization['nextDeadline'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextDeadline'],
            ),
      nextDeadlineLabel: jsonSerialization['nextDeadlineLabel'] as String?,
      onsetAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['onsetAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      responders: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['responders'],
      ),
      unitsAssigned: jsonSerialization['unitsAssigned'] as int,
      unitsArrived: jsonSerialization['unitsArrived'] as int,
      victimCount: jsonSerialization['victimCount'] as int,
      parentIncidentId: jsonSerialization['parentIncidentId'] as int?,
      fromScenario: _is.BoolJsonExtension.fromJson(
        jsonSerialization['fromScenario'],
      ),
    );
  }

  int id;

  String code;

  String title;

  _ikhu1dq5.EventType eventType;

  _idlnttep.EventFamily family;

  _i55c3ufc.Severity severity;

  _i15vj9fk.IncidentState state;

  String zoneCode;

  String zoneName;

  String? locationDetail;

  double confidence;

  _iz9xj5p4.Observability observability;

  int escalationLevel;

  bool needsHumanReview;

  String? nextAction;

  DateTime? nextDeadline;

  String? nextDeadlineLabel;

  DateTime onsetAt;

  DateTime updatedAt;

  List<String> responders;

  /// Units committed to the response (excludes declined, timed-out and recalled assignments).
  int unitsAssigned;

  /// Committed units with a recorded arrival. Incident state is the furthest unit; this shows the rest.
  int unitsArrived;

  int victimCount;

  int? parentIncidentId;

  bool fromScenario;

  /// Returns a shallow copy of this [IncidentSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IncidentSummary copyWith({
    int? id,
    String? code,
    String? title,
    _ikhu1dq5.EventType? eventType,
    _idlnttep.EventFamily? family,
    _i55c3ufc.Severity? severity,
    _i15vj9fk.IncidentState? state,
    String? zoneCode,
    String? zoneName,
    String? locationDetail,
    double? confidence,
    _iz9xj5p4.Observability? observability,
    int? escalationLevel,
    bool? needsHumanReview,
    String? nextAction,
    DateTime? nextDeadline,
    String? nextDeadlineLabel,
    DateTime? onsetAt,
    DateTime? updatedAt,
    List<String>? responders,
    int? unitsAssigned,
    int? unitsArrived,
    int? victimCount,
    int? parentIncidentId,
    bool? fromScenario,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentSummary',
      'id': id,
      'code': code,
      'title': title,
      'eventType': eventType.toJson(),
      'family': family.toJson(),
      'severity': severity.toJson(),
      'state': state.toJson(),
      'zoneCode': zoneCode,
      'zoneName': zoneName,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'confidence': confidence,
      'observability': observability.toJson(),
      'escalationLevel': escalationLevel,
      'needsHumanReview': needsHumanReview,
      if (nextAction != null) 'nextAction': nextAction,
      if (nextDeadline != null) 'nextDeadline': nextDeadline?.toJson(),
      if (nextDeadlineLabel != null) 'nextDeadlineLabel': nextDeadlineLabel,
      'onsetAt': onsetAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'responders': responders.toJson(),
      'unitsAssigned': unitsAssigned,
      'unitsArrived': unitsArrived,
      'victimCount': victimCount,
      if (parentIncidentId != null) 'parentIncidentId': parentIncidentId,
      'fromScenario': fromScenario,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentSummary',
      'id': id,
      'code': code,
      'title': title,
      'eventType': eventType.toJson(),
      'family': family.toJson(),
      'severity': severity.toJson(),
      'state': state.toJson(),
      'zoneCode': zoneCode,
      'zoneName': zoneName,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'confidence': confidence,
      'observability': observability.toJson(),
      'escalationLevel': escalationLevel,
      'needsHumanReview': needsHumanReview,
      if (nextAction != null) 'nextAction': nextAction,
      if (nextDeadline != null) 'nextDeadline': nextDeadline?.toJson(),
      if (nextDeadlineLabel != null) 'nextDeadlineLabel': nextDeadlineLabel,
      'onsetAt': onsetAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'responders': responders.toJson(),
      'unitsAssigned': unitsAssigned,
      'unitsArrived': unitsArrived,
      'victimCount': victimCount,
      if (parentIncidentId != null) 'parentIncidentId': parentIncidentId,
      'fromScenario': fromScenario,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentSummaryImpl extends IncidentSummary {
  _IncidentSummaryImpl({
    required int id,
    required String code,
    required String title,
    required _ikhu1dq5.EventType eventType,
    required _idlnttep.EventFamily family,
    required _i55c3ufc.Severity severity,
    required _i15vj9fk.IncidentState state,
    required String zoneCode,
    required String zoneName,
    String? locationDetail,
    required double confidence,
    required _iz9xj5p4.Observability observability,
    required int escalationLevel,
    required bool needsHumanReview,
    String? nextAction,
    DateTime? nextDeadline,
    String? nextDeadlineLabel,
    required DateTime onsetAt,
    required DateTime updatedAt,
    required List<String> responders,
    required int unitsAssigned,
    required int unitsArrived,
    required int victimCount,
    int? parentIncidentId,
    required bool fromScenario,
  }) : super._(
         id: id,
         code: code,
         title: title,
         eventType: eventType,
         family: family,
         severity: severity,
         state: state,
         zoneCode: zoneCode,
         zoneName: zoneName,
         locationDetail: locationDetail,
         confidence: confidence,
         observability: observability,
         escalationLevel: escalationLevel,
         needsHumanReview: needsHumanReview,
         nextAction: nextAction,
         nextDeadline: nextDeadline,
         nextDeadlineLabel: nextDeadlineLabel,
         onsetAt: onsetAt,
         updatedAt: updatedAt,
         responders: responders,
         unitsAssigned: unitsAssigned,
         unitsArrived: unitsArrived,
         victimCount: victimCount,
         parentIncidentId: parentIncidentId,
         fromScenario: fromScenario,
       );

  /// Returns a shallow copy of this [IncidentSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IncidentSummary copyWith({
    int? id,
    String? code,
    String? title,
    _ikhu1dq5.EventType? eventType,
    _idlnttep.EventFamily? family,
    _i55c3ufc.Severity? severity,
    _i15vj9fk.IncidentState? state,
    String? zoneCode,
    String? zoneName,
    Object? locationDetail = _Undefined,
    double? confidence,
    _iz9xj5p4.Observability? observability,
    int? escalationLevel,
    bool? needsHumanReview,
    Object? nextAction = _Undefined,
    Object? nextDeadline = _Undefined,
    Object? nextDeadlineLabel = _Undefined,
    DateTime? onsetAt,
    DateTime? updatedAt,
    List<String>? responders,
    int? unitsAssigned,
    int? unitsArrived,
    int? victimCount,
    Object? parentIncidentId = _Undefined,
    bool? fromScenario,
  }) {
    return IncidentSummary(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      eventType: eventType ?? this.eventType,
      family: family ?? this.family,
      severity: severity ?? this.severity,
      state: state ?? this.state,
      zoneCode: zoneCode ?? this.zoneCode,
      zoneName: zoneName ?? this.zoneName,
      locationDetail: locationDetail is String?
          ? locationDetail
          : this.locationDetail,
      confidence: confidence ?? this.confidence,
      observability: observability ?? this.observability,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      needsHumanReview: needsHumanReview ?? this.needsHumanReview,
      nextAction: nextAction is String? ? nextAction : this.nextAction,
      nextDeadline: nextDeadline is DateTime?
          ? nextDeadline
          : this.nextDeadline,
      nextDeadlineLabel: nextDeadlineLabel is String?
          ? nextDeadlineLabel
          : this.nextDeadlineLabel,
      onsetAt: onsetAt ?? this.onsetAt,
      updatedAt: updatedAt ?? this.updatedAt,
      responders: responders ?? this.responders.map((e0) => e0).toList(),
      unitsAssigned: unitsAssigned ?? this.unitsAssigned,
      unitsArrived: unitsArrived ?? this.unitsArrived,
      victimCount: victimCount ?? this.victimCount,
      parentIncidentId: parentIncidentId is int?
          ? parentIncidentId
          : this.parentIncidentId,
      fromScenario: fromScenario ?? this.fromScenario,
    );
  }
}
