# 30.01 — Audit and critique (2026-10-07)

An agency takeover audit, written before a line of the revamp was built. It answers
three questions: what is actually there, what is wrong with it, and what is worth
keeping. Every claim below was checked against the running site, the repository, CI
or the CMS API on 2026-10-07, not taken from earlier documents. Several earlier
documents turned out to be stale, and where they are, this one says so.

---

## 1. The verdict, in one paragraph

Femio has **an unusually solid engine inside an unremarkable car, and no road to drive it
on**. The code is clean, tested and principled: 42,000 lines of TypeScript, 940 passing unit
tests, a fifteen-check gate, row-level security on every table, honest prediction ranges,
and real Arabic right-to-left. But the product a woman actually sees looks like a
competent SaaS template. The first impression is a generic violet gradient, text-only cards and
an alarm-red "Need help now?" pill floating over every screen. The project has produced
**more documentation than code** (56,780 lines of docs against 42,221 of code) and **seven
successive strategy and revamp plans in eight weeks**. Each plan was rigorous and each was
superseded before it shipped anything a user could feel. Meanwhile there is no mobile app,
no launch date, no real user, and CI on `main` has been red for a month. The revamp keeps the
engine, replaces the body and paint, and above all **picks a road**: one wedge, one market,
one launch date.

---

## 2. What is genuinely good — keep it

| Asset | Why it is worth keeping |
|---|---|
| **The data model** | 23 migrations, RLS on every table, per-day flow, predictions with their basis, patterns with evidence, provenance on measured values. The schema is better than most funded competitors'. |
| **Honest predictions** | Ranges with confidence, a "why this window" explanation, no "late" counter in irregular mode. This is a real differentiator and matches the #2 user complaint about competitors. |
| **Arabic RTL** | Built in, not bolted on. Logical properties, bidi traps found and fixed, Arabic crisis copy reviewed. Flo has **no Arabic at all** (research §1), which makes this Femio's single biggest structural advantage. |
| **Privacy posture** | No ad SDKs, EU hosting, consent manager, export/delete, scrubbed telemetry, a strict CSP. This is a moat as Saudi and Egyptian enforcement starts (research §2.3). |
| **Content** | **100 published, clinician-bylined, cited articles** (not 31 as `STATE.md` still says), plus 5 condition hubs, 5 calculators and a postgres full-text search with Arabic stemming. |
| **The guards** | Claims-language, crisis, analytics-privacy, i18n, token parity, tier-1 portability. Cheap to run, and each one encodes a lesson that was paid for. |
| **Tier-1/tier-2 split** | Medical decisions live in pure, portable TypeScript with golden fixtures. This is exactly what makes a Flutter client affordable later. |

---

## 3. What is wrong — ranked by what it costs the launch

### 3.1 No road: the project optimises everything except shipping

The repo carries `docs/05`, `23`, `24`, `25`, `26`, `27`, `28` and `29`, each a plan or audit,
the later ones explicitly superseding the earlier. `STATE.md` is 1,431 lines. There are 73
persona specifications (3.1 MB), a 140 KB TODO, a 180 KB ADR log, and three separate
owner-facing runbooks totalling about 2,400 lines. The governance was built for an agency of
twenty; it is being run by one founder and a sequence of AI sessions, each of which spends a
large share of its budget re-reading the governance.

The symptom that matters: **seven plans, zero launches, and no date.** The persona model is
for "a woman's whole health life", 73 personas wide, so every plan has to serve everyone.
None can ship anything narrow enough to be excellent.

**Fix:** one wedge, one market, one date (plan §2). Governance shrinks to one living state
file, one plan, one owner-actions file. Old documents move to `docs/archive/`, nothing is
deleted, and nobody has to read them to work.

### 3.2 The product looks generic, and generic is fatal in this category

Measured on the live site at 390×844 on 2026-10-07:

- **The brand colour is Tailwind's default.** `--violet-600: #7C3AED` is Tailwind's stock
  `violet-600`, and the accent `#E11D74` is one step from its stock pink. Nothing about the
  palette is ownable; it is the colour of a thousand starter templates.
- **No imagery, illustration or texture anywhere.** The homepage is headings, paragraphs and
  bordered cards. The "product" is shown as a CSS mock-up of a phone. For a category where
  Flo, Clue and Stardust sell on visual warmth, this reads as unfinished.
- **The Learn hub is one 21,504-pixel list** of text-only cards with no categories, no
  imagery, no "start here", and titles like "Week 17 of Pregnancy: What to Expect" repeated
  forty times. `OD-12` asked for Flo's structure (chips, rows, illustrated cards) on
  2026-08-23. It has not been built.
- **The crisis pill overlaps content and calls to action.** "Need help now?" floats in violet
  over the onboarding *Continue* button, over article titles and over the footer, on every
  page. It is an important safety feature implemented as a permanent alarm. It belongs in
  the header and the menu, and in the content where risk is discussed, not on top of the product.
- **The copy argues with competitors instead of inviting the user.** "We would rather be
  useful than certain", "Six things you can verify", "No 'you are 4 days late'". These are
  the builder's convictions, written as the builder's defence. A woman deciding in eight
  seconds wants to see herself and what she gets.
- **Arabic UI, English content.** `/ar` is beautifully mirrored and then serves English
  articles. For a wedge whose whole advantage is Arabic, this is the gap that matters most.

### 3.3 The engine is over-built relative to the surface it drives

`lib/experience` + `lib/persona` = **10,227 lines**, more than all the pregnancy, cycle and
account screens combined. There are two experience engines (v1 and v2) running side by side,
with every v2 surface flag **defaulting off in production**. Most of Phase B and C of
`docs/29` (the v2 contract, the v2 home shell, the v2 log screen) is therefore built, tested
and invisible. `experience_documents` (migration 0020) has no reader or writer.
`public.content`, `content_i18n` and `content_history` from schema v1 have never been used.

**Fix:** flip the v2 surfaces on as the screens are redesigned, delete the v1 path behind each
one, and drop the dead tables (guarded migration `0024`, Phase 0).

### 3.4 Two production systems where one would do

The content is authored as Markdown in `docs/content/articles/` (105 files with complete
SEO and review frontmatter), imported into **Payload CMS**, which runs as a **second Vercel
project** on a **15-connection pool** to the same Supabase database. The public site then
fetches each article from the CMS's REST API **on every request** (`force-dynamic` on
`learn/[slug]`, `conditions/[slug]`, `authors/[slug]`), so an article view is two serverless
invocations and a database round trip.

That CMS was, until today's fix, **publicly reachable with two critical and five high
advisories** (Payload < 3.90). It is also why every commit rebuilt two Vercel projects.

**Fix (decision D3):** publish from the repository. The Markdown already *is* the source; the
CMS adds an admin screen the founder uses only to flip "approved". Static content means
article pages served from the CDN, no CMS to patch or pay for, no connection pool to exhaust,
and translations that land as files.

### 3.5 Infrastructure noise: the alert emails, explained

Gmail search is not available to this session, so the emails themselves were not read; these
are the causes found in the systems that send them.

| Source | Cause | Status |
|---|---|---|
| **GitHub Actions** | CI on `main` failed **every week since 2026-09-14** on `pnpm audit` (2 critical, 20 high), plus six Dependabot PRs sitting red, each a failure email | **Fixed** `7abbb2e` — audit clean, gate green |
| **Security** | Public CMS on Payload 3.86 (critical), both apps on Next < 15.5.24 (critical) | **Fixed** `7abbb2e` — Payload 3.90.2, CMS on Next 16.3.8, web on 15.5.27 |
| **Vercel build usage** | Every push rebuilt both projects; 27 of 50 recent commits changed nothing in `apps/web` | **Fixed** `0b62436` — ignored-build step per app |
| **Vercel function usage** | Article, condition and author pages render per request and fetch from a second serverless app | Phase 0 → ISR; D3 → static |
| **Sentry** | Every extension error, dropped connection and stale chunk opened an issue, and each issue is an email | **Fixed** `0b62436` — narrow ignore list |
| **Dependabot** | Weekly grouped PRs, never merged, each with failing CI and two preview builds | **Fixed** — monthly, previews skipped |
| **Supabase** | CI e2e signs in **anonymous users on the production project** on every run; the CMS holds a 15-slot session pool | Owner action: a separate free staging project for CI (`OWNER_ACTIONS.md`) |
| **Supabase / Vercel dashboards** | Not readable from this session: no connector | Owner action: connect both connectors, or forward one example of each email |

### 3.6 Facts the documents still get wrong

| Document says | Actually (verified 2026-10-07) |
|---|---|
| 31 articles published (`CLAUDE.md`, `STATE.md`) | **100** published and approved, plus 5 conditions |
| "Nothing is blocked", CI green | CI red on `main` for 3+ weeks |
| `00_WHERE_WE_ARE.md`: Phase C in progress | Phase C closed; D1–D4 closed; D5+ open |
| Postpartum/teen/week-by-week "awaiting review" | Published |

---

## 4. Design critique, screen by screen

Judged at 390×844, light, English and Arabic, on the live site.

**Home.** The structure is sound: hero, "this is the app", one account, honest by design,
trust, start reading. The execution is flat. One saturated gradient block, then a long
sequence of identical white cards on grey, in a single text style. There is no moment of
delight, no photography or illustration, and no proof (ratings, press, doctor). The
phone mock-up is CSS boxes at 60% scale, illegible on a phone. The header wraps to two
rows on a 390px screen.

**Onboarding (`/welcome`).** Clear, and correctly short (4 steps). But it is a form: eight
radio cards and eight age chips on one screen, the crisis pill sitting on the *Continue*
button, no illustration, no sense of arriving somewhere. `OD-6` asks for "joyful but simple";
this is simple.

**Learn.** Covered above: the single biggest visible gap.

**Calculators.** Correct and bare. A date input and a number, then a disclaimer. No
result visualisation (a due-date calculator that does not draw the pregnancy timeline is
a missed share moment).

**The app (from code and earlier audits).** The calendar (C5), log (C6) and states (C7)
work done in August is careful and correct. The ceiling is the visual language it renders
in, which is the same one as above.

---

## 5. What the revamp keeps, changes and removes

| Keep | Change | Remove / archive |
|---|---|---|
| Schema, RLS, migrations | Brand palette, type, imagery, motion (v3 design language) | Payload CMS + its Vercel project (D3) |
| Tier-1/2 medical logic, golden fixtures | Learn hub, article template, home, onboarding | v1 experience path, once each v2 surface ships |
| Prediction honesty, crisis safety (relocated) | App shell: bottom tabs with Calendar prominent | Dead tables `content*` (guarded) |
| Arabic RTL engineering | Positioning: one wedge, Arabic-first, MENA | Seven superseded plans → `docs/archive/` |
| The guard scripts | Governance: one state file, one plan, one owner file | `references/femio_v1_archive/` (still in git history) |
| 100 articles + the review discipline | Content priority: Arabic parity for the wedge | 2,400 lines of runbooks → one `OWNER_ACTIONS.md` |
