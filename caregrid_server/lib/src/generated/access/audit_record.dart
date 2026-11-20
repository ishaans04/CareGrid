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

/// Access and action audit: who saw what, who escalated, who dispatched, who overrode the AI, and when.
abstract class AuditRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AuditRecord._({
    this.id,
    this.campusId,
    required this.at,
    this.userId,
    required this.userName,
    required this.role,
    required this.action,
    this.target,
    this.detail,
  });

  factory AuditRecord({
    int? id,
    int? campusId,
    required DateTime at,
    int? userId,
    required String userName,
    required String role,
    required String action,
    String? target,
    String? detail,
  }) = _AuditRecordImpl;

  factory AuditRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditRecord(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int?,
      at: _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      userId: jsonSerialization['userId'] as int?,
      userName: jsonSerialization['userName'] as String,
      role: jsonSerialization['role'] as String,
      action: jsonSerialization['action'] as String,
      target: jsonSerialization['target'] as String?,
      detail: jsonSerialization['detail'] as String?,
    );
  }

  static final t = AuditRecordTable();

  static const db = AuditRecordRepository._();

  @override
  int? id;

  /// Null only for deployment-operator records that precede any campus membership.
  int? campusId;

  DateTime at;

  int? userId;

  String userName;

  String role;

  String action;

  String? target;

  String? detail;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuditRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuditRecord copyWith({
    int? id,
    int? campusId,
    DateTime? at,
    int? userId,
    String? userName,
    String? role,
    String? action,
    String? target,
    String? detail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditRecord',
      if (id != null) 'id': id,
      if (campusId != null) 'campusId': campusId,
      'at': at.toJson(),
      if (userId != null) 'userId': userId,
      'userName': userName,
      'role': role,
      'action': action,
      if (target != null) 'target': target,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditRecord',
      if (id != null) 'id': id,
      if (campusId != null) 'campusId': campusId,
      'at': at.toJson(),
      if (userId != null) 'userId': userId,
      'userName': userName,
      'role': role,
      'action': action,
      if (target != null) 'target': target,
      if (detail != null) 'detail': detail,
    };
  }

  static AuditRecordInclude include() {
    return AuditRecordInclude._();
  }

  static AuditRecordIncludeList includeList({
    _is.WhereExpressionBuilder<AuditRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditRecordTable>? orderBy,
    _is.OrderByListBuilder<AuditRecordTable>? orderByList,
    AuditRecordInclude? include,
  }) {
    return AuditRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditRecord.t),
      orderByList: orderByList?.call(AuditRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditRecordImpl extends AuditRecord {
  _AuditRecordImpl({
    int? id,
    int? campusId,
    required DateTime at,
    int? userId,
    required String userName,
    required String role,
    required String action,
    String? target,
    String? detail,
  }) : super._(
         id: id,
         campusId: campusId,
         at: at,
         userId: userId,
         userName: userName,
         role: role,
         action: action,
         target: target,
         detail: detail,
       );

  /// Returns a shallow copy of this [AuditRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuditRecord copyWith({
    Object? id = _Undefined,
    Object? campusId = _Undefined,
    DateTime? at,
    Object? userId = _Undefined,
    String? userName,
    String? role,
    String? action,
    Object? target = _Undefined,
    Object? detail = _Undefined,
  }) {
    return AuditRecord(
      id: id is int? ? id : this.id,
      campusId: campusId is int? ? campusId : this.campusId,
      at: at ?? this.at,
      userId: userId is int? ? userId : this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      action: action ?? this.action,
      target: target is String? ? target : this.target,
      detail: detail is String? ? detail : this.detail,
    );
  }
}

class AuditRecordUpdateTable extends _is.UpdateTable<AuditRecordTable> {
  AuditRecordUpdateTable(super.table);

  _is.ColumnValue<int, int> campusId(int? value) => _is.ColumnValue(
    table.campusId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> at(DateTime value) => _is.ColumnValue(
    table.at,
    value,
  );

  _is.ColumnValue<int, int> userId(int? value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> userName(String value) => _is.ColumnValue(
    table.userName,
    value,
  );

  _is.ColumnValue<String, String> role(String value) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<String, String> action(String value) => _is.ColumnValue(
    table.action,
    value,
  );

  _is.ColumnValue<String, String> target(String? value) => _is.ColumnValue(
    table.target,
    value,
  );

  _is.ColumnValue<String, String> detail(String? value) => _is.ColumnValue(
    table.detail,
    value,
  );
}

class AuditRecordTable extends _is.Table<int?> {
  AuditRecordTable({super.tableRelation}) : super(tableName: 'audit_record') {
    updateTable = AuditRecordUpdateTable(this);
    campusId = _is.ColumnInt(
      'campusId',
      this,
    );
    at = _is.ColumnDateTime(
      'at',
      this,
    );
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    userName = _is.ColumnString(
      'userName',
      this,
    );
    role = _is.ColumnString(
      'role',
      this,
    );
    action = _is.ColumnString(
      'action',
      this,
    );
    target = _is.ColumnString(
      'target',
      this,
    );
    detail = _is.ColumnString(
      'detail',
      this,
    );
  }

  late final AuditRecordUpdateTable updateTable;

  /// Null only for deployment-operator records that precede any campus membership.
  late final _is.ColumnInt campusId;

  late final _is.ColumnDateTime at;

  late final _is.ColumnInt userId;

  late final _is.ColumnString userName;

  late final _is.ColumnString role;

  late final _is.ColumnString action;

  late final _is.ColumnString target;

  late final _is.ColumnString detail;

  @override
  List<_is.Column> get columns => [
    id,
    campusId,
    at,
    userId,
    userName,
    role,
    action,
    target,
    detail,
  ];
}

class AuditRecordInclude extends _is.IncludeObject {
  AuditRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AuditRecord.t;
}

class AuditRecordIncludeList extends _is.IncludeList {
  AuditRecordIncludeList._({
    _is.WhereExpressionBuilder<AuditRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuditRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AuditRecord.t;
}

class AuditRecordRepository {
  const AuditRecordRepository._();

  /// Returns a list of [AuditRecord]s matching the given query parameters.
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
  Future<List<AuditRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditRecordTable>? orderBy,
    _is.OrderByListBuilder<AuditRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuditRecord>(
      where: where?.call(AuditRecord.t),
      orderBy: orderBy?.call(AuditRecord.t),
      orderByList: orderByList?.call(AuditRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuditRecord] matching the given query parameters.
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
  Future<AuditRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<AuditRecordTable>? orderBy,
    _is.OrderByListBuilder<AuditRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuditRecord>(
      where: where?.call(AuditRecord.t),
      orderBy: orderBy?.call(AuditRecord.t),
      orderByList: orderByList?.call(AuditRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuditRecord] by its [id] or null if no such row exists.
  Future<AuditRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuditRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuditRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [AuditRecord]s will have their `id` fields set.
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
  Future<List<AuditRecord>> insert(
    _is.DatabaseSession session,
    List<AuditRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AuditRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AuditRecord] and returns the inserted row.
  ///
  /// The returned [AuditRecord] will have its `id` field set.
  Future<AuditRecord> insertRow(
    _is.DatabaseSession session,
    AuditRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuditRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AuditRecord]s in the list and returns the resulting rows.
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
  /// The returned [AuditRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditRecord>> upsert(
    _is.DatabaseSession session,
    List<AuditRecord> rows, {
    required _is.ColumnSelections<AuditRecordTable> conflictColumns,
    _is.ColumnSelections<AuditRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<AuditRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AuditRecord>(
      rows,
      conflictColumns: conflictColumns(AuditRecord.t),
      updateColumns: updateColumns?.call(AuditRecord.t),
      updateWhere: updateWhere?.call(AuditRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AuditRecord] and returns the resulting row.
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
  /// The returned [AuditRecord] will have its `id` field set.
  Future<AuditRecord?> upsertRow(
    _is.DatabaseSession session,
    AuditRecord row, {
    required _is.ColumnSelections<AuditRecordTable> conflictColumns,
    _is.ColumnSelections<AuditRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<AuditRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AuditRecord>(
      row,
      conflictColumns: conflictColumns(AuditRecord.t),
      updateColumns: updateColumns?.call(AuditRecord.t),
      updateWhere: updateWhere?.call(AuditRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [AuditRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditRecord>> update(
    _is.DatabaseSession session,
    List<AuditRecord> rows, {
    _is.ColumnSelections<AuditRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AuditRecord>(
      rows,
      columns: columns?.call(AuditRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AuditRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuditRecord> updateRow(
    _is.DatabaseSession session,
    AuditRecord row, {
    _is.ColumnSelections<AuditRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuditRecord>(
      row,
      columns: columns?.call(AuditRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuditRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AuditRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AuditRecord>(
      id,
      columnValues: columnValues(AuditRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuditRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuditRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AuditRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AuditRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuditRecordTable>? orderBy,
    _is.OrderByListBuilder<AuditRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AuditRecord>(
      columnValues: columnValues(AuditRecord.t.updateTable),
      where: where(AuditRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditRecord.t),
      orderByList: orderByList?.call(AuditRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AuditRecord]s in the list and returns the deleted rows.
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
  Future<List<AuditRecord>> delete(
    _is.DatabaseSession session,
    List<AuditRecord> rows, {
    _is.OrderByBuilder<AuditRecordTable>? orderBy,
    _is.OrderByListBuilder<AuditRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AuditRecord>(
      rows,
      orderBy: orderBy?.call(AuditRecord.t),
      orderByList: orderByList?.call(AuditRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AuditRecord].
  Future<AuditRecord> deleteRow(
    _is.DatabaseSession session,
    AuditRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuditRecord>(
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
  Future<List<AuditRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuditRecordTable> where,
    _is.OrderByBuilder<AuditRecordTable>? orderBy,
    _is.OrderByListBuilder<AuditRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AuditRecord>(
      where: where(AuditRecord.t),
      orderBy: orderBy?.call(AuditRecord.t),
      orderByList: orderByList?.call(AuditRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuditRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AuditRecord>(
      where: where?.call(AuditRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuditRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuditRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuditRecord>(
      where: where(AuditRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
