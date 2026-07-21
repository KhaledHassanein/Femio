# Persona D4 — Pregnancy with Pre-Existing (Pregestational) Diabetes — Type 1 or Type 2

Prepared: 2026-07-17 · Wave 1 (spine) · Status: research + spec
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills
Layers on: **D1 (uncomplicated pregnancy)** — D4 is *additive pregestational-diabetes emphasis on the D1 spine*, never a separate silo.
Distinct from: **D3 (gestational diabetes)** — D4 is **diabetes diagnosed *before* pregnancy (type 1 or type 2)**, carried in from conception, lifelong, usually insulin/pump/CGM-managed, with **preconception glycaemic control**, **higher congenital-anomaly / pre-eclampsia risk**, tighter targets, and far more intensive monitoring. It does **not** resolve at delivery (→ E4 ongoing diabetes care, not a one-off postpartum OGTT).
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening, discuss with clinician." Glucose, CGM and medication content is educational, never prescriptive — no dosing, no bolus/carb-ratio calculators, no insulin titration, no "your reading/CGM trend is good/bad."**

---

## A. Persona snapshot

**Who she is.** A woman with **type 1 or type 2 diabetes diagnosed before this pregnancy**, who is either planning a baby (**preconception**) or is already pregnant and managing her diabetes from day one. If T1, she has lived with intensive self-management for years — likely an **insulin pump and/or CGM (or an automated insulin delivery / hybrid closed-loop system)**, carb-counting, fear of hypos. If T2, she may be on metformin and/or insulin, sometimes newly switched off oral agents for pregnancy. She is often a **prior Femio user** — either from a **pre-pregnancy diabetes/cycle life-track** or a **C-series TTC** journey where her diabetes was already flagged — so her condition, meds, HbA1c history and devices carry in. Unlike D3 she was **never "normal-pregnancy" then diagnosed**; she enters pregnancy already knowing the stakes and already exhausted by the regimen.

**Core job.** "I've had diabetes for years and now I'm trying for / carrying a baby. The targets are suddenly much tighter, everyone keeps telling me my sugars affect my baby's development, and I'm terrified of both highs *and* hypos. Help me keep my glucose/CGM picture, meals, insulin, HbA1c and all these extra appointments (eye screening, kidney tests, growth scans, extra monitoring) in one private place; explain what the tight targets and the risks actually mean; tell me clearly when to seek care — and reassure me that women with diabetes have healthy babies — without pretending to be my doctor, calculating my insulin, scaring me, or selling my data."

**Emotional arc (the anxiety is front-loaded and continuous, not diagnosis-triggered like D3).**
- **Preconception (the defining, under-served window):** the pressure to hit an HbA1c target *before* conceiving; folic-acid/med-review anxiety; grief/frustration at "not being allowed" to try until control improves; fear she's already "too high." Research shows preconception care measurably lowers anomaly risk — yet most apps ignore this window entirely.
- **Early T1 (organogenesis):** acute fear that early highs harmed the baby during organ formation; guilt and self-blame ("did my numbers before I knew hurt my baby?"); paradoxically, **first-trimester hypoglycaemia** is common and frightening (fear of lows harming baby brain / her own safety while driving).
- **Mid-pregnancy:** relentless logistical load — 7+ checks/day or CGM vigilance, shifting insulin needs, dietitian + diabetes-antenatal clinic + eye screening + renal tests; the **diabetes-distress cycle** (guilt → hypervigilance → burnout → guilt).
- **Late T3:** insulin resistance rises so needs climb; macrosomia / growth-scan worry; talk of **earlier, planned delivery (often 36–39 wk)**; NICU / neonatal-hypoglycaemia fear; birth-plan anxiety with a pump/CGM.
- **Postpartum (does NOT resolve):** insulin needs **crash** right after delivery (real hypo danger), breastfeeding-and-lows, and lifelong diabetes continues — a very different tail from D3 (→ E4 ongoing care, not a resolving condition).

**Context.** Web-first, mobile-heavy; opens the app **many times a day** — every glucose check / CGM glance / meal / dose is a potential touchpoint (even heavier than D3). Arabic-first / RTL primary with EN/AR/FR/ES; carb/meal guidance must be culturally literate (rice, bread, dates, Ramadan-with-insulin — a serious "discuss with your clinician first" topic). She is device-fluent and data-hungry but emotionally raw; the app must be calm, non-judgmental and never add shame to an already guilt-heavy experience.

**Success = she feels informed, organized, and less alone** — her CGM/glucose picture, meals, insulin, HbA1c and the *many* extra appointments live in one private place she can show her care team; she understands the tight targets and honest risks *and* the true, evidence-based reassurance that good control dramatically improves outcomes; genuine red flags (severe hypo, DKA warning signs, pre-eclampsia, reduced fetal movement) are surfaced loudly and routed to care — never diagnosed, never trivialized, and **never** turned into a dose instruction.

---

## B. Needs & questions (voice-of-user)

Mined from r/diabetes_t1, r/diabetes_t2, r/type1diabetes pregnancy threads, r/BabyBumps, Beyond Type 1 / JDRF pregnancy communities, diabetes-app reviews, and the qualitative pre-existing-diabetes-in-pregnancy literature. Representative real questions, grouped by job-to-be-done. Verbatim-style paraphrases.

**Preconception (the window nobody else serves)**
- "I have T1 and want to start trying — what HbA1c do they want before I'm 'allowed' to?"
- "Do I need to change my meds before conceiving? I'm on [oral tablets] — is that safe?"
- "How much folic acid do people with diabetes take, and why is it higher?"
- "I'm scared my current numbers already mean I can't have a healthy baby."

**Guilt, fear & reassurance (continuous, not a single shock)**
- "Every high feels like I'm damaging my baby — the guilt is crushing."
- "Can women with type 1 actually have healthy babies? I need to hear it's possible."
- "The diabetes-distress cycle is real — I'm hypervigilant and burnt out at the same time."

**Tight targets & CGM (the defining daily burden)**
- "Why are pregnancy targets SO much tighter than my normal ones?"
- "What time-in-range should I aim for now — I keep hearing 70%?"
- "My CGM is buzzing all day and I feel like I'm failing every alarm."
- "How do I read my CGM without spiraling every time it goes over the line?"

**Hypoglycaemia (unique, insulin-driven fear — not a big D3 theme)**
- "First-trimester lows are brutal — are they hurting the baby?"
- "I'm scared of going low overnight / while driving now that I'm pregnant."
- "My insulin needs keep changing — I can't keep up." (needs drop early, rise late, crash postpartum)

**Insulin / pump / meds (educational anxiety)**
- "Is my pump/CGM okay to use in pregnancy? What about during labour?"
- "They took me off my tablets and put me on insulin — is that normal?"
- "How do people manage carb-counting with pregnancy cravings and nausea?" (→ never calculate a dose)

**Extra monitoring & appointments (a huge, distinct load)**
- "Suddenly there's an eye-screening AND a kidney test AND a diabetes-antenatal clinic — how do I track all this?"
- "What is a fetal echo / growth scan / the twice-weekly monitoring for?"
- "Why do they want to deliver me at 37–38 weeks?"

**Delivery & baby**
- "Will my baby be too big? Will I need a C-section / induction earlier?"
- "Will my baby's blood sugar crash after birth / go to NICU?"

**Postpartum (does NOT resolve — key D3 contrast)**
- "My insulin needs dropped off a cliff after delivery and I keep going low — is that normal?"
- "How do I manage lows while breastfeeding?"
- "I still have diabetes forever — what changes now, if anything?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Pregnancy apps (What to Expect, Ovia, Pregnancy+, Flo) give lovely week-by-week baby content but **zero real glucose/CGM tooling** — pregestational diabetes is a footnote, and they know nothing about pumps, CGM, TIR or preconception.
- Diabetes apps (mySugr, Glucose Buddy, Sugarmate, CGM apps) log/read glucose well but **know nothing about pregnancy** — no gestational context, no tighter pregnancy targets, no fetal content — and, critically, many surface **bolus/insulin-dose calculators** (mySugr) or **grade meals** (Glucose Buddy "Meal IQ"), which are exactly out of scope and unsafe for a wellness app.
- **Nobody covers the preconception window** at all — the most impactful moment for this persona.
- She ends up juggling 2–3 apps + her pump/CGM software.
- Privacy dread — "I don't want my diabetes + pregnancy status sold, or visible to my employer/insurer."
- Judgmental, gamified, "streak/score" diabetes UX that grades an already-guilty user.

---

## C. Competitor teardown

Three worlds collide for D4: **pregnancy trackers** (great baby content, no glucose/CGM tooling, no diabetes literacy), **diabetes/CGM trackers** (great glucose tooling, no pregnancy context, and often out-of-scope dosing/grading), and **the entirely un-served preconception window**. **The integration — plus preconception — is the whitespace.** This is a *deeper* gap than D3's, because D4 adds CGM/TIR, insulin/pump literacy, and a preconception phase.

| Capability | What to Expect / Pregnancy+ / Ovia (preg) | Flo (preg mode) | mySugr | Glucose Buddy | Sugarmate | CGM vendor apps (Dexcom/Libre) |
|---|---|---|---|---|---|---|
| Week-by-week fetal/pregnancy content | Strong / best-in-class visuals | Good | **None** | **None** | **None** | **None** |
| Pregestational-diabetes education | Article-level footnote | Article-level | Diabetes-generic | Diabetes-generic | None | None |
| **Preconception (pre-pregnancy) diabetes window** | **No** | **No** | **No** | **No** | **No** | **No** |
| Blood-glucose log | **No** | **No** | **Yes, core** | **Yes, core** | Via CGM | Via sensor |
| CGM display / time-in-range | **No** | **No** | Limited | Dexcom integ. | **Dexcom-native** | **Native TIR/AGP** |
| **Pregnancy-specific tighter targets / TIR 63–140** | **No** | **No** | No | No | No | No (generic targets) |
| Carb / meal logging | No / basic | No | **Yes** | **Yes (+ "Meal IQ" grading — out of scope tone)** | Basic | No |
| Insulin / med log | No | No | **Yes (+ bolus calculator — OUT of scope for us)** | **Yes** | Basic | No |
| Extra-appointment / eye-screen / renal / growth-scan tracking | Basic reminders | Reminders | No | No | No | No |
| Clinician-shareable report (PDF/AGP) | No / limited | No | **Yes** | **Yes** | Yes (AGP) | **Yes (AGP)** |
| Pregnancy + pre-existing-diabetes integrated | **No** | **No** | No | No | No | No |
| Languages / RTL | EN-centric / multi | Multi | Multi (no true Arabic-first) | EN-centric | EN-centric | Multi (no Arabic-first care flow) |
| Privacy posture | Data-sale / employer-visibility concerns | 2021 FTC settlement | Roche-owned health data | Ad-supported free tier | Dexcom-partner data | Device-vendor cloud |

**Whitespace Femio owns (D4):** *the only calm, privacy-first, Arabic-first app that spans **preconception → pregnancy → ongoing postpartum diabetes**, layering a compliant glucose/CGM-context, meal, insulin-record and dense-appointment toolset onto real week-by-week pregnancy content in one account* — **without a bolus/carb calculator, without meal-grading, without ads, without selling her data, and without making her feel graded** by every CGM alarm.

**Compliance contrast to note:** mySugr's headline **bolus calculator** and Glucose Buddy's **Meal IQ grading** are precisely what Femio must NOT do. Femio displays glucose/CGM as **user-recorded / read-only tracking data with educational context only** — no dose suggestions, no titration, no carb-ratio math, no "your reading/trend/meal is good/bad."

---

## D. Clinical grounding (cited)

All figures below are **education, not medical advice**; app copy must attribute to these bodies, present targets as *"a common range your clinician confirms for you,"* and defer every dosing/treatment/med-change decision to the user's care team. Units shown in both mg/dL and mmol/L (US mg/dL vs UK/NHS/NICE & much of MENA mmol/L).

**What pregestational diabetes is / how it differs from GDM.** D4 covers **type 1 or type 2 diabetes present *before* pregnancy** ("pregestational" / "pre-existing"), distinct from gestational diabetes (first recognized in pregnancy). Prevalence of pre-existing diabetes in pregnancy has risen substantially. Because glucose is elevated during **organogenesis** (unlike GDM, which appears later), the risks and the management window are different and start **before conception**. [ADA 2026 §15; ACOG PB 201; CDC MMWR; Endotext]

**Preconception care (the defining, high-impact window).** The single most important diabetes-specific preconception step is **attaining glycaemic goals before conception**. Preconception care is associated with **lower A1C and reduced risk of birth defects, preterm delivery, perinatal mortality, SGA births and NICU admission** (meta-analysis RR ~0.32 for anomalies). Components: strict glycaemic control, **folic acid** supplementation, nutrition/activity, review/adjustment of **potentially teratogenic medications** (e.g., certain BP meds/statins per clinician), and baseline diabetes-specific testing (**A1C, creatinine, urine albumin-to-creatinine ratio**). Femio surfaces this as *education + tracking + "discuss with your clinician,"* never as instruction. [ADA 2026 §15; NICE NG3; PubMed 11493721; PMC preconception review]

**Preconception targets (education; clinician sets hers).** Aim for glucose as close to normal as safely possible without excess hypoglycaemia, ideally **A1C < 6.5% (< 48 mmol/mol)**; NICE advises avoiding pregnancy while **A1C > 86 mmol/mol (10%)**. Preconception glucose goals commonly taught: **preprandial 80–110 mg/dL (4.4–6.1 mmol/L)**, **2-h postprandial < 155 mg/dL (< 8.6 mmol/L)**. Present as an educational reference, never a gate the app enforces. [ADA 2026 §15; NICE NG3]

**Pregnancy glucose targets (tighter than GDM's; education only).** Commonly taught in pregnancy for any diabetes:
- **Fasting:** < **95 mg/dL** (< **5.3 mmol/L**)
- **1-hour post-meal:** < **140 mg/dL** (< **7.8 mmol/L**)
- **2-hour post-meal:** < **120 mg/dL** (< **6.7 mmol/L**) (NICE: 2-h < 6.4 mmol/L)
- **A1C in pregnancy:** ideally **< 6% (< 42 mmol/mol)** if achievable without significant hypoglycaemia; may be relaxed to **< 7% (< 53 mmol/mol)** to avoid hypos.
→ Educational reference band; *"your clinician confirms your personal targets"*; never a pass/fail score, never a diagnosis from user numbers. [ADA 2026 §15; ACOG PB 201; NICE NG3]

**CGM & time-in-range in pregnancy (a D4-defining metric; education only).** For **type 1** especially, the international **Time-in-Range-in-pregnancy (TIRp)** consensus target is **63–140 mg/dL (3.5–7.8 mmol/L) with > 70% of time in range**, time-above-range < 25%, plus low time-below-range — aimed for **as early as possible**. Every 5% higher TIR is associated with better neonatal outcomes (lower LGA, neonatal hypoglycaemia, NICU). CONCEPTT showed CGM in T1 pregnancy improves outcomes. Femio can **display** a user's TIR/CGM picture (read-only, if data is imported) as *education and a share-with-clinician view* — **never** interpret it as "good/bad" or drive a dose. [Diabetologia (Battelino/Murphy) "every 5% TIR matters"; ADA Diabetes Spectrum TIRp; Diabetes Care CGM & birth weight]

**Monitoring intensity (much heavier than GDM).** NICE: pregnant women with **type 1** should test **fasting, pre-meal, 1-h post-meal, and bedtime daily** (or use CGM) — ~7+ checks/day. Frequent HbA1c. This is a materially larger logging burden than D3 — the app must reduce, not add to, it. [NICE NG3; ADA 2026 §15]

**Retinopathy & nephropathy screening (persona-specific, not in D3).** Pregnancy can accelerate **diabetic retinopathy**; NICE/ADA recommend **retinal (eye) screening** in pregnancy (and preconception) and a **renal assessment** (creatinine, ACR) at first antenatal contact if not done in the prior 3 months. Retinopathy is **not** a contraindication to vaginal birth. Femio tracks these as appointments/results (user-entered) and explains why they matter — never interprets them. [NICE NG3; ADA 2026 §15]

**Congenital-anomaly risk (honest, dose-responsive, non-shaming framing).** Pre-existing diabetes raises the risk of **major congenital anomalies** (neural-tube, congenital heart defects, caudal regression — the last uniquely linked to maternal diabetes), stillbirth and LGA, with a **dose-response to periconception HbA1c** (e.g., ~10% anomaly rate at A1C ~10%, higher still at ~13%). The essential paired message: **good preconception/early control markedly lowers these risks** — honest but never fear-mongering, never blaming. [Endotext Pregestational DM; StatPearls Diabetic Embryopathy; PMC periconception glycemia; ACOG PB 201]

**Other risks it's honest about.** Increased risk of **pre-eclampsia**, **macrosomia / shoulder dystocia**, **preterm and cesarean delivery**, **stillbirth**, and **neonatal hypoglycaemia**. ACOG antenatal surveillance: **fetal echocardiography considered** if cardiac anomaly suspected; **NST/BPP once–twice weekly** in T3; **fetal-growth scans**; **planned delivery ~36 0/7–38 6/7 wk** with complications (vasculopathy, nephropathy, poor control, prior demise), up to ~39 wk if well-controlled. Femio explains what each is for; it does not schedule, interpret or predict outcomes. [ACOG PB 201 / ObG Project; Merck Manual; NICE NG3]

**Hypoglycaemia (a D4-specific safety theme absent from D3).** Insulin-treated women — especially **type 1** — face real **hypoglycaemia**, including **first-trimester lows** and **impaired awareness**; NICE stresses hypo education, glucagon access, and support. Post-delivery insulin needs **fall sharply**, raising early-postpartum hypo risk (esp. with breastfeeding). Red-flag hypo/DKA symptoms get "seek care now" framing — never a dose fix. [NICE NG3; ADA 2026 §15]

**Postpartum → lifelong (NOT resolving — key D3 contrast).** Unlike GDM, diabetes **continues after birth**. Care shifts to safe postpartum glycaemic management (sharp insulin-need drop, breastfeeding-and-lows), contraception/interpregnancy-planning counselling, and **ongoing lifelong diabetes care** — seeding the **E4** handoff (ongoing diabetes, not a one-off OGTT). [ADA 2026 §15; NICE NG3]

*[NEEDS SOURCE]* flags: exact **ACOG Practice Bulletin 201** permalink (acog.org); **NICE NG3** canonical permalink; the **TIRp international consensus** primary statement (Diabetes Care 2019, Battelino et al.) permalink; region-specific mmol/L targets and **Ramadan-with-insulin-in-pregnancy** guidance for MENA localization; CDC/MedlinePlus consumer-level pre-existing-diabetes-in-pregnancy page for Tier-1 grade-6–8 grounding.

---

## E. Feature set (prioritized)

D4 = the **D1 spine (week content, appointments, warning-signs, weight)** + a **pre-existing-diabetes tool layer** that also spans **preconception** and **ongoing postpartum**. Nothing from D1 is removed. It is heavier than D3's layer (CGM/TIR, hypo, insulin/pump, eye/renal screening, preconception).

**P0 — must-have (the pregestational-diabetes layer)**
1. **Glucose / CGM context view** — quick manual entry with **meal-context tags** (fasting / pre-meal / 1-h post / 2-h post / bedtime / overnight), mg/dL *or* mmol/L; optional **read-only CGM import** showing her **time-in-range** picture against an **educational pregnancy reference band (63–140 mg/dL, > 70% TIR)** she or her clinician can set. *Tracking/education aid, not a test interpreter, not a dose driver.*
2. **Meal / carb log** paired to readings — optional note/photo so she can *see her own patterns*. **No carb-ratio math, no meal grading, no scoring.**
3. **Insulin / medication record (educational)** — she records what she took *as her clinician prescribed* (name, time, user-entered) for her own pattern-tracking + export. **No dose suggestions, no bolus/carb calculator, no titration.**
4. **Dense extra-appointment & care-team tracker** — diabetes-antenatal clinic, dietitian, **eye (retinal) screening**, **renal test (ACR/creatinine)**, endocrinology, **growth scans**, fetal echo, NST/BPP; reminders; "questions to ask."
5. **HbA1c log** — user-entered values over time (preconception + pregnancy), shown against educational targets; descriptive trend, never a grade.
6. **Pregestational-diabetes education hub** — referenced, calm, anti-self-blame (see F), including a **preconception module**.
7. **Clinician-shareable export (PDF/CSV)** — glucose/CGM summary + meals + insulin + HbA1c + appointments; the thing her diabetes-antenatal team actually asks for.
8. **Red-flag safety layer (inherited + diabetes-tuned)** — persistent warning-signs; contextual red-flag boxes for **severe hypo**, **DKA warning signs (esp. T1)**, pre-eclampsia signs, reduced fetal movement.

**P1 — high value**
9. **Preconception mode (pre-pregnancy)** — for the planning window: HbA1c-toward-target education (not a gate), folic-acid & med-review education ("discuss changing/stopping meds with your clinician"), baseline eye/renal-test tracking, "getting ready" checklist. Bridges from a diabetes life-track or C-series TTC.
10. **Check/CGM reminders & hypo-safety card** — optional nudges at her chosen test times; a **hypo-preparedness** info card (recognizing lows, glucagon-access reminder as *education*), fully editable.
11. **Trend views** — readings/TIR over time by context; % in her own range (descriptive, never a grade).
12. **Kick counter / contraction timer (from D1, T3)** — unchanged.

**P2 — differentiators / later**
13. Culturally-adapted carb/meal example library (MENA + EN/FR/ES), dietitian-reviewed; Ramadan-with-insulin "discuss with clinician first."
14. Postpartum bridge card → **E4**: sharp insulin-drop / hypo-awareness, breastfeeding-and-lows, interpregnancy planning, ongoing lifelong care.
15. Gentle, moderated peer support / curated Q&A (privacy-safe, only if moderation guaranteed).
16. Deeper device integrations (pump/CGM/AID read-only display) — later, pending device/compliance review.

**Explicitly out of scope (compliance):** any **insulin/bolus dose calculator, carb-ratio/correction math, or titration** (mySugr-style); any **meal grading/scoring** (Glucose-Buddy-style); any "your reading/CGM trend is high/low — do X" instruction; any algorithm that *diagnoses* or judges "your control is good/bad"; any prediction of anomaly/macrosomia/outcome; any preconception "you may/may not conceive" gate. Glucose, CGM, insulin and meals are **user-recorded / read-only tracking data with educational context only.**

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL, dual-unit). Delivered as an additive pregestational-diabetes hub on the D1 library; always searchable. Spans preconception → pregnancy → postpartum.

- **"Planning a baby with diabetes" (preconception)** — why control *before* conception matters, HbA1c goals as education (not a gate), folic acid, reviewing meds with your clinician, baseline eye/kidney checks. Hopeful, non-shaming.
- **"You're pregnant with type 1 / type 2 diabetes" primer** — what changes now, that healthy babies are absolutely possible with support, and that this is manageable — explicitly anti-self-blame and anti-catastrophizing.
- **Understanding the tighter targets** — why pregnancy targets are lower than her usual; fasting/pre/post-meal band; A1C in pregnancy; *"your clinician sets your targets."* Dual-unit.
- **CGM & time-in-range, explained** — what TIR / 63–140 / >70% means, reading a CGM without spiraling, that alarms aren't a verdict on her worth; validating alarm fatigue. No interpretation of *her* trace.
- **Highs, lows & staying safe** — hypoglycaemia recognition (esp. first-trimester & T1), glucagon access as education, driving/overnight safety, DKA warning signs → seek care. **No dose fixes.**
- **Insulin, pumps & meds in pregnancy (educational)** — why oral agents may be switched to insulin, pump/CGM/AID in pregnancy and labour, needle/tech reassurance; safety questions to ask. No doses.
- **Eating with diabetes in pregnancy** — carbs, pairing, nausea/cravings, honest "overblown vs real," **culturally-adapted example meals** (rice, bread, dates, MENA staples) + Ramadan-with-insulin "discuss with your clinician first." No calorie/carb budget, no grading.
- **The extra appointments & scans** — diabetes-antenatal clinic, dietitian, **eye screening**, **kidney test**, growth scans, fetal echo, NST/BPP; what each is for; what to ask.
- **Diabetes and your baby / delivery** — honest, gentle: congenital-risk framing *paired with* "good control markedly lowers risk," macrosomia, why delivery may be planned earlier (~37–39 wk), neonatal blood-sugar checks/NICU possibility.
- **Warning-signs hub (inherited)** — CDC Hear Her list always reachable; pre-eclampsia awareness foregrounded (diabetes raises risk); "severe hypo / DKA signs / very high or very low readings → seek care now."
- **After birth: diabetes continues** — the **sharp insulin-need drop and postpartum hypo risk**, breastfeeding-and-lows, contraception/interpregnancy planning, ongoing lifelong care (bridges to E4). Explicitly contrasts with GDM ("this doesn't go away — and that's okay, here's what changes").
- **Emotional wellbeing & the diabetes-distress cycle** — normalizing guilt/hypervigilance/burnout; soft pointer to mood screening ("screening, discuss with clinician"); when to seek support.

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs & tools**
- **Glucose / CGM view** — manual value + unit + meal-context tag + optional note; optional **read-only CGM import** with a **time-in-range** picture vs an editable **educational reference band (63–140 mg/dL / 3.5–7.8 mmol/L, > 70% TIR)**. Copy: *"This is a tracking and education aid, not a medical test, diagnosis, or dosing tool. Targets shown are general education — your care team sets what's right for you. It can't tell you a reading or CGM trend is 'good' or 'bad,' and it never suggests insulin."* No scoring; at most a neutral "above/below your set range" marker for *her own* reference.
- **Meal / carb log** — paired to readings so she sees her own patterns; optional photo; **no carb-ratio math, no meal grade, no budget, no judgment.**
- **Insulin / medication record (educational)** — user records meds *as prescribed*; pattern-tracking + export only. Copy: *"Record only. Femio never recommends, calculates, or adjusts doses — follow your clinician."*
- **HbA1c log** — user-entered values over time (preconception + pregnancy) vs educational targets; descriptive, never a grade.
- **Trend view** — readings/TIR by context over time; descriptive "% in your set range." Framed as *"a picture to share with your care team,"* never a grade.
- **Appointment/care-team log** — diabetes-antenatal clinic, dietitian, **eye screening**, **renal test**, growth scans, fetal echo, NST/BPP, provider, notes, results (user-entered), reminders.
- **Export (PDF/CSV)** — glucose/CGM + meals + insulin + HbA1c + notes for appointments.
- **Kick counter / contraction timer (T3, inherited from D1)** — unchanged, same compliant framing.

**Alerts (all opt-in, calm, non-alarmist)**
- Check/CGM reminders at her chosen times (editable).
- Appointment/scan reminders (incl. eye-screening & renal-test prompts).
- Gestational-milestone + content nudges (inherited).
- Preconception: gentle "getting-ready" content nudges (never a "you can't conceive yet" gate).
- Postpartum: a gentle bridge card on **postpartum hypo risk / insulin-need drop** and ongoing care (→ E4).
- **No** predictive/diagnostic alerts. **No** "your sugars/CGM are dangerous" auto-verdicts. **No** insulin/dose/bolus prompts.

**Red-flag box pattern (reusable component, diabetes-tuned).**
> **⚠ Seek care now**
> Contact your maternity/diabetes care team or local emergency number right away if you have: a blood-sugar reading much higher or much lower than your care team told you to expect · shaking, sweating, confusion, or feeling faint (possible severe low) · a low you can't bring up · nausea/vomiting with high sugars, tummy pain, deep or fast breathing, or a fruity breath smell (possible DKA — especially with type 1) · a severe headache that won't go away or vision changes · severe swelling of your face/hands · pain in the upper right of your tummy · trouble breathing · heavy vaginal bleeding or fluid leaking · (after ~28 wk) your baby moving noticeably less than usual · thoughts of harming yourself.
> *You know your body best — if something feels wrong, get it checked. This app can't diagnose or treat, it can't tell you a glucose reading is safe or dangerous, and it never tells you how much insulin to take.*
> [Save my care-team/emergency contact] [Learn the warning signs]

Placement: persistent nav entry + auto-injected on the glucose/CGM screen (near "very high/low reading" and "hypo/DKA" guidance), pre-eclampsia/warning-sign content, and any symptom explainer with an associated danger sign.

---

## H. EMR fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1)**
- Identity/account, locale/language, **units (mg/dL vs mmol/L)**.
- DOB / age; height; pre-pregnancy weight & BMI.
- Menstrual history; LMP.
- Medical-history flags (**diabetes type 1 / type 2**, hypertension, thyroid, prior VTE, family history).
- Medications, allergies, supplements (incl. **folic acid**).
- Prior pregnancies/outcomes (gravida/para); prior loss / prior anomaly flags.
- Consent/privacy settings; emergency/care-team contact (optional).

**Persona-specific (pre-existing diabetes — layered over the constant core EMR, on top of D1's pregnancy fields; distinct from D3)**
- **Diabetes type** (T1 / T2) & **year of diagnosis** — the marker that routes to D4, not D3.
- **Diabetes-management modality** — MDI / **insulin pump** / **CGM** / **automated insulin delivery (AID/closed-loop)** / oral agents — user-recorded; drives *content emphasis* (e.g., pump-in-labour, CGM/TIR modules), never a clinical action.
- **Preconception status & baseline set** (if pre-pregnancy) — planning flag, preconception **HbA1c series**, baseline **eye-screening** and **renal (ACR/creatinine)** results (user-entered).
- **HbA1c series** — preconception + pregnancy, user-entered, vs educational targets (reference, not a rule).
- **Glucose readings series** — value, unit, meal-context tag (fasting/pre/1-h/2-h/bedtime/overnight), timestamp, note; user-entered.
- **CGM data (optional, read-only import)** — time-in-range / TAR / TBR summary; stored/displayed as her data, not app-interpreted.
- **Personal target band** — user- or clinician-set fasting/post-meal thresholds + TIR target (default = educational pregnancy band, editable). Reference, not enforcement.
- **Meal/carb log** — entries paired to readings; optional photo.
- **Insulin/medication record** — names + times, *user-recorded as prescribed*; **no dose logic, no calculator.**
- **Hypoglycaemia events** — user-logged lows / severe-low episodes (for her own pattern + care-team export), glucagon-access flag (education).
- **Diabetes-specific antenatal appointments** — diabetes clinic, dietitian, **eye screening**, **renal test**, endocrinology, **growth scans**, **fetal echo**, **NST/BPP** — dates/results (user-entered).
- **Delivery-planning notes** — planned earlier delivery discussion, pump/CGM-in-labour plan, mode-of-birth preferences (user-entered).
- **Postpartum diabetes fields** — postpartum insulin-need change note, breastfeeding-and-lows note, contraception/interpregnancy plan, ongoing-care handoff (→ E4). *(No resolving-OGTT field — that is D3.)*
- Inherited D1 fields (EDD/GA, BP-if-logged, kick/contraction sessions, weight series, etc.) all retained.

---

## I. Personalization rules (layered on the D1 pregnancy base; hidden-but-reachable)

**D4 does not re-onboard.** It activates *on top of* an existing D1 pregnancy context (or a pre-pregnancy diabetes/TTC context) when **pre-existing diabetes** is recorded — additive emphasis, nothing hidden or removed.

**Activation (wizard delta, short & editable/resettable — personalize, never restrict).**
1. Trigger: **diabetes type 1 / type 2 already flagged** in her record (carried from a diabetes life-track or C-series TTC), or she records "I have type 1 / type 2 diabetes" — often surfaced when she enters a preconception/TTC or pregnancy context.
2. Quick set-up: **units** (mg/dL / mmol/L); **management modality** (MDI / pump / CGM / AID / oral — editable); **check/CGM times** for reminders (editable); who (if anyone) she shares with (X2 partner).
3. Optional: enter clinician-given **target band + TIR target** (else default educational pregnancy band, clearly labeled editable); connect **read-only CGM import** if she wishes.

**Home configuration (phase- and GA-driven, inherited from D1, with pregestational layer on top).**
- **Preconception (pre-pregnancy):** "Planning a baby with diabetes" primer, HbA1c-toward-target education, folic-acid & med-review education, baseline eye/renal-test tracking, "getting ready" checklist foregrounded; **no conception gate**, purely supportive.
- **Early pregnancy (organogenesis):** anti-self-blame reassurance dialed up; glucose/CGM view + tighter-targets and hypo-safety content foregrounded; glucose log surfaced as a primary quick-action.
- **Steady state (T2):** glucose/CGM + TIR trend + meal log foregrounded; carb-education, HbA1c log, and the **dense appointment tracker (eye/renal/scans)** prominent; the D1 week-by-week card stays present.
- **Pump/CGM/AID recorded:** device-specific modules (pump-in-labour, CGM/TIR, alarm-fatigue) surfaced.
- **T3 (inherited):** kick counter + contraction timer + birth-prep surface as in D1, plus diabetes-delivery content (macrosomia, planned earlier delivery, neonatal sugar checks, pump/CGM-in-labour plan).
- **Post-delivery:** postpartum **hypo-risk / insulin-drop** and breastfeeding-and-lows cards appear; ongoing-care bridge (→ E4). Tools stay reachable (diabetes doesn't end).

**Hidden-but-reachable rule.** Nothing is locked. The full D1 pregnancy experience remains completely intact and foregrounded; diabetes tools are *added*, and every article/tool stays in the library and search regardless of persona/phase. She can collapse or de-emphasize the diabetes layer if she finds it heavy, without losing it.

**Continuity.** Her diabetes history (type, meds, devices, HbA1c), any pre-pregnancy/TTC record, her D1 pregnancy record (EDD/GA, appointments, weight, symptoms) and core history seed D4 automatically — no separate app, no re-entry, no re-onboarding across preconception → pregnancy → postpartum; a one-time *"your diabetes and pregnancy history is here, this just adds your pregnancy-diabetes tools, and it's all private"* note.

---

## J. Adaptation triggers (state transitions)

**INTO D4:**
- **From a pre-pregnancy diabetes life-track or C-series TTC (preconception path — distinctive to D4):** when a woman with **type 1/type 2 diabetes** flags planning/TTC, offer **preconception mode** (HbA1c/folic-acid/med-review/eye-renal education + tracking) *before* conception — the window competitors ignore. Education + "discuss with your clinician," never a conception gate, never a diagnosis.
- **From D1 (already pregnant):** if **pre-existing diabetes (T1/T2) is in her record** or she records it, offer to add the pregestational-diabetes layer to her existing pregnancy mode; carry all D1 + diabetes context; **privacy step:** reassure that her diabetes + pregnancy status is never sold, never employer/insurer-visible, and confirm partner-sharing scope. Additive emphasis — **do not diagnose**; frame as *"you've told us you have type 1/type 2 diabetes — here's education, tracking and when to seek care."*
- **Distinct from D3 (GDM):** D4 is keyed to **diabetes recorded *before* pregnancy**; an **abnormal glucose screen with no prior diabetes** routes to **D3**, not D4. The resolver must not confuse them (different targets, different postpartum path, different risk framing).

**Within pregnancy (additive blends, never restriction, never diagnosis):**
- **Pre-eclampsia signs or elevated BP logged** → blend **D6** (gestational HTN/pre-eclampsia) awareness; foreground warning-signs (diabetes raises this risk). Education + "seek care," never a verdict.
- **Severe hypo / DKA warning signs logged** → foreground hypo/DKA safety content + red-flag routing (still D4, no dosing).
- **Retinopathy/nephropathy result recorded** → surface the relevant eye/kidney explainer (education; not interpretation).
- **Growth-scan / macrosomia discussion or large-baby concern** → delivery-planning content emphasis.
- **Repeated low-mood logs / positive mood screen** → **D11** antenatal anxiety/depression emphasis (screening framing) — the diabetes-distress burden makes this common; watch gently.
- All D1 content stays fully available; the resolver blends emphasis.

**OUT of pregnancy (does NOT resolve — key D3 contrast):**
- **Delivery/birth logged** → transition to **Postpartum (E1)**, and because she has **lifelong diabetes**, **carry forward to E4 (ongoing diabetes care)**: postpartum **insulin-need drop / hypo-risk** education, **breastfeeding-and-lows**, contraception/interpregnancy-planning, and continuous diabetes management — **not** a resolving one-off OGTT (that's D3→E4-GDM). **E2** if breastfeeding. Diabetes tools stay fully active.
- **Pre-eclampsia escalation co-occurring at/after delivery** → carry D6 awareness into E-series follow-up (BP monitoring education), never diagnosis.
- **Pregnancy loss / stillbirth logged** → immediate, dignified transition to **loss/grief (E6)**: stop all pregnancy *and* diabetes-pregnancy reminders instantly (check/CGM nudges, appointment prompts), offer grief resources, no re-prompting; her core diabetes tracking (non-pregnancy) remains available if she wants it, quietly.
- **Reset/withdraw:** she can drop the diabetes-pregnancy layer or exit pregnancy mode anytime; data retained per her privacy settings, nothing forced.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention claims, no medical-device functionality. The glucose/CGM view, meal log, insulin record and HbA1c log are **tracking/education aids for user-entered or read-only imported data**, explicitly *not* tests, not diagnostic tools, and not able to judge a reading/CGM trend "safe/dangerous" or "good/bad" — copy must state this (avoids medical-device classification per femio-compliance-privacy skill).
- **No dosing / no calculators / no titration (the hard line vs mySugr):** categorically **no insulin/bolus calculator, no carb-ratio or correction math, no dose recommendation, no "start/increase/adjust X."** Insulin/med content is general, cited, and defers every decision to the clinician.
- **No meal grading (the line vs Glucose Buddy "Meal IQ"):** meals are logged as user data with no score/grade/AI verdict.
- **CGM/TIR is display + education, not interpretation:** any imported CGM/TIR is her own data shown against an *educational, clinician-confirmed* reference band; the app never renders a verdict, prediction, or dose from it.
- **Targets are educational reference bands, clinician-confirmed:** dual-unit, labeled editable, never a pass/fail score; app never diagnoses or gates from user numbers; **no preconception "you may/may not conceive" gate.**
- **Screeners = "screening, discuss with clinician":** eye screening, renal test, any mood screen framed as screening, never verdicts.
- **Red-flag routing:** severe hypo, DKA warning signs, very-high/low readings, pre-eclampsia signs, reduced fetal movement use "seek care now" framing pointing to her care team / local emergency number; never reassures ("your baby/sugar is fine"), never alarms with a diagnosis, **never** answers with a dose.
- **Anti-self-blame, non-judgmental tone (sensitive topic):** given documented guilt, shame, hypervigilance, alarm-fatigue and the diabetes-distress cycle, all copy is non-shaming; no "you failed," no graded gamification of readings/CGM/meals; food logging never enforces a budget; the honest congenital-risk message is always paired with the true "good control markedly lowers risk / healthy babies are possible" reassurance.
- **Privacy-by-design (GDPR/PDPL, health data):** pre-existing-diabetes status is sensitive health data layered on sensitive pregnancy data (and, in preconception, fertility intent) — minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility**; any CGM/device import is opt-in, read-only, and privacy-scoped. Partner sharing opt-in and granular. Loss/withdrawal → immediate suppression of all pregnancy + diabetes-pregnancy reminders and honored deletion.
- **Content provenance:** every medical claim medically reviewed + cited to Tier-1 (CDC/NIH/MedlinePlus/NHS) / Tier-2 (ACOG/ADA/NICE); review dates surfaced; no clickbait, no sponsored content interleaved with medical guidance.
- **i18n/RTL + cultural food literacy:** all safety/red-flag copy human-reviewed in AR/EN/FR/ES (not machine-only) given clinical stakes (hypo/DKA especially); carb/meal examples culturally adapted (MENA staples, **Ramadan-with-insulin "discuss with clinician first"**).
- **Open items:** resolve **[NEEDS SOURCE]** citations (ACOG PB 201 permalink; NICE NG3 permalink; TIRp consensus primary statement; region mmol/L targets; Ramadan-with-insulin-in-pregnancy MENA guidance; CDC/MedlinePlus consumer pre-existing-diabetes page) before content freeze; localize warning-signs + emergency numbers per region.

---

## Sources

- [ADA — Management of Diabetes in Pregnancy: Standards of Care in Diabetes—2026 (§15)](https://diabetesjournals.org/care/article/49/Supplement_1/S321/163918/15-Management-of-Diabetes-in-Pregnancy-Standards)
- [ADA — Management of Diabetes in Pregnancy: Standards of Care in Diabetes—2024 (§15, PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10725801/)
- [ADA — Section 15: Management of Diabetes in Pregnancy (Clinical Diabetes)](https://diabetesjournals.org/clinical/article/43/2/223/158033/Section-15-Management-of-Diabetes-in-Pregnancy)
- [ACOG — Pregestational Diabetes Mellitus (Practice Bulletin No. 201)](https://www.acog.org/clinical/clinical-guidance/practice-bulletin/articles/2018/12/pregestational-diabetes-mellitus)
- [ACOG Practice Bulletin No. 201 — full text (PDF)](https://tjodistanbul.org/uploads/pregestational-diabetes-mell-number-201.pdf)
- [The ObG Project — Updated ACOG Guidance on Perinatal Management of Pregestational Diabetes](https://www.obgproject.com/2023/01/30/updated-acog-guidance-on-perinatal-management-of-pregestational-diabetes/)
- [NICE NG3 — Diabetes in Pregnancy: Management from Preconception to the Postnatal Period (PDF)](https://www.nice.org.uk/guidance/ng3/resources/diabetes-in-pregnancy-management-from-preconception-to-the-postnatal-period-pdf-51038446021)
- [NICE NG3 — NCBI Bookshelf full guideline](https://www.ncbi.nlm.nih.gov/books/NBK555331/)
- [CDC MMWR — Prevalence and Changes in Preexisting Diabetes and Gestational Diabetes Among Women Who Had a Live Birth](https://www.cdc.gov/mmwr/volumes/67/wr/mm6743a2.htm)
- [NIH/NCBI Endotext — Pregestational Diabetes Mellitus](https://www.ncbi.nlm.nih.gov/books/NBK572754/)
- [NIH/NCBI StatPearls — Diabetic Embryopathy](https://www.ncbi.nlm.nih.gov/books/NBK558974/)
- [PMC — Periconception Glycemic Control and Congenital Anomalies in Women with Pregestational Diabetes](https://pmc.ncbi.nlm.nih.gov/articles/PMC8070859/)
- [PubMed — Preconception Care and the Risk of Congenital Anomalies in Offspring of Women with Diabetes (meta-analysis)](https://pubmed.ncbi.nlm.nih.gov/11493721/)
- [PMC — Diabetes During Pregnancy: Surveillance, Preconception Care, and Postpartum Care](https://pmc.ncbi.nlm.nih.gov/articles/PMC6082119/)
- [PMC — Management of Type 1 Diabetes in Pregnancy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4919374/)
- [Diabetologia (Battelino/Murphy) — CGM Targets in Type 1 Diabetes Pregnancy: Every 5% Time in Range Matters](https://pmc.ncbi.nlm.nih.gov/articles/PMC6560014/)
- [ADA Diabetes Spectrum — Time in Range in Pregnancy: Is There a Role?](https://pmc.ncbi.nlm.nih.gov/articles/PMC8178723/)
- [Diabetes Care — CGM Metrics and Birth Weight in Type 1 Diabetes Pregnancy](https://diabetesjournals.org/care/article/45/8/1724/147079/Continuous-Glucose-Monitoring-Metrics-and-Birth)
- [BMC Pregnancy and Childbirth — Perceptions of Diabetes Distress During Pregnancy in Women with Type 1 and Type 2 Diabetes (qualitative)](https://bmcpregnancychildbirth.biomedcentral.com/articles/10.1186/s12884-024-06370-w)
- [JMIR Diabetes — Exploring Psychosocial Burdens of Diabetes in Pregnancy and the Feasibility of Technology-Based Support (qualitative)](https://diabetes.jmir.org/2025/1/e53854)
- [Springer/BMC — Psychosocial Issues of Women with Type 1 Diabetes Transitioning to Motherhood (literature review)](https://link.springer.com/article/10.1186/1471-2393-13-218)
- [Merck Manual (Professional) — Diabetes Mellitus in Pregnancy](https://www.merckmanuals.com/professional/gynecology-and-obstetrics/pregnancy-complicated-by-disease/diabetes-mellitus-in-pregnancy)
- [mySugr — Diabetes App (bolus calculator — out-of-scope contrast)](https://www.mysugr.com/en/diabetes-app)
- [Gluroo — mySugr vs Glucose Buddy full comparison (Meal IQ grading — out-of-scope contrast)](https://gluroo.com/blog/diabetes-101/mysugr-vs-glucose-buddy-full-comparison/)
- [DiaTribe — Free Apps That Sync With Blood Glucose Meters (Sugarmate/CGM landscape)](https://diatribe.org/diabetes-technology/4-free-apps-sync-blood-glucose-meters)

*[NEEDS SOURCE]* canonical ACOG PB 201 acog.org permalink + NICE NG3 nice.org.uk permalink (verify current versions); TIRp international consensus primary statement (Diabetes Care 2019, Battelino et al.) permalink; region-specific mmol/L target table + Ramadan-with-insulin-in-pregnancy guidance for MENA localization; CDC/MedlinePlus consumer-level "pregnancy and pre-existing diabetes" page for Tier-1 grade-6–8 grounding.
