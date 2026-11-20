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
import '../enums/verdict.dart' as _irobyjww;
import '../readiness/stage_estimate.dart' as _ijdzm3ea;
import '../readiness/stress_fix.dart' as _ied9xxny;

/// Report of one stress-test run against the digital twin.
abstract class StressTestRun
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StressTestRun._({
    this.id,
    required this.campusId,
    required this.scenarioCode,
    required this.scenarioName,
    required this.ranAt,
    required this.ranBy,
    required this.verdict,
    required this.predictedSeconds,
    required this.slaSeconds,
    this.policyCode,
    required this.stages,
    required this.responderPlan,
    required this.findings,
    required this.fixes,
    this.verdictAfterFix,
    this.predictedAfterFixSeconds,
    required this.planAfterFix,
  });

  factory StressTestRun({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String scenarioName,
    required DateTime ranAt,
    required String ranBy,
    required _irobyjww.Verdict verdict,
    required int predictedSeconds,
    required int slaSeconds,
    String? policyCode,
    required List<_ijdzm3ea.StageEstimate> stages,
    required List<String> responderPlan,
    required List<String> findings,
    required List<_ied9xxny.StressFix> fixes,
    _irobyjww.Verdict? verdictAfterFix,
    int? predictedAfterFixSeconds,
    required List<String> planAfterFix,
  }) = _StressTestRunImpl;

  factory StressTestRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return StressTestRun(
      id: jsonSerialization['id'] as int?,
      campusId: jsonSerialization['campusId'] as int,
      scenarioCode: jsonSerialization['scenarioCode'] as String,
      scenarioName: jsonSerialization['scenarioName'] as String,
      ranAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['ranAt']),
      ranBy: jsonSerialization['ranBy'] as String,
      verdict: _irobyjww.Verdict.fromJson(
        (jsonSerialization['verdict'] as String),
      ),
      predictedSeconds: jsonSerialization['predictedSeconds'] as int,
      slaSeconds: jsonSerialization['slaSeconds'] as int,
      policyCode: jsonSerialization['policyCode'] as String?,
      stages: _ighx06pg.Protocol().deserialize<List<_ijdzm3ea.StageEstimate>>(
        jsonSerialization['stages'],
      ),
      responderPlan: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['responderPlan'],
      ),
      findings: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['findings'],
      ),
      fixes: _ighx06pg.Protocol().deserialize<List<_ied9xxny.StressFix>>(
        jsonSerialization['fixes'],
      ),
      verdictAfterFix: jsonSerialization['verdictAfterFix'] == null
          ? null
          : _irobyjww.Verdict.fromJson(
              (jsonSerialization['verdictAfterFix'] as String),
            ),
      predictedAfterFixSeconds:
          jsonSerialization['predictedAfterFixSeconds'] as int?,
      planAfterFix: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['planAfterFix'],
      ),
    );
  }

  static final t = StressTestRunTable();

  static const db = StressTestRunRepository._();

  @override
  int? id;

  int campusId;

  String scenarioCode;

  String scenarioName;

  DateTime ranAt;

  String ranBy;

  _irobyjww.Verdict verdict;

  /// Predicted onset-to-arrival of the slowest required unit.
  int predictedSeconds;

  int slaSeconds;

  String? policyCode;

  List<_ijdzm3ea.StageEstimate> stages;

  List<String> responderPlan;

  List<String> findings;

  List<_ied9xxny.StressFix> fixes;

  /// Verdict when the recommended fixes are applied together.
  _irobyjww.Verdict? verdictAfterFix;

  int? predictedAfterFixSeconds;

  List<String> planAfterFix;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StressTestRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StressTestRun copyWith({
    int? id,
    int? campusId,
    String? scenarioCode,
    String? scenarioName,
    DateTime? ranAt,
    String? ranBy,
    _irobyjww.Verdict? verdict,
    int? predictedSeconds,
    int? slaSeconds,
    String? policyCode,
    List<_ijdzm3ea.StageEstimate>? stages,
    List<String>? responderPlan,
    List<String>? findings,
    List<_ied9xxny.StressFix>? fixes,
    _irobyjww.Verdict? verdictAfterFix,
    int? predictedAfterFixSeconds,
    List<String>? planAfterFix,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StressTestRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'scenarioName': scenarioName,
      'ranAt': ranAt.toJson(),
      'ranBy': ranBy,
      'verdict': verdict.toJson(),
      'predictedSeconds': predictedSeconds,
      'slaSeconds': slaSeconds,
      if (policyCode != null) 'policyCode': policyCode,
      'stages': stages.toJson(valueToJson: (v) => v.toJson()),
      'responderPlan': responderPlan.toJson(),
      'findings': findings.toJson(),
      'fixes': fixes.toJson(valueToJson: (v) => v.toJson()),
      if (verdictAfterFix != null) 'verdictAfterFix': verdictAfterFix?.toJson(),
      if (predictedAfterFixSeconds != null)
        'predictedAfterFixSeconds': predictedAfterFixSeconds,
      'planAfterFix': planAfterFix.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StressTestRun',
      if (id != null) 'id': id,
      'campusId': campusId,
      'scenarioCode': scenarioCode,
      'scenarioName': scenarioName,
      'ranAt': ranAt.toJson(),
      'ranBy': ranBy,
      'verdict': verdict.toJson(),
      'predictedSeconds': predictedSeconds,
      'slaSeconds': slaSeconds,
      if (policyCode != null) 'policyCode': policyCode,
      'stages': stages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'responderPlan': responderPlan.toJson(),
      'findings': findings.toJson(),
      'fixes': fixes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (verdictAfterFix != null) 'verdictAfterFix': verdictAfterFix?.toJson(),
      if (predictedAfterFixSeconds != null)
        'predictedAfterFixSeconds': predictedAfterFixSeconds,
      'planAfterFix': planAfterFix.toJson(),
    };
  }

  static StressTestRunInclude include() {
    return StressTestRunInclude._();
  }

  static StressTestRunIncludeList includeList({
    _is.WhereExpressionBuilder<StressTestRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StressTestRunTable>? orderBy,
    _is.OrderByListBuilder<StressTestRunTable>? orderByList,
    StressTestRunInclude? include,
  }) {
    return StressTestRunIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StressTestRun.t),
      orderByList: orderByList?.call(StressTestRun.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StressTestRunImpl extends StressTestRun {
  _StressTestRunImpl({
    int? id,
    required int campusId,
    required String scenarioCode,
    required String scenarioName,
    required DateTime ranAt,
    required String ranBy,
    required _irobyjww.Verdict verdict,
    required int predictedSeconds,
    required int slaSeconds,
    String? policyCode,
    required List<_ijdzm3ea.StageEstimate> stages,
    required List<String> responderPlan,
    required List<String> findings,
    required List<_ied9xxny.StressFix> fixes,
    _irobyjww.Verdict? verdictAfterFix,
    int? predictedAfterFixSeconds,
    required List<String> planAfterFix,
  }) : super._(
         id: id,
         campusId: campusId,
         scenarioCode: scenarioCode,
         scenarioName: scenarioName,
         ranAt: ranAt,
         ranBy: ranBy,
         verdict: verdict,
         predictedSeconds: predictedSeconds,
         slaSeconds: slaSeconds,
         policyCode: policyCode,
         stages: stages,
         responderPlan: responderPlan,
         findings: findings,
         fixes: fixes,
         verdictAfterFix: verdictAfterFix,
         predictedAfterFixSeconds: predictedAfterFixSeconds,
         planAfterFix: planAfterFix,
       );

  /// Returns a shallow copy of this [StressTestRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StressTestRun copyWith({
    Object? id = _Undefined,
    int? campusId,
    String? scenarioCode,
    String? scenarioName,
    DateTime? ranAt,
    String? ranBy,
    _irobyjww.Verdict? verdict,
    int? predictedSeconds,
    int? slaSeconds,
    Object? policyCode = _Undefined,
    List<_ijdzm3ea.StageEstimate>? stages,
    List<String>? responderPlan,
    List<String>? findings,
    List<_ied9xxny.StressFix>? fixes,
    Object? verdictAfterFix = _Undefined,
    Object? predictedAfterFixSeconds = _Undefined,
    List<String>? planAfterFix,
  }) {
    return StressTestRun(
      id: id is int? ? id : this.id,
      campusId: campusId ?? this.campusId,
      scenarioCode: scenarioCode ?? this.scenarioCode,
      scenarioName: scenarioName ?? this.scenarioName,
      ranAt: ranAt ?? this.ranAt,
      ranBy: ranBy ?? this.ranBy,
      verdict: verdict ?? this.verdict,
      predictedSeconds: predictedSeconds ?? this.predictedSeconds,
      slaSeconds: slaSeconds ?? this.slaSeconds,
      policyCode: policyCode is String? ? policyCode : this.policyCode,
      stages: stages ?? this.stages.map((e0) => e0.copyWith()).toList(),
      responderPlan:
          responderPlan ?? this.responderPlan.map((e0) => e0).toList(),
      findings: findings ?? this.findings.map((e0) => e0).toList(),
      fixes: fixes ?? this.fixes.map((e0) => e0.copyWith()).toList(),
      verdictAfterFix: verdictAfterFix is _irobyjww.Verdict?
          ? verdictAfterFix
          : this.verdictAfterFix,
      predictedAfterFixSeconds: predictedAfterFixSeconds is int?
          ? predictedAfterFixSeconds
          : this.predictedAfterFixSeconds,
      planAfterFix: planAfterFix ?? this.planAfterFix.map((e0) => e0).toList(),
    );
  }
}

class StressTestRunUpdateTable extends _is.UpdateTable<StressTestRunTable> {
  StressTestRunUpdateTable(super.table);

  _is.ColumnValue<int, int> campusId(int value) => _is.ColumnValue(
    table.campusId,
    value,
  );

  _is.ColumnValue<String, String> scenarioCode(String value) => _is.ColumnValue(
    table.scenarioCode,
    value,
  );

  _is.ColumnValue<String, String> scenarioName(String value) => _is.ColumnValue(
    table.scenarioName,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> ranAt(DateTime value) => _is.ColumnValue(
    table.ranAt,
    value,
  );

  _is.ColumnValue<String, String> ranBy(String value) => _is.ColumnValue(
    table.ranBy,
    value,
  );

  _is.ColumnValue<_irobyjww.Verdict, _irobyjww.Verdict> verdict(
    _irobyjww.Verdict value,
  ) => _is.ColumnValue(
    table.verdict,
    value,
  );

  _is.ColumnValue<int, int> predictedSeconds(int value) => _is.ColumnValue(
    table.predictedSeconds,
    value,
  );

  _is.ColumnValue<int, int> slaSeconds(int value) => _is.ColumnValue(
    table.slaSeconds,
    value,
  );

  _is.ColumnValue<String, String> policyCode(String? value) => _is.ColumnValue(
    table.policyCode,
    value,
  );

  _is.ColumnValue<List<_ijdzm3ea.StageEstimate>, List<_ijdzm3ea.StageEstimate>>
  stages(List<_ijdzm3ea.StageEstimate> value) => _is.ColumnValue(
    table.stages,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> responderPlan(
    List<String> value,
  ) => _is.ColumnValue(
    table.responderPlan,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> findings(List<String> value) =>
      _is.ColumnValue(
        table.findings,
        value,
      );

  _is.ColumnValue<List<_ied9xxny.StressFix>, List<_ied9xxny.StressFix>> fixes(
    List<_ied9xxny.StressFix> value,
  ) => _is.ColumnValue(
    table.fixes,
    value,
  );

  _is.ColumnValue<_irobyjww.Verdict, _irobyjww.Verdict> verdictAfterFix(
    _irobyjww.Verdict? value,
  ) => _is.ColumnValue(
    table.verdictAfterFix,
    value,
  );

  _is.ColumnValue<int, int> predictedAfterFixSeconds(int? value) =>
      _is.ColumnValue(
        table.predictedAfterFixSeconds,
        value,
      );

  _is.ColumnValue<List<String>, List<String>> planAfterFix(
    List<String> value,
  ) => _is.ColumnValue(
    table.planAfterFix,
    value,
  );
}

class StressTestRunTable extends _is.Table<int?> {
  StressTestRunTable({super.tableRelation})
    : super(tableName: 'stress_test_run') {
    updateTable = StressTestRunUpdateTable(this);
    campusId = _is.ColumnInt(
      'campusId',
      this,
    );
    scenarioCode = _is.ColumnString(
      'scenarioCode',
      this,
    );
    scenarioName = _is.ColumnString(
      'scenarioName',
      this,
    );
    ranAt = _is.ColumnDateTime(
      'ranAt',
      this,
    );
    ranBy = _is.ColumnString(
      'ranBy',
      this,
    );
    verdict = _is.ColumnEnum(
      'verdict',
      this,
      _is.EnumSerialization.byName,
    );
    predictedSeconds = _is.ColumnInt(
      'predictedSeconds',
      this,
    );
    slaSeconds = _is.ColumnInt(
      'slaSeconds',
      this,
    );
    policyCode = _is.ColumnString(
      'policyCode',
      this,
    );
    stages = _is.ColumnSerializable<List<_ijdzm3ea.StageEstimate>>(
      'stages',
      this,
    );
    responderPlan = _is.ColumnSerializable<List<String>>(
      'responderPlan',
      this,
    );
    findings = _is.ColumnSerializable<List<String>>(
      'findings',
      this,
    );
    fixes = _is.ColumnSerializable<List<_ied9xxny.StressFix>>(
      'fixes',
      this,
    );
    verdictAfterFix = _is.ColumnEnum(
      'verdictAfterFix',
      this,
      _is.EnumSerialization.byName,
    );
    predictedAfterFixSeconds = _is.ColumnInt(
      'predictedAfterFixSeconds',
      this,
    );
    planAfterFix = _is.ColumnSerializable<List<String>>(
      'planAfterFix',
      this,
    );
  }

  late final StressTestRunUpdateTable updateTable;

  late final _is.ColumnInt campusId;

  late final _is.ColumnString scenarioCode;

  late final _is.ColumnString scenarioName;

  late final _is.ColumnDateTime ranAt;

  late final _is.ColumnString ranBy;

  late final _is.ColumnEnum<_irobyjww.Verdict> verdict;

  /// Predicted onset-to-arrival of the slowest required unit.
  late final _is.ColumnInt predictedSeconds;

  late final _is.ColumnInt slaSeconds;

  late final _is.ColumnString policyCode;

  late final _is.ColumnSerializable<List<_ijdzm3ea.StageEstimate>> stages;

  late final _is.ColumnSerializable<List<String>> responderPlan;

  late final _is.ColumnSerializable<List<String>> findings;

  late final _is.ColumnSerializable<List<_ied9xxny.StressFix>> fixes;

  /// Verdict when the recommended fixes are applied together.
  late final _is.ColumnEnum<_irobyjww.Verdict> verdictAfterFix;

  late final _is.ColumnInt predictedAfterFixSeconds;

  late final _is.ColumnSerializable<List<String>> planAfterFix;

  @override
  List<_is.Column> get columns => [
    id,
    campusId,
    scenarioCode,
    scenarioName,
    ranAt,
    ranBy,
    verdict,
    predictedSeconds,
    slaSeconds,
    policyCode,
    stages,
    responderPlan,
    findings,
    fixes,
    verdictAfterFix,
    predictedAfterFixSeconds,
    planAfterFix,
  ];
}

class StressTestRunInclude extends _is.IncludeObject {
  StressTestRunInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StressTestRun.t;
}

class StressTestRunIncludeList extends _is.IncludeList {
  StressTestRunIncludeList._({
    _is.WhereExpressionBuilder<StressTestRunTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StressTestRun.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StressTestRun.t;
}

class StressTestRunRepository {
  const StressTestRunRepository._();

  /// Returns a list of [StressTestRun]s matching the given query parameters.
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
  Future<List<StressTestRun>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StressTestRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StressTestRunTable>? orderBy,
    _is.OrderByListBuilder<StressTestRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StressTestRun>(
      where: where?.call(StressTestRun.t),
      orderBy: orderBy?.call(StressTestRun.t),
      orderByList: orderByList?.call(StressTestRun.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StressTestRun] matching the given query parameters.
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
  Future<StressTestRun?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StressTestRunTable>? where,
    int? offset,
    _is.OrderByBuilder<StressTestRunTable>? orderBy,
    _is.OrderByListBuilder<StressTestRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StressTestRun>(
      where: where?.call(StressTestRun.t),
      orderBy: orderBy?.call(StressTestRun.t),
      orderByList: orderByList?.call(StressTestRun.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StressTestRun] by its [id] or null if no such row exists.
  Future<StressTestRun?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StressTestRun>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StressTestRun]s in the list and returns the inserted rows.
  ///
  /// The returned [StressTestRun]s will have their `id` fields set.
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
  Future<List<StressTestRun>> insert(
    _is.DatabaseSession session,
    List<StressTestRun> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StressTestRun>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StressTestRun] and returns the inserted row.
  ///
  /// The returned [StressTestRun] will have its `id` field set.
  Future<StressTestRun> insertRow(
    _is.DatabaseSession session,
    StressTestRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StressTestRun>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StressTestRun]s in the list and returns the resulting rows.
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
  /// The returned [StressTestRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StressTestRun>> upsert(
    _is.DatabaseSession session,
    List<StressTestRun> rows, {
    required _is.ColumnSelections<StressTestRunTable> conflictColumns,
    _is.ColumnSelections<StressTestRunTable>? updateColumns,
    _is.WhereExpressionBuilder<StressTestRunTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StressTestRun>(
      rows,
      conflictColumns: conflictColumns(StressTestRun.t),
      updateColumns: updateColumns?.call(StressTestRun.t),
      updateWhere: updateWhere?.call(StressTestRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StressTestRun] and returns the resulting row.
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
  /// The returned [StressTestRun] will have its `id` field set.
  Future<StressTestRun?> upsertRow(
    _is.DatabaseSession session,
    StressTestRun row, {
    required _is.ColumnSelections<StressTestRunTable> conflictColumns,
    _is.ColumnSelections<StressTestRunTable>? updateColumns,
    _is.WhereExpressionBuilder<StressTestRunTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StressTestRun>(
      row,
      conflictColumns: conflictColumns(StressTestRun.t),
      updateColumns: updateColumns?.call(StressTestRun.t),
      updateWhere: updateWhere?.call(StressTestRun.t),
      transaction: transaction,
    );
  }

  /// Updates all [StressTestRun]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StressTestRun>> update(
    _is.DatabaseSession session,
    List<StressTestRun> rows, {
    _is.ColumnSelections<StressTestRunTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StressTestRun>(
      rows,
      columns: columns?.call(StressTestRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StressTestRun]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StressTestRun> updateRow(
    _is.DatabaseSession session,
    StressTestRun row, {
    _is.ColumnSelections<StressTestRunTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StressTestRun>(
      row,
      columns: columns?.call(StressTestRun.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StressTestRun] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StressTestRun?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StressTestRunUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StressTestRun>(
      id,
      columnValues: columnValues(StressTestRun.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StressTestRun]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StressTestRun>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StressTestRunUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StressTestRunTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StressTestRunTable>? orderBy,
    _is.OrderByListBuilder<StressTestRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StressTestRun>(
      columnValues: columnValues(StressTestRun.t.updateTable),
      where: where(StressTestRun.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StressTestRun.t),
      orderByList: orderByList?.call(StressTestRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StressTestRun]s in the list and returns the deleted rows.
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
  Future<List<StressTestRun>> delete(
    _is.DatabaseSession session,
    List<StressTestRun> rows, {
    _is.OrderByBuilder<StressTestRunTable>? orderBy,
    _is.OrderByListBuilder<StressTestRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StressTestRun>(
      rows,
      orderBy: orderBy?.call(StressTestRun.t),
      orderByList: orderByList?.call(StressTestRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StressTestRun].
  Future<StressTestRun> deleteRow(
    _is.DatabaseSession session,
    StressTestRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StressTestRun>(
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
  Future<List<StressTestRun>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StressTestRunTable> where,
    _is.OrderByBuilder<StressTestRunTable>? orderBy,
    _is.OrderByListBuilder<StressTestRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StressTestRun>(
      where: where(StressTestRun.t),
      orderBy: orderBy?.call(StressTestRun.t),
      orderByList: orderByList?.call(StressTestRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StressTestRunTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StressTestRun>(
      where: where?.call(StressTestRun.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StressTestRun] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StressTestRunTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StressTestRun>(
      where: where(StressTestRun.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
