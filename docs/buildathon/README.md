# CareGrid · Team Duality · Startup Buildathon India 2026

Prepared 12 November 2026 (Asia/Kolkata). Founders: Hriday Vig and Ishaan Sharma.

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
| [Visual assets](../../assets/pitch/README.md) | Architecture exports and product captures for the deck |
| [Interactive submission prototype](../../caregrid_web/README.md) | Locally runnable console matching the Claude Design visual direction |

## Status and claim boundary

- **Existing implementation:** Flutter/Serverpod/Dart prototype, PostgreSQL models, deterministic fusion/policies, campus routing, simulation, response watchdog, rehearsal engine and role views. Historical test results in the original README have not been independently rerun in this session.
- **Submission experience:** a separate interactive web prototype for screenshots and product demonstration. It uses fictional, browser-local data and explicit simulated workflow controls. It does not call Gemini, Google Maps, Firebase or the existing Dart server.
- **Proposed deployment:** Google Cloud Run + Cloud SQL for PostgreSQL, Gemini through Google's enterprise AI platform, Firebase identity/notifications, Google Cloud Storage and operational controls. No project or billable resources have been created.
- **Pilot gates:** real telemetry, robust authentication, durable deadlines, transactional dispatch, trained operators, model evaluation and approved institutional SOPs are required before operational use.

The original PDFs and Claude Design exports remain historical references. Their event names, team names, market numbers, legal statements and suggested technology choices are not current submission claims.
