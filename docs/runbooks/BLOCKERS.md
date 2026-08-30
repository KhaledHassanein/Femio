# Blockers and gates — the only things waiting on Khaled

**This file is exclusively work that cannot proceed without you.** Nothing optional, nothing
"nice to have". If it is here, something is stopped.

- Config, keys and one-off commands that are *not* blocking → `OWNER_MANUAL_TASKS.md`
- Things needing your eyes rather than your input → `MANUAL_TEST_PLAN.md`

**Nothing is blocked as of 2026-08-23.** B13 closed the last three open questions — partner
sharing's launch clearance, the in-app hero gradient, and Arabic digits. **One action remains and
it is not a blocker on me, it is a live exposure:** `NEXT_PUBLIC_BETA_INVITE_CODE` is unset in
Vercel, so signup is open to anyone who finds the domain while `/privacy` and `/terms` are drafts.
Partner sharing's beta clearance is conditional on that variable existing (B13, ADR-069).

**Two older questions remain open under B7** — the infant reviewer statement, and where the newborn
set may appear (E1 cannot carry it; E6 extends E1). Neither stops other work.

**Nothing else is blocked.** B1–B9 are all closed: B5 and B6 done by the owner, and
B7, B8 and B9 answered in one pass. What each answer unblocks is written into its section below,
and the three content sets that go to a separate chat have their prompts in
`docs/content/HANDOVER_NEWBORN_BASICS.md`, `docs/content/HANDOVER_WEEK_BY_WEEK.md` and
`docs/content/HANDOVER_TEEN_CONTENT.md`.

---

## B1 · ✅ DONE 2026-08-12 — one public bio: `Dr. Khaled M. · MBBCh, CPC`, no affiliation shown

**Blocked:** P1.9.8 (bylines on all 30 imported articles), the homepage clinician trust line,
and doc 15 §8 compliance — which requires a named reviewer *with* credentials and a bio link
before any health page claims review.

**Why I cannot proceed:** `upsert-people.mjs` refuses `--publish` for a `medical_reviewer` with
blank credentials, deliberately. A bio reading only "K.H." is weaker evidence than none — it
looks like the requirement was met when it was not. I will not guess post-nominals.

**Status 2026-08-12:** `credentials` received and set to **`MBBCh, CPC`**.
**`affiliation` is still blank**, and `upsert-people.mjs` refuses `--publish` without it — so
this is still blocked, on one more word.

| Field | Example | Currently |
|---|---|---|
| `credentials` | `MBBCh, MSc` | ✅ `MBBCh, CPC` |
| `affiliation` | `Cairo University`, or a clinic, or `Independent` | ❌ `""` |

If you genuinely have no institutional affiliation, say **`Independent`** — that is a true
answer and it satisfies doc 15 §8, which asks for a named reviewer with credentials and a bio,
not for an employer.

**What happens next (I do this):** update `docs/content/people/kh.json`, then

```powershell
pnpm --filter cms exec payload run ./scripts/upsert-people.mjs -- --apply --publish
```

then wire `authors` + `medicalReviewerProfile` on the 30 drafts, then restore the homepage
line "every guide is reviewed by a clinician — named, with credentials".

---

## B2 · ✅ APPROVED 2026-08-16 — the 14 postpartum titles, unchanged, drafting is authorised

**You replied "postpartum approved" with no cuts**, so the list stands as written: 1 your body
in the first six weeks · 2 bleeding after birth · 3 postpartum warning signs · 4 perineal and
caesarean wound healing · 5 afterpains · 6 pelvic floor · 7 your mood after birth · 8 sleep and
exhaustion · 9 breastfeeding, the first two weeks · 10 if breastfeeding is not working · 11 when
your periods come back · 12 contraception after birth · 13 your six-week check · 14 sex after
birth.

**Written and imported 2026-08-16 (P2.3c).** All fourteen are in the CMS as drafts, they pass
the content guard, and every source URL resolves. **The review gate is yours** — `MANUAL_TEST_PLAN.md`
T22 is the checklist. The postpartum dashboard's reading card fills itself in as you publish, with
no deploy needed.

Route (a): drafted under `docs/content/CODEX_AUTHORING_BRIEF.md`, the same path the 31 live
articles took. `content-lint` checks them mechanically first — Tier-1/2 sourcing with ≥2
sources, forbidden claim verbs, red-flag boxes, reading level, metadata uniqueness — then the
importer writes them as `draft`. Tracked as **P2.3c** in the queue, in batches of ten.

**The one thing still yours, and it is not a blocker:** each draft needs approving in the CMS
before it is public. `femio-cms.vercel.app/admin` → Articles → open → `reviewStatus: approved`
→ publish. Your account already holds `medical_reviewer` (ADR-032), and the gate is what makes
the byline on every page true. Nothing goes live on my say-so.

**Week-by-week (P2.2.2) is a separate ask** — 40 short entries under one pillar, batched by
trimester — and it is *not* covered by this approval. I will bring you that list when the
postpartum batch is drafted, rather than assuming.

---

## B3 · ✅ DONE 2026-08-12 — deployed and verified live (401 unauthed, 200 returns a real config)

**Your 2026-08-12 attempt failed and it was my bug, not yours.** The deploy reported
`failed to read file: .../persona/resolver` and then `EISDIR`. Deno resolves relative imports
literally — no extension inference, no directory/index lookup — and the tier-1 modules imported
each other the TypeScript way (`from "./types"`, `from "../pregnancy"`). Both work perfectly in
the web app and both fail at deploy.

Fixed: every tier-1 relative import now carries an explicit `.ts`, and the portability guard
gained a rule for it that was watched failing on the exact pattern. **`login` and `link` already
succeeded, so only the last line is needed:**

```powershell
npx supabase@latest functions deploy experience
```

(The `WARNING: Docker is not running` line is harmless — Docker is only needed to run functions
locally, not to deploy.)

**Blocked:** R2.4 cannot close. **Nothing is broken meanwhile** — the client falls back to
computing the same document locally from the same modules, which is why it was built that way.
This is a strict upgrade, not a switch-over.

Run from `E:\Femio`. `scoop` is not installed on this machine and is not needed — `npx` works.

**Tell me when it is done** and I will point the dashboard at the served document and repoint
`native-readiness-lint` (R2.7).

---

## B4 · ✅ BUILT 2026-08-12 — set `NEXT_PUBLIC_BETA_INVITE_CODE` in Vercel to switch it on

**Blocked:** P1.24, the beta with 20–50 real users. **This is the single
highest-information action available to the project** and it has been available for weeks;
every quality judgement so far, including yours and mine, is internal.

**Why it is a gate:** signup is open on a live domain while P0.12 legal is deliberately
deferred. The trigger for P0.12 was never incorporation — it is the first real user storing
health data. While that is only you and testers, this is genuinely fine. It stops being fine
the moment you invite someone.

**Built 2026-08-12** — option (a) with (c)'s wording alongside it, as you approved. **It is
off until you set one environment variable**, and with it unset signup behaves exactly as it
does today:

```
NEXT_PUBLIC_BETA_INVITE_CODE=femio-beta
```

Set it in Vercel on the **web** project and redeploy. The last step of onboarding then shows
the private-beta notice and asks for the code; the code is matched ignoring case and
punctuation, so `FEMIO-BETA`, `femio beta` and `femiobeta` all work.

**Stated plainly because it must not be oversold:** this is a speed bump, not a security
control. It is a `NEXT_PUBLIC_` value and readable in the bundle. It stops a stranger arriving
from a search result and storing real health data while the privacy policy is a draft; someone
determined to read the bundle is making an informed choice, which is what the notice is for.
The real control is P0.12.

---

## B5 · ✅ DONE 2026-08-16 — PostHog EU project created, **DPA signed**, register updated

`docs/compliance/PROCESSOR_REGISTER.md` now records the DPA as signed 2026-08-16 with the EU
region and EU transfer mechanism. That row records the **permission**, not the connection.

**Still off, and deliberately:** no key is set in Vercel, so no vendor script loads and `track()`
remains a verified no-op. Setting these two turns it on, and it is a config task rather than a
blocker (`OWNER_MANUAL_TASKS.md`):

```
NEXT_PUBLIC_POSTHOG_KEY=…
NEXT_PUBLIC_POSTHOG_HOST=https://eu.i.posthog.com
```

A non-EU host fails the build by design, so a mistyped host cannot ship.

---

## B6 · ✅ DONE 2026-08-16 — two-step sign-in enrolled

`/admin/*` is reachable: the translation portal and the insights dashboard. Recovery if the
authenticator is ever lost is `scripts/auth/reset-mfa.mjs` (runbook B★★★).


---

## B7 · ✅ ANSWERED 2026-08-16 — **(b), narrowly**: newborn basics as a seed set

**Owner direction:** *"I need newborn basics with breastfeeding — basic not extensive but to be
supporting the mother (let this be a seed to be scalable later)."*

So Femio does carry baby-care content, and the shape is the answer to the compliance question
this raised: **eight articles, mother-facing, no baby tracking, no milestones, no growth
charts** — enough to answer what the postpartum experience already provokes, small enough to
review in one sitting, and structured so a second wave slots in without renaming anything.

**The plan and the prompt for the other chat are in `docs/content/HANDOVER_NEWBORN_BASICS.md`.**
Its §2 carries the three rules that make infant content publishable here: the boundary to a
paediatrician stated in the first screen, a red-flag box on every article drawn from the
*newborn* set rather than an adult one, and **no assessment of a baby, ever**.

**Written and imported 2026-08-17 (P2.13c).** All eight are in the CMS as drafts, both content
lints pass over 64 files with every source URL resolving, and the return handover — what was cut
for lack of a Tier-1 source, the three places national guidance genuinely disagrees, and the five
sentences to re-read against the no-assessment rule — is in
`docs/content/HANDOVER_NEWBORN_BASICS_RETURN.md`. **Publication is still yours**, page by page,
in `/admin`.

**Two things now want a word from you, and only the second is a decision:**

**1. The reviewer statement** (the one flagged when B7 was answered). Doc 15 §8 is written for
content about an adult woman's own body. Eight pages about infants may want their own line in
it — a sentence saying who reviews content about a second person, and against what. Say the word
and I draft it; say it does not need one and I close the point.

**2. Where the newborn set is allowed to appear, and this one has a real constraint behind it.**
The obvious home is **E1**, the postpartum recovery spine — a woman weeks after birth is exactly
who these pages were written for. It is also the one place they cannot go. `content.foreground`
merges purely additively up the `extends` chain, and **E6 (pregnancy loss) extends E1**, so any
topic added to the recovery spine appears on the reading card of a woman after a loss. "Your
newborn in the first two weeks" in front of her is the worst thing this track could do.

So three of the eight are wired to **E2** instead, which is gated on a stated live birth that E6
can never satisfy: `feeding-your-newborn`, `newborn-warning-signs` and `bottle-and-formula-feeding`.
A test now resolves E6 through the whole inheritance chain and fails if newborn content ever
reaches it. The other five — the pillar, crying, safer sleep, nappies and cord, checks and
vaccinations — are reachable from `/learn` and from each other, and from no dashboard.

**That is fine for a seed set and it is not fine forever.** Giving them a persona shelf needs one
of two things, and both cost something:

- **(a) Subtraction in the engine** — let an `emotionalLayer` remove inherited topics. It is the
  first exception to "additive layers", which is product rule 5, so it would be an ADR.
- **(b) A live-birth-gated newborn persona** — a new record beside E2 that carries the baby shelf
  for mothers who are not breastfeeding. No engine change, one more persona to maintain.

I would pick **(b)**: it keeps the additive rule intact, and the gate that already protects E2 is
exactly the gate this needs. Nothing is broken while it waits — five articles are simply one tap
further away than they could be.

---

## B8 · ✅ APPROVED 2026-08-16 — the ten teen titles, unchanged

**You replied "approved" with no cuts**, so the list stands as written in the queue. Drafting is
authorised under `CODEX_AUTHORING_BRIEF.md`, `content-lint` first, imported as `draft`. Tracked
as **P2.13**.

Two constraints carry into the drafting and are worth repeating because they are the reason this
set is not just "period articles for younger readers": **no condition is named as a possibility**
(A2 §D — PCOS should generally not be raised within two to three years of menarche), and one of
the ten exists specifically to answer A2 §B's *"it said Tuesday and it didn't — is the app broken
or am I broken?"*

**Handed out 2026-08-16** the same way as B7 and B9 — the prompt is
`docs/content/HANDOVER_TEEN_CONTENT.md`, with fixed slugs and the A-track constraints written in
as rules rather than notes.

**The one thing still yours, and it is not a blocker:** approving each draft in the CMS, the same
gate the postpartum fourteen are waiting at.

---

## B9 · ✅ ANSWERED 2026-08-16 — **(b)**, forty week entries, and you do not review the list

**Owner direction:** option (b), *"no need for me to review — create a prompt for a chat to get
the data and consolidate it with references. I need data for the mother, her body, tips for the
mother in this week, and also for the fetus with fun as pregnancy apps (size of the baby… fetus
development news)."*

**The prompt is in `docs/content/HANDOVER_WEEK_BY_WEEK.md`.** Weeks **4–40, 37 files** — weeks
1–3 are deliberately absent because dating counts from the last period, so "week 1" is before
conception and an entry for it teaches the wrong thing. Every entry answers the same four things
in the same order: your body this week · what you may notice · your baby this week (with the size
illustration) · one specific tip.

**The fun is approved and it is not the risk.** The risk is one sentence type, and the prompt
makes it load-bearing: *"around this week, babies are often about the length of a lemon"* is a
population illustration; *"your baby is the size of a lemon"* is a measurement of her pregnancy,
and a woman whose scan measured small has then been handed a verdict by a phone. Same for weight.

**Publication is still your gate** even though the titles are not — that is ADR-032 and it does
not move.

---

## Not blockers, listed so they stay off this file

- **AR/FR/ES review** — ungated by your direction (ADR-063). Review happens during testing; a
  correction is an edit, not a blocked release.
- **P0.12 legal** — deferred by your direction. Blocks nothing except B4's honesty.
- **Search Console, custom CMS subdomain, Sentry DSN** — real, unblocking nothing. They live in
  `OWNER_MANUAL_TASKS.md`.

---

## B10 · ⏸ DEFERRED to 2026-09-01 (owner decision 2026-08-21) — Actions quota exhausted

**Every workflow run fails in ~3 seconds having executed zero steps.** Not a code failure: the
runner never starts. Verified across three runs including `d92f103`, which predates any of the
audit work, and re-verified on a fresh attempt after the e2e secrets were added.

```
verify      failure  started 08:49:25Z  completed 08:49:28Z  steps=0
verify-cms  failure  started 08:49:25Z  completed 08:49:28Z  steps=0
```

`verify-cms` fails identically and nothing in the revamp touched it. Two different jobs, zero
steps, three seconds — that is the runner declining to start the job, which on a **private**
repository is almost always exhausted included Actions minutes or a spending limit of $0.

**Cause confirmed by the owner 2026-08-21:** the minutes are used up and the allowance resets on
**1 September 2026**. Either add credit or wait. The decision was to wait, so every task that
depends on a CI run is parked in `DEFERRED_2026-09-01.md` — do not retry them before then.

**What this blocks:** the entire CI gate, including the product e2e suite restored in R3.0.4.
The secrets you added (`E2E_SUPABASE_URL`, `E2E_SUPABASE_PUBLISHABLE_KEY`) are **correct** —
verified by name against the workflow's references — and will take effect the moment runs execute
again. Nothing needs changing there.

**What this does not block:** local development. The full gate runs locally and is green
(typecheck, 637 unit tests, 70 e2e). Work continues; it is the automated net that is down.

---

## B11 · ✅ DONE 2026-08-22 — the Supabase Preview migration ledger is back in sync

The `Supabase Preview` check fails on every push:

```
ERROR: relation "fetal_movement_sessions" already exists (SQLSTATE 42P07)
At statement: 0   (0007_fetal_movement_sessions.sql)
```

It fails at **0007**, not 0001 — so 0001–0006 are recorded as applied and 0007 is not, while the
table itself exists. That is the signature of a migration applied out of band (run by hand in the
SQL editor) without being written to `supabase_migrations.schema_migrations`. `0008_contractions`
is very likely in the same state; both are the only migrations with zero idempotency guards.

**The fix is a ledger repair, not a code change**, which is why it is here rather than done:

```
supabase migration repair --status applied 0007
supabase migration repair --status applied 0008   # if it reports the same
```

**Deliberately not "fixed" by adding `if not exists`.** That would make the error disappear while
leaving the ledger wrong, so the next migration would fail the same way and the branch schema
would drift from what the files say it is. The audit's whole complaint is defects hidden rather
than fixed.

**What this blocks:** preview branches per PR. Production is unaffected — it already has both
tables.

---

### The schema is fine. Only the bookkeeping is wrong.

Verified 2026-08-22 by probing every migration's artifact against the live database:

| Migration | Artifact probed | Result |
|---|---|---|
| 0001 | `profiles` | present |
| 0003 | `delete_account()` | present |
| 0006 | `insights_overview()` | present |
| 0007 | `fetal_movement_sessions` | present (`42501` = RLS blocking anon, which proves the table exists) |
| 0008 | `contractions` | present (same) |
| 0009 | `pregnancy.ended_on` | present |
| 0010 | `profiles.stated_cycle_length` | present |

So **nothing needs to be re-run against the database.** `supabase migration repair` writes to the
ledger only — it executes no SQL — which is exactly what this situation needs.

### Steps

**1 — Link the CLI to the project.** Needs the database password (Dashboard → Project Settings →
Database). Skip if `supabase/.temp` already exists from a previous link.

```bash
npx supabase link --project-ref wnthtqtcajkhskdygbgo
```

**2 — Look at the truth. This is also the answer to "are my migrations done".**

```bash
npx supabase migration list --linked
```

Two columns, `Local` and `Remote`. `Local` is the files in `supabase/migrations/`; `Remote` is
what the ledger believes. Expect `0007`, `0008` and `0010` to show a version in `Local` and a gap
in `Remote` — that gap *is* B11.

**3 — Repair only the rows that showed a gap.** Pass the version numbers, not filenames:

```bash
npx supabase migration repair --status applied 0007 0008 0010
```

Adjust the list to match what step 2 actually showed. If step 2 shows no gaps, stop — B11 is
already resolved and the Preview failure has another cause.

**4 — Verify the repair.**

```bash
npx supabase migration list --linked
```

Every row should now carry a version in **both** columns.

**5 — Confirm nothing is pending.**

```bash
npx supabase db push --dry-run
```

Expect "Remote database is up to date" or an empty plan. **If it instead proposes to run 0007,
stop** — the repair did not take, and running it for real will fail on "already exists", which is
precisely the loop this blocker describes.

**6 — Confirm the fix.** Push any commit and check that the `Supabase Preview` check goes green.

### Do not

- **Do not run `supabase db push` before step 3.** It will try to replay 0007 against a database
  that already has the table and fail with `42P07` — the error in this blocker.
- **Do not add `if not exists` to the migrations to make the error go away.** That hides the
  drift and leaves the ledger wrong, so the next migration fails the same way.
- **Do not re-run the SQL by hand.** The table is already there; the probe above confirms it.

---

### ✅ Resolved 2026-08-22 — and what it actually was

`migration list --linked` is the whole diagnostic, and it named a different row than this blocker
predicted:

```
   Local  | Remote
   0008   | 0008
   0009   | ` `      ← the only gap
   0010   | 0010
```

**The gap was `0009`, not `0007 0008 0010`.** Those three were guessed — `0007` from the error
message and `0010` because it had been applied by hand — and repairing them was harmless but beside
the point. The lesson is the ordering in the steps above: **run `migration list` first and repair
exactly what it shows**, never a list inferred from an error message.

Why the error message pointed at `0007` anyway: `db push` walks migrations in order and stops at
the first one the ledger does not know about, so it reports the earliest symptom rather than the
cause. After the three wrong rows were repaired it moved on and named the real one — *"Found local
migration files to be inserted before the last migration on remote database: 0009"*, which is
Supabase saying "0010 is recorded but 0009 is not, so this would land out of order".

That message offers `--include-all`, and **taking that offer would have been the mistake**:
`0009` was already applied — `pregnancy.ended_on` answers on the live database — so `--include-all`
would have re-run it and failed exactly like `0007` did. The correct instrument was the one that
touches no SQL:

```bash
npx supabase migration repair --status applied 0009
```

Verified after: every row carries a version in both columns, and `db push --dry-run` reports
`Remote database is up to date`.

**The durable rule:** when the schema is already correct and only the ledger disagrees, `repair`
is the tool and `push` is the trap — `push` is for SQL that has not run, `repair` is for SQL that
has. Confirm which situation you are in by probing for the artifact (a table, column or function)
before touching either.


---

## B12 · ⚠️ WITHDRAWN 2026-08-22 — there was no contradiction; I misread §5a

`docs/26` flagged "a saturated purple hero against a hot-pink CTA" as a design defect. Trying to
fix it surfaced that the rule is not ambiguous — **there are two rules, and they disagree.**

**ADR-051 (2026-08-07)** introduced the gradient hero *into the signed-in dashboard*, as the fix
for your own "the design is from first look AI generated" verdict. Its (b) and (d) are explicit:
the dashboard leads with one answer carried by a hero, and *"heroes use `--gradient-hero-*`; the
decorative gradients never carry text."* Three AA-safe hero gradients were added specifically so a
hero could carry small copy.

**`docs/25` §5a (2026-08-09)**, two days later, says the opposite: *"`--gradient-hero-*` marks the
answer and is **never used inside the signed-in app**, which stays calm."*

The app currently follows ADR-051 — six components render `HeroCard` with a gradient. §5a is the
later decision and would remove all six.

**Not resolved here, deliberately.** This is precisely the ADR bar: a decision that cost something
and that a future session could reverse by accident. I would be reversing ADR-051 — a workstream
you commissioned in response to a specific complaint — on the strength of one line written two days
afterwards, with no ADR recording the change of mind. Picking either one silently is the failure
mode the bar exists to prevent.

**What is not in question:** the raspberry CTA is correct either way. §5a's "one accent element per
view, and it is the primary action" is satisfied — `Log today` is the only accent on the dashboard.
So the audit's "clash" is really *one* question: does the signed-in app keep its gradient hero?

**Your call, and it needs one line either way:**

- **Keep ADR-051** — the hero stays; `docs/25` §5a is amended to say hero gradients are for the
  *answer* card wherever it appears, in-app included. Cheapest, and consistent with what shipped.
- **Follow §5a** — the six heroes become calm surfaces (`--surface` + `shadow-md`, no gradient),
  and an ADR records that ADR-051(d) is superseded. More restrained; closer to Clue.

Either way the losing decision gets an ADR, so the next session inherits one rule instead of two.

**What this blocks:** Phase 5.1 only. Everything else in Phase 5 — dark mode, RTL, iconography,
inclusive copy — proceeds independently.

### ⚠️ Withdrawn 2026-08-22 — the blocker was mine, not the documents'

**There was never a contradiction.** §5a reads: *"`--gradient-dawn` … becomes the marketing
signature — homepage hero, app icon, store assets — **and is never used inside the signed-in app**"*.
That clause governs `--gradient-dawn`, the marketing gradient. It does not govern
`--gradient-hero-*`, which the same paragraph's first sentence assigns to the answer card — exactly
what the dashboard renders.

So §5a and ADR-051 agree and always did. I read a clause as attaching to the sentence's first
subject rather than its nearest one, and raised a decision the owner did not need to make. ADR-067
is withdrawn rather than deleted, with the misreading recorded in it.

**Nothing changed in the app at any point** — no code was written for this, and the §5a edit was
reverted. The rule for next time: quote the whole sentence before declaring two documents in
conflict.

---

## B13 · ✅ ANSWERED 2026-08-23 — partner sharing ships to the beta; the hero keeps its gradient; Arabic uses Western digits

Three owner decisions, all closed. Reasoning and the research behind the first are in **ADR-069**.

**Partner sharing is cleared for the private beta, not for public launch.** The DPO gate was
mis-specified: a DPO is mandatory for *large-scale* special-category processing (Art. 37(1)(c)),
and twenty to fifty invited testers is not large scale under Recital 91 or WP243 — while Art. 35(2)
only asks for a DPO's advice *where one has been designated*. Taken literally the old gate was
circular: no launch without a DPO, no DPO until real users, no users without something to use.

What is required at any scale has now been done: `docs/13` §5b carries the disclosures table, and
**the consent moment names the recipient** — which it did not. That was the one real compliance gap
in the build, and it is fixed in migration 0012.

**One condition is still on you, and the clearance depends on it: `NEXT_PUBLIC_BETA_INVITE_CODE`
must be set** (P0.12.5). The whole argument rests on the population being *invited* rather than
arriving from a search result. Until that variable exists, signup is open on a live domain and
"private beta" is a claim rather than a fact.

**B12 closes with the gradient kept.** ADR-051 stands, `docs/25` §5a is not amended, no code
changed.

**Arabic renders Western digits**, and is now pinned by a test rather than left to the runtime's
CLDR default — it was already correct, and correct-by-accident is what the test removes.

---

## B13 · ✅ DONE 2026-08-23 — `0015`–`0021` applied and **verified by probing the artifacts**

**What is needed:** apply `0015`–`0021` to Preview, then Production.

```bash
npx supabase migration list --linked    # confirm 0014 is the last applied
npx supabase db push                    # applies 0015..0021
```

**What they are.** Phase A of `docs/29_REBUILD` — the foundations everything else
waits on. `period_days` (per-day flow), `symptom_logs.dimension` (mood as its own
dimension), `source` provenance on `vitals` and `fertility_logs`, and four new tables:
`predictions`, `patterns`, `experience_documents`, `feature_flags`.

**Nothing in the app reads them yet**, so applying them changes no behaviour. That is
deliberate: the schema lands silently and Phase B onwards consumes it. Equally,
**Phase B cannot start until they are applied**, because the resolver writes to
`experience_documents` and reads `feature_flags`.

**Two of them contain backfills.** `0015` writes one `period_days` row per day of each
closed period, and `0016` reclassifies nine mood keys. Both are idempotent and both are
safe to re-run, but worth watching the row counts on Preview before Production.

**Every one has idempotency guards** — `if not exists`, `drop policy if exists`,
`drop trigger if exists` — which is the lesson from B11, where `0007` and `0008` had
none and desynced the migration ledger.

**What to check after.** That `feature_flags` is readable when signed out (the public
site needs it), that `predictions` rejects an insert from a browser client (it must be
tier-1 only), and that `patterns` accepts an update to `dismissed_at` and rejects one
to `confidence` — the column grant is doing work that RLS alone cannot.

---

### Closed 2026-08-23 — and the ledger was not taken at its word

The owner ran both commands; all 21 migrations showed Local/Remote matched and
`db push` reported the remote up to date.

**That is a ledger, and B11 is the reason a ledger is not evidence.** So the
artifacts themselves were probed. All five new tables answer, all three new columns
answer, `feature_flags` returns `200 []` to an anonymous reader, and `predictions`
rejects an anonymous insert with `42501`:

```bash
pnpm db-artifacts-probe
```

`scripts/db-artifacts-probe.mjs` is that check, kept rather than thrown away — B11
and B13 both needed it and no tool existed. It uses only the publishable key, so it
runs anywhere the web app runs, and its table and column lists should grow with every
migration that adds one.

**One check it cannot make.** That `patterns` accepts an update to `dismissed_at` and
rejects one to `confidence` needs a signed-in session. It is a column-level grant that
RLS cannot express, so it is worth confirming by hand — added to
`MANUAL_TEST_PLAN.md`.

---

## B14 · ✅ APPROVED 2026-08-23 — `جماع` confirmed by the owner, unchanged

**What is needed:** confirmation, by someone Arabic-competent and clinically literate,
of one string.

| Locale | `fertility.intercourse` |
|---|---|
| en | Intercourse |
| ar | **جماع** ← the one under review |
| fr | Rapport sexuel |
| es | Relación sexual |

**Why it is a blocker rather than a copy task.** OD-5 makes conservative wording a
**review item, not a detail**: a term that reads clinical in English and crude in
Arabic fails the direction, and nothing in our automated gate can tell the difference.
`i18n-untranslated-lint` compares values, not register — it will pass a word that is
accurate and unusable.

**Why this word.** `جماع` is the classical and medical register, the term used in
clinical and religious writing, rather than any colloquial alternative. That is the
conservative choice as far as I can judge it, and judging it is not mine to do.

**What it labels.** One marker, carrying a date and nothing else — the single term in
the `intercourse` dimension of `LogVocabulary` (`lib/experience/v2/vocabulary.ts`),
backed by `fertility_logs.intercourse`, which has been a boolean since schema v1.
There are no act types and there will be none.

**Not blocking Phase B.** Nothing renders this string yet. It blocks the log screen
(C6), which is where the term first appears to a user.

**Also worth a look while you are there:** the four clinical sexual-health symptoms
that stay in the vocabulary under clinical names — `painDuringSex` (dyspareunia),
`vaginalDryness`, `libidoUp`, `libidoDown`. Their existing Arabic strings predate
OD-5 and were never reviewed against it.

---

### Approved 2026-08-23, unchanged

The owner confirmed `جماع` as the Arabic term. The string ships as written; no code
change was needed. The four clinical symptom strings remain worth a pass when the log
screen (C6) puts them in front of a user for the first time — they are not blocking.

## ~~Two deploys, so D2's findings can exist at all~~ — DONE 2026-08-30 (added 2026-08-29)

**Why a human.** Both are production deploys, and the first one is a *new* function
that writes to a table using the service role. That is not a call I should make on
my own.

**Nothing is broken meanwhile.** Until they run, `patterns` stays empty, the home
module renders nothing, and the patterns *screen* keeps working exactly as it does
today by computing in the browser. This is an addition, not a switch-over.

Run from `E:\Femio`:

```powershell
npx supabase@latest functions deploy patterns
npx supabase@latest functions deploy experience
```

**Why the second one.** Track B now contributes the `patterns.finding` module, and
a registry change is inert until `experience` is redeployed — STATE.md records the
session that lost half a day to exactly this. Deploying the first without the
second writes findings that nothing renders.

**No secret to set.** Supabase injects `SUPABASE_URL`, `SUPABASE_ANON_KEY` and
`SUPABASE_SERVICE_ROLE_KEY` into Edge Functions automatically. The function reads
her logs with the *caller's* JWT and uses the service role only for the insert,
scoped to the id it got from verifying that JWT.

**What to check after.** `curl` the function with no auth header and confirm `401`.
Then, signed in with at least three logged cycles, open the dashboard and confirm a
finding card appears with its evidence line — and that dismissing it keeps it gone
across a reload. That last one is also the `patterns` column-grant check in
MANUAL_TEST_PLAN, which has been pending since it was written because nothing
wrote a row.

**Done 2026-08-30.** Both functions verified returning `401` unauthenticated. D2 is closed.

## One migration: content search (added 2026-08-30, D4)

**Why a human.** It is a production schema change. Nothing else about it is risky —
it adds two functions and one search function in `public`, creates no tables, and
touches no existing object.

Run from `E:\Femio`:

```powershell
npx supabase@latest db push
```

**Already verified against production.** The whole migration was applied inside a
transaction on the live database and rolled back, and the search was exercised
against the real 100 articles — `endometriosis` returns the condition above the
articles that mention it, `pregnan` returns pregnancy articles mid-word, a quoted
`"iron"` finds the anaemia article, and junk like `!!! &&` returns nothing rather
than erroring. So this is not expected to surprise anyone; it is queued because
production DDL is yours to run, not because it is doubtful.

**What it reads.** Payload's own tables, in the `payload` schema, through a
`security definer` function with a pinned `search_path`. It returns only
`_status = 'published'` rows — content that is already public on the marketing
site — and is granted to `anon` as well as `authenticated`, because search has to
work before sign-in.

**It cannot block the CMS.** Deliberately a function rather than a view: Postgres
does not track function-to-column dependencies, so a future Payload schema change
can never fail on our account. If Payload renames a column, our search breaks and
the CMS still deploys — the right way round.

**What to check after.** Signed out, on the site, search for `endometriosis` and
confirm the condition page ranks above the articles that mention it. **Two things
you will notice and should not report as bugs** — both are already in the queue:
the glossary returns nothing because `payload.glossary` is empty (R3.7), and
searching in Arabic returns English results because all CMS content is English
(R3.8).
