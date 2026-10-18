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
import '../response/dispatch.dart' as _iq9e3ied;
import '../twin/responder.dart' as _inukslo5;
import '../views/responder_task.dart' as _iydnmz1w;

/// Responder app home: own unit, current task and recent assignments.
abstract class ResponderHome
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ResponderHome._({
    required this.responder,
    required this.zoneName,
    this.task,
    required this.recent,
  });

  factory ResponderHome({
    required _inukslo5.Responder responder,
    required String zoneName,
    _iydnmz1w.ResponderTask? task,
    required List<_iq9e3ied.Dispatch> recent,
  }) = _ResponderHomeImpl;

  factory ResponderHome.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResponderHome(
      responder: _ighx06pg.Protocol().deserialize<_inukslo5.Responder>(
        jsonSerialization['responder'],
      ),
      zoneName: jsonSerialization['zoneName'] as String,
      task: jsonSerialization['task'] == null
          ? null
          : _ighx06pg.Protocol().deserialize<_iydnmz1w.ResponderTask>(
              jsonSerialization['task'],
            ),
      recent: _ighx06pg.Protocol().deserialize<List<_iq9e3ied.Dispatch>>(
        jsonSerialization['recent'],
      ),
    );
  }

  _inukslo5.Responder responder;

  String zoneName;

  _iydnmz1w.ResponderTask? task;

  List<_iq9e3ied.Dispatch> recent;

  /// Returns a shallow copy of this [ResponderHome]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResponderHome copyWith({
    _inukslo5.Responder? responder,
    String? zoneName,
    _iydnmz1w.ResponderTask? task,
    List<_iq9e3ied.Dispatch>? recent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResponderHome',
      'responder': responder.toJson(),
      'zoneName': zoneName,
      if (task != null) 'task': task?.toJson(),
      'recent': recent.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResponderHome',
      'responder': responder.toJsonForProtocol(),
      'zoneName': zoneName,
      if (task != null) 'task': task?.toJsonForProtocol(),
      'recent': recent.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponderHomeImpl extends ResponderHome {
  _ResponderHomeImpl({
    required _inukslo5.Responder responder,
    required String zoneName,
    _iydnmz1w.ResponderTask? task,
    required List<_iq9e3ied.Dispatch> recent,
  }) : super._(
         responder: responder,
         zoneName: zoneName,
         task: task,
         recent: recent,
       );

  /// Returns a shallow copy of this [ResponderHome]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResponderHome copyWith({
    _inukslo5.Responder? responder,
    String? zoneName,
    Object? task = _Undefined,
    List<_iq9e3ied.Dispatch>? recent,
  }) {
    return ResponderHome(
      responder: responder ?? this.responder.copyWith(),
      zoneName: zoneName ?? this.zoneName,
      task: task is _iydnmz1w.ResponderTask? ? task : this.task?.copyWith(),
      recent: recent ?? this.recent.map((e0) => e0.copyWith()).toList(),
    );
  }
}
