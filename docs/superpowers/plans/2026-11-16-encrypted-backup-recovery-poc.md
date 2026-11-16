# Encrypted Backup and Recovery PoC Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Determine whether Poket can securely encrypt a backup and restore it on replacement devices across iOS, Android and web, with passkey PRF where supported and a recovery phrase fallback.

**Architecture:** Keep this as an isolated Phase 0 spike, not a Flutter product scaffold. First prove crypto/key-wrap and recovery behavior using fake data locally; then verify platform passkey support and Google Drive ciphertext upload/restore only where the required RP, signing and OAuth configuration exists. No real user data or production secrets.

**Tech Stack:** Existing installed platform SDKs; WebAuthn PRF and Apple AuthenticationServices PRF for capability probes; reviewed platform cryptography APIs for local test vectors. No new dependencies until compatibility and security review.

**Spec:** `docs/ADRs.md` ADR-005, `docs/SECURITY_PRIVACY.md` sections 3–6, `docs/ARCHITECTURE.md` section 7, `docs/ROADMAP.md` Phase 0.

## Global Constraints

- Encrypt financial records and receipt bytes on the client; cloud receives ciphertext only.
- Generate a random data-encryption key; neither login password nor Google account is the encryption key.
- Never upload plaintext keys, recovery phrases, credentials or real user data.
- Firebase Authentication remains identity only; Drive authorization is a separate grant.
- Do not create custom cryptographic primitives or claim platform support without an observed test.
- Do not scaffold the Poket Flutter application or add dependencies in this PoC.

## Review Focus

- PRF unsupported or silently ignored: detect absent output and use the explicit recovery-phrase path.
- Different passkey on a replacement device: prove the selected credential can reproduce the required wrapping key or fail safely.
- Recovery phrase typo/format errors: reject without corrupting or replacing the wrapped data key.
- Ciphertext tampering, truncation or wrong key: authenticated decryption must fail without returning partial plaintext.
- Account sign-in without Drive authorization or key recovery: explain the separate steps; never imply authentication recovered the key.

---

### Task 1: Build local cryptographic envelope test vectors

**Files:**
- Create: `poc/backup_recovery/README.md`
- Create: `poc/backup_recovery/vectors/README.md`
- Create: `poc/backup_recovery/vectors/manifest.json`
- Create: `poc/backup_recovery/vectors/expected-results.md`

**Interfaces:**
- Consumes: fake JSON ledger fixture and fake receipt bytes created in the PoC only.
- Produces: versioned envelope fields and expected success/failure cases for later platform probes.

- [ ] Define a minimal versioned envelope carrying algorithm identifiers, salt/nonce, wrapped random data-encryption key, ciphertext and authentication tag; leave algorithm selection to maintained platform primitives and document exact choices before coding.
- [ ] Define expected tests for successful round trip, modified ciphertext/tag, wrong wrapping key, malformed envelope and unsupported version.
- [ ] Confirm fixtures contain only synthetic values and add a simple scan/assertion preventing realistic user data or secrets.
- [ ] Review the envelope and cryptographic choices against OWASP MASVS Crypto and NIST key-management guidance before using them beyond this PoC.

### Task 2: Probe passkey PRF by launch platform

**Files:**
- Create: `poc/backup_recovery/web/README.md`
- Create: `poc/backup_recovery/ios/README.md`
- Create: `poc/backup_recovery/android/README.md`
- Create: `poc/backup_recovery/results/passkey-prf-matrix.md`

**Interfaces:**
- Consumes: documented PRF input label and a non-sensitive test salt from Task 1.
- Produces: per-platform registration/assertion result, feature availability, stable same-credential output check and failure behavior.

- [ ] Record prerequisites for a real test: HTTPS/RP domain for web, Apple associated domain and entitlement for iOS, Android relying-party association and signing identity, and suitable passkey providers/devices.
- [ ] Verify web PRF registration and assertion output; record browser, OS and authenticator, including the case where an extension is ignored.
- [ ] Verify Apple AuthenticationServices PRF registration and assertion on an available iOS device/simulator and document limitations of simulator-only evidence.
- [ ] Investigate Android Credential Manager and provider support. If no supported public API returns PRF output, record this as unsupported for the launch design rather than implementing a custom extension.
- [ ] Confirm equal PRF input and same credential yields the expected repeatable output where the platform supports it; never log the output.

### Task 3: Verify recovery phrase and encrypted restore behavior

**Files:**
- Create: `poc/backup_recovery/results/recovery-tests.md`
- Create: `poc/backup_recovery/results/envelope-tests.md`

**Interfaces:**
- Consumes: versioned envelope and supported wrapping paths from Tasks 1–2.
- Produces: evidence that synthetic data restores with the intended key path and fails closed otherwise.

- [ ] Implement only the smallest local harness needed to test a recovery phrase wrapping the random data-encryption key using a reviewed, maintained implementation; document the concrete KDF and parameters before use.
- [ ] Test restore on a replacement installation with the original device key absent; cover correct phrase, incorrect phrase, malformed phrase, tampered ciphertext and wrong account metadata.
- [ ] Verify no logs or result files contain plaintext keys, phrase contents, decrypted fixture payloads or PRF outputs.
- [ ] Store command output summaries and platform versions, not secrets or actual backup contents.

### Task 4: Probe Google Drive ciphertext backup and restore

**Files:**
- Create: `poc/backup_recovery/drive/README.md`
- Create: `poc/backup_recovery/results/drive-tests.md`

**Interfaces:**
- Consumes: synthetic authenticated ciphertext envelope from Task 3.
- Produces: Drive app-data upload/download/delete result and confirmed replacement-device restore path.

- [ ] First document OAuth consent, app verification, `drive.appdata` scope, app registration and quota prerequisites; do not create or modify production cloud resources without explicit approval.
- [ ] Once approved credentials/configuration exist, upload only fake ciphertext to a test account’s app data area, retrieve it on a replacement test client, decrypt locally, then delete it.
- [ ] Verify missing Drive grant, revoked grant, quota/error response, missing file, changed ciphertext and wrong recovery factor fail with understandable outcomes.
- [ ] Record whether any provider can see plaintext payload or key material; expected result is ciphertext and minimal routing metadata only.

### Task 5: Produce Phase 0 decision record

**Files:**
- Create: `poc/backup_recovery/results/summary.md`
- Modify: `docs/ADRs.md`
- Modify: `docs/SECURITY_PRIVACY.md`
- Modify: `docs/ROADMAP.md`

**Interfaces:**
- Consumes: measured results and limitations from Tasks 1–4.
- Produces: go/no-go recommendation, exact tested platform matrix, blockers, and minimum supported recovery flow.

- [ ] Summarize only verified results, exact commands/tool versions and untested platform cases.
- [ ] Recommend PRF primary only if portable key recovery is proven on the supported target/provider matrix; otherwise specify recovery phrase as the dependable launch path or defer encrypted backup.
- [ ] Require security review before any production backup claim or live data use.

## Execution Notes

- Do not commit or push until the user reviews the completed PoC and approves the changes.
- If web, iOS or Android relying-party setup requires new domains, signing identifiers, OAuth clients, or user-owned credentials, stop at the documented prerequisite and request the specific value/approval.
- Current Flutter SDK invocation fails while trying to write outside the workspace cache; do not attempt to modify the shared SDK as part of this plan.
