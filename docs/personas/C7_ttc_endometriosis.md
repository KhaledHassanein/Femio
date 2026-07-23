# C7 — TTC with Endometriosis (Chronic Pelvic Pain + Fertility Impact, Long Diagnostic-Delay History)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window features support **conception awareness**, and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, or prevents disease. Screeners are framed as *"screening — discuss results with a clinician."* Endometriosis is a **clinician-diagnosed condition** — Femio never confirms, stages, or manages it; it educates, helps her track, and helps her prepare for clinician conversations.
> Persona code: **C7** · Cohort: Conception (C) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (seven invariants, state object, constant core, universal events §6, Z1 fallback, blending rules) · Last research pass: 2026-07-17

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Salma," 33 |
| **Age band** | ~28–38 (often already at/near the ACOG/NICE 35 threshold because diagnosis took years — the delay itself compresses her fertile runway) |
| **Stage** | Actively TTC with a **clinician-confirmed endometriosis diagnosis** (often after laparoscopy). Chronic pelvic pain is a daily companion, not a monthly event. May be pre-surgery, post-laparoscopy, or weighing surgery/ART. |
| **Relationship** | Partnered; partner has often witnessed years of pain and dismissal, may be protective/anxious; dyspareunia complicates timed intercourse and the couple's intimacy. |
| **Goal (top JTBD)** | *"Help me understand how endo actually affects my chances, track pain AND fertility in one place without them fighting each other, and prepare for the surgery-vs-IVF conversations — and please, finally, take my pain seriously."* |
| **Health literacy** | High and hard-won. Years of self-advocacy made her an expert patient. She knows the vocabulary (laparoscopy, endometrioma, AMH, EFI) and distrusts oversimplification. |
| **Tech context** | Web-first; likely already stacking a period tracker + a pain/symptom app + a fertility charting app. Frustrated that none hold the whole picture. |
| **Locale** | Arabic-first / RTL a first-class case; also EN/FR/ES. In AR/MENA markets, chronic pelvic pain + fertility difficulty carry heavy stigma and silence — validation and privacy matter even more. |
| **Emotional state** | **Validation-hungry after years of dismissal**; a mix of grief (lost time, lost trust in medicine), determination, anxiety, and fear that endo "stole" her fertility. Pain and TTC anxiety compound each other. |
| **What she is NOT** | Not undiagnosed (that's a screener/routing case, not C7). Not someone who wants her pain minimized as "just cramps." Not seeking Femio to treat endo — she has (or is seeking) a clinician for that. |
| **Primary devices for signals** | BBT thermometer, OPK/LH strips, self-observed CM — **plus** a pain/flare diary, medication/hormonal-history log, and surgical/imaging records she carries between clinicians. |
| **Success = leaves us because…** | She conceived (→ Pregnancy mode, **endo modifier retained** — pain often persists in pregnancy and postpartum), OR she moved into ART with us alongside her (→ C10, endo-aware), OR she found in Femio the first tool that believed her and held her whole story. |

**Persona thesis.** C7 sits at the intersection of a **chronic-pain persona** and a **conception persona**, and no competitor serves both halves in one account. Her defining wound is **years of dismissal** (avg 6.6–9.6 years to diagnosis; see §D) — so the single most valuable thing Femio can do is **believe her, hold the whole longitudinal record, and never make her re-justify her pain.** Get the validation tone, the pain-vs-fertile-window dual tracking, and the surgery/ART decision-prep right, and C7 becomes the emotional flagship of the conception cohort. Treat her like C1 (generic optimistic TTC) and she churns instantly — cheerful "just relax, it'll happen!" framing is a re-traumatizing trust-breaker for this persona.

---

## B. Needs & questions (voice-of-user)

Mined from r/endometriosis, r/Endo, r/TryingForABaby, endo+TTC forums, and app-store reviews of Flo/Ovia/Phendo. Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD (endo + TTC):**
1. *"How does endometriosis actually lower my chances — is it the inflammation, the adhesions, my egg reserve, or all of it?"* (mechanism literacy — she wants the real model, §D)
2. *"Does my stage / my endometrioma / my past surgery change what I should do next?"*
3. *"Should I try naturally longer, have surgery, or go straight to IVF — and how do I decide?"* (the surgery-vs-ART timing question)
4. *"My fertile window is exactly when I hurt the most — how do I time intercourse when sex is painful?"* (dyspareunia vs timed-sex collision)
5. *"Is this pain a flare, ovulation pain, or something new I should get checked?"* (pain-signal disambiguation)
6. *"Did my laparoscopy actually help my fertility, and for how long?"* (post-op window anxiety)
7. *"My AMH is low / they mentioned my ovarian reserve — how worried should I be?"*
8. *"Will endo make IVF less likely to work for me?"*
9. *"I've been dismissed for years — how do I get a clinician to take my fertility seriously now?"* (advocacy + eval-prep)
10. *"Will the pain get better or worse if I get pregnant? Will it come back after?"* (continuity fear)

**Emotional arc — design must respect this:**
- **Baseline:** chronic pain as a constant substrate; fatigue; hypervigilance to her body; a deep reservoir of medical mistrust from years of being disbelieved.
- **Fertile window:** urgency + **dread** — the window she must "hit" often coincides with pain flares and painful intercourse; performance pressure is compounded by physical pain.
- **Two-week wait:** the usual TWW anxiety, *plus* difficulty distinguishing endo pain / flare symptoms from possible early-pregnancy signs (heightened symptom-spotting confusion).
- **Decision points:** surgery? repeat surgery? IVF? — high-stakes, high-information, high-anxiety forks where she desperately wants an organized, unbiased way to weigh options with her clinician.
- **Cycle end:** negative → grief layered on top of chronic grief ("endo took this from me too"); positive → joy braided with fear about pain in pregnancy.

**Anti-needs / trust-breakers (what makes her churn):**
- **Any minimization of pain** ("it's just cramps," "have you tried relaxing?") — the single fastest churn driver; it re-enacts the dismissal she's fleeing.
- Toxic positivity ("just relax and it'll happen!") — community consensus is that this phrase is uniquely enraging for endo patients.
- Being handled as generic C1 optimistic-TTC, with no acknowledgment of her condition or history.
- An app that forces her to choose "period tracking OR pregnancy OR pain" and loses the others (a specific, repeated Flo complaint).
- **Pain tracking too shallow** to be meaningful (Flo's ~4-option pain field is a named grievance — endo pain needs location, type, severity, triggers, not a single tap).
- Any implication Femio can diagnose, stage, or "manage" her endo — she needs a partner tool, not a fake doctor.
- Privacy creep with reproductive + chronic-illness data (doubly sensitive; see §C, §K).

**Feature requests recurring in reviews/forums:**
- Deep, structured **pain/flare tracking** (location map, type, severity, triggers, meds taken) that lives *alongside* fertility charting, not in a separate app.
- One record that carries **surgical history, imaging, hormonal-treatment history, AMH/labs** between clinicians (she is tired of re-explaining).
- Honest, endo-specific fertility education — not generic TTC content that ignores her condition.
- **Decision-prep tools** for the surgery-vs-ART conversation (organized questions, her own data exported).
- Validation and community that "gets it" (Phendo's research-community ethos is valued; generic trackers feel hollow).
- A way to log pain *and* fertile-window signals without the two "fighting" for the same day's attention.

---

## C. Competitor teardown

Feature-by-feature. **Key insight for Femio:** the market is split into two non-overlapping camps — **fertility/TTC apps** (Flo, Ovia, Premom, Fertility Friend) that treat endo as at most a symptom checkbox, and **endo/chronic-pain apps** (Phendo) that deeply track pain + symptoms but do **nothing** for conception. **No one holds both halves in one lifespan account.** C7 today typically stacks a fertility charting app + a pain app + a notes file for her surgical/lab history — exactly the fragmentation Femio's one-account model dissolves.

| App | Endo pain/flare depth | Fertility/TTC depth | Surgical/lab history | Endo-specific fertility content | Decision-prep (surgery/ART) | Notable privacy / positioning |
|---|---|---|---|---|---|---|
| **Phendo** (Citizen Endo / Columbia) | **Best-in-class** — daily structured tracking of symptoms, pain, bleeding, GI, mood, treatments; 21k+ users; data behind 11 published papers | **None** — not a conception tool at all; no fertile-window/BBT/OPK | Partial (treatments tried) | Educational-research, not TTC-directed | No | Research-consent model; patient-driven; strong community trust but purely observational/academic. |
| **Flo** | **Shallow** — named grievance: pain field ~4 options, "not nuanced enough" for endo; forces period-OR-pregnancy mode; has an endo *symptom checker* (screening) | Cycle/statistical fertile window; light TTC | No | Endo explainer + 5-min self-assessment (routes to doctor) | No | FTC 2021 settlement (data to Facebook/Google); added Anonymous Mode. Reach without depth. |
| **Ovia Fertility** | Moderate symptom logging; has endo/painful-sex education | Data-rich TTC (weight, sleep, stress) | No | Some endo + dyspareunia guides | No | Employer/health-plan B2B2C channel; generous free tier. |
| **Premom** | Shallow | **Best-in-class OPK** photo-reading | No | No | No | FTC 2023 settlement (fertility data to analytics). |
| **Fertility Friend** | Shallow (custom symptoms) | **Best-in-class BBT/FAM** charting | Export only | No | No | Power-user charting gold standard; dated UX; single-purpose. |
| **Clue** | Moderate — has an endo-symptom-tracking guide, more granular pain options than Flo | Light TTC | No | Endo tracking article | No | Strong, well-regarded privacy posture (EU/GDPR). |

**Fragmentation map (the opening for Femio):**
- **Pain depth** lives in Phendo (and partly Clue) — but with **zero** conception support and no fertile-window signals.
- **Fertility depth** lives in Fertility Friend / Premom / Ovia — but they treat endo as a checkbox and ignore chronic pain, dyspareunia, and surgical history.
- **Endo-specific fertility education + surgery/ART decision-prep + a record that carries surgical/imaging/lab history between clinicians:** essentially **nobody** does this for the TTC patient.
- **Nobody** combines: deep pain/flare tracking **+** honest endo-aware fertile-window signals **+** longitudinal surgical/lab record **+** decision-prep for surgery-vs-ART **+** trustworthy privacy **+** Arabic-first RTL **+** one account that keeps *all* women's-health knowledge (including pregnancy, postpartum, perimenopause — where endo persists) reachable. **That whole-picture, whole-lifespan gap is C7's Femio thesis.**

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio does **not** diagnose, stage, treat, or prevent endometriosis or infertility. Under **NICE NG73 (updated 2024)**, ultrasound, referral when indicated, and initial treatment can proceed in parallel. A normal examination or ultrasound does not exclude endometriosis, and laparoscopy may still be considered. Femio never treats imaging, pain, or a cycle pattern as a diagnosis. [NICE NG73, recommendations 1.5.1–1.5.11]

**The diagnostic-delay reality (the emotional core — cite carefully):**
- Endometriosis diagnostic delay averages roughly **6.6 years** across studies (range ~1.5–11.3 y); some cohorts report **~8 years (UK)** and up to **~9.6 years** total. The delay splits into a care-seeking component (~3.7 y from symptom onset to first presentation) and a **healthcare-related component (~5.8 y from first presentation to diagnosis)**. [medRxiv scoping review; BJOG 2024; NZ studies] — *Femio uses this to validate, never to alarm.*
- **Dismissal** is near-universal in patient accounts and materially worsens delay (patients who reported no dismissal had ~4.6 y delay vs ~9.0 y for those who did). Post-diagnosis, the dominant emotions are **relief (~86%)**, feeling overwhelmed (~54%), and anger (~32%). [BJOG 2024; NZ dismissal study] — *This is the evidence base for C7's validation-first tone.*

**How endometriosis can affect fertility (mechanism literacy — in scope as education):**
- Endometriosis can reduce fertility through **multiple, overlapping pathways**: pelvic **adhesions and anatomical distortion** (impairing egg release, tubal ovum pick-up/transport, and sperm access); a **pro-inflammatory peritoneal environment** (cytokines, oxidative stress) that can impair gametes, embryos, and endometrial receptivity; **endometriomas** and disrupted ovarian function; and **reduced ovarian reserve** (lower AMH/AFC) in many patients, with or without prior surgery. [ESHRE 2022 guideline; PMC inflammatory-mechanisms review; Frontiers 2022] — *Femio frames this as "here's why it can be harder," never as "you are infertile."*
- Endometriosis can be associated with difficulty becoming pregnant, but a diagnosis does not establish that an individual is infertile or predict whether natural conception will occur. Femio does not publish stage-specific natural-conception probabilities or a personal prognosis. [NICE NG73; ESHRE 2022]

**Pain, dyspareunia & timed intercourse (in scope — awareness + coping education):**
- Endometriosis commonly causes **dyspareunia (painful sex)**, which can itself reduce conception chances when pain leads to avoiding intercourse — independent of any biological fertility effect. [NICE NG73; ESSI/patient guides; Genesis Fertility] — *Femio's fertile-window UX must acknowledge this collision and offer non-judgmental coping/education, never pressure.*
- Pain may be logged alongside an estimated fertile window to help describe timing to a clinician, but the pain is nonspecific: Femio must not label it as ovulation, an endometriosis flare, or proof of any diagnosis. NICE supports using a pain and symptom diary to aid discussions. [NICE NG73 recommendation 1.3.3]

**Management options & when ART is advised (Tier-2 guideline grounding — educational routing, never a plan):**
- **NICE NG73 (updated 2024):** Do **not** offer hormonal treatment (alone or with surgery) to those trying to conceive, because it does **not** improve spontaneous pregnancy rates. Ask about the person's **pain-vs-fertility priorities** to guide surgical decisions. [NICE NG73]
- **ESHRE 2022 (endometriosis-associated infertility):** surgery and/or medically assisted reproduction (MAR) are both feasible; **ovarian suppression should not be used to improve fertility**; **routine cystectomy of endometriomas before IVF is not recommended** (no proven live-birth benefit, and cystectomy can **reduce ovarian reserve**). Surgery is considered case-by-case (e.g., pain, suspected malignancy, large cyst obstructing retrieval). [ESHRE 2022; multi-guideline review PMC8628449]
- **IUI with ovarian stimulation** is recommended over expectant management for rASRM stage I/II (and suggested for stage III/IV with tubal patency, limited evidence). [ESHRE 2022]
- **Clinician decision tools and assisted reproduction:** surgical findings, symptoms, ovarian reserve, age, other fertility factors, and the person’s preferences can inform clinician decision-making. Femio may explain that clinicians use multiple factors but does not compute EFI, publish EFI probability tables, quote a universal post-operative window or IVF live-birth percentage, or recommend surgery versus assisted reproduction. [NICE NG73; ESHRE 2022]

**WHEN to seek/expedite evaluation (the routing rule — critical for §J):**
- Known endometriosis is an explicit reason to seek fertility evaluation **sooner, regardless of the 12-month rule**; combined with age ≥35 (common for C7 due to diagnostic delay), the threshold is effectively **now / 6 months**. [ASRM; ACOG; NHS] — *Femio applies this as educational routing that always ends "discuss with your clinician," never as a diagnosis.*

Medical-review resolution: diagnostic-pathway, symptom-diary, fertility, and decision-support wording follows [`ENDOMETRIOSIS_CONTENT_SAFETY.md`](../compliance/ENDOMETRIOSIS_CONTENT_SAFETY.md). Stage-specific conception probabilities, EFI tables, a universal post-operative window, and IVF live-birth percentages were removed. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

Inherits all C1 TTC fertility tooling (fertile-window, BBT, OPK, CM, TWW, partner mode); C7 **adds the pain/chronic-illness and decision-prep layers** that make it endo-specific.

**P0 — Must-have (defines the persona; ship first):**
1. **Deep pain / flare tracker** — location map (pelvic, bowel, bladder, back, leg), pain **type** (cramping/stabbing/burning), **severity** (0–10), triggers, meds/relief taken, dyspareunia + dyschezia/dysuria flags, functional impact (missed work/activity). Structured far beyond Flo's ~4 options; Phendo-grade, but joined to fertility.
2. **Dual pain-vs-fertile-window view** — one timeline that overlays pain/flares with the fertile window, so she sees (and can discuss) how they collide, *without* the two "fighting" for the day. Fertile-window UX explicitly acknowledges dyspareunia and offers gentle, non-pressuring coping/education (never "you must have sex today").
3. **Longitudinal endo record** — surgical history (laparoscopy dates, findings, stage if known), imaging, **hormonal-treatment history**, AMH/other labs (entry-only, no interpretation), that she can **export/carry between clinicians**. Solves the "I'm tired of re-explaining" grievance.
4. **Endo-aware fertile-window predictor** — inherits C1's uncertainty-honest window; tone and content acknowledge that endo can affect conception and that pain may accompany the window. No false precision, no minimization.
5. **Validation-first tone engine** — content and nudges that explicitly affirm her pain and her years of being unheard; **hard bans** on "just relax," "just cramps," and toxic positivity for this persona (§K).
6. **Surgery-vs-ART decision-prep toolkit** — a neutral, cited explainer of the options (expectant/natural, surgery, IUI+stimulation, IVF), what EFI is, what ovarian reserve means, and a **question builder** she takes to her clinician, pre-filled from her own logged data. Educational only — never a recommendation.
7. **TWW pain-vs-symptom disambiguation help** — gentle content helping her hold the confusion between flare symptoms and possible early-pregnancy signs, without claiming to tell them apart.

**P1 — Strong differentiators (fast follow):**
8. **Clinician-visit prep + eval-expedite content** — advocacy scripts ("known endometriosis is a reason to be evaluated now") + chart/pain-diary export as PDF for the appointment.
9. **Post-laparoscopy fertility support** — clinician-directed recovery and fertility education, with no universal conception window, probability table, or countdown.
10. **Cross-cycle pattern insights** — pain patterns vs cycle phase, luteal length, ovulation confirmation — calm, non-alarmist, non-diagnostic.
11. **Partner mode (endo-aware)** — partner sees the window + a **pain/energy status** she chooses to share, reframing "today is a good day" around how she actually feels; consent-gated, revocable. Helps a partner who has watched years of pain support without pressure.
12. **Wearable / device import** — Apple Health, temp-capable wearables, OPK strips.

**P2 — Nice-to-have / later:**
13. Moderated endo+TTC community / Q&A (privacy-safe; Phendo-style "you're believed here" ethos).
14. Fully custom trackable symptoms (Read-Your-Body-style flexibility for atypical endo presentations).
15. Localized coaching content by market (AR modesty- and stigma-aware framing for chronic pelvic pain + fertility).
16. Fertility-preservation education module (for the "before endometrioma surgery" conversation).

**Explicitly OUT of scope for C7 (guardrail):**
- Diagnosing, **staging**, or "managing" endometriosis; computing an EFI or rASRM stage; interpreting AMH/labs. Femio educates and organizes — the clinician diagnoses and manages.
- Any "safe days / avoid pregnancy / contraception" framing. **Never.**
- Recommending surgery vs IVF, or any treatment/dose. Decision-prep presents options + questions; it never advises.

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries source citations and "not medical advice / discuss with your clinician." Tone across all C7 content is **validating** (see §K).

- **"You were not imagining it"** — the diagnostic-delay reality (avg years, dismissal is common, relief is the most common feeling at diagnosis). Validation content, cited, non-alarming.
- **How endometriosis can affect fertility** — the honest mechanism model: adhesions/anatomy, inflammation, endometriomas, ovarian reserve — *and* that many people still conceive. Holds impact + hope together.
- **Endometriosis & painful sex while TTC** — dyspareunia + timed intercourse, coping and comfort education, when to raise it with a clinician; explicitly non-pressuring.
- **Your options, explained** — expectant/natural vs surgery vs IUI+stimulation vs IVF, in plain language; what NICE/ESHRE say about hormonal treatment (doesn't improve spontaneous pregnancy) and routine endometrioma surgery before IVF.
- **What is the EFI?** — what the Endometriosis Fertility Index means and why a clinician might use it; that Femio does not compute it.
- **Ovarian reserve & AMH, plainly** — what these are, why endo can affect them, why numbers alone don't decide anything.
- **After laparoscopy** — what surgery can and can't do for fertility; the ~12-month post-op window as *information*, not a deadline.
- **Endometriosis and IVF** — what the evidence describes (variable, often quantity-of-eggs effect), always ending "discuss with your specialist."
- **Preparing for the appointment** — advocacy scripts, questions to ask, using your exported pain diary + chart.
- **Pain vs early-pregnancy signs** — holding the TWW confusion without false certainty.
- **The two-week wait, with chronic pain** — coping when your body always hurts and you're also symptom-spotting.
- **Reachable-but-hidden library:** full-lifespan content — including **endometriosis in pregnancy and postpartum** (pain often persists), perimenopause, and general gynae — stays searchable so C7 never feels boxed into "endo+TTC only."

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception; education, not diagnosis)

**Logs (inputs):**
- **Pain/flare:** location, type, severity (0–10), triggers, meds/relief, dyspareunia/dyschezia/dysuria flags, functional impact.
- **Fertility (inherited):** BBT (°C/°F, time, quality flags), OPK/LH result + photo, CM type, intercourse, period flow, HPT results.
- **Endo record:** surgeries (date/type/findings/stage-if-known), imaging, hormonal-treatment history, AMH/labs (entry-only), appointments.
- Mood/symptoms, meds/supplements, weight/sleep (optional).

**Tools:**
- Fertile-window estimator (range + confidence), coverline/thermal-shift detector, LH plotter, DPO/TWW counter.
- **Pain-vs-window overlay timeline**, cross-cycle pain-pattern view.
- **Endo-record + chart export (PDF/image)** for clinicians.
- **Surgery-vs-ART decision-prep / question builder** (educational).

**Alerts / nudges (all opt-in, tone-calibrated, revocable, validation-first):**
- "Your fertile window is *likely* opening — here's some gentle guidance for timing when pain is a factor." (acknowledges dyspareunia; never pressures)
- "Time to log today's pain / OPK / temperature."
- "Thermal shift detected — ovulation likely occurred." (retrospective, honest)
- Partner nudge (consent-gated): reframed around her shared pain/energy status, not just "a good day."
- Eval-prep: "Known endometriosis can be a reason to talk to a clinician about fertility sooner — here's how to prepare." (routing, not diagnosis)
- **No** streak/celebration pressure on pain logs; **no** "late" counter; **no** minimizing language ever.

**Mandatory compliance wording on every relevant surface:**
- *"Predictions are estimates based on your data — not a guarantee, and **not a method of birth control**."*
- No "safe day," "infertile day," or pregnancy-avoidance language — **ever**.
- Screener/decision-prep outputs: *"This is educational, not a diagnosis or a treatment plan. Please discuss with your clinician."*
- Pain and endo content: *"Femio helps you track and prepare — it does not diagnose, stage, or manage endometriosis."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared — the one-account spine):** `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, consent flags, account mode · `cycle{period_start/end, cycle_length_history[], flow[]}` · `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (non-diagnostic) · `content_history[]`, `screener_results[]` (timestamped, non-diagnostic).

**C7 persona-specific (adds the TTC (C) layer + infertility (C2/C4/C5) evaluation layer + a chronic-condition endo sub-layer):**
- **Inherited TTC (C1) fields:** `ttc_start_date`, `bbt_readings[]`, `opk_results[]`, `cm_log[]`, `intercourse_log[]`, `ovulation_confirmed[]`, `luteal_phase_length[]`, `dpo_current`, `hpt_results[]`, `predicted_window[]{start,end,confidence}`, `partner_link_id`/`partner_scope`/`partner_consent_ts`, `preconception_checklist_state`.
- **Endo condition sub-layer:**
  - `endo_diagnosis` {confirmed_by_clinician:bool, method (e.g. laparoscopy/imaging/clinical), date, stage_if_known} — **entry-only, never Femio-derived**.
  - `pain_log[]` {timestamp, location[], type, severity_0_10, triggers[], meds_taken, dyspareunia:bool, dyschezia:bool, dysuria:bool, functional_impact}.
  - `surgeries[]` {date, type (e.g. laparoscopy), findings_note, stage_if_known}.
  - `imaging_results[]` {date, type, note} (entry-only).
  - `hormonal_treatment_history[]` {agent, start, end, note} (educational context only).
  - `labs[]` {name (e.g. AMH), value, unit, date} — **entry-only, no interpretation**.
  - `appointments[]`, `eval_prep_state`, `decision_prep_notes`.
  - `efi_note` — free-text of a clinician-provided EFI *if she chooses to record it*; **Femio never computes it**.
- **Modifier flags:** `modifiers=[endometriosis]`; optional stacks (`chronic_pelvic_pain`, `low_ovarian_reserve` self-report, `post_laparoscopy`).

*Data-minimization: collect only what powers a used feature; surgical/imaging/lab entries and photos stored with strict retention + user-deletable. Chronic-illness + reproductive data is doubly sensitive — see §K.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C7):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "Any of these apply?" → **known condition → endometriosis** selected → sets `modifiers=[endometriosis]`, routes to C7 (not C1).
3. "Has a clinician diagnosed it? How was it confirmed?" → sets `endo_diagnosis` (clinical/imaging/laparoscopy); **if not clinician-diagnosed, this is a screener/routing case, not C7** — soft-route to endo education + "discuss with a clinician," never self-label.
4. "Have you had surgery for it (e.g. laparoscopy)?" → seeds `surgeries[]`, unlocks post-op window content.
5. Age capture → because C7 skews ≥35 via diagnostic delay, defaults to the **6-month / evaluate-sooner** routing tone.
6. "How long have you been trying?" → `ttc_start_date`.
7. "What do you want to track?" (pain/flare, BBT, OPK, CM, minimal) → **pain tracker on by default for C7**; others reachable via "Add tracking."
8. "Involve a partner?" → endo-aware partner setup or defer.
9. Consent & privacy (chronic-illness + reproductive data double-consent).

**Home config for C7:**
- Hero = **endo-aware fertile-window card (with confidence)** with an at-a-glance **pain/energy strip** beside it (the dual view, not two competing heroes).
- Quick-log row = pain/flare + her chosen fertility trackers.
- Secondary = decision-prep card (surgery/ART) when relevant; post-op window content if applicable; TWW/DPO card post-ovulation; latest validating content module.
- **Hidden-but-reachable:** full lifespan library — endo-in-pregnancy/postpartum, perimenopause, contraception *education*, other conditions — one search/tap away.

**Adaptive tone:** **validation-first at all times.** Early cycles = affirming + informative; as cycles accumulate or at decision forks, tone shifts to *organizing + empowering* (here's how to prepare, here are your questions) — never alarmist, never toxic-positive, never minimizing pain.

---

## J. Adaptation triggers (state transitions)

Inherits the **universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive test, pregnancy loss, mood-screen high/crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). C7 adds/`specializes` the transitions below. **Cross-cutting C7 rule: the `endometriosis` modifier and its pain/surgical/lab record persist across every state — it is never dropped on transition (endo pain commonly continues through pregnancy, postpartum, and into perimenopause).**

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Positive pregnancy test** | `hpt_results` = positive (or user confirms) | Fire universal positive-test handler (celebrate, tone-matched; suppress fertile-window/OPK/TWW; carry all data; re-confirm privacy). **Retain endo modifier + pain tracker** — surface "endometriosis in pregnancy" content (pain may persist/change). | **Pregnancy mode + endometriosis modifier** (pain-tracking continuity preserved) |
| **Starts IUI / IVF** | user reports entering ART | Offer switch to **C10 (ART/IVF)**, endo-aware; carry endo record, labs, pain log; add ART cycle tracking; retain validation tone. | **C10**, `modifiers=[endometriosis]` |
| **Weighing surgery vs ART** | user opens decision-prep / logs a consult | Surface neutral cited options explainer + EFI/ovarian-reserve education + question builder + data export. **Educational only — never a recommendation.** | Stay C7; decision-prep + clinician referral |
| **12 mo (<35) / 6 mo (≥35) / known-endo → evaluate now** | routing clock or endo flag | Calm, non-diagnostic: "Known endometriosis can be a reason to be evaluated sooner." Offer eval-prep + export. **Never auto-label "infertile."** | Evaluation prep → C10/clinician; endo-fertility content |
| **New/worsening or atypical pain** | pain log severity spike / new location | Non-diagnostic "this is worth raising with your clinician" + surface red-flag education box (universal handler); log stays raw. **Never** interpret pain as diagnosis or ovulation-proof. | Clinician-referral content; stay C7 |
| **Post-laparoscopy** | `surgeries[]` recent | Surface clinician-directed recovery and fertility education without a universal conception window, probability, or countdown. | Stay C7; post-op content skin |
| **Pregnancy loss reported** | user reports loss | Fire universal loss handler (instant suppression of celebratory/milestone nudges, Gentle Mode, grief resources). **Retain endo care + pain tracker.** Offer RPL / Pregnancy-After-Loss pathway. | **E6 grief → later optional C5/D2 (RPL/PAL)**, endo modifier retained |
| **Low ovarian reserve / AMH concern surfaced** | user logs low AMH / clinician note | Non-alarmist "what AMH means" education; "discuss timing with your specialist." **No interpretation of the number.** | Stay C7; content + clinician referral |
| **Disengagement / "taking a break"** | inactivity / break flag | Pause nudges; keep all data (pain + fertility + record); low-touch validating wellness content. | Retain, low-touch |

*All routes preserve data continuity (one account, endo record + pain history intact) and always end with clinician-referral language, never a diagnosis, stage, or treatment plan.*

---

## K. Compliance flags

1. **No diagnosis / staging / management of endometriosis (top guardrail alongside #2).** Femio never confirms endo, assigns rASRM stage, computes EFI, or interprets AMH/imaging/pain. It records clinician-provided facts, educates, and prepares her for clinician conversations. Every endo/pain surface carries *"Femio helps you track and prepare — it does not diagnose, stage, or manage endometriosis."*
2. **Not contraception.** Fertile-window features are conception-awareness only. Ban “safe/infertile day” and any pregnancy-avoidance framing; every predictive surface says “not a method of birth control.” This is an internal product-scope guardrail; app-store and device-classification review remains a separate pre-submission legal task.
3. **No treatment/prevention claims; decision-prep ≠ advice.** The surgery-vs-ART toolkit presents cited options + questions; it **never** recommends surgery, IVF, hormonal treatment, or any dose. Routing thresholds (known-endo → evaluate sooner; 12-mo/6-mo) are *educational routing*, not an infertility diagnosis.
4. **Validation & anti-minimization (persona-critical emotional-safety rule).** Because C7's defining injury is **years of dismissal**, Femio **hard-bans** minimizing language for this persona — "just cramps," "just relax," "have you tried…", and toxic positivity are prohibited in copy and nudges. Tone is validating, believing, and non-alarming. This is a named, testable content rule, not a vibe. [BJOG 2024; NZ dismissal study — see §D]
5. **Uncertainty honesty.** Predictions display confidence and "estimate, not a guarantee." No false precision on ovulation day; no "late" counter for a persona already carrying grief. Endo-fertility content holds **impact AND hope** — never doom-frames ("endo = infertility") nor false-reassures.
6. **Privacy-by-design — doubly sensitive data.** Endo/chronic-illness + reproductive data is special-category and stigmatized (esp. AR/MENA). Learn from category history: **Flo (FTC 2021)** and **Premom (FTC 2023).** No sharing of pain/fertility/condition data with ad networks or analytics SDKs; data minimization; explicit, granular, revocable consent; strict retention + user-deletion for surgical/imaging/lab entries and OPK photos. **[NEEDS SOURCE — FTC primary docs; align to Femio privacy skill / DPA.]**
7. **GDPR / PDPL — special-category health data.** Lawful basis + explicit consent; DSAR/export/delete; regional data-residency (esp. AR/MENA). **[NEEDS SOURCE — align to Femio privacy skill at implementation.]**
8. **Partner mode consent.** Partner sees only granted scope (window + chosen pain/energy status); consent logged, scope-limited, instantly revocable; no access to non-shared history.
9. **Medical review + citations.** Diagnostic-pathway, symptom-diary, fertility, and decision-support wording is pinned in [`ENDOMETRIOSIS_CONTENT_SAFETY.md`](../compliance/ENDOMETRIOSIS_CONTENT_SAFETY.md). Translation must preserve the meaning and be locale-QA’d before publication. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
10. **Submission policy.** Public copy must make no implied diagnosis, treatment, prevention, contraception, individual prognosis, or treatment-selection claim. Current Apple/Google policy and device-classification mapping remains a separate legal pre-submission task.

---

## Sources

**Clinical — endometriosis & fertility (Tier-2 guidelines):**
- [ESHRE Guideline: Endometriosis (2022) — Human Reproduction Open (full text)](https://academic.oup.com/hropen/article/2022/2/hoac009/6537540) · [PMC copy](https://pmc.ncbi.nlm.nih.gov/articles/PMC8951218/) · [Guideline PDF (eshre.eu)](https://www.eshre.eu/-/media/sitecore-files/Guidelines/Endometriosis/ESHRE-GUIDELINE-ENDOMETRIOSIS-2022_2.pdf)
- [NICE NG73 — Endometriosis: diagnosis and management (recommendations)](https://www.nice.org.uk/guidance/ng73/chapter/recommendations) · [NICE 2024 update reframing (EndoNews summary)](https://www.endonews.com/nice-guideline-update-reframes-endometriosis-care-in-2024)
- [ASRM — Endometriosis and infertility: a committee opinion](https://www.asrm.org/practice-guidance/practice-committee-documents/endometriosis-and-infertility-a-committee-opinion-2012/)
- [Treatment of endometriosis: comparison of 8 guidelines (PMC8628449)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8628449/)

**Clinical — mechanisms, EFI, IVF outcomes:**
- [Endometriosis: inflammatory mechanisms & fertility implications (PMC11370979)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11370979/)
- [Endometriosis-associated infertility: pathophysiology to tailored treatment — Frontiers 2022](https://www.frontiersin.org/journals/endocrinology/articles/10.3389/fendo.2022.1020827/full)
- [EFI predicts live births after surgery — Human Reproduction 2017](https://academic.oup.com/humrep/article/32/11/2243/4282624) · [EFI optimal time-frame — PLOS One 2021 (PMC8115855)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8115855/)
- [Endometriosis lowers cumulative live-birth in IVF via embryo quantity not quality — J Clin Med 2020 (PMC7464781)](https://pmc.ncbi.nlm.nih.gov/articles/PMC7464781/)
- [Endometrioma surgery & ovarian reserve / fertility-preservation timing — Aksoy IVF summary](https://draksoyivf.com/blog/endometriosis-endometrioma/)
- [Endometriosis and infertility: pathophysiology, treatment, outcomes (PMC12414060)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12414060/)

**Clinical — diagnostic delay & dismissal (validation evidence):**
- [Understanding diagnostic delay for endometriosis: a scoping review — medRxiv 2024](https://www.medrxiv.org/content/10.1101/2024.01.08.24300988v1.full)
- [Patient experiences of endometriosis diagnosis (mixed methods) — BJOG 2024](https://obgyn.onlinelibrary.wiley.com/doi/10.1111/1471-0528.17719)
- [Dismissal informs priorities of endometriosis patients (NZ) — PMC10267318](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10267318/) · [A decade to wait: NZ diagnosis-delay update — PMC11660020](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11660020/)

**Clinical — dyspareunia / painful sex & TTC:**
- [NICE NG73 recommendations (pain/fertility priorities)](https://www.nice.org.uk/guidance/ng73/chapter/recommendations)
- [Patient's guide to painful sex (dyspareunia) with endometriosis — ESSI](https://internationalendo.com/endometriosis-painful-sex-dyspareunia-treatment/) · [Managing painful sex caused by endometriosis — Genesis Fertility](https://www.genesisfertility.com/blog/managing-painful-sex-caused-by-endometriosis/)

**Competitors / apps:**
- [Phendo (Citizen Endo, Columbia) — research app](https://citizenendo.org/phendo/) · [Phendo — Google Play](https://play.google.com/store/apps/details?id=com.appliedinformaticsinc.phendo&hl=en) · [Patient-driven app advances endo research — NewYork-Presbyterian](https://www.nyp.org/advances/article/womens-health/patient-driven-app-provides-key-data-to-advance-endometriosis-research)
- [Flo — endometriosis explainer](https://flo.health/menstrual-cycle/health/symptoms-and-diseases/what-endometriosis-is) · [Flo review + pain-tracking limitation (Healthline)](https://www.healthline.com/health/flo-period-tracker) · [Best period-tracking apps for endometriosis (The Mighty)](https://themighty.com/topic/endometriosis/best-period-tracking-apps-endometriosis/)
- [How to track endometriosis symptoms with Clue](https://helloclue.com/articles/cycle-a-z/how-to-track-endometriosis-symptoms-with-clue) · [Endometriosis & painful sex — Ovia Health](https://www.oviahealth.com/guide/101191/endometriosis-painful-sex/)

*Community insight (r/endometriosis, r/Endo, r/TryingForABaby, endo+TTC forums, app-store reviews) is synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. FTC and competitor claims remain subject to the tracker’s separate researcher/compliance verification. Clinical wording is governed by [`ENDOMETRIOSIS_CONTENT_SAFETY.md`](../compliance/ENDOMETRIOSIS_CONTENT_SAFETY.md). Clinical review: Mohamed K., 23 July 2026.*
