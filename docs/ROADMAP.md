# Delivery Roadmap — Poket

## Phase 0 — Discovery and technical feasibility
Do not start broad feature coding yet.

Tasks:
- Inspect OS, Flutter, Dart, Xcode, Android SDK, Java, Node, Git and GitHub CLI versions.
- Confirm and validate launch targets: iOS, Android and web.
- Validate required registration with Firebase Authentication and the Flutter application shell on all three targets.
- Test Drift persistence and migrations.
- Prove native database encryption with a maintained package.
- Design and PoC client-side encrypted Google Drive backup and restore. Evaluate passkey PRF for wrapping a random data-encryption key, with a user-held recovery phrase fallback. Use fake data and ciphertext only; test replacement-device recovery and portable restore among iOS, Android and web.
- Validate the `drive.appdata` OAuth consent and verification requirements, user Drive quota behavior, app-data deletion/revocation, and upload/download limits.
- Decide whether backups run automatically, manually, or both, including retention and deletion behavior.
- Test camera, gallery and PDF selection plus encrypted local receipt storage and backup on each supported platform.
- Validate browser persistence, key handling, routing, file access, offline behavior, and responsive/keyboard UX before web release.
- Validate the searchable public feature page and its sign-in/register handoff to the Flutter web app.
- Review package maintenance, licence, platform support and security.
- Verify official LHDN sources for all applicable Assessment Year 2026 relief categories; include Assessment Year 2027 only if its details are available and reviewed.
- Produce an ADR for every decision.

Exit criteria:
- Written PoC results with exact versions and commands.
- No unresolved blocker hidden behind assumptions.
- User approves architecture and MVP scope.

Phase 0 backup gate is not passed: only the local synthetic envelope has been verified; platform PRF, generated recovery phrase, Drive transfer and replacement-device restore remain open. See poc/backup_recovery/results/summary.md.

## Phase 1 — Responsive local-first ledger MVP (iOS, Android and web)
- App shell, themes, localisation, responsive/adaptive layouts and required Firebase Authentication registration.
- Public searchable feature page with sign-in/register routes into the authenticated Flutter web app. Static semantic page is the current proposal pending review.
- Onboarding and wallet creation.
- Ask for a wallet's current balance during setup; whether zero or skipping is allowed remains to be decided.
- Categories.
- Income, expense and transfer flows.
- Transaction list, edit, and archive-on-delete behavior with archived records hidden from normal views.
- Home summary and category breakdown.
- Camera/gallery/PDF receipt attachment with encrypted local storage.
- Client-side encrypted cross-platform Google Drive backup and restore, only after Phase 0 security and recovery gates pass. Use the user's Drive storage quota; iCloud is future scope.
- Local database and migration tests.
- Unit/widget/integration tests.

Exit criteria:
- All ledger flows work offline.
- Money arithmetic and transfers pass tests.
- No sensitive data in logs.

## Phase 2 — Tax relief tracker
- Assessment-year selection for YA 2026 and YA 2027 only when the latter's official details are available and reviewed.
- Comprehensive verified coverage of applicable relief categories for each supported year.
- Verified rule-set format and fixtures.
- Screening engine and reason codes.
- Tax dashboard and detail explanations.
- Missing-answer workflow.
- Evidence attachment and status.
- Rule update/version handling.

Exit criteria:
- Tax rule reviewer approves all included rules.
- Positive, negative and boundary tests pass.
- User-facing copy clearly communicates uncertainty.

## Phase 3 — Usability improvements
- Optional on-device OCR and user confirmation.
- CSV export.
- Usability testing and accessibility pass.

Exit criteria:
- OCR never silently changes transaction values.
- Receipt lifecycle and deletion tested.

## Phase 4 — Live encrypted sync (later, only if approved)
- Device enrolment and key lifecycle.
- Encrypted change envelopes.
- Conflict handling and idempotency.
- Encrypted receipt sync.
- Recovery, revoke-device and account deletion.
- Backup/restore drills.

Exit criteria:
- Independent security review.
- Backend cannot read financial content.
- Restore and conflict tests pass.

## Release discipline
- Build one vertical slice at a time.
- Keep main branch stable.
- Use feature branches and pull requests.
- CI: format, analyze, unit tests, widget tests, build checks.
- Add release signing and store deployment only after release process is documented.
