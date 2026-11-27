# 06 · Judge re-score against the official #BuildHybridAI criteria (2026-11-27)

Agent-facing report. This is an independent re-score of `audit-2026-11-26/06-judge-criteria.md`, using the
same rubric and scale: four equally weighted criteria, each 1–5, shown as /10 with the official /5 in
brackets, and assuming the owner completes the repo, the video and the APK. Worktree `judge-audit-bd6d27`
at `3a92a90` (`git log --oneline -1`). Reviewer: Claude Opus 5.5.

This review was read-only. I changed no app, web or docs file, and made no commit. Things I ran, all
outside the repo, in the session scratchpad:
- the public exporter, the export's secret scan and tripwire, and `flutter analyze` and `flutter test`
  inside the export;
- `apksigner` and `aapt2` on the signed builds;
- a dex string check;
- `curl` on femioapp.com and the two WHO pages;
- `gh` lookups.

No secret value was printed. The dex check compared a string from `assistant.env` inside a shell
variable and printed only a count.

Labels used below:
- **VERIFIED**: I read it in the source or ran it myself.
- **NOT VERIFIED**: it needs a phone, a console, a live AI call or GitHub.
- **LIVE SITE**: what https://femioapp.com serves today.
- **LOCAL CODE**: this tree.

## 1 · Score: old → new

| Criterion (25% each) | 26 Nov | 27 Nov | One-line reason |
|---|---|---|---|
| Technological Implementation | 6/10 (3/5) | **6.5/10 (3.25/5)** | Better: the export is accurate and its tests pass, the native calls now time out, and the tripwire and CI are packaged. Two things hold it back. Hybrid inference has still never run on real Nano or real Firebase. The exported tripwire crashes, so the public CI would go red (JUDGE-N2-1). |
| Design | 8/10 (4/5) | **8.5/10 (4.25/5)** | Better: a Today chip shows where the AI runs, the assistant is introduced in onboarding, "Report this answer" is added, Help now works on the lock screen, and a failed save shows a banner. All of this is checked only in synthetic renders, not on a real phone. |
| Potential Impact | 7/10 (3.5/5) | **7/10 (3.5/5)** | Unchanged. The two WHO figures now have links, and both are correct on WHO's live pages. There is still no tester, clinician or sign-up evidence. |
| Quality of the Idea | 7/10 (3.5/5) | **7.5/10 (3.75/5)** | Better: the text now presents the "What the AI did" receipt, "What the AI can see" and the AI-off switch, and says why femio uses no other Firebase product. The three non-obvious mechanisms are still not given one reason each. |
| **Weighted total** | **7.0/10 (3.5/5)** | **7.4/10 (3.7/5)** | Still **0 if any Stage One item is missing.** None of the four Stage One items exists yet. |

If N2-1, N2-2 and the real-phone proof (JUDGE-1) are fixed and the video shows both paths, the total is
about **8.3/10 (4.1/5)**, the same ceiling as on 26 Nov.

## 2 · Old findings: status with evidence

### Summary

| ID | Status | Evidence (short) |
|---|---|---|
| JUDGE-1 | **OPEN** (owner) | No real-phone run; the signed builds have no Firebase config |
| JUDGE-2 | **OPEN** (owner) | Repo not found; video and APK links are placeholders |
| JUDGE-3 | **FIXED** | Text matches `redaction.dart` |
| JUDGE-4 | **FIXED** | README rewritten to match ADR-079 |
| JUDGE-5 | **FIXED** | AdMob dates named and match git |
| JUDGE-6 | **FIXED** (Windows run) | Export: analyze clean, 848 pass, 36 skipped |
| JUDGE-7 | **PARTLY FIXED** | Tripwire and CI exported, but the tripwire crashes (N2-1) |
| JUDGE-8 | **PARTLY FIXED** | Script has the cloud segment; not recorded |
| JUDGE-9 | **PARTLY FIXED** | Posture decided; console not set; judge APK not built with config |
| JUDGE-10 | **FIXED** | Step 3 has no first-person word |
| JUDGE-11 | **OPEN** (deferred on purpose) | PROGRESS R14.17 |
| JUDGE-12 | **FIXED** | Ledger, "What the AI can see", multi-day Say it and AI off in the text |
| JUDGE-13 | **FIXED** | Text says why no other Firebase product |
| JUDGE-14 | **FIXED** | HISTORY.md generated, 71 commits |
| JUDGE-15 | **FIXED** | Sleep described as a kind of symptom |
| JUDGE-16 | **FIXED** | Both WHO figures VERIFIED live |

**Count: 10 fixed, 3 partly fixed, 3 open, 0 not verified.** One fixed item, JUDGE-6, was run on Windows
only; the CI on GitHub's Linux runners was not checked.

### Detail

**JUDGE-1 · OPEN (owner).** No evidence that hybrid inference has run on a real phone. These searches came
back empty in `testing-results/`:
- no `*real*` or `*hybrid*` folder;
- no file containing `logcat` or `IN_CLOUD`.

OWNER_ACTIONS row 43 still says "Nothing has run against real Gemini Nano or Firebase yet".

It is also worse than it looks. The only signed builds, `E:/femio-builds/femio-1.0.0-test.apk` and
`femio-1.0.0.aab`, have **no Firebase config**:
- The Firebase project id appears **0 times** in their dex, while the build's default model string
  `gemini-3.5-flash-lite` appears once. That proves `BuildConfig` strings do reach the dex.
- `E:/Femio/apps/mobile/assistant.env` does not exist. The signed builds were made in that main checkout.
- `canRunPrivate` needs `configured` (`apps/mobile/lib/data/assistant_channel.dart:29`), and
  `FemioAssistant.kt:148,160` returns "not configured" when the ids are blank.

So these builds run **no AI at all**, not even Gemini Nano. See JUDGE-N2-2.

**JUDGE-2 · OPEN (owner).**
- `gh repo view KhaledHassanein/femio-app` → "Could not resolve to a Repository".
- The video link is a placeholder: `DEVPOST_SUBMISSION.md:76` `<YouTube, public, ≤3 min, English>`.
- The APK link is a placeholder in testing step 1 (`:89` `<APK link>`), and the release tag in "Try it
  out" (`:75`) does not exist yet.
- LIVE SITE `/en/app` says "Download link coming soon". That is honest.

**JUDGE-3 · FIXED.**
- `DEVPOST_SUBMISSION.md` §3 now says "numbers, e-mail addresses and links are removed".
- That matches `redaction.dart:57-80` (e-mail, URL and digits only).
- The public README says outright that redaction "does not detect names".
- LIVE SITE `/en/app` uses the same wording.

**JUDGE-4 · FIXED.** `scripts/hackathon/public-template/README.md`:
- contains no `ONLY_IN_CLOUD`, "search suggestion" or "rewrites" (grep finds none);
- describes `ONLY_ON_DEVICE` / `PREFER_ON_DEVICE`, `CloudPrompt`, the registry, the ledger, AI off,
  build steps, a mermaid diagram of the two paths, and the tests.

**JUDGE-5 · FIXED.**
- `DEVPOST_SUBMISSION.md:42,80` say "no network code of its own", name AdMob as added on 29 Oct and
  removed on 24 Nov, and say the website has been public since October.
- git agrees: `18bf8c1` 2026-10-29 added the AdMob package; `e5695a9` 2026-11-24 removed it.

**JUDGE-6 · FIXED (VERIFIED by running).** On a fresh export of `3a92a90`:
- `flutter analyze` → "No issues found!";
- `flutter test` → `+848 ~36: All other tests passed!`, exit 0;
- 36 screenshot test files were tagged and skipped through `dart_test.yaml`.

NOT VERIFIED: GitHub's Linux runners.

**JUDGE-7 · PARTLY FIXED.**
- Done: the exporter now copies `scripts/analytics-lint.mjs` byte for byte, plus a wrapper
  (`privacy-tripwire.mjs`) and a CI workflow (`public-template/.github/workflows/ci.yml`). The Devpost
  text now says "checked in CI", not "build".
- I checked that `actions/checkout@v7` and `actions/setup-node@v7` exist (gh api: tags v7.0.1 and v7.1.0).
- Broken: **the exported tripwire crashes** (JUDGE-N2-1), so the strongest privacy proof would show as a
  failing CI job.

**JUDGE-8 · PARTLY FIXED.**
- Done: `VIDEO_SCRIPT.md:37-38` adds a 42-second Cloud boost run on Phone B and the "What the AI did"
  receipt. Every on-screen string it quotes exists in `app_en.arb`:
  - `askWillSend` (:720), `askAnswerCloud` (:784), `boostReceipt` (:937);
  - "Exactly what was sent" and "Sent with Cloud boost".
- Open: the recording (owner). It depends on JUDGE-1.
- Nit: the script quotes the Settings status as "Ready. It reads your notes on the phone; nothing is
  sent." The app says "…, and your words are not sent." (`app_en.arb:868`).

**JUDGE-9 · PARTLY FIXED.**
- Done:
  - Decision recorded: enforcement stays on, and Play Integrity is set to "exclusively outside Google
    Play" (`RELEASE_STEPS.md` §C; OWNER_ACTIONS row 42).
  - The judge fallback line exists: `askNoSummary`, "No on-phone or Cloud boost summary was available…"
    is in `app_en.arb`.
  - Testing step 7 explains the App Check path.
- Not done or not verified:
  - The console settings and the upload-key SHA-256 (owner).
  - A sideloaded test on a second phone (`RELEASE_STEPS.md` "Not verified").
  - The judge APK has not been built with config (N2-2).
- Testing step 7 (`DEVPOST_SUBMISSION.md:95`) already states the Play Integrity setup as fact. It
  becomes true only after §C is done.

**JUDGE-10 · FIXED.**
- Step 3 (`DEVPOST_SUBMISSION.md:91`) is "When should a couple see a doctor about getting pregnant?". It
  contains no word from `_firstPerson` (`redaction.dart:30-49`), so with Cloud boost on it is eligible to
  go to the cloud.
- The registry has a matching passage ("…after at least one year of trying").
- Step 4, "heavy bleeding and dizzy", matches `_heavyBleedingPhrases` and `_dizzyPhrases`
  (`safety.dart:84,164`) and shows the ACOG card.

**JUDGE-11 · OPEN (deferred on purpose).** PROGRESS R14.17 is `[DEFERRED]`. The app is Android only. The
text's "What's next" names iOS, not the web.

**JUDGE-12 · FIXED.** The text now has:
- "What the AI can see" and "What the AI did";
- Say it across several days;
- the AI-off switch;
- the visit companion ("write her worry in her own words"), in `DEVPOST_SUBMISSION.md` "What femio does".

**JUDGE-13 · FIXED.** §6 of the text says: "Analytics and Remote Config would add a per-install
identifier, and Auth an account, which the privacy promise rules out."

**JUDGE-14 · FIXED (VERIFIED by running).** The export writes a `HISTORY.md` with 71 app commits since
2026-11-11, generated from `git log`. It names the first app commit, `6471c12` on 2026-10-08.

**JUDGE-15 · FIXED.** The text now says "symptoms (including sleep problems), flow, mood and ovulation
tests".

**JUDGE-16 · FIXED (VERIFIED on the LIVE WHO pages).**
- The infertility news release of 4 Apr 2023 says "roughly 1 in 6 worldwide".
- The PCOS fact sheet (dated 22 January 2026) says "an estimated 10–13% of reproductive-aged women".
- Both links are in `DEVPOST_SUBMISSION.md:27`.

### R14 items the task asked me to check

| Item | Verdict | Evidence |
|---|---|---|
| R14.2 truth pass | VERIFIED (Devpost, README, LIVE SITE `/en/app`) | See JUDGE-3, JUDGE-5 and JUDGE-15 above |
| R14.3 exporter | VERIFIED working, **except the tripwire** | N2-1 |
| R14.4 judge install path | PARTLY | See JUDGE-9; LIVE `/en/app` card says "Download link coming soon" |
| R14.5 video and Devpost text | Script and text VERIFIED; recording not done | — |
| R14.6 hybrid AI visible on Today | VERIFIED | `lib/features/assistant/ai_status_chip.dart`; strings "Gemini Nano · on this phone" and "On this phone · femio's rules"; `testing-results/2026-11-27-r14-ai-visible/today_en_light.png` viewed (synthetic fixture) |
| R14.6a assistant intro in onboarding | Tests present | `test/r14_19_ports_test.dart` |
| R14.18 "Report this answer" | VERIFIED in code | `lib/features/assistant/report_answer_sheet.dart`; `test/r14_18_report_answer_test.dart` |
| R14.19 Help now on the lock | VERIFIED in code | `lib/features/lock/lock_screen.dart:151` `HelpNowButton` |
| R14.19 failed-save banner | Tests present, not run on a device | `test/r14_19_ports_test.dart` |
| R14.9–R14.14 | Outside this role | Their tests ran green inside the export run (848) |
| Signed builds | **Signed: VERIFIED. Judge-usable: NO** | See below |
| Release smoke test on an emulator | **NOT VERIFIED** | Only a PROGRESS line; no log in `testing-results/` |
| Website deployed | VERIFIED LIVE | See below |

Signed builds:
- `apksigner`: "CN=Khaled Hassanein … C=EG", SHA-256 starting 6671d6bd. Not the debug key.
- `aapt2`: versionName 1.0.0, target and compile SDK 36.
- They carry no Firebase config (JUDGE-1).

Release smoke test: the smoke test checks launch and first frame only, so it says nothing about the AI.

Website: `/en`, `/en/app`, `/ar/app` and `/en/privacy` all return 200 today.

## 3 · New findings

**JUDGE-N2-1 · P0 · The exported privacy tripwire crashes; the public repo's CI would be red.**
BUILDABLE. VERIFIED by running.
- What happens: in a fresh export of `3a92a90`, `node scripts/privacy-tripwire.mjs` prints "privacy
  tripwire FAILED without a readable report". Underneath it is `ERR_MODULE_NOT_FOUND …
  scripts/lib/android-tripwire.mjs`.
- Cause, step 1: `scripts/analytics-lint.mjs:40` now imports `./lib/android-tripwire.mjs`. That import
  was added by `135e59d` (R14.14) at 01:21 on 27 Nov, after the R14.3 export test.
- Cause, step 2: `ARCHIVE_PATHS` and `PATH_MAP` in `scripts/hackathon/export-public-app.mjs:34-48` do
  not include `scripts/lib/`.
- Effect:
  - the `privacy` job in `ci.yml` fails on every push;
  - `RELEASE_STEPS.md:21` (§A step 2) fails, so the owner stops before publishing.
- Fix:
  - add `scripts/lib/android-tripwire.mjs` to `ARCHIVE_PATHS` and `PATH_MAP`;
  - add it to the exporter's `must` list;
  - add a test that runs the wrapper inside a fresh export.
- I tested the fix: with that one file copied into the export, the wrapper prints "✓ privacy tripwire
  (app checks): passed. 4 website check(s) skipped".

**JUDGE-N2-2 · P0 · The only signed builds run no AI, and the release steps would not catch it.**
BUILDABLE check; OWNER build. VERIFIED.
- What is wrong: `femio-1.0.0-test.apk` and `femio-1.0.0.aab` have no Firebase ids (evidence under
  JUDGE-1). On any phone they report "not configured": no Gemini Nano, no Cloud boost. Every testing
  step that mentions Gemini Nano would then be false for a judge.
- Why the release steps miss it: `RELEASE_STEPS.md:68` (§B step 4) only says "run Ask femio once". That
  passes even without config, because Ask femio then shows the passages word for word.
- Fix:
  - In §B, check the built APK for config: Settings → Assistant must not say the assistant is not
    configured.
  - Better, make `flutter build apk --release` fail when `assistant.env` is missing, unless a flag says
    so. That is the same pattern as the `key.properties` guard in `build.gradle.kts:30`.
- Keep in mind: the main checkout has `key.properties` but no `assistant.env`. The hackathon worktree
  has `assistant.env` (4 non-empty keys, values not read) but no `key.properties`.
- The same applies to the `.aab` meant for the closed test.

**JUDGE-N2-3 · P2 · The Devpost network list is less complete than the live website.** BUILDABLE.
- `DEVPOST_SUBMISSION.md:42` says the app reaches the internet "only through Firebase AI Logic and App
  Check, Android's AICore …, and Google Play".
- LIVE SITE `/en/app` "What can leave this phone" also discloses that Google's AI software "may send
  Google technical usage data, such as device details, an identifier for this installation, errors and
  performance".
- A judge who reads both sees a gap next to "femio attaches no account or identifier".
- Fix: add one clause to the Devpost bullet that matches the website.

**JUDGE-N2-4 · P2 (nits) · Small text drifts.** BUILDABLE.
- `DEVPOST_SUBMISSION.md:58` says "812 pass in the public repo". The export now gives 848 passing and 36
  skipped.
- `:88` says "64-bit", but the APK also ships `armeabi-v7a` (`aapt2` native-code). Either drop "64-bit"
  or check that 32-bit phones work.
- `VIDEO_SCRIPT.md` quotes the "Ready" status sentence wrongly (see JUDGE-8).

## 4 · Stage One: what still depends on the owner

| Required item | Status 27 Nov | Who |
|---|---|---|
| Public repo with Apache-2.0 detected in About | **Missing.** The exporter, LICENSE, README, HISTORY and CI are ready locally, but blocked by N2-1. | Session fixes N2-1 → **owner** runs `RELEASE_STEPS.md` §A (`gh repo create`) |
| Firebase AI Logic imported and called at runtime | OK in code (unchanged C1–C3); **never run** | **Owner**: phone and console (rows 25, 43) |
| Demo video, ≤3 min, public on YouTube | **Missing.** Script ready. | **Owner** records (row 28); needs JUDGE-1 first |
| Testing access (APK link) | **Missing.** The existing signed APK has no AI config. | Session adds the N2-2 check → **owner** builds with `assistant.env` and `key.properties`, sets the App Check console (§C), publishes the GitHub Release (§B) |
| Devpost form submitted | **Not done** | **Owner**, at least 24 h before 30 Nov 2:00 PM PT |

## 5 · Biggest remaining gaps, ranked

1. **Hybrid inference has never run for real** (JUDGE-1). This blocks the video, the cloud claims, and
   rules §6 "function as depicted". The fix is a Nano phone, the debug token, a configured build, a Cloud
   boost run and screen recordings. **OWNER-ONLY** (phone, console, recording). A session can prepare a
   configured debug APK and read the logcat.
2. **The public repo would publish with red CI** (JUDGE-N2-1). It is a one-file exporter fix plus a test.
   **BUILDABLE.** Publishing afterwards is OWNER-ONLY.
3. **No judge-usable APK** (JUDGE-N2-2 and JUDGE-9). The signed build has no AI config, the release
   steps would not notice, and the App Check console settings are unset. The config guard and the step
   change are **BUILDABLE**. The build, the console settings and the sideloaded test on a second phone
   are **OWNER-ONLY**.
