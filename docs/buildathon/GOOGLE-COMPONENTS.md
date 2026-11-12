# Google component assessment

Decision date: 12 November 2026. **C = cloud vertical slice, P = campus pilot, E = expansion, D = defer/not a fit, T = development tool.** Local screenshot prototype has no live Google dependencies. These are evaluated options, not a bill of deployed services. A service earns a place by removing a defined delay, reliability gap, privacy risk or operating burden.

## AI and edge

| Component | Stage | CareGrid responsibility / decision | Official reference |
| --- | --- | --- | --- |
| Gemini on Google Cloud / Gemini Enterprise Agent Platform (former Vertex AI generative AI) | C | Grounded structured evidence brief; current model/version/location selected at deployment | [Structured output](https://docs.cloud.google.com/gemini-enterprise-agent-platform/models/capabilities/control-generated-output) |
| Google Gen AI SDK | C | Small supported-language AI adapter; workload credentials; not a browser API key | [SDK](https://googleapis.github.io/python-genai/) |
| Gemini multimodal / Omni options | P | Selected masked image/clip/audio interpretation after evaluation; no continuous medical surveillance claim | [Model documentation](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/multimodal/overview) |
| Gemini Live API | E | Optional hands-free responder intake; interruption, latency, privacy and device testing needed | [Live API](https://ai.google.dev/gemini-api/docs/live) |
| Google ADK | P | Bounded read-only evidence/SOP tools, evaluation and tool authorization | [ADK](https://google.github.io/adk-docs/) |
| Managed agent runtime / Agent Engine | E | Consider if managed sessions/tools/agent execution justify another runtime; not necessary for one brief | [Agent runtime](https://cloud.google.com/vertex-ai/generative-ai/docs/agent-engine/overview) |
| Grounding / RAG Engine | E | Approved corpus discovery; structured approved SOP remains authority | [RAG](https://cloud.google.com/vertex-ai/generative-ai/docs/rag-engine/rag-overview) |
| Google text embeddings + SQL vector extension | E | Search approved after-action/SOP corpus with access filters; exact lookup first | [Embeddings](https://cloud.google.com/vertex-ai/generative-ai/docs/embeddings/get-text-embeddings) |
| Vector Search / enterprise search | D/E | Defer until corpus/latency warrants dedicated retrieval; not required for eleven SOPs | [Vector Search](https://cloud.google.com/vertex-ai/docs/vector-search/overview) |
| Model evaluation / model registry / pipelines | P/E | Version datasets, evaluate evidence grounding, deploy reviewed model changes | [Evaluation](https://cloud.google.com/vertex-ai/generative-ai/docs/models/evaluation-overview) |
| Model Armor | P | Assess prompt/content screening; still enforce authorization and domain constraints | [Model Armor](https://docs.cloud.google.com/model-armor/overview) |
| Google AI Edge / LiteRT | P | On-site inference runtime, quantization and hardware benchmarking | [LiteRT](https://developers.google.com/edge/litert) |
| MediaPipe | P | Pose/tracking experiments and temporal signals; pose landmarks do not establish a medical emergency | [MediaPipe](https://developers.google.com/mediapipe) |
| Gemma + LiteRT-LM | E | Optional offline language brief on sufficiently capable gateway; evaluate memory, license and quality | [Gemma](https://ai.google.dev/gemma/docs) |
| ML Kit | E | On-device utility functions if a responder use case needs them; not a certified fall detector | [ML Kit](https://developers.google.com/ml-kit) |
| Vision API | D/E | OCR/image utilities if justified; generic labels are not validated person-down detection | [Vision](https://cloud.google.com/vision/docs) |
| Video Intelligence | D/E | Batch media enrichment/investigation; not assumed to be a low-latency emergency detector | [Video Intelligence](https://cloud.google.com/video-intelligence/docs) |
| Document AI | P/E | Parse scanned institutional SOPs with human approval/versioning | [Document AI](https://cloud.google.com/document-ai/docs) |
| Speech-to-Text | E | Accessible voice SOS and dictated handoff notes, with correction UI | [Speech](https://cloud.google.com/speech-to-text/docs) |
| Text-to-Speech | E | Read back task instructions; must not distract crews | [TTS](https://cloud.google.com/text-to-speech/docs) |
| Cloud Translation | E | Multilingual intake/task text; preserve original and test safety-critical wording | [Translation](https://cloud.google.com/translate/docs) |
| Imagen / Nano Banana / Veo | T/D | Optional marketing/training illustrations with clear synthetic labels; never fabricate incident evidence | [Image generation](https://ai.google.dev/gemini-api/docs/image-generation) |
| Lyria / music models | D | No emergency coordination requirement; not in the runtime architecture | [Music](https://ai.google.dev/gemini-api/docs/music-generation) |
| Search/Maps grounding | D | Do not send private incident context to web grounding or substitute web results for approved SOPs | [Data retention](https://docs.cloud.google.com/gemini-enterprise-agent-platform/resources/zero-data-retention) |

## Application, identity and mobile

| Component | Stage | CareGrid responsibility / decision | Official reference |
| --- | --- | --- | --- |
| Flutter + Dart | C/P | Existing cross-platform responder/member app and typed domain/client reuse | [Flutter](https://docs.flutter.dev/) |
| Android / Play distribution | P/E | Supervised mobile pilot; background location and notification permissions explicitly tested | [Android](https://developer.android.com/develop) |
| Firebase Hosting | C | Static web console and public assets; HTTPS/CDN; no private clips | [Hosting](https://firebase.google.com/docs/hosting) |
| Firebase App Hosting | D | Alternative if adopting supported server-rendered framework; unnecessary for buildless console | [App Hosting](https://firebase.google.com/docs/app-hosting) |
| Firebase Authentication | C | Human sign-in; backend token validation and SQL role/campus assignment | [Auth](https://firebase.google.com/docs/auth) |
| Identity Platform | P | Enterprise federation/MFA/tenant capabilities when procurement requires them | [Comparison](https://cloud.google.com/identity-platform/docs/product-comparison) |
| Firebase App Check | P | Additional abuse defense for supported client/backends; not authorization | [App Check](https://firebase.google.com/docs/app-check) |
| Firebase Cloud Messaging | P | Low-content push; dispatch IDs/versions; explicit acknowledgement required | [FCM](https://firebase.google.com/docs/cloud-messaging) |
| Firestore | D/E | Optional redacted read projection/offline UX; avoid duplicate writable incident truth | [Firestore](https://firebase.google.com/docs/firestore) |
| Realtime Database | D | Do not add alongside SQL and Firestore without a specific need | [Realtime DB](https://firebase.google.com/docs/database) |
| Remote Config | P/E | UI experiments/noncritical feature flags; never silently change emergency policy thresholds | [Remote Config](https://firebase.google.com/docs/remote-config) |
| Crashlytics + Performance Monitoring | P | Mobile crashes/network performance with sensitive data exclusions | [Crashlytics](https://firebase.google.com/docs/crashlytics), [Performance](https://firebase.google.com/docs/perf-mon) |
| Analytics / A/B Testing | D/E | Optional consent-aware product analytics; not patient profiling or experimentation on emergency decisions | [Analytics](https://firebase.google.com/docs/analytics) |
| Test Lab + App Distribution | P | Device coverage and controlled responder builds | [Test Lab](https://firebase.google.com/docs/test-lab), [Distribution](https://firebase.google.com/docs/app-distribution) |
| Firebase Emulator Suite | T | Local auth/storage/security-rule testing when those services are implemented | [Emulators](https://firebase.google.com/docs/emulator-suite) |
| Firebase Extensions | D | Evaluate individually for permissions/data paths; no automatic shortcut to secure incident processing | [Extensions](https://firebase.google.com/docs/extensions) |

## Compute, events and state

| Component | Stage | CareGrid responsibility / decision | Official reference |
| --- | --- | --- | --- |
| Cloud Run services | C | Incident API / AI adapter; adapt Serverpod ports and auth/networking | [Cloud Run](https://docs.cloud.google.com/run/docs/overview/what-is-cloud-run) |
| Cloud Run jobs | P | Rehearsal batches, approved evidence processing, migrations and exports | [Jobs](https://cloud.google.com/run/docs/create-jobs) |
| Cloud Run worker pools | P | Candidate continuously supervised deadline/outbox consumer; SQL leases and local fallback still necessary | [Worker pools](https://cloud.google.com/run/docs/overview/what-is-cloud-run) |
| Cloud Run instances | D/E | Evaluate current long-lived instance lifecycle if simpler than a VM; not automatically durable state | [Resource comparison](https://cloud.google.com/run/docs/overview/what-is-cloud-run) |
| Cloud Run functions | D/E | Small object/event handlers if needed; avoid spreading core state machine across functions | [Functions](https://cloud.google.com/functions/docs) |
| Compute Engine | P | Alternative supervised deadline/local-integration worker when continuous process control is required | [Compute](https://cloud.google.com/compute/docs) |
| GKE / GKE Autopilot | D | Defer Kubernetes for two-person MVP; revisit for genuine fleet/GPU/control requirements | [GKE](https://cloud.google.com/kubernetes-engine/docs) |
| Cloud SQL for PostgreSQL | C | Primary durable relational incident/twin/dispatch store; transactions and existing migrations | [Cloud SQL](https://cloud.google.com/sql/docs/postgres) |
| Cloud Storage | C | Private selected evidence, approved SOP originals and controlled exports; separate public assets | [Storage](https://cloud.google.com/storage/docs) |
| Pub/Sub | P/E | Normalized event fan-out, integration consumers, analytics; idempotent processing | [Pub/Sub](https://cloud.google.com/pubsub/docs) |
| Cloud Tasks | P | Explicit retryable HTTP tasks and backup checks; not sole urgent deadline clock | [Tasks limits](https://docs.cloud.google.com/tasks/docs/common-pitfalls) |
| Cloud Scheduler | P | Periodic reconciliation/retention reports; not one-second watchdog | [Scheduler](https://cloud.google.com/scheduler/docs) |
| Eventarc | E | Storage/event integration routing when needed; avoid duplicating Pub/Sub routing | [Eventarc](https://cloud.google.com/eventarc/docs) |
| Workflows | E | Administrative approval/export/integration orchestration; domain lifecycle stays transactional | [Workflows](https://cloud.google.com/workflows/docs) |
| Memorystore | E | Shared transient fan-out/cache if measured need; never only copy of dispatch state | [Memorystore](https://cloud.google.com/memorystore/docs) |
| BigQuery | P/E | De-identified stage/outcome aggregates, cohort/drill comparison and cost analysis | [BigQuery](https://cloud.google.com/bigquery/docs) |
| Looker Studio / Looker | E | Leadership dashboards and reporting with scoped aggregate access | [Looker Studio](https://cloud.google.com/looker-studio), [Looker](https://cloud.google.com/looker/docs) |
| Datastream / Dataflow | D/E | CDC/stream processing when volume requires it; begin with scheduled outbox/aggregate export | [Datastream](https://cloud.google.com/datastream/docs), [Dataflow](https://cloud.google.com/dataflow/docs) |
| BigQuery ML | D/E | Later demand/readiness analysis with sufficient authorized data; no unsupported clinical predictions | [BQML](https://cloud.google.com/bigquery/docs/bqml-introduction) |
| Spanner / AlloyDB / Bigtable | D | No demonstrated need beyond PostgreSQL; service count is not architectural merit | [Spanner](https://cloud.google.com/spanner/docs), [AlloyDB](https://cloud.google.com/alloydb/docs), [Bigtable](https://cloud.google.com/bigtable/docs) |
| Integration Connectors / Application Integration | E | Campus enterprise integrations when supported/licensed; hospital integration requires actual contracts | [Integration](https://cloud.google.com/application-integration/docs) |
| Cloud IoT Core (legacy) | D | Excluded from target. Use authenticated HTTPS gateway ingestion; do not copy an old IoT Core architecture | [Current cloud products](https://cloud.google.com/products) |

## Maps, connectivity, security and operations

| Component | Stage | CareGrid responsibility / decision | Official reference |
| --- | --- | --- | --- |
| Maps JavaScript API / Flutter Google Maps | P | Geographic basemap under campus-owned zones and gate states | [Maps JS](https://developers.google.com/maps/documentation/javascript) |
| Routes API | P/E | External/public-road ETA support; institution graph handles restricted campus routes | [Routes](https://developers.google.com/maps/documentation/routes) |
| Navigation SDK | E | Crew navigation if supported/validated for operating region; no assumed ambulance priority | [Navigation](https://developers.google.com/maps/documentation/navigation) |
| Places / Geocoding | E | Address normalization/approved facility discovery; known campus IDs avoid repeated lookups | [Places](https://developers.google.com/maps/documentation/places/web-service), [Geocoding](https://developers.google.com/maps/documentation/geocoding) |
| Geolocation / Maps URLs | E | Optional location assistance/deep links; permission, accuracy and connectivity caveats | [Geolocation](https://developers.google.com/maps/documentation/geolocation), [URLs](https://developers.google.com/maps/documentation/urls/get-started) |
| IAM + service accounts | C | Separate API/AI/build/worker identities; least privilege by resource | [IAM](https://cloud.google.com/iam/docs) |
| Secret Manager | C | Provider secrets/config; workload identity instead of downloadable service keys | [Secrets](https://cloud.google.com/secret-manager/docs) |
| Cloud KMS / CMEK | P/E | Institution-required customer-managed keys after service/region support and recovery review | [KMS](https://cloud.google.com/kms/docs) |
| VPC / Direct VPC egress / Private Service Connect | P | Private SQL/integration paths; validate chosen service compatibility | [Direct VPC](https://cloud.google.com/run/docs/configuring/vpc-direct-vpc), [PSC](https://cloud.google.com/vpc/docs/private-service-connect) |
| Cloud VPN / Interconnect | E | Campus/private connectivity once local integration requires it | [VPN](https://cloud.google.com/network-connectivity/docs/vpn), [Interconnect](https://cloud.google.com/network-connectivity/docs/interconnect) |
| Cloud Load Balancing + Cloud Armor | P/E | Public perimeter, WAF/rate controls and selected ingress design | [Load balancing](https://cloud.google.com/load-balancing/docs), [Armor](https://cloud.google.com/armor/docs) |
| Identity-Aware Proxy | P/E | Staff/admin access where compatible; member SOS/mobile need separate end-user auth design | [IAP](https://cloud.google.com/iap/docs) |
| API Gateway / Apigee | D/E | Third-party API governance once integrations justify it; not mandatory in front of every endpoint | [Gateway](https://cloud.google.com/api-gateway/docs), [Apigee](https://cloud.google.com/apigee/docs) |
| Cloud CDN / DNS / Certificate Manager | P/E | Public asset/domain/TLS options; private evidence never default public CDN content | [CDN](https://cloud.google.com/cdn/docs), [DNS](https://cloud.google.com/dns/docs), [Certificates](https://cloud.google.com/certificate-manager/docs) |
| VPC Service Controls | P/E | Supported-service data perimeter after compatibility testing; not a substitute for app RBAC | [VPC SC](https://cloud.google.com/vpc-service-controls/docs) |
| Sensitive Data Protection | P | Inspect/redact selected exports; access and purpose still enforced | [SDP](https://cloud.google.com/sensitive-data-protection/docs) |
| Security Command Center | P/E | Central posture/vulnerability findings with appropriate tier/organization | [SCC](https://cloud.google.com/security-command-center/docs) |
| Cloud Logging + Audit Logs | C | Correlated operational logs plus cloud administrative audit; separate application incident audit | [Logging](https://cloud.google.com/logging/docs), [Audit](https://cloud.google.com/logging/docs/audit) |
| Cloud Monitoring + Trace / Error Reporting | C/P | Worker heartbeat, overdue ACK, errors, queues, DB saturation and uptime/latency | [Monitoring](https://cloud.google.com/monitoring/docs), [Trace](https://cloud.google.com/trace/docs) |
| Managed backup/PITR / Storage lifecycle | P | Restore-tested data recovery and retention; configure scope/region explicitly | [SQL recovery](https://cloud.google.com/sql/docs/postgres/backup-recovery/backups), [Lifecycle](https://cloud.google.com/storage/docs/lifecycle) |
| Cloud Build + Artifact Registry | C | Reproducible container build and image registry on Google | [Build](https://cloud.google.com/build/docs), [Registry](https://cloud.google.com/artifact-registry/docs) |
| Artifact Analysis / Binary Authorization | P | Container vulnerability/supply-chain policy after compatibility review | [Analysis](https://cloud.google.com/artifact-analysis/docs), [Binary Authorization](https://cloud.google.com/binary-authorization/docs) |
| Cloud Deploy | E | Controlled staged promotions/rollback when release workflow warrants it | [Deploy](https://cloud.google.com/deploy/docs) |
| Terraform + Infrastructure Manager | P | Reviewed reproducible infrastructure; no credentials checked into repo | [Infrastructure Manager](https://cloud.google.com/infrastructure-manager/docs) |
| Workload Identity Federation | P | Keyless external CI access if GitHub trigger is retained; Google-only Cloud Build path is simplest | [Federation](https://cloud.google.com/iam/docs/workload-identity-federation) |
| Cloud Billing budgets / quotas / Recommender | C | Spend visibility, eligible caps, bounded scaling and resource review | [Budgets](https://docs.cloud.google.com/billing/docs/how-to/budgets), [Caps](https://docs.cloud.google.com/billing/docs/how-to/budgets-spend-caps) |

## Tools and optional healthcare/workspace extensions

| Component | Stage | Decision | Official reference |
| --- | --- | --- | --- |
| Google AI Studio | T | Prompt experiments with synthetic data; production evidence uses enterprise project controls | [AI Studio](https://ai.google.dev/) |
| Google Antigravity / Gemini development tools | T | Development assistance and reproducible work history; not deployed emergency infrastructure | [Antigravity](https://antigravity.google/) |
| Cloud Shell / Cloud Workstations | T | Google-hosted development environments if useful; optional for the two-person team | [Cloud Shell](https://cloud.google.com/shell/docs), [Workstations](https://cloud.google.com/workstations/docs) |
| Google Workspace / Slides / Drive / Meet / Calendar | T/E | Deck/collaboration and possible drill scheduling; OAuth-minimized explicit integration only | [Workspace APIs](https://developers.google.com/workspace) |
| Apps Script / AppSheet | D/E | Lightweight administrative/drill tools only; not the urgent response state machine | [Apps Script](https://developers.google.com/apps-script), [AppSheet](https://about.appsheet.com/) |
| Cloud Healthcare API / FHIR / DICOM / HL7v2 | D/E | Only when a real clinical partner requires record exchange; no need to store clinical records for MVP | [Healthcare](https://cloud.google.com/healthcare-api/docs) |
| Contact Center AI / Dialogflow | D/E | Possible future staffed call intake, not autonomous emergency-call handling in MVP | [Dialogflow](https://cloud.google.com/dialogflow/docs) |

No finite list of all Google products is a useful deployment plan. This assessment deliberately covers the relevant alternatives and supporting layers, and records why optional services are deferred. Availability, product naming, contractual eligibility, region support and prices must be rechecked when provisioning. The core architecture remains comprehensible on one slide.
