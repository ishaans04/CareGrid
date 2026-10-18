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
import '../enums/user_role.dart' as _ifev4lwy;

/// A seeded account listed on the sign-in screen of the prototype.
abstract class DemoAccount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DemoAccount._({
    required this.handle,
    required this.displayName,
    required this.role,
    required this.title,
    required this.pinHint,
    required this.description,
  });

  factory DemoAccount({
    required String handle,
    required String displayName,
    required _ifev4lwy.UserRole role,
    required String title,
    required String pinHint,
    required String description,
  }) = _DemoAccountImpl;

  factory DemoAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return DemoAccount(
      handle: jsonSerialization['handle'] as String,
      displayName: jsonSerialization['displayName'] as String,
      role: _ifev4lwy.UserRole.fromJson((jsonSerialization['role'] as String)),
      title: jsonSerialization['title'] as String,
      pinHint: jsonSerialization['pinHint'] as String,
      description: jsonSerialization['description'] as String,
    );
  }

  String handle;

  String displayName;

  _ifev4lwy.UserRole role;

  String title;

  String pinHint;

  String description;

  /// Returns a shallow copy of this [DemoAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DemoAccount copyWith({
    String? handle,
    String? displayName,
    _ifev4lwy.UserRole? role,
    String? title,
    String? pinHint,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DemoAccount',
      'handle': handle,
      'displayName': displayName,
      'role': role.toJson(),
      'title': title,
      'pinHint': pinHint,
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DemoAccount',
      'handle': handle,
      'displayName': displayName,
      'role': role.toJson(),
      'title': title,
      'pinHint': pinHint,
      'description': description,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DemoAccountImpl extends DemoAccount {
  _DemoAccountImpl({
    required String handle,
    required String displayName,
    required _ifev4lwy.UserRole role,
    required String title,
    required String pinHint,
    required String description,
  }) : super._(
         handle: handle,
         displayName: displayName,
         role: role,
         title: title,
         pinHint: pinHint,
         description: description,
       );

  /// Returns a shallow copy of this [DemoAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DemoAccount copyWith({
    String? handle,
    String? displayName,
    _ifev4lwy.UserRole? role,
    String? title,
    String? pinHint,
    String? description,
  }) {
    return DemoAccount(
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      title: title ?? this.title,
      pinHint: pinHint ?? this.pinHint,
      description: description ?? this.description,
    );
  }
}
