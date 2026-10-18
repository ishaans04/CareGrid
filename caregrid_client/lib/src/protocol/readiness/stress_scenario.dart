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
import 'package:caregrid_client/src/protocol/protocol.dart' as _i3n4vhm4;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../enums/event_type.dart' as _ikhu1dq5;
import '../readiness/stress_failure.dart' as _ia6zsb2k;

/// A compound-failure rehearsal: an emergency plus things going wrong at the same time.
abstract class StressScenario
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StressScenario._({
    this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.zoneCode,
    required this.eventType,
    required this.hour,
    required this.failures,
    bool? builtIn,
  }) : builtIn = builtIn ?? false;

  factory StressScenario({
    int? id,
    required String code,
    required String name,
    required String description,
    required String zoneCode,
    required _ikhu1dq5.EventType eventType,
    required int hour,
    required List<_ia6zsb2k.StressFailure> failures,
    bool? builtIn,
  }) = _StressScenarioImpl;

  factory StressScenario.fromJson(Map<String, dynamic> jsonSerialization) {
    return StressScenario(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      zoneCode: jsonSerialization['zoneCode'] as String,
      eventType: _ikhu1dq5.EventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      hour: jsonSerialization['hour'] as int,
      failures: _i3n4vhm4.Protocol().deserialize<List<_ia6zsb2k.StressFailure>>(
        jsonSerialization['failures'],
      ),
      builtIn: jsonSerialization['builtIn'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['builtIn']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String name;

  String description;

  String zoneCode;

  _ikhu1dq5.EventType eventType;

  /// Local hour the emergency happens at (policies are time-aware).
  int hour;

  List<_ia6zsb2k.StressFailure> failures;

  bool builtIn;

  /// Returns a shallow copy of this [StressScenario]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StressScenario copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    String? zoneCode,
    _ikhu1dq5.EventType? eventType,
    int? hour,
    List<_ia6zsb2k.StressFailure>? failures,
    bool? builtIn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StressScenario',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'description': description,
      'zoneCode': zoneCode,
      'eventType': eventType.toJson(),
      'hour': hour,
      'failures': failures.toJson(valueToJson: (v) => v.toJson()),
      'builtIn': builtIn,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StressScenario',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'description': description,
      'zoneCode': zoneCode,
      'eventType': eventType.toJson(),
      'hour': hour,
      'failures': failures.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'builtIn': builtIn,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StressScenarioImpl extends StressScenario {
  _StressScenarioImpl({
    int? id,
    required String code,
    required String name,
    required String description,
    required String zoneCode,
    required _ikhu1dq5.EventType eventType,
    required int hour,
    required List<_ia6zsb2k.StressFailure> failures,
    bool? builtIn,
  }) : super._(
         id: id,
         code: code,
         name: name,
         description: description,
         zoneCode: zoneCode,
         eventType: eventType,
         hour: hour,
         failures: failures,
         builtIn: builtIn,
       );

  /// Returns a shallow copy of this [StressScenario]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StressScenario copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? description,
    String? zoneCode,
    _ikhu1dq5.EventType? eventType,
    int? hour,
    List<_ia6zsb2k.StressFailure>? failures,
    bool? builtIn,
  }) {
    return StressScenario(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      zoneCode: zoneCode ?? this.zoneCode,
      eventType: eventType ?? this.eventType,
      hour: hour ?? this.hour,
      failures: failures ?? this.failures.map((e0) => e0.copyWith()).toList(),
      builtIn: builtIn ?? this.builtIn,
    );
  }
}
