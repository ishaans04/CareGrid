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
import '../twin/camera.dart' as _i08lb16k;
import '../twin/campus.dart' as _izii60si;
import '../twin/responder.dart' as _inukslo5;
import '../twin/road_segment.dart' as _isekq9yw;
import '../twin/zone.dart' as _ix6vm764;
import '../views/incident_summary.dart' as _ibgq71nj;

/// Snapshot of the campus digital twin for the live map and admin screens.
abstract class CampusTwin
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CampusTwin._({
    required this.campusName,
    required this.campus,
    required this.zones,
    required this.roads,
    required this.cameras,
    required this.responders,
    required this.activeIncidents,
    required this.responderPositions,
  });

  factory CampusTwin({
    required String campusName,
    required _izii60si.Campus campus,
    required List<_ix6vm764.Zone> zones,
    required List<_isekq9yw.RoadSegment> roads,
    required List<_i08lb16k.Camera> cameras,
    required List<_inukslo5.Responder> responders,
    required List<_ibgq71nj.IncidentSummary> activeIncidents,
    required Map<String, String> responderPositions,
  }) = _CampusTwinImpl;

  factory CampusTwin.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusTwin(
      campusName: jsonSerialization['campusName'] as String,
      campus: _ighx06pg.Protocol().deserialize<_izii60si.Campus>(
        jsonSerialization['campus'],
      ),
      zones: _ighx06pg.Protocol().deserialize<List<_ix6vm764.Zone>>(
        jsonSerialization['zones'],
      ),
      roads: _ighx06pg.Protocol().deserialize<List<_isekq9yw.RoadSegment>>(
        jsonSerialization['roads'],
      ),
      cameras: _ighx06pg.Protocol().deserialize<List<_i08lb16k.Camera>>(
        jsonSerialization['cameras'],
      ),
      responders: _ighx06pg.Protocol().deserialize<List<_inukslo5.Responder>>(
        jsonSerialization['responders'],
      ),
      activeIncidents: _ighx06pg.Protocol()
          .deserialize<List<_ibgq71nj.IncidentSummary>>(
            jsonSerialization['activeIncidents'],
          ),
      responderPositions: _ighx06pg.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['responderPositions'],
      ),
    );
  }

  String campusName;

  /// Map frame, attribution and affiliation note of the caller's campus.
  _izii60si.Campus campus;

  List<_ix6vm764.Zone> zones;

  List<_isekq9yw.RoadSegment> roads;

  List<_i08lb16k.Camera> cameras;

  List<_inukslo5.Responder> responders;

  List<_ibgq71nj.IncidentSummary> activeIncidents;

  /// Responder code to zone code it is currently passing through (live telemetry).
  Map<String, String> responderPositions;

  /// Returns a shallow copy of this [CampusTwin]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CampusTwin copyWith({
    String? campusName,
    _izii60si.Campus? campus,
    List<_ix6vm764.Zone>? zones,
    List<_isekq9yw.RoadSegment>? roads,
    List<_i08lb16k.Camera>? cameras,
    List<_inukslo5.Responder>? responders,
    List<_ibgq71nj.IncidentSummary>? activeIncidents,
    Map<String, String>? responderPositions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampusTwin',
      'campusName': campusName,
      'campus': campus.toJson(),
      'zones': zones.toJson(valueToJson: (v) => v.toJson()),
      'roads': roads.toJson(valueToJson: (v) => v.toJson()),
      'cameras': cameras.toJson(valueToJson: (v) => v.toJson()),
      'responders': responders.toJson(valueToJson: (v) => v.toJson()),
      'activeIncidents': activeIncidents.toJson(valueToJson: (v) => v.toJson()),
      'responderPositions': responderPositions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampusTwin',
      'campusName': campusName,
      'campus': campus.toJsonForProtocol(),
      'zones': zones.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'roads': roads.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'cameras': cameras.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'responders': responders.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'activeIncidents': activeIncidents.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'responderPositions': responderPositions.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CampusTwinImpl extends CampusTwin {
  _CampusTwinImpl({
    required String campusName,
    required _izii60si.Campus campus,
    required List<_ix6vm764.Zone> zones,
    required List<_isekq9yw.RoadSegment> roads,
    required List<_i08lb16k.Camera> cameras,
    required List<_inukslo5.Responder> responders,
    required List<_ibgq71nj.IncidentSummary> activeIncidents,
    required Map<String, String> responderPositions,
  }) : super._(
         campusName: campusName,
         campus: campus,
         zones: zones,
         roads: roads,
         cameras: cameras,
         responders: responders,
         activeIncidents: activeIncidents,
         responderPositions: responderPositions,
       );

  /// Returns a shallow copy of this [CampusTwin]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CampusTwin copyWith({
    String? campusName,
    _izii60si.Campus? campus,
    List<_ix6vm764.Zone>? zones,
    List<_isekq9yw.RoadSegment>? roads,
    List<_i08lb16k.Camera>? cameras,
    List<_inukslo5.Responder>? responders,
    List<_ibgq71nj.IncidentSummary>? activeIncidents,
    Map<String, String>? responderPositions,
  }) {
    return CampusTwin(
      campusName: campusName ?? this.campusName,
      campus: campus ?? this.campus.copyWith(),
      zones: zones ?? this.zones.map((e0) => e0.copyWith()).toList(),
      roads: roads ?? this.roads.map((e0) => e0.copyWith()).toList(),
      cameras: cameras ?? this.cameras.map((e0) => e0.copyWith()).toList(),
      responders:
          responders ?? this.responders.map((e0) => e0.copyWith()).toList(),
      activeIncidents:
          activeIncidents ??
          this.activeIncidents.map((e0) => e0.copyWith()).toList(),
      responderPositions:
          responderPositions ??
          this.responderPositions.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
