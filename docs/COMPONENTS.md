# CareGrid component reference

> **20 November 2026 update:** the Google target is in [SOLUTION-ARCHITECTURE.md](buildathon/SOLUTION-ARCHITECTURE.md). The web workspace now calls this Serverpod API through an authenticated local gateway; the original presentation remains browser-local. [Connected implementation](buildathon/CONNECTED-MVP.md), [launch instructions](../caregrid_web/README.md) and [validation](buildathon/VALIDATION.md).

The single reference for every element of the CareGrid prototype: app screens and shared widgets, API endpoints, server services, data models, behaviour rules and seeded data. Keep it in step with the code: when a component is added, renamed or removed, update its entry here in the same commit.

- [1. Overview](#1-overview)
- [2. Flutter app](#2-flutter-app)
- [3. API endpoints](#3-api-endpoints)
- [4. Server services](#4-server-services)
- [5. Data models](#5-data-models)
- [6. Rules and behaviour](#6-rules-and-behaviour)
- [7. Seeded data](#7-seeded-data)
- [8. Configuration and operations](#8-configuration-and-operations)

---

## 1. Overview

| Package | Path | Role |
| --- | --- | --- |
| Server | `caregrid_server/` | Serverpod 4 backend: endpoints, domain services, models, migrations, seed, tests. |
| Client | `caregrid_client/` | Generated typed client. Never edited by hand; regenerate with `serverpod generate`. |
| App | `caregrid_flutter/` | Flutter app for Android, iOS and web. One codebase, five role consoles. |
| Web brand layer | `caregrid_web/brand.css`, `glass.mjs`, `assets/mark.svg`, `assets/fonts/` | Shared tokens (warm paper, espresso ink, sienna, moss, mustard), Instrument Sans + IBM Plex Mono, the fixed glass navigation bar with a sliding active marker, buttons and reduced-motion rules for all three web surfaces. |
| Landing page | `caregrid_web/landing.*` (served at `/`) | Product story: opening reveal, scroll-driven exploded campus (twin, sensing, decision, response layers), scroll-scrubbed 100-second response replay, proof of response, live readiness model (`domain.mjs`), roles and an infrastructure status grid. Transform/opacity-only motion; one batched scroll frame. |
| Connected web | `caregrid_web/connected.*`, `connected-domain.mjs` (served at `/console`) | Role-specific web workspace under a glass top bar (no sidebar), shared backend state, per-unit proof, mobile actions, polling with draft retention and visible errors. Polls re-render only when the workspace HTML changes. |
| Local web gateway | `caregrid_web/server.mjs` | Same-origin static/JSON service, opaque HttpOnly sessions, allowlisted Serverpod RPC, typed error handling and request limits; loopback demo mode. |
| Local launcher | `scripts/start-local.ps1`, `scripts/dev.mjs` | Verified portable Dart setup on Windows; server-only workspace without Flutter; preserved synthetic DB; API readiness gate and owned process cleanup. |
| Browser checks / assets | `caregrid_web/e2e/connected.spec.mjs`, `assets/pitch/connected/` | Real multi-role Chrome workflow, 390px browser checks, backend failure behavior and reproducible connected screenshots. |

**Data flow.** A signal enters `SignalEndpoint` / `SosEndpoint` (or the simulator), the `IncidentAgent` creates or updates an `Incident`, the `Orchestrator` changes state and writes the timeline, and `OpsBus` pushes a minimal `OpsEvent` over the `LiveEndpoint` stream. Every screen is a `LiveLoader` that refetches its role-filtered data when an event arrives. The `OpsTicker` runs `ProofOfResponse` and `SimulationEngine` once per second.

**Conventions.** UI styling is intentionally default Material 3; visual design is applied later through `main.dart` (theme), `core/format.dart` (`Palette`) and the shared widgets. Times are stored in UTC and shown in local time. All role checks happen on the server.

---

## 2. Flutter app

### 2.1 App core (`caregrid_flutter/lib/`)

| Element | File | What it does |
| --- | --- | --- |
| `main()` / `CareGridApp` | `main.dart` | Initializes the client, restores the session, shows a spinner, then `SignInScreen` or `HomeShell`. Holds the light/dark theme (seed colour teal). |
| `client`, `initializeClient()` | `client.dart` | Global generated `Client`. Server URL: `--dart-define=SERVER_URL`, else `assets/config.json` (served by the CareGrid server for web), else `http://localhost:8080/` (Android emulator maps localhost automatically). Attaches `TokenKeyProvider` and the connectivity monitor. |
| `AppSession` | `src/core/app_session.dart` | Signed-in user state (`ChangeNotifier`). `restore()` validates a stored token with `account.me`; `signIn(handle, pin)`; `signOut()`. Token persisted in `shared_preferences` under `caregrid.token`. Starts and stops `LiveFeed`. |
| `TokenKeyProvider` | `src/core/app_session.dart` | Sends `Authorization: Bearer <token>` on every call and stream. |
| `LiveFeed` | `src/core/live_feed.dart` | Subscribes to `live.watch()`. Each event bumps `revision` (debounced 250 ms). Reconnects 3 s after a drop and polls every 10 s as a fallback. Exposes `connected` for the live indicator. |
| `Fmt` | `src/core/format.dart` | `time`, `dateTime`, `seconds` (`1m 25s`), `ago`, `percent`, `confidence`. |
| `Palette` | `src/core/format.dart` | Semantic colours for severity, incident state, responder status and camera health. |
| `runAction` | `src/core/actions.dart` | Runs a server call, shows a success or error snackbar (`CareGridException.message` when typed). |
| `askText`, `confirm` | `src/core/actions.dart` | In-page dialogs for a reason/outcome/note and yes/no confirmation. |

### 2.2 Shared widgets (`caregrid_flutter/lib/src/widgets/`)

| Widget | Inputs | Behaviour |
| --- | --- | --- |
| `LiveLoader<T>` | `load`, `builder(context, data, reload)` | Loads once, reloads on every `LiveFeed` change, shows spinner, error with Retry, then the builder. Every data screen uses it. |
| `Tag` | `text`, `color`, `icon?` | Small coloured label. |
| `SeverityTag`, `StateTag` | `Severity`, `IncidentState` | Labelled, coloured tags. |
| `EscalationTag` | `level` | "Escalated xN"; hidden at 0. |
| `ObservabilityTag` | `Observability` | "Degraded coverage" / "Blind spot"; hidden when full. |
| `DeadlineCountdown` | `deadline`, `label` | Ticks every second: "Label: in 12s"; orange under 10 s, red "overdue 5s" after. |
| `IncidentTile` | `IncidentSummary`, `onTap` | Queue row: tags (severity, state, escalation, coverage, human review, victims, simulation, code), title, location, onset, next action, unit statuses, countdown. |
| `TimelineView` | `List<TimelineEntry>` | Audit timeline with one icon per `TimelineKind` (escalations in red). |
| `ProofTracker` | `Dispatch` | Proof-of-Response for one unit: status, stalled flag, chips for Dispatched / Acknowledged / Moving / On scene / Care / Completed with times, progress bar and ETA while en route, route, arrival source, note, countdown to the next milestone. |
| `Section` | `title`, `child`, `trailing?` | Titled block. |
| `MetricTile` | `label`, `value`, `caption?`, `color?` | Headline number card. |
| `EmptyState` | `message`, `icon` | Placeholder for empty lists. |
| `PageBody` | `children`, `maxWidth` | Centered, width-limited scrolling page. |
| `CampusMap` | `CampusTwin`, `highlightRoute`, `onZoneTap` | Schematic twin on a 1000 x 700 canvas (`CustomPaint`): roads (blocked red, congested orange, outside grey), zones by type, gates (green open, amber override, red closed), incident halos by severity, unit dots at live positions with codes. Tap selects the nearest zone. |
| `MapLegend` | none | Explains the map symbols. |

### 2.3 Screens (`caregrid_flutter/lib/src/features/`)

Every screen below lists its data source, its components, and each action with the endpoint it calls.

#### Sign-in: `sign_in/sign_in_screen.dart` (`SignInScreen`)
- **Data:** `account.demoAccounts()`.
- **Components:** intro text; one card per seeded account (role icon, name, role, title, description, handle, PIN); manual handle + PIN form.
- **Actions:** tap a card or *Sign in* → `AppSession.signIn` → `account.signIn`.

#### Shell: `shell/home_shell.dart` (`HomeShell`)
- **Components:** app bar (screen title, `_LiveIndicator` green/orange, user name on screens 600 px or wider, sign out); `NavigationRail` at 900 px or wider, otherwise a bottom `NavigationBar`.
- **Destinations by role:** command: Incidents, Live map, Twin, Simulation, Analytics. Medical: Care console, Live map. Responder: My task, Map. Admin: Readiness, Twin, Policies, Analytics, Audit. Member: SOS.

#### Incident console: `command/incident_console_screen.dart` (`IncidentConsoleScreen`)
- **Data:** `incident.board()`.
- **Components:** metric tiles (open incidents, escalated, units available, cameras degraded); *Active incidents* as `IncidentTile`s, most urgent first; *Closed in the last 24 hours*; FAB *Report signal*.
- **Actions:** tap an incident → `IncidentDetailScreen`; *Report signal* → `ManualSignalSheet`.

#### Manual signal sheet: `ManualSignalSheet` (same file)
- **Data:** `campus.twin()` for the zone list.
- **Fields:** zone, event type (non-negative types), location detail, what was reported.
- **Action:** *Send to Incident Agent* → `signal.ingest(SignalInput(source: operatorReport, confidence: 0.9, ...))`.

#### Incident detail: `command/incident_detail_screen.dart` (`IncidentDetailScreen`)
Shared by command, medical and admin; the server redacts per role.
- **Data:** `incident.detail(id)`.
- **Header (`_Header`):** tags (severity, state, escalation, coverage, corroborated, human review, hospital pre-alerted/ready, simulation); code and title; zone, zone type, location detail; consequence, family, source, confidence, onset, owner; next action; countdown; closure note when closed.
- **Stage strip (`_StageStrip`):** Detect, Verify, Dispatch, Ack, Arrive, Care and MTTC durations for this incident.
- **Action bar (`_ActionBar`)**, shown from `allowedActions`:

  | Button | Shown when | Calls |
  | --- | --- | --- |
  | Confirm & dispatch | `confirmDispatch` and not yet dispatched | `incident.confirmDispatch(id, null)` |
  | Choose units / Add units | `confirmDispatch` | unit picker (plan options + alternatives) → `incident.confirmDispatch(id, codes)` |
  | Take ownership | `claim` | `incident.claim(id)` |
  | Ready to receive | `markReady` | `care.markReady(id)` |
  | Escalate | `escalate` | `incident.escalate(id, note)` |
  | Note / Care note | `note` / `careNote` | `incident.addNote(id, note)` |
  | Resolve | `resolve` (after verified arrival) | `incident.resolve(id, outcome)` |
  | Dismiss (false positive) | `dismiss` | `incident.dismiss(id, reason)` |

- **Recommended response (`_PlanSection`, before dispatch):** each planned unit with role, ETA, distance, route and an in/out-of-SLA icon; planner warnings.
- **Proof-of-Response:** one `ProofTracker` per dispatch (latest first).
- **Planner warnings** (after dispatch), **Linked victims**, **Agent reasoning**, **Negative evidence**.
- **Policy (`_PolicySection`):** SOP name, severity, verification rule, dispatch mode, all SLAs, units and fallbacks, numbered instructions.
- **Signals (evidence):** raw signals with source, camera, confidence, detail, track and the agent's outcome (command only).
- **Timeline:** `TimelineView`.
- **Hidden for your role:** the server's redaction list.

#### Live map: `map/live_map_screen.dart` (`LiveMapScreen`)
- **Data:** `campus.twin()`.
- **Components:** `CampusMap`, `MapLegend`, list *On the map now* (opens the incident for command, medical and admin).
- **Zone sheet (tap a zone):** name, type, code, restricted flag, gate state, description; cameras with health; units currently there; incidents there.

#### Twin: `admin/twin_admin_screen.dart` (`TwinAdminScreen`)
Used by command and admin. Tabs over `campus.twin()`:
- **Units:** grouped by type; status, note, live location, base, speed, mobilization time, capabilities, contact. Menu sets available / busy / offline with a note → `admin.setResponderStatus`. Units on a task show "On task".
- **Gates:** switches *Open* and *Emergency override pre-authorized* → `admin.setGate`.
- **Roads:** status dropdown open / congested / blocked → `admin.setRoadStatus` (blocking a road under a moving unit triggers a reroute).
- **Cameras:** health dropdown (admin) → `admin.setCameraHealth`; adjacency shown.

#### Simulation lab: `simulation/simulation_lab_screen.dart` (`SimulationLabScreen`)
- **Data:** `simulation.status()` and `signal.recent(25)`.
- **Components:** *Autopilot* switch; *Stand down all simulation incidents*; scenario cards (title, description, expected outcome, signal count, zone, capabilities demonstrated, injected faults, *Run*); recent runs (status, signals emitted, mode, faults, *Stop*); edge event bus log (source, event, zone, camera, confidence, time, agent outcome).
- **Actions:** *Run* → `simulation.start(code, autopilot)`; *Stop* → `simulation.stop(runId)`; *Stand down* → `simulation.clear()`.

#### Analytics: `analytics/analytics_screen.dart` (`AnalyticsScreen`)
- **Data:** `analytics.metrics()`.
- **Components:** tiles for MTTC, RCI, false escalation, blind-spot rate, incident totals, escalations; *MTTC stage by stage* bars (detection, verification, dispatch, acknowledgement, arrival, care start); counts for dismissal reasons, event family, severity, zone.

#### Care console: `care/care_console_screen.dart` (`CareConsoleScreen`)
- **Data:** `care.cases()`.
- **Incoming case card (`_CaseCard`):** severity, state, handoff state, ready flag; nature; zone and location; onset; ambulance and its status; countdown to first unit on scene; unit statuses; last three care notes.
- **Actions:** *Ready to receive* → `care.markReady(id)`; *Open case* → `IncidentDetailScreen`.
- **Closed in the last 12 hours:** list linking to the case.

#### Responder view: `responder/responder_screen.dart` (`ResponderScreen`)
- **Data:** `responder.home()`.
- **Unit card:** name, type, status and note, location, capabilities; on/off-duty switch when idle → `responder.setAvailability(bool)`.
- **Task (`_TaskView`):** severity, status, hospital-alerted tags; nature; location; incident code; one primary button for the next step; *Decline* while offered or acknowledged; acknowledgement countdown; route; numbered SOP steps; other units; `ProofTracker`.

  | Dispatch status | Primary button | Calls |
  | --- | --- | --- |
  | offered | Acknowledge | `responder.acknowledge(id)` |
  | acknowledged | Start moving | `responder.enRoute(id)` |
  | enRoute | Arrived on scene | `responder.arrive(id)` |
  | onScene | Start care / action | `responder.startCare(id)` |
  | care | Complete my task (handover note) | `responder.complete(id, note)` |
  | offered / acknowledged | Decline (reason) | `responder.decline(id, reason)` |

- **Recent tasks** list. When idle: "Standing by".

#### SOS: `member/sos_screen.dart` (`SosScreen`)
- **Data:** `sos.mine()`.
- **Components:** round SOS button; guidance text; *My requests* cards (state, code, zone, time, status message, unit statuses, arrival countdown, *I no longer need help*).
- **Raise sheet (`_RaiseSosSheet`):** place (from `campus.twin()`), floor/room/landmark, what happened, *I need help* / *Someone else needs help* → `sos.raise(zone, location, note, forSelf)`.
- **Cancel:** reason → `sos.cancel(id, reason)` (negative evidence; after dispatch a human decides).

#### Readiness lab: `admin/readiness_lab_screen.dart` (`ReadinessLabScreen`)
- **Data:** `readiness.scenarios()` and `readiness.history(20)`.
- **Components:** readiness card with score after *Run all* (`readiness.runAll()`); one card per rehearsal (`_ScenarioResult`): name, description, emergency/zone/hour, injected failures, *Run* (`readiness.run(code)`), PASS/FAIL, predicted onset-to-arrival vs SLA and policy, stage chips, unit plan, findings, fixes (passes alone or improves), *Apply* (admin, with confirmation) → `readiness.applyFix(code)`, verdict with fixes, run time and author.
- **Custom rehearsal (`_CustomScenarioDialog`, admin):** name, zone, emergency, local hour slider, failure builder (kind + target from the twin) → `readiness.runCustom(scenario)`.

#### Policies: `admin/policies_screen.dart` (`PoliciesScreen`)
- **Data:** `admin.policies()`.
- **Components:** one expandable card per SOP (severity, zone type, family, hour window, auto-dispatch, verification rule, hospital pre-alert, units, fallbacks, SLAs, instructions).
- **Editor (`_PolicyEditor`):** severity, minimum confidence slider, require corroboration, auto-dispatch, pre-alert hospital, confirmation / acknowledgement / arrival / care SLAs → `admin.updatePolicy(policy)`.

#### Audit: `admin/audit_screen.dart` (`AuditScreen`)
- **Data:** `admin.auditLog(200)` and `admin.users()`.
- **Components:** *Reset demo* with confirmation → `admin.resetDemo()`; users and roles; audit log (time, user, role, action, target, detail).

---

## 3. API endpoints

`caregrid_server/lib/src/endpoints/`. Calls are typed RPC through the generated client. "Any" means any signed-in role.

| Endpoint | Method | Roles | Returns / effect |
| --- | --- | --- | --- |
| `account` | `demoAccounts()` | public | `List<DemoAccount>` |
| | `signIn(handle, pin)` | public | `SignInResult` (7-day bearer token); audit `sign-in` |
| | `me()` | any | `AppUser` |
| | `signOut()` | any | deletes the token |
| `live` | `watch()` | any | `Stream<OpsEvent>` (hello, then every change) |
| `campus` | `twin()` | any | `CampusTwin`, filtered: members get places only; cameras for command/admin; medical sees hospital-alerted incidents |
| | `route(from, to)` | command, admin, responder | `RoutePlan` |
| `incident` | `board()` | command, admin, medical | `OpsBoard` (medical: hospital-alerted only) |
| | `detail(id)` | command, admin, medical, assigned responder | `IncidentDetail`, redacted per role; audit `view-incident` |
| | `confirmDispatch(id, codes?)` | command | dispatches plan or chosen units; audit `confirm-dispatch` / `override-dispatch` |
| | `claim(id)` | command | sets owner |
| | `escalate(id, note)` | command, medical | escalation +1 |
| | `addNote(id, note)` | command, medical, admin | timeline note |
| | `dismiss(id, reason)` | command | recalls units, closes; audit `override-dismiss` |
| | `releaseUnit(id, dispatchId, reason)` | command | stands down one assigned unit (recorded as recalled, unit released); the rest of the response continues; audit `recall-unit` |
| | `resolve(id, outcome)` | command, medical | requires verified arrival and recorded care; arrived units complete, units still travelling are recorded as stood down (recalled), never completed |
| `responder` | `home()` | responder (own unit) | `ResponderHome` |
| | `acknowledge`, `enRoute`, `arrive`, `startCare` `(dispatchId)` | responder (own task) | Proof-of-Response transitions |
| | `complete(dispatchId, note?)` | responder | completes own task, unit back to base |
| | `decline(dispatchId, reason)` | responder | releases unit, re-dispatches same type |
| | `setAvailability(bool)` | responder | on/off duty (not while on a task) |
| `care` | `cases()` | medical, command | `List<CareCase>` |
| | `markReady(id)` | medical | hospital ready to receive |
| `sos` | `raise(zone, location?, note?, forSelf)` | member | `SosStatus`; creates an SOS signal |
| | `mine()` | member | own SOS statuses only |
| | `cancel(id, reason)` | member (own SOS) | negative evidence |
| `signal` | `ingest(SignalInput)` | command, admin | `SensorEvent`; edge gateway ingress |
| | `recent(limit)` | command | latest signals with agent outcome |
| `simulation` | `status()`, `start(code, autopilot)`, `stop(runId)`, `clear()` | command, admin | scenario catalog, runs, stand-down |
| `readiness` | `scenarios()`, `run(code)`, `runAll()`, `history(limit)` | admin, command | rehearsals and `ReadinessSummary` |
| | `runCustom(StressScenario)`, `applyFix(code)` | admin | ad-hoc rehearsal; apply a fix to the live twin |
| `admin` | `policies()` | admin, command | SOP list |
| | `updatePolicy(ZonePolicy)` | admin | validates and saves |
| | `setCameraHealth(code, health)` | admin | camera state |
| | `setGate(zone, isOpen, emergencyOverride)` | admin, command | gate state |
| | `setRoadStatus(code, status)` | admin, command | road state |
| | `setResponderStatus(code, status, note?)` | admin, command | available / busy / offline |
| | `auditLog(limit)`, `users()` | admin | governance views |
| | `resetDemo()` | admin | reseeds twin and history; keeps users and audit |
| `analytics` | `metrics()` | command, admin | `OpsMetrics` |

Errors reach the app as `CareGridException(message, code)` with `code` one of `forbidden`, `notFound`, `invalidState`, `badRequest`, `conflict` (the incident changed since it was read; review the latest record), `unavailable`, `busy`.

---

## 4. Server services

`caregrid_server/lib/` unless noted.

| Service | File | Responsibility |
| --- | --- | --- |
| `run()` / `_authenticate` | `server.dart` | Boots Serverpod with the token authentication handler (token → user id + `role:<role>` scope), mounts the web app and config route, seeds on first boot, closes orphaned scenario runs, starts `OpsTicker`. |
| `Access`, `Actor` | `src/core/access.dart` | Loads the caller and enforces role sets; typed error helpers. |
| `Audit` | `src/core/audit.dart` | Writes `AuditRecord`s. |
| `OpsBus` | `src/core/ops_bus.dart` | Posts `OpsEvent`s to the `caregrid-ops` channel. |
| `CampusClock`, `formatSeconds` | `src/core/clock.dart` | UTC now, campus local hour (offset from `CAREGRID_UTC_OFFSET_MINUTES`, default 330), hour-window test. |
| `TwinSnapshot` | `src/twin/twin_snapshot.dart` | Loads zones, roads, cameras, units, policies; deep copy for what-if; observability of a zone. |
| `CampusGraph` | `src/twin/campus_graph.dart` | Dijkstra over roads; gate and road rules; `etaSeconds = mobilization + effective meters / speed`. |
| `PolicyEngine` | `src/agent/policy_engine.dart` | Event family per type, person events, observable consequence text, most-specific SOP selection, severity escalation. |
| `IncidentAgent` | `src/agent/incident_agent.dart` | Signal ingest: suppression of offline cameras, fusion, corroboration, victim linking, negative evidence, verification decision, explanation lines. |
| `ResponsePlanner` | `src/response/response_planner.dart` | Fastest available unit per required type, fallbacks, alternatives, SLA warnings. |
| `Orchestrator` | `src/response/orchestrator.dart` | All state transitions: verify, dispatch, confirm/override, acknowledge, en route, arrive, start care, complete, decline, re-dispatch, escalate, dismiss, resolve, state derivation and next deadline, timeline writes. |
| `ProofOfResponse` | `src/response/proof_of_response.dart` | 1 s watchdog: deadlines, missed acknowledgement and stalls. Explicit scenario runs alone simulate travel, rerouting and labelled arrival; genuine cases require responder check-in. |
| `IncidentViews` | `src/response/incident_views.dart` | Summaries, urgency ordering, per-role redaction. |
| `StressTestEngine` | `src/readiness/stress_test_engine.dart` | Applies failures to a twin copy, predicts every stage, judges against the SOP SLA, searches and combines fixes. Pure computation. |
| `ScenarioLibrary` | `src/simulation/scenario_library.dart` | The eight live scenarios (signals, timing, faults). |
| `SimulationEngine` | `src/simulation/simulation_engine.dart` | Starts runs, emits due signals each tick, stops runs, frees units left unreachable by fault scenarios. |
| `MetricsService` | `src/analytics/metrics_service.dart` | MTTC and stage means, RCI, false escalation, blind-spot rate, breakdowns. |
| `OpsTicker` | `src/engine/ops_ticker.dart` | One-second heartbeat (non-overlapping) for the simulator and watchdog. |
| `SeedData`, `Seeder` | `src/seed/` | Seeded campus and history; first-boot seeding; demo reset. |

---

## 5. Data models

Source: `caregrid_server/lib/src/models/**/*.spy.yaml`, generated into server and client.

### 5.1 Tables

| Model (table) | Key fields |
| --- | --- |
| `Zone` (`zone`) | `code` (unique), `name`, `type`, `x`, `y`, `description`, `isOpen`, `emergencyOverride`, `isRestricted`, `privacySensitive` |
| `RoadSegment` (`road_segment`) | `code` (unique), `name`, `fromZone`, `toZone`, `lengthMeters`, `status`, `isOutsideCampus` |
| `Camera` (`camera`) | `code` (unique), `zoneCode`, `label`, `health`, `adjacentCameras`, `privacyMasked` |
| `Responder` (`responder`) | `code` (unique), `name`, `type`, `status`, `zoneCode`, `baseZoneCode`, `speedMetersPerMin`, `mobilizationSeconds`, `capabilities`, `contact`, `activeDispatchId`, `statusNote` |
| `ZonePolicy` (`zone_policy`) | `code` (unique), `name`, `zoneType?`, `family`, `startHour?`, `endHour?`, `severity`, `minConfidence`, `requireCorroboration`, `autoDispatch`, `notifyHospital`, `responderTypes`, `fallbackTypes`, `verifySlaSeconds`, `ackSlaSeconds`, `arrivalSlaSeconds`, `careSlaSeconds`, `instructions` |
| `Incident` (`incident`) | `code` (unique), `title`, `eventType`, `family`, `severity`, `state`, `zoneCode`, `locationDetail`, `primaryCameraCode`, `trackId`, `source`, `confidence`, `corroborated`, `observability`, `consequence`, `policyCode`, `reasoning`, `negativeEvidence`, `nextAction`, `parentIncidentId`, `escalationLevel`, `needsHumanReview`, `ownerName`, `hospitalNotified`, `hospitalReady`, `reporterUserId` (server only), `scenarioRunId`, `contextHour`, timestamps `onsetAt` `detectedAt` `verifiedAt` `dispatchedAt` `acknowledgedAt` `enRouteAt` `onSceneAt` `careAt` `resolvedAt` `dismissedAt`, `closureNote`, `nextDeadline`, `nextDeadlineLabel`, `updatedAt` |
| `SensorEvent` (`sensor_event`) | `source`, `eventType`, `zoneCode`, `cameraCode`, `trackId`, `confidence`, `detail`, `locationDetail`, `observedAt`, `receivedAt`, `incidentId`, `outcome`, `contextHour`, `scenarioRunId`, `reporterUserId` (server only) |
| `TimelineEntry` (`timeline_entry`) | `incidentId`, `at`, `kind`, `actor`, `message`, `sensitive` |
| `Dispatch` (`dispatch`) | `incidentId`, `responderCode`, `responderName`, `responderType`, `role`, `status`, `route`, `distanceMeters`, `etaSeconds`, `offeredAt`, `ackDeadline`, `acknowledgedAt`, `enRouteAt`, `arrivalDeadline`, `onSceneAt`, `careAt`, `completedAt`, `progress`, `arrivalSource`, `stalled`, `note` |
| `StressScenario` (`stress_scenario`) | `code` (unique), `name`, `description`, `zoneCode`, `eventType`, `hour`, `failures`, `builtIn` |
| `StressTestRun` (`stress_test_run`) | `scenarioCode`, `scenarioName`, `ranAt`, `ranBy`, `verdict`, `predictedSeconds`, `slaSeconds`, `policyCode`, `stages`, `responderPlan`, `findings`, `fixes`, `verdictAfterFix`, `predictedAfterFixSeconds`, `planAfterFix` |
| `ScenarioRun` (`scenario_run`) | `scenarioCode`, `title`, `startedAt`, `startedBy`, `autopilot`, `status`, `stepsTotal`, `stepsEmitted`, `faults` |
| `AppUser` (`app_user`) | `handle` (unique), `displayName`, `role`, `title`, `responderCode`, `pin` (server only) |
| `AuthToken` (`auth_token`, server only) | `token` (unique), `userId`, `createdAt`, `expiresAt` |
| `AuditRecord` (`audit_record`) | `at`, `userId`, `userName`, `role`, `action`, `target`, `detail` |

### 5.2 Transfer and view models

| Model | Purpose |
| --- | --- |
| `SignalInput` | Ingest payload: source, event type, zone, camera, track, confidence, detail, location, context hour. |
| `PlanOption` | One candidate unit: code, name, type, role, route, route names, distance, ETA, within SLA, note. |
| `ResponsePlan` | Recommended options, alternatives, warnings, arrival SLA. |
| `RoutePlan` | Found flag, route, route names, distance, note. |
| `StressFailure` | Failure kind + target code. |
| `StageEstimate` | Stage label, seconds, note (stress predictions and analytics). |
| `StressFix` | Fix code, title, detail, applicable, passes alone. |
| `ReadinessSummary` | Score %, passed, total, runs. |
| `SignInResult` | Token, user, expiry. |
| `DemoAccount` | Handle, name, role, title, PIN hint, description. |
| `ScenarioInfo` | Scenario catalog entry (code, title, description, expected, zone, steps, faults, demonstrates). |
| `SimulationStatus` | Scenarios + recent runs. |
| `IncidentSummary` | Queue/map row (see `IncidentTile`). |
| `OpsBoard` | Active (sorted), recent, unit and camera counts, escalated count, campus name. |
| `IncidentDetail` | Redacted incident, zone, timeline, dispatches, signals, policy, plan, victims, allowed actions, viewer role, redactions. |
| `ResponderTask` | Dispatch, incident code, severity, nature, zone, location, route names, instructions, hospital flag, other units. |
| `ResponderHome` | Unit, zone name, current task, recent dispatches. |
| `CareCase` | Hospital row: severity, state, nature, location, onset, handoff state, ready flag, ambulance, scene ETA, units, care notes. |
| `SosStatus` | Member view: state, zone, raised at, message, unit statuses, scene ETA. |
| `OpsEvent` | Live push: kind (`hello`, `incident`, `dispatch`, `signal`, `twin`, `scenario`, `readiness`), incident id, message, time. |
| `OpsMetrics` | MTTC, stages, RCI %, false escalation %, blind-spot %, totals, escalations, breakdowns by reason/family/severity/zone. |
| `CampusTwin` | Zones, roads, cameras, units, active incidents, unit positions. |
| `CareGridException` | Typed error: message + code. |

### 5.3 Enums

| Enum | Values |
| --- | --- |
| `UserRole` | command, medical, responder, admin, member |
| `ZoneType` | hostel, academic, lab, libraryHall, sports, hospital, gate, admin, commons, junction, outside |
| `AssetHealth` | online, degraded, offline |
| `ResponderType` | securityDesk, securityPatrol, ambulance, hospitalEr, facilities, fireSafety |
| `ResponderStatus` | available, assigned, busy, offline |
| `SignalSource` | camera, sos, accessControl, vehicle, iotSensor, operatorReport |
| `EventFamily` | medical, fireHazard, mobility, access, environment, object, crowd |
| `EventType` | personDown, fall, prolongedImmobility, visibleDistress, sosRequest, smoke, fire, crowdSurge, vehicleCollision, routeObstruction, restrictedEntry, flooding, unattendedObject; negative evidence: personRecovered, helpArrived, hazardCleared, reporterCancelled |
| `Severity` | p0 Critical, p1 Urgent, p2 High, p3 Routine |
| `IncidentState` | detected, review, verified, dispatched, acknowledged, enRoute, onScene, care, resolved, dismissed |
| `DispatchStatus` | offered, acknowledged, enRoute, onScene, care, completed, declined, timedOut, recalled |
| `TimelineKind` | signal, agent, policy, dispatch, responder, proof, escalation, operatorAction, care, closure, system |
| `RoadStatus` | open, congested, blocked |
| `Observability` | full, degraded, blind |
| `StressFailureKind` | responderBusy, gateClosed, roadBlocked, cameraDegraded, cameraOffline |
| `Verdict` | pass, fail |

---

## 6. Rules and behaviour

### 6.1 Incident Agent
- **Offline camera:** its signals are suppressed and recorded as untrusted.
- **Degraded camera:** confidence discounted by 15%.
- **Fusion:** a signal joins the newest open incident in the same zone within 10 minutes with the same family (a medical event also joins an open mobility or crowd incident), only within the same scenario run (real signals never join simulated incidents).
- **Member SOS separation:** an SOS joins an open incident only when it is evidently the same request: the same member pressing again, another member naming the same normalized location, or a camera/sensor detection with no conflicting stated location. Otherwise a separate incident is opened and its reasoning names the open request it was kept apart from, so no person is hidden behind another's case.
- **Corroboration:** adjacent camera, an independent source type, or the same camera still seeing the event 8 s or more after onset. SOS and operator reports count as a witness.
- **Victims:** a person event with a different anonymous track, or a person event joining a mobility/crowd incident, becomes a linked victim record. The parent's severity rises one level when it has two or more victims or is non-medical; the hospital is pre-alerted.
- **Negative evidence:** acts only on evidence that clearly refers to the incident: a matching anonymous track, a member withdrawing a request that only they support (bound to that incident, never searched by zone), or the single untracked hazard in the zone. Decisive evidence before dispatch dismisses with the reason; ambiguous evidence (another track, several open incidents, untracked evidence about a tracked person, a withdrawal while cameras still support the case) is recorded and routed to human review. A recovery on a victim's track is recorded on the victim and the parent; the parent response continues. After dispatch, evidence is recorded and units continue.
- **Decision:** verified when confidence ≥ SOP minimum and (corroborated or not required). Confidence below 70% of the minimum goes to human review. Otherwise the agent waits a 20 s corroboration window, then routes to human review. No matching SOP means human review.
- **On verification:** hospital pre-alert if the SOP says so; auto-dispatch SOPs dispatch at once; otherwise next action "Confirm & dispatch ..." with the SOP confirmation SLA as deadline.

### 6.2 Policy selection
Most specific match wins: zone-type match +2, hour window +1; ties go to the more urgent severity. Hour windows wrap midnight (22 to 6).

### 6.3 Routing and planning
- Closed gates are impassable unless `emergencyOverride` is set (start and end zones are exempt). Blocked roads are removed. Congested roads cost 1.5x.
- ETA = mobilization seconds + effective meters / speed.
- One unit per required type (fastest available); fallback types if none; warnings when a type cannot be covered or an ETA misses the onset-to-arrival SLA.

### 6.4 State machine and Proof-of-Response
- Incident state is the furthest stage reached by any of its dispatches (dispatched < acknowledged < en route < on scene < care).
- Deadlines: acknowledgement = SOP ack SLA after dispatch; start moving = 45 s after acknowledgement; arrival = 1.5 x travel time + 30 s after moving; care start = SOP care SLA after arrival.
- Watchdog (every second):
  - detected past the corroboration window → human review;
  - review / verified past the confirmation deadline → escalate and extend the deadline;
  - offered past the ack deadline → dispatch timed out, unit marked unreachable ("radio check"), escalate, re-dispatch the same responder type (or flag the incident commander if none);
  - acknowledged for more than 45 s without moving → stall escalation;
  - en route in an explicit scenario → simulated progress (elapsed / travel time), rerouting around blocked roads and labelled simulated arrival;
  - en route outside a scenario → no generated route progress or arrival; passing the arrival deadline escalates once until the unit confirms its status;
  - on scene past the care SLA without care → escalation.
- Decline → unit released, same-type replacement (or SOP fallback type) dispatched. If no replacement exists the case returns to `verified` with a `Re-dispatch` deadline that keeps escalating until an operator acts; it never sits "dispatched" with nobody coming.
- Resolve requires a verified arrival and recorded care; arrived units complete, units still travelling are recorded as recalled, units return to base, victim records close. Dismiss recalls active dispatches. Command can stand down a single unit mid-response (`releaseUnit`).
- **Concurrency:** units are reserved under a row lock (check available → insert dispatch → mark assigned in one transaction), so two incidents or operators can never hold the same unit. Every dispatch transition re-reads the dispatch under its row lock: a responder's tap and the watchdog's timeout cannot both win. Incidents carry a `revision`; a save from an outdated copy raises `conflict` instead of overwriting newer state (the watchdog simply re-evaluates on its next pass). Incident codes derive from the record id (`INC-{1000+id}`).
- Queue rows report `unitsArrived / unitsAssigned`, because the incident state alone is the furthest unit.
- Queue order: severity, escalation level (high first), nearest deadline, oldest onset.

### 6.5 Autopilot (simulation runs only)
Operator confirms 4 s after verification or review; hospital marks ready 6 s after verification; crews acknowledge 5 s after the offer (unless a `noAck:<unit>` fault), start moving 3 s later, start care 6 s after arrival. Autopilot never resolves an incident.

### 6.6 Stress-Test Engine
- Stage model: detection 4 s (camera online), 10 s (only degraded), 90 s (blind spot, SOS-dependent); verification 5 s (adjacent camera online), 20 s (temporal persistence), 10 s (human report), 3 s (SOP without corroboration); operator confirmation 15 s (0 for auto-dispatch); dispatch 3 s; acknowledgement 15 s; then travel ETA per unit.
- Verdict: pass when every required type has a unit and the slowest arrives within the SOP arrival SLA (from onset).
- Fix candidates: emergency override on normally closed gates (not those under failure), re-staging an available mobile unit of a late type at the hospital (ambulances) or Central Junction (others), restoring degraded/offline cameras. Only fixes that pass alone or shorten the response are reported; passing fixes are combined first to compute the verdict with fixes.
- Fix codes accepted by `applyFix`: `gate-override:<gate>`, `restage:<unit>:<zone>`, `restore-camera:<camera>`.

### 6.7 Access and redaction

| Data | Command | Medical | Admin | Responder | Member |
| --- | --- | --- | --- | --- | --- |
| Incident queue | all | hospital-alerted | all | none | none |
| Incident detail | full | no camera/track ids, no camera reasoning, no raw signals, no camera timeline entries | no location detail, camera or track ids, no raw signals | assigned only: no reasoning, evidence or camera data | none (own SOS status only) |
| Cameras on map | yes | no | yes | no | no |
| Units on map | yes | yes | yes | yes | no |
| Reporter identity | never sent to any client | | | | |

Every incident detail view, sign-in, dispatch, override, dismissal, escalation, fix, policy or twin change, SOS and reset is written to the audit log.

### 6.8 Metrics
- **MTTC:** mean of onset to care start.
- **Stages:** onset→detected, detected→verified, verified→dispatched, dispatched→acknowledged, acknowledged→on scene, on scene→care.
- **RCI (Response Completion Integrity):** dispatched-and-closed incidents whose acknowledgement, arrival and care were all verified and which were resolved, divided by all dispatched-and-closed incidents.
- **False escalation:** verified incidents later dismissed / verified incidents.
- **Blind-spot rate:** incidents with degraded or blind coverage / all incidents.

---

## 7. Seeded data

Source: `caregrid_server/lib/src/seed/seed_data.dart` (fictional **Meridian Demo Campus**). Road lengths are computed from coordinates at 1.5 m per canvas unit.

### 7.1 Zones (26)

| Group | Zones |
| --- | --- |
| Outside | NPOST North Response Post (ambulance A1 standby), PNW and PSW perimeter road points |
| Gates | G1 Main Gate, G2 East Gate, G3 North Gate (open); G4 North-West Service Gate (closed, no override until a fix is applied) |
| Junctions | J1 South-West, J2 South, J3 South-East, J4 West, J5 Central, J6 East, J7 North |
| Buildings | SEC Security Control Room, ADM Admin Block, HOS Campus Hospital, ACD Academic Complex, LAB Chemistry Labs (restricted), LIB Central Library, COM Student Commons, SPT Sports Complex |
| Hostels | HA Aster, HB Birch, HC Cedar, HD Deodar (privacy-sensitive) |

### 7.2 Roads (34)
R1 to R29 on campus (main gate road, south avenue west/east, east gate road, west road, central roads, east road, academic drive, north road and north gate road, hostel lanes, hospital roads, lab roads, library walk/link, sports roads, control-room and admin lanes, service lane HA–G4) and O1 to O5 outside campus (north post approach, perimeter road north/west, service gate approach, main gate approach).

### 7.3 Cameras (19)
CAM-HB-B07 / CAM-HB-B08 (Birch Block B corridor, adjacent), CAM-HA-01 / CAM-HA-02, CAM-HC-01 (**offline**: blind spot), CAM-HD-01, CAM-LAB-02 / CAM-LAB-03, CAM-SPT-01 / CAM-SPT-02, CAM-G2-01 / CAM-J3-01, CAM-LIB-01, CAM-ACD-03, CAM-COM-01 / CAM-COM-02, CAM-G3-01, CAM-HOS-01, CAM-G1-01. All privacy-masked.

### 7.4 Response units (11)

| Code | Unit | Base | Speed | Ready in |
| --- | --- | --- | --- | --- |
| DESK-HA/HB/HC/HD | Hostel security desks | own hostel | 80 m/min | 15 s |
| PAT-1 | Patrol Bike 1 (AED) | J5 | 300 m/min | 15 s |
| PAT-2 | Patrol Bike 2 | J3 | 300 m/min | 15 s |
| AMB-A1 | Ambulance A1 | NPOST | 500 m/min | 30 s |
| AMB-A2 | Ambulance A2 | HOS | 500 m/min | 30 s |
| ER-1 | Hospital ER team | HOS | 80 m/min | 60 s |
| FIRE-1 | Fire & Safety Unit | SEC | 450 m/min | 30 s |
| FAC-1 | Facilities Crew | ADM | 200 m/min | 60 s |

### 7.5 Policies (11)

| Code | Scope | Severity | Verify | Dispatch | Units (fallback) | Arrival SLA |
| --- | --- | --- | --- | --- | --- | --- |
| SOP-HST-MED-NIGHT | hostel, medical, 22–6 | P1 | 75% + corroboration | operator | desk, ambulance (patrol) | 5 m |
| SOP-HST-MED-DAY | hostel, medical, 6–22 | P2 | 80% + corroboration | operator | desk, ambulance (patrol) | 7 m |
| SOP-SPT-MED | sports, medical | P2 | 85% + corroboration | operator | patrol, ambulance | 7 m |
| SOP-LAB-HAZ | lab, fire/hazard | P0 | 70% + corroboration | **auto** | fire safety, patrol (facilities) | 4 m |
| SOP-FIRE-ANY | any, fire/hazard | P1 | 75% + corroboration | **auto** | fire safety (patrol) | 5 m |
| SOP-ROAD-COLL | any, mobility | P1 | 70% | operator | patrol, ambulance | 6 m |
| SOP-MED-ANY | any, medical | P2 | 80% + corroboration | operator | patrol, ambulance (desk) | 7 m |
| SOP-CROWD | any, crowd | P1 | 75% + corroboration | operator | patrol, ambulance (desk) | 5 m |
| SOP-LAB-ACCESS | lab, access | P2 | 80% | operator | patrol | 5 m |
| SOP-ENV-ANY | any, environment | P3 | 70% | operator | facilities (patrol) | 15 m |
| SOP-OBJ-ANY | any, object | P3 | 70% | operator | patrol | 10 m |

### 7.6 Users (10)
`cmd.night` / 1111 (command), `er.doctor` / 2222 (medical), `amb.a2` / 3302, `desk.birch` / 3303, `amb.a1` / 3301, `patrol.one` / 3304, `fire.one` / 3305 (responders bound to AMB-A2, DESK-HB, AMB-A1, PAT-1, FIRE-1), `ops.admin` / 9090 (admin), `student.aanya` / 5501 and `staff.rohan` / 5502 (members).

### 7.7 Live scenarios (8)

| Code | Signals (seconds after start) | Expected |
| --- | --- | --- |
| SC-HOSTEL-0217 | 0 s person down CAM-HB-B07 86% T-41; 2 s CAM-HB-B08 91% T-41 (local 02:00) | P1 verified, desk + A2, full proof chain |
| SC-SPORTS-RECOVER | 0 s fall CAM-SPT-01 82% T-7; 5 s person recovered (17:00) | dismissed by negative evidence |
| SC-LAB-SMOKE | 0 s smoke CAM-LAB-02 84%; 3 s smoke detector 95% (14:00) | P0 auto-dispatch fire + patrol |
| SC-SOS-LIBRARY | 0 s SOS at LIB (15:00) | verified on human report, awaits operator |
| SC-EASTGATE-COLLISION | 0 s collision CAM-G2-01 88%; 2 s rider down T-3 (19:00) | one incident, victim linked, P0 |
| SC-CROWD-VICTIMS | 0 s and 2 s crowd surge on COM-01/02; 4 s and 6 s two people down T-11, T-12 (21:00) | parent + 2 victims, P0 |
| SC-MISSED-ACK | hostel person down on two cameras, fault `noAck:AMB-A2` (02:00) | A2 times out at 30 s, A1 re-dispatched |
| SC-CEDAR-BLIND | 0 s SOS at HC (23:00), camera offline | blind spot reported, desk + nearest ambulance |

### 7.8 Stress rehearsals (4)

| Code | Failures | Result on the seeded twin |
| --- | --- | --- |
| ST-HOSTEL-0217 | AMB-A2 busy, G3 closed, CAM-HB-B08 degraded (02:00) | FAIL 6 m 41 s vs 5 m. Fixes passing alone: G4 emergency override (4 m 12 s), re-stage AMB-A1 at HOS. Restoring CAM-HB-B08 helps but does not pass. |
| ST-LAB-FIRE-OUT | FIRE-1 busy (14:00) | FAIL 6 m 33 s vs 4 m (facilities fallback). Fix: re-stage FAC-1 at J5 (3 m 6 s). |
| ST-CEDAR-BLIND | CAM-HC-01 offline (23:00) | PASS 3 m 35 s, with blind-spot finding. |
| ST-EASTGATE-ROAD | R3 blocked (18:00) | PASS 3 m 23 s. |

Applying both fixes raises readiness from 50% to 100%.

### 7.9 Incident history (14)
Past incidents over the last two weeks so analytics have data on first launch: hostel person-downs and falls, a sports fall dismissed by negative evidence, lab smoke, crowd surge, SOS from a blind spot, East Gate collision, restricted lab entry, a library false positive (verified then dismissed), a degraded-coverage hostel case with escalation, flooding, an SOS whose arrival was never verified (lowers RCI), a missed acknowledgement with re-dispatch, and an unattended object dismissed by negative evidence.

---

## 8. Configuration and operations

| Item | Value |
| --- | --- |
| Ports (development) | API 8080, Insights 8081, web 8082, embedded PostgreSQL 8090 (tests 9090) |
| Local secrets | `caregrid_server/config/passwords.yaml` (git-ignored): `development.database`, `development.serviceSecret`, `test.database` |
| Campus time zone | `CAREGRID_UTC_OFFSET_MINUTES` (default 330) |
| App server URL | `--dart-define=SERVER_URL=...`, else `assets/config.json`, else localhost |
| Web build served by server | `caregrid_server/web/app` (built by `serverpod run flutter_build`) |
| Migrations | `caregrid_server/migrations/`; applied by `--apply-migrations`, `serverpod start`, and every Serverpod Cloud deploy |
| Cloud | `serverpod cloud launch` (first time), `serverpod cloud deploy`; CI via `.github/workflows/deploy.yml` with `SERVERPOD_CLOUD_TOKEN` |
| CI | `analyze.yml` (server + app, fatal infos), `format.yml` (server + app), `tests.yml` (server tests on embedded PostgreSQL) |

**Prototype limits.** Single server instance: the ops ticker and pending scenario steps live in memory (multi-instance would use recurring future calls and a lock). Sign-in uses seeded handles and PINs (campus SSO replaces it behind the same authentication handler). Responder movement and arrival are simulated telemetry. No vision model runs: camera signals come from the simulator or `signal.ingest`, which is the contract a real edge detector would call.

## 9. Submission web prototype (`caregrid_web/`)

| File / surface | Responsibility |
| --- | --- |
| `server.mjs` | Dependency-free loopback-only static server; path containment and MIME handling. Serves this presentation at `/demo` and `/index.html`. |
| `index.html`, `styles.css` | Responsive application shell on the shared `brand.css`: glass top bar for the six views (no sidebar), clock, scenario, reset, status and about controls. |
| `app.js` / Command | Synthetic queue/filter, campus SVG, resource/coverage fixtures, proof summary and scenario controls. |
| `app.js` / Incident workspace | Illustrated evidence, fixture brief, deterministic plan, explicit response actions, audit timeline and JSON export. |
| `app.js` / Responder | Minimal task context and next-step action; explicit demo check-in, no real GPS. |
| `app.js` / Care | Minimized handoff context and medical-team-ready demo action. |
| `app.js` / Readiness | Three selectable failures, isolated what-if model, alternate-route intervention; no live asset mutations. |
| `app.js` / After-action | Illustrative stage timings and seeded response-integrity denominator, never pilot results. |
| `domain.mjs` | Pure response state transitions, missed-ACK escalation, synthetic rehearsal calculator. |
| `tests/domain.test.mjs` | Guards closure ordering, prevents silence becoming acceptance, verifies isolated rehearsal intervention. |
| Browser state | `caregrid.duality.v1` localStorage key; synthetic data only; reset affects only that key. |
| Capture fixtures | Explicit `?demo=` initial states; deep-link views via URL hash. |

Role/view navigation is presentation behavior, not production authorization. All Google AI, identity, map and cloud data integrations remain proposed until connected and tested. Original Dart services and generated clients were not rewritten.
