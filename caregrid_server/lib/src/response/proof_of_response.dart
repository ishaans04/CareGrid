import 'package:serverpod/serverpod.dart' hide Responder;

import '../core/clock.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import '../twin/campus_graph.dart';
import '../twin/twin_snapshot.dart';
import 'orchestrator.dart';

/// Proof-of-Response: "alert sent" is not success. Every dispatch is tracked
/// against an expected trajectory (acknowledge, move, arrive, start care). A
/// missed milestone escalates and re-plans; nothing is ever closed silently.
///
/// Explicit scenario runs simulate route progress and arrival. For autopilot
/// scenario runs, the watchdog also plays the operator,
/// responders and hospital so a demo can run unattended.
class ProofOfResponse {
  ProofOfResponse._();

  static const simulatedOperator = 'Simulated operator (autopilot)';

  static Future<void> tick(Session session) async {
    final open = await Incident.db.find(
      session,
      where: (t) =>
          t.resolvedAt.equals(null) &
          t.dismissedAt.equals(null) &
          t.parentIncidentId.equals(null),
    );
    if (open.isEmpty) return;
    final runs = <int, ScenarioRun?>{};
    for (final incident in open) {
      try {
        final runId = incident.scenarioRunId;
        final run = runId == null
            ? null
            : runs[runId] ??= await ScenarioRun.db.findById(session, runId);
        await _checkIncident(session, incident, run);
      } catch (e, st) {
        session.log(
          'Proof-of-Response failed on ${incident.code}: $e',
          level: LogLevel.error,
          exception: e,
          stackTrace: st,
        );
      }
    }
  }

  static Future<void> _checkIncident(
    Session session,
    Incident incident,
    ScenarioRun? run,
  ) async {
    final now = CampusClock.now();
    final autopilot = run?.autopilot ?? false;
    final faults = run?.faults ?? const <String>[];
    final policy = await Orchestrator.policyOf(session, incident);
    final verifySla = policy?.verifySlaSeconds ?? 60;
    final deadlinePassed =
        incident.nextDeadline != null && now.isAfter(incident.nextDeadline!);

    switch (incident.state) {
      case IncidentState.detected when deadlinePassed:
        incident
          ..state = IncidentState.review
          ..needsHumanReview = true
          ..nextAction = 'Corroboration not received: review evidence'
          ..nextDeadline = now.add(Duration(seconds: verifySla))
          ..nextDeadlineLabel = 'Human review';
        await Orchestrator.log(
          session,
          incident,
          TimelineKind.agent,
          Orchestrator.agentName,
          'No corroboration within the window. The agent will not guess: '
          'routed to human review.',
        );
        await Orchestrator.save(session, incident);
        return;
      case IncidentState.review || IncidentState.verified:
        final waited = now
            .difference(incident.verifiedAt ?? incident.detectedAt)
            .inSeconds;
        if (autopilot && waited >= 4) {
          await Orchestrator.confirmDispatch(
            session,
            incident,
            null,
            simulatedOperator,
          );
          return;
        }
        if (deadlinePassed) {
          incident
            ..nextDeadline = now.add(Duration(seconds: verifySla))
            ..nextDeadlineLabel = incident.state == IncidentState.review
                ? 'Human review (escalated)'
                : 'Operator confirmation (escalated)';
          await Orchestrator.escalate(
            session,
            incident,
            '${incident.state == IncidentState.review ? 'Human review' : 'Operator confirmation'} '
            'overdue (${formatSeconds(verifySla)} SLA). Supervisor notified.',
          );
        }
        return;
      default:
        break;
    }

    if (autopilot &&
        incident.hospitalNotified &&
        !incident.hospitalReady &&
        now.difference(incident.verifiedAt ?? incident.detectedAt).inSeconds >=
            6) {
      incident.hospitalReady = true;
      await Orchestrator.log(
        session,
        incident,
        TimelineKind.care,
        'Hospital (simulated)',
        'ER bay prepared; team ready to receive.',
      );
      incident = await Orchestrator.save(session, incident);
    }

    final dispatches = await Orchestrator.dispatchesOf(session, incident.id!);
    for (final d in dispatches.where((d) => d.status.active)) {
      await _checkDispatch(
        session,
        incident,
        d,
        policy,
        run != null,
        autopilot,
        faults,
      );
    }
  }

  static Future<void> _checkDispatch(
    Session session,
    Incident incident,
    Dispatch d,
    ZonePolicy? policy,
    bool simulation,
    bool autopilot,
    List<String> faults,
  ) async {
    final now = CampusClock.now();
    final crew = '${d.responderName} (simulated)';
    switch (d.status) {
      case DispatchStatus.offered:
        final noAck = faults.contains('noAck:${d.responderCode}');
        if (autopilot && !noAck && now.difference(d.offeredAt).inSeconds >= 5) {
          await Orchestrator.acknowledge(session, d.id!, crew);
        } else if (now.isAfter(d.ackDeadline)) {
          await _missedAck(session, incident, d);
        }
      case DispatchStatus.acknowledged:
        final since = now.difference(d.acknowledgedAt!).inSeconds;
        if (autopilot && since >= 3) {
          await Orchestrator.startEnRoute(session, d.id!, crew);
        } else if (since > 45 && !d.stalled) {
          d.stalled = true;
          await Dispatch.db.updateRow(session, d);
          await Orchestrator.escalate(
            session,
            incident,
            '${d.responderName} acknowledged but has not started moving.',
          );
        }
      case DispatchStatus.enRoute:
        if (simulation) {
          await _advance(session, incident, d);
        } else if (d.arrivalDeadline != null &&
            now.isAfter(d.arrivalDeadline!) &&
            !d.stalled) {
          // An ETA is a prediction, never proof that a person has arrived.
          d.stalled = true;
          await Dispatch.db.updateRow(session, d);
          await Orchestrator.escalate(
            session,
            incident,
            '${d.responderName} has not confirmed arrival before the deadline. '
            'Contact the unit to verify its location.',
          );
        }
      case DispatchStatus.onScene:
        final since = now.difference(d.onSceneAt!).inSeconds;
        final careSla = policy?.careSlaSeconds ?? 120;
        if (autopilot && since >= 6) {
          await Orchestrator.startCare(session, d.id!, crew);
        } else if (since > careSla && !d.stalled) {
          d.stalled = true;
          await Dispatch.db.updateRow(session, d);
          await Orchestrator.escalate(
            session,
            incident,
            '${d.responderName} is on scene but care has not started '
            '(${formatSeconds(careSla)} SLA).',
          );
        }
      default:
        break;
    }
  }

  static Future<void> _missedAck(
    Session session,
    Incident incident,
    Dispatch d,
  ) async {
    d
      ..status = DispatchStatus.timedOut
      ..note = 'No acknowledgement within the SLA';
    await Dispatch.db.updateRow(session, d);
    final responder = await Responder.db.findFirstRow(
      session,
      where: (t) => t.code.equals(d.responderCode),
    );
    if (responder != null) {
      responder
        ..status = ResponderStatus.offline
        ..activeDispatchId = null
        ..statusNote = 'Missed acknowledgement: radio check required';
      await Responder.db.updateRow(session, responder);
    }
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.proof,
      Orchestrator.watchdogName,
      'Missed acknowledgement: ${d.responderName} did not respond within '
      '${formatSeconds(d.ackDeadline.difference(d.offeredAt).inSeconds)}. '
      'Unit marked unreachable.',
    );
    await Orchestrator.redispatch(
      session,
      incident,
      d,
      'missed acknowledgement',
    );
  }

  /// Simulated telemetry: moves the unit along its route, reroutes around
  /// newly blocked roads, verifies arrival by geofence, flags stalls.
  static Future<void> _advance(
    Session session,
    Incident incident,
    Dispatch d,
  ) async {
    final now = CampusClock.now();
    final twin = await TwinSnapshot.load(session);
    final responder = twin.responders[d.responderCode];
    if (responder == null) return;
    final travel = (d.etaSeconds - responder.mobilizationSeconds).clamp(
      5,
      3600,
    );
    final elapsed = now.difference(d.enRouteAt!).inMilliseconds / 1000;
    final progress = (elapsed / travel).clamp(0.0, 1.0);

    // Reroute if a road ahead was blocked after departure.
    final index = (progress * (d.route.length - 1)).floor();
    final blocked = _blockedAhead(twin, d.route, index);
    if (blocked != null) {
      final from = d.route[index];
      final reroute = CampusGraph(twin).route(from, incident.zoneCode);
      if (reroute.found) {
        final newTravel =
            CampusGraph.etaSeconds(responder, reroute) -
            responder.mobilizationSeconds;
        d
          ..route = reroute.path
          ..distanceMeters = reroute.meters
          ..etaSeconds = responder.mobilizationSeconds + newTravel
          ..enRouteAt = now
          ..progress = 0
          ..arrivalDeadline = now.add(
            Duration(seconds: (newTravel * 1.5).round() + 30),
          );
        await Dispatch.db.updateRow(session, d);
        await Orchestrator.log(
          session,
          incident,
          TimelineKind.proof,
          Orchestrator.watchdogName,
          'Route obstruction on ${blocked.name}: ${d.responderName} rerouted via '
          '${reroute.path.map(twin.zoneName).join(' > ')} '
          '(new travel time ${formatSeconds(newTravel)}).',
        );
        await Orchestrator.recompute(session, incident);
      } else if (!d.stalled) {
        d.stalled = true;
        await Dispatch.db.updateRow(session, d);
        await Orchestrator.escalate(
          session,
          incident,
          '${d.responderName} is blocked on ${blocked.name} and no '
          'alternate route exists.',
        );
      }
      return;
    }

    if (progress >= 1) {
      await Orchestrator.arrive(
        session,
        d.id!,
        Orchestrator.watchdogName,
        source: 'simulation',
      );
      return;
    }
    if (d.arrivalDeadline != null && now.isAfter(d.arrivalDeadline!)) {
      if (!d.stalled) {
        d.stalled = true;
        await Dispatch.db.updateRow(session, d);
        await Orchestrator.escalate(
          session,
          incident,
          '${d.responderName} is behind its expected trajectory (stall).',
        );
      }
      return;
    }
    if (progress - d.progress >= 0.04) {
      d.progress = progress;
      await Dispatch.db.updateRow(session, d);
      await OpsBus.publish(session, 'dispatch', incidentId: incident.id);
    }
  }

  static RoadSegment? _blockedAhead(
    TwinSnapshot twin,
    List<String> route,
    int fromIndex,
  ) {
    for (var i = fromIndex; i < route.length - 1; i++) {
      final a = route[i];
      final b = route[i + 1];
      for (final road in twin.roads) {
        final matches =
            (road.fromZone == a && road.toZone == b) ||
            (road.fromZone == b && road.toZone == a);
        if (matches && road.status == RoadStatus.blocked) return road;
      }
    }
    return null;
  }

  /// Zone a responder is passing through, for the live map.
  static String positionOf(Responder r, Dispatch? d) {
    if (d == null || d.status != DispatchStatus.enRoute || d.route.isEmpty) {
      return r.zoneCode;
    }
    final index = (d.progress * (d.route.length - 1)).floor();
    return d.route[index.clamp(0, d.route.length - 1)];
  }
}
