// Builds the NIET campus digital twin from committed OpenStreetMap data.
//
//   node scripts/build-niet-twin.mjs
//
// Inputs (assets/maps/niet/):
//   osm-extract.json      Overpass extract (ways with node ids, building
//                          relations, gate nodes). © OpenStreetMap
//                          contributors, ODbL 1.0.
//   referral-routes.json  OSRM road distances from each gate to the partner
//                          hospitals.
//   twin-spec.json        Which OSM element is which twin zone, plus the
//                          explicitly approximate zones and gates.
// Output:
//   caregrid_server/lib/src/seed/niet_geometry.dart (generated, do not edit)
//
// The routing graph is reverse-engineered from the real road network: every
// building is snapped to the nearest road inside its own plot, shortest paths
// between all buildings and gates are computed over OSM road nodes, only the
// roads those paths use are kept, and chains of road nodes are contracted
// into twin road segments that keep their real length and drawn shape.
import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const input = (name) =>
  readFile(path.join(root, "assets", "maps", "niet", name), "utf8").then(
    JSON.parse,
  );
const [osm, routes, spec] = await Promise.all([
  input("osm-extract.json"),
  input("referral-routes.json"),
  input("twin-spec.json"),
]);

// ------------------------------------------------------------ projection
const ways = new Map();
const relations = new Map();
const pointNodes = new Map();
const coords = new Map(); // OSM node id -> [lat, lon]
for (const e of osm.elements) {
  if (e.type === "way") {
    ways.set(e.id, e);
    e.nodes?.forEach((id, i) => {
      const g = e.geometry?.[i];
      if (g) coords.set(id, [g.lat, g.lon]);
    });
  } else if (e.type === "relation") relations.set(e.id, e);
  else if (e.type === "node") {
    pointNodes.set(e.id, e);
    coords.set(e.id, [e.lat, e.lon]);
  }
}
const element = (ref) => {
  const [type, id] = ref.split("/");
  return (type === "way" ? ways : relations).get(Number(id));
};
const ringOf = (e) => {
  if (e.type === "way") return e.geometry.map((g) => [g.lat, g.lon]);
  const outers = e.members.filter(
    (m) => m.role === "outer" && m.geometry?.length > 3,
  );
  outers.sort((a, b) => b.geometry.length - a.geometry.length);
  return outers[0].geometry.map((g) => [g.lat, g.lon]);
};

// Frame: both plots plus a margin, origin at the north-west corner.
const plotRings = spec.campus.plots.map((p) => ringOf(element(p.osm)));
const lats = plotRings.flat().map(([lat]) => lat);
const lons = plotRings.flat().map(([, lon]) => lon);
const midLat = (Math.min(...lats) + Math.max(...lats)) / 2;
const rad = (midLat * Math.PI) / 180;
const mPerLat =
  111132.92 - 559.82 * Math.cos(2 * rad) + 1.175 * Math.cos(4 * rad);
const mPerLon = 111412.84 * Math.cos(rad) - 93.5 * Math.cos(3 * rad);
const margin = spec.campus.frameMarginMeters;
const originLat = Math.max(...lats) + margin / mPerLat;
const originLon = Math.min(...lons) - margin / mPerLon;
const width = (Math.max(...lons) - Math.min(...lons)) * mPerLon + 2 * margin;
const height = (Math.max(...lats) - Math.min(...lats)) * mPerLat + 2 * margin;
const project = ([lat, lon]) => [
  (lon - originLon) * mPerLon,
  (originLat - lat) * mPerLat,
];
const r1 = (v) => Math.round(v * 10) / 10;

// ------------------------------------------------------------ geometry
const dist = (a, b) => Math.hypot(a[0] - b[0], a[1] - b[1]);
const area = (ring) => {
  let s = 0;
  for (let i = 0; i < ring.length - 1; i++)
    s += ring[i][0] * ring[i + 1][1] - ring[i + 1][0] * ring[i][1];
  return s / 2;
};
const inside = (p, ring) => {
  let hit = false;
  for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    const [xi, yi] = ring[i];
    const [xj, yj] = ring[j];
    if (yi > p[1] !== yj > p[1] && p[0] < ((xj - xi) * (p[1] - yi)) / (yj - yi) + xi)
      hit = !hit;
  }
  return hit;
};
const centroid = (ring) => {
  const a = area(ring);
  let cx = 0;
  let cy = 0;
  for (let i = 0; i < ring.length - 1; i++) {
    const f = ring[i][0] * ring[i + 1][1] - ring[i + 1][0] * ring[i][1];
    cx += (ring[i][0] + ring[i + 1][0]) * f;
    cy += (ring[i][1] + ring[i + 1][1]) * f;
  }
  const c = [cx / (6 * a), cy / (6 * a)];
  if (inside(c, ring)) return c;
  // Concave outline: fall back to the interior grid point furthest from edges.
  const xs = ring.map((p) => p[0]);
  const ys = ring.map((p) => p[1]);
  let best = c;
  let bestScore = -1;
  for (let x = Math.min(...xs); x <= Math.max(...xs); x += 1)
    for (let y = Math.min(...ys); y <= Math.max(...ys); y += 1) {
      if (!inside([x, y], ring)) continue;
      const score = Math.min(
        ...ring.slice(0, -1).map((p, i) => segDist([x, y], p, ring[i + 1]).d),
      );
      if (score > bestScore) [best, bestScore] = [[x, y], score];
    }
  return best;
};
function segDist(p, a, b) {
  const dx = b[0] - a[0];
  const dy = b[1] - a[1];
  const len2 = dx * dx + dy * dy;
  const t = len2 ? Math.max(0, Math.min(1, ((p[0] - a[0]) * dx + (p[1] - a[1]) * dy) / len2)) : 0;
  const q = [a[0] + t * dx, a[1] + t * dy];
  return { d: dist(p, q), t, q };
}
const nearestOnRing = (p, ring) => {
  let best = null;
  for (let i = 0; i < ring.length - 1; i++) {
    const s = segDist(p, ring[i], ring[i + 1]);
    if (!best || s.d < best.d) best = s;
  }
  return best.q;
};

const plots = new Map(
  spec.campus.plots.map((p, i) => [p.osm, plotRings[i].map(project)]),
);
const plotOf = (p) => {
  for (const [ref, ring] of plots) if (inside(p, ring)) return ref;
  for (const [ref, ring] of plots) if (dist(p, nearestOnRing(p, ring)) < 15) return ref;
  return null;
};

// ------------------------------------------------------------ road graph
const DRIVABLE = new Set([
  "primary",
  "secondary",
  "tertiary",
  "tertiary_link",
  "residential",
  "unclassified",
  "service",
  "living_street",
]);
const pos = new Map(); // graph node -> [x, y]
const adj = new Map(); // graph node -> Map(neighbour -> {len, way})
const wayName = new Map();
const link = (a, b, way) => {
  const len = dist(pos.get(a), pos.get(b));
  if (!adj.has(a)) adj.set(a, new Map());
  if (!adj.has(b)) adj.set(b, new Map());
  adj.get(a).set(b, { len, way });
  adj.get(b).set(a, { len, way });
};
const unlink = (a, b) => {
  adj.get(a)?.delete(b);
  adj.get(b)?.delete(a);
};
for (const w of ways.values()) {
  if (!DRIVABLE.has(w.tags?.highway) || !w.nodes) continue;
  wayName.set(w.id, w.tags.name || null);
  for (const id of w.nodes) pos.set(String(id), project(coords.get(id)));
  for (let i = 0; i < w.nodes.length - 1; i++)
    link(String(w.nodes[i]), String(w.nodes[i + 1]), w.id);
}

/// Inserts a node where [p] projects onto the nearest allowed edge.
function attach(id, p, allowed) {
  let best = null;
  for (const [a, ns] of adj)
    for (const [b, e] of ns) {
      if (a > b || !allowed(a, b)) continue;
      const s = segDist(p, pos.get(a), pos.get(b));
      if (!best || s.d < best.s.d) best = { a, b, e, s };
    }
  if (!best) throw Error(`No road to attach ${id}`);
  const { a, b, e, s } = best;
  pos.set(id, s.q);
  if (s.t <= 0.02) return { node: a, offset: s.d };
  if (s.t >= 0.98) return { node: b, offset: s.d };
  unlink(a, b);
  link(a, id, e.way);
  link(id, b, e.way);
  return { node: id, offset: s.d };
}
const inPlot = (ref, slack = 12) => (a, b) => {
  const ring = plots.get(ref);
  return [pos.get(a), pos.get(b)].every(
    (p) => inside(p, ring) || dist(p, nearestOnRing(p, ring)) <= slack,
  );
};

// ------------------------------------------------------------ zones
const zones = [];
for (const z of spec.zones) {
  const e = element(z.osm);
  if (!e) throw Error(`Missing ${z.osm} in the extract`);
  const ring = ringOf(e).map(project);
  if (area(ring) > 0) ring.reverse();
  const c = centroid(ring);
  zones.push({
    ...z,
    x: c[0],
    y: c[1],
    footprint: ring,
    levels: e.tags?.["building:levels"] ? Number(e.tags["building:levels"]) : null,
    source: `OpenStreetMap ${z.osm}`,
    approximate: false,
  });
}
const byCode = new Map(zones.map((z) => [z.code, z]));
for (const z of spec.approximateZones) {
  const near = byCode.get(z.nearZone);
  zones.push({
    ...z,
    x: near.x + z.offset[0],
    y: near.y + z.offset[1],
    footprint: null,
    levels: null,
    source: "Position assumed; not present in OpenStreetMap",
    approximate: true,
  });
}

// Gates sit on the road network already; approximate gates are created on
// the plot boundary facing the named road and joined to both sides.
const gates = spec.gates.map((g) => {
  const p = project(coords.get(g.node));
  return { ...g, graphNode: String(g.node), x: p[0], y: p[1], source: `OpenStreetMap node/${g.node}`, approximate: false };
});
/// The point on the plot boundary closest to [wayId], at least [minSep]
/// metres from [avoid]: where else the plot meets that public road.
function frontageOnto(ring, wayId, avoid, minSep) {
  const road = ways.get(wayId).nodes.map((id) => pos.get(String(id)));
  let best = null;
  for (let i = 0; i < ring.length - 1; i++) {
    const steps = Math.ceil(dist(ring[i], ring[i + 1]));
    for (let s = 0; s <= steps; s++) {
      const t = s / steps;
      const p = [
        ring[i][0] + t * (ring[i + 1][0] - ring[i][0]),
        ring[i][1] + t * (ring[i + 1][1] - ring[i][1]),
      ];
      if (dist(p, avoid) < minSep) continue;
      let d = Infinity;
      for (let k = 0; k < road.length - 1; k++)
        d = Math.min(d, segDist(p, road[k], road[k + 1]).d);
      if (!best || d < best.d) best = { p, d };
    }
  }
  return best.p;
}
for (const g of spec.approximateGates) {
  const ring = plots.get(g.plot);
  const avoid = gates.find((x) => x.code === g.awayFromGate);
  const p = frontageOnto(ring, g.towardsWay, [avoid.x, avoid.y], g.minSeparationMeters);
  const id = `gate:${g.code}`;
  // Inside first, onto a campus road (never the public road it faces), so
  // neither attachment can snap onto the other's new link.
  const insidePlot = inPlot(g.plot);
  const inner = attach(`in:${g.code}`, p, (a, b) =>
    insidePlot(a, b) && adj.get(a)?.get(b)?.way !== g.towardsWay,
  );
  const outside = attach(`out:${g.code}`, p, (a, b) => {
    const w = adj.get(a)?.get(b)?.way;
    return w === g.towardsWay;
  });
  pos.set(id, p);
  link(id, inner.node, null);
  link(id, outside.node, g.towardsWay);
  gates.push({ ...g, graphNode: id, x: p[0], y: p[1], source: "Position assumed; no second entrance is mapped", approximate: true });
}

// Every building is snapped to the nearest road inside its own plot.
for (const z of zones) {
  const plot = z.plot || plotOf([z.x, z.y]);
  const a = attach(`att:${z.code}`, [z.x, z.y], inPlot(plot));
  z.attachNode = a.node;
  z.accessLength = a.offset;
  z.attachPoint = pos.get(a.node);
}

// ------------------------------------------------------------ shortest paths
function dijkstra(source) {
  const d = new Map([[source, 0]]);
  const prev = new Map();
  const open = new Set([source]);
  while (open.size) {
    let u = null;
    for (const n of open) if (u === null || d.get(n) < d.get(u)) u = n;
    open.delete(u);
    for (const [v, e] of adj.get(u) || []) {
      const nd = d.get(u) + e.len;
      if (nd < (d.get(v) ?? Infinity)) {
        d.set(v, nd);
        prev.set(v, u);
        open.add(v);
      }
    }
  }
  return { d, prev };
}
const keyNodes = [
  ...gates.map((g) => g.graphNode),
  ...zones.map((z) => z.attachNode),
];
const used = new Set();
const edgeKey = (a, b) => (a < b ? `${a}|${b}` : `${b}|${a}`);
for (const s of new Set(keyNodes)) {
  const { d, prev } = dijkstra(s);
  for (const t of new Set(keyNodes)) {
    if (t === s) continue;
    if (!d.has(t)) throw Error(`No road path between ${s} and ${t}`);
    for (let v = t; prev.has(v); v = prev.get(v)) used.add(edgeKey(v, prev.get(v)));
  }
}
const kept = new Map();
for (const k of used) {
  const [a, b] = k.split("|");
  for (const [x, y] of [[a, b], [b, a]]) {
    if (!kept.has(x)) kept.set(x, new Map());
    kept.get(x).set(y, adj.get(x).get(y));
  }
}

// ------------------------------------------------------------ contraction
const keySet = new Set(keyNodes);
const isStop = (n) => keySet.has(n) || (kept.get(n)?.size ?? 0) !== 2;
const zoneOfNode = new Map();
gates.forEach((g) => zoneOfNode.set(g.graphNode, g.code));
// Naming and the public/private flag use the strict boundary: a road just
// outside the fence is a public road even if it runs alongside the plot.
const strictPlotOf = (p) => {
  for (const [ref, ring] of plots) if (inside(p, ring)) return ref;
  return null;
};
const plotLabel = (p) => {
  const ref = strictPlotOf(p);
  return ref === "way/87176929" ? "Old campus" : ref === "way/1408786197" ? "New campus" : null;
};
const compass = (p, ring) => {
  const c = centroid(ring);
  const ang = (Math.atan2(c[1] - p[1], p[0] - c[0]) * 180) / Math.PI;
  return ["east", "north-east", "north", "north-west", "west", "south-west", "south", "south-east"][
    Math.round(((ang + 360) % 360) / 45) % 8
  ];
};
const junctions = [];
const attachOwner = new Map();
for (const z of zones) {
  if (!zoneOfNode.has(z.attachNode) && !attachOwner.has(z.attachNode))
    attachOwner.set(z.attachNode, z);
}
let jn = 0;
const junctionCode = new Map();
const stops = [...kept.keys()].filter(isStop).sort((a, b) => {
  const pa = pos.get(a);
  const pb = pos.get(b);
  return pa[1] - pb[1] || pa[0] - pb[0];
});
for (const n of stops) {
  if (zoneOfNode.has(n)) continue;
  const code = `J${String(++jn).padStart(2, "0")}`;
  junctionCode.set(n, code);
  zoneOfNode.set(n, code);
  const p = pos.get(n);
  const owner = attachOwner.get(n);
  const where = plotLabel(p);
  const ring = where ? plots.get(strictPlotOf(p)) : null;
  junctions.push({
    code,
    name: owner
      ? `${owner.name} access point`
      : where
        ? `${where} junction (${compass(p, ring)})`
        : "Public road junction",
    x: p[0],
    y: p[1],
    source: "Derived from the OpenStreetMap road network",
  });
}
const roads = [];
const seen = new Set();
const gateNames = new Map(gates.map((g) => [g.code, g.name]));
// Gates sit exactly on the fence line, so they count as neither side.
const insideShareOf = (chain) => {
  const body = chain.filter((n) => !gates.some((g) => g.graphNode === n));
  const pts = (body.length ? body : chain).map((n) => pos.get(n));
  return pts.filter((p) => strictPlotOf(p)).length / pts.length;
};
const nameFor = (wayIds, points, ends, insideShare) => {
  const named = wayIds.map((w) => wayName.get(w)).find(Boolean);
  if (named) return named;
  const gate = ends.find((code) => gateNames.has(code));
  if (insideShare < 0.5 && gate) return `${gateNames.get(gate)} approach`;
  const mid = points[Math.floor(points.length / 2)];
  const where = insideShare >= 0.5 ? plotLabel(mid) : null;
  return where ? `${where} internal road` : "Public road";
};
for (const s of stops) {
  for (const first of kept.get(s).keys()) {
    if (seen.has(edgeKey(s, first))) continue;
    const chain = [s];
    const wayIds = [];
    let prev = s;
    let cur = first;
    let length = 0;
    for (;;) {
      seen.add(edgeKey(prev, cur));
      const e = kept.get(prev).get(cur);
      length += e.len;
      if (e.way) wayIds.push(e.way);
      chain.push(cur);
      if (isStop(cur)) break;
      const next = [...kept.get(cur).keys()].find((n) => n !== prev);
      [prev, cur] = [cur, next];
    }
    const points = chain.map((n) => pos.get(n));
    const insideShare = insideShareOf(chain);
    const ends = [zoneOfNode.get(chain[0]), zoneOfNode.get(chain.at(-1))];
    roads.push({
      from: ends[0],
      to: ends[1],
      name: nameFor(wayIds, points, ends, insideShare),
      length,
      outside: insideShare < 0.5,
      path: points,
    });
  }
}
// Building access paths: zone centre to its road attachment.
for (const z of zones) {
  roads.push({
    from: z.code,
    to: zoneOfNode.get(z.attachNode),
    name: `${z.name} access`,
    length: Math.max(5, z.accessLength),
    outside: false,
    path: [[z.x, z.y], z.attachPoint],
  });
}
// Partner hospitals: placed on the frame edge in their real direction and
// joined to each gate with the OSRM road distance.
const hospitals = spec.hospitals.map((h) => {
  const info = routes.hospitals[h.routeKey];
  const target = project([info.lat, info.lon]);
  const centre = [width / 2, height / 2];
  const v = [target[0] - centre[0], target[1] - centre[1]];
  const scale = Math.min(
    v[0] ? (v[0] > 0 ? width - 18 - centre[0] : 18 - centre[0]) / v[0] : Infinity,
    v[1] ? (v[1] > 0 ? height - 18 - centre[1] : 18 - centre[1]) / v[1] : Infinity,
  );
  const p = [centre[0] + v[0] * scale, centre[1] + v[1] * scale];
  return { ...h, x: p[0], y: p[1], lat: info.lat, lon: info.lon, fullName: info.name };
});
for (const h of hospitals) {
  for (const g of gates.filter((g) => !g.approximate)) {
    const r = routes.routes.find(
      (r) => r.to === h.routeKey && r.from === spec.gateRouteKeys[g.code],
    );
    roads.push({
      from: h.code,
      to: g.code,
      name: `Road to ${h.name} (${(r.meters / 1000).toFixed(1)} km)`,
      length: r.meters,
      outside: true,
      path: [[h.x, h.y], [g.x, g.y]],
      osrmSeconds: r.seconds,
    });
  }
}
roads.sort(
  (a, b) => Number(a.outside) - Number(b.outside) || a.path[0][1] - b.path[0][1] || a.path[0][0] - b.path[0][0],
);
roads.forEach((r, i) => (r.code = `R${String(i + 1).padStart(2, "0")}`));

// ------------------------------------------------------------ map context
const polygonLayer = (filter) =>
  [...ways.values(), ...relations.values()]
    .filter(filter)
    .map((e) => {
      const ring = ringOf(e).map(project);
      return { ring: ring.flat().map(r1), name: e.tags?.name || null };
    })
    .filter((f) => {
      const c = [f.ring[0], f.ring[1]];
      return c[0] > -50 && c[1] > -50 && c[0] < width + 50 && c[1] < height + 50;
    });
const zoneOsm = new Set(spec.zones.map((z) => z.osm));
const layers = {
  plots: spec.campus.plots.map((p) => ({
    name: p.name,
    ring: plots.get(p.osm).flat().map(r1),
  })),
  parking: polygonLayer((e) => e.tags?.amenity === "parking"),
  courts: polygonLayer((e) => e.tags?.leisure === "pitch"),
  construction: polygonLayer((e) => e.tags?.landuse === "construction"),
  neighbours: polygonLayer(
    (e) =>
      (e.tags?.amenity === "college" || e.tags?.amenity === "university" || e.tags?.landuse === "college") &&
      !spec.campus.plots.some((p) => p.osm === `${e.type}/${e.id}`),
  ),
  otherBuildings: polygonLayer(
    (e) =>
      e.tags?.building &&
      !zoneOsm.has(`${e.type}/${e.id}`) &&
      [...plots.values()].some((ring) => {
        const p = project(ringOf(e)[0]);
        return inside(p, ring);
      }),
  ),
  streets: [...ways.values()]
    .filter((w) => DRIVABLE.has(w.tags?.highway) && w.nodes)
    .map((w) => ({
      kind: w.tags.highway,
      name: w.tags.name || null,
      line: w.nodes.map((id) => project(coords.get(id))).flat().map(r1),
    })),
  attribution: "© OpenStreetMap contributors, ODbL 1.0",
  osmTimestamp: osm.osm3s?.timestamp_osm_base || null,
};

// ------------------------------------------------------------ Dart output
const dartString = (s) =>
  s == null ? "null" : `'${String(s).replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\$/g, "\\$")}'`;
const nums = (pts) => `[${pts.flat().map((v) => r1(v).toFixed(1)).join(", ")}]`;
const zoneLine = (z, type) =>
  `    GeoZone(${dartString(z.code)}, ${dartString(z.name)}, ${type}, ${r1(z.x).toFixed(1)}, ${r1(z.y).toFixed(1)}, ` +
  `description: ${dartString(z.description)}, footprint: ${z.footprint ? nums(z.footprint) : "null"}, ` +
  `levels: ${z.levels ?? "null"}, source: ${dartString(z.source)}, approximate: ${Boolean(z.approximate)}, ` +
  `restricted: ${Boolean(z.restricted)}, privacySensitive: ${Boolean(z.privacySensitive)}, ` +
  `isOpen: ${z.open ?? true}),`;
const out = `// GENERATED by scripts/build-niet-twin.mjs from assets/maps/niet. Do not edit.
// Map data © OpenStreetMap contributors, ODbL 1.0 (extract ${layers.osmTimestamp}).
// Referral distances: ${routes.source}, fetched ${routes.fetched}.
// ignore_for_file: lines_longer_than_80_chars

import '../generated/protocol.dart';

/// A twin zone with real geometry, before it is bound to a campus row.
class GeoZone {
  const GeoZone(
    this.code,
    this.name,
    this.type,
    this.x,
    this.y, {
    this.description,
    this.footprint,
    this.levels,
    this.source,
    this.approximate = false,
    this.restricted = false,
    this.privacySensitive = false,
    this.isOpen = true,
  });

  final String code;
  final String name;
  final ZoneType type;
  final double x;
  final double y;
  final String? description;
  final List<double>? footprint;
  final int? levels;
  final String? source;
  final bool approximate;
  final bool restricted;
  final bool privacySensitive;
  final bool isOpen;
}

/// A road segment with its real length (metres) and drawn shape.
class GeoRoad {
  const GeoRoad(
    this.code,
    this.name,
    this.from,
    this.to,
    this.lengthMeters,
    this.outside,
    this.path,
  );

  final String code;
  final String name;
  final String from;
  final String to;
  final int lengthMeters;
  final bool outside;
  final List<double> path;
}

class NietGeometry {
  NietGeometry._();

  static const originLat = ${originLat.toFixed(7)};
  static const originLon = ${originLon.toFixed(7)};
  static const width = ${r1(width).toFixed(1)};
  static const height = ${r1(height).toFixed(1)};
  static const osmTimestamp = ${dartString(layers.osmTimestamp)};

  static const zones = <GeoZone>[
${zones.map((z) => zoneLine(z, `ZoneType.${z.type}`)).join("\n")}
${gates.map((g) => zoneLine(g, "ZoneType.gate")).join("\n")}
${junctions.map((j) => zoneLine(j, "ZoneType.junction")).join("\n")}
${hospitals.map((h) => zoneLine({ ...h, source: `OpenStreetMap (${h.fullName}); placed on the map edge in its real direction`, footprint: null }, "ZoneType.outside")).join("\n")}
  ];

  static const roads = <GeoRoad>[
${roads.map((r) => `    GeoRoad(${dartString(r.code)}, ${dartString(r.name)}, ${dartString(r.from)}, ${dartString(r.to)}, ${Math.round(r.length)}, ${r.outside}, ${nums(r.path)}),`).join("\n")}
  ];

  /// Non-routing context layers (plots, parking, courts, streets).
  static const mapLayers = r'''${JSON.stringify(layers)}''';
}
`;
const target = path.join(root, "caregrid_server", "lib", "src", "seed", "niet_geometry.dart");
await writeFile(target, out);
if (process.env.NIET_DEBUG_JSON)
  await writeFile(
    process.env.NIET_DEBUG_JSON,
    JSON.stringify({ width, height, zones, gates, junctions, hospitals, roads, layers }),
  );
console.log(
  `NIET twin: ${zones.length} buildings/sites, ${gates.length} gates, ${junctions.length} junctions, ` +
    `${hospitals.length} referral hospitals, ${roads.length} road segments; frame ${r1(width)} x ${r1(height)} m.`,
);
for (const r of roads.filter((r) => !r.outside))
  if (!r.from || !r.to) throw Error(`Dangling road ${r.code}`);
