# Google staging deploy — handoff

> **Resolved 20 November 2026, 16:40 IST.** The socket fix was applied, migration `caregrid-demo-migrate-fdb4l` succeeded, synthetic data was seeded, and API, watchdog and web are serving at <https://caregrid-demo-web-959096744456.asia-south1.run.app>. The remaining step is a real Google sign-in followed by `bootstrap bind`. The current record is section 0 of [GOOGLE-PROVISIONING.md](GOOGLE-PROVISIONING.md); the note below is kept as the historical handoff.

**Written for:** the next agent/engineer resuming the `caregrid-staging` deploy. Prior operator (Codex) ran out of usage limit mid-deploy on 20 Nov 2026 ~15:00 IST.

## TL;DR state

- **Code is done and pushed.** `61e1de8` ("Use the full PostgreSQL socket filename on Cloud Run") is on `main`. Working tree clean. No uncommitted/dangling deploy code.
- **Live cloud deploy is HALF-DONE.** Foundation infra applied; application services NOT yet serving; **first DB migration never completed.**
- **One lost artifact (minor):** Codex intended to add a "Linux socket regression check" test (~+91 lines, the hidden 4th file in its last panel). It was never committed and is not recoverable. Re-add if you want the regression guard; the actual fix it protects is already in `61e1de8`.

## What exists in Google Cloud (applied)

Project `caregrid-staging`, region `asia-south1`.
- Billed project, Firebase config, $5 budget (alert-only, **does not auto-stop**), private Terraform state GCS bucket.
- Foundation applied: private build + evidence buckets, runtime identities, scoped secret grants, Artifact Registry repo.
- Both container images built with immutable digests: **web** and **server**.
- Cloud SQL (Postgres) provisioned.
- Stable DB/service secrets stored in an **encrypted Windows profile dir OUTSIDE the repo** (not in git, not in `tmp/`). Locate those before retrying — the deploy can't proceed without them.

## Where it stopped (the blocker)

First migration job `caregrid-demo-migrate` **failed**: Cloud SQL socket host was set to the *directory* only. Fix (already committed in `61e1de8`): `SERVERPOD_DATABASE_HOST` must be the full socket filename:

```
/cloudsql/PROJECT:REGION:INSTANCE/.s.PGSQL.5432
```

Codex corrected `infra/google/runtime.tf` + `.github/workflows/google-runtime.yml` for this, then tried to apply + re-run the migration. **That command was declined by auto-review, then the session hit its usage limit.** So the fix is in git but **NOT yet applied to live infra**, and the migration has **NOT** been re-run.

## Next steps (resume here)

1. Recover the secrets from the encrypted Windows profile dir; confirm gcloud auth to `caregrid-staging`.
2. Re-establish the ephemeral helpers Codex used (they lived in gitignored `tmp/`, now gone): the gcloud wrapper (`tmp/caregrid-gcloud.cmd`) and the terraform driver (`tmp/google-setup/deploy-terraform.ps1`). Or just use `gcloud` + `terraform` directly.
3. **Apply the `jobs-socket-fix` plan** (updates the 2 Cloud Run jobs with the corrected socket host — should be 2 `update` no-op-free changes, nothing created/destroyed).
4. **Re-run migration:** `gcloud run jobs execute caregrid-demo-migrate --project=caregrid-staging --region=asia-south1 --wait`. Confirm success.
5. Bring up serving workloads: API (`CAREGRID_PROCESS_ROLE=api`) and watchdog (`CAREGRID_PROCESS_ROLE=watchdog`, continuous CPU + min 1 instance). Web gateway.
6. First **Google sign-in**: the operator's Google account has **no Firebase app user record yet** — first sign-in once the web URL is live creates it.
7. Keep **Gemini inference and evidence uploads DISABLED** until their live checks pass (both off by default — see `GOOGLE-GEMINI.md`, `GOOGLE-EVIDENCE.md`).

## Cost / time window — IMPORTANT

- Baseline ~**$2.72 / 24h** (Cloud SQL + Cloud Run, Mumbai rates). $5 ≈ 44h theoretical.
- **Credit EXPIRES 21 Nov 2026** — plan around the expiry, not the $5 depletion. Expiry likely cuts the window short regardless of remaining balance.
- Budget sends alerts only; **no automatic spend stop.** Watch it manually.

## Reference docs (same branch)

- `docs/buildathon/GOOGLE-RUNTIME.md` — runtime roles, Cloud Run contract, socket fix rationale.
- `docs/buildathon/GOOGLE-PROVISIONING.md` — live vs planned resources.
- `infra/google/README.md` — infra module + rollout runbook.
