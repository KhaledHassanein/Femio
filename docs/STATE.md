# Femio — current state (living document)

**Last updated: 2026-08-09.** This file replaces the seven dated handover documents, which
are now in `docs/archive/` (ADR-062). **Rewrite this file in place; do not create a new one
per session.**

## Read this, in this order

1. `CLAUDE.md` — the product rules and the repo map.
2. `docs/23_STRATEGIC_REVIEW_2026-08-09.md` — what is wrong, ranked, with evidence. Start here
   if you are wondering why the priorities are what they are.
3. `docs/24_REVAMP_PLAN.md` — the architecture every new feature must obey.
4. `docs/25_DESIGN_DIRECTION_BRIEF.md` — before touching any UI.
5. `docs/22_APP_UI_ARCHITECTURE.md` — the code conventions for tracker screens.
6. `docs/07_MASTER_TODO.md` — the queue. Take the highest open item in **▶ NOW**.

## How to work here

**Build. Do not discuss.** The owner's instruction, verbatim: *"only talk if something needed
manual or info or decision but be short and to the point."* No progress narration, no options
essays. Do the work, run the gate, commit, report in a few lines.

**Do not overcomplicate a simple task.** Match the size of the solution to the size of the
problem. A previous session built scaffolding around a one-line problem and was rightly pulled
up for it.

**Do not lose context.** Most "new ideas" are already decided in `docs/`. Find the decision
rather than re-inventing it.

**Small commits, conventional messages.** Update `DECISIONS.md` / `CHANGELOG.md` /
`07_MASTER_TODO.md` in the same change — but under the ADR-062 bar: **an ADR is for a decision
that cost something or that a future session could reverse by accident; a commit message is
for everything else.** A TODO line is one line.

## What Femio is

One account for a woman's whole health life — puberty → cycles → conditions → TTC/IVF →
pregnancy → postpartum → perimenopause → menopause. Four languages (EN/AR/FR/ES), Arabic RTL
first-class. **Not "a cycle tracker with extra screens"** — a one-stop app better than every
competitor at each life stage and, uniquely, across all of them. The 73 specs in
`docs/personas/` and the model in `docs/09` are the product specification.

**Mobile is the destination; web is also a real product** (owner, 2026-08-08). Android via
**Flutter**, then iOS, over the same backend (ADR-060). The public content site and CMS are
**support functions** — they bring people to the app. If you are deep in CMS tooling, you have
drifted.

## Live today

`femioapp.com` (web) and `femio-cms.vercel.app` (Payload CMS) on Vercel, sharing a Supabase
Postgres in the EU. 31 articles published with structured data; the sitemap carries 99 URLs.

**Built and working:** onboarding wizard with a condition-triage step; cycle tracking with
honest ranges and irregular mode; symptom logging with per-symptom severity and custom
entries; four dashboards (cycle, TTC, pregnancy, menopause); the full pregnancy lifecycle
including urgency-tiered symptom logging, the movement log and ending a pregnancy; export and
delete; an offline IndexedDB queue; a consent manager; staff MFA; k-anonymous first-party
insights; the visit summary; Settings → "Your Femio experience" to change life stage or choose
General.

**Owner manual tasks outstanding:** see the *Owner / manual actions* section of the TODO.
Migrations 0001–0007 are all applied; 0006 is the exception — confirm before relying on
`/admin/insights`.

## The architecture rule that governs new code (ADR-060/061)

**The backend owns decisions; the clients render them.** Anything medical — thresholds,
red-flag sets, persona rules, alert cadences, screener scoring — belongs in tier 1 (Edge
Function) or tier 2 (shared golden fixtures), never inline in a screen. Personas reach the UI
as an `ExperienceConfig` document rendered through a module registry, never as a `mode ===`
branch. Full contract in `docs/24`.

**Until R2.4 lands**, the tracker path is still governed by the old `native-readiness-lint`
rule (no server reads, no `force-dynamic`, no Server Actions, no `searchParams` page props).
R2.7 repoints it. Do not add server reads to the tracker before then.

## The gate — run all of it before pushing

```
pnpm build && pnpm typecheck && pnpm lint
pnpm claims-lint && pnpm crisis-lint && pnpm analytics-lint
pnpm i18n-client-lint && pnpm content-lint && pnpm native-readiness-lint
pnpm i18n-untranslated-lint && pnpm tokens-parity-lint
pnpm test
CI=1 pnpm --filter web test:e2e:ci     # after a fresh build
```

## Environment traps that have each cost real time

- **`next dev` renders everything dynamically**, so a green local e2e proves nothing. Run the
  CI-mode e2e after a fresh build.
- **Check the deployed thing.** Every serious defect in recent sessions was invisible from
  inside the build: an interactive migrate prompt, connection-pool exhaustion, a sitemap that
  silently emptied, articles 404ing during a CMS outage.
- **A loop making one network call per document** is an outage waiting for the collection to
  grow. It took the CMS down at 30 articles.
- **Editing the Tailwind preset alone does not invalidate Next's PostCSS cache.** `pnpm build`
  reports success while shipping the previous stylesheet. `rm -rf apps/web/.next/cache` first,
  then grep `.next/static/css` for the class you expect (ADR-054).
- **A Tailwind utility with no theme entry emits nothing — silently.** If a token "doesn't
  work", check the preset map before anything else (`tokens-parity-lint` now catches this).
- **The i18n catalogs are Prettier-formatted** and some maps are on one line. Insert keys as
  text; never re-serialise with `json.dumps`. Verify the file still parses after every edit.
- **`apps/cms/.env.local` holds the PRODUCTION connection string.** Any local migrate touches
  live data.
- **Windows:** `pkill` does not kill `next start`; kill by port.

## Verification honesty

Guards have caught real errors in this project's own work, repeatedly — including a claim in a
handover doc based on a grep over an already-modified tree. **Watch a new guard fail before
trusting it.** Prefer assertions that break loudly over ones that can silently pass. When a
guard fails, fix the code — do not narrow the rule.

## Where R1 stands (2026-08-09)

**R1.2 is decided** — the visual language is in `docs/25` §5a and is now binding on every
screen: Fraunces states and Inter explains, never Fraunces below 22px; Arabic pairs by weight
because no serif counterpart exists; three elevation levels with **one raised element per
screen**; `--gradient-dawn` is the marketing signature and never appears inside the app; the
data-visualisation language is band · strip · stack, with **rings explicitly rejected**.

**Two references are built and awaiting the owner's verdict**, both importing the real token
file so neither can specify something the product cannot build:

- `assets/mockups/R1.3_homepage_reference.html` — four states. Two defects surfaced by
  rendering it that a diff would not have shown: the Arabic headline fell back to Georgia, and
  white copy on the dawn gradient measured 2.15:1 at the amber stop. Both fixed and re-measured
  (8.98:1 and 5.70:1). R1.3a then added the product screenshot the teardown said was missing,
  and collapsed 4 duplicated copies into one template.
- `assets/mockups/R1.4_onboarding_reference.html` — the flow in EN light plus the triage step
  in dark, AR and AR-dark. **Its last step renders `ExperienceConfig.home` rather than a
  summary of her answers, which makes onboarding the natural first consumer of the R2 engine.**

Both were verified by **executing the template in node** — state counts, no `undefined`
leaking — not by looking at them. The browser pane would not composite. **The visual verdict is
genuinely the owner's**, which is what a reference is for.

**R1.1, the competitor teardown, is still owed — and it is now split** (`docs/25` §2.1,
decided 2026-08-09). **R1.1a is desk research an agent can start immediately** and needs no
device: store screenshots per locale including Arabic, their web surfaces measured with the
browser tools, and reviews mined for the whitespace map. **R1.1b is the owner's ~1 hour** —
three screen recordings per app (sign up · log a period · open cold on day 3) into
`assets/research/`, because craft lives in things no scrape captures. **Decompiling the APKs
is rejected** and should not be proposed again; the reasoning is in `docs/25` §2.1.

Everything in R1.2 was decided without R1.1 and may be revised by it — expected, not a failure.

**R1.1a is in progress** — `docs/03` §H carries the craft teardown for Flo, Clue and Balance
(2026-08-11). Three things it established: nobody in the category uses stock portraiture, which
confirms R1.2's illustration call from the market side; Balance puts its clinician's
post-nominals on the page, which Femio could copy in ten minutes if P1.9.7 were unblocked; and
Flo answers a documented FTC action with a **certification**, where Femio can answer
structurally — no channel exists — which is the strongest sentence this product owns. **Key
finding:** pattern analysis is *"the one feature I would actually pay for, gated"*, so R4 is
both the differentiator and the revenue mechanism. Remaining: Ovia, Stardust, Arabic store
screenshots.

## First action for the next session

**Then, on the owner's verdict on R1.3:**

- *Approved* → implement at `apps/web/src/app/[locale]/(public)/page.tsx`, keeping the page
  server-rendered (it is the SEO landing page), with new i18n keys in all four locales, and run
  axe on the result. Delete the stale `home.title` / `home.body` placeholders ("Scaffold
  online.") still sitting in all four catalogs in the same change.
- *Rejected* → the notes at the bottom of the reference say what each decision was for, so the
  argument can be had against a specific choice rather than a vibe. Move to **R1.4** (onboarding
  reference) while R1.3 is reworked.
