import 'package:serverpod/serverpod.dart' hide Responder;

import '../core/access.dart';
import '../core/clock.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import '../twin/twin_snapshot.dart';
import 'response_planner.dart';

/// The response orchestrator: owns every incident state transition, writes the
/// timeline, and keeps responders and incidents consistent. Endpoints, the
/// incident agent and the Proof-of-Response watchdog all go through here.
class Orchestrator {
  Orchestrator._();

  static const agentName = 'Incident Agent';
  static const watchdogName = 'Proof-of-Response';

  // ---------------------------------------------------------------- timeline

  static Future<void> log(
    Session session,
    Incident incident,
    TimelineKind kind,
    String actor,
    String message, {
    bool sensitive = false,
  }) async {
    await TimelineEntry.db.insertRow(
      session,
      TimelineEntry(
        incidentId: incident.id!,
        at: CampusClock.now(),
        kind: kind,
        actor: actor,
        message: message,
        sensitive: sensitive,
      ),
    );
  }

  static Future<Incident> save(Session session, Incident incident) async {
    incident.updatedAt = CampusClock.now();
    final saved = await Incident.db.updateRow(session, incident);
    await OpsBus.publish(session, 'incident', incidentId: saved.id);
    return saved;
  }

  static Future<ZonePolicy?> policyOf(Session session, Incident incident) {
    final code = incident.policyCode;
    if (code == null) return Future.value(null);
    return ZonePolicy.db.findFirstRow(
      session,
      where: (t) => t.code.equals(code),
    );
  }

  static int secondsSinceOnset(Incident incident) =>
      CampusClock.now().difference(incident.onsetAt).inSeconds;

  static Future<Incident> load(Session session, int incidentId) async {
    final incident = await Incident.db.findById(session, incidentId);
    if (incident == null) throw notFound('Incident $incidentId');
    return incident;
  }

  static Future<List<Dispatch>> dispatchesOf(Session session, int incidentId) =>
      Dispatch.db.find(
        session,
        where: (t) => t.incidentId.equals(incidentId),
        orderBy: (t) => t.offeredAt,
      );

  // ------------------------------------------------------------ verification

  /// Marks the incident verified, pre-alerts the hospital when the policy
  /// says so, then either auto-dispatches (life-safety SOPs) or asks the
  /// operator to confirm the recommended response.
  static Future<Incident> verify(
    Session session,
    Incident incident,
    ZonePolicy policy,
    String reason,
  ) async {
    final now = CampusClock.now();
    incident.state = IncidentState.verified;
    incident.verifiedAt ??= now;
    incident.needsHumanReview = false;
    incident.reasoning = [...incident.reasoning, 'Verified: $reason'];
    await log(
      session,
      incident,
      TimelineKind.agent,
      agentName,
      'Verified as ${incident.severity.label}: $reason',
    );

    if (policy.notifyHospital && !incident.hospitalNotified) {
      incident.hospitalNotified = true;
      await log(
        session,
        incident,
        TimelineKind.care,
        'Orchestrator',
        'Hospital emergency pre-alerted with location and nature of event.',
      );
    }

    final twin = await TwinSnapshot.load(session);
    final plan = ResponsePlanner(twin).plan(
      zoneCode: incident.zoneCode,
      policy: policy,
      elapsedSeconds: secondsSinceOnset(incident),
    );
    final names = plan.options.map((o) => o.responderName).join(' + ');

    if (policy.autoDispatch && plan.options.isNotEmpty) {
      incident = await save(session, incident);
      await log(
        session,
        incident,
        TimelineKind.policy,
        agentName,
        'SOP ${policy.code} allows autonomous dispatch for this hazard.',
      );
      return dispatch(session, incident, plan.options, '$agentName (auto)');
    }

    incident.nextAction = plan.options.isEmpty
        ? 'No unit available: escalate to incident commander'
        : 'Confirm & dispatch $names';
    incident.nextDeadline = now.add(Duration(seconds: policy.verifySlaSeconds));
    incident.nextDeadlineLabel = 'Operator confirmation';
    for (final warning in plan.warnings) {
      await log(session, incident, TimelineKind.agent, agentName, warning);
    }
    return save(session, incident);
  }

  // ---------------------------------------------------------------- dispatch

  /// Creates one [Dispatch] per option and moves the incident to dispatched.
  static Future<Incident> dispatch(
    Session session,
    Incident incident,
    List<PlanOption> options,
    String actorLabel,
  ) async {
    if (!incident.state.open) {
      throw invalidState('${incident.code} is already closed.');
    }
    final policy = await policyOf(session, incident);
    final ackSla = policy?.ackSlaSeconds ?? 30;
    final now = CampusClock.now();
    var dispatched = 0;

    for (final option in options) {
      final responder = await Responder.db.findFirstRow(
        session,
        where: (t) => t.code.equals(option.responderCode),
      );
      if (responder == null || responder.status != ResponderStatus.available) {
        await log(
          session,
          incident,
          TimelineKind.dispatch,
          actorLabel,
          '${option.responderName} is no longer available; skipped.',
        );
        continue;
      }
      final d = await Dispatch.db.insertRow(
        session,
        Dispatch(
          incidentId: incident.id!,
          responderCode: responder.code,
          responderName: responder.name,
          responderType: responder.type,
          role: option.role,
          status: DispatchStatus.offered,
          route: option.route,
          distanceMeters: option.distanceMeters,
          etaSeconds: option.etaSeconds,
          offeredAt: now,
          ackDeadline: now.add(Duration(seconds: ackSla)),
        ),
      );
      responder
        ..status = ResponderStatus.assigned
        ..activeDispatchId = d.id;
      await Responder.db.updateRow(session, responder);
      dispatched++;
      await log(
        session,
        incident,
        TimelineKind.dispatch,
        actorLabel,
        'Dispatched ${responder.name} (${responder.type.label}) via '
        '${option.routeNames.join(' > ')}: ${option.distanceMeters} m, '
        'ETA ${formatSeconds(option.etaSeconds)}. '
        'Acknowledgement due in ${formatSeconds(ackSla)}.',
      );
    }

    if (dispatched == 0) {
      return escalate(
        session,
        incident,
        'Dispatch failed: none of the selected units are available.',
        actor: actorLabel,
      );
    }
    incident.dispatchedAt ??= now;
    if (incident.state.stage < IncidentState.dispatched.stage) {
      incident.state = IncidentState.dispatched;
    }
    incident.verifiedAt ??= now;
    await OpsBus.publish(session, 'dispatch', incidentId: incident.id);
    return recompute(session, incident);
  }

  /// Operator confirmation: dispatch the recommended plan, or the units the
  /// operator picked instead (a logged override of the AI recommendation).
  static Future<Incident> confirmDispatch(
    Session session,
    Incident incident,
    List<String>? responderCodes,
    String actorLabel,
  ) async {
    if (incident.state == IncidentState.detected ||
        incident.state == IncidentState.review) {
      incident.state = IncidentState.verified;
      incident.verifiedAt ??= CampusClock.now();
      incident.needsHumanReview = false;
      await log(
        session,
        incident,
        TimelineKind.operatorAction,
        actorLabel,
        'Operator verified the incident from evidence.',
      );
    }
    final policy = await policyOf(session, incident);
    if (policy == null) throw invalidState('No policy for ${incident.code}.');
    final twin = await TwinSnapshot.load(session);
    final planner = ResponsePlanner(twin);
    final active = (await dispatchesOf(
      session,
      incident.id!,
    )).where((d) => d.status.active).map((d) => d.responderCode).toSet();

    List<PlanOption> options;
    if (responderCodes == null || responderCodes.isEmpty) {
      options = planner
          .plan(
            zoneCode: incident.zoneCode,
            policy: policy,
            elapsedSeconds: secondsSinceOnset(incident),
            exclude: active,
          )
          .options;
    } else {
      options = [];
      for (final code in responderCodes) {
        final r = twin.responders[code];
        if (r == null) continue;
        final option = planner.optionFor(
          r,
          incident.zoneCode,
          role: options.isEmpty ? 'primary' : 'support',
          slaRemaining: policy.arrivalSlaSeconds - secondsSinceOnset(incident),
        );
        if (option != null) options.add(option);
      }
      await log(
        session,
        incident,
        TimelineKind.operatorAction,
        actorLabel,
        'Operator overrode the recommendation and chose '
        '${responderCodes.join(', ')}.',
      );
    }
    if (options.isEmpty) {
      return escalate(
        session,
        incident,
        'No available unit matches the plan.',
        actor: actorLabel,
      );
    }
    return dispatch(session, incident, options, actorLabel);
  }

  // ------------------------------------------------- responder transitions

  static Future<(Dispatch, Incident)> _loadDispatch(
    Session session,
    int dispatchId,
  ) async {
    final d = await Dispatch.db.findById(session, dispatchId);
    if (d == null) throw notFound('Dispatch $dispatchId');
    final incident = await load(session, d.incidentId);
    return (d, incident);
  }

  static Future<Incident> acknowledge(
    Session session,
    int dispatchId,
    String actorLabel,
  ) async {
    var (d, incident) = await _loadDispatch(session, dispatchId);
    if (d.status != DispatchStatus.offered) {
      throw invalidState('Dispatch is ${d.status.label}, not offered.');
    }
    final now = CampusClock.now();
    d
      ..status = DispatchStatus.acknowledged
      ..acknowledgedAt = now
      ..stalled = false;
    await Dispatch.db.updateRow(session, d);
    incident.acknowledgedAt ??= now;
    await log(
      session,
      incident,
      TimelineKind.responder,
      actorLabel,
      '${d.responderName} acknowledged '
      '(${formatSeconds(now.difference(d.offeredAt).inSeconds)} after dispatch).',
    );
    return recompute(session, incident);
  }

  static Future<Incident> startEnRoute(
    Session session,
    int dispatchId,
    String actorLabel,
  ) async {
    var (d, incident) = await _loadDispatch(session, dispatchId);
    if (d.status == DispatchStatus.offered) {
      incident = await acknowledge(session, dispatchId, actorLabel);
      d = (await Dispatch.db.findById(session, dispatchId))!;
    }
    if (d.status != DispatchStatus.acknowledged) {
      throw invalidState('Dispatch is ${d.status.label}.');
    }
    final now = CampusClock.now();
    final responder = await Responder.db.findFirstRow(
      session,
      where: (t) => t.code.equals(d.responderCode),
    );
    final travel = d.etaSeconds - (responder?.mobilizationSeconds ?? 0);
    d
      ..status = DispatchStatus.enRoute
      ..enRouteAt = now
      ..arrivalDeadline = now.add(
        Duration(seconds: (travel * 1.5).round() + 30),
      )
      ..stalled = false;
    await Dispatch.db.updateRow(session, d);
    incident.enRouteAt ??= now;
    await log(
      session,
      incident,
      TimelineKind.responder,
      actorLabel,
      '${d.responderName} is moving. Route progress is now tracked against '
      'the expected trajectory.',
    );
    return recompute(session, incident);
  }

  /// Arrival is an explicit responder check-in, or labelled scenario telemetry.
  static Future<Incident> arrive(
    Session session,
    int dispatchId,
    String actorLabel, {
    required String source,
  }) async {
    var (d, incident) = await _loadDispatch(session, dispatchId);
    if (d.status == DispatchStatus.offered ||
        d.status == DispatchStatus.acknowledged) {
      d.acknowledgedAt ??= CampusClock.now();
      d.enRouteAt ??= CampusClock.now();
      incident.acknowledgedAt ??= d.acknowledgedAt;
      incident.enRouteAt ??= d.enRouteAt;
    } else if (d.status != DispatchStatus.enRoute) {
      throw invalidState('Dispatch is ${d.status.label}.');
    }
    final now = CampusClock.now();
    d
      ..status = DispatchStatus.onScene
      ..onSceneAt = now
      ..progress = 1
      ..arrivalSource = source
      ..stalled = false;
    await Dispatch.db.updateRow(session, d);
    await Responder.db.updateWhere(
      session,
      columnValues: (t) => [t.zoneCode(incident.zoneCode)],
      where: (t) => t.code.equals(d.responderCode),
    );
    incident.onSceneAt ??= now;
    await log(
      session,
      incident,
      TimelineKind.proof,
      source == 'simulation' ? watchdogName : actorLabel,
      source == 'simulation'
          ? '${d.responderName} simulated arrival at '
                '${incident.zoneCode}.'
          : '${d.responderName} checked in on scene.',
    );
    return recompute(session, incident);
  }

  static Future<Incident> startCare(
    Session session,
    int dispatchId,
    String actorLabel,
  ) async {
    var (d, incident) = await _loadDispatch(session, dispatchId);
    if (d.status != DispatchStatus.onScene) {
      throw invalidState('Care can start once the unit is on scene.');
    }
    final now = CampusClock.now();
    d
      ..status = DispatchStatus.care
      ..careAt = now
      ..stalled = false;
    await Dispatch.db.updateRow(session, d);
    incident.careAt ??= now;
    await log(
      session,
      incident,
      TimelineKind.care,
      actorLabel,
      '${d.responderName} started care / action. '
      'Time to care: ${formatSeconds(now.difference(incident.onsetAt).inSeconds)}.',
    );
    return recompute(session, incident);
  }

  static Future<Incident> complete(
    Session session,
    int dispatchId,
    String actorLabel,
    String? note,
  ) async {
    var (d, incident) = await _loadDispatch(session, dispatchId);
    if (!d.status.active) throw invalidState('Dispatch already closed.');
    if (d.status != DispatchStatus.care && d.status != DispatchStatus.onScene) {
      throw invalidState('Complete is only possible on scene.');
    }
    d
      ..status = DispatchStatus.completed
      ..completedAt = CampusClock.now()
      ..note = note;
    await Dispatch.db.updateRow(session, d);
    await _release(session, d.responderCode);
    await log(
      session,
      incident,
      TimelineKind.responder,
      actorLabel,
      '${d.responderName} completed their task'
      '${note == null || note.isEmpty ? '' : ': $note'}.',
    );
    return recompute(session, incident);
  }

  /// A responder declining is never silent: the incident is re-planned.
  static Future<Incident> decline(
    Session session,
    int dispatchId,
    String actorLabel,
    String reason,
  ) async {
    var (d, incident) = await _loadDispatch(session, dispatchId);
    if (d.status != DispatchStatus.offered &&
        d.status != DispatchStatus.acknowledged) {
      throw invalidState(
        'Only an offered or acknowledged task can be declined.',
      );
    }
    d
      ..status = DispatchStatus.declined
      ..note = reason;
    await Dispatch.db.updateRow(session, d);
    await _release(session, d.responderCode);
    await log(
      session,
      incident,
      TimelineKind.responder,
      actorLabel,
      '${d.responderName} declined: $reason',
    );
    return redispatch(session, incident, d, 'declined');
  }

  /// Finds a replacement of the same responder type after a decline or a
  /// missed acknowledgement.
  static Future<Incident> redispatch(
    Session session,
    Incident incident,
    Dispatch failed,
    String why,
  ) async {
    final policy = await policyOf(session, incident);
    if (policy == null) return recompute(session, incident);
    final twin = await TwinSnapshot.load(session);
    final tried = (await dispatchesOf(
      session,
      incident.id!,
    )).map((d) => d.responderCode).toSet();
    final plan = ResponsePlanner(twin).plan(
      zoneCode: incident.zoneCode,
      policy: policy,
      elapsedSeconds: secondsSinceOnset(incident),
      exclude: tried,
      onlyTypes: [failed.responderType],
    );
    if (plan.options.isEmpty) {
      incident.needsHumanReview = true;
      return escalate(
        session,
        incident,
        'No replacement for ${failed.responderName} ($why). '
        'Incident commander must assign a unit manually.',
      );
    }
    final replacement = plan.options.first;
    incident = await escalate(
      session,
      incident,
      '${failed.responderName} $why: re-dispatching '
      '${replacement.responderName} (ETA ${formatSeconds(replacement.etaSeconds)}).',
    );
    return dispatch(session, incident, [replacement], watchdogName);
  }

  // ------------------------------------------------------------- closure

  static Future<Incident> escalate(
    Session session,
    Incident incident,
    String reason, {
    String actor = watchdogName,
  }) async {
    incident.escalationLevel += 1;
    await log(
      session,
      incident,
      TimelineKind.escalation,
      actor,
      'Escalation level ${incident.escalationLevel}: $reason',
    );
    return save(session, incident);
  }

  /// Human override: close a false positive (or recall units) with a reason.
  static Future<Incident> dismiss(
    Session session,
    Incident incident,
    String reason,
    String actorLabel,
  ) async {
    if (!incident.state.open) throw invalidState('${incident.code} is closed.');
    for (final d in await dispatchesOf(session, incident.id!)) {
      if (!d.status.active) continue;
      d
        ..status = DispatchStatus.recalled
        ..note = 'Recalled: incident dismissed';
      await Dispatch.db.updateRow(session, d);
      await _release(session, d.responderCode);
    }
    incident
      ..state = IncidentState.dismissed
      ..dismissedAt = CampusClock.now()
      ..closureNote = reason
      ..nextAction = null
      ..nextDeadline = null
      ..nextDeadlineLabel = null
      ..needsHumanReview = false;
    await log(
      session,
      incident,
      TimelineKind.closure,
      actorLabel,
      'Dismissed: $reason',
    );
    await _closeVictims(session, incident);
    return save(session, incident);
  }

  /// Victim sub-records close with their parent incident.
  static Future<void> _closeVictims(Session session, Incident parent) async {
    final victims = await Incident.db.find(
      session,
      where: (t) => t.parentIncidentId.equals(parent.id),
    );
    final now = CampusClock.now();
    for (final v in victims.where((v) => v.state.open)) {
      v
        ..state = parent.state
        ..resolvedAt = parent.state == IncidentState.resolved ? now : null
        ..dismissedAt = parent.state == IncidentState.dismissed ? now : null
        ..careAt = parent.careAt
        ..onSceneAt = parent.onSceneAt
        ..closureNote = 'Closed with ${parent.code}: ${parent.closureNote}'
        ..updatedAt = now;
      await Incident.db.updateRow(session, v);
    }
  }

  /// The incident ends only when a human says it is resolved.
  static Future<Incident> resolve(
    Session session,
    Incident incident,
    String outcome,
    String actorLabel,
  ) async {
    if (!incident.state.open) throw invalidState('${incident.code} is closed.');
    if (incident.onSceneAt == null) {
      throw invalidState(
        'No unit has verified arrival yet. Resolve requires a verified '
        'response; dismiss instead if this was a false alarm.',
      );
    }
    if (incident.careAt == null) {
      throw invalidState(
        'Care / action has not been recorded. Confirm the response milestone '
        'before resolving; closure cannot create evidence of care.',
      );
    }
    for (final d in await dispatchesOf(session, incident.id!)) {
      if (!d.status.active) continue;
      d
        ..status = DispatchStatus.completed
        ..completedAt = CampusClock.now();
      await Dispatch.db.updateRow(session, d);
      await _release(session, d.responderCode);
    }
    final now = CampusClock.now();
    incident
      ..state = IncidentState.resolved
      ..resolvedAt = now
      ..closureNote = outcome
      ..nextAction = null
      ..nextDeadline = null
      ..nextDeadlineLabel = null
      ..needsHumanReview = false;
    await log(
      session,
      incident,
      TimelineKind.closure,
      actorLabel,
      'Resolved: $outcome. MTTC ${formatSeconds(incident.careAt!.difference(incident.onsetAt).inSeconds)}.',
    );
    await _closeVictims(session, incident);
    return save(session, incident);
  }

  static Future<void> _release(Session session, String responderCode) async {
    final r = await Responder.db.findFirstRow(
      session,
      where: (t) => t.code.equals(responderCode),
    );
    if (r == null) return;
    r
      ..status = r.status == ResponderStatus.assigned
          ? ResponderStatus.available
          : r.status
      ..activeDispatchId = null
      ..zoneCode = r.baseZoneCode;
    await Responder.db.updateRow(session, r);
    await OpsBus.publish(session, 'twin');
  }

  // ------------------------------------------------------------ recompute

  /// Derives the incident state from its dispatches and sets the next
  /// milestone Proof-of-Response expects.
  static Future<Incident> recompute(Session session, Incident incident) async {
    if (!incident.state.open) return save(session, incident);
    final dispatches = await dispatchesOf(session, incident.id!);
    final policy = await policyOf(session, incident);
    if (dispatches.isNotEmpty) {
      var stage = IncidentState.dispatched;
      for (final d in dispatches) {
        final s = switch (d.status) {
          DispatchStatus.acknowledged => IncidentState.acknowledged,
          DispatchStatus.enRoute => IncidentState.enRoute,
          DispatchStatus.onScene => IncidentState.onScene,
          DispatchStatus.care || DispatchStatus.completed => IncidentState.care,
          _ => IncidentState.dispatched,
        };
        if (s.stage > stage.stage) stage = s;
      }
      incident.state = stage;
    }

    DateTime? deadline;
    String? label;
    void consider(DateTime? at, String what) {
      if (at == null) return;
      if (deadline == null || at.isBefore(deadline!)) {
        deadline = at;
        label = what;
      }
    }

    final active = dispatches.where((d) => d.status.active).toList();
    for (final d in active) {
      switch (d.status) {
        case DispatchStatus.offered:
          consider(d.ackDeadline, 'Acknowledgement: ${d.responderName}');
        case DispatchStatus.acknowledged:
          consider(
            d.acknowledgedAt!.add(const Duration(seconds: 45)),
            'Start moving: ${d.responderName}',
          );
        case DispatchStatus.enRoute:
          consider(d.arrivalDeadline, 'Arrival: ${d.responderName}');
        case DispatchStatus.onScene:
          consider(
            d.onSceneAt!.add(Duration(seconds: policy?.careSlaSeconds ?? 120)),
            'Care start: ${d.responderName}',
          );
        default:
          break;
      }
    }
    if (dispatches.isNotEmpty) {
      incident.nextDeadline = deadline;
      incident.nextDeadlineLabel = label;
      incident.nextAction = switch (incident.state) {
        IncidentState.dispatched =>
          'Await acknowledgement from '
              '${active.map((d) => d.responderName).join(', ')}',
        IncidentState.acknowledged ||
        IncidentState.enRoute => 'Track units en route; keep the route clear',
        IncidentState.onScene => 'Confirm care has started',
        IncidentState.care =>
          active.isEmpty
              ? 'All units done: resolve with outcome'
              : 'Coordinate handover; resolve when care is complete',
        _ => incident.nextAction,
      };
    }
    return save(session, incident);
  }
}
