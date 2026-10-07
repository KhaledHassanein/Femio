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
- [ ] P2.2 · Build-time search index replacing the Payload-table search
- [ ] P2.3 · Homepage rebuilt (aurora hero, real product UI, Arabic-first copy, proof as visuals)
- [~] P2.4 · **Learn hub done** (OD-12): aurora hero with search (a no-JS GET form; /search now reads `?q=`) and 8 question chips, Start-here row, one row per stage in wedge order with procedural `TopicArt` covers, a tappable week 4–40 grid; 21,224px → 5,316px at 390 wide; `lib/content/topics.ts` + 5 tests (a new article with no topic fails CI). Article template refresh still open
- [ ] P2.5 · Illustration set (brief → generate → owner D-2)
- [ ] P2.6 · Calculators with visual results + OG images
- [ ] P2.7 · Checkpoint: Lighthouse ≥ 95 mobile, LCP < 2.0 s
- [ ] P2.8 · Retire the CMS Vercel project (owner, after P2.1 ships)

## Phase 3 — The app, for the wedge

- [ ] P3.1 · Onboarding ≤ 6 screens
- [ ] P3.2 · Today
- [ ] P3.3 · Calendar to OD-15
- [ ] P3.4 · TTC toolkit
- [ ] P3.5 · Pregnancy week-by-week + transitions
- [ ] P3.6 · PCOS hub + screener (owner D-5)
- [ ] P3.7 · Visit pack one-pager (PDF + WhatsApp)
- [ ] P3.8 · Privacy centre + app lock + anonymous start
- [ ] P3.9 · v2 surfaces default-on; v1 paths deleted
- [ ] P3.10 · Checkpoint: TTC + pregnancy journeys recorded in AR → owner D-4

## Phase 4 — Launch readiness

- [ ] P4.1 · Legal gate (owner §A) · P4.2 SMTP + Supabase Pro (owner §E) · P4.3 funnels
- [ ] P4.4 · Play listing via TWA (AR/EN) · P4.5 Ramadan hub · P4.6 Arabic top-50 content (owner §B)
- [ ] P4.7 · Soft launch, 50–100 women, Egypt + KSA

## Phase 5 — Native mobile (after launch signal)

- [ ] P5.1 · Flutter on served documents (`docs/29` G1–G4)

## Session log

| When | What | Commit |
|---|---|---|
| 2026-10-07 | Phase 1 started: Dusk Bloom palette + type, aurora hero, header, compact crisis launcher | this commit |
| 2026-10-07 | CMS list queries 2.1 MB → 4.2 KB (the likely usage-alert cause) | `544bac0` `3d8df90` |
| 2026-10-07 | Takeover: CI green, critical CVEs patched, build skipping, plan written, repo cleaned | `7abbb2e` `0b62436` `6d1e677` |
