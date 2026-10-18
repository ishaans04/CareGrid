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
import '../enums/timeline_kind.dart' as _iag1obo8;

/// One timestamped line of the incident's audit timeline: the institutional memory.
abstract class TimelineEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TimelineEntry._({
    this.id,
    required this.incidentId,
    required this.at,
    required this.kind,
    required this.actor,
    required this.message,
    bool? sensitive,
  }) : sensitive = sensitive ?? false;

  factory TimelineEntry({
    int? id,
    required int incidentId,
    required DateTime at,
    required _iag1obo8.TimelineKind kind,
    required String actor,
    required String message,
    bool? sensitive,
  }) = _TimelineEntryImpl;

  factory TimelineEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimelineEntry(
      id: jsonSerialization['id'] as int?,
      incidentId: jsonSerialization['incidentId'] as int,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      kind: _iag1obo8.TimelineKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      actor: jsonSerialization['actor'] as String,
      message: jsonSerialization['message'] as String,
      sensitive: jsonSerialization['sensitive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['sensitive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int incidentId;

  DateTime at;

  _iag1obo8.TimelineKind kind;

  String actor;

  String message;

  /// Entries that reference camera evidence are only shown to the command role.
  bool sensitive;

  /// Returns a shallow copy of this [TimelineEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TimelineEntry copyWith({
    int? id,
    int? incidentId,
    DateTime? at,
    _iag1obo8.TimelineKind? kind,
    String? actor,
    String? message,
    bool? sensitive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimelineEntry',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'at': at.toJson(),
      'kind': kind.toJson(),
      'actor': actor,
      'message': message,
      'sensitive': sensitive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimelineEntry',
      if (id != null) 'id': id,
      'incidentId': incidentId,
      'at': at.toJson(),
      'kind': kind.toJson(),
      'actor': actor,
      'message': message,
      'sensitive': sensitive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimelineEntryImpl extends TimelineEntry {
  _TimelineEntryImpl({
    int? id,
    required int incidentId,
    required DateTime at,
    required _iag1obo8.TimelineKind kind,
    required String actor,
    required String message,
    bool? sensitive,
  }) : super._(
         id: id,
         incidentId: incidentId,
         at: at,
         kind: kind,
         actor: actor,
         message: message,
         sensitive: sensitive,
       );

  /// Returns a shallow copy of this [TimelineEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TimelineEntry copyWith({
    Object? id = _Undefined,
    int? incidentId,
    DateTime? at,
    _iag1obo8.TimelineKind? kind,
    String? actor,
    String? message,
    bool? sensitive,
  }) {
    return TimelineEntry(
      id: id is int? ? id : this.id,
      incidentId: incidentId ?? this.incidentId,
      at: at ?? this.at,
      kind: kind ?? this.kind,
      actor: actor ?? this.actor,
      message: message ?? this.message,
      sensitive: sensitive ?? this.sensitive,
    );
  }
}
