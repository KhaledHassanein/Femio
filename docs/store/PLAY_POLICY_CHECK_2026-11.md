# Google Play policy check for femio 0.5.1+6 — 2026-11-01

What this is: a rule-by-rule check of the build and the store files against Google's current official
pages, plus paste-ready answers for every Play Console "App content" form.
Every source below was read on **2026-11-01** (the "read" date). None of the Google help pages shows a
"last updated" stamp unless stated; where a page gives one it is quoted.
Status words: **pass** (build or file meets the rule), **gap** (something to fix), **not verified**
(no official source found, or it can only be confirmed in the Console).
Evidence type: the 16 KB result and the manifest are from **real files** (an APK built 2026-11-01 from
the same code, `0.5.0+5`); everything else is a reading of text.

## 1 · The table

| # | Rule | Source (read 2026-11-01) | femio status | Action and who |
|---|---|---|---|---|
| 1 | **Closed test: 12 testers, 14 days.** Page text: "Developers with personal accounts created after November 13, 2023, must run a closed test for their app with a minimum of 12 testers who have been opted in continuously for at least 14 days", then "apply for production access on the Dashboard". Testers who opt out early do not count; Production stays disabled until met (this last point is from the same page as shown in a search result, not from my page fetch). | https://support.google.com/googleplay/android-developer/answer/14151465 | **not verified** for femio (see §2) | **Owner:** find the account's creation date. After 13 Nov 2023 → the rule applies to femio; plan 16 testers. On or before → the page does not apply it. If unsure, run the test anyway (it costs 14 days, the launch guide already plans it). |
| 2 | **Target API level.** New apps and updates must target Android 16 (API 36) or higher (deadline 31 Aug 2026, now passed). Existing apps need API 35 to stay available to new users. A one-time extension to 1 Nov 2026 existed. | https://support.google.com/googleplay/android-developer/answer/11926878 | **pass**. `targetSdkVersion 36`, `compileSdkVersion 36` read from the built APK with `aapt2 dump badging` | None. Keep target at 36 or above on every update. |
| 3 | **16 KB page size.** "All apps targeting Android 15 (API level 35) and higher must support 16 KB memory page sizes on 64-bit devices on Google Play. Starting February 1, 2027, if your app updates don't support 16 KB memory page sizes, you won't be able to release these updates." Needs AGP 8.5.1+, NDK r28+ (or linker flags on r27-), Build-Tools 35+ to check. The page does not mention the earlier dates (1 Nov 2025, 31 May 2026) and has no Flutter section. Page stamped 2026-10-16 UTC. | https://developer.android.com/guide/practices/page-sizes | **pass** on the APK (§3). AGP is 9.1.0 (`android/settings.gradle.kts`) | **Session:** re-run the two checks on the final `.aab` (extract a universal APK with bundletool) before upload. The deadline is 3 months away, so this is already met, not urgent. |
| 4 | **Health apps declaration.** Every app must complete it; Google reviews it with the app. Categories (verbatim): Health and fitness → "Period Tracking"; Medical → "Reproductive and Sexual Health", "Medical Reference and Education", "Emergency and First Aid", "Diseases and Conditions Management", "Clinical Decision Support", "Disease Prevention and Public Health" and others; plus "Medical device apps" (only if regulated as one). Non-device apps have no extra disclosure. | https://support.google.com/googleplay/android-developer/answer/14738291 | **pass** (answers in §4.8) | **Owner:** tick the boxes in §4.8. **Decision flagged:** in-app Help now (`lib/features/help/help_now_screen.dart`) lists emergency numbers; I recommend also ticking "Emergency and First Aid" (over-declaring is the lower risk; the page lists no extra duty). |
| 5 | **Health Content and Services policy.** Misleading health claims are banned. A non-device health app "must include a disclaimer in the app description" that it is "not a medical device and does not diagnose, treat, cure, or prevent any medical condition", and must remind users to consult a healthcare professional. A privacy policy on "an active, publicly accessible and non-geofenced URL (no PDFs)", also inside the app. No permissions the core feature does not need. | https://support.google.com/googleplay/android-developer/answer/12261419 | **pass**: the EN listing carries the disclaimer word for word plus "Always talk to your doctor or midwife"; privacy page loads as HTML (read 2026-11-01); permissions all have a job (§5) | **Session:** run `pnpm store-lint` on every listing edit (it checks the disclaimer). **Owner:** confirm the in-app Settings link to the privacy page on the phone. |
| 6 | **Metadata policy** (listing). No misleading or non-descriptive metadata; no unattributed testimonials; no "#1" or ranking claims; no emojis or repeated special characters in title; title 30 characters or fewer; no repetitive keywords; description must accurately describe the app; screenshots must reflect the real experience. | https://support.google.com/googleplay/android-developer/answer/9898842 ; limits 30/80/4,000 from https://support.google.com/googleplay/android-developer/answer/9859152 | **pass**. Title `femio: Ovulation & Pregnancy` (28), short 79, full 2,722; no superlatives, no testimonials, no emojis (`•` bullets are plain characters, not emoji). Screenshots are real screens with synthetic data | **Session:** keep the Arabic, French and Spanish listings under the same rules; `pnpm store-lint` covers length only. |
| 7 | **Data safety.** "Collect" includes data an SDK sends off the device; you must reflect third-party code. Inferred approximate location (from IP) "must be disclosed". Privacy policy required. Page change log: December 5, 2023. | https://support.google.com/googleplay/android-developer/answer/10787469 | **gap, fixed in this pass**: the old answer gave the advertising ID and approximate location one purpose (advertising); Google's SDK page gives all four types three purposes (§4.6, and the note at the top of `data-safety-and-declarations.md`) | **Owner:** paste §4.6. **Session:** done. |
| 8 | **Google Mobile Ads SDK disclosure.** Latest version covered: 25.5.0. Collected and shared automatically: IP address; user product interactions (launch, taps, video views); diagnostic information (launch time, hang rate, energy); device and account identifiers (ad ID, app set ID). Purposes for all: advertising, analytics, fraud prevention. Encrypted with TLS. Ad ID collection is optional (manifest). Page stamped 2026-10-30 UTC. Banner: this "Legacy" SDK is in maintenance mode; Google points to the GMA Next-Gen SDK. | https://developers.google.com/admob/android/privacy/play-data-disclosure | **pass** on version: `google_mobile_ads 9.2.0` pulls `play-services-ads:25.5.0` and `user-messaging-platform:4.0.0` (`pubspec.lock`, `google_mobile_ads-9.2.0/android/build.gradle`) | **Session:** re-read this page and `pubspec.lock` before each upload. Migration to Next-Gen: not urgent, no deadline found (not verified). |
| 9 | **Advertising ID.** Apps that update their target to Android 13+ must declare `com.google.android.gms.permission.AD_ID`; the Google Mobile Ads SDK may already add it by manifest merge. For analytics and fraud prevention Google suggests the app set ID. | https://support.google.com/googleplay/android-developer/answer/6048248 | **pass**. Merged manifest has `AD_ID` and `ACCESS_ADSERVICES_AD_ID` (APK badging) | **Owner:** answer the Console's Advertising ID question per §4.9. The page does not say what happens if the declaration is missing (not verified). |
| 10 | **Ads consent (EEA, UK, Switzerland).** Google EU User Consent Policy applies to end users in the EEA, UK and Switzerland. A Google-certified CMP is required to serve beyond Limited Ads there ("only Limited Ads will be eligible to serve on EEA and UK traffic" without one; enforced 16 Jan 2024; Switzerland 31 Jul 2024). The UMP SDK is optional: "you can use any CMP from the List of Google-certified CMP". UMP is IAB-certified for TCF v2.3. | https://www.google.com/about/company/user-consent-policy/ ; https://developers.google.com/admob/android/privacy/gdpr and https://developers.google.com/admob/flutter/privacy/gdpr (both stamped 2026-10-30 UTC); https://support.google.com/admob/answer/13554116 (dates); https://support.google.com/admob/answer/10113207 | **partial / not verified**. Code is ready: `ads_runtime.dart` runs UMP before the SDK starts and only requests ads if `canRequestAds()`. Whether a message exists in the AdMob account is not visible from the repo | **Owner:** before any EEA, UK or Swiss country is turned on, create the "European regulations" message in AdMob (Privacy and messaging). **Session:** test with UMP debug geography once the AdMob account exists. Recommendation in §6. |
| 11 | **Non-personalised ads.** Not a Play rule. Google's personalised-advertising page lists "Health" and "Birth control" as sensitive interest categories for advertisers; it does not address app publishers. | https://support.google.com/adspolicy/answer/143465 | pass by design: every request is `nonPersonalizedAds: true`, content rating capped at PG, no keywords (`ads_runtime.dart`) | None. |
| 12 | **Content rating.** Every new app needs the IARC questionnaire; wrong answers "may result in removal or suspension"; ads must not be significantly more mature than the app. The page says nothing specific about health or sexual content. | https://support.google.com/googleplay/android-developer/answer/9898843 | **not verified** (question wording is not in any page I could read) | **Owner:** answer per §4.4, literally. **Session:** none. |
| 13 | **Target audience.** 18+ is "content generally appropriate for adult audiences"; "Restrict Minor Access" can block minors from finding or downloading. Child appeal is judged on the listing's marketing elements (youthful animation, young characters). Choosing a wider age range than the app is built for is not appropriate. | https://support.google.com/googleplay/android-developer/answer/9867159 | **pass**: no characters or photos of people in the listing; Dusk Bloom art is abstract | **Owner:** tick 18+ and "Restrict minor access". |
| 14 | **User Data policy.** Privacy policy link in Play Console and inside the app; policy must cover retention and deletion. Prominent in-app disclosure before a consent or permission request when use may be unexpected. Secure transmission. SDK providers must not sell the data. Account deletion rules apply only when accounts exist. | https://support.google.com/googleplay/android-developer/answer/10144311 | **pass**: no accounts; Settings → Delete everything; the policy page names the advertising ID, device type and internet address and says "The one thing that leaves your phone is the ad request" | **Session (small):** the policy page does not mention the SDK's app-interaction and diagnostic data (taps, launch time). Add one sentence so it matches Data safety. |
| 15 | **Notifications.** Android 13+ needs the `POST_NOTIFICATIONS` runtime permission; with target 33+ the app controls when to ask; best practice is to ask in context after a user action ("the user taps an alert bell button"). Page stamped 2026-10-28 UTC. | https://developer.android.com/develop/ui/views/notifications/notification-permission | **pass**: asked only when she turns a reminder on (manifest comment, `data-safety-and-declarations.md`) | **Session:** confirm on a phone running Android 13+ that the prompt appears only after the reminder toggle (part of owner action 5). |
| 16 | **Health Connect.** The Health Content page says Health Connect data is personal and sensitive data with extra requirements. | https://support.google.com/googleplay/android-developer/answer/12261419 | **pass, not applicable**: no Health Connect, location or camera package in `pubspec.yaml`; no such permission in the APK | None. Re-check if Health Connect is ever added. |
| 17 | **Foreground service permission.** The merged manifest has `FOREGROUND_SERVICE` (from the ads SDK). Whether the Console then asks for a foreground-service declaration: no Google page read. | none found | **not verified** | **Owner:** if the Console asks at upload, say femio runs no foreground service; tell a session, which can strip the permission with `tools:node="remove"`. |
| 18 | **Account and testers (Console mechanics).** Closed track: up to 200 email lists of 2,000 users, or a Google Group; "Changes to distributed countries and regions apply across all tracks"; the opt-in link shows only when the app status is "Published"; extra closed tracks cannot target countries. | https://support.google.com/googleplay/android-developer/answer/9845334 | n/a | **Owner:** use one closed track; set countries once for the whole app. |

## 2 · Question 1 in detail: does the 12-testers rule apply to femio?

- **What the page says:** the requirement is stated for "personal accounts created after November 13, 2023": a closed test with at least 12 testers opted in continuously for at least 14 days, then you apply for production access.
- **What it does not say:** whether an account that already has a published app is exempt when it publishes a second app. The page ties the rule to the account's creation date only. It names no exemption for accounts with a live app. **The page is therefore silent, not ambiguous in the owner's favour:** read literally, the rule follows the account date, not the app count.
- **So:** account created after 13 Nov 2023 → the rule applies to femio (the first app's history does not exempt it, as far as the page says). Account created on or before 13 Nov 2023 → the page does not apply the rule.
- **Owner must:** (1) check the account's creation date (Console account details or the date of the Google payments/registration email; I could not verify where the Console shows it); (2) look at the app Dashboard: if Production access is enabled before any test, the rule is not applied to this app; (3) otherwise run the closed test with 16 testers and do not let anyone leave. The launch guide D4–D6 already does this.
- Note: a community post claims the number was once 20 and was reduced to 12 in December 2024; that is not an official page, so I ignore it.

## 3 · Question 3 in detail: the 16 KB check

APK: `E:\Femio\.claude\worktrees\femio-repo-study-planning-88d7c9\apps\mobile\build\app\outputs\flutter-apk\app-release.apk` (62,144,791 bytes; `0.5.0+5`, built 2026-11-01 02:21; not modified; libraries extracted by Python into the session scratchpad). Tools: Build-Tools 36.1.0 `zipalign`; NDK 28.2.13676358 `llvm-objdump`.

Command: `zipalign -c -P 16 -v 4 app-release.apk`. Last line: **Verification successful**.

| Library | zipalign 16 KB | ELF LOAD alignment (all three LOAD segments) |
|---|---|---|
| arm64-v8a/libapp.so | OK | 2**16 |
| arm64-v8a/libflutter.so | OK | 2**16 |
| arm64-v8a/libdartjni.so | OK | 2**14 |
| x86_64/libapp.so | OK | 2**16 |
| x86_64/libflutter.so | OK | 2**16 |
| x86_64/libdartjni.so | OK | 2**14 |
| armeabi-v7a/libapp.so | OK | 2**14 |
| armeabi-v7a/libflutter.so | OK | 2**16 |
| armeabi-v7a/libdartjni.so | OK | 2**14 |

The page's test: LOAD segments must not be below 2**14. **All nine pass.** The requirement covers 64-bit devices; the armeabi-v7a files pass too. The APK holds only these three libraries per CPU type; the ads SDK ships no native library. Limit of this evidence: it is the APK, not the `.aab` Play receives; and it is `0.5.0+5`, not `0.5.1+6` (same native libraries by the task brief; not rebuilt here).

## 4 · Paste-ready answers (Play Console → Policy → App content)

Re-check each label on the day; Google renames options.

### 4.1 Privacy policy
`https://femioapp.com/en/privacy` (Arabic listing: `https://femioapp.com/ar/privacy`). Plain HTML page, no PDF, open worldwide.

### 4.2 App access
"All or some functionality is restricted" → **No**: all functionality is available without login. No credentials, no special steps for the reviewer. Reviewer note (paste): "femio has no accounts. Open the app and choose a mode on first run. Reminders ask for notification permission only when you switch one on."

### 4.3 Ads
**Yes, my app contains ads.** (Google AdMob banners on guide screens only; non-personalised.)

### 4.4 Content rating (IARC questionnaire)
Enter the email `info@femioapp.com`. Category: **Utility, Productivity, Communication, or other** (a tracker; if the Console offers only "Reference, News, or Educational" for the library, choose by the app's main function, the tracker). Answer literally; the rating is whatever it returns. Question wording is **not verified**; answers by topic:

| Topic | Answer |
|---|---|
| Violence (any kind) | No |
| Blood or gore | No (clinical articles mention bleeding in pregnancy as a warning sign; no images of blood) |
| Sexuality: sexual content, nudity, sexual themes | No sexual content for entertainment. If the form asks about educational or clinical references to sex (conception, fertile days, intercourse timing), say they exist as **clinical education only**, no images, no erotic content |
| Language / profanity | No |
| Controlled substances (drugs, alcohol, tobacco) | No (medicines may be named in articles; answer the question as worded; do not omit if it asks about references) |
| Gambling / simulated gambling | No |
| User interaction: users can interact or exchange content | **No** (no accounts, no chat, no sharing, no user-generated content) |
| Shares the user's location with other users | No |
| Digital purchases | **No for 0.5.1** (femio Plus comes later; change and resubmit the questionnaire when Plus ships) |
| Unrestricted internet access / web browser | No |
| Contains ads | Yes (the Console takes this from the Ads form) |
| Health-related: medical or health content | Answer as asked: the app contains health information and tracking; it is not a medical device |

### 4.5 Target audience and content
Target age group: **18 and over only** (tick no other group). Appeals to children: **No**. Tick **Restrict minor access**. The store listing has no child-appealing elements.

### 4.6 Data safety (matches `data-safety-and-declarations.md` after today's fix)
- Collects or shares required data types: **Yes**.
- All collected data encrypted in transit: **Yes** (SDK sends over TLS, per Google).
- Users can request deletion: **Yes** (Settings → "Delete everything on this phone"; no server copy; no accounts).
- Data types, each **Collected: Yes, Shared: Yes, Processed ephemerally: No, Required (not optional)**, purposes **Advertising or marketing + Analytics + Fraud prevention, security, and compliance** for all four:
  1. **Device or other IDs** (advertising ID, app set ID)
  2. **Location → Approximate location** (inferred from IP address)
  3. **App activity → App interactions** (taps, app launch, video views)
  4. **App info and performance → Diagnostics** (launch time, hang rate, energy use)
- Do **not** tick Health info, Personal info, Financial info, Photos, Contacts. Her entries stay on the phone; the SDK never receives them.
- Independent security review: **No**.
- Mismatch check against Google's SDK page: the only mismatch was the purposes for IDs and location (fixed). One nuance: Google says ad ID collection is "optional" for the developer (remove `AD_ID`); femio keeps it, so for the user it is not optional: keep "Required". If you ever remove `AD_ID`, re-read the page and the form.

### 4.7 News app / Government app / Financial features
News app: **No**. Government app: **No**. Financial features: **None** (tick "My app doesn't provide any financial features"). When femio Plus ships, in-app purchases are Play Billing in-app products, not a financial feature.

### 4.8 Health apps declaration
- Health and fitness: **Period Tracking**
- Medical: **Reproductive and Sexual Health** (fertile window, contraction timer, baby-movement log) and **Medical Reference and Education** (Learn library with sources)
- Recommended extra: **Emergency and First Aid** (in-app Help now: emergency numbers by country, red-flag card). Owner may skip it; I rate omitting it a small risk, over-ticking a smaller one.
- Considered and **not** ticked: Diseases and Conditions Management (PCOS articles and a PCOS mode exist, but the app does not manage or treat a disease; flagged as the one borderline call), Clinical Decision Support, Disease Prevention and Public Health, Medication and Treatment Management.
- **Medical device apps: do not select.** Intended use is education and tracking; the listing disclaimer says it is not a medical device and not a method of birth control.
- Do **not** pick "My app doesn't provide any health features".

### 4.9 Advertising ID declaration
**Yes, the app uses the advertising ID.** Purposes to tick: **Advertising or marketing**, **Analytics**, **Fraud prevention, security, and compliance** (the SDK page lists exactly these for the identifiers). We keep `AD_ID` because: the Google Mobile Ads SDK (25.5.0) uses it for ad delivery, frequency capping and fraud checks; the user can reset or delete it in Android settings; femio never reads it itself, never links it to her records, and asks for non-personalised ads only. Removing it is optional per Google but would remove those functions. Option labels in the Console: **not verified**.

### 4.10 Other declarations the Console may show
Data deletion / account deletion: no accounts, so "My app does not allow users to create an account". COVID-19 / government: not applicable. Foreground service types: see table row 17. Financial/loan apps: no.

## 5 · Permissions check (merged manifest, from the APK)

| Permission | Source | Needed for | Verdict |
|---|---|---|---|
| `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE` | local-notifications plugin | reminders | needed |
| `INTERNET`, `ACCESS_NETWORK_STATE` | ads SDK | ad request | needed only for ads |
| `AD_ID`, `ACCESS_ADSERVICES_AD_ID` | ads SDK | ad delivery | declared in §4.9 |
| `WAKE_LOCK`, `FOREGROUND_SERVICE` | ads SDK | SDK internals | see row 17 |
| `com.android.vending.BILLING` | `in_app_purchase` | femio Plus, later | harmless now; no products yet |
| Topics and Attribution ad permissions | removed by `tools:node="remove"` | none | removed, good |

## 6 · Question 5: the recommendation on ads consent

- **Does femio need the UMP SDK if distributed in the EEA, UK or Switzerland?** It needs a Google-certified CMP (Google, https://support.google.com/admob/answer/13554116 and https://developers.google.com/admob/android/privacy/gdpr, both read 2026-11-01). UMP is one such CMP and "optional" only in the sense that any certified CMP will do. Without one, only Limited Ads can serve there: no policy rejection, but almost no ad income, and the consent duty of the EU User Consent Policy still applies. femio already contains UMP 4.0.0 and calls it first (`ads_runtime.dart`), so the code side is done.
- **Remaining work** for those regions is on the AdMob account side: create and publish the European regulations message; not visible from the repo, so **not verified**.
- **Recommendation (one):** **limit the app's countries to Egypt and Saudi Arabia for the closed test and for the first production release**, and keep UMP in the build. Why this: Google says country changes "apply across all tracks", so one setting covers testing and launch; no EEA, UK or Swiss user can then trigger the consent duty before the AdMob message is set up; it matches the wedge in `CLAUDE.md`. Add EEA, UK and Swiss countries only after the AdMob message is published and tested with UMP debug geography. This does not remove the owner's own legal duties for local law (Egypt Law 151 of 2020, Saudi PDPL); those are outside this check and **not verified** here.
- Caveat on testers: a tester abroad in the EEA cannot install if the country is not listed (launch guide troubleshooting row already says so). Recruit testers inside Egypt and Saudi Arabia.

## 7 · Listing check (`play-listing.en.md`)

| Check | Result |
|---|---|
| Disclaimer present and exact ("not a medical device and does not diagnose, treat, cure or prevent any medical condition") | pass |
| Reminder to consult a clinician | pass ("Always talk to your doctor or midwife", plus "seek medical care right away") |
| Predictions not birth control | pass ("not a method of birth control") |
| Health claims | pass: the listing promises tracking, estimates and education, not detection or treatment. "Clear guidance on when to talk to a doctor" and "Baby-movement log and contraction timer that never give a verdict" are accurate to the build per README ship gates |
| "Written by a physician, with sources" | pass as a claim of authorship; each article lists sources (README ship-gate table). Keep `[NEEDS SOURCE]` discipline for any new medical sentence |
| "No third-party analytics. Ads only on the guide screens" | pass: honest about ads, matches Data safety |
| "Your records never leave your phone" | pass: records stay on the device; the ad request is the only traffic and is disclosed in Data safety and the privacy page |
| "Encrypted ... on your device" and "No account" | pass (README) |
| Unattributed testimonials, rankings, emojis, other brands | none found |
| Contact email | `info@femioapp.com` present |

## 8 · Fixes needed outside this file (found while checking)

1. **`docs/33_REBUILD_V3/06_LAUNCH_GUIDE_A_TO_Z.md` D3 is stale and wrong:** it says "Ads: No" and "Data safety ... Collects: No. Shares: No." After ADR-076 the correct answers are Ads **Yes** and Collects/Shares **Yes** (§4.3, §4.6). A reviewer comparing the declaration with the APK would flag the mismatch. Owner: do not follow D3 for those two lines; **session: edit the guide** (I did not, since the brief limited changes to the data-safety file).
2. `docs/33_REBUILD_V3/03_LEGAL_PACK.md` §4.1 is cited by D3; check it matches §4.6 here.
3. Launch guide D2 uses the Arabic privacy URL for the whole listing; the brief for this check asks for the English URL. Either is valid (both are live HTML); use the English one on the default listing, Arabic on the Arabic listing.
4. Privacy page: add one sentence on app-interaction and diagnostic data (row 14).
