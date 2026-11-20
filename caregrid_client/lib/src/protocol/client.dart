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
import 'dart:async' as _ida;
import 'package:caregrid_client/src/protocol/access/app_user.dart' as _iuk2443h;
import 'package:caregrid_client/src/protocol/access/audit_record.dart'
    as _inaf94tj;
import 'package:caregrid_client/src/protocol/access/demo_account.dart'
    as _izv3hd7x;
import 'package:caregrid_client/src/protocol/access/sign_in_result.dart'
    as _isffjahj;
import 'package:caregrid_client/src/protocol/enums/asset_health.dart'
    as _ixg59cvv;
import 'package:caregrid_client/src/protocol/enums/responder_status.dart'
    as _isx8do3n;
import 'package:caregrid_client/src/protocol/enums/road_status.dart'
    as _i0vdyud3;
import 'package:caregrid_client/src/protocol/incidents/sensor_event.dart'
    as _i2diccse;
import 'package:caregrid_client/src/protocol/incidents/signal_input.dart'
    as _izrej7sn;
import 'package:caregrid_client/src/protocol/readiness/readiness_summary.dart'
    as _i1n3uq96;
import 'package:caregrid_client/src/protocol/readiness/stress_scenario.dart'
    as _i8cvvux7;
import 'package:caregrid_client/src/protocol/readiness/stress_test_run.dart'
    as _iun6a96o;
import 'package:caregrid_client/src/protocol/response/route_plan.dart'
    as _ivvgd8xk;
import 'package:caregrid_client/src/protocol/simulation/scenario_run.dart'
    as _ivhq4frs;
import 'package:caregrid_client/src/protocol/simulation/simulation_status.dart'
    as _iw7811tl;
import 'package:caregrid_client/src/protocol/twin/camera.dart' as _i2jonons;
import 'package:caregrid_client/src/protocol/twin/campus.dart' as _iuambs3x;
import 'package:caregrid_client/src/protocol/twin/responder.dart' as _i9znye72;
import 'package:caregrid_client/src/protocol/twin/road_segment.dart'
    as _ikjtweu4;
import 'package:caregrid_client/src/protocol/twin/zone.dart' as _ismkci5j;
import 'package:caregrid_client/src/protocol/twin/zone_policy.dart'
    as _ijzs5hac;
import 'package:caregrid_client/src/protocol/views/campus_twin.dart'
    as _igwqpf3x;
import 'package:caregrid_client/src/protocol/views/care_case.dart' as _i3zkoq01;
import 'package:caregrid_client/src/protocol/views/evidence_content.dart'
    as _iiw8gzz6;
import 'package:caregrid_client/src/protocol/views/evidence_file.dart'
    as _ifcuo3bg;
import 'package:caregrid_client/src/protocol/views/evidence_page.dart'
    as _ir6o4nlw;
import 'package:caregrid_client/src/protocol/views/incident_brief.dart'
    as _ic5ad2f9;
import 'package:caregrid_client/src/protocol/views/incident_detail.dart'
    as _i0czyis8;
import 'package:caregrid_client/src/protocol/views/incident_summary.dart'
    as _iok9p1hs;
import 'package:caregrid_client/src/protocol/views/network_overview.dart'
    as _iwlfx8z8;
import 'package:caregrid_client/src/protocol/views/ops_board.dart' as _ictwk91n;
import 'package:caregrid_client/src/protocol/views/ops_event.dart' as _ij549iae;
import 'package:caregrid_client/src/protocol/views/ops_metrics.dart'
    as _i8jd85w1;
import 'package:caregrid_client/src/protocol/views/responder_home.dart'
    as _i9ogdjwu;
import 'package:caregrid_client/src/protocol/views/sos_status.dart'
    as _i5mcf2sk;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Demo sign-in. Each seeded account represents one role; production would
/// replace this with campus SSO behind the same authentication handler.
/// {@category Endpoint}
class EndpointAccount extends _isc.EndpointRef {
  EndpointAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'account';

  /// Accounts listed on the sign-in screen, grouped by campus.
  _ida.Future<List<_izv3hd7x.DemoAccount>> demoAccounts() =>
      caller.callServerEndpoint<List<_izv3hd7x.DemoAccount>>(
        'account',
        'demoAccounts',
        {},
      );

  _ida.Future<_isffjahj.SignInResult> signIn(
    String handle,
    String pin,
  ) => caller.callServerEndpoint<_isffjahj.SignInResult>(
    'account',
    'signIn',
    {
      'handle': handle,
      'pin': pin,
    },
  );

  _ida.Future<_iuk2443h.AppUser> me() =>
      caller.callServerEndpoint<_iuk2443h.AppUser>(
        'account',
        'me',
        {},
      );

  _ida.Future<void> signOut() => caller.callServerEndpoint<void>(
    'account',
    'signOut',
    {},
  );
}

/// Admin Control Plane: policies (SOPs), digital-twin asset state, users,
/// audit log, and demo reset. Everything is scoped to the caller's campus.
/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _ida.Future<List<_ijzs5hac.ZonePolicy>> policies() =>
      caller.callServerEndpoint<List<_ijzs5hac.ZonePolicy>>(
        'admin',
        'policies',
        {},
      );

  /// Edit thresholds, SLAs, responders and instructions of an existing SOP.
  _ida.Future<_ijzs5hac.ZonePolicy> updatePolicy(_ijzs5hac.ZonePolicy policy) =>
      caller.callServerEndpoint<_ijzs5hac.ZonePolicy>(
        'admin',
        'updatePolicy',
        {'policy': policy},
      );

  _ida.Future<_i2jonons.Camera> setCameraHealth(
    String code,
    _ixg59cvv.AssetHealth health,
  ) => caller.callServerEndpoint<_i2jonons.Camera>(
    'admin',
    'setCameraHealth',
    {
      'code': code,
      'health': health,
    },
  );

  _ida.Future<_ismkci5j.Zone> setGate(
    String zoneCode,
    bool isOpen,
    bool emergencyOverride,
  ) => caller.callServerEndpoint<_ismkci5j.Zone>(
    'admin',
    'setGate',
    {
      'zoneCode': zoneCode,
      'isOpen': isOpen,
      'emergencyOverride': emergencyOverride,
    },
  );

  /// Blocking a road during a live response makes Proof-of-Response reroute
  /// the units that would have used it.
  _ida.Future<_ikjtweu4.RoadSegment> setRoadStatus(
    String code,
    _i0vdyud3.RoadStatus status,
  ) => caller.callServerEndpoint<_ikjtweu4.RoadSegment>(
    'admin',
    'setRoadStatus',
    {
      'code': code,
      'status': status,
    },
  );

  _ida.Future<_i9znye72.Responder> setResponderStatus(
    String code,
    _isx8do3n.ResponderStatus status,
    String? note,
  ) => caller.callServerEndpoint<_i9znye72.Responder>(
    'admin',
    'setResponderStatus',
    {
      'code': code,
      'status': status,
      'note': note,
    },
  );

  _ida.Future<List<_inaf94tj.AuditRecord>> auditLog(int limit) =>
      caller.callServerEndpoint<List<_inaf94tj.AuditRecord>>(
        'admin',
        'auditLog',
        {'limit': limit},
      );

  _ida.Future<List<_iuk2443h.AppUser>> users() =>
      caller.callServerEndpoint<List<_iuk2443h.AppUser>>(
        'admin',
        'users',
        {},
      );

  /// Restores this campus's seeded twin and history. Users and the audit log
  /// are kept; other campuses are untouched.
  _ida.Future<void> resetDemo() => caller.callServerEndpoint<void>(
    'admin',
    'resetDemo',
    {},
  );
}

/// After-Action Analytics: MTTC stage by stage, RCI, false escalations and
/// blind spots, for leadership and operations.
/// {@category Endpoint}
class EndpointAnalytics extends _isc.EndpointRef {
  EndpointAnalytics(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analytics';

  _ida.Future<_i8jd85w1.OpsMetrics> metrics() =>
      caller.callServerEndpoint<_i8jd85w1.OpsMetrics>(
        'analytics',
        'metrics',
        {},
      );
}

/// Optional prose assistance. No model output enters the response state machine.
/// {@category Endpoint}
class EndpointBriefing extends _isc.EndpointRef {
  EndpointBriefing(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'briefing';

  _ida.Future<_ic5ad2f9.IncidentBrief> generate(int incidentId) =>
      caller.callServerEndpoint<_ic5ad2f9.IncidentBrief>(
        'briefing',
        'generate',
        {'incidentId': incidentId},
      );
}

/// The campus digital twin: zones, roads, cameras, responders, live map.
/// {@category Endpoint}
class EndpointCampus extends _isc.EndpointRef {
  EndpointCampus(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'campus';

  /// Role-filtered snapshot. Members only get places (for the SOS picker);
  /// cameras are visible to command and admin only.
  _ida.Future<_igwqpf3x.CampusTwin> twin() =>
      caller.callServerEndpoint<_igwqpf3x.CampusTwin>(
        'campus',
        'twin',
        {},
      );

  /// The caller's campus with its static map layers (plot outlines,
  /// parking, courts, streets). Fetched once per session; [twin] carries the
  /// live state without them.
  _ida.Future<_iuambs3x.Campus> profile() =>
      caller.callServerEndpoint<_iuambs3x.Campus>(
        'campus',
        'profile',
        {},
      );

  /// Shortest passable route between two zones right now.
  _ida.Future<_ivvgd8xk.RoutePlan> route(
    String from,
    String to,
  ) => caller.callServerEndpoint<_ivvgd8xk.RoutePlan>(
    'campus',
    'route',
    {
      'from': from,
      'to': to,
    },
  );
}

/// Hospital / Care Console API: incoming emergency context, location, ETA
/// and handoff state. No camera evidence: clinicians get what care needs.
/// {@category Endpoint}
class EndpointCare extends _isc.EndpointRef {
  EndpointCare(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'care';

  _ida.Future<List<_i3zkoq01.CareCase>> cases() =>
      caller.callServerEndpoint<List<_i3zkoq01.CareCase>>(
        'care',
        'cases',
        {},
      );

  /// The hospital confirms a bay and team are ready to receive.
  _ida.Future<void> markReady(int incidentId) =>
      caller.callServerEndpoint<void>(
        'care',
        'markReady',
        {'incidentId': incidentId},
      );
}

/// Every operation rechecks SQL membership and command role. Knowing an
/// incident/key/generation grants no access. No bucket URL reaches a client.
/// {@category Endpoint}
class EndpointEvidence extends _isc.EndpointRef {
  EndpointEvidence(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'evidence';

  _ida.Future<_ir6o4nlw.EvidencePage> list(
    int incidentId,
    String? pageToken,
  ) => caller.callServerEndpoint<_ir6o4nlw.EvidencePage>(
    'evidence',
    'list',
    {
      'incidentId': incidentId,
      'pageToken': pageToken,
    },
  );

  _ida.Future<_ifcuo3bg.EvidenceFile> upload(
    int incidentId,
    String mediaType,
    String base64Data,
  ) => caller.callServerEndpoint<_ifcuo3bg.EvidenceFile>(
    'evidence',
    'upload',
    {
      'incidentId': incidentId,
      'mediaType': mediaType,
      'base64Data': base64Data,
    },
  );

  _ida.Future<_iiw8gzz6.EvidenceContent> read(
    int incidentId,
    String key,
    String generation,
  ) => caller.callServerEndpoint<_iiw8gzz6.EvidenceContent>(
    'evidence',
    'read',
    {
      'incidentId': incidentId,
      'key': key,
      'generation': generation,
    },
  );

  _ida.Future<void> remove(
    int incidentId,
    String key,
    String generation,
  ) => caller.callServerEndpoint<void>(
    'evidence',
    'remove',
    {
      'incidentId': incidentId,
      'key': key,
      'generation': generation,
    },
  );
}

/// Incident Console API: one prioritized queue of owned incidents, the
/// incident detail with evidence and recommendation, and every human action.
/// {@category Endpoint}
class EndpointIncident extends _isc.EndpointRef {
  EndpointIncident(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'incident';

  /// The single prioritized queue. Medical sees incidents the hospital was
  /// alerted to.
  _ida.Future<_ictwk91n.OpsBoard> board() =>
      caller.callServerEndpoint<_ictwk91n.OpsBoard>(
        'incident',
        'board',
        {},
      );

  /// Full incident context for one viewer, redacted for their role and
  /// written to the audit log.
  _ida.Future<_i0czyis8.IncidentDetail> detail(int incidentId) =>
      caller.callServerEndpoint<_i0czyis8.IncidentDetail>(
        'incident',
        'detail',
        {'incidentId': incidentId},
      );

  /// Dispatch the recommended units, or the units the operator chose.
  _ida.Future<_iok9p1hs.IncidentSummary> confirmDispatch(
    int incidentId,
    List<String>? responderCodes,
  ) => caller.callServerEndpoint<_iok9p1hs.IncidentSummary>(
    'incident',
    'confirmDispatch',
    {
      'incidentId': incidentId,
      'responderCodes': responderCodes,
    },
  );

  /// Stand down one assigned unit with a reason; the rest of the response
  /// continues. A unit that is no longer needed is released for other calls.
  _ida.Future<_iok9p1hs.IncidentSummary> releaseUnit(
    int incidentId,
    int dispatchId,
    String reason,
  ) => caller.callServerEndpoint<_iok9p1hs.IncidentSummary>(
    'incident',
    'releaseUnit',
    {
      'incidentId': incidentId,
      'dispatchId': dispatchId,
      'reason': reason,
    },
  );

  _ida.Future<_iok9p1hs.IncidentSummary> claim(int incidentId) =>
      caller.callServerEndpoint<_iok9p1hs.IncidentSummary>(
        'incident',
        'claim',
        {'incidentId': incidentId},
      );

  _ida.Future<_iok9p1hs.IncidentSummary> escalate(
    int incidentId,
    String note,
  ) => caller.callServerEndpoint<_iok9p1hs.IncidentSummary>(
    'incident',
    'escalate',
    {
      'incidentId': incidentId,
      'note': note,
    },
  );

  _ida.Future<_iok9p1hs.IncidentSummary> addNote(
    int incidentId,
    String note,
  ) => caller.callServerEndpoint<_iok9p1hs.IncidentSummary>(
    'incident',
    'addNote',
    {
      'incidentId': incidentId,
      'note': note,
    },
  );

  /// Human override: reject the AI's incident (false positive) with a reason.
  _ida.Future<_iok9p1hs.IncidentSummary> dismiss(
    int incidentId,
    String reason,
  ) => caller.callServerEndpoint<_iok9p1hs.IncidentSummary>(
    'incident',
    'dismiss',
    {
      'incidentId': incidentId,
      'reason': reason,
    },
  );

  _ida.Future<_iok9p1hs.IncidentSummary> resolve(
    int incidentId,
    String outcome,
  ) => caller.callServerEndpoint<_iok9p1hs.IncidentSummary>(
    'incident',
    'resolve',
    {
      'incidentId': incidentId,
      'outcome': outcome,
    },
  );
}

/// Real-time push over Serverpod's managed WebSocket.
/// {@category Endpoint}
class EndpointLive extends _isc.EndpointRef {
  EndpointLive(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'live';

  /// Emits an [OpsEvent] whenever anything operational changes on the
  /// caller's campus. The network role receives a content-free "something
  /// changed on campus X" signal and refetches its aggregates.
  _ida.Stream<_ij549iae.OpsEvent> watch() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_ij549iae.OpsEvent>,
        _ij549iae.OpsEvent
      >(
        'live',
        'watch',
        {},
        {},
      );
}

/// Network operations: one de-identified picture across every campus (for a
/// university group, district or city hub). Counts and timings only; no
/// incident codes, locations, people or evidence leave a campus this way.
/// {@category Endpoint}
class EndpointNetwork extends _isc.EndpointRef {
  EndpointNetwork(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'network';

  _ida.Future<_iwlfx8z8.NetworkOverview> overview() =>
      caller.callServerEndpoint<_iwlfx8z8.NetworkOverview>(
        'network',
        'overview',
        {},
      );
}

/// Readiness Lab: rehearse compound failures before the emergency happens,
/// and apply the fixes the Stress-Test Engine finds to the live twin. Every
/// scenario, run and fix belongs to the caller's campus.
/// {@category Endpoint}
class EndpointReadiness extends _isc.EndpointRef {
  EndpointReadiness(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'readiness';

  _ida.Future<List<_i8cvvux7.StressScenario>> scenarios() =>
      caller.callServerEndpoint<List<_i8cvvux7.StressScenario>>(
        'readiness',
        'scenarios',
        {},
      );

  _ida.Future<_iun6a96o.StressTestRun> run(String scenarioCode) =>
      caller.callServerEndpoint<_iun6a96o.StressTestRun>(
        'readiness',
        'run',
        {'scenarioCode': scenarioCode},
      );

  /// Run an ad-hoc scenario built in the Readiness Lab form. Saved for reuse.
  _ida.Future<_iun6a96o.StressTestRun> runCustom(
    _i8cvvux7.StressScenario scenario,
  ) => caller.callServerEndpoint<_iun6a96o.StressTestRun>(
    'readiness',
    'runCustom',
    {'scenario': scenario},
  );

  _ida.Future<_i1n3uq96.ReadinessSummary> runAll() =>
      caller.callServerEndpoint<_i1n3uq96.ReadinessSummary>(
        'readiness',
        'runAll',
        {},
      );

  _ida.Future<List<_iun6a96o.StressTestRun>> history(int limit) =>
      caller.callServerEndpoint<List<_iun6a96o.StressTestRun>>(
        'readiness',
        'history',
        {'limit': limit},
      );

  /// Applies a fix found by the engine to the live twin. Codes:
  /// gate-override:ZONE, restage:RESPONDER:ZONE, restore-camera:CAMERA.
  _ida.Future<String> applyFix(String fixCode) =>
      caller.callServerEndpoint<String>(
        'readiness',
        'applyFix',
        {'fixCode': fixCode},
      );
}

/// Responder View API: minimal instructions, map route, and the buttons that
/// produce Proof-of-Response (acknowledge, en route, arrived, care, complete).
/// {@category Endpoint}
class EndpointResponder extends _isc.EndpointRef {
  EndpointResponder(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'responder';

  _ida.Future<_i9ogdjwu.ResponderHome> home() =>
      caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
        'responder',
        'home',
        {},
      );

  _ida.Future<_i9ogdjwu.ResponderHome> acknowledge(int dispatchId) =>
      caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
        'responder',
        'acknowledge',
        {'dispatchId': dispatchId},
      );

  _ida.Future<_i9ogdjwu.ResponderHome> enRoute(int dispatchId) =>
      caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
        'responder',
        'enRoute',
        {'dispatchId': dispatchId},
      );

  _ida.Future<_i9ogdjwu.ResponderHome> arrive(int dispatchId) =>
      caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
        'responder',
        'arrive',
        {'dispatchId': dispatchId},
      );

  _ida.Future<_i9ogdjwu.ResponderHome> startCare(int dispatchId) =>
      caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
        'responder',
        'startCare',
        {'dispatchId': dispatchId},
      );

  _ida.Future<_i9ogdjwu.ResponderHome> complete(
    int dispatchId,
    String? note,
  ) => caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
    'responder',
    'complete',
    {
      'dispatchId': dispatchId,
      'note': note,
    },
  );

  _ida.Future<_i9ogdjwu.ResponderHome> decline(
    int dispatchId,
    String reason,
  ) => caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
    'responder',
    'decline',
    {
      'dispatchId': dispatchId,
      'reason': reason,
    },
  );

  /// Go on or off duty. Units on a task cannot go off duty.
  _ida.Future<_i9ogdjwu.ResponderHome> setAvailability(bool available) =>
      caller.callServerEndpoint<_i9ogdjwu.ResponderHome>(
        'responder',
        'setAvailability',
        {'available': available},
      );
}

/// Edge event bus ingress. Edge gateways (or an operator) post normalized
/// signals; the Incident Agent turns them into incidents on the caller's
/// campus. Supplying [SignalInput.eventId] makes retries safe.
/// {@category Endpoint}
class EndpointSignal extends _isc.EndpointRef {
  EndpointSignal(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'signal';

  _ida.Future<_i2diccse.SensorEvent> ingest(_izrej7sn.SignalInput input) =>
      caller.callServerEndpoint<_i2diccse.SensorEvent>(
        'signal',
        'ingest',
        {'input': input},
      );

  /// Most recent signals and what the agent did with each (command only).
  _ida.Future<List<_i2diccse.SensorEvent>> recent(int limit) =>
      caller.callServerEndpoint<List<_i2diccse.SensorEvent>>(
        'signal',
        'recent',
        {'limit': limit},
      );
}

/// Simulation Lab: plays the caller's campus's seeded emergencies through the
/// live pipeline.
/// {@category Endpoint}
class EndpointSimulation extends _isc.EndpointRef {
  EndpointSimulation(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'simulation';

  _ida.Future<_iw7811tl.SimulationStatus> status() =>
      caller.callServerEndpoint<_iw7811tl.SimulationStatus>(
        'simulation',
        'status',
        {},
      );

  _ida.Future<_ivhq4frs.ScenarioRun> start(
    String code,
    bool autopilot,
  ) => caller.callServerEndpoint<_ivhq4frs.ScenarioRun>(
    'simulation',
    'start',
    {
      'code': code,
      'autopilot': autopilot,
    },
  );

  _ida.Future<_ivhq4frs.ScenarioRun> stop(int runId) =>
      caller.callServerEndpoint<_ivhq4frs.ScenarioRun>(
        'simulation',
        'stop',
        {'runId': runId},
      );

  /// Stands down every open scenario incident on this campus so demos can be
  /// repeated. Member SOS requests and other campuses are untouched.
  _ida.Future<int> clear() => caller.callServerEndpoint<int>(
    'simulation',
    'clear',
    {},
  );
}

/// Campus member SOS: the human signal channel, with closed-loop feedback
/// ("help is on the way") and no access to anyone else's data.
/// {@category Endpoint}
class EndpointSos extends _isc.EndpointRef {
  EndpointSos(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sos';

  _ida.Future<_i5mcf2sk.SosStatus> raise(
    String zoneCode,
    String? locationDetail,
    String? note,
    bool forSelf,
  ) => caller.callServerEndpoint<_i5mcf2sk.SosStatus>(
    'sos',
    'raise',
    {
      'zoneCode': zoneCode,
      'locationDetail': locationDetail,
      'note': note,
      'forSelf': forSelf,
    },
  );

  _ida.Future<List<_i5mcf2sk.SosStatus>> mine() =>
      caller.callServerEndpoint<List<_i5mcf2sk.SosStatus>>(
        'sos',
        'mine',
        {},
      );

  /// Reporter withdraws the SOS. This is negative evidence bound to their own
  /// incident: before dispatch it stands the incident down only if nobody
  /// else (camera, sensor, another member) supports it; after dispatch a
  /// human decides.
  _ida.Future<_i5mcf2sk.SosStatus> cancel(
    int incidentId,
    String reason,
  ) => caller.callServerEndpoint<_i5mcf2sk.SosStatus>(
    'sos',
    'cancel',
    {
      'incidentId': incidentId,
      'reason': reason,
    },
  );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    account = EndpointAccount(this);
    admin = EndpointAdmin(this);
    analytics = EndpointAnalytics(this);
    briefing = EndpointBriefing(this);
    campus = EndpointCampus(this);
    care = EndpointCare(this);
    evidence = EndpointEvidence(this);
    incident = EndpointIncident(this);
    live = EndpointLive(this);
    network = EndpointNetwork(this);
    readiness = EndpointReadiness(this);
    responder = EndpointResponder(this);
    signal = EndpointSignal(this);
    simulation = EndpointSimulation(this);
    sos = EndpointSos(this);
  }

  late final EndpointAccount account;

  late final EndpointAdmin admin;

  late final EndpointAnalytics analytics;

  late final EndpointBriefing briefing;

  late final EndpointCampus campus;

  late final EndpointCare care;

  late final EndpointEvidence evidence;

  late final EndpointIncident incident;

  late final EndpointLive live;

  late final EndpointNetwork network;

  late final EndpointReadiness readiness;

  late final EndpointResponder responder;

  late final EndpointSignal signal;

  late final EndpointSimulation simulation;

  late final EndpointSos sos;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'account': account,
    'admin': admin,
    'analytics': analytics,
    'briefing': briefing,
    'campus': campus,
    'care': care,
    'evidence': evidence,
    'incident': incident,
    'live': live,
    'network': network,
    'readiness': readiness,
    'responder': responder,
    'signal': signal,
    'simulation': simulation,
    'sos': sos,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
