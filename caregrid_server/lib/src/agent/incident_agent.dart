import 'dart:math';

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

  /// Producers may report events this late (clock skew, buffered edge
  /// gateways) or this far ahead; anything outside is rejected.
  static const maxLateness = Duration(hours: 24);
  static const maxClockSkew = Duration(seconds: 60);

  /// Ingests one signal into [campusId]'s pipeline. Zone and camera codes are
  /// resolved only inside that campus.
  ///
  /// [targetIncidentId] binds negative evidence to one known incident (a
  /// member withdrawing their own SOS) instead of searching the zone.
  static Future<SensorEvent> ingest(
    Session session,
    int campusId,
    SignalInput input, {
    int? scenarioRunId,
    int? reporterUserId,
    int? targetIncidentId,
  }) async {
    final now = CampusClock.now();
    final twin = await TwinSnapshot.load(session, campusId);
    final zone = twin.zone(input.zoneCode);
    if (zone == null) throw badRequest('Unknown zone ${input.zoneCode}.');
    final camera = input.cameraCode == null
        ? null
        : twin.cameras[input.cameraCode];
    if (input.cameraCode != null && camera == null) {
      throw badRequest('Unknown camera ${input.cameraCode}.');
    }
    if (input.confidence.isNaN ||
        input.confidence < 0 ||
        input.confidence > 1) {
      throw badRequest('Confidence must be between 0 and 1.');
    }
    final eventId = input.eventId?.trim();
    if (eventId != null && (eventId.isEmpty || eventId.length > 128)) {
      throw badRequest('Event ids are 1-128 characters.');
    }
    final observedAt = input.observedAt?.toUtc() ?? now;
    if (observedAt.isAfter(now.add(maxClockSkew)) ||
        observedAt.isBefore(now.subtract(maxLateness))) {
      throw badRequest(
        'observedAt must be within the last 24 hours and no more than '
        '60 seconds ahead of the server clock.',
      );
    }
    final lateBy = now.difference(observedAt);

    Future<SensorEvent?> duplicate() async => eventId == null
        ? null
        : SensorEvent.db.findFirstRow(
            session,
            where: (t) =>
                t.campusId.equals(campusId) &
                t.source.equals(input.source) &
                t.sourceEventId.equals(eventId),
          );

    final seen = await duplicate();
    if (seen != null) return seen;

    SensorEvent event;
    try {
      event = await SensorEvent.db.insertRow(
        session,
        SensorEvent(
          campusId: campusId,
          source: input.source,
          eventType: input.eventType,
          zoneCode: input.zoneCode,
          cameraCode: input.cameraCode,
          trackId: input.trackId,
          confidence: input.confidence,
          detail: input.detail,
          locationDetail: input.locationDetail,
          observedAt: observedAt,
          receivedAt: now,
          contextHour: input.contextHour,
          scenarioRunId: scenarioRunId,
          reporterUserId: reporterUserId,
          sourceEventId: eventId,
        ),
      );
    } on DatabaseException {
      // A concurrent retry of the same producer event won the unique index.
      final winner = await duplicate();
      if (winner != null) return winner;
      rethrow;
    }

    Future<SensorEvent> finish(String outcome, Incident? incident) async {
      event
        ..outcome = lateBy > const Duration(minutes: 2)
            ? '$outcome (reported ${formatSeconds(lateBy.inSeconds)} after '
                  'it was observed)'
            : outcome
        ..incidentId = incident?.id;
      event = await SensorEvent.db.updateRow(session, event);
      await OpsBus.publish(
        session,
        'signal',
        campusId: campusId,
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
      final (incident, outcome) = await _applyNegativeEvidence(
        session,
        campusId,
        input,
        scenarioRunId,
        targetIncidentId: targetIncidentId,
        reporterUserId: reporterUserId,
      );
      return finish(outcome, incident);
    }

    final family = PolicyEngine.familyOf(input.eventType);
    final confidence = camera?.health == AssetHealth.degraded
        ? input.confidence * 0.85
        : input.confidence;

    final (existing, keptSeparate) = await _findFusionTarget(
      session,
      campusId,
      input,
      family,
      scenarioRunId,
      reporterUserId,
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
      keptSeparateFrom: keptSeparate,
      observedAt: observedAt,
    );
    return finish(
      keptSeparate.isEmpty
          ? 'Created ${incident.code}.'
          : 'Created ${incident.code}; kept separate from '
                '${keptSeparate.map((i) => i.code).join(', ')} '
                '(different reporter and location).',
      incident,
    );
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
    List<Incident> keptSeparateFrom = const [],
    DateTime? observedAt,
  }) async {
    final now = CampusClock.now();
    final hour =
        input.contextHour ??
        CampusClock.localHourAt(
          observedAt ?? now,
          twin.campus.utcOffsetMinutes,
        );
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
      if (keptSeparateFrom.isNotEmpty)
        'Another open request in ${zone.name} '
            '(${keptSeparateFrom.map((i) => i.code).join(', ')}) came from a '
            'different reporter and location. Kept separate so neither person '
            'is hidden; command can coordinate both.',
    ];

    var incident = await Incident.db.insertRow(
      session,
      Incident(
        campusId: twin.campusId,
        code: _provisionalCode(),
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
        onsetAt: observedAt ?? now,
        detectedAt: now,
        updatedAt: now,
      ),
    );
    incident = await _assignCode(session, incident, twin.campus);
    final code = incident.code;
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
  ///
  /// Member SOS requests are people, not pixels: two members asking for help
  /// in the same building are only merged when the request is evidently the
  /// same one. Returns the fusion target (if any) and the open requests the
  /// signal was deliberately kept apart from.
  static Future<(Incident?, List<Incident>)> _findFusionTarget(
    Session session,
    int campusId,
    SignalInput input,
    EventFamily family,
    int? scenarioRunId,
    int? reporterUserId,
  ) async {
    final since = CampusClock.now().subtract(fusionWindow);
    final candidates = await Incident.db.find(
      session,
      where: (t) =>
          t.campusId.equals(campusId) &
          t.zoneCode.equals(input.zoneCode) &
          (t.onsetAt > since) &
          t.parentIncidentId.equals(null) &
          t.scenarioRunId.equals(scenarioRunId),
      orderBy: (t) => t.onsetAt.desc(),
    );
    final separate = <Incident>[];
    for (final c in candidates.where((c) => c.state.open)) {
      // A person down at a collision or crowd surge belongs to that incident.
      final related =
          c.family == family ||
          (family == EventFamily.medical &&
              (c.family == EventFamily.mobility ||
                  c.family == EventFamily.crowd));
      if (!related) continue;
      if (input.source == SignalSource.sos &&
          !await _sosMayJoin(session, c, input, reporterUserId)) {
        separate.add(c);
        continue;
      }
      return (c, const <Incident>[]);
    }
    return (null, separate);
  }

  /// A member SOS joins an open incident only when it is evidently the same
  /// request: the same member pressing again, the same stated location as
  /// another member's request, or a camera/sensor detection with no stated
  /// location that it can corroborate.
  static Future<bool> _sosMayJoin(
    Session session,
    Incident candidate,
    SignalInput input,
    int? reporterUserId,
  ) async {
    if (reporterUserId != null) {
      final sameReporter = await SensorEvent.db.count(
        session,
        where: (t) =>
            t.incidentId.equals(candidate.id) &
            t.reporterUserId.equals(reporterUserId),
      );
      if (sameReporter > 0) return true;
    }
    final mine = normalizeLocation(input.locationDetail);
    final theirs = normalizeLocation(candidate.locationDetail);
    if (candidate.reporterUserId != null) {
      // Another member's request: same stated place, or keep both visible.
      return mine.isNotEmpty && mine == theirs;
    }
    // A detection without a stated location: the SOS corroborates it unless
    // the member names a different place than the incident already records.
    return mine.isEmpty || theirs.isEmpty || mine == theirs;
  }

  /// Lower-case, punctuation-free, single-spaced location text.
  static String normalizeLocation(String? text) =>
      (text ?? '').toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();

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
    var victim = await Incident.db.insertRow(
      session,
      Incident(
        campusId: parent.campusId,
        code: _provisionalCode(),
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
    victim = await _assignCode(session, victim, twin.campus);
    final code = victim.code;
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

  /// The agent actively looks for evidence against an emergency, but acts
  /// only on evidence that clearly refers to the incident: a matching
  /// anonymous track, a reporter withdrawing a request only they made, or the
  /// single untracked hazard in the zone. Before dispatch, decisive evidence
  /// dismisses with a reason and ambiguous evidence goes to a human. After
  /// dispatch it only informs: humans own escalation and closure.
  static Future<(Incident?, String)> _applyNegativeEvidence(
    Session session,
    int campusId,
    SignalInput input,
    int? scenarioRunId, {
    int? targetIncidentId,
    int? reporterUserId,
  }) async {
    Incident incident;
    var decisive = false;
    String? ambiguity;

    if (targetIncidentId != null) {
      final target = await Incident.db.findById(session, targetIncidentId);
      if (target == null || target.campusId != campusId || !target.state.open) {
        return (null, 'No open incident to update.');
      }
      incident = target;
      if (input.eventType == EventType.reporterCancelled) {
        decisive = await _onlyReporter(session, target, reporterUserId);
        if (!decisive) {
          ambiguity =
              'Other sources still support ${target.code}: the withdrawal is '
              'recorded but cannot stand the incident down on its own.';
        }
      } else {
        decisive = true;
      }
    } else {
      final family = PolicyEngine.familyOf(input.eventType);
      final candidates = (await Incident.db.find(
        session,
        where: (t) =>
            t.campusId.equals(campusId) &
            t.zoneCode.equals(input.zoneCode) &
            t.family.equals(family) &
            t.scenarioRunId.equals(scenarioRunId) &
            (t.onsetAt > CampusClock.now().subtract(fusionWindow)),
        orderBy: (t) => t.onsetAt.desc(),
      )).where((c) => c.state.open).toList();
      if (candidates.isEmpty) return (null, 'No open incident to update.');

      if (input.trackId != null) {
        // Evidence about one anonymous person only ever concerns that person.
        final matched = candidates
            .where((c) => c.trackId == input.trackId)
            .firstOrNull;
        if (matched == null) {
          return (
            null,
            'No open incident follows track ${input.trackId}: recorded only, '
                'no incident changed.',
          );
        }
        if (matched.parentIncidentId != null) {
          return _victimRecovered(session, matched, input);
        }
        incident = matched;
        decisive = true;
      } else {
        incident = candidates.first;
        decisive = candidates.length == 1 && incident.trackId == null;
        if (!decisive) {
          ambiguity = candidates.length > 1
              ? '${candidates.length} open incidents in this zone: evidence '
                    'without a track cannot be tied to one of them.'
              : '${incident.code} follows an anonymous person; evidence '
                    'without a track cannot confirm it is the same person.';
        }
      }
    }

    final line = _evidenceLine(input);
    incident.negativeEvidence = [...incident.negativeEvidence, line];
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.signal,
      input.source.label,
      'Negative evidence: $line',
      sensitive: input.source == SignalSource.camera,
    );

    if (incident.dispatchedAt != null) {
      await Orchestrator.log(
        session,
        incident,
        TimelineKind.agent,
        Orchestrator.agentName,
        'Units are already dispatched: they continue. A human decides closure.',
      );
      final saved = await Orchestrator.save(session, incident);
      return (saved, 'Negative evidence for ${saved.code}; units continue.');
    }
    if (decisive) {
      final dismissed = await Orchestrator.dismiss(
        session,
        incident,
        'Negative evidence (${input.eventType.label.toLowerCase()}): '
        '${input.detail ?? 'emergency no longer supported by evidence'}',
        Orchestrator.agentName,
      );
      return (dismissed, 'Negative evidence dismissed ${dismissed.code}.');
    }
    incident
      ..needsHumanReview = true
      ..nextAction = 'Conflicting evidence: review, then confirm or stand down';
    await Orchestrator.log(
      session,
      incident,
      TimelineKind.agent,
      Orchestrator.agentName,
      '$ambiguity Routed to human review; nothing was dismissed.',
    );
    final saved = await Orchestrator.save(session, incident);
    return (saved, 'Negative evidence for ${saved.code} needs human review.');
  }

  /// One victim of a multi-casualty incident recovering never stands the
  /// parent response down; it is recorded on both records.
  static Future<(Incident?, String)> _victimRecovered(
    Session session,
    Incident victim,
    SignalInput input,
  ) async {
    final line = _evidenceLine(input);
    victim.negativeEvidence = [...victim.negativeEvidence, line];
    await Orchestrator.log(
      session,
      victim,
      TimelineKind.signal,
      input.source.label,
      'Negative evidence: $line',
      sensitive: input.source == SignalSource.camera,
    );
    await Orchestrator.save(session, victim);
    final parent = await Orchestrator.load(session, victim.parentIncidentId!);
    await Orchestrator.log(
      session,
      parent,
      TimelineKind.agent,
      Orchestrator.agentName,
      '${victim.code}: $line. The response to ${parent.code} continues; '
      'command decides whether that person still needs care.',
    );
    final saved = await Orchestrator.save(session, parent);
    return (saved, 'Victim ${victim.code} update recorded on ${saved.code}.');
  }

  /// True when every supporting signal of [incident] is an SOS from
  /// [reporterUserId], so their withdrawal removes all positive evidence.
  static Future<bool> _onlyReporter(
    Session session,
    Incident incident,
    int? reporterUserId,
  ) async {
    if (reporterUserId == null) return false;
    final supporting = (await SensorEvent.db.find(
      session,
      where: (t) => t.incidentId.equals(incident.id),
    )).where((e) => !e.eventType.negative).toList();
    return supporting.isNotEmpty &&
        supporting.every(
          (e) =>
              e.source == SignalSource.sos &&
              e.reporterUserId == reporterUserId,
        );
  }

  static String _evidenceLine(SignalInput input) =>
      '${input.eventType.label}${input.cameraCode == null ? '' : ' on ${input.cameraCode}'}'
      '${input.detail == null ? '' : ': ${input.detail}'}';

  static final _random = Random.secure();

  /// Unique placeholder used only between insert and [_assignCode].
  static String _provisionalCode() =>
      'NEW-${DateTime.now().microsecondsSinceEpoch}-'
      '${_random.nextInt(1 << 32).toRadixString(16)}';

  /// Derives the public code from the database id and the campus prefix, so
  /// concurrent signals can never compute the same code.
  static Future<Incident> _assignCode(
    Session session,
    Incident incident,
    Campus campus,
  ) {
    incident.code = incidentCode(campus, incident.id!);
    return Incident.db.updateRow(session, incident);
  }

  static String incidentCode(Campus campus, int id) =>
      '${campus.incidentPrefix}-${1000 + id}';
}
