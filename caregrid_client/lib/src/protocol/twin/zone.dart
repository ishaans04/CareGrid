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
import '../enums/zone_type.dart' as _i7qzwj5g;

/// A node of the campus digital twin: a building, a gate, a road junction or a point outside campus.
abstract class Zone
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Zone._({
    this.id,
    required this.campusId,
    required this.code,
    required this.name,
    required this.type,
    required this.x,
    required this.y,
    this.description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
    this.footprint,
    this.levels,
    bool? approximate,
    this.source,
  }) : isOpen = isOpen ?? true,
       emergencyOverride = emergencyOverride ?? false,
       isRestricted = isRestricted ?? false,
       privacySensitive = privacySensitive ?? false,
       approximate = approximate ?? false;

  factory Zone({
    int? id,
    required int campusId,
    required String code,
    required String name,
    required _i7qzwj5g.ZoneType type,
    required double x,
    required double y,
    String? description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
    List<double>? footprint,
    int? levels,
    bool? approximate,
    String? source,
  }) = _ZoneImpl;

  factory Zone.fromJson(Map<String, dynamic> jsonSerialization) {
    return Zone(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      type: _i7qzwj5g.ZoneType.fromJson((jsonSerialization['type'] as String)),
      x: (jsonSerialization['x'] as num).toDouble(),
      y: (jsonSerialization['y'] as num).toDouble(),
      description: jsonSerialization['description'] as String?,
      isOpen: jsonSerialization['isOpen'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
      emergencyOverride: jsonSerialization['emergencyOverride'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['emergencyOverride'],
            ),
      isRestricted: jsonSerialization['isRestricted'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isRestricted']),
      privacySensitive: jsonSerialization['privacySensitive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['privacySensitive'],
            ),
      footprint: jsonSerialization['footprint'] == null
          ? null
          : _i3n4vhm4.Protocol().deserialize<List<double>>(
              jsonSerialization['footprint'],
            ),
      levels: jsonSerialization['levels'] as int?,
      approximate: jsonSerialization['approximate'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['approximate']),
      source: jsonSerialization['source'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  /// Stable short code, unique within its campus, e.g. HB for Birch Hostel.
  String code;

  String name;

  _i7qzwj5g.ZoneType type;

  /// Map position in campus canvas units (see Campus.metersPerUnit).
  double x;

  double y;

  String? description;

  /// Gates only: whether vehicles can pass right now.
  bool isOpen;

  /// Gates only: closed gate that can be remotely opened for emergency vehicles.
  bool emergencyOverride;

  /// Restricted zones (labs, server rooms) trigger access policies.
  bool isRestricted;

  /// Privacy-sensitive zones only expose minimum context to non-command roles.
  bool privacySensitive;

  /// Building outline as flattened x,y canvas pairs; null for a schematic node.
  List<double>? footprint;

  /// Above-ground floors, when known.
  int? levels;

  /// True when the position is a planning assumption rather than mapped data.
  bool approximate;

  /// Where the geometry came from, e.g. 'OpenStreetMap way 351607593'.
  String? source;

  /// Returns a shallow copy of this [Zone]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Zone copyWith({
    int? id,
    int? campusId,
    String? code,
    String? name,
    _i7qzwj5g.ZoneType? type,
    double? x,
    double? y,
    String? description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
    List<double>? footprint,
    int? levels,
    bool? approximate,
    String? source,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Zone',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      'type': type.toJson(),
      'x': x,
      'y': y,
      if (description != null) 'description': description,
      'isOpen': isOpen,
      'emergencyOverride': emergencyOverride,
      'isRestricted': isRestricted,
      'privacySensitive': privacySensitive,
      if (footprint != null) 'footprint': footprint?.toJson(),
      if (levels != null) 'levels': levels,
      'approximate': approximate,
      if (source != null) 'source': source,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Zone',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      'type': type.toJson(),
      'x': x,
      'y': y,
      if (description != null) 'description': description,
      'isOpen': isOpen,
      'emergencyOverride': emergencyOverride,
      'isRestricted': isRestricted,
      'privacySensitive': privacySensitive,
      if (footprint != null) 'footprint': footprint?.toJson(),
      if (levels != null) 'levels': levels,
      'approximate': approximate,
      if (source != null) 'source': source,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ZoneImpl extends Zone {
  _ZoneImpl({
    int? id,
    required int campusId,
    required String code,
    required String name,
    required _i7qzwj5g.ZoneType type,
    required double x,
    required double y,
    String? description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
    List<double>? footprint,
    int? levels,
    bool? approximate,
    String? source,
  }) : super._(
         id: id,
         campusId: campusId,
         code: code,
         name: name,
         type: type,
         x: x,
         y: y,
         description: description,
         isOpen: isOpen,
         emergencyOverride: emergencyOverride,
         isRestricted: isRestricted,
         privacySensitive: privacySensitive,
         footprint: footprint,
         levels: levels,
         approximate: approximate,
         source: source,
       );

  /// Returns a shallow copy of this [Zone]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Zone copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? code,
    String? name,
    _i7qzwj5g.ZoneType? type,
    double? x,
    double? y,
    Object? description = _Undefined,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
    Object? footprint = _Undefined,
    Object? levels = _Undefined,
    bool? approximate,
    Object? source = _Undefined,
  }) {
    return Zone(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      description: description is String? ? description : this.description,
      isOpen: isOpen ?? this.isOpen,
      emergencyOverride: emergencyOverride ?? this.emergencyOverride,
      isRestricted: isRestricted ?? this.isRestricted,
      privacySensitive: privacySensitive ?? this.privacySensitive,
      footprint: footprint is List<double>?
          ? footprint
          : this.footprint?.map((e0) => e0).toList(),
      levels: levels is int? ? levels : this.levels,
      approximate: approximate ?? this.approximate,
      source: source is String? ? source : this.source,
    );
  }
}
