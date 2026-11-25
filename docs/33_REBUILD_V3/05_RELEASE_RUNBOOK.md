# 05 — Release runbook (engineering): from a green gate to a signed App Bundle

For sessions and for Khaled when he builds himself. The owner-facing walk-through is
`06_LAUNCH_GUIDE_A_TO_Z.md`. Every command runs from the repo root unless it says otherwise.

## 1 · Before any build

```bash
git branch --list "wip/*"          # must be empty
pnpm gate                          # web: typecheck, lint, 500+ tests, every guard
cd apps/mobile && flutter analyze && flutter test && cd ../..
```

The privacy tripwire inside `pnpm gate` fails if `apps/mobile/pubspec.yaml` gains an analytics,
crash, ads or database package, if the app's own Dart code opens a connection, or if a model
call bypasses the assistant gateway (ADR-080, ADR-081). `INTERNET` is declared only for Firebase
AI Logic (Cloud boost, off by default) and App Check. That is the technical half of the Play Data
safety answers in `docs/store/data-safety-and-declarations.md`; do not weaken it.

## 2 · The upload keystore (once, owner only)

Run once on the owner's PC, outside the repository, and keep the file in two safe places
(a password manager attachment and an offline drive). Losing it means a new app listing.

```bash
keytool -genkey -v -keystore E:/_Private/femio-upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then copy `apps/mobile/android/key.properties.example` to `apps/mobile/android/key.properties`
(git-ignored) and fill in the path and passwords. With the file present the release build signs
with the upload key; without it, it signs with the debug key so a test APK still builds. Google
Play uses Play App Signing: the upload key signs what you send; Google re-signs for devices.

## 3 · Version and build

femio's first published release is **1.0.0 (build 1)** (owner 2026-11-25). Earlier numbers were
never uploaded. For every later upload raise the build number (`+2`, `+3`, ...) in
`apps/mobile/pubspec.yaml` and keep `appBuild` in `lib/domain/store_prompts.dart` equal (a test
checks); raise the name for user-visible releases (1.0.1 fixes, 1.1.0 features). The app has
no ads (ADR-080), so there is no `ads.env`. The live Firebase ids come from
`apps/mobile/assistant.env` (git-ignored); without it the build runs on rules only. Then:

```bash
cd apps/mobile
flutter build appbundle --release   # Play wants an .aab: build/app/outputs/bundle/release/app-release.aab
flutter build apk --release         # for the owner's phone and testers outside Play
```

Target API: Flutter 3.47 sets `targetSdk` 36 (Android 16), which Google Play requires of new
apps from 31 August 2026 (support.google.com/googleplay/android-developer/answer/11926878).
App Check: release builds use the Play Integrity provider (`src/release/.../AppCheckInstaller.kt`);
after the first upload, add the **App signing key** SHA-256 from Play Console → App integrity to
the Firebase app, then register Play Integrity in Firebase App Check.

`isMinifyEnabled` and resource shrinking are on for release; if a plugin breaks under R8, add a
keep rule to `android/app/proguard-rules.pro` with the reason.

## 4 · What to check on a real phone before uploading

1. Fresh install → onboarding in Arabic → first prediction → the "Private by design" notice.
2. Settings → set a PIN → kill the app → reopen: lock screen; wrong PIN refused; right PIN opens.
3. Settings → save a backup → pick a folder → file `femio-backup-<date>.femio` exists.
4. Settings → delete everything → confirm → onboarding again → restore from the backup with the
   passphrase → the record is back.
5. Airplane mode throughout: nothing changes (there is no network path).
6. Both themes, Arabic and English, a 2.5-year-old phone if available.

## 5 · Upload and testing tracks

Which tracks run together depends on the account type (Play Console Help, "App testing
requirements for new personal developer accounts", answer 14151465, read 2026-11-25):

- **Personal account created after 13 Nov 2023:** internal testing and closed testing run at
  the same time from day one. Open testing and production unlock only after a closed test with
  **12 testers opted in for 14 days in a row** and an approved production-access application
  (review usually seven days or less).
- **Organization account** (needs a D-U-N-S number): no 12-tester rule; internal, closed, open
  and production are all available at once.

Steps: Play Console → Test and release → Testing → Internal testing (owner's list) and Closed
testing (track "femio closed", a Google Group) → upload the same `.aab` to both → release notes
from `docs/store/release-notes-1.0.0.md` → start rollout. The Data safety form, Health apps
declaration, content rating, target audience and store listing must be filled before the
first upload is accepted; the paste-ready answers are in `docs/store/`. The owner-side click
path with tick boxes is the launch board (https://claude.ai/artifact/4BNRwtG7FspkAWsem7AwvB).

Production: staged rollout 20% → watch Android vitals and reviews 3 days → 100%. Set the
in-app update priority on each release (4–5 only for urgent fixes: the app then shows Play's
full-screen update, R12.3).

## 6 · After each tester round

Fix round in a session → gate → version bump → new bundle → same track. Testers get it
automatically. Keep `docs/33_REBUILD_V3/PROGRESS.md` R5.4 updated with the date the 14-day
window started: it restarts if the count drops below 12.

## 7 · Website

Vercel deploys `main`. After the branch merges: Vercel → Project → Settings → Environment
Variables must hold only `NEXT_PUBLIC_APP_URL`, `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION`
(optional) and `NEXT_PUBLIC_CRISIS_DIRECTORY_URL` (optional). Delete every Supabase, Sentry,
PostHog, CMS and VAPID variable; the build does not read them and a stray value is a liability.
Then `pnpm sitemap-check https://femioapp.com` and open `/ar/calculators/fertile-window` on a
phone.
