# D8 — Pregnancy with a History of Prior Preterm Birth (High Risk for Recurrence; Being Monitored)

> Femio persona spec. Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent.** Preterm labour is **time-critical territory** — red-flag symptoms get prominent "seek care now" framing, but the app **NEVER diagnoses** and never tells her she is or isn't in labour. Screeners = *"screening — discuss with your clinician."* Progesterone, cerclage, cervical-length and medication content is **educational, never prescriptive**.
> Persona code: **D8** · Cohort: Pregnancy (D) · Layered on **D1** (uncomplicated pregnancy spine); monitoring-overlay pattern mirrors **D6** · Last research pass: 2026-07-17
> Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · 09_MASTER_ADAPTATION_MODEL · femio-compliance-privacy · femio-medical-content skills

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Rana," 31 |
| **Stage** | Pregnant, most engaged **T1→early T3**. Risk is set from booking (history-based), monitoring peaks in the **cervical-length surveillance window (~16–24 weeks)**, anxiety peaks approaching the gestation of her previous early delivery. |
| **Defining history** | **A prior spontaneous preterm birth** (delivery before 37 weeks) and/or a **mid-trimester loss (from 16 weeks)** — the single strongest predictor of recurrence. May also carry prior PPROM (waters breaking early) or a cervical-surgery/trauma history. |
| **Care context** | Usually referred to a **preterm-birth-prevention / high-risk clinic**: serial **transvaginal cervical-length scans**, and — as a clinician decision — possible **vaginal progesterone** and/or a **cervical cerclage (stitch)**. All of this is education-only in Femio. |
| **Relationship / support** | Partnered; wants partner informed and calm (X2 partner mode) — a possible early delivery and NICU stay affects the whole household. |
| **Goal (top JTBD)** | *"Help me get through this pregnancy without the same thing happening — help me understand my monitoring, learn the warning signs of early labour in plain language, keep my scans and medicines straight, and keep me calm and accurate. Never scare me, never pretend to be my doctor, and never tell me I'm 'fine' or 'in labour.'"* |
| **Health literacy** | Moderate–high, **driven by fear and by memory** of a traumatic prior birth. Researches obsessively ("is this the same feeling as last time?"). Wants sources, the "when to go in" lines, and to know what her monitoring actually means. |
| **Tech context** | Web-first, phone-heavy; opens the app often around scan days and as she nears the gestation her last baby arrived. May be counting down "get past X weeks this time." |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. MENA relevance high (preterm birth is a leading cause of newborn death; where NICU access is uneven, the "seek care now" routing matters even more). |
| **Emotional state** | **High, anticipatory, milestone-anchored anxiety** — often with a trauma tail from the previous birth. Fears: another early delivery, another NICU stay or loss, "will I notice in time?", and guilt/self-blame. Every twinge is re-lived. Passing the previous gestation is a huge emotional landmark. |
| **What she is NOT** | Not primarily a BP/pre-eclampsia persona (D6, though the overlay pattern is shared), not GDM (D3), not multiples-by-definition (D9, though multiples raise preterm risk and can co-flag). She keeps every D1 feature. |
| **Success = she leaves us when…** | She reaches a **term (or later-preterm) delivery → postpartum (E1)**; if the baby comes early, she transitions to **E1 with a NICU-aware / carried-complication tail (E4)** and felt watched-over, informed, and safely routed to care — never diagnosed, never falsely reassured, never scared by the app itself. |

**Persona thesis.** D8 is **D1 plus an anticipatory-anxiety + surveillance overlay**. She keeps the full week-by-week pregnancy spine, but her home is reorganized around **understanding her monitoring** (cervical-length scans, progesterone/cerclage context), an **unmissable preterm-labour red-flag layer**, **appointment/medication tracking**, and **calm milestone framing** ("one week further than last time"). Like D6, this is a persona where the guardrail is load-bearing: the value is *calm, cited education + frictionless logging + unmissable "seek care now" routing*, and the failure mode is *any hint that the app is diagnosing labour, interpreting a cervical-length number, or promising an outcome*. Femio must be the **calmest, most honest** thing on her phone.

---

## B. Needs & questions (voice-of-user)

Mined from r/BabyBumps, r/pregnant, r/PregnancyAfterLoss, incompetent-cervix / cerclage and "preemie" parent communities, and pregnancy-app reviews. Phrasing is representative/composite (community norms; not quoting individuals). **Anticipatory anxiety, milestone-counting, and "will I notice in time?" dominate.**

**"Will it happen again?" (the defining need)**
- *"My first came at 32 weeks — what are the actual odds it happens again, and does anything lower them?"*
- *"I'm terrified of the gestation my son was born. How do I get through those weeks?"*
- *"Was it my fault last time? Is there anything I did or can do differently?"* (guilt/self-blame — tone-critical)

**Understanding the monitoring**
- *"What is a cervical-length scan actually measuring, and what number is 'short'?"*
- *"They said my cervix is 28mm — is that okay? They're rescanning in two weeks."* (→ never interpret her number; explain the concept + "your clinician reads this")
- *"How often will I be scanned and until when?"*

**Progesterone / cerclage / pessary (educational)**
- *"They offered me progesterone OR a stitch — what's the difference?"* (wants a plain, non-directive explainer + "your clinician decides")
- *"How long do I stay on the progesterone?"*
- *"I have a cerclage — what can and can't I do, and when does it come out?"*
- *"Do I still need progesterone if I have the stitch?"*

**"Is this early labour right now?" (the acute, time-critical need)**
- *"Tightening every 8 minutes at 29 weeks — do I go in or wait?"*
- *"More discharge than usual and some cramping — is this a sign?"*
- *"I felt a gush — could my waters have broken this early?"*
- *"Dull backache that comes and goes — I can't tell if it's normal."*

**Tracking & keeping it straight**
- *"I have scans every two weeks plus growth scans — I can't keep the dates and results straight."*
- *"I want a graph of my cervical lengths to bring to my appointment."*
- *"I keep forgetting my progesterone — I need a reminder."*

**Prematurity / NICU fear**
- *"If the baby comes at 30 weeks, what happens? What's the NICU like?"*
- *"What do steroid injections for the baby's lungs do?"* (antenatal corticosteroids — educational)
- *"How many weeks do I need to reach for it to be 'okay'?"*

**Anti-needs / trust-breakers (churn + safety risk):**
- Any app that **interprets** a symptom or a cervical-length number ("you're in labour / you're fine / your cervix is dangerously short") — that's diagnosis and could cause harm either way.
- **False reassurance** ("don't worry, that's normal") on a possible-preterm-labour symptom.
- **Scare-content / doom-scrolling** and countdowns to disaster — she is already maxed out; alarmist copy is harmful.
- Milestone/"celebrate your bump!" nudges that ignore her fear, or reminders that keep firing after an early delivery or loss.
- Privacy dread — pregnancy + a flagged high-risk history is highly sensitive; she fears employer/insurer visibility and data sale.

---

## C. Competitor teardown

**Key insight for Femio:** the market splits into two camps that **do not meet** — consumer **pregnancy trackers** (broad, ad-heavy, generic "preterm labour" articles, no structured support for a *high-recurrence-risk* pregnancy) and **clinical preterm-birth-prevention pathways** (real cervical-length surveillance, progesterone/cerclage decisions — but locked inside a hospital/specialist clinic, not consumer-ownable). **No trustworthy, privacy-first, multilingual consumer app offers calm preterm-risk *education* + a personal *scan / symptom / medication log* + an unmissable *preterm-labour red-flag layer* + *trauma-aware milestone support*, without either overreaching into triage or requiring a clinical enrolment.** That gap is D8's whitespace. **Safety caution:** the moment an app *interprets* a symptom as labour, or a cervical-length value as safe/unsafe, it enters diagnosis / medical-device territory; Femio deliberately does **not** cross that line.

| App / tool | Category | Cervical-length / scan log | Preterm-labour red-flags | Prior-PTB-specific education | Trauma / milestone-anxiety support | Interprets? | Privacy / positioning |
|---|---|---|---|---|---|---|---|
| **What to Expect** | Consumer pregnancy | No | Generic warning-sign article | Shallow, article-level | Minimal | No | Reported data sale to 3rd parties for ad targeting |
| **BabyCenter** | Consumer pregnancy | No | Generic | Shallow | Minimal | No | Sells data; named in 2024 US Senate data-broker inquiry |
| **Pregnancy+ (Philips)** | Consumer pregnancy | No | Generic | Shallow | Minimal | No | Reported ad-sharing (Facebook/Google) |
| **Ovia Pregnancy** | Consumer pregnancy | Light health logging | Symptom-checker-ish nudges | Some risk-factor content | Weak | Borderline (nudges) | Labcorp-owned; **employer/health-plan versions** raise high-risk-status-visibility concern |
| **Flo (pregnancy mode)** | Consumer cycle→pregnancy | No | Generic | Shallow | Weak | No | 2021 FTC settlement; "Anonymous Mode" mitigates, not eliminates |
| **PregnancyAfterLoss / loss-support apps & forums** | Community/support | No | No | Some (loss-focused) | **Strong (peer support)** | No | Community-run; no structured tracking; moderation varies |
| **Hospital PTB-prevention clinic pathway** | **Clinical** | **Yes — core (serial TVUS)** | Pathway-embedded | Yes | Variable | **Yes — clinician-read** | Real surveillance + progesterone/cerclage decisions; **gated behind specialist referral; not consumer-ownable; not multilingual/RTL; no lifespan continuity** |

**What each camp gets wrong for D8:**
- **Consumer pregnancy apps:** no first-class scan/cervical-length log, no preterm-labour-specific red-flag layer, generic "signs of preterm labour" buried in an article, ad clutter around terrifying moments, and **nothing** for the trauma/milestone-anxiety that defines this persona.
- **Loss/after-loss communities:** genuinely strong for *emotional* support, but no structured education, no scan/medication tracking, no safety-routing layer, and variable moderation.
- **Clinical pathways:** safe and effective, but **locked behind specialist referral**, single-pathway, English-centric, no continuity across her life, and they *do* interpret/decide — which is exactly why they must be a regulated clinical service, not a general app.

**Femio's differentiated position for D8 (whitespace, held safely):**
1. **A self-owned scan + symptom + medication log** she controls — a **cervical-length series** and a **progesterone/cerclage tracker** she can **export/show her clinician** — with **zero interpretation** (no "your cervix is short/fine," no "you're in labour") → stays out of the diagnosis/medical-device lane.
2. **The clearest, calmest preterm-labour red-flag layer in the category** — CDC/MedlinePlus/NICHD warning signs, "even one sign → contact your provider now," her saved maternity/emergency contact, one tap — never buried, never alarmist.
3. **Referenced, honest, prior-PTB-specific education** (recurrence risk in plain terms, what cervical-length surveillance is, progesterone vs cerclage vs pessary as *options her clinician weighs*, PPROM, antenatal steroids, NICU basics) at grade 6–8, cited to Tier-1/Tier-2, **AR-first + EN/FR/ES**.
4. **Trauma-aware, milestone-anchored emotional support** — a *calm* "one week further than last time" framing she can opt into, validation of anticipatory anxiety and self-blame, and a soft, correctly-framed mental-health pointer — an angle **no competitor covers**.
5. **Privacy-by-design** — no data sale, no ad-SDKs, **no employer/insurer visibility** — decisive for a flagged high-risk history.
6. **One account, full continuity** — layered on D1; carries cleanly into **postpartum + NICU-aware / carried-complication follow-up (E1/E4)**, and honours any prior-loss history already in her record.

---

## D. Clinical grounding (cited)

> All figures below are **patient education, not medical advice**. Femio content is medically reviewed and cited to primary sources. Femio **does not diagnose, treat, or prevent**; it educates and helps her track. Thresholds and timings are shown so she knows *what her monitoring is* and *when to seek care*, **never** so the app can label her cervix, her symptom, or her risk.

**What preterm birth is (educational definitions).** Preterm (premature) birth is birth before **37 weeks** of pregnancy; about **1 in 10** babies in the US is born preterm. Sub-categories are described clinically as late preterm (34–36 wk), moderate (32–34), very (28–32) and extremely preterm (<28); earlier birth generally carries more risk to the baby. **Spontaneous** preterm birth (spontaneous labour or preterm prelabour rupture of membranes, PPROM) is distinct from medically-indicated early delivery. [CDC; MedlinePlus; NICHD; March of Dimes]

**Prior preterm birth as the key recurrence factor.** A **previous spontaneous preterm birth is the single strongest risk factor** for another one; a **mid-trimester loss (from ~16 weeks)**, prior PPROM, and cervical surgery/trauma also raise risk. This history is what places her in D8 and drives specialist monitoring. Framed supportively: *higher risk is not a verdict, and it is exactly why she is being watched closely.* [ACOG Practice Bulletin 234; NICE NG25; March of Dimes]

**Cervical-length surveillance (education — the app logs, never scores).**
- For women with risk factors (including prior sPTB/mid-trimester loss), **transvaginal ultrasound cervical-length measurement is offered between 16+0 and 24+0 weeks**; a **short cervix is commonly defined as ≤25 mm**, which is associated with increased preterm-birth risk. Borderline results (~25–30 mm) are often **rescanned every 2–4 weeks**. [NICE NG25; ACOG PB 234]
- App framing: *"A cervical-length scan measures how long your cervix is. Clinicians use around 25 mm as a point where they discuss extra options. Femio can record your measurements so you can see them and share them — but only your clinician can tell you what your number means for you."* **No zones, no colour-coding, no "short/fine" verdict.**

**Progesterone (educational context only — never a Femio instruction).**
- **NICE** offers women with a history of spontaneous preterm birth (up to 34+0 weeks) **or** mid-trimester loss (from 16+0 weeks) **and** a cervical length ≤25 mm on TVUS at 16+0–24+0 weeks a **choice of prophylactic vaginal progesterone or cervical cerclage**, as a shared decision; **vaginal progesterone is typically started 16+0–24+0 weeks and continued until at least 34 weeks**. [NICE NG25]
- **ACOG** describes **daily vaginal progesterone** as an option to reduce risk in patients with a short cervix and/or prior preterm birth, commonly framed from ~16–24 weeks until ~34–36 weeks. [ACOG PB 234]
- **17-hydroxyprogesterone caproate (17-OHPC / Makena):** the US FDA withdrew approval of Makena and its generics on 6 April 2023; they are no longer approved for distribution in US interstate commerce. Femio does not extrapolate US status to another country or suggest an alternative. Medication type, availability, eligibility, and regimen remain clinician/country decisions. [FDA decision, 6 April 2023](https://www.fda.gov/news-events/press-announcements/fda-commissioner-and-chief-scientist-announce-decision-withdraw-approval-makena). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
- App framing: *"Some people at higher risk are offered progesterone to help lower the chance of an early birth. Whether it's right for you, which type, the dose, and how long — those are decisions only your clinician makes."*

**Cervical cerclage / "stitch" (educational context only).**
- A **cerclage** is a stitch placed in the cervix. It may be considered where TVUS at 16+0–24+0 weeks shows a **cervical length ≤25 mm** together with a **prior sPTB (<34 weeks)**, or for a history of **PPROM or cervical trauma**; it is one of the options weighed against progesterone (and, in trials, cervical **pessary**). Some evidence explores **combined** cerclage + progesterone in selected cases. Timing, type (history-, ultrasound- or exam-indicated; rescue), and removal (commonly ~36–37 weeks or at labour) are clinician decisions. [NICE NG25; RCOG Green-top 75; ACOG PB 234; FIGO 2021]
- App framing: general "what a cerclage is / common questions" education + *"your clinician decides if, when, and what type."* **Never** an instruction, never a promise of outcome.

**Antenatal corticosteroids and magnesium (calm, factual, if early birth looms).** [NICE NG25, updated 10 June 2022](https://www.nice.org.uk/guidance/ng25/chapter/recommendations) describes when clinicians offer or consider corticosteroids for fetal lung maturation and magnesium sulfate for fetal neuroprotection. Femio explains the categories only and publishes no gestational window, course, dose, or timing instruction; the maternity team applies the current local guideline. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Signs of preterm labour → seek care now (populate the red-flag box, verbatim-in-spirit).** **Regular or frequent contractions** — the belly tightening/hardening every ~10 minutes or more often; a **low, dull backache** (constant or coming and going); **pelvic pressure** (feels like the baby is pushing down); **menstrual-like or abdominal cramps** (with or without diarrhoea); a **change in vaginal discharge** (watery, mucus-like, or bloody) or **more than usual**; and **fluid leaking or a gush from the vagina** (possible waters breaking). **Even one** sign or symptom before 37 weeks → **contact your provider or maternity unit right away; early treatment can help.** [CDC; MedlinePlus; NICHD; March of Dimes; ACOG] → *"You know your body best — if something feels off, get checked now. This app can't tell you whether this is labour."*

**Emotional dimension (design-relevant).** A user may experience anxiety, low mood, trauma reminders, or distress in a pregnancy after preterm birth or loss, but Femio does not assert that everyone will or predict a gestational “spike.” Tone is validating and calming; milestones are opt-in; self-blame is countered; concerning symptoms route to clinical support and urgent disclosures to [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

*Source register resolved:* [ACOG Practice Bulletin 234 (2021)](https://www.acog.org/clinical/clinical-guidance/practice-bulletin/articles/2021/08/prediction-and-prevention-of-spontaneous-preterm-birth), [NICE NG25 recommendations](https://www.nice.org.uk/guidance/ng25/chapter/recommendations), [RCOG Green-top Guideline No. 75](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/cervical-cerclage-green-top-guideline-no-75/), and the [FDA Makena withdrawal, 6 April 2023](https://www.fda.gov/news-events/press-announcements/fda-commissioner-and-chief-scientist-announce-decision-withdraw-approval-makena). Global copy gives no medicine/gestational-window instruction; urgent routing uses the country selector and local maternity/emergency destination, not a static MENA list. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

> **All of D1's feature set is inherited and stays fully available** (week-by-week home, referenced library, kick counter, weight guidance, etc.). D8 *adds and re-prioritizes* a surveillance + safety + emotional-support overlay. Where D6 centres on a BP log, D8 centres on **scan tracking, a preterm-labour red-flag layer, and milestone-anxiety support.**

**P0 — must-have (the D8 overlay):**
1. **Prominent, persistent preterm-labour red-flag / "seek care now" layer** — always one tap from home; the CDC/MedlinePlus/NICHD signs; "even one sign → contact your provider now"; saved **maternity-unit + emergency contact**; localized emergency guidance. **The anchor of the persona.**
2. **Symptom log with preterm-labour awareness** — tightenings/contractions, low backache, pelvic pressure, cramps, discharge change, fluid/leaking — each logged symptom that is a preterm-labour warning sign **surfaces the "seek care now" box**, never a reassurance, never a "you're in labour."
3. **Cervical-length / scan log** — record measurements (mm) and dates as a **trend series**, plus scan notes; **export (PDF) for clinician**. **Zero interpretation** — no zones, no "short/normal" verdict. Educational reference (the ~25 mm concept) available *as content*, never applied to her number.
4. **Progesterone & cerclage tracker** — log clinician-prescribed progesterone (name/type/time) with **reminders + adherence**; record a cerclage (placed date, planned removal) as **her own notes**. Educational "what this is / common questions" cards. **No dosing, no changes suggested.**
5. **Appointment / monitoring-schedule tracker** — serial cervical-length scans, growth scans, clinic visits; log results as **her own notes** (app never interprets); reminders; "questions to ask."
6. **Calm, cited prior-PTB education hub** (see §F) — foregrounded on the D8 home.

**P1 — high value:**
7. **Trauma-aware milestone support** — opt-in "progress" framing ("you're now further than last time" / "past [prior] gestation"), gentle and revocable; validation of anticipatory anxiety; soft, correctly-framed EPDS-style mental-health pointer (*"screening, discuss with clinician"*).
8. **Partner/shared view (X2)** — partner sees the red-flag guidance + (opt-in) scan/symptom/med summary, so a second person can help her act and stay calm.
9. **Fetal-movement / kick awareness** foregrounded (reduced movement is a general pregnancy red flag she should never ignore).
10. **Log export bundle** (cervical lengths + symptoms + meds + appointments) as a PDF for her clinic.

**P2 — later / differentiators:**
11. **NICU-aware postpartum tail (E1/E4)** — if the baby arrives early, calm NICU-orientation content + carried-complication follow-up, rather than dropping her into a generic postpartum flow.
12. Optional home-uterine-activity or device import (stored raw only; **never** interpreted — explicitly not a labour test).
13. Gentle, privacy-safe curated Q&A / moderated peer support (only if moderation quality is guaranteed).

**Explicitly OUT of scope for D8 (guardrail):**
- **Any interpretation, triage, or classification** of a symptom or cervical-length number ("you're in preterm labour," "your cervix is dangerously short / fine," "go in / stay home," "you'll deliver early"). **Never.** That is diagnosis + medical-device territory.
- Any **contraction-timer output that reads as a labour diagnosis** — the timer (inherited from D1) is a *timing aid only*; for D8 it must be paired even more firmly with "this is not a diagnosis of labour; if you have any warning sign, seek care now."
- Any **dosing calculator** or medication advice/changes; any directive to take (or not take) progesterone or have a cerclage.
- Any **risk-score verdict** or countdown-to-delivery presented as a conclusion (screening/education framing only).
- False reassurance on any red-flag symptom.

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Every card cites Tier-1/Tier-2 sources and carries "not medical advice / discuss with your clinician." Tone: **calm, honest, validating, non-alarmist.**

- **"You've had a preterm birth before — what that means for this pregnancy"** — plain-language recurrence context, that it's monitored, that being higher-risk is *why* she's watched closely; actively counters self-blame. (reassurance without minimizing)
- **"Signs of early labour — when to seek care now"** — the CDC/MedlinePlus/NICHD list; "even one sign → contact your provider now"; always reachable. The anchor of the whole persona.
- **"Cervical-length scans, explained"** — what a transvaginal scan measures, the ~25 mm reference point, why it's repeated; explicitly "these are for context — your clinician reads *your* scan; Femio just records it."
- **"Progesterone, explained"** — what it is, why some higher-risk people are offered it, vaginal vs injection context, "your clinician decides if, which, and how long." Educational, never an instruction; kept current on 17-OHPC status.
- **"Cervical cerclage (the stitch), explained"** — what it is, common questions (activity, sex, when it's removed), the alternatives (progesterone, pessary) as options her clinician weighs.
- **"PPROM — if your waters break early"** — what it is, why any suspected leaking/gush = seek care now.
- **"If your baby might come early"** — calm, factual: antenatal steroids for the baby's lungs, magnesium for brain protection, what the team plans; framed as "things your team may do," never app-timed.
- **"The NICU — a gentle overview"** — what a neonatal unit is, common support (breathing, feeding, warmth), that many preterm babies do well; orientation, not prognosis.
- **"Getting through the anxious weeks"** — validating anticipatory anxiety and the milestone of passing the previous gestation; grounding/calming; when low mood needs support (soft EPDS pointer = "screening, discuss with clinician"); honours prior-loss history if flagged.
- **"Fetal movements & why they matter"** — reduced movement = contact provider today (inherited emphasis from D1).
- **Reachable-but-hidden:** the full D1 week-by-week library and all lifespan content remain searchable — she is never boxed into "preterm risk only."

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs (inputs):**
- **Symptom log** {tightenings/contractions, low backache, pelvic pressure, cramps ± diarrhoea, discharge change, fluid/leaking, general unwell — timestamped}.
- **Cervical-length log** {measurement mm, gestation, scan date, notes} — **stored raw; never scored**.
- **Progesterone log** {type (vaginal/injection), schedule, taken/missed} + **cerclage record** {placed date, type as noted, planned removal}.
- **Appointment/test results** (user notes: scans, growth scans, clinic), weight, mood, fetal-movement notes (continuous with D1).
- **Contraction timer** (inherited from D1) {frequency/duration} — **timing aid only, never a labour diagnosis** (§K).

**Tools:**
- **Cervical-length trend chart** (values over time; **no zones/verdicts**), **PDF export bundle**, progesterone reminders, appointment/monitoring scheduler, kick-count (from D1), contraction timer (from D1, D8-tightened wording), opt-in milestone tracker ("weeks vs previous birth").

**Mandatory compliance wording (every relevant surface):**
- On the **cervical-length log:** *"This is your personal record — Femio does not read or judge your cervical length. Only your clinician can tell you what your measurement means."* Chart shows her numbers **without** any normal/short overlay; an always-visible static note explains the ~25 mm reference as **fixed education**, not an evaluation of her entry.
- On the **contraction timer / symptom log:** *"This is a timing and tracking aid, not a test of labour. Femio can't tell you whether you're in labour. If you have any sign of early labour, contact your maternity unit now."*
- On the **progesterone/cerclage tracker:** *"A record to help you remember — not medical advice. Your clinician manages your medicine and any procedure."*

**Alerts / nudges (all opt-in, calm, revocable):**
- Progesterone/medication reminders (times she sets), scan/appointment reminders, "log today's symptoms?" nudge, and **opt-in** gentle milestone acknowledgements.
- **No** alert is ever triggered by *interpreting* a value or symptom ("your cervix is short" / "this is labour" ← forbidden). Reminders are schedule-based only. Milestone nudges are **suppressible** and never celebratory in a way that ignores her fear.

**Red-flag box pattern (reusable component — preterm-labour-tuned):**
> **⚠ Seek care now**
> Before 37 weeks, contact your maternity unit or local emergency number **right away** if you have any of these — even just one: **regular or frequent tightenings/contractions** (your belly hardening every ~10 minutes or more often) · a **low, dull backache** that won't ease · **pressure low in your pelvis** (like the baby is pushing down) · **period-like or belly cramps** (with or without diarrhoea) · a **change in your discharge** — watery, mucus-like, bloody, or a lot more than usual · any **fluid leaking or a gush** (your waters may have broken) · your **baby moving less than usual**.
> *You know your body best — if something feels off, get checked now. This app can't tell you whether this is labour or diagnose you — but early care can help.*
> [Call my maternity unit] [Emergency number] [Learn the signs of early labour]

**Placement:** persistent entry in nav; pinned on the D8 home; **auto-injected** at the bottom of every relevant symptom explainer and **whenever a preterm-labour warning-sign symptom is logged** (surfaced as guidance, never as "you're in labour").

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1):**
- `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, units, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- Height; pre-pregnancy weight & BMI; menstrual/LMP history.
- Medical-history flags; **prior pregnancies/outcomes (gravida/para)** incl. **prior preterm birth / mid-trimester loss / PPROM / cervical-surgery-trauma flags — these set the D8 high-risk flag**; medications, allergies, supplements; emergency/maternity contact.

**D1 pregnancy fields (inherited):** `edd`/`gestational_age` (single source of truth for gating), confirmed-pregnancy date, singleton/multiple, blood type/Rh, prenatal-visit log, weight-gain series, kick-count sessions, contraction-timer sessions.

**D8 persona-specific:**
- `prior_ptb_history` {gestation of previous birth(s)/loss, spontaneous vs indicated, PPROM y/n, cervical-trauma y/n} — **the recurrence-risk basis; an attribute recorded from history, not an app risk verdict**.
- `ptb_monitoring_status` {high-risk-watch / cervical-surveillance / on-progesterone / cerclage-in-situ — **as recorded by user from clinician**}.
- `cervical_length_readings[]` {mm, gestation, date, note} — **stored raw; never scored**.
- `ptb_symptom_log[]` {type, note, timestamp}.
- `progesterone_record` {type, schedule, adherence[], user-entered start/stop}; `cerclage_record` {placed_date, type_note, planned_removal_date}.
- `monitoring_schedule[]` {scan/appointment type, date, cadence e.g. 2-weekly}, `med_reminders[]`, `scan_reminders[]`.
- `previous_birth_gestation` (drives opt-in milestone framing) and `milestone_opt_in` {bool}.
- `saved_maternity_unit`, `saved_emergency_contact`, `localized_emergency_number`.
- `nicu_awareness_flag` (foregrounds NICU content if early birth looms/occurs), `log_export_history[]`.

*Data-minimization: collect only what powers a used feature; all logs user-deletable; flagged high-risk history + any prior-loss data are **special-category data** with tightened retention/consent (§K).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Entry (layered on D1 — additive emphasis, never restriction):**
- D8 is reached from **D1** when the user **records a history of prior preterm birth / mid-trimester loss / PPROM / cervical trauma**, **notes she's under cervical-length surveillance or a preterm-birth-prevention clinic**, or **records progesterone / a cerclage**. It can also be **carried in automatically** if a prior-loss/prior-preterm flag already exists in her record. See §J.
- Short, **editable/resettable** confirm step: *"Because you've had an early birth before, your clinician may watch this pregnancy more closely. Want Femio set up to help you understand your monitoring, learn the warning signs, and keep your scans and medicines straight? (You keep your full pregnancy tracker too.)"* — worded to **reassure, not alarm**.

**Home configuration for D8 (safety- + calm-forward):**
- **Hero re-order:** the **"seek care now" pinned card** (early-labour signs), next scan/appointment, today's progesterone reminder, and (opt-in) the **milestone card** ("you're at X weeks — [n] weeks further than last time").
- **Secondary:** the calm prior-PTB education hub; cervical-length trend + symptom quick-log; the inherited **D1 week-by-week card** stays present (she is still pregnant and wants it), just below the safety/support row.
- **Symptom quick-log** foregrounded; logging a warning-sign symptom surfaces the red-flag box.
- **Tone:** calm, validating, uncluttered; **no alarmist visuals**, **no countdown-to-disaster**, no scary imagery. Milestone framing is gentle and opt-in.

**Hidden-but-reachable rule.** Nothing is locked. All D1 content/tools remain available and searchable. Scan/progesterone/cerclage tools are *surfaced* for D8 but reachable by anyone via the tools menu with an "usually used when a clinician is monitoring for preterm-birth risk" note. The high-risk flag **adds** emphasis; it never hides pregnancy content.

**Safety-forward defaults.** Red-flag layer is **always on** for D8 and cannot be buried; the cervical-length log **never** shows an interpretive overlay regardless of settings; the contraction timer always carries the "not a labour diagnosis" wording; reminders are calm and schedule-based only.

**Continuity.** History (prior preterm birth/loss, cervical surgery, PPROM) auto-seeds the high-risk flag and D8 emphasis — no re-onboarding; a one-time "your history is here and private" note. If a prior-loss emotional context is set, tone inherits **anxiety-/grief-aware** handling (aligns with D2/PAL and E6 sensitivities).

---

## J. Adaptation triggers (state transitions)

> **Inherits all universal events from the Master Adaptation Model §6** — positive-test entry, **pregnancy loss/stillbirth → instant reminder suppression + Gentle Mode + grief resources (E6)**, mood-screen-high/crisis routing, red-flag/severe-reading messaging, disengagement/"taking a break," toggle-mode-off, age-of-consent. The table below specifies only the **D8-specific** transitions.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Enters D8 from D1 — history recorded** | User records prior preterm birth / mid-trimester loss / PPROM / cervical trauma, or a carried prior-loss/preterm flag exists | Additive: switch to D8 home emphasis; enable scan/progesterone/cerclage + symptom tools; surface calm prior-PTB education + preterm-labour red-flag layer; set (opt-in) milestone framing from `previous_birth_gestation`. **Never** self-generate a risk verdict. | **D8** (from D1) |
| **Enters D8 — monitoring / treatment noted** | User notes cervical-length surveillance / PTB-prevention clinic, or records progesterone / a cerclage | Offer D8 setup ("your clinician may watch this pregnancy closely"); foreground scan log + warning signs + med reminders; keep all D1 content. | **D8** (watch mode) |
| **Preterm-labour warning-sign symptom logged** | User logs a preterm-labour red-flag symptom before 37 weeks (contractions, leaking/gush, discharge change, pelvic pressure, backache, cramps) | **Surface the "seek care now" box + saved maternity/emergency contact** as *guidance/education* — **not** a diagnosis, **not** "you're in labour," no "go in / stay home" verdict. Log stays raw. | Emergency-escalation **messaging** (content, not clinical instruction) |
| **Cervical-length measurement logged** | User records a scan value | Store raw, chart it; show fixed educational reference only; **never** flag it as short/normal or trigger an alert from the number. | Stay in **D8** |
| **Approaching / passing previous birth gestation** | GA nears or passes `previous_birth_gestation` (if `milestone_opt_in`) | Gentle, opt-in acknowledgement ("you're now past last time"); pair with the calm-anxiety module; **suppressible**; never celebratory in a way that ignores fear. | Stay + emotional-support emphasis |
| **Overlap with other pregnancy conditions** | Multiples (D9), high BP/PE (D6), GDM (D3), high BMI (D12), AMA (D13) recorded | Additive blend (multiples notably raise preterm risk); D8 preterm-labour safety layer persists alongside the other overlay. | Blended emphasis |
| **Early birth looms / antenatal steroids noted** | User records planned early birth or steroid/magnesium given | Surface calm antenatal-steroid/magnesium + NICU-orientation content; set `nicu_awareness_flag`; **do not** frame as countdown. | Content + prep for E1/E4 |
| **Preterm delivery logged** | Birth recorded before 37 weeks | Transition to **Postpartum (E1)** with a **NICU-aware / carried-complication tail (E4)** — NICU-orientation content, gentle tone, carried follow-up; honour any separation-from-baby reality; **do not** drop her into a generic postpartum flow. | **E1 + E4 (NICU-aware)** |
| **Term (or later) delivery logged** | Birth recorded at term | Transition to **Postpartum (E1)**; celebrate tone-matched to her history; retain record. | **E1** |
| **Withdraw / step back** | User exits monitoring mode | Pause nudges (incl. milestone framing); retain data per privacy settings; nothing forced. | Retain, low-touch |

*All routes preserve one-account data continuity and always end with clinician-referral language, never a diagnosis. Emergency escalation is **messaging/education that routes her to real care** — Femio never itself triages, times labour, calls, or decides. Pregnancy loss at any point fires the universal E6 handler (instant suppression, Gentle Mode, grief resources).*

---

## K. Compliance flags

1. **No diagnosis / triage / interpretation (highest-priority guardrail).** Femio **never** tells her she is or isn't in labour, **never** interprets a symptom or a cervical-length number ("short/normal/dangerous"), **never** says "go to hospital / stay home," **never** predicts that she will deliver early. The ~25 mm reference and preterm-labour signs appear only as **fixed educational reference**; the red-flag layer **routes her to care** without deciding *for* her. This keeps Femio out of the **medical-device + diagnosis** lane that clinical PTB-prevention pathways legitimately occupy.
2. **No prescribing / no dosing.** Progesterone, cerclage, aspirin, steroid and all medication content is **general and cited**; all decisions (whether, which, dose, timing, starting/stopping, procedure) defer to the clinician. **No** dosing calculator. Progesterone/cerclage content is context ("some higher-risk people are offered…"), never an instruction. 17-OHPC status kept **current and cited** (US market withdrawal 2023; availability varies).
3. **Time-critical-territory framing.** Preterm-labour red-flag symptoms (regular contractions, leaking/gush/PPROM, discharge change, pelvic pressure, backache, cramps, reduced movement) get **prominent, calm "seek care now — even one sign"** framing with the user's maternity/emergency contact — **never** false reassurance ("that's normal"), **never** alarmist doom, **never** a diagnosis.
4. **Contraction timer & cervical-length log are tracking aids, not tests.** Both must carry explicit "not a diagnosis of labour / not a judgement of your cervix" wording, reinforcing the D1 guardrail and avoiding medical-device classification (per femio-compliance-privacy skill).
5. **Screeners = "screening, discuss with clinician."** Cervical-length surveillance, fetal-fibronectin/other tests, risk-factor checklists, EPDS — all framed as screening/context, never verdicts.
6. **Emotional safety.** This persona is high-anxiety and often trauma-carrying by definition; tone must be **validating and calming**, no scare-content, no alarmist imagery, no countdown-to-disaster, no anxiety-driving nudges. Milestone framing is **opt-in, gentle, suppressible**; self-blame is actively countered. Crisis resources surface on any high mood-screen; if a prior-loss context is set, grief-aware handling applies.
7. **Privacy-by-design (GDPR/PDPL — special-category health data).** Pregnancy + a flagged high-risk/prior-loss history is highly sensitive. **No data sale, no ad-targeting SDKs, no employer/insurer visibility** (explicit contrast with employer-channel apps). Explicit, granular, revocable consent; strong retention limits; user-deletion of scan/symptom/med logs; partner sharing opt-in and scope-limited.
8. **Reminder suppression on loss / early exit.** Scan/med/appointment/milestone reminders — **especially milestone-anxiety framing** — must **instantly stop** on logged loss or withdrawal (fixing the competitor failure of stale reminders after a loss). Universal E6 handler governs loss.
9. **Postpartum continuity is a care feature.** A preterm delivery must route to **E1 + a NICU-aware / carried-complication tail (E4)** — not a generic postpartum flow — so NICU orientation and gentle tone carry forward.
10. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIH/CDC/NHS/MedlinePlus/NICHD) + Tier-2 (ACOG/RCOG/NICE/March of Dimes/FIGO), grade 6–8, localized in 4 languages with **human-reviewed** RTL parity (clinical stakes forbid machine-only translation of safety copy).
11. **Medical-review source set:** use the ACOG, NICE, RCOG, and FDA primary links in §D. Country modules own availability, treatment windows, NICU wording, and maternity destinations; crisis/urgent routing uses [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). Emotional copy is non-predictive and routes symptoms rather than assigning a diagnosis. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Tier-1 (NIH / CDC / NHS / MedlinePlus / NICHD):**
- [CDC — Preterm Birth (Maternal & Infant Health)](https://www.cdc.gov/maternal-infant-health/preterm-birth/index.html)
- [MedlinePlus — Preterm Labor (signs of preterm labor)](https://medlineplus.gov/pretermlabor.html) · [MedlinePlus — Preterm labor (Medical Encyclopedia / patient instructions)](https://medlineplus.gov/ency/patientinstructions/000486.htm)
- [NICHD (NIH) — What are the symptoms of preterm labor?](https://www.nichd.nih.gov/health/topics/preterm/conditioninfo/symptoms)
- [PMC — Vaginal progesterone in high-risk patients with short cervical length (cohort study)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10017734/)
- [PMC — Predictive value of cervical length for spontaneous preterm birth in women with cervical cerclage](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12317304/)
- [PMC — Transvaginal cervical-length surveillance after cerclage placement](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11256969/)

**Tier-2 (ACOG / RCOG / NICE / March of Dimes / FIGO):**
- [ACOG — Preterm Labor and Birth (FAQ)](https://www.acog.org/womens-health/faqs/preterm-labor-and-birth)
- [ACOG Practice Bulletin 234 — Prediction and Prevention of Spontaneous Preterm Birth (2021)](https://www.acog.org/clinical/clinical-guidance/practice-bulletin/articles/2021/08/prediction-and-prevention-of-spontaneous-preterm-birth)
- [NICE NG25 — Preterm labour and birth (Recommendations)](https://www.nice.org.uk/guidance/ng25/chapter/recommendations) · [NICE QS135 — Prophylactic vaginal progesterone and cervical cerclage](https://www.nice.org.uk/guidance/qs135/chapter/quality-statement-2-prophylactic-vaginal-progesterone-and-prophylactic-cervical-cerclage)
- [RCOG — Cervical Cerclage (Green-top Guideline No. 75)](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/cervical-cerclage-green-top-guideline-no-75/)
- [FIGO — Good practice recommendations on cervical cerclage for prevention of preterm birth (2021)](https://obgyn.onlinelibrary.wiley.com/doi/full/10.1002/ijgo.13835)
- [March of Dimes — Signs and symptoms of preterm labor](https://www.marchofdimes.org/find-support/topics/birth/signs-and-symptoms-preterm-labor) · [March of Dimes — Preterm labor and preterm birth: Are you at risk?](https://www.marchofdimes.org/find-support/topics/birth/preterm-labor-and-preterm-birth-are-you-risk)

**Evidence / comparative (progesterone, cerclage, pessary, combined therapy):**
- [SuPPoRT trial — cerclage vs pessary vs vaginal progesterone for short cervix (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11288449/)
- [Combined vaginal progesterone + cervical cerclage: systematic review & meta-analysis (PubMed)](https://pubmed.ncbi.nlm.nih.gov/37211087/)
- [FDA — Decision to withdraw approval of Makena, 6 April 2023](https://www.fda.gov/news-events/press-announcements/fda-commissioner-and-chief-scientist-announce-decision-withdraw-approval-makena) · [PMC — historical safety review of 17-hydroxyprogesterone caproate](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8049867/)

**Consumer clinical references (Tier-2/3, for tone/plain-language cross-check):**
- [Cleveland Clinic — Premature (Preterm) Labor](https://my.clevelandclinic.org/health/diseases/4498-premature-labor) · [UCSF Health — Recognizing Premature Labor](https://www.ucsfhealth.org/education/recognizing-premature-labor)

*Community insight (r/BabyBumps, r/pregnant, r/PregnancyAfterLoss, incompetent-cervix / cerclage and "preemie"-parent communities, pregnancy-app reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes.*

*Publication boundary:* the primary guideline/permalink set above governs clinical education. Global copy does not supply drug availability, treatment windows, a diagnosis of trauma/anxiety, a static emergency number, or a country-specific NICU pathway. These are clinician/country-module responsibilities. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
