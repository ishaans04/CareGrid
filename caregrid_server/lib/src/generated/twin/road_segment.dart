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
import '../enums/road_status.dart' as _iralfy71;

/// A two-way road between two zones in the campus graph.
abstract class RoadSegment
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RoadSegment._({
    this.id,
    required this.campusId,
    required this.code,
    required this.name,
    required this.fromZone,
    required this.toZone,
    required this.lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
    this.path,
  }) : status = status ?? _iralfy71.RoadStatus.open,
       isOutsideCampus = isOutsideCampus ?? false;

  factory RoadSegment({
    int? id,
    required int campusId,
    required String code,
    required String name,
    required String fromZone,
    required String toZone,
    required int lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
    List<double>? path,
  }) = _RoadSegmentImpl;

  factory RoadSegment.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoadSegment(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      fromZone: jsonSerialization['fromZone'] as String,
      toZone: jsonSerialization['toZone'] as String,
      lengthMeters: jsonSerialization['lengthMeters'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _iralfy71.RoadStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      isOutsideCampus: jsonSerialization['isOutsideCampus'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['isOutsideCampus'],
            ),
      path: jsonSerialization['path'] == null
          ? null
          : _ighx06pg.Protocol().deserialize<List<double>>(
              jsonSerialization['path'],
            ),
    );
  }

  static final t = RoadSegmentTable();

  static const db = RoadSegmentRepository._();

  @override
  int? id;

  int campusId;

  /// Unique within its campus.
  String code;

  String name;

  String fromZone;

  String toZone;

  int lengthMeters;

  _iralfy71.RoadStatus status;

  bool isOutsideCampus;

  /// Drawn shape as flattened x,y canvas pairs from fromZone to toZone; null draws a straight line.
  List<double>? path;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RoadSegment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RoadSegment copyWith({
    int? id,
    int? campusId,
    String? code,
    String? name,
    String? fromZone,
    String? toZone,
    int? lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
    List<double>? path,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoadSegment',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      'fromZone': fromZone,
      'toZone': toZone,
      'lengthMeters': lengthMeters,
      'status': status.toJson(),
      'isOutsideCampus': isOutsideCampus,
      if (path != null) 'path': path?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoadSegment',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'name': name,
      'fromZone': fromZone,
      'toZone': toZone,
      'lengthMeters': lengthMeters,
      'status': status.toJson(),
      'isOutsideCampus': isOutsideCampus,
      if (path != null) 'path': path?.toJson(),
    };
  }

  static RoadSegmentInclude include() {
    return RoadSegmentInclude._();
  }

  static RoadSegmentIncludeList includeList({
    _is.WhereExpressionBuilder<RoadSegmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RoadSegmentTable>? orderBy,
    _is.OrderByListBuilder<RoadSegmentTable>? orderByList,
    RoadSegmentInclude? include,
  }) {
    return RoadSegmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RoadSegment.t),
      orderByList: orderByList?.call(RoadSegment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoadSegmentImpl extends RoadSegment {
  _RoadSegmentImpl({
    int? id,
    required int campusId,
    required String code,
    required String name,
    required String fromZone,
    required String toZone,
    required int lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
    List<double>? path,
  }) : super._(
         id: id,
         campusId: campusId,
         code: code,
         name: name,
         fromZone: fromZone,
         toZone: toZone,
         lengthMeters: lengthMeters,
         status: status,
         isOutsideCampus: isOutsideCampus,
         path: path,
       );

  /// Returns a shallow copy of this [RoadSegment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RoadSegment copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? code,
    String? name,
    String? fromZone,
    String? toZone,
    int? lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
    Object? path = _Undefined,
  }) {
    return RoadSegment(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      code: code ?? this.code,
      name: name ?? this.name,
      fromZone: fromZone ?? this.fromZone,
      toZone: toZone ?? this.toZone,
      lengthMeters: lengthMeters ?? this.lengthMeters,
      status: status ?? this.status,
      isOutsideCampus: isOutsideCampus ?? this.isOutsideCampus,
      path: path is List<double>? ? path : this.path?.map((e0) => e0).toList(),
    );
  }
}

class RoadSegmentUpdateTable extends _is.UpdateTable<RoadSegmentTable> {
  RoadSegmentUpdateTable(super.table);

  _is.ColumnValue<int, int> campusId(int value) => _is.ColumnValue(
    table.campusId,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> fromZone(String value) => _is.ColumnValue(
    table.fromZone,
    value,
  );

  _is.ColumnValue<String, String> toZone(String value) => _is.ColumnValue(
    table.toZone,
    value,
  );

  _is.ColumnValue<int, int> lengthMeters(int value) => _is.ColumnValue(
    table.lengthMeters,
    value,
  );

  _is.ColumnValue<_iralfy71.RoadStatus, _iralfy71.RoadStatus> status(
    _iralfy71.RoadStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<bool, bool> isOutsideCampus(bool value) => _is.ColumnValue(
    table.isOutsideCampus,
    value,
  );

  _is.ColumnValue<List<double>, List<double>> path(List<double>? value) =>
      _is.ColumnValue(
        table.path,
        value,
      );
}

class RoadSegmentTable extends _is.Table<int?> {
  RoadSegmentTable({super.tableRelation}) : super(tableName: 'road_segment') {
    updateTable = RoadSegmentUpdateTable(this);
    campusId = _is.ColumnInt(
      'campusId',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    fromZone = _is.ColumnString(
      'fromZone',
      this,
    );
    toZone = _is.ColumnString(
      'toZone',
      this,
    );
    lengthMeters = _is.ColumnInt(
      'lengthMeters',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    isOutsideCampus = _is.ColumnBool(
      'isOutsideCampus',
      this,
      hasDefault: true,
    );
    path = _is.ColumnSerializable<List<double>>(
      'path',
      this,
    );
  }

  late final RoadSegmentUpdateTable updateTable;

  late final _is.ColumnInt campusId;

  /// Unique within its campus.
  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnString fromZone;

  late final _is.ColumnString toZone;

  late final _is.ColumnInt lengthMeters;

  late final _is.ColumnEnum<_iralfy71.RoadStatus> status;

  late final _is.ColumnBool isOutsideCampus;

  /// Drawn shape as flattened x,y canvas pairs from fromZone to toZone; null draws a straight line.
  late final _is.ColumnSerializable<List<double>> path;

  @override
  List<_is.Column> get columns => [
    id,
    campusId,
    code,
    name,
    fromZone,
    toZone,
    lengthMeters,
    status,
    isOutsideCampus,
    path,
  ];
}

class RoadSegmentInclude extends _is.IncludeObject {
  RoadSegmentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RoadSegment.t;
}

class RoadSegmentIncludeList extends _is.IncludeList {
  RoadSegmentIncludeList._({
    _is.WhereExpressionBuilder<RoadSegmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RoadSegment.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RoadSegment.t;
}

class RoadSegmentRepository {
  const RoadSegmentRepository._();

  /// Returns a list of [RoadSegment]s matching the given query parameters.
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
  Future<List<RoadSegment>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RoadSegmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RoadSegmentTable>? orderBy,
    _is.OrderByListBuilder<RoadSegmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RoadSegment>(
      where: where?.call(RoadSegment.t),
      orderBy: orderBy?.call(RoadSegment.t),
      orderByList: orderByList?.call(RoadSegment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RoadSegment] matching the given query parameters.
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
  Future<RoadSegment?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RoadSegmentTable>? where,
    int? offset,
    _is.OrderByBuilder<RoadSegmentTable>? orderBy,
    _is.OrderByListBuilder<RoadSegmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RoadSegment>(
      where: where?.call(RoadSegment.t),
      orderBy: orderBy?.call(RoadSegment.t),
      orderByList: orderByList?.call(RoadSegment.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RoadSegment] by its [id] or null if no such row exists.
  Future<RoadSegment?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RoadSegment>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RoadSegment]s in the list and returns the inserted rows.
  ///
  /// The returned [RoadSegment]s will have their `id` fields set.
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
  Future<List<RoadSegment>> insert(
    _is.DatabaseSession session,
    List<RoadSegment> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RoadSegment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RoadSegment] and returns the inserted row.
  ///
  /// The returned [RoadSegment] will have its `id` field set.
  Future<RoadSegment> insertRow(
    _is.DatabaseSession session,
    RoadSegment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RoadSegment>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RoadSegment]s in the list and returns the resulting rows.
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
  /// The returned [RoadSegment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RoadSegment>> upsert(
    _is.DatabaseSession session,
    List<RoadSegment> rows, {
    required _is.ColumnSelections<RoadSegmentTable> conflictColumns,
    _is.ColumnSelections<RoadSegmentTable>? updateColumns,
    _is.WhereExpressionBuilder<RoadSegmentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RoadSegment>(
      rows,
      conflictColumns: conflictColumns(RoadSegment.t),
      updateColumns: updateColumns?.call(RoadSegment.t),
      updateWhere: updateWhere?.call(RoadSegment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RoadSegment] and returns the resulting row.
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
  /// The returned [RoadSegment] will have its `id` field set.
  Future<RoadSegment?> upsertRow(
    _is.DatabaseSession session,
    RoadSegment row, {
    required _is.ColumnSelections<RoadSegmentTable> conflictColumns,
    _is.ColumnSelections<RoadSegmentTable>? updateColumns,
    _is.WhereExpressionBuilder<RoadSegmentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RoadSegment>(
      row,
      conflictColumns: conflictColumns(RoadSegment.t),
      updateColumns: updateColumns?.call(RoadSegment.t),
      updateWhere: updateWhere?.call(RoadSegment.t),
      transaction: transaction,
    );
  }

  /// Updates all [RoadSegment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RoadSegment>> update(
    _is.DatabaseSession session,
    List<RoadSegment> rows, {
    _is.ColumnSelections<RoadSegmentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RoadSegment>(
      rows,
      columns: columns?.call(RoadSegment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RoadSegment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RoadSegment> updateRow(
    _is.DatabaseSession session,
    RoadSegment row, {
    _is.ColumnSelections<RoadSegmentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RoadSegment>(
      row,
      columns: columns?.call(RoadSegment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RoadSegment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RoadSegment?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RoadSegmentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RoadSegment>(
      id,
      columnValues: columnValues(RoadSegment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RoadSegment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RoadSegment>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RoadSegmentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RoadSegmentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RoadSegmentTable>? orderBy,
    _is.OrderByListBuilder<RoadSegmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RoadSegment>(
      columnValues: columnValues(RoadSegment.t.updateTable),
      where: where(RoadSegment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RoadSegment.t),
      orderByList: orderByList?.call(RoadSegment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RoadSegment]s in the list and returns the deleted rows.
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
  Future<List<RoadSegment>> delete(
    _is.DatabaseSession session,
    List<RoadSegment> rows, {
    _is.OrderByBuilder<RoadSegmentTable>? orderBy,
    _is.OrderByListBuilder<RoadSegmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RoadSegment>(
      rows,
      orderBy: orderBy?.call(RoadSegment.t),
      orderByList: orderByList?.call(RoadSegment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RoadSegment].
  Future<RoadSegment> deleteRow(
    _is.DatabaseSession session,
    RoadSegment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RoadSegment>(
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
  Future<List<RoadSegment>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RoadSegmentTable> where,
    _is.OrderByBuilder<RoadSegmentTable>? orderBy,
    _is.OrderByListBuilder<RoadSegmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RoadSegment>(
      where: where(RoadSegment.t),
      orderBy: orderBy?.call(RoadSegment.t),
      orderByList: orderByList?.call(RoadSegment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RoadSegmentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RoadSegment>(
      where: where?.call(RoadSegment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RoadSegment] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RoadSegmentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RoadSegment>(
      where: where(RoadSegment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
