---
name: femio-compliance-privacy
description: Femio privacy and regulatory compliance - GDPR/PDPL health data handling, consent, data mapping, medical-device scope avoidance, app store health policies, ads restrictions. Use when designing ANY Femio feature touching user data, writing privacy UX/policy, adding data fields, integrating third parties/SDKs, or making medical/prediction claims.
---

# Femio Compliance & Privacy Standard

Privacy is Femio's headline differentiator in a scandal-ridden category (Flo FTC 2021, Premom FTC 2023, Glow breach 2024). We must be verifiably clean, not just legally adequate.

## Regulatory scope control (existential rule)
- **Intended purpose = wellness, education, tracking.** Femio must NEVER claim to diagnose, treat, prevent disease, or act as contraception. Fertile-window features are framed for awareness/conception support — explicitly NOT birth control (that is regulated SaMD territory: FDA De Novo / EU MDR Class IIb, Natural Cycles' moat).
- Screeners (EPDS, PHQ-9, DRSP, MRS) = "screening/awareness tools, discuss results with your clinician."
- Copy review: any feature description using diagnose/detect/prevent/treat/contraception gets flagged and rewritten.
- AI features: educational answers with citations only; no personalized medical advice; log this boundary in system prompts and UX.

## Data protection (GDPR + Saudi/UAE PDPL + Egypt 151/2020)
1. Cycle/health data = special category → **explicit, granular, revocable consent** captured before first health field is stored; consent text plain-language, per purpose (tracking / insights / research-opt-in separately).
2. **Data minimization:** every new field must answer "which user feature needs this?" — no speculative collection (the #1 user resentment found in research).
3. Rights implemented in-product: export (JSON+PDF), full deletion (cascade, incl. backups schedule), rectification. Target <72h automated.
4. **Data map maintained** (`docs/compliance/DATA_MAP.md`): field → purpose → lawful basis → retention → processors → region. Updated in the same PR that adds any field (CI checklist item).
5. Hosting EU region; processors require DPA; maintain processor register. DPIA before launch and before each new data category.
6. Anonymous mode: full tracking without identity (device-keyed), upgradeable to account without data loss.
7. Breach runbook: 72h GDPR notification path documented.

## Ads & SDK rules (freemium tier)
- **No health data ever reaches ad/analytics SDKs.** Ads are contextual (page topic) only — never targeted on logged symptoms, cycle phase, pregnancy status.
- SDK allowlist reviewed quarterly; no SDK gets default access to app storage/events; analytics (PostHog EU) receives pseudonymous, health-field-free events with documented event schema.
- Affiliate links disclosed inline.

## Minors
Teen mode: no ads, no community DMs, minimal data, age-appropriate content; comply with GDPR age-of-consent per country (13–16) with parental-consent flow where required.

## App stores (Phase 4)
Apple 5.1.3 (health data may not be used for advertising; no false medical claims), Play Health apps declaration + Data safety form — labels must exactly match the data map.

## Feature review gate
Any PR touching data or claims includes this filled block: fields added? consent needed? data map updated? claims language checked? third parties involved? retention set? — reviewer blocks merge if incomplete.
