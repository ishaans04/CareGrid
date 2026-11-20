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
import '../enums/responder_status.dart' as _iyo0md2b;
import '../enums/responder_type.dart' as _iua0ui51;

/// A dispatchable response unit: security desk, patrol, ambulance, ER team, facilities or fire safety.
abstract class Responder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Responder._({
    this.id,
    required this.campusId,
    required this.code,
    required this.name,
    required this.type,
    _iyo0md2b.ResponderStatus? status,
    required this.zoneCode,
    required this.baseZoneCode,
    required this.speedMetersPerMin,
    required this.mobilizationSeconds,
    required this.capabilities,
    required this.contact,
    this.activeDispatchId,
    this.statusNote,
  }) : status = status ?? _iyo0md2b.ResponderStatus.available;

  factory Responder({
    int? id,
    required int campusId,
    required String code,
    required String name,
    required _iua0ui51.ResponderType type,
    _iyo0md2b.ResponderStatus? status,
    required String zoneCode,
    required String baseZoneCode,
    required int speedMetersPerMin,
    required int mobilizationSeconds,
    required List<String> capabilities,
    required String contact,
    int? activeDispatchId,
    String? statusNote,
  }) = _ResponderImpl;

  factory Responder.fromJson(Map<String, dynamic> jsonSerialization) {
    return Responder(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      type: _iua0ui51.ResponderType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      status: jsonSerialization['status'] == null
          ? null
          : _iyo0md2b.ResponderStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      zoneCode: jsonSerialization['zoneCode'] as String,
      baseZoneCode: jsonSerialization['baseZoneCode'] as String,
      speedMetersPerMin: jsonSerialization['speedMetersPerMin'] as int,
      mobilizationSeconds: jsonSerialization['mobilizationSeconds'] as int,
      capabilities: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['capabilities'],
      ),
      contact: jsonSerialization['contact'] as String,
      activeDispatchId: jsonSerialization['activeDispatchId'] as int?,
      statusNote: jsonSerialization['statusNote'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  String code;

  String name;

  _iua0ui51.ResponderType type;

  _iyo0md2b.ResponderStatus status;

  /// Zone the unit is at right now.
  String zoneCode;

  /// Zone the unit returns to after a task.
  String baseZoneCode;

  int speedMetersPerMin;

  /// Time from accepting a task to starting to move.
  int mobilizationSeconds;

  List<String> capabilities;

  String contact;

  int? activeDispatchId;

  /// Note shown when the unit is busy or offline, e.g. 'Inter-hospital transfer'.
  String? statusNote;

  /// Returns a shallow copy of this [Responder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Responder copyWith({
    int? id,
    int? campusId,
    String? code,
    String? name,
    _iua0ui51.ResponderType? type,
    _iyo0md2b.ResponderStatus? status,
    String? zoneCode,
    String? baseZoneCode,
    int? speedMetersPerMin,
    int? mobilizationSeconds,
    List<String>? capabilities,
    String? contact,
    int? activeDispatchId,
    String? statusNote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Responder',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      'type': type.toJson(),
      'status': status.toJson(),
      'zoneCode': zoneCode,
      'baseZoneCode': baseZoneCode,
      'speedMetersPerMin': speedMetersPerMin,
      'mobilizationSeconds': mobilizationSeconds,
      'capabilities': capabilities.toJson(),
      'contact': contact,
      if (activeDispatchId != null) 'activeDispatchId': activeDispatchId,
      if (statusNote != null) 'statusNote': statusNote,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Responder',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      'type': type.toJson(),
      'status': status.toJson(),
      'zoneCode': zoneCode,
      'baseZoneCode': baseZoneCode,
      'speedMetersPerMin': speedMetersPerMin,
      'mobilizationSeconds': mobilizationSeconds,
      'capabilities': capabilities.toJson(),
      'contact': contact,
      if (activeDispatchId != null) 'activeDispatchId': activeDispatchId,
      if (statusNote != null) 'statusNote': statusNote,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponderImpl extends Responder {
  _ResponderImpl({
    int? id,
    required int campusId,
    required String code,
    required String name,
    required _iua0ui51.ResponderType type,
    _iyo0md2b.ResponderStatus? status,
    required String zoneCode,
    required String baseZoneCode,
    required int speedMetersPerMin,
    required int mobilizationSeconds,
    required List<String> capabilities,
    required String contact,
    int? activeDispatchId,
    String? statusNote,
  }) : super._(
         id: id,
         campusId: campusId,
         code: code,
         name: name,
         type: type,
         status: status,
         zoneCode: zoneCode,
         baseZoneCode: baseZoneCode,
         speedMetersPerMin: speedMetersPerMin,
         mobilizationSeconds: mobilizationSeconds,
         capabilities: capabilities,
         contact: contact,
         activeDispatchId: activeDispatchId,
         statusNote: statusNote,
       );

  /// Returns a shallow copy of this [Responder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Responder copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? code,
    String? name,
    _iua0ui51.ResponderType? type,
    _iyo0md2b.ResponderStatus? status,
    String? zoneCode,
    String? baseZoneCode,
    int? speedMetersPerMin,
    int? mobilizationSeconds,
    List<String>? capabilities,
    String? contact,
    Object? activeDispatchId = _Undefined,
    Object? statusNote = _Undefined,
  }) {
    return Responder(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      zoneCode: zoneCode ?? this.zoneCode,
      baseZoneCode: baseZoneCode ?? this.baseZoneCode,
      speedMetersPerMin: speedMetersPerMin ?? this.speedMetersPerMin,
      mobilizationSeconds: mobilizationSeconds ?? this.mobilizationSeconds,
      capabilities: capabilities ?? this.capabilities.map((e0) => e0).toList(),
      contact: contact ?? this.contact,
      activeDispatchId: activeDispatchId is int?
          ? activeDispatchId
          : this.activeDispatchId,
      statusNote: statusNote is String? ? statusNote : this.statusNote,
    );
  }
}
