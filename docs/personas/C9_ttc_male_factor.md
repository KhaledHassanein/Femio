# C9 — TTC with Known Male-Factor Infertility (Partner's Semen Analysis Abnormal)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window features support **conception awareness** and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, or prevents disease. Screeners are framed as *"screening — discuss results with a clinician."* Male-factor content (semen parameters, IUI/ICSI, varicocele) is **educational only**; Femio interprets nothing and prescribes nothing.
> Persona code: **C9** · Cohort: Conception (C) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (seven invariants, state object, constant core, universal events, Z1 fallback, blending). Branches from **C1**. · Last research pass: 2026-07-17

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Yasmin," 31 |
| **Age band** | ~28–36. Age matters for *her* routing clock, but the identified factor is (partly) her partner's. |
| **Stage** | TTC 8–18 months; a **semen analysis (SA) has come back abnormal** (low count/motility/morphology, or azoospermia). She is the app user; the "problem" is (partly) her partner's body. |
| **Relationship** | Partnered, cohabiting/married. Partner is emotionally central to this persona in a way he is not in C1 — he is a *subject of care*, not a background helper. Male partner may be avoidant, ashamed, in denial, or newly diagnosed and reeling. |
| **Goal (top JTBD)** | *"His numbers came back low. Tell me what that actually means, what we can do together, and how to support him — without making this all about my body, and without either of us feeling blamed."* |
| **Health literacy** | Moderate–high, urgently self-educating on semen parameters, IUI vs ICSI, varicocele — often *on his behalf* because he won't Google it himself. |
| **Tech context** | Web-first; she is the account holder. Partner-mode is a first-class requirement (he may engage lightly or via his own linked view). |
| **Locale** | Arabic-first / RTL first-class. **MENA cultural landmine:** infertility is culturally mis-attributed to the woman even when the factor is male; male infertility is hidden as an emasculating secret. Femio must actively counter this. Also EN/FR/ES. |
| **Emotional state** | Relief-at-an-answer mixed with grief, guilt-by-proxy, protectiveness of him, fear the relationship/family will blame her, frustration if he's avoidant. He (secondary user) carries shame, loss of masculinity, isolation. |
| **What she is NOT** | Not solely responsible for conception outcomes. Not an "infertility patient" defined by *her* body. Not a clinician — she cannot fix his numbers, and the app must not imply she can. |
| **Primary devices/signals** | Still logs her own cycle/BBT/OPK/CM (fertile-window timing still matters for natural/IUI attempts). **New:** partner's `semen_analysis[]` results (entry-only), male-lifestyle checklist, appointment/treatment tracking. |
| **Success = leaves us because…** | Pregnancy (→ Pregnancy mode, PAI-flagged), OR she moves to assisted treatment (→ **C10** IUI/ICSI), having felt *both* partners were seen — with dignity and no blame. |

**Persona thesis.** C9 is the persona the entire femtech category fails. Mainstream apps assume the fertility problem lives in the *woman's* body; when the abnormal signal is the *partner's* semen analysis, the app keeps pointing every tool, chart, and worry at her — which is factually wrong (male factor is implicated in ~40–50% of cases), clinically counterproductive, and, in MENA, actively harmful because it echoes the cultural lie that infertility is the woman's fault. C9's Femio thesis: a **couple-framed, non-blaming** experience that (a) educates her on male-factor causes and *educational* treatment paths, (b) gives the partner a dignified, private on-ramp via partner-mode, and (c) refuses to make her body the sole object of the problem. Nail this and Femio owns whitespace no competitor occupies.

---

## B. Needs & questions (voice-of-user)

Mined from r/maleinfertility, r/infertility, Fertility Out Loud, and app-store/femtech HCI research. Phrasing is representative/composite (community norms; not quoting individuals).

**Her core JTBD (post-SA-result):**
1. *"What do these numbers mean?"* — concentration, motility, morphology, "normal forms 2%," azoospermia vs oligospermia — in plain language, without pretending they're a verdict.
2. *"Is this fixable? What can HE actually do?"* — lifestyle (weight, smoking, alcohol, heat), varicocele, time-to-improvement expectations.
3. *"IUI or ICSI — what's the difference and which is us?"* — the treatment ladder, educationally, before the clinic conversation.
4. *"How do I support him without crushing him?"* — he's ashamed, shutting down, or refusing to talk about it.
5. *"Why does everyone assume it's me?"* — countering family/social pressure (acute in MENA).
6. *"Do I stop tracking my body now?"* — no: timing still matters for natural + IUI attempts; her cycle is still relevant, just not the *problem*.
7. *"Should he re-test?"* — SA varies; one abnormal result isn't destiny; repeat testing is standard.
8. *"Is this my fault / his fault?"* — the blame spiral, in both directions.
9. *"What do we ask the urologist/andrologist/REI?"* — appointment prep for a specialist she's never seen.

**His core JTBD (secondary user, partner-mode):**
- *"Am I still a man?"* — masculinity/identity threat is the dominant male emotion in the literature.
- *"What can I do myself, privately, without a lecture?"* — self-directed lifestyle actions, framed as agency not blame.
- *"I don't want to talk about this with anyone."* — isolation; wants information more than conversation; may prefer peer/other-men framing over partner conversation.
- *"Is a low number permanent?"* — hope, re-test, treatability.

**Emotional arc — design must respect this:**
- **The result lands:** shock, grief, sometimes relief ("at least we know"). Fear + sadness dominate at the diagnostic moment (Reddit NLP study).
- **Blame risk window:** the days after the result — who "caused" this; in MENA, external pressure on *her* despite a male factor.
- **Mobilization:** researching, lifestyle changes, booking specialists, deciding on IUI/ICSI.
- **Per-cycle arc (still present):** she still rides C1's follicular→fertile-window→TWW arc for natural/IUI attempts, layered over the male-factor context.

**Anti-needs / trust-breakers:**
- Any framing that treats *her body* as the problem when the identified factor is his — the category's core failure.
- Blaming language toward either partner ("your husband's poor sperm," "you should have…").
- Toxic positivity ("just relax and it'll happen") — invalidating when there's a real, measured factor.
- Reducing him to a data field or a "read-only afterthought" partner view.
- Turning a single abnormal SA into a fatalistic verdict (SA is variable; not pass/fail).
- Cultural tone-deafness in AR markets (exposing his diagnosis, shaming, or reinforcing woman-blame).
- Diagnosing, staging, or telling them which treatment to pick.

**Feature requests recurring in reviews/forums/HCI research:**
- A place to record and *understand* SA results without a clinician present.
- Male-facing content and actions men will actually use (men report apps don't speak to them; ~1/3 of clinics don't even test the man).
- Couple-shared roadmap so "we" are doing this, not "she."
- Private, dignified male on-ramp (peer/other-men framing preferred over being managed by partner).

---

## C. Competitor teardown

Key insight for Femio: **male-factor + genuine couple-framing is near-total whitespace.** The category splits into (1) female-centric cycle/TTC apps that assume the problem is her body and bolt on a light "for partners" view, and (2) male-fertility point products (at-home SA kits, sperm-optimization habit apps) that live entirely outside her women's-health account. **Nobody** unifies: her cycle/fertile-window depth + male-factor education + SA-result tracking + a dignified partner on-ramp + non-blaming couple roadmap + Arabic/RTL + full-lifespan continuity.

| Product | Male-factor education | SA-result tracking | Partner / male on-ramp | Couple framing | Gap for C9 |
|---|---|---|---|---|---|
| **Flo** | Minimal | No | "Flo for Partners" — light, informational, partner sees *her* cycle | Her-centric | Assumes problem is her; partner is a spectator of her body. |
| **Clue / Ovia / Glow** | Thin | No | Light partner linking | Her-centric | No male-factor pathway; man is not a subject of care. |
| **Premom / Fertility Friend / Kindara** | Minimal | No | Chart-sharing with partner/practitioner | Her-centric (signal depth) | Deep on *her* BBT/OPK/CM; silent on male factor. |
| **Legacy** | **Strong** (sperm health) | **Yes** (lab SA, cryo) | Male-first; markets to female partners to buy for him | Male-centric | Standalone male product; no cycle/fertile-window; no lifespan account; clinical/lab, not couple-education. |
| **Dadi / Fellow / YO / Trak** | Moderate | At-home SA kit results | Male-first; ~50% bought by female partner for him | Male-centric | Point testing products; no integration with her health; no education continuity. |
| **Batch / "spermaxxing" apps / Infotility XY** | **Yes** (male lifestyle/education) | Some | Male-first habit/education | Male-only | Wellness-habit for men; disconnected from her account and the couple's shared TTC record. |

**Whitespace map (the opening for Femio C9):**
- **Male-factor depth** lives in Legacy/Dadi/Batch — but *outside* the woman's account, clinical or male-only, no couple continuity.
- **Cycle/TTC depth** lives in Flo/Premom/Fertility Friend — but assumes the problem is *her* and treats the partner as a spectator.
- **Nobody** provides: her fertile-window depth **+** male-factor education (causes, SA literacy, IUI/ICSI *educationally*) **+** SA-result tracking as a shared field **+** a *dignified, private male on-ramp* **+** explicitly non-blaming couple framing **+** MENA-aware woman-blame counter **+** Arabic-first RTL **+** one account keeping all women's-health knowledge reachable. **That gap is C9's Femio thesis.** [Sources: HCI review of apps failing men's fertility needs; femtech male-gap reporting — §Sources.]

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, or prevent; it educates and helps the couple track. Male-factor material is Tier-1 (NIH/NHS/MedlinePlus) + Tier-2 (ASRM/AUA/ESHRE) grounded.

**Prevalence & couple framing (the non-blaming anchor):**
- Male factor is implicated in roughly **40–50% of infertility cases** — infertility is a *couple* issue, not a woman's issue. Evaluation is recommended for **both partners**. [ASRM; AUA/ASRM Male Infertility Guideline; ESHRE unexplained-infertility guideline] Femio uses this as the persona's founding fact to counter mis-attribution.
- Despite this, roughly **a third of fertility clinics historically do not test the male partner** — a real-world gap Femio education names explicitly. **[NEEDS SOURCE — verify the "one-third of clinics" figure against a primary study at publish.]**

**Semen analysis (SA) — literacy, not verdict:**
- SA is the **cornerstone** of male fertility evaluation; **one or more** analyses are recommended in initial evaluation. [AUA/ASRM Guideline 2020, amended 2024]
- **WHO 2021 lower reference limits** (the 5th percentile of ~3,500 men whose partners conceived naturally within 12 months — a *statistical benchmark, not a pass/fail line*): sperm concentration **16 million/mL**, total motility **42%**, progressive motility **30%**, normal forms **4%**, semen volume **1.4 mL**. [WHO 2021 via Andrology/Boeri 2022] **[NEEDS SOURCE — cite WHO Laboratory Manual 6th ed. primary at publish.]**
- Values above/below the limit **do not by themselves predict fertility or infertility**; results carry most meaning when **multiple parameters are abnormal** and on **repeat** testing (SA is biologically variable). [AUA/ASRM]
- Terminology (educational glossary): *normozoospermia* (all within range), *oligozoospermia* (low concentration; severe <5 million/mL), *asthenozoospermia* (reduced motility), *teratozoospermia* (low normal forms), *azoospermia* (no sperm found — may be **obstructive** [blockage] or **non-obstructive** [production]). [AUA/ASRM; MedlinePlus]

**Causes & contributing factors (educational):**
- **Varicocele** — enlarged scrotal veins raising temperature; the **most common correctable** cause of male-factor infertility. [AUA/ASRM Varicocele best-practice]
- **Lifestyle/modifiable factors** that may impair semen quality: **smoking, excess alcohol, obesity, sedentary lifestyle, heat exposure**; evidence indicates a healthy diet, smoking cessation, moderate alcohol, weight management, and regular exercise can **improve** semen parameters — though guidelines note evidence for many individual risk factors is limited. [NHS/UHB "Improving sperm quality"; PMC lifestyle reviews; AUA/ASRM]
- Other categories a clinician evaluates: hormonal (endocrine), genetic, infection, obstruction, medications, environmental/occupational exposures. [AUA/ASRM; MedlinePlus] Femio lists these as *"things a specialist looks into,"* never as a self-diagnosis.

**Treatment paths (educational only — never a recommendation):**
- **Lifestyle optimization** first-line where a modifiable factor exists; semen improvements take time (spermatogenesis ~2–3 months, so changes are judged over months, not weeks). **[NEEDS SOURCE — confirm ~72–90 day spermatogenesis figure at publish.]**
- **Varicocele repair** may improve parameters and pregnancy/live-birth rates in appropriately selected couples. [AUA/ASRM Varicocele]
- **IUI (intrauterine insemination)** — washed, concentrated motile sperm placed in the uterus around ovulation; often first-line for **mild** male factor. [FertilityIQ; reproductive-medicine sources]
- **IVF with ICSI (intracytoplasmic sperm injection)** — a single sperm injected into each egg; used for **severe** male factor (very low count/motility, azoospermia with retrievable sperm). [AUA/ASRM; FertilityIQ]
- Choice of path is a **clinician + couple** decision (andrologist/urologist + REI). Femio explains the ladder; it never selects the rung.

**Repeat/confirm framing:** a single abnormal SA should be **confirmed on repeat testing** before conclusions; Femio always pairs an entered abnormal result with *"one result isn't the whole picture — your clinician may repeat it."* [AUA/ASRM]

*Femio applies all thresholds and terms as **education**, always ending "discuss with your clinician" — never as a diagnosis, stage, or treatment plan.*

**Flagged for medical-review sign-off before ship:** exact WHO 2021 numeric limits vs. locale lab reference ranges; spermatogenesis-cycle days; varicocele-repair benefit wording; "one-third of clinics don't test men" figure. **[NEEDS SOURCE VERIFICATION AT PUBLISH]** for any figure stated without a per-locale reviewed citation.

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Semen-analysis (SA) explainer + entry-only tracker** — she enters his concentration/motility/morphology/volume; Femio shows a **plain-language glossary and WHO-2021 reference context** (labelled *benchmark, not pass/fail*), NEVER an interpretation, score, or verdict. Every abnormal entry pairs with *"one result isn't destiny; your clinician may repeat it."*
2. **Non-blaming couple framing (core UX law for C9)** — copy, defaults, and hero never make *her body* the problem. Founding fact surfaced early: *"Male factor is involved in about 40–50% of cases — this is a couple's journey."* No blame language toward either partner, ever.
3. **Male-factor education library** — causes (varicocele, lifestyle, hormonal, obstruction, genetic), SA literacy, and the **educational treatment ladder** (lifestyle → varicocele repair → IUI → IVF/ICSI). Cited (§D).
4. **Dignified partner-mode with a male on-ramp** — partner gets his **own linked view**, not a read-only spectator of her cycle: male-lifestyle checklist, his SA history, male-facing education, private tone. Consent-gated, scope-limited, revocable. Framed as *agency*, not homework she assigns him.
5. **Male-lifestyle optimization checklist (his)** — smoking cessation, alcohol moderation, weight, heat/exposure, exercise, framed over a **multi-month** horizon (spermatogenesis timeline), all cited, no blame.
6. **Fertile-window tracking retained (hers)** — C1's uncertainty-honest window + BBT/OPK/CM stay active for natural + IUI timing; explicitly *not the problem*, just still-useful timing.
7. **Specialist appointment prep** — question lists for urologist/andrologist/REI; SA-result export (PDF) to hand over.

**P1 — Strong differentiators (fast follow):**
8. **Shared couple roadmap** — a "we" view of where they are (evaluating → optimizing → repeat SA → considering IUI/ICSI), with data continuity into **C10** if they start treatment.
9. **MENA woman-blame counter module** — culturally-framed content affirming male factor exists and is common, with modesty-aware, privacy-first handling of his diagnosis (AR-first).
10. **SA trend view** — plot his repeat SAs over time so lifestyle/varicocele changes are visible (education, not scoring).
11. **Male peer/"other men" content framing** — men prefer learning from other men over being managed; surface male-authored/peer-voiced education (privacy-safe).

**P2 — Nice-to-have / later:**
12. At-home SA kit result import (Legacy/Dadi/YO-style) as entry-only fields.
13. Couples counseling / mental-health signposting (male-infertility grief is under-supported).
14. Localized coaching by market (AR modesty-aware, secrecy-respecting).

**Explicitly OUT of scope for C9 (guardrail):**
- Interpreting/scoring his SA, diagnosing male infertility, or naming a cause. **Never.**
- Recommending IUI vs ICSI vs surgery, or any dose/medication. **Never.**
- Any "safe days / contraception" framing (inherited C-cohort ban).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each card carries citations + "not medical advice / discuss with your clinician." Male-facing variants written in a male, peer, non-lecturing voice.

- **"Male factor is common" (founding card)** — ~40–50% of cases involve male factor; infertility is a couple issue; both partners get evaluated.
- **SA-101: "Reading a semen analysis"** — concentration, motility, morphology, volume; WHO-2021 as a *benchmark not a grade*; why one result isn't the whole picture.
- **Glossary card** — oligo/astheno/terato/azoospermia (obstructive vs non-obstructive), plain-language.
- **"What can affect sperm" (causes)** — varicocele, lifestyle, heat, hormones, obstruction, genetics — as *what a specialist checks*, not self-diagnosis.
- **"What HE can do" (male-facing lifestyle)** — smoking, alcohol, weight, heat, exercise; multi-month horizon; agency-framed, cited.
- **Treatment ladder, honestly** — lifestyle → varicocele repair → IUI → IVF/ICSI; what each is; that the couple + clinician choose.
- **"IUI vs ICSI"** — the difference, when each is typically considered (educational).
- **"Supporting him without blame"** (her-facing) + **"You're still you"** (his-facing) — the emotional/masculinity content, non-shaming.
- **MENA culture card (AR-first):** "Infertility is not automatically the woman's fault" — counters mis-attribution, respects privacy/secrecy, modesty-aware.
- **Appointment prep** — questions for the andrologist/urologist/REI.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so she is never boxed into "male-factor only."

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception; education, not diagnosis)

**Logs (inputs):**
- **Hers:** BBT, OPK/LH (+photo), CM, cervical position (opt), intercourse, period flow, mood/symptoms, meds/supplements, HPT.
- **His (partner-mode / entry-only):** `semen_analysis[]` {concentration, total_motility, progressive_motility, morphology_normal_forms, volume, date, lab, azoospermia_flag}, male-lifestyle checklist state, varicocele/procedure noted (non-diagnostic), appointments.

**Tools:**
- Fertile-window estimator (range + confidence), coverline/thermal-shift detector, LH plotter, sympto-thermal confirmation, DPO/TWW counter (all inherited from C1).
- **SA glossary + reference-context viewer** (labels WHO-2021 as benchmark, interprets nothing).
- **SA trend view** (repeat results over time — education, no score).
- Male-lifestyle checklist, couple roadmap, appointment-prep generator, PDF export (SA + charts) for clinician.

**Alerts / nudges (opt-in, tone-calibrated, revocable, non-blaming):**
- *Hers:* C1 fertile-window/OPK/TWW nudges (awareness language, retained for timing).
- *His (partner-mode):* gentle lifestyle-habit reminders (agency-framed); "consider a repeat SA per your clinician's advice" (educational).
- *Couple:* "appointment coming up — here are questions to bring."
- **Never:** any nudge implying the outcome depends on *her body alone*, or blaming either partner.

**Mandatory compliance wording:**
- On SA surfaces: *"This is educational information, not a diagnosis or interpretation of your results. WHO reference values are a statistical benchmark, not a pass/fail line. Please discuss with your clinician."*
- On treatment content: *"Educational overview only — the right path is a decision for you and your clinician."*
- Inherited C-cohort ban: fertile-window is *"not a method of birth control."* No "safe/infertile day" language, ever.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared — the one-account spine):** `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, consent flags, account mode; `cycle{period_start, period_end, cycle_length_history[], flow[]}`; `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (non-diagnostic); `content_history[]`, `screener_results[]` (timestamped, non-diagnostic).

**C9 persona-specific (additive layer — inherits C1's TTC layer + infertility layer from §3 of the model):**
- **Hers (from C1):** `ttc_start_date`, `bbt_readings[]`, `opk_results[]`, `cm_log[]`, `intercourse_log[]`, `ovulation_confirmed[]`, `luteal_phase_length[]`, `dpo_current`, `hpt_results[]`, `predicted_window[]{confidence}`.
- **Male-factor (new for C9):**
  - `partner_semen_analysis[]` {concentration, total_motility, progressive_motility, morphology_normal_forms, volume, date, lab_name, azoospermia_flag} — **entry-only, no interpretation stored as a verdict.**
  - `male_factor_type` (self-report bucket: low-count / low-motility / low-morphology / azoospermia / mixed — **non-diagnostic tag**).
  - `male_lifestyle_checklist_state`, `partner_procedures[]` (e.g., varicocele-repair noted, non-diagnostic), `partner_appointments[]`.
  - `evaluation_phase` (self-report: awaiting-results / results-in / optimizing / repeat-SA / considering-treatment).
  - `workup_roadmap_state`, `treatment_intent` (natural / IUI / ICSI — self-report, drives →C10 offer).
- **Partner-mode (from C1, scoped up):** `partner_link_id`, `partner_scope` (what each sees), `partner_consent_ts`, `partner_account_mode` (his own linked view vs. read-only).

*Data-minimization: his SA is **special-category health data about a third party** — see §K. Stored under explicit partner consent, scoped, revocable, user-deletable.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C9):** enters via C1's TTC branch, then Q3-style refinement:
1. "What brings you to Femio?" → *Trying to conceive.*
2. "How long trying?" → sets `ttc_start_date`.
3. "Anything a clinician has flagged?" (multi-select) → **"a semen analysis / male-factor result"** selected → **C9 layer on**. (Other selections route to sibling C-personas.)
4. "Would you like to add your partner's results and involve him?" → offer SA entry + partner-mode setup (both optional, both consent-gated).
5. "How do you want to track?" (BBT/OPK/CM/minimal) → her trackers; others reachable via "Add tracking."
6. Consent & privacy — **including explicit partner-data consent** for storing his SA.

**Home config for C9:**
- Hero = **couple/roadmap card** (non-blaming: "where you both are") + today's timing action (her fertile-window still present, secondary).
- Strip 1 = **his SA + male-lifestyle** (partner-mode); Strip 2 = **her fertile-window/tracking** (retained, not foregrounded as "the problem").
- Secondary = male-factor education module of the week; appointment-prep card when appointments upcoming.
- **Hidden-but-reachable:** full lifespan library one tap away — she is configured, never walled in.

**Adaptive tone:** validating + partnership-centered; explicitly de-blaming; MENA locale adds woman-blame-counter framing + heightened privacy/secrecy defaults for his diagnosis. Never toxic-positive ("just relax"), never doom.

**Blending (per model §8):** C9 stacks cleanly with her own condition modifiers (e.g., C9 ⊕ PCOS = male factor + her irregular cycles → both surfaced, neither blamed) and with age-based routing (her 12-mo/6-mo clock still runs in parallel).

---

## J. Adaptation triggers (state transitions)

*Inherits ALL universal events from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive pregnancy test, pregnancy loss, mood-screen-high, red-flag symptom, disengagement, toggle-off, age-of-consent). Below are only the **C9-specific** transitions.*

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Positive pregnancy test** | `hpt_results` positive / user confirms | Universal celebrate handler; suppress fertile-window/TWW; **carry all partner/SA data forward**; re-confirm privacy scope; offer Pregnancy mode **flagged Pregnancy-After-Infertility (PAI)** given the prior male-factor journey. | Pregnancy (D-track), **PAI-flagged** |
| **Starts IUI / ICSI / IVF** | `treatment_intent` = IUI/ICSI or user reports cycle start | Deepen treatment support; carry his SA + her cycle data intact; shift roadmap to assisted-treatment phase. | **→ C10** (IUI/ICSI in-treatment persona) |
| **Repeat SA entered / SA trend improves or worsens** | new `partner_semen_analysis[]` entry | Update SA trend view (education only, no verdict); reinforce "confirm with clinician"; if worsening/azoospermia, surface *earlier-specialist* educational routing (never diagnosis). | Stay C9; deepen male-factor content |
| **Varicocele repair / procedure noted** | `partner_procedures[]` entry | Surface *what to expect over months* education (spermatogenesis horizon); schedule repeat-SA-per-clinician reminder. | Stay C9 |
| **Pregnancy loss reported** | user reports loss | Universal loss handler (instant suppression, Gentle Mode, grief resources, retain data). Given male-factor + prior journey, offer **RPL / Pregnancy-After-Loss (PAL)** pathway. | → E6 grief; later optional **C5 (RPL) / D2 (PAL)** |
| **Her age crosses / 12-mo (or 6-mo ≥35) with no conception** | age + `ttc_start_date` | Calm educational routing to broaden the couple's evaluation (both partners) + eval-prep + export; never label either partner. | Stay C9 + deepen; possible C10 |
| **Partner disengages / withdraws consent** | partner-mode inactivity / consent revoked | Instantly revoke his scope; keep her account fully functional and non-blaming; offer lighter "solo" male-factor content she can read for herself. | Stay C9 (solo mode) |
| **She wants to involve partner (was solo)** | user enables partner-mode | Consent-gated partner on-ramp; add his SA/lifestyle layer. | Stay C9 (couple mode) |

*All routes preserve data continuity (one account, partner data carried), always end with clinician-referral language, and never blame either partner or diagnose.*

---

## K. Compliance flags

1. **Non-blaming, couple-framed (highest-priority C9 guardrail).** The app must never make *her body* the object of the problem, and never blame either partner. Founding-fact framing (male factor ~40–50%) is a compliance-and-safety requirement, not just tone.
2. **Third-party (partner) health data.** His semen analysis is **special-category health data about a person who is not the account holder.** Requires explicit partner consent to store/share, scoped and revocable, user-deletable, with data-minimization. Partner-mode consent logged. **[NEEDS SOURCE — align to Femio privacy skill / DPA + GDPR/PDPL lawful basis for third-party data at implementation.]**
3. **No diagnosis / interpretation of SA.** Femio shows glossary + WHO-2021 *benchmark* context; it never scores, interprets, stages, or names a cause. Every SA surface carries "educational, not a diagnosis; discuss with your clinician."
4. **No treatment recommendation.** IUI/ICSI/varicocele content is an educational ladder; the app never selects a path, dose, or medication.
5. **Uncertainty & non-fatalism.** One abnormal SA is not a verdict; SA is variable; always pair with "confirm on repeat testing per your clinician."
6. **Not contraception (inherited C-cohort ban).** Fertile-window = awareness only; "not a method of birth control"; no "safe/infertile day" language, ever.
7. **MENA cultural safety.** Actively counter woman-blame mis-attribution; handle his diagnosis with privacy-first, modesty-aware, secrecy-respecting defaults in AR markets; do not out his diagnosis to family/social contexts.
8. **Emotional safety for both partners.** Male-infertility grief/masculinity threat is real and under-supported; tone avoids shame and toxic positivity; crisis resources on any high mood-screen (his view too).
9. **Privacy-by-design / reproductive-data sensitivity.** Inherit category lessons (FTC vs Flo 2021, Premom 2023): no cycle/fertility/SA data to ad networks or third-party analytics; granular, revocable consent; strict retention/deletion for SA + OPK photos. **[NEEDS SOURCE — FTC primary docs; Femio privacy skill.]**
10. **Medical review + citations.** All clinical content (incl. WHO-2021 limits, spermatogenesis timeline, varicocele wording, prevalence and "one-third of clinics" figures) medically reviewed, cited to primary sources, grade 6–8, localized in 4 languages with RTL parity. **[NEEDS SOURCE VERIFICATION AT PUBLISH]**
11. **App-store health-app policy.** Meet Apple/Google health-app + medical-disclaimer requirements; no over-claiming on male-fertility improvement. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

**Tier-1 (NIH / NHS / MedlinePlus):**
- [MedlinePlus — Semen analysis](https://medlineplus.gov/ency/article/003627.htm) · [MedlinePlus — Male infertility](https://medlineplus.gov/maleinfertility.html)
- [NHS (UHB) — Improving sperm quality (patient info, PDF)](https://www.uhb.nhs.uk/media/3dljknhq/pi_pathology_improving-sperm-quality.pdf)
- [PMC — Implications of lifestyle factors on male reproductive health](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11152437/)
- [PMC — Empirical Treatments for Male Infertility: Lifestyle Modifications and Medicines](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11431325/)

**Tier-2 (ASRM / AUA / ESHRE / WHO):**
- [AUA/ASRM — Diagnosis and Treatment of Infertility in Men: Guideline (2020, amended 2024, PDF)](https://www.auanet.org/documents/Guidelines/PDF/2024%20Guidelines/Male%20Infertility%20Unabridged%20Final.pdf) · [ASRM landing](https://www.asrm.org/practice-guidance/practice-committee-documents/diagnosis-and-treatment-of-infertility-in-men-auaasrm-guideline-part-i-2020/)
- [ASRM — Semen Analysis for Assessment of Fertility](https://www.asrm.org/practice-guidance/coding-resources/coding/coding-andrology/semen-analysis-for-assessment-of-fertility/)
- [AUA/ASRM — Report on Varicocele and Infertility (Best Practice Policy, PDF)](https://www.auanet.org/documents/education/clinical-guidance/Varicocele-Archive.pdf)
- [ESHRE — Evidence-based guideline: unexplained infertility (Human Reproduction 2023)](https://academic.oup.com/humrep/article/38/10/1881/7246182) · [Guideline for unexplained couple infertility: misunderstandings on the male factor](https://doi.org/10.1093/humrep/deae032)
- [WHO 2021 reference values — impact analysis (Andrology / Boeri 2022, PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9541878/) · **[NEEDS SOURCE — WHO Laboratory Manual for the Examination and Processing of Human Semen, 6th ed. (2021) primary]**
- [FertilityIQ — IVF, ICSI, IUI & Male Factor Infertility](https://www.fertilityiq.com/fertilityiq/male-factor-infertility/ivf-icsi-iui-and-male-factor-infertility) · [FertilityIQ — Varicocele](https://www.fertilityiq.com/fertilityiq/male-factor-infertility/varicocele)

**Community / emotional / cultural:**
- [medRxiv — Peer Support in Online Discussions of Male Infertility: NLP Study of Reddit](https://www.medrxiv.org/content/10.64898/2026.03.09.26347980v1.full)
- [Fertility Out Loud — Male infertility & emotional well-being](https://www.fertilityoutloud.com/content-hub/male-infertility-psychological-impact/)
- [PMC — Rethinking the gendered burden of female partners in male-factor infertility](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12835443/)
- [PMC — Gender Biases in Male Infertility and Its Impact on Women (qualitative)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12126270/)
- [PubMed — Middle Eastern masculinities & male infertility stigma in Egypt and Lebanon (Inhorn)](https://pubmed.ncbi.nlm.nih.gov/15272802/)
- [Al Jazeera — Infertility: still a social stigma in the Gulf](https://www.aljazeera.com/news/2003/4/24/infertility-still-a-social-stigma-in-the-gulf)
- [PMC — Infertile Jordanian Women's Self-Perception About Societal Violence](https://pmc.ncbi.nlm.nih.gov/articles/PMC11022872/)

**Competitor / femtech gap:**
- [ACM DL — "But what does it mean for me?" Apps (fail) to support men's fertility](https://dl.acm.org/doi/pdf/10.1145/3806651)
- [Mass General Advances in Motion — Smartphone app for male infertility](https://advances.massgeneral.org/obgyn/article.aspx?id=1096)
- [Forbes — Male fertility tech gaining investor attention](https://www.forbes.com/sites/ayaspencer/2024/09/24/male-fertility-tech-is-quietly-gaining-attention-from-investors/)
- [Legacy Partner](https://www.givelegacy.com/partners/legacypartner) · [Pay It Forward Fertility — Dadi vs Legacy vs Fellow vs YO (2026)](https://payitforwardfertility.org/best-male-fertility-test/)
- [Men's Journal — spermaxxing / Batch app](https://www.mensjournal.com/news/can-an-app-improve-your-fertility-inside-the-rise-of-spermaxxing)

*Community insight (r/maleinfertility, r/infertility, forums, app-store reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. FTC actions vs. Flo (2021) and Premom (2023) inherited from C1 §C/§K. All numeric clinical claims re-verified against live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH]** where flagged.*
