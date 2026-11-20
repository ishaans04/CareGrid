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

/// A campus served by this CareGrid deployment. Every operational record (twin, incidents, units, users, audit) belongs to exactly one campus, and every query is scoped to the caller's campus.
abstract class Campus implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Campus._({
    this.id,
    required this.code,
    required this.name,
    required this.shortName,
    this.city,
    this.description,
    required this.utcOffsetMinutes,
    required this.incidentPrefix,
    required this.fictional,
    this.attribution,
    this.affiliationNote,
    this.originLat,
    this.originLon,
    required this.metersPerUnit,
    required this.mapWidth,
    required this.mapHeight,
    this.mapLayers,
  });

  factory Campus({
    int? id,
    required String code,
    required String name,
    required String shortName,
    String? city,
    String? description,
    required int utcOffsetMinutes,
    required String incidentPrefix,
    required bool fictional,
    String? attribution,
    String? affiliationNote,
    double? originLat,
    double? originLon,
    required double metersPerUnit,
    required double mapWidth,
    required double mapHeight,
    String? mapLayers,
  }) = _CampusImpl;

  factory Campus.fromJson(Map<String, dynamic> jsonSerialization) {
    return Campus(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      shortName: jsonSerialization['shortName'] as String,
      city: jsonSerialization['city'] as String?,
      description: jsonSerialization['description'] as String?,
      utcOffsetMinutes: jsonSerialization['utcOffsetMinutes'] as int,
      incidentPrefix: jsonSerialization['incidentPrefix'] as String,
      fictional: _is.BoolJsonExtension.fromJson(jsonSerialization['fictional']),
      attribution: jsonSerialization['attribution'] as String?,
      affiliationNote: jsonSerialization['affiliationNote'] as String?,
      originLat: (jsonSerialization['originLat'] as num?)?.toDouble(),
      originLon: (jsonSerialization['originLon'] as num?)?.toDouble(),
      metersPerUnit: (jsonSerialization['metersPerUnit'] as num).toDouble(),
      mapWidth: (jsonSerialization['mapWidth'] as num).toDouble(),
      mapHeight: (jsonSerialization['mapHeight'] as num).toDouble(),
      mapLayers: jsonSerialization['mapLayers'] as String?,
    );
  }

  static final t = CampusTable();

  static const db = CampusRepository._();

  @override
  int? id;

  /// Stable identifier used in configuration and seeds, e.g. 'meridian', 'niet'.
  String code;

  String name;

  /// Short label for tight spaces, e.g. 'NIET'.
  String shortName;

  String? city;

  String? description;

  /// Minutes east of UTC for local-hour policies and display (330 = IST).
  int utcOffsetMinutes;

  /// Prefix of this campus's incident codes, e.g. 'NIET' gives NIET-1042.
  String incidentPrefix;

  /// True for an invented demo campus; false when modelled from real public map data.
  bool fictional;

  /// Credit shown wherever the campus map appears, e.g. the OpenStreetMap ODbL notice.
  String? attribution;

  /// Plain statement of the relationship between CareGrid and the institution.
  String? affiliationNote;

  /// WGS84 point of canvas (0, 0); null for a schematic campus.
  double? originLat;

  double? originLon;

  /// Metres per canvas unit; canvas y grows southwards.
  double metersPerUnit;

  double mapWidth;

  double mapHeight;

  /// Non-routing map context as JSON in canvas units: plot outlines, parking, courts, construction and surrounding streets. Drawn under the twin; never used for routing.
  String? mapLayers;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Campus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Campus copyWith({
    int? id,
    String? code,
    String? name,
    String? shortName,
    String? city,
    String? description,
    int? utcOffsetMinutes,
    String? incidentPrefix,
    bool? fictional,
    String? attribution,
    String? affiliationNote,
    double? originLat,
    double? originLon,
    double? metersPerUnit,
    double? mapWidth,
    double? mapHeight,
    String? mapLayers,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Campus',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'shortName': shortName,
      if (city != null) 'city': city,
      if (description != null) 'description': description,
      'utcOffsetMinutes': utcOffsetMinutes,
      'incidentPrefix': incidentPrefix,
      'fictional': fictional,
      if (attribution != null) 'attribution': attribution,
      if (affiliationNote != null) 'affiliationNote': affiliationNote,
      if (originLat != null) 'originLat': originLat,
      if (originLon != null) 'originLon': originLon,
      'metersPerUnit': metersPerUnit,
      'mapWidth': mapWidth,
      'mapHeight': mapHeight,
      if (mapLayers != null) 'mapLayers': mapLayers,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Campus',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'shortName': shortName,
      if (city != null) 'city': city,
      if (description != null) 'description': description,
      'utcOffsetMinutes': utcOffsetMinutes,
      'incidentPrefix': incidentPrefix,
      'fictional': fictional,
      if (attribution != null) 'attribution': attribution,
      if (affiliationNote != null) 'affiliationNote': affiliationNote,
      if (originLat != null) 'originLat': originLat,
      if (originLon != null) 'originLon': originLon,
      'metersPerUnit': metersPerUnit,
      'mapWidth': mapWidth,
      'mapHeight': mapHeight,
      if (mapLayers != null) 'mapLayers': mapLayers,
    };
  }

  static CampusInclude include() {
    return CampusInclude._();
  }

  static CampusIncludeList includeList({
    _is.WhereExpressionBuilder<CampusTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusTable>? orderBy,
    _is.OrderByListBuilder<CampusTable>? orderByList,
    CampusInclude? include,
  }) {
    return CampusIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Campus.t),
      orderByList: orderByList?.call(Campus.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampusImpl extends Campus {
  _CampusImpl({
    int? id,
    required String code,
    required String name,
    required String shortName,
    String? city,
    String? description,
    required int utcOffsetMinutes,
    required String incidentPrefix,
    required bool fictional,
    String? attribution,
    String? affiliationNote,
    double? originLat,
    double? originLon,
    required double metersPerUnit,
    required double mapWidth,
    required double mapHeight,
    String? mapLayers,
  }) : super._(
         id: id,
         code: code,
         name: name,
         shortName: shortName,
         city: city,
         description: description,
         utcOffsetMinutes: utcOffsetMinutes,
         incidentPrefix: incidentPrefix,
         fictional: fictional,
         attribution: attribution,
         affiliationNote: affiliationNote,
         originLat: originLat,
         originLon: originLon,
         metersPerUnit: metersPerUnit,
         mapWidth: mapWidth,
         mapHeight: mapHeight,
         mapLayers: mapLayers,
       );

  /// Returns a shallow copy of this [Campus]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Campus copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? shortName,
    Object? city = _Undefined,
    Object? description = _Undefined,
    int? utcOffsetMinutes,
    String? incidentPrefix,
    bool? fictional,
    Object? attribution = _Undefined,
    Object? affiliationNote = _Undefined,
    Object? originLat = _Undefined,
    Object? originLon = _Undefined,
    double? metersPerUnit,
    double? mapWidth,
    double? mapHeight,
    Object? mapLayers = _Undefined,
  }) {
    return Campus(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      city: city is String? ? city : this.city,
      description: description is String? ? description : this.description,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
      incidentPrefix: incidentPrefix ?? this.incidentPrefix,
      fictional: fictional ?? this.fictional,
      attribution: attribution is String? ? attribution : this.attribution,
      affiliationNote: affiliationNote is String?
          ? affiliationNote
          : this.affiliationNote,
      originLat: originLat is double? ? originLat : this.originLat,
      originLon: originLon is double? ? originLon : this.originLon,
      metersPerUnit: metersPerUnit ?? this.metersPerUnit,
      mapWidth: mapWidth ?? this.mapWidth,
      mapHeight: mapHeight ?? this.mapHeight,
      mapLayers: mapLayers is String? ? mapLayers : this.mapLayers,
    );
  }
}

class CampusUpdateTable extends _is.UpdateTable<CampusTable> {
  CampusUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> shortName(String value) => _is.ColumnValue(
    table.shortName,
    value,
  );

  _is.ColumnValue<String, String> city(String? value) => _is.ColumnValue(
    table.city,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<int, int> utcOffsetMinutes(int value) => _is.ColumnValue(
    table.utcOffsetMinutes,
    value,
  );

  _is.ColumnValue<String, String> incidentPrefix(String value) =>
      _is.ColumnValue(
        table.incidentPrefix,
        value,
      );

  _is.ColumnValue<bool, bool> fictional(bool value) => _is.ColumnValue(
    table.fictional,
    value,
  );

  _is.ColumnValue<String, String> attribution(String? value) => _is.ColumnValue(
    table.attribution,
    value,
  );

  _is.ColumnValue<String, String> affiliationNote(String? value) =>
      _is.ColumnValue(
        table.affiliationNote,
        value,
      );

  _is.ColumnValue<double, double> originLat(double? value) => _is.ColumnValue(
    table.originLat,
    value,
  );

  _is.ColumnValue<double, double> originLon(double? value) => _is.ColumnValue(
    table.originLon,
    value,
  );

  _is.ColumnValue<double, double> metersPerUnit(double value) =>
      _is.ColumnValue(
        table.metersPerUnit,
        value,
      );

  _is.ColumnValue<double, double> mapWidth(double value) => _is.ColumnValue(
    table.mapWidth,
    value,
  );

  _is.ColumnValue<double, double> mapHeight(double value) => _is.ColumnValue(
    table.mapHeight,
    value,
  );

  _is.ColumnValue<String, String> mapLayers(String? value) => _is.ColumnValue(
    table.mapLayers,
    value,
  );
}

class CampusTable extends _is.Table<int?> {
  CampusTable({super.tableRelation}) : super(tableName: 'campus') {
    updateTable = CampusUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    shortName = _is.ColumnString(
      'shortName',
      this,
    );
    city = _is.ColumnString(
      'city',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    utcOffsetMinutes = _is.ColumnInt(
      'utcOffsetMinutes',
      this,
    );
    incidentPrefix = _is.ColumnString(
      'incidentPrefix',
      this,
    );
    fictional = _is.ColumnBool(
      'fictional',
      this,
    );
    attribution = _is.ColumnString(
      'attribution',
      this,
    );
    affiliationNote = _is.ColumnString(
      'affiliationNote',
      this,
    );
    originLat = _is.ColumnDouble(
      'originLat',
      this,
    );
    originLon = _is.ColumnDouble(
      'originLon',
      this,
    );
    metersPerUnit = _is.ColumnDouble(
      'metersPerUnit',
      this,
    );
    mapWidth = _is.ColumnDouble(
      'mapWidth',
      this,
    );
    mapHeight = _is.ColumnDouble(
      'mapHeight',
      this,
    );
    mapLayers = _is.ColumnString(
      'mapLayers',
      this,
    );
  }

  late final CampusUpdateTable updateTable;

  /// Stable identifier used in configuration and seeds, e.g. 'meridian', 'niet'.
  late final _is.ColumnString code;

  late final _is.ColumnString name;

  /// Short label for tight spaces, e.g. 'NIET'.
  late final _is.ColumnString shortName;

  late final _is.ColumnString city;

  late final _is.ColumnString description;

  /// Minutes east of UTC for local-hour policies and display (330 = IST).
  late final _is.ColumnInt utcOffsetMinutes;

  /// Prefix of this campus's incident codes, e.g. 'NIET' gives NIET-1042.
  late final _is.ColumnString incidentPrefix;

  /// True for an invented demo campus; false when modelled from real public map data.
  late final _is.ColumnBool fictional;

  /// Credit shown wherever the campus map appears, e.g. the OpenStreetMap ODbL notice.
  late final _is.ColumnString attribution;

  /// Plain statement of the relationship between CareGrid and the institution.
  late final _is.ColumnString affiliationNote;

  /// WGS84 point of canvas (0, 0); null for a schematic campus.
  late final _is.ColumnDouble originLat;

  late final _is.ColumnDouble originLon;

  /// Metres per canvas unit; canvas y grows southwards.
  late final _is.ColumnDouble metersPerUnit;

  late final _is.ColumnDouble mapWidth;

  late final _is.ColumnDouble mapHeight;

  /// Non-routing map context as JSON in canvas units: plot outlines, parking, courts, construction and surrounding streets. Drawn under the twin; never used for routing.
  late final _is.ColumnString mapLayers;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    name,
    shortName,
    city,
    description,
    utcOffsetMinutes,
    incidentPrefix,
    fictional,
    attribution,
    affiliationNote,
    originLat,
    originLon,
    metersPerUnit,
    mapWidth,
    mapHeight,
    mapLayers,
  ];
}

class CampusInclude extends _is.IncludeObject {
  CampusInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Campus.t;
}

class CampusIncludeList extends _is.IncludeList {
  CampusIncludeList._({
    _is.WhereExpressionBuilder<CampusTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Campus.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Campus.t;
}

class CampusRepository {
  const CampusRepository._();

  /// Returns a list of [Campus]s matching the given query parameters.
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
  Future<List<Campus>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusTable>? orderBy,
    _is.OrderByListBuilder<CampusTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Campus>(
      where: where?.call(Campus.t),
      orderBy: orderBy?.call(Campus.t),
      orderByList: orderByList?.call(Campus.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Campus] matching the given query parameters.
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
  Future<Campus?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusTable>? where,
    int? offset,
    _is.OrderByBuilder<CampusTable>? orderBy,
    _is.OrderByListBuilder<CampusTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Campus>(
      where: where?.call(Campus.t),
      orderBy: orderBy?.call(Campus.t),
      orderByList: orderByList?.call(Campus.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Campus] by its [id] or null if no such row exists.
  Future<Campus?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Campus>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Campus]s in the list and returns the inserted rows.
  ///
  /// The returned [Campus]s will have their `id` fields set.
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
  Future<List<Campus>> insert(
    _is.DatabaseSession session,
    List<Campus> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Campus>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Campus] and returns the inserted row.
  ///
  /// The returned [Campus] will have its `id` field set.
  Future<Campus> insertRow(
    _is.DatabaseSession session,
    Campus row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Campus>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Campus]s in the list and returns the resulting rows.
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
  /// The returned [Campus]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Campus>> upsert(
    _is.DatabaseSession session,
    List<Campus> rows, {
    required _is.ColumnSelections<CampusTable> conflictColumns,
    _is.ColumnSelections<CampusTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Campus>(
      rows,
      conflictColumns: conflictColumns(Campus.t),
      updateColumns: updateColumns?.call(Campus.t),
      updateWhere: updateWhere?.call(Campus.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Campus] and returns the resulting row.
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
  /// The returned [Campus] will have its `id` field set.
  Future<Campus?> upsertRow(
    _is.DatabaseSession session,
    Campus row, {
    required _is.ColumnSelections<CampusTable> conflictColumns,
    _is.ColumnSelections<CampusTable>? updateColumns,
    _is.WhereExpressionBuilder<CampusTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Campus>(
      row,
      conflictColumns: conflictColumns(Campus.t),
      updateColumns: updateColumns?.call(Campus.t),
      updateWhere: updateWhere?.call(Campus.t),
      transaction: transaction,
    );
  }

  /// Updates all [Campus]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Campus>> update(
    _is.DatabaseSession session,
    List<Campus> rows, {
    _is.ColumnSelections<CampusTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Campus>(
      rows,
      columns: columns?.call(Campus.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Campus]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Campus> updateRow(
    _is.DatabaseSession session,
    Campus row, {
    _is.ColumnSelections<CampusTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Campus>(
      row,
      columns: columns?.call(Campus.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Campus] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Campus?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CampusUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Campus>(
      id,
      columnValues: columnValues(Campus.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Campus]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Campus>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CampusUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CampusTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CampusTable>? orderBy,
    _is.OrderByListBuilder<CampusTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Campus>(
      columnValues: columnValues(Campus.t.updateTable),
      where: where(Campus.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Campus.t),
      orderByList: orderByList?.call(Campus.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Campus]s in the list and returns the deleted rows.
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
  Future<List<Campus>> delete(
    _is.DatabaseSession session,
    List<Campus> rows, {
    _is.OrderByBuilder<CampusTable>? orderBy,
    _is.OrderByListBuilder<CampusTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Campus>(
      rows,
      orderBy: orderBy?.call(Campus.t),
      orderByList: orderByList?.call(Campus.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Campus].
  Future<Campus> deleteRow(
    _is.DatabaseSession session,
    Campus row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Campus>(
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
  Future<List<Campus>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusTable> where,
    _is.OrderByBuilder<CampusTable>? orderBy,
    _is.OrderByListBuilder<CampusTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Campus>(
      where: where(Campus.t),
      orderBy: orderBy?.call(Campus.t),
      orderByList: orderByList?.call(Campus.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CampusTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Campus>(
      where: where?.call(Campus.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Campus] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CampusTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Campus>(
      where: where(Campus.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
