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

/// Family of observable events. Each family maps to a response domain.
enum EventFamily implements _isc.SerializableModel {
  medical('Human safety / medical'),
  fireHazard('Fire / hazard'),
  mobility('Mobility'),
  access('Access / restriction'),
  environment('Environment'),
  object('Object / asset'),
  crowd('Event / crowd');

  const EventFamily(this.label);

  final String label;

  static EventFamily fromJson(String name) {
    switch (name) {
      case 'medical':
        return EventFamily.medical;
      case 'fireHazard':
        return EventFamily.fireHazard;
      case 'mobility':
        return EventFamily.mobility;
      case 'access':
        return EventFamily.access;
      case 'environment':
        return EventFamily.environment;
      case 'object':
        return EventFamily.object;
      case 'crowd':
        return EventFamily.crowd;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "EventFamily"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
