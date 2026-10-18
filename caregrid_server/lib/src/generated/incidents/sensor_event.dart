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
import '../enums/event_type.dart' as _ikhu1dq5;
import '../enums/signal_source.dart' as _ixv6cj1v;

/// A normalized signal from the edge event bus: camera inference, SOS, access control, vehicle or IoT.
abstract class SensorEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SensorEvent._({
    this.id,
    required this.source,
    required this.eventType,
    required this.zoneCode,
    this.cameraCode,
    this.trackId,
    required this.confidence,
    this.detail,
    this.locationDetail,
    required this.observedAt,
    required this.receivedAt,
    this.incidentId,
    this.outcome,
    this.contextHour,
    this.scenarioRunId,
    this.reporterUserId,
  });

  factory SensorEvent({
    int? id,
    required _ixv6cj1v.SignalSource source,
    required _ikhu1dq5.EventType eventType,
    required String zoneCode,
    String? cameraCode,
    String? trackId,
    required double confidence,
    String? detail,
    String? locationDetail,
    required DateTime observedAt,
    required DateTime receivedAt,
    int? incidentId,
    String? outcome,
    int? contextHour,
    int? scenarioRunId,
    int? reporterUserId,
  }) = _SensorEventImpl;

  factory SensorEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SensorEvent(
      id: jsonSerialization['id'] as int?,
      source: _ixv6cj1v.SignalSource.fromJson(
        (jsonSerialization['source'] as String),
      ),
      eventType: _ikhu1dq5.EventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      zoneCode: jsonSerialization['zoneCode'] as String,
      cameraCode: jsonSerialization['cameraCode'] as String?,
      trackId: jsonSerialization['trackId'] as String?,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      detail: jsonSerialization['detail'] as String?,
      locationDetail: jsonSerialization['locationDetail'] as String?,
      observedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['observedAt'],
      ),
      receivedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['receivedAt'],
      ),
      incidentId: jsonSerialization['incidentId'] as int?,
      outcome: jsonSerialization['outcome'] as String?,
      contextHour: jsonSerialization['contextHour'] as int?,
      scenarioRunId: jsonSerialization['scenarioRunId'] as int?,
      reporterUserId: jsonSerialization['reporterUserId'] as int?,
    );
  }

  static final t = SensorEventTable();

  static const db = SensorEventRepository._();

  @override
  int? id;

  _ixv6cj1v.SignalSource source;

  _ikhu1dq5.EventType eventType;

  String zoneCode;

  String? cameraCode;

  String? trackId;

  double confidence;

  String? detail;

  String? locationDetail;

  DateTime observedAt;

  DateTime receivedAt;

  /// Incident this signal created or joined.
  int? incidentId;

  /// What the agent did with the signal, e.g. 'Corroborated INC-1042'.
  String? outcome;

  int? contextHour;

  int? scenarioRunId;

  int? reporterUserId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SensorEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SensorEvent copyWith({
    int? id,
    _ixv6cj1v.SignalSource? source,
    _ikhu1dq5.EventType? eventType,
    String? zoneCode,
    String? cameraCode,
    String? trackId,
    double? confidence,
    String? detail,
    String? locationDetail,
    DateTime? observedAt,
    DateTime? receivedAt,
    int? incidentId,
    String? outcome,
    int? contextHour,
    int? scenarioRunId,
    int? reporterUserId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SensorEvent',
      if (id != null) 'id': id,
      'source': source.toJson(),
      'eventType': eventType.toJson(),
      'zoneCode': zoneCode,
      if (cameraCode != null) 'cameraCode': cameraCode,
      if (trackId != null) 'trackId': trackId,
      'confidence': confidence,
      if (detail != null) 'detail': detail,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'observedAt': observedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      if (incidentId != null) 'incidentId': incidentId,
      if (outcome != null) 'outcome': outcome,
      if (contextHour != null) 'contextHour': contextHour,
      if (scenarioRunId != null) 'scenarioRunId': scenarioRunId,
      if (reporterUserId != null) 'reporterUserId': reporterUserId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SensorEvent',
      if (id != null) 'id': id,
      'source': source.toJson(),
      'eventType': eventType.toJson(),
      'zoneCode': zoneCode,
      if (cameraCode != null) 'cameraCode': cameraCode,
      if (trackId != null) 'trackId': trackId,
      'confidence': confidence,
      if (detail != null) 'detail': detail,
      if (locationDetail != null) 'locationDetail': locationDetail,
      'observedAt': observedAt.toJson(),
      'receivedAt': receivedAt.toJson(),
      if (incidentId != null) 'incidentId': incidentId,
      if (outcome != null) 'outcome': outcome,
      if (contextHour != null) 'contextHour': contextHour,
      if (scenarioRunId != null) 'scenarioRunId': scenarioRunId,
    };
  }

  static SensorEventInclude include() {
    return SensorEventInclude._();
  }

  static SensorEventIncludeList includeList({
    _is.WhereExpressionBuilder<SensorEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SensorEventTable>? orderBy,
    _is.OrderByListBuilder<SensorEventTable>? orderByList,
    SensorEventInclude? include,
  }) {
    return SensorEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SensorEvent.t),
      orderByList: orderByList?.call(SensorEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SensorEventImpl extends SensorEvent {
  _SensorEventImpl({
    int? id,
    required _ixv6cj1v.SignalSource source,
    required _ikhu1dq5.EventType eventType,
    required String zoneCode,
    String? cameraCode,
    String? trackId,
    required double confidence,
    String? detail,
    String? locationDetail,
    required DateTime observedAt,
    required DateTime receivedAt,
    int? incidentId,
    String? outcome,
    int? contextHour,
    int? scenarioRunId,
    int? reporterUserId,
  }) : super._(
         id: id,
         source: source,
         eventType: eventType,
         zoneCode: zoneCode,
         cameraCode: cameraCode,
         trackId: trackId,
         confidence: confidence,
         detail: detail,
         locationDetail: locationDetail,
         observedAt: observedAt,
         receivedAt: receivedAt,
         incidentId: incidentId,
         outcome: outcome,
         contextHour: contextHour,
         scenarioRunId: scenarioRunId,
         reporterUserId: reporterUserId,
       );

  /// Returns a shallow copy of this [SensorEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SensorEvent copyWith({
    Object? id = _Undefined,
    _ixv6cj1v.SignalSource? source,
    _ikhu1dq5.EventType? eventType,
    String? zoneCode,
    Object? cameraCode = _Undefined,
    Object? trackId = _Undefined,
    double? confidence,
    Object? detail = _Undefined,
    Object? locationDetail = _Undefined,
    DateTime? observedAt,
    DateTime? receivedAt,
    Object? incidentId = _Undefined,
    Object? outcome = _Undefined,
    Object? contextHour = _Undefined,
    Object? scenarioRunId = _Undefined,
    Object? reporterUserId = _Undefined,
  }) {
    return SensorEvent(
      id: id is int? ? id : this.id,
      source: source ?? this.source,
      eventType: eventType ?? this.eventType,
      zoneCode: zoneCode ?? this.zoneCode,
      cameraCode: cameraCode is String? ? cameraCode : this.cameraCode,
      trackId: trackId is String? ? trackId : this.trackId,
      confidence: confidence ?? this.confidence,
      detail: detail is String? ? detail : this.detail,
      locationDetail: locationDetail is String?
          ? locationDetail
          : this.locationDetail,
      observedAt: observedAt ?? this.observedAt,
      receivedAt: receivedAt ?? this.receivedAt,
      incidentId: incidentId is int? ? incidentId : this.incidentId,
      outcome: outcome is String? ? outcome : this.outcome,
      contextHour: contextHour is int? ? contextHour : this.contextHour,
      scenarioRunId: scenarioRunId is int? ? scenarioRunId : this.scenarioRunId,
      reporterUserId: reporterUserId is int?
          ? reporterUserId
          : this.reporterUserId,
    );
  }
}

class SensorEventUpdateTable extends _is.UpdateTable<SensorEventTable> {
  SensorEventUpdateTable(super.table);

  _is.ColumnValue<_ixv6cj1v.SignalSource, _ixv6cj1v.SignalSource> source(
    _ixv6cj1v.SignalSource value,
  ) => _is.ColumnValue(
    table.source,
    value,
  );

  _is.ColumnValue<_ikhu1dq5.EventType, _ikhu1dq5.EventType> eventType(
    _ikhu1dq5.EventType value,
  ) => _is.ColumnValue(
    table.eventType,
    value,
  );

  _is.ColumnValue<String, String> zoneCode(String value) => _is.ColumnValue(
    table.zoneCode,
    value,
  );

  _is.ColumnValue<String, String> cameraCode(String? value) => _is.ColumnValue(
    table.cameraCode,
    value,
  );

  _is.ColumnValue<String, String> trackId(String? value) => _is.ColumnValue(
    table.trackId,
    value,
  );

  _is.ColumnValue<double, double> confidence(double value) => _is.ColumnValue(
    table.confidence,
    value,
  );

  _is.ColumnValue<String, String> detail(String? value) => _is.ColumnValue(
    table.detail,
    value,
  );

  _is.ColumnValue<String, String> locationDetail(String? value) =>
      _is.ColumnValue(
        table.locationDetail,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> observedAt(DateTime value) =>
      _is.ColumnValue(
        table.observedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );

  _is.ColumnValue<int, int> incidentId(int? value) => _is.ColumnValue(
    table.incidentId,
    value,
  );

  _is.ColumnValue<String, String> outcome(String? value) => _is.ColumnValue(
    table.outcome,
    value,
  );

  _is.ColumnValue<int, int> contextHour(int? value) => _is.ColumnValue(
    table.contextHour,
    value,
  );

  _is.ColumnValue<int, int> scenarioRunId(int? value) => _is.ColumnValue(
    table.scenarioRunId,
    value,
  );

  _is.ColumnValue<int, int> reporterUserId(int? value) => _is.ColumnValue(
    table.reporterUserId,
    value,
  );
}

class SensorEventTable extends _is.Table<int?> {
  SensorEventTable({super.tableRelation}) : super(tableName: 'sensor_event') {
    updateTable = SensorEventUpdateTable(this);
    source = _is.ColumnEnum(
      'source',
      this,
      _is.EnumSerialization.byName,
    );
    eventType = _is.ColumnEnum(
      'eventType',
      this,
      _is.EnumSerialization.byName,
    );
    zoneCode = _is.ColumnString(
      'zoneCode',
      this,
    );
    cameraCode = _is.ColumnString(
      'cameraCode',
      this,
    );
    trackId = _is.ColumnString(
      'trackId',
      this,
    );
    confidence = _is.ColumnDouble(
      'confidence',
      this,
    );
    detail = _is.ColumnString(
      'detail',
      this,
    );
    locationDetail = _is.ColumnString(
      'locationDetail',
      this,
    );
    observedAt = _is.ColumnDateTime(
      'observedAt',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
    );
    incidentId = _is.ColumnInt(
      'incidentId',
      this,
    );
    outcome = _is.ColumnString(
      'outcome',
      this,
    );
    contextHour = _is.ColumnInt(
      'contextHour',
      this,
    );
    scenarioRunId = _is.ColumnInt(
      'scenarioRunId',
      this,
    );
    reporterUserId = _is.ColumnInt(
      'reporterUserId',
      this,
    );
  }

  late final SensorEventUpdateTable updateTable;

  late final _is.ColumnEnum<_ixv6cj1v.SignalSource> source;

  late final _is.ColumnEnum<_ikhu1dq5.EventType> eventType;

  late final _is.ColumnString zoneCode;

  late final _is.ColumnString cameraCode;

  late final _is.ColumnString trackId;

  late final _is.ColumnDouble confidence;

  late final _is.ColumnString detail;

  late final _is.ColumnString locationDetail;

  late final _is.ColumnDateTime observedAt;

  late final _is.ColumnDateTime receivedAt;

  /// Incident this signal created or joined.
  late final _is.ColumnInt incidentId;

  /// What the agent did with the signal, e.g. 'Corroborated INC-1042'.
  late final _is.ColumnString outcome;

  late final _is.ColumnInt contextHour;

  late final _is.ColumnInt scenarioRunId;

  late final _is.ColumnInt reporterUserId;

  @override
  List<_is.Column> get columns => [
    id,
    source,
    eventType,
    zoneCode,
    cameraCode,
    trackId,
    confidence,
    detail,
    locationDetail,
    observedAt,
    receivedAt,
    incidentId,
    outcome,
    contextHour,
    scenarioRunId,
    reporterUserId,
  ];
}

class SensorEventInclude extends _is.IncludeObject {
  SensorEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SensorEvent.t;
}

class SensorEventIncludeList extends _is.IncludeList {
  SensorEventIncludeList._({
    _is.WhereExpressionBuilder<SensorEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SensorEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SensorEvent.t;
}

class SensorEventRepository {
  const SensorEventRepository._();

  /// Returns a list of [SensorEvent]s matching the given query parameters.
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
  Future<List<SensorEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SensorEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SensorEventTable>? orderBy,
    _is.OrderByListBuilder<SensorEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SensorEvent>(
      where: where?.call(SensorEvent.t),
      orderBy: orderBy?.call(SensorEvent.t),
      orderByList: orderByList?.call(SensorEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SensorEvent] matching the given query parameters.
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
  Future<SensorEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SensorEventTable>? where,
    int? offset,
    _is.OrderByBuilder<SensorEventTable>? orderBy,
    _is.OrderByListBuilder<SensorEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SensorEvent>(
      where: where?.call(SensorEvent.t),
      orderBy: orderBy?.call(SensorEvent.t),
      orderByList: orderByList?.call(SensorEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SensorEvent] by its [id] or null if no such row exists.
  Future<SensorEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SensorEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SensorEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [SensorEvent]s will have their `id` fields set.
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
  Future<List<SensorEvent>> insert(
    _is.DatabaseSession session,
    List<SensorEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SensorEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SensorEvent] and returns the inserted row.
  ///
  /// The returned [SensorEvent] will have its `id` field set.
  Future<SensorEvent> insertRow(
    _is.DatabaseSession session,
    SensorEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SensorEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SensorEvent]s in the list and returns the resulting rows.
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
  /// The returned [SensorEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SensorEvent>> upsert(
    _is.DatabaseSession session,
    List<SensorEvent> rows, {
    required _is.ColumnSelections<SensorEventTable> conflictColumns,
    _is.ColumnSelections<SensorEventTable>? updateColumns,
    _is.WhereExpressionBuilder<SensorEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SensorEvent>(
      rows,
      conflictColumns: conflictColumns(SensorEvent.t),
      updateColumns: updateColumns?.call(SensorEvent.t),
      updateWhere: updateWhere?.call(SensorEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SensorEvent] and returns the resulting row.
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
  /// The returned [SensorEvent] will have its `id` field set.
  Future<SensorEvent?> upsertRow(
    _is.DatabaseSession session,
    SensorEvent row, {
    required _is.ColumnSelections<SensorEventTable> conflictColumns,
    _is.ColumnSelections<SensorEventTable>? updateColumns,
    _is.WhereExpressionBuilder<SensorEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SensorEvent>(
      row,
      conflictColumns: conflictColumns(SensorEvent.t),
      updateColumns: updateColumns?.call(SensorEvent.t),
      updateWhere: updateWhere?.call(SensorEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [SensorEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SensorEvent>> update(
    _is.DatabaseSession session,
    List<SensorEvent> rows, {
    _is.ColumnSelections<SensorEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SensorEvent>(
      rows,
      columns: columns?.call(SensorEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SensorEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SensorEvent> updateRow(
    _is.DatabaseSession session,
    SensorEvent row, {
    _is.ColumnSelections<SensorEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SensorEvent>(
      row,
      columns: columns?.call(SensorEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SensorEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SensorEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SensorEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SensorEvent>(
      id,
      columnValues: columnValues(SensorEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SensorEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SensorEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SensorEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SensorEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SensorEventTable>? orderBy,
    _is.OrderByListBuilder<SensorEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SensorEvent>(
      columnValues: columnValues(SensorEvent.t.updateTable),
      where: where(SensorEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SensorEvent.t),
      orderByList: orderByList?.call(SensorEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SensorEvent]s in the list and returns the deleted rows.
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
  Future<List<SensorEvent>> delete(
    _is.DatabaseSession session,
    List<SensorEvent> rows, {
    _is.OrderByBuilder<SensorEventTable>? orderBy,
    _is.OrderByListBuilder<SensorEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SensorEvent>(
      rows,
      orderBy: orderBy?.call(SensorEvent.t),
      orderByList: orderByList?.call(SensorEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SensorEvent].
  Future<SensorEvent> deleteRow(
    _is.DatabaseSession session,
    SensorEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SensorEvent>(
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
  Future<List<SensorEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SensorEventTable> where,
    _is.OrderByBuilder<SensorEventTable>? orderBy,
    _is.OrderByListBuilder<SensorEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SensorEvent>(
      where: where(SensorEvent.t),
      orderBy: orderBy?.call(SensorEvent.t),
      orderByList: orderByList?.call(SensorEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SensorEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SensorEvent>(
      where: where?.call(SensorEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SensorEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SensorEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SensorEvent>(
      where: where(SensorEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
