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

/// Where a campus signal came from.
enum SignalSource implements _is.SerializableModel {
  camera('Camera'),
  sos('SOS app'),
  accessControl('Access control'),
  vehicle('Vehicle telemetry'),
  iotSensor('IoT sensor'),
  operatorReport('Operator');

  const SignalSource(this.label);

  final String label;

  static SignalSource fromJson(String name) {
    switch (name) {
      case 'camera':
        return SignalSource.camera;
      case 'sos':
        return SignalSource.sos;
      case 'accessControl':
        return SignalSource.accessControl;
      case 'vehicle':
        return SignalSource.vehicle;
      case 'iotSensor':
        return SignalSource.iotSensor;
      case 'operatorReport':
        return SignalSource.operatorReport;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SignalSource"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
