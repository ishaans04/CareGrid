import '../generated/protocol.dart';

/// One signal emitted [atSecond] seconds after a scenario starts.
class ScenarioStep {
  const ScenarioStep(this.atSecond, this.input);

  final int atSecond;
  final SignalInput input;
}

/// A seeded live scenario: real signals pushed through the real pipeline.
class ScenarioDefinition {
  const ScenarioDefinition({
    required this.code,
    required this.title,
    required this.description,
    required this.expected,
    required this.zoneCode,
    required this.steps,
    required this.demonstrates,
    this.faults = const [],
  });

  final String code;
  final String title;
  final String description;
  final String expected;
  final String zoneCode;
  final List<ScenarioStep> steps;
  final List<String> demonstrates;

  /// Autopilot faults, e.g. noAck:AMB-A2 (that crew never acknowledges).
  final List<String> faults;

  ScenarioInfo toInfo() => ScenarioInfo(
    code: code,
    title: title,
    description: description,
    expected: expected,
    zoneCode: zoneCode,
    steps: steps.length,
    faults: faults,
    demonstrates: demonstrates,
  );
}

/// Live scenarios for the Simulation Lab. Each campus has its own catalogue
/// (see `CampusSeed.scenarios`); this file holds the Meridian set and the
/// shared signal helper.
class ScenarioLibrary {
  ScenarioLibrary._();

  static ScenarioDefinition? find(
    List<ScenarioDefinition> catalogue,
    String code,
  ) {
    for (final s in catalogue) {
      if (s.code == code) return s;
    }
    return null;
  }

  static SignalInput cam(
    EventType type,
    String zone,
    String camera,
    double confidence, {
    String? track,
    String? detail,
    String? location,
    int? hour,
  }) => SignalInput(
    source: SignalSource.camera,
    eventType: type,
    zoneCode: zone,
    cameraCode: camera,
    trackId: track,
    confidence: confidence,
    detail: detail,
    locationDetail: location,
    contextHour: hour,
  );

  static final meridian = <ScenarioDefinition>[
    ScenarioDefinition(
      code: 'SC-HOSTEL-0217',
      title: '02:17, person down in Birch Hostel',
      description:
          'A resident collapses in a Block B corridor at night. '
          'Nobody is around to call for help.',
      expected:
          'Two camera angles corroborate, the agent applies the night '
          'hostel SOP (P1), pre-alerts the hospital and recommends the Birch '
          'desk + Ambulance A2. After confirmation both units are tracked '
          'through acknowledgement, movement, geofenced arrival and care.',
      zoneCode: 'HB',
      demonstrates: [
        'Corroboration',
        'Time-aware policy',
        'Human confirmation',
        'Proof-of-Response',
        'MTTC',
      ],
      steps: [
        ScenarioStep(
          0,
          cam(
            EventType.personDown,
            'HB',
            'CAM-HB-B07',
            0.86,
            track: 'T-41',
            detail:
                'Rapid downward motion; subject horizontal, no '
                'movement for 6 s',
            location: 'Block B, ground floor, corridor 2',
            hour: 2,
          ),
        ),
        ScenarioStep(
          2,
          cam(
            EventType.personDown,
            'HB',
            'CAM-HB-B08',
            0.91,
            track: 'T-41',
            detail: 'Adjacent angle: subject still on the floor (8 s)',
            location: 'Block B, ground floor, corridor 2',
            hour: 2,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'SC-SPORTS-RECOVER',
      title: 'Fall on the sports field, player recovers',
      description: 'A player goes down during an evening match and gets up.',
      expected:
          'Confidence is below the sports-field threshold, so the agent '
          'waits for corroboration. Negative evidence (player stands up) '
          'dismisses the incident with a reason. Nobody is dispatched.',
      zoneCode: 'SPT',
      demonstrates: ['Negative evidence', 'False-positive control'],
      steps: [
        ScenarioStep(
          0,
          cam(
            EventType.fall,
            'SPT',
            'CAM-SPT-01',
            0.82,
            track: 'T-7',
            detail: 'Player fell during a tackle',
            location: 'Football field, north half',
            hour: 17,
          ),
        ),
        ScenarioStep(
          5,
          cam(
            EventType.personRecovered,
            'SPT',
            'CAM-SPT-01',
            0.93,
            track: 'T-7',
            detail: 'Subject stood up and resumed play',
            hour: 17,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'SC-LAB-SMOKE',
      title: 'Smoke in the Chemistry Labs',
      description: 'A fume hood starts smouldering in the afternoon.',
      expected:
          'Camera + smoke detector corroborate. The lab hazard SOP is '
          'P0 with autonomous dispatch: the Fire & Safety Unit and a patrol '
          'are dispatched without waiting, and the hospital is pre-alerted.',
      zoneCode: 'LAB',
      demonstrates: ['Multi-modal fusion', 'Auto-dispatch for life safety'],
      steps: [
        ScenarioStep(
          0,
          cam(
            EventType.smoke,
            'LAB',
            'CAM-LAB-02',
            0.84,
            detail: 'Grey plume near fume hood bay 3',
            location: 'Ground floor, fume hood bay 3',
            hour: 14,
          ),
        ),
        ScenarioStep(
          3,
          SignalInput(
            source: SignalSource.iotSensor,
            eventType: EventType.smoke,
            zoneCode: 'LAB',
            confidence: 0.95,
            detail: 'Smoke detector SD-L2-04 triggered',
            locationDetail: 'Ground floor, fume hood bay 3',
            contextHour: 14,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'SC-SOS-LIBRARY',
      title: 'SOS from the Central Library',
      description: 'A staff member presses SOS: a visitor fainted.',
      expected:
          'A human report counts as a witness, so the incident is '
          'verified at once under the general medical SOP and waits for the '
          'operator to confirm a patrol + ambulance.',
      zoneCode: 'LIB',
      demonstrates: ['SOS channel', 'Human report as corroboration'],
      steps: [
        ScenarioStep(
          0,
          SignalInput(
            source: SignalSource.sos,
            eventType: EventType.sosRequest,
            zoneCode: 'LIB',
            confidence: 0.95,
            detail: 'Someone fainted near the reading hall; breathing',
            locationDetail: 'Reading hall, first floor',
            contextHour: 15,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'SC-EASTGATE-COLLISION',
      title: 'Collision at the East Gate',
      description: 'A two-wheeler and a car collide at the gate barrier.',
      expected:
          'The collision is verified under the road SOP. A rider on '
          'the ground joins the same incident as a linked victim, which '
          'raises the severity instead of creating a second alert.',
      zoneCode: 'G2',
      demonstrates: [
        'Mobility events',
        'Cross-family fusion',
        'Victim linking',
      ],
      steps: [
        ScenarioStep(
          0,
          cam(
            EventType.vehicleCollision,
            'G2',
            'CAM-G2-01',
            0.88,
            detail: 'Two-wheeler and car collided at the gate barrier',
            location: 'Inbound lane, East Gate barrier',
            hour: 19,
          ),
        ),
        ScenarioStep(
          2,
          cam(
            EventType.personDown,
            'G2',
            'CAM-G2-01',
            0.8,
            track: 'T-3',
            detail: 'Rider on the ground beside the vehicle',
            location: 'Inbound lane, East Gate barrier',
            hour: 19,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'SC-CROWD-VICTIMS',
      title: 'Crowd surge at the Student Commons',
      description:
          'An evening event exit becomes a pinch point; two people '
          'go down.',
      expected:
          'Two cameras corroborate dangerous density (P1). Two '
          'different anonymous tracks go down: one parent incident with two '
          'linked victim records, severity raised to P0.',
      zoneCode: 'COM',
      demonstrates: [
        'Crowd events',
        'Multiple victims',
        'No facial recognition',
      ],
      steps: [
        ScenarioStep(
          0,
          cam(
            EventType.crowdSurge,
            'COM',
            'CAM-COM-01',
            0.83,
            detail: 'Density 5.8 people/m2 at the east exit',
            location: 'Plaza east exit',
            hour: 21,
          ),
        ),
        ScenarioStep(
          2,
          cam(
            EventType.crowdSurge,
            'COM',
            'CAM-COM-02',
            0.86,
            detail: 'Counter-flow at the west exit',
            location: 'Plaza west exit',
            hour: 21,
          ),
        ),
        ScenarioStep(
          4,
          cam(
            EventType.personDown,
            'COM',
            'CAM-COM-01',
            0.82,
            track: 'T-11',
            detail: 'Person down in the crowd',
            location: 'Plaza east exit',
            hour: 21,
          ),
        ),
        ScenarioStep(
          6,
          cam(
            EventType.personDown,
            'COM',
            'CAM-COM-02',
            0.8,
            track: 'T-12',
            detail: 'Second person down near the west steps',
            location: 'Plaza west steps',
            hour: 21,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'SC-MISSED-ACK',
      title: 'Missed acknowledgement (Proof-of-Response)',
      description:
          'The 02:17 hostel emergency, but Ambulance A2 never '
          'acknowledges its radio call.',
      expected:
          'After the 30 s acknowledgement SLA the watchdog marks A2 '
          'unreachable, escalates, and re-dispatches Ambulance A1. The '
          'incident is never treated as handled just because an alert was '
          'sent.',
      zoneCode: 'HB',
      faults: ['noAck:AMB-A2'],
      demonstrates: ['Proof-of-Response', 'Escalation', 'Re-dispatch'],
      steps: [
        ScenarioStep(
          0,
          cam(
            EventType.personDown,
            'HB',
            'CAM-HB-B07',
            0.88,
            track: 'T-52',
            detail: 'Subject collapsed near the stairwell',
            location: 'Block B, ground floor, stairwell',
            hour: 2,
          ),
        ),
        ScenarioStep(
          2,
          cam(
            EventType.personDown,
            'HB',
            'CAM-HB-B08',
            0.9,
            track: 'T-52',
            detail: 'Adjacent angle confirms no movement',
            location: 'Block B, ground floor, stairwell',
            hour: 2,
          ),
        ),
      ],
    ),
    ScenarioDefinition(
      code: 'SC-CEDAR-BLIND',
      title: 'SOS from a camera blind spot',
      description:
          'A resident of Cedar Hostel raises SOS at 23:00 for an '
          'unresponsive roommate. The lobby camera is offline.',
      expected:
          'The agent proceeds on the human report, reports the zone as '
          'a blind spot instead of inventing certainty, and the night hostel '
          'SOP selects the Cedar desk + the nearest ambulance.',
      zoneCode: 'HC',
      demonstrates: ['Blind-spot transparency', 'SOS channel'],
      steps: [
        ScenarioStep(
          0,
          SignalInput(
            source: SignalSource.sos,
            eventType: EventType.sosRequest,
            zoneCode: 'HC',
            confidence: 0.95,
            detail: 'Roommate unresponsive, breathing slowly',
            locationDetail: 'Room 214, second floor',
            contextHour: 23,
          ),
        ),
      ],
    ),
  ];
}
