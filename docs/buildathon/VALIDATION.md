# Validation record

## Finalized UI and team operations · 20 November 2026, late evening

This section supersedes the older test counts and pre-deployment claims below. The application source remains the finalized UI release (`aa9e40d`, recorded on `main` in `3b84a33`). This refresh changes documentation, artwork, captures and operator tooling.

| Check | Result and scope |
| --- | --- |
| Backend | **107 passed**, Dart 3.12.2 / Serverpod 4.0.4, real embedded PostgreSQL and labelled identity/provider fixtures. The serial Windows run used `dart test --concurrency=1`; it covers campus isolation, membership, deployment boundaries, response proof and readiness. |
| Node | **34 passed**, covering domain/rendering and gateway boundaries. |
| Browser | **Six passed** against a fresh local synthetic database. The connected SOS/dispatch/care workflow uses real backend calls. The briefing race, storage UI and Google-entry layout retain their explicitly mocked provider responses. |
| Reused local state | The first browser run returned a different readiness score against an already modified rehearsal database. A fresh `CAREGRID_WORK_DIR` restored the baseline and all six passed. No assertion or application logic was changed to obtain the pass. |
| Windows backend startup | The first parallel run hit four Serverpod startup timeouts. A serial run after closing the interactive launcher passed all 107. This records the observed resolution without claiming a proven root cause. |
| Live team roles | Both existing Google identities were bound successfully: `niet.command` and `niet.admin`, through private bootstrap executions recorded in [demo operations](DEMO-OPERATIONS.md). No public role picker or PIN login was enabled. |
| Terraform safety | Corrected stale local stage/image inputs; refreshed plan initially reported no changes. The reviewed notification update was **0 add / 2 change / 0 destroy**, touching only the two alert policies' channel lists. |
| Notification delivery | A synthetic INFO-log policy opened alert `0.of8rcyxiiufv`; the team confirmed receipt in both inboxes. The temporary test policy was removed. Actual API/watchdog failure induction was not performed. |
| Documentation visuals | Two Mermaid diagrams render; the embedded GeoJSON parses with two polygons. SVG cover/architecture exports and finalized UI captures were visually inspected. The [launch gallery](../../assets/pitch/launch/README.md) records provenance and the [deck exports](../../assets/pitch/launch/deck/README.md) match the requested panel proportions. |
| CI | `main` at `b2524cd` passed Analyze, Format, Tests, Connected MVP checks and Google infrastructure checks. See [Actions](https://github.com/ishaans04/CareGrid/actions) for subsequent documentation commits. |

Live browser sign-in after binding, two-person Google-token campus/role denial and watchdog restart during an incident remain explicit acceptance checks. Local test passes, UID binding and a notification canary do not establish those behaviors. Gemini and evidence remain disabled in live configuration.

## Earlier connected MVP verification · 20 November 2026

The local backend and connected web workspace are now implemented and exercised. The 12 November record below is preserved as the historical submission-package check.

| Area | Current result |
| --- | --- |
| Backend tests | **73 tests passed** using Dart 3.12.2 / Serverpod 4.0.4: previous 60 plus ten GCS/image-boundary checks and three evidence endpoint integration checks. PostgreSQL integration tests use the real embedded database; identity/model/storage provider checks use synthetic fixtures. |
| Response correctness | Regression checks prove elapsed time cannot create arrival outside an explicit scenario; overdue travel escalates once; authenticated check-in works; scenario arrivals are labelled; closure cannot manufacture a care milestone. |
| Backend access boundaries | Role/assignment tests, unshared-case id guessing by medical accounts, evidence redaction and admin exact-location redaction passed. This does not establish tenant isolation or production security certification. |
| Static analysis | `dart analyze` on the complete isolated server workspace: **No issues found**. Flutter checks run separately in GitHub Actions. |
| Node checks | **26 passed**: previous 17 plus eight attachment state/rendering checks and one route-specific upload/body/cache check. They cover private-preview cleanup, stale results, metadata consistency, pagination, optional errors, authentication/session boundaries and bounded gateway behavior. |
| Browser interaction | **Six isolated Chrome tests passed**: three real local workflow tests, a delayed-draft race with one mocked briefing response, an evidence UI flow with mocked storage responses, and a Google-entry preview with mocked public Firebase configuration (not OAuth). Real API flows cover SOS → dispatch → responder milestones → receiving-team readiness → human closure, readiness/analytics/audit, connection loss and role denial. Storage/model fixtures do not demonstrate live providers. |
| Mobile | Browser viewports at **390 × 844 CSS pixels** tested for member/responder overflow. Form drafts survive polling. Responder actions remain in a mobile action tray. This is browser emulation, not a physical-device field trial. |
| Assets | Eight connected product captures plus separately labelled Google-entry and private-attachment previews, with local fonts and synthetic-data labels. Attachment preview uses a synthetic floor-plan image and mocked storage responses. Gallery and provenance in [connected assets](../../assets/pitch/connected/README.md). |
| Launch | Windows portable SDK SHA-256 checked; server-only workspace and real PostgreSQL start successfully; Node gateway waits for backend seeding. No Flutter or Google credentials needed for the local workflow. |
| Infrastructure | Google provider 8.12.0 schema validation and ten mocked Terraform rollout plans passed. Both Linux images and private maintenance/bootstrap commands passed CI. A real authenticated GCS-backed foundation plan passed: 46 additions, no updates/deletions; it remains unapplied. Runtime OAuth/IAM/SQL network acceptance is pending. [Deployment module](../../infra/google/README.md), [provisioning record](GOOGLE-PROVISIONING.md). |
| Gemini | Optional adapter and command UI implemented; minimized enum/count input, fixed Google endpoint, schema/reference checks, bounded inference and stale-result rejection tested. No real model call or semantic evaluation has run. [Scope and limits](GOOGLE-GEMINI.md). |
| Evidence | Optional command-only GCS broker/UI implemented and disabled by default. Role denial, generation/digest/type/size boundaries, audit and failure budgets tested with fixtures. Real storage/IAM, scanning, retention/restore and cross-service reconciliation remain acceptance gates. [Evidence contract](GOOGLE-EVIDENCE.md). |
| Cloud / external effects | The existing billed project/Firebase app were configured, APIs enabled, budget corrected and private Terraform state bucket created. No application services, SQL, runtime secrets, build, model call, real notification or event submission occurred. Identity/gateway/watchdog and optional Gemini/GCS code have local/synthetic checks; live application integration remains unverified. FCM delivery is unimplemented. [Dated setup inventory](GOOGLE-PROVISIONING.md). |

Dependency audit: the pinned npm dependency tree returned **0 known vulnerabilities** on 20 November 2026. This is a point-in-time registry check, not a security certification.

Source contract references: pinned official [Serverpod client source](https://github.com/serverpod/serverpod/tree/4.0.4/packages/serverpod_client/lib/src) and [Playwright browser configuration](https://playwright.dev/docs/browsers). Runtime HTTP requests and isolated browser contexts verified the contract locally. For commands, scope and limitations, see [connected MVP](CONNECTED-MVP.md) and [workspace instructions](../../caregrid_web/README.md).

## Historical submission-package verification · 12 November 2026

12 November 2026. This records checks actually performed, with limits.

| Area | Result |
| --- | --- |
| Source review | All 40 pages across three original PDFs read; image-only deck rendered/read visually; original Markdown docs and visible/dynamic content of both design exports reviewed. PDF hashes/page coverage in `pdf-review-manifest.json`. |
| Public rules crawl | Home page, registration-routing script, portal application bundle and discovered public event endpoints checked; broken/empty terms path and deadline discrepancy documented. No registration/submission performed. |
| Research link reachability | 136 links returned HTTP 200 after correcting one Model Armor path. `source-verification.json` retains URLs, redirects, titles and dates. Reachability is separate from semantic review and deployment testing. |
| JavaScript syntax | Node syntax checks passed for application, static server and domain module. |
| Domain tests | Three meaningful checks passed: full explicit lifecycle before closure; missed acceptance cannot advance without alternate-unit escalation; rehearsal is isolated and intervention changes the modeled verdict. |
| Local serving | Loopback static server returned HTTP 200 and served the app/modules/fonts used by screenshots. No dependency install is required to run the prototype. |
| Visual rendering | All six desktop views, two narrow views and the architecture raster inspected. Local Google Fonts and licenses included. Initial narrow export was regenerated to avoid Windows headless Chrome's minimum viewport cropping. |
| Responsive layout | Headless DOM diagnostics at requested widths 440, 540, 768 and 1600 reported no horizontal content overflow in the responder view. The 440 request rendered at 504 CSS pixels due to Windows Chrome constraints; this is not a 440px device test. Published narrow images use 540px output. |
| Manual interaction | Connected browser host was unavailable and native desktop preview approval timed out. Direct live UI clicking was not completed. Workflow correctness was checked in the pure domain tests; screenshot fixtures exercise page rendering at each state. |
| Dart/Flutter backend | Existing framework, authentication, ticker, proof simulation, config and tests inspected. Flutter/Dart executables were not available on PATH, so the historical 25-test claim was not rerun or re-certified. No Dart source behavior was changed. |
| Google Cloud integration | Not provisioned/tested. Auth, Gemini, Storage, Maps, FCM, durable worker and SQL cloud paths are design/backlog items. |
| External effects | No real notification, medical action, organizer submission, cloud billing change or deployment performed. The requested repository commit/push is handled separately. |

Recheck locally:

```powershell
node --check caregrid_web/app.js
node --check caregrid_web/server.mjs
node --check caregrid_web/connected.js
node --test caregrid_web/tests/*.test.mjs
node scripts/check-submission.mjs
```

For a real Google MVP, use the acceptance gates in [IMPLEMENTATION-PLAN.md](IMPLEMENTATION-PLAN.md). Screenshots and seeded timings are evidence of a product prototype, not evidence of deployed AI, secure role isolation or clinical/field performance.
