import 'package:serverpod/serverpod.dart' hide Responder;

import '../core/access.dart';
import '../generated/protocol.dart';

/// In-memory copy of one campus's digital twin. The live pipeline loads it
/// from the database; the Stress-Test Engine mutates a private copy of it.
/// A snapshot never mixes campuses.
class TwinSnapshot {
  TwinSnapshot({
    required this.campus,
    required this.zones,
    required this.roads,
    required this.cameras,
    required this.responders,
    required this.policies,
  });

  final Campus campus;
  final Map<String, Zone> zones;
  final List<RoadSegment> roads;
  final Map<String, Camera> cameras;
  final Map<String, Responder> responders;
  final List<ZonePolicy> policies;

  int get campusId => campus.id!;

  static Future<TwinSnapshot> load(Session session, int campusId) async {
    final campus = await Campus.db.findById(session, campusId);
    if (campus == null) throw notFound('Campus $campusId');
    final zones = await Zone.db.find(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    final roads = await RoadSegment.db.find(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    final cameras = await Camera.db.find(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    final responders = await Responder.db.find(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    final policies = await ZonePolicy.db.find(
      session,
      where: (t) => t.campusId.equals(campusId),
    );
    return TwinSnapshot(
      campus: campus,
      zones: {for (final z in zones) z.code: z},
      roads: roads,
      cameras: {for (final c in cameras) c.code: c},
      responders: {for (final r in responders) r.code: r},
      policies: policies,
    );
  }

  /// Deep copy, so what-if changes never leak into the live twin.
  TwinSnapshot copy() => TwinSnapshot(
    campus: campus.copyWith(),
    zones: {for (final e in zones.entries) e.key: e.value.copyWith()},
    roads: [for (final r in roads) r.copyWith()],
    cameras: {for (final e in cameras.entries) e.key: e.value.copyWith()},
    responders: {
      for (final e in responders.entries) e.key: e.value.copyWith(),
    },
    policies: [for (final p in policies) p.copyWith()],
  );

  Zone? zone(String code) => zones[code];

  String zoneName(String code) => zones[code]?.name ?? code;

  List<Camera> camerasIn(String zoneCode) =>
      cameras.values.where((c) => c.zoneCode == zoneCode).toList();

  /// Coverage of a zone by working cameras.
  Observability observabilityOf(String zoneCode) {
    final cams = camerasIn(zoneCode);
    if (cams.any((c) => c.health == AssetHealth.online)) {
      final allOnline = cams.every((c) => c.health == AssetHealth.online);
      return allOnline ? Observability.full : Observability.degraded;
    }
    if (cams.any((c) => c.health == AssetHealth.degraded)) {
      return Observability.degraded;
    }
    return Observability.blind;
  }
}
