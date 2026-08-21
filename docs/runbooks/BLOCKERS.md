# Blockers and gates — the only things waiting on Khaled

**This file is exclusively work that cannot proceed without you.** Nothing optional, nothing
"nice to have". If it is here, something is stopped.

- Config, keys and one-off commands that are *not* blocking → `OWNER_MANUAL_TASKS.md`
- Things needing your eyes rather than your input → `MANUAL_TEST_PLAN.md`

**Two questions are open as of 2026-08-17, both under B7 — the infant reviewer statement, and
where the newborn set may appear (E1 cannot carry it; E6 extends E1). Neither stops other work.**

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

## B11 · 🔴 OPEN 2026-08-21 — the Supabase Preview migration ledger is out of sync

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
