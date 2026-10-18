import 'package:serverpod/serverpod.dart' hide Responder;

import '../core/access.dart';
import '../core/audit.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';
import '../twin/twin_snapshot.dart';

/// Responder View API: minimal instructions, map route, and the buttons that
/// produce Proof-of-Response (acknowledge, en route, arrived, care, complete).
class ResponderEndpoint extends Endpoint {
  Future<(Actor, Responder)> _me(Session session) async {
    final actor = await Access.require(session, {UserRole.responder});
    final code = actor.user.responderCode;
    final responder = code == null
        ? null
        : await Responder.db.findFirstRow(
            session,
            where: (t) => t.code.equals(code),
          );
    if (responder == null) throw notFound('Responder unit for ${actor.name}');
    return (actor, responder);
  }

  Future<ResponderHome> home(Session session) async {
    final (_, responder) = await _me(session);
    final twin = await TwinSnapshot.load(session);
    final mine = await Dispatch.db.find(
      session,
      where: (t) => t.responderCode.equals(responder.code),
      orderBy: (t) => t.offeredAt.desc(),
      limit: 10,
    );
    final current = mine.where((d) => d.status.active).firstOrNull;
    ResponderTask? task;
    if (current != null) {
      final incident = await Orchestrator.load(session, current.incidentId);
      final policy = await Orchestrator.policyOf(session, incident);
      final others = (await Orchestrator.dispatchesOf(session, incident.id!))
          .where((d) => d.id != current.id && d.status.active)
          .map((d) => '${d.responderName} (${d.status.label})')
          .toList();
      task = ResponderTask(
        dispatch: current,
        incidentCode: incident.code,
        severity: incident.severity,
        nature:
            '${incident.consequence} (${incident.eventType.label.toLowerCase()})',
        zoneName: twin.zoneName(incident.zoneCode),
        locationDetail: incident.locationDetail,
        routeNames: current.route.map(twin.zoneName).toList(),
        instructions: policy?.instructions ?? const [],
        hospitalNotified: incident.hospitalNotified,
        otherResponders: others,
      );
    }
    return ResponderHome(
      responder: responder,
      zoneName: twin.zoneName(responder.zoneCode),
      task: task,
      recent: mine.where((d) => !d.status.active).toList(),
    );
  }

  Future<Dispatch> _owned(Session session, Responder me, int dispatchId) async {
    final d = await Dispatch.db.findById(session, dispatchId);
    if (d == null || d.responderCode != me.code) {
      throw CareGridException(
        message: 'This task is not assigned to your unit.',
        code: 'forbidden',
      );
    }
    return d;
  }

  Future<ResponderHome> acknowledge(Session session, int dispatchId) async {
    final (actor, me) = await _me(session);
    await _owned(session, me, dispatchId);
    await Orchestrator.acknowledge(session, dispatchId, actor.label);
    return home(session);
  }

  Future<ResponderHome> enRoute(Session session, int dispatchId) async {
    final (actor, me) = await _me(session);
    await _owned(session, me, dispatchId);
    await Orchestrator.startEnRoute(session, dispatchId, actor.label);
    return home(session);
  }

  Future<ResponderHome> arrive(Session session, int dispatchId) async {
    final (actor, me) = await _me(session);
    await _owned(session, me, dispatchId);
    await Orchestrator.arrive(
      session,
      dispatchId,
      actor.label,
      source: 'responder',
    );
    return home(session);
  }

  Future<ResponderHome> startCare(Session session, int dispatchId) async {
    final (actor, me) = await _me(session);
    await _owned(session, me, dispatchId);
    await Orchestrator.startCare(session, dispatchId, actor.label);
    return home(session);
  }

  Future<ResponderHome> complete(
    Session session,
    int dispatchId,
    String? note,
  ) async {
    final (actor, me) = await _me(session);
    await _owned(session, me, dispatchId);
    await Orchestrator.complete(session, dispatchId, actor.label, note);
    return home(session);
  }

  Future<ResponderHome> decline(
    Session session,
    int dispatchId,
    String reason,
  ) async {
    final (actor, me) = await _me(session);
    await _owned(session, me, dispatchId);
    if (reason.trim().isEmpty) throw badRequest('A reason is required.');
    await Orchestrator.decline(session, dispatchId, actor.label, reason.trim());
    await Audit.log(
      session,
      actor,
      'decline-dispatch',
      target: '$dispatchId',
      detail: reason,
    );
    return home(session);
  }

  /// Go on or off duty. Units on a task cannot go off duty.
  Future<ResponderHome> setAvailability(Session session, bool available) async {
    final (actor, me) = await _me(session);
    if (me.status == ResponderStatus.assigned) {
      throw invalidState('Finish or hand over your current task first.');
    }
    me
      ..status = available ? ResponderStatus.available : ResponderStatus.offline
      ..statusNote = available ? null : 'Off duty';
    await Responder.db.updateRow(session, me);
    await Audit.log(
      session,
      actor,
      available ? 'on-duty' : 'off-duty',
      target: me.code,
    );
    await OpsBus.publish(session, 'twin');
    return home(session);
  }
}
