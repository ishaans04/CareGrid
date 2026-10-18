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

/// Kind of human response unit that can be dispatched.
enum ResponderType implements _isc.SerializableModel {
  securityDesk('Security desk'),
  securityPatrol('Security patrol'),
  ambulance('Ambulance'),
  hospitalEr('Hospital ER team'),
  facilities('Facilities crew'),
  fireSafety('Fire and safety unit');

  const ResponderType(this.label);

  final String label;

  static ResponderType fromJson(String name) {
    switch (name) {
      case 'securityDesk':
        return ResponderType.securityDesk;
      case 'securityPatrol':
        return ResponderType.securityPatrol;
      case 'ambulance':
        return ResponderType.ambulance;
      case 'hospitalEr':
        return ResponderType.hospitalEr;
      case 'facilities':
        return ResponderType.facilities;
      case 'fireSafety':
        return ResponderType.fireSafety;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ResponderType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
