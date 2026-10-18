import '../core/clock.dart';
import '../generated/protocol.dart';
import '../twin/campus_graph.dart';
import '../twin/twin_snapshot.dart';

/// Matches an incident to the fastest available units: one per responder type
/// the policy requires, with fallbacks when a type has nobody available.
class ResponsePlanner {
  ResponsePlanner(this.twin) : graph = CampusGraph(twin);

  final TwinSnapshot twin;
  final CampusGraph graph;

  /// [elapsedSeconds] is the time already spent since onset; it is added to
  /// each ETA when checking the policy's onset-to-arrival SLA.
  ResponsePlan plan({
    required String zoneCode,
    required ZonePolicy policy,
    required int elapsedSeconds,
    Set<String> exclude = const {},
    List<ResponderType>? onlyTypes,
  }) {
    final options = <PlanOption>[];
    final warnings = <String>[];
    final used = <String>{...exclude};
    final types = onlyTypes ?? policy.responderTypes;

    for (final type in types) {
      var choice = best(
        type,
        zoneCode,
        used,
        role: type == types.first ? 'primary' : 'support',
        slaRemaining: policy.arrivalSlaSeconds - elapsedSeconds,
      );
      if (choice == null) {
        for (final fallback in policy.fallbackTypes) {
          choice = best(
            fallback,
            zoneCode,
            used,
            role: 'fallback',
            slaRemaining: policy.arrivalSlaSeconds - elapsedSeconds,
          );
          if (choice != null) {
            warnings.add(
              'No ${type.label.toLowerCase()} available: '
              'fallback to ${choice.responderName}.',
            );
            break;
          }
        }
      }
      if (choice == null) {
        warnings.add(
          'No available unit can cover ${type.label.toLowerCase()}. '
          'Escalate to the incident commander.',
        );
        continue;
      }
      if (!choice.withinSla) {
        warnings.add(
          '${choice.responderName} ETA ${formatSeconds(choice.etaSeconds)} '
          'misses the ${formatSeconds(policy.arrivalSlaSeconds)} arrival SLA.',
        );
      }
      used.add(choice.responderCode);
      options.add(choice);
    }

    final alternatives = <PlanOption>[];
    for (final type in {...types, ...policy.fallbackTypes}) {
      for (final r in _available(type, used)) {
        final option = optionFor(
          r,
          zoneCode,
          role: 'alternative',
          slaRemaining: policy.arrivalSlaSeconds - elapsedSeconds,
        );
        if (option != null) alternatives.add(option);
      }
    }
    alternatives.sort((a, b) => a.etaSeconds.compareTo(b.etaSeconds));

    return ResponsePlan(
      options: options,
      alternatives: alternatives.take(4).toList(),
      warnings: warnings,
      arrivalSlaSeconds: policy.arrivalSlaSeconds,
    );
  }

  /// Fastest available unit of [type] that can reach [zoneCode].
  PlanOption? best(
    ResponderType type,
    String zoneCode,
    Set<String> exclude, {
    required String role,
    required int slaRemaining,
  }) {
    PlanOption? bestOption;
    for (final r in _available(type, exclude)) {
      final option = optionFor(
        r,
        zoneCode,
        role: role,
        slaRemaining: slaRemaining,
      );
      if (option == null) continue;
      if (bestOption == null || option.etaSeconds < bestOption.etaSeconds) {
        bestOption = option;
      }
    }
    return bestOption;
  }

  PlanOption? optionFor(
    Responder r,
    String zoneCode, {
    required String role,
    required int slaRemaining,
  }) {
    final route = graph.route(r.zoneCode, zoneCode);
    if (!route.found) return null;
    final eta = CampusGraph.etaSeconds(r, route);
    return PlanOption(
      responderCode: r.code,
      responderName: r.name,
      responderType: r.type,
      role: role,
      route: route.path,
      routeNames: route.path.map(twin.zoneName).toList(),
      distanceMeters: route.meters,
      etaSeconds: eta,
      withinSla: eta <= slaRemaining,
    );
  }

  Iterable<Responder> _available(ResponderType type, Set<String> exclude) =>
      twin.responders.values.where(
        (r) =>
            r.type == type &&
            r.status == ResponderStatus.available &&
            !exclude.contains(r.code),
      );
}
