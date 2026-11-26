# 06 · Judge audit against the official #BuildHybridAI criteria (2026-11-26)

Agent-facing report. Read-only audit of worktree `judge-audit-bd6d27` at `fb45488`, by a hackathon-judge
reviewer (Claude Opus 5.5). Nothing in the code was changed; no test, install or build was run (another
process runs the suite). "VERIFIED" below means read in the source or on the official page; nothing here
was run on a phone.

## 1 · Official rules (VERIFIED on the live Devpost pages, 2026-11-26)

Sources: overview https://firebasehybridaihackathon.devpost.com/ · rules https://firebasehybridaihackathon.devpost.com/rules ·
Android hybrid guide https://firebase.google.com/docs/ai-logic/hybrid/android/get-started · models
https://firebase.google.com/docs/ai-logic/models

| Topic | What the official text says | URL |
|---|---|---|
| Period | Submissions 11 Nov 2026 1:30 PM PT to **30 Nov 2026 2:00 PM PT**; judging 10–16 Dec; winners ~21 Dec. **Commits pushed after the deadline are not evaluated.** | rules §4, §7 |
| Eligibility | Age of majority; excluded: Brazil, Italy, Quebec, Crimea, Cuba, Iran, Syria, North Korea, Sudan, Belarus, Russia, OFAC-designated. Egypt is eligible. Individuals, teams, organisations. | rules §3 |
| Required technology | "Build a Gen AI application using Firebase AI Logic along with supported firebase products such as: AppCheck, RemoteConfig, Firestore and Authentication." At least one platform: Web (Chrome) with Gemini Nano 4, **Android with Gemini Nano 4 via Firebase AI Logic**, or iOS with Apple Foundation Models. Multi-platform preferred ("strong consideration for the Grand Prize"). Main description: "your app runs prompts on-device when a local model is available and falls back to the cloud when it isn't." **"Firebase AI Logic requires App Check; debug tokens are accepted in submissions."** | rules §6; overview |
| Functionality | Must install and run consistently on its platform and "function as depicted in the video and/or expressed in the text description". | rules §6 |
| New vs existing | Existing projects must be "significantly updated" in the period; must disclose pre-existing code and **provide a summary of what you built during the submission period**; if the existing app already has public usage, describe the core value it brings. | rules §6 |
| Text description | How Firebase AI Logic is used, features and functionality, value proposition. | rules §6 |
| Repository | Public GitHub/GitLab URL with all source, assets and instructions to make it functional; must **demonstrate Firebase AI Logic imported and actually called at runtime**; **open-source licence file detectable in the About section** (Apache preferred). No production keys, live secrets or PII in repo, form or testing instructions. | rules §6 |
| Video | Shows the project functioning on its platform; **≤ 3 minutes** (only the first 3 judged); **public on YouTube**; English or English subtitles. | rules §6 |
| Testing access | Link to a website, functioning demo or test build, free, until judging ends. Judges may judge on text, images and video alone. Hosted project "highly encouraged". | rules §6 |
| Language | App must support English at minimum; materials in English. | rules §6 |
| Judging | Stage One pass/fail (all requirements present, addresses the challenge). Stage Two: **four equally weighted criteria, each scored 1–5, averaged**: (1) Technological Implementation: how well built, and how effectively it uses Firebase AI Logic **hybrid inference**; (2) Design: complete, coherent product experience, not a proof of concept; (3) Potential Impact: credible, specific case for a real problem for a real audience, addressed by what is demonstrated; (4) Quality of the Idea: creative, non-obvious use of Firebase AI Logic, genuine understanding of the problem space. Ties broken in that order. AI-driven analysis may be used. | rules §8; overview |
| Prizes | Grand $10,000 (+ interview, blog, social); 1st runner-up $7,000; 2nd runner-up $4,000; Best iOS, **Best Android**, Best Web/Chrome $3,000 each. One grand + up to one "Best of". | rules §9 |
| Platform facts | Android: `firebase-ai:18.2.0`, `firebase-ai-ondevice:16.0.0-beta08`; `InferenceMode` = `PREFER_ON_DEVICE`, `ONLY_ON_DEVICE`, `PREFER_IN_CLOUD`, `ONLY_IN_CLOUD`; `FirebaseAIOnDevice.checkStatus()/download()`. **App Check enforced automatically for AI Logic in all projects since 2 Nov 2026.** On-device validated only for English and Korean; keep on-device output under 256 tokens. `gemini-3.5-flash-lite` is a listed model (no billing required). | Android guide; models page |

The repo's own `docs/hackathon/` agrees with these rules except where findings below say otherwise.

## 2 · Claim truth table (`docs/hackathon/DEVPOST_SUBMISSION.md`)

Paths are relative to `apps/mobile/` unless they start with `docs/` or `scripts/`.

| # | Claim in the submission | Verdict | Evidence (file:line) |
|---|---|---|---|
| C1 | Firebase AI Logic imported and called at runtime in Kotlin (`FemioAssistant.kt`), one method channel | TRUE | `android/app/src/main/kotlin/com/femioapp/femio/assistant/FemioAssistant.kt:26-35` imports, `:141-145` `Firebase.ai(...).generativeModel(... onDeviceConfig = OnDeviceConfig(mode))`; registered in `MainActivity.kt:24`; deps `android/app/build.gradle.kts:101-105` match Google's guide |
| C2 | Record-touching calls run ONLY_ON_DEVICE; no silent cloud fallback | TRUE (code) | `FemioAssistant.kt:117-121`; Dart discards any private reply not marked ON_DEVICE `lib/data/assistant_channel.dart:99-101`; Say it, tips, visit questions, Ask on phone all go through `_private` `lib/data/assistant_gateway.dart:121-199` |
| C3 | Cloud boost uses PREFER_ON_DEVICE with a cloud Gemini model | TRUE (code) | `FemioAssistant.kt:128-132`; model `build.gradle.kts:74` (`gemini-3.5-flash-lite`, a valid model per models page). Note: Dart only calls hybrid when Nano is **not** available (`lib/features/assistant/ask_screen.dart:119-143`), so in practice the hybrid call is the cloud call |
| C4 | Cloud-capable call accepts only `CloudPrompt`, built only from `CloudSafeText` or `PseudonymisedProfile` | TRUE | `lib/data/assistant_channel.dart:109`; private ctor and two factories `lib/domain/assistant/cloud_prompt.dart:21-48`; `CloudSafeText` private ctor `lib/domain/assistant/redaction.dart:17-22`; `PseudonymisedProfile` private ctor `lib/domain/assistant/pseudonymised_profile.dart:72-78` |
| C5 | Redaction removes "numbers, dates, names, contacts" | **FALSE (names) / PARTLY (dates)** | `redaction.dart:57-80` strips e-mail, URLs and digits only. **No name detection**: "Can Sara get pregnant with PCOS?" passes with "Sara". Month names survive ("since March"). First-person questions are kept on the phone (`:62-68`), which is the real protection. Tests cover digits/links/@ only: `test/assistant_core_test.dart:145-152` |
| C6 | She sees and approves the exact text before it may use the cloud | TRUE | editable `_outgoing` field, `_Stage.confirming`, re-checked with `toCloudSafe` and safety rules on send: `ask_screen.dart:136-167` |
| C7 | Pseudonymised profile = coarse derived bands, no dates, free text, names or identifiers | TRUE | `pseudonymised_profile.dart:89-94` (four bands), elevated terms excluded `:110-113`; test `test/assistant_hybrid_test.dart:67` |
| C8 | Consent per purpose, unticked boxes, "I agree", dated versioned receipt, withdrawal recorded | TRUE | `lib/domain/assistant/cloud_consent.dart:15-60` (purposes, ISO time, version, empty set = withdrawal); screen `lib/features/assistant/cloud_boost_screen.dart:10-11,98,194`; tests `test/cloud_consent_test.dart:19,27,34,47` |
| C9 | Cloud is offered every tip for her life stage, never the subset that fits her | TRUE | `cloud_prompt.dart:38-48`; test `test/assistant_hybrid_test.dart:164` |
| C10 | Answers only from the bundled registry; numbered citations; uncited answers discarded and passages shown word for word | TRUE | prompt `lib/domain/assistant/prompts.dart:79-87`; `parseAnswer` rejects no citation / bad number / NOT_COVERED `:107-117`; registry loaded from assets `lib/data/trusted_registry.dart:21-27`; tests `test/assistant_hybrid_test.dart:52,59`, `test/assistant_boundary_test.dart:114` |
| C11 | Each source shows publisher, link and date | TRUE | `lib/features/assistant/answer_card.dart:75,134-153` |
| C12 | Red flags and birth-control rules run first and always win | TRUE | `lib/domain/assistant/safety.dart:396-406` (crisis, urgent, heavy bleeding + dizzy, pregnancy, postpartum, birth control); runs before search/model `ask_screen.dart:98-109` and again before send `:153-157`; tests `test/assistant_core_test.dart:72-106`, `test/assistant_hybrid_test.dart:208-266` |
| C13 | App Check on every call: debug provider in development, Play Integrity in release | TRUE (code) | installed when the Firebase app is created `FemioAssistant.kt:159`; `src/debug/.../AppCheckInstaller.kt:14` (debug), `src/release/...:29` and `src/profile/...:44` (Play Integrity) |
| C14 | "A build-time tripwire fails if [the CloudPrompt rule] changes, if search grounding is wired in, or if network code appears outside the one allowed layer" | **PARTLY** | Rules exist in `scripts/analytics-lint.mjs:169-290` (Dart network code `:173-184`, Firebase only in Kotlin assistant package `:216-230`, no GoogleSearch `:232-233`, CloudPrompt factories `:247-263`). But it is a **gate/CI step** (`package.json:17`, `.github/workflows/ci.yml:39`), **not part of the Android/Flutter build**; Kotlin network code other than Firebase imports is not checked; and **the export to the public repo leaves the tripwire out** (`scripts/hackathon/export-public-app.mjs:44-45` copies only `apps/mobile` and `fixtures/domain`), so judges cannot see it |
| C15 | Four languages (EN, AR, FR, ES) | TRUE | `lib/l10n/app_{en,ar,fr,es}.arb` |
| C16 | Say it turns words into symptoms, flow, mood, sleep and ovulation tests | TRUE, "sleep" PARTLY | model output shape `prompts.dart:23-45` (terms, flow, opk); mood is a term dimension; sleep exists only as symptom terms (insomnia, fatigue, "cant sleep" lexicon `lib/domain/assistant/log_phrases_lexicon.dart:774-793`); tests `test/assistant_core_test.dart:28-58` |
| C17 | Tips chosen on her phone; Gemini Nano puts them in order | TRUE | `assistant_gateway.dart:167-188` |
| C18 | Visit prep: one-page summary + personalised question list | TRUE | `lib/domain/assistant/visit_summary.dart`, `lib/features/assistant/visit_summary_screen.dart`; on-phone ordering `assistant_gateway.dart:191-199` |
| C19 | No account, no ads, no analytics or tracking SDK in the app | TRUE (today) | `pubspec.yaml:23-37` has no ads/analytics package; INTERNET only for AI Logic `android/app/src/main/AndroidManifest.xml:7-12` |
| C20 | "Before Nov 11 … The prototype had no AI features and no network code" | **PARTLY FALSE** | No AI: TRUE (no AI SDK in history before 2026-11-24; first AI commit `86d851a` 2026-11-24). "No network code": FALSE for the app: `google_mobile_ads 9.2.0` (AdMob, network SDK, INTERNET) shipped in the app from `18bf8c1` (2026-10-29) until ADR-080 (2026-11-24); `git show 0d2bf25:apps/mobile/pubspec.yaml:32`. Also "early Flutter tracker / unfinished prototype" understates a signed release candidate 0.5.0 with 16 store screenshots (STATE.md:82); and the website has been **public** on femioapp.com since 2026-10-28 (public usage, rules §6) |
| C21 | Built during the period: the whole AI layer, consent, redaction, Kotlin bridge, tripwire update, public Apache-2.0 repo | TRUE for code; **FALSE today for the repo** | AI commits all 2026-11-24..26 (`git log --since=2026-11-01` on assistant paths: `86d851a`, `6c32f5c`, `ac3d2e0`, `a690ae1`, `d39e1ae`); 0 commits between 11 and 24 Nov. `KhaledHassanein/femio-app` does not exist (`gh repo view`: not found); no `LICENSE` in this tree |
| C22 | Start date 07-21-26 | TRUE | first commit `f2b52fa` 2026-07-21 (docs); app code starts `6471c12` 2026-10-08 |
| C23 | "On a phone without Nano … with Cloud boost on, a general question can be summarised in the cloud" (testing instructions) | TRUE in code, **but the instructed example never reaches it** | Step 3's question "How long should **we** try…" contains "we", so `isAboutHer` keeps it on the phone (`redaction.dart:31,63`); a judge without Nano following the steps never sees a cloud answer |
| C24 | Stats: infertility 1 in 6 (WHO 2023), PCOS 8–13% (WHO fact sheet) | NOT VERIFIED here (consistent with WHO public figures as remembered; check the two URLs before submitting) | `DEVPOST_SUBMISSION.md:20` |
| C25 | "Hundreds of unit tests plus guards" | TRUE by record, NOT re-run | STATE.md:21 (990 tests on 2026-11-25); not run in this audit by instruction |
| **C26** | **The whole hybrid path works on a real phone with real Firebase and real Gemini Nano** | **NOT VERIFIED: never run** | STATE.md:37 "Not yet run against real Firebase or Gemini Nano: owner actions 23–28 first"; PROGRESS R7.4/R7.8 "fake bridge, synthetic"; every image in `testing-results/2026-11-24-r7-assistant/` and `2026-11-25-r10-transparency/` is a golden render from a fake bridge; no logcat, no `IN_CLOUD`/`ON_DEVICE` trace, no device recording anywhere in `testing-results/` (searched both worktrees and `E:\Femio`) |

### Has the AI ever run for real?

- **No evidence that it has.** Nothing in `testing-results/`, PROGRESS or STATE records a real call.
- `apps/mobile/assistant.env` does **not** exist in this worktree. It **does** exist in
  `E:\Femio\.claude\worktrees\firebase-hackathon-eligibility-833c52\apps\mobile\` (written 2026-11-24 21:45; all
  four keys non-empty; values not read or printed). So owner actions 23–24 look done in part.
- In that worktree the **debug APK was built 2026-11-24 21:38, seven minutes before `assistant.env` existed**, so it
  reports "not configured". The release APK there (2026-11-26 14:44) would carry the config but uses Play Integrity,
  which a sideloaded APK will not pass now that App Check is enforced for AI Logic in every project (since 2 Nov 2026).
  No `key.properties` there, so that APK is not signed with the upload key.
- Owner actions 25 (debug token, enforcement), 26 (Nano phone), 27 (public repo), 28 (video, Devpost) are open.

**Minimum evidence before submitting** (store it in `testing-results/2026-11-2x-hybrid-real/`):
1. On a Nano-ready phone (debug build with config): Settings → Assistant shows "Ready"; one Say it, one Ask femio and
   the tips card each answered with the on-device label; logcat lines showing the `private` call returned
   `source=ON_DEVICE` (no prompt text in the log).
2. On a phone without Nano (or the emulator) with Cloud boost on: one general question, approved, answered with the
   "ran in the cloud" label and citations; the AI ledger entry showing what was sent.
3. The App Check debug token registered and the cloud call succeeding with enforcement on; one refused call with
   enforcement and no token, to prove App Check is real.
4. The red-flag case on the real phone ("heavy bleeding and dizzy") opening help with no model call in the ledger.
5. A screen recording of 1–2 (this is also the video's raw material).
Without 1–2, the central claim ("hybrid inference with Gemini Nano and cloud fallback") is unproven and the text must
not say it works.

## 3 · Submission completeness checklist

| Required item | Status | Evidence | Owner |
|---|---|---|---|
| Eligibility (individual, Egypt, adult) | OK | rules §3 | — |
| Firebase AI Logic hybrid on Android, called at runtime | OK in code, **not run** | C1–C3, C26 | 23–26 |
| App Check | OK in code; enforcement + debug token **not done** | C13; OWNER_ACTIONS 25 | 25 |
| Public GitHub repo with all source + instructions | **MISSING**; export script ready but **its README is stale** and **`flutter test` will fail** in the export | JUDGE-4, JUDGE-6 | 27 |
| Open-source licence visible in About | **MISSING** (planned via `gh repo create --license apache-2.0`, `export-public-app.mjs:11-12`) | no LICENSE in tree | 27 |
| No keys/secrets/PII in repo | OK by design: `assistant.env` git-ignored (`.gitignore:14`), export refuses secret-shaped files (`export-public-app.mjs:28,48-52`) | — | — |
| Demo video ≤3 min, public YouTube, English | **MISSING**; script exists but shows **no cloud call** | `docs/hackathon/VIDEO_SCRIPT.md` | 28 |
| Text description (Firebase AI Logic use, features, value) | Drafted; 3 false/partly false statements | C5, C14, C20 | session |
| "What existed vs what I built" | Drafted; needs the AdMob correction and the public website | C20 | session |
| Testing access (APK link) | **MISSING** (`<APK link>` placeholder); no judge-ready build | `DEVPOST_SUBMISSION.md:66` | 28 + session |
| Testing instructions | Drafted; step 3 cannot show the cloud | C23 | session |
| Thumbnail | OK, 1500×1000 PNG (3:2) | `docs/hackathon/thumbnail.png` | — |
| Elevator pitch ≤200 chars | OK (192) | `DEVPOST_SUBMISSION.md:16` | — |
| Platform selected: Android | OK | `:68` | 28 |
| Git history supports "AI built after 11 Nov" | OK: all AI commits 24–26 Nov | C21 | — |

**Stage One risk:** as of `fb45488` three required items do not exist (public licensed repo, YouTube video, testing
build). Missing any of them is a Stage One fail regardless of code quality.

## 4 · Scores against the official criteria (tough but fair)

Official scale is 1–5 per criterion, equal weights, averaged. Scores below are /10 (official equivalent in brackets),
assuming the owner completes repo, video and APK but nothing else changes.

| Criterion (25% each) | Score | Why | What raises it most before 30 Nov |
|---|---|---|---|
| Technological Implementation | **6/10 (3/5)** | Strong engineering: typed privacy boundary the compiler enforces, a single gateway with timeout and circuit breaker, fuzzed reply parsing, grounded answers that are discarded when uncited, offline parity, AI ledger, ~990 tests. But it has **never run on real Gemini Nano or real Firebase**; the hybrid fallback sits behind an opt-in that is off by default; the planned video shows **no cloud call**; a sideloaded judge APK cannot pass Play Integrity, so judges are unlikely to see the cloud path; the public repo would omit the tripwire and fail `flutter test` | Real-device evidence (§2 list) and a video showing **both** paths with the "on this phone" / "in the cloud" label and the ledger; ship the tripwire and a CI badge in the public repo; fix the export README → **8/10** |
| Design | **8/10 (4/5)** | A complete product, not a demo: cycle/pregnancy/perimenopause views, consent screen with her own values, "what the AI sees", ledger, four languages with RTL, every feature works with AI off. Risk: on a phone without Nano and without consent, the AI is invisible and the app looks rules-only | Open the video on the AI moments; make the "ran on this phone / in the cloud" chip obvious; add the AI ledger and "What the AI sees" screens to the submission text (built after the text was aligned on 24 Nov) → **9/10** |
| Potential Impact | **7/10 (3.5/5)** | Physician-built, specific audience (TTC, PCOS, pregnancy; Egypt and Saudi), a real privacy problem in femtech, WHO figures cited. Weakness: no users, no tester feedback, not on Play; the market claim is generic | One concrete line of evidence: tester or clinician quotes, or the closed-test sign-ups; name the audience and the gap (no private, sourced, Arabic-capable assistant) with numbers; show the Arabic Say it once in the video → **8/10** |
| Quality of the Idea | **7/10 (3.5/5)** | Splitting device/cloud by data sensitivity is the canonical hybrid example (Google's own workshop uses it), so it is on-theme rather than surprising. The non-obvious parts are good: a pseudonymised four-band profile as the only personal cloud input, the "offer the whole stage, never her subset" trick, registry-only grounding with "not covered", rules that outrank the model | Lead the text with those three non-obvious mechanisms and one sentence on why each exists (re-identification by subset, hallucination in health, crisis wording) → **8/10** |
| **Weighted total** | **7.0/10 (3.5/5)** | 0 if any Stage One item is missing | With the fixes: **≈8.3/10 (4.1/5)**; a credible Best Android contender |

## 5 · Findings

| ID | Sev | Finding | Evidence | Status | Fix | OWNER |
|---|---|---|---|---|---|---|
| JUDGE-1 | **P0** | The central claim (hybrid Gemini Nano + cloud fallback through Firebase AI Logic) has never run on a real phone or a real Firebase project. Rules §6: the project must "function as depicted". | STATE.md:37; PROGRESS R7.4, R7.8; `testing-results/` has only fake-bridge goldens | VERIFIED (absence of evidence) | Do owner actions 25–26, build a **fresh** debug APK from the worktree that holds `assistant.env`, capture the §2 evidence set. Until then remove "works" wording | **OWNER** (25, 26) |
| JUDGE-2 | **P0** | Required items missing: public licensed repo, YouTube video, APK link. Stage One is pass/fail. | `gh repo view KhaledHassanein/femio-app` → not found; no LICENSE; placeholders `DEVPOST_SUBMISSION.md:66-67,89` | VERIFIED | Owner says "make it public" (27); record and upload (28); host the APK (GitHub Release on the public repo) | **OWNER** (27, 28) |
| JUDGE-3 | **P0** | False claim: redaction says "names" are removed; only digits, e-mails and URLs are. "Dates" only partly (month names survive). | `redaction.dart:57-80`; `DEVPOST_SUBMISSION.md:38` | VERIFIED | Either change the text to "numbers, contacts and links removed; anything about her stays on the phone", or add a capitalised-name/month stripper with tests. Text change is the safe fix | — |
| JUDGE-4 | **P0** | The public repo's README (written by the export script) describes the **removed** design: `ONLY_IN_CLOUD`, "Google Search grounding", "rewrites a personal question", "Google's search suggestions", WHO/NHS as answer sources. It contradicts the submission and the tripwire. | `scripts/hackathon/export-public-app.mjs:63-75`; script last changed `6c32f5c` (before ADR-079) | VERIFIED | Rewrite the README template to match `DEVPOST_SUBMISSION.md` §"How Femio uses Firebase AI Logic"; add value proposition, build and test steps, a diagram of the two paths | — |
| JUDGE-5 | **P0** | False claim in "What existed": "no network code". The app carried the AdMob SDK (with INTERNET) from 29 Oct to 24 Nov. | `18bf8c1`; `git show 0d2bf25:apps/mobile/pubspec.yaml:32` | VERIFIED | Say: "no AI features and no network code of its own; an ads SDK added on 29 Oct was removed during the period." Also say the website is public since Oct 2026 and the app was an unreleased release candidate | — |
| JUDGE-6 | P1 | In the exported repo `flutter test` will fail: screenshot tests compare against goldens in `../../../testing-results/...` and `docs/store/...`, which the export does not copy. The README tells judges to run `flutter test`. | e.g. `test/assistant_screens_test.dart:38,184`; export copies only `apps/mobile`, `fixtures/domain` (`export-public-app.mjs:44-45`) | VERIFIED by reading, NOT run | Copy the referenced golden folders into the export, or tag screenshot tests and exclude them (`flutter test --exclude-tags screenshots`) in the README; run the export + `flutter test` once in the export folder before publishing | — |
| JUDGE-7 | P1 | The privacy tripwire, the strongest proof of the boundary, is not in the public repo, and it is a gate/CI step, not a build step, despite "enforced by … the build". | `scripts/analytics-lint.mjs:169-290`; `ci.yml:39`; export scope | VERIFIED | Export a mobile-only copy of the tripwire plus a GitHub Actions workflow running it with `flutter analyze` and tests; reword to "a CI check fails the build" | — |
| JUDGE-8 | P1 | The video script never shows a cloud call (Cloud boost stays off, consent screen ends on "Not now"). The criterion is "how effectively does it use hybrid inference". | `VIDEO_SCRIPT.md:20` | VERIFIED | Add a 20-second segment: Nano off (or second phone), Cloud boost on, approve a general question, "answered in the cloud" label, then the AI ledger showing exactly what was sent | **OWNER** (28) |
| JUDGE-9 | P1 | Judges cannot reach the cloud path: a sideloaded release APK fails Play Integrity under enforced App Check; the existing debug APK predates `assistant.env` and has no config. | APK timestamps in the hackathon worktree; App Check enforced since 2 Nov 2026 (Android guide) | VERIFIED (timestamps), outcome NOT VERIFIED | Decide one: (a) keep enforcement, say so plainly and rely on the video; (b) set AI Logic App Check to unenforced (monitor) for 10–16 Dec with the $10 budget alert; (c) Play internal app sharing link. Whatever is chosen, rebuild the judge APK **after** `assistant.env` and test it on a phone that did not build it | **OWNER** (decision) |
| JUDGE-10 | P1 | Testing step 3 uses "we", which keeps the question on the phone; a judge without Nano never sees a cloud answer. | `DEVPOST_SUBMISSION.md:82`; `redaction.dart:31` | VERIFIED | Use a general question for the cloud step, e.g. "What helps with period cramps?", and say which label to expect on each path | — |
| JUDGE-11 | P2 | Multi-platform is preferred for the Grand Prize; femio is Android-only. The website could host a Web (Chrome) hybrid demo of Ask femio on public registry passages only, no personal data. | overview page; `apps/web` static | VERIFIED (rule) | Bold, optional, 4 days left: a `/ask` page on femioapp.com using Firebase AI Logic web hybrid (Chrome built-in Nano, cloud fallback), registry passages only, App Check reCAPTCHA. Only if it can be finished and verified by 29 Nov; otherwise say "iOS and web next" | **OWNER** (scope call) |
| JUDGE-12 | P2 | The submission was aligned on 24 Nov; newer AI strengths are missing from the text: AI ledger and "What the AI sees" (R10.3), Say it over several days (R10.7), visit companion (R10.2), patterns (R10.4). | STATE.md:19-21 | VERIFIED | Add one bullet each; add the wave-2 non-AI work to "built during the period" | — |
| JUDGE-13 | P2 | Only App Check is used among the "supported firebase products". Remote Config or Auth would add Firebase Installation IDs, which conflicts with "no identifiers". | rules §6 | VERIFIED | Keep it, and say in one line why: other Firebase products would add an install identifier, which the privacy promise forbids. Judges reward the reasoning | — |
| JUDGE-14 | P2 | Public repo will be a single-commit export; judges cannot check "built after 11 Nov" from it. | export script | VERIFIED | Add a `HISTORY.md` table of the AI commits with dates and hashes, or say in the text that the private monorepo history is available on request | — |
| JUDGE-15 | P2 | "Sleep" is not its own Say it output; it maps to symptom terms. | C16 | VERIFIED | Say "symptoms (including sleep problems), flow, mood and ovulation tests" | — |
| JUDGE-16 | P2 | Two statistics carry no URL in the text. | `DEVPOST_SUBMISSION.md:20` | NOT VERIFIED | Link the WHO infertility release (2023) and the WHO PCOS fact sheet | — |

## 6 · Order of work before 30 Nov 2:00 PM PT (00:00 Cairo 1 Dec)

1. Owner 25–26 today; session rebuilds the debug APK with config and captures the §2 evidence (JUDGE-1, JUDGE-9).
2. Session fixes text (JUDGE-3, 5, 10, 12, 15, 16) and the export (JUDGE-4, 6, 7, 14); runs the export and
   `flutter test` inside it once.
3. Owner 27 (publish), 28 (video with the cloud segment, JUDGE-8), then submit with the APK as a GitHub Release.
4. Submit at least 24 hours early: commits after the deadline are not evaluated.
