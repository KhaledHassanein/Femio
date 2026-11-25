# Google Play: Data safety, Health apps declaration, content rating — answers for the build on `main`

Source of the reasoning: `docs/33_REBUILD_V3/03_LEGAL_PACK.md` §4 (Google pages P1–P9 read 2026-10-27).
This file states the answers for the **actual build** and the evidence that makes them true.
Re-check the Console's wording on the day; Google changes the form.

## What the build does (evidence, ADR-080, 2026-11-24)

| Fact | Evidence |
|---|---|
| No ads, analytics, crash-reporting, attribution or tracking SDK | `pubspec.yaml`: no `google_mobile_ads`; `scripts/analytics-lint.mjs` fails on any ads/analytics/attribution package, on `lib/features/ads`, and on `AD_ID` / `ACCESS_ADSERVICES_*` in the source or merged manifest |
| Network: Firebase AI Logic only (Cloud boost) | `INTERNET` declared in `AndroidManifest.xml` for the Kotlin assistant; no HTTP client, socket or WebSocket under `lib/` (tripwire) |
| What Cloud boost sends, only with consent per purpose | A redacted general question she approves, with public passages; or four coarse bands (life stage, cycle regularity, symptom kinds, logging streak). Plus request metadata: IP address, App Check (Play Integrity) token, Firebase heartbeat header. No Firebase installation ID |
| Records encrypted at rest | AES-GCM sealed file, key in the Android Keystore |
| Backups | Passphrase-sealed file she saves herself; `allowBackup=false` and `dataExtractionRules` |
| Deletion | Settings → "Delete everything on this phone"; Cloud boost data at Google is deleted by Google within 55 days and carries no identifier femio could match |
| Permissions (merged debug manifest, 2026-11-24) | `INTERNET`, `ACCESS_NETWORK_STATE` (Firebase), `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE`, `BILLING`, `aicore BIND_SERVICE`; ad-ID permissions removed with `tools:node="remove"` |
| Accounts | None |

## Data safety form

| Console question | Answer | Why |
|---|---|---|
| Does your app collect or share any of the required user data types? | **Yes** | Cloud boost transmits data off the device when she agrees |
| Is all of the user data collected by your app encrypted in transit? | **Yes** | Firebase AI Logic uses TLS |
| Do you provide a way for users to request that their data is deleted? | **Yes** | Settings → Delete everything; Cloud boost data is deleted by Google within 55 days |
| Data types | **Health and fitness → Health info** (the four bands; questions about her health) and **App activity → Other user-generated content** (the approved question). For each: Collected **Yes**, Shared **No** (Google is a service provider processing for femio), Processed ephemerally **No** (Google keeps up to 55 days), **Optional** (she chooses), Purpose **App functionality** and **Personalization** (tips) | Google counts an SDK's transmission as collection; transfers to a service provider are not sharing (Play help 10787469) |
| Device or other IDs / Approximate location | **No** `[NEEDS CHECK on the day]`: femio derives no location and sends no device ID; confirm Google's guidance on App Check / Play Integrity tokens and IP addresses before submitting | |
| Independent security review | **No** | None done |
| Privacy policy URL | `https://femioapp.com/en/privacy` | Also linked on the Cloud boost screen |

Validity: true while the tripwire holds and Cloud boost sends only a `CloudPrompt`. Re-read Google's Data safety guidance for Firebase AI Logic and App Check before each submission.

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
| Ads | **No, does not contain ads** (ADR-080) |
| App access | All features available without sign-in (no credentials needed for review) |
| Content rating (IARC) | Answer literally: no violence, no gambling, no purchases yet (femio Plus comes later), **contains ads: no**, no user-generated content, no location sharing, no chat. The sexual-content question is about reproductive-health education, not entertainment. The resulting rating is whatever the questionnaire gives; do not steer it `[NEEDS CHECK on the day]` |
| Government / news / financial app | No |
| Category | Health & Fitness |
| Tags | Period tracker, Pregnancy, Fertility, Women's health, Health tracking (pick from Play's fixed list on the day) |

## Closed testing (personal developer account)

At least **12 testers opted in continuously for 14 days** before applying for production access; a tester who leaves and rejoins restarts the clock (P9). Recruitment message and tester brief: `docs/33_REBUILD_V3/06_LAUNCH_GUIDE_A_TO_Z.md`.
