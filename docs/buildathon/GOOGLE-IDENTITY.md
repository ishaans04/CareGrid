# Google identity and membership

Updated 20 November 2026. This code is implemented and tested with generated RSA fixtures and local PostgreSQL. No Firebase project, real OAuth exchange or deployed Google service has been tested yet.

## Request path

```mermaid
sequenceDiagram
    participant User as Browser
    participant Firebase as Firebase Authentication
    participant Web as Cloud Run web gateway
    participant API as Private Cloud Run API
    participant SQL as Cloud SQL membership
    User->>Firebase: Google popup sign-in
    Firebase-->>User: Firebase ID token
    User->>Web: Authorization: Firebase bearer
    Web->>API: Authorization: Firebase bearer<br/>X-Serverless-Authorization: web service ID token
    Note over API: Cloud Run IAM checks the service token.<br/>Dart verifies the Firebase token.
    API->>SQL: Find UID; check disabled flag and revocation cutoff
    SQL-->>API: Existing membership and database role
    API-->>User: Role-filtered result through gateway
```

The browser bundles Firebase's modular SDK from pinned npm dependencies. Authentication uses `inMemoryPersistence` from initialization. Refresh tokens and ID tokens are not stored in localStorage, IndexedDB or gateway cookies; a reload requires another sign-in. JavaScript still has access to the in-memory token, so this does not eliminate XSS risk. The SDK refreshes tokens during the open session.

The stateless cloud gateway uses its attached Google service account through Application Default Credentials. It obtains an audience-bound service ID token for the fixed API origin. Service and user credentials use separate headers, following [Cloud Run's documented contract](https://docs.cloud.google.com/run/docs/authenticating/service-to-service). A metadata failure rejects the request rather than forwarding anonymously. Cloud replicas share no gateway user-session map.

The API uses Google's fixed certificate endpoint and verifies RS256 signature, key ID, exact project audience/issuer, subject, expiry, issue time and authentication time. Token size, certificate request time, cache lifetime and refresh frequency are bounded. Expired certificates fail closed during an outage. This follows the [third-party Firebase verification flow](https://firebase.google.com/docs/auth/admin/verify-id-tokens), using `dart_jsonwebtoken`; it is not the Firebase Admin SDK.

Authorization comes only from `app_user`. A valid Google account cannot self-enrol or choose a role through email/claims. Disabled memberships fail on the next API request. `tokensValidAfter` requires later Firebase **reauthentication**, rather than a token refresh from the old login. UID and cutoff are server-only protocol fields. Tenant-bearing Firebase tokens are rejected: this increment supports one Firebase project/campus, not multi-tenant isolation.

## Project setup once a project exists

1. Add Firebase to the chosen Google Cloud project and register a web app. Enable Google as an Authentication provider. Configure support email, OAuth consent and test users as required by the project's publishing status.
2. Add the exact deployed web hostname to Firebase Authentication's authorized domains. Keep the SDK `authDomain` as `PROJECT_ID.firebaseapp.com`. Follow Firebase's provider handler/redirect settings; do not add wildcard domains.
3. Set `FIREBASE_PROJECT_ID` on the API. Set that same project ID, `FIREBASE_WEB_API_KEY`, `FIREBASE_WEB_APP_ID`, exact HTTPS `CAREGRID_WEB_ORIGIN` and fixed HTTPS `CAREGRID_API_URL` on the gateway. Web configuration is public application configuration, never service-account JSON or refresh tokens. Apply supported API-key restrictions after checking Firebase's required APIs and flow.
4. Grant the web runtime identity `roles/run.invoker` on the API service. Keep API and watchdog without `allUsers` invoker bindings. Deliberately decide whether the web entry is publicly reachable; membership remains required for data access.
5. Build immutable images. Run the additive migration through the private maintenance job before serving the new API revision. Do not point production at an unmigrated schema.
6. For synthetic staging only, explicitly execute the bootstrap seed job and bind intended users to existing role handles. Verify each role in separate temporary browser profiles.

References: [Google sign-in](https://firebase.google.com/docs/auth/web/google-signin), [persistence](https://firebase.google.com/docs/auth/web/auth-state-persistence), [CSP requirements](https://firebase.google.com/docs/web/environments-js-sdk). Cloud CSP permits the Google API loader at `apis.google.com`; application scripts are bundled locally. The gateway sets a popup-compatible opener policy. Mobile and institutional browser behavior require live testing.

## Privileged bootstrap and revocation

The server image exposes private job commands, **not HTTP endpoints**:

```text
bootstrap seed-synthetic
bootstrap bind HANDLE FIREBASE_UID
bootstrap disable HANDLE
bootstrap enable HANDLE
bootstrap revoke HANDLE
```

`seed-synthetic` also requires `CAREGRID_BOOTSTRAP_SYNTHETIC=true`. It creates fictional Meridian campus role handles; production never seeds automatically. Seeding is a staging convenience, not a transactional import/migration mechanism. Campus onboarding requires a reviewed import workflow.

Run argument overrides on the private Cloud Run bootstrap job, with the same server-image digest as the API. The job identity needs SQL and scoped database-secret access. The operator needs job execution/override permission; ordinary app users must not receive it. Job metadata can expose **UIDs and handles** to project operators. Never pass bearer tokens or passwords as arguments.

Obtain the UID from the intended Firebase user record, not an email guess. Choose the existing handle's role before binding. No deployed public account listing exists. A binding cannot replace an existing UID. A row lock serializes changes to one membership; the unique UID index prevents one identity receiving multiple memberships. Bind/disable/enable/revoke and their audit row share a transaction.

SQL revocation is the immediate application control. Firebase account deletion/disablement is not queried on every request; an already issued token can remain valid until expiry. Disable/revoke SQL membership when immediate CareGrid denial is required. A cutoff requires reauthentication. Identity recovery/remapping is deliberately absent from convenience RPCs.

## Verification and remaining gates

- RSA fixtures cover signature tampering, algorithms, project/time/tenant claims, certificate caching/rotation, concurrent refresh and outage recovery. Fixture keys have no Google privileges and are excluded from images.
- PostgreSQL tests cover unbound identities, SQL role authority, protocol redaction, disable/enable, revocation, refused/competing bindings, audit and seed opt-in.
- Node tests cover separate IAM/user headers, stateless replicas, deployed PIN/simulation denial, exact origins and metadata failure.
- Browser checks cover the bundled Google-entry **configuration preview** and the real local workflow. The preview does not sign into Google.
- Linux CI builds both images and checks migration, custom ports, bootstrap commands, health and deployed sign-in surfaces using synthetic configuration.

Before a cloud demo: verify real sign-in/refresh/sign-out/reauthentication, unbound-account denial, immediate membership disablement, IAM rejection outside the gateway, wrong-project/expired-token rejection, and authorized-domain/CSP behavior on the exact URL. App Check, institutional MFA, multi-campus isolation, external audit retention and security review remain separate gates. See [runtime](GOOGLE-RUNTIME.md) and [validation](VALIDATION.md).
