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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Latency of one response stage, predicted (stress test) or measured (analytics).
abstract class StageEstimate
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StageEstimate._({
    required this.label,
    required this.seconds,
    this.note,
  });

  factory StageEstimate({
    required String label,
    required double seconds,
    String? note,
  }) = _StageEstimateImpl;

  factory StageEstimate.fromJson(Map<String, dynamic> jsonSerialization) {
    return StageEstimate(
      label: jsonSerialization['label'] as String,
      seconds: (jsonSerialization['seconds'] as num).toDouble(),
      note: jsonSerialization['note'] as String?,
    );
  }

  String label;

  double seconds;

  String? note;

  /// Returns a shallow copy of this [StageEstimate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StageEstimate copyWith({
    String? label,
    double? seconds,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StageEstimate',
      'label': label,
      'seconds': seconds,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StageEstimate',
      'label': label,
      'seconds': seconds,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StageEstimateImpl extends StageEstimate {
  _StageEstimateImpl({
    required String label,
    required double seconds,
    String? note,
  }) : super._(
         label: label,
         seconds: seconds,
         note: note,
       );

  /// Returns a shallow copy of this [StageEstimate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StageEstimate copyWith({
    String? label,
    double? seconds,
    Object? note = _Undefined,
  }) {
    return StageEstimate(
      label: label ?? this.label,
      seconds: seconds ?? this.seconds,
      note: note is String? ? note : this.note,
    );
  }
}
