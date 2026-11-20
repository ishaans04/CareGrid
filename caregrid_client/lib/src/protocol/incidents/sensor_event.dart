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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../enums/event_type.dart' as _ikhu1dq5;
import '../enums/signal_source.dart' as _ixv6cj1v;

/// A normalized signal from the edge event bus: camera inference, SOS, access control, vehicle or IoT.
abstract class SensorEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SensorEvent._({
    this.id,
    required this.campusId,
    required this.source,
    required this.eventType,
    required this.zoneCode,
    this.cameraCode,
    this.trackId,
    required this.confidence,
    this.detail,
    this.locationDetail,
    required this.observedAt,
    required this.receivedAt,
    this.incidentId,
    this.outcome,
    this.contextHour,
    this.scenarioRunId,
    this.sourceEventId,
  });

  factory SensorEvent({
    int? id,
    required int campusId,
    required _ixv6cj1v.SignalSource source,
    required _ikhu1dq5.EventType eventType,
    required String zoneCode,
    String? cameraCode,
    String? trackId,
    required double confidence,
    String? detail,
    String? locationDetail,
    required DateTime observedAt,
    required DateTime receivedAt,
    int? incidentId,
    String? outcome,
    int? contextHour,
    int? scenarioRunId,
    String? sourceEventId,
  }) = _SensorEventImpl;

  factory SensorEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SensorEvent(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      source: _ixv6cj1v.SignalSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      eventType: _ikhu1dq5.EventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      zoneCode: jsonSerialization['zoneCode'] as String,
      cameraCode: jsonSerialization['cameraCode'] as String?,
      trackId: jsonSerialization['trackId'] as String?,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      detail: jsonSerialization['detail'] as String?,
      locationDetail: jsonSerialization['locationDetail'] as String?,
      observedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['observedAt'],
      ),
      receivedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['receivedAt'],
      ),
      incidentId: jsonSerialization['incidentId'] as int?,
      outcome: jsonSerialization['outcome'] as String?,
      contextHour: jsonSerialization['contextHour'] as int?,
      scenarioRunId: jsonSerialization['scenarioRunId'] as int?,
      sourceEventId: jsonSerialization['sourceEventId'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  _ixv6cj1v.SignalSource source;

  _ikhu1dq5.EventType eventType;

  String zoneCode;

  String? cameraCode;

  String? trackId;

  double confidence;

  String? detail;

  String? locationDetail;

  DateTime observedAt;

  DateTime receivedAt;

  /// Incident this signal created or joined.
  int? incidentId;

  /// What the agent did with the signal, e.g. 'Corroborated INC-1042'.
  String? outcome;

  int? contextHour;

  int? scenarioRunId;

  /// Producer's event id, when supplied. Unique per campus and source.
  String? sourceEventId;

  /// Returns a shallow copy of this [SensorEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SensorEvent copyWith({
    int? id,
    int? campusId,
    _ixv6cj1v.SignalSource? source,
    _ikhu1dq5.EventType? eventType,
    String? zoneCode,
    String? cameraCode,
    String? trackId,
    double? confidence,
    String? detail,
    String? locationDetail,
    DateTime? observedAt,
    DateTime? receivedAt,
    int? incidentId,
    String? outcome,
    int? contextHour,
    int? scenarioRunId,
    String? sourceEventId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SensorEvent',
      if (id != null) 'id': id,
      'campusId': campusId,
      'source': source.toJson(),
      'eventType': eventType.toJson(),
      'zoneCode': zoneCode,
      if (cameraCode != null) 'cameraCode': cameraCode,
      if (trackId != null) 'trackId': trackId,
      'confidence': confidence,
      if (detail != null) 'detail': detail,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'observedAt': observedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      if (incidentId != null) 'incidentId': incidentId,
      if (outcome != null) 'outcome': outcome,
      if (contextHour != null) 'contextHour': contextHour,
      if (scenarioRunId != null) 'scenarioRunId': scenarioRunId,
      if (sourceEventId != null) 'sourceEventId': sourceEventId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SensorEvent',
      if (id != null) 'id': id,
      'campusId': campusId,
      'source': source.toJson(),
      'eventType': eventType.toJson(),
      'zoneCode': zoneCode,
      if (cameraCode != null) 'cameraCode': cameraCode,
      if (trackId != null) 'trackId': trackId,
      'confidence': confidence,
      if (detail != null) 'detail': detail,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'observedAt': observedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      if (incidentId != null) 'incidentId': incidentId,
      if (outcome != null) 'outcome': outcome,
      if (contextHour != null) 'contextHour': contextHour,
      if (scenarioRunId != null) 'scenarioRunId': scenarioRunId,
      if (sourceEventId != null) 'sourceEventId': sourceEventId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SensorEventImpl extends SensorEvent {
  _SensorEventImpl({
    int? id,
    required int campusId,
    required _ixv6cj1v.SignalSource source,
    required _ikhu1dq5.EventType eventType,
    required String zoneCode,
    String? cameraCode,
    String? trackId,
    required double confidence,
    String? detail,
    String? locationDetail,
    required DateTime observedAt,
    required DateTime receivedAt,
    int? incidentId,
    String? outcome,
    int? contextHour,
    int? scenarioRunId,
    String? sourceEventId,
  }) : super._(
         id: id,
         campusId: campusId,
         source: source,
         eventType: eventType,
         zoneCode: zoneCode,
         cameraCode: cameraCode,
         trackId: trackId,
         confidence: confidence,
         detail: detail,
         locationDetail: locationDetail,
         observedAt: observedAt,
         receivedAt: receivedAt,
         incidentId: incidentId,
         outcome: outcome,
         contextHour: contextHour,
         scenarioRunId: scenarioRunId,
         sourceEventId: sourceEventId,
       );

  /// Returns a shallow copy of this [SensorEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SensorEvent copyWith({
    Object? id = _Undefined,
    int? campusId,
    _ixv6cj1v.SignalSource? source,
    _ikhu1dq5.EventType? eventType,
    String? zoneCode,
    Object? cameraCode = _Undefined,
    Object? trackId = _Undefined,
    double? confidence,
    Object? detail = _Undefined,
    Object? locationDetail = _Undefined,
    DateTime? observedAt,
    DateTime? receivedAt,
    Object? incidentId = _Undefined,
    Object? outcome = _Undefined,
    Object? contextHour = _Undefined,
    Object? scenarioRunId = _Undefined,
    Object? sourceEventId = _Undefined,
  }) {
    return SensorEvent(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      source: source ?? this.source,
      eventType: eventType ?? this.eventType,
      zoneCode: zoneCode ?? this.zoneCode,
      cameraCode: cameraCode is String? ? cameraCode : this.cameraCode,
      trackId: trackId is String? ? trackId : this.trackId,
      confidence: confidence ?? this.confidence,
      detail: detail is String? ? detail : this.detail,
      locationDetail: locationDetail is String?
          ? locationDetail
          : this.locationDetail,
      observedAt: observedAt ?? this.observedAt,
      receivedAt: receivedAt ?? this.receivedAt,
      incidentId: incidentId is int? ? incidentId : this.incidentId,
      outcome: outcome is String? ? outcome : this.outcome,
      contextHour: contextHour is int? ? contextHour : this.contextHour,
      scenarioRunId: scenarioRunId is int? ? scenarioRunId : this.scenarioRunId,
      sourceEventId: sourceEventId is String?
          ? sourceEventId
          : this.sourceEventId,
    );
  }
}
