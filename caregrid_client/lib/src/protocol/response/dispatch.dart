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
import '../enums/dispatch_status.dart' as _inzg8co6;
import '../enums/responder_type.dart' as _iua0ui51;

/// One responder assignment. Proof-of-Response tracks it against an expected trajectory.
abstract class Dispatch
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Dispatch._({
    this.id,
    required this.campusId,
    required this.incidentId,
    required this.responderCode,
    required this.responderName,
    required this.responderType,
    required this.role,
    required this.status,
    required this.route,
    required this.distanceMeters,
    required this.etaSeconds,
    required this.offeredAt,
    required this.ackDeadline,
    this.acknowledgedAt,
    this.enRouteAt,
    this.arrivalDeadline,
    this.onSceneAt,
    this.careAt,
    this.completedAt,
    double? progress,
    this.arrivalSource,
    bool? stalled,
    this.note,
  }) : progress = progress ?? 0.0,
       stalled = stalled ?? false;

  factory Dispatch({
    int? id,
    required int campusId,
    required int incidentId,
    required String responderCode,
    required String responderName,
    required _iua0ui51.ResponderType responderType,
    required String role,
    required _inzg8co6.DispatchStatus status,
    required List<String> route,
    required int distanceMeters,
    required int etaSeconds,
    required DateTime offeredAt,
    required DateTime ackDeadline,
    DateTime? acknowledgedAt,
    DateTime? enRouteAt,
    DateTime? arrivalDeadline,
    DateTime? onSceneAt,
    DateTime? careAt,
    DateTime? completedAt,
    double? progress,
    String? arrivalSource,
    bool? stalled,
    String? note,
  }) = _DispatchImpl;

  factory Dispatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return Dispatch(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      incidentId: jsonSerialization['incidentId'] as int,
      responderCode: jsonSerialization['responderCode'] as String,
      responderName: jsonSerialization['responderName'] as String,
      responderType: _iua0ui51.ResponderType.fromJson(
        (jsonSerialization['responderType'] as String),
      ),
      role: jsonSerialization['role'] as String,
      status: _inzg8co6.DispatchStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      route: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['route'],
      ),
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      etaSeconds: jsonSerialization['etaSeconds'] as int,
      offeredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['offeredAt'],
      ),
      ackDeadline: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['ackDeadline'],
      ),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      enRouteAt: jsonSerialization['enRouteAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['enRouteAt']),
      arrivalDeadline: jsonSerialization['arrivalDeadline'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['arrivalDeadline'],
            ),
      onSceneAt: jsonSerialization['onSceneAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['onSceneAt']),
      careAt: jsonSerialization['careAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['careAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      progress: (jsonSerialization['progress'] as num?)?.toDouble(),
      arrivalSource: jsonSerialization['arrivalSource'] as String?,
      stalled: jsonSerialization['stalled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['stalled']),
      note: jsonSerialization['note'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campusId;

  int incidentId;

  String responderCode;

  String responderName;

  _iua0ui51.ResponderType responderType;

  /// primary, first-responder, support or fallback.
  String role;

  _inzg8co6.DispatchStatus status;

  /// Zone codes from the responder's start to the incident.
  List<String> route;

  int distanceMeters;

  int etaSeconds;

  DateTime offeredAt;

  DateTime ackDeadline;

  DateTime? acknowledgedAt;

  DateTime? enRouteAt;

  DateTime? arrivalDeadline;

  DateTime? onSceneAt;

  DateTime? careAt;

  DateTime? completedAt;

  /// 0..1 along the route, from simulated telemetry.
  double progress;

  /// geofence or responder: how arrival was verified.
  String? arrivalSource;

  bool stalled;

  String? note;

  /// Returns a shallow copy of this [Dispatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Dispatch copyWith({
    int? id,
    int? campusId,
    int? incidentId,
    String? responderCode,
    String? responderName,
    _iua0ui51.ResponderType? responderType,
    String? role,
    _inzg8co6.DispatchStatus? status,
    List<String>? route,
    int? distanceMeters,
    int? etaSeconds,
    DateTime? offeredAt,
    DateTime? ackDeadline,
    DateTime? acknowledgedAt,
    DateTime? enRouteAt,
    DateTime? arrivalDeadline,
    DateTime? onSceneAt,
    DateTime? careAt,
    DateTime? completedAt,
    double? progress,
    String? arrivalSource,
    bool? stalled,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Dispatch',
      if (id != null) 'id': id,
      'campusId': campusId,
      'incidentId': incidentId,
      'responderCode': responderCode,
      'responderName': responderName,
      'responderType': responderType.toJson(),
      'role': role,
      'status': status.toJson(),
      'route': route.toJson(),
      'distanceMeters': distanceMeters,
      'etaSeconds': etaSeconds,
      'offeredAt': offeredAt.toJson(),
      'ackDeadline': ackDeadline.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (enRouteAt != null) 'enRouteAt': enRouteAt?.toJson(),
      if (arrivalDeadline != null) 'arrivalDeadline': arrivalDeadline?.toJson(),
      if (onSceneAt != null) 'onSceneAt': onSceneAt?.toJson(),
      if (careAt != null) 'careAt': careAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'progress': progress,
      if (arrivalSource != null) 'arrivalSource': arrivalSource,
      'stalled': stalled,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Dispatch',
      if (id != null) 'id': id,
      'campusId': campusId,
      'incidentId': incidentId,
      'responderCode': responderCode,
      'responderName': responderName,
      'responderType': responderType.toJson(),
      'role': role,
      'status': status.toJson(),
      'route': route.toJson(),
      'distanceMeters': distanceMeters,
      'etaSeconds': etaSeconds,
      'offeredAt': offeredAt.toJson(),
      'ackDeadline': ackDeadline.toJson(),
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (enRouteAt != null) 'enRouteAt': enRouteAt?.toJson(),
      if (arrivalDeadline != null) 'arrivalDeadline': arrivalDeadline?.toJson(),
      if (onSceneAt != null) 'onSceneAt': onSceneAt?.toJson(),
      if (careAt != null) 'careAt': careAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'progress': progress,
      if (arrivalSource != null) 'arrivalSource': arrivalSource,
      'stalled': stalled,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DispatchImpl extends Dispatch {
  _DispatchImpl({
    int? id,
    required int campusId,
    required int incidentId,
    required String responderCode,
    required String responderName,
    required _iua0ui51.ResponderType responderType,
    required String role,
    required _inzg8co6.DispatchStatus status,
    required List<String> route,
    required int distanceMeters,
    required int etaSeconds,
    required DateTime offeredAt,
    required DateTime ackDeadline,
    DateTime? acknowledgedAt,
    DateTime? enRouteAt,
    DateTime? arrivalDeadline,
    DateTime? onSceneAt,
    DateTime? careAt,
    DateTime? completedAt,
    double? progress,
    String? arrivalSource,
    bool? stalled,
    String? note,
  }) : super._(
         id: id,
         campusId: campusId,
         incidentId: incidentId,
         responderCode: responderCode,
         responderName: responderName,
         responderType: responderType,
         role: role,
         status: status,
         route: route,
         distanceMeters: distanceMeters,
         etaSeconds: etaSeconds,
         offeredAt: offeredAt,
         ackDeadline: ackDeadline,
         acknowledgedAt: acknowledgedAt,
         enRouteAt: enRouteAt,
         arrivalDeadline: arrivalDeadline,
         onSceneAt: onSceneAt,
         careAt: careAt,
         completedAt: completedAt,
         progress: progress,
         arrivalSource: arrivalSource,
         stalled: stalled,
         note: note,
       );

  /// Returns a shallow copy of this [Dispatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Dispatch copyWith({
    Object? id = _Undefined,
    int? campusId,
    int? incidentId,
    String? responderCode,
    String? responderName,
    _iua0ui51.ResponderType? responderType,
    String? role,
    _inzg8co6.DispatchStatus? status,
    List<String>? route,
    int? distanceMeters,
    int? etaSeconds,
    DateTime? offeredAt,
    DateTime? ackDeadline,
    Object? acknowledgedAt = _Undefined,
    Object? enRouteAt = _Undefined,
    Object? arrivalDeadline = _Undefined,
    Object? onSceneAt = _Undefined,
    Object? careAt = _Undefined,
    Object? completedAt = _Undefined,
    double? progress,
    Object? arrivalSource = _Undefined,
    bool? stalled,
    Object? note = _Undefined,
  }) {
    return Dispatch(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      incidentId: incidentId ?? this.incidentId,
      responderCode: responderCode ?? this.responderCode,
      responderName: responderName ?? this.responderName,
      responderType: responderType ?? this.responderType,
      role: role ?? this.role,
      status: status ?? this.status,
      route: route ?? this.route.map((e0) => e0).toList(),
      distanceMeters: distanceMeters ?? this.distanceMeters,
      etaSeconds: etaSeconds ?? this.etaSeconds,
      offeredAt: offeredAt ?? this.offeredAt,
      ackDeadline: ackDeadline ?? this.ackDeadline,
      acknowledgedAt: acknowledgedAt is DateTime?
          ? acknowledgedAt
          : this.acknowledgedAt,
      enRouteAt: enRouteAt is DateTime? ? enRouteAt : this.enRouteAt,
      arrivalDeadline: arrivalDeadline is DateTime?
          ? arrivalDeadline
          : this.arrivalDeadline,
      onSceneAt: onSceneAt is DateTime? ? onSceneAt : this.onSceneAt,
      careAt: careAt is DateTime? ? careAt : this.careAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      progress: progress ?? this.progress,
      arrivalSource: arrivalSource is String?
          ? arrivalSource
          : this.arrivalSource,
      stalled: stalled ?? this.stalled,
      note: note is String? ? note : this.note,
    );
  }
}
