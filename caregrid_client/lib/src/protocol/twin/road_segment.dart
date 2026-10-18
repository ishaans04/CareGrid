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
import '../enums/road_status.dart' as _iralfy71;

/// A two-way road between two zones in the campus graph.
abstract class RoadSegment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RoadSegment._({
    this.id,
    required this.code,
    required this.name,
    required this.fromZone,
    required this.toZone,
    required this.lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
  }) : status = status ?? _iralfy71.RoadStatus.open,
       isOutsideCampus = isOutsideCampus ?? false;

  factory RoadSegment({
    int? id,
    required String code,
    required String name,
    required String fromZone,
    required String toZone,
    required int lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
  }) = _RoadSegmentImpl;

  factory RoadSegment.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoadSegment(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      fromZone: jsonSerialization['fromZone'] as String,
      toZone: jsonSerialization['toZone'] as String,
      lengthMeters: jsonSerialization['lengthMeters'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _iralfy71.RoadStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      isOutsideCampus: jsonSerialization['isOutsideCampus'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['isOutsideCampus'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String name;

  String fromZone;

  String toZone;

  int lengthMeters;

  _iralfy71.RoadStatus status;

  bool isOutsideCampus;

  /// Returns a shallow copy of this [RoadSegment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RoadSegment copyWith({
    int? id,
    String? code,
    String? name,
    String? fromZone,
    String? toZone,
    int? lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoadSegment',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'fromZone': fromZone,
      'toZone': toZone,
      'lengthMeters': lengthMeters,
      'status': status.toJson(),
      'isOutsideCampus': isOutsideCampus,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoadSegment',
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'fromZone': fromZone,
      'toZone': toZone,
      'lengthMeters': lengthMeters,
      'status': status.toJson(),
      'isOutsideCampus': isOutsideCampus,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoadSegmentImpl extends RoadSegment {
  _RoadSegmentImpl({
    int? id,
    required String code,
    required String name,
    required String fromZone,
    required String toZone,
    required int lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
  }) : super._(
         id: id,
         code: code,
         name: name,
         fromZone: fromZone,
         toZone: toZone,
         lengthMeters: lengthMeters,
         status: status,
         isOutsideCampus: isOutsideCampus,
       );

  /// Returns a shallow copy of this [RoadSegment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RoadSegment copyWith({
    Object? id = _Undefined,
    String? code,
    String? name,
    String? fromZone,
    String? toZone,
    int? lengthMeters,
    _iralfy71.RoadStatus? status,
    bool? isOutsideCampus,
  }) {
    return RoadSegment(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      fromZone: fromZone ?? this.fromZone,
      toZone: toZone ?? this.toZone,
      lengthMeters: lengthMeters ?? this.lengthMeters,
      status: status ?? this.status,
      isOutsideCampus: isOutsideCampus ?? this.isOutsideCampus,
    );
  }
}
