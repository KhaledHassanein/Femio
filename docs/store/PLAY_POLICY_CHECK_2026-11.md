# Google Play policy check for femio 1.0.0 (build 1), 27 Nov 2026

Rule-by-rule check of the release build and the store files against Google's pages. It also says
which Play Console "App content" answers live in which file. Ported on 2026-11-27 (R14.15) from the
2 Nov check in commit 0475223, then rewritten for the build as it is now:
- no ads SDK (removed 24 Nov, ADR-080);
- Cloud boost through Firebase AI Logic, only with her consent (ADR-079, ADR-080);
- App Check with Play Integrity.

The paste-ready Data safety, Health apps and audience answers live in one place only,
`data-safety-and-declarations.md`, so this file does not repeat them.

**Status words:**
- **pass**: the build or file meets the rule.
- **gap**: something to fix.
- **not verified**: no official source found, or it can only be confirmed in the Console.

**Read dates:** each source carries the date it was read. Pages marked "read 2026-11-01" were not
re-read today. Re-read them on submission day; Google changes forms and labels.

## 1 · The table

| # | Rule | Source | femio status | Action and who |
|---|---|---|---|---|
| 1 | **Closed test: 12 testers, 14 days** (personal accounts created after 13 Nov 2023), then apply for production access | https://support.google.com/googleplay/android-developer/answer/14151465 (read 2026-11-01) | **not verified** for femio: depends on the account's creation date | **Owner:** OWNER_ACTIONS rows 1 and 6; plan 16 testers in Egypt and Saudi Arabia. |
| 2 | **Target API level:** new apps and updates target Android 16 (API 36) or higher | https://support.google.com/googleplay/android-developer/answer/11926878 (read 2026-11-01) | **pass**: see §3 (read from the 27 Nov release APK) | Keep target 36+ on every update. |
| 3 | **16 KB memory page size** for apps targeting API 35+ on 64-bit devices; updates without it blocked from 1 Feb 2027 | https://developer.android.com/guide/practices/page-sizes (read 2026-11-01) | **pass** on the 27 Nov release APK (§3). AGP 9.1.0 | **Session:** re-run §3 on the upload-signed `.aab` (universal APK via bundletool) before upload. |
| 4 | **Health apps declaration:** every app completes it | https://support.google.com/googleplay/android-developer/answer/14738291 (read 2026-11-01) | **pass**: answers in `data-safety-and-declarations.md` | **Owner:** tick as that file says. Recommended extra: **Emergency and First Aid**, because Help now lists emergency numbers (`features/help/help_now_screen.dart`); over-declaring is the lower risk. |
| 5 | **Health Content and Services:** no misleading claims; a non-device health app carries Google's disclaimer in its description and reminds users to consult a professional; privacy policy on a public HTML page and inside the app; no permission the core feature does not need | https://support.google.com/googleplay/android-developer/answer/12261419 (read 2026-11-01) | **pass**: the disclaimer is in all four full descriptions (`pnpm store-lint` checks it); every permission has a job (§4) | **Owner:** confirm on the phone that the in-app link to the privacy page opens. |
| 6 | **Metadata:** title of 30 characters or fewer, no ranking claims, no testimonials, no emojis in the title; avoid ALL CAPS unless it is part of the brand | https://support.google.com/googleplay/android-developer/answer/9898842 ; limits https://support.google.com/googleplay/android-developer/answer/9859152 (read 2026-11-01) | **pass**: the store-listing guard passes on EN, AR, FR and ES; section headers moved to sentence case on 27 Nov (REL-10) | Run `pnpm store-lint` after every listing edit. |
| 7 | **Data safety:** data an SDK sends counts as collected | https://support.google.com/googleplay/android-developer/answer/10787469 (read 2026-11-01) | **pass once the 27 Nov answers are pasted**: Cloud boost (health info, user content; optional, not shared) and Google's on-device AI telemetry (device or other IDs, diagnostics) | **Owner:** paste from `data-safety-and-declarations.md`. The traffic capture (row 33) can still change the ID answer. |
| 8 | **AI-generated content:** apps that generate content with AI must prevent restricted content, and "must contain in-app user reporting or flagging features" so users can report offensive content without leaving the app | https://support.google.com/googleplay/android-developer/answer/13985936 (read 2026-11-27) | **gap**: femio's assistant writes summaries, tips and visit questions, with no in-app way to report an answer. Rules run first, and answers come only from the bundled registry with citations, which limits the risk but does not meet the reporting duty | **Owner decision (new):** femio has no server, so a report needs a channel. Recommended: a "Report this answer" action on every AI output that shows the exact text it will send and opens an e-mail draft to the support address, with nothing else from her record. Whether opening the mail app counts as "without needing to exit the app" is **not verified**. App UI lane (PROGRESS R14.18). |
| 9 | **Advertising ID:** apps targeting Android 13+ declare whether they use it | https://support.google.com/googleplay/android-developer/answer/6048248 (read 2026-11-01) | **pass**: no `AD_ID` or `ACCESS_ADSERVICES_*` in the release manifest; the tripwire fails if one appears | **Owner:** answer **No, the app does not use an advertising ID**. |
| 10 | **Ads and ads consent** (EU User Consent Policy, certified CMP) | https://www.google.com/about/company/user-consent-policy/ (read 2026-11-01) | **not applicable**: no ads SDK since 24 Nov (ADR-080). The website's AdSense consent is a web matter, not a Play one | **Owner:** Ads form: **No, my app does not contain ads**. |
| 11 | **Content rating (IARC):** every new app answers the questionnaire, and wrong answers can lead to removal | https://support.google.com/googleplay/android-developer/answer/9898843 (read 2026-11-01) | **not verified**: question wording is visible only in the Console | **Owner:** answer literally (topics in §5). |
| 12 | **Target audience:** 18+ only, with "Restrict minor access"; child appeal is judged by the listing's look | https://support.google.com/googleplay/android-developer/answer/9867159 (read 2026-11-01) | **pass**: the first run asks about the 18th birthday; abstract Dusk Bloom art; no people | **Owner:** tick 18+ and Restrict minor access. |
| 13 | **User Data policy:** privacy policy in the Console and in the app; prominent disclosure before an unexpected use; secure transmission; deletion | https://support.google.com/googleplay/android-developer/answer/10144311 (read 2026-11-01) | **pass**: no accounts; Settings → Delete everything; Cloud boost consent per purpose with a dated receipt; privacy v3 names everything that can leave the phone | **Owner:** the live site shows v3 only after the website deploy (R14.16). |
| 14 | **Notifications:** Android 13+ asks for `POST_NOTIFICATIONS` at run time, best asked in context | https://developer.android.com/develop/ui/views/notifications/notification-permission (read 2026-11-01) | **pass**: asked only when she turns on a reminder | Confirm on an Android 13+ phone (owner action 5). |
| 15 | **Health Connect** is personal and sensitive data with extra rules | as row 5 | **not applicable**: no Health Connect, no location, no camera or storage permission | Re-check if any is added. |
| 16 | **App Check / Play Integrity:** by default App Check wants the `PLAY_RECOGNIZED` label, which an app not on Play cannot get; an app distributed outside Play can relax it | https://firebase.google.com/docs/app-check/android/play-integrity-provider (read 2026-11-27) | **pass for judging** once the console settings in `docs/hackathon/RELEASE_STEPS.md` section C are saved (not verified on a phone) | **Owner:** after the Play launch, add the Play app signing key's SHA-256 and require `PLAY_RECOGNIZED` again. |
| 17 | **Generative AI disclosure** in the Console (if asked) | Console only | **not verified** | Answer yes: Gemini Nano on the phone, and the cloud model only through Cloud boost with consent. Safeguards: citations, rules first, nothing written to her record without her confirming. |

## 2 · What changed since the 2 Nov check

- **Ads.** The ads SDK and everything that depended on it are gone: the `AD_ID` and
  `FOREGROUND_SERVICE` permissions, the advertising-ID declaration, the AdMob consent message and
  the WorkManager database that crashed 0.5.0+5. Rows 8 to 11 of the old check no longer apply.
- **New network path.** Firebase AI Logic (Cloud boost), App Check with Play Integrity, and Google's
  on-device AI telemetry (ML Kit GenAI). See row 16 and Data safety.
- **New policy row 8 (AI-generated content).** This is a gap to close before the production
  release; it does not block the hackathon.
- **R8.** The keep rules were rewritten on 27 Nov (`android/app/proguard-rules.pro`). The resolved
  release classpath has no Room or WorkManager. Run `pnpm mobile-release-smoke` on every release APK:
  it is the only check that runs the minified build.

## 3 · Build facts (release APK, 27 Nov)

Filled from `aapt2 dump badging` and `zipalign -c -P 16` on the release APK built 2026-11-27
(`flutter build apk --release -P allowDebugSigning=true`, so debug-signed; the upload-signed
build must be re-checked).

| Fact | Result |
|---|---|
| Package, version | `com.femioapp.femio`, versionCode 1, versionName 1.0.0 |
| compileSdk, targetSdk | 36, 36 (row 2 **pass**) |
| Native code | arm64-v8a, armeabi-v7a, x86_64 |
| `zipalign -c -P 16 -v 4` | **Verification successful**; all 12 `.so` files OK |
| ELF LOAD alignment (`llvm-objdump -p`, NDK 28.2) | every library 2\*\*14 or 2\*\*16, never below 2\*\*14 (row 3 **pass**): `libapp` and `libflutter` 2\*\*16 on 64-bit, `libdartjni` and `libdatastore_shared_counter` (new since 2 Nov, from AndroidX DataStore through Firebase) 2\*\*14 |
| Release smoke test (`pnpm mobile-release-smoke`) | **pass** on an Android 16 emulator (AVD Medium_Phone_API_36.1, booted headless): clean install, first frame after 6.7 s, process alive, no crash. Synthetic: no records, no AI run |
| R8 | minify and shrinkResources on; keep rules in `android/app/proguard-rules.pro`; no Room or WorkManager in the resolved release classpath |
| Firebase Installations | absent from the resolved release classpath and the manifest (closes the dependency-tree check of REL-7) |

## 4 · Permissions (release manifest, 27 Nov)

| Permission | Comes from | Needed for |
|---|---|---|
| `INTERNET`, `ACCESS_NETWORK_STATE` | Firebase AI Logic, App Check | Cloud boost (only with consent), App Check, Gemini Nano model download through AICore |
| `com.google.android.apps.aicore.service.BIND_SERVICE` | `firebase-ai-ondevice` | talking to Android's AICore to run Gemini Nano |
| `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE` | `flutter_local_notifications` | reminders she turns on |
| `RECORD_AUDIO` | femio (`speech/SpeechChannel.kt`, ADR-086) | the mic on Ask femio and Say it: asked the first time she taps it; Android's on-device recognizer turns speech into text on the phone; no audio is recorded, kept or sent |
| `com.android.vending.BILLING` | `in_app_purchase` | femio Plus later; nothing sold in 1.0.0 |
| `com.femioapp.femio.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | AndroidX | the app's own receivers |

Absent: `AD_ID`, `ACCESS_ADSERVICES_*`, `CAMERA`, storage, media, location, exact alarms and
foreground service.

## 5 · Content rating topics (answer literally; question wording not verified)

| Topic | Answer |
|---|---|
| Violence, blood or gore | No (bleeding appears only as a warning sign in text) |
| Sexual content | No content for entertainment. Conception and fertile days appear as clinical education only, with no images |
| Language, gambling, controlled substances | No (medicines may be named; answer the question as worded) |
| Users interact or share content with other users | No (no accounts, no chat) |
| Shares location | No |
| Digital purchases | No for 1.0.0 |
| Ads | No |
| Generative AI | Yes, if asked (row 17) |
