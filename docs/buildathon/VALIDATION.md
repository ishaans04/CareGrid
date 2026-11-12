# Validation record

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
node --test caregrid_web/tests/domain.test.mjs
node scripts/check-submission.mjs
```

For a real Google MVP, use the acceptance gates in [IMPLEMENTATION-PLAN.md](IMPLEMENTATION-PLAN.md). Screenshots and seeded timings are evidence of a product prototype, not evidence of deployed AI, secure role isolation or clinical/field performance.
