# CareGrid Google deployment foundation

20 November 2026. **Prepared, not applied.** No project/billing is available. Schema validation and mocked plans do not establish that a Google deployment works. This module is for the synthetic staging MVP; the broader [solution architecture](../../docs/buildathon/SOLUTION-ARCHITECTURE.md) remains the pilot/expansion design.

## What is concrete

| Building block | Configuration |
| --- | --- |
| Runtime | Distinct web/API/watchdog/migration/bootstrap service accounts; unprivileged Linux images; API and worker have IAM invocation enabled |
| Web/API | Web can invoke only the API; browser Firebase token stays separate from the service token; public web access defaults off |
| Watchdog | At least one instance with continuously allocated CPU; maximum one configured revision instance; SQL advisory lock coordinates overlapping revisions |
| PostgreSQL | Cloud SQL PostgreSQL 16 Enterprise, zonal staging tier, encrypted connector transport, no authorized direct-IP networks, backups/PITR and deletion protection |
| Secrets | Scoped Secret Manager grants; pinned secret versions; ephemeral Terraform inputs and write-only provider arguments keep secret values out of state/plan files |
| Artifacts/build | Regional Artifact Registry, dedicated build identity, private source bucket with seven-day lifecycle; pipeline builds/pushes both images without deployment permission |
| Evidence | Private, versioned bucket with public access prevention; no app upload grant/endpoint yet; synthetic objects have a 30-day deletion lifecycle |
| Operations | Structured watchdog failure metric and two monitoring policies; notification channels are explicit existing inputs; default creates console incidents only |
| State | GCS backend requires a separately created private versioned bucket; no application resources own/delete their state bucket |

This deliberately does not create a project, attach billing, configure OAuth consent, grant humans project ownership, create credentials or silently provision every service in the research catalogue. Firebase project/web registration and provider settings are operator steps. Gemini, FCM delivery, Maps and evidence access are separate application increments. An empty evidence bucket does not establish a working evidence pipeline.

## Offline checks

Terraform **1.17.2**, Google provider **8.12.0**, signed Windows/Linux checksums in the lockfile:

```text
terraform init -backend=false -input=false -lockfile=readonly
terraform fmt -check -recursive
terraform validate
terraform test
```

The six mocked plan runs check foundation/jobs/services boundaries, lack of direct SQL allowlists, absence of web SQL/secret access, private evidence, continuously allocated watchdog CPU, explicit public entry, immutable image inputs and migration attestation. They use no Google credentials and create nothing. GitHub Actions repeats these checks on Linux. Cloud Build YAML is prepared but has not run on Google.

## First rollout once a project exists

Use Google Cloud Shell or a locally installed authenticated Google Cloud SDK and Terraform. Follow the actual project/region throughout; do not run these placeholder commands unchanged. Review the billable plan before apply. Cloud SQL and the continuously running watchdog incur ongoing charges. Create a project budget and verified alerts in Cloud Billing before provisioning; a budget notification is not a spending cap. Confirm the billing account currency, build credits, quotas and regional availability using Google's current calculator rather than presenting the staging settings as a price quote.

1. Select the existing billed project, add Firebase, register its web app and enable the Google provider as described in [Google identity](../../docs/buildathon/GOOGLE-IDENTITY.md). Confirm organization policies permit service accounts, Cloud Run and the chosen network/public-entry policy.
2. Create a separate GCS state bucket with uniform access, public access prevention and versioning. Grant only the deployment operator/identity the required state object access. Copy `backend.hcl.example` to ignored `backend.hcl` with that bucket and an environment-specific prefix. State contains infrastructure identifiers/public configuration and still requires protection, even though secret values are write-only.
3. Copy `terraform.tfvars.example` to ignored `terraform.tfvars`. Set project/region/prefix. Supply generated, **stable** secrets of at least 32 characters through process-local `TF_VAR_database_password` and `TF_VAR_service_secret` from a secure password store. Do not paste them in flags, tfvars, repository files, chat, logs or shell transcripts. Keep the same inputs on subsequent runs until a coordinated rotation. Remove the environment variables after use. Never confuse Firebase's public web configuration with administrative credentials.
4. Initialize `terraform init -backend-config=backend.hcl`. With `rollout_stage="foundation"`, inspect `terraform plan` and then apply that reviewed configuration. This creates billable SQL/storage plus APIs, identities, artifacts/secrets/monitoring. It does not deploy workloads. The deployment operator needs the corresponding service-management/IAM/SQL/Run/Storage/Secret Manager/Monitoring permissions and permission to attach the runtime accounts. Use a dedicated deployment identity and review narrowly scoped grants; this module does not grant Owner/Editor.
5. Review the upload file list from the repository root with `gcloud meta list-files-for-upload`. `.gcloudignore` includes only build inputs; original PDFs, Git metadata, local credentials/caches and test PEMs are excluded. The submitter needs Cloud Build submission permission, `iam.serviceAccounts.actAs` on the build account and object creation in the source bucket. The dedicated build account receives scoped source read, artifact write and log write, without SQL, secret or deploy rights.

Example **Cloud Shell Bash**, from a clean checkout after setting the real variables:

```bash
PROJECT_ID=your-project-id
REGION=asia-south1
PREFIX=caregrid-demo
COMMIT=$(git rev-parse HEAD)
gcloud builds submit . --project="$PROJECT_ID" --region="$REGION" \
  --config=infra/google/cloudbuild.yaml \
  --service-account="projects/$PROJECT_ID/serviceAccounts/$PREFIX-build@$PROJECT_ID.iam.gserviceaccount.com" \
  --gcs-source-staging-dir="gs://$PROJECT_ID-$PREFIX-build-source/source" \
  --substitutions="_REGION=$REGION,_REPOSITORY=$PREFIX-images,_IMAGE_TAG=$COMMIT"
```

6. Wait for the successful build; obtain each pushed image's `sha256` digest from Artifact Registry. Set `server_image` and `web_image` to their full digest references. Mutable tags fail validation. Images derive from the reviewed commit; retain its build ID and digests as release evidence. Base images have version tags today; pin/scan their resolved digests before a pilot.
7. Before migrations, verify the staging `caregrid` SQL user can connect and create tables in the `caregrid` database/public schema. PostgreSQL 15+ schema defaults differ from older installations. If needed, use the database/schema owner through Cloud SQL Studio or the authenticated SQL connector to run [the explicit staging grants](sql/staging-grants.sql). Keep owner credentials out of app jobs; grant the named user rather than `PUBLIC`. The module cannot issue SQL grants through the Google SQL Admin API. CI runs migrations under a non-superuser after these grants; live Cloud SQL grants still need verification. Then set `rollout_stage="jobs"`, apply the reviewed plan and execute **only** the migration job. The command below waits for the execution result. Check its success and logs, not merely the job resource's creation. Jobs have one task and zero automatic retries; do not run overlapping migrations or seed jobs.

```bash
gcloud run jobs execute "$PREFIX-migrate" --project="$PROJECT_ID" --region="$REGION" --wait
```

8. For fictional staging only, run the explicit seed execution, then bind intended Firebase UIDs. Keep the configured bootstrap job's seed opt-in absent; pass it only for that execution. Job arguments appear in control-plane metadata, so pass **UID/handle, never tokens or passwords**. Operators require `run.jobs.runWithOverrides` in addition to ordinary execution rights.

```bash
gcloud run jobs execute "$PREFIX-bootstrap" --project="$PROJECT_ID" --region="$REGION" \
  --args=bootstrap,seed-synthetic --update-env-vars=CAREGRID_BOOTSTRAP_SYNTHETIC=true --wait
gcloud run jobs execute "$PREFIX-bootstrap" --project="$PROJECT_ID" --region="$REGION" \
  --args=bootstrap,bind,cmd.night,FIREBASE_UID_FROM_THE_INTENDED_USER_RECORD --wait
```

9. Add the `web_origin` output hostname to Firebase authorized domains. Set the two public Firebase web values. Record the successful migration execution ID, verify its digest matches this release, then set `migration_verified=true` and `rollout_stage="services"`. This is an **operator attestation**, not a Terraform check of database schema/execution history. Choose `public_web=true` only when intentionally exposing the browser entry. With it false, an ordinary browser cannot pass Cloud Run IAM using a Firebase token alone; this is the default private gate, not a completed user-facing deployment.
10. Review/apply. Confirm actual service URLs match the configured deterministic `web_origin`/`api_origin`. Use that exact web origin; alternate aliases are rejected by the gateway's host/origin checks. Test the [identity acceptance gates](../../docs/buildathon/GOOGLE-IDENTITY.md), all roles, live SQL connector, API/worker restart and overdue recovery. Confirm the worker needs no request traffic to scan deadlines. Verify health probes, alert delivery and IAM denial from outside the gateway. Do not use real campus emergency data for this staging rollout.

## Subsequent release and recovery

Do **not** move an active module backwards from `services` to `jobs`/`foundation`: that would plan workload deletion (normally blocked by deletion protection). Keep the serving `server_image` unchanged, update `maintenance_image` to the next server digest and apply just the ordinary reviewed plan. Execute/verify its migration job. Then update `server_image` and `web_image`, set/retain the migration attestation only after checking that release, and apply the next plan. Prefer additive/backward-compatible migrations; the membership migration adds nullable/defaulted fields and a unique nullable UID index. Retain the successful execution record with the release.

Roll back application digests through a reviewed Terraform plan, not an unrecorded deployment that creates drift. Database schema is not rolled back by changing an image. If a migration failed, inspect its execution and SQL state before rerunning; seed/import is not transactional and should not be treated as a recoverable migration. Restore backups into a separate instance and rehearse recovery before a pilot. Use SQL membership disable/revoke for immediate application denial.

Rotation increments `secret_revision` and updates **both** ephemeral inputs. PostgreSQL password changes can invalidate old instances when they reconnect; coordinate replacement/drain of API/worker/jobs. Pinned secret versions prevent unplanned `latest` adoption but do not by themselves provide zero-downtime rotation. Do not rotate a real pilot using this simple staging sequence without a dual-credential rollout design.

## Known limits and pilot gates

- SQL uses a public address with **no direct-IP authorized networks**, accessed through Cloud Run's encrypted managed Unix-socket connector. This is an explicit staging tradeoff. Private IP/Direct VPC networking, organization policy and zonal/regional HA must be configured and tested for the pilot; this module does not claim a private-IP SQL topology.
- API/worker have separate Google identities, but share a staging SQL `cloudsqlsuperuser` role with migration jobs. They are not least-privilege database users. Split schema ownership/migrations from runtime DML, constrain grants and verify them before a pilot.
- API pool: five connections per instance, max two configured instances; watchdog: four connections, max one; each of the two jobs: two. The watchdog requires at least two because the ownership transaction and scan use separate connections. Revision overlaps, platform scaling behavior and operators can raise the aggregate. Monitor actual connections; these settings are not a global hard cap.
- Deadline records survive restarts and workers serialize scans. Human transitions, allocation, external effects and retries still need transactions/idempotency/outbox. A healthy process does not prove a successful scan. Current alerts detect reported failures/5xx, not all hangs; pass-heartbeat, oldest-overdue, SQL saturation and measured SLO alerts remain gates.
- No default alert recipient is invented. Configure verified `notification_channels`, exercise a deliberate staging failure, and confirm receipt. No email/Slack/notification was sent by this work.
- The evidence bucket has no public grant or runtime grant. GCS signing, scoped evidence ACLs, upload validation, consent/retention and audit are unimplemented. The synthetic lifecycle is not an approved medical/security evidence retention policy.
- Firebase setup, OAuth domain validation, Cloud Build, managed SQL networking, real billing, restore and provider-side IAM propagation require an actual project. Mocked tests cannot validate them. Neither this module nor the screenshots establish operational or clinical readiness.

References: [Cloud Run SQL connector](https://docs.cloud.google.com/sql/docs/postgres/connect-run), [deterministic service URLs](https://docs.cloud.google.com/run/docs/triggering/https-request), [background CPU allocation](https://docs.cloud.google.com/run/docs/configuring/services/cpu), [user-managed build identity](https://docs.cloud.google.com/build/docs/securing-builds/configure-user-specified-service-accounts), [write-only arguments](https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments), and [provider 8.12.0 source](https://github.com/hashicorp/terraform-provider-google/tree/v8.12.0).
