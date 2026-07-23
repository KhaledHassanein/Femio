# Persona D7 — Pregnancy with Thyroid Disease (Hypothyroidism / Hashimoto's, Hyperthyroidism / Graves', or Newly Abnormal Thyroid in Pregnancy)

> Femio persona spec. Cohort: Pregnancy (D) · Layered on **D1** (uncomplicated pregnancy spine) with a **thyroid layer**. Last research pass: 2026-07-17
> Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent.** Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening — discuss with your clinician." **TSH/lab and medication logs (e.g. levothyroxine, PTU/methimazole) are educational self-tracking, never prescriptive — no dosing advice.** Every target number is presented as "what guidelines describe; confirm with your clinician."
> **Destination state of the C8 flagship transition** — D7 is where a C8 (thyroid-aware TTC) user arrives on a positive test (see §J and C8 §J.1). The EMR is **constant**; the lab log and medication log continue uninterrupted; monitoring reminders tighten; the content library re-skins to thyroid-in-pregnancy. D7 can also be reached from D1 when a thyroid diagnosis is recorded.

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Nour," 33 |
| **Age band** | ~28–38 (thyroid disease prevalence rises with age; may also brush the AMA/35 line → D13 emphasis) |
| **Stage** | Pregnant with a **thyroid condition**. Three entry pictures: (1) **pre-existing hypothyroidism / Hashimoto's** on levothyroxine (most common); (2) **hyperthyroidism / Graves'** on antithyroid drugs (ATDs) or post-ablation/surgery; (3) **newly abnormal thyroid found in pregnancy** (screen-detected subclinical/overt hypothyroidism, or gestational hyperthyroidism). She may arrive already knowing her diagnosis (from C8) or have it flagged mid-pregnancy (from D1). |
| **Relationship** | Usually partnered; she carries the medical load — labs, meds, and now **two clinicians** (OB + endocrinologist) she has to keep synchronized. |
| **Goal (top JTBD)** | *"I'm pregnant and I have a thyroid condition. Help me watch my TSH closely, keep my medication straight as the dose changes, keep my OB and endo on the same page, tell me clearly when something needs urgent care — and reassure me my baby can develop normally if I stay on top of this. Without scaring me, without ads, without selling my data."* |
| **Health literacy** | High and anxious. She has usually read "increase your levo when you get a positive test" and "TSH under 2.5" and wants Femio to be *better sourced* and calmer than the forum that taught her. If newly diagnosed in pregnancy, literacy is lower and fear is higher. |
| **Tech context** | Web-first, mobile-heavy. Today she **stacks apps**: a pregnancy tracker (What to Expect/BabyCenter/Pregnancy+) *plus* a thyroid tracker (ThyForLife/BOOST/Paloma) *plus* a Notes file of TSH values. That stacking — during the one life stage where thyroid control matters *most* — is the core pain. |
| **Locale** | Arabic-first / RTL a first-class case; also EN/FR/ES. Iodine status and thyroid-disease prevalence vary by region; MENA modesty/privacy sensitivity high. |
| **Emotional state** | Vigilant and frightened *for the baby*. The dominant fear is **"will my thyroid harm my baby's brain/development?"** layered on ordinary first-trimester miscarriage anxiety and the pressure of a fast-moving early-pregnancy medication/lab to-do list. |
| **What she is NOT** | Not looking for a diagnosis (she has one, or her clinician is investigating one). Not seeking dose advice from an app. Not low-risk in the D1 sense — but **not** a crisis case either; with monitoring, outcomes are typically good, and Femio's job is to hold that honest, reassuring middle. |
| **Primary signals she brings** | Lab values (**TSH, Free T4, ± Free T3, TPO/TG antibodies, TRAb** for Graves'), medication + fasting/timing adherence (levothyroxine fasting, separated from iron/calcium/prenatal); plus the full D1 pregnancy signal set (GA/EDD, symptoms, weight, appointments, later kick counts). |
| **Success = she feels informed, monitored, and reassured** | She kept labs + meds + pregnancy in one private account, handed a clean export to *both* clinicians, understood every number as "discuss with your clinician," and — at delivery — flowed into **postpartum with a postpartum-thyroiditis watch (E7)** without losing her thyroid history. |

**Persona thesis.** D7 sits at the **same unserved intersection as C8, at its highest-stakes moment**: pregnancy apps have nowhere to put a TSH value or a levothyroxine dose change; thyroid apps have no gestational-age spine, no fetal-development content, no red-flag layer. D7 currently duct-tapes a pregnancy app and a thyroid app together during the exact window when maternal thyroid hormone matters most for fetal brain development and when levothyroxine needs typically rise. Femio's one-account, referenced, uncertainty-honest, privacy-by-design model is purpose-built for this seam — and it lets the account carry her from thyroid-aware TTC (C8) → thyroid-aware pregnancy (D7) → postpartum-thyroiditis-aware recovery (E7) without ever slipping into prescriptive or diagnostic territory.

---

## B. Needs & questions (voice-of-user)

Mined from r/Hypothyroidism, r/Hashimotos, r/thyroidhealth, r/BabyBumps + thyroid-in-pregnancy threads, thyroid-and-pregnancy forums, and app-store reviews of both pregnancy apps (What to Expect/BabyCenter/Ovia/Pregnancy+) and thyroid apps (ThyForLife/BOOST/Paloma). Phrasing is representative/composite (community norms; not quoting individuals).

**The dominant emotional need — "will my thyroid hurt my baby?" (all trimesters, peaks T1):**
- *"I have Hashimoto's and I just got my positive — is my baby's brain okay if my TSH was a little high before I knew?"*
- *"I read the baby uses MY thyroid hormone in the first trimester — did I do damage before I increased my dose?"*
- *"My TSH came back 4.1 at 7 weeks. Is that dangerous? My OB seems calm but I'm panicking."*

**Medication mechanics & the early-pregnancy dose change (educational):**
- *"Everyone says increase your levo the day you get a positive — by how much? Do I really do this myself before I see my doctor?"* (she's read the "two extra tablets a week" rule — wants it *framed as education, confirm with clinician*)
- *"I take my levo, then my prenatal has iron and calcium — am I ruining the absorption? How long do I wait?"*
- *"My dose went from 75 to 100 and I feel weird — is that the thyroid or just pregnancy?"*
- *(Graves')* *"I'm on methimazole and pregnant — I read that's dangerous in the first trimester and I should be on PTU. Should I switch? I'm terrified."* (ATD-in-pregnancy fear — strictly *ask your clinician now*)

**Monitoring / lab-timing / two-clinician coordination:**
- *"How often am I supposed to get my TSH checked now? My OB said every trimester, a forum said every 4 weeks — which is it?"*
- *"My endo orders one set of labs, my OB orders another. Nobody's talking to each other and I'm the messenger."*
- *"I need one place to show BOTH doctors my TSH trend and my dose history."* (the export need — doubled, because two providers)
- *"When do I stop the every-4-weeks checks?"*

**Symptom disambiguation (thyroid vs. pregnancy):**
- *"Exhausted, cold, constipated, foggy — is my thyroid under-treated or is this just pregnancy?"*
- *(Graves')* *"Racing heart and sweating — is that my thyroid flaring or normal pregnancy?"* (overlaps a red-flag; must route, not reassure)

**Newly-diagnosed-in-pregnancy sub-need (lower literacy, higher fear):**
- *"They found a thyroid problem at my booking bloods. I've never had this. What does subclinical mean? Do I need medication? Is my baby okay?"*

**Looking ahead / postpartum:**
- *"Does this go away after birth or am I on this medication forever?"*
- *"I heard your thyroid can go haywire after delivery — what's postpartum thyroiditis and will I get it?"*

**Anti-needs / trust-breakers (what makes her churn):**
- A pregnancy app with **nowhere to log a TSH or a levo dose**; a thyroid app with **no pregnancy spine**.
- Any app that treats "normal TSH range" and "pregnancy TSH target" as the same thing.
- **Prescriptive tone** ("increase your dose to X," "switch to PTU") — she needs *educational* framing routed to her clinician; a dose instruction both scares her and is out of scope (§K).
- Reassurance theatre ("your baby is fine!") on a symptom that should be checked — she needs honest red-flag routing, not false comfort.
- Doom-framing that fixates on fetal-brain risk without the honest "with monitoring, outcomes are typically good" counterweight.
- Predictions/verdicts stated as certainties; a lab shown as "abnormal — you have…".
- Privacy creep with combined **reproductive + chronic-disease + medication** data (post-Flo/Premom/BabyCenter distrust).

**Feature requests recurring in reviews/forums:**
- One place for **pregnancy week-by-week + TSH/antibody lab trends + levothyroxine/ATD adherence + appointments** — nobody offers this.
- Lab **trend charts** she can **export/share with BOTH the OB and the endo**.
- **Medication reminders** with the fasting/spacing rules baked in, that survive a mid-pregnancy dose change.
- A gentle, sourced answer to "what TSH should I be at now," and an honest "labs are often checked ~every 4 weeks early on — your clinician sets your schedule."
- Reassurance content that is *honest*: the risks of untreated disease **and** the strong message that monitoring and treatment mitigate them.

---

## C. Competitor teardown

The decisive finding (same seam as C8, higher stakes): **no mainstream app integrates thyroid management with pregnancy tracking.** Pregnancy apps and thyroid apps are entirely separate product categories; D7 lives in the gap and stacks one from each column during the highest-stakes window of thyroid care.

### Column 1 — Pregnancy apps (strong on gestational spine, blind to thyroid)

| App | Week-by-week / fetal content | Lab handling (TSH/FT4/antibody) | Thyroid / medication support | Red-flag safety | Privacy / positioning |
|---|---|---|---|---|---|
| **What to Expect** | Strong editorial, daily updates; **busy, ad-heavy** | No structured lab tracker | **None**; generic med reminders at best | Some warning-sign content | Reported to sell personal data for targeted ads |
| **BabyCenter** | Large library; **heavily commercialized** | No lab tracker | **None** | Some | Sells data to third parties; named in 2024 US Senate data-broker inquiry |
| **Pregnancy+ (Philips)** | **Best-in-class 3D visuals**, weekly articles | No lab/TSH tracker | **None** | Basic | Reported ad-sharing with Facebook/Google/Pinterest |
| **Ovia Pregnancy** | Data-rich logging + insights | Some results logging, not thyroid-structured | **None thyroid-specific** | Some | Owned by Labcorp; employer/insurer-visibility concern |
| **Flo (pregnancy mode)** | Weekly + daily insight stories | No structured lab tracker | **None** | Limited | 2021 FTC settlement; Anonymous Mode (partial) |

### Column 2 — Thyroid / Hashimoto's apps (strong on labs/meds, blind to pregnancy)

| App | Lab tracking (TSH/FT4/FT3/antibodies) | Medication + adherence | Symptom tracking | Pregnancy spine (GA / fetal / red-flags) | Notes |
|---|---|---|---|---|---|
| **ThyForLife** | **Deep** — TSH, T4/FT4, T3/FT3, TG, TGAb; 40+ meds/supplements | Yes, reminders | Yes | **None** | Community + trend charts; thyroid-only |
| **BOOST Thyroid** | Deep labs + reference ranges | Meds/supplements, reminders | Symptoms, trends | **None** | Hashimoto/hypo focused |
| **Paloma Health** | Labs + symptom tracker | Reminders | Yes | **None** (US telehealth + test kits; a *"2026 guidelines for hypothyroidism and pregnancy"* explainer exists, but no in-app pregnancy tracking) | Bundled care model |
| **Hashimoto's Journey / Hashimoto Tracker** | TSH, FT4, TPO Ab; fasting/timing compliance | Levo/Tirosint adherence | Fatigue/brain-fog | **None** | Endo-shareable reports; thyroid-only |

### Whitespace map (the D7 opening)

- **Pregnancy depth** lives in Column 1; **thyroid depth** lives in Column 2. **No product spans both** — and the overlap is *most clinically consequential* exactly here, in pregnancy.
- The moments that matter for D7 — **the positive-test levothyroxine increase, the ~every-4-week TSH re-checks, the OB↔endo coordination, the fetal-development reassurance, and the postpartum-thyroiditis watch** — fall precisely in the gap. A pregnancy app never sees the TSH; a thyroid app never sees the pregnancy.
- **Nobody** offers: gestational-age pregnancy spine **+** structured TSH/antibody lab trends **+** levothyroxine/ATD adherence with fasting rules **+** OB↔endo-ready export **+** honest fetal-development reassurance **+** red-flag safety layer **+** postpartum-thyroiditis continuity **+** trustworthy privacy **+** Arabic-first RTL, in **one account.** That seam — inherited from C8 and extended through delivery — is D7's Femio thesis.

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, prescribe, or adjust medication; it educates and helps the user track and prepare for clinician conversations. **All medication/lab content is educational — every dose, target, or threshold is presented as "what guidelines describe; confirm with your clinician."** Numeric targets vary by guideline edition and by lab assay — cite the live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH — reconcile 2017 ATA vs. any 2026 update; use trimester/assay-specific ranges.]**

**Why thyroid control matters *more* in pregnancy (the reassurance-with-honesty core):**
- Pregnancy raises **thyroid-binding globulin** and, via **hCG**, transiently stimulates the thyroid; the **fetal thyroid does not function until ~12–13 weeks**, so early fetal brain development depends on adequate **maternal** thyroid hormone. This is why first-trimester control is emphasized. [ATA "Hypothyroidism in Pregnancy"; NEJM Alexander et al.; StatPearls]
- **Untreated / inadequately treated maternal hypothyroidism** is associated with increased risk of **miscarriage, pre-eclampsia, anemia, placental abnormalities, preterm birth, low birth weight, postpartum hemorrhage**, and — with severe untreated disease — **impaired fetal neurocognitive development.** The honest counterweight Femio must always pair with this: **early detection and appropriate treatment substantially mitigate these risks.** [ATA; PMC "Hypothyroidism in pregnancy" review; StatPearls]
- Uncontrolled **hyperthyroidism** likewise raises risks (miscarriage, pre-eclampsia, preterm birth, low birth weight, and rarely fetal/neonatal thyroid dysfunction via TRAb). Treatment aims to keep the mother mildly-controlled, not over-treated. [ATA "Hyperthyroidism in Pregnancy"]

**Levothyroxine dose in early pregnancy (educational — the flagship teaching point):**
- Levothyroxine requirements **frequently increase in pregnancy, commonly by ~25–50%**, often as early as ~week 5. [NEJM Alexander et al.; ATA]
- ATA describes that hypothyroid women on levothyroxine can be advised to **independently increase their dose by ~20–30% as soon as pregnancy is confirmed** — a practical method being **two extra daily doses per week** — and then **notify their clinician for prompt testing.** **Femio surfaces this as education + a "contact your clinician now" prompt — it does NOT instruct a dose change.** [ATA "Hypothyroidism in Pregnancy"]

**TSH targets in pregnancy (educational):**
- ATA advises adjusting levothyroxine to keep **TSH between the lower reference limit and ~2.5 mIU/L** in the treated hypothyroid patient; where trimester/assay-specific ranges aren't available, an **upper reference limit of ~4.0 mIU/L** in the first trimester is described (a reduction of ~0.5 from the non-pregnant upper limit), rising slightly across the 2nd/3rd trimesters but staying below non-pregnant levels. [2017 ATA guideline; ATA patient materials] **Femio presents these as *guideline-described targets to discuss with a clinician* — never a number the app tells her to "hit," never a pass/fail verdict on her lab.**

**Monitoring cadence (educational):**
- Thyroid function (TSH ± Free T4) is typically checked **at least every ~4 weeks through the first half of pregnancy** and with any dose change, then **at least once between ~weeks 26–32**, often less frequently after mid-gestation. **Femio educates on this typical pattern and lets her set a clinician-informed reminder cadence — the clinician sets the actual schedule.** [2017 ATA guideline; ATA]

**Hyperthyroidism / Graves' in pregnancy (educational):**
- Guidelines describe **PTU (propylthiouracil) preferred in the first trimester** because first-trimester methimazole/carbimazole exposure carries a higher risk of birth defects; **consideration of switching to methimazole in the second trimester** is discussed (PTU carries a rare hepatotoxicity concern). **Antithyroid-drug choice, switching, and dosing are strictly clinician decisions — Femio explains the landscape and routes to the clinician promptly; it never recommends, switches, stops, or doses ATDs.** [ATA "Hyperthyroidism in Pregnancy"; 2017 ATA guideline; Endocrine Society]
- **TRAb (TSH-receptor antibodies) can cross the placenta**; guidelines describe TRAb testing at pregnancy confirmation and, if elevated, again around **weeks 18–22** (and ~30–34 if still elevated), because maternal TRAb can rarely cause fetal/neonatal thyroid dysfunction — a reason OB and endocrinologist coordinate monitoring. [ATA; 2017 ATA guideline]

**Newly abnormal thyroid found in pregnancy (educational):**
- Screen-detected subclinical or overt hypothyroidism, thyroid autoimmunity, and gestational (hCG-mediated) hyperthyroidism are managed per clinician judgment; treatment thresholds (e.g. TPO-antibody status influencing whether TSH 2.5–4.0 is treated) are **actively debated** — frame honestly, never as an app verdict. [2017 ATA guideline; ATA]

**Thyroid antibodies (educational):** TPO/TG antibodies are associated with increased miscarriage risk even in biochemically euthyroid women, and strongly predict **postpartum thyroiditis**; whether levothyroxine helps euthyroid antibody-positive women is **debated** — do not present treatment benefit as established. [Wiley/AJRI meta-analyses; PMC]

**Postpartum thyroiditis (educational — the E7 hand-off):**
- **Postpartum thyroiditis (PPT)** affects roughly **5–10%** of women in the first year after delivery; it can be a hyperthyroid phase, a hypothyroid phase, or both then recovery. It is **strongly associated with TPO antibodies** — up to ~50% of women TPO-positive in the first trimester develop PPT. Symptoms (fatigue, palpitations, mood, cold/heat intolerance) overlap normal postpartum experience, so Femio surfaces *awareness* and "discuss with your clinician," never a diagnosis. [Cleveland Clinic; PMC PPT reviews; ATA]

**Medication mechanics (adherence education, not prescription):**
- **Levothyroxine administration education:** follow the prescription label. Current MedlinePlus drug guidance describes taking levothyroxine on an empty stomach **30–60 minutes before breakfast** and separating **calcium carbonate or ferrous sulfate by at least 4 hours before or after** levothyroxine; NHS guidance likewise advises 30–60 minutes before the first meal or a caffeinated drink. This is relevant when a prenatal product contains iron or calcium, but Femio must prompt the user to check that specific product and regimen with a pharmacist or prescriber. Femio may mirror a user-entered regimen and remind; it never sets or changes the dose. ([MedlinePlus Drug Information](https://medlineplus.gov/druginfo/meds/a682461.html); [NHS, reviewed 6 July 2026](https://www.nhs.uk/medicines/levothyroxine/); reviewed Mohamed K., 23 July 2026.)

**Pregnancy general (inherited from D1, in scope):** typical prenatal-visit schedule; folic acid 400 mcg/day; iodine sufficiency; CDC "Hear Her" urgent maternal warning signs; kick counting ~28 wk; screening-vs-diagnostic framing. [ACOG; CDC Hear Her; NHS — see D1 §D]

*Femio applies all thyroid targets/thresholds as **educational context**, always ending "discuss with your clinician" — never a diagnosis, prescription, or dose instruction.*

---

## E. Feature set (prioritized)

Inherits the full **D1 pregnancy spine** (week-by-week home, appointments/checklists, weight guidance, red-flag safety layer, kick counter/contraction timer in T3) and **adds a thyroid layer**. Nothing from D1 is removed — thyroid features are additive emphasis.

**P0 — must-have (defines D7; ship the thyroid layer first):**
1. **Thyroid-aware pregnancy home** — the D1 week-by-week hero **plus a thyroid strip**: latest TSH (with lab reference range, no verdict), next-lab reminder, today's medication status. This single integration is the whole reason D7 switches from her two-app stack.
2. **Lab tracker (thyroid-aware, pregnancy-contextual)** — structured entry for **TSH, Free T4, ± Free T3, TPO/TG antibodies, TRAb** with units, date, and lab reference range; **trend charts over gestational age**; an *educational* "pregnancy context" annotation (guideline-described ≤2.5 / trimester-range picture + "discuss with your clinician"), never a pass/fail badge. Continues uninterrupted from C8.
3. **Medication log & reminders (educational), dose-change-aware** — levothyroxine or ATD, dose she enters herself, **fasting/timing/spacing reminders** (empty stomach; separate from iron/calcium/**prenatal**/coffee), adherence streak; supports a **mid-pregnancy dose change** (log old→new dose, keep history). **No dosing suggestions.**
4. **Monitoring reminder engine** — user/clinician-informed cadence, defaulting to the *educationally-described* "~every 4 weeks in the first half" pattern with copy that the **clinician sets the schedule**; a **medication-review reminder** on entry to pregnancy.
5. **OB↔endo export pack** — one PDF/image with TSH/antibody trends, medication + dose-change history, cycle/GA context, and questions — explicitly built for **two coordinating clinicians**.
6. **Fetal-development reassurance module (thyroid edition)** — honest, cited content answering "will my thyroid affect my baby?" that pairs the real risks of untreated disease with the strong "monitoring and treatment mitigate these risks" message. Non-diagnostic, never false comfort.
7. **Red-flag safety layer (inherited from D1, thyroid-tuned)** — CDC Hear Her warning signs, plus thyroid-symptom disambiguation content that **routes** (e.g. racing heart/severe symptoms → seek care) rather than reassures.

**P1 — high value (fast follow):**
8. **Symptom–lab correlation view** — descriptive only ("your fatigue logs cluster when TSH was higher"), never causal/diagnostic.
9. **Graves'/ATD sub-track** — TRAb logging + educational ATD-in-pregnancy content (PTU-first-trimester landscape as a *clinician conversation*), TRAb-monitoring reminder cadence; **never** a switch/stop/dose instruction.
10. **Partner/shared view (X2)** — consent-gated follow-along; partner optionally sees "she has a lab/med reminder today" (privacy-scoped, no lab values unless shared).
11. **Wearable/import** — Apple Health, manual lab entry always primary; photo-of-lab-report capture with user-confirmed transcription (private, deletable).

**P2 — differentiators / later:**
12. **Postpartum-thyroiditis pre-education + E7 hand-off primer** (surfaced late pregnancy): what PPT is, that antibody-positive women are higher-risk, "your clinician may check your thyroid after delivery."
13. Localized clinician-question lists per market (AR modesty-aware), for OB and endo separately.
14. Newly-diagnosed-in-pregnancy gentle onboarding path (lower-literacy, higher-reassurance content sequencing).

**Explicitly OUT of scope for D7 (guardrail):**
- **Any dose recommendation, titration, ATD switch, or "increase your levothyroxine / switch to PTU by X."** Education + clinician routing only. **Never.**
- Interpreting a lab as a verdict ("abnormal — you have…", "your TSH is fine/bad"); labs show ranges + "discuss with clinician."
- Any "your baby is fine / at risk" fetal-status verdict; kick counter/contraction timer remain tracking aids per D1, not tests of fetal wellbeing.
- Contraception framing (irrelevant here).

---

## F. Content modules

Inherits all **D1 content modules** (week-by-week development, trimester primers, symptom explainers, appointments/tests, nutrition/supplements, weight guidance, movement/kick counting, warning-signs hub, preparing-for-birth, emotional wellbeing) and adds the **thyroid-in-pregnancy set** below. Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each thyroid card carries citations + "not medical advice / discuss with your clinician" and, for anything touching meds/labs, an explicit **"educational, not a prescription or dose instruction"** line.

- **"Your thyroid and your baby"** (the flagship reassurance card) — why maternal thyroid hormone matters in the first trimester; the honest risks of untreated disease **paired with** the strong "with monitoring and treatment, outcomes are typically good" message. No doom, no false comfort.
- **"Why my levo dose often goes up in pregnancy"** — TBG/hCG physiology in plain language; the "~25–50% increase, often by week 5" picture; the "some patients are advised to add two doses a week the moment they test positive — **contact your clinician now**" teaching, framed as *what guidelines describe*, never an instruction.
- **"What TSH should I be at now?"** — the guideline-described ≤2.5 / trimester-range picture, honestly, with the debate acknowledged; normal-range vs. pregnancy-target explained; "discuss with your clinician."
- **"How often will my thyroid be checked?"** — the ~every-4-weeks-in-the-first-half pattern; "your clinician sets your schedule."
- **"Taking levothyroxine right in pregnancy"** — empty stomach, timing, and the **prenatal-vitamin iron/calcium spacing** trap specifically.
- **"Graves' / an overactive thyroid in pregnancy"** — the PTU-first-trimester landscape *as a clinician conversation*; TRAb and why it's monitored; **never a switch/stop instruction**; when symptoms are a red flag to report.
- **"Newly told I have a thyroid problem in pregnancy"** — gentle, low-literacy explainer of subclinical vs overt, antibodies, "what happens next," heavy on reassurance and clinician-routing.
- **"Thyroid symptoms vs. pregnancy symptoms"** — the fatigue/cold/palpitations overlap; which overlaps are ordinary and which warrant reporting/urgent care.
- **"Keeping your OB and endocrinologist on the same page"** — how to use the export pack; who monitors what; questions to ask each.
- **"After the birth: your thyroid and postpartum thyroiditis"** (late-pregnancy primer; hand-off to E7) — what PPT is, the TPO-antibody link, "your clinician may re-check your thyroid."
- **Reachable-but-hidden library:** the full D1 pregnancy library and full-lifespan women's-health content stay searchable so D7 never feels boxed into "thyroid-pregnancy only."

---

## G. Tools, logs & alerts (compliant framing — educational; red-flag boxes; not prescription)

**Logs (inputs):** — D1 set (symptom/mood, weight, appointments, checklist, kick counter T3, contraction timer T3) **plus:**
- **Lab log:** TSH, Free T4, Free T3, TPO Ab, TG Ab, TRAb — value + unit + date + lab reference range (user-entered). Continues from C8.
- **Medication log:** drug (levothyroxine / ATD — PTU/methimazole/carbimazole / liothyronine), user-entered dose, time taken, **dose-change history**, fasting/spacing adherence flags (with the prenatal-iron/calcium interaction surfaced).
- Supplements (iron/calcium/iodine/prenatal flagged for the spacing reminder).

**Tools:**
- Lab **trend chart** (TSH/FT4 over gestational age, with reference-range and *educational* target-band annotation — no pass/fail).
- **Dose-change timeline** (old→new dose vs. lab trend, descriptive).
- Symptom–lab correlation view (descriptive only).
- **OB↔endo export** (PDF/image) — labs + meds + dose history + GA context + questions.
- Inherited D1 tools: appointment/checklist, weight-vs-IOM-band, kick counter (T3), contraction timer (T3), optional export.

**Alerts / nudges (all opt-in, calm, tone-calibrated, revocable, RTL/localized):**
- "Time to take your thyroid medication" + (if relevant) "remember: empty stomach, and keep it away from iron/calcium/your prenatal/coffee." (adherence education)
- "Your next thyroid lab check is coming up around [date]." (user/clinician-set cadence; default educational "~every 4 weeks early on" pattern)
- **On entry to pregnancy (educational):** *"Because you take thyroid medication, many people need a thyroid lab check and a **medication review with their clinician** early in pregnancy — please contact your clinician soon."* (Information + routing. **NOT** a dose instruction.)
- Gestational-milestone nudges (inherited D1): kick counting ~28 wk, etc.
- **Late-pregnancy PPT primer nudge:** "After birth, some people's thyroid changes for a while — here's what to know and to discuss with your clinician."
- **No** predictive/diagnostic alerts. **No** "your TSH is abnormal," **no** "increase/decrease your dose," **no** "your baby is at risk."

**Red-flag box pattern (reusable D1 component, thyroid-tuned).**
> **⚠ Seek care now**
> Contact your maternity provider or local emergency number immediately if you have: heavy vaginal bleeding or fluid leaking · a severe headache that won't go away or vision changes · trouble breathing or chest pain · **a racing or pounding heartbeat that won't settle** · severe belly pain · fever of 38°C/100.4°F or higher · sudden severe swelling of face/hands · (after ~28 wk) your baby moving noticeably less than usual · thoughts of harming yourself.
> *Some thyroid symptoms overlap with pregnancy — if something feels wrong or severe, get it checked. This app can't diagnose or treat.*
> [Save my maternity/emergency contact] [Learn the warning signs]

**Mandatory compliance wording:**
- On lab surfaces: *"Lab values are shown with your lab's reference range for your records — this is not a diagnosis. Discuss results with your clinician."*
- On medication surfaces: *"This log is for your own tracking. Femio does not recommend, prescribe, or change medication or dose. Any change is a decision for you and your clinician."*
- **Never:** "your TSH is abnormal," "increase/decrease your dose," "switch to PTU," "your baby is fine/at risk," or any diagnostic/prescriptive phrasing.

---

## H. EMR fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine; carried unchanged across every §J transition, incl. C8→D7→E7):**
- Identity/account, `locale`, `rtl_pref`, units, consent/privacy flags; emergency/maternity contact (optional).
- DOB / age; height; pre-pregnancy weight & BMI.
- Menstrual history (LMP, typical cycle length); medical-history flags (**thyroid = set here**), medications, allergies, supplements; prior pregnancies/outcomes (gravida/para, prior-loss flag).
- `symptoms[]`, `mood[]`, `content_history[]`, `screener_results[]` (timestamped, "non-diagnostic" tagged).

> **Design principle (flagship, inherited from C8/§J):** the EMR is **constant**; only the **content, home config, and alert logic layered over it are persona-specific.** In the C8→D7 transition *no field is dropped* — the lab log, medication log, and cycle history all persist; the app re-interprets and re-surfaces them for the pregnancy stage. The same holds D7→E7.

**Pregnancy-specific (inherited from D1):**
- **EDD / gestational age** (from LMP or clinician-set EDD; single source of truth for all gating); confirmed-pregnancy / positive-test date (the C→D transition marker).
- Singleton vs multiple; blood type & Rh status (user-entered); prenatal visit log; screening/test milestones (user notes); weight-gain series; BP if logged; kick-count & contraction-timer sessions; birth preferences / hospital-bag state.

**D7 thyroid-specific (over the constant core + D1 pregnancy layer):**
- `thyroid_status` {hypothyroid / Hashimoto's / hyperthyroid / Graves' / subclinical / newly-abnormal-in-pregnancy / other}, `thyroid_dx_date`, `dx_context` {pre-existing / found-in-pregnancy}, `antibody_status` {TPO±, TG±, TRAb±}.
- `labs[]` {analyte ∈ {TSH, FreeT4, FreeT3, TPOAb, TGAb, TRAb}, value, unit, ref_range_low, ref_range_high, date, GA_at_draw, source(self/clinic)}.
- `thyroid_meds[]` {drug (levothyroxine/methimazole/carbimazole/PTU/liothyronine), user_entered_dose, schedule, fasting_flag, spacing_flags[] (incl. prenatal-iron/calcium), dose_change_history[] {old_dose, new_dose, date}}.
- `med_adherence[]` {med_id, timestamp, taken, timing_ok}.
- `lab_due_date`, `lab_cadence` (user/clinician-informed), `preg_thyroid_context_shown` (audit that education, not a verdict, was surfaced), `med_review_prompt_shown` (audit of the entry-to-pregnancy educational prompt).
- Provider fields: `ob_provider`, `endo_provider`, `clinician_export_history[]` (dual-clinician).
- `ppt_watch_flag` (set true if antibody-positive → seeds the E7 postpartum-thyroiditis awareness on delivery).

*Data-minimization: collect only what powers a used feature. Lab-report photos (if enabled) stored with strict retention + user-deletable. Reproductive + chronic-disease + medication data together = elevated sensitivity (§K).*

---

## I. Personalization rules (wizard → home config; layered on D1; hidden-but-reachable)

**Onboarding wizard (branch into D7 — extends the D1 pregnancy wizard):**
1. "Are you currently pregnant?" → yes enters/confirms pregnancy mode (D1 base). *(Prior C8 user: auto-carried on positive test — no re-onboarding; see §J.)*
2. EDD or LMP (single source of truth for GA gating).
3. "Any conditions your clinician is watching?" → **Thyroid condition** → sub-pick {hypothyroid/Hashimoto's · hyperthyroid/Graves' · told I have a thyroid problem in pregnancy · not sure} → enables the **thyroid layer** on top of the D1 spine. *(From D1, this same answer recorded mid-pregnancy escalates D1→D7.)*
4. "Do you take thyroid medication?" → seeds `thyroid_meds[]` + reminder setup (fasting/spacing incl. the prenatal interaction).
5. "Do you want to track thyroid labs here?" → enables lab log; offers "add your latest TSH" (carried from C8 if present).
6. "Who's looking after your thyroid — an OB, an endocrinologist, both?" → seeds provider fields + dual-clinician export.
7. Partner sharing? (X2). 8. Notification/privacy preferences (explicit note that thyroid + pregnancy data are special-category health data).

**Home config for D7:**
- Hero = **D1 week-by-week development card** + a **thyroid strip** (latest TSH + next-lab reminder + today's medication status).
- Quick-log row = medication, lab, weight, symptom/mood (+ kick counter in T3).
- **T1 home:** development card + the **"your thyroid and your baby"** reassurance module foregrounded + the entry-to-pregnancy medication-review prompt + early-symptom/warning-signs entry.
- **T2 home:** development card + anatomy-scan/glucose-screen prep (D1) + lab-trend check-in + (Graves') TRAb-monitoring content.
- **T3 home:** development card + kick counter (~28 wk) + contraction timer (later) + birth-prep + **late-pregnancy PPT primer** + warning-signs prominent.
- **Newly-diagnosed-in-pregnancy variant:** lead with the low-literacy "newly told I have a thyroid problem" reassurance sequence; lighter data-entry defaults.
- **Hidden-but-reachable:** full D1 pregnancy library, full-lifespan content, other-condition content — one search/tap away. Nothing locked.

**Adaptive tone:** vigilant-reassuring. Validate her fear *for the baby* without feeding it; always pair honest risk with "monitoring and treatment mitigate this"; never imply her thyroid "will" harm the baby; never turn a lab into a verdict; never reassure away a red-flag symptom.

**Continuity.** C8 thyroid history (labs, meds, antibody status, dx) seeds D7 automatically on the positive test — no re-onboarding; a one-time "your thyroid history is here and private" note.

---

## J. Adaptation triggers (state transitions) — arrives from C8; consistent with the C8 flagship

D7 is the **destination state of C8's flagship transition** (C8 §J.1) and also reachable from D1. The **constant EMR** (§H) is the substrate; each transition re-layers **content, home config, and alert logic** — it never rebuilds her record or drops her history.

### J.1 — INTO D7

| Trigger | Detection | Femio response | Consistency note |
|---|---|---|---|
| **C8 user logs a positive test** (the flagship arrival) | `hpt_results` = positive (or user confirms pregnancy) while thyroid layer active | 1) Celebrate warmly. 2) Suppress fertile-window/OPK/TWW/BBT surfaces. 3) Fire the **thyroid-in-pregnancy educational prompt** ("many people on thyroid medication need a lab check and a **medication review with their clinician** early in pregnancy — contact your clinician soon" — *information + routing, NOT a dose instruction*). 4) One-tap switch to **D7 (thyroid-aware Pregnancy)**. **Lab log + medication log continue uninterrupted; cycle history archived-but-reachable; nothing deleted.** | **Exactly** C8 §J.1: constant EMR, lab/med log continuity, TSH-monitoring alerts tighten to the guideline-described ~every-4-weeks pattern, content re-skins to thyroid-in-pregnancy. |
| **D1 user records a thyroid diagnosis** | User selects a thyroid condition in the "conditions your clinician is watching" flow, or logs thyroid meds/an abnormal TSH note mid-pregnancy | **Additive emphasis** — D1 content stays fully available; the thyroid layer switches on (lab log, med log, thyroid content, monitoring reminders, OB↔endo export). Non-diagnostic framing throughout. | Mirrors D1 §J "thyroid → D7" escalation: additive, never restrictive, never a diagnosis. |
| **Newly abnormal thyroid found at booking bloods** | User records a screen-detected abnormal TSH / antibody result | Gentle low-literacy "newly told I have a thyroid problem" path; educational, heavy reassurance + "discuss with your clinician"; enable lab/med tracking if she starts treatment. | No verdict, no diagnosis — "your clinician is looking into this." |

### J.2 — WITHIN D7 (educational nudges, never diagnosis/prescription)

| Trigger | Femio response |
|---|---|
| **Lab entered outside the guideline-described band** (e.g. TSH logged above range) | **Non-alarming, non-diagnostic** note: "This is outside your lab's reference range — a good thing to discuss with your clinician." **No** verdict, **no** dose suggestion; raise clinician-check + export prominence. |
| **Dose change logged** | Record old→new dose in `dose_change_history`; educational "labs are often re-checked after a dose change — your clinician sets the timing"; **no** commentary on whether the change is right. |
| **Graves'/ATD user** | ATD-specific educational content (PTU-first-trimester landscape, TRAb monitoring) surfaced *as a clinician conversation*; **never** a switch/stop/dose instruction; TRAb-monitoring reminder cadence. |
| **Severe/overlapping symptom logged** (e.g. racing heart) | Route via the red-flag layer to "seek care" — **never** reassure ("that's just your thyroid") and **never** diagnose. |

### J.3 — OUT of D7

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Delivery / birth logged** | User records birth | Transition to **Postpartum**; **retain thyroid lab/med history**; if `ppt_watch_flag` (antibody-positive) or prior thyroid dx, surface **postpartum-thyroiditis awareness** ("some people's thyroid changes in the year after birth — your clinician may re-check; here's what to watch, discuss with them"). Levothyroxine dose often returns toward pre-pregnancy level — *educational, clinician-decided*. | **E7 (postpartum-thyroiditis watch)** / E1 postpartum recovery; E2 if breastfeeding (levo/ATD-and-breastfeeding education, clinician-routed) |
| **Pregnancy loss / stillbirth logged** | User reports loss | Immediate, dignified transition: **stop all pregnancy/milestone reminders instantly**; grief-aware tone; **retain lab/med log** (thyroid care continues through and after loss); if TPO/TG antibodies present, surface *educational, non-alarming* "thyroid antibodies and miscarriage — discuss with your clinician" content (**never blame/verdict**); gentle later path to PAL/RPL. | **Loss/grief (E6)**, then **RPL / Pregnancy-After-Loss (C5/D2)** if applicable (thyroid-flagged; data travels) |
| **Reset / withdraw** | User exits pregnancy mode | Data retained per privacy settings; nothing forced; thyroid tracking can continue in a non-pregnancy endocrine/cycle mode. | Retain, low-touch |

*All routes preserve data continuity (one account, constant EMR), require explicit user confirmation for mode switches, and always end with clinician-referral language — never a diagnosis, prescription, or dose change.*

---

## K. Compliance flags

1. **No prescription / no dosing / no titration / no ATD switching (top guardrail).** Medication logging (levothyroxine, PTU/methimazole/carbimazole) is **self-tracking only.** Femio never recommends, changes, doses, switches, or stops medication. The early-pregnancy "levo often increases ~25–50% / two extra doses a week" and "PTU-first-trimester" teachings are presented as **guideline-described education + "contact your clinician now,"** never instructions. Every med surface carries the non-prescription disclaimer. **[NEEDS SOURCE — confirm current app-store medical-claims wording at ship.]**
2. **No diagnosis / no lab interpretation as verdict.** Labs display **with the user's own reference range** for record-keeping and clinician discussion. Femio never says "abnormal," "you have hypothyroidism," or "your TSH is fine/bad." Out-of-range values trigger *neutral* "discuss with your clinician" language only. Newly-abnormal-in-pregnancy path never states a diagnosis.
3. **No fetal-status verdicts.** Fetal-development content pairs honest risk-of-untreated-disease with the "monitoring mitigates" counterweight; it **never** says "your baby is fine" or "your baby is at risk." Kick counter/contraction timer remain **tracking aids** (per D1), explicitly not tests of fetal wellbeing or labour — avoids medical-device classification.
4. **Red-flag routing, not reassurance theatre.** Thyroid-symptom overlap (palpitations, severe fatigue) is disambiguated toward "seek care now" where warranted; Femio never reassures away a danger sign and never alarms with a diagnosis.
5. **Uncertainty honesty (two axes).** The contested clinical evidence (euthyroid-antibody-positive treatment benefit; the 2.5–4.0 TSH treatment debate; trimester/assay-range variability) must be framed with honest uncertainty — no false precision, no overclaiming a number guarantees an outcome.
6. **Guideline-version + assay integrity.** Pregnancy TSH targets, dose-increase figures, and TRAb-monitoring windows differ by guideline edition (2017 ATA vs. any later update) and by lab assay/trimester. Cite the live primary text at publish; do not hard-code numbers without a reviewed citation. **[NEEDS SOURCE VERIFICATION AT PUBLISH — reconcile 2017 vs 2026 ATA; trimester/assay-specific ranges; levothyroxine spacing intervals from Tier-1.]**
7. **Privacy-by-design — compounded sensitivity.** D7 combines **reproductive/pregnancy data + chronic-disease/lab data + medication data** — an elevated-sensitivity set. Learn from **Flo (FTC 2021)**, **Premom (FTC 2023)**, **BabyCenter (2024 Senate data-broker inquiry)**. No sharing of pregnancy/lab/med data with ad networks, third-party analytics, or employers/insurers; data minimization; explicit, granular, revocable consent; strict retention + user-deletion for lab-report photos. **[NEEDS SOURCE — FTC/Senate primary docs; align to Femio privacy skill / DPA.]**
8. **GDPR / PDPL — special-category health data.** Lawful basis + explicit consent; DSAR/export/delete; regional data-residency (esp. AR/MENA).
9. **Partner mode consent.** Partner sees only granted scope; consent logged, revocable; no partner access to labs/meds unless explicitly shared.
10. **Loss & postpartum handling.** Pregnancy loss → instant reminder suppression, grief-aware UX, thyroid data retained, never blame the thyroid. Delivery → postpartum-thyroiditis awareness (E7) framed as "discuss with your clinician," never a diagnosis or a promise it will/won't happen.
11. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIH/NHS/MedlinePlus) + Tier-2 (ATA pregnancy guidelines / ACOG / Endocrine Society / ASRM), grade 6–8, localized in 4 languages with RTL parity; safety/red-flag copy human-reviewed in all locales.
12. **App-store health-app policy.** Framing as tracking/education keeps out of regulated-device territory; meet Apple/Google health-app + medical-disclaimer requirements; legal review before submission. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

**Clinical — Tier 1 (NIH / NHS / MedlinePlus / gov):**
- [NEJM — Alexander et al., Timing and Magnitude of Increases in Levothyroxine Requirements during Pregnancy in Women with Hypothyroidism](https://www.nejm.org/doi/full/10.1056/NEJMoa040079)
- [PMC (NIH) — Hypothyroidism in pregnancy (review)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3354841/)
- [StatPearls (NCBI) — Thyroid Disease and Pregnancy](https://www.ncbi.nlm.nih.gov/books/NBK538485/)
- [PMC (NIH) — Postpartum thyroiditis: an autoimmune thyroid disorder which predicts future thyroid health](https://pmc.ncbi.nlm.nih.gov/articles/PMC4989649/)
- [PMC (NIH) — Symptoms and Signs Associated with Postpartum Thyroiditis](https://pmc.ncbi.nlm.nih.gov/articles/PMC4227325/)
- [CDC — Urgent Maternal Warning Signs (HEAR HER)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [NHS — Vitamins and Supplements in Pregnancy](https://www.nhs.uk/pregnancy/keeping-well/pregnancy-vitamins-and-supplements/)

**Clinical — Tier 2 (ATA pregnancy guidelines / ACOG / Endocrine Society / ASRM):**
- [ATA — Hypothyroidism in Pregnancy](https://www.thyroid.org/hypothyroidism-in-pregnancy/)
- [ATA — Hypothyroidism in Pregnancy (patient brochure, PDF)](https://www.thyroid.org/wp-content/uploads/patients/brochures/hypothyroidism_pregnancy_brochure.pdf)
- [ATA — Management of Hypothyroidism During Pregnancy: When and how to treat?](https://www.thyroid.org/management-hypothyroidism-pregnancy/)
- [ATA — Hyperthyroidism in Pregnancy](https://www.thyroid.org/hyperthyroidism-in-pregnancy/)
- [2017 Guidelines of the American Thyroid Association for the Diagnosis and Management of Thyroid Disease During Pregnancy and the Postpartum (Thyroid / Liebert)](https://www.liebertpub.com/doi/10.1089/thy.2016.0457)
- [2017 ATA Guidelines (SAGE mirror)](https://journals.sagepub.com/doi/10.1089/thy.2016.0457)
- [ATA — Women with hypothyroidism on levothyroxine may need closer monitoring before pregnancy (Clinical Thyroidology for the Public, Jan 2024)](https://www.thyroid.org/patient-thyroid-information/ct-for-patients/january-2024/vol-17-issue-1-p-3-4/)
- [Management of Hyperthyroidism in Pregnancy: ATA vs. Endocrine Society recommendations — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3674680/)
- [ASRM ReproductiveFacts — Hypothyroidism and pregnancy: What should I know?](https://www.reproductivefacts.org/news-and-publications/fact-sheets-and-infographics/hypothyroidism-and-pregnancy-what-should-i-know/)
- [Cleveland Clinic — Postpartum Thyroiditis](https://my.clevelandclinic.org/health/diseases/15294-postpartum-thyroiditis)
- [Frontiers in Endocrinology (2020) — Systematic review of research after the 2017 ATA pregnancy guidelines](https://www.frontiersin.org/journals/endocrinology/articles/10.3389/fendo.2020.00193/full)

**Thyroid autoimmunity & miscarriage (peer-reviewed):**
- [Effect of antithyroid antibodies on women with recurrent miscarriage: meta-analysis (Wiley, AJRI 2020)](https://onlinelibrary.wiley.com/doi/full/10.1111/aji.13238)
- [Prevalence of Thyroid Autoimmunity in Women with Recurrent Pregnancy Loss — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7912215/)

**Competitor landscape — pregnancy apps:**
- [What to Expect](https://www.whattoexpect.com/) · [BabyCenter](https://www.babycenter.com/) · [Pregnancy+ (Philips)](https://www.philips.com/a-w/mother-and-child-care/pregnancy/pregnancy-app.html)
- [Ovia Cycle & Pregnancy Tracker (App Store)](https://apps.apple.com/us/app/ovia-cycle-pregnancy-tracker/id570244389)
- [Consumer Reports — Best Pregnancy Tracking Apps (privacy analysis)](https://www.consumerreports.org/health/pregnancy-childbirth/best-pregnancy-tracking-apps-a8731130463/)
- [Flo (app) — Wikipedia (FTC settlement, Anonymous Mode, privacy history)](https://en.wikipedia.org/wiki/Flo_(app))

**Competitor landscape — thyroid apps:**
- [ThyForLife — Thyroid Health Community & Tracking App](https://www.thyforlife.com/)
- [BOOST Thyroid — Hashimoto's and Hypothyroid App](https://www.boostthyroid.com/)
- [Paloma Health — New 2026 Guidelines for Hypothyroidism and Pregnancy](https://www.palomahealth.com/learn/new-2026-guidelines-hypothyroidism-and-pregnancy)
- [Hashimoto's Journey (App Store)](https://apps.apple.com/us/app/hashimotos-journey/id6754571242) · [Hashimoto Tracker (Google Play)](https://play.google.com/store/apps/details?id=hashimoto.tracker.thyroid.hormone.log&hl=en)

*Community insight (r/Hypothyroidism, r/Hashimotos, r/thyroidhealth, r/BabyBumps thyroid threads, thyroid-and-pregnancy forums, app-store reviews of both pregnancy and thyroid apps) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. Cross-links: D1 (pregnancy spine), C8 (thyroid-aware TTC / the arrival transition), E7 (postpartum-thyroiditis watch), C5/D2 (loss/RPL). FTC actions vs. Flo (2021)/Premom (2023) and the BabyCenter 2024 Senate data-broker inquiry referenced via D1/C1 privacy sources; verify against primary FTC/Senate docs at implementation. **[NEEDS SOURCE — FTC/Senate primary docs]**. Numeric thyroid targets/dose figures/monitoring windows re-verified against live 2017 (and any 2026) ATA primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH]**.*
