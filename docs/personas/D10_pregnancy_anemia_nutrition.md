# Persona D10 — Pregnancy with Anemia / Nutritional Risk

Prepared: 2026-07-17 · Wave 3 · Status: research + spec
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 09_MASTER_ADAPTATION_MODEL · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills
Layers on: **D1 (uncomplicated pregnancy)** — D10 is *additive anemia / nutritional-risk emphasis on the D1 spine*, never a separate silo.
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening, discuss with clinician." Iron/folate/B12/vitamin-D and lab content is educational, never prescriptive — no dosing, no "your Hb is dangerous/fine," no supplement regimen. Hb/ferritin are entry-only, user-recorded values, never app-interpreted.**

---

## A. Persona snapshot

**Who she is.** A pregnant woman — often mid-pregnancy, but the risk spans all three trimesters — who has been told at a routine antenatal blood test (booking bloods, or the ~28-week screen) that she is **anemic**, or that her **iron / ferritin is low**, or who carries strong nutritional-risk factors (vegetarian/vegan diet, closely-spaced pregnancies, twins → D9 crossover, heavy pre-pregnancy periods, known thalassemia trait common in MENA/Mediterranean populations, low dietary diversity). Iron-deficiency anemia is the single most common medical issue in pregnancy — she is not a rare edge case, she is a large slice of the D1 base whose bloods flagged. She is frequently a **prior D1 user**, sometimes a prior C/TTC user. Unlike GDM (D3), the diagnosis usually lands with less shock and more confusion: "I feel exhausted and dizzy, they say I'm anemic, they gave me iron tablets that upset my stomach, and I don't really understand why it matters."

**Core job.** "They said I'm anemic / my iron is low in pregnancy. Help me understand what that actually means for me and my baby, why I feel so tired and dizzy, what iron-rich foods actually help (in food I really eat), how to take my iron without the stomach upset that made me stop, and keep my Hb and ferritin results in one place so I can see the trend — without pretending to be my doctor, scaring me, giving me a dose, or selling my pregnancy to advertisers."

**Emotional arc.**
- **Getting the result (entry point):** mild worry + a lot of confusion; relief that there's a name for the exhaustion; uncertainty about how serious it is ("is my baby getting enough?"). Less acute shock than GDM, more of a low-grade "should I be worried?"
- **Living with symptoms:** the defining daily experience — **fatigue, weakness, dizziness/lightheadedness, breathlessness on stairs, pica (craving ice/non-food), pale skin, headaches, restless legs, palpitations.** Many women normalize this as "just pregnancy tiredness" and don't connect it to anemia.
- **Supplement struggle (the biggest practical pain):** she's given oral iron and hits **constipation, nausea, stomach upset, metallic taste, black stools** — the top real-world reasons women quietly stop taking it. She needs validating, in-scope education on tolerability strategies (with food vs empty stomach, vitamin-C pairing, alternate-day dosing as *"something clinicians discuss"* — never a Femio instruction) and reassurance that black stool is expected.
- **Dietary overwhelm & culture:** "what do I actually eat?" — especially loaded for **vegetarian/vegan** users and **MENA** diets (lentils, beans, dark leafy greens, fortified staples, tea-with-meals reducing absorption — a strong culturally-specific teaching point).
- **Tracking the trend:** she gets re-tested and wants to see if her Hb/ferritin is climbing — the small win of a rising number, or the worry of a stubborn one that leads to talk of **IV iron** or, near term, transfusion planning.
- **Postpartum tail:** blood loss at birth can worsen anemia; postpartum fatigue, low milk-supply worry, and a follow-up Hb check seed the E1/E4 handoff.

**Context.** Web-first, mobile-heavy. Opens the app more than baseline D1 around result days and while adjusting supplements, but not the multiple-times-daily cadence of D3. Arabic-first / RTL primary with EN/AR/FR/ES; dietary guidance must be culturally literate (MENA staples, vegetarian Indian/South-Asian diets, fasting contexts). Dual lab units matter: **g/dL vs g/L** for hemoglobin, **ng/mL (µg/L) vs pmol/L** for ferritin/B12. Values calm, non-judgmental, jargon-free framing — she is tired and confused, not panicked, and the app must translate lab-speak into plain language without ever grading her.

**Success = she understands why anemia matters and that it's common and treatable, sticks with her supplement because she finally understands how to tolerate it, eats iron-smarter within her own food culture, and can see her Hb/ferritin trend in one private place to show her clinician** — while genuine red flags (severe breathlessness, chest pain, fainting, very low readings, reduced fetal movement) are surfaced loudly and routed to care, never diagnosed, never trivialized.

---

## B. Needs & questions (voice-of-user)

Mined from r/BabyBumps, r/pregnant, BabyCenter/What-to-Expect anemia threads, vegetarian-pregnancy communities, and the iron-deficiency-in-pregnancy literature. Representative real questions, grouped by job-to-be-done. Verbatim-style paraphrases.

**Confusion & reassurance (dominant emotional need at entry)**
- "They said I'm anemic — is my baby getting enough oxygen / iron?"
- "How serious is low iron in pregnancy, actually? Should I be scared?"
- "My hemoglobin is 10.2 — is that bad? What number do I want?"
- "Is being anemic my fault for not eating enough meat?" (self-blame, gentler than GDM but present)

**Understanding the labs**
- "What's the difference between hemoglobin and ferritin? My Hb is 'normal' but they still say my iron stores are low."
- "What does ferritin actually measure and why is mine 8?"
- "My numbers went down between appointments even though I'm taking iron — why?"
- "MCV, MCH, ferritin, transferrin saturation — can someone explain my blood test in plain words?"

**Symptoms**
- "Is this crushing fatigue normal pregnancy or is it the anemia?"
- "I get dizzy and see stars when I stand up — is that the low iron?"
- "I'm suddenly craving and chewing ice constantly — what is that?" (pica)
- "Short of breath just walking up stairs — anemia or something worse?"

**Iron supplements (the biggest practical pain)**
- "The iron tablets destroy my stomach / constipate me / make me nauseous — what do I do?" (top complaint, top reason for stopping)
- "Should I take iron with food or on an empty stomach? With orange juice? Away from my tea/coffee/calcium?"
- "My stools turned black — is that dangerous?" (very common, benign, needs reassurance)
- "I read every-other-day iron absorbs better — is that true?" (→ "something to discuss with your clinician," never a Femio instruction)
- "How long until I feel less tired after starting iron?"

**Diet (huge, and culturally loaded)**
- "What foods actually have iron and will really move my numbers?"
- "I'm vegetarian/vegan — can I fix this without eating meat?"
- "How do I get enough iron eating rice, lentils, bread, greens?" (MENA / South-Asian signal)
- "Does tea with meals really block iron? What about coffee?" (strong, under-taught)
- "Do I need folate and B12 too, or just iron?"

**Other deficiencies**
- "They mentioned my B12 / folate / vitamin D is low too — how do these connect to anemia?"
- "I'm vegan and worried about B12 — how do I know if I'm deficient?"

**Escalation / near-term worry**
- "My iron won't come up with tablets — they're talking about an iron infusion (IV). What is that?"
- "I'm close to my due date and still anemic — what happens at delivery?"
- "Will being anemic mean I bleed more / need a transfusion?"

**Postpartum**
- "I lost a lot of blood at birth and feel wiped out — is my anemia worse now?"
- "Does anemia affect my milk supply / breastfeeding?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Pregnancy apps (What to Expect, Ovia, Pregnancy+, Flo) treat anemia as a single generic article — **no lab tracker, no Hb/ferritin trend, no culturally-real iron-food guidance, no supplement-tolerability help.**
- General nutrition/iron apps know nothing about pregnancy targets, trimester Hb thresholds, or fetal context.
- Nobody helps with the #1 real failure — **supplement intolerance making women silently quit** — in a compliant, non-prescriptive way.
- Generic food lists are Western/meat-centric and useless for vegetarian and MENA diets.
- Privacy dread — "I don't want my health data / pregnancy sold or visible to my employer."

---

## C. Competitor teardown

Two worlds fail D10 in opposite ways: **pregnancy trackers** (nice baby content, anemia is a footnote article, no lab tracking, no real food guidance) and **general iron/nutrition apps** (some food data, zero pregnancy context, no trimester Hb thresholds, no fetal framing). **The integration — compliant lab-trend tracking + culturally-real nutrition education inside week-by-week pregnancy content — is the whitespace.**

| Capability | What to Expect | Ovia Pregnancy | Pregnancy+ | Flo (preg mode) | BabyCenter | General nutrition apps (MyFitnessPal etc.) |
|---|---|---|---|---|---|---|
| Week-by-week fetal/pregnancy content | Strong | Strong + insights | Best-in-class visuals | Good | Strong | **None** |
| Anemia / iron-deficiency education | Article-level only | Article-level | Article-level | Article-level | Article-level | Generic, non-pregnancy |
| Hb / ferritin lab log & trend | **No** | **No** | **No** | **No** | **No** | **No** |
| Iron-rich food guidance | Generic list | Generic list | Minimal | Minimal | Generic list | Nutrient totals, not iron-strategy |
| Absorption teaching (vit-C pairing, tea/calcium timing) | Rare | Rare | No | No | Rare | No |
| Vegetarian / MENA cultural food adaptation | **No** | **No** | No | No | Limited | Limited |
| Supplement-tolerability help (in-scope) | No | No | No | No | No | No |
| Folate / B12 / vitamin-D context | Prenatal-vitamin blurb | Blurb | Blurb | Blurb | Blurb | Partial |
| Clinician-shareable lab report (PDF) | No | Limited | No | No | No | No |
| Languages / RTL | EN-centric | EN-centric | Multi | Multi | Multi (no true Arabic-first) | Multi (no true Arabic-first) |
| Privacy posture | Reported data sale | Labcorp-owned; employer-visibility concern | Reported ad-SDK sharing | 2021 FTC settlement | Reported data sale | Ad/data-monetized |

**Whitespace Femio owns (D10):** *the only calm, privacy-first, Arabic-first app that layers a compliant Hb/ferritin lab-trend log + culturally-real iron/folate/B12/vitamin-D nutrition education + supplement-tolerability help onto real week-by-week pregnancy content in one account* — without dosing, without "your number is good/bad," without ads, and without selling her data.

**Compliance contrast to note:** where a general iron app might tell a user "take X mg" or "your ferritin means you need iron," Femio logs Hb/ferritin as **user-recorded tracking data with educational context only** — no dose, no titration, no "your reading is safe/dangerous," no diagnosis from a number.

---

## D. Clinical grounding (cited)

All content below is **education, not medical advice**. Femio may store a user-entered result with its original unit and laboratory reference range, but it does not generate a trimester reference band, classify anemia or iron deficiency, interpret trends, or recommend a supplement regimen. Every result and treatment decision is deferred to the care team.

**How common it is.** WHO’s February 2025 fact sheet estimates that 37% of pregnant women worldwide are affected by anemia. Causes are varied and can include iron or other nutritional deficiency, infection, inflammation, inherited red-cell disorders, and pregnancy-related factors. Femio does not infer the cause from diet, location, symptoms, or one laboratory value. [WHO, *Anaemia*, 10 February 2025]

**Hemoglobin and ferritin results.** WHO issued an updated guideline on hemoglobin cutoffs in March 2024 and notes that interpretation is affected by population and measurement factors. Clinical bodies and laboratories may use different pregnancy and postpartum thresholds. Femio therefore stores the original value, unit, laboratory range, date, and clinician note only; it never renders “anemic,” “iron deficient,” “safe,” or “dangerous.” [WHO, *Guideline on haemoglobin cutoffs to define anaemia in individuals and populations*, 5 March 2024]

**Ferritin education.** Ferritin is used as part of assessing iron stores and is interpreted with clinical context and other results. Femio explains the term but does not publish one global cutoff or interpret a user’s value.

**Screening / when bloods are checked.** Routine anemia screening is typically at the **booking (first) appointment** and again around **28 weeks** (earlier/repeat if risk factors or symptoms). All screening content = *"this is a screening blood test — discuss your results with your clinician."* [NICE NG201; BSH 2019; ACOG]

**Iron supplementation context (educational only — no dosing).**
- Supplement type, dose, schedule, interactions, and whether oral or intravenous iron is appropriate are clinician decisions. Femio records only what the user says was prescribed and never converts guideline doses into instructions.
- **Tolerability (in scope):** oral iron can cause gastrointestinal effects and dark stools. Femio may help a user record effects and prepare questions for a pharmacist or clinician, but it does not advise changing timing, frequency, formulation, or dose.
- **IV iron / transfusion** (education, for the escalation path): when oral iron isn't tolerated or isn't enough, or anemia is significant approaching delivery, clinicians may discuss **intravenous iron**; severe anemia near term prompts an individualized birth plan (group-and-save, transfusion readiness). Explained as *what her clinician may consider*, never advised by the app. [BSH 2019; ASH 2023]

**Dietary iron (education, culturally adaptable).**
- Pregnancy iron requirement rises to about **27 mg/day** (RDA), roughly double non-pregnant needs. [NIH ODS]
- **Heme iron** (meat, poultry, fish) is absorbed far more efficiently (~15–35%) than **non-heme iron** (plants, fortified foods, ~2–20%). Vegetarians/vegans are advised iron intakes ~**1.8× higher** because of lower non-heme absorption. [NIH ODS; NHS]
- **Absorption levers to teach:** pairing non-heme iron with **vitamin C** (citrus, tomato, peppers) markedly boosts absorption; **tea/coffee (tannins), calcium/dairy, and phytates** reduce it — a high-value, under-taught, culturally-relevant point (tea-with-meals is common in MENA/South-Asian diets). [NIH ODS; NHS]
- **Food sources:** red meat, poultry, fish; and plant sources — lentils, chickpeas, beans, tofu, dark leafy greens (spinach, kale), fortified cereals/bread, dried fruit (apricots, dates), pumpkin/sesame seeds — all mappable to MENA and vegetarian staples. [NHS; NIH ODS; American Pregnancy Association]

**Folate & B12 (the other nutritional anemias).** Folate (B9) and vitamin B12 deficiency cause **megaloblastic anemia**. Folate needs rise in pregnancy (folic-acid supplementation is standard for neural-tube-defect risk, distinct from anemia but overlapping). **B12** is found mainly in animal foods, so **vegans/vegetarians are at elevated risk** and are advised fortified foods or supplements under clinician guidance. Femio explains the connection and defers dosing. [NHS; NIH ODS; ASH 2017]

**Vitamin D.** Vitamin D is not a classic cause of anemia. Supplement recommendations vary by jurisdiction and individual risk; Femio follows the user’s clinician or current local public-health guidance and gives no dose.

**Why it matters (honest, not fear-mongering).** Untreated moderate-to-severe anemia is associated with higher risks of **preterm birth, low birth weight, and increased maternal fatigue / reduced tolerance of blood loss at delivery (→ postpartum anemia and, rarely, transfusion)**. Crucially, iron deficiency is **very treatable**, and correcting it improves maternal wellbeing — always pair the "why it matters" with the true, reassuring "and it's common and fixable." [WHO; ASH 2017; FIGO 2023]

**Postpartum tail.** Blood loss at birth can worsen or reveal anemia. Femio supports follow-up and result organization but does not publish one global postpartum threshold or advise how long supplementation continues.

Medical-review resolution: current WHO hemoglobin guidance and NICE antenatal blood-test timing are pinned below. Global app-generated reference bands, ferritin/B12 cutoffs, MENA prevalence claims, and alternate-day dosing instructions were removed. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

D10 = the **D1 spine (week content, appointments, warning-signs, weight)** + an **anemia / nutrition tool + education layer**. Nothing from D1 is removed.

**P0 — must-have (the anemia/nutrition layer)**
1. **Lab log — Hb & ferritin (entry-only)** — manual entry of the value, original unit, date, laboratory reference range, and optional clinician note. No app-generated band or classification. *Tracking aid, not a test interpreter.*
2. **Hb/ferritin trend view** — a descriptive line of entered values by date, with no trimester band and no “improving/failing” language.
3. **Iron & nutrition education hub** — referenced, calm, anti-self-blame; iron-rich foods, absorption levers, folate/B12/vitamin-D context, culturally-adapted (see F).
4. **Supplement-tolerability education (in-scope)** — the high-value differentiator: how iron is commonly taken, tolerability strategies framed as *"things to ask your clinician,"* black-stool reassurance. **No dose, no regimen.**
5. **Appointment / lab-recheck tracker** — booking bloods, 28-week recheck, follow-up Hb, dietitian/hematology referral if mentioned; reminders; "questions to ask."
6. **Clinician-shareable export (PDF/CSV)** of lab values + supplement/symptom notes.
7. **Red-flag safety layer (inherited + anemia-tuned)** — persistent warning-signs access; contextual red-flag boxes (severe breathlessness / chest pain / fainting / palpitations, very low readings, reduced fetal movement → "seek care now").

**P1 — high value**
8. **Supplement log (educational)** — record that she took her iron / folate / B12 / vitamin D *as advised by her clinician* (name, time, user-entered) for adherence pattern-tracking + export. **No dose suggestions, no calculators.** Optional tolerability note ("nausea today") so she can see patterns.
9. **Iron-symptom log** — lightweight tags (fatigue, dizziness, breathlessness, pica, headache, restless legs) continuous with cycle-era symptom logging, so she can correlate symptoms with her trend and supplement adherence — descriptive, never diagnostic.
10. **Culturally-adapted iron-food library** — MENA staples, vegetarian/vegan, South-Asian; vitamin-C pairing and tea/coffee-timing tips. Dietitian-reviewed.
11. **Kick counter / contraction timer (from D1, T3)** — unchanged.

**P2 — differentiators / later**
12. Vegetarian/vegan pregnancy-nutrition deep module (iron + B12 + protein), dietitian-reviewed.
13. Postpartum bridge card → **E1/E4** repeat-Hb + continued-iron reminder + fatigue/breastfeeding context.
14. Gentle, moderated peer support / curated Q&A (privacy-safe, only if moderation is guaranteed).
15. Optional lab-portal import (read-only display of user's own values; no interpretation) — later, pending compliance review.

**Explicitly out of scope (compliance):** any **iron/supplement dose calculator or titration**; any "your Hb/ferritin is low/normal/dangerous — do X" instruction; any algorithm that *diagnoses* anemia or iron deficiency from user-entered labs; any prediction of preterm birth/transfusion. Hb, ferritin, and supplements are **user-recorded tracking data with educational context only.**

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL, dual-unit). Delivered as an additive anemia/nutrition hub on the D1 library; always searchable.

- **"You've been told you're anemic / low iron" primer** — what anemia and iron deficiency in pregnancy are, that they're **very common and treatable and not her fault** (doubled iron needs, expanded blood volume), what changes now. Anti-self-blame, anti-catastrophizing.
- **Understanding your blood results** — hemoglobin vs ferritin in plain words (Hb = oxygen-carrying; ferritin = iron-store fuel-gauge); why Hb can be "normal" while ferritin is low; what the trimester reference bands mean; dual-unit; *"your clinician interprets your numbers."*
- **Why anemia matters for you and your baby** — honest, gentle: fatigue and reduced tolerance of blood loss at birth; associations with preterm birth / low birth weight in moderate-severe cases; **always paired with "it's common and correcting it helps."**
- **Anemia symptoms explainer** — fatigue, dizziness, breathlessness, pallor, palpitations, headaches, restless legs, **pica (ice/non-food cravings)** — each with a "when this could be a red flag → seek care" callout.
- **Iron-rich eating (culturally real)** — heme vs non-heme; food sources mapped to **MENA / vegetarian / South-Asian** staples (lentils, beans, chickpeas, greens, fortified bread/cereal, dates, seeds, red meat/fish where eaten); realistic example plates.
- **Getting the most from your iron (absorption)** — the vitamin-C pairing win; **tea/coffee/calcium/dairy timing** (a high-value, under-taught, culturally-relevant point); phytates.
- **Iron supplements, explained (educational)** — what oral iron is, common tolerability issues (constipation/nausea/metallic taste), **black stool is expected and harmless**, strategies to ask your clinician about (with food, vitamin C, spacing from tea/calcium, alternate-day dosing) — **no doses.**
- **Folate & B12 and anemia** — the megaloblastic-anemia connection; why **vegans/vegetarians** need to watch B12; folate in pregnancy; deferring dosing.
- **Vitamin D & the wider nutritional picture** — brief, MENA-relevant.
- **When iron tablets aren't enough** — plain-language, non-alarming explainer of **IV iron infusion** and, near term, individualized birth planning / transfusion readiness — *what your clinician may consider*, never advised.
- **Warning-signs hub (inherited)** — CDC Hear Her list always reachable; severe breathlessness / chest pain / fainting / very-low-reading and reduced-fetal-movement framed as report-now signs, never diagnosis.
- **After birth: anemia and recovery** — blood loss can worsen anemia; postpartum fatigue and breastfeeding context; the follow-up Hb check; continued iron as clinician advises (bridges to E1/E4).
- **Emotional wellbeing** — normalizing the exhaustion and "am I doing enough" worry; soft pointer to mood screening ("screening, discuss with clinician").

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs & tools**
- **Lab log (Hb / ferritin, entry-only)** — value + unit + date + optional note; optional extra fields (MCV, MCH, B12, folate, vitamin D, transferrin saturation). Displays *her* values vs an **educational trimester reference band**. Copy: *"This is a tracking aid, not a medical test or diagnosis. The bands shown are general education by trimester — your clinician interprets your results. Femio can't tell you a value is 'normal', 'low', or 'dangerous', and can't tell you if you're anemic."* No pass/fail, no color-graded "fail" state beyond a neutral "below/within the reference band shown" marker for *her own* reference.
- **Hb/ferritin trend view** — her entered values over time, trimester-banded. Framed as *"a picture to share with your care team,"* never a grade or a prediction.
- **Supplement log (educational)** — user records iron/folate/B12/vitamin-D *as advised*; adherence + tolerability pattern-tracking and export only. Copy: *"Record only. Femio never recommends or adjusts doses or supplements — follow your clinician."*
- **Iron-symptom log** — fatigue/dizziness/breathlessness/pica/etc. tags; descriptive correlation with her trend, never diagnostic.
- **Appointment / lab-recheck log** — booking bloods, 28-week recheck, follow-ups, dietitian/hematology referrals, provider, notes, results (user-entered), reminders.
- **Export (PDF/CSV)** — lab values + supplement adherence + symptoms + notes for appointments.
- **Kick counter / contraction timer (T3, inherited from D1)** — unchanged, same compliant framing.

**Alerts (all opt-in, calm, non-alarmist)**
- Supplement reminders at her chosen times (editable) — a simple "take your iron" nudge, no dose shown.
- Lab-recheck / appointment reminders (e.g., a gentle "your 28-week bloods are coming up" if she's set it).
- Gestational-milestone + content nudges (inherited).
- Postpartum: a single gentle **"your clinician may recheck your blood count"** reminder after delivery (→ E1/E4).
- **No** predictive/diagnostic alerts. **No** "your iron is dangerously low" auto-verdicts. **No** dose prompts.

**Red-flag box pattern (reusable component, anemia-tuned).**
> **⚠ Seek care now**
> Contact your maternity provider or local emergency number right away if you have: severe or worsening breathlessness, especially at rest · chest pain or a racing/pounding heartbeat · fainting or feeling you might pass out · a blood-test result far lower than your clinician told you to expect · a severe headache that won't go away or vision changes · heavy vaginal bleeding or fluid leaking · (after ~28 wk) your baby moving noticeably less than usual · thoughts of harming yourself.
> *You know your body best — if something feels wrong, get it checked. This app can't diagnose or treat, and it can't tell you whether a blood result is safe or dangerous.*
> [Save my maternity/emergency contact] [Learn the warning signs]

Placement: persistent nav entry + auto-injected on the lab-log screen (near "very low reading" guidance), the anemia-symptoms explainer, and any symptom content with an associated danger sign (breathlessness, palpitations, fainting, bleeding, reduced movement).

---

## H. EMR fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1)**
- Identity/account, locale/language, **units (Hb g/dL vs g/L; ferritin ng/mL; B12 pg/mL vs pmol/L)**.
- DOB / age; height; pre-pregnancy weight & BMI.
- Menstrual history; LMP; **heavy-menstrual-bleeding history** (an anemia risk factor).
- Medical-history flags (**anemia history, thalassemia/hemoglobinopathy trait, prior IDA, GI conditions affecting absorption, bariatric surgery**, thyroid, etc.).
- **Dietary pattern flag** (omnivore / vegetarian / vegan / other) — a nutritional-risk signal.
- Medications, allergies, **supplements (iron/folate/B12/vitamin D)**.
- Prior pregnancies/outcomes (gravida/para); **closely-spaced-pregnancy flag; prior postpartum hemorrhage** (anemia risk factors).
- Consent/privacy settings; emergency/care-team contact (optional).

**Persona-specific (anemia / nutritional risk — layered over the constant core EMR, on top of D1's pregnancy fields)**
- **Anemia / iron-deficiency status & date** — user-recorded (the D1→D10 transition marker), with type as user note (IDA / folate / B12 / mixed / trait-related) — *not app-interpreted*.
- **Anemia / nutritional risk factors** carried from core (vegetarian/vegan diet, thalassemia trait, HMB history, closely-spaced pregnancy, prior IDA/PPH, twins→D9, low dietary diversity) — used to *surface* education, never to diagnose or predict.
- **Hemoglobin series (entry-only)** — value, unit, date, optional note. User-entered.
- **Ferritin series (entry-only)** — value (ng/mL), date, optional note. User-entered.
- **Optional additional lab fields (entry-only)** — MCV, MCH, MCHC, transferrin saturation, serum iron, **B12, folate (RBC/serum), vitamin D** — value + unit + date, all user-entered, none interpreted.
- **Trimester reference band** — educational display band by trimester (view-only context, not a rule or a score).
- **Supplement log** — iron/folate/B12/vitamin-D name + time, *user-recorded as advised*; optional tolerability note; no dose logic.
- **Iron-symptom series** — fatigue/dizziness/breathlessness/pica/palpitations/restless-legs tags, timestamped.
- **Treatment context** (diet-only / oral iron / IV iron discussed / other) — user-recorded; drives *content emphasis* (e.g., IV-iron explainer if recorded), never a clinical action.
- **Lab-recheck / referral log** — booking + 28-wk bloods, follow-ups, dietitian/hematology, results (user-entered).
- **Postpartum Hb-recheck status** — due/booked/done + result-as-user-note (→ E1/E4).
- Inherited D1 fields (EDD/GA, BP-if-logged, kick/contraction sessions, weight series, etc.) all retained.

---

## I. Personalization rules (layered on the D1 pregnancy base; hidden-but-reachable)

**D10 does not re-onboard.** It activates *on top of* an existing D1 pregnancy context when anemia / low iron / nutritional risk is recorded — additive emphasis, nothing hidden or removed.

**Activation (wizard delta, short & editable/resettable — personalize, never restrict).**
1. Trigger: user records an **anemia / low-iron / low-ferritin result** (or "my pregnancy blood test showed anemia / low iron") — often from a D1 home prompt after booking bloods or the ~28-wk screen, or offered proactively if **risk factors** (vegetarian/vegan diet, thalassemia trait, HMB history, closely-spaced pregnancy, prior IDA) are in her record.
2. Quick set-up: preferred **lab units** (Hb g/dL / g/L; ferritin ng/mL); **dietary pattern** (omnivore / vegetarian / vegan) to tailor food content; **supplement context** (none / oral iron / other, editable) and optional **reminder times**; who (if anyone) she shares with (X2 partner).
3. Optional: enter her latest **Hb / ferritin** to seed the trend (else the log starts empty; reference band shown as context only).

**Home configuration (GA-driven, inherited from D1, with anemia/nutrition layer on top).**
- **Result moment / early D10:** the "You've been told you're anemic" primer and "Understanding your blood results" are foregrounded; the lab log surfaced as a new quick-action; iron-eating and supplement-tolerability content prominent; reassuring, anti-self-blame tone dialed up.
- **Vegetarian/vegan flag set:** vegetarian iron + B12 content foregrounded; food examples default to plant-based.
- **Steady state:** lab-trend + supplement log + iron-food content foregrounded; the D1 week-by-week card stays present (she is still pregnant and wants baby content).
- **Oral iron recorded:** supplement-tolerability module + supplement log surfaced.
- **IV iron / near-term anemia recorded:** the "when tablets aren't enough" IV-iron/birth-plan explainer surfaced (calm, educational).
- **T3 (inherited):** kick counter + contraction timer + birth-prep surface as in D1, plus anemia-and-delivery content (blood-loss tolerance, postpartum recovery).
- **Post-delivery:** anemia tools quiet down; the postpartum Hb-recheck / continued-iron bridge card appears (→ E1/E4).

**Hidden-but-reachable rule.** Nothing is locked. The full D1 pregnancy experience remains completely intact and foregrounded; anemia/nutrition tools are *added*, and every article/tool stays in the library and search regardless of persona. She can collapse or de-emphasize the anemia layer without losing it.

**Continuity.** Her D1 pregnancy record (EDD/GA, appointments, weight, symptoms) and core history (dietary pattern, HMB history, prior IDA, trait flags) seed D10 automatically — no separate app, no re-entry; a one-time *"your pregnancy history is here, this just adds your anemia and nutrition tools, and it's all private"* note.

---

## J. Adaptation triggers (state transitions)

**Inherited universal events (from 09_MASTER_ADAPTATION_MODEL §6 — not re-specified here):** positive pregnancy test, pregnancy loss/stillbirth (→ instant reminder suppression, Gentle Mode, E6), mood-screen-high / crisis flag, red-flag symptom / severe reading, disengagement/"taking a break," toggle-mode-off, age-of-consent milestone. D10 only specifies its **persona-specific** transitions below.

**INTO D10 (from D1 — on record):**
- **Anemia / low-iron / low-ferritin result recorded** by the user (typically after booking bloods or the 28-wk screen) → offer to add the anemia/nutrition layer to her existing pregnancy mode; carry all D1 context; **privacy step:** reassure that her anemia + pregnancy status is never sold, never employer/insurer-visible, and confirm partner-sharing scope. Additive emphasis — **do not diagnose**; frame as *"you've told us your clinician found anemia / low iron — here's education, lab tracking and when to seek care."*
- **Risk-factor pre-surfacing:** if vegetarian/vegan diet, thalassemia trait, HMB history, closely-spaced pregnancy, or prior IDA are in her record, D1 may *offer* iron/nutrition education proactively (never a prediction, never a diagnosis).

**Within pregnancy (additive blends, never restriction, never diagnosis):**
- **Multiples confirmed (D9) blend** — twin/triplet pregnancy sharply raises iron/nutritional demand and anemia risk; D10 ⊕ D9 blends: multiples hero/timeline + anemia lab-trend + nutrition emphasis, merged warning-signs, without conflating the two. (Per §8 modifier-blending: composable layers, union of safety layers, most-acute emphasis wins the hero.)
- **GDM recorded (D3) co-occurrence** — a woman can have both; carb-aware iron-food guidance must reconcile (e.g., iron-rich *and* lower-glycemic choices); layers stack, neither is hidden.
- **Elevated BP / pre-eclampsia signs (D5/D6)** — surface warning-signs; anemia can amplify fatigue/breathlessness that also feature in pre-eclampsia, so the red-flag routing stays prominent. Education + "seek care," never a verdict.
- **IV iron / significant anemia near term recorded** → "when tablets aren't enough" + individualized-birth-plan content emphasis (still D10, no dosing).
- **Repeated low-mood logs / positive mood screen** → **D11** antenatal anxiety/depression emphasis (screening framing) — anemia fatigue overlaps with low mood; watch gently.
- All D1 content stays fully available; the resolver blends emphasis.

**OUT of pregnancy:**
- **Delivery/birth logged** → transition to **Postpartum (E1)**, and because she had antenatal anemia (and blood loss at birth can worsen it), **carry forward the anemia follow-up to E4**: a gentle single reminder that her clinician may **recheck her blood count**, continued-iron-as-advised education, and **postpartum-fatigue + breastfeeding** context; **E2** if breastfeeding. Anemia lab tools quiet down but remain reachable (postpartum Hb entry).
- **Postpartum hemorrhage recorded** → carry heightened postpartum-anemia awareness into E4 (fatigue, recovery, recheck), never diagnosis.
- **Pregnancy loss / stillbirth logged** → universal handler: immediate, dignified transition to **loss/grief (E6)** — stop all pregnancy *and anemia* reminders instantly (supplement nudges, lab-recheck prompts), offer grief resources, no re-prompting; ongoing nutritional care (e.g., continued iron for her own recovery) retained if she wants it.
- **Reset/withdraw:** she can drop the anemia layer or exit pregnancy mode anytime; data retained per her privacy settings, nothing forced.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention claims, no medical-device functionality. The lab log, supplement log and symptom log are **tracking aids for user-entered data**, explicitly *not* tests, not diagnostic tools, and not able to judge a value "normal/low/dangerous" or tell her she is anemic — copy must state this (avoids medical-device classification per femio-compliance-privacy skill).
- **Hb/ferritin are entry-only, never interpreted:** the app stores and trends user-entered values against an *educational* trimester reference band, labeled clinician-interpreted, dual-unit; it never renders an anemia/iron-deficiency diagnosis from a number, and never a pass/fail score.
- **No dosing / no titration / no calculators:** categorically **no iron/supplement dose calculator, no "take X mg," no titration.** Supplement content is general, cited, and defers every decision to the clinician; tolerability strategies are framed as *"things to ask your clinician about,"* never Femio instructions.
- **Guideline-honest:** where guidelines genuinely disagree (e.g., ACOG universal-supplementation vs USPSTF 2024 insufficient-evidence; CDC/ACOG trimester thresholds vs WHO single threshold vs UK BSH), present the disagreement plainly rather than pick a side.
- **Screeners = "screening, discuss with clinician":** booking/28-wk anemia bloods and any mood screen framed as screening, never verdicts.
- **Red-flag routing:** severe breathlessness, chest pain, palpitations, fainting, very-low readings, reduced fetal movement use "seek care now" framing pointing to her provider / local emergency number; never reassures ("your iron is fine / baby is fine"), never alarms with a diagnosis.
- **Anti-self-blame, non-judgmental tone (sensitive topic):** pregnancy anemia carries mild guilt ("I didn't eat well enough"); all copy is non-shaming, framing iron depletion as physiological and common; no graded gamification of labs or food; food logging never enforces a budget.
- **Privacy-by-design (GDPR/PDPL, health data):** anemia status + lab values are sensitive health data layered on sensitive pregnancy data — minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility**. Partner sharing opt-in and granular. Loss/withdrawal → immediate suppression of all pregnancy + anemia reminders and honored deletion.
- **Content provenance:** every medical claim medically reviewed + cited to Tier-1 (CDC/NIH/MedlinePlus/NHS/WHO) / Tier-2 (ACOG/RCOG/NICE/BSH); review dates surfaced; no clickbait, no sponsored content interleaved with medical guidance.
- **i18n/RTL + cultural food literacy:** all safety/red-flag copy human-reviewed in AR/EN/FR/ES (not machine-only) given clinical stakes; iron-food examples culturally adapted (MENA staples, vegetarian/vegan, South-Asian; tea-with-meals absorption note); dual lab units per locale.
- **Reviewed source set:** WHO’s 2024 hemoglobin-cutoff guideline and 2025 anemia fact sheet govern global context; NICE NG201 supports full blood count at booking and 28 weeks. Femio does not generate diagnostic bands, doses, or region-specific clinical pathways. Urgent symptoms use the global urgent-routing policy. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## Sources

- [WHO — Anaemia (fact sheet / prevalence)](https://www.who.int/news-room/fact-sheets/detail/anaemia)
- [CDC — Anemia during pregnancy / maternal nutrition](https://www.cdc.gov/nutrition/php/data-research/anemia.html)
- [ACOG — Anemia in Pregnancy (Practice Bulletin 233, 2021)](https://www.acog.org/clinical/clinical-guidance/practice-bulletin/articles/2021/08/anemia-in-pregnancy)
- [USPSTF — Iron Deficiency Anemia in Pregnancy: Screening and Supplementation (Final Recommendation, 2024)](https://www.uspreventiveservicestaskforce.org/uspstf/document/RecommendationStatementFinal/iron-deficiency-anemia-in-pregnant-women-screening-and-supplementation)
- [BSH / Pavord et al. — UK guidelines on the management of iron deficiency in pregnancy (BJH, 2019)](https://b-s-h.org.uk/media/2891/uk_guidelines_iron_deficiency_in_pregnancy.pdf)
- [ASH Education Program — Identifying and treating iron deficiency anemia in pregnancy (2023)](https://ashpublications.org/hematology/article/2023/1/223/506437/Identifying-and-treating-iron-deficiency-anemia-in)
- [Blood (ASH) — How I treat anemia in pregnancy: iron, cobalamin, and folate (2017)](https://ashpublications.org/blood/article/129/8/940/36329/How-I-treat-anemia-in-pregnancy-iron-cobalamin-and)
- [FIGO — Good practice recommendations on anemia in pregnancy (IJGO, 2025)](https://obgyn.onlinelibrary.wiley.com/doi/10.1002/ijgo.70529)
- [The ObG Project — Clinical Update: Anemia in Pregnancy](https://www.obgproject.com/2021/10/01/anemia-in-pregnancy-interim-update/)
- [PMC — Identifying and treating iron deficiency anemia in pregnancy (review)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10727057/)
- [PMC — Iron deficiency and iron deficiency anemia in pregnancy](https://pmc.ncbi.nlm.nih.gov/articles/PMC8321297/)
- [PMC — Early evaluation of iron and vitamin B12 deficiency in pregnancy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11416752/)
- [NIH Office of Dietary Supplements — Iron (Health Professional Fact Sheet: RDA, heme/non-heme, vegetarian 1.8×)](https://ods.od.nih.gov/factsheets/Iron-HealthProfessional/)
- [NIH Office of Dietary Supplements — Dietary Supplements During Pregnancy](https://ods.od.nih.gov/factsheets/Pregnancy-HealthProfessional/)
- [NHS — Vitamins, supplements and nutrition in pregnancy (iron, folic acid, vitamin D)](https://www.nhs.uk/pregnancy/keeping-well/vitamins-supplements-and-nutrition/)
- [NHS — Iron deficiency anaemia](https://www.nhs.uk/conditions/iron-deficiency-anaemia/)
- [American Pregnancy Association — Iron-Rich Foods for Pregnancy](https://americanpregnancy.org/pregnancy/iron-rich-foods-for-your-pregnancy/)
- [UCSF Health — Anemia and Pregnancy (patient education)](https://www.ucsfhealth.org/health-articles/anemia-and-pregnancy)
- [PMC — Postpartum anemia prevalence and risk factors (thresholds)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11055361/)
- [PMC — Compliance with oral iron supplementation in antenatal women (side effects, adherence)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10290743/)

*Clinical source pinning: [WHO hemoglobin-cutoff guideline (5 March 2024)](https://www.who.int/publications/i/item/9789240088542); [WHO Anaemia fact sheet (10 February 2025)](https://www.who.int/news-room/fact-sheets/detail/ANAEMIA); [NICE NG201 antenatal-care recommendations](https://www.nice.org.uk/guidance/ng201/chapter/Recommendations). Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.*
