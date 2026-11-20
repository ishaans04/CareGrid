import 'package:serverpod/serverpod.dart' hide Responder;

import '../agent/incident_agent.dart';
import '../agent/policy_engine.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';
import 'campus_seed.dart';

/// Loads every [CampusSeed] into the database. Runs on first boot and when an
/// administrator resets their campus's demo. Campuses are seeded and reset
/// independently; one campus's reset never touches another.
class Seeder {
  Seeder._();

  /// Creates each campus that does not exist yet (with its twin and
  /// history) and any missing demo accounts. A database migrated from the
  /// single-campus prototype keeps its data as the Meridian campus.
  static Future<void> seedIfEmpty(Session session) async {
    for (final seed in CampusSeeds.all) {
      final campus = await _campusRow(session, seed);
      final hasTwin = await Zone.db.count(
        session,
        where: (t) => t.campusId.equals(campus.id),
      );
      if (hasTwin == 0) {
        await _seedTwin(session, seed, campus);
        await _seedHistory(session, seed, campus);
        session.log('CareGrid seed data loaded (${campus.name}).');
      }
      await _seedUsers(session, seed.users, campus.id);
    }
    await _seedUsers(session, CampusSeeds.networkUsers, null);
  }

  /// Wipes one campus's operational data and twin, then reseeds it. Users,
  /// tokens and the audit log are kept so nobody is signed out and the reset
  /// is audited.
  static Future<void> reset(Session session, int campusId) async {
    final campus = await Campus.db.findById(session, campusId);
    if (campus == null) throw StateError('Unknown campus $campusId.');
    final seed = CampusSeeds.byCode(campus.code);
    if (seed == null) throw StateError('No seed for campus ${campus.code}.');
    final incidentIds = (await Incident.db.find(
      session,
      where: (t) => t.campusId.equals(campusId),
    )).map((i) => i.id!).toSet();
    if (incidentIds.isNotEmpty) {
      await TimelineEntry.db.deleteWhere(
        session,
        where: (t) => t.incidentId.inSet(incidentIds),
      );
    }
    await Dispatch.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await SensorEvent.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await Incident.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await ScenarioRun.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await StressTestRun.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await StressScenario.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await ZonePolicy.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await Responder.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await Camera.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await RoadSegment.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await Zone.db.deleteWhere(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    await _seedTwin(session, seed, campus);
    await _seedHistory(session, seed, campus);
  }

  static Future<Campus> _campusRow(Session session, CampusSeed seed) async {
    final code = seed.campus.code;
    final existing = await Campus.db.findFirstRow(
      session,
      where: (t) => t.code.equals(code),
    );
    if (existing != null) return existing;
    return Campus.db.insertRow(session, seed.campus);
  }

  static Future<void> _seedUsers(
    Session session,
    List<SeedUser> users,
    int? campusId,
  ) async {
    final existing = {
      for (final u in await AppUser.db.find(
        session,
        where: (t) => t.handle.inSet(users.map((u) => u.handle).toSet()),
      ))
        u.handle,
    };
    final missing = users.where((u) => !existing.contains(u.handle)).toList();
    if (missing.isEmpty) return;
    await AppUser.db.insert(session, [
      for (final u in missing)
        AppUser(
          campusId: campusId,
          handle: u.handle,
          displayName: u.name,
          role: u.role,
          title: u.title,
          pin: u.pin,
          responderCode: u.responderCode,
        ),
    ]);
  }

  static Future<void> _seedTwin(
    Session session,
    CampusSeed seed,
    Campus campus,
  ) async {
    final id = campus.id!;
    final zones = [for (final z in seed.zones()) z.copyWith(campusId: id)];
    await Zone.db.insert(session, zones);
    await RoadSegment.db.insert(session, [
      for (final r in seed.roads(zones)) r.copyWith(campusId: id),
    ]);
    await Camera.db.insert(session, [
      for (final c in seed.cameras()) c.copyWith(campusId: id),
    ]);
    await Responder.db.insert(session, [
      for (final r in seed.responders()) r.copyWith(campusId: id),
    ]);
    await ZonePolicy.db.insert(session, [
      for (final p in seed.policies()) p.copyWith(campusId: id),
    ]);
    await StressScenario.db.insert(session, [
      for (final s in seed.stressScenarios()) s.copyWith(campusId: id),
    ]);
  }

  static Future<void> _seedHistory(
    Session session,
    CampusSeed seed,
    Campus campus,
  ) async {
    final id = campus.id!;
    final zones = {
      for (final z in await Zone.db.find(
        session,
        where: (t) => t.campusId.equals(id),
      ))
        z.code: z,
    };
    final policies = await ZonePolicy.db.find(
      session,
      where: (t) => t.campusId.equals(id),
    );
    final responders = {
      for (final r in await Responder.db.find(
        session,
        where: (t) => t.campusId.equals(id),
      ))
        r.code: r,
    };
    final offset = Duration(minutes: campus.utcOffsetMinutes);
    final now = CampusClock.now();
    final localToday = now.add(offset);

    final items = [...seed.history]
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
      ).subtract(offset);
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

      var incident = await Incident.db.insertRow(
        session,
        Incident(
          campusId: id,
          code: 'SEED-${campus.code}-$n',
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
      incident.code = IncidentAgent.incidentCode(campus, incident.id!);
      incident = await Incident.db.updateRow(session, incident);

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
              campusId: id,
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
