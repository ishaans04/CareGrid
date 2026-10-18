import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../core/clock.dart';
import '../core/ops_bus.dart';
import '../generated/protocol.dart';
import '../response/orchestrator.dart';
import '../twin/twin_snapshot.dart';
import 'policy_engine.dart';

/// Turns every meaningful signal into an owned incident. The agent fuses
/// signals, applies zone policy, looks for corroborating and negative
/// evidence, and either verifies, asks for human review, or dismisses with a
/// reason. It is deterministic and explains every step in `reasoning`.
class IncidentAgent {
  IncidentAgent._();

  /// Signals for the same zone and family within this window join one incident.
  static const fusionWindow = Duration(minutes: 10);

  /// Seconds the agent waits for corroboration before asking a human.
  static const corroborationWindowSeconds = 20;

  /// Same-camera persistence that counts as temporal corroboration.
  static const persistenceSeconds = 8;

  static Future<SensorEvent> ingest(
    Session session,
    SignalInput input, {
    int? scenarioRunId,
    int? reporterUserId,
  }) async {
    final now = CampusClock.now();
    final twin = await TwinSnapshot.load(session);
    final zone = twin.zone(input.zoneCode);
    if (zone == null) throw badRequest('Unknown zone ${input.zoneCode}.');
    final camera = input.cameraCode == null
        ? null
        : twin.cameras[input.cameraCode];

    var event = await SensorEvent.db.insertRow(
      session,
      SensorEvent(
        source: input.source,
        eventType: input.eventType,
        zoneCode: input.zoneCode,
        cameraCode: input.cameraCode,
        trackId: input.trackId,
        confidence: input.confidence,
        detail: input.detail,
        locationDetail: input.locationDetail,
        observedAt: now,
        receivedAt: now,
        contextHour: input.contextHour,
        scenarioRunId: scenarioRunId,
        reporterUserId: reporterUserId,
      ),
    );

    Future<SensorEvent> finish(String outcome, Incident? incident) async {
      event
        ..outcome = outcome
        ..incidentId = incident?.id;
      event = await SensorEvent.db.updateRow(session, event);
      await OpsBus.publish(
        session,
        'signal',
        incidentId: incident?.id,
        message: outcome,
      );
      return event;
    }

    if (camera != null && camera.health == AssetHealth.offline) {
      return finish(
        'Suppressed: ${camera.code} is offline, its output is not trusted. '
        'Coverage of ${zone.name} reported as degraded.',
        null,
      );
    }

    if (input.eventType.negative) {
      final incident = await _applyNegativeEvidence(
        session,
        input,
        scenarioRunId,
      );
      return finish(
        incident == null
            ? 'No open incident to update.'
            : 'Negative evidence for ${incident.code}.',
        incident,
      );
    }

    final family = PolicyEngine.familyOf(input.eventType);
    final confidence = camera?.health == AssetHealth.degraded
        ? input.confidence * 0.85
        : input.confidence;

    final existing = await _findFusionTarget(
      session,
      input,
      family,
      scenarioRunId,
    );
    if (existing != null) {
      final incident = await _fuse(
        session,
        twin,
        existing,
        input,
        confidence,
        scenarioRunId: scenarioRunId,
        reporterUserId: reporterUserId,
      );
      return finish(
        incident.id == existing.id
            ? 'Joined ${existing.code} as corroborating evidence.'
            : 'Linked victim record ${incident.code} to ${existing.code}.',
        incident,
      );
    }

    final incident = await _create(
      session,
      twin,
      zone,
      camera,
      input,
      family,
      confidence,
      scenarioRunId: scenarioRunId,
      reporterUserId: reporterUserId,
    );
    return finish('Created ${incident.code}.', incident);
  }

  // ----------------------------------------------------------------- create

  static Future<Incident> _create(
    Session session,
    TwinSnapshot twin,
    Zone zone,
    Camera? camera,
    SignalInput input,
    EventFamily family,
    double confidence, {
    int? scenarioRunId,
    int? reporterUserId,
    int? parentIncidentId,
  }) async {
    final now = CampusClock.now();
    final hour = input.contextHour ?? CampusClock.localHour(now);
    final policy = PolicyEngine.select(twin.policies, zone.type, family, hour);
    final observability = twin.observabilityOf(zone.code);
    final humanReport =
        input.source == SignalSource.sos ||
        input.source == SignalSource.operatorReport;

    final reasoning = <String>[
      '${input.source.label} reported ${input.eventType.label.toLowerCase()} '
          'in ${zone.name} (${zone.type.label.toLowerCase()}) at local '
          '${PolicyEngine.hourLabel(hour)}'
          '${camera == null ? '' : ' on ${camera.code}'}, '
          'confidence ${(confidence * 100).round()}%.',
      if (input.detail != null) 'Observation: ${input.detail}.',
      if (camera?.health == AssetHealth.degraded)
        '${camera!.code} is degraded: confidence discounted 15%.',
      policy == null
          ? 'No policy matches this zone, event and hour: human review needed.'
          : 'Policy ${policy.code} "${policy.name}" applies: '
                '${policy.severity.label}, verify at '
                '${(policy.minConfidence * 100).round()}% confidence'
                '${policy.requireCorroboration ? ' with corroboration' : ''}.',
      if (observability != Observability.full)
        'Observability: ${observability.label.toLowerCase()}. '
            'The agent will not assume continuity it cannot see.',
      if (humanReport)
        'Human report counts as a witness: corroboration satisfied.',
    ];

    final code = await _nextCode(session);
    var incident = await Incident.db.insertRow(
      session,
      Incident(
        code: code,
        title: '${input.eventType.label} at ${zone.name}',
        eventType: input.eventType,
        family: family,
        severity: policy?.severity ?? Severity.p2,
        state: IncidentState.detected,
        zoneCode: zone.code,
        locationDetail: input.locationDetail,
        primaryCameraCode: input.cameraCode,
        trackId: input.trackId,
        source: input.source,
        confidence: confidence,
        corroborated: humanReport,
        observability: observability,
        consequence: PolicyEngine.consequenceFor(input.eventType),
        policyCode: policy?.code,
        reasoning: reasoning,
        negativeEvidence: [],
        parentIncidentId: parentIncidentId,
        reporterUserId: reporterUserId,
        scenarioRunId: scenarioRunId,
        contextHour: input.contextHour,
        onsetAt: now,
        detectedAt: now,
        updatedAt: now,
      ),
    );
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.signal,
      input.source.label,
      '${input.eventType.label}${input.cameraCode == null ? '' : ' on ${input.cameraCode}'}'
      '${input.detail == null ? '' : ': ${input.detail}'}',
      sensitive: input.source == SignalSource.camera,
    );
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.agent,
      Orchestrator.agentName,
      'Opened $code. ${reasoning.length > 2 ? reasoning[2] : reasoning.last}',
    );
    return _evaluate(session, incident, policy);
  }

  /// Verify, wait for corroboration, or ask for human review.
  static Future<Incident> _evaluate(
    Session session,
    Incident incident,
    ZonePolicy? policy,
  ) async {
    if (policy == null) {
      incident
        ..state = IncidentState.review
        ..needsHumanReview = true
        ..nextAction = 'No policy matched: review evidence';
      return Orchestrator.save(session, incident);
    }
    final confident = incident.confidence >= policy.minConfidence;
    final corroborated = incident.corroborated || !policy.requireCorroboration;

    if (confident && corroborated) {
      return Orchestrator.verify(
        session,
        incident,
        policy,
        '${(incident.confidence * 100).round()}% confidence'
        '${incident.corroborated ? ', corroborated' : ''}; '
        '${incident.consequence.toLowerCase()}.',
      );
    }
    if (!confident && incident.confidence < policy.minConfidence * 0.7) {
      incident
        ..state = IncidentState.review
        ..needsHumanReview = true
        ..nextAction =
            'Low confidence: review evidence, then confirm or dismiss'
        ..nextDeadline = CampusClock.now().add(
          Duration(seconds: policy.verifySlaSeconds),
        )
        ..nextDeadlineLabel = 'Human review';
      await Orchestrator.log(
        session,
        incident,
        TimelineKind.agent,
        Orchestrator.agentName,
        'Confidence below the review threshold: routed to human review.',
      );
      return Orchestrator.save(session, incident);
    }
    incident
      ..state = IncidentState.detected
      ..nextAction = confident
          ? 'Awaiting corroboration (adjacent camera, sensor or persistence)'
          : 'Awaiting more evidence before verification'
      ..nextDeadline = CampusClock.now().add(
        const Duration(seconds: corroborationWindowSeconds),
      )
      ..nextDeadlineLabel = 'Corroboration window';
    return Orchestrator.save(session, incident);
  }

  // ------------------------------------------------------------------- fuse

  /// Scenario signals only fuse within their own run, so repeated demos never
  /// contaminate each other or real incidents.
  static Future<Incident?> _findFusionTarget(
    Session session,
    SignalInput input,
    EventFamily family,
    int? scenarioRunId,
  ) async {
    final since = CampusClock.now().subtract(fusionWindow);
    final candidates = await Incident.db.find(
      session,
      where: (t) =>
          t.zoneCode.equals(input.zoneCode) &
          (t.onsetAt > since) &
          t.parentIncidentId.equals(null) &
          t.scenarioRunId.equals(scenarioRunId),
      orderBy: (t) => t.onsetAt.desc(),
    );
    for (final c in candidates.where((c) => c.state.open)) {
      if (c.family == family) return c;
      // A person down at a collision or crowd surge belongs to that incident.
      final related =
          family == EventFamily.medical &&
          (c.family == EventFamily.mobility || c.family == EventFamily.crowd);
      if (related) return c;
    }
    return null;
  }

  static Future<Incident> _fuse(
    Session session,
    TwinSnapshot twin,
    Incident incident,
    SignalInput input,
    double confidence, {
    int? scenarioRunId,
    int? reporterUserId,
  }) async {
    final personEvent = PolicyEngine.isPersonEvent(input.eventType);
    final crossFamily =
        PolicyEngine.familyOf(input.eventType) != incident.family;

    // Different anonymous track = another person: a victim sub-record.
    final otherPerson =
        personEvent &&
        input.trackId != null &&
        incident.trackId != null &&
        input.trackId != incident.trackId;
    final firstVictim = personEvent && crossFamily && incident.trackId == null;
    if (otherPerson || firstVictim) {
      return _linkVictim(
        session,
        twin,
        incident,
        input,
        confidence,
        scenarioRunId: scenarioRunId,
        reporterUserId: reporterUserId,
      );
    }

    final adjacent =
        incident.primaryCameraCode != null &&
        input.cameraCode != null &&
        input.cameraCode != incident.primaryCameraCode &&
        (twin.cameras[incident.primaryCameraCode]?.adjacentCameras.contains(
              input.cameraCode,
            ) ??
            false);
    final otherSource = input.source != incident.source;
    final persisted =
        input.cameraCode != null &&
        input.cameraCode == incident.primaryCameraCode &&
        CampusClock.now().difference(incident.onsetAt).inSeconds >=
            persistenceSeconds;
    final corroborates = adjacent || otherSource || persisted;

    final why = adjacent
        ? 'adjacent camera ${input.cameraCode}'
        : otherSource
        ? 'independent ${input.source.label.toLowerCase()} signal'
        : persisted
        ? 'temporal persistence on ${input.cameraCode}'
        : 'same source, no independent confirmation';

    incident
      ..confidence = confidence > incident.confidence
          ? confidence
          : incident.confidence
      ..corroborated = incident.corroborated || corroborates
      ..reasoning = [
        ...incident.reasoning,
        'Corroboration from $why '
            '(${(confidence * 100).round()}%)'
            '${input.detail == null ? '' : ': ${input.detail}'}.',
      ];
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.signal,
      input.source.label,
      '${input.eventType.label}${input.cameraCode == null ? '' : ' on ${input.cameraCode}'}: '
      '${corroborates ? 'corroborates' : 'adds to'} ${incident.code} ($why).',
      sensitive: input.source == SignalSource.camera,
    );

    if (incident.state == IncidentState.detected ||
        incident.state == IncidentState.review) {
      final policy = await Orchestrator.policyOf(session, incident);
      return _evaluate(session, incident, policy);
    }
    return Orchestrator.save(session, incident);
  }

  /// Multi-victim events become one parent incident with linked victim
  /// sub-records, so one emergency never fragments into disconnected alerts.
  static Future<Incident> _linkVictim(
    Session session,
    TwinSnapshot twin,
    Incident parent,
    SignalInput input,
    double confidence, {
    int? scenarioRunId,
    int? reporterUserId,
  }) async {
    final zone = twin.zone(input.zoneCode)!;
    final now = CampusClock.now();
    final victims = await Incident.db.count(
      session,
      where: (t) => t.parentIncidentId.equals(parent.id),
    );
    final code = await _nextCode(session);
    final victim = await Incident.db.insertRow(
      session,
      Incident(
        code: code,
        title: 'Victim ${victims + 1} of ${parent.code}',
        eventType: input.eventType,
        family: EventFamily.medical,
        severity: parent.severity,
        state: parent.state.stage >= IncidentState.verified.stage
            ? IncidentState.verified
            : IncidentState.detected,
        zoneCode: zone.code,
        locationDetail: input.locationDetail ?? parent.locationDetail,
        primaryCameraCode: input.cameraCode,
        trackId: input.trackId,
        source: input.source,
        confidence: confidence,
        corroborated: true,
        observability: parent.observability,
        consequence: PolicyEngine.consequenceFor(input.eventType),
        policyCode: parent.policyCode,
        reasoning: [
          'Anonymous track ${input.trackId ?? 'n/a'} is a different person '
              'from ${parent.code}: recorded as a linked victim, not a new alert.',
        ],
        negativeEvidence: [],
        parentIncidentId: parent.id,
        reporterUserId: reporterUserId,
        scenarioRunId: scenarioRunId,
        contextHour: input.contextHour,
        onsetAt: now,
        detectedAt: now,
        verifiedAt: now,
        updatedAt: now,
      ),
    );
    await Orchestrator.log(
      session,
      victim,
      TimelineKind.agent,
      Orchestrator.agentName,
      'Victim record linked to ${parent.code}.',
    );

    final bumped = victims + 1 >= 2 || parent.family != EventFamily.medical;
    final oldSeverity = parent.severity;
    if (bumped) parent.severity = PolicyEngine.escalate(parent.severity);
    parent
      ..consequence = parent.family == EventFamily.medical
          ? 'Multiple casualties'
          : '${PolicyEngine.consequenceFor(parent.eventType)} with injured person(s)'
      ..title =
          '${parent.eventType.label} at ${zone.name} '
          '(${victims + 1} victim${victims + 1 == 1 ? '' : 's'})'
      ..reasoning = [
        ...parent.reasoning,
        'Victim ${victims + 1} detected (${input.eventType.label.toLowerCase()}, '
            'track ${input.trackId ?? 'n/a'}): linked as $code.',
        if (bumped && oldSeverity != parent.severity)
          'Severity raised ${oldSeverity.label} > ${parent.severity.label} '
              'because people are hurt.',
      ];
    await Orchestrator.log(
      session,
      parent,
      TimelineKind.agent,
      Orchestrator.agentName,
      'Victim ${victims + 1} linked ($code). ${parent.consequence}.',
    );

    // Make sure an ambulance is part of the response.
    final dispatches = await Orchestrator.dispatchesOf(session, parent.id!);
    final hasAmbulance = dispatches.any(
      (d) => d.status.active && d.responderType == ResponderType.ambulance,
    );
    if (!hasAmbulance && parent.dispatchedAt != null) {
      parent.nextAction = 'Add an ambulance: casualties confirmed';
    }
    if (!parent.hospitalNotified) {
      parent.hospitalNotified = true;
      await Orchestrator.log(
        session,
        parent,
        TimelineKind.care,
        'Orchestrator',
        'Hospital pre-alerted: casualties at ${zone.name}.',
      );
    }
    await Orchestrator.save(session, parent);
    return victim;
  }

  // -------------------------------------------------------- negative evidence

  /// The agent actively looks for evidence against an emergency. Before
  /// dispatch it may dismiss with a reason; after dispatch it only informs:
  /// humans own escalation and closure.
  static Future<Incident?> _applyNegativeEvidence(
    Session session,
    SignalInput input,
    int? scenarioRunId,
  ) async {
    final family = PolicyEngine.familyOf(input.eventType);
    final candidates = await Incident.db.find(
      session,
      where: (t) =>
          t.zoneCode.equals(input.zoneCode) &
          t.family.equals(family) &
          t.scenarioRunId.equals(scenarioRunId) &
          (t.onsetAt > CampusClock.now().subtract(fusionWindow)),
      orderBy: (t) => t.onsetAt.desc(),
    );
    final open = candidates.where((c) => c.state.open).toList();
    if (open.isEmpty) return null;
    final incident = input.trackId == null
        ? open.first
        : open.firstWhere(
            (c) => c.trackId == input.trackId,
            orElse: () => open.first,
          );

    final line =
        '${input.eventType.label}${input.cameraCode == null ? '' : ' on ${input.cameraCode}'}'
        '${input.detail == null ? '' : ': ${input.detail}'}';
    incident.negativeEvidence = [...incident.negativeEvidence, line];
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.signal,
      input.source.label,
      'Negative evidence: $line',
      sensitive: input.source == SignalSource.camera,
    );

    if (incident.dispatchedAt == null) {
      return Orchestrator.dismiss(
        session,
        incident,
        'Negative evidence (${input.eventType.label.toLowerCase()}): '
        '${input.detail ?? 'emergency no longer supported by evidence'}',
        Orchestrator.agentName,
      );
    }
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.agent,
      Orchestrator.agentName,
      'Units are already dispatched: they continue. A human decides closure.',
    );
    return Orchestrator.save(session, incident);
  }

  static Future<String> _nextCode(Session session) async {
    final last = await Incident.db.findFirstRow(
      session,
      orderBy: (t) => t.id.desc(),
    );
    return 'INC-${1001 + (last?.id ?? 0)}';
  }
}
