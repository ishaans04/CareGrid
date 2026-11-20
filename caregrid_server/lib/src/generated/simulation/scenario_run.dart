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

/// One playback of a seeded emergency scenario through the live pipeline.
abstract class ScenarioRun
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ScenarioRun._({
    this.id,
    required this.campusId,
    required this.scenarioCode,
    required this.title,
    required this.startedAt,
    required this.startedBy,
    required this.autopilot,
    required this.status,
    required this.stepsTotal,
    required this.stepsEmitted,
    required this.faults,
  });

  factory ScenarioRun({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String title,
    required DateTime startedAt,
    required String startedBy,
    required bool autopilot,
    required String status,
    required int stepsTotal,
    required int stepsEmitted,
    required List<String> faults,
  }) = _ScenarioRunImpl;

  factory ScenarioRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScenarioRun(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      scenarioCode: jsonSerialization['scenarioCode'] as String,
      title: jsonSerialization['title'] as String,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      startedBy: jsonSerialization['startedBy'] as String,
      autopilot: _is.BoolJsonExtension.fromJson(jsonSerialization['autopilot']),
      status: jsonSerialization['status'] as String,
      stepsTotal: jsonSerialization['stepsTotal'] as int,
      stepsEmitted: jsonSerialization['stepsEmitted'] as int,
      faults: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['faults'],
      ),
    );
  }

  static final t = ScenarioRunTable();

  static const db = ScenarioRunRepository._();

  @override
  int? id;

  int campusId;

  String scenarioCode;

  String title;

  DateTime startedAt;

  String startedBy;

  /// Simulated operator and responders act on their own.
  bool autopilot;

  /// running, completed or stopped.
  String status;

  int stepsTotal;

  int stepsEmitted;

  /// Injected faults, e.g. noAck:AMB-A2.
  List<String> faults;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScenarioRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScenarioRun copyWith({
    int? id,
    int? campusId,
    String? scenarioCode,
    String? title,
    DateTime? startedAt,
    String? startedBy,
    bool? autopilot,
    String? status,
    int? stepsTotal,
    int? stepsEmitted,
    List<String>? faults,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScenarioRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'title': title,
      'startedAt': startedAt.toJson(),
      'startedBy': startedBy,
      'autopilot': autopilot,
      'status': status,
      'stepsTotal': stepsTotal,
      'stepsEmitted': stepsEmitted,
      'faults': faults.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScenarioRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'title': title,
      'startedAt': startedAt.toJson(),
      'startedBy': startedBy,
      'autopilot': autopilot,
      'status': status,
      'stepsTotal': stepsTotal,
      'stepsEmitted': stepsEmitted,
      'faults': faults.toJson(),
    };
  }

  static ScenarioRunInclude include() {
    return ScenarioRunInclude._();
  }

  static ScenarioRunIncludeList includeList({
    _is.WhereExpressionBuilder<ScenarioRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScenarioRunTable>? orderBy,
    _is.OrderByListBuilder<ScenarioRunTable>? orderByList,
    ScenarioRunInclude? include,
  }) {
    return ScenarioRunIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScenarioRun.t),
      orderByList: orderByList?.call(ScenarioRun.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScenarioRunImpl extends ScenarioRun {
  _ScenarioRunImpl({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String title,
    required DateTime startedAt,
    required String startedBy,
    required bool autopilot,
    required String status,
    required int stepsTotal,
    required int stepsEmitted,
    required List<String> faults,
  }) : super._(
         id: id,
         campusId: campusId,
         scenarioCode: scenarioCode,
         title: title,
         startedAt: startedAt,
         startedBy: startedBy,
         autopilot: autopilot,
         status: status,
         stepsTotal: stepsTotal,
         stepsEmitted: stepsEmitted,
         faults: faults,
       );

  /// Returns a shallow copy of this [ScenarioRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScenarioRun copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? scenarioCode,
    String? title,
    DateTime? startedAt,
    String? startedBy,
    bool? autopilot,
    String? status,
    int? stepsTotal,
    int? stepsEmitted,
    List<String>? faults,
  }) {
    return ScenarioRun(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      scenarioCode: scenarioCode ?? this.scenarioCode,
      title: title ?? this.title,
      startedAt: startedAt ?? this.startedAt,
      startedBy: startedBy ?? this.startedBy,
      autopilot: autopilot ?? this.autopilot,
      status: status ?? this.status,
      stepsTotal: stepsTotal ?? this.stepsTotal,
      stepsEmitted: stepsEmitted ?? this.stepsEmitted,
      faults: faults ?? this.faults.map((e0) => e0).toList(),
    );
  }
}

class ScenarioRunUpdateTable extends _is.UpdateTable<ScenarioRunTable> {
  ScenarioRunUpdateTable(super.table);

  _is.ColumnValue<int, int> campusId(int value) => _is.ColumnValue(
    table.campusId,
    value,
  );

  _is.ColumnValue<String, String> scenarioCode(String value) => _is.ColumnValue(
    table.scenarioCode,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<String, String> startedBy(String value) => _is.ColumnValue(
    table.startedBy,
    value,
  );

  _is.ColumnValue<bool, bool> autopilot(bool value) => _is.ColumnValue(
    table.autopilot,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> stepsTotal(int value) => _is.ColumnValue(
    table.stepsTotal,
    value,
  );

  _is.ColumnValue<int, int> stepsEmitted(int value) => _is.ColumnValue(
    table.stepsEmitted,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> faults(List<String> value) =>
      _is.ColumnValue(
        table.faults,
        value,
      );
}

class ScenarioRunTable extends _is.Table<int?> {
  ScenarioRunTable({super.tableRelation}) : super(tableName: 'scenario_run') {
    updateTable = ScenarioRunUpdateTable(this);
    campusId = _is.ColumnInt(
      'campusId',
      this,
    );
    scenarioCode = _is.ColumnString(
      'scenarioCode',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    startedBy = _is.ColumnString(
      'startedBy',
      this,
    );
    autopilot = _is.ColumnBool(
      'autopilot',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    stepsTotal = _is.ColumnInt(
      'stepsTotal',
      this,
    );
    stepsEmitted = _is.ColumnInt(
      'stepsEmitted',
      this,
    );
    faults = _is.ColumnSerializable<List<String>>(
      'faults',
      this,
    );
  }

  late final ScenarioRunUpdateTable updateTable;

  late final _is.ColumnInt campusId;

  late final _is.ColumnString scenarioCode;

  late final _is.ColumnString title;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnString startedBy;

  /// Simulated operator and responders act on their own.
  late final _is.ColumnBool autopilot;

  /// running, completed or stopped.
  late final _is.ColumnString status;

  late final _is.ColumnInt stepsTotal;

  late final _is.ColumnInt stepsEmitted;

  /// Injected faults, e.g. noAck:AMB-A2.
  late final _is.ColumnSerializable<List<String>> faults;

  @override
  List<_is.Column> get columns => [
    id,
    campusId,
    scenarioCode,
    title,
    startedAt,
    startedBy,
    autopilot,
    status,
    stepsTotal,
    stepsEmitted,
    faults,
  ];
}

class ScenarioRunInclude extends _is.IncludeObject {
  ScenarioRunInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ScenarioRun.t;
}

class ScenarioRunIncludeList extends _is.IncludeList {
  ScenarioRunIncludeList._({
    _is.WhereExpressionBuilder<ScenarioRunTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScenarioRun.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ScenarioRun.t;
}

class ScenarioRunRepository {
  const ScenarioRunRepository._();

  /// Returns a list of [ScenarioRun]s matching the given query parameters.
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
  Future<List<ScenarioRun>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScenarioRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScenarioRunTable>? orderBy,
    _is.OrderByListBuilder<ScenarioRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ScenarioRun>(
      where: where?.call(ScenarioRun.t),
      orderBy: orderBy?.call(ScenarioRun.t),
      orderByList: orderByList?.call(ScenarioRun.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ScenarioRun] matching the given query parameters.
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
  Future<ScenarioRun?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScenarioRunTable>? where,
    int? offset,
    _is.OrderByBuilder<ScenarioRunTable>? orderBy,
    _is.OrderByListBuilder<ScenarioRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ScenarioRun>(
      where: where?.call(ScenarioRun.t),
      orderBy: orderBy?.call(ScenarioRun.t),
      orderByList: orderByList?.call(ScenarioRun.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ScenarioRun] by its [id] or null if no such row exists.
  Future<ScenarioRun?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ScenarioRun>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ScenarioRun]s in the list and returns the inserted rows.
  ///
  /// The returned [ScenarioRun]s will have their `id` fields set.
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
  Future<List<ScenarioRun>> insert(
    _is.DatabaseSession session,
    List<ScenarioRun> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ScenarioRun>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ScenarioRun] and returns the inserted row.
  ///
  /// The returned [ScenarioRun] will have its `id` field set.
  Future<ScenarioRun> insertRow(
    _is.DatabaseSession session,
    ScenarioRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScenarioRun>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ScenarioRun]s in the list and returns the resulting rows.
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
  /// The returned [ScenarioRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScenarioRun>> upsert(
    _is.DatabaseSession session,
    List<ScenarioRun> rows, {
    required _is.ColumnSelections<ScenarioRunTable> conflictColumns,
    _is.ColumnSelections<ScenarioRunTable>? updateColumns,
    _is.WhereExpressionBuilder<ScenarioRunTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ScenarioRun>(
      rows,
      conflictColumns: conflictColumns(ScenarioRun.t),
      updateColumns: updateColumns?.call(ScenarioRun.t),
      updateWhere: updateWhere?.call(ScenarioRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ScenarioRun] and returns the resulting row.
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
  /// The returned [ScenarioRun] will have its `id` field set.
  Future<ScenarioRun?> upsertRow(
    _is.DatabaseSession session,
    ScenarioRun row, {
    required _is.ColumnSelections<ScenarioRunTable> conflictColumns,
    _is.ColumnSelections<ScenarioRunTable>? updateColumns,
    _is.WhereExpressionBuilder<ScenarioRunTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ScenarioRun>(
      row,
      conflictColumns: conflictColumns(ScenarioRun.t),
      updateColumns: updateColumns?.call(ScenarioRun.t),
      updateWhere: updateWhere?.call(ScenarioRun.t),
      transaction: transaction,
    );
  }

  /// Updates all [ScenarioRun]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScenarioRun>> update(
    _is.DatabaseSession session,
    List<ScenarioRun> rows, {
    _is.ColumnSelections<ScenarioRunTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ScenarioRun>(
      rows,
      columns: columns?.call(ScenarioRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ScenarioRun]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScenarioRun> updateRow(
    _is.DatabaseSession session,
    ScenarioRun row, {
    _is.ColumnSelections<ScenarioRunTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScenarioRun>(
      row,
      columns: columns?.call(ScenarioRun.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScenarioRun] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScenarioRun?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ScenarioRunUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ScenarioRun>(
      id,
      columnValues: columnValues(ScenarioRun.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScenarioRun]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScenarioRun>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ScenarioRunUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ScenarioRunTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScenarioRunTable>? orderBy,
    _is.OrderByListBuilder<ScenarioRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ScenarioRun>(
      columnValues: columnValues(ScenarioRun.t.updateTable),
      where: where(ScenarioRun.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScenarioRun.t),
      orderByList: orderByList?.call(ScenarioRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ScenarioRun]s in the list and returns the deleted rows.
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
  Future<List<ScenarioRun>> delete(
    _is.DatabaseSession session,
    List<ScenarioRun> rows, {
    _is.OrderByBuilder<ScenarioRunTable>? orderBy,
    _is.OrderByListBuilder<ScenarioRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ScenarioRun>(
      rows,
      orderBy: orderBy?.call(ScenarioRun.t),
      orderByList: orderByList?.call(ScenarioRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ScenarioRun].
  Future<ScenarioRun> deleteRow(
    _is.DatabaseSession session,
    ScenarioRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScenarioRun>(
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
  Future<List<ScenarioRun>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScenarioRunTable> where,
    _is.OrderByBuilder<ScenarioRunTable>? orderBy,
    _is.OrderByListBuilder<ScenarioRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ScenarioRun>(
      where: where(ScenarioRun.t),
      orderBy: orderBy?.call(ScenarioRun.t),
      orderByList: orderByList?.call(ScenarioRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScenarioRunTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ScenarioRun>(
      where: where?.call(ScenarioRun.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ScenarioRun] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScenarioRunTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ScenarioRun>(
      where: where(ScenarioRun.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
