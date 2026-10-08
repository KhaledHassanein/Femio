# Competitor benchmark: Arabic-first TTC and pregnancy wedge

Prepared 2026-10-08 by a delegated research pass (Sonnet) for the lead session to review. Nothing here has been committed or merged into other docs. Builds on `02_MARKET_RESEARCH_2026-10.md`, `28_TEARDOWN/06_COMPARISON_MATRICES.md` and `07_GAP_REGISTER.md`; those are not repeated.

## 0. Read this first

1. **Femio's Arabic content is zero.** `apps/web/src/content/snapshot/meta.json` (taken 2026-10-07) reports 100 articles and 5 conditions in `en` and **0 in `ar`, `fr`, `es`**; FAQs and glossary are empty in all four. The UI is four-language, the knowledge base is English only. Every other finding is secondary to this for a wedge that is "Arabic-first".
2. **The Arabic search market is owned by two generalist sites.** Semrush estimates (database `sa` and `eg`, pulled 2026-10-08): altibbi.com 3.30M organic visits/month in Saudi Arabia and 9.14M in Egypt; webteb.com 1.45M (SA) and 1.73M (EG); sayidaty.net 0.68M (SA). flo.health, by comparison, gets about 4,200 (SA) and 3,400 (EG). Global trackers are not competing for Arabic web traffic at all. Competition for the wedge is Altibbi, WebTeb, Sayidaty plus a handful of Arabic apps.
3. **Only two of the global apps ship Arabic.** From App Store listings: Clue (Arabic among 27 languages) and Premom (Arabic among 21). Flo, Natural Cycles, Ovia, BabyCenter and Pregnancy+ (Korean-storefront listing) do not list Arabic.
4. **The Android app today is tracking and TTC, not pregnancy.** P3.1 to P3.5 are done; P3.6 (pregnancy week-by-week, kick counter, contraction timer, appointments), P3.7 (articles, PCOS hub, conditions) and P3.8 (backup, app lock, reminders) are open in `PROGRESS.md`. The kick counter and contraction timer exist as TypeScript logic (`apps/web/src/lib/pregnancy/movements.ts`, `apps/web/src/lib/contractions`) but have no screen in `apps/mobile/lib/features/*`.
5. **A documentation inconsistency worth fixing:** `02_MARKET_RESEARCH` still says "31 articles" and `07_GAP_REGISTER` TD-08 says "105 authored / 31 live"; the snapshot has 100 English. Separately, docs call all articles "clinician-bylined", but in the snapshot only 26 of 100 carry an `authors` entry and 25 a `medicalReviewerProfile` (all 100 have `lastReviewed`, 99 have `sources`). Verify whether the site template falls back to the single bio in `people.json`; if not, the byline claim is overstated.

## 1. Femio inventory (from the repo, 2026-10-08)

### 1.1 Content (snapshot, English only)

| Topic row (`lib/content/topics.ts`) | Articles | Notes |
|---|---:|---|
| Trying to conceive | 11 | guide, fertile window, irregular cycles, when to test, age, preconception visit, PCOS and fertility, endometriosis and fertility, thyroid, fertility tests, when to seek help |
| Pregnancy week by week | 37 | weeks 4 to 40 (nothing for weeks 1 to 3 or 41 to 42) |
| Pregnancy (other) | 4 | basics, early changes, first appointment, warning signs |
| After birth | 14 | recovery, warning signs, bleeding, afterpains, wounds/caesarean, mood, sleep, breastfeeding x2, pelvic floor, periods, contraception, six-week check, sex |
| Newborn | 8 | first two weeks, warning signs, feeding, formula, safer sleep, crying, nappies/cord, checks and vaccinations |
| Cycles | 8 | cycle basics, is my period normal, tracking, period pain care, how painful periods assessed, heavy periods and anaemia, PMS/PMDD tracking, myths |
| Conditions | 4 articles + 5 hubs | PCOS signs, how PCOS is assessed, endometriosis signs, how assessed; hubs for PCOS, endometriosis, heavy periods, painful periods, PMS/PMDD |
| Teens | 8 | |
| Menopause | 5 | |
| Other | 1 | "Meet Femio" |
| **Total** | **100 articles, 5 condition hubs** | all `en`; 99 cite sources; no video; no FAQ or glossary entries |

Life stages covered: puberty, cycles, conditions, TTC, pregnancy, postpartum, newborn, perimenopause/menopause. PCOS specifically: `pcos-signs`, `how-pcos-is-assessed`, `pcos-and-fertility` plus the PCOS hub. No PCOS treatment, lifestyle, insulin-resistance, hirsutism/acne or irregular-cycle-with-PCOS TTC article (body-text counts in the snapshot: metformin 0, inositol 0, letrozole 0, clomiphene 0, hirsutism 0, "PMOS" 0).

### 1.2 Web calculators (`calculators/*`, `lib/calculators/index.ts`, `lib/pregnancy/index.ts`)

Seven pages: period (next three periods as ranges from her own shortest/longest cycle), ovulation/fertile window (drawn on a month calendar), pregnancy test timing (NHS rule), due date (trimester bar), pregnancy week, cycle length, BMI. The library also holds `eddFromConception`, `eddFromTransfer` (3 or 5 day embryo), `isPlausibleEdd`, movement-pattern comparison, and a pregnancy symptom urgency classifier; the due-date page itself, per a grep of `page.tsx`, exposes LMP plus cycle length only (no IVF, conception or ultrasound modes in the web UI). No Hijri date input or output anywhere in `apps/` (grep for "hijri" and "ramadan" finds nothing in code or content; only strategy docs mention them).

### 1.3 App: built vs planned (`PROGRESS.md`, `04_ANDROID_APP_SPEC.md`, `apps/mobile/lib/features/*`)

| Built | Line | Planned, open | Line |
|---|---|---|---|
| Flutter app, 4 languages with RTL, private-file store, no network | P3.1 | Persona/period-forecast and test-timing ports (partial) | P3.2 `[~]` |
| Onboarding (goal, birth year, last period, cycle, trying-for, four ways to date a pregnancy, menopause) | P3.3 | Pregnancy week-by-week, due date, kick counter, contraction timer, appointments | P3.6 |
| Today, Calendar (predicted window, fertile days, likely ovulation as estimates), Log (flow, 9 moods, 36 symptoms, 5 discharge types, intimacy marker) | P3.4 | Articles in app, conditions on Today/Settings, PCOS hub | P3.7 |
| TTC toolkit: fertile window range with confidence, ovulation-test log (what the stick said), typed BBT chart with no shift marked, test timing, 12/6-month trying-time nudge | P3.5 | Backup export/import, app lock, reminders, crash reporting without content | P3.8 |
| Dating a pregnancy by LMP, conception, IVF transfer, due date known (shared golden fixtures, TS and Dart) | P3.2/P3.3 | Privacy policy, Play listing and Data safety, closed test | P4.1, P4.2 |

Not mentioned anywhere in PROGRESS or the spec: Hijri dates, Ramadan hub, baby names, weight log and hospital-bag list (listed in spec section 4 "Tools" for pregnancy but not in the P3.6 line), partner share, doctor-visit PDF in the app, home-screen widget, pregnancy-loss path.

## 2. Competitors: primary sources and verification limits

All pages "checked 2026-10-08". Primary here means the product's own store listing or own site. **Limits, stated plainly:** (a) Google Play pages returned only truncated text, so listing facts below come from the developer-written Apple App Store listings (same developer text, developer-declared privacy labels, which Apple does not verify); (b) babycenter.com and whattoexpect.com refused automated fetches, so BabyCenter facts come from its App Store listing and What to Expect facts from search snippets of its store listings (flagged "snippet"); (c) Flo's tool pages and Stardust facts appear here only via search snippets or a third-party review (flagged); (d) no per-app install counts for KSA/EG were available, and Ahrefs SERP data was blocked by plan, so "what ranks" uses Semrush domain traffic only.

| Product | Source used | URL |
|---|---|---|
| Flo | App Store listing; tools list (snippet) | https://apps.apple.com/us/app/flo-period-pregnancy-tracker/id1038369065 ; https://flo.health/tools ; https://flo.health/pregnancy/week-by-week ; https://flo.health/pcos/press-release |
| Clue | App Store listing; own help centre/articles (snippet) | https://apps.apple.com/us/app/clue-period-cycle-tracker/id657189652 ; https://support.helloclue.com/hc/en-us/articles/16701057975581-What-are-modes ; https://helloclue.com/articles/pcos |
| Natural Cycles | App Store listing | https://apps.apple.com/us/app/-/id765535549 |
| Ovia (Cycle & Pregnancy; Fertility is the same Ovuline app, `com.ovuline.fertility`) | App Store listing; Play listing (snippet) | https://apps.apple.com/sa/app/id570244389 ; https://play.google.com/store/apps/details?id=com.ovuline.fertility |
| Premom | App Store listing | https://apps.apple.com/us/app/premom-ovulation-tracker/id1279295922 |
| Stardust | Mozilla privacy review (secondary); no listing fetched | https://www.mozillafoundation.org/en/nothing-personal/stardust-privacy-review/ |
| BabyCenter | App Store listing (UK/SG store) | https://apps.apple.com/sg/app/babycentre-pregnancy-tracker/id386022579 |
| What to Expect | Store-listing snippets via search | https://www.bluestacks.com/campaign/com.wte.view/es (mirror) ; App Store `apple.co/33IbGyc` |
| Pregnancy+ | App Store listing (KR store) | https://apps.apple.com/KR/app/id505864483 |
| Maya | App Store listing (snippet) | https://apps.apple.com/us/app/-/id492534636 |
| Al-Malika (الملكة) | App Store listing | https://apps.apple.com/us/app/-/id859154447 |
| Pregnancy calculator, Hayah Site (حاسبة الحمل) | mwm.ai store mirror (ratings, reviews) | https://mwm.ai/apps/hsb-lhml/950624032 |
| "حمل - حاسبه الحمل و تقويم" | App Store listing (SA store) | https://apps.apple.com/sa/app/id1659797587 |
| Altibbi / Altibbi Mama | Own homepage; 2021 launch article | https://altibbi.com/ ; https://almalnews.com/997249/ |
| WebTeb | Own pregnancy portal and calculator index | https://baby.webteb.com/pregnancy ; https://www.webteb.com/calculator |
| Traffic data | Semrush `domain_rank`, databases sa and eg | semrush.com/analytics/overview/?db=sa&q=altibbi.com (and eg, webteb.com, flo.health, sayidaty.net) |

### Key facts per competitor (only visible features count)

- **Flo.** 4.7 from ~2M ratings. 70+ symptoms and moods; LH test and BBT logging; discharge; pregnancy with weekly updates and daily articles; perimenopause tools (score, timeline); Anonymous Mode; Flo for Partners; cycle report to share. Premium: expert videos, Symptom Checker (not offered in UK/EU/EEA, Switzerland), 24/7 Health Assistant. Week-by-week pages cover weeks 1 to 42 and name a reviewing physician (snippet). Ten web calculators (ovulation, period, cycle, pregnancy test, implantation, hCG, weeks-to-months, due date, IVF/FET due date, due date by ultrasound; snippet). Languages: English plus 20, **Arabic not among them**. Privacy label lists Health & Fitness, Location and Sensitive Info as linked, and Identifiers, Purchases, Location, Usage Data as used for tracking. Web due-date page assumes a 28-day cycle (snippet).
- **Clue.** 4.8 from ~405K ratings. 200+ tracking categories, 400+ articles, modes for period, TTC (Conceive, which the developer calls a regulated medical device), pregnancy, perimenopause; birth-control logging; wearables; Arabic UI. Plus $9.99/month or $39.99/year. Label: Identifiers used for tracking; Health & Fitness and coarse Location linked. PCOS is educational content only (Clue now writes "PCOS (now PMOS)"); no PCOS-adjusted predictions found.
- **Natural Cycles.** Five modes: birth control, plan pregnancy, follow pregnancy (baby development, movements), postpartum, perimenopause. Temperature-led, NC° Band and wearables. Claims 93% typical-use effectiveness; US$21.99 per month or $149.99 per year. Languages: English, Portuguese, Spanish, Swedish. Contraception is a lane Femio must not enter.
- **Ovia (Labcorp).** English and Spanish only. Fertile window and daily fertility score, BBT/OPK logging, pregnancy (growth calendar, due-date countdown, kick counter, contraction timer, baby names, food-safety lookup), 12-month postpartum programme, perimenopause, 2,000+ free articles, PIN lock, partner linking. Free (employer/health plan funded). Label: health and sensitive data linked, used for advertising/marketing and analytics.
- **Premom.** Arabic included. 4.8 from ~60K ratings. Photographs and reads LH strips (low/high/peak), automatic BBT chart, 50+ symptom logs, pregnancy mode with due date calculator, **"PCOS AI" interpreting BBT and LH trends plus a PCOS nutrition plan**, partner link, community forums, expert consultations, exported reports. Label lists payment and financial info among linked data, contains advertising. Subscription "Get Pregnant Faster" about US$23.
- **Stardust (secondary only).** Astrology/moon-phase framing, cycle compare with friends. Mozilla's review says the privacy policy names Meta and Google ad-measurement tools as recipients of activity data (as of May 2026) and that end-to-end encryption claims were removed after press reports. A University of Illinois analysis found no health-data sharing with advertisers on Android. No store listing was fetched, so feature cells are marked unverified.
- **BabyCenter.** App: day-by-day tracking from a due date, daily feed, checklists, calendar timeline, live Q&A with midwives, Birth Club community and chat, baby name tool, due date calculator, bump photo diary, "Inside the Uterus" videos, first year coverage. States all content is approved by its Medical Advisory Board and certified by the NHS England Information Standard. Languages: English, German, Portuguese, Spanish. Label: third-party advertising among linked-data purposes. (US app also lists an ovulation calculator; snippet.)
- **What to Expect (snippets).** Due date by LMP, IVF transfer, conception or ultrasound; week by week; daily tips and baby-size comparisons; medical review board following ACOG, AAP and CDC. Android 7.90 (August 2026) adds an ovulation calculator and tracker, a TTC journal and community groups. Kick counter and contraction timer not confirmed.
- **Pregnancy+ (Philips).** 15 languages on the Korean store (Arabic absent there; another tracker site lists Arabic, so storefronts differ). 3D development models, size guide, due date calculator, kick counter, weight log, contraction timer, hospital bag, birth plan, to-do and shopping lists, baby names, bump photo diary, partner sharing, community (v7.0). Free plus subscription.
- **Maya.** Period, fertility, pregnancy tracking, community; 14 languages and Arabic could not be confirmed in any source. Freemium with ads.
- **Al-Malika (الملكة).** Arabic content, store metadata English only. 4.5 from ~4.7K ratings. Period/ovulation with a **Hijri-calendar cycle calculator**, week-by-week pregnancy, kick and contraction counters, weight, hospital bag, medical-checkup reminders, **"safe days" information as a contraception aid**, baby growth to age two, **Ramadan fasting courses and a make-up-fast day tracker**, women-only "Golden Forum", OB-GYN consults (US$19). Premium US$7/month or $29/year. Label: third-party advertising data and usage data; contains ads.
- **Hayah Site "Pregnancy calculator" (حاسبة الحمل).** 2.5M+ downloads, 4.7 from 344K ratings (written reviews 4.1 from 1,175). Due-date and days/weeks/months tracking, weekly fetal development, **Hijri and Gregorian**, forum, consults with female specialists, reminders. Recent reviews cite intrusive ads, sign-in failures (Iraq, Kuwait), crashes, date not rolling over at midnight, **inaccurate IVF dating with no way to choose the pregnancy type, and no handling when a pregnancy ends early**.
- **"حمل" pregnancy app (SA store).** Arabic plus 67 languages, 4.2 from 275 ratings. Week by week, due date with conception estimate, trimester chart, offline kick counter, contraction timer, ultrasound photos. Label: precise location and advertising data linked (third-party advertising). SAR 9.99 weekly to 149.99 annual, 199.99 lifetime.
- **Altibbi / Altibbi Mama.** Homepage: women's health, pregnancy and gynaecology categories, pregnancy/due-date calculator, ovulation calculator, BMI/calorie/water calculators, voice or text consults with doctors, an AI assistant (Sina), apps on three stores. Mama (2021): Hijri and Gregorian conception/ovulation/due date, baby names, child vaccination schedules, Egypt/Jordan/Saudi. The pages reviewed do not name an author or reviewer for content.
- **WebTeb.** Arabic only. Calculator index lists ovulation days, pregnancy/due date, period, PMS symptom checker, child growth, BMI, and a **"Chinese chart for predicting the baby's sex"**. Pregnancy portal shows partner logos (UCLA Health, Mayo Clinic, Harvard) but no named authors or reviewers on the page fetched. Online clinic booking.

## 3. Comparison matrix

Legend. Femio: **B** built (in repo today), **P** planned (cited in PROGRESS or plan docs), **N** no and not planned. Competitors: **●** has (visible in listing/site), **◐** partial or paid-only or unclear scope, **○** not found, **?** could not verify. "Alm" = Al-Malika; "Hay" = Hayah حاسبة الحمل; "Alt" = Altibbi/WebTeb (Arabic portals, treated together; differences in notes). WTE = What to Expect, P+ = Pregnancy+, NC = Natural Cycles, BC = BabyCenter, Ste = Stardust.

### (a) Knowledge base and content

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | Ste | BC | WTE | P+ | Alm | Hay | Alt |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Article library in the product | B (100, EN only; in app = P3.7) | ● | ● (400+) | ◐ | ● (2,000+) | ◐ | ◐ | ● | ● | ● | ● | ◐ | ● |
| Pregnancy week by week | B web content weeks 4 to 40 (EN); app = P3.6 | ● (1 to 42) | ◐ | ● | ● | ◐ | ○ | ● (day by day) | ● | ● | ● | ● | ● |
| Referenced sources shown | B (99 of 100) | ◐ | ? | ? | ? | ○ | ○ | ◐ | ◐ | ○ | ○ | ○ | ○ |
| Named medical reviewer / review board | ◐ B (25 to 26 of 100 in snapshot; see 0.5) | ● (page-level) | ◐ | ? | ? | ◐ | ○ | ● (Advisory Board, NHS Info Standard) | ● (review board) | ○ | ○ | ○ | ○ (not shown) |
| Review date shown | B (100 of 100 have `lastReviewed`) | ◐ | ? | ? | ? | ○ | ○ | ? | ? | ○ | ○ | ○ | ○ |
| Arabic content | **N today** (0 of 100); P: top 50 in `03` Phase 4 line 248, not in PROGRESS | ○ | ◐ (UI; content unclear) | ○ | ○ | ◐ (UI; content unclear) | ? | ○ | ? | ◐ | ● | ● | ● |
| Languages (UI) | B 4 (AR/EN/FR/ES) | 21 (no AR) | 27 incl. AR | 4 (no AR) | 2 (no AR) | 21 incl. AR | ? | 4 (no AR) | ? | 15 on KR store, no AR | AR | AR + 67 | AR |
| Video | N | ● (premium) | ◐ | ○ | ● weekly | ○ | ○ | ● | ● | ◐ (3D models) | ◐ (courses) | ○ | ◐ |
| Shareable cards / WhatsApp-style sharing | N | ○ | ○ | ○ | ○ | ○ | ◐ | ○ | ○ | ◐ (partner share) | ? | ◐ | ? |
| Search | B (client-side, answers questions) | ● | ? | ? | ? | ? | ? | ● | ● | ? | ? | ? | ● |
| Glossary / FAQ | N (both empty) | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ◐ (Q&A) |

### (b) Web calculators and tools

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | BC | WTE | P+ | Alm | Hay | Alt |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Ovulation/fertile window | B (range, month calendar) | ● | ○ | ○ | ◐ | ○ | ● | ● | ○ | ◐ | ○ | ● |
| Period calculator | B (3 periods, ranges) | ● | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● |
| Due date by LMP | B | ● | ○ | ○ | ○ | ○ | ● | ● | ● | ● | ● | ● |
| Due date by conception / IVF / ultrasound | ◐ B in lib and app onboarding (P3.3), not in the web page | ● (IVF/FET and ultrasound pages) | ○ | ○ | ○ | ○ | ○ | ● (all four) | ○ | ○ | ○ (reviewer complaint) | ◐ conception |
| Pregnancy weeks / months | B | ● | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● | ● | ● |
| Pregnancy test timing | B (NHS rule) | ● | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ |
| Implantation / hCG | N | ● | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ |
| Cycle length | B | ● | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ |
| BMI | B | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● |
| Hijri date input/output | N | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● | ● | ● (Mama) |
| Baby name finder | N | ○ | ○ | ○ | ● | ○ | ● | ◐ | ● | ◐ | ○ | ● (Mama) |
| Results end in app CTA | B | ● | ● | ● | ● | ● | ● | ● | ● | n/a | n/a | ● |

### (c) App tracking functions

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | Ste | Maya | Alm | Hay |
|---|---|---|---|---|---|---|---|---|---|---|
| Period log and calendar | B (P3.4) | ● | ● | ● | ● | ● | ● | ● | ● | ○ |
| Predictions with ranges and confidence | B (P3.3/P3.5) | ◐ | ◐ (wider windows) | ◐ | ◐ | ◐ | ? | ? | ○ | ○ |
| Irregular-cycle mode with no "late" counter | B (onboarding irregular) | ◐ | ? | ● | ● | ◐ | ? | ? | ○ | ○ |
| Symptom/mood log | B (36 symptoms, 9 moods) | ● (70+) | ● (200+) | ◐ | ● | ● (50+) | ● | ● | ● | ○ |
| Local reminders | P (P3.8) | ● | ● | ● | ● | ● | ● | ● | ● | ● |
| Backup/export, new phone | P (P3.8) | ◐ account | ◐ account | ◐ account | ◐ | ● export | ? | ◐ | ◐ | ○ |
| Doctor report (PDF) | P (not in app lines; web summary retired with beta) | ◐ premium | ◐ | ◐ | ○ | ● | ○ | ○ | ○ | ○ |
| Partner view | N | ● | ◐ (Connect) | ● | ● | ● (Predad) | ◐ friends | ○ | ○ | ○ |
| Wearable / Health Connect | N | ◐ Apple Watch | ● | ● | ● | ◐ Apple Health | ○ | ○ | ○ | ○ |
| Home-screen widget | N | ? | ? | ? | ? | ? | ? | ? | ? | ? |
| App lock / PIN | P (P3.8) | ◐ | ? | ? | ● | ? | ? | ? | ? | ? |
| Perimenopause/menopause mode | B web content only (5 articles); N in app | ● | ● | ● | ● | ○ | ○ | ○ | ○ | ○ |

### (d) Pregnancy tools

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | BC | WTE | P+ | Alm | Hay |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Week/day and trimester on home | B (Today) | ● | ◐ | ● | ● | ◐ | ● | ● | ● | ● | ● |
| Due date handling for IVF / conception | B (app); web UI N | ● | ○ | ○ | ○ | ○ | ○ | ● | ○ | ○ | ○ (complaint) |
| Kick / movement counter | P (P3.6; logic B in TS) | ? | ○ | ● | ● | ○ | ○ | ? | ● | ● | ● (SA app) |
| Contraction timer | P (P3.6; logic B in TS) | ? | ○ | ○ | ● | ○ | ○ | ? | ● | ● | ● (SA app) |
| Appointments / checkup reminders | P (P3.6) | ? | ○ | ○ | ○ | ○ | ● | ○ | ● | ● | ● |
| Weight log | P (spec) | ? | ○ | ○ | ○ | ○ | ○ | ○ | ● | ● | ○ |
| Hospital bag / to-do / birth plan | N | ? | ○ | ○ | ○ | ○ | ● checklists | ○ | ● | ● bag | ○ |
| Symptom urgency guidance | B (red-flag classifier in lib; app = P3.6/P3.7) | ◐ | ○ | ○ | ◐ food-safety lookup | ○ | ○ | ○ | ○ | ○ | ○ |
| Baby size visuals / 3D | N (P2.5 illustration set open) | ● | ○ | ○ | ● | ○ | ● | ● | ● 3D | ○ | ◐ |
| Pregnancy loss / early-end path | N | ? | ? | ? | ? | ○ | ? | ? | ? | ○ | ○ (complaint) |
| Postpartum mode | B web content (14 articles); app N | ● | ○ | ● | ● 12-month | ○ | ◐ | ◐ | ○ | ◐ baby to 2y | ○ |
| Ramadan/fasting content and make-up fast tracker | N (plan only) | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● | ○ |

### (e) TTC tools

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | WTE | Alm |
|---|---|---|---|---|---|---|---|---|
| Fertile window and likely ovulation | B (range + confidence) | ● | ● (Conceive, paid) | ● | ● | ● | ● (new 2026) | ● |
| LH/ovulation test log | B (as the stick said) | ● | ● | ◐ | ● | ● (photo reader) | ○ | ○ |
| LH strip photo reader | N | ○ | ○ | ○ | ○ | ● | ○ | ○ |
| BBT chart | B (typed, no shift marked) | ● | ● | ● | ● | ● auto | ○ | ○ |
| Cervical mucus / discharge log | B (5 types; not charted) | ● | ◐ not used in algorithm | ○ | ● | ◐ | ○ | ○ |
| Pregnancy-test timing | B | ● | ○ | ○ | ○ | ○ | ○ | ○ |
| TTC journal | ◐ B daily log | ○ | ○ | ○ | ○ | ○ | ● | ○ |
| "See a clinician after N months" nudge | B (12, or 6 if 35+) | ◐ | ◐ | ? | ? | ◐ | ? | ○ |
| Partner view | N | ● | ◐ | ● | ● | ● | ○ | ○ |
| Wearable temperature | N | ◐ | ● | ● | ● | ◐ | ○ | ○ |
| TTC articles | B 11 (EN) | ● | ● | ◐ | ● | ● | ● | ◐ |
| Contraception/"safe days" | **N by rule** | ● birth control reminder | ● logging | ● core | ● logging | ○ | ○ | ● (safe days) |

### (f) Conditions and PCOS

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | Alt/WebTeb |
|---|---|---|---|---|---|---|---|
| PCOS education | B (hub + 3 articles, EN) | ● (many) | ● (articles) | ○ | ◐ | ● | ● (Arabic, no named reviewer on pages seen) |
| PCOS treatment, lifestyle, nutrition content | N | ● | ◐ | ○ | ◐ | ● (nutrition plan) | ● |
| PCOS self-assessment / screener | P (framework in docs; "screening, discuss with your clinician") | ● (self-assessment, Symptom Checker, premium) | ○ | ○ | ◐ AI assistant (Play snippet) | ● ("PCOS AI") | ◐ PMS checker only |
| Prediction adjusted for PCOS/irregular cycles | B (irregular = wider ranges) | ◐ | ◐ | ● | ● | ● | ○ |
| Endometriosis, heavy and painful periods, PMS/PMDD hubs | B (4 hubs + 8 articles) | ● | ● | ○ | ◐ | ○ | ◐ |
| Thyroid, diabetes in pregnancy | ◐ (thyroid-and-conceiving only; GDM in 2 articles' body text) | ◐ | ◐ | ○ | ◐ | ○ | ● |
| Condition-aware home (Today) | P (P3.7) | ◐ | ○ | ○ | ◐ | ● | ○ |

### (g) Privacy and trust (developer-declared App Store labels; not verified by Apple)

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | Ste | BC | P+ | Alm | Hay-type ("حمل" SA) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| No account needed | B (no accounts v1) | ◐ (Anonymous Mode) | ○ | ○ | ◐ (anonymous mode, Play snippet) | ○ | ○ | ○ | ◐ | ○ | ◐ |
| Health records on device only | B (private file store, no network) | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ○ |
| Ad or analytics SDK reach health data | N (rule) | label shows tracking identifiers and ad/marketing purposes | Identifiers tracked | Contact info tracked | Advertising/marketing purposes | Advertising purposes, payment info linked | Meta/Google ad measurement named (Mozilla) | Third-party advertising | Identifiers tracked | Third-party advertising data; ads | Precise location and advertising data; third-party advertising |
| Export / delete | P (P3.8) | ◐ | ◐ | ◐ | ◐ | ● | ? | ? | ? | ? | ? |
| App lock | P (P3.8) | ◐ | ? | ? | ● PIN | ? | ? | ? | ? | ? | ? |
| Published data map / plain-language privacy | P (P4.1) | ◐ | ◐ | ◐ | ◐ | ◐ | ○ | ◐ | ◐ | ○ | ○ |
| Regulated-device claims | none (rule 1) | ○ | ● Conceive "registered medical device" | ● FDA-cleared contraceptive | ○ | ○ | ○ | ○ | ○ | ○ ("safe days as contraception aid" implied) | ○ |

### (h) Localisation and Arabic

| Capability | Femio | Flo | Clue | NC | Ovia | Premom | BC | P+ | Alm | Hay | Alt/WebTeb |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Arabic UI | B (full) | ○ | ● | ○ | ○ | ● | ○ | ○/? | ● | ● | ● |
| RTL layout quality verified in the product | B (screens shot en/ar, light/dark) | n/a | ? | n/a | n/a | ? | n/a | n/a | ? | ? | ? |
| Arabic medical content | **N** | ○ | ? | ○ | ○ | ? | ○ | ? | ● | ● | ● |
| Hijri calendar | N | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● | ● | ● (Mama) |
| Western vs Arabic-Indic digits choice | B (Western digits by default) | n/a | ? | n/a | n/a | ? | n/a | n/a | ? | ? | ? |
| Ramadan content | N | ○ | ○ | ○ | ○ | ○ | ○ | ○ | ● | ○ | ? |
| Gulf/Egyptian dialect copy | ? (MSA UI) | n/a | ? | n/a | n/a | ? | n/a | n/a | ● | ● | ● |
| Arabic web SEO presence (Semrush, monthly organic visits, 2026-10) | none (no Arabic pages) | SA 4.2K / EG 3.4K | ? | ? | ? | ? | ? | ? | ? | ? | Altibbi SA 3.30M, EG 9.14M; WebTeb SA 1.45M, EG 1.73M |

## 4. Recommendations

Effort: S under a week, M one to three weeks, L over three weeks. "Planned?" cites `PROGRESS.md` (PR) or another doc.

### P0: needed to compete in the wedge at launch

| # | What | Why (who has it, what reviews say) | Effort | Rule that constrains it | Planned? |
|---|---|---|---|---|---|
| P0-1 | **Arabic parity for the wedge's top 50 questions** (TTC, pregnancy weeks, first-trimester warning signs, PCOS), same sourcing and review standard, with `lang`/`dir` and per-locale review state | Altibbi and WebTeb own Arabic search (millions of visits per month per country); Al-Malika, Hayah, Altibbi Mama all ship Arabic content. Femio has 0 of 100. Without it the Play listing and the website cannot rank or be trusted in Arabic. Translation is not enough: use the Arabic reviewer and Gulf/Egypt phrasing. | L | Rule 6 (Arabic first-class); medical-content standard (cited, reviewed, grade 6 to 8); rule 1 in wording. Needs the Arabic reviewer (OWNER_ACTIONS B) | In `03_REVAMP_PLAN.md` Phase 4 (line 248) and TD-08; **no line in PROGRESS.md. Add one.** |
| P0-2 | **Pregnancy toolset in the app**: week/day and trimester, kick counter, contraction timer, appointments, weight log, hospital-bag checklist | Table stakes in Ovia, Pregnancy+, Al-Malika, Hayah and the SA "حمل" app. Hayah's rating is built on it. | M to L | Rule 1: kick counter shows her own pattern and a "contact your clinician" line from the existing `comparePattern` threshold, never "baby is fine". Rule 3: due date as range around the date. Local-only data | P3.6 covers kick counter, contraction timer, appointments, week-by-week; weight and hospital bag are in the spec (section 4) but not in the P3.6 line |
| P0-3 | **Dating by method, with a visible choice** (LMP, conception, IVF/FET transfer, ultrasound) in the app and the web due-date page | Hayah reviews: "inaccurate results for IVF pregnancies, no option to specify pregnancy type". Flo and What to Expect offer IVF/FET and ultrasound modes. Femio's engine already does LMP, conception and transfer. | S | Rule 3: show the date as an estimate with a range; flag that ultrasound dating overrides LMP when a clinician gave it | App onboarding done (P3.2/P3.3, "edd-from" fixtures); web UI and an ultrasound option not in PROGRESS |
| P0-4 | **Hijri and Gregorian dates** everywhere a date is entered or shown (onboarding, calendar, due date, calculators) | Al-Malika, Hayah and Altibbi Mama all lead with it; the Saudi market uses Hijri for appointments. Femio has none. | S to M | Rule 6; keep Gregorian as the stored value, Hijri as display/entry only; confirm Western digits and the Saturday-first week still hold | Not in PROGRESS or spec; `02` launch-ten item 1 mentions it |
| P0-5 | **Articles, conditions and PCOS hub inside the app, in Arabic** | Every competitor puts content in the app. The PCOS wedge needs more than 3 articles and a hub: add treatment options a clinician may discuss, lifestyle/insulin resistance, irregular-cycle TTC, hirsutism/acne, and the PMOS rename (see 5.2). | M (app) plus L (content, overlaps P0-1) | Rule 1: "options to discuss with your clinician", no dosing, no "you have PCOS"; Rule 2: offered by card, never gating knowledge | P3.7 (open). The extra PCOS topics are not listed |
| P0-6 | **Reminders with local notifications** | Every tracker has them; "notification spam" is also 10% of low reviews, so make them opt-in per type | S to M | Rule 4: local only, no notification text that reveals health to the lock screen by default | P3.8 (open) |
| P0-7 | **Backup/restore and app lock**, since there is no account | Premom exports; Ovia has a PIN. The top-cited 1 to 3 star complaint in `02` is years of history lost on a new phone; a no-account design makes this the only recovery path | M | Rule 4; encrypt the file; no cloud copy by default | P3.8 (open) |
| P0-8 | **Verifiable privacy page and Play Data safety in Arabic**, with the plain-language data map ("records stay on this phone, no ad or analytics SDKs") | All 10 apps with store labels declare linked health or sensitive data; Al-Malika and the SA "حمل" app declare third-party advertising data. This is the only wedge differentiator that competitors cannot copy without a rebuild. | S | Rule 4; claims must be literally true (crash reporting without content must be described accurately) | P4.1, P4.2 (open) |
| P0-9 | **Ramadan content hub** (pregnancy, cycle, PCOS, diabetes in pregnancy; red-flag box) plus an optional make-up-fast day counter | Al-Malika has Ramadan courses and a make-up fast tracker; no clinical competitor owns it; Ramadan 2027 begins around 8 February, which is a hard content deadline inside the first three months after launch | M | Rule 1: clinician-voiced wellness guidance; no fiqh rulings, no haid/istihada classification (leave to scholars) | `03` Phase 4 line 247 (content only); the counter is not planned; **no PROGRESS line** |

Why P0-9 is P0 rather than P1: the 2027 Ramadan lands roughly four months after a mid-October soft launch; the content needs the Arabic reviewer and a lead time.

### P1: within three months of launch

| # | What | Why | Effort | Rule | Planned? |
|---|---|---|---|---|---|
| P1-1 | **Doctor-visit summary as a shareable PDF** (cycles, symptoms, pregnancy data, her questions) | Premom exports reports; Flo and Clue charge for them. Gap register TD-05 calls "my questions" the highest-value pregnancy tool and nothing in the market connects it to a clinician summary | M | Rule 4: file generated on the phone, shared by her choice (WhatsApp) | Not in PROGRESS (summary existed on the retired web app) |
| P1-2 | **Pregnancy-loss / early-end path** (end a pregnancy without a countdown, supportive content, clinician follow-up) | Hayah reviewers: "no adjustment when a pregnancy ends early". Compassion and trust; no competitor found handles it well | S to M | Rule 1: supportive education plus "see your clinician"; no "was it your fault" content | Not planned |
| P1-3 | **Shareable WhatsApp cards** (week card, fertile-window card, red-flag card) | Main viral channel in KSA/EG per `02` section 6; Pregnancy+ and Hayah rely on sharing and community | S to M | Rule 4: card content generated on-device from her data only if she taps share; default card has no personal data | `02` launch-ten item 10; not in PROGRESS |
| P1-4 | **Baby name finder** (Arabic and Islamic names with meaning, origin, sound) | Ovia, BabyCenter, Pregnancy+, Altibbi Mama, Hamila (search result) all ship names; cheap, high engagement, low medical risk | S | None medical; cultural review of meanings | Not planned |
| P1-5 | **Conservative PCOS pattern view** (cycle-length spread, BBT/LH traces, acne/hair logged) with a high referral threshold | Premom ("PCOS AI") and Flo (Symptom Checker, self-assessment) lead; the VICE/Lown reporting in `02` shows Flo's tool sent ~38% of completers to a doctor against 4.6 to 8% prevalence. Honest and under-referring is a differentiator | M | Rule 1 (screening, not diagnosis), Rule 3 (ranges) | P3.7 mentions a PCOS hub; screener design not in PROGRESS |
| P1-6 | **Partner share as a read-only card or link, no account** | Flo for Partners, Clue Connect, Premom Predad, Ovia, Pregnancy+ all offer it; marriage-context fit in MENA | M | Rule 4: no server copy by default; a signed, expiring snapshot or a card image | `02` launch-ten item 9; not in PROGRESS |
| P1-7 | **Short doctor-voiced video or audio in Arabic** for the top 10 questions | Flo (premium videos), BabyCenter ("Inside the Uterus"), Ovia weekly videos | M to L | Medical-content standard (cited, reviewed); captions in Arabic | Not planned |
| P1-8 | **Fill the week-by-week set** (weeks 1 to 3 and 41 to 42) and add pregnancy-loss and ectopic warnings next to week 4 to 9 | Flo covers 1 to 42; Femio 4 to 40 | S | Medical-content standard | Not planned |
| P1-9 | **Web due-date and ovulation calculators in Arabic with Hijri output**, plus new calculators for implantation and hCG-doubling (if it can be framed as a range that is not diagnostic) | The Arabic calculator SERP is dominated by Altibbi, WebTeb, miqatona and hijri-calendars pages. Flo has implantation and hCG tools | S to M | Rule 1: hCG interpretation is clinical territory; show only the typical-range reference and "ask your clinician"; leave out if it cannot be framed so | P2.6 done for English; Arabic and Hijri not planned |
| P1-10 | **Android widget (Today)** | Competitor parity; cheap retention. No competitor listing described one, so unverified | S to M | Rule 4: widget text must not reveal health data on a locked screen unless she opts in | TD-15 in the gap register; not in PROGRESS |

### P2: later

| # | What | Why | Effort | Rule | Planned? |
|---|---|---|---|---|---|
| P2-1 | Health Connect temperature/wearable import | Clue, Natural Cycles, Oura, Premom sync | M | Rule 4: read-only, on device | Deferred in `02` section 11.2 |
| P2-2 | LH strip photo reader | Premom's selling point | L | Rule 1 and 3: report the line intensity as read, not "ovulation confirmed"; run on-device only | Not planned |
| P2-3 | IVF protocol and medication calendar | Valuable for TTC; builds on dating work | L | Rule 1: reminders only, no dosing advice | `02` section 11.2 |
| P2-4 | Postpartum and baby modes in the app (12-month programme as Ovia) | Ovia, Natural Cycles, BabyCenter | L | Rule 1 | Content exists (22 articles); app not planned |
| P2-5 | Perimenopause/menopause module in the app | Flo, Clue, Ovia, NC all have one | L | Rule 2 (personalise, never restrict) | Deferred in `02` |
| P2-6 | French and Spanish content | Spread-thin risk | L | n/a | Deferred |
| P2-7 | Community, in-app clinician consults, AI assistant | Al-Malika, Hayah, Altibbi, Flo, Premom have them | XL | Owner deferred (OD-8, OD-9) | Out of scope |
| P2-8 | Teen mode | Highest duty of care | L | Rule 2 | Deferred until legal |

## 5. Where Femio already leads, and the content gaps

### 5.1 Where Femio already leads

1. **Verifiable privacy.** No account, records on the phone, no network in the store layer. Every competitor with an App Store label declares linked health or sensitive data, and Flo, Clue, Natural Cycles, Premom, BabyCenter, Pregnancy+, Al-Malika and the SA "حمل" app each declare identifiers, contact, location or advertising data used for tracking or ads. Stardust's ad-measurement recipients were reported by Mozilla.
2. **Ad-free and honest about it.** Al-Malika, Hayah and the SA "حمل" app are ad-funded with intrusive-ad reviews; Femio has no billing or ads.
3. **Arabic UI quality.** Full four-language parity, native RTL, per-glyph Arabic type stacks, Western digits, Saturday-first calendars in Arabic, an explicit "not translated yet" note on fallback content. Only Clue and Premom among global apps ship Arabic at all, and Flo's help centre describes technical difficulty.
4. **Uncertainty-honest predictions.** Period forecast from her own shortest and longest cycle, fertile window with confidence, BBT chart that draws her readings with no shift or ovulation day marked, no "late" counter in irregular mode. Flo's web due-date page assumes a 28-day cycle (snippet); Femio's `estimateDueDate` adjusts by cycle length and returns the 37 to 42 week window.
5. **Pregnancy dating that follows the method.** LMP, conception, IVF/FET transfer (3 or 5 day embryo) and "I know my due date", driven by shared golden fixtures in TypeScript and Dart. Directly answers Hayah's most specific complaint.
6. **Conservative clinical framing.** "Screening, discuss with your clinician", no contraception lane (Natural Cycles, Clue Conceive and Al-Malika's "safe days" all sit near or inside regulated territory), no gender-prediction charts (WebTeb lists a "Chinese chart for predicting the baby's sex").
7. **Content depth across life stages with sources.** 100 articles, 99 with citations, 100 with review dates, 14 postpartum and 8 newborn articles that Arabic competitors lack, and a red-flag urgency classifier for pregnancy symptoms.
8. **Everything free at launch.** Compare Flo (core free, depth premium), Clue Plus US$39.99 per year, Natural Cycles US$149.99 per year, Al-Malika US$29 per year, SAR 149.99 per year for the SA "حمل" app.

Caveat: leads 3 to 7 are leads on the engine and UI. Until P0-1 lands, lead 7 is English only and the "Arabic-first" claim holds for the interface, not the knowledge.

### 5.2 Content gaps (specific titles, ranked by wedge relevance)

Evidence for "missing": body-text counts across all 100 English articles (e.g. miscarriage 1 article, ectopic 1, hyperemesis 0, IVF 2, gestational diabetes 2, folic acid 4, ramadan 0, fasting 0, metformin 0, inositol 0, letrozole 0, male factor 0, consanguinity 0, thalassemia 0, vitamin D 0). No dedicated article exists for any item below. Each should be written Arabic-first or Arabic-in-parallel.

**Top 10 (recommended order)**

1. **الحمل في رمضان: الصيام أثناء الحمل، علامات الخطر ومتى تفطرين** (Fasting in Ramadan while pregnant: risks, red flags and when to stop and call). Plus a companion for the breastfeeding mother and one for PCOS and diabetes. Nobody clinical owns it; Al-Malika has courses only.
2. **Trying to conceive with PCOS: ovulation, timing and when to see a specialist** (تكيس المبايض والحمل: كيف أحدد التبويض ومتى أراجع الطبيبة). The wedge's depth article; includes irregular cycles and BBT/LH test interpretation limits.
3. **PCOS lifestyle, insulin resistance and what treatments a clinician may discuss** (metformin, inositol, letrozole/clomiphene, as options to discuss, no doses). Competitors lead with Premom's nutrition plan; Femio has none.
4. **PCOS is being renamed PMOS: what the change means** (Clue already writes "PCOS (now PMOS)"). Also **PCOS symptoms beyond the ovaries: acne, hair growth, hair loss, weight, mood** (hirsutism and acne appear 0 times).
5. **Ovulation tests, BBT and cervical mucus: how to use them and how to read them** (اختبار التبويض، الحرارة القاعدية، إفرازات الخصوبة). The app has the tools (P3.5); the library has no explainer, so the tool has nothing to link to.
6. **Gestational diabetes: screening, targets, what to expect** and **Pre-eclampsia: blood-pressure signs and when it is an emergency**. Both are tied to the wedge, are Arabic search topics with high intent, and are central to Ramadan guidance.
7. **Miscarriage, ectopic pregnancy and bleeding in early pregnancy**: what is common, what is an emergency, and what follows (one supportive article each). Also **recurrent miscarriage: when to seek tests**. Required for P1-2.
8. **IVF and IUI explained: steps, dating the pregnancy, what the two-week wait feels like** and **male-factor fertility: semen analysis, what affects it**. Egypt and the Gulf have high IVF use; Hayah reviews prove the dating pain point; male factor appears in 0 articles' headline coverage.
9. **Nausea and hyperemesis in pregnancy; vomiting that needs a clinician** (hyperemesis 0 articles), **iron, anaemia and folic acid supplements**, **vitamin D**, **exercise in pregnancy**, **food and caffeine safety**. The everyday pregnancy questions that Ovia's food-safety lookup and Pregnancy+ guides answer.
10. **Antenatal tests and scans by trimester (NT scan, anomaly scan, glucose test, Rh factor), labour stages, caesarean versus vaginal birth, and building a birth plan.** Gives the P3.6 appointments feature content to attach to; Rh appears in only 3 articles' body text.

**Further gaps (lower rank)**

- Premarital and preconception screening in the region: consanguinity, thalassaemia and sickle cell carrier testing, vaccination (rubella, MMR) before pregnancy.
- Pregnancy weeks 1 to 3 and 41 to 42; twins; pregnancy after 35.
- Postpartum depression as its own article (the term appears in 0 articles; `mood-after-birth` covers it under "baby blues, depression and anxiety").
- Pregnancy loss and stillbirth support; breastfeeding while fasting; cultural postpartum practices (the 40 days).
- HPV and cervical screening, UTI and thrush in pregnancy (UTI-type terms appear heavily only as keywords).
- A glossary and FAQ entries (both files are empty in all four languages); Arabic FAQ is a quick SEO win for question searches.

## 6. Verification limits and what the owner could still get

- Arabic SERP positions (what ranks for "حاسبة الحمل" in KSA/EG) were not obtainable: the Ahrefs SERP and keyword tools returned "Insufficient plan". Semrush returned domain-level traffic only. A Semrush `organic_research` or `position_tracking` run on altibbi.com, webteb.com and sayidaty.net would give keyword lists for the content-gap work.
- Installed base in KSA and Egypt per app is unknown. Prior research already has Flo at #4 H&F in Egypt and #26 in Saudi Arabia (iOS). Hayah's 2.5M+ downloads and 344K ratings come from a store mirror and are the best Arabic-pregnancy signal.
- Google Play listings could not be read; label comparisons use App Store labels. Play "Data safety" sections can differ.
- BabyCenter and What to Expect websites could not be fetched; their tools and content rows use app store text and snippets. Pregnancy+ language lists conflict between storefronts.
- Maya's Arabic support, Stardust's feature set and Flo's kick-counter/contraction-timer support are unverified.
- Hamila (Islamic baby names, daily duas) appeared in one search result but was not checked on its store page; it is not counted in the matrix.
