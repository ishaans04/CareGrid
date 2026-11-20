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
import 'package:caregrid_client/src/protocol/protocol.dart' as _i3n4vhm4;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Optional Gemini handoff draft. It cannot change incident or dispatch state.
abstract class IncidentBrief
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  IncidentBrief._({
    required this.incidentCode,
    required this.generatedAt,
    required this.sourceUpdatedAt,
    required this.status,
    this.summary,
    required this.evidenceRefs,
    this.model,
    required this.promptVersion,
    required this.notice,
  });

  factory IncidentBrief({
    required String incidentCode,
    required DateTime generatedAt,
    required DateTime sourceUpdatedAt,
    required String status,
    String? summary,
    required List<String> evidenceRefs,
    String? model,
    required String promptVersion,
    required String notice,
  }) = _IncidentBriefImpl;

  factory IncidentBrief.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentBrief(
      incidentCode: jsonSerialization['incidentCode'] as String,
      generatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      sourceUpdatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['sourceUpdatedAt'],
      ),
      status: jsonSerialization['status'] as String,
      summary: jsonSerialization['summary'] as String?,
      evidenceRefs: _i3n4vhm4.Protocol().deserialize<List<String>>(
        jsonSerialization['evidenceRefs'],
      ),
      model: jsonSerialization['model'] as String?,
      promptVersion: jsonSerialization['promptVersion'] as String,
      notice: jsonSerialization['notice'] as String,
    );
  }

  String incidentCode;

  DateTime generatedAt;

  DateTime sourceUpdatedAt;

  String status;

  String? summary;

  List<String> evidenceRefs;

  String? model;

  String promptVersion;

  String notice;

  /// Returns a shallow copy of this [IncidentBrief]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IncidentBrief copyWith({
    String? incidentCode,
    DateTime? generatedAt,
    DateTime? sourceUpdatedAt,
    String? status,
    String? summary,
    List<String>? evidenceRefs,
    String? model,
    String? promptVersion,
    String? notice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentBrief',
      'incidentCode': incidentCode,
      'generatedAt': generatedAt.toJson(),
      'sourceUpdatedAt': sourceUpdatedAt.toJson(),
      'status': status,
      if (summary != null) 'summary': summary,
      'evidenceRefs': evidenceRefs.toJson(),
      if (model != null) 'model': model,
      'promptVersion': promptVersion,
      'notice': notice,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentBrief',
      'incidentCode': incidentCode,
      'generatedAt': generatedAt.toJson(),
      'sourceUpdatedAt': sourceUpdatedAt.toJson(),
      'status': status,
      if (summary != null) 'summary': summary,
      'evidenceRefs': evidenceRefs.toJson(),
      if (model != null) 'model': model,
      'promptVersion': promptVersion,
      'notice': notice,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentBriefImpl extends IncidentBrief {
  _IncidentBriefImpl({
    required String incidentCode,
    required DateTime generatedAt,
    required DateTime sourceUpdatedAt,
    required String status,
    String? summary,
    required List<String> evidenceRefs,
    String? model,
    required String promptVersion,
    required String notice,
  }) : super._(
         incidentCode: incidentCode,
         generatedAt: generatedAt,
         sourceUpdatedAt: sourceUpdatedAt,
         status: status,
         summary: summary,
         evidenceRefs: evidenceRefs,
         model: model,
         promptVersion: promptVersion,
         notice: notice,
       );

  /// Returns a shallow copy of this [IncidentBrief]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IncidentBrief copyWith({
    String? incidentCode,
    DateTime? generatedAt,
    DateTime? sourceUpdatedAt,
    String? status,
    Object? summary = _Undefined,
    List<String>? evidenceRefs,
    Object? model = _Undefined,
    String? promptVersion,
    String? notice,
  }) {
    return IncidentBrief(
      incidentCode: incidentCode ?? this.incidentCode,
      generatedAt: generatedAt ?? this.generatedAt,
      sourceUpdatedAt: sourceUpdatedAt ?? this.sourceUpdatedAt,
      status: status ?? this.status,
      summary: summary is String? ? summary : this.summary,
      evidenceRefs: evidenceRefs ?? this.evidenceRefs.map((e0) => e0).toList(),
      model: model is String? ? model : this.model,
      promptVersion: promptVersion ?? this.promptVersion,
      notice: notice ?? this.notice,
    );
  }
}
