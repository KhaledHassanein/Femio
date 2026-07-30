# 19 — Analytics event schema (P1.20)

**Status:** foundation built 2026-07-30 · vendor not yet connected (P1.20.APPLY)
**Owner:** engineering, with compliance sign-off on every schema change
**Enforced by:** `pnpm analytics-lint` (CI) + unit tests in `apps/web/src/lib/analytics/`

## The rule this schema exists to keep

`docs/13_LEGAL_COMPLIANCE.md` §5 and `docs/compliance/DATA_MAP.md` state the same
prohibition twice, because it is the one that would end the company: **no health
data goes to an ad network or a third-party analytics SDK, ever.** The FTC's
actions against Flo (2021) and Premom (2023) were both about this exact failure —
not a breach, but ordinary product analytics carrying reproductive data to
vendors while the privacy policy said otherwise.

A policy sentence cannot enforce that, and neither can careful callers. So the
event layer is built so the unsafe thing is *unrepresentable*.

## How the guarantee is constructed

Three layers, each of which would be sufficient to notice a mistake and none of
which is trusted alone:

1. **A closed catalog** (`lib/analytics/events.ts`). Only the events below may be
   sent. Each declares a fixed set of property keys, and every value must be one
   of that key's enumerated literals. There is **no free-form string, no number,
   and no date anywhere in the schema** — so a symptom label, an article slug, a
   cycle date, or a lab value has no channel to travel down. TypeScript makes an
   unsafe call fail to compile.

2. **A runtime guard** (`lib/analytics/guard.ts`). Types are erased at runtime, so
   the guard re-checks every payload: unknown event, undeclared key, missing key,
   non-string value, or non-allowlisted value → dropped. A health-term denylist
   is the second belt, catching a carelessly widened enum.

3. **A CI ratchet** (`scripts/analytics-lint.mjs`). Tests only cover today's
   schema. The lint fails the build if the *source* drifts: a health-shaped
   property name, a free-form `string`/`number` property, autocapture or session
   recording switched on, or anything tracking the crisis surface.

### Why the guard tokenizes instead of using `\b`

Both the guard and the lint split identifiers on separators and camelCase and
then prefix-match tokens. This is not incidental. An underscore is a word
character, so `/\bcondition\b/` does **not** match `condition_tag` — and
`condition_tag` is precisely the leak the check exists to catch. The first draft
of the lint used `\b` and silently passed an injected `condition_tag` property;
tokenizing catches it. Conversely, plain substring matching is too loose: `age`
would fire on `page`, `language` and `storage`, so short ambiguous stems (`lab`,
`age`) are compared as whole tokens.

## The catalog

| Event | Properties | Notes |
|---|---|---|
| `page_viewed` | `area`, `locale` | Coarse area only — **never a slug or path** |
| `signup_started` | `locale` | |
| `signup_completed` | `locale`, `auth_method`, `outcome` | No `mode` — life-stage is health data |
| `signin_completed` | `locale`, `auth_method`, `outcome` | |
| `calculator_used` | `locale` | **Not** which calculator — see below |
| `language_changed` | `from_locale`, `to_locale` | |
| `app_installed` | `locale` | PWA install |

**Enumerated values**

- `area`: `home` · `library` · `calculators` · `trust` · `auth` · `onboarding` · `app`
- `locale` / `from_locale` / `to_locale`: `en` · `ar` · `fr` · `es`
- `auth_method`: `anonymous` · `email_password` · `magic_link` · `google`
- `outcome`: `success` · `error`

## Deliberate exclusions, and why

These are the judgement calls a reviewer should check, not incidental gaps.

- **Article and condition slugs.** `/learn/endometriosis-symptoms` attached to a
  pseudonymous `distinct_id` is a health inference about a person. `area` collapses
  `/learn`, `/conditions`, `/faq` and `/glossary` into `library` for the same
  reason — even the section split leaks something.
- **Which calculator was used.** "Used the due-date calculator" implies pregnancy;
  "fertile window" implies trying to conceive. Per-tool demand is a legitimate
  product question, but it is a *first-party* one (P1.20.3), not a vendor one.
- **Life-stage mode, persona/condition tags, age bands.** The original P1.20 line
  named these as PostHog dimensions. They cannot be: each is special-category data
  under GDPR Article 9. They move to the first-party dashboard (P1.20.3), computed
  by aggregate SQL over our own RLS-protected Postgres with k-anonymity thresholds.
- **The crisis surface.** Opening crisis help reveals mental-health intent.
  ADR-013 already guarantees `useCrisisHelp().open()` takes no payload and fires no
  analytics; `FORBIDDEN_AREAS` turns that promise into a failing test, and the lint
  rejects any `track("...crisis...")` call anywhere in the app.
- **Autocapture and session recording.** Both bypass the catalog entirely —
  autocapture scrapes DOM text (symptom labels, article titles), session recording
  captures health fields on screen. They must stay off; the lint enforces it.

## Consent

Analytics is **non-essential**, so it is opt-in and fails closed (docs/13 §6: "no
non-essential cookies/SDKs fire before consent").

`insights` is **not** the governing purpose. It reads *"Use my entries to show me
patterns and insights"* — first-party processing of her own data to show her
something. Reusing it as permission to send events to a vendor would be exactly
the purpose creep the FTC pursued Flo for. Migration `0005` therefore adds a
distinct `analytics` purpose to `consent_records`.

No consent UI exists yet (**P1.20.2**), so no user has granted this purpose and
`track()` is off for everyone today. Adding the purpose grants nothing; it only
makes a future grant recordable.

## Residency

PostHog runs separate US and EU clouds and **the SDK defaults to the US host**, so
a missing or copy-pasted host would silently create an international transfer with
no mechanism behind it. `NEXT_PUBLIC_POSTHOG_HOST` must be an `https://` PostHog
EU host, a key without a host is rejected, and either mistake **fails the build**
rather than shipping — the same posture as the crisis directory link.

Verified 2026-07-30: US host → build exits 1; key with no host → build exits 1;
`https://eu.i.posthog.com` → build exits 0.

## Current state

Unset key → the whole layer is a verified no-op and **no vendor script loads at
all**. That is the correct state, not a placeholder: loading an analytics SDK
before a signed DPA and a consent toggle exist would itself be the violation.

## Changing this schema

A schema change is a compliance change. In the same PR: update
`lib/analytics/events.ts`, this document, and `docs/compliance/DATA_MAP.md`, then
fill the feature-review gate in `docs/13` §9 (fields added? consent group? data
map updated? third parties? retention? minors?). `pnpm analytics-lint` and the
unit tests must pass without weakening a rule to get there.
