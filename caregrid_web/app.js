import {
  newState,
  advance,
  escalate,
  rehearsal,
  fmtSeconds,
  stages,
} from "./domain.mjs";
import { glassThumb, glassScroll } from "./glass.mjs";

const $ = (s) => document.querySelector(s);
const esc = (s) =>
  String(s).replace(
    /[&<>"']/g,
    (c) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        c
      ],
  );
let state = newState();
try {
  const saved = JSON.parse(localStorage.getItem("caregrid.duality.v1"));
  if (
    saved?.version === 1 &&
    Number.isInteger(saved.stage) &&
    saved.stage >= 0 &&
    saved.stage <= 6 &&
    Array.isArray(saved.audit)
  )
    state = { ...state, ...saved };
} catch {}
// Explicit synthetic fixtures make deck captures reproducible without a cloud account.
const fixture = new URLSearchParams(location.search).get("demo");
if (
  ["verified", "dispatched", "active", "care", "readiness", "outcome"].includes(
    fixture,
  )
) {
  state = newState();
  const count = {
    verified: 0,
    dispatched: 1,
    active: 3,
    care: 5,
    readiness: 0,
    outcome: 6,
  }[fixture];
  for (const a of [
    "dispatch",
    "ack",
    "move",
    "arrive",
    "care",
    "resolve",
  ].slice(0, count))
    state = advance(state, a);
  if (fixture === "care") state.hospitalReady = true;
  if (fixture === "readiness") state.rehearsed = true;
}
let view = location.hash.slice(1) || "overview",
  filter = "all",
  search = "",
  faults = { ambulanceBusy: true, gateClosed: true, cameraDegraded: true };
const nav = [
  ["overview", "Command centre", "01", "grid"],
  ["incident", "Incident workspace", "02", "pulse"],
  ["responder", "Responder view", "03", "route"],
  ["care", "Care console", "04", "cross"],
  ["readiness", "Readiness lab", "05", "layers"],
  ["analytics", "After-action", "06", "chart"],
];
const icons = {
  grid: '<rect x="3" y="3" width="6" height="6" rx="1"/><rect x="15" y="3" width="6" height="6" rx="1"/><rect x="3" y="15" width="6" height="6" rx="1"/><rect x="15" y="15" width="6" height="6" rx="1"/>',
  pulse: '<path d="M2 12h5l3-8 4 16 3-8h5"/>',
  route:
    '<circle cx="5" cy="5" r="3"/><circle cx="19" cy="19" r="3"/><path d="M8 5h8a4 4 0 0 1 0 8H8a4 4 0 0 0 0 8h8"/>',
  cross: '<path d="M9 3h6v6h6v6h-6v6H9v-6H3V9h6Z"/>',
  layers: '<path d="m12 2 10 6-10 6L2 8Z M2 12l10 6 10-6M2 16l10 6 10-6"/>',
  chart: '<path d="M3 3v18h18M7 16v-4m5 4V7m5 9V4"/>',
  arrow: '<path d="M5 12h14m-5-5 5 5-5 5"/>',
  up: '<path d="M5 19 19 5M5 5h14v14"/>',
  check: '<path d="m5 12 4 4L19 6"/>',
  search: '<circle cx="10" cy="10" r="6"/><path d="m15 15 6 6"/>',
  shield:
    '<path d="m12 2 9 4v6c0 5-9 10-9 10S3 17 3 12V6Z"/><path d="m8 12 3 3 5-6"/>',
  clock: '<circle cx="12" cy="12" r="9"/><path d="M12 6v6l4 3"/>',
  bell: '<path d="M5 17h14l-2-3V9a5 5 0 0 0-10 0v5ZM10 21h4"/>',
  download: '<path d="M12 3v12m-5-5 5 5 5-5M4 17v4h16v-4"/>',
  camera:
    '<rect x="3" y="6" width="13" height="12" rx="2"/><path d="m16 10 5-3v10l-5-3"/>',
  close: '<path d="m6 6 12 12M6 18 18 6"/>',
  sun: '<circle cx="12" cy="12" r="4"/><path d="M12 1v2m0 18v2M1 12h2m18 0h2M4 4l2 2m12 12 2 2M4 20l2-2M18 6l2-2"/>',
};
const icon = (name, cls = "") =>
  `<svg class="icon ${cls}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${icons[name] || icons.grid}</svg>`;
const tag = (text, color = "muted") =>
  `<span class="tag ${color}">${text}</span>`;
const section = (n, label, right = "") =>
  `<div class="section-label"><span>${n}</span> ${label}<i></i>${right ? `<small>${right}</small>` : ""}</div>`;
const status = () => stages[state.stage];
const unit = () => (state.alternate ? "A1" : "A2");
const nextAction = () =>
  [
    "Confirm & dispatch",
    "Acknowledge task",
    "Start moving",
    "Record arrival",
    "Start care",
    "Resolve incident",
    "Case resolved",
  ][state.stage];
const actionName = () =>
  ["dispatch", "ack", "move", "arrive", "care", "resolve", null][state.stage];
function save() {
  try {
    localStorage.setItem("caregrid.duality.v1", JSON.stringify(state));
  } catch {
    toast("Browser storage is unavailable. This demo will reset on reload.");
  }
}
function toast(text) {
  $("#toast").textContent = text;
  $("#toast").classList.add("shown");
  clearTimeout(window.toastTimer);
  window.toastTimer = setTimeout(
    () => $("#toast").classList.remove("shown"),
    4500,
  );
}
function proof(compact = false) {
  return `<div class="proof ${compact ? "compact" : ""}">${["Dispatch", "Acknowledge", "Moving", "On scene", "Care", "Resolve"].map((s, i) => `<div class="proof-step ${state.stage > i ? "done" : ""} ${state.stage === i ? "current" : ""}"><span class="proof-dot">${state.stage > i ? icon("check") : String(i + 1).padStart(2, "0")}</span><span>${s}</span><small>${state.stage > i ? ["02:17:08", "02:17:13", "02:17:18", "02:18:22", "02:18:28", "02:18:40"][i] : "Awaiting proof"}</small></div>`).join("")}</div>`;
}

function campusMap(large = false) {
  return `<div class="map-wrap ${large ? "map-large" : ""}"><svg class="campus-map" viewBox="0 0 800 360" role="img" aria-label="Illustrated Meridian campus map. Birch Hostel incident, hospital, response route and closed north gate. No live Google Maps connection.">
<defs><pattern id="dots" width="18" height="18" patternUnits="userSpaceOnUse"><circle cx="1" cy="1" r=".6" fill="#d6deec"/></pattern><linearGradient id="park" x2="0" y2="1"><stop stop-color="#e6f2e7"/><stop offset="1" stop-color="#d8ebd9"/></linearGradient></defs>
<rect width="800" height="360" fill="#f4f7fd"/><rect width="800" height="360" fill="url(#dots)"/><path d="M0 280Q100 250 155 312T330 340L410 360H0Z" fill="#eaf0fa"/>
<path d="M10 45h780M10 185h780M10 312h780M120 0v360M360 0v360M610 0v360" stroke="#ffffff" stroke-width="17" stroke-linecap="round" fill="none"/><path d="M10 45h780M10 185h780M10 312h780M120 0v360M360 0v360M610 0v360" stroke="#dbe3f3" stroke-width="1" fill="none" stroke-dasharray="5 6"/>
<path d="M440 72h120v74H440zM425 218h140v65H425zM660 70h110v85H660zM159 224h120v64H159zM165 66h120v73H165z" fill="url(#park)" stroke="#c8e0c9"/>
<g fill="#3c7a48" font-family="Geist Mono,monospace" font-size="9.5" font-weight="500" letter-spacing="1"><text x="466" y="112">ACADEMIC QUAD</text><text x="457" y="254">CENTRAL GREEN</text><text x="678" y="112">SPORTS FIELD</text><text x="180" y="260">LIBRARY</text><text x="187" y="106">ASTER HOSTEL</text></g>
<g stroke="#9fbcef" fill="#c9dbf8"><rect x="29" y="70" width="60" height="60" rx="3"/><rect x="29" y="222" width="60" height="58" rx="3"/><rect x="405" y="77" width="19" height="62"/><rect x="570" y="225" width="17" height="60"/><rect x="646" y="219" width="65" height="67" rx="3"/><rect x="725" y="219" width="50" height="67" rx="3"/></g>
<g fill="#b9d8bb"><circle cx="151" cy="161" r="4"/><circle cx="165" cy="160" r="3"/><circle cx="183" cy="161" r="4"/><circle cx="451" cy="160" r="4"/><circle cx="469" cy="160" r="3"/><circle cx="486" cy="160" r="4"/><circle cx="450" cy="295" r="4"/><circle cx="469" cy="295" r="3"/><circle cx="485" cy="295" r="4"/></g>
<path d="M610 255V185H360V107" fill="none" stroke="#2b58bf" stroke-opacity=".12" stroke-width="18"/><path class="route-line" d="M610 255V185H360V107" fill="none" stroke="#2b58bf" stroke-width="4" stroke-linejoin="round" stroke-linecap="round"/>
<rect x="316" y="68" width="88" height="73" rx="4" fill="#f6dd78" stroke="#e5c55a"/><path d="M330 80h59v48h-59z" fill="none" stroke="#e0c060"/><circle cx="360" cy="108" r="22" fill="#c8391b" fill-opacity=".14"/><circle cx="360" cy="108" r="8" fill="#c8391b" stroke="#ffffff" stroke-width="3"/>
<g fill="#2b3a5c" font-family="Geist Mono,monospace" font-size="10.5" font-weight="500" letter-spacing=".6"><text x="316" y="58">BIRCH HOSTEL</text><text x="541" y="291">CAMPUS HOSPITAL</text><text x="28" y="302">CONTROL</text><text x="645" y="305">CEDAR · BLIND SPOT</text></g>
<rect x="574" y="225" width="72" height="54" rx="3" fill="#ffffff" stroke="#9fbcef"/><path d="M607 237h7v10h10v7h-10v10h-7v-10h-10v-7h10z" fill="#157a3d"/>
<g transform="translate(${state.stage >= 3 ? "455 185" : "610 195"})"><circle r="15" fill="#2b58bf" stroke="#ffffff" stroke-width="3"/><path d="m-6 4 6-10 6 10-6-2Z" fill="#ffffff"/><text x="22" y="4" fill="#2b58bf" font-family="Geist Mono,monospace" font-weight="500" font-size="11">AMB-${unit()}</text></g>
<circle cx="298" cy="159" r="6" fill="#946200" stroke="#ffffff" stroke-width="2"/><text x="189" y="178" fill="#946200" font-family="Geist Mono,monospace" font-weight="500" font-size="10">BIRCH DESK · 24s</text>
<path d="M342 24h36" stroke="#c8391b" stroke-width="4" stroke-dasharray="5 3"/><text x="395" y="29" fill="#c8391b" font-family="Geist Mono,monospace" font-weight="500" font-size="10">NORTH GATE CLOSED</text>
<g transform="translate(754 30)" stroke="#6b7a99" fill="none"><path d="M0 25V0m-5 8 5-8 5 8"/><text x="-4" y="-8" fill="#6b7a99" stroke="none" font-family="Geist Mono,monospace" font-size="10">N</text></g>
<path d="M32 334h75m-75-4v8m75-8v8" stroke="#6b7a99"/><text x="119" y="338" fill="#6b7a99" font-family="Geist Mono,monospace" font-size="9">100m · SCHEMATIC</text>
</svg><span class="map-pulse" aria-hidden="true"></span><div class="map-overlay"><span class="live-dot"></span> MERIDIAN DEMO CAMPUS <span>26 ZONES / 11 UNITS</span></div><div class="map-key"><span><i class="lime-dot"></i> Response route</span><span><i class="orange-dot"></i> Active incident</span><span>Illustrative map</span></div></div>`;
}

function evidence() {
  return `<div class="evidence"><svg viewBox="0 0 640 330" role="img" aria-label="Synthetic illustrated corridor scene with an anonymous person-down silhouette. Not real CCTV footage."><defs><linearGradient id="floor" x2="0" y2="1"><stop stop-color="#121719"/><stop offset="1" stop-color="#373c3a"/></linearGradient><pattern id="scan" width="4" height="4" patternUnits="userSpaceOnUse"><path d="M0 3h4" stroke="#000" stroke-opacity=".17"/></pattern></defs><rect width="640" height="330" fill="#121515"/><path d="m0 0 320 100L0 330Z" fill="#2c3231"/><path d="m640 0-260 100 260 230Z" fill="#252b29"/><path d="M0 330 320 155h60l260 175Z" fill="url(#floor)"/><path d="M0 0h640L380 100h-60Z" fill="#191e1c"/><rect x="320" y="100" width="60" height="55" fill="#101411"/><g fill="#141c18" stroke="#49514b"><path d="M31 27 128 56v184L31 300Z"/><path d="m178 72 62 18v93l-62 38Z"/><path d="m277 101 27 8v55l-27 17Z"/><path d="m599-1-85 40v205l85 74Z"/><path d="m471 57-56 27v99l56 37Z"/></g><g fill="none" stroke="#5e6960" opacity=".3"><path d="m0 88 320 36M0 248l320-110M640 80l-260 43M640 263 380 140M0 330l334-175M180 330l162-175M400 330l-41-175M640 330 370 155M183 232h288M80 289h478"/></g><g fill="#b9c7b7" opacity=".45"><path d="m210 0 21 7 117 88-5 2Z"/><path d="m479 0-22 9-94 85 7 3Z"/></g><g stroke="#aeb6a9" stroke-linecap="round"><path d="m267 254 58 7 43 13m-41-13 28-19 43 4m-71 16-8 18-44 6" stroke-width="15"/><path d="m270 254-18-2" stroke-width="20"/><circle cx="238" cy="249" r="13" fill="#aeb6a9" stroke="none"/></g><g fill="none" stroke="#ff8d68" stroke-width="2"><path d="M204 219h21m-21 0v19M416 219h-21m21 0v19M204 301h21m-21 0v-19M416 301h-21m21 0v-19"/></g><rect x="204" y="199" width="188" height="17" fill="#ff8d68"/><text x="211" y="211" fill="#171a17" font-family="monospace" font-size="10">PERSON DOWN · TRACK T-41</text><rect width="640" height="330" fill="url(#scan)"/></svg><div class="evidence-top"><span><i class="orange-dot"></i> CAM-HB-B07</span><span>02:17:02 / IR</span></div><div class="evidence-bottom">SYNTHETIC SCENE · NO REAL VIDEO <span>ADJACENT ANGLE CORROBORATED</span></div></div>`;
}

function header(title, subtitle, kicker, actions = "") {
  return `<div class="page-heading"><div><div class="eyebrow">${kicker}</div><h1>${title}</h1><p>${subtitle}</p></div><div class="heading-actions">${actions}</div></div>`;
}
function metrics() {
  return `<div class="metrics"><div class="metric"><span class="eyebrow">OPEN INCIDENTS</span><strong>${state.stage === 6 ? "02" : "03"}<small> / ACTIVE NOW</small></strong><span><i class="orange-dot"></i> ${state.stage === 6 ? "No urgent case" : "1 urgent · operator action needed"}</span></div><div class="metric"><span class="eyebrow">RESPONSE INTEGRITY</span><strong>12<span class="slash">/</span>14<small> CLOSED DEMO CASES</small></strong><span>2 incomplete proof chains in seed history</span></div><div class="metric"><span class="eyebrow">AVAILABLE UNITS</span><strong>${state.stage > 0 && state.stage < 6 ? "07" : "09"}<small> / 11 ON ROSTER</small></strong><span><i class="lime-dot"></i> Security · medical · facilities</span></div><div class="metric"><span class="eyebrow">CAMPUS COVERAGE</span><strong>18<span class="slash">/</span>19<small> CAMERAS</small></strong><span><i class="amber-dot"></i> Cedar corridor · coverage gap</span></div></div>`;
}
const incidents = [
  {
    id: "CG-0217",
    title: "Person down in Birch Hostel",
    place: "Block B · Ground floor · Corridor 2",
    priority: "P1",
    kind: "medical",
    time: "02:17:00",
    note: "Two-angle corroboration · night SOP",
    color: "orange",
  },
  {
    id: "CG-0216",
    title: "Water ingress near service access",
    place: "Facilities · East service lane",
    priority: "P3",
    kind: "facilities",
    time: "02:12:14",
    note: "Facilities crew assigned",
    color: "cyan",
  },
  {
    id: "CG-0215",
    title: "SOS request at Central Library",
    place: "Library · West entrance",
    priority: "P2",
    kind: "medical",
    time: "02:08:42",
    note: "Patrol on scene · handoff pending",
    color: "amber",
  },
];
function incidentRows() {
  const list = incidents.filter(
    (i) =>
      (filter !== "urgent" || i.priority === "P1") &&
      (filter !== "review" || i.id === "CG-0217") &&
      (i.title + " " + i.id + " " + i.place)
        .toLowerCase()
        .includes(search.toLowerCase()),
  );
  return list.length
    ? list
        .map(
          (i, n) =>
            `<button class="incident-row ${n === 0 ? "featured" : ""}" data-incident="${i.id}"><div class="row-top">${tag(i.priority, i.color)}<span class="mono">${i.id}</span><span class="time">${i.time}</span></div><h3>${i.title}</h3><p>${i.place}</p><div class="row-bottom"><span><i class="${i.color}-dot"></i> ${i.id === "CG-0217" ? status() : i.note}</span>${icon("up")}</div></button>`,
        )
        .join("")
    : '<div class="empty">No demo cases match this filter.</div>';
}
function overview() {
  return `${header("Campus <em>command.</em>", "Every signal connected. Every response accounted for.", "OPERATIONS / NIGHT SHIFT", `<button class="btn ghost" data-action="export">${icon("download")} Export case</button><button class="btn primary" data-action="scenario">Run a scenario ${icon("arrow")}</button>`)}${metrics()}<div class="overview-grid"><section class="panel map-panel">${section("01", "THE CAMPUS IN CONTEXT", "SCHEMATIC TWIN")}${campusMap()}<div class="map-footer"><span>${icon("route")} Hospital → West Junction → Birch Hostel</span><span class="lime">${state.alternate ? "2m 42s" : "1m 25s"} <small>PLANNED ETA · DEMO</small></span></div></section><section class="panel queue-panel">${section("02", "OWNED INCIDENTS", `${state.stage === 6 ? "2" : "3"} OPEN`)}<div class="filters" role="group" aria-label="Filter cases">${[
    ["all", "All cases"],
    ["urgent", "Urgent"],
    ["review", "Review"],
  ]
    .map(
      ([id, l]) =>
        `<button class="${filter === id ? "active" : ""}" data-filter="${id}" aria-pressed="${filter === id}">${l}</button>`,
    )
    .join(
      "",
    )}</div><div id="incident-list">${incidentRows()}</div></section></div><section class="panel response-strip"><div class="strip-title"><span class="eyebrow">03 / PROOF-OF-RESPONSE</span><h2>Sending help is <em>only the start.</em></h2><p>CG-0217 · Birch Hostel · ${state.stage === 6 ? "Human closure recorded" : "An explicit check at every step"}</p><a href="#incident" class="text-link">Open workspace ${icon("arrow")}</a></div>${proof(true)}</section><div class="footline"><span><i class="lime-dot"></i> FICTIONAL CAMPUS · SYNTHETIC DATA</span><span>Sense → Understand → Decide → Act → Verify → Close → Learn</span></div>`;
}

function actionButtons() {
  if (state.stage === 6)
    return `<button class="btn primary" data-action="scenario">Replay the incident ${icon("arrow")}</button>`;
  if (state.missedAck && state.stage === 1 && !state.alternate)
    return `<button class="btn warning" data-action="escalate">Simulate missed ACK & offer A1 ${icon("arrow")}</button>`;
  return `<button class="btn primary" data-action="advance">${nextAction()} ${icon("arrow")}</button>`;
}
function briefing() {
  return `<div class="briefing"><div class="section-label"><span>G</span> EVIDENCE BRIEF <i></i>${tag("FIXTURE", "cyan")}</div><h3>Two signals. One urgent case.</h3><div class="brief-line"><span>OBSERVED</span><p>Anonymous track T-41 remains on the floor. Adjacent camera B08 corroborates the event.</p></div><div class="brief-line"><span>CONTEXT</span><p>Hostel corridor · 02:17 · low foot traffic. SOP-HST-MED-NIGHT requires human dispatch confirmation.</p></div><div class="brief-line"><span>UNKNOWN</span><p>Clinical condition and cause. No responder arrival has been independently verified.</p></div><div class="ai-note">${icon("shield")} Gemini drafting is built and gated off. This brief is a synthetic fixture, not live model output.</div></div>`;
}
function incident() {
  return `${header("An incident. <em>An owner.</em>", "Birch Hostel · Block B · Ground floor · Corridor 2", "INCIDENT WORKSPACE / CG-0217", `<button class="btn ghost" data-action="export">${icon("download")} Export timeline</button>${actionButtons()}`)}<div class="incident-meta">${tag("P1 · URGENT", "orange")}${tag(status(), state.stage === 6 ? "lime" : "cyan")}<span>OWNER <b>Command · night shift</b></span><span>POLICY <b>SOP-HST-MED-NIGHT</b></span>${state.escalated ? tag("ESCALATED · ALTERNATE OFFERED", "amber") : ""}</div><div class="detail-grid"><div class="detail-main"><section class="panel evidence-panel">${section("01", "THE EVIDENCE", "ANONYMOUS TRACK T-41")}${evidence()}<div class="evidence-stats"><span>${icon("camera")} 2 independent angles</span><span>${icon("clock")} Persistence observed: 8s</span><span class="lime">Corroborated</span></div></section><section class="panel">${section("03", "THE RESPONSE PLAN", "DETERMINISTIC RULES")}<div class="plan-row"><div class="unit-mark">S</div><div><strong>Birch security desk</strong><p>Local first response · assigned desk</p></div><span class="plan-eta">24s<small>PLANNED</small></span></div><div class="plan-row"><div class="unit-mark ambulance">+</div><div><strong>Ambulance ${unit()}</strong><p>Hospital → West Junction → Birch</p></div><span class="plan-eta">${state.alternate ? "2m 42s" : "1m 25s"}<small>PLANNED</small></span></div><div class="notice">${icon("shield")} ETA is an estimate. Arrival and care require explicit proof.</div></section></div><div class="detail-side">${briefing()}<section class="panel compact-panel">${section("02", "NEXT ACTION")}<h3>${state.stage === 6 ? "Human closure recorded" : nextAction()}</h3><p class="muted">${state.stage === 0 ? "Confirm available units. A notification alone never counts as an accepted task." : state.stage === 6 ? "Demo outcome: care handed over to campus medical team." : "Use the responder workflow to record the next milestone. All telemetry is simulated."}</p>${actionButtons()}<a href="#responder" class="text-link">Switch to responder view ${icon("arrow")}</a></section></div></div><section class="panel">${section("04", "PROOF-OF-RESPONSE", "PER-UNIT TRACKING IN PILOT")}${proof()}</section><section class="panel timeline-panel">${section("05", "THE INCIDENT MEMORY", "LATEST FIRST")}${state.audit
    .slice(0, 5)
    .map(
      (a) =>
        `<div class="timeline-row"><time>${a.at}</time><span class="timeline-node"></span><div><strong>${esc(a.actor)}</strong><p>${esc(a.text)}</p></div></div>`,
    )
    .join("")}</section>`;
}

function responder() {
  return `${header("One task. <em>A clear next step.</em>", "Only the context the crew needs. Every milestone recorded.", "RESPONDER VIEW / AMBULANCE " + unit(), `<span class="role-badge">${icon("shield")} DEMO ROLE VIEW</span>`)}<div class="responder-layout"><section class="responder-card"><div class="task-head"><span class="eyebrow">AMB-${unit()} / RESPONSE ASSIGNMENT</span>${tag(state.stage === 0 ? "NOT YET OFFERED" : status(), "lime")}</div><div class="task-content"><div class="urgent-symbol">${icon("cross")}</div><span class="eyebrow orange">CG-0217 · P1 URGENT</span><h2>Possible medical<br><em>emergency.</em></h2><p class="task-location">Birch Hostel · Block B<br>Ground floor · Corridor 2</p><div class="task-facts"><div><span>ACCESS</span><b>Via West Junction</b></div><div><span>CONTACT</span><b>Birch security desk</b></div><div><span>DESTINATION</span><b>Campus hospital</b></div></div><div class="task-instructions"><span class="eyebrow">APPROVED RESPONSE STEPS / DEMO SOP</span><ol><li>Accept the task and confirm availability.</li><li>Follow the approved campus access route.</li><li>Check in on arrival; let clinicians assess care.</li></ol></div>${state.stage === 0 ? '<a href="#incident" class="btn primary">Awaiting command dispatch ' + icon("arrow") + "</a>" : actionButtons()}<p class="privacy-note">${icon("shield")} Camera evidence and anonymous track IDs are withheld in this view.</p></div></section><div class="responder-right"><section class="panel">${section("01", "YOUR ROUTE", "ILLUSTRATIVE")}${campusMap(true)}<div class="route-summary"><span>Hospital → West Junction → Birch</span><strong>${state.alternate ? "2m 42s" : "1m 25s"} <small>PLANNED ETA</small></strong></div></section><section class="panel">${section("02", "YOUR PROOF CHAIN")}${proof(true)}<div class="notice">Demo actions represent crew reports. No live GPS or emergency service is connected.</div></section></div></div>`;
}

function care() {
  return `${header("Ready for <em>the handoff.</em>", "The right context for care. A shared case, with a different view.", "CARE CONSOLE / CAMPUS HOSPITAL", `<span class="role-badge">${icon("shield")} MEDICAL DEMO VIEW</span>`)}<div class="care-banner"><div><span class="eyebrow">CAMPUS MEDICAL TEAM</span><h2>Know what is coming.<br><em>Prepare before arrival.</em></h2></div><div class="care-readiness">${icon("cross")}<span>${state.hospitalReady ? "READY TO RECEIVE" : "PREPARATION PENDING"}</span></div></div><div class="care-grid"><section class="panel incoming">${section("01", "INCOMING CASE", "SYNTHETIC CASE")}${tag("P1 · URGENT", "orange")}<h2>Possible medical emergency</h2><p class="large-muted">Birch Hostel · Block B · Corridor 2</p><div class="care-info"><div><span>CASE</span><b>CG-0217</b></div><div><span>RESPONSE</span><b>${status()}</b></div><div><span>TRANSPORT</span><b>Ambulance ${unit()}</b></div><div><span>CARE START</span><b>${state.stage >= 5 ? "02:18:28 · demo" : "Awaiting crew report"}</b></div></div><div class="notice cyan-notice">${icon("shield")} Clinical condition is unknown. CareGrid coordinates response; clinicians assess and treat.</div><button class="btn ${state.hospitalReady ? "ghost" : "primary"}" data-action="ready" ${state.hospitalReady ? "disabled" : ""}>${state.hospitalReady ? "Team marked ready" : "Mark team ready to receive"} ${icon("check")}</button></section><section class="panel">${section("02", "MINIMUM NECESSARY CONTEXT")}<div class="handoff-list"><div><span>Observed event</span><b>Person down, reported in hostel corridor</b></div><div><span>Other responder</span><b>Birch security desk</b></div><div><span>Receiving destination</span><b>Campus hospital · emergency bay</b></div><div><span>Camera footage</span><b class="redacted">WITHHELD IN THIS VIEW</b></div><div><span>Anonymous track</span><b class="redacted">WITHHELD IN THIS VIEW</b></div><div><span>Diagnosis</span><b>Not inferred</b></div></div><p class="privacy-note">This prototype demonstrates field minimization. Production access must be enforced by the backend.</p><a href="#incident" class="text-link">Return to command workspace ${icon("arrow")}</a></section></div>`;
}

function readiness() {
  const result = rehearsal({ ...faults, fix: state.fix });
  return `${header("Rehearse the <em>bad night.</em>", "Find the broken handoff before it becomes a real emergency.", "READINESS LAB / WHAT-IF SIMULATION", `<button class="btn primary" data-action="rehearse">${icon("layers")} Run rehearsal</button>`)}<div class="readiness-layout"><section class="panel scenario-panel">${section("01", "THE 02:17 COMPOUND FAILURE")}<h2>One emergency.<br><em>Three things go wrong.</em></h2><p>Person down at Birch Hostel. Five-minute onset-to-arrival objective.</p><div class="faults">${[
    [
      "ambulanceBusy",
      "Ambulance A2 is busy",
      "An alternate must travel from the north post.",
    ],
    [
      "gateClosed",
      "North Gate is closed",
      "The usual approach is unavailable.",
    ],
    [
      "cameraDegraded",
      "Adjacent camera is degraded",
      "Verification takes longer.",
    ],
  ]
    .map(
      ([id, title, note]) =>
        `<label class="fault"><input type="checkbox" data-fault="${id}" ${faults[id] ? "checked" : ""}><span class="toggle"></span><span><b>${title}</b><small>${note}</small></span></label>`,
    )
    .join(
      "",
    )}</div><div class="notice">${icon("shield")} Isolated what-if model. Running it does not change real gates, units or SOPs.</div></section><section class="panel result-panel">${section("02", "PREDICTED RESPONSE", state.rehearsed ? "MODEL COMPLETE" : "AWAITING RUN")}<div class="result-top">${tag(state.rehearsed ? (result.pass ? "WITHIN OBJECTIVE" : "OBJECTIVE MISSED") : "NOT RUN", state.rehearsed ? (result.pass ? "lime" : "orange") : "muted")}<span class="mono">ILLUSTRATIVE MODEL</span></div><div class="result-time">${state.rehearsed ? fmtSeconds(result.seconds) : "—"}<span>/ 5m 00s objective</span></div><p>${!state.rehearsed ? "Select the failure conditions, then run the rehearsal." : result.pass ? "An approved alternate access plan meets this model’s objective." : "The alternate response misses the objective. Test an access intervention."}</p><div class="stage-bars">${result.stages.map((s, i) => `<div><span>${s.label}</span><div><i style="width:${state.rehearsed ? Math.max(5, (s.seconds / 401) * 100) : 0}%;background:${i === 3 ? "var(--lime)" : "var(--cyan)"}"></i></div><b>${state.rehearsed ? s.seconds + "s" : "—"}</b></div>`).join("")}</div><div class="fix-card"><span class="eyebrow">RECOMMENDED WHAT-IF INTERVENTION</span><h3>Pre-authorize the service-gate route.</h3><p>Model an approved alternate route around the closed North Gate. A real access change requires institutional authorization.</p><button class="btn ${state.fix ? "ghost" : "primary"}" data-action="fix" ${!state.rehearsed || state.fix || !faults.gateClosed ? "disabled" : ""}>${state.fix ? "Intervention modeled" : "Test route intervention"} ${icon("arrow")}</button></div></section></div><section class="panel comparison">${section("03", "BEFORE THE NEXT EMERGENCY", "DECISION SUPPORT")}<div><h2>401<span>s</span> <em>→</em> 252<span>s</span></h2><p>Seeded compound-failure example with all three conditions enabled.<br><b>149 seconds of modeled improvement.</b> A hypothesis to test in drills, never a measured field result.</p></div></section>`;
}

function analytics() {
  return `${header("Measure the <em>whole response.</em>", "From the first signal to recorded care. Include the incomplete cases.", "AFTER-ACTION / SYNTHETIC HISTORY", `<button class="btn ghost" data-action="export">${icon("download")} Export demo record</button>`)}<div class="analytics-hero"><div><span class="eyebrow">NORTH STAR / MEAN TIME TO CARE</span><h2>Minutes.<br><em>Not alerts.</em></h2><p>Timings below illustrate the hero scenario.<br>They are not pilot outcomes.</p></div><div class="big-metric"><span>${state.stage >= 5 ? "1m 28s" : "—"}</span><small>${state.stage >= 5 ? "RECORDED BY DEMO ACTION" : "CARE NOT YET RECORDED"}</small></div></div><section class="panel">${section("01", "ONE INCIDENT, STAGE BY STAGE", "CG-0217 / DEMO CLOCK")}<div class="latency-chart">${[
    ["Detect", 2],
    ["Verify", 3],
    ["Dispatch", 3],
    ["Acknowledge", 5],
    ["Move + arrive", 69],
    ["Start care", 6],
  ]
    .map(
      ([l, s], i) =>
        `<div style="flex:${s < 8 ? 10 : s}" class="${i === 4 ? "lime-block" : ""}"><span>0${i + 1}</span><strong>${s}s</strong><small>${l}</small></div>`,
    )
    .join(
      "",
    )}</div><p class="chart-note">Illustrative scheduled chain totals 88s. Actual field reports must retain source timestamps, missing stages and clock uncertainty.</p></section><div class="analytics-grid"><section class="panel integrity">${section("02", "RESPONSE COMPLETION INTEGRITY")}<h2>12 <span>/ 14</span></h2><p>Closed synthetic responses with acknowledgement, arrival and care recorded.</p><div class="integrity-blocks">${Array.from({ length: 14 }, (_, i) => `<i class="${i < 12 ? "complete" : "incomplete"}">${i < 12 ? "✓" : "!"}</i>`).join("")}</div><div class="notice">2 seeded closed responses have incomplete proof. Open cases must be reported separately.</div></section><section class="panel">${section("03", "WHAT THE TIMELINE REVEALS")}<div class="insight-row"><span class="insight-number">01</span><div><h3>Arrival is the long pole.</h3><p>Route and access rehearsals matter as much as detection latency.</p></div></div><div class="insight-row"><span class="insight-number">02</span><div><h3>Silence is a signal.</h3><p>A missed acceptance must create an escalation, not disappear from the queue.</p></div></div><div class="insight-row"><span class="insight-number">03</span><div><h3>Coverage is never assumed.</h3><p>Cedar’s offline camera remains a visible gap; SOS is an independent path.</p></div></div></section></div>`;
}

const navShort = {
  overview: "Command",
  incident: "Incident",
  responder: "Responder",
  care: "Care",
  readiness: "Readiness",
  analytics: "After-action",
};
let placeThumb = () => {};
// The glass bar is rendered once; view changes move its marker and swap
// only the workspace, so the bar never flickers or loses its blur.
function chrome() {
  $("#app").innerHTML =
    `<header class="gbar demo-bar" data-gbar><div class="gbar-inner"><a href="#overview" class="gbar-brand" aria-label="CareGrid command centre"><img src="assets/mark.svg" alt="" width="26" height="26"><span>CareGrid</span><small>Demo</small></a><nav class="gbar-nav" aria-label="Product views"><span class="gbar-thumb" aria-hidden="true"></span>${nav.map(([id, title, n]) => `<a href="#${id}" class="gbar-link" data-view="${id}" title="${title}"><small aria-hidden="true">${n}</small>${navShort[id]}</a>`).join("")}</nav><div class="gbar-end"><span class="gbar-chip clock-chip"><span class="live-dot"></span>02:17 AM · Night shift</span><button class="gbar-icon" data-action="scenario" aria-label="Scenario controls" title="Scenario controls">${icon("pulse")}</button><button class="gbar-icon" data-action="reset" aria-label="Reset demo" title="Reset demo">${icon("clock")}</button><button class="gbar-icon" data-action="status" aria-label="View prototype connection status" title="Connection and provenance">${icon("bell")}</button><button class="gbar-avatar" data-action="about" aria-label="About Team Duality" title="About Team Duality">TD</button></div></div></header><main id="main" tabindex="-1"></main><dialog id="modal"><div id="modal-content"></div></dialog>`;
  placeThumb = glassThumb($(".gbar-nav"));
  glassScroll();
}
function render() {
  if (!nav.some((n) => n[0] === view)) view = "overview";
  if (!$("#main")) chrome();
  const label = nav.find((n) => n[0] === view)[1];
  for (const link of document.querySelectorAll("[data-view]"))
    link.dataset.view === view
      ? link.setAttribute("aria-current", "page")
      : link.removeAttribute("aria-current");
  placeThumb();
  $("#main").innerHTML =
    `<div class="breadcrumb">CAREGRID <span>/</span> ${label.toUpperCase()} <span>/</span> <b>SYNTHETIC DATA</b><span class="crumb-date">12 NOV 2026 · DEMO CLOCK</span></div>${{ overview, incident, responder, care, readiness, analytics }[view]()}<footer class="demo-foot"><span><i class="lime-dot"></i> Browser-local presentation · fictional campus · synthetic data</span><span>Built by <b>Team Duality</b> · Hriday Vig · Ishaan Sharma</span></footer>`;
  bind();
}
function openModal(html) {
  $("#modal-content").innerHTML =
    `<button class="modal-close icon-btn" aria-label="Close dialog">${icon("close")}</button>${html}`;
  $("#modal").showModal();
  $(".modal-close").onclick = () => $("#modal").close();
  $("#modal").addEventListener(
    "click",
    (e) => {
      if (e.target === $("#modal")) $("#modal").close();
    },
    { once: true },
  );
}
function bind() {
  document
    .querySelectorAll("[data-action]")
    .forEach((b) => (b.onclick = () => handle(b.dataset.action)));
  document.querySelectorAll("[data-filter]").forEach(
    (b) =>
      (b.onclick = () => {
        filter = b.dataset.filter;
        render();
      }),
  );
  document.querySelectorAll("[data-incident]").forEach(
    (b) =>
      (b.onclick = () => {
        if (b.dataset.incident === "CG-0217") location.hash = "incident";
        else
          openModal(
            `<div class="eyebrow">SUPPORTING SYNTHETIC CASE</div><h2>${esc(incidents.find((i) => i.id === b.dataset.incident).title)}</h2><p>This seeded case provides queue context. The complete interactive workflow is CG-0217.</p><a href="#incident" class="btn primary" onclick="document.querySelector('dialog').close()">Open the hero case ${icon("arrow")}</a>`,
          );
      }),
  );
  document.querySelectorAll("[data-fault]").forEach(
    (b) =>
      (b.onchange = () => {
        faults[b.dataset.fault] = b.checked;
        state.rehearsed = false;
        state.fix = false;
        save();
        render();
      }),
  );
}
function handle(action) {
  try {
    switch (action) {
      case "advance":
        state = advance(state, actionName());
        save();
        render();
        toast(
          state.stage === 6
            ? "Human closure recorded. Demo case resolved."
            : "Demo milestone recorded: " + status(),
        );
        break;
      case "escalate":
        state = escalate(state);
        save();
        render();
        toast("Missed acceptance escalated. Alternate A1 offered.");
        break;
      case "ready":
        state.hospitalReady = true;
        state.audit.unshift({
          at: "02:17:20",
          actor: "Medical team (demo)",
          text: "Receiving team marked ready.",
        });
        save();
        render();
        toast("Demo medical team marked ready.");
        break;
      case "rehearse":
        state.rehearsed = true;
        save();
        render();
        toast("Illustrative rehearsal complete. No live assets changed.");
        break;
      case "fix":
        state.fix = true;
        save();
        render();
        toast("Alternate access intervention modeled.");
        break;
      case "reset":
        openModal(
          `<span class="eyebrow">RESET LOCAL PROTOTYPE</span><h2>Replay a <em>fresh response.</em></h2><p>This clears only CareGrid’s synthetic state in this browser. It does not affect the Dart app or any cloud data.</p><button class="btn primary" id="confirm-reset">Reset synthetic demo ${icon("arrow")}</button>`,
        );
        $("#confirm-reset").onclick = () => {
          state = newState();
          faults = {
            ambulanceBusy: true,
            gateClosed: true,
            cameraDegraded: true,
          };
          save();
          render();
          toast("Local demo reset.");
        };
        break;
      case "scenario":
        openModal(
          `<span class="eyebrow">SCENARIO LIBRARY / SYNTHETIC INPUTS</span><h2>Choose the <em>night.</em></h2><p>Start a clean demo case. Workflow steps remain explicit so you can demonstrate each handoff.</p><button class="scenario-choice" id="hero"><span>01</span><div><b>The 02:17 hostel incident</b><small>Corroboration → dispatch → recorded care</small></div>${icon("arrow")}</button><button class="scenario-choice" id="missed"><span>02</span><div><b>The ambulance that never accepts</b><small>Missed ACK → escalation → alternate unit</small></div>${icon("arrow")}</button>`,
        );
        for (const id of ["hero", "missed"])
          $("#" + id).onclick = () => {
            state = newState();
            state.missedAck = id === "missed";
            save();
            view = "incident";
            location.hash = "incident";
            render();
            toast(
              id === "missed"
                ? "Missed-ACK scenario loaded. Confirm dispatch first."
                : "02:17 scenario loaded.",
            );
          };
        break;
      case "export": {
        const blob = new Blob(
          [
            JSON.stringify(
              {
                product: "CareGrid",
                team: "Duality",
                provenance:
                  "Synthetic browser-local demonstration; no live Google integrations",
                state,
              },
              null,
              2,
            ),
          ],
          { type: "application/json" },
        );
        const url = URL.createObjectURL(blob);
        const a = document.createElement("a");
        a.href = url;
        a.download = "caregrid-CG-0217-demo.json";
        a.click();
        setTimeout(() => URL.revokeObjectURL(url), 1000);
        toast("Synthetic case record exported.");
        break;
      }
      case "status":
        openModal(
          `<span class="eyebrow">CONNECTION & PROVENANCE</span><h2>Transparent <em>by design.</em></h2><div class="status-list"><p><i class="lime-dot"></i> Browser-local demo state <b>Ready</b></p><p>Serverpod API <b>Not used by this presentation</b></p><p>Google Cloud staging <b>Connected console only</b></p><p>Gemini drafting <b>Built · gated off</b></p><p>Camera / GPS / Google Maps <b>Illustrated</b></p></div><p>No emergency service is contacted. Notifications and all case data shown here are synthetic.</p>`,
        );
        break;
      case "about":
        openModal(
          `<span class="eyebrow">TEAM DUALITY / STARTUP BUILDATHON 2026</span><h2>From signal<br>to <em>verified care.</em></h2><p>Built by Hriday Vig and Ishaan Sharma.</p><p>The connected console runs on Cloud Run with Cloud SQL and Firebase sign-in in a staging project. Gemini drafts and Cloud Storage evidence are built and stay gated off until validated. This presentation remains browser-local.</p><a class="btn primary" href="/console">Open the connected console ${icon("arrow")}</a>`,
        );
        break;
    }
  } catch (e) {
    toast(e.message);
  }
}
window.addEventListener("hashchange", () => {
  view = location.hash.slice(1) || "overview";
  render();
  window.scrollTo(0, 0);
});
window.addEventListener("storage", (e) => {
  if (e.key === "caregrid.duality.v1") {
    try {
      const saved = JSON.parse(e.newValue);
      if (saved?.version === 1) {
        state = saved;
        render();
      }
    } catch {}
  }
});
render();
if (new URLSearchParams(location.search).has("inspect"))
  document.fonts.ready.then(() => {
    document.documentElement.dataset.viewport = String(innerWidth);
    document.documentElement.dataset.contentWidth = String(
      document.documentElement.scrollWidth,
    );
    document.documentElement.dataset.layoutOverflow = String(
      document.documentElement.scrollWidth > innerWidth,
    );
  });
