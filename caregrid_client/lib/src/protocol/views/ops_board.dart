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
import '../views/incident_summary.dart' as _ibgq71nj;

/// The command console's single prioritized queue of owned incidents plus header stats.
abstract class OpsBoard
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  OpsBoard._({
    required this.generatedAt,
    required this.campusName,
    required this.active,
    required this.recent,
    required this.respondersAvailable,
    required this.respondersTotal,
    required this.camerasDegraded,
    required this.camerasTotal,
    required this.escalatedOpen,
  });

  factory OpsBoard({
    required DateTime generatedAt,
    required String campusName,
    required List<_ibgq71nj.IncidentSummary> active,
    required List<_ibgq71nj.IncidentSummary> recent,
    required int respondersAvailable,
    required int respondersTotal,
    required int camerasDegraded,
    required int camerasTotal,
    required int escalatedOpen,
  }) = _OpsBoardImpl;

  factory OpsBoard.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsBoard(
      generatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      campusName: jsonSerialization['campusName'] as String,
      active: _i3n4vhm4.Protocol().deserialize<List<_ibgq71nj.IncidentSummary>>(
        jsonSerialization['active'],
      ),
      recent: _i3n4vhm4.Protocol().deserialize<List<_ibgq71nj.IncidentSummary>>(
        jsonSerialization['recent'],
      ),
      respondersAvailable: jsonSerialization['respondersAvailable'] as int,
      respondersTotal: jsonSerialization['respondersTotal'] as int,
      camerasDegraded: jsonSerialization['camerasDegraded'] as int,
      camerasTotal: jsonSerialization['camerasTotal'] as int,
      escalatedOpen: jsonSerialization['escalatedOpen'] as int,
    );
  }

  DateTime generatedAt;

  String campusName;

  /// Open incidents, most urgent first.
  List<_ibgq71nj.IncidentSummary> active;

  /// Closed in the last 24 hours.
  List<_ibgq71nj.IncidentSummary> recent;

  int respondersAvailable;

  int respondersTotal;

  int camerasDegraded;

  int camerasTotal;

  int escalatedOpen;

  /// Returns a shallow copy of this [OpsBoard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OpsBoard copyWith({
    DateTime? generatedAt,
    String? campusName,
    List<_ibgq71nj.IncidentSummary>? active,
    List<_ibgq71nj.IncidentSummary>? recent,
    int? respondersAvailable,
    int? respondersTotal,
    int? camerasDegraded,
    int? camerasTotal,
    int? escalatedOpen,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsBoard',
      'generatedAt': generatedAt.toJson(),
      'campusName': campusName,
      'active': active.toJson(valueToJson: (v) => v.toJson()),
      'recent': recent.toJson(valueToJson: (v) => v.toJson()),
      'respondersAvailable': respondersAvailable,
      'respondersTotal': respondersTotal,
      'camerasDegraded': camerasDegraded,
      'camerasTotal': camerasTotal,
      'escalatedOpen': escalatedOpen,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OpsBoard',
      'generatedAt': generatedAt.toJson(),
      'campusName': campusName,
      'active': active.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'recent': recent.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'respondersAvailable': respondersAvailable,
      'respondersTotal': respondersTotal,
      'camerasDegraded': camerasDegraded,
      'camerasTotal': camerasTotal,
      'escalatedOpen': escalatedOpen,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _OpsBoardImpl extends OpsBoard {
  _OpsBoardImpl({
    required DateTime generatedAt,
    required String campusName,
    required List<_ibgq71nj.IncidentSummary> active,
    required List<_ibgq71nj.IncidentSummary> recent,
    required int respondersAvailable,
    required int respondersTotal,
    required int camerasDegraded,
    required int camerasTotal,
    required int escalatedOpen,
  }) : super._(
         generatedAt: generatedAt,
         campusName: campusName,
         active: active,
         recent: recent,
         respondersAvailable: respondersAvailable,
         respondersTotal: respondersTotal,
         camerasDegraded: camerasDegraded,
         camerasTotal: camerasTotal,
         escalatedOpen: escalatedOpen,
       );

  /// Returns a shallow copy of this [OpsBoard]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OpsBoard copyWith({
    DateTime? generatedAt,
    String? campusName,
    List<_ibgq71nj.IncidentSummary>? active,
    List<_ibgq71nj.IncidentSummary>? recent,
    int? respondersAvailable,
    int? respondersTotal,
    int? camerasDegraded,
    int? camerasTotal,
    int? escalatedOpen,
  }) {
    return OpsBoard(
      generatedAt: generatedAt ?? this.generatedAt,
      campusName: campusName ?? this.campusName,
      active: active ?? this.active.map((e0) => e0.copyWith()).toList(),
      recent: recent ?? this.recent.map((e0) => e0.copyWith()).toList(),
      respondersAvailable: respondersAvailable ?? this.respondersAvailable,
      respondersTotal: respondersTotal ?? this.respondersTotal,
      camerasDegraded: camerasDegraded ?? this.camerasDegraded,
      camerasTotal: camerasTotal ?? this.camerasTotal,
      escalatedOpen: escalatedOpen ?? this.escalatedOpen,
    );
  }
}
