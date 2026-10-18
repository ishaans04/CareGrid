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
import '../enums/event_type.dart' as _ikhu1dq5;
import '../readiness/stress_failure.dart' as _ia6zsb2k;

/// A compound-failure rehearsal: an emergency plus things going wrong at the same time.
abstract class StressScenario
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StressScenario._({
    this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.zoneCode,
    required this.eventType,
    required this.hour,
    required this.failures,
    bool? builtIn,
  }) : builtIn = builtIn ?? false;

  factory StressScenario({
    int? id,
    required String code,
    required String name,
    required String description,
    required String zoneCode,
    required _ikhu1dq5.EventType eventType,
    required int hour,
    required List<_ia6zsb2k.StressFailure> failures,
    bool? builtIn,
  }) = _StressScenarioImpl;

  factory StressScenario.fromJson(Map<String, dynamic> jsonSerialization) {
    return StressScenario(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      zoneCode: jsonSerialization['zoneCode'] as String,
      eventType: _ikhu1dq5.EventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      hour: jsonSerialization['hour'] as int,
      failures: _ighx06pg.Protocol().deserialize<List<_ia6zsb2k.StressFailure>>(
        jsonSerialization['failures'],
      ),
      builtIn: jsonSerialization['builtIn'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['builtIn']),
    );
  }

  static final t = StressScenarioTable();

  static const db = StressScenarioRepository._();

  @override
  int? id;

  String code;

  String name;

  String description;

  String zoneCode;

  _ikhu1dq5.EventType eventType;

  /// Local hour the emergency happens at (policies are time-aware).
  int hour;

  List<_ia6zsb2k.StressFailure> failures;

  bool builtIn;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StressScenario]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StressScenario copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    String? zoneCode,
    _ikhu1dq5.EventType? eventType,
    int? hour,
    List<_ia6zsb2k.StressFailure>? failures,
    bool? builtIn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StressScenario',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'description': description,
      'zoneCode': zoneCode,
      'eventType': eventType.toJson(),
      'hour': hour,
      'failures': failures.toJson(valueToJson: (v) => v.toJson()),
      'builtIn': builtIn,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StressScenario',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'description': description,
      'zoneCode': zoneCode,
      'eventType': eventType.toJson(),
      'hour': hour,
      'failures': failures.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'builtIn': builtIn,
    };
  }

  static StressScenarioInclude include() {
    return StressScenarioInclude._();
  }

  static StressScenarioIncludeList includeList({
    _is.WhereExpressionBuilder<StressScenarioTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StressScenarioTable>? orderBy,
    _is.OrderByListBuilder<StressScenarioTable>? orderByList,
    StressScenarioInclude? include,
  }) {
    return StressScenarioIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StressScenario.t),
      orderByList: orderByList?.call(StressScenario.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StressScenarioImpl extends StressScenario {
  _StressScenarioImpl({
    int? id,
    required String code,
    required String name,
    required String description,
    required String zoneCode,
    required _ikhu1dq5.EventType eventType,
    required int hour,
    required List<_ia6zsb2k.StressFailure> failures,
    bool? builtIn,
  }) : super._(
         id: id,
         code: code,
         name: name,
         description: description,
         zoneCode: zoneCode,
         eventType: eventType,
         hour: hour,
         failures: failures,
         builtIn: builtIn,
       );

  /// Returns a shallow copy of this [StressScenario]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StressScenario copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? description,
    String? zoneCode,
    _ikhu1dq5.EventType? eventType,
    int? hour,
    List<_ia6zsb2k.StressFailure>? failures,
    bool? builtIn,
  }) {
    return StressScenario(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      zoneCode: zoneCode ?? this.zoneCode,
      eventType: eventType ?? this.eventType,
      hour: hour ?? this.hour,
      failures: failures ?? this.failures.map((e0) => e0.copyWith()).toList(),
      builtIn: builtIn ?? this.builtIn,
    );
  }
}

class StressScenarioUpdateTable extends _is.UpdateTable<StressScenarioTable> {
  StressScenarioUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> zoneCode(String value) => _is.ColumnValue(
    table.zoneCode,
    value,
  );

  _is.ColumnValue<_ikhu1dq5.EventType, _ikhu1dq5.EventType> eventType(
    _ikhu1dq5.EventType value,
  ) => _is.ColumnValue(
    table.eventType,
    value,
  );

  _is.ColumnValue<int, int> hour(int value) => _is.ColumnValue(
    table.hour,
    value,
  );

  _is.ColumnValue<List<_ia6zsb2k.StressFailure>, List<_ia6zsb2k.StressFailure>>
  failures(List<_ia6zsb2k.StressFailure> value) => _is.ColumnValue(
    table.failures,
    value,
  );

  _is.ColumnValue<bool, bool> builtIn(bool value) => _is.ColumnValue(
    table.builtIn,
    value,
  );
}

class StressScenarioTable extends _is.Table<int?> {
  StressScenarioTable({super.tableRelation})
    : super(tableName: 'stress_scenario') {
    updateTable = StressScenarioUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    zoneCode = _is.ColumnString(
      'zoneCode',
      this,
    );
    eventType = _is.ColumnEnum(
      'eventType',
      this,
      _is.EnumSerialization.byName,
    );
    hour = _is.ColumnInt(
      'hour',
      this,
    );
    failures = _is.ColumnSerializable<List<_ia6zsb2k.StressFailure>>(
      'failures',
      this,
    );
    builtIn = _is.ColumnBool(
      'builtIn',
      this,
      hasDefault: true,
    );
  }

  late final StressScenarioUpdateTable updateTable;

  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  late final _is.ColumnString zoneCode;

  late final _is.ColumnEnum<_ikhu1dq5.EventType> eventType;

  /// Local hour the emergency happens at (policies are time-aware).
  late final _is.ColumnInt hour;

  late final _is.ColumnSerializable<List<_ia6zsb2k.StressFailure>> failures;

  late final _is.ColumnBool builtIn;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    name,
    description,
    zoneCode,
    eventType,
    hour,
    failures,
    builtIn,
  ];
}

class StressScenarioInclude extends _is.IncludeObject {
  StressScenarioInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StressScenario.t;
}

class StressScenarioIncludeList extends _is.IncludeList {
  StressScenarioIncludeList._({
    _is.WhereExpressionBuilder<StressScenarioTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StressScenario.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StressScenario.t;
}

class StressScenarioRepository {
  const StressScenarioRepository._();

  /// Returns a list of [StressScenario]s matching the given query parameters.
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
  Future<List<StressScenario>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StressScenarioTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StressScenarioTable>? orderBy,
    _is.OrderByListBuilder<StressScenarioTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StressScenario>(
      where: where?.call(StressScenario.t),
      orderBy: orderBy?.call(StressScenario.t),
      orderByList: orderByList?.call(StressScenario.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StressScenario] matching the given query parameters.
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
  Future<StressScenario?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StressScenarioTable>? where,
    int? offset,
    _is.OrderByBuilder<StressScenarioTable>? orderBy,
    _is.OrderByListBuilder<StressScenarioTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StressScenario>(
      where: where?.call(StressScenario.t),
      orderBy: orderBy?.call(StressScenario.t),
      orderByList: orderByList?.call(StressScenario.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StressScenario] by its [id] or null if no such row exists.
  Future<StressScenario?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StressScenario>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StressScenario]s in the list and returns the inserted rows.
  ///
  /// The returned [StressScenario]s will have their `id` fields set.
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
  Future<List<StressScenario>> insert(
    _is.DatabaseSession session,
    List<StressScenario> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StressScenario>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StressScenario] and returns the inserted row.
  ///
  /// The returned [StressScenario] will have its `id` field set.
  Future<StressScenario> insertRow(
    _is.DatabaseSession session,
    StressScenario row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StressScenario>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StressScenario]s in the list and returns the resulting rows.
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
  /// The returned [StressScenario]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StressScenario>> upsert(
    _is.DatabaseSession session,
    List<StressScenario> rows, {
    required _is.ColumnSelections<StressScenarioTable> conflictColumns,
    _is.ColumnSelections<StressScenarioTable>? updateColumns,
    _is.WhereExpressionBuilder<StressScenarioTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StressScenario>(
      rows,
      conflictColumns: conflictColumns(StressScenario.t),
      updateColumns: updateColumns?.call(StressScenario.t),
      updateWhere: updateWhere?.call(StressScenario.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StressScenario] and returns the resulting row.
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
  /// The returned [StressScenario] will have its `id` field set.
  Future<StressScenario?> upsertRow(
    _is.DatabaseSession session,
    StressScenario row, {
    required _is.ColumnSelections<StressScenarioTable> conflictColumns,
    _is.ColumnSelections<StressScenarioTable>? updateColumns,
    _is.WhereExpressionBuilder<StressScenarioTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StressScenario>(
      row,
      conflictColumns: conflictColumns(StressScenario.t),
      updateColumns: updateColumns?.call(StressScenario.t),
      updateWhere: updateWhere?.call(StressScenario.t),
      transaction: transaction,
    );
  }

  /// Updates all [StressScenario]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StressScenario>> update(
    _is.DatabaseSession session,
    List<StressScenario> rows, {
    _is.ColumnSelections<StressScenarioTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StressScenario>(
      rows,
      columns: columns?.call(StressScenario.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StressScenario]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StressScenario> updateRow(
    _is.DatabaseSession session,
    StressScenario row, {
    _is.ColumnSelections<StressScenarioTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StressScenario>(
      row,
      columns: columns?.call(StressScenario.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StressScenario] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StressScenario?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StressScenarioUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StressScenario>(
      id,
      columnValues: columnValues(StressScenario.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StressScenario]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StressScenario>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StressScenarioUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StressScenarioTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StressScenarioTable>? orderBy,
    _is.OrderByListBuilder<StressScenarioTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StressScenario>(
      columnValues: columnValues(StressScenario.t.updateTable),
      where: where(StressScenario.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StressScenario.t),
      orderByList: orderByList?.call(StressScenario.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StressScenario]s in the list and returns the deleted rows.
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
  Future<List<StressScenario>> delete(
    _is.DatabaseSession session,
    List<StressScenario> rows, {
    _is.OrderByBuilder<StressScenarioTable>? orderBy,
    _is.OrderByListBuilder<StressScenarioTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StressScenario>(
      rows,
      orderBy: orderBy?.call(StressScenario.t),
      orderByList: orderByList?.call(StressScenario.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StressScenario].
  Future<StressScenario> deleteRow(
    _is.DatabaseSession session,
    StressScenario row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StressScenario>(
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
  Future<List<StressScenario>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StressScenarioTable> where,
    _is.OrderByBuilder<StressScenarioTable>? orderBy,
    _is.OrderByListBuilder<StressScenarioTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StressScenario>(
      where: where(StressScenario.t),
      orderBy: orderBy?.call(StressScenario.t),
      orderByList: orderByList?.call(StressScenario.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StressScenarioTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StressScenario>(
      where: where?.call(StressScenario.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StressScenario] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StressScenarioTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StressScenario>(
      where: where(StressScenario.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
