import 'package:serverpod/serverpod.dart';

import '../core/access.dart';
import '../generated/protocol.dart';
import '../response/incident_views.dart';
import '../response/proof_of_response.dart';
import '../twin/campus_graph.dart';
import '../twin/twin_snapshot.dart';

/// The campus digital twin: zones, roads, cameras, responders, live map.
class CampusEndpoint extends Endpoint {
  /// Role-filtered snapshot. Members only get places (for the SOS picker);
  /// cameras are visible to command and admin only.
  Future<CampusTwin> twin(Session session) async {
    final actor = await Access.any(session);
    final twin = await TwinSnapshot.load(session, actor.campusId);
    final role = actor.role;
    final seesOps = role != UserRole.member;
    final seesCameras = role == UserRole.command || role == UserRole.admin;

    final open = await Incident.db.find(
      session,
      where: (t) =>
          t.campusId.equals(actor.campusId) &
          t.resolvedAt.equals(null) &
          t.dismissedAt.equals(null) &
          t.parentIncidentId.equals(null),
    );
    final visible = switch (role) {
      UserRole.command || UserRole.admin => open,
      UserRole.medical => open.where((i) => i.hospitalNotified).toList(),
      _ => <Incident>[],
    };

    final active = await Dispatch.db.find(
      session,
      where: (t) =>
          t.campusId.equals(actor.campusId) &
          t.status.inSet(
            DispatchStatus.values.where((s) => s.active).toSet(),
          ),
    );
    final positions = <String, String>{
      for (final r in twin.responders.values)
        r.code: ProofOfResponse.positionOf(
          r,
          active
              .where((d) => d.responderCode == r.code && d.status.active)
              .lastOrNull,
        ),
    };

    return CampusTwin(
      campusName: twin.campus.name,
      // Live state only; the static map layers come once from [profile].
      campus: twin.campus.copyWith(mapLayers: null),
      zones: twin.zones.values.toList(),
      roads: twin.roads,
      cameras: seesCameras ? twin.cameras.values.toList() : [],
      responders: seesOps ? twin.responders.values.toList() : [],
      activeIncidents: await IncidentViews.summaries(
        session,
        visible,
        twin,
        role: role,
      ),
      responderPositions: seesOps ? positions : {},
    );
  }

  /// The caller's campus with its static map layers (plot outlines,
  /// parking, courts, streets). Fetched once per session; [twin] carries the
  /// live state without them.
  Future<Campus> profile(Session session) async {
    final actor = await Access.any(session);
    final campus = await Campus.db.findById(session, actor.campusId);
    if (campus == null) throw notFound('Campus');
    return campus;
  }

  /// Shortest passable route between two zones right now.
  Future<RoutePlan> route(Session session, String from, String to) async {
    final actor = await Access.require(session, {
      UserRole.command,
      UserRole.admin,
      UserRole.responder,
    });
    final twin = await TwinSnapshot.load(session, actor.campusId);
    final result = CampusGraph(twin).route(from, to);
    return RoutePlan(
      found: result.found,
      route: result.path,
      routeNames: result.path.map(twin.zoneName).toList(),
      distanceMeters: result.meters,
      note: result.found
          ? null
          : 'No passable route (closed gate or blocked road).',
    );
  }
}
