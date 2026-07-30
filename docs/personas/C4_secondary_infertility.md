# C4 — Secondary Infertility (Has a Child, Struggling to Conceive Again)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window features support **conception awareness**, and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, or prevents disease. Screeners are framed as *"screening — discuss results with a clinician."*
> Persona code: **C4** · Cohort: Conception (C) · Last research pass: 2026-07-16

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Rana," 36 |
| **Age band** | ~33–41 (often the *reason* it changed — she conceived #1 in her late 20s / early 30s; she is now past the ACOG/NICE 35 threshold). |
| **Stage** | Trying for another child, 6–18+ months, after ≥1 prior spontaneous conception/birth. No prior fertility treatment for the earlier pregnancy (that's the definition — a prior *unassisted* conception). |
| **Relationship** | Partnered, parenting together; both older than last time; partner may assume "we did it before, we'll do it again." |
| **Goal (top JTBD)** | *"We conceived so easily before — why is it not working now? Tell me honestly what may have changed, help me get evaluated, and stop making me feel like I'm not allowed to be sad."* |
| **Health literacy** | Moderate–high; experienced (she's been pregnant), but her prior *easy* conception is now a false baseline that breeds confusion and self-blame. |
| **Tech context** | Web-first; time-poor. Logs in fragments between school runs, work, bedtime. Likely already has a period/TTC app from last time. |
| **Locale** | Arabic-first / RTL a first-class case; also EN/FR/ES. In AR/MENA markets family-size expectations + "why only one?" social pressure sharpen the pain. |
| **Emotional state** | **Disenfranchised grief** — real loss that society won't validate ("at least you have one"). Guilt (for grieving; toward the child she has), isolation (fits nowhere — not with first-timers, not with the "done" crowd), self-blame ("did I wait too long?"), plus logistical exhaustion of pursuing a workup *while parenting*. |
| **What she is NOT** | Not a first-time TTC user (C1) — do not treat her as a beginner. Not (yet) an ART patient. Not childless — celebratory "your first baby!" framing is a wound, not a delight. |
| **Primary signals** | Cycle length/regularity (may have shifted post-partum/with age), OPK/LH, BBT, CM; increasingly labs & imaging *ordered by a clinician* (day-3 FSH/AMH ovarian reserve, mid-luteal progesterone, HSG, semen analysis). |
| **Success = leaves us because…** | She conceives (→ Pregnancy / PAL mode), OR she moves into assisted treatment and we route her with dignity (→ C10/ART), OR she reaches resolution/acceptance — each with continuity and validation, never a cold hand-off. |

**Persona thesis.** C4 is **whitespace**. Every mainstream fertility app treats *conception* generically and treats *her prior child* as either invisible or as cheerful proof it'll work again. Her defining pain is **emotional and navigational**, not signal-tracking novelty: an invalidated grief no app names, plus the burden of *organizing an evaluation* (labs, imaging, referrals, both partners) around a life that already has a kid in it. Femio wins C4 by being the first product to (1) *name and validate* secondary-infertility grief, (2) educate honestly on *why fertility can change* between pregnancies (age, new conditions, prior-delivery sequelae), and (3) act as a calm **workup navigator** — without ever diagnosing.

---

## B. Needs & questions (voice-of-user)

Mined from r/secondaryinfertility, RESOLVE, and reproductive-grief communities. Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD (secondary infertility):**
1. *"We got pregnant so fast last time — what changed?"* (the central, tormenting question)
2. *"Is it my age? Did I 'wait too long'? Is this my fault?"* (self-blame + age anxiety)
3. *"Could my C-section / tear / infection / D&C last time have caused this?"* (prior-delivery sequelae fear)
4. *"My cycles are different since I had the baby — is that the problem?"* (post-partum cycle change confusion)
5. *"How long do I wait before I get checked? I already have a kid so I feel silly going in."*
6. *"What tests should I even ask for? What order? Do we both need testing?"* (workup navigation)
7. *"How do I track cycles/labs/appointments when I'm already drowning in parenting?"*
8. *"Why do I feel so alone? Everyone says 'at least you have one.'"* (isolation / disenfranchised grief)
9. *"Is it wrong to grieve a baby who doesn't exist when I'm holding one who does?"* (guilt toward existing child)
10. *"How do I answer 'so when's the next one?' at every family gathering?"* (social pressure, acute in AR/MENA)

**Emotional profile — design must respect this (distinct from C1):**
- **Disenfranchised / invalidated grief.** Society (and often her own inner voice) refuses to recognize the loss because she already has a child; grief that gets dismissed "goes underground," heavier to carry. [Shifting Tides; Therapy Group DC]
- **Belonging-nowhere isolation.** Guilt among friends TTC their first; alienation among friends who feel "done." She fits no group; support-group attendance is low precisely because she doubts she's "allowed." [RMA of NY; RESOLVE]
- **Guilt, doubled.** Guilt for wanting more when she "should be grateful," *and* guilt that the pursuit steals attention from the child she has.
- **Self-blame + urgency.** Age is the most cited driver; the "I did it easily before" baseline makes the current struggle feel like personal failure and fuels time-pressure panic. [Cleveland Clinic; Northwestern]

**Anti-needs / trust-breakers (what makes her churn):**
- **"At least you have one" energy** in any copy. Instant abandonment.
- Being treated as a **first-time beginner** (re-explaining what a fertile window is) — condescending given she's been pregnant.
- **Celebratory "your first pregnancy!"** framing that erases her existing child *and* her grief.
- Toxic positivity ("just relax, it'll happen — it did before!").
- Over-medicalizing at month 2, OR the opposite — dismissing her because "you already did it."
- Privacy creep with reproductive + child data (see FTC actions vs. Flo/Premom, §C).

**Feature requests implied by the community:**
- A place where the grief is **named as real** (not minimized).
- Honest, cited education on *what changes between pregnancies*.
- A **workup checklist / question-list to bring to the clinician**, since navigating the evaluation is the practical bottleneck.
- Lab + appointment tracking that fits a parent's fractured schedule.
- Content that explicitly says: *you are allowed to want this and to grieve.*

---

## C. Competitor teardown

Feature-by-feature, viewed through the **secondary-infertility lens specifically**. Key insight for Femio: **no mainstream fertility app addresses secondary infertility's distinct emotional or navigational needs.** They optimize *ovulation prediction for conception in general*; the prior child is invisible, and the disenfranchised grief is unnamed. **This is the clearest whitespace in the conception cohort.**

| App | TTC signal depth | Names/validates secondary-infertility grief? | "Why it changed" education | Workup / lab / appt navigation | Partner mode | Notable privacy / positioning |
|---|---|---|---|---|---|---|
| **Flo** | Basic cycle/statistical; large reach | **No** — generic TTC; content skews first-baby/celebratory | Minimal, generic | No | "Flo for Partners" (light) | **FTC settlement 2021** (data to Facebook/Google); added Anonymous Mode. |
| **Ovia Fertility** | Data-rich (weight, sleep, stress); free tier, employer channel | **No** — generic TTC coaching | Some general fertility content | Light (some appt reminders) | Some visibility | B2B2C via employers; generous free tier. |
| **Glow** | Cycle + strong community/forums | **Partial** — community *may* surface it, but no first-party validation or dedicated pathway | No structured module | No | Partner linking | Community-heavy; **2024 data-breach report** — trust hit. |
| **Premom** | **Best-in-class OPK** photo-reading | **No** — signal-tool focus | No | No | Limited | **FTC settlement 2023** (fertility/period data to analytics); since updated. |
| **Fertility Friend** | **Best-in-class BBT/FAM** charting | **No** — power-user charting, emotionally neutral | No | Chart export only | Sharing | Power-user gold standard; dated UX. |

**The gap (C4's Femio thesis):**
- **Emotional whitespace:** *not one* mainstream app names or validates secondary-infertility grief, or designs for the "belong-nowhere" isolation. Validation currently lives only in therapy blogs, RESOLVE, and Reddit — never *inside the tracking tool she already uses.*
- **Navigational whitespace:** none act as a *workup navigator* (what tests, what order, what to ask, how to track labs/appointments) tuned for a **time-poor parent**.
- **Educational whitespace:** none explain, honestly and cited, *why fertility can change between pregnancies* (age, new conditions, prior-delivery sequelae) — the single question that defines her.
- **Framing failure:** most default to first-baby/celebratory tone that actively *harms* her.
- **Femio combines:** validation-first tone + honest "why it changed" education + a compliant workup navigator + labs/appointment tracking for parents + deep signals when she wants them + privacy-by-design + Arabic-first RTL + one account that already knows her prior pregnancy. **Nobody else does any of this for C4.**

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, or prevent; it educates and helps users track.

**Definition and scope:**
- Secondary infertility describes difficulty conceiving after one or more previous pregnancies. Definitions used by services and studies may differ on duration and prior outcomes, so Femio does not apply a subtype diagnosis.
- The persona publishes no secondary-infertility prevalence or primary-versus-secondary comparison. The current [WHO infertility fact sheet, 28 November 2025](https://www.who.int/news-room/fact-sheets/detail/infertility) provides global context without assigning a personal likelihood.

**Why it can change between pregnancies (the core question):**
- **Age and health can change between attempts.** Femio explains the general age-related trend and why clinicians offer earlier evaluation at older ages without a “cliff,” probability table, or personal prognosis. [ASRM fertility evaluation committee opinion, 2021](https://www.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/).
- **Prior pregnancy, delivery, surgery, infection, and uterine/tubal history** are reasons a clinician may ask more questions or select tests. Femio does not name a cesarean-scar defect as the cause of infertility or infer adhesions.
- **New or progressed conditions since last pregnancy:** ovulatory disorders including **PCOS** (a leading cause), **endometriosis**, **tubal factor** (from PID / chlamydia / gonorrhea), thyroid dysfunction, weight change. [Cleveland Clinic; Medical News Today; Africa meta-analysis: PID/tubal factors among the most common female causes]
- **Both partners are assessed when applicable.** Femio publishes no one-third cause split and does not assign blame.
- **Postpartum/breastfeeding context:** ovulation and cycles can change during lactation and after birth, but Femio gives no months/cycles-to-stability prediction and routes persistent concerns to a clinician.

**WHEN to seek evaluation (routing rule — critical for §J; she often *under*-seeks because "I already have one"):**
- **< 35 y:** evaluate after **12 months** of regular unprotected intercourse without conception. [ACOG; NHS; ASRM]
- **≥ 35 y:** **expedited** evaluation after **6 months**. [ACOG; NICE CG156]
- **≥ 40 y:** more immediate evaluation/treatment. [ACOG]
- **Refer/seek sooner regardless of duration** with known risk factors: irregular/absent cycles, known/suspected tubal/uterine disease, endometriosis, prior pelvic surgery or C-section complication, or a partner with known subfertility. [NICE CG156 — refer at presentation if ≥36 or a known/suspected cause; ASRM]

**What a workup typically includes (so she can navigate it — educational, clinician-ordered):**
- **History + physical**; **semen analysis for the male partner in all couples** (compare to WHO reference values; repeat abnormal test ~3 months later). [NICE CG156; ASRM Fertility Evaluation 2021]
- **Ovulation confirmation:** menstrual history (regular menses ≈ ovulatory) plus **mid-luteal (≈day 21 of a 28-day cycle) serum progesterone.** [NICE CG156]
- **Ovarian reserve:** day-3 FSH/estradiol and/or **AMH**, antral follicle count. [ASRM Fertility Evaluation 2021]
- **Structural/tubal assessment:** **HSG** (or HyCoSy), pelvic ultrasound; hysteroscopy if cesarean-scar defect/adhesions suspected. [ASRM; ACOG Infertility Workup 2019]

*Femio presents all of the above as **education and preparation** — "tests a clinician may discuss/order," "questions to ask" — never as instructions, a workup she should self-order, or a diagnosis.*

**Publication boundary:** subtype prevalence, cause-distribution percentages, cesarean-scar causation, age probability tables, postpartum normalization timelines, and ovarian-reserve verdicts are excluded. Evaluation education follows [ASRM 2021](https://www.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/) and the central [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Validation-first framing engine** — the whole C4 surface leads with *"Your grief is real. Wanting another child, and struggling, is a valid loss — even though you have a child you love."* Copy library scrubbed of "at least"/"grateful"/"first baby" landmines. This is the single most important C4 feature.
2. **"Why it may have changed" education hub** — honest, cited modules on age, prior-delivery sequelae (C-section scar, D&C/adhesions, infection), new conditions (PCOS/endo/thyroid/tubal), male-factor age effects, and post-partum cycle change. Directly answers her defining question.
3. **Workup navigator (compliant)** — a plain-language map of *what a clinician may evaluate* and in *what rough order* (both partners, ovulation, ovarian reserve, tubal/structural, semen analysis), with a **"questions to bring to your appointment" builder**. Explicitly *preparation*, never self-ordering or diagnosis.
4. **Cycle/lab/appointment tracker for parents** — log clinician-ordered results (progesterone, AMH/FSH, HSG, semen analysis) and appointments in a low-friction, time-poor-parent UI; timeline view; export PDF for continuity of care.
5. **Uncertainty-honest fertile-window predictor** — window-with-confidence (not a false single day), tuned for her possibly-shifted/post-partum cycles; awareness-not-contraception language.
6. **Age-aware, non-alarming routing card** — surfaces the 6-mo (≥35) / 12-mo (<35) evaluation thresholds *calmly*, counteracting her tendency to under-seek because "I already have one."

**P1 — Strong differentiators (fast follow):**
7. **BBT + OPK/LH + CM logging** — full signal depth for when she wants it, *without* re-onboarding her as a beginner.
8. **Grief & isolation content pathway** — disenfranchised-grief explainers, "you belong here" content, coping-with-family-pressure (AR/MENA-aware), signposting to professional support/RESOLVE-type resources. Non-clinical, supportive, never therapy-substituting.
9. **Partner mode** — shared window awareness + *shared workup* view (both partners' tests, appointment reminders); consent-gated, revocable; frames male evaluation as normal and equal.
10. **Existing-child-aware personalization** — never erases or over-centers the child; tone acknowledges parenting load (e.g., logging reminders timed around a parent's day).

**P2 — Nice-to-have / later:**
11. Moderated, privacy-safe **secondary-infertility peer space** (the community that fits nowhere else).
12. Cross-cycle chart overlay & pattern insights ("your luteal phase / cycle length vs. before baby").
13. Wearable/device import (Apple Health, temp wearables, OPK strips).
14. Localized family-pressure coaching by market.

**Explicitly OUT of scope for C4 (guardrail):**
- Any "safe days / avoid pregnancy / contraception" mode. **Never.**
- Diagnosing secondary infertility, a cesarean-scar defect, PCOS, low ovarian reserve, or male factor. Screeners/navigator may *educate & route*, never diagnose (§K).
- Instructing her to obtain/interpret specific tests herself, or prescribing a workup. We *prepare her to discuss with a clinician.*

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries citations and "not medical advice / discuss with your clinician." Tone: validating, never "at least."

- **"Your grief is valid" (cornerstone):** naming disenfranchised grief; you can love your child *and* ache for another.
- **"Why it can change between pregnancies":** age & egg quality, honestly explained.
- **"Could my last delivery be a factor?":** C-section scar / isthmocele, D&C/adhesions, post-partum infection — awareness, not self-diagnosis.
- **"New since last time":** PCOS, endometriosis, thyroid, tubal factor, weight — how conditions can emerge/progress.
- **"His side matters too":** male-factor age effects; why both partners get evaluated.
- **"My cycles are different since the baby":** post-partum/breastfeeding cycle changes and prolactin.
- **"When to get checked (even though you have a child)":** the 6-mo/12-mo thresholds, calm, counteracting under-seeking.
- **"What a fertility evaluation looks like":** the workup map + "questions to ask" (preparation).
- **"The fertile window, honestly":** the 6-day window, why we show a *range* (for the experienced user, not a beginner).
- **"When people say 'at least you have one'":** coping scripts, family-pressure (AR/MENA-aware).
- **"You're not alone in this":** isolation, belonging-nowhere, finding support; signposts to professional resources.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so she's never boxed into "TTC only."

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception)

**Logs (inputs):**
- Cycle (period start/end, length history, regularity flags), BBT, OPK/LH (+ photo), CM, intercourse, mood/grief check-in, meds/supplements.
- **Clinician-ordered results** (user-entered): mid-luteal progesterone, day-3 FSH/estradiol, AMH, antral follicle count, TSH, HSG/HyCoSy result, pelvic ultrasound note, **partner semen-analysis** result.
- Appointments (clinic, date, purpose), workup-navigator progress, existing-child context flag.

**Tools:**
- Fertile-window estimator (range + confidence), coverline/thermal-shift detector, LH-progression plotter, DPO/TWW counter (awareness), cross-cycle overlay, **workup navigator + "questions to ask" builder**, **lab/appointment timeline**, PDF export for clinician continuity, age-aware routing card.

**Alerts / nudges (all opt-in, tone-calibrated, revocable, parent-schedule aware):**
- "Your fertile window is *likely* opening — consider intercourse in the next few days." (awareness language)
- "Time to log today's OPK / temperature." (only if she opted into signals)
- "You logged a clinician appointment for Thursday — want to review your questions-to-ask list?"
- "It's been ~6 months trying and you're 35+ — many people talk to a clinician around now. No pressure, and it's not a verdict." (calm routing)
- Grief check-in: gentle, opt-in, never on a celebratory schedule.

**Mandatory compliance wording on every predictive/navigational surface:**
- *"Predictions are estimates based on your data — not a guarantee, and **not a method of birth control**."*
- No "safe/infertile day" language — **ever**.
- Workup navigator: *"This explains what a clinician may discuss or order — it is education to help you prepare, not medical advice or a test to run yourself."*
- Screener/navigator outputs: *"This is a screening/education tool, not a diagnosis. Please discuss with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`, `regularity_flag`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (from screeners, non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamp + "non-diagnostic" tag).

**C4 persona-specific:**
- `prior_pregnancies[]` {outcome, year, mode_of_delivery (vaginal / C-section), complications_noted (user-entered, non-diagnostic), breastfeeding_status}.
- `ttc_restart_date` (drives the 6-mo/12-mo routing clock for *this* attempt).
- `postpartum_cycle_return_date`, `lactation_flag`.
- `bbt_readings[]`, `opk_results[]` {result, line_intensity, photo_ref, ts}, `cm_log[]`.
- `workup_navigator_state` {steps_viewed[], questions_list[]}.
- `lab_results[]` {type: progesterone|FSH|E2|AMH|AFC|TSH|semen_analysis|HSG|ultrasound, value/result, unit, date, source: "user-entered from clinician"}.
- `appointments[]` {clinic, date, purpose, notes}.
- `partner_link_id`, `partner_scope`, `partner_semen_analysis_shared`, `partner_consent_ts`.
- `predicted_window[]` {start, end, confidence}.
- `grief_checkin[]` {ts, state}, `existing_child_context` (flag to gate copy/tone).
- `evaluation_routing_flag` {threshold_met, acknowledged_ts}.

*Data-minimization: collect only what powers a used feature; prior-pregnancy/child and lab data stored with strict retention + user-deletable; user-entered labs are **records, not interpretations**. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C4):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "Have you been pregnant or given birth before?" → **Yes** → sets `prior_pregnancies`, branches C1 → **C4** (experienced, not beginner).
3. "How was that pregnancy conceived?" → *Without fertility treatment* confirms secondary-infertility framing (vs prior ART → different path).
4. "How long have you been trying this time?" → sets `ttc_restart_date`, seeds routing clock.
5. Age capture → sets 6-mo (≥35) vs 12-mo threshold and tone; primes "why it may have changed / age" content.
6. "Any of these since your last pregnancy?" (C-section, D&C, infection, still breastfeeding, new irregular cycles, known condition, partner concern) → tailors "why it changed" hub + soft, non-diagnostic routing; **never** auto-labels "infertile."
7. "How do you want to track?" (signals / labs+appointments / minimal) → enables just those; others stay **reachable**.
8. "Involve a partner?" → partner + shared-workup setup or defer.
9. Consent & privacy choices.

**Home config for C4:**
- Hero rotates between **validation card** (grief acknowledged), **fertile-window card (with confidence)**, and **workup/appointment card** depending on state — *never* a celebratory first-baby hero.
- Quick-log row = her chosen trackers (labs/appointments elevated for the parent who's mid-evaluation).
- Secondary = "why it may have changed" module of the week; questions-to-ask builder; calm routing card if threshold met.
- **Hidden-but-reachable:** full lifespan library, condition pages, contraception *education*, perimenopause — one tap away. Configured, not walled in.

**Adaptive tone:** validating + normalizing from the start; acknowledges the existing child without centering it; escalates *support* (not alarm) as months accumulate; strictly bans "at least"/"just relax"/"first baby" language via the copy-lint layer.

---

## J. Adaptation triggers (state transitions)

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Positive pregnancy test** | `hpt` positive / user confirms | Validate *and* celebrate gently (mindful she may carry anxiety); offer **Pregnancy mode**; pause fertile-window/TWW surfaces; continue folic acid; if prior loss on record, offer **PAL** tone. | Pregnancy persona (or **PAL** if loss history) |
| **Moving to assisted treatment (ART)** | user logs IUI/IVF plan, clinic referral, or ART meds | Shift from workup-navigation to **treatment-companion**; medication/appointment tracking; ART-specific emotional support; suppress "natural window" primacy. | **C10 (ART / assisted treatment)** |
| **6 months, no conception (≥35)** | age ≥35 & `≥6 mo` since `ttc_restart_date` | Calm, non-diagnostic routing card + workup-prep content + export; deepen navigator. Counteract under-seeking. | Clinician referral (educational routing) |
| **12 months, no conception (<35)** | `≥12 mo` & not pregnant | Same, 12-mo threshold. | Clinician referral (educational routing) |
| **Prior-delivery-sequela concern surfaces** | user flags C-section/D&C/infection/adhesion worry | Route to specific "could my last delivery be a factor" content + "questions to ask"; **never** diagnose isthmocele/Asherman. | Condition content + navigator → clinician |
| **Pregnancy loss reported** | user reports loss | Switch tone; grief-aware content; offer **RPL / Pregnancy-After-Loss (PAL)** pathway; suppress celebratory nudges. | **RPL / PAL** persona |
| **Recurrent loss pattern** | ≥2 losses on record | Route to **RPL** content + evaluation-prep; validate compounded grief. | **RPL** persona |
| **Resolution / stepping back** | "taking a break" / "we're done" flag | Pause nudges; validate the decision; keep data; offer wellness/next-life-stage content. | Retain, low-touch (→ other lifespan cohorts) |

*All routes preserve data continuity (one account, incl. her prior-pregnancy history) and always end with clinician-referral language, never a diagnosis. Grief-aware suppression of celebratory nudges is mandatory on loss paths.*

---

## K. Compliance flags

1. **Not contraception (highest-priority guardrail).** Fertile-window features are conception-awareness only. Ban “safe/infertile day” and pregnancy-avoidance framing; every predictive surface says *“not a method of birth control.”* Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). Intended-use limits do not by themselves determine regulatory classification; launch-market legal review remains required. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
2. **No diagnosis / treatment / prevention.** The workup navigator and screeners **educate and prepare** ("tests a clinician may discuss," "questions to ask") — they must never instruct self-ordering/interpretation, diagnose secondary infertility / isthmocele / PCOS / low ovarian reserve / male factor, or prescribe a workup. The 6-mo/12-mo thresholds are *educational routing*, not a diagnosis.
3. **Emotional safety — disenfranchised grief (persona-critical).** C4's defining risk is *invalidation*. A **copy-lint layer** must block "at least you have one," "be grateful," "just relax," and "your first baby" across all surfaces and locales. Grief check-ins opt-in; supportive resources are signposts, **not** a therapy/clinical service. Never a substitute for professional mental-health care; provide crisis/support signposting.
4. **Uncertainty honesty.** Predictions display confidence + "estimate, not a guarantee." No false precision — especially important for her possibly-shifted post-partum/older cycles.
5. **Privacy-by-design / reproductive-data sensitivity.** Cycle, fertility, child-related, and laboratory data are never sent to ad networks or used for targeted advertising. Apply minimum collection, granular/revocable product permissions, purpose-limited processors, and strict retention, export, deletion, and security controls for records/photos under [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). Primary warnings: [FTC Flo](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v). The unverified Glow breach reference is excluded. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Privacy-law implementation.** For EEA processing, fertility and prior-pregnancy health data fall within GDPR Article 9; document an Article 6 basis and Article 9 condition and implement applicable rights. Minimize child-related data and establish its separate purpose/retention. Other markets require launch-country review; no universal compliance or residency promise. ([GDPR official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj); [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
7. **Partner mode consent.** Partner sees only what she grants (incl. shared workup / his own semen-analysis entry); consent logged, scope-limited, instantly revocable.
8. **Medical review + citations.** Evaluation scope and ovarian-reserve caveats follow [ASRM 2021](https://www.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/) and [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). Prevalence, causal, postpartum-timeline, age-probability, and personal reserve interpretations are excluded. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
9. **Existing-child / cultural sensitivity.** Never erase or over-center her child; AR/MENA family-size pressure handled with care; loss and resolution paths grief-aware.
10. **App-store health-app policy.** Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): no diagnosis, fertility-outcome prediction, treatment selection, or result interpretation; substantiate claims and complete current privacy/disclaimer disclosures and Google’s health-app declaration. Re-check both store policies immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

- [Cleveland Clinic — Secondary Infertility: Causes, Signs, Diagnosis & Treatments](https://my.clevelandclinic.org/health/diseases/21139-secondary-infertility)
- [NHS — Infertility](https://www.nhs.uk/conditions/infertility/)
- [WebMD — What to Know About Secondary Infertility](https://www.webmd.com/infertility-and-reproduction/what-to-know-about-secondary-infertility)
- [Medical News Today — Secondary infertility: causes, statistics, treatment](https://www.medicalnewstoday.com/articles/secondary-infertility)
- [RESOLVE: The National Infertility Association — Secondary Infertility](https://resolve.org/learn/infertility-101/underlying-causes/secondary-infertility/)
- [Northwestern Medicine — Facing Secondary Infertility](https://www.nm.org/healthbeat/healthy-tips/emotional-health/facing-secondary-infertility)
- [RMA of New York — The Loneliness of Secondary Infertility](https://www.rmany.com/blog/the-loneliness-of-secondary-infertility)
- [Shifting Tides Therapy NY — Secondary Infertility: The Grief No One Talks About](https://www.shiftingtidestherapyny.com/post/secondary-infertility)
- [Therapy Group DC — Infertility Grief: The Invisible Loss No One Talks About](https://therapygroupdc.com/therapist-dc-blog/infertility-grief-the-invisible-loss-no-one-talks-about/)
- [Psychology Today — The Secondary Infertility Paradox: Love and Longing](https://www.psychologytoday.com/us/blog/beyond-the-womb/202606/the-secondary-infertility-paradox-love-and-longing)
- [ACOG — Infertility Workup for the Women's Health Specialist (2019)](https://journals.lww.com/greenjournal/fulltext/2019/06000/infertility_workup_for_the_women_s_health.47.aspx)
- [ASRM — Fertility Evaluation of Infertile Women: A Committee Opinion (2021)](https://www.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/)
- [NICE CG156 — Fertility problems: assessment and treatment (Recommendations)](https://www.nice.org.uk/guidance/cg156/chapter/recommendations)
- [CCRM — Secondary Infertility: Causes, Signs, Treatment](https://www.ccrmivf.com/secondary-infertility/)
- [PMC — Isthmocele: a neglected cause of secondary infertility and implantation failure](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9107921/)
- [PMC — Primary and secondary infertility in Africa: systematic review with meta-analysis](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7709409/)
- [Oona — Postpartum period changes](https://oonacares.com/postpartum-period-changes/)
- [Go-Go-Gaia — Best Fertility Tracking Apps 2026 (comparison)](https://www.go-go-gaia.com/blog/best-fertility-tracking-app.html)
- [SingleCare — Infertility survey and statistics 2026](https://www.singlecare.com/blog/news/infertility-statistics/)

*Community insight (secondary-infertility and reproductive-grief communities and app reviews) is internal aggregate voice-of-user research and informs tone only. It is not clinical evidence. Global context may cite the [WHO infertility fact sheet, 28 November 2025](https://www.who.int/news-room/fact-sheets/detail/infertility); no secondary-infertility prevalence is published. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
