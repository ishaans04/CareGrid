import '../generated/protocol.dart';
import '../simulation/scenario_library.dart';
import 'campus_seed.dart';
import 'niet_geometry.dart';
import 'seed_data.dart';

/// NIET Greater Noida (Plot 19 old campus and Plot 14 new campus, Knowledge
/// Park II), modelled from public data:
///
/// * building footprints, gates and the road network: OpenStreetMap
///   (ODbL), turned into a routing twin by `scripts/build-niet-twin.mjs`;
/// * facilities (health centre with a full-time doctor and nurse, a 24x7
///   ambulance supported by an associated hospital, tie-ups with Yatharth and
///   Kailash hospitals, CCTV at important locations): NIET's NAAC self-study
///   report (2017);
/// * referral distances: OSRM over OpenStreetMap roads.
///
/// The unit roster, camera positions, people, incidents and timings are
/// illustrative, and the campus record says so. CareGrid is not affiliated
/// with NIET.
class NietSeed implements CampusSeed {
  const NietSeed();

  @override
  Campus get campus => Campus(
    code: 'niet',
    name: 'NIET Greater Noida',
    shortName: 'NIET',
    city: 'Greater Noida, Uttar Pradesh',
    description:
        'Noida Institute of Engineering and Technology: the old campus on '
        'Plot 19 and the new campus on Plot 14, Knowledge Park II. Twin built '
        'from OpenStreetMap; facility facts from NIET\'s public NAAC '
        'self-study report (2017).',
    utcOffsetMinutes: 330,
    incidentPrefix: 'NIET',
    fictional: false,
    attribution:
        'Map data © OpenStreetMap contributors, ODbL 1.0 · referral road '
        'distances: OSRM',
    affiliationNote:
        'Built from public OpenStreetMap data and NIET\'s public NAAC report. '
        'Not affiliated with or endorsed by NIET. The unit roster, camera '
        'positions, people and incidents are illustrative; positions marked '
        'approximate must be confirmed on site.',
    originLat: NietGeometry.originLat,
    originLon: NietGeometry.originLon,
    metersPerUnit: 1,
    mapWidth: NietGeometry.width,
    mapHeight: NietGeometry.height,
    mapLayers: NietGeometry.mapLayers,
  );

  @override
  List<Zone> zones() => [
    for (final g in NietGeometry.zones)
      Zone(
        campusId: 0,
        code: g.code,
        name: g.name,
        type: g.type,
        x: g.x,
        y: g.y,
        description: g.description,
        isOpen: g.isOpen,
        isRestricted: g.restricted,
        privacySensitive: g.privacySensitive,
        footprint: g.footprint,
        levels: g.levels,
        approximate: g.approximate,
        source: g.source,
      ),
  ];

  @override
  List<RoadSegment> roads(List<Zone> zones) => [
    for (final r in NietGeometry.roads)
      RoadSegment(
        campusId: 0,
        code: r.code,
        name: r.name,
        fromZone: r.from,
        toZone: r.to,
        lengthMeters: r.lengthMeters,
        isOutsideCampus: r.outside,
        path: r.path,
      ),
  ];

  static final _zoneAt = {for (final z in NietGeometry.zones) z.code: z};

  /// Illustrative camera plan: placed at building edges for rehearsal, not
  /// the institution's real CCTV layout.
  static Camera _cam(
    String code,
    String zone,
    String label,
    List<String> adjacent, {
    double dx = 0,
    double dy = 0,
    AssetHealth health = AssetHealth.online,
  }) => Camera(
    campusId: 0,
    code: code,
    zoneCode: zone,
    label: label,
    health: health,
    adjacentCameras: adjacent,
    x: _zoneAt[zone]!.x + dx,
    y: _zoneAt[zone]!.y + dy,
    rangeMeters: 25,
  );

  @override
  List<Camera> cameras() => [
    _cam('CAM-GT1', 'GT1', 'Old campus main gate', [], dx: 6, dy: 6),
    _cam('CAM-GT2', 'GT2', 'New campus gate', [], dx: 6, dy: 4),
    _cam('CAM-A-1', 'ABLK', 'A Block lobby', [], dy: 8),
    _cam('CAM-B-1', 'BBLK', 'B Block auditorium foyer', ['CAM-E-1'], dx: 8),
    _cam('CAM-E-1', 'EBLK', 'E Block reading room corridor', [
      'CAM-B-1',
    ], dx: -6),
    _cam('CAM-D-1', 'DBLK', 'D Block ground floor', [], dy: -6),
    _cam(
      'CAM-PH-1',
      'PHRM',
      'Pharmacy lab corridor, ground floor',
      [
        'CAM-PH-2',
      ],
      dx: -6,
      dy: -4,
    ),
    _cam(
      'CAM-PH-2',
      'PHRM',
      'Pharmacy lab corridor, first floor',
      [
        'CAM-PH-1',
      ],
      dx: 6,
      dy: 4,
    ),
    _cam(
      'CAM-MH-1',
      'MHOS',
      "Men's Hostel corridor, ground floor",
      [
        'CAM-MH-2',
      ],
      dx: -8,
      dy: -6,
    ),
    _cam(
      'CAM-MH-2',
      'MHOS',
      "Men's Hostel corridor, stairwell",
      [
        'CAM-MH-1',
      ],
      dx: 8,
      dy: 6,
    ),
    _cam('CAM-WH-1', 'WHOS', "Women's Hostel entrance", [], dy: 10),
    _cam('CAM-PLAY-1', 'PLAY', 'Playground, west side', [
      'CAM-PLAY-2',
    ], dx: -30),
    _cam('CAM-PLAY-2', 'PLAY', 'Playground, east side', [
      'CAM-PLAY-1',
    ], dx: 30),
    _cam('CAM-FOOD-1', 'FOOD', 'Food court', [], dx: 4),
    _cam('CAM-NB-1', 'NACD', 'New Campus Block lobby', [], dy: 6),
    _cam('CAM-GH-1', 'GHOS', "Girls' Hostel (new campus) entrance", [], dy: 8),
    _cam(
      'CAM-BH-1',
      'BHOS',
      "Boys' Hostel (new campus) entrance",
      [],
      dy: 6,
      health: AssetHealth.degraded,
    ),
    _cam(
      'CAM-NG-1',
      'NGND',
      'New Campus Ground',
      [],
      health: AssetHealth.offline,
    ),
  ];

  static Responder _r(
    String code,
    String name,
    ResponderType type,
    String base,
    int speed,
    int ready,
    List<String> capabilities,
    String contact,
  ) => Responder(
    campusId: 0,
    code: code,
    name: name,
    type: type,
    zoneCode: base,
    baseZoneCode: base,
    speedMetersPerMin: speed,
    mobilizationSeconds: ready,
    capabilities: capabilities,
    contact: contact,
  );

  /// Illustrative roster built around the facilities NIET's report lists.
  @override
  List<Responder> responders() => [
    _r(
      'DESK-GT1',
      'Main Gate security post',
      ResponderType.securityDesk,
      'GT1',
      80,
      15,
      ['First aid', 'Radio', 'Gate control'],
      'Radio ch. 1',
    ),
    _r(
      'DESK-MH',
      "Men's Hostel warden desk",
      ResponderType.securityDesk,
      'MHOS',
      80,
      15,
      ['First aid', 'Radio', 'Master keys'],
      'Radio ch. 2',
    ),
    _r(
      'DESK-WH',
      "Women's Hostel warden desk",
      ResponderType.securityDesk,
      'WHOS',
      80,
      15,
      ['First aid', 'Radio', 'Master keys'],
      'Radio ch. 2',
    ),
    _r(
      'DESK-GT2',
      'New Campus gate post',
      ResponderType.securityDesk,
      'GT2',
      80,
      15,
      ['First aid', 'Radio', 'Gate control'],
      'Radio ch. 3',
    ),
    _r(
      'DESK-GH',
      "Girls' Hostel (new campus) desk",
      ResponderType.securityDesk,
      'GHOS',
      80,
      15,
      ['First aid', 'Radio'],
      'Radio ch. 3',
    ),
    _r(
      'DESK-BH',
      "Boys' Hostel (new campus) desk",
      ResponderType.securityDesk,
      'BHOS',
      80,
      15,
      ['First aid', 'Radio'],
      'Radio ch. 3',
    ),
    _r(
      'PAT-1',
      'Security patrol e-cart',
      ResponderType.securityPatrol,
      'J12',
      200,
      20,
      ['AED', 'First aid', 'Stretcher'],
      'Radio ch. 1',
    ),
    _r('AMB-1', 'Campus ambulance', ResponderType.ambulance, 'HLTH', 450, 45, [
      'Basic life support',
      'Oxygen',
      'Stretcher',
    ], 'Radio ch. 4'),
    _r(
      'AMB-Y',
      'Yatharth Hospital ambulance',
      ResponderType.ambulance,
      'YATH',
      600,
      60,
      ['Advanced life support', 'Paramedic'],
      'Hospital emergency desk',
    ),
    _r(
      'MED-1',
      'Health Centre doctor and nurse',
      ResponderType.hospitalEr,
      'HLTH',
      80,
      60,
      ['Doctor', 'Nurse', 'Emergency kit'],
      'Health Centre',
    ),
    _r(
      'FIRE-1',
      'Fire & safety marshal',
      ResponderType.fireSafety,
      'GT1',
      250,
      30,
      ['Extinguishers', 'Hose reel', 'Evacuation'],
      'Radio ch. 1',
    ),
    _r(
      'FAC-1',
      'Estates & facilities crew',
      ResponderType.facilities,
      'J15',
      150,
      60,
      ['Power isolation', 'Water', 'Barricades'],
      'Estates office',
    ),
  ];

  @override
  List<ZonePolicy> policies() => SeedData.policies();

  @override
  List<StressScenario> stressScenarios() => [
    StressScenario(
      campusId: 0,
      code: 'ST-NIET-GATE',
      name: "Men's Hostel at 02:00, main gate blocked, campus units out",
      description:
          'The campus ambulance and the patrol e-cart are on other calls, so '
          'help must come from Yatharth Hospital while a stalled vehicle '
          'blocks the only mapped gate of the old campus.',
      zoneCode: 'MHOS',
      eventType: EventType.personDown,
      hour: 2,
      failures: [
        StressFailure(kind: StressFailureKind.responderBusy, target: 'AMB-1'),
        StressFailure(kind: StressFailureKind.responderBusy, target: 'PAT-1'),
        StressFailure(kind: StressFailureKind.gateClosed, target: 'GT1'),
      ],
      builtIn: true,
    ),
    StressScenario(
      campusId: 0,
      code: 'ST-NIET-AMB-OUT',
      name: 'Night hostel emergency, campus ambulance out',
      description:
          'Person down in the Women\'s Hostel at 01:30 while the campus '
          'ambulance is away: can a hospital ambulance meet the 5-minute '
          'arrival target?',
      zoneCode: 'WHOS',
      eventType: EventType.personDown,
      hour: 1,
      failures: [
        StressFailure(kind: StressFailureKind.responderBusy, target: 'AMB-1'),
      ],
      builtIn: true,
    ),
    StressScenario(
      campusId: 0,
      code: 'ST-NIET-NEW-CAMPUS',
      name: "Girls' Hostel on the new campus, 23:00, camera down",
      description:
          'An emergency on Plot 14 with its entrance camera offline. The '
          'nearest ambulance is on the old campus, about a kilometre away by '
          'public road.',
      zoneCode: 'GHOS',
      eventType: EventType.personDown,
      hour: 23,
      failures: [
        StressFailure(
          kind: StressFailureKind.cameraOffline,
          target: 'CAM-GH-1',
        ),
      ],
      builtIn: true,
    ),
    StressScenario(
      campusId: 0,
      code: 'ST-NIET-LAB-FIRE',
      name: 'Pharmacy lab fire with the fire marshal away',
      description:
          'Smoke in the Pharmacy Block at 14:00 while the fire & safety '
          'marshal is on another call.',
      zoneCode: 'PHRM',
      eventType: EventType.fire,
      hour: 14,
      failures: [
        StressFailure(kind: StressFailureKind.responderBusy, target: 'FIRE-1'),
      ],
      builtIn: true,
    ),
  ];

  @override
  List<HistoricIncident> get history => const [
    HistoricIncident(
      2,
      1,
      52,
      EventType.personDown,
      'MHOS',
      Severity.p1,
      responders: ['DESK-MH', 'AMB-1'],
      stages: [3, 7, 22, 10, 80, 18],
      outcome:
          'Student fainted after a viral fever; observed at the Health '
          'Centre, referred to Yatharth',
    ),
    HistoricIncident(
      3,
      16,
      20,
      EventType.fall,
      'PLAY',
      Severity.p2,
      responders: ['PAT-1', 'MED-1'],
      stages: [4, 9, 30, 15, 70, 25],
      outcome: 'Ankle sprain during cricket practice; treated on site',
    ),
    HistoricIncident(
      4,
      14,
      5,
      EventType.smoke,
      'PHRM',
      Severity.p0,
      source: SignalSource.iotSensor,
      responders: ['FIRE-1', 'PAT-1'],
      stages: [2, 4, 1, 8, 55, 10],
      outcome: 'Overheated hot plate in a teaching lab; isolated, no injury',
    ),
    HistoricIncident(
      5,
      22,
      40,
      EventType.sosRequest,
      'GHOS',
      Severity.p2,
      source: SignalSource.sos,
      observability: Observability.degraded,
      responders: ['DESK-GH', 'AMB-1'],
      stages: [1, 5, 40, 12, 160, 20],
      outcome: 'Severe migraine; transported to the Health Centre',
    ),
    HistoricIncident(
      6,
      19,
      15,
      EventType.vehicleCollision,
      'GT1',
      Severity.p1,
      responders: ['PAT-1', 'AMB-1'],
      stages: [3, 6, 25, 14, 50, 22],
      outcome: 'Two-wheeler skid at the gate; minor abrasions dressed',
    ),
    HistoricIncident(
      8,
      13,
      30,
      EventType.personDown,
      'EBLK',
      Severity.p2,
      responders: ['PAT-1', 'MED-1'],
      stages: [4, 25, 45, 20, 90, 30],
      outcome: 'Dehydration during exams; recovered at the Health Centre',
    ),
    HistoricIncident(
      9,
      17,
      45,
      EventType.fall,
      'NGND',
      Severity.p3,
      observability: Observability.blind,
      dismissal: 'Negative evidence: player got up and walked off',
      stages: [6, 8],
    ),
    HistoricIncident(
      10,
      2,
      10,
      EventType.personDown,
      'WHOS',
      Severity.p1,
      escalations: 1,
      responders: ['DESK-WH', 'AMB-1'],
      stages: [3, 6, 35, 40, 95, 20],
      outcome: 'Hypoglycaemia; glucose given, observed overnight',
    ),
    HistoricIncident(
      11,
      11,
      0,
      EventType.unattendedObject,
      'BBLK',
      Severity.p3,
      dismissal: 'Owner identified: a student\'s bag left at the auditorium',
      stages: [5, 30],
    ),
    HistoricIncident(
      12,
      23,
      55,
      EventType.sosRequest,
      'BHOS',
      Severity.p2,
      source: SignalSource.sos,
      observability: Observability.degraded,
      responders: ['DESK-BH', 'AMB-1'],
      stages: [1, 4, 30, 10],
      outcome:
          'Request withdrawn after the desk reached the room; no arrival '
          'of the ambulance was recorded',
    ),
  ];

  @override
  List<SeedUser> get users => const [
    SeedUser(
      'niet.command',
      'Kavya Sharma',
      UserRole.command,
      'Campus command, night shift',
      '1212',
      null,
      'NIET incident console, campus map, dispatch, Simulation Lab.',
    ),
    SeedUser(
      'niet.doctor',
      'Dr. Sameer Khan',
      UserRole.medical,
      'Medical officer, Health Centre',
      '2323',
      null,
      'Care console for the Health Centre: incoming cases and handoff.',
    ),
    SeedUser(
      'niet.amb',
      'Rakesh Yadav',
      UserRole.responder,
      'Campus ambulance crew',
      '3434',
      'AMB-1',
      'Responder app for the campus ambulance (Health Centre).',
    ),
    SeedUser(
      'niet.mh.desk',
      'Imran Ali',
      UserRole.responder,
      "Men's Hostel warden desk",
      '3535',
      'DESK-MH',
      "Responder app for the Men's Hostel desk.",
    ),
    SeedUser(
      'niet.patrol',
      'Deepak Chauhan',
      UserRole.responder,
      'Security patrol e-cart',
      '3636',
      'PAT-1',
      'Responder app for the patrol e-cart (AED on board).',
    ),
    SeedUser(
      'niet.admin',
      'Pooja Bansal',
      UserRole.admin,
      'Campus operations & IT administrator',
      '9191',
      null,
      'Readiness Lab, campus twin, policies and audit for NIET.',
    ),
    SeedUser(
      'niet.student',
      'Aditya Rawat',
      UserRole.member,
      "Student, Men's Hostel",
      '5151',
      null,
      'Campus member app: raise SOS, follow its status.',
    ),
    SeedUser(
      'niet.student2',
      'Simran Kaur',
      UserRole.member,
      "Student, Girls' Hostel (new campus)",
      '5252',
      null,
      'Campus member app: raise SOS, follow its status.',
    ),
  ];

  static SignalInput _sos(
    String zone,
    String location,
    String detail,
    int hour,
  ) => SignalInput(
    source: SignalSource.sos,
    eventType: EventType.sosRequest,
    zoneCode: zone,
    confidence: 0.95,
    detail: detail,
    locationDetail: location,
    contextHour: hour,
  );

  @override
  List<ScenarioDefinition> get scenarios => [
    ScenarioDefinition(
      code: 'NIET-MH-0217',
      title: "Collapse in the Men's Hostel at 02:17",
      description:
          'A student collapses in a hostel corridor at night. Two cameras '
          'see the same anonymous track; the night-hostel SOP applies.',
      expected:
          'P1 verified on corroboration, Health Centre pre-alerted, hostel '
          'desk + campus ambulance recommended, full proof chain.',
      zoneCode: 'MHOS',
      demonstrates: [
        'Two-camera corroboration',
        'Night SOP',
        'Proof-of-Response',
      ],
      steps: [
        ScenarioStep(
          0,
          ScenarioLibrary.cam(
            EventType.personDown,
            'MHOS',
            'CAM-MH-1',
            0.86,
            track: 'T-21',
            detail: 'Person on the floor, not moving',
            location: 'Ground floor corridor, wing B',
            hour: 2,
          ),
        ),
        ScenarioStep(
          2,
          ScenarioLibrary.cam(
            EventType.personDown,
            'MHOS',
            'CAM-MH-2',
            0.91,
            track: 'T-21',
            detail: 'Same person, still down',
            hour: 2,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'NIET-PHARM-SMOKE',
      title: 'Smoke in the Pharmacy Block lab',
      description:
          'A lab camera sees smoke and the smoke detector confirms it three '
          'seconds later.',
      expected: 'P0 hazard, fire marshal + patrol dispatched automatically.',
      zoneCode: 'PHRM',
      demonstrates: ['Camera + sensor fusion', 'Auto-dispatch for hazards'],
      steps: [
        ScenarioStep(
          0,
          ScenarioLibrary.cam(
            EventType.smoke,
            'PHRM',
            'CAM-PH-1',
            0.84,
            detail: 'Smoke near a fume hood',
            location: 'Ground floor teaching lab',
            hour: 14,
          ),
        ),
        ScenarioStep(
          3,
          SignalInput(
            source: SignalSource.iotSensor,
            eventType: EventType.smoke,
            zoneCode: 'PHRM',
            confidence: 0.95,
            detail: 'Smoke detector PH-G-03 in alarm',
            locationDetail: 'Ground floor teaching lab',
            contextHour: 14,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'NIET-PLAY-RECOVER',
      title: 'Fall on the playground, player gets up',
      description:
          'A fall during evening cricket; the same tracked player stands up '
          'five seconds later.',
      expected:
          'Dismissed by negative evidence on the same track; no dispatch.',
      zoneCode: 'PLAY',
      demonstrates: ['Negative evidence', 'No false dispatch'],
      steps: [
        ScenarioStep(
          0,
          ScenarioLibrary.cam(
            EventType.fall,
            'PLAY',
            'CAM-PLAY-1',
            0.82,
            track: 'T-5',
            hour: 17,
          ),
        ),
        ScenarioStep(
          5,
          ScenarioLibrary.cam(
            EventType.personRecovered,
            'PLAY',
            'CAM-PLAY-1',
            0.9,
            track: 'T-5',
            detail: 'Player stood up and walked off',
            hour: 17,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'NIET-GH-TWO-SOS',
      title: "Two separate SOS calls from the Girls' Hostel",
      description:
          'Two requests from different floors of the same building within a '
          'minute. They must not be merged into one case.',
      expected:
          'Two incidents, each with its own response; the second explains '
          'why it was kept separate.',
      zoneCode: 'GHOS',
      demonstrates: ['No hidden patient', 'SOS separation'],
      steps: [
        ScenarioStep(
          0,
          _sos('GHOS', 'Room 214, second floor', 'Roommate unresponsive', 23),
        ),
        ScenarioStep(
          20,
          _sos(
            'GHOS',
            'Ground floor common room',
            'Someone fell on the stairs',
            23,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'NIET-GATE-COLLISION',
      title: 'Two-wheeler collision at the main gate',
      description:
          'A collision at the old campus gate at evening rush; a rider is '
          'seen down two seconds later.',
      expected:
          'One incident with a linked victim, severity raised, '
          'ambulance included.',
      zoneCode: 'GT1',
      demonstrates: ['Victim linking', 'Mobility SOP'],
      steps: [
        ScenarioStep(
          0,
          ScenarioLibrary.cam(
            EventType.vehicleCollision,
            'GT1',
            'CAM-GT1',
            0.88,
            detail: 'Two-wheeler and car at the gate',
            hour: 19,
          ),
        ),
        ScenarioStep(
          2,
          ScenarioLibrary.cam(
            EventType.personDown,
            'GT1',
            'CAM-GT1',
            0.87,
            track: 'T-3',
            detail: 'Rider on the ground',
            hour: 19,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'NIET-MISSED-ACK',
      title: 'Campus ambulance does not acknowledge',
      description:
          "The Men's Hostel emergency, but the campus ambulance never "
          'acknowledges its dispatch.',
      expected:
          'Ambulance times out after the SLA, is marked unreachable, the case '
          'escalates and the Yatharth ambulance is dispatched.',
      zoneCode: 'MHOS',
      faults: ['noAck:AMB-1'],
      demonstrates: [
        'Missed acknowledgement',
        'Re-dispatch to a partner hospital',
      ],
      steps: [
        ScenarioStep(
          0,
          ScenarioLibrary.cam(
            EventType.personDown,
            'MHOS',
            'CAM-MH-1',
            0.88,
            track: 'T-30',
            hour: 2,
          ),
        ),
        ScenarioStep(
          2,
          ScenarioLibrary.cam(
            EventType.personDown,
            'MHOS',
            'CAM-MH-2',
            0.9,
            track: 'T-30',
            hour: 2,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'NIET-NEW-CAMPUS-NIGHT',
      title: "SOS from the Boys' Hostel on the new campus",
      description:
          'A late-night request from Plot 14, where the hostel entrance '
          'camera is degraded. The ambulance must cross between campuses.',
      expected:
          'Verified on the human report, degraded coverage stated, hostel '
          'desk + ambulance planned over the public road.',
      zoneCode: 'BHOS',
      demonstrates: ['Inter-campus routing', 'Degraded-coverage transparency'],
      steps: [
        ScenarioStep(
          0,
          _sos(
            'BHOS',
            'Room 108, first floor',
            'Friend has chest pain and is sweating',
            23,
          ),
        ),
      ],
    ),
  ];
}
