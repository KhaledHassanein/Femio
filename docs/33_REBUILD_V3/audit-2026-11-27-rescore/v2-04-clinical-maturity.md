# 04 · Clinical feature maturity, re-score v2 (2026-11-27, eca4eaa)

Reviewer role: clinician (obstetrics and gynaecology, reproductive endocrinology) with product-safety
experience. Independent re-score of `04-clinical-maturity.md` (the 27 Nov re-score at `3a92a90`),
same rubric, same 0-10 scale, same stage table. Read-only audit of worktree `judge-audit-bd6d27` at
`main eca4eaa` (`git log --oneline -1` → `eca4eaa docs(state): signed builds from 85bbe8e, smoke
green, Lab 0 next`). Diff read: `git diff 3a92a90..eca4eaa -- apps/mobile apps/web`. Commit messages
were not trusted; every claim below was checked in the code.

How things were checked:
- **VERIFIED (code)** means read at the cited line.
- **VERIFIED (test run)** means I ran it myself on this machine at eca4eaa, Flutter 3.47.8:
  - `flutter test test/r14_stage_moves_test.dart test/r14_stage_change_test.dart test/r14_ask_log_test.dart test/delete_dialog_test.dart test/r14_clinical_p1_test.dart test/red_flags_test.dart` → **61 passed, 0 failed** (the stage-moves and ask-log proof shots were compared against the committed PNGs, not regenerated).
  - A throw-away probe test in my scratchpad (outside the repo) for a loss at about 16 weeks did **not** run: `flutter test` on a file outside the package hung and I stopped it. CLIN-N3-1 and CLIN-N3-3 are therefore code-reading findings, worked by hand below.
  - All of these use **synthetic fixtures**. They show the code does not break; they say nothing about real use.
- **SCREENSHOTS**: I looked at `testing-results/2026-11-27-stage-moves/after_loss_en_light.png`, `after_loss_ar_dark.png` and `breastfeeding_en_light.png` (synthetic fixture, 390×844 at 2x).
- **SOURCE READ**: NHS, Miscarriage, https://www.nhs.uk/conditions/miscarriage/ (page last reviewed 31 March 2026), fetched 2026-11-27.
- **LIVE SITE**: https://femioapp.com/en/calculators/pregnancy-weight-gain fetched with curl on 2026-11-27 (HTTP 200).
- No real phone, no emulator, no AI call. Anything that needs those is marked **not verified**.

## 1. Overall feature maturity: 6 / 10 → 6.5 / 10

**Reason:** pregnancy loss now has a real, kind, data-keeping path (2 → 5), the wedge move
"trying → pregnant" is one tap from Today, and a second pregnancy after a recorded birth is now a
pregnancy. It does not reach 7 because:
- the "N days past your due date" counter still ships (CLIN-7);
- after a loss, the MR-10 card "If you could be pregnant, a pregnancy test is the first step" can
  appear directly under "We're so sorry" (CLIN-N3-1), and the old "Change" route still bypasses the
  loss path (CLIN-N3-2);
- the PCOS overlay is unchanged.

## 2. Per-stage table (same stages, same scale)

| Stage | 3a92a90 | eca4eaa | What changed (verified) | What is still missing | Safety notes |
|---|---|---|---|---|---|
| (a) Period and cycle tracking, irregular included | 7.5 | **7.5** | Nothing clinical in this stage. "Now: Track my period · Change" on Today (stage_cards.dart:43-62; today_screen.dart:116) makes the answers easier to correct. | CLIN-N2-2 (stated length overrides a contradicting observed gap) unchanged. No MR-46 ">7 days bleeding" note. | Unchanged; no regressions found. |
| (b) Trying to conceive | 6.5 | **7** | One-tap "I'm pregnant" under the trying hero, which opens the flow straight at the due-date question (`PregnantNowButton`, stage_cards.dart:64-78; today_screen.dart:154; onboarding_flow.dart:109-117). Test "trying: one tap on I'm pregnant opens the due-date question" passed. A new pregnancy clears an earlier `pregnancyEnded` (profile.dart:457). | Two-week wait (R8.12/R10.8). MR-13 40+ "you do not have to wait" line. The calendar still fills one ovulation day (CLIN-16). No prompt from a positive ovulation or pregnancy test result to the "I'm pregnant" button. | The button reads "I'm pregnant" (`goalPregnant`, app_en.arb:21) and only opens the due-date question; nothing changes until she finishes it. Contraception refusal unchanged. |
| (c) PCOS overlay | 4 | **4** | Nothing. | R8.11 "My health" switch, PCOS self-report and overlay; MR-34. | No harm found. Still thin for the wedge persona. |
| (d) Pregnancy | 6.5 | **7** | **CLIN-N2-1 fixed**: a new due date by any method except "born" clears an old birth date (onboarding_flow.dart:200-203), so `isPostpartum` is false and the week guide, pregnancy tools and red-flag card return. Tests "a second pregnancy after a recorded birth is a pregnancy, not after-birth (CLIN-N2-1)" and "trying again after a birth keeps the birth … (MR-60)" passed (r14_stage_change_test.dart:174-217). "My pregnancy has ended" on the pregnancy Today (today_screen.dart:191). | **"N days past your due date" still ships** (pregnancy_hero.dart:44, CLIN-7). MR-27 (record that the date came from a scan) not built. The earlier birth date is dropped, not kept in a list of past births (minor; logs are kept). The widget test asserts `isPostpartum == false`, not that the red-flag card is on screen. | Second-pregnancy safety gap closed in code. Hear Her list unchanged (16 signs). |
| (e) After birth | 7.5 | **7.5** | "I'm breastfeeding" switch on the after-birth Today; while on, it offers two reviewed guides and the stage row reads "After birth · breastfeeding" (stage_cards.dart:149-195; postpartum_cards.dart:58). Test passed; screenshot looked at. | The layer is thin: two guide links, no feeding log (by design). Once she leaves the after-birth view the switch is gone but the label "· breastfeeding" stays, with no way to turn it off (CLIN-N3-5). No MR-60 JSON fixture (CLIN-18), no MR-32 blood-pressure reference. | No new risk. Breastfeeding "changes no prediction" (profile.dart:360-362), which is correct. |
| (f) Pregnancy loss | 2 | **5** | **A dedicated path now exists** (R14.22, MR-35): "My pregnancy has ended" → a tap-a-day sheet back up to 300 days → "What should femio help with now?" with "Track my period" first and "Get pregnant" second (stage_cards.dart:80-125). `Profile.endPregnancy` keeps the pregnancy record, moves the goal, and turns log, period and appointment reminders off; medicine reminders stay (profile.dart:472-489). Bleeding up to the end day never counts toward her cycles (`cycleStarts`, profile.dart:368-379), so the "range has passed … a pregnancy test can tell you" hero line cannot be drawn from her pre-pregnancy dates (period_hero.dart:60 reads `cycleStarts`). An after-loss card shows for up to 120 days or until a period is logged (pregnancy_end.dart:17-27; today_screen.dart:156-159), with an urgent line and Help now (stage_cards.dart:127-147). 13 tests passed. | **MR-10 pregnancy-test card can appear under the after-loss card** (CLIN-N3-1). **"Change" from pregnant to period still bypasses all of this** (CLIN-N3-2). Ask and Say it are not loss-aware (CLIN-N3-3). No choice of her own words (MR-35 "her own term" open). No support resources for Saudi Arabia or Egypt. Late loss or stillbirth gets no after-birth warning signs (CLIN-N3-4). Medicine reminders stay on (may include a prenatal vitamin; see CLIN-N3-3). | Tone is kind and neutral; no diagnosis; nothing assumes she will try again; data kept (details in section 5). The urgent line matches the NHS 999 list (verified). |
| (g) Perimenopause and menopause | 7 | **7** | Nothing clinical. Stage row on Today. | No MR-61 JSON fixture (CLIN-18). | Unchanged. |

## 3. Old findings: status at eca4eaa

| ID | Sev | Status | Evidence |
|---|---|---|---|
| CLIN-1 | P0 | **Mostly fixed** (was partly) | One-tap "I'm pregnant" (stage_cards.dart:64-78, today_screen.dart:154); "My pregnancy has ended" (stage_cards.dart:80-125, profile.dart:472-489); appointment reminders off after a loss (profile.dart:487); stage row on Today (stage_cards.dart:43-62). Tests in `r14_stage_moves_test.dart` passed. **Left:** the "Change" route out of pregnancy does not record an end (CLIN-N3-2), and no choice of her own words. |
| CLIN-2 | P0 | Fixed (unchanged) | calendar_legend.dart:83-86, period_hero.dart:90 not touched by this diff. |
| CLIN-3 | P1 | Fixed (MR-27 left) | Unchanged. |
| CLIN-4 | P1 | Fixed | Unchanged. |
| CLIN-5 | P1 | Fixed | Unchanged. |
| CLIN-6 | P1 | Fixed | Unchanged. |
| CLIN-7 | P1 | **Open** | `l.pregOverdue(-progress.daysUntilDue)` still at pregnancy_hero.dart:44; `pregOverdue` "{days} days past your due date" at app_en.arb:275; PROGRESS R9.2 still `[ ]` (PROGRESS.md:183); R14.20 lists it as owner-only. |
| CLIN-8 | P1 | Fixed | Unchanged. |
| CLIN-9 | P1 | Fixed, **with a new defect after a loss** | The MR-10 rule ignores `pregnancyEnded` (absent_period.dart:37-42 passes `periodStarts`, not `cycleStarts`). See CLIN-N3-1. |
| CLIN-10 | P1 | Fixed | Unchanged. |
| CLIN-11 | P1 | Fixed | Unchanged. |
| CLIN-12 | P1 | Partly fixed (unchanged) | MR-15 exact sentence and lint ADR still open. |
| CLIN-13 | P1 | Fixed | Unchanged. |
| CLIN-14 | P2 | Fixed | Unchanged. |
| CLIN-15 | P2 | Fixed | Unchanged. |
| CLIN-16 | P2 | Partly fixed (unchanged) | day_marks.dart:97 still one ovulation day. |
| CLIN-17 | P2 | Fixed | Unchanged. |
| CLIN-18 | P2 | Partly fixed (unchanged) | Still no JSON fixtures for MR-58..61. No fixture for the new `pregnancy_end.dart` rule either (Dart tests only; it has no web twin, so this is minor). |
| CLIN-19 | P2 | Fixed (app) | Unchanged. |
| CLIN-20 | P2 | Open (owner row 46) | Unchanged. |
| CLIN-N2-1 | P1 | **Fixed** (code + test; not seen on a device) | onboarding_flow.dart:200-203 sets `birthDate` to null when the new goal is pregnant and not "born". `isPostpartum` (profile.dart:366) is then false, so Today shows `PregnancyTools`, `ThisWeekCard` and the red-flag card (today_screen.dart:165-192), and `safetySignalFor` treats her as pregnant (safety.dart:436). Tests r14_stage_change_test.dart:174-198 and 200-217 passed. |
| CLIN-N2-2 | P2 | **Open** | cycle_prediction.dart not changed in this diff. |
| CLIN-N2-3 | P1 | **Partly fixed** | Via "My pregnancy has ended": the period hero no longer shows the "range has passed … pregnancy test" line (prediction reads `cycleStarts`, which drops starts up to the end day: profile.dart:373-379; period_hero.dart:60); appointment reminders off (profile.dart:487). **Still open:** the MR-10 card (CLIN-N3-1), and the whole defect via the "Change" route (CLIN-N3-2). |
| CLIN-N2-4 | P2 | **Fixed** (code + live payload) | weight-gain-calculator.tsx:45-58 maps each band to numbers (`bandUnder`, `bandBetween`, `bandFrom`), cut-offs named in calculators/index.ts:176-179. Live `/en/calculators/pregnancy-weight-gain` payload (curl, 2026-11-27) contains `bandFrom":"{limit} or more"` and no `"obese":"Obese"`. The general BMI calculator keeps the WHO terms (en.json:338), as the 27 Nov fix allowed. Rendering after a result was not exercised. |

**Tally of 24 findings (20 CLIN + 4 CLIN-N2):**
- fixed: 16 (CLIN-2, 3, 4, 5, 6, 8, 9 (with a new defect after a loss), 10, 11, 13, 14, 15, 17, 19; CLIN-N2-1, N2-4);
- partly fixed: 5 (CLIN-1, now mostly fixed; CLIN-12, 16, 18; CLIN-N2-3);
- open: 3 (CLIN-7, 20; CLIN-N2-2);
- not verified: 0.

## 4. New findings

| ID | Sev | Finding | Evidence | Status | Fix | Owner |
|---|---|---|---|---|---|---|
| CLIN-N3-1 | **P1** (harm in tone) | **After a loss, the MR-10 card "Your period hasn't come for a while … If you could be pregnant, a pregnancy test is the first step" can show directly under "We're so sorry".** `periodAbsentFor` passes `profile.periodStarts` (all bleeds, including the period before the pregnancy) and exempts only a birth, not `pregnancyEnded`. Her last start before a pregnancy is her last menstrual period, so for any loss after about 13 weeks the card shows on the same day, and for an early loss it shows a few weeks later, while the after-loss card is still up. The R14.22 test misses it because its fixture's last start is only 69 days before "today". | absent_period.dart:27-42; today_screen.dart:156-164; r14_stage_moves_test.dart:38 (`'2026-09-18'`, today `'2026-11-26'`). Worked by hand from the code: LMP 2026-08-01, ended 2026-11-20, today 2026-11-26 → `showAfterLoss` true (6 days, no start after the end) and `periodAbsent` true (117 days ≥ 90, no birth date). | VERIFIED (code); not run (probe did not complete); not seen on a device | Pass `cycleStarts` to the MR-10 rule, or exempt it while `showAfterLoss` is true and for `afterLossCardDays` after `pregnancyEnded`, the way a birth is exempted. Add a test with an LMP 100+ days before today. Update `fixtures/domain/absent-period.json` and the web twin if the rule's inputs change. | No (mirrors the MR-60 birth exemption) |
| CLIN-N3-2 | P1 | **The "Change" route out of pregnancy still bypasses the loss path.** "Now: Pregnant · Change" is now the most visible stage control on Today (just under the title), while "My pregnancy has ended" sits lower, after the week card and "I had my baby". If she picks "Track my period" or "Get pregnant" through Change, `withAnswers` gets no `ended`, so nothing is recorded: appointment and log reminders keep firing, her pre-pregnancy starts drive the ranges, and both the "range has passed … a pregnancy test can tell you" line and the MR-10 card can appear. This is the exact CLIN-N2-3 defect, still reachable. | stage_cards.dart:43-62; today_screen.dart:116, 189-191; onboarding_flow.dart:192-207 (no `ended` passed); profile.dart:457 | VERIFIED (code) | When the editor moves her from pregnant (no birth) to a cycle goal, ask once: "Has your pregnancy ended?" Yes → `endPregnancy` with a day; No → change as now (a mistaken pregnancy entry). | Yes: the question's wording |
| CLIN-N3-3 | P2 | **Ask and Say it are not loss-aware, and medicine reminders stay on.** After `endPregnancy` the goal is period or trying and `birthDate` is null, so `safetySignalFor` sets `pregnant` and `postpartum` false. Words from the after-loss card ("soaking a pad", "shoulder pain") are caught only by the generic rules (urgent, heavy bleeding plus dizziness). Separately, medicine reminders are kept on purpose, but her list may hold a prenatal vitamin or pregnancy medicine, which would keep reminding her. The MR-35 rule text still says "stop all reminders at once" while its "Today" cell says medicine reminders are kept. | safety.dart:394-406, 435-438; profile.dart:472-489; 01_PRODUCT_SCOPE.md:280 | VERIFIED (code); not run | Add a `recentLoss` flag (ended within `afterLossCardDays`) that turns on the NHS 999 phrases in `safetySignal`. On "My pregnancy has ended", list her medicine reminders with a switch each, or say "your medicine reminders are still on" in the card. Align the MR-35 rule text. | Yes: MR-35 text |
| CLIN-N3-4 | P2 | **A late loss or stillbirth gets only the miscarriage card.** The sheet accepts any day up to 300 days back, so a loss at 20+ weeks or a stillbirth goes through the same path. Its urgent line is the NHS miscarriage list; it does not include the after-birth warning signs (CDC Hear Her covers the year after any pregnancy, including thoughts of harming herself, fever, swelling, headache) that the after-birth view gives for 365 days. Milk coming in and lochia are not mentioned. | stage_cards.dart:96-100; pregnancy_end.dart:13; safety.dart:437 (`postpartum` needs a birth date) | VERIFIED (code). The clinical content of a later-loss line is [NEEDS SOURCE] | Owner decision: either use the after-birth warning card and rules for losses after a gestation threshold [NEEDS SOURCE for the threshold, e.g. NHS 24 weeks], or add the CDC postpartum list to the after-loss card. | Yes |
| CLIN-N3-5 | P3 | **The breastfeeding label can stick.** The switch exists only on the after-birth Today. After "My period came back", the stage row still reads "Track my period · breastfeeding" with no switch to turn it off. | stage_cards.dart:33, 149-195; postpartum_cards.dart:58; today_screen.dart:211 | VERIFIED (code) | Show the switch in Settings → "What femio helps with", or on Today while the flag is on. | No |
| CLIN-N3-6 | P3 | **Wording to settle.** (1) "We're so sorry" assumes grief; the route also covers a termination, where some women may not want condolences. (2) Arabic source line "NHS، الإجهاض": in Arabic "الإجهاض" alone also reads as induced abortion; "الإجهاض التلقائي" or "فقدان الحمل" is clearer for Saudi and Egyptian readers. (3) The save-to-record prompt says "Nothing is saved unless you tick it and tap Save", but the symptom chips arrive already ticked. | app_en.arb:2949; app_ar.arb:1264; save_to_record_card.dart:42, app_en.arb:1864 | VERIFIED (code + screenshot) | Owner picks the card title (or offers her a choice, which MR-35 "her own term" asks for); fix the Arabic term; change the intro to "Nothing is saved until you tap Save" or start the chips unticked. | Yes: (1), (2) |

## 5. The pregnancy-loss path, checked point by point

- **Tone: kind and neutral.** The action is "My pregnancy has ended" (no clinical label, no
  "miscarriage" imposed on her). The sheet asks only the day and says "femio will stop the week
  cards, the countdown and your reminders. Everything you logged stays on your phone" (app_en.arb:2945).
  The card opens with "We're so sorry" and then says only what femio changed (app_en.arb:2953).
  Seen in the EN light and AR dark shots: calm, readable, no baby imagery, Help now below.
  Caveat in CLIN-N3-6 (condolence after a termination).
- **No diagnosis.** Nothing names a cause, a type of loss or a risk. "It may take a few months for
  periods to settle" matches the NHS page ("It may take a few months for your periods to go back to
  what's usual for you"). No statement on recurrence, fertility or "most women go on to…".
- **Urgent-care line and its source.** "Get help now if the bleeding is heavy (soaking a pad soon
  after putting it on), you have severe pain in your tummy or shoulder, or you feel faint or dizzy"
  (app_en.arb:2961), "Source: NHS, Miscarriage (2026)". I read the NHS page (last reviewed 31 March
  2026): its "Call 999 if" list is severe tummy pain, pain in your shoulder, feeling sick, faint,
  dizzy or losing consciousness, and heavy bleeding "soaking a period pad soon after putting it on".
  **The app's line matches.** Two notes: the NHS list is for someone still pregnant with bleeding,
  so applying it after the end is a reasonable extension, not a quote; and signs of infection after
  a loss (fever, unusual discharge) are not on that NHS page and are not in the card
  [NEEDS SOURCE before adding]. The Help now button follows the card (stage_cards.dart:138-144).
- **Her data.** Nothing is deleted: the due date, logs, bleeding and record stay (profile.dart:472-489;
  test "ending a pregnancy keeps every record…" passed). Bleeding up to the end day is kept on the
  calendar but never counts toward her cycles (profile.dart:373-379). A new pregnancy clears the end
  marker (profile.dart:457). It survives save and load (test passed).
- **Nothing assumes she wants to try again.** The next-goal choice lists "Track my period" first and
  "Get pregnant" second, with no default (stage_cards.dart:104). The card mentions periods only.
  One gap: no option to step away from cycles altogether (for example a pause), which is acceptable.
- **What is still wrong:** CLIN-N3-1 (pregnancy-test card under the condolence), CLIN-N3-2 (the
  Change route bypasses it), CLIN-N3-3 (Ask/Say it and medicine reminders), CLIN-N3-4 (late loss).

## 6. R14.23: the "+" sheet and save-to-record

- **Ask or Log:** the "+" sheet shows two equal choices, "Ask femio" and "Log with femio", only
  when her assistant switch is on (add_sheet.dart:104-137); the visit summary is a small link. Test
  "with the assistant off neither choice is shown (rule 7)" passed.
- **Never writes without her confirming: VERIFIED.** `SaveToRecordCard` writes only inside `_save`,
  which runs only from the Save button, which is disabled until something is ticked
  (save_to_record_card.dart:53-79, 156-159). "Not now" closes it with no write; the test compares the
  whole profile JSON before and after (r14_ask_log_test.dart:338-346). Showing the prompt writes
  nothing (test at :303-305). Terms come only from her question through the "Say it" phrase rules,
  never from the answer text (ask_save.dart:18-22). The prompt is not shown when a safety signal
  fired (ask_screen.dart:315), which is right.
- **Clinical caution (minor):** the symptom chips are pre-ticked and go into *today's* log. A question
  is not always a report ("what causes cramps in early pregnancy?" asked for a friend or about last
  week). She still has to tap Save, so rule 7 holds, but unticked-by-default would match the intro
  text (CLIN-N3-6 (3)). The visit note keeps up to 280 characters of the answer, labelled "Asked
  femio", so a clinician can see it came from the app.

## 7. Biggest remaining gaps, ranked

1. **After-loss leaks: the MR-10 pregnancy-test card under "We're so sorry" (CLIN-N3-1) and the
   Change route that skips the loss path (CLIN-N3-2).** **BUILDABLE**: pass `cycleStarts` (or a
   loss exemption) to MR-10 with a test whose LMP is 100+ days back; ask "Has your pregnancy ended?"
   when Change moves her out of pregnancy. Only the question's wording needs the owner.
2. **The "N days past your due date" counter (CLIN-7, R9.2).** **OWNER-ONLY**: the replacement
   sentence and register row [NEEDS SOURCE: what to say after 40+0, e.g. NICE NG207]. Then BUILDABLE.
3. **Loss path depth: her own words (MR-35), loss-aware Ask/Say it rules, later-loss and stillbirth
   warning signs, local support lines for Saudi Arabia and Egypt (CLIN-N3-3, N3-4).** **OWNER-ONLY**
   first (wording, gestation threshold [NEEDS SOURCE], which support services to name
   [NEEDS SOURCE]), then BUILDABLE.

Close behind: the PCOS overlay R8.11 (BUILDABLE once MR-14 wording is signed off) and the MR-15
exact sentence plus lint ADR (OWNER-ONLY).

## Not verified in this re-score

- Any behaviour on a real phone or emulator, including the signed builds from 85bbe8e.
- French and Spanish wording of the new strings (keys present in all four ARB files; meaning not
  reviewed). Arabic checked only for the after-loss card in one screenshot.
- The reviewed breastfeeding guides' content (slugs only).
- The AI wizard, sealed receipts and Cloud boost check (privacy and security lanes, not clinical).
- Rendering of the live weight-gain result line (payload only).
