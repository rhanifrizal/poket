# Architecture Decision Records — Poket

Status labels: Proposed, Accepted, Rejected, Superseded.

## ADR-001 — Flutter as primary client framework
**Status:** Proposed  
**Decision:** Use Flutter for the authenticated iOS, Android and web application. The public searchable feature page is proposed as semantic static web content alongside the Flutter web app.
**Reason:** One UI codebase and existing developer familiarity.  
**Trade-off:** Browser storage, camera, file handling and encryption differ from native platforms.  
**Validation:** Phase 0 validates persistence, encryption, receipt handling, routing and responsive behavior on iOS, Android and web. Review the landing-page implementation for search discoverability and accessibility.

## ADR-002 — Riverpod for state management and dependency injection
**Status:** Proposed  
**Decision:** Use Riverpod; do not introduce Provider or Bloc.  
**Reason:** Consistent with the developer's preferred Flutter approach and supports testable dependency composition.  
**Validation:** Confirm package compatibility with selected Flutter/Dart SDK.

## ADR-003 — Feature-first Clean Architecture
**Status:** Proposed  
**Decision:** Organise by feature with presentation/domain/data boundaries.  
**Reason:** Keeps tax, transactions, wallets and receipts independently testable without overengineering.  
**Trade-off:** More files than a simple layered-by-type structure; keep abstractions proportional to actual complexity.

## ADR-004 — Integer minor units for money
**Status:** Accepted  
**Decision:** Store amounts as integer minor units with currency code and exponent metadata.  
**Reason:** Avoid binary floating-point errors.  
**Validation:** Unit tests for currencies with 0, 2 and 3 decimal places, rounding and overflow.

## ADR-005 — Local-first ledger with encrypted backup
**Status:** Proposed  
**Decision:** Core records are stored locally and usable offline after required registration. Launch includes client-side encrypted Google Drive backup and restore across iOS, Android and web. Live multi-device sync is deferred.
**Reason:** Preserve offline use and offer recovery without exposing readable financial data to cloud storage.  
**Trade-off:** Drive OAuth, user storage quotas and backup key recovery add launch complexity; iCloud-only users are not supported for backup at launch, and there is no live synchronization between devices.
**Key recovery direction:** Evaluate passkey PRF as the primary way to derive a wrapping key for a random data-encryption key, with a user-held recovery phrase as fallback. The login password and Google account authorization are not encryption keys. Never upload the plaintext data-encryption key or recovery phrase.
**Validation:** Phase 0 local synthetic Node/Web Crypto envelope tests pass, but actual passkey PRF, recovery phrase UX, Google Drive transfer, and replacement-device restore are unverified. Continue the platform and Drive PoCs; do not advertise backup until portability, OAuth verification and security review pass. See poc/backup_recovery/results/summary.md. iCloud backup remains future scope.

## ADR-006 — Separate native and web persistence security
**Status:** Proposed  
**Decision:** Do not assume SQLCipher works on web. Use platform-specific adapters behind repository interfaces and validate each.  
**Reason:** Browser persistence and key management have different security constraints.  
**Validation:** Phase 0 PoC and security review.

## ADR-007 — Firebase Authentication provides identity only
**Status:** Proposed  
**Decision:** Registration is required and uses Firebase Authentication for identity. Financial data encryption and backup recovery are separate designs.  
**Reason:** Authentication does not encrypt local data or make cloud data end-to-end encrypted.  
**Validation:** Validate Android/iOS sign-in and account lifecycle. Do not treat Firebase Authentication as the encryption key or financial-data recovery mechanism.

## ADR-008 — Rule-based tax screening with human-verified data
**Status:** Proposed  
**Decision:** Use deterministic, versioned tax rules; no generative AI decides eligibility.  
**Reason:** Tax correctness, explainability and auditability.  
**Trade-off:** Rules require maintenance and review for each assessment year.

## ADR-009 — Receipt OCR is assistive
**Status:** Proposed  
**Decision:** OCR may suggest merchant/date/amount, but the user confirms all extracted fields.  
**Reason:** OCR can be wrong; financial data must not be silently modified.

## ADR-010 — Manual transaction entry before bank integrations
**Status:** Accepted  
**Decision:** MVP has manual entry only.  
**Reason:** Reduces security, regulatory and integration complexity; keeps the core product focused.

## ADR-011 — Required registration and optional app lock
**Status:** Proposed  
**Decision:** Users must register before first use. An app lock using a user-selected PIN or supported device authentication is optional.  
**Reason:** Registration is a confirmed product requirement; app lock choice belongs to each user.  
**Trade-off:** Registration adds an onboarding and connectivity dependency. Firebase sign-in flows and offline behavior after initial registration require validation. Authentication is not encryption.

## ADR-012 — Launch currency and transaction lifecycle
**Status:** Proposed  
**Decision:** Launch supports RM/MYR only. Transactions can be edited; deletion archives the record and hides it from normal views. Refunds and recurring transactions are deferred. Future additional currencies do not imply cross-currency transfers.  
**Reason:** Keep the initial ledger understandable and preserve transaction history.  
**Trade-off:** Users cannot represent foreign-currency wallets or refunds in the first release. Archive restoration and retention details remain unresolved.

## ADR-013 — Assessment-year coverage
**Status:** Proposed  
**Decision:** Target comprehensive coverage of applicable Malaysian personal relief categories for Assessment Year 2026. Include Assessment Year 2027 only after official details are available and reviewed.  
**Reason:** Users need broad expense tracking, while tax content must remain source-linked, year-specific and trustworthy.  
**Trade-off:** Comprehensive coverage increases research and review effort; any unverified or ambiguous category remains not assessed or blocked from release.
