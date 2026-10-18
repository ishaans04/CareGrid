import 'dart:math' as math;

import '../generated/protocol.dart';

/// Seeded reference deployment: a fictional "Meridian Demo Campus".
/// Everything the prototype shows is derived from this data.
class SeedData {
  SeedData._();

  static const campusName = 'Meridian Demo Campus';

  /// Canvas units to meters for road lengths.
  static const metersPerUnit = 1.5;

  // ------------------------------------------------------------------ zones

  static List<Zone> zones() => [
    // Outside campus.
    _z(
      'NPOST',
      'North Response Post',
      ZoneType.outside,
      500,
      25,
      'Ambulance standby post outside the North Gate.',
    ),
    _z(
      'PNW',
      'Perimeter Road (north-west)',
      ZoneType.outside,
      40,
      25,
      'Public perimeter road.',
    ),
    _z(
      'PSW',
      'Perimeter Road (south-west)',
      ZoneType.outside,
      40,
      665,
      'Public perimeter road.',
    ),
    // Gates.
    _z('G1', 'Main Gate', ZoneType.gate, 110, 640, 'Staffed 24x7.'),
    _z('G2', 'East Gate', ZoneType.gate, 900, 640, 'Busy two-wheeler traffic.'),
    _z(
      'G3',
      'North Gate',
      ZoneType.gate,
      500,
      95,
      'Main entry for the North Response Post.',
    ),
    Zone(
      code: 'G4',
      name: 'North-West Service Gate',
      type: ZoneType.gate,
      x: 70,
      y: 120,
      description:
          'Locked service gate. Can be opened remotely if '
          'pre-authorized for emergencies.',
      isOpen: false,
      emergencyOverride: false,
    ),
    // Junctions.
    _z('J1', 'South-West Junction', ZoneType.junction, 200, 540, null),
    _z('J2', 'South Junction', ZoneType.junction, 500, 540, null),
    _z('J3', 'South-East Junction', ZoneType.junction, 800, 540, null),
    _z('J4', 'West Junction', ZoneType.junction, 200, 260, null),
    _z('J5', 'Central Junction', ZoneType.junction, 500, 260, null),
    _z('J6', 'East Junction', ZoneType.junction, 800, 260, null),
    _z('J7', 'North Junction', ZoneType.junction, 500, 165, null),
    // Buildings.
    _z(
      'SEC',
      'Security Control Room',
      ZoneType.admin,
      90,
      520,
      'Command center and fire & safety base.',
    ),
    _z('ADM', 'Admin Block', ZoneType.admin, 330, 620, 'Facilities office.'),
    _z(
      'HOS',
      'Campus Hospital',
      ZoneType.hospital,
      330,
      330,
      '24x7 emergency room, two ambulance bays.',
    ),
    _z('ACD', 'Academic Complex', ZoneType.academic, 500, 420, null),
    Zone(
      code: 'LAB',
      name: 'Chemistry Labs',
      type: ZoneType.lab,
      x: 650,
      y: 420,
      description: 'Restricted. Fume hoods, solvent store.',
      isRestricted: true,
    ),
    _z('LIB', 'Central Library', ZoneType.libraryHall, 330, 450, null),
    _z(
      'COM',
      'Student Commons',
      ZoneType.commons,
      650,
      260,
      'Food court and event plaza.',
    ),
    _z(
      'SPT',
      'Sports Complex',
      ZoneType.sports,
      880,
      420,
      'Football field, courts, gym.',
    ),
    Zone(
      code: 'HA',
      name: 'Aster Hostel',
      type: ZoneType.hostel,
      x: 150,
      y: 165,
      description: '420 residents. Security desk at the lobby.',
      privacySensitive: true,
    ),
    Zone(
      code: 'HB',
      name: 'Birch Hostel',
      type: ZoneType.hostel,
      x: 330,
      y: 170,
      description: '510 residents, blocks A-C. Security desk at Block B.',
      privacySensitive: true,
    ),
    Zone(
      code: 'HC',
      name: 'Cedar Hostel',
      type: ZoneType.hostel,
      x: 650,
      y: 165,
      description: '380 residents. Lobby camera currently offline.',
      privacySensitive: true,
    ),
    Zone(
      code: 'HD',
      name: 'Deodar Hostel',
      type: ZoneType.hostel,
      x: 850,
      y: 165,
      description: '300 residents.',
      privacySensitive: true,
    ),
  ];

  static Zone _z(
    String code,
    String name,
    ZoneType type,
    double x,
    double y,
    String? description,
  ) => Zone(
    code: code,
    name: name,
    type: type,
    x: x,
    y: y,
    description: description,
  );

  // ------------------------------------------------------------------ roads

  /// (code, name, from, to, outsideCampus)
  static const _roads = <(String, String, String, String, bool)>[
    ('R1', 'Main Gate Road', 'G1', 'J1', false),
    ('R2', 'South Avenue (west)', 'J1', 'J2', false),
    ('R3', 'South Avenue (east)', 'J2', 'J3', false),
    ('R4', 'East Gate Road', 'J3', 'G2', false),
    ('R5', 'West Road', 'J1', 'J4', false),
    ('R6', 'Central Road (west)', 'J4', 'J5', false),
    ('R7', 'Central Road (commons)', 'J5', 'COM', false),
    ('R8', 'Central Road (east)', 'COM', 'J6', false),
    ('R9', 'East Road', 'J3', 'J6', false),
    ('R10', 'Academic Drive (south)', 'J2', 'ACD', false),
    ('R11', 'Academic Drive (north)', 'ACD', 'J5', false),
    ('R12', 'North Road', 'J5', 'J7', false),
    ('R13', 'North Gate Road', 'J7', 'G3', false),
    ('R14', 'Aster Lane', 'J4', 'HA', false),
    ('R15', 'Birch Lane', 'J4', 'HB', false),
    ('R16', 'Cedar Lane (west)', 'J7', 'HC', false),
    ('R17', 'Cedar Lane (east)', 'J6', 'HC', false),
    ('R18', 'Deodar Lane', 'J6', 'HD', false),
    ('R19', 'Hospital Road (west)', 'J4', 'HOS', false),
    ('R20', 'Hospital Road (east)', 'HOS', 'J5', false),
    ('R21', 'Lab Road (north)', 'J5', 'LAB', false),
    ('R22', 'Lab Road (south)', 'LAB', 'J3', false),
    ('R23', 'Library Walk', 'J1', 'LIB', false),
    ('R24', 'Library Link', 'LIB', 'ACD', false),
    ('R25', 'Sports Road (south)', 'J3', 'SPT', false),
    ('R26', 'Sports Road (north)', 'SPT', 'J6', false),
    ('R27', 'Control Room Lane', 'J1', 'SEC', false),
    ('R28', 'Admin Lane', 'J2', 'ADM', false),
    ('R29', 'Service Lane', 'HA', 'G4', false),
    ('O1', 'North Post Approach', 'G3', 'NPOST', true),
    ('O2', 'Perimeter Road (north)', 'NPOST', 'PNW', true),
    ('O3', 'Service Gate Approach', 'PNW', 'G4', true),
    ('O4', 'Perimeter Road (west)', 'PNW', 'PSW', true),
    ('O5', 'Main Gate Approach', 'PSW', 'G1', true),
  ];

  static List<RoadSegment> roads(List<Zone> zones) {
    final byCode = {for (final z in zones) z.code: z};
    return [
      for (final (code, name, from, to, outside) in _roads)
        RoadSegment(
          code: code,
          name: name,
          fromZone: from,
          toZone: to,
          lengthMeters: _length(byCode[from]!, byCode[to]!),
          isOutsideCampus: outside,
        ),
    ];
  }

  static int _length(Zone a, Zone b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return (math.sqrt(dx * dx + dy * dy) * metersPerUnit).round();
  }

  // ---------------------------------------------------------------- cameras

  static List<Camera> cameras() => [
    _c('CAM-HB-B07', 'HB', 'Birch Block B, ground corridor 2 (east)', [
      'CAM-HB-B08',
    ]),
    _c('CAM-HB-B08', 'HB', 'Birch Block B, ground corridor 2 (west)', [
      'CAM-HB-B07',
    ]),
    _c('CAM-HA-01', 'HA', 'Aster lobby', ['CAM-HA-02']),
    _c('CAM-HA-02', 'HA', 'Aster stairwell', ['CAM-HA-01']),
    _c('CAM-HC-01', 'HC', 'Cedar lobby', [], health: AssetHealth.offline),
    _c('CAM-HD-01', 'HD', 'Deodar lobby', []),
    _c('CAM-LAB-02', 'LAB', 'Chemistry corridor, fume hood bays', [
      'CAM-LAB-03',
    ]),
    _c('CAM-LAB-03', 'LAB', 'Chemistry solvent store door', ['CAM-LAB-02']),
    _c('CAM-SPT-01', 'SPT', 'Sports field north', ['CAM-SPT-02']),
    _c('CAM-SPT-02', 'SPT', 'Sports field south', ['CAM-SPT-01']),
    _c('CAM-G2-01', 'G2', 'East Gate barrier', ['CAM-J3-01']),
    _c('CAM-J3-01', 'J3', 'South-East junction', ['CAM-G2-01']),
    _c('CAM-LIB-01', 'LIB', 'Library reading hall', []),
    _c('CAM-ACD-03', 'ACD', 'Academic atrium', []),
    _c('CAM-COM-01', 'COM', 'Commons plaza (east exit)', ['CAM-COM-02']),
    _c('CAM-COM-02', 'COM', 'Commons plaza (west exit)', ['CAM-COM-01']),
    _c('CAM-G3-01', 'G3', 'North Gate', []),
    _c('CAM-HOS-01', 'HOS', 'Hospital entrance', []),
    _c('CAM-G1-01', 'G1', 'Main Gate', []),
  ];

  static Camera _c(
    String code,
    String zone,
    String label,
    List<String> adjacent, {
    AssetHealth health = AssetHealth.online,
  }) => Camera(
    code: code,
    zoneCode: zone,
    label: label,
    health: health,
    adjacentCameras: adjacent,
    privacyMasked: true,
  );

  // ------------------------------------------------------------- responders

  static List<Responder> responders() => [
    _r(
      'DESK-HA',
      'Aster Hostel Security Desk',
      ResponderType.securityDesk,
      'HA',
      80,
      15,
      ['First-aid kit', 'AED'],
      'Ext. 2101',
    ),
    _r(
      'DESK-HB',
      'Birch Hostel Security Desk',
      ResponderType.securityDesk,
      'HB',
      80,
      15,
      ['First-aid kit', 'AED'],
      'Ext. 2102',
    ),
    _r(
      'DESK-HC',
      'Cedar Hostel Security Desk',
      ResponderType.securityDesk,
      'HC',
      80,
      15,
      ['First-aid kit'],
      'Ext. 2103',
    ),
    _r(
      'DESK-HD',
      'Deodar Hostel Security Desk',
      ResponderType.securityDesk,
      'HD',
      80,
      15,
      ['First-aid kit'],
      'Ext. 2104',
    ),
    _r('PAT-1', 'Patrol Bike 1', ResponderType.securityPatrol, 'J5', 300, 15, [
      'AED',
      'First-aid kit',
      'Radio',
    ], 'Radio ch. 3'),
    _r('PAT-2', 'Patrol Bike 2', ResponderType.securityPatrol, 'J3', 300, 15, [
      'First-aid kit',
      'Radio',
      'Traffic cones',
    ], 'Radio ch. 3'),
    _r('AMB-A1', 'Ambulance A1', ResponderType.ambulance, 'NPOST', 500, 30, [
      'Stretcher',
      'Oxygen',
      'AED',
      'BLS crew',
    ], 'Radio ch. 1'),
    _r('AMB-A2', 'Ambulance A2', ResponderType.ambulance, 'HOS', 500, 30, [
      'Stretcher',
      'Oxygen',
      'AED',
      'BLS crew',
    ], 'Radio ch. 1'),
    _r('ER-1', 'Hospital ER Team', ResponderType.hospitalEr, 'HOS', 80, 60, [
      'Emergency physician',
      'Nurse',
      'Resuscitation bay',
    ], 'Ext. 2000'),
    _r(
      'FIRE-1',
      'Fire & Safety Unit',
      ResponderType.fireSafety,
      'SEC',
      450,
      30,
      ['Extinguishers', 'Breathing apparatus', 'Hazmat kit'],
      'Radio ch. 2',
    ),
    _r('FAC-1', 'Facilities Crew', ResponderType.facilities, 'ADM', 200, 60, [
      'Pumps',
      'Electrical isolation',
      'Barricades',
    ], 'Ext. 2300'),
  ];

  static Responder _r(
    String code,
    String name,
    ResponderType type,
    String zone,
    int speed,
    int mobilization,
    List<String> capabilities,
    String contact,
  ) => Responder(
    code: code,
    name: name,
    type: type,
    zoneCode: zone,
    baseZoneCode: zone,
    speedMetersPerMin: speed,
    mobilizationSeconds: mobilization,
    capabilities: capabilities,
    contact: contact,
  );

  // --------------------------------------------------------------- policies

  static List<ZonePolicy> policies() => [
    ZonePolicy(
      code: 'SOP-HST-MED-NIGHT',
      name: 'Hostel medical event (night)',
      zoneType: ZoneType.hostel,
      family: EventFamily.medical,
      startHour: 22,
      endHour: 6,
      severity: Severity.p1,
      minConfidence: 0.75,
      requireCorroboration: true,
      autoDispatch: false,
      notifyHospital: true,
      responderTypes: [ResponderType.securityDesk, ResponderType.ambulance],
      fallbackTypes: [ResponderType.securityPatrol],
      verifySlaSeconds: 45,
      ackSlaSeconds: 30,
      arrivalSlaSeconds: 300,
      careSlaSeconds: 120,
      instructions: [
        'Check breathing. If absent, start CPR and send someone for the AED.',
        'Do not move the person unless the location is unsafe.',
        'Keep the corridor and stairwell clear for the ambulance crew.',
        'Mark arrival and care start in the responder app.',
      ],
    ),
    ZonePolicy(
      code: 'SOP-HST-MED-DAY',
      name: 'Hostel medical event (day)',
      zoneType: ZoneType.hostel,
      family: EventFamily.medical,
      startHour: 6,
      endHour: 22,
      severity: Severity.p2,
      minConfidence: 0.8,
      requireCorroboration: true,
      autoDispatch: false,
      notifyHospital: true,
      responderTypes: [ResponderType.securityDesk, ResponderType.ambulance],
      fallbackTypes: [ResponderType.securityPatrol],
      verifySlaSeconds: 60,
      ackSlaSeconds: 45,
      arrivalSlaSeconds: 420,
      careSlaSeconds: 180,
      instructions: [
        'Check responsiveness and breathing.',
        'Clear onlookers; protect privacy.',
        'Mark arrival and care start in the responder app.',
      ],
    ),
    ZonePolicy(
      code: 'SOP-SPT-MED',
      name: 'Sports field injury',
      zoneType: ZoneType.sports,
      family: EventFamily.medical,
      severity: Severity.p2,
      minConfidence: 0.85,
      requireCorroboration: true,
      autoDispatch: false,
      notifyHospital: true,
      responderTypes: [ResponderType.securityPatrol, ResponderType.ambulance],
      fallbackTypes: [],
      verifySlaSeconds: 60,
      ackSlaSeconds: 45,
      arrivalSlaSeconds: 420,
      careSlaSeconds: 180,
      instructions: [
        'Falls are common here: look for the person getting up before acting.',
        'Stop play near the injured person.',
        'Immobilize suspected fractures; wait for the ambulance crew.',
      ],
    ),
    ZonePolicy(
      code: 'SOP-LAB-HAZ',
      name: 'Laboratory fire / hazard',
      zoneType: ZoneType.lab,
      family: EventFamily.fireHazard,
      severity: Severity.p0,
      minConfidence: 0.7,
      requireCorroboration: true,
      autoDispatch: true,
      notifyHospital: true,
      responderTypes: [ResponderType.fireSafety, ResponderType.securityPatrol],
      fallbackTypes: [ResponderType.facilities],
      verifySlaSeconds: 20,
      ackSlaSeconds: 20,
      arrivalSlaSeconds: 240,
      careSlaSeconds: 120,
      instructions: [
        'Evacuate the corridor; do not use lifts.',
        'Isolate gas and electrical supply at the lab panel.',
        'Fire & safety unit leads; patrol holds the cordon.',
      ],
    ),
    ZonePolicy(
      code: 'SOP-FIRE-ANY',
      name: 'Fire / smoke (any zone)',
      family: EventFamily.fireHazard,
      severity: Severity.p1,
      minConfidence: 0.75,
      requireCorroboration: true,
      autoDispatch: true,
      notifyHospital: false,
      responderTypes: [ResponderType.fireSafety],
      fallbackTypes: [ResponderType.securityPatrol],
      verifySlaSeconds: 30,
      ackSlaSeconds: 30,
      arrivalSlaSeconds: 300,
      careSlaSeconds: 180,
      instructions: ['Evacuate the area.', 'Fire & safety unit leads.'],
    ),
    ZonePolicy(
      code: 'SOP-ROAD-COLL',
      name: 'Road collision',
      family: EventFamily.mobility,
      severity: Severity.p1,
      minConfidence: 0.7,
      requireCorroboration: false,
      autoDispatch: false,
      notifyHospital: true,
      responderTypes: [ResponderType.securityPatrol, ResponderType.ambulance],
      fallbackTypes: [],
      verifySlaSeconds: 45,
      ackSlaSeconds: 30,
      arrivalSlaSeconds: 360,
      careSlaSeconds: 120,
      instructions: [
        'Secure the scene with cones; stop traffic at the gate.',
        'Do not remove a rider\'s helmet.',
        'Keep the emergency lane open for the ambulance.',
      ],
    ),
    ZonePolicy(
      code: 'SOP-MED-ANY',
      name: 'Medical event (any zone)',
      family: EventFamily.medical,
      severity: Severity.p2,
      minConfidence: 0.8,
      requireCorroboration: true,
      autoDispatch: false,
      notifyHospital: true,
      responderTypes: [ResponderType.securityPatrol, ResponderType.ambulance],
      fallbackTypes: [ResponderType.securityDesk],
      verifySlaSeconds: 60,
      ackSlaSeconds: 45,
      arrivalSlaSeconds: 420,
      careSlaSeconds: 180,
      instructions: [
        'Check responsiveness and breathing.',
        'Mark arrival and care start in the responder app.',
      ],
    ),
    ZonePolicy(
      code: 'SOP-CROWD',
      name: 'Dangerous crowding',
      family: EventFamily.crowd,
      severity: Severity.p1,
      minConfidence: 0.75,
      requireCorroboration: true,
      autoDispatch: false,
      notifyHospital: true,
      responderTypes: [ResponderType.securityPatrol, ResponderType.ambulance],
      fallbackTypes: [ResponderType.securityDesk],
      verifySlaSeconds: 30,
      ackSlaSeconds: 30,
      arrivalSlaSeconds: 300,
      careSlaSeconds: 120,
      instructions: [
        'Open every exit; stop inflow at the entrance.',
        'Use the PA to direct people away from the pinch point.',
        'Triage casualties at the edge of the crowd.',
      ],
    ),
    ZonePolicy(
      code: 'SOP-LAB-ACCESS',
      name: 'Restricted lab entry',
      zoneType: ZoneType.lab,
      family: EventFamily.access,
      severity: Severity.p2,
      minConfidence: 0.8,
      requireCorroboration: false,
      autoDispatch: false,
      notifyHospital: false,
      responderTypes: [ResponderType.securityPatrol],
      fallbackTypes: [],
      verifySlaSeconds: 60,
      ackSlaSeconds: 45,
      arrivalSlaSeconds: 300,
      careSlaSeconds: 300,
      instructions: ['Verify induction status; escort out if not inducted.'],
    ),
    ZonePolicy(
      code: 'SOP-ENV-ANY',
      name: 'Environmental hazard',
      family: EventFamily.environment,
      severity: Severity.p3,
      minConfidence: 0.7,
      requireCorroboration: false,
      autoDispatch: false,
      notifyHospital: false,
      responderTypes: [ResponderType.facilities],
      fallbackTypes: [ResponderType.securityPatrol],
      verifySlaSeconds: 120,
      ackSlaSeconds: 120,
      arrivalSlaSeconds: 900,
      careSlaSeconds: 600,
      instructions: ['Isolate water / power; barricade the area.'],
    ),
    ZonePolicy(
      code: 'SOP-OBJ-ANY',
      name: 'Unattended object',
      family: EventFamily.object,
      severity: Severity.p3,
      minConfidence: 0.7,
      requireCorroboration: false,
      autoDispatch: false,
      notifyHospital: false,
      responderTypes: [ResponderType.securityPatrol],
      fallbackTypes: [],
      verifySlaSeconds: 120,
      ackSlaSeconds: 60,
      arrivalSlaSeconds: 600,
      careSlaSeconds: 600,
      instructions: ['Do not touch. Ask around for the owner first.'],
    ),
  ];

  // ------------------------------------------------------------------ users

  /// (handle, name, role, title, pin, responderCode, description)
  static const users =
      <(String, String, UserRole, String, String, String?, String)>[
        (
          'cmd.night',
          'Riya Menon',
          UserRole.command,
          'Night shift command operator',
          '1111',
          null,
          'Incident console, live map, dispatch, Simulation Lab.',
        ),
        (
          'er.doctor',
          'Dr. Arjun Rao',
          UserRole.medical,
          'Doctor on duty, campus hospital',
          '2222',
          null,
          'Care console: incoming cases, ETA, handoff.',
        ),
        (
          'amb.a2',
          'Kabir Singh',
          UserRole.responder,
          'Ambulance A2 crew lead',
          '3302',
          'AMB-A2',
          'Responder app for Ambulance A2 (stationed at the hospital).',
        ),
        (
          'desk.birch',
          'Meera Das',
          UserRole.responder,
          'Birch Hostel security desk',
          '3303',
          'DESK-HB',
          'Responder app for the Birch Hostel desk.',
        ),
        (
          'amb.a1',
          'Vikram Joshi',
          UserRole.responder,
          'Ambulance A1 crew lead',
          '3301',
          'AMB-A1',
          'Responder app for Ambulance A1 (North Response Post).',
        ),
        (
          'patrol.one',
          'Sanjay Kumar',
          UserRole.responder,
          'Patrol Bike 1',
          '3304',
          'PAT-1',
          'Responder app for Patrol Bike 1.',
        ),
        (
          'fire.one',
          'Farah Khan',
          UserRole.responder,
          'Fire & safety lead',
          '3305',
          'FIRE-1',
          'Responder app for the Fire & Safety Unit.',
        ),
        (
          'ops.admin',
          'Neha Kapoor',
          UserRole.admin,
          'Operations & IT administrator',
          '9090',
          null,
          'Readiness Lab, digital twin, policies, audit log.',
        ),
        (
          'student.aanya',
          'Aanya Verma',
          UserRole.member,
          'Student, Birch Hostel',
          '5501',
          null,
          'Campus member app: raise SOS, follow its status.',
        ),
        (
          'staff.rohan',
          'Rohan Iyer',
          UserRole.member,
          'Library staff',
          '5502',
          null,
          'Campus member app: raise SOS, follow its status.',
        ),
      ];

  // --------------------------------------------------------- stress tests

  static List<StressScenario> stressScenarios() => [
    StressScenario(
      code: 'ST-HOSTEL-0217',
      name: 'Person down at Birch Hostel, 02:17, compound failure',
      description:
          'The hero emergency while Ambulance A2 is on another '
          'job, the North Gate is unavailable and the adjacent corridor '
          'camera is degraded.',
      zoneCode: 'HB',
      eventType: EventType.personDown,
      hour: 2,
      failures: [
        StressFailure(kind: StressFailureKind.responderBusy, target: 'AMB-A2'),
        StressFailure(kind: StressFailureKind.gateClosed, target: 'G3'),
        StressFailure(
          kind: StressFailureKind.cameraDegraded,
          target: 'CAM-HB-B08',
        ),
      ],
      builtIn: true,
    ),
    StressScenario(
      code: 'ST-LAB-FIRE-OUT',
      name: 'Lab smoke while the fire unit is out',
      description:
          'Smoke in the Chemistry Labs at 14:00 while the Fire & '
          'Safety Unit is attending another call.',
      zoneCode: 'LAB',
      eventType: EventType.smoke,
      hour: 14,
      failures: [
        StressFailure(kind: StressFailureKind.responderBusy, target: 'FIRE-1'),
      ],
      builtIn: true,
    ),
    StressScenario(
      code: 'ST-CEDAR-BLIND',
      name: 'Night emergency in a camera blind spot',
      description:
          'Person down at Cedar Hostel at 23:00 with the lobby '
          'camera offline: detection depends on an SOS.',
      zoneCode: 'HC',
      eventType: EventType.personDown,
      hour: 23,
      failures: [
        StressFailure(
          kind: StressFailureKind.cameraOffline,
          target: 'CAM-HC-01',
        ),
      ],
      builtIn: true,
    ),
    StressScenario(
      code: 'ST-EASTGATE-ROAD',
      name: 'East Gate collision with South Avenue blocked',
      description:
          'Collision at the East Gate at 18:00 while South Avenue '
          '(east) is closed for works.',
      zoneCode: 'G2',
      eventType: EventType.vehicleCollision,
      hour: 18,
      failures: [
        StressFailure(kind: StressFailureKind.roadBlocked, target: 'R3'),
      ],
      builtIn: true,
    ),
  ];

  // ----------------------------------------------------- incident history

  /// Past incidents so analytics has data on first launch.
  static const history = <HistoricIncident>[
    HistoricIncident(
      1,
      2,
      40,
      EventType.personDown,
      'HB',
      Severity.p1,
      responders: ['DESK-HB', 'AMB-A2'],
      stages: [3, 6, 18, 12, 95, 20],
      outcome: 'Student fainted; treated at hospital and discharged',
    ),
    HistoricIncident(
      1,
      17,
      10,
      EventType.fall,
      'SPT',
      Severity.p2,
      stages: [4],
      dismissal: 'Negative evidence (person recovered): player resumed play',
    ),
    HistoricIncident(
      2,
      13,
      5,
      EventType.smoke,
      'LAB',
      Severity.p0,
      responders: ['FIRE-1', 'PAT-1'],
      stages: [4, 5, 2, 10, 160, 15],
      outcome: 'Fume hood filter smouldering; extinguished, lab ventilated',
    ),
    HistoricIncident(
      3,
      21,
      30,
      EventType.crowdSurge,
      'COM',
      Severity.p1,
      responders: ['PAT-1', 'AMB-A2'],
      stages: [6, 9, 30, 15, 120, 30],
      outcome: 'Exit flow restored; one minor injury treated on site',
    ),
    HistoricIncident(
      3,
      23,
      55,
      EventType.sosRequest,
      'HC',
      Severity.p1,
      source: SignalSource.sos,
      observability: Observability.blind,
      responders: ['DESK-HC', 'AMB-A1'],
      stages: [2, 3, 25, 18, 140, 25],
      outcome: 'Resident with high fever; transported to hospital',
    ),
    HistoricIncident(
      4,
      19,
      20,
      EventType.vehicleCollision,
      'G2',
      Severity.p1,
      responders: ['PAT-2', 'AMB-A2'],
      stages: [3, 3, 20, 14, 110, 20],
      outcome: 'Two-wheeler collision; rider treated for abrasions',
    ),
    HistoricIncident(
      5,
      15,
      45,
      EventType.restrictedEntry,
      'LAB',
      Severity.p2,
      responders: ['PAT-1'],
      stages: [3, 3, 40, 20, 150, 10],
      outcome: 'Visitor without induction escorted out',
    ),
    HistoricIncident(
      6,
      10,
      15,
      EventType.personDown,
      'LIB',
      Severity.p2,
      stages: [5, 8],
      dismissal: 'Operator review: person asleep on the reading-hall couch',
    ),
    HistoricIncident(
      7,
      3,
      5,
      EventType.prolongedImmobility,
      'HA',
      Severity.p1,
      observability: Observability.degraded,
      escalations: 1,
      responders: ['DESK-HA', 'AMB-A2'],
      stages: [4, 20, 35, 25, 105, 30],
      outcome: 'Resident unwell after missed meals; observed overnight',
    ),
    HistoricIncident(
      8,
      11,
      30,
      EventType.flooding,
      'ACD',
      Severity.p3,
      responders: ['FAC-1'],
      stages: [10, 2, 60, 60, 300, 60],
      outcome: 'Burst pipe isolated; corridor dried',
    ),
    HistoricIncident(
      9,
      20,
      50,
      EventType.sosRequest,
      'SPT',
      Severity.p2,
      source: SignalSource.sos,
      responders: ['PAT-2'],
      stages: [2, 3, 30, 20],
      outcome:
          'Caller reached by phone and walked to the hospital '
          '(arrival never verified)',
    ),
    HistoricIncident(
      10,
      1,
      20,
      EventType.personDown,
      'HD',
      Severity.p1,
      escalations: 1,
      responders: ['DESK-HD', 'AMB-A1'],
      stages: [3, 6, 15, 50, 160, 25],
      outcome:
          'Ambulance A2 missed acknowledgement; A1 re-dispatched. '
          'Resident treated',
    ),
    HistoricIncident(
      12,
      16,
      0,
      EventType.unattendedObject,
      'COM',
      Severity.p3,
      stages: [5, 2],
      dismissal: 'Negative evidence: owner returned for the bag',
    ),
    HistoricIncident(
      14,
      22,
      10,
      EventType.fall,
      'HB',
      Severity.p1,
      responders: ['DESK-HB', 'AMB-A2'],
      stages: [3, 5, 12, 9, 80, 18],
      outcome: 'Fall on stairs; ankle sprain treated',
    ),
  ];
}

/// Compact description of a past incident for seeding analytics.
class HistoricIncident {
  const HistoricIncident(
    this.daysAgo,
    this.hour,
    this.minute,
    this.eventType,
    this.zoneCode,
    this.severity, {
    this.source = SignalSource.camera,
    this.observability = Observability.full,
    this.escalations = 0,
    this.responders = const [],
    required this.stages,
    this.outcome,
    this.dismissal,
  });

  final int daysAgo;
  final int hour;
  final int minute;
  final EventType eventType;
  final String zoneCode;
  final Severity severity;
  final SignalSource source;
  final Observability observability;
  final int escalations;
  final List<String> responders;

  /// Seconds for detection, verification, dispatch, acknowledgement,
  /// arrival and care start. Shorter lists stop the lifecycle early.
  final List<int> stages;
  final String? outcome;
  final String? dismissal;
}
