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

/// A seeded CareGrid user. The prototype signs in with handle + PIN; production would use campus SSO.
abstract class AppUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppUser._({
    this.id,
    required this.handle,
    required this.displayName,
    required this.role,
    required this.title,
    this.responderCode,
  });

  factory AppUser({
    int? id,
    required String handle,
    required String displayName,
    required _ifev4lwy.UserRole role,
    required String title,
    String? responderCode,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      handle: jsonSerialization['handle'] as String,
      displayName: jsonSerialization['displayName'] as String,
      role: _ifev4lwy.UserRole.fromJson((jsonSerialization['role'] as String)),
      title: jsonSerialization['title'] as String,
      responderCode: jsonSerialization['responderCode'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String handle;

  String displayName;

  _ifev4lwy.UserRole role;

  /// Job title shown in the UI, e.g. 'Night shift command operator'.
  String title;

  /// Responder unit this user operates (responder role only).
  String? responderCode;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppUser copyWith({
    int? id,
    String? handle,
    String? displayName,
    _ifev4lwy.UserRole? role,
    String? title,
    String? responderCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'handle': handle,
      'displayName': displayName,
      'role': role.toJson(),
      'title': title,
      if (responderCode != null) 'responderCode': responderCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'handle': handle,
      'displayName': displayName,
      'role': role.toJson(),
      'title': title,
      if (responderCode != null) 'responderCode': responderCode,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String handle,
    required String displayName,
    required _ifev4lwy.UserRole role,
    required String title,
    String? responderCode,
  }) : super._(
         id: id,
         handle: handle,
         displayName: displayName,
         role: role,
         title: title,
         responderCode: responderCode,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? handle,
    String? displayName,
    _ifev4lwy.UserRole? role,
    String? title,
    Object? responderCode = _Undefined,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      title: title ?? this.title,
      responderCode: responderCode is String?
          ? responderCode
          : this.responderCode,
    );
  }
}
