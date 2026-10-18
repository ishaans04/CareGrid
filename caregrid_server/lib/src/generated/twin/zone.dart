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
import '../enums/zone_type.dart' as _i7qzwj5g;

/// A node of the campus digital twin: a building, a gate, a road junction or a point outside campus.
abstract class Zone implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Zone._({
    this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.x,
    required this.y,
    this.description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
  }) : isOpen = isOpen ?? true,
       emergencyOverride = emergencyOverride ?? false,
       isRestricted = isRestricted ?? false,
       privacySensitive = privacySensitive ?? false;

  factory Zone({
    int? id,
    required String code,
    required String name,
    required _i7qzwj5g.ZoneType type,
    required double x,
    required double y,
    String? description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
  }) = _ZoneImpl;

  factory Zone.fromJson(Map<String, dynamic> jsonSerialization) {
    return Zone(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      type: _i7qzwj5g.ZoneType.fromJson((jsonSerialization['type'] as String)),
      x: (jsonSerialization['x'] as num).toDouble(),
      y: (jsonSerialization['y'] as num).toDouble(),
      description: jsonSerialization['description'] as String?,
      isOpen: jsonSerialization['isOpen'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
      emergencyOverride: jsonSerialization['emergencyOverride'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['emergencyOverride'],
            ),
      isRestricted: jsonSerialization['isRestricted'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isRestricted']),
      privacySensitive: jsonSerialization['privacySensitive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['privacySensitive'],
            ),
    );
  }

  static final t = ZoneTable();

  static const db = ZoneRepository._();

  @override
  int? id;

  /// Stable short code, e.g. HB for Birch Hostel.
  String code;

  String name;

  _i7qzwj5g.ZoneType type;

  /// Schematic map position (0..1000 x 0..700 canvas units).
  double x;

  double y;

  String? description;

  /// Gates only: whether vehicles can pass right now.
  bool isOpen;

  /// Gates only: closed gate that can be remotely opened for emergency vehicles.
  bool emergencyOverride;

  /// Restricted zones (labs, server rooms) trigger access policies.
  bool isRestricted;

  /// Privacy-sensitive zones only expose minimum context to non-command roles.
  bool privacySensitive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Zone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Zone copyWith({
    int? id,
    String? code,
    String? name,
    _i7qzwj5g.ZoneType? type,
    double? x,
    double? y,
    String? description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Zone',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'type': type.toJson(),
      'x': x,
      'y': y,
      if (description != null) 'description': description,
      'isOpen': isOpen,
      'emergencyOverride': emergencyOverride,
      'isRestricted': isRestricted,
      'privacySensitive': privacySensitive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Zone',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'type': type.toJson(),
      'x': x,
      'y': y,
      if (description != null) 'description': description,
      'isOpen': isOpen,
      'emergencyOverride': emergencyOverride,
      'isRestricted': isRestricted,
      'privacySensitive': privacySensitive,
    };
  }

  static ZoneInclude include() {
    return ZoneInclude._();
  }

  static ZoneIncludeList includeList({
    _is.WhereExpressionBuilder<ZoneTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ZoneTable>? orderBy,
    _is.OrderByListBuilder<ZoneTable>? orderByList,
    ZoneInclude? include,
  }) {
    return ZoneIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Zone.t),
      orderByList: orderByList?.call(Zone.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ZoneImpl extends Zone {
  _ZoneImpl({
    int? id,
    required String code,
    required String name,
    required _i7qzwj5g.ZoneType type,
    required double x,
    required double y,
    String? description,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
  }) : super._(
         id: id,
         code: code,
         name: name,
         type: type,
         x: x,
         y: y,
         description: description,
         isOpen: isOpen,
         emergencyOverride: emergencyOverride,
         isRestricted: isRestricted,
         privacySensitive: privacySensitive,
       );

  /// Returns a shallow copy of this [Zone]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Zone copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    _i7qzwj5g.ZoneType? type,
    double? x,
    double? y,
    Object? description = _Undefined,
    bool? isOpen,
    bool? emergencyOverride,
    bool? isRestricted,
    bool? privacySensitive,
  }) {
    return Zone(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      description: description is String? ? description : this.description,
      isOpen: isOpen ?? this.isOpen,
      emergencyOverride: emergencyOverride ?? this.emergencyOverride,
      isRestricted: isRestricted ?? this.isRestricted,
      privacySensitive: privacySensitive ?? this.privacySensitive,
    );
  }
}

class ZoneUpdateTable extends _is.UpdateTable<ZoneTable> {
  ZoneUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_i7qzwj5g.ZoneType, _i7qzwj5g.ZoneType> type(
    _i7qzwj5g.ZoneType value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<double, double> x(double value) => _is.ColumnValue(
    table.x,
    value,
  );

  _is.ColumnValue<double, double> y(double value) => _is.ColumnValue(
    table.y,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<bool, bool> isOpen(bool value) => _is.ColumnValue(
    table.isOpen,
    value,
  );

  _is.ColumnValue<bool, bool> emergencyOverride(bool value) => _is.ColumnValue(
    table.emergencyOverride,
    value,
  );

  _is.ColumnValue<bool, bool> isRestricted(bool value) => _is.ColumnValue(
    table.isRestricted,
    value,
  );

  _is.ColumnValue<bool, bool> privacySensitive(bool value) => _is.ColumnValue(
    table.privacySensitive,
    value,
  );
}

class ZoneTable extends _is.Table<int?> {
  ZoneTable({super.tableRelation}) : super(tableName: 'zone') {
    updateTable = ZoneUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    x = _is.ColumnDouble(
      'x',
      this,
    );
    y = _is.ColumnDouble(
      'y',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    isOpen = _is.ColumnBool(
      'isOpen',
      this,
      hasDefault: true,
    );
    emergencyOverride = _is.ColumnBool(
      'emergencyOverride',
      this,
      hasDefault: true,
    );
    isRestricted = _is.ColumnBool(
      'isRestricted',
      this,
      hasDefault: true,
    );
    privacySensitive = _is.ColumnBool(
      'privacySensitive',
      this,
      hasDefault: true,
    );
  }

  late final ZoneUpdateTable updateTable;

  /// Stable short code, e.g. HB for Birch Hostel.
  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnEnum<_i7qzwj5g.ZoneType> type;

  /// Schematic map position (0..1000 x 0..700 canvas units).
  late final _is.ColumnDouble x;

  late final _is.ColumnDouble y;

  late final _is.ColumnString description;

  /// Gates only: whether vehicles can pass right now.
  late final _is.ColumnBool isOpen;

  /// Gates only: closed gate that can be remotely opened for emergency vehicles.
  late final _is.ColumnBool emergencyOverride;

  /// Restricted zones (labs, server rooms) trigger access policies.
  late final _is.ColumnBool isRestricted;

  /// Privacy-sensitive zones only expose minimum context to non-command roles.
  late final _is.ColumnBool privacySensitive;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    name,
    type,
    x,
    y,
    description,
    isOpen,
    emergencyOverride,
    isRestricted,
    privacySensitive,
  ];
}

class ZoneInclude extends _is.IncludeObject {
  ZoneInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Zone.t;
}

class ZoneIncludeList extends _is.IncludeList {
  ZoneIncludeList._({
    _is.WhereExpressionBuilder<ZoneTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Zone.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Zone.t;
}

class ZoneRepository {
  const ZoneRepository._();

  /// Returns a list of [Zone]s matching the given query parameters.
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
  Future<List<Zone>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ZoneTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ZoneTable>? orderBy,
    _is.OrderByListBuilder<ZoneTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Zone>(
      where: where?.call(Zone.t),
      orderBy: orderBy?.call(Zone.t),
      orderByList: orderByList?.call(Zone.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Zone] matching the given query parameters.
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
  Future<Zone?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ZoneTable>? where,
    int? offset,
    _is.OrderByBuilder<ZoneTable>? orderBy,
    _is.OrderByListBuilder<ZoneTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Zone>(
      where: where?.call(Zone.t),
      orderBy: orderBy?.call(Zone.t),
      orderByList: orderByList?.call(Zone.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Zone] by its [id] or null if no such row exists.
  Future<Zone?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Zone>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Zone]s in the list and returns the inserted rows.
  ///
  /// The returned [Zone]s will have their `id` fields set.
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
  Future<List<Zone>> insert(
    _is.DatabaseSession session,
    List<Zone> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Zone>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Zone] and returns the inserted row.
  ///
  /// The returned [Zone] will have its `id` field set.
  Future<Zone> insertRow(
    _is.DatabaseSession session,
    Zone row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Zone>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Zone]s in the list and returns the resulting rows.
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
  /// The returned [Zone]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Zone>> upsert(
    _is.DatabaseSession session,
    List<Zone> rows, {
    required _is.ColumnSelections<ZoneTable> conflictColumns,
    _is.ColumnSelections<ZoneTable>? updateColumns,
    _is.WhereExpressionBuilder<ZoneTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Zone>(
      rows,
      conflictColumns: conflictColumns(Zone.t),
      updateColumns: updateColumns?.call(Zone.t),
      updateWhere: updateWhere?.call(Zone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Zone] and returns the resulting row.
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
  /// The returned [Zone] will have its `id` field set.
  Future<Zone?> upsertRow(
    _is.DatabaseSession session,
    Zone row, {
    required _is.ColumnSelections<ZoneTable> conflictColumns,
    _is.ColumnSelections<ZoneTable>? updateColumns,
    _is.WhereExpressionBuilder<ZoneTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Zone>(
      row,
      conflictColumns: conflictColumns(Zone.t),
      updateColumns: updateColumns?.call(Zone.t),
      updateWhere: updateWhere?.call(Zone.t),
      transaction: transaction,
    );
  }

  /// Updates all [Zone]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Zone>> update(
    _is.DatabaseSession session,
    List<Zone> rows, {
    _is.ColumnSelections<ZoneTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Zone>(
      rows,
      columns: columns?.call(Zone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Zone]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Zone> updateRow(
    _is.DatabaseSession session,
    Zone row, {
    _is.ColumnSelections<ZoneTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Zone>(
      row,
      columns: columns?.call(Zone.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Zone] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Zone?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ZoneUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Zone>(
      id,
      columnValues: columnValues(Zone.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Zone]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Zone>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ZoneUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ZoneTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ZoneTable>? orderBy,
    _is.OrderByListBuilder<ZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Zone>(
      columnValues: columnValues(Zone.t.updateTable),
      where: where(Zone.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Zone.t),
      orderByList: orderByList?.call(Zone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Zone]s in the list and returns the deleted rows.
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
  Future<List<Zone>> delete(
    _is.DatabaseSession session,
    List<Zone> rows, {
    _is.OrderByBuilder<ZoneTable>? orderBy,
    _is.OrderByListBuilder<ZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Zone>(
      rows,
      orderBy: orderBy?.call(Zone.t),
      orderByList: orderByList?.call(Zone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Zone].
  Future<Zone> deleteRow(
    _is.DatabaseSession session,
    Zone row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Zone>(
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
  Future<List<Zone>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ZoneTable> where,
    _is.OrderByBuilder<ZoneTable>? orderBy,
    _is.OrderByListBuilder<ZoneTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Zone>(
      where: where(Zone.t),
      orderBy: orderBy?.call(Zone.t),
      orderByList: orderByList?.call(Zone.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ZoneTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Zone>(
      where: where?.call(Zone.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Zone] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ZoneTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Zone>(
      where: where(Zone.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
