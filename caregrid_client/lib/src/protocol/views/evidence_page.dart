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
import '../views/evidence_file.dart' as _is5n17wp;

abstract class EvidencePage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EvidencePage._({
    required this.status,
    required this.files,
    this.nextPageToken,
    required this.notice,
  });

  factory EvidencePage({
    required String status,
    required List<_is5n17wp.EvidenceFile> files,
    String? nextPageToken,
    required String notice,
  }) = _EvidencePageImpl;

  factory EvidencePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return EvidencePage(
      status: jsonSerialization['status'] as String,
      files: _i3n4vhm4.Protocol().deserialize<List<_is5n17wp.EvidenceFile>>(
        jsonSerialization['files'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      notice: jsonSerialization['notice'] as String,
    );
  }

  String status;

  List<_is5n17wp.EvidenceFile> files;

  String? nextPageToken;

  String notice;

  /// Returns a shallow copy of this [EvidencePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EvidencePage copyWith({
    String? status,
    List<_is5n17wp.EvidenceFile>? files,
    String? nextPageToken,
    String? notice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EvidencePage',
      'status': status,
      'files': files.toJson(valueToJson: (v) => v.toJson()),
      if (nextPageToken != null) 'nextPageToken': nextPageToken,
      'notice': notice,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EvidencePage',
      'status': status,
      'files': files.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextPageToken != null) 'nextPageToken': nextPageToken,
      'notice': notice,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EvidencePageImpl extends EvidencePage {
  _EvidencePageImpl({
    required String status,
    required List<_is5n17wp.EvidenceFile> files,
    String? nextPageToken,
    required String notice,
  }) : super._(
         status: status,
         files: files,
         nextPageToken: nextPageToken,
         notice: notice,
       );

  /// Returns a shallow copy of this [EvidencePage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EvidencePage copyWith({
    String? status,
    List<_is5n17wp.EvidenceFile>? files,
    Object? nextPageToken = _Undefined,
    String? notice,
  }) {
    return EvidencePage(
      status: status ?? this.status,
      files: files ?? this.files.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      notice: notice ?? this.notice,
    );
  }
}
