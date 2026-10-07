# Owner actions — everything only Khaled can do, in one place

**This is the only file you need to open.** It replaces `BLOCKERS.md`, `OWNER_MANUAL_TASKS.md`
and `MANUAL_TEST_PLAN.md` (archived in `docs/archive/runbooks-2026-09/`, still searchable). Items are
grouped so each section can be done in one sitting. Each one says how long it takes and
what it unblocks.

**Nothing here stops the build.** Every decision has a default the work proceeds on. If you
disagree with a default, say so and the work changes course.

Last updated: 2026-10-07.

---

## 0 · Decisions: ✅ all six accepted as defaults (owner, 2026-10-07)

Khaled replied *"Go with all your recommended defaults"*. D1–D6 below are therefore **decided**, not pending. Each one still names its alternatives, in case a later conversation reopens it.

| # | Decision | Decided (2026-10-07) | Alternatives not taken |
|---|---|---|---|
| **D1** | **Launch wedge** | **TTC → pregnancy, with PCOS/irregular cycles as depth.** Every stage stays reachable; this sets emphasis and marketing. (`30.03` §2.1) | (b) whole-life launch, all stages equal · (c) cycle tracking first |
| **D2** | **Route to the stores** | **Web PWA first → Google Play via TWA within days of the web revamp → Flutter (iOS + full Android) after launch signal** (`30.03` §2.3) | (b) Flutter now, no store presence until it is done (months) · (c) Capacitor wrapper for both stores |
| **D3** | **Retire Payload CMS** | **Yes.** Articles publish from the Markdown in the repo. You approve by saying so (as with "postpartum approved"), and the session flips the frontmatter. Removes a second production app and its security surface. | (b) keep Payload as the editing UI |
| **D4** | **Launch markets** | **Saudi Arabia + Egypt, Arabic first; UAE next; EU web-only** (`30.02` §10) | name others |
| **D5** | **Target date for the soft launch (50–100 women)** | **Week of 2026-11-30.** Phases 1–4 at the pace in `30.03` §5. | pick a date |
| **D6** | **Visual direction "Dusk Bloom"** (plum · rose · peach · saffron on porcelain) | **Proceed.** You see it in screenshots at the Phase 1 checkpoint and can redirect then. | describe what you want instead |

---

## A · Legal and compliance: the real launch gate (start now, runs in the background)

The research made this non-deferrable. Egypt's data-protection licensing for health data is
enforced from **31 October 2026**, and Saudi SDAIA issued 48 violation decisions in 2025.

| # | Action | Time | Unblocks |
|---|---|---|---|
| A1 | **Engage one privacy lawyer** (MENA + EU) with three questions: (1) does Egypt PDPL licensing apply to Femio as a foreign controller of Egyptian residents' health data; (2) do Saudi PDPL transfer rules allow EU (Frankfurt) hosting; (3) final privacy policy + terms from our drafts (`/privacy`, `/terms`) | 1 h to brief | launch |
| A2 | **Name a DPO** (can be external) and sign the DPIA §5 (`docs/compliance/`) | 30 min | launch |
| A3 | **Crisis-safety sign-off.** Read the crisis copy in AR/FR/ES (`apps/web/src/lib/crisis/crisis.json`) and confirm the ThroughLine (findahelpline.com) linking terms | 20 min | launch |
| A4 | **Set `NEXT_PUBLIC_BETA_INVITE_CODE` in Vercel** (web project → Settings → Environment Variables → Production) to any code you choose, then redeploy. **Signup is open to anyone today** while privacy/terms are drafts. | 3 min | closes a live exposure |

## B · People (start now; the long-lead item)

| # | Action | Unblocks |
|---|---|---|
| B1 | **An Arabic-competent medical reviewer**: a named clinician (OB-GYN ideally), credentials, a one-line bio. Arabic content is the whole wedge, and nothing Arabic publishes without a named reviewer. You can be the reviewer if you review Arabic yourself; say so and you are recorded. | Arabic library (Phase 4) |
| B2 | Optional: one or two doctor-creators in Egypt/KSA for launch content (research §6.2) | distribution |

## C · Accounts, keys and settings (one sitting, about 60 minutes)

Do these in order; each says where.

| # | Action | Where | Time |
|---|---|---|---|
| C1 | **Merge this session's branch into `main`.** Vercel deploys from `main`, so the security fix reaches production only after the merge. Open the PR for `claude/epic-planck-5y8geb` and merge once CI is green (or tell the next session it may push to `main` directly, as earlier sessions did). | GitHub | 2 min |
| C2 | **After C1, smoke-test the CMS** at `femio-cms.vercel.app/admin`: log in, open one article. It moved to Payload 3.90 / Next 16. If the admin errors, tell the session. (Moot once D3 retires it.) | browser | 2 min |
| C3 | **Connect the Supabase and Vercel connectors** in claude.ai → Settings → Connectors. With them, a session can read usage, the security and performance advisors, logs and deployments directly instead of guessing what the alert emails say. | claude.ai | 5 min |
| C4 | **Forward one of each alert email** you keep getting (Vercel, Supabase, Sentry, GitHub…) or paste the subject lines into the chat. This session can read a message but not search the inbox. | Gmail | 3 min |
| C5 | **Create a free staging Supabase project** (EU), apply migrations to it (`npx supabase@latest link --project-ref <staging>` then `db push`), and set GitHub secrets `E2E_SUPABASE_URL` / `E2E_SUPABASE_PUBLISHABLE_KEY` to **staging**. CI currently signs anonymous users into **production** on every run. | Supabase + GitHub → Settings → Secrets | 15 min |
| C6 | **Apply migration `0024`** when it lands (drops three never-used content tables; it refuses to run if any holds a row): `npx supabase@latest db push` | terminal, repo root | 2 min |
| C7 | **Vercel: confirm Root Directory** = `apps/web` (web project) and `apps/cms` (CMS project), and that **Settings → Git → Ignored Build Step** is *not* overridden in the dashboard, so the new `vercel.json` rule applies. | Vercel | 3 min |
| C8 | **Google Search Console**: add `femioapp.com` as a Domain property (DNS TXT), submit `https://femioapp.com/sitemap.xml` | GSC + DNS | 10 min |
| C9 | **Google Play Console account** ($25 one-off). **Note:** a new *personal* account must run a closed test with **12 testers for 14 days** before production. An *organisation* account (needs a D-U-N-S number) avoids that. Choose before Phase 4. | play.google.com/console | 20 min |

## D · Things that need your eyes (batched at checkpoints; the session tells you when)

| # | When | What |
|---|---|---|
| D-1 | Phase 1 checkpoint | Approve or redirect the Dusk Bloom look from ~6 screenshots (light, dark, Arabic) |
| D-2 | Phase 2 | Approve the illustration set (~60 pieces) in one pass |
| D-3 | Phase 2 | Read the new Arabic homepage copy as a native speaker |
| D-4 | Phase 3 | Walk the TTC and pregnancy journeys on your phone (a recorded walkthrough is provided) |
| D-5 | Phase 3 | Clinician check of the PCOS screener wording (must screen, not diagnose) |

## E · At launch (Phase 4; not yet)

| # | Action | Cost |
|---|---|---|
| E1 | **Supabase Pro** (daily backups, no pausing; PITR optional) | $25/mo |
| E2 | **Custom SMTP** for sign-in email: Resend or Postmark, EU region, domain DNS (SPF/DKIM) | free tier → ~$15/mo |
| E3 | Web-push keys (`npx web-push generate-vapid-keys`; public half → `NEXT_PUBLIC_VAPID_PUBLIC_KEY`) | free |
| E4 | Remove `NEXT_PUBLIC_BETA_INVITE_CODE` (opens signup) on launch day | — |

---

## Done (kept for reference: nothing to do)

- 2026-10-07: CI green; critical advisories patched; Vercel build skipping; Sentry noise filter; Dependabot monthly (session `7abbb2e`, `0b62436`).
- Earlier: Sentry and PostHog EU live; MFA enrolled; Edge Functions `experience`, `patterns`, `partner-view` deployed; migrations 0001–0022 applied (0023 unverified — C6’s `db push` applies it if missing); 100 articles reviewed and published; Google sign-in live.
