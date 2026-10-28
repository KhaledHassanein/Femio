# Google Play: Data safety, Health apps declaration, content rating — answers for the build on `main`

Source of the reasoning: `docs/33_REBUILD_V3/03_LEGAL_PACK.md` §4 (Google pages P1–P9 read 2026-10-27).
This file states the answers for the **actual build** and the evidence that makes them true.
Re-check the Console's wording on the day; Google changes the form.

## What the build does (evidence)

| Fact | Evidence |
|---|---|
| No network permission | `apps/mobile/android/app/src/main/AndroidManifest.xml` has no `INTERNET`; `scripts/analytics-lint.mjs` fails the gate if it appears |
| No analytics, crash-reporting, ads or database SDK | `pubspec.yaml` dependencies: `cryptography`, `file_picker`, `flutter_local_notifications`, `flutter_secure_storage`, `intl`, `path_provider`, `timezone`; the privacy tripwire names the forbidden packages |
| Records encrypted at rest | AES-GCM sealed file, key in the Android Keystore (`lib/data/crypto/envelope.dart`, `lib/data/key_vault.dart`) |
| Backups | A passphrase-sealed file she saves herself (`lib/data/backup.dart`); `allowBackup=false` and `dataExtractionRules` keep the record out of Google backup and device transfer |
| Deletion | Settings → "Delete everything on this phone" (no server copy exists) |
| Permissions requested | `POST_NOTIFICATIONS` (asked only when she turns a reminder on), `RECEIVE_BOOT_COMPLETED` (re-schedules reminders after a restart). No exact-alarm permission: reminders are inexact |
| Accounts | None. No sign-in anywhere |

## Data safety form

| Console question | Answer | Why |
|---|---|---|
| Does your app collect or share any of the required user data types? | **No** | Nothing is transmitted off the device. Google's definition of "collect" is transmission off the device; on-device processing is out of scope |
| Is all of the user data collected by your app encrypted in transit? | Not applicable (nothing collected). If asked: no data is transmitted | — |
| Do you provide a way for users to request that their data is deleted? | **Yes** | Settings → Delete everything. No account exists, so account-deletion rules do not apply |
| Data types | **None selected** | Do not tick "Health info" because the app is about health; the question is about collection |
| Independent security review | **No** | None done |
| Privacy policy URL | `https://femioapp.com/en/privacy` (Arabic: `/ar/privacy`) | Live web page, readable worldwide, also linked inside the app (Settings) |

Validity: the "No" is true only while the release manifest has no `INTERNET` permission and no SDK that sends data. The gate enforces both.

## Health apps declaration

Select the features femio really has (under-declaring is the risk):
- Health and fitness → **Period tracking**
- Medical → **Reproductive and sexual health** (fertile window, contraction timer, baby-movement log) and **Medical reference and education** (the Learn library)
- Do **not** select Medical device apps, Clinical decision support, or Disease prevention. Intended use is wellness, education and tracking (`01_PRODUCT_SCOPE.md` rule 1).
- Do **not** use "My app doesn't provide any health features".

## The disclaimer Google requires (already in both full descriptions)

EN: "femio is for education and tracking. It is not a medical device and does not diagnose, treat, cure or prevent any medical condition. Predictions are estimates, not guarantees, and are not a method of birth control. Always talk to your doctor or midwife about your health."

The Google sentence contains words the claims guard bans on purpose; it lives only in the store files, never in the app or web catalogs.

## Target audience, content rating, ads, access

| Item | Answer |
|---|---|
| Target age group | **18 and over only**; tick "restrict minor access" |
| Appeals to children | No |
| Ads | No, the app contains no ads |
| App access | All features available without sign-in (no credentials needed for review) |
| Content rating (IARC) | Answer literally: no violence, no gambling, no purchases, no user-generated content, no location, no chat. The sexual-content question is about reproductive-health education, not entertainment. The resulting rating is whatever the questionnaire gives; do not steer it `[NEEDS CHECK on the day]` |
| Government / news / financial app | No |
| Category | Health & Fitness |
| Tags | Period tracker, Pregnancy, Fertility, Women's health, Health tracking (pick from Play's fixed list on the day) |

## Closed testing (personal developer account)

At least **12 testers opted in continuously for 14 days** before applying for production access; a tester who leaves and rejoins restarts the clock (P9). Recruitment message and tester brief: `docs/33_REBUILD_V3/06_LAUNCH_GUIDE_A_TO_Z.md`.
