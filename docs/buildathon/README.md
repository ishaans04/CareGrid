# CareGrid · Team Duality · Startup Buildathon India 2026

Prepared 12 November 2026 (Asia/Kolkata). Founders: Hriday Vig and Ishaan Sharma.

**Updated 20 November:** [the connected MVP](CONNECTED-MVP.md) now joins the polished web workspace to Serverpod/PostgreSQL. The original presentation and research package remain available separately.

**CareGrid connects an emergency signal to a verified human response.** Its strongest differentiators are Proof-of-Response after dispatch and failure rehearsals before an emergency. The first buyer is a residential campus with an existing security team, hospital/medical partner, and response vehicles.

## Start here

**Demo preparation, 20 November:** [current operations](DEMO-OPERATIONS.md) records the two successful Google role bindings, team alert routing, corrected Terraform settings and observed credit balance. The [repository README](../../README.md) is the current product entry point; older dated research remains source material.

| Deliverable | Purpose |
| --- | --- |
| [Solution architecture](SOLUTION-ARCHITECTURE.md) | Submission narrative, Google architecture, data flow, AI boundaries, resilience, migration and delivery plan |
| [Google component catalogue](GOOGLE-COMPONENTS.md) | Broad service assessment: required, pilot, expansion and deliberately deferred components |
| [Research and rules](RESEARCH-AND-RULES.md) | Verified public event requirements, crawl results, source links and unresolved rules |
| [Document review](DOCUMENT-REVIEW.md) | Every original document and PDF reviewed, page coverage, conflicts and claims to correct |
| [Product and pitch notes](PRODUCT-AND-PITCH.md) | Founder positioning, buyer, validation, business model, screenshot captions and demo script |
| [Implementation plan](IMPLEMENTATION-PLAN.md) | Exact changes required to connect the current prototype to Google Cloud |
| [Google runtime](GOOGLE-RUNTIME.md) | Separate API/watchdog images, private maintenance jobs and verified deployment boundaries |
| [Google identity](GOOGLE-IDENTITY.md) | Firebase token validation, SQL membership, stateless gateway and operator setup |
| [Gemini handoff drafts](GOOGLE-GEMINI.md) | Bounded optional inference adapter, command-only UI, validation and live-evaluation gates |
| [Private evidence broker](GOOGLE-EVIDENCE.md) | Command-only image attachments, GCS generation/digest checks, optional bucket permissions and live acceptance gates |
| [Google infrastructure](../../infra/google/README.md) | Validated Terraform, phased deployment, build pipeline and recovery runbook; applied to `caregrid-staging` through the services stage |
| [Google provisioning record](GOOGLE-PROVISIONING.md) | Live account/project, billing, Firebase, private state, local tools, planned hosting and ordered continuation for deployment agents |
| [Demo operations](DEMO-OPERATIONS.md) | Team Google access, reusable binding helper, current Terraform inputs, team alerts and credit expiry |
| [Connected MVP](CONNECTED-MVP.md) | Working local architecture, response fixes, role boundaries and launch instructions |
| [Visual assets](../../assets/pitch/README.md) | Architecture exports and product captures for the deck |
| [Interactive submission prototype](../../caregrid_web/README.md) | Locally runnable console matching the Claude Design visual direction |

## Status and claim boundary

- **Existing implementation:** Flutter/Serverpod/Dart, PostgreSQL models, deterministic fusion/policies, campus routing, simulation, response watchdog, rehearsal and role views. The latest refresh passed **107 backend tests, 34 Node checks and six Chrome tests**. PostgreSQL checks use a real embedded database; identity/model/storage fixtures retain their stated boundaries. GitHub Actions verifies Flutter analysis/formatting/tests separately.
- **Submission experience:** the finalized blue/butter web UI calls the Dart backend through the authenticated gateway. The separate `/demo` and `/index.html` presentation retains fictional browser-local fixtures. Local mode does not call Gemini, Maps or Firebase by default. The optional Gemini and evidence adapters are implemented but remain disabled in live configuration. [Validation and limits](VALIDATION.md), [current product gallery](../../assets/pitch/launch/README.md).
- **Google setup:** the billed `caregrid-staging` MVP is deployed: Cloud SQL, migrated schema, seeded synthetic campuses, private API/watchdog and public web entry at <https://caregrid-demo-web-959096744456.asia-south1.run.app>. Both existing Firebase identities were bound to the requested NIET roles. Infrastructure/budget alerts route to both teammates, and synthetic-alert delivery was confirmed in both inboxes. Browser acceptance after binding and live two-person denial/recovery checks remain gates. [Current operations](DEMO-OPERATIONS.md), [provisioning evidence](GOOGLE-PROVISIONING.md). The wider catalogue remains the pilot/expansion design.
- **Pilot gates:** real telemetry, live identity validation, transactional deadline processing and dispatch, trained operators, model evaluation and approved institutional SOPs are required before operational use.

The original PDFs and Claude Design exports remain historical references. Their event names, team names, market numbers, legal statements and suggested technology choices are not current submission claims.
