# Google runtime implementation

Updated 20 November 2026. The billed `caregrid-staging` project, Firebase configuration, budget and private Terraform state bucket now exist; the application module remains unapplied. See the [provisioning record](GOOGLE-PROVISIONING.md). Nothing in this document implies a deployed service, live Firebase sign-in or a field-tested emergency system.

## Runtime foundation

The API and the response watchdog have separate process roles. `CAREGRID_PROCESS_ROLE=api` serves requests without starting a timer. `watchdog` starts a one-second scan of persisted SQL deadlines; deploy it with continuously allocated CPU and a minimum instance. `all` is permitted only for local development/tests, where the in-memory scenario engine remains available.

A PostgreSQL transaction-scoped advisory lock serializes watchdog passes across revisions. A competing worker skips that pass; the lock is released when its owning transaction or connection ends. A restarted worker scans overdue SQL records again. This coordinates watchdogs; incident writes still need transactional state transitions, unit reservation, idempotency and an outbox before a pilot. It does not provide exactly-once effects or coordinate concurrent human actions.

Seeded PIN sign-in, account/PIN listing, demo reset and scenario endpoints reject deployed requests. Automatic synthetic-data seeding and simulated telemetry run only in local `development`/`test` modes. Cloud Run cannot select a development mode. Existing seeded credentials in an accidentally copied database cannot authenticate in production.

The container uses Dart's supplied Linux runtime, an unprivileged numeric user and an exec entrypoint for signal forwarding. The build context excludes local credentials, caches and original documents. Only the production configuration is copied into the final image. Cloud Run supplies the ingress `PORT`; migrations run once in a separate Serverpod maintenance job. The API does not apply migrations on each revision startup.

## Verification

The runtime-foundation commit passed its Linux image build, custom ingress port, migration job, readiness probe, zero automatic users and deployed PIN lockout in GitHub Actions. The local suite then contained 37 passing tests, including real-PostgreSQL watchdog ownership/failure checks.

The identity increment adds [Firebase identity and SQL membership](GOOGLE-IDENTITY.md), a stateless Google-authenticated web gateway, private bootstrap commands and an additive database migration. Both Linux image checks, maintenance/bootstrap checks, backend analysis/tests, Flutter analysis/format/tests and connected browser checks passed before [PR #2](https://github.com/ishaans04/CareGrid/pull/2) merged to main. Google IAM, OAuth, SQL connectivity and provider-side shutdown behavior still require a real project.

The [Google infrastructure module and rollout runbook](../../infra/google/README.md) prepare Cloud Run services/jobs, Cloud SQL, Artifact Registry, scoped identities/secrets, private build/evidence buckets, monitoring and a build-only Cloud Build pipeline. Terraform provider validation and ten mocked rollout plans pass without Google credentials. A real authenticated GCS-backed foundation plan subsequently passed with 46 additions and no updates/deletions. No application apply or Cloud Build run has occurred; the [provisioning record](GOOGLE-PROVISIONING.md) distinguishes live setup from planned resources.

The connected MVP was merged through [PR #1](https://github.com/ishaans04/CareGrid/pull/1). All analysis, formatting, backend and connected browser checks passed on main after that merge.

## Optional inference

The [Gemini handoff adapter](GOOGLE-GEMINI.md) is implemented with a command-only endpoint and optional UI. It remains disabled by default. Terraform can enable the API identity’s inference-only role with explicit model/location inputs. Tests use synthetic provider responses; no Google model has been called. It cannot alter policy, dispatch or closure.

## Private evidence

The optional [private evidence broker](GOOGLE-EVIDENCE.md) is implemented and disabled by default. It uses API workload identity, bucket-scoped object permissions, authenticated image reads and generation/digest checks. It does not use the inherited Serverpod storage registration. Google storage/IAM/retention acceptance remains pending.

## Google contracts used

- [Cloud Run container contract](https://docs.cloud.google.com/run/docs/container-contract): ingress must listen on the supplied port and all interfaces; shutdown signals reach the application.
- [CPU allocation](https://docs.cloud.google.com/run/docs/configuring/services/cpu): a background watchdog requires the appropriate continuously allocated runtime, rather than assuming requests keep it alive.
- [Cloud SQL connections from Cloud Run](https://docs.cloud.google.com/sql/docs/postgres/connect-run): the managed connector encrypts the connection. The pinned Dart PostgreSQL driver connects to its host path verbatim, so `SERVERPOD_DATABASE_HOST` must contain the full socket filename: `/cloudsql/PROJECT:REGION:INSTANCE/.s.PGSQL.5432`. Supplying only the directory failed in the first live migration.

Pinned Serverpod 4.0.4 package source was inspected for environment names, configuration overrides, maintenance migrations, health endpoints and shutdown hooks. Cloud resources and provider-side behavior remain unverified until a project is available.
