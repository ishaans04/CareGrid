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

/// One playback of a seeded emergency scenario through the live pipeline.
abstract class ScenarioRun
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScenarioRun._({
    this.id,
    required this.campusId,
    required this.scenarioCode,
    required this.title,
    required this.startedAt,
    required this.startedBy,
    required this.autopilot,
    required this.status,
    required this.stepsTotal,
    required this.stepsEmitted,
    required this.faults,
  });

  factory ScenarioRun({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String title,
    required DateTime startedAt,
    required String startedBy,
    required bool autopilot,
    required String status,
    required int stepsTotal,
    required int stepsEmitted,
    required List<String> faults,
  }) = _ScenarioRunImpl;

  factory ScenarioRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScenarioRun(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      scenarioCode: jsonSerialization['scenarioCode'] as String,
      title: jsonSerialization['title'] as String,
      startedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      startedBy: jsonSerialization['startedBy'] as String,
      autopilot: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['autopilot'],
      ),
      status: jsonSerialization['status'] as String,
      stepsTotal: jsonSerialization['stepsTotal'] as int,
      stepsEmitted: jsonSerialization['stepsEmitted'] as int,
      faults: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['faults'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  String scenarioCode;

  String title;

  DateTime startedAt;

  String startedBy;

  /// Simulated operator and responders act on their own.
  bool autopilot;

  /// running, completed or stopped.
  String status;

  int stepsTotal;

  int stepsEmitted;

  /// Injected faults, e.g. noAck:AMB-A2.
  List<String> faults;

  /// Returns a shallow copy of this [ScenarioRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ScenarioRun copyWith({
    int? id,
    int? campusId,
    String? scenarioCode,
    String? title,
    DateTime? startedAt,
    String? startedBy,
    bool? autopilot,
    String? status,
    int? stepsTotal,
    int? stepsEmitted,
    List<String>? faults,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScenarioRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'title': title,
      'startedAt': startedAt.toJson(),
      'startedBy': startedBy,
      'autopilot': autopilot,
      'status': status,
      'stepsTotal': stepsTotal,
      'stepsEmitted': stepsEmitted,
      'faults': faults.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScenarioRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'title': title,
      'startedAt': startedAt.toJson(),
      'startedBy': startedBy,
      'autopilot': autopilot,
      'status': status,
      'stepsTotal': stepsTotal,
      'stepsEmitted': stepsEmitted,
      'faults': faults.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScenarioRunImpl extends ScenarioRun {
  _ScenarioRunImpl({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String title,
    required DateTime startedAt,
    required String startedBy,
    required bool autopilot,
    required String status,
    required int stepsTotal,
    required int stepsEmitted,
    required List<String> faults,
  }) : super._(
         id: id,
         campusId: campusId,
         scenarioCode: scenarioCode,
         title: title,
         startedAt: startedAt,
         startedBy: startedBy,
         autopilot: autopilot,
         status: status,
         stepsTotal: stepsTotal,
         stepsEmitted: stepsEmitted,
         faults: faults,
       );

  /// Returns a shallow copy of this [ScenarioRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ScenarioRun copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? scenarioCode,
    String? title,
    DateTime? startedAt,
    String? startedBy,
    bool? autopilot,
    String? status,
    int? stepsTotal,
    int? stepsEmitted,
    List<String>? faults,
  }) {
    return ScenarioRun(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      scenarioCode: scenarioCode ?? this.scenarioCode,
      title: title ?? this.title,
      startedAt: startedAt ?? this.startedAt,
      startedBy: startedBy ?? this.startedBy,
      autopilot: autopilot ?? this.autopilot,
      status: status ?? this.status,
      stepsTotal: stepsTotal ?? this.stepsTotal,
      stepsEmitted: stepsEmitted ?? this.stepsEmitted,
      faults: faults ?? this.faults.map((e0) => e0).toList(),
    );
  }
}
