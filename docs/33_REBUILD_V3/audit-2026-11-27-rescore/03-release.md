# 03 Release re-score (2026-11-27, HEAD 3a92a90 = origin/main)

Read-only. VERIFIED = I measured it today. NOT VERIFIED = needs a phone, a console or an account. LIVE SITE = femioapp.com fetched today. LOCAL CODE = repo and E:/femio-builds.

## 1. Score (same scale as 26 Nov)

- Launch readiness: 5 -> 6 / 10. The upload-signed bundle and APK now exist and the live site has an honest test-build card. Still no public repo, no APK link, no Play account evidence, no closed test.
- Hackathon deadline (30 Nov, 2 pm PT): 4 -> 6 / 10. Rises to 8-9 once the repo and release exist (about 30 min of owner work, RELEASE_STEPS A and B).
- Play production: 3 -> 3 / 10. The 14-day clock has not started.

## 2. Old findings

| ID | Status | Evidence |
|---|---|---|
| REL-1 no public installable artifact | OPEN (tooling done) | `gh repo view KhaledHassanein/femio-app` = "Could not resolve to a Repository" (LOCAL). `export-public-app.mjs` and `docs/hackathon/RELEASE_STEPS.md` A/B exist and were not run. `E:/femio-hackathon.apk` absent. Devpost line 75 now holds a future release URL, line 89 still has `<APK link>`. |
| REL-2 live "Get the app" is Coming soon | PARTLY FIXED | LIVE: `/en/app` now shows an "Early test build (APK)" card with "Download link coming soon" and no button. `site.ts:26` `APK_DOWNLOAD_URL = null`, `site.ts:15` `PLAY_STORE_URL = null`. Honest, but still nothing to install. |
| REL-3 testing steps omit sideload | FIXED (text) | Devpost line 89 has the install, unknown-apps and Play Protect steps; RELEASE_STEPS B5 release notes carry them. Not tested on a judge's phone. |
| REL-4 closed test not started, no account | OPEN | PROGRESS R14.15 "Left for the owner: upload .aab to closed test (rows 1, 6)". OWNER_ACTIONS rows 1 and 6 open. Account NOT VERIFIED. Earliest production slides to about 2026-12-18 or later. |
| REL-5 no upload-signed bundle | FIXED | `apksigner verify --print-certs` on `E:/femio-builds/femio-1.0.0-test.apk`: signer DN `CN=Khaled Hassanein, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=EG` (no longer Android Debug). `jarsigner -verify` on `femio-1.0.0.aab`: "jar verified", same DN. Badging: com.femioapp.femio, versionCode 1, 1.0.0, minSdk 26, targetSdk 36. APK 66,501,488 B and .aab 65,694,942 B, both 2026-11-27 02:58, after the last app commit (f909e19, 02:48). Whether it equals the key in Play is NOT VERIFIED. |
| REL-6 keystore docs stale | PARTLY FIXED | Row 2 now says "Probably done; please confirm". Backup copy of the .jks still unconfirmed (owner). Gradle now fails a release build without key.properties unless `-P allowDebugSigning=true` (`build.gradle.kts:21-34`). |
| REL-7 Data safety Device IDs / ML Kit | PARTLY FIXED | PROGRESS R14.15: doc now recommends declaring Device or other IDs and diagnostics (conservative). Console entry and row 33 traffic capture NOT VERIFIED. R14.14 still `[~]`. |
| REL-8 live privacy text vs doc | NOT VERIFIED | `/en/privacy` returns 200; I did not re-read its text against the doc. |
| REL-9 stale Data safety doc | PARTLY FIXED | Doc refreshed per PROGRESS and diff touches docs/store; I did not re-diff it against pubspec. |
| REL-10 ALL CAPS headers | PARTLY FIXED | PROGRESS says headers are sentence case; `git diff fb45488..3a92a90 --stat -- docs/store` shows the listings changed. My grep of the listing files for the old capital headers returned nothing. Console acceptance NOT VERIFIED. |
| REL-11 FR/ES screenshots | OPEN | `docs/store/screenshots/` still has only `ar` and `en`. Low impact. |
| REL-12 beta ondevice lib, thin keep rules | PARTLY FIXED | PROGRESS: R8 keep rules added, `pnpm mobile-release-smoke` (package.json:11, script exists) green on an API 36 emulator, first frame 5.6 s, no crash. I did not re-run it. Say it, Ask femio and Cloud boost on a real phone: NOT VERIFIED (row 43, R14.1 `[ ]`). |
| REL-13 live site lag | FIXED | `git ls-remote origin main` = 3a92a905 = HEAD. PROGRESS R14.16 claims Vercel dpl READY. LIVE: /en, /en/app, /ar/app, /en/privacy, /robots.txt return 200 and /en/app carries the new R14.4 card, so the live site is at least as new as that commit. Exact deployed commit NOT VERIFIED. |

Counts for my role (13 findings): fixed 3 (REL-3, REL-5, REL-13), partly fixed 6 (REL-2, REL-6, REL-7, REL-9, REL-10, REL-12), open 3 (REL-1, REL-4, REL-11), not verified 1 (REL-8).

## 3. New findings

- REL-N2-1 (P0 hackathon, BUILDABLE once the owner says "go"): the signed APK sits on the PC only. Nothing in `gh` shows a repo or release. The Devpost "Try it out" line already points at GitHub URLs that return 404 today, so the submission text is ahead of reality. Do RELEASE_STEPS A then B before pasting links.
- REL-N2-2 (P1 hackathon, OWNER-ONLY): sideloaded Cloud boost needs the Firebase console steps in RELEASE_STEPS section C (add the upload key SHA-256, set Play Integrity to the "outside Google Play" verdict row, then test on a second phone). RELEASE_STEPS itself says the console labels and the outcome are "not verified". If skipped, judges get the rules-only fallback, which the text already describes.
- REL-N2-3 (P2, BUILDABLE): the Devpost line 89 still has the literal `<APK link>` placeholder; the page `/en/app` has no button until `APK_DOWNLOAD_URL` is set and the site redeployed (a second deploy, owner's word).
- REL-N2-4 (P2, NOT VERIFIED): the release smoke ran on an emulator only; the real-device run (R14.1, row 43) is still open and gates the claim "hybrid AI works".

## 4. Biggest remaining gaps

1. Public repo plus GitHub Release plus APK link, then set `APK_DOWNLOAD_URL`, redeploy, fill Devpost. OWNER-ONLY to approve (publishing, `gh repo create`); the commands and the signed APK are ready. Needed before 30 Nov.
2. Real-phone proof run and App Check console settings (rows 43, 25, 42, RELEASE_STEPS C). OWNER-ONLY (phone and Firebase console). Without it, Cloud boost for judges is unproven.
3. Play Console account, closed test with 12 testers for 14 days (rows 1, 6, then upload the signed .aab). OWNER-ONLY (identity, people, calendar). Production cannot happen before about mid to late December.

Not checked: Play Console state, GitHub CI on Linux runners, any live AI call, installing the APK on a phone.
