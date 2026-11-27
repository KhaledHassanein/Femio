# 05 · UX and AI showcase: re-score (2026-11-27)

Agent-facing audit record. This is an independent, read-only re-score of the 26 Nov report
(`audit-2026-11-26/05-ux-ai-showcase.md`, written at `fb45488`). It checks worktree `judge-audit-bd6d27` at
`main 3a92a90` (`git log --oneline -1` → `3a92a90 docs: R14.15 signed build evidence, R14.16 merged and deployed`)
and the live site, femioapp.com, fetched on 2026-11-27.

**Rubric and scale:** the same as 26 Nov.
- Two scores out of 10: the **Hybrid-AI showcase** and **Presentation and polish**.
- Findings are graded P0, P1 or P2.

**Labels:**
- **LOCAL CODE**: I read it in the repo.
- **LIVE SITE**: fetched with curl today.
- **RENDER**: a PNG in the repo.
- **VERIFIED** means I checked it directly.
- **NOT VERIFIED** means it needs a real phone, a console or a live AI call.

**Every app render named below is a synthetic fixture.** They were made with the offline or fake bridge. Real
Gemini Nano and real Cloud boost have still never run: PROGRESS R14.1 is still `[ ]`.

**Tests I ran (LOCAL CODE, VERIFIED):** `flutter test test/r14_ai_visible_test.dart test/r14_18_report_answer_test.dart test/r14_19_ports_test.dart`
→ `+29: All tests passed!`

---

## 1 · Scores

| Score | 26 Nov | 27 Nov | One-line reason |
|---|---|---|---|
| **Hybrid-AI showcase** | 4 / 10 | **6 / 10** | The AI is now on Today's first screen (status chip and Say it bar), it is introduced at the end of onboarding, and Nano gets credit wherever it ran. But no real Nano or cloud run has happened yet, a judge still has no way to install the app, and a phone without Nano still shows no AI output. |
| **Presentation and polish** | 6 / 10 | **7 / 10** | The home H1 now says "private AI companion", the thumbnail's source tile is fixed, the Arabic "+" label now lines up, and the Devpost text and video script match the buttons. Still wrong: the Play screenshots, which show no AI; the synthetic `ask-en-light.webp`, still live with the duplicate source; and the install card, which says "Download link coming soon". |

### Can a judge see the AI within 10 seconds?

Not in the first 10 seconds after a cold start, but yes within 10 seconds of reaching Today. On a phone that
is already set up, yes. Details:

- **Second 0, Welcome screen.** The only AI cue is the tagline, a claim rather than a demonstration
  (`welcome_step.dart`, unchanged).
- **Onboarding** still takes about 40–60 s. It now ends with "Meet femio's assistant", which explains the
  phone/cloud split (`onboarding_flow.dart` `_Step.assistantIntro`; render
  `testing-results/2026-11-27-r14-19/en_light_04_assistant_intro.png`).
- **Today, first viewport (390×844):**
  - the chip "On this phone · femio's rules" (or "Gemini Nano · on this phone") sits directly under the title;
  - below it is the bar "Tell femio anything…".
  - Evidence: `today_screen.dart:113-122`; renders `testing-results/2026-11-27-r14-ai-visible/today_en_light.png` and
    `today_ar_dark.png`; test `r14_ai_visible_test.dart:95-103` asserts the chip sits above the hero.
- **First AI output** now takes 2 taps after onboarding instead of 12: tap the Say it bar, type, then tap "Turn
  into log entries". The intro sheet is skipped because onboarding saves `assistantIntroSeen: true`
  (`onboarding_flow.dart` `_saveNew`).

---

## 2 · Old findings: status

| ID | Sev | Status | Evidence |
|---|---|---|---|
| UX-1 | P0 | **Partly fixed** | **The no-Nano state is now visible and honest.** The chip shows `aiChipRules` "On this phone · femio's rules" (`ai_status_chip.dart:25-38`). Devpost now tells judges what a phone without Nano shows (`DEVPOST_SUBMISSION.md:96`). **What is not fixed:** without Nano or a working Cloud boost, a judge still sees no AI *output*. The gateway still returns `AssistantResult.rules()` (`assistant_gateway.dart:126,156,192`). Cloud boost on a sideloaded APK: NOT VERIFIED. |
| UX-2 | P0 | **Fixed** | The chip and Say it bar sit under "Today", above the hero (`today_screen.dart:113-122`). Renders: `2026-11-27-r14-ai-visible/today_{en,ar}_{light,dark}.png`. Test: `r14_ai_visible_test.dart:75-103`. The chip opens Settings → Assistant (`ai_status_chip.dart:81-86`). The "Gemini Nano" state is shown only in a widget test, not in any render (synthetic). |
| UX-3 | P0 | **Partly fixed** | **The fallback line no longer blames the AI.** `askModelFellBack` = "No on-phone or Cloud boost summary was available this time, so here are the trusted passages word for word." (`app_en.arb:769`, used `ask_screen.dart:175`). **What is not fixed:** it still does not say "could not connect", because the bridge returns no reason. App Check is enforced with Play Integrity for an app installed outside Google Play (PROGRESS R14.4, `RELEASE_STEPS.md` §C). Whether a sideloaded APK is accepted: NOT VERIFIED (needs a phone and the console). |
| UX-4 | P0 | **Open** | LIVE `/en/app` shows "Early test build (APK) … **Download link coming soon** … The test build will be linked here once it is published." No `.apk`, GitHub or Play link appears in the page's hrefs (curl, 2026-11-27). In Devpost, the APK link waits on "RELEASE_STEPS.md B" and the video link is still a placeholder (`DEVPOST_SUBMISSION.md:75-76,89`). Signed files exist: `E:/femio-builds/femio-1.0.0-test.apk` (66.5 MB) and `femio-1.0.0.aab` (65.7 MB). I did not check their signature, or whether the APK was built with `assistant.env`: NOT VERIFIED. |
| UX-5 | P0 | **Open** | PROGRESS R14.1 is still `[ ]`. Every AI render is still synthetic. `VIDEO_SCRIPT.md:20-24` says the demo sentence was checked against the rules only ("synthetic run, no model"). |
| UX-6 | P1 | **Fixed in code; device NOT VERIFIED** | **Say it** now credits Nano whenever it ran, even when it added nothing: `_ranModel` and `sayItCheckedNano` (`say_it_sheet.dart` diff; `app_en.arb` "Gemini Nano on this phone read your words too and found nothing more to add."). **The video's demo sentence** is now outside the lexicon: "my jeans will not button, I feel like a balloon" should become Bloating (`VIDEO_SCRIPT.md:20-24,34`). Whether Nano actually adds it: NOT VERIFIED. **Caveat:** if Nano returns an empty extraction, `readNote` gives `rules()` and no credit appears (`assistant_gateway.dart:159-161`). |
| UX-7 | P1 | **Fixed in code** | **Tips:** `tipsOrderedNano` when `ranOn == RanOn.phone` (`tips_card.dart:96,158`). **Visit:** `visitOrderedNano` (`visit_summary_screen.dart` `_nanoOrdered`); `orderVisitQuestions` runs only on the phone (`assistant_gateway.dart:191-198`). On a device: NOT VERIFIED. |
| UX-8 | P1 | **Fixed** | Today (`today_screen.dart:119,240,249`), Learn (`learn_screen.dart:73`), Log (`log_screen.dart:189`) and "+" (`add_sheet.dart:54`) all call `openAssistantDoor`. No direct `AskScreen(` push remains outside `assistant_pill.dart`. |
| UX-9 | P1 | **Open** | `git diff --stat fb45488..3a92a90 -- docs/store/screenshots` is empty. Shot `08-ask.png` is still the word-for-word path, and no store shot shows AI running. |
| UX-10 | P1 | **Partly fixed** | **Fixed:** the video script now bans synthetic renders (`VIDEO_SCRIPT.md:18-19`). **Not fixed:** `apps/web/public/app-screens/` is unchanged, and LIVE `/en/app` still serves `ask-en-light.webp` (the duplicate "Period Pain" source) and the old `today-en-light.webp`, which has no chip. `AnswerCard` still does not group passages from the same page: grep finds no grouping, and `ask_screen.dart` and `answer_card.dart` have no change apart from the report button. |
| UX-11 | P1 | **Fixed** | The thumbnail tile now reads "Cited to CDC, MedlinePlus and NIH; WHO, NHS and ACOG as further reading" (`thumbnail.html` diff; `thumbnail.png` viewed). Neither phone mock shows an AI screen yet (opinion, minor). |
| UX-12 | P1 | **Partly fixed** | The script now has a real Cloud boost run on Phone B and the ledger receipt (`VIDEO_SCRIPT.md:37-38`). Recording is the owner's job. It uses the *debug* build on Phone B because the release Play Integrity path is untested (`:16-17`). The video itself: NOT VERIFIED. |
| UX-13 | P1 | **Partly fixed** | **The headline now names the AI.** LIVE `/en` H1 is "femio is your private AI companion, from trying to conceive through pregnancy." and the next line is "Its AI runs on your phone; the cloud is used only if you agree to Cloud boost." The `/ar` H1 also names AI (curl). Local source: `en.json:121-122`. **Not done:** "Gemini", "Nano" and "hybrid" appear 0 times on `/en`. `/en/app` has no 3-box hybrid strip (its h2 list has none). The H1 is still TTC-to-pregnancy, not the "every life stage" of ADR-078 §8. |
| UX-14 | P1 | **Fixed** | Devpost step 2 is now "Tap + in the navigation bar, then 'Tell femio anything…'" (`DEVPOST_SUBMISSION.md:90`). |
| UX-15 | P2 | **Fixed (visible doors)** | Today, "+" and Learn use `auto_stories_rounded` (`today_screen.dart:242`, `add_sheet.dart` diff, `learn_screen.dart:75`). The globe icon survives only in dead code (UX-N2-1). |
| UX-16 | P2 | **Partly fixed** | Today's Ask and Visit now show with AI off, which matches rule 7 (test: "AI off: … Ask still opens"). The "+" sheet still hides Ask, Visit and Say it when the master switch is off (`add_sheet.dart:103`). This is now written down (`DEVPOST_SUBMISSION.md:94`), but it is still two rules. |
| UX-17 | P2 | **Fixed** | The script says "Tap **Save 2 entries on 1 day**" (`VIDEO_SCRIPT.md:34`), which matches `sayItSaveCount` (`app_en.arb:685`). |
| UX-18 | P2 | **Fixed** | `firstRunStorageNotice` adds "Its AI runs on this phone; the cloud is used only if you switch on Cloud boost." (`app_en.arb:517`). Whether legal reviewed this wording: NOT VERIFIED. |
| UX-19 | P2 | **Partly fixed** | The `AssistantPill` FAB class is gone. But `openAssistant()` and `AssistantDoorsSheet` are now unused (`assistant_pill.dart:22-36,178-195`; grep finds no caller). |
| UX-20 | P2 | **Fixed** | The "+" circle now overflows an icon-sized slot (`home_shell.dart` `_AddButton`). In render `2026-11-27-r14-19/ar_dark_03_save_failed.png`, "إضافة" sits on the same line as the other labels. |

### R14 items in this role's scope

All of these are LOCAL CODE and VERIFIED unless marked.

- **R14.6: Say it row and status chip on Today.** VERIFIED (see UX-2).
  - Opinion on the chip: it is honest and readable in EN/AR, light and dark.
  - It starts as `AssistantStatus.offline` until the bridge answers (UX-N2-2).
- **R14.6a: assistant intro as onboarding's last step.** VERIFIED.
  - `assistant_intro_step.dart` reuses `AssistantIntroPoints`.
  - The record is saved only after Continue (`_saveNew`), with `assistantIntroSeen: true`.
  - Render `en_light_04_assistant_intro.png`: clear, three points, with the cloud explained.
- **Ask placement.** Partly.
  - Ask and Visit moved above medicines and tips (`today_screen.dart:233-256`).
  - They are still below the hero and both log buttons, so below the fold on a TTC profile.
  - The Say it bar is the above-the-fold door.
- **Assistant first in Settings.** VERIFIED: it is the first `_Section` in `settings_screen.dart`.
- **Fallback line.** VERIFIED: it no longer blames the AI (see UX-3).
- **R14.18: Report this answer.** VERIFIED. Its test is part of the 29 passing.
  - The flag appears on every AI-written summary (`answer_card.dart` `if (s != null)`).
  - The sheet offers four reasons. The report text holds the reason, the origin label and the answer only
    (`report_answer_sheet.dart:30-33`).
  - It goes to the share sheet addressed to `info@femioapp.com`, or to the clipboard if there is no share sheet.
  - Renders `2026-11-27-r14-18/{en,ar}_{light,dark}_05_report_answer.png` are clean, except for UX-N2-3.
  - Whether Play accepts e-mail delivery as "in-app reporting" is the owner's call: NOT VERIFIED.
- **R14.19: Help now on the lock screen and the failed-save banner.** VERIFIED in code and RENDER.
  - `ar_light_01_lock_help.png` shows the Help now icon on the lock.
  - `{en,ar}_dark_03_save_failed.png` shows the amber "Not saved on this phone" card with Try again.
  - Its behaviour on a real phone with a full disk: NOT VERIFIED.
- **Signed .aab/APK and the emulator smoke test.** The files exist (sizes above). I did not re-run the smoke test,
  check the signature, or check whether `assistant.env` was compiled in: NOT VERIFIED.
- **Website deployed.** LIVE SITE: `/en`, `/en/app` and `/ar` return 200, and the H1 matches the local
  `en.json:121`, so the deploy is current for this string.

---

## 3 · New findings

| ID | Sev | Finding | Evidence | Status | Fix | Effort |
|---|---|---|---|---|---|---|
| UX-N2-1 | P2 | `openAssistant()` and `AssistantDoorsSheet` are dead code, and the sheet still uses the `travel_explore` globe icon | `assistant_pill.dart:22-36,178-195`; grep shows no callers | VERIFIED, LOCAL CODE | Delete both | S |
| UX-N2-2 | P2 | **What happens:** the chip shows `AssistantStatus.offline` until the async `status()` call returns. It refreshes only in `didChangeDependencies` and after returning from Settings. **Effect:** on a Nano phone, the first frame says "femio's rules" and then flips to "Gemini Nano". If AICore finishes downloading Nano while Today is open, the chip stays on "rules". That is the exact moment a demo video would show. | `ai_status_chip.dart:50-69` | VERIFIED (code); on a device NOT VERIFIED | Show a neutral "Checking…" state, or nothing, until the first status arrives; refresh on app resume | S |
| UX-N2-3 | P2 | **What happens:** in the Arabic UI, an English AI summary is laid out right-to-left, so its full stop jumps to the start (".from the first day of a missed period [1]"). The word-for-word passages already force LTR; the summary does not. **Why it can happen for real:** the Devpost text says Nano is validated only for English and Korean, so English summaries in an Arabic UI are plausible. | Render `2026-11-27-r14-18/ar_dark_05_report_answer.png` (synthetic); `answer_card.dart` `SelectableText(s.text, …)` has no `textDirection`, unlike the passages | VERIFIED (render + code) | Detect the summary's script, or use the requested `languageCode`, and set `textDirection` | S |
| UX-N2-4 | P2 | The synthetic Ask fixture pairs a pregnancy-test question with "About Pregnancy Loss" as source 2. A judge who saw this would read it as poor retrieval. | Renders `2026-11-27-r14-18/*_05_report_answer.png` | VERIFIED, RENDER (synthetic) | Keep it out of any judge-facing asset; re-shoot on the device | S |
| UX-N2-5 | P2 | On the website hero, the decorative ✦ and bloom ring sit on top of the eyebrow text "AI-ASSISTED WOMEN'S HEALTH & WELLNESS" at 390 px | Render `2026-11-27-web-r14/en-top-light.png` (local dev build, with the Next "N" badge) | VERIFIED, RENDER; on the live site NOT VERIFIED visually | Move the ornament below the eyebrow, or behind it at lower opacity | S |

---

## 4 · Biggest remaining gaps, ranked

1. **No real AI has ever run, and none has been filmed** (UX-5, UX-12, UX-9). **OWNER-ONLY** (phone, console,
   recording).
   - Every AI screen a judge could see is still synthetic.
   - The chip's "Gemini Nano · on this phone" state has never been seen on a device.
   - The video and store shot 08 depend on R14.1.
2. **No install path for a judge** (UX-4, UX-3). **OWNER-ONLY** (GitHub Release, console App Check posture,
   sideload test on a phone).
   - The `/app` card and Devpost still say the download link is "coming soon".
   - The rest is BUILDABLE after the release exists: wiring `APK_DOWNLOAD_URL` and redeploying.
3. **Judge-facing images and the website still undersell the hybrid AI** (UX-10, UX-13, UX-9). **BUILDABLE**
   for the web part.
   - Replace `app-screens/ask-en-light.webp` and `today-en-light.webp` with renders that show the chip.
     Label them as samples, or wait for device captures.
   - Group same-page passages in `AnswerCard`.
   - Add the 3-box hybrid strip (on phone → Cloud boost → cited answers) to `/en/app`.
   - Fix UX-N2-2 and UX-N2-3.
   - Re-shooting the store screenshots on a real phone is OWNER-ONLY.

**Tally of the 20 old findings:**
- Fixed: 10 (UX-2, 6, 7, 8, 11, 14, 15, 17, 18, 20). The device outcome of UX-6 and UX-7 is not verified.
- Partly fixed: 7 (UX-1, 3, 10, 12, 13, 16, 19).
- Open: 3 (UX-4, 5, 9).
- Not verified as a whole: 0. The device-dependent parts are flagged inline.
- New: 5, all P2.
