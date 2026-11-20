import 'package:serverpod/serverpod.dart' hide Responder;

import '../core/access.dart';
import '../core/clock.dart';
import '../core/locks.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import '../twin/twin_snapshot.dart';
import 'response_planner.dart';

/// The response orchestrator: owns every incident state transition, writes the
/// timeline, and keeps responders and incidents consistent. Endpoints, the
/// incident agent and the Proof-of-Response watchdog all go through here.
///
/// Concurrency rules:
/// * a unit is reserved under its row lock, so two incidents (or two
///   operators) can never hold the same ambulance;
/// * every dispatch transition re-reads the dispatch under its row lock, so a
///   responder's tap and the watchdog's timeout cannot both win;
/// * incidents are saved only from their latest revision; a stale copy raises
///   a typed conflict instead of overwriting newer state.
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

  /// Saves [incident] if nobody has saved it since it was read. The caller's
  /// object receives the new revision, so a flow can save the same copy
  /// several times in sequence.
  static Future<Incident> save(Session session, Incident incident) async {
    final saved = await RowLock.on(
      session,
      LockedTable.incident,
      incident.id!,
      (transaction) async {
        final current = await RowLock.incidentRevision(
          session,
          incident.id!,
          transaction,
        );
        if (current == null) throw notFound('Incident ${incident.code}');
        if (current != incident.revision) throw staleIncident(incident.code);
        incident
          ..revision = current + 1
          ..updatedAt = CampusClock.now();
        return Incident.db.updateRow(
          session,
          incident,
          transaction: transaction,
        );
      },
    );
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

  /// Re-reads [dispatchId] under its row lock and stores [apply]'s result.
  /// [apply] throws (typically [invalidState]) when the transition no longer
  /// fits the dispatch's current status.
  static Future<Dispatch> transition(
    Session session,
    int dispatchId,
    Dispatch Function(Dispatch current) apply,
  ) => RowLock.on(session, LockedTable.dispatch, dispatchId, (
    transaction,
  ) async {
    final current = await Dispatch.db.findById(
      session,
      dispatchId,
      transaction: transaction,
    );
    if (current == null) throw notFound('Dispatch $dispatchId');
    return Dispatch.db.updateRow(
      session,
      apply(current),
      transaction: transaction,
    );
  });

  /// Like [transition], but returns null instead of throwing when the
  /// dispatch has moved on. Used by the watchdog, which simply re-evaluates
  /// on its next pass.
  static Future<Dispatch?> tryTransition(
    Session session,
    int dispatchId,
    Dispatch? Function(Dispatch current) apply,
  ) => RowLock.on(session, LockedTable.dispatch, dispatchId, (
    transaction,
  ) async {
    final current = await Dispatch.db.findById(
      session,
      dispatchId,
      transaction: transaction,
    );
    if (current == null) return null;
    final next = apply(current);
    if (next == null) return null;
    return Dispatch.db.updateRow(session, next, transaction: transaction);
  });

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
  /// Each unit is reserved atomically: a unit taken by another incident since
  /// the plan was computed is skipped and recorded, never double-assigned.
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
      final reserved = await _reserve(session, incident, option, now, ackSla);
      if (reserved == null) {
        await log(
          session,
          incident,
          TimelineKind.dispatch,
          actorLabel,
          '${option.responderName} is no longer available; skipped.',
        );
        continue;
      }
      final (responder, _) = reserved;
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
    await OpsBus.publish(session, 'twin');
    return recompute(session, incident);
  }

  /// Claims an available unit and creates its dispatch in one transaction.
  static Future<(Responder, Dispatch)?> _reserve(
    Session session,
    Incident incident,
    PlanOption option,
    DateTime now,
    int ackSla,
  ) async {
    final found = await Responder.db.findFirstRow(
      session,
      where: (t) => t.code.equals(option.responderCode),
    );
    if (found == null) return null;
    return RowLock.on(session, LockedTable.responder, found.id!, (
      transaction,
    ) async {
      final responder = await Responder.db.findById(
        session,
        found.id!,
        transaction: transaction,
      );
      if (responder == null || responder.status != ResponderStatus.available) {
        return null;
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
        transaction: transaction,
      );
      responder
        ..status = ResponderStatus.assigned
        ..activeDispatchId = d.id
        ..statusNote = null;
      await Responder.db.updateRow(
        session,
        responder,
        transaction: transaction,
      );
      return (responder, d);
    });
  }

  /// Operator confirmation: dispatch the recommended plan, or the units the
  /// operator picked instead (a logged override of the AI recommendation).
  static Future<Incident> confirmDispatch(
    Session session,
    Incident incident,
    List<String>? responderCodes,
    String actorLabel,
  ) async {
    if (!incident.state.open) {
      throw invalidState('${incident.code} is already closed.');
    }
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
      for (final code in responderCodes.toSet()) {
        if (active.contains(code)) continue;
        final r = twin.responders[code];
        if (r == null) throw badRequest('Unknown unit $code.');
        final option = planner.optionFor(
          r,
          incident.zoneCode,
          role: options.isEmpty && active.isEmpty ? 'primary' : 'support',
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

  static Future<Incident> acknowledge(
    Session session,
    int dispatchId,
    String actorLabel,
  ) async {
    final now = CampusClock.now();
    final d = await transition(session, dispatchId, (d) {
      if (d.status != DispatchStatus.offered) {
        throw invalidState('Dispatch is ${d.status.label}, not offered.');
      }
      return d
        ..status = DispatchStatus.acknowledged
        ..acknowledgedAt = now
        ..stalled = false;
    });
    final incident = await load(session, d.incidentId);
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
    final current = await Dispatch.db.findById(session, dispatchId);
    if (current == null) throw notFound('Dispatch $dispatchId');
    if (current.status == DispatchStatus.offered) {
      await acknowledge(session, dispatchId, actorLabel);
    }
    final responder = await Responder.db.findFirstRow(
      session,
      where: (t) => t.code.equals(current.responderCode),
    );
    final now = CampusClock.now();
    final d = await transition(session, dispatchId, (d) {
      if (d.status != DispatchStatus.acknowledged) {
        throw invalidState('Dispatch is ${d.status.label}.');
      }
      final travel = d.etaSeconds - (responder?.mobilizationSeconds ?? 0);
      return d
        ..status = DispatchStatus.enRoute
        ..enRouteAt = now
        ..arrivalDeadline = now.add(
          Duration(seconds: (travel * 1.5).round() + 30),
        )
        ..stalled = false;
    });
    final incident = await load(session, d.incidentId);
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
    final now = CampusClock.now();
    final d = await transition(session, dispatchId, (d) {
      if (d.status == DispatchStatus.offered ||
          d.status == DispatchStatus.acknowledged) {
        d.acknowledgedAt ??= now;
        d.enRouteAt ??= now;
      } else if (d.status != DispatchStatus.enRoute) {
        throw invalidState('Dispatch is ${d.status.label}.');
      }
      return d
        ..status = DispatchStatus.onScene
        ..onSceneAt = now
        ..progress = 1
        ..arrivalSource = source
        ..stalled = false;
    });
    final incident = await load(session, d.incidentId);
    incident.acknowledgedAt ??= d.acknowledgedAt;
    incident.enRouteAt ??= d.enRouteAt;
    await Responder.db.updateWhere(
      session,
      columnValues: (t) => [t.zoneCode(incident.zoneCode)],
      where: (t) =>
          t.code.equals(d.responderCode) & t.activeDispatchId.equals(d.id),
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
    final now = CampusClock.now();
    final d = await transition(session, dispatchId, (d) {
      if (d.status != DispatchStatus.onScene) {
        throw invalidState('Care can start once the unit is on scene.');
      }
      return d
        ..status = DispatchStatus.care
        ..careAt = now
        ..stalled = false;
    });
    final incident = await load(session, d.incidentId);
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
    final d = await transition(session, dispatchId, (d) {
      if (!d.status.active) throw invalidState('Dispatch already closed.');
      if (d.status != DispatchStatus.care &&
          d.status != DispatchStatus.onScene) {
        throw invalidState('Complete is only possible on scene.');
      }
      return d
        ..status = DispatchStatus.completed
        ..completedAt = CampusClock.now()
        ..note = note;
    });
    await _release(session, d);
    final incident = await load(session, d.incidentId);
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
    final d = await transition(session, dispatchId, (d) {
      if (d.status != DispatchStatus.offered &&
          d.status != DispatchStatus.acknowledged) {
        throw invalidState(
          'Only an offered or acknowledged task can be declined.',
        );
      }
      return d
        ..status = DispatchStatus.declined
        ..note = reason;
    });
    await _release(session, d);
    final incident = await load(session, d.incidentId);
    await log(
      session,
      incident,
      TimelineKind.responder,
      actorLabel,
      '${d.responderName} declined: $reason',
    );
    return redispatch(session, incident, d, 'declined');
  }

  /// Command stands down one unit (for example a second ambulance that is no
  /// longer needed). The unit is released; the rest of the response continues.
  static Future<Incident> recallUnit(
    Session session,
    Incident incident,
    int dispatchId,
    String reason,
    String actorLabel,
  ) async {
    if (!incident.state.open) throw invalidState('${incident.code} is closed.');
    final d = await transition(session, dispatchId, (d) {
      if (d.incidentId != incident.id) {
        throw badRequest('That unit is not assigned to ${incident.code}.');
      }
      if (!d.status.active) {
        throw invalidState('${d.responderName} is already ${d.status.label}.');
      }
      return d
        ..status = DispatchStatus.recalled
        ..note = 'Recalled by command: $reason';
    });
    await _release(session, d);
    incident = await load(session, incident.id!);
    await log(
      session,
      incident,
      TimelineKind.operatorAction,
      actorLabel,
      'Stood down ${d.responderName}: $reason',
    );
    await OpsBus.publish(session, 'dispatch', incidentId: incident.id);
    return recompute(session, incident);
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
      incident = await escalate(
        session,
        incident,
        'No replacement for ${failed.responderName} ($why). '
        'Incident commander must assign a unit manually.',
      );
      return recompute(session, incident);
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
      final recalled = await tryTransition(
        session,
        d.id!,
        (current) => current.status.active
            ? (current
                ..status = DispatchStatus.recalled
                ..note = 'Recalled: incident dismissed')
            : null,
      );
      if (recalled != null) await _release(session, recalled);
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
    final saved = await save(session, incident);
    await _closeVictims(session, saved);
    return saved;
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
        ..nextAction = null
        ..nextDeadline = null
        ..nextDeadlineLabel = null;
      await save(session, v);
    }
  }

  /// The incident ends only when a human says it is resolved. Units that
  /// arrived are completed; units still travelling are recorded as stood
  /// down, never as completed, so the response record stays truthful.
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
    final stoodDown = <String>[];
    final now = CampusClock.now();
    for (final d in await dispatchesOf(session, incident.id!)) {
      final closed = await tryTransition(session, d.id!, (current) {
        if (!current.status.active) return null;
        final arrived =
            current.status == DispatchStatus.onScene ||
            current.status == DispatchStatus.care;
        if (!arrived) stoodDown.add(current.responderName);
        return current
          ..status = arrived
              ? DispatchStatus.completed
              : DispatchStatus.recalled
          ..completedAt = arrived ? now : null
          ..note = arrived
              ? current.note
              : 'Stood down at closure before arrival';
      });
      if (closed != null) await _release(session, closed);
    }
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
      'Resolved: $outcome. MTTC ${formatSeconds(incident.careAt!.difference(incident.onsetAt).inSeconds)}.'
      '${stoodDown.isEmpty ? '' : ' Stood down before arrival: ${stoodDown.join(', ')}.'}',
    );
    final saved = await save(session, incident);
    await _closeVictims(session, saved);
    return saved;
  }

  /// Returns a unit to service, but only if it is still held by [d]. A unit
  /// that has since been re-assigned elsewhere is left alone.
  static Future<void> _release(Session session, Dispatch d) async {
    final found = await Responder.db.findFirstRow(
      session,
      where: (t) => t.code.equals(d.responderCode),
    );
    if (found == null) return;
    final released = await RowLock.on(
      session,
      LockedTable.responder,
      found.id!,
      (transaction) async {
        final r = await Responder.db.findById(
          session,
          found.id!,
          transaction: transaction,
        );
        if (r == null || r.activeDispatchId != d.id) return false;
        r
          ..status = r.status == ResponderStatus.assigned
              ? ResponderStatus.available
              : r.status
          ..activeDispatchId = null
          ..zoneCode = r.baseZoneCode;
        await Responder.db.updateRow(session, r, transaction: transaction);
        return true;
      },
    );
    if (released) await OpsBus.publish(session, 'twin');
  }

  /// Marks a unit unreachable after a missed acknowledgement, if it is still
  /// held by [d].
  static Future<void> markUnreachable(Session session, Dispatch d) async {
    final found = await Responder.db.findFirstRow(
      session,
      where: (t) => t.code.equals(d.responderCode),
    );
    if (found == null) return;
    await RowLock.on(session, LockedTable.responder, found.id!, (
      transaction,
    ) async {
      final r = await Responder.db.findById(
        session,
        found.id!,
        transaction: transaction,
      );
      if (r == null || r.activeDispatchId != d.id) return;
      r
        ..status = ResponderStatus.offline
        ..activeDispatchId = null
        ..statusNote = 'Missed acknowledgement: radio check required';
      await Responder.db.updateRow(session, r, transaction: transaction);
    });
    await OpsBus.publish(session, 'twin');
  }

  // ------------------------------------------------------------ recompute

  /// Derives the incident state from its dispatches and sets the next
  /// milestone Proof-of-Response expects.
  static Future<Incident> recompute(Session session, Incident incident) async {
    if (!incident.state.open) return save(session, incident);
    final dispatches = await dispatchesOf(session, incident.id!);
    final policy = await policyOf(session, incident);
    final committed = dispatches.where(
      (d) =>
          d.status != DispatchStatus.declined &&
          d.status != DispatchStatus.timedOut &&
          d.status != DispatchStatus.recalled,
    );
    if (committed.isNotEmpty) {
      var stage = IncidentState.dispatched;
      for (final d in committed) {
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
    } else if (dispatches.isNotEmpty) {
      // Every unit declined, timed out or was recalled. Nobody is coming, so
      // the case returns to the operator with a live deadline the watchdog
      // keeps escalating, instead of sitting "dispatched" with no unit.
      incident
        ..state = IncidentState.verified
        ..nextAction =
            'No unit is assigned: dispatch a unit or stand down with a reason'
        ..nextDeadline = CampusClock.now().add(
          Duration(seconds: policy?.verifySlaSeconds ?? 60),
        )
        ..nextDeadlineLabel = 'Re-dispatch';
      return save(session, incident);
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
      final travelling = active
          .where(
            (d) =>
                d.status == DispatchStatus.offered ||
                d.status == DispatchStatus.acknowledged ||
                d.status == DispatchStatus.enRoute,
          )
          .map((d) => d.responderName)
          .toList();
      incident.nextDeadline = deadline;
      incident.nextDeadlineLabel = label;
      incident.nextAction = switch (incident.state) {
        IncidentState.dispatched =>
          'Await acknowledgement from '
              '${active.map((d) => d.responderName).join(', ')}',
        IncidentState.acknowledged ||
        IncidentState.enRoute => 'Track units en route; keep the route clear',
        IncidentState.onScene =>
          travelling.isEmpty
              ? 'Confirm care has started'
              : 'Confirm care has started; still awaiting '
                    '${travelling.join(', ')}',
        IncidentState.care =>
          active.isEmpty
              ? 'All units done: resolve with outcome'
              : travelling.isEmpty
              ? 'Coordinate handover; resolve when care is complete'
              : 'Care started; ${travelling.join(', ')} still on the way',
        _ => incident.nextAction,
      };
    }
    return save(session, incident);
  }
}
