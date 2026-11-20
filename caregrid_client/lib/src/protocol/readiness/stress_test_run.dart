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
import '../enums/verdict.dart' as _irobyjww;
import '../readiness/stage_estimate.dart' as _ijdzm3ea;
import '../readiness/stress_fix.dart' as _ied9xxny;

/// Report of one stress-test run against the digital twin.
abstract class StressTestRun
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StressTestRun._({
    this.id,
    required this.campusId,
    required this.scenarioCode,
    required this.scenarioName,
    required this.ranAt,
    required this.ranBy,
    required this.verdict,
    required this.predictedSeconds,
    required this.slaSeconds,
    this.policyCode,
    required this.stages,
    required this.responderPlan,
    required this.findings,
    required this.fixes,
    this.verdictAfterFix,
    this.predictedAfterFixSeconds,
    required this.planAfterFix,
  });

  factory StressTestRun({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String scenarioName,
    required DateTime ranAt,
    required String ranBy,
    required _irobyjww.Verdict verdict,
    required int predictedSeconds,
    required int slaSeconds,
    String? policyCode,
    required List<_ijdzm3ea.StageEstimate> stages,
    required List<String> responderPlan,
    required List<String> findings,
    required List<_ied9xxny.StressFix> fixes,
    _irobyjww.Verdict? verdictAfterFix,
    int? predictedAfterFixSeconds,
    required List<String> planAfterFix,
  }) = _StressTestRunImpl;

  factory StressTestRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return StressTestRun(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      scenarioCode: jsonSerialization['scenarioCode'] as String,
      scenarioName: jsonSerialization['scenarioName'] as String,
      ranAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ranAt']),
      ranBy: jsonSerialization['ranBy'] as String,
      verdict: _irobyjww.Verdict.fromJson(
        (jsonSerialization['verdict'] as String),
      ),
      predictedSeconds: jsonSerialization['predictedSeconds'] as int,
      slaSeconds: jsonSerialization['slaSeconds'] as int,
      policyCode: jsonSerialization['policyCode'] as String?,
      stages: _i3n4vhm4.Protocol().deserialize<List<_ijdzm3ea.StageEstimate>>(
        jsonSerialization['stages'],
      ),
      responderPlan: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['responderPlan'],
      ),
      findings: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['findings'],
      ),
      fixes: _i3n4vhm4.Protocol().deserialize<List<_ied9xxny.StressFix>>(
        jsonSerialization['fixes'],
      ),
      verdictAfterFix: jsonSerialization['verdictAfterFix'] == null
          ? null
          : _irobyjww.Verdict.fromJson(
              (jsonSerialization['verdictAfterFix'] as String),
            ),
      predictedAfterFixSeconds:
          jsonSerialization['predictedAfterFixSeconds'] as int?,
      planAfterFix: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['planAfterFix'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  String scenarioCode;

  String scenarioName;

  DateTime ranAt;

  String ranBy;

  _irobyjww.Verdict verdict;

  /// Predicted onset-to-arrival of the slowest required unit.
  int predictedSeconds;

  int slaSeconds;

  String? policyCode;

  List<_ijdzm3ea.StageEstimate> stages;

  List<String> responderPlan;

  List<String> findings;

  List<_ied9xxny.StressFix> fixes;

  /// Verdict when the recommended fixes are applied together.
  _irobyjww.Verdict? verdictAfterFix;

  int? predictedAfterFixSeconds;

  List<String> planAfterFix;

  /// Returns a shallow copy of this [StressTestRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StressTestRun copyWith({
    int? id,
    int? campusId,
    String? scenarioCode,
    String? scenarioName,
    DateTime? ranAt,
    String? ranBy,
    _irobyjww.Verdict? verdict,
    int? predictedSeconds,
    int? slaSeconds,
    String? policyCode,
    List<_ijdzm3ea.StageEstimate>? stages,
    List<String>? responderPlan,
    List<String>? findings,
    List<_ied9xxny.StressFix>? fixes,
    _irobyjww.Verdict? verdictAfterFix,
    int? predictedAfterFixSeconds,
    List<String>? planAfterFix,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StressTestRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'scenarioName': scenarioName,
      'ranAt': ranAt.toJson(),
      'ranBy': ranBy,
      'verdict': verdict.toJson(),
      'predictedSeconds': predictedSeconds,
      'slaSeconds': slaSeconds,
      if (policyCode != null) 'policyCode': policyCode,
      'stages': stages.toJson(valueToJson: (v) => v.toJson()),
      'responderPlan': responderPlan.toJson(),
      'findings': findings.toJson(),
      'fixes': fixes.toJson(valueToJson: (v) => v.toJson()),
      if (verdictAfterFix != null) 'verdictAfterFix': verdictAfterFix?.toJson(),
      if (predictedAfterFixSeconds != null)
        'predictedAfterFixSeconds': predictedAfterFixSeconds,
      'planAfterFix': planAfterFix.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StressTestRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'scenarioName': scenarioName,
      'ranAt': ranAt.toJson(),
      'ranBy': ranBy,
      'verdict': verdict.toJson(),
      'predictedSeconds': predictedSeconds,
      'slaSeconds': slaSeconds,
      if (policyCode != null) 'policyCode': policyCode,
      'stages': stages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'responderPlan': responderPlan.toJson(),
      'findings': findings.toJson(),
      'fixes': fixes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (verdictAfterFix != null) 'verdictAfterFix': verdictAfterFix?.toJson(),
      if (predictedAfterFixSeconds != null)
        'predictedAfterFixSeconds': predictedAfterFixSeconds,
      'planAfterFix': planAfterFix.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StressTestRunImpl extends StressTestRun {
  _StressTestRunImpl({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String scenarioName,
    required DateTime ranAt,
    required String ranBy,
    required _irobyjww.Verdict verdict,
    required int predictedSeconds,
    required int slaSeconds,
    String? policyCode,
    required List<_ijdzm3ea.StageEstimate> stages,
    required List<String> responderPlan,
    required List<String> findings,
    required List<_ied9xxny.StressFix> fixes,
    _irobyjww.Verdict? verdictAfterFix,
    int? predictedAfterFixSeconds,
    required List<String> planAfterFix,
  }) : super._(
         id: id,
         campusId: campusId,
         scenarioCode: scenarioCode,
         scenarioName: scenarioName,
         ranAt: ranAt,
         ranBy: ranBy,
         verdict: verdict,
         predictedSeconds: predictedSeconds,
         slaSeconds: slaSeconds,
         policyCode: policyCode,
         stages: stages,
         responderPlan: responderPlan,
         findings: findings,
         fixes: fixes,
         verdictAfterFix: verdictAfterFix,
         predictedAfterFixSeconds: predictedAfterFixSeconds,
         planAfterFix: planAfterFix,
       );

  /// Returns a shallow copy of this [StressTestRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StressTestRun copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? scenarioCode,
    String? scenarioName,
    DateTime? ranAt,
    String? ranBy,
    _irobyjww.Verdict? verdict,
    int? predictedSeconds,
    int? slaSeconds,
    Object? policyCode = _Undefined,
    List<_ijdzm3ea.StageEstimate>? stages,
    List<String>? responderPlan,
    List<String>? findings,
    List<_ied9xxny.StressFix>? fixes,
    Object? verdictAfterFix = _Undefined,
    Object? predictedAfterFixSeconds = _Undefined,
    List<String>? planAfterFix,
  }) {
    return StressTestRun(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      scenarioCode: scenarioCode ?? this.scenarioCode,
      scenarioName: scenarioName ?? this.scenarioName,
      ranAt: ranAt ?? this.ranAt,
      ranBy: ranBy ?? this.ranBy,
      verdict: verdict ?? this.verdict,
      predictedSeconds: predictedSeconds ?? this.predictedSeconds,
      slaSeconds: slaSeconds ?? this.slaSeconds,
      policyCode: policyCode is String? ? policyCode : this.policyCode,
      stages: stages ?? this.stages.map((e0) => e0.copyWith()).toList(),
      responderPlan:
          responderPlan ?? this.responderPlan.map((e0) => e0).toList(),
      findings: findings ?? this.findings.map((e0) => e0).toList(),
      fixes: fixes ?? this.fixes.map((e0) => e0.copyWith()).toList(),
      verdictAfterFix: verdictAfterFix is _irobyjww.Verdict?
          ? verdictAfterFix
          : this.verdictAfterFix,
      predictedAfterFixSeconds: predictedAfterFixSeconds is int?
          ? predictedAfterFixSeconds
          : this.predictedAfterFixSeconds,
      planAfterFix: planAfterFix ?? this.planAfterFix.map((e0) => e0).toList(),
    );
  }
}
