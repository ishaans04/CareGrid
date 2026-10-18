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
import '../response/plan_option.dart' as _iswy3tjt;

/// The response the orchestrator recommends: best unit per required type plus warnings.
abstract class ResponsePlan
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ResponsePlan._({
    required this.options,
    required this.alternatives,
    required this.warnings,
    required this.arrivalSlaSeconds,
  });

  factory ResponsePlan({
    required List<_iswy3tjt.PlanOption> options,
    required List<_iswy3tjt.PlanOption> alternatives,
    required List<String> warnings,
    required int arrivalSlaSeconds,
  }) = _ResponsePlanImpl;

  factory ResponsePlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResponsePlan(
      options: _ighx06pg.Protocol().deserialize<List<_iswy3tjt.PlanOption>>(
        jsonSerialization['options'],
      ),
      alternatives: _ighx06pg.Protocol()
          .deserialize<List<_iswy3tjt.PlanOption>>(
            jsonSerialization['alternatives'],
          ),
      warnings: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['warnings'],
      ),
      arrivalSlaSeconds: jsonSerialization['arrivalSlaSeconds'] as int,
    );
  }

  List<_iswy3tjt.PlanOption> options;

  /// Alternatives the operator can pick instead of the recommendation.
  List<_iswy3tjt.PlanOption> alternatives;

  List<String> warnings;

  int arrivalSlaSeconds;

  /// Returns a shallow copy of this [ResponsePlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResponsePlan copyWith({
    List<_iswy3tjt.PlanOption>? options,
    List<_iswy3tjt.PlanOption>? alternatives,
    List<String>? warnings,
    int? arrivalSlaSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResponsePlan',
      'options': options.toJson(valueToJson: (v) => v.toJson()),
      'alternatives': alternatives.toJson(valueToJson: (v) => v.toJson()),
      'warnings': warnings.toJson(),
      'arrivalSlaSeconds': arrivalSlaSeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResponsePlan',
      'options': options.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'alternatives': alternatives.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'warnings': warnings.toJson(),
      'arrivalSlaSeconds': arrivalSlaSeconds,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ResponsePlanImpl extends ResponsePlan {
  _ResponsePlanImpl({
    required List<_iswy3tjt.PlanOption> options,
    required List<_iswy3tjt.PlanOption> alternatives,
    required List<String> warnings,
    required int arrivalSlaSeconds,
  }) : super._(
         options: options,
         alternatives: alternatives,
         warnings: warnings,
         arrivalSlaSeconds: arrivalSlaSeconds,
       );

  /// Returns a shallow copy of this [ResponsePlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResponsePlan copyWith({
    List<_iswy3tjt.PlanOption>? options,
    List<_iswy3tjt.PlanOption>? alternatives,
    List<String>? warnings,
    int? arrivalSlaSeconds,
  }) {
    return ResponsePlan(
      options: options ?? this.options.map((e0) => e0.copyWith()).toList(),
      alternatives:
          alternatives ?? this.alternatives.map((e0) => e0.copyWith()).toList(),
      warnings: warnings ?? this.warnings.map((e0) => e0).toList(),
      arrivalSlaSeconds: arrivalSlaSeconds ?? this.arrivalSlaSeconds,
    );
  }
}
