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

/// How well the incident location is covered by working sensors.
enum Observability implements _is.SerializableModel {
  full('Full coverage'),
  degraded('Degraded coverage'),
  blind('Blind spot');

  const Observability(this.label);

  final String label;

  static Observability fromJson(String name) {
    switch (name) {
      case 'full':
        return Observability.full;
      case 'degraded':
        return Observability.degraded;
      case 'blind':
        return Observability.blind;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "Observability"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
