# Demo operations · 20 November 2026

This record covers the finalized UI release on `caregrid-staging`. The application remains unchanged from `3b84a33`; the operational fixes below preserve its role model. Use the [public landing page](https://caregrid-demo-web-959096744456.asia-south1.run.app/) and [connected console](https://caregrid-demo-web-959096744456.asia-south1.run.app/console).

## Google sign-in and roles

Both teammates already had enabled Firebase users with the Google provider. The missing step was linking those identities to the existing SQL memberships, using the private bootstrap job. This is separate from project IAM permissions.

| Teammate | Membership | Successful private job execution |
| --- | --- | --- |
| Ishaan Sharma | `niet.command` — NIET command | `caregrid-demo-bootstrap-6scl4` |
| Hriday Vig | `niet.admin` — NIET administrator | `caregrid-demo-bootstrap-kvr7x` |

Open `/console`, reload, and sign in with the corresponding Google account. The UI displays the **synthetic membership persona**, rather than the Google account's personal name. An administrator sees readiness, policies and audit; command sees incident ownership and dispatch. These different screens are expected.

**Existing campus-label issue:** `/api/config` still reports the gateway's shared `Meridian Demo Campus` label. The finalized frontend uses that static label in its header, including for NIET memberships. The label does not choose the SQL campus or grant access; membership and campus-scoped endpoints do. Verify the NIET twin after sign-in rather than using the header as authorization evidence. Dynamic campus labelling needs an application follow-up; this task preserved the user's explicit instruction to leave the finalized application unchanged.

One Google identity remains linked to one membership. A different identity cannot overwrite an already bound membership. No PIN login or role picker was enabled on the public deployment. Both teammates explicitly chose to retain these two roles for the demo.

The previously quoted `tmp/google-setup/bind-user.sh` was an ignored machine-local helper and was unavailable here. Its durable replacement is [scripts/bind-google-user.ps1](../../scripts/bind-google-user.ps1). From a checkout with PowerShell and an authenticated Google Cloud SDK:

```powershell
# Set CLOUDSDK_CONFIG first if you use a separate deployment profile.
./scripts/bind-google-user.ps1 -ListRoles
./scripts/bind-google-user.ps1 -Email teammate@example.com -Handle niet.command -CheckOnly
./scripts/bind-google-user.ps1 -Email teammate@example.com -Handle niet.command
```

The first command checks an existing Google identity without mutation. The second waits for the job's successful execution, rather than treating a submitted job as a completed bind. It uses REST argument arrays to avoid the Windows `.cmd` comma-argument failure. Tokens remain in process memory. The script does not create users, grant Google Cloud IAM roles or seed/reset the database. Existing membership handles are defined in [the campus seeds](../../caregrid_server/lib/src/seed/campus_seed.dart), including NIET's [eight synthetic roles](../../caregrid_server/lib/src/seed/niet_seed.dart).

## Preserve the live Terraform deployment

Both ignored local `terraform.tfvars` files were stale: the root checkout said `foundation`; the deployment worktree said `jobs` and referenced the previous web image. They were corrected to:

```hcl
rollout_stage      = "services"
migration_verified = true
public_web         = true
```

They also retain the current immutable images:

```hcl
server_image = "asia-south1-docker.pkg.dev/caregrid-staging/caregrid-demo-images/server@sha256:9f06dfa7684e2827d7775e4e5db00c452180551993e051edd77586426bab03ca"
web_image    = "asia-south1-docker.pkg.dev/caregrid-staging/caregrid-demo-images/web@sha256:735ef85169a16cdd175e7af68086ac76a80b56a3c6a8197632314bead720cd05"
```

After refreshing live state, the corrected configuration produced **no changes**. Do not apply an old saved plan or copy the new-environment example over this existing staging configuration. Keep stable secret inputs, the current GCS backend and the notification channel IDs. Review the entire plan before any future apply; moving the rollout stage backward removes workloads.

The final refreshed plan **after** attaching the team alert channels also reported **no changes**.

## Billing and alerts

**21 November replacement account:** the project is now linked to `011742-6AEDED-1EC8D8` (GDP Event Credit: Buildathon day 2), with billing enabled. The previous account was closed. The existing $5 gross-cost budget and both team email channels were reproduced on the replacement account; budget ID `4de3c550-4d89-445a-ac50-3317addbbf3d`. This is not a statement of the new credit balance or expiry. See the [recovery record](GOOGLE-PROVISIONING.md#billing-recovery--21-november-2026) for the dated service status. The observations below describe the former account.

The owner account can access billing. At approximately 22:35 IST on 20 November, the Google Cloud console showed **$4.85 remaining (97%)** of the $5 GDP credit, with an **end date of 21 November 2026**. The regular monthly report showed $0.00 net and $0.08 Cloud Run usage offset by savings. These views update at different times; neither proves all incurred usage has been posted. The console did not show a precise expiry timestamp.

Cloud SQL and the continuously allocated watchdog keep billing while idle. The previously calculated gross SQL/watchdog baseline is approximately **$0.113195/hour ($2.72/day)** before applicable credits/free allowances, excluding builds, web/API requests, storage, backups, logging and optional AI. This is a planning baseline, not a bill or guaranteed credit lifetime. Credit expiry can arrive before exhaustion. The $5 budget sends alerts; it does not stop services or cap charges.

Both requested team email channels were created and linked to the existing $5 budget (actual 50%, 80%, 100%; forecast 100%). The API 5xx and watchdog-failure policies use the same channels. Channel IDs and recipients are kept in ignored local configuration and Cloud Monitoring, rather than hardcoded into the repository. See [Google's budget recipient documentation](https://docs.cloud.google.com/billing/docs/how-to/budgets-notification-recipients) for delivery delays.

**Delivery verified:** a separate, explicitly labelled INFO-log canary opened alert `0.of8rcyxiiufv` at **23:04:55 IST**. The team confirmed receipt in **both inboxes**. No API/watchdog failure was induced. The temporary test policy was deleted afterward; the two real failure policies remain attached to both channels. This establishes the shared notification delivery path, not the behavior of every failure condition. The test followed [Google's log-alert testing procedure](https://docs.cloud.google.com/logging/docs/alerting/log-based-alerts).

Check [Billing → Credits](https://console.cloud.google.com/billing/01834C-FC917A-2D73CC/credits?project=caregrid-staging) and [Reports](https://console.cloud.google.com/billing/01834C-FC917A-2D73CC/reports?project=caregrid-staging) again before the demo and before expiry. Decide explicitly whether to retain the demo afterward; follow the [cleanup runbook](../../infra/google/README.md) when it is no longer needed. This work did not stop or delete any live resource.

## Branch cleanup

`duality/google-staging-deployment` was deleted remotely and locally. Its final patch matched the rewritten commit already on `main` (stable patch IDs matched), and its worktree had no tracked changes. The old deployment worktree was detached at current `main`, preserving its ignored local settings. Published `main` history was not rewritten.

## Acceptance boundaries

- Successful binding jobs establish membership linkage. The teammates still need to reload and exercise the browser Google sign-in with their own accounts; a binding alone does not prove the popup/redirect experience.
- Local multi-role and campus-isolation tests use the real Serverpod/PostgreSQL backend and synthetic accounts. They do not replace a two-person live Google-token acceptance check.
- A warm watchdog container and absence of error logs do not establish incident recovery after a restart. Keep that live acceptance gate explicit.
- Both inboxes received the synthetic alert, as confirmed by the team. Actual API-error and watchdog-error conditions were not deliberately triggered; the delivery test used a separate policy with the same channels.
- Gemini and private evidence storage remain disabled in the live configuration. Browser fixtures and mocked provider tests must not be described as live model/storage evidence.
