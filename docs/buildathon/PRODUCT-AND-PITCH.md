# Founder and pitch notes

## Product sentence

**CareGrid turns campus emergency signals into a coordinated, verified human response, from first observation to recorded care.**

Start with residential campuses that already employ security staff and have an ambulance/medical partner. The painful gap is handoff across existing resources: who owns the case, who is actually going, and did anyone arrive? Proof-of-Response and the failure rehearsal engine make this more than a detector dashboard.

## Buyer and market thesis

Economic buyer hypothesis: campus administration/security leadership, co-approved by medical operations and IT. Users: command operator, medical team, ambulance/security responder, administrator and campus member. A sale requires workflow integration, staffing commitments, privacy review, training and institutional procurement; a beautiful interface alone is not adoption.

Initial offer hypothesis: a paid, supervised pilot across one or two hostels with existing assets. Price implementation separately from recurring software/support. The old deck's ₹6 lakh annual price, 200-campus SOM, ₹12 crore ARR and institutional counts are planning assumptions, not validated demand. Do not present digital health market size as the addressable market for campus emergency software.

Build the market bottom up: named institutions meeting residential population, medical coverage, available response staff, camera/SOS access, procurement readiness and budget criteria. Estimate annual contract value from buyer interviews and actual integration/support cost. Model gross margin including local gateways, model calls, evidence bandwidth, onboarding, training, support and any staffed monitoring. An optional 24×7 managed service materially changes operating cost and liability; keep it separate from SaaS.

Validation interviews should establish the current handoff process, recent anonymized failure modes, overnight staffing, lost/stalled calls, existing spend, buyer authority, security/privacy concerns and a specific pilot-success criterion. No interviews, LOIs, partnerships, revenue, customer logos or pilot results were supplied here. IITG is prior reference research, not a claimed customer.

## What makes the Google AI use meaningful

Show an incident where the model identifies contradictory/missing evidence and cites the approved SOP, then show the deterministic planner refusing an unavailable unit and Proof-of-Response noticing missing acknowledgement. That demonstrates AI understanding plus accountable workflow. A Gemini logo or chatbot screenshot alone is insufficient technical evidence.

## Architecture slide copy

**Signals → understanding → coordinated response → proof.**

- Google AI Edge/LiteRT: local candidate signals and outage buffer (pilot).
- Gemini on Google Cloud: grounded, structured evidence brief.
- Cloud Run + Cloud SQL: approved policy, campus routing and transactional incident lifecycle.
- Firebase: identity and responder notifications; explicit human ACK.
- Cloud Storage: private incident evidence and approved SOPs.
- Durable deadline worker + local fallback: missed-response escalation.
- BigQuery/Looker: de-identified after-action learning (expansion).

Foundation band: IAM · Secret Manager · Cloud Build/Artifact Registry · Logging/Monitoring. Label diagram “proposed Google Cloud architecture”. Do not put every evaluated service on the main slide.

## Screenshot sequence and honest captions

| Visual | What the viewer should understand | Suggested caption |
| --- | --- | --- |
| Command overview | Prioritized owned cases, campus context, next action and live coverage gaps | “Interactive prototype · fictional campus and synthetic incidents” |
| Incident detail | Corroborating evidence, approved-policy rationale, response route and per-unit proof | “Evidence → operator confirmation → verified response; media illustrated” |
| Responder | One clear next action and minimum case context | “Responder workflow prototype; location and arrival simulated/manual” |
| Care console | Medical team receives case/handoff without camera evidence | “Role-specific care view; demo controls illustrate intended authorization” |
| Readiness lab | Busy ambulance + closed gate + degraded camera can be rehearsed | “Illustrative what-if rehearsal; predictions are model assumptions” |
| Architecture | Google services power a coherent loop | “Proposed deployment; Google Cloud resources not yet provisioned” |

The local prototype role switch demonstrates product behavior; it is not a production security boundary. Security evidence requires backend authorization tests.

## Ninety-second demonstration

1. Command overview: “At 02:17, two independent observations create one urgent case.” Open CG-0217.
2. Evidence panel: “Here is what was observed, the night-hostel SOP, and what is still unknown.” Point to the synthetic-media label and AI integration status.
3. Dispatch: choose available desk + ambulance; confirm. “Notification is only the beginning.”
4. Responder view: acknowledge, start moving, record arrival and care using explicit demo controls. Show the proof chain updating and closure being blocked until care is recorded.
5. Reset, inject missed acknowledgement: “If a unit does not accept, CareGrid escalates; it never calls silence a success.”
6. Readiness: run the compound failure, compare the gate-route intervention and predicted SLA. “We can rehearse a bad night before a real one.”
7. Close on architecture: “Google AI helps interpret; the operational system coordinates and verifies human action.”

## Claims to avoid

No diagnosis, “lives saved”, guaranteed emergency response, certified campus safety, legal compliance badge, production uptime, signed IITG pilot, universal detector accuracy, hard-real-time Cloud Tasks guarantee, fabricated traction, real Google Maps/Gemini calls in the local prototype, or measured improvement inferred from seeded demo timings.

## Pilot success criteria

Agree with the institution on baseline/drill protocol and acceptable false escalation burden. Measure MTTC distributions, per-stage latency, missing acknowledgements discovered, verified-care completion, operator workload, coverage gaps and restore/outage behavior. Include incomplete cases and uncertainty. Expansion to district hubs/rural PHCs follows a successful campus proof and authorized clinical/operational partnerships; no eSanjeevani/ABDM integration is claimed.
