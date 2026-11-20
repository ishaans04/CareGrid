# CareGrid connected response workspace

Team Duality · shared Serverpod/PostgreSQL state · synthetic data only. Updated 20 November 2026.

From the repository root on Windows with Node 22+, start the full MVP:

```powershell
powershell -File scripts/start-local.ps1
```

The first launch downloads the pinned Dart 3.12.2 SDK, verifies its official SHA-256 checksum, resolves dependencies, and lets Serverpod download embedded PostgreSQL. All application state, SDK and dependency files remain under ignored `tmp/` (PostgreSQL binaries use Serverpod's user-local cache). No Flutter installation, Google project or billing is required. Subsequent starts preserve the synthetic local database.

If the checkout lives in OneDrive, Dropbox or another synced folder, set `CAREGRID_WORK_DIR` to an unsynced absolute path (for example `C:\Users\you\.caregrid-work`) before starting. The launcher, generator and browser tests then keep the Dart SDK, pub cache, server workspace and embedded PostgreSQL there; sync clients otherwise slow PostgreSQL enough for Serverpod start-up and the integration tests to time out.

With Dart already available, run `node scripts/dev.mjs` from the repository root. `DART_EXECUTABLE` can select a specific SDK. The launcher prepares a server-only workspace, applies the existing migration, waits for the seeded backend, and opens the loopback web service. It checks ports 8080/8081/8082/4173 before starting. Stop the owning terminal with Ctrl+C; do not start a second copy on the same ports.

Open <http://127.0.0.1:4173>. The sign-in screen lists seeded accounts and intentional demo PIN hints. Use separate browser profiles or private windows for simultaneous roles. Command owns and dispatches cases, responders record their milestones, medical staff prepare the receiving team, admin runs readiness and analytics, and members send/follow their own SOS requests. The backend enforces role and assignment access. [Implementation and boundaries](../docs/buildathon/CONNECTED-MVP.md).

To demonstrate arrival provenance, send an SOS from a member, approve its dispatch from command, then sign in as the assigned responder. Elapsed time cannot confirm arrival for this case. The responder must acknowledge, depart, confirm arrival and record care before command can close it. The per-unit proof panel and timeline update from the database. Rehearsal scenarios use explicitly labelled simulated travel instead.

This is loopback development authentication, not production identity. No camera, live GPS, emergency service, Gemini, Maps or Google Cloud deployment is connected. Local gateway sessions are held in memory and end on restart. Cloud mode instead uses bundled Firebase Google sign-in, stateless bearer forwarding and Cloud Run service identity; see [identity setup and limits](../docs/buildathon/GOOGLE-IDENTITY.md). Its real OAuth flow remains untested without a project. SQL deadlines and a coordinated separate watchdog runtime are implemented; transactional effects and pilot reliability gates remain open. [Cloud acceptance gates](../docs/buildathon/IMPLEMENTATION-PLAN.md) remain open.

An optional command-only [Gemini handoff draft](../docs/buildathon/GOOGLE-GEMINI.md) is implemented and disabled by default. It receives minimized recorded facts, has no dispatch authority, and requires real Google model validation before enablement. Drafting does not block response actions. Switching cases clears old controls until the selected record loads.

## Checks and connected screenshots

Command also has an optional [private evidence panel](../docs/buildathon/GOOGLE-EVIDENCE.md), disabled by default. It brokers bounded PNG/JPEG observations through the authenticated API. It cannot create arrival/care proof. Storage errors stay within the panel; previews close after sixty seconds and clear on context/connection loss. Real Google storage/IAM/retention validation remains pending.

Browser tests create synthetic incidents and change responder availability. For repeatable captures, start the launcher with a separate initially empty absolute `SERVERPOD_DATABASE_DATA_PATH`, such as `E:\Projects\CareGrid-\tmp\capture-run\pgdata`. **Use a distinct parent directory for each embedded database:** Serverpod keeps its supervisor/socket/state files beside `pgdata`; sibling data directories with the same parent can collide. Stop another local instance first and do not overlap server preparation/generation/test runs. This preserves your existing development database; CI starts from a fresh workspace.

```powershell
cd caregrid_web
npm.cmd ci
npm.cmd run build
npm.cmd test
# With the complete backend running and Google Chrome installed:
npm.cmd run test:browser
# Optionally export screenshots while exercising the same real workflow:
$env:CAREGRID_CAPTURE = '1'
npm.cmd run test:browser
```

Browser tests use separate, temporary Chrome contexts, never a personal profile. They include a separate Google-entry configuration preview (not OAuth) and cover the shared multi-role loop, missing-care closure guard, unauthorized API calls, backend readiness/analytics, mobile overflow, draft retention and connection failure. Captures go to [assets/pitch/connected](../assets/pitch/connected/README.md). `node --test caregrid_web/tests/*.test.mjs` runs the domain/gateway tests without an npm install. For backend checks, prepare with `node scripts/dev.mjs --prepare-only`, then run `dart test` and `dart analyze` from `tmp/server-runtime/caregrid_server` using the same SDK/PUB_CACHE as the launcher.

## Original pitch presentation

The original six-view presentation is at <http://127.0.0.1:4173/index.html>. It remains a separate browser-local demonstration with reproducible fixtures. Its view selector illustrates roles; it does not authenticate. Its simulated controls and illustrative 401s → 252s result are not backend operations. To serve only this presentation, run `node caregrid_web/server.mjs` and visit `/index.html` directly; no Dart or npm installation is required.

Design follows the supplied `12112026/CareGrid v2.dc.html`: ink, warm paper, lime and cyan; Archivo, Instrument Serif and Martian Mono; fine rules, numbered sections, editorial hierarchy and a schematic campus. Local fonts have system fallbacks. All numbers are fixtures, illustrative predictions or demo observations, never customer outcomes.

Presentation view links use `/index.html#overview`, `/index.html#incident`, `/index.html#responder`, `/index.html#care`, `/index.html#readiness`, `/index.html#analytics`. Capture fixtures append `?demo=verified`, `?demo=dispatched`, `?demo=active`, `?demo=care`, `?demo=readiness` or `?demo=outcome`, followed by the view hash. Remove the query to resume stored presentation state.
