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

/// Payload an edge gateway (or the simulator) sends to ingest one signal.
abstract class SignalInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SignalInput._({
    required this.source,
    required this.eventType,
    required this.zoneCode,
    this.cameraCode,
    this.trackId,
    required this.confidence,
    this.detail,
    this.locationDetail,
    this.contextHour,
    this.eventId,
    this.observedAt,
  });

  factory SignalInput({
    required _ixv6cj1v.SignalSource source,
    required _ikhu1dq5.EventType eventType,
    required String zoneCode,
    String? cameraCode,
    String? trackId,
    required double confidence,
    String? detail,
    String? locationDetail,
    int? contextHour,
    String? eventId,
    DateTime? observedAt,
  }) = _SignalInputImpl;

  factory SignalInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return SignalInput(
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
      contextHour: jsonSerialization['contextHour'] as int?,
      eventId: jsonSerialization['eventId'] as String?,
      observedAt: jsonSerialization['observedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['observedAt'],
            ),
    );
  }

  _ixv6cj1v.SignalSource source;

  _ikhu1dq5.EventType eventType;

  String zoneCode;

  String? cameraCode;

  String? trackId;

  double confidence;

  String? detail;

  String? locationDetail;

  int? contextHour;

  /// Producer's own id for this event. A repeated id from the same campus and source is recognised and ignored, so a network retry can neither open a second incident nor corroborate itself.
  String? eventId;

  /// When the producer observed the event (UTC). Defaults to receipt time; accepted only within the last 24 hours and up to 60 seconds ahead (clock skew).
  DateTime? observedAt;

  /// Returns a shallow copy of this [SignalInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SignalInput copyWith({
    _ixv6cj1v.SignalSource? source,
    _ikhu1dq5.EventType? eventType,
    String? zoneCode,
    String? cameraCode,
    String? trackId,
    double? confidence,
    String? detail,
    String? locationDetail,
    int? contextHour,
    String? eventId,
    DateTime? observedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SignalInput',
      'source': source.toJson(),
      'eventType': eventType.toJson(),
      'zoneCode': zoneCode,
      if (cameraCode != null) 'cameraCode': cameraCode,
      if (trackId != null) 'trackId': trackId,
      'confidence': confidence,
      if (detail != null) 'detail': detail,
      if (locationDetail != null) 'locationDetail': locationDetail,
      if (contextHour != null) 'contextHour': contextHour,
      if (eventId != null) 'eventId': eventId,
      if (observedAt != null) 'observedAt': observedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SignalInput',
      'source': source.toJson(),
      'eventType': eventType.toJson(),
      'zoneCode': zoneCode,
      if (cameraCode != null) 'cameraCode': cameraCode,
      if (trackId != null) 'trackId': trackId,
      'confidence': confidence,
      if (detail != null) 'detail': detail,
      if (locationDetail != null) 'locationDetail': locationDetail,
      if (contextHour != null) 'contextHour': contextHour,
      if (eventId != null) 'eventId': eventId,
      if (observedAt != null) 'observedAt': observedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SignalInputImpl extends SignalInput {
  _SignalInputImpl({
    required _ixv6cj1v.SignalSource source,
    required _ikhu1dq5.EventType eventType,
    required String zoneCode,
    String? cameraCode,
    String? trackId,
    required double confidence,
    String? detail,
    String? locationDetail,
    int? contextHour,
    String? eventId,
    DateTime? observedAt,
  }) : super._(
         source: source,
         eventType: eventType,
         zoneCode: zoneCode,
         cameraCode: cameraCode,
         trackId: trackId,
         confidence: confidence,
         detail: detail,
         locationDetail: locationDetail,
         contextHour: contextHour,
         eventId: eventId,
         observedAt: observedAt,
       );

  /// Returns a shallow copy of this [SignalInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SignalInput copyWith({
    _ixv6cj1v.SignalSource? source,
    _ikhu1dq5.EventType? eventType,
    String? zoneCode,
    Object? cameraCode = _Undefined,
    Object? trackId = _Undefined,
    double? confidence,
    Object? detail = _Undefined,
    Object? locationDetail = _Undefined,
    Object? contextHour = _Undefined,
    Object? eventId = _Undefined,
    Object? observedAt = _Undefined,
  }) {
    return SignalInput(
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
      contextHour: contextHour is int? ? contextHour : this.contextHour,
      eventId: eventId is String? ? eventId : this.eventId,
      observedAt: observedAt is DateTime? ? observedAt : this.observedAt,
    );
  }
}
