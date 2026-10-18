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
import 'package:serverpod/serverpod.dart' as _is;

/// Category of an incident timeline entry.
enum TimelineKind implements _is.SerializableModel {
  signal,
  agent,
  policy,
  dispatch,
  responder,
  proof,
  escalation,
  operatorAction,
  care,
  closure,
  system;

  static TimelineKind fromJson(String name) {
    switch (name) {
      case 'signal':
        return TimelineKind.signal;
      case 'agent':
        return TimelineKind.agent;
      case 'policy':
        return TimelineKind.policy;
      case 'dispatch':
        return TimelineKind.dispatch;
      case 'responder':
        return TimelineKind.responder;
      case 'proof':
        return TimelineKind.proof;
      case 'escalation':
        return TimelineKind.escalation;
      case 'operatorAction':
        return TimelineKind.operatorAction;
      case 'care':
        return TimelineKind.care;
      case 'closure':
        return TimelineKind.closure;
      case 'system':
        return TimelineKind.system;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "TimelineKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
