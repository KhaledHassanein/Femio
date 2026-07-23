# C3 — Primary Infertility, Age ≥35 (Time-Pressured Evaluation / Ovarian-Reserve Phase)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Femio never diagnoses, treats, or prevents disease, and is **not contraception**. Fertile-window features are **conception awareness, not birth control**. Screeners and thresholds are framed as *"screening / education — discuss with your clinician."* Femio does not run, order, or interpret medical tests; it helps a user **organize, understand, and prepare** for a workup her clinician directs. **Age is context, not a verdict** — Femio never tells a user her age or an AMH value means she "can't" conceive.
> Persona code: **C3** · Cohort: Conception (C) · Sibling of **C2** (same phase, <35) · Last research pass: 2026-07-17

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Dana," 38 (band 35–42) |
| **Age band** | **≥35 (typically 35–42).** This is the defining variable: her formal evaluation clock is **6 months, not 12** (ACOG/ASRM/NICE); at **≥40 the guidance is immediate evaluation.** [ACOG; ASRM 2021] |
| **Stage** | **Primary infertility**: ~**6+ months** of regular, unprotected intercourse, no conception, **no prior pregnancy ever**. Entering the **clinical-evaluation / workup** phase on a compressed timeline, with **ovarian-reserve (AMH/AFC)** front-of-mind. |
| **Relationship** | Partnered. Both partners are worked up (male factor ~30% of couples — semen analysis is first-line, not an afterthought). Some C3 users are solo-by-choice or using donor sperm — the age clock still governs. |
| **Goal (top JTBD)** | *"I don't have 12 months to 'keep trying.' Help me understand my ovarian reserve, move through the workup fast and in the right order, get to a specialist (REI) prepared, and hold me steady while the clock feels loud."* |
| **Health literacy** | High and rising fast — but saturated with **age-panic content**. She has read the scary charts. She needs **referenced, uncertainty-honest** framing that neither sugar-coats age nor doom-spirals it. |
| **Tech context** | Web-first; also phone. Often arriving from a period/ovulation tracker whose "just time it better" advice now feels actively harmful given her clock. May already have an AMH result from a home/clinic test in hand. |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. In many AR/MENA markets infertility carries acute stigma and is often (wrongly) framed as a "woman's problem"; **age adds a second stigma layer** ("you waited too long"). Privacy and dignity are paramount. |
| **Emotional state** | **Acute time-pressure + grief + urgency.** Age-anxiety ("did I wait too long?"), self-blame, cyclical grief each failed cycle, and the specific dread of a "low for your age" reserve result. Anticipatory grief about ART, cost, and donor eggs. 30–40% of women in fertility workup/treatment report clinically significant anxiety/depression. |
| **What she is NOT** | Not (yet) an ART/IVF patient (that's **C10**) — though her runway to ART is *short*. Not diagnosed by Femio. Not a C2 (the **6-month/immediate clock, reserve-testing emphasis, and faster ART push** distinguish her). Not someone to be told "just relax" or "you have plenty of time." |
| **Primary signals she brings** | Age ≥35, cycle history, BBT/OPK archives, and **clinical data with reserve-testing front and center**: **AMH, antral follicle count (AFC), day-3 FSH/estradiol**, mid-luteal progesterone, TSH/prolactin, partner's semen analysis, HSG result, ultrasound findings, appointment dates. |
| **Success = she leaves us because…** | She conceives (→ Pregnancy, flagged **Pregnancy-After-Infertility / advanced-maternal-age-aware**), OR she starts IUI/IVF **fast** (→ **C10** ART), OR a loss occurs (→ **RPL/PAL**, notably higher miscarriage risk at this age) — each transition with data continuity and dignity. |

**Persona thesis.** C3 is C2 **with the clock turned up**. Same comprehension/organization/endurance problem, but three things are materially different and drive the whole spec: (1) the **6-month (≥35) / immediate (≥40) evaluation threshold** compresses everything — routing must be faster and framed as "worth talking to a clinician **now**"; (2) **ovarian-reserve testing (AMH/AFC/FSH)** moves from a late detail to the emotional and informational center of gravity — and it is the single most **misunderstood** result, so the "reserve predicts stimulation response, **not** natural-conception chance" caveat is load-bearing; (3) the emotional register is **urgency + anticipatory grief**, not just limbo. No mainstream app owns the age-35+ diagnostic phase — they keep optimizing timing she cannot afford to keep "practicing." C3 is Femio's chance to be the app that **moves efficiently and holds steady at once.**

---

## B. Needs & questions (voice-of-user)

Mined from r/infertility, r/AgeGapTTC / "TTC after 35 / 37 / 40" threads, r/IVF (DOR & low-AMH megathreads), fertility-clinic patient blogs, and app-store reviews. Phrasing is representative/composite (community norms; not quoting individuals).

**Time & threshold questions (the compressed clock — unique vs C2):**
1. *"I'm 38 and it's been 6 months — is that already 'long enough' to get seen? Or am I overreacting?"* (Answer: at ≥35, 6 months is the guideline trigger.)
2. *"I'm 41 — do I even wait? Everyone says 'go now.'"* (At ≥40, immediate evaluation is guideline-supported.)
3. *"How fast does this workup actually move, and can I do tests in parallel instead of one cycle at a time?"*
4. *"When do we skip straight to IVF instead of trying IUIs?"* (age-based ART acceleration)

**Ovarian-reserve questions (the emotional epicenter — much heavier than C2):**
5. *"My AMH is 0.8 / 'low for my age' — does that mean I can't get pregnant naturally? Am I out of time?"* (The single most loaded, most misunderstood fear — see §D.)
6. *"AMH vs AFC vs day-3 FSH — what does each actually tell me, and which one matters?"*
7. *"If my reserve is low, does that mean IVF won't work / I'll need donor eggs?"*
8. *"My AMH dropped since last year — is my fertility 'crashing'?"*
9. *"Does a normal AMH at 39 mean I'm fine?"* (false-reassurance risk — reserve ≠ egg quality/age effect)

**Decode-the-rest-of-the-workup questions (shared with C2):**
10. *"What's the standard order of tests, and what's the day-21/mid-luteal progesterone for?"*
11. *"What is an HSG, will it hurt, what does it check?"* (tubal patency)
12. *"His semen analysis is 'abnormal' — what do count/motility/morphology mean, should he repeat it?"*
13. *"They said 'unexplained infertility' at 38 — what now, given my age?"*
14. *"When does the GP/OB refer us to an REI — and can I self-refer to save time?"*

**Organization & logistics pain (sharper because every cycle counts):**
- *"Results in three portals, a lab PDF, screenshots, my memory — I need one place before the appointment, and I can't afford to waste a consult."*
- *"Which test happens on which cycle day? Missing a window costs me a whole month I don't have."*
- *"I forget half my questions in a 15-minute consult — and at my age I need to ask the right ones."*

**Emotional-arc needs (design must respect this):**
- **Urgency + anticipatory grief**, layered on the limbo C2 feels: every failed cycle is grief *and* a felt loss of runway.
- Age-shame and the "you waited too long" narrative (external and internalized), acute in AR/MENA.
- Surrounded by pregnancy announcements, "have you tried…", and well-meaning "my cousin had a baby at 44!" (false hope) or "at your age?" (doom). She needs **honest but not bleak, urgent but not panicked.**

**Anti-needs / trust-breakers (churn drivers):**
- **Age-doom** — countdown timers, "your fertility falls off a cliff," or implying she's already failed.
- **False reassurance** — "a normal AMH means you're totally fine" (ignores age-related egg-quality decline that reserve tests don't measure).
- Toxic positivity ("just relax," "it only takes one egg").
- Telling her a single low AMH means she'll never conceive naturally (untrue and cruel).
- Any app still cheerfully pushing "time it better!" as if timing were her unsolved problem.
- Being labeled/diagnosed by an app ("diminished ovarian reserve") instead of helped to understand a clinician's finding.
- Privacy creep on reproductive + clinical data (post-Flo/Premom FTC distrust), doubled by age/stigma sensitivity.

**Feature requests recurring in reviews/forums:**
- An **ovarian-reserve explainer + log** (AMH/AFC/FSH) with the natural-conception caveat stated plainly, and trend view over time — framed as awareness, never a verdict.
- A **faster, age-aware workup roadmap** that shows the ≥35 (6-mo) / ≥40 (immediate) trigger and lets her see what can move in parallel.
- **Clinical-results home** for AMH, progesterone, FSH/E2, TSH/prolactin, HSG, ultrasound, and the **partner's semen analysis**.
- **REI-visit prep pack** + exportable summary; **"can I self-refer?" / choosing-a-clinic** education.
- **ART-readiness / "what to expect if IVF is recommended"** education (bridge to C10) — she wants it *before* the referral, not after.
- Referenced content she can trust more than a forum — especially on **age & fertility**.

---

## C. Competitor teardown

Feature-by-feature, focused on **the age-35+ diagnostic phase**: reserve-testing literacy, the compressed clock, and emotionally-intelligent support. Key insight: mainstream trackers are *timing* tools built for the woman still trying on her own; clinic apps are *logistics* tools locked to one clinic *after* referral. **Nobody** owns the independent, referenced, age-aware, reserve-literate evaluation companion — and the older user is exactly who these timing tools quietly fail.

| App | What it's built for | Age-35+ diagnostic-phase support | Ovarian-reserve (AMH/AFC) literacy | Emotional support (urgency/age) | Where it fails C3 |
|---|---|---|---|---|---|
| **Flo** | Mass-market cycle + fertile-window prediction | Minimal; keeps predicting a fertile window regardless of age/clock. "Secret Chats" community is generic | None — no AMH/AFC concept; can't log or explain reserve | Generic community + content; not age- or reserve-specific | Optimizes *timing* she can't afford to keep practicing; no 6-mo/immediate threshold logic; **FTC 2021** data legacy erodes trust for clinical data |
| **Ovia Fertility** | Data-rich fertility "score," employer/health-plan channel | Some "when to see a doctor" content; still fertility-score-centric, not clock-aware | No structured reserve log or caveat education | Coaching content; not calibrated to age-anxiety | Daily "fertility score" can read as false precision/false hope at 39; employer/health-plan data model is a stigma red flag; no reserve roadmap |
| **Glow** | Cycle + community + fertility | Community threads on DOR/low-AMH/IVF exist | Weak structured logging; reserve knowledge lives in (variable-quality) forum posts | Strong peer community — double-edged: support *and* age-doom/false-hope amplification | No referenced, age-aware reserve education; historic privacy scrutiny; community can spike anxiety at exactly her pressure point |
| **Premom** | Best-in-class OPK photo reading (Easy@Home) | Essentially none — it's an ovulation-detection tool | No | Minimal | Purpose-built for *timing*; **FTC 2023** settlement over data sharing; abandons the ≥35 user precisely at the workup |
| **Fertility Friend** | Deep BBT/FAM charting, power-user charting | Charts exportable for a clinician; no age/threshold guidance | Manual notes only; no reserve framing | Long-standing forums | Dated UX; still a *charting* tool; no reserve decoding, no age-aware roadmap, no visit-prep, no emotional layer |
| **Fertility-clinic companion apps** (clinic-branded, Kindbody/Ivy-style, EngagedMD-type consenting) | Managing an *active* treatment cycle at a specific clinic | Strong **once you're a patient there** — meds, monitoring, portal; may show *your* AMH inside their silo | Clinic's own results, siloed; interpretation is the clinic's, not portable education | Task reminders, some education | **You must already be a clinic patient.** No help in the pre-referral / choosing-a-path limbo where the age clock is loudest; not portable; not referenced-independent; rarely Arabic-first |

**The fragmentation map (the opening for Femio):**
- **Timing depth** (Premom / Fertility Friend / Flo) is not just irrelevant to C3 — at her age it can be *harmful*, encouraging more unmonitored months.
- **Fertility "scores"** (Ovia) risk both false precision and false hope for the 35+ user.
- **Clinic apps** only start working *after* referral and lock her into one silo — after the clock has already been running.
- **Community** (Glow / Flo) provides warmth but amplifies both age-doom and "44-year-old miracle" false hope, and spreads reserve-test misinformation.
- **Nobody** offers: a **referenced, uncertainty-honest, age-aware workup companion** + **plain-language ovarian-reserve literacy with the natural-conception caveat** + a **portable clinical-results & appointment home** + **REI-visit prep** + **ART-readiness education before referral** + **urgency-and-grief-calibrated support** + **Arabic-first/RTL** + **privacy-by-design for clinical data** + **one account that carries her into ART / pregnancy / loss without starting over.** *That is C3's Femio thesis.*

---

## D. Clinical grounding (cited)

> All claims below are **patient-education framing**. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, order tests, or interpret results — it explains, in plain language, what a clinician-directed workup involves and routes every specific concern to "discuss with your clinician." **Age and AMH are context for a conversation, never a Femio verdict.**

**The age threshold — the routing rule that defines C3 (critical for §I/§J):**
- **Infertility** = failure to achieve pregnancy after **12 months** of regular, unprotected intercourse — **or 6 months if the female partner is ≥35.** [ASRM 2021; ACOG; WHO] *Primary* infertility = no prior pregnancy ever.
- **Age 35–39 (core C3):** evaluate after **6 months.** [ACOG *Evaluating Infertility*; ASRM 2021]
- **Age ≥40:** **more immediate evaluation and treatment is warranted** — do not wait the 6 months. [ACOG; ASRM 2021]
- Evaluate **without delay regardless of duration** with a known risk factor (irregular/absent cycles, known male-factor, prior pelvic infection/surgery, endometriosis, suspected tubal/uterine disease, prior chemo/radiation or ovarian surgery). [ASRM 2021; ACOG 2019]

**Age & fertility decline (grounds the urgency — state honestly, never as doom):**
- Female fertility declines gradually from the early 30s and **more rapidly after ~35**, driven by falling **egg number and egg quality**; per-cycle conception probability decreases and time-to-pregnancy lengthens with age. [ACOG *Anticipatory Counseling Regarding Ovarian-Factor Fertility Decline*, 2025; NICHD; StatPearls *Age-Related Fertility Decline*]
- Aneuploidy (chromosomal errors in eggs) rises with age, which is the main driver of **higher miscarriage risk** at older maternal age. [StatPearls; ACOG 2025] *Design implication:* C3's loss route (→ RPL/PAL) is a materially higher-probability branch than C2's.
- *Femio framing:* present the age-related trend and explain why clinicians suggest earlier evaluation, **never** a countdown, “cliff,” public per-age probability table, or personal probability verdict. [ASRM *Fertility Evaluation of Infertile Women* (2021)]

**Ovarian-reserve testing — the emotional epicenter (the load-bearing caveat):**
- Ovarian-reserve tests — **AMH, antral follicle count (AFC), and early-follicular (day-3) FSH/estradiol** — estimate the **quantity** of remaining eggs and, importantly, **predict response to ovarian stimulation** (i.e., they inform IVF planning). [ASRM *Testing and Interpreting Measures of Ovarian Reserve*, 2020]
- **They are NOT a good predictor of natural conception**, and a **"low" value does not mean a woman cannot conceive naturally** or is "out of time." AMH/AFC measure egg *quantity/stimulation response*, **not egg quality** and **not whether a given cycle will work.** This is the most misunderstood, most emotionally loaded result in C3 and Femio content must state the caveat explicitly and repeatedly. [ASRM 2020; NICE NG257; PMC — ovarian reserve does not influence natural conception]
- Reserve testing is reasonable in women **≥35 not conceiving after ~6 months**, and earlier with DOR risk factors (single ovary, prior ovarian surgery, chemo/radiation, unexplained infertility). [ASRM 2020]
- Femio does **not** publish universal AMH, FSH, or AFC cutoffs: assays, laboratories, clinical context, and treatment protocols differ. It may store a clinician-provided value but never labels or interprets it. Ovarian-reserve testing is an adjunct in infertility evaluation and helps predict response to stimulation; a poor result does not necessarily imply inability to conceive naturally. [ASRM *Fertility Evaluation of Infertile Women* (2021)]
- *Design implication:* "diminished ovarian reserve" is a **clinician's** characterization, never a Femio label. The reserve log is **entry + trend + caveat**, never a scorecard.

**The rest of the standard workup (education only — shared with C2):**
- ASRM initial evaluation = **history & physical, ovulation assessment, ovarian-reserve testing, tubal patency, and semen analysis for the partner.** [ASRM 2021; ACOG 2019]
- **Ovulation:** in people with regular 21–35-day cycles, added testing to confirm ovulation is generally not required unless another indication exists. If a clinician orders mid-luteal progesterone, the clinician individualizes timing relative to the expected next period; Femio does not hard-code “day 21.” [ASRM (2021)]
- **Tubal patency:** **hysterosalpingography (HSG)** (or HyCoSy/sono-HSG; laparoscopy in selected cases) assesses tubes and cavity. [ASRM 2021; ACOG 2019]
- **Thyroid/prolactin** (TSH, prolactin) and other hormones as clinically indicated. [ACOG 2019]

**The male workup (equal first-line):**
- **Semen analysis** is a primary first-line test; an abnormal result is generally **repeated/confirmed** before conclusions. Endocrine testing is not routine first-line. [AUA/ASRM *Diagnosis and Treatment of Infertility in Men*]

**Faster path to specialist care & ART (distinguishes C3 from C2):**
- Because the age clock and reserve decline compress the window, guidelines support **earlier referral to an REI** and **age-based acceleration toward ART** (e.g., proceeding to IVF sooner, fewer/none IUI attempts) — a clinician's decision Femio helps her *prepare for*, never one Femio makes. [ASRM 2021; ACOG 2019]

**Emotional impact (grounds the support features):**
- Women in fertility evaluation/treatment report **depression and anxiety at ~30–40%**, higher than the general population; distress is frequently compared to that of serious medical illness. Age-related urgency and anticipatory grief (about ART, cost, donor eggs) layer on top for C3. Themes: anxiety, mood disturbance, threat to self-esteem/identity, couple strain, shrinking support network. [ASRM MHPG; MDPI review; ACOG committee statement]

*Femio applies all of this as **educational routing and organization**, always ending "discuss with your clinician" — never as a diagnosis, test order, result interpretation, or age/reserve verdict.*

Medical-review resolution: evaluation thresholds, ovarian-reserve caveats, lab-cutoff policy, and ovulation-test timing follow [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). No public per-age probability table, universal reserve cutoff, or individual result interpretation. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

*Inherits the C2 evaluation-phase feature spine; **bold = C3-specific additions or reweightings** driven by age, reserve testing, and urgency.*

**P0 — Must-have (defines the persona; ship first):**
1. **Age-aware workup roadmap / "Understand your evaluation"** — referenced, step-by-step, *non-diagnostic* map of the couple's workup, **surfacing the ≥35 (6-mo) / ≥40 (immediate) trigger** and **what tests can move in parallel** to save cycles. Marks each item done / pending / to-ask — never "you need this test."
2. **Ovarian-reserve explainer + log (the C3 centerpiece)** — AMH, AFC, day-3 FSH/E2 with plain-language "what this measures" education, a **trend view over time**, and the **load-bearing caveat everywhere**: *reserve predicts stimulation response, not natural-conception chance; a low number is not a verdict; it does not measure egg quality.* Entry-only, **never interpreted or scored**, never labeled "DOR."
3. **Clinical-results & lab home (self-entered)** — one place for AMH/AFC/FSH/E2, mid-luteal progesterone, TSH/prolactin, HSG, ultrasound, and the **partner's semen analysis** — each with category-level "what this measures" education (not interpretation of *her* value).
4. **REI-visit prep pack** — auto-generated, exportable/printable: cycle history, logged results (reserve front-and-center), timeline, and a **question list** (curated + her own), tuned for the *specialist* visit and the age-accelerated decisions ahead.
5. **Cycle-day-aware test-timing helper** — non-alarming reminders tied to *her* cycle for time-sensitive, clinician-ordered tests (mid-luteal progesterone, day-3 FSH/E2/AMH draw timing) — *"confirm the exact day with your clinician."* Prevents losing a cycle she can't spare.
6. **Urgency-and-grief-calibrated emotional layer** — warm, non-toxic-positive cards tuned to the C3 arc (**age-anxiety**, waiting for a reserve result, after a failed cycle, before a big REI appointment, **anticipatory grief about ART/donor eggs**), a mood/anxiety **screener** (screening-framed + localized crisis resources), coping content. Explicitly avoids both "just relax" **and** "you're running out of time."
7. **Uncertainty-honest framing everywhere** — the **AMH ≠ can't-conceive-naturally** message and the **normal-AMH ≠ "you're totally fine"** counter-message; age presented as *ranges/why-earlier-eval*, never a countdown. No false hope, no false doom.
8. **Partner mode with equal male-factor footing** — partner logs/sees the semen analysis and male-workup content, shares the calendar, receives partner-facing support; consent-gated, revocable.

**P1 — Strong differentiators (fast follow):**
9. **"If IVF is recommended — what to expect" ART-readiness bridge** — referenced education about ART *before* referral (why age accelerates the path, IUI-vs-IVF, what reserve means for stimulation, cost/coverage awareness), pre-loading the **C10** hand-off. Education only.
10. **Referenced content library** on age & fertility, ovarian reserve, HSG, semen analysis, unexplained infertility — grade 6–8, 4 languages, RTL-first.
11. **Appointment & follow-up organizer** — visits, cycle day, what was ordered, what's pending, results due; **fast-track / self-referral education** where regionally valid.
12. **"Unexplained infertility at 35+" explainer & next-steps** — age reframes the decision (earlier ART), a high-anxiety/low-information moment.
13. **Timeline view** — one portable narrative (cycles + tests + appointments) for any provider she chooses.
14. **Chart/data export (PDF/image)** for any clinician.

**P2 — Nice-to-have / later:**
15. Moderated, privacy-safe evaluation-phase community (age-aware; guarded against age-doom **and** false-hope misinformation).
16. Couple's shared journal / decision-notes (ART/donor-egg decisions are heavy — space to think).
17. Region-aware **cost/coverage education** (ACOG flags access disparities; ART cost is a major C3 stressor) — education only.
18. Localized, stigma-aware AR/MENA content (infertility as a couple's medical matter; **age-shame de-escalation**).

**Explicitly OUT of scope for C3 (guardrail):**
- Ordering, running, or **interpreting** any test/result — including **AMH/AFC/FSH** (Femio explains categories; only her clinician interprets *her* numbers).
- **Diagnosing or labeling "diminished ovarian reserve," advanced maternal age, infertility, or its cause.** Screeners/thresholds **flag & route**, never diagnose (§K).
- Any **age/reserve "fertility score," countdown, or probability verdict.** Never.
- Any "safe day / avoid pregnancy / contraception" framing. **Never.**
- ART/IVF cycle management (meds, stims, monitoring) — that is **C10** (though C3 pre-loads the bridge).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries source citations, a medical-review byline + date, and "not medical advice / discuss with your clinician."

- **"Trying after 35 — when is it worth getting evaluated?"** — the **6-month (≥35) / immediate (≥40)** trigger, calm and non-alarming; why clinicians suggest earlier evaluation. [ACOG; ASRM 2021]
- **Age & fertility, honestly** — how egg number/quality change with age, what that does and doesn't mean, presented as ranges/trends — **no cliffs, no countdown.** [ACOG 2025; NICHD; StatPearls]
- **Ovarian reserve, decoded (AMH · AFC · day-3 FSH)** — what each measures, why they predict **stimulation response** and **not** natural conception, why a "low" number is **not** a verdict and **doesn't** measure egg quality, and why a "normal" number isn't a guarantee at her age. **The flagship C3 module.** [ASRM 2020; NICE; PMC]
- **The couple's workup, explained (fast-track view)** — ovulation, reserve, tubal patency, semen analysis; what each checks, that **both partners** are evaluated, and what can move in parallel.
- **Understanding an HSG** — what it is, what it checks (tubal patency), what to expect, questions to ask.
- **The "day 21" / mid-luteal progesterone test** — what it confirms (ovulation) and why timing matters.
- **Making sense of a semen analysis** — count/motility/morphology categories, why abnormal results are repeated, male-factor is common. (Partner-facing variant.)
- **"Unexplained infertility at 35+ — what it means and what's next"** — why age often shifts the recommendation toward earlier ART; reframing the distress.
- **When and how referral to a fertility specialist (REI) works — and moving efficiently** — self-referral/fast-track where valid; choosing a clinic.
- **"If IVF is recommended" — what to expect** — an honest, referenced bridge to ART (IUI vs IVF, what reserve means for stimulation, cost/coverage awareness). Education only; pre-loads **C10**.
- **Getting the most from your specialist visit** — how to prepare, what to bring, the questions that matter most on a compressed clock.
- **The emotional side: urgency, grief, and the clock** — normalizing age-anxiety and anticipatory grief, coping strategies, couple communication, when to seek mental-health support; **de-escalating "I waited too long."** [ASRM MHPG]
- **Stigma-aware module (AR/MENA-first)** — infertility as a shared medical matter; **age-shame de-escalation**; privacy and dignity.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so C3 never feels boxed into "age/infertility only."

---

## G. Tools, logs & alerts (compliant framing)

**Logs (inputs):**
- Cycle/bleed log, BBT/OPK/CM (carried from C1 if present), intercourse, symptoms/mood.
- **Clinical results (self-entered, entry-only, never machine-interpreted):** **AMH, AFC, day-3 FSH/E2/LH** (reserve front-and-center), mid-luteal progesterone, TSH, prolactin, HSG result, ultrasound/AFC notes, **partner semen analysis** (count/motility/morphology/volume). Reserve values support a **trend view** (awareness, not scoring).
- Appointments, ordered-tests, referral status, questions-for-visit.
- Mood/anxiety screener history (scores + dates, screening-only).
- `emotional_state_tags` incl. **age-anxiety / awaiting-reserve-result / anticipatory-grief** (drive support-card selection).

**Tools:**
- **Age-aware workup-roadmap tracker** (done / pending / to-ask), surfacing the 6-mo/immediate trigger + parallel-testing view.
- **Ovarian-reserve log + trend + caveat panel** (never a score).
- Clinical-results home with plain-language category explainers.
- REI-visit prep generator (one-tap export/print).
- Cycle-day-aware test-timing helper (clinician-ordered, time-sensitive draws).
- ART-readiness education bridge.
- Timeline view; PDF/image export.
- Mood/anxiety screener (PHQ-2/GAD-2-style) → screening-framed output + localized crisis resources.

**Alerts / nudges (all opt-in, tone-calibrated, dismissible, revocable, RTL-aware):**
- "You've been trying ~6 months — at your stage, many people talk to a clinician now. Here's what an evaluation involves." (awareness routing, **never** "you are infertile")
- "Your clinician mentioned a day-3 FSH/AMH draw — the early-cycle window is usually days 2–4; confirm the exact day with them." (awareness, not instruction)
- "Appointment with Dr. [X] in 2 days — want to finish your questions list?"
- "New reserve result to log? Add it to see your trend and read what it does — and doesn't — mean."
- Emotional-arc cards: age-anxiety steadying, awaiting-reserve-result support, pre-REI-appointment prep, post-failed-cycle grief-aware, anticipatory-grief (ART/donor) support.
- Screening follow-up (re-check mood in N weeks) + crisis resources on any low screen.
- **Never:** contraception/"safe day" language; never "your AMH/age means you can't conceive"; never "your reserve is low/diminished" (that's a clinician's word); never a countdown/score; never "you have [diagnosis]"; never disease-prevention claims; never "you need test X."

**Mandatory compliance wording on relevant surfaces:**
- *"Femio helps you organize and understand your evaluation — it does not order tests or interpret your results. Only your clinician can do that."*
- On every reserve surface: *"AMH/AFC estimate how your ovaries might respond to fertility medication. They do not predict whether you can conceive naturally, and they don't measure egg quality. A number here is not a diagnosis — discuss it with your clinician."*
- Any fertile-window/ovulation surface retained from C1: *"Estimate based on your data — not a guarantee, and **not a method of birth control**."*
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (from screeners, non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamp + "non-diagnostic" tag).

**C3 persona-specific (extends the C2 evaluation layer; bold = C3 delta):**
- `ttc_start_date`; `infertility_type` = `primary` (no prior pregnancy) — drives tone.
- **`age_threshold_rule`** = derived from `age_band`: `six_month` (35–39) | `immediate` (≥40) — **drives the compressed routing clock.**
- `evaluation_phase_flag` = true; `workup_roadmap_state[]` {item, status: done/pending/to_ask, parallelizable: bool}.
- **`ovarian_reserve[]`** {test_type: AMH | AFC | FSH_d3 | E2_d3, value, unit, date, source_note} — **entry-only, trend-enabled, never interpreted, never scored, never labeled DOR.**
- `labs[]` {test_type (progesterone_midluteal, TSH, prolactin, LH, …), value, unit, date, source_note} — entry-only, no interpretation.
- `partner_semen_analysis[]` {count, motility, morphology, volume, date, repeat_flag} (partner-shared, consent-gated).
- `imaging_results[]` {type (HSG, TVUS), finding_note, date}.
- `appointments[]` {clinician (incl. **REI**), type, cycle_day, ordered_tests[], results_due, status}.
- `referral_status` {stage: GP/OB / referred / **REI-consult-booked** / **ART-planning**}.
- **`art_readiness_flag`** (has viewed/opted into ART-bridge education) — soft signal toward **C10**, not a state change.
- `visit_questions[]`, `visit_prep_exports[]`.
- `mood_screen_history[]` {tool, score, date} (screening-only).
- `emotional_state_tags[]` (**age_anxiety / awaiting_reserve_result / anticipatory_grief** / waiting / post_failed_cycle / pre_appointment) — drives support-card selection.
- `partner_link_id`, `partner_scope`, `partner_consent_ts`.

*Data-minimization & heightened sensitivity: clinical/lab/reserve data is special-category health data with **elevated** stigma risk (age adds a second stigma layer); encrypted, user-deletable, never shared with ad networks/analytics; retention limits on uploaded lab PDFs/photos. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C3 — the age answer is the pivot vs C2):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. Age capture → **≥35** ⇒ candidate for **C3** (this is the C2/C3 fork). ≥40 ⇒ set `age_threshold_rule = immediate`.
3. "How long have you been trying?" → **≥6 months** (or **any duration if ≥40**) ⇒ evaluation-phase candidate.
4. "Have you ever been pregnant before?" → **No** ⇒ `infertility_type = primary` (distinguishes from secondary-infertility persona).
5. "Where are you in the process?" (still trying on our own / starting tests / **have reserve/AMH results** / seeing/booked with a specialist) ⇒ sets `evaluation_phase_flag`, `art_readiness_flag` interest, and home emphasis.
6. "Any of these apply?" (irregular/absent cycles, known condition, partner known issue, prior pelvic surgery/infection, **prior ovarian surgery / chemo-radiation / single ovary**) → raise relevant content + "consider evaluation now" (educational, not a diagnosis; DOR risk factors accelerate routing).
7. "Involve a partner?" → partner-mode setup with **male-factor equality** framing.
8. Consent & privacy choices (explicit clinical-data + age-sensitivity notice).

**Home config for C3:**
- Hero = **age-aware workup roadmap** (done/pending/to-ask, with the 6-mo/immediate trigger visible) + next appointment + "prep your questions."
- Secondary = **ovarian-reserve log/trend + caveat panel** (prominent — this is C3's centerpiece); clinical-results home; emotional-support card matched to current `emotional_state_tag`; latest relevant module (age & fertility / reserve / ART-bridge).
- **De-emphasize** the C1 fertile-window hero (timing is not her blocker and can mislead at her age) — keep it **reachable**, never her primary narrative, never with a countdown.
- **Hidden-but-reachable:** full lifespan library, condition pages, contraception *education*, perimenopause — one search/tap away.

**Adaptive tone:** validating, steady, honest, **efficient**. Acknowledge the clock without amplifying panic; escalate emotional-support prominence around age-anxiety spikes, awaiting-reserve results, failed cycles, and big REI appointments; surface mental-health module + resources if mood screens trend low. **Never toxic-positive, never age-doom, never a countdown.**

---

## J. Adaptation triggers (state transitions)

*Inherits all **universal events** from the Master Adaptation Model §6 (positive test, loss, mood-crisis, red-flag, disengagement, mode-off, age-of-consent). Listed below are **C3-specific** transitions and reweightings only.*

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Arrives at ≥35 + ~6-mo threshold (or ≥40 any duration)** | `age ≥35 & now−ttc_start_date ≥ 6 mo` (or `age ≥40`), not pregnant, no prior pregnancy | Calm, non-diagnostic, **time-aware** hand-off: "At your stage, many people talk to a clinician now." Activate age-aware roadmap, reserve log, results home, visit-prep, urgency-calibrated emotional layer. | **Become C3** (this persona) |
| **→ C10 ART (fast)** | user logs/reports starting stimulation, IUI, or IVF — **expected sooner than C2 given age-based acceleration** | Sensitive confirm; hand off to ART experience (meds/monitoring/cycle mgmt) carrying **all** C3 data forward, incl. reserve trend. C3's `art_readiness_flag` makes this a *primed*, not cold, transition. | **C10 — ART / IVF persona** |
| **Positive pregnancy test** | `hpt` positive or user confirms | Universal positive-test handler; offer **Pregnancy mode flagged Pregnancy-After-Infertility (PAI) + advanced-maternal-age-aware** (heightened anxiety + age-related monitoring context, education only); retire timing widgets; carry workup + reserve context. | **D-track, PAI-flagged** (age-aware) |
| **Pregnancy loss reported** | user reports loss | Universal loss handler: instant suppression of celebratory nudges, Gentle Mode, grief resources, retain data. **Higher-probability branch at this age** — offer **C5 (RPL)** after ≥2 losses / **PAL** pathway. | **C5 / RPL** or **PAL / E6 grief** |
| **DOR risk factor or "low reserve" result recorded** | user logs prior ovarian surgery / chemo-radiation / single ovary, or records a clinician's low-reserve finding | Surface reserve-decoded module + the **natural-conception caveat**, raise ART-bridge education and emotional support; **Femio never labels "DOR" or interprets the value.** | Stay C3, raise reserve education + support + (soft) ART-bridge |
| **"Unexplained infertility" outcome at 35+** | user records this result | Surface the age-aware explainer (why age often shifts toward earlier ART) + next-steps + emotional support; **no diagnosis by Femio.** | Stay C3, raise support + ART-bridge prominence |
| **Mood screen trends low / crisis flag** | screener threshold crossed | Universal handler: mental-health module + localized crisis resources; screening-framed. (C3's age-anxiety/anticipatory-grief tags raise baseline sensitivity.) | Stay C3 |
| **Taking a break / stepping back** | inactivity or "pause" flag | Universal handler: pause nudges (**silence the clock, too**); preserve all data; gentle wellness content. | Retain, low-touch |

*All routes preserve data continuity (one account) and always end with clinician-referral language — never a diagnosis, test order, result interpretation, or age/reserve verdict.*

---

## K. Compliance flags

1. **No diagnosis / treatment / prevention; no test ordering or interpretation (highest-priority guardrail).** Femio helps a user *organize and understand* a **clinician-directed** workup. It never orders a test, interprets an individual lab or reserve value, or diagnoses infertility or diminished ovarian reserve. The **6-month (age 35 or older) / more-immediate (over 40)** thresholds are educational routing; results fields are entry-only with category-level education. This clinical scope follows [ASRM’s 2021 evaluation framework](https://www.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/); app-store and device-classification review remains a separate pre-submission legal task.
2. **Ovarian-reserve caveat is load-bearing.** Every reserve surface must state that AMH/AFC/FSH predict **stimulation response, not natural conception**, don't measure **egg quality**, and a value is **not a verdict** — countering both false doom (low = "can't conceive") and false reassurance (normal = "you're fine at 39"). [ASRM 2020; NICE; PMC]
3. **Age is context, never a verdict.** No countdowns, no "cliff," no per-user probability, no "fertility score." Age framing = ranges + "why clinicians suggest earlier evaluation," always routing to a clinician. [ACOG 2025]
4. **Not contraception.** Any retained fertile-window surface is conception-awareness only, carries *"not a method of birth control,"* never uses "safe/infertile day" language.
5. **Uncertainty honesty / no false hope or false doom.** Predictions display confidence; no false precision; no "you can't conceive," no "you're totally fine" absolutes; miscarriage-risk-by-age content stated as population ranges, gently, never as personal prediction.
6. **Clinical-data privacy (elevated sensitivity + age-stigma layer).** Reserve results, labs, and a partner's semen analysis are special-category health data with acute, **age-compounded** stigma risk (esp. AR/MENA). Learn from **Flo (FTC 2021)** and **Premom (FTC 2023)**: no sharing of reproductive/clinical data with ad networks or third-party analytics; data minimization; explicit, granular, revocable consent; strict retention & user-deletion for uploaded PDFs/photos. **[NEEDS SOURCE — FTC primary docs.]**
7. **GDPR / PDPL — special-category health data.** Lawful basis + explicit consent; DSAR/export/delete; regional data-residency (esp. AR/MENA); DPIA before launch. **[NEEDS SOURCE — align to Femio privacy skill / DPA at implementation.]**
8. **Partner mode consent + male-factor equality.** Partner sees only granted scope; consent logged, scope-limited, instantly revocable. Male-factor testing framed as equal and routine, never as blame — and age-related distress is **not** hers to carry alone.
9. **Medical review + citations.** Evaluation thresholds, ovarian-reserve caveats, lab-cutoff policy, and ovulation-test timing are pinned in [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). Translation must preserve the meaning and be locale-QA’d before publication. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
10. **Emotional safety (urgency + anticipatory grief).** The age-35+ evaluation phase carries clinically significant distress (30–40% anxiety/depression) plus time-pressure and anticipatory grief. Tone must avoid both doom and toxic positivity **and** the "you waited too long" narrative; crisis resources on any low mood screen; loss (a higher-probability branch here) handled with grief-aware UX.
11. **Stigma-aware localization (double layer).** AR/MENA-first framing treats infertility as a shared medical matter, not a woman's failing, **and de-escalates age-shame**; maximum privacy/dignity by default.
12. **App-store health-app policy.** Meet Apple/Google health-app & medical-disclaimer requirements; no over-claiming (esp. no age/reserve predictive claims); legal review before store submission. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

**Clinical — Tier 1 (NIH/CDC/WHO/NHS/MedlinePlus/gov):**
- [WHO — Infertility (fact sheet)](https://www.who.int/news-room/fact-sheets/detail/infertility)
- [NICHD (NIH) — Infertility & fertility / age](https://www.nichd.nih.gov/health/topics/infertility)
- [StatPearls (NCBI Bookshelf) — Age-Related Fertility Decline](https://www.ncbi.nlm.nih.gov/books/NBK576440/)
- [NICE NG257 — Fertility problems: assessment and treatment (investigation & management)](https://www.nice.org.uk/guidance/ng257/chapter/Investigation-of-fertility-problems-and-management-strategies)

**Clinical — Tier 2 (ASRM / ESHRE / ACOG / AUA / peer-reviewed):**
- [ASRM — Fertility Evaluation of Infertile Women: a committee opinion (2021)](https://www.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/) · [integration copy](https://integration.asrm.org/practice-guidance/practice-committee-documents/fertility-evaluation-of-infertile-women-a-committee-opinion-2021/)
- [ASRM — Testing and Interpreting Measures of Ovarian Reserve: a committee opinion (2020)](https://www.asrm.org/practice-guidance/practice-committee-documents/testing-and-interpreting-measures-of-ovarian-reserve-a-committee-opinion-2020/)
- [ACOG — Anticipatory Counseling Regarding Ovarian-Factor Fertility Decline (Committee Statement, 2025)](https://www.acog.org/clinical/clinical-guidance/committee-statement/articles/2025/11/anticipatory-counseling-regarding-ovarian-factor-fertility-decline)
- [ACOG — Evaluating Infertility (patient FAQ; ≥35 six-month / >40 immediate)](https://www.acog.org/womens-health/faqs/evaluating-infertility)
- [ACOG — Infertility Workup for the Women's Health Specialist (Obstetrics & Gynecology, 2019)](https://journals.lww.com/greenjournal/fulltext/2019/06000/infertility_workup_for_the_women_s_health.47.aspx)
- [AUA/ASRM — Diagnosis and Treatment of Infertility in Men: Guideline Part I (2020)](https://www.asrm.org/practice-guidance/practice-committee-documents/diagnosis-and-treatment-of-infertility-in-men-auaasrm-guideline-part-i-2020/)
- [Merck Manual (Professional) — Diminished Ovarian Reserve](https://www.merckmanuals.com/professional/gynecology-and-obstetrics/infertility-and-recurrent-pregnancy-loss/diminished-ovarian-reserve)
- [Ovarian reserve does not influence natural conception: insights from infertile women (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11485058/)
- [AMH/AFC as predictors of natural fecundability (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6371573/)
- [Diagnosis and Management of Infertility: A Review (PubMed)](https://pubmed.ncbi.nlm.nih.gov/34228062/)
- [The ObG Project — Infertility Evaluation: Who, When and How (thresholds summary)](https://www.obgproject.com/2023/02/21/infertility-evaluation-who-when-and-how/)

**Age & fertility statistics (context — verify exact numbers at publish):**
- [RMA Network — Female Fertility Age Chart: pregnancy chances 20s–40s](https://rmanetwork.com/blog/what-are-my-odds-of-getting-pregnant-at-any-age/)
- [Age and female fertility — overview (Wikipedia, secondary; pin to Tier-1 at publish)](https://en.wikipedia.org/wiki/Age_and_female_fertility)

**Emotional / patient-journey (society + peer-reviewed):**
- [ASRM — Psychological Counseling](https://www.asrm.org/topics/topics-index/psychological-counseling) · [ASRM Mental Health Professional Group — The Psychological Impact of Infertility](https://connect.asrm.org/mhpg/education/infertilityimpact)
- [ACOG — Infertility: Disparities and Access to Services (Committee Statement, 2025)](https://www.acog.org/clinical/clinical-guidance/committee-statement/articles/2025/01/infertility-disparities-and-access-to-services)
- [Emotional Support for Infertility Patients: Integrating Mental Health Professionals (MDPI)](https://www.mdpi.com/2673-4184/2/1/8)
- [Emotional reaction to diagnosis of infertility (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2851694/)

**Competitor / app landscape:**
- [Best Fertility Tracking Apps 2026 (comparison)](https://www.go-go-gaia.com/blog/best-fertility-tracking-app.html)
- [Review: The best free fertility tracker apps (Motherfigure)](https://motherfigure.com/mag/review-the-best-free-fertility-tracker-apps/)
- [Top Fertility Tracking Apps (Proov)](https://proovtest.com/blogs/blog/top-fertility-tracking-apps)
- [Best Fertility Apps and Ovulation Trackers (MakeAMom)](https://www.makeamom.com/blog/best-fertility-apps-ovulation-trackers.html)

*Community insight (r/infertility, r/AgeGapTTC / TTC-after-35/37/40 threads, r/IVF DOR & low-AMH megathreads, fertility-clinic patient blogs, app-store reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. FTC actions vs. Flo (2021) and Premom (2023) referenced via the C1/C2 spec privacy sources; verify against primary FTC press releases at implementation. **[NEEDS SOURCE — FTC primary docs].** Named-app age-35+ diagnostic-phase and reserve-literacy gaps are directional from secondary review sources and hands-on category knowledge; verify before any public claim. **[NEEDS SOURCE].** Exact per-age conception/miscarriage percentages and AMH/FSH/AFC cutoffs must be pinned to live Tier-1/Tier-2 primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH].***
