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
import '../enums/responder_type.dart' as _iua0ui51;

/// One candidate responder for an incident, with its computed route and ETA.
abstract class PlanOption
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlanOption._({
    required this.responderCode,
    required this.responderName,
    required this.responderType,
    required this.role,
    required this.route,
    required this.routeNames,
    required this.distanceMeters,
    required this.etaSeconds,
    required this.withinSla,
    this.note,
  });

  factory PlanOption({
    required String responderCode,
    required String responderName,
    required _iua0ui51.ResponderType responderType,
    required String role,
    required List<String> route,
    required List<String> routeNames,
    required int distanceMeters,
    required int etaSeconds,
    required bool withinSla,
    String? note,
  }) = _PlanOptionImpl;

  factory PlanOption.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlanOption(
      responderCode: jsonSerialization['responderCode'] as String,
      responderName: jsonSerialization['responderName'] as String,
      responderType: _iua0ui51.ResponderType.fromJson(
        (jsonSerialization['responderType'] as String),
      ),
      role: jsonSerialization['role'] as String,
      route: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['route'],
      ),
      routeNames: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['routeNames'],
      ),
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      etaSeconds: jsonSerialization['etaSeconds'] as int,
      withinSla: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['withinSla'],
      ),
      note: jsonSerialization['note'] as String?,
    );
  }

  String responderCode;

  String responderName;

  _iua0ui51.ResponderType responderType;

  String role;

  List<String> route;

  List<String> routeNames;

  int distanceMeters;

  /// Mobilization plus travel time.
  int etaSeconds;

  bool withinSla;

  String? note;

  /// Returns a shallow copy of this [PlanOption]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlanOption copyWith({
    String? responderCode,
    String? responderName,
    _iua0ui51.ResponderType? responderType,
    String? role,
    List<String>? route,
    List<String>? routeNames,
    int? distanceMeters,
    int? etaSeconds,
    bool? withinSla,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlanOption',
      'responderCode': responderCode,
      'responderName': responderName,
      'responderType': responderType.toJson(),
      'role': role,
      'route': route.toJson(),
      'routeNames': routeNames.toJson(),
      'distanceMeters': distanceMeters,
      'etaSeconds': etaSeconds,
      'withinSla': withinSla,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlanOption',
      'responderCode': responderCode,
      'responderName': responderName,
      'responderType': responderType.toJson(),
      'role': role,
      'route': route.toJson(),
      'routeNames': routeNames.toJson(),
      'distanceMeters': distanceMeters,
      'etaSeconds': etaSeconds,
      'withinSla': withinSla,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlanOptionImpl extends PlanOption {
  _PlanOptionImpl({
    required String responderCode,
    required String responderName,
    required _iua0ui51.ResponderType responderType,
    required String role,
    required List<String> route,
    required List<String> routeNames,
    required int distanceMeters,
    required int etaSeconds,
    required bool withinSla,
    String? note,
  }) : super._(
         responderCode: responderCode,
         responderName: responderName,
         responderType: responderType,
         role: role,
         route: route,
         routeNames: routeNames,
         distanceMeters: distanceMeters,
         etaSeconds: etaSeconds,
         withinSla: withinSla,
         note: note,
       );

  /// Returns a shallow copy of this [PlanOption]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlanOption copyWith({
    String? responderCode,
    String? responderName,
    _iua0ui51.ResponderType? responderType,
    String? role,
    List<String>? route,
    List<String>? routeNames,
    int? distanceMeters,
    int? etaSeconds,
    bool? withinSla,
    Object? note = _Undefined,
  }) {
    return PlanOption(
      responderCode: responderCode ?? this.responderCode,
      responderName: responderName ?? this.responderName,
      responderType: responderType ?? this.responderType,
      role: role ?? this.role,
      route: route ?? this.route.map((e0) => e0).toList(),
      routeNames: routeNames ?? this.routeNames.map((e0) => e0).toList(),
      distanceMeters: distanceMeters ?? this.distanceMeters,
      etaSeconds: etaSeconds ?? this.etaSeconds,
      withinSla: withinSla ?? this.withinSla,
      note: note is String? ? note : this.note,
    );
  }
}
