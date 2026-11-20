import 'package:serverpod/serverpod.dart' hide Responder;

import '../core/access.dart';
import '../core/audit.dart';
import '../core/runtime_policy.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import '../seed/seeder.dart';

/// Admin Control Plane: policies (SOPs), digital-twin asset state, users,
/// audit log, and demo reset. Everything is scoped to the caller's campus.
class AdminEndpoint extends Endpoint {
  Future<List<ZonePolicy>> policies(Session session) async {
    final actor = await Access.require(session, {
      UserRole.admin,
      UserRole.command,
    });
    return ZonePolicy.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId),
      orderBy: (t) => t.id,
    );
  }

  /// Edit thresholds, SLAs, responders and instructions of an existing SOP.
  Future<ZonePolicy> updatePolicy(Session session, ZonePolicy policy) async {
    final actor = await Access.require(session, {UserRole.admin});
    final existing = policy.id == null
        ? null
        : await ZonePolicy.db.findById(session, policy.id!);
    if (existing == null || existing.campusId != actor.campusId) {
      throw notFound('Policy ${policy.code}');
    }
    if (policy.minConfidence < 0 || policy.minConfidence > 1) {
      throw badRequest('Confidence must be between 0 and 1.');
    }
    if (policy.responderTypes.isEmpty) {
      throw badRequest('A policy needs at least one responder type.');
    }
    for (final sla in [
      policy.verifySlaSeconds,
      policy.ackSlaSeconds,
      policy.arrivalSlaSeconds,
      policy.careSlaSeconds,
    ]) {
      if (sla < 5 || sla > 24 * 3600) {
        throw badRequest('SLAs must be between 5 seconds and 24 hours.');
      }
    }
    for (final hour in [policy.startHour, policy.endHour]) {
      if (hour != null && (hour < 0 || hour > 23)) {
        throw badRequest('Hours must be 0-23.');
      }
    }
    final saved = await ZonePolicy.db.updateRow(
      session,
      policy.copyWith(code: existing.code, campusId: existing.campusId),
    );
    await Audit.log(session, actor, 'policy-update', target: saved.code);
    await OpsBus.publish(session, 'twin', campusId: actor.campusId);
    return saved;
  }

  Future<Camera> setCameraHealth(
    Session session,
    String code,
    AssetHealth health,
  ) async {
    final actor = await Access.require(session, {UserRole.admin});
    final camera = await Camera.db.findFirstRow(
      session,
      where: (t) => t.campusId.equals(actor.campusId) & t.code.equals(code),
    );
    if (camera == null) throw notFound('Camera $code');
    camera.health = health;
    final saved = await Camera.db.updateRow(session, camera);
    await Audit.log(
      session,
      actor,
      'camera-health',
      target: code,
      detail: health.name,
    );
    await OpsBus.publish(session, 'twin', campusId: actor.campusId);
    return saved;
  }

  Future<Zone> setGate(
    Session session,
    String zoneCode,
    bool isOpen,
    bool emergencyOverride,
  ) async {
    final actor = await Access.require(session, {
      UserRole.admin,
      UserRole.command,
    });
    final gate = await Zone.db.findFirstRow(
      session,
      where: (t) => t.campusId.equals(actor.campusId) & t.code.equals(zoneCode),
    );
    if (gate == null || gate.type != ZoneType.gate) {
      throw notFound('Gate $zoneCode');
    }
    gate
      ..isOpen = isOpen
      ..emergencyOverride = emergencyOverride;
    final saved = await Zone.db.updateRow(session, gate);
    await Audit.log(
      session,
      actor,
      'gate-state',
      target: zoneCode,
      detail: 'open=$isOpen override=$emergencyOverride',
    );
    await OpsBus.publish(session, 'twin', campusId: actor.campusId);
    return saved;
  }

  /// Blocking a road during a live response makes Proof-of-Response reroute
  /// the units that would have used it.
  Future<RoadSegment> setRoadStatus(
    Session session,
    String code,
    RoadStatus status,
  ) async {
    final actor = await Access.require(session, {
      UserRole.admin,
      UserRole.command,
    });
    final road = await RoadSegment.db.findFirstRow(
      session,
      where: (t) => t.campusId.equals(actor.campusId) & t.code.equals(code),
    );
    if (road == null) throw notFound('Road $code');
    road.status = status;
    final saved = await RoadSegment.db.updateRow(session, road);
    await Audit.log(
      session,
      actor,
      'road-status',
      target: code,
      detail: status.name,
    );
    await OpsBus.publish(session, 'twin', campusId: actor.campusId);
    return saved;
  }

  Future<Responder> setResponderStatus(
    Session session,
    String code,
    ResponderStatus status,
    String? note,
  ) async {
    final actor = await Access.require(session, {
      UserRole.admin,
      UserRole.command,
    });
    final r = await Responder.db.findFirstRow(
      session,
      where: (t) => t.campusId.equals(actor.campusId) & t.code.equals(code),
    );
    if (r == null) throw notFound('Responder $code');
    if (r.status == ResponderStatus.assigned &&
        status != ResponderStatus.assigned) {
      throw invalidState('${r.name} is on an active task.');
    }
    if (status == ResponderStatus.assigned) {
      throw badRequest('Units are assigned through dispatch only.');
    }
    r
      ..status = status
      ..statusNote = note
      ..zoneCode = status == ResponderStatus.available
          ? r.baseZoneCode
          : r.zoneCode;
    final saved = await Responder.db.updateRow(session, r);
    await Audit.log(
      session,
      actor,
      'responder-status',
      target: code,
      detail: '${status.name} ${note ?? ''}'.trim(),
    );
    await OpsBus.publish(session, 'twin', campusId: actor.campusId);
    return saved;
  }

  Future<List<AuditRecord>> auditLog(Session session, int limit) async {
    final actor = await Access.require(session, {UserRole.admin});
    return AuditRecord.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId),
      orderBy: (t) => t.at.desc(),
      limit: limit.clamp(1, 500),
    );
  }

  Future<List<AppUser>> users(Session session) async {
    final actor = await Access.require(session, {UserRole.admin});
    return AppUser.db.find(
      session,
      where: (t) => t.campusId.equals(actor.campusId),
      orderBy: (t) => t.id,
    );
  }

  /// Restores this campus's seeded twin and history. Users and the audit log
  /// are kept; other campuses are untouched.
  Future<void> resetDemo(Session session) async {
    RuntimePolicy.requireDemo(session);
    final actor = await Access.require(session, {UserRole.admin});
    await Seeder.reset(session, actor.campusId);
    await Audit.log(session, actor, 'demo-reset');
    await OpsBus.publish(
      session,
      'twin',
      campusId: actor.campusId,
      message: 'Demo data reset',
    );
  }
}
