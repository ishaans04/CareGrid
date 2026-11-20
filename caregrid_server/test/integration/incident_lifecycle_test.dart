import 'package:caregrid_server/src/core/access.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/response/proof_of_response.dart';
import 'package:caregrid_server/src/seed/seeder.dart';
import 'package:serverpod/serverpod.dart' hide Responder;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

SignalInput camera(
  EventType type,
  String zone,
  String cameraCode,
  double confidence, {
  String? track,
  int? hour,
}) => SignalInput(
  source: SignalSource.camera,
  eventType: type,
  zoneCode: zone,
  cameraCode: cameraCode,
  trackId: track,
  confidence: confidence,
  contextHour: hour,
);

void main() {
  withServerpod('Given the seeded campus', (sessionBuilder, endpoints) {
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

    /// Runs the 02:17 hostel signals and returns the verified incident.
    Future<IncidentSummary> heroVerified(TestSessionBuilder cmd) async {
      await endpoints.signal.ingest(
        cmd,
        camera(
          EventType.personDown,
          'HB',
          'CAM-HB-B07',
          0.86,
          track: 'T-41',
          hour: 2,
        ),
      );
      await endpoints.signal.ingest(
        cmd,
        camera(
          EventType.personDown,
          'HB',
          'CAM-HB-B08',
          0.91,
          track: 'T-41',
          hour: 2,
        ),
      );
      return (await endpoints.incident.board(cmd)).active.single;
    }

    test('sign-in issues a token and rejects a wrong PIN', () async {
      final result = await endpoints.account.signIn(
        sessionBuilder,
        'cmd.night',
        '1111',
      );
      expect(result.token, isNotEmpty);
      expect(result.user.role, UserRole.command);
      await expectLater(
        endpoints.account.signIn(sessionBuilder, 'cmd.night', '0000'),
        throwsA(isA<CareGridException>()),
      );
    });

    test('hero: corroborated person-down runs the full closed loop', () async {
      final cmd = await signedIn('cmd.night');
      await endpoints.signal.ingest(
        cmd,
        camera(
          EventType.personDown,
          'HB',
          'CAM-HB-B07',
          0.86,
          track: 'T-41',
          hour: 2,
        ),
      );
      var hero = (await endpoints.incident.board(cmd)).active.single;
      expect(
        hero.state,
        IncidentState.detected,
        reason: 'one camera is not enough under the night hostel SOP',
      );

      hero = await heroVerified(cmd);
      expect(hero.state, IncidentState.verified);
      expect(hero.severity, Severity.p1);

      final detail = await endpoints.incident.detail(cmd, hero.id);
      expect(detail.incident.corroborated, isTrue);
      expect(detail.incident.hospitalNotified, isTrue);
      expect(detail.policy?.code, 'SOP-HST-MED-NIGHT');
      expect(detail.plan!.options.map((o) => o.responderCode), [
        'DESK-HB',
        'AMB-A2',
      ]);

      await endpoints.incident.confirmDispatch(cmd, hero.id, null);
      final crew = await signedIn('amb.a2');
      final task = (await endpoints.responder.home(crew)).task!;
      expect(task.zoneName, 'Birch Hostel');
      expect(task.instructions, isNotEmpty);

      final id = task.dispatch.id!;
      await endpoints.responder.acknowledge(crew, id);
      await endpoints.responder.enRoute(crew, id);
      await endpoints.responder.arrive(crew, id);
      await endpoints.responder.startCare(crew, id);

      final resolved = await endpoints.incident.resolve(
        cmd,
        hero.id,
        'Resident treated and admitted for observation',
      );
      expect(resolved.state, IncidentState.resolved);

      final incident = (await Incident.db.findById(session, hero.id))!;
      expect(incident.acknowledgedAt, isNotNull);
      expect(incident.onSceneAt, isNotNull);
      expect(incident.careAt, isNotNull);
      final kinds = (await TimelineEntry.db.find(
        session,
        where: (t) => t.incidentId.equals(hero.id),
      )).map((e) => e.kind);
      expect(
        kinds,
        containsAll([
          TimelineKind.signal,
          TimelineKind.agent,
          TimelineKind.dispatch,
          TimelineKind.proof,
          TimelineKind.care,
          TimelineKind.closure,
        ]),
      );
      final a2 = await Responder.db.findFirstRow(
        session,
        where: (t) => t.code.equals('AMB-A2'),
      );
      expect(a2!.status, ResponderStatus.available);
    });

    test('resolve is refused until arrival is verified', () async {
      final cmd = await signedIn('cmd.night');
      final hero = await heroVerified(cmd);
      await endpoints.incident.confirmDispatch(cmd, hero.id, null);
      await expectLater(
        endpoints.incident.resolve(cmd, hero.id, 'Assumed fine'),
        throwsA(isA<CareGridException>()),
      );
    });

    test('closure cannot manufacture an unrecorded care milestone', () async {
      final cmd = await signedIn('cmd.night');
      final hero = await heroVerified(cmd);
      await endpoints.incident.confirmDispatch(cmd, hero.id, null);
      final crew = await signedIn('amb.a2');
      final id = (await endpoints.responder.home(crew)).task!.dispatch.id!;
      await endpoints.responder.arrive(crew, id);
      await expectLater(
        endpoints.incident.resolve(cmd, hero.id, 'Assumed care was given'),
        throwsA(isA<CareGridException>()),
      );
      final incident = (await Incident.db.findById(session, hero.id))!;
      expect(incident.careAt, isNull);
      expect(incident.resolvedAt, isNull);
      final detail = await endpoints.incident.detail(cmd, hero.id);
      expect(detail.allowedActions, isNot(contains('resolve')));
    });

    test(
      'negative evidence dismisses a fall before anyone is dispatched',
      () async {
        final cmd = await signedIn('cmd.night');
        await endpoints.signal.ingest(
          cmd,
          camera(
            EventType.fall,
            'SPT',
            'CAM-SPT-01',
            0.82,
            track: 'T-7',
            hour: 17,
          ),
        );
        await endpoints.signal.ingest(
          cmd,
          camera(
            EventType.personRecovered,
            'SPT',
            'CAM-SPT-01',
            0.93,
            track: 'T-7',
            hour: 17,
          ),
        );
        final incident = await Incident.db.findFirstRow(
          session,
          where: (t) => t.zoneCode.equals('SPT') & t.trackId.equals('T-7'),
        );
        expect(incident!.state, IncidentState.dismissed);
        expect(incident.closureNote, contains('Negative evidence'));
        expect(
          await Dispatch.db.count(
            session,
            where: (t) => t.incidentId.equals(incident.id),
          ),
          0,
        );
      },
    );

    test(
      'missed acknowledgement escalates and re-dispatches another ambulance',
      () async {
        final cmd = await signedIn('cmd.night');
        final hero = await heroVerified(cmd);
        await endpoints.incident.confirmDispatch(cmd, hero.id, null);
        final a2 = (await Dispatch.db.findFirstRow(
          session,
          where: (t) =>
              t.incidentId.equals(hero.id) & t.responderCode.equals('AMB-A2'),
        ))!;
        await Dispatch.db.updateRow(
          session,
          a2.copyWith(
            ackDeadline: DateTime.now().toUtc().subtract(
              const Duration(seconds: 1),
            ),
          ),
        );

        await ProofOfResponse.tick(session);

        final dispatches = await Dispatch.db.find(
          session,
          where: (t) => t.incidentId.equals(hero.id),
        );
        expect(
          dispatches.firstWhere((d) => d.responderCode == 'AMB-A2').status,
          DispatchStatus.timedOut,
        );
        expect(
          dispatches.firstWhere((d) => d.responderCode == 'AMB-A1').status,
          DispatchStatus.offered,
        );
        final incident = (await Incident.db.findById(session, hero.id))!;
        expect(incident.escalationLevel, greaterThanOrEqualTo(1));
        expect(incident.state.open, isTrue, reason: 'never closed silently');
      },
    );

    test('elapsed time cannot verify arrival outside a simulation', () async {
      final cmd = await signedIn('cmd.night');
      final hero = await heroVerified(cmd);
      await endpoints.incident.confirmDispatch(cmd, hero.id, null);
      final crew = await signedIn('amb.a2');
      final id = (await endpoints.responder.home(crew)).task!.dispatch.id!;
      await endpoints.responder.enRoute(crew, id);
      final d = (await Dispatch.db.findById(session, id))!;
      await Dispatch.db.updateRow(
        session,
        d.copyWith(
          enRouteAt: DateTime.now().toUtc().subtract(
            const Duration(minutes: 5),
          ),
          arrivalDeadline: DateTime.now().toUtc().subtract(
            const Duration(minutes: 1),
          ),
        ),
      );

      await ProofOfResponse.tick(session);

      final pending = (await Dispatch.db.findById(session, id))!;
      expect(pending.status, DispatchStatus.enRoute);
      expect(pending.arrivalSource, isNull);
      expect(pending.onSceneAt, isNull);
      expect(pending.progress, 0);
      expect(pending.stalled, isTrue);
      final incident = (await Incident.db.findById(session, hero.id))!;
      expect(incident.escalationLevel, greaterThanOrEqualTo(1));
      // A second tick does not repeat the overdue-arrival escalation.
      await ProofOfResponse.tick(session);
      final again = (await Incident.db.findById(session, hero.id))!;
      expect(again.escalationLevel, incident.escalationLevel);
      await endpoints.responder.arrive(crew, id);
      final confirmed = (await Dispatch.db.findById(session, id))!;
      expect(confirmed.arrivalSource, 'responder');
      expect(confirmed.onSceneAt, isNotNull);
    });

    test('explicit scenario runs retain labelled simulated arrival', () async {
      final cmd = await signedIn('cmd.night');
      final hero = await heroVerified(cmd);
      final heroCampus = (await Incident.db.findById(
        session,
        hero.id,
      ))!.campusId;
      final run = await ScenarioRun.db.insertRow(
        session,
        ScenarioRun(
          campusId: heroCampus,
          scenarioCode: 'TEST-EXPLICIT-SIMULATION',
          title: 'Arrival fixture',
          startedAt: DateTime.now().toUtc(),
          startedBy: 'Integration test',
          autopilot: false,
          status: 'running',
          stepsTotal: 0,
          stepsEmitted: 0,
          faults: [],
        ),
      );
      final incident = (await Incident.db.findById(session, hero.id))!;
      await Incident.db.updateRow(
        session,
        incident.copyWith(scenarioRunId: run.id),
      );
      await endpoints.incident.confirmDispatch(cmd, hero.id, null);
      final crew = await signedIn('amb.a2');
      final id = (await endpoints.responder.home(crew)).task!.dispatch.id!;
      await endpoints.responder.enRoute(crew, id);
      final dispatch = (await Dispatch.db.findById(session, id))!;
      await Dispatch.db.updateRow(
        session,
        dispatch.copyWith(
          enRouteAt: DateTime.now().toUtc().subtract(
            const Duration(minutes: 5),
          ),
        ),
      );
      await ProofOfResponse.tick(session);
      final arrived = (await Dispatch.db.findById(session, id))!;
      expect(arrived.status, DispatchStatus.onScene);
      expect(arrived.arrivalSource, 'simulation');
    });

    test(
      'a crowd surge with two people down is one incident with two victims',
      () async {
        final cmd = await signedIn('cmd.night');
        await endpoints.signal.ingest(
          cmd,
          camera(EventType.crowdSurge, 'COM', 'CAM-COM-01', 0.83, hour: 21),
        );
        await endpoints.signal.ingest(
          cmd,
          camera(EventType.crowdSurge, 'COM', 'CAM-COM-02', 0.86, hour: 21),
        );
        await endpoints.signal.ingest(
          cmd,
          camera(
            EventType.personDown,
            'COM',
            'CAM-COM-01',
            0.82,
            track: 'T-11',
            hour: 21,
          ),
        );
        await endpoints.signal.ingest(
          cmd,
          camera(
            EventType.personDown,
            'COM',
            'CAM-COM-02',
            0.8,
            track: 'T-12',
            hour: 21,
          ),
        );
        final active = (await endpoints.incident.board(cmd)).active;
        expect(active, hasLength(1));
        expect(active.single.victimCount, 2);
        expect(active.single.severity, Severity.p0);
      },
    );

    test(
      'an SOS gives the member closed-loop status and reaches command',
      () async {
        final member = await signedIn('student.aanya');
        final status = await endpoints.sos.raise(
          member,
          'LIB',
          'Reading hall, first floor',
          'Friend fainted',
          false,
        );
        expect(status.state, IncidentState.verified);
        expect(status.message, contains('reviewing'));

        final cmd = await signedIn('cmd.night');
        final board = await endpoints.incident.board(cmd);
        expect(board.active.single.zoneCode, 'LIB');

        final mine = await endpoints.sos.mine(member);
        expect(mine, hasLength(1));
      },
    );

    test('roles only reach their own surfaces', () async {
      final crew = await signedIn('amb.a2');
      await expectLater(
        endpoints.incident.board(crew),
        throwsA(isA<CareGridException>()),
      );
      final member = await signedIn('student.aanya');
      await expectLater(
        endpoints.admin.auditLog(member, 10),
        throwsA(isA<CareGridException>()),
      );
      final medical = await signedIn('er.doctor');
      await expectLater(
        endpoints.incident.confirmDispatch(medical, 1, null),
        throwsA(isA<CareGridException>()),
      );
    });

    test('responders cannot see incidents they are not assigned to', () async {
      final cmd = await signedIn('cmd.night');
      final hero = await heroVerified(cmd);
      await endpoints.incident.confirmDispatch(cmd, hero.id, null);
      final otherCrew = await signedIn('amb.a1');
      await expectLater(
        endpoints.incident.detail(otherCrew, hero.id),
        throwsA(isA<CareGridException>()),
      );
      final medical = await signedIn('er.doctor');
      final redacted = await endpoints.incident.detail(medical, hero.id);
      expect(redacted.incident.primaryCameraCode, isNull);
      expect(redacted.signals, isEmpty);
      expect(redacted.redactions, isNotEmpty);
      expect(redacted.incident.reasoning, isEmpty);
      expect(redacted.incident.negativeEvidence, isEmpty);
    });

    test(
      'care access cannot be obtained by guessing an unshared incident id',
      () async {
        final cmd = await signedIn('cmd.night');
        final hero = await heroVerified(cmd);
        final incident = (await Incident.db.findById(session, hero.id))!;
        await Incident.db.updateRow(
          session,
          incident.copyWith(hospitalNotified: false),
        );
        final medical = await signedIn('er.doctor');
        for (final action in <Future<dynamic> Function()>[
          () => endpoints.incident.detail(medical, hero.id),
          () => endpoints.incident.addNote(medical, hero.id, 'Unshared note'),
          () => endpoints.incident.escalate(
            medical,
            hero.id,
            'Unshared escalation',
          ),
          () =>
              endpoints.incident.resolve(medical, hero.id, 'Unshared closure'),
          () => endpoints.care.markReady(medical, hero.id),
        ]) {
          await expectLater(action(), throwsA(isA<CareGridException>()));
        }
        expect((await endpoints.incident.board(medical)).active, isEmpty);
        // Other legitimate seeded cases can fall in the 12-hour care window
        // depending on the runner's local time zone. Only this case is hidden.
        final visibleCases = await endpoints.care.cases(medical);
        expect(
          visibleCases.map((item) => item.incidentId),
          isNot(contains(hero.id)),
        );
      },
    );

    test(
      'admin summaries and details do not leak exact evidence context',
      () async {
        final cmd = await signedIn('cmd.night');
        final hero = await heroVerified(cmd);
        final incident = (await Incident.db.findById(session, hero.id))!;
        await Incident.db.updateRow(
          session,
          incident.copyWith(
            locationDetail: 'Sensitive room',
            reasoning: ['Camera CAM-HB-B07 tracked T-41 at Sensitive room'],
            negativeEvidence: ['Track T-41 context'],
          ),
        );
        final admin = await signedIn('ops.admin');
        final board = await endpoints.incident.board(admin);
        expect(board.active.single.locationDetail, isNull);
        final twin = await endpoints.campus.twin(admin);
        expect(twin.activeIncidents.single.locationDetail, isNull);
        final detail = await endpoints.incident.detail(admin, hero.id);
        expect(detail.incident.locationDetail, isNull);
        expect(detail.incident.reasoning, isEmpty);
        expect(detail.incident.negativeEvidence, isEmpty);
      },
    );

    test(
      'applying the Readiness Lab fixes raises the readiness score',
      () async {
        final admin = await signedIn('ops.admin');
        final before = await endpoints.readiness.runAll(admin);
        expect(before.scorePercent, 50);

        await endpoints.readiness.applyFix(admin, 'gate-override:G4');
        await endpoints.readiness.applyFix(admin, 'restage:FAC-1:J5');

        final after = await endpoints.readiness.runAll(admin);
        expect(after.scorePercent, 100);
      },
    );

    test('analytics measure MTTC and RCI from seeded history', () async {
      final admin = await signedIn('ops.admin');
      final metrics = await endpoints.analytics.metrics(admin);
      expect(metrics.mttcSeconds, isNotNull);
      expect(metrics.incidentsTotal, 14);
      expect(
        metrics.rciPercent,
        lessThan(100),
        reason: 'one seeded response never verified arrival',
      );
      expect(metrics.dismissReasons, isNotEmpty);
    });
  });
}
