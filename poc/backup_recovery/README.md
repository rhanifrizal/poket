# Poket encrypted-backup recovery PoC

This isolated spike uses synthetic ledger and receipt data only. It is not the Poket application and does not handle production records or credentials.

## Phase 0 purpose

Establish whether a random data-encryption key can be recovered on a replacement device using passkey PRF where available and a user-held recovery phrase as a fallback, while Google Drive receives ciphertext only.

## Current scope

- Document a provisional, versioned envelope shape and test synthetic fixtures.
- Probe platform PRF availability only after the required relying-party setup exists.
- Prove authenticated encryption and key-wrap behavior with platform APIs in later tasks.
- Test Google Drive upload/restore only with a dedicated test account and approved OAuth configuration.

## Safety limits

No production Google Cloud/Firebase resources, credentials, user records, app identifiers, or signing materials are included. No dependencies have been installed. The envelope and algorithms remain proposals until cross-platform results and security review are complete.
