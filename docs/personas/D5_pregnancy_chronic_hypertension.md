# D5 — Pregnancy with Pre-existing Chronic Hypertension (Diagnosed before pregnancy or <20 weeks)

> Femio persona spec. Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent.** Chronic hypertension in pregnancy raises the risk of **superimposed pre-eclampsia** (red-flag / medical-emergency territory) — warning signs get prominent, calm "seek care now" framing, but the app **NEVER diagnoses**. **BP and medication content is educational, never prescriptive** (some antihypertensives are contraindicated in pregnancy — explained as general education, never as an instruction to start/stop/switch). Screeners = *"screening — discuss with your clinician."*
> Persona code: **D5** · Cohort: Pregnancy (D) · Layered on **D1** (uncomplicated pregnancy spine) · Coordinates tightly with **D6** (pre-eclampsia / gestational HTN) · Last research pass: 2026-07-17
> Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Rania," 37 |
| **Stage** | Pregnant, with **chronic (pre-existing) hypertension** — diagnosed *before* this pregnancy or *before 20 weeks*. Either (a) already **on an antihypertensive** entering pregnancy (some agents need review/switching — educational framing only), (b) **diagnosed early** this pregnancy and starting/adjusting therapy, or (c) **diet/lifestyle-managed** and now under closer surveillance. High-risk flag can be set from booking. |
| **Relationship / support** | Partnered; wants partner informed and calm (X2 partner mode) — a possible early delivery or growth concern affects the whole household. |
| **Goal (top JTBD)** | *"I've had high blood pressure for years — help me carry this pregnancy safely. Let me log my BP and medicines, tell me in plain language which pills are safe and which aren't (without telling me what to take), warn me clearly about the pre-eclampsia signs I'm now more likely to get, keep my extra scans and appointments straight — and stay calm and honest, never scare me and never pretend to be my doctor."* |
| **Health literacy** | Moderate–high; often **already familiar with BP monitoring** from her non-pregnant life (owns a cuff, knows her numbers), but **new to the pregnancy-specific rules** — different targets, contraindicated drugs, the superimposed-pre-eclampsia overlay, extra growth scans. |
| **Tech context** | Web-first, phone-heavy; opens the app **multiple times daily** (each home BP check is an app moment). Likely already owns a home BP cuff; may be on a home-BP / telemonitoring pathway; juggles an obstetric team plus (sometimes) an internist/obstetric-medicine specialist. |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. MENA relevance high (chronic HTN prevalence rising with maternal age and BMI; uneven access makes the "seek care now" routing and medication-safety literacy matter more). |
| **Emotional state** | **Sustained, managed anxiety** — less acute "emergency panic" than D6, more a **chronic vigilance** ("I've lived with this for years, but pregnancy changes the stakes"). Specific fears: an unsafe medicine harming the baby, **superimposed pre-eclampsia** creeping in, the baby being **small (growth restriction)**, and an **early delivery**. Monitoring is familiar but the pregnancy reframes every reading. |
| **What she is NOT** | Not a *de novo* gestational-hypertension / pre-eclampsia persona (that's **D6** — hers began *before* 20 weeks); not a diabetic-pregnancy persona (D3); not a general low-risk D1 (though she keeps every D1 feature). She **borrows D6's red-flag layer wholesale** for the superimposed-pre-eclampsia risk (see §J). |
| **Success = she leaves us when…** | She delivers safely → **postpartum (E1)** with an **ongoing-BP-follow-up (E4)** tail (chronic HTN persists — and pre-eclampsia can onset/persist postpartum; her medicines and BP need review after birth, incl. if breastfeeding), and she felt watched-over, medication-literate, informed, and safely routed to care every time it mattered — never diagnosed, never falsely reassured, never scared by the app itself. |

**Persona thesis.** D5 is **D1 plus a chronic-condition management overlay plus D6's superimposed-pre-eclampsia safety layer**. She keeps the full week-by-week pregnancy spine, but her home is reorganized around a **BP + medication log**, **medication-safety education** (what's generally considered safe vs avoided in pregnancy — never an instruction), an **extra-monitoring / growth-scan tracker**, and a **relentlessly clear red-flag layer** for the pre-eclampsia she is now materially more likely to develop. The differentiator vs D6: D5's defining anxiety is **"are my medicines safe?"** and the **chronic, pre-existing** framing; the shared spine is **BP logging + superimposed-pre-eclampsia red-flags**, kept consistent with D6 by design. This is a persona where Femio's guardrail is load-bearing twice over: *never interpret a BP reading*, and *never tell her to start/stop/switch a medication.*

---

## B. Needs & questions (voice-of-user)

Mined from r/hypertension, r/BabyBumps, r/pregnant, chronic-HTN + pregnancy threads, ACOG/AAFP patient FAQs, and pregnancy/BP-app reviews. Phrasing is representative/composite (community norms; not quoting individuals). The **medication-safety worry** and **"will I get pre-eclampsia on top of this?"** dominate.

**Medication safety — the defining D5 worry**
- *"I've been on lisinopril/an ARB for years — is it safe now I'm pregnant? My heart sank when I read it's not."* (→ never advise; general cited info + "your clinician manages this, don't stop on your own")
- *"They switched me to labetalol/nifedipine/methyldopa — what should I know about it?"*
- *"Is it dangerous to just stop my BP pill? I'm scared of both the pill AND stopping it."*
- *"Which blood-pressure medicines are okay in pregnancy and which ones do people get taken off?"*
- *"I keep forgetting my meds now that the schedule changed — I need reminders."*

**"Will chronic HTN turn into pre-eclampsia?" (the superimposed-PE fear — shared with D6)**
- *"I already have high blood pressure — how do I even tell if pre-eclampsia is starting on top of it?"*
- *"What warning signs should I watch for, and what number means 'go in'?"*
- *"My BP has always been high — how will anyone notice it getting worse?"*

**Blood-pressure logging & the pregnancy targets**
- *"My target used to be one thing — is it different now I'm pregnant?"* (wants the 140/90 and 135/85 context, plainly, as education)
- *"How do I take my BP properly at home so the number is real?"* (cuff position, rest, arm, white-coat effect)
- *"Can I see my readings as a graph to show my OB and my regular doctor?"* (she often has *two* teams)

**Growth restriction & extra scans**
- *"They said the baby might be small and I need extra growth scans — why?"*
- *"What are all these extra appointments and Doppler/growth scans for?"*
- *"How do I keep two sets of appointments (OB + my hypertension doctor) straight?"*

**Aspirin**
- *"Why was I told to take low-dose aspirin, and until when?"* (chronic HTN is itself a high-risk factor)

**The chronic-vigilance burden**
- *"I've monitored my BP for years, but now every reading feels like it's about the baby, not just me."*
- *"I'm managing a chronic condition AND a pregnancy — it's a lot."*

**Postpartum tail (under-served)**
- *"After birth do I go back to my old BP medicine? Is it safe while breastfeeding?"*
- *"My BP is still high weeks after delivery — I have chronic HTN, so how is this followed up?"*

**Anti-needs / trust-breakers (churn + safety risk):**
- Any app that **interprets** a reading ("your BP is fine / dangerous") — that's diagnosis and could kill.
- Any app that **tells her to start/stop/switch a medication** or **doses** for her — prescribing, out of scope, dangerous.
- **False reassurance** ("don't worry, that's normal") on a red-flag symptom.
- **Scare-content / doom-scrolling** — especially frightening her *off* a medicine her clinician wants her on.
- Buried or slow "when to seek care" info.
- Privacy dread — pregnancy + a chronic diagnosis is highly sensitive; she fears employer/insurer visibility and data sale.
- Reminders that keep firing after an early delivery or a loss.

---

## C. Competitor teardown

**Key insight for Femio:** the market splits into two camps that **do not meet** — consumer **pregnancy trackers** (broad, ad-heavy, no real HTN/medication support and correctly *cautious* about it) and **generic BP / hypertension apps** (medication reminders + BP logs, but **not pregnancy-aware** — wrong targets, no contraindicated-drug education, no superimposed-pre-eclampsia red-flags). **No trustworthy, privacy-first, multilingual consumer app offers calm chronic-HTN-in-pregnancy *education* (incl. which drug classes are generally safe vs avoided) + a personal *BP/medication log* + an unmissable *pre-eclampsia red-flag layer* without either overreaching into triage/prescribing or requiring a clinical enrolment.** That integrated gap — *educational, non-diagnostic, non-prescriptive management companion for the woman managing a chronic condition through pregnancy* — is D5's whitespace. **Safety caution:** the moment an app *interprets* readings or *advises on medication* it enters medical-device / prescribing territory; Femio deliberately does **not** cross either line.

| App / tool | Category | BP logging | Med reminders + safety education | Pregnancy-aware targets | Superimposed-PE red-flags | Interprets readings / advises meds? | Privacy / positioning |
|---|---|---|---|---|---|---|---|
| **What to Expect** | Consumer pregnancy | No dedicated BP log | No | No | Generic warning-sign articles | No | Reported data sale to 3rd parties for ad targeting |
| **BabyCenter** | Consumer pregnancy | No | No | No | Generic | No | Sells data; named in 2024 US Senate data-broker inquiry |
| **Pregnancy+ (Philips)** | Consumer pregnancy | No | No | No | Generic | No | Reported ad-sharing (Facebook/Google) |
| **Ovia Pregnancy** | Consumer pregnancy | Light health logging | Light | No | Some | Borderline (nudges) | Labcorp-owned; **employer/health-plan versions** raise chronic-condition-visibility concern — acutely bad here |
| **SmartBP / generic BP apps** | Consumer cardio | **Yes — core** | **Reminders yes** | **No — non-pregnancy targets** | **None** | Some interpret/zone-color (risky) | Not pregnancy-aware; contraindicated-drug + PE warning signs absent; camera/"selfie BP" apps are unvalidated & dangerous |
| **MyTherapy / med-adherence apps** | Consumer medication | Some | **Strong reminders + adherence** | No | No | No (but no pregnancy-safety context) | General; not pregnancy- or PE-aware |
| **HaMpton** (NHS/King's) | **Clinical** home-BP for HTN in pregnancy | **Yes — core** | Pathway meds | **Yes** | Trigger-question set | **Yes — clinician-read, alerts to attend** | Real home BP+urine monitoring, doctor/midwife read remotely. **Gated: hospital enrolment + provided cuff/sticks; a regulated clinical service, not a consumer app** |

**What each camp gets wrong for D5:**
- **Consumer pregnancy apps:** no first-class BP or medication log, no medication-safety education, no HTN-specific red-flag layer, ad clutter, privacy exposure — and (rightly) no triage/prescribing, but they leave her with *nothing structured* for her actual condition.
- **Generic BP / med apps:** log BP and remind her about pills, but with **non-pregnancy targets, zone-coloring that implies a verdict, no notion of contraindicated drugs, and zero pre-eclampsia awareness** — actively unsafe framing for a pregnant woman.
- **Clinical tools (HaMpton etc.):** genuinely useful and *safe by design*, but **locked behind a hospital/device/prescription**, single-pathway, no lifespan continuity, not consumer-ownable, English-centric, and they *do* interpret/alert — which is exactly why they must be a regulated clinical service, not a general app.

**Femio's differentiated position for D5 (whitespace, held safely):**
1. **A self-owned BP + medication log** she controls — graphs she can **export/show *both* her OB and her hypertension doctor** — with **zero interpretation** (no "normal/high" verdict) and **zero prescribing** (no dosing, no start/stop/switch advice).
2. **Honest, referenced *medication-safety education*** — which antihypertensive *classes* are generally considered compatible with pregnancy (labetalol, nifedipine, methyldopa) vs generally avoided (ACE inhibitors, ARBs) — framed strictly as *general information*, always "your clinician decides; never stop on your own."
3. **D6's red-flag layer, shared verbatim-in-spirit** — CDC/NHS/ACOG pre-eclampsia warning signs, "seek care now," saved maternity/emergency + regular-doctor contacts, one tap — never buried, never alarmist. Consistency with D6 is a design requirement.
4. **Extra-monitoring & growth-scan tracker** — the added scans/appointments chronic HTN brings, in one place.
5. **Privacy-by-design** — no data sale, no ad-SDKs, **no employer/insurer visibility** (decisive given a *chronic* diagnosis + pregnancy).
6. **One account, full continuity** — layered on D1; carries cleanly into **postpartum + ongoing BP follow-up (E4)**, including medicine review while breastfeeding and the persisting chronic condition.

---

## D. Clinical grounding (cited)

> All figures below are **patient education, not medical advice**. Femio content is medically reviewed and cited to primary sources. Femio **does not diagnose, treat, or prevent**, and **never advises on medication**; it educates and helps her track. Thresholds/targets are shown so she understands *what her team is aiming for* and *when to seek care*, **never** so the app can label a reading or tell her what to take.

**What chronic hypertension in pregnancy is (educational definition).**
- **Chronic (pre-existing) hypertension** = high blood pressure diagnosed **before pregnancy or before 20 weeks' gestation** (as opposed to *gestational* hypertension, which is new *after* 20 weeks → D6). It affects **up to ~1–1.5%** of pregnancies and is rising with maternal age and BMI. [ACOG/AAFP Practice Bulletin 203; AJOG]

**Superimposed pre-eclampsia — the central shared risk with D6 (educational).**
- Pre-eclampsia developing *on top of* chronic hypertension ("superimposed") occurs in roughly **20%–50%** of pregnancies complicated by chronic HTN — far higher than the general-population risk. It is associated with **earlier delivery** (mean ~33.9 weeks in one series), **~40–50% risk of fetal growth restriction**, and higher maternal/perinatal risk than de novo pre-eclampsia. → This is *why* D5 inherits D6's red-flag layer and warning-sign vigilance. [AJOG "Chronic hypertension and superimposed preeclampsia: screening and diagnosis"; Frontiers Cardiovascular Medicine 2025]

**Blood-pressure targets & thresholds (shown as *education* — the app never applies them to her reading).**
- **CHAP trial (NEJM 2022)** → **ACOG 2022 guidance:** treat mild chronic hypertension in pregnancy to a threshold of **140/90 mmHg** (initiate/titrate therapy at ≥140/90), rather than waiting for severe range — this improved the composite of superimposed severe pre-eclampsia, indicated preterm birth <35 wks, abruption, and fetal/neonatal death, without increasing small-for-gestational-age babies. [ACOG CHAP Practice Advisory 2022; NEJM CHAP; SMFM statement]
- **NICE NG133** target when on treatment: aim for **≤135/85 mmHg**. [NICE NG133]
- **Severe-range BP: ≥160 systolic or ≥110 diastolic** — an **urgent, seek-care-now** threshold (consistent with D6). [ACOG; NHS; MedlinePlus]
- App framing: *"These are the numbers clinicians aim for and act on. If your reading is at or above 160/110, or you have any warning sign, contact your maternity unit or emergency number now. Femio can't tell you what your reading means — your clinician does."*

**Medications (educational, never prescriptive — the D5-defining module).**
- **Generally considered compatible with pregnancy:** **labetalol, extended-release nifedipine, and methyldopa** are the commonly used first-line agents (methyldopa long-established but less potent / more side effects). [ACOG PB 203; NICE NG133; PMC pharmacokinetics review]
- **Generally avoided / contraindicated in pregnancy:** **ACE inhibitors and ARBs** (e.g., lisinopril, enalapril, losartan) are **contraindicated**; if a woman was well-controlled on one pre-pregnancy she is usually reviewed and switched by her clinician. Thiazide diuretics are used cautiously/secondarily. [ACOG PB 203; AAFP; GPnotebook]
- **Critical framing:** Femio explains *what a class is and how it's generally regarded in pregnancy*, and **always** defers starting/stopping/switching and all dosing to the clinician. Copy anchor: *"Some blood-pressure medicines are usually changed in pregnancy and some are usually continued — but never stop or change a medicine on your own. Your clinician decides what's right for you and your baby."* **Never** a dosing calculator; **never** "you should switch." **Bed rest is not recommended** as treatment. [ACOG; NICE]

**Low-dose aspirin prophylaxis (educational context only — never a Femio instruction to take it).**
- Chronic hypertension is itself a **high-risk factor** for pre-eclampsia, so low-dose aspirin prophylaxis is commonly advised. **USPSTF (Grade B):** low-dose **81 mg/day after 12 weeks** for high risk. **ACOG/SMFM:** initiate **12–28 weeks (optimally before 16), continue until delivery**. **NICE:** **150 mg at night from 12 weeks**. [USPSTF; ACOG/SMFM Practice Advisory 2021; NICE NG133] → *"Some people at higher risk — including many with chronic high blood pressure — are advised by their clinician to take low-dose aspirin. Whether it's right for you, the dose, and timing are decisions only your clinician makes."*

**Home BP monitoring (guidance context — supports self-tracking, not self-diagnosis).**
- NICE recognizes home/self BP monitoring as an option in diagnosing and managing hypertension, with **increased BP-check frequency** for those at higher risk of pre-eclampsia; chronic-HTN pregnancies are typically seen by an obstetrician (± obstetric-medicine/MFM specialist) with home readings between visits. Evidence on home BP in pregnancy is **feasible but without consensus home diagnostic thresholds** — reinforcing that Femio logs and charts but **never sets a home cutoff or verdict**. [NICE NG133; PMC systematic reviews]
- Good-technique education (rested, seated, back supported, arm at heart level, correct cuff, repeat; beware "selfie/camera BP" apps that are unvalidated) improves reading quality — a legitimate, in-scope *how-to*. [general BP-technique guidance — *[NEEDS SOURCE: pin AHA / British & Irish Hypertension Society home-BP technique permalink]*]

**Fetal growth surveillance (educational).** Because chronic HTN raises the risk of **fetal growth restriction**, **third-trimester (and often serial) ultrasound growth scans** are commonly recommended, sometimes with Doppler and increased antenatal fetal surveillance. Frame supportively as "extra check-ups your team arranges," never as prediction. [ACOG PB 203; AJOG; NICE NG133]

**Warning signs → seek care now (SHARED WITH D6 — keep identical in spirit).** Severe/persistent **headache that won't go away**; **vision changes** (blurring, spots, light sensitivity); **pain in the upper-right abdomen / under the ribs**; **sudden swelling** of face/hands; **shortness of breath**; new nausea/vomiting late in pregnancy; **decreased fetal movement**; and any **seizure** = emergency. [CDC "Hear Her"; NHS; MedlinePlus; Preeclampsia Foundation; Mayo/Cleveland Clinic] → *"You know your body best — if something feels off, get checked. This app can't diagnose."*

**Early / preterm delivery context (calm, factual).** Superimposed pre-eclampsia or worsening control can lead to **medically-indicated (iatrogenic) preterm birth**; timing is individualized by the team. Frame supportively, never as a countdown or prediction. [NICE NG133; ACOG; AJOG]

**Postpartum (critical, under-served).** Chronic HTN **persists after birth**, and pre-eclampsia can **onset or persist postpartum** (most within 48h–7 days, up to ~6 weeks). Antihypertensive medicines are often **reviewed/re-adjusted postpartum**, including for **breastfeeding compatibility**; BP monitoring and the warning-sign layer must **continue postpartum**. [ACOG/AJOG; Mayo; Cleveland Clinic] → seeds the **E4 ongoing-BP-follow-up** tail (§J).

**Emotional dimension (design-relevant, cited).** Anxiety and depression are elevated in hypertensive disorders of pregnancy, with a documented bidirectional link between anxiety and BP; there is a real chronic self-management/monitoring burden. Tone must be **calming and validating**, never alarmist (and never frighten her *off* a prescribed medicine). [Anxiety & hypertensive disorders of pregnancy review, PMC 2024/25; Frontiers 2025]

*[NEEDS SOURCE]* flags to resolve before content freeze: exact **ACOG Practice Bulletin 203 (Chronic Hypertension in Pregnancy)** permalink; **ACOG CHAP Practice Advisory (2022)** permalink; **USPSTF** aspirin recommendation primary permalink; **AHA/BIHS** home-BP technique permalink; region-localized emergency numbers and MENA-specific HTN-in-pregnancy guidance.

---

## E. Feature set (prioritized)

> **All of D1's feature set is inherited and stays fully available** (week-by-week home, referenced library, kick counter, weight guidance, etc.). D5 *adds and re-prioritizes* a chronic-HTN management + superimposed-pre-eclampsia safety overlay, **sharing the BP log and red-flag layer with D6.**

**P0 — must-have (the D5 overlay):**
1. **Blood-pressure log** — quick entry (systolic/diastolic/pulse, time, arm, optional "rested / white-coat context"), **trend chart over time**, **export (PDF) for clinician(s)** (OB + hypertension doctor). **Zero interpretation** — no color-coded "normal/high," no verdict. Educational target/threshold reference available *as content*, never applied to her number. (Shared component with D6; see §G, §K.)
2. **Medication log + medication-safety education** — list her clinician-managed antihypertensives (name/time), **reminders**, adherence log; **"what this class is / how it's generally regarded in pregnancy"** cards (safe-vs-avoided *education*). **No dosing, no start/stop/switch advice.** The D5-defining feature.
3. **Prominent, persistent red-flag / "seek care now" layer for superimposed pre-eclampsia** — the **shared D6 component**; always one tap from home; saved **maternity-unit + emergency + regular-doctor contacts**; localized emergency guidance.
4. **Symptom log with red-flag awareness** — headache, vision changes, upper-abdominal/rib pain, swelling, shortness of breath, reduced fetal movement — each logged PE warning-sign symptom **surfaces the "seek care now" box**, never a reassurance.
5. **Extra-monitoring & growth-scan / appointment tracker** — the added growth scans, Doppler, PLGF/bloods, urine dips, and *two* care teams; log results as **her own notes** (app never interprets); reminders; "questions to ask."
6. **Calm, cited HTN-in-pregnancy education hub** (see §F) — foregrounded on the D5 home.

**P1 — high value:**
7. **Home-BP technique guide** — how to get a real reading; warns against unvalidated camera/"selfie BP" apps (in-scope how-to).
8. **Aspirin awareness card + optional reminder** — educational context (chronic HTN as a high-risk factor), "your clinician decides."
9. **Partner/shared view (X2)** — partner sees the red-flag guidance + (opt-in) BP/med summary.
10. **Fetal-movement / kick awareness** foregrounded earlier (growth-restriction + PE relevance).
11. **Log export bundle** (BP + meds + symptoms + appointments) as a PDF she hands to *either* team.

**P2 — later / differentiators:**
12. **Postpartum-BP-follow-up mode** (the E4 tail) — keeps BP + medication logging + red-flag layer live after birth, incl. breastfeeding-medicine education and the persisting chronic condition.
13. Optional device/wearable BP import (only stored raw; still never interpreted).
14. Gentle, privacy-safe curated Q&A (only if moderation quality is guaranteed).

**Explicitly OUT of scope for D5 (guardrail):**
- **Any interpretation, triage, or classification of a BP reading or symptom** ("normal/high/dangerous," "you have/likely have pre-eclampsia," "go to hospital / stay home"). **Never.**
- **Any medication advice** — starting, stopping, switching, or **dosing** — or any **dosing calculator**. Medication-safety content is *general class education only*.
- Any **risk-score verdict** presented as a conclusion (screening framing only).
- False reassurance on any red-flag symptom; any content that frightens her off a clinician-prescribed medicine.

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Every card cites Tier-1/Tier-2 sources and carries "not medical advice / discuss with your clinician." Tone: **calm, honest, non-alarmist.** Pre-eclampsia modules are **shared with D6** — keep identical in spirit.

- **"Chronic high blood pressure in pregnancy — what it means"** — plain-language definition (diagnosed before 20 weeks), that it's monitored closely, that clinicians manage it.
- **"Your blood-pressure medicines in pregnancy"** *(D5-defining)* — general, non-dosing explainer: which classes are usually continued (labetalol, nifedipine, methyldopa) vs usually changed (ACE inhibitors, ARBs); **"never stop or change on your own — your clinician decides."**
- **"Understanding your blood-pressure numbers & targets"** — what 140/90, 135/85, and 160/110 mean *as clinical reference points*; "these are for context, not for you to diagnose yourself."
- **"Taking your blood pressure at home properly"** — technique, white-coat effect; **avoid unvalidated camera/selfie-BP apps.**
- **"Pre-eclampsia on top of high blood pressure (superimposed)"** *(shared w/ D6)* — why chronic HTN raises the risk, and how the team watches for it.
- **"Warning signs — when to seek care now"** *(shared w/ D6)* — the CDC/NHS/ACOG list; the anchor red-flag module.
- **"HELLP syndrome — the signs to know"** *(shared w/ D6)* — upper-right pain, nausea, feeling very unwell; seek care.
- **"Low-dose aspirin, explained"** *(shared w/ D6)* — why higher-risk people (incl. chronic HTN) may be advised to take it; "your clinician decides."
- **"Growth scans & extra check-ups"** — why chronic HTN can mean a smaller baby and more scans/Doppler; screening framing.
- **"Your monitoring schedule & tests"** — PLGF, urine protein, bloods, growth scans; coordinating OB + hypertension doctor.
- **"Fetal movements & why they matter here"** — reduced movement = contact provider today.
- **"After birth — your blood pressure & medicines"** — chronic HTN persists; postpartum PE window; medicine review incl. breastfeeding compatibility; keep monitoring.
- **"Coping with managing a chronic condition through pregnancy"** — validating the vigilance burden; grounding/calming; soft EPDS pointer = "screening, discuss with clinician."
- **Reachable-but-hidden:** the full D1 week-by-week library and all lifespan content remain searchable — she is never boxed into "HTN only."

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs (inputs):**
- **BP log** {systolic, diastolic, pulse, arm, timestamp, optional context flags: rested / after activity / clinic vs home} — **shared component with D6.**
- **Medication log** {name, class, schedule, taken/missed} + **aspirin** flag; each med links to its "what this is / how it's generally regarded in pregnancy" education card.
- **Symptom log** {headache, vision changes, upper-abdominal/rib pain, swelling, breathlessness, reduced movement, nausea, general unwell — timestamped}.
- **Urine-dip result** (user-entered), **growth-scan / PLGF / bloods results** (user notes), **appointment results** (user notes) across both care teams.
- Weight, mood, fetal-movement notes (continuous with D1).

**Tools:**
- **BP trend chart** (values over time; **no zones/verdicts**), **PDF export** (for OB *and* hypertension doctor), medication reminders, aspirin reminder, appointment/monitoring scheduler (two-team aware), kick-count (from D1), home-BP technique guide.

**Mandatory compliance wording:**
- On the BP log (every relevant surface): *"This is your personal record — Femio does not read or judge your blood pressure. Only your clinician can interpret your readings."* The chart shows her numbers **without** a normal/abnormal overlay, plus an **always-visible** static reference note: *"Clinicians treat 160/110 or above as urgent. If your reading is at or above this, or you have any warning sign, contact your maternity unit or emergency number now."* — **fixed education, not a dynamic evaluation.**
- On the medication log: *"Femio lists the medicines you tell us about and helps you remember them. It never tells you to start, stop, change, or dose a medicine — that's your clinician's decision. Never stop a blood-pressure medicine on your own."*

**Alerts / nudges (all opt-in, calm, revocable):**
- BP-check reminders (times she sets), **medication/aspirin reminders**, appointment/monitoring/growth-scan reminders, "log today's symptoms?" nudge.
- **No** alert is ever triggered by *interpreting* a value ("your BP is high" ← forbidden) or by *evaluating a medication*. Reminders are schedule-based only.

**Red-flag box pattern (reusable component — SHARED WITH D6, keep identical):**
> **⚠ Seek care now**
> Contact your maternity unit or local emergency number **immediately** if you have: a **severe headache that won't go away** · **changes in your vision** (blurring, spots, flashing) · **pain in your upper belly / under your right ribs** · **sudden swelling** of your face or hands · **trouble breathing** · your **baby moving less than usual** · a blood-pressure reading **at or above 160/110** · a **seizure** (call emergency services).
> *You know your body best — if something feels wrong, get it checked now. This app can't diagnose or treat.*
> [Call my maternity unit] [Emergency number] [Learn the warning signs]

**Placement:** persistent entry in nav; pinned on the D5 home; **auto-injected** at the bottom of every symptom explainer and **whenever a PE-warning-sign symptom is logged** (surfaced as guidance, never as "you have PE").

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1):**
- `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, units, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- Height; pre-pregnancy weight & BMI; menstrual/LMP history.
- Medical-history flags (**chronic hypertension**, renal, prior PE, diabetes, thyroid, VTE, high BMI, autoimmune) — **chronic HTN here is the persona anchor** and **sets the D5 flag** (and the superimposed-PE / D6 red-flag inheritance).
- Medications, allergies, supplements; prior pregnancies/outcomes (gravida/para, prior PE/HELLP/preterm/FGR flags); emergency/maternity contact.

**D1 pregnancy fields (inherited):** `edd`/`gestational_age` (single source of truth for gating), confirmed-pregnancy date, singleton/multiple, blood type/Rh, prenatal-visit log, weight-gain series, kick-count sessions.

**D5 persona-specific:**
- `chronic_htn_flag` {bool} and `htn_dx_timing` {pre-pregnancy / <20 weeks — the D5 vs D6 discriminator}.
- `bp_readings[]` {systolic, diastolic, pulse, arm, context_flag, timestamp} — **stored raw; never scored** (shared with D6).
- `antihypertensives_active[]` {name, class (labetalol / nifedipine / methyldopa / ACEi / ARB / thiazide / other), schedule, adherence[], user-entered start/stop as recorded from clinician} + `aspirin_prophylaxis` {flag, user-entered start}.
- `medication_safety_ack` {viewed "never stop/change on your own" education — soft, non-blocking}.
- `pe_symptom_log[]` {type, severity_note, timestamp} (shared with D6).
- `superimposed_pe_status` {watch / recorded-by-user-from-clinician — an attribute, **not** an app diagnosis; escalates emphasis toward D6}.
- `urine_protein_results[]`, `plgf_or_bloods_results[]`, `growth_scan_notes[]` (foregrounded — FGR surveillance).
- `monitoring_schedule[]` {appointment type, care-team (OB / hypertension-doctor), date, cadence}, `bp_check_reminders[]`, `med_reminders[]`, `growth_scan_reminders[]`.
- `saved_maternity_unit`, `saved_emergency_contact`, `saved_hypertension_doctor`, `localized_emergency_number`.
- `fetal_movement_flag` (foregrounded), `postpartum_bp_monitoring[]`, `postpartum_med_review_flag` (breastfeeding-compatibility education) — the E4 tail.
- `log_export_history[]` (PDF bundles generated for clinician(s)).

*Data-minimization: collect only what powers a used feature; all logs user-deletable; chronic-diagnosis + medication status is **special-category data** with tightened retention/consent (§K).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Entry (layered on D1 — additive emphasis, never restriction):**
- D5 is reached from **D1** (or from **pre-pregnancy cycle tracking** where chronic HTN is already flagged) when the user **carries a chronic-hypertension history flag**, **records being on/starting an antihypertensive**, or **records a clinician diagnosis of chronic/pre-existing hypertension (before 20 weeks)**. The **pre-/early (<20 wk) timing** is what distinguishes D5 from D6. See §J.
- Short, **editable/resettable** confirm step: *"You have high blood pressure that started before or early in this pregnancy — want Femio set up to help you log your BP and medicines and stay aware of the signs to watch for? (You keep everything in your pregnancy tracker too.)"*

**Home configuration for D5 (management- + safety-forward):**
- **Hero re-order:** BP-log quick-entry + last few readings (chart), **today's medication + aspirin reminder**, the **"seek care now" pinned card** (shared D6 component), next monitoring/growth-scan appointment.
- **Secondary:** the calm HTN-in-pregnancy + medication-safety education hub; the inherited **D1 week-by-week card** stays present, just below the management/safety rows.
- **Symptom quick-log** foregrounded; logging a warning-sign symptom surfaces the red-flag box.
- **Tone:** calm, validating, uncluttered; **no alarmist visuals**; never frighten her off a prescribed medicine.

**Hidden-but-reachable rule.** Nothing is locked. All D1 content/tools remain available and searchable. BP/medication tools are *surfaced* for D5 but reachable by anyone via the tools menu with an "usually used when a clinician is monitoring your BP / medicines" note. The chronic-HTN flag **adds** emphasis; it never hides pregnancy content.

**Safety-forward defaults.** Red-flag layer is **always on** for D5 (shared with D6) and cannot be buried; BP log **never** shows an interpretive overlay; medication log **never** advises start/stop/switch/dose; reminders are calm and schedule-based only.

**Continuity.** History (chronic HTN, prior PE/FGR, BMI, existing antihypertensive) auto-seeds the D5 flag and emphasis — no re-onboarding; a one-time "your history is here and private" note. A pre-pregnancy Femio user already tracking BP/HTN transitions seamlessly on a positive test.

---

## J. Adaptation triggers (state transitions)

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Enters D5 from pre-pregnancy / D1 — chronic HTN present** | Chronic-HTN history flag, existing antihypertensive recorded, or clinician dx of pre-existing/<20-wk hypertension | Additive: switch to D5 home emphasis; enable BP/medication/monitoring tools; surface calm HTN + medication-safety education + shared red-flag layer. **Never** self-generate the diagnosis. | **D5** (from D1 / pre-pregnancy tracking) |
| **Medication-safety event** | User records being on an ACEi/ARB (or any med) | Surface *general, non-prescriptive* class education ("some medicines are usually reviewed in pregnancy — never stop on your own; your clinician decides") + prompt to confirm with clinician. **No** advice to stop/switch/dose. | Education (content only) |
| **Warning-sign symptom logged / severe reading entered** | User logs a PE red-flag symptom, or enters a reading ≥160/110 | **Surface the shared "seek care now" box + saved maternity/emergency contact** as *guidance/education* — **not** a diagnosis/triage, no "you have PE / go now" verdict. Log stays raw. | Emergency-escalation **messaging** (content, not clinical instruction) |
| **Superimposed pre-eclampsia — signs emerging / clinician dx recorded** | User records new proteinuria/PE dx, or logs escalating PE warning signs on top of chronic HTN | **Blend / escalate emphasis to D6** (superimposed pre-eclampsia): foreground D6 education + red-flag layer; unify BP/med tools; avoid double-counting. **Never** self-diagnose. | **D5 → D6** blend/escalate |
| **Overlap with gestational diabetes / other** | GDM, thyroid, multiples, high BMI, AMA recorded | Additive blend with **D3 / D7 / D9 / D12 / D13** as relevant; D5 management + red-flag layer persists. | Blended emphasis |
| **Fetal growth restriction / small baby recorded** | User notes FGR / small-for-dates from a growth scan | Calm growth-surveillance content; foreground movement awareness; extra-scan tracking. No interpretation of scan values. | Content + monitoring emphasis |
| **Early / preterm delivery planned or occurs** | User records planned early birth or delivery | Calm prematurity/NICU content; transition on birth (below); **do not** frame as countdown. | Content + → E1/E4 |
| **Delivery / birth logged** | Birth recorded | Transition to **Postpartum (E1)**; **carry BP + medication logging + red-flag layer forward** into **E4 ongoing-BP-follow-up** — chronic HTN persists, meds are often reviewed/re-adjusted (incl. breastfeeding compatibility), and PE can onset/persist postpartum (48h–6 wks). | **E1 + E4** |
| **Postpartum-onset PE signs** | Postpartum user logs headache / raised BP / warning sign within ~6 wks | Shared red-flag "seek care now" box (postpartum-tuned); keep BP log live; "this is worth getting checked now." No diagnosis. | **E4** emergency messaging |
| **Pregnancy loss / stillbirth logged** | User reports loss | Immediate dignified transition to **loss/grief (E6)**; **instantly suppress** all BP/med/appointment/milestone reminders; grief resources; no re-prompting. | **E6** |
| **Withdraw / step back** | User exits monitoring mode | Pause nudges; retain data per privacy settings; nothing forced. | Retain, low-touch |

*All routes preserve one-account data continuity and always end with clinician-referral language, never a diagnosis and never a medication instruction. The **D5→D6 escalation** keeps the superimposed-pre-eclampsia red-flag framing consistent by design. Emergency escalation is **messaging/education that routes her to real care** — Femio never itself triages, prescribes, calls, or decides.*

---

## K. Compliance flags

1. **No diagnosis / triage / interpretation (highest-priority guardrail).** Femio **never** classifies a BP reading or symptom, never says "normal/high/dangerous," never says "you have / likely have (superimposed) pre-eclampsia," never says "go to hospital / stay home." Targets/thresholds (140/90, 135/85, 160/110) appear only as **fixed educational reference**; the shared red-flag layer **routes her to care** without deciding *for* her. Keeps Femio out of the **medical-device + diagnosis** lane. **[NEEDS SOURCE — confirm current medical-device software / app-store medical-claims wording at ship.]**
2. **No prescribing / no dosing / no start-stop-switch (D5-critical, second guardrail).** Medication and aspirin content is **general class education**, cited; all dosing, choice, starting, stopping, and switching defer to the clinician. **No** dosing calculator. Contraindicated-drug content (ACEi/ARB) is framed as *"usually reviewed in pregnancy — never stop on your own; your clinician decides,"* **never** "stop taking X." Never frighten her off a prescribed medicine.
3. **Emergency-territory framing (shared with D6).** Superimposed-pre-eclampsia red-flag symptoms (severe headache, vision changes, upper-abdominal pain, sudden swelling, reduced movement, ≥160/110, seizure) get **prominent, calm "seek care now"** framing with the user's contacts — **never** false reassurance, **never** alarmist doom, **never** a diagnosis. Framing must stay **identical in spirit to D6**.
4. **Screeners = "screening, discuss with clinician."** PLGF, urine protein, growth scans, risk-factor checklists, EPDS — all framed as screening/context, never verdicts.
5. **Emotional safety.** High chronic-vigilance persona; tone must be **validating and calming**, no scare-content, no anxiety-driving nudges, and specifically nothing that undermines medication adherence her clinician has set. [Anxiety & HDP review 2024/25]
6. **Privacy-by-design (GDPR/PDPL — special-category health data).** A **chronic diagnosis + active medication + pregnancy** is highly sensitive. **No data sale, no ad-targeting SDKs, no employer/insurer visibility.** Explicit, granular, revocable consent; strong retention limits; user-deletion of BP/medication/symptom logs; partner sharing opt-in and scope-limited.
7. **Reminder suppression on loss / early exit.** BP/med/appointment/growth-scan reminders must **instantly stop** on logged loss or withdrawal.
8. **Postpartum continuity is a safety feature.** Chronic HTN persists and PE can onset/persist postpartum; BP + medication logging + red-flag layer **must persist into E4**, including breastfeeding-medicine education. Dropping them at birth would be a safety gap.
9. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIH/CDC/NHS/MedlinePlus) + Tier-2 (ACOG/RCOG/NICE), grade 6–8, localized in 4 languages with **human-reviewed** RTL parity (clinical stakes forbid machine-only translation of safety/medication copy).
10. **Open items:** resolve **[NEEDS SOURCE]** — ACOG Practice Bulletin 203 permalink; ACOG CHAP Practice Advisory (2022) permalink; USPSTF aspirin permalink; AHA/BIHS home-BP-technique permalink; **localize emergency numbers and MENA-specific HTN-in-pregnancy guidance** before content freeze.

---

## Sources

**Tier-1 (NIH / CDC / NHS / MedlinePlus):**
- [MedlinePlus — High Blood Pressure in Pregnancy](https://medlineplus.gov/highbloodpressureinpregnancy.html) · [MedlinePlus — Preeclampsia (Encyclopedia)](https://medlineplus.gov/ency/article/000898.htm)
- [CDC — Urgent Maternal Warning Signs & Symptoms (HEAR HER)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [NEJM — Treatment for Mild Chronic Hypertension during Pregnancy (CHAP trial)](https://www.nejm.org/doi/full/10.1056/NEJMoa2201295)
- [PMC — Clinical Trials That Have Changed Obstetric Practice: The CHAP Trial](https://pmc.ncbi.nlm.nih.gov/articles/PMC11062801/) · [PMC — Drug Treatment of Hypertension in Pregnancy](https://pmc.ncbi.nlm.nih.gov/articles/PMC4558097/) · [PMC — Pharmacokinetics of methyldopa, labetalol, and nifedipine in pregnancy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9474278/)
- [NCBI Bookshelf — Hypertension in Pregnancy: Diagnosis and Management (NICE NG133 full text)](https://www.ncbi.nlm.nih.gov/books/NBK546004/)
- [PMC — Anxiety and hypertensive disorders of pregnancy: epidemiology, mechanisms, management](https://pmc.ncbi.nlm.nih.gov/articles/PMC12188884/)
- [PMC — Home blood pressure monitoring in pregnancy: systematic review & meta-analysis](https://pmc.ncbi.nlm.nih.gov/articles/PMC8248564/)

**Tier-2 (ACOG / RCOG / NICE):**
- [ACOG — Clinical Guidance for the Integration of the Findings of the CHAP Study (Practice Advisory, 2022)](https://www.acog.org/clinical/clinical-guidance/practice-advisory/articles/2022/04/clinical-guidance-for-the-integration-of-the-findings-of-the-chronic-hypertension-and-pregnancy-chap-study)
- [AAFP — Managing Chronic Hypertension in Pregnant Women: ACOG Updated Practice Bulletin (203)](https://www.aafp.org/pubs/afp/issues/2019/1215/p782.html)
- [SMFM Statement — Antihypertensive therapy for mild chronic hypertension in pregnancy (CHAP), AJOG](https://www.ajog.org/article/S0002-9378(22)00283-6/fulltext)
- [AJOG — Chronic hypertension and superimposed preeclampsia: screening and diagnosis](https://www.ajog.org/article/S0002-9378(20)31328-4/fulltext)
- [Frontiers in Cardiovascular Medicine (2025) — A prediction model of superimposed preeclampsia in women with chronic hypertension](https://www.frontiersin.org/journals/cardiovascular-medicine/articles/10.3389/fcvm.2025.1641662/full)
- [ACOG / SMFM — Low-Dose Aspirin Use for the Prevention of Preeclampsia (Practice Advisory, 2021)](https://www.acog.org/clinical/clinical-guidance/practice-advisory/articles/2021/12/low-dose-aspirin-use-for-the-prevention-of-preeclampsia-and-related-morbidity-and-mortality)
- [NICE NG133 — Hypertension in pregnancy: diagnosis and management (Overview)](https://www.nice.org.uk/guidance/ng133) · [NICE NG133 — Recommendations](https://www.nice.org.uk/guidance/ng133/chapter/recommendations)
- [GPnotebook — Antihypertensives during pregnancy (safe vs contraindicated classes)](https://gpnotebook.com/pages/obstetrics/pregnancy-antihypertensives-during)

**Competitor / market (BP-app & privacy landscape):**
- [PMC — Quality of Blood Pressure Tracking Apps: adherence with home-BP best practices](https://pmc.ncbi.nlm.nih.gov/articles/PMC6484262/) · [PMC — Mobile Apps for Blood Pressure Monitoring: content analysis](https://pmc.ncbi.nlm.nih.gov/articles/PMC6262205/)
- [JMIR Human Factors (2026) — Smartphone app to monitor BP in normotensive, high-risk & preeclampsia pregnancies (feasibility)](https://humanfactors.jmir.org/2026/1/e70370)
- [Consumer Reports — Best Pregnancy Tracking Apps (privacy analysis)](https://www.consumerreports.org/health/pregnancy-childbirth/best-pregnancy-tracking-apps-a8731130463/) · [Flo (app) — FTC settlement & Anonymous Mode (Wikipedia)](https://en.wikipedia.org/wiki/Flo_(app))

**Consumer clinical references (Tier-2/3, for tone/plain-language cross-check):**
- [Mayo Clinic — High blood pressure and pregnancy](https://www.mayoclinic.org/healthy-lifestyle/pregnancy-week-by-week/in-depth/pregnancy/art-20046098) · [Cleveland Clinic — Preeclampsia](https://my.clevelandclinic.org/health/diseases/17952-preeclampsia) · [Healthline — Antihypertensive Medications for Pregnant Women](https://www.healthline.com/health/pregnancy/chronic-hypertension-medicine)

*Community insight (r/hypertension, r/BabyBumps, r/pregnant, chronic-HTN + pregnancy threads, ACOG/AAFP patient FAQs, pregnancy/BP-app reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes.*

*[NEEDS SOURCE]* to resolve before content freeze: **ACOG Practice Bulletin 203 (Chronic Hypertension in Pregnancy)** exact permalink; **ACOG CHAP Practice Advisory (2022)** direct permalink; **USPSTF** aspirin-for-preeclampsia recommendation primary permalink; **AHA / British & Irish Hypertension Society** home-BP-measurement-technique permalink; region-localized emergency numbers + MENA-specific chronic-HTN-in-pregnancy guidance for the AR-first build.
