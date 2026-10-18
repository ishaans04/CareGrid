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
import '../enums/severity.dart' as _i55c3ufc;

/// Hospital / care console row: incoming emergency context, location, ETA and handoff state.
abstract class CareCase
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CareCase._({
    required this.incidentId,
    required this.code,
    required this.severity,
    required this.state,
    required this.nature,
    required this.zoneName,
    this.locationDetail,
    required this.onsetAt,
    required this.handoffState,
    required this.hospitalReady,
    this.ambulanceCode,
    this.ambulanceStatus,
    this.sceneEta,
    required this.responders,
    required this.careNotes,
  });

  factory CareCase({
    required int incidentId,
    required String code,
    required _i55c3ufc.Severity severity,
    required _i15vj9fk.IncidentState state,
    required String nature,
    required String zoneName,
    String? locationDetail,
    required DateTime onsetAt,
    required String handoffState,
    required bool hospitalReady,
    String? ambulanceCode,
    String? ambulanceStatus,
    DateTime? sceneEta,
    required List<String> responders,
    required List<String> careNotes,
  }) = _CareCaseImpl;

  factory CareCase.fromJson(Map<String, dynamic> jsonSerialization) {
    return CareCase(
      incidentId: jsonSerialization['incidentId'] as int,
      code: jsonSerialization['code'] as String,
      severity: _i55c3ufc.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      state: _i15vj9fk.IncidentState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      nature: jsonSerialization['nature'] as String,
      zoneName: jsonSerialization['zoneName'] as String,
      locationDetail: jsonSerialization['locationDetail'] as String?,
      onsetAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['onsetAt']),
      handoffState: jsonSerialization['handoffState'] as String,
      hospitalReady: _is.BoolJsonExtension.fromJson(
        jsonSerialization['hospitalReady'],
      ),
      ambulanceCode: jsonSerialization['ambulanceCode'] as String?,
      ambulanceStatus: jsonSerialization['ambulanceStatus'] as String?,
      sceneEta: jsonSerialization['sceneEta'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['sceneEta']),
      responders: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['responders'],
      ),
      careNotes: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['careNotes'],
      ),
    );
  }

  int incidentId;

  String code;

  _i55c3ufc.Severity severity;

  _i15vj9fk.IncidentState state;

  String nature;

  String zoneName;

  String? locationDetail;

  DateTime onsetAt;

  /// pre-alert, unit en route, on scene, care in progress, handover, closed.
  String handoffState;

  bool hospitalReady;

  String? ambulanceCode;

  String? ambulanceStatus;

  /// Estimated arrival of the first unit at the scene.
  DateTime? sceneEta;

  List<String> responders;

  List<String> careNotes;

  /// Returns a shallow copy of this [CareCase]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CareCase copyWith({
    int? incidentId,
    String? code,
    _i55c3ufc.Severity? severity,
    _i15vj9fk.IncidentState? state,
    String? nature,
    String? zoneName,
    String? locationDetail,
    DateTime? onsetAt,
    String? handoffState,
    bool? hospitalReady,
    String? ambulanceCode,
    String? ambulanceStatus,
    DateTime? sceneEta,
    List<String>? responders,
    List<String>? careNotes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CareCase',
      'incidentId': incidentId,
      'code': code,
      'severity': severity.toJson(),
      'state': state.toJson(),
      'nature': nature,
      'zoneName': zoneName,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'onsetAt': onsetAt.toJson(),
      'handoffState': handoffState,
      'hospitalReady': hospitalReady,
      if (ambulanceCode != null) 'ambulanceCode': ambulanceCode,
      if (ambulanceStatus != null) 'ambulanceStatus': ambulanceStatus,
      if (sceneEta != null) 'sceneEta': sceneEta?.toJson(),
      'responders': responders.toJson(),
      'careNotes': careNotes.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CareCase',
      'incidentId': incidentId,
      'code': code,
      'severity': severity.toJson(),
      'state': state.toJson(),
      'nature': nature,
      'zoneName': zoneName,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'onsetAt': onsetAt.toJson(),
      'handoffState': handoffState,
      'hospitalReady': hospitalReady,
      if (ambulanceCode != null) 'ambulanceCode': ambulanceCode,
      if (ambulanceStatus != null) 'ambulanceStatus': ambulanceStatus,
      if (sceneEta != null) 'sceneEta': sceneEta?.toJson(),
      'responders': responders.toJson(),
      'careNotes': careNotes.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CareCaseImpl extends CareCase {
  _CareCaseImpl({
    required int incidentId,
    required String code,
    required _i55c3ufc.Severity severity,
    required _i15vj9fk.IncidentState state,
    required String nature,
    required String zoneName,
    String? locationDetail,
    required DateTime onsetAt,
    required String handoffState,
    required bool hospitalReady,
    String? ambulanceCode,
    String? ambulanceStatus,
    DateTime? sceneEta,
    required List<String> responders,
    required List<String> careNotes,
  }) : super._(
         incidentId: incidentId,
         code: code,
         severity: severity,
         state: state,
         nature: nature,
         zoneName: zoneName,
         locationDetail: locationDetail,
         onsetAt: onsetAt,
         handoffState: handoffState,
         hospitalReady: hospitalReady,
         ambulanceCode: ambulanceCode,
         ambulanceStatus: ambulanceStatus,
         sceneEta: sceneEta,
         responders: responders,
         careNotes: careNotes,
       );

  /// Returns a shallow copy of this [CareCase]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CareCase copyWith({
    int? incidentId,
    String? code,
    _i55c3ufc.Severity? severity,
    _i15vj9fk.IncidentState? state,
    String? nature,
    String? zoneName,
    Object? locationDetail = _Undefined,
    DateTime? onsetAt,
    String? handoffState,
    bool? hospitalReady,
    Object? ambulanceCode = _Undefined,
    Object? ambulanceStatus = _Undefined,
    Object? sceneEta = _Undefined,
    List<String>? responders,
    List<String>? careNotes,
  }) {
    return CareCase(
      incidentId: incidentId ?? this.incidentId,
      code: code ?? this.code,
      severity: severity ?? this.severity,
      state: state ?? this.state,
      nature: nature ?? this.nature,
      zoneName: zoneName ?? this.zoneName,
      locationDetail: locationDetail is String?
          ? locationDetail
          : this.locationDetail,
      onsetAt: onsetAt ?? this.onsetAt,
      handoffState: handoffState ?? this.handoffState,
      hospitalReady: hospitalReady ?? this.hospitalReady,
      ambulanceCode: ambulanceCode is String?
          ? ambulanceCode
          : this.ambulanceCode,
      ambulanceStatus: ambulanceStatus is String?
          ? ambulanceStatus
          : this.ambulanceStatus,
      sceneEta: sceneEta is DateTime? ? sceneEta : this.sceneEta,
      responders: responders ?? this.responders.map((e0) => e0).toList(),
      careNotes: careNotes ?? this.careNotes.map((e0) => e0).toList(),
    );
  }
}
