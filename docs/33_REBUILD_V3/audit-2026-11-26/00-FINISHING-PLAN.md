# Judge-style audit and finishing plan (2026-11-26)

Agent-facing. Owner page: see the artifact link in `docs/STATE.md`. Ledger lines: PROGRESS **R14**.
Owner-only steps: `docs/runbooks/OWNER_ACTIONS.md` rows 40-45.

Audited at commit `fb45488` (branch `claude/firebase-hackathon-eligibility-833c52`, same tree as
`claude/judge-audit-bd6d27`). Deadline: #BuildHybridAI, Monday 30 Nov 2026 14:00 PT = Tuesday
1 Dec 00:00 Cairo. Commits pushed after the deadline are not evaluated (Devpost rules §8).

## Reports (read these for evidence; every finding has an ID)

| File | Role | Model | Score |
|---|---|---|---|
| `01-security.md` | Security reviewer | Opus | 7/10 (17 findings, no P0) |
| `02-privacy.md` | Privacy / data-protection lawyer | Opus | 8/10 by the agent, **7/10 after lead review** (a false "names removed" sentence is live) |
| `03-release.md` | Play release manager | Sonnet | 5/10 overall; 4/10 for the hackathon today; 3/10 for Play production |
| `04-clinical-maturity.md` | Clinician reviewer | Opus | 5/10 (cycle 6, TTC 5, PCOS 3, pregnancy 6, after birth 6.5, loss 1, perimenopause 6) |
| `05-ux-ai-showcase.md` | UX critic and demo coach | Opus | hybrid-AI showcase 4/10; presentation and polish 6/10 |
| `06-judge-criteria.md` | Hackathon judge | Opus | 7.0/10 (3.5/5) **if** Stage One passes; 0 if any required item is missing |
| Stitch Review artifact (parent session) | per-screen review, 12 calendar states, AI placement | — | https://claude.ai/artifact/2wbNyvPh6eVLDkUUoMpvRT ("Top 10 fixes"; v2 read 2026-11-26). Fixes 1, 3-7 → R14.7; fix 2 → R14.8 (owner row 40); fixes 8-10 → R14.6. Renders and `calendar_facts.json`: `testing-results/2026-11-26-stitch-review-all/` in the hackathon worktree |
| `evidence/calendar_repro.dart` | lead | — | owner's calendar report reproduced (below) |

Official judging (https://firebasehybridaihackathon.devpost.com/rules §8): Stage One pass/fail on
required items (Firebase AI Logic with App Check, public repo with an open-source licence, public
YouTube video ≤ 3 min, testing access, what was built in the period); Stage Two four equal criteria
scored 1-5: Technological Implementation, Design, Potential Impact, Quality of the Idea.

## Lead sample checks (each agent's claims re-run before acceptance)

| Claim | Check | Result |
|---|---|---|
| App gate | `flutter analyze` + `flutter test` in this worktree | VERIFIED: no issues; 1185 tests pass; no tracked file changed |
| UX-2 Today has no AI on the first screen | `today_screen.dart:84-131` | VERIFIED |
| UX-3 fallback blames the AI | `app_en.arb:702` `askModelFellBack` | VERIFIED |
| REL-2 no install path on the site | `apps/web/src/lib/site.ts:15` `PLAY_STORE_URL = null` | VERIFIED |
| REL-5 test APK is debug-signed | `apksigner verify --print-certs E:/femio-builds/femio-1.0.0-test.apk` → `CN=Android Debug` | VERIFIED |
| JUDGE-3 / PRIV-1 redaction does not remove names | `redaction.dart:57-80` strips e-mails, URLs, digits only; `app_en.arb:855,1206` promise names and dates | VERIFIED |
| JUDGE-4 / SEC-7 export README describes the removed design | `export-public-app.mjs:63-75` says `ONLY_IN_CLOUD`, Google Search grounding | VERIFIED |
| JUDGE-5 "no network code" before 11 Nov | commit `18bf8c1` 2026-10-29 added AdMob | VERIFIED |
| CLIN-1 no stage change | only `recordBirth` / `periodCameBack` change goal (`app.dart:202-211`); `goalSub` promises "change this any time" | VERIFIED |
| CLIN-5 36-45 accepted then dropped | `cycle_length_step.dart:36` max 45; `cycle_prediction.dart:128` keeps 21-35 | VERIFIED |
| SEC-1 no FLAG_SECURE | grep over `android/` and `lib/` finds none | VERIFIED |
| SEC-4 KDF rounds | `envelope.dart:35` 120000 | VERIFIED |
| Phone APK carries Firebase config | `classes.dex` of the 26 Nov 14:44 APK contains one API-key-shaped string; `assistant.env` exists in the hackathon worktree since 24 Nov 21:45 | VERIFIED (values not printed) |
| The AI has run on a real phone | no evidence in `testing-results/`; STATE says not yet | NOT VERIFIED (that is finding JUDGE-1) |

## The owner's two reports

**1. Calendar shows only the past period, no future range, no fertile window.** Reproduced on
synthetic profiles (`evidence/calendar_repro.dart`, today 2026-11-26):

| Profile | Future estimate days | Fertile days |
|---|---|---|
| stated 28, one start (R8.10c fixed this on 26 Nov, 232bcf5) | 35 | 18 |
| **same woman logs her next period** | **8** | **0** |
| same in TTC | 8 | 0 |
| "not sure", one start | 0 | 0 |
| three regular starts | 15 | 18 |

Cause: once two starts exist the prediction switches to `basis: observed` with `learning: true`
(`cycle_prediction.dart:132-150`), which drops the stated length, cuts the ranges to one
(`upcoming_periods.dart:48`) and withholds the window (`fertility.dart` `_windowBefore`). Logging
more makes the calendar show less. Plus silent empty states (not sure, irregular, 36-45 days, no
last period) and a past range in the "Next periods" card. The Stitch artifact's 12-state table
(A-L) agrees; its fixes 1-7 are R14.7 and R14.8. Whether the owner's phone ran a build from before
R8.10c is NOT VERIFIED; the current APK (14:44) still shows state G.

**2. AI is not prominent enough.** Confirmed (UX-2, UX-8; Stitch "Where the AI shows"): the first
AI door is 9 taps from cold start; Today's Ask/Visit buttons sit 550-1250 px down; nothing names
Gemini Nano or "on this phone" outside Settings → Assistant; a judge without Nano sees no AI
output. Fixes: R14.6.

## Ranked finishing plan (by judge impact, then deadline)

Days are Cairo dates. "S" = under two hours of session work, "M" = half a day.

### Tier 0: Stage One and truth (a miss here scores zero or a false claim)

| # | Item | Findings | Who | When |
|---|---|---|---|---|
| R14.1 | **Prove hybrid AI on a real phone.** Session builds a debug APK from this branch with `assistant.env` (copy from the hackathon worktree, never into git) and a one-screen "proof" path (Settings → Assistant → What the AI did, already built). Owner runs the four demo steps (row 43); session reads logcat and the ledger. Fix whatever breaks. | JUDGE-1, UX-5, SEC-5, PRIV-15 | session S + owner 30 min | Fri 27 |
| R14.2 | **Truth pass on every claim.** Redaction wording: say "numbers, e-mail addresses and links are removed, and you see and edit the exact text before it is sent" (app ×4 with a consent-version bump, website policies ×4, listing ×4, Devpost). "What existed": "no network code of its own; an ad SDK added in October was removed on 24 Nov". Thumbnail: WHO/NHS/ACOG are further reading. Testing steps: sideload steps, the real "+" → "Tell femio anything" path, a question without "we", the honest no-Nano path. Video "then Add" → "Save". Devpost "identifiers of any kind" and "build-time tripwire" softened to what is true. | JUDGE-3, PRIV-1, JUDGE-5, UX-11, UX-14, UX-17, JUDGE-10, REL-3, PRIV-16, JUDGE-15, JUDGE-16, PRIV-8 | session S | Thu 26-Fri 27 |
| R14.3 | **Public repo exporter.** Export from `git archive HEAD`, not the working tree; rewrite the README from ADR-079 (PREFER_ON_DEVICE, no grounding, registry only); include the privacy tripwire and a CI workflow that runs it; make `flutter test` pass in the export (ship or skip the screenshot goldens); run the export into a scratch folder and run `flutter analyze && flutter test` there. Then owner says "make it public" (row 27). | SEC-6, SEC-7, JUDGE-4, JUDGE-6, JUDGE-7, JUDGE-14 | session S-M, owner 1 min | Fri 27-Sat 28 |
| R14.4 | **A judge can install and test.** GitHub Release on the public repo with the APK; Devpost and `/app` link to it (website deploy needs the owner's word); App Check posture during judging decided (row 42); the fallback message stops blaming the AI ("No AI on this phone; here are the sources word for word"). | REL-1, REL-2, REL-3, UX-1, UX-3, UX-4, JUDGE-9 | session S + owner decision | Sat 28 |
| R14.5 | **Video and assets from the real phone.** Rewrite `VIDEO_SCRIPT.md`: split diagram, status chip, Say it on Nano with a sentence the lexicon misses, Ask on the phone, one real Cloud boost run after consent, the "What the AI did" ledger. Re-shoot the Ask store shot and Devpost images on the phone; add the newer strengths (ledger, "What the AI sees", Say it over several days) to the Devpost text. Owner records and submits (row 28). | JUDGE-2, UX-9, UX-10, UX-12, JUDGE-8, JUDGE-12 | session S + owner 1 h | script Sat 28, record Sun 29, submit Mon 30 |

### Tier 1: score raisers inside the app (Design and Technological Implementation)

| # | Item | Findings | Effort |
|---|---|---|---|
| R14.6 | **Make the hybrid AI visible** (Stitch fixes 8-10): a "Say it" row under the Today hero with an "On this phone · Gemini Nano / rules on this phone / + Cloud boost" chip read from `AssistantStatus`; the assistant intro sheet as onboarding's last, skippable step; Ask femio and Visit summary moved up and named; Assistant first in Settings; tips, visit questions and Say it credit Nano when it ran (the ledger already knows); Ask icon not a globe; Today's AI buttons obey the master switch; first-run notice mentions the assistant; Arabic "+" baseline. Rule 7 holds: every door works with AI off, nothing runs a core function. Website home headline names the AI companion. | UX-2, UX-6, UX-7, UX-8, UX-13, UX-15, UX-16, UX-18, UX-19, UX-20 | S-M |
| R14.7 | **Calendar fixes without a rule change** (Stitch fixes 1, 3, 4, 5, 6, 7): an empty-state card that says why and offers the answer that fixes it; a stated 36-45 keeps the period range (window still withheld by MR-08); "Next period: Dec 1-5 →" under the month when this month has none; the "Next periods" card drops ranges already past; her "irregular" answer limits ranges to one (MR-51); the legend shows only what is drawn plus the MR-06 sentence; Today and calendar agree on a passed range. Twins + fixtures where domain changes. | CLIN-4, CLIN-5, CLIN-6, owner report 1 | S-M |
| R14.8 | **Keep her stated cycle length until three starts** (Stitch fix 2): extends MR-57; needs the owner's ruling (row 40). Dart + TS twins + `cycle-prediction.json` / `upcoming-periods.json` by hand. | owner report 1 (state G, K) | M |
| R14.9 | **MR-15 sentence wherever a fertile window is drawn**, and decide whether "Track my period" draws a window at all (row 41). | CLIN-2 | S |
| R14.10 | **Change life stage and correct onboarding answers**: Settings → "What femio helps with" (period ↔ TTC ↔ pregnant with due date or last period ↔ perimenopause; rule 5 re-layers, never deletes) and "My cycle answers" (cycle length, period length, irregular, due date after a scan, MR-27). The loss path stays R8.14. | CLIN-1, CLIN-3 | M |

### Tier 2: before the Play release (after the deadline unless a session is idle)

| # | Item | Findings |
|---|---|---|
| R14.11 | Clinical P1: the day note runs the safety rules; after-birth mood check-in gets the crisis route; menopause "Not sure" false fact; MR-10 90-day prompt; irregular test-day rule (MR-21 wording); CDC Hear Her list (row 44); `pregOverdue` stays R9.2 (owner) | CLIN-7, CLIN-8, CLIN-9, CLIN-10, CLIN-11, CLIN-12, CLIN-13 |
| R14.12 | Clinical P2: 10-day bleed phantom period; estimates drawn like facts; single ovulation day; window check uses observed length; MR-58..61 shared fixtures and register "Today" cells; BMI labels as verdicts; movement-log heuristic | CLIN-14..CLIN-20 |
| R14.13 | Security: FLAG_SECURE (after the video is recorded, or as a setting, since it blocks screen recording); PIN backoff; PBKDF2 → 600k or Argon2id with the stored count honoured on import; import caps and order of checks; PIN-wrapped record key (ADR); release fails without `key.properties`; widget respects the lock; shared-file cache cleanup; current merged manifest checked in the tripwire; web CSP trade-offs recorded | SEC-1..SEC-4, SEC-8..SEC-17 |
| R14.14 | Privacy wording and guard: website policies ×4 name the health record, documents and photos, medicines and labs (R11.2a); birth-year purpose; medicine reminder shows her words; list sharing and CSV export; `NEXT_LOCALE` cookie; receipt stores the language; unencrypted widget/notification text named; tripwire extended to Kotlin network code, Gradle SDKs and merged manifests; ML Kit GenAI telemetry settled by the traffic capture (row 33) before the Data safety "Device or other IDs" answer; consoles checked (rows 29-31) | PRIV-2..PRIV-7, PRIV-9..PRIV-14 |
| R14.15 | Release: start the closed test (12 testers × 14 days; earliest production about 17 Dec if it starts now); upload-signed .aab (the keystore exists, REL-6); Data safety doc refresh (image_picker, billing probe); listing headers not ALL CAPS; FR/ES screenshots; firebase-ai-ondevice beta keep rules | REL-4..REL-12 |
| R14.16 | Merge the branch to `main` and deploy the website (owner's word), so the live site is not behind the app it describes | REL-13 |
| R14.17 | DEFERRED: a web (Chrome) hybrid demo of Ask femio for the multi-platform preference; other Firebase products (Remote Config or Auth would add installation ids, against ADR-080) | JUDGE-11, JUDGE-13 |

## What is verified, and where

- **Local code, verified by the lead:** the sample checks above, the gate, the calendar repro.
- **Live site, verified by agents with curl/fetch on 2026-11-26:** pages return 200 in four
  locales; strong security headers; no third-party scripts; Vercel Web Analytics 404 (not enabled);
  privacy pages carry an effective date of 30 Nov; every "Get the app" is "Coming soon".
- **Not verified anywhere:** the AI on a real phone or a real Firebase project; network traffic of
  the release build (ML Kit telemetry, App Check, Firebase heartbeat); the merged manifest at
  `fb45488`; console settings (paid tier, logging off, data sharing off); which commit Vercel
  serves; whether the owner's phone build predated R8.10c.
