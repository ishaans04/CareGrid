# Validation record

## Connected MVP verification · 20 November 2026

The local backend and connected web workspace are now implemented and exercised. The 12 November record below is preserved as the historical submission-package check.

| Area | Current result |
| --- | --- |
| Backend tests | **29 passed**: 13 unit tests and 16 integration tests against real embedded PostgreSQL, using Dart 3.12.2 / Serverpod 4.0.4. |
| Response correctness | Regression checks prove elapsed time cannot create arrival outside an explicit scenario; overdue travel escalates once; authenticated check-in works; scenario arrivals are labelled; closure cannot manufacture a care milestone. |
| Backend access boundaries | Role/assignment tests, unshared-case id guessing by medical accounts, evidence redaction and admin exact-location redaction passed. This does not establish tenant isolation or production security certification. |
| Static analysis | `dart analyze` on the complete isolated server workspace: **No issues found**. Flutter application analysis was not rerun. |
| Node checks | **10 passed**: three original presentation-domain checks and seven gateway tests covering session secrecy/expiry/logout, origin/host protections, method allowlist, bounded JSON, typed errors, rate limiting, backend failure and static source restrictions. |
| Browser interaction | **Three isolated Chrome tests passed** against the real local API: member SOS → command ownership/dispatch → responder ACK/departure/arrival/care → medical readiness → human closure; readiness/analytics/audit; visible connection loss. Unauthorized API calls are tested from authenticated browser sessions. |
| Mobile | Browser viewports at **390 × 844 CSS pixels** tested for member/responder overflow. Form drafts survive polling. Responder actions remain in a mobile action tray. This is browser emulation, not a physical-device field trial. |
| Assets | Eight connected product captures exported by the same browser workflow, with local fonts and synthetic-data labels. Gallery and provenance in [connected assets](../../assets/pitch/connected/README.md). Original presentation captures remain separate. |
| Launch | Windows portable SDK SHA-256 checked; server-only workspace and real PostgreSQL start successfully; Node gateway waits for backend seeding. No Flutter or Google credentials needed for the local workflow. |
| Cloud / external effects | No Google resources provisioned, real notifications sent, event submission made or cloud billing changed. Google identity/AI/Storage/FCM/Maps and durable-worker behavior remain untested target integrations. |

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
