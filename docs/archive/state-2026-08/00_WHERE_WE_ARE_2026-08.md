# Where we are — one page, three launches

Written 2026-08-28 because the project has four planning documents, ninety-five commits since the
revamp opened, and no single place that answers *"how far am I from shipping?"*

**This file is short on purpose.** It orients; it does not duplicate. Everything here points at the
document that owns the detail.

| If you want… | Read |
|---|---|
| What is being built now, one line per checkpoint | `29_REBUILD/PROGRESS.md` |
| Why it is being built that way | `29_REBUILD/` chapters 01–07 |
| What competitors actually do, measured | `28_TEARDOWN/` |
| What only you can do | `runbooks/OWNER_MANUAL_TASKS.md` |
| What is stopping work right now | `runbooks/BLOCKERS.md` |
| Traps that have each cost a session | `STATE.md` → "Environment traps" |

---

## The three launches, and where each stands

### 1 · Web — **live, but not launched**

`femioapp.com` is deployed, healthy, and serving 200s. 31 clinician-bylined articles are public.
The app works end to end: onboarding, tracking, predictions, the visit report, partner sharing.

**It is not "launched" because no real user has been invited.** That is a deliberate gate, not an
oversight — `docs/13` says the trigger for the legal work is the first real user, and that user has
not arrived.

**What stands between here and inviting real users:**

| | Owner | Where |
|---|---|---|
| Legal + DPO gate — privacy policy, terms, DPIA §5 signed | **You** (appoint/engage) | `OWNER_MANUAL_TASKS.md` §I |
| Crisis-safety human sign-off | **You** (clinician) | `OWNER_MANUAL_TASKS.md` §H |
| Sentry + Search Console | **You**, 5–15 min each | `OWNER_MANUAL_TASKS.md` §F, §G |
| Phase C — the visible foundation | Build | `PROGRESS.md` → C4–C7 |

Nothing on that list is research. Two are decisions you make, two are accounts you create, one is
engineering already in flight.

### 2 · Android — **not started, and correctly so**

There is **no Flutter code**. `apps/` contains `web` and `cms` only; the Flutter in
`references/femio_v1_archive/` is V1, kept for learning and explicitly not the plan.

That is the plan working, not a gap. ADR-060 puts mobile on the *served* `ExperienceConfig`, so
every medical decision the phone renders must first exist as a document the backend serves. Phases
A and B built exactly that. **Building Flutter before the contract stabilises means building it
twice.**

Mobile is **Phase G** and it starts after the web app is right — `PROGRESS.md` → G1–G4.

### 3 · iOS — **after Android, same codebase**

Flutter targets both. iOS adds App Store review, HealthKit entitlements and a paid developer
account; nothing about it changes what gets built. There is no separate iOS workstream and there
should not be one.

---

## What is actually happening this week

**Phase C — the visible foundation.** Tokens, motion, chart primitives and the new home shell.

- ✅ **A** foundations — 7 migrations, all 21 now applied to production
- ✅ **B** the v2 experience contract — nothing reads it yet, every surface flag defaults to v1
- ⏳ **C** in progress — C1 (49 tokens), C2 (motion), C3 (7 chart primitives) done; **C4 half-done**
  (shell landed behind a flag; registry, explain affordance and mounting still open); C5–C7 open
- ⬜ **D** depth · **E** clinician bridge · **F** content · **G** mobile

**Health right now:** 851 tests in 77 files, the full fifteen-check `pnpm gate` green, production
answering 200.

---

## What to do next, in order

1. **Do the two five-minute ones.** Sentry and Search Console (`OWNER_MANUAL_TASKS.md` §F, §G).
   They cost nothing and both get more useful the earlier they exist.
2. **Decide when you want the first real user.** That date is what makes the legal gate urgent;
   until you pick it, §I sits open forever and nothing else is blocked by it.
3. **Let Phase C finish.** It is the last phase before the app stops looking like a competent
   tracker and starts looking like the product `docs/28` argues for.
4. **Do not start mobile yet.** The contract it depends on is one phase old.

## What to tell a new chat

> Read `CLAUDE.md`, then `docs/STATE.md`, then `docs/29_REBUILD/PROGRESS.md` — the last `[~]` line
> is where we are. Read that phase's chapter before writing code. Check
> `docs/runbooks/BLOCKERS.md`. `docs/27` is superseded by `docs/29`; `docs/26` is the audit that
> produced it and is still accurate about the product.

---

## Two housekeeping notes

- **`PROGRESS.md` Phase A says migrations are "not yet applied".** They are — all 21 verified
  against the linked project on 2026-08-28. That line is stale.
- **Nine untracked paths** sit in the working tree: `AGENTS.md`, `.agents/`, `.codex/` (agent
  config) and the V1 Flutter archive under `references/femio_v1_archive/`. None are build inputs.
  Decide whether they belong in the repo or in `.gitignore` — right now they are neither.
