# Technical Architecture — Poket

## 1. Architectural goals
- Offline-first for core money tracking.
- Clear separation of UI, business rules and infrastructure.
- Financial calculations are deterministic and testable.
- Tax rules can be updated independently of app releases where safe, while retaining version history.
- Cloud sync, if enabled, cannot read financial content.
- Launch on iOS, Android and web with one logical ledger and responsive/adaptive layouts.
- A public, searchable feature page leads into the authenticated Flutter web application.

## 2. Proposed stack
| Concern | Proposed choice | Validation required |
|---|---|---|
| UI | Flutter | Confirm installed stable SDK |
| Language | Dart | Match Flutter SDK |
| State / DI | Riverpod | Choose current compatible version |
| Navigation | Custom Router / Navigator | Deep-link and web history tests |
| Local DB | Drift | Native and web backend feasibility |
| Native DB encryption | SQLCipher-backed SQLite | Plugin maintenance, platform support, migration |
| Web persistence | Separate encrypted browser-storage adapter (IndexedDB is a candidate) | Browser support, key handling, threat model |
| Auth | Firebase Authentication | Identity only; not data encryption or backup-key recovery |
| Backup storage | Google Drive `appDataFolder` | Client-side encryption, Drive OAuth, user quota handling, key recovery and portable restore PoC |
| Live sync | Not in launch scope | Separate protocol and security design if later approved |
| Receipts | App-private local files, encrypted at rest | iOS/Android/web file handling |
| OCR | On-device OCR where available | Accuracy, language, offline support, privacy |
| Localisation | Flutter gen-l10n | English and Bahasa Malaysia initial |
| Tests | flutter_test + unit/integration tests | CI execution |

Do not assume one database encryption package supports all platforms. Hide persistence behind interfaces and use platform-specific adapters only where necessary.

## 3. Layered architecture
Feature-first layout with layers inside each feature:

```text
lib/
  app/
    app.dart
    bootstrap/
    router/
    theme/
    localisation/
  core/
    errors/
    money/
    dates/
    security/
    database/
    platform/
    utils/
  features/
    dashboard/
      data/
      domain/
      presentation/
    transactions/
      data/
      domain/
      presentation/
    wallets/
      data/
      domain/
      presentation/
    tax_relief/
      data/
      domain/
      presentation/
    receipts/
      data/
      domain/
      presentation/
    settings/
      data/
      domain/
      presentation/
```

Responsibilities:
- Presentation: screens, widgets, view models/notifiers, UI state.
- Domain: entities, value objects, repository contracts, use cases and pure rules.
- Data: repository implementations, database mappings, DTOs and data sources.
- Core: cross-feature primitives only. Avoid turning core into a dumping ground.

## 4. Dependency direction
Presentation -> Domain  
Data -> Domain  
App composition root wires implementations to domain interfaces.  
Domain must not import Flutter UI, Firebase, Drift, camera or OCR SDKs.

## 5. Key domain modules
- Money: amount, currency, currency exponent, formatting and arithmetic.
- Wallets: wallet metadata and opening/current balance.
- Transactions: income, expense, transfer and transaction lifecycle.
- Categories: built-in and user-defined categories.
- Reports: date-range aggregates and category summaries.
- Tax relief: assessment years, rule definitions, screening, review and evidence.
- Receipts: encrypted file lifecycle, metadata and OCR suggestions.
- Backup (launch): encrypted backup creation, versioning, restore and key recovery.
- Sync (later): device identity, encrypted change envelopes, conflict handling.

## 6. Data flow example: create expense
1. UI validates required input and calls `CreateTransaction`.
2. Use case validates wallet, amount, currency and transaction invariants.
3. Repository commits transaction atomically to local DB.
4. Tax screening service evaluates the expense against the selected assessment-year rule set.
5. Screening result is persisted separately with rule version and reasons.
6. UI displays saved transaction; any tax follow-up is non-blocking.
7. Sync queue may later encrypt and enqueue an opaque change envelope.

## 7. Backup and later sync architecture
- Launch backup: encrypt records and receipt content on the client before writing an opaque backup file to the user's Google Drive `appDataFolder`.
- Firebase Authentication remains the Poket identity provider. Request Google Drive authorization separately and use the narrow `drive.appdata` scope; Google sign-in alone does not grant Drive access.
- The Drive app-data folder is hidden from the user's Drive UI and uses the user's Drive storage quota. Handle quota exhaustion and deletion/revocation explicitly.
- The provider must receive ciphertext only; define key creation, account-based recovery, backup versioning, deletion and restore before implementation.
- Prove portable restore among iOS, Android and web onto a replacement device without the original device, using the same linked Google account.
- Firebase may store a wrapped key envelope only if the wrapping key remains unavailable to Firebase; never upload a plaintext data-encryption key.
- iCloud support is future scope and must use the same portable backup format if added.
- Validate a separate browser storage and key strategy; do not assume native keystore protections or SQLCipher apply to web.
- Do not treat account authentication or platform cloud account security as a substitute for application-level encryption.
- Live sync is later scope and needs its own device enrolment, conflict and revocation design.

For later live sync:
- Encrypt payload on client before upload.
- Backend stores opaque ciphertext, schema/version metadata and minimal routing fields.
- No server-side indexing of merchant, amount, category, notes or receipt text.
- Use idempotent operation IDs and versioned envelopes.
- Define conflict resolution per entity; never silently overwrite a financial transaction.
- Design device enrolment, key recovery, rotation, revoked devices and account deletion before release.
- Evaluate passkey PRF for wrapping a random data-encryption key, with a user-held recovery phrase fallback. Do not promise recoverability until replacement-device recovery is tested on every launch platform.
- Sync is disabled until a security review and cross-device PoC pass.

## 8. Platform strategy
- Phase 0: inspect actual development machine and Flutter environment.
- Phase 1: local-first ledger MVP on iOS, Android and web after platform-specific Phase 0 validation.
- The public feature page is a searchable web entry surface; the Flutter web app hosts authenticated finance features.
- Encrypted Google Drive backup and restore are required across all three launch platforms after Phase 0 security and recovery validation. iCloud backup is deferred.
- Live multi-device sync is later scope, after a separate threat-model review.

## 9. Quality attributes
- Correctness: integer money, deterministic tax rules, atomic writes.
- Privacy: data minimisation, no plaintext cloud sync.
- Reliability: offline operation, migrations, backup/restore tests.
- Usability: low-friction transaction capture and understandable tax outcomes.
- Maintainability: feature boundaries, testable domain, limited dependencies.
