# Persona D3 — Pregnancy with Gestational Diabetes (GDM)

Prepared: 2026-07-17 · Wave 1 (spine) · Status: research + spec
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills
Layers on: **D1 (uncomplicated pregnancy)** — D3 is *additive GDM emphasis on the D1 spine*, never a separate silo.
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening, discuss with clinician." Glucose and medication content is educational, never prescriptive — no dosing, no "your reading is bad/good," no insulin titration.**

---

## A. Persona snapshot

**Who she is.** A pregnant woman, usually in her late second / early third trimester, who has just been told after the routine **24–28 week glucose screen** (or an early screen if she carried risk factors) that she has **gestational diabetes**. She was tracking an otherwise ordinary pregnancy (she is often a **prior D1 user**, sometimes a prior C/TTC user before that) and this diagnosis lands as an unexpected, frightening plot-twist. She now has to prick her finger multiple times a day, rethink every meal, attend extra appointments, possibly start metformin or insulin, and she is scared for her baby and her delivery. She may have GDM risk factors carried in her record (prior GDM, high BMI, PCOS → B6 crossover, family history of T2DM, prior large baby, older age).

**Core job.** "I just got diagnosed with gestational diabetes and I'm terrified. Help me understand what this actually means for my baby, keep my blood-sugar readings and meals in one place so I can see if I'm on track, remind me about all these new appointments, tell me clearly when to call my doctor — and reassure me that women get through this — without pretending to be my doctor, scaring me, or selling my pregnancy to advertisers."

**Emotional arc (post-diagnosis is the defining moment).**
- **Diagnosis shock (the entry point):** shock, fear for the baby, self-blame/guilt ("did I cause this?"), feeling overwhelmed by the sudden regimen, grief for the "normal" pregnancy she thought she had. Research documents shock, anxiety, fear for the baby's health and self-blame as the dominant first reactions.
- **Regimen ramp-up (first ~1–2 weeks):** learning to use a glucometer, decoding fasting vs post-meal targets, panic over "high" numbers, the mental load of logging 4+ times a day, dietary overwhelm and cultural-food conflict (a huge issue for Arabic/MENA users — rice, bread, dates, Ramadan).
- **Living with it (steady state):** food becomes fraught — many women describe an almost obsessive/anxious relationship with eating; fatigue of finger-pricks; small wins when numbers are in range; anxiety spikes if diet alone isn't enough and **insulin/metformin** is added (evidence: women requiring insulin show measurably higher anxiety).
- **Delivery run-up (T3):** worry about macrosomia ("will my baby be too big?"), induction/early delivery talk, C-section fear, growth scans, "will the baby's sugar crash after birth?"
- **Postpartum tail:** relief + a new worry — the **postpartum OGTT at 4–12 weeks** and lifelong T2DM risk (see J → E4).

**Context.** Web-first, mobile-heavy, opens the app **multiple times per day** (far more than baseline D1 — every glucose entry is a touchpoint). Arabic-first / RTL primary with EN/AR/FR/ES; carb/meal guidance must be culturally literate. Values calm, honest, non-judgmental framing above all — she is already anxious and blames herself; the app must never add shame.

**Success = she feels informed, less alone, and organized** — her readings, meals, meds and appointments live in one private place she can show her clinician; she understands GDM is common and manageable; genuine red flags (very high sugars, pre-eclampsia signs, reduced fetal movement) are surfaced loudly and routed to care — never diagnosed, never trivialized.

---

## B. Needs & questions (voice-of-user)

Mined from r/GestationalDiabetes, GDM support communities, diabetes-app reviews, and the qualitative GDM literature. Representative real questions, grouped by job-to-be-done. Verbatim-style paraphrases.

**Shock, guilt & reassurance (dominant emotional need at entry)**
- "Just got diagnosed and I burst into tears — did I do this to my baby by eating badly?"
- "Is my baby going to be okay? I keep reading scary things."
- "Does everyone with GD end up on insulin / with a C-section / an induction?"
- "I feel like a failure every time a number is high." (self-blame is pervasive)

**Understanding the diagnosis**
- "What do fasting vs 1-hour vs 2-hour numbers even mean?"
- "I failed the 3-hour glucose test — what happens now?"
- "Is GD my fault or is it the placenta / hormones?"
- "Will this go away after I give birth, or do I have diabetes forever?"

**Glucose logging & 'am I in range?' (the daily burden)**
- "How many times a day do I actually have to prick my finger?"
- "My fasting number is high even though I eat well — why, and what do I do?"
- "One reading was 160 — do I need to call someone right now or wait?"
- "I'm so tired of testing 4 times a day and writing it all down." (logging fatigue is a top complaint)

**Diet / carb guidance (the biggest practical pain)**
- "What can I actually eat? Every list contradicts the next."
- "How many carbs per meal / per snack?"
- "Why does my sugar spike after breakfast specifically?"
- "How do I eat rice / bread / dates / knafeh with GD?" (cultural-food conflict — strong MENA signal)
- “What do I do about fasting for Ramadan with gestational diabetes?” → Femio gives no fast/don’t-fast decision and no medication or meal-timing change; it prompts advance discussion with the maternity/diabetes team and offers neutral question-preparation.

**Medication (educational anxiety)**
- "My diet numbers are fine but fasting won't budge — will they put me on insulin?"
- "Is metformin / insulin safe for the baby?"
- "I'm scared of needles / injecting myself."

**Appointments & extra monitoring**
- "Suddenly I have way more appointments — dietitian, diabetes midwife, extra scans — how do I keep track?"
- "What is a growth scan and when do I get one?"
- "They mentioned induction at 38–39 weeks — is that normal for GD?"

**Delivery & baby**
- "Will my baby be too big? Will I be induced early?"
- "Will my baby's blood sugar drop after birth / go to the NICU?"

**Postpartum**
- "Do I still test after birth? What's this 6-week glucose test?"
- "What are my chances of getting type 2 diabetes later, and can I lower them?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Pregnancy apps (What to Expect, Ovia, Pregnancy+, Flo) give lovely week-by-week baby content but **no real glucose log** — GDM is a footnote article, not a toolset.
- Diabetes apps (mySugr, Glucose Buddy) log glucose well but **know nothing about pregnancy** — no gestational context, no fetal content, and worse, many surface **insulin/bolus dose recommendations** (out of scope and unsafe for a wellness app) and paywall target ranges/reminders.
- Nobody stitches the two together → she juggles two apps.
- Privacy dread — "I don't want my diabetes + pregnancy status sold or visible to my employer/insurer."
- Judgmental / gamified diabetes UX that makes an already-guilty user feel graded.

---

## C. Competitor teardown

Two categories collide for D3: **pregnancy trackers** (great baby content, no glucose tooling) and **diabetes trackers** (great glucose tooling, no pregnancy context, and often out-of-scope dosing features). **The integration is the whitespace.**

| Capability | What to Expect | Ovia Pregnancy | Pregnancy+ | Flo (preg mode) | mySugr | Glucose Buddy |
|---|---|---|---|---|---|---|
| Week-by-week fetal/pregnancy content | Strong | Strong + insights | Best-in-class visuals | Good | **None** | **None** |
| GDM education | Article-level only | Article + employer "GD prevention program" | Article-level | Article-level | Diabetes-generic | Diabetes-generic |
| Blood-glucose log | **No** | Symptom log, not true BG | **No** | **No** | **Yes, core** | **Yes, core** |
| Fasting/post-meal tagging & targets | No | No | No | No | **Yes (targets behind PRO)** | **Yes** |
| Carb / meal logging | No | Basic food log | No | No | **Yes** | **Yes (+ nutrition DB)** |
| Insulin/med log | No | No | No | No | **Yes (+ bolus calc — OUT of scope for us)** | **Yes** |
| Appointment / extra-visit tracking | Basic | Better | Reminders | Reminders | No | No |
| Clinician-shareable report (PDF) | No | Limited | No | No | **Yes** | **Yes** |
| Pregnancy + GDM integrated | **No** | Partial (prevention program, not a glucose tool) | No | No | No (diabetes only) | No |
| Languages / RTL | EN-centric | EN-centric | Multi | Multi | Multi (no true Arabic-first) | EN-centric |
| Privacy posture | Reported data sale | Labcorp-owned; employer-visibility concern | Reported ad-SDK sharing | 2021 FTC settlement | Roche-owned health data | Ad-supported free tier |

**Whitespace Femio owns (D3):** *the only calm, privacy-first, Arabic-first app that layers a compliant GDM glucose/meal/appointment toolset onto real week-by-week pregnancy content in one account* — without a bolus calculator, without ads, without selling her data, and without making her feel graded.

**Compliance contrast to note:** mySugr's headline feature (insulin/bolus dose recommendation) is exactly what Femio must NOT do. Femio logs glucose and meds as **user-recorded tracking data with educational context only** — no dose suggestions, no titration, no "your number is bad."

---

## D. Clinical grounding (cited)

All figures below are **education, not medical advice**; app copy must attribute to these bodies, present targets as *"a common range your clinician confirms for you,"* and defer every dosing/treatment decision to the user's care team. Units shown in both mg/dL and mmol/L because targets differ by region (US mg/dL vs UK/NHS & much of MENA mmol/L).

**What GDM is / how common.** Gestational diabetes is high blood sugar first recognized in pregnancy; it affects roughly **up to ~9% of US pregnancies** and typically resolves after birth, though it signals higher lifetime T2DM risk. Driven largely by placental hormones causing insulin resistance — **not** by anything the woman "did wrong" (important anti-self-blame framing). [CDC; MedlinePlus; NIH; StatPearls]

**Diagnosis.** Screening is routine at **24–28 weeks** (earlier if risk factors). Two common approaches: the **one-step 75-g OGTT** or the **two-step** 50-g glucose-challenge followed, if elevated, by a **100-g 3-hour OGTT**. App framing: explain *"screening → if elevated, a diagnostic test; discuss your results with your clinician"* — never render a diagnosis from user-entered numbers. [ACOG 2018 (PB 190); ADA Standards of Care 2026 §15]

**Glucose targets (education; her clinician sets hers).** Commonly taught targets in GDM:
- **Fasting / pre-meal:** < **95 mg/dL** (< **5.3 mmol/L**)
- **1-hour post-meal:** < **140 mg/dL** (< **7.8 mmol/L**)
- **2-hour post-meal:** < **120 mg/dL** (< **6.7 mmol/L**)
→ Present as an **educational reference band**, always "your clinician confirms your personal targets," never a pass/fail score. [ACOG; ADA 2026 §15; NHS]

**Monitoring frequency.** The common regimen is **fasting on waking + 1 (or 2) hours after each meal** — i.e., ~**4 checks/day**. App reflects this as an optional, editable logging cadence, not a prescription. [ACOG; ADA §15; NHS/Tommy's]

**Diet / carbohydrate (first-line).** Medical nutrition therapy is first-line: emphasis on **complex/slower-release carbohydrates, spreading carbs across meals + snacks, pairing carbs with protein/fat**, reducing high-sugar foods and drinks; referral to a **dietitian** is standard. Femio gives *general, cited* carb education and culturally-adapted example meals — **not** a personalized prescriptive meal plan. [NHS/Frimley & North Cumbria; ADA §15]

**Medication (educational only).** When diet/activity don't reach targets, **insulin** is the classic first-line pharmacologic option; **metformin** is also used (crosses the placenta; shared-decision with clinician). Femio content explains *what these are and why a clinician might use them* — **never** doses, titration, or "you should start X." [ADA 2026 §15; ACOG]

**Risks it's honest about (without fear-mongering).** Untreated/poorly-controlled GDM raises the chance of a **large baby (macrosomia)** → shoulder-dystocia/birth-injury and cesarean risk; **pre-eclampsia**; **preterm birth**; and **neonatal hypoglycemia** after birth. Crucially, **treatment lowers these risks** (e.g., pre-eclampsia risk shown to fall with treatment) — always paired with the reassuring, true message that GDM is common and manageable. [MedlinePlus; NIH; StatPearls-Macrosomia; Healthline/clinical]

**Pre-eclampsia overlap (escalation link).** GDM raises pre-eclampsia risk, so D3 keeps the **CDC "Hear Her" warning-signs** prominent (severe/persistent headache, vision changes, severe swelling of face/hands, upper-abdominal pain, trouble breathing) → these are report-now signs, never an app diagnosis, and set the D3→**D6** blend. [CDC Hear Her]

**Postpartum → lifelong.** ADA/ACOG recommend a **75-g OGTT at 4–12 weeks postpartum** to check whether diabetes/prediabetes persists (~30%+ have prediabetes/IGT, ~4% T2DM at that test), then **lifelong screening every 1–3 years**; lifetime T2DM progression risk is high (~40–70%) but reducible with lifestyle/medication. This seeds the E4 handoff. [ADA 2026 §15; ACOG; SMFM]

**Resolved source set.** Global education cites [WHO recommendations on care for women with diabetes during pregnancy (2025)](https://www.who.int/publications/b/81691), [NICE NG3](https://www.nice.org.uk/guidance/ng3), and ACOG’s [Gestational Diabetes guidance hub](https://www.acog.org/topics/gestational-diabetes). Femio does not diagnose GDM, reproduce a diagnostic table, set a glucose target, or advise Ramadan fasting/medication changes. Targets, test method, and fasting decisions come from the user’s maternity/diabetes team or an approved country module. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

D3 = the **D1 spine (week content, appointments, warning-signs, weight)** + a **GDM tool layer**. Nothing from D1 is removed.

**P0 — must-have (the GDM layer)**
1. **Blood-glucose log** — quick entry with **meal-context tags** (fasting / pre-meal / 1-hr post / 2-hr post / bedtime), value in mg/dL *or* mmol/L (locale unit). Shows her own readings against an **educational reference band** she or her clinician can set. *Tracking aid, not a test result interpreter.*
2. **Meal / carb log** paired to readings — optional note or photo per meal so she can *see her own patterns* ("what did I eat before that number?"). Non-judgmental, no scoring.
3. **Extra-appointment & care-team tracker** — dietitian, diabetes midwife/educator, endocrinology, **growth scans**, more-frequent visits; reminders; "questions to ask."
4. **GDM education hub** — referenced, calm, anti-self-blame (see F).
5. **Clinician-shareable export (PDF/CSV)** of glucose + meal + med logs — the thing her care team actually asks for.
6. **Red-flag safety layer (inherited + GDM-tuned)** — persistent warning-signs access; contextual red-flag boxes (very high/low readings → "contact your care team," pre-eclampsia signs, reduced fetal movement).

**P1 — high value**
7. **Medication log (educational)** — record that she took metformin/insulin *as prescribed by her clinician* (name, time, user-entered) for her own pattern-tracking and export. **No dose suggestions, no calculators.**
8. **Reading reminders** — optional nudges at her chosen test times (fasting, post-meals), fully editable.
9. **Trend views** — her readings over time by meal-context; % in her own range (descriptive, never a grade).
10. **Kick counter / contraction timer (from D1, T3)** — unchanged.

**P2 — differentiators / later**
11. Culturally-adapted carb/meal example library (MENA + EN/FR/ES), dietitian-reviewed.
12. Postpartum bridge card → **E4** OGTT reminder + lifelong-screening explainer.
13. Gentle, moderated GDM peer support / curated Q&A (privacy-safe, only if moderation is guaranteed).
14. Optional glucometer/CGM data import (read-only display of user data; no interpretation) — later, pending device/compliance review.

**Explicitly out of scope (compliance):** any **insulin/bolus dose calculator or titration** (mySugr-style); any "your reading is high/low — do X" instruction; any algorithm that *diagnoses* GDM or "your control is good/bad"; any prediction of macrosomia/outcome. Glucose and meds are **user-recorded tracking data with educational context only.**

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL, dual-unit). Delivered as an additive GDM hub on the D1 library; always searchable.

- **"You've just been diagnosed" primer** — what GDM is, that it's common and **not her fault** (placental hormones, not diet-shaming), that it's manageable, what changes now. Explicitly anti-self-blame and anti-catastrophizing.
- **Understanding your numbers** — fasting vs pre-meal vs 1-hr/2-hr post-meal; what the common target band means; why *"your clinician sets your targets."* Dual-unit.
- **Why fasting numbers can be stubborn** — validating explainer (the classic "I eat perfectly and it's still high" frustration → hormonal, common, discuss with clinician).
- **Eating with GDM** — complex carbs, spreading/pairing carbs, snacks, high-sugar foods to limit; honest "overblown vs real"; **culturally-adapted example meals** (rice, bread, dates, MENA staples) + a Ramadan-with-GDM "discuss with your clinician first" note.
- **Monitoring how-to** — using a glucometer, when to test, hygiene, logging without burning out (validating the logging fatigue).
- **Medication, explained (educational)** — what metformin and insulin are, why a clinician might add them, safety questions to ask; needle-anxiety reassurance. No doses.
- **Extra appointments & scans** — dietitian, diabetes team, growth scans, more-frequent visits; what each is for; what to ask.
- **GDM and your baby / delivery** — honest, gentle: macrosomia, possible induction/earlier delivery discussion, neonatal blood-sugar checks; paired with "treatment lowers these risks."
- **Warning-signs hub (inherited)** — CDC Hear Her list always reachable; **pre-eclampsia awareness** foregrounded (GDM overlap) as symptoms-to-report, never diagnosis; "very high or very low readings → contact your care team."
- **After birth: GDM usually resolves, but** — the **4–12 week OGTT**, lifelong T2DM screening every 1–3 years, and lifestyle steps that reduce risk (bridges to E4).
- **Emotional wellbeing with GDM** — normalizing anxiety/guilt/food-stress; soft pointer to mood screening ("screening, discuss with clinician"); when to seek support.

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs & tools**
- **Glucose log** — value + unit + meal-context tag + optional note. Displays *her* readings vs an editable **educational reference band**. Copy: *"This is a tracking aid, not a medical test or diagnosis. Targets shown are general education — your care team sets what's right for you. It can't tell you a reading is 'good' or 'bad.'"* No scoring, no color-graded "fail" states beyond a neutral "above/below your set range" marker for *her own* reference.
- **Meal / carb log** — paired to readings so she sees her own patterns; optional photo; no calorie/carb "budget" enforcement, no judgment.
- **Medication log (educational)** — user records meds *as prescribed*; for pattern-tracking + export only. Copy: *"Record only. Femio never recommends or adjusts doses — follow your clinician."*
- **Trend view** — readings by meal-context over time; descriptive "% in your set range." Framed as *"a picture to share with your care team,"* never a grade.
- **Appointment/care-team log** — extra GDM visits, scans, provider, notes, results (user-entered), reminders.
- **Export (PDF/CSV)** — glucose + meals + meds + notes for appointments.
- **Kick counter / contraction timer (T3, inherited from D1)** — unchanged, same compliant framing.

**Alerts (all opt-in, calm, non-alarmist)**
- Reading reminders at her chosen test times (editable).
- Appointment/scan reminders.
- Gestational-milestone + content nudges (inherited).
- Postpartum: a single gentle **"book your 4–12 week glucose test"** reminder after delivery (→ E4).
- **No** predictive/diagnostic alerts. **No** "your sugars are dangerous" auto-verdicts. **No** insulin/dose prompts.

**Red-flag box pattern (reusable component, GDM-tuned).**
> **⚠ Seek care now**
> Contact your maternity/diabetes care team or local emergency number right away if you have: a blood-sugar reading much higher or much lower than your care team told you to expect · shaking, sweating, confusion or feeling faint (possible low sugar) · a severe headache that won't go away or vision changes · severe swelling of your face/hands · pain in the upper right of your tummy · trouble breathing · heavy vaginal bleeding or fluid leaking · (after ~28 wk) your baby moving noticeably less than usual · thoughts of harming yourself.
> *You know your body best — if something feels wrong, get it checked. This app can't diagnose or treat, and it can't tell you a glucose reading is safe or dangerous.*
> [Save my care-team/emergency contact] [Learn the warning signs]

Placement: persistent nav entry + auto-injected on the glucose-log screen (near "very high/low reading" guidance), pre-eclampsia/warning-sign content, and any symptom explainer with an associated danger sign.

---

## H. EMR fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1)**
- Identity/account, locale/language, **units (mg/dL vs mmol/L)**.
- DOB / age; height; pre-pregnancy weight & BMI.
- Menstrual history; LMP.
- Medical-history flags (**diabetes, PCOS, hypertension, thyroid, prior VTE**, family history of T2DM).
- Medications, allergies, supplements.
- Prior pregnancies/outcomes (gravida/para); **prior GDM flag; prior macrosomic baby**.
- Consent/privacy settings; emergency/care-team contact (optional).

**Persona-specific (GDM — layered over the constant core EMR, on top of D1's pregnancy fields)**
- **GDM status & diagnosis date** — user-recorded (the D1→D3 transition marker); screen type recorded (one-step / two-step, values as user notes — *not app-interpreted*).
- **GDM risk factors** carried from core (prior GDM, high BMI, PCOS/B6, family history, prior large baby, AMA) — used to *surface* early-screen education, never to diagnose.
- **Glucose readings series** — value, unit, meal-context tag (fasting/pre/1-hr/2-hr/bedtime), timestamp, optional note. User-entered.
- **Personal target band** — user- or clinician-set fasting & post-meal thresholds (default = educational common band, editable). Stored as reference, not a rule.
- **Meal/carb log** — entries paired to readings; optional photo.
- **Medication log** — GDM meds (metformin/insulin) name + time, *user-recorded as prescribed*; no dose logic.
- **Treatment mode** (diet-only / metformin / insulin) — user-recorded; drives *content emphasis* (e.g., needle-anxiety module if insulin), never a clinical action.
- **Extra-visit / scan log** — dietitian, diabetes team, growth scans, results (user-entered).
- **Delivery-planning notes** — induction/earlier-delivery discussion, mode-of-birth preferences (user-entered).
- **Postpartum OGTT status** — due/booked/done + result-as-user-note (→ E4).
- Inherited D1 fields (EDD/GA, BP-if-logged, kick/contraction sessions, weight series, etc.) all retained.

---

## I. Personalization rules (layered on the D1 pregnancy base; hidden-but-reachable)

**D3 does not re-onboard.** It activates *on top of* an existing D1 pregnancy context when GDM is recorded — additive emphasis, nothing hidden or removed.

**Activation (wizard delta, short & editable/resettable — personalize, never restrict).**
1. Trigger: user records a **GDM diagnosis** (or "my glucose test was abnormal") — often from a D1 home prompt after the ~24–28 wk screen, or offered proactively if GDM **risk factors** are in her record.
2. Quick set-up: preferred **units** (mg/dL / mmol/L); **test times** for reminders (fasting + post-meals, editable); **treatment mode** (diet-only / metformin / insulin, editable); who (if anyone) she shares with (X2 partner).
3. Optional: enter clinician-given **target band** (else default educational band, clearly labeled editable).

**Home configuration (GA-driven, inherited from D1, with GDM layer on top).**
- **Diagnosis moment / early D3:** the "You've just been diagnosed" primer and "Understanding your numbers" are foregrounded; glucose log surfaced as the new primary quick-action; reassurance + anti-self-blame tone dialed up.
- **Steady state:** glucose log + trend + meal log foregrounded; carb-education and appointment tracker prominent; the D1 week-by-week card stays present (she is still pregnant and wants baby content).
- **Insulin/metformin recorded:** medication-education + needle/medication-anxiety modules surfaced; med log added.
- **T3 (inherited):** kick counter + contraction timer + birth-prep surface as in D1, plus GDM-delivery content (macrosomia, induction talk, neonatal sugar checks).
- **Post-delivery:** GDM tools quiet down; the postpartum-OGTT bridge card appears (→ E4).

**Hidden-but-reachable rule.** Nothing is locked. The full D1 pregnancy experience remains completely intact and foregrounded; GDM tools are *added*, and every article/tool stays in the library and search regardless of persona. She can collapse or de-emphasize the GDM layer if she finds it heavy, without losing it.

**Continuity.** Her D1 pregnancy record (EDD/GA, appointments, weight, symptoms) and core history (risk factors, prior GDM, PCOS) seed D3 automatically — no separate app, no re-entry; a one-time *"your pregnancy history is here, this just adds your GDM tools, and it's all private"* note.

---

## J. Adaptation triggers (state transitions)

**INTO D3 (from D1):**
- **GDM diagnosis / abnormal glucose-screen recorded** by the user (typically after the 24–28 wk screen, sometimes early) → offer to add the GDM layer to her existing pregnancy mode; carry all D1 context; **privacy step:** reassure that her diabetes + pregnancy status is never sold, never employer/insurer-visible, and confirm partner-sharing scope. Additive emphasis — **do not diagnose**; frame as *"you've told us your clinician diagnosed GDM — here's education, tracking and when to seek care."*
- **Risk-factor pre-surfacing:** if prior GDM / high BMI / PCOS / family history are in her record, D1 may *offer* early-screen education (never a prediction, never a diagnosis).

**Within pregnancy (additive blends, never restriction, never diagnosis):**
- **Pre-eclampsia signs or elevated BP logged** → blend **D6** (gestational HTN/pre-eclampsia) awareness; foreground warning-signs; GDM raises this risk, so the link is primed. Education + "seek care," never a verdict.
- **Insulin/metformin recorded** → medication-education emphasis (still D3, no dosing).
- **Growth-scan / macrosomia discussion or large-baby concern** → delivery-planning content emphasis.
- **Repeated low-mood logs / positive mood screen** → **D11** antenatal anxiety/depression emphasis (screening framing) — GDM carries elevated anxiety, so watch gently.
- All D1 content stays fully available; the resolver blends emphasis.

**OUT of pregnancy:**
- **Delivery/birth logged** → transition to **Postpartum (E1)**, and because she had GDM, **carry forward to E4**: a gentle single reminder to book the **4–12 week postpartum OGTT**, lifelong T2DM-screening (every 1–3 years) education, and risk-reduction lifestyle content; **E2** if breastfeeding. GDM glucose tools quiet down but remain reachable (some clinicians ask for a short postpartum monitoring period — user-recorded only).
- **Pre-eclampsia escalation co-occurring at/after delivery** → carry the D6 awareness into E-series follow-up (BP monitoring education), never diagnosis.
- **Pregnancy loss / stillbirth logged** → immediate, dignified transition to **loss/grief (E6)**: stop all pregnancy *and GDM* reminders instantly (glucose nudges, appointment prompts), offer grief resources, no re-prompting.
- **Reset/withdraw:** she can drop the GDM layer or exit pregnancy mode anytime; data retained per her privacy settings, nothing forced.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention claims, no medical-device functionality. The glucose log, meal log and medication log are **tracking aids for user-entered data**, explicitly *not* tests, not diagnostic tools, and not able to judge a reading "safe/dangerous" — copy must state this (avoids medical-device classification per femio-compliance-privacy skill).
- **No dosing / no titration / no calculators:** categorically **no insulin or bolus calculator, no dose recommendation, no "start/increase X"** (the explicit line vs mySugr). Medication content is general, cited, and defers every decision to the clinician.
- **Glucose targets are educational reference bands, clinician-confirmed:** shown dual-unit, labeled editable, never a pass/fail score; app never renders a GDM diagnosis from user-entered numbers.
- **Screeners = "screening, discuss with clinician":** the glucose screen/OGTT and any mood screen framed as screening, never verdicts.
- **Red-flag routing:** very-high/very-low readings, pre-eclampsia signs, reduced fetal movement, hypo symptoms use "seek care now" framing pointing to her care team / local emergency number; never reassures ("your baby/sugar is fine"), never alarms with a diagnosis.
- **Anti-self-blame, non-judgmental tone (sensitive topic):** given documented guilt/anxiety and disordered-eating-adjacent food stress in GDM, all copy is non-shaming; no "you failed," no graded gamification of readings or meals; food logging never enforces a budget.
- **Privacy-by-design (GDPR/PDPL, health data):** GDM status is sensitive health data layered on sensitive pregnancy data — minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility**. Partner sharing opt-in and granular. Loss/withdrawal → immediate suppression of all pregnancy + GDM reminders and honored deletion.
- **Content provenance:** every medical claim medically reviewed + cited to Tier-1 (CDC/NIH/MedlinePlus/NHS) / Tier-2 (ACOG/ADA/NICE); review dates surfaced; no clickbait, no sponsored content interleaved with medical guidance.
- **i18n/RTL + cultural food literacy:** all safety/red-flag copy human-reviewed in AR/EN/FR/ES (not machine-only) given clinical stakes; carb/meal examples culturally adapted (MENA staples, Ramadan "discuss with clinician first").
- **Publication control:** source anchors are pinned above. Region-specific mmol/L targets, diagnostic thresholds, and Ramadan instructions are excluded from global copy; warning-sign destinations use the maintained local-provider/emergency fallback and a country module only when approved. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

- [CDC — Gestational Diabetes](https://www.cdc.gov/diabetes/about/gestational-diabetes.html)
- [MedlinePlus — Gestational Diabetes](https://medlineplus.gov/genetics/condition/gestational-diabetes/)
- [NIH DiscoverWHR — Gestational Diabetes Mellitus (GDM) Research Overview](https://discoverwhr.nih.gov/research/gestational-diabetes-mellitus-gdm/)
- [NCBI StatPearls — Gestational Diabetes](https://www.ncbi.nlm.nih.gov/books/NBK545196/)
- [NCBI StatPearls — Macrosomia](https://www.ncbi.nlm.nih.gov/books/NBK557577/)
- [ADA — Management of Diabetes in Pregnancy: Standards of Care in Diabetes—2026 (§15)](https://diabetesjournals.org/care/article/49/Supplement_1/S321/163918/15-Management-of-Diabetes-in-Pregnancy-Standards)
- [ADA — Management of Diabetes in Pregnancy: Standards of Care—2024 (§15)](https://diabetesjournals.org/care/article/47/Supplement_1/S282/153948/15-Management-of-Diabetes-in-Pregnancy-Standards)
- [The ObG Project — ACOG Updated Guidance on Gestational Diabetes (screening, targets, postpartum)](https://www.obgproject.com/2023/01/02/acog-releases-updated-guidance-gestational-diabetes/)
- [SMFM — Special Statement: Quality metric on postpartum diabetes screening after GDM](https://www.ajog.org/article/S0002-9378(22)02601-1/fulltext)
- [NHS Frimley Health — Healthy Eating for Gestational Diabetes](https://www.fhft.nhs.uk/patients-and-visitors/patient-information-library/healthy-eating-gestational-diabetes)
- [NHS North Cumbria — Healthy Eating for Gestational Diabetes](https://www.ncic.nhs.uk/patients-visitors/patient-information-leaflets/Maternity-Healthy-eating-for-Gestational-Diabetes)
- [Tommy's — Monitoring Your Own Glucose Levels (blood sugar targets)](https://www.tommys.org/pregnancy-information/pregnancy-complications/gestational-diabetes/monitoring-your-own-glucose-levels)
- [CDC — Urgent Maternal Warning Signs (HEAR HER Campaign)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [PMC — Psychological wellbeing of women with GDM: increased anxiety in those requiring insulin](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9888455/)
- [PMC — Emotional/psychological burden of GDM (qualitative, low-income women)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7552378/)
- [PMC — GDM, emotional eating and clinical indicators](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12388857/)
- [PMC — GDM management among primigravida women (qualitative)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12375173/)
- [mySugr — Diabetes Tracker (features incl. bolus/insulin calculator — out-of-scope contrast)](https://www.mysugr.com/en/diabetes-app)
- [Gluroo — mySugr vs Glucose Buddy comparison](https://gluroo.com/blog/diabetes-101/mysugr-vs-glucose-buddy-full-comparison/)
- [Malama — Top Gestational Diabetes Apps (glucose + meal tracking teardown)](https://heymalama.co/guide-to-glucometers/top-5-gestational-diabetes-apps-for-pregnant-patients)
- [SNAQ — Best Gestational Diabetes Apps 2025](https://www.snaq.ai/blog/best-gestational-diabetes-apps-2025)
- [Ovia Health — Gestational Diabetes During Pregnancy (content-level, not a glucose tool)](https://www.oviahealth.com/guide/10071/gestational-diabetes-during-pregnancy/)

*Medical-source resolution: [WHO 2025](https://www.who.int/publications/b/81691), [NICE NG3](https://www.nice.org.uk/guidance/ng3), and the [ACOG Gestational Diabetes hub](https://www.acog.org/topics/gestational-diabetes) are pinned. Global copy contains no diagnostic/target table or Ramadan treatment instruction. Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
