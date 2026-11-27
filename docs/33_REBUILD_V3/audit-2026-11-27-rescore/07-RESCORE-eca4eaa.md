# Second re-score, 27 Nov 2026: main `eca4eaa` against `3a92a90`

Four role reviewers re-scored main `eca4eaa`, which adds R14.20 to R14.23 and ADR-085, with the
same rubrics as files `01`–`06`:
- `v2-04-clinical-maturity.md`
- `v2-02-privacy.md`
- `v2-05-ux-ai-showcase.md`
- `v2-06-judge-criteria.md`

Security and release were not re-scored; their scores carry over from `00-RESCORE.md`. The lead
sample-checked one or two claims from each report (section 3). Numbers come from code, synthetic
fixtures and the live site. Nothing ran on a real phone or a real model.

## 1 · Scores

| Area | 3a92a90 | eca4eaa (lead) | Reviewer said | What moved it |
|---|---|---|---|---|
| Security | 8 | **8** | not re-scored | — |
| Privacy | 8 | **8** | 9 | **Fixed:**<br>- the health-data recipients and dates (PRIV-N2-1, PRIV-9);<br>- what the report sheet shows is what it sends;<br>- the wizard asks per purpose with nothing pre-ticked, and consent v3 makes older consents lapse.<br>**Lead keeps 8 for two new P1s:**<br>- withdrawing still asks for ticks (PRIV-N3-1);<br>- "Nothing is sent" is back for on-phone AI, against the ML Kit disclosure (PRIV-N3-3).<br>The traffic is still unproven. |
| Launch readiness | 6 | **6** | not re-scored | The signed APK and `.aab` now carry the Firebase ids (both the judge reviewer and the lead checked; counts only). There is still no public repo or APK link. |
| Feature maturity (stages) | 6 | **6.5** | 6.5 | By stage, 3a92a90 → eca4eaa:<br>- period 7.5 → 7.5<br>- trying to conceive 6.5 → 7<br>- PCOS 4 → 4<br>- pregnancy 6.5 → 7 (CLIN-N2-1 fixed)<br>- after birth 7.5 → 7.5<br>- **loss 2 → 5**<br>- menopause 7 → 7 |
| Hybrid-AI showcase | 6 | **6** | 6 | The wizard's step 1 is the best hybrid explainer in the app, and Check Cloud boost names why a call fails. Neither has run for real, and the judge-facing text describes UI that is gone. |
| Presentation and polish | 7 | **7** | 7 | New icon, stage row on Today, dark language page. Store shots and the Devpost steps are stale. |
| Official criteria (Devpost) | 7.4 (3.7/5) | **7.5 (3.75/5)**, only if Stage One passes | 7.5 | Tech 6.5 → 7; Design 8.5, Impact 7 and Idea 7.5 unchanged. **Stage One still fails:**<br>- no public repo;<br>- `APK_DOWNLOAD_URL` is null, and the live `/en/app` says "coming soon";<br>- no video;<br>- no submission. |

Tests the reviewers ran on synthetic fixtures (counts as they reported them): clinical 61, privacy 90,
UX 88. The public export of `eca4eaa` gives 863 tests and a clean analyze, run on Windows only.
`analytics-lint` exits 0.

## 2 · Biggest remaining gaps, ranked

| # | Gap | Who | IDs |
|---|---|---|---|
| 1 | **The hybrid AI has never run on a real phone.** The phone logcat of 27 Nov 12:41 was taken before 85bbe8e. It shows femio running but has zero AI, Firebase or App Check lines. The owner's Check Cloud boost run on the new APK is the next evidence. | **Owner-only** | JUDGE-1, UX-5 |
| 2 | **Stage One:** repo, GitHub Release with the APK, link wired, video, submission. | **Owner-only**; a session wires the link once the release exists | REL-1, UX-4 |
| 3 | **Judge-facing text describes UI that is gone.** Devpost steps 2, 6 and 7, the public README and the video shots name things that no longer exist:<br>- the "Use the assistant" switch (`assistantMasterTitle` is now unused, lead-checked);<br>- the old "I agree" Cloud boost screen;<br>- "+" → "Tell femio anything".<br>None of them mentions Check Cloud boost. The live site still shows the retired consent screen as a "real screen". | **Buildable**, small, and it moves both UX scores | UX-N3-1, UX-N3-2, JUDGE-N3-1 |
| 4 | **"One typed door" is no longer true.** Check Cloud boost is a second `ONLY_IN_CLOUD` call (`FemioAssistant.kt:177`, lead-checked) outside `CloudPrompt`. It sends one fixed sentence. Devpost line 52 and the README overstate the boundary, and the tripwire does not see the call. Fix: reword, and add a tripwire rule that allows exactly this one fixed-prompt call. | **Buildable** | JUDGE-N3-2 |
| 5 | **Withdrawing is harder than consenting.**<br>- Moving down from Cloud boost asks for 2 ticks (`ai_choices_wizard.dart:105-108`, lead-checked).<br>- Dropping one purpose means re-ticking all 3.<br>- "No AI" takes 3 screens plus a dialog.<br>- The live pages still promise "one tap" on a Cloud boost screen that is gone.<br>- ADR-085 says turning off needs no boxes. | **Buildable** | PRIV-N3-1 |
| 6 | **"Nothing is sent" for on-phone AI** (three strings) contradicts the ML Kit telemetry disclosure. On-device AI is on by default with no receipt. | Wording **buildable**; the capture is **owner-only** | PRIV-N3-3, SEC-N2-3 |
| 7 | **The seal is an unkeyed SHA-256.**<br>- Re-sealing an edit, dropping the newest withdrawal, or stripping all seals still reads "intact".<br>- ADR-085 and the code comments are honest. `aiRecordBroken` ("changed outside femio") and `aiRecordIntact` read as proof.<br>- Devpost makes no seal claim; keep it that way. | Wording **buildable**; a signed receipt needs a server (**owner-only**) | PRIV-N3-2, JUDGE-N3-3 |
| 8 | **After a loss, the "a pregnancy test is the first step" card can show** right under "We're so sorry". `periodAbsent` (`absent_period.dart:21-33`) has no exception for an ended pregnancy (lead read the code; the reviewer's run hung, so this is not run-verified). Separately, "Change" out of pregnancy skips the loss path. | **Buildable** (P1 safety-of-tone) | CLIN-N3-1, CLIN-N3-2 |
| 9 | **App Check failure text** tells a sideloading judge to "Install femio from Google Play". | **Buildable** | UX-N3, JUDGE-N3-4 |
| 10 | **Smaller items:**<br>- the save-to-record box starts ticked while its text says "unless you tick it" (`save_to_record_card.dart:42`, lead-checked; saving still needs her Save tap);<br>- a shared receipt shows her time zone;<br>- logcat gets up to 300 characters of a raw exception message;<br>- the Data safety doc still cites consent v2;<br>- the CLIN-7 past-due counter still ships ([NEEDS SOURCE] for the replacement, owner);<br>- the breastfeeding layer is two links. | Buildable, except CLIN-7 | PRIV-N3-4…7, CLIN-7 |

## 3 · Lead sample-checks

- **Builds.**
  - `femio-1.0.0-test.apk` and `femio-1.0.0.aab` were built at 13:45, after 85bbe8e (13:33).
  - The APK's dex holds the project id once and one API-key-shaped string. Counts only; nothing printed.
  - The release smoke run left no stored log, so it is not verified by the lead.
- **Seal.**
  - `cloud_consent.dart:16-21` says "not a signature".
  - `app_en.arb:937-939` claims more: "Record intact", "changed outside femio".
- **Withdrawal ticks:** confirmed at `ai_choices_wizard.dart:105-108`.
- **Save-to-record pre-tick:** confirmed at `save_to_record_card.dart:42`.
- **Stale switch:** `assistantMasterTitle` is defined but used by no Dart screen. Devpost step 6 and video shot 2:32 still use it.
- **Second cloud call:** confirmed at `FemioAssistant.kt:170-177`. It contradicts `DEVPOST_SUBMISSION.md:52`.
- **Loss card:** `periodAbsent` checks only goal, period starts and birth date (`absent_period.dart:21-33`), so CLIN-N3-1 is plausible from the code.
- **Scores:**
  - Privacy was lowered from 9 to 8 for the new P1s above.
  - The other reviewer scores were taken as given.

## 4 · Not verified

- **On a real phone:** Nano, Cloud boost, Check Cloud boost codes, App Check for a sideloaded APK, FLAG_SECURE, reminders.
- **The wire traffic** (row 33), and the console settings (paid tier, logging, App Check verdicts).
- **CI** on Linux runners, and the release smoke log for the 85bbe8e build.
