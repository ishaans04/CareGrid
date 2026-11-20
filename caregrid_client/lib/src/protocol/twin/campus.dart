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

/// A campus served by this CareGrid deployment. Every operational record (twin, incidents, units, users, audit) belongs to exactly one campus, and every query is scoped to the caller's campus.
abstract class Campus
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      fictional: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['fictional'],
      ),
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [Campus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
