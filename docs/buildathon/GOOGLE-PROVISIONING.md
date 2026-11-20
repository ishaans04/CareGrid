# Google hosting and provisioning record

**Team Duality / CareGrid Staging. Verified 20 November 2026, approximately 14:37 IST (09:07 UTC).**

This is the operational starting point for another coding or deployment agent. The Google account, billing link, Firebase configuration, budget and Terraform state bucket exist. **The CareGrid application has not been deployed.** A successful authenticated Terraform plan is preparation, not a running MVP.

This record supplements the [deployment runbook](../../infra/google/README.md), which remains the source for staged rollout commands. Recheck live resources and current `main` before making changes; this is a dated inventory.

## 1. Repository and working folders

| Item | Value |
| --- | --- |
| Repository | [ishaans04/CareGrid](https://github.com/ishaans04/CareGrid) |
| Active Windows checkout | `E:\Projects\CareGrid-` |
| Related folder | `E:\Projects\CareGrid` holds the shared Git repository metadata; these are linked worktrees, not interchangeable deployment roots |
| Infrastructure source | [infra/google](../../infra/google/README.md) |
| Application work | Another agent is working on application code. Use an isolated branch/worktree and preserve its changes |
| Editor constraint | Do not operate the user's VS Code; use files and CLI |

This document was prepared on top of `0698ead` (campus isolation and NIET digital twin). The earlier live infrastructure plan used `d8dcf2ca3d76d1320866dba4071b8d504b98ede9`. **Build and migrate the latest reviewed release, not that old planning snapshot.** In particular, include the current response-record and campus migrations.

## 2. Account, project and billing

| Setting | Verified value |
| --- | --- |
| Owner / active CLI account | `vighriday@gmail.com` |
| Project display name | CareGrid Staging |
| Project ID | `caregrid-staging` |
| Project number | `959096744456` |
| Project lifecycle | ACTIVE |
| Organization | Personal account; no Google Workspace organization configured |
| Region selected | `asia-south1` — Mumbai |
| Resource prefix selected | `caregrid-demo` |
| Billing account | `01834C-FC917A-2D73CC` |
| Billing account name | GDP Event Credit: Startup Buildathon - Delhi |
| Billing currency / linkage | USD; `billingEnabled=true` for this project |
| Existing human permissions | Owner on the project; Billing Account Administrator on the billing account |

No collaborator's Google IAM access was added. GitHub collaboration does not grant Google Cloud access. Do not invent Ishaan's Google email or grant broad roles automatically. No service-account JSON key was created.

The user's Billing Credits screenshots showed **GDP – Codelab credit: $5 original / $5 remaining**, valid **19–21 November 2026**. That is a screenshot observation, not a live balance or an exact expiry timestamp. Recheck Billing → Credits before provisioning; an active billing account does not prove unexpired credit or prevent charges after credit exhaustion.

### Budget already configured

The existing `CareGrid` budget was corrected from a zero-dollar, account-wide budget; no duplicate was created.

| Field | Value |
| --- | --- |
| Budget ID | `9971ec4b-8fd7-4217-bd92-a14f3c7147a2` |
| Resource | `billingAccounts/01834C-FC917A-2D73CC/budgets/9971ec4b-8fd7-4217-bd92-a14f3c7147a2` |
| Amount / period | USD 5 / calendar month |
| Project filter | `projects/959096744456` |
| Credit treatment | `EXCLUDE_ALL_CREDITS`: gross cost before all credits, not remaining promotional balance |
| Actual-spend thresholds | 50%, 80%, 100% |
| Forecast threshold | 100% |
| Recipients | Default billing-role recipients; the owner has `roles/billing.admin` |

The API returns `notificationsRule={}`; do not claim a project-owner recipient option or custom channel was enabled. Email delivery has not been exercised. **This is an alerts-only budget, not a spending cap or automatic shutdown.** See [Google's budget documentation](https://docs.cloud.google.com/billing/docs/how-to/budgets).

## 3. Firebase configuration already completed

Firebase was added to the same `caregrid-staging` Google Cloud project. The console shows the Blaze plan because billing is linked; there is no separate Firebase credit pool established by this work.

| Public application setting | Value |
| --- | --- |
| Web app ID | `1:959096744456:web:82291fa6aa18977d713fbd` |
| Messaging sender ID | `959096744456` |
| SDK auth domain | `caregrid-staging.firebaseapp.com` |
| Configured storage bucket name | `caregrid-staging.firebasestorage.app` |
| Public-facing name / support | CareGrid / `vighriday@gmail.com`, configured by the user |
| Google Authentication provider | `google.com`, live Admin API returns `enabled=true` |

The storage bucket name above is a Firebase SDK configuration value; **it does not prove that bucket exists**. The live GCS inventory contains only the Terraform state bucket below.

Firebase Authentication's authorized domains were read back as:

- `localhost`
- `caregrid-staging.firebaseapp.com`
- `caregrid-staging.web.app`
- `caregrid-demo-web-959096744456.asia-south1.run.app`

The last domain was added in preparation for the selected Cloud Run naming scheme. **It is not evidence of a deployed web service.** Keep the Firebase SDK auth domain above; an authorized domain is a hostname, not a URL with a path or wildcard.

The public Firebase API key is available in Firebase Console → Project settings → Your apps and the ignored local `infra/google/terraform.tfvars`. It is public app configuration, not an administrative credential. Retrieve it from the existing app rather than creating another app/key unnecessarily.

Terraform maps `firebase_web_api_key` and `firebase_web_app_id` to gateway `FIREBASE_WEB_API_KEY` and `FIREBASE_WEB_APP_ID`; `project_id` supplies `FIREBASE_PROJECT_ID`. Exact web/API origins come from module outputs. See [identity configuration and acceptance](GOOGLE-IDENTITY.md).

**Still unverified:** real Firebase user sign-in, refresh, sign-out, reauthentication, UID-to-SQL membership binding and deployed role denial. CLI OAuth sign-in is not Firebase app sign-in. Obtain a real Firebase UID from its user record; an email address is not a UID.

## 4. Existing cloud resources and enabled APIs

### Private Terraform state bucket — created

| Field | Live value |
| --- | --- |
| Bucket | `gs://caregrid-staging-tfstate-959096744456` |
| Location / class | `ASIA-SOUTH1` / STANDARD |
| Created | 20 November 2026, 08:27:49 UTC |
| Uniform bucket-level access | Enabled |
| Public access prevention | Enforced |
| Object versioning | Enabled |
| Soft-delete retention | 604800 seconds / seven days |
| Labels | `app=caregrid`, `team=duality`, `environment=staging`, `purpose=terraform-state` |
| Terraform state prefix | `caregrid/staging` |

This bucket is bootstrapped separately from the application module. Do not import it as an application-owned resource, delete it during ordinary app cleanup, or point staging at a new empty state location. It can incur storage/operation charges even while app hosting is absent.

### APIs — enabled, not deployed workloads

All twelve APIs declared by [foundation.tf](../../infra/google/foundation.tf) are enabled:

```text
run.googleapis.com
sqladmin.googleapis.com
artifactregistry.googleapis.com
secretmanager.googleapis.com
storage.googleapis.com
iam.googleapis.com
iamcredentials.googleapis.com
cloudbuild.googleapis.com
logging.googleapis.com
monitoring.googleapis.com
identitytoolkit.googleapis.com
firebase.googleapis.com
```

`billingbudgets.googleapis.com` and `cloudbilling.googleapis.com` are also enabled for budget management and pricing-catalog inspection. This session explicitly enabled Run, SQL Admin, Artifact Registry, Secret Manager, IAM, IAM Credentials, Cloud Build and those two billing APIs; other baseline APIs were already enabled by project/Firebase setup.

The project also has automatically enabled Firebase/Google dependencies and APIs, including FCM, Firebase Hosting, BigQuery, Pub/Sub and tracing. API availability does not establish an FCM integration, Hosting release, analytics dataset or deployed product. Do not disable unrelated dependencies to make this inventory shorter. `aiplatform.googleapis.com` was not enabled; optional inference remains off.

### Application inventory — verified absent

Live listings returned no Cloud Run services/jobs in Mumbai, no Cloud SQL instances project-wide, no Artifact Registry repositories in Mumbai, no Secret Manager secrets, and no custom `caregrid-demo-*` service accounts. GCS lists only the state bucket.

Consequently there is **no live CareGrid URL, Cloud Build release, image digest, SQL connection acceptance, migration execution, bootstrap execution, runtime secret version or bound application UID** to hand over. Google-managed service agents may exist after API activation; they are different from the six planned custom runtime/build accounts.

No custom domain/DNS, Firebase Hosting release, AI Studio/Maps key, model call, FCM delivery, evidence upload, monitoring delivery channel or CI deployment federation was configured by this setup. Local CI and screenshot checks are not cloud acceptance.

## 5. Local tools, authentication and files

### Tools installed locally

| Tool | Location / version |
| --- | --- |
| Google Cloud CLI | `tmp/toolchains/google-cloud-cli/google-cloud-sdk/bin/gcloud.cmd`, version **594.0.0** |
| Bundled Python | `tmp/toolchains/google-cloud-cli/google-cloud-sdk/platform/bundledpython/python.exe` |
| Terraform | `tmp/toolchains/terraform/terraform.exe`, version **1.17.2** |
| Terraform Google provider | **8.12.0**, pinned by the tracked lockfile with Windows/Linux checksums |

Paths above are relative to `E:\Projects\CareGrid-`. Tools are portable and ignored; they are not installed globally and will not appear in a fresh clone. The official Cloud SDK ZIP's verified SHA-256 was `17359246fa68be3a6681569988040044f60f07ed784b1e1d7b75893b941762b3`; use [Google's versioned archives](https://docs.cloud.google.com/sdk/docs/downloads-versioned-archives) for reproducible replacement.

### Canonical credential location

Active credentials were moved outside the repository:

```text
%APPDATA%\CareGrid\gcloud-staging-959096744456
This machine: C:\Users\Hriday\AppData\Roaming\CareGrid\gcloud-staging-959096744456
```

The active directory/files have restricted ACLs for Hriday, SYSTEM and Administrators. Three active credential stores were relocated and their duplicate active copies removed from the project's old `tmp/google-cloud-config`. An inaccessible legacy cache may remain in that ignored old directory; do not use it, broaden its ACLs or take ownership to inspect it.

CLI login and Application Default Credentials (ADC) both use `vighriday@gmail.com`. ADC quota project is `caregrid-staging`; the earlier quota-project warning was resolved. Scoped CLI defaults select project `caregrid-staging` and Run region `asia-south1`. Authentication and GCS backend access were verified after relocation.

**Never print/copy credential JSON, access tokens, refresh tokens or credential databases into chat, tracked files, logs or build context.** Another machine should authenticate its authorized operator, not copy these credentials. This setup does not change the global default gcloud credential profile.

### Ignored helpers on this machine

| Helper | Purpose |
| --- | --- |
| `tmp/caregrid-cloud-login.cmd` | Interactive Google login with ADC update, project selection and ADC quota-project correction |
| `tmp/caregrid-gcloud.cmd` | Run gcloud using the private CareGrid credential directory |
| `tmp/caregrid-terraform.cmd` | Set ADC/quota environment and run Terraform from the original checkout's `infra/google` |

The Terraform helper **always targets `E:\Projects\CareGrid-\infra\google`**, even when invoked from another worktree. For an isolated checkout, invoke Terraform directly in that checkout with the same scoped environment; do not accidentally plan a different source tree.

Read-only checks from the original checkout:

```powershell
& .\tmp\caregrid-gcloud.cmd auth list --filter=status:ACTIVE --format="value(account)"
& .\tmp\caregrid-gcloud.cmd billing projects describe caregrid-staging
& .\tmp\caregrid-gcloud.cmd run services list --project=caregrid-staging --region=asia-south1
& .\tmp\caregrid-gcloud.cmd sql instances list --project=caregrid-staging
& .\tmp\caregrid-terraform.cmd workspace list
& .\tmp\caregrid-terraform.cmd state list
```

On a new machine, install the pinned tools, start a task-specific PowerShell session, and set an operator-owned private credential directory. The following uses a normal installed `gcloud`; substitute its absolute executable path for a portable installation:

```powershell
$env:CLOUDSDK_CONFIG = Join-Path $env:APPDATA 'CareGrid\gcloud-staging-959096744456'
gcloud auth login --update-adc
gcloud config set project caregrid-staging
gcloud config set run/region asia-south1
gcloud auth application-default set-quota-project caregrid-staging
$env:GOOGLE_APPLICATION_CREDENTIALS = Join-Path $env:CLOUDSDK_CONFIG 'application_default_credentials.json'
$env:GOOGLE_CLOUD_QUOTA_PROJECT = 'caregrid-staging'
gcloud auth list --filter=status:ACTIVE --format="value(account)"
```

Confirm the intended authorized account and private directory permissions before proceeding. These are process-scoped environment variables; do not persist secrets in profile scripts.

### Ignored Terraform inputs already prepared

`infra/google/backend.hcl`:

```hcl
bucket = "caregrid-staging-tfstate-959096744456"
prefix = "caregrid/staging"
```

`infra/google/terraform.tfvars` selects:

```hcl
project_id      = "caregrid-staging"
region          = "asia-south1"
prefix          = "caregrid-demo"
rollout_stage   = "foundation"
public_web      = false
enable_gemini   = false
enable_evidence = false
# firebase_web_api_key and firebase_web_app_id contain public app configuration.
```

Both files exist only locally and are ignored. Recreate them from the tracked [tfvars example](../../infra/google/terraform.tfvars.example) and [backend example](../../infra/google/backend.hcl.example) in another checkout. Neither contains a database password or Serverpod service secret.

## 6. Terraform verification and planned hosting

Canonical `infra/google` was initialized against the actual GCS backend with:

```text
terraform init -reconfigure -input=false -lockfile=readonly -backend-config=backend.hcl -no-color
```

A real authenticated foundation plan passed: **46 create / 0 update / 0 delete**, with **zero Owner, Editor or allUsers IAM grants** in that foundation plan. Twelve create entries represent adopting API enablement into Terraform state even though the APIs are already enabled. The plan has **not been applied**. Offline schema/mocked-plan checks are separate evidence.

Ignored local review artifacts are under `tmp/google-setup/`: `foundation-google.tfplan`, `foundation-google-plan.log`, `foundation-google-plan.json`, and `plan-review.json`. An older `foundation-plan/` preview used a temporary local backend; the canonical GCS-backed plan is the relevant result.

**The plan used temporary, in-memory plan-only secret inputs that were not retained. There are no stable deployment passwords to recover.** Generate and securely retain stable inputs before a new reviewed plan/apply. Do not apply the old saved plan or assume its secret inputs exist. Treat plans/state as private operational artifacts even with ephemeral/write-only secret handling.

### Planned names — none is a deployed endpoint/resource

| Resource | Planned value |
| --- | --- |
| Web origin | `https://caregrid-demo-web-959096744456.asia-south1.run.app` |
| API origin | `https://caregrid-demo-api-959096744456.asia-south1.run.app` |
| Watchdog service | `caregrid-demo-watchdog` |
| Migration / bootstrap jobs | `caregrid-demo-migrate` / `caregrid-demo-bootstrap` |
| Artifact Registry path | `asia-south1-docker.pkg.dev/caregrid-staging/caregrid-demo-images` |
| SQL instance / database / user | `caregrid-demo-pg` / `caregrid` / `caregrid` |
| SQL connection name | `caregrid-staging:asia-south1:caregrid-demo-pg` |
| Runtime secret IDs | `caregrid-demo-database-password`, `caregrid-demo-service-secret` |
| Build-source bucket | `caregrid-staging-caregrid-demo-build-source` |
| Evidence bucket | `caregrid-staging-caregrid-demo-evidence` |

Six planned accounts follow `caregrid-demo-ROLE@caregrid-staging.iam.gserviceaccount.com`, where ROLE is `web`, `api`, `watchdog`, `migrate`, `bootstrap` or `build`.

The module prepares these boundaries:

- **Web:** Cloud Run, 1 vCPU / 256 MiB, min 0 / max 2; only web invokes API through Cloud Run IAM. Browser Firebase identity and service identity use separate headers. Public web entry defaults off.
- **API:** Cloud Run, 1 vCPU / 512 MiB, min 0 / max 2; SQL and scoped secret access. API does not receive a public invocation grant.
- **Watchdog:** separate Cloud Run identity/process, 1 vCPU / 512 MiB, min 1 / max 1, continuously allocated CPU. SQL locking coordinates overlapping revisions. Scaling to zero would break background deadline processing.
- **Database:** PostgreSQL 16 Enterprise, zonal `db-g1-small`, 10 GiB SSD with growth limit 30 GiB, backups/PITR and deletion protection. Staging uses public-IP managed connector transport without direct-IP authorized networks. API/worker/jobs share a staging SQL superuser role; split migration ownership from runtime grants before a pilot.
- **Maintenance:** migration and bootstrap jobs, one task, no automatic retries, explicit execution required. Creating the resource does not execute or verify migrations.
- **Build:** dedicated account with source-read, registry-write and log-write access; build pipeline has no deployment, SQL or runtime-secret permission.
- **Storage:** private build/evidence buckets. Evidence has versioning, seven-day soft delete and thirty-day staging lifecycle; optional API evidence permissions remain off.
- **Monitoring:** watchdog failure log metric plus watchdog/API alert policies. No notification channels supplied; policies would create console incidents only until verified channels are configured. Billing budget recipients are separate.
- **Optional services:** Gemini inference and evidence broker remain disabled; no selected/validated live model, AI Studio key, Maps or FCM implementation is implied.

## 7. Build upload protection already merged

[PR #6](https://github.com/ishaans04/CareGrid/pull/6), merged as `c710c64`, corrected `.gcloudignore` parent-directory handling that otherwise admitted local Terraform configuration/provider files. `.dockerignore` was also hardened. Both exclude Terraform cache/state/plans/tfvars/backend configuration; the cloud source allowlist admits only `infra/google/cloudbuild.yaml` from infrastructure.

The actual SDK upload enumeration at `c710c64` contained **261 files, zero forbidden files**, both Dockerfiles and `pubspec.lock`. File counts will change with application work. Re-run `gcloud meta list-files-for-upload` on the release checkout and inspect the list before Cloud Build. It must exclude `tmp`, credentials, Git metadata, original PDFs, test PEMs, caches and local configuration. No build source upload or Cloud Build execution has occurred.

## 8. Cost envelope and short credit window

On 20 November, Google's pricing catalog returned these Mumbai on-demand USD rates, before free tier, discounts or promotional credits:

| Baseline component | Rate / calculation |
| --- | --- |
| Zonal PostgreSQL Small | $0.042/hour |
| SQL SSD | $0.204/GiB-month × 10 GiB; 730-hour month conversion |
| SQL + initial disk | Approximately $0.044795/hour |
| Watchdog CPU | $0.000018/vCPU-second × 1 vCPU |
| Watchdog memory | $0.000002/GiB-second × 0.5 GiB |
| Watchdog combined | $0.0684/hour |
| SQL + watchdog | Approximately **$1.36 / 12 h**, **$2.72 / 24 h**, **$4.08 / 36 h** |

These are a partial baseline, **not a total bill or a guarantee that $5 covers the demo**. They exclude web/API activity, backups/PITR logs, builds, registry, storage operations, network, logging, secrets, maintenance jobs, optional model calls and taxes. Shared billing-account free-tier eligibility/remaining allowance was not verified. The always-on SQL/watchdog are not running yet.

Sources: [Cloud SQL pricing](https://cloud.google.com/sql/pricing), [Cloud Run pricing](https://cloud.google.com/run/pricing). Exact catalog observations and SKU IDs are retained locally in `tmp/google-setup/cost-estimate.json`, `pricing-skus.json` and `pricing-sql-storage.json`; refresh them for a later rollout.

Before 21 November credit expiry, agree the demo run window and inspect gross spend. After the demo, inventory any resources actually created and prepare a reviewed cleanup plan, accounting for deletion protection, retained backups, soft-deleted/versioned objects and artifact storage. Preserve state/recovery evidence; do not disable billing or delete the state bucket as a shortcut.

## 9. Next agent: ordered continuation

1. Fetch current `main`; inspect uncommitted work and use an isolated checkout. Check current CI, including the existing Flutter analysis failure recorded below, before deploying a release. Recheck project, billing, credits, quotas, region and live inventory. This record does not authorize replacing another agent's edits.
2. Reuse the existing project, Firebase app, provider settings, budget and state bucket. Recreate ignored inputs only if absent. Authenticate the intended operator with scoped ADC; never copy credential stores to another machine.
3. Generate **stable, securely retained** database/service secrets of at least 32 characters. Supply process-local `TF_VAR_database_password` and `TF_VAR_service_secret` from a secure store, never command-line values, tfvars, transcripts or chat. Reuse them until coordinated rotation; clear process variables afterward.
4. Follow the [foundation → jobs → services runbook](../../infra/google/README.md). Regenerate/review the foundation plan from current source, then apply if proceeding with the billable rollout. Capture actual resource creation and any policy/quota failure.
5. Review build-upload inputs. Run the prepared Cloud Build pipeline under its dedicated build account. Retain the exact source commit, build ID and immutable server/web `sha256` digests. There are no existing digests to reuse.
6. Set digest-pinned images; review/apply the jobs stage. Verify SQL schema privileges using the [explicit staging grants](../../infra/google/sql/staging-grants.sql) if required. Execute the migration job and check successful execution/logs for **all current migrations**, including response-record and campus-isolation changes.
7. If wanted, explicitly seed fictional staging data and bind real Firebase UIDs to intended memberships using the bootstrap runbook. Account for the latest campus configuration and scope. Do not use real emergency/medical data or infer a UID from an email.
8. Record the successful migration execution and its image digest before setting `migration_verified=true`. Review/apply services. Set `public_web=true` only for intentional public browser entry; retain private API IAM and application authorization. Compare actual origins with the prepared authorized domain.
9. Exercise real OAuth, membership/campus denial, private API invocation, SQL connectivity, watchdog restart/recovery and verified monitoring notification delivery. Keep Gemini/evidence disabled until their separate [model](GOOGLE-GEMINI.md) and [storage](GOOGLE-EVIDENCE.md) acceptance gates pass.
10. Update this record with live URLs, digests, migration/seed execution IDs, tested behavior, spend and cleanup status. Record identifiers and outcomes, never secret values or user tokens.

Once services are active, **do not move `rollout_stage` backward** to jobs/foundation; it would plan workload deletion. Use the runbook's `maintenance_image` sequence for later migrations and release changes.

## 10. Evidence and claim boundaries

| Evidence | What it establishes |
| --- | --- |
| Live Cloud/Firebase reads on 20 November | Project/billing linkage, budget, authorized domains/provider enabled, API availability, private state bucket and absent application resources |
| Authenticated GCS-backed plan | Current credentials can read project/backend and produce the reviewed foundation proposal; it does not exercise resource creation, runtime IAM or SQL |
| Local credential relocation checks | The scoped profile and ADC work after relocation; no credential content is part of this record |
| Upload enumeration and PR #6 | Current source filtering excluded the tested local files; recheck against each release checkout |
| Main `c710c64` CI | Google infrastructure, Google runtime, Format, Analyze and Tests workflows passed; connected MVP had passed on application commit `571b963` |
| Later main `0698ead` | Format, Google runtime, Connected MVP and Tests passed. Analyze failed in Flutter with three campus/role integration errors; see the linked run below. No infrastructure source changed in that commit |

**Existing release issue:** [Analyze run 44707914445](https://github.com/ishaans04/CareGrid/actions/runs/44707914445) failed on `0698eade09c856401c6369dfaf27aabb1afe93eb`: `caregrid_flutter/lib/src/features/admin/readiness_lab_screen.dart:433` omits required `campusId`; `features/shell/home_shell.dart:40` and `features/sign_in/sign_in_screen.dart:35` do not handle `UserRole.network`. These are application changes already on main before this documentation branch. Coordinate their correction with the application agent and recheck current CI; this document does not change application code.

No Google app deployment, real model/storage acceptance, medical action, event submission or outbound message was performed by this account-setup work. For broader implementation evidence and historical records, see [validation](VALIDATION.md), [runtime](GOOGLE-RUNTIME.md) and [solution architecture](SOLUTION-ARCHITECTURE.md).
