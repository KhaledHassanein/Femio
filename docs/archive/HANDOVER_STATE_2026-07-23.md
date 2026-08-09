# Femio — Session State & Handover (2026-07-23)
Restore point for resuming work without context loss. Read this + `CLAUDE.md` + `docs/07_MASTER_TODO.md` first.

## TL;DR — where we are
Femio is a **working, live product** on Vercel (EU, `https://femio-web.vercel.app`): onboarding → dashboard → cycle tracking + uncertainty-honest predictions → symptom logging → GDPR export/delete → offline sync, in **EN/AR/FR/ES (RTL-native)**. Backend is Supabase (schema + RLS + anonymous auth, applied & verified live). CMS is Payload 3 in `apps/cms` (code complete, not yet connected). 36 unit tests + 4 Playwright e2e all green.

## Done this session (all committed + pushed to GitHub `main`)
P0.10.2 (GitHub) · P1.2 scaffold · P1.3 Supabase (schema/RLS/auth, **applied live**) · P1.4 CI + claims-guard · P1.5 design system · P1.6 Payload CMS · P1.7 editorial policy · P1.8 condition IA · P1.10 calculators · P1.11 technical SEO · P1.12 onboarding · P1.13 cycle tracking + predictions · P1.14 symptoms · P1.15 dashboard · P1.16 GDPR export/delete · P1.17 offline logging · app-nav shell · Playwright e2e harness (partial P1.22). Details in `docs/CHANGELOG.md` + `docs/DECISIONS.md` (ADR-008…012).

**Critical fix this session:** `env.ts` was validating the whole `process.env` (empty in the client bundle) → every signed-in page crashed on hydration in prod. Fixed by referencing each `NEXT_PUBLIC_*` explicitly. **Pattern to remember: never `safeParse(process.env)` wholesale in code that reaches the client.** Caught only by Playwright (SSR/curl couldn't see it).

## Gates status
- **Medical review (P0.22): ✅ COMPLETE** — tracker Summary = 0 open / 432 resolved. P1.9 content sourcing unblocked. (Per-article + per-locale reviewer sign-off in the CMS at publish is still the final per-page gate; doc 15.)
- **Legal/counsel + DPO (P0.12): OPEN** — the launch gate for real user health data. Khaled.
- **CMS go-live: OPEN** — `apps/cms/.env.local` still has PLACEHOLDER `DATABASE_URL` + `PAYLOAD_SECRET`. Fill: `DATABASE_URL` = Supabase → Settings → Database → **Session pooler** URI (user = `postgres.wnthtqtcajkhskdygbgo`, host `...pooler.supabase.com:5432`); `PAYLOAD_SECRET` = `openssl rand -base64 32`. Then create schema + first admin (`docs/runbooks/cms_setup.md`).
- **Apply migration 0003** (delete_account RPC) to remote — Khaled (delete already cascades via client fallback).
- **Optional:** Sentry DSN, Google Search Console verify + submit sitemap, custom domain.

## ⏭️ NEXT TASK (agreed): implement the Global Crisis-Safety Routing plan
Approved approach (assessed sound + safer than country-specific numbers). **Use ONLY the reviewer-approved wording in `docs/compliance/CRISIS_RESOURCES.md`.** Build:
- Public `/{locale}/help-now` — no account/questionnaire/health-data; `noindex`; **exclude from sitemap** (edit `apps/web/src/app/sitemap.ts`); renders approved copy.
- A fixed 44px "Need help now?" launcher mounted in the **locale layout** so it's on public + onboarding + calculator + signed-in pages.
- An accessible native `<dialog>` opening immediately (not nav-dependent): immediate-danger + **"call your local emergency number OR go to the nearest emergency department"** + worried-about-someone guidance + a clearly-separate external-directory action. **No promises** about cost/confidentiality/hours/language/dispatch.
- Render fallback content in the page shell so it works offline/after-load.
- `useCrisisHelp().open()` internal API — accepts **no** reason/score/country/health-data payload.
- Optional `NEXT_PUBLIC_CRISIS_DIRECTORY_URL` (canonical Find A Helpline HTTPS only; unset → link hidden, fallback still works; malformed/unexpected host → **fail the build**). Open same-context, no query params, `referrerPolicy="no-referrer"`. Never embed/proxy/cache directory data.
- Crisis-locale **review manifest** (status, reviewer, review date, next-review). EN = approved Mohamed K. copy; AR/FR/ES render the **EN fallback marked `lang="en"` `dir="ltr"`** until human locale sign-off. Enabling a translation needs key-parity + reviewer sign-off + new 12-month date.
- **CI compliance check** failing on: expired medical copy (deadline 2027-07-23), approved translations missing review metadata, translation-key mismatches.
- **No analytics** on the crisis interface (opening it could reveal mental-health intent).
- Playwright tests: launcher works unauthed across 4 locales, keyboard/SR-accessible, focus trap + Escape, RTL, offline still opens fallback, only approved directory host accepted + no referrer/identifiers leak, pending translations render EN fallback with correct `lang`/`dir`.

**My 5 pre-merge caveats (from the assessment):** (1) re-frame the WHO citation as "modeled on WHO's global-to-local adaptation approach," not a crisis endorsement (the link is WHO's SMBP Digital Adaptation Kit); (2) log the global-only decision as an **ADR** + a DPIA line, with medical + DPO sign-off; (3) make the "local emergency number OR nearest ED" wording explicit in approved copy; (4) keep country packs non-speculative (later verified market modules); (5) minors: account-less global availability is correct since the app collects/reports nothing.

## Environment gotchas (this machine)
- **pnpm** installed via npm-global; on PATH at `C:\Users\slash\AppData\Roaming\npm`. Run scripts from repo root.
- pnpm 11 blocks native build scripts → approved via **`allowBuilds:`** (NOT `onlyBuiltDependencies`) in `pnpm-workspace.yaml`. Vercel runs `CI=true` → unapproved builds are FATAL.
- Vercel needs `NEXT_PUBLIC_APP_URL`, `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` set (already done). `NEXT_PUBLIC_*` bake in at build → change requires a **clean rebuild**.
- **Playwright** installed (chromium-1228). Run e2e: `cd apps/web && npx playwright test`. Config auto-starts `pnpm dev`; tests hit **live** Supabase (create throwaway anon users). Offline emulation via `context.setOffline()`.
- Supabase project ref: `wnthtqtcajkhskdygbgo` (EU). Anonymous sign-ins ENABLED. Migrations 0001/0002 applied; **0003 pending**.
- Line-ending warnings (LF→CRLF) on commit are benign.
- Verify DB/RLS from Node with `@supabase/supabase-js` + the publishable key (see prior scripts): consent gate + owner-only RLS + GDPR cascade all proven live.

## How to resume (new chat)
Open `E:\Femio` in Claude Code and say: *"Read CLAUDE.md, docs/07_MASTER_TODO.md, and docs/HANDOVER_STATE_2026-07-23.md. Continue: implement the Global Crisis-Safety Routing plan using only the approved wording in docs/compliance/CRISIS_RESOURCES.md, following the 5 caveats. Verify with Playwright (incl. offline + RTL). Small commits, update docs, push."*
