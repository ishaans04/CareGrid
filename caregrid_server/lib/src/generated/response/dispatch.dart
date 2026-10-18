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
import '../enums/dispatch_status.dart' as _inzg8co6;
import '../enums/responder_type.dart' as _iua0ui51;

/// One responder assignment. Proof-of-Response tracks it against an expected trajectory.
abstract class Dispatch
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Dispatch._({
    this.id,
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
      route: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['route'],
      ),
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      etaSeconds: jsonSerialization['etaSeconds'] as int,
      offeredAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['offeredAt'],
      ),
      ackDeadline: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['ackDeadline'],
      ),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      enRouteAt: jsonSerialization['enRouteAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['enRouteAt']),
      arrivalDeadline: jsonSerialization['arrivalDeadline'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['arrivalDeadline'],
            ),
      onSceneAt: jsonSerialization['onSceneAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['onSceneAt']),
      careAt: jsonSerialization['careAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['careAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      progress: (jsonSerialization['progress'] as num?)?.toDouble(),
      arrivalSource: jsonSerialization['arrivalSource'] as String?,
      stalled: jsonSerialization['stalled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['stalled']),
      note: jsonSerialization['note'] as String?,
    );
  }

  static final t = DispatchTable();

  static const db = DispatchRepository._();

  @override
  int? id;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Dispatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Dispatch copyWith({
    int? id,
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

  static DispatchInclude include() {
    return DispatchInclude._();
  }

  static DispatchIncludeList includeList({
    _is.WhereExpressionBuilder<DispatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DispatchTable>? orderBy,
    _is.OrderByListBuilder<DispatchTable>? orderByList,
    DispatchInclude? include,
  }) {
    return DispatchIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Dispatch.t),
      orderByList: orderByList?.call(Dispatch.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DispatchImpl extends Dispatch {
  _DispatchImpl({
    int? id,
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
  @_is.useResult
  @override
  Dispatch copyWith({
    Object? id = _Undefined,
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

class DispatchUpdateTable extends _is.UpdateTable<DispatchTable> {
  DispatchUpdateTable(super.table);

  _is.ColumnValue<int, int> incidentId(int value) => _is.ColumnValue(
    table.incidentId,
    value,
  );

  _is.ColumnValue<String, String> responderCode(String value) =>
      _is.ColumnValue(
        table.responderCode,
        value,
      );

  _is.ColumnValue<String, String> responderName(String value) =>
      _is.ColumnValue(
        table.responderName,
        value,
      );

  _is.ColumnValue<_iua0ui51.ResponderType, _iua0ui51.ResponderType>
  responderType(_iua0ui51.ResponderType value) => _is.ColumnValue(
    table.responderType,
    value,
  );

  _is.ColumnValue<String, String> role(String value) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<_inzg8co6.DispatchStatus, _inzg8co6.DispatchStatus> status(
    _inzg8co6.DispatchStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> route(List<String> value) =>
      _is.ColumnValue(
        table.route,
        value,
      );

  _is.ColumnValue<int, int> distanceMeters(int value) => _is.ColumnValue(
    table.distanceMeters,
    value,
  );

  _is.ColumnValue<int, int> etaSeconds(int value) => _is.ColumnValue(
    table.etaSeconds,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> offeredAt(DateTime value) =>
      _is.ColumnValue(
        table.offeredAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> ackDeadline(DateTime value) =>
      _is.ColumnValue(
        table.ackDeadline,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> acknowledgedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acknowledgedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> enRouteAt(DateTime? value) =>
      _is.ColumnValue(
        table.enRouteAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> arrivalDeadline(DateTime? value) =>
      _is.ColumnValue(
        table.arrivalDeadline,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> onSceneAt(DateTime? value) =>
      _is.ColumnValue(
        table.onSceneAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> careAt(DateTime? value) =>
      _is.ColumnValue(
        table.careAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );

  _is.ColumnValue<double, double> progress(double value) => _is.ColumnValue(
    table.progress,
    value,
  );

  _is.ColumnValue<String, String> arrivalSource(String? value) =>
      _is.ColumnValue(
        table.arrivalSource,
        value,
      );

  _is.ColumnValue<bool, bool> stalled(bool value) => _is.ColumnValue(
    table.stalled,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );
}

class DispatchTable extends _is.Table<int?> {
  DispatchTable({super.tableRelation}) : super(tableName: 'dispatch') {
    updateTable = DispatchUpdateTable(this);
    incidentId = _is.ColumnInt(
      'incidentId',
      this,
    );
    responderCode = _is.ColumnString(
      'responderCode',
      this,
    );
    responderName = _is.ColumnString(
      'responderName',
      this,
    );
    responderType = _is.ColumnEnum(
      'responderType',
      this,
      _is.EnumSerialization.byName,
    );
    role = _is.ColumnString(
      'role',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    route = _is.ColumnSerializable<List<String>>(
      'route',
      this,
    );
    distanceMeters = _is.ColumnInt(
      'distanceMeters',
      this,
    );
    etaSeconds = _is.ColumnInt(
      'etaSeconds',
      this,
    );
    offeredAt = _is.ColumnDateTime(
      'offeredAt',
      this,
    );
    ackDeadline = _is.ColumnDateTime(
      'ackDeadline',
      this,
    );
    acknowledgedAt = _is.ColumnDateTime(
      'acknowledgedAt',
      this,
    );
    enRouteAt = _is.ColumnDateTime(
      'enRouteAt',
      this,
    );
    arrivalDeadline = _is.ColumnDateTime(
      'arrivalDeadline',
      this,
    );
    onSceneAt = _is.ColumnDateTime(
      'onSceneAt',
      this,
    );
    careAt = _is.ColumnDateTime(
      'careAt',
      this,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
    progress = _is.ColumnDouble(
      'progress',
      this,
      hasDefault: true,
    );
    arrivalSource = _is.ColumnString(
      'arrivalSource',
      this,
    );
    stalled = _is.ColumnBool(
      'stalled',
      this,
      hasDefault: true,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
  }

  late final DispatchUpdateTable updateTable;

  late final _is.ColumnInt incidentId;

  late final _is.ColumnString responderCode;

  late final _is.ColumnString responderName;

  late final _is.ColumnEnum<_iua0ui51.ResponderType> responderType;

  /// primary, first-responder, support or fallback.
  late final _is.ColumnString role;

  late final _is.ColumnEnum<_inzg8co6.DispatchStatus> status;

  /// Zone codes from the responder's start to the incident.
  late final _is.ColumnSerializable<List<String>> route;

  late final _is.ColumnInt distanceMeters;

  late final _is.ColumnInt etaSeconds;

  late final _is.ColumnDateTime offeredAt;

  late final _is.ColumnDateTime ackDeadline;

  late final _is.ColumnDateTime acknowledgedAt;

  late final _is.ColumnDateTime enRouteAt;

  late final _is.ColumnDateTime arrivalDeadline;

  late final _is.ColumnDateTime onSceneAt;

  late final _is.ColumnDateTime careAt;

  late final _is.ColumnDateTime completedAt;

  /// 0..1 along the route, from simulated telemetry.
  late final _is.ColumnDouble progress;

  /// geofence or responder: how arrival was verified.
  late final _is.ColumnString arrivalSource;

  late final _is.ColumnBool stalled;

  late final _is.ColumnString note;

  @override
  List<_is.Column> get columns => [
    id,
    incidentId,
    responderCode,
    responderName,
    responderType,
    role,
    status,
    route,
    distanceMeters,
    etaSeconds,
    offeredAt,
    ackDeadline,
    acknowledgedAt,
    enRouteAt,
    arrivalDeadline,
    onSceneAt,
    careAt,
    completedAt,
    progress,
    arrivalSource,
    stalled,
    note,
  ];
}

class DispatchInclude extends _is.IncludeObject {
  DispatchInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Dispatch.t;
}

class DispatchIncludeList extends _is.IncludeList {
  DispatchIncludeList._({
    _is.WhereExpressionBuilder<DispatchTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Dispatch.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Dispatch.t;
}

class DispatchRepository {
  const DispatchRepository._();

  /// Returns a list of [Dispatch]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Dispatch>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DispatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DispatchTable>? orderBy,
    _is.OrderByListBuilder<DispatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Dispatch>(
      where: where?.call(Dispatch.t),
      orderBy: orderBy?.call(Dispatch.t),
      orderByList: orderByList?.call(Dispatch.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Dispatch] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Dispatch?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DispatchTable>? where,
    int? offset,
    _is.OrderByBuilder<DispatchTable>? orderBy,
    _is.OrderByListBuilder<DispatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Dispatch>(
      where: where?.call(Dispatch.t),
      orderBy: orderBy?.call(Dispatch.t),
      orderByList: orderByList?.call(Dispatch.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Dispatch] by its [id] or null if no such row exists.
  Future<Dispatch?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Dispatch>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Dispatch]s in the list and returns the inserted rows.
  ///
  /// The returned [Dispatch]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Dispatch>> insert(
    _is.DatabaseSession session,
    List<Dispatch> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Dispatch>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Dispatch] and returns the inserted row.
  ///
  /// The returned [Dispatch] will have its `id` field set.
  Future<Dispatch> insertRow(
    _is.DatabaseSession session,
    Dispatch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Dispatch>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Dispatch]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Dispatch]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Dispatch>> upsert(
    _is.DatabaseSession session,
    List<Dispatch> rows, {
    required _is.ColumnSelections<DispatchTable> conflictColumns,
    _is.ColumnSelections<DispatchTable>? updateColumns,
    _is.WhereExpressionBuilder<DispatchTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Dispatch>(
      rows,
      conflictColumns: conflictColumns(Dispatch.t),
      updateColumns: updateColumns?.call(Dispatch.t),
      updateWhere: updateWhere?.call(Dispatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Dispatch] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Dispatch] will have its `id` field set.
  Future<Dispatch?> upsertRow(
    _is.DatabaseSession session,
    Dispatch row, {
    required _is.ColumnSelections<DispatchTable> conflictColumns,
    _is.ColumnSelections<DispatchTable>? updateColumns,
    _is.WhereExpressionBuilder<DispatchTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Dispatch>(
      row,
      conflictColumns: conflictColumns(Dispatch.t),
      updateColumns: updateColumns?.call(Dispatch.t),
      updateWhere: updateWhere?.call(Dispatch.t),
      transaction: transaction,
    );
  }

  /// Updates all [Dispatch]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Dispatch>> update(
    _is.DatabaseSession session,
    List<Dispatch> rows, {
    _is.ColumnSelections<DispatchTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Dispatch>(
      rows,
      columns: columns?.call(Dispatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Dispatch]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Dispatch> updateRow(
    _is.DatabaseSession session,
    Dispatch row, {
    _is.ColumnSelections<DispatchTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Dispatch>(
      row,
      columns: columns?.call(Dispatch.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Dispatch] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Dispatch?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DispatchUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Dispatch>(
      id,
      columnValues: columnValues(Dispatch.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Dispatch]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Dispatch>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DispatchUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DispatchTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DispatchTable>? orderBy,
    _is.OrderByListBuilder<DispatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Dispatch>(
      columnValues: columnValues(Dispatch.t.updateTable),
      where: where(Dispatch.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Dispatch.t),
      orderByList: orderByList?.call(Dispatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Dispatch]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Dispatch>> delete(
    _is.DatabaseSession session,
    List<Dispatch> rows, {
    _is.OrderByBuilder<DispatchTable>? orderBy,
    _is.OrderByListBuilder<DispatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Dispatch>(
      rows,
      orderBy: orderBy?.call(Dispatch.t),
      orderByList: orderByList?.call(Dispatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Dispatch].
  Future<Dispatch> deleteRow(
    _is.DatabaseSession session,
    Dispatch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Dispatch>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Dispatch>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DispatchTable> where,
    _is.OrderByBuilder<DispatchTable>? orderBy,
    _is.OrderByListBuilder<DispatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Dispatch>(
      where: where(Dispatch.t),
      orderBy: orderBy?.call(Dispatch.t),
      orderByList: orderByList?.call(Dispatch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DispatchTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Dispatch>(
      where: where?.call(Dispatch.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Dispatch] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DispatchTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Dispatch>(
      where: where(Dispatch.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
