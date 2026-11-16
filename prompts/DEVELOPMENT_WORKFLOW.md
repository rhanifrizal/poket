# Codex and Superpowers Workflow — Step-by-Step Prompts

Use the stages in order, returning to the relevant stage when decisions change. Work from the repository root in Codex. Follow `AGENTS.md`, use the relevant Superpowers skills for discovery, planning, implementation and verification, and review diffs. Do not authorize destructive commands broadly.

## Step 1 — Inspect the environment (read-only)
```text
Read AGENTS.md and the relevant files under docs/ before doing anything.

Do not create or modify files yet. Inspect this machine and report:
- OS and architecture
- Flutter and Dart versions
- Xcode and iOS simulator availability
- Android SDK, Java and Android emulator availability
- Flutter web browser availability
- Git, GitHub CLI and Node versions
- available disk space if easy to inspect
- whether this folder is already a Git repository, whether it has uncommitted changes, and whether a GitHub remote is configured

Then identify compatibility risks for the proposed Flutter, Riverpod, Drift, encryption, Firebase Auth, camera and OCR stack. Use current official package/documentation sources where necessary. Do not assume package support. Produce a concise environment report and a list of decisions that need my approval.
```

## Step 2 — Product discovery interview
```text
Act as a product manager and senior Flutter architect. Review docs/PRODUCT_REQUIREMENTS.md and docs/UX_PRODUCT_DESIGN.md.

Interview me one question at a time, only when the answer materially changes MVP scope, UX or architecture. Prioritise:
1. iOS, Android and web launch scope
2. registration and local/offline behavior
3. wallet opening balance behavior
4. receipt image and PDF support
5. assessment years and complete verified relief coverage
6. launch currency and cross-currency behavior
7. transaction editing, archive-on-delete, refunds and recurring transactions
8. optional app lock, encrypted cross-platform backup/restore, key recovery and later live sync
9. searchable public feature page, sign-in/register handoff, responsive behavior and same-ledger access across platforms

Do not ask me to decide low-level implementation details that can be safely proposed. At the end, update the product docs with confirmed decisions and list unresolved risks. Do not write application code.
```

## Step 3 — Validate tax requirements
```text
Work only on the tax-rule research and specification. Identify the official Malaysian LHDN sources and relevant legislation for the assessment year(s) I approved.

For every proposed relief rule, provide:
- exact assessment year
- official source URL and publication date
- cap/sub-limits
- eligibility conditions and exclusions
- required/supporting evidence
- effective dates
- confidence and unresolved interpretation questions

Do not use blogs as the authority. Do not invent rules or assume a prior year's limits carry forward. If the source is ambiguous, mark the rule as blocked for release and ask for qualified review. Create a draft versioned rule dataset and tests only for verified facts. Do not implement tax UI yet.
```

## Step 4 — Architecture and database review
```text
Review docs/ARCHITECTURE.md, docs/DATA_MODEL.md, docs/SECURITY_PRIVACY.md and docs/ADRs.md against the confirmed product decisions and environment report.

Produce:
- final proposed folder structure
- dependency graph
- logical-to-physical database mapping
- migration strategy
- native and web persistence strategy
- threat model and key-management questions
- package shortlist with licence, maintenance and platform-support notes
- CI checks

Challenge unnecessary complexity. Keep MVP simple. Do not add packages or create application code yet. Update the docs and ADRs, then stop for my approval.
```

## Step 5 — Phase 0 technical proof-of-concepts
```text
Implement only the smallest Phase 0 proof-of-concepts approved in docs/ROADMAP.md.

Before each PoC, state the exact question it is intended to answer. Keep PoCs isolated and easy to remove. Test:
- Flutter app runs on the approved native target
- Riverpod setup
- Drift persistence and schema migration
- native database encryption on iOS and Android
- encrypted receipt file write/read for camera, gallery and PDF flows
- browser persistence and key protection for the Flutter web app
- portable encrypted backup/restore across iOS, Android and web using fake data and ciphertext
- responsive layouts and keyboard navigation across supported browser sizes

Do not connect production authentication, create cloud resources, upload real data or enable live sync. Use fake data and ciphertext only. Validate Google Drive API access with a test account and isolated approved OAuth setup before using any production project. Validate `drive.appdata` scope, quota/revocation behavior and portable restore across iOS, Android and web. Run tests and report exact versions, commands, results and limitations. Update ADRs with evidence.
```

## Step 6 — Create the production app shell
```text
After I approve Phase 0, create the production Flutter app shell only.

Implement:
- app bootstrap
- theme system with light/dark mode
- localisation setup for English and Bahasa Malaysia
- custom router
- Riverpod composition root
- feature-first folder structure
- error handling and logging redaction
- lint and test configuration

Do not implement transactions, tax, receipts or sync yet. Keep the app compiling. Run format, analyze and tests. Show the file tree and explain every dependency added.
```

## Step 7 — Implement the ledger vertical slice
```text
Implement the ledger in small vertical slices in this order:
1. Money value object and currency metadata
2. Wallet create/list/archive
3. Category list and custom category support
4. Expense create/read/update/delete
5. Income create/read/update/delete
6. Transfers with atomic source/destination balance updates
7. Transaction history, filters and search
8. Home summaries

For each slice:
- write/adjust domain tests first
- implement data persistence
- implement Riverpod state
- implement accessible UI and all states
- run format, analyze and relevant tests
- review money correctness and transaction invariants

Do not use double for money. Do not add tax logic to the ledger UI. Stop after each slice for review.
```

## Step 8 — Implement tax relief screening
```text
Implement the tax-relief engine as a pure domain module using only the reviewed, versioned rule dataset.

Requirements:
- deterministic rule evaluation
- assessment-year selection
- statuses: potentially eligible, needs your answer, not eligible, not assessed
- reason codes and plain-language explanations
- missing-answer questions
- evidence checklist
- rule version and source traceability
- no double counting and correct cap/sub-limit calculations
- user override with audit history

Write positive, negative and boundary tests before the UI. Never let tax screening block transaction saving. Do not invent tax rules. After the domain engine passes, build the Tax summary and detail screens using progressive disclosure.
```

## Step 9 — Receipts and OCR
```text
Implement receipt capture and attachment using the approved local encrypted storage design.

Start with attach/view/delete. Then investigate on-device OCR. OCR may suggest merchant, date and total only; show a confirmation step before updating a transaction. Do not send images or OCR text to cloud services. Test file encryption, permissions, deletion, large files, unsupported types and app restart recovery.
```

## Step 10 — UX review and hardening
```text
Act as a critical product designer and QA engineer. Review the app against docs/UX_PRODUCT_DESIGN.md and docs/PRODUCT_REQUIREMENTS.md.

Walk through:
- first launch and onboarding
- record first expense
- edit/delete transaction
- create transfer
- understand Home summary
- review tax relief item
- answer missing tax question
- attach evidence
- offline and error states
- light/dark, text scaling, keyboard and screen reader basics

Identify confusing labels, unnecessary steps, clutter and misleading tax wording. Fix only approved issues. Add widget/integration tests for critical flows. Do not add new features during this pass.
```

## Step 11 — Live sync (only if approved)
```text
Do not begin live sync from assumptions. Web is in launch scope; re-read the web security ADRs and Phase 0 evidence before web implementation.

For live sync, first produce a protocol design covering key creation, device enrolment, encryption envelope, versioning, idempotency, conflict resolution, revocation, recovery and deletion. Have the design reviewed before coding. Backend must never receive readable financial payloads or receipt bytes.
```

## Step 12 — Release readiness
```text
Prepare a release-readiness review. Do not publish or deploy.

Check:
- tests and coverage for critical domain logic
- formatting, analyzer and dependency audit
- secrets scan
- database migration and restore tests
- privacy/logging review
- accessibility and responsive behavior
- tax rule verification and source freshness
- app permissions and store disclosures
- crash reporting and analytics data minimisation
- backup, deletion and support procedures

Create a release checklist and list all blockers. Do not claim production readiness while any critical security, financial correctness or tax verification blocker remains.
```

## Session-ending prompt
```text
Before we stop, update the relevant documentation and ADRs with decisions made today. Summarise completed work, files changed, commands/tests actually run, open questions, risks and the exact next step. Do not commit or push unless I explicitly ask.
```
