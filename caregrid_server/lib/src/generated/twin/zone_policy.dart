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
import '../enums/event_family.dart' as _idlnttep;
import '../enums/responder_type.dart' as _iua0ui51;
import '../enums/severity.dart' as _i55c3ufc;
import '../enums/zone_type.dart' as _i7qzwj5g;

/// A site-specific standard operating procedure: what counts as an incident in a zone at a time, and who responds.
abstract class ZonePolicy
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ZonePolicy._({
    this.id,
    required this.code,
    required this.name,
    this.zoneType,
    required this.family,
    this.startHour,
    this.endHour,
    required this.severity,
    required this.minConfidence,
    required this.requireCorroboration,
    required this.autoDispatch,
    required this.notifyHospital,
    required this.responderTypes,
    required this.fallbackTypes,
    required this.verifySlaSeconds,
    required this.ackSlaSeconds,
    required this.arrivalSlaSeconds,
    required this.careSlaSeconds,
    required this.instructions,
  });

  factory ZonePolicy({
    int? id,
    required String code,
    required String name,
    _i7qzwj5g.ZoneType? zoneType,
    required _idlnttep.EventFamily family,
    int? startHour,
    int? endHour,
    required _i55c3ufc.Severity severity,
    required double minConfidence,
    required bool requireCorroboration,
    required bool autoDispatch,
    required bool notifyHospital,
    required List<_iua0ui51.ResponderType> responderTypes,
    required List<_iua0ui51.ResponderType> fallbackTypes,
    required int verifySlaSeconds,
    required int ackSlaSeconds,
    required int arrivalSlaSeconds,
    required int careSlaSeconds,
    required List<String> instructions,
  }) = _ZonePolicyImpl;

  factory ZonePolicy.fromJson(Map<String, dynamic> jsonSerialization) {
    return ZonePolicy(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      zoneType: jsonSerialization['zoneType'] == null
          ? null
          : _i7qzwj5g.ZoneType.fromJson(
              (jsonSerialization['zoneType'] as String),
            ),
      family: _idlnttep.EventFamily.fromJson(
        (jsonSerialization['family'] as String),
      ),
      startHour: jsonSerialization['startHour'] as int?,
      endHour: jsonSerialization['endHour'] as int?,
      severity: _i55c3ufc.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      minConfidence: (jsonSerialization['minConfidence'] as num).toDouble(),
      requireCorroboration: _is.BoolJsonExtension.fromJson(
        jsonSerialization['requireCorroboration'],
      ),
      autoDispatch: _is.BoolJsonExtension.fromJson(
        jsonSerialization['autoDispatch'],
      ),
      notifyHospital: _is.BoolJsonExtension.fromJson(
        jsonSerialization['notifyHospital'],
      ),
      responderTypes: _ighx06pg.Protocol()
          .deserialize<List<_iua0ui51.ResponderType>>(
            jsonSerialization['responderTypes'],
          ),
      fallbackTypes: _ighx06pg.Protocol()
          .deserialize<List<_iua0ui51.ResponderType>>(
            jsonSerialization['fallbackTypes'],
          ),
      verifySlaSeconds: jsonSerialization['verifySlaSeconds'] as int,
      ackSlaSeconds: jsonSerialization['ackSlaSeconds'] as int,
      arrivalSlaSeconds: jsonSerialization['arrivalSlaSeconds'] as int,
      careSlaSeconds: jsonSerialization['careSlaSeconds'] as int,
      instructions: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['instructions'],
      ),
    );
  }

  static final t = ZonePolicyTable();

  static const db = ZonePolicyRepository._();

  @override
  int? id;

  String code;

  String name;

  /// Null means the policy applies to every zone type.
  _i7qzwj5g.ZoneType? zoneType;

  _idlnttep.EventFamily family;

  /// Local hour window [startHour, endHour). Wraps past midnight when start > end. Null means all day.
  int? startHour;

  int? endHour;

  _i55c3ufc.Severity severity;

  /// Minimum signal confidence before the agent treats the event as verified.
  double minConfidence;

  /// Require a second camera or sensor (or temporal persistence) before verification.
  bool requireCorroboration;

  /// Dispatch without waiting for operator confirmation (life-safety hazards only).
  bool autoDispatch;

  bool notifyHospital;

  List<_iua0ui51.ResponderType> responderTypes;

  /// Used when no unit of a required type is available.
  List<_iua0ui51.ResponderType> fallbackTypes;

  int verifySlaSeconds;

  int ackSlaSeconds;

  /// Onset-to-arrival target for the first unit of every required type.
  int arrivalSlaSeconds;

  int careSlaSeconds;

  List<String> instructions;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ZonePolicy]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ZonePolicy copyWith({
    int? id,
    String? code,
    String? name,
    _i7qzwj5g.ZoneType? zoneType,
    _idlnttep.EventFamily? family,
    int? startHour,
    int? endHour,
    _i55c3ufc.Severity? severity,
    double? minConfidence,
    bool? requireCorroboration,
    bool? autoDispatch,
    bool? notifyHospital,
    List<_iua0ui51.ResponderType>? responderTypes,
    List<_iua0ui51.ResponderType>? fallbackTypes,
    int? verifySlaSeconds,
    int? ackSlaSeconds,
    int? arrivalSlaSeconds,
    int? careSlaSeconds,
    List<String>? instructions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ZonePolicy',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      if (zoneType != null) 'zoneType': zoneType?.toJson(),
      'family': family.toJson(),
      if (startHour != null) 'startHour': startHour,
      if (endHour != null) 'endHour': endHour,
      'severity': severity.toJson(),
      'minConfidence': minConfidence,
      'requireCorroboration': requireCorroboration,
      'autoDispatch': autoDispatch,
      'notifyHospital': notifyHospital,
      'responderTypes': responderTypes.toJson(valueToJson: (v) => v.toJson()),
      'fallbackTypes': fallbackTypes.toJson(valueToJson: (v) => v.toJson()),
      'verifySlaSeconds': verifySlaSeconds,
      'ackSlaSeconds': ackSlaSeconds,
      'arrivalSlaSeconds': arrivalSlaSeconds,
      'careSlaSeconds': careSlaSeconds,
      'instructions': instructions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ZonePolicy',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      if (zoneType != null) 'zoneType': zoneType?.toJson(),
      'family': family.toJson(),
      if (startHour != null) 'startHour': startHour,
      if (endHour != null) 'endHour': endHour,
      'severity': severity.toJson(),
      'minConfidence': minConfidence,
      'requireCorroboration': requireCorroboration,
      'autoDispatch': autoDispatch,
      'notifyHospital': notifyHospital,
      'responderTypes': responderTypes.toJson(valueToJson: (v) => v.toJson()),
      'fallbackTypes': fallbackTypes.toJson(valueToJson: (v) => v.toJson()),
      'verifySlaSeconds': verifySlaSeconds,
      'ackSlaSeconds': ackSlaSeconds,
      'arrivalSlaSeconds': arrivalSlaSeconds,
      'careSlaSeconds': careSlaSeconds,
      'instructions': instructions.toJson(),
    };
  }

  static ZonePolicyInclude include() {
    return ZonePolicyInclude._();
  }

  static ZonePolicyIncludeList includeList({
    _is.WhereExpressionBuilder<ZonePolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ZonePolicyTable>? orderBy,
    _is.OrderByListBuilder<ZonePolicyTable>? orderByList,
    ZonePolicyInclude? include,
  }) {
    return ZonePolicyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ZonePolicy.t),
      orderByList: orderByList?.call(ZonePolicy.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ZonePolicyImpl extends ZonePolicy {
  _ZonePolicyImpl({
    int? id,
    required String code,
    required String name,
    _i7qzwj5g.ZoneType? zoneType,
    required _idlnttep.EventFamily family,
    int? startHour,
    int? endHour,
    required _i55c3ufc.Severity severity,
    required double minConfidence,
    required bool requireCorroboration,
    required bool autoDispatch,
    required bool notifyHospital,
    required List<_iua0ui51.ResponderType> responderTypes,
    required List<_iua0ui51.ResponderType> fallbackTypes,
    required int verifySlaSeconds,
    required int ackSlaSeconds,
    required int arrivalSlaSeconds,
    required int careSlaSeconds,
    required List<String> instructions,
  }) : super._(
         id: id,
         code: code,
         name: name,
         zoneType: zoneType,
         family: family,
         startHour: startHour,
         endHour: endHour,
         severity: severity,
         minConfidence: minConfidence,
         requireCorroboration: requireCorroboration,
         autoDispatch: autoDispatch,
         notifyHospital: notifyHospital,
         responderTypes: responderTypes,
         fallbackTypes: fallbackTypes,
         verifySlaSeconds: verifySlaSeconds,
         ackSlaSeconds: ackSlaSeconds,
         arrivalSlaSeconds: arrivalSlaSeconds,
         careSlaSeconds: careSlaSeconds,
         instructions: instructions,
       );

  /// Returns a shallow copy of this [ZonePolicy]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ZonePolicy copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    Object? zoneType = _Undefined,
    _idlnttep.EventFamily? family,
    Object? startHour = _Undefined,
    Object? endHour = _Undefined,
    _i55c3ufc.Severity? severity,
    double? minConfidence,
    bool? requireCorroboration,
    bool? autoDispatch,
    bool? notifyHospital,
    List<_iua0ui51.ResponderType>? responderTypes,
    List<_iua0ui51.ResponderType>? fallbackTypes,
    int? verifySlaSeconds,
    int? ackSlaSeconds,
    int? arrivalSlaSeconds,
    int? careSlaSeconds,
    List<String>? instructions,
  }) {
    return ZonePolicy(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      zoneType: zoneType is _i7qzwj5g.ZoneType? ? zoneType : this.zoneType,
      family: family ?? this.family,
      startHour: startHour is int? ? startHour : this.startHour,
      endHour: endHour is int? ? endHour : this.endHour,
      severity: severity ?? this.severity,
      minConfidence: minConfidence ?? this.minConfidence,
      requireCorroboration: requireCorroboration ?? this.requireCorroboration,
      autoDispatch: autoDispatch ?? this.autoDispatch,
      notifyHospital: notifyHospital ?? this.notifyHospital,
      responderTypes:
          responderTypes ?? this.responderTypes.map((e0) => e0).toList(),
      fallbackTypes:
          fallbackTypes ?? this.fallbackTypes.map((e0) => e0).toList(),
      verifySlaSeconds: verifySlaSeconds ?? this.verifySlaSeconds,
      ackSlaSeconds: ackSlaSeconds ?? this.ackSlaSeconds,
      arrivalSlaSeconds: arrivalSlaSeconds ?? this.arrivalSlaSeconds,
      careSlaSeconds: careSlaSeconds ?? this.careSlaSeconds,
      instructions: instructions ?? this.instructions.map((e0) => e0).toList(),
    );
  }
}

class ZonePolicyUpdateTable extends _is.UpdateTable<ZonePolicyTable> {
  ZonePolicyUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_i7qzwj5g.ZoneType, _i7qzwj5g.ZoneType> zoneType(
    _i7qzwj5g.ZoneType? value,
  ) => _is.ColumnValue(
    table.zoneType,
    value,
  );

  _is.ColumnValue<_idlnttep.EventFamily, _idlnttep.EventFamily> family(
    _idlnttep.EventFamily value,
  ) => _is.ColumnValue(
    table.family,
    value,
  );

  _is.ColumnValue<int, int> startHour(int? value) => _is.ColumnValue(
    table.startHour,
    value,
  );

  _is.ColumnValue<int, int> endHour(int? value) => _is.ColumnValue(
    table.endHour,
    value,
  );

  _is.ColumnValue<_i55c3ufc.Severity, _i55c3ufc.Severity> severity(
    _i55c3ufc.Severity value,
  ) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<double, double> minConfidence(double value) =>
      _is.ColumnValue(
        table.minConfidence,
        value,
      );

  _is.ColumnValue<bool, bool> requireCorroboration(bool value) =>
      _is.ColumnValue(
        table.requireCorroboration,
        value,
      );

  _is.ColumnValue<bool, bool> autoDispatch(bool value) => _is.ColumnValue(
    table.autoDispatch,
    value,
  );

  _is.ColumnValue<bool, bool> notifyHospital(bool value) => _is.ColumnValue(
    table.notifyHospital,
    value,
  );

  _is.ColumnValue<List<_iua0ui51.ResponderType>, List<_iua0ui51.ResponderType>>
  responderTypes(List<_iua0ui51.ResponderType> value) => _is.ColumnValue(
    table.responderTypes,
    value,
  );

  _is.ColumnValue<List<_iua0ui51.ResponderType>, List<_iua0ui51.ResponderType>>
  fallbackTypes(List<_iua0ui51.ResponderType> value) => _is.ColumnValue(
    table.fallbackTypes,
    value,
  );

  _is.ColumnValue<int, int> verifySlaSeconds(int value) => _is.ColumnValue(
    table.verifySlaSeconds,
    value,
  );

  _is.ColumnValue<int, int> ackSlaSeconds(int value) => _is.ColumnValue(
    table.ackSlaSeconds,
    value,
  );

  _is.ColumnValue<int, int> arrivalSlaSeconds(int value) => _is.ColumnValue(
    table.arrivalSlaSeconds,
    value,
  );

  _is.ColumnValue<int, int> careSlaSeconds(int value) => _is.ColumnValue(
    table.careSlaSeconds,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> instructions(
    List<String> value,
  ) => _is.ColumnValue(
    table.instructions,
    value,
  );
}

class ZonePolicyTable extends _is.Table<int?> {
  ZonePolicyTable({super.tableRelation}) : super(tableName: 'zone_policy') {
    updateTable = ZonePolicyUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    zoneType = _is.ColumnEnum(
      'zoneType',
      this,
      _is.EnumSerialization.byName,
    );
    family = _is.ColumnEnum(
      'family',
      this,
      _is.EnumSerialization.byName,
    );
    startHour = _is.ColumnInt(
      'startHour',
      this,
    );
    endHour = _is.ColumnInt(
      'endHour',
      this,
    );
    severity = _is.ColumnEnum(
      'severity',
      this,
      _is.EnumSerialization.byName,
    );
    minConfidence = _is.ColumnDouble(
      'minConfidence',
      this,
    );
    requireCorroboration = _is.ColumnBool(
      'requireCorroboration',
      this,
    );
    autoDispatch = _is.ColumnBool(
      'autoDispatch',
      this,
    );
    notifyHospital = _is.ColumnBool(
      'notifyHospital',
      this,
    );
    responderTypes = _is.ColumnSerializable<List<_iua0ui51.ResponderType>>(
      'responderTypes',
      this,
    );
    fallbackTypes = _is.ColumnSerializable<List<_iua0ui51.ResponderType>>(
      'fallbackTypes',
      this,
    );
    verifySlaSeconds = _is.ColumnInt(
      'verifySlaSeconds',
      this,
    );
    ackSlaSeconds = _is.ColumnInt(
      'ackSlaSeconds',
      this,
    );
    arrivalSlaSeconds = _is.ColumnInt(
      'arrivalSlaSeconds',
      this,
    );
    careSlaSeconds = _is.ColumnInt(
      'careSlaSeconds',
      this,
    );
    instructions = _is.ColumnSerializable<List<String>>(
      'instructions',
      this,
    );
  }

  late final ZonePolicyUpdateTable updateTable;

  late final _is.ColumnString code;

  late final _is.ColumnString name;

  /// Null means the policy applies to every zone type.
  late final _is.ColumnEnum<_i7qzwj5g.ZoneType> zoneType;

  late final _is.ColumnEnum<_idlnttep.EventFamily> family;

  /// Local hour window [startHour, endHour). Wraps past midnight when start > end. Null means all day.
  late final _is.ColumnInt startHour;

  late final _is.ColumnInt endHour;

  late final _is.ColumnEnum<_i55c3ufc.Severity> severity;

  /// Minimum signal confidence before the agent treats the event as verified.
  late final _is.ColumnDouble minConfidence;

  /// Require a second camera or sensor (or temporal persistence) before verification.
  late final _is.ColumnBool requireCorroboration;

  /// Dispatch without waiting for operator confirmation (life-safety hazards only).
  late final _is.ColumnBool autoDispatch;

  late final _is.ColumnBool notifyHospital;

  late final _is.ColumnSerializable<List<_iua0ui51.ResponderType>>
  responderTypes;

  /// Used when no unit of a required type is available.
  late final _is.ColumnSerializable<List<_iua0ui51.ResponderType>>
  fallbackTypes;

  late final _is.ColumnInt verifySlaSeconds;

  late final _is.ColumnInt ackSlaSeconds;

  /// Onset-to-arrival target for the first unit of every required type.
  late final _is.ColumnInt arrivalSlaSeconds;

  late final _is.ColumnInt careSlaSeconds;

  late final _is.ColumnSerializable<List<String>> instructions;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    name,
    zoneType,
    family,
    startHour,
    endHour,
    severity,
    minConfidence,
    requireCorroboration,
    autoDispatch,
    notifyHospital,
    responderTypes,
    fallbackTypes,
    verifySlaSeconds,
    ackSlaSeconds,
    arrivalSlaSeconds,
    careSlaSeconds,
    instructions,
  ];
}

class ZonePolicyInclude extends _is.IncludeObject {
  ZonePolicyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ZonePolicy.t;
}

class ZonePolicyIncludeList extends _is.IncludeList {
  ZonePolicyIncludeList._({
    _is.WhereExpressionBuilder<ZonePolicyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ZonePolicy.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ZonePolicy.t;
}

class ZonePolicyRepository {
  const ZonePolicyRepository._();

  /// Returns a list of [ZonePolicy]s matching the given query parameters.
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
  Future<List<ZonePolicy>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ZonePolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ZonePolicyTable>? orderBy,
    _is.OrderByListBuilder<ZonePolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ZonePolicy>(
      where: where?.call(ZonePolicy.t),
      orderBy: orderBy?.call(ZonePolicy.t),
      orderByList: orderByList?.call(ZonePolicy.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ZonePolicy] matching the given query parameters.
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
  Future<ZonePolicy?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ZonePolicyTable>? where,
    int? offset,
    _is.OrderByBuilder<ZonePolicyTable>? orderBy,
    _is.OrderByListBuilder<ZonePolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ZonePolicy>(
      where: where?.call(ZonePolicy.t),
      orderBy: orderBy?.call(ZonePolicy.t),
      orderByList: orderByList?.call(ZonePolicy.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ZonePolicy] by its [id] or null if no such row exists.
  Future<ZonePolicy?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ZonePolicy>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ZonePolicy]s in the list and returns the inserted rows.
  ///
  /// The returned [ZonePolicy]s will have their `id` fields set.
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
  Future<List<ZonePolicy>> insert(
    _is.DatabaseSession session,
    List<ZonePolicy> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ZonePolicy>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ZonePolicy] and returns the inserted row.
  ///
  /// The returned [ZonePolicy] will have its `id` field set.
  Future<ZonePolicy> insertRow(
    _is.DatabaseSession session,
    ZonePolicy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ZonePolicy>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ZonePolicy]s in the list and returns the resulting rows.
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
  /// The returned [ZonePolicy]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ZonePolicy>> upsert(
    _is.DatabaseSession session,
    List<ZonePolicy> rows, {
    required _is.ColumnSelections<ZonePolicyTable> conflictColumns,
    _is.ColumnSelections<ZonePolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<ZonePolicyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ZonePolicy>(
      rows,
      conflictColumns: conflictColumns(ZonePolicy.t),
      updateColumns: updateColumns?.call(ZonePolicy.t),
      updateWhere: updateWhere?.call(ZonePolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ZonePolicy] and returns the resulting row.
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
  /// The returned [ZonePolicy] will have its `id` field set.
  Future<ZonePolicy?> upsertRow(
    _is.DatabaseSession session,
    ZonePolicy row, {
    required _is.ColumnSelections<ZonePolicyTable> conflictColumns,
    _is.ColumnSelections<ZonePolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<ZonePolicyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ZonePolicy>(
      row,
      conflictColumns: conflictColumns(ZonePolicy.t),
      updateColumns: updateColumns?.call(ZonePolicy.t),
      updateWhere: updateWhere?.call(ZonePolicy.t),
      transaction: transaction,
    );
  }

  /// Updates all [ZonePolicy]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ZonePolicy>> update(
    _is.DatabaseSession session,
    List<ZonePolicy> rows, {
    _is.ColumnSelections<ZonePolicyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ZonePolicy>(
      rows,
      columns: columns?.call(ZonePolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ZonePolicy]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ZonePolicy> updateRow(
    _is.DatabaseSession session,
    ZonePolicy row, {
    _is.ColumnSelections<ZonePolicyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ZonePolicy>(
      row,
      columns: columns?.call(ZonePolicy.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ZonePolicy] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ZonePolicy?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ZonePolicyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ZonePolicy>(
      id,
      columnValues: columnValues(ZonePolicy.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ZonePolicy]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ZonePolicy>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ZonePolicyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ZonePolicyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ZonePolicyTable>? orderBy,
    _is.OrderByListBuilder<ZonePolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ZonePolicy>(
      columnValues: columnValues(ZonePolicy.t.updateTable),
      where: where(ZonePolicy.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ZonePolicy.t),
      orderByList: orderByList?.call(ZonePolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ZonePolicy]s in the list and returns the deleted rows.
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
  Future<List<ZonePolicy>> delete(
    _is.DatabaseSession session,
    List<ZonePolicy> rows, {
    _is.OrderByBuilder<ZonePolicyTable>? orderBy,
    _is.OrderByListBuilder<ZonePolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ZonePolicy>(
      rows,
      orderBy: orderBy?.call(ZonePolicy.t),
      orderByList: orderByList?.call(ZonePolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ZonePolicy].
  Future<ZonePolicy> deleteRow(
    _is.DatabaseSession session,
    ZonePolicy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ZonePolicy>(
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
  Future<List<ZonePolicy>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ZonePolicyTable> where,
    _is.OrderByBuilder<ZonePolicyTable>? orderBy,
    _is.OrderByListBuilder<ZonePolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ZonePolicy>(
      where: where(ZonePolicy.t),
      orderBy: orderBy?.call(ZonePolicy.t),
      orderByList: orderByList?.call(ZonePolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ZonePolicyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ZonePolicy>(
      where: where?.call(ZonePolicy.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ZonePolicy] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ZonePolicyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ZonePolicy>(
      where: where(ZonePolicy.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
