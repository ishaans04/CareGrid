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
import '../enums/user_role.dart' as _ifev4lwy;

/// A seeded CareGrid user. The prototype signs in with handle + PIN; production would use campus SSO.
abstract class AppUser
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AppUser._({
    this.id,
    required this.handle,
    required this.displayName,
    required this.role,
    required this.title,
    this.responderCode,
    this.pin,
  });

  factory AppUser({
    int? id,
    required String handle,
    required String displayName,
    required _ifev4lwy.UserRole role,
    required String title,
    String? responderCode,
    String? pin,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      handle: jsonSerialization['handle'] as String,
      displayName: jsonSerialization['displayName'] as String,
      role: _ifev4lwy.UserRole.fromJson((jsonSerialization['role'] as String)),
      title: jsonSerialization['title'] as String,
      responderCode: jsonSerialization['responderCode'] as String?,
      pin: jsonSerialization['pin'] as String?,
    );
  }

  static final t = AppUserTable();

  static const db = AppUserRepository._();

  @override
  int? id;

  String handle;

  String displayName;

  _ifev4lwy.UserRole role;

  /// Job title shown in the UI, e.g. 'Night shift command operator'.
  String title;

  /// Responder unit this user operates (responder role only).
  String? responderCode;

  /// Demo PIN. Never sent to clients.
  String? pin;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AppUser copyWith({
    int? id,
    String? handle,
    String? displayName,
    _ifev4lwy.UserRole? role,
    String? title,
    String? responderCode,
    String? pin,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'handle': handle,
      'displayName': displayName,
      'role': role.toJson(),
      'title': title,
      if (responderCode != null) 'responderCode': responderCode,
      if (pin != null) 'pin': pin,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'handle': handle,
      'displayName': displayName,
      'role': role.toJson(),
      'title': title,
      if (responderCode != null) 'responderCode': responderCode,
    };
  }

  static AppUserInclude include() {
    return AppUserInclude._();
  }

  static AppUserIncludeList includeList({
    _is.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppUserTable>? orderBy,
    _is.OrderByListBuilder<AppUserTable>? orderByList,
    AppUserInclude? include,
  }) {
    return AppUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String handle,
    required String displayName,
    required _ifev4lwy.UserRole role,
    required String title,
    String? responderCode,
    String? pin,
  }) : super._(
         id: id,
         handle: handle,
         displayName: displayName,
         role: role,
         title: title,
         responderCode: responderCode,
         pin: pin,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? handle,
    String? displayName,
    _ifev4lwy.UserRole? role,
    String? title,
    Object? responderCode = _Undefined,
    Object? pin = _Undefined,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      title: title ?? this.title,
      responderCode: responderCode is String?
          ? responderCode
          : this.responderCode,
      pin: pin is String? ? pin : this.pin,
    );
  }
}

class AppUserUpdateTable extends _is.UpdateTable<AppUserTable> {
  AppUserUpdateTable(super.table);

  _is.ColumnValue<String, String> handle(String value) => _is.ColumnValue(
    table.handle,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<_ifev4lwy.UserRole, _ifev4lwy.UserRole> role(
    _ifev4lwy.UserRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> responderCode(String? value) =>
      _is.ColumnValue(
        table.responderCode,
        value,
      );

  _is.ColumnValue<String, String> pin(String? value) => _is.ColumnValue(
    table.pin,
    value,
  );
}

class AppUserTable extends _is.Table<int?> {
  AppUserTable({super.tableRelation}) : super(tableName: 'app_user') {
    updateTable = AppUserUpdateTable(this);
    handle = _is.ColumnString(
      'handle',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    responderCode = _is.ColumnString(
      'responderCode',
      this,
    );
    pin = _is.ColumnString(
      'pin',
      this,
    );
  }

  late final AppUserUpdateTable updateTable;

  late final _is.ColumnString handle;

  late final _is.ColumnString displayName;

  late final _is.ColumnEnum<_ifev4lwy.UserRole> role;

  /// Job title shown in the UI, e.g. 'Night shift command operator'.
  late final _is.ColumnString title;

  /// Responder unit this user operates (responder role only).
  late final _is.ColumnString responderCode;

  /// Demo PIN. Never sent to clients.
  late final _is.ColumnString pin;

  @override
  List<_is.Column> get columns => [
    id,
    handle,
    displayName,
    role,
    title,
    responderCode,
    pin,
  ];
}

class AppUserInclude extends _is.IncludeObject {
  AppUserInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AppUser.t;
}

class AppUserIncludeList extends _is.IncludeList {
  AppUserIncludeList._({
    _is.WhereExpressionBuilder<AppUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppUser.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AppUser.t;
}

class AppUserRepository {
  const AppUserRepository._();

  /// Returns a list of [AppUser]s matching the given query parameters.
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
  Future<List<AppUser>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppUserTable>? orderBy,
    _is.OrderByListBuilder<AppUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppUser>(
      where: where?.call(AppUser.t),
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppUser] matching the given query parameters.
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
  Future<AppUser?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppUserTable>? where,
    int? offset,
    _is.OrderByBuilder<AppUserTable>? orderBy,
    _is.OrderByListBuilder<AppUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppUser>(
      where: where?.call(AppUser.t),
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppUser] by its [id] or null if no such row exists.
  Future<AppUser?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppUser>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppUser]s in the list and returns the inserted rows.
  ///
  /// The returned [AppUser]s will have their `id` fields set.
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
  Future<List<AppUser>> insert(
    _is.DatabaseSession session,
    List<AppUser> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AppUser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AppUser] and returns the inserted row.
  ///
  /// The returned [AppUser] will have its `id` field set.
  Future<AppUser> insertRow(
    _is.DatabaseSession session,
    AppUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppUser>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AppUser]s in the list and returns the resulting rows.
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
  /// The returned [AppUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppUser>> upsert(
    _is.DatabaseSession session,
    List<AppUser> rows, {
    required _is.ColumnSelections<AppUserTable> conflictColumns,
    _is.ColumnSelections<AppUserTable>? updateColumns,
    _is.WhereExpressionBuilder<AppUserTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AppUser>(
      rows,
      conflictColumns: conflictColumns(AppUser.t),
      updateColumns: updateColumns?.call(AppUser.t),
      updateWhere: updateWhere?.call(AppUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AppUser] and returns the resulting row.
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
  /// The returned [AppUser] will have its `id` field set.
  Future<AppUser?> upsertRow(
    _is.DatabaseSession session,
    AppUser row, {
    required _is.ColumnSelections<AppUserTable> conflictColumns,
    _is.ColumnSelections<AppUserTable>? updateColumns,
    _is.WhereExpressionBuilder<AppUserTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AppUser>(
      row,
      conflictColumns: conflictColumns(AppUser.t),
      updateColumns: updateColumns?.call(AppUser.t),
      updateWhere: updateWhere?.call(AppUser.t),
      transaction: transaction,
    );
  }

  /// Updates all [AppUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppUser>> update(
    _is.DatabaseSession session,
    List<AppUser> rows, {
    _is.ColumnSelections<AppUserTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AppUser>(
      rows,
      columns: columns?.call(AppUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AppUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppUser> updateRow(
    _is.DatabaseSession session,
    AppUser row, {
    _is.ColumnSelections<AppUserTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppUser>(
      row,
      columns: columns?.call(AppUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppUser?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AppUserUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AppUser>(
      id,
      columnValues: columnValues(AppUser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppUser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppUser>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AppUserUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AppUserTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppUserTable>? orderBy,
    _is.OrderByListBuilder<AppUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AppUser>(
      columnValues: columnValues(AppUser.t.updateTable),
      where: where(AppUser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AppUser]s in the list and returns the deleted rows.
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
  Future<List<AppUser>> delete(
    _is.DatabaseSession session,
    List<AppUser> rows, {
    _is.OrderByBuilder<AppUserTable>? orderBy,
    _is.OrderByListBuilder<AppUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AppUser>(
      rows,
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AppUser].
  Future<AppUser> deleteRow(
    _is.DatabaseSession session,
    AppUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppUser>(
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
  Future<List<AppUser>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppUserTable> where,
    _is.OrderByBuilder<AppUserTable>? orderBy,
    _is.OrderByListBuilder<AppUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AppUser>(
      where: where(AppUser.t),
      orderBy: orderBy?.call(AppUser.t),
      orderByList: orderByList?.call(AppUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppUserTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AppUser>(
      where: where?.call(AppUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppUser] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppUserTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppUser>(
      where: where(AppUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
