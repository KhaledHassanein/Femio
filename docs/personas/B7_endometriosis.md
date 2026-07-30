# Persona B7 — Endometriosis (diagnosed or suspected), NOT currently trying to conceive — living with it day to day

> Femio product + UX research spec. Scope guardrail: **wellness / education / tracking only.** Femio never diagnoses, treats, prevents, or manages disease, and is not contraception. Screeners are framed as *"screening — discuss with a clinician."* Endometriosis is a **clinician-diagnosed and clinician-managed condition** — Femio never confirms, stages, treats, or manages it; it educates, helps her track her symptoms, and helps her prepare for clinician conversations. Medication content is **educational only**.
> Persona code: **B7** · Cohort: Reproductive-age, non-TTC (B) · Shares endo clinical grounding with **C7** (endo + TTC) · Inherits `09_MASTER_ADAPTATION_MODEL.md` (seven invariants, state object, constant core, universal events §6, Z1 fallback, blending rules) · Last research pass: 2026-07-18

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Nadia," 30 |
| **Age band** | ~22–42. Can include adolescents with persistent symptoms and people in perimenopausal overlap; age does not determine whether symptoms deserve evaluation. |
| **Stage** | Living with endometriosis **day to day** — clinician-diagnosed (often confirmed at laparoscopy, or increasingly via imaging/clinical picture per ESHRE 2022) **or strongly suspected** and mid-diagnostic-journey. **Not currently trying to conceive** — fertility is not today's job. Managing pain, fatigue, flares, and the mental-health load of a chronic illness. May be on hormonal management, post-surgery, on painkillers, or between treatments. |
| **Relationship** | Any status. If partnered, a partner who has often watched years of pain and dismissal; dyspareunia (painful sex) strains intimacy even when conception is not the goal. |
| **Goal (top JTBD)** | *"Help me track my pain and flares in enough detail to actually see patterns and triggers, hold my whole history in one place, give me evidence my doctor can't wave away, teach me what my management options really are — and finally believe me."* |
| **Health literacy** | High and hard-won. Years of self-advocacy made her an expert patient; she knows "laparoscopy," "excision vs ablation," "GnRH," "endo belly," and distrusts oversimplification and "have you tried yoga." |
| **Tech context** | Web-first, phone-first. Likely already stacking a period tracker + a pain/symptom app (Phendo/Frendo) + a Notes file of surgeries and meds. Frustrated nothing holds the whole picture. |
| **Locale** | Arabic-first / RTL a first-class case; also EN/FR/ES. In AR/MENA markets, chronic pelvic pain and painful sex carry heavy stigma and silence — validation and privacy matter even more. |
| **Emotional state** | **Validation-hungry after years of dismissal**; exhausted by pain + fatigue; carrying real depression/anxiety load (see §D); hypervigilant to her body; determined to be taken seriously. Not in crisis about fertility — in a daily grind of symptom management. |
| **What she is NOT** | Not TTC (that is C7 — endo + TTC; distinct persona). Not someone who wants pain minimized as "just cramps." Not seeking Femio to treat or cure endo — she has (or is seeking) a clinician for that. Not necessarily child-free by choice — she may TTC later (→ C7), but today fertility is off the table. |
| **Primary devices for signals** | A structured **pain/flare diary**, symptom-severity trends, a **medication/hormonal-treatment log**, surgical/imaging records she carries between clinicians, cycle log (pain often tracks the cycle). |
| **Success = leaves us because…** | She finally has a tool that **believes her and holds her whole story**, walks into appointments with credible evidence, understands her options — OR she decides to TTC (→ C7, pain history carried), OR her cycles start changing in her 40s (→ perimenopause, endo modifier retained). |

**Persona thesis.** B7 is the **chronic-illness self-management** persona of the reproductive-age band — sharing C7’s experience of possible diagnostic delay or dismissal but with **fertility explicitly not today's job.** Her jobs are *pain/flare tracking deep enough to describe patterns, a longitudinal record that ends the "re-explaining" tax, doctor-ready evidence, honest management education, and validation.* No competitor serves this well: fertility apps treat endo as a checkbox and assume she's TTC; the best endo apps (Phendo) track deeply but are research-observational with no lifespan account, no doctor-export polish, and no path to "and when you're ready to conceive, your whole pain history comes with you." Treat B7 like a generic cycle tracker and she churns; treat her pain as "4 tap options" and she churns faster. Get the **believe-her tone, the deep pain/flare tracking, the descriptive pattern insight, and the doctor-evidence export** right and B7 becomes the chronic-condition flagship of the B band.

---

## B. Needs & questions (voice-of-user)

Mined from r/endometriosis, r/Endo, endometriosis.net community, app-store reviews of Phendo/Frendo/Flo/Clue, and qualitative studies (see Sources). Phrasing is representative/composite — community norms, not quoting individuals.

**On pain & flare tracking (the #1 job for B7):**
- *"I need to log WHERE it hurts, what KIND of pain, how bad, and what I took — not tap one 'cramps' button."* (Flo's shallow ~4-option pain field is a named grievance)
- *"I want to see if my flares follow my cycle, my food, my stress, my sleep — or if they're random."* (trigger-pattern hunger)
- *"Some days I can't work. I want to track how much this actually steals from my life."* (functional impact)
- *"Is this a flare, ovulation pain, or something new I need checked?"* (pain-signal disambiguation)

**On being believed & getting evidence (the emotional core):**
- *"It took me [years] and being told it was stress / IBS / in my head."*
- *"I forget half my symptoms in a 10-minute appointment — I need a summary that proves the pattern."*
- *"I want data my doctor can't dismiss — a real record, not me describing pain from memory."*

**On holding the whole history:**
- *"I'm so tired of re-explaining my surgeries, my meds, what I've already tried, to every new doctor."*
- *"I want my laparoscopy dates, my imaging, every hormonal treatment I've tried and whether it helped, in ONE place."*

**On management & options (education, not treatment):**
- *"What are my actual options — the pill, the coil, GnRH, surgery — and what do they each do?"* (education only)
- *"Will the birth control they gave me for endo make it better or just mask it?"*
- *"Do diet / physio / heat actually help or is that wellness noise?"*
- *"They keep offering me the same painkillers. What else is there to ask about?"*

**On fatigue, bowel/bladder, and the whole-body reality:**
- *"The fatigue is as disabling as the pain and no one warned me / no app tracks it."*
- *"My bowel and bladder symptoms flare with my period — is that the endo?"*
- *"Endo belly — the bloating is real and I want to log it."*

**On mental health:**
- *"The depression and anxiety from living in pain is the part no one treats."*
- *"I'm grieving the life / body I thought I'd have."*

**On privacy & framing:**
- *"After the Flo/Facebook thing I don't trust these apps with my health data."*
- *"Stop asking if I'm trying to get pregnant. I'm not. I'm trying to survive my period."*

**Top recurring questions Femio must answer in-product:**
1. Is what I'm feeling "normal" for endo, and what's a red flag I should get checked now?
2. Why am I so tired / bloated / having bowel + bladder pain — is that the endo too?
3. What are my management options and what does each actually do? (education)
4. Do lifestyle levers (heat, movement, physio, diet, pelvic floor) really help?
5. How do I get a dismissive clinician to take me seriously — and what should I ask for?
6. Is this pain a flare or something new I should get checked?

**Anti-needs / trust-breakers (what makes her churn):**
- **Any minimization of pain** ("it's just cramps," "have you tried relaxing/losing weight/yoga") — the single fastest churn driver; it re-enacts the dismissal she's fleeing.
- Being assumed to be TTC or pregnant the moment she logs an irregular/painful cycle.
- **Pain tracking too shallow** to reveal patterns (Flo's ~4 options is the named grievance).
- Any implication Femio can diagnose, stage, treat, or "manage" her endo.
- Toxic positivity and "cure" claims (diet-will-cure-you, detox, etc.).
- Privacy creep with chronic-illness + reproductive data (doubly sensitive; see §K).

---

## C. Competitor teardown

Feature-by-feature. **Key insight for Femio:** the market splits into (a) **general cycle/fertility trackers** (Flo, Clue, Ovia) where endo is a shallow symptom checkbox and the whole UX assumes cycle-prediction or TTC, and (b) **dedicated endo apps** (Phendo, Frendo) that track symptoms deeply but are single-purpose, research- or community-flavored, with no lifespan account, thin doctor-export, and no bridge to the rest of a woman's health. **No one holds deep pain/flare tracking + trigger-pattern insight + a longitudinal surgical/med record + a polished doctor-evidence export + trustworthy privacy + Arabic-first RTL + one account that carries her whole story into TTC, pregnancy, and perimenopause when life changes.** That whole-picture, whole-lifespan gap is B7's Femio thesis.

| App | Endo pain/flare depth | Trigger/pattern insight | Surgical/med/lab history | Doctor-evidence export | Endo management education | Non-TTC framing | Notable privacy / positioning |
|---|---|---|---|---|---|---|---|
| **Phendo** (Citizen Endo / Columbia) | **Best-in-class** — structured daily logging of pain, bleeding, GI/bladder, mood, self-management strategies; personalized health journal incl. "endo belly" | Some (research-grade analytics; 11+ published papers) | Partial (treatments/strategies tried) | Basic | Research-educational, not decision-directed | **Yes** — not a fertility app | Research-consent model; strong community trust; purely observational/academic; no lifespan account. |
| **Frendo** | Good — daily symptoms, triggers, flare-ups, activities to find what impacts the condition; community built in | Insight tool for triggers | Partial | Basic | Community + tracking | **Yes** | Community-first; reviewers report reliability/data-entry bugs ("nothing goes through"). |
| **Flo** | **Shallow** — named grievance: pain field ~4 options, "not nuanced enough" for endo; has an endo *symptom checker* (screening) | Cycle-centric | No | No | Endo explainer + 5-min self-assessment (routes to doctor) | Assumes cycle/TTC framing | FTC 2021 settlement (data to Facebook/Google); ~$56M class settlement (2025); added Anonymous Mode. Reach without depth. |
| **Clue** | Moderate — endo-symptom-tracking guide, more granular pain options than Flo | Modest | No | No | Endo tracking article | Neutral | Strong, well-regarded EU/GDPR privacy posture; still cycle-prediction-centric. |
| **Ovia** | Moderate symptom logging; endo/painful-sex education | Modest | No | No | Some endo guides | Strongly fertility/pregnancy-oriented | Employer/health-plan B2B2C channel raises data concerns. |
| **Bearable** (general chronic-illness tracker) | Good generic symptom/factor tracking + correlations | **Strong generic** factor correlations | Some (meds) | Some export | Generic, not endo-specific | **Yes** | Chronic-illness generalist; no women's-health depth, no lifespan account, no endo content. |

**Fragmentation map (the opening for Femio):**
- **Pain/flare depth** lives in Phendo/Frendo — but with no lifespan account, thin doctor-export, no bridge to TTC/pregnancy/perimenopause, and (Frendo) reliability complaints.
- **Correlation/trigger insight** lives in generic chronic-illness apps (Bearable) — but with zero women's-health/endo specificity or content.
- **Reach + polish** lives in Flo/Clue — but with shallow pain tracking and a cycle/TTC-centric frame that mis-serves a non-TTC endo patient.
- **A believe-her tone + deep pain/flare tracking + trigger-pattern insight + a longitudinal surgical/med/lab record + a doctor-ready evidence export + honest endo management education + trustworthy privacy + Arabic-first RTL + one account that carries her whole story across the lifespan:** essentially **nobody**. That is B7's Femio thesis.

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio does **not** diagnose, stage, treat, prevent, or manage endometriosis; it educates and helps users track. Under **NICE NG73 (updated 2024)**, ultrasound, referral where indicated, and initial treatment can proceed in parallel. A normal examination or ultrasound does not exclude endometriosis, and laparoscopy may still be considered. Femio never treats imaging or a symptom pattern as a diagnosis. [NICE NG73, recommendations 1.5.1–1.5.11]

**What endometriosis is & core symptoms (in scope as education):**
- Endometriosis is tissue similar to the uterine lining growing outside the uterus, causing inflammation, pain, and sometimes scarring/adhesions [NICHD; NHS]. Core symptoms: **chronic pelvic pain, painful periods (dysmenorrhoea), pain during/after sex (deep dyspareunia), heavy or irregular bleeding, fatigue,** and, for some, subfertility [NICHD; NICE NG73; ESHRE 2022].
- Pain may be **cyclical** (worse around menstruation and ovulation) **and/or non-cyclical / constant**; patients describe burning, throbbing, stabbing pain in different pelvic locations [PMC "Pain in Endometriosis"; PMC endometriosis-related CPP].
- **Bowel involvement** can cause IBS-like symptoms — painful bowel movements (dyschezia), diarrhoea, constipation, cyclical rectal bleeding [NICE NG73; UCLA Health]. **Bladder involvement** can cause painful urination (dysuria), bladder pain/sensitivity, cyclical haematuria [NICE NG73; NICHD]. Less common: shoulder-tip pain, cyclical cough/chest pain (thoracic endo) [ESHRE 2022].
- **Fatigue** is a common, debilitating, non-specific symptom of the chronic-illness/inflammatory burden [UCLA Health; endometriosis.net]. **"Endo belly"** (severe bloating) is a real, frequently-reported symptom patients want to track [Phendo/community].

**Diagnostic delay and validation (the emotional core; shared with C7):**
- NICE emphasizes prompt diagnosis because delay can affect quality of life. Femio validates a user’s symptoms and helps prepare a clear history without publishing one global delay, dismissal, or post-diagnosis-emotion percentage. [NICE NG73 (updated 2024)]

**Mental health and quality of life (in scope — screening + support education):**
- Persistent pain and endometriosis symptoms can affect daily life and emotional wellbeing. Femio may offer validated, non-diagnostic screening, coping content, and support routing, but does not publish one universal depression/anxiety prevalence or infer a mental-health diagnosis from endometriosis. [NICE NG73]

**Management options (Tier-2 guideline grounding — EDUCATIONAL only, never a plan or a dose):**
- **NICE NG73 (updated November 2024):** discuss benefits and risks of analgesics and consider a short trial of paracetamol or an NSAID for endometriosis-related pain. Hormonal and surgical options are clinician-directed and preference-sensitive. Femio explains categories and questions only; it never recommends an option or dose. [NICE NG73]
- **ESHRE 2022** supports individualized care and shared decision-making. Femio preserves that uncertainty and routes treatment choices to the user’s clinician. [ESHRE 2022 guideline + patient version]
- **Lifestyle / complementary levers** (heat, physical activity, pelvic-floor physiotherapy, dietary approaches, TENS, psychological therapies) have **variable/limited evidence** but are low-harm, preference-sensitive adjuncts to discuss with a clinician — never framed as a cure [PMC comparative-effectiveness review; ESHRE 2022]. *Femio presents these as "some people find these help; evidence is mixed; discuss with your clinician," and hard-bans "cure/detox" framing.*

**WHEN to seek/expedite care (the routing rule — critical for §G/§J):**
- Consider raising endometriosis with a clinician for symptoms in NICE NG73, including chronic pelvic pain, period-related pain that affects daily life, deep pain during or after sex, cyclical bowel or urinary symptoms, or infertility with one or more of those symptoms. Acute or severe symptoms follow Femio’s general urgent-care route; the app does not decide that endometriosis is the cause. [NICE NG73]
- If not yet diagnosed but symptoms fit, Femio soft-routes to endo-symptom education + "discuss with a clinician" — **never self-labels her.**

Medical-review resolution: diagnostic-pathway, symptom, management, fertility, and product-scope wording follows [`ENDOMETRIOSIS_CONTENT_SAFETY.md`](../compliance/ENDOMETRIOSIS_CONTENT_SAFETY.md). Global delay, dismissal, mental-health-prevalence, and red-flag-attribution figures were removed. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

Inherits the B-band constant core (cycle/bleed log, generic symptom/mood/sleep, uncertainty-honest cycle view, visit-prep, privacy-by-design, non-TTC default). B7 **adds the chronic-pain / chronic-illness self-management layer** that makes it endo-specific.

**P0 — Must-have (defines the persona; ship first):**
1. **Deep pain / flare tracker** — **pain-location body map** (pelvic, bowel, bladder, lower back, leg, abdomen/"endo belly," chest/shoulder for thoracic), pain **type** (cramping/stabbing/burning/throbbing/dragging), **severity 0–10**, **cyclical vs non-cyclical** flag, triggers (food, stress, sleep, activity, cycle phase), **meds/relief taken + whether it helped**, dyspareunia / dyschezia / dysuria flags, **functional impact** (missed work/school/activity, bed-bound). Structured far beyond Flo's ~4 options; Phendo-grade, but joined to her whole record.
2. **Symptom-severity trend view** — pain, fatigue, bloating ("endo belly"), bowel/bladder, mood over time; see whether things are getting better/worse across weeks and months. Calm, descriptive, non-diagnostic.
3. **Trigger / flare-pattern insight** — descriptive correlations ("your higher-pain days appear associated with your late-luteal phase / poor-sleep nights") — **"appears associated with," never "caused by,"** never diagnostic. This is the #2 job after logging.
4. **Longitudinal endo record** — surgical history (laparoscopy dates, findings, stage if known, excision/ablation), imaging, **hormonal/medication-treatment history with "did it help?"**, labs (entry-only, no interpretation), appointments — that she can **export/carry between clinicians.** Ends the "re-explaining tax."
5. **Doctor-evidence export** — one-tap, printable/PDF **appointment pack**: pain-map summary, severity trends, flare frequency, functional-impact days, med/treatment history + effectiveness, and her questions. The credible evidence a dismissive clinician "can't wave away."
6. **Validation-first tone engine** — content and nudges that explicitly affirm her pain and her years of being unheard; **hard bans** on "just cramps," "just relax," "have you tried…", cure/detox claims, and toxic positivity for this persona (§K).
7. **Non-TTC default** — no "trying to conceive?" nudges, no fertile-window pushing; TTC/pregnancy/contraception content reachable but never assumed.

**P1 — Strong differentiators (fast follow):**
8. **Management-options education library** — plain-language, cited explainers of analgesia, hormonal options (pill/progestogens/LNG-IUS/GnRH+add-back), surgery (excision vs ablation), and lifestyle/complementary levers — **what each does, per NICE/ESHRE,** never a recommendation or dose. Includes "what to ask about if the same painkillers aren't working."
9. **Clinician-visit prep + advocacy pack** — question builder, "what a work-up can involve," advocacy scripts for being dismissed, standard red-flag list — pre-filled from her own logged data.
10. **Mental-health & body-image support module** — validated screening (e.g., PHQ-2/GAD-2 style, screening-framed), coping content for chronic-pain-related depression/anxiety and grief, crisis resources on any low screen.
11. **Post-surgery / post-laparoscopy tracking** — symptom-recovery logging and education on what surgery can/can't do, without a countdown or pressure clock.
12. **Wearable / device import** — Apple Health, sleep/activity, to enrich trigger-pattern insight (optional).

**P2 — Nice-to-have / later:**
13. Moderated endo community / Q&A (privacy-safe; "you're believed here" ethos).
14. Fully custom trackable symptoms (Read-Your-Body-style flexibility for atypical presentations).
15. Localized coaching content by market (AR modesty- and stigma-aware framing for chronic pelvic pain + painful sex).
16. Pain-management-technique library (heat, TENS, pelvic-floor physio, pacing) — evidence-graded, non-cure.

**Explicitly OUT of scope for B7 (guardrail):**
- Diagnosing, **staging**, or "managing" endometriosis; computing rASRM stage; interpreting labs/imaging/pain. Femio educates and organizes — the clinician diagnoses and manages.
- Any treatment/dose recommendation. Management education presents options + questions; it never advises a treatment or dose.
- Any "safe days / contraception" framing. **Never.**
- "Cure," "reverse," "detox," or diet-will-cure-your-endo claims. **Banned.**

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries source citations and "not medical advice / discuss with your clinician." Tone across all B7 content is **validating** (see §K).

1. **“You were not imagining it”** — why diagnosis can be delayed and how to prepare a clear symptom history. Validation content, cited, non-alarming, with no universal delay or dismissal statistic.
2. **Endometriosis 101** — what it is, how it can cause pain, why symptoms vary; the ESHRE-2022 shift to imaging-first diagnosis (so she understands her clinician's pathway).
3. **The whole-body picture** — why fatigue, "endo belly"/bloating, and bowel/bladder symptoms are part of endo; what's cyclical vs constant.
4. **Your management options, explained (education only)** — analgesia, hormonal options (pill/progestogens/LNG-IUS/GnRH + add-back), surgery (excision vs ablation), per NICE/ESHRE — what each does, plainly. Clear non-prescription disclaimer.
5. **Do lifestyle & complementary approaches help?** — heat, movement, pelvic-floor physio, diet, TENS, psychological therapy: honest "evidence is mixed, low-harm, discuss with your clinician." Explicitly **not** a cure.
6. **Endometriosis & painful sex (dyspareunia)** — why it happens, coping/comfort education, when to raise it; non-judgmental, stigma-aware for AR/MENA.
7. **Endo & mental health** — normalizing depression/anxiety/grief from chronic pain; coping strategies; when and how to seek support.
8. **Getting the most from your appointment** — advocacy scripts, questions to ask, using your exported pain diary + evidence pack; what a work-up can involve.
9. **When to seek care** — red flags (severe rectal bleeding, acute abdominal pain) and "worth-raising" patterns, screening-framed, "discuss with a clinician."
10. **Myths vs evidence** — "it's just a bad period," "pregnancy/hysterectomy cures it," "diet will cure you," "you're too young."
11. **Reachable-but-hidden library:** full-lifespan content — **endometriosis and fertility / TTC** (for if/when she's ready → C7), **endo in pregnancy and postpartum** (pain often persists), **endo and perimenopause**, contraception *education*, and general gynae — stays searchable so B7 never feels boxed into "endo-only."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer.

---

## G. Tools, logs & alerts (compliant framing — education & tracking, not diagnosis; not contraception)

**Logs (inputs):**
- **Pain/flare (P0 core):** **pain-location body map** (pelvic, bowel, bladder, lower back, leg, abdomen/endo belly, chest/shoulder), pain **type**, **severity 0–10**, **cyclical vs non-cyclical**, triggers (food/stress/sleep/activity/cycle phase), **meds/relief taken + helped?**, dyspareunia / dyschezia / dysuria flags, **functional impact** (missed work/activity, bed-bound).
- **Whole-body symptoms:** fatigue level, bloating/"endo belly," bowel + bladder symptoms, mood, sleep.
- **Cycle/bleed log:** flow, spotting, cycle-length range view (no "late" language).
- **Endo record:** surgeries (date/type/findings/stage-if-known/excision-vs-ablation), imaging, **hormonal/medication-treatment history + did-it-help**, labs (entry-only, no interpretation), appointments.
- Optional: weight (never required), private photo progress (local; e.g., bloating).

**Tools:**
- **Pain-map + severity-trend dashboard** — body-map heat view + 0–10 severity over time; fatigue/bloating/bowel/bladder trends.
- **Flare-pattern insight** — descriptive correlations vs cycle phase / sleep / logged triggers ("appears associated with," never "caused by," never diagnostic).
- **Doctor-evidence export (PDF/print)** — appointment pack: pain-map summary + severity trends + flare frequency + functional-impact days + med/treatment-effectiveness history + her questions + standard work-up checklist.
- **Endo-record export** — surgical/imaging/med/lab history to carry between clinicians.
- **Visit-prep / question builder** — pre-filled from her logs.
- **Screeners (framed as screening, not diagnosis):**
  - Mood/anxiety screen (PHQ-2/GAD-2 style) → "This is a screening tool, not a diagnosis — consider discussing with a clinician." + crisis resources.
  - Endo-symptom-awareness checklist (esp. for the "suspected/undiagnosed" B7) → "These can be signs to discuss; only a clinician can diagnose."

**Alerts / nudges (all opt-in, tone-calibrated, revocable, validation-first, non-alarming, localized/RTL):**
- Gentle log reminders (respect her cadence; **never** "your period is late," **never** streak pressure on pain logs).
- Flare-pattern surface: "Your higher-pain days this cycle appear to cluster around [phase] — you might want to note this for your clinician." (descriptive, not diagnostic)
- **Red-flag education box** (universal handler): if she logs **severe rectal bleeding** or **acute/severe abdominal pain**, surface a prominent "this is worth urgent medical attention — here's what to know" box + saved care contact as *education*, never triage/diagnosis; the log stays raw.
- Visit-prep nudge before a logged appointment: "Want to generate your evidence pack?"
- Mental-health check-in nudge if pain/mood logs trend low; crisis resources on any low screen.
- **No** fertile-window / "safe day" content; **no** TTC nudges; **no** "late" counter; **no** minimizing or "cure" language ever.

**Mandatory compliance wording on relevant surfaces:**
- Pain/endo surfaces: *"Femio helps you track and prepare — it does not diagnose, stage, treat, or manage endometriosis."*
- Screener/insight outputs: *"This is educational, not a diagnosis or a treatment plan. Please discuss with your clinician."*
- Medication/management content: *"Educational only — not a recommendation or a dose. Discuss options with your clinician."*
- No "safe day," "infertile day," or contraception framing — **ever.** If cycle/ovulation info appears anywhere, it carries *"not a method of birth control."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared — the one-account spine):** `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, consent flags, account mode · `cycle{period_start/end, cycle_length_history[], flow[]}` · `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (non-diagnostic) · `content_history[]`, `screener_results[]` (timestamped, non-diagnostic) · privacy/state flags.

**B7 persona-specific (adds the chronic-condition endo sub-layer over the B band; `ttc_intent=false`):**
- **Endo diagnosis:** `endo_diagnosis` {status: confirmed_by_clinician | suspected/undiagnosed, method (imaging/laparoscopy/clinical), date, stage_if_known} — **entry-only, never Femio-derived.**
- **Pain log:** `pain_log[]` {timestamp, location[] (body-map), type, severity_0_10, cyclical:bool, triggers[], meds_taken, meds_helped:bool, dyspareunia:bool, dyschezia:bool, dysuria:bool, functional_impact (none/reduced/missed_activity/bed_bound)}.
- **Whole-body symptom log:** `symptom_log[]` {fatigue_0_10, bloating/endo_belly, bowel_symptoms, bladder_symptoms, mood, sleep}.
- **Endo record:**
  - `surgeries[]` {date, type (e.g. laparoscopy), approach (excision/ablation), findings_note, stage_if_known}.
  - `imaging_results[]` {date, type (US/MRI), note} (entry-only).
  - `treatment_history[]` {agent/type (NSAID, COC, progestogen, LNG-IUS, GnRH+add-back, surgery, physio…), start, end, **helped:bool/scale**, side-effects note} — **educational context only.**
  - `labs[]` {name, value, unit, date} — **entry-only, no interpretation.**
  - `appointments[]`, `visit_prep_state`, `evidence_pack_history[]`.
- **Screening history:** `mood_screen_history[]` (scores + dates, screening-only).
- **Modifier flags:** `modifiers=[endometriosis]`; optional stacks (`chronic_pelvic_pain`, `post_laparoscopy`, `suspected_undiagnosed`). `ttc_intent=false` (drives non-TTC UX; reachable toggle).

*Data-minimization: collect only what powers a used feature; surgical/imaging/lab/photo entries stored with strict retention + user-deletion. Chronic-illness + reproductive data is doubly sensitive — see §K. Weight is never required.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into B7):**
1. "What brings you to Femio?" → *Tracking my cycle / managing a condition* (not TTC, not pregnant).
2. "Any of these apply?" → **known/suspected condition → endometriosis** selected → sets `modifiers=[endometriosis]`, routes to **B7** (not generic B1, not C7).
3. "Are you currently trying to conceive?" → **No** → `ttc_intent=false`; suppress fertile-window & pregnancy nudges (reachable via toggle).
4. "Has a clinician diagnosed it, and how?" → sets `endo_diagnosis` (clinical/imaging/laparoscopy). **If not clinician-diagnosed → `suspected_undiagnosed`**: emphasize endo-symptom education + "discuss with a clinician" + visit-prep; **never self-label.**
5. "Have you had surgery for it (e.g. laparoscopy)?" → seeds `surgeries[]`, unlocks post-op tracking/education.
6. "What matters most right now?" (multi-select: pain/flares, fatigue, bowel/bladder, mental health, appointment prep, understanding my options) → orders home modules.
7. "What do you want to track?" (pain/flare, fatigue, cycle, minimal) → **pain/flare tracker ON by default for B7**; others reachable via "Add tracking."
8. Consent & privacy (chronic-illness + reproductive data double-consent).

**Home config for B7:**
- Hero = **pain/flare quick-log + today's severity-and-fatigue strip** (not a fertile-window card, not a "late" counter).
- Quick-log row = pain/flare + fatigue + her chosen trackers.
- Secondary cards ordered by her concern selection: severity-trend view, flare-pattern insight, **doctor-evidence export / visit-prep** when an appointment is near, management-options education, mental-health module if flagged, post-op tracking if applicable, latest validating content module.
- **Hidden-but-reachable:** full lifespan library — endo-and-fertility/TTC (for if/when she's ready), endo-in-pregnancy/postpartum, endo-and-perimenopause, contraception *education*, other conditions — one search/tap away.

**Adaptive tone:** **validation-first at all times.** Baseline = affirming + informative ("you're believed here"). As logs accumulate or an appointment nears, tone shifts to *organizing + empowering* ("here's your evidence, here are your questions") — never alarmist, never toxic-positive, never minimizing pain. If mood screens trend low, surface the mental-health module + resources.

---

## J. Adaptation triggers (state transitions)

Inherits the **universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive test, pregnancy loss, mood-screen high/crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). B7 adds/`specializes` the transitions below. **Cross-cutting B7 rule: the `endometriosis` modifier and its pain/flare + surgical/med/lab record persist across every state — it is never dropped on transition (endo pain commonly continues through TTC, pregnancy, postpartum, and into perimenopause).**

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Sets TTC intent = true** ("start trying") | user toggles TTC on / wizard re-answer | Confirm sensitively; enable fertility tooling **with endo-aware, uncertainty-honest framing**; **carry the entire pain/flare + surgical/med history forward** (she never re-enters it); surface endo-and-fertility education. | **C7 (endo + TTC)**, `modifiers=[endometriosis]`, **pain history carried** |
| **New/worsening or atypical pain; or red-flag** (severe rectal bleeding, acute abdominal pain) | pain-log severity spike / new location / red-flag entry | Non-diagnostic "worth raising / worth urgent attention" + prominent red-flag education box (universal handler); saved care contact as education; **log stays raw.** **Never** interpret pain as diagnosis. | Clinician-referral content; stay B7 |
| **Suspected/undiagnosed → sees a clinician / gets diagnosed** | user updates `endo_diagnosis` to confirmed | Update record (entry-only); unlock diagnosed-path content + management-options education; validate ("relief is the most common feeling"). **Never** Femio-confirms the diagnosis. | Stay B7 (status: confirmed) |
| **Starts / changes hormonal or surgical management** | user logs a new `treatment_history[]` entry | Surface educational context for that option (what it does, per NICE/ESHRE) + "track whether it helps"; **never** dose/advise. Post-surgery → unlock recovery-tracking + post-op education (no countdown). | Stay B7; management-education skin |
| **Mood screen high / crisis flag** | validated screen crosses its reviewed follow-up threshold, or separate urgent disclosure | Fire universal handler: surface mental-health module + global urgent-routing policy; screening framing. Do not infer a diagnosis from endometriosis. | Stay B7 + support routing |
| **Perimenopause overlap** (late 30s/40s; changing cycles, vasomotor symptoms) | age/symptom signals | Introduce perimenopause education; explain endo-vs-perimenopause symptom overlap and how endo/pain may change (or persist) around menopause; keep pain tracking. **Endo modifier retained.** | Blend B7 + perimenopause; offer route to menopause band (F), endo modifier carried |
| **Positive pregnancy test** (if she was TTC-toggled or unplanned) | `hpt_results` positive / user confirms | Fire universal positive-test handler (celebrate, tone-matched; suppress fertile-window/OPK/TWW; carry all data; re-confirm privacy). **Retain endo modifier + pain tracker** — surface "endometriosis in pregnancy" content (pain may persist/change). | **Pregnancy mode + endometriosis modifier**, pain-tracking continuity preserved |
| **Pregnancy loss reported** | user reports loss | Fire universal loss handler (instant suppression of celebratory/milestone nudges, Gentle Mode, grief resources). **Retain endo care + pain tracker.** | **E6 grief**, endo modifier retained |
| **Disengagement / "taking a break"** | inactivity / break flag | Pause nudges; keep all data (pain/flare + record intact); low-touch validating wellness content. | Retain, low-touch |
| **Toggles off endometriosis mode** | user setting | Revert to generic B-band cycle logic; **preserve all history** (archived-but-reachable). | Generic reproductive-age band / Z1 |

*All routes preserve data continuity (one account, endo record + pain/flare history intact) and always end with clinician-referral language, never a diagnosis, stage, or treatment plan.*

---

## K. Compliance flags

1. **No diagnosis / staging / management of endometriosis (top guardrail alongside #3).** Femio never confirms endo, assigns rASRM stage, or interprets labs/imaging/pain. It records clinician-provided facts, educates, and prepares her for clinician conversations. Every endo/pain surface carries *"Femio helps you track and prepare — it does not diagnose, stage, treat, or manage endometriosis."*
2. **Validation & anti-minimization (persona-critical emotional-safety rule).** Because B7's defining injury is **years of dismissal**, Femio **hard-bans** minimizing language for this persona — "just cramps," "just relax," "have you tried…", and toxic positivity are prohibited in copy and nudges. Also banned: **"cure," "reverse," "detox," and diet-will-cure-your-endo** claims. Tone is validating, believing, non-alarming. Named, testable content rules, not a vibe. [BJOG 2024; NZ dismissal study — §D]
3. **No treatment/prevention claims; management education ≠ advice.** The management-options library and medication content (NSAIDs, COC, progestogens, LNG-IUS, GnRH+add-back, surgery, physio) present **cited options + what each does + questions** — never a recommendation, plan, or dose. Routing thresholds (red flags; "worth raising") are *educational routing*, not diagnosis.
4. **Not contraception.** No “safe/infertile day” or pregnancy-avoidance framing—ever. Any cycle/ovulation surface carries “not a method of birth control.” This is an internal product-scope guardrail; app-store and device-classification review remains a separate pre-submission legal task.
5. **Uncertainty honesty.** Flare-pattern insight is descriptive ("appears associated with," never "caused by"); no "late" counter for a persona already carrying grief; predictions (if any) show confidence and "estimate, not a guarantee." Endo content holds **realism AND hope** — never doom-frames nor false-cures.
6. **Mental-health safety.** Persistent symptoms can affect emotional wellbeing. Use validated, non-diagnostic screening and the project’s global urgent-routing policy; do not infer a mental-health diagnosis from endometriosis.
7. **Privacy-by-design—combined health and reproductive data.** Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): no pain/condition/cycle data to ad networks or targeted-advertising profiles; minimum necessary collection; granular, revocable product permissions; and purpose-limited retention, export, deletion, processor, and security controls for entries and photos. The primary warnings are the [FTC Flo matter](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom matter](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v); the unsupported class-settlement amount is excluded. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
8. **Privacy-law implementation.** For EEA processing, endometriosis and reproductive data fall within GDPR Article 9; document an Article 6 basis and Article 9 condition and implement applicable access, correction, portability, and erasure workflows. Other markets require launch-country counsel review. Do not claim universal “GDPR/PDPL compliance” or residency without approved architecture/contracts. ([GDPR official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj); [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
9. **Medical review + citations.** Diagnostic-pathway, symptom, management, fertility, and scope wording is pinned in [`ENDOMETRIOSIS_CONTENT_SAFETY.md`](../compliance/ENDOMETRIOSIS_CONTENT_SAFETY.md). Translation must preserve the meaning and be locale-QA’d before publication. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
10. **Submission policy.** Public copy must make no implied diagnosis, treatment, prevention, cure, contraception, or individual treatment-selection claim. Current Apple/Google policy and device-classification mapping remains a separate legal pre-submission task.

---

## Sources

**Clinical — endometriosis symptoms, diagnosis & management (Tier-1 + Tier-2):**
- [What are the symptoms of endometriosis? — NICHD (NIH)](https://www.nichd.nih.gov/health/topics/endometri/conditioninfo/symptoms)
- [Endometriosis: diagnosis and management — NICE NG73 (recommendations; updated Nov 2024)](https://www.nice.org.uk/guidance/ng73/chapter/recommendations) · [NG73 overview](https://www.nice.org.uk/guidance/ng73) · [NG73 visual summary (first presentation, management, referral)](https://www.nice.org.uk/guidance/ng73/resources/visual-summary-on-first-presentation-initial-management-diagnosis-referral-and-ongoing-care-of-pdf-13559822461)
- [ESHRE Guideline: Endometriosis (2022) — full PDF](https://www.eshre.eu/-/media/sitecore-files/Guidelines/Endometriosis/ESHRE-GUIDELINE-ENDOMETRIOSIS-2022_2.pdf) · [ESHRE 2022 patient version PDF](https://www.eshre.eu/-/media/sitecore-files/Guidelines/Endometriosis/ESHRE-ENDOMETRIOSIS-patient-Guideline_21032022.pdf) · [ESHRE 2022 guideline summary — Medscape](https://reference.medscape.com/cc2/p10/endometriosis-eshre-guideline-2026a1000iib)
- [Endometriosis treatment & management (hormonal/surgical) — Medscape](https://emedicine.medscape.com/article/271899-treatment)
- [Management of endometriosis-related pain: hormonal vs surgical vs complementary — PMC11724681](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11724681/)

**Clinical — symptom breadth (pain, fatigue, bowel/bladder, whole-body):**
- [Pain in Endometriosis — PMC7573391](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7573391/) · [Endometriosis-related chronic pelvic pain — PMC10603876](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10603876/)
- [Lesser-known effects of endometriosis (fatigue, bowel/bladder) — UCLA Health](https://www.uclahealth.org/news/article/lesser-known-effects-endometriosis)
- [Endometriosis symptoms and signs — WebMD](https://www.webmd.com/women/endometriosis/understanding-endometriosis-symptoms)

**Clinical — mental health & quality-of-life burden:**
- [Impact of endometriosis on depression, anxiety & QoL: systematic review — Frontiers 2023](https://www.frontiersin.org/journals/public-health/articles/10.3389/fpubh.2023.1230303/full) · [PMC copy](https://pmc.ncbi.nlm.nih.gov/articles/PMC10512020/)
- [Endometriosis, chronic pain, anxiety, depression — retrospective study (12M women), J Affective Disorders — ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0165032723014027)
- [Relationship between endometriosis and mental health: systematic review & meta-analysis — PMC12703484](https://pmc.ncbi.nlm.nih.gov/articles/PMC12703484/)
- [Psychological distress & QoL in women with endometriosis: narrative review — PMC11972425](https://pmc.ncbi.nlm.nih.gov/articles/PMC11972425/)
- [Depression/anxiety in endometriosis-associated chronic pain: neuroimmune mechanisms — PMC12531961](https://pmc.ncbi.nlm.nih.gov/articles/PMC12531961/)

**Clinical — diagnostic delay & dismissal (validation evidence; shared with C7):**
- [Understanding diagnostic delay for endometriosis: a scoping review — medRxiv 2024](https://www.medrxiv.org/content/10.1101/2024.01.08.24300988v1.full)
- [Patient experiences of endometriosis diagnosis (mixed methods) — BJOG 2024](https://obgyn.onlinelibrary.wiley.com/doi/10.1111/1471-0528.17719)
- [Dismissal informs priorities of endometriosis patients (NZ) — PMC10267318](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10267318/) · [A decade to wait: NZ diagnosis-delay update — PMC11660020](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11660020/)

**Competitors / apps (endo-tracking & general):**
- [Phendo (Citizen Endo, Columbia) — research app](https://citizenendo.org/phendo/) · [Phendo — App Store](https://apps.apple.com/us/app/phendo/id1145512423)
- [Frendo — Endometriosis Tracker (Google Play)](https://play.google.com/store/apps/details?id=com.devensis.frendo&hl=en_AU)
- [Endometriosis symptom tracking: endo apps put to the test — endometriosis.net](https://endometriosis.net/living/apps)
- [Flo — endometriosis explainer](https://flo.health/menstrual-cycle/health/symptoms-and-diseases/what-endometriosis-is) · [How to track endometriosis symptoms with Clue](https://helloclue.com/articles/cycle-a-z/how-to-track-endometriosis-symptoms-with-clue) · [Endometriosis & painful sex — Ovia Health](https://www.oviahealth.com/guide/101191/endometriosis-painful-sex/)

*Community insight (r/endometriosis, r/Endo, endometriosis.net, app-store reviews of Phendo/Frendo/Flo/Clue) is synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. FTC actions and settlement figures remain subject to the tracker’s separate researcher/compliance verification. Clinical wording is governed by [`ENDOMETRIOSIS_CONTENT_SAFETY.md`](../compliance/ENDOMETRIOSIS_CONTENT_SAFETY.md). Clinical review: Mohamed K., 23 July 2026.*
