# Product Requirements — Poket

## 1. Product vision
Poket helps people understand their personal finances without requiring accounting knowledge. It combines a lightweight money tracker with a practical Malaysian tax-relief tracker that identifies potentially eligible expenses and explains what the user should check.

**Promise:** Your money, made clear.

## 2. Target user and problem
Initial audience: individuals in Malaysia who want to track day-to-day spending, understand their cash flow, and prepare supporting records for personal income-tax filing.

Pain points:
- Money is spread across cash, bank accounts and e-wallets.
- Manual tracking feels tedious.
- Users are unsure which expenses might qualify for tax relief.
- Receipts are easily lost and tax evidence is scattered.
- Existing finance tools can feel too complex or are not tailored to Malaysian tax concepts.

## 3. Product principles
- A transaction should be recordable in a few taps.
- Users should see useful summaries immediately.
- Tax guidance should be contextual, transparent and optional.
- No feature should require users to understand tax law before they can use the app.
- Avoid feature creep: build a dependable core ledger before advanced automation.

## 4. MVP scope

### Must have
1. Required registration before first use. Onboarding sets locale and creates wallets in RM/MYR.
2. Manual wallets/accounts: cash, bank account, e-wallet and custom wallet.
3. Income, expense and transfer transactions.
4. Categories, notes, date, wallet and optional merchant.
5. Dashboard: current-period income, expenses, net cash flow and spending by category.
6. Transaction list, search/filter and editing; deleting archives a transaction so it is hidden from normal views while retained in history.
7. Malaysian tax relief tracker for Assessment Year 2026, covering all applicable relief categories verified against official sources. Assessment Year 2027 may be included only after its details are available and reviewed.
8. Automatic rule-based tax screening when an expense is saved or edited.
9. Plain-language eligibility outcome with reason and missing-information prompts.
10. Receipt attachment from camera, photo gallery, and PDF file picker, stored securely on device.
11. Tax dashboard: tracked eligible amount, cap/remaining amount where applicable, evidence status and review-needed items.
12. Light/dark theme and English/Bahasa Malaysia-ready localisation.
13. Offline-first local storage after registration.
14. Encrypted cloud backup and restore using the approved platform storage approach; no readable financial data or receipt content is uploaded.

### Should have (after core MVP is stable)
- Receipt OCR that extracts candidate merchant/date/total and asks user to confirm.
- CSV export of transactions and tax records.
- Live encrypted sync between devices, after backup and restore are proven and the sync protocol is reviewed.
- Recurring transaction templates.
- Refund transactions linked to the original expense.
- More detailed monthly reports.

### Explicitly out of MVP
- Bank credential collection or screen scraping.
- Payment initiation, transfers through banks or card processing.
- Investment/crypto portfolio tracking.
- Shared family budgets and multi-user household access.
- AI-generated tax advice or automatic tax filing.
- Cloud OCR or third-party AI processing of receipts.
- Business accounting, invoicing, payroll or SST.
- Automatic tax submission to LHDN.
- Recurring transactions and refund handling.
- Live multi-device sync.

## 5. Core user journeys

### A. Record an expense
1. Tap `+`.
2. Choose `Expense` (default).
3. Enter amount, select wallet and category.
4. Optionally add note, merchant and receipt.
5. Save.
6. Poket quietly checks tax rules. If a follow-up is needed, show a small prompt after save or a review badge on the transaction.

Acceptance:
- A basic expense can be saved without answering tax questions.
- Amount and wallet are required; date defaults to today; category has a sensible default or is required according to UX testing.
- Save is possible offline.
- Tax screening never blocks saving a normal transaction.

### B. Understand tax eligibility
1. User opens Tax.
2. Sees assessment year and summary.
3. Poket groups expenses into `Potentially eligible`, `Needs your answer`, `Not eligible` and `Not assessed`.
4. User opens an item and sees the rule, cap/sub-limit, conditions, evidence checklist and source.
5. User answers only relevant questions and attaches evidence if needed.
6. Poket recalculates tracked amount and remaining cap.

Acceptance:
- Every outcome has a human-readable explanation.
- Each rule identifies its assessment year, source, version and verification status.
- Unknown or outdated rules are marked `Needs review`, never silently treated as eligible.
- Users can override the classification with a reason; the original automated assessment remains in history.

### C. Attach a receipt
1. User chooses camera, photo library, or a PDF through the file picker.
2. App stores the original locally in encrypted form.
3. Optional OCR extracts candidate fields on-device where technically supported.
4. User confirms extracted values before they change a transaction.
5. The receipt is linked to the transaction and/or tax evidence record.

Acceptance:
- OCR is never silently authoritative.
- Receipt access requires app-level authorization where supported.
- No receipt image or OCR text is uploaded in plaintext.

## 6. Information architecture
Primary navigation (bottom navigation on mobile; equivalent responsive navigation on web):
- **Home** — summary and quick actions.
- **Transactions** — searchable transaction history.
- **Tax** — assessment-year relief tracker.
- **Wallets** — wallet balances and management.
- **Settings** — preferences, privacy, export and account.

Keep the primary navigation to five destinations or fewer. On smaller screens, Wallets can be accessed from Home or Settings if usability testing shows five tabs are too crowded.

## 7. Tax result language
- **Potentially eligible:** rule conditions appear to match, but user must review the explanation and evidence.
- **Needs your answer:** one or more required facts are missing.
- **Not eligible:** known facts do not meet the configured rule.
- **Not assessed:** no applicable verified rule is available for this assessment year.

Do not use `Eligible` as an unconditional promise. A final tax return decision belongs to the taxpayer and applicable law.

## 8. Success measures
- Median time to record a basic expense: target under 15 seconds in usability testing.
- New user can understand Home and record first expense without tutorial.
- Tax screen explains why an item is included/excluded.
- No money arithmetic uses floating-point.
- No sensitive financial data appears in logs or analytics.
- Critical offline flows work without network access.

## 9. Confirmed launch decisions and remaining questions
- Launch platforms are Android and iOS; web/PWA is deferred until its storage and security approach is proven.
- Registration is required and uses Firebase Authentication for identity only; authentication does not imply sync or encryption.
- Single-user versus shared-household scope and custom-category creation have not been confirmed; retain the current proposed single-user MVP and default categories until decided.
- Wallet setup asks for the current balance. Whether zero or skipping is allowed remains open.
- Transactions can be edited. Delete archives the transaction and keeps it hidden from user-facing transaction views; restore behavior remains open.
- Refunds and recurring transactions are out of launch scope.
- Launch currency is RM/MYR only. Future country/currency support will not include cross-currency transactions.
- An app lock is optional and user-controlled.
- Keep records locally and provide client-side encrypted cloud backup and restore before launch. Live sync is a later phase. Storage-provider choice, backup frequency/trigger, key recovery, and cross-platform restore remain open.
- Target Assessment Year 2026 with comprehensive verified relief coverage. Add Assessment Year 2027 only if its official details are available and reviewed. Unverified rules are never guessed or presented as confirmed.
