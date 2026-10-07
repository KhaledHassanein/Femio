# Owner actions — everything only Khaled can do, in one place

**This is the only file you need to open.** It replaces `BLOCKERS.md`, `OWNER_MANUAL_TASKS.md`
and `MANUAL_TEST_PLAN.md` (archived in `docs/archive/runbooks-2026-09/`, still searchable). Items are
grouped so each section can be done in one sitting. Each one says how long it takes and
what it unblocks.

**Nothing here stops the build.** Every decision has a default the work proceeds on. If you
disagree with a default, say so and the work changes course.

Last updated: 2026-10-07.

> **🔴 (2026-10-07): the live app's sign-in and tracking are down until the billing month resets.** Supabase has
> answered every API request with *402 Payment Required* since 2026-10-06 19:45 UTC: the
> free plan's 5 GB monthly egress was exhausted (8.96 GB, 0 users) by CMS reads. **The leak is
> fixed and live** (#22 merged 2026-10-07; articles ship inside the web build). Staying free, the
> restriction lifts on its own after the reset; nothing to do. **[`OWNER_GUIDE_A_TO_Z.md`](OWNER_GUIDE_A_TO_Z.md)**
> has every remaining step, click by click, written for a non-developer.

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

### D7 · Private launch: health records stay on the phone (proposed 2026-10-07, needs your yes)

You asked to launch without holding health data. Full assessment: [`docs/compliance/PRIVATE_LAUNCH_V1.md`](../compliance/PRIVATE_LAUNCH_V1.md).
**Proposal:** v1 has no accounts; cycle, TTC, pregnancy and symptom records live only on
her phone; predictions run on the phone; backup is a file she saves herself; the tracker is
18+ at launch (articles stay open to all). Cloud sync comes later, once the licences are in
place. **Cost:** a lost phone without a backup loses the record, and iPhone users must add
Femio to the Home Screen. **Gain:** no sensitive-data or cross-border licences, no Supabase
dependency (and no egress) for the app, and a much shorter lawyer engagement (A1).
Disclaimers and waivers cannot do this; the architecture can. *Reply "D7 yes" and Phase 3
is rebuilt on a local store.*

---

## A · Legal and compliance: the real launch gate (start now, runs in the background)

The research made this non-deferrable. Egypt's data-protection licensing for health data is
enforced from **31 October 2026**, and Saudi SDAIA issued 48 violation decisions in 2025.

| # | Action | Time | Unblocks |
|---|---|---|---|
| A1 | **Engage one privacy lawyer** (Egypt-qualified ideally; Saudi + UK by referral). **If D7 is accepted**, the brief shrinks to the four narrow questions in `PRIVATE_LAUNCH_V1.md` §6 (do we need an Egypt controller licence/representative for logs and crash reports only; same for Saudi and UK; review the v1 policy). **Also tell them where Femio's operating entity is registered**; it changes Egypt's answer. Do not reuse the ChatGPT drafts as-is: they assume Firebase and Frankfurt (Femio uses Supabase in Ireland) and cloud sync. | 1 h to brief | launch |
| A2 | **Name a DPO** (can be external) and sign the DPIA §5 (`docs/compliance/`) | 30 min | launch |
| A3 | **Crisis-safety sign-off.** Read the crisis copy in AR/FR/ES (`apps/web/src/lib/crisis/crisis.json`) and confirm the ThroughLine (findahelpline.com) linking terms | 20 min | launch |
| A4 | ✅ **Done by Claude 2026-10-07: `BLOOM-2026`, Production, active from the next deploy.** ~~Set `NEXT_PUBLIC_BETA_INVITE_CODE` in Vercel~~ (web project → Settings → Environment Variables → Production) to any code you choose, then redeploy. **Signup is open to anyone today** while privacy/terms are drafts. | 3 min | closes a live exposure |

## B · People (start now; the long-lead item)

| # | Action | Unblocks |
|---|---|---|
| B1 | **An Arabic-competent medical reviewer**: a named clinician (OB-GYN ideally), credentials, a one-line bio. Arabic content is the whole wedge, and nothing Arabic publishes without a named reviewer. You can be the reviewer if you review Arabic yourself; say so and you are recorded. | Arabic library (Phase 4) |
| B2 | Optional: one or two doctor-creators in Egypt/KSA for launch content (research §6.2) | distribution |

## C · Accounts, keys and settings (one sitting, about 60 minutes)

Do these in order; each says where.

| # | Action | Where | Time |
|---|---|---|---|
| C1 | ✅ **Done 2026-10-07 (#22 merged).** ~~Merge this session's branch into `main`.~~ Vercel deploys from `main`, so the security fix reaches production only after the merge. Open the PR for `claude/epic-planck-5y8geb` and merge once CI is green (or tell the next session it may push to `main` directly, as earlier sessions did). | GitHub | 2 min |
| C2 | **After C1, smoke-test the CMS** at `femio-cms.vercel.app/admin`: log in, open one article. It moved to Payload 3.90 / Next 16. If the admin errors, tell the session. (Moot once D3 retires it.) | browser | 2 min |
| C3 | ✅ **Done 2026-10-07.** ~~Connect the Supabase and Vercel connectors~~ in claude.ai → Settings → Connectors. With them, a session can read usage, the security and performance advisors, logs and deployments directly instead of guessing what the alert emails say. | claude.ai | 5 min |
| C4 | **Forward one of each alert email** you keep getting (Vercel, Supabase, Sentry, GitHub…) or paste the subject lines into the chat. This session can read a message but not search the inbox. | Gmail | 3 min |
| C5 | **Create a free staging Supabase project** (EU), apply migrations to it (`npx supabase@latest link --project-ref <staging>` then `db push`), and set GitHub secrets `E2E_SUPABASE_URL` / `E2E_SUPABASE_PUBLISHABLE_KEY` to **staging**. CI currently signs anonymous users into **production** on every run. | Supabase + GitHub → Settings → Secrets | 15 min |
| C6 | ✅ **Done 2026-10-07, verified in the database.** ~~Apply migrations `0024` + `0025` + the Payload 3.90 column~~: paste `docs/runbooks/sql/2026-10-07_apply_all.sql` into the Supabase SQL editor (guide step 2; no terminal needed). Do it **before merging #22**. **0024** drops three never-used content tables (verified empty 2026-10-07; it refuses to run otherwise). **0025** acts on the Supabase security/performance advisors: it stops visitors with no session calling six account/staff functions over the API (including `handle_new_user`, a trigger that was callable as an RPC), pins six function search paths, drops a duplicate index and adds four missing foreign-key indexes. The session's attempt to apply them was blocked by the permission system, correctly: production schema changes are yours to run. | terminal, repo root | 2 min |
| C6b | **Supabase → Authentication → Settings: turn on "Leaked password protection"** (an advisor finding; a dashboard toggle, not SQL) | Supabase | 1 min |
| C6c | **Purge 442 stale test accounts?** The production project holds 443 accounts, **442 of them anonymous**, all idle 30+ days and none newer than 2026-08-29: CI runs and onboarding tests. 214 hold no data; 228 hold test data. Say *"purge test accounts"* and the next session deletes the 214 empty ones (and, if you say *"all"*, the rest). Nothing is deleted until you say so. | chat | 1 min |
| C6d | ✅ **Done 2026-10-07 (verified: deployments readable).** ~~Re-authorise the Vercel connector for the `khaledhassaneins-projects` scope.** It can list projects and deployments but gets 403 on project settings, logs and usage. | claude.ai → Connectors → Vercel | 2 min |
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

## Publishing an article (new process, 2026-10-07)

Approve and publish in the CMS exactly as before. The website no longer reads the CMS live,
so a new or edited article appears after the next session runs
`node scripts/content/snapshot-cms.mjs` and commits it (Vercel redeploys). Just say
**"publish the new articles"** in the chat.

## Done (kept for reference: nothing to do)

- 2026-10-07 (with the connectors): the error source is confirmed. Supabase's pooler logged **236 "max clients reached" + 172 failed checkouts in 24 h**: the CMS was exhausting the session pool on uncached article renders. Fixed in code by `544bac0` (lists 2.1 MB → 4.2 KB) and the ISR switch (article pages cached for an hour, verified MISS → HIT). Both reach production on merge (C1). Vercel's ignored-build step is verified working: CMS builds for web-only commits now show CANCELED.

- 2026-10-07: CI green; critical advisories patched; Vercel build skipping; Sentry noise filter; Dependabot monthly (session `7abbb2e`, `0b62436`).
- Earlier: Sentry and PostHog EU live; MFA enrolled; Edge Functions `experience`, `patterns`, `partner-view` deployed; migrations 0001–0022 applied (0023 unverified — C6’s `db push` applies it if missing); 100 articles reviewed and published; Google sign-in live.
