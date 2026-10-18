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
import '../access/app_user.dart' as _i3449lmd;

/// Returned by a successful sign-in.
abstract class SignInResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SignInResult._({
    required this.token,
    required this.user,
    required this.expiresAt,
  });

  factory SignInResult({
    required String token,
    required _i3449lmd.AppUser user,
    required DateTime expiresAt,
  }) = _SignInResultImpl;

  factory SignInResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SignInResult(
      token: jsonSerialization['token'] as String,
      user: _i3n4vhm4.Protocol().deserialize<_i3449lmd.AppUser>(
        jsonSerialization['user'],
      ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  String token;

  _i3449lmd.AppUser user;

  DateTime expiresAt;

  /// Returns a shallow copy of this [SignInResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SignInResult copyWith({
    String? token,
    _i3449lmd.AppUser? user,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SignInResult',
      'token': token,
      'user': user.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SignInResult',
      'token': token,
      'user': user.toJsonForProtocol(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SignInResultImpl extends SignInResult {
  _SignInResultImpl({
    required String token,
    required _i3449lmd.AppUser user,
    required DateTime expiresAt,
  }) : super._(
         token: token,
         user: user,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [SignInResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SignInResult copyWith({
    String? token,
    _i3449lmd.AppUser? user,
    DateTime? expiresAt,
  }) {
    return SignInResult(
      token: token ?? this.token,
      user: user ?? this.user.copyWith(),
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
