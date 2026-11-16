# UX & Product Design — Poket

## 1. Experience direction
Poket should feel calm, clear and approachable—not like accounting software. Use friendly language, restrained colour, generous spacing, readable typography and a small number of meaningful numbers.

Avoid:
- Dense data tables on mobile.
- Too many charts on the home screen.
- Tax-law language without a plain-language explanation.
- Forcing receipt upload or tax questions during basic expense entry.
- Showing every feature during onboarding.

## 2. Navigation
Recommended primary destinations:
1. Home
2. Transactions
3. Tax
4. Wallets
5. Settings

Use a persistent `+` quick action for Add transaction. On mobile, a bottom sheet or dedicated focused screen can present Expense, Income and Transfer.

## 3. Home screen
Top:
- Greeting / selected period.
- Total balance across selected wallets (label clearly; do not imply bank-verified balance).
- Income, expenses and net cash flow for the period.

Middle:
- Spending by category (simple horizontal bars; limit visible categories and provide `See all`).
- Recent transactions.

Tax helper card:
- `Tax relief progress` with tracked amount for the selected assessment year.
- Small count of items needing review.
- CTA: `Review tax items`.

Do not make tax relief dominate the Home screen. The ledger remains the primary use case.

## 4. Add transaction flow
Default to Expense only if user research supports it. Provide a clear segmented choice: Expense / Income / Transfer.

Minimum fields:
- Amount
- Wallet
- Category (not required for transfer if source/destination are clear)
- Date (today by default)

Optional fields:
- Merchant
- Note
- Receipt

After save:
- Show concise success feedback.
- If tax screening requires an answer, show a non-blocking `Check tax details` action.
- Never block transaction saving because tax rules are unavailable or outdated.

## 5. Tax screen
Header: `Tax relief`
- Assessment year selector.
- Summary: `Potentially claimable*` tracked amount, applicable annual limit and remaining amount only when the rule data supports those values.
- Footnote: `Estimate based on information you've entered. Confirm against current LHDN guidance.`

Sections:
- Needs your attention
- Potentially eligible expenses
- Not eligible / excluded (collapsed by default)
- Evidence missing (may be a filter or badge)

Each relief category card shows:
- Plain-language category name.
- Amount tracked / applicable limit.
- Number of transactions.
- Evidence status.
- A short status label and accessible icon.

Detail view:
- Why Poket flagged this expense.
- Conditions checked.
- Questions still unanswered.
- Required/supporting evidence.
- Official source and assessment year.
- `Mark reviewed`, `Update answers`, `Change status` actions.

## 6. Progressive disclosure
Show only the next useful question. Example: if a rule requires the purchase to be for the taxpayer's own use, ask that question only after a potentially matching expense is detected. Do not ask every user every tax question during onboarding.

## 7. Visual and accessibility requirements
- Light and dark themes.
- Use semantic text styles and spacing tokens.
- Minimum comfortable touch target around 44–48 logical pixels.
- Support text scaling and screen readers.
- Meet WCAG 2.2 AA contrast targets where applicable.
- Never rely on colour alone for status.
- Provide skeleton/loading, empty, error, offline and success states.
- Web layout should have a sensible max content width and keyboard focus indicators.
- Localise all user-facing text; do not embed English strings in widgets.

## 8. Design system starter tokens
Create a small theme system, not a giant design framework:
- Colour roles: primary, onPrimary, background, surface, surfaceVariant, textPrimary, textSecondary, outline, success, warning, error.
- Spacing scale: 4, 8, 12, 16, 24, 32.
- Radius scale: 8, 12, 16, 24.
- Typography: display, headline, title, body, label.
- Components: primary/secondary button, amount input, wallet selector, category picker, transaction row, summary card, tax status chip, evidence row, empty state.

Colours and font choices should be proposed as a small visual direction and reviewed before implementation. Do not generate elaborate UI before core navigation and flows are agreed.
