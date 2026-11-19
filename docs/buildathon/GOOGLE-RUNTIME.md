# Google runtime implementation

Updated 20 November 2026. No Google Cloud project exists yet. Nothing in this document implies a deployed service, live Firebase sign-in or a field-tested emergency system.

## Runtime foundation

The API and the response watchdog have separate process roles. `CAREGRID_PROCESS_ROLE=api` serves requests without starting a timer. `watchdog` starts a one-second scan of persisted SQL deadlines; deploy it with continuously allocated CPU and a minimum instance. `all` is permitted only for local development/tests, where the in-memory scenario engine remains available.

A PostgreSQL transaction-scoped advisory lock serializes watchdog passes across revisions. A competing worker skips that pass; the lock is released when its owning transaction or connection ends. A restarted worker scans overdue SQL records again. This coordinates watchdogs; incident writes still need transactional state transitions, unit reservation, idempotency and an outbox before a pilot. It does not provide exactly-once effects or coordinate concurrent human actions.

Seeded PIN sign-in, account/PIN listing, demo reset and scenario endpoints reject deployed requests. Automatic synthetic-data seeding and simulated telemetry run only in local `development`/`test` modes. Cloud Run cannot select a development mode. Existing seeded credentials in an accidentally copied database cannot authenticate in production.

The container uses Dart's supplied Linux runtime, an unprivileged numeric user and an exec entrypoint for signal forwarding. The build context excludes local credentials, caches and original documents. Only the production configuration is copied into the final image. Cloud Run supplies the ingress `PORT`; migrations run once in a separate Serverpod maintenance job. The API does not apply migrations on each revision startup.

## Verification

Local Dart analysis and **37 tests passed**: the previous 29 plus four runtime-policy checks, two production boundary checks and two real-PostgreSQL watchdog ownership/failure checks. The Linux image build, custom ingress port, migration job, readiness probe, zero automatic users and deployed PIN lockout are covered by the new Google runtime CI workflow. Its result must be checked before merge.

The connected MVP was merged through [PR #1](https://github.com/ishaans04/CareGrid-/pull/1). All analysis, formatting, backend and connected browser checks passed on main after that merge.

## Google contracts used

- [Cloud Run container contract](https://docs.cloud.google.com/run/docs/container-contract): ingress must listen on the supplied port and all interfaces; shutdown signals reach the application.
- [CPU allocation](https://docs.cloud.google.com/run/docs/configuring/services/cpu): a background watchdog requires the appropriate continuously allocated runtime, rather than assuming requests keep it alive.
- [Cloud SQL connections from Cloud Run](https://docs.cloud.google.com/sql/docs/postgres/connect-run): the managed Unix socket uses `/cloudsql/PROJECT:REGION:INSTANCE`; the connector encrypts the connection. The Dart PostgreSQL driver supplies the PostgreSQL socket suffix.

Pinned Serverpod 4.0.4 package source was inspected for environment names, configuration overrides, maintenance migrations, health endpoints and shutdown hooks. Cloud resources and provider-side behavior remain unverified until a project is available.
