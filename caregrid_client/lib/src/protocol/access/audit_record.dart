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

/// Access and action audit: who saw what, who escalated, who dispatched, who overrode the AI, and when.
abstract class AuditRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuditRecord._({
    this.id,
    required this.at,
    this.userId,
    required this.userName,
    required this.role,
    required this.action,
    this.target,
    this.detail,
  });

  factory AuditRecord({
    int? id,
    required DateTime at,
    int? userId,
    required String userName,
    required String role,
    required String action,
    String? target,
    String? detail,
  }) = _AuditRecordImpl;

  factory AuditRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditRecord(
      id: jsonSerialization['id'] as int?,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      userId: jsonSerialization['userId'] as int?,
      userName: jsonSerialization['userName'] as String,
      role: jsonSerialization['role'] as String,
      action: jsonSerialization['action'] as String,
      target: jsonSerialization['target'] as String?,
      detail: jsonSerialization['detail'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime at;

  int? userId;

  String userName;

  String role;

  String action;

  String? target;

  String? detail;

  /// Returns a shallow copy of this [AuditRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuditRecord copyWith({
    int? id,
    DateTime? at,
    int? userId,
    String? userName,
    String? role,
    String? action,
    String? target,
    String? detail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditRecord',
      if (id != null) 'id': id,
      'at': at.toJson(),
      if (userId != null) 'userId': userId,
      'userName': userName,
      'role': role,
      'action': action,
      if (target != null) 'target': target,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditRecord',
      if (id != null) 'id': id,
      'at': at.toJson(),
      if (userId != null) 'userId': userId,
      'userName': userName,
      'role': role,
      'action': action,
      if (target != null) 'target': target,
      if (detail != null) 'detail': detail,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditRecordImpl extends AuditRecord {
  _AuditRecordImpl({
    int? id,
    required DateTime at,
    int? userId,
    required String userName,
    required String role,
    required String action,
    String? target,
    String? detail,
  }) : super._(
         id: id,
         at: at,
         userId: userId,
         userName: userName,
         role: role,
         action: action,
         target: target,
         detail: detail,
       );

  /// Returns a shallow copy of this [AuditRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuditRecord copyWith({
    Object? id = _Undefined,
    DateTime? at,
    Object? userId = _Undefined,
    String? userName,
    String? role,
    String? action,
    Object? target = _Undefined,
    Object? detail = _Undefined,
  }) {
    return AuditRecord(
      id: id is int? ? id : this.id,
      at: at ?? this.at,
      userId: userId is int? ? userId : this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      action: action ?? this.action,
      target: target is String? ? target : this.target,
      detail: detail is String? ? detail : this.detail,
    );
  }
}
