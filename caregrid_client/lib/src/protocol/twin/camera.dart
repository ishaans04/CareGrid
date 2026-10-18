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
    required this.code,
    required this.zoneCode,
    required this.label,
    _ienw8okx.AssetHealth? health,
    required this.adjacentCameras,
    bool? privacyMasked,
  }) : health = health ?? _ienw8okx.AssetHealth.online,
       privacyMasked = privacyMasked ?? true;

  factory Camera({
    int? id,
    required String code,
    required String zoneCode,
    required String label,
    _ienw8okx.AssetHealth? health,
    required List<String> adjacentCameras,
    bool? privacyMasked,
  }) = _CameraImpl;

  factory Camera.fromJson(Map<String, dynamic> jsonSerialization) {
    return Camera(
      id: jsonSerialization['id'] as int?,
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
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String zoneCode;

  String label;

  _ienw8okx.AssetHealth health;

  /// Cameras that can corroborate an event seen by this one.
  List<String> adjacentCameras;

  /// Faces and identities are never processed; masked cameras only emit anonymous track events.
  bool privacyMasked;

  /// Returns a shallow copy of this [Camera]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Camera copyWith({
    int? id,
    String? code,
    String? zoneCode,
    String? label,
    _ienw8okx.AssetHealth? health,
    List<String>? adjacentCameras,
    bool? privacyMasked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Camera',
      if (id != null) 'id': id,
      'code': code,
      'zoneCode': zoneCode,
      'label': label,
      'health': health.toJson(),
      'adjacentCameras': adjacentCameras.toJson(),
      'privacyMasked': privacyMasked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Camera',
      if (id != null) 'id': id,
      'code': code,
      'zoneCode': zoneCode,
      'label': label,
      'health': health.toJson(),
      'adjacentCameras': adjacentCameras.toJson(),
      'privacyMasked': privacyMasked,
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
    required String code,
    required String zoneCode,
    required String label,
    _ienw8okx.AssetHealth? health,
    required List<String> adjacentCameras,
    bool? privacyMasked,
  }) : super._(
         id: id,
         code: code,
         zoneCode: zoneCode,
         label: label,
         health: health,
         adjacentCameras: adjacentCameras,
         privacyMasked: privacyMasked,
       );

  /// Returns a shallow copy of this [Camera]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Camera copyWith({
    Object? id = _Undefined,
    String? code,
    String? zoneCode,
    String? label,
    _ienw8okx.AssetHealth? health,
    List<String>? adjacentCameras,
    bool? privacyMasked,
  }) {
    return Camera(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      zoneCode: zoneCode ?? this.zoneCode,
      label: label ?? this.label,
      health: health ?? this.health,
      adjacentCameras:
          adjacentCameras ?? this.adjacentCameras.map((e0) => e0).toList(),
      privacyMasked: privacyMasked ?? this.privacyMasked,
    );
  }
}
