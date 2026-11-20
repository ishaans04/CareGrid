# Private Google evidence broker

20 November 2026. The broker, API, command UI and optional infrastructure grant are implemented. **No real Google bucket has been accessed.** Provider responses in tests are fixtures. Keep the feature disabled until the live acceptance checks below pass.

## Product and access boundary

Command can list, attach, privately view and remove small PNG/JPEG observations for a case. Medical, responder, member and admin accounts cannot call any evidence operation. Every request rechecks active SQL membership and role before loading the incident or contacting storage. This is the existing single-campus model; tenant isolation remains a separate pilot gate.

An attachment cannot set incident severity, authorize dispatch, confirm arrival/care or close a case. It is an unverified observation. Loading or failing an attachment does not set the workspace's global busy/connection state. Response controls remain available during storage work. Previews and pending results clear on case/session/view change, primary incident mutation or connection failure. A preview closes after sixty seconds; that is a UI exposure limit, not revocation of bytes already delivered or prevention of copying/screenshots.

## Storage contract

The server uses only Google's fixed `storage.googleapis.com` JSON endpoints. Cloud Run uses the API's attached identity through the metadata server; outside Cloud Run, Application Default Credentials are used. Bucket names come from validated server configuration. Callers cannot provide a bucket, URL or arbitrary object path. No public URL, signed URL, signing key or service credential reaches the browser. Reads traverse the authenticated API and gateway, whose responses use `Cache-Control: no-store`.

Objects live under `caregrid/v1/incidents/INCIDENT_ID/RANDOM_KEY`. Keys contain 256 random bits; original filenames, member names, locations and free-text captions are not added to object names/metadata. IDs are still linkable institutional data. Google metadata records schema version, incident binding and SHA-256. The stored bytes remain the original upload, preserving the digest. JPEG/PNG metadata, including possible EXIF location, is **not stripped**; use approved synthetic images for staging.

Uploads accept canonical base64 for at most 512 KiB. Header/dimension checks permit PNG and baseline/extended/progressive JPEG with positive dimensions, at most 4096 pixels per side and four megapixels. These checks are not full image decoding, malware scanning, content review or provenance verification. Corrupt bodies can still pass a header check and fail to display. Approved ingest/scanning and metadata policy are prerequisites for real evidence use. SVG, HTML, PDF and video are unsupported.

Multipart uploads use `ifGenerationMatch=0`, so this code cannot silently overwrite a live object. Reads verify the incident binding, media type, size, generation, metageneration and SHA-256. Media retrieval is conditional on the metadata's generation and metageneration; mismatched bytes never reach the browser. SHA-256 establishes consistency with recorded metadata, not authenticity of the original observation. Lists are restricted to the incident prefix, with at most fifty objects per page and an explicit next-page cursor.

Removal checks the selected generation and freshly read metageneration and deletes the **live** object. It does not request deletion of an arbitrary historic version. The staging bucket has versioning, explicit seven-day soft-delete retention and the existing thirty-day lifecycle rule. Removed or expired objects can remain as noncurrent/soft-deleted versions. The UI explicitly says removal is not permanent erasure. Real retention, legal holds, purge/restore procedures and storage costs require institution-specific decisions.

## Failure and audit behavior

Each operation has one total eight-second budget including credential acquisition and response reading. Two operations per API process bound concurrent buffering. Metadata responses are limited to 128 KiB; image bytes to 512 KiB. Redirects and unexpected provider responses are refused. There are no application mutation retries. These are process limits, not fleet-wide quotas, a storage budget or a distributed availability guarantee.

The internal Serverpod JSON body cap is 710,000 bytes to accommodate base64. The gateway permits that larger body only for `evidence/upload`; every other RPC retains its 32 KiB limit. Clients must refresh after an uncertain upload/removal. An upload can succeed at Google before a timeout or lost response, and a manual retry can create a duplicate random-key object. Reconciliation and distributed idempotency/outbox are still pilot gates.

SQL audit records intent before external reads/mutations and completion afterward. Completion records identify the object, generation and, for uploads/reads, digest. They do not store image bytes, original filenames, tokens or provider error bodies. Read bytes are returned only after the completion audit succeeds. SQL audit and GCS writes are **not one atomic transaction**: a failed completion audit can follow a successful upload/removal. Inspect storage and audit before repeating an uncertain action. Project logging, Google Data Access logs, access retention and incident response require live review; application tests do not establish organization-wide logging policy.

## Configure after a project exists

Leave `enable_evidence=false` in [the Terraform module](../../infra/google/README.md) until acceptance. Opt-in adds a custom role containing only `storage.objects.create`, `get`, `list` and `delete`, bound to the private evidence bucket for the API identity. Web, watchdog, build and maintenance identities receive no evidence grant. The role cannot change bucket configuration, ACLs or object metadata. Its create/delete permissions could overwrite objects outside this application's guarded path if the identity were compromised; application preconditions are not an IAM immutability policy.

Terraform supplies `CAREGRID_EVIDENCE_ENABLED=true` and `CAREGRID_EVIDENCE_BUCKET` only to the API. Missing/invalid configuration produces an explicit disabled/unavailable panel; local storage is not silently substituted. No SQL table or database migration is required for attachment metadata. The inherited Serverpod Cloud/database storage registration is separate and is not used by this broker.

## Live acceptance and limits

1. Apply to a synthetic staging project, verify the exact private bucket and API identity, and prove every other service identity is denied object access.
2. Attach a small synthetic image through the real browser/API/GCS path. Verify original-byte digest, list pagination, private read, no-store headers, audit entries and absence of object URLs/credentials in browser responses.
3. Deny all four endpoints for signed-out and each non-command role, disabled/revoked users, nonexistent incidents and guessed cross-case keys. Add tenant tests before supporting multiple campuses.
4. Inject changed generation/metageneration, altered metadata/bytes, 403/404/412/429/5xx, oversized responses and credential/network timeout. Confirm primary response actions remain usable and uncertain mutations are reconciled before retry.
5. Verify active removal, retained versions, soft-delete restore and eventual lifecycle behavior with the institution's approved policy. Review payload logging, quotas/billing and a scanned/quarantined ingest design before real personal data.

Local adapter/endpoint tests and the separately labelled storage UI preview cannot prove these Google controls are operating. No live camera upload, medical evidence validation or forensic chain-of-custody system is claimed.

Official contracts: [multipart object upload](https://docs.cloud.google.com/storage/docs/json_api/v1/objects/insert), [metadata/media reads](https://docs.cloud.google.com/storage/docs/json_api/v1/objects/get), [generation preconditions](https://docs.cloud.google.com/storage/docs/request-preconditions), [prefix/paginated listing](https://docs.cloud.google.com/storage/docs/json_api/v1/objects/list), [active object deletion](https://docs.cloud.google.com/storage/docs/json_api/v1/objects/delete), and [soft-delete semantics](https://docs.cloud.google.com/storage/docs/soft-delete). Reviewed 20 November 2026; live behavior remains unverified.
