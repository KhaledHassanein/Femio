# Persona B17 — Thyroid disorder affecting the cycle, NON-TTC and non-pregnant

> Femio product + UX research spec. **Scope guardrail: wellness / education / tracking ONLY.** Femio never diagnoses, treats, prevents, or contracepts. Thyroid **lab (TSH/FT4/FT3/antibodies) and medication (levothyroxine / antithyroid drug) content is educational self-tracking — never a diagnosis, verdict, dose, or titration.** Screeners are framed as *"screening — discuss results with a clinician."*
> Persona code: **B17** · Cohort: B (reproductive-age, non-TTC, non-pregnant) · Last research pass: 2026-07-21
> Shares clinical grounding with **C8** (thyroid × conception) and **D7** (thyroid × pregnancy); B17 is the **upstream, non-TTC** node of the same thyroid spine. Distinct from C8 (thyroid + TTC) and D7 (thyroid + pregnancy).

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Nadia," 29 |
| **Age band** | ~20s–30s reproductive age; not trying to conceive, not pregnant, cycles still the axis of her month. |
| **Stage** | Living with a **known thyroid disorder** — most often **hypothyroidism / Hashimoto's** on levothyroxine; a substantial minority **hyperthyroidism / Graves'** on an antithyroid drug (ATD). Recently diagnosed or long-managed but still symptomatic. |
| **What changed her cycle** | Her thyroid is **visibly disrupting her period** — hypothyroid: **heavier, longer, or more frequent (short 21–24 day) cycles**, or absent ones; hyperthyroid: **lighter, shorter, infrequent (oligomenorrhea) or absent**. Plus the whole-body load: fatigue, weight change, low/anxious mood, hair thinning, temperature intolerance. |
| **Relationship / context** | May be partnered or single; the medical load (labs, pills, appointments, symptom diary) is hers alone. Not organizing around a partner or conception. |
| **Goal (top JTBD)** | *"Help me understand how my thyroid is messing with my period and the rest of me, keep my TSH/labs and my medication in one place, spot the patterns, and walk into my next appointment able to actually explain what's happening — without telling me I'm 'late,' pregnant, or trying."* |
| **Health literacy** | Rising fast; she's read that "thyroid affects periods" on Reddit and wants Femio to be better-sourced and calmer than the forum that scared her. |
| **Tech context** | Web-first, also phone. **Stacks apps today** — a period tracker (Flo/Clue) that ignores her thyroid + a thyroid tracker (ThyForLife/BOOST/Paloma) that ignores her cycle + a Notes file of TSH values. This duct-tape is the core pain. |
| **Emotional state** | Frustrated and self-doubting: "Is it my thyroid, my dose, or me?" Dismissed before ("your labs are normal, it's just stress"). Wants to feel **believed** and in control, not pathologized or funneled toward pregnancy. |
| **What she is NOT** | Not TTC, not pregnant, not seeking a diagnosis (she has one), not looking to be told her thyroid "is" everything. Being force-funneled into fertility/pregnancy framing the moment she logs an irregular cycle churns her instantly. |
| **Primary signals she brings** | Lab values (TSH, Free T4, ± Free T3, TPO/TG antibodies, ± TRAb for Graves'), medication + fasting/spacing adherence, and cycle + symptom clusters (flow/length changes, fatigue, weight, mood, hair, temperature). |
| **Success = she stops screenshotting a period app, a thyroid app, and a Notes file to hand her endocrinologist / GP.** |

**Persona thesis.** B17 sits at the **same unserved intersection as C8 — minus the baby.** Cycle apps have nowhere to put a TSH value; thyroid apps have no cycle. She is the woman for whom the thyroid–cycle link is a *daily lived symptom*, not a fertility variable. Femio's one-account, referenced, uncertainty-honest, privacy-by-design model is purpose-built for this overlap. And because her likely future forks are *exactly* Femio's flagship spine (decides to try → **C8**, positive test → **D7**), B17 is the clean **non-TTC entry point** to the thyroid journey — proving Femio "personalizes, never restricts" without ever slipping into diagnosis, dosing, or a pregnancy assumption.

---

## B. Needs & questions (voice-of-user)

Mined from r/Hypothyroidism, r/Hashimotos, r/thyroidhealth, thyroid-and-cycle forums, and app-store reviews of both period apps (Flo/Clue) and thyroid apps (ThyForLife/BOOST/Paloma). Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD (thyroid × cycle, non-TTC):**
1. *"Is my thyroid the reason my periods went haywire — heavy and every-three-weeks / vanished for months?"* (linking symptom → thyroid without self-diagnosing)
2. *"My TSH is 'in range' but my periods and I still feel awful — is this my dose?"* (the normal-labs-still-symptomatic frustration)
3. *"How heavy is too heavy? I'm soaking through and exhausted — is that the thyroid or something else I should check?"* (menorrhagia worry)
4. *"When am I supposed to re-test my TSH? My GP said 'a few months' and I forgot."* (monitoring-cadence confusion)
5. *"Did I take my levo right today — empty stomach, away from my coffee and iron?"* (adherence mechanics)
6. *"Is the weight / brain fog / hair fall the thyroid, my mood, or just me?"* (untangling the symptom cluster)
7. *"I want to SEE whether my bad-period months line up with my higher-TSH months."* (the pattern she can't get from two separate apps)
8. *"I'm on methimazole for Graves' and my periods stopped — is that the disease or the drug?"* (ATD + cycle question — strictly *ask your clinician*)
9. *"How do I put all this on one page for my endocrinologist so I stop forgetting half of it?"* (the export need)
10. *"Please stop telling me I'm 'late' or asking if I'm trying to get pregnant. I'm neither."* (the anti-pregnancy-funnel plea)

**Emotional arc (recurring, non-cyclical-in-the-usual-sense):**
- **Symptom flare:** heavy/absent bleed + fatigue crash + mood dip → "is my thyroid off again?" → wants to check when her last lab was and log the pattern.
- **Lab day / dose change:** anxiety about the number, then the 6–8 week wait to see if the new dose "works" — she wants that window *tracked and explained*, not silent.
- **Appointment:** fear of being dismissed; needs a clean summary so 10 minutes counts.
- **Plateau:** "labs normal, still symptomatic" — the hardest emotional place; needs validation without doom.

**Anti-needs / trust-breakers (what makes her churn):**
- Any app that assumes a 28-day cycle and brands her irregular bleed "late," or that pops "trying to conceive?" the moment she logs an odd cycle.
- A period app with **nowhere to put a TSH value**, or a thyroid app with **no cycle view** — the stack she's stuck in.
- Any app that treats "TSH in normal range" as "you're fine" (dismisses her lived symptoms) **or**, conversely, tells her a lab is "abnormal / you're under-medicated" (a verdict — out of scope).
- **Prescriptive tone** ("increase your dose to X") — needs *educational* framing routed to her clinician; anything reading like dosing both scares her and is out of scope (§K).
- Privacy creep with her combined reproductive **+** chronic-disease **+** medication data (post-Flo/Premom FTC distrust).

**Feature requests recurring in reviews/forums:**
- One place for **labs + meds + cycle + symptoms**, with a **thyroid-symptom line lined up against the cycle** (nobody offers this — §C).
- Lab **trend charts** (TSH over time) she can **export/share** with her endo/GP.
- **Medication reminders** with the fasting/spacing rules baked in, and a **next-lab-due** reminder tied to her clinician's cadence.
- **Descriptive** pattern insight ("your heavy-flow and low-energy logs cluster around your higher-TSH entries") — explicitly not a diagnosis.
- Honest, calm education on *how* thyroid changes periods, **without** a pregnancy detour.

---

## C. Competitor teardown

The decisive finding (identical to C8's, minus the fertility layer): **no mainstream app integrates thyroid management with cycle + symptom tracking.** B17 lives in the seam and stacks one app from each column.

### Column 1 — Period / cycle apps (track the bleed, blind to thyroid)

| App | Cycle + symptom depth | Lab handling (TSH etc.) | Thyroid support | Irregular-cycle framing | Privacy / positioning |
|---|---|---|---|---|---|
| **Flo** | Broad symptom logging; AI cycle predictions | **No structured lab/TSH tracker** | **None** (general symptom tags only) | Has an "irregular" mode but core UX still centers a predicted cycle; leans TTC/pregnancy | **FTC settlement 2021** (data to Facebook/Google); ~$56M class settlement (2025) |
| **Clue** | Strong, neutral symptom taxonomy; adapts to variable length | **No lab/TSH tracker**; limited third-party integration | **None** | More conservative predictions; still surfaces predicted period | Better GDPR posture; still no thyroid depth |
| **Ovia** | Cycle + health tracking | Minimal results logging | **None thyroid-specific** | Fertility/pregnancy-oriented | Employer/health-plan B2B2C data model |
| **Stardust** | Symptom/flow, privacy-forward | Minimal | **None** | Low prediction emphasis (good) but astrology framing dilutes clinical trust | Strong local-first privacy |

### Column 2 — Thyroid / Hashimoto's apps (track labs/meds, blind to the cycle)

| App | Lab tracking (TSH/FT4/FT3/antibodies) | Medication + adherence | Symptom tracking | Cycle / period view | Notes |
|---|---|---|---|---|---|
| **ThyForLife** | **Deep** — TSH, T4/FT4, T3/FT3, TG, TGAb; 40+ meds | Yes | Yes | **None** | Community + trend charts; thyroid-only |
| **BOOST Thyroid** | Deep labs + reference ranges | Meds/supplements, reminders | Symptoms, notes, trends | **None** | Hashimoto/hypo focused |
| **Paloma Health** | Labs + symptom tracker | Reminders | Yes | **None** | Bundled with US telehealth + at-home test kits |
| **Hashimoto's Journey / Hashimoto Tracker** | TSH, FT4, TPO Ab; fasting/timing compliance | Levo adherence | Fatigue/brain-fog ratings | **None** | Endo-shareable reports; thyroid-only |

### Whitespace map (the B17 opening)

- **Cycle depth** lives in Column 1; **thyroid depth** lives in Column 2. **No product spans both — and none lets her see the two *against each other*.**
- The exact thing B17 wants — a **thyroid-symptom-and-lab line laid over her cycle history** to answer "does my bad-period month track my TSH?" — is a view **neither category can render**, because each only holds half the data.
- **Nobody** offers: irregular-cycle-honest tracking **+** structured TSH/antibody lab trends **+** levothyroxine/ATD adherence with fasting rules **+** thyroid-symptom-vs-cycle correlation **+** endo/GP-ready export **+** trustworthy privacy **+** Arabic-first RTL, in **one account — with no pregnancy assumption.** That seam, minus the baby, is B17's Femio thesis.

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, prescribe, or adjust medication; it educates and helps the user track and prepare for clinician conversations. **All lab/medication content is educational — every number is "what guidelines describe; confirm with your clinician," never a verdict or dose.**

**Thyroid hormone regulates the menstrual cycle.** Thyroid hormone influences metabolism, mood, temperature, hair, and the reproductive axis; thyroid dysfunction is a recognized cause of menstrual disturbance in reproductive-age women. Correcting thyroid function commonly restores a more regular cycle — i.e. these effects are typically **reversible with appropriate treatment** (a clinician decision). [NIDDK — Hashimoto's disease; Mayo Clinic; MedlinePlus; NHS]

**Hypothyroidism → heavier / more frequent / irregular or absent periods.**
- Hypothyroidism can be associated with **heavy or irregular menstrual periods** and fertility problems, but these symptoms are nonspecific and do not diagnose a thyroid disorder. Femio does not publish a shortened-cycle range, prevalence, or speculative mechanism and directs new/heavy bleeding to clinical evaluation. [NIDDK, “Hypothyroidism,” accessed 24 July 2026](https://www.niddk.nih.gov/health-information/endocrine-diseases/hypothyroidism). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Hyperthyroidism → lighter / shorter / infrequent or absent periods.**
- Overactive thyroid is classically associated with **hypomenorrhea (scant flow), oligomenorrhea (infrequent periods), and amenorrhea** — amenorrhea was one of the earliest-recognized clinical signs of hyperthyroidism (von Basedow, 1840). Mechanisms include disrupted estrogen/progesterone balance, altered feedback and anovulation, and sometimes raised prolactin. [ScienceDirect — Thyroid disease and female reproduction; Medical News Today clinical review; ATA patient materials]

**The whole-body symptom cluster B17 is untangling (education, non-diagnostic).**
- Hypothyroidism/Hashimoto's commonly presents with **fatigue, weight gain, dry/thinning hair, cold intolerance, low or depressed mood, and heavy/irregular periods**; hyperthyroidism/Graves' with **weight loss, heat intolerance, palpitations, anxiety, and light/absent periods.** Femio helps her *log and see* these together; it never asserts causation. [NIDDK; Mayo Clinic; Cleveland Clinic]

**Monitoring (educational cadence — a clinician sets hers):**
- **Hypothyroidism on levothyroxine:** baseline TSH (± Free T4), re-checked about **6–8 weeks** after starting or after any dose change, then—once stable/normalized—**every ~6–12 months** barring a change in status. [AACE/ATA hypothyroidism guideline; AAFP] Femio surfaces this as *what guidelines describe*, tied to the user's own clinician-set date — never an instruction to change anything.
- **Hyperthyroidism/Graves' on an ATD:** Free T4 and T3 are typically monitored roughly **every 4–8 weeks** during titration, then less often once stable; **TSH can stay suppressed for months** early on and is a poor early gauge. Over-treatment can tip toward **hypothyroidism**, so shifting thyroid status (and shifting periods) is expected during treatment. [2018 ETA Graves' guideline; AAFP hyperthyroidism] All clinician-managed — Femio educates and tracks only.

**Thyroid autoimmunity context (non-alarming, non-TTC framing):**
- TPO/TG antibodies define Hashimoto's and can be present in Graves'; antibody status is something a clinician interprets. Antibody-and-pregnancy risk material is **downstream** (C8/D7) and is *not* pushed to a non-TTC, non-pregnant user — it stays reachable, never foregrounded. [NIDDK; ATA]

**Medication mechanics (adherence education, not prescription):**
- **Levothyroxine administration education:** follow the prescription label. Current MedlinePlus drug guidance describes taking levothyroxine on an empty stomach **30–60 minutes before breakfast** and separating **calcium carbonate or ferrous sulfate by at least 4 hours before or after** levothyroxine; NHS guidance likewise advises 30–60 minutes before the first meal or a caffeinated drink. Femio may mirror a user-entered regimen and remind; it never sets or changes the dose. ([MedlinePlus Drug Information](https://medlineplus.gov/druginfo/meds/a682461.html); [NHS, reviewed 6 July 2026](https://www.nhs.uk/medicines/levothyroxine/); reviewed Mohamed K., 23 July 2026.)

**Guideline-version integrity.** Femio publishes no universal TSH reference band, monitoring interval, or treatment target. It stores user-entered results with the reporting laboratory’s own range and routes interpretation to the clinician. Levothyroxine administration wording is limited to the cited MedlinePlus/NHS text above; pregnancy thyroid education links to the [American Thyroid Association guideline, 2026](https://doi.org/10.1177/10507256261445624). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

*Femio applies all thyroid targets/thresholds as **educational context**, always ending "discuss with your clinician" — never a diagnosis, prescription, or dose instruction.*

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Unified thyroid + cycle home (non-TTC)** — one screen carrying the **cycle view (irregular-honest, no "late" counter, no fertile-window)** *plus* her **latest TSH/lab + next-lab reminder + today's medication status**. This single integration is the whole reason B17 leaves her two-app stack.
2. **Lab tracker (thyroid-aware)** — structured entry for **TSH, Free T4, ± Free T3, TPO/TG antibodies, ± TRAb**, with unit, date, and the user's own lab reference range; **trend charts over time**. Labs shown **with the range for record-keeping only — never "abnormal / normal" as a verdict.**
3. **Medication log & reminders (educational)** — levothyroxine or ATD, dose she enters herself, **fasting/timing/spacing reminders** (empty stomach; separate from iron/calcium/coffee), adherence streak. **No dosing suggestions.**
4. **Irregular-cycle-honest tracking** — models her cycle as a **personal range**, never labels her "late," suppresses fertile-window/pregnancy widgets by default (reachable, not pushed).
5. **Thyroid-symptom ↔ cycle correlation view** — the flagship B17 differentiator: her thyroid-symptom logs (fatigue, weight, mood, hair, temperature) and **flow/length changes** shown **against her lab timeline** — *descriptive only* ("these cluster around your higher-TSH entries"), never causal/diagnostic.
6. **Next-lab-due & re-test reminders** — user/clinician-set cadence (e.g. "your GP asked for a re-check ~6–8 weeks after your dose change, around [date]").
7. **Endo/GP export pack** — one PDF/image: lab trends + med log/adherence + cycle history + thyroid-symptom trends + questions — built to hand to a busy clinician in a 10-minute slot.

**P1 — Strong differentiators (fast follow):**
8. **Heavy-bleeding awareness prompt** — non-alarming, screening-framed: "Very heavy or prolonged bleeding is worth discussing with your clinician — here's why and what to note," with clinician routing (never a diagnosis).
9. **Mood/energy screen (screening-framed)** — PHQ-2/GAD-2-style, returns "screening, not a diagnosis" + crisis resources; validates the mood load without pathologizing.
10. **Symptom-cluster logging** — fatigue, weight (optional/toggleable, never required), hair, temperature intolerance, palpitations, mood, sleep, cravings — logged together.
11. **Wearable/import** — Apple Health etc.; manual lab entry always primary.
12. **"Getting the most from your appointment"** — thyroid-and-cycle question lists, what a monitoring schedule looks like, how to advocate if dismissed.

**P2 — Nice-to-have / later:**
13. Photo-of-lab-report capture with user-confirmed transcription (private, deletable).
14. Localized clinician-question lists per market (AR modesty-aware).
15. Moderated Q&A / community (privacy-safe).

**Explicitly OUT of scope for B17 (guardrail):**
- **Any dose recommendation, titration, or "increase/decrease your levo/ATD."** Education + clinician routing only. **Never.**
- **Any lab verdict** — never "your TSH is abnormal / you're under-medicated / you're fine." Range + "discuss with your clinician" only.
- **Any pregnancy or contraception framing by default** — no "trying to conceive?" nudges, no fertile-window/"safe day." TTC and pregnancy are reachable, never assumed.
- Diagnosing thyroid disease or a menstrual disorder.

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each card carries citations + "not medical advice / discuss with your clinician," and — for anything touching meds/labs — an explicit **"educational, not a prescription or dose instruction"** line.

- **Thyroid & your cycle 101** — how thyroid hormone regulates the menstrual cycle; **hypothyroid → heavier/more frequent/irregular or absent**; **hyperthyroid → lighter/infrequent or absent**; why treatment usually reverses it (a clinician decision).
- **"My labs are 'normal' but I still feel awful"** — the range-vs-lived-symptoms picture, honestly; why symptoms and dose are a clinician conversation, not a self-adjustment.
- **Heavy periods & your thyroid** — what menorrhagia is, the thyroid link, when heavy/prolonged bleeding warrants a clinician check (screening-framed, non-diagnostic).
- **The thyroid symptom cluster** — fatigue, weight, mood, hair, temperature — why they travel together, and how to log them to see patterns (not to self-diagnose).
- **Taking levothyroxine right** — empty stomach, timing, spacing from iron/calcium/coffee (adherence education).
- **Hyperthyroidism / Graves' & your cycle** — lighter/absent periods, the ATD landscape *as a clinician conversation*, why monitoring shifts; **never a switch or dose instruction.**
- **How thyroid monitoring works** — why TSH is re-checked ~6–8 weeks after a change then periodically; why hyperthyroid monitoring leans on FT4/T3 early; "your clinician sets your schedule."
- **Getting the most from your appointment** — how to use the export pack; thyroid-and-cycle questions to ask; advocating if dismissed.
- **Reachable-but-hidden library:** full-lifespan women's-health content — including TTC, pregnancy, contraception education, and thyroid-antibody-and-pregnancy material — stays searchable so B17 is never boxed in, but none of it is pushed.

---

## G. Tools, logs & alerts (compliant framing — educational, awareness, not contraception, not prescription)

**Logs (inputs):**
- **Lab log:** TSH, Free T4, Free T3, TPO Ab, TG Ab, ± TRAb — value + unit + date + lab reference range (user-entered).
- **Medication log:** drug name (levothyroxine / ATD), user-entered dose, time taken, fasting/spacing adherence flags.
- **Cycle/bleed log:** flow (incl. heavy/flooding flag), spotting, cycle-length range view — **no "late" language.**
- **Symptom cluster:** fatigue, weight (optional/toggleable), mood, anxiety, hair thinning, cold/heat intolerance, palpitations, sleep, cravings; supplements (iron/calcium flagged for the spacing reminder).

**Tools:**
- Lab **trend chart** (TSH over time, with reference-range annotation — no pass/fail).
- **Thyroid-symptom ↔ cycle correlation view** (descriptive: "appears associated with," never "caused by").
- **Irregular-cycle range view** (personal range + variability; no fertile-window/prediction pressure by default).
- **Endo/GP export** (PDF/image) — labs + meds + cycle + symptom trends + questions.
- Screeners (framed as screening): mood/anxiety (PHQ-2/GAD-2-style) → "screening, not a diagnosis" + crisis resources; heavy-bleeding awareness checklist → "signs to discuss with a clinician."

**Alerts / nudges (all opt-in, tone-calibrated, revocable, RTL/localized):**
- "Time to take your medication" + (if relevant) "remember: empty stomach, and keep it away from iron/calcium/coffee." (adherence education)
- "Your next thyroid lab check is coming up around [date]." (user/clinician-set cadence; e.g. after a dose change)
- **Heavy-bleeding awareness:** "You've logged several heavy days — very heavy or prolonged bleeding is a good thing to discuss with your clinician." (screening, non-diagnostic)
- **Never:** "your period is late," "trying to conceive?", "safe day," "your TSH is abnormal," "increase/decrease your dose," or any diagnostic/prescriptive/contraceptive phrasing.

**Mandatory compliance wording:**
- On lab surfaces: *"Lab values are shown with your lab's reference range for your records — this is not a diagnosis. Discuss results with your clinician."*
- On medication surfaces: *"This log is for your own tracking. Femio does not recommend, prescribe, or change medication or dose. Any change is a decision for you and your clinician."*
- On cycle surfaces: *"Your cycles vary — this is a range, not a 'late' date, and Femio is not a method of birth control."*

---

## H. EMR / data fields (core vs persona-specific)

**Constant core (the one-account spine — present for everyone; carried unchanged across every §J transition):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (screener-derived, non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamped, "non-diagnostic" tagged).

> **Design principle (inherited from the flagship, §9 of the Master Model):** the EMR is **constant**; only the **content, home config, and alert logic layered over it are persona-specific.** B17's thyroid layer is added **over** the core, never replacing it — so when she later routes to C8 (TTC) or D7 (pregnancy), *no field is dropped*: the lab log, med log, cycle history, and symptom clusters all travel forward.

**B17 persona-specific (over the constant core — thyroid labs/meds are *entry-only*, never interpreted):**
- `thyroid_status` {hypothyroid / Hashimoto's / hyperthyroid / Graves' / other / not sure}, `thyroid_dx_date`, `antibody_status` {TPO±, TG±, TRAb±} (self-report).
- `labs[]` {analyte ∈ {TSH, FreeT4, FreeT3, TPOAb, TGAb, TRAb}, value, unit, ref_range_low, ref_range_high, date, source(self/clinic)} — **entry + trend display only, no interpretation as diagnosis.**
- `thyroid_meds[]` {drug (levothyroxine / methimazole / carbimazole / PTU / liothyronine), user_entered_dose, schedule, fasting_flag, spacing_flags[]}.
- `med_adherence[]` {med_id, timestamp, taken, timing_ok}.
- `lab_due_date`, `lab_cadence` (user/clinician-informed; e.g. post-dose-change 6–8wk).
- Cycle-impact fields: `flow_heavy_flag[]`, `cycle_pattern_note` {short / heavy / infrequent / absent — self-observed, non-diagnostic}, `prolonged_amenorrhea_days`.
- Thyroid-symptom cluster: `fatigue[]`, `weight[]` (optional/toggleable), `hair_change[]`, `temp_intolerance[]`, `palpitations[]`, `mood_screen_history[]` (scores + dates, screening-only).
- `ttc_intent` = **false** (drives the non-TTC, no-fertile-window UX; reachable toggle → C8).
- Export artifacts: `clinician_export_history[]`.

*Data-minimization: collect only what powers a used feature. Weight is optional and never required. Lab-report photos (if enabled) stored with strict retention + user-deletable. Reproductive + chronic-disease + medication data together = elevated sensitivity (§K).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into B17):**
1. "What brings you to Femio?" → *Tracking my cycle / general* → Q2.
2. "How are your cycles?" → *irregular / heavy / absent* (does **not** auto-assume PCOS or pregnancy).
3. "Do you have any ongoing health conditions we should tailor to?" → *Thyroid condition* → sub-pick {hypothyroid/Hashimoto's · hyperthyroid/Graves' · not sure} → enables the **thyroid layer** over the cycle base.
4. "Are you currently trying to conceive?" → **No** → `ttc_intent=false`; suppress fertile-window & pregnancy nudges.
5. "Do you take thyroid medication?" → seeds `thyroid_meds[]` + reminder setup (fasting/spacing rules).
6. "Do you want to track thyroid labs here?" → enables lab log; offers "add your latest TSH."
7. "What bothers you most?" (multi-select: heavy/irregular periods, fatigue, weight, mood, hair, appointment prep) → orders home modules.
8. Consent & privacy (explicit note that thyroid + reproductive + medication data are handled as special-category health data).

**Home config for B17:**
- Hero = **cycle range view (irregular-honest, no "late", no fertile-window)** + **thyroid strip** (latest TSH + next-lab reminder + today's medication status).
- Quick-log row = medication, lab, bleed/flow, + top symptom (e.g. fatigue).
- Secondary = **thyroid-symptom ↔ cycle correlation card**; the most relevant thyroid-×-cycle content module; export-prep.
- **Hidden-but-reachable:** full lifespan library, TTC/pregnancy/contraception education, thyroid-antibody-and-pregnancy content, other conditions — one search/tap away, never pushed.

**Adaptive tone:** believed-and-in-control. Validate her lived symptoms even when labs are "in range"; never imply her thyroid "is" the whole problem; never turn a lab into a verdict; never funnel her toward pregnancy.

**Adaptive tuning:** repeated heavy-flow logs → raise heavy-bleeding awareness content + export prominence. Low mood screens → surface mood module + crisis resources. 90+ day amenorrhea → non-alarming clinician-check prompt (thyroid *or* other causes — discuss).

---

## J. Adaptation triggers (state transitions)

B17 **inherits all universal events** from the Master Adaptation Model §6 (positive pregnancy test, pregnancy loss, mood-screen-high/crisis, red-flag symptom, disengagement/break, toggle-mode-off, age-of-consent). Those handlers are not re-specified here. Below are only B17's **persona-specific** transitions. All routes preserve data continuity (one account, constant EMR), require **explicit user confirmation** for a mode switch, and always end in clinician-referral language — never a diagnosis, prescription, or dose change.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Sets TTC intent = true** ("I want to start trying") | User toggles `ttc_intent=true` | Confirm; **carry all thyroid data forward** (labs[], thyroid_meds[], antibody_status, adherence, cycle history); add the fertile-window layer with uncertainty caveats; surface preconception-TSH + thyroid-antibody education (now relevant). | **C8 — TTC with a thyroid disorder** (thyroid data travels intact) |
| **Positive pregnancy test** (universal handler, thyroid-flagged) | `hpt_results` = positive / user confirms | Universal celebrate + suppress fertile-window/TWW; **keep lab + med logs running**; fire the educational **"because you take thyroid medication, many people need a lab check + medication review with their clinician early in pregnancy — contact your clinician soon"** prompt; offer one-tap Pregnancy mode. Never a dose. | **D7 — thyroid-aware pregnancy** (FLAGSHIP; thyroid data carried) |
| **Irregular-cycle crossroads** (cause unclear) | Persistently irregular/absent cycles where thyroid may not be the whole story (e.g. PCOS-adjacent signals, or user unsure of cause) | Present a **non-diagnostic crossroads**: "Irregular cycles can have several causes — thyroid is one; here's what else clinicians consider." Keep thyroid layer; offer the **B5 irregular-cycle pathway** for broader work-up education; never label. | **B5 — irregular cycles (undiagnosed/crossroads)**, thyroid layer retained |
| **Lab entered outside guideline-described band** | e.g. TSH logged well above/below range | **Non-alarming, non-diagnostic** note: "This is outside your lab's reference range — a good thing to discuss with your clinician." **No** verdict, **no** dose suggestion; raise export + next-lab prominence. | Stay B17; clinician-check prominence up |
| **Recurrent heavy / prolonged bleeding logged** | Repeated heavy-flow flags | Screening-framed heavy-bleeding awareness + "discuss with your clinician" + note to bring to appointment; never a diagnosis. | Stay B17; raise heavy-bleeding module |
| **Prolonged amenorrhea (90+ days, recurring)** | `prolonged_amenorrhea_days ≥ 90` | Non-alarming clinician-check prompt (thyroid *or* other causes); no "late" framing, no pregnancy assumption. | Stay B17; screening prominence up |
| **TTC paused / just optimizing thyroid** | User active but explicitly not trying | Keep thyroid + cycle mode; no TTC/fertile-window pressure; "getting your thyroid steady" education. | Stay B17 |
| **User toggles thyroid mode off** | Setting change | Revert to generic cycle logic; **preserve all thyroid history** (archived-but-reachable). | Generic reproductive-age band / Z1 |

> **Why B17 matters to the model:** it is the **non-TTC, non-pregnant on-ramp to Femio's flagship thyroid spine.** The same constant EMR that holds her labs and meds today flows — with zero rebuild — into C8 the day she decides to try, and into D7 the day she tests positive. B17 proves the thyroid layer exists *before* and *independent of* any reproductive intent, exactly as "personalize, never restrict" requires.

---

## K. Compliance flags

1. **No prescription / no dosing / no titration (top guardrail).** Medication logging is self-tracking only; Femio never recommends, changes, or doses medication. Reminder controls follow [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). *(Reviewed Mohamed K., 24 July 2026.)*
2. **No diagnosis / no lab interpretation as verdict.** Labs display **with the user's own reference range** for record-keeping and clinician discussion. Femio never says "abnormal," "under-medicated," "you have hypothyroidism," or "your TSH is fine/bad." Out-of-range values trigger *neutral* "discuss with your clinician" language only. This is doubly important for B17, whose lived complaint is often "normal labs, still symptomatic" — Femio validates the symptoms without adjudicating the dose.
3. **No pregnancy/contraception funnel.** `ttc_intent=false` by default; no "trying to conceive?" nudges, no fertile-window, no "safe/infertile day." Cycle predictions display uncertainty and carry *"not a method of birth control."* Keeps Femio out of the regulated-contraceptive lane and respects her explicit anti-funnel need (§B).
4. **Uncertainty honesty.** Irregular-cycle predictions degrade gracefully to a range + "this is expected," never a "late" counter. Contested clinical points (e.g. symptoms persisting with in-range labs) are framed honestly, routed to the clinician — no false precision, no overclaiming.
5. **Guideline-version integrity.** No universal TSH band, monitoring interval, or treatment target is published. Results retain the reporting laboratory’s range and remain clinician-interpreted. Administration spacing is limited to [MedlinePlus](https://medlineplus.gov/druginfo/meds/a682461.html) and [NHS guidance, reviewed 6 July 2026](https://www.nhs.uk/medicines/levothyroxine/). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Privacy-by-design — compounded sensitivity.** B17 combines **reproductive data + chronic-disease/lab data + medication data.** Learn from **Flo (FTC 2021)** and **Premom (FTC 2023).** No sharing of cycle/lab/med data with ad networks or third-party analytics; data minimization; explicit, granular, revocable consent; strict retention + user-deletion for lab-report photos.
7. **Privacy-law implementation.** For EEA processing, thyroid/reproductive data is health data within GDPR Article 9; document an Article 6 basis and Article 9 condition and implement applicable access, correction, portability, and erasure workflows. MENA and other launches require country-specific counsel review. Do not promise universal “GDPR/PDPL compliance” or data residency without approved architecture and contracts. See the [official GDPR text](https://eur-lex.europa.eu/eli/reg/2016/679/oj) and [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
8. **Screeners = screening.** Mood/anxiety and heavy-bleeding checklists always return "screening, not a diagnosis — discuss with a clinician." Crisis resources on any low mood screen, localized per region/language.
9. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIDDK/NIH/NHS/MedlinePlus) + Tier-2 (ATA/AACE/ETA/Endocrine Society), grade 6–8, localized in 4 languages with RTL parity.
10. **Emotional safety.** B17's load is frustration + self-doubt + feeling dismissed. Tone avoids both doom-framing and toxic positivity; validates lived symptoms; never blames her thyroid for everything; never pathologizes an irregular cycle.
11. **App-store health-app policy.** Follow the current Apple/Google controls pinned in [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): substantiate claims, avoid misleading functionality, provide required disclosures/clinician prompts, and complete Google’s health-app declaration. Tracking/education wording alone does not decide device status; launch counsel must review intended use and functionality. Re-check both stores immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIDDK / NIH / NHS / MedlinePlus / gov):**
- [NIDDK — Hashimoto's Disease](https://www.niddk.nih.gov/health-information/endocrine-diseases/hashimotos-disease)
- [MedlinePlus (NIH) — Hypothyroidism](https://medlineplus.gov/hypothyroidism.html)
- [Mayo Clinic — Hashimoto's disease: Symptoms & causes](https://www.mayoclinic.org/diseases-conditions/hashimotos-disease/symptoms-causes/syc-20351855)
- [Cleveland Clinic — Hashimoto's Disease: What It Is, Symptoms & Treatment](https://my.clevelandclinic.org/health/diseases/17665-hashimotos-disease)
- [NCBI/PMC — Menorrhagia as main presentation of severe hypothyroidism (case report)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9465942/)
- [NCBI/PMC — Hypothyroidism and Its Impact on Menstrual Irregularities in Reproductive-Age Women (tertiary-care analysis)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11281884/)

**Clinical — Tier 2 (ATA / AACE / ETA / society + peer-reviewed):**
- [AACE/ATA — Hypothyroidism in Adults Guideline (summary)](https://www.guidelinecentral.com/guideline/6855/)
- [ATA guidelines on treatment of hypothyroidism (MedCentral summary; monitoring cadence)](https://www.medcentral.com/endocrinology/thyroid/hypothyroidism/american-thyroid-association-guidelines-treatment-hypothyroidism)
- [AAFP — Hypothyroidism: Diagnosis and Treatment](https://www.aafp.org/afp/2021/0515/p605)
- [AAFP — Hyperthyroidism: Diagnosis and Treatment](https://www.aafp.org/pubs/afp/issues/2016/0301/p363.html)
- [2018 European Thyroid Association Guideline for the Management of Graves' Hyperthyroidism — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6140607/)
- [ScienceDirect — Thyroid disease and female reproduction (menstrual effects; historical amenorrhea)](https://www.sciencedirect.com/science/article/pii/S0015028200015892)
- [Medical News Today (clinical review) — Hyperthyroidism and menstrual cycle](https://www.medicalnewstoday.com/articles/hyperthyroidism-and-menstrual-cycle)
- [Healthline (clinical review) — Does Hypothyroidism Affect Your Period?](https://www.healthline.com/health/does-hypothyroidism-affect-period)

**Competitor landscape — cycle apps:**
- [Flo](https://flo.health/) · [Clue](https://helloclue.com/)
- [Best Period Tracker App 2026: Clue vs Flo vs Ovia](https://www.go-go-gaia.com/blog/how-to-choose-period-tracker-app.html)
- [Flo vs Clue vs Glow (TTC/PCOS)](https://ovul.ai/flo-vs-clue-vs-glow/)

**Competitor landscape — thyroid apps:**
- [ThyForLife — Thyroid Health Community & Tracking App](https://www.thyforlife.com/) · [ThyForLife — Your Thyroid and Your Period](https://www.thyforlife.com/you-thyroid-and-your-period/)
- [BOOST Thyroid — Hashimoto's and Hypothyroid App](https://www.boostthyroid.com/)
- [Paloma Health — thyroid app + care](https://www.palomahealth.com/) · [Paloma — Abnormal Uterine Bleeding and Hypothyroidism](https://www.palomahealth.com/learn/abnormal-uterine-bleeding-hypothyroidism)

**Cross-references (Femio internal):**
- `docs/09_MASTER_ADAPTATION_MODEL.md` (invariants, universal events §6, constant core §3, flagship C8→D7 §9)
- `docs/personas/C8_ttc_thyroid.md` (thyroid × TTC — B17's TTC route target)
- `docs/personas/B6_pcos_not_ttc.md` (B-track non-TTC format + irregular-cycle handling)

*Community material (thyroid/cycle forums and app-store reviews) is internal qualitative research used only to shape questions, tone, and workflow; wording is editorial paraphrase, not quotation or prevalence evidence. Clinical numbers require the pinned current guideline and medical review. Privacy controls use the [FTC Flo](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v) matters. Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
