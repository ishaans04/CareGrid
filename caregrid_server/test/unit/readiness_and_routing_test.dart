import 'package:caregrid_server/src/agent/policy_engine.dart';
import 'package:caregrid_server/src/generated/protocol.dart';
import 'package:caregrid_server/src/readiness/stress_test_engine.dart';
import 'package:caregrid_server/src/response/response_planner.dart';
import 'package:caregrid_server/src/seed/seed_data.dart';
import 'package:caregrid_server/src/twin/campus_graph.dart';
import 'package:caregrid_server/src/twin/twin_snapshot.dart';
import 'package:test/test.dart';

TwinSnapshot seededTwin() {
  final zones = SeedData.zones();
  return TwinSnapshot(
    zones: {for (final z in zones) z.code: z},
    roads: SeedData.roads(zones),
    cameras: {for (final c in SeedData.cameras()) c.code: c},
    responders: {for (final r in SeedData.responders()) r.code: r},
    policies: SeedData.policies(),
  );
}

StressScenario scenario(String code) =>
    SeedData.stressScenarios().firstWhere((s) => s.code == code);

void main() {
  group('Campus graph', () {
    test('routes the hospital ambulance to Birch Hostel via West Junction', () {
      final route = CampusGraph(seededTwin()).route('HOS', 'HB');
      expect(route.path, ['HOS', 'J4', 'HB']);
      expect(route.meters, inInclusiveRange(440, 480));
    });

    test('a closed gate is impassable unless it has an emergency override', () {
      final twin = seededTwin();
      twin.zones['G3']!.isOpen = false;
      final around = CampusGraph(twin).route('NPOST', 'HB');
      expect(around.path, isNot(contains('G3')));
      expect(around.path, isNot(contains('G4')));

      twin.zones['G4']!.emergencyOverride = true;
      final viaService = CampusGraph(twin).route('NPOST', 'HB');
      expect(viaService.path, contains('G4'));
      expect(viaService.meters, lessThan(around.meters));
    });

    test('blocked roads are avoided', () {
      final twin = seededTwin();
      twin.roads.firstWhere((r) => r.code == 'R15').status = RoadStatus.blocked;
      final route = CampusGraph(twin).route('HOS', 'HB');
      expect(route.found, isFalse, reason: 'Birch Lane is the only way in');
    });
  });

  group('Policy engine', () {
    test('night hostel SOP wins over the generic medical SOP at 02:00', () {
      final policy = PolicyEngine.select(
        SeedData.policies(),
        ZoneType.hostel,
        EventFamily.medical,
        2,
      );
      expect(policy?.code, 'SOP-HST-MED-NIGHT');
    });

    test('day hostel SOP applies at 14:00', () {
      final policy = PolicyEngine.select(
        SeedData.policies(),
        ZoneType.hostel,
        EventFamily.medical,
        14,
      );
      expect(policy?.code, 'SOP-HST-MED-DAY');
    });

    test('library falls back to the any-zone medical SOP', () {
      final policy = PolicyEngine.select(
        SeedData.policies(),
        ZoneType.libraryHall,
        EventFamily.medical,
        15,
      );
      expect(policy?.code, 'SOP-MED-ANY');
    });
  });

  group('Response planner', () {
    test('hero incident: Birch desk + Ambulance A2 within SLA', () {
      final twin = seededTwin();
      final policy = twin.policies.firstWhere(
        (p) => p.code == 'SOP-HST-MED-NIGHT',
      );
      final plan = ResponsePlanner(twin).plan(
        zoneCode: 'HB',
        policy: policy,
        elapsedSeconds: 10,
      );
      expect(plan.options.map((o) => o.responderCode), ['DESK-HB', 'AMB-A2']);
      expect(plan.options.every((o) => o.withinSla), isTrue);
      expect(plan.warnings, isEmpty);
    });

    test('falls back when no unit of a required type is available', () {
      final twin = seededTwin();
      for (final code in ['DESK-HA', 'DESK-HB', 'DESK-HC', 'DESK-HD']) {
        twin.responders[code]!.status = ResponderStatus.busy;
      }
      final policy = twin.policies.firstWhere(
        (p) => p.code == 'SOP-HST-MED-NIGHT',
      );
      final plan = ResponsePlanner(twin).plan(
        zoneCode: 'HB',
        policy: policy,
        elapsedSeconds: 0,
      );
      expect(plan.options.first.role, 'fallback');
      expect(plan.options.first.responderType, ResponderType.securityPatrol);
      expect(plan.warnings.first, contains('fallback'));
    });
  });

  group('Stress-Test Engine', () {
    test('02:17 compound failure fails, then passes with alternate route', () {
      final run = StressTestEngine(
        seededTwin(),
      ).run(scenario('ST-HOSTEL-0217'), 'test');
      expect(run.verdict, Verdict.fail);
      expect(run.predictedSeconds, greaterThan(run.slaSeconds));
      expect(run.findings.first, contains('No complete response'));
      expect(
        run.fixes.map((f) => f.code),
        containsAll(['gate-override:G4', 'restage:AMB-A1:HOS']),
      );
      expect(
        run.fixes.firstWhere((f) => f.code == 'gate-override:G4').passesAlone,
        isTrue,
      );
      expect(run.verdictAfterFix, Verdict.pass);
      expect(run.predictedAfterFixSeconds, lessThanOrEqualTo(run.slaSeconds));
    });

    test(
      'lab smoke with the fire unit out is fixed by re-staging facilities',
      () {
        final run = StressTestEngine(
          seededTwin(),
        ).run(scenario('ST-LAB-FIRE-OUT'), 'test');
        expect(run.verdict, Verdict.fail);
        expect(run.fixes.map((f) => f.code), contains('restage:FAC-1:J5'));
        expect(run.verdictAfterFix, Verdict.pass);
      },
    );

    test('blind spot passes but reports SOS-dependent detection', () {
      final run = StressTestEngine(
        seededTwin(),
      ).run(scenario('ST-CEDAR-BLIND'), 'test');
      expect(run.verdict, Verdict.pass);
      expect(run.findings.join(' '), contains('Blind spot'));
    });

    test('East Gate collision survives the South Avenue closure', () {
      final run = StressTestEngine(
        seededTwin(),
      ).run(scenario('ST-EASTGATE-ROAD'), 'test');
      expect(run.verdict, Verdict.pass);
    });

    test('never mutates the live twin', () {
      final twin = seededTwin();
      StressTestEngine(twin).run(scenario('ST-HOSTEL-0217'), 'test');
      expect(twin.responders['AMB-A2']!.status, ResponderStatus.available);
      expect(twin.zones['G3']!.isOpen, isTrue);
      expect(twin.cameras['CAM-HB-B08']!.health, AssetHealth.online);
    });
  });
}
