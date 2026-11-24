# Market research: what the best apps offer that femio lacks (by persona group)

Read date for every source: **2026-11-24** (the day this file was written). Method: WebFetch on the page itself; where the fetch failed and only a search snippet exists, the row says "snippet only" or "not verified". Store listings are the developers' own marketing copy; privacy labels are developer-declared and "not verified by Apple". No claim below is a medical statement of ours; competitor wording is quoted or paraphrased as theirs.

Femio status words: **has / partial / lacks / check in code**, taken from the brief's inventory (2026-11-24) plus two code checks: `apps/mobile/lib/domain/log_vocabulary.g.dart` has five discharge terms (dry, sticky, creamy, watery, eggWhite; lines 61-65) and a constant `opkResults = [negative, low, high, peak, positive]` (line 72). Whether an LH-test logging screen exists in the UI was not verified.

Short names for sources: AS = Apple App Store listing, GP = Google Play.

---

## 1. TTC / PCOS (C1, C6, C2, C3, C11, C12, B6, B5)

| Feature | Who has it | What it does for her | femio today | Source (read 2026-11-24) |
|---|---|---|---|---|
| LH test strip photo scan and quantify | Premom | Scans an ovulation test and reads a level (low/high/peak) to estimate likely ovulation | lacks (and the photo reading is out of scope for now) | Premom AS https://apps.apple.com/us/app/premom-ovulation-tracker/id1279295922 |
| LH test result logging | Flo (free listing text) ; Premom | Logs strip results next to BBT and discharge | check in code (`opkResults` constant exists; UI not verified) | Flo AS https://apps.apple.com/us/app/flo-cycle-period-tracker/id1038369065 |
| Basal body temperature chart | Premom, Clue Plus (BBT chart in Analysis tab), Natural Cycles, Flo (logging) | Charts temperature across the cycle | partial (logs BBT; chart not confirmed) | Clue Plus page https://helloclue.com/articles/about-clue/introducing-clue-plus ; NC AS https://apps.apple.com/us/app/natural-cycles/id765535549 |
| Discharge / cervical-mucus tracking | Flo, Maya (v4.x notes add cervical mucus), Ovia | Logs discharge as a fertile-sign input | partial (5 discharge terms) | Flo AS (above) ; Maya AS https://apps.apple.com/us/app/-/id492534636 |
| Dedicated Conceive mode with likely-conception-days | Clue Plus ("Clue Conceive Mode: identifies likely conception days from your period start dates") | A goal mode for TTC | has (TTC goal with fertile-window range) | Clue Plus page (above) |
| Daily fertility score | Ovia | One number for the day | lacks, and a single score conflicts with the ranges rule | Ovia AS https://apps.apple.com/sa/app/id570244389 |
| PCOS programme / AI companion | Premom "PCOS Pro" ("PCOS AI interprets BBT and OPK trends", nutrition plan); Daleela (PCOS programme, paid); Flo Premium Symptom Checker (education on PCOS etc.; not in UK/EU) ; Ovia (PCOS programmes only via employer/health plan) | Paid guided PCOS content | partial (PCOS depth in guides; no tracking programme) | Premom AS (above); Daleela AS https://apps.apple.com/us/app/id6482997617 ; Flo AS (above) ; Ovia AS (above) |
| Partner view for TTC | Natural Cycles (optional partner view), Premom "Predad", Flo for Partners, Clue Connect, Stardust, Maya | Partner sees cycle/ovulation info | lacks | NC AS ; Premom AS ; Flo AS ; Clue Plus page ; Stardust AS https://apps.apple.com/us/app/id1495829322 |
| Wearable temperature sync | Natural Cycles (NC Band, Oura, WHOOP, Garmin, Apple Watch), Clue (Apple Watch, Oura, WHOOP, Withings, Fitbit), Stardust (Apple Watch, Oura) | Auto-fills BBT | lacks (Android app; Health Connect not checked) | NC AS ; Clue AS https://apps.apple.com/app/id657189652 ; Stardust AS |
| Cycle analysis tab (cycle length average and variation) | Clue Plus | Shows her own averages and spread | lacks (no Patterns screen) | Clue Plus page |
| Ovulation/due-date calculators | WTE, BabyCenter, Pregnancy+, Tahara | Web-style calculators in-app | has (7 calculators on the web; in-app not confirmed) | BabyCenter AS https://apps.apple.com/us/app/babycenter-pregnancy-tracker/id386022579 |

**Strongest gaps for femio (TTC/PCOS), ranked**
1. No Patterns / trends screen. Clue sells it (Analysis tab: BBT, flow, average cycle length and variation); Flo downloads a cycle report; Natural Cycles sells symptom analysis. femio has the data and a visit summary but no way for her to see it.
2. LH-test logging with a results chart next to BBT and discharge (Flo and Premom). Check whether the `opkResults` constant is wired to a screen; if not, manual logging (not photo reading) is the small step.
3. PCOS: every competitor puts PCOS behind a paywall as an add-on (Premom PCOS Pro, Daleela, Flo Symptom Checker). A free, wellness-framed PCOS tracking view (cycle-length spread, symptoms over time) is a differentiator. Keep it "a screen, discuss with your clinician".
4. Partner view (read-only, opt-in). Four of the apps above have it; privacy design is the hard part for femio (no server).
5. Wearable temperature import. Lower priority for the Saudi/Egypt wedge.

---

## 2. Pregnancy (D1, D2, D3, D11, D13, D15)

| Feature | Who has it | What it does for her | femio today | Source |
|---|---|---|---|---|
| Week-by-week baby development content | Flo, Clue Plus, Ovia, BabyCenter, WTE, Pregnancy+, NC "Follow Pregnancy", Stardust, Tahara, Altibbi Mama | A page per week on baby and body | partial (week + trimester hero; 13 pregnancy tips; no per-week pages) | Flo help https://help.flo.health/hc/en-us/articles/360054523711-What-is-Pregnancy-mode-and-how-do-I-activate-it ; Clue Plus page ; Tahara AS https://apps.apple.com/sa/app/id6446452995 |
| Baby size comparison | WTE ("fruits, sports gear, snacks"), Pregnancy+ , Ovia (growth calendar), Stardust | A fruit-sized image per week | lacks | WTE AS https://apps.apple.com/app/id289560144 ; Pregnancy+ AS https://apps.apple.com/us/app/id505864483 ; Ovia AS (above) |
| 3D / AR baby models and videos | WTE, BabyCenter, Pregnancy+ (3D documentary is Premium), Stardust (3D/AR size), Ovia | Visual baby development | lacks | same AS pages |
| Daily stories or articles from week 4 | Flo ("personalized daily stories starting at week 4") | Short daily card | partial (tips card) | Flo help (above) |
| Kick / movement counter | WTE, BabyCenter, Pregnancy+ (reviewer says Premium), Ovia, NC | Logs fetal movement | has (movement log) | WTE AS ; Pregnancy+ AS |
| Contraction timer | BabyCenter, Pregnancy+, Ovia, WTE | Times contractions | has | BabyCenter AS |
| Appointments / calendar | BabyCenter, Pregnancy+, Sahiba | Visits list | has | BabyCenter AS |
| Weight log | WTE, Pregnancy+ | Weight over time | has (weight chart) | WTE AS |
| Hospital bag checklist, birth plan template | BabyCenter, Pregnancy+ | Printable planning | lacks (check in code) | BabyCenter AS ; Pregnancy+ AS |
| Symptom and food-safety lookup | Ovia ("symptom and food safety lookup tools") | Quick lookup | partial ("Ask femio" cited answers) | Ovia AS |
| Twin mode | WTE (twin mode), Flo (number of children in settings) | Adjusts for twins | check in code | WTE AS ; Flo help |
| Partner/family follow-along | Pregnancy+ (invite partners, family), Flo for Partners ("pregnancy progress"), Stardust | Shares weekly progress | lacks | Pregnancy+ AS ; Flo AS |
| Baby names | Ovia, BabyCenter, Pregnancy+, Altibbi Mama | Browse names (in Arabic: boys and girls list) | lacks | Altibbi press release https://www.zawya.com/en/press-release/al-tibbi-launches-first-arabic-app-thriving-with-reproductive-health-in-egypt-hdxg7yot (2021) |
| Photo bump diary | Pregnancy+ ("My Bump") | Visual diary | lacks (photos stay local; fits privacy model) | Pregnancy+ AS |
| Vaccination schedules by country | Altibbi Mama (developed with health ministries, per press release) | Local schedule | lacks (check scope) | Altibbi press release |
| GDM-specific tracking | none found in the listings read | n/a | lacks (market gap, not a competitor feature) | not verified: no competitor listing read mentions GDM tools |

**Strongest gaps (pregnancy), ranked**
1. Week-by-week pages for mother and baby, in Arabic. This is the baseline in every pregnancy app read (Flo, Clue Plus, Ovia, BabyCenter, WTE, Pregnancy+, Tahara, Altibbi Mama). femio has the week number, not the content.
2. Baby-size comparison and a simple weekly visual. Universal in WTE, Pregnancy+, Ovia and Stardust listings; cheap to add as illustrations (no photos of people per Dusk Bloom rules).
3. Planning checklists (hospital bag, birth plan, questions for the next visit). BabyCenter and Pregnancy+ lead with them; fits the Visit summary pattern.
4. Partner/family follow-along (opt-in, read-only). Pregnancy+ and Flo do it with accounts; femio would need a no-server design (shared file/link) or should defer.
5. Daily card from week 4 (Flo). femio's tips card can be extended to a per-week card.

---

## 3. Postpartum (E1, E2, E3, E6)

| Feature | Who has it | What it does for her | femio today | Source |
|---|---|---|---|---|
| Postpartum mode | Flo ("Postpartum Mode", page title seen in search; page not fetched), Natural Cycles (NC Postpartum: daily check-ins, postpartum bleeding tracking, expert articles, detection of returning ovulation), Ovia (12-month programme, recovery by delivery type vaginal/C-section/VBAC), Stardust (Postpartum Mode), Sahiba (postpartum mood, nifas and feeding records) | A stage of its own after birth | lacks (tip stage only) | NC AS https://apps.apple.com/us/app/natural-cycles/id765535549 ; Ovia AS https://apps.apple.com/sa/app/id570244389 ; Stardust AS https://apps.apple.com/us/app/id1495829322 ; Sahiba AS https://apps.apple.com/app/id6772802488 ; Flo page: not verified (https://flo.health/faq/pregnancy-mode/using-app-postpartum returned 404 on fetch) |
| Baby feeding / sleep / diaper log | WTE, BabyCenter, Pregnancy+ (v8, English, gradual rollout) | Newborn log with timers | lacks | WTE AS ; BabyCenter AS ; Pregnancy+ AS |
| Postpartum symptom and medication log | WTE, BabyCenter | Notes after delivery | lacks | WTE AS |
| Postpartum mood / mental-health track | Ovia (mental health in the programme), Sahiba (postpartum mood) | Mood log after birth | partial (mood chips exist; no postpartum framing) | Ovia AS ; Sahiba AS |
| Pregnancy-loss support groups | BabyCenter (a reviewer says it has loss groups; not a developer claim) | Peer support | lacks, and community is out of scope | BabyCenter AS |
| Loss/grief content | none found as a feature in the listings read | n/a | check in code | not verified |
| Returning-cycle tracking after birth | NC Postpartum ("temperature-based detection of returning ovulation") | Tracks return of cycles | lacks | NC AS (see section 7 on its contraception framing) |

**Strongest gaps (postpartum), ranked**
1. A postpartum goal in onboarding that keeps the same record (rule 5, additive layers). Four apps have a mode; femio has none.
2. Postpartum recovery content by delivery type (Ovia's framing) and a postpartum mood and bleeding log.
3. A baby feeding/sleep log (WTE, BabyCenter). Larger scope; probably later than 1-2.
4. Gentle pregnancy-loss path: no competitor listing read offers one as a feature, so this is a chance to lead, with Help-now and clinician-visit prompts.

---

## 4. Cycle tracking (B1, B2, B3, B4, B7)

| Feature | Who has it | What it does for her | femio today | Source |
|---|---|---|---|---|
| Symptom library size | Clue (200+), Maya (not counted), Flo (70+ / 80+), Premom (50+) | Wide log vocabulary | has (~136 terms) | Clue AS https://apps.apple.com/app/id657189652 ; Flo AS |
| Trends / cycle history charts | Maya ("stats, history, and graphs"), Clue Plus (Analysis tab), Ovia (symptoms "shown in charts"), Tahara ("charts showing cycle patterns") | See patterns over months | lacks | Maya AS https://apps.apple.com/us/app/-/id492534636 ; Tahara AS |
| Symptom forecasts | Clue ("Predicts upcoming symptoms"), Maya ("daily predictions of expected symptoms"), Stardust (mood, cravings forecasts) | "What to expect this week" | lacks | Clue AS ; Maya AS ; Stardust AS |
| Doctor-ready report | Flo (downloadable cycle report), Natural Cycles (Cycle Report PDF), Tahara (PDF to share with a doctor) | Takes data to a visit | has (Visit summary) | Flo AS ; NC perimenopause page https://www.naturalcycles.com/perimenopause ; Tahara AS |
| Daily wellbeing snapshot | Flo ("Flori: Well-Being Battery") | One daily view of sleep, cycle, symptoms | lacks | Flo AS |
| Irregular-cycle support | Flo, Ovia, Clue ("tracking without bleeding"), NC | Predictions when cycles vary | has ("no confident window") | Flo AS ; Clue AS |
| PMS/PMDD-specific tools | none found in the listings read | n/a | not verified | not verified |
| Custom tags | Clue Plus ("Unlimited custom tags") | Her own symptom words | lacks | Clue Plus page |
| Reminders (custom) | Maya, Ovia | Habit/medication reminders | partial (daily log, period expected) | Maya AS |
| Privacy lock | Maya (password/biometric), Ovia (PIN) | Locks the app | has (PIN) | Maya AS ; Ovia AS |
| Sleep insights across cycle | Natural Cycles | Sleep by phase | lacks | NC AS |
| Hijri calendar beside Gregorian | Nana, Tahara, Altibbi Mama (calendars) | Local dates | has | Nana AS https://apps.apple.com/app/id6763940143 |

**Strongest gaps (cycle), ranked**
1. Patterns screen: cycle length history, symptom frequency by phase, "what is usual for you" range. Appears in Clue, Maya, Ovia and Tahara listings. Must show ranges, never a verdict.
2. Per-phase "what you may notice" card from her own logs (Clue and Maya forecast symptoms). Must be framed as her past pattern, not prediction of health state.
3. Custom tags so she can name her own symptoms (Clue Plus).
4. A daily snapshot (Flo's battery) is optional; weaker evidence of value.

---

## 5. First periods / teens (A1, A2, A3)

femio is 18+ today. This section reports what competitors do; it is not a recommendation to lower the age gate.

| Feature | Who has it | What it does | femio today | Source |
|---|---|---|---|---|
| Teen first-period space | Flo ("a safe space for teens to track their first period, with age-appropriate education"; store text as returned by search, not seen in the fetched listing text) | Education for a first period | lacks | snippet only: https://apps.apple.com/ca/app/id1038369065 ; Flo AS (fetched, no teen line): https://apps.apple.com/us/app/flo-cycle-period-tracker/id1038369065 |
| Age floors | Flo: under 13 not allowed (16 in EEA/UK); "some functions limited for under 18" (terms, snippet) ; Clue: under 13 not allowed in the US (help centre, snippet) ; Natural Cycles: 18+ ; Premom/Maya: Maya AS rating 17+ in one listing | Minor-privacy handling | femio 18+ | Flo terms https://flo.health/terms-of-use (snippet only) ; Clue help https://support.helloclue.com/hc/en-us/articles/25411219033373-How-old-do-I-have-to-be-to-use-Clue (403 on fetch; snippet only) ; NC AS (fetched) |
| Teen-focused alternatives | Protect Young Eyes calls Flo "an adult app" and recommends a teen-focused app (third-party opinion) | Parental view | n/a | https://protectyoungeyes.com/the-best-period-tracking-apps-for-young-girls/ (snippet only) |
| First-period prediction / "when will my next period come" with wide ranges | none verified | n/a | n/a | not verified |

**Strongest gaps (teens), ranked**
1. Nothing is verified that shows a competitor doing teen privacy well; Flo's own terms restrict content for under-18s, and Clue ties its floor to a US child-privacy law. Treat as a legal question for `docs/33_REBUILD_V3/03_LEGAL_PACK.md`, not a feature.
2. If femio ever opens to minors, a "first period" article set (education only, no tracking account) on the website is the lowest-risk step; this needs no age gate change. Flag: this touches the 18+ rule; owner decision.
3. Note that the teen category is where ads/analytics findings are worst (see section 7 on Flo's FTC history, not fetched).

---

## 6. Perimenopause / menopause (F1, F2, F3)

| Feature | Who has it | What it does | femio today | Source |
|---|---|---|---|---|
| Perimenopause mode | Clue Plus ("Perimenopause Mode: tracks hot flashes, sleep, mood, with a modified Cycle View"), Natural Cycles (NC Perimenopause), Flo, Ovia | A stage mode | partial (menopause hero in Today) | Clue Plus page ; NC page https://www.naturalcycles.com/perimenopause ; Flo AS |
| Perimenopause score / timeline | Flo ("Perimenopause Score", "Menopause Timeline") | Symptom-impact number and phases | lacks (a score or stage label touches the no-diagnosis rule) | Flo AS |
| Symptom-vs-lifestyle correlation | Natural Cycles ("analysis of how symptoms correlate with lifestyle, and progress tracking as you make changes") | Shows what helps or triggers | lacks | NC page |
| Health Report for appointments | Balance (free), Natural Cycles | Takes symptoms to a clinician | has (Visit summary) | Balance AS https://apps.apple.com/us/app/id1503345959 |
| Mood and sleep tracking | Balance (free) | Daily mood/sleep | partial (mood chips; sleep not confirmed) | Balance AS |
| Expert live sessions, recipes, yoga | Balance+ (paid) | Video and live Q&A | lacks | Balance AS |
| Community | Balance (free "community support") | Peer support | lacks, out of scope | Balance AS |
| Hormone-therapy awareness | Natural Cycles (shows who can use it with HT) | Clarifies use | partial (check in code whether HT is a loggable item) | NC page |

**Strongest gaps (menopause), ranked**
1. Perimenopause as a goal that keeps irregular cycles visible (Clue's "modified Cycle View"); femio has a menopause hero but no perimenopause-specific tracking view. Check in code what the menopause goal logs.
2. Symptom frequency over time and a report for the clinician visit; Balance gives this free, so femio's Visit summary must at least match it.
3. A symptom set specific to the stage (NC's list: brain fog, fatigue, dryness, joint pain, palpitations, hot flashes). Check which exist in the 136 terms.

---

## 7. Arabic-market apps (what I actually found)

| App | What it is | Verified features | Languages | Privacy as stated | Source |
|---|---|---|---|---|---|
| Tahara - طهارة | Women's health app (Saudi App Store listing) | Cycle prediction, symptom log, week-by-week pregnancy tracker, doctor-share PDF, live sessions with specialists, a shop with cashback | English, Arabic | Labels list contact info and usage data used across other companies' apps | https://apps.apple.com/sa/app/id6446452995 |
| Nana: Period & Cycle Tracker (Elkhoi Labs) | Period + pregnancy | Hijri/Gregorian switch, week-by-week pregnancy, prayer-time reminders, charts, PDF for doctor, "smart reminders for late periods" | Arabic, English (listing inconsistent about 14 languages) | "Your data stays on your device" claim; "Contains Advertising" age note | https://apps.apple.com/app/id6763940143 |
| Sahiba (formerly Nisaa) | Muslim period tracker | Cycle history, fertile-window estimates, prayer times, Ramadan and fasting records, pregnancy weekly, postpartum mood/nifas/feeding records, pregnancy widgets; works without an account, local by default; states dates "should not be used as contraception" | EN, AR, UR, ID, MS, TR | Local by default; optional sign-in for cloud backup | https://apps.apple.com/app/id6772802488 |
| Daleela (Motherbeing, Cairo) | Cycle + AI chat + consultations | Period tracker, online OB-GYN consultations, programmes (pre-marriage, PCOS), free 24/7 AI Q&A; no pregnancy tracking in the listing | Description says Arabic and English with dialect; listing shows English only | Labels disclose cross-app tracking | https://apps.apple.com/us/app/id6482997617 |
| Aziza - عزيزة (Egypt) | Cycle tracker for Egyptian women | Cycle tracking, pregnancy tracking, "experimental AI-assisted symptom analysis" | Arabic only | Labels: usage data used to track across apps; advertising data | https://apps.apple.com/us/app/id6452802604 |
| Nabta (NABTA) | Employer/organisation health programme app | Lab results, 31 health goals, care-team messaging, AI-style insights; cycle calendar only in older notes | English, Arabic and others | Account required; delete in app | https://apps.apple.com/ae/app/nabta-%D9%86%D8%A8%D8%AA%D8%A9/id1508198107 |
| Altibbi Mama | Arabic pregnancy app (UAE-based platform) | Week-by-week with tests per stage, call-a-doctor, Hijri + Gregorian calendars, baby names, fetal growth, infant care, country vaccination schedules; under EGP 75 per month | Arabic | Not read | https://www.zawya.com/en/press-release/al-tibbi-launches-first-arabic-app-thriving-with-reproductive-health-in-egypt-hdxg7yot (press release, 2021; current availability not verified) |
| Kenzi (كنزي) | Arabic women's health content + consultations | Play page truncated; features from a search summary only | Arabic | not verified | https://play.google.com/store/apps/details?id=com.matz.banatmed (not verified) |
| Hayati/حياتي, Mama, Nabd | Searched by name; none surfaced as a matching women's-health app | not verified | n/a | n/a | not verified |

Notes. The big global apps: Flo lists no Arabic (21 languages, Flo AS); Clue lists Arabic (Clue AS); Ovia lists English and Spanish only (Ovia AS); Maya lists no Arabic (Maya AS); Pregnancy+ lists 14 languages without Arabic in the fetched listing, though one search snippet claimed Arabic (conflict, not verified); BabyCenter lists EN/PT/ES; WTE English only; Premom 21 languages, Arabic not named in what I read.

**Strongest gaps (Arabic market), ranked**
1. The Arabic apps found are thin on trust: most disclose usage-data tracking across apps (Tahara, Daleela, Aziza) or ads (Nana). Femio's verifiable "nothing leaves the phone" is the clearest wedge, but Sahiba and Nana make the same claim, so femio must show proof (store data-safety form, no network code).
2. Week-by-week Arabic pregnancy content with local vaccination/antenatal schedule (Altibbi Mama). Compare with femio's cited, reviewed content.
3. Hijri dates: femio has them; Nana, Tahara and Altibbi Mama also do. It is parity, not a lead.
4. Doctor access (consultations: Daleela, Altibbi, Kenzi, Tahara) is a services business; out of femio's scope.

---

## 8. Patterns across the market

- **Week-by-week pregnancy content is the baseline.** Flo, Clue Plus, Ovia, BabyCenter, WTE, Pregnancy+, Stardust, NC, Tahara, Altibbi Mama (sources in section 2).
- **Baby-size and 3D visuals** are standard in WTE, Pregnancy+, Ovia, Stardust. Pregnancy+ puts its 3D documentary behind Premium (Pregnancy+ AS).
- **Trends/analysis is paywalled or buried.** Clue Plus Analysis tab; Maya premium graphs and "basic tier limits history" (reviews); NC Cycle Report; Flo cycle report is in the free listing text. femio offering a free Patterns view would stand out.
- **Partner modes** are common: Flo for Partners (basic version is free per Flo's help article https://help.flo.health/hc/en-us/articles/4411293934740-What-s-included-in-the-free-version), Clue Connect (Clue Plus), NC, Premom Predad, Pregnancy+, Stardust, Maya.
- **LH test reading**: Premom scans and quantifies; Flo logs results. No Android-local competitor read does photo reading.
- **Symptom correlations**: NC (perimenopause lifestyle correlation), Clue Plus (analysis), Flo (battery).
- **Paywall pattern:** pregnancy depth, PCOS and perimenopause tools sit behind subscriptions (Flo Premium "in-depth pregnancy features", Premom PCOS Pro, Clue Plus modes, NC $149 per year in the US listing). Reviews complain about basic features moving behind paywalls (Flo AS reviews, via search summary; not fetched). femio's free guides are a visible contrast.
- **AI assistants** exist in Daleela (free 24/7 AI chat), Premom (PCOS AI), Aziza (AI-assisted symptom analysis), Nabta (Aya insights). femio's cited, bundled-source assistant is more constrained; "AI chat" is a deferred item for the owner, so any change here is **deferred**.
- **Privacy labels** show most large apps linking health data to analytics or advertising (Flo, Clue, Ovia, Premom, BabyCenter, WTE, Pregnancy+, Balance's analytics). Only Nana, Sahiba and Stardust (claims) say otherwise, and Mozilla's review of Stardust disputes its claim (snippet only; Mozilla page not fetched).

---

## 9. Things competitors do that femio's rules forbid (cite as rejections)

| Competitor practice | Who | Source | Femio rule broken |
|---|---|---|---|
| Birth-control mode with efficacy claims (98% correct use, 93% typical, "cleared by FDA"; outside authorised countries "fertility monitoring only") | Natural Cycles | NC AS https://apps.apple.com/us/app/natural-cycles/id765535549 | wellness only, never contraception |
| Birth-control method logging (pills, IUDs, rings, patches) | Clue, Ovia ("tracks birth control"), Maya (pill reminder) | Clue AS https://apps.apple.com/app/id657189652 ; Ovia AS ; Maya AS | Logging a method is not itself contraception use; keep any such log neutral and non-predictive (lead correction 2026-11-24: an earlier tail attributed a framing rule to Clue that Clue does not state) |
| Predicting fertile days "for planning either to conceive or to avoid" | an Arabic calculator app in the search results (Hawwa) | search summary only: https://apps.apple.com/app/id1352788674 (not fetched) | never a way to avoid pregnancy |
| Symptom checker for named conditions (PCOS, endometriosis, fibroids) | Flo Premium (not offered in UK/EU) | Flo AS | no diagnosis |
| "Perimenopause stage assessment using the NC° Menopause Algorithm" | Natural Cycles | NC page https://www.naturalcycles.com/perimenopause | no diagnosis or staging verdicts (the same page says it is "not a diagnosis") |
| Perimenopause Score | Flo | Flo AS | verdict-like single score |
| "Medical diagnosis (تشخيص طبي)" in-app purchase, $14.99 | Daleela | Daleela AS https://apps.apple.com/us/app/id6482997617 | no diagnosis |
| PCOS AI that "interprets BBT and OPK trends to spot fertile signs" | Premom | Premom AS | diagnosis-like AI; ranges rule |
| Daily fertility score | Ovia | Ovia AS | ranges, not single values |
| "Plan up to 12 cycles ahead" | Clue Plus | Clue Plus page | ranges not certain dates |
| "Smart reminders for late periods" | Nana | Nana AS | never a "late" counter in irregular modes |
| Health data linked to advertising, analytics or cross-app tracking | Flo (AS: health data for analytics), Clue ("Data linked to you, for advertising/marketing": coarse location, name, email; "for analytics": health data), Ovia (health data for advertising/marketing), Premom, BabyCenter and WTE (third-party advertising), Stardust (labels: purchases/identifiers tracked) | the AS pages in section 10 | health data never to ad or analytics SDKs |
| Community: Secret Chats (Flo; listed Premium in the AS text but free per Flo's help article, a conflict), Premom forum, BabyCenter Birth Club, WTE community, Pregnancy+ community, Maya forum, Balance community | many | Flo help (free version) ; Premom AS ; BabyCenter AS ; WTE AS ; Pregnancy+ AS ; Maya AS ; Balance AS | no user-to-user chat (and community is deferred) |
| Sexual-wellness content: intimacy diary, sex logging, sexual-health sessions | Maya (intimacy diary), Ovia (logs sex), Balance+ (sexual health and pelvic floor sessions) | Maya AS ; Ovia AS ; Balance AS | conservative register, no sexual-wellness content |
| Ramadan, fasting and prayer-time tools | Sahiba, Nana | Sahiba AS https://apps.apple.com/app/id6772802488 ; Nana AS | owner ruling: no Ramadan features |
| Accounts required (sign-up with email/phone) | Nabta, Daleela, Aziza, Balance, Flo (anonymous mode optional) | Nabta AS ; Balance AS | no accounts in v1 |
| In-app shop with cashback / ads | Tahara (shop), Nana (ads) | Tahara AS ; Nana AS | no ads, no analytics SDK |

---

## 10. Source list (all read 2026-11-24)

**Fetched and read (22)**
1. Flo AS US https://apps.apple.com/us/app/flo-cycle-period-tracker/id1038369065
2. Flo help: Pregnancy mode https://help.flo.health/hc/en-us/articles/360054523711-What-is-Pregnancy-mode-and-how-do-I-activate-it
3. Flo help: free version https://help.flo.health/hc/en-us/articles/4411293934740-What-s-included-in-the-free-version
4. Clue AS https://apps.apple.com/app/id657189652
5. Clue Plus intro (first 100,000 of 120,929 characters read) https://helloclue.com/articles/about-clue/introducing-clue-plus
6. Natural Cycles AS https://apps.apple.com/us/app/natural-cycles/id765535549
7. Natural Cycles perimenopause page https://www.naturalcycles.com/perimenopause
8. Ovia Cycle & Pregnancy AS (SA store) https://apps.apple.com/sa/app/id570244389
9. Premom AS https://apps.apple.com/us/app/premom-ovulation-tracker/id1279295922
10. Stardust AS https://apps.apple.com/us/app/id1495829322
11. BabyCenter AS https://apps.apple.com/us/app/babycenter-pregnancy-tracker/id386022579
12. What to Expect (WTE) AS https://apps.apple.com/app/id289560144
13. Pregnancy+ AS https://apps.apple.com/us/app/id505864483
14. Balance AS https://apps.apple.com/us/app/id1503345959
15. Maya AS https://apps.apple.com/us/app/-/id492534636
16. Nabta AS https://apps.apple.com/ae/app/nabta-%D9%86%D8%A8%D8%AA%D8%A9/id1508198107
17. Daleela AS https://apps.apple.com/us/app/id6482997617
18. Nana AS https://apps.apple.com/app/id6763940143
19. Tahara AS https://apps.apple.com/sa/app/id6446452995
20. Sahiba (Nisaa) AS https://apps.apple.com/app/id6772802488
21. Aziza AS https://apps.apple.com/us/app/id6452802604
22. Altibbi Mama press release (2021) https://zawya.com/en/press-release/al-tibbi-launches-first-arabic-app-thriving-with-reproductive-health-in-egypt-hdxg7yot

**Not verified (fetch failed, truncated, or search snippet only) (14)**
- All Google Play pages: Flo, Clue, NC (truncated, no feature text); Ovia (404); Premom (404); Kenzi (truncated). Apple App Store listings were used instead; features may differ on Android.
- Flo Premium page and Flo for Partners page (truncated); Flo pregnancy product tour (truncated); Flo Secret Chats product tour (truncated).
- Flo Postpartum Mode FAQ (404 on fetch; title seen in search only).
- Clue help centre: Clue Plus and premium-feature pages (403); Clue age page (403; search snippet only).
- NC postpartum help article (403); NC App Store did cover Postpartum.
- Mozilla Privacy Not Included, Flo (403) and Stardust (search snippet only).
- Flo terms of use and Flo teen claim (search snippets only).
- Protect Young Eyes page (search snippet only).
- Ovia Pregnancy standalone listing (404) and an "Ovia Parenting" app: not found.
- Hayati/حياتي, Mama, Nabd apps: not found by name.
- Hawwa app (id1352788674), cited in section 9 from a search summary only.

**Conflicts spotted**
- Flo Secret Chats: the AS listing groups it under Premium; Flo's help article lists it as free.
- Natural Cycles AS says both "cleared by FDA" and "FDA-approved" (Featured blurb).
- Daleela and Nana: description language claims differ from the Information section.
- Pregnancy+: Arabic support unverified (snippet vs a Saudi review).
