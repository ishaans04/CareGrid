# CareGrid · Team Duality · Startup Buildathon India 2026

Prepared 12 November 2026 (Asia/Kolkata). Founders: Hriday Vig and Ishaan Sharma.

**Updated 20 November:** [the connected MVP](CONNECTED-MVP.md) now joins the polished web workspace to Serverpod/PostgreSQL. The original presentation and research package remain available separately.

**CareGrid connects an emergency signal to a verified human response.** Its strongest differentiators are Proof-of-Response after dispatch and failure rehearsals before an emergency. The first buyer is a residential campus with an existing security team, hospital/medical partner, and response vehicles.

## Start here

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
| [Google infrastructure](../../infra/google/README.md) | Validated Terraform, phased deployment, build pipeline and recovery runbook; not applied |
| [Connected MVP](CONNECTED-MVP.md) | Working local architecture, response fixes, role boundaries and launch instructions |
| [Visual assets](../../assets/pitch/README.md) | Architecture exports and product captures for the deck |
| [Interactive submission prototype](../../caregrid_web/README.md) | Locally runnable console matching the Claude Design visual direction |

## Status and claim boundary

- **Existing implementation:** Flutter/Serverpod/Dart prototype, PostgreSQL models, deterministic fusion/policies, campus routing, simulation, response watchdog, rehearsal engine and role views. 49 backend checks cover the current implementation against real embedded PostgreSQL and RSA fixtures; Dart static analysis reports no issues. GitHub Actions verifies Flutter analysis/formatting/tests separately.
- **Submission experience:** the default web workspace now calls the Dart backend through a local authenticated gateway. The original `/index.html` presentation retains its fictional browser-local fixtures. The local demo does not call Gemini, Maps or Firebase. Cloud-mode Firebase identity code and its configuration preview are implemented; live OAuth remains unverified. [Validation and limits](VALIDATION.md).
- **Proposed deployment:** Google Cloud Run + Cloud SQL for PostgreSQL, Gemini through Google's enterprise AI platform, Firebase identity/notifications, Google Cloud Storage and operational controls. No project or billable resources have been created.
- **Pilot gates:** real telemetry, live identity validation, transactional deadline processing and dispatch, trained operators, model evaluation and approved institutional SOPs are required before operational use.

The original PDFs and Claude Design exports remain historical references. Their event names, team names, market numbers, legal statements and suggested technology choices are not current submission claims.
