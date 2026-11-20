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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// De-identified operating picture of one campus for the network view. Counts and timings only: no incident codes, locations, people or evidence.
abstract class CampusPulse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CampusPulse._({
    required this.code,
    required this.name,
    required this.shortName,
    this.city,
    required this.fictional,
    this.attribution,
    required this.openIncidents,
    required this.urgentOpen,
    required this.escalatedOpen,
    required this.overdueOpen,
    required this.unitsAvailable,
    required this.unitsTotal,
    required this.camerasDegraded,
    required this.camerasTotal,
    this.mttcSeconds,
    this.rciPercent,
    required this.resolved30d,
    this.readinessPercent,
    this.readinessRanAt,
  });

  factory CampusPulse({
    required String code,
    required String name,
    required String shortName,
    String? city,
    required bool fictional,
    String? attribution,
    required int openIncidents,
    required int urgentOpen,
    required int escalatedOpen,
    required int overdueOpen,
    required int unitsAvailable,
    required int unitsTotal,
    required int camerasDegraded,
    required int camerasTotal,
    int? mttcSeconds,
    double? rciPercent,
    required int resolved30d,
    int? readinessPercent,
    DateTime? readinessRanAt,
  }) = _CampusPulseImpl;

  factory CampusPulse.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampusPulse(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      shortName: jsonSerialization['shortName'] as String,
      city: jsonSerialization['city'] as String?,
      fictional: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['fictional'],
      ),
      attribution: jsonSerialization['attribution'] as String?,
      openIncidents: jsonSerialization['openIncidents'] as int,
      urgentOpen: jsonSerialization['urgentOpen'] as int,
      escalatedOpen: jsonSerialization['escalatedOpen'] as int,
      overdueOpen: jsonSerialization['overdueOpen'] as int,
      unitsAvailable: jsonSerialization['unitsAvailable'] as int,
      unitsTotal: jsonSerialization['unitsTotal'] as int,
      camerasDegraded: jsonSerialization['camerasDegraded'] as int,
      camerasTotal: jsonSerialization['camerasTotal'] as int,
      mttcSeconds: jsonSerialization['mttcSeconds'] as int?,
      rciPercent: (jsonSerialization['rciPercent'] as num?)?.toDouble(),
      resolved30d: jsonSerialization['resolved30d'] as int,
      readinessPercent: jsonSerialization['readinessPercent'] as int?,
      readinessRanAt: jsonSerialization['readinessRanAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['readinessRanAt'],
            ),
    );
  }

  String code;

  String name;

  String shortName;

  String? city;

  bool fictional;

  String? attribution;

  int openIncidents;

  /// Open P0/P1 incidents.
  int urgentOpen;

  int escalatedOpen;

  /// Open incidents whose next deadline has already passed.
  int overdueOpen;

  int unitsAvailable;

  int unitsTotal;

  int camerasDegraded;

  int camerasTotal;

  /// Mean onset-to-care over resolved incidents in the last 30 days; null when none.
  int? mttcSeconds;

  /// Response Completion Integrity over the last 30 days; null when no dispatched case closed.
  double? rciPercent;

  int resolved30d;

  /// Latest readiness-suite score for the campus; null before any run.
  int? readinessPercent;

  DateTime? readinessRanAt;

  /// Returns a shallow copy of this [CampusPulse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CampusPulse copyWith({
    String? code,
    String? name,
    String? shortName,
    String? city,
    bool? fictional,
    String? attribution,
    int? openIncidents,
    int? urgentOpen,
    int? escalatedOpen,
    int? overdueOpen,
    int? unitsAvailable,
    int? unitsTotal,
    int? camerasDegraded,
    int? camerasTotal,
    int? mttcSeconds,
    double? rciPercent,
    int? resolved30d,
    int? readinessPercent,
    DateTime? readinessRanAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampusPulse',
      'code': code,
      'name': name,
      'shortName': shortName,
      if (city != null) 'city': city,
      'fictional': fictional,
      if (attribution != null) 'attribution': attribution,
      'openIncidents': openIncidents,
      'urgentOpen': urgentOpen,
      'escalatedOpen': escalatedOpen,
      'overdueOpen': overdueOpen,
      'unitsAvailable': unitsAvailable,
      'unitsTotal': unitsTotal,
      'camerasDegraded': camerasDegraded,
      'camerasTotal': camerasTotal,
      if (mttcSeconds != null) 'mttcSeconds': mttcSeconds,
      if (rciPercent != null) 'rciPercent': rciPercent,
      'resolved30d': resolved30d,
      if (readinessPercent != null) 'readinessPercent': readinessPercent,
      if (readinessRanAt != null) 'readinessRanAt': readinessRanAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampusPulse',
      'code': code,
      'name': name,
      'shortName': shortName,
      if (city != null) 'city': city,
      'fictional': fictional,
      if (attribution != null) 'attribution': attribution,
      'openIncidents': openIncidents,
      'urgentOpen': urgentOpen,
      'escalatedOpen': escalatedOpen,
      'overdueOpen': overdueOpen,
      'unitsAvailable': unitsAvailable,
      'unitsTotal': unitsTotal,
      'camerasDegraded': camerasDegraded,
      'camerasTotal': camerasTotal,
      if (mttcSeconds != null) 'mttcSeconds': mttcSeconds,
      if (rciPercent != null) 'rciPercent': rciPercent,
      'resolved30d': resolved30d,
      if (readinessPercent != null) 'readinessPercent': readinessPercent,
      if (readinessRanAt != null) 'readinessRanAt': readinessRanAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampusPulseImpl extends CampusPulse {
  _CampusPulseImpl({
    required String code,
    required String name,
    required String shortName,
    String? city,
    required bool fictional,
    String? attribution,
    required int openIncidents,
    required int urgentOpen,
    required int escalatedOpen,
    required int overdueOpen,
    required int unitsAvailable,
    required int unitsTotal,
    required int camerasDegraded,
    required int camerasTotal,
    int? mttcSeconds,
    double? rciPercent,
    required int resolved30d,
    int? readinessPercent,
    DateTime? readinessRanAt,
  }) : super._(
         code: code,
         name: name,
         shortName: shortName,
         city: city,
         fictional: fictional,
         attribution: attribution,
         openIncidents: openIncidents,
         urgentOpen: urgentOpen,
         escalatedOpen: escalatedOpen,
         overdueOpen: overdueOpen,
         unitsAvailable: unitsAvailable,
         unitsTotal: unitsTotal,
         camerasDegraded: camerasDegraded,
         camerasTotal: camerasTotal,
         mttcSeconds: mttcSeconds,
         rciPercent: rciPercent,
         resolved30d: resolved30d,
         readinessPercent: readinessPercent,
         readinessRanAt: readinessRanAt,
       );

  /// Returns a shallow copy of this [CampusPulse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CampusPulse copyWith({
    String? code,
    String? name,
    String? shortName,
    Object? city = _Undefined,
    bool? fictional,
    Object? attribution = _Undefined,
    int? openIncidents,
    int? urgentOpen,
    int? escalatedOpen,
    int? overdueOpen,
    int? unitsAvailable,
    int? unitsTotal,
    int? camerasDegraded,
    int? camerasTotal,
    Object? mttcSeconds = _Undefined,
    Object? rciPercent = _Undefined,
    int? resolved30d,
    Object? readinessPercent = _Undefined,
    Object? readinessRanAt = _Undefined,
  }) {
    return CampusPulse(
      code: code ?? this.code,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      city: city is String? ? city : this.city,
      fictional: fictional ?? this.fictional,
      attribution: attribution is String? ? attribution : this.attribution,
      openIncidents: openIncidents ?? this.openIncidents,
      urgentOpen: urgentOpen ?? this.urgentOpen,
      escalatedOpen: escalatedOpen ?? this.escalatedOpen,
      overdueOpen: overdueOpen ?? this.overdueOpen,
      unitsAvailable: unitsAvailable ?? this.unitsAvailable,
      unitsTotal: unitsTotal ?? this.unitsTotal,
      camerasDegraded: camerasDegraded ?? this.camerasDegraded,
      camerasTotal: camerasTotal ?? this.camerasTotal,
      mttcSeconds: mttcSeconds is int? ? mttcSeconds : this.mttcSeconds,
      rciPercent: rciPercent is double? ? rciPercent : this.rciPercent,
      resolved30d: resolved30d ?? this.resolved30d,
      readinessPercent: readinessPercent is int?
          ? readinessPercent
          : this.readinessPercent,
      readinessRanAt: readinessRanAt is DateTime?
          ? readinessRanAt
          : this.readinessRanAt,
    );
  }
}
