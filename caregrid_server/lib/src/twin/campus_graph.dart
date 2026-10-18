import '../generated/protocol.dart';
import 'twin_snapshot.dart';

/// Result of a shortest-path query.
class RouteResult {
  const RouteResult(this.path, this.meters, this.effectiveMeters);

  static const none = RouteResult([], 0, 0);

  /// Zone codes from start to destination.
  final List<String> path;

  /// Physical length of the route.
  final int meters;

  /// Length weighted by congestion; used for travel time.
  final double effectiveMeters;

  bool get found => path.isNotEmpty;
}

/// Road graph of the campus. Closed gates and blocked roads are impassable,
/// gates with an emergency override are passable, congested roads are slower.
class CampusGraph {
  CampusGraph(this.twin) {
    for (final road in twin.roads) {
      if (road.status == RoadStatus.blocked) continue;
      final weight = road.status == RoadStatus.congested ? 1.5 : 1.0;
      _edges
          .putIfAbsent(road.fromZone, () => [])
          .add(
            _Edge(road.toZone, road.lengthMeters, weight),
          );
      _edges
          .putIfAbsent(road.toZone, () => [])
          .add(
            _Edge(road.fromZone, road.lengthMeters, weight),
          );
    }
  }

  final TwinSnapshot twin;
  final Map<String, List<_Edge>> _edges = {};

  bool _passable(String code, String from, String to) {
    if (code == from || code == to) return true;
    final zone = twin.zone(code);
    if (zone == null || zone.type != ZoneType.gate) return true;
    return zone.isOpen || zone.emergencyOverride;
  }

  /// Dijkstra over the (small) campus graph.
  RouteResult route(String from, String to) {
    if (from == to) return RouteResult([from], 0, 0);
    final dist = <String, double>{from: 0};
    final meters = <String, int>{from: 0};
    final prev = <String, String>{};
    final open = <String>{from};
    final done = <String>{};

    while (open.isNotEmpty) {
      final current = open.reduce((a, b) => dist[a]! <= dist[b]! ? a : b);
      open.remove(current);
      if (current == to) break;
      done.add(current);
      if (!_passable(current, from, to)) continue;
      for (final edge in _edges[current] ?? const <_Edge>[]) {
        if (done.contains(edge.to)) continue;
        final candidate = dist[current]! + edge.meters * edge.weight;
        if (candidate < (dist[edge.to] ?? double.infinity)) {
          dist[edge.to] = candidate;
          meters[edge.to] = meters[current]! + edge.meters;
          prev[edge.to] = current;
          open.add(edge.to);
        }
      }
    }

    if (!dist.containsKey(to)) return RouteResult.none;
    final path = <String>[to];
    var cursor = to;
    while (prev.containsKey(cursor)) {
      cursor = prev[cursor]!;
      path.insert(0, cursor);
    }
    return RouteResult(path, meters[to]!, dist[to]!);
  }

  /// Seconds for [responder] to mobilize and travel the route.
  static int etaSeconds(Responder responder, RouteResult route) {
    final travel = route.effectiveMeters / responder.speedMetersPerMin * 60;
    return responder.mobilizationSeconds + travel.round();
  }
}

class _Edge {
  _Edge(this.to, this.meters, this.weight);

  final String to;
  final int meters;
  final double weight;
}
