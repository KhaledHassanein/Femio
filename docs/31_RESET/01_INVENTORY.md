# 31.01 — Femio inventory (2026-10-27)

**What this is.** A read-only snapshot of Femio as it stands on `main` (`88f5aed`, 8 Oct 2026), taken
to answer two questions: *why does the work keep drifting*, and *what does it cost to resume a
session*. It feeds `02_SPEC_V1_DRAFT.md`. It changes no plan and no code.

**Labels.** **Checked** = measured today with a command or request. **From the docs** = the
project's own files say it; not re-verified. **Hypothesis** = my reading of the evidence.

> **Correction.** A first version of this inventory (written earlier today, never committed) was
> taken from a local checkout 38 commits behind GitHub. It described the August web app and missed
> the October revamp. This version replaces it.

---

## 1 · Summary

1. **The direction is already narrow and dated.** The October revamp (`docs/30_REVAMP/`, D1–D8) set
   the product to a **private Android app** (records on the phone, no accounts), the wedge to
   **TTC → pregnancy with PCOS depth**, the markets to **Saudi Arabia + Egypt, Arabic first**, and a
   **soft launch the week of 30 Nov 2026** (from the docs, `OWNER_ACTIONS.md` §0).
2. **The website is now the shop window.** `femioapp.com` serves articles and calculators; the web
   tracker is closed (checked: `/en/sign-in` → 307 → `/en/app`).
3. **Work stopped on 9 Oct.** That's 18 days ago, with the launch 34 days away. Six commits from
   8–9 Oct (article template, public-audit fixes) sit on `claude/epic-planck-5y8geb` and are **not
   on `main`** (checked).
4. **Resuming a session is now cheap.** It reads about 43 KB, roughly 11,000 tokens, down from about
   70,000 in August (§6). The token problem is mostly solved. **The drift problem is not** (§5).
5. **The critical path is not code.** It is the lawyer, the Arabic reviewer and Google Play's
   closed-test window (§7).

---

## 2 · The live product (checked 2026-10-27)

| URL | Result |
|---|---|
| `femioapp.com` | 307 → `/en`, 200 |
| `/en/learn`, `/ar` | 200 |
| `/en/app` | 200 (the "get the app" page) |
| `/en/sign-in` | 307 → `/en/app`: the web tracker is closed (D8) |

**Not checked:** whether the 9 Oct audit fixes (Arabic links that 404'd, honest review labels) are
live. They are on the unmerged branch, and Vercel deploys `main` (from the docs).

---

## 3 · The code (checked, on `main`)

| Part | Size | Notes |
|---|---|---|
| `apps/mobile` (Flutter, Android) | 40 Dart files, ≈ 10,500 lines in `lib/`, 3 test files | Onboarding, Today, Calendar, Log, TTC toolkit, pregnancy tools (movement log, contractions, appointments, weight). v0.4 |
| `apps/web` (Next.js) | ≈ 44,500 lines of TS/TSX in `src/` | Public site live; signed-in app kept behind `WEB_APP_ENABLED`, off in production |
| `apps/cms` (Payload) | — | Still the editor; retirement decided (D3), not done (P2.8) |
| Shared medical maths | 12 fixture files in `fixtures/domain/` | The same expected answers run against both the TypeScript and the Dart code |
| Tests | 93 test files in the repo | Docs claim 971 unit tests and a green `pnpm gate`. **Not re-run today** |
| Content | 100 English articles, 25 with a named reviewer, **0 in Arabic** | From the docs (`PROGRESS.md` P4.0, P4.0b) |

**What the app does today** (from `PROGRESS.md` Phase 3, not run on a phone today):
- Onboarding to the competitor standard, ending on a first prediction.
- Calendar and day log (51 terms, four languages).
- TTC: ovulation tests, waking temperature, test timing, trying-time nudge.
- Pregnancy: week and day, red-flag card, movement log, contraction timer, appointments, weight.

**Not built yet:**
- Articles inside the app, and the PCOS hub (P3.7).
- Backup, app lock, reminders and crash reporting (P3.8).
- Hijri dates (P3.10).
- Week-by-week pregnancy content and hospital bag (P3.6).

---

## 4 · The plan layer (checked)

**What improved in October.**
- `STATE.md` went from 1,431 lines to 17 KB.
- Superseded plans moved to `docs/archive/`.
- One owner file (`OWNER_ACTIONS.md`) and one progress ledger (`30_REVAMP/PROGRESS.md`).

**What still contradicts itself.** These are the places a session can go the wrong way:

| Where | Says | But |
|---|---|---|
| `CLAUDE.md` "What Femio is" | "whole health life", "web is also a real product" | D7/D8: Android app first, web tracker closed |
| `CLAUDE.md` architecture rule | "The backend owns decisions" | ADR-070: "**the specification owns decisions**", run on the device |
| `CLAUDE.md` governance | "read `STATE.md`, then the TODO" | Its own "How to work here" and `STATE.md` say `30_REVAMP/PROGRESS.md` |
| `30_REVAMP/00_README.md` | Android "Not started", Play "via TWA" | `04_ANDROID_APP_SPEC.md` and PROGRESS: Flutter app at v0.4; D8 replaced TWA |
| `30_REVAMP/03_REVAMP_PLAN.md` §2.3, §5 | Web first, Flutter "after launch signal" | D7/D8 reversed both, one day after the plan was written |

**Femio has now been built four times:**

| Build | Stack | Status |
|---|---|---|
| V1 | Flutter, on-device | Archived; removed from the tree 7 Oct |
| V2 web tracker | Next.js + Supabase | Built Jul–Sep; closed 7 Oct (D8) |
| Codex Flutter app | Flutter, on-device, outside this repo | Built Mar–Oct; archived 27 Oct (ADR-071) |
| `apps/mobile` | Flutter, on-device, in this repo | Started 8 Oct; the current product |

---

## 5 · Why it drifts (hypotheses, each with its evidence)

1. **The direction changed faster than the plan could be written down.** The revamp plan
   (7 Oct, web first) was reversed the same day by D7/D8 (Android app first). The constitution
   (`CLAUDE.md`) still describes the August product. **Each session starts from documents that
   disagree, and resolves the disagreement by itself.**
2. **The loop still says "don't stop".** `STATE.md`: *"Build in large steps… Next item. Do not
   stop to summarise."* Owner checkpoints exist only at phase ends (D-1…D-4). Phase 3's
   first six items landed on 8 Oct without one.
3. **Two builders ran at once.** The Codex Flutter app (outside the repo) and `apps/mobile`
   overlapped in October, building the same product twice.
4. **Session work is not landing on `main`.** The 8–9 Oct work sits on a branch, and the local
   checkout was 38 commits behind GitHub until today. **The person resuming cannot see where the
   work stands.**
5. **The goal statement is still "whole life".** The wedge (D1) narrows what gets *polished*,
   but rule 2 keeps every stage reachable. In practice the app still gains menopause and
   postpartum paths (`04` §3–4) during a TTC → pregnancy launch.

---

## 6 · Where the tokens go (checked)

| What a session reads before working | Size |
|---|---|
| `CLAUDE.md` | 12.4 KB |
| `docs/STATE.md` | 17.5 KB |
| `docs/30_REVAMP/PROGRESS.md` | 12.8 KB |
| **Total** | **≈ 43 KB ≈ 11,000 tokens** (rough rule: bytes ÷ 4) |

In August the same read was about 276 KB, roughly 70,000 tokens. The October collapse did the
work. What remains:
- About 4 KB of `CLAUDE.md` is tool trivia: the shadcn MCP paragraph and the ui-ux-pro-max
  paragraph.
- The contradictions in §4 cost more than the bytes do, because each one invites a session to
  re-read the archive to find out which document is right.

**Cost report.** `/claude-code-cost:by-project` shows **no Femio row**. `STATE.md`'s `/root/sdk`
paths show the October sessions ran in cloud sessions (hypothesis: their logs are not on this
PC). The report also leaves 18,060 current-model events unpriced. **Femio's spend cannot be
measured from this machine.**

---

## 7 · The real critical path to 30 Nov (from the docs, with dates)

| Item | Owner | Why it is critical |
|---|---|---|
| Lawyer engaged on the four narrow questions (A1) | Khaled | Egypt's health-data licensing is enforced from **31 Oct 2026**. Nothing launches without counsel's answer |
| DPO named, DPIA signed (A2); crisis copy signed (A3) | Khaled | Launch conditions |
| Arabic-competent medical reviewer named (B1) | Khaled | 0 of 100 articles are in Arabic, and the wedge is Arabic-first |
| Play closed test: **12 testers × 14 days** on a personal developer account (P4.2) | Khaled + testers | To launch the week of 30 Nov, the closed test must start by about **16 Nov**, with a stable build by then |
| Privacy policy and terms for the private architecture (P4.1) | Lawyer | Play listing and launch |

**None of these is code.** All of them are on the owner.

---

## 8 · Not checked

- `pnpm gate`, the e2e suite and `flutter test` were **not run**.
- The APK was **not installed**.
- The live site was **not clicked through**.
- The six commits on `claude/epic-planck-5y8geb` were **not reviewed**. Whether they should merge
  to `main` is your call.
- The archived Codex app was **not opened**.
