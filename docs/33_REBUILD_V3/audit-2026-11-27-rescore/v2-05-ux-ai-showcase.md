# 05 v2 · UX and AI showcase: second re-score (2026-11-27, 3a92a90 → eca4eaa)

Agent-facing audit record. Independent, read-only re-score of `05-ux-ai-showcase.md` (written at `3a92a90`),
using exactly its rubric: two scores out of 10 (**Hybrid-AI showcase**, **Presentation and polish**), the
10-second test, findings graded P0/P1/P2.

- Worktree `judge-audit-bd6d27`, `git log --oneline -1` → `eca4eaa docs(state): signed builds from 85bbe8e, smoke green, Lab 0 next`.
- Claims checked in code with `git diff 3a92a90..eca4eaa -- apps/mobile apps/web` (73 files), not from commit messages.
- Live site fetched with curl on 2026-11-27: `https://femioapp.com/en` and `/en/app`.

**Labels:** LOCAL CODE (read in the repo) · LIVE SITE (curl today) · RENDER (a PNG in the repo) · VERIFIED
(checked directly) · NOT VERIFIED (needs a real phone, the Firebase console or a live model call).

**Every app render named below is a synthetic fixture** (offline or fake bridge, 390×844 at 2x). No real
Gemini Nano or Cloud boost call has run: PROGRESS R14.1 is still `[ ]`. Everything about a real phone or a
real model is NOT VERIFIED.

**Tests I ran (LOCAL CODE, VERIFIED):** `flutter test test/cloud_consent_test.dart test/delete_dialog_test.dart
test/assistant_gateway_test.dart test/r14_ask_log_test.dart test/assistant_screens_test.dart test/language_page_test.dart`
→ `+88: All tests passed!` (no golden update; `git status` clean afterwards).

---

## 1 · Scores

| Score | 3a92a90 | eca4eaa | Reason |
|---|---|---|---|
| **Hybrid-AI showcase** | 6 / 10 | **6 / 10** | **Better:** the wizard's step 1 is now the clearest hybrid explainer in the app (No AI · AI on this phone · plus Cloud boost, naming Gemini Nano and Google's cloud AI). "Check Cloud boost" sends one fixed sentence and names the failure (`app_check`, `quota`, `network`…), which is the first in-app proof path for the cloud half. The "+" sheet now opens on two equal AI cards. **Why not higher:** nothing new reaches a judge. There is still no install link, no real Nano or cloud run, and a phone without Nano still shows rules output only. The new save-to-record prompt is rules, not AI, by design. The judge instructions now point at UI that no longer exists (UX-N3-1). |
| **Presentation and polish** | 7 / 10 | **7 / 10** | **Gains:** premium launcher icon (`2026-11-27-icon/compare.png`); welcome page on a dark Dusk gradient; clean "+" sheet cards; "Now: Get pregnant · Change" sits neatly under the Today title, and the chip and Say it bar stay above the hero (EN light, AR dark renders). Store shot `05-ai` shows the Nano chip (synthetic). **Losses:** the live site's "Cloud boost" screen is the retired consent screen, with different wording (UX-N3-2). Devpost and the video script describe the retired switches (UX-N3-1). Wizard renders exist in EN light only, with the DEBUG banner (UX-N3-8). The install card still says "Download link coming soon". |

## 2 · The 10-second test

**Result: unchanged.** Not within 10 s of a cold start; yes within 10 s of reaching Today.

- **Welcome (second 0):** "AI-assisted women's health & wellness" on the new dark gradient
  (`2026-11-27-language-page/en_light.png`). It is still a claim, not a demonstration.
- **Onboarding:** unchanged, ending with "Meet femio's assistant".
- **Today, first viewport (390×844):** the title, then "Now: Get pregnant · Change", then the chip "On this phone ·
  femio's rules", then the bar "Tell femio anything…". All four sit above the fertile-window hero
  (`2026-11-27-r14-ai-visible/today_en_light.png`, `today_ar_dark.png`; `today_screen.dart:116-126`).
  The stage row pushed the chip down by about one line; it is still visible without scrolling.
- **"+" sheet:** "Ask femio" and "Log with femio" are now the first two cards (`add_sheet_en_light.png`).

### Taps from a cold start to the first visible AI result

Counted from code (`onboarding_flow.dart` `_build`), not measured on a phone. Typing is not counted.

| Path | Taps |
|---|---|
| Fastest onboarding (TTC) | **8** — Get started → goal → birth year Continue → "don't remember" → "not sure" → "not sure" → trying → assistant intro Continue |
| Then the Say it bar on Today | **+2** — bar → "Turn into log entries" |
| Total, cold start | **10** |
| From Today with the "+" sheet | **3** — + → Log with femio → Turn into log entries; or + → Ask femio → Ask |

On a phone without Nano, that "AI result" is femio's word rules, honestly labelled. Whether it is a
Nano-credited result on a real phone: NOT VERIFIED.

## 3 · The four questions

**1. How many taps from a cold start to a first visible AI result?**
10 taps plus typing (8 of onboarding, then 2), or 3 from Today through "+". This is the same as at 3a92a90,
apart from the new "+" path.

**2. Can a judge tell what ran on the phone versus in the cloud?**
Yes in code; on a device, NOT VERIFIED.
- **The chip.** Three states, plus "· Cloud boost on" (`ai_status_chip.dart:31-37`).
- **The answer label.** For example "Summarised by Google's cloud AI (Cloud boost), from the sources below"
  (`2026-11-27-r14-18/en_light_05_report_answer.png`, synthetic).
- **The wizard.** Step 1 names Gemini Nano versus Google's cloud AI (`en_light_ai_wizard_1.png`).
- **The ledger.** It records every call with what was sent; the Cloud check is logged too
  (`assistant_gateway.dart` `checkCloud`).
- **Two leaks remain:**
  - The chip still says "rules" on its first frame (UX-N2-2).
  - A sideloaded judge can only see the cloud side if App Check accepts the APK (UX-3, NOT VERIFIED). If it
    does not, the check tells them to "Install femio from Google Play", which they cannot do (UX-N3-5).

**3. Does the wizard feel like one clear choice, or like friction?**
One clear choice at step 1, then more friction than the choice needs.
- **Turning Cloud boost on from Today:** about 12 taps. That is gear → Assistant → "AI and Cloud boost" →
  radio → Next → Next → 4 ticks → "Confirm my choice" → dialog Confirm.
- **Step 2 repeats step 3.** Step 2 shows the first-person "I agree that femio may send…" statements as
  prose, and step 3 repeats them as checkboxes (`en_light_ai_wizard_2_cloud.png` vs `_3_cloud.png`).
- **"Confirm" is asked twice:** the button, then the dialog.
- **Withdrawing only Cloud boost still asks for 2 ticks** (UX-N3-4).
- **Verdict:** the consent friction for Cloud boost is defensible; the repetition is not.

**4. With AI off, is every core flow still complete?**
Yes (LOCAL CODE, VERIFIED by reading).
- **Still working:** predictions, calendar, the Log screen and the "+" chips, Ask femio from Today and
  Learn (word-for-word passages), the visit summary from Today, guides and Help now.
- **Save-to-record stays offered after an answer:** it uses no model (`save_to_record_card.dart` header;
  `ask_screen.dart` shows it on `_signal == none` regardless of the switch).
- **The wizard's "No AI" text says exactly this** (`aiModeOffSub`).
- **Remaining inconsistency:** the "+" sheet still hides Ask, Log with femio and Visit when AI is off
  (`add_sheet.dart:104`; UX-16). Today hides the Say it bar too, but Log → "Say it in your words" still works.

---

## 4 · Claimed new work: verified in code

| Item | Verdict | Evidence |
|---|---|---|
| R14.21 one wizard | **VERIFIED** | `ai_choices_wizard.dart`: three modes; nothing pre-ticked; the cloud option is disabled when the build has no cloud (`_cloudBuilt`). `cloud_boost_screen.dart` is now a thin alias, and the intro sheet's Cloud button opens the wizard at `AiMode.cloud`. |
| R14.21 confirm dialog | **VERIFIED** | `_confirm` → `AlertDialog` "Confirm this change?", with a mode-specific body (`aiConfirmDialogBody` select). |
| R14.21 sealed receipts / "My AI choices" | **VERIFIED (code)** | `CloudConsent.choose`, `sealIntact`; `ai_choices_record_screen.dart`; tests in `cloud_consent_test.dart` pass. Render: EN light only (UX-N3-8). |
| R14.21 Check Cloud boost | **VERIFIED (code)**; device NOT VERIFIED | Kotlin `check()` uses `ONLY_IN_CLOUD` and sends the fixed `CLOUD_CHECK_PROMPT`. `failureReason` maps the SDK exceptions to 11 codes; logcat tag `femio-ai`. Dart `CloudChecker` is implemented only by the real bridge. The button shows only while Cloud boost for questions is on (`assistant_settings_screen.dart`). The Ask path still drops the reason (`runHybrid` `on Object → null`). |
| R14.21 delete acknowledgement | **VERIFIED** | `delete_dialog.dart`: Delete is disabled until `deleteConfirmAck` is ticked; 2 tests pass. No render. |
| R14.22 "Now: stage · Change" | **VERIFIED** | `StageRow` (`stage_cards.dart`), under the Today title; seen in the Today renders, EN and AR. |
| R14.22 stage moves | **VERIFIED (code)** | `PregnantNowButton` opens onboarding at `Goal.pregnant`. `PregnancyEndedButton` → `endPregnancy`. `AfterLossCard` shows for up to 120 days or until a period is logged. `BreastfeedingCard`. Renders `2026-11-27-stage-moves/*`; no render of the two buttons themselves. |
| R14.23 "+" Ask femio / Log with femio | **VERIFIED** | `add_sheet.dart` `_AiChoice` ×2 plus a small "For my visit" link; render `add_sheet_{en,ar}_{light,dark}.png`. |
| R14.23 save-to-record prompt | **VERIFIED** | `save_to_record_card.dart` + `ask_save.dart`: terms are taken from her question only, through the Say it rules; nothing is written before Save. Renders `save_prompt_*`. See UX-N3-7. |
| R14.23 launcher icon | **VERIFIED (render)** | Adaptive and 512 icons now have a gradient ground and a larger bloom (`compare.png`). On a real launcher: NOT VERIFIED. |
| R14.23 language page | **VERIFIED** | `welcome_step.dart`: plum-700 → plum-950 radial gradient; render `language-page/*`. Light and dark are identical by design. |

---

## 5 · Old findings: status

| ID | Sev | Status at eca4eaa | Evidence |
|---|---|---|---|
| UX-1 | P0 | **Partly fixed** (unchanged) | A no-Nano phone still gets `AssistantResult.rules()`. Check Cloud boost now gives a way to prove the cloud path, but only after Cloud boost is on. Device: NOT VERIFIED. |
| UX-2 | P0 | **Fixed** | The chip and Say it bar stay above the hero, under the new stage row (renders above). |
| UX-3 | P0 | **Partly fixed, improved** | The Settings check names the cause (`cloudCheckFailed` select, 11 codes) and logs it. Ask's fallback line still names no cause (`assistant_channel.dart` `runHybrid` swallows it). Sideload plus App Check: NOT VERIFIED. |
| UX-4 | P0 | **Open** | LIVE `/en/app`: "Download link coming soon"; no `.apk`, GitHub release or Play href. Devpost step 1 still says `<APK link>`. |
| UX-5 | P0 | **Open** | R14.1 `[ ]`. Every AI render is synthetic. |
| UX-6 | P1 | **Fixed in code; device NOT VERIFIED** | No change. |
| UX-7 | P1 | **Fixed in code; device NOT VERIFIED** | No change. |
| UX-8 | P1 | **Fixed** | The new "+" cards still route through `openAssistantDoor` (`pop(AssistantDoor.ask / sayIt / visit)`). |
| UX-9 | P1 | **Partly fixed** | Store shot `05-ai` (84fb90b) shows the "Gemini Nano · on this phone" chip and the Say it bar (synthetic). No store shot shows an AI *output*, and `05-ai` predates the stage row, so it no longer matches Today. |
| UX-10 | P1 | **Partly fixed** (worse in one place) | `apps/web/public/app-screens/` is unchanged since 25 Nov. `ask-en-light.webp` (duplicate source) and the chip-less `today-en-light.webp` are still served. `boost-en-light.webp` now shows a retired screen (UX-N3-2). `AnswerCard` grouping: no change. |
| UX-11 | P1 | **Fixed** | No change. |
| UX-12 | P1 | **Partly fixed** | Video not recorded. Its script now describes retired UI (UX-N3-1). |
| UX-13 | P1 | **Partly fixed** (unchanged) | LIVE `/en`: "Gemini" 0 times. LIVE `/en/app`: "Gemini Nano" only in a demo caption and the usage-data note; no 3-box hybrid strip. |
| UX-14 | P1 | **Reopened** | Devpost step 2 says "Tap + … then 'Tell femio anything…'". The "+" sheet no longer has that bar; it now offers "Log with femio" (`add_sheet.dart` diff, render `add_sheet_en_light.png`). See UX-N3-1. |
| UX-15 | P2 | **Fixed** | No change. |
| UX-16 | P2 | **Partly fixed** (unchanged) | "+" still hides its AI doors when AI is off (`add_sheet.dart:104`). |
| UX-17 | P2 | **Fixed** | "Save 2 entries on 1 day" still matches the Say it sheet. |
| UX-18 | P2 | **Fixed** | No change. |
| UX-19 | P2 | **Partly fixed** | `openAssistant()` and `AssistantDoorsSheet` are still present with no caller (`assistant_pill.dart:22,178`). |
| UX-20 | P2 | **Fixed** | No change. |
| UX-N2-1 | P2 | **Open** | Dead code and the `travel_explore` icon remain (`assistant_pill.dart:195`). |
| UX-N2-2 | P2 | **Open** | `ai_status_chip.dart` is not in the diff; it still starts at `AssistantStatus.offline`. |
| UX-N2-3 | P2 | **Open** | `answer_card.dart` is not in the diff; the summary still has no `textDirection`. |
| UX-N2-4 | P2 | **Not re-checked** | The new r14-18 shots cover the source list with the report sheet. The fixture was not changed. |
| UX-N2-5 | P2 | **Open** | Web hero source is not in the diff; the live site was not checked visually. |

**Tally of the 20 UX findings:**
- Fixed: 9 (UX-2, 6, 7, 8, 11, 15, 17, 18, 20).
- Partly fixed: 8 (UX-1, 3, 9, 10, 12, 13, 16, 19).
- Open: 3 (UX-4, UX-5, and UX-14 reopened).

**UX-N2:** 4 open, 1 not re-checked.

---

## 6 · New findings

| ID | Sev | Finding | Evidence | Fix | Effort |
|---|---|---|---|---|---|
| UX-N3-1 | **P1** | **The judge-facing steps describe UI that no longer exists.** **Devpost:** step 2 says "+ → Tell femio anything"; step 6 says turn off "Use the assistant"; step 7 says "Settings → Assistant → Cloud boost opens the consent screen". **Video script:** 0:22 (the + bar), 1:30 (Cloud boost screen, "I agree"), 2:32 ("Use the assistant"). **The code:** there is no "Use the assistant" switch (`assistantMasterTitle` has no caller), the "Cloud boost" row is not tappable, and "+" has no Say it bar. Neither text mentions **Check Cloud boost**, the best judge tool for the cloud half. | `DEVPOST_SUBMISSION.md:90-95`; `VIDEO_SCRIPT.md:34,37,39`; `assistant_settings_screen.dart`; `add_sheet.dart` | Rewrite the steps: "+ → Log with femio"; "AI and Cloud boost → No AI"; the wizard → "AI on this phone, plus Cloud boost"; then "Check Cloud boost". | S · BUILDABLE |
| UX-N3-2 | **P1** | **The live site's "real screen" is out of date.** `/en/app` and `/en` serve `boost-en-light.webp` (25 Nov), which shows the retired consent screen, under "Real screens from the app". **Its consent wording differs from the shipped wizard:** "removes numbers, dates, names and contacts … I see the exact text" versus "removes numbers, e-mail addresses and links … I see and can edit". | LIVE SITE; `apps/web/public/app-screens/boost-*.webp`; `en_light_ai_wizard_3_cloud.png` | Re-render the wizard's step 1 and step 3 as the Cloud boost screen (EN and AR). The privacy role should check which redaction sentence is true. | S · BUILDABLE |
| UX-N3-3 | P2 | **Wizard repetition.** Step 2 shows the first-person "I agree that femio may send…" consent sentences as prose before step 3 asks her to tick the same sentences. Then "Confirm my choice" is followed by a second "Confirm this change?" dialog. It reads as consent before consent. | `ai_choices_wizard.dart` `_read` uses `boostAgreeQuestions` / `boostAgreeTips`; wizard renders 2 and 3 | On step 2, use third-person descriptions ("femio may send…"). Keep the dialog (owner asked for it, ADR-085) but make its body the only summary. | S · BUILDABLE |
| UX-N3-4 | P2 | **Withdrawing only Cloud boost is harder than ADR-085 says.** Going from Cloud boost to "AI on this phone only" needs the wellness and privacy-notice boxes ticked again (`_requiredAcks` for `AiMode.phone`). ADR-085 says "Turning things off needs no boxes", but that holds only for "No AI". | `ai_choices_wizard.dart` `_requiredAcks` / `_ready` | No ticks when the new mode grants less than the current one. The privacy role should confirm against GDPR Art. 7(3). | S · BUILDABLE |
| UX-N3-5 | P2 | **The Check is hard to reach, and one failure message is wrong for a sideloaded APK.** The Check appears only after Cloud boost for questions is on, so a judge must finish the whole wizard first. On `app_check` it says "Install femio from Google Play", which a judge with a sideloaded APK cannot do: Play is "Closed testing comes later" on the live site. | `app_en.arb:996`; `assistant_settings_screen.dart` | Word it for a sideloaded copy ("Google could not verify this copy; Cloud boost is unavailable on it"). | S · BUILDABLE |
| UX-N3-6 | P2 | **Cloud boost appears twice in Settings → Assistant.** "AI and Cloud boost" (tappable) and "Cloud boost" (a status row with no chevron, which does nothing). A judge following Devpost step 7 taps the dead row. | `en_light_assistant_settings.png`; `assistant_settings_screen.dart` | Make the status row open the wizard at Cloud boost, or fold it into the first row's subtitle. | S · BUILDABLE |
| UX-N3-7 | P2 | **The save prompt's text contradicts its default.** "Add what you mentioned to today's log" is pre-ticked, while the intro says "Nothing is saved unless you tick it and tap Save". Rule 7 still holds, because Save is required. | `save_to_record_card.dart` `_addTerms = _terms.isNotEmpty`; `save_prompt_en_light.png` | Intro: "Nothing is saved until you tap Save", or leave it unticked. | S · BUILDABLE |
| UX-N3-8 | P2 | **The evidence for R14.21 is thin.** **Wizard renders:** EN light only, filed under `testing-results/2026-11-24-r7-assistant/` (committed 27 Nov in 85bbe8e) and showing the Flutter DEBUG banner. **No render at all:** of AR or dark, the confirm dialog, a Check result, "My AI choices" in AR, the delete acknowledgement, or the "I'm pregnant" and "My pregnancy has ended" buttons. **Fixture artefact:** in `stage-moves/after_loss_en_light.png`, "Log how you feel" is greyed because the harness passes no `onLog`. | Folder listing; `today_screen.dart:230` | Re-shoot at 390×844 (EN/AR, light/dark) without the banner, and pass `onLog` in the harness. | S · BUILDABLE |

---

## 7 · The biggest gaps

1. **No real AI has run, and none has been filmed** (UX-5, UX-12, UX-1). **OWNER-ONLY.**
   - **What is still missing:** R14.1 is open, and every AI screen a judge could see is synthetic.
   - **What is new:** "Check Cloud boost" plus logcat `femio-ai` now turns the owner's Lab 0 into a
     one-tap test of the cloud path. Run it first, on the release APK, and read the code it shows.
2. **No install path for a judge** (UX-4, UX-3, UX-N3-5). **OWNER-ONLY** for the GitHub Release and the
   App Check posture; **BUILDABLE** after that (wire `APK_DOWNLOAD_URL`, redeploy, reword `app_check`).
3. **Judge-facing text and images now describe a superseded app** (UX-N3-1, UX-N3-2, UX-10, UX-9, UX-13).
   **BUILDABLE.**
   - Rewrite Devpost steps 2, 6 and 7 and the video rows 0:22, 1:30 and 2:32.
   - Replace `boost-*`, `ask-en-light` and `today-en-light` on the site.
   - Re-render store shot 05 with the stage row.
   - Add the 3-box hybrid strip to `/en/app`.
   - This is the cheapest gain available: S effort, and it moves both scores.
