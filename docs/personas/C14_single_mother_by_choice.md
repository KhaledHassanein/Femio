# C14 — Single Mother by Choice (SMBC) — Solo Conception via Donor Sperm (IUI/IVF)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Femio never diagnoses, treats, prevents, or contracepts. Fertile-window features support **conception awareness** and are **explicitly NOT contraception / birth control**. Screeners are framed as *"screening — discuss results with a clinician."* Femio does not perform, prescribe, or clinically manage IUI/IVF; it educates about the process and helps the user organize and track it.
> Persona code: **C14** · Cohort: Conception (C) · Last research pass: 2026-07-17

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Dana," 37 |
| **Age band** | ~34–43 (skews older than C1; the ACOG/NICE 35 line is usually already crossed, so the help-seeking window is short and treatment often starts fast) |
| **Stage** | Solo woman **actively pursuing conception with donor sperm** — moving through *Thinker → Tryer → (Mother)*. May be pre-treatment (choosing a donor/clinic) or mid-treatment (IUI cycles, often escalating to IVF). |
| **Relationship** | **No partner — by design, not by loss.** This is a chosen path (SMBC / "solo mum by choice"), distinct from a woman whose partner is absent, infertile, or estranged. |
| **Goal (top JTBD)** | *"Support me through this as a solo decision-maker — donor choice, treatment logistics, the money and the medical steps — without ever asking 'where's the father?' or assuming I have a partner to lean on."* |
| **Health literacy** | High and research-driven. Often has spent months–years as a "Thinker"; arrives fluent in IUI/IVF vocabulary, donor-bank jargon, and cost structures. Wants sources and logistics, not hand-holding. |
| **Tech context** | Web-first (spreadsheets, donor-bank portals, clinic patient portals, cost trackers); also phone. Frequently stacks a period/fertility tracker + a notes/spreadsheet + community forums. |
| **Locale** | EN/FR/ES primary user base; **AR/MENA is a high-sensitivity edge case** — donor conception and unmarried motherhood are legally restricted and culturally stigmatized across much of the region (see §I, §K). Femio must serve her without endangering her. |
| **Emotional state** | **A distinct profile from infertility.** Empowered, deliberate, "this is Plan A." But layered with: decision-weight (choosing alone), isolation/stigma ("am I selfish?", family disapproval), financial anxiety (usually self-funded), and — if cycles fail — a grief that overlaps infertility *without* the partner-shared load. |
| **What she is NOT** | Not a woman who "couldn't find a man." Not necessarily infertile (many SMBCs have no fertility problem — they lack sperm, not fertility). Not looking for a co-parent. Framing her as a deficit case is the fastest trust-breaker in this persona. |
| **Primary signals/inputs** | Donor shortlist + selection criteria, clinic/treatment plan, IUI/IVF cycle logs, medication protocol (educational), trigger/monitoring appointments, vial inventory, cost ledger, cycle/OPK/BBT tracking for timing (esp. natural or minimally-medicated IUI). |
| **Success = leaves us because…** | She conceived (→ Pregnancy mode, carried as *pregnancy after donor conception / after treatment*), OR she made peace with a decision (paused, adopted, chose child-free) and we honored it without a partner-shaped hole in the UX. |

**Persona thesis.** C14 is where Femio's *"one account, partner-optional, non-judgemental"* promise is stress-tested hardest. Nearly every competitor's TTC experience is scaffolded on an assumed male partner — "invite your partner," "his sperm health," "baby-making with your other half." For an SMBC, each of those is a small papercut of erasure. Serve her by making **partner-optional the default, not a toggle**, by treating **donor selection and solo decision-support as first-class features** (nobody else does), and by getting the emotional register right — *chosen, capable, and occasionally very alone.* Get this persona right and Femio earns a fiercely loyal, high-intent, high-LTV user and a reputation for genuine inclusivity that halo-benefits every LGBTQ+ and solo-parent segment.

---

## B. Needs & questions (voice-of-user)

Mined from Single Mothers by Choice (singlemothersbychoice.org — "Thinker/Tryer/Mom" structure), r/singlemothersbychoice, Solo Mum Society, Motherhood Reimagined, and Donor Sibling Registry community discussion. Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD — "Thinker" phase (deciding):**
1. *"Am I really ready to do this alone? How do I make this decision without a partner to talk it through with?"* (solo decision-weight)
2. *"Can I afford this? IUI vs IVF vs how many rounds — what am I actually signing up for financially?"*
3. *"IUI or IVF first — what makes sense at my age?"* (age-pressure + cost trade-off)
4. *"How do I choose a sperm donor? Open/ID-release vs anonymous, medical history, how many families, sibling limits?"*
5. *"Will my child resent me / feel something's missing? How and when do I tell them?"* (disclosure anxiety)
6. *"How do I handle my family/friends who think this is selfish or 'not the right way'?"* (stigma)

**The core JTBD — "Tryer" phase (in treatment):**
7. *"What actually happens in an IUI cycle? Monitoring, trigger shot, timing, two-week wait — walk me through it."*
8. *"My clinic gave me a med protocol — what do these injections/pills do?"* (educational, not dosing)
9. *"How many IUIs before I switch to IVF? When do I stop 'wasting' vials and money?"*
10. *"How many vials do I have left, and should I reserve some for a sibling from the same donor?"* (inventory + future-sibling planning)
11. *"This cycle failed. I'm grieving alone and everyone thinks I should just be grateful I'm 'trying something.'"* (isolated loss)
12. *"Where are the other women doing exactly this? I need people who get it."* (community/belonging)

**Emotional arc — design must respect this (distinct from C1/infertility):**
- **Deciding:** heavy, deliberate, often long. Needs validation that this is a legitimate, considered path — *not* a fallback. Community insight: *"It feels good to have somebody say 'yes, you're thinking about the right things, and yes, it is possible.'"*
- **Choosing a donor:** oddly intimate + clinical at once; high-stakes, irreversible-feeling, done alone.
- **Treatment cycles:** logistics-heavy (appointments, meds, money), plus the C1 fertile-window/TWW arc — but *without a partner in the room* for the trigger shot, the wait, or the result.
- **Cycle end:** joy → new solo-parenting fears, OR private grief that is doubly isolating ("I chose this, so I can't complain").

**Anti-needs / trust-breakers (what makes her churn):**
- **Partner-assuming UX.** "Invite your partner," "add his details," "baby-making for two," partner-only nudges, forms that require a second parent. Every one reads as *you weren't built for me.*
- **Deficit/pity framing.** Treating SMBC as failed-to-partner rather than chosen.
- **Over-medicalizing her fertility.** Many SMBCs are not infertile; defaulting her into an "infertility patient" identity is wrong and alienating (mirror of the C1 lesson, different reason).
- **Judgement, subtle or overt.** Anything implying a child "needs a father," or that this is second-best.
- **Data-privacy creep** — SMBC data (donor IDs, treatment, unmarried-parent status) is acutely sensitive, especially in restrictive regions.

**Feature requests recurring in the community:**
- A **donor comparison/shortlist** tool (side-by-side criteria — ID-release status, medical/family history, family limit, siblings) she can reason about alone.
- **IUI/IVF cycle + cost tracking** in one place (many resort to spreadsheets).
- **Vial inventory + sibling-planning** ("reserve for a future sibling from the same donor").
- **Solo decision-support** content — Thinker checklists, "are you ready" frameworks, telling-your-child scripts by age.
- **A community that assumes no partner** and no shame.

---

## C. Competitor teardown

Key insight for Femio: **the entire TTC-app category is architected around a couple.** The gap for C14 is not "a better OPK reader" (that's C1) — it is *the total absence of a partner-optional, donor-aware, solo-decision-supported product.* SMBCs currently cobble together: a fertility tracker (for timing) + a donor-bank portal (for selection) + a spreadsheet (for cost/cycles) + SMC forums / Reddit (for the emotional load). No app unifies these.

| App | Partner assumption | Donor-selection support | IUI/IVF logistics | Solo/SMBC framing | Community | Notable gap for C14 |
|---|---|---|---|---|---|---|
| **Flo** | Strong — "Flo for Partners," couple-centric TTC | None | Minimal | None; heteronormative default tone | Large, general | Presumes partner; no donor/treatment layer. Critiqued for imposed heteronormativity. |
| **Clue** | Lighter, more neutral science-comms tone | None | Minimal | Neutral-ish, not SMBC-specific | Light | Good privacy posture but no donor/treatment/solo tooling. |
| **Premom** | Couple-oriented (best OPK reader) | None | None | None | Limited | Signal depth only; nothing for donor choice or solo decision. |
| **Ovia Fertility** | Some partner visibility | None | Some treatment/appointment logging | Not SMBC-specific | Some | B2B2C employer channel; treatment tracking shallow, no donor tooling. |
| **Glow / Fertility Friend / Kindara** | Partner linking / chart-sharing with partner | None | Charting only | None | Varies | Power-user charting; **partner is the assumed second party**, not a donor. |
| **Donor bank portals (California Cryobank, Cryos, ESB, London Sperm Bank)** | N/A | **Core** — searchable donor catalogs, ID-release status, medical/family profiles | None | Purchase-focused | Some (limited) | Selection only; siloed from her cycle/health data; sales-driven, not decision-neutral. |
| **Single Mothers by Choice (org) / Solo Mum Society** | None — SMBC-native | Guidance/education, not a tool | Community wisdom | **Best-in-class framing** | **Best-in-class** (Thinker/Tryer/Mom forums, 40+ yrs) | Community/education, *not* a tracking product; no integrated tooling. |
| **Motherhood Reimagined / That Solo Mum** | None | Editorial guidance | Editorial | Strong SMBC voice | Blog/support groups | Content, not app. |

**Fragmentation map (the opening for Femio):**
- **Timing/signal depth** lives in the trackers — but every one assumes a partner.
- **Donor data** lives in bank portals — siloed, sales-driven, decoupled from her health record.
- **Logistics/cost** lives in her own spreadsheet — because no app owns it.
- **Framing + community** lives in SMBC/Solo Mum orgs — the emotional gold standard, but not a product.
- **Nobody** combines: partner-optional-by-default UX + donor-selection decision support + IUI/IVF logistics & cost tracking + honest fertile-window timing + trustworthy privacy + non-judgemental SMBC-native tone + one account that keeps all women's-health knowledge reachable across the lifespan. **That is C14's Femio thesis.**

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, prevent, or perform/prescribe treatment; it educates and helps the user track and organize.

**Access & who this is for (dignity grounding):**
- Professional ethics support equal access to fertility services **irrespective of marital status, sexual orientation, or gender identity** — single individuals should be treated the same as partnered patients. This underwrites Femio's non-judgemental posture. [ASRM Ethics Committee, *Access to fertility treatment irrespective of marital status, sexual orientation, or gender identity* (2021)]
- Around **half of single women pursuing donor conception have no fertility problem** — the need is sperm, not a diagnosis; do not default-frame SMBCs as infertile. [SMBC community / clinical framing — **[NEEDS SOURCE VERIFICATION AT PUBLISH]** for exact proportion]

**Treatment pathways (educational):**
- The two donor-sperm treatments are **IUI / Donor Insemination (DI)** and **IVF**. IUI places prepared donor sperm into the uterus around ovulation; IVF fertilizes eggs with donor sperm in the lab. IUI is the usual first-line for a solo woman without a known fertility barrier; IVF is used when there is a fertility factor or after IUI has not succeeded. [NHS *Infertility – treatment*; HFEA *Single women*; UCLH *IUI with donor sperm*]
- IUI may be **natural-cycle** or with **ovarian-stimulation medication**; cycles are often monitored (scan/LH) with timing around ovulation, sometimes a **trigger** to time insemination. [Cleveland Clinic *IUI*; UCLH]
- **How many IUIs before IVF:** many clinicians suggest reviewing/switching to IVF after around **3 IUI cycles**, and success per cycle falls with age (notably beyond 40). Femio frames this as *what guidelines/clinicians commonly describe* + "discuss with your clinician," never a verdict. [Cleveland Clinic; ASRM — **[NEEDS SOURCE VERIFICATION AT PUBLISH]** for exact cycle count + per-age rates]
- **Age matters and time is short:** because C14 skews ≥35, the ACOG/NHS shortened help-seeking window (evaluate at 6 months ≥35; without delay ≥40) is usually already in play — treatment often starts promptly by design. [ACOG; NHS; ASRM]

**Donor selection (awareness — Femio informs, never brokers):**
- Donor sperm from a licensed clinic/bank is screened: family history checked for serious genetic disease; donors tested negative for HIV, Hepatitis B/C, syphilis, chlamydia; screened for cystic fibrosis and chromosome analysis. [NHS *spermdonation.nhs.uk*; HFEA]
- **ID-release vs anonymous:** rules are jurisdictional. In the UK, donation since 1 April 2005 is **not anonymous** — a donor-conceived person may access **non-identifying** info at 16 and **identifying** info (name, DOB, last known address) at **18**. [HFEA *Rules around releasing donor information*; *Sperm donation and the law*]
- **Family/sibling limits:** in the UK a donor's sperm may be used to create up to **10 families**, limiting the number of donor-linked half-siblings. Limits and registries differ by country. [HFEA; NHS]
- Both known/ID-release and anonymous routes carry trade-offs; counselling/support is repeatedly recommended to work through the choice and family-linkage questions. [PMC — *Complexities in the donor narratives of single mothers using sperm donation*; PMC — *Psychosocial aspects of identity-release gamete donation*]

**Disclosure & donor siblings (parenting-forward education):**
- Research on solo mothers finds **most disclose early** (in infancy), which normalizes the story; discussion of **donor siblings ("diblings")** tends to come later as the child matures. The **Donor Sibling Registry** connects donor-conceived people, half-siblings, and donors. [Swedish solo-mother study via DC Journal Club; Donor Sibling Registry; U.S. Donor Conceived Council]

**Preconception (in scope, shared with C1):**
- **Folic acid 400 mcg/day** from ≥1 month before conception through the first trimester; general preconception care (chronic-condition/medication review, vaccination) belongs with a clinician. [CDC; ACOG Prepregnancy Counseling; NICHD]

**Emotional load (design grounding):**
- Fertility-related stress can rival that of serious medical diagnoses; for SMBCs this is compounded by solo decision-making and stigma, and **relieved by peer community**. [ASRM (stress framing); SMBC/Solo Mum community evidence]

Flagged for medical-review sign-off before ship: exact IUI-before-IVF cycle count, per-age IUI success rates, the "half of SMBCs have no fertility problem" proportion, and **per-jurisdiction** donor-anonymity/family-limit rules (UK HFEA ≠ US ≠ MENA). **[NEEDS SOURCE VERIFICATION AT PUBLISH]** for any figure or legal rule stated without a per-locale reviewed citation.

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Partner-optional-by-default experience** — the entire TTC surface renders with **no partner assumed**: no "invite your partner," no second-parent-required fields, no coupled tone. A partner/support-person is an *optional* add, never scaffolding. (This is the persona's spine, not a feature.)
2. **Donor selection & comparison tool** — a neutral, decision-support shortlist: compare candidate donors on the criteria that matter (ID-release vs anonymous status, medical/family history summary, family/sibling limit, siblings reserved). **Femio informs the decision; it does not sell, broker, or recommend a specific donor.** Educational cards on ID-release vs anonymous by jurisdiction.
3. **IUI/IVF cycle tracker (educational)** — cycle-by-cycle: cycle type (natural/medicated IUI, IVF), monitoring appointments, trigger timing, insemination/transfer date, outcome. Explains each step; never prescribes or doses.
4. **Medication/protocol log (educational only)** — record what her clinic prescribed and what each medication *is for*, with clinician-review prompts. **Never a dose, never a schedule Femio authored.**
5. **Solo decision-support ("Thinker") module** — readiness frameworks, IUI-vs-IVF and cost trade-off explainers, "am I ready to parent solo" reflection prompts, and content that validates SMBC as a considered, legitimate path.
6. **Fertile-window / ovulation timing** — inherits C1's uncertainty-honest predictor + OPK/BBT/CM for **natural or lightly-medicated IUI timing**; clearly awareness, never contraception.
7. **Cost & logistics ledger** — track spend per cycle (vials, monitoring, meds, procedure) and appointments in one place — replacing the spreadsheet.

**P1 — Strong differentiators (fast follow):**
8. **Vial inventory + future-sibling planning** — track remaining vials from a chosen donor; optional "reserve for a sibling" flag and education on same-donor sibling considerations.
9. **SMBC-native community / moderated Q&A** — Thinker / Tryer / Mom spaces that **assume no partner and no shame**; privacy-safe. (Directly answers the strongest community need.)
10. **Disclosure toolkit** — age-appropriate "telling your child" scripts, "diblings"/Donor Sibling Registry education, timelines — all parenting-forward, cited.
11. **Record/export for clinician or bank** — export cycle history, timing charts, cost/appointment log if/when she chooses.
12. **Two-week-wait experience (solo-tuned)** — DPO counter + anxiety-aware cards written for someone waiting *alone*, honest test-timing, no partner-shaped nudges.

**P2 — Nice-to-have / later:**
13. Optional "support person" mode (a friend/family member/sister she *chooses* to loop in) — the inverse of partner mode: opt-in, scope-limited, framed as *your* support, not a co-parent.
14. Clinic/appointment reminders + med-refill nudges.
15. Localized, region-aware framing (esp. AR/MENA safety-forward mode — see §I/§K).
16. Known-donor pathway education (co-parenting/known-donor legal-awareness → "get legal + counselling advice").

**Explicitly OUT of scope for C14 (guardrails):**
- **Brokering, selling, or recommending specific donors, banks, or clinics.** Femio educates on *how to evaluate*; it is not a marketplace and takes no referral position.
- **Prescribing, dosing, or scheduling medication/treatment.** Protocols come from her clinic; Femio only records + educates.
- **Any contraception / "safe day" framing.** Never.
- **Diagnosing infertility.** Screeners flag & route only (§K).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each card carries citations, "not medical advice / discuss with your clinician," and — critically — **no partner assumption** in examples or imagery.

- **"Is solo motherhood by choice right for me?"** — the Thinker readiness framework; validating, non-judgemental. Not a fallback, a considered path.
- **IUI vs IVF, and cost, explained** — pathways, what each involves, typical sequencing, why age changes the calculus. Cited; "discuss with your clinician."
- **Choosing a sperm donor** — what to weigh: medical/family history, ID-release vs anonymous, family/sibling limits, screening. Jurisdiction-aware (UK HFEA rules vs elsewhere).
- **ID-release vs anonymous donation, by country** — the child's future right to information; why disclosure matters.
- **What happens in an IUI cycle** — monitoring, trigger, timing, insemination, the wait (solo-tuned).
- **Understanding your medication protocol** — what stimulation/trigger meds *do* (educational, never a dose).
- **When clinicians commonly review moving IUI → IVF** — framed as guidance + "discuss with your clinician," never a verdict.
- **Telling your child their story** — age-by-age disclosure scripts; "diblings" and the Donor Sibling Registry.
- **Handling stigma & the "selfish?" question** — family/friends, self-compassion, community.
- **When a cycle doesn't work** — grief that's real even on a chosen path; coping alone; support resources.
- **Preconception starter (solo)** — folic acid 400 mcg, lifestyle, all cited (shared with C1, partner-free framing).
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so she's never boxed into "solo TTC only."

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception; education, not treatment)

**Logs (inputs):**
- Donor shortlist {candidate_id, id_release_status, family/sibling info, notes}, chosen donor + vial inventory, treatment plan (IUI/IVF), cycle logs (type, monitoring, trigger, insemination/transfer date, outcome), medication log (name + purpose only), appointments, cost entries, OPK/LH + BBT + CM (for timing), intercourse N/A by default (donor-timing instead), mood/symptoms, meds/supplements, HPT results.

**Tools:**
- Donor comparison/shortlist (decision-support, non-brokering), IUI/IVF cycle tracker, cost & appointment ledger, vial inventory + sibling-reserve flag, fertile-window estimator (range + confidence), DPO/TWW counter, disclosure-script library, export for clinician/bank.

**Alerts / nudges (all opt-in, tone-calibrated, revocable, partner-free):**
- "Your fertile window is *likely* opening — if you're timing a natural-cycle IUI, this is the range to discuss with your clinic." (awareness language)
- "Monitoring appointment tomorrow." / "Time to take today's OPK / temperature."
- "It may still be too early to test — a negative now isn't conclusive." (solo-tuned TWW)
- Medication reminder = *"your clinic's protocol says…"* framing, user-entered, never Femio-authored dosing.
- **No** "tell your partner," "today's a good day for you two," or any coupled nudge — ever.

**Mandatory compliance wording on relevant surfaces:**
- *"Predictions are estimates based on your data — not a guarantee, and **not a method of birth control**."*
- *"Femio provides education and tracking. It does not prescribe or manage treatment, or recommend specific donors, banks, or clinics. Please make medical decisions with your clinician."*
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*
- No "safe day / infertile day" language — **ever**.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `support_person_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamped, "non-diagnostic").

**C14 persona-specific:**
- `ttc_intent = true`, `conception_mode = donor_solo`, `partner_present = false` (**default; drives partner-optional rendering**).
- `smbc_stage` {thinker | tryer | mother}.
- `donor_shortlist[]` {candidate_ref, id_release_status, family_limit_info, medical_family_history_summary, notes}, `chosen_donor_ref`, `donor_jurisdiction`.
- `vial_inventory` {count_available, reserved_for_sibling_flag}.
- `treatment_plan` {pathway: IUI_natural | IUI_medicated | IVF}, `cycles[]` {type, monitoring[], trigger_ts, insemination_or_transfer_ts, outcome}.
- `medication_log[]` {name, purpose, clinician_prescribed:true} — **purpose only, no Femio-authored dose**.
- `appointments[]`, `cost_ledger[]` {cycle, category, amount, currency}.
- `opk_results[]`, `bbt_readings[]`, `cm_log[]`, `predicted_window[]` {start, end, confidence}, `dpo_current`, `hpt_results[]`.
- `support_person_link_id` (optional, opt-in), `support_person_scope`, `support_person_consent_ts` — **the inverse of partner-link: never required, user-chosen.**
- `disclosure_plan_state` (optional).
- `folic_acid_start_date`, `preconception_checklist_state`.

*Data-minimization: collect only what powers a used feature. Donor IDs, treatment records, cost, and unmarried-parent status are **acutely sensitive** — strict retention, user-deletable, region-aware handling (§I/§K).*

---

## I. Personalization rules (wizard → home config; partner-optional; hidden-but-reachable)

**Onboarding wizard (branch into C14):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "How are you building your family?" → **includes a first-class, non-othered option: "On my own, with a donor (solo)."** (Not buried under "other"; not requiring a partner first.) → sets `conception_mode = donor_solo`, `partner_present = false`.
3. "Where are you in the journey?" → Thinker / Choosing a donor or clinic / In treatment (IUI/IVF) / → sets `smbc_stage` + home emphasis.
4. Age capture → tone + time-sensitivity framing (usually ≥35).
5. "How do you want to track?" (donor shortlist / cycles & treatment / cost / timing signals) → enables those; others stay **reachable**.
6. "Is there a support person you'd like to loop in?" → **optional, framed as *your* choice** — the inverse of "invite your partner." Never presented as expected.
7. Consent & privacy choices — **with a region-aware safety step** where donor conception / unmarried motherhood is legally or culturally sensitive.

**Partner-optional UX (the persona's design law):**
- **Default = solo.** No screen assumes a second parent. "Partner mode" is replaced by **optional Support-Person mode**: user-initiated, scope-limited, revocable, and *never* co-parent-framed.
- Copy, examples, illustrations, and nudges are written partner-free by default across the whole TTC surface (this benefits LGBTQ+ and other non-couple users too).
- Any field that other apps make "partner-required" (e.g., second-parent details, "his sperm") is either removed or reframed to donor/solo context.

**Home config for C14:**
- **Thinker stage:** Hero = decision-support / readiness + IUI-vs-IVF-vs-cost explainer; secondary = donor-selection education, SMBC community.
- **Choosing stage:** Hero = donor comparison/shortlist + clinic/cost planning; secondary = ID-release education, jurisdiction rules.
- **Tryer stage:** Hero = current cycle tracker (monitoring/trigger/timing) + fertile-window card (for natural IUI); secondary = TWW/DPO card, cost ledger, community.
- **Hidden-but-reachable:** full lifespan library, condition pages, perimenopause, contraception *education* — one search away. Configured, not walled in.

**Regional / cultural sensitivity (esp. AR/MENA):**
- In regions where donor conception and unmarried motherhood are legally restricted and heavily stigmatized (UAE, KSA, Qatar, Egypt and others — third-party gamete donation is broadly prohibited; frameworks are built around married couples), Femio must **educate honestly without endangering the user**: neutral, factual, safety-forward content; heightened privacy defaults; no assumption she can access treatment locally; awareness of cross-border care as an option users describe — always "seek local legal and clinical advice."
- **Never** moralize, and never expose SMBC status in shared/family-visible surfaces. Discretion is a safety feature, not just a preference.
- AR content is RTL-first with the same non-judgemental register; modesty-aware imagery.

**Adaptive tone:** empowering and matter-of-fact for the deliberate decision-maker; validating and gently company-keeping through solo waits and losses. Never pity, never "selfish?", never toxic-positive.

---

## J. Adaptation triggers (state transitions)

C14 **inherits all universal events** from the Master Adaptation Model §6 (positive test, pregnancy loss, mood-screen-high/crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). Listed below are **C14-specific** transitions only; universals fire as defined globally.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Starts IUI or IVF** | user sets `treatment_plan` / logs first cycle | Layer in the IUI/IVF cycle tracker, medication (educational) log, cost ledger, monitoring/appointment reminders; keep timing signals for natural-cycle IUI. Carry all data. | **→ C10** (IUI/IVF-in-treatment shared logistics layer), C14 emotional/donor layer retained |
| **Thinker → Tryer** | `smbc_stage` advances (chose donor/clinic, begins trying) | Shift home from decision-support to active cycle/timing tracking; surface donor inventory + sibling-reserve; tone → active + company-keeping. | Stay C14, re-layer home |
| **Positive pregnancy test** | `hpt_results` positive / user confirms | **Universal positive-test handler**: celebrate (tone-matched); suppress fertile-window/TWW/OPK/BBT; carry donor + treatment record; re-confirm privacy scope. Offer Pregnancy mode carrying modifiers. | **→ Pregnancy (D)**, flagged *pregnancy after donor conception / after treatment*; solo-parent-aware, partner-free pregnancy UX |
| **IUI cycle(s) unsuccessful / considering escalation** | logged cycle outcome negative; multiple cycles | Calm, non-diagnostic card: "Clinicians commonly review options such as IVF around this point — discuss with your clinician." Deepen support + community; **no** infertility label. | Education + clinician-routing; **→ C10** if escalating to IVF |
| **Pregnancy loss reported** | user reports loss | **Universal loss handler**: instant suppression of celebratory/milestone nudges; Gentle Mode; grief resources; retain data; no re-prompting. **Solo-tuned grief** (no partner to lean on; "chosen path" doesn't lessen loss). | **→ E6 grief**, later optional **RPL / Pregnancy-After-Loss (PAL)** — partner-free framing |
| **Screener flags a fertility factor** | screener/onboarding flags irregular/absent cycles, suspected condition | Soft route to relevant condition content + "consider evaluation with your clinician"; **never** auto-label infertile (many SMBCs are not). | Screener → clinician; condition modules |
| **Chooses a support person** | opt-in support-person link | Enable scope-limited, revocable Support-Person view (inverse of partner mode); log consent. | Stay C14 |
| **Pauses / chooses adoption / child-free / donor change** | user updates plan | Honor without a partner-shaped gap; retain data; low-touch wellness + relevant content; no re-prompting. | Retain / re-route (e.g., adoption content), silent |

*All routes preserve data continuity (one account), keep the experience partner-optional, and end with clinician/legal-referral language — never a diagnosis, never a treatment instruction, never a donor recommendation.*

---

## K. Compliance flags

1. **Partner-optional is a compliance-adjacent inclusivity guardrail, not a nicety.** The default UX must never require or assume a partner. Coupled framing toward an SMBC is an inclusivity failure and a churn/erasure risk. (Grounded in ASRM's equal-access ethics: treat single individuals the same as partnered ones.)
2. **No brokering / no recommendation of donors, banks, or clinics.** Femio provides **decision-support education**, not a marketplace or referral. It must not sell, rank-to-sell, or steer toward a specific donor/bank/clinic — this keeps Femio out of a regulated-intermediary posture and avoids conflicts of interest. **[NEEDS SOURCE — confirm advertising/health-marketplace rules per store + region at ship.]**
3. **No treatment, prescription, dosing, or scheduling.** IUI/IVF protocols and medications come from the user's clinic. Femio records purpose + educates only; medication surfaces must never present a Femio-authored dose or schedule.
4. **No diagnosis / no default "infertile" identity.** Many SMBCs have no fertility problem. Screeners flag & route ("screening — discuss with a clinician"); age/cycle thresholds are educational routing, not verdicts.
5. **Not contraception.** Fertile-window features are conception-awareness only; carry *"not a method of birth control"* on predictive surfaces. Ban "safe/infertile day."
6. **Acute privacy sensitivity + region-aware safety.** Donor IDs, treatment records, cost, and **unmarried-parent status** are special-category and, in restrictive jurisdictions, potentially **unsafe if exposed**. Explicit granular consent; no ad/analytics-SDK access; heightened privacy defaults in sensitive regions; no SMBC status in family-visible/shared surfaces; strict retention + user-deletion. Learn from category history (FTC actions vs Flo 2021, Premom 2023). **[NEEDS SOURCE — align to Femio privacy skill / DPA + FTC primary docs at implementation.]**
7. **Jurisdictional legal accuracy on donor rules.** Anonymity, ID-release ages, and family/sibling limits differ by country (UK HFEA: non-anonymous since 2005, non-ID at 16 / ID at 18, 10-family limit ≠ US ≠ elsewhere); MENA broadly prohibits third-party donation. Donor-law content must be per-locale, reviewed, and end with "seek local legal advice." **[NEEDS SOURCE VERIFICATION AT PUBLISH]** per jurisdiction.
8. **Support-person consent (inverse of partner mode).** Any looped-in support person sees only what the user grants; consent logged, scope-limited, instantly revocable; opt-in only, never expected.
9. **Emotional safety — chosen path, real grief.** SMBC decision-weight, stigma, and isolated loss are distinct from infertility grief and must not be minimized by "but you chose this." Silence-over-risk on loss paths; crisis resources on high mood-screens; peer community as a first-class support.
10. **Medical review + citations + reading level.** All clinical content medically reviewed, cited to primary sources, grade 6–8, localized in 4 languages with RTL parity. Numeric/legal claims re-verified against live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH]**
11. **App-store health-app policy.** Meet Apple/Google health-app + medical-disclaimer requirements; no over-claiming; no fertility-outcome guarantees. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

- [ASRM — Access to fertility treatment irrespective of marital status, sexual orientation, or gender identity: an Ethics Committee opinion (2021)](https://www.asrm.org/practice-guidance/ethics-opinions/access-to-fertility-treatment-irrespective-of-marital-status-sexual-orientation-or-gender-identity-an-ethics-committee-opinion-2021/) · [PubMed](https://pubmed.ncbi.nlm.nih.gov/33906744/)
- [HFEA — Single women](https://www.hfea.gov.uk/i-am/single-women/)
- [HFEA — Rules around releasing donor information](https://www.hfea.gov.uk/donation/donors/rules-around-releasing-donor-information/)
- [HFEA — Sperm donation and the law: for patients](https://www.hfea.gov.uk/treatments/explore-all-treatments/using-donated-eggs-sperm-or-embryos-in-treatment/legal-implications-of-using-donated-sperm/)
- [NHS — Sperm donation and the law (spermdonation.nhs.uk)](https://www.spermdonation.nhs.uk/sperm-donation-and-the-law)
- [NHS — Infertility: treatment](https://www.nhs.uk/conditions/infertility/treatment/)
- [UCLH NHS — IUI with donor sperm](https://www.uclh.nhs.uk/our-services/find-service/womens-health-1/gynaecology/reproductive-medicine-unit/fertility/intrauterine-insemination-iui/iui-donor-sperm)
- [Shropshire & Mid Wales Fertility Centre (NHS) — Donor Insemination (DI) treatment](https://www.shropshireivf.nhs.uk/fertility-treatments-and-investigations/fertility-treatments/donor-insemination/treatment/)
- [Cleveland Clinic — IUI (Intrauterine Insemination): Procedure & Results](https://my.clevelandclinic.org/health/treatments/22456-iui-intrauterine-insemination)
- [CDC — About Folic Acid](https://www.cdc.gov/folic-acid/about/index.html)
- [ACOG — Prepregnancy Counseling](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2019/01/prepregnancy-counseling) · [ACOG — Infertility: Disparities and Access to Services (2025)](https://www.acog.org/clinical/clinical-guidance/committee-statement/articles/2025/01/infertility-disparities-and-access-to-services)
- [NICHD (NIH) — Pre-Pregnancy and Prenatal Care](https://www.nichd.nih.gov/health/topics/factsheets/preconceptioncare)
- [Manchester Fertility — IVF for Single Women guide](https://www.manchesterfertility.com/learn/guides/guide-single-women/)
- [Single Mothers by Choice (org) — Home](https://www.singlemothersbychoice.org/) · [Thinking](https://www.singlemothersbychoice.org/thinking/) · [About](https://www.singlemothersbychoice.org/about/)
- [Solo Mum Society](https://www.solomumsociety.com/) · [Motherhood Reimagined — SMC support groups](https://motherhoodreimagined.com/single-mother-by-choice-smc-support-groups/) · [That Solo Mum — becoming an SMBC](https://thatsolomum.com/becoming-a-single-mother-by-choice/)
- [PMC — Absence or presence? Complexities in the donor narratives of single mothers using sperm donation](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4677963/)
- [PMC — Psychosocial aspects of identity-release gamete donation](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7720987/)
- [Donor Sibling Registry — for prospective parents](https://donorsiblingregistry.com/prospective-parents)
- [U.S. Donor Conceived Council — Ask a Therapist: single parenthood by choice](https://www.usdcc.org/2023/10/24/ask-a-therapist-how-to-do-single-parenthood-by-choice-right/)
- [DC Journal Club — Study on how Swedish solo moms talk about donor conception](https://www.dcjournalclub.com/p/study-explores-how-swedish-solo-moms)
- [MetaFilter — How period trackers presume/impose heterosexuality (partner-assumption critique)](https://www.metafilter.com/147509/How-period-trackers-presume-impose-heterosexuality-fertility-feminity)
- [The Conversation — Popular fertility apps and widespread data misuse](https://theconversation.com/popular-fertility-apps-are-engaging-in-widespread-misuse-of-data-including-on-sex-periods-and-pregnancy-202127)
- [FTC — Flo Health settlement (2021)](https://www.ftc.gov/news-events/news/press-releases/2021/01/developer-popular-womens-fertility-tracking-app-settles-ftc-allegations-it-misled-consumers-about)
- [Middle East Fertility Society Journal — Review of assisted reproduction techniques, laws, and regulations in Muslim countries](https://mefj.springeropen.com/articles/10.1186/s43043-019-0011-0)
- [Sperm donation laws by country — Wikipedia (jurisdictional overview; verify against primary law at publish)](https://en.wikipedia.org/wiki/Sperm_donation_laws_by_country)

*Community insight (Single Mothers by Choice, r/singlemothersbychoice, Solo Mum Society, Motherhood Reimagined, Donor Sibling Registry, app-store reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. FTC actions vs Flo (2021) and Premom (2023) referenced via the sources above; verify against primary FTC press releases at implementation. Per-jurisdiction donor law (UK HFEA vs US vs MENA) and clinical figures (IUI-before-IVF cycle count, per-age success rates, proportion of SMBCs without a fertility problem) flagged **[NEEDS SOURCE VERIFICATION AT PUBLISH]**.*
