import 'package:serverpod/serverpod.dart' hide Responder;

import '../agent/policy_engine.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';
import 'seed_data.dart';

/// Loads [SeedData] into the database. Runs on first boot (empty twin) and
/// when an administrator resets the demo.
class Seeder {
  Seeder._();

  static Future<void> seedIfEmpty(Session session) async {
    if (await Zone.db.count(session) > 0) return;
    await _seedUsers(session);
    await _seedTwin(session);
    await _seedHistory(session);
    session.log('CareGrid seed data loaded (${SeedData.campusName}).');
  }

  /// Wipes operational data and the twin, then reseeds. Users, tokens and
  /// the audit log are kept so nobody is signed out and the reset is audited.
  static Future<void> reset(Session session) async {
    await TimelineEntry.db.deleteWhere(session, where: (t) => t.id > 0);
    await Dispatch.db.deleteWhere(session, where: (t) => t.id > 0);
    await SensorEvent.db.deleteWhere(session, where: (t) => t.id > 0);
    await Incident.db.deleteWhere(session, where: (t) => t.id > 0);
    await ScenarioRun.db.deleteWhere(session, where: (t) => t.id > 0);
    await StressTestRun.db.deleteWhere(session, where: (t) => t.id > 0);
    await StressScenario.db.deleteWhere(session, where: (t) => t.id > 0);
    await ZonePolicy.db.deleteWhere(session, where: (t) => t.id > 0);
    await Responder.db.deleteWhere(session, where: (t) => t.id > 0);
    await Camera.db.deleteWhere(session, where: (t) => t.id > 0);
    await RoadSegment.db.deleteWhere(session, where: (t) => t.id > 0);
    await Zone.db.deleteWhere(session, where: (t) => t.id > 0);
    await _seedTwin(session);
    await _seedHistory(session);
  }

  static Future<void> _seedUsers(Session session) async {
    if (await AppUser.db.count(session) > 0) return;
    await AppUser.db.insert(session, [
      for (final (handle, name, role, title, pin, responder, _)
          in SeedData.users)
        AppUser(
          handle: handle,
          displayName: name,
          role: role,
          title: title,
          pin: pin,
          responderCode: responder,
        ),
    ]);
  }

  static Future<void> _seedTwin(Session session) async {
    final zones = SeedData.zones();
    await Zone.db.insert(session, zones);
    await RoadSegment.db.insert(session, SeedData.roads(zones));
    await Camera.db.insert(session, SeedData.cameras());
    await Responder.db.insert(session, SeedData.responders());
    await ZonePolicy.db.insert(session, SeedData.policies());
    await StressScenario.db.insert(session, SeedData.stressScenarios());
  }

  static Future<void> _seedHistory(Session session) async {
    final zones = {for (final z in await Zone.db.find(session)) z.code: z};
    final policies = await ZonePolicy.db.find(session);
    final responders = {
      for (final r in await Responder.db.find(session)) r.code: r,
    };
    final now = CampusClock.now();
    final localToday = now.add(CampusClock.utcOffset);

    final items = [...SeedData.history]
      ..sort(
        (a, b) => b.daysAgo != a.daysAgo
            ? b.daysAgo.compareTo(a.daysAgo)
            : a.hour.compareTo(b.hour),
      );

    var n = 0;
    for (final h in items) {
      n++;
      final day = localToday.subtract(Duration(days: h.daysAgo));
      final onset = DateTime.utc(
        day.year,
        day.month,
        day.day,
        h.hour,
        h.minute,
      ).subtract(CampusClock.utcOffset);
      final zone = zones[h.zoneCode]!;
      final family = PolicyEngine.familyOf(h.eventType);
      final policy = PolicyEngine.select(policies, zone.type, family, h.hour);

      DateTime? at(int count) {
        if (h.stages.length < count) return null;
        var t = onset;
        for (var i = 0; i < count; i++) {
          t = t.add(Duration(seconds: h.stages[i]));
        }
        return t;
      }

      final detected = at(1)!;
      final verified = at(2);
      final dispatched = at(3);
      final acknowledged = at(4);
      final onScene = at(5);
      final care = at(6);
      final last =
          care ?? onScene ?? acknowledged ?? dispatched ?? verified ?? detected;
      final dismissed = h.dismissal != null;

      final incident = await Incident.db.insertRow(
        session,
        Incident(
          code: 'INC-${1000 + n}',
          title: '${h.eventType.label} at ${zone.name}',
          eventType: h.eventType,
          family: family,
          severity: h.severity,
          state: dismissed ? IncidentState.dismissed : IncidentState.resolved,
          zoneCode: zone.code,
          source: h.source,
          confidence: 0.9,
          corroborated: true,
          observability: h.observability,
          consequence: PolicyEngine.consequenceFor(h.eventType),
          policyCode: policy?.code,
          reasoning: ['Historical incident loaded from seed data.'],
          negativeEvidence: [],
          escalationLevel: h.escalations,
          hospitalNotified: policy?.notifyHospital ?? false,
          onsetAt: onset,
          detectedAt: detected,
          verifiedAt: verified,
          dispatchedAt: dispatched,
          acknowledgedAt: acknowledged,
          enRouteAt: acknowledged,
          onSceneAt: onScene,
          careAt: care,
          resolvedAt: dismissed ? null : last.add(const Duration(minutes: 25)),
          dismissedAt: dismissed ? last.add(const Duration(seconds: 30)) : null,
          closureNote: h.dismissal ?? h.outcome,
          updatedAt: last,
        ),
      );

      final lines = <(DateTime, TimelineKind, String, String)>[
        (
          detected,
          TimelineKind.signal,
          h.source.label,
          '${h.eventType.label} detected at ${zone.name}.',
        ),
        if (verified != null)
          (
            verified,
            TimelineKind.agent,
            'Incident Agent',
            'Verified as ${h.severity.label} under ${policy?.code}.',
          ),
        if (dispatched != null)
          (
            dispatched,
            TimelineKind.dispatch,
            'Command operator',
            'Dispatched ${h.responders.join(', ')}.',
          ),
        if (onScene != null)
          (
            onScene,
            TimelineKind.proof,
            'Proof-of-Response',
            'Arrival verified by geofence.',
          ),
        if (care != null)
          (
            care,
            TimelineKind.care,
            h.responders.isEmpty ? 'Responder' : h.responders.first,
            'Care / action started.',
          ),
        (
          dismissed ? incident.dismissedAt! : incident.resolvedAt!,
          TimelineKind.closure,
          'Command operator',
          dismissed ? 'Dismissed: ${h.dismissal}' : 'Resolved: ${h.outcome}',
        ),
      ];
      await TimelineEntry.db.insert(session, [
        for (final (at, kind, actor, message) in lines)
          TimelineEntry(
            incidentId: incident.id!,
            at: at,
            kind: kind,
            actor: actor,
            message: message,
          ),
      ]);

      if (dispatched != null) {
        await Dispatch.db.insert(session, [
          for (final (i, code) in h.responders.indexed)
            Dispatch(
              incidentId: incident.id!,
              responderCode: code,
              responderName: responders[code]?.name ?? code,
              responderType:
                  responders[code]?.type ?? ResponderType.securityPatrol,
              role: i == 0 ? 'primary' : 'support',
              status: DispatchStatus.completed,
              route: [],
              distanceMeters: 0,
              etaSeconds: h.stages.length > 4 ? h.stages[4] : 0,
              offeredAt: dispatched,
              ackDeadline: dispatched.add(const Duration(seconds: 30)),
              acknowledgedAt: acknowledged,
              enRouteAt: acknowledged,
              onSceneAt: onScene,
              careAt: care,
              completedAt: incident.resolvedAt,
              progress: onScene == null ? 0 : 1,
              arrivalSource: onScene == null ? null : 'geofence',
            ),
        ]);
      }
    }
  }
}
