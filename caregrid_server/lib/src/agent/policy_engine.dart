import '../generated/protocol.dart';
import '../core/clock.dart';

/// Site-specific policy logic: context changes meaning. The same fall is
/// judged differently on a sports field at 17:00 and in a hostel at 02:17.
class PolicyEngine {
  PolicyEngine._();

  static EventFamily familyOf(EventType type) => switch (type) {
    EventType.personDown ||
    EventType.fall ||
    EventType.prolongedImmobility ||
    EventType.visibleDistress ||
    EventType.sosRequest ||
    EventType.personRecovered ||
    EventType.helpArrived ||
    EventType.reporterCancelled => EventFamily.medical,
    EventType.smoke ||
    EventType.fire ||
    EventType.hazardCleared => EventFamily.fireHazard,
    EventType.vehicleCollision ||
    EventType.routeObstruction => EventFamily.mobility,
    EventType.restrictedEntry => EventFamily.access,
    EventType.flooding => EventFamily.environment,
    EventType.unattendedObject => EventFamily.object,
    EventType.crowdSurge => EventFamily.crowd,
  };

  /// Events about a person, used for victim tracking and fusion.
  static bool isPersonEvent(EventType type) => const {
    EventType.personDown,
    EventType.fall,
    EventType.prolongedImmobility,
    EventType.visibleDistress,
  }.contains(type);

  /// Observable consequence. CareGrid never states a diagnosis.
  static String consequenceFor(EventType type) => switch (type) {
    EventType.personDown ||
    EventType.fall ||
    EventType.prolongedImmobility => 'Potential medical emergency',
    EventType.visibleDistress => 'Person in visible distress',
    EventType.sosRequest => 'Help requested by a campus member',
    EventType.smoke || EventType.fire => 'Fire or hazardous atmosphere',
    EventType.vehicleCollision => 'Road collision, possible injuries',
    EventType.routeObstruction => 'Emergency route obstructed',
    EventType.crowdSurge => 'Dangerous crowd density',
    EventType.restrictedEntry => 'Unauthorized entry into restricted zone',
    EventType.flooding => 'Flooding / water hazard',
    EventType.unattendedObject => 'Unattended object',
    _ => 'Context update',
  };

  /// Picks the most specific policy that matches zone type, family and the
  /// local hour. Zone-type match beats wildcard; an hour window beats all-day.
  static ZonePolicy? select(
    List<ZonePolicy> policies,
    ZoneType zoneType,
    EventFamily family,
    int hour,
  ) {
    ZonePolicy? best;
    var bestScore = -1;
    for (final p in policies) {
      if (p.family != family) continue;
      if (p.zoneType != null && p.zoneType != zoneType) continue;
      if (!CampusClock.hourInWindow(hour, p.startHour, p.endHour)) continue;
      final score =
          (p.zoneType != null ? 2 : 0) + (p.startHour != null ? 1 : 0);
      if (score > bestScore ||
          (score == bestScore && p.severity.rank < best!.severity.rank)) {
        best = p;
        bestScore = score;
      }
    }
    return best;
  }

  /// One step more urgent, used for multi-victim events.
  static Severity escalate(Severity s) => switch (s) {
    Severity.p3 => Severity.p2,
    Severity.p2 => Severity.p1,
    _ => Severity.p0,
  };

  static String hourLabel(int hour) => '${hour.toString().padLeft(2, '0')}:00';
}
