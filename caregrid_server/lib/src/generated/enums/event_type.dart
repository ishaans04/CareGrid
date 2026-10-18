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

/// Observable event reported by a signal. Negative-evidence types argue against an emergency.
enum EventType implements _is.SerializableModel {
  personDown('Person down', false),
  fall('Fall', false),
  prolongedImmobility('Prolonged immobility', false),
  visibleDistress('Visible distress', false),
  sosRequest('SOS request', false),
  smoke('Smoke', false),
  fire('Fire', false),
  crowdSurge('Crowd surge', false),
  vehicleCollision('Vehicle collision', false),
  routeObstruction('Route obstruction', false),
  restrictedEntry('Restricted entry', false),
  flooding('Flooding', false),
  unattendedObject('Unattended object', false),
  personRecovered('Person recovered', true),
  helpArrived('Bystander help arrived', true),
  hazardCleared('Hazard cleared', true),
  reporterCancelled('Reporter cancelled SOS', true);

  const EventType(
    this.label,
    this.negative,
  );

  final String label;

  final bool negative;

  static EventType fromJson(String name) {
    switch (name) {
      case 'personDown':
        return EventType.personDown;
      case 'fall':
        return EventType.fall;
      case 'prolongedImmobility':
        return EventType.prolongedImmobility;
      case 'visibleDistress':
        return EventType.visibleDistress;
      case 'sosRequest':
        return EventType.sosRequest;
      case 'smoke':
        return EventType.smoke;
      case 'fire':
        return EventType.fire;
      case 'crowdSurge':
        return EventType.crowdSurge;
      case 'vehicleCollision':
        return EventType.vehicleCollision;
      case 'routeObstruction':
        return EventType.routeObstruction;
      case 'restrictedEntry':
        return EventType.restrictedEntry;
      case 'flooding':
        return EventType.flooding;
      case 'unattendedObject':
        return EventType.unattendedObject;
      case 'personRecovered':
        return EventType.personRecovered;
      case 'helpArrived':
        return EventType.helpArrived;
      case 'hazardCleared':
        return EventType.hazardCleared;
      case 'reporterCancelled':
        return EventType.reporterCancelled;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "EventType"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
