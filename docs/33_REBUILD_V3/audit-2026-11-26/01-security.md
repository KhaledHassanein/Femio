# 01 · Security review (judge's view), 2026-11-26

Read-only audit of commit `fb45488` (branch `claude/judge-audit-bd6d27`) plus the live site
https://femioapp.com, which was deployed from an older `main`. Reviewer stance: a #BuildHybridAI judge
with a security background. Nothing in the repository was changed except this file.

**Not run:** `flutter test`, `flutter build`, `pnpm install` and any app on a phone (another process
held the test suite). So every statement about runtime behaviour on a phone is **NOT VERIFIED** unless
the evidence column says otherwise. Statements labelled VERIFIED were checked by reading the cited
code or by running the cited command.

## Score: 7 / 10

The privacy design is well above hackathon level and mostly enforced in code, not only in prose.
- The record, documents and AI ledger are sealed with AES-256-GCM under a random key kept in
  Keystore-backed secure storage.
- Google backup and device transfer are excluded.
- Notifications are neutral and `VISIBILITY_PRIVATE`.
- The cloud path accepts only a `CloudPrompt`, which only two typed factories can build, and a lint
  tripwire guards it.
- Consent is a dated, versioned receipt, and every AI call is written to an on-phone ledger.
- The website ships a tight CSP and full security headers, live as well as in code.

It loses points on the things a security judge tests in the first five minutes:
- The app sets no `FLAG_SECURE`, so the recent-apps view shows her record.
- The PIN allows unlimited guesses, and it only gates the screen: it does not protect the encryption key.
- The backup passphrase is protected by PBKDF2 at 120k rounds, a fifth of OWASP's current floor,
  and the minimum passphrase is 6 characters.
- Nobody has captured the network traffic to prove that "on-device" calls and plain app use send
  nothing. Firebase and App Check start as soon as the assistant status is read.
- The public-repo exporter copies the working tree, not git, and its README describes an AI design
  (`ONLY_IN_CLOUD` plus Google Search grounding) that ADR-079 removed.

There is no P0: none of these is an exploitable remote data exposure, and none blocks submission.

## Findings

Severity: **P0** blocks the hackathon submission or is an exploitable data exposure; **P1** fix before
the Play release (or before the public export, where noted); **P2** polish.

| ID | Sev | Finding | Evidence | Status | Where | Recommended fix | Owner? |
|---|---|---|---|---|---|---|---|
| SEC-1 | P1 | **No `FLAG_SECURE`.** The Android recent-apps thumbnail and screenshots or screen recording capture her record (cycle, pregnancy, documents, Ask femio text). The 60-second relock does not help, because the snapshot is taken as she leaves the app. | `grep -rn FLAG_SECURE apps/mobile/android/app/src/main/kotlin lib` returns nothing; `MainActivity.kt:15-49` sets no window flags; no secure-screen plugin in `pubspec.yaml` dependencies. | VERIFIED (absence in code) | LOCAL CODE | Set `window.setFlags(FLAG_SECURE)` in `MainActivity.onCreate`, or at least `setRecentsScreenshotEnabled(false)` (API 33+) plus a privacy cover on `AppLifecycleState.inactive`. Make it a Settings switch, default on, if she needs screenshots for her doctor. | |
| SEC-2 | P1 | **Unlimited PIN attempts, no backoff.** A 4-digit PIN (10,000 values, about 0.25 s per check) can be tried by hand or by an accessibility or ADB tapper with no lockout. | `lib/features/lock/lock_screen.dart:30-37` (`_submit` only toggles `_wrong`); `lib/app.dart:438` `unlock()` has no counter; `lib/data/app_lock.dart:22-23` sets PIN length 4 to 8. | VERIFIED (code read) | LOCAL CODE | Count failures in the vault and apply an escalating delay (for example 30 s after 5 failures, doubling after that). Optionally offer biometric unlock (no biometric code exists today). | |
| SEC-3 | P1 | **The PIN gates the UI, not the data.** The record key (`record-key-v1`) is read from the vault without the PIN, so anyone who can run code as the app (rooted phone, ADB backup is excluded, forensic image of an unlocked phone) decrypts without knowing the PIN. This is acceptable for a v1 lock, but the copy must not imply that the PIN encrypts. | `lib/data/store.dart:55-62` (`recordKey` takes only the vault); `lib/data/app_lock.dart:39-56` (PIN hash stored separately and never used in key derivation). | VERIFIED (code read) | LOCAL CODE | Either document it honestly ("the PIN hides the app; encryption uses the phone's keystore") or wrap the record key with a key that requires user authentication (`setUserAuthenticationRequired`, BiometricPrompt or device credential). | |
| SEC-4 | P1 | **Backup KDF is weak for a file that travels.** The KDF is PBKDF2-HMAC-SHA256 at 120,000 rounds with a 6-character minimum passphrase. OWASP's current floor is 600,000 rounds, or Argon2id at m=19 MiB, t=2, p=1 (Password Storage Cheat Sheet, fetched 2026-11-26). A leaked backup (Drive, WhatsApp, email) protected by a 6-letter passphrase is within reach of offline GPU cracking. The exact speed was not benchmarked here [NEEDS SOURCE for a cracking-rate figure]. | `lib/data/crypto/envelope.dart:35` (`backupIterations = 120000`), `:81-85` (PBKDF2); `lib/data/backup.dart:20` (`minPassphraseLength = 6`). | VERIFIED (code); risk size is an estimate | LOCAL CODE | Move new backups to Argon2id (the `cryptography` package already ships `Argon2id`) behind a new magic (`FMB2`), keep reading `FMB1`, raise the minimum to 10 or more characters or 4 words, and add a strength hint. | |
| SEC-5 | P1 | **Privacy claim not proven on the wire.** The code keeps her text on the phone by type (`ONLY_ON_DEVICE`), but nobody has captured traffic to show what Firebase, App Check and Play Integrity send. `status()` calls `firebase()`, which initialises a `FirebaseApp` and installs App Check whenever the assistant status is read, before and without Cloud boost consent. Whether that triggers App Check or Play Integrity token fetches, Firebase heartbeat or installations traffic is **unknown**. The `source == ON_DEVICE` check on private replies runs *after* the call, so it could not stop a send. | `FemioAssistant.kt:93-105` (status → `firebase()`), `:149-162` (init and `AppCheckInstaller.install`), `:117-121` (private uses `ONLY_ON_DEVICE`); `lib/data/assistant_channel.dart:97-105` (post-hoc source check). | NOT VERIFIED (hypothesis about SDK behaviour) | LOCAL CODE | On a Nano phone and a non-Nano phone, run PCAPdroid or mitmproxy through: plain use, Ask femio on the phone, Say it, and Cloud boost on and off. Record the hosts contacted in `docs/compliance/`. If App Check fetches before consent, initialise Firebase lazily only inside `hybrid()`, and for `private` use a model path that does not need App Check. Mention any pre-consent contact in the privacy notice. | |
| SEC-6 | P1 (before export) | **The public exporter copies the working tree, not git.** Run from the main checkout it would publish untracked and ignored files that its skip list misses: `apps/mobile/android/hs_err_pid22940.log` (1.5 MB JVM crash log with `USERNAME`, `PATH`, `JAVA_HOME`, `TMP`), `ios/Flutter/Generated.xcconfig` and `flutter_export_environment.sh` (local paths), `.flutter-plugins-dependencies` (local paths), and `test/screenshots/` (92 images; synthetic, and git-ignored on purpose). The skip list does not cover `*.p12`, `*.pem` or service-account JSON. | `scripts/hackathon/export-public-app.mjs:28-44` (`readdirSync` walk, deny-list only); `git status --ignored --porcelain apps/mobile` in `E:\Femio` lists those files; `hs_err` env section checked by variable name only (values not printed). | VERIFIED (script read; files present); export not run | LOCAL CODE | Build the copy from `git ls-files apps/mobile fixtures/domain` (or `git archive HEAD`), keep the deny-list as a second check, and add `*.p12`, `*.pem`, `*.log` and `*service-account*.json`. Delete the `hs_err` log. | |
| SEC-7 | P1 (before export) | **The public README misstates the AI design.** It says the cloud path is `ONLY_IN_CLOUD` with Google Search grounding and a trusted-host list (WHO, NHS, CDC…). ADR-079 removed grounding; the code uses `PREFER_ON_DEVICE` with no tools and answers only from bundled public-domain passages. A judge who compares the README with `FemioAssistant.kt` will see a contradiction on the exact thing being judged. | `scripts/hackathon/export-public-app.mjs:63-77` against `FemioAssistant.kt:9-13,128-132` and `docs/DECISIONS.md` ADR-079 §1 to §3. | VERIFIED | LOCAL CODE | Rewrite the README table from ADR-079, ADR-080 and ADR-081: Nano `ONLY_ON_DEVICE` for anything from her record; Cloud boost `PREFER_ON_DEVICE`, opt-in, `CloudPrompt` only (approved general question with public passages, or four bands); no grounding; App Check. | |
| SEC-8 | P1 | **Firebase API key ships in the APK (expected), but no restriction is recorded.** `FEMIO_FIREBASE_API_KEY`, `FEMIO_FIREBASE_APP_ID` and `FEMIO_FIREBASE_PROJECT_ID` become `BuildConfig` string constants, readable from the dex. App Check enforcement is an owner action (#25), but I found no owner action that restricts the key to the Android package plus signing SHA-1 and to the Firebase AI Logic API. Whether enforcement is on today is unknown. | `apps/mobile/android/app/build.gradle.kts:22-31,71-74`; `docs/runbooks/OWNER_ACTIONS.md:17` (#25 App Check); `grep -i restrict OWNER_ACTIONS.md` finds nothing. | VERIFIED (code and docs); console state NOT VERIFIED | LOCAL CODE | Google Cloud console → APIs & Services → Credentials → the key: Android apps restriction (`com.femioapp.femio` with the Play app-signing SHA-1 and the upload SHA-1), API restriction to the Firebase AI Logic API and Firebase App Check. Confirm App Check is **enforced** for AI Logic. Keep the $10 budget alert. | OWNER |
| SEC-9 | P2 | **Release silently falls back to debug signing** when `key.properties` is missing. The file comment calls this intended, but a judge or tester can receive a debug-signed "release" APK that Play Integrity will not recognise (Cloud boost then fails) and that a Play build cannot upgrade. | `build.gradle.kts:9-17,83`. | VERIFIED | LOCAL CODE | Fail the release task when `hasReleaseKey` is false unless `-PallowDebugSigning=true` is passed. | |
| SEC-10 | P2 | **The example keystore path is not git-ignored.** `key.properties.example` points `storeFile=../upload-keystore.jks`, which resolves from `android/` to `apps/mobile/upload-keystore.jks`. `android/.gitignore` ignores `**/*.jks` only under `android/`, and the root `.gitignore` ignores `*.key` but not `*.jks`. The owner's real keystore is outside the repo (`storeFile=E:/_Private/...`; only that line was read), so there is no leak today. | `apps/mobile/android/key.properties.example:4`; `git check-ignore -v --no-index apps/mobile/upload-keystore.jks` returns rc=1 (not ignored). | VERIFIED | LOCAL CODE | Add `*.jks`, `*.keystore` and `key.properties` to the root `.gitignore`; change the example to an absolute path outside the repo. | |
| SEC-11 | P2 | **Import trusts a backup that opened.** (a) A file declaring up to 10,000,000 PBKDF2 rounds is accepted, which means minutes of CPU in pure Dart (a self-inflicted denial of service from a received file). (b) The picked file is read whole with no size cap before decryption. (c) Document ids inside the backup are checked only at write time. `importBackup` deletes her current documents first, so a crafted (passphrase-valid) file with one bad id throws an `ArgumentError` the UI does not catch. Her documents are then gone while the old record still points at them. | `envelope.dart:108-110`; `features/settings/backup_actions.dart:90`; `backup.dart:74-76`; `app.dart:476-481`; `attachment_store.dart:63`. | VERIFIED (code read); crash path not executed | LOCAL CODE | Cap iterations at about 2× the current value, cap file size (100 MB plus record), validate every document id and its size, and require each to be referenced by the restored record before `documents.clear()`. Restore into a staging folder and swap. | |
| SEC-12 | P2 | **The native bridge trusts Dart completely.** Kotlin `hybrid` runs any string with `PREFER_ON_DEVICE` and checks neither consent nor prompt shape. `CloudPrompt` and consent are enforced only in Dart plus a regex tripwire (the channel name as a literal). There is no native timeout, so after Dart's 20 s timeout a cloud call can still finish; the ledger keeps a receipt for that case. | `FemioAssistant.kt:74-90,128-132`; `scripts/analytics-lint.mjs:239-263`; `assistant_gateway.dart:30,105-117`. | VERIFIED | LOCAL CODE | Defence in depth: pass a `purpose` and the consent text version over the channel and refuse `hybrid` when a native flag, set only by the consent screen's own channel call, is off. Wrap `generateContent` in `withTimeout(20_000)` so the call is cancelled. | |
| SEC-13 | P2 | **Redaction is heuristic.** `toCloudSafe` blocks first-person words, digits, emails and URLs, but names, places, third-person details ("does Sarah Ahmed in Jeddah…") and spelled-out numbers pass. This is mitigated by her seeing and editing the exact outgoing text, and by the ledger. | `lib/domain/assistant/redaction.dart:29-80`; confirm step in `features/assistant/ask_screen.dart:131-140`. | VERIFIED (code read) | LOCAL CODE | Optionally have Nano (where present) or a simple capitalised-word check flag likely names before the confirm screen. State the limit in the consent text. | |
| SEC-14 | P2 | **Widget details ignore the app lock.** With "show details" on, the home-screen widget shows the pregnancy week or the next-period range even when a PIN is set, and keeps them in plain `SharedPreferences` outside the sealed record. The widget is `home_screen` only, not lock screen, and neutral by default. | `lib/app.dart:380-385` (`showDetails` reads only `widgetDetails`); `widget/FemioWidgetProvider.kt:28-40`; `res/xml/femio_widget_info.xml` (`widgetCategory="home_screen"`). | VERIFIED | LOCAL CODE | When `lockEnabled`, force the neutral content (or say so on the switch). | |
| SEC-15 | P2 | **Plain copies in cache.** A shared document stays as plaintext in `cache/shared/` until the next app start. Rendered-PDF temp files are deleted at once. | `files/FilesChannel.kt:97-115`. | VERIFIED | LOCAL CODE | Also clear `shared/` in `onResume` after the share sheet returns, or after about 10 minutes via WorkManager. | |
| SEC-16 | P2 | **The current merged manifest is unverified, and stale release artefacts exist.** `E:\Femio\apps\mobile\build` holds a 2 Nov `app-release.apk` and `.aab`, and a 29 Oct merged manifest that still has `AD_ID`, `ACCESS_ADSERVICES_AD_ID` and the AdMob components (pre-ADR-080). The tripwire's merged-manifest check (§4b) reads that stale file in the main checkout and skips the check entirely in this worktree. Which components Firebase AI, App Check and Play Integrity add at `fb45488` is unknown. | `ls -la` on those paths (dates Oct 29 and Nov 2); `grep` of the merged manifest lines 101-102 and 187-209; `scripts/analytics-lint.mjs:321-340`. | VERIFIED (stale files); current merge NOT VERIFIED | LOCAL CODE | Run `flutter clean`, build release once, re-run the tripwire, and attach the merged manifest to the evidence folder. Never hand judges an APK from that `build/` folder. | |
| SEC-17 | P2 | **Website: `'unsafe-inline'` in `script-src`; locale cookie without `Secure`; no HSTS preload.** All three are documented trade-offs. `NEXT_LOCALE` is functional (`SameSite=Lax`), and HSTS covers transport. `Access-Control-Allow-Origin: *` on static HTML is Vercel's default and harmless for public pages. | `curl -sI https://femioapp.com/en` (headers quoted in "What is good"); `apps/web/next.config.mjs:57-84,87-103`. | VERIFIED | LIVE SITE + LOCAL CODE | Leave as is for the hackathon; revisit nonces or hashes if Next supports static nonces. | |

### Facts, hypotheses, unknowns

- **Facts (checked):**
  - No real secret appears in tracked files or in git history for these patterns: `AIza…`, `BEGIN PRIVATE`, `BEGIN RSA`, `storePassword=`, `keyPassword=`, `sk-ant`, `ghp_`, `xoxb`, Supabase JWT, `sb_secret_`, `sk_live_`, `AKIA…`. The hits are placeholders (`CHANGE_ME`, `YOUR_PASSWORD`, `sb_secret_xxx…`) and a lint regex (commit `b88f2cc`).
  - No keystore, `key.properties`, `assistant.env` or `google-services.json` was ever added to git (`git log --all --diff-filter=A --name-only` is empty for those patterns).
  - `apps/mobile/assistant.env` and `android/key.properties` are git-ignored (`git check-ignore -v`: `.gitignore:14` and `apps/mobile/android/.gitignore:12`).
  - `assistant.env` does not exist in this worktree or in `E:\Femio`. A build from either checkout gets empty Firebase fields and reports "not configured" (`FemioAssistant.kt:151`), so every AI feature, Nano included, runs on rules (`private()` also needs `firebase()`).
- **Hypotheses (not checked):**
  - App Check or Play Integrity token traffic happens before Cloud boost consent (SEC-5).
  - Sideloaded judge APKs fail Play Integrity, so Cloud boost does not work for them. The owner noted this in OWNER_ACTIONS #25.
- **Unknowns:**
  - Whether App Check enforcement and API-key restrictions are on in the console (SEC-8).
  - Whether Gemini request logging and AI monitoring prompts are switched off (ADR-080 owner actions).
  - The merged manifest at `fb45488` (SEC-16).
  - Live Vercel Web Analytics: `https://femioapp.com/_vercel/insights/script.js` returns **404** and no insights script appears in the page HTML. Analytics looks not enabled on the live deploy. This is not a security issue; it is logged for the growth audit.

## What is good

- **Storage:**
  - AES-256-GCM with a fresh 96-bit nonce from `Random.secure()` on every seal.
  - Magic headers and an authenticated tag; a wrong key and tampering are refused the same way (`envelope.dart:52-78`).
  - An atomic temp-and-rename write with serialised saves.
  - An unreadable record is quarantined, never overwritten (`store.dart:95-110,127-140`).
  - Documents are sealed under the same key and named by random ids, with a path-traversal guard (`attachment_store.dart:59`).
  - The AI ledger is sealed under its own key.
  - "Delete everything" deletes the keys (crypto-shredding).
- **Backups:** the file is passphrase-sealed and self-describing, and the passphrase is never stored. Cloud consent does not survive a restore (`backup.dart:71-79`, ADR-080).
- **Platform:**
  - `allowBackup="false"`, plus `fullBackupContent` and `dataExtractionRules` that exclude every domain from cloud backup *and* device transfer (`AndroidManifest.xml:34-37`, `res/xml/*_rules.xml`).
  - Every component is non-exported except the launcher activity and the widget receiver. The FileProvider is not exported and is scoped to `cache/shared/`.
  - The ad-ID and ad-services permissions are removed with `tools:node="remove"`.
  - No cleartext configuration (targetSdk default blocks it).
- **Lock:**
  - The PIN is stored only as a salted PBKDF2 hash and compared in constant time.
  - The app locks on cold start (`app.dart:140-141`) and after 60 s in the background.
  - The lock is an overlay above *every* route, so pushed screens cannot sit on top of it (`app.dart:544-558`).
- **Notifications:** wordmark plus neutral body, `NotificationVisibility.private` (`reminder_scheduler.dart:60-73`).
- **AI boundary:**
  - Anything from her record runs `ONLY_ON_DEVICE`. Cloud boost is opt-in per purpose and receives only a `CloudPrompt` built from `CloudSafeText` or the four-band `PseudonymisedProfile`.
  - One gateway does the consent checks, a 20 s timeout, id-whitelisted parsing and a circuit breaker.
  - Kotlin errors return only an exception class name, never her text, and no `Log.*` or `print` of prompts exists (`grep` over `lib/` and the Kotlin tree finds only error `debugPrint`s in `app.dart` and `play_store.dart`).
  - Model output renders as plain `SelectableText`; links come only from the registry and open only over `https` (`FemioAssistant.kt:169-174`).
  - Registry passages are bundled, so the prompt-injection surface is her own text only.
- **App Check:** the debug provider exists only in the `debug` source set and the `debugImplementation` dependency; `profile` and `release` use Play Integrity (`src/{debug,profile,release}/kotlin/.../AppCheckInstaller.kt`).
- **Website (live = code):** `curl -sI https://femioapp.com/en` and `/en/calculators/due-date` both return:
  - a CSP with `default-src 'self'`, `connect-src 'self'`, `frame-ancestors 'none'`, `object-src 'none'`, `base-uri 'self'`, `form-action 'self'` and `upgrade-insecure-requests`;
  - `Strict-Transport-Security: max-age=63072000; includeSubDomains`;
  - `X-Frame-Options: DENY`, `X-Content-Type-Options: nosniff` and `Referrer-Policy: strict-origin-when-cross-origin`;
  - a `Permissions-Policy` that denies camera, microphone, geolocation, payment, usb and interest-cohort.

  No third-party `<script src>` appears on either page. AdSense hosts are absent from the live CSP, so ads are off. `http://` redirects to https with a 308.
