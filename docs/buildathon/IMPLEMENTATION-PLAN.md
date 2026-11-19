# From the current repository to a Google Cloud pilot

This is an implementation backlog with acceptance gates, not a claim that migration is complete. User priority: architecture + screenshot-ready submission first, cloud setup later.

## Repository decisions

Keep `caregrid_server`, `caregrid_client` and `caregrid_flutter`; do not hand-edit generated clients. `caregrid_web` now includes a connected Serverpod/PostgreSQL workspace and a separate browser-local presentation. The local RPC contract is verified against Serverpod 4.0.4 and the real backend. [Completed local slice](CONNECTED-MVP.md). Keep `12112026` as supplied design/source material.

The existing Serverpod framework can run on Google-managed compute. Its present Dockerfile/config and Serverpod Cloud CI are **not** a complete Cloud Run deployment. Disable the old automatic external-cloud deploy path before using main for the Google event; keep it manual/historical if retained.

## Phase A: submission package

- Source audit of all 40 PDF pages, both designs and current docs.
- Google service mapping with rationale, failure semantics, cost model and claim boundaries.
- Diagram in editable SVG plus raster export.
- Local interactive command, incident, responder, care, rehearsal and analytics views with fictional data.
- Exported product assets with captions saying “interactive prototype / synthetic data”.
- No GCP billing or credentials needed.

## Phase B: deploy a real cloud vertical slice

| Work | Existing location | Required change / acceptance |
| --- | --- | --- |
| Frontend transport | Connected Node gateway + web workspace; generated Dart client remains separate | Local adapter complete. Replace demo identity, configure HTTPS/origins and distributed session handling or direct verified identity before Cloud Run. Preserve explicit connection errors; no silent fixture fallback. |
| API container | `caregrid_server/Dockerfile`, production config | Cloud Run ingress must bind `0.0.0.0:$PORT`. Serverpod has API :8080, Insights :8081, web :8082; expose only the intended API ingress and keep Insights private/disabled. Serve web separately via Firebase Hosting. Test streaming and TLS origins. |
| Configuration | `caregrid_server/config/production.yaml` | Replace placeholder hosts, validate environment overrides against Serverpod 4 docs, define SQL host/SSL/connection limits, CORS and log output. Do not embed passwords into a build layer. |
| Database | Existing migrations/models | Apply migration once as a controlled job before traffic; backups and rollback plan. Cloud SQL private networking or tested Auth Proxy/connector sidecar. Verify Dart socket/TCP compatibility. |
| Identity | `server.dart`, `account_endpoint.dart`, `core/access.dart` | Replace public PIN login with Firebase ID token validation and SQL campus membership. Remove demo-account exposure in deployed mode. Role change/session revocation tests. |
| AI adapter | New bounded internal service/module | Workload credentials, model/prompt/schema versions, input minimization, timeout/circuit breaker, actual Gemini output and validation. Synthetic fixtures are labeled fixtures. |
| Evidence | Existing `ServerpodCloudProvider` registration | Replace provider-specific paths with Google Cloud Storage access broker or an actually supported adapter. Private bucket, constrained upload, authorized short-lived read, deletion/audit. |
| Google build/deploy | Existing `.github/workflows/deploy.yml` | Cloud Build → Artifact Registry → Cloud Run. If GitHub trigger is retained, use reviewed keyless federation; the deployed service path stays on Google. |
| Operations | New metrics/log config | JSON logs to stdout, heartbeat, model failures, DB capacity, stale state and uptime checks. Alerts reach a staffed owner. |

Do not use a guessed Docker tag, SDK version or environment variable as a deployment guarantee. Verify current Dart/Flutter/Serverpod compatibility and pin the actual build toolchain when setting up CI.

## Phase C: safety and durability before real use

1. **Simulation isolation:** fixed and regression-tested locally on 19–20 November. `_advance` requires an explicit scenario run; arrival source is `simulation`. Non-simulation travel never invents arrival, overdue units escalate, and closure cannot manufacture care. Genuine telemetry provenance and per-SOP closure criteria still require implementation.
2. **Transactional state:** unit reservation, incident revision, dispatch record, deadline and outbox commit together. Test two concurrent commands competing for one ambulance and retrying the same command.
3. **Durable clock:** SQL deadline jobs, lease/fencing, restart recovery and reconciliation. Test killing the worker before/after commit and injecting duplicate execution. Tasks is a retry/backup transport, not the sole urgent timer.
4. **Tenant isolation:** add campus membership and tenant-scoped foreign keys/queries. Test ID guessing and cross-campus role/evidence access for every endpoint.
5. **Telemetry provenance:** sequence, timestamps, accuracy, device identity and stale/spoof checks. Distinguish estimated progress from verified arrival; retain manual overrides.
6. **Per-unit proof:** incident summary must not hide unarrived required units because another unit progressed further. Explicit closure criteria reflect the approved SOP.
7. **Notifications:** FCM payload contains identifiers/version only; explicit ACK; failed delivery and silent devices trigger the staffed fallback. No “push sent = acknowledged”.
8. **Local continuity:** operator runbook, radio/phone fallback, buffered events, explicit disconnected status, reconciliation/drill. No claim that the current prototype already operates offline as an emergency service.
9. **Privacy and governance:** approve purpose, notices, role matrix, retention, children handling, vendor terms, evidence access and incident response with the institution.
10. **Evaluation:** frozen test corpus, model failure/abstention checks, field drills, false-negative review and site-specific thresholds. No autonomous model retraining from operator labels without review.

## Suggested two-founder work split

| Owner | First deliverable | Follow-up |
| --- | --- | --- |
| Hriday | Submission visuals, command/responder/care flows, accessibility and demo rehearsal | Authenticated web transport, device UX, privacy/error/stale states |
| Ishaan | Domain/AI adapter, Google deployment, transactions and identity | Durable deadlines, telemetry, load/failure tests, integration contracts |
| Both | Operator discovery, approved SOP, claim review and pitch | Supervised pilot drills and baseline measurement |

These are proposed responsibilities, not assumptions about either founder's availability.

## Definition of a cloud MVP

One authenticated command operator can ingest a synthetic signal into the real database, receive a real bounded Gemini brief, inspect its evidence references, confirm a deterministic plan, have a separately authenticated responder accept/move/arrive/start care, and close with an outcome. Missed ACK escalates after worker restart. A different role cannot retrieve raw evidence. The UI shows real/synthetic provenance. Build logs and tests reproduce the run. Only then describe the Google integrations as implemented.
