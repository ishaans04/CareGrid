# Optional Gemini handoff drafts

20 November 2026. The adapter, endpoint and UI are implemented; **a real Google model has not been called**. Test responses are synthetic fixtures. Do not label the current screenshots as live Gemini output or claim an evaluated AI system.

## Product boundary

A command operator can explicitly request a short handoff draft alongside an incident. Deterministic campus policy, routing, dispatch, responder milestones and human closure remain authoritative. The model has no tools or mutation interface. A failed/disabled draft produces an explicit notice, without invented fallback prose. Response actions remain available while the optional request is pending.

The server's input allowlist contains twelve enum/count/boolean facts: event type, recorded state/severity, signal source, simulation/review flags, assignment count, recorded acknowledgements/arrivals/care starts, hospital pre-alert and hospital-ready records. It excludes names, incident identifiers, exact locations, camera/track IDs, member IDs, free-text observations/reasoning/notes, raw evidence and routes. Minimization reduces exposure; these facts still concern an incident and must be handled under the institution's approved purpose/data policy.

Changing incident selection immediately removes the previous case's controls while the new record loads. This avoids offering actions against the old case during an asynchronous selection change. The browser regression deliberately holds the detail response to check that boundary.

`BriefingSnapshot` is the only model input builder. The adapter depends on that minimized snapshot and HTTP, with no database or response-engine access. `BriefingEndpoint` enforces the command role before reading any case. It checks the incident/dispatch snapshot again after generation and discards changed-source results. The browser also clears pending/results when the selected record changes, an operator mutation begins, the view changes or the session ends.

## Google request and validation

The adapter calls the regional or explicitly selected global Google `v1 ... publishers/google/models/MODEL:generateContent` REST method. It uses attached service identity via the metadata server on Cloud Run; outside Cloud Run it uses Application Default Credentials. No browser API key or service-account file is needed for the model runtime. Disabled assistance never acquires credentials.

The request is tool-less, with one candidate, a small output budget, JSON MIME type and an explicit object schema. The response must complete normally, contain only `summary` and `evidenceRefs`, fit bounded body/text sizes and reference unique IDs from the supplied allowlist. Blocked, truncated, malformed, oversized, unknown-reference or extra-field outputs are discarded. Redirects are refused. The UI HTML-escapes prose and metadata.

These checks validate **shape and reference identifiers, not factual correctness or clinical safety**. A generated draft can still misstate a count or add an unsupported claim. Every generated result carries a review notice and source timestamp. No model result is applied to an incident or shared as an approved instruction automatically. The prompt/schema version is `handoff-facts-v1`; changing either requires a new version and evaluation.

Limits are per API process: one active inference, ten seconds between new attempts, at most 32 cached snapshots for two minutes, and a one-minute circuit opening after three failures. Cached results require the same incident version and minimized dispatch facts. The total eight-second request budget includes credentials, HTTP and response reading; transport closes on completion/timeout. No application inference retries occur. These controls do not constitute a fleet-wide spend cap; use actual model quotas, budgets, max instances and observed billing before enabling.

Audit records contain caller, incident, result status and prompt version. Raw prompts, generated text, access credentials and provider error bodies are not logged or stored in SQL by this feature. Drafts are transient memory. Existing Cloud Logging/platform settings and Google's model data-governance terms still require project-specific review.

## Enable only after project setup

In [the Google infrastructure module](../../infra/google/README.md), leave `enable_gemini=false` until a compatible model is available and evaluated in the chosen project/location. Enablement requires explicit `gemini_model` and `gemini_location`; there is no guessed default model or silent cross-region/model fallback. Prefer a stable versioned identifier when supported. Verify the exact model's structured-output, token-budget and location behavior against current documentation.

The module enables `aiplatform.googleapis.com` and grants a custom inference-only project role to the **API** identity: `aiplatform.endpoints.predict` plus `serviceusage.services.use`. Web, watchdog, builder and maintenance jobs receive no inference grant. The role is scoped to the project, not cryptographically restricted to a single publisher model; the application fixes the model/endpoint from validated server configuration. No deploy/tune/admin permissions are granted by this feature.

Runtime equivalents are `CAREGRID_GEMINI_ENABLED=true`, `CAREGRID_GEMINI_MODEL`, `CAREGRID_GEMINI_LOCATION`, and the existing `FIREBASE_PROJECT_ID` as Google project ID. Invalid configuration returns unavailable assistance without preventing other response operations. A global endpoint is an explicit processing-location decision, not an India-residency guarantee.

Before claiming the integration works: run on Google with the attached API identity; record the actual model/version, prompt version and release digest; verify a real returned draft and its evidence IDs; reject wrong-role requests; simulate timeout/429/5xx/blocked output; change a case during generation; check primary actions remain usable; and review actual cost/logging behavior. Evaluate a frozen synthetic corpus for unsupported claims, per-unit stage confusion, simulation disclosure and harmful advice before any institutional use. The existing fixtures and tests are not such an evaluation.

## Verification

Backend analysis is clean and **73 tests passed**, including eight adapter/snapshot checks and three endpoint integration checks against real PostgreSQL. They cover input minimization, fixed endpoints, schema/reference rejection, timeout/circuit/cache/concurrency behavior, role denial, no incident mutation and stale-response rejection. The web suite has **26 passing checks**, including output escaping and explicit disabled rendering. Infrastructure validation and **ten mocked plans passed**, including disabled-by-default inference, explicit model/location and limited permissions. Browser/live-provider verification is recorded separately in [validation](VALIDATION.md).

Official contracts: [structured output](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/capabilities/control-generated-output), [generateContent](https://docs.cloud.google.com/gemini-enterprise-agent-platform/reference/models/inference), [IAM permissions](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/access-control), and [application credentials](https://docs.cloud.google.com/docs/authentication/application-default-credentials). Exact pinned `googleapis_auth` source was inspected for metadata identity, token refresh and request forwarding.
