# Google Play: Data safety, Health apps declaration, content rating — answers for the initial release (1.0.0, build 1)

Source of the reasoning: `docs/33_REBUILD_V3/03_LEGAL_PACK.md` §4 and ADR-079/080 (`docs/DECISIONS.md`).
This file states the answers for the **build as it is on 2026-11-27** (refreshed after the R14 privacy truth pass and the native tripwire; first written 2026-11-25) and the evidence that makes each true.
Anything not checked against the running build or the live Console is marked **not verified**.
Re-check the Console's wording on submission day; Google changes the form.

## What the build does (evidence)

| Fact | Evidence | Status |
|---|---|---|
| No ads, analytics, crash-reporting, attribution or tracking SDK | `apps/mobile/pubspec.yaml` lists only cryptography, file_picker, flutter_local_notifications, flutter_secure_storage, in_app_purchase, in_app_review, in_app_update, intl, path_provider, timezone; `scripts/analytics-lint.mjs` fails on ads/analytics packages and on `AD_ID` / `ACCESS_ADSERVICES_*`; `AndroidManifest.xml` removes those four permissions with `tools:node="remove"`. Since 2026-11-27 the tripwire also reads the native side (`scripts/lib/android-tripwire.mjs`): no network code in Kotlin outside the assistant package, only reviewed Gradle dependencies and plugins, and no ad-ID permission, ad or analytics metadata in the merged manifests | verified in source 2026-11-27 |
| Network: Firebase AI Logic only (Cloud boost) | `INTERNET` in `AndroidManifest.xml`; Kotlin deps `firebase-ai:18.2.0`, `firebase-ai-ondevice`, `firebase-appcheck-playintegrity:20.1.0` in `android/app/build.gradle*`; tripwire forbids HTTP clients and sockets under `lib/` | verified in source |
| Cloud boost is off by default, consent per purpose, dated receipt | ADR-080 §3; consent strings `boostAgreeQuestions`, `boostAgreeTips`, `boostWho`, `boostKept` in `lib/l10n/app_en.arb` | verified in source; not re-run on a device |
| What Cloud boost sends | A redacted general question she approves, with public passages; or four coarse bands (life stage, cycle regularity, symptom kinds in the last month, logging streak). The answer language goes with it. Redaction removes numbers, e-mail addresses and links (not names), and she sees and edits the exact text first, so a question can still hold words she typed, such as a name. Nothing else from her record: not her log, notes, dates, cycle lengths, medicines, lab results, visits, documents, photos or birth year; never contacts or advertising ID (`boostNever`, consent text version 2). Google also sees her IP address and a Play Integrity check (`boostAlsoSeen`) | verified in source 2026-11-27 |
| Retention at Google | Paid tier: up to 55 days for abuse monitoring, no product improvement (`boostKept`; ADR-080) | per ADR; Google's current terms **not verified** |
| Records encrypted at rest | AES-GCM sealed file, key in the Android Keystore (`flutter_secure_storage`, `cryptography`) | verified in source |
| Backups | Passphrase-sealed file she saves herself (PBKDF2-HMAC-SHA256, 600,000 rounds since 2026-11-27, ADR-083); `allowBackup="false"` plus `fullBackupContent` and `dataExtractionRules` | verified in source |
| Deletion | Settings: "Delete everything on this phone" (`deleteConfirmTitle`) | verified in source |
| Google Play rating and in-app updates | `apps/mobile/lib/data/play_store.dart`: `in_app_review` and `in_app_update` talk to the Play Store app on the phone (Play Core); femio passes no data of hers; every failure is swallowed. The rating request follows 6 days of use (PROGRESS R12.2). Play, not femio, decides whether the dialog appears | verified in source; Play's own handling is Google's, so femio declares nothing for it |
| Reminders | Local notifications only; `POST_NOTIFICATIONS` asked at run time on Android 13+ when she turns one on; `RECEIVE_BOOT_COMPLETED`; no exact-alarm permission. Text is "femio: Open the app", except a medicine reminder, which shows the words she wrote for it on the notification and lock screen. Local only: nothing is sent | verified in source 2026-11-27 |
| Permissions in the **release** merged manifest | Release APK 2026-11-27 (`flutter build apk --release`, R8 keep rules of R14.15, debug-signed for the check; `aapt2 dump permissions`), same list as the 2026-11-25 bundle: `INTERNET`, `ACCESS_NETWORK_STATE`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE`, `com.android.vending.BILLING`, aicore `BIND_SERVICE`, plus the app's own `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`. No `AD_ID`, and no Firebase Installations component in the release manifest | verified in the release build 2026-11-27 |
| Accounts | None | verified in source |
| In-app purchases | None sold. `in_app_purchase` is present for a billing probe shown in test builds only (`plusProbeTitle`); `BILLING` comes with it | **not verified** that the probe is absent from the release build |

## Data safety form

| Console question | Answer | Why |
|---|---|---|
| Does your app collect or share any of the required user data types? | **Yes** | Cloud boost transmits data off the phone when she agrees. Google counts data an SDK sends as collected (Play help 10787469) |
| Is all of the user data collected by your app encrypted in transit? | **Yes** | Firebase states it encrypts this data in transit using HTTPS ([Firebase data disclosure](https://firebase.google.com/docs/android/play-data-disclosure)) |
| Do you provide a way for users to request that data be deleted? | **Yes** | Settings: Delete everything on this phone (local data). Cloud boost content at Google is deleted by Google after up to 55 days and carries no identifier femio could match. Add the privacy-policy deletion route when the form asks for a URL |
| Health and fitness → **Health info** | Collected **Yes**; shared **No** (Google acts as a service provider under femio's instructions, an exemption in Play help 10787469); processed ephemerally **No** (up to 55 days); collection **optional** (she chooses); purposes **App functionality** and **Personalization** | The four bands, and any health question she approves |
| App activity → **Other user-generated content** | Same flags as above | The approved question text |
| Device or other IDs | **Recommended since 2026-11-27: tick it** (collected; not shared; purpose **Analytics**, Google's diagnostics). Why: Google's ML Kit disclosure page (https://developers.google.com/ml-kit/android-data-disclosure, read 2026-11-27) says its GenAI features collect user, device or other identifiers and per-installation identifiers for diagnostics and usage analytics, and Gemini Nano runs through ML Kit GenAI (`firebase-ai-ondevice`). Google says SDK collection counts as the app's (Play help 10787469), and the app's own privacy screen now says this identifier may be sent. Under-declaring is the risk. The phone traffic check (owner #33) can still show it is not sent; until then declare. Earlier answer, kept for the record: **Leave unticked.** Release bundle 2026-11-25: the merged manifest registers no `FirebaseInstallationsRegistrar` and `classes.dex` holds no `com/google/firebase/installations` class, so no installation ID is created. Registered Firebase components: common, AI, AI on-device, App Check (+ Play Integrity), ML Kit common. Google's `datatransport` classes are present but no transport registrar is; whether ML Kit sends usage metrics is **not verified** until the phone traffic check (owner #33). Earlier note: **Not verified.** femio sends no advertising ID and no ID of its own. Firebase's disclosure page says App Check sends a Play Integrity token and a user agent with device metadata "never linked to a user or device identifier", and that the Firebase installations SDK creates a per-installation ID. ADR-080 records "no Firebase installation ID". Confirm with the release dependency tree (`gradlew :app:dependencies`, search for `firebase-installations`) and, if present, declare **Device or other IDs** (optional, app functionality, not shared) | open |
| App info and performance → **Diagnostics** and **Other app performance data** | **Recommended since 2026-11-27: tick both** (collected; not shared; purpose **Analytics**). Same source: ML Kit sends device and app details, errors, speed and request size whenever the on-phone AI runs (in-app text `leaveModelBody`) | not verified on a phone (owner #33) |
| Approximate location (IP address) | **Not verified.** femio derives no location. Her IP address reaches Google as in any connection. Play's form does not list IP address as a type; decide on the day, conservatively, with the privacy lawyer already booked (owner actions 29 to 36) | open |
| Independent security review | **No** | None done |
| Privacy policy URL | `https://femioapp.com/en/privacy` | Also linked on the Cloud boost screen (`boostReadNotice`). The policy (privacy v3, 27 Nov) names Google Play for installs, updates, ratings and payments, the record's contents, the birth-year purpose, lock-screen reminder text, sharing and CSV export, and the `NEXT_LOCALE` cookie. Live only after the website deploy **(not verified on the live site)** |

Validity: true while the tripwire holds and Cloud boost sends only a `CloudPrompt`. The data practices of the release differ from the 24 November text in two ways: the Play rating and update prompts were added (they send nothing from femio), and the on-phone AI's Google telemetry is now declared rather than left open.

## Health apps declaration

Select the features femio really has (under-declaring is the risk). The names below are from the earlier file; the help page for the form (answer 16679511) does not list the options, so **the exact option names are not verified**: read them in the Console on the day.
- Health and fitness → **Period tracking**
- Medical → **Reproductive and sexual health** (fertile window, contraction timer, baby-movement log) and **Medical reference and education** (the Learn library)
- Do **not** select Medical device apps, Clinical decision support, or Disease prevention. Intended use is wellness, education and tracking (`01_PRODUCT_SCOPE.md` rule 1). The assistant answers only from the bundled trusted-source registry with citations, and rules (red flags, contraception refusal) run before any model.
- Do **not** use "My app doesn't provide any health features".
- No Health Connect access (`pubspec.yaml` and manifest carry none).

## The disclaimer Google requires (already in all four full descriptions)

Google's required wording: the app is "not a medical device and does not diagnose, treat, cure, or prevent any medical condition", with a reminder to consult a healthcare professional ([Health apps policy page](https://support.google.com/googleplay/android-developer/answer/16679511)).

EN: "femio is for education and tracking. It is not a medical device and does not diagnose, treat, cure or prevent any medical condition. Predictions are estimates, not guarantees, and are not a method of birth control. Always talk to your doctor or midwife about your health."

The Google sentence contains words the claims guard bans on purpose; it lives only in the store files, never in the app or web catalogs.

## Target audience, content rating, ads, access

| Item | Answer |
|---|---|
| Target age group | **18 and over only**; tick "restrict minor access". The first run asks "Has your 18th birthday passed?" (`eighteenTitle`) |
| Appeals to children | No |
| Ads | **No, does not contain ads** (ADR-080; `AD_ID` permission removed) |
| App access | All features available without sign-in; no credentials needed for review. Assistant features work without Cloud boost (rules and registry on the phone); Gemini Nano depends on the reviewer's device, so tell the reviewer in the access notes that the assistant has a built-in fallback |
| Content rating (IARC) | Answer literally: no violence, no gambling, no in-app purchases, no ads, no user-to-user content or chat, no location sharing. The sexual-content question is about reproductive-health education, not entertainment. Take whatever rating the questionnaire gives; do not steer it. Exact question wording **not verified** (Console, on the day) |
| Contains AI-generated content / generative AI | The assistant uses Gemini Nano on the phone and, optionally, Google's cloud model. Console may ask; answer yes and name the safeguards (citations, rules first, no writing to her record without confirmation). Form wording **not verified** |
| Government / news / financial app | No |
| Category | Health & Fitness |
| Tags | Period tracker, Pregnancy, Fertility, Women's health, Health tracking (pick from Play's fixed list on the day) |

## Closed testing (personal developer account)

At least **12 testers opted in continuously for 14 days** before applying for production access; a tester who leaves and rejoins restarts the clock. Recruitment message and tester brief: `docs/33_REBUILD_V3/06_LAUNCH_GUIDE_A_TO_Z.md`. The figures come from the earlier file (Play help P9, read 2026-10-27); **re-read on the day**.
