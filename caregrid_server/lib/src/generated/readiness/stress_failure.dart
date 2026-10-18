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
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/stress_failure_kind.dart' as _i6wcqumf;

/// A failure applied to a copy of the digital twin during a stress test.
abstract class StressFailure
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StressFailure._({
    required this.kind,
    required this.target,
  });

  factory StressFailure({
    required _i6wcqumf.StressFailureKind kind,
    required String target,
  }) = _StressFailureImpl;

  factory StressFailure.fromJson(Map<String, dynamic> jsonSerialization) {
    return StressFailure(
      kind: _i6wcqumf.StressFailureKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      target: jsonSerialization['target'] as String,
    );
  }

  _i6wcqumf.StressFailureKind kind;

  /// Responder, gate, road or camera code the failure applies to.
  String target;

  /// Returns a shallow copy of this [StressFailure]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StressFailure copyWith({
    _i6wcqumf.StressFailureKind? kind,
    String? target,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StressFailure',
      'kind': kind.toJson(),
      'target': target,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StressFailure',
      'kind': kind.toJson(),
      'target': target,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StressFailureImpl extends StressFailure {
  _StressFailureImpl({
    required _i6wcqumf.StressFailureKind kind,
    required String target,
  }) : super._(
         kind: kind,
         target: target,
       );

  /// Returns a shallow copy of this [StressFailure]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StressFailure copyWith({
    _i6wcqumf.StressFailureKind? kind,
    String? target,
  }) {
    return StressFailure(
      kind: kind ?? this.kind,
      target: target ?? this.target,
    );
  }
}
