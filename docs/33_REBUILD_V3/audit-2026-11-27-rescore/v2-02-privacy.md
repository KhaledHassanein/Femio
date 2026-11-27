# 02 · Privacy re-score, second pass (2026-11-27)

Re-score of `02-privacy.md` (main `3a92a90`) at main `eca4eaa` (`git log --oneline -1` → `eca4eaa docs(state): signed builds from 85bbe8e, smoke green, Lab 0 next`).
Read-only; only this file was written. Same rubric: privacy and security of consent as a hackathon judge, 1-10, finding IDs PRIV-*.
Labels: VERIFIED = I read the code at `eca4eaa`, ran the command or fetched the live page. NOT VERIFIED = needs a phone, a traffic capture or a console.
LOCAL CODE = this checkout. LIVE SITE = femioapp.com, fetched 2026-11-27. Commit messages and PROGRESS were not taken as evidence.

**What I ran:**
- `flutter test test/cloud_consent_test.dart test/assistant_screens_test.dart test/assistant_gateway_test.dart test/delete_dialog_test.dart test/r14_ask_log_test.dart test/r14_18_report_answer_test.dart` → **90 tests, all passed** (synthetic fixtures).
- `node scripts/analytics-lint.mjs` → exit 0, tripwire pass line. Same 8 review warnings as before (datatransport x3 and url_launcher `WebViewActivity`, in 2 merged manifests). Gradle reports the manifests older than their inputs but complete.
- A Dart probe of the seal (`CloudConsent` from `lib/domain/assistant/cloud_consent.dart`, run from the scratchpad, not committed). Results are in PRIV-N3-2.
- `curl` of `/en/privacy`, `/en/consumer-health-data`, the `ar`/`fr`/`es` versions (dates only), `/_vercel/insights/script.js`, `/ads.txt` and the `/en` headers.

**Not run:** a build, anything on a phone, a traffic capture, the Firebase or Play consoles. I did not unpack the signed artefacts in `E:/femio-builds`.

## 1 · Score: 9 -> 9 / 10 (held)

**What improved:**
- PRIV-N2-1 and PRIV-N2-2 are closed, and the effective dates are fixed (2026-11-27 on both pages in all four languages).
- The new wizard is good consent design:
  - one box per purpose, nothing pre-ticked, and a confirm dialog;
  - consent version 3, so every older consent lapses (`allows` needs version 3);
  - a receipt for every choice, with its language;
  - the check sends a fixed sentence, says so before it runs, and records the call in her AI ledger.

**Why it is not higher:** the new work opens three gaps of its own.
1. **Withdrawing is not as easy as the docs and the live site say.** The site says "one tap". In the app it takes three screens and a dialog. Moving from Cloud boost back to on-phone AI asks her to tick two statements again (PRIV-N3-1).
2. **The SHA-256 seal proves less than the screen suggests** (PRIV-N3-2).
3. **"Nothing is sent" is back in the consent wizard.** This contradicts the ML Kit telemetry disclosure (PRIV-N3-3).

The 10 is still blocked by the same unproven facts: the wire traffic (SEC-5) and the console settings (PRIV-6, SEC-8).

## 2 · Old findings

| ID | Status at eca4eaa | Evidence |
|---|---|---|
| PRIV-1 names claim | **FIXED** (unchanged) | `boostAgreeQuestions` `app_en.arb:1056` still says "numbers, e-mail addresses and links"; LIVE privacy: "femio does not remove names or other words". |
| PRIV-2 ML Kit telemetry | **PARTLY FIXED, with a regression** | Still disclosed: `leaveModelBody` `:1395` and LIVE privacy and health-data pages. But new wizard strings say "Nothing is sent" for on-phone AI (PRIV-N3-3). Traffic is NOT VERIFIED (owner row 33). |
| PRIV-3 R11 record in policies | **FIXED** | LIVE privacy and health-data pages list sexual activity, medicines with doses, labs, documents and photos. |
| PRIV-4 birth-year purpose | **FIXED** | LIVE privacy, "Your birth year checks that you are 18 or over…". |
| PRIV-5 notification text | **FIXED** | LIVE privacy, "Reminders, notifications and the widget". |
| PRIV-6 console facts | **NOT VERIFIED** | `boostKept` `:1063` and LIVE "We keep Google's optional request logging switched off" still rest on unseen console settings (owner rows 29-30). |
| PRIV-7 complete list | **FIXED**, with a new omission | LIVE "Files you share or export". A shared receipt copy is not on either list (PRIV-N3-4). |
| PRIV-8 internet only for AI | **FIXED** | LIVE summary names Google Play. |
| PRIV-9 live site vs policy | **PARTLY FIXED** | Fixed: both dates are now `2026-11-27` (`placeholders.ts`; LIVE in en/ar/fr/es; health data v3). Still open: `/_vercel/insights/script.js` returns 404, so the policy says visits are counted while nothing is counted. `ads.txt` is still "no advertising configured". Vercel toggle: OWNER-ONLY (row 31). |
| PRIV-10 NEXT_LOCALE | **FIXED** | Header still sets it; LIVE policy names it. |
| PRIV-11 tripwire gaps | **PARTLY FIXED** (unchanged) | (d) There is still no check that binds policy wording to code. PRIV-N3-1 and PRIV-N3-3 are drift that such a check would catch. |
| PRIV-12 heuristic redaction | **OPEN** (disclosed) | `redaction.dart` unchanged since 3a92a90 (`git diff --stat` empty). |
| PRIV-13 receipt language | **PARTLY FIXED** (improved) | The wizard now passes `lang` on every receipt (`ai_choices_wizard.dart:133-140`). `afterRestore` → `withdraw(at)` still writes no `lang` (`cloud_consent.dart`). No archive of each version's wording in the app, and no lawyer's view yet (row 36). |
| PRIV-14 unencrypted stores / IME | **PARTLY FIXED** (unchanged) | `enableIMEPersonalizedLearning` is still absent from `lib/`. Keyboard behaviour NOT VERIFIED. |
| PRIV-15 App Check at `status()` | **OPEN** | `FemioAssistant.kt:139` `status()` still calls `firebase()`. Network effect NOT VERIFIED. |
| PRIV-16 Devpost | **FIXED** (unchanged) | — |
| PRIV-N2-1 health-data recipients | **FIXED** | LIVE `/en/consumer-health-data` v3, "Who receives it": the "Nobody, except" wording is gone. It now names the ML Kit usage data ("even with Cloud boost off… an identifier for this installation") and the files she shares, including "a report about an AI answer". The source diff changed all four `messages/*.json`. |
| PRIV-N2-2 report flow | **FIXED** | The sheet shows "This is exactly what will be sent:" with the same `answerReportText` it sends (`report_answer_sheet.dart:94-107`). The test asserts that what is shown equals what is sent (`r14_18_report_answer_test.dart:100-102`, passed). `reportBody` now says "the answer may repeat words you used". `leaveShareBody` `:2297` names reports. The clipboard fallback is still unflagged (SEC-N2-5b). |
| PRIV-N2-3 WebViewActivity | **OPEN** | Still a tripwire warning in both merged manifests. |

Totals (19): 10 fixed · 5 partly fixed · 3 open · 1 not verified.

### Consent-related SEC findings

| ID | Status at eca4eaa | Evidence |
|---|---|---|
| SEC-5 claim not proven on the wire | **OPEN** | No capture. The new `check` method adds one more cloud path that a capture should cover. |
| SEC-8 API key / App Check | **OPEN, NOT VERIFIED** | Console only. The check's `app_check` and `api_key` codes will help the owner diagnose it, but they prove nothing about how the key is restricted. |
| SEC-12 native bridge trusts Dart | **PARTLY FIXED** (unchanged) | The new Kotlin `check()` (`FemioAssistant.kt:174-192`) also checks no consent. The only gate is in Dart: `AssistantGateway.checkCloud` needs the bridge, the build flag, her master switch and `allows(questions)` (`assistant_gateway.dart:120-136`; test `assistant_gateway_test.dart:184`, passed). |
| SEC-13 heuristic redaction | **PARTLY FIXED** (unchanged) | See PRIV-12. |
| SEC-N2-2 unconfigured signed build | **CLAIMED FIXED, NOT VERIFIED by me** | PROGRESS R14.20 claims a rebuild with the Firebase ids. I did not scan the artefacts. |
| SEC-N2-3 Google SDKs start before consent | **OPEN** | The tripwire still warns about datatransport. It matters more now: on-device AI is on by default with no receipt (PRIV-N3-3). |
| SEC-N2-5 report wording / clipboard | **(a) FIXED, (b) OPEN** | (a) The wording is softened. (b) `report_answer_sheet.dart:65` still uses `Clipboard.setData` with no sensitive flag. |

## 3 · R14.21, R14.20, R14.23 against the brief's questions

- **Specific and per purpose? Yes.**
  - `CloudPurpose.questions` and `.tips` are separate boxes, plus three statement boxes, and none is pre-ticked (`ai_choices_wizard.dart:79-81, 289-297`).
  - `_ready` needs every required statement, at least one purpose and a cloud-capable build.
  - The receipt stores purposes, statement ids, `ai`, version 3, `lang` and the UTC time.
  - One weakness: the "I have read femio's privacy notice" box is a self-declaration. The notice is a link and is not shown in the wizard. This is common practice, so it is a nit.
- **As easy to withdraw as to give? Only for "No AI", and never "one tap".** See PRIV-N3-1.
- **Does the seal prove anything?** It proves integrity only against accidental change and naive edits. ADR-085 says so honestly. The app screens do not (PRIV-N3-2).
- **Does a shared receipt leak?** No health data, no bands and no record. It does reveal her time zone offset (the local time and the UTC time are printed side by side) and that she uses femio. The share is not named in the "what can leave" lists (PRIV-N3-4).
- **Does "Check Cloud boost" send anything, and is that said first? Yes, and yes.**
  - It sends the fixed sentence `"Reply with the single word OK."` with `ONLY_IN_CLOUD` (`FemioAssistant.kt:89, 174-192`). Like any Cloud boost request, Google also sees her IP address and an App Check token.
  - `cloudCheckNote` (`app_en.arb:986`) is shown above the button before it runs.
  - The button only appears while questions consent is in force. The call is logged in her AI ledger with the sentence (`assistant_gateway.dart:134`).
  - Whether a real request succeeds against the project is NOT VERIFIED (it needs a phone).
- **Do the logcat failure codes hold her data?** The codes themselves do not. Each logcat line also carries up to 300 characters of the raw exception message, for every method, including the on-phone `private` call that holds her unredacted prompt (PRIV-N3-5).
- **Delete acknowledgement.** The Delete button stays disabled until she ticks the box (`delete_dialog.dart:19-50`; 2 tests passed). One extra tick for erasure is proportionate. Deleting also erases her consent receipts. That is consistent, since femio holds no copy, but there is then no consent history left.
- **R14.20 (PRIV-N2-1, dates): FIXED** (LIVE, all four languages).
- **R14.23 save-to-record: stays local, and needs her tap.**
  - `SaveToRecordCard._save` → `controller.save(withAskSaved(...))`. No network code is involved, and no model either: the terms come from her question through the "Say it" phrase rules (`ask_save.dart`).
  - The card is hidden when a safety signal fired (`ask_screen.dart:315`). "Not now writes nothing" is tested and passed.
  - One wording gap: the terms box starts ticked (PRIV-N3-6).

## 4 · New findings

| ID | Sev | Finding | Evidence | Fix |
|---|---|---|---|---|
| PRIV-N3-1 | P1 | **Withdrawing is harder than promised, and moving down from Cloud boost asks for statements again.** (a) "Cloud boost → on-phone only" means choosing `AiMode.phone`, whose `_requiredAcks` are `wellness` and `notice`, so she must tick two boxes to withdraw. Dropping just one purpose means re-ticking all three statements. ADR-085 §1 and PROGRESS say "switching off needs no boxes". (b) Even "No AI" takes choose → Next → Next → Confirm → dialog. `aiWizardOffConfirm` says "turning AI off is always one step". (c) The LIVE privacy page says "One tap, on the Cloud boost screen or in Settings, Assistant" and "Turn Cloud boost off on its screen". The health-data page says "withdraw it at any time with one tap" and "consent on the Cloud boost screen". The separate screen is gone, and `boostTurnOff` is now unused. (d) The off path no longer shows `boostWithdrawEffect` (unused): "It cannot recall what was already sent". | `ai_choices_wizard.dart:104-108`; `app_en.arb:916, 1054, 1082`; LIVE `/en/privacy`, `/en/consumer-health-data`; `apps/web/messages/en.json:1204, 1208, 1321` | Ask for no statements on any move to a lower mode, and for no re-tick when dropping one purpose. Add a one-confirm "Turn off Cloud boost" on Settings → Assistant that writes a withdrawal receipt. Show `boostWithdrawEffect` on the off path. Rewrite the live wording ×4 ("in Settings › Assistant › AI and Cloud boost"). BUILDABLE |
| PRIV-N3-2 | P2 | **The seal is an unkeyed hash, and the screen implies more than it gives.** The probe at eca4eaa found four things. (1) Editing a grant's date, dropping a later withdrawal and re-sealing with the public algorithm gives `sealIntact: true`, with tips allowed. (2) Removing the newest receipt (the withdrawal) without re-sealing gives `sealIntact: true`, and tips are allowed again. (3) Stripping every `seal` and `prev` gives `sealIntact: true`. (4) Only an edit or removal in the middle without re-sealing is caught. On the phone, the record is already authenticated by AES-GCM, so the seal adds nothing there. On a shared plain-text copy, anyone can edit and re-seal, and the "Record intact" line is just text. ADR-085 is honest ("not a signature… anyone with the code could compute a seal"). The UI is not: `aiRecordBroken` asserts "This record was changed outside femio", and `aiRecordIntact` and `aiRecordIntro` read as proof. The code comments say "a record that can show, in a dispute, what she chose" (`ai_choices_record_screen.dart:4`). | probe output; `cloud_consent.dart` `sealIntact` and `_append`; `app_en.arb:937-939` | Say plainly in the app: "The seal shows accidental damage. It is not proof for anyone else." Treat "sealed receipts after unsealed ones" and "missing seals" as not intact. Drop the "Record intact" line from the shared copy. Signed receipts need a server and an ADR (owner row 29). BUILDABLE (wording); OWNER-ONLY (stronger proof) |
| PRIV-N3-3 | P1 | **"Nothing is sent" is back on the consent path**, which contradicts the ML Kit disclosure. Three strings: `aiChoicesSubPhone` "On, on this phone only. Nothing is sent."; `aiConfirmDialogBody` (phone) "Nothing will be sent."; `aiWizardOffBody` "Nothing is sent anywhere." But `leaveModelBody` and the LIVE pages say that Google's AI software may send usage data with an installation identifier "whenever the on-phone AI runs". On-device AI is on by default (`assistantOn ?? true`) with no receipt, while the wizard asks for two statements for the same mode. So the disclosed telemetry starts with no choice made. Whether ML Kit or datatransport send anything with AI off or on is NOT VERIFIED (SEC-N2-3). | `app_en.arb:885, 910, 921, 1395`; `profile.dart:208` | Say "Nothing you type or log is sent; Google's AI software may send technical usage data (see What can leave this phone)". Do not say "Nothing is sent anywhere" until a capture proves it. Settle with the capture (row 33). BUILDABLE (wording); OWNER-ONLY (capture) |
| PRIV-N3-4 | P2 | **The shared receipt copy is not named in any "what can leave" list, and it reveals her time zone.** `receiptsAsText` prints the local time and the UTC time per receipt, plus language and AI choices. It goes to any app through `shareText`. It is absent from `leaveShareBody`, the LIVE "Files you share or export", and the health-data recipients line. The LIVE privacy page also still says the receipt is seen "on the Cloud boost screen". | `ai_choices_record_screen.dart:89-104`; `app_en.arb:2297`; LIVE `/en/privacy` | Add "a copy of your AI choices" to the three lists ×4. Print UTC only in the shared copy. Point the live text to "My AI choices". BUILDABLE |
| PRIV-N3-5 | P2 | **logcat gets raw exception messages, not only codes.** `logFailure` writes `"$method failed [$reason]: Class: ${e.message.take(300)}"` for every method, including `private` (on-phone, her unredacted prompt) and `hybrid`. Firebase AI exception messages normally hold server errors or finish reasons. femio does not control the SDK or on-device messages, so the comment "the log never holds her text" and ADR-085's "no prompt text, no record" cannot be guaranteed. `Log.w` is not stripped in release (no `-assumenosideeffects`). Reading logcat needs adb or a bug report. | `FemioAssistant.kt:115-123, 249-253`; `proguard-rules.pro` | Log only the method, the reason code and the exception class. Drop the message, or keep it only for `check`, whose prompt is fixed. BUILDABLE |
| PRIV-N3-6 | nit | **The save-to-record intro says "Nothing is saved unless you tick it and tap Save", but the terms box starts ticked** (`_addTerms = _terms.isNotEmpty`; the test is named "terms are preselected"). Saving still needs her Save tap and stays local, so rule 7 holds. | `save_to_record_card.dart:43-45`; `app_en.arb:1864`; `r14_ask_log_test.dart:290` | Start the box unticked, or say "Nothing is saved until you tap Save". BUILDABLE |
| PRIV-N3-7 | nit | **`docs/store/data-safety-and-declarations.md` predates v3.** It is unchanged since 3a92a90: it still cites "consent text version 2" and still marks the privacy URL "not verified on the live site" (it is live). It does not mention the wizard, the receipts or the Check call. The form answers themselves are still right. | `git log` on the file (last 8d1ab40) | Refresh the evidence rows on the day the form is filed. BUILDABLE |

## 5 · The 2-3 biggest gaps

1. **Make withdrawal as easy as consent, and make every page say the same.** This covers PRIV-N3-1, PRIV-N3-3, PRIV-N3-4 and the PRIV-11(d) wording check:
   - no statements when moving to a lower mode;
   - a one-confirm "Turn off Cloud boost";
   - replace "Nothing is sent" with honest wording;
   - live privacy and health-data pages ×4 that match the wizard ("My AI choices", no "one tap");
   - a lint that fails when the web or ARB copy says "one tap" or "Nothing is sent".

   **BUILDABLE.**
2. **The privacy claim on the wire is still unproven** (SEC-5, SEC-N2-3, PRIV-2, PRIV-15, plus the new `check` path), and so are the console settings behind `boostKept` (PRIV-6, SEC-8). The Data safety form has to match whatever the capture shows. **OWNER-ONLY** (phone capture, row 33; consoles, rows 29-30). The Vercel analytics toggle is also **OWNER-ONLY** (PRIV-9, row 31).
3. **Be honest about what the seal proves** (PRIV-N3-2): soften the app wording and harden `sealIntact` against stripped seals (**BUILDABLE**). Proof that holds against a third party would need a signed receipt held by a server. That is a new ADR and a lawyer's view. **OWNER-ONLY** (row 29).
