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

/// Shortest passable route between two zones in the campus graph.
abstract class RoutePlan
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RoutePlan._({
    required this.found,
    required this.route,
    required this.routeNames,
    required this.distanceMeters,
    this.note,
  });

  factory RoutePlan({
    required bool found,
    required List<String> route,
    required List<String> routeNames,
    required int distanceMeters,
    String? note,
  }) = _RoutePlanImpl;

  factory RoutePlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoutePlan(
      found: _isc.BoolJsonExtension.fromJson(jsonSerialization['found']),
      route: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['route'],
      ),
      routeNames: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['routeNames'],
      ),
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      note: jsonSerialization['note'] as String?,
    );
  }

  bool found;

  List<String> route;

  List<String> routeNames;

  int distanceMeters;

  String? note;

  /// Returns a shallow copy of this [RoutePlan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RoutePlan copyWith({
    bool? found,
    List<String>? route,
    List<String>? routeNames,
    int? distanceMeters,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoutePlan',
      'found': found,
      'route': route.toJson(),
      'routeNames': routeNames.toJson(),
      'distanceMeters': distanceMeters,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoutePlan',
      'found': found,
      'route': route.toJson(),
      'routeNames': routeNames.toJson(),
      'distanceMeters': distanceMeters,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoutePlanImpl extends RoutePlan {
  _RoutePlanImpl({
    required bool found,
    required List<String> route,
    required List<String> routeNames,
    required int distanceMeters,
    String? note,
  }) : super._(
         found: found,
         route: route,
         routeNames: routeNames,
         distanceMeters: distanceMeters,
         note: note,
       );

  /// Returns a shallow copy of this [RoutePlan]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RoutePlan copyWith({
    bool? found,
    List<String>? route,
    List<String>? routeNames,
    int? distanceMeters,
    Object? note = _Undefined,
  }) {
    return RoutePlan(
      found: found ?? this.found,
      route: route ?? this.route.map((e0) => e0).toList(),
      routeNames: routeNames ?? this.routeNames.map((e0) => e0).toList(),
      distanceMeters: distanceMeters ?? this.distanceMeters,
      note: note is String? ? note : this.note,
    );
  }
}
