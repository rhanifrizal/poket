# Malaysian Tax Relief Engine — Poket

## 1. Purpose
Screen expense transactions against verified Malaysian individual income-tax relief rules for a selected assessment year. The engine provides a useful estimate and evidence checklist; it does not determine a taxpayer's final legal entitlement.

## 2. Critical rule
**Category match is only a candidate signal, never proof of eligibility.**

An expense may depend on:
- assessment year;
- taxpayer identity/relationship;
- date of payment or purchase;
- item/service type;
- personal-use or other statutory conditions;
- ownership/name on bill or receipt;
- supporting documents;
- relief cap and sub-limits;
- exclusions and interactions with other reliefs.

## 3. Rule lifecycle
1. Collect current official LHDN publications and relevant legislation/regulations.
2. Extract candidate rule changes.
3. Have a qualified human reviewer verify wording, assessment year, conditions and limits.
4. Encode rules as versioned data.
5. Add positive, negative and boundary tests.
6. Publish only rules marked verified.
7. Retain previous versions for audit and historical recalculation.
8. When a rule is uncertain or source is unavailable, return `not_assessed` or `needs_answer`, not a guessed result.

Never assume a public LHDN API exists. Do not scrape or auto-publish tax rules without human review.

## 4. Rule record
Each rule must include:
- stable rule ID;
- assessment year;
- display category;
- source title and official URL;
- source publication/effective date;
- verified date and reviewer;
- rule-set version;
- cap and sub-limits (when applicable);
- eligibility conditions in a typed declarative format;
- required/supporting evidence;
- exclusions;
- calculation order;
- test cases;
- status: draft | reviewed | verified | retired.

## 5. Screening workflow
When an expense is saved:
1. Find verified rules for the selected assessment year.
2. Match broad expense/category signals.
3. Evaluate only conditions that can be answered from transaction data.
4. If required information is missing, return `needs_answer`.
5. If facts clearly fail a condition, return `not_eligible` with an explanation.
6. If conditions appear to match, return `potentially_eligible`.
7. If no verified rule applies, return `not_assessed`.
8. Persist rule version, reason codes and screening timestamp.

The user can save the expense regardless of screening outcome.

## 6. Example UX (illustrative only)
User records `RM2,000 — smartphone`.
- Poket recognises a possible lifestyle-related tax rule for the chosen assessment year.
- It asks only the necessary questions, e.g. whether the item meets the rule's permitted purpose and ownership requirements.
- If the answer is unknown, status is `Needs your answer`.
- If facts appear to match a verified rule, status is `Potentially eligible`.
- Poket requests a receipt or other required evidence.
- The tax dashboard updates the tracked amount subject to the applicable cap and sub-limits.

This example does not assert that a smartphone purchase qualifies in every year. The current official rule and conditions must be checked.

## 7. Calculation requirements
- Use integer minor units/decimal-safe arithmetic.
- Apply statutory caps and sub-limits exactly as encoded for that assessment year.
- Do not double count one expense across reliefs unless rules permit it.
- Track amount per expense and aggregate per rule.
- Show tracked amount, maximum amount, remaining amount and evidence state only when supported by verified data.
- Never calculate tax savings by multiplying relief by a generic tax rate unless the user's full tax situation and progressive rates are modelled. Prefer to show relief amount, not estimated refund.

## 8. User-facing wording
Use:
- `Potentially eligible`
- `Needs your answer`
- `Not eligible`
- `Not assessed`

Every outcome should include:
- why it was flagged;
- what facts were checked;
- what is missing;
- evidence checklist;
- assessment year;
- source and last verification date;
- reminder to confirm against official LHDN guidance.

## 9. Source policy
Primary sources:
- LHDN official tax relief page: https://www.hasil.gov.my/en/individu/pelepasan-cukai/?isStampsSite=false&lang=en&refererUrl=https%3A%2F%2Fwww.hasil.gov.my%2Fen%2Findividu%2Fpelepasan-cukai%2F
- LHDN official publications and assessment-year flyers: https://www.hasil.gov.my/
- Applicable Malaysian legislation and official gazette publications.

The exact current official URL and content must be re-verified before rules are added. Do not copy values from a prior assessment year into a new year without confirmation. Tax content needs a human review gate before release.
