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
import '../readiness/stress_test_run.dart' as _i04pf7e3;

/// Campus readiness: how many rehearsed compound failures the current twin survives.
abstract class ReadinessSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReadinessSummary._({
    required this.scorePercent,
    required this.passed,
    required this.total,
    required this.runs,
  });

  factory ReadinessSummary({
    required int scorePercent,
    required int passed,
    required int total,
    required List<_i04pf7e3.StressTestRun> runs,
  }) = _ReadinessSummaryImpl;

  factory ReadinessSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReadinessSummary(
      scorePercent: jsonSerialization['scorePercent'] as int,
      passed: jsonSerialization['passed'] as int,
      total: jsonSerialization['total'] as int,
      runs: _i3n4vhm4.Protocol().deserialize<List<_i04pf7e3.StressTestRun>>(
        jsonSerialization['runs'],
      ),
    );
  }

  int scorePercent;

  int passed;

  int total;

  List<_i04pf7e3.StressTestRun> runs;

  /// Returns a shallow copy of this [ReadinessSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReadinessSummary copyWith({
    int? scorePercent,
    int? passed,
    int? total,
    List<_i04pf7e3.StressTestRun>? runs,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReadinessSummary',
      'scorePercent': scorePercent,
      'passed': passed,
      'total': total,
      'runs': runs.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReadinessSummary',
      'scorePercent': scorePercent,
      'passed': passed,
      'total': total,
      'runs': runs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ReadinessSummaryImpl extends ReadinessSummary {
  _ReadinessSummaryImpl({
    required int scorePercent,
    required int passed,
    required int total,
    required List<_i04pf7e3.StressTestRun> runs,
  }) : super._(
         scorePercent: scorePercent,
         passed: passed,
         total: total,
         runs: runs,
       );

  /// Returns a shallow copy of this [ReadinessSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReadinessSummary copyWith({
    int? scorePercent,
    int? passed,
    int? total,
    List<_i04pf7e3.StressTestRun>? runs,
  }) {
    return ReadinessSummary(
      scorePercent: scorePercent ?? this.scorePercent,
      passed: passed ?? this.passed,
      total: total ?? this.total,
      runs: runs ?? this.runs.map((e0) => e0.copyWith()).toList(),
    );
  }
}
