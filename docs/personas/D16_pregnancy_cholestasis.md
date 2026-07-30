# D16 — Pregnancy with Intrahepatic Cholestasis of Pregnancy (ICP / Obstetric Cholestasis)

> Femio persona spec. Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent.** ICP raises the risk of stillbirth and often leads to planned early delivery — red-flag symptoms and reduced fetal movement get prominent "seek care now" framing, but the app **NEVER diagnoses**. Bile-acid and liver results are **entry-only, never interpreted**. Screeners = *"screening — discuss with your clinician."* Medication content (ursodeoxycholic acid, etc.) is **educational, never prescriptive**.
> Persona code: **D16** · Cohort: Pregnancy (D) · Layered on **D1** (uncomplicated pregnancy spine); shares the monitoring/red-flag pattern of **D6** · Last research pass: 2026-07-17
> Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · 09_MASTER_ADAPTATION_MODEL · femio-compliance-privacy · femio-medical-content skills

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Rana," 31 |
| **Stage** | Pregnant, usually **T2 late / T3** (ICP most often presents in the late second or third trimester; itching can rarely start earlier). Either (a) **diagnosed** ICP (pruritus + raised bile acids on bloods), or (b) **itching without rash, awaiting bloods / being investigated**, or (c) a **prior-ICP** history flag from an earlier pregnancy (70–90% recurrence) being watched from booking. |
| **Relationship / support** | Partnered; wants partner to understand why she is awake scratching at 3 a.m. and why an early induction may be planned (X2 partner mode). |
| **Goal (top JTBD)** | *"This relentless itch is driving me mad and I'm scared for my baby — help me track the itch and my symptoms, understand my bile-acid numbers and what the plan is, keep my extra blood tests and appointments straight, and tell me plainly when something is an emergency — calmly, accurately, and without pretending to be my doctor."* |
| **Health literacy** | Moderate–high, **fear-motivated**, often already deep in ICP forums; wants the bile-acid thresholds (40, 100 µmol/L), the stillbirth-risk framing, and the delivery-timing logic explained honestly. |
| **Tech context** | Web-first, phone-heavy; opens the app **many times a day and especially at night** when itching peaks and she can't sleep. On a raised-surveillance pathway (repeat bloods, extra growth/CTG monitoring, planned early birth). |
| **Emotional state** | **High, sustained anxiety + sleep deprivation + physical misery.** Fears: stillbirth, an early/NICU baby, and the helpless "the itch doesn't match my numbers so how do I know it's safe?" feeling. The itch itself is exhausting and isolating ("it looks like nothing, but it's unbearable"). |
| **What she is NOT** | Not a BP/pre-eclampsia persona (D6 — though she inherits the same *calm monitoring + red-flag* pattern), not a diabetic-pregnancy persona (D3/D4), not general low-risk D1 (though she keeps every D1 feature). ICP can **co-occur** with pre-eclampsia/GDM — handled as a blend in §J. |
| **Success = she leaves us when…** | She delivers safely (often a **planned early birth ~36–39 wks**) → **postpartum (E1)**; itch and bile acids **usually resolve within days–weeks**, so the monitoring overlay winds down, **but** she carries forward *recurrence education* and a *postpartum bile-acid recheck* awareness note. She felt heard about the itch, informed about her numbers, and safely routed to care every time it mattered — never diagnosed, never falsely reassured. |

**Persona thesis.** D16 is **D1 plus a calm symptom-and-lab monitoring overlay tuned to a condition where the danger is invisible.** Unlike pre-eclampsia (D6), the severity of ICP does **not** track how bad the itch feels — it tracks a lab number the app must never interpret. So D16's value is threefold: (1) **take the itch seriously** with a real itch/symptom log (validation + a record to show her clinician), (2) **let her record her bile-acid and liver results** as her own data with zero interpretation, and (3) **an unmissable red-flag + reduced-fetal-movement layer** because the fetal risk is real and time-sensitive. The failure mode is *any hint of "your itch/number is fine (or dangerous)," any implied all-clear, or dismissing the itch.* This is near-total whitespace: essentially **no consumer app supports ICP**.

---

## B. Needs & questions (voice-of-user)

Mined from ICP Care and ICP Support communities/FAQs, r/cholestasis and r/BabyBumps, Tommy's/British Liver Trust forums, and pregnancy-app reviews. Phrasing is representative/composite (community norms; not quoting individuals). **The itch, the numbers, and stillbirth fear dominate.**

**The itch itself (the defining, under-validated need)**
- *"My hands and feet itch so badly at night I've scratched them raw — nothing helps and I can't sleep."*
- *"There's no rash, so people think I'm exaggerating, but it's unbearable."*
- *"Is itching all over normal or is this the liver thing?"*
- *"What actually soothes the itch — cold, creams, anything?"* (→ general comfort info only; never a dose)

**Bile-acid numbers & "what do they mean?"**
- *"My bile acids came back at 45 — is that bad? What's the number where it gets dangerous?"*
- *"They keep repeating my bloods weekly and I can't keep the results straight."*
- *"My itch is awful but my levels are 'only' 30 — does that mean I'm safe?"* (the dangerous mismatch — itch severity does **not** track risk)
- *"What's the difference between mild, moderate and severe ICP?"*

**Stillbirth fear (the acute emotional core)**
- *"I read ICP causes stillbirth — how worried should I be?"*
- *"Why can't they just deliver me now?"*
- *"At what level do they deliver early?"*
- *"Baby feels quieter today and I'm terrified because of the ICP."*

**Medication (ursodeoxycholic acid / UDCA)**
- *"I've been put on urso — what is it, does it actually help the baby or just the itch?"* (→ never dose; cite that evidence shows it eases maternal itch, benefit to baby is uncertain; "your clinician manages this")
- *"I keep forgetting my urso doses — I need reminders."*
- *"Is it safe? What about vitamin K they mentioned?"*

**Monitoring & the delivery plan**
- *"I have weekly bloods, extra scans and CTGs — what are they all for?"*
- *"They're planning to induce me at 37 weeks — why, and will my baby be okay that early?"*
- *"How long can they safely let me go?"*

**Postpartum & the future**
- *"Will the itch go away after birth?"* (usually yes, within days)
- *"Will I get ICP again next time?"* (70–90% recurrence — big unanswered question)
- *"Can I take the pill afterwards, or will it bring the itch back?"* (estrogen-containing contraception caution)

**Anti-needs / trust-breakers (churn + safety risk):**
- Any app that **interprets** a bile-acid number or the itch ("your level is fine / dangerous," "your ICP is mild so relax") — diagnosis, and dangerous given the itch–severity mismatch.
- **False reassurance** ("itching is just a normal pregnancy thing") on what could be ICP or on a red-flag symptom.
- **Dismissing the itch** as trivial — the #1 emotional wound of this condition.
- **Scare-content / doom-scrolling** about stillbirth — she is already terrified; alarmist copy is harmful.
- Privacy dread — a diagnosed pregnancy complication is highly sensitive.
- Reminders that keep firing after an early delivery or a loss.

---

## C. Competitor teardown

**Key insight for Femio:** ICP is **almost entirely unserved by consumer software.** The market splits into (1) **consumer pregnancy trackers** (broad, ad-heavy, no ICP concept at all — itching is at most a generic symptom tag), and (2) **excellent non-profit information sites** (ICP Care, ICP Support, Tommy's) that explain the condition beautifully but offer **no personal tracking** — no itch log, no way to record serial bile-acid results, no structured red-flag layer tied to *her* data. **No trustworthy, privacy-first, multilingual consumer app combines calm ICP *education* + an *itch/symptom log* + *bile-acid result entry* + an unmissable *red-flag / reduced-movement layer* without either overreaching into interpretation or being a static leaflet.** That is D16's whitespace — and, as with D6, the safety discipline is the moat: the moment an app *interprets* a bile-acid value it enters diagnosis / medical-device territory, which Femio deliberately does **not** do.

| App / resource | Category | Itch/symptom log | Bile-acid result entry | ICP-specific education | Red-flag / reduced-movement layer | Interprets data? | Privacy / positioning |
|---|---|---|---|---|---|---|---|
| **What to Expect** | Consumer pregnancy | Generic symptom tags only | No | Shallow article, if any | Generic warning-sign articles | No | Reported data sale to 3rd parties for ad targeting |
| **BabyCenter** | Consumer pregnancy | Generic | No | Shallow | Generic | No | Sells data; named in 2024 US Senate data-broker inquiry |
| **Pregnancy+ (Philips)** | Consumer pregnancy | Generic | No | Shallow | Generic | No | Reported ad-sharing (Facebook/Google) |
| **Ovia Pregnancy** | Consumer pregnancy | Light symptom logging | No | Minimal | Symptom-checker-ish nudges | Borderline | Labcorp-owned; **employer/health-plan versions** raise complication-status-visibility concern |
| **Flo (pregnancy mode)** | Consumer cycle→pregnancy | Symptom/weight logging | No | None meaningful | Generic | No | 2021 FTC settlement; "Anonymous Mode" mitigates, not eliminates |
| **ICP Care** (icpcare.org) | **Non-profit info + advocacy** | No personal log | No | **Best-in-class, patient + clinician** | Educational warning info | No | Trustworthy, mission-driven — but **information only, no tracking, English-centric** |
| **ICP Support** (UK) | **Non-profit info + advocacy** | No personal log | No | **Excellent, UK-oriented** | Educational | No | Trustworthy — **information only, no tracking** |
| **Tommy's / British Liver Trust** | Charity info | No | No | Good ICP explainer | Educational | No | Trustworthy — **static content, no tools** |

**What each camp gets wrong for D16:**
- **Consumer pregnancy apps:** ICP does not exist in their model; "itching" is a throwaway tag with no seriousness, no reduced-movement linkage, no way to hold serial lab results, ad clutter around a frightening condition, and privacy exposure.
- **Non-profit info sites:** genuinely authoritative and compassionate — Femio should *cite and defer* to them — but they are **read-only**: no itch trend she can show her midwife, no lab-result timeline, no personalized red-flag layer, no lifespan continuity, and mostly English-only.

**Femio's differentiated position for D16 (whitespace, held safely):**
1. **The first real ICP itch/symptom log** — timing (esp. nighttime), body areas (hands/feet/all-over), severity, sleep impact — a record that **validates her experience** and that she can **export/show her clinician**, with **zero interpretation** (Femio never says the itch means anything).
2. **Bile-acid + liver-result entry, entry-only** — she can hold her serial results (bile acids µmol/L, ALT/AST) as a timeline; the app **never** scores, colors, or verdicts them. Educational thresholds appear only as fixed reference content.
3. **The clearest, calmest red-flag + reduced-fetal-movement layer in the category** — CDC/NHS/ACOG warning signs + ICP-specific fetal-movement emphasis, "seek care now," saved maternity/emergency contact, one tap — never buried, never alarmist, **never** an all-clear.
4. **Referenced, honest ICP education** (itch, bile-acid thresholds, stillbirth-risk framing, UDCA context, delivery timing, recurrence) at grade 6–8, cited Tier-1/Tier-2, in **AR-first + EN/FR/ES**.
5. **Privacy-by-design** — no data sale, no ad-SDKs, **no employer/insurer visibility**.
6. **One account, full continuity** — layered on D1; carries into **postpartum (E1)** with recurrence + postpartum-recheck awareness, and **flags recurrence** on a future pregnancy.

---

## D. Clinical grounding (cited)

> All figures below are **patient education, not medical advice**. Femio content is medically reviewed and cited to primary sources. Femio **does not diagnose, treat, or prevent**; it educates and helps her track. Thresholds are shown so she knows *when clinicians act and when to seek care*, **never** so the app can label her itch or her bile-acid number.

**What ICP is (educational definition).** Intrahepatic cholestasis of pregnancy (ICP; also *obstetric cholestasis*) is the **most common liver disorder specific to pregnancy.** Bile acids build up in the blood, usually in the **late second or third trimester**. The hallmark is **itching (pruritus) without a rash**, classically on the **palms and soles**, often **worse at night**, though it can be anywhere (wrists, ankles, limbs, scalp, all over). Diagnosis is by **raised serum bile acids** (± raised liver transaminases) in a pregnant person with otherwise-unexplained itching. Occasionally there is jaundice, dark urine, or pale stools. Symptoms and bloods **usually resolve within days to a few weeks after birth.** [MedlinePlus Genetics; StatPearls; RCOG Green-top 43; ICP Care; SMFM Consult #53]

**Bile-acid thresholds & severity bands (shown as *education*, so she understands the plan — the app never applies them to her result).** Common classification: **mild = peak bile acids 19–39 µmol/L; moderate = 40–99 µmol/L; severe = ≥100 µmol/L.** [RCOG Green-top 43]

**Stillbirth risk by bile-acid level (the honest, calming-but-truthful core).** From the **2019 Ovadia et al. Lancet meta-analysis (~5,269 ICP pregnancies)**: stillbirth prevalence was **~0.13% for bile acids <40 µmol/L**, **~0.28% for 40–99 µmol/L**, and **~3.4% for ≥100 µmol/L** — i.e., the excess risk is concentrated at **peak bile acids ≥100 µmol/L**. RCOG patient framing: with levels **19–39 µmol/L** and no other risk factors, stillbirth chance is **no different** from someone without ICP; **40–99 µmol/L**, similar until **38–39 weeks**; **≥100 µmol/L**, higher — around **3 in 100** after 36 weeks if untreated by timing. → App framing: present as **honest context that explains why clinicians monitor and plan timing**, never as a personal risk score. [Ovadia et al., Lancet 2019; RCOG Green-top 43; The ObG Project]

**Itch severity does NOT track fetal risk (a safety-critical teaching point).** The **intensity of itching does not correlate with bile-acid level or with the severity of disease** — a person can itch intensely with low levels, or mildly with high levels. This is *exactly* why Femio must never let the itch log imply safety or danger, and why blood monitoring matters. [ICP Care; StatPearls]

**Diagnosis / who gets investigated.** SMFM recommends **measuring serum bile acids and liver transaminases** in patients with suspected ICP; itching without a rash in the second/third trimester should prompt testing. Femio's role: encourage anyone with unexplained pregnancy itching to **contact their clinician for bloods** — screening framing, never a diagnosis. [SMFM Consult #53 (GRADE 1B); RCOG]

**Ursodeoxycholic acid (UDCA / urso) — educational context only, never a Femio instruction or dose.** UDCA is the **first-line medication** used for ICP; guidelines note it **improves maternal itching and liver biochemistry**, while its benefit in reducing *fetal/perinatal* risk is **less certain** (large trials such as PITCHES showed limited effect on the main perinatal outcomes). Dose, choice, starting, and stopping are **clinician decisions**. Some clinicians also discuss **vitamin K** in certain cases. → App framing: *"Ursodeoxycholic acid is the medicine most commonly used in ICP. Whether it's right for you, and the dose, are decisions only your clinician makes."* **No dosing calculator, ever.** [SMFM Consult #53 (GRADE 1A); RCOG Green-top 43; PITCHES trial (Lancet)]

**Antenatal monitoring.** Because ICP raises fetal risk, patients are placed on **increased surveillance** — often **serial/weekly bile-acid + liver bloods** and **additional fetal monitoring** (growth scans, CTG). SMFM: begin antenatal fetal surveillance appropriate to gestation/at diagnosis. Femio helps her **hold and organize** these results and appointments as her own notes — it never interprets them. [SMFM Consult #53; RCOG Green-top 43]

**Timing of delivery (calm, factual — never an app countdown or prediction).** Delivery is individualized and clinician-decided:
- **Bile acids ≥100 µmol/L (severe):** delivery commonly **offered around 35–36 weeks** (SMFM: **36 0/7 weeks**), because stillbirth risk rises around then.
- **Bile acids <100 µmol/L:** delivery commonly **between 36 0/7 and 39 0/7 weeks**, depending on levels, symptoms, and other factors.
→ Frame supportively as *"why an early planned birth is often recommended,"* never as a fixed date or prediction Femio generates. [SMFM Consult #53 (GRADE 1B/1C); RCOG Green-top 43; Ovadia et al. 2019]

**Fetal-movement awareness (elevated importance here).** As in all pregnancy, a **change or reduction in the baby's movements = contact the maternity unit today, don't wait** — foregrounded more prominently in D16 because of the ICP fetal-risk context. Femio's kick/movement awareness (from D1) is surfaced earlier and more clearly. [CDC "Hear Her"; RCOG; SMFM]

**Postpartum resolution & recheck.** Itching typically **eases within ~48 hours** of birth and bloods normalize within **2–4 weeks.** Guidance commonly recommends a **postpartum bile-acid / liver recheck (e.g., ~6–12 weeks / by ~3–6 months)**; **persistently raised** levels warrant further evaluation for underlying liver disease. → seeds the postpartum awareness note (§J). [StatPearls; SMFM Consult #53; RCOG]

**Recurrence & contraception.** ICP **recurs in ~70–90%** of future pregnancies — important, calm forward-education (not alarm). A history of ICP is also relevant to contraception: **estrogen-containing hormonal contraception can occasionally provoke cholestasis** and is used with caution; **progestin-only** options carry lower risk — all **clinician decisions**, framed educationally. [StatPearls; SMFM Consult #53; medscape/emedicine]

**Emotional dimension (design-relevant).** ICP combines **severe sleep-disrupting itch, stillbirth fear, and the distress of an "invisible," dismissed symptom** — a heavy anxiety + validation burden. Tone must be **calming, validating, and non-dismissive**, never alarmist. [ICP Care community; Tommy's]

**Resolved source set.** Core clinician education links to [RCOG Green-top Guideline 43 (2022)](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/intrahepatic-cholestasis-of-pregnancy-green-top-guideline-no-43/) and [SMFM Consult Series 53](https://publications.smfm.org/publications/374-society-for-maternal-fetal-medicine-consult-series-53/) (DOI 10.1016/j.ajog.2020.11.002). Femio does not reproduce a delivery-timing table, interpret bile acids, or provide local fasting/reference ranges in global copy. Clinician-entered schedules and the laboratory’s own units/reference interval are recorded only. Global urgent routing follows [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md); any MENA clinical module requires local sign-off before activation. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

> **All of D1's feature set is inherited and stays fully available** (week-by-week home, referenced library, kick counter, weight guidance, appointment/checklist tracker, etc.). D16 *adds and re-prioritizes* a symptom-and-lab monitoring + safety overlay, sharing the D6 pattern but tuned to ICP.

**P0 — must-have (the D16 overlay):**
1. **Itch / symptom log** — quick entry for **itch severity** (simple scale), **body areas** (hands/palms, feet/soles, all-over, other), **timing** (esp. night), **sleep impact**, plus jaundice/dark-urine/pale-stool/nausea/upper-right-pain flags. **Trend chart**, **export (PDF)** for her clinician. **Zero interpretation** — Femio never says the itch means her ICP is better/worse or safe/unsafe. (See §G, §K.)
2. **Bile-acid & liver-result entry (ENTRY-ONLY)** — she records serial results (**bile acids in µmol/L**, **ALT/AST**, date, fasting/non-fasting note) as **her own data**; displayed as a **plain timeline/table with no color-coding, no zones, no verdict**. Educational threshold reference (19–39 / 40–99 / ≥100) available *as content only*, never applied to her value. (See §G, §K.)
3. **Prominent, persistent red-flag / "seek care now" layer** — always one tap from home; **reduced/changed fetal movement foregrounded**; saved **maternity-unit + emergency contact**; localized emergency guidance.
4. **Medication tracker (UDCA + others)** — list clinician-prescribed meds (name/time), **reminders**, adherence log; educational "what UDCA is" card. **No dosing, no changes suggested.**
5. **Appointment / monitoring-schedule tracker** — repeat-bloods dates, growth scans, CTG/monitoring, "questions to ask"; log results as **her own notes**; reminders.
6. **Calm, cited ICP education hub** (see §F) — foregrounded on the D16 home.

**P1 — high value:**
7. **Fetal-movement / kick awareness** foregrounded earlier and more prominently than in D1 (reduced movement is the key fetal red flag here).
8. **Itch-comfort self-care guide** — general, in-scope comfort measures (cool environment, cotton, etc.) framed as *comfort only, not treatment*; never a medication/dose.
9. **Partner/shared view (X2)** — partner sees the red-flag guidance + (opt-in) itch/symptom summary, so a second person understands the plan and can help her act.
10. **Log export bundle** (itch/symptom + bile-acid timeline + meds + appointments) as a PDF for her clinician.

**P2 — later / differentiators:**
11. **Postpartum wind-down + awareness** — supports the usual resolution, surfaces the **postpartum bile-acid-recheck** reminder and **recurrence** education (the E1 tail; not an ongoing high-risk mode).
12. Gentle, privacy-safe curated Q&A (only if moderation quality is guaranteed).

**Explicitly OUT of scope for D16 (guardrail):**
- **Any interpretation, scoring, or classification of a bile-acid/liver value or of the itch** ("your level is mild/severe/dangerous," "your itch means your ICP is worse," "you have ICP," "your baby is fine / at risk"). **Never.** That is diagnosis + medical-device territory.
- Any **dosing calculator** or medication advice/changes (incl. UDCA, vitamin K).
- Any **stillbirth-risk score or delivery-date prediction** presented as a personal verdict/countdown (education/context only).
- **False reassurance** on the itch or on any red-flag symptom; any implied "all-clear."

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Every card cites Tier-1/Tier-2 sources and carries "not medical advice / discuss with your clinician." Tone: **calm, honest, validating, non-alarmist, non-dismissive.**

- **"What is ICP (obstetric cholestasis)?"** — plain-language definition, that it's a liver condition of pregnancy, that it's monitored and clinicians manage it, that itch/bloods usually resolve after birth (reassurance without minimizing).
- **"The itch — why it happens and that it's real"** — validating; hands/soles, worse at night, no rash; *comfort* measures (not treatment); **explicitly: the itch does not tell you how serious your ICP is — that's why bloods matter.**
- **"Understanding bile-acid numbers"** — what 40 and 100 µmol/L mean *as clinical reference points* and the mild/moderate/severe bands; explicitly "these are for context, not for you to judge your own result; your clinician reads your results."
- **"ICP and stillbirth risk — the honest picture"** — the Ovadia/RCOG framing (risk concentrated at ≥100 µmol/L; why monitoring + planned timing lower it); calm, truthful, **not** doom.
- **"Warning signs — when to seek care now"** — the CDC/NHS/ACOG list **plus ICP-specific reduced-fetal-movement emphasis**, always reachable; the anchor of the persona.
- **"Fetal movements & why they matter here"** — reduced/changed movement = contact maternity unit today; foregrounded.
- **"Ursodeoxycholic acid (urso), explained"** — what it is, that it commonly eases itch/bloods, honest note that fetal-outcome benefit is less certain, "your clinician decides" (educational, never an instruction or dose).
- **"Your monitoring — bloods, scans and CTG"** — what repeat bile-acid/liver bloods, growth scans and CTG are for (screening framing).
- **"Planned early birth — what to expect"** — why induction/early delivery is often recommended (≥100 → ~35–36 wks; <100 → ~36–39 wks), calm prematurity/late-preterm and NICU basics; "your team plans the timing for you and baby."
- **"After the baby — will it go away?"** — usual resolution within days–weeks; the **postpartum bile-acid recheck**; when persistent levels need follow-up.
- **"Will it happen again? (recurrence) & contraception"** — ~70–90% recurrence, calm forward-planning; estrogen-contraception caution / progestin-only lower risk (clinician decision).
- **"Coping with the worry and the sleepless nights"** — validating the itch + fear + exhaustion; grounding/calming; when low mood needs support (soft EPDS pointer = "screening, discuss with clinician").
- **Reachable-but-hidden:** the full D1 week-by-week library and all lifespan content remain searchable — she is never boxed into "ICP only."

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs (inputs):**
- **Itch / symptom log** {itch_severity (scale), body_areas[hands/palms, feet/soles, arms/legs, all-over, other], timing[day/night], sleep_impact, plus flags: jaundice, dark_urine, pale_stools, nausea, upper_right_abdominal_pain — timestamped}.
- **Bile-acid & liver-result log (ENTRY-ONLY)** {bile_acids_umol_l, ALT, AST, sample_date, fasting/non-fasting note} — **stored raw; never scored, never zoned, never verdicted.**
- **Medication log** {name, schedule, taken/missed} incl. **UDCA/urso** and any others (e.g. vitamin K if recorded).
- **Appointment/test-results log** (repeat bloods, growth scans, CTG — user notes).
- Fetal-movement notes (foregrounded), weight, mood (continuous with D1).

**Tools:**
- **Itch/symptom trend chart** (values over time; **no "better/worse" judgement**), **bile-acid/liver timeline** (plain table/graph, **no zones/verdicts**), **PDF export bundle**, medication reminders, appointment/monitoring scheduler, kick/movement awareness (from D1), itch-comfort self-care guide.

**Mandatory compliance wording on the itch log and the bile-acid/liver log (every relevant surface):**
- On the itch log: *"This is your personal record. Femio can't tell you what your itching means — and importantly, how bad the itch feels does not tell you how serious ICP is. Only your clinician, using your blood tests, can judge that."*
- On the bile-acid/liver log: *"This is your personal record — Femio does not read or judge your results. Only your clinician can interpret your bile-acid and liver numbers."* The timeline shows her numbers **without** any normal/abnormal overlay. An **always-visible** static reference note: *"Clinicians treat bile acids of 100 µmol/L or above as the highest-risk group and often plan earlier birth. These numbers are for context only — they are not a judgement of your result. If you have any warning sign or your baby is moving less, contact your maternity unit or emergency number now."*

**Alerts / nudges (all opt-in, calm, revocable):**
- Itch/symptom-log nudges, medication/UDCA reminders, repeat-bloods & appointment reminders, kick/movement-awareness prompts.
- **No** alert is ever triggered by *interpreting* a value (no "your bile acids are high," no "your itch is worse" ← forbidden). Reminders are schedule-based only.

**Red-flag box pattern (reusable component — ICP-tuned):**
> **⚠ Seek care now**
> Contact your maternity unit or local emergency number **immediately** if: your **baby is moving less or differently than usual** · you have **yellowing of your skin or eyes (jaundice)**, **very dark urine** or **pale stools** · **severe or sudden upper-belly / right-rib pain** · you feel **generally very unwell** · or you have any pregnancy warning sign (severe headache, vision changes, heavy bleeding, fluid leaking, fever, trouble breathing) · or **thoughts of harming yourself**.
> *You know your body best — if something feels wrong, get it checked now. Itching that won't go away, especially on your hands and feet, is worth telling your maternity team so they can test for ICP. This app can't diagnose or treat.*
> [Call my maternity unit] [Emergency number] [Learn the warning signs]

**Placement:** persistent entry in nav; pinned on the D16 home; **auto-injected** at the bottom of every symptom explainer and **whenever a red-flag symptom (jaundice/dark urine/pale stools/upper-right pain/reduced movement) is logged** (surfaced as guidance, never as "you have/your ICP is worse").

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1):**
- `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, units, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- Height; pre-pregnancy weight & BMI; menstrual/LMP history.
- Medical-history flags (liver disease, **prior ICP**, thyroid, diabetes, HTN, autoimmune) — **prior ICP sets the D16 recurrence-watch flag.**
- Medications, allergies, supplements; prior pregnancies/outcomes (gravida/para, **prior ICP / prior stillbirth** flags); emergency/maternity contact.

**D1 pregnancy fields (inherited):** `edd`/`gestational_age` (single source of truth for gating), confirmed-pregnancy date, singleton/multiple, blood type/Rh, prenatal-visit log, weight-gain series, kick/movement sessions.

**D16 persona-specific:**
- `icp_status` {itching-under-investigation / diagnosed-ICP — **as recorded by user from clinician**, an attribute, not an app diagnosis}, `icp_recurrence_flag` {bool, from prior-ICP history}.
- `itch_symptom_log[]` {itch_severity, body_areas[], timing, sleep_impact, jaundice/dark_urine/pale_stools/nausea/ruq_pain flags, timestamp}.
- `bile_acid_results[]` {value_umol_l, sample_date, fasting_flag} — **stored raw; never scored.**
- `liver_results[]` {ALT, AST, other, sample_date} — **entry-only.**
- `medications_active[]` {name, schedule, adherence[]} incl. `udca_urso` {flag, user-entered start}, optional `vitamin_k_noted`.
- `monitoring_schedule[]` {repeat-bloods dates, growth-scan dates, CTG/monitoring, cadence}, `med_reminders[]`, `bloods_reminders[]`.
- `fetal_movement_flag` (foregrounded), `planned_early_delivery_note` (user-entered, e.g. planned induction week — **not** an app prediction).
- `saved_maternity_unit`, `saved_emergency_contact`, `localized_emergency_number`.
- `postpartum_bile_acid_recheck_flag` (the E1 awareness tail), `log_export_history[]`.

*Data-minimization: collect only what powers a used feature; all logs user-deletable; diagnosed-condition status and lab values are **special-category data** with tightened retention/consent (§K).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Entry (layered on D1 — additive emphasis, never restriction):**
- D16 is reached from **D1** when the user **records a clinician diagnosis of ICP/obstetric cholestasis**, **logs persistent itching (esp. hands/feet, no rash) and indicates she is being investigated / has had bloods**, or **carries a prior-ICP history flag** (recurrence watch). See §J.
- Short, **editable/resettable** confirm step: *"You've told us you're being monitored for ICP (cholestasis). Want Femio set up to help you track your itch and symptoms, hold your blood results, and stay aware — while keeping your full pregnancy tracker?"*

**Home configuration for D16 (safety-forward, itch-aware):**
- **Hero re-order:** itch/symptom quick-log + trend, the **"seek care now" pinned card** (with reduced-movement emphasis), today's UDCA/medication reminder, next bloods/monitoring appointment, bile-acid timeline (entry-only).
- **Secondary:** the calm ICP-education hub; the inherited **D1 week-by-week card** stays present (she is still pregnant and wants it), just below the safety row.
- **Symptom quick-log** foregrounded; logging a red-flag symptom surfaces the red-flag box.
- **Tone:** calm, validating, uncluttered; explicitly **takes the itch seriously**; no alarmist visuals, no stillbirth doom-imagery.

**Hidden-but-reachable rule.** Nothing is locked. All D1 content/tools remain available and searchable. Itch/lab/medication tools are *surfaced* for D16 but reachable by anyone via the tools menu with an "usually used when a clinician is monitoring you for ICP" note. The recurrence/ICP flag **adds** emphasis; it never hides pregnancy content.

**Safety-forward defaults.** Red-flag + reduced-movement layer is **always on** for D16 and cannot be buried; the itch log and bile-acid/liver log **never** show an interpretive overlay regardless of settings; reminders are calm and schedule-based only.

**Continuity.** History (prior ICP) auto-seeds the recurrence-watch flag and D16 emphasis — no re-onboarding; a one-time "your history is here and private" note.

---

## J. Adaptation triggers (state transitions)

> **Universal events are inherited from the Master Adaptation Model §6** (positive test, loss/grief, mood-screen-high/crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). The table below specifies only the **D16-specific** transitions.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Enters D16 from D1 — ICP diagnosis recorded** | User records clinician dx of ICP / obstetric cholestasis | Additive: switch to D16 home emphasis; enable itch/symptom log, bile-acid/liver entry, med + monitoring tools; surface calm education + red-flag/reduced-movement layer. **Never** self-generate the diagnosis. | **D16** (from D1) |
| **Enters D16 — itching under investigation** | User logs persistent itching (esp. hands/feet, no rash) / notes she's awaiting bloods | Offer D16 setup; **encourage contacting clinician for bile-acid + liver bloods** (screening framing); foreground itch log + warning signs; keep all D1 content. **No diagnosis.** | **D16** (watch mode) |
| **Enters D16 — prior-ICP recurrence watch** | Prior-ICP history flag on a new pregnancy | Offer recurrence-aware D16 emphasis from booking; calm "it can recur (~70–90%) — here's what to watch and log"; itch log ready. | **D16** (recurrence watch) |
| **Bile-acid / liver result entered** | User records a lab value | Store **raw**; show on plain timeline; surface **fixed educational reference only** (never applied to her value); **no score, no verdict, no color.** | Stays in D16 (entry-only) |
| **Red-flag symptom logged (jaundice / dark urine / pale stools / RUQ pain / reduced movement / general unwell)** | User logs an ICP or pregnancy red-flag symptom | **Surface the "seek care now" box + saved maternity/emergency contact** as *guidance/education* — not a diagnosis, not triage, no "your ICP is worse / your baby is at risk" verdict. Log stays raw. | Emergency-escalation **messaging** (content, not clinical instruction) |
| **Overlap with pre-eclampsia / gestational HTN** | BP/PE flag recorded alongside ICP | Blend **D6** monitoring/red-flag emphasis with D16; unify red-flag layer; avoid double-counting. | **D6 ⊕ D16** blend |
| **Overlap with GDM / thyroid / multiples** | GDM, thyroid, multiples recorded | Additive blend with **D3/D4 / D7 / D9** as relevant; D16 safety + itch layer persists. | Blended emphasis |
| **Planned early / preterm delivery recorded** | User notes planned induction/early birth (often ~36–39 wks; ~35–36 if severe) | Calm late-preterm/NICU content; **never** frame as a countdown or app-generated date; transition on birth (below). | Content + → E1 |
| **Delivery / birth logged** | Birth recorded | Transition to **Postpartum (E1)**. Itch/bile acids **usually resolve within days–weeks**, so wind down the monitoring overlay; **carry forward** two awareness items: **(1) postpartum bile-acid/liver recheck** reminder (per clinician, e.g. ~6–12 wks) and **(2) recurrence + contraception education** for the future. Not an ongoing high-risk mode. | **E1** (+ recheck/recurrence awareness) |
| **Persistent postpartum itch / raised recheck noted** | Postpartum user logs ongoing itch or an elevated recheck result | Calm "this is worth following up — persistent levels can need further checks"; **no diagnosis**; keep entry-only lab log available. | **E1** clinician-referral messaging |

*All routes preserve one-account data continuity and always end with clinician-referral language, never a diagnosis. Emergency escalation is **messaging/education that routes her to real care** — Femio never itself triages, calls, or decides. Loss/stillbirth is handled by the **universal loss handler** (→ E6): instant suppression of all itch/lab/med/appointment/milestone reminders, Gentle Mode, grief resources, later optional PAL path.*

---

## K. Compliance flags

1. **No diagnosis, result interpretation, or personalized disposition (highest-priority guardrail).** Femio never classifies a bile-acid/liver value or itch; labels a result mild, severe, normal, or dangerous; diagnoses ICP; or states fetal status. Numeric severity bands are not shown as a consumer self-triage tool. Results are entry-only. Fixed pregnancy warning signs and reduced movement route the user to her maternity unit or local emergency services without interpreting ICP or advising her to stay home. Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md) and current Apple/Google health-app rules; regulatory classification remains a launch-market legal decision. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
2. **Itch-severity ≠ risk teaching is a safety requirement.** Content and the itch log must state that itch intensity does **not** track ICP severity, so the app never lets a "mild itch" imply safety or a "bad itch" imply danger.
3. **No prescribing / no dosing.** UDCA/urso and all medication (incl. vitamin K) content is **general and cited**; dosing, choice, starting, stopping defer to the clinician. **No** dosing calculator. UDCA framing is honest: eases maternal itch/bloods, fetal-benefit uncertain.
4. **Fetal-risk / red-flag framing.** ICP red-flags (reduced fetal movement, jaundice, dark urine/pale stools, upper-right pain, feeling very unwell) get **prominent, calm "seek care now"** framing with the user's maternity/emergency contact — **never** false reassurance, **never** alarmist doom, **never** a diagnosis. Stillbirth-risk content is **honest but calm**, framed to explain *why monitoring + planned timing help*.
5. **Screeners = "screening, discuss with clinician."** Bile-acid/liver testing, fetal surveillance, EPDS — all framed as screening/context, never verdicts. Persistent itching → "worth asking your clinician to test," not "you have ICP."
6. **Emotional safety.** High-anxiety + sleep-deprived + often-dismissed persona; tone must be **validating, calming, and non-dismissive of the itch**, no scare-content, no stillbirth-doom imagery.
7. **Privacy-by-design (GDPR/PDPL — special-category health data).** A diagnosed pregnancy complication + lab values is highly sensitive. **No data sale, no ad-targeting SDKs, no employer/insurer visibility.** Explicit, granular, revocable consent; strong retention limits; user-deletion of itch/lab/med logs; partner sharing opt-in and scope-limited.
8. **Reminder suppression on loss / early exit.** Itch/lab/med/appointment/milestone reminders must **instantly stop** on logged loss (universal E6 handler) or withdrawal.
9. **Postpartum continuity is a safety feature.** Even though ICP usually resolves, the **postpartum bile-acid recheck** reminder and **recurrence + contraception** education must carry into E1 — dropping them would miss the persistent-liver-disease and next-pregnancy cases.
10. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIH/MedlinePlus/StatPearls/NHS) + Tier-2 (RCOG Green-top 43, SMFM Consult #53, ICP Care/ICP Support, Ovadia/PITCHES), grade 6–8, localized in 4 languages with **human-reviewed** RTL parity (clinical stakes forbid machine-only translation of safety copy).
11. **Publication control.** The canonical RCOG/SMFM sources are pinned above. Delivery timing, treatment-effect figures, bile-acid units/reference ranges, and MENA-specific guidance are not published from this global persona; they require a separately approved country/clinician module. Urgent destinations use the maintained global crisis/emergency routing policy. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Tier-1 (NIH / MedlinePlus / StatPearls / NHS):**
- [MedlinePlus Genetics — Intrahepatic cholestasis of pregnancy](https://medlineplus.gov/genetics/condition/intrahepatic-cholestasis-of-pregnancy/)
- [StatPearls (NCBI) — Pregnancy Intrahepatic Cholestasis](https://www.ncbi.nlm.nih.gov/books/NBK551503/)
- [PMC/NIH — Intrahepatic cholestasis of pregnancy (review)](https://pmc.ncbi.nlm.nih.gov/articles/PMC1891276/)
- [PMC — Prolonged and Recurrent Intrahepatic Cholestasis of Pregnancy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10651348/)
- [CDC — Urgent Maternal Warning Signs & Symptoms (HEAR HER)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)

**Tier-2 (RCOG / SMFM / ACOG / ICP Care / ICP Support / SOGC):**
- [RCOG — Intrahepatic Cholestasis of Pregnancy (Green-top Guideline No. 43)](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/intrahepatic-cholestasis-of-pregnancy-green-top-guideline-no-43/)
- [RCOG — Intrahepatic cholestasis of pregnancy (patient information)](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/intrahepatic-cholestasis-of-pregnancy/) · [RCOG patient leaflet (PDF)](https://www.rcog.org.uk/media/pldp0w40/pi_icp_updated-link.pdf)
- [SMFM — Consult Series #53: Intrahepatic Cholestasis of Pregnancy (AJOG full text)](https://www.ajog.org/article/S0002-9378(20)31284-9/fulltext) · [SMFM publications page](https://publications.smfm.org/publications/374-society-for-maternal-fetal-medicine-consult-series-53/) · [SMFM Consult #53 summary (ObG Project)](https://www.obgproject.com/2020/12/26/smfm-recommendations-intrahepatic-cholestasis-of-pregnancy/)
- [SMFM vs RCOG guideline comparison (ScienceDirect)](https://www.sciencedirect.com/science/article/abs/pii/S2589933322002683)
- [SOGC — Guideline No. 452: Diagnosis and Management of ICP (2024, PDF)](https://www.jogc.com/article/S1701-2163(24)00441-9/pdf)
- [ICP Care — Symptoms of ICP](https://icpcare.org/intrahepatic-cholestasis-pregnancy/symptoms/) · [ICP Care — Treatment](https://icpcare.org/intrahepatic-cholestasis-pregnancy/treatment/) · [ICP Care — Delivery Timing](https://icpcare.org/healthcare-provider/delivery-timing/) · [ICP Care — Interpretations of the 2019 meta-analysis](https://icpcare.org/icp-research/interpretations-of-the-2019-icp-meta-analysis/) · [ICP Care — Patient brochure (PDF)](https://icpcare.org/wp-content/uploads/2025/05/ICP-Patient-Brochure-English-rev-052825.pdf)
- [ICP Support (UK) — Symptoms](https://www.icpsupport.org/symptoms)

**Key evidence / trials:**
- [Ovadia et al. — Association of adverse perinatal outcomes of ICP with biochemical markers (Lancet 2019, aggregate + IPD meta-analysis)](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(18)31877-4/fulltext) · [Stillbirth-risk-by-bile-acid summary (ObG Project)](https://www.obgproject.com/2019/04/16/risk-of-stillbirth-with-intrahepatic-cholestasis-of-pregnancy-what-do-bile-acid-concentrations-tell-us/)
- [Chappell et al. — UDCA vs placebo / early vs expectant delivery (semifactorial RCT; PITCHES-lineage, PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3420230/)
- [PMC — Redefining the reference range of total serum bile acids in ICP](https://pmc.ncbi.nlm.nih.gov/articles/PMC9543426/)
- [PMC — Risk of Stillbirth in US Patients with Diagnosed ICP](https://pmc.ncbi.nlm.nih.gov/articles/PMC10651178/)

**Consumer clinical references (Tier-2/3, for tone/plain-language cross-check) & community:**
- [Cleveland Clinic — Cholestasis of Pregnancy](https://my.clevelandclinic.org/health/diseases/17901-cholestasis-of-pregnancy) · [Mayo Clinic — Cholestasis of pregnancy](https://www.mayoclinic.org/diseases-conditions/cholestasis-of-pregnancy/symptoms-causes/syc-20363257)
- [Tommy's — ICP / Obstetric Cholestasis](https://www.tommys.org/pregnancy-information/pregnancy-complications/obstetric-cholestasis) · [British Liver Trust — ICP](https://britishlivertrust.org.uk/information-and-support/liver-conditions/intrahepatic-cholestasis-pregnancy/) · [PUSH Pregnancy — ICP / stillbirth prevention](https://www.pushpregnancy.org/post/icp-intrahepatic-cholestasis-of-pregnancy)

*Community insight (ICP Care & ICP Support forums/FAQs, r/cholestasis, r/BabyBumps, Tommy's/British Liver Trust) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes.*

*Medical-source resolution: [RCOG Green-top 43 (2022)](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/intrahepatic-cholestasis-of-pregnancy-green-top-guideline-no-43/) and [SMFM Consult 53](https://publications.smfm.org/publications/374-society-for-maternal-fetal-medicine-consult-series-53/) are the source anchors. Global copy excludes delivery schedules, treatment-effect figures, and local laboratory thresholds; emergency routing follows [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
