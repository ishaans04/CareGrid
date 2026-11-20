# Connected CareGrid MVP · product captures

Exported 20 November 2026. Images 01–08 come from browser tests operating the real local Serverpod/PostgreSQL backend. Image 09 is a separate Google-entry configuration preview with mocked public Firebase configuration; it does not demonstrate sign-in. [Open the gallery](index.html). Founders: Hriday Vig and Ishaan Sharma · Team Duality.

Use the command, responder and readiness images as the strongest product trio. Caption every screenshot: **Connected local MVP · synthetic campus data · Google deployment planned.** The screenshots demonstrate software behavior; they do not demonstrate a field pilot, live Gemini, camera inference, GPS, real notifications or clinical outcomes.

| PNG | What it demonstrates |
| --- | --- |
| [01 · Command centre](01-command-centre.png) | A member SOS, actual backend policy/reasoning, route recommendation, operator authority and incident timeline |
| [02 · Mobile responder](02-mobile-responder.png) | An independently signed-in ambulance crew, real task, recorded milestones and the next action; 390px viewport |
| [03 · Care handoff](03-care-handoff.png) | Pre-alerted cases and receiving-team readiness recorded by a medical account |
| [04 · Mobile member](04-mobile-member.png) | The requesting member receives the resolved status from the shared backend; 390px viewport |
| [05 · Readiness lab](05-readiness-lab.png) | Actual deterministic engine results against the seeded campus twin, predicted arrival SLAs and supported remedies |
| [06 · After action](06-after-action.png) | Backend-computed metrics from fictional history and local test activity; these are not measured customer results |
| [07 · Audit trail](07-audit-trail.png) | Actual access/action records for the demo accounts |
| [08 · Disconnected responder](08-mobile-disconnected.png) | Visible network failure with retained last-known context and blocked actions; no synthetic success fallback |
| [09 · Google entry preview](09-google-entry-preview.png) | Bundled SDK and deployed-mode entry layout; mocked public configuration, no OAuth or live Google account |
| [10 · Private attachment preview](10-private-attachments-preview.png) | Command-only image upload/view/removal layout with a synthetic floor plan; storage calls are mocked, while sign-in, case actions and role denial use the real local backend |

Caption image 09: **Google sign-in configuration preview · OAuth verification pending.**

Caption image 10: **Private attachment UI preview · synthetic image · mocked storage responses · live GCS verification pending.**

Reproduce with the full local MVP running against a separate initially empty synthetic database with its own parent directory (see [test setup](../../../caregrid_web/README.md)):

```powershell
cd caregrid_web
npm.cmd ci
npm.cmd run build
$env:CAREGRID_CAPTURE = '1'
npm.cmd run test:browser
```

Chrome uses temporary isolated contexts. Captures wait for synchronized state, load local fonts, return scroll to the top before full-page export, and hide only the transient notification toast. The campus graph is schematic. Test scripts create real synthetic database records, so incident codes, timestamps, recent cases and aggregate metrics change across runs. All screens were visually reviewed; [validation and limits](../../../docs/buildathon/VALIDATION.md).
