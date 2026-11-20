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
import '../readiness/stage_estimate.dart' as _ijdzm3ea;

/// After-action analytics: MTTC stage by stage, Response Completion Integrity and trust metrics.
abstract class OpsMetrics
    implements _is.SerializableModel, _is.ProtocolSerialization {
  OpsMetrics._({
    required this.generatedAt,
    this.mttcSeconds,
    this.mttcMedianSeconds,
    this.mttcP90Seconds,
    required this.mttcSamples,
    required this.rciClosed,
    required this.rciVerified,
    required this.stages,
    this.rciPercent,
    this.falseEscalationPercent,
    this.blindSpotPercent,
    required this.incidentsTotal,
    required this.resolved,
    required this.dismissed,
    required this.open,
    required this.escalations,
    required this.dismissReasons,
    required this.byFamily,
    required this.bySeverity,
    required this.byZone,
  });

  factory OpsMetrics({
    required DateTime generatedAt,
    double? mttcSeconds,
    double? mttcMedianSeconds,
    double? mttcP90Seconds,
    required int mttcSamples,
    required int rciClosed,
    required int rciVerified,
    required List<_ijdzm3ea.StageEstimate> stages,
    double? rciPercent,
    double? falseEscalationPercent,
    double? blindSpotPercent,
    required int incidentsTotal,
    required int resolved,
    required int dismissed,
    required int open,
    required int escalations,
    required Map<String, int> dismissReasons,
    required Map<String, int> byFamily,
    required Map<String, int> bySeverity,
    required Map<String, int> byZone,
  }) = _OpsMetricsImpl;

  factory OpsMetrics.fromJson(Map<String, dynamic> jsonSerialization) {
    return OpsMetrics(
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      mttcSeconds: (jsonSerialization['mttcSeconds'] as num?)?.toDouble(),
      mttcMedianSeconds: (jsonSerialization['mttcMedianSeconds'] as num?)
          ?.toDouble(),
      mttcP90Seconds: (jsonSerialization['mttcP90Seconds'] as num?)?.toDouble(),
      mttcSamples: jsonSerialization['mttcSamples'] as int,
      rciClosed: jsonSerialization['rciClosed'] as int,
      rciVerified: jsonSerialization['rciVerified'] as int,
      stages: _ighx06pg.Protocol().deserialize<List<_ijdzm3ea.StageEstimate>>(
        jsonSerialization['stages'],
      ),
      rciPercent: (jsonSerialization['rciPercent'] as num?)?.toDouble(),
      falseEscalationPercent:
          (jsonSerialization['falseEscalationPercent'] as num?)?.toDouble(),
      blindSpotPercent: (jsonSerialization['blindSpotPercent'] as num?)
          ?.toDouble(),
      incidentsTotal: jsonSerialization['incidentsTotal'] as int,
      resolved: jsonSerialization['resolved'] as int,
      dismissed: jsonSerialization['dismissed'] as int,
      open: jsonSerialization['open'] as int,
      escalations: jsonSerialization['escalations'] as int,
      dismissReasons: _ighx06pg.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['dismissReasons'],
      ),
      byFamily: _ighx06pg.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['byFamily'],
      ),
      bySeverity: _ighx06pg.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['bySeverity'],
      ),
      byZone: _ighx06pg.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['byZone'],
      ),
    );
  }

  DateTime generatedAt;

  /// Mean Time To Care: onset to care initiated, in seconds.
  double? mttcSeconds;

  /// Distribution of the same measurement: means hide the slow tail that matters in an emergency.
  double? mttcMedianSeconds;

  double? mttcP90Seconds;

  /// Number of incidents with both onset and care recorded (the MTTC denominator).
  int mttcSamples;

  /// Closed dispatched incidents (the RCI denominator) and how many of them were fully verified.
  int rciClosed;

  int rciVerified;

  /// Mean latency of each stage (detection, verification, dispatch, acknowledgement, arrival, care start).
  List<_ijdzm3ea.StageEstimate> stages;

  /// Response Completion Integrity: share of dispatched incidents verified through arrival and care with no silent failure.
  double? rciPercent;

  /// Dismissed after verification / verified.
  double? falseEscalationPercent;

  /// Incidents with degraded or blind observability / all incidents.
  double? blindSpotPercent;

  int incidentsTotal;

  int resolved;

  int dismissed;

  int open;

  int escalations;

  Map<String, int> dismissReasons;

  Map<String, int> byFamily;

  Map<String, int> bySeverity;

  /// Incidents per zone name, for coverage planning.
  Map<String, int> byZone;

  /// Returns a shallow copy of this [OpsMetrics]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OpsMetrics copyWith({
    DateTime? generatedAt,
    double? mttcSeconds,
    double? mttcMedianSeconds,
    double? mttcP90Seconds,
    int? mttcSamples,
    int? rciClosed,
    int? rciVerified,
    List<_ijdzm3ea.StageEstimate>? stages,
    double? rciPercent,
    double? falseEscalationPercent,
    double? blindSpotPercent,
    int? incidentsTotal,
    int? resolved,
    int? dismissed,
    int? open,
    int? escalations,
    Map<String, int>? dismissReasons,
    Map<String, int>? byFamily,
    Map<String, int>? bySeverity,
    Map<String, int>? byZone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OpsMetrics',
      'generatedAt': generatedAt.toJson(),
      if (mttcSeconds != null) 'mttcSeconds': mttcSeconds,
      if (mttcMedianSeconds != null) 'mttcMedianSeconds': mttcMedianSeconds,
      if (mttcP90Seconds != null) 'mttcP90Seconds': mttcP90Seconds,
      'mttcSamples': mttcSamples,
      'rciClosed': rciClosed,
      'rciVerified': rciVerified,
      'stages': stages.toJson(valueToJson: (v) => v.toJson()),
      if (rciPercent != null) 'rciPercent': rciPercent,
      if (falseEscalationPercent != null)
        'falseEscalationPercent': falseEscalationPercent,
      if (blindSpotPercent != null) 'blindSpotPercent': blindSpotPercent,
      'incidentsTotal': incidentsTotal,
      'resolved': resolved,
      'dismissed': dismissed,
      'open': open,
      'escalations': escalations,
      'dismissReasons': dismissReasons.toJson(),
      'byFamily': byFamily.toJson(),
      'bySeverity': bySeverity.toJson(),
      'byZone': byZone.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OpsMetrics',
      'generatedAt': generatedAt.toJson(),
      if (mttcSeconds != null) 'mttcSeconds': mttcSeconds,
      if (mttcMedianSeconds != null) 'mttcMedianSeconds': mttcMedianSeconds,
      if (mttcP90Seconds != null) 'mttcP90Seconds': mttcP90Seconds,
      'mttcSamples': mttcSamples,
      'rciClosed': rciClosed,
      'rciVerified': rciVerified,
      'stages': stages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (rciPercent != null) 'rciPercent': rciPercent,
      if (falseEscalationPercent != null)
        'falseEscalationPercent': falseEscalationPercent,
      if (blindSpotPercent != null) 'blindSpotPercent': blindSpotPercent,
      'incidentsTotal': incidentsTotal,
      'resolved': resolved,
      'dismissed': dismissed,
      'open': open,
      'escalations': escalations,
      'dismissReasons': dismissReasons.toJson(),
      'byFamily': byFamily.toJson(),
      'bySeverity': bySeverity.toJson(),
      'byZone': byZone.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OpsMetricsImpl extends OpsMetrics {
  _OpsMetricsImpl({
    required DateTime generatedAt,
    double? mttcSeconds,
    double? mttcMedianSeconds,
    double? mttcP90Seconds,
    required int mttcSamples,
    required int rciClosed,
    required int rciVerified,
    required List<_ijdzm3ea.StageEstimate> stages,
    double? rciPercent,
    double? falseEscalationPercent,
    double? blindSpotPercent,
    required int incidentsTotal,
    required int resolved,
    required int dismissed,
    required int open,
    required int escalations,
    required Map<String, int> dismissReasons,
    required Map<String, int> byFamily,
    required Map<String, int> bySeverity,
    required Map<String, int> byZone,
  }) : super._(
         generatedAt: generatedAt,
         mttcSeconds: mttcSeconds,
         mttcMedianSeconds: mttcMedianSeconds,
         mttcP90Seconds: mttcP90Seconds,
         mttcSamples: mttcSamples,
         rciClosed: rciClosed,
         rciVerified: rciVerified,
         stages: stages,
         rciPercent: rciPercent,
         falseEscalationPercent: falseEscalationPercent,
         blindSpotPercent: blindSpotPercent,
         incidentsTotal: incidentsTotal,
         resolved: resolved,
         dismissed: dismissed,
         open: open,
         escalations: escalations,
         dismissReasons: dismissReasons,
         byFamily: byFamily,
         bySeverity: bySeverity,
         byZone: byZone,
       );

  /// Returns a shallow copy of this [OpsMetrics]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OpsMetrics copyWith({
    DateTime? generatedAt,
    Object? mttcSeconds = _Undefined,
    Object? mttcMedianSeconds = _Undefined,
    Object? mttcP90Seconds = _Undefined,
    int? mttcSamples,
    int? rciClosed,
    int? rciVerified,
    List<_ijdzm3ea.StageEstimate>? stages,
    Object? rciPercent = _Undefined,
    Object? falseEscalationPercent = _Undefined,
    Object? blindSpotPercent = _Undefined,
    int? incidentsTotal,
    int? resolved,
    int? dismissed,
    int? open,
    int? escalations,
    Map<String, int>? dismissReasons,
    Map<String, int>? byFamily,
    Map<String, int>? bySeverity,
    Map<String, int>? byZone,
  }) {
    return OpsMetrics(
      generatedAt: generatedAt ?? this.generatedAt,
      mttcSeconds: mttcSeconds is double? ? mttcSeconds : this.mttcSeconds,
      mttcMedianSeconds: mttcMedianSeconds is double?
          ? mttcMedianSeconds
          : this.mttcMedianSeconds,
      mttcP90Seconds: mttcP90Seconds is double?
          ? mttcP90Seconds
          : this.mttcP90Seconds,
      mttcSamples: mttcSamples ?? this.mttcSamples,
      rciClosed: rciClosed ?? this.rciClosed,
      rciVerified: rciVerified ?? this.rciVerified,
      stages: stages ?? this.stages.map((e0) => e0.copyWith()).toList(),
      rciPercent: rciPercent is double? ? rciPercent : this.rciPercent,
      falseEscalationPercent: falseEscalationPercent is double?
          ? falseEscalationPercent
          : this.falseEscalationPercent,
      blindSpotPercent: blindSpotPercent is double?
          ? blindSpotPercent
          : this.blindSpotPercent,
      incidentsTotal: incidentsTotal ?? this.incidentsTotal,
      resolved: resolved ?? this.resolved,
      dismissed: dismissed ?? this.dismissed,
      open: open ?? this.open,
      escalations: escalations ?? this.escalations,
      dismissReasons:
          dismissReasons ??
          this.dismissReasons.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      byFamily:
          byFamily ??
          this.byFamily.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      bySeverity:
          bySeverity ??
          this.bySeverity.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      byZone:
          byZone ??
          this.byZone.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
