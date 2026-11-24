# Competitor APK teardown — 2026-11-24 (R8.28)

**For agents.** Khaled reads the owner page published from this file, not the file itself (link in
the R8.28 line of `PROGRESS.md`). **Asked by:** the lead session for the combined R8 plan, on the
owner's three downloads. **Accepted items** are R9.x lines in `docs/33_REBUILD_V3/PROGRESS.md`;
where an R8 line already covers a finding, the note sits on that R8 line.

**Method.** Each APK was copied into its own empty folder under `E:\re\2026-11-apk\<app>\` and
decompiled with jadx 1.5 (`--deobf`). Nothing was installed or run. Scripts live apart in
`E:\re\2026-11-apk\_scripts\` and ran with `python -I`. Private evidence notes, with file and line
pointers, are in `E:\re\2026-11-apk\NOTES.md` (outside the repo). **Nothing from these apps (code,
text, images, week content, data) is copied into femio.** Features are described in our own words.

**Evidence labels.** **[code]** = seen in the decompiled code, manifest, resources or bundled
assets. **[inferred]** = a reasonable reading that was not traced end to end. **[not verified]** =
looked for and not settled. Per the August meta-lesson (`docs/28_TEARDOWN/11_FINDINGS_LEDGER.md`
§2): reading a binary shows what was *built*, not what users *reach*. None of these apps was run.

**No new medical facts.** Where a recommendation needs one, it says `[NEEDS SOURCE]`.

---

## 0 · The three apps

| Short name | Package, version | Publisher | Shape |
|---|---|---|---|
| **P** (pregnancy) | `com.easymobs.pregnancy` 1.4.75 **[code]** | "Amila" per its bundled privacy text and site host **[code]**; legal entity **[not verified]** | Single-activity Compose app, code obfuscated; 27 content locales **[code]**. Not the app from the August teardown (that was `com.teamthree.pregnancytracker`). |
| **C** (period calendar) | `com.popularapp.periodcalendar` 1.80.370 **[code]** | Simple Design / ABISHKKING, from its hosts and contact address **[inferred]** | 238 activities plus a Compose "new UI"; 44 locale folders **[code]** |
| **T** (period tracker) | `periodtracker.pregnancy.ovulationtracker` 1.122, code under `com.northpark.periodtracker` **[code]** | Same family as C: shared libraries and many identical strings **[inferred]** | 172 activities; 44 locale folders **[code]** |

Arabic coverage of the app-owned English strings: P 482/497 (97%), C 2,746/3,096 (89%),
T 1,357/1,743 (78%) **[code]**. None shows Hijri dates, Western-digit pinning or any Ramadan or
religious content **[code: no matching strings]**. RTL quality is **[not verified]** (not run).

## 1 · Per-app feature inventory

### 1.1 P — pregnancy tracker

**Screens and tools [code, from strings, drawer and models]:** home dashboard with the current week,
trimester and days left; a size comparison and baby dimensions; week browser; daily update card;
calendar and diary (mood, symptoms, notes, appointments, with filters and search); kick counter;
contraction counter; weight tracker with an "expected gain" band from height and pre-pregnancy BMI;
Kegel trainer with levels and daily workouts; meal plan with recipes; trimester shopping lists;
bump photo gallery; trimester chart; "baby born" registration (date, time, sex, weight, height)
that stops pregnancy tracking; data transfer by file between phones; spreadsheet (CSV) export by
email; two home-screen widgets (circular and linear); rate-us and article feedback prompts.

**Week-by-week content structure [code: `assets/text/<locale>/`]:**

| Folder | Unit | Fields per item | Count (EN) |
|---|---|---|---|
| `weeks-baby/<0..42>` | cards per week | id, date, image, title, body paragraphs; category (what the baby can do, organs developing, facts) | 109 cards |
| `weeks-mother/<0..42>` | cards per week | same fields; category Symptoms, Interesting, Nutrition, Sport | 149 cards |
| `daily_update/<week>_<day>` | one card per day | one short paragraph | 287 (weeks 0–40 × 7) |
| `baby-fruit-mapping.json` | per week from 4 | a fruit or seed name | — |
| `common/baby-dimensions.json` | per week from 5 | length range, weight range (crown-to-rump before week 20, head-to-toe after, explained in a one-off card) | — |
| `food/` | recipe | title, image, prep/cook time, servings, ingredients, directions | 58 |
| `shopping/trimester1..3` | item card | description, body, an Amazon affiliate link block | 3 files |

No content file carries a citation, a link, a reviewer or a review date **[code: zero files contain
a URL; no reviewer field]**. The `date` field on every card is a build date, not a review date
**[inferred]**.

**How it counts weeks [code: `xl2.m19764h`, `fm0.java`, `C1881zu`, `dd0`]:**
- Due date = last period + 280 days.
- Week = whole weeks since the last period, clamped to 1–42 (so days 0–13 both show week 1).
- The daily card is picked by (days since last period) mod 7, so **both the week and the daily card
  turn over on the weekday of the last period**. Same convention as femio (`domain/pregnancy.dart`:
  completed weeks plus days).
- A circular progress ring fills by days/280; a "days left" countdown sits under it.

**Reminders [code]:** a notification scheduler with boot re-arm, an events channel and an
"in progress" channel for running kick or contraction sessions; the text of scheduled reminders is
**[not verified]** (obfuscated).

**Onboarding [code, strings]:** welcome → due date or last period → privacy consent (age 16+,
terms, ads consent, analytics opt-in).

**Paywall [inferred]:** Play Billing is present and only a thank-you string exists; most likely
"remove ads". What premium unlocks is **[not verified]**.

**Money from content [code]:** Amazon baby-registry promotion card and affiliate links inside the
shopping articles; a cross-promotion for the publisher's baby-tracker app.

### 1.2 C — period calendar

**Navigation [code: `NavHostEnum`]:** Today, Calendar, Self-care, Analysis tabs; plus cycle history
editing, pregnancy history editing, temperature, weight and BMI, Kegel, water chart, symptom top list
and symptom analysis, fertility report, ovulation-test report, breast-check report, cramps-relief
workouts, soundscapes, themes with virtual pets, FAQ, help-translate and help-correct.

**Logging [code: entry screens]:** period and flow, symptoms, moods, notes, temperature, weight,
height, intercourse (with or without condom, frequency charts), contraception (pill with placebo
days, implant, injection, IUD, patch, ring, each with a looping reminder), water.

**Calendar and prediction [code: strings; algorithm partly inferred]:**
- Future periods and ovulation are drawn as predictions; a "smart prediction" switch exists.
- Ovulation and fertile days follow from the luteal-phase length, which she can adjust.
- **Fertile days are hidden when the cycle is under 21 days**, with an in-app explanation, and she
  can hide fertile days entirely.
- Analysis unlocks after 3 logged cycles; irregularity is flagged with a 9-day variation rule and
  advice to see a clinician.
- How many future periods it draws is **[not verified]**; the calendar marks prediction cells in
  any month she scrolls to **[inferred]**.

**Pregnancy mode [code]:** switches from cycle to pregnancy, with week content, a size comparison,
due-date calculation, and an end choice that covers **delivery or miscarriage**; she logs her first
period after pregnancy to restart analysis.

**Partner mode [code]:** pairing code, an account, the partner sees history, phase and predictions,
gets push notices of her phase changes and daily logs, a daily couple quiz, nicknames, and a partner
message when her period is late.

**Other [code]:** community forum (topics include "could I be pregnant" and birth control); Google
Drive, Dropbox and Gmail backup with a monthly backup reminder; PIN, password and fingerprint;
four widgets (cycle day, period, ovulation, all); water and cycle-phase reminders; themes, pets,
rewarded ads to unlock items, free trial, "remove ads forever".

### 1.3 T — period tracker

**Screens [code: activities]:** welcome and goal questions, period and ovulation prediction
settings, notes (sex, weight, temperature, sleep), charts (period, symptoms, weight, sleep, water,
temperature, sex, breast checks), **PDF preview of a report**, pregnancy mode with a calculator and
baby-born screen, contraceptive settings, Google Drive backup and cloud-account deletion, PIN,
themes, workouts and poses, soundscapes, breast self-check with reminders, and an **ovulation-test
scanner** that photographs a strip and returns a result, plus a test report.

**Content [code]:** "Insight" story cards with a reference label and a feedback form; a 70-plus mood
list (several sexual); cervix position and texture logging; a breast self-check guide with an
unsourced cancer statistic.

**Claims [code: strings]:** a days-late counter; conception chance as high, medium or low; a
marketing line that the app makes conception three times faster (no source in the app).

## 2 · What femio must NOT copy (seen in these apps)

| Pattern | App | Rule it breaks |
|---|---|---|
| A days-late counter on the cycle | C, T **[code]** | Rule 3 (no late counter) |
| A days-past-due counter for the baby | C **[code]** | Rule 3; see the femio self-finding in §6 |
| Conception chance as High / Medium / Low, and "chance is really low" on some days | C, T **[code]** | Rule 3 (no verdicts); rule 1 (reads as a way to avoid pregnancy) |
| "Three times faster to conceive" | T **[code]** | Rule 1, unsupported claim |
| Contraceptive pill, ring, patch, injection and IUD schedules | C, T **[code]** | Rule 1 (never a way to avoid pregnancy) |
| Ovulation-strip photo that returns a result | T **[code]** | Rule 1; MR-16 (already rejected, R8.25) |
| Partner gets push notices of her phases, logs and a late period, through an account and server | C **[code]** | Rule 4 (records never leave the phone) |
| Forum and couple chat | C **[code]** | OD-8 (no chat) |
| Intercourse charts, condom logging, sexual moods, "orgasm every" | C, T **[code]** | OD-5, MR-47 |
| Ads, rewarded ads, ad ID, attribution and TikTok events | all **[code]** | Rule 4, ADR-080 |
| Amazon affiliate links inside health articles | P **[code]** | Rule 4 spirit; editorial independence |
| Health content with no source, reviewer or review date; an unsourced cancer statistic | P, T **[code]** | Medical-content rule (Tier 1/2 or `[NEEDS SOURCE]`) |
| Progress ring for pregnancy | P **[code]** | Dusk Bloom §7.8 (no rings) |
| A single "due date" with a countdown and no range | P **[code]** | Rule 3 (femio already notes the date is an estimate) |
| Photo-style images in week cards (file names suggest people and fetuses) and a bump photo gallery | P **[inferred from image paths; gallery code]** | §7.8 (no photos of people); R8.25 deferral |
| Consent at 16+ | P **[code]** | femio is 18+ (MR-48) |

## 3 · Gap table

Columns: feature · which app · femio today (**have / partial / missing**, read in
`apps/mobile/lib/` on this branch) · recommendation · femio rule it touches. "R8.x" means already
accepted; "R9.x" means a new line from this teardown.

| Feature | App | femio today | Recommendation | Rule |
|---|---|---|---|---|
| Week-by-week baby and body content | P, C | **partial**: 37 reviewed week guides (4–40) in four languages, in Learn; no weekly view yet | **Do better** (R8.6): ours are sourced and reviewed; theirs carry no source at all | 1, medical-content |
| Daily line inside the pregnancy week | P | **missing** | **Do better** (R9.1): one short line a day drawn from that week's reviewed guide sections; no new medical text | 1, 2 |
| Size comparison by week | P, C, T | **missing** | **Do better** (R8.17): only what our guide states; drawn object, never photos | 1, §7.8 |
| Baby length and weight range by week | P | **missing** | **Adopt as a range** inside R8.17 if the reviewed guide gives it; otherwise `[NEEDS SOURCE]` | 1, 3 |
| Week and day turnover on the last-period weekday | P | **have** (`domain/pregnancy.dart`) | Keep; add the guide-file mapping to the R8.7 fixture (which guide shows at 4w0d) | 3 |
| Trimester map / month view of the pregnancy | P | **missing** | **Adopt** inside R8.6 (week calendar), no ring | §7.8 |
| Due-date countdown | P, C, T | **have** ("days to go" plus an estimate note) | Keep; show the full-term window beside it (data exists: `termStart`) | 3 |
| Days past the due date | C | **have** (`pregOverdue` counter) | **Change** (R9.2): see §6 | 3 |
| Kick counter | P | **have** (movement log, with slower-movement guidance) | Keep; ours is safer | MR-29 |
| Contraction timer | P | **have** | Keep | — |
| Pregnancy weight tracker | P | **partial**: entries and change, no reference band | **Adopt carefully** (R9.3): a reference band by pre-pregnancy BMI only after a register row cites it `[NEEDS SOURCE]`; never a verdict colour | 1, 3 |
| Appointments | P | **have** (screen) | **Add a reminder** for a saved appointment (R9.4) | 4 (neutral text) |
| Supplement / own-medicine reminder | C (as pill) | **missing** | **Adopt, never for contraception** (R9.4): her own label, neutral text | 1, 4 |
| Kegel / pelvic-floor guided timer | P, C | **missing** | **Adopt** (R9.5) with sourced instructions `[NEEDS SOURCE]` | 1 |
| Recipes and meal plan | P | **missing** | **Skip**: unsourced nutrition advice is a liability; the guides carry the food-safety content | 1 |
| Shopping lists with affiliate links | P | **missing** | **Do better** (R8.16 checklists): no affiliate links, ever | 4 |
| Bump photo gallery | P | **missing** (deferred, R8.25) | Keep deferred | 4, §7.8 |
| Baby born, then stop tracking | P, C, T | **partial**: `birthDate` field, hero switches to weeks since birth; no flow | **Do better** (R8.14, R8.19): postpartum view, data kept | 5 |
| Pregnancy end with a loss option | C | **missing** | **Do better** (R8.14): a kind screen and reminders stopped; C proves the need exists | 5, MR-35 |
| Next periods drawn ahead on the calendar | C, T | **partial**: next period only | **Do better** (R8.10): three ranges that widen; none when irregular | 3, MR-01, MR-06 |
| Fertile days hidden when cycles are short | C | **have in spirit** ("no confident window") | Keep; add a "why no window" sheet (R9.6) | 3 |
| Adjustable luteal phase | C, T | **missing** | **Skip as a setting**: a user-set luteal length invents precision; our window comes from the register (MR-07) | 3 |
| "Why is my prediction like this?" FAQ | C | **partial** (prediction note) | **Do better** (R9.6): a sheet built from her own evidence (cycles used, spread, rule) | 3 |
| Cycle analysis after N cycles; irregularity notice | C | **missing** (R8.5 Patterns) | **Do better** (R8.5); the variability seek-help wording needs a register row (R9.7) | 1, 3 |
| Symptom statistics | C, T | **missing** | Covered by R8.5 ("seen in N of M cycles") | 3 |
| Temperature chart | C, T | **have** (BBT chart, TTC) | Keep; R8.8 adds signs side by side | MR-16/17/18 |
| Cervical position and texture | T | **missing** | **Skip**: low use, intimate, adds little over mucus | OD-5 |
| Ovulation-test result log | C, T | **have** (OPK chips) | Keep; no photo reading | MR-16 |
| Free-text note on a day | P, C, T | **missing** (day record has flow, terms, OPK, BBT only) | **Adopt** (R9.8): a local note, inside the encrypted record and backup, readable by Say it | 4 |
| Moods | P, C, T | **have** (short clinical list) | Keep; their 70-plus list includes sexual moods (OD-5) | OD-5 |
| Water and sleep logs | C, T | **missing** | **Skip for now**: not in the wedge; revisit with Patterns | scope |
| Self-care audio, workouts, cramps exercises | C, T | **missing** | **Skip**: needs content and licences; guides cover pain relief | 1 |
| Breast self-check reminders | C, T | **missing** | **Skip the tracker**; a sourced guide on breast awareness is possible (R9.9) `[NEEDS SOURCE]` | 1 |
| PDF report for the doctor | T, C (report pages) | **partial**: visit summary on screen | Covered by R8.24 / R8.27 (one-page document through the share sheet) | 4 |
| Spreadsheet export of her logs | P | **missing** (encrypted backup only) | **Adopt** (R9.10): CSV through the system share sheet, she chooses where | 4 |
| Phone-to-phone transfer | P, C, T | **have** (encrypted backup file) | Keep; ours is passphrase-sealed, theirs are plain files or cloud accounts | 4 |
| Cloud backup (Drive, Dropbox, Gmail) with an account | C, T | **missing by design** | **Skip**: the file she saves is the backup | 4 |
| PIN / fingerprint lock | C, T | **have** (PIN) | **Adopt** fingerprint unlock beside the PIN (R9.13) | 4 |
| Home-screen widgets | P, C, T | **missing** | **Adopt, neutral** (R9.11): no health words on the home or lock screen unless she turns them on | 4 |
| Themes, pets, discreet icon | C, T | **missing** | Covered by R8.24 (themes and a discreet icon as Plus); **no pets or gamification** | — |
| Partner mode | C | **missing** (deferred, R8.25) | Keep deferred; their design needs an account and pushes her late period to the partner | 4 |
| Forum, couple quiz, chat | C | **missing by rule** | **Skip** | OD-8 |
| Contraception logging and reminders | C, T | **missing by rule** | **Skip** | 1 |
| Rate-us and article feedback prompts | P, T | **missing** | **Adopt the feedback half** (R9.12): a "this was unclear" link on guides and a "report a wording problem" entry for translations, sent through her mail app; no rating nag | 4 |
| Help-translate and help-correct screens | C, T | **missing** | Folded into R9.12 | — |
| Languages | P 27, C and T 44 | **have** 4 | Keep four; ours are reviewed. None of theirs shows Hijri or Western-digit control | 6 |

## 4 · Top 15 "beat them" ideas (ranked)

Ranked by value to the wedge (TTC → pregnancy, PCOS, Saudi Arabia and Egypt) against effort, and
only where femio can be clearly better while keeping its rules.

1. **Sourced, reviewed weekly view (R8.6) against unsourced cards.** Every competitor's week content
   has no citation, reviewer or date; ours has all three. Show the reviewer line and sources on the
   weekly card itself.
2. **A daily line from the reviewed guide (R9.1).** Their daily card is the habit loop; ours can be
   the same loop with zero new medical text.
3. **Predictions she can understand (R8.10 + R9.6).** Three widening ranges and a "why" sheet built
   from her own numbers, where they offer one date and a days-late counter.
4. **Pregnancy end done kindly (R8.14).** C has the choice buried in a menu; femio gives her own
   words, a quiet screen, reminders stopped and data kept.
5. **Privacy you can check (R8.21).** Their APKs carry six to ten ad networks each; femio's "what can
   leave this phone" page lists one opt-in path.
6. **Postpartum view (R8.19)** where all three simply stop.
7. **Signs side by side (R8.8)** instead of a camera that "reads" a strip.
8. **Patterns that count, not judge (R8.5).** Their analysis flags "abnormal"; ours says "seen in N of
   M cycles" and routes worry to the seek-help rules.
9. **Neutral widget (R9.11)** that shows nothing health-related on the lock screen unless she opts in.
10. **Spreadsheet export she controls (R9.10)** next to the sealed backup, where theirs email plain files
    or need cloud accounts.
11. **Visit pack as one page through the share sheet (R8.27)** against T's PDF, which only it can print.
12. **Supplement and appointment reminders with neutral text (R9.4)**, never contraception.
13. **Free-text day note inside the encrypted record (R9.8)**, which Say it can also read on the phone.
14. **Pelvic-floor timer with sourced steps (R9.5)**, without levels, streaks or birth promises.
15. **A feedback path for wording and translation (R9.12)** so Arabic stays first-class without a rating
    nag or an account.

## 5 · Privacy contrast

| | P (pregnancy) | C (period calendar) | T (period tracker) | femio app |
|---|---|---|---|---|
| Ad networks in the APK | AppLovin MAX, Google ads **[code]** | Meta Audience Network, Bigo, InMobi, Pangle/ByteDance, Moloco, Vungle, AppLovin, Google ads **[code]** | Meta Audience Network, Bigo, InMobi, Pangle/ByteDance, Moloco, myTarget, Google ads **[code]** | None (ADR-080, tripwire) |
| Analytics / attribution | Firebase Analytics (off until consent), Crashlytics, Remote Config, A/B testing **[code]** | Firebase, TikTok app events, ByteDance APM **[code]** | Firebase, TikTok app events, ByteDance APM **[code]** | None |
| Advertising ID permissions | Yes (AD_ID, ad-services topics and attribution) **[code]** | Yes **[code]** | Yes **[code]** | Removed (ADR-080) |
| Account or cloud | No account; Firebase Realtime DB host present **[code]**, use **[not verified]** | Account for partner mode and sync; Drive, Dropbox, Gmail **[code]** | Cloud account, Drive **[code]** | No account, no server; she saves her own sealed file |
| Health data off the phone | Its own privacy text lists last period, due date, kicks, contractions, weight and notes as collected, with targeted advertising among the purposes **[code: bundled privacy.html]** | Partner sees history, phase, predictions and daily logs **[code]**; ad SDKs receive device data **[inferred]** | Cloud backup of records **[code]**; ad SDKs receive device data **[inferred]** | Never; Cloud boost (opt-in, per-purpose receipt) sends only a redacted question or four-band profile |
| Age gate | 16+ checkbox **[code]** | Birth year asked **[code]**; minimum **[not verified]** | **[not verified]** | 18+ as a domain rule |
| Lock | none seen | PIN, password, fingerprint **[code]** | PIN, fingerprint **[code]** | PIN; backup sealed with a passphrase |
| Camera / storage | Photo picker and cropper for bump photos; no camera permission **[code]** | External storage read/write **[code]** | Camera, external storage **[code]** | None |

Network hosts named in their own code (not exhaustive; SDK hosts excluded): P `pregnancy.amila.io`
and a Firebase Realtime Database; C `period-calendar.com` subdomains, `partner.simpledesign.ltd`,
`pc.abishkking.com`; T a Firebase Realtime Database **[code]**.

## 6 · Corrections and self-findings

1. **The persona review said no competitor offers a loss path** (`PERSONA_FEATURES_2026-11.md` §3.2
   rank 3, §3.3). **C does**: its pregnancy end choice covers delivery or miscarriage **[code:
   strings]**. femio can still lead on how it is done (R8.14), but not on having it. Noted on R8.14.
2. **femio shows a days-past-due-date counter** (`pregOverdue`, "N days past your due date",
   `features/today/pregnancy_hero.dart`). That is the pregnancy twin of the late counter rule 3
   forbids for cycles. Proposed: replace with an estimate sentence ("your estimated due date has
   passed; full term runs from …") and the red-flag entry, no number. **Owner decision**, then a
   register row (R9.2).
3. **Week numbering is the same convention as P** (completed weeks plus days, turnover on the
   last-period weekday). What R8.7's fixture must still pin: **which week guide shows at 4w0d** and
   whether the label reads "week 12" or "12 weeks" in each language. Noted on R8.7.
4. P's weekly card shows a crown-to-rump to head-to-toe switch at week 20 with an explainer; if
   R8.17 shows lengths, the same switch needs saying, sourced `[NEEDS SOURCE]`.

## 7 · What this teardown did not do

- Run any app (August's rule: binary ≠ reach). Reminder texts, paywall contents, RTL quality and
  the number of future periods drawn by C and T are **not verified**.
- Read C's encrypted asset blobs (`contents`, `dic`, `permission`).
- Read every locale; Arabic was compared for coverage only, not quality.
