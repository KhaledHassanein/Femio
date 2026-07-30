# Persona D1 — Uncomplicated, Low-Risk Pregnancy

Prepared: 2026-07-16 · Wave 1 (spine) · Status: research + spec
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening, discuss with clinician."**

---

## A. Persona snapshot

**Who she is.** A pregnant woman with a singleton, low-risk, medically uncomplicated pregnancy. No pre-existing diabetes/hypertension/thyroid disease, no prior loss driving acute anxiety (that is D2), no multiples (D9). She may be a first-time mother (highest information appetite) or a multip wanting lighter-touch tracking. Frequently a **prior Femio cycle/TTC user** whose account converts on a positive test — her history (cycle length, LMP, TTC logs, pre-existing conditions flagged as "none") carries in and seeds gestational age.

**Core job.** "Walk me through my pregnancy week by week — what's happening to my baby and body, what's normal, what to do at each appointment, and tell me clearly when something needs a doctor — without ads, scare content, or selling my data."

**Emotional arc.**
- **T1 (wk 4–13):** excitement + private anxiety (miscarriage fear, symptoms feel invisible, "is this normal?"), nausea/fatigue management, deciding who to tell, first-appointment prep, screening decisions (NIPT/first-trimester screen framed as *screening*).
- **T2 (wk 14–27):** the "golden trimester" — energy returns, anatomy scan (~18–22 wk), feeling first movement (~16–25 wk), name/registry/planning, glucose screening (~24–28 wk), weight-gain awareness.
- **T3 (wk 28–40+):** discomforts (heartburn, back pain, swelling, sleep), fetal-movement awareness / kick counting, birth-plan + hospital bag, warning-sign vigilance (pre-eclampsia, reduced movement), "am I in labour?" contraction timing, due-date anxiety and post-dates.

**Context.** Web-first, mobile-heavy. Arabic-first / RTL primary with EN/AR/FR/ES. Likely to open the app several times a week (daily in T1 and late T3). Values a calm, honest, uncluttered experience and a partner who can follow along (X2 partner mode).

**Success = she feels informed, reassured, and safe**, keeps her appointment/checklist state in one place, and trusts that a genuine red flag will be surfaced loudly and routed to care — not buried under a fruit-of-the-week card.

---

## B. Needs & questions (voice-of-user)

Mined from r/BabyBumps, What to Expect / BabyCenter community threads, and app-store reviews. Representative real questions, grouped by job-to-be-done. Verbatim-style paraphrases.

**Reassurance / "is this normal?" (dominant emotional need, all trimesters)**
- "My symptoms disappeared for a day at 9 weeks — is that bad?"
- "I'm 6 weeks and terrified something will go wrong before my first scan."
- "Brown spotting at 8 weeks — do I need to be seen or is this normal?"
- "Haven't felt the baby move much today, when do I actually worry?"

**Fetal development curiosity**
- "How big is the baby this week and what's actually forming right now?"
- "Can the baby hear me yet?"
- Complaint: *"I'm sick of fruit comparisons — a mango is not a real size. Just give me cm and grams."* (recurring, strong signal)

**Symptom guidance (self-care within scope)**
- "What actually helps first-trimester nausea?" "Is it safe to take X for a headache?" (→ never dose/prescribe; frame as "commonly discussed with your clinician; here's general info")
- "Round ligament pain vs something serious — how do I tell?"
- "Heartburn/constipation/insomnia — what's normal and what helps?"

**Appointments, tests & checklists**
- "What happens at each prenatal visit and what should I ask?"
- "When is the anatomy scan / glucose test / Tdap / whooping-cough / flu shot?"
- "What's the difference between a screening test and a diagnostic one?" (NIPT anxiety is huge)
- "I keep losing track of appointments and results across texts and portals."

**Weight & nutrition**
- "How much weight *should* I be gaining — am I gaining too fast/too little?"
- "What foods do I actually have to avoid, and what's overblown?"
- "Which prenatal vitamin, and is folic acid enough?"

**Kick counting (T3)**
- "When do I start counting kicks and how do I do it properly?"
- "The app told me to 'count kicks' but not what a normal result is."

**Labour readiness (late T3)**
- "Braxton Hicks vs real contractions — how do I time them and when do I go in?"
- "What goes in the hospital bag / what's a birth plan?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Ads and sponsored/product-placement clutter around emotionally loaded content.
- Clickbait / anxiety-inducing content and unmoderated forum drama.
- Privacy dread — "I don't want my pregnancy sold to advertisers or visible to my employer."
- Apps that handle loss badly (forcing a loss to be logged as a "period," stale reminders after a loss).
- Wanting **one account** that remembers her cycle/TTC history rather than a separate pregnancy silo.

---

## C. Competitor teardown

Feature-by-feature read of the apps D1 will compare Femio against. Focus: week content, visuals, kick counter, contraction timer, checklists, weight tracker, appointment logs, and the **privacy + content-honesty** angle where Femio differentiates.

| Capability | What to Expect | BabyCenter | Pregnancy+ (Philips) | Ovia Pregnancy | Flo (pregnancy mode) | The Bump |
|---|---|---|---|---|---|---|
| Week-by-week / daily content | Strong editorial (book brand); daily updates; **busy, ad-heavy UI** | Large content library; **heavily commercialized, product placement** | Solid weekly articles | Weekly + personalized insights from logged data | Weekly + daily "insight stories" (premium) | Weekly, lighter |
| Fetal size metaphor | Fruit/veg | Fruit/veg | Fruit + real dimensions | Fruit/toy/pastry/animal + life-size hands/feet | Fruit | Fruit ("carrot" era) |
| 3D / rich visuals | 3D visuals | Illustrations | **Best-in-class interactive, zoomable 3D models** | Weekly 3D illustrations | Illustrated | Illustrations |
| Kick counter | Yes | Yes | Yes | Yes | Limited | Limited |
| Contraction timer | Yes | Yes | Yes | Yes | No/limited | Basic |
| Checklists (to-do/appointments) | Yes | Yes | Appointment reminders | Yes, detailed | Reminders | Registry/checklist |
| Weight tracker | Yes | Yes | Yes | **Detailed health logging + insights** | Symptom/weight logging | Light |
| Appointment log / results | Basic | Basic | Reminders | Better structured logging | Reminders | Basic |
| Community forum | **Very large** | **Very large, moderation hit-or-miss** | Minimal | Minimal | Sec. groups | Moderate |
| Languages / RTL | EN-centric | Multi (no true Arabic-first) | Multi | EN-centric | Multi | EN-centric |

**Privacy posture (Femio's wedge).**
- **What to Expect** — reported to sell personal data to third parties for targeted advertising.
- **BabyCenter** — sells data to third parties; named in a 2024 US Senate Commerce Committee inquiry into data-broker practices.
- **Pregnancy+** — reported data sharing with Facebook/Instagram/Pinterest/Google for advertising.
- **Ovia** — owned by Labcorp; employer/health-plan-sponsored versions have drawn concern over employer/insurer visibility into pregnancy status.
- **Flo** — 2021 FTC settlement over misleading handling of health data shared with third parties (Google, Facebook, etc.); later added "Anonymous Mode," which reduces but does not eliminate data risk.

**Content-quality gaps Femio exploits.** Ad/sponsored clutter around emotionally loaded moments; clickbait and anxiety-driving content; unmoderated forum drama; poor handling of loss; separate pregnancy silos that forget the user's own history.

**Femio's differentiated position for D1.**
1. **One account, continuity of self** — cycle/TTC history carries in; no re-onboarding; loss handled with dignity (see J).
2. **Privacy-by-design** — no data sale, no ad-targeting SDKs, no employer visibility; explicit, minimal data collection (compliance skill).
3. **Referenced, medically-reviewed, honest content** — every claim cited to Tier-1/Tier-2 sources; real measurements *and* an optional friendly metaphor; grade 6–8 reading level; no clickbait.
4. **Arabic-first / RTL** done properly, plus EN/FR/ES.
5. **Calm, uncluttered, red-flag-forward** safety UX rather than buried warnings.

---

## D. Clinical grounding (cited)

All figures below are **education, not medical advice**; app copy must attribute to these bodies and defer dosing/decisions to the user's clinician.

**Prenatal-care schedule.** The long-standing model for a healthy, low-risk pregnancy is ~12–14 visits: roughly every 4 weeks to 28 weeks, every 2 weeks from 28–36 weeks, then weekly to delivery. ACOG's 2025 Clinical Consensus ("Tailored Prenatal Care Delivery") supports **individualized schedules for average/low-risk patients — potentially fewer in-person visits (evidence supports 6–10) plus telehealth** — with an initial comprehensive assessment ideally **before 10 weeks**. → App framing: show a *typical* schedule as a checklist, always "your clinic's plan may differ." [ACOG 2025; NICE NG201]

**Gestational weight gain (2009 IOM/NAM ranges, by pre-pregnancy BMI, singleton).**
- Underweight (BMI < 18.5): **12.5–18 kg (28–40 lb)**
- Normal (18.5–24.9): **11.5–16 kg (25–35 lb)**
- Overweight (25–29.9): **7–11.5 kg (15–25 lb)**
- Obese (≥ 30): **5–9 kg (11–20 lb)**
→ Present as a **guidance band**, computed from her booked pre-pregnancy BMI; never a scored "pass/fail," never a target she is pushed toward. [IOM 2009 via CDC & ACOG]

**Urgent maternal warning signs (CDC "Hear Her").** Seek care immediately for: severe/worsening headache that won't go away; vision changes; dizziness/fainting; **vaginal bleeding or fluid leaking during pregnancy**; chest pain or fast-beating heart; trouble breathing; severe belly pain that doesn't go away; severe nausea/vomiting (not like morning sickness); **fever ≥ 100.4°F / 38°C**; extreme swelling of hands/face; thoughts of self-harm; and, in T3, a **noticeable decrease in fetal movement**. "You know your body best — if something feels off, contact your provider." → These populate Femio's red-flag boxes verbatim-in-spirit. [CDC Hear Her]

**Fetal movement / kick counting.** Commonly begins around **28 weeks** (some high-risk from ~26). A widely taught method: time how long to feel **10 movements** (kicks/rolls/jabs, not hiccups), typically within ~2 hours; get to know your baby's own pattern. A change/decrease in movement should prompt **same-day contact with the provider** — do not wait. → Kick-counter tool unlocks in T3; result copy points to "contact your provider" for decreased movement, never "your baby is fine/at risk." [ACOG; Count the Kicks; Cleveland Clinic]

**Nutrition & supplements.** **Folic acid 400 mcg/day** (higher 5 mg only if a clinician prescribes for elevated risk) to reduce neural-tube-defect risk; **vitamin D 10 mcg/day** in pregnancy/breastfeeding (per NHS). Avoid high-dose vitamin A / retinol / liver / cod-liver-oil supplements. General "foods to be cautious with" education (certain cheeses, undercooked meats, high-mercury fish, unpasteurized products, limiting caffeine) framed as general guidance, deferring specifics to clinician/local guidance. [NHS; NIH ODS; RCOG]

**Screening vs diagnostic.** Serum/ultrasound screening and cell-free DNA estimate chance and are not equivalent to diagnostic testing; a positive screen requires clinician-led counseling and an offer of diagnostic testing. ACOG recommends offering a second-trimester ultrasound for structural defects, ideally at **18–22 weeks**. Glucose-screen timing is shown only from the user’s clinician or an approved country guideline, not as a universal app order. Every result surface says “screening, not a diagnosis—discuss the result with your clinician.” ([ACOG current NIPT guidance](https://www.acog.org/advocacy/policy-priorities/non-invasive-prenatal-testing/current-acog-guidance), accessed 24 July 2026) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Resolved source set.** Gestational-weight-gain education uses ACOG’s [Weight Gain During Pregnancy](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2013/01/weight-gain-during-pregnancy) and the National Academies’ [2009 report brief](https://nap.nationalacademies.org/resource/12584/Report-Brief---Weight-Gain-During-Pregnancy.pdf). International antenatal-care framing uses the [WHO 2016 ANC guideline](https://www.who.int/publications/i/item/9789241549912), which recommends a minimum of eight contacts. This is a care-model reference, not a schedule Femio imposes: the user follows her maternity team’s locally applicable plan. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — must-have (the D1 spine)**
1. **Week-by-week home** driven by gestational age (from LMP/EDD carried in or entered): "This week" card = fetal development (real cm/g **and** optional metaphor, toggle), body changes, 1–3 curated tips.
2. **Referenced content library** — trimester-organized, searchable, every article citation-backed and medically reviewed; nothing locked (personalize, never restrict).
3. **Appointment & checklist tracker** — typical-schedule checklist, custom appointments, "questions to ask," reminders; log visit notes/results manually.
4. **Symptom & mood log** (lightweight, continuous with her prior cycle-tracking UX).
5. **Weight-gain guidance** — IOM band from pre-pregnancy BMI, trend chart, non-judgmental framing.
6. **Red-flag safety layer** — persistent "Urgent warning signs" access + contextual red-flag boxes on relevant content, with "seek care now" framing and (optional) saved local emergency/maternity contact.

**P1 — high value**
7. **Kick counter** (unlocks ~28 wk; educational, not diagnostic).
8. **Contraction timer** (unlocks ~T3; "timing tool, not a labour diagnosis").
9. **Partner/shared view (X2)** — read-mostly follow-along.
10. **Rich fetal visuals** (illustrated → optional 3D later) to match Pregnancy+ expectation.

**P2 — differentiators / later**
11. Birth-plan builder + hospital-bag checklist.
12. Kick-count / weight / appointment **export (PDF)** to show her clinician.
13. Gentle, moderated community or curated Q&A (privacy-safe) — only if moderation quality is guaranteed.
14. Photo/bump journal (private by default).

**Explicitly out of scope (compliance):** contraction/kick tools that *interpret* results as "you're in labour" / "baby is fine"; any dosing calculator; any "your pregnancy is high/low risk" auto-classification presented as a verdict; contraception features (irrelevant here).

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL). Delivered gestational-age-gated but always searchable.

- **"This week" development** — one card/week, wk 4–42: what's forming, size (cm/g + metaphor), what she may feel.
- **Trimester primers** — T1 / T2 / T3 orientation hubs.
- **Symptom explainers** — nausea, fatigue, heartburn, constipation, back/round-ligament pain, swelling, sleep, Braxton Hicks — each with a "when this could be a red flag → seek care" callout.
- **Appointments & tests** — what happens at each visit; screening vs diagnostic explainer (NIPT anxiety module); anatomy scan; glucose screening; vaccines (flu, Tdap/pertussis) framed as "discuss with your clinician."
- **Nutrition & supplements** — folic acid / vitamin D, foods to be cautious with, caffeine, hydration; honest "overblown vs real" tone.
- **Weight-gain guidance** — the IOM bands, why they vary, non-judgmental.
- **Movement & kick counting** — what to expect by week; how to count; "decreased movement = contact provider today."
- **Warning-signs hub** — CDC Hear Her list, always reachable; pre-eclampsia awareness (as symptoms-to-report, never diagnosis).
- **Preparing for birth** — birth-plan basics, hospital bag, signs of labour, "when to call/go in."
- **Emotional wellbeing** — normal worry, when low mood needs support (soft pointer to EPDS-based screening = "screening, discuss with clinician"; deeper = persona D11/postpartum).
- **Continuity note module** — "Your cycle/TTC history is here" reassurance + how privacy works.

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs & tools**
- **Symptom/mood log** (continuous from cycle era).
- **Weight log** → trend vs IOM band. Copy: *"This is general guidance based on IOM ranges — your clinician sets what's right for you."* No pass/fail scoring.
- **Appointment log** — date, type, provider, notes, results (user-entered), reminders.
- **Checklist** — typical prenatal schedule + custom, all editable.
- **Kick counter (T3)** — logs time-to-10-movements; shows *her own* pattern trend. Copy: *"A tracking aid, not a medical test. If you notice your baby moving less than usual, contact your provider today — don't wait."*
- **Contraction timer (T3)** — logs frequency/duration. Copy: *"A timing tool, not a diagnosis of labour. Follow your provider's guidance on when to call or go in."*
- **Optional export (PDF)** of logs for appointments.

**Alerts (all opt-in, calm, non-alarmist)**
- Appointment/checklist reminders.
- Gestational-milestone nudges (e.g., "~28 weeks — kick counting is now available").
- Content nudges ("This week's development is ready").
- **No** predictive/diagnostic alerts. **No** "you're at risk" pushes.

**Red-flag box pattern (reusable component).**
> **⚠ Seek care now**
> Contact your maternity provider or local emergency number immediately if you have: heavy vaginal bleeding or fluid leaking · a severe headache that won't go away or vision changes · trouble breathing or chest pain · severe belly pain · fever of 38°C/100.4°F or higher · sudden severe swelling of face/hands · (after ~28 wk) your baby moving noticeably less than usual · thoughts of harming yourself.
> *You know your body best — if something feels wrong, get it checked. This app can't diagnose or treat.*
> [Save my maternity/emergency contact] [Learn the warning signs]

Placement: persistent entry in nav + auto-injected at the bottom of every symptom explainer whose topic has an associated danger sign (bleeding, headache, swelling, movement, abdominal pain).

---

## H. EMR fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC)**
- Identity/account, locale/language, units.
- DOB / age; height; pre-pregnancy weight & BMI.
- Menstrual history: typical cycle length, LMP.
- Medical history flags (diabetes, hypertension, thyroid, prior VTE, etc. — here mostly "none" → keeps her D1).
- Medications, allergies, supplements.
- Prior pregnancies/outcomes (gravida/para), incl. prior loss flag (routes to D2 sensitivity if set).
- Consent/privacy settings; emergency/maternity contact (optional).

**Persona-specific (pregnancy / D1)**
- **EDD / gestational age** — derived from LMP or clinician-set EDD (dating-scan override); single source of truth for all gating.
- Confirmed pregnancy date / positive-test date (the C→D transition marker).
- Singleton vs multiple (multiple → D9).
- Blood type & Rh status (Rh-neg → D17 awareness) — user-entered.
- Prenatal visit log (date/type/provider/notes/results).
- Screening/test milestones logged (NIPT/first-tri screen result *as recorded by user*, anatomy scan, glucose screen) — stored as user notes, not app interpretation.
- Weight-gain series; symptom/mood series; BP if user chooses to log (elevated readings → surface warning-sign content + D5/D6 awareness, never diagnosis).
- Kick-count sessions; contraction-timer sessions.
- Fetal-movement-noticed flag.
- Birth preferences / hospital-bag checklist state.

---

## I. Personalization rules (wizard → home config)

**Wizard (short, editable/resettable in settings — personalize, never restrict).**
1. "Are you currently pregnant?" → yes enters/confirms pregnancy mode. (Prior TTC user: auto-prompted on logging a positive test.)
2. EDD or LMP (or "I'll add it later" → generic pregnancy home until set).
3. First pregnancy? (multip → lighter default content density).
4. Any conditions your clinician is watching? (all "no" → stays D1; any "yes" → blends toward D3–D17 emphasis without hiding anything).
5. Partner sharing? (X2). 6. Notification/privacy preferences.

**Home configuration (all gestational-age-driven).**
- **GA computes everything:** the "This week" card, which trimester hub is featured, which tools are surfaced.
- **T1 home:** development card, early-symptom self-care, first-appointment prep, reassurance + warning-signs entry, screening explainer.
- **T2 home:** development card, anatomy-scan + glucose-screen prep, weight-gain guidance foregrounded, movement-education primer.
- **T3 home:** development card, **kick counter surfaced (~28 wk)**, **contraction timer surfaced (later T3)**, birth-prep + hospital bag, warning-signs prominent, "signs of labour."
- **Multip / low-info preference:** denser week cards collapsed by default; quick-log foregrounded.

**Hidden-but-reachable rule.** Nothing is locked. Tools that are *contextually surfaced* by GA (kick counter, contraction timer) remain reachable earlier via the tools menu/search with an "usually used later in pregnancy" note. Every article/tool is always in the library and search regardless of persona.

**Continuity.** Cycle/TTC history (cycle length, LMP, logged symptoms, condition flags) seeds GA and personalization automatically — no re-onboarding; a one-time "your history is here and private" note.

---

## J. Adaptation triggers (state transitions)

**INTO D1 (from cycle/TTC):**
- **Positive-test log or "I'm pregnant" toggle** from B1 (cycle) or any C (TTC) persona → offer transition to pregnancy mode; carry EDD from LMP/TTC data; **privacy step:** confirm what shows to any shared partner and reassure no data sale/employer visibility (the pregnancy-mode privacy+continuity differentiator).

**Within pregnancy — escalation to complicated-pregnancy personas (emphasis shift, never restriction, never diagnosis):**
- User logs/records a **clinician diagnosis** or the app surfaces relevant education based on user-entered data:
  - Gestational diabetes / abnormal glucose screen recorded → blend **D3** content/tools.
  - Elevated BP readings or clinician-noted hypertension → **D5** (chronic HTN) / **D6** (pre-eclampsia/gestational HTN) awareness; foreground warning-signs; **do not diagnose** — frame as "your clinician is monitoring this; here's education + when to seek care."
  - Thyroid → **D7**; multiples confirmed → **D9**; high BMI → **D12**; AMA (age ≥ 35 recorded) → **D13** emphasis; prior C-section/VBAC interest → **D14**; severe persistent vomiting logged → **D15** (hyperemesis) awareness; prior preterm birth history → **D8**.
  - Repeated low-mood logs / positive EPDS screen → **D11** antenatal anxiety/depression emphasis (screening framing).
- All escalations are **additive emphasis** — D1 content stays fully available; the resolver blends.

**OUT of pregnancy:**
- **Delivery/birth logged** → transition to **Postpartum (E1)**; if she had a complicated course, carry forward to **E4** (e.g., GDM→T2DM screen reminder, HTN follow-up) and **E2** if breastfeeding.
- **Pregnancy loss / stillbirth logged** → immediate, dignified transition to **loss/grief (E6)**: stop all pregnancy/milestone reminders instantly (explicitly fixing the competitor failure where loss must be mis-logged as a "period"), offer grief resources, no re-prompting, gentle later path to **PAL (pregnancy after loss, D2)** if she conceives again.
- **Reset/withdraw:** she can exit pregnancy mode anytime; data retained per her privacy settings, nothing forced.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention claims, no medical-device functionality. Kick counter and contraction timer are **tracking aids**, explicitly *not* tests of fetal wellbeing or labour — copy must state this (avoids medical-device classification per femio-compliance-privacy skill).
- **No dosing / no prescribing:** supplement and symptom content gives general, cited info and defers all dosing/medication decisions to the clinician.
- **Screeners = "screening, discuss with clinician":** NIPT/first-tri, glucose, EPDS all framed as screening, never verdicts.
- **Red-flag routing:** danger-sign content uses "seek care now" framing and points to the user's provider / local emergency number; never reassures ("your baby is fine") and never alarms with a diagnosis.
- **Weight guidance** presented as IOM educational bands, non-judgmental, no scoring, no "you failed" states — sensitive-topic tone.
- **Privacy-by-design (GDPR/PDPL, health data):** minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility**; pregnancy status is sensitive data. Partner sharing is opt-in and granular. Loss/withdrawal must be handled with immediate reminder suppression and data-deletion honoring.
- **Content provenance:** every medical claim medically reviewed + cited to Tier-1/Tier-2; review dates surfaced; no clickbait, no sponsored content interleaved with medical guidance.
- **i18n/RTL:** all safety and red-flag copy must be human-reviewed in AR/EN/FR/ES (not machine-only) given clinical stakes.
- **Publication control:** ACOG/NAM weight-gain and WHO ANC sources are pinned above. Warning-sign routing never embeds a language-derived or global emergency number; it uses the maintained country selector and fallback in [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). Country-specific care schedules or destinations require separate local approval. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

- [ACOG — Tailored Prenatal Care Delivery for Pregnant Individuals (Clinical Consensus, 2025)](https://www.acog.org/clinical/clinical-guidance/clinical-consensus/articles/2025/04/tailored-prenatal-care-delivery-for-pregnant-individuals)
- [ACOG — New Guidance Recommends Transformation to U.S. Prenatal Care Delivery (2025)](https://www.acog.org/news/news-releases/2025/04/new-acog-guidance-recommends-transformation-to-us-prenatal-care-delivery)
- [ACOG — Weight Gain During Pregnancy (Committee Opinion)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2013/01/weight-gain-during-pregnancy)
- [CDC — Urgent Maternal Warning Signs & Symptoms (HEAR HER Campaign)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [CDC — Recognizing Urgent Pregnancy-Related Warning Signs (HEAR HER)](https://www.cdc.gov/hearher/news-media/article-urgent-warning-signs.html)
- [ACOG / Count the Kicks — Fetal Movement Counting FAQ](https://countthekicks.org/faq/)
- [Cleveland Clinic — Kick Counts (Fetal Movement Counting)](https://my.clevelandclinic.org/health/articles/23497-kick-counts)
- [American Pregnancy Association — Counting Baby Kicks](https://americanpregnancy.org/healthy-pregnancy/while-pregnant/counting-baby-kicks/)
- [NHS — Vitamins and Supplements in Pregnancy](https://www.nhs.uk/pregnancy/keeping-well/pregnancy-vitamins-and-supplements/)
- [NIH Office of Dietary Supplements — Dietary Supplements and Life Stages: Pregnancy](https://ods.od.nih.gov/factsheets/Pregnancy-HealthProfessional/)
- [RCOG — Healthy Eating and Vitamin Supplements in Pregnancy](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/healthy-eating-and-vitamin-supplements-in-pregnancy/)
- [NCBI — Schedule of Visits and Televisits for Routine Antenatal Care: A Systematic Review](https://www.ncbi.nlm.nih.gov/books/NBK582019/)
- [Consumer Reports — Best Pregnancy Tracking Apps (privacy analysis)](https://www.consumerreports.org/health/pregnancy-childbirth/best-pregnancy-tracking-apps-a8731130463/)
- [Comparison — Flo vs Ovia vs What to Expect (feature teardown)](https://www.go-go-gaia.com/blog/best-pregnancy-tracking-app.html)
- [Ovia Cycle & Pregnancy Tracker — App Store listing (features)](https://apps.apple.com/us/app/ovia-cycle-pregnancy-tracker/id570244389)
- [Flo (app) — Wikipedia (FTC settlement, Anonymous Mode, privacy history)](https://en.wikipedia.org/wiki/Flo_(app))

*Source resolution: [ACOG current NIPT guidance](https://www.acog.org/advocacy/policy-priorities/non-invasive-prenatal-testing/current-acog-guidance), [ACOG Weight Gain During Pregnancy](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2013/01/weight-gain-during-pregnancy), [WHO 2016 ANC guideline](https://www.who.int/publications/i/item/9789241549912), and the [National Academies 2009 report brief](https://nap.nationalacademies.org/resource/12584/Report-Brief---Weight-Gain-During-Pregnancy.pdf). Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
