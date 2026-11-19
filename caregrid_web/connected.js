import {
  escapeHtml as e,
  label,
  duration,
  clock,
  openIncident,
  proofSteps,
  nextResponderAction,
  navigationFor,
} from "./connected-domain.mjs";

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
};
let toastTimer;
let modalAction;
let pendingSync = Promise.resolve();
async function api(path, { method = "GET", body, signal } = {}) {
  let response;
  try {
    response = await fetch(`/api/${path}`, {
      method,
      credentials: "same-origin",
      cache: "no-store",
      signal: signal || AbortSignal.timeout(13_000),
      headers: {
        "X-CareGrid-Request": "1",
        ...(body ? { "Content-Type": "application/json" } : {}),
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
  } catch {
    throw Error(
      "Connection lost. Check the local service, then reconnect. Your action has not been retried.",
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
const pill = (text, type = "") =>
  `<span class="pill ${type}">${e(text)}</span>`;
const empty = (title, message) =>
  `<div class="empty"><h3>${e(title)}</h3><p>${e(message)}</p></div>`;
const button = (
  text,
  action,
  { primary = false, danger = false, id = "", disabled = false } = {},
) =>
  `<button type="button" class="button ${primary ? "primary" : ""} ${danger ? "danger" : ""}" data-action="${action}" ${id !== "" ? `data-id="${e(id)}"` : ""} ${state.busy || disabled || (state.error && !["refresh", "logout", "close-dialog", "select-incident"].includes(action)) ? "disabled" : ""}>${e(text)}</button>`;
const note = (message) => {
  const target = document.querySelector("#notice");
  target.textContent = message;
  target.classList.add("visible");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => target.classList.remove("visible"), 5000);
};
const heading = (eyebrow, title, description, action = "") =>
  `<header class="page-heading"><div><p class="eyebrow">${e(eyebrow)}</p><h1>${title}</h1><p>${e(description)}</p></div>${action}</header>`;
const metric = (name, value, description, color = "") =>
  `<div class="metric"><span class="eyebrow">${e(name)}</span><strong class="${color}">${e(value)}</strong><small>${e(description)}</small></div>`;
const panel = (title, body, aside = "", classes = "") =>
  `<section class="panel ${classes}"><header class="panel-head"><h2>${e(title)}</h2>${aside}</header>${body}</section>`;
const banner = () =>
  state.error
    ? `<div class="error-banner" role="alert"><div><p>${e(state.error)}</p><small>Last successful sync: ${state.lastSync ? clock(state.lastSync) : "not yet connected"}. Refresh before repeating an action.</small></div>${button("Reconnect", "refresh")}</div>`
    : "";

function login() {
  app.innerHTML = `<main id="main" class="login"><section class="login-story"><a class="wordmark" href="/"><img src="assets/mark.svg" alt="" />CareGrid<span class="lime">.</span></a><div><p class="eyebrow lime">Team Duality / campus response</p><h1 style="margin-top:22px">Every signal.<br />An owner.<br /><em>A response.</em></h1><p>One shared workspace for the command desk, the people responding, and the team ready to receive them.</p><div class="orbit" aria-hidden="true"><svg viewBox="0 0 600 180"><path d="M0 90H130L190 45H340L400 130H600M80 180V90M260 0V45M490 0V130" fill="none" stroke="#ece9e13a" stroke-width="2"/><path d="M130 90L190 45H340L400 130H490" fill="none" stroke="#c6ff3d" stroke-width="3"/>${[
    [130, 90],
    [190, 45],
    [340, 45],
    [400, 130],
    [490, 130],
  ]
    .map(
      ([x, y]) =>
        `<circle cx="${x}" cy="${y}" r="6" fill="#0a0c14" stroke="#c6ff3d" stroke-width="2"/>`,
    )
    .join(
      "",
    )}</svg></div></div><footer class="eyebrow muted">From first signal to accountable care.</footer></section><section class="login-form-wrap"><p class="eyebrow cyan">Meridian Demo Campus</p><h2>Take your place.</h2><p class="muted">Sign in to the workspace for your role.</p><div style="margin-top:24px">${banner()}</div>${state.accounts.length ? `<form id="login-form"><label>Demo account<select name="handle" required>${state.accounts.map((account) => `<option value="${e(account.handle)}">${e(account.displayName)} · ${e(label(account.role))}</option>`).join("")}</select><small id="account-description"></small></label><label>Demo PIN<input name="pin" type="password" inputmode="numeric" maxlength="30" autocomplete="off" required aria-describedby="pin-hint"/><small id="pin-hint"></small></label><button class="button primary full" ${state.busy ? "disabled" : ""}>${state.busy ? "Signing in…" : "Enter workspace"}</button></form>` : `<div style="margin-top:24px">${empty("Service is not available", "Run node scripts/dev.mjs from the repository to start the backend and this console.")}</div>`}<div class="login-note">Connected local MVP · synthetic campus and seeded demo PINs. For a second role, open a separate browser profile or private window. <a href="index.html">Open the pitch presentation</a>.</div></section></main>`;
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
  if (!state.user) return login();
  const nav = navigationFor(state.user.role);
  if (!nav.some(([key]) => key === state.view)) state.view = nav[0]?.[0];
  const view = { overview, response, care, readiness, analytics, audit, sos }[
    state.view
  ];
  const focus = document.activeElement;
  const focusKey = focus?.dataset?.focus;
  const activeField = focus?.name;
  const activeFormId = focus?.closest("form")?.id;
  const selection = [focus?.selectionStart, focus?.selectionEnd];
  // Retain drafts and keyboard position when polling replaces the workspace.
  const drafts = new Map(
    [...app.querySelectorAll("form")].map((form) => [
      form.id,
      new FormData(form),
    ]),
  );
  app.innerHTML = `<div class="shell" data-role="${e(state.user.role)}"><aside class="sidebar"><a class="wordmark" href="/"><img src="assets/mark.svg" alt=""/>CareGrid<span class="lime">.</span></a><div class="campus-label"><span class="eyebrow muted">Connected workspace</span><strong>Meridian Demo Campus</strong></div><nav aria-label="Workspace">${nav.map(([key, title], index) => `<button class="nav-button ${state.view === key ? "active" : ""}" data-action="navigate" data-id="${key}" ${state.view === key ? 'aria-current="page"' : ""}><span>0${index + 1}</span>${e(title)}</button>`).join("")}</nav><div class="sidebar-foot"><p class="muted small">A signal is the beginning.<br />Care is the measure.</p><div class="identity"><strong>${e(state.user.displayName)}</strong><span class="muted small">${e(state.user.title)}</span></div>${button("Sign out", "logout")}</div></aside><div class="workspace"><header class="topbar"><span class="eyebrow">Campus response / <span class="lime">${e(label(state.user.role))}</span></span><div class="topbar-status" id="connection-status"></div></header><main id="main" class="main"><div id="connection-error" style="margin-bottom:${state.error ? 24 : 0}px">${banner()}</div>${state.lastSync ? view() : empty("Loading your workspace", "Reading the campus state from CareGrid…")}<footer class="context-note">Team Duality · Synthetic local MVP · The server enforces each account’s permissions. Camera analysis, mobile telemetry and Google Cloud delivery remain planned integrations.</footer></main></div></div>`;
  updateConnection();
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
function updateConnection() {
  const target = document.querySelector("#connection-status");
  if (target)
    target.innerHTML = `<span class="dot ${state.error ? "warn" : ""}"></span>${state.error ? "Connection needs attention" : `Synced ${clock(state.lastSync)}`} ${pill("SYNTHETIC DATA")}`;
}
function map(twin = state.data.twin, highlightedRoute = []) {
  if (!twin)
    return empty("Campus map unavailable", "The campus twin has not loaded.");
  const zones = new Map(twin.zones.map((zone) => [zone.code, zone]));
  const active = new Set(
    (twin.activeIncidents || []).map((incident) => incident.zoneCode),
  );
  const paths = twin.roads
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
      return `<line x1="${Number(a.x)}" y1="${Number(a.y)}" x2="${Number(b.x)}" y2="${Number(b.y)}" stroke="${road.status === "blocked" ? "#ff9278" : selected ? "#c6ff3d" : "#ece9e129"}" stroke-width="${selected ? 5 : 3}" ${road.status === "blocked" ? 'stroke-dasharray="8 8"' : ""}/>`;
    })
    .join("");
  const landmarks = new Set([
    "HB",
    "HOS",
    "LIB",
    "LAB",
    "SPT",
    "COM",
    "SEC",
    "G1",
    "G3",
  ]);
  const nodes = twin.zones
    .map(
      (zone) =>
        `<g><title>${e(zone.name)}</title><circle cx="${Number(zone.x)}" cy="${Number(zone.y)}" r="${active.has(zone.code) ? 12 : 6}" fill="${active.has(zone.code) ? "#ff9278" : zone.type === "hospital" ? "#c6ff3d" : "#888f9a"}"/>${landmarks.has(zone.code) || active.has(zone.code) ? `<text x="${Number(zone.x) + 15}" y="${Number(zone.y) - 13}" fill="${active.has(zone.code) ? "#ece9e1" : "#a0a6b3"}" font-family="Archivo, sans-serif" font-size="26">${e(zone.name.replace("Sports Complex", "Sports").replace("Chemistry Labs", "Labs").replace("Security Control Room", "Command"))}</text>` : ""}</g>`,
    )
    .join("");
  return `<svg class="schematic" viewBox="-25 -25 1120 770" role="img" aria-label="Schematic campus graph; orange marks active incident zones. Positions are campus nodes, not live GPS.">${paths}${nodes}</svg><div class="map-legend"><span><i class="dot warn"></i>Incident zone</span><span><i class="dot"></i>Hospital / selected route</span><span>Schematic · no live GPS</span></div>`;
}
function overview() {
  const board = state.data.board;
  if (!board)
    return empty(
      "Campus board unavailable",
      "Reconnect to load the operational state.",
    );
  return `${heading("Campus operations / shared incident state", "Calm at the centre.<br /><em>Accountability everywhere.</em>", "Review a signal, approve a response, and follow each unit through to care.", button("Refresh", "refresh"))}<section class="metrics" aria-label="Campus status">${metric("Open incidents", board.active.length, "Sorted by operational urgency", board.active.length ? "orange" : "lime")}${metric("Units available", `${board.respondersAvailable}/${board.respondersTotal}`, "Recorded campus availability")}${metric("Escalations open", board.escalatedOpen, "A deadline needs attention", board.escalatedOpen ? "orange" : "")}${metric("Degraded cameras", `${board.camerasDegraded}/${board.camerasTotal}`, "Seeded asset health", "cyan")}</section><div class="columns"><div class="queue-map">${panel("Incident queue", board.active.length ? board.active.map((incident) => incidentRow(incident)).join("") : empty("No open incidents", "Start a labelled rehearsal below, or send an SOS from a member account."), pill(`${board.active.length} OPEN`, board.active.length ? "warn" : "good"))}${panel("Campus twin", map(state.data.twin, state.detail?.dispatches?.find((unit) => unit.route.length > 1)?.route || state.detail?.plan?.options.find((unit) => unit.route.length > 1)?.route || []), pill(`${state.data.twin?.zones.length || 0} ZONES`))}${scenarioPanel()}${
    board.recent.length
      ? panel(
          "Recent outcomes",
          board.recent
            .slice(0, 5)
            .map((incident) => incidentRow(incident))
            .join(""),
        )
      : ""
  }</div><div>${incidentDetail()}</div></div>`;
}
function incidentRow(incident) {
  return `<button class="incident-row ${state.selected === incident.id ? "selected" : ""}" data-action="select-incident" data-id="${incident.id}" data-focus="incident-${incident.id}"><div><div class="row"><span class="eyebrow ${incident.severity === "p0" || incident.severity === "p1" ? "orange" : "cyan"}">${e(incident.code)}</span>${pill(incident.severity.toUpperCase(), "warn")}${incident.fromScenario ? pill("SIMULATION") : ""}</div><strong>${e(incident.title)}</strong><p>${e(incident.zoneName)} · ${e(label(incident.state))}${incident.escalationLevel ? ` · Escalation ${incident.escalationLevel}` : ""}</p></div><span class="muted mono">${clock(incident.onsetAt).slice(0, 5)}</span></button>`;
}
function incidentDetail() {
  const detail = state.detail;
  if (!detail || detail.incident.id !== state.selected)
    return panel(
      "Incident workspace",
      empty(
        "Choose an incident",
        "The evidence, recommended plan and response record will appear here.",
      ),
    );
  const incident = detail.incident;
  const allowed = detail.allowedActions;
  const can = (key) => allowed.includes(key);
  const route = detail.plan?.options[0];
  return `<section class="panel"><header class="detail-heading"><div class="row between"><span class="eyebrow cyan">${e(incident.code)}</span><div class="row">${pill(label(incident.state), openIncident(incident) ? "warn" : "good")}${incident.scenarioRunId ? pill("SIMULATION") : ""}</div></div><h2>${e(incident.title)}</h2><p class="muted">${e(detail.zoneName)}${incident.locationDetail ? ` · ${e(incident.locationDetail)}` : ""}</p><p class="small muted" style="margin-top:12px">Owner: ${e(incident.ownerName || "Unclaimed")} · ${e(incident.policyCode || "Policy review")}</p></header>${incident.nextAction ? `<div class="detail-section"><h3>Next decision</h3><p class="decision">${e(incident.nextAction)}</p>${incident.nextDeadline ? `<p class="muted" style="margin-top:10px">${e(incident.nextDeadlineLabel)} · due ${clock(incident.nextDeadline)}</p>` : ""}</div>` : ""}${incident.reasoning?.length ? `<div class="detail-section"><h3>Evidence &amp; policy</h3><ul class="reasoning">${incident.reasoning.map((reason) => `<li>${e(reason)}</li>`).join("")}</ul><p class="muted" style="margin-top:14px">${Math.round(incident.confidence * 100)}% signal score (uncalibrated) · ${e(label(incident.observability))} observability · ${detail.signals.length} visible signals. Deterministic policy evaluation; no live Gemini call.</p></div>` : ""}${!detail.dispatches.length && detail.plan ? `<div class="detail-section"><h3>Recommended response</h3>${detail.plan.options.map((option) => `<div class="unit"><div class="row between"><strong>${e(option.responderName)}</strong>${pill(duration(option.etaSeconds), option.withinSla ? "good" : "warn")}</div><p>${e(option.role)} · ${option.distanceMeters}m · ${e(option.routeNames.join(" / "))}</p></div>`).join("")}${detail.plan.warnings.map((warning) => `<p class="orange" style="margin-top:12px">${e(warning)}</p>`).join("")}</div>` : ""}${
    detail.dispatches.length
      ? `<div class="detail-section"><h3>Proof of response · per unit</h3><p class="muted" style="margin-bottom:18px">The incident stage reflects the furthest unit. Check each assignment separately.</p>${detail.dispatches
          .map(
            (dispatch) =>
              `<article class="unit"><div class="row between"><strong>${e(dispatch.responderName)}</strong>${pill(label(dispatch.status), dispatch.stalled ? "warn" : "")}</div><div class="proof" aria-label="Recorded milestones: ${proofSteps(dispatch).filter(Boolean).length} of 5">${proofSteps(
                dispatch,
              )
                .map((done) => `<span class="${done ? "done" : ""}"></span>`)
                .join(
                  "",
                )}</div><p>ACK ${clock(dispatch.acknowledgedAt)} · Arrival ${clock(dispatch.onSceneAt)} · Care ${clock(dispatch.careAt)}</p><p>${dispatch.arrivalSource ? `Arrival source: ${e(label(dispatch.arrivalSource))}` : `Arrival is unconfirmed · ETA estimate ${duration(dispatch.etaSeconds)}`}${dispatch.stalled ? " · Unit contact required" : ""}</p></article>`,
          )
          .join("")}</div>`
      : ""
  }${allowed.length ? `<div class="detail-section"><h3>Operator actions</h3><div class="actions">${can("claim") ? button("Take ownership", "claim", { id: incident.id }) : ""}${can("confirmDispatch") && !incident.dispatchedAt ? button("Approve recommended dispatch", "dispatch", { primary: true, id: incident.id, disabled: !route }) : ""}${can("note") ? button("Add a note", "incident-note", { id: incident.id }) : ""}${can("escalate") ? button("Escalate", "escalate", { id: incident.id }) : ""}${can("resolve") ? button("Record outcome & close", "resolve", { primary: true, id: incident.id }) : ""}${can("dismiss") ? button("Stand down with reason", "dismiss", { danger: true, id: incident.id }) : ""}</div></div>` : ""}<div class="detail-section"><h3>Response timeline</h3><div class="timeline">${detail.timeline.map((entry) => `<article class="timeline-entry"><time datetime="${e(entry.at)}">${clock(entry.at)}</time><div><strong>${e(entry.actor)}</strong><p>${e(entry.message)}</p></div></article>`).join("")}</div></div>${detail.redactions.length ? `<div class="detail-section"><p class="muted">Restricted for this role: ${e(detail.redactions.join("; "))}</p></div>` : ""}${incident.closureNote ? `<div class="detail-section"><h3>Recorded outcome</h3><p>${e(incident.closureNote)}</p></div>` : ""}</section>`;
}
function scenarioPanel() {
  const simulation = state.data.simulation;
  if (!simulation) return "";
  return panel(
    "Rehearse a real workflow",
    `<div class="panel-body"><form id="scenario-form"><label>Scenario<select name="scenario">${simulation.scenarios.map((scenario) => `<option value="${e(scenario.code)}">${e(scenario.title)}</option>`).join("")}</select></label><select name="autopilot" aria-label="Scenario control"><option value="false">Manual response</option><option value="true">Autopilot simulation</option></select><button class="button primary" ${state.busy ? "disabled" : ""}>Start rehearsal</button></form><p>Signals enter the real backend and create audited incidents. Every rehearsal incident is labelled. Scenario travel is simulated; use a member SOS to demonstrate responder-confirmed arrival.</p>${simulation.runs.some((run) => run.status === "running") ? `<div class="row" style="margin-top:16px">${pill("REHEARSAL RUNNING", "good")}${button("End open rehearsals", "clear-simulations")}</div>` : ""}</div>`,
    pill("SIMULATION"),
    "scenario-launch",
  );
}
function response() {
  const home = state.data.home;
  if (!home)
    return empty("Assignment unavailable", "Reconnect to load your unit.");
  const task = home.task;
  const introduction = heading(
    `${home.responder.code} / responder workspace`,
    "One assignment.<br /><em>Your next action.</em>",
    "Acknowledge, move, confirm arrival, and record care. Each action reaches the command desk.",
  );
  if (!task)
    return `${introduction}<div class="task-shell">${panel("Ready for the next call", `<div class="panel-body stack"><div class="row between"><strong>${e(home.responder.name)}</strong>${pill(label(home.responder.status), home.responder.status === "available" ? "good" : "")}</div><p class="muted">Recorded location: ${e(home.zoneName)}. No active assignment is currently attached to this account.</p>${button(home.responder.status === "available" ? "Go off duty" : "Mark available", "availability", { id: home.responder.status !== "available", primary: true })}</div>`)}</div>`;
  const dispatch = task.dispatch;
  const next = nextResponderAction(dispatch.status);
  return `${introduction}<section class="panel task-shell"><header class="task-hero"><div class="row between"><span class="eyebrow cyan">${e(task.incidentCode)}</span><div class="row">${pill(task.severity.toUpperCase(), "warn")}${pill(label(dispatch.status), "good")}</div></div><h2>${e(task.zoneName)}</h2><p>${e(task.locationDetail || "Exact location has not been supplied")}</p><p class="muted" style="margin-top:14px">${e(task.nature)}</p></header><div class="task-body"><div><p class="eyebrow muted">Assigned route</p><h3 style="margin:12px 0">${e(task.routeNames.join(" / "))}</h3><p class="muted">${dispatch.distanceMeters}m · ${duration(dispatch.etaSeconds)} estimated mobilization + travel</p><h3 style="margin:26px 0 18px">Response instructions</h3><ol class="instructions">${task.instructions.map((instruction) => `<li>${e(instruction)}</li>`).join("")}</ol>${task.otherResponders.length ? `<p class="muted small" style="margin-top:24px">Also assigned: ${e(task.otherResponders.join("; "))}</p>` : ""}</div><div><p class="eyebrow muted">Your response record</p><ul class="step-list">${[
    ["Assignment offered", "offeredAt"],
    ["Acknowledged", "acknowledgedAt"],
    ["Departure confirmed", "enRouteAt"],
    ["Arrival confirmed", "onSceneAt"],
    ["Care started", "careAt"],
  ]
    .map(
      ([title, key]) =>
        `<li><span class="${dispatch[key] ? "lime" : "muted"}">${e(title)}</span><time>${clock(dispatch[key])}</time></li>`,
    )
    .join(
      "",
    )}</ul><p class="small muted">${dispatch.arrivalSource ? `Arrival recorded by ${e(label(dispatch.arrivalSource))}.` : "An ETA never confirms your arrival. Use the on-scene action when you have reached the incident."}</p>${dispatch.stalled ? `<p class="orange small" style="margin-top:16px">This assignment is overdue. Contact command and confirm your status.</p>` : ""}</div></div><footer class="task-action">${next ? button(next[1], "responder-step", { primary: true, id: next[0] }) : ""}${["offered", "acknowledged"].includes(dispatch.status) ? button("Unable to respond", "decline", { danger: true, id: dispatch.id }) : ""}<p class="small muted">${task.hospitalNotified ? "The care team has been pre-alerted." : "Command coordinates any additional care support."}</p></footer></section>`;
}
function care() {
  const cases = state.data.cases || [];
  return `${heading("Care coordination / minimum necessary context", "Ready before<br /><em>they arrive.</em>", "Care teams receive the incident context and handoff record. Camera evidence stays with command.")}<section class="metrics">${metric("Pre-alerts", cases.filter((item) => openIncident(item)).length, "Open cases shared with care", "orange")}${metric("Team ready", cases.filter((item) => openIncident(item) && item.hospitalReady).length, "Readiness confirmed by care", "lime")}${metric("Care in progress", cases.filter((item) => item.state === "care").length, "Recorded responder care")}${metric("Closed cases", cases.filter((item) => !openIncident(item)).length, "Recent 12-hour window")}</section><div class="cards">${cases.length ? cases.map((item) => `<section class="panel case-card"><div class="panel-body"><div class="row between"><span class="eyebrow cyan">${e(item.code)}</span>${pill(item.severity.toUpperCase(), "warn")}</div><div><h2>${e(item.zoneName)}</h2><p class="muted">${e(item.locationDetail || "Location detail not supplied")}</p></div><p>${e(item.nature)}</p><div class="case-grid"><div><span class="eyebrow muted">Handoff state</span><strong>${e(item.handoffState)}</strong></div><div><span class="eyebrow muted">Receiving team</span><strong class="${item.hospitalReady ? "lime" : "orange"}">${item.hospitalReady ? "Ready to receive" : "Awaiting confirmation"}</strong></div><div><span class="eyebrow muted">Ambulance</span><strong>${e(item.ambulanceCode || "Not assigned")}</strong><small class="muted">${e(item.ambulanceStatus || "Pending dispatch")}</small></div><div><span class="eyebrow muted">Scene ETA</span><strong>${item.sceneEta ? clock(item.sceneEta) : "Not available"}</strong><small class="muted">Estimate, not verified arrival</small></div></div>${item.careNotes.length ? `<div><h3>Care record</h3>${item.careNotes.map((message) => `<p class="muted small" style="margin-top:10px">${e(message)}</p>`).join("")}</div>` : ""}${openIncident(item) ? `<div class="actions">${state.user.role === "medical" && !item.hospitalReady ? button("Confirm team & bay ready", "care-ready", { primary: true, id: item.incidentId }) : ""}${button("Add care note", "care-note", { id: item.incidentId })}${state.user.role === "medical" ? button("Escalate to command", "escalate", { id: item.incidentId }) : ""}</div>` : ""}</div></section>`).join("") : panel("Incoming care", empty("No care pre-alerts", "Cases appear here when the backend notifies the receiving team."))}</div>`;
}
function readiness() {
  const runs = state.readiness?.runs || state.runs;
  return `${heading("Readiness lab / deterministic campus rehearsal", "Find the failure.<br /><em>Before the emergency.</em>", "Run the campus stress scenarios against a copy of the current twin. Predictions measure the slowest required unit’s arrival, not patient outcomes.", button("Run all scenarios", "run-all", { primary: true }))}${state.readiness ? `<section class="metrics">${metric("Readiness score", `${state.readiness.scorePercent}%`, "Scenarios meeting their arrival SLA", "lime")}${metric("Passed", state.readiness.passed, "Current suite run")}${metric("Scenarios", state.readiness.total, "Built-in compound failures")}${metric("Result source", "Engine", "Computed from the campus twin", "cyan")}</section>` : ""}<div class="cards">${runs.length ? runs.map((run) => panel(run.scenarioName, `<div class="run-result"><div class="row between">${pill(label(run.verdict), run.verdict === "pass" ? "good" : "warn")}<span class="mono muted">${clock(run.ranAt)}</span></div><h3>${duration(run.predictedSeconds)} <span class="muted small">predicted arrival / ${duration(run.slaSeconds)} target</span></h3><ul class="findings">${run.findings.map((finding) => `<li>${e(finding)}</li>`).join("")}</ul>${run.fixes.map((fix) => `<div class="fix-row"><h3>${e(fix.title)}</h3><p class="muted small">${e(fix.detail)}</p>${state.user.role === "admin" && fix.applicable ? button("Apply to campus twin", "apply-fix", { id: fix.code }) : `<span class="small muted">${fix.applicable ? "Administrator permission required to apply" : "Recommendation for operator review"}</span>`}</div>`).join("")}${run.predictedAfterFixSeconds != null ? `<p class="small cyan" style="margin-top:18px">Combined-fix prediction: ${duration(run.predictedAfterFixSeconds)} · ${e(label(run.verdictAfterFix))}. Run again after applying to verify.</p>` : ""}</div>`, pill("PREDICTION"))).join("") : panel("Start with the campus you have", empty("No rehearsal results yet", "Run the built-in suite to expose coverage and route failures. No incident is dispatched by this analysis."))}</div>`;
}
function analytics() {
  const metrics = state.data.metrics;
  if (!metrics)
    return heading(
      "After action / measured response",
      "Make the next<br /><em>response better.</em>",
      "Loading the backend metrics…",
    );
  const max = Math.max(1, ...metrics.stages.map((stage) => stage.seconds));
  return `${heading("After action / recorded campus history", "Measure the care.<br /><em>Improve the system.</em>", "Metrics are computed from seeded fictional history and activity in this local database. They are not pilot results.")}<section class="metrics">${metric("Mean time to care", duration(metrics.mttcSeconds), "Onset to recorded care", "lime")}${metric("Completion integrity", metrics.rciPercent == null ? "—" : `${metrics.rciPercent.toFixed(1)}%`, "Verified resolved / closed dispatched")}${metric("Incidents recorded", metrics.incidentsTotal, `${metrics.resolved} resolved · ${metrics.open} open`)}${metric("Blind observability", metrics.blindSpotPercent == null ? "—" : `${metrics.blindSpotPercent.toFixed(1)}%`, "Cases with degraded / blind coverage", "orange")}</section><div class="columns">${panel("Where the time goes", `<div class="panel-body">${metrics.stages.map((stage) => `<div class="bar-row"><span>${e(stage.label)}</span><span class="bar-track"><i style="width:${Math.max(1, (stage.seconds / max) * 100)}%"></i></span><strong class="mono">${duration(stage.seconds)}</strong></div>`).join("")}<p class="muted small">Mean duration per stage from recorded timestamps; missing milestones are excluded by the backend metric definition.</p></div>`, pill("MEASURED"))}${panel(
    "Campus pattern",
    `<div class="table-wrap"><table><thead><tr><th>Zone</th><th>Incidents</th></tr></thead><tbody>${Object.entries(
      metrics.byZone,
    )
      .map(
        ([zone, count]) =>
          `<tr><td>${e(zone)}</td><td class="mono">${e(count)}</td></tr>`,
      )
      .join("")}</tbody></table></div>`,
    pill("SYNTHETIC HISTORY"),
  )}</div>`;
}
function audit() {
  const records = state.data.audit || [];
  return `${heading("Governance / backend audit records", "A record behind<br /><em>every decision.</em>", "Recent access and action records from the backend. Incident timelines preserve operational milestones.")}${panel("Audit trail", records.length ? `<div class="table-wrap"><table><thead><tr><th>Time</th><th>Actor</th><th>Action</th><th>Target / detail</th></tr></thead><tbody>${records.map((record) => `<tr><td class="mono">${clock(record.at)}</td><td>${e(record.userName)}<small>${e(label(record.role))}</small></td><td>${e(record.action)}</td><td>${e(record.target || "—")}<small>${e(record.detail || "")}</small></td></tr>`).join("")}</tbody></table></div>` : empty("No audit records", "Records appear as accounts access the service."), pill("RECENT 60"))}`;
}
function sos() {
  const mine = state.data.mine || [];
  return `${heading("Campus member / your requests only", "Help starts<br /><em>with a signal.</em>", "Send your location to the campus command desk and follow the response. This demo does not contact emergency services.")}<div class="sos-layout">${panel("Request campus help", `<form id="sos-form" class="panel-body sos-form"><label>Campus location<select name="zoneCode" required>${(state.data.twin?.zones || []).map((zone) => `<option value="${e(zone.code)}">${e(zone.name)}</option>`).join("")}</select></label><label>Where exactly?<input name="locationDetail" maxlength="240" placeholder="Floor, room, corridor or landmark" required /></label><label>What happened?<textarea name="note" maxlength="1000" placeholder="Brief context for the command desk" required></textarea></label><label>Who needs help?<select name="forSelf"><option value="false">Someone with me</option><option value="true">I need help</option></select></label><button class="button primary" ${state.busy ? "disabled" : ""}>Send request to command</button></form>`)}${panel("Your response updates", mine.length ? mine.map((item) => `<article class="sos-status"><div class="row between"><span class="eyebrow cyan">${e(item.code)}</span>${pill(label(item.state), openIncident(item) ? "warn" : "good")}</div><h3>${e(item.message)}</h3><p>${e(item.zoneName)} · raised ${clock(item.raisedAt)}</p>${item.responders.map((responder) => `<p>${e(responder)}</p>`).join("")}${openIncident(item) ? button("Help no longer needed", "cancel-sos", { id: item.incidentId }) : ""}</article>`).join("") : empty("No requests from this account", "Your request and its response status will stay visible here."))}</div>`;
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
        rpc("simulation", "status"),
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
async function resetSession() {
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
});
document.addEventListener("click", async (event) => {
  const target = event.target.closest("[data-action]");
  if (!target || state.busy) return;
  const { action, id } = target.dataset;
  const numericId = Number(id);
  if (action === "close-dialog") return dialog.close();
  if (action === "refresh") {
    if (state.user) await sync({ force: true });
    else await initialize();
    return;
  }
  if (action === "navigate") {
    state.view = id;
    state.epoch++;
    state.error = "";
    shell();
    await sync({ force: true });
    return;
  }
  if (action === "select-incident") {
    state.selected = numericId;
    state.detailKey = null;
    await sync({ force: true });
    return;
  }
  if (action === "logout") {
    state.busy = true;
    try {
      await api("session", { method: "DELETE" });
    } catch {
      note(
        "Could not revoke the server session. Close this browser and restart the local service to clear it.",
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
    state.accounts = await api("accounts");
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
