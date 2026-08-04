# Femio — Session State & Handover (2026-08-04)

Supersedes `HANDOVER_STATE_2026-07-30.md`. Read this + `CLAUDE.md` +
`docs/07_MASTER_TODO.md` + `docs/runbooks/OWNER_MANUAL_TASKS.md` first.

## TL;DR

Femio is live on Vercel (EU): a content-first public site (`femio-web.vercel.app`,
domain `femioapp.com` purchased, **not yet connected**) with the tracker app as its
portal, plus a Payload CMS on the shared Supabase Postgres. Since the last handover the
security pass finished (audit at **0 advisories**, CSP/headers, staff MFA, Sentry,
analytics), the content pipeline was commissioned, and **31 article drafts** have arrived
from the content assistant.

**Two things are mid-flight and need attention first — see "Start here".**

## Start here (in this order)

1. **Verify the CMS deploy actually landed.** Production API was healthy at handover time
   but the migration had *not* applied (`payload_migrations` = `dev` only, `articles_rels`
   absent), which means the deploy of `33ec508` (publishing fields + migrations) had
   failed rather than shipped. Commit `31644cf` fixes the likely cause. Check:
   ```bash
   curl -s -o /dev/null -w "%{http_code}\n" https://femio-cms.vercel.app/api/articles?limit=1   # want 200
   # and confirm the schema arrived:
   #   payload.payload_migrations should contain the two migration names
   #   payload.articles_rels should exist
   ```
   If the API 500s → the code deployed without its schema again; run
   `pnpm --filter cms migrate` locally (`.env.local` has the production DATABASE_URL) and
   it recovers. If the API is 200 but the migration is missing → the deploy hasn't run;
   check Vercel's build logs for `femio-cms`.
2. **Content-lint, then the importer** (P1.9.1 / P1.9.2 below). This is the recommended
   next work and the owner has approved it.

## Done since 2026-07-30 (lead commits)

- **P1.9b.3a/b** privacy + terms as marked drafts (ADR-015); author/reviewer bio pages
  with Person schema (ADR-016).
- **P1.6.4/C3.7** CMS admin bootstrap script — no admin existed, publishing was impossible
  (ADR-018). **P1.20.2** consent manager; **P1.20.3** first-party k-anonymous insights
  dashboard with secondary suppression (ADR-020, migration 0006 applied).
- **P1.23.1** dependency ratchet + security headers (ADR-021) — and the **500-instead-of-404**
  fix on every unknown content URL, plus the localized 404 (P1.2.2).
- **P1.23.2** next-intl v3→v4 (ADR-022) — audit now **0 advisories**. Tested and disproved
  that v4 fixes `notFound()` under ISR, so the three CMS detail routes stay `force-dynamic`
  (P1.23.2b).
- **P1.23.3** staff MFA, enforced on `/admin/*` (ADR-023) + **P1.23.3b** recovery script;
  **P1.2.4** global-error boundary (ADR-024).
- **P1.20.1/P1.20.4** PostHog wired and emitting (ADR-025, ADR-027) — URL stripped from
  every event; the page declares its area as a literal so no code path turns a path into an
  event. **P1.4.2** Sentry (ADR-026) — route patterns, no bodies/user/extra, EU-only DSN.
- **P1.6.6** public bylines + SEO fields; **P1.6.5/P1.6.6b** Payload **migrations adopted**
  after those fields took production down for ~1h (ADR-029 — read it, the lesson is about
  verification, not Payload).
- **ADR-028** health-not-medical positioning (owner direction): decorative "medical"
  framing → clinician-framed; disclaimers keep the word verbatim; boundary line moved above
  the article body.
- **P1.9** commissioned: `docs/content/CODEX_AUTHORING_BRIEF.md` is the assistant's working
  prompt. **31 drafts** now in `docs/content/articles/`.

## Open, in recommended order

1. **P1.9.1 content-lint** (approved, not started). A `scripts/content-lint.mjs` in the
   same ratchet pattern as claims/crisis/analytics-lint, checking the brief mechanically:
   front-matter key parity + required keys, `status: draft`, forbidden claim verbs, source
   count ≥2 with ≥1 Tier-1 and resolvable URLs, `meta_title`/`meta_description` uniqueness
   **across the set**, slug ↔ `canonical_url` agreement, internal links resolving to routes
   that exist, structural requirements (answer-first opening, "When to see a doctor",
   red-flag box), and health-not-medical framing per ADR-028. Judgement stays human.
   Known signals already: **7 files** use medical framing that post-dates ADR-028; one file
   (`how-endometriosis-is-assessed.md`) mentions "diagnos" — inspect in context, describing
   clinical assessment is allowed.
2. **P1.9.2 Markdown → Payload importer** (approved, not started). There is currently **no
   way to get the drafts into the CMS**; the path is a human pasting 60 articles by hand,
   which would silently drop the front-matter fields P1.6.6 just added columns for. The
   importer should refuse malformed input, so the brief's schema becomes a specification
   rather than an aspiration. Publication still goes through the review gate.
3. **P1.9 review** of batches 1–3, using (1). The owner will ask for it.
4. **P1.11.1 CWV/Lighthouse budget in CI** and **P1.11.2** trimming the i18n payload (every
   page ships the whole locale catalog; `/en/learn` was ~56 KB and embedded privacy/terms
   copy it never renders).
5. **P1.6.7–P1.6.13** — the CMS/SEO recommendations, incl. publication-gate hardening
   (needs a health/marketing content split first) and review-expiry surfacing.

## Owner tasks outstanding (`docs/runbooks/OWNER_MANUAL_TASKS.md`)

- **Custom domain** `femioapp.com` → task F, four steps. Do it **before** the content push:
  every article's canonical/hreflang/sitemap entry is built from `NEXT_PUBLIC_APP_URL`.
- **Remove `PAYLOAD_DB_PUSH`** from the femio-cms Vercel env (now ignored by code, but tidy).
- **PostHog DPA** + "Discard client IP data"; **ThroughLine** confirmation email (drafted at
  `docs/compliance/THROUGHLINE_LINK_CONFIRMATION.md`).
- **P0.12 legal/DPO gate** — the long-lead item; blocks real users. Includes **P0.12.4**
  (replace the draft privacy/terms text, then un-noindex and add to the sitemap).

## Environment gotchas (hard-won)

- **Run e2e in CI mode before pushing:** `CI=1 pnpm --filter web test:e2e:ci` after a fresh
  build. `next dev` renders everything dynamically, so a green local run proves nothing
  about production — that gap hid the 500-instead-of-404 for weeks.
- **`pkill -f "next start"` does NOT kill the server on Windows.** Kill by port:
  `Get-NetTCPConnection -LocalPort 3000 -State Listen | %{ Stop-Process -Id $_.OwningProcess -Force }`.
  A stale server serving an old build invalidates every measurement taken after it.
- **Underscore-prefixed folders (`__foo/`) are private in the App Router** — a scratch route
  named that way never registers and 404s, which looks like a passing test.
- **i18n catalogs are CRLF.** Use start-of-line regex anchors, never substring anchors: a
  two-space `  "learn": {` also matches inside the six-space nested `home.sections.learn`,
  which silently put keys in the wrong namespace across all four locales.
- **Verify against the deployed thing, not just the code.** The CMS build never connects to
  the database, so builds and 154 unit tests all passed while production was broken. Hit the
  API after a CMS deploy.
- **`apps/cms/.env.local` holds the PRODUCTION connection string.** Any command that
  migrates from a local build touches live data — that is why `migrate-on-deploy.mjs` runs
  only when `VERCEL_ENV === "production"`.
- Supabase project `wnthtqtcajkhskdygbgo` (EU). Both Vercel projects auto-deploy from `main`.

## How to resume (new chat)

Open `E:\Femio` and paste the prompt in `docs/HANDOVER_PROMPT_2026-08-04.md`.
