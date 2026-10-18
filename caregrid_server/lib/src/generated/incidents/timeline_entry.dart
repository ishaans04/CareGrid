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
import '../enums/timeline_kind.dart' as _iag1obo8;

/// One timestamped line of the incident's audit timeline: the institutional memory.
abstract class TimelineEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TimelineEntry._({
    this.id,
    required this.incidentId,
    required this.at,
    required this.kind,
    required this.actor,
    required this.message,
    bool? sensitive,
  }) : sensitive = sensitive ?? false;

  factory TimelineEntry({
    int? id,
    required int incidentId,
    required DateTime at,
    required _iag1obo8.TimelineKind kind,
    required String actor,
    required String message,
    bool? sensitive,
  }) = _TimelineEntryImpl;

  factory TimelineEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimelineEntry(
      id: jsonSerialization['id'] as int?,
      incidentId: jsonSerialization['incidentId'] as int,
      at: _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      kind: _iag1obo8.TimelineKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      actor: jsonSerialization['actor'] as String,
      message: jsonSerialization['message'] as String,
      sensitive: jsonSerialization['sensitive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['sensitive']),
    );
  }

  static final t = TimelineEntryTable();

  static const db = TimelineEntryRepository._();

  @override
  int? id;

  int incidentId;

  DateTime at;

  _iag1obo8.TimelineKind kind;

  String actor;

  String message;

  /// Entries that reference camera evidence are only shown to the command role.
  bool sensitive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TimelineEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TimelineEntry copyWith({
    int? id,
    int? incidentId,
    DateTime? at,
    _iag1obo8.TimelineKind? kind,
    String? actor,
    String? message,
    bool? sensitive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimelineEntry',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'at': at.toJson(),
      'kind': kind.toJson(),
      'actor': actor,
      'message': message,
      'sensitive': sensitive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimelineEntry',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'at': at.toJson(),
      'kind': kind.toJson(),
      'actor': actor,
      'message': message,
      'sensitive': sensitive,
    };
  }

  static TimelineEntryInclude include() {
    return TimelineEntryInclude._();
  }

  static TimelineEntryIncludeList includeList({
    _is.WhereExpressionBuilder<TimelineEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TimelineEntryTable>? orderBy,
    _is.OrderByListBuilder<TimelineEntryTable>? orderByList,
    TimelineEntryInclude? include,
  }) {
    return TimelineEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TimelineEntry.t),
      orderByList: orderByList?.call(TimelineEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimelineEntryImpl extends TimelineEntry {
  _TimelineEntryImpl({
    int? id,
    required int incidentId,
    required DateTime at,
    required _iag1obo8.TimelineKind kind,
    required String actor,
    required String message,
    bool? sensitive,
  }) : super._(
         id: id,
         incidentId: incidentId,
         at: at,
         kind: kind,
         actor: actor,
         message: message,
         sensitive: sensitive,
       );

  /// Returns a shallow copy of this [TimelineEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TimelineEntry copyWith({
    Object? id = _Undefined,
    int? incidentId,
    DateTime? at,
    _iag1obo8.TimelineKind? kind,
    String? actor,
    String? message,
    bool? sensitive,
  }) {
    return TimelineEntry(
      id: id is int? ? id : this.id,
      incidentId: incidentId ?? this.incidentId,
      at: at ?? this.at,
      kind: kind ?? this.kind,
      actor: actor ?? this.actor,
      message: message ?? this.message,
      sensitive: sensitive ?? this.sensitive,
    );
  }
}

class TimelineEntryUpdateTable extends _is.UpdateTable<TimelineEntryTable> {
  TimelineEntryUpdateTable(super.table);

  _is.ColumnValue<int, int> incidentId(int value) => _is.ColumnValue(
    table.incidentId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> at(DateTime value) => _is.ColumnValue(
    table.at,
    value,
  );

  _is.ColumnValue<_iag1obo8.TimelineKind, _iag1obo8.TimelineKind> kind(
    _iag1obo8.TimelineKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> actor(String value) => _is.ColumnValue(
    table.actor,
    value,
  );

  _is.ColumnValue<String, String> message(String value) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<bool, bool> sensitive(bool value) => _is.ColumnValue(
    table.sensitive,
    value,
  );
}

class TimelineEntryTable extends _is.Table<int?> {
  TimelineEntryTable({super.tableRelation})
    : super(tableName: 'timeline_entry') {
    updateTable = TimelineEntryUpdateTable(this);
    incidentId = _is.ColumnInt(
      'incidentId',
      this,
    );
    at = _is.ColumnDateTime(
      'at',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    actor = _is.ColumnString(
      'actor',
      this,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    sensitive = _is.ColumnBool(
      'sensitive',
      this,
      hasDefault: true,
    );
  }

  late final TimelineEntryUpdateTable updateTable;

  late final _is.ColumnInt incidentId;

  late final _is.ColumnDateTime at;

  late final _is.ColumnEnum<_iag1obo8.TimelineKind> kind;

  late final _is.ColumnString actor;

  late final _is.ColumnString message;

  /// Entries that reference camera evidence are only shown to the command role.
  late final _is.ColumnBool sensitive;

  @override
  List<_is.Column> get columns => [
    id,
    incidentId,
    at,
    kind,
    actor,
    message,
    sensitive,
  ];
}

class TimelineEntryInclude extends _is.IncludeObject {
  TimelineEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TimelineEntry.t;
}

class TimelineEntryIncludeList extends _is.IncludeList {
  TimelineEntryIncludeList._({
    _is.WhereExpressionBuilder<TimelineEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TimelineEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TimelineEntry.t;
}

class TimelineEntryRepository {
  const TimelineEntryRepository._();

  /// Returns a list of [TimelineEntry]s matching the given query parameters.
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
  Future<List<TimelineEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TimelineEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TimelineEntryTable>? orderBy,
    _is.OrderByListBuilder<TimelineEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TimelineEntry>(
      where: where?.call(TimelineEntry.t),
      orderBy: orderBy?.call(TimelineEntry.t),
      orderByList: orderByList?.call(TimelineEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TimelineEntry] matching the given query parameters.
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
  Future<TimelineEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TimelineEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<TimelineEntryTable>? orderBy,
    _is.OrderByListBuilder<TimelineEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TimelineEntry>(
      where: where?.call(TimelineEntry.t),
      orderBy: orderBy?.call(TimelineEntry.t),
      orderByList: orderByList?.call(TimelineEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TimelineEntry] by its [id] or null if no such row exists.
  Future<TimelineEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TimelineEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TimelineEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [TimelineEntry]s will have their `id` fields set.
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
  Future<List<TimelineEntry>> insert(
    _is.DatabaseSession session,
    List<TimelineEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TimelineEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TimelineEntry] and returns the inserted row.
  ///
  /// The returned [TimelineEntry] will have its `id` field set.
  Future<TimelineEntry> insertRow(
    _is.DatabaseSession session,
    TimelineEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TimelineEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TimelineEntry]s in the list and returns the resulting rows.
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
  /// The returned [TimelineEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TimelineEntry>> upsert(
    _is.DatabaseSession session,
    List<TimelineEntry> rows, {
    required _is.ColumnSelections<TimelineEntryTable> conflictColumns,
    _is.ColumnSelections<TimelineEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<TimelineEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TimelineEntry>(
      rows,
      conflictColumns: conflictColumns(TimelineEntry.t),
      updateColumns: updateColumns?.call(TimelineEntry.t),
      updateWhere: updateWhere?.call(TimelineEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TimelineEntry] and returns the resulting row.
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
  /// The returned [TimelineEntry] will have its `id` field set.
  Future<TimelineEntry?> upsertRow(
    _is.DatabaseSession session,
    TimelineEntry row, {
    required _is.ColumnSelections<TimelineEntryTable> conflictColumns,
    _is.ColumnSelections<TimelineEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<TimelineEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TimelineEntry>(
      row,
      conflictColumns: conflictColumns(TimelineEntry.t),
      updateColumns: updateColumns?.call(TimelineEntry.t),
      updateWhere: updateWhere?.call(TimelineEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [TimelineEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TimelineEntry>> update(
    _is.DatabaseSession session,
    List<TimelineEntry> rows, {
    _is.ColumnSelections<TimelineEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TimelineEntry>(
      rows,
      columns: columns?.call(TimelineEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TimelineEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TimelineEntry> updateRow(
    _is.DatabaseSession session,
    TimelineEntry row, {
    _is.ColumnSelections<TimelineEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TimelineEntry>(
      row,
      columns: columns?.call(TimelineEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TimelineEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TimelineEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TimelineEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TimelineEntry>(
      id,
      columnValues: columnValues(TimelineEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TimelineEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TimelineEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TimelineEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TimelineEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TimelineEntryTable>? orderBy,
    _is.OrderByListBuilder<TimelineEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TimelineEntry>(
      columnValues: columnValues(TimelineEntry.t.updateTable),
      where: where(TimelineEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TimelineEntry.t),
      orderByList: orderByList?.call(TimelineEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TimelineEntry]s in the list and returns the deleted rows.
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
  Future<List<TimelineEntry>> delete(
    _is.DatabaseSession session,
    List<TimelineEntry> rows, {
    _is.OrderByBuilder<TimelineEntryTable>? orderBy,
    _is.OrderByListBuilder<TimelineEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TimelineEntry>(
      rows,
      orderBy: orderBy?.call(TimelineEntry.t),
      orderByList: orderByList?.call(TimelineEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TimelineEntry].
  Future<TimelineEntry> deleteRow(
    _is.DatabaseSession session,
    TimelineEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TimelineEntry>(
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
  Future<List<TimelineEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TimelineEntryTable> where,
    _is.OrderByBuilder<TimelineEntryTable>? orderBy,
    _is.OrderByListBuilder<TimelineEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TimelineEntry>(
      where: where(TimelineEntry.t),
      orderBy: orderBy?.call(TimelineEntry.t),
      orderByList: orderByList?.call(TimelineEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TimelineEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TimelineEntry>(
      where: where?.call(TimelineEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TimelineEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TimelineEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TimelineEntry>(
      where: where(TimelineEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
