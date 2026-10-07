# 30 — Revamp progress

The checkpoint ledger for `03_REVAMP_PLAN.md` §5. **Update it in the same commit as the
work.** Marks: `[ ]` open · `[~]` in progress · `[x]` done (commit) · `[BLOCKED]` · `[DEFERRED]`.

## Phase 0 — Stabilise and clean

- [x] P0.1 · Critical advisories patched (Payload 3.90.2, Next 16.3.8 CMS / 15.5.27 web); CI + gate green (`7abbb2e`)
- [x] P0.2 · Vercel ignored-build step per app; Sentry noise filter; Dependabot monthly (`0b62436`)
- [x] P0.3 · Audit, market research, plan, single `OWNER_ACTIONS.md`
- [x] P0.4 · Governance collapse: short `STATE.md`; superseded plans and runbooks → `docs/archive/`; V1 Flutter reference removed from tree
- [x] P0.5 · Migration `0024`: guarded drop of `content`, `content_i18n`, `content_history`; `0025`: advisor hardening (owner applies both: C6)
- [x] P0.6 · CMS lists select only their fields: 2.1 MB → 4.2 KB (`544bac0`); article/condition/author pages are ISR (hourly), verified MISS → HIT and 404 for unknown slugs in en+ar. Root cause of the error emails confirmed in Supabase logs: `EMAXCONNSESSION` (pool exhaustion), hundreds/day

## Phase 1 — Design language v3 "Dusk Bloom" ✅ (2026-10-07, pending owner D-1)

- [x] P1.1 · Dusk Bloom palette: plum/rose/peach/saffron/sage + porcelain neutrals, light + dark, every pairing contrast-checked (white on solids 5.6–7.9:1); JSON mirror regenerated from the CSS
- [x] P1.2 · Type: Newsreader · Plus Jakarta Sans · Noto Naskh Arabic · IBM Plex Sans Arabic, per-glyph stacks (no locale branching); Instrument Serif tried and rejected (cramped at UI sizes)
- [x] P1.3 · Aurora + grain on the home hero (white text ≥ 6.9:1 measured on rendered pixels, EN + AR); scroll-driven `.reveal` on home sections (CSS `view()` timeline, `@supports`-gated so content can never stick invisible); the prediction window band breathes (`.band-breathe`); all stop under reduced motion
- [x] P1.4 · Pill buttons with plum glow, 24px cards, 48px inputs, white hero-card highlight; prediction band moved amber → saffron
- [x] P1.5 · Header rebuilt (one row of actions + scrolling sections, sticky, frosted; visible "Need help now?" link); launcher a compact 44px lifebuoy (ADR-013 kept); footer grouped Explore/Trust/Legal on plum
- [x] P1.6 · App shell: tabs Today · Calendar · Log · Learn · Tools; Settings → header gear; the tab bar follows a signed-in woman onto public Learn pages (session read locally, no network)
- [x] P1.7 · Checkpoint photographed at 390×844 (home, Learn, article, gallery × en/ar × light/dark). Found and fixed a live Arabic defect: English-fallback articles rendered RTL with punctuation at the wrong end; content now carries `lang`/`dir` and an "not translated yet" note. **App screens not photographed**: seeding creates accounts on production (442 already), so they wait for the staging project (OWNER_ACTIONS C5). Owner D-1 review due.

## Phase 2 — Public site

- [x] P2.1 · **Content from the repo (D3 step 1)**: `scripts/content/snapshot-cms.mjs` → `apps/web/src/content/snapshot/` (100 articles, 5 conditions, 1 bio); `lib/cms/client.ts` reads it with unchanged signatures; 589 pages prerendered, sitemap 99 → 161 URLs; zero DB reads per page view (root cause of the 8.96/5 GB egress restriction). Payload stays the editor until full retirement (P2.8)
- [x] P2.2 · **Search without the database**: `/api/search-index/{locale}` is a static file built from the snapshot (titles, summaries, section headings; 69 KB raw, ~15 KB on the wire) and ranked in the browser by `lib/search`, which now also answers questions ("bleeding after birth") and finds a word after a mid-word miss. Replaces the `search_content` RPC, which cost egress on every keystroke and failed outright under the 402. English titles on Arabic results keep their punctuation (`dir="auto"`). `e2e/search.spec.ts` asserts no Supabase request (2026-10-07)
- [x] P2.3 · **Homepage rebuilt as the app's front door** (D8): hero with the drawn phone and "Get the app"; goal cards (track my period / get pregnant / I'm pregnant / menopause → the tool for each); the five top calculators; honesty, every stage, a dark "private by design" section (no account, records on the phone, backup); trust trimmed to the four claims still true (EU storage and in-app export removed); feminine motifs from our own Bloom mark (`motifs.tsx`: petal, moon, spark). axe clean en/ar light/dark; /en within its 104 KB budget
- [~] P2.4 · **Learn hub done** (OD-12): aurora hero with search, question chips, Start-here row, stage rows with `TopicArt`, week 4–40 grid; `lib/content/topics.ts` + tests. Article template refresh still open
- [ ] P2.5 · Illustration set (brief → generate → owner D-2)
- [x] P2.6 · **Calculators to the competitor set, with visual results**: new period calculator (next three periods as ranges from her own shortest/longest cycle, never a constant we chose) and pregnancy-test calculator (NHS: first day of the missed period, or 21 days after sex); ovulation result drawn on a month calendar (`MiniCalendar`, Saturday-first in Arabic); due date and pregnancy week show a trimester bar (ACOG 14/28w); names women search for ("Ovulation calculator", "Pregnancy week calculator"); index ordered period → ovulation → test → due date → week; every result ends with "track this in the app". OG images still open
- [x] P2.7 · **Web beta closed** (D8): `middleware.ts` sends every app route (sign-in, welcome, the `(app)` group) to `/app` with a 307 and skips the Supabase session refresh, unless `NEXT_PUBLIC_WEB_APP_ENABLED=1` (CI only); a test fails if a new `(app)` route is not covered; `/help-now` stays open. Header CTA "Get the app", calculators end with "track this in the app", `/app` page with a drawn phone (Android coming soon, iPhone later) in 4 languages
- [ ] P2.8 · Checkpoint: Lighthouse ≥ 95 mobile, LCP < 2.0 s; retire the CMS Vercel project (owner)

## Phase 3 — The Android app (D7, D8; spec `04_ANDROID_APP_SPEC.md`)

- [ ] P3.1 · Flutter project in `apps/mobile`: Dusk Bloom theme from the tokens, AR/EN/FR/ES + RTL, local encrypted store behind `Store`
- [ ] P3.2 · Cycle and pregnancy maths in Dart with the shared golden fixtures (twin of `lib/calculators`, `lib/cycle`)
- [ ] P3.3 · Onboarding: five questions, under a minute, first prediction at the end (spec §3)
- [ ] P3.4 · Today + calendar + log (period, symptoms, mood)
- [ ] P3.5 · TTC toolkit: fertile window, ovulation tests, BBT, test timing, trying-time nudge
- [ ] P3.6 · Pregnancy: week-by-week, due date, kick counter, contraction timer, appointments
- [ ] P3.7 · Articles in the app (snapshot), conditions offered on Today and in Settings, PCOS hub
- [ ] P3.8 · Backup export/import, app lock, reminders (local notifications), crash reporting without content
- [ ] P3.9 · Checkpoint: TTC + pregnancy journeys recorded in Arabic → owner D-4

## Phase 4 — Launch

- [ ] P4.1 · Privacy policy + terms for the private architecture; counsel's four questions (A1)
- [ ] P4.2 · Play Console: listing AR/EN, Data safety ("health data not collected"), Health apps declaration, target audience 18+; closed test (12 testers × 14 days if personal account)
- [ ] P4.3 · Soft launch, 50–100 women, Egypt + KSA
- [ ] P4.4 · iOS from the same Flutter code (after launch signal)

## Session log

| When | What | Commit |
|---|---|---|
| 2026-10-07 | D7 + D8: private Android app is the product; website promotes it; onboarding respecified to the competitor standard | this commit |
| 2026-10-07 | Phase 1 started: Dusk Bloom palette + type, aurora hero, header, compact crisis launcher | this commit |
| 2026-10-07 | CMS list queries 2.1 MB → 4.2 KB (the likely usage-alert cause) | `544bac0` `3d8df90` |
| 2026-10-07 | Takeover: CI green, critical CVEs patched, build skipping, plan written, repo cleaned | `7abbb2e` `0b62436` `6d1e677` |
