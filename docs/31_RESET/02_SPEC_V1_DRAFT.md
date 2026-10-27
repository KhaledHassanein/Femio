# 31.02 — Femio v1: scope lock (draft for Khaled)

**Status: DRAFT. Nothing here is decided until you approve it.**

**This is not a new plan.** The October revamp already chose the direction: D1–D8 in
`docs/runbooks/OWNER_ACTIONS.md`, the app spec in `docs/30_REVAMP/04_ANDROID_APP_SPEC.md`, and
the ledger in `docs/30_REVAMP/PROGRESS.md`. This page does three narrower things:
- it **locks** what ships at the soft launch (the week of 30 Nov, §4), and what doesn't;
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
| V1-06 | **Articles in the app** | Snapshot of the reviewed library, Arabic where you have reviewed it. Not built (P3.7, first half) |
| V1-07 | Reminders + crash reporting without content | Local notifications only. Not built (P3.8) |
| V1-08 | **Legal pages for the private app** | Privacy policy and terms (AR/EN), the Play Data safety and Health-apps answers, and a one-page regulatory note on Egypt, Saudi Arabia and the UK. All drafted by a session from the published laws, with sources; you approve them as owner (P4.1) |

## 3 · What moves to v1.1 (after the soft launch) **[Proposal — confirm each]**

| Item | Why it can wait |
|---|---|
| PCOS hub (P3.7, second half) | Depth, not the entry point. The PCOS articles cover the launch |
| Hijri dates, ultrasound dating (P3.10) | Valuable for the market, not needed to log and predict |
| Week-by-week pregnancy content, hospital bag (P3.6 rest) | Needs sourced drafting and your review; not needed to log and predict |
| Illustration set (P2.5), Lighthouse pass and CMS retirement (P2.8) | The website already works; none of these block the app |
| Menopause and postpartum goals in onboarding | Outside the wedge (D1). Keep them reachable through articles (rule 2). Show "coming soon" rather than a thin tool |
| Arabic top 50 (P4.0) | **Launch with the Ramadan set plus the 10 most-asked TTC/pregnancy questions**, each reviewed by you. Fifty is not reachable before launch |
| iOS (P4.4) | Unchanged: after launch signal |

## 4 · The launch path, with dates **[Proposal]**

*Re-dated 2026-10-27, twice. First, a 31 Oct lawyer brief was not realistic. Then the owner removed
every role but the owner's (`docs/runbooks/OWNER_ACTIONS.md`). With no lawyer or reviewer to wait for,
the build and Google's closed test are the only critical path, and D5's original week holds.*

| By | What | Who |
|---|---|---|
| 7 Nov | V1-05…V1-08 built and drafted: backup, app lock, articles in the app, reminders, crash reporting, legal pages | Sessions |
| **9 Nov** | **Release candidate APK** on your phone. Play Console account created; store listing AR/EN drafted | You (install, account); sessions (listing) |
| **11 Nov** | Play closed test starts: 12 testers × 14 days | You find the testers |
| 25 Nov | Closed test ends. Fix round from what testers and you found. Apply for production access (Google's review time `[NEEDS CHECK]`) | Sessions, you |
| **Week of 30 Nov** | Soft launch to 50–100 women, Egypt + KSA | You |

**What moves it.** Two things move the launch day for day:
- the release candidate slipping past 9 Nov;
- the closed test starting after 11 Nov.

If Google's production review is slow, the launch becomes the week of 7 Dec. Don't shorten the
14-day closed test: Google enforces it.

**The one risk you are accepting.** The legal pages and the regulatory note are written from the
published laws, not by a lawyer. That is your call as owner. The private design (no accounts, no
health data leaves the phone) is what keeps the exposure small.

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
3. **Confirm the week of 30 Nov** for the soft launch (D5 unchanged), with 9 Nov for the release candidate.
4. **Find the 12 testers** by 11 Nov. This is the one thing Google requires of you that nobody else can do.
5. **Approve §5 and §6** so the next session can make those doc edits.
