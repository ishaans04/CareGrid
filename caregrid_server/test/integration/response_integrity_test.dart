import 'package:caregrid_server/src/core/access.dart';
import 'package:caregrid_server/src/core/locks.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/response/orchestrator.dart';
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

/// Regression coverage for response-record integrity: evidence must reach the
/// right incident, people must not be merged or hidden, units must not be
/// double-assigned, and stale or racing writers must not overwrite newer
/// state.
void main() {
  withServerpod('Response integrity on the seeded campus', (
    sessionBuilder,
    endpoints,
  ) {
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

    Future<Incident> heroVerified(TestSessionBuilder cmd) async {
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
      final event = await endpoints.signal.ingest(
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
      final incident = await Orchestrator.load(session, event.incidentId!);
      expect(incident.state, IncidentState.verified);
      return incident;
    }

    Future<Dispatch> dispatchOf(Incident incident, String responder) async =>
        (await Dispatch.db.findFirstRow(
          session,
          where: (t) =>
              t.incidentId.equals(incident.id) &
              t.responderCode.equals(responder),
          orderBy: (t) => t.id.desc(),
        ))!;

    group('evidence reaches the right incident', () {
      test(
        'two members in one building at different places stay separate, and '
        'one withdrawal never stands the other down',
        () async {
          final aanya = await signedIn('student.aanya');
          final rohan = await signedIn('staff.rohan');
          final first = await endpoints.sos.raise(
            aanya,
            'HB',
            'Block C, room 314',
            'Friend fainted',
            false,
          );
          final second = await endpoints.sos.raise(
            rohan,
            'HB',
            'Ground floor lobby',
            'Chest pain',
            true,
          );
          expect(second.incidentId, isNot(first.incidentId));
          final separate = await Orchestrator.load(session, second.incidentId);
          expect(
            separate.reasoning.join(' '),
            contains('Kept separate'),
            reason: 'command must see why two requests were not merged',
          );

          await endpoints.sos.cancel(aanya, first.incidentId, 'She is fine');
          expect(
            (await Orchestrator.load(session, first.incidentId)).state,
            IncidentState.dismissed,
          );
          final untouched = await Orchestrator.load(session, second.incidentId);
          expect(
            untouched.state.open,
            isTrue,
            reason: 'withdrawing one request must not close another person\'s',
          );
          expect(untouched.negativeEvidence, isEmpty);
        },
      );

      test('the same member pressing twice, or a second member naming the '
          'same place, joins the existing request', () async {
        final aanya = await signedIn('student.aanya');
        final rohan = await signedIn('staff.rohan');
        final first = await endpoints.sos.raise(
          aanya,
          'LIB',
          'Reading room 2',
          null,
          true,
        );
        final again = await endpoints.sos.raise(
          aanya,
          'LIB',
          'Near the stairs',
          'Still need help',
          true,
        );
        final sameplace = await endpoints.sos.raise(
          rohan,
          'LIB',
          'reading room 2!',
          'Someone collapsed',
          false,
        );
        expect(again.incidentId, first.incidentId);
        expect(sameplace.incidentId, first.incidentId);
      });

      test(
        'a withdrawal cannot stand down a request that cameras also support',
        () async {
          final aanya = await signedIn('student.aanya');
          final cmd = await signedIn('cmd.night');
          final sos = await endpoints.sos.raise(aanya, 'HB', null, null, false);
          await endpoints.signal.ingest(
            cmd,
            camera(
              EventType.personDown,
              'HB',
              'CAM-HB-B07',
              0.88,
              track: 'T-41',
              hour: 2,
            ),
          );
          await endpoints.sos.cancel(aanya, sos.incidentId, 'False alarm');
          final incident = await Orchestrator.load(session, sos.incidentId);
          expect(incident.state.open, isTrue);
          expect(incident.needsHumanReview, isTrue);
          expect(incident.negativeEvidence, hasLength(1));
        },
      );

      test(
        'a recovery seen on a different anonymous track changes nothing',
        () async {
          final cmd = await signedIn('cmd.night');
          final hero = await heroVerified(cmd);
          final event = await endpoints.signal.ingest(
            cmd,
            camera(
              EventType.personRecovered,
              'HB',
              'CAM-HB-B07',
              0.9,
              track: 'T-99',
            ),
          );
          expect(event.incidentId, isNull);
          expect(event.outcome, contains('T-99'));
          final after = await Orchestrator.load(session, hero.id!);
          expect(after.state, IncidentState.verified);
          expect(after.negativeEvidence, isEmpty);
        },
      );

      test(
        'untracked evidence about a tracked person goes to a human, not '
        'dismissal',
        () async {
          final cmd = await signedIn('cmd.night');
          final hero = await heroVerified(cmd);
          await endpoints.signal.ingest(
            cmd,
            SignalInput(
              source: SignalSource.operatorReport,
              eventType: EventType.personRecovered,
              zoneCode: 'HB',
              confidence: 0.8,
              detail: 'Caller says someone got up',
            ),
          );
          final after = await Orchestrator.load(session, hero.id!);
          expect(after.state.open, isTrue);
          expect(after.needsHumanReview, isTrue);
          expect(after.negativeEvidence, hasLength(1));
        },
      );

      test('the matching track still dismisses before dispatch', () async {
        final cmd = await signedIn('cmd.night');
        final hero = await heroVerified(cmd);
        await endpoints.signal.ingest(
          cmd,
          camera(
            EventType.personRecovered,
            'HB',
            'CAM-HB-B08',
            0.93,
            track: 'T-41',
          ),
        );
        expect(
          (await Orchestrator.load(session, hero.id!)).state,
          IncidentState.dismissed,
        );
      });
    });

    group('units and records are never double-written', () {
      test(
        'a unit reserved by one incident is skipped for another',
        () async {
          final cmd = await signedIn('cmd.night');
          final hero = await heroVerified(cmd);
          final aanya = await signedIn('student.aanya');
          final library = await endpoints.sos.raise(
            aanya,
            'LIB',
            'Reading room',
            null,
            true,
          );
          await endpoints.incident.confirmDispatch(cmd, hero.id!, ['AMB-A2']);
          final before = await Orchestrator.load(session, library.incidentId);
          await endpoints.incident.confirmDispatch(
            cmd,
            library.incidentId,
            ['AMB-A2'],
          );
          final live = (await Dispatch.db.find(
            session,
            where: (t) => t.responderCode.equals('AMB-A2'),
          )).where((d) => d.status.active).toList();
          expect(live, hasLength(1), reason: 'never two live assignments');
          expect(live.single.incidentId, hero.id);
          final after = await Orchestrator.load(session, library.incidentId);
          expect(after.escalationLevel, before.escalationLevel + 1);
        },
      );

      test('a stale incident copy cannot overwrite newer state', () async {
        final cmd = await signedIn('cmd.night');
        final hero = await heroVerified(cmd);
        final stale = await Orchestrator.load(session, hero.id!);
        await endpoints.incident.claim(cmd, hero.id!);
        stale.escalationLevel += 1;
        await expectLater(
          Orchestrator.save(session, stale),
          throwsA(predicate(isConflict)),
        );
        final current = await Orchestrator.load(session, hero.id!);
        expect(current.ownerName, isNotNull);
        expect(current.escalationLevel, hero.escalationLevel);
        expect(current.revision, greaterThan(stale.revision));
      });

      test(
        'an acknowledgement after the watchdog timed the offer out is refused',
        () async {
          final cmd = await signedIn('cmd.night');
          final hero = await heroVerified(cmd);
          await endpoints.incident.confirmDispatch(cmd, hero.id!, ['AMB-A2']);
          final offer = await dispatchOf(hero, 'AMB-A2');
          await Dispatch.db.updateRow(
            session,
            offer.copyWith(
              ackDeadline: DateTime.now().toUtc().subtract(
                const Duration(seconds: 1),
              ),
            ),
          );
          await ProofOfResponse.tick(session);
          expect(
            (await Dispatch.db.findById(session, offer.id!))!.status,
            DispatchStatus.timedOut,
          );
          final crew = await signedIn('amb.a2');
          await expectLater(
            endpoints.responder.acknowledge(crew, offer.id!),
            throwsA(isA<CareGridException>()),
          );
        },
      );

      test(
        'an acknowledgement recorded first is never undone by the watchdog',
        () async {
          final cmd = await signedIn('cmd.night');
          final hero = await heroVerified(cmd);
          await endpoints.incident.confirmDispatch(cmd, hero.id!, ['AMB-A2']);
          final offer = await dispatchOf(hero, 'AMB-A2');
          final crew = await signedIn('amb.a2');
          await endpoints.responder.acknowledge(crew, offer.id!);
          final acknowledged = (await Dispatch.db.findById(
            session,
            offer.id!,
          ))!;
          await Dispatch.db.updateRow(
            session,
            acknowledged.copyWith(
              ackDeadline: DateTime.now().toUtc().subtract(
                const Duration(seconds: 1),
              ),
            ),
          );
          await ProofOfResponse.tick(session);
          expect(
            (await Dispatch.db.findById(session, offer.id!))!.status,
            DispatchStatus.acknowledged,
          );
        },
      );

      test('incident codes derive from the record id, so they cannot '
          'collide', () async {
        final cmd = await signedIn('cmd.night');
        final events = [
          for (final zone in ['LIB', 'SPT', 'COM', 'ACD'])
            await endpoints.signal.ingest(
              cmd,
              SignalInput(
                source: SignalSource.operatorReport,
                eventType: EventType.visibleDistress,
                zoneCode: zone,
                confidence: 0.9,
              ),
            ),
        ];
        final incidents = [
          for (final e in events)
            await Orchestrator.load(session, e.incidentId!),
        ];
        expect(incidents.map((i) => i.code).toSet(), hasLength(4));
        for (final i in incidents) {
          expect(i.code, 'INC-${1000 + i.id!}');
        }
      });
    });

    group('per-unit truth', () {
      test(
        'command can stand down one unit; the rest of the response continues',
        () async {
          final cmd = await signedIn('cmd.night');
          final hero = await heroVerified(cmd);
          await endpoints.incident.confirmDispatch(cmd, hero.id!, null);
          final desk = await signedIn('desk.birch');
          final deskTask = await dispatchOf(hero, 'DESK-HB');
          await endpoints.responder.arrive(desk, deskTask.id!);
          await endpoints.responder.startCare(desk, deskTask.id!);

          var board = await endpoints.incident.board(cmd);
          var row = board.active.singleWhere((s) => s.id == hero.id);
          expect(row.unitsAssigned, 2);
          expect(row.unitsArrived, 1);

          final ambulance = await dispatchOf(hero, 'AMB-A2');
          await endpoints.incident.releaseUnit(
            cmd,
            hero.id!,
            ambulance.id!,
            'Desk confirms no transport needed',
          );
          final released = (await Responder.db.findFirstRow(
            session,
            where: (t) => t.code.equals('AMB-A2'),
          ))!;
          expect(released.status, ResponderStatus.available);
          expect(released.activeDispatchId, isNull);

          board = await endpoints.incident.board(cmd);
          row = board.active.singleWhere((s) => s.id == hero.id);
          expect(row.state, IncidentState.care);
          expect(row.unitsAssigned, 1);
          expect(row.unitsArrived, 1);
        },
      );

      test('closing with a unit still travelling records it as stood down, '
          'never as completed', () async {
        final cmd = await signedIn('cmd.night');
        final hero = await heroVerified(cmd);
        await endpoints.incident.confirmDispatch(cmd, hero.id!, null);
        final desk = await signedIn('desk.birch');
        final deskTask = await dispatchOf(hero, 'DESK-HB');
        await endpoints.responder.arrive(desk, deskTask.id!);
        await endpoints.responder.startCare(desk, deskTask.id!);
        await endpoints.incident.resolve(cmd, hero.id!, 'Treated on site');

        final ambulance = await dispatchOf(hero, 'AMB-A2');
        expect(ambulance.status, DispatchStatus.recalled);
        expect(ambulance.completedAt, isNull);
        expect(
          (await dispatchOf(hero, 'DESK-HB')).status,
          DispatchStatus.completed,
        );
        final all = await Dispatch.db.find(
          session,
          where: (t) => t.incidentId.equals(hero.id),
        );
        expect(
          all.where(
            (d) => d.status == DispatchStatus.completed && d.onSceneAt == null,
          ),
          isEmpty,
          reason: 'a completed assignment always has a recorded arrival',
        );
      });

      test('when every unit declines and none remain, the case returns to '
          'the operator with a live deadline', () async {
        final cmd = await signedIn('cmd.night');
        final hero = await heroVerified(cmd);
        // No other desk, and no patrol bike for the SOP's fallback either.
        for (final other in [
          'DESK-HA',
          'DESK-HC',
          'DESK-HD',
          'PAT-1',
          'PAT-2',
        ]) {
          await endpoints.admin.setResponderStatus(
            cmd,
            other,
            ResponderStatus.offline,
            'Test: unavailable',
          );
        }
        await endpoints.incident.confirmDispatch(cmd, hero.id!, ['DESK-HB']);
        final desk = await signedIn('desk.birch');
        final task = await dispatchOf(hero, 'DESK-HB');
        await endpoints.responder.decline(desk, task.id!, 'Desk unattended');

        final after = await Orchestrator.load(session, hero.id!);
        expect(after.state, IncidentState.verified);
        expect(after.needsHumanReview, isTrue);
        expect(after.nextDeadlineLabel, 'Re-dispatch');
        expect(after.nextDeadline, isNotNull);
      });
    });
  });
}
