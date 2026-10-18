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

/// Incident priority. Lower rank is more urgent.
enum Severity implements _is.SerializableModel {
  p0('P0 Critical', 0),
  p1('P1 Urgent', 1),
  p2('P2 High', 2),
  p3('P3 Routine', 3);

  const Severity(
    this.label,
    this.rank,
  );

  final String label;

  final int rank;

  static Severity fromJson(String name) {
    switch (name) {
      case 'p0':
        return Severity.p0;
      case 'p1':
        return Severity.p1;
      case 'p2':
        return Severity.p2;
      case 'p3':
        return Severity.p3;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "Severity"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
