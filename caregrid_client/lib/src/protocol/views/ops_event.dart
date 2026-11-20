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

/// Live push message. Deliberately minimal: clients refetch role-filtered data when they receive it.
abstract class OpsEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OpsEvent._({
    required this.kind,
    this.campusId,
    this.incidentId,
    this.message,
    required this.at,
  });

  factory OpsEvent({
    required String kind,
    int? campusId,
    int? incidentId,
    String? message,
    required DateTime at,
  }) = _OpsEventImpl;

  factory OpsEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsEvent(
      kind: jsonSerialization['kind'] as String,
      campusId: jsonSerialization['campusId'] as int?,
      incidentId: jsonSerialization['incidentId'] as int?,
      message: jsonSerialization['message'] as String?,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  /// incident, dispatch, twin, scenario, readiness or hello.
  String kind;

  /// Campus the change belongs to; streams only deliver a member's own campus.
  int? campusId;

  int? incidentId;

  String? message;

  DateTime at;

  /// Returns a shallow copy of this [OpsEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OpsEvent copyWith({
    String? kind,
    int? campusId,
    int? incidentId,
    String? message,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsEvent',
      'kind': kind,
      if (campusId != null) 'campusId': campusId,
      if (incidentId != null) 'incidentId': incidentId,
      if (message != null) 'message': message,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OpsEvent',
      'kind': kind,
      if (campusId != null) 'campusId': campusId,
      if (incidentId != null) 'incidentId': incidentId,
      if (message != null) 'message': message,
      'at': at.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpsEventImpl extends OpsEvent {
  _OpsEventImpl({
    required String kind,
    int? campusId,
    int? incidentId,
    String? message,
    required DateTime at,
  }) : super._(
         kind: kind,
         campusId: campusId,
         incidentId: incidentId,
         message: message,
         at: at,
       );

  /// Returns a shallow copy of this [OpsEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OpsEvent copyWith({
    String? kind,
    Object? campusId = _Undefined,
    Object? incidentId = _Undefined,
    Object? message = _Undefined,
    DateTime? at,
  }) {
    return OpsEvent(
      kind: kind ?? this.kind,
      campusId: campusId is int? ? campusId : this.campusId,
      incidentId: incidentId is int? ? incidentId : this.incidentId,
      message: message is String? ? message : this.message,
      at: at ?? this.at,
    );
  }
}
