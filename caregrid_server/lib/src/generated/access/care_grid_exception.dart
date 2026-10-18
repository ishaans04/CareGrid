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

/// Typed error returned to the app, e.g. a role trying an action it is not allowed to perform.
abstract class CareGridException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  CareGridException._({
    required this.message,
    required this.code,
  });

  factory CareGridException({
    required String message,
    required String code,
  }) = _CareGridExceptionImpl;

  factory CareGridException.fromJson(Map<String, dynamic> jsonSerialization) {
    return CareGridException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String,
    );
  }

  String message;

  /// forbidden, notFound, invalidState or badRequest.
  String code;

  /// Returns a shallow copy of this [CareGridException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CareGridException copyWith({
    String? message,
    String? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CareGridException',
      'message': message,
      'code': code,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CareGridException',
      'message': message,
      'code': code,
    };
  }

  @override
  String toString() {
    return 'CareGridException(message: $message, code: $code)';
  }
}

class _CareGridExceptionImpl extends CareGridException {
  _CareGridExceptionImpl({
    required String message,
    required String code,
  }) : super._(
         message: message,
         code: code,
       );

  /// Returns a shallow copy of this [CareGridException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CareGridException copyWith({
    String? message,
    String? code,
  }) {
    return CareGridException(
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }
}
