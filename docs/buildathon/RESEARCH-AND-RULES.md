# Buildathon rules and research record

Checked 12 November 2026, India time. Public sources only; no registration, form submission, account access or organizer contact was performed.

## Event findings

The [official Startup Buildathon site](https://startupbuildathon.com/) describes an AI startup program, Google AI use, Google Cloud deployment, and evaluation of founders, product potential, market viability, architecture and depth of Google use. Its application deadline is **13 November 2026**. City builds are 20–21 November; regional showcases are 23/25/27 November; finale is 2 December. These are different from the older WhyCode_4U rules in this repository.

The home page's **Apply Now** is a script-controlled button. Crawling its [own public script](https://startupbuildathon.com/js/app.js) resolves it to [the Hack2skill registration portal](https://hack2skill.com/event/startupbuildathon2026/registration?isExternalLinkRedirection=true). The public application bundle exposes the [event-details endpoint](https://hack2skill.com/api/v1/event/startupbuildathon2026/event-details). Its submission notice requires **both** the prescribed PPT upload and the Startup/Project Details form. The event is listed as open innovation.

Portal configuration contains `registrationEnd=2026-11-13T18:29:00Z` (13 November 23:59 IST), and `submissionEnd=2026-11-15T18:29:00Z` (15 November 23:59 IST). This is an observed configuration discrepancy, not permission to submit late. **Plan to finish by the public 13 November deadline and use the authenticated dashboard's current requirements when actually submitting.**

The footer links [a terms page using the slug `buildathon`](https://hack2skill.com/event/buildathon/tnc). That path serves the app shell but its public event endpoint returns invalid parameters. The [correct event's terms endpoint](https://hack2skill.com/api/v1/event/startupbuildathon2026/event-tnc) returns only event title/client/type; the event-details response has an empty, hidden terms array. No full rules were exposed there. The portal metadata also has a team-size maximum of 30 while its FAQ says no limit; this does not affect a two-person team.

### Verified versus unverified

| Item | Finding / action |
| --- | --- |
| AI-powered solution + Google AI + Google Cloud | Publicly supported; make Gemini do a substantive, testable task and use Google-managed cloud services |
| “Every component must be Google” | Detailed exclusivity wording not located in the public crawl; honor the user's stricter architecture constraint |
| Existing project/code eligibility | Not established by the accessible pages; disclose inherited prototype and new work; obtain organizer clarification before representing all code as event-created |
| Deck format and project-details form | Both required in public portal notice; user owns template assembly/submission |
| Eight-slide maximum from old PDF | Belongs to a different event; not verified for this one |
| Google credit availability | Not assumed; no billing/project exists yet |
| Use of Claude Design/Codex as creation tools | Disclose if organizer rules require it; not a runtime dependency in the proposed Google stack |

## Architecture research that changes the design

| Finding | Design consequence | Official source |
| --- | --- | --- |
| Cloud Run WebSockets remain bounded requests; affinity is best effort | Reconnect with revision cursor and refetch durable state; no per-instance incident truth | [WebSockets](https://docs.cloud.google.com/run/docs/triggering/websockets) |
| Request-based billing allocates CPU during requests; instances can be terminated | Do not deploy a one-second in-memory ticker as a durable scheduler | [Billing/CPU](https://docs.cloud.google.com/run/docs/configuring/billing-settings) |
| Cloud Tasks can duplicate work and occasionally delay execution by minutes | Use for retryable notifications and backup checks, not the sole 30-second life-safety clock | [Tasks limitations](https://docs.cloud.google.com/tasks/docs/common-pitfalls) |
| Pub/Sub push is not exactly once; exactly once has pull/regional qualifications | Unique event keys, SQL constraints, transactional outbox and idempotent consumers | [Delivery semantics](https://docs.cloud.google.com/pubsub/docs/exactly-once-delivery) |
| Structured output has a supported schema subset | Validate evidence references, SOP versions and action bounds in application code | [Structured output](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/capabilities/control-generated-output) |
| Enterprise model data training restrictions do not equal universal zero retention | Review logging, caching, grounding and conversation-storage settings separately | [Data governance](https://docs.cloud.google.com/gemini-enterprise-agent-platform/resources/zero-data-retention) |
| Endpoint choice alone does not prove residency | Verify exact model/features/processing guarantees before making India-residency claims | [Locations](https://docs.cloud.google.com/gemini-enterprise-agent-platform/resources/locations) |
| Firebase ID tokens require server-side verification | Check issuer, audience, signature, expiry/revocation policy and campus membership; UI role switches are not authorization | [Verify tokens](https://firebase.google.com/docs/auth/admin/verify-id-tokens) |
| FCM delivery depends on client/device/network behavior and ordering is not guaranteed | Persist dispatch, require explicit acceptance and version messages; notify radio/phone operator on missed acceptance | [Delivery](https://firebase.google.com/docs/cloud-messaging/understand-delivery), [ordering](https://firebase.google.com/docs/cloud-messaging/customize-messages/collapsible-message-types) |
| Maps route avoidance can be advisory; campus access conditions remain local | Overlay institution-approved graph, blocked roads, gates and floors; no guaranteed emergency priority routing | [Route modifiers](https://developers.google.com/maps/documentation/routes/route-modifiers) |
| Maps has SKU thresholds and India eligibility rules | Estimate map loads, route calls and Places separately; do not reuse the old flat $200 credit assumption | [India pricing](https://developers.google.com/maps/billing-and-pricing/india) |
| Alert-only budgets do not cap spend; eligible per-service spend caps now exist | Use alerts, quotas and max instances; distinguish caps from alerts and account for fixed costs/overages | [Budgets](https://docs.cloud.google.com/billing/docs/how-to/budgets), [spend caps](https://docs.cloud.google.com/billing/docs/how-to/budgets-spend-caps) |
| LiteRT is Google's cross-platform edge inference runtime | Future local detection can use a Google runtime; a model still needs training, licensing and validation | [LiteRT](https://developers.google.com/edge/litert) |

Current Google documentation redirects several former Vertex AI generative AI pages to **Gemini Enterprise Agent Platform**. The deck may say “Gemini on Google Cloud (Vertex AI / Gemini Enterprise Agent Platform)” for continuity. API/model identifiers and supported regions must be pinned and tested when a project exists; a marketing model name is not a deployment configuration.

## Privacy and evidence sources

The [MeitY DPDP Rules page](https://www.meity.gov.in/documents/act-and-policies/digital-personal-data-protection-rules-2025-gDOxUjMtQWa?pageTitle=Digital-Personal-Data-Protection-Rules-2025) provides the notified rules, corrigendum and enforcement timeline. The older concept dossier's legal interpretation is not adopted as a current legal opinion. Campus purpose/authority, notices, children, medical information, rights handling, processors, retention, breach response and transfers need institution-specific review. No claim of DPDP/HIPAA/medical-device compliance is made here.

Public IITG sources in the old dossier support a reference environment, not endorsement or an executed pilot. The proposed product avoids repeating population, campus-size or market-growth figures as newly verified facts. Business assumptions are labeled in [Product and pitch notes](PRODUCT-AND-PITCH.md).

## Research limits

Public event pages, registration routing, public event configuration and relevant Google technical documentation were inspected. Full authenticated submission fields and organizer-only rules were not available. A service catalogue is an assessment of relevant options, not a claim that every listed service is built or that every Google product belongs in CareGrid.
