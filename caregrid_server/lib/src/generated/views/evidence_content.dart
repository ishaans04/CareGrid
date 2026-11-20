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
import '../views/evidence_file.dart' as _is5n17wp;

/// Transient authenticated response, never a public or signed object URL.
abstract class EvidenceContent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  EvidenceContent._({
    required this.file,
    required this.base64Data,
  });

  factory EvidenceContent({
    required _is5n17wp.EvidenceFile file,
    required String base64Data,
  }) = _EvidenceContentImpl;

  factory EvidenceContent.fromJson(Map<String, dynamic> jsonSerialization) {
    return EvidenceContent(
      file: _ighx06pg.Protocol().deserialize<_is5n17wp.EvidenceFile>(
        jsonSerialization['file'],
      ),
      base64Data: jsonSerialization['base64Data'] as String,
    );
  }

  _is5n17wp.EvidenceFile file;

  String base64Data;

  /// Returns a shallow copy of this [EvidenceContent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EvidenceContent copyWith({
    _is5n17wp.EvidenceFile? file,
    String? base64Data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EvidenceContent',
      'file': file.toJson(),
      'base64Data': base64Data,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EvidenceContent',
      'file': file.toJsonForProtocol(),
      'base64Data': base64Data,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _EvidenceContentImpl extends EvidenceContent {
  _EvidenceContentImpl({
    required _is5n17wp.EvidenceFile file,
    required String base64Data,
  }) : super._(
         file: file,
         base64Data: base64Data,
       );

  /// Returns a shallow copy of this [EvidenceContent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EvidenceContent copyWith({
    _is5n17wp.EvidenceFile? file,
    String? base64Data,
  }) {
    return EvidenceContent(
      file: file ?? this.file.copyWith(),
      base64Data: base64Data ?? this.base64Data,
    );
  }
}
