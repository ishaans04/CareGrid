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
import '../simulation/scenario_info.dart' as _if7zqq4k;
import '../simulation/scenario_run.dart' as _ila38kmx;

/// Simulation lab state: catalog plus recent runs.
abstract class SimulationStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SimulationStatus._({
    required this.scenarios,
    required this.runs,
  });

  factory SimulationStatus({
    required List<_if7zqq4k.ScenarioInfo> scenarios,
    required List<_ila38kmx.ScenarioRun> runs,
  }) = _SimulationStatusImpl;

  factory SimulationStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimulationStatus(
      scenarios: _ighx06pg.Protocol().deserialize<List<_if7zqq4k.ScenarioInfo>>(
        jsonSerialization['scenarios'],
      ),
      runs: _ighx06pg.Protocol().deserialize<List<_ila38kmx.ScenarioRun>>(
        jsonSerialization['runs'],
      ),
    );
  }

  List<_if7zqq4k.ScenarioInfo> scenarios;

  List<_ila38kmx.ScenarioRun> runs;

  /// Returns a shallow copy of this [SimulationStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SimulationStatus copyWith({
    List<_if7zqq4k.ScenarioInfo>? scenarios,
    List<_ila38kmx.ScenarioRun>? runs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SimulationStatus',
      'scenarios': scenarios.toJson(valueToJson: (v) => v.toJson()),
      'runs': runs.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SimulationStatus',
      'scenarios': scenarios.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'runs': runs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SimulationStatusImpl extends SimulationStatus {
  _SimulationStatusImpl({
    required List<_if7zqq4k.ScenarioInfo> scenarios,
    required List<_ila38kmx.ScenarioRun> runs,
  }) : super._(
         scenarios: scenarios,
         runs: runs,
       );

  /// Returns a shallow copy of this [SimulationStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SimulationStatus copyWith({
    List<_if7zqq4k.ScenarioInfo>? scenarios,
    List<_ila38kmx.ScenarioRun>? runs,
  }) {
    return SimulationStatus(
      scenarios:
          scenarios ?? this.scenarios.map((e0) => e0.copyWith()).toList(),
      runs: runs ?? this.runs.map((e0) => e0.copyWith()).toList(),
    );
  }
}
