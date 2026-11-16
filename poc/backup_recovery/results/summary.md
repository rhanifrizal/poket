# Phase 0 encrypted-backup recovery summary

Date: 2026-11-16

## Decision

NO-GO for production encrypted backup, recovery claims or real financial data. The local envelope prototype demonstrates a plausible standardized-primitive flow, but platform passkey recovery, phrase UX, Drive transfer and replacement-device restore are unverified.

Keep passkey PRF as an experiment, not a required launch path. Keep the user-held recovery phrase as a proposed fallback only; this PoC modeled it as 32-byte high-entropy test material and did not implement word encoding or user recovery UX. Do not use the login password or Google account as the encryption key.

## Verified evidence

- Synthetic fixture manifest and provisional envelope schema validate with the built-in Node test runner.
- A random 256-bit data key encrypts the synthetic payload with AES-256-GCM and is wrapped into separate passkey-PRF and recovery-phrase slots using HKDF-SHA-256 plus AES-256-GCM.
- Each slot can restore the exact fixture when given the corresponding synthetic 32-byte input and correct account-binding context.
- Wrong input, wrong account binding, changed ciphertext, unsupported version and empty key slots fail closed.
- The local module has no console logging.
- Algorithms follow standardized specifications, but this envelope/protocol has not had independent review and the runtime does not guarantee erasure of internal key copies.

## Not verified

- Real WebAuthn PRF registration/assertion on web, iOS or Android.
- Same-credential PRF output portability across devices or providers.
- Human-readable recovery phrase entropy, encoding, normalization, secure display, storage guidance, rotation and loss handling.
- Native keychain/keystore behavior, browser persistence, actual OS replacement/reinstall restore, or Dart/Flutter interoperability.
- Google Drive OAuth consent, appDataFolder upload/download/delete, quota/error handling, account revocation or replacement-client restore.
- Any cloud ciphertext inspection or Firebase/Drive access-control rules.

## Exact local verification

- Node.js version: v26.3.0.
- Command: node --test poc/backup_recovery/test/*.test.mjs — 6 passed, 0 failed.
- Command: git diff --check — passed.
- No dependencies installed; no Google Cloud, Firebase, Drive, OAuth, app signing or repository remote configuration changed.
- flutter --version could not complete because Flutter attempted to write its shared SDK cache outside the authorized workspace; no SDK files were changed.

## Required next inputs and gates

1. Select a development relying-party domain and test app identities for web, iOS and Android. Required associations include the Apple webcredentials domain and Android Digital Asset Links for the final package/signing identity.
2. Approve a dedicated development Google Cloud project, Drive API enablement, OAuth test-user/client configuration and a dedicated test Google account before any cloud upload.
3. Test actual PRF behavior on the selected browsers, Apple devices and Android passkey providers. If any supported path lacks a portable PRF result, the recovery phrase must independently recover the same key or encrypted backup must be deferred.
4. Define and test generated recovery phrase entropy/encoding and key lifecycle, then review the protocol with a qualified security reviewer.
5. Prove cross-platform serialization and replacement-device restore before advertising backup.

## Standards references

- NIST SP 800-38D defines AES-GCM authenticated encryption: https://csrc.nist.gov/pubs/sp/800/38/d/final
- IETF RFC 5869 defines HKDF: https://datatracker.ietf.org/doc/rfc5869/
- W3C WebAuthn defines PRF but makes extensions optional: https://www.w3.org/TR/webauthn/
- Apple documents PRF-based symmetric keys from passkeys: https://developer.apple.com/documentation/authenticationservices/asauthorizationpublickeycredentialprfassertioninput-c.class
- Google Drive appDataFolder, OAuth scopes and API limits are documented at:
  - https://developers.google.com/workspace/drive/api/guides/appdata
  - https://developers.google.com/workspace/drive/api/guides/api-specific-auth
  - https://developers.google.com/workspace/drive/api/guides/limits
