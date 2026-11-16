# Google Drive ciphertext probe prerequisites

This PoC must use a dedicated development Google Cloud project and test account, never Poket production resources or a user's real financial data.

## Required setup before an upload test

1. Select a stable development relying-party domain and test app identities for web, iOS and Android. Their passkey associations must match.
2. Create or designate a development Google Cloud project; enable the Google Drive API.
3. Configure the OAuth consent screen with a test-user allowlist and the correct app identity/origins/redirect URIs for each client.
4. Request only the drive.appdata scope for the hidden application-specific Drive area. Firebase Authentication remains a separate identity grant.
5. Use a dedicated test Google account with available Drive quota and test clients that can sign into that same account.
6. Confirm a test-only cleanup path before upload. The probe should upload one encrypted fixture, retrieve it on a replacement client, decrypt locally, then delete it.

Do not paste OAuth client secrets, refresh tokens, service-account keys or signing secrets into the repository or chat. Mobile OAuth client identifiers and public signing fingerprints are configuration, but must still be scoped to the development project.

## Intended probe

- Upload a serialized synthetic envelope only; inspect the cloud object and verify it contains no synthetic plaintext, recovery input, PRF output or data key.
- Download the same object using a second test client, restore with the separately provided synthetic key-slot material, and compare the synthetic payload locally.
- Test missing/revoked Drive grant, missing object, quota/API error and modified ciphertext.
- Delete the test object after each run and verify cleanup.

References:
- Drive app-specific data: https://developers.google.com/workspace/drive/api/guides/appdata
- Drive API OAuth scopes: https://developers.google.com/workspace/drive/api/guides/api-specific-auth
- Drive API quotas and limits: https://developers.google.com/workspace/drive/api/guides/limits
