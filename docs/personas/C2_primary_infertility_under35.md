# C2 — Primary Infertility, Under 35 (Clinical-Evaluation Phase)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Femio never diagnoses, treats, or prevents disease, and is **not contraception**. Fertile-window features are **conception awareness, not birth control**. Screeners and thresholds are framed as *"screening / education — discuss with your clinician."* Femio does not run, order, or interpret medical tests; it helps a user **organize, understand, and prepare** for a workup her clinician directs.
> Persona code: **C2** · Cohort: Conception (C) · Last research pass: 2026-07-16

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Rana," 31 |
| **Age band** | Under 35 (below the ACOG/NICE/ASRM 35 threshold — so her formal evaluation clock is **12 months**, not 6) |
| **Stage** | **Primary infertility**: ≥12 months of regular, unprotected intercourse, no conception, **no prior pregnancy ever**. Now entering the **clinical-evaluation / workup** phase. |
| **Relationship** | Partnered. Both partners are being worked up (male factor is ~30–50% of couples — semen analysis is a first-line test, not an afterthought). |
| **Goal (top JTBD)** | *"Help me understand what all these tests mean, keep my cycles/labs/appointments in one place, walk into my specialist visit prepared, and hold me steady — without false hope or clinical coldness."* |
| **Health literacy** | High and rising fast. She has moved past "line-eye" and is now Googling AMH ranges, HSG, and post-coital myths. She wants **referenced** answers, not forum guesses. |
| **Tech context** | Web-first; also phone. Likely arriving from a period/ovulation tracker (Flo/Premom/Fertility Friend) that has stopped being useful now that "just time it better" is no longer the answer. |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. In many AR/MENA markets infertility carries acute social stigma and is often (wrongly) framed as a "woman's problem" — privacy and dignity are paramount. |
| **Emotional state** | Strained. Cyclical grief, self-blame, shame, identity threat, "why is this happening to us," and the specific exhaustion of the diagnostic limbo — lots of waiting between tests and results. 30–40% of women in fertility workup/treatment report clinically significant anxiety or depression. |
| **What she is NOT** | Not (yet) an ART/IVF patient (that's **C10**). Not diagnosed by Femio — a workup is a *clinician's* job. Not someone to be told "just relax" or "it'll happen." |
| **Primary signals she brings** | Cycle history, BBT/OPK archives, and now **clinical data**: mid-luteal progesterone, AMH/AFC, TSH/prolactin, partner's semen analysis, HSG result, ultrasound findings, appointment dates. |
| **Success = she leaves us because…** | She conceives (→ Pregnancy, often flagged Pregnancy-After-Infertility), OR she starts IUI/IVF (→ **C10** ART), OR a loss occurs (→ **RPL/PAL**) — each transition handled with data continuity and dignity. |

**Persona thesis.** C2 is where the conception cohort **stops being a tracking problem and becomes a comprehension, organization, and emotional-endurance problem.** Trackers optimize timing; C2 has already timed everything and it hasn't worked. Her unmet needs are: (1) *decode the workup* in referenced, plain language; (2) *one trusted home* for cycles + labs + appointments + partner's results; (3) *specialist-visit preparation*; (4) *emotional support that is neither toxic-positive nor clinically cold.* No mainstream app owns this phase — they are built for the person still trying to conceive on her own, and quietly abandon her the moment she needs a clinic. C2 is Femio's chance to be the app that **doesn't leave when it gets hard.**

---

## B. Needs & questions (voice-of-user)

Mined from r/infertility, r/TTC30, r/TryingForABaby (graduating-to-workup threads), fertility-clinic patient blogs, and app-store reviews. Phrasing is representative/composite (community norms; not quoting individuals).

**Decode-the-workup questions (the acute information hunger):**
1. *"We hit 12 months — what actually happens now? What's the standard order of tests?"*
2. *"What is an HSG, will it hurt, and what does it actually check?"* (tubal patency)
3. *"My AMH came back 'low for my age' — does that mean I can't get pregnant naturally?"* (a huge, often-misunderstood fear — see §D)
4. *"What day do I get the progesterone / 'day 21' blood test, and what is it confirming?"*
5. *"His semen analysis is 'abnormal' — what do count/motility/morphology numbers mean, and should he repeat it?"*
6. *"What's day-3 FSH/estradiol/LH for vs. AMH? Why so many hormones?"*
7. *"When does the GP/OB refer us to an actual fertility specialist (REI)?"*
8. *"They said 'unexplained infertility' — how can there be nothing wrong and still no baby?"*

**Organization & logistics pain:**
- *"I have results in three portals, a lab PDF, screenshots, and my memory — I need it in one place before the appointment."*
- *"I always forget half my questions in the 15-minute consult."*
- *"Which test happens on which cycle day? I keep missing the timing window and losing a whole month."*

**Emotional-arc needs (design must respect this):**
- The diagnostic phase is **limbo**: bursts of activity (tests) separated by long, anxious waits for results and appointments — *"periods of intense activity and waiting, high hopes and profound disappointments."*
- Cyclical grief every failed cycle — *grief no one else sees*; self-blame, shame, threat to identity/femininity, strain on the couple, and a shrinking support network.
- She is surrounded by pregnancy announcements and "have you tried…" advice. She needs a space that is **honest but not bleak, warm but not saccharine.**

**Anti-needs / trust-breakers (churn drivers):**
- Toxic positivity ("just relax and it'll happen," "my friend adopted and then got pregnant").
- Clinical coldness — numbers and probabilities with no human tone.
- **False hope OR false doom** — being told a single low AMH means she'll never conceive (untrue and cruel), or being handed a glowing "you're totally fine!" that ignores a real workup.
- Any app that keeps cheerfully predicting a "fertile window" and pushing "time it better!" as if timing were the unsolved problem.
- Being labeled/diagnosed by an app. She wants help *understanding* a clinician's findings, not an algorithm's verdict.
- Privacy creep — reproductive + now **clinical** data is even more sensitive (post-Flo/Premom FTC distrust).

**Feature requests recurring in reviews/forums:**
- A place to log **labs and test results** (AMH, progesterone, FSH, TSH, semen analysis, HSG) with plain-language "what this means" context.
- An **appointment + questions organizer** and an exportable visit-prep summary for the specialist.
- A **workup roadmap / checklist** so she knows what's done, what's pending, and what to ask for next.
- Partner inclusion that treats **male-factor testing as equal**, not a footnote.
- Referenced content she can trust more than a forum.

---

## C. Competitor teardown

Feature-by-feature, focused on **where each app fails at the diagnostic/evaluation phase and at emotional support** — the two things C2 needs most. Key insight: the mainstream trackers are *timing* tools; the clinic apps are *logistics* tools locked to one clinic. **Nobody** owns the independent, referenced, emotionally-intelligent evaluation-phase companion.

| App | What it's built for | Diagnostic/evaluation-phase support | Lab & test-result handling | Emotional support | Where it fails C2 |
|---|---|---|---|---|---|
| **Flo** | Mass-market cycle + fertile-window prediction | Minimal. Keeps predicting a fertile window; "Secret Chats" community exists but is generic | No structured lab/workup log | Community + some content; not evaluation-phase-specific | Keeps optimizing *timing* she's already exhausted; no workup roadmap; **FTC 2021** data-sharing legacy erodes trust for clinical data |
| **Ovia Fertility** | Data-rich fertility scoring, employer/health-plan channel | Some "when to see a doctor" content; still fertility-score-centric | Limited; not a clinical-results home | Coaching content, health-plan tie-ins | Employer/health-plan data model is a red flag for stigma-sensitive users; not built to hold a full workup or a specialist visit |
| **Glow** | Cycle + community + fertility | Community threads on testing/IVF exist | Weak structured lab tracking | Strong peer community (double-edged: support *and* anxiety) | No referenced clinical roadmap; historic privacy scrutiny; community can amplify false hope/doom |
| **Premom** | Best-in-class OPK photo reading (Easy@Home) | Essentially none — it's an ovulation-detection tool | No | Minimal | Purpose-built for *timing*; **FTC 2023** settlement over data sharing; abandons her exactly at the workup |
| **Fertility Friend** | Deep BBT/FAM charting, power-user "chart stalking" | Charts can be exported for a clinician, but no workup guidance | Manual notes only | Long-standing forums | Dated UX; still a *charting* tool; no lab decoding, no visit-prep, no emotional layer |
| **Fertility-clinic companion apps** (e.g., clinic-branded patient apps, Kindbody/Ivy-style, EngagedMD-type consenting) | Managing an *active* treatment cycle at a specific clinic | Strong **once you're a patient at that clinic** — meds, monitoring, portal | Clinic's own results, siloed to that clinic | Task reminders, some education | **You must already be a clinic patient.** No help in the *pre-referral / choosing-a-path* limbo; not portable; not referenced-independent; not multilingual/Arabic-first |

**The fragmentation map (the opening for Femio):**
- **Timing depth** (Premom / Fertility Friend / Flo) is irrelevant to C2's actual blocker.
- **Clinic apps** only start working *after* referral and lock her into one provider's silo.
- **Community** (Glow / Flo Secret Chats) provides warmth but also false hope, false doom, and misinformation.
- **Nobody** offers: a **referenced, uncertainty-honest workup companion** + a **portable clinical-results & appointment home** + **specialist-visit prep** + **evaluation-phase-specific emotional support** + **Arabic-first/RTL** + **privacy-by-design for clinical data** + **one account that carries her forward into ART / pregnancy / loss without starting over.** *That is C2's Femio thesis.*

---

## D. Clinical grounding (cited)

> All claims below are **patient-education framing**. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, order tests, or interpret results — it explains, in plain language, what a clinician-directed workup involves and routes every specific concern to "discuss with your clinician."

**Definition & when evaluation is warranted (the routing rule — critical for §J):**
- **Infertility** = failure to achieve pregnancy after **12 months of regular, unprotected intercourse** (or **6 months if the female partner is ≥35**). [WHO; ASRM; NICE; ACOG] *Primary* infertility = no prior pregnancy ever.
- **< 35 y (C2):** evaluate after **12 months.** [ACOG; NICE; ASRM]
- Evaluate **without delay**, regardless of duration, with a known risk factor (irregular/absent cycles, known male-factor, prior pelvic infection/surgery, endometriosis, suspected tubal or uterine disease). [ASRM Fertility Evaluation of Infertile Women, 2021; ACOG]

**Why both partners are evaluated:**
- Causes may involve ovulation, the uterus or fallopian tubes, the male partner, more than one factor, or remain unexplained after evaluation. The evaluation therefore includes ovulatory status, female reproductive-tract structure and patency, and semen evaluation where applicable. Femio does not publish a universal cause-distribution percentage. [ASRM *Fertility Evaluation of Infertile Women* (2021)]

**The standard female workup (education only — a clinician directs it):**
The ASRM evaluation includes assessment of **ovulatory status, reproductive-tract structure and patency, and semen evaluation of the male partner** where applicable. [ASRM *Fertility Evaluation of Infertile Women* (2021)]
- **Ovulation:** in people with regular 21–35-day cycles, added testing to confirm ovulation is generally not required unless another clinical indication is present. If a clinician orders mid-luteal progesterone, the clinician sets timing relative to the expected next period; Femio does not hard-code “day 21.” [ASRM (2021)]
- **Ovarian-reserve testing (such as AMH or antral follicle count):** is an adjunct in an infertility evaluation and helps predict **response to ovarian stimulation**. It is not a screening test for people who do not meet infertility criteria, and a poor result does not necessarily imply inability to conceive naturally. Femio never interprets an individual value. [ASRM (2021)]
- **Tubal patency:** **hysterosalpingography (HSG)** assesses uterine cavity morphology and fallopian-tube patency; alternatives include HyCoSy/sono-HSG or laparoscopy in selected cases. [ASRM 2021; ACOG 2019]
- **Thyroid/prolactin and other hormones** (TSH, prolactin, and day-3 FSH/estradiol/LH in some circumstances) as clinically indicated. [ACOG 2019]

**The male workup (equal first-line):**
- **Semen analysis** is a primary first-line test; an abnormal result should generally be **repeated/confirmed** before conclusions. Endocrine testing (FSH, testosterone) is **not** routine first-line but is indicated with oligospermia or clinical signs. [AUA/ASRM Diagnosis and Treatment of Infertility in Men guideline]

**When to refer to a specialist (REI):**
- After the duration threshold (12 mo <35), or **sooner** with red-flags; NICE and ASRM support onward referral to specialist services once first-line investigation indicates a problem or thresholds are met. [NICE NG257; ASRM 2021]

**Emotional impact (grounds the support features):**
- Women in fertility evaluation/treatment report **depression and anxiety at roughly 30–40%**, higher than the general population; infertility-related distress is frequently compared to that of serious medical illness. Themes: anxiety, mood disturbance, threat to self-esteem/identity, couple strain, weakened support network. [ASRM/MHPG; MDPI review; ACOG committee statement on infertility disparities/access]

*Femio applies these as **educational routing and organization**, always ending "discuss with your clinician" — never as a diagnosis, test order, or result interpretation.*

Medical-review resolution: cause framing, workup scope, ovulation-test timing, and ovarian-reserve caveats follow [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). No public lab cutoffs or individual result interpretation. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Workup roadmap / "Understand your evaluation"** — a referenced, step-by-step, *non-diagnostic* map of the standard couple's workup (ovulation, ovarian reserve, tubal patency, semen analysis), showing *what's typically checked and why*, with a per-item "discuss with your clinician" footer. Marks each item **done / pending / to ask about** — never "you need this test."
2. **Clinical-results & lab home (self-entered)** — one place to record AMH/AFC, mid-luteal progesterone, day-3 FSH/E2/LH, TSH/prolactin, HSG result, ultrasound findings, and the **partner's semen analysis** — each with a plain-language "what this measures" explainer (education, **not interpretation of her value**).
3. **Specialist-visit prep pack** — auto-generated, exportable/printable summary: cycle history, logged results, timeline, and a **question list** (curated + her own). Directly answers "I forget half my questions."
4. **Cycle-day-aware test-timing helper** — non-alarming reminders tied to *her* cycle for time-sensitive tests her clinician has ordered (e.g., "your clinician mentioned a mid-luteal progesterone draw — that's typically ~7 days before your expected period; here's your estimated window — confirm the exact day with them"). Prevents losing a cycle.
5. **Emotional-support layer (evaluation-phase-specific)** — warm, non-toxic-positive daily/weekly cards calibrated to the *limbo* arc (waiting for results, after a failed cycle, before a big appointment), a mood/anxiety **screener** (screening-framed, with localized crisis resources), and coping content. Explicitly avoids "just relax."
6. **Uncertainty-honest framing everywhere** — especially the **AMH ≠ can't-conceive-naturally** message; no false hope, no false doom.
7. **Partner mode with equal male-factor footing** — partner can log/see the **semen analysis** and male-workup content, share the appointment calendar, and receive partner-facing support content; consent-gated, revocable.

**P1 — Strong differentiators (fast follow):**
8. **Referenced content library** on every workup component (HSG, AMH, semen analysis, unexplained infertility) — grade 6–8, 4 languages, RTL-first.
9. **Appointment & follow-up organizer** — visits, which cycle day, what was ordered, what's pending, results due.
10. **"Unexplained infertility" explainer & next-steps education** — one of her highest-anxiety, lowest-information moments.
11. **Timeline view** — a single narrative of her journey (cycles + tests + appointments) she can show any provider (portable, not clinic-locked).
12. **Chart/data export (PDF/image)** for any clinician of her choosing.

**P2 — Nice-to-have / later:**
13. Moderated, privacy-safe community for the evaluation phase (guarded against false-hope/doom misinformation).
14. Couple's shared journal / decision-notes.
15. Cost/coverage education (region-aware; ACOG flags access disparities) — **education only**.
16. Localized, stigma-aware AR/MENA content (infertility framed as a couple's medical matter, not a woman's failing).

**Explicitly OUT of scope for C2 (guardrail):**
- Ordering, running, or **interpreting** any medical test or result (Femio explains categories; only her clinician interprets *her* numbers).
- Diagnosing infertility, its cause, or "unexplained infertility." Screeners **flag & route**, never diagnose (§K).
- Any "safe day / avoid pregnancy / contraception" framing. **Never.**
- ART/IVF cycle management (meds, stims, monitoring) — that is **C10**.

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries source citations, a medical-review byline + date, and "not medical advice / discuss with your clinician."

- **"You've hit 12 months — what happens now?"** — the evaluation trigger and what a workup is (calm, non-alarming, non-diagnostic).
- **The couple's workup, explained** — ovulation, ovarian reserve, tubal patency, semen analysis; *what each checks and why*, and that **both partners** are evaluated.
- **Understanding an HSG** — what it is, what it checks (tubal patency), what to expect, questions to ask.
- **AMH & ovarian reserve — what it does and doesn't tell you** — the critical caveat: predicts stimulation response, **not** natural-conception chance; a "low" number is not a verdict. [NICE; PMC]
- **The "day 21" / mid-luteal progesterone test** — what it confirms (ovulation) and why timing matters.
- **Making sense of a semen analysis** — count/motility/morphology categories, why abnormal results are often repeated, male-factor is common and treatable-in-context. (Partner-facing variant.)
- **"Unexplained infertility" — what it means and doesn't mean** — reframing the "nothing's wrong but nothing's working" distress.
- **When and how referral to a fertility specialist (REI) works.**
- **Getting the most from your specialist visit** — how to prepare, what to bring, questions to ask, how to advocate.
- **The emotional side of the wait** — normalizing grief/anxiety/limbo, coping strategies, couple communication, when to seek mental-health support. [ASRM/MHPG]
- **Stigma-aware module (AR/MENA-first)** — infertility as a shared medical matter; privacy and dignity.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so C2 never feels boxed into "infertility only."

---

## G. Tools, logs & alerts (compliant framing)

**Logs (inputs):**
- Cycle/bleed log, BBT/OPK/CM (carried from C1 if present), intercourse, symptoms/mood.
- **Clinical results (self-entered, entry-only, never machine-interpreted):** AMH, AFC, mid-luteal progesterone, day-3 FSH/E2/LH, TSH, prolactin, HSG result, ultrasound/AFC notes, **partner semen analysis** (count/motility/morphology/volume).
- Appointments, ordered-tests, referral status, questions-for-visit.
- Mood/anxiety screener history (scores + dates, screening-only).

**Tools:**
- Workup-roadmap tracker (done / pending / to-ask).
- Clinical-results home with plain-language category explainers.
- Specialist-visit prep generator (one-tap export/print).
- Cycle-day-aware test-timing helper (for clinician-ordered, time-sensitive tests).
- Timeline view; PDF/image export.
- Mood/anxiety screener (PHQ-2/GAD-2-style) → screening-framed output + localized crisis resources.

**Alerts / nudges (all opt-in, tone-calibrated, dismissible, revocable, RTL-aware):**
- "Your clinician mentioned a mid-luteal draw — your estimated window is around [dates]; confirm the exact day with them." (awareness, not instruction)
- "Appointment with Dr. [X] in 2 days — want to finish your questions list?"
- "Results waiting to be logged? Add them so your next visit summary is complete."
- Emotional-arc cards: pre-appointment steadying, post-failed-cycle grief-aware, results-waiting anxiety support.
- Screening follow-up (e.g., re-check mood in N weeks) + crisis resources on any low screen.
- **Never:** contraception/"safe day" language; never "your AMH means you can't conceive"; never "you have [diagnosis]"; never disease-prevention claims; never "you need test X."

**Mandatory compliance wording on relevant surfaces:**
- *"Femio helps you organize and understand your evaluation — it does not order tests or interpret your results. Only your clinician can do that."*
- Any fertile-window/ovulation surface retained from C1: *"Estimate based on your data — not a guarantee, and **not a method of birth control**."*
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (from screeners, non-diagnostic).
- `content_history[]`, `screener_results[]` (with timestamp + "non-diagnostic" tag).

**C2 persona-specific:**
- `ttc_start_date` and `infertility_type` = `primary` (no prior pregnancy) — drives the 12-mo routing + tone.
- `evaluation_phase_flag` = true; `workup_roadmap_state[]` {item, status: done/pending/to_ask}.
- `labs[]` {test_type (AMH, AFC, progesterone_midluteal, FSH_d3, E2, LH, TSH, prolactin, etc.), value, unit, date, source_note} — **entry-only, no diagnostic interpretation**.
- `partner_semen_analysis[]` {count, motility, morphology, volume, date, repeat_flag} (partner-shared, consent-gated).
- `imaging_results[]` {type (HSG, TVUS), finding_note, date}.
- `appointments[]` {clinician, type, cycle_day, ordered_tests[], results_due, status}.
- `referral_status` {stage: GP/OB / referred / REI-consult-booked}.
- `visit_questions[]`, `visit_prep_exports[]`.
- `mood_screen_history[]` {tool, score, date} (screening-only).
- `emotional_state_tags[]` (waiting / post-failed-cycle / pre-appointment) — drives support-card selection.
- `partner_link_id`, `partner_scope`, `partner_consent_ts`.

*Data-minimization & heightened sensitivity: clinical/lab data is special-category health data with **elevated** stigma risk; encrypted, user-deletable, never shared with ad networks/analytics; retention limits on any uploaded lab PDFs/photos. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C2 — often arriving as a route from C1):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "How long have you been trying?" → **≥12 months** ⇒ candidate for C2.
3. "Have you ever been pregnant before?" → **No** ⇒ `infertility_type = primary` (distinguishes from secondary-infertility persona).
4. Age capture → **under 35** ⇒ 12-mo threshold + calibrated tone.
5. "Where are you in the process?" (still trying on our own / starting tests / seeing/booked with a specialist) ⇒ sets `evaluation_phase_flag` and home emphasis.
6. "Any of these apply?" (irregular/absent cycles, known condition, partner known issue, prior pelvic surgery/infection) → raise relevant content + "consider earlier evaluation" (educational, not a diagnosis).
7. "Involve a partner?" → partner-mode setup with **male-factor equality** framing.
8. Consent & privacy choices (with explicit clinical-data sensitivity notice).

**Home config for C2:**
- Hero = **workup roadmap** (done/pending/to-ask) + next appointment + "prep your questions."
- Secondary = clinical-results home; emotional-support card matched to current `emotional_state_tag`; latest relevant content module.
- **De-emphasize** the C1 fertile-window hero (timing is no longer her blocker) — keep it **reachable**, not front-and-center, and never as her primary narrative.
- **Hidden-but-reachable:** full lifespan library, condition pages, contraception *education*, perimenopause — one search/tap away.

**Adaptive tone:** validating, steady, honest. Escalate emotional-support prominence around waits, failed cycles, and big appointments; surface mental-health module + resources if mood screens trend low. Never toxic-positive, never doom.

---

## J. Adaptation triggers (state transitions)

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Arrives at 12-mo threshold (from C1)** | `now − ttc_start_date ≥ 12 mo`, `<35`, not pregnant, no prior pregnancy | Calm, non-diagnostic hand-off from C1: "It can be worth talking to a clinician now." Activate workup roadmap, results home, visit-prep, emotional layer. | **Become C2** (this persona) |
| **IUI / IVF / ART begins** | user logs/reports starting stimulation, IUI, or IVF cycle | Sensitive confirm; hand off to ART experience (meds/monitoring/cycle management) while carrying all C2 data forward. | **C10 — ART / IVF persona** |
| **Positive pregnancy test** | `hpt` positive or user confirms | Celebrate carefully; offer switch to **Pregnancy mode**, flagged **pregnancy-after-infertility** (heightened anxiety); retire prediction/timing widgets; carry workup context. | Pregnancy persona (PAI-flagged) |
| **Pregnancy loss reported** | user reports loss | Switch tone; grief-aware content; suppress celebratory nudges; offer **RPL / Pregnancy-After-Loss (PAL)** pathway. | RPL / PAL persona |
| **"Unexplained infertility" outcome** | user records this result | Surface the dedicated explainer + next-steps education + emotional support; **no diagnosis by Femio**. | Stay C2, raise support + education prominence |
| **Red-flag / early-eval indicator** | irregular/absent cycles, known male factor, prior tubal/uterine issue, endometriosis | Educational "consider earlier evaluation"; raise relevant condition modules; **never** auto-label "infertile." | Stay C2 + condition modules |
| **Mood screen trends low / crisis flag** | screener threshold crossed | Surface mental-health module + localized crisis resources; screening-framed. | Stay C2 |
| **Taking a break / stepping back** | inactivity or "pause" flag | Pause nudges; preserve all data; offer gentle wellness content. | Retain, low-touch |

*All routes preserve data continuity (one account) and always end with clinician-referral language, never a diagnosis, test order, or result interpretation.*

---

## K. Compliance flags

1. **No diagnosis / treatment / prevention; no test ordering or interpretation (highest-priority guardrail for C2).** Femio helps a user *organize and understand* a **clinician-directed** workup. It never says “you need test X,” interprets an individual lab value, or diagnoses infertility or its cause. The 12-month threshold is educational routing; results fields are entry-only with category-level education. This clinical scope follows [ASRM’s 2021 evaluation framework](https://www.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/); app-store and device-classification review remains a separate pre-submission legal task.
2. **Not contraception.** Any retained fertile-window/ovulation surface is conception-awareness only, carries *"not a method of birth control,"* and never uses "safe/infertile day" language — keeping Femio out of the regulated contraceptive-device lane.
3. **Uncertainty honesty / no false hope or false doom.** Especially the **AMH ≠ inability to conceive naturally** message [NICE; PMC]. Predictions display confidence; no false precision; no "you can't conceive" and no "you're totally fine" absolutes.
4. **Clinical-data privacy (elevated sensitivity).** Laboratory and partner semen-analysis data are never sent to ad networks or used for targeted advertising; each partner authorizes their own data. Apply minimum collection, granular/revocable product permissions, purpose-limited processors, and strict retention, export, deletion, and security controls for uploads under [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). Primary warnings: [FTC Flo](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
5. **Privacy-law implementation.** For EEA processing, fertility, laboratory, and partner health data fall within GDPR Article 9; document an Article 6 basis and Article 9 condition, complete a DPIA where Article 35 requires it, and implement applicable rights. Each partner authorizes their own data. Other markets require launch-country review; no universal compliance/residency promise. ([GDPR official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj); [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Partner mode consent + male-factor equality.** Partner sees only granted scope; consent logged, scope-limited, instantly revocable. Male-factor testing framed as equal and routine, never as blame.
7. **Medical review + citations.** Cause framing, workup scope, ovulation-test timing, and ovarian-reserve caveats are pinned in [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). Translation must preserve the meaning and be locale-QA’d before publication. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
8. **Emotional safety.** The evaluation phase carries clinically significant distress (30–40% anxiety/depression; comparable to serious illness). Tone must avoid both doom and toxic positivity; crisis resources on any low mood screen; loss handled with grief-aware UX.
9. **Stigma-aware localization.** AR/MENA-first framing treats infertility as a shared medical matter, not a woman's failing; maximum privacy/dignity by default.
10. **App-store health-app policy.** Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): no diagnosis, laboratory interpretation, treatment recommendation, or outcome guarantee; substantiate health claims; provide required disclosures/clinician prompts and complete Google’s health-app declaration. Re-check both store policies and obtain launch-market legal review immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH/CDC/WHO/NHS/MedlinePlus/gov):**
- [WHO — Infertility (fact sheet)](https://www.who.int/news-room/fact-sheets/detail/infertility)
- [NICHD (NIH) — What are some possible causes of female infertility?](https://www.nichd.nih.gov/health/topics/infertility/conditioninfo/causes/causes-female)
- [NICE NG257 — Fertility problems: assessment and treatment — Investigation of fertility problems and management strategies](https://www.nice.org.uk/guidance/ng257/chapter/Investigation-of-fertility-problems-and-management-strategies)
- [UF Health — Female Infertility (cause distribution)](https://ufhealth.org/conditions-and-treatments/female-infertility)

**Clinical — Tier 2 (ASRM / ESHRE / ACOG / AUA / peer-reviewed):**
- [ASRM — Fertility Evaluation of Infertile Women: a committee opinion (2021)](https://integration.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/)
- [ACOG — Infertility Workup for the Women's Health Specialist (Obstetrics & Gynecology, 2019)](https://journals.lww.com/greenjournal/fulltext/2019/06000/infertility_workup_for_the_women_s_health.47.aspx)
- [AUA/ASRM — Diagnosis and Treatment of Infertility in Men: Guideline Part I (2020)](https://www.asrm.org/practice-guidance/practice-committee-documents/diagnosis-and-treatment-of-infertility-in-men-auaasrm-guideline-part-i-2020/) · [AUA copy](https://www.auanet.org/guidelines-and-quality/guidelines/male-infertility)
- [Diagnosis and Management of Infertility: A Review (PubMed)](https://pubmed.ncbi.nlm.nih.gov/34228062/)
- [Hysterosalpingographic evaluation of primary and secondary infertility (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4641280/)
- [Ovarian reserve does not influence natural conception: insights from infertile women (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11485058/)
- [AMH/AFC as predictors of natural fecundability (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6371573/)

**Emotional / patient-journey (society + peer-reviewed):**
- [ASRM — Psychological Counseling](https://www.asrm.org/topics/topics-index/psychological-counseling) · [ASRM Mental Health Professional Group — The Psychological Impact of Infertility](https://connect.asrm.org/mhpg/education/infertilityimpact)
- [ACOG — Infertility: Disparities and Access to Services (Committee Statement, 2025)](https://www.acog.org/clinical/clinical-guidance/committee-statement/articles/2025/01/infertility-disparities-and-access-to-services)
- [Emotional Support for Infertility Patients: Integrating Mental Health Professionals (MDPI)](https://www.mdpi.com/2673-4184/2/1/8)
- [Impact of Reproductive Problems on Couples (ClinicalTrials.gov NCT03365830)](https://clinicaltrials.gov/study/NCT03365830)
- [Emotional reaction to diagnosis of infertility (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2851694/)

**Competitor / app landscape:**
- [Best Fertility Tracking Apps 2026 (comparison)](https://www.go-go-gaia.com/blog/best-fertility-tracking-app.html)
- [Best Fertility Apps and Ovulation Trackers (MakeAMom)](https://www.makeamom.com/blog/best-fertility-apps-ovulation-trackers.html)
- [Do fertility trackers work? Experts on apps and tools (TODAY)](https://www.today.com/health/health/do-fertility-trackers-work-rcna14223)

*Community material is internal qualitative design input only, not evidence for a public clinical, prevalence, or competitor claim. Privacy requirements are grounded in the FTC’s [Flo matter (2021)](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [Premom/Easy Healthcare matter (2023)](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v). Named-app diagnostic or support gaps must not be published without a dated hands-on verification record. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
