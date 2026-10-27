# 31.02 — Femio v1: scope lock (draft for Khaled)

**Status: DRAFT. Nothing here is decided until you approve it.**

**This is not a new plan.** The October revamp already chose the direction: D1–D8 in
`docs/runbooks/OWNER_ACTIONS.md`, the app spec in `docs/30_REVAMP/04_ANDROID_APP_SPEC.md`, and
the ledger in `docs/30_REVAMP/PROGRESS.md`. This page does three narrower things:
- it **locks** what ships at the soft launch (now the week of 4 Jan 2027, §4), and what doesn't;
- it **fixes the documents that disagree** (inventory §4);
- it **changes the working loop** that lets work drift (inventory §5).

Each choice marked **[Proposal]** is mine. Strike it or change it. Evidence for every claim is in
`01_INVENTORY.md`.

> The version of this page drafted earlier today proposed a web-first v1. That was based on a
> checkout 38 commits out of date, and it is withdrawn.

---

## 1 · v1 in one sentence (from D1, D7, D8)

*A private Android app, in Arabic and English, for women trying to conceive or expecting. It
gives honest predictions and a doctor's explanations, and her records never leave her phone.*

## 2 · What ships at the soft launch **[Proposal]**

Already built (inventory §3), so v1 means finishing and polishing these:

| # | Feature | Done when… |
|---|---|---|
| V1-01 | Onboarding | Under a minute, ends on her first prediction. ✅ built (P3.3) |
| V1-02 | Today, Calendar, Log | Ranges, never one date. Fertile window shown as awareness, never contraception. ✅ built (P3.4) |
| V1-03 | TTC toolkit | Ovulation tests, waking temperature, test timing, trying-time nudge. ✅ built (P3.5) |
| V1-04 | Pregnancy core | Week and day, red-flag card, movement log, contraction timer, appointments, weight. ✅ built (P3.6, except week-by-week content) |
| V1-05 | **Backup and app lock** | Export file, import on a new phone, lock screen. **Not built (P3.8).** A private-records app without backup loses her data with her phone (ADR-070), so this is a launch blocker |
| V1-06 | **Articles in the app** | Snapshot of the reviewed library, Arabic where a named reviewer has signed. Not built (P3.7, first half) |
| V1-07 | Reminders + crash reporting without content | Local notifications only. Not built (P3.8) |

## 3 · What moves to v1.1 (after the soft launch) **[Proposal — confirm each]**

| Item | Why it can wait |
|---|---|
| PCOS hub (P3.7, second half) | Depth, not the entry point. The PCOS articles cover the launch |
| Hijri dates, ultrasound dating (P3.10) | Valuable for the market, not needed to log and predict |
| Week-by-week pregnancy content, hospital bag (P3.6 rest) | Needs sourced drafting **and** the Arabic reviewer, who doesn't exist yet |
| Illustration set (P2.5), Lighthouse pass and CMS retirement (P2.8) | The website already works; none of these block the app |
| Menopause and postpartum goals in onboarding | Outside the wedge (D1). Keep them reachable through articles (rule 2). Show "coming soon" rather than a thin tool |
| Arabic top 50 (P4.0) | **Launch with the Ramadan set plus the 10 most-asked TTC/pregnancy questions**, each signed by the named reviewer. Fifty is not reachable before launch without the reviewer |
| iOS (P4.4) | Unchanged: after launch signal |

## 4 · The launch path, with dates **[Proposal]**

*Re-dated 2026-10-27: the owner said a 31 Oct lawyer brief is not realistic. This replaces D5's
"week of 30 Nov" once approved.*

**The two assumptions this rests on:**
- the lawyer is briefed by **14 Nov**. This is your date to confirm;
- counsel answers in about **two weeks**. This is a guess; ask the lawyer.

| By | What | Who |
|---|---|---|
| **14 Nov** | Lawyer briefed on the four narrow questions (A1). Also ask whether anything is needed before launch, given that Egypt's licensing starts 31 Oct | You |
| 21 Nov | Arabic reviewer named (B1). DPO named, DPIA signed (A2). Crisis copy signed (A3) | You |
| 28 Nov | Counsel's answers back. V1-05…V1-07 built. **Release candidate APK** on your phone | Lawyer; sessions, with your checks |
| **1 Dec** | Play closed test starts: 12 testers × 14 days (P4.2). Runs alongside the policy drafting | You + testers |
| 12 Dec | Privacy policy and terms final (P4.1). Store listing AR/EN | Lawyer, sessions |
| 15 Dec | Closed test ends. Fix round from tester feedback. Apply for production access (Google's review time `[NEEDS CHECK]`) | Sessions, you |
| **Week of 4 Jan 2027** | Soft launch to 50–100 women, Egypt + KSA (P4.3) | You |

**Why 4 Jan and not mid-December:**
- it leaves room for the production-access review and one fix round;
- it still gives five weeks of real use before Ramadan (expected around 8 Feb, `03_REVAMP_PLAN.md`
  §5), so the Ramadan content reaches real users.

**How slips move it.** Each week the lawyer brief slips past 14 Nov moves the launch one week. A
brief after about **5 Dec** puts the launch inside Ramadan. If that happens, decide then whether to
launch after Ramadan instead. Don't compress the 14-day closed test to save the date.

## 5 · Fix the documents that disagree **[Proposal: one small docs commit, after you approve]**

1. `CLAUDE.md` "What Femio is": the private Android app (D7/D8), keeping the whole-life ambition
   as the long-term direction.
2. `CLAUDE.md` architecture rule: "the **specification** owns decisions; the clients run it"
   (ADR-070).
3. `CLAUDE.md` governance: read `STATE.md`, then `30_REVAMP/PROGRESS.md`. Drop "then the TODO".
4. `30_REVAMP/00_README.md` and `03_REVAMP_PLAN.md` §2.3/§5: mark them superseded by D7/D8 and
   point to `04`.
5. `CLAUDE.md`: move the shadcn and ui-ux-pro-max paragraphs (≈ 4 KB) into
   `docs/runbooks/TOOLS.md`. Sessions read them only when using those tools.

## 6 · Change the working loop **[Proposal]**

Replace *"Build in large steps… Do not stop to summarise"* in `STATE.md` with:

1. **One item per session.** Take the first open line in PROGRESS and finish it, gated.
2. **Then stop and show Khaled.** A screenshot or APK, plus two lines on what changed and what
   is next.
3. **Merge to `main` the same day.** No work lives only on a session branch. `main` is what the
   next session sees.
4. **Nothing outside §2 gets built before the soft launch.** A new idea becomes one line in a "v1.1" list,
   not code.
5. **One builder.** No parallel apps in other folders or other tools.

## 7 · Decisions for you

1. **Approve §2 and §3**, or move items between them.
2. **Merge `claude/epic-planck-5y8geb` into `main`?** Six commits from 8–9 Oct, mainly public-site
   audit fixes, are on it. I haven't reviewed them.
3. **Confirm 14 Nov for the lawyer brief** and the week of 4 Jan 2027 for the soft launch. Approving them replaces D5 in `OWNER_ACTIONS.md`.
4. **Who reviews Arabic?** You, or a named colleague (B1).
5. **Approve §5 and §6** so the next session can make those doc edits.
