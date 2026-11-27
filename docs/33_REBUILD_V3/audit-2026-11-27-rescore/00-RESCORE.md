# Re-score, 27 Nov 2026: main `3a92a90` against the 26 Nov audit

Six independent role reviewers re-scored main `3a92a90` against the 26 Nov audit
(`../audit-2026-11-26/`, commit `fb45488`), each with the same rubric. They read the code, ran the
tests, checked the signed builds and fetched the live site at femioapp.com. Each role's full report
is in this folder (`01`–`06`). The lead sample-checked the two P0 claims (section 3) and adjusted
one score (privacy).

Scale: 1–10 as on 26 Nov. The judge row also shows Devpost's official 1–5 average. Numbers come
from the code, tests on synthetic fixtures, and the live site. Nothing was run on a real phone, and
no real Gemini Nano or Firebase call was made.

## 1 · Scores

| Area | 26 Nov (lead) | 27 Nov (lead) | Role reviewer said | What moved it |
|---|---|---|---|---|
| Security | 7 | **8** | 8 | PIN wait, 600k backup KDF (hand-written PBKDF2 matches published vectors and the package), import caps, release signing guard, widget lock, share cleanup; 47 security tests pass |
| Privacy | 7 | **8** | 9 | False "names removed" claim gone (consent v2); ML Kit telemetry disclosed in the app and on the live policy; policies name the whole record. Lead keeps 8: the traffic is still unproven, and two live legal-page slips remain (section 2) |
| Launch readiness | 5 | **6** | 6 (hackathon 6, Play 3) | Upload-signed `.aab` and APK exist; honest test-build card on the live `/app`. No public repo, no APK link, no closed test |
| Feature maturity (stages) | 5 | **6** | 6 | Life-stage change and answer correction in Settings, honest calendar, clinical P1 fixes. By stage, 26→27 Nov: period 6→7.5, trying to conceive 5→6.5, PCOS 3→4, pregnancy 6→6.5, after birth 6.5→7.5, loss 1→2, menopause 6→7 |
| Hybrid-AI showcase | 4 | **6** | 6 | The AI is on Today's first screen (status chip, Say it), there is an assistant intro in onboarding, and the first AI result is 2 taps away instead of 12. It has still never run for real |
| Presentation and polish | 6 | **7** | 7 | Live headline names the AI companion; thumbnail and Arabic "+" fixed. Store shots still show no AI |
| Official criteria (Devpost) | 7.0 (3.5/5) | **7.4 (3.7/5)** if Stage One passes | 7.4 | By criterion, 26→27 Nov: Tech 6→6.5, Design 8→8.5, Impact 7→7, Idea 7→7.5. **Stage One still fails today:** no public repo, video, APK link or submission |

Finding counts, old findings only (fixed / partly fixed / open / not verified):

| Area | Fixed | Partly fixed | Open | Not verified |
|---|---|---|---|---|
| Security | 8 | 6 | 3 | 0 |
| Privacy | 8 | 4 | 3 | 1 |
| Release | 3 | 6 | 3 | 1 |
| Clinical | 14 | 4 | 2 | 0 |
| UX | 10 | 7 | 3 | 0 |
| Judge | 10 | 3 | 3 | 0 |

New findings: 24 in all (SEC 5, PRIV 3, REL 4, CLIN 4, UX 5, JUDGE 4).

## 2 · Biggest remaining gaps, ranked across all roles

| # | Gap | Who | Roles |
|---|---|---|---|
| 1 | **The signed APK and `.aab` in `E:/femio-builds` have no Firebase configuration.** The project ID and API key appear 0 times in the APK's code (lead-checked, counts only). The build (02:58) ran before `assistant.env` reached `E:\Femio\apps\mobile` (06:21). On that APK every AI feature runs on rules only, so no hybrid AI for judges. Fix: rebuild and re-sign both now that the file exists, and add a release-time check that refuses a build with no Firebase config | **Buildable** (session rebuilds; the key is on this PC) | JUDGE-N2-2, SEC-N2-2 |
| 2 | **The hybrid AI has never run on a real phone or real Firebase**: no Nano run, no Cloud boost run, no ledger proof. The video depends on it | **Owner-only** (phone, row 43) | JUDGE-1, UX-5, SEC-5 |
| 3 | **Stage One items:** public repo, GitHub Release with the APK, `APK_DOWNLOAD_URL` set and redeployed, video, Devpost submission. Devpost still holds the `<APK link>` placeholder | **Owner-only**; a session wires the link once the release exists | REL-1, REL-N2-1, REL-N2-3, UX-4 |
| 4 | **The public export would publish with red CI.** `scripts/analytics-lint.mjs` imports `scripts/lib/android-tripwire.mjs`, which the exporter did not copy (lead-checked). Fixed on this branch in the commit after this report | **Buildable** (done) | JUDGE-N2-1 |
| 5 | **App Check console settings** for a sideloaded APK (`RELEASE_STEPS.md` section C), plus the API-key restriction | **Owner-only** (console) | REL-N2-2, SEC-8 |
| 6 | **Traffic capture:** the signed APK starts ML Kit, Firebase and Google's telemetry transport at launch, before any consent; what is actually sent is unproven. It decides the Data safety ID answer | **Owner-only** (phone); an emulator pre-check is buildable | SEC-5, SEC-N2-3, PRIV-2, PRIV-15 |
| 7 | **Second pregnancy after a birth recorded in femio keeps the old birth date.** She sees the after-birth view: no week guide, no pregnancy red-flag card, no pregnancy warning signs in Ask or Say it (`onboarding_flow.dart:186-187`, `profile.dart:355`, `safety.dart:436`) | **Buildable** (P1 safety) | CLIN-N2-1 |
| 8 | **No pregnancy-loss path.** Switching stage is the only route, and it shows pregnancy-test prompts and keeps appointment reminders firing | **Owner-only** wording (MR-35), then buildable | CLIN-1, CLIN-N2-3 |
| 9 | **Live legal pages.** Consumer-health-data says "Nobody, except Cloud boost" but omits the report sheet and sharing; the effective date 2026-11-30 is in the future; Vercel Analytics returns 404 | Wording and date **buildable**; analytics toggle **owner-only** | PRIV-N2-1, PRIV-9 |
| 10 | **Smaller buildable items:** the website still says "Obese" in the weight-gain calculator (CLIN-N2-4); the "N days past your due date" counter (CLIN-7, owner decision first); FLAG_SECURE for users without a PIN; the PIN wait can be skipped by setting the clock forward (SEC-N2-1); store shots show no AI (UX-9) | Buildable (CLIN-7 needs a decision) | as named |

## 3 · Lead sample-checks

- **No Firebase config in the signed APK (gap 1):** confirmed.
  - `E:/femio-builds/femio-1.0.0-test.apk` (27 Nov 02:58) has 0 occurrences of the project ID from `assistant.env` and 0 strings shaped like an API key across all its `.dex` files. Only counts were printed.
  - `E:\Femio\apps\mobile\assistant.env` is dated 27 Nov 06:21, after the build.
- **Exporter misses the tripwire library (gap 4):** confirmed.
  - `scripts/analytics-lint.mjs:40` imports `./lib/android-tripwire.mjs`.
  - `scripts/hackathon/export-public-app.mjs` `ARCHIVE_PATHS` lists only `scripts/analytics-lint.mjs`.
- **Scores:** the five role scores were taken as given after reading each summary against its report. Privacy was lowered from 9 to 8 for the reasons in section 1.

## 4 · Not verified

- Anything on a real phone: Nano, Cloud boost, FLAG_SECURE, the widget, KDF speed, reminders, the minified build's AI paths.
- App Check for a sideloaded APK. CI on GitHub's Linux runners. The Play Console, the closed test and the account date.
- The emulator smoke test of the signed build: no log was stored, so the judge reviewer could not confirm it. The lead's own smoke run on 27 Nov used a debug-signed release build.
