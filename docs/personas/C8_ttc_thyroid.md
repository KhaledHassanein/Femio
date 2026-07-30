# C8 — TTC with a Thyroid Disorder (Hypothyroidism / Hashimoto's or Hyperthyroidism / Graves')

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window features support **conception awareness**, and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, or prevents disease. TSH/lab and medication logs (e.g. levothyroxine) are **educational self-tracking, never prescriptive** — no dosing advice. Screeners are framed as *"screening — discuss results with a clinician."*
> Persona code: **C8** · Cohort: Conception (C) · Last research pass: 2026-07-17
> **Canonical example of Femio's dynamic adaptation** — see §J. C8 is the flagship illustration of one account carrying a woman from thyroid-aware TTC into a **thyroid-aware pregnancy mode** without losing data, tone, or scope discipline.

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Mariam," 32 |
| **Age band** | ~30–37 (30+ is itself an ATA risk factor for preconception TSH testing; also brushing the ACOG/NICE 35 line that shortens the help-seeking window) |
| **Stage** | Actively trying to conceive, cycle 3–10. Has a **known thyroid disorder** — most often **hypothyroidism / Hashimoto's** on levothyroxine; a substantial minority have **hyperthyroidism / Graves'** on antithyroid drugs (ATDs). |
| **Relationship** | Partnered; wants partner informed but is the one carrying the medical load (labs, meds, appointments). |
| **Goal (top JTBD)** | *"Help me get my thyroid 'ready' before and during trying — track my TSH and my medication, tell me honestly when my fertile days are, and keep my endocrinologist and OB on the same page — without scaring me."* |
| **Health literacy** | High and rising fast. She has already learned "TSH under 2.5 before pregnancy" from forums and wants Femio to be *more* trustworthy and *better sourced* than the Reddit thread that taught her. |
| **Tech context** | Web-first; also phone. Frequently **stacks apps today** — a period/fertility tracker (Flo/Premom) *plus* a separate thyroid tracker (ThyForLife/BOOST/Paloma) *plus* a Notes file of lab values. This stacking is the core pain. |
| **Locale** | Arabic-first / RTL a first-class case; also EN/FR/ES. Thyroid disease and iodine status vary by region; MENA modesty/privacy sensitivity high. |
| **Emotional state** | Anxious-but-organized. Fear that "my thyroid is why it isn't working" and guilt/vigilance about labs and pills. The two-week wait (TWW) compounds with lab-timing anxiety. |
| **What she is NOT (yet)** | Not an infertility patient by definition of her thyroid; not pregnant; not looking for a diagnosis (she has one). Over-medicalizing her *fertility* prematurely, or under-serving her *thyroid*, both churn her. |
| **Primary signals she brings** | Lab values (TSH, Free T4, ± Free T3, TPO/TG antibodies, TRAb for Graves'), medication + timing/fasting adherence (levothyroxine taken fasting, separated from iron/calcium), plus the usual TTC signals (LH/OPK, BBT, CM, cycle). |
| **Success = leaves us because…** | She conceived and **flowed straight into thyroid-aware Pregnancy mode** (§J — the flagship), OR her TTC without-conception clock routed her, with dignity, toward evaluation while her thyroid data traveled with her. |

**Persona thesis.** C8 sits at an **unserved intersection**: fertility apps ignore her thyroid; thyroid apps ignore her cycle and fertile window. She currently duct-tapes two apps and a spreadsheet together. Femio's one-account, referenced, uncertainty-honest, privacy-by-design model is *purpose-built* for exactly this overlap — and her likely trajectory (positive test → pregnancy where levothyroxine needs often rise and TSH must be watched closely) makes her the **canonical proof** that Femio "personalizes, never restricts" and adapts life-stage without ever slipping into prescriptive or diagnostic territory (§J, §K).

---

## B. Needs & questions (voice-of-user)

Mined from r/Hypothyroidism, r/Hashimotos, r/TryingForABaby + thyroid threads, r/xxfitness/thyroid, thyroid-and-fertility forums, and app-store reviews of both fertility apps (Flo/Premom/Ovia) and thyroid apps (ThyForLife/BOOST/Paloma). Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD (thyroid × TTC):**
1. *"Does my thyroid explain why my cycles are weird / why it isn't happening yet?"* (linking symptom → cause without self-diagnosing)
2. *"What TSH number should I be at **before** I get pregnant?"* — she's heard "under 2.5" and wants a sourced, honest answer.
3. *"My TSH was 3.8 — is that 'fine' or 'fine for pregnancy'?"* (the normal-range-vs-preconception-target confusion)
4. *"When exactly do I re-test? My endo says one thing, my OB says another."* (lab-timing + provider-coordination anxiety)
5. *"Do I really increase my levothyroxine the day I get a positive test? By how much?"* (she's read this — wants it *framed as educational, confirm with clinician*)
6. *"Take levo on an empty stomach, wait 30–60 min, keep it away from my iron/calcium/coffee — did I do it right today?"* (adherence mechanics)
7. *"I have Hashimoto's antibodies but 'normal' thyroid — does that raise my miscarriage risk?"* (the euthyroid-TPO-positive worry)
8. *"I'm on methimazole for Graves' — is it safe while trying? Should I switch to PTU?"* (ATD-in-pregnancy fear — strictly *ask your clinician*)
9. *"How do I keep all my labs in one place to actually show my doctor?"* (the export need)
10. *"I'm 9 DPO, exhausted and cold — is that a pregnancy sign or just my thyroid?"* (TWW symptom-spotting tangled with thyroid symptoms)

**Emotional arc (per cycle) — design must respect this:**
- **Pre-window / follicular:** "get the thyroid optimized," lab-and-pill vigilance, planning.
- **Fertile window:** timed-intercourse pressure *plus* "is my thyroid in range for this to count?"
- **Two-week wait (TWW):** double obsession — pregnancy symptom-spotting **and** "if I'm pregnant I need to act on my thyroid *now*." A positive test triggers an immediate to-do (test TSH, review meds with clinician), not just joy.
- **Cycle end:** positive (→ relief + a *new* thyroid-in-pregnancy anxiety) or negative (→ grief + "was it my thyroid?").

**Anti-needs / trust-breakers (what makes her churn):**
- Any app that treats "TSH normal range" and "preconception TSH target" as the same thing.
- A fertility app that has *nowhere to put a lab value* — or a thyroid app that has *no fertile window*.
- Prescriptive tone ("increase your dose to X") — she needs *educational* framing that routes to her clinician; anything that reads like dosing advice both scares her and is out of scope (§K).
- Predictions stated as certainties (fertile day *or* "your TSH will be fine").
- Privacy creep with her reproductive **and** chronic-disease data (post-Flo/Premom FTC distrust).
- Being pushed into "infertility" framing when her issue is a *manageable* thyroid condition.

**Feature requests recurring in reviews/forums:**
- One place for **labs + meds + cycle + fertile window** (nobody offers this — see §C).
- Lab **trend charts** (TSH over time) that she can **export/share** with endo and OB.
- **Medication reminders** with the fasting/spacing rules baked in.
- Honest confidence on the fertile window, *and* an honest "here's what the guidelines say about preconception TSH — discuss with your clinician."
- A gentle prompt on positive test: "many people on thyroid medication need lab re-checks and a medication review early in pregnancy — contact your clinician" (educational, not a dose instruction).

---

## C. Competitor teardown

The decisive finding: **no mainstream app integrates thyroid management with fertility/cycle tracking.** The two categories are entirely separate, and C8 lives in the seam. She stacks one from each column.

### Column 1 — Fertility / cycle apps (strong on TTC, blind to thyroid)

| App | Fertile-window / OPK / BBT depth | Lab handling | Thyroid support | Partner | Privacy / positioning |
|---|---|---|---|---|---|
| **Flo** | Cycle/statistical + TTC mode; manual OPK | No structured lab/TSH tracker | **None** (general symptom logging only) | "Flo for Partners" (light) | **FTC settlement 2021** (data to Facebook/Google); Anonymous Mode; huge reach, shallow chronic-disease depth |
| **Premom** | **Best-in-class OPK** photo reading; LH curves | No lab/TSH tracker | **None** | Limited | **FTC settlement 2023** (fertility data to analytics); Easy@Home ecosystem |
| **Ovia Fertility** | Data-rich (sleep, weight, nutrition) | Some results logging; **owned by Labcorp** (lab-testing conflict-of-interest concern) | **None thyroid-specific** | Some visibility | Employer/health-plan B2B2C data model |
| **Glow** | Cycle + OPK + community | Minimal | **None** | Partner linking | Community-heavy; historic privacy scrutiny |
| **Natural Cycles** | FDA-cleared **contraception** algorithm (BBT) | No | None | Light | Regulated device — **out of Femio scope** |

### Column 2 — Thyroid / Hashimoto's apps (strong on labs/meds, blind to fertility)

| App | Lab tracking (TSH/FT4/FT3/antibodies) | Medication + adherence | Symptom tracking | Cycle / fertile window | Notes |
|---|---|---|---|---|---|
| **ThyForLife** | **Deep** — TSH, T4/FT4, T3/FT3, TG, TGAb; 40+ meds/supplements | Yes | Yes | **None** | Community + trend charts; thyroid-only |
| **BOOST Thyroid** | Deep labs + reference ranges | Meds/supplements, reminders | Symptoms, notes, trends | **None** | Hashimoto/hypo focused |
| **Paloma Health** | Labs + symptom tracker | Reminders | Yes | **None** | Bundled with US telehealth + at-home test kits |
| **Hashimoto's Journey / Hashimoto Tracker** | TSH, FT4, TPO Ab; fasting/timing compliance | Levo/Tirosint/Cytomel adherence | Fatigue/brain-fog ratings | **None** | Endo-shareable reports; thyroid-only |

### Whitespace map (the C8 opening)

- **Fertility depth** lives in Column 1; **thyroid depth** lives in Column 2. **No product spans both.**
- The clinically critical moment for C8 — **a positive pregnancy test, when preconception/first-trimester TSH targets tighten and levothyroxine needs typically rise (§D)** — falls *precisely* in the gap between the two app categories. A fertility app celebrates the positive; a thyroid app never sees it. **Femio catches both** and issues the (educational, clinician-routed) "re-check labs / review medication" prompt neither category can.
- **Nobody** offers: uncertainty-honest fertile window **+** structured TSH/antibody lab trends **+** levothyroxine/ATD adherence with fasting rules **+** endo↔OB-ready export **+** thyroid-aware pregnancy continuity **+** trustworthy privacy **+** Arabic-first RTL, in **one account.** **That seam is C8's Femio thesis.**

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, prescribe, or adjust medication; it educates and helps the user track and prepare for clinician conversations. **All medication/lab content is educational — every dose or target number is presented as "what guidelines describe; confirm with your clinician."**

**Thyroid ↔ fertility & cycles:**
- Thyroid hormone regulates the menstrual cycle and ovulation; **hypothyroidism can cause menstrual irregularity and reduced/impaired ovulation, and these effects are typically reversible with appropriate treatment.** [NHS / Patient.info; Mayo Clinic; ASRM ReproductiveFacts]
- Hyperthyroidism can likewise disturb cycles and fertility. Both directions of thyroid dysfunction warrant optimization before/while trying. [ATA; ASRM]
- **Thyroid autoimmunity (TPO/TG antibodies)** is associated with increased miscarriage and recurrent-pregnancy-loss risk **even in biochemically euthyroid women**; prevalence of thyroid antibodies is markedly higher in RPL cohorts (reported ~17–33%). Whether levothyroxine helps euthyroid TPO-positive women is **debated/controversial** — do not present treatment as established benefit. [Wiley meta-analyses; PMC RPL studies — see Sources]

**Preconception TSH target (educational):**
- ATA guidance: for women with treated hypothyroidism planning pregnancy, adjust levothyroxine to keep **TSH between the lower reference limit and ~2.5 mIU/L preconception.** [ATA "Hypothyroidism in Pregnancy"]
- For thyroid-autoimmune / subclinical pictures: with **positive TPO antibodies**, treatment is generally recommended when **TSH > 4** and may be considered when **TSH 2.5–4.0**; with negative antibodies the recommendation is weaker. Whether TSH in the **2.5–4.5** band harms fertility outcomes remains **actively debated** — frame honestly, not definitively. [ATA; PMC preconception-TSH studies]
- Femio presents these as *guideline-described targets to discuss with a clinician* — **never** as a number the app tells her to "hit."

**Why levothyroxine needs rise in pregnancy (the flagship teaching point for §J):**
- Pregnancy raises **thyroid-binding globulin** and, via **hCG**, transiently stimulates the thyroid; fetal brain development depends on adequate **maternal** thyroid hormone, especially in the first trimester before the fetal thyroid works. So **levothyroxine requirements frequently increase, commonly by ~25–50%.** [ATA; NEJM Alexander et al.; NHS]
- ATA describes that hypothyroid women on levothyroxine can be advised to **independently increase their dose (commonly ~20–30%, e.g. an extra ~2 tablets/week) as soon as pregnancy is confirmed, then notify their clinician for prompt testing.** **Femio surfaces this as education + a "contact your clinician now" prompt — it does NOT instruct a dose change.** [ATA]

**Monitoring in pregnancy (educational):**
- On a positive pregnancy test, Femio prompts the user to contact her thyroid/pregnancy clinician promptly and follow that team’s lab schedule and pregnancy-/assay-specific reference ranges. The app does not display a universal **four-week schedule** or **TSH <2.5 mIU/L** target as personalized advice. Clinical education is versioned to the [2026 ATA guideline](https://doi.org/10.1177/10507256261445624); user-entered results remain uninterpreted. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Hyperthyroidism / Graves' preconception (educational):**
- Women treated for Graves' are generally advised to **stabilize thyroid function before conceiving** (e.g. euthyroid on stable dosing). Antithyroid-drug choice around conception/early pregnancy is a **clinician decision** — guidelines have historically discussed **switching from methimazole/carbimazole to PTU** for early pregnancy because of differing teratogenic risk profiles; **TRAb** monitoring matters because antibodies can cross the placenta. **Femio explains the landscape and routes to the clinician; it never recommends, switches, or doses ATDs.** [ATA "Hyperthyroidism in Pregnancy"; GDATF; 2017 ATA pregnancy guideline]

**Medication mechanics (adherence education, not prescription):**
- **Levothyroxine administration education:** follow the prescription label. Current MedlinePlus drug guidance describes taking levothyroxine on an empty stomach **30–60 minutes before breakfast** and separating **calcium carbonate or ferrous sulfate by at least 4 hours before or after** levothyroxine; NHS guidance likewise advises 30–60 minutes before the first meal or a caffeinated drink. Femio may mirror a user-entered regimen and remind; it never sets or changes the dose. ([MedlinePlus Drug Information](https://medlineplus.gov/druginfo/meds/a682461.html); [NHS, reviewed 6 July 2026](https://www.nhs.uk/medicines/levothyroxine/); reviewed Mohamed K., 23 July 2026.)

**Preconception general (in scope, cross-links C1):** folic acid 400 mcg/day ≥1 month before conception, iodine sufficiency, healthy weight, medication review with clinician. [CDC; ACOG; ASRM]

*Femio applies all thyroid targets/thresholds as **educational context**, always ending "discuss with your clinician" — never as a diagnosis, prescription, or dose instruction.*

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Unified TTC + thyroid home** — one screen that carries the fertile-window card *and* her latest TSH/lab + next-lab reminder + medication status. This single integration is the whole reason C8 switches from her two-app stack.
2. **Lab tracker (thyroid-aware)** — structured entry for **TSH, Free T4, ± Free T3, TPO/TG antibodies, TRAb**, with units, date, and lab reference range; **trend charts over time**; "preconception context" annotation that *educationally* shows the guideline-described ~2.5 target band with a "discuss with your clinician" note (never a pass/fail verdict).
3. **Medication log & reminders (educational)** — levothyroxine or ATD, dose she enters herself, **fasting/timing/spacing reminders** (empty stomach; separate from iron/calcium/coffee), adherence streak. **No dosing suggestions.**
4. **Uncertainty-honest fertile-window predictor** — window + confidence (inherits C1 engine); LH/OPK, BBT confirmation, CM.
5. **Lab-due & re-test reminders** — user- or clinician-informed cadence (e.g. "your endo asked for a re-check around [date]"); on trigger events (positive test), an **educational** "many people need earlier thyroid labs now — contact your clinician" prompt.
6. **Endo↔OB export pack** — one PDF/image with lab trends, med log/adherence, cycle history, and questions — built for handing to **two** coordinating clinicians.
7. **Two-Week-Wait (TWW) module, thyroid-aware** — DPO counter + honest test-timing + gentle disambiguation content ("fatigue/cold can be thyroid *or* early pregnancy — here's what that means," non-diagnostic).

**P1 — Strong differentiators (fast follow):**
8. **Positive-test → thyroid-aware pregnancy pivot** (the §J flagship) — see below.
9. **Partner mode** — consent-gated; partner sees fertile window + optionally "she has a lab/med reminder today" (privacy-scoped).
10. **Symptom–lab correlation view** — descriptive only ("your fatigue logs cluster when TSH was higher"), never causal/diagnostic.
11. **Wearable/import** — Apple Health, temp wearables, OPK strips; manual lab entry always primary.
12. **Preconception optimization plan** — folic acid, iodine sufficiency, "ask about a preconception TSH check," all cited (§D).

**P2 — Nice-to-have / later:**
13. Photo-of-lab-report capture with user-confirmed transcription (private, deletable).
14. Localized clinician-question lists per market (AR modesty-aware).
15. Community / moderated Q&A (privacy-safe).

**Explicitly OUT of scope for C8 (guardrail):**
- **Any dose recommendation, titration, or "increase your levothyroxine by X."** Education + clinician routing only. **Never.**
- Any "safe days / contraception" framing. **Never.**
- Diagnosing thyroid disease, infertility, or interpreting a lab as a verdict (labs are shown with ranges + "discuss with clinician," never "abnormal — you have…").

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each card carries citations + "not medical advice / discuss with your clinician," and — for anything touching meds/labs — an explicit **"educational, not a prescription or dose instruction"** line.

- **Thyroid & fertility 101** — how thyroid hormone affects cycles and ovulation; why treatment usually reverses the effect; hypo vs. hyper.
- **"What TSH target for trying?"** — the guideline-described preconception ~2.5 picture, honestly, with the *debate* acknowledged; normal-range vs. preconception-target explained.
- **Thyroid antibodies & pregnancy** — TPO/TG antibodies, the miscarriage-risk association, and the *unsettled* evidence on treatment in euthyroid women (no overclaiming).
- **Levothyroxine & pregnancy (why the dose often goes up)** — TBG/hCG physiology in plain language; the "labs get checked ~every 4 weeks early on" picture; **"changes are made by your clinician."**
- **Taking levothyroxine right** — empty stomach, timing, spacing from iron/calcium/coffee (adherence education).
- **Graves'/hyperthyroidism & trying** — stabilize first; the ATD/PTU landscape *as a clinician conversation*; TRAb; **never a switch instruction.**
- **The two-week wait with a thyroid condition** — symptom overlap; when to test; what a positive means for your thyroid to-do list (contact clinician).
- **Getting your endo and OB on the same page** — how to use the export pack; questions to ask each; who monitors what.
- **Preconception starter (thyroid edition)** — folic acid, iodine sufficiency, "ask for a preconception thyroid check."
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so C8 never feels boxed into "thyroid-TTC only."

---

## G. Tools, logs & alerts (compliant framing — educational, awareness, not contraception, not prescription)

**Logs (inputs):**
- **Lab log:** TSH, Free T4, Free T3, TPO Ab, TG Ab, TRAb — value + unit + date + lab reference range (user-entered).
- **Medication log:** drug name (levothyroxine / ATD), user-entered dose, time taken, fasting/spacing adherence flags.
- TTC signals: OPK/LH (+photo), BBT (+quality flags), CM, cervical position (optional), intercourse, period flow, HPT result.
- Symptoms (fatigue, cold intolerance, palpitations, mood, etc.), weight/sleep (optional), supplements (iron/calcium/iodine flagged for the spacing reminder).

**Tools:**
- Lab **trend chart** (TSH over time, with reference-range and *educational* preconception-band annotation).
- Fertile-window estimator (range + confidence), coverline/thermal-shift detector, LH plotter, DPO/TWW counter, test-timing helper.
- **Endo↔OB export** (PDF/image) — labs + meds + cycle + questions.
- Symptom–lab correlation view (descriptive only).
- Preconception checklist.

**Alerts / nudges (all opt-in, tone-calibrated, revocable, RTL/localized):**
- "Time to take your medication" + (if relevant) "remember: empty stomach, and keep it away from iron/calcium/coffee." (adherence education)
- "Your next thyroid lab check is coming up around [date]." (user/clinician-set cadence)
- Fertile window: "Your fertile window is *likely* opening…" (awareness language, inherits C1).
- **Positive test (educational):** "Congratulations. Because you take thyroid medication, many people need a thyroid lab check and a **medication review with their clinician** early in pregnancy — please contact your clinician soon." *(Information + routing. NOT a dose instruction.)*
- TWW: "It may still be too early to test — a negative now isn't conclusive."

**Mandatory compliance wording:**
- On lab surfaces: *"Lab values are shown with your lab's reference range for your records — this is not a diagnosis. Discuss results with your clinician."*
- On medication surfaces: *"This log is for your own tracking. Femio does not recommend, prescribe, or change medication or dose. Any change is a decision for you and your clinician."*
- On predictive surfaces: *"Predictions are estimates based on your data — not a guarantee, and **not a method of birth control**."*
- **Never:** "your TSH is abnormal," "increase/decrease your dose," "safe day," or any diagnostic/prescriptive/contraceptive phrasing.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine; carried unchanged across every §J transition):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (screener-derived, non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamped, "non-diagnostic" tagged).

> **Design principle (flagship):** the EMR is **constant**; only the **content, home config, and alert logic layered over it are persona-specific.** When C8 transitions to pregnancy (§J), *no field is dropped* — the lab log, med log, and cycle history all persist; the app simply re-interprets and re-surfaces them for the new stage.

**C8 persona-specific (over the constant core):**
- `thyroid_status` {hypothyroid / Hashimoto's / hyperthyroid / Graves' / other}, `thyroid_dx_date`, `antibody_status` {TPO±, TG±, TRAb±}.
- `labs[]` {analyte ∈ {TSH, FreeT4, FreeT3, TPOAb, TGAb, TRAb}, value, unit, ref_range_low, ref_range_high, date, source(self/clinic)}.
- `thyroid_meds[]` {drug (levothyroxine/methimazole/carbimazole/PTU/liothyronine), user_entered_dose, schedule, fasting_flag, spacing_flags[]}.
- `med_adherence[]` {med_id, timestamp, taken, timing_ok}.
- `lab_due_date`, `lab_cadence` (user/clinician-informed), `preconception_tsh_context_shown` (audit that education, not a verdict, was surfaced).
- `ttc_start_date` (12-mo / 6-mo routing clock, inherited from C1).
- TTC signal fields inherited from C1: `bbt_readings[]`, `opk_results[]`, `cm_log[]`, `intercourse_log[]`, `ovulation_confirmed[]`, `luteal_phase_length[]`, `dpo_current`, `hpt_results[]`, `predicted_window[]` {start, end, confidence}.
- `partner_link_id`, `partner_scope`, `partner_consent_ts`.
- Export artifacts: `clinician_export_history[]`.

*Data-minimization: collect only what powers a used feature. Lab-report photos (if enabled) stored with strict retention + user-deletable. Chronic-disease + reproductive data together = elevated sensitivity (§K).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C8):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "Do you have any ongoing health conditions we should tailor to?" → *Thyroid condition* → sub-pick {hypothyroid/Hashimoto's · hyperthyroid/Graves' · not sure} → enables the **thyroid layer** on top of the TTC base.
3. "Do you take thyroid medication?" → seeds `thyroid_meds[]` + reminder setup (with fasting/spacing rules).
4. "Do you want to track thyroid labs here?" → enables lab log; offers "add your latest TSH."
5. "How long have you been trying?" + age → sets `ttc_start_date`, 12-mo/6-mo threshold, tone.
6. "How do you want to track fertility?" (OPK / BBT / CM / minimal) → enables chosen logs; others stay reachable.
7. "Involve a partner?" → partner-mode setup or defer.
8. Consent & privacy (explicit note that thyroid + reproductive data are handled as special-category health data).

**Home config for C8:**
- Hero = split card: **fertile-window (with confidence)** + **thyroid strip** (latest TSH + next-lab reminder + today's medication status).
- Quick-log row = medication, lab, + chosen fertility trackers (OPK/BBT/CM).
- Secondary = TWW/DPO card post-ovulation; preconception checklist; the most relevant thyroid-×-TTC content module.
- **Hidden-but-reachable:** full lifespan library, contraception *education*, other conditions, pregnancy content — one search/tap away.

**Adaptive tone:** organized-reassuring. Validate her vigilance without feeding anxiety; never imply her thyroid "is" the problem; never turn a lab into a verdict.

---

## J. Adaptation triggers (state transitions) — **FLAGSHIP: dynamic, thyroid-aware life-stage adaptation**

C8 is Femio's **canonical example** of one account adapting across life stages while (a) preserving all data, (b) holding scope discipline (no diagnosis / no prescription / no contraception), and (c) keeping the whole library reachable. The **constant EMR** (§H) is the substrate; each transition re-layers **content, home config, and alert logic** — it never rebuilds her record or drops her history.

### J.1 — The flagship transition: **Positive pregnancy test → thyroid-aware PREGNANCY mode**

| Aspect | Behavior |
|---|---|
| **Trigger / detection** | `hpt_results` = positive (or user confirms pregnancy). |
| **Immediate response (educational, not prescriptive)** | 1) Celebrate warmly. 2) **Suppress** fertile-window/OPK/TWW/BBT surfaces (they no longer apply). 3) Fire the **thyroid-in-pregnancy educational prompt:** *"Because you take thyroid medication, many people need a thyroid lab check and a medication review with their clinician early in pregnancy — please contact your clinician soon."* This is **information + routing**, explicitly **not** "increase your dose by X." 4) Offer one-tap switch to **Pregnancy mode**. |
| **What continues (data continuity)** | The **lab log and medication log continue uninterrupted** — same fields, now surfaced under pregnancy. Cycle history is archived-but-reachable. Nothing is deleted. |
| **What changes (content + alerts, persona-specific over constant EMR)** | • **Alert logic:** lab-cadence reminders **tighten** to the guideline-described pattern (educationally: "labs are often checked around every 4 weeks in early pregnancy — your clinician sets your schedule"). A **medication-review reminder** appears. • **Content library re-skins to thyroid-in-pregnancy:** why levothyroxine needs commonly rise (~25–50%), why first-trimester TSH targets are tighter, why maternal thyroid hormone matters for fetal development, TPO-antibody-in-pregnancy context. All cited (§D), all clinician-routed. • **Home config:** hero becomes pregnancy timeline + **thyroid-in-pregnancy strip** (latest TSH, next lab reminder, medication status). |
| **Guardrails held** | EMR **constant**; content **persona-specific**. Femio still does **not** tell her a dose, does **not** interpret a TSH as pass/fail, and frames every number as "guideline-described — confirm with your clinician." The early-pregnancy dose-increase teaching is presented as *what guidelines describe patients are sometimes advised to do*, paired with **"contact your clinician now,"** never as an app instruction. |
| **Routes to** | **Pregnancy persona (thyroid-flagged)** — carries thyroid_status, antibody_status, labs[], thyroid_meds[] forward; downstream pregnancy content is thyroid-aware (e.g. connects to postpartum-thyroiditis awareness later). |

*Why this is the flagship:* the positive test is the exact clinical moment that **falls in the gap between fertility apps and thyroid apps (§C).** Only a one-account, both-aware, uncertainty-honest, scope-disciplined product can (1) notice it, (2) continue the vitals/lab/med log, (3) tighten thyroid monitoring reminders, (4) swap the content library to thyroid-in-pregnancy, and (5) do all of it **without ever prescribing or diagnosing.** C8 → pregnancy is the reference implementation for every other Femio life-stage adaptation.

### J.2 — Other transitions

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Pregnancy loss reported** | User reports loss | Grief-aware tone; suppress celebratory + pregnancy nudges; **retain lab/med log** (thyroid care continues through and after loss); surface RPL/PAL pathway; if TPO/TG antibodies present, surface *educational, non-alarming* "thyroid antibodies and miscarriage — discuss with your clinician" content (never blame/verdict). | **RPL / Pregnancy-After-Loss** (thyroid-flagged) |
| **TTC paused / stepping back for thyroid optimization** | User sets "not actively trying / optimizing thyroid first" | Pause fertile-window pressure; keep **thyroid endocrine/cycle mode** active (labs, meds, cycle logging, "getting ready" content); no TTC nudges. | **Endocrine/cycle mode** (thyroid, non-TTC) — reachable back to C8 |
| **12 mo no conception (<35) / 6 mo (≥35)** | `now − ttc_start_date ≥ threshold` & not pregnant | Calm, non-diagnostic: "It can be worth talking to a clinician now"; note thyroid as one factor a clinician may review; export pack + eval-prep. | **C2/C3/C4** infertility personas (thyroid data travels) — *educational routing, not diagnosis* |
| **Lab entered outside guideline-described band** | e.g. TSH logged well above range | **Non-alarming, non-diagnostic** note: "This is above your lab's reference range — that's a good thing to discuss with your clinician." **No** verdict, **no** dose suggestion. | Stay C8; raise clinician-check + export prominence |
| **Graves'/ATD user confirms pregnancy** | positive test + ATD in `thyroid_meds[]` | Same flagship pivot **plus** ATD-specific educational content ("antithyroid medication choice in early pregnancy is an important, time-sensitive clinician conversation — contact your clinician promptly"); **never** a switch/stop instruction. | Pregnancy persona (Graves'-flagged) |
| **Disengagement / break** | inactivity / "break" flag | Pause nudges; keep all data; offer wellness/thyroid education low-touch. | Retain, low-touch |

*All routes preserve data continuity (one account, constant EMR), require explicit user confirmation for mode switches, and always end with clinician-referral language — never a diagnosis, prescription, or dose change.*

---

## K. Compliance flags

1. **No prescription / no dosing / no titration (top guardrail for this persona).** Medication logging is self-tracking only. Femio must not recommend, change, calculate, or display a default levothyroxine or antithyroid-drug dose. Pregnancy-related medication content may only say that treatment often needs prompt clinician review; it must not repeat a percentage increase as a user action. Every medication surface carries the non-prescription disclaimer in [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
2. **No diagnosis / no lab interpretation as verdict.** Labs are displayed **with the user's own reference range** for record-keeping and clinician discussion. Femio never says "abnormal," "you have hypothyroidism," or "your TSH is fine/bad." Out-of-range values trigger *neutral* "discuss with your clinician" language only.
3. **Not contraception.** Fertile-window features are conception-awareness only. Ban "safe/infertile day." Every predictive surface carries *"not a method of birth control."* Keeps Femio out of the regulated contraceptive-device lane.
4. **Uncertainty honesty (two axes for C8).** Both fertility predictions **and** the *contested* clinical evidence (e.g. euthyroid-TPO-positive treatment benefit; the 2.5–4.5 TSH debate) must be framed with honest uncertainty. No false precision on ovulation day; no overclaiming that a target number guarantees an outcome.
5. **Guideline-version integrity.** Clinical education is pinned to the [2026 ATA guideline for preconception, pregnancy, and postpartum](https://doi.org/10.1177/10507256261445624) (Thyroid 2026;36(5):481–544). Femio does not hard-code a TSH target, dose increase, iodine amount, or medication-spacing interval as a user action; any such number requires a separately reviewed module and the clinician’s plan. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Privacy-by-design — compounded sensitivity.** C8 combines **reproductive data + chronic-disease/lab data + medication data** — an elevated-sensitivity set. Learn from **Flo (FTC 2021)** and **Premom (FTC 2023).** No sharing of cycle/fertility/lab/med data with ad networks or third-party analytics; data minimization; explicit, granular, revocable consent; strict retention + user-deletion for lab-report photos.
7. **Privacy-law implementation.** For EEA processing, thyroid, fertility, medication, and laboratory data fall within GDPR Article 9; document an Article 6 basis and Article 9 condition and implement applicable rights. Other markets require launch-country counsel review. Do not claim universal “GDPR/PDPL compliance” or residency without approved architecture/contracts. ([GDPR official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj); [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
8. **Partner mode consent.** Partner sees only granted scope; consent logged, revocable; no partner access to labs/meds unless explicitly shared.
9. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIH/NHS/MedlinePlus) + Tier-2 (ATA/ASRM/ACOG/Endocrine Society) primary sources, grade 6–8, localized in 4 languages with RTL parity.
10. **Emotional safety.** Thyroid-TTC anxiety is high (fear "my thyroid is why"; loss + antibody worry). Tone avoids both doom-framing and toxic positivity; loss handled with grief-aware UX; never assign blame to her thyroid.
11. **App-store health-app policy.** Follow [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): no diagnosis, laboratory interpretation, dosing, or treatment selection; provide required disclosures and complete Google’s health-app declaration. Tracking/education framing alone does not determine device status; re-check both store policies and obtain launch-market legal review immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH / NHS / MedlinePlus / gov):**
- [NHS / Patient.info — How an underactive thyroid affects fertility](https://patient.info/news-and-features/how-an-underactive-thyroid-affects-fertility)
- [University Hospitals Sussex NHS Foundation Trust — Pregnancy and hypothyroidism](https://www.uhsussex.nhs.uk/resources/pregnancy-and-hypothyroidism/)
- [Mayo Clinic — Hypothyroidism and infertility: Any connection?](https://www.mayoclinic.org/diseases-conditions/female-infertility/expert-answers/hypothyroidism-and-infertility/faq-20058311)
- [MedlinePlus (NIH) — Pregnancy: Identifying Fertile Days](https://medlineplus.gov/ency/article/007015.htm)
- [NEJM — Alexander et al., Timing and Magnitude of Increases in Levothyroxine Requirements during Pregnancy](https://www.nejm.org/doi/full/10.1056/NEJMoa040079)
- [PMC (NIH) — Thyroid disease in pregnancy (review)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11046508/)
- [CDC — About Folic Acid](https://www.cdc.gov/folic-acid/about/index.html)

**Clinical — Tier 2 (ATA / ASRM / ACOG / Endocrine Society / society guidance):**
- [ATA — Hypothyroidism in Pregnancy](https://www.thyroid.org/hypothyroidism-in-pregnancy/)
- [ATA — Management of Hypothyroidism During Pregnancy: When and how to treat?](https://www.thyroid.org/management-hypothyroidism-pregnancy/)
- [ATA — Hypothyroidism in Pregnancy (patient brochure, PDF)](https://www.thyroid.org/wp-content/uploads/patients/brochures/hypothyroidism_pregnancy_brochure.pdf)
- [ATA — Women with hypothyroidism on levothyroxine may need closer monitoring before pregnancy (Clinical Thyroidology for the Public, Jan 2024)](https://www.thyroid.org/patient-thyroid-information/ct-for-patients/january-2024/vol-17-issue-1-p-3-4/)
- [ATA — Hyperthyroidism in Pregnancy](https://www.thyroid.org/hyperthyroidism-in-pregnancy/)
- [2017 ATA Guidelines for Diagnosis and Management of Thyroid Disease During Pregnancy and the Postpartum (Thyroid / SAGE)](https://journals.sagepub.com/doi/10.1089/thy.2016.0457)
- [ASRM ReproductiveFacts — Hypothyroidism and pregnancy: What should I know?](https://www.reproductivefacts.org/news-and-publications/fact-sheets-and-infographics/hypothyroidism-and-pregnancy-what-should-i-know/)
- [Graves' Disease and Thyroid Foundation — ATA new guidelines on thyroid disease in pregnancy](https://gdatf.org/american-thyroid-association-releases-new-guidelines-on-thyroid-disease-in-pregnancy/)
- [BJOG (2025) — Management of Thyroid Disorders in Pregnancy (Chan et al.)](https://obgyn.onlinelibrary.wiley.com/doi/10.1111/1471-0528.18088)
- [Preconception Counseling in Patients with Hypothyroidism and/or Thyroid Autoimmunity — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9415345/)
- [Pre-Conception Counselling in Graves' Disease — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3821453/)

**Thyroid autoimmunity, fertility & miscarriage (peer-reviewed):**
- [Effect of antithyroid antibodies on women with recurrent miscarriage: meta-analysis (Wiley, AJRI 2020)](https://onlinelibrary.wiley.com/doi/full/10.1111/aji.13238)
- [Prevalence of Thyroid Autoimmunity in Women with Recurrent Pregnancy Loss — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7912215/)
- [Treatment of recurrent pregnancy loss by Levothyroxine in women with high Anti-TPO antibody — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4165956/)
- [Impact of preconceptional serum TSH 2.5–4.5 mIU/L on live birth rates (IUI, unexplained infertility) — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8056662/)
- [Hashimoto's Thyroiditis and Female Infertility: endocrine and ovarian markers — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12250945/)

**Competitor landscape — fertility apps:**
- [Flo](https://flo.health/) · [Ovia Cycle & Pregnancy Tracker (App Store)](https://apps.apple.com/us/app/ovia-cycle-pregnancy-tracker/id570244389)
- [Best Fertility Tracking Apps 2026 (comparison)](https://www.go-go-gaia.com/blog/best-fertility-tracking-app.html) · [Flo vs Clue vs Glow (TTC/PCOS)](https://ovul.ai/flo-vs-clue-vs-glow/)

**Competitor landscape — thyroid apps:**
- [ThyForLife — Thyroid Health Community & Tracking App](https://www.thyforlife.com/) · [Thyroid Tracker ThyForLife (App Store)](https://apps.apple.com/us/app/thyroid-tracker-thyforlife/id1550428415)
- [BOOST Thyroid — Hashimoto's and Hypothyroid App](https://www.boostthyroid.com/)
- [Paloma Health — thyroid app + care](https://www.palomahealth.com/) · [Paloma — New 2026 Guidelines for Hypothyroidism and Pregnancy](https://www.palomahealth.com/learn/new-2026-guidelines-hypothyroidism-and-pregnancy)
- [Hashimoto's Journey (App Store)](https://apps.apple.com/us/app/hashimotos-journey/id6754571242) · [Hashimoto Tracker (Google Play)](https://play.google.com/store/apps/details?id=hashimoto.tracker.thyroid.hormone.log&hl=en)

*Community material is internal qualitative design input only, not evidence for a public clinical or competitor claim. Privacy requirements are grounded in the FTC’s [Flo matter (2021)](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [Premom/Easy Healthcare matter (2023)](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v). Thyroid education is pinned to the [2026 ATA guideline](https://doi.org/10.1177/10507256261445624); consumer targets and dose figures are excluded. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
