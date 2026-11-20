# From the current repository to a Google Cloud pilot

This is an implementation backlog with acceptance gates, not a claim that migration is complete. User priority: architecture + screenshot-ready submission first, cloud setup later.

## Repository decisions

Keep `caregrid_server`, `caregrid_client` and `caregrid_flutter`; do not hand-edit generated clients. `caregrid_web` now includes a connected Serverpod/PostgreSQL workspace and a separate browser-local presentation. The local RPC contract is verified against Serverpod 4.0.4 and the real backend. [Completed local slice](CONNECTED-MVP.md). Keep `12112026` as supplied design/source material.

The existing Serverpod framework can run on Google-managed compute. Its present Dockerfile/config and Serverpod Cloud CI are **not** a complete Cloud Run deployment. The old automatic external-cloud deploy path is already disabled and retained as a manual historical workflow. The current Google runtime/identity code is merged; infrastructure is prepared and tested offline. No Google project has been deployed.

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
| Frontend transport | Connected Node gateway + web workspace | Local flow complete; cloud-mode stateless Firebase bearer forwarding and Google service identity implemented. Exact-origin HTTPS and actual IAM/OAuth remain live gates. |
| API container | Unprivileged Dart Linux image; separate web image | Custom Cloud Run port, maintenance job and deployed demo lockout pass Linux CI. Only API ingress is exposed; Insights/web listeners remain internal. The current BFF runs on Cloud Run; Firebase Hosting is optional future fronting, not an active runtime. |
| Configuration | Production environment overrides and runtime policy | Google infrastructure supplies exact hosts, Unix socket, pool limits, pinned secrets and JSON logging. Cloud provider behavior remains unverified. |
| Database | Additive membership migration and Cloud SQL module | Non-superuser maintenance/bootstrap checks pass in Linux CI. Complete live SQL grants, connector verification, backup/restore and phased rollout. Shared staging SQL role/private-IP/HA limits are explicit in the runbook. |
| Identity | Firebase verifier, SQL membership and private bootstrap commands | RSA/project/time validation, role authority, disabling/revocation and competing binds are tested. Configure real Firebase provider/domains and prove live OAuth/IAM; campus tenancy remains a pilot gate. |
| AI adapter | Optional command-only handoff endpoint/UI and Gemini REST adapter implemented | Input allowlist, workload identity, schema/reference validation, timeout/circuit/cache and stale-result checks tested with fixtures. Actual model/region validation, semantic evaluation, measured cost and real Google output remain required. Deterministic decision authority stays separate. [Adapter details](GOOGLE-GEMINI.md). |
| Evidence | Optional command-only GCS broker, constrained upload/read/removal UI and bucket-scoped API grant implemented | Header/size/dimension checks, digest/generation validation, role denial and audit tested with provider fixtures. Live IAM/GCS checks, ingest scanning, approved metadata/retention policy, reconciliation and tenant isolation remain gates. [Evidence runbook](GOOGLE-EVIDENCE.md). |
| Google build/deploy | Terraform and build-only Cloud Build configuration | Offline schema plus ten mocked rollout plans pass. Run Cloud Build -> Artifact Registry -> maintenance job -> Cloud Run once a project exists. Pipeline identity has no deploy or SQL/secret rights. |
| Operations | Coordinated SQL watchdog and structured failure monitoring | Worker passes serialize across revisions; continuous CPU/min instance configured. Live restart recovery, heartbeat/oldest-overdue alerts, transactional effects and staffed notification delivery remain gates. |

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

One authenticated command operator can ingest a synthetic signal into the real database, receive a real bounded Gemini brief, inspect its evidence references, confirm a deterministic plan, have a separately authenticated responder accept/move/arrive/start care, and close with an outcome. Missed ACK escalates after worker restart. A different role cannot retrieve raw evidence. The UI shows real/synthetic provenance. Build logs and tests reproduce the run. Only then describe the Google integrations as verified end to end.
