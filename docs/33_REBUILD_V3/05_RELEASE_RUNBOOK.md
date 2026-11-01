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
crash, ads or database package, or if the release manifest asks for `INTERNET`. That is the
technical half of the Play Data safety answer "no data collected"; do not weaken it.

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

Bump `version:` in `apps/mobile/pubspec.yaml` (`0.5.1+6` → name+code; the code must rise every
upload). Then:

```bash
cd apps/mobile
flutter build appbundle --release --dart-define-from-file=ads.env   # Play wants an .aab: build/app/outputs/bundle/release/app-release.aab
flutter build apk --release --dart-define-from-file=ads.env         # for the owner's phone and testers outside Play
# ads.env (git-ignored, copy of ads.env.example) holds the AdMob app id and the two banner unit
# ids (ADR-076). Without the file, or without the --dart-define-from-file flag, the build shows
# Google's TEST ads: harmless on a phone, wrong on Play.
```

`isMinifyEnabled` and resource shrinking are on for release; if a plugin breaks under R8, add a
keep rule to `android/app/proguard-rules.pro` with the reason.

**Then, before the APK or bundle goes anywhere, run the release smoke test** with an emulator
booted (Android Studio → Device Manager, or `emulator -avd Medium_Phone_API_36.1`):

```bash
pnpm mobile-release-smoke     # installs the release APK clean, launches it, fails on any crash
```

Why: R8 only runs in release builds, so `flutter test` and debug runs cannot see what it removes.
0.5.0+5 passed every test and died at launch on the owner's phone (R4.15, 2026-11-01).

## 4 · What to check on a real phone before uploading

1. Fresh install → onboarding in Arabic → first prediction → the "Private by design" notice.
2. Settings → set a PIN → kill the app → reopen: lock screen; wrong PIN refused; right PIN opens.
3. Settings → save a backup → pick a folder → file `femio-backup-<date>.femio` exists.
4. Settings → delete everything → confirm → onboarding again → restore from the backup with the
   passphrase → the record is back.
5. Airplane mode throughout: nothing changes (there is no network path).
6. Both themes, Arabic and English, a 2.5-year-old phone if available.

## 5 · Upload

Play Console → Testing → Closed testing → create a track "femio closed" → upload the `.aab` →
release notes (EN + AR, two lines) → add the testers' Google emails or a Google Group → start.
The Data safety form, Health apps declaration, content rating and store listing must be filled
before the first upload is accepted; the paste-ready texts and answers are in `docs/store/`
(reasoning in `03_LEGAL_PACK.md` §4 and `04_GROWTH_PACK.md` §4).

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
