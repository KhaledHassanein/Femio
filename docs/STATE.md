# Femio — current state (living document)

**Last updated: 2026-10-07.** Rewrite in place; never add a dated copy. The August
version (1,431 lines, every session's notes) is `docs/archive/state-2026-08/STATE_2026-08.md`.
Search it by feature name when you need the history of a decision. It is not required reading.

## ▶ Resume prompt

> Read `CLAUDE.md`, then this file, then `docs/30_REVAMP/PROGRESS.md`. The first open item
> there is the work. Its phase is described in `docs/30_REVAMP/03_REVAMP_PLAN.md` §5.
> Owner items go in `docs/runbooks/OWNER_ACTIONS.md`, never in chat. Build in large steps,
> photograph every UI change (390×844, light, dark, Arabic), commit with the reasoning in
> the message, and update `PROGRESS.md` in the same commit.
>
> First, run `git branch --list "wip/*"`. A branch there means the last session stopped
> mid-item; finish it first.

## Where things stand (2026-10-07)

- **Agency takeover, Phase 0.** Audit `docs/30_REVAMP/01`, market research `02`, plan `03`.
  Wedge: Arabic-first TTC → pregnancy with PCOS depth, Saudi + Egypt; web first, then Play via
  TWA, then Flutter. The owner confirms decisions D1–D6 in `OWNER_ACTIONS.md` §0. Work
  proceeds on the stated defaults meanwhile.
- **Live:** `femioapp.com` (web) and `femio-cms.vercel.app` (Payload) on Vercel, Supabase EU.
  **100 articles** + 5 condition hubs published, all clinician-bylined. Migrations 0001–0022
  applied. 0023 is unverified and 0024 (guarded drop of unused content tables) is new; both
  apply with `db push`.
- **Health:** `pnpm gate` green, 942 unit tests, `pnpm audit --audit-level high` clean as of
  `7abbb2e`. CMS on Payload 3.90.2 / Next 16.3.8; web on Next 15.5.27.
- **Branch:** this session works on `claude/epic-planck-5y8geb`. Vercel deploys from `main`,
  so nothing here is live until the owner merges (OWNER_ACTIONS C1).
- **Design:** Phase 1 under way — Dusk Bloom palette, Newsreader/Plus Jakarta/Noto Naskh/Plex Arabic type, aurora hero, new header and compact crisis launcher are in (see PROGRESS). Next: reveal-on-scroll, cycle band, components pass, footer, app shell tabs. v2 experience surfaces exist behind
  flags that default **off**. Phase 3 turns them on and deletes v1 behind each.

## The working loop

1. **Take** the first open item in `docs/30_REVAMP/PROGRESS.md`. Mark it `[~]`.
2. **Build** the whole item, including i18n in all four locales and its tests.
3. **Gate:** `pnpm gate`. When a guard fails, fix the code, never the rule.
4. **Verify** the way the change can actually fail: a rendered page for UI, an injected
   fault for a guard, the deployed site for anything that only breaks in production.
5. **Record** the line in `PROGRESS.md` and this file in place. Write an ADR only if the
   decision cost something or could be reversed by accident.
6. **Commit** with explicit paths (never `git add -A`) and push to the session branch.
7. **Next item.** Do not stop to summarise.

**Stopped mid-item?** Commit the dirty tree to `wip/<item-id>` with a `wip:` message saying
what is built, what is not, and the next action. Never commit ungated work to `main`.

## The gate — run all of it before pushing

```
pnpm gate                              # everything below the build, in one exit code
rm -rf apps/web/.next/cache && pnpm build
CI=1 pnpm --filter web test:e2e:ci     # after that fresh build, never before
```

`pnpm gate` is typecheck, lint, test and all ten guards chained with `&&`, added
2026-08-23 after a real mistake: running them individually and piping each to `tail`
to read the output **discards the exit code**, so a failing typecheck scrolled past
and a commit went out on top of it. One command, one exit code, nothing to mask.
It excludes `build` and the e2e suite, which are slow and belong at the phase
boundary rather than at every checkpoint.

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
- **A flag read inside a component is a hook, and an early return below it skips every other
  hook.** Mounting the v2 log screen as `if (flag) return <LogScreenV2 />` at the top of
  `TrackScreen` type-checked, passed 879 tests, and would have crashed the moment the flag was
  flipped — the hooks after the return stop running, so the order changes between renders.
  `react-hooks/rules-of-hooks` caught it and nothing else would have, because the failing path is
  the one no test takes while the flag is off. **Split the decision into its own component**, so
  each branch mounts something whose hooks all run unconditionally — correct rather than merely
  currently working.
- **Offline is not signed out, and a skeleton that never ends is not a loading state.** Two
  defects found by photographing the offline case (RB-C7), each hiding the next. `AuthGate` called
  `getUser()`, which calls the auth server; offline it fails, and the gate read that as *anon* and
  redirected a signed-in woman to onboarding — her account appeared gone, and no offline state was
  reachable behind it. Use `getSession()` first: it reads stored session state with **no network
  call**, so "no session at all" stays answerable offline. Then, with the gate fixed, the screen
  held its skeleton forever, because supabase-js retries a failed fetch with backoff and the
  promise never settles — every read now races `QUERY_TIMEOUT_MS`. **To see any of this:**
  `node scripts/dev/seed-and-shoot.mjs --route <r> --offline`, which blocks *only* the Supabase
  host. Cutting all network gives a blank page (the document itself cannot load) and tests the
  browser's error page rather than ours.
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
- **Read `docs/archive/plans-2026-08/25_DESIGN_DIRECTION_BRIEF.md` §5a before building any visualisation.** Rings and circular progress are
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
