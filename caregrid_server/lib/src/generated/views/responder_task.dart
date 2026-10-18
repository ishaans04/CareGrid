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
import '../enums/severity.dart' as _i55c3ufc;
import '../response/dispatch.dart' as _iq9e3ied;

/// Minimum necessary context for a responder: where, what, how to get there, what to do.
abstract class ResponderTask
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ResponderTask._({
    required this.dispatch,
    required this.incidentCode,
    required this.severity,
    required this.nature,
    required this.zoneName,
    this.locationDetail,
    required this.routeNames,
    required this.instructions,
    required this.hospitalNotified,
    required this.otherResponders,
  });

  factory ResponderTask({
    required _iq9e3ied.Dispatch dispatch,
    required String incidentCode,
    required _i55c3ufc.Severity severity,
    required String nature,
    required String zoneName,
    String? locationDetail,
    required List<String> routeNames,
    required List<String> instructions,
    required bool hospitalNotified,
    required List<String> otherResponders,
  }) = _ResponderTaskImpl;

  factory ResponderTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResponderTask(
      dispatch: _ighx06pg.Protocol().deserialize<_iq9e3ied.Dispatch>(
        jsonSerialization['dispatch'],
      ),
      incidentCode: jsonSerialization['incidentCode'] as String,
      severity: _i55c3ufc.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      nature: jsonSerialization['nature'] as String,
      zoneName: jsonSerialization['zoneName'] as String,
      locationDetail: jsonSerialization['locationDetail'] as String?,
      routeNames: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['routeNames'],
      ),
      instructions: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['instructions'],
      ),
      hospitalNotified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['hospitalNotified'],
      ),
      otherResponders: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['otherResponders'],
      ),
    );
  }

  _iq9e3ied.Dispatch dispatch;

  String incidentCode;

  _i55c3ufc.Severity severity;

  /// Observable nature, never a diagnosis, e.g. 'Possible medical emergency (person down)'.
  String nature;

  String zoneName;

  String? locationDetail;

  List<String> routeNames;

  List<String> instructions;

  bool hospitalNotified;

  List<String> otherResponders;

  /// Returns a shallow copy of this [ResponderTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResponderTask copyWith({
    _iq9e3ied.Dispatch? dispatch,
    String? incidentCode,
    _i55c3ufc.Severity? severity,
    String? nature,
    String? zoneName,
    String? locationDetail,
    List<String>? routeNames,
    List<String>? instructions,
    bool? hospitalNotified,
    List<String>? otherResponders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResponderTask',
      'dispatch': dispatch.toJson(),
      'incidentCode': incidentCode,
      'severity': severity.toJson(),
      'nature': nature,
      'zoneName': zoneName,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'routeNames': routeNames.toJson(),
      'instructions': instructions.toJson(),
      'hospitalNotified': hospitalNotified,
      'otherResponders': otherResponders.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResponderTask',
      'dispatch': dispatch.toJsonForProtocol(),
      'incidentCode': incidentCode,
      'severity': severity.toJson(),
      'nature': nature,
      'zoneName': zoneName,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'routeNames': routeNames.toJson(),
      'instructions': instructions.toJson(),
      'hospitalNotified': hospitalNotified,
      'otherResponders': otherResponders.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponderTaskImpl extends ResponderTask {
  _ResponderTaskImpl({
    required _iq9e3ied.Dispatch dispatch,
    required String incidentCode,
    required _i55c3ufc.Severity severity,
    required String nature,
    required String zoneName,
    String? locationDetail,
    required List<String> routeNames,
    required List<String> instructions,
    required bool hospitalNotified,
    required List<String> otherResponders,
  }) : super._(
         dispatch: dispatch,
         incidentCode: incidentCode,
         severity: severity,
         nature: nature,
         zoneName: zoneName,
         locationDetail: locationDetail,
         routeNames: routeNames,
         instructions: instructions,
         hospitalNotified: hospitalNotified,
         otherResponders: otherResponders,
       );

  /// Returns a shallow copy of this [ResponderTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResponderTask copyWith({
    _iq9e3ied.Dispatch? dispatch,
    String? incidentCode,
    _i55c3ufc.Severity? severity,
    String? nature,
    String? zoneName,
    Object? locationDetail = _Undefined,
    List<String>? routeNames,
    List<String>? instructions,
    bool? hospitalNotified,
    List<String>? otherResponders,
  }) {
    return ResponderTask(
      dispatch: dispatch ?? this.dispatch.copyWith(),
      incidentCode: incidentCode ?? this.incidentCode,
      severity: severity ?? this.severity,
      nature: nature ?? this.nature,
      zoneName: zoneName ?? this.zoneName,
      locationDetail: locationDetail is String?
          ? locationDetail
          : this.locationDetail,
      routeNames: routeNames ?? this.routeNames.map((e0) => e0).toList(),
      instructions: instructions ?? this.instructions.map((e0) => e0).toList(),
      hospitalNotified: hospitalNotified ?? this.hospitalNotified,
      otherResponders:
          otherResponders ?? this.otherResponders.map((e0) => e0).toList(),
    );
  }
}
