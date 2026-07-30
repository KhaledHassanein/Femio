# Femio — Session State & Handover (2026-07-30)

Restore point for resuming without context loss. Read this + `CLAUDE.md` +
`docs/07_MASTER_TODO.md` + `docs/runbooks/OWNER_MANUAL_TASKS.md` first. The
`resume-pointer` auto-memory also loads each session.

## TL;DR — where we are
Femio is a **working, live product** on Vercel (EU), and now a **content-first public
website** with the tracker app as its portal:
- **Public site:** content-first homepage → **Learn · Conditions · Calculators · FAQ ·
  Glossary** → **About · Editorial policy · Medical review**, with a persistent global
  header + footer, structured data (MedicalWebPage/FAQPage/DefinedTermSet/Breadcrumb),
  per-locale sitemap, EN/AR/FR/ES + RTL, and graceful empty states until the CMS has content.
- **Content** is read from **Payload CMS** (live on its own Vercel deploy on the shared
  Supabase Postgres). CMS shows real content once `NEXT_PUBLIC_CMS_URL` is set on the web app.
- **App (signed-in):** onboarding → dashboard → cycle tracking w/ month **calendar + flow +
  fertile/ovulation overlay** → **per-symptom** logging + custom symptoms → uncertainty-honest
  predictions → GDPR export + **doctor-visit summary/print-to-PDF** → offline sync.
- **Auth:** password + passwordless magic link + Google (gated) + reset/set-password.
- **Trust/safety:** global crisis-safety routing (/help-now + launcher); translation portal
  (/admin/translations) with CSV Excel round-trip; claims + crisis + RLS CI/manual guards.

All changes are on `main`; pushing auto-deploys both Vercel projects (web + cms).

## Done since the 2026-07-23 handover (with lead commits)
- **P1.26** crisis-safety routing (ADR-013) · **P0.12.3** cross-link.
- **P1.22a/P1.5.2** axe a11y + DB-free e2e in CI; fixed 2 real AA contrast bugs.
- **P1.23** RLS/security audit (`pnpm rls-audit`, 12/12 live) + `SECURITY_REVIEW.md`.
- **P1.18** RBAC foundation (`apps/web/src/lib/auth/`, `docs/18_RBAC_MODEL.md`).
- **P1.13.1** calendar+flow · **P1.13.2** fertile/ovulation · **P1.14.1** symptom severity+custom · **P1.16.1** doctor-visit summary/PDF.
- **P1.19** translation portal + **P1.19.2** CSV import/export (ADR-014 DB-overlay i18n loader).
- **P1.12.1** password + Google + magic-link sign-in, reset/set-password.
- **CMS live** (fixes: TLS on DB pool; `service_role` grants = migration **0004**; Payload isolated in **`payload`** schema; missing `@payloadcms/next/css` admin styles).
- **P1.6.2** web reads published CMS content → `/learn`; **Conditions**, **FAQ**, **Glossary** (P1.11.1 partial: content JSON-LD + dynamic sitemap).
- **P1.9b** content-first homepage · **P1.9b.1** persistent header/footer via `[locale]/(public)/` route group · **P1.9b.2** About/Editorial/Medical-review trust pages (+ fixed a latent unflatten array bug in the i18n overlay).

## Architecture notes (current)
- Route groups: `[locale]/(public)/` (home + library + trust pages, has SiteHeader/SiteFooter);
  `[locale]/(app)/` (dashboard/track/settings/summary/admin, has AppNav); auth/onboarding/
  crisis/components pages sit directly under `[locale]` with their own minimal layouts. Route
  groups don't change URLs.
- CMS: Payload 3 in `apps/cms`, tables in the **`payload`** schema (isolation prevents clobbering
  the app's `public` tables). Schema push is interactive → schema was created via a one-time local
  `pnpm --filter cms dev`; the serverless deploy just uses it. TLS + service_role grants required.
- i18n: local JSON catalogs are the base; the translation portal's **human-approved** `ui_strings`
  rows overlay on top (cached; `unflatten` is array-safe). `NEXT_PUBLIC_CMS_URL` (web) points at the CMS.
- CMS content reader: `apps/web/src/lib/cms/` (published-only, locale-aware, graceful). Shared
  `ContentArticle`/`ContentHub`/`TrustPage` components; lightweight Lexical→React renderer.

## Owner manual tasks / gates (see docs/runbooks/OWNER_MANUAL_TASKS.md)
- **Show real content:** set `NEXT_PUBLIC_CMS_URL` on the **web** Vercel project + publish an article (C3.5). Until then content pages show empty states (correct).
- **Auth email:** Supabase Auth redirect URLs must include the web origins (B★); custom SMTP for launch. Optional: Google provider + `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH=true` (B★★).
- **P0.12 legal/DPO launch gate:** entity/DPO, privacy+terms finalized, DPIA signed (incl. crisis global-only posture P1.26.1), consent wording. Blocks real-user launch.
- **P1.20 analytics:** needs a PostHog (EU) account/key.
- Apply migration **0003** (delete_account) if not yet; `0004` (service_role) already applied for CMS.

## Next tasks (in order)
1. **P1.9b.3** — Privacy + Terms pages as clearly-marked *drafts* (counsel finalizes, P0.12) + author/reviewer **bio pages** (Person schema) — the latter with P1.9 content.
2. **P1.20 analytics** — with a PostHog key; else build a no-op, **health-field-free** analytics guardrail (consent-gated) as foundation.
3. **P1.23 remaining** — `pnpm audit`/Dependabot in CI, CSP/security headers, staff MFA, Sentry + breach alerting, independent pen-test.
4. **P1.21 moderation/CS** — premature until there's user-generated content.
5. **P1.24 beta → P1.25 launch** — gated by P0.12.
   (Consumer follow-ups available anytime: P1.13.1 visual calendar polish, P1.14.1 full 100+ taxonomy via portal, P1.16.1 PDF doctor-summary polish.)

## Environment gotchas (this machine)
- pnpm on PATH (npm-global); run scripts from repo root. Commit to `main`; Vercel auto-deploys web + cms.
- Playwright: `cd apps/web && npx playwright test`. DB-free subset (CI): `pnpm --filter web test:e2e:ci` (= `--grep-invert @live`). **Kill port 3000 between back-to-back local runs** (`Get-NetTCPConnection -LocalPort 3000` → Stop-Process) or the next run cascade-fails on a webServer timeout. Config runs `workers:1`.
- CI (ci.yml): claims-lint, crisis-lint, lint, typecheck, unit, build, then DB-free e2e + axe; CMS build in a second job.
- Guards: `pnpm claims-lint` (no clinical claim verbs in EN UI copy), `pnpm crisis-lint`, `pnpm rls-audit` (live), crisis-compliance.
- **i18n edits:** message files are **CRLF**; use CRLF-aware targeted string inserts (anchor on `  "settings": {` / `  "home": {` etc.). **Never** rewrite whole JSON with `JSON.stringify` (reformats inline objects → huge diffs).
- Never `safeParse(process.env)` wholesale in client-reachable code (crashes hydration).
- Supabase project ref `wnthtqtcajkhskdygbgo` (EU). LF→CRLF git warnings are benign.

## How to resume (new chat)
Open `E:\Femio` and say:
*"Read CLAUDE.md, docs/07_MASTER_TODO.md, docs/HANDOVER_STATE_2026-07-30.md, and
docs/runbooks/OWNER_MANUAL_TASKS.md. Continue the Femio Phase-1 build in order — next is
P1.9b.3 (draft Privacy/Terms pages + author/reviewer bio scaffolding). Work in small commits,
verify (build/typecheck/lint/claims-lint/e2e), update DECISIONS/CHANGELOG/TODO, and push to main."*
