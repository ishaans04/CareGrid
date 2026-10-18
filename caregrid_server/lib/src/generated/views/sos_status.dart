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
import '../enums/incident_state.dart' as _i15vj9fk;

/// What a campus member sees about their own SOS: closed-loop feedback, no other people's data.
abstract class SosStatus
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SosStatus._({
    required this.incidentId,
    required this.code,
    required this.state,
    required this.zoneName,
    required this.raisedAt,
    required this.message,
    required this.responders,
    this.sceneEta,
  });

  factory SosStatus({
    required int incidentId,
    required String code,
    required _i15vj9fk.IncidentState state,
    required String zoneName,
    required DateTime raisedAt,
    required String message,
    required List<String> responders,
    DateTime? sceneEta,
  }) = _SosStatusImpl;

  factory SosStatus.fromJson(Map<String, dynamic> jsonSerialization) {
    return SosStatus(
      incidentId: jsonSerialization['incidentId'] as int,
      code: jsonSerialization['code'] as String,
      state: _i15vj9fk.IncidentState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      zoneName: jsonSerialization['zoneName'] as String,
      raisedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['raisedAt'],
      ),
      message: jsonSerialization['message'] as String,
      responders: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['responders'],
      ),
      sceneEta: jsonSerialization['sceneEta'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['sceneEta']),
    );
  }

  int incidentId;

  String code;

  _i15vj9fk.IncidentState state;

  String zoneName;

  DateTime raisedAt;

  String message;

  List<String> responders;

  DateTime? sceneEta;

  /// Returns a shallow copy of this [SosStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SosStatus copyWith({
    int? incidentId,
    String? code,
    _i15vj9fk.IncidentState? state,
    String? zoneName,
    DateTime? raisedAt,
    String? message,
    List<String>? responders,
    DateTime? sceneEta,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SosStatus',
      'incidentId': incidentId,
      'code': code,
      'state': state.toJson(),
      'zoneName': zoneName,
      'raisedAt': raisedAt.toJson(),
      'message': message,
      'responders': responders.toJson(),
      if (sceneEta != null) 'sceneEta': sceneEta?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SosStatus',
      'incidentId': incidentId,
      'code': code,
      'state': state.toJson(),
      'zoneName': zoneName,
      'raisedAt': raisedAt.toJson(),
      'message': message,
      'responders': responders.toJson(),
      if (sceneEta != null) 'sceneEta': sceneEta?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SosStatusImpl extends SosStatus {
  _SosStatusImpl({
    required int incidentId,
    required String code,
    required _i15vj9fk.IncidentState state,
    required String zoneName,
    required DateTime raisedAt,
    required String message,
    required List<String> responders,
    DateTime? sceneEta,
  }) : super._(
         incidentId: incidentId,
         code: code,
         state: state,
         zoneName: zoneName,
         raisedAt: raisedAt,
         message: message,
         responders: responders,
         sceneEta: sceneEta,
       );

  /// Returns a shallow copy of this [SosStatus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SosStatus copyWith({
    int? incidentId,
    String? code,
    _i15vj9fk.IncidentState? state,
    String? zoneName,
    DateTime? raisedAt,
    String? message,
    List<String>? responders,
    Object? sceneEta = _Undefined,
  }) {
    return SosStatus(
      incidentId: incidentId ?? this.incidentId,
      code: code ?? this.code,
      state: state ?? this.state,
      zoneName: zoneName ?? this.zoneName,
      raisedAt: raisedAt ?? this.raisedAt,
      message: message ?? this.message,
      responders: responders ?? this.responders.map((e0) => e0).toList(),
      sceneEta: sceneEta is DateTime? ? sceneEta : this.sceneEta,
    );
  }
}
