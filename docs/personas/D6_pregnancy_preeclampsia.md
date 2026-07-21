# D6 — Pregnancy with Pre-eclampsia / Gestational Hypertension (Diagnosed, or High-Risk / Being Monitored)

> Femio persona spec. Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent.** Pre-eclampsia is **medical-emergency territory** — red-flag symptoms get prominent "seek care now" framing, but the app **NEVER diagnoses**. Screeners = *"screening — discuss with your clinician."* BP and medication content is **educational, never prescriptive**.
> Persona code: **D6** · Cohort: Pregnancy (D) · Layered on **D1** (uncomplicated pregnancy spine) · Last research pass: 2026-07-17
> Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Mona," 34 |
| **Stage** | Pregnant, T2/T3 (most commonly >20 weeks; high-risk flag can be set from booking). Either (a) **diagnosed** gestational hypertension or pre-eclampsia, (b) **high-risk / being monitored** (prior PE, chronic HTN, high BMI, IVF, multiples, first pregnancy, ≥40, family history), or (c) under **outpatient BP surveillance** after a raised reading. |
| **Relationship / support** | Partnered; wants partner informed and calm (X2 partner mode), because a possible early or emergency delivery affects the whole household. |
| **Goal (top JTBD)** | *"Help me watch this safely — log my blood pressure and symptoms, tell me in plain language which signs are an emergency, keep my appointments and medicines straight — and stay calm and accurate, never scare me and never pretend to be my doctor."* |
| **Health literacy** | Moderate–high and **highly motivated by fear**; researching obsessively ("is this headache the headache?"). Wants sources, thresholds, and clear "when to go in" lines. |
| **Tech context** | Web-first, phone-heavy, opens the app **multiple times daily** (each BP check is an app moment). May already own a home BP cuff and urine dipsticks; may be on a hospital "day-unit" or telemonitoring pathway. |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. MENA relevance high (PE/eclampsia carry heavier maternal-mortality burden where access is uneven — the "seek care now" routing matters even more). |
| **Emotional state** | **High, sustained anxiety.** Fears: seizure/HELLP, her own organ damage, an emergency C-section, a premature baby in NICU, and the helpless feeling of "will I even notice in time?" Monitoring is simultaneously reassuring and a burden (every reading is a verdict). |
| **What she is NOT** | Not a diabetic-pregnancy persona (D3), not chronic-HTN-only without pregnancy overlay framing (D5 sits adjacent; overlap handled in §J), not a general low-risk D1 (though she keeps every D1 feature). |
| **Success = she leaves us when…** | She delivers safely → **postpartum (E1)** with an **ongoing-BP-follow-up (E4)** tail (PE can *onset or persist* postpartum — see §J), and she felt watched-over, informed, and safely routed to care every time it mattered — never diagnosed, never falsely reassured, never scared by the app itself. |

**Persona thesis.** D6 is **D1 plus a safety-critical monitoring overlay**. She keeps the full week-by-week pregnancy spine, but her home is reorganized around a **BP + symptom log**, a **relentlessly clear red-flag layer**, and **appointment/medication tracking**. This is the persona where Femio's guardrail is most load-bearing: the value is *calm, cited education + frictionless logging + unmissable "seek care now" routing*, and the failure mode is *any hint of diagnosis, triage, or "your reading is fine."* Femio must be the **calmest, most honest** thing on her phone — not a false clinician.

---

## B. Needs & questions (voice-of-user)

Mined from r/preeclampsia, r/BabyBumps, Preeclampsia Foundation forums/FAQs, HELLP-survivor communities, and pregnancy/BP-app reviews. Phrasing is representative/composite (community norms; not quoting individuals). Anxiety and *monitoring burden* dominate.

**"Is this an emergency right now?" (the acute, defining need)**
- *"I have a headache that won't go away and I see spots — do I go to L&D or am I overreacting?"*
- *"My BP was 158/104 at home, then 148/96 ten minutes later — what number actually means 'go in'?"*
- *"Pain under my right ribs — is that the liver thing (HELLP) everyone warns about?"*
- *"Sudden swelling in my face and hands overnight — normal pregnancy or a sign?"*
- *"Baby feels quieter today and my BP is up — I'm terrified."*

**Blood-pressure logging & meaning**
- *"How do I take my BP properly at home so the number is real?"* (cuff position, rest, arm, avoiding white-coat spikes)
- *"Can I see my readings as a graph to show my midwife?"*
- *"What's a normal range and what's 'severe'?"* (wants the 140/90 and 160/110 lines, plainly)
- *"White-coat syndrome makes my clinic readings scary-high — home readings feel more real."*

**The monitoring burden & the fear of missing it**
- *"I check my BP 4x a day and I'm exhausted and obsessed."*
- *"I'm scared to sleep in case something happens overnight."*
- *"Every reading feels like a pass/fail exam."*
- *"Will I even notice a seizure coming?"* (eclampsia dread)

**Early delivery / prematurity fear**
- *"They're talking about delivering at 34 weeks — will my baby be okay?"*
- *"What is HELLP and how fast does it move?"*
- *"How long can they 'keep me pregnant' safely?"*

**Medications & aspirin**
- *"I'm on labetalol/nifedipine — what should I know?"* (→ never dose/advise; general cited info + "your clinician manages this")
- *"Why was I told to take low-dose aspirin, and until when?"*
- *"I keep forgetting my BP meds — I need reminders."*

**Appointments & the surveillance schedule**
- *"I have twice-weekly monitoring and I can't keep the dates, urine dips, and results straight."*
- *"What tests are they doing — PLGF, urine protein, bloods, growth scans — and what do they mean?"*

**Postpartum tail (under-served everywhere)**
- *"I delivered a week ago and my BP is HIGH again — I thought this ended at birth?"* (postpartum PE)
- *"How long do I keep monitoring after birth?"*

**Anti-needs / trust-breakers (churn + safety risk):**
- Any app that **interprets** a reading ("your BP is fine / dangerous") — that's diagnosis and could kill.
- **False reassurance** ("don't worry, that's normal") on a red-flag symptom.
- **Scare-content / doom-scrolling** — she is already maxed out; alarmist copy is harmful.
- Buried or slow "when to seek care" info.
- Privacy dread — pregnancy + a diagnosed condition is highly sensitive; she fears employer/insurer visibility and data sale.
- Reminders that keep firing after an early delivery or a loss.

---

## C. Competitor teardown

**Key insight for Femio:** the market splits into two camps that **do not meet** — consumer **pregnancy trackers** (broad, ad-heavy, no real PE support and correctly *cautious* about it) and **clinical BP-monitoring tools** (safe but gated behind a hospital, prescription, or device). **No trustworthy, privacy-first, multilingual consumer app offers calm PE *education* + a personal *BP/symptom log* + an unmissable *red-flag layer* without either overreaching into triage or requiring a clinical enrolment.** That gap — *educational, non-diagnostic, self-owned monitoring companion* — is D6's whitespace. **Safety caution:** the moment an app *interprets* readings it enters medical-device / diagnosis territory; Femio deliberately does **not** cross that line (contrast the clinician-connected tools below).

| App / tool | Category | BP logging | Symptom red-flags | PE-specific education | Interprets readings? | Privacy / positioning |
|---|---|---|---|---|---|---|
| **What to Expect** | Consumer pregnancy | No dedicated BP log | Generic warning-sign articles | Shallow, article-level | No | Reported data sale to 3rd parties for ad targeting |
| **BabyCenter** | Consumer pregnancy | No | Generic | Shallow | No | Sells data; named in 2024 US Senate data-broker inquiry |
| **Pregnancy+ (Philips)** | Consumer pregnancy | No | Generic | Shallow | No | Reported ad-sharing (Facebook/Google) |
| **Ovia Pregnancy** | Consumer pregnancy | Light health logging | Symptom checker-ish nudges | Some | Borderline (nudges) | Labcorp-owned; **employer/health-plan versions** raise PE-status-visibility concern — acutely bad for a diagnosed condition |
| **Flo (pregnancy mode)** | Consumer cycle→pregnancy | Symptom/weight logging | Generic | Shallow | No | 2021 FTC settlement; "Anonymous Mode" mitigates, not eliminates |
| **HaMpton** (NHS/King's) | **Clinical** home-BP for PE | **Yes — core** | Trigger-question set | Yes, pathway-embedded | **Yes — clinician-read, alerts to attend** | Real BP+urine home monitoring, **doctor/midwife read remotely**; ~53% fewer monitoring appointments. **Gated: hospital enrolment + provided cuff/sticks; a regulated clinical service, not a consumer app** |
| **Anura / app-based remote BP** | Research/clinical | Contactless BP (research) | — | — | Yes (clinical) | Trial-stage; clinician-facing |
| **Generic BP apps** (non-pregnancy) | Consumer cardio | Yes | No pregnancy red-flags | None | Some interpret (risky) | Not pregnancy-aware; PE thresholds/warning signs absent |

**What each camp gets wrong for D6:**
- **Consumer pregnancy apps:** no first-class BP log, no PE-specific red-flag layer, ad clutter around terrifying moments, privacy exposure — and (rightly) no triage, but they leave her with *nothing structured* for her actual condition.
- **Clinical tools (HaMpton etc.):** genuinely useful and *safe by design*, but **locked behind a hospital/device/prescription**, single-pathway, no lifespan continuity, not consumer-ownable, English-centric, and they *do* interpret/alert — which is exactly why they must be a regulated clinical service, not a general app.

**Femio's differentiated position for D6 (whitespace, held safely):**
1. **A self-owned BP + symptom + medication log** she controls — graphs she can **export/show her clinician** — with **zero interpretation** (no "normal/high" verdict) → stays out of the medical-device/triage lane HaMpton occupies.
2. **The clearest, calmest red-flag layer in the category** — CDC/NHS/ACOG warning signs, "seek care now," her saved maternity/emergency contact, one tap — never buried, never alarmist.
3. **Referenced, honest PE education** (thresholds, aspirin context, HELLP, postpartum PE) at grade 6–8, cited to Tier-1/Tier-2, in **AR-first + EN/FR/ES**.
4. **Privacy-by-design** — no data sale, no ad-SDKs, **no employer/insurer visibility** (decisive given Ovia's posture and her diagnosed-condition sensitivity).
5. **One account, full continuity** — layered on D1; carries cleanly into **postpartum + ongoing BP follow-up (E4)**, including the under-served **postpartum-onset** window.

---

## D. Clinical grounding (cited)

> All figures below are **patient education, not medical advice**. Femio content is medically reviewed and cited to primary sources. Femio **does not diagnose, treat, or prevent**; it educates and helps her track. Thresholds are shown so she knows *when to seek care*, **never** so the app can label a reading.

**What pre-eclampsia / gestational hypertension are (educational definitions).**
- **Gestational hypertension:** new high blood pressure after **20 weeks** without the other organ features. **Pre-eclampsia:** high BP after 20 weeks **plus** signs of organ involvement (protein in urine, or low platelets, kidney/liver changes, fluid on the lungs, or brain/vision symptoms). It can progress; **eclampsia** = seizures. **HELLP** (Hemolysis, Elevated Liver enzymes, Low Platelets) is a severe variant. [ACOG; MedlinePlus; NICE NG133; StatPearls]

**Blood-pressure thresholds (shown as *education*, so she knows the "seek care" lines — the app never applies them to her reading).**
- Diagnostic BP for pre-eclampsia (a clinician's measure): **≥140 systolic or ≥90 diastolic**, on two occasions ~4 hours apart, after 20 weeks. [ACOG]
- **Severe-range BP: ≥160 systolic or ≥110 diastolic** — an **urgent, seek-care-now** threshold. Multiple sources: readings **≥160/110** (with symptoms, or per guidance) warrant emergency assessment. [ACOG; NHS; MedlinePlus]
- App framing: *"These are the numbers clinicians use. If your reading is at or above 160/110, or you have any warning sign, contact your maternity unit or emergency number now. Femio can't tell you what your reading means — your clinician does."*

**Warning signs → seek care now (populate the red-flag box, verbatim-in-spirit).** Severe/persistent **headache that won't go away**; **vision changes** (blurring, spots, light sensitivity); **pain in the upper-right abdomen / under the ribs**; **sudden swelling** of face/hands; **shortness of breath**; nausea/vomiting (new, late pregnancy); **decreased fetal movement**; and any **seizure** = emergency. [CDC "Hear Her"; NHS; MedlinePlus; Preeclampsia Foundation; Mayo/Cleveland Clinic] → *"You know your body best — if something feels off, get checked. This app can't diagnose."*

**Home BP monitoring (guidance context — supports self-tracking, not self-diagnosis).**
- NICE recognizes home/self BP monitoring as an option in diagnosing and managing hypertension, and recommends **increased BP-check frequency for those at higher risk of pre-eclampsia**; outpatient PE/GH pathways commonly involve **once- or twice-weekly** clinician review, with home readings between visits. [NICE NG133; ACOG FAQ; systematic reviews]
- Higher-risk groups (NICE): **age ≥40, first pregnancy, >10-year pregnancy interval, BMI ≥30, family or personal history of PE, pre-existing hypertension/renal/vascular disease, multiple pregnancy.** → drives who Femio surfaces D6 education to. [NICE NG133]
- Evidence on home BP monitoring is **mixed/feasible but without consensus home diagnostic thresholds** — reinforcing that Femio logs and charts but **never sets a home cutoff or verdict**. [PMC systematic reviews]
- Good-technique education (rested, seated, back supported, arm at heart level, correct cuff, repeat) improves reading quality and reduces white-coat spikes — a legitimate, in-scope *how-to*. [general BP-technique guidance — *[NEEDS SOURCE: pin AHA/British & Irish Hypertension Society home-BP technique permalink]*]

**Low-dose aspirin prophylaxis (educational context only — never a Femio instruction to take it).**
- **USPSTF (Grade B):** low-dose **81 mg/day aspirin after 12 weeks** for those at high risk. **ACOG/SMFM:** initiate **between 12 and 28 weeks (optimally before 16), continue until delivery**, for ≥1 high-risk or ≥2 moderate-risk factors. **NICE:** **150 mg at night from 12 weeks** (to ~36 weeks) for high risk. [USPSTF; ACOG/SMFM Practice Advisory 2021; NICE NG133] → App framing: *"Some people at higher risk are advised by their clinician to take low-dose aspirin. Whether it's right for you, the dose, and timing are decisions only your clinician makes."*

**Medications (educational, never prescriptive).** Commonly used BP medicines in pregnancy include **labetalol, nifedipine, and methyldopa** (per NICE); **bed rest is not recommended** as treatment. Femio explains what a class *is* in general terms and always defers dosing/choice/changes to the clinician. **Never** a dosing calculator. [NICE NG133]

**Early / preterm delivery context (calm, factual).** The only definitive resolution of pre-eclampsia is **delivery**, sometimes **iatrogenic preterm birth** when maternal/fetal risks rise; timing is individualized (e.g., early birth generally not offered for GH with BP <160/110 before 37 weeks unless otherwise indicated). Frame supportively, never as a countdown or prediction. [NICE NG133; ACOG; StatPearls]

**Postpartum pre-eclampsia (critical, under-served).** PE/eclampsia can **onset or persist AFTER birth** — most commonly within **48 hours to ~7 days**, but **up to 6 weeks** postpartum (rare later cases documented). Presenting sign is often **headache**; the warning-sign layer and BP logging must **continue postpartum**. [ACOG/AJOG; Mayo Clinic; Cleveland Clinic; Preeclampsia Foundation] → seeds the **E4 ongoing-BP-follow-up** tail (§J).

**Emotional dimension (design-relevant, cited).** High-PE-risk pregnancy is associated with elevated **anxiety and depression** and a real **self-management/monitoring burden**; heightened anxiety is itself sometimes noted among PE presentations. Tone must be **calming and validating**, never alarmist. [Frontiers in Psychology 2025; Clinical Advisor]

*[NEEDS SOURCE]* flags to resolve before content freeze: exact **ACOG Gestational Hypertension & Preeclampsia Practice Bulletin (222)** permalink; **Preeclampsia Foundation** signs-&-symptoms permalink; **AHA/BIHS** home-BP technique permalink; region-localized emergency numbers and MENA-specific PE guidance.

---

## E. Feature set (prioritized)

> **All of D1's feature set is inherited and stays fully available** (week-by-week home, referenced library, kick counter, weight guidance, etc.). D6 *adds and re-prioritizes* a monitoring + safety overlay.

**P0 — must-have (the D6 safety overlay):**
1. **Blood-pressure log** — quick entry (systolic/diastolic/pulse, time, arm, optional "rested / white-coat context"), **trend chart over time**, **export (PDF) for clinician**. **Zero interpretation** — no color-coded "normal/high," no verdict. Educational threshold reference available *as content*, never applied to her number. (See §G, §K.)
2. **Symptom log with red-flag awareness** — headache, vision changes, upper-abdominal/rib pain, swelling, shortness of breath, reduced fetal movement — each logged symptom that is a PE warning sign **surfaces the "seek care now" box**, never a reassurance.
3. **Prominent, persistent red-flag / "seek care now" layer** — always one tap from home; saved **maternity-unit + emergency contact**; localized emergency guidance.
4. **Medication & aspirin tracker** — list her clinician-prescribed meds (name/time), **reminders**, adherence log. Educational "what this is" cards. **No dosing, no changes suggested.**
5. **Appointment / monitoring-schedule tracker** — twice-weekly monitoring, urine-dip dates, growth scans, PLGF/bloods; log results as **her own notes** (app never interprets); reminders; "questions to ask."
6. **Calm, cited PE education hub** (see §F) — foregrounded on the D6 home.

**P1 — high value:**
7. **Home-BP technique guide** — how to get a real reading (in-scope how-to).
8. **Partner/shared view (X2)** — partner sees the red-flag guidance + (opt-in) BP/symptom summary, so a second person can help her act and stay calm.
9. **Fetal-movement / kick awareness** foregrounded earlier and more prominently than in D1 (reduced movement is a PE-relevant red flag).
10. **Log export bundle** (BP + symptoms + meds + appointments) as a PDF she hands to her clinician or day-unit.

**P2 — later / differentiators:**
11. **Postpartum-BP-follow-up mode** (the E4 tail) — keeps BP logging + red-flag layer live after birth for the postpartum-onset window.
12. Optional device/wearable BP import (only stored raw; still never interpreted).
13. Gentle, privacy-safe curated Q&A (only if moderation quality is guaranteed).

**Explicitly OUT of scope for D6 (guardrail):**
- **Any interpretation, triage, or classification of a BP reading or symptom** ("your reading is normal/high/dangerous," "you have/likely have pre-eclampsia," "go to hospital / stay home"). **Never.** That is diagnosis + medical-device territory.
- Any **dosing calculator** or medication advice/changes.
- Any **risk-score verdict** presented as a conclusion (screening framing only).
- False reassurance on any red-flag symptom.

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Every card cites Tier-1/Tier-2 sources and carries "not medical advice / discuss with your clinician." Tone: **calm, honest, non-alarmist**.

- **"What is pre-eclampsia / gestational hypertension?"** — plain-language definitions, that it's monitored, that clinicians manage it (reassurance without minimizing).
- **"Warning signs — when to seek care now"** — the CDC/NHS/ACOG list, always reachable; the anchor of the whole persona.
- **"Understanding blood-pressure numbers"** — what 140/90 and 160/110 mean *as clinical reference points*; explicitly "these are for context, not for you to diagnose yourself; your clinician reads your readings."
- **"Taking your blood pressure at home properly"** — technique, white-coat effect, why one high reading isn't the whole story (and why any severe reading or symptom = seek care).
- **"HELLP syndrome — the signs to know"** — upper-right pain, nausea, feeling very unwell; fast-moving; seek care.
- **"Low-dose aspirin, explained"** — why some higher-risk people are advised to take it, the 12-week context, "your clinician decides" (educational, never an instruction).
- **"Your medicines in pregnancy"** — general, non-dosing explainer of common BP-medicine classes; adherence and "never stop/change without your clinician."
- **"Your monitoring schedule & tests"** — what PLGF, urine protein, bloods, growth scans are and why they're done (screening framing).
- **"Early birth & prematurity — what to expect"** — calm, factual, supportive; NICU basics; "delivery is how it's resolved and your team plans timing for you and baby."
- **"Fetal movements & why they matter here"** — reduced movement = contact provider today.
- **"Pre-eclampsia after birth"** — the postpartum-onset window (48h–6 weeks), keep monitoring, headache as a key sign.
- **"Coping with the worry"** — validating the monitoring burden; grounding/calming; when low mood needs support (soft EPDS pointer = "screening, discuss with clinician").
- **Reachable-but-hidden:** the full D1 week-by-week library and all lifespan content remain searchable — she is never boxed into "PE only."

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs (inputs):**
- **BP log** {systolic, diastolic, pulse, arm, timestamp, optional context flags: rested / after activity / clinic vs home}.
- **Symptom log** {headache, vision changes, upper-abdominal/rib pain, swelling, breathlessness, reduced movement, nausea, general unwell — timestamped}.
- **Medication log** {name, schedule, taken/missed} + **aspirin** flag.
- **Urine-dip result** (user-entered, e.g., protein +/++), **appointment/test results** (user notes).
- Weight, mood, fetal-movement notes (continuous with D1).

**Tools:**
- **BP trend chart** (values over time; **no zones/verdicts**), **PDF export**, medication reminders, appointment/monitoring scheduler, kick-count (from D1), home-BP technique guide.

**Mandatory compliance wording on the BP log (every relevant surface):**
- *"This is your personal record — Femio does not read or judge your blood pressure. Only your clinician can interpret your readings."*
- The chart shows her numbers **without** a normal/abnormal overlay. An **always-visible** static reference note: *"Clinicians treat 160/110 or above as urgent. If your reading is at or above this, or you have any warning sign, contact your maternity unit or emergency number now."* — this is **fixed education**, not a dynamic evaluation of her entry.

**Alerts / nudges (all opt-in, calm, revocable):**
- BP-check reminders (times she sets), medication/aspirin reminders, appointment/monitoring reminders, "log today's symptoms?" nudge.
- **No** alert is ever triggered by *interpreting* a value ("your BP is high" ← forbidden). Reminders are schedule-based only.

**Red-flag box pattern (reusable component — PE-tuned):**
> **⚠ Seek care now**
> Contact your maternity unit or local emergency number **immediately** if you have: a **severe headache that won't go away** · **changes in your vision** (blurring, spots, flashing) · **pain in your upper belly / under your right ribs** · **sudden swelling** of your face or hands · **trouble breathing** · your **baby moving less than usual** · a blood-pressure reading **at or above 160/110** · a **seizure** (call emergency services).
> *You know your body best — if something feels wrong, get it checked now. This app can't diagnose or treat.*
> [Call my maternity unit] [Emergency number] [Learn the warning signs]

**Placement:** persistent entry in nav; pinned on the D6 home; **auto-injected** at the bottom of every symptom explainer and **whenever a PE-warning-sign symptom is logged** (surfaced as guidance, never as "you have PE").

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1):**
- `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, units, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- Height; pre-pregnancy weight & BMI; menstrual/LMP history.
- Medical-history flags (**hypertension, renal, prior PE, diabetes, thyroid, VTE, high BMI, autoimmune**) — these **set the D6 high-risk flag**.
- Medications, allergies, supplements; prior pregnancies/outcomes (gravida/para, **prior PE/HELLP/preterm** flags); emergency/maternity contact.

**D1 pregnancy fields (inherited):** `edd`/`gestational_age` (single source of truth for gating), confirmed-pregnancy date, singleton/multiple, blood type/Rh, prenatal-visit log, weight-gain series, kick-count sessions.

**D6 persona-specific:**
- `bp_readings[]` {systolic, diastolic, pulse, arm, context_flag, timestamp} — **stored raw; never scored**.
- `pe_high_risk_flag` {bool, derived from history factors} and `pe_monitoring_status` {high-risk-watch / gestational-HTN / pre-eclampsia — **as recorded by user from clinician**, an attribute, not an app diagnosis}.
- `pe_symptom_log[]` {type, severity_note, timestamp}.
- `medications_active[]` {name, schedule, adherence[]} incl. `aspirin_prophylaxis` {flag, user-entered start}.
- `urine_protein_results[]` (user-entered), `plgf_or_bloods_results[]` (user notes), `growth_scan_notes[]`.
- `monitoring_schedule[]` {appointment type, date, cadence e.g. twice-weekly}, `bp_check_reminders[]`, `med_reminders[]`.
- `saved_maternity_unit`, `saved_emergency_contact`, `localized_emergency_number`.
- `fetal_movement_flag` (foregrounded), `postpartum_bp_monitoring[]` (the E4 tail).
- `log_export_history[]` (PDF bundles generated for clinician).

*Data-minimization: collect only what powers a used feature; all logs user-deletable; diagnosed-condition status is **special-category data** with tightened retention/consent (§K).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Entry (layered on D1 — additive emphasis, never restriction):**
- D6 is reached from **D1** when the user **records a clinician diagnosis** (gestational HTN / pre-eclampsia), **logs a raised BP / enters outpatient monitoring**, or **carries a high-risk history flag** (prior PE, chronic HTN, BMI ≥30, multiples, ≥40, first pregnancy + risk factor). See §J.
- Short, **editable/resettable** confirm step: *"Your clinician is monitoring your blood pressure this pregnancy — want Femio set up to help you log and stay aware? (You keep everything in your pregnancy tracker too.)"*

**Home configuration for D6 (safety-forward):**
- **Hero re-order:** BP-log quick-entry + last few readings (chart), the **"seek care now" pinned card**, today's medication/aspirin reminder, next monitoring appointment.
- **Secondary:** the calm PE-education hub; the inherited **D1 week-by-week card** stays present (she is still pregnant and wants it), just below the safety row.
- **Symptom quick-log** foregrounded; logging a warning-sign symptom surfaces the red-flag box.
- **Tone:** calm, validating, uncluttered; **no alarmist visuals**, no scary imagery.

**Hidden-but-reachable rule.** Nothing is locked. All D1 content/tools remain available and searchable. BP/medication tools are *surfaced* for D6 but reachable by anyone via the tools menu with an "usually used when a clinician is monitoring your BP" note. The high-risk flag **adds** emphasis; it never hides pregnancy content.

**Safety-forward defaults.** Red-flag layer is **always on** for D6 and cannot be buried; BP log **never** shows an interpretive overlay regardless of settings; reminders are calm and schedule-based only.

**Continuity.** History (prior PE, chronic HTN, BMI) auto-seeds the high-risk flag and D6 emphasis — no re-onboarding; a one-time "your history is here and private" note.

---

## J. Adaptation triggers (state transitions)

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Enters D6 from D1 — diagnosis recorded** | User records clinician dx of gestational HTN / pre-eclampsia | Additive: switch to D6 home emphasis; enable BP/med/monitoring tools; surface calm education + red-flag layer. **Never** self-generate the diagnosis. | **D6** (from D1) |
| **Enters D6 — high-risk / monitoring** | High-risk history flag, raised BP logged, or user notes outpatient monitoring | Offer D6 setup ("your clinician is watching your BP"); foreground BP log + warning signs; keep all D1 content. | **D6** (watch mode) |
| **Warning-sign symptom logged / severe reading entered** | User logs a PE red-flag symptom, or enters a reading ≥160/110 | **Surface the "seek care now" box + saved maternity/emergency contact** as *guidance/education* — **not** a diagnosis, **not** a triage decision, no "you have PE / go now" verdict. Log stays raw. | Emergency-escalation **messaging** (content, not clinical instruction) |
| **Overlap with chronic hypertension** | Pre-existing HTN flag + pregnancy | Blend **D5** (chronic HTN in pregnancy) emphasis with D6; unify BP/med tools; avoid double-counting. | **D5 ⊕ D6** blend |
| **Overlap with gestational diabetes / other** | GDM, thyroid, multiples, high BMI recorded | Additive blend with **D3 / D7 / D9 / D12** as relevant; D6 safety layer persists. | Blended emphasis |
| **Early / preterm delivery planned or occurs** | User records planned early birth or delivery | Calm prematurity/NICU content; transition on birth (below); **do not** frame as countdown. | Content + → E1/E4 |
| **Delivery / birth logged** | Birth recorded | Transition to **Postpartum (E1)**; **carry BP logging + red-flag layer forward** into **E4 ongoing-BP-follow-up** because **PE can onset or persist postpartum** (48h–6 wks); reminders to continue monitoring per her clinician. | **E1 + E4** |
| **Postpartum-onset PE signs** | Postpartum user logs headache / raised BP / warning sign within ~6 wks of birth | Red-flag "seek care now" box (postpartum-tuned); keep BP log live; "PE can start after birth — this is worth getting checked now." No diagnosis. | **E4** emergency messaging |
| **Pregnancy loss / stillbirth logged** | User reports loss | Immediate dignified transition to **loss/grief (E6)**; **instantly suppress** all BP/med/appointment/milestone reminders; grief resources; no re-prompting. | **E6** |
| **Withdraw / step back** | User exits monitoring mode | Pause nudges; retain data per privacy settings; nothing forced. | Retain, low-touch |

*All routes preserve one-account data continuity and always end with clinician-referral language, never a diagnosis. Emergency escalation is **messaging/education that routes her to real care** — Femio never itself triages, calls, or decides.*

---

## K. Compliance flags

1. **No diagnosis / triage / interpretation (highest-priority guardrail).** Femio **never** classifies a BP reading or symptom, never says "normal/high/dangerous," never says "you have / likely have pre-eclampsia," never says "go to hospital / stay home." Thresholds (140/90, 160/110) appear only as **fixed educational reference**; the red-flag layer **routes her to care** without deciding *for* her. This keeps Femio out of the **medical-device + diagnosis** lane that clinician-connected tools (e.g., HaMpton) legitimately occupy. **[NEEDS SOURCE — confirm current medical-device software / app-store medical-claims wording at ship.]**
2. **No prescribing / no dosing.** Medication and aspirin content is **general and cited**; all dosing, choice, starting, stopping, and changes defer to the clinician. **No** dosing calculator. Aspirin content is context ("some higher-risk people are advised…"), never an instruction to take it.
3. **Emergency-territory framing.** PE red-flag symptoms (severe headache, vision changes, upper-abdominal pain, sudden swelling, reduced movement, ≥160/110, seizure) get **prominent, calm "seek care now"** framing with the user's maternity/emergency contact — **never** false reassurance ("that's normal"), **never** alarmist doom, **never** a diagnosis.
4. **Screeners = "screening, discuss with clinician."** PLGF, urine protein, risk-factor checklists, EPDS — all framed as screening/context, never verdicts.
5. **Emotional safety.** This persona is high-anxiety by definition; tone must be **validating and calming**, no scare-content, no alarmist imagery, no anxiety-driving nudges. [Frontiers 2025 on PE-risk anxiety burden]
6. **Privacy-by-design (GDPR/PDPL — special-category health data).** A **diagnosed condition + pregnancy** is highly sensitive. **No data sale, no ad-targeting SDKs, no employer/insurer visibility** (explicit contrast with employer-channel apps). Explicit, granular, revocable consent; strong retention limits; user-deletion of BP/symptom/med logs; partner sharing opt-in and scope-limited.
7. **Reminder suppression on loss / early exit.** BP/med/appointment/milestone reminders must **instantly stop** on logged loss or withdrawal (fixing the competitor failure of stale reminders after a loss).
8. **Postpartum continuity is a safety feature.** Because PE can onset/persist postpartum, BP logging + red-flag layer **must persist into E4**; dropping them at birth would be a safety gap.
9. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIH/CDC/NHS/MedlinePlus) + Tier-2 (ACOG/RCOG/NICE/Preeclampsia Foundation), grade 6–8, localized in 4 languages with **human-reviewed** RTL parity (clinical stakes forbid machine-only translation of safety copy).
10. **Open items:** resolve **[NEEDS SOURCE]** — ACOG Practice Bulletin 222 permalink; Preeclampsia Foundation signs-&-symptoms permalink; AHA/BIHS home-BP-technique permalink; **localize emergency numbers and MENA-specific PE guidance** before content freeze.

---

## Sources

**Tier-1 (NIH / CDC / NHS / MedlinePlus):**
- [MedlinePlus — High Blood Pressure in Pregnancy / Preeclampsia](https://medlineplus.gov/highbloodpressureinpregnancy.html) · [MedlinePlus — Preeclampsia (Encyclopedia)](https://medlineplus.gov/ency/article/000898.htm) · [MedlinePlus — Eclampsia](https://medlineplus.gov/ency/article/000899.htm)
- [CDC — Urgent Maternal Warning Signs & Symptoms (HEAR HER)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html) · [CDC — Recognizing Urgent Pregnancy-Related Warning Signs (HEAR HER)](https://www.cdc.gov/hearher/news-media/article-urgent-warning-signs.html)
- [StatPearls (NCBI) — Preeclampsia](https://www.ncbi.nlm.nih.gov/books/NBK570611/) · [NCBI Bookshelf — Hypertension in Pregnancy: Diagnosis and Management (NICE NG133 full text)](https://www.ncbi.nlm.nih.gov/books/NBK546004/)
- [PMC — Postpartum preeclampsia/eclampsia: defining its place and management (AJOG)](https://www.ajog.org/article/S0002-9378(20)31201-1/fulltext) · [PMC — Late-Onset Postpartum Eclampsia case](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2925215/)
- [PMC — Home blood pressure monitoring in pregnancy: systematic review & meta-analysis](https://pmc.ncbi.nlm.nih.gov/articles/PMC8248564/) · [PMC — Self-monitoring of BP among women with hypertensive disorders of pregnancy: systematic review](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9152837/) · [PMC — BP self-monitoring in pregnancy: feasibility cohort](https://pmc.ncbi.nlm.nih.gov/articles/PMC5745883/)
- [Frontiers in Psychology (2025) — Pregnancy stress, anxiety, depression & self-management in women at high risk of preeclampsia](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2025.1537858/full)

**Tier-2 (ACOG / RCOG / NICE / Preeclampsia Foundation):**
- [ACOG — Preeclampsia and High Blood Pressure During Pregnancy (FAQ)](https://www.acog.org/womens-health/faqs/preeclampsia-and-high-blood-pressure-during-pregnancy)
- [ACOG / SMFM — Low-Dose Aspirin Use for the Prevention of Preeclampsia (Practice Advisory, 2021)](https://www.acog.org/clinical/clinical-guidance/practice-advisory/articles/2021/12/low-dose-aspirin-use-for-the-prevention-of-preeclampsia-and-related-morbidity-and-mortality) · [ACOG — Low-Dose Aspirin Use During Pregnancy (Committee Opinion)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/07/low-dose-aspirin-use-during-pregnancy)
- [NICE NG133 — Hypertension in pregnancy: diagnosis and management (Overview)](https://www.nice.org.uk/guidance/ng133) · [NICE DG49 — PLGF-based testing to help diagnose suspected pre-eclampsia](https://www.nice.org.uk/guidance/dg49/chapter/2-The-diagnostic-tests)
- [Preeclampsia Foundation — Signs and Symptoms](https://www.preeclampsia.org/signs-and-symptoms) · [Preeclampsia Foundation — FAQs](https://www.preeclampsia.org/faqs) · [Preeclampsia Foundation — Postpartum Preeclampsia](https://www.preeclampsia.org/postpartum-preeclampsia)
- [The ObG Project — Diagnosing Preeclampsia: Key Definitions & ACOG Guidelines](https://www.obgproject.com/2017/01/08/diagnosing-preeclampsia-key-definitions/)

**Competitor / market (BP-app & privacy landscape):**
- [HaMpton — App helps reduce hypertension-monitoring appointments in pregnancy by 53% (HSJ case study)](https://solutions.hsj.co.uk/story.aspx?storyCode=7019192) · [Mother&Baby — HaMpton home-BP app for pregnancy](https://www.motherandbaby.com/pregnancy/health-and-wellness/finally-there-s-an-app-that-helps-pregnant-women-monitor-their-blood-pressure/) · [CQC — Home monitoring of hypertension in pregnancy](https://www.cqc.org.uk/publications/themes-care/home-monitoring-hypertension-pregnancy)
- [JMIR Human Factors (2026) — Smartphone app to monitor BP in normotensive, high-risk & preeclampsia pregnancies (feasibility)](https://humanfactors.jmir.org/2026/1/e70370)
- [Consumer Reports — Best Pregnancy Tracking Apps (privacy analysis)](https://www.consumerreports.org/health/pregnancy-childbirth/best-pregnancy-tracking-apps-a8731130463/) · [Flo (app) — FTC settlement & Anonymous Mode (Wikipedia)](https://en.wikipedia.org/wiki/Flo_(app))

**Consumer clinical references (Tier-2/3, for tone/plain-language cross-check):**
- [Mayo Clinic — Preeclampsia](https://www.mayoclinic.org/diseases-conditions/preeclampsia/symptoms-causes/syc-20355745) · [Mayo Clinic — Postpartum Preeclampsia](https://www.mayoclinic.org/diseases-conditions/postpartum-preeclampsia/symptoms-causes/syc-20376646) · [Cleveland Clinic — Preeclampsia](https://my.clevelandclinic.org/health/diseases/17952-preeclampsia) · [Cleveland Clinic — Postpartum Preeclampsia](https://my.clevelandclinic.org/health/diseases/17733-postpartum-preeclampsia)

*Community insight (r/preeclampsia, r/BabyBumps, Preeclampsia Foundation forums/FAQs, HELLP-survivor communities, pregnancy/BP-app reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes.*

*[NEEDS SOURCE]* to resolve before content freeze: **ACOG Practice Bulletin 222 (Gestational Hypertension & Preeclampsia)** exact permalink; **AHA / British & Irish Hypertension Society** home-BP-measurement-technique permalink; **USPSTF** aspirin-for-preeclampsia recommendation primary permalink; region-localized emergency numbers + MENA-specific PE/eclampsia guidance for the AR-first build.
