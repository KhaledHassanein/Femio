# C16 — Premature Ovarian Insufficiency (POI) / Early Ovarian Decline at a Young Age (<40)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Femio never diagnoses, treats, prevents, or contracepts. Fertile-signal features are **awareness, not birth control** — and in POI this caveat is *doubly* load-bearing (occasional ovulation means pregnancy remains possible; HRT is **not** contraception). Screeners and thresholds are framed as *"screening / education — discuss with your clinician."* Femio does not run, order, or interpret medical tests, and **never labels a user "POI," "in early menopause," or "infertile."** POI is a **clinician's diagnosis**; Femio helps a user who *already has, or is being evaluated for,* that diagnosis to understand it, organize her care, and be held steady.
> Persona code: **C16** · Cohort: Conception (C), **bridging Menopause/Hormone-health (F)** · Last research pass: 2026-07-17
> **Bridge persona:** C16 is the deliberate hinge between the **C-cohort (fertility)** and the **F-cohort (menopause/hormone health)**. She is simultaneously a fertility persona *and* an early-hormone-loss persona — the spec must serve **both tracking needs at once** without collapsing one into the other.

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Yara," 31 (band <40; core 28–38, tail into teens/early 20s and up to 39) |
| **Age band** | **Under 40 — the defining variable.** POI = loss of normal ovarian function **before 40**; sub-groups skew younger (**<35, sometimes teens/early 20s**). "Early menopause" (40–45) is a *sibling* band handled in the F-cohort; C16 is specifically the **young, unexpected** decline where fertility grief and multi-decade hormone-health both bite. [NICHD; ESHRE 2024] |
| **Stage** | **Being evaluated for, or newly living with, POI** — persistently irregular/absent periods + menopausal-type symptoms at a young age, or an FSH result her clinician called "menopausal." Facing **unexpected fertility decline/loss**, possible **early-menopause symptoms**, and **grief** — often all at once, decades ahead of "schedule." |
| **Relationship** | Mixed: partnered, single, LGBTQ+. Family-building status varies enormously — some were actively TTC, some hadn't started, some are teens told they may never carry. The diagnosis reframes an assumed future for all of them. |
| **Goal (top JTBD)** | *"Help me understand what POI actually is (and isn't) — is this menopause? Am I infertile? Can I still get pregnant? What do I do about my hormones for the next 20+ years? — organize my two very different care needs (fertility AND hormone/bone/heart health), and hold me through grief I wasn't remotely ready for."* |
| **Health literacy** | Variable and **whiplashed**. Blindsided by a diagnosis most have never heard of, frequently **misdiagnosed/dismissed for months** ("you're too young," "it's just stress"), then drowned in conflicting content that conflates POI with ordinary menopause. Needs **plain-language, referenced, uncertainty-honest** framing that untangles POI-vs-menopause and fertility-vs-hormone-health. |
| **Tech context** | Web-first; also phone. Often arrives from a cycle tracker that kept flashing "late period" / "your cycle is irregular" with **no explanation and no off-ramp** — or from a fertility app whose entire model (predict ovulation, time intercourse) has just been detonated. |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. In many AR/MENA markets, a young woman's (in)fertility carries acute stigma and is wrongly framed as her failing or her family's shame; **"early menopause" adds an aging/"defective" stigma layer.** Privacy and dignity paramount. |
| **Emotional state** | **Acute grief + identity rupture + fear of the future.** Not the "trying and waiting" grief of C1–C3 — this is the **sudden loss of an assumed fertile future**, plus feeling "prematurely old," plus health-anxiety about bones/heart/brain over decades. Qualitative research names it exactly: *psychological distress and identity loss, deprivation of reproductive autonomy, the experience of premature aging, and lack of social support.* Depression risk is elevated, especially with younger age at diagnosis and fertility grief. [PMC 12790688; PMC 12688449] |
| **What she is NOT** | Not in ordinary menopause (ovarian activity in POI can be **intermittent**, so spontaneous pregnancy remains possible but unpredictable). Not an ART patient *yet* (that's **C10**), though donor-egg IVF may be discussed if she wants to carry (→ **C10/C13**). Not diagnosed *by Femio*. Not someone to be told "at least you know" or "you can just adopt." Not a standard F-cohort menopause user — her hormone-loss is **premature, health-consequential, and entangled with fertility grief.** |
| **Primary signals she brings** | Age <40; irregular/absent-period history; menopausal-type symptoms young (hot flushes, night sweats, vaginal dryness, low libido, sleep/mood, brain fog); **clinical data** she may already hold — **FSH result(s), estradiol, AMH, karyotype, FMR1/fragile-X premutation status, thyroid/adrenal antibodies, DXA/bone-density, lipids/BP**; a diagnosis note; HRT/MHT regimen; fertility-counselling / donor-egg discussions. |
| **Success = she leaves us because…** | She's **stable and informed** — HRT-educated and continuous, fertility path chosen (spontaneous-conception awareness → **D-track PAI**, or donor-egg IVF → **C10/C13**, or child-free/adoption peace), grief metabolized, and long-term bone/CV/hormone health carried forward into the **F-cohort** on the *same account, no restart*. Or she simply stays, held, in a hormone-health-forward state for years. |

**Persona thesis.** C16 is the persona **no mainstream app serves at all** — a young woman handed a diagnosis that is simultaneously a major fertility loss and a long-horizon hormone-health condition, wrapped in profound grief, and frequently conflated with "early menopause." Three things drive the spec: (1) **POI is not established menopause** — ovarian activity can be intermittent and spontaneous pregnancy remains possible but unpredictable; the distinction itself is a flagship educational job. (2) **Dual tracking is non-negotiable** — she needs a fertility layer and a hormone/bone/CV layer side by side. (3) The emotional register is grief + identity rupture + premature-aging fear, not the hopeful limbo of TTC.

---

## B. Needs & questions (voice-of-user)

Mined from r/POI, r/PrematureOvarianFailure, r/menopause (young-POI threads), Daisy Network community, fertility-clinic POI blogs, and app-store reviews. Phrasing is representative/composite (community norms; not quoting individuals).

**"What even is this?" — the definitional shock (the C16 epicenter):**
1. *"I'm 31 and my doctor said my FSH is 'menopausal.' Am I in menopause? Is this permanent?"* (Answer: POI ≠ menopause; ovarian function can fluctuate — see §D.)
2. *"POI vs POF vs early menopause vs 'diminished reserve' — what's the actual difference and which do I have?"*
3. *"They said I might still ovulate sometimes. So am I infertile or not?"* (Both grief AND hope are true — this ambiguity is the hardest part.)
4. *"It took a year and three doctors who said 'you're too young for this' before anyone tested my FSH."* (Diagnostic delay / dismissal is near-universal.)

**Fertility questions (grief + a sliver of hope):**
5. *"Can I still get pregnant on my own, or is that false hope?"*
6. *"If I want a baby, is donor egg my only realistic option? How does that even work?"* (→ C10/C13.)
7. *"Should I freeze eggs NOW before it's worse — or is it already too late?"* (Time-anxiety; often already past the window — needs gentle, honest framing.)
8. *"My periods came back for two months then stopped — did my ovaries 'wake up'? Could I get pregnant right now?"* (Intermittent function → the *not-contraception* + *pregnancy-still-possible* double message.)
9. *"I got my POI diagnosis before I ever tried to have kids. How do I grieve something I never got to attempt?"*

**Hormone-health questions (the F-cohort layer she didn't expect):**
10. *"Why do I need HRT at 30? I thought that was for older women."* (Answer: bone/heart/brain protection until ~natural-menopause age — see §D.)
11. *"Is HRT safe? I read scary things about breast cancer."* (POI HRT risk/benefit ≠ older-menopause HRT — must be distinguished.)
12. *"How long do I stay on HRT — forever?"* (Until ~51, the average age of natural menopause, then reassess.)
13. *"HRT vs 'the pill' — my doctor offered both, what's the difference for POI?"*
14. *"What about my bones and heart? Someone mentioned osteoporosis and I'm terrified."* (Long-term risk education — bone/CV are POI-specific stakes.)
15. *"The hot flushes and brain fog and dryness at 29 make me feel broken and old."* (Premature-aging distress.)

**Cause / workup questions:**
16. *"Why did this happen to me? They said 'idiopathic' — does that mean no reason?"* (Most cases are idiopathic; state honestly.)
17. *"They're testing me for fragile X and a chromosome thing — should I be scared? Does it affect my family?"* (FMR1/Turner → family-planning + relatives' implications.)
18. *"Is this autoimmune? Do I need my thyroid/adrenals checked too?"*

**Emotional-arc needs (design must respect this):**
- **Grief for an assumed future**, not a failed cycle — often *disenfranchised grief* (no one recognizes it as a loss).
- **Identity rupture / "premature aging"** — feeling old, defective, out-of-step with peers who are having babies.
- **Isolation** — almost no one her age understands; "everyone I know is pregnant or complaining about being 25."
- **Ambiguity fatigue** — holding grief and an unpredictable residual possibility simultaneously is exhausting.
- AR/MENA: young-infertility stigma **plus** "early menopause = defective bride/wife" shame — acute, private.

**Anti-needs / trust-breakers (churn drivers):**
- Being told (or having an app imply) she's **"in menopause," "infertile," or "done"** — untrue, cruel, and Femio's job is to *not* say it.
- Toxic positivity ("at least you know now," "just do donor eggs," "just adopt," "you can always...").
- False hope ("miracle babies!") *or* false doom ("your fertility is over") — both wrong.
- A cycle tracker that keeps flashing **"late period" / "irregular cycle"** at her with no explanation and no way to say *"I have POI, stop counting."*
- A menopause app that assumes she's 52 and ignores fertility entirely.
- A fertility app that keeps optimizing an ovulation model that no longer applies.
- Being **dismissed** ("too young") — she's had enough of that from humans.
- Privacy creep on reproductive + genetic + hormone data (post-Flo/Premom FTC distrust), tripled by genetic (FMR1/karyotype) sensitivity.

**Feature requests recurring in reviews/forums:**
- A **"POI is not menopause" explainer** that untangles the terms and explains intermittent ovarian activity without a personal forecast.
- **Dual home**: a fertility layer AND a hormone/bone/heart layer, visibly co-existing.
- **HRT-for-POI education + log** (why, which regimens, how long, HRT-vs-pill, safety *specific to POI* not older menopause) — educational, never a dose.
- **Symptom tracker** for the menopausal-type symptoms (flushes, sleep, mood, dryness, libido, brain fog) — the F-cohort MRS-style log, at 30.
- **Clinical-results home** for FSH/E2/AMH, karyotype/FMR1, thyroid/adrenal antibodies, **DXA/bone density**, lipids/BP.
- **Donor-egg / family-building options explainer** with the honest odds and the *decision-space* (donor IVF, adoption, child-free) — bridge to **C10/C13**.
- The **not-contraception + still-possibly-fertile** double caveat, stated kindly.
- **Grief support** built for *this* grief (disenfranchised, ambiguous, premature-aging) — not generic sadness cards.
- Referenced content she can trust over a forum, in her language.

---

## C. Competitor teardown

Focused on **the young-POI dual-need**: POI-vs-menopause literacy, fertility-*and*-hormone-health at once, and grief calibrated to premature loss. Key insight: **essentially no consumer app serves POI at all.** Cycle trackers actively mishandle her (endless "irregular" flags); fertility apps assume a working ovary; menopause apps assume she's in her 50s and drop fertility entirely. POI falls straight down the seam between two app categories — the **purest whitespace in the taxonomy.**

| App | What it's built for | POI-vs-menopause literacy | Dual fertility + hormone-health support | Emotional support (premature grief) | Where it fails C16 |
|---|---|---|---|---|---|
| **Flo** | Mass-market cycle + fertile-window prediction | None — no POI concept; treats her cycles as "irregular" to be predicted | Fertility-timing only; no hormone/bone/HRT layer at all | Generic community/content; not POI- or grief-specific | Endlessly flags "late/irregular period" with no explanation or off-ramp; can read as a daily wound; **FTC 2021** data legacy erodes trust for reproductive + (potential) genetic data |
| **Clue** | Cycle science + education | Some general "irregular cycle causes" content; no POI pathway or dual model | Timing-centric; no HRT/bone/CV layer | Educational tone, not grief-calibrated | No POI diagnosis pathway, no hormone-health tracking, no fertility-decision support; she's a data anomaly, not a served user |
| **Ovia / Premom / Fertility Friend** | Fertility timing / OPK-BBT charting | None | Fertility only; the ovulation model **has just stopped applying to her** | Minimal / TTC-framed | Purpose-built to optimize a timing problem POI removes; **Premom FTC 2023**; abandons her at diagnosis |
| **Balance / menopause apps (Balance, Caria, Perry, etc.)** | Peri/menopause symptom tracking + HRT support (40s–50s) | Treat POI as "early menopause" at best; assume an older user | Strong hormone/symptom/HRT layer — **but fertility is gone entirely** (assumes childbearing is over) | Menopause-community support, but peers are 50+, not 30 | Ignore that C16 is *young and may still want/consider children*; no donor-egg/fertility-decision bridge; peer mismatch deepens her isolation; no POI-vs-menopause correction |
| **Fertility-clinic / donor-egg program apps** | Managing an active donor-IVF cycle at one clinic | Clinic's framing, siloed | Strong for the *donor-IVF cycle* only; no hormone-health-for-life layer | Task reminders; little grief support | You must already be a clinic patient choosing donor eggs; nothing for the pre-decision, hormone-health, or grief phases; not portable; rarely Arabic-first |
| **Daisy Network / POI charities (web)** | Peer support + referenced POI info (excellent, non-app) | **Best-in-class POI literacy** — but it's a website/community, not a personalized tracking app | Educational, not a tracker; no logs/home/dual-layer state | Strong lived-experience community | Not an app, not personalized, no dual-tracking, no Arabic-first localization, no data home — a content peer, not a product competitor |

**The fragmentation map (the opening for Femio):**
- **Cycle trackers** don't just fail C16 — they *hurt* her, flagging "irregular" indefinitely with no explanation or exit.
- **Fertility apps** optimize a timing model POI has invalidated.
- **Menopause apps** get the hormone layer roughly right but **erase her fertility question and assume she's 50+** — the exact mismatch that deepens young-POI isolation.
- **Clinic/donor apps** only start after she's chosen a path and become a patient.
- **POI charities** own the literacy but aren't apps.
- **Nobody** offers: a **referenced, POI-vs-menopause-literate explainer** + **simultaneous fertility AND hormone/bone/CV tracking on one home** + **HRT-for-POI education (distinct from older-menopause HRT)** + **honest donor-egg/family-building decision support (bridge to C10/C13)** + the **not-contraception + still-possibly-fertile double caveat** + **grief calibrated to premature, disenfranchised, ambiguous loss** + **Arabic-first/RTL** + **privacy-by-design for reproductive + genetic + hormone data** + **one account that carries her from fertility grief into lifelong hormone health without starting over.** *That is C16's Femio thesis — the clearest whitespace in the map.*

---

## D. Clinical grounding (cited)

> All claims below are **patient-education framing**. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, order tests, or interpret results — it explains, in plain language, what POI *is*, what a clinician-directed evaluation and management involve, and routes every specific concern to "discuss with your clinician." **POI, its cause, and every lab value are context for a clinician conversation — never a Femio verdict or label.**

**What POI is — and the definitional distinction that defines C16 (critical for §I/§J):**
- **Primary/premature ovarian insufficiency (POI)** = loss of normal ovarian function **before age 40**, causing irregular/absent periods, low estrogen, and reduced fertility. It can begin as early as the teens or 20s. [NICHD — Primary Ovarian Insufficiency; MedlinePlus]
- **Diagnosis (clinician-made, never by Femio):** the 2024 international guideline describes disordered cycles for at least 4 months plus FSH above 25 IU/L, with repeat FSH after 4–6 weeks only if diagnosis is uncertain. NICE NG23 still describes two elevated samples 4–6 weeks apart. Both treat diagnosis as clinical and advise against routinely substituting AMH. Femio shows the source and never interprets a result. ([ASRM/ESHRE international guideline 2024](https://www.asrm.org/practice-guidance/practice-committee-documents/evidence-based-guideline-premature-ovarian-insufficiency--2024/); [NICE NG23, updated April 2026](https://www.nice.org.uk/guidance/ng23/chapter/Recommendations))
- **POI is not the same as established menopause — the flagship caveat.** Ovarian activity may be intermittent, so occasional periods, ovulation, and pregnancy can occur unpredictably. Femio does not publish a universal spontaneous-conception percentage or use this possibility to minimize fertility grief. ([ASRM/ESHRE international guideline 2024](https://www.asrm.org/practice-guidance/practice-committee-documents/evidence-based-guideline-premature-ovarian-insufficiency--2024/))
- **"Early menopause" (40–45)** is a *distinct, older sibling band* (handled in the F-cohort). C16 is specifically **<40 / young**, where fertility grief and a multi-decade hormone deficit both apply. [ESHRE 2024] *Design implication:* the resolver must **never conflate** C16 with a standard F-cohort menopause user, and must never surface "menopause"/"infertile" as a Femio label.

**Prevalence (grounds "uncommon but real; you are not alone"):**
- Published estimates vary by population and case definition. Femio uses no global prevalence percentage in user-facing copy.

**Causes (answer the "why me?" — most often no clear answer):**
- **Idiopathic / unknown:** sometimes no cause is identified.
- **Genetic:** clinicians may evaluate chromosomal causes and **FMR1 premutation**, which can have implications for relatives and offspring.
- **Autoimmune:** clinicians may evaluate associated thyroid or adrenal autoimmunity.
- **Iatrogenic:** chemotherapy, radiation, or ovarian surgery (a distinct, often *known* cause — relevant to oncofertility overlap). [O&G Magazine; NICHD]
- *Femio framing:* explains categories and why a clinician tests for them; **never assigns a cause** and handles genetic results with elevated privacy/sensitivity (§H/§K).

**Hormone therapy for POI — the F-cohort layer, distinct from older-menopause HRT (load-bearing):**
- The international guideline recommends **hormone therapy until the usual age of menopause**, whether or not symptoms are present, to reduce morbidity and mortality. NICE offers a clinician-directed choice of HRT or combined hormonal contraception unless contraindicated. Femio explains the replacement rationale, never a dose/product, and notes that HRT is not contraception. ([ASRM/ESHRE international guideline 2024](https://www.asrm.org/practice-guidance/practice-committee-documents/evidence-based-guideline-premature-ovarian-insufficiency--2024/); [NICE NG23](https://www.nice.org.uk/guidance/ng23/chapter/Recommendations))
- **Long-term stakes if untreated:** premature estrogen deficiency raises risks of **osteoporosis/fracture and cardiovascular disease**, and is associated with reduced life expectancy — which is *why* HRT-until-natural-menopause-age is framed as protective, not optional lifestyle. [ESHRE 2024; PMC 10299102 (bone); CCJM 2025]
- **Not contraception (the doubled caveat):** **HRT is not a contraceptive**, and because ovulation can occur intermittently in POI, **pregnancy remains possible** — a woman not wanting pregnancy needs separate contraception; a woman wanting pregnancy retains a small spontaneous chance. Femio states both plainly and routes to clinician. [NHS/Leeds POI patient guide; Daisy Network]

**Fertility & family-building options (education only — the C-cohort layer):**
- **Spontaneous conception can occur** because ovarian activity may be intermittent, but it is unpredictable. Femio gives no percentage, fertility forecast, or protection verdict.
- **Ovarian stimulation / a woman's own eggs generally does not restore fertility**; **donor-egg IVF is the most effective route to pregnancy** for those who want to carry, with high success rates. **Egg/embryo freezing** is only relevant if diagnosed *very* early with residual function (often already past the window). **Adoption and child-free living** are equally valid paths. A cross-sectional survey (324 women) documents the range of family-building choices after POI. [Mid-Iowa Fertility; Advanced Fertility; Oxford EJE survey 2023] *Design implication:* the fertility layer is **decision-support + honest odds**, bridging to **C10 (ART) / C13 (donor conception)** — never a promise.

**Emotional impact (grounds the support features):**
- POI diagnosis carries **shock, grief over lost fertility and an assumed future, identity loss, and a sense of premature aging**; qualitative themes include *psychological distress and identity loss, deprivation of reproductive autonomy, premature-aging experience, barriers to integrated care, and lack of social support.* **Depression risk is elevated**, associated with younger age at diagnosis, severe symptoms, and fertility grief; **delayed diagnosis, no HRT, and no fertility counselling worsen distress.** [PMC 12790688 (qualitative); PMC 12688449 (depressive symptoms)]

*Femio applies all of this as **educational routing and organization**, always ending "discuss with your clinician" — never as a diagnosis, cause assignment, result interpretation, dose, or fertility/menopause verdict.*

**Medical-source resolution.** The guideline disagreement on repeat FSH is explicit; diagnostic interpretation remains clinician-only; unsupported prevalence, cause, and spontaneous-conception percentages and all HRT dose examples are excluded. See [`REPRODUCTIVE_TREATMENT_SAFETY.md`](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md). *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

*Builds a **dual spine**: a C-cohort fertility layer AND an F-cohort hormone/bone/CV layer, co-resident. **Bold = C16-defining.***

**P0 — Must-have (defines the persona; ship first):**
1. **"POI is not menopause" explainer + orientation (the C16 centerpiece)** — referenced, plain-language untangling of **POI vs early menopause vs POF vs "diminished reserve,"** explaining intermittent activity and unpredictable residual possibility without a percentage or personal forecast.
2. **Dual home — fertility layer + hormone-health layer, visibly co-existing.** Not one or the other: a **family-building/fertility** module *and* an **F-cohort hormone/symptom/bone/CV** module both present, user able to weight which leads.
3. **Menopausal-symptom tracker at a young age (F-cohort MRS-style log)** — flushes, night sweats, sleep, mood, vaginal dryness, libido, brain fog — logged as *awareness*, validating that these are real at 30, feeding symptom-education (never a severity "diagnosis").
4. **HRT-for-POI education + log (educational)** — *why* HRT at a young age (bone/CV/brain protection **until ~natural-menopause age**), how it **differs from older-menopause HRT** (rationale, higher physiologic dosing *as guidelines describe*, HRT-vs-pill), safety framed **specific to POI**, and how long. **Never a dose, never "start/stop," always "discuss with your clinician."**
5. **Clinical-results & lab home (self-entered, entry-only, never interpreted)** — **FSH/E2/AMH**, **karyotype**, **FMR1/fragile-X**, **thyroid/adrenal antibodies**, **DXA/bone density**, **lipids/BP** — each with category-level "what this measures," genetic results handled with **elevated privacy** (§H/§K).
6. **Family-building options explainer + honest odds** — spontaneous-conception awareness (with the *not-contraception* + *still-possible* double caveat), **donor-egg IVF** as the main path, egg-freezing (if residual function), adoption, child-free — as a **decision space**, bridging to **C10/C13**. Education only; never a promise.
7. **Grief-calibrated emotional layer (built for THIS grief)** — cards tuned to **disenfranchised, ambiguous, premature-aging grief** (grieving an assumed future / a loss others don't recognize / holding grief-and-hope at once / feeling "old" at 30), a mood/anxiety **screener** (screening-framed + localized crisis resources), coping content. Explicitly avoids "at least you know," "just do donor eggs," "just adopt."
8. **The double caveat, everywhere relevant** — *POI is not menopause; occasional ovulation and pregnancy remain possible; HRT is not contraception* — stated kindly, on every fertility/HRT surface.
9. **"Stop flagging me as late/irregular" control** — a POI-aware cycle mode that **suppresses "late period"/"irregular cycle" nudges and countdowns**, degrading gracefully to symptom + trend view (inherits the uncertainty-honest / irregular-state UX from PCOS/perimenopause).

**P1 — Strong differentiators (fast follow):**
10. **Bone & cardiovascular-health module (F-cohort, young-onset framing)** — why estrogen matters for bones/heart over *decades*, what DXA/lipids/BP monitoring involve, lifestyle education — framed as protective, never alarmist. Bridges cleanly into the F-cohort long-term.
11. **Cause / work-up explainer** — idiopathic (most), Turner, **FMR1/FXPOI (with sensitive family-implications framing)**, autoimmune, iatrogenic (chemo/radiation/surgery) — categories only, never a cause assignment.
12. **Referenced content library** — POI-vs-menopause, HRT-for-POI, donor eggs, bone/heart health, genetics — grade 6–8, 4 languages, RTL-first.
13. **Clinician-visit prep pack** — exportable summary (symptoms + labs + HRT + questions), tuned for the *two* care conversations (fertility team AND menopause/endocrine/bone care).
14. **Partner mode (optional, scoped)** — shared understanding of diagnosis, family-building decision-space, and support; consent-gated, revocable.
15. **Timeline / continuity view** — one portable narrative that will carry her **into the F-cohort** at ~natural-menopause age with zero restart.

**P2 — Nice-to-have / later:**
16. Moderated, privacy-safe POI community (age-matched — the antidote to "everyone I know is 25 and pregnant"); guarded against false-hope and false-doom misinformation.
17. Journal / decision-notes space (family-building and identity decisions are heavy).
18. Region-aware cost/coverage education (donor-egg IVF, HRT access) — education only.
19. Localized, stigma-aware AR/MENA content (young-infertility **and** "early menopause" shame de-escalation; privacy/dignity).
20. Oncofertility cross-link for iatrogenic POI (chemo/radiation survivors).

**Explicitly OUT of scope for C16 (guardrail):**
- **Diagnosing or labeling POI, "early menopause," "infertility," or its cause.** Femio serves a user who *has, or is being evaluated for,* a clinician's diagnosis; it **never** declares it. Screeners/thresholds **flag & route**, never diagnose (§K).
- Ordering, running, or **interpreting** any test — including **FSH/AMH/karyotype/FMR1/DXA** (categories explained; only her clinician interprets *her* results).
- Any **HRT dose, start/stop/switch instruction**, or "this regimen is right for you." Education only.
- Any **fertility "score," probability verdict, or countdown**; never "you can't conceive" and never "you'll get your miracle."
- Any **contraception / "safe day"** framing — *and* Femio must actively state the **opposite** for POI (pregnancy remains possible; HRT ≠ contraception).
- ART/donor-IVF cycle management (meds/stims/monitoring) — that is **C10/C13** (C16 pre-loads the bridge).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each card carries citations, a medical-review byline + date, and "not medical advice / discuss with your clinician."

- **"POI is not menopause — what your diagnosis actually means"** — the flagship: POI vs early menopause vs POF vs diminished reserve; intermittent activity; holding grief and uncertainty. ([ASRM/ESHRE 2024](https://www.asrm.org/practice-guidance/practice-committee-documents/evidence-based-guideline-premature-ovarian-insufficiency--2024/))
- **"Why did this happen? — the causes of POI"** — idiopathic (most), Turner, **fragile-X/FMR1 (with family-implications, handled gently)**, autoimmune, chemo/radiation/surgery; category-level, no cause assignment. [O&G Magazine; NICHD FXPOI; Merck]
- **"Understanding your tests"** — FSH result(s), estradiol, AMH, karyotype, FMR1, thyroid/adrenal antibodies, DXA, lipids/BP — what each category checks and why clinicians may order it; no interpretation.
- **"HRT for POI — why, which, and how long"** — the protective rationale (bone/heart/brain **until ~natural-menopause age**), how POI HRT differs from older-menopause HRT, HRT-vs-pill, safety-specific-to-POI, duration — **no doses as advice.** [ESHRE 2024; Human Reproduction Open 2017]
- **"Your bones and heart, protected"** — why young estrogen loss matters over decades; DXA/lipids/BP; lifestyle; framed protective, not alarmist. [PMC 10299102; CCJM 2025]
- **"Can I still get pregnant? — fertility and family-building with POI"** — spontaneous-conception honesty + the *not-contraception* + *still-possible* double caveat; donor-egg IVF; egg-freezing (if applicable); adoption; child-free — a decision space, not a promise. Bridges **C10/C13**. [Daisy Network; Mid-Iowa; Oxford EJE 2023]
- **"Living with menopausal symptoms in your 20s/30s"** — flushes, sleep, mood, dryness, libido, brain fog; that they're real; coping + when to seek care.
- **"The grief no one prepared you for"** — disenfranchised/ambiguous grief, premature-aging feelings, identity, isolation; coping; when to seek mental-health support; **de-escalating "at least..." and "just adopt."** [PMC 12790688; PMC 12688449]
- **"Getting the most from your care — two conversations"** — preparing for both the fertility team and the menopause/endocrine/bone care; what to bring and ask.
- **Stigma-aware module (AR/MENA-first)** — young-infertility **and** early-menopause shame de-escalation; privacy and dignity.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable — including the **F-cohort menopause library** she'll grow into and any C1/C3 fertility content — so C16 never feels boxed into "POI only."

---

## G. Tools, logs & alerts (compliant framing)

**Logs (inputs):**
- Cycle/bleed log in **POI-aware mode** (no "late"/"irregular" shaming; captures the *waves* of activity as awareness).
- **Menopausal-symptom log** (flushes, night sweats, sleep, mood, vaginal dryness, libido, brain fog) — F-cohort-style, awareness only.
- **Clinical results (self-entered, entry-only, never machine-interpreted):** **FSH/E2/AMH**, **karyotype**, **FMR1/fragile-X**, **thyroid/adrenal antibodies**, **DXA/bone density**, **lipids/BP**. FSH/E2 and DXA support **trend views** (awareness, not scoring).
- **HRT/MHT log (educational)** — regimen name, form, start/stop dates *as the user records them* — for continuity/visit-prep, **never** as a schedule Femio prescribes.
- Family-building intentions/decisions; appointments (fertility team AND menopause/endocrine/bone); questions-for-visit.
- Mood/anxiety screener history (scores + dates, screening-only).
- `emotional_state_tags` incl. **new-diagnosis-shock / fertility-grief / premature-aging-distress / holding-grief-and-hope / hrt-decision** (drive support-card selection).

**Tools:**
- POI-aware cycle mode (suppresses late/irregular nudges + countdowns).
- Dual home (fertility layer + hormone/bone/CV layer).
- Menopausal-symptom tracker + trend.
- HRT-for-POI education + log (never a dose).
- Clinical-results home with category explainers (genetic results elevated-privacy).
- Bone/CV-health module + DXA/lipid/BP trend.
- Family-building options explainer + honest-odds decision space (→ C10/C13 bridge).
- Clinician-visit prep generator (two-conversation aware; one-tap export/print).
- Timeline/continuity view; PDF/image export.
- Mood/anxiety screener (PHQ-2/GAD-2-style) → screening-framed output + localized crisis resources.

**Alerts / nudges (all opt-in, tone-calibrated, dismissible, revocable, RTL-aware):**
- "New FSH/estradiol or DXA result to log? Add it to see your trend and read what this category means." (awareness, never interpretation)
- "It might be worth talking with your clinician about hormone therapy and bone/heart health — here's what the guidelines describe." (awareness routing, **never** "start HRT")
- "Appointment with [fertility team / menopause care] in 2 days — want to finish your questions?"
- Emotional-arc cards: new-diagnosis-shock support, fertility-grief, premature-aging steadying, holding-grief-and-hope, HRT-decision support.
- Screening follow-up (re-check mood in N weeks) + crisis resources on any low screen.
- **Never:** "you are in menopause"; "you are infertile"; "you can't get pregnant"; any HRT dose/start/stop; contraception/"safe day" language; **and Femio actively states the opposite where relevant** — pregnancy remains possible, HRT is not contraception; never a countdown/score; never "you have [diagnosis]"; never disease-prevention claims; never "you need test X."

**Mandatory compliance wording on relevant surfaces:**
- *"Femio helps you understand and organize your care — it does not diagnose POI or menopause, order tests, interpret your results, or prescribe hormone therapy. Only your clinician can do that."*
- On every POI-vs-menopause surface: *"POI is not the same as established menopause. Ovarian activity can be intermittent, so spontaneous pregnancy can still occur, but Femio cannot predict this for you. Discuss fertility and contraception with your clinician."*
- On every fertility/HRT surface: *"Pregnancy is still possible with POI, and hormone therapy is **not** a contraceptive. If you want to avoid pregnancy, discuss contraception with your clinician; if you hope to conceive, discuss your options with a fertility specialist."*
- On HRT surfaces: *"Any doses or regimens shown are what clinical guidelines describe, for education only — not a recommendation for you. Never start, stop, or change hormone therapy without your clinician."*
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (from screeners, non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamp + "non-diagnostic" tag).

**C16 persona-specific (spans the C-cohort fertility layer AND the F-cohort hormone layer; bold = C16 delta):**
- `poi_status_flag` = `under_evaluation` | `diagnosed_by_clinician` (**user-reported diagnosis, never Femio-assigned**) — drives dual-layer home; **never rendered as a Femio label to the user or third parties.**
- **`ovarian_labs[]`** {test_type: FSH | E2 | AMH, value, unit, date, occasion_note} — FSH/E2 trend-enabled; **entry-only, never interpreted, never used to declare POI/menopause.**
- **`genetic_results[]`** {test_type: karyotype | FMR1_premutation, result_note, date} — **elevated-privacy class** (family implications), entry-only, no interpretation.
- `autoimmune_labs[]` {test_type: thyroid_ab | adrenal_ab | TSH, value, date} — entry-only.
- **`bone_cv_health[]`** {test_type: DXA_tscore | lipids | BP, value, date} — trend-enabled (bone/CV monitoring awareness).
- **`menopausal_symptoms[]`** {symptom, severity_self_report, date} — F-cohort-style log, awareness only, no severity "diagnosis."
- **`hrt_log[]`** {regimen_name, form (oral/transdermal/pill), start_date, stop_date, source_note} — **user-recorded, educational, never a Femio-prescribed schedule or dose.**
- **`family_building_intent`** = `wants_children` | `undecided` | `child_free` | `already_deciding_donor` — drives fertility-layer weighting; editable anytime.
- `family_building_options_viewed[]` (spontaneous-awareness / donor-egg / freezing / adoption) — soft signal toward **C10/C13**, not a state change.
- `cause_category_noted` (idiopathic | Turner | FMR1 | autoimmune | iatrogenic) — **user-recorded clinician finding only, never Femio-assigned.**
- `appointments[]` {clinician (fertility team / menopause-endocrine / bone care), type, ordered_tests[], results_due, status}.
- `visit_questions[]`, `visit_prep_exports[]`.
- `mood_screen_history[]` {tool, score, date} (screening-only).
- `emotional_state_tags[]` (**new_diagnosis_shock / fertility_grief / premature_aging_distress / grief_and_hope / hrt_decision** / waiting) — drives support-card selection.
- `partner_link_id`, `partner_scope`, `partner_consent_ts`.

*Data-minimization & heightened sensitivity: reproductive + **genetic (karyotype/FMR1)** + hormone data is special-category health data with **compounded** stigma risk (young-infertility + early-menopause + genetic/familial); encrypted, user-deletable, never shared with ad networks/analytics; strict retention on uploaded lab PDFs/genetic reports. Genetic data carries the **highest** sensitivity tier. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C16 — the age + diagnosis answers are the pivot):**
1. "What brings you to Femio?" → *My cycles have changed / my hormones / a diagnosis I was given* (may also arrive via TTC or menopause branches, or via **Z1** and be offered C16 later).
2. Age capture → **<40** ⇒ POI-band candidate (this is the fork away from a standard F-cohort menopause user).
3. "Has a clinician talked to you about premature/primary ovarian insufficiency, early menopause, or 'menopausal' hormone levels at a young age?" → *yes, diagnosed* ⇒ `poi_status_flag = diagnosed_by_clinician`; *being tested / not sure* ⇒ `under_evaluation` (both enter C16 dual-layer; **Femio never confirms the diagnosis itself**).
4. "Which matters most to you right now?" (family-building / my hormones & symptoms / understanding what this is / all of it) ⇒ sets which layer *leads* the dual home (both remain present).
5. "Where are you with family-building?" (want children / undecided / not planning children / already exploring donor eggs) ⇒ sets `family_building_intent`, fertility-layer weight, and C10/C13 bridge readiness. **Optional, skippable, editable** — grief-safe.
6. "Any of these apply?" (chemo/radiation/ovarian surgery, a genetic result like Turner or fragile-X, thyroid/autoimmune condition, family history of early menopause) → raise relevant content sensitively; **no cause assignment.**
7. "Involve a partner?" → optional scoped partner mode.
8. Consent & privacy choices (explicit reproductive + **genetic** + hormone data notice; genetic = highest tier).

**Home config for C16:**
- Hero = **dual card**: the leading layer per Q4 (fertility *or* hormone-health) up top, the other **always visibly present** below — the "one account, two needs" proof. New-diagnosis users default to the **"POI is not menopause" orientation** as hero.
- Secondary = menopausal-symptom log + trend; clinical-results/bone-CV home; HRT-education card; family-building options card (weighted per intent); emotional-support card matched to current `emotional_state_tag`.
- **POI-aware cycle mode ON by default:** no "late period"/"irregular" nudges or countdowns; graceful degrade to symptom + trend.
- **De-emphasize** any C1-style fertile-window hero (misleading in POI) — keep reachable, never primary, always carrying the *not-contraception + still-possible* caveat.
- **Hidden-but-reachable:** full lifespan library, the **F-cohort menopause library** (she'll grow into it), C1/C3/C10/C13 fertility content, contraception *education* — one search/tap away.

**Adaptive tone:** validating, steady, honest, **grief-aware and non-dismissive** (she's been dismissed enough). Hold grief-and-hope simultaneously; never toxic-positive, never "at least you know," never "in menopause"/"infertile," never a countdown. Escalate emotional-support prominence around new diagnosis, fertility decisions, HRT decisions, and premature-aging distress; surface mental-health module + resources if mood screens trend low.

---

## J. Adaptation triggers (state transitions)

*Inherits all **universal events** from the Master Adaptation Model §6 (positive test, loss, mood-crisis, red-flag, disengagement, mode-off, age-of-consent). Listed below are **C16-specific** transitions, plus the explicit **C-cohort ↔ F-cohort blend** this bridge persona owns.*

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Arrives with POI diagnosis or under-evaluation at <40** | wizard: age <40 + clinician-diagnosis / being-tested; or **Z1** nearest-persona match on young age + menopausal symptoms + irregular/absent cycles + FSH-menopausal note | Activate **dual-layer** C16: "POI is not menopause" orientation, POI-aware cycle mode, symptom log, HRT + fertility layers, results/bone-CV home, grief-calibrated support. **Femio never confirms the diagnosis.** | **Become C16** (this persona) |
| **HRT education engaged / user starts HRT (reports)** | user logs an HRT regimen or opts into HRT education | Raise HRT-for-POI + bone/CV modules; enable HRT log (continuity, **never a dose**); this is the **F-cohort hormone-health continuity** thread that will carry her forward. | Stay C16, raise F-cohort hormone-health emphasis |
| **Family-building decision → donor path** | user records exploring/starting donor-egg IVF or freezing | Sensitive confirm; hand off to **ART / donor-conception experience** carrying **all** C16 data forward (labs, symptoms, HRT, timeline). `family_building_options_viewed` primes a *warm*, not cold, transition. | **C10 (ART/IVF) / C13 (donor conception)** |
| **Spontaneous positive pregnancy test** | `hpt` positive or user confirms | Universal positive-test handler; offer **Pregnancy mode flagged Pregnancy-After-Infertility (PAI)**; suppress any "you can't conceive" narrative; retire timing widgets; carry POI/hormone context; note HRT must be reviewed with a clinician (never a stop-instruction). | **D-track, PAI-flagged** |
| **Pregnancy loss reported** | user reports loss | Universal loss handler: instant suppression of celebratory nudges, Gentle Mode, grief resources, retain data. Layer with existing POI fertility-grief sensitivity. | **PAL / E6 grief** (POI-grief-aware) |
| **Reaches ~natural-menopause age (~50–51) on HRT** | age crosses ~average-menopause band | **The bridge completes:** offer graceful continuity into the **F-cohort** (standard menopause/hormone-health state) on the **same account, no restart**; HRT conversation shifts from "replacement-until-natural-age" to standard menopause framing (education); all history carried. | **F-cohort (menopause/hormone health)** |
| **Genetic result recorded (FMR1/Turner)** | user logs a genetic finding | Surface sensitive cause + **family-implications** education (relatives, offspring, fragile-X); elevate privacy tier; raise emotional support. **Femio never assigns/labels the cause.** | Stay C16, raise genetics + support (elevated privacy) |
| **Grief spike / premature-aging distress** | `emotional_state_tag` or mood screen trends low | Universal handler + C16 grief layer: disenfranchised/ambiguous-grief content, mental-health module + localized crisis resources; screening-framed. | Stay C16, raise grief support |
| **Mood screen trends low / crisis flag** | screener threshold crossed | Universal handler: mental-health module + crisis resources; screening-framed. (C16 baseline sensitivity is high — young-diagnosis depression risk.) | Stay C16 |
| **Taking a break / stepping back** | inactivity or "pause" flag | Universal handler: pause nudges; preserve all data; gentle wellness content. | Retain, low-touch |

*All routes preserve data continuity (one account) and always end with clinician-referral language — never a diagnosis, cause assignment, result interpretation, HRT dose, or fertility/menopause verdict. **C16 is the canonical C-cohort → F-cohort bridge:** fertility-grief and donor decisions resolve toward C10/C13 or D-track PAI, while hormone/bone/CV health flows continuously into the F-cohort at natural-menopause age — the same account carrying her across two life-stage cohorts without a restart.*

---

## K. Compliance flags

1. **No diagnosis / treatment / prevention; no test ordering or interpretation; no prescribing (highest-priority guardrail).** Femio serves a user who *has, or is being evaluated for,* a **clinician's** POI diagnosis. It **never** declares POI, menopause, infertility, or a cause; never interprets *her* FSH/AMH/karyotype/FMR1/DXA; **never states an HRT dose or start/stop/switch.** Diagnosis-related fields are **user-reported, entry-only** with category-level education. **[NEEDS SOURCE — confirm current app-store medical-claims + medical-device scope wording at ship.]**
2. **"POI is not menopause" is load-bearing.** Every relevant surface must state that ovarian activity can be intermittent and spontaneous pregnancy may remain possible, countering both false doom and false reassurance. ([ASRM/ESHRE 2024](https://www.asrm.org/practice-guidance/practice-committee-documents/evidence-based-guideline-premature-ovarian-insufficiency--2024/))
3. **The double caveat — not contraception, still possibly fertile.** Femio must actively state that **pregnancy remains possible in POI** and **HRT is not a contraceptive** — the *inverse* of a "safe day" claim. Route both pregnancy-avoiders and pregnancy-seekers to a clinician. [NHS/Leeds; Daisy Network]
4. **HRT content is education, never a prescription.** Rationale/duration/regimen *categories* and "what guidelines describe" only; no dose as advice, no start/stop/switch; always "discuss with your clinician." POI HRT risk/benefit is framed **distinctly from older-menopause HRT.** [ESHRE 2024; Human Reproduction Open 2017]
5. **Genetic data = highest sensitivity tier.** Karyotype and **FMR1/fragile-X** results carry familial implications; handled with elevated privacy, explicit granular consent, strict retention, user-deletion, and **never** shared with ad networks/analytics. **[NEEDS SOURCE — align to Femio privacy skill / DPA + genetic-data provisions at implementation.]**
6. **Reproductive + hormone data privacy (elevated + compounded stigma).** Learn from **Flo (FTC 2021)** and **Premom (FTC 2023)**: no third-party sharing of reproductive/hormone/genetic data; data minimization; explicit, revocable consent; strict retention/deletion. **[NEEDS SOURCE — FTC primary docs.]**
7. **GDPR / PDPL — special-category + genetic data.** Lawful basis + explicit consent; DSAR/export/delete; regional data-residency (esp. AR/MENA); DPIA before launch, with specific attention to **genetic-data** processing. **[NEEDS SOURCE — align to Femio privacy skill / DPA at implementation.]**
8. **Age is context, never a verdict.** "Under 40" routes to POI education; it never triggers a Femio declaration of POI or menopause. No countdowns, no "fertility over," no score.
9. **Uncertainty honesty / no false hope or false doom.** Hold grief and uncertainty; no spontaneous-conception percentage or personal prediction; donor-egg outcomes remain clinician-directed, not a Femio promise.
10. **Emotional safety (premature, disenfranchised, ambiguous grief).** Young-POI carries elevated depression risk (worse with delayed diagnosis, no HRT, no fertility counselling). Tone avoids doom, toxic positivity, and "at least..."/"just adopt"; crisis resources on any low mood screen; loss and grief handled with grief-aware UX; premature-aging distress explicitly supported.
11. **Bridge-persona continuity discipline.** The C-cohort → F-cohort transition (into menopause/hormone health at natural-menopause age) must be **additive and reversible, one account, zero data loss** (Master Model §1–§3) — no restart, no re-diagnosis, full history carried.
12. **Stigma-aware localization (compounded layers).** AR/MENA-first framing de-escalates **both** young-infertility **and** early-menopause/"defective" shame; maximum privacy/dignity by default.
13. **Medical review + citations.** POI diagnostic and hormone-therapy wording is pinned to the 2024 international guideline and NICE NG23 in [`REPRODUCTIVE_TREATMENT_SAFETY.md`](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md). Excluded percentages and doses must not be reintroduced without a new primary-source review. Reviewer Mohamed K., 23 July 2026; next review 23 July 2027.
14. **App-store health-app policy.** Meet Apple/Google health-app & medical-disclaimer requirements; no over-claiming (no POI/menopause predictive or HRT-prescriptive claims); legal review before store submission. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

**Clinical — Tier 1 (NIH/NICHD/NHS/MedlinePlus/gov):**
- [NICHD (NIH) — Primary Ovarian Insufficiency (POI)](https://www.nichd.nih.gov/health/topics/poi)
- [NICHD (NIH) — POI Fact Sheet](https://www.nichd.nih.gov/health/topics/factsheets/poi)
- [NICHD (NIH) — About Fragile X-Associated Primary Ovarian Insufficiency (FXPOI)](https://www.nichd.nih.gov/health/topics/fxpoi/conditioninfo)
- [MedlinePlus — Primary Ovarian Insufficiency](https://medlineplus.gov/primaryovarianinsufficiency.html)
- [NICE QS143 — Menopause Quality Standard: Diagnosing premature ovarian insufficiency](https://www.nice.org.uk/guidance/qs143/chapter/quality-statement-2-diagnosing-premature-ovarian-insufficiency)
- [Leeds Teaching Hospitals NHS Trust — Premature Ovarian Insufficiency (patient guide; HRT-not-contraception, occasional ovulation)](https://www.leedsth.nhs.uk/patients/resources/premature-ovarian-insufficiency/)

**Clinical — Tier 2 (ESHRE / ASRM / ACOG / Menopause Society / peer-reviewed):**
- [ESHRE — Patient resource based on the Guideline on Premature Ovarian Insufficiency (2024)](https://www.eshre.eu/-/media/sitecore-files/Guidelines/POI/2024/POI-GUIDELINE_Patient-version_2024dec.pdf)
- [ASRM — Evidence-based guideline: Premature Ovarian Insufficiency (2024/2025)](https://www.asrm.org/practice-guidance/practice-committee-documents/evidence-based-guideline-premature-ovarian-insufficiency--2024/) · [PMC copy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11631070/)
- [ACOG — Primary Ovarian Insufficiency in Adolescents and Young Women (Committee Opinion, 2014)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2014/07/primary-ovarian-insufficiency-in-adolescents-and-young-women)
- [HRT for women with premature ovarian insufficiency: a comprehensive review (Human Reproduction Open, 2017)](https://academic.oup.com/hropen/article/2017/2/hox007/3957909) · [PMC copy](https://pmc.ncbi.nlm.nih.gov/articles/PMC6276684/)
- [Merck Manual (Professional) — Primary Ovarian Insufficiency](https://www.merckmanuals.com/professional/gynecology-and-obstetrics/abnormal-uterine-bleeding/primary-ovarian-insufficiency)
- [Premature Ovarian Insufficiency — O&G Magazine (causes/etiology overview)](https://www.ogmagazine.org.au/19/1-19/premature-ovarian-insufficiency/)
- [NFXF — Fragile X-Associated Primary Ovarian Insufficiency (FXPOI)](https://fragilex.org/premutation/fx-conditions/fxpoi/)
- [Managing Early Onset Osteoporosis: Impact of POI on Bone Health (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10299102/)
- [The overlooked and undertreated perils of premature ovarian insufficiency (Cleveland Clinic Journal of Medicine, 2025)](https://www.ccjm.org/content/92/8/475)

**Fertility & family-building (education):**
- [Daisy Network — POI and fertility treatment](https://daisynetwork.org/poi-and-fertility-treatment/) · [What is POI](https://www.daisynetwork.org/about-poi/what-is-poi/)
- [Family building after diagnosis of POI: cross-sectional survey of 324 women (European Journal of Endocrinology, 2023)](https://academic.oup.com/ejendo/article/188/3/282/7034158)
- [Mid-Iowa Fertility — POI & infertility: considering an egg donor](https://midiowafertility.com/egg-donor/primary-ovarian-insufficiency-infertility-what-to-consider-using-an-egg-donor/)
- [Advanced Fertility — Premature Ovarian Failure / POI (donor-egg IVF)](https://www.advancedfertility.com/patient-education/causes-of-infertility/premature-ovarian-failure)

**Emotional / patient-journey (peer-reviewed):**
- [Exploring the Experiences and Reproductive Health Needs of Young Women with POI: A Qualitative Content Analysis (PMC 12790688)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12790688/)
- [Depressive symptoms in women with POI: a cross-sectional observational study (PMC 12688449)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12688449/)
- [Perceptions and experiences of women with POI about sexual & reproductive health (PMC 7869211)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7869211/)
- [Premature Ovarian Insufficiency: Past, Present, and Future (PMC 8141617)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8141617/)

**Competitor / app landscape (directional; verify before public claims):**
- Cross-category knowledge of Flo, Clue, Ovia, Premom, Fertility Friend, and menopause apps (Balance, Caria, Perry); POI-charity web resources (Daisy Network). FTC actions vs. **Flo (2021)** and **Premom (2023)** referenced via C1–C3 spec privacy sources.

*Community insight is synthesized as aggregate voice-of-user, not individual quotation. Privacy and competitor claims remain separately tracked. POI diagnostic and hormone-therapy wording follows [`REPRODUCTIVE_TREATMENT_SAFETY.md`](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md); unsupported prevalence, cause, spontaneous-conception, and dose figures are excluded. Medical review: Mohamed K., 23 July 2026; next review 23 July 2027.*
