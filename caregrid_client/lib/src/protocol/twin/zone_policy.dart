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
import '../enums/responder_type.dart' as _iua0ui51;
import '../enums/severity.dart' as _i55c3ufc;
import '../enums/zone_type.dart' as _i7qzwj5g;

/// A site-specific standard operating procedure: what counts as an incident in a zone at a time, and who responds.
abstract class ZonePolicy
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ZonePolicy._({
    this.id,
    required this.campusId,
    required this.code,
    required this.name,
    this.zoneType,
    required this.family,
    this.startHour,
    this.endHour,
    required this.severity,
    required this.minConfidence,
    required this.requireCorroboration,
    required this.autoDispatch,
    required this.notifyHospital,
    required this.responderTypes,
    required this.fallbackTypes,
    required this.verifySlaSeconds,
    required this.ackSlaSeconds,
    required this.arrivalSlaSeconds,
    required this.careSlaSeconds,
    required this.instructions,
  });

  factory ZonePolicy({
    int? id,
    required int campusId,
    required String code,
    required String name,
    _i7qzwj5g.ZoneType? zoneType,
    required _idlnttep.EventFamily family,
    int? startHour,
    int? endHour,
    required _i55c3ufc.Severity severity,
    required double minConfidence,
    required bool requireCorroboration,
    required bool autoDispatch,
    required bool notifyHospital,
    required List<_iua0ui51.ResponderType> responderTypes,
    required List<_iua0ui51.ResponderType> fallbackTypes,
    required int verifySlaSeconds,
    required int ackSlaSeconds,
    required int arrivalSlaSeconds,
    required int careSlaSeconds,
    required List<String> instructions,
  }) = _ZonePolicyImpl;

  factory ZonePolicy.fromJson(Map<String, dynamic> jsonSerialization) {
    return ZonePolicy(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      zoneType: jsonSerialization['zoneType'] == null
          ? null
          : _i7qzwj5g.ZoneType.fromJson(
              (jsonSerialization['zoneType'] as String),
            ),
      family: _idlnttep.EventFamily.fromJson(
        (jsonSerialization['family'] as String),
      ),
      startHour: jsonSerialization['startHour'] as int?,
      endHour: jsonSerialization['endHour'] as int?,
      severity: _i55c3ufc.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      minConfidence: (jsonSerialization['minConfidence'] as num).toDouble(),
      requireCorroboration: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['requireCorroboration'],
      ),
      autoDispatch: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['autoDispatch'],
      ),
      notifyHospital: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['notifyHospital'],
      ),
      responderTypes: _i3n4vhm4.Protocol()
          .deserialize<List<_iua0ui51.ResponderType>>(
            jsonSerialization['responderTypes'],
          ),
      fallbackTypes: _i3n4vhm4.Protocol()
          .deserialize<List<_iua0ui51.ResponderType>>(
            jsonSerialization['fallbackTypes'],
          ),
      verifySlaSeconds: jsonSerialization['verifySlaSeconds'] as int,
      ackSlaSeconds: jsonSerialization['ackSlaSeconds'] as int,
      arrivalSlaSeconds: jsonSerialization['arrivalSlaSeconds'] as int,
      careSlaSeconds: jsonSerialization['careSlaSeconds'] as int,
      instructions: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['instructions'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  String code;

  String name;

  /// Null means the policy applies to every zone type.
  _i7qzwj5g.ZoneType? zoneType;

  _idlnttep.EventFamily family;

  /// Local hour window [startHour, endHour). Wraps past midnight when start > end. Null means all day.
  int? startHour;

  int? endHour;

  _i55c3ufc.Severity severity;

  /// Minimum signal confidence before the agent treats the event as verified.
  double minConfidence;

  /// Require a second camera or sensor (or temporal persistence) before verification.
  bool requireCorroboration;

  /// Dispatch without waiting for operator confirmation (life-safety hazards only).
  bool autoDispatch;

  bool notifyHospital;

  List<_iua0ui51.ResponderType> responderTypes;

  /// Used when no unit of a required type is available.
  List<_iua0ui51.ResponderType> fallbackTypes;

  int verifySlaSeconds;

  int ackSlaSeconds;

  /// Onset-to-arrival target for the first unit of every required type.
  int arrivalSlaSeconds;

  int careSlaSeconds;

  List<String> instructions;

  /// Returns a shallow copy of this [ZonePolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ZonePolicy copyWith({
    int? id,
    int? campusId,
    String? code,
    String? name,
    _i7qzwj5g.ZoneType? zoneType,
    _idlnttep.EventFamily? family,
    int? startHour,
    int? endHour,
    _i55c3ufc.Severity? severity,
    double? minConfidence,
    bool? requireCorroboration,
    bool? autoDispatch,
    bool? notifyHospital,
    List<_iua0ui51.ResponderType>? responderTypes,
    List<_iua0ui51.ResponderType>? fallbackTypes,
    int? verifySlaSeconds,
    int? ackSlaSeconds,
    int? arrivalSlaSeconds,
    int? careSlaSeconds,
    List<String>? instructions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ZonePolicy',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      if (zoneType != null) 'zoneType': zoneType?.toJson(),
      'family': family.toJson(),
      if (startHour != null) 'startHour': startHour,
      if (endHour != null) 'endHour': endHour,
      'severity': severity.toJson(),
      'minConfidence': minConfidence,
      'requireCorroboration': requireCorroboration,
      'autoDispatch': autoDispatch,
      'notifyHospital': notifyHospital,
      'responderTypes': responderTypes.toJson(valueToJson: (v) => v.toJson()),
      'fallbackTypes': fallbackTypes.toJson(valueToJson: (v) => v.toJson()),
      'verifySlaSeconds': verifySlaSeconds,
      'ackSlaSeconds': ackSlaSeconds,
      'arrivalSlaSeconds': arrivalSlaSeconds,
      'careSlaSeconds': careSlaSeconds,
      'instructions': instructions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ZonePolicy',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      if (zoneType != null) 'zoneType': zoneType?.toJson(),
      'family': family.toJson(),
      if (startHour != null) 'startHour': startHour,
      if (endHour != null) 'endHour': endHour,
      'severity': severity.toJson(),
      'minConfidence': minConfidence,
      'requireCorroboration': requireCorroboration,
      'autoDispatch': autoDispatch,
      'notifyHospital': notifyHospital,
      'responderTypes': responderTypes.toJson(valueToJson: (v) => v.toJson()),
      'fallbackTypes': fallbackTypes.toJson(valueToJson: (v) => v.toJson()),
      'verifySlaSeconds': verifySlaSeconds,
      'ackSlaSeconds': ackSlaSeconds,
      'arrivalSlaSeconds': arrivalSlaSeconds,
      'careSlaSeconds': careSlaSeconds,
      'instructions': instructions.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ZonePolicyImpl extends ZonePolicy {
  _ZonePolicyImpl({
    int? id,
    required int campusId,
    required String code,
    required String name,
    _i7qzwj5g.ZoneType? zoneType,
    required _idlnttep.EventFamily family,
    int? startHour,
    int? endHour,
    required _i55c3ufc.Severity severity,
    required double minConfidence,
    required bool requireCorroboration,
    required bool autoDispatch,
    required bool notifyHospital,
    required List<_iua0ui51.ResponderType> responderTypes,
    required List<_iua0ui51.ResponderType> fallbackTypes,
    required int verifySlaSeconds,
    required int ackSlaSeconds,
    required int arrivalSlaSeconds,
    required int careSlaSeconds,
    required List<String> instructions,
  }) : super._(
         id: id,
         campusId: campusId,
         code: code,
         name: name,
         zoneType: zoneType,
         family: family,
         startHour: startHour,
         endHour: endHour,
         severity: severity,
         minConfidence: minConfidence,
         requireCorroboration: requireCorroboration,
         autoDispatch: autoDispatch,
         notifyHospital: notifyHospital,
         responderTypes: responderTypes,
         fallbackTypes: fallbackTypes,
         verifySlaSeconds: verifySlaSeconds,
         ackSlaSeconds: ackSlaSeconds,
         arrivalSlaSeconds: arrivalSlaSeconds,
         careSlaSeconds: careSlaSeconds,
         instructions: instructions,
       );

  /// Returns a shallow copy of this [ZonePolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ZonePolicy copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? code,
    String? name,
    Object? zoneType = _Undefined,
    _idlnttep.EventFamily? family,
    Object? startHour = _Undefined,
    Object? endHour = _Undefined,
    _i55c3ufc.Severity? severity,
    double? minConfidence,
    bool? requireCorroboration,
    bool? autoDispatch,
    bool? notifyHospital,
    List<_iua0ui51.ResponderType>? responderTypes,
    List<_iua0ui51.ResponderType>? fallbackTypes,
    int? verifySlaSeconds,
    int? ackSlaSeconds,
    int? arrivalSlaSeconds,
    int? careSlaSeconds,
    List<String>? instructions,
  }) {
    return ZonePolicy(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      code: code ?? this.code,
      name: name ?? this.name,
      zoneType: zoneType is _i7qzwj5g.ZoneType? ? zoneType : this.zoneType,
      family: family ?? this.family,
      startHour: startHour is int? ? startHour : this.startHour,
      endHour: endHour is int? ? endHour : this.endHour,
      severity: severity ?? this.severity,
      minConfidence: minConfidence ?? this.minConfidence,
      requireCorroboration: requireCorroboration ?? this.requireCorroboration,
      autoDispatch: autoDispatch ?? this.autoDispatch,
      notifyHospital: notifyHospital ?? this.notifyHospital,
      responderTypes:
          responderTypes ?? this.responderTypes.map((e0) => e0).toList(),
      fallbackTypes:
          fallbackTypes ?? this.fallbackTypes.map((e0) => e0).toList(),
      verifySlaSeconds: verifySlaSeconds ?? this.verifySlaSeconds,
      ackSlaSeconds: ackSlaSeconds ?? this.ackSlaSeconds,
      arrivalSlaSeconds: arrivalSlaSeconds ?? this.arrivalSlaSeconds,
      careSlaSeconds: careSlaSeconds ?? this.careSlaSeconds,
      instructions: instructions ?? this.instructions.map((e0) => e0).toList(),
    );
  }
}
