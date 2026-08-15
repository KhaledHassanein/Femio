# Femio — current state (living document)

**Last updated: 2026-08-16.** This file replaces the seven dated handover documents, which
are now in `docs/archive/` (ADR-062). **Rewrite this file in place; do not create a new one
per session.**

## ▶ Resume prompt — paste this into a new chat

> Read `CLAUDE.md`, then this file, then `docs/07_MASTER_TODO.md` → **▶ NOW**. Skim
> `docs/23`/`24`/`25` only if the task touches strategy, architecture or design.
>
> **Build, do not narrate.** Work in the loop below. Do not report progress between
> checkpoints, do not present options, do not ask me to confirm a plan. Speak only when a
> blocker in `docs/runbooks/BLOCKERS.md` actually stops you, and then in one short paragraph.
>
> Anything that needs my input goes into `docs/runbooks/BLOCKERS.md`; anything needing my eyes
> goes into `docs/runbooks/MANUAL_TEST_PLAN.md`. Add it there silently and carry on with the
> next unblocked item.
>
> Jump in large steps. Take the whole of an item, not a slice of it.

## The working loop — one pass per checkpoint

1. **Take** the highest open item under ▶ NOW. Mark it `[~]`.
2. **Build** the whole thing, including its i18n in all four locales and its tests.
3. **Gate** — everything below, no exceptions. When a guard fails, fix the code, never the rule.
4. **Verify** the way the change can actually fail: a rendered page for UI, an injected fault
   for a guard, the deployed site for anything that only breaks in production.
5. **Record** — TODO line (one line), `STATE.md` in place, an ADR only if it meets the bar.
6. **Commit and push to `main`.** Vercel deploys from `main`. A commit message carries the
   *reasoning*; the TODO carries the *status*.
7. **Next item.** Do not stop to summarise.

**Checkpoint discipline:** never end a turn with a dirty tree. Any interruption should be
recoverable from `git log` plus this file alone.

## Read this, in this order

1. `CLAUDE.md` — the product rules and the repo map.
2. `docs/23_STRATEGIC_REVIEW_2026-08-09.md` — what is wrong, ranked, with evidence. Start here
   if you are wondering why the priorities are what they are.
3. `docs/24_REVAMP_PLAN.md` — the architecture every new feature must obey.
4. `docs/25_DESIGN_DIRECTION_BRIEF.md` — before touching any UI.
5. `docs/22_APP_UI_ARCHITECTURE.md` — the code conventions for tracker screens.
6. `docs/07_MASTER_TODO.md` — the queue. Take the highest open item in **▶ NOW**.
7. `docs/runbooks/BLOCKERS.md` — the only things waiting on the owner. Check it before
   claiming you are blocked, and add to it rather than asking in chat.
8. `docs/runbooks/MANUAL_TEST_PLAN.md` — what only a human can judge. Every automated gate
   passes on every commit; none of them can tell you a screen looks generic or an Arabic
   sentence is tonally wrong. Point the owner at it rather than describing checks in chat.

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

**Blocked on the owner:** `docs/runbooks/BLOCKERS.md` — **nothing is blocked.** B1, B2, B3 and
B4 are all closed; the 14 postpartum titles were approved on 2026-08-16. Migrations 0001–0007
applied.

**The Edge Function is DEPLOYED and verified** (2026-08-12): unauthenticated → 401, with a
session → 200 returning a real `ExperienceConfig`. **Its source changed on 2026-08-16, so it
wants a re-deploy** (`npx supabase@latest functions deploy experience`, runbook task 4) — one
line, and nothing is broken meanwhile because the local fallback now runs literally the same
functions.

**R2.4 is closed: the screens render a served document.** See below for the three defects that
only became visible once the server was the authority.

**Bylines are live** (P1.9.8, 2026-08-16). One public reviewer bio — `Dr. Khaled M. · MBBCh,
CPC`, no affiliation, deliberately (`docs/content/people/khaled-m.json`) — and all 30 imported
documents now name it as author and medical reviewer, on the page and in the `Article` JSON-LD.
`apps/cms/scripts/wire-bylines.mjs` did it: idempotent, never overwrites an existing byline,
never publishes. **`meet-femio` deliberately has an author and no reviewer** — an About page is
not health content, and spending the credential there dilutes it where it counts. The homepage
clinician trust line is back, as the first of six verifiable claims.

## The architecture rule that governs new code (ADR-060/061)

**The backend owns decisions; the clients render them.** Anything medical — thresholds,
red-flag sets, persona rules, alert cadences, screener scoring — belongs in tier 1 (Edge
Function) or tier 2 (shared golden fixtures), never inline in a screen. Personas reach the UI
as an `ExperienceConfig` document rendered through a module registry, never as a `mode ===`
branch. Full contract in `docs/24`.

**`native-readiness-lint` now enforces that rule directly** (R2.7, 2026-08-16). It used to
forbid server reads in the tracker, which ADR-060 turned from a protection into a
contradiction — the tracker is *supposed* to call the server. It now fails on **medical
decision logic inside a client component**: resolving or composing the experience, declaring a
threshold or red-flag set, deriving days from milliseconds, accumulating a screener score.
Server reads in the tracker are fine and expected.

## The gate — run all of it before pushing

```
pnpm typecheck && pnpm lint && pnpm test
pnpm claims-lint && pnpm crisis-lint && pnpm analytics-lint && pnpm content-lint
pnpm i18n-client-lint && pnpm i18n-untranslated-lint && pnpm tokens-parity-lint
pnpm native-readiness-lint && pnpm persona-branch-lint && pnpm tier1-portability-lint
rm -rf apps/web/.next/cache && pnpm build
CI=1 pnpm --filter web test:e2e:ci     # after that fresh build, never before
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
  Two specifics that each cost time on 2026-08-12: **`dashboard.modeLabel` is a single-line
  map**, so a "insert before the closing brace" approach silently misses it; and **`"mode"` /
  `"modes"` appear in more than one namespace**, so anchor inside the enclosing namespace
  rather than on first match.
- **`git checkout` restores the catalogs with CRLF** in this working tree, while files written
  by a script are LF. Every `\n`-based anchor then stops matching — with no error, because
  `indexOf` just returns −1 and a naive script reports success. Normalise to LF, edit, and
  write back in whatever style the file had.
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

**R1.3 and R1.4 are APPROVED as direction** (ADR-063, 2026-08-11), with fixes tracked as
R1.3b/c and R1.4a/b/c rather than blocking. Both import the real token file so neither can
specify something the product cannot build:

- `assets/mockups/R1.3_homepage_reference.html` — four states. Two defects surfaced by
  rendering it that a diff would not have shown: the Arabic headline fell back to Georgia, and
  white copy on the dawn gradient measured 2.15:1 at the amber stop. Both fixed and re-measured
  (8.98:1 and 5.70:1). R1.3a then added the product screenshot the teardown said was missing,
  and collapsed 4 duplicated copies into one template.
- `assets/mockups/R1.4_onboarding_reference.html` — the flow in EN light plus the triage step
  in dark, AR and AR-dark. **Its last step renders `ExperienceConfig.home` rather than a
  summary of her answers, which makes onboarding the natural first consumer of the R2 engine.**

Both were verified by **executing the template in node** — state counts, no `undefined`
leaking — not by looking at them.

**The review gates are ungated (ADR-063).** P1.29, P1.26.1 and P1.26.2 are closed with the
owner as the recorded reviewer, and review now happens **in the running app during testing**
rather than before the build. The one that matters: **ar/fr/es crisis copy did not exist** — it
was authored on 2026-08-11 and the English fallback that used to render in those locales is
gone. Translated sentence for sentence from the medically-reviewed English, no added promises,
no phone numbers, key parity across four locales, 63/63 e2e. **Read the ten Arabic strings in
the app** — it is the one place a wrong word costs differently. Correction is an edit plus a
new `reviewDate`, not a blocked release. **Revisit before inviting outside testers (P0.12.5)**,
which is when the audience stops being the owner.

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

## The homepage is rebuilt (R1.3c, 2026-08-11)

`apps/web/src/app/[locale]/(public)/page.tsx` is now the seven-section page from the reference,
server-rendered, in four locales. **Not yet verified on a deployed site** — see R1.3d.

**The one you must know about: ADR-064.** The page shipped with its new markup and the *old
text*, because the P1.19 seed had put the whole English catalog into `ui_strings` as
`human_reviewed` and the overlay beat the repo. Scope: **every English copy edit to any of the
~293 seeded keys had silently done nothing in production since that seed.** Fixed — the default
locale never takes the DB overlay, because the portal was always a *translation* tool and
renders English as its read-only master column. Translations overlay exactly as before.

**The clinician trust line is restored** (2026-08-16). It was removed because it was not true —
P1.9.7 and P1.9.8 have both landed, so it is, and it now leads the trust section. The rule it
came from stands: a claim about review goes on the page *after* the review is verifiable from
the page, never before.

**Verified on production 2026-08-11** — `/en` and `/ar` both serve the new page, the Arabic
crisis copy renders, and `Scaffold online` is gone. Still owed: a human looking at it at 390px
in light and dark. Curl proves the copy, not the craft.

## R2 has started — the Track D registry exists (R2.1, 2026-08-11)

`apps/web/src/lib/experience/` holds the contract (`types.ts`) and the first registry
(`registry/track-d.ts`). **Data only — nothing consumes it yet**, which is the point: R2.2
builds `buildExperienceConfig` on it and R2.3 renders the pregnancy dashboard from the result.

**The finding that makes the engine tractable:** reading D1, D2, D3, D4 and D7 end to end, the
specs do not describe 73 configurations. They describe **one spine plus layers**. D1 is the
spine and gestational age computes everything. D3, D4 and D7 each state that the D1 experience
stays "completely intact and foregrounded" and their own tools are *added* — so they extend D1
and contribute strips. D2 is an **emotional** layer, not a clinical one: it stacks on any D
persona, the clinical layer wins the hero, and the anxiety-aware tone plus loss-suppression stay
armed on top. That composition is why the remaining personas are additions to a table rather
than branches in a screen.

**R2.2 landed** — `buildExperienceConfig` is pure, clock-injected and lifts into an Edge
Function unchanged. It found the flagship bug on the way: an emotional layer was stealing the
hero, so pregnancy + thyroid + prior loss produced a milestone card instead of the pregnancy
timeline `docs/09` §8 specifies. Caught because a test's *name* disagreed with its assertion.

**R1.6 landed** — `assets/mockups/R1.6_pregnancy_dashboard_reference.html`, the dashboard drawn
as **modules**: a 14-module inventory plus four assembled personas whose module lists are copied
from the engine's real output. Building it exposed a second engine defect — strips were
appended below the quick-log rather than sitting under the hero, which is where you put
something nobody asked for. Fixed with a test.

**R2.3 landed — the engine reaches the screen.** `persona_id`, `modifiers` and
`emotional_context` had been written at onboarding and read by nothing since; the pregnancy
dashboard now renders `ExperienceConfig.home.modules` through a module registry, so D3, D4 and
D7 differ **from data alone**. There is no `personaId ===` anywhere in a component, and
`pnpm persona-branch-lint` fails the build if one appears.

Two things worth knowing before extending it:

- **A clinical strip is facts, never a verdict.** `ClinicalStrip` has no `status`, `inRange` or
  `severity` prop and must never gain one — it shows the value, the unit and the lab's own
  reference range, then stops (D7 §G). Same reasoning as the movement log's missing `result`
  column.
- **Unimplemented modules are listed, not skipped.** `UNIMPLEMENTED` in `module-registry.tsx`
  names every id the registry can emit that has no component yet, and a test asserts the two
  sets cover the registry. A module that vanished silently would let the engine look correct
  while a woman's screen lost a panel.

**She can now correct herself (P1.27.3, P1.27.4a, R2.6, 2026-08-12).** Settings has "Re-answer
the questions", and the mode picker finally re-resolves properly. The bug it fixed was live and
user-visible: **a woman with a recorded thyroid condition who chose "I'm pregnant" in Settings
got D1 and silently lost the thyroid layer she had at signup**, because `switchMode` wrote the
track's first persona from a lookup table while leaving the resolver's modifiers behind.

One rule to know before touching it: **re-answering the triage is the only place in the product
allowed to delete.** It replaces `source='self'` condition rows, because leaving a retracted
"PCOS" on file would make the record less true and keep shaping her experience against her
wishes. Screener rows (P2.7) are never touched — those are not hers to retract by re-answering
a wizard question — and both sides of the change go to `adaptation_events`.

**R2.4 is half done (2026-08-12): tier 1 is portable and the fixtures exist.**

The medical logic can now leave the browser. `AgeBand` and `PersonaMode` moved to pure
`lib/persona/{age,modes}.ts`, because importing them from `state.ts` was quietly dragging the
Supabase client into the resolver — nothing broke in the web app, which is exactly why it
needed a guard rather than a memory. `pnpm tier1-portability-lint` holds 12 modules to
framework-free, data-free, alias-free, and adds two clock rules: no bare `new Date()` outside
`dates.ts`, and no `todayISO()` inside a computation where it cannot be injected.

**`fixtures/domain/*.json` is the anti-drift mechanism for Flutter** — 31 committed cases across
cycle prediction, gestational age, phase, persona resolution and `ExperienceConfig`. The TS
suite loads them; the Dart suite will load *the same files*. New behaviour lands as a new
fixture before it lands as code in either language. **Do not regenerate them from the
implementation** — a fixture that always matches proves nothing; a change to one is a change a
reviewer looks at.

**The Edge Function and the client ladder are written (2026-08-12).**
`supabase/functions/experience/` imports the tier-1 modules **directly from `apps/web/src`** —
one implementation, not a copy that drifts, which is the only reason the portability guard
exists. It runs the caller's JWT rather than the service role, so **RLS is still the security
boundary**; it never writes; and it takes `today` from the caller, because she is the one in a
timezone and a UTC server deciding it is already tomorrow would shift her gestational age by a
day.

`lib/experience/client.ts` is the ladder: **server → cache → local.** The local step is not a
nicety — deploying is an owner task, and a screen that broke while waiting for a deployment
would be worse than no engine at all. The three produce the same document because they run the
same modules. The cached one carries her `modifiers`, i.e. her conditions, so it is user-scoped
and cleared on sign-out.

## R2.4 closed — and what the swap exposed (2026-08-16)

`dashboard-screen.tsx` calls `loadExperienceConfig`; `pregnancy-experience.tsx` and
`postpartum-experience.tsx` render what comes back. Neither resolves anything any more — no
`buildExperienceConfig`, no registry lookup, no `Resolution` built from props.

**It was billed as a one-line swap and it was not, which is the useful part.** Making the
server the authority meant the server's answer had to be right, and in three ways it was not:

- **`weeksSincePregnancyEnd` was written by nothing.** `E1.requires` gates on it, so the gate
  could only fail: **Track E was unreachable from the live record.** R2.5 looked fine because
  the browser was composing E1 by hand from the stored persona id and never asking the
  resolver. The lesson generalises — *a screen that builds its own answer cannot notice that
  the pipeline behind it is dead.*
- **The phase came only from a pregnancy row.** A woman who installs Femio two weeks after
  giving birth has never had one, so she got a Track E persona whose every module is filed
  under `postpartum`, against a null phase, and therefore an empty dashboard. `phaseForTrack`.
- **"Her stated stage wins the track" (R2.6) lived in `switchMode`,** where the Edge Function
  could not see it — so the server would have served her the generic document, i.e. the
  next-period prediction R2.5 exists to stop. Now `resolveForStatedTrack`, in tier 1.

Two duplications died with it, both of which had already drifted:
`lib/persona/signals-from-rows.ts` is now the single rows→signals derivation (the Edge Function
had a hand-copy that said it "mirrors `signals-from-db.ts` exactly" while hard-coding
`ttcIntent` differently — **C1/C6/C8 could resolve on the server and never in the fallback**),
and `lib/experience/layers.ts` owns `prior_loss` → **E6 in Track E, D2 in Track D**. That
mapping sat in four files and three had it wrong for E: D2 is a pregnancy carried *after* a
loss, E6 is the loss.

**The rule this leaves behind:** the local fallback must call the *same functions* as the Edge
Function, not equivalent ones. `tier1-portability-lint` (16 modules) and the golden fixtures
(42 cases, Track E included) are what keep that true.

## First action for the next session

Take the top open item under ▶ NOW. Right now that is **R2.5c** (Track A, the last track with
no mode), then R3 depth: **P2.2.3** appointments, **P2.1** TTC toolkit, **P2.4** menopause —
none of which need content. Postpartum content drafting (P2.3c) is unblocked as of 2026-08-16.
