import '../agent/policy_engine.dart';
import '../core/clock.dart';
import '../generated/protocol.dart';
import '../response/response_planner.dart';
import '../twin/campus_graph.dart';
import '../twin/twin_snapshot.dart';

/// Stress-Test Engine: rehearses an emergency plus compound failures on a
/// private copy of the digital twin, predicts every response stage, and, when
/// the response misses its SLA, searches for fixes and re-runs with them.
/// Pure computation: the live twin is never touched.
class StressTestEngine {
  StressTestEngine(this.live);

  final TwinSnapshot live;

  /// Where a re-staged ambulance waits: the campus's own hospital or health
  /// centre (first by code, for determinism). Null skips ambulance re-staging.
  static String? ambulanceHubOf(TwinSnapshot twin) {
    final hubs =
        twin.zones.values.where((z) => z.type == ZoneType.hospital).toList()
          ..sort((a, b) => a.code.compareTo(b.code));
    return hubs.firstOrNull?.code;
  }

  /// Where other re-staged units wait: the junction with the shortest total
  /// road distance to every building on campus (its graph centre). Derived
  /// from each campus's own road network rather than a hard-coded code.
  static String? centralStandbyOf(TwinSnapshot twin) {
    const notBuildings = {ZoneType.junction, ZoneType.gate, ZoneType.outside};
    final buildings = twin.zones.values
        .where((z) => !notBuildings.contains(z.type))
        .map((z) => z.code)
        .toList();
    final junctions =
        twin.zones.values.where((z) => z.type == ZoneType.junction).toList()
          ..sort((a, b) => a.code.compareTo(b.code));
    final graph = CampusGraph(twin);
    String? best;
    var bestTotal = double.infinity;
    for (final j in junctions) {
      var total = 0.0;
      for (final b in buildings) {
        final route = graph.route(j.code, b);
        total += route.found ? route.meters : 1e6;
      }
      if (total < bestTotal) {
        bestTotal = total;
        best = j.code;
      }
    }
    return best;
  }

  StressTestRun run(StressScenario scenario, String ranBy) {
    final failed = _withFailures(live, scenario.failures);
    final base = _simulate(failed, scenario);

    final fixes = <StressFix>[];
    StressPrediction? fixed;
    final findings = [...base.findings];

    if (!base.pass) {
      final candidates = _fixCandidates(failed, scenario, base);
      var combined = failed;
      for (final fix in candidates) {
        final alone = _simulate(_applyFix(failed, fix.code), scenario);
        fix.passesAlone = alone.pass;
        // Only report fixes that actually improve the response: it passes,
        // arrives sooner, has fewer late types, or reaches a responder type
        // that could not be reached at all before (a route where none
        // existed is an improvement even if it is still late).
        if (alone.pass ||
            alone.worstArrival < base.worstArrival ||
            alone.lateTypes.length < base.lateTypes.length ||
            alone.uncoveredTypes.length < base.uncoveredTypes.length) {
          fixes.add(fix);
        }
      }
      // Apply fixes in order of benefit until the scenario passes.
      fixes.sort((a, b) => (b.passesAlone ? 1 : 0) - (a.passesAlone ? 1 : 0));
      for (final fix in fixes) {
        combined = _applyFix(combined, fix.code);
        fixed = _simulate(combined, scenario);
        if (fixed.pass) break;
      }
    }

    return StressTestRun(
      campusId: live.campusId,
      scenarioCode: scenario.code,
      scenarioName: scenario.name,
      ranAt: CampusClock.now(),
      ranBy: ranBy,
      verdict: base.pass ? Verdict.pass : Verdict.fail,
      predictedSeconds: base.worstArrival,
      slaSeconds: base.slaSeconds,
      policyCode: base.policyCode,
      stages: base.stages,
      responderPlan: base.plan,
      findings: findings,
      fixes: fixes,
      verdictAfterFix: fixed == null
          ? null
          : (fixed.pass ? Verdict.pass : Verdict.fail),
      predictedAfterFixSeconds: fixed?.worstArrival,
      planAfterFix: fixed?.plan ?? [],
    );
  }

  // --------------------------------------------------------------- failures

  static TwinSnapshot _withFailures(
    TwinSnapshot live,
    List<StressFailure> failures,
  ) {
    final twin = live.copy();
    for (final f in failures) {
      switch (f.kind) {
        case StressFailureKind.responderBusy:
          twin.responders[f.target]?.status = ResponderStatus.busy;
        case StressFailureKind.gateClosed:
          twin.zones[f.target]
            ?..isOpen = false
            ..emergencyOverride = false;
        case StressFailureKind.roadBlocked:
          for (final r in twin.roads.where((r) => r.code == f.target)) {
            r.status = RoadStatus.blocked;
          }
        case StressFailureKind.cameraDegraded:
          twin.cameras[f.target]?.health = AssetHealth.degraded;
        case StressFailureKind.cameraOffline:
          twin.cameras[f.target]?.health = AssetHealth.offline;
      }
    }
    return twin;
  }

  // ------------------------------------------------------------- simulation

  StressPrediction _simulate(TwinSnapshot twin, StressScenario sc) {
    final zone = twin.zone(sc.zoneCode)!;
    final family = PolicyEngine.familyOf(sc.eventType);
    final policy = PolicyEngine.select(
      twin.policies,
      zone.type,
      family,
      sc.hour,
    );
    final findings = <String>[];
    if (policy == null) {
      return StressPrediction(
        pass: false,
        worstArrival: 0,
        slaSeconds: 0,
        policyCode: null,
        stages: [],
        plan: [],
        findings: [
          'No policy covers ${sc.eventType.label} in ${zone.name} '
              'at ${PolicyEngine.hourLabel(sc.hour)}.',
        ],
      );
    }

    // Detection and verification depend on sensor coverage.
    final cams = twin.camerasIn(zone.code);
    final online = cams.where((c) => c.health == AssetHealth.online).toList();
    final degraded = cams
        .where((c) => c.health == AssetHealth.degraded)
        .toList();
    double detection;
    double verification;
    if (online.isNotEmpty) {
      detection = 4;
      final primary = online.first;
      final adjacentOnline = primary.adjacentCameras.any(
        (code) => twin.cameras[code]?.health == AssetHealth.online,
      );
      if (adjacentOnline) {
        verification = 5;
      } else {
        verification = 20;
        final weak = primary.adjacentCameras
            .where((c) => twin.cameras[c]?.health != AssetHealth.online)
            .join(', ');
        findings.add(
          'Corroboration camera ${weak.isEmpty ? '(none)' : weak} unavailable: '
          'verification falls back to temporal persistence (+15s).',
        );
      }
    } else if (degraded.isNotEmpty) {
      detection = 10;
      verification = 20;
      findings.add(
        'Only degraded cameras cover ${zone.name}: detection '
        'slows to ~10s and confidence drops.',
      );
    } else {
      detection = 90;
      verification = 10;
      findings.add(
        'Blind spot: no working camera covers ${zone.name}. '
        'Detection depends on an SOS or bystander report (~90s).',
      );
    }
    if (!policy.requireCorroboration) verification = 3;
    final confirmation = policy.autoDispatch ? 0.0 : 15.0;
    const dispatch = 3.0;
    const acknowledgement = 15.0;
    final pre =
        detection + verification + confirmation + dispatch + acknowledgement;

    final planner = ResponsePlanner(twin);
    final plan = planner.plan(
      zoneCode: zone.code,
      policy: policy,
      elapsedSeconds: pre.round(),
    );
    final lines = <String>[];
    final lateTypes = <ResponderType>{};
    var worst = 0;
    final missing = plan.warnings.any(
      (w) => w.startsWith('No available unit can cover'),
    );
    for (final w in plan.warnings.where((w) => w.startsWith('No '))) {
      findings.add(w);
    }
    for (final o in plan.options) {
      final arrival = pre.round() + o.etaSeconds;
      worst = arrival > worst ? arrival : worst;
      lines.add(
        '${o.responderName} (${o.responderType.label}): '
        '${o.routeNames.join(' > ')}, ETA ${formatSeconds(o.etaSeconds)}, '
        'on scene at +${formatSeconds(arrival)}',
      );
      if (arrival > policy.arrivalSlaSeconds) {
        lateTypes.add(o.responderType);
        findings.add(
          '${o.responderName} reaches ${zone.name} at '
          '+${formatSeconds(arrival)}: misses the '
          '${formatSeconds(policy.arrivalSlaSeconds)} SLA.',
        );
      }
    }
    final uncoveredTypes = <ResponderType>{};
    if (missing) {
      for (final type in policy.responderTypes) {
        if (!plan.options.any((o) => o.responderType == type)) {
          lateTypes.add(type);
          uncoveredTypes.add(type);
        }
      }
    }
    final pass = !missing && worst <= policy.arrivalSlaSeconds;
    if (!pass && !missing) {
      findings.insert(
        0,
        'No complete response reaches ${zone.name} in time '
        '(predicted +${formatSeconds(worst)} vs SLA '
        '${formatSeconds(policy.arrivalSlaSeconds)}).',
      );
    }

    return StressPrediction(
      pass: pass,
      worstArrival: worst,
      slaSeconds: policy.arrivalSlaSeconds,
      policyCode: policy.code,
      stages: [
        StageEstimate(label: 'Detection', seconds: detection),
        StageEstimate(label: 'Verification', seconds: verification),
        StageEstimate(
          label: 'Operator confirmation',
          seconds: confirmation,
          note: policy.autoDispatch ? 'Auto-dispatch SOP' : null,
        ),
        StageEstimate(label: 'Dispatch', seconds: dispatch),
        StageEstimate(label: 'Acknowledgement', seconds: acknowledgement),
        StageEstimate(
          label: 'Travel (slowest unit)',
          seconds: (worst - pre).clamp(0, 99999).toDouble(),
        ),
      ],
      plan: lines,
      findings: findings,
      lateTypes: lateTypes,
      uncoveredTypes: uncoveredTypes,
    );
  }

  // ------------------------------------------------------------------ fixes

  List<StressFix> _fixCandidates(
    TwinSnapshot failed,
    StressScenario sc,
    StressPrediction base,
  ) {
    final failedTargets = sc.failures.map((f) => f.target).toSet();
    final fixes = <StressFix>[];

    // 1. Emergency override on normally-closed gates (alternate route).
    for (final gate in failed.zones.values.where(
      (z) =>
          z.type == ZoneType.gate &&
          !z.isOpen &&
          !z.emergencyOverride &&
          !failedTargets.contains(z.code),
    )) {
      fixes.add(
        StressFix(
          code: 'gate-override:${gate.code}',
          title: 'Alternate route via ${gate.name}',
          detail:
              'Pre-authorize remote emergency opening of ${gate.name} so '
              'responders can route through it.',
          applicable: true,
          passesAlone: false,
        ),
      );
    }

    // 2. Re-stage an alternate mobile unit of each late type at a hub.
    final zone = failed.zone(sc.zoneCode)!;
    const mobile = {
      ResponderType.ambulance,
      ResponderType.securityPatrol,
      ResponderType.fireSafety,
      ResponderType.facilities,
    };
    final policy = PolicyEngine.select(
      failed.policies,
      zone.type,
      PolicyEngine.familyOf(sc.eventType),
      sc.hour,
    );
    final restageTypes = {
      ...base.lateTypes,
      if (base.lateTypes.isNotEmpty) ...?policy?.fallbackTypes,
    }.where(mobile.contains);
    final ambulanceHub = ambulanceHubOf(failed);
    final centralStandby = centralStandbyOf(failed);
    for (final type in restageTypes) {
      final hub = type == ResponderType.ambulance
          ? ambulanceHub
          : centralStandby;
      if (hub == null) continue;
      for (final r in failed.responders.values.where(
        (r) =>
            r.type == type &&
            r.status == ResponderStatus.available &&
            r.zoneCode != hub,
      )) {
        fixes.add(
          StressFix(
            code: 'restage:${r.code}:$hub',
            title: 'Alternate responder: re-stage ${r.name}',
            detail:
                'Station ${r.name} at ${failed.zoneName(hub)} during this '
                'window so it can cover ${zone.name}.',
            applicable: true,
            passesAlone: false,
          ),
        );
      }
    }

    // 3. Restore degraded or offline cameras (maintenance work order).
    for (final f in sc.failures.where(
      (f) =>
          f.kind == StressFailureKind.cameraDegraded ||
          f.kind == StressFailureKind.cameraOffline,
    )) {
      fixes.add(
        StressFix(
          code: 'restore-camera:${f.target}',
          title: 'Restore ${f.target}',
          detail:
              'Raise a maintenance work order to bring ${f.target} back '
              'online and restore corroboration.',
          applicable: true,
          passesAlone: false,
        ),
      );
    }
    for (final c
        in failed
            .camerasIn(sc.zoneCode)
            .where(
              (c) =>
                  c.health == AssetHealth.offline &&
                  !failedTargets.contains(c.code),
            )) {
      fixes.add(
        StressFix(
          code: 'restore-camera:${c.code}',
          title: 'Restore ${c.code}',
          detail: 'The zone is a blind spot today: restore ${c.code}.',
          applicable: true,
          passesAlone: false,
        ),
      );
    }
    return fixes;
  }

  /// Applies a fix code to a twin copy. Also used to apply a fix to the live
  /// twin from the Readiness Lab (see ReadinessEndpoint.applyFix).
  static TwinSnapshot _applyFix(TwinSnapshot twin, String code) {
    final copy = twin.copy();
    final parts = code.split(':');
    switch (parts.first) {
      case 'gate-override':
        copy.zones[parts[1]]?.emergencyOverride = true;
      case 'restage':
        copy.responders[parts[1]]
          ?..zoneCode = parts[2]
          ..baseZoneCode = parts[2];
      case 'restore-camera':
        copy.cameras[parts[1]]?.health = AssetHealth.online;
    }
    return copy;
  }
}

/// Internal result of one simulated response.
class StressPrediction {
  StressPrediction({
    required this.pass,
    required this.worstArrival,
    required this.slaSeconds,
    required this.policyCode,
    required this.stages,
    required this.plan,
    required this.findings,
    this.lateTypes = const {},
    this.uncoveredTypes = const {},
  });

  /// Required responder types that miss the SLA or have no unit at all.
  final Set<ResponderType> lateTypes;

  /// Required responder types no available unit can reach at all.
  final Set<ResponderType> uncoveredTypes;
  final bool pass;
  final int worstArrival;
  final int slaSeconds;
  final String? policyCode;
  final List<StageEstimate> stages;
  final List<String> plan;
  final List<String> findings;
}
