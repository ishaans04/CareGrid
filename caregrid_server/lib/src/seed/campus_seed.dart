import '../generated/protocol.dart';
import '../simulation/scenario_library.dart';
import 'niet_seed.dart';
import 'seed_data.dart';

/// One seeded demo account.
class SeedUser {
  const SeedUser(
    this.handle,
    this.name,
    this.role,
    this.title,
    this.pin,
    this.responderCode,
    this.description,
  );

  final String handle;
  final String name;
  final UserRole role;
  final String title;
  final String pin;
  final String? responderCode;
  final String description;
}

/// Everything needed to stand up one campus: its record, digital twin,
/// policies, rehearsals, history, demo accounts and live scenarios.
///
/// Twin, policy and rehearsal lists are templates with `campusId: 0`; the
/// seeder binds them to the campus row it creates.
abstract class CampusSeed {
  Campus get campus;
  List<Zone> zones();
  List<RoadSegment> roads(List<Zone> zones);
  List<Camera> cameras();
  List<Responder> responders();
  List<ZonePolicy> policies();
  List<StressScenario> stressScenarios();
  List<HistoricIncident> get history;
  List<SeedUser> get users;
  List<ScenarioDefinition> get scenarios;
}

/// The fictional reference campus the prototype was built around.
class MeridianSeed implements CampusSeed {
  const MeridianSeed();

  @override
  Campus get campus => Campus(
    code: 'meridian',
    name: SeedData.campusName,
    shortName: 'Meridian',
    description:
        'Fictional residential reference campus with hostels, a hospital, '
        'labs and a perimeter road. Used to rehearse the full response loop.',
    utcOffsetMinutes: 330,
    incidentPrefix: 'INC',
    fictional: true,
    affiliationNote:
        'Fictional campus. Any resemblance to a real institution is '
        'coincidental.',
    metersPerUnit: SeedData.metersPerUnit,
    mapWidth: 1000,
    mapHeight: 700,
  );

  @override
  List<Zone> zones() => SeedData.zones();
  @override
  List<RoadSegment> roads(List<Zone> zones) => SeedData.roads(zones);
  @override
  List<Camera> cameras() => SeedData.cameras();
  @override
  List<Responder> responders() => SeedData.responders();
  @override
  List<ZonePolicy> policies() => SeedData.policies();
  @override
  List<StressScenario> stressScenarios() => SeedData.stressScenarios();
  @override
  List<HistoricIncident> get history => SeedData.history;
  @override
  List<SeedUser> get users => [
    for (final (handle, name, role, title, pin, responder, description)
        in SeedData.users)
      SeedUser(handle, name, role, title, pin, responder, description),
  ];
  @override
  List<ScenarioDefinition> get scenarios => ScenarioLibrary.meridian;
}

class CampusSeeds {
  CampusSeeds._();

  static const List<CampusSeed> all = [MeridianSeed(), NietSeed()];

  static CampusSeed? byCode(String code) {
    for (final seed in all) {
      if (seed.campus.code == code) return seed;
    }
    return null;
  }

  /// Network-level demo accounts: de-identified aggregates across campuses.
  static const networkUsers = [
    SeedUser(
      'network.ops',
      'Devika Nair',
      UserRole.network,
      'Network operations lead',
      '7070',
      null,
      'Cross-campus readiness and response health. Counts and timings only; '
          'no incident detail.',
    ),
  ];
}
