---
name: femio-i18n-workflow
description: Femio internationalization workflow - EN/AR/FR/ES string management, ICU MessageFormat, RTL QA, translation portal process (machine draft to human review). Use when adding/changing any user-facing string, building i18n infrastructure, translating content, or QA-ing locale builds for Femio.
---

# Femio i18n Workflow

Four locales (EN master, AR RTL, FR, ES) from scratch. Strings live in the database (served to next-intl), managed by the admin translation portal — never hardcoded, never edited only in code.

## String rules
1. Key naming: `feature.screen.element[.qualifier]` — e.g. `cycle.dashboard.nextPeriod.title`, `common.actions.save`. Stable keys; never reuse a key for different meaning (create new + deprecate old).
2. ICU MessageFormat for everything variable: plurals (`{count, plural, one {...} other {...}}` — AR needs zero/one/two/few/many/other!), gender, dates via locale-aware formatters (never string-built dates).
3. No string concatenation across keys — full sentences per key so translators see context.
4. Every key ships with a `description` for translators (where it appears, tone, max length).
5. Numbers/units: locale formatters; metric/imperial user setting orthogonal to locale; Western Arabic digits default in AR (configurable).

## Translation portal workflow (admin)
```
EN string added (dev or CMS) → status: missing in AR/FR/ES
→ DeepL/machine draft (auto) → status: draft
→ human translator edits → status: translated
→ reviewer approves (medical content requires locale medical reviewer) → status: approved → live
```
- Portal shows per-locale completion %, missing/stale lists (EN changed after translation = stale), in-context screenshot preview where possible.
- Fallback chain: locale → EN. Never render raw keys in production.

## Locale style guides (summary)
- **AR:** Modern Standard Arabic, warm register; second-person feminine (مخاطبة المؤنث) for user-facing copy; avoid over-formal clinical MSA; medical terms with common Arabic name + English in parentheses first use. Line-height 1.7; no italics (use weight).
- **FR:** tutoiement ("tu") for app voice, vouvoiement for legal/medical-formal pages; inclusive but readable.
- **ES:** neutral Latin-American Spanish; "tú"; avoid Spain-only idioms.
- All: reading level ≈ grade 6–8 equivalent; keep translated CTAs ≤ EN length +30% (check truncation).

## RTL QA checklist (every AR release)
- [ ] Layout mirrors correctly (nav, chevrons, progress, charts axes)
- [ ] Mixed LTR content (numbers, English drug names, URLs) renders with proper bidi isolation (`&lrm;`/`<bdi>`)
- [ ] Calendar starts Saturday/Sunday per locale setting; Hijri display option where enabled
- [ ] Forms: labels/placeholders aligned start; validation messages localized
- [ ] Truncation/overflow at 360px width
- [ ] Voice: feminine address consistent

## Definition of done for any string change
All 4 locales have at least machine-draft entries, EN + one other human-reviewed before feature flag opens; portal statuses updated; no raw keys visible.
