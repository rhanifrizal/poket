# Poket — Codex Project Instructions

## Mission
Build **Poket**, a calm, approachable personal finance app with a Malaysian personal income-tax relief tracker. The app should make money tracking easy and tax eligibility understandable without overwhelming users.

## Non-negotiable product rules
- Keep the everyday transaction flow short. Do not turn a simple expense entry into a tax questionnaire.
- The primary product is a money tracker. Tax relief is a helpful layer, not the whole app.
- Explain tax classification in plain language: `Potentially eligible`, `Needs your answer`, `Not eligible`, or `Not assessed`.
- Never imply that Poket is affiliated with or endorsed by LHDN.
- Tax rules must be assessment-year-specific, source-linked, versioned, reviewed and testable. Never guess current relief caps or conditions.
- Never claim a tax expense is definitely deductible solely because its category matches.
- Make it easy for users to correct a category, tax status, amount, date or evidence attachment.

## Engineering principles
- Flutter/Dart, feature-first Clean Architecture with clear presentation, domain and data boundaries.
- Use **Riverpod** for dependency injection and state management. Do not introduce Provider or Bloc.
- Use a custom `Navigator`/`Router` implementation. Do not add `go_router` unless an ADR is approved.
- Prefer small, cohesive features, explicit types, immutable domain models and testable pure business logic.
- Keep UI widgets thin. No database, tax-rule or encryption logic in widgets.
- Use repository interfaces in domain; implementations and external SDKs belong in data/infrastructure.
- Avoid premature abstractions and unnecessary packages. Every dependency needs a reason and a platform-compatibility review.
- Use the Flutter/Dart versions installed in the environment; inspect before changing versions.

## Financial-data correctness
- Never represent money using binary floating-point (`double`) in domain or persistence.
- Store amounts as integer minor units with an ISO 4217 currency code and currency exponent/metadata.
- Use decimal-safe conversion and formatting at boundaries. Do not silently round.
- A transfer between a user's own wallets is neither income nor expense.
- Store the original transaction currency and amount. If reporting in a base currency, persist the exchange rate and converted amount used for that report.
- Use atomic database transactions for multi-record financial operations.
- Preserve transaction history where practical; corrections should be explicit and auditable.
- Handle refunds, split transactions and recurring transactions only when their MVP scope is approved.

## Privacy and security
- Treat transactions, account names, balances, receipts and tax records as highly sensitive.
- Never log financial values, receipt OCR text, access tokens, passwords, encryption keys or personal identifiers.
- Do not commit secrets, service-account files, signing keys, `.env` files or real user data.
- Do not send readable financial data or receipt content to analytics, crash reporting, AI services or cloud storage.
- Cloud sync must be end-to-end/client-side encrypted: encrypt before upload; server stores opaque ciphertext and minimal routing metadata only.
- Authentication is not encryption and does not by itself protect stored financial data.
- Use platform secure storage for key material; do not invent cryptography or implement custom ciphers.
- Review key creation, recovery, rotation, logout, device loss and account deletion before enabling sync.
- Do not claim SQLCipher or web encryption works until a Phase 0 proof-of-concept passes on each target platform.
- Require explicit approval before destructive commands, dependency upgrades with broad impact, remote repository creation, pushing, deploying, or deleting data.

## UX and accessibility
- Prefer clear labels, familiar language, sensible defaults and progressive disclosure.
- Avoid jargon, dense dashboards, unnecessary charts, modal chains and excessive setup.
- Every screen should have one clear primary action.
- Support light/dark themes, responsive layouts, keyboard navigation on web, semantic labels and readable contrast.
- Do not use colour alone to communicate tax status.
- Loading, empty, error, offline and success states are required for user-facing flows.

## Testing and quality
- Add unit tests for money calculations, transfer rules, tax eligibility and rule version selection.
- Add repository/database tests for persistence and atomicity.
- Add widget tests for critical flows and integration tests for onboarding, transaction creation and tax review.
- Test edge cases: zero, negative values where allowed, large values, currency exponents, leap dates, timezone boundaries, duplicate sync operations and missing evidence.
- Run formatter, analyzer and relevant tests after each coherent change. Report exact commands and results.
- Do not claim a test passed unless it was run and its output supports that claim.

## Workflow
1. Inspect the repository and environment before editing.
2. Read relevant documentation before proposing implementation.
3. For substantial work, enter plan mode, identify assumptions and propose a small sequence of changes.
4. Ask questions only when a missing decision materially affects correctness. Otherwise state a reversible assumption.
5. Implement one vertical slice at a time; do not scaffold the entire product in one giant pass.
6. Before adding a package, inspect its maintenance, licence, platform support and security implications.
7. Keep docs and ADRs updated when decisions change.
8. Never overwrite user work or discard unknown changes. Inspect `git status` first.
9. Do not commit, push, create GitHub resources or deploy unless the user explicitly asks.
10. At completion, summarize files changed, tests run, known limitations and the next smallest step.

## Codex and Superpowers workflow
- Treat the product and engineering documents listed in `README.md` as the source of truth; read the relevant sections before proposing or changing behavior.
- Use Superpowers brainstorming for new features or meaningful behavior changes. Ask one discovery question at a time when product decisions materially affect scope or architecture.
- For substantial approved work, write a small implementation plan before editing. Use focused implementation and verification workflows for the task; routine documentation fixes do not need a heavyweight process.
- Use test-driven development for application behavior and verify with the relevant formatter, analyzer and tests before claiming completion.
- Keep Codex project instructions concise; update the source documents instead of duplicating their full requirements here.
- Do not create GitHub repositories, configure remotes, push, deploy or delete data without explicit approval.

## Current proposed stack (not yet validated)
- Flutter + Dart
- Riverpod
- Drift as persistence abstraction; native SQLite with SQLCipher considered for mobile/desktop
- A separately validated encrypted web persistence adapter (IndexedDB/Web Crypto or an equivalent maintained solution)
- Firebase Authentication for account identity only; authentication is not encryption
- Client-side encrypted cross-platform backup and restore for launch using Google Drive; Firebase Authentication is identity only, iCloud backup is future scope, and live sync is later. Key recovery requires a separate design and PoC.
- Camera/gallery/PDF receipt capture; OCR as optional assisted extraction, always user-confirmed
- Local, bundled tax-rule datasets with signed/versioned releases considered later

Do not treat proposed choices as approved implementation facts. Follow `docs/ADRs.md` and record changes.
