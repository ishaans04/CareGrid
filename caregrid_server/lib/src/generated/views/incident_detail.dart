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
import '../enums/user_role.dart' as _ifev4lwy;
import '../enums/zone_type.dart' as _i7qzwj5g;
import '../incidents/incident.dart' as _iqnzh5nn;
import '../incidents/sensor_event.dart' as _i4ab9fti;
import '../incidents/timeline_entry.dart' as _ipthwt8s;
import '../response/dispatch.dart' as _iq9e3ied;
import '../response/response_plan.dart' as _i5vuq9ku;
import '../twin/zone_policy.dart' as _ie7pqmcv;
import '../views/incident_summary.dart' as _ibgq71nj;

/// Everything one role may see about one incident. Fields are redacted per role on the server.
abstract class IncidentDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IncidentDetail._({
    required this.incident,
    required this.zoneName,
    required this.zoneType,
    required this.timeline,
    required this.dispatches,
    required this.signals,
    this.policy,
    this.plan,
    required this.victims,
    required this.allowedActions,
    required this.viewerRole,
    required this.redactions,
  });

  factory IncidentDetail({
    required _iqnzh5nn.Incident incident,
    required String zoneName,
    required _i7qzwj5g.ZoneType zoneType,
    required List<_ipthwt8s.TimelineEntry> timeline,
    required List<_iq9e3ied.Dispatch> dispatches,
    required List<_i4ab9fti.SensorEvent> signals,
    _ie7pqmcv.ZonePolicy? policy,
    _i5vuq9ku.ResponsePlan? plan,
    required List<_ibgq71nj.IncidentSummary> victims,
    required List<String> allowedActions,
    required _ifev4lwy.UserRole viewerRole,
    required List<String> redactions,
  }) = _IncidentDetailImpl;

  factory IncidentDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return IncidentDetail(
      incident: _ighx06pg.Protocol().deserialize<_iqnzh5nn.Incident>(
        jsonSerialization['incident'],
      ),
      zoneName: jsonSerialization['zoneName'] as String,
      zoneType: _i7qzwj5g.ZoneType.fromJson(
        (jsonSerialization['zoneType'] as String),
      ),
      timeline: _ighx06pg.Protocol().deserialize<List<_ipthwt8s.TimelineEntry>>(
        jsonSerialization['timeline'],
      ),
      dispatches: _ighx06pg.Protocol().deserialize<List<_iq9e3ied.Dispatch>>(
        jsonSerialization['dispatches'],
      ),
      signals: _ighx06pg.Protocol().deserialize<List<_i4ab9fti.SensorEvent>>(
        jsonSerialization['signals'],
      ),
      policy: jsonSerialization['policy'] == null
          ? null
          : _ighx06pg.Protocol().deserialize<_ie7pqmcv.ZonePolicy>(
              jsonSerialization['policy'],
            ),
      plan: jsonSerialization['plan'] == null
          ? null
          : _ighx06pg.Protocol().deserialize<_i5vuq9ku.ResponsePlan>(
              jsonSerialization['plan'],
            ),
      victims: _ighx06pg.Protocol()
          .deserialize<List<_ibgq71nj.IncidentSummary>>(
            jsonSerialization['victims'],
          ),
      allowedActions: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['allowedActions'],
      ),
      viewerRole: _ifev4lwy.UserRole.fromJson(
        (jsonSerialization['viewerRole'] as String),
      ),
      redactions: _ighx06pg.Protocol().deserialize<List<String>>(
        jsonSerialization['redactions'],
      ),
    );
  }

  _iqnzh5nn.Incident incident;

  String zoneName;

  _i7qzwj5g.ZoneType zoneType;

  List<_ipthwt8s.TimelineEntry> timeline;

  List<_iq9e3ied.Dispatch> dispatches;

  /// Raw signals (command role only).
  List<_i4ab9fti.SensorEvent> signals;

  _ie7pqmcv.ZonePolicy? policy;

  /// Recommended response while the incident is not yet dispatched.
  _i5vuq9ku.ResponsePlan? plan;

  List<_ibgq71nj.IncidentSummary> victims;

  /// Action ids this viewer may perform, e.g. confirmDispatch, dismiss, escalate, resolve.
  List<String> allowedActions;

  _ifev4lwy.UserRole viewerRole;

  /// What was hidden from this viewer and why (transparent least-privilege).
  List<String> redactions;

  /// Returns a shallow copy of this [IncidentDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IncidentDetail copyWith({
    _iqnzh5nn.Incident? incident,
    String? zoneName,
    _i7qzwj5g.ZoneType? zoneType,
    List<_ipthwt8s.TimelineEntry>? timeline,
    List<_iq9e3ied.Dispatch>? dispatches,
    List<_i4ab9fti.SensorEvent>? signals,
    _ie7pqmcv.ZonePolicy? policy,
    _i5vuq9ku.ResponsePlan? plan,
    List<_ibgq71nj.IncidentSummary>? victims,
    List<String>? allowedActions,
    _ifev4lwy.UserRole? viewerRole,
    List<String>? redactions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IncidentDetail',
      'incident': incident.toJson(),
      'zoneName': zoneName,
      'zoneType': zoneType.toJson(),
      'timeline': timeline.toJson(valueToJson: (v) => v.toJson()),
      'dispatches': dispatches.toJson(valueToJson: (v) => v.toJson()),
      'signals': signals.toJson(valueToJson: (v) => v.toJson()),
      if (policy != null) 'policy': policy?.toJson(),
      if (plan != null) 'plan': plan?.toJson(),
      'victims': victims.toJson(valueToJson: (v) => v.toJson()),
      'allowedActions': allowedActions.toJson(),
      'viewerRole': viewerRole.toJson(),
      'redactions': redactions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IncidentDetail',
      'incident': incident.toJsonForProtocol(),
      'zoneName': zoneName,
      'zoneType': zoneType.toJson(),
      'timeline': timeline.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'dispatches': dispatches.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'signals': signals.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      if (plan != null) 'plan': plan?.toJsonForProtocol(),
      'victims': victims.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'allowedActions': allowedActions.toJson(),
      'viewerRole': viewerRole.toJson(),
      'redactions': redactions.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IncidentDetailImpl extends IncidentDetail {
  _IncidentDetailImpl({
    required _iqnzh5nn.Incident incident,
    required String zoneName,
    required _i7qzwj5g.ZoneType zoneType,
    required List<_ipthwt8s.TimelineEntry> timeline,
    required List<_iq9e3ied.Dispatch> dispatches,
    required List<_i4ab9fti.SensorEvent> signals,
    _ie7pqmcv.ZonePolicy? policy,
    _i5vuq9ku.ResponsePlan? plan,
    required List<_ibgq71nj.IncidentSummary> victims,
    required List<String> allowedActions,
    required _ifev4lwy.UserRole viewerRole,
    required List<String> redactions,
  }) : super._(
         incident: incident,
         zoneName: zoneName,
         zoneType: zoneType,
         timeline: timeline,
         dispatches: dispatches,
         signals: signals,
         policy: policy,
         plan: plan,
         victims: victims,
         allowedActions: allowedActions,
         viewerRole: viewerRole,
         redactions: redactions,
       );

  /// Returns a shallow copy of this [IncidentDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IncidentDetail copyWith({
    _iqnzh5nn.Incident? incident,
    String? zoneName,
    _i7qzwj5g.ZoneType? zoneType,
    List<_ipthwt8s.TimelineEntry>? timeline,
    List<_iq9e3ied.Dispatch>? dispatches,
    List<_i4ab9fti.SensorEvent>? signals,
    Object? policy = _Undefined,
    Object? plan = _Undefined,
    List<_ibgq71nj.IncidentSummary>? victims,
    List<String>? allowedActions,
    _ifev4lwy.UserRole? viewerRole,
    List<String>? redactions,
  }) {
    return IncidentDetail(
      incident: incident ?? this.incident.copyWith(),
      zoneName: zoneName ?? this.zoneName,
      zoneType: zoneType ?? this.zoneType,
      timeline: timeline ?? this.timeline.map((e0) => e0.copyWith()).toList(),
      dispatches:
          dispatches ?? this.dispatches.map((e0) => e0.copyWith()).toList(),
      signals: signals ?? this.signals.map((e0) => e0.copyWith()).toList(),
      policy: policy is _ie7pqmcv.ZonePolicy?
          ? policy
          : this.policy?.copyWith(),
      plan: plan is _i5vuq9ku.ResponsePlan? ? plan : this.plan?.copyWith(),
      victims: victims ?? this.victims.map((e0) => e0.copyWith()).toList(),
      allowedActions:
          allowedActions ?? this.allowedActions.map((e0) => e0).toList(),
      viewerRole: viewerRole ?? this.viewerRole,
      redactions: redactions ?? this.redactions.map((e0) => e0).toList(),
    );
  }
}
