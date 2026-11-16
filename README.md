# Poket — Product & Engineering Documentation

**Product direction:** Poket  
**Tagline:** Your money, made clear.  
**Status:** Product specification for an MVP; technical choices are proposed and must be validated in Phase 0.

Poket is a simple personal finance app with a Malaysian tax-relief companion. Users record income and expenses, understand where their money goes, and see which expenses may qualify for personal income-tax relief. Launch targets are iOS, Android and web, with a searchable public feature page and a responsive authenticated finance app.

## Product principles
1. **Simple first:** everyday money tracking must be faster than maintaining a spreadsheet.
2. **Useful, not noisy:** show clear summaries and only ask follow-up questions when they change eligibility or data quality.
3. **Explain every tax decision:** show why an expense may qualify, what conditions remain, and what evidence is needed.
4. **Private by design:** financial records and receipt images are sensitive. Cloud services must not receive readable financial content.
5. **Honest about uncertainty:** tax rules are year-specific and conditional. Never present automated classification as an official LHDN determination.

## Documentation map
- `AGENTS.md` — Codex project instructions and workflow guardrails.
- `docs/PRODUCT_REQUIREMENTS.md` — target users, MVP, user stories and acceptance criteria.
- `docs/UX_PRODUCT_DESIGN.md` — navigation, screens, UX rules and interaction patterns.
- `docs/UX_PRODUCT_DESIGN.md` — navigation, screens, UX rules and interaction patterns.
- `docs/ARCHITECTURE.md` — proposed Flutter architecture and system boundaries.
- `docs/DATA_MODEL.md` — domain entities, database concepts and money representation.
- `docs/SECURITY_PRIVACY.md` — threat model, encryption, authentication and privacy requirements.
- `docs/TAX_RELIEF_ENGINE.md` — versioned Malaysian tax-rule model and eligibility workflow.
- `docs/ROADMAP.md` — phased implementation and definition of done.
- `docs/ADRs.md` — architecture decisions and open decisions.
- `prompts/DEVELOPMENT_WORKFLOW.md` — staged development workflow for Codex and Superpowers.

## Important product boundaries
- Poket is not a bank, payment processor, tax agent, or official LHDN product.
- MVP transactions are entered manually. Do not build bank account aggregation or payment initiation.
- Tax classification is an assistant feature, not tax advice. Users must be able to review and correct it.
- Do not hard-code a tax year's limits into application logic. Tax rules are versioned data with sources and verification status.
- Account registration is required and uses Firebase Authentication for identity only; it does not protect financial data by encryption.
- Encrypted cross-platform backup and restore are launch requirements. Google Drive is the launch backup destination; Firebase remains the identity provider, and iCloud backup is future scope. Live multi-device sync is later.
- No production backup, OCR, or authentication integration should be treated as complete until its security and platform feasibility are tested.

## Start here
1. Read `AGENTS.md` and the relevant product and engineering docs.
2. Follow `prompts/DEVELOPMENT_WORKFLOW.md` with Codex and the applicable Superpowers workflow.
3. Do not skip Phase 0 technical spikes or the user approval gates.
