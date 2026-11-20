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

/// Private attachment metadata. Object names and bucket URLs stay on the server.
abstract class EvidenceFile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EvidenceFile._({
    required this.key,
    required this.mediaType,
    required this.byteLength,
    required this.sha256,
    required this.generation,
    required this.metageneration,
    required this.createdAt,
  });

  factory EvidenceFile({
    required String key,
    required String mediaType,
    required int byteLength,
    required String sha256,
    required String generation,
    required String metageneration,
    required DateTime createdAt,
  }) = _EvidenceFileImpl;

  factory EvidenceFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return EvidenceFile(
      key: jsonSerialization['key'] as String,
      mediaType: jsonSerialization['mediaType'] as String,
      byteLength: jsonSerialization['byteLength'] as int,
      sha256: jsonSerialization['sha256'] as String,
      generation: jsonSerialization['generation'] as String,
      metageneration: jsonSerialization['metageneration'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String key;

  String mediaType;

  int byteLength;

  String sha256;

  String generation;

  String metageneration;

  DateTime createdAt;

  /// Returns a shallow copy of this [EvidenceFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EvidenceFile copyWith({
    String? key,
    String? mediaType,
    int? byteLength,
    String? sha256,
    String? generation,
    String? metageneration,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EvidenceFile',
      'key': key,
      'mediaType': mediaType,
      'byteLength': byteLength,
      'sha256': sha256,
      'generation': generation,
      'metageneration': metageneration,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EvidenceFile',
      'key': key,
      'mediaType': mediaType,
      'byteLength': byteLength,
      'sha256': sha256,
      'generation': generation,
      'metageneration': metageneration,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _EvidenceFileImpl extends EvidenceFile {
  _EvidenceFileImpl({
    required String key,
    required String mediaType,
    required int byteLength,
    required String sha256,
    required String generation,
    required String metageneration,
    required DateTime createdAt,
  }) : super._(
         key: key,
         mediaType: mediaType,
         byteLength: byteLength,
         sha256: sha256,
         generation: generation,
         metageneration: metageneration,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EvidenceFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EvidenceFile copyWith({
    String? key,
    String? mediaType,
    int? byteLength,
    String? sha256,
    String? generation,
    String? metageneration,
    DateTime? createdAt,
  }) {
    return EvidenceFile(
      key: key ?? this.key,
      mediaType: mediaType ?? this.mediaType,
      byteLength: byteLength ?? this.byteLength,
      sha256: sha256 ?? this.sha256,
      generation: generation ?? this.generation,
      metageneration: metageneration ?? this.metageneration,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
