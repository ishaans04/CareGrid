import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/readiness/stress_test_engine.dart';
import 'package:caregrid_server/src/response/response_planner.dart';
import 'package:caregrid_server/src/seed/niet_geometry.dart';
import 'package:caregrid_server/src/seed/niet_seed.dart';
import 'package:caregrid_server/src/twin/campus_graph.dart';
import 'package:caregrid_server/src/twin/twin_snapshot.dart';
import 'package:test/test.dart';

TwinSnapshot nietTwin() {
  const seed = NietSeed();
  final zones = seed.zones();
  return TwinSnapshot(
    campus: seed.campus.copyWith(id: 2),
    zones: {for (final z in zones) z.code: z},
    roads: seed.roads(zones),
    cameras: {for (final c in seed.cameras()) c.code: c},
    responders: {for (final r in seed.responders()) r.code: r},
    policies: seed.policies(),
  );
}

StressScenario rehearsal(String code) =>
    const NietSeed().stressScenarios().firstWhere((s) => s.code == code);

/// The NIET twin is generated from OpenStreetMap; these checks pin down that
/// the generated graph is a usable, honest emergency-routing model.
void main() {
  group('NIET twin built from OpenStreetMap', () {
    test(
      'every building, gate and junction is reachable from the main gate',
      () {
        final twin = nietTwin();
        final graph = CampusGraph(twin);
        for (final zone in twin.zones.values) {
          if (zone.code == 'GT1W') continue; // Closed candidate entrance.
          expect(
            graph.route('GT1', zone.code).found,
            isTrue,
            reason: '${zone.code} must be reachable',
          );
        }
      },
    );

    test('road codes, ends and lengths are consistent', () {
      final twin = nietTwin();
      final codes = twin.roads.map((r) => r.code).toSet();
      expect(codes, hasLength(twin.roads.length));
      for (final r in twin.roads) {
        expect(twin.zones.containsKey(r.fromZone), isTrue, reason: r.code);
        expect(twin.zones.containsKey(r.toZone), isTrue, reason: r.code);
        expect(r.lengthMeters, greaterThan(0), reason: r.code);
        expect(r.path!.length.isEven, isTrue, reason: r.code);
      }
    });

    test('buildings carry real footprints and provenance; assumptions are '
        'labelled', () {
      final twin = nietTwin();
      for (final code in ['ABLK', 'BBLK', 'MHOS', 'GHOS', 'PLAY']) {
        final zone = twin.zones[code]!;
        expect(zone.footprint, isNotNull, reason: code);
        expect(zone.footprint!.length, greaterThanOrEqualTo(8), reason: code);
        expect(zone.source, startsWith('OpenStreetMap'), reason: code);
        expect(zone.approximate, isFalse, reason: code);
      }
      expect(twin.zones['ABLK']!.levels, 5);
      expect(twin.zones['HLTH']!.approximate, isTrue);
      expect(twin.zones['GT1W']!.approximate, isTrue);
      expect(twin.zones['GT1W']!.isOpen, isFalse);
      expect(twin.campus.fictional, isFalse);
      expect(twin.campus.affiliationNote, contains('Not affiliated'));
      expect(twin.campus.attribution, contains('OpenStreetMap'));
    });

    test('partner hospitals keep their real road distances', () {
      final twin = nietTwin();
      final yatharth = twin.roads.firstWhere(
        (r) => r.fromZone == 'YATH' && r.toZone == 'GT1',
      );
      expect(yatharth.lengthMeters, inInclusiveRange(2900, 3100));
      expect(yatharth.isOutsideCampus, isTrue);
      expect(NietGeometry.osmTimestamp, isNotNull);
    });

    test('the two campuses are joined by about a kilometre of public road', () {
      final route = CampusGraph(nietTwin()).route('GT1', 'GT2');
      expect(route.found, isTrue);
      expect(route.meters, inInclusiveRange(800, 1300));
    });

    test('re-staging hubs are derived from the campus itself', () {
      final twin = nietTwin();
      expect(StressTestEngine.ambulanceHubOf(twin), 'HLTH');
      final centre = StressTestEngine.centralStandbyOf(twin);
      expect(twin.zones[centre]!.type, ZoneType.junction);
    });

    test(
      'the night-hostel plan sends the hostel desk and campus ambulance',
      () {
        final twin = nietTwin();
        final policy = twin.policies.firstWhere(
          (p) => p.code == 'SOP-HST-MED-NIGHT',
        );
        final plan = ResponsePlanner(
          twin,
        ).plan(zoneCode: 'MHOS', policy: policy, elapsedSeconds: 0);
        expect(plan.options.map((o) => o.responderCode), [
          'DESK-MH',
          'AMB-1',
        ]);
        expect(plan.options.every((o) => o.withinSla), isTrue);
      },
    );
  });

  group('NIET readiness rehearsals', () {
    test('a blocked main gate cuts off outside help; the engine surfaces the '
        'single-gate weakness and a fix that meets the target', () {
      final run = StressTestEngine(
        nietTwin(),
      ).run(rehearsal('ST-NIET-GATE'), 'test');
      expect(run.verdict, Verdict.fail);
      expect(
        run.findings.join(' '),
        contains('No available unit can cover ambulance'),
      );
      final fixes = {for (final f in run.fixes) f.code: f};
      expect(
        fixes.keys,
        contains('gate-override:GT1W'),
        reason: 'restoring a route where none existed must be reported',
      );
      expect(fixes['gate-override:GT1W']!.passesAlone, isFalse);
      expect(fixes['restage:AMB-Y:HLTH']!.passesAlone, isTrue);
      expect(run.verdictAfterFix, Verdict.pass);
    });

    test('with the campus ambulance away, a hospital ambulance misses the '
        'five-minute target and re-staging fixes it', () {
      final run = StressTestEngine(
        nietTwin(),
      ).run(rehearsal('ST-NIET-AMB-OUT'), 'test');
      expect(run.verdict, Verdict.fail);
      expect(run.predictedSeconds, greaterThan(run.slaSeconds));
      expect(
        run.fixes.map((f) => f.code),
        contains('restage:AMB-Y:HLTH'),
      );
      expect(run.verdictAfterFix, Verdict.pass);
    });

    test('a new-campus night emergency behind a blind spot misses the target; '
        'restoring the camera alone recovers it', () {
      final run = StressTestEngine(
        nietTwin(),
      ).run(rehearsal('ST-NIET-NEW-CAMPUS'), 'test');
      expect(run.verdict, Verdict.fail);
      expect(run.findings.join(' ').toLowerCase(), contains('blind spot'));
      final restore = run.fixes.firstWhere(
        (f) => f.code == 'restore-camera:CAM-GH-1',
      );
      expect(restore.passesAlone, isTrue);
      expect(run.verdictAfterFix, Verdict.pass);
    });
  });
}
