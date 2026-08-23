# Femio — current state (living document)

**Last updated: 2026-08-18.** This file replaces the seven dated handover documents, which
are now in `docs/archive/` (ADR-062). **Rewrite this file in place; do not create a new one
per session.**

## ▶ Resume prompt — paste this into a new chat

> Read `CLAUDE.md`, then this file, then `docs/07_MASTER_TODO.md` → **▶ NOW**. Skim
> `docs/23`/`24`/`25` only if the task touches strategy, architecture or design.
>
> **Where things stand (2026-08-23, third pass).** The `docs/27` revamp is closed, and so are the
> three items queued after it and the two biggest not-started ones. **Partner sharing** is built,
> deployed and **cleared for the private beta** (ADR-068, ADR-069). **The persona-branch ratchet is
> finished** — `MODE_BASELINE` is empty. **The pattern engine ships** (P2.5, the stated
> differentiator) and **notification preferences ship** (P2.8, delivery pending one owner key).
> Two live defects were found by running the gate rather than by looking for them: Arabic readers
> were getting the **English crisis dialog** on every page, and the visit report **printed
> illegibly in both themes**. 756 unit tests, 74 e2e, eleven guards, migrations through 0013.
> **Read `docs/07_MASTER_TODO.md` → the readiness score and then R3.6** — the score was
> re-measured this pass and its "shortest path" list is now the launch path.
>
> **The live workstream is the 2026-08-21 revamp.** `docs/26` is the audit — what is wrong,
> measured, with screenshots and request logs. `docs/27` is the plan answering it, phases 0→6,
> a checkpoint after each. Read both before touching a screen: `docs/26` records defects that
> are invisible on an empty account, and `docs/27` carries design rules this session added
> (dense with *her data*, never with article cards; one accent per screen; no pink-flowery
> defaults; every screen earns its scroll).
>
> **Read "Environment traps" in this file before running anything.** Each entry cost real time
> at least once. The 2026-08-21 block is the most recent and the most repeatable: do not build
> while `next dev` runs, do not `git add -A`, and check `docs/25` §5a before drawing anything.
>
> **Build. Do not report.** I do not want to read anything unless you need my input. No
> summaries of what you did, no options, no plan confirmations. Put what needs my eyes in
> `MANUAL_TEST_PLAN.md`, what needs my decision in `BLOCKERS.md`, and everything else in the
> commit message. Work several items per pass.
>
> Anything that needs my input goes into `docs/runbooks/BLOCKERS.md`; anything needing my eyes
> goes into `docs/runbooks/MANUAL_TEST_PLAN.md`. Add it there silently and carry on with the
> next unblocked item.
>
> Jump in large steps. Take the whole of an item, not a slice of it.
>
> **First, run `git branch --list "wip/*"`.** A branch there means the last session was cut off
> mid-item; finish that before starting anything new (see the `wip/` rule below).

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

### When the stop lands mid-item — the `wip/` rule

Between items the loop above is enough: the work is committed, gated and pushed, and a session
that ends there costs nothing but tokens. **The exposed case is a stop in the middle of step 2
or 3**, where the tree holds real work that has not passed the gate. Losing it is bad; pushing
it to `main` is worse, because `main` is what Vercel deploys and its one guarantee is that
everything on it went through the gate.

So, when work must stop with the tree dirty:

1. **Commit everything to `wip/<item-id>`** — e.g. `wip/P2.4-hrt-log`. Never to `main`.
2. **Prefix the message `wip:`** and say three things in it: what is built, what is not, and
   what the next action is. A WIP commit must be unmistakable at a glance in `git log`; the
   failure to avoid is a half-finished change that reads like a finished one.
3. **Leave the TODO line `[~]`.** It is not done. Do not write a `[x]` for work that has not
   been gated.
4. **Name the branch in this file**, in one line under *First action for the next session*.
   That is what makes it recoverable from `git log` plus this file alone, which is the whole
   property this discipline exists for.
5. **Claim nothing about the gate.** If it did not run, say so in the commit message.

Resuming: `git log main..wip/<item-id>`, finish on the branch, run the full gate, then merge to
`main` and delete the branch. A `wip/` branch that outlives its item is a lie about the state
of the work — clean it up when the item closes.

**`main` never carries ungated work. `wip/` never carries a claim that it does.**

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

**Build. Do not report.** The owner's instruction, sharpened on 2026-08-16: *"I do not want to
read anything unless you need my input."* So — **no end-of-turn summaries, no "here is what I
did", no explaining a decision he did not ask about.** The commit message carries the
reasoning; this file carries the state; `MANUAL_TEST_PLAN.md` carries what needs his eyes.
Speak only to ask a question you cannot answer yourself, and then in a few lines.

Everything else that used to be said in chat now has a home:
- needs his **decision or a credential** → `docs/runbooks/BLOCKERS.md`
- needs his **eyes** → `docs/runbooks/MANUAL_TEST_PLAN.md`
- needs a **one-off command or a key** → `docs/runbooks/OWNER_MANUAL_TASKS.md`
- everything else → the commit message and this file.

**Work in large steps.** Take several queue items per pass, not one. Do not stop between them
to check in.

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
- **Supabase: `repair` is for SQL that has already run, `push` is for SQL that has not.** When the
  schema is right and only `supabase_migrations.schema_migrations` disagrees, `migration repair
  --status applied <version>` fixes it and executes nothing. `db push` will try to re-run the
  migration and fail with `42P07`. `db push --dry-run` may suggest `--include-all`; taking that
  offer on an already-applied migration is the same trap. Diagnose with `migration list --linked`
  — the row where `Local` has a version and `Remote` is blank is the whole problem — and confirm
  by probing for the artifact the migration creates before touching either command (B11).
- **Windows:** `pkill` does not kill `next start`; kill by port.
- **A registry change is inert until the Edge Function is deployed.** `experience/index.ts`
  imports `PERSONA_RECORDS` straight from `apps/web/src`, and the function is tier-1 *authority* —
  the local computation is only a fallback for when it has not been deployed. So editing
  `lib/experience/registry/*` and testing locally proves nothing about what a user is served:
  Track C gained the cycle modules and the dashboard measured **exactly the same 844px** until
  `npx supabase functions deploy experience` ran, at which point it became 1646px. Worse, R3.1.6
  had shipped `track-z.ts` *and deleted the hardcoded branch that compensated for its absence*
  without a deploy — leaving the fallback persona thinner in production than before the fix, for
  as long as that gap lasted. **Deploy the function in the same pass as any registry change, and
  measure after, not before.**
- **Run the whole guard set, not the three you remember.** `pnpm typecheck && pnpm test` plus
  *every* `*-lint` script. Adding UI copy across a long session and checking only persona-branch,
  tier-1 and client-i18n let two failures sit in a clean tree until a full sweep found them:
  `claims-lint` rejecting "never a diagnosis" (the meaning was right, the word is still forbidden
  — the guard keyword-scans and cannot read a negation) and `i18n-untranslated-lint` flagging a
  genuine French cognate. The full list: persona-branch, tier1-portability, i18n-client,
  i18n-untranslated, content, content:test, claims, crisis, analytics, native-readiness,
  tokens-parity.
- **Contrast cannot be measured with `getComputedStyle` alone.** Two things break it and both
  produced false failures: an element painting a **gradient** reports `backgroundColor:
  transparent`, so walking up for a background measures text against the page behind it (white on
  white, 1.04:1); and a **semi-transparent** background like `rgba(124,58,237,.18)` must be
  composited over what is behind it before any ratio means anything — reading its RGB and dropping
  the alpha reported 3.09:1 for a badge that is actually 5.4–8.9:1. Exclude gradient-backed text
  and composite alpha, or the tool invents defects.
- **Prove the persona resolved before calling a screen empty.** Three findings in the 2026-08-21
  revamp were measurement artifacts, all the same shape: a script drove the product wrongly and
  the result was written up as a product defect. The subtlest answered "I'm a teenager" and then
  picked the 25–34 age band — the resolver weighs stage against age, and a contradiction there
  does not error, it quietly serves a different persona. The badge in the dashboard header says
  which one she got; check it before believing a height. `scripts/dev/seed-and-shoot.mjs` now
  derives a coherent age band from the stage.

### Added 2026-08-21 (the revamp session — each of these cost time in that one pass)

- **Never run `pnpm build` while `next dev` is running.** They share `apps/web/.next`, and the
  build overwrites the dev server's chunks underneath it. The dev server then 500s with
  `Cannot find module './vendor-chunks/…'`, which reads like a dependency problem and is not.
  **Stop the dev server, then build.** Cost two separate debugging detours in one session
  because the symptom does not look like the cause.
  - **Extended 2026-08-23, and the extension is the expensive half: a dev server can be running
    that *this* session did not start.** One survived from an earlier session, holding :3000 for
    the whole pass. `pnpm build` therefore hit the trap above without anyone typing `pnpm dev`,
    and — worse — the CI e2e run silently went to that dev server instead of the built app.
    `playwright.config.ts` sets `reuseExistingServer: !process.env.CI`, so under `CI=1` it starts
    `pnpm start`, which cannot bind a port already taken; the config's `url` check then succeeds
    against the squatter and the suite runs against the wrong server. It produced **forty minutes
    of no output at all** and would have been reported as a pass or a hang, never as "you tested
    something else". **Check the port before you build and before you run e2e** — a green e2e
    against `next dev` proves nothing, which is the very first trap in this list:

    ```powershell
    Get-CimInstance Win32_Process -Filter "Name='node.exe'" |
      Select-Object ProcessId, CommandLine     # look for `next dev`
    Get-NetTCPConnection -LocalPort 3000 -State Listen
    ```

    `pkill` does not kill it (see below); `Stop-Process -Id <pid> -Force` does.
- **Never `git add -A` in this repo.** It swept a Playwright storage-state file holding a live
  Supabase session cookie into a commit, which then needed a history rewrite and a force-push.
  Stage paths explicitly. `.seeded-state.json` and `screenshots/` are gitignored now, but the
  next stray artifact will not be.
- **Read `docs/25` §5a before building any visualisation.** Rings and circular progress are
  rejected *explicitly*, with reasoning (a ring implies a target and a completion). A cycle ring
  was half-built before that was found. The prescribed vocabulary is the **band**, the **strip**
  and the **stack** — use those.
- **A full-page screenshot places `position: fixed` elements at the initial viewport origin.**
  The crisis pill and the tab bar therefore *appear* to overlap content mid-page in every
  full-page capture. That is an artifact. Confirm any overlap by measuring bounding-box
  intersection at the real scroll position before writing it down as a defect — one real
  consent-screen overlap was found that way, and several false ones were avoided.
- **Audit with data, not just an empty account.** The dashboard shows least when it has least,
  so an empty-state pass missed a duplicated prediction hero and a second dead end that only
  appear once cycles exist. `node scripts/dev/seed-and-shoot.mjs --out DIR` builds a user with
  three logged cycles and shoots light, dark and Arabic in about twenty seconds.
- **A golden-fixture failure is the system working.** Changing anything in a tier-2 module will
  fail `golden-fixtures.test.ts`. Read what changed and edit the fixture *by hand*; never
  regenerate. One such failure caught a fix that would have flipped `regularityFrom` from one
  unfounded claim about her cycles to the opposite one.
- **The Supabase session is a cookie, not `localStorage`.** `@supabase/ssr` stores it as
  `sb-<ref>-auth-token`, chunked across `.0`/`.1` past 4KB and prefixed `base64-`. Reassemble in
  name order and decode. Guessing `localStorage` fails as "no auth token", which reads like a
  broken login rather than a wrong assumption.
- **Drive Playwright with labels read from `messages/<locale>.json`**, not hand-written regexes
  and not positional selectors. Guessed Arabic labels failed unverifiably in a console that
  mangles the script; a positional fallback was worse — it silently matched a *disabled*
  Continue and hung every run.

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

## R2.10 — the log screen, and where it actually is (noted 2026-08-17)

Three things the next session would otherwise have to rediscover, checked on the current head:

**The file is `components/cycle/track-screen.tsx`**, not `components/track/`. 187 lines, and the
branch appears at **five sites** off one `isPregnancy` const on line 58, which is itself
`modeFromTrack(personaState?.track) === "pregnancy"`.

**`persona-branch-lint` does not flag it today.** Its baseline holds one file and that file is
`components/dashboard/dashboard-screen.tsx` — track-screen is not baselined and passes anyway. So
the target of R2.10 is a mode branch the guard is not currently catching, which is worth
understanding before the refactor rather than after it: either the guard should catch this form
and does not, or the form is deliberately outside it, and only reading the rule will say which.
Do not widen the guard to make a point — the R2.7 lesson is that when a guard fires on new code
the decision is usually in the wrong layer, and the inverse deserves the same care.

**Two `LogKind`s are missing** and both must be decided in `types.ts`, never invented in a
component: fertility (P2.1 shipped `/fertility` with no kind, so the dashboard reaches it through
a `mode === "ttc"` button) and feeding (P2.3). `ExperienceConfig.tools` is a real served field of
ten kinds that no screen reads — the same write-only shape `docs/23` §3.1 opened this workstream
with, one screen after R2.3 closed it for the dashboard.

## Content is closed — 2026-08-19, owner direction

**All 105 articles are published.** The owner directed that nothing needs his prior approval and
that content stops being a workstream: *"we are not bloggers or journalists… from the next prompt
we are only developers."*

**Do not write another article.** Not to fill a `NO_ARTICLE_YET` entry, not because a reading card
shows two links instead of four, not because a topic list looks incomplete. Eight topics stay
listed — four in Track B, four in Track F — and a test asserts they stay listed. A counted gap is
the correct end state, and removing them quietly would be worse than leaving them.

**The drift worth remembering, because it was mine.** The readiness ordering in
`07_MASTER_TODO.md` put publishing and screens above content, and four consecutive passes went to
writing articles anyway — because articles are bounded, gate cleanly and always succeed, while
screens are ambiguous and need judgement. Safe work is not the same as valuable work, and a queue
exists precisely to stop that substitution.

**From here: build the product.** R1.9 (the dashboards for B, C and F), then the beta path
(P0.12.5 → P1.24). Content re-opens only on evidence from a real user.

## The page behind Track F's only red flag exists (R2.9b, 2026-08-17)

`menopause.pmb` was live, the alert was live, and there was nowhere for a woman who tapped through
to land. `postmenopausal-bleeding` is written, imported as a draft and mapped, so it appears on the
dashboard the moment the owner approves it — no deploy.

**The test that pinned the gap was inverted, not deleted.** It used to assert the topic was counted
as missing; it now asserts the topic resolves to a slug and is no longer counted. What is worth
guarding is the *pairing* — the only red flag in the track, and the page behind it — and that
survives either way.

**Checking a source's HTTP status is not checking the source.** `content-lint:urls` passed NG23
happily; reading the page title showed NICE renamed it *identification* and management in 2024,
while the front matter said *diagnosis*. Read the `<title>`, not the status code — the same trap
the last session hit with an ACOG page that returned 200 over "Page Not Found".

## The six references are drawn — R1.5, R1.7 and R1.8 landed (2026-08-16)

`assets/mockups/` now holds five of the six screens `docs/25` §3 asks for: homepage (R1.3),
onboarding (R1.4), pregnancy (R1.6), **cycle (R1.5), menopause (R1.7) and track/log (R1.8)**.
Only R1.1b, the owner's hour of screen recordings, is still owed before implementation (R1.9).

**Read the box at the top of R1.5 and R1.7 before trusting their module lists.** R1.6's
assembled screens were copied from `buildExperienceConfig`'s real output, and these two could
not be: `registry/` holds tracks A, D and E only. So their lists are read from the persona
specs and are a **specification for** Track B (R2.8) and Track F (R2.9), not a copy of anything.
The files say so at the top rather than implying an engine output that does not exist.

**What each decided, in one line, because these are the arguments not the pictures:**

- **R1.5** — *different personas get a different hero, not the same hero with more cards.* B2's
  hero is a control and B4's is her own bleeding count, which is the test R1.6 could not run
  because every D persona shares the D1 spine. The honest absence gets the hero at full size —
  B5's window is dotted and unfilled in the same slot — because demoting "we don't know" to
  grey small print teaches that uncertainty is a failure state. The ring is **replaced** by the
  phase strip rather than merely removed, with the ovulatory segment faded at both edges and no
  date and no word "fertile" on it. And the cycle dashboard has **no red panel at all**, which
  is the deliberate opposite of pregnancy.
- **R1.7** — the brief was one sentence (*reports a count and refuses a conclusion, and it must
  read as respect rather than evasion*). What replaces the rejected ring is the shape of the
  transition with no destination drawn: cycle lengths as columns, **skipped cycles as dashed
  outlines rather than gaps**, because a gap reads as missing data and a skipped cycle is data.
  The MRS's missing severity word is answered with **her own previous totals** as the context.
  PMB is the only red panel in the track, outranks the hero, and is never attributed to dryness.
- **R1.8** — the finding is structural. **`ExperienceConfig.tools` exists, is served, and the
  log screen ignores it**, branching on `isPregnancy` three times — the write-only shape
  `docs/23` §3.1 opened this workstream with, one screen after R2.3 fixed it for the dashboard.
  Filed as R2.10, and it surfaced two more: **fertility logging (P2.1) has no `LogKind`**, so
  the engine cannot reach it and the dashboard uses a `mode === "ttc"` button, and feeding has
  none either.

All three were **executed in node** rather than looked at — every module id drawn, no
`undefined` leaking, RTL and dark rendered — and the checker was watched failing on a renamed
module and a renamed field before being trusted. The visual judgement is the owner's;
`MANUAL_TEST_PLAN.md` T23 is the checklist.

## Track B exists, and it was hiding a live defect (R2.8, 2026-08-16)

`registry/track-b.ts` holds B1, B5 and B6. **Data only, like R2.1** — no component renders a
cycle module yet — but the half of the document that needs no component is live from today:
tone, alerts, EMR view and the reading list now come from her record rather than from
`mode === "cycle"`.

**Two versions of the same bug, both found by encoding the registry rather than by reading it:**

- **B6 was unreachable.** B5 and B6 both scored a perfect 1.0 for a woman with PCOS and
  irregular cycles, and B5 won on rule order. The PCOS she took the trouble to report changed
  nothing about her app. This is the trap for the **fifth** time (C1/C2, E1/E2, the hero hoist,
  E1 against E3/E4/E7) and the rule is unchanged: *when a specific persona extends a general
  one, the general one needs a signal that is false in the specific case.* B5 gained
  `conditions.length === 0`, which is not a patch — §I defines B5 as **cause undetermined**, and
  a named cause routes elsewhere.
- **The larger one: B1 outscored B6 for a woman with PCOS and currently-regular cycles**, because
  "no condition" was worth 1 against "regular cycles" at 3. Raised to 3. Kept a **signal, not a
  gate**: gating B1 would drop a woman with a thyroid condition and ordinary cycles to Z1, since
  Track B has no B17 rule to catch her, and that is restriction dressed as precision.

**Two window modules, not one with a flag.** `cycle.window` predicts; `cycle.variability` shows
her own lengths and declines to. Whether Femio predicts at all is a tier-1 decision, so it is
*which module the record contributes* — the same shape as A1 contributing no window (ADR-041/042).
A `predict: false` param would have made the safety decision a value.

**Two golden fixtures moved, and were checked rather than regenerated.** Both properties they
encode still hold. The one to remember: an account with nothing logged now scores B1 at **0.28**
rather than 0.21, still under `OFFER_THRESHOLD` (0.4) — worth watching as more weight lands on
facts that are true of someone who has told us nothing.

## All three content sets are home — the week-by-week 37 landed last (P2.2.2, 2026-08-18)

Written **here**, like the teen ten and the newborn eight, because the chat holding
`docs/content/HANDOVER_WEEK_BY_WEEK.md` since 2026-08-16 never came back. 37 drafts,
`pregnancy-week-4` … `pregnancy-week-40`, 612–823 words each, three Tier-1 sources apiece,
imported as CMS drafts. **101 files now pass the content guard.** The consolidation record —
every source, every size comparison with the measurement behind it, the five places the
"measurement of her baby" line was hardest, and what was cut — is
`docs/content/HANDOVER_WEEK_BY_WEEK_RETURN.md`.

**Checking a source's title, not its status, caught two dead pages.** `content-lint:urls` would
have passed both: **acog.org serves HTTP 200 with a "Page Not Found" body** for a dead FAQ slug,
which is the trap `docs/23`-era sessions hit twice before. All 70 unique URLs were fetched and
their `<h1>` read. Also worth keeping: **NHS moved the entire week-by-week guide** under
`/best-start-in-life/…/{1st|2nd|3rd}-trimester/week-N/`, the old `/pregnancy/week-by-week/`
paths 301 rather than 404, and **week 13 is filed under the 2nd trimester**, not the 1st.

**§0.2 held in all 37.** Every figure is population-framed and attributed in the same sentence —
*"around week 12, the NHS gives a measurement of 5.4cm, about the size of a plum"* — never *"your
baby is"*. **No fetal weight appears anywhere in the set**: the NHS week pages do not give
per-week weights, and every table that does traces back to app blogs. A weight is the single
number most likely to be read as a verdict on a scan. **No movement count appears either**; from
week 23 the red-flag box says *any reduction in her usual pattern*, routed to maternity services.

**The engine half is the more interesting one, and it closed the oldest defect in the workstream.**
`week-by-week` left `NO_ARTICLE_YET` for a new `WEEK_AWARE_TOPICS` list resolved by
`weekArticleSlug`, because it is the first topic in `reading.ts` whose answer depends on a fact
about her record rather than on a lookup. The pregnancy dashboard's reading slot now renders
`ReadingList` over D1's own `content.foreground` — **the three hardcoded links there were the last
live instance of the write-only shape `docs/23` §3.1 opened this workstream with**, surviving one
screen after P2.3c fixed it for postpartum. The week comes from `pregnancyProgress`, the single
place that turns an EDD into weeks, so the card and the hero above it cannot disagree.

Two boundaries are held by tests, both watched failing before being trusted:

- **Nothing resolves below week 4.** Substituting the week-4 entry to fill the slot would be the
  invented-window defect ADR-041/042 fixed at three other life stages, in content form.
- **Week 40 stands past the due date** rather than falling off the end, because term runs to 42
  weeks (ADR-053) and that entry is the one a woman at 41 weeks is searching for.

**Nothing is public.** `MANUAL_TEST_PLAN.md` **T25** is the checklist, and the reading card fills
itself in per-article as the owner approves — no deploy.

## The teen ten are written and imported (P2.13, 2026-08-17)

Written **here** rather than in the handover chat, on the owner's instruction — the prompt in
`docs/content/HANDOVER_TEEN_CONTENT.md` had gone out on 2026-08-16 and nothing had come back.
Ten drafts, 55 files now pass the content guard, and `pnpm content-lint:urls` resolves every
source. All Tier 1: ACOG (*Your First Period*, and the menstrual-cycle-as-a-vital-sign committee
opinion), NHS (periods, starting periods, period pain, period problems, irregular periods,
missed periods, early or delayed puberty, toxic shock), NICHD (puberty, menstruation), the FDA
tampon-safety page, the AAP's puberty page, and the US Office on Women's Health.

**§0.1 held, and it is the rule the guard cannot check.** No condition is named as a possibility
anywhere. Two names do appear and both are deliberate: *dysmenorrhea* only inside an ACOG page
title in a citation, and *toxic shock syndrome* in the tampon sections, because the FDA and NHS
both name it as the reason to follow the packet instructions — product safety, not a diagnosis
put in front of a thirteen-year-old. Nothing predicts a first period, articles 1–4 read for
someone who has not started, and there are no doses, no drug names and no phone numbers.

**The importer caught what the guard could not.** It requires the body H1 to equal `title`, so
ten title-cased front-matter titles were refused; they are now the H1 verbatim, which is what
"one H1, in her words" actually means. Worth remembering: `content-lint` passing is not the same
as the importer accepting.

**`content.foreground` is fully answered for Track A.** All eight topics resolve to real
articles, `NO_ARTICLE_YET` lost its entire Track A block, and **A2 gained `period-pain` and
`telling-an-adult`** — the two a teenager is most likely to be searching for alone, and the two
the registry previously had no topic that could reach. The A2 golden fixture moved with it.

**Nothing is public.** `MANUAL_TEST_PLAN.md` **T24** is the checklist, and it is the one that
most wants a clinician.

## Track F exists, and logging a bleed used to throw her out of it (R2.9, 2026-08-17)

`registry/track-f.ts` holds F1 and F2. Data only, like R2.8. Encoding it found three defects,
and the middle one is the worst the engine has produced so far.

- **F1 did not count a skipped cycle.** `signals-from-rows` returns `"absent"` once ninety days
  have passed, and F1's largest signal matched `"irregular"` only — so a 47-year-old four months
  past her last period scored *lower* on the persona she fits best. F1 §I asks for the opposite
  in as many words: *"skipping / long gaps ⇒ late-transition emphasis."*
- **Logging a bleed threw a postmenopausal woman out of Track F.** F2's gate was
  `daysSinceLastPeriod >= 365`. The moment she recorded the one thing F2 §G calls *"the main
  warning sign clinicians look for"*, her days-since counter reset, the gate failed, and she
  resolved to B5 — **she lost the persona whose entire job is that bleed, by doing what it asked
  her to do.** The fix is a tier-1 signal, `postmenopausalBleed`, derived from a year-long gap
  between two of her own logged starts. It is a fact about her record and never a finding: what
  it means is a clinician's. Structurally identical to `weeksSincePregnancyEnd` before R2.4 — a
  gate that could only fail.
- **F2 was unreachable behind F1.** Both scored 1.0 for a woman eighteen months past her last
  period and F1 won on rule order. The trap, for the **sixth** time. F1 gained a
  *within-the-year* signal, which is the persona's own definition rather than a tiebreak.

**B5 moved too** — it was beating F1 for a woman in her late forties with absent cycles and hot
flushes, and B5 §J routes exactly that case to F1. It now carries a reproductive-age band signal
mirroring B1's.

**Two decisions in the record worth not reversing.** **F2 does not extend F1**: §I says no cycle
view at all, and `build.ts` has no path that subtracts a module, so they are siblings rather than
a layer. And **`period` stays in F2's tools** — §G says the bleeding log's purpose *flips* from
"track your cycle" to "note and act on any bleeding", so removing it would remove the only way
she can tell Femio the one thing it most needs to hear.

**Two things this leaves open, both filed.** **R2.9a — F6 (GSM) must not become a resolver
rule.** The signals exist (P2.4 added dryness and urinary urgency), which is why it is a decision:
§I offers discreet mode *before any content loads*, and a resolver that reskinned her home screen
because she logged dryness twice would announce her intimate symptoms on her own phone, unasked.
**R2.9b — the `postmenopausal-bleeding` article does not exist**, while the module and the
red-flag alert both do. Highest-priority single article in the queue.

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

## Every track has a mode now (R2.5c, 2026-08-16)

Track A was the last one the audit named. `registry/track-a.ts` (A1 + A2) and
`teen-experience.tsx` close it: before this a 13-year-old resolved to `general` and got the
adult cycle dashboard.

**A1 and A2 differ on one thing, and it is the clinical one.** A1 contributes no window,
because she has not started menstruating — predicting a first period from no data would be the
invented-window defect ADR-041, ADR-042 and R2.5 each fixed at a different life stage, aimed at
a child anxious about exactly that. A2's window is wide and carries its reason *inside* it.

Three things the work exposed, all pre-existing:

- **A track with no phase contributed no modules.** `Phase` is Track D's vocabulary
  (gestational age computes it), so the engine would have resolved A2 correctly and rendered an
  empty screen. `PersonaRecord.home.default` is the fix; Track D is untouched by it.
- **B1 outscored A2 for a teen with steady cycles** — the adult general-tracker persona,
  winning for a 13-year-old. That is the "17+ gap" A2 §C names as the category's recurring
  failure, reproduced in Femio's own resolver. B1/B5/B6 now require a non-adolescent age band;
  an *unknown* band still passes, or B1 would stop resolving for nearly everyone.
- **Onboarding wrote the resolver's track, not hers.** R2.6 fixed that in `switchMode` and
  never came back for signup, so "I recently gave birth" with no pregnancy row was filed as
  `general` from the first screen.

Two smaller fixes rode along: the **hero now leads** (a layer's hero could render below the
base's first card — A2's window under a reassurance card, E6's loss-aware card under a
check-in), and there is **one log button per dashboard** (pregnancy and postpartum had rendered
two identical ones since R2.3).

## R3 has started — appointments exist (P2.2.3, 2026-08-16)

`public.appointments` had a table, an index, RLS policies and a line in the GDPR export since
schema v1, and **no code had ever written a row**. It is now a real feature at `/appointments`,
surfaced on the pregnancy dashboard by the module the registry has emitted since R2.1.

Two decisions worth keeping:

- **It is not a pregnancy feature.** The obvious build was a panel inside the pregnancy
  dashboard, and that would have been the restriction pattern rule 2 forbids — a fertility
  work-up, a gynae follow-up and a menopause clinic are all appointments. Own route, reachable
  from Settings in every mode.
- **There is nowhere to record what it found.** No result, no status, no "normal". Third time
  this codebase has made that call (ADR-049, R2.3) and the reason does not change: store a
  clinical finding and the next feature to read it is interpreting one. What it holds instead
  is the questions she meant to ask.

## Charting exists (P2.1, 2026-08-16)

`fertility_logs` was the third table unused since v1. BBT, OPK and cervical mucus now write to
it at `/fertility`.

**The chart is dots and an axis and nothing else** — no shift line, no ovulation marker, no
shaded band — and `lib/fertility` exports no `ovulationDay`, `thermalShift` or `isFertile`,
with a test asserting it never gains one. The reasoning is worth keeping: reading a thermal
shift is a clinical inference from a home measurement (rule 1), and the feature everyone builds
on top of one is "days you could avoid", which crosses the medical-device line and the
contraception line in a single step. The table's schema comment has said *"conception
AWARENESS, never contraception"* since v1; this is the first screen that could say it to her,
and it says it at the top.

`isPlausibleBbt` is a **typo guard and must stay wider than any normal range** — 34–40 °C are
both valid — so it can never drift into "your temperature is abnormal".

## The first screener exists (P2.4, 2026-08-16)

`screener_results` names MRS in its own schema comment and had never held a row. The
Menopause Rating Scale now writes to it, and it sets the pattern every screener in P2.7 will
follow:

**It reports a number and refuses to grade it.** No band, no severity word, no threshold
constant in the module, and two tests assert none appears. The literature attaches cut-offs;
Femio does not apply them, because "your total is 19" is arithmetic on her own answers while
"your symptoms are severe" is a clinical assessment — and the woman that hurts is the one who
reads "mild" and decides the appointment can wait.

Partial answers travel with their count. Scoring a blank as zero would describe her as having
fewer symptoms than she reported, in a number she may read out loud in a consultation.

The scoring is tier 1 because R2.7's guard forbids screener scoring in a screen — and this is
the file that rule was written for: two clients disagreeing about an MRS total would give one
woman two different sentences in the same appointment.

## Partner sharing exists, and building it deleted an RLS policy (Phase 4.5, 2026-08-23)

`partner_links` was the seventh table shipped empty in schema v1. It now holds real data, reused
rather than replaced — v1 already carried the exact shape the design asked for, and a second
`partner_shares` table beside it would have been a second mechanism where the house pattern is one
revocable ledger.

**The reasoning is in `docs/compliance/PARTNER_SHARING_DESIGN.md` and ADR-068. Three things are
worth carrying forward without opening either.**

**The checkboxes are not the feature.** Seven categories, all off, no "share everything" shortcut,
six-month term. That part is ordinary. What makes it safe is that a **withheld category is absent
from the payload** rather than present-and-empty — his view is byte-identical to one in which Femio
has no symptom log at all — and that **revocation is silent**, so a revoked share, an expired one
and one that never existed produce the same response. Both properties are invisible in a screenshot
and both are the reason the feature is worth having.

**Building it required dropping `partner_links_select_involved`.** The v1 policy let the recipient
read the row naming him, "so they know their scope". That row carries `scope_json` — *the list of
what she concealed* — and `revoked_at`, which makes her revocation observable. It broke §2 and §3
of the design in one line of SQL written before either risk had a name. **If a future session sees
`partner_links` with no recipient SELECT policy, that is not an omission.** It is the feature, and
ADR-068 exists so nobody re-adds it.

**`partner-view` holds the service role and `experience` still must not.** A partner granted
`nextPeriod` and not `cycleDates` is entitled to a window derived from dates he may not see, and no
browser can hold that distinction. The Edge Function derives it with the same tier-2 modules the
dashboard uses. The three alternatives — filter client-side, re-derive in PL/pgSQL, or forbid the
combination — are compared in ADR-068 and each is worse.

**Verified against the live project, not locally** — `scripts/dev/partner-sharing-check.mjs`, and
it is committed so the check is repeatable rather than a claim in a handover. 20 assertions, three
real anonymous accounts, publishable key only, including that a `screenerResults` key is rejected by Postgres,
that `partner_shared_rows` returns 403 to an authenticated browser, that a code cannot be redeemed
twice, that an unknown age is treated as a minor, and that a revoked share returns JSON identical
to a stranger's. The accounts were deleted afterwards.

**Launch is still gated and never was on code:** `docs/13` §5 disclosures, and DPO sign-off on the
Art. 9(2)(a) wording. Femio has no DPO appointed (P0.12).

## The persona-branch ratchet is finished (R3.1.6a, 2026-08-23)

`MODE_BASELINE` in `persona-branch-lint.mjs` is **empty**. `dashboard-screen.tsx` was the last
entry and it has no `mode ===` left.

The four life-stage mounts did not become registry rows. Each screen now reads **`config.track`**
from the served document and decides for itself whether it has anything to draw — the same shape
`TtcExperience` has used since R1.9c. That is the point rather than a shortcut: `mode` was
`modeFromTrack(persona_state.track)`, a second answer computed in the browser, independent of the
document the screen was actually rendering. The two agreed; having two of them is what ADR-061
removes. The fifth branch — the pregnancy row read, gated on `mode === "pregnancy"` — went the same
way, so the browser and tier 1 can no longer disagree about who she is.

**Watching the guard fail first found a hole in the guard.** Injecting `mode === "teen"` and
running `persona-branch-lint` produced a **pass**: the `mode-branch` alternation listed
cycle/ttc/pregnancy/postpartum/menopause/general and never grew a `teen` when Track A arrived. So
the one branch the guard was explicitly waiting to see removed was the one it could not see. Fixed
in the same change, and re-verified by injection in both directions. This is the whole of
"Verification honesty" in one incident: the guard had been reported green for weeks while blind to
a member of its own enum.

## The visit report did NOT survive a print, in either theme (R3.1c.4, 2026-08-23)

The register listed this as "verified by hand, not by machine". It had never been verified either
way, and both themes were broken.

`scripts/dev/print-check.mjs` drives a seeded account to `/summary`, switches to `print` media and
measures the derived section — the dashed box separating what Femio estimated from what she logged
— compositing every alpha layer down to the paper first. What it found:

- **Printing from dark mode lost the heading.** "Worked out by Femio" is `--color-text`, near-white
  under `[data-theme="dark"]`, printed onto the white page `globals.css` forces. **1.12:1.**
- **Printing from light mode lost the dashed border.** `--color-border` is a pale lilac tuned
  against an app surface, not against paper. **1.26:1.**

Both erase the same thing: the boundary between what she recorded and what Femio derived, which is
the one distinction R3.1c built the section to make. A clinician who cannot tell an estimate from an
observation is reading a document that launders a prediction into a medical record.

**The cause was scope.** The `@media print` block forced `background` and `color` on `body` and
stopped. Both are inherited properties — so every descendant carrying its own token colour, which
is every heading, muted line and border in the report, kept it. The fix gives the printed document
a small explicit palette instead of the theme's: two text levels and a border grey at 4.54:1. Both
themes now measure 4.54:1 on the border and 18.88:1 on the heading.

**The tool was wrong before the product was.** The first run failed all fourteen assertions, which
would have read as "the derived section does not survive a print" — a defect that does not exist.
`page.evaluate` treats a **string** first argument as an *expression*, not a function body, so the
selector was never passed and every measurement came back `undefined`. Ninth measurement artifact
in this workstream; caught by dumping the DOM before believing the result, which is now the habit
that has caught most of them.

## Arabic readers were getting the English crisis dialog, and had been (2026-08-23)

Found by running the full e2e suite, which is the only reason it was found: the two `[ar]` crisis
specs were **failing on `main` and in production**, and the last handover recorded the suite as
green.

**What was wrong.** `NextIntlClientProvider` in the locale layout was mounted without a `locale`
prop. Messages were passed, so every client component reading a *message* rendered correct Arabic
and the app looked entirely fine. `useLocale()`, though, resolved to the default locale — and there
is exactly one client component that **branches** on the locale rather than reading a message:
`CrisisHelpProvider` calls `getCrisisContent(useLocale())`. So the launcher on every page rendered
`Need help now?` in a `lang="en"` span and the dialog opened in English, LTR — the copy the owner
personally reviewed and approved in Arabic (ADR-063), unreachable in the locale it was approved for.

**Why it survived.** `/ar/help-now` is a *server* component and was correct throughout. The page
you would check by hand was right; the launcher on every other page was not.

**The fix is `locale={locale}` on both providers** — the root layout and the `(app)` one, since a
nested provider replaces the context rather than extending it and would otherwise undo the fix for
every signed-in page.

**The reusable part.** `crisis-lint` passed the whole time, and correctly: the copy is approved, in
date, and in key parity. It checks the *content*, and the defect was in whether the content was
ever reached. Two guards can both be green either side of a gap. And a first pass at diagnosing
this produced a **false** reading — `curl | python -c "'<arabic>' in html"` compares against a
literal the shell has already mangled, which reported production as broken in a way it was not and
the built output as broken in a way it was not either. **Read the expected Arabic from the catalog
file; never type it into a command line.** That is the eighth measurement artifact here and the
second caused specifically by Arabic in a console.

## A new table can have perfect RLS and still be unreadable (2026-08-23)

Found by driving the **deployed** site and watching the network, minutes after calling the
notification work done. `GET /rest/v1/notification_prefs` returned **403** to its own owner.

**RLS narrows a privilege; it does not grant one.** Migration 0002 ran `grant … on ALL TABLES in
schema public to authenticated`, and `ALL TABLES` means *the tables that existed at that moment*.
Every table created since — `notification_prefs`, `push_subscriptions` — inherited nothing.
`partner_links` was fine only because it is a v1 table.

**Why the whole gate missed it.** Nothing failed. `readPrefs()` treats a missing row as the normal
state, which it is for anyone who has never opened the panel, so it returns the defaults — and an
*unreadable* table and an *empty* one are indistinguishable from the screen. The panel rendered
perfectly, every checkbox correctly unticked, and the first real user to change a setting would
have had it silently fail. Unit tests do not touch Postgres and the e2e suite has no signed-in
notification flow.

Migration 0014 grants the two tables and — the part that matters more — adds the
`alter default privileges … to authenticated` line that 0004 wrote for `service_role` and nobody
wrote for `authenticated`, which is the entire reason this was possible. It also **re-applies
0011's revokes**, because a blanket `grant execute on all functions` would otherwise hand
`partner_shared_rows` back to `authenticated` and quietly undo ADR-068's boundary.

`scripts/dev/notifications-rls-check.mjs` is committed and asserts the status codes rather than the
screen: read, write, read back, cross-account denial, the CHECK constraint, and that
`partner_shared_rows` is still 403 from a browser.

**The reusable rule: a new table needs a GRANT line or a default privilege, and "the screen looks
right" is not evidence that it has one.**

## Sentry, PostHog and 0006 were all already done — the file was wrong (2026-08-23)

The owner said so and was right. All three were carried as open owner tasks for weeks while being
live. What each check actually found:

- **Sentry** — DSN set, EU ingest (`ingest.de.sentry.io`), and a real browser session watched
  POSTing an envelope to it. Live.
- **PostHog** — key and `eu.i.posthog.com` both set in Vercel; the project accepted a test event,
  `200 {"status":"Ok"}`. Live.
- **Migration 0006** — applied, and its four functions exist: `insights_k()` returns 10 and the
  other three refuse a non-staff caller with 42501. `pnpm rls-audit` is 15/15 with no `[SKIPPED]`.

**The PostHog diagnosis is the part worth keeping, because it nearly produced a false bug report.**
`posthog-js` is **absent from the shipped bundle**, which reads exactly like "not configured" — and
it is the feature working: the SDK is a dynamic import *inside* `capture()`, so for anyone who has
not granted analytics consent no vendor code is ever fetched, which is what `docs/13` §6 requires
literally rather than approximately. Then, with consent granted, a Playwright run still sent
nothing: `posthog.capture()` returned `undefined`, which is what posthog-js does when it decides
the visitor is a **bot**, and headless Chromium announces itself as one twice over. Masking
`navigator.webdriver` and the user agent was not enough to convince it.

**So an automated browser cannot verify this feature, and a run that sends nothing is not evidence
of anything.** The endpoint POST is the check that works. Tenth measurement artifact in this
project, and the first where the tool was *correct* to refuse.

## The pattern engine, and the two things it refuses (P2.5, 2026-08-23)

`docs/03` §H.3 calls it *"the one feature I would actually pay for"*. Timing already existed;
co-occurrence, severity and a shared confidence model did not. All tier 2, all on the portability
guard, because a Dart client has to reach the identical answer.

**Confidence is a coverage measure, not a statistic.** Three to twelve cycles of self-reported data
collected without a protocol cannot support a p-value, and one printed next to a symptom would
imply a rigour that is not there. Three-for-three is `medium`: clean data is not the same as enough
data.

**Co-occurrence counts distinct cycles, never days.** Someone who logs both symptoms every day for
one bad week has seven co-occurrences and no pattern. The pair is stored alphabetically so no
direction can be inferred and there is no field that could carry one — this is the shape people
read as causation, and the copy says *together*, never *because*.

**Severity says `higher` and `lower`, never *worse*.** One is a fact about her entries, the other a
judgement about her health. An unrated entry is skipped rather than averaged in as a zero: "she
didn't rate it" must not read as "it didn't hurt".

Behind the `insights` consent, which reads *"use my entries to show me patterns and insights"* and
until now described nothing in the product.

## Notification preferences ship; delivery waits on one key (P2.8, 2026-08-23)

The first thing Femio does *to* a woman rather than *for* her, and the design follows from a
notification arriving on a lock screen in a room she did not choose.

Five kinds, **all off by default**. **Discreet wording on by default**, with the panel showing the
actual text rather than describing it — and the discreet body is *identical for all five kinds*,
because five distinct discreet messages are five distinguishable notifications and someone reading
over her shoulder twice learns the mapping. Her own quiet hours, honoured in the decision rather
than in the sender so no future scheduler can forget them. **No streaks, no missed-day counts,
nothing about being late**, stated in the UI and not only in a comment.

`NEXT_PUBLIC_VAPID_PUBLIC_KEY` is unset, so **no notification permission prompt is raised at all**.
That is deliberate: a browser gives an origin one prompt and a denial is permanent, so spending it
on a feature that cannot yet deliver would burn it for good. Owner task 6d.

## Partner sharing had one real compliance gap, and it was not on the register (2026-08-23)

0011 shipped *granular* consent. But the recipient was **whoever redeemed the code**, so at the
moment she agreed there was no identified recipient to agree about — granular, and not **explicit**
under Art. 9(2)(a). Migration 0012 makes her name the person before she can create an invite. He
never sees the name and cannot set it, or it becomes one more field a coercive partner can ask her
to change.

**The DPO gate was mis-specified rather than wrong** (ADR-069). A DPO is mandatory for *large-scale*
special-category processing; 20–50 invited testers is not that, and Art. 35(2) only asks for a DPO's
advice *where one has been designated*. Taken literally the old gate was circular. Cleared for the
private beta with `docs/13` §5b written; **unchanged for public launch**, and conditional on the
beta gate actually being switched on.

## First action for the next session

> ### ▶ Checkpoint — 2026-08-23, third pass
>
> **No `wip/` branch. Tree clean. Migrations through 0013 applied. Full gate green: 756 unit
> tests, 74 e2e against a fresh build, eleven guards.**
>
> **What closed:** partner sharing (built, deployed, beta-cleared), R3.1.6a, R3.1c.4, P2.5, the
> notification-preferences half of P2.8, B12, R3.5.2, and three stale owner tasks that were done
> all along. Two live defects fixed: the Arabic crisis dialog and the unprintable visit report.
>
> **Do next, in order:**
> 1. `git branch --list "wip/*"` — expect nothing. Check nothing is squatting on :3000 before you
>    build or run e2e; a stale `next dev` cost an earlier pass forty minutes.
> 2. **Two owner actions, and the first is a live exposure.** `NEXT_PUBLIC_BETA_INVITE_CODE`
>    (P0.12.5) — signup is open on a live domain while `/privacy` is a draft, and partner sharing's
>    beta clearance is conditional on it. Then `NEXT_PUBLIC_VAPID_PUBLIC_KEY` (owner task 6d),
>    which is all that stands between notification preferences and reminders that arrive.
> 3. **The notification sender.** Preferences are saved and honoured; nothing sends them yet. An
>    Edge Function reading `notification_prefs` + `push_subscriptions` through `shouldSend`, called
>    by a cron. The decision layer is done and tested — this is the transport.
> 4. **`MANUAL_TEST_PLAN.md`.** The owner has said he is not ready to review UI yet, so this is
>    parked rather than pending. It stays the largest unmeasured surface: both defects found this
>    pass were invisible to every guard and obvious to a human with the app open.
> 5. **R5.1 Flutter**, or **R3.4.1** (the thin TTC and pregnancy screens) for a smaller pass.
>
> **Working rule, verbatim:** *"I do not want to read anything unless you need my input."*

**No `wip/` branch is open** — 2026-08-16 ended between items, with everything gated, committed
and pushed. If that line ever says otherwise, finish the named branch before starting anything
new (the `wip/` rule, above).

**The symptom vocabulary grew with P2.4** (26 keys → 45, four locales) and it grew *shared* —
`MENOPAUSE_SYMPTOMS` is a view over it, so every key stays loggable from every mode. A
menopause-only list would have been restriction by data structure. Curated, not copied: the
circulating "34 symptoms" list carries osteoporosis and allergies, which are findings a
clinician establishes rather than things a woman notices. A test now pins the vocabulary to the
catalogs in both directions — a built-in with no label renders the raw key to a woman, and
nothing else in the suite would have caught it.

**P2.4 is code-complete.** The HRT log shipped as `meds_supplements` — the fourth table unused
since v1 — and shipped as *one list*, not an HRT list: a woman on levothyroxine, a patch, iron
and a prenatal vitamin has one, and an HRT-shaped screen would have restricted by data
structure. Two absences are held by tests and must stay: **no dosing guidance** and **no
adherence score**. Stopping keeps the row. What is left of P2.4 is the CBT program, which is
content rather than code (**P2.13b**).

**P2.2.3 is nearly done** (2026-08-16): the contraction timer and weight chart shipped, retiring three
`UNIMPLEMENTED` module ids. Neither reads what it measures — no 5-1-1 verdict on the timer, no target
band on the chart — and the maternity-contact route sits *above* the timer in every state. Migration **0008 was applied by the owner on 2026-08-16**, so the timer is live.
`vitals` was the fifth table unused since v1. Only checklists remain.

## The first screener that acts on an answer (P2.7, P1.26.3, 2026-08-16)

The EPDS ships with the crisis route wired. **Item 10 — “the thought of harming myself has occurred
to me” — returns `selfHarmItemPositive`, a separate flag no total can mask**, and the client opens
the crisis dialog *on the tap, not on submit*, whatever the score. Guidance is unanimous that a
positive item 10 is followed up regardless of the total, and a woman can answer it above zero while
scoring below every published cut-off. The decision is in tier 1 so a screen cannot forget it; the
screen owns only the timing. Saving is optional and separate from answering — she may want the route
without wanting a record.

**It also found that Track E shipped without its hero.** `support.checkIn` sat in `UNIMPLEMENTED`
while `postpartum-experience` passed its hero card in as `pregnancyHero`, an id Track E never emits.
The node existed and was simply never asked for — the one failure `UNIMPLEMENTED` exists to make
visible, and it could not, because the id *was* listed. Worth remembering when adding a module: a
listed id proves the gap is known, not that the wiring is right.

## The engine finally offers something (P1.27.5, 2026-08-16)

`runnerUp` has been computed since ADR-057 and `ExperienceConfig.offer` since R2.2, and nothing had
ever rendered either — the same write-only shape `docs/23` §3.1 opened this workstream with.

**All three conditions live in tier 1** (`offerFrom` in `build.ts`), not in the component: only from
the generic state, only above **`OFFER_THRESHOLD` (0.4)**, only when the runner-up names a real
track. The threshold exists because a test caught the alternative — an account with nothing logged
scores B1 at 0.21, because "no conditions" and "not trying to conceive" are both true of someone
who has told us nothing.

`persona-branch-lint` rejected the first version over a `mode !== "general"` check in the component
and was right to. The fix moved the condition into tier 1. **When a guard fires on new code, the
usual answer is that the decision is in the wrong layer** — not that the rule is too strict.

**PHQ-9 and GAD-7 followed** (2026-08-16), at `/screeners`, reachable in every mode — general
instruments, unlike the EPDS, which stays on the postpartum screen because it is perinatal. One
module and one component parameterised by instrument: **a second near-identical copy is where the
item-9 rule would eventually be lost.** `selfHarmItemPositive` is always false for GAD-7, which is a
fact of the instrument kept in the type rather than a branch in a screen.

## The wizard asks one more thing (P1.27.8, 2026-08-16)

One stage-scoped question on the triage step, and the rule is that **a question exists only if a
resolver rule reads the answer**. TTC duration unlocks C2/C3; "roughly when did you give birth"
supplies `weeksSincePregnancyEnd` *and* the `ended` status for the majority of Track E — the woman
who installs Femio after the birth, whose gates otherwise fail exactly as they did before R2.4.

**`evaluationWindowMonths` is one definition with three consumers** (twelve months, six from 35).
C1 is the woman inside her window, C2 past it under 35, C3 past it over. Writing the number three
times is how they would disagree, and the direction — a 37-year-old held at C1 for six extra
months — is the expensive one.

Two guards earned their keep. `persona-branch-lint` rejected `mode === "ttc"` in the wizard, so
what a stage asks became **`FOLLOWUP_BY_MODE`, a lookup** like `CONDITIONS_BY_MODE`. And a golden
fixture caught a hand-written "regular" for two period starts — one measured cycle, which
`predictNextPeriod` correctly calls irregular. **Hand-writing fixtures is worth it precisely because
they catch you.**

Fixed on the way: `switchMode` replaced `flags_json` wholesale, so one mode change would have
erased her answers.

## The transitions fire at last (P1.27.6, 2026-08-16)

`docs/09` §6 defines seven global handlers that "fire from almost any state" and **none of them
fired**: a woman's mode changed only when she opened Settings herself, so someone who recorded that
her pregnancy had ended stayed in pregnancy mode indefinitely, reading a panel telling her it had
ended.

Three of the seven are mode changes and are now in `lib/persona/transitions.ts`, surfaced through a
new `ExperienceConfig.transition` beside P1.27.5's offer. The other four change what is *shown*
rather than which track she is in, and modelling them as transitions would blur two things.

**Offered, never applied.** A loss makes that non-negotiable: an app that silently reconfigured
itself the moment she recorded one would be announcing her loss back to her, on its own schedule,
possibly in front of someone.

Two rules worth keeping in mind before editing that file: *pregnancy ended* fires **only from Track
D**, because for anyone else it is an old fact and raising it months later is the app bringing up a
loss unprompted; and dismissal is keyed **per suggestion**, so a "no thanks" to a personalization
offer cannot swallow a positive test weeks afterwards.

## The postpartum shelf exists, and `content.foreground` is finally read (P2.3c, 2026-08-16)

Fourteen guides written against `CODEX_AUTHORING_BRIEF.md` and imported as drafts — 45 files now pass
the content guard and **every source URL resolves** (`pnpm content-lint:urls`). They are not public:
the CMS review gate is the owner's, and `MANUAL_TEST_PLAN.md` T22 is the checklist.

The more interesting half is the render path. `ExperienceConfig.content.foreground` had been written
since R2.1 and **read by nothing** — the same write-only shape `docs/23` §3.1 opened this workstream
with. It now drives the reading card through `lib/experience/reading.ts`, and three decisions there are
worth keeping:

**The registry keeps naming topics, not slugs.** A slug is an SEO artefact that gets renamed and split;
a topic outlives the article answering it, and a persona spec should not change when a page moves. So
there is a mapping, and **every unmapped topic is listed in `NO_ARTICLE_YET`** with a test asserting the
two lists cover the registry — the `UNIMPLEMENTED` idiom, for the reason P2.7a proved.

**A draft cannot reach a screen.** `/api/reading` asks the CMS as an anonymous caller, so an unapproved
article is simply absent from the answer. That is what lets a persona foreground an article *before* it
is approved with no window in which the dashboard links to a 404 — and it means each guide appears on
its own as the reviewer publishes it, with no deploy. Watched failing with the filter removed.

**The card says "being written" rather than rendering empty.** True today, and it stops being shown
the moment the first article is approved.

## Track E is complete, and the trap appeared a fourth time (R2.5f, 2026-08-16)

E3, E4 and E7 now resolve. The postpartum triage has asked about mood, diabetes, hypertension,
pre-eclampsia and thyroid since R2.5 and **nothing read any of those answers** — every woman in
Track E got E1 whatever she had reported.

**The rule, now written down and worth reading before touching the resolver: when a specific
persona extends a general one, the general one needs a signal that is false in the specific case.**
This is its fourth appearance (C1/C2, E1/E2, the hero hoist, and now E1 against E3/E4/E7). E1
gained `conditions.length === 0`; delete that one line and all three new personas become
unreachable and six tests go red, which is how it was verified.

Two decisions are in **ADR-065** and should not be reversed casually. E3 is gated on the
`depression_anxiety` code she selected, **never on her EPDS total** — a score that may not produce
"your symptoms are severe" may not silently produce a mood-shaped app either. And **E5 is not a
persona**: "fertility returns before your first period" is true of everyone in the track, so it
ships as content on E1 rather than as a record that would have made E1 vestigial.

## Every blocker is closed, and two content sets are out to a second agent (2026-08-16)

B1–B9 are all answered. **B5** (PostHog DPA signed — the register records the permission, not the
connection; no key is set, so `track()` is still a verified no-op) and **B6** (two-step sign-in, so
`/admin/*` is reachable) were done by the owner. **B7, B8 and B9** were answered in one pass:

- **B7 → (b), narrowly.** Femio does carry newborn content: **eight mother-facing articles**, no baby
  tracking, no milestones, no growth charts. This is the first content Femio publishes about **a
  person who is not the account holder**, so three rules are non-negotiable — the boundary to a
  paediatrician in the first screen, a red-flag box drawn from the *newborn* set (a fever under three
  months is an emergency in a way an adult's is not), and **no assessment of a baby, ever**.
- **B8 → approved**, ten teen titles unchanged. P2.13 is drafting work, unblocked.
- **B9 → (b)**, weeks 4–40, and the owner does not review the title list. Weeks 1–3 are absent because
  dating counts from the last period.

**The two large sets go to a separate chat**, with the prompts in `docs/content/HANDOVER_NEWBORN_BASICS.md`
and `docs/content/HANDOVER_WEEK_BY_WEEK.md`. Each prompt is self-contained — schema, sourcing tiers,
the forbidden-language list, the exact route surface for internal links, the four mechanical checks
that fail most often — and each ends by telling that agent to write a handover prompt back here, so
consolidation starts with the sources and the uncertainties rather than with 37 unexplained files.

**The one line that governs the week-by-week set**, because it is the whole difference between a
charming feature and a claim: *"babies are often about the length of a lemon"* is a population
illustration; *"your baby is the size of a lemon"* is a measurement of her pregnancy.

## All three content sets are out, and R1 is what is left (2026-08-16 — superseded 2026-08-18)

*Kept because its reasoning still holds; all three sets are now written and imported. See the
P2.2.2 section above.*


Newborn basics (B7), week-by-week (B9) and the teen ten (B8) each have a self-contained prompt in
`docs/content/HANDOVER_*.md`, each ending with an instruction to hand back a consolidation prompt.
None of them is drafting work here any more.

**The teen set is the one to read hardest on return**, and the reason is that its failure mode is
invisible to `content-lint`: a condition named as a possibility. A2 §D is explicit that PCOS should
not be raised within two to three years of menarche, and the guard checks claim verbs, not
clinical judgement about an audience.

With the content out, **R1 design was the live workstream** — and its references are now done
(R1.5, R1.7, R1.8, above). What they leave behind is three engine items rather than a design
one: **R2.8** Track B, **R2.9** Track F, **R2.10** the log screen rendering `tools`. Drawing the
screens is what found the third of those, which is the argument for `docs/25` §1 in a sentence.

Otherwise the open work is the rest of `P2.2.3` (checklists), `P2.7`'s remaining screeners
(DRSP, PBAC), and consolidating the three content sets when they come back.
