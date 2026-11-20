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

/// Role of a signed-in CareGrid user. Decides which console and which data the user sees.
enum UserRole implements _is.SerializableModel {
  command('Security / Command'),
  medical('Medical team'),
  responder('Responder'),
  admin('IT / Administration'),
  member('Campus member'),
  network('Network operations');

  const UserRole(this.label);

  final String label;

  static UserRole fromJson(String name) {
    switch (name) {
      case 'command':
        return UserRole.command;
      case 'medical':
        return UserRole.medical;
      case 'responder':
        return UserRole.responder;
      case 'admin':
        return UserRole.admin;
      case 'member':
        return UserRole.member;
      case 'network':
        return UserRole.network;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "UserRole"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
