# v2 · 06 · Judge re-score against the #BuildHybridAI criteria (2026-11-27, second pass)

Agent-facing report. Re-scores `06-judge-criteria.md` (made at `3a92a90`) at main `eca4eaa`
(`git log --oneline -1` in worktree `judge-audit-bd6d27`). It uses the same rubric:
- four equally weighted Stage Two criteria, each 1–5, shown as /10 with the /5 in brackets;
- the owner is assumed to finish the repo, the video and the APK;
- Stage One is pass/fail.

Reviewer: Claude Opus 5.5.

This review was read-only. The only file I wrote is this report, and I made no commit. Everything I
ran was in the session scratchpad:
- the public exporter into a new empty folder, then the export's tripwire, `flutter analyze` and
  `flutter test`;
- `apksigner`, `aapt2` and `keytool` on the signed builds;
- dex and `libapp.so` string counts;
- `curl` on femioapp.com;
- `gh repo view`;
- tag and keyword counts on `E:/femio-builds/logcat.txt`.

No secret value was printed. The Firebase ids were read from `E:/Femio/apps/mobile/assistant.env`
into shell variables, and only counts were printed.

The labels are the same as before:
- **VERIFIED**: I read it in the source or ran it.
- **NOT VERIFIED**: it needs a phone, a console, a live AI call or GitHub.
- **LIVE SITE**: what femioapp.com serves today.
- **LOCAL CODE**: this tree.

**Nothing has run on a real phone with the new build. Every on-device and cloud claim below is NOT
VERIFIED.**

## 1 · Score: 3a92a90 → eca4eaa

| Criterion (25% each) | 3a92a90 | eca4eaa | Reason |
|---|---|---|---|
| Technological Implementation | 6.5/10 (3.25/5) | **7/10 (3.5/5)** | Up: the exported tripwire now runs green (N2-1 fixed). The signed APK and AAB carry the Firebase ids (N2-2 fixed), and Gradle refuses a release without them. The new cloud check returns typed failure codes, which makes the hybrid path debuggable. The export passes analyze, with 863 tests passing and 39 skipped. Held back for two reasons. Hybrid inference has still never been shown working on a real phone, and the only real-phone contact so far failed (JUDGE-1). The new `ONLY_IN_CLOUD` check is a second way to the cloud that neither the text nor the tripwire mentions (N3-2). |
| Design | 8.5/10 (4.25/5) | **8.5/10 (4.25/5)** | Unchanged. Added: the one AI wizard (choose, read, tick, confirm, with nothing pre-ticked and "off" in one step); "My AI choices"; a two-choice "+" sheet; stage moves, including a gentle "My pregnancy has ended" path; and a Delete acknowledgement. These are real gains. Two things offset them: all of it is seen in synthetic renders only, and the judge's testing steps now point at controls that are gone (N3-1). |
| Potential Impact | 7/10 (3.5/5) | **7/10 (3.5/5)** | Unchanged. The loss path and the breastfeeding layer widen the whole-life story. There is still no evidence from testers, clinicians or sign-ups. |
| Quality of the Idea | 7.5/10 (3.75/5) | **7.5/10 (3.75/5)** | Unchanged. Consent receipts the user keeps, plus a check that says why the cloud call failed, are distinctive for a hybrid-AI entry. But `DEVPOST_SUBMISSION.md` was not edited since `3a92a90`, so a judge never sees either. |
| **Weighted total** | **7.4/10 (3.7/5)** | **7.5/10 (3.75/5)** | Still **0 if any Stage One item is missing.** None of the four owner items exists yet. |

**Ceiling:** about **8.4/10 (4.2/5)**. That needs three things:
- N3-1 and N3-2 fixed and the wizard and check presented in the text;
- a real-phone run of both paths, shown in the video;
- the Stage One items done.

## 2 · Stage One (pass/fail)

| Required item | Status at eca4eaa | Who |
|---|---|---|
| Public repo, Apache-2.0 shown in About | **Missing.** `gh repo view KhaledHassanein/femio-app` → "Could not resolve to a Repository". The export is ready and VERIFIED: 443 files, secret scan clean, tripwire passes, analyze clean, `+863 ~39: All tests passed!` (Windows). | **Owner**: `RELEASE_STEPS.md` §A |
| Firebase AI Logic imported and called at runtime | **In code: yes.** `FemioAssistant.kt` makes `private` (`ONLY_ON_DEVICE`), `hybrid` (`PREFER_ON_DEVICE`) and the new `check` (`ONLY_IN_CLOUD`) calls. The signed builds now carry the config. **Not verified working on any phone.** | **Owner**: phone and console (rows 25, 42, 43) |
| Demo video, ≤3 min, public on YouTube | **Missing.** `DEVPOST_SUBMISSION.md:76` is still a placeholder. The script is now stale in three shots (N3-1). | Session updates the script → **owner** records |
| Testing access (APK link) | **Missing.** `APK_DOWNLOAD_URL = null` (`apps/web/src/lib/site.ts:26`). LIVE `/en/app` returns 200 and says "Download link coming soon" (honest). `DEVPOST_SUBMISSION.md:89` is still `<APK link>`. A configured, signed APK exists locally (N2-2 fixed). | **Owner**: App Check console (§C), GitHub Release (§B), then set the URL |
| Devpost form submitted | **Not done** | **Owner**, at least 24 h before 30 Nov, 2:00 PM PT |

## 3 · Finding statuses

| ID | 3a92a90 | eca4eaa | Evidence |
|---|---|---|---|
| JUDGE-1 | OPEN | **OPEN (owner); first real-phone contact failed** | See below |
| JUDGE-2 | OPEN | **OPEN (owner)** | Repo missing, `APK_DOWNLOAD_URL` null, video placeholder |
| JUDGE-3 | FIXED | FIXED | Devpost §3 and `redaction.dart` unchanged since |
| JUDGE-4 | FIXED | **REGRESSED (partly)** | Public README describes removed UI and only one way to the cloud (N3-1, N3-2) |
| JUDGE-5 | FIXED | FIXED | Text unchanged |
| JUDGE-6 | FIXED | FIXED (Windows) | Fresh export of eca4eaa: "No issues found!", `+863 ~39` |
| JUDGE-7 | PARTLY | **FIXED** (Windows) | Export's `node scripts/privacy-tripwire.mjs` → "✓ privacy tripwire (app checks): passed", exit 0. Linux CI NOT VERIFIED |
| JUDGE-8 | PARTLY | **PARTLY, worse** | Not recorded. Shots 0:22, 1:30 and 2:32 now quote removed UI (N3-1). The "Ready…" nit is unchanged |
| JUDGE-9 | PARTLY | **PARTLY, better** | Judge APK now configured. Console settings and the second-phone test not done. N3-4 |
| JUDGE-10 | FIXED | FIXED | Unchanged |
| JUDGE-11 | OPEN (deferred) | OPEN (deferred) | R14.17 `[DEFERRED]` |
| JUDGE-12 | FIXED | FIXED in text; **step 6 path stale** | N3-1 |
| JUDGE-13 | FIXED | FIXED | Unchanged |
| JUDGE-14 | FIXED | FIXED | HISTORY.md: 78 commits from eca4eaa (N3-6 nit) |
| JUDGE-15 | FIXED | FIXED | Unchanged |
| JUDGE-16 | FIXED | FIXED | Text unchanged; WHO pages not fetched again today |
| JUDGE-N2-1 | OPEN P0 | **FIXED, VERIFIED** | See below |
| JUDGE-N2-2 | OPEN P0 | **FIXED, VERIFIED** | See below |
| JUDGE-N2-3 | OPEN P2 | **OPEN** | See below |
| JUDGE-N2-4 | OPEN P2 | **OPEN** | See below |

**Count: 12 fixed, 2 partly fixed, 1 regressed, 5 open** (2 owner-only, 1 deferred, 2 buildable).

### JUDGE-1 detail

**Status:** OPEN, owner-only. NOT VERIFIED.

What changed: `E:/femio-builds/logcat.txt` exists. It is UTF-16 text from 11-27, 11:47 to 12:41,
written before `85bbe8e` was committed at 13:33. My counts on it:
- **Device:** a real Samsung phone (Samsung `SemSmartClip` tags, no emulator markers).
- **femio ran:** 943 `com.femioapp.femio` lines and 2 process starts.
- **No AI activity:** femio's two PIDs logged **0** Firebase, AppCheck, AICore or `IN_CLOUD` lines.
- **No new log tag:** 0 `femio-ai` lines, which is expected because that build predates the tag.

Two documents agree with that log:
- ADR-085 says Cloud boost "did nothing" on the owner's phone.
- STATE says Gemini Nano is "not ready" on that model.

So the first real-phone contact shows neither path working, and the cause is unknown. The new
"Check Cloud boost" exists to name that cause (Lab 0). The video's Phone A needs a phone that can
run Nano.

### JUDGE-N2-1 detail

**Status:** FIXED, VERIFIED.
- `e373a5f` adds `scripts/lib/android-tripwire.mjs` to `PATH_MAP` and `ARCHIVE_PATHS`, and adds a
  byte-identity check for both tripwire files.
- I ran it into a new empty folder (`scratchpad/export-v2`). Output: "exported 443 files from
  eca4eaa … secret scan clean".
- Inside the export, `node scripts/privacy-tripwire.mjs` gave exit 0 and "passed. 4 website check(s)
  skipped".

### JUDGE-N2-2 detail

**Status:** FIXED, VERIFIED. The builds in `E:/femio-builds` are both dated 27 Nov 13:45, after
`85bbe8e` (13:33).

Occurrence counts in `classes.dex`:

| Build | `FEMIO_FIREBASE_PROJECT_ID` | app id | API key | Check prompt |
|---|---|---|---|---|
| `femio-1.0.0-test.apk` | **1** | 1 | 1 | 1 |
| `femio-1.0.0.aab` (`base/dex/classes.dex`) | **1** | 1 | 1 | 1 |

What else ties the builds to `85bbe8e`:
- Every `libapp.so` (arm64, armv7, x86_64) contains "Check Cloud boost", "My AI choices" and "My
  pregnancy has ended".
- Signer: `CN=Khaled Hassanein … C=EG`, SHA-256 starting `6671d6bd`, the same as the AAB.
- versionName 1.0.0, target SDK 36.

The Gradle guard is in `build.gradle.kts:53-71`. I read it but did not run it.

The API key appears in the dex. That is normal for a Firebase client key. What protects it is App
Check enforcement plus API restrictions in the console, and both are NOT VERIFIED.

`RELEASE_STEPS.md` §B4 still says only "run Ask femio once". It should run "Check Cloud boost" instead.

### JUDGE-N2-3 and JUDGE-N2-4 detail

**JUDGE-N2-3 · OPEN.** `DEVPOST_SUBMISSION.md:42` still does not mention the "technical usage data
… an identifier for this installation" that the LIVE `/en/app` page discloses.

**JUDGE-N2-4 · OPEN.** Three items are unchanged:
- `:58` still says "812 pass"; the export now gives 863.
- `:88` still says "64-bit"; the APK also ships `armeabi-v7a`.
- `VIDEO_SCRIPT.md:12` still quotes "Ready… nothing is sent"; the app says "…, and your words are
  not sent" (`app_en.arb:873`).

### The new work, checked in code

| Claim | Verdict | Evidence |
|---|---|---|
| R14.21 wizard | VERIFIED in code | `ai_choices_wizard.dart` has three modes. Nothing is pre-ticked (`_acks` and `_purposes` start empty). The required statements are 0 for off, 2 for phone and 3 for cloud plus at least one purpose. The dialog "Confirm this change?" comes before `CloudConsent.choose`. The old Cloud boost screen now only wraps the wizard. Tests: `assistant_screens_test.dart` |
| R14.21 sealed receipts | VERIFIED as a hash chain; **the wording overstates it** (N3-3) | `cloud_consent.dart`: `computeSeal` is SHA-256 over JSON that includes `prev`, and `sealIntact` walks the chain. The last 50 receipts are kept. There is no key. Tests: `cloud_consent_test.dart` (17) |
| R14.21 Check Cloud boost | VERIFIED in code; **missing from the docs** (N3-2) | `FemioAssistant.kt` `check()` sends the fixed `CLOUD_CHECK_PROMPT` with `ONLY_IN_CLOUD`. `failureReason` maps the exception chain to 10 codes and logs to `femio-ai`. Dart side: `CloudChecker`, `AssistantGateway.checkCloud`. It is gated on the master switch and on consent to "questions", and written to the ledger. Tests: `assistant_gateway_test.dart` |
| R14.21 Delete acknowledgement | Tests present | `delete_dialog_test.dart` (2) |
| R14.22 stage moves | VERIFIED in code | `pregnancy_end.dart` (`showAfterLoss`, 120 days, cleared once a period is logged). `Profile.cycleStarts` drops starts on or before `pregnancyEnded`. A new pregnant goal clears `pregnancyEnded` (`profile.dart:457`). The urgent line is cited to NHS "Miscarriage (2026)", which I did not re-fetch. Tests: `r14_stage_moves_test.dart` (10 cases) |
| R14.23 "+" sheet | VERIFIED in code | `add_sheet.dart` shows two equal choices, "Ask femio" and "Log with femio", plus a visit link. The Say-it bar moved to Today. `ask_save.dart` takes terms from **her question only** and saves only after she taps Save. Tests: `r14_ask_log_test.dart` |
| R14.20 gap fixes | VERIFIED for N2-1 and N2-2; the others ran green | Their tests are in the 863 passing |
| "Release smoke green on the emulator" (STATE) | **NOT VERIFIED** | No log in `testing-results/` |

## 4 · New findings (JUDGE-N3-x)

### JUDGE-N3-1 · P1 · The judge's testing steps, the README and the video script describe UI that no longer exists

BUILDABLE. VERIFIED: I grepped the strings and their uses.

| Doc | What it says | What the app has now |
|---|---|---|
| `DEVPOST_SUBMISSION.md:90` (step 2) and `VIDEO_SCRIPT.md` 0:22 | "+" → "Tell femio anything…" | The "+" sheet shows "Log with femio"; `addSayItPrompt` now appears only in the Today bar |
| `DEVPOST_SUBMISSION.md:94` (step 6), README `:69` and video 2:32 | Turn off "Use the assistant" | `assistantMasterTitle` and `assistantMasterOff` have no remaining use in `lib/`. AI is turned off through "AI and Cloud boost" → No AI → Next → Confirm my choice → Confirm |
| `DEVPOST_SUBMISSION.md:46` (§2), `:95` (step 7), README `:49-50`, video 1:30 and `RELEASE_STEPS.md` §C4 | "Settings → Assistant → Cloud boost" with an "I agree" button, then "You agreed on…" | `boostAgree` and `boostReceipt` have no remaining use. The wizard ends on "Confirm my choice" plus a dialog |

`OWNER_ACTIONS` row 43 is stale in the same way.

A judge who follows steps 2, 6 or 7 cannot find the control, and rule §6 asks that the project
"function as depicted".

**Fix:** rewrite those steps and shots from `app_en.arb`. Add one line on the wizard and "My AI
choices" to "What femio does".

### JUDGE-N3-2 · P1 · A second, undocumented way to the cloud (`ONLY_IN_CLOUD`) that the tripwire does not guard

BUILDABLE. VERIFIED.

**What the code does:** `FemioAssistant.kt:177` calls `model(InferenceMode.ONLY_IN_CLOUD)` for
`check`. That call takes no `CloudPrompt`. It sends only the constant "Reply with the single word
OK.", only after she has consented to "questions", and the call is written to the ledger. So
**nothing about her is sent.**

**What the text claims:**
- `DEVPOST_SUBMISSION.md:52`: "the cloud-capable call accepts one type, `CloudPrompt`".
- README `:38`: "One typed door to the cloud".
- "Main technology requirement" (`:85`) lists only `ONLY_ON_DEVICE` and `PREFER_ON_DEVICE`.

JUDGE-4 removed `ONLY_IN_CLOUD` from the README because there it had been a false claim. A judge who
now finds it in the Kotlin will read it as drift.

**Tripwire gap:** `analytics-lint.mjs:253` only checks that `runHybrid(CloudPrompt` exists, so the
tripwire passed with this call in place.

**Fix:**
- In the text, name the check as the one fixed-sentence cloud call.
- In the tripwire, allow `ONLY_IN_CLOUD` only inside `check()` with `CLOUD_CHECK_PROMPT`.
- Better still, turn it into a strength. Add "Check Cloud boost" to testing step 7, so that a judge
  whose sideloaded copy fails App Check sees the reason code rather than a silent fallback.

### JUDGE-N3-3 · P2 · "Sealed" receipts are a keyless hash chain: they catch accidental or naive edits, not deliberate ones

BUILDABLE (wording); the design choice is the owner's. VERIFIED in code.

**What the code does:** the seal is `SHA-256(jsonEncode(content + prev))`, with no secret.

**What the chain cannot catch:**
- **Recomputed seals.** Anyone who can read the record can rewrite a receipt and recompute every seal
  after it. The algorithm will be public in the Apache-2.0 repo.
- **Dropped receipts at the ends.** Dropping the newest receipts is invisible, because nothing
  anchors the end of the chain. This includes dropping a withdrawal so that an older grant looks
  current again. Dropping the oldest receipts is also invisible, because `sealIntact` does not
  check the first kept `prev`; that is by design, since the log is capped at 50.
- **A replaced log.** A whole log rebuilt from scratch checks out.
- **Wrong times.** `at` comes from the phone's clock.

**What it does catch:** an edited, re-ordered or removed middle receipt, when the editor does not
recompute the seals.

**How the claims compare:**
- **ADR-085 is mostly honest.** It says "not a signature by femio: anyone with the code could compute
  a seal". But its line "an edited, removed or re-ordered receipt no longer checks out" holds only
  against an editor who does not recompute. The owner asked for a record "that can be proven", and
  this does not reach that bar.
- **The UI overstates it.** `aiRecordIntact` says "Record intact: every receipt matches its seal",
  and `aiRecordBroken` says "This record was changed outside femio". Both read as proof. The second
  could also be plain data damage.
- **Devpost makes no seal claim today** ("dated, versioned record"), which is accurate.
  **Do not add "tamper-proof" or "proven".**

**Suggested wording:** "a hash chain that shows if a receipt was changed by accident or edited
without recomputing the chain. It is not a signature."

**Stronger option, if wanted:** sign each receipt with a hardware-backed Android Keystore key and put
its key-attestation chain in the shared copy. Forging would then need that phone's secure hardware.
It still would not catch dropped receipts at the end, and it needs an ADR.

### JUDGE-N3-4 · P2 · The App Check failure message tells a sideloading judge to "Install femio from Google Play"

BUILDABLE. VERIFIED.
- `cloudCheckFailed` → `app_check` reads "Google did not accept this copy of femio (App Check).
  Install femio from Google Play, or try again later." That is in `app_en.arb:996`, and the same
  wording is in AR, FR and ES.
- femio is not on Play during judging.
- **Fix:** say that the check needs a real, unrooted phone with Google Play services, matching
  `RELEASE_STEPS.md` §C.

### JUDGE-N3-5 · P3 · The ledger files the cloud check as an Ask femio cloud call

BUILDABLE.
- `assistant_gateway.dart:134` logs `AssistantUse.askInCloud`, so "What the AI did" shows a
  diagnostic as a question that was asked.
- The sent text is shown, so this is honest, but it is muddled.
- **Fix:** give the check its own `AssistantUse`.

### JUDGE-N3-6 · P3 · Two small items

- **HISTORY.md:** the public file lists a `wip(app):` commit (`b534d8f`). It is harmless, but it
  reads as unfinished.
- **Smoke test:** STATE's "release smoke green" has no stored log.

## 5 · Biggest gaps

1. **Hybrid inference is unproven, and the first real-phone contact failed** (JUDGE-1). On the
   owner's Samsung, Nano was "not ready", Cloud boost did nothing, and the logcat has no AI line.
   This blocks the video, the cloud claims and "function as depicted". To close it: run "Check Cloud
   boost" on the new APK and read the code; register the debug token or set the Play Integrity
   verdicts; then record on a Nano-capable phone plus one Cloud boost run. **OWNER-ONLY** (phone,
   console, recording). A session can interpret the `femio-ai` logcat line.
2. **The judge-facing text has drifted from the app** (N3-1, N3-2, plus N2-3 and N2-4). Testing
   steps 2, 6 and 7, the README and three video shots point at removed controls. The new cloud check
   is undocumented and not guarded by the tripwire. The wizard and receipts, femio's newest
   differentiators, are absent from the Devpost text. **BUILDABLE**: about an hour of text edits plus
   a tripwire rule, then re-export.
3. **The Stage One assets do not exist** (JUDGE-2, JUDGE-9). There is no public repo, no GitHub
   Release, no `APK_DOWNLOAD_URL`, no App Check verdict settings, no video and no submission. The
   export (green) and a configured signed APK are ready. **OWNER-ONLY.**
