# 01 · Security re-score (judge's view), 2026-11-27

Independent, read-only re-score of commit `3a92a90` (`git log --oneline -1` →
`3a92a90 docs: R14.15 signed build evidence, R14.16 merged and deployed`) against the 26 Nov report
(`audit-2026-11-26/01-security.md`, commit `fb45488`). Same rubric, same 1-10 scale, same P0/P1/P2
severities. Nothing was changed except this file. Commit messages and PROGRESS were not taken as
evidence: every status below rests on code read at `3a92a90`, a command I ran, or the live site.

**What I ran:**
- `flutter test test/sec_hardening_test.dart test/r14_18_report_answer_test.dart test/r14_19_ports_test.dart test/cloud_consent_test.dart` → **47 tests, all passed** (synthetic fixtures).
- `node scripts/analytics-lint.mjs` → passes, with 7 "under review" warnings (see SEC-N2-3, SEC-N2-4).
- `node --test scripts/hackathon/public-export-secrets.test.mjs` → 0 failures.
- `apksigner verify --print-certs` and `aapt2 dump badging / xmltree` on `E:/femio-builds/femio-1.0.0-test.apk`; a string scan of the APK and `.aab` dex files (values never printed).
- `git check-ignore -v --no-index` for keystore paths; a secret-pattern scan of `git diff fb45488..3a92a90`.
- `curl -sI https://femioapp.com/en` and `curl -s https://femioapp.com/en/app`.

**Not run:** the full app suite, `flutter build`, the Gradle refuse-path, the public export, and
anything on a phone. Every runtime statement about a phone (FLAG_SECURE in recents, KDF speed,
widget, network traffic) is **NOT VERIFIED**.

## 1 · Score: 7 → 8 / 10

Most of the 26 Nov P1 and P2 items are fixed in code and covered by tests. The hand-written
PBKDF2 is correct and proven against published vectors and the package. The signed APK's merged
manifest is clean. It is not a 9, because three things still stand:
- the headline claim ("nothing leaves the phone unless she turns on Cloud boost") is still not
  proven on the wire;
- screen protection is off for everyone without a PIN;
- the PIN still does not protect the encryption key.

## 2 · Old findings, one by one

Status key: **fixed** · **partly fixed** · **open** · **not verified**.
Where: **LOCAL CODE** or **LIVE SITE** or **SIGNED BUILD** (the artefacts in `E:/femio-builds`).

| ID | Old sev | Status | Evidence (VERIFIED unless marked) | Where |
|---|---|---|---|---|
| SEC-1 No FLAG_SECURE | P1 | **partly fixed** | `MainActivity.kt:27-32` applies the flag before `super.onCreate` from a remembered boolean; `lock/SecureScreenChannel.kt:21-57` adds or clears `FLAG_SECURE` on the `femio/secure` channel; `data/app_lock.dart:81-101,154-159` turns it on with a PIN, off without one, and syncs it at start; `main.dart:28-29` passes the real `SecureKeyVault`, so the real channel is used. Test `sec_hardening_test.dart:225-241` passes. The signed APK and `.aab` contain the `femio/secure` and `femio_lock_state` strings. **Gap:** the flag follows the PIN (`secure_screen.dart:3-9`), so a woman with no PIN (the default) still has her record in the recents thumbnail and in screenshots. On-phone behaviour: NOT VERIFIED. | LOCAL CODE + SIGNED BUILD |
| SEC-2 Unlimited PIN tries | P1 | **fixed** (see SEC-N2-1) | `app_lock.dart:43-59`: 4 free misses, then a wait of 30 s on the 5th, doubling to a 30-min ceiling. The count and wait end are kept in the vault (`:117-124`), so a restart does not reset them. No check runs during a wait (`:108`). A clock set back is capped (`:139-142`). The lock screen disables the field while busy or waiting (`lock_screen.dart:116-123`). Settings uses the same `verify` (`app.dart:444`). Tests `sec_hardening_test.dart:167-223,243-262` pass. 10,000 PINs ≈ 208 days at the ceiling. | LOCAL CODE |
| SEC-3 PIN gates UI, not data | P1 | **partly fixed** | The honest-copy option is done: no app string says the PIN encrypts (`app_en.arb:464-491`), and the privacy page says the key is held by the Android Keystore (`apps/web/messages/en.json`). The code comment says so too (`app_lock.dart:13-14`). The technical fix is only proposed: ADR-084 is "proposed (not built)" (`docs/DECISIONS.md:1206-1240`). `store.dart` key handling is unchanged. | LOCAL CODE |
| SEC-4 Weak backup KDF | P1 | **fixed** | New backups use 600,000 rounds (`envelope.dart:39,109-114`) and record the count, and old 120k files still open at their own count (`:127-132`). New passphrases need 10 or more characters; opening keeps the old 6-character floor (`backup.dart:22,27,41`; `backup_actions.dart:26`). The KDF runs on a background isolate (`envelope.dart:100-104`) behind a modal "working" dialog. **PBKDF2 check:** `data/crypto/pbkdf2.dart` read in full. The HMAC pads are precomputed. Each later round is two compressions with fixed padding (`w[8]=0x80000000`, `w[15]=768` bits = 64+32 bytes). Long keys are hashed first. Multi-block output is correct, and every 32-bit sum is masked. The tests check it against 4 published vectors, including RFC 7914 §11 (64-byte output), and against the `cryptography` package on 24 random cases (Arabic, empty, 80- and 100-byte passwords, 1-3 output blocks); all pass. Argon2id was not adopted, but 600k meets OWASP's PBKDF2-SHA256 floor. Phone speed: NOT VERIFIED. | LOCAL CODE |
| SEC-5 Privacy claim not proven on the wire | P1 | **open** (claim NOT VERIFIED) | No traffic capture exists. `FemioAssistant.kt:102` `status()` still calls `firebase()` (`:158-160`). New evidence makes this more pressing: the signed APK ships `FirebaseInitProvider`, `MlKitInitProvider` and Google's `datatransport` telemetry services, and these start with the process, before any assistant use (SEC-N2-3). | LOCAL CODE + SIGNED BUILD |
| SEC-6 Exporter copies working tree | P1 | **fixed** (export not run by me) | `scripts/hackathon/export-public-app.mjs:10,59` builds from a `git archive HEAD` tar stream. A second deny-check, `public-export-secrets.mjs:28-37`, adds `.p12/.pfx`, `.pem/.key/.der/.p8`, service-account JSON, `*.log`/`hs_err_pid*` and the machine-specific Flutter files. Its tests pass. | LOCAL CODE |
| SEC-7 README misstates AI design | P1 | **fixed** | `public-template/README.md:15-30,61` now describes the private path as `ONLY_ON_DEVICE` and the Cloud boost path as `PREFER_ON_DEVICE`, and says "No Google Search grounding and no tools". | LOCAL CODE |
| SEC-8 API key unrestricted, App Check state unknown | P1 | **open** (OWNER) | App Check enforcement is decided "on" with the Play Integrity "outside Google Play" verdict row (`docs/hackathon/RELEASE_STEPS.md:83-115`). There is still no step to restrict the API key to the package plus signing SHA and to the AI Logic and App Check APIs (`grep -i restrict` finds nothing in RELEASE_STEPS or OWNER_ACTIONS). Console state: NOT VERIFIED. Note: relaxing `PLAY_RECOGNIZED` widens who can get App Check tokens until step 5 of §C restores it. Whether that matters without a key restriction is a hypothesis, NOT VERIFIED. | LOCAL CODE (docs) |
| SEC-9 Release falls back to debug signing | P2 | **fixed** (refuse path not run by me) | `build.gradle.kts:16-37`: a release task fails without `key.properties` unless `-P allowDebugSigning=true` or `FEMIO_ALLOW_DEBUG_SIGNING=1` is set. The regex covers `assemble/bundle/package/sign…Release`. The signed APK is signed by the owner's upload certificate (`apksigner`: SHA-256 `6671d6bd…dd0b01`, DN not "Android Debug"). | LOCAL CODE + SIGNED BUILD |
| SEC-10 Keystore path not git-ignored | P2 | **fixed** | Root `.gitignore:91-93` ignores `*.jks`, `*.keystore` and `key.properties`; `git check-ignore` matches `apps/mobile/upload-keystore.jks`. The example now uses an absolute path outside the repo (`key.properties.example:4-7`). | LOCAL CODE |
| SEC-11 Import trusts an opened backup | P2 | **partly fixed** | Done: the round count is capped (1,000 to 2,000,000) before any key work (`envelope.dart:41-49,130-131`); a file over 150 MB is refused before it is read (`backup.dart:32,83`; `backup_actions.dart:124-131`); every document's id, size, count and total is checked before `documents.clear()`, and documents the record does not describe are dropped (`backup.dart:97,112-132`). Tests `sec_hardening_test.dart:129-164` pass. **Left:** no staging-and-swap. `app.dart:493-499` still clears and then writes one document at a time (`record_documents.dart:142-149`). An I/O error part-way (for example a full phone) leaves her old documents deleted while the old record still points at them. `importBackupFlow` catches only `BackupError` (`backup_actions.dart:136-145`), so that error goes unhandled. | LOCAL CODE |
| SEC-12 Native bridge trusts Dart | P2 | **partly fixed** | Done: a native 20 s `withTimeout` on both model calls cancels a late cloud request (`FemioAssistant.kt:57-63,128,139`). **Left:** Kotlin `hybrid` still checks no consent flag or purpose. | LOCAL CODE |
| SEC-13 Heuristic redaction | P2 | **partly fixed** | The consent text now says only what the code does ("numbers, e-mail addresses and links removed", `app_en.arb:922,1296`), and `cloudConsentVersion` went from 1 to 2, so older consents lapse (`cloud_consent.dart:17-23`). No name or place check was added. She still sees and edits the outgoing text. | LOCAL CODE |
| SEC-14 Widget ignores app lock | P2 | **partly fixed** | While locked, the widget always draws the neutral line and the wordmark (`FemioWidgetProvider.kt:62-70`), and redraws when the lock changes (`SecureScreenChannel.kt:32-36`). **Left:** Dart still sends the detail string when "show details" is on (`app.dart:392-405`, no `lockEnabled` check), so the pregnancy week or period range still sits in plain app-private `SharedPreferences` while a PIN is set; it is just not drawn. On-phone: NOT VERIFIED. | LOCAL CODE |
| SEC-15 Plain copies in cache | P2 | **fixed** | Shared copies older than 10 minutes are deleted on every `onResume` and before each share (`MainActivity.kt:34-39`; `FilesChannel.kt:103,124-133,148-149`). Picker copies are cleared once read (`document_source.dart:32-42,104-106`; `backup_actions.dart:127`), and the camera's temp photo is deleted (`document_source.dart:45-52,120`). | LOCAL CODE |
| SEC-16 Merged manifest unverified, stale artefacts | P2 | **fixed** | The signed APK's own manifest, dumped with `aapt2`, has: `allowBackup=false`, `fullBackupContent` and `dataExtractionRules` set, no `AD_ID` or ad-services permission, not debuggable. Only three components are exported: the launcher activity, the widget receiver, and `ProfileInstallReceiver`, which is guarded by `android.permission.DUMP`. Permissions: INTERNET, RECEIVE_BOOT_COMPLETED, ACCESS_NETWORK_STATE, VIBRATE, POST_NOTIFICATIONS, AICore BIND_SERVICE, `com.android.vending.BILLING`, and the dynamic-receiver permission. The tripwire now reads Kotlin, Gradle and merged manifests (`scripts/lib/android-tripwire.mjs`) and passed on two merged manifests. | SIGNED BUILD + LOCAL CODE |
| SEC-17 Website CSP `unsafe-inline`, cookie, no preload | P2 | **open** (accepted trade-off, unchanged) | `curl -sI https://femioapp.com/en` returns the same CSP (`script-src 'self' 'unsafe-inline'`), HSTS `max-age=63072000; includeSubDomains`, `X-Frame-Options: DENY`, `nosniff`, Referrer-Policy and Permissions-Policy, and `Set-Cookie: NEXT_LOCALE=en; Path=/; SameSite=lax` (no `Secure`). | LIVE SITE |

**Totals:** 8 fixed (SEC-2, 4, 6, 7, 9, 10, 15, 16) · 6 partly fixed (SEC-1, 3, 11, 12, 13, 14) ·
3 open (SEC-5, 8, 17) · 0 whose status itself could not be checked. The runtime effect on a phone of
SEC-1, 2, 4 and 14 is NOT VERIFIED.

### Checks the brief asked for specifically

- **PBKDF2 correctness:** VERIFIED by reading the code and running its tests (SEC-4 row). Minor test
  gap: no salt is longer than 39 bytes, so the first-round path where salt+4 bytes needs two
  SHA-256 blocks is exercised only through long-key hashing, not through a long salt. Low risk; a
  salt of 56-120 bytes in the random test would close it.
- **App lock backoff:** VERIFIED in code and tests. Two weaknesses remain (SEC-N2-1).
- **FLAG_SECURE wiring:** VERIFIED from Dart through the channel and Kotlin to the cold-start
  preference, and present in both signed artefacts; it applies only while a PIN is set (SEC-1).
- **Backup import order:** VERIFIED. Validation happens before `documents.clear()`. The restore
  itself is not atomic (SEC-11).
- **Release signing guard:** VERIFIED in code; the signed APK carries the upload certificate.
- **R14.18 report sheet:** VERIFIED that it sends only `Reason`, `Made by` (the card's own label)
  and `s.text`. `s.text` is exactly the `SelectableText` she sees (`answer_card.dart:73,94`;
  `report_answer_sheet.dart:32-33,57-63`; `app_en.arb:752`). It goes through her share sheet,
  pre-addressed with `EXTRA_EMAIL` (`MainActivity.kt:52`), and nothing is sent without her own tap
  in her mail app. No question, record, device id or app version is attached. The test asserts
  that the question is absent (`r14_18_report_answer_test.dart:102-118`). It only appears on
  summaries, which are the only AI free text. See SEC-N2-5 for two wording and clipboard nits.
- **Help now on the lock (R14.19):** VERIFIED in code. It opens `HelpNowScreen`, which imports no
  controller or record (`help_now_screen.dart:14-24`). Back while locked never pops the routes
  under the lock (`app.dart:547-558`).
- **Secrets:** the diff since `fb45488` has no secret-shaped values; the 4 pattern hits are lint
  regexes, the 26 Nov report and a test fixture. No keystore, `key.properties`, `assistant.env` or
  `google-services.json` was added to git in the 41 new commits.

## 3 · New findings

| ID | Sev | Finding | Evidence | Status | Where | Recommended fix |
|---|---|---|---|---|---|---|
| SEC-N2-1 | P2 | **The PIN wait can be skipped by moving the clock forward, and a miss is counted only after the check.** `retryAfter` compares a wall-clock end time with `DateTime.now()`, so setting the phone's clock forward ends any wait at once; only setting it back is capped. Someone holding an unlocked phone (the threat the lock exists for) can keep guessing by changing the time. The miss is written after the PBKDF2 check and the result (`:112-124`), so killing the app in that gap would cost no miss (theoretical). | `app_lock.dart:107-150` | VERIFIED (code read); not exploited | LOCAL CODE | Write `failures+1` before deriving and clear it on success. Also keep a boot-relative timestamp (`SystemClock.elapsedRealtime` over the secure channel) and treat any forward jump larger than the elapsed real time as "the wait restarts". |
| SEC-N2-2 | P1 (cross-role: release) | **The signed `.aab` and APK in `E:/femio-builds` have no Firebase configuration.** No API-key-shaped string appears anywhere in the APK or in the `.aab` dex (0 hits), while the default model name (also a BuildConfig string) does appear. `apps/mobile/assistant.env` is absent from both checkouts. `FemioAssistant.kt:148,158-160` then returns "not configured", so every AI feature, **Gemini Nano included**, runs on rules in these builds. This is safe for security (nothing can go to the cloud), but the "release" artefacts cannot show hybrid AI to a judge. | dex string scan (counts only); `ls` for `assistant.env`; `FemioAssistant.kt:148-160` | VERIFIED (artefact scan); the runtime "not configured" state is inferred from code | SIGNED BUILD | The owner places `assistant.env` (OWNER-ONLY); then a session rebuilds the signed `.aab` and APK, re-runs the smoke test, and records "configured: yes" in the build evidence without printing values. |
| SEC-N2-3 | P2 | **Google SDK components start with the app, before any consent or assistant use.** The signed APK registers `FirebaseInitProvider`, `MlKitInitProvider` (both content providers, run at process start) and the `datatransport` CCT telemetry backend with its scheduler service and receiver. The tripwire only warns ("under review … settled by the traffic capture"). Whether these contact Google during plain use is **unknown**. This is the concrete form of SEC-5. | `aapt2 dump xmltree` of the APK; `node scripts/analytics-lint.mjs` warnings | VERIFIED (components present); traffic NOT VERIFIED | SIGNED BUILD | Capture traffic (SEC-5). If ML Kit telemetry fires on plain use, either declare it in the privacy notice and Data safety, or disable the auto-init providers with `tools:node="remove"` and initialise only inside the assistant, after testing that Nano still works. |
| SEC-N2-4 | nit | **url_launcher's in-app `WebViewActivity` ships in the signed APK** (non-exported), pulled in by `in_app_review`, although R14.19 says url_launcher was dropped. It is unreachable while Dart never calls url_launcher. | `aapt2` manifest dump; tripwire warning | VERIFIED | SIGNED BUILD | Remove it with `tools:node="remove"` in the app manifest, or accept it in an ADR line as the tripwire suggests. |
| SEC-N2-5 | nit | **Report sheet: the wording promises a little more than the code can, and the fallback uses the clipboard.** (a) "never your question or your records" is true of what the code adds, but an on-phone answer is written from her own unredacted question (`prompts.dart:77-95`) and may restate it. She sees the exact text in her mail app before sending. (b) With no share sheet, the health text goes to the clipboard without a sensitive-content flag. | `app_en.arb:729`; `report_answer_sheet.dart:63` | VERIFIED (code read) | LOCAL CODE | Say "only the answer shown above"; on Android 13+ copy through a native call with `ClipDescription.EXTRA_IS_SENSITIVE`. |

## 4 · Biggest remaining gaps, ranked

1. **Prove the privacy claim on the wire (SEC-5, SEC-N2-3). OWNER-ONLY (phone).** Run PCAPdroid
   on a Nano phone and a non-Nano phone through: plain use, Ask femio on the phone, Say it, and
   Cloud boost off and then on. Record every host contacted. This is the first thing a security
   judge asks, and the signed APK now visibly starts ML Kit, Firebase and datatransport at
   launch. A session can do an emulator pre-check with mitmproxy (BUILDABLE) and analyse the
   owner's capture, but Nano and Play Integrity need a real phone.
2. **Console posture plus a configured signed build (SEC-8, SEC-N2-2). OWNER-ONLY (console,
   secret file).** Steps:
   - restrict the API key to `com.femioapp.femio` plus the upload and Play signing SHA, and to the
     AI Logic and App Check APIs;
   - confirm App Check is **Enforced**, and do the §C verdict settings;
   - put `assistant.env` in place.

   Then a session rebuilds and re-signs the `.aab` and APK (BUILDABLE). Without this, the judge
   APK has no AI beyond rules.
3. **Protect the screen and the key for every user (SEC-1 default, SEC-3, SEC-N2-1, SEC-11
   restore). BUILDABLE.** Steps:
   - turn screen protection on by default, or at least add a privacy cover on
     `AppLifecycleState.inactive` plus `setRecentsScreenshotEnabled(false)`, with a Settings
     switch for the video;
   - make the PIN wait clock-proof and count misses before checking;
   - restore documents through a staging folder;
   - build ADR-084 (a Keystore key bound to user authentication) after the hackathon.
