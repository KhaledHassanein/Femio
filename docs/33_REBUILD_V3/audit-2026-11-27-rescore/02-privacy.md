# 02 · Privacy re-score (2026-11-27)

Re-score of the 26 Nov privacy audit (`../audit-2026-11-26/02-privacy.md`, commit fb45488) at main `3a92a90`.
Read-only. Same rubric: privacy as a hackathon judge, 1-10, finding IDs PRIV-*.
Labels: VERIFIED = I read the code, ran the command or fetched the live page. NOT VERIFIED = needs a phone capture or a console.
LOCAL CODE = this checkout. LIVE SITE = femioapp.com, fetched 2026-11-27.
Not done: no `flutter test`, no builds. Tests cited were read, not run.

## 1 · Score: 8 -> 9 / 10

Why up: the three reasons I held it at 8 are closed in code and on the live site. Names are no longer claimed, ML Kit telemetry is now disclosed, and the policies now cover the health record.
Why not 10: Google console facts (paid tier, logging off) and the ML Kit traffic are still unproven. The Play Data safety form is only recommended, not filed. Two live-site loose ends remain.

## 2 · Tripwire

`node scripts/analytics-lint.mjs` -> exit 0, privacy tripwire pass line printed (VERIFIED). It also prints 8 review warnings: ML Kit/Firebase datatransport telemetry components and the unused `url_launcher` WebViewActivity (pulled in by `in_app_review`), all from the merged release manifest.
`--require-merged-manifest` also passes. The merged manifest is dated 27 Nov 01:55, has no `AD_ID` and no personal permission (permissions: INTERNET, ACCESS_NETWORK_STATE, RECEIVE_BOOT_COMPLETED, VIBRATE, POST_NOTIFICATIONS, AICore bind, BILLING).
New since 26 Nov: Kotlin network code outside `assistant/`, a Gradle allowlist and a merged-manifest check (`scripts/lib/android-tripwire.mjs`).
Still no check that binds policy wording to code. The signed APK/AAB in E:/femio-builds (27 Nov 02:58) is newer than that manifest; I did not unpack it (NOT VERIFIED).

## 3 · Old findings

| ID | Status | Evidence |
|---|---|---|
| PRIV-1 names claim | **FIXED** | LOCAL: `app_en.arb:922` and `:1296` now say "numbers, e-mail addresses and links". `redaction.dart` unchanged (strips email, URL, digits). `cloudConsentVersion` 1 -> 2 (`cloud_consent.dart:23`), so old consent lapses. LIVE: `/en/privacy` has no "names removed" claim; `/en/consumer-health-data` says "femio does not remove names". Devpost lines 6 and 42 corrected. Names still go out if she types one; she sees and edits the text first. |
| PRIV-2 ML Kit telemetry | **PARTLY FIXED** | Disclosed: app `leaveModelBody` (`app_en.arb:1261`); LIVE privacy: "even with Cloud boost off, that software may send Google technical usage data… identifiers for this installation"; "nothing is sent" is gone. `data-safety-and-declarations.md:35-36` now recommends ticking Device IDs and Diagnostics. NOT VERIFIED: actual traffic (owner row 33) and the Play console form. |
| PRIV-3 policies omit R11 | **FIXED** | LIVE `/en/privacy` and `/en/consumer-health-data` list sexual activity, medicines with doses, lab results, documents and photos. The false "no photos or files" line is replaced by "only a photo or file you choose to add". |
| PRIV-4 birth-year purpose | **FIXED** | LIVE: "Your birth year checks that you are 18 or over, and your age shapes some guidance"; the yes/no question "is not saved". App `leaveIntro` `:1248` matches. |
| PRIV-5 notification text | **FIXED** | LIVE privacy: notification shows "femio" "unless you write your own words for a medicine reminder". App `leaveNever` `:1268` says so too. |
| PRIV-6 console facts | **NOT VERIFIED** | Paid tier, logging off, monitoring off (owner rows 29-30). Consent text `boostKept` `:929` still asserts them. |
| PRIV-7 "complete list" | **FIXED** | LIVE has "Files you share or export" incl. unencrypted CSV and clipboard. App `leaveShareBody` `:2100`. |
| PRIV-8 internet only for AI | **FIXED** | LIVE summary now names Google Play (installs, updates, ratings, payments). |
| PRIV-9 live site vs policy | **OPEN** | LIVE: `/_vercel/insights/script.js` still 404 (nothing counted, policy says visits are counted). Effective date still "2026-11-30" (future) on both pages. `ads.txt` still "no advertising configured". Owner row 31. |
| PRIV-10 NEXT_LOCALE cookie | **FIXED** | LIVE privacy names `NEXT_LOCALE` as a session cookie; the header still sets it. |
| PRIV-11 tripwire gaps | **PARTLY FIXED** | (a) Kotlin network, (b) Gradle allowlist, (c) merged-manifest requirement fixed (`android-tripwire.mjs`, `analytics-lint.mjs` diff). (d) no wording-to-code check: still open. |
| PRIV-12 heuristic redaction | **OPEN** | `redaction.dart` unchanged; no name detection. Now honestly disclosed; the approval box remains the control. |
| PRIV-13 receipt language | **PARTLY FIXED** | `lang` added to `CloudConsentEvent` (`cloud_consent.dart:40-79`); `cloud_boost_screen.dart:149` passes it. Per-version text archive and the lawyer's view (row 36) still open. |
| PRIV-14 unencrypted stores / IME | **PARTLY FIXED** | Disclosure added in app and web (widget and reminder text unencrypted). `enableIMEPersonalizedLearning` still absent from `lib/` (grep). Keyboard behaviour NOT VERIFIED. |
| PRIV-15 App Check at `status()` | **OPEN** | `FemioAssistant.kt:113` still calls `firebase()` in `status()`. The only change to this file was a 20 s timeout. Network effect NOT VERIFIED (owner row 33). |
| PRIV-16 Devpost overclaims | **FIXED** | `DEVPOST_SUBMISSION.md:8-9` and `:42` rewritten to match. |

Totals: 8 fixed, 4 partly fixed, 3 open, 1 not verified (16).
Consent path re-check: still one `runHybrid` caller behind the consent gate; consent v2 tests read, not run. No P0.

## 4 · R14.18 "Report this answer" (LOCAL CODE, VERIFIED by reading)

`report_answer_sheet.dart` builds text of reason + origin label + the answer, then `shareText(..., to: info@femioapp.com)`. Dart has no network code; the share sheet hands it to the app she picks. No question, record or device data is added. Nothing leaves unless she taps Send and picks an app. The button shows only on model summaries (`answer_card.dart:94`), which is the only free text the AI writes. Test file `r14_18_report_answer_test.dart` exists (not run). Gaps: PRIV-N2-2.

## 5 · New findings

| ID | Sev | Finding | Evidence | Fix |
|---|---|---|---|---|
| PRIV-N2-1 | P1 | The live `/en/consumer-health-data` page says "Who receives it: Nobody, except Cloud boost". `/en/privacy` says Google's AI software may send usage data with installation identifiers even with Cloud boost off. The two live legal pages contradict each other, and the stricter-regime page is the narrower. | LIVE text of both pages, 2026-11-27 | Add the ML Kit usage-data line, Play and the share/report flows to "Who receives it", in 4 languages. BUILDABLE |
| PRIV-N2-2 | P2 | The report sheet says it "holds only this answer", but the answer is a model summary and could repeat words from her question. The sheet does not show the text before the share sheet, and the app she picks (not necessarily e-mail) receives it. The "What can leave this phone" screen, the web lists and the Data safety doc do not name this flow. | `report_answer_sheet.dart:60-90`, `app_en.arb:729`, `leaveShareBody` `:2100` | Show the exact text in the sheet. Add "Reports you send" to the leave lists. Soften "never your question". BUILDABLE |
| PRIV-N2-3 | P2 | `url_launcher` WebViewActivity ships in the merged release manifest, pulled in by `in_app_review`; femio never calls it. The tripwire only warns. | lint warnings | ADR line or drop the dependency. BUILDABLE |

## 6 · Biggest remaining gaps

1. **ML Kit telemetry and App Check traffic are unproven** (PRIV-2, PRIV-15), and the Play Data safety form must be filed to match. Needs a phone capture and the Play console. OWNER-ONLY (row 33, store console).
2. **Google console facts behind the consent text are unchecked** (PRIV-6: paid tier, logging off, monitoring off). If wrong, `boostKept` is false. Screenshots go in `docs/compliance/evidence/`. OWNER-ONLY (rows 29-30).
3. **Live legal pages still disagree with each other and with the product** (PRIV-N2-1 recipients, PRIV-9 future effective date and analytics 404, PRIV-N2-2 report flow). The wording and date are BUILDABLE; the Vercel analytics toggle is OWNER-ONLY (row 31).
