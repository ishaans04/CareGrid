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

/// Kind of place in the campus digital twin.
enum ZoneType implements _is.SerializableModel {
  hostel('Hostel'),
  academic('Academic'),
  lab('Laboratory'),
  libraryHall('Library'),
  sports('Sports'),
  hospital('Hospital'),
  gate('Gate'),
  admin('Administration'),
  commons('Commons'),
  junction('Road junction'),
  outside('Outside campus');

  const ZoneType(this.label);

  final String label;

  static ZoneType fromJson(String name) {
    switch (name) {
      case 'hostel':
        return ZoneType.hostel;
      case 'academic':
        return ZoneType.academic;
      case 'lab':
        return ZoneType.lab;
      case 'libraryHall':
        return ZoneType.libraryHall;
      case 'sports':
        return ZoneType.sports;
      case 'hospital':
        return ZoneType.hospital;
      case 'gate':
        return ZoneType.gate;
      case 'admin':
        return ZoneType.admin;
      case 'commons':
        return ZoneType.commons;
      case 'junction':
        return ZoneType.junction;
      case 'outside':
        return ZoneType.outside;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ZoneType"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
