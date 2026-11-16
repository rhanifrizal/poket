# Security & Privacy — Poket

## 1. Data classification
Highly sensitive:
- transaction amounts, dates, merchants, notes and categories;
- wallet/account names and balances;
- receipts, OCR output and tax evidence;
- authentication identifiers and device metadata.

## 2. Threat model
Consider:
- lost or stolen unlocked/locked device;
- malicious or compromised app dependencies;
- accidental logging, analytics or crash-report leakage;
- cloud/backend compromise;
- insecure backups and exports;
- cross-device sync conflict or replay;
- key loss, account recovery and device revocation;
- web browser profile compromise and XSS.

## 3. Required controls
- Local database encryption on supported native platforms, validated by PoC.
- Encrypt receipt files at rest; store keys in platform secure storage.
- Web must use an independently reviewed browser storage/key strategy; do not assume native SQLCipher or mobile keystore protections apply.
- Use TLS for network transport.
- Use Firebase Authentication for identity only; keep it separate from financial-data encryption and backup-key recovery.
- Google Drive is the launch backup destination. Encrypt records and receipt content on the client before upload; Google Drive stores ciphertext only.
- Request only the narrow Google Drive `drive.appdata` OAuth scope for the app-specific Drive area. Firebase Authentication and Drive authorization are separate grants.
- Firebase may store a wrapped key envelope only if it cannot unwrap the key; never store a raw data-encryption key in Firebase.
- Minimise analytics; never send transaction values, merchant names, tax status or OCR text.
- Redact sensitive fields from logs and crash reports.
- Lock sensitive screens after configurable inactivity; support device biometrics where appropriate.
- Offer an optional user-controlled app lock; do not require it for normal use.
- Encrypt all financial records and receipt content on the client before cloud backup. Cloud backup storage must contain ciphertext only.
- Use least-privilege backend rules and test them.
- Protect exports; warn users that exported CSV/PDF files are unencrypted unless user chooses a protected format.
- Provide account deletion and local data deletion flows with clear consequences.

## 4. Key management questions to resolve
Before encrypted backup and restore:
- Who generates the data-encryption key?
- How is the backup key made recoverable after loss of the original device?
- How does Google-account authorization enable key recovery without giving the server the decryption key?
- Does the backup/restore PoC prove portability across iOS, Android and web?
- How are Drive app-data deletion, Google account revocation, user storage quota exhaustion and backup lifecycle handled?
- How are backups versioned, expired and deleted?

Before later live sync:
- How is the key safely provided to an additional device?
- How does a new device join?
- What happens if a user loses every enrolled device?
- Is recovery user-held, trusted-device-assisted or escrowed?
- How are keys rotated and devices revoked?
- How are old encrypted backups migrated?
- What data remains after account deletion?

Do not invent a custom cryptographic protocol. Prefer well-reviewed, maintained primitives and obtain security review.

## 5. Security acceptance criteria
- Automated tests confirm no sensitive fields are emitted to logs.
- Database and receipt storage are encrypted at rest on supported native targets.
- Web storage design passes a documented security review before release.
- Backend cannot decrypt backed-up or synced financial payloads.
- Google Drive and Firebase cannot read financial records or receipt content; a restore test from a replacement device succeeds without the original device.
- No secrets are committed.
- Authenticated users cannot access another user's ciphertext objects.
- Logout and account deletion behavior is documented and tested.
- A restore test proves that encrypted backup recovery works before backup is advertised.

## 6. Release gate
No production encrypted backup or cloud receipt backup until the implementation, key recovery, restore flow and threat model have been reviewed and tested. No live sync or marketing claim such as “end-to-end encrypted” until its protocol has also been independently reviewed and tested.
