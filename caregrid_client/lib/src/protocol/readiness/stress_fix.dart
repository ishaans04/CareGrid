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

/// A remedy the Stress-Test Engine tried, and whether the re-run passed with it.
abstract class StressFix
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StressFix._({
    required this.code,
    required this.title,
    required this.detail,
    required this.applicable,
    required this.passesAlone,
  });

  factory StressFix({
    required String code,
    required String title,
    required String detail,
    required bool applicable,
    required bool passesAlone,
  }) = _StressFixImpl;

  factory StressFix.fromJson(Map<String, dynamic> jsonSerialization) {
    return StressFix(
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      detail: jsonSerialization['detail'] as String,
      applicable: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['applicable'],
      ),
      passesAlone: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['passesAlone'],
      ),
    );
  }

  /// Machine code, e.g. gate-override:G4, fallback-responder, open-road:R12.
  String code;

  String title;

  String detail;

  /// The fix can be applied to the live twin from the Readiness Lab.
  bool applicable;

  bool passesAlone;

  /// Returns a shallow copy of this [StressFix]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StressFix copyWith({
    String? code,
    String? title,
    String? detail,
    bool? applicable,
    bool? passesAlone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StressFix',
      'code': code,
      'title': title,
      'detail': detail,
      'applicable': applicable,
      'passesAlone': passesAlone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StressFix',
      'code': code,
      'title': title,
      'detail': detail,
      'applicable': applicable,
      'passesAlone': passesAlone,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StressFixImpl extends StressFix {
  _StressFixImpl({
    required String code,
    required String title,
    required String detail,
    required bool applicable,
    required bool passesAlone,
  }) : super._(
         code: code,
         title: title,
         detail: detail,
         applicable: applicable,
         passesAlone: passesAlone,
       );

  /// Returns a shallow copy of this [StressFix]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StressFix copyWith({
    String? code,
    String? title,
    String? detail,
    bool? applicable,
    bool? passesAlone,
  }) {
    return StressFix(
      code: code ?? this.code,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      applicable: applicable ?? this.applicable,
      passesAlone: passesAlone ?? this.passesAlone,
    );
  }
}
