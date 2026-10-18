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

/// State of one responder assignment, tracked by Proof-of-Response.
enum DispatchStatus implements _is.SerializableModel {
  offered('Offered', true),
  acknowledged('Acknowledged', true),
  enRoute('En route', true),
  onScene('On scene', true),
  care('Care / action', true),
  completed('Completed', false),
  declined('Declined', false),
  timedOut('Timed out', false),
  recalled('Recalled', false);

  const DispatchStatus(
    this.label,
    this.active,
  );

  final String label;

  final bool active;

  static DispatchStatus fromJson(String name) {
    switch (name) {
      case 'offered':
        return DispatchStatus.offered;
      case 'acknowledged':
        return DispatchStatus.acknowledged;
      case 'enRoute':
        return DispatchStatus.enRoute;
      case 'onScene':
        return DispatchStatus.onScene;
      case 'care':
        return DispatchStatus.care;
      case 'completed':
        return DispatchStatus.completed;
      case 'declined':
        return DispatchStatus.declined;
      case 'timedOut':
        return DispatchStatus.timedOut;
      case 'recalled':
        return DispatchStatus.recalled;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DispatchStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
