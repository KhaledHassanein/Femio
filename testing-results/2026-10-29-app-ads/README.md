# App ads (R6.13, ADR-076) — release build evidence, 2026-10-29

**Question.** With Google's ads SDK (`google_mobile_ads` 9.2.0) in the app, what does the signed
release build ask the phone for, and does the privacy tripwire still hold?

**Answer (from the build, synthetic — no device yet).** The build carries exactly the permissions the
ads SDK and the billing library need, and nothing personal. Checked with `aapt2 dump permissions`
on `apps/mobile/build/app/outputs/flutter-apk/app-release.apk` (58.3 MB, built 10:50 with the test
ids from `ads.env.example`).

| Permission | Why it is there |
|---|---|
| `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE` | femio's reminders (unchanged) |
| `INTERNET`, `ACCESS_NETWORK_STATE` | the ads SDK fetches banners (ADR-076; previously removed for the billing spike, allowed again) |
| `com.google.android.gms.permission.AD_ID`, `ACCESS_ADSERVICES_AD_ID` | the advertising id the ads SDK may send (declared on Play as "Device or other IDs") |
| `com.android.vending.BILLING` | Play Billing (femio Plus, R6.9) |
| `WAKE_LOCK`, `FOREGROUND_SERVICE` | pulled in by the SDK's dependencies (WorkManager); no service of femio's own |
| `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | Android's own signature permission for in-app receivers |

**Removed on purpose** (`tools:node="remove"` in the source manifest): `ACCESS_ADSERVICES_TOPICS`
and `ACCESS_ADSERVICES_ATTRIBUTION`, so the SDK cannot use the Topics or Attribution APIs.
**Absent:** location, camera, microphone, contacts, phone state, SMS, call log, accounts,
Bluetooth, activity recognition (the tripwire fails the build if any appears).

Files: `aapt2-permissions.txt` (the dump), `tripwire.txt` (`node scripts/analytics-lint.mjs`
output, which read this build's merged release manifest).

**Not verified here (needs a phone or emulator):** the UMP consent form, a banner actually
rendering on the Learn index and an open guide, the label and layout at 390×844 in Arabic, and
Plus hiding the banner. Those are the owner's phone checks on the dashboard (phase 4 and 6).
