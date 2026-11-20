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
import '../enums/asset_health.dart' as _ienw8okx;

/// An existing campus camera used as a sensor. CareGrid integrates cameras; it does not replace them.
abstract class Camera implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Camera._({
    this.id,
    required this.campusId,
    required this.code,
    required this.zoneCode,
    required this.label,
    _ienw8okx.AssetHealth? health,
    required this.adjacentCameras,
    bool? privacyMasked,
    this.x,
    this.y,
    this.rangeMeters,
  }) : health = health ?? _ienw8okx.AssetHealth.online,
       privacyMasked = privacyMasked ?? true;

  factory Camera({
    int? id,
    required int campusId,
    required String code,
    required String zoneCode,
    required String label,
    _ienw8okx.AssetHealth? health,
    required List<String> adjacentCameras,
    bool? privacyMasked,
    double? x,
    double? y,
    double? rangeMeters,
  }) = _CameraImpl;

  factory Camera.fromJson(Map<String, dynamic> jsonSerialization) {
    return Camera(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      code: jsonSerialization['code'] as String,
      zoneCode: jsonSerialization['zoneCode'] as String,
      label: jsonSerialization['label'] as String,
      health: jsonSerialization['health'] == null
          ? null
          : _ienw8okx.AssetHealth.fromJson(
              (jsonSerialization['health'] as String),
            ),
      adjacentCameras: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['adjacentCameras'],
      ),
      privacyMasked: jsonSerialization['privacyMasked'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['privacyMasked']),
      x: (jsonSerialization['x'] as num?)?.toDouble(),
      y: (jsonSerialization['y'] as num?)?.toDouble(),
      rangeMeters: (jsonSerialization['rangeMeters'] as num?)?.toDouble(),
    );
  }

  static final t = CameraTable();

  static const db = CameraRepository._();

  @override
  int? id;

  int campusId;

  /// Unique within its campus.
  String code;

  String zoneCode;

  String label;

  _ienw8okx.AssetHealth health;

  /// Cameras that can corroborate an event seen by this one.
  List<String> adjacentCameras;

  /// Faces and identities are never processed; masked cameras only emit anonymous track events.
  bool privacyMasked;

  /// Mounting point in canvas units; null places the camera at its zone.
  double? x;

  double? y;

  /// Approximate useful viewing radius in metres, for coverage planning.
  double? rangeMeters;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Camera]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Camera copyWith({
    int? id,
    int? campusId,
    String? code,
    String? zoneCode,
    String? label,
    _ienw8okx.AssetHealth? health,
    List<String>? adjacentCameras,
    bool? privacyMasked,
    double? x,
    double? y,
    double? rangeMeters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Camera',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'zoneCode': zoneCode,
      'label': label,
      'health': health.toJson(),
      'adjacentCameras': adjacentCameras.toJson(),
      'privacyMasked': privacyMasked,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (rangeMeters != null) 'rangeMeters': rangeMeters,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Camera',
      if (id != null) 'id': id,
      'campusId': campusId,
      'code': code,
      'zoneCode': zoneCode,
      'label': label,
      'health': health.toJson(),
      'adjacentCameras': adjacentCameras.toJson(),
      'privacyMasked': privacyMasked,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (rangeMeters != null) 'rangeMeters': rangeMeters,
    };
  }

  static CameraInclude include() {
    return CameraInclude._();
  }

  static CameraIncludeList includeList({
    _is.WhereExpressionBuilder<CameraTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CameraTable>? orderBy,
    _is.OrderByListBuilder<CameraTable>? orderByList,
    CameraInclude? include,
  }) {
    return CameraIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Camera.t),
      orderByList: orderByList?.call(Camera.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CameraImpl extends Camera {
  _CameraImpl({
    int? id,
    required int campusId,
    required String code,
    required String zoneCode,
    required String label,
    _ienw8okx.AssetHealth? health,
    required List<String> adjacentCameras,
    bool? privacyMasked,
    double? x,
    double? y,
    double? rangeMeters,
  }) : super._(
         id: id,
         campusId: campusId,
         code: code,
         zoneCode: zoneCode,
         label: label,
         health: health,
         adjacentCameras: adjacentCameras,
         privacyMasked: privacyMasked,
         x: x,
         y: y,
         rangeMeters: rangeMeters,
       );

  /// Returns a shallow copy of this [Camera]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Camera copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? code,
    String? zoneCode,
    String? label,
    _ienw8okx.AssetHealth? health,
    List<String>? adjacentCameras,
    bool? privacyMasked,
    Object? x = _Undefined,
    Object? y = _Undefined,
    Object? rangeMeters = _Undefined,
  }) {
    return Camera(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      code: code ?? this.code,
      zoneCode: zoneCode ?? this.zoneCode,
      label: label ?? this.label,
      health: health ?? this.health,
      adjacentCameras:
          adjacentCameras ?? this.adjacentCameras.map((e0) => e0).toList(),
      privacyMasked: privacyMasked ?? this.privacyMasked,
      x: x is double? ? x : this.x,
      y: y is double? ? y : this.y,
      rangeMeters: rangeMeters is double? ? rangeMeters : this.rangeMeters,
    );
  }
}

class CameraUpdateTable extends _is.UpdateTable<CameraTable> {
  CameraUpdateTable(super.table);

  _is.ColumnValue<int, int> campusId(int value) => _is.ColumnValue(
    table.campusId,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> zoneCode(String value) => _is.ColumnValue(
    table.zoneCode,
    value,
  );

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<_ienw8okx.AssetHealth, _ienw8okx.AssetHealth> health(
    _ienw8okx.AssetHealth value,
  ) => _is.ColumnValue(
    table.health,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> adjacentCameras(
    List<String> value,
  ) => _is.ColumnValue(
    table.adjacentCameras,
    value,
  );

  _is.ColumnValue<bool, bool> privacyMasked(bool value) => _is.ColumnValue(
    table.privacyMasked,
    value,
  );

  _is.ColumnValue<double, double> x(double? value) => _is.ColumnValue(
    table.x,
    value,
  );

  _is.ColumnValue<double, double> y(double? value) => _is.ColumnValue(
    table.y,
    value,
  );

  _is.ColumnValue<double, double> rangeMeters(double? value) => _is.ColumnValue(
    table.rangeMeters,
    value,
  );
}

class CameraTable extends _is.Table<int?> {
  CameraTable({super.tableRelation}) : super(tableName: 'camera') {
    updateTable = CameraUpdateTable(this);
    campusId = _is.ColumnInt(
      'campusId',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    zoneCode = _is.ColumnString(
      'zoneCode',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    health = _is.ColumnEnum(
      'health',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    adjacentCameras = _is.ColumnSerializable<List<String>>(
      'adjacentCameras',
      this,
    );
    privacyMasked = _is.ColumnBool(
      'privacyMasked',
      this,
      hasDefault: true,
    );
    x = _is.ColumnDouble(
      'x',
      this,
    );
    y = _is.ColumnDouble(
      'y',
      this,
    );
    rangeMeters = _is.ColumnDouble(
      'rangeMeters',
      this,
    );
  }

  late final CameraUpdateTable updateTable;

  late final _is.ColumnInt campusId;

  /// Unique within its campus.
  late final _is.ColumnString code;

  late final _is.ColumnString zoneCode;

  late final _is.ColumnString label;

  late final _is.ColumnEnum<_ienw8okx.AssetHealth> health;

  /// Cameras that can corroborate an event seen by this one.
  late final _is.ColumnSerializable<List<String>> adjacentCameras;

  /// Faces and identities are never processed; masked cameras only emit anonymous track events.
  late final _is.ColumnBool privacyMasked;

  /// Mounting point in canvas units; null places the camera at its zone.
  late final _is.ColumnDouble x;

  late final _is.ColumnDouble y;

  /// Approximate useful viewing radius in metres, for coverage planning.
  late final _is.ColumnDouble rangeMeters;

  @override
  List<_is.Column> get columns => [
    id,
    campusId,
    code,
    zoneCode,
    label,
    health,
    adjacentCameras,
    privacyMasked,
    x,
    y,
    rangeMeters,
  ];
}

class CameraInclude extends _is.IncludeObject {
  CameraInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Camera.t;
}

class CameraIncludeList extends _is.IncludeList {
  CameraIncludeList._({
    _is.WhereExpressionBuilder<CameraTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Camera.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Camera.t;
}

class CameraRepository {
  const CameraRepository._();

  /// Returns a list of [Camera]s matching the given query parameters.
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
  Future<List<Camera>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CameraTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CameraTable>? orderBy,
    _is.OrderByListBuilder<CameraTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Camera>(
      where: where?.call(Camera.t),
      orderBy: orderBy?.call(Camera.t),
      orderByList: orderByList?.call(Camera.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Camera] matching the given query parameters.
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
  Future<Camera?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CameraTable>? where,
    int? offset,
    _is.OrderByBuilder<CameraTable>? orderBy,
    _is.OrderByListBuilder<CameraTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Camera>(
      where: where?.call(Camera.t),
      orderBy: orderBy?.call(Camera.t),
      orderByList: orderByList?.call(Camera.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Camera] by its [id] or null if no such row exists.
  Future<Camera?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Camera>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Camera]s in the list and returns the inserted rows.
  ///
  /// The returned [Camera]s will have their `id` fields set.
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
  Future<List<Camera>> insert(
    _is.DatabaseSession session,
    List<Camera> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Camera>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Camera] and returns the inserted row.
  ///
  /// The returned [Camera] will have its `id` field set.
  Future<Camera> insertRow(
    _is.DatabaseSession session,
    Camera row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Camera>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Camera]s in the list and returns the resulting rows.
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
  /// The returned [Camera]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Camera>> upsert(
    _is.DatabaseSession session,
    List<Camera> rows, {
    required _is.ColumnSelections<CameraTable> conflictColumns,
    _is.ColumnSelections<CameraTable>? updateColumns,
    _is.WhereExpressionBuilder<CameraTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Camera>(
      rows,
      conflictColumns: conflictColumns(Camera.t),
      updateColumns: updateColumns?.call(Camera.t),
      updateWhere: updateWhere?.call(Camera.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Camera] and returns the resulting row.
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
  /// The returned [Camera] will have its `id` field set.
  Future<Camera?> upsertRow(
    _is.DatabaseSession session,
    Camera row, {
    required _is.ColumnSelections<CameraTable> conflictColumns,
    _is.ColumnSelections<CameraTable>? updateColumns,
    _is.WhereExpressionBuilder<CameraTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Camera>(
      row,
      conflictColumns: conflictColumns(Camera.t),
      updateColumns: updateColumns?.call(Camera.t),
      updateWhere: updateWhere?.call(Camera.t),
      transaction: transaction,
    );
  }

  /// Updates all [Camera]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Camera>> update(
    _is.DatabaseSession session,
    List<Camera> rows, {
    _is.ColumnSelections<CameraTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Camera>(
      rows,
      columns: columns?.call(Camera.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Camera]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Camera> updateRow(
    _is.DatabaseSession session,
    Camera row, {
    _is.ColumnSelections<CameraTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Camera>(
      row,
      columns: columns?.call(Camera.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Camera] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Camera?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CameraUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Camera>(
      id,
      columnValues: columnValues(Camera.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Camera]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Camera>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CameraUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CameraTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CameraTable>? orderBy,
    _is.OrderByListBuilder<CameraTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Camera>(
      columnValues: columnValues(Camera.t.updateTable),
      where: where(Camera.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Camera.t),
      orderByList: orderByList?.call(Camera.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Camera]s in the list and returns the deleted rows.
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
  Future<List<Camera>> delete(
    _is.DatabaseSession session,
    List<Camera> rows, {
    _is.OrderByBuilder<CameraTable>? orderBy,
    _is.OrderByListBuilder<CameraTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Camera>(
      rows,
      orderBy: orderBy?.call(Camera.t),
      orderByList: orderByList?.call(Camera.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Camera].
  Future<Camera> deleteRow(
    _is.DatabaseSession session,
    Camera row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Camera>(
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
  Future<List<Camera>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CameraTable> where,
    _is.OrderByBuilder<CameraTable>? orderBy,
    _is.OrderByListBuilder<CameraTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Camera>(
      where: where(Camera.t),
      orderBy: orderBy?.call(Camera.t),
      orderByList: orderByList?.call(Camera.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CameraTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Camera>(
      where: where?.call(Camera.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Camera] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CameraTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Camera>(
      where: where(Camera.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
