# 30.03 — The revamp plan (2026-10-07)

This plan supersedes the *sequence* in `docs/29_REBUILD/07_SEQUENCE.md` and the plans before
it. It does **not** discard their work: `docs/24` stays the architecture reference, `docs/29`
chapters 02–06 stay the screen and data specifications, `docs/28` stays the competitive
evidence, and the 16 owner directions (`OD-1…OD-16`, `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md`)
still bind. What changes is the **destination**: a dated launch of a narrow, excellent product,
instead of an open-ended rebuild of a 73-persona platform.

Inputs: `01_AUDIT_AND_CRITIQUE.md` (what is wrong) and `02_MARKET_RESEARCH_2026-10.md`
(the market, the SWOT, the gaps).

---

## 1. Goal

> **Launch Femio as the Arabic-first, doctor-written women's-health companion, where the
> leading global app does not even speak the language, with a product that looks and feels
> as premium as the best in the category.**

The ambition, one account for a woman's whole health life, does not shrink. The
**launch** does. A superapp is earned stage by stage; nobody launches one. Femio's record
already spans every stage (rule 5), so starting narrow costs nothing structurally. Each later
stage is a new layer over the same record.

---

## 2. Strategy — the decisions the plan rests on

### 2.1 Wedge: trying to conceive → pregnancy, with PCOS and irregular cycles as the clinical depth

From research §10. It is the job MENA women open these apps for, it is where Femio is
already most built (fertility logs, the full pregnancy lifecycle, appointments, weight,
screeners, partner sharing, the visit summary), and it is where a clinician founder's
authority counts most. Postpartum is the first follow-on layer and is already modelled.

**What the wedge does *not* mean.** Every other life stage stays reachable (rule 2:
personalise, never restrict). Cycle tracking stays free and first-class, because it is the
entry point to TTC. The wedge decides **emphasis, marketing, content priority and polish
order**, not access.

### 2.2 Market: Saudi Arabia (revenue) + Egypt (volume, content, clinicians), Arabic first

UAE follows. The EU stays live as the SEO/content surface, with no paid acquisition.
**Gate:** the Egypt and Saudi data-protection questions in research §10.2 are legal
questions. They make the legal work (P0.12) a launch condition from today (`OWNER_ACTIONS.md` §A).

### 2.3 Platform: web first, then Play Store fast, then native

`OD-16` stands: the mobile-first web app gets right first, tested in the browser. The
revamp adds a **fast path to the stores** so "launch soon" means weeks, not a Flutter
rewrite:

1. **Web (PWA)**, revamped, is the product of record.
2. **Google Play via Trusted Web Activity**: the same PWA, packaged with Bubblewrap,
   listed in Arabic. Days of work, not months. Egypt is Android-heavy.
3. **Flutter (ADR-060)** for iOS and the full native Android experience, after launch
   signal, built on the served `ExperienceConfig` exactly as planned.

This is **decision D2** in `OWNER_ACTIONS.md`; the recommendation is above and the plan
proceeds on it unless the owner says otherwise.

### 2.4 Positioning and voice

Positioning (research §10.3, shortened):

> For Arabic-speaking women trying to conceive or expecting, especially with irregular cycles
> or PCOS, **Femio is the private, doctor-written companion** that gives honest predictions,
> explains your body in your language, and prepares you for every visit. Unlike Flo, it speaks
> Arabic. Unlike the local calculator apps, it is referenced, ad-free and built to stay with
> you from the first cycle to the first year with your baby.

**Voice rules for the revamp:**

- **Invite, never argue.** Say what she gets ("Know your fertile days, in Arabic, with a
  doctor's explanation"), not what competitors do wrong.
- **Warm, precise, unhurried.** Short sentences. A doctor who sits down, not one at the door.
- **Proof over promises.** Show the clinician, the citation and the prediction range; do not
  describe them in paragraphs.

### 2.5 Monetisation (OD-7: freemium, model later)

Launch **free**, with the paywall designed but off. Free forever: tracking, predictions,
pregnancy weeks, calculators, the library, privacy features, the Ramadan hub. Candidate
premium (switched on after retention data): the PCOS programme, pattern insights, the full
visit pack, partner extras. Regional pricing near the ~$40/yr median in the Gulf and well
below it in Egypt (research §5).

---

## 3. The design language: Femio v3, "Dusk Bloom"

The single biggest visible change. The brief: **modern, feminine without cliché pink,
cinematic where it earns it, Arabic-native.**

### 3.1 Principles

1. **Own a palette.** Retire Tailwind's stock violet. Femio's colours come from dusk: deep
   plum, rose, peach and a thread of saffron gold over warm porcelain. They are feminine and
   adult, and they read as Gulf and Levantine rather than Silicon Valley.
2. **Editorial type, in both scripts.** A display serif in Latin and a matched Arabic display
   face, so the Arabic headline is as beautiful as the English one and not a fallback.
3. **Cinema in moments, calm everywhere else.** Motion and depth are spent on four moments:
   the homepage hero, onboarding arrival, the first prediction, and each pregnancy week.
   Everywhere else is still, fast and legible. `prefers-reduced-motion` is honoured
   everywhere.
4. **Her data is the hero.** The cycle band, the fertile window and the pregnancy week are
   the visuals. Decoration never competes with them (`docs/27` rule, kept).
5. **Illustration, not stock.** A consistent abstract-organic illustration system (petal and
   bloom forms from the logo, soft gradients, grain), with no photographs of people and no
   generic stock.
6. **Safety stays one tap away, and stays out of the way.** The crisis entry moves from a
   floating pill to the header, the menu and red-flag content. It remains one tap away and no
   longer covers the product.

### 3.2 Tokens (implemented in Phase 1; values are the starting point, contrast-checked)

| Role | Light | Dark | Use |
|---|---|---|---|
| Ground | porcelain `#FBF7F3` | night `#140D14` | page background |
| Surface | `#FFFFFF` | `#1E1520` | cards |
| Ink | aubergine `#24141F` | `#F6EEF2` | text |
| **Primary** | plum `#6B2558` | `#E7A9CF` | brand, primary actions |
| Accent | rose `#D9466F` | `#F28AA6` | period, highlights, never body text |
| Warm | peach `#F2A07B` | `#F5B497` | pregnancy, warmth |
| Gold | saffron `#C08A2E` | `#E2B661` | ovulation, premium, Ramadan |
| Fertile | sage `#3D8B7A` | `#7CC7B5` | fertile window, success |
| Aurora | plum → rose → peach → gold mesh | same on night | hero moments only |

Semantic token **names do not change**. `bg-primary-solid` and the rest keep working, so the
re-skin is a token change plus targeted component work, not a rewrite. Danger, warning and
info keep their accessible values.

### 3.3 Type

| Role | Latin | Arabic |
|---|---|---|
| Display | **Newsreader** (editorial, optical sizes, real weights) | **Noto Naskh Arabic** 600–700 |
| UI / body | **Plus Jakarta Sans** (warmer than Inter) | **IBM Plex Sans Arabic** (kept) |

All four are loaded through `next/font`, self-hosted, with no runtime Google request (CSP
unchanged).

### 3.4 Motion

The C2 motion vocabulary stays. New: an **aurora** background (CSS-only, GPU-cheap, paused
offscreen), scroll-driven reveal for the public site (CSS `animation-timeline` with fallback),
the **breathing cycle band** (never a ring — a ring implies a target to complete; `docs/archive/plans-2026-08/25` §5a), and a shared-element style transition between pregnancy weeks.
No JavaScript animation library unless a moment cannot be done in CSS. If one is needed,
`motion` (Framer) is the choice, lazy-loaded on that route only.

### 3.5 Imagery

An illustration set generated to brief and committed as optimised SVG/AVIF: 12 topic
covers for Learn, 6 hero/onboarding pieces, 40 pregnancy-week size motifs (fruit and
everyday objects familiar in MENA; dates and pomegranates sit alongside the usual). Brief
and prompts in Phase 2; generation uses the connected Adobe Firefly / Canva tools, and
the owner approves the set once (`OWNER_ACTIONS.md` §D).

---

## 4. Architecture and infrastructure — simpler, cheaper, faster

| # | Change | Why | Phase |
|---|---|---|---|
| I-1 | **Publish content from the repo; retire Payload** (decision D3) | Removes a second production app, its CVE surface, its 15-connection pool and every per-request article fetch. Markdown is already the source. Owner approval becomes a frontmatter flip done on his word, as it effectively is today. | 2 |
| I-2 | Content pages **static/ISR**, not `force-dynamic` | CDN-served articles: faster, cheaper, better Core Web Vitals | 0 → 2 |
| I-3 | Search index built at build time from the same files | `0022` searches Payload's tables; once content is files, a generated index (tier-2 ranking already exists) replaces it. Postgres FTS kept only if the library outgrows it. | 2 |
| I-4 | **Flip v2 surfaces on and delete the v1 path behind each** | One engine instead of two; ~3–4k fewer lines | 3 |
| I-5 | Drop never-used tables (`content`, `content_i18n`, `content_history`), guarded to refuse if any holds rows | Schema honesty; fewer RLS surfaces to audit | 0 |
| I-6 | **Staging Supabase project** for CI e2e (free tier) | Stops CI creating anonymous users in production | 0 (owner creates, 5 min) |
| I-7 | Supabase **Pro** at launch (daily backups, no pause, PITR option) | A health record without backups is not launchable | 4 |
| I-8 | Ignored build steps, Sentry noise filter, monthly Dependabot | Done `0b62436`, `7abbb2e` | 0 ✅ |
| I-9 | Custom SMTP for auth email (Resend/Postmark EU) | Supabase's built-in sender is rate-limited and lands in spam | 4 |
| I-10 | Governance collapse (one state file, one plan, one owner file) | Sessions spend their budget building, not re-reading | 0 |

**Not changing:** Supabase (EU), Next.js on Vercel, RLS-first security, the tier-1/tier-2
medical logic, the guards, PostHog EU (consent-gated), Sentry EU.

---

## 5. Phases

Each phase ends at a checkpoint that is **visible**: deployed, photographed at 390×844 in
light, dark and Arabic, and recorded in `PROGRESS.md`. Phases run in order; the owner's
manual items run in parallel from `OWNER_ACTIONS.md`.

### Phase 0 — Stabilise and clean · this session

- ✅ Critical advisories patched, CI green, gate green
- ✅ Vercel build skipping, Sentry noise filter, Dependabot monthly
- Governance collapse: `STATE.md` rewritten short; superseded plans → `docs/archive/`; one
  `OWNER_ACTIONS.md`; `CLAUDE.md`, `00_WHERE_WE_ARE.md` and `AGENTS.md` pointed here
- `references/femio_v1_archive/` removed from the tree (kept in git history)
- Guarded migration `0024` dropping the never-used content tables

### Phase 1 — Design language v3 · ~1 week

- Tokens: the Dusk Bloom palette in `femio.tokens.css`, light and dark, all parity guards green
- Type: Newsreader, Plus Jakarta Sans, Noto Naskh Arabic, IBM Plex Sans Arabic
- Aurora + grain hero primitive; breathing cycle band; reveal-on-scroll utility
- Components restyled: button, card, chip, badge, alert, inputs, header, footer, bottom tabs
- Crisis entry relocated (header + menu + content), never floating over the product
- App shell: bottom tab bar **Today · Calendar · Log · Learn · Tools**, Settings as a gear in the top bar, Calendar a tab
  (OD-11)
- **Checkpoint:** `/components` gallery and three key screens photographed in light, dark
  and AR

### Phase 2 — The public site: acquisition · ~1–2 weeks

- Homepage rebuilt: cinematic aurora hero with the real product (rendered UI, not a CSS phone),
  Arabic-first copy for MENA, proof (clinician, citations, privacy) as visuals, one CTA
- Learn hub per OD-12: search, question chips, "start here", most-read row, category rows,
  illustrated cards. Article template: hero, key takeaways, table of contents, reading
  progress, red-flag box, byline card, related reads
- Content from the repo (I-1, I-3); the 100 published articles reconciled from the CMS export
- Calculators with visual results (due-date timeline, fertile-window calendar), each a
  share moment with its own Open Graph image
- SEO: static article pages, schema kept, hreflang only for real translations, an Arabic
  keyword map for the wedge
- **Checkpoint:** Lighthouse ≥ 95 mobile on home/article; LCP < 2.0 s

### Phase 3 — The app, for the wedge · ~2–3 weeks

- Onboarding ≤ 6 joyful screens (OD-6): goal → last period/cycle → TTC or pregnancy
  detail → conditions (PCOS/irregular) → privacy promise → arrival moment
- **Today** (OD-10/OD-13): one focal insight, the cycle band or the pregnancy week as the
  hero, today's log, the tools for *her* stage, and one personalised read
- **Calendar** to OD-15: every period day, first and last day distinguished, fertile window,
  ovulation, both prediction tiers (C5 built the logic; v3 gives it the finish)
- TTC toolkit: fertile window, OPK/BBT/cervical mucus, conception-day marker (OD-5 wording),
  "when to see a doctor" by age
- Pregnancy: week-by-week with size motif and a cinematic week transition, kick counter,
  contractions, appointments, weight
- **PCOS hub**: symptom set, education path, the conservative screener
- **Visit pack**: the summary, redesigned as a shareable one-pager (PDF + WhatsApp)
- Privacy centre: data map in plain Arabic, export/delete, app lock (PWA), anonymous start
- v2 surfaces on by default; v1 paths deleted (I-4)
- **Checkpoint:** a full TTC journey and a full pregnancy journey recorded at 390×844 in AR

### Phase 4 — Launch readiness · ~1 week, overlapping

- Legal gate closed (owner): privacy policy, terms, DPIA, Egypt/Saudi counsel answers
- Invite gate on, then off at launch; custom SMTP; Supabase Pro + backups
- Analytics funnels (consent-gated): visit → start → onboarded → first log → D7
- Store listing (Play, TWA): Arabic + English screenshots, ASO keywords, privacy labels
- Ramadan hub content (an annual acquisition moment; Ramadan 2027 is expected to begin around 8 February)
- Arabic content parity for the wedge's top 50 questions (needs the Arabic reviewer, §B)
- **Checkpoint:** soft launch to a 50–100 woman beta in Egypt and Saudi Arabia

### Phase 5 — Native mobile · after launch signal

Flutter on the served documents (ADR-060, `docs/29` G1–G4), iOS + Android, Health Connect /
HealthKit, widgets. Starts when the beta shows retention.

---

## 6. What is explicitly out of scope until after launch

From research §11.2 and the owner directions: AI chat (OD-9), messaging/community (OD-8),
menopause **module** (the content stays), teen mode changes (legal first), clinician
marketplace, e-commerce beyond affiliate, wearables beyond Health Connect/HealthKit, IVF
protocol calendar (Phase 2 of the wedge), haid/istihada classification (needs scholarly
partnership), full FR/ES content.

---

## 7. How sessions work from here

1. Read `CLAUDE.md` → `docs/STATE.md` (short) → `docs/30_REVAMP/PROGRESS.md`; take the
   first open checkpoint item.
2. Build it whole, i18n in four locales, tests, run `pnpm gate`.
3. **Photograph it** at 390×844, light, dark and Arabic. Use `scripts/dev/seed-and-shoot.mjs`
   for app screens.
4. Commit with the reasoning in the message; update `PROGRESS.md` in the same commit.
5. Anything for the owner goes in `docs/runbooks/OWNER_ACTIONS.md`, never in chat.
