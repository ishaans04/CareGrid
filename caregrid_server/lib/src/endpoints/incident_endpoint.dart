import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/audit.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';
import '../response/incident_views.dart';
import '../response/orchestrator.dart';
import '../response/response_planner.dart';
import '../twin/twin_snapshot.dart';

/// Incident Console API: one prioritized queue of owned incidents, the
/// incident detail with evidence and recommendation, and every human action.
class IncidentEndpoint extends Endpoint {
  static const _viewers = {UserRole.command, UserRole.admin, UserRole.medical};

  /// The single prioritized queue. Medical sees incidents the hospital was
  /// alerted to.
  Future<OpsBoard> board(Session session) async {
    final actor = await Access.require(session, _viewers);
    final twin = await TwinSnapshot.load(session, actor.campusId);
    final since = CampusClock.now().subtract(const Duration(hours: 24));
    final all = await Incident.db.find(
      session,
      where: (t) =>
          t.campusId.equals(actor.campusId) &
          t.parentIncidentId.equals(null) &
          ((t.resolvedAt.equals(null) & t.dismissedAt.equals(null)) |
              (t.updatedAt > since)),
      orderBy: (t) => t.onsetAt.desc(),
    );
    final visible = actor.role == UserRole.medical
        ? all.where((i) => i.hospitalNotified).toList()
        : all;
    final summaries = await IncidentViews.summaries(
      session,
      visible,
      twin,
      role: actor.role,
    );
    final active = summaries.where((s) => s.state.open).toList()
      ..sort(IncidentViews.byUrgency);
    final recent = summaries.where((s) => !s.state.open).toList();
    final responders = twin.responders.values;
    return OpsBoard(
      generatedAt: CampusClock.now(),
      campusName: twin.campus.name,
      active: active,
      recent: recent,
      respondersAvailable: responders
          .where((r) => r.status == ResponderStatus.available)
          .length,
      respondersTotal: responders.length,
      camerasDegraded: twin.cameras.values
          .where((c) => c.health != AssetHealth.online)
          .length,
      camerasTotal: twin.cameras.length,
      escalatedOpen: active.where((s) => s.escalationLevel > 0).length,
    );
  }

  /// Full incident context for one viewer, redacted for their role and
  /// written to the audit log.
  Future<IncidentDetail> detail(Session session, int incidentId) async {
    final actor = await Access.any(session);
    final incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    final dispatches = await Orchestrator.dispatchesOf(session, incidentId);

    switch (actor.role) {
      case UserRole.responder:
        final mine = dispatches.any(
          (d) => d.responderCode == actor.user.responderCode,
        );
        if (!mine) {
          throw CareGridException(
            message: 'Responders only see incidents they are assigned to.',
            code: 'forbidden',
          );
        }
      case UserRole.member:
        throw CareGridException(
          message: 'Use the SOS screen to follow your own requests.',
          code: 'forbidden',
        );
      default:
        break;
    }

    final twin = await TwinSnapshot.load(session, incident.campusId);
    final zone = twin.zone(incident.zoneCode);
    final (redacted, redactions) = IncidentViews.redact(incident, actor.role);
    final isCommand = actor.role == UserRole.command;
    final timeline = await TimelineEntry.db.find(
      session,
      where: (t) => t.incidentId.equals(incidentId),
      orderBy: (t) => t.at,
    );
    final signals = isCommand
        ? await SensorEvent.db.find(
            session,
            where: (t) => t.incidentId.equals(incidentId),
            orderBy: (t) => t.observedAt,
          )
        : <SensorEvent>[];
    final policy = await Orchestrator.policyOf(session, incident);
    final victims = await Incident.db.find(
      session,
      where: (t) => t.parentIncidentId.equals(incidentId),
      orderBy: (t) => t.onsetAt,
    );

    ResponsePlan? plan;
    if (policy != null &&
        incident.state.open &&
        (isCommand || actor.role == UserRole.admin)) {
      final active = dispatches
          .where((d) => d.status.active)
          .map((d) => d.responderCode)
          .toSet();
      plan = ResponsePlanner(twin).plan(
        zoneCode: incident.zoneCode,
        policy: policy,
        elapsedSeconds: Orchestrator.secondsSinceOnset(incident),
        exclude: active,
      );
    }

    await Audit.log(
      session,
      actor,
      'view-incident',
      target: incident.code,
      detail: redactions.isEmpty ? 'full evidence' : 'redacted view',
    );

    return IncidentDetail(
      incident: redacted,
      zoneName: zone?.name ?? incident.zoneCode,
      zoneType: zone?.type ?? ZoneType.junction,
      timeline: isCommand
          ? timeline
          : timeline.where((e) => !e.sensitive).toList(),
      dispatches: dispatches,
      signals: signals,
      policy: policy,
      plan: plan,
      victims: await IncidentViews.summaries(session, victims, twin),
      allowedActions: _actionsFor(actor.role, incident, dispatches),
      viewerRole: actor.role,
      redactions: [
        ...redactions,
        if (!isCommand) 'Camera-evidence timeline entries',
      ],
    );
  }

  List<String> _actionsFor(
    UserRole role,
    Incident i, [
    List<Dispatch> dispatches = const [],
  ]) {
    if (!i.state.open) return const [];
    final beforeDispatch = i.dispatchedAt == null;
    return switch (role) {
      UserRole.command => [
        'confirmDispatch',
        if (i.ownerName == null) 'claim',
        if (dispatches.any((d) => d.status.active)) 'releaseUnit',
        'escalate',
        'note',
        'dismiss',
        if (i.onSceneAt != null && i.careAt != null) 'resolve',
      ],
      UserRole.medical => [
        if (!i.hospitalReady && i.hospitalNotified) 'markReady',
        'careNote',
        'escalate',
        if (i.onSceneAt != null && i.careAt != null) 'resolve',
      ],
      UserRole.admin => [if (beforeDispatch) 'note'],
      _ => const [],
    };
  }

  /// Dispatch the recommended units, or the units the operator chose.
  Future<IncidentSummary> confirmDispatch(
    Session session,
    int incidentId,
    List<String>? responderCodes,
  ) async {
    final actor = await Access.require(session, {UserRole.command});
    var incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    incident = await Orchestrator.confirmDispatch(
      session,
      incident,
      responderCodes,
      actor.label,
    );
    await Audit.log(
      session,
      actor,
      responderCodes == null ? 'confirm-dispatch' : 'override-dispatch',
      target: incident.code,
      detail: responderCodes?.join(', '),
    );
    return _summary(session, incident);
  }

  /// Stand down one assigned unit with a reason; the rest of the response
  /// continues. A unit that is no longer needed is released for other calls.
  Future<IncidentSummary> releaseUnit(
    Session session,
    int incidentId,
    int dispatchId,
    String reason,
  ) async {
    final actor = await Access.require(session, {UserRole.command});
    if (reason.trim().isEmpty) throw badRequest('A reason is required.');
    var incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    incident = await Orchestrator.recallUnit(
      session,
      incident,
      dispatchId,
      reason.trim(),
      actor.label,
    );
    await Audit.log(
      session,
      actor,
      'recall-unit',
      target: incident.code,
      detail: 'dispatch $dispatchId: ${reason.trim()}',
    );
    return _summary(session, incident);
  }

  Future<IncidentSummary> claim(Session session, int incidentId) async {
    final actor = await Access.require(session, {UserRole.command});
    var incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    incident.ownerName = actor.name;
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.operatorAction,
      actor.label,
      '${actor.name} took ownership.',
    );
    incident = await Orchestrator.save(session, incident);
    return _summary(session, incident);
  }

  Future<IncidentSummary> escalate(
    Session session,
    int incidentId,
    String note,
  ) async {
    final actor = await Access.require(session, {
      UserRole.command,
      UserRole.medical,
    });
    var incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    incident = await Orchestrator.escalate(
      session,
      incident,
      note.isEmpty ? 'Manual escalation' : note,
      actor: actor.label,
    );
    await Audit.log(
      session,
      actor,
      'escalate',
      target: incident.code,
      detail: note,
    );
    return _summary(session, incident);
  }

  Future<IncidentSummary> addNote(
    Session session,
    int incidentId,
    String note,
  ) async {
    final actor = await Access.require(session, {
      UserRole.command,
      UserRole.medical,
      UserRole.admin,
    });
    if (note.trim().isEmpty) throw badRequest('Note is empty.');
    var incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    await Orchestrator.log(
      session,
      incident,
      actor.role == UserRole.medical
          ? TimelineKind.care
          : TimelineKind.operatorAction,
      actor.label,
      note.trim(),
    );
    incident = await Orchestrator.save(session, incident);
    return _summary(session, incident);
  }

  /// Human override: reject the AI's incident (false positive) with a reason.
  Future<IncidentSummary> dismiss(
    Session session,
    int incidentId,
    String reason,
  ) async {
    final actor = await Access.require(session, {UserRole.command});
    if (reason.trim().isEmpty) throw badRequest('A reason is required.');
    var incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    incident = await Orchestrator.dismiss(
      session,
      incident,
      'Operator: ${reason.trim()}',
      actor.label,
    );
    await Audit.log(
      session,
      actor,
      'override-dismiss',
      target: incident.code,
      detail: reason,
    );
    return _summary(session, incident);
  }

  Future<IncidentSummary> resolve(
    Session session,
    int incidentId,
    String outcome,
  ) async {
    final actor = await Access.require(session, {
      UserRole.command,
      UserRole.medical,
    });
    if (outcome.trim().isEmpty) throw badRequest('An outcome is required.');
    var incident = await Orchestrator.load(session, incidentId);
    Access.requireIncident(actor, incident);
    incident = await Orchestrator.resolve(
      session,
      incident,
      outcome.trim(),
      actor.label,
    );
    await Audit.log(
      session,
      actor,
      'resolve',
      target: incident.code,
      detail: outcome,
    );
    return _summary(session, incident);
  }

  Future<IncidentSummary> _summary(Session session, Incident incident) async {
    final twin = await TwinSnapshot.load(session, incident.campusId);
    return (await IncidentViews.summaries(session, [incident], twin)).first;
  }
}
