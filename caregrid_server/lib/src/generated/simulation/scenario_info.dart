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
import 'package:caregrid_server/src/generated/protocol.dart' as _ighx06pg;
import 'package:serverpod/serverpod.dart' as _is;

/// Catalog entry for a seeded live scenario.
abstract class ScenarioInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ScenarioInfo._({
    required this.code,
    required this.title,
    required this.description,
    required this.expected,
    required this.zoneCode,
    required this.steps,
    required this.faults,
    required this.demonstrates,
  });

  factory ScenarioInfo({
    required String code,
    required String title,
    required String description,
    required String expected,
    required String zoneCode,
    required int steps,
    required List<String> faults,
    required List<String> demonstrates,
  }) = _ScenarioInfoImpl;

  factory ScenarioInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScenarioInfo(
      code: jsonSerialization['code'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      expected: jsonSerialization['expected'] as String,
      zoneCode: jsonSerialization['zoneCode'] as String,
      steps: jsonSerialization['steps'] as int,
      faults: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['faults'],
      ),
      demonstrates: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['demonstrates'],
      ),
    );
  }

  String code;

  String title;

  String description;

  /// What the audience should see happen.
  String expected;

  String zoneCode;

  int steps;

  List<String> faults;

  /// Capability of the platform the scenario demonstrates.
  List<String> demonstrates;

  /// Returns a shallow copy of this [ScenarioInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScenarioInfo copyWith({
    String? code,
    String? title,
    String? description,
    String? expected,
    String? zoneCode,
    int? steps,
    List<String>? faults,
    List<String>? demonstrates,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScenarioInfo',
      'code': code,
      'title': title,
      'description': description,
      'expected': expected,
      'zoneCode': zoneCode,
      'steps': steps,
      'faults': faults.toJson(),
      'demonstrates': demonstrates.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScenarioInfo',
      'code': code,
      'title': title,
      'description': description,
      'expected': expected,
      'zoneCode': zoneCode,
      'steps': steps,
      'faults': faults.toJson(),
      'demonstrates': demonstrates.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ScenarioInfoImpl extends ScenarioInfo {
  _ScenarioInfoImpl({
    required String code,
    required String title,
    required String description,
    required String expected,
    required String zoneCode,
    required int steps,
    required List<String> faults,
    required List<String> demonstrates,
  }) : super._(
         code: code,
         title: title,
         description: description,
         expected: expected,
         zoneCode: zoneCode,
         steps: steps,
         faults: faults,
         demonstrates: demonstrates,
       );

  /// Returns a shallow copy of this [ScenarioInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScenarioInfo copyWith({
    String? code,
    String? title,
    String? description,
    String? expected,
    String? zoneCode,
    int? steps,
    List<String>? faults,
    List<String>? demonstrates,
  }) {
    return ScenarioInfo(
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      expected: expected ?? this.expected,
      zoneCode: zoneCode ?? this.zoneCode,
      steps: steps ?? this.steps,
      faults: faults ?? this.faults.map((e0) => e0).toList(),
      demonstrates: demonstrates ?? this.demonstrates.map((e0) => e0).toList(),
    );
  }
}
