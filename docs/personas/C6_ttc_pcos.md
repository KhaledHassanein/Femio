# C6 — TTC with PCOS (Trying to Conceive with Irregular / Anovulatory Cycles)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window features support **conception awareness** and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, or prevents disease. Medication content (letrozole, clomifene, metformin, inositol) is **educational only — never a recommendation or a dose.** Screeners are framed as *"screening — discuss results with a clinician."*
> Persona code: **C6** · Cohort: Conception (C) · Blend of **B6 (PCOS, non-TTC)** + **C1 (TTC, general)** · Last research pass: 2026-07-17

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Mariam," 30 |
| **Age band** | ~27–35 (watches the 35 line, but PCOS is itself a "seek help sooner" red flag — see §D) |
| **Stage** | Actively trying to conceive **with diagnosed or suspected PCOS.** Cycles run 35 to 90+ days, sometimes anovulatory. Bleeding does **not** reliably signal ovulation. |
| **Relationship** | Partnered; wants partner involved. Often carrying years of "just lose weight" dismissal before diagnosis. |
| **Top JTBD** | *"My cycles are all over the place and my ovulation tests are always positive — just tell me, honestly, whether and when I'm actually ovulating, and stop pretending you know my 'day 14.'"* |
| **Health literacy** | High and hard-won. She has researched letrozole, inositol, and metformin already; wants sources, not vibes, and not to be sold a diet. |
| **Tech context** | Web-first + phone. Usually **stacking apps**: a period tracker (Flo/Clue) + an OPK reader (Premom) + often a hormone monitor (Mira/Inito/Oova) + a Notes file for her clinic. |
| **Locale** | Arabic-first / RTL a first-class case; also EN/FR/ES. Modesty + privacy sensitivity high in AR markets. |
| **Emotional state** | The C1 per-cycle arc (hope → TWW anxiety → grief/reset) **amplified and stretched**: a 60-day cycle means a longer, lonelier wait, more "am I even ovulating," and compounded dismissal-trauma from the diagnosis journey. |
| **What she is NOT (yet)** | Not (necessarily) an infertility patient, not on ovulation-induction, not pregnant. But PCOS means the C1 "12-month" clock does **not** cleanly apply — irregular cycles are a "seek help sooner" signal. |
| **Primary devices for signals** | OPK/LH strips (which mislead her — §D), oral BBT, cervical mucus, and increasingly at-home hormone monitors that measure **PdG (progesterone metabolite)** to *confirm* ovulation. |
| **Success = leaves us because…** | She conceived (→ Pregnancy + PCOS mode, GDM-aware), OR she moved to clinician-led evaluation / ovulation-induction (→ C2/C3), OR she started ART (→ C10) — each handed over with dignity and her full data. |

**Persona thesis.** C6 sits exactly at the intersection of Femio's two hardest problems: **PCOS prediction honesty** (B6) and **TTC signal depth + emotional load** (C1). The generic-tracker failure that merely *annoys* B6 ("you're 40 days late") becomes *actively harmful* for C6, because a false-confident fertile window or an always-positive OPK sends her to "time intercourse" on days she may not ovulate, then blames her when it doesn't work. C6 is the strongest proof of Femio's uncertainty-honest thesis: the right answer is often *"we can't predict your window this cycle — here's how to confirm ovulation after it happens, and here's what to bring to your clinician."*

---

## B. Needs & questions (voice-of-user)

Mined from r/PCOS, r/TTC_PCOS, r/TryingForABaby, PCOS-fertility forums, and app-store/device reviews. Phrasing is representative/composite (community norms; not quoting individuals).

**The core prediction/ovulation pain (where B6 and C1 collide):**
1. *"My OPK is positive almost every day — how do I know which surge, if any, is real?"* (chronically elevated / multi-peak LH — §D)
2. *"Am I even ovulating this cycle?"* — the single loudest question; bleeding ≠ ovulation in PCOS.
3. *"The app gave me a 'fertile window' on day 12 of a cycle that turned out to be 74 days long."*
4. *"How do I confirm ovulation actually happened — progesterone? temperature? the PdG monitors?"*
5. *"My temps are chaotic — did I ovulate or is this just PCOS noise?"*
6. *"How often do we even have sex when the 'window' could be anywhere in a 60-day cycle?"* (timed-intercourse fatigue, stretched)

**On lifestyle, weight, and meds — without shame:**
7. *"Everyone says 'lose 5–10%' — I want the real evidence, not another diet lecture."*
8. *"What actually is letrozole vs Clomid, and why would my doctor pick one? Is inositol worth it? What does metformin do for TTC?"* (she wants to walk in informed, not be prescribed by an app)
9. *"I have insulin resistance — I want food/movement info that respects that."*

**On being taken seriously / getting to the right care:**
10. *"It took 4 years to get diagnosed. Now I'm scared it'll take 4 more to get help trying."*
11. *"When do I stop waiting and ask for a referral? The '12-month rule' doesn't fit me."*
12. *"I want one summary — cycle history, ovulation confirmations, labs, questions — to hand my OB/endocrinologist."*

**On the emotional load:**
13. *"A 3-month wait for other people is a 3-cycle wait. My 3 cycles can be 9 months. The grief is longer and quieter."*
14. *"Please don't tell me to 'just relax' or that stress caused this."*

**Anti-needs / trust-breakers (churn drivers):**
- A confident single "ovulation day" or glowing fertile day the app cannot actually know.
- Treating a positive OPK as proof of ovulation.
- Any "safe day / can't get pregnant today" framing (out of scope, and cruel here).
- Diet-first / weight-loss-first messaging as the opening line.
- Being **either** rushed into "infertility/IVF" in month 2 **or** left waiting on a 12-month clock that ignores PCOS.
- Reproductive-data privacy creep (post-Flo/Premom FTC distrust — §C, §K).

**Feature requests recurring in reviews/forums:**
- OPK reading that is *honest about PCOS* (flags baseline-LH ambiguity, doesn't over-call surges).
- A way to **log and interpret confirmation** signals — BBT shift, mid-luteal progesterone, PdG-monitor results — not just prediction.
- Longer-cycle-aware UI that never shows a "late" counter and never assumes day 14.
- Educational, non-prescriptive explainers on letrozole/clomifene/metformin/inositol.
- One exportable visit-prep pack for the OB **and** the endocrinologist.

---

## C. Competitor teardown

C6 is the **worst-served** user in the category because she needs *both* PCOS irregular-cycle honesty *and* TTC confirmation depth — and today no single product does both well. She stacks apps and devices (a period app + Premom + a hormone monitor + a notes file).

| App / device | Irregular / PCOS handling | Ovulation *prediction* honesty | Ovulation *confirmation* depth | TTC + PCOS med education | Privacy / positioning | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Has PCOS/irregular mode, but core UX still centers a predicted cycle + fertile window; TTC-leaning | Low for PCOS — models trained on ~28-day cycles present false-confident dates | Shallow | Light | **FTC 2021 (data to Facebook/Google); ~$56M class settlement (2025)** | Uncertainty-honest window + confirmation layer + privacy-by-design |
| **Clue** | Adapts to variable length better than most; still surfaces predicted window | More conservative, still degrades on highly irregular cycles | Basic BBT | Neutral, thin on PCOS-fertility | Strong GDPR posture | Referenced PCOS-fertility content + confirmation depth + AR/RTL |
| **Ovia Fertility** | Cycle + health tracking; fertility/pregnancy-oriented | Standard predictions | Manual BBT/OPK | Some | Employer/health-plan data model | Non-employer, privacy-first, uncertainty-honest |
| **Premom** | Popular PCOS "AI" + a **6-month PCOS plan**; best-in-class OPK **photo** reader | Still forecasts a window; OPK-centric approach is exactly what misleads in PCOS | Basic BBT; some PdG-strip support | Nutrition-plan leaning | **FTC 2023 (data to analytics firms)**, since updated | Honest about OPK ambiguity in PCOS; confirmation-first; referenced meds education |
| **Mira / Inito / Oova (hormone monitors)** | **Strong** — quantitative LH + estrogen + **PdG/progesterone** confirms ovulation; genuinely helpful in PCOS/anovulatory cycles | Measures actual hormone levels (better than threshold OPKs) | **Best-in-class confirmation** (PdG) | Device-first, thin on lifespan content/education | Hardware + subscription; US-centric; data model varies | Femio **logs/interprets** their outputs inside one lifespan account, adds referenced education + AR/RTL — without selling hardware or making device claims |
| **Fertility Friend / Kindara** | FAM/BBT power-user charting | Retrospective FAM confirmation (good) | **Best-in-class BBT/CM cross-check** | None PCOS-specific | Export / partner sharing | Femio matches confirmation rigor + adds PCOS context, meds education, multilingual, uncertainty-honest prediction |
| **Allara Health** | Real PCOS telehealth (MD + dietitian), incl. fertility | N/A (clinician-led) | N/A | Clinical care | US-only, paid ($125–149/mo), insurance-gated | Femio = accessible web-first education/tracking that *feeds* the clinician visit, globally + Arabic |

**Cross-cutting insight (the C6 opening).** For regular cycles the category's failure is *prediction quality*; for C6 the failure is **the whole prediction-centric paradigm**. When ovulation may not happen and LH is chronically noisy, the honest product pivots from *"here's your fertile day"* to **(1) a wide, confidence-flagged window when data supports one, (2) a strong confirmation layer (BBT shift + mid-luteal progesterone + PdG-monitor logging) to answer "did I ovulate?", and (3) referenced, non-prescriptive education on ovulation-induction so she walks into her clinic informed.** Nobody combines that with privacy-by-design, Arabic-first RTL, and one account that keeps all other women's-health knowledge reachable. **That gap is C6's Femio thesis.**

---

## D. Clinical grounding (cited)

> All claims are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, or prevent; it educates and helps users track. Medication passages are **educational context only.**

**Why standard fertile-window / OPK tools mislead in PCOS (the central teaching).**
- Many women with PCOS have **chronically elevated baseline LH**, so threshold OPKs can read **positive much of the cycle** or show **multiple LH peaks**, producing false-positive "surges." [Ubie clinical note; Inito; Clearblue — Tier-3, corroborated by guideline below]
- **A positive OPK confirms an LH surge, not ovulation.** In anovulatory cycles (common in PCOS) LH can surge without an egg being released. [Premom clinical; Oova]
- **The only hormone that confirms ovulation *occurred* is progesterone.** A **mid-luteal progesterone > ~3 ng/mL** is generally consistent with ovulation; **> ~10 ng/mL** suggests a more robust luteal response. [Oova clinical; corroborate at publish — see NEEDS SOURCE]
- **BBT confirms ovulation retrospectively** (a sustained thermal shift follows the post-ovulation progesterone rise); it does **not predict** forward and is noisier in PCOS. [MedlinePlus; StatPearls — as in C1]
- The **2023 International PCOS Guideline** advises that if OPKs are used, they be **paired with at least one other ovulation signal** (temperature or cervical mucus), acknowledging their reduced reliability in PCOS. [2023 Guideline / Monash summary]
- At-home **quantitative hormone monitors** measuring LH + estrogen + **PdG (a progesterone metabolite)** can help in irregular/anovulatory cycles by *confirming* ovulation rather than only predicting a surge. [Mira; Inito; Natural Womanhood — device landscape]

**When to seek help (routing — PCOS shifts the C1 rule).**
- General rule (C1): evaluate after **12 months** (<35 y) or **6 months** (≥35 y). [ACOG; ASRM; NHS]
- **But** irregular/absent cycles are an explicit **"seek help sooner, regardless of duration"** factor. PCOS-related anovulation is a leading, treatable cause of subfertility, so C6 should be encouraged toward clinician evaluation **earlier**, not made to wait out a 12-month clock. [ASRM; ACOG] Femio applies this as **educational routing**, always ending "discuss with your clinician" — never as a diagnosis.

**Lifestyle & weight (first-line, non-shaming).**
- Lifestyle (healthy eating, ~150 min/wk activity) is first-line; for those with higher weight, **modest weight change (~5–10%)** can restore ovulatory function and improve conception rates — the guideline stresses this **alongside explicit weight-stigma awareness.** [2023 Guideline; ASRM; NHS] Femio frames this as one evidence-based lever, never a mandate or the opening line.

**Ovulation-induction awareness (EDUCATIONAL ONLY — Femio never recommends or doses).**
- **Letrozole is now first-line** pharmacological ovulation induction in PCOS per the **2023 International Guideline and ASRM**; it improves live-birth and ovulation rates vs clomifene and (unlike clomifene) lacks anti-estrogen effects on endometrium/cervical mucus, with lower multiple-pregnancy risk. [2023 Guideline / Monash summary; ASRM; meta-analyses — PMC]
- **Clomifene citrate** (± metformin) is **second-line**; UK guidance caps use at ~6 cycles; it does not achieve pregnancy for a large share of women. [NHS patient info; 2023 Guideline; LOCI trial (HRA)]
- **Metformin** — clinician-considered for metabolic features / as an adjunct; **inositol (myo-inositol)** has low-harm but low-to-moderate-quality evidence and is **explicitly NOT recommended as a stand-alone fertility treatment** by the 2023 update. [2023 Guideline inositol meta-analysis — JCEM/PMC]
- Second/third-line options a clinician may discuss include **gonadotrophins, laparoscopic ovarian surgery (drilling), and ART/IVF** (→ Femio C10 pathway). [2023 Guideline; NHS] All presented as *what guidelines describe*, with clinician routing.

**Pregnancy risk context (why the pregnancy handoff must be GDM-aware).**
- PCOS is associated with **higher odds of miscarriage, gestational diabetes (GDM), gestational hypertension, pre-eclampsia, and caesarean** — and these persist even when **age- and BMI-matched.** [Nature Communications 2024 meta-analysis; PMC]
- The **2023 Guideline** recommends an **OGTT ideally preconception**; if not done, **at the first antenatal visit and repeated at 24–28 weeks**, and that **PCOS status be captured** for anyone planning or newly pregnant. [2023 Guideline; EGOI-PCOS GDM position statement] This seeds the **pregnancy + PCOS (GDM-aware)** handoff in §J.

**Mental health.** PCOS carries significantly higher anxiety/depression and body-image distress; the guideline recommends routine screening. The TTC-with-PCOS combination compounds this (longer cycles = longer waits). [2023 Guideline] Femio surfaces screening + crisis resources, screening-framed.

*Femio scope guardrail restated: all of the above is **wellness education + tracking + "discuss with your clinician."** Femio is not contraception, does not claim to prevent disease, and never prescribes or doses a medication.*

**[NEEDS SOURCE / verify at publish]** — exact mid-luteal progesterone thresholds (ng/mL vs nmol/L by locale/lab); precise letrozole-vs-clomifene live-birth/ovulation effect sizes cite the live 2023 Guideline + primary RCTs (Legro NEJM lineage); OPK "always positive in PCOS" claims currently rest on clinical-blog/device sources — corroborate against a peer-reviewed source before any public claim; NHS/ACOG "irregular cycles = evaluate sooner" exact wording; per-locale crisis directories.

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **PCOS-aware, uncertainty-honest fertile-window predictor.** Inherits C1's range+confidence, but degrades gracefully: on highly irregular/long cycles it may show **no confident window** and say so plainly (*"Your cycles vary too much to predict a window this cycle — here's how to confirm ovulation instead"*). **Never** a single glowing day; **never** a "late" counter.
2. **Ovulation *confirmation* layer (the C6 differentiator).** Combine BBT thermal shift + cervical mucus + **mid-luteal progesterone entry** + **PdG/hormone-monitor result logging** to answer *"did I ovulate?"* retrospectively. Clearly labelled awareness-not-contraception.
3. **PCOS-honest OPK/LH logging.** Log strips (photo-assisted as C1), but **flag baseline-LH ambiguity**: explain multi-peak/chronic-elevation, that a positive = surge ≠ ovulation, and prompt pairing with a second signal. Manual override always available.
4. **Long-cycle-aware TTC UI + TWW.** DPO counter anchored to *confirmed* (not assumed) ovulation; intercourse-frequency guidance that survives a 60-day cycle (*"every 2–3 days across the fertile stretch"* to reduce timed-sex fatigue); anxiety-aware, longer-wait-aware tone.
5. **Ovulation-induction & meds education (educational only).** Referenced explainers: letrozole (first-line) vs clomifene (second-line), metformin, inositol (not stand-alone), weight-lever evidence, gonadotrophins/ART overview. Clear non-prescription disclaimer + clinician routing on every card.
6. **PCOS-aware "when to seek help" routing.** Because irregular cycles = evaluate sooner, surface calm, non-diagnostic evaluation-prep content **earlier** than the generic 12-month clock — without labeling her "infertile."
7. **Dual visit-prep pack.** One exportable/printable summary for **both** the OB/fertility clinic **and** the endocrinologist: cycle history, ovulation confirmations, logged labs, meds/supplements, and questions.
8. **Partner mode.** Invited partner sees confirmation-based windows + "today: yes/maybe/rest," optional male-preconception tips; consent-gated, revocable.

**P1 — Strong differentiators:**
9. Referenced, medically-reviewed **PCOS-and-fertility** content library (AR-first + EN/FR/ES).
10. Insulin-resistance-aware, **non-shaming** lifestyle module (no default weight-loss messaging; weight optional).
11. Mental-health / body-image support (screening + coping), tuned for the longer-wait grief.
12. Lab/result tracker (progesterone, HbA1c/OGTT, AMH, testosterone, thyroid) — entry-only, no diagnosis.
13. Chart/data export (PDF/image) for clinician.

**P2 — Depth / retention:**
14. Cross-cycle overlays + pattern insight ("your confirmed ovulations cluster around CD 30–45").
15. Hormone-monitor integrations (Mira/Inito/Oova/Apple Health) — log/interpret, don't sell hardware.
16. Custom trackables; hirsutism/acne private photo log (carried from B6).

**Explicitly OUT of scope for C6 (guardrail):**
- Any "safe days / avoid pregnancy / contraception" mode. **Never.**
- Diagnosing PCOS, anovulation, or infertility; recommending or dosing any medication. Screeners **flag & route**, never diagnose (§K).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each card carries citations + "not medical advice / discuss with your clinician."

- **PCOS & fertility 101** — why anovulation (not "broken-ness") is the usual TTC barrier, and that it is common and often treatable.
- **Why OPKs mislead with PCOS** — baseline/multi-peak LH, positive ≠ ovulation, pair with a second signal.
- **Did I actually ovulate?** — confirmation via BBT shift, mid-luteal progesterone, and PdG monitors; what each tells you.
- **The fertile window when cycles are long/irregular** — why we sometimes show *no* confident window, and what to do instead.
- **Timing & frequency without burning out** — every 2–3 days across a long fertile stretch; reducing timed-sex pressure.
- **Lifestyle & the weight lever, honestly** — the ~5–10% evidence, insulin-resistance-aware, weight-stigma-aware.
- **Understanding ovulation-induction (education only)** — letrozole vs clomifene, metformin, inositol, gonadotrophins, ovarian drilling, ART — what they are and why a clinician might discuss them. Non-prescription disclaimer.
- **When to see a clinician with PCOS** — why irregular cycles mean *sooner*, what a work-up looks like, how to advocate if dismissed.
- **PCOS in pregnancy — what to know if you conceive** — GDM/OGTT timing, higher-risk awareness, continue folic acid; calm, not alarmist.
- **Preconception starter (PCOS)** — folic acid 400 mcg, OGTT preconception, med/supplement review with clinician.
- **The two-week wait, stretched** — coping with longer, lonelier waits; myth vs real "symptoms."
- **PCOS, TTC & mental health** — normalizing the compounded grief; coping; when to seek support.
- **Reachable-but-hidden library** — full-lifespan women's-health content stays searchable so C6 is configured, not walled in.

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception)

**Logs (inputs):** period/bleed (flow; no "late" language), BBT (value/unit/time + quality flags), OPK/LH (+ photo + PCOS-ambiguity flag), cervical mucus, cervical position (optional), **mid-luteal progesterone / PdG-monitor result**, intercourse, meds/supplements (incl. letrozole/clomifene/metformin/inositol if she's on them), HbA1c/OGTT/AMH/testosterone/thyroid labs (entry-only), mood/energy/sleep, hirsutism/acne (optional), weight (optional, never required), HPT results.

**Tools:**
- PCOS-aware fertile-window estimator (range + confidence, or an honest "no confident window this cycle").
- **Ovulation-confirmation engine** (BBT shift + CM + progesterone/PdG cross-check).
- DPO/TWW counter anchored to *confirmed* ovulation.
- Cross-cycle overlay + pattern insight (descriptive, "appears associated with," never "caused by").
- Dual visit-prep generator (OB + endocrinologist) with standard work-up checklist.
- **Screeners (screening, not diagnosis):** mood/anxiety (PHQ-2/GAD-2 style) → crisis resources on any low screen; PCOS-symptom awareness checklist → "signs to discuss; only a clinician can diagnose."

**Alerts / nudges (opt-in, tone-calibrated, revocable, localized/RTL):**
- "Your cycle data doesn't support a confident window this cycle — here's how to confirm ovulation as it happens." (honesty over false precision)
- "Fertile window is *likely* opening — consider intercourse every 2–3 days." (awareness language, only when data supports it)
- "Thermal shift / progesterone suggests ovulation *likely occurred* — your window is probably closing." (retrospective, honest)
- "It's been 90+ days without a period — many clinicians suggest checking in." (educational, endometrial + evaluation context — carried from B6)
- Preconception: folic-acid reminder; "ask about a preconception OGTT."
- Partner nudge (consent-gated). TWW: "too early to test — a negative now isn't conclusive."

**Mandatory compliance wording on every predictive surface:** *"Predictions are estimates based on your data — not a guarantee, and **not a method of birth control**."* No "safe day / infertile day / you can't get pregnant today" — **ever.** Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."* Medication cards: *"Educational only — Femio does not recommend, prescribe, or dose any medication."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared one-account spine):** `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, consent flags, account mode/state; `cycle`{`period_start`,`period_end`,`cycle_length_history[]`,`flow[]`}; `symptoms[]`,`mood[]`,`meds_supplements[]`,`conditions_flagged[]` (non-diagnostic); `content_history[]`,`screener_results[]` (timestamped, non-diagnostic).

**C6 persona-specific (union of C1 TTC layer + B6 PCOS layer):**
- **From C1 (TTC):** `ttc_start_date`; `bbt_readings[]`; `opk_results[]`{result, line_intensity, photo_ref, **pcos_ambiguity_flag**}; `cm_log[]`; `intercourse_log[]`; `ovulation_confirmed[]`{cycle, method, day}; `coverline[]`; `luteal_phase_length[]`; `dpo_current`; `hpt_results[]`; `partner_link_id`+`partner_scope`+`partner_consent_ts`; `preconception_checklist_state`; `folic_acid_start_date`; `predicted_window[]`{start, end, **confidence** (may be null = "no confident window")}.
- **From B6 (PCOS):** `pcos_status` (diagnosed / suspected / screening) + diagnosis year; `phenotype_hints` (irregular-cycles, hyperandrogenism, prior US/AMH); `hyperandrogenism_log` (hirsutism/acne/thinning); `insulin_resistance_flag`; `prolonged_amenorrhea_counter` (days since last bleed); mental-health screen history.
- **C6-new (confirmation + fertility-meds context):** `progesterone_pdg_log[]`{value, unit, cycle_day, source (lab / monitor)}; `ovulation_induction_context`{agent (letrozole/clomifene/metformin/inositol — self-reported, educational), started_by_clinician: bool}; user-entered labs (progesterone, HbA1c/OGTT, AMH, testosterone, thyroid) — **entry-only, no interpretation as diagnosis**.
- `ttc_intent = true`; `pcos_mode = ON`.

*Data-minimization: collect only what powers a used feature; OPK/hirsutism photos strict-retention + user-deletable; weight optional and never required. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C6).** Reached via wizard Q1→"Trying to conceive"→Q3 flags PCOS/irregular, **or** from B6 (sets TTC), **or** from C1 (PCOS surfaces). Confirmed, reversible.
1. "What brings you to Femio?" → *Trying to conceive.*
2. "How long trying?" → sets `ttc_start_date` (routing clock — but PCOS shifts the threshold, §J).
3. "Do any apply?" → **irregular/absent cycles** and/or **PCOS (diagnosed/suspected)** → set `pcos_mode = ON`, `ttc_intent = true` ⇒ **C6**.
4. Age capture → tone + baseline threshold (still noting PCOS = evaluate sooner).
5. "How do you want to track?" (BBT / OPK / CM / **progesterone-PdG monitor** / minimal) → enables just those; others reachable via "Add tracking."
6. "Are you working with a clinician on ovulation (e.g., letrozole/clomifene)?" → tunes med-education depth + confirmation prominence (never prescriptive).
7. Partner? → partner-mode setup or defer. Consent & privacy choices.

**Home config for C6:**
- Hero = **confirmation-first card**: either a confidence-flagged window *or* an honest "no confident window this cycle → confirm ovulation" prompt + today's action. **No "late" counter, no assumed day 14.**
- Quick-log row = her chosen signals (BBT / OPK / CM / progesterone-PdG / intercourse).
- Secondary = TWW/DPO (anchored to *confirmed* ovulation); PCOS-fertility content; visit-prep; lifestyle-and-meds education card.
- **Hidden-but-reachable:** full lifespan library, contraception *education*, gynae conditions, perimenopause — one search/tap away.

**Adaptive tuning:** early = optimistic/light; as long cycles accumulate, tone shifts to validating/normalizing (never alarmist, never toxic-positive). Recurring 90+ day amenorrhea → raise endometrial-awareness + evaluation-prep (B6-carried). Low mood screens → surface mental-health module + resources. If she logs an ovulation-induction agent, foreground confirmation tools + the matching educational content.

---

## J. Adaptation triggers (state transitions)

C6 **inherits all universal events** from the Master Adaptation Model §6 (positive-test handler, pregnancy-loss/Gentle-Mode, mood-crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). Only the **C6-specific** transitions are specified below. All require explicit user confirmation, preserve data continuity (one account), and always end with clinician-referral language — never a diagnosis.

**Arrivals into C6 (blend entry points):**

| Trigger | Detection | Femio response | Route from → to |
|---|---|---|---|
| **B6 user sets TTC intent** | B6 user toggles "start trying" | Confirm; add C1 TTC layer (BBT/OPK/CM/confirmation, TWW, preconception) **on top of** existing PCOS mode; keep uncertainty caveats; surface PCOS-and-fertility education | **B6 → C6** (PCOS mode retained, TTC layer added) |
| **C1 user's PCOS surfaces** | irregular/anovulatory pattern over logged cycles, always-positive OPK pattern, or user reports PCOS diagnosis | Non-diagnostic offer: "Your cycles look irregular / PCOS may change how we predict — want PCOS-aware tools?"; add PCOS layer + confirmation-first UI | **C1 → C6** (TTC retained, PCOS layer added) |

**Exits out of C6 (universal-informed, PCOS-flavored):**

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Positive pregnancy test** | `hpt_results` positive / user confirms | Universal positive-test handler: celebrate (tone-matched), **suppress fertile-window/OPK/BBT/TWW**, carry all data, re-confirm privacy scope. Carry **PCOS metabolic context → GDM-aware**: surface OGTT-timing education (preconception/first visit/24–28 wk), higher-risk awareness, continue folic acid. | **Pregnancy + PCOS (GDM-aware)** — D-track, PCOS modifier |
| **No conception + PCOS "seek sooner" threshold** | irregular/anovulatory cycles + duration trying (earlier than the generic 12-mo/6-mo clock, per §D) | Calm, non-diagnostic card: "With irregular cycles, many clinicians suggest evaluating sooner." Deepen confirmation + labs; offer dual visit-prep + chart export; foreground ovulation-induction *education*. **Never** auto-label "infertile." | **C2 / C3** (infertility evaluation personas) **with PCOS context retained** — educational routing, not diagnosis |
| **Starts ART (IUI / IVF)** | user reports starting assisted reproduction | Add ART pathway layer; carry PCOS + all TTC data; retain confirmation/lab logs; adjust content to cycle-monitoring/ART education | **→ C10** (ART), PCOS-flagged |
| **On clinician-led ovulation induction** | user logs letrozole/clomifene/metformin as clinician-started | Foreground *educational* meds content + confirmation tools (is this cycle ovulatory?); no dosing, no verdicts | Stay C6, induction context ON |
| **Pregnancy loss reported** | user reports loss | Universal loss handler: **instant** suppression of celebratory/milestone nudges, Gentle Mode, grief resources, retain data (incl. PCOS care), no re-prompting, date-control for anniversaries | **→ E6 grief**, later optional **C5 / D2 (PAL)**; PCOS care retained |
| **Recurring 90+ day amenorrhea while trying** | `prolonged_amenorrhea_counter` recurs | Non-alarming clinician-check + endometrial-awareness + evaluation-prep (B6-carried) | Stay C6, raise screening prominence |
| **Mood screen low / crisis flag** | screener threshold / crisis flag | Universal handler: mental-health module + localized crisis resources; screening-framed | Stay C6 |
| **Toggles off PCOS mode or TTC** | user setting | Revert to the matching band (C1 if TTC-only; B6 if PCOS non-TTC; general otherwise); preserve all history | → C1 / B6 / general band |
| **Disengagement / "taking a break"** | inactivity / break flag | Pause nudges, keep data, low-touch wellness content | Retain, low-touch |

**Blend note (per Master §8).** C6 is itself a worked modifier blend — `TTC ⊕ PCOS`. Most-acute emphasis wins the hero (TTC action / confirmation), while the PCOS layer supplies the irregular-cycle prediction logic, the "seek help sooner" threshold, and the metabolic context that pre-loads the **pregnancy ⊕ PCOS (GDM-aware)** handoff. Distinct paths stay distinct: C6→C2/C3 (evaluation) is kept separate from C6→C10 (already in ART), keyed on whether assisted reproduction has started.

---

## K. Compliance flags

1. **Not contraception (highest-priority guardrail).** Fertile-window + confirmation features are conception-awareness only. Ban "safe/infertile day," "you can't get pregnant today," any pregnancy-avoidance framing. Every predictive surface: *"not a method of birth control."* Keeps Femio out of the regulated contraceptive-device lane. **[NEEDS SOURCE — confirm store medical-claims + FTC health-claims wording at ship.]**
2. **No diagnosis / treatment / prevention.** Screeners flag & route; the "seek help sooner" and 12-/6-month cues are *educational routing*, not an infertility or PCOS diagnosis. Never outputs "You have PCOS" or "You are infertile."
3. **Medication content (letrozole / clomifene / metformin / inositol / gonadotrophins):** educational context only — what they are, why a clinician might discuss them, current first-line/second-line framing as *what guidelines describe.* **No recommendation, no dosing, no "take this."** Clear non-prescription disclaimer + clinician routing on every med surface.
4. **Uncertainty honesty (elevated stakes in PCOS).** Predictions display confidence and may honestly show **no window**; OPK surfaces must flag PCOS ambiguity (positive = surge ≠ ovulation). No false precision — a false-confident window here can drive misdirected timed-intercourse and blame.
5. **Ovulation *confirmation* framing.** Progesterone/PdG/BBT confirmation is educational retrospective awareness, never a fertility guarantee or contraceptive signal.
6. **Weight / body image.** Weight fields optional, never required; no default weight-loss messaging; the ~5–10% lever presented evidence-based + weight-stigma-aware per 2023 guideline; never the opening line.
7. **Mental health.** Crisis resources on any low screen; localized per region/language; tone aware of the compounded, longer-wait grief.
8. **Privacy-by-design / reproductive-data sensitivity.** Learn from category history — **Flo (FTC 2021), Premom (FTC 2023).** No sharing of cycle/fertility/hormone data with ad networks or third-party analytics. Data-minimization; explicit, granular, revocable consent; strict retention + user-deletion for OPK/hirsutism photos and hormone-monitor data; partner scope revocable.
9. **GDPR / PDPL — special-category health data.** Lawful basis + explicit consent; DSAR/export/delete; regional data-residency (esp. AR/MENA). Every transition exposing a new data class (e.g., pregnancy handoff) re-confirms sharing scope. **[NEEDS SOURCE — align to Femio privacy skill / DPA at implementation.]**
10. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1/Tier-2 primary sources, grade 6–8, four locales with RTL parity. Numeric claims (progesterone thresholds, letrozole/clomifene effect sizes, weight %, GDM/OGTT timing) re-verified against live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH.]**
11. **App-store health-app policy.** Framing as tracking/education (not device/diagnosis) keeps out of regulated-device territory — legal review before store submission.

---

## Sources

**Clinical — Tier 1 (NIH / CDC / NHS / MedlinePlus / gov):**
- [Polycystic ovary syndrome — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/a-z-topics/polycystic-ovary-syndrome)
- [PCOS | MedlinePlus (NIH)](https://medlineplus.gov/polycysticovarysyndrome.html)
- [MedlinePlus — Pregnancy: Identifying Fertile Days](https://medlineplus.gov/ency/article/007015.htm)
- [StatPearls (NCBI) — Physiology, Ovulation and Basal Body Temperature](https://www.ncbi.nlm.nih.gov/books/NBK546686/)
- [CDC — About Folic Acid](https://www.cdc.gov/folic-acid/about/index.html)
- [NHS HRA — LOCI: Letrozole Or Clomifene for Ovulation Induction](https://www.hra.nhs.uk/planning-and-improving-research/application-summaries/research-summaries/loci-letrozole-or-clomifene-for-ovulation-induction/)
- [NHS (East & North Herts) — Fertility Treatment using Clomifene Tablets (patient info PDF)](https://www.enherts-tr.nhs.uk/wp-content/uploads/2020/02/Fertility-Treatment-Clomifene-Tablets-v1-02.2020-w.pdf)

**Clinical — Tier 2 (2023 international PCOS guideline / ESHRE / ASRM / ACOG / peer-reviewed):**
- [2023 International Evidence-based Guideline for the Assessment and Management of PCOS — Human Reproduction](https://academic.oup.com/humrep/article/38/9/1655/7241786)
- [PCOS Guideline Summary 2023 (Monash, patient/clinician summary PDF)](https://www.monash.edu/__data/assets/pdf_file/0003/3371133/PCOS-Guideline-Summary-2023.pdf)
- [2023 PCOS Guideline recommendations — ASRM practice guidance](https://www.asrm.org/practice-guidance/practice-committee-documents/recommendations-from-the-2023-international-evidence-based-guideline-for-the-assessment-and-management-of-polycystic-ovary-syndrome/)
- [ASRM — Optimizing Natural Fertility: A Committee Opinion](https://www.asrm.org/practice-guidance/practice-committee-documents/optimizing-natural-fertility-a-committee-opinion-2021/)
- [ACOG — Trying to Get Pregnant? Here's When to Have Sex](https://www.acog.org/womens-health/experts-and-stories/the-latest/trying-to-get-pregnant-heres-when-to-have-sex)
- [Inositol for PCOS: Systematic Review & Meta-analysis informing the 2023 Guideline — JCEM](https://academic.oup.com/jcem/article/109/6/1630/7504796) · [PMC mirror](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11099481/)
- [Letrozole vs clomiphene as first-line ovulation induction in PCOS (RCT) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3604833/)
- [Letrozole + clomiphene vs letrozole alone for ovulation induction in PCOS: systematic review/meta-analysis — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12097446/)
- [Systematic review & meta-analysis of pregnancy outcomes in women with PCOS — Nature Communications (2024)](https://www.nature.com/articles/s41467-024-49749-1) · [PMC mirror](https://pmc.ncbi.nlm.nih.gov/articles/PMC11224312/)
- [Gestational diabetes mellitus and PCOS — position statement from EGOI-PCOS — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11825335/)
- [GDM in the setting of PCOS: a systematic review — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10793469/)

**Ovulation tracking / confirmation in PCOS (clinical blogs + device landscape — Tier-3, corroborate before public claims):**
- [How to Confirm Ovulation with PCOS (When OPKs Don't Work) — Oova](https://www.oova.life/blog/how-to-confirm-ovulation-with-pcos)
- [Temperature Tracking and PCOS: how BBT confirms ovulation — RHM Gynecology](https://rhmgyn.com/blog/bbt-pcos-ovulation)
- [PCOS and Anovulation: Are You Actually Ovulating? — Premom](https://premom.com/pcos-anovulation-and-ovulation-tracking/)
- [Why PCOS OPKs are always positive & next steps — Ubie Doctor's Note](https://ubiehealth.com/doctors-note/pcos-false-positive-opk-ovulation-test-steps-37-rx33e1)
- [Using Ovulation Tests with PCOS: Can You Trust the Accuracy? — Inito](https://blog.inito.com/ovulation-tests-with-pcos/)
- [PCOS — Clearblue](https://www.clearblue.com/fertility/pcos)
- [Pros and cons of Mira, Inito, Kegg and other femtech devices — Natural Womanhood](https://naturalwomanhood.org/femtech-device/)

**Competitor / app + device landscape:**
- [Premom — Ovulation Tracker, PCOS (App Store)](https://apps.apple.com/us/app/premom-ovulation-tracker-pcos/id1279295922)
- [Premom — PCOS fertility tracker 6-month plan](https://premom.com/pcos-fertility-tracker-6-month-plan/)
- [Inito vs Mira: I Tried Both Monitors — The PCOS Nutritionist Alyssa](https://pcosnutritionistalyssa.com/inito-vs-mira/)
- [6 of the Best Apps and Devices for Tracking Ovulation — MyOva](https://www.myovacare.com/blogs/news/best-apps-devices-for-tracking-ovulation)
- [Allara Health (telehealth for PCOS + fertility)](https://www.allarahealth.com/)
- [Tommy's — PCOS & Fertility: symptoms, treatment & tests](https://www.tommys.org/pregnancy-information/planning-a-pregnancy/fertility-and-causes-of-infertility/pcos-and-fertility-everything-you-need-know)

**Patient-journey / community insight:** r/PCOS, r/TTC_PCOS, r/TryingForABaby, and PCOS-fertility forums synthesized as aggregate voice-of-user (representative phrasing, not individual quotes). FTC actions vs. Flo (2021) and Premom (2023) referenced via the B6/C1 sibling specs; verify against primary FTC press releases at implementation. **[NEEDS SOURCE — FTC primary docs; peer-reviewed corroboration for OPK "always positive in PCOS" and mid-luteal progesterone thresholds before any public claim.]**
