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

/// Lifecycle state of an incident. Arrival, care and closure are measured states, not assumptions.
enum IncidentState implements _isc.SerializableModel {
  detected('Detected', 0, true),
  review('Needs review', 1, true),
  verified('Verified', 1, true),
  dispatched('Dispatched', 2, true),
  acknowledged('Acknowledged', 3, true),
  enRoute('En route', 4, true),
  onScene('On scene', 5, true),
  care('Care / action', 6, true),
  resolved('Resolved', 7, false),
  dismissed('Dismissed', 7, false);

  const IncidentState(
    this.label,
    this.stage,
    this.open,
  );

  final String label;

  final int stage;

  final bool open;

  static IncidentState fromJson(String name) {
    switch (name) {
      case 'detected':
        return IncidentState.detected;
      case 'review':
        return IncidentState.review;
      case 'verified':
        return IncidentState.verified;
      case 'dispatched':
        return IncidentState.dispatched;
      case 'acknowledged':
        return IncidentState.acknowledged;
      case 'enRoute':
        return IncidentState.enRoute;
      case 'onScene':
        return IncidentState.onScene;
      case 'care':
        return IncidentState.care;
      case 'resolved':
        return IncidentState.resolved;
      case 'dismissed':
        return IncidentState.dismissed;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "IncidentState"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
