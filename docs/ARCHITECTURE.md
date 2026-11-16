# Technical Architecture — Poket

## 1. Architectural goals
- Offline-first for core money tracking.
- Clear separation of UI, business rules and infrastructure.
- Financial calculations are deterministic and testable.
- Tax rules can be updated independently of app releases where safe, while retaining version history.
- Cloud sync, if enabled, cannot read financial content.
- Support Android and iOS first; web/PWA only after storage, encryption and file handling are proven.

## 2. Proposed stack
| Concern | Proposed choice | Validation required |
|---|---|---|
| UI | Flutter | Confirm installed stable SDK |
| Language | Dart | Match Flutter SDK |
| State / DI | Riverpod | Choose current compatible version |
| Navigation | Custom Router / Navigator | Deep-link and web history tests |
| Local DB | Drift | Native and web backend feasibility |
| Native DB encryption | SQLCipher-backed SQLite | Plugin maintenance, platform support, migration |
| Web persistence | Separate encrypted IndexedDB adapter | Browser support, key handling, threat model |
| Auth | Firebase Authentication | Identity only; not data encryption or backup-key recovery |
| Sync | Custom encrypted payload protocol over a backend | Security design and PoC before implementation |
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
- Launch backup: encrypt records and receipt content on the client before writing a backup to the approved Google/iCloud storage path.
- The provider must receive ciphertext only; define key creation, recovery, backup versioning, deletion and restore before implementation.
- Prove restore onto a replacement device without the original device. Cross-platform restore is an open requirement.
- Do not treat account authentication or platform cloud account security as a substitute for application-level encryption.
- Live sync is later scope and needs its own device enrolment, conflict and revocation design.

For later live sync:
- Encrypt payload on client before upload.
- Backend stores opaque ciphertext, schema/version metadata and minimal routing fields.
- No server-side indexing of merchant, amount, category, notes or receipt text.
- Use idempotent operation IDs and versioned envelopes.
- Define conflict resolution per entity; never silently overwrite a financial transaction.
- Design device enrolment, key recovery, rotation, revoked devices and account deletion before release.
- Consider a user-held recovery phrase or another carefully reviewed recovery method; do not promise recoverability without a tested key-management design.
- Sync is disabled until a security review and cross-device PoC pass.

## 8. Platform strategy
- Phase 0: inspect actual development machine and Flutter environment.
- Phase 1: native Android/iOS local-first MVP.
- Phase 2: validate web/PWA storage, browser cryptography, file access, routing and offline behavior.
- Encrypted backup and restore are required for the mobile launch after Phase 0 security and recovery validation.
- Live multi-device sync is later scope, after a separate threat-model review.

## 9. Quality attributes
- Correctness: integer money, deterministic tax rules, atomic writes.
- Privacy: data minimisation, no plaintext cloud sync.
- Reliability: offline operation, migrations, backup/restore tests.
- Usability: low-friction transaction capture and understandable tax outcomes.
- Maintainability: feature boundaries, testable domain, limited dependencies.
