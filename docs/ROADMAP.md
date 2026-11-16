# Delivery Roadmap — Poket

## Phase 0 — Discovery and technical feasibility
Do not start broad feature coding yet.

Tasks:
- Inspect OS, Flutter, Dart, Xcode, Android SDK, Java, Node, Git and GitHub CLI versions.
- Confirm target launch platforms.
- Validate registration and the minimal Flutter app on both Android and iOS.
- Test Drift persistence and migrations.
- Prove native database encryption with a maintained package.
- Design and PoC client-side encrypted backup and restore, including key recovery after loss of the original device. Use fake data and ciphertext only; validate intended Google/iCloud storage options and whether cross-platform restore is supported.
- Decide whether backups run automatically, manually, or both, including retention and deletion behavior.
- Test camera, gallery and PDF selection plus encrypted local receipt storage and backup.
- Investigate web persistence only after mobile scope; do not promise web until proven.
- Review package maintenance, licence, platform support and security.
- Verify official LHDN sources for all applicable Assessment Year 2026 relief categories; include Assessment Year 2027 only if its details are available and reviewed.
- Produce an ADR for every decision.

Exit criteria:
- Written PoC results with exact versions and commands.
- No unresolved blocker hidden behind assumptions.
- User approves architecture and MVP scope.

## Phase 1 — Local-first ledger MVP
- App shell, themes, localisation and required registration.
- Onboarding and wallet creation.
- Ask for a wallet's current balance during setup; whether zero or skipping is allowed remains to be decided.
- Categories.
- Income, expense and transfer flows.
- Transaction list, edit, and archive-on-delete behavior with archived records hidden from normal views.
- Home summary and category breakdown.
- Camera/gallery/PDF receipt attachment with encrypted local storage.
- Client-side encrypted cloud backup and restore, only after Phase 0 security and recovery gates pass.
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

## Phase 4 — Web/PWA
- Web storage/encryption adapter.
- Responsive UI and keyboard accessibility.
- Browser file handling and offline behavior.
- Web-specific security review.

Exit criteria:
- Web storage threat model reviewed.
- Cross-browser tests pass.
- No unsupported native assumptions remain.

## Phase 5 — Live encrypted sync (later, only if approved)
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
