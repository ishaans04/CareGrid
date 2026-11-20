import {
  escapeHtml as e,
  label,
  duration,
  clock,
  openIncident,
  activeDispatch,
  proofSteps,
  nextResponderAction,
  navigationFor,
  incidentStage,
} from "./connected-domain.mjs";

import { renderBriefing } from "./briefing-view.mjs";
import { EvidenceController, renderEvidence } from "./evidence-view.mjs";
import { glassThumb, glassScroll } from "./glass.mjs";

const app = document.querySelector("#app");
const dialog = document.querySelector("#action-dialog");
const state = {
  user: null,
  accounts: [],
  view: "",
  data: {},
  selected: null,
  detail: null,
  detailKey: null,
  busy: false,
  fetching: false,
  error: "",
  lastSync: 0,
  epoch: 0,
  readiness: null,
  runs: [],
  config: null,
  brief: null,
  briefBusy: false,
  briefEpoch: 0,
  timelineOpen: false,
};
let identity;
let toastTimer;
let modalAction;
let pendingSync = Promise.resolve();
// Render cache: the shell skeleton, the bar markup and the last workspace HTML.
let shellKey = "";
let barKey = "";
let mainHtml = "";
let placeThumb = () => {};
async function api(path, { method = "GET", body, signal } = {}) {
  let response;
  try {
    const token = await identity?.token();
    response = await fetch(`/api/${path}`, {
      method,
      credentials: "same-origin",
      cache: "no-store",
      signal: signal || AbortSignal.timeout(13_000),
      headers: {
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        "X-CareGrid-Request": "1",
        ...(body ? { "Content-Type": "application/json" } : {}),
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
  } catch {
    throw Error(
      "Connection lost. Check the service and your connection, then reconnect. Your action has not been retried.",
    );
  }
  const result = await response.json();
  if (!response.ok) {
    const error = Error(
      result.error?.message || "The action could not be completed.",
    );
    error.status = response.status;
    throw error;
  }
  return result.data;
}
const rpc = (endpoint, method, body = {}) =>
  api(`rpc/${endpoint}/${method}`, { method: "POST", body });
const evidence = new EvidenceController({ rpc, changed: () => shell() });
const pill = (text, type = "") =>
  `<span class="pill ${type}">${e(text)}</span>`;
const empty = (title, message) =>
  `<div class="empty"><h3>${e(title)}</h3><p>${e(message)}</p></div>`;
// Actions that stay available while the connection needs attention.
const offlineSafe = [
  "refresh",
  "logout",
  "close-dialog",
  "select-incident",
  "google-signin",
  "toggle-timeline",
];
const button = (
  text,
  action,
  {
    primary = false,
    danger = false,
    quiet = false,
    small = false,
    id = "",
    disabled = false,
  } = {},
) =>
  `<button type="button" class="${["button", primary && "primary", danger && "danger", quiet && "quiet", small && "small"].filter(Boolean).join(" ")}" data-action="${action}" ${id !== "" ? `data-id="${e(id)}"` : ""} ${state.busy || disabled || (state.error && !offlineSafe.includes(action)) ? "disabled" : ""}>${e(text)}</button>`;
const note = (message) => {
  const target = document.querySelector("#notice");
  target.textContent = message;
  target.classList.add("visible");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => target.classList.remove("visible"), 5000);
};
// Page introduction: one line of context, a functional title, optional actions.
const intro = (eyebrow, title, description = "", actions = "") =>
  `<header class="intro"><div class="intro-text"><p class="eyebrow">${eyebrow}</p><h1>${e(title)}</h1>${description ? `<p>${e(description)}</p>` : ""}</div>${actions ? `<div class="intro-actions">${actions}</div>` : ""}</header>`;
// Inline figures separated by hairlines: status at a glance, no boxes.
const stat = (name, value, hint = "", tone = "") =>
  `<div class="stat metric ${tone}"><span class="stat-name">${e(name)}</span><strong>${e(value)}</strong>${hint ? `<small>${e(hint)}</small>` : ""}</div>`;
const stats = (items) =>
  `<section class="stats" aria-label="Status">${items.join("")}</section>`;
// A numbered step in a reading flow, joined to the next by the flow rule.
const step = (n, title, body, aside = "", classes = "") =>
  `<section class="step ${classes}"><header class="step-head"><span class="step-n" aria-hidden="true">${String(n).padStart(2, "0")}</span><h3>${e(title)}</h3>${aside ? `<div class="step-aside">${aside}</div>` : ""}</header><div class="step-body">${body}</div></section>`;
const block = (title, body, aside = "", classes = "") =>
  `<section class="block ${classes}"><header class="block-head"><h2>${e(title)}</h2>${aside}</header>${body}</section>`;
const banner = () =>
  state.error
    ? `<div class="error-banner" role="alert"><div><p>${e(state.error)}</p><small>Last successful sync: ${state.lastSync ? clock(state.lastSync) : "not yet connected"}. Refresh before repeating an action.</small></div>${button("Reconnect", "refresh")}</div>`
    : "";
const campusName = () => state.config?.campus || "Meridian Demo Campus";
const viewTitle = () =>
  navigationFor(state.user?.role).find(([key]) => key === state.view)?.[1] ||
  "Workspace";

const brand = `<a class="gbar-brand" href="/" aria-label="CareGrid home"><img src="assets/mark.svg" alt="" width="24" height="24"/><span>CareGrid</span><small>Console</small></a>`;
const roleLegend = [
  ["CMD", "Command", "Owns each incident and approves dispatch."],
  ["RSP", "Responder", "One assignment and the next step."],
  ["MED", "Medical", "Prepares the receiving team."],
  ["ADM", "Administrator", "Readiness, analytics and audit."],
  ["MBR", "Member", "Requests help and follows it."],
];
function accountOptions() {
  const campuses = new Map();
  for (const account of state.accounts) {
    const campus = account.campusName || campusName();
    if (!campuses.has(campus)) campuses.set(campus, []);
    campuses.get(campus).push(account);
  }
  const option = (account) =>
    `<option value="${e(account.handle)}">${e(account.displayName)} · ${e(label(account.role))}</option>`;
  return campuses.size > 1
    ? [...campuses]
        .map(
          ([campus, accounts]) =>
            `<optgroup label="${e(campus)}">${accounts.map(option).join("")}</optgroup>`,
        )
        .join("")
    : state.accounts.map(option).join("");
}
function login() {
  shellKey = "";
  mainHtml = "";
  barKey = "";
  const firebase = state.config?.authentication === "firebase";
  const googleSignIn = `<div class="login-google">${button(state.busy ? "Signing in…" : "Continue with Google", "google-signin", { primary: true })}<p class="muted small">Use the account assigned by your campus administrator. Access follows your CareGrid role.</p></div>`;
  app.innerHTML = `<header class="gbar" data-gbar><div class="gbar-inner">${brand}<div class="gbar-end"><a class="btn hide-sm" href="/">Overview</a><a class="btn" href="/demo">Interactive demo</a></div></div></header><main id="main" class="login"><section class="login-story"><p class="eyebrow"><b>Response workspace</b> · Team Duality</p><h1 class="login-title">Every signal.<br />An owner.<br /><em>A response.</em></h1><p class="login-lead">One shared record for the command desk, the people responding and the team preparing to receive them. Each role sees what its part of the response requires.</p><ol class="role-legend">${roleLegend.map(([code, name, text]) => `<li><span>${code}</span><b>${name}</b><small>${text}</small></li>`).join("")}</ol></section><section class="login-card"><p class="eyebrow campus-line"><i class="dot"></i>${e(campusName())}</p><h2>Take your place.</h2><p class="muted">Sign in to the workspace for your role.</p>${banner()}${firebase ? googleSignIn : state.accounts.length ? `<form id="login-form"><label>Demo account<select name="handle" required>${accountOptions()}</select><small id="account-description"></small></label><label>Demo PIN<input name="pin" type="password" inputmode="numeric" maxlength="30" autocomplete="off" required aria-describedby="pin-hint"/><small id="pin-hint"></small></label><button class="button primary full" ${state.busy ? "disabled" : ""}>${state.busy ? "Signing in…" : "Enter workspace"}</button></form>` : empty("Service is not available", "Run node scripts/dev.mjs from the repository to start the backend and this console.")}<p class="login-note">${firebase ? "Google staging MVP · synthetic campus. Sign-in stays in memory and clears when this page reloads. For another role, use a separate tab." : "Connected local MVP · synthetic campus and seeded demo PINs. For a second role, open a separate browser profile or private window."} <a href="/demo">Open the pitch presentation</a>.</p></section></main>`;
  glassScroll();
  accountHint();
}
function accountHint() {
  const select = document.querySelector('[name="handle"]');
  const account = state.accounts.find((item) => item.handle === select?.value);
  if (!account) return;
  document.querySelector("#account-description").textContent =
    account.description;
  document.querySelector("#pin-hint").textContent =
    `Seeded demo PIN: ${account.pinHint}`;
}
function shell() {
  evidence.context({
    incidentId:
      state.user?.role === "command" &&
      state.view === "overview" &&
      state.detail?.incident.id === state.selected
        ? state.selected
        : null,
    userId: state.user?.id,
    offline: Boolean(state.error),
    blocked: state.busy,
  });
  if (!state.user) return login();
  const nav = navigationFor(state.user.role);
  if (!nav.some(([key]) => key === state.view)) state.view = nav[0]?.[0];
  const view = { overview, response, care, readiness, analytics, audit, sos }[
    state.view
  ];
  // The glass bar is built once per signed-in identity. Changing view only
  // moves the active marker, so the thumb glides instead of being rebuilt.
  const key = `${state.user.id}|${state.user.role}`;
  if (key !== shellKey) {
    shellKey = key;
    mainHtml = "";
    barKey = "";
    app.innerHTML = `<div class="shell" data-role="${e(state.user.role)}"><header class="gbar console-bar" data-gbar id="console-bar"></header><main id="main" class="main" tabindex="-1"></main></div>`;
    glassScroll();
  }
  renderBar(nav);
  const next = `<div id="connection-error">${banner()}</div>${state.lastSync ? view() : empty("Loading your workspace", "Reading the campus state from CareGrid…")}<footer class="context-note">${state.config?.authentication === "firebase" ? "Team Duality · Google staging MVP · Synthetic campus data. Camera analysis, live telemetry and notification delivery remain separate integrations." : "Team Duality · Synthetic local MVP · The server enforces each account’s permissions. Camera analysis, mobile telemetry and real notifications remain planned integrations."}</footer>`;
  updateConnection();
  // Polling re-renders only when the workspace actually changed.
  if (next === mainHtml) return;
  mainHtml = next;
  const main = document.querySelector("#main");
  const focus = document.activeElement;
  const focusKey = focus?.dataset?.focus;
  const activeField = focus?.name;
  const activeFormId = focus?.closest("form")?.id;
  const selection = [focus?.selectionStart, focus?.selectionEnd];
  // Retain drafts and keyboard position when polling replaces the workspace.
  const drafts = new Map(
    [...main.querySelectorAll("form")].map((form) => [
      form.id,
      new FormData(form),
    ]),
  );
  main.innerHTML = next;
  tickCountdowns();
  for (const [id, values] of drafts) {
    const form = document.getElementById(id);
    if (form)
      for (const [name, value] of values) {
        const field = form.elements.namedItem(name);
        if (field && typeof value === "string") field.value = value;
      }
  }
  if (activeField && activeFormId) {
    const field = document
      .getElementById(activeFormId)
      ?.elements.namedItem(activeField);
    field?.focus({ preventScroll: true });
    if (
      selection[0] != null &&
      ["text", "search", "password"].includes(field?.type)
    )
      field.setSelectionRange(...selection);
  }
  if (focusKey)
    document
      .querySelector(`[data-focus="${CSS.escape(focusKey)}"]`)
      ?.focus({ preventScroll: true });
}
// Deadline countdowns tick in place; the workspace HTML is not re-rendered.
function tickCountdowns() {
  const now = Date.now();
  for (const element of document.querySelectorAll("[data-due]")) {
    const ms = Date.parse(element.dataset.due) - now;
    if (!Number.isFinite(ms)) continue;
    const text = `${ms >= 0 ? "in" : "overdue by"} ${duration(Math.abs(ms) / 1000)}`;
    if (element.textContent !== text) element.textContent = text;
    element.classList.toggle("late", ms < 0);
  }
}
setInterval(tickCountdowns, 1000);
function initials(name) {
  return (
    String(name || "")
      .split(/\s+/)
      .filter((word) => /^[A-Za-z]/.test(word) && !word.endsWith("."))
      .map((word) => word[0].toUpperCase())
      .slice(0, 2)
      .join("") || "CG"
  );
}
function renderBar(nav) {
  const bar = document.querySelector("#console-bar");
  const key = JSON.stringify([
    nav,
    state.user.displayName,
    state.user.title,
    state.config?.campus,
  ]);
  if (key !== barKey) {
    barKey = key;
    bar.innerHTML = `<div class="gbar-inner">${brand}<nav class="gbar-nav" aria-label="Workspace"><span class="gbar-thumb" aria-hidden="true"></span>${nav.map(([view, title], index) => `<button type="button" class="gbar-link" data-action="navigate" data-id="${view}" data-focus="nav-${view}"><small aria-hidden="true">0${index + 1}</small>${e(title)}</button>`).join("")}</nav><div class="gbar-end"><div class="topbar-status" id="connection-status"></div><div class="identity" title="${e(state.user.displayName)} · ${e(state.user.title)}"><span class="gbar-avatar" aria-hidden="true">${e(initials(state.user.displayName))}</span><span class="identity-text"><strong>${e(state.user.displayName)}</strong><small>${e(label(state.user.role))} · ${e(campusName())}</small></span></div><button type="button" class="btn signout" data-action="logout">Sign out</button></div></div>`;
    placeThumb = glassThumb(bar.querySelector(".gbar-nav"));
  }
  for (const item of bar.querySelectorAll('[data-action="navigate"]'))
    item.dataset.id === state.view
      ? item.setAttribute("aria-current", "page")
      : item.removeAttribute("aria-current");
  for (const control of bar.querySelectorAll("button"))
    control.disabled = state.busy;
  placeThumb();
}
let connectionHtml = "";
function updateConnection() {
  const target = document.querySelector("#connection-status");
  if (!target) return;
  const next = `<span class="dot ${state.error ? "warn" : ""}"></span><span class="sync-text">${state.error ? "Connection needs attention" : `Synced ${clock(state.lastSync)}`}</span>`;
  if (next !== connectionHtml || !target.firstChild) {
    connectionHtml = next;
    target.innerHTML = next;
  }
}

/* ───────── Campus schematic ───────── */
const landmarks = new Set(["HB", "HOS", "LIB", "LAB", "SPT", "COM", "SEC"]);
const shortName = (name) =>
  name
    .replace("Sports Complex", "Sports")
    .replace("Chemistry Labs", "Labs")
    .replace("Security Control Room", "Command")
    .replace("Campus Hospital", "Hospital")
    .replace("Student Commons", "Commons");
function map(
  twin = state.data.twin,
  highlightedRoute = [],
  { compact = false } = {},
) {
  if (!twin)
    return empty("Campus map unavailable", "The campus twin has not loaded.");
  const zones = new Map(twin.zones.map((zone) => [zone.code, zone]));
  const active = new Set(
    (twin.activeIncidents || []).map((incident) => incident.zoneCode),
  );
  const onRoute = new Set(highlightedRoute);
  const roads = twin.roads
    .map((road) => {
      const a = zones.get(road.fromZone),
        b = zones.get(road.toZone);
      if (!a || !b) return "";
      const selected = highlightedRoute.some(
        (code, index) =>
          index &&
          [code, highlightedRoute[index - 1]].includes(a.code) &&
          [code, highlightedRoute[index - 1]].includes(b.code),
      );
      const blocked = road.status === "blocked";
      return `<line x1="${Number(a.x)}" y1="${Number(a.y)}" x2="${Number(b.x)}" y2="${Number(b.y)}" class="${selected ? "road route" : blocked ? "road blocked" : "road"}"/>`;
    })
    .join("");
  const nodes = twin.zones
    .map((zone) => {
      const x = Number(zone.x),
        y = Number(zone.y);
      const incident = active.has(zone.code);
      const hospital = zone.type === "hospital";
      const named =
        incident ||
        hospital ||
        (compact
          ? onRoute.has(zone.code) && zone.code === highlightedRoute[0]
          : landmarks.has(zone.code));
      return `<g class="${incident ? "node incident" : hospital ? "node hospital" : onRoute.has(zone.code) ? "node on-route" : "node"}"><title>${e(zone.name)}</title>${incident ? `<circle cx="${x}" cy="${y}" r="34" class="halo"/>` : ""}<circle cx="${x}" cy="${y}" r="${incident ? 13 : hospital ? 11 : 6}"/>${named ? `<text x="${x + 20}" y="${y - 16}">${e(shortName(zone.name))}</text>` : ""}</g>`;
    })
    .join("");
  return `<svg class="schematic ${compact ? "compact" : ""}" viewBox="-40 -40 1150 800" role="img" aria-label="Schematic campus graph; highlighted zones carry active incidents. Positions are campus nodes, not live GPS.">${roads}${nodes}</svg><div class="map-legend"><span><i class="key incident"></i>Incident</span><span><i class="key hospital"></i>Hospital</span><span><i class="key route"></i>Route</span><span><i class="key blocked"></i>Blocked</span><span class="legend-note">Schematic · no live GPS</span></div>`;
}

/* ───────── Command centre: queue, focus and flow ───────── */
function overview() {
  const board = state.data.board;
  if (!board)
    return empty(
      "Campus board unavailable",
      "Reconnect to load the operational state.",
    );
  const awaiting = board.active.filter((incident) => !incident.unitsAssigned);
  const responding = board.active.filter((incident) => incident.unitsAssigned);
  const simulation = state.data.simulation;
  const rehearsing = simulation?.runs.some((run) => run.status === "running");
  const command = state.user.role === "command";
  const group = (title, items) =>
    `<section class="queue-group"><h2 class="queue-title">${e(title)}<span>${items.length}</span></h2>${items.length ? items.map(incidentRow).join("") : `<p class="queue-none">Nothing here.</p>`}</section>`;
  return `${intro(`${e(campusName())} · ${command ? "Night operations" : "Campus overview"}`, viewTitle(), "", `${simulation ? button("Rehearse a scenario", "rehearse") : ""}${button("Refresh", "refresh", { quiet: true })}`)}${stats(
    [
      stat(
        "Open incidents",
        board.active.length,
        "Sorted by urgency",
        board.active.length ? "flare" : "mint",
      ),
      stat(
        "Units available",
        `${board.respondersAvailable}/${board.respondersTotal}`,
        "Recorded availability",
      ),
      stat(
        "Escalations open",
        board.escalatedOpen,
        "Deadlines needing attention",
        board.escalatedOpen ? "flare" : "",
      ),
      stat(
        "Degraded cameras",
        `${board.camerasDegraded}/${board.camerasTotal}`,
        "Seeded asset health",
        board.camerasDegraded ? "amber" : "",
      ),
    ],
  )}${rehearsing ? `<div class="strip">${pill("Rehearsal running", "good")}<span>Rehearsal incidents are labelled and use simulated travel.</span>${button("End open rehearsals", "clear-simulations", { small: true })}</div>` : ""}<div class="ops"><nav class="queue" aria-label="Incident queue">${board.active.length ? `${group("Awaiting decision", awaiting)}${group("In response", responding)}` : `<div class="queue-calm"><span class="dot"></span><h2>All clear</h2><p>No open incidents. ${simulation ? "Start a labelled rehearsal, or send an SOS from a member account." : "New signals appear here as they arrive."}</p></div>`}${board.recent.length ? group("Closed recently", board.recent.slice(0, 5)) : ""}</nav><div class="stage">${incidentDetail()}</div></div>`;
}
function incidentRow(incident) {
  const urgent = ["p0", "p1"].includes(incident.severity);
  const open = openIncident(incident);
  const escalation = incident.escalationLevel
    ? ` · Escalated${incident.escalationLevel > 1 ? ` ×${incident.escalationLevel > 99 ? "99+" : incident.escalationLevel}` : ""}`
    : "";
  return `<button class="incident-row ${state.selected === incident.id ? "selected" : ""} ${open ? (urgent ? "urgent" : "") : "closed"}" data-action="select-incident" data-id="${incident.id}" data-focus="incident-${incident.id}"><span class="row-top"><span class="row-code">${e(incident.code)}</span>${pill(incident.severity.toUpperCase(), open && urgent ? "warn" : "")}${incident.fromScenario ? pill("Sim") : ""}<time>${clock(incident.onsetAt).slice(0, 5)}</time></span><strong>${e(incident.title)}</strong><span class="row-sub">${e(incident.zoneName)} · ${e(label(incident.state))}${incident.unitsAssigned ? ` · ${incident.unitsArrived}/${incident.unitsAssigned} arrived` : ""}${escalation}</span></button>`;
}
const stageLabels = [
  "Signal",
  "Verified",
  "Dispatched",
  "Acknowledged",
  "En route",
  "On scene",
  "Care",
  "Closed",
];
function spine(incidentState) {
  const at = incidentStage(incidentState);
  const finished = at === stageLabels.length - 1;
  return `<ol class="spine" aria-label="Response progress: ${e(label(incidentState))}">${stageLabels
    .map(
      (name, index) =>
        `<li class="${index < at || finished ? "done" : index === at ? "now" : ""}"><span>${index === 7 && incidentState === "dismissed" ? "Stood down" : name}</span></li>`,
    )
    .join("")}</ol>`;
}
function proofMatrix(detail, can) {
  const columns = [
    ["Offered", "offeredAt"],
    ["Acknowledged", "acknowledgedAt"],
    ["Departed", "enRouteAt"],
    ["Arrived", "onSceneAt"],
    ["Care", "careAt"],
  ];
  return `<div class="matrix-wrap"><table class="matrix"><thead><tr><th scope="col">Unit</th>${columns.map(([name]) => `<th scope="col">${name}</th>`).join("")}<th scope="col">Status</th></tr></thead><tbody>${detail.dispatches
    .map(
      (dispatch) =>
        `<tr class="${dispatch.stalled ? "stalled" : ""}"><th scope="row"><strong>${e(dispatch.responderName)}</strong><small>${dispatch.arrivalSource ? `Arrival by ${e(label(dispatch.arrivalSource))}` : `ETA ${duration(dispatch.etaSeconds)} · arrival unconfirmed`}${dispatch.stalled ? " · contact unit" : ""}</small>${dispatch.note ? `<small>${e(dispatch.note)}</small>` : ""}</th>${columns.map(([name, key]) => `<td data-label="${name}" class="${dispatch[key] ? "done" : ""}"><i aria-hidden="true"></i><span>${dispatch[key] ? clock(dispatch[key]) : "—"}</span></td>`).join("")}<td class="matrix-status">${pill(label(dispatch.status), dispatch.stalled ? "warn" : ["care", "completed"].includes(dispatch.status) ? "good" : "")}${can("releaseUnit") && activeDispatch(dispatch) ? button("Stand down unit", "release-unit", { small: true, quiet: true, id: dispatch.id }) : ""}</td></tr>`,
    )
    .join(
      "",
    )}</tbody></table></div><p class="step-note">The incident stage follows the furthest unit. Each assignment is proved separately; an ETA never counts as arrival.</p>`;
}
function incidentDetail() {
  const detail = state.detail;
  if (!detail || detail.incident.id !== state.selected)
    return `<div class="stage-empty">${empty(
      state.selected == null
        ? "Choose an incident"
        : "Loading selected incident",
      state.selected == null
        ? "The decision, its evidence and the response record will appear here."
        : "Retrieving the selected response record.",
    )}</div>`;
  const incident = detail.incident;
  const allowed = detail.allowedActions;
  const can = (key) => allowed.includes(key);
  const route = detail.plan?.options[0];
  const open = openIncident(incident);
  const urgent = ["p0", "p1"].includes(incident.severity);
  const command = state.user.role === "command";
  const routeNodes =
    detail.dispatches.find((unit) => unit.route.length > 1)?.route ||
    detail.plan?.options.find((unit) => unit.route.length > 1)?.route ||
    [];
  const primary = [
    can("confirmDispatch") && !incident.dispatchedAt
      ? button("Approve recommended dispatch", "dispatch", {
          primary: true,
          id: incident.id,
          disabled: !route,
        })
      : "",
    can("resolve")
      ? button("Record outcome & close", "resolve", {
          primary: true,
          id: incident.id,
        })
      : "",
    can("claim") ? button("Take ownership", "claim", { id: incident.id }) : "",
  ].join("");
  const secondary = [
    can("note")
      ? button("Add a note", "incident-note", {
          quiet: true,
          small: true,
          id: incident.id,
        })
      : "",
    can("escalate")
      ? button("Escalate", "escalate", {
          quiet: true,
          small: true,
          id: incident.id,
        })
      : "",
    can("dismiss")
      ? button("Stand down with reason", "dismiss", {
          quiet: true,
          small: true,
          danger: true,
          id: incident.id,
        })
      : "",
  ].join("");
  const decision =
    incident.nextAction ||
    (open
      ? "Follow each unit until care is recorded."
      : incident.state === "dismissed"
        ? "This incident was stood down."
        : "This response is closed with a recorded outcome.");
  let n = 0;
  const steps = [];
  if (incident.reasoning?.length)
    steps.push(
      step(
        ++n,
        "Evidence & policy",
        `<ul class="reasons">${incident.reasoning.map((reason) => `<li>${e(reason)}</li>`).join("")}</ul><p class="step-note">${Math.round(incident.confidence * 100)}% signal score (uncalibrated) · ${e(label(incident.observability))} observability · ${detail.signals.length} visible signals. Deterministic policy evaluation; optional handoff drafts do not control this decision.</p>`,
        pill(incident.policyCode || "Policy review"),
      ),
    );
  if (detail.dispatches.length)
    steps.push(
      step(
        ++n,
        "Proof of response · per unit",
        proofMatrix(detail, can),
        pill(`${detail.dispatches.length} UNITS`),
      ),
    );
  else if (detail.plan)
    steps.push(
      step(
        ++n,
        "Recommended response",
        `${detail.plan.options.length ? `<ul class="plan">${detail.plan.options.map((option) => `<li><div><strong>${e(option.responderName)}</strong><small>${e(option.role)} · ${option.distanceMeters}m · ${e(option.routeNames.join(" → "))}</small></div>${pill(duration(option.etaSeconds), option.withinSla ? "good" : "warn")}</li>`).join("")}</ul>` : `<p class="muted">No unit can be recommended right now.</p>`}${detail.plan.warnings.map((warning) => `<p class="callout">${e(warning)}</p>`).join("")}`,
        pill("Deterministic"),
      ),
    );
  if (command)
    steps.push(
      step(
        ++n,
        "Handoff and evidence",
        `<div class="tools">${renderBriefing({ incidentId: incident.id, brief: state.brief, busy: state.briefBusy, offline: Boolean(state.error) })}${renderEvidence(evidence.snapshot)}</div>`,
        pill("Optional"),
      ),
    );
  const entries = [...detail.timeline].reverse();
  const shown = state.timelineOpen ? entries : entries.slice(0, 6);
  steps.push(
    step(
      ++n,
      "Response timeline",
      `<ol class="timeline">${shown.map((entry) => `<li class="timeline-entry"><time datetime="${e(entry.at)}">${clock(entry.at)}</time><div><strong>${e(entry.actor)}</strong><p>${e(entry.message)}</p></div></li>`).join("")}</ol>${entries.length > 6 ? button(state.timelineOpen ? "Show the latest entries" : `Show all ${entries.length} entries`, "toggle-timeline", { quiet: true, small: true }) : ""}${detail.redactions.length ? `<p class="step-note">Restricted for this role: ${e(detail.redactions.join("; "))}</p>` : ""}`,
      pill("Latest first"),
    ),
  );
  return `<article class="case"><header class="detail-heading"><div class="case-tags"><span class="case-code">${e(incident.code)}</span>${pill(incident.severity.toUpperCase(), open && urgent ? "warn" : "")}${pill(label(incident.state), open ? "warn" : "good")}${incident.scenarioRunId ? pill("Simulation") : ""}</div><h2>${e(incident.title)}</h2><p class="case-where">${e(detail.zoneName)}${incident.locationDetail ? ` · ${e(incident.locationDetail)}` : ""}</p><dl class="case-facts"><div><dt>Owner</dt><dd>${e(incident.ownerName || "Unclaimed")}</dd></div><div><dt>Onset</dt><dd>${clock(incident.onsetAt)}</dd></div><div><dt>Signal</dt><dd>${Math.round(incident.confidence * 100)}% · ${e(label(incident.observability))}</dd></div></dl>${spine(incident.state)}</header><div class="focus"><section class="decide ${open ? "" : "settled"}" aria-label="Next decision"><p class="eyebrow"><b>Now</b> · ${open ? "next decision" : "outcome"}</p><p class="now-text">${e(decision)}</p>${incident.nextDeadline ? `<p class="now-due">${e(incident.nextDeadlineLabel || "Deadline")} · due ${clock(incident.nextDeadline)} <span class="countdown" data-due="${e(incident.nextDeadline)}"></span></p>` : ""}${incident.closureNote ? `<p class="now-outcome">${e(incident.closureNote)}</p>` : ""}${primary ? `<div class="now-actions">${primary}</div>` : ""}${secondary ? `<div class="now-more">${secondary}</div>` : ""}</section><figure class="focus-map">${map(state.data.twin, routeNodes, { compact: true })}</figure></div><div class="flow">${steps.join("")}</div></article>`;
}
function openRehearse() {
  const simulation = state.data.simulation;
  if (!simulation) return;
  modalAction = null;
  dialog.innerHTML = `<form id="scenario-form" class="dialog-body"><div><p class="eyebrow"><b>Rehearsal</b> · labelled simulation</p><h2 id="dialog-title">Rehearse a real workflow</h2><p>Signals enter the real backend and create audited incidents. Every rehearsal incident is labelled and uses simulated travel. Use a member SOS to demonstrate responder-confirmed arrival.</p></div><label>Scenario<select name="scenario">${simulation.scenarios.map((scenario) => `<option value="${e(scenario.code)}">${e(scenario.title)}</option>`).join("")}</select></label><label>Control<select name="autopilot"><option value="false">Manual response</option><option value="true">Autopilot simulation</option></select></label><p class="dialog-error" id="dialog-error" role="alert"></p><div class="row">${button("Cancel", "close-dialog")}<button class="button primary" ${state.busy ? "disabled" : ""}>Start rehearsal</button></div></form>`;
  dialog.showModal();
}

/* ───────── Responder ───────── */
function response() {
  const home = state.data.home;
  if (!home)
    return empty("Assignment unavailable", "Reconnect to load your unit.");
  const task = home.task;
  const head = intro(
    `${e(home.responder.code)} · Responder`,
    viewTitle(),
    "Acknowledge, move, confirm arrival and record care. Each step reaches the command desk.",
  );
  if (!task) {
    const available = home.responder.status === "available";
    return `${head}<section class="idle"><div class="idle-head"><span class="beacon ${available ? "on" : ""}" aria-hidden="true"></span><div><h2>${e(home.responder.name)}</h2><p>${available ? "Ready for the next call." : "Currently off duty."} Recorded location: ${e(home.zoneName)}.</p></div>${pill(label(home.responder.status), available ? "good" : "")}</div><p class="muted">No active assignment is attached to this account.</p>${button(available ? "Go off duty" : "Mark available", "availability", { id: !available, primary: true })}</section>`;
  }
  const dispatch = task.dispatch;
  const next = nextResponderAction(dispatch.status);
  const steps = [
    ["Offered", "offeredAt"],
    ["Acknowledged", "acknowledgedAt"],
    ["Departed", "enRouteAt"],
    ["Arrived", "onSceneAt"],
    ["Care started", "careAt"],
  ];
  return `${head}<article class="task"><header class="task-hero"><div class="case-tags"><span class="case-code">${e(task.incidentCode)}</span>${pill(task.severity.toUpperCase(), "warn")}${pill(label(dispatch.status), "good")}</div><h2>${e(task.zoneName)}</h2><p class="task-where">${e(task.locationDetail || "Exact location has not been supplied")}</p><p class="task-nature">${e(task.nature)}</p></header><ol class="task-steps">${steps.map(([title, key]) => `<li class="${dispatch[key] ? "done" : ""}"><span>${title}</span><time>${dispatch[key] ? clock(dispatch[key]) : "—"}</time></li>`).join("")}</ol><div class="task-body"><section><p class="eyebrow">Route</p><h3>${e(task.routeNames.join(" → "))}</h3><p class="muted">${dispatch.distanceMeters}m · ${duration(dispatch.etaSeconds)} estimated mobilisation and travel</p>${task.otherResponders.length ? `<p class="muted small">Also assigned: ${e(task.otherResponders.join("; "))}</p>` : ""}</section><section><p class="eyebrow">Instructions</p><ol class="instructions">${task.instructions.map((instruction) => `<li>${e(instruction)}</li>`).join("")}</ol></section></div><p class="task-note ${dispatch.stalled ? "late" : ""}">${dispatch.stalled ? "This assignment is overdue. Contact command and confirm your status." : dispatch.arrivalSource ? `Arrival recorded by ${e(label(dispatch.arrivalSource))}.` : "An ETA never confirms your arrival. Use the on-scene action when you reach the incident."}</p><footer class="task-action">${next ? button(next[1], "responder-step", { primary: true, id: next[0] }) : ""}${["offered", "acknowledged"].includes(dispatch.status) ? button("Unable to respond", "decline", { danger: true, quiet: true, id: dispatch.id }) : ""}<p class="small muted">${task.hospitalNotified ? "The care team has been pre-alerted." : "Command coordinates any additional care support."}</p></footer></article>`;
}

/* ───────── Care ───────── */
function careCase(item) {
  const open = openIncident(item);
  const medical = state.user.role === "medical";
  const handoff = [
    ["Pre-alerted", true, clock(item.onsetAt)],
    [
      "Team & bay",
      item.hospitalReady,
      item.hospitalReady ? "Ready to receive" : "Awaiting confirmation",
    ],
    [
      "Ambulance",
      Boolean(item.ambulanceCode),
      item.ambulanceCode
        ? `${item.ambulanceCode} · ${item.ambulanceStatus || "Assigned"}`
        : "Pending dispatch",
    ],
    [
      "Scene ETA",
      Boolean(item.sceneEta),
      item.sceneEta ? `${clock(item.sceneEta)} · estimate` : "Not available",
    ],
  ];
  return `<article class="case-card ${open ? "" : "closed"}"><div class="case-card-main"><div class="case-tags"><span class="case-code">${e(item.code)}</span>${pill(item.severity.toUpperCase(), open ? "warn" : "")}</div><h2>${e(item.zoneName)}</h2><p class="case-where">${e(item.locationDetail || "Location detail not supplied")}</p><p class="case-nature">${e(item.nature)}</p><p class="case-state ${open ? "" : "done"}">${e(item.handoffState)}</p></div><ol class="handoff">${handoff.map(([title, done, value]) => `<li class="${done ? "done" : ""}"><span>${title}</span><strong>${e(value)}</strong></li>`).join("")}</ol>${item.careNotes.length ? `<div class="care-notes"><p class="eyebrow">Care record</p>${item.careNotes.map((message) => `<p>${e(message)}</p>`).join("")}</div>` : ""}${open ? `<div class="case-actions">${medical && !item.hospitalReady ? button("Confirm team & bay ready", "care-ready", { primary: true, id: item.incidentId }) : ""}${button("Add care note", "care-note", { id: item.incidentId })}${medical ? button("Escalate to command", "escalate", { quiet: true, id: item.incidentId }) : ""}</div>` : ""}</article>`;
}
function care() {
  const cases = state.data.cases || [];
  const open = cases.filter((item) => openIncident(item));
  const closed = cases.filter((item) => !openIncident(item));
  return `${intro("Care coordination · minimum necessary context", viewTitle(), "Receiving teams see the incident context and handoff record. Camera evidence stays with command.")}${stats(
    [
      stat(
        "Pre-alerts",
        open.length,
        "Open cases shared with care",
        open.length ? "flare" : "",
      ),
      stat(
        "Team ready",
        open.filter((item) => item.hospitalReady).length,
        "Confirmed by care",
        "mint",
      ),
      stat(
        "Care in progress",
        cases.filter((item) => item.state === "care").length,
        "Recorded by responders",
      ),
      stat("Closed", cases.length - open.length, "Recent 12-hour window"),
    ],
  )}${open.length ? `<section class="care-group"><h2 class="group-title">Needs preparation<span>${open.length}</span></h2><div class="cases">${open.map(careCase).join("")}</div></section>` : `<div class="calm">${empty("No open pre-alerts", "Cases appear here when the backend notifies the receiving team.")}</div>`}${closed.length ? `<section class="care-group"><h2 class="group-title">Closed in the last 12 hours<span>${closed.length}</span></h2><ol class="closed-list">${closed.map((item) => `<li class="closed-row"><span class="case-code">${e(item.code)}</span><strong>${e(item.zoneName)}</strong><span class="closed-where">${e(item.locationDetail || "Location not supplied")}</span><span class="closed-state">${e(item.handoffState)}</span><time>${clock(item.onsetAt).slice(0, 5)}</time></li>`).join("")}</ol></section>` : ""}`;
}

/* ───────── Readiness, analytics, audit ───────── */
function runRow(run) {
  const pass = run.verdict === "pass";
  const scale =
    Math.max(
      run.slaSeconds,
      run.predictedSeconds,
      run.predictedAfterFixSeconds || 0,
    ) * 1.1;
  const at = (seconds) => `${((seconds / scale) * 100).toFixed(1)}%`;
  return `<article class="run ${pass ? "pass" : "fail"}"><header class="run-head"><div><h2>${e(run.scenarioName)}</h2><p class="muted small">${clock(run.ranAt)} · deterministic prediction</p></div>${pill(label(run.verdict), pass ? "good" : "warn")}</header><div class="run-scale" aria-hidden="true"><i class="run-bar" style="width:${at(run.predictedSeconds)}"></i>${run.predictedAfterFixSeconds != null ? `<i class="run-fix" style="left:${at(run.predictedAfterFixSeconds)}"></i>` : ""}<i class="run-sla" style="left:${at(run.slaSeconds)}"></i></div><p class="run-figures"><strong>${duration(run.predictedSeconds)}</strong> predicted arrival <span>· target ${duration(run.slaSeconds)}</span>${run.predictedAfterFixSeconds != null ? `<span class="fix-figure">· with fixes ${duration(run.predictedAfterFixSeconds)} (${e(label(run.verdictAfterFix))})</span>` : ""}</p><ul class="findings">${run.findings.map((finding) => `<li>${e(finding)}</li>`).join("")}</ul>${run.fixes.length ? `<div class="fixes">${run.fixes.map((fix) => `<div class="fix"><div><h3>${e(fix.title)}</h3><p>${e(fix.detail)}</p></div>${state.user.role === "admin" && fix.applicable ? button("Apply to campus twin", "apply-fix", { id: fix.code, small: true }) : `<span class="small muted">${fix.applicable ? "Administrator permission required" : "For operator review"}</span>`}</div>`).join("")}</div>` : ""}</article>`;
}
function readiness() {
  const runs = state.readiness?.runs || state.runs;
  return `${intro("Readiness lab · deterministic campus rehearsal", viewTitle(), "Run compound-failure scenarios against a copy of the current twin. Predictions measure the slowest required unit’s arrival, not patient outcomes.", button("Run all scenarios", "run-all", { primary: true }))}${state.readiness ? stats([stat("Readiness score", `${state.readiness.scorePercent}%`, "Scenarios meeting their arrival SLA", "mint"), stat("Passed", state.readiness.passed, "Current suite run"), stat("Scenarios", state.readiness.total, "Built-in compound failures"), stat("Result source", "Engine", "Computed from the campus twin")]) : ""}${runs.length ? `<div class="runs">${runs.map(runRow).join("")}</div>` : `<div class="calm">${empty("No rehearsal results yet", "Run the built-in suite to expose coverage and route failures. No incident is dispatched by this analysis.")}</div>`}`;
}
function analytics() {
  const metrics = state.data.metrics;
  if (!metrics)
    return `${intro("After action · measured response", viewTitle(), "Loading the backend metrics…")}`;
  const longest = Math.max(1, ...metrics.stages.map((stage) => stage.seconds));
  const zones = Object.entries(metrics.byZone).sort((a, b) => b[1] - a[1]);
  const busiest = Math.max(1, ...zones.map(([, count]) => count));
  return `${intro("After action · recorded campus history", viewTitle(), "Computed from seeded fictional history and activity in this database. These are not pilot results.")}${stats(
    [
      stat(
        "Mean time to care",
        duration(metrics.mttcSeconds),
        "Onset to recorded care",
        "mint",
      ),
      stat(
        "Completion integrity",
        metrics.rciPercent == null ? "—" : `${metrics.rciPercent.toFixed(1)}%`,
        "Verified resolved / closed dispatched",
      ),
      stat(
        "Incidents recorded",
        metrics.incidentsTotal,
        `${metrics.resolved} resolved · ${metrics.open} open`,
      ),
      stat(
        "Blind observability",
        metrics.blindSpotPercent == null
          ? "—"
          : `${metrics.blindSpotPercent.toFixed(1)}%`,
        "Degraded or blind coverage",
        "amber",
      ),
    ],
  )}<div class="split">${block(
    "Where the time goes",
    `<ol class="bars">${metrics.stages.map((stage) => `<li><span>${e(stage.label)}</span><i class="bar ${stage.seconds === longest ? "peak" : ""}"><b style="width:${Math.max(1.5, (stage.seconds / longest) * 100)}%"></b></i><strong>${duration(stage.seconds)}</strong></li>`).join("")}</ol><p class="step-note">Mean duration per stage from recorded timestamps; missing milestones are excluded by the backend metric definition.</p>`,
    pill("Measured"),
  )}${block(
    "Campus pattern",
    `<ol class="bars zones">${zones.map(([zone, count]) => `<li><span>${e(zone)}</span><i class="bar"><b style="width:${(count / busiest) * 100}%"></b></i><strong>${e(count)}</strong></li>`).join("")}</ol>`,
    pill("Synthetic history"),
  )}</div>`;
}
function audit() {
  const records = state.data.audit || [];
  return `${intro("Governance · backend audit records", viewTitle(), "Recent access and action records from the backend. Incident timelines preserve operational milestones.")}${block(
    "Recent records",
    records.length
      ? `<div class="table-wrap"><table class="audit-table"><thead><tr><th scope="col">Time</th><th scope="col">Actor</th><th scope="col">Action</th><th scope="col">Target / detail</th></tr></thead><tbody>${records.map((record) => `<tr><td class="mono">${clock(record.at)}</td><td>${e(record.userName)}<small>${e(label(record.role))}</small></td><td>${e(record.action)}</td><td>${e(record.target || "—")}<small>${e(record.detail || "")}</small></td></tr>`).join("")}</tbody></table></div>`
      : empty(
          "No audit records",
          "Records appear as accounts access the service.",
        ),
    pill("Recent 60"),
  )}`;
}

/* ───────── Member ───────── */
function sos() {
  const mine = state.data.mine || [];
  return `${intro("Campus member · your requests only", viewTitle(), "Send your location to the campus command desk and follow the response. This demo does not contact emergency services.")}<div class="sos"><section class="sos-compose"><h2>Request campus help</h2><form id="sos-form" class="sos-form"><label>Campus location<select name="zoneCode" required>${(state.data.twin?.zones || []).map((zone) => `<option value="${e(zone.code)}">${e(zone.name)}</option>`).join("")}</select></label><label>Where exactly?<input name="locationDetail" maxlength="240" placeholder="Floor, room, corridor or landmark" required /></label><label>What happened?<textarea name="note" maxlength="1000" placeholder="Brief context for the command desk" required></textarea></label><label>Who needs help?<select name="forSelf"><option value="false">Someone with me</option><option value="true">I need help</option></select></label><button class="button primary full" ${state.busy ? "disabled" : ""}>Send request to command</button></form></section><section class="sos-updates"><h2>Your response updates</h2>${mine.length ? mine.map((item) => `<article class="sos-status ${openIncident(item) ? "" : "closed"}"><div class="row between"><span class="case-code">${e(item.code)}</span>${pill(label(item.state), openIncident(item) ? "warn" : "good")}</div><h3>${e(item.message)}</h3><p>${e(item.zoneName)} · raised ${clock(item.raisedAt)}</p>${item.responders.map((responder) => `<p class="responder-line">${e(responder)}</p>`).join("")}${openIncident(item) ? button("Help no longer needed", "cancel-sos", { quiet: true, id: item.incidentId }) : ""}</article>`).join("") : empty("No requests from this account", "Your request and its response status will stay visible here.")}</section></div>`;
}

async function sync({ force = false } = {}) {
  if (!state.user || (state.busy && !force)) return;
  if (state.fetching) {
    if (force) {
      await pendingSync;
      return sync({ force: true });
    }
    return;
  }
  let finish;
  pendingSync = new Promise((resolve) => {
    finish = resolve;
  });
  const epoch = state.epoch;
  const view = state.view;
  state.fetching = true;
  try {
    const data = { ...state.data };
    const role = state.user.role;
    if (view === "overview")
      [data.board, data.twin, data.simulation] = await Promise.all([
        rpc("incident", "board"),
        rpc("campus", "twin"),
        state.config?.demoEnabled
          ? rpc("simulation", "status")
          : Promise.resolve(null),
      ]);
    if (view === "care") data.cases = await rpc("care", "cases");
    if (view === "response") data.home = await rpc("responder", "home");
    if (view === "sos")
      [data.mine, data.twin] = await Promise.all([
        rpc("sos", "mine"),
        rpc("campus", "twin"),
      ]);
    if (view === "analytics") data.metrics = await rpc("analytics", "metrics");
    if (view === "audit")
      data.audit = await rpc("admin", "auditLog", { limit: 60 });
    let runs;
    if (view === "readiness" && (force || !state.runs.length))
      runs = await rpc("readiness", "history", { limit: 8 });
    if (epoch !== state.epoch || view !== state.view) return;
    if (data.board && view === "overview") {
      const incidents = [...data.board.active, ...data.board.recent];
      if (!incidents.some((incident) => incident.id === state.selected))
        state.selected = incidents[0]?.id ?? null;
      const incident = incidents.find(
        (incident) => incident.id === state.selected,
      );
      const key = incident ? `${incident.id}:${incident.updatedAt}` : null;
      if (incident && (force || key !== state.detailKey)) {
        const detail = await rpc("incident", "detail", {
          incidentId: incident.id,
        });
        if (
          epoch !== state.epoch ||
          view !== state.view ||
          state.selected !== incident.id
        )
          return;
        if (
          state.detail?.incident.id !== detail.incident.id ||
          state.detail?.incident.updatedAt !== detail.incident.updatedAt
        )
          clearBriefing();
        state.detail = detail;
        state.detailKey = key;
      }
      if (!incident) {
        state.detail = null;
        state.detailKey = null;
      }
    }
    if (
      epoch !== state.epoch ||
      view !== state.view ||
      state.user.role !== role
    )
      return;
    state.data = data;
    if (runs) state.runs = runs;
    state.error = "";
    state.lastSync = Date.now();
  } catch (error) {
    if (epoch !== state.epoch) return;
    if (error.status === 401) {
      await resetSession();
      state.error = error.message;
    } else state.error = error.message;
  } finally {
    state.fetching = false;
    finish();
  }
  shell();
}
function clearBriefing() {
  state.briefEpoch++;
  state.brief = null;
  state.briefBusy = false;
}
async function draftBrief(incidentId) {
  if (
    state.briefBusy ||
    state.user?.role !== "command" ||
    state.selected !== incidentId
  )
    return;
  const epoch = ++state.briefEpoch;
  const userId = state.user.id;
  const source = state.detail?.incident.updatedAt;
  state.briefBusy = true;
  shell();
  try {
    const brief = await rpc("briefing", "generate", { incidentId });
    if (
      epoch === state.briefEpoch &&
      state.user?.id === userId &&
      state.selected === incidentId &&
      state.detail?.incident.updatedAt === source
    )
      state.brief = brief;
  } catch {
    if (epoch === state.briefEpoch)
      state.brief = {
        status: "unavailable",
        notice:
          "The draft could not be loaded. Continue using the response record and timeline.",
      };
  } finally {
    if (epoch === state.briefEpoch) {
      state.briefBusy = false;
      shell();
    }
  }
}
async function resetSession() {
  evidence.clear();
  clearBriefing();
  state.epoch++;
  state.user = null;
  state.view = "";
  state.data = {};
  state.selected = null;
  state.detail = null;
  state.detailKey = null;
  state.lastSync = 0;
  state.readiness = null;
  state.runs = [];
  dialog.close();
  modalAction = null;
}
async function mutate(task, success) {
  if (state.busy) return;
  evidence.clear();
  clearBriefing();
  state.epoch++; // Discard any read started before this action.
  state.busy = true;
  document
    .querySelectorAll("button")
    .forEach((element) => (element.disabled = true));
  try {
    await task();
    state.error = "";
    if (success) note(success);
    dialog.close();
    modalAction = null;
  } catch (error) {
    state.error = error.message;
    if (dialog.open) {
      document.querySelector("#dialog-error").textContent = error.message;
      document
        .querySelectorAll("#action-dialog button")
        .forEach((element) => (element.disabled = false));
    } else note(error.message);
  } finally {
    state.busy = false;
    // Buttons were disabled directly in the DOM; force a fresh render.
    mainHtml = "";
  }
  await sync({ force: true });
  shell();
}
function ask({
  title,
  description,
  label: fieldLabel = "Reason",
  submit = "Confirm",
  action,
  required = true,
  field = true,
}) {
  modalAction = action;
  dialog.innerHTML = `<form id="action-form" class="dialog-body"><div><h2 id="dialog-title">${e(title)}</h2><p style="margin-top:14px">${e(description)}</p></div>${field ? `<label>${e(fieldLabel)}<textarea name="message" maxlength="1500" ${required ? "required" : ""}></textarea></label>` : ""}<p class="dialog-error" id="dialog-error" role="alert"></p><div class="row">${button("Cancel", "close-dialog")}<button class="button primary">${e(submit)}</button></div></form>`;
  dialog.showModal();
}
app.addEventListener("change", (event) => {
  if (event.target.name === "handle") accountHint();
  if (event.target.name === "evidence-image") {
    const file = event.target.files?.[0];
    if (file) void evidence.upload(file);
  }
});
document.addEventListener("click", async (event) => {
  const target = event.target.closest("[data-action]");
  if (!target || state.busy) return;
  const { action, id } = target.dataset;
  const numericId = Number(id);
  if (action === "close-dialog") return dialog.close();
  if (action === "toggle-timeline") {
    state.timelineOpen = !state.timelineOpen;
    shell();
    return;
  }
  if (action === "google-signin") {
    state.busy = true;
    state.error = "";
    shell();
    try {
      await identity.signIn();
      await resetSession();
      state.user = await api("session");
      state.view = navigationFor(state.user.role)[0]?.[0];
    } catch (error) {
      state.error =
        error.status === 401
          ? "This Google account has no active CareGrid membership, or its sign-in has expired. Contact your campus administrator."
          : error.code === "auth/popup-closed-by-user"
            ? "Sign-in was closed. Continue when you are ready."
            : "Google sign-in could not be completed. Reconnect and try again.";
      await identity?.signOut();
    } finally {
      state.busy = false;
    }
    shell();
    await sync({ force: true });
    return;
  }
  if (action === "refresh") {
    if (state.user) await sync({ force: true });
    else await initialize();
    return;
  }
  if (action === "navigate") {
    clearBriefing();
    state.view = id;
    state.epoch++;
    state.error = "";
    shell();
    await sync({ force: true });
    return;
  }
  if (action === "select-incident") {
    clearBriefing();
    state.epoch++;
    state.selected = numericId;
    state.timelineOpen = false;
    state.detail = null;
    state.detailKey = null;
    shell();
    await sync({ force: true });
    return;
  }
  if (action === "logout") {
    state.busy = true;
    try {
      await identity?.signOut();
      await api("session", { method: "DELETE" });
    } catch {
      note(
        identity
          ? "Could not finish sign-out. Close this tab to clear its in-memory Google sign-in."
          : "Could not revoke the server session. Close this browser and restart the local service to clear it.",
      );
    }
    await resetSession();
    state.busy = false;
    state.error = "";
    shell();
    return;
  }
  // Reconnect before retrying a mutation whose outcome may be uncertain.
  if (state.error)
    return note(
      "Reconnect and check the recorded state before taking another action.",
    );
  if (action === "rehearse") return openRehearse();
  if (action === "draft-brief") return draftBrief(numericId);
  if (action === "evidence-load") return evidence.load();
  if (action === "evidence-next")
    return evidence.load(evidence.page?.nextPageToken);
  if (action === "evidence-read") return evidence.read(id);
  if (action === "evidence-close") {
    evidence.hidePreview();
    shell();
    return;
  }
  if (action === "evidence-remove") {
    modalAction = null;
    dialog.innerHTML = `<form id="evidence-remove-form" class="dialog-body"><h2 id="dialog-title">Remove private attachment?</h2><p>This removes the active attachment from this case. Storage versioning and soft-delete retention may preserve its bytes.</p><input type="hidden" name="key" value="${e(id)}"/><div class="row">${button("Cancel", "close-dialog")}<button class="button danger">Remove attachment</button></div></form>`;
    dialog.showModal();
    return;
  }
  if (action === "claim")
    return mutate(
      () => rpc("incident", "claim", { incidentId: numericId }),
      "Incident ownership recorded.",
    );
  if (action === "dispatch")
    return mutate(
      () =>
        rpc("incident", "confirmDispatch", {
          incidentId: numericId,
          responderCodes: null,
        }),
      "Dispatch approved. Each assigned unit must acknowledge.",
    );
  if (action === "care-ready")
    return mutate(
      () => rpc("care", "markReady", { incidentId: numericId }),
      "Receiving team readiness recorded.",
    );
  if (action === "availability")
    return mutate(
      () => rpc("responder", "setAvailability", { available: id === "true" }),
      "Availability updated.",
    );
  if (action === "run-all")
    return mutate(async () => {
      state.readiness = await rpc("readiness", "runAll");
    }, "Readiness suite completed by the backend.");
  if (action === "responder-step" && id !== "complete")
    return mutate(
      () =>
        rpc("responder", id, { dispatchId: state.data.home.task.dispatch.id }),
      "Your response milestone is recorded.",
    );
  const actions = {
    "incident-note": {
      title: "Add an operational note",
      description: "This note joins the incident timeline.",
      label: "Note",
      action: (message) =>
        rpc("incident", "addNote", { incidentId: numericId, note: message }),
    },
    "care-note": {
      title: "Add a care note",
      description: "Record only the context needed to coordinate care.",
      label: "Care note",
      action: (message) =>
        rpc("incident", "addNote", { incidentId: numericId, note: message }),
    },
    escalate: {
      title: "Escalate to command",
      description: "Give the incident owner a concrete reason to intervene.",
      action: (message) =>
        rpc("incident", "escalate", { incidentId: numericId, note: message }),
    },
    resolve: {
      title: "Record the outcome",
      description:
        "Close only after the response has been verified. The server checks the required milestones.",
      label: "Response outcome",
      submit: "Record outcome & close",
      action: (message) =>
        rpc("incident", "resolve", { incidentId: numericId, outcome: message }),
    },
    dismiss: {
      title: "Stand down this incident",
      description:
        "Assigned units will be recalled. Your reason stays in the record.",
      submit: "Stand down",
      action: (message) =>
        rpc("incident", "dismiss", { incidentId: numericId, reason: message }),
    },
    decline: {
      title: "Unable to respond",
      description:
        "The backend will seek an alternative unit and escalate the failed assignment.",
      action: (message) =>
        rpc("responder", "decline", { dispatchId: numericId, reason: message }),
    },
    "release-unit": {
      title: "Stand down this unit",
      description:
        "The unit is released for other calls and its assignment is recorded as recalled. The rest of the response continues.",
      submit: "Stand down unit",
      action: (message) =>
        rpc("incident", "releaseUnit", {
          incidentId: state.selected,
          dispatchId: numericId,
          reason: message,
        }),
    },
    "cancel-sos": {
      title: "Withdraw your request",
      description:
        "Before dispatch this can stand the incident down. After dispatch, command reviews the withdrawal.",
      action: (message) =>
        rpc("sos", "cancel", { incidentId: numericId, reason: message }),
    },
    "clear-simulations": {
      title: "End open rehearsals",
      description:
        "This recalls units for simulation incidents and stops running scenarios. Member SOS requests stay active.",
      field: false,
      required: false,
      action: () => rpc("simulation", "clear"),
    },
    "apply-fix": {
      title: "Apply the readiness fix",
      description: `This changes the synthetic campus twin: ${id}. Run the suite again to measure the result.`,
      field: false,
      required: false,
      action: () => rpc("readiness", "applyFix", { fixCode: id }),
    },
    "responder-step": {
      title: "Complete your assignment",
      description:
        "Command retains responsibility for closing the parent incident.",
      label: "Handoff note",
      required: false,
      action: (message) =>
        rpc("responder", "complete", {
          dispatchId: state.data.home.task.dispatch.id,
          note: message || null,
        }),
    },
  };
  if (actions[action]) ask(actions[action]);
});
document.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (state.busy) return;
  const form = event.target;
  const values = Object.fromEntries(new FormData(form));
  if (form.id === "evidence-remove-form") {
    dialog.close();
    return evidence.remove(values.key);
  }
  if (form.id === "login-form") {
    state.busy = true;
    form.querySelector("button").disabled = true;
    try {
      const user = await api("session", { method: "POST", body: values });
      await resetSession();
      state.user = user;
      state.view = navigationFor(user.role)[0][0];
      state.error = "";
    } catch (error) {
      state.error = error.message;
    } finally {
      state.busy = false;
    }
    shell();
    await sync({ force: true });
    return;
  }
  if (state.error && form.id !== "action-form")
    return note("Reconnect before sending another action.");
  if (form.id === "action-form" && modalAction) {
    const action = modalAction;
    return mutate(
      () => action((values.message || "").trim()),
      "Action recorded.",
    );
  }
  if (form.id === "scenario-form")
    return mutate(
      () =>
        rpc("simulation", "start", {
          code: values.scenario,
          autopilot: values.autopilot === "true",
        }),
      "Rehearsal started. Signals will appear in the incident queue.",
    );
  if (form.id === "sos-form")
    return mutate(async () => {
      await rpc("sos", "raise", {
        zoneCode: values.zoneCode,
        locationDetail: values.locationDetail.trim(),
        note: values.note.trim(),
        forSelf: values.forSelf === "true",
      });
      form.reset();
    }, "Your request has reached command.");
});
async function initialize() {
  try {
    state.config = await api("config");
    if (state.config.authentication === "firebase") {
      if (!identity) {
        const { createFirebaseIdentity } =
          await import("./assets/generated/firebase-auth.js");
        identity = await createFirebaseIdentity(state.config.firebase);
      }
      state.accounts = [];
    } else {
      state.accounts = await api("accounts");
    }
    state.error = "";
  } catch (error) {
    state.error = error.message;
  }
  try {
    state.user = await api("session");
    state.view = navigationFor(state.user.role)[0]?.[0];
  } catch (error) {
    if (error.status !== 401) state.error = error.message;
  }
  shell();
  await sync({ force: true });
}
await initialize();
setInterval(() => {
  if (!document.hidden && !dialog.open) sync();
}, 2500);
document.addEventListener("visibilitychange", () => {
  if (!document.hidden && state.user) sync({ force: true });
});
