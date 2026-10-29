# Google Play: Data safety, Health apps declaration, content rating — answers for the build on `main`

Source of the reasoning: `docs/33_REBUILD_V3/03_LEGAL_PACK.md` §4 (Google pages P1–P9 read 2026-10-27).
This file states the answers for the **actual build** and the evidence that makes them true.
Re-check the Console's wording on the day; Google changes the form.

## What the build does (evidence)

| Fact | Evidence |
|---|---|
| Network: the ads SDK only | `INTERNET` and `ACCESS_NETWORK_STATE` come from Google's ads SDK (`google_mobile_ads`, ADR-076); the app's own manifest asks for neither, and `scripts/analytics-lint.mjs` fails the gate if any code under `lib/` opens a connection (HTTP client, socket, WebSocket) or if the ads SDK is imported outside `lib/features/ads/` |
| No analytics, crash-reporting, attribution, mediation or database SDK | `pubspec.yaml` carries `google_mobile_ads` (ads on guide screens, non-personalised, no keywords, no events) and `in_app_purchase` (Play Billing); the privacy tripwire names the forbidden packages |
| What the ads SDK sends | Advertising ID, app-set ID, IP address, ad interactions, diagnostics, to Google, TLS-encrypted (Google's disclosure page for the SDK, read 2026-10-29). Never her records: the SDK receives no keywords, no content URL, no events |
| Records encrypted at rest | AES-GCM sealed file, key in the Android Keystore (`lib/data/crypto/envelope.dart`, `lib/data/key_vault.dart`) |
| Backups | A passphrase-sealed file she saves herself (`lib/data/backup.dart`); `allowBackup=false` and `dataExtractionRules` keep the record out of Google backup and device transfer |
| Deletion | Settings → "Delete everything on this phone" (no server copy exists) |
| Permissions requested | `POST_NOTIFICATIONS` (asked only when she turns a reminder on), `RECEIVE_BOOT_COMPLETED` (re-schedules reminders after a restart), `VIBRATE`; from the ads SDK: `INTERNET`, `ACCESS_NETWORK_STATE`, `AD_ID`, `ACCESS_ADSERVICES_AD_ID`, `WAKE_LOCK`, `FOREGROUND_SERVICE`; from Play Billing: `BILLING`. Topics and Attribution ad-services permissions are removed in the manifest. No exact-alarm permission: reminders are inexact. Full dump: `testing-results/2026-10-29-app-ads/` |
| Accounts | None. No sign-in anywhere |

## Data safety form

| Console question | Answer | Why |
|---|---|---|
| Does your app collect or share any of the required user data types? | **Yes** | Google's ads SDK transmits device identifiers and ad interactions; Google counts an SDK's transmission as collection. Her health entries are processed on the device only and are never given to the SDK |
| Is all of the user data collected by your app encrypted in transit? | **Yes** | The only transmission is the ads SDK's, which Google documents as TLS-encrypted |
| Do you provide a way for users to request that their data is deleted? | **Yes** | Settings → Delete everything. No account exists, so account-deletion rules do not apply |
| Data types | **Device or other IDs** (advertising ID, app-set ID) · **Location → Approximate location** (inferred from the IP address; Play requires inferred location to be disclosed) · **App activity → App interactions** · **App info and performance → Diagnostics**. For each: Collected **Yes**, Shared **Yes** (Google serves the ads for its own purposes), Processed ephemerally **No**, Required (not optional), Purposes: **Advertising or marketing**; for App interactions and Diagnostics also **Analytics** and **Fraud prevention, security and compliance** | Exactly what Google's disclosure page lists for the ads SDK. **Do not tick Health and fitness or Personal info**: her entries are never transmitted; the gate forbids any network code of our own |
| Independent security review | **No** | None done |
| Privacy policy URL | `https://femioapp.com/en/privacy` (Arabic: `/ar/privacy`) | Live web page, readable worldwide, also linked inside the app (Settings) |

Validity: these answers describe one SDK, Google's ads SDK, and nothing else. They stay true while the gate holds: no analytics, crash, attribution or mediation package, no network code under `lib/`, the SDK imported only under `lib/features/ads/`, and no personal permission in the merged manifest. Re-read Google's disclosure page for the SDK version in `pubspec.lock` before each submission; it changes.

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
| Ads | **Yes, contains ads** (Google AdMob banners on the guide screens only; non-personalised; femio Plus removes them) |
| App access | All features available without sign-in (no credentials needed for review) |
| Content rating (IARC) | Answer literally: no violence, no gambling, no purchases yet (femio Plus comes later), **contains ads: yes**, no user-generated content, no location sharing, no chat. The sexual-content question is about reproductive-health education, not entertainment. The resulting rating is whatever the questionnaire gives; do not steer it `[NEEDS CHECK on the day]` |
| Government / news / financial app | No |
| Category | Health & Fitness |
| Tags | Period tracker, Pregnancy, Fertility, Women's health, Health tracking (pick from Play's fixed list on the day) |

## Closed testing (personal developer account)

At least **12 testers opted in continuously for 14 days** before applying for production access; a tester who leaves and rejoins restarts the clock (P9). Recruitment message and tester brief: `docs/33_REBUILD_V3/06_LAUNCH_GUIDE_A_TO_Z.md`.
