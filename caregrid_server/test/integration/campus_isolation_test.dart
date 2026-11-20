import 'package:caregrid_server/src/core/access.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/seed/seeder.dart';
import 'package:serverpod/serverpod.dart' hide Responder;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Tenant isolation: every endpoint resolves records inside the caller's own
/// campus. Another campus's incident, dispatch, unit, gate, road, camera,
/// policy, rehearsal or scenario run is "not found", even with a guessed id.
void main() {
  withServerpod('Two campuses on one deployment', (sessionBuilder, endpoints) {
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();
      await Seeder.seedIfEmpty(session);
    });

    Future<TestSessionBuilder> signedIn(String handle) async {
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.handle.equals(handle),
      );
      return sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          '${user!.id}',
          {Access.scopeFor(user.role)},
        ),
      );
    }

    Matcher denied(String code) => throwsA(
      isA<CareGridException>().having((e) => e.code, 'code', code),
    );

    /// A verified, dispatched Meridian incident (the 02:17 hero case).
    Future<(IncidentSummary, Dispatch)> meridianCase() async {
      final cmd = await signedIn('cmd.night');
      for (final (cam, confidence) in [
        ('CAM-HB-B07', 0.86),
        ('CAM-HB-B08', 0.91),
      ]) {
        await endpoints.signal.ingest(
          cmd,
          SignalInput(
            source: SignalSource.camera,
            eventType: EventType.personDown,
            zoneCode: 'HB',
            cameraCode: cam,
            trackId: 'T-41',
            confidence: confidence,
            contextHour: 2,
          ),
        );
      }
      final hero = (await endpoints.incident.board(cmd)).active.single;
      await endpoints.incident.confirmDispatch(cmd, hero.id, null);
      final dispatch = (await Dispatch.db.findFirstRow(
        session,
        where: (t) => t.incidentId.equals(hero.id),
      ))!;
      return (hero, dispatch);
    }

    test(
      'each campus is seeded with its own twin, policies and accounts',
      () async {
        final campuses = await Campus.db.find(session, orderBy: (t) => t.id);
        expect(campuses.map((c) => c.code), containsAll(['meridian', 'niet']));
        final niet = campuses.firstWhere((c) => c.code == 'niet');
        expect(niet.fictional, isFalse);
        expect(niet.attribution, contains('OpenStreetMap'));
        final nietCmd = await signedIn('niet.command');
        final twin = await endpoints.campus.twin(nietCmd);
        expect(twin.campus.code, 'niet');
        expect(twin.zones.map((z) => z.code), contains('MHOS'));
        expect(twin.zones.map((z) => z.code), isNot(contains('HB')));
        expect(
          twin.zones.firstWhere((z) => z.code == 'ABLK').footprint,
          isNotNull,
        );
        final accounts = await endpoints.account.demoAccounts(sessionBuilder);
        expect(
          accounts.firstWhere((a) => a.handle == 'niet.command').campusName,
          'NIET Greater Noida',
        );
        expect(
          accounts.firstWhere((a) => a.handle == 'network.ops').campusName,
          'All campuses',
        );
      },
    );

    test('another campus\'s incident is not found, even with its id', () async {
      final (hero, dispatch) = await meridianCase();
      final niet = await signedIn('niet.command');
      expect(
        (await endpoints.incident.board(niet)).active.map((s) => s.id),
        isNot(contains(hero.id)),
      );
      await expectLater(
        endpoints.incident.detail(niet, hero.id),
        denied('notFound'),
      );
      await expectLater(
        endpoints.incident.confirmDispatch(niet, hero.id, null),
        denied('notFound'),
      );
      await expectLater(
        endpoints.incident.claim(niet, hero.id),
        denied('notFound'),
      );
      await expectLater(
        endpoints.incident.dismiss(niet, hero.id, 'not ours'),
        denied('notFound'),
      );
      await expectLater(
        endpoints.incident.releaseUnit(niet, hero.id, dispatch.id!, 'x'),
        denied('notFound'),
      );
      await expectLater(
        endpoints.briefing.generate(niet, hero.id),
        denied('notFound'),
      );
      await expectLater(
        endpoints.evidence.list(niet, hero.id, null),
        denied('notFound'),
      );
      final doctor = await signedIn('niet.doctor');
      expect(
        (await endpoints.care.cases(doctor)).map((c) => c.incidentId),
        isNot(contains(hero.id)),
      );
      final unchanged = (await Incident.db.findById(session, hero.id))!;
      expect(unchanged.ownerName, isNull);
      expect(unchanged.state.open, isTrue);
    });

    test('a responder cannot act on another campus\'s assignment', () async {
      final (_, dispatch) = await meridianCase();
      final crew = await signedIn('niet.amb');
      await expectLater(
        endpoints.responder.acknowledge(crew, dispatch.id!),
        denied('forbidden'),
      );
      expect(
        (await Dispatch.db.findById(session, dispatch.id!))!.status,
        DispatchStatus.offered,
      );
      final home = await endpoints.responder.home(crew);
      expect(home.responder.code, 'AMB-1');
      expect(home.task, isNull);
    });

    test('twin codes resolve only inside the caller\'s campus', () async {
      final admin = await signedIn('niet.admin');
      // Meridian codes that do not exist on NIET.
      await expectLater(
        endpoints.admin.setGate(admin, 'G4', true, true),
        denied('notFound'),
      );
      await expectLater(
        endpoints.admin.setCameraHealth(
          admin,
          'CAM-HB-B07',
          AssetHealth.offline,
        ),
        denied('notFound'),
      );
      await expectLater(
        endpoints.admin.setResponderStatus(
          admin,
          'AMB-A2',
          ResponderStatus.offline,
          null,
        ),
        denied('notFound'),
      );
      await expectLater(
        endpoints.readiness.applyFix(admin, 'restage:AMB-A1:HOS'),
        denied('notFound'),
      );
      await expectLater(
        endpoints.readiness.run(admin, 'ST-HOSTEL-0217'),
        denied('notFound'),
      );
      // Meridian state is untouched.
      final gate = (await Zone.db.findFirstRow(
        session,
        where: (t) => t.code.equals('G4'),
      ))!;
      expect(gate.emergencyOverride, isFalse);
      final meridianAmbulance = (await Responder.db.findFirstRow(
        session,
        where: (t) => t.code.equals('AMB-A2'),
      ))!;
      expect(meridianAmbulance.status, ResponderStatus.available);
    });

    test(
      'signals and SOS are only accepted for the caller\'s own zones',
      () async {
        final niet = await signedIn('niet.command');
        await expectLater(
          endpoints.signal.ingest(
            niet,
            SignalInput(
              source: SignalSource.operatorReport,
              eventType: EventType.visibleDistress,
              zoneCode: 'HB',
              confidence: 0.9,
            ),
          ),
          denied('badRequest'),
        );
        final student = await signedIn('niet.student');
        await expectLater(
          endpoints.sos.raise(student, 'HB', null, null, true),
          denied('badRequest'),
        );
        final mine = await endpoints.sos.raise(
          student,
          'MHOS',
          null,
          null,
          true,
        );
        expect(mine.code, startsWith('NIET-'));
        final aanya = await signedIn('student.aanya');
        expect(
          (await endpoints.sos.mine(aanya)).map((s) => s.incidentId),
          isNot(contains(mine.incidentId)),
        );
      },
    );

    test('audit, analytics, policies and rehearsals are per campus', () async {
      await meridianCase();
      final nietAdmin = await signedIn('niet.admin');
      final log = await endpoints.admin.auditLog(nietAdmin, 200);
      expect(log.map((r) => r.userName), isNot(contains('Riya Menon')));
      final policies = await endpoints.admin.policies(nietAdmin);
      final nietCampus = (await Campus.db.findFirstRow(
        session,
        where: (t) => t.code.equals('niet'),
      ))!;
      expect(policies.every((p) => p.campusId == nietCampus.id), isTrue);
      final rehearsals = await endpoints.readiness.scenarios(nietAdmin);
      expect(rehearsals.map((s) => s.code), contains('ST-NIET-GATE'));
      expect(rehearsals.map((s) => s.code), isNot(contains('ST-HOSTEL-0217')));
      final metrics = await endpoints.analytics.metrics(nietAdmin);
      expect(metrics.byZone.keys, isNot(contains('Birch Hostel')));
      expect(metrics.mttcSamples, greaterThan(0));
      expect(metrics.mttcMedianSeconds, isNotNull);
      expect(
        metrics.mttcP90Seconds,
        greaterThanOrEqualTo(
          metrics.mttcMedianSeconds!,
        ),
      );
      expect(metrics.rciVerified, lessThanOrEqualTo(metrics.rciClosed));
    });

    test('the network role sees de-identified pulses for every campus and '
        'nothing else', () async {
      await meridianCase();
      final network = await signedIn('network.ops');
      final overview = await endpoints.network.overview(network);
      expect(
        overview.campuses.map((c) => c.code),
        containsAll(['meridian', 'niet']),
      );
      final meridian = overview.campuses.firstWhere(
        (c) => c.code == 'meridian',
      );
      expect(meridian.openIncidents, greaterThanOrEqualTo(1));
      expect(meridian.urgentOpen, greaterThanOrEqualTo(1));
      expect(meridian.unitsTotal, 11);
      await expectLater(
        endpoints.incident.board(network),
        denied('forbidden'),
      );
      await expectLater(endpoints.campus.twin(network), denied('forbidden'));
      final cmd = await signedIn('cmd.night');
      await expectLater(endpoints.network.overview(cmd), denied('forbidden'));
    });

    test('a retried producer event is recognised and never creates a second '
        'incident', () async {
      final niet = await signedIn('niet.command');
      SignalInput signal() => SignalInput(
        source: SignalSource.camera,
        eventType: EventType.personDown,
        zoneCode: 'MHOS',
        cameraCode: 'CAM-MH-1',
        trackId: 'T-77',
        confidence: 0.88,
        contextHour: 2,
        eventId: 'edge-gw-7:frame-4410',
      );
      final first = await endpoints.signal.ingest(niet, signal());
      final retry = await endpoints.signal.ingest(niet, signal());
      expect(retry.id, first.id);
      final incident = (await Incident.db.findById(
        session,
        first.incidentId!,
      ))!;
      expect(
        incident.corroborated,
        isFalse,
        reason: 'a retry must not corroborate itself',
      );
      expect(
        await SensorEvent.db.count(
          session,
          where: (t) => t.sourceEventId.equals('edge-gw-7:frame-4410'),
        ),
        1,
      );
    });

    test('a late event keeps its observed time as onset; impossible times are '
        'rejected', () async {
      final niet = await signedIn('niet.command');
      final observed = DateTime.now().toUtc().subtract(
        const Duration(minutes: 6),
      );
      final event = await endpoints.signal.ingest(
        niet,
        SignalInput(
          source: SignalSource.iotSensor,
          eventType: EventType.smoke,
          zoneCode: 'PHRM',
          confidence: 0.95,
          observedAt: observed,
        ),
      );
      expect(
        event.observedAt.difference(observed).inSeconds.abs(),
        lessThan(1),
      );
      expect(event.outcome, contains('after it was observed'));
      final incident = (await Incident.db.findById(
        session,
        event.incidentId!,
      ))!;
      expect(
        incident.onsetAt.difference(observed).inSeconds.abs(),
        lessThan(1),
      );
      await expectLater(
        endpoints.signal.ingest(
          niet,
          SignalInput(
            source: SignalSource.iotSensor,
            eventType: EventType.smoke,
            zoneCode: 'PHRM',
            confidence: 0.95,
            observedAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
        ),
        denied('badRequest'),
      );
    });
  });
}
