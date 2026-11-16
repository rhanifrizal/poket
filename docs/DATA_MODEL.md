# Data Model — Poket

This is a logical model, not a final SQL schema. Generate a physical schema only after the Phase 0 database proof-of-concept and ADR approval.

## 1. Money representation
Represent money as:
- `amount_minor`: signed integer (or positive integer plus transaction type; choose one convention consistently).
- `currency_code`: ISO 4217 code, e.g. `MYR`.
- `currency_exponent`: number of decimal places for that currency, sourced from a maintained currency metadata table.

Never use `double` for persisted or domain money. Format only at the UI boundary. Validate overflow and maximum supported amount.

If future reporting converts between currencies, retain:
- original amount and currency;
- base/reporting currency;
- exchange-rate value in a decimal-safe representation;
- rate source and timestamp;
- converted amount used for the report.

## 2. Core entities

### Wallet
- id
- name
- type: cash | bank | e_wallet | other
- currency_code
- opening_balance_minor
- is_archived
- created_at, updated_at

### Category
- id
- name_key (localisation key or user-defined name)
- kind: income | expense
- parent_id (optional)
- icon_key
- is_system
- is_archived

### Transaction
- id
- type: income | expense | transfer
- amount_minor
- currency_code
- currency_exponent
- wallet_id (source wallet for income/expense; source for transfer)
- destination_wallet_id (transfer only)
- category_id (income/expense; optional only if product decision allows)
- merchant (optional)
- note (optional)
- occurred_at
- created_at, updated_at
- deleted_at (soft-delete/tombstone where sync/history requires it)
- source: manual | recurring | import (future)
- idempotency_key (for future sync/import safety)

### Receipt
- id
- local_path_or_blob_id
- encrypted_file_metadata
- mime_type
- file_size
- content_hash
- captured_at
- created_at
- encryption_key_reference (never the raw key)

### TransactionReceipt
- transaction_id
- receipt_id
- relationship_type: receipt | supporting_document

### TaxAssessment
- id
- assessment_year
- ruleset_version
- ruleset_source_reference
- created_at
- updated_at

### TaxRule
Versioned configuration:
- rule_id (stable identifier)
- assessment_year
- category_key
- maximum_relief_minor (nullable when not a simple fixed cap)
- sub_limits (structured, validated)
- effective_from / effective_to
- eligibility_conditions (typed condition definitions; not arbitrary executable code)
- evidence_requirements
- source_title
- source_url
- source_published_at
- verified_at
- verified_by / review_status
- ruleset_version

### TaxScreeningResult
- id
- transaction_id
- rule_id
- ruleset_version
- assessment_year
- status: potentially_eligible | needs_answer | not_eligible | not_assessed
- matched_conditions
- failed_conditions
- missing_answers
- reason_codes
- screened_at
- user_review_status
- user_override_reason (optional)

### TaxAnswer
- id
- transaction_id
- rule_id
- question_key
- answer_value (typed/validated)
- answered_at

### TaxEvidence
- id
- transaction_id
- rule_id
- receipt_id (nullable)
- evidence_type
- status: missing | attached | reviewed
- note (optional)

## 3. Transaction invariants
- Income increases the selected wallet balance.
- Expense decreases the selected wallet balance.
- At launch, all wallets and transactions use MYR; transfers are MYR-to-MYR only.
- Future support for additional country currencies does not authorize cross-currency transfers. Any broader currency behavior requires a separate product decision and ADR.
- Transfer is excluded from income and expense reports.
- A transaction's amount and currency cannot be changed without recalculating derived reports and tax screening.
- Deleting a transaction must also update reports and tax totals; retain a tombstone if sync is enabled.
- All balance-affecting writes are atomic.

## 4. Tax totals
Do not sum all candidate expenses blindly. For each rule and assessment year:
1. Select transactions that match the rule and pass required conditions.
2. Apply category/rule sub-limits and annual caps in the configured order.
3. Avoid double-counting the same expense across overlapping relief rules unless the official rule explicitly permits it.
4. Retain per-transaction contribution and calculation trace.
5. Clearly label values as tracked estimates, not final tax-return amounts.

## 5. Privacy
Encrypt receipt bytes and sensitive local fields at rest. Minimise metadata that must remain queryable. Never place raw encryption keys in this schema.
