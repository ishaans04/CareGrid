# Source document review

Review date: 12 November 2026. Scope: every Markdown/document file and all three PDFs discovered in the checkout, both Claude Design HTML exports, and supporting implementation/configuration relevant to architecture. Generated client code is a protocol artifact, not an additional idea document.

## Complete document inventory

| Original | Coverage and reading method | Findings carried forward |
| --- | --- | --- |
| `README.md` | Entire 362-line original | Existing working-prototype description; seven-stage loop; 02:17 example; 26 zones, 34 roads, 19 cameras, 11 units; five roles; simulation and readiness. Original deployment is Serverpod Cloud, team is Falcons, and metrics are seeded/simulated. |
| `docs/COMPONENTS.md` | Entire 491-line original | All screens, widgets, endpoints, services, tables, DTOs, enums, fusion/routing rules, privacy views, scenarios and limitations. Explicitly says no vision model runs. |
| `12112026/uploads/CareGrid_Final_IITG_WhyCode4U_Concept.pdf` | All 25 pages: full text extraction plus rendered visual review of every page | Original founder/product dossier. Valuable operational model and governance boundaries; previous-event submission constraints and IITG-specific assumptions must be separated from this event. |
| `12112026/uploads/CareGrid ppt.pdf` | All 8 pages rendered and read visually; the PDF is image-based and text extraction alone returned almost nothing | Dark navy/cyan presentation. Explicit Proof-of-Response and Stress-Test Engine distinction. Contains older Next.js/React/MapLibre, FastAPI, Redis and YOLO suggestions, plus Falcons branding. |
| `12112026/misc/CareGrid_Chokers Final .pdf` | All 7 pages: extracted text and visual reading, including image-only architecture on page 4 and graphics on pages 3/5/6 | Previous three-person team and a separate design system. Market figures and ₹6 lakh pricing are assumptions to revalidate. Broad roadmap is useful, but not proof of customers or implementation. |
| `12112026/CareGrid.dc.html` | Complete visible copy and dynamic content/data arrays; source structure, typography, themes and interaction design reviewed | Single scrolling story with night corridor, urgency, contextual policy, privacy-role switch, product surfaces and roadmap. Simplified copy sometimes overstates legal compliance and automatic dismissal. |
| `12112026/CareGrid v2.dc.html` | Complete visible copy and dynamic content/data arrays; eight-tab structure, canvas scene, typography, theme tokens and interaction design reviewed | Preferred current visual reference: ink #0A0C14, warm paper #ECE9E1, acid lime #C6FF3D, cyan #3DDCFF, Archivo, Instrument Serif and Martian Mono. Eight rotating chapters tell one incident story. |
| `caregrid_flutter/ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md` | Entire file | Platform starter instructions; no product requirements. |
| `caregrid_server/web/templates/built_with_serverpod.html` | Entire file | Default Serverpod starter page, not the CareGrid landing page. |
| `caregrid_server/web/pages/build_flutter_app.html` | Entire file | Build fallback and original Serverpod Cloud instructions. |
| `caregrid_flutter/web/index.html` | Entire file | Starter metadata/title and Flutter bootstrap; needs product metadata when publishing the Flutter app. |
| `caregrid_server/migrations/migration_registry.txt` | Entire file | One migration, `20261018074019666`; generated metadata. |
| `12112026/support.js`, `.thumbnail` | Supporting files identified; generated runtime header reviewed | Design export runtime and preview thumbnail; not additional research documents. |

## Dossier page-by-page reading notes

| Page | Material | Submission decision |
| --- | --- | --- |
| 1 | WhyCode_4U cover, 5 October deadline, eight-slide limit | Historical; do not reuse those rules |
| 2 | Executive decision; owned incident and no-queue model | Keep thesis, rewrite for current Google event |
| 3 | Seven handoffs and Verdun inspiration | Describe the coordination problem; no unsupported competitive performance claims |
| 4 | IITG reference environment and published response processes | Reference environment, not a signed pilot or partner |
| 5 | Five layers, five product surfaces, MTTC | Preserve; map each responsibility to Google services |
| 6 | Incident object and contextual graph | Preserve policy, resource, evidence and next-action fields |
| 7 | Seven event families and negative evidence | MVP: one medical scenario; other families are roadmap |
| 8 | 02:17 scenario | Use fictional Meridian/Birch campus consistently with code |
| 9 | Eleven failure cases and safety rule | Convert to concrete failure handling and acceptance criteria |
| 10 | Mobility and lifecycle | Keep campus road/gate graph; Maps is a geographic layer, not indoor ground truth |
| 11 | Digital twin, asset state, permissions | Preserve typed relational graph; graph database is unnecessary initially |
| 12 | Privacy, DPDP and telemedicine | Design inputs, not legal certification; independent review needed before pilot |
| 13 | Rural hub-and-spoke expansion | Future option, not a current integration with eSanjeevani |
| 14 | Institutional owners and managed service | Map buyer, approvers and operational owner |
| 15 | SaaS, implementation, premium modules, moat | Hypotheses to validate; incident history only helps with authorized use |
| 16 | One complete vertical slice | Retain disciplined MVP scope |
| 17 | 24-hour plan and suggested stack | Historical suggestion; existing Dart domain logic has more reuse value |
| 18 | Stage metrics and honest claims | Keep; add denominators, distributions and clock quality |
| 19 | Competitive positioning | Differentiate on verified coordination; do not say nobody else can do it |
| 20 | Judge objections | Update with actual Google integrations and live-vs-demo status |
| 21 | Eight-slide blueprint | Historical event limit; current official template governs |
| 22 | Spoken narrative | Reuse structure without implying deployment at IITG |
| 23 | 24-month roadmap | Sequence by evidence and operational readiness |
| 24 | Claim boundaries | Treat source claims as dated research, not automatically current |
| 25 | Ten source references | Research leads; verify any figure repeated in the new deck |

## Eight-slide image deck coverage

1. CareGrid title, AI response OS, Falcons and founder names.
2. Event → notice → localize → decide → dispatch → reach → care; six handoffs.
3. Sense/understand/decide/act/verify/close/learn and feedback loop.
4. Proof-of-Response after dispatch; compound-failure stress test before an emergency.
5. Five-layer older technical stack and privacy principles.
6. Campus users, IITG scale and rural extension.
7. MTTC and RCI with explicitly illustrative scenario timings.
8. 24-hour build sequence and 24-month rollout.

## Seven-slide Chokers coverage

1. Hriday Vig, Ishaan Sharma, Jaskaran Vaid and historic roles.
2. Problem, impact and healthcare theme.
3. Solution and feature illustration.
4. Image-only five-layer architecture and API/integration panel.
5. Market counts, assumed price, arithmetic and geographic illustration.
6. Roadmap and future modules.
7. Thank-you page.

## Conflicts resolved for Team Duality

| Conflict | Current decision |
| --- | --- |
| Falcons / Chokers / three members | New submission: **Team Duality, Hriday Vig + Ishaan Sharma**. Preserve old artifacts. |
| WhyCode_4U healthcare requirement | Current event is open innovation; healthcare coordination is our chosen problem, not a verified event-wide theme. |
| Claimed IITG pilot | IITG was reference research; no partnership or deployment is established here. Demo campus is fictional. |
| Serverpod Cloud vs Google | Retain Serverpod framework; migrate managed runtime/data/AI to Google Cloud. Framework/library provenance is separate from cloud hosting. |
| React/FastAPI/YOLO vs Flutter/Dart | Prior docs were options. Existing implementation is Flutter/Dart. New web presentation prototype is an additive frontend, not an unreported backend rewrite. |
| Model confidence as certainty | Detector score is not calibrated probability. Show evidence and uncertainty; validate thresholds on site data. |
| Arrival from elapsed time | Existing `_advance` simulates arrival even without autopilot. Production must gate this to simulation and require authenticated telemetry or accountable manual arrival. |
| Incident state is furthest dispatch | Show each required unit independently; a security desk arriving must not imply the ambulance arrived or the whole response is complete. |
| “Someone left, so dismiss” | Negative evidence is fallible. Never automatically cancel an already dispatched response solely on AI output. |
| “We comply from day one” | Replace with designed controls and a pilot review requirement. Architecture alone does not establish legal compliance. |
| Market numbers and digital-health CAGR | Do not reuse as verified current market size. Build a qualified-campus list and bottom-up pricing hypotheses. |
| Readiness 50% → 100% | Four seeded rehearsals only; not campus safety certification or measured improvement. |

## Implementation spot checks behind the review

Reviewed server boot, authentication, production config, Dockerfile, deploy workflow, ticker, Proof-of-Response, orchestrator, and routing/readiness tests. Notable gaps: public demo PIN hints, no tenant boundary, local in-memory scenario/ticker state, placeholder production hosts, multiple server ports, simulated telemetry, no production Google AI call and no durable dispatch outbox. These are implementation work, not boxes that can be solved by renaming a diagram.
