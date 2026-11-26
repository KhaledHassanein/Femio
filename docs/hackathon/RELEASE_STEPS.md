# Public repo and GitHub Release: owner steps (R14.3, R14.4)

Agent doc, also mirrored in `OWNER_GUIDE.html` sections 10 and 11. Written 2026-11-27. Nothing here
has been run against GitHub yet: the export and its tests were run locally (PROGRESS R14.3).
Run every command in Git Bash. `E:\Femio` is the main checkout; use the commit you will submit.
Deadline: 30 Nov 2026, 2:00 PM PT (midnight Cairo, 1 Dec). Commits pushed after it are not judged.

## A · Make the repository public (about 10 minutes)

1. Export the app from the final commit into an empty folder outside the monorepo:
   ```sh
   cd /e/Femio
   git log --oneline -1                       # the commit you are publishing
   node scripts/hackathon/export-public-app.mjs /e/femio-app-public
   ```
   It must end with `secret scan clean`. If it says `refusing`, stop and paste the output to a session.
   Only committed files are exported: `assistant.env` and `key.properties` cannot be included.
2. Check the export the way CI will:
   ```sh
   cd /e/femio-app-public
   node scripts/secret-scan.mjs . && node scripts/privacy-tripwire.mjs
   cd apps/mobile && flutter pub get && flutter analyze && flutter test && cd ../..
   ```
   Expect `No issues found!` and `All tests passed!` (screenshot tests show as skipped).
3. Make it a git repository and commit, staging by name:
   ```sh
   git init -b main
   git add README.md LICENSE HISTORY.md .github scripts apps fixtures
   git ls-files | grep -E "assistant\.env$|key\.properties$|local\.properties$|Generated\.xcconfig$|\.dart_tool/" \
     && echo "STOP: a local file is staged" || echo "clean: only exported files staged"
   git commit -m "femio app: public export for #BuildHybridAI"
   ```
4. Create the public repository and push in one step (the licence comes from the `LICENSE` file):
   ```sh
   gh repo create KhaledHassanein/femio-app --public --source . --remote origin --push \
     --description "femio: private women's health app with hybrid AI (Gemini Nano on the phone, opt-in Cloud boost) via Firebase AI Logic" \
     --homepage https://femioapp.com
   gh repo edit KhaledHassanein/femio-app --add-topic firebase-ai-logic,gemini-nano,hybrid-ai,flutter,android,womens-health
   ```
5. Check it is public, licensed and green:
   ```sh
   gh repo view KhaledHassanein/femio-app --json visibility,licenseInfo --jq '.visibility, .licenseInfo.name'
   gh run watch -R KhaledHassanein/femio-app $(gh run list -R KhaledHassanein/femio-app --limit 1 --json databaseId --jq '.[0].databaseId')
   ```
   Expect `PUBLIC`, `Apache License 2.0`, and both CI jobs passing. Open
   https://github.com/KhaledHassanein/femio-app in a private window: "Apache-2.0 license" shows in
   About, and there is no `assistant.env`.
6. To update it before the deadline: export again into a new empty folder, copy its files over the
   repository folder (keep `.git`), then `git add` by name, commit and `git push`.

## B · GitHub Release with the APK (about 20 minutes)

1. Build the release APK in the checkout that has both git-ignored files,
   `apps/mobile/assistant.env` and `apps/mobile/android/key.properties` (copy `assistant.env` in if
   needed; never `git add` it). Build after both files exist:
   ```sh
   cd /e/Femio/apps/mobile
   flutter clean && flutter build apk --release
   ```
2. Check it is signed with your upload key, not the debug key:
   ```sh
   "$LOCALAPPDATA/Android/Sdk/build-tools/$(ls "$LOCALAPPDATA/Android/Sdk/build-tools" | tail -1)/apksigner.bat" \
     verify --print-certs build/app/outputs/flutter-apk/app-release.apk | grep "certificate DN"
   ```
   It must **not** say `CN=Android Debug`. If it does, `key.properties` was not found; fix that first.
3. Re-run the tripwire so it reads the freshly merged manifest (SEC-16):
   `cd /e/Femio && node scripts/analytics-lint.mjs`.
4. Install it on a phone that did not build it, open the app, run Ask femio once; then name it:
   ```sh
   cp apps/mobile/build/app/outputs/flutter-apk/app-release.apk /e/femio-hackathon.apk
   sha256sum /e/femio-hackathon.apk
   ```
5. Create the release on the public repository (paste the SHA-256 from step 4 into the notes):
   ```sh
   gh release create v1.0.0-hackathon /e/femio-hackathon.apk -R KhaledHassanein/femio-app \
     --title "femio 1.0.0 for #BuildHybridAI" \
     --notes "Android 8.0 or later, 64-bit. Install: allow your browser to install unknown apps, open the APK, and if Play Protect warns, choose More details, then Install anyway. SHA-256: <paste>. Cloud boost uses Firebase App Check with Play Integrity; on an APK installed outside Google Play it is expected to be refused, and Ask femio then shows its sources word for word."
   ```
6. Copy these two links into `DEVPOST_SUBMISSION.md` ("Try it out") and the Devpost form:
   - release page: https://github.com/KhaledHassanein/femio-app/releases/tag/v1.0.0-hackathon
   - direct download: https://github.com/KhaledHassanein/femio-app/releases/download/v1.0.0-hackathon/femio-hackathon.apk

## Not verified

- That the release APK's Cloud boost is refused when sideloaded (Play Integrity), and what the
  screen says then. Check it on a second phone in step B4.
- That the CI workflow passes on GitHub's Linux runners; it passed locally on Windows only.
