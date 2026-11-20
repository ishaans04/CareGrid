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
import '../enums/asset_health.dart' as _ienw8okx;

/// An existing campus camera used as a sensor. CareGrid integrates cameras; it does not replace them.
abstract class Camera
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Camera._({
    this.id,
    required this.campusId,
    required this.code,
    required this.zoneCode,
    required this.label,
    _ienw8okx.AssetHealth? health,
    required this.adjacentCameras,
    bool? privacyMasked,
    this.x,
    this.y,
    this.rangeMeters,
  }) : health = health ?? _ienw8okx.AssetHealth.online,
       privacyMasked = privacyMasked ?? true;

  factory Camera({
    int? id,
    required int campusId,
    required String code,
    required String zoneCode,
    required String label,
    _ienw8okx.AssetHealth? health,
    required List<String> adjacentCameras,
    bool? privacyMasked,
    double? x,
    double? y,
    double? rangeMeters,
  }) = _CameraImpl;

  factory Camera.fromJson(Map<String, dynamic> jsonSerialization) {
    return Camera(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      code: jsonSerialization['code'] as String,
      zoneCode: jsonSerialization['zoneCode'] as String,
      label: jsonSerialization['label'] as String,
      health: jsonSerialization['health'] == null
          ? null
          : _ienw8okx.AssetHealth.fromJson(
              (jsonSerialization['health'] as String),
            ),
      adjacentCameras: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['adjacentCameras'],
      ),
      privacyMasked: jsonSerialization['privacyMasked'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['privacyMasked']),
      x: (jsonSerialization['x'] as num?)?.toDouble(),
      y: (jsonSerialization['y'] as num?)?.toDouble(),
      rangeMeters: (jsonSerialization['rangeMeters'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  /// Unique within its campus.
  String code;

  String zoneCode;

  String label;

  _ienw8okx.AssetHealth health;

  /// Cameras that can corroborate an event seen by this one.
  List<String> adjacentCameras;

  /// Faces and identities are never processed; masked cameras only emit anonymous track events.
  bool privacyMasked;

  /// Mounting point in canvas units; null places the camera at its zone.
  double? x;

  double? y;

  /// Approximate useful viewing radius in metres, for coverage planning.
  double? rangeMeters;

  /// Returns a shallow copy of this [Camera]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Camera copyWith({
    int? id,
    int? campusId,
    String? code,
    String? zoneCode,
    String? label,
    _ienw8okx.AssetHealth? health,
    List<String>? adjacentCameras,
    bool? privacyMasked,
    double? x,
    double? y,
    double? rangeMeters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Camera',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'zoneCode': zoneCode,
      'label': label,
      'health': health.toJson(),
      'adjacentCameras': adjacentCameras.toJson(),
      'privacyMasked': privacyMasked,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (rangeMeters != null) 'rangeMeters': rangeMeters,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Camera',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'zoneCode': zoneCode,
      'label': label,
      'health': health.toJson(),
      'adjacentCameras': adjacentCameras.toJson(),
      'privacyMasked': privacyMasked,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (rangeMeters != null) 'rangeMeters': rangeMeters,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CameraImpl extends Camera {
  _CameraImpl({
    int? id,
    required int campusId,
    required String code,
    required String zoneCode,
    required String label,
    _ienw8okx.AssetHealth? health,
    required List<String> adjacentCameras,
    bool? privacyMasked,
    double? x,
    double? y,
    double? rangeMeters,
  }) : super._(
         id: id,
         campusId: campusId,
         code: code,
         zoneCode: zoneCode,
         label: label,
         health: health,
         adjacentCameras: adjacentCameras,
         privacyMasked: privacyMasked,
         x: x,
         y: y,
         rangeMeters: rangeMeters,
       );

  /// Returns a shallow copy of this [Camera]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Camera copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? code,
    String? zoneCode,
    String? label,
    _ienw8okx.AssetHealth? health,
    List<String>? adjacentCameras,
    bool? privacyMasked,
    Object? x = _Undefined,
    Object? y = _Undefined,
    Object? rangeMeters = _Undefined,
  }) {
    return Camera(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      code: code ?? this.code,
      zoneCode: zoneCode ?? this.zoneCode,
      label: label ?? this.label,
      health: health ?? this.health,
      adjacentCameras:
          adjacentCameras ?? this.adjacentCameras.map((e0) => e0).toList(),
      privacyMasked: privacyMasked ?? this.privacyMasked,
      x: x is double? ? x : this.x,
      y: y is double? ? y : this.y,
      rangeMeters: rangeMeters is double? ? rangeMeters : this.rangeMeters,
    );
  }
}
