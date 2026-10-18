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

/// Failure injected into the digital twin by the Stress-Test Engine.
enum StressFailureKind implements _isc.SerializableModel {
  responderBusy('Responder unavailable'),
  gateClosed('Gate unavailable'),
  roadBlocked('Road blocked'),
  cameraDegraded('Camera degraded'),
  cameraOffline('Camera offline');

  const StressFailureKind(this.label);

  final String label;

  static StressFailureKind fromJson(String name) {
    switch (name) {
      case 'responderBusy':
        return StressFailureKind.responderBusy;
      case 'gateClosed':
        return StressFailureKind.gateClosed;
      case 'roadBlocked':
        return StressFailureKind.roadBlocked;
      case 'cameraDegraded':
        return StressFailureKind.cameraDegraded;
      case 'cameraOffline':
        return StressFailureKind.cameraOffline;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "StressFailureKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
