# Persona D15 — Pregnancy with Hyperemesis Gravidarum (HG)

Prepared: 2026-07-17 · Wave 3 · Status: research + spec
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 09_MASTER_ADAPTATION_MODEL · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills
Layers on: **D1 (uncomplicated pregnancy)** — D15 is *additive HG emphasis on the D1 spine*, never a separate silo. Built per the D3 additive-layer pattern.
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms (dehydration, weight loss, ketosis, inability to keep fluids down) get prominent "seek care now" framing, never a diagnosis. Screeners (PUQE, mood) = "screening, discuss with clinician." Antiemetic / medication content is educational, never prescriptive — no dosing, no "take X," no titration.**

---

## A. Persona snapshot

**Who she is.** A pregnant woman — usually in the **first trimester (peak ~wk 5–12, often persisting to ~wk 16–20, sometimes the whole pregnancy)** — who is not experiencing "normal morning sickness" but **hyperemesis gravidarum: severe, relentless, debilitating nausea and vomiting** that stops her keeping food or fluids down, is causing **weight loss (>5% of pre-pregnancy weight)**, dehydration, and sometimes ketosis, and has landed or may land her in hospital for IV fluids. She is frequently a **prior D1 user** whose ordinary pregnancy tipped into something far worse, or a prior C/TTC user. She is often **exhausted, frightened, isolated, unable to work, unable to parent existing children, and — critically — repeatedly dismissed** ("it's just morning sickness," "eat crackers and ginger," "everyone feels sick"). That dismissal, from family, employers, and sometimes clinicians, is the defining wound of this persona.

**Core job.** "This is not morning sickness — I'm vomiting all day, I can't keep water down, I'm losing weight, and everyone keeps telling me it's normal. Help me understand what's actually happening, track my vomiting, what little I manage to keep down, and my weight so I can *prove* how bad it is and show my clinician, tell me clearly the signs that mean I need urgent care or a drip, explain the anti-sickness medicines my doctor might discuss — and take me seriously and support my mental health — without pretending to be my doctor, minimising it, or selling my pregnancy to advertisers."

**Emotional arc (validation is the defining need).**
- **Onset / "is this normal?" (the entry point):** creeping realization that this is far beyond friends' morning sickness; fear for the baby ("is my baby starving?"); confusion; the first waves of being dismissed. She needs, above all, to hear *"this is real, it has a name, you are not weak, and you deserve care."*
- **Survival mode (peak weeks):** unable to eat/drink/work; counting hours between vomits; the mental load of tracking intake to justify care; guilt about existing children, partner, job; fear of hospital and IV lines; terror that it will never end. Food aversion so severe that smells trigger vomiting.
- **Treatment negotiation:** anxiety and relief around **antiemetics** (will they work, are they safe for the baby?), fear of needles/IV/NG tubes, ping-ponging between GP/ED/day-unit, and the fight to be believed and prescribed. Many describe having to advocate hard or switch providers.
- **The grind & mental-health toll:** HG is strongly linked to **antenatal depression, anxiety, and PTSD** — and, tragically, some women consider or seek termination of otherwise-wanted pregnancies because the suffering is unbearable. This is not a footnote; it is central to D15.
- **Easing (for most):** for many, symptoms ease in the **second trimester (~wk 16–20)**, though a substantial minority suffer until delivery. Relief is real but often shadowed by trauma and dread of "what if it comes back."
- **Postpartum tail:** instant physical relief at delivery, but lingering trauma/PTSD, fear of future pregnancies (HG has a high recurrence rate), and grief for the pregnancy experience she "lost."

**Context.** Web-first, mobile-heavy, but often **too sick to engage for long** — she may open the app briefly, lying down, between episodes, one-handed. Low-friction logging is not a nice-to-have; it is the whole product for her in survival mode. Arabic-first / RTL primary with EN/AR/FR/ES. Values calm, validating, ultra-low-effort UX above all — she is depleted and dismissed; the app must never add burden or doubt.

**Success = she feels believed, less alone, and organized** — her vomiting/intake/weight live in one private place that visibly documents severity for her care team; she understands HG is a real medical condition (not weakness or "just morning sickness"); genuine red flags (signs of dehydration, ongoing weight loss, inability to keep any fluids down, dark/no urine) are surfaced **loudly with "seek care now" framing** and routed to care; and her mental health is watched gently and supported — never diagnosed, never trivialised.

---

## B. Needs & questions (voice-of-user)

Mined from r/HyperemesisGravidarum, the HER Foundation community and forums, pregnancy-sickness support groups, and the qualitative HG literature. Representative real questions, grouped by job-to-be-done. Verbatim-style paraphrases.

**Validation & "is this normal / am I overreacting?" (dominant emotional need at entry)**
- "Everyone keeps saying it's just morning sickness — but I've thrown up 15 times today and can't keep water down. Is that normal??"
- "My mum/partner/boss thinks I'm being dramatic. Am I?"
- "How do I know if this is HG or just bad morning sickness?"
- "I feel like a failure for not being able to eat or work — is that just me?"

**Fear for the baby**
- "I've lost 4 kg and can't eat anything — is my baby getting enough? Am I starving it?"
- "Will the vomiting hurt the baby?"

**Tracking to prove severity / get care**
- "My GP won't take me seriously — how do I show them how bad it actually is?"
- "How many times a day counts as 'severe'? I want to log it so they believe me."
- "What's this PUQE score my midwife mentioned?"

**Dehydration / when to seek care (the safety core)**
- "I haven't peed since this morning and it's dark — do I need to go to hospital?"
- "When do I actually need a drip / IV fluids?"
- "How do I know if I'm dehydrated?"
- "Is it bad that I can't keep even sips of water down for a whole day?"

**Medication (educational anxiety)**
- "What anti-sickness meds are safe in pregnancy? Are they safe for the baby?"
- "My doctor mentioned ondansetron/cyclizine/metoclopramide — what are these?"
- "Nothing is working — what else is there? What's next after the first tablets?"
- "I'm scared of the IV / the NG tube they mentioned."

**Eating & drinking survival**
- "What can I actually keep down? Everything makes me sick."
- "Smells make me vomit — how do people cope?"
- "How do I stay hydrated when I can't drink?"

**Mental health**
- "I love this baby but I can't do this anymore — is it normal to feel this low?"
- "I've had intrusive thoughts about ending the pregnancy just to make it stop. I feel so guilty."
- "Will I be traumatised by this? I'm already dreading a future pregnancy."

**Recurrence & the future**
- "Will I get HG again next time? Can anything reduce the chance?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Every mainstream pregnancy app **treats all nausea as mild** — a cheery "morning sickness: try ginger and crackers!" tip that is, to an HG sufferer, insulting and useless. There is no severity spectrum, no HG mode, no acknowledgment she might be vomiting 20+ times a day.
- No app offers a **vomiting-episode / fluid-intake / weight-loss tracker** framed for HG, and none surface **dehydration red-flags** — the exact thing that keeps her safe.
- The "fruit of the week" celebratory framing feels cruel when she is too sick to lift her head.
- Nowhere does she feel **believed** — the tone assumes a glowing, mildly queasy pregnancy.
- Privacy dread — "I don't want my pregnancy + hospital admissions + mental-health data sold or visible to my employer, especially when I'm already being penalised at work for being sick."

---

## C. Competitor teardown

The core HG whitespace is stark: **pregnancy apps treat all nausea as mild**, and **no app models severity, HG tracking, or dehydration safety at all.** Symptom trackers log a generic "nausea" tag; none distinguish "queasy" from "vomiting 20×/day and dehydrated."

| Capability | What to Expect | Ovia Pregnancy | Pregnancy+ | Flo (preg mode) | HER Foundation (web/resources) | Generic symptom trackers |
|---|---|---|---|---|---|---|
| Week-by-week fetal/pregnancy content | Strong | Strong + insights | Best-in-class visuals | Good | None (support/education org) | None |
| Nausea handled as a **severity spectrum** | **No — "mild" assumed** | **No** | **No** | **No** | Yes (educational) | **No** |
| Dedicated **HG mode / content** | Article-level "morning sickness" only | Article-level | Article-level | Article-level | **Yes — the gold standard** | No |
| **Vomiting-episode log** | No | Generic symptom tag | No | Generic symptom tag | No (org, not an app) | Generic tag, no context |
| **Fluid / food intake log** | No | Basic food log | No | No | No | No |
| **Weight-loss tracking (HG-framed)** | Weight-*gain* only | Weight-gain only | Weight-gain only | No | No | No |
| **PUQE severity screen** | No | No | No | No | References it | No |
| **Dehydration red-flags / "seek care"** | Generic warning-signs | Generic | Generic | Generic | **Yes (educational)** | No |
| Antiemetic education (no dosing) | Light article | Light | Light | Light | **Yes, thorough** | No |
| Mental-health watch (HG-linked) | Generic mood | Generic mood | No | Mood | **Yes — trauma/PTSD focus** | No |
| Clinician-shareable report (PDF) | No | Limited | No | No | No | Rare |
| Languages / RTL | EN-centric | EN-centric | Multi | Multi | EN-centric | Varies |
| Privacy posture | Reported data sale | Labcorp-owned; employer-visibility concern | Reported ad-SDK sharing | 2021 FTC settlement | Non-profit, trustworthy | Varies |

**Whitespace Femio owns (D15):** *the only calm, validating, privacy-first, Arabic-first pregnancy app that recognises nausea as a severity spectrum and layers a compliant HG toolset — vomiting/intake/weight tracking, PUQE severity screening, dehydration red-flags, and antiemetic + mental-health education — onto real week-by-week pregnancy content in one account* — without ads, without selling her data, and, above all, **without ever telling a woman vomiting 20 times a day to "try ginger."**

**Compliance/positioning contrast to note:** the HER Foundation is the trusted *educational* authority Femio should align to and cite — but it is not a tracking app. Femio's differentiator is the compliant *tool layer* (episode/intake/weight logs, PUQE screen, dehydration safety) delivered in-context, validating, and multilingual, pointing to (not replacing) clinical care.

---

## D. Clinical grounding (cited)

All figures below are **education, not medical advice**; app copy must attribute to these bodies, present severity tools (PUQE) as *"a screening aid your clinician interprets,"* and defer every treatment/dosing decision to the user's care team.

**What HG is / how it differs from morning sickness.** Nausea and vomiting affect up to ~70–80% of pregnancies (normal NVP). **Hyperemesis gravidarum is the severe end**: persistent, severe nausea and vomiting with **weight loss of >5% of pre-pregnancy weight**, **dehydration**, **ketosis**, and electrolyte/acid–base disturbance; it affects roughly **~0.3–3% of pregnancies**, is a leading cause of hospital admission in early pregnancy, and — untreated — can cause serious complications. It is **not** caused by anything the woman did, is not "in her head," and is not weakness (crucial anti-dismissal framing). [MedlinePlus; NIH/StatPearls; RCOG Green-top 69]

**Typical timing.** Usually begins in the first trimester (often ~wk 4–9, peaking ~wk 9–13); for many it eases by ~**wk 16–20 (second trimester)**, but a substantial minority experience it until delivery. → App framing: never promise it will end at a fixed week; "for many it eases in the second trimester, but everyone is different." [RCOG GTG 69; NHS] *[NEEDS SOURCE: pin exact NHS "sickness in pregnancy / HG" page for timing wording]*

**Severity scoring — PUQE (screening framing).** The **PUQE / PUQE-24 (Pregnancy-Unique Quantification of Emesis and Nausea)** score quantifies severity from three questions (hours of nausea, number of vomiting episodes, number of retching episodes over 24h): **Mild ≤6 · Moderate 7–12 · Severe ≥13** (max 15). A validated tool used to gauge severity and nutritional impact. → In Femio it is a **screening aid** she can complete and share, framed *"this is a severity screen, not a diagnosis — discuss your score with your clinician."* Never an app verdict, never auto-escalation. [RCOG GTG 69; Norwegian PUQE validation study, PMC4382206]

**Signs of dehydration (the red-flag core).** Reported signs include **sunken eyes, dry lips/mouth, dark or reduced urine (oliguria) or not passing urine, dizziness/feeling faint, fast heartbeat (tachycardia), and low blood pressure**. **Important nuance for compliant copy:** **ketonuria/ketones are NOT a reliable marker of dehydration or HG severity** and should not be used to gauge severity — so Femio educates on *symptoms of dehydration and weight loss*, and frames ketosis as part of the clinical picture a clinician assesses, never as something the user self-measures to "score" herself. Inability to keep any fluids down for a prolonged period → urgent assessment / possible IV fluids. [RCOG GTG 69; BNSSG Remedy HG guideline]

**When to seek care / escalation (education, not triage).** Guidelines describe urgent assessment for: **unable to keep any food or fluids down (e.g., >24h)**, signs of **dehydration**, **dark/very little/no urine**, **significant or continued weight loss**, **very frequent vomiting**, **vomiting blood**, severe weakness/fainting, or a high PUQE with complications. Management may include **IV fluids, antiemetics, and — before any dextrose — thiamine (vitamin B1) to prevent Wernicke's encephalopathy**, and in severe unresponsive cases nutritional (NG/enteral) support. → These populate Femio's red-flag boxes and "when to seek care" content, always "contact your maternity provider / day unit / local emergency number," never an app diagnosis. [RCOG GTG 69; ACOG PB 189/153; StatPearls]

**Medication (educational only — the "ladder" as *what guidelines describe*).** Guidelines describe a general stepwise approach, which Femio explains as *education about what a clinician might discuss*, never a recommendation or dose:
- **First-line:** vitamin **B6 (pyridoxine)** ± **doxylamine** (an antihistamine); other antihistamines/dopamine-antagonists such as **cyclizine, promethazine, prochlorperazine, metoclopramide** are also used. (Note: metoclopramide carries duration-limit warnings in Europe.)
- **Next-line:** **ondansetron** (widely used; guidelines note discussion of a possible small increased risk of orofacial clefts with early first-trimester use — a shared clinician decision) and **steroids (corticosteroids)** in refractory cases.
- **Supportive:** IV rehydration, electrolyte correction, **thiamine before dextrose**, thromboprophylaxis considerations, and mental-health support.
→ Femio content explains *what these are and why a clinician might use them, in what rough order* — **never** doses, titration, "start/switch to X," or "this one is safe for you." Every decision defers to the care team. [ACOG PB 189 (2018) / PB 153; RCOG GTG 69; treatment-options review PMC7037589]

**Mental health (central, not peripheral).** HG is strongly associated with **antenatal and postnatal depression, anxiety, and PTSD**; recent research links HG to a marked (~50%) increase in mental-health/neuropsychiatric diagnoses in the year after; some women experience intrusive thoughts and, in extreme suffering, consider terminating wanted pregnancies. → D15 keeps a **gentle mental-health watch**, surfaces mood screening (framed as screening) and crisis resources, and routes to **D11 (antenatal anxiety/depression)** emphasis; any self-harm signal triggers the universal crisis path immediately. [HER Foundation; Mother.ly on HG–mental-health study; PMC3514078 (PTSD after HG); MGH Center for Women's Mental Health]

**Recurrence & reassurance.** HG has a high recurrence rate in later pregnancies (a common, honest concern) — but it is **manageable**, most babies do well when the mother is supported and treated, and early treatment of NVP may reduce progression. Always paired with validation and the true, reassuring message that she will get through it with care. [HER Foundation; ACOG; RCOG GTG 69]

*[NEEDS SOURCE]* flags: exact ACOG Practice Bulletin 189 permalink; exact NHS HG page permalink; region-specific antiemetic availability/naming for MENA localization; localized crisis directories + maternity day-unit pathways per region.

---

## E. Feature set (prioritized)

D15 = the **D1 spine (week content, appointments, warning-signs, weight)** + an **HG tool + validation + safety layer**. Nothing from D1 is removed; but in survival mode the home *foregrounds* the HG tools and *softens/collapses* celebratory content.

**P0 — must-have (the HG layer)**
1. **Vomiting / nausea episode log** — ultra-low-friction one-tap logging of vomiting & retching episodes and nausea hours (designed for a woman who is too sick to type). Feeds an optional **PUQE-24 severity screen** she can complete and share. *Tracking aid + screening, not a diagnosis.*
2. **Fluid & food intake log** — quick "kept down / brought back up" tracking of fluids and food, so she and her clinician can *see* whether she is maintaining any intake. Non-judgmental, no targets, no scoring.
3. **Weight-loss tracking (HG-framed)** — logs weight against **pre-pregnancy weight**, showing *loss* (the >5% threshold as educational context), the inverse of D1's weight-*gain* band. Non-alarmist, "share this with your clinician."
4. **Dehydration red-flag safety layer** — persistent, prominent "signs of dehydration → seek care now" access + contextual red-flag boxes (dark/no urine, can't keep fluids down >24h, dizziness, continued weight loss). The safety core of this persona.
5. **HG validation + education hub** — referenced, calm, explicitly *"this is real, this is not just morning sickness, this is not your fault"* (see F).
6. **Clinician-shareable export (PDF/CSV)** of episode + intake + weight + PUQE logs — the evidence she needs to be believed and get care.
7. **Mental-health watch** — gentle mood check-ins (screening framing) + crisis resources, routing to **D11** emphasis; central, not optional.

**P1 — high value**
8. **Antiemetic / medication education** — what the common anti-sickness options are and the rough order a clinician might discuss them, plus a **medication log (educational)** to record what she was prescribed and whether she took it, for her own pattern-tracking and export. **No doses, no "take/switch to X."**
9. **Appointment / care-pathway tracker** — GP, midwife, maternity day-unit / ED visits, admissions, IV-fluid sessions, follow-ups; reminders; "questions to ask / how to advocate."
10. **Symptom-trigger notes** — optional log of smell/food triggers so she sees her own patterns.
11. **Low-effort / rest mode** — a stripped, quiet home state for survival weeks (big buttons, minimal content, no cheery nudges).

**P2 — differentiators / later**
12. Culturally-adapted "what people manage to keep down" education (MENA + EN/FR/ES), clinician-reviewed, framed gently and non-prescriptively.
13. Gentle, moderated HG peer support / curated Q&A (privacy-safe, high validation value given isolation — only if moderation is guaranteed).
14. Partner/support view (X2) — helps a partner understand severity and support her (directly addresses the "my partner thinks I'm dramatic" wound).
15. Recurrence-planning bridge for a future pregnancy (educational; links to preconception content).

**Explicitly out of scope (compliance):** any tool that **diagnoses HG** or renders "you have HG / this is severe" as a verdict; any **antiemetic dose calculator, titration, or "take X"** instruction; any **auto-escalation** to hospital based on logs (PUQE and logs *inform her and her clinician*, never trigger an app decision); any "your baby is fine / at risk" reassurance or alarm; any measurement that scores her by ketones. Episode/intake/weight/PUQE/med logs are **user-recorded tracking + screening data with educational context only.**

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL, dual-unit for weight). Delivered as an additive HG hub on the D1 library; always searchable. Tone throughout: **validating, calm, anti-dismissal, anti-catastrophizing.**

- **"This is not just morning sickness" primer** — what HG is, how it differs from normal NVP (severity, weight loss, dehydration, ketosis), how common, that it is **real, has a name, and is not her fault or weakness**. The single most important module for this persona — leads the hub.
- **Understanding severity (PUQE, explained)** — what the PUQE screen measures, what mild/moderate/severe bands mean, and why *"it's a screen you share with your clinician, not a diagnosis."*
- **Dehydration: the signs and when to seek care** — sunken eyes, dry mouth, dark/little/no urine, dizziness, fast heartbeat; can't keep fluids down; the "seek care now" framing. Explicitly notes ketones are a clinical measure, not a self-score.
- **"Is my baby okay?"** — honest, gentle reassurance that with care most babies do well, framed without false certainty and without minimising her suffering.
- **Antiemetics / anti-sickness medicines, explained (educational)** — what B6/doxylamine, cyclizine, promethazine, prochlorperazine, metoclopramide, ondansetron, and steroids are, and the rough order a clinician might discuss them; safety questions to ask; IV fluids, thiamine-before-dextrose, and NG/enteral feeding explained for the frightened. **No doses.**
- **Getting through the day** — coping with smells/triggers, tiny-and-often sips/foods (framed gently, non-prescriptive, "whatever you can manage"), rest, work/sick-leave realities.
- **Advocating for yourself** — how to describe severity to a GP/midwife, using your logs/PUQE/weight record, what a maternity day unit is, what to do if you feel dismissed. (Directly answers the dominant real-world pain.)
- **HG and your mental health** — validating that depression, anxiety, intrusive thoughts and trauma are common with HG and **not a moral failing**; when and how to seek support; soft pointer to mood screening ("screening, discuss with clinician") and crisis resources; bridges to **D11**.
- **When it eases / the road ahead** — for many, second-trimester easing; honest that some suffer longer; processing the experience.
- **After birth & future pregnancies** — instant relief, possible lingering trauma (PTSD), high recurrence and that support/early treatment exist; bridges to postpartum (E) and preconception planning.
- **Warning-signs hub (inherited + HG-tuned)** — CDC Hear Her list always reachable; HG dehydration/weight-loss red-flags foregrounded.

---

## G. Tools, logs & alerts (compliant framing; dehydration red-flag box; PUQE + intake/weight tracking)

**Logs & tools**
- **Vomiting/nausea episode log** — ultra-low-friction: tap to add a vomiting or retching episode; optional nausea-hours entry. Rolls up into a daily count and *her own* trend. Copy: *"A tracking aid to help you and your clinician see how severe things are. It can't diagnose HG or tell you a day is 'good' or 'bad.'"*
- **PUQE-24 severity screen (screening)** — optional 3-question screen; shows her band (mild/moderate/severe) as **screening context only**. Copy: *"This is a severity screen, not a diagnosis. Share your score with your clinician — Femio can't diagnose HG or decide if you need hospital care."* No auto-escalation.
- **Fluid & food intake log** — quick "kept down / came back up" entries for fluids and food. Copy: *"A record of what you're managing — no targets, no judgment. Share it with your care team."* No scoring, no "budget."
- **Weight log (HG-framed)** — tracks weight vs **pre-pregnancy weight**, showing *change/loss*; the >5% figure appears as **educational context**, never a scored alarm. Copy: *"General education — your clinician decides what your weight means for you. If you're losing weight and can't keep fluids down, seek care."* Inverts D1's gain-band; the two views coexist (she may return to gain-tracking as HG eases).
- **Medication log (educational)** — user records prescribed anti-sickness meds (name, time, *as prescribed*) for pattern-tracking + export. Copy: *"Record only. Femio never recommends, orders, or adjusts doses — follow your clinician."*
- **Appointment / care-pathway log** — GP, midwife, day-unit/ED visits, admissions, IV sessions; provider, notes, results (user-entered), reminders.
- **Mood check-in (screening)** — gentle, low-frequency; feeds the mental-health watch (see below); framed as screening.
- **Export (PDF/CSV)** — episodes + intake + weight + PUQE + meds + notes, formatted to show a clinician (the "prove it" artifact).
- **Kick counter / contraction timer (T3, inherited from D1)** — unchanged, surface later if she reaches T3 still using the app.

**Alerts (all opt-in, calm, non-alarmist, survival-mode-aware)**
- **Low-effort by default:** in survival mode, notifications are minimised; no cheery "fruit of the week" nudges, no milestone celebrations that would feel cruel. She can mute everything and keep only what she wants.
- Optional gentle reminders: log intake/weight (if she opted in), appointment/day-unit reminders, take-your-prescribed-med reminder (record-only, never a dose).
- **No** predictive/diagnostic alerts. **No** "your PUQE is dangerous" or "you're dehydrated" auto-verdicts. **No** auto-escalation to hospital.

**Dehydration red-flag box pattern (reusable component, HG-tuned).**
> **⚠ Seek care now**
> Contact your maternity provider, GP, maternity day unit, or local emergency number right away if you: **can't keep any food or fluids down** (for example, for more than a day) · are passing **dark, very little, or no urine** · feel **dizzy, faint, or very weak** · have a **fast or pounding heartbeat** · are **losing weight** or your vomiting is getting worse · are **vomiting blood** · have severe tummy pain · have thoughts of harming yourself or of ending the pregnancy to make it stop.
> *This is not "just morning sickness" — severe sickness in pregnancy is a real medical condition, and you deserve to be taken seriously and treated. Femio can't diagnose or treat, and can't tell you whether you're dehydrated — but these are signs to get checked urgently.*
> [Save my maternity/day-unit/emergency contact] [Learn the signs of dehydration]

Placement: persistent nav entry + auto-injected on the vomiting-log and intake-log screens, the PUQE result screen, the weight-loss view, and any dehydration/HG content. A **crisis-resources** panel is attached wherever the mental-health/self-harm language appears (per universal handler).

---

## H. EMR fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1)**
- Identity/account, locale/language, units (kg/lb).
- DOB / age; height; **pre-pregnancy weight & BMI** (the baseline HG weight-loss is measured against).
- Menstrual history; LMP.
- Medical-history flags (**prior HG**, thyroid, GI conditions, mental-health history, prior pregnancies/outcomes).
- Medications, allergies, supplements.
- Consent/privacy settings; emergency/maternity-day-unit contact (optional).

**Persona-specific (HG — layered over the constant core EMR, on top of D1's pregnancy fields)**
- **HG status & recorded date** — user-recorded (the D1→D15 transition marker, typically off a severe-vomiting log or "I've been told I have HG"); *not app-diagnosed*.
- **Prior-HG flag** carried from core — used to *surface* early HG education/validation in a subsequent pregnancy, never a prediction.
- **Vomiting/retching episode series** — timestamped counts; nausea-hours. User-entered.
- **PUQE screen results series** — score + band, timestamped, stored as **screening context** (non-diagnostic), user-shared.
- **Fluid/food intake series** — "kept down / brought back up" entries; optional trigger notes.
- **Weight series vs pre-pregnancy baseline** — showing change/loss; the >5% threshold stored only as an educational reference, not a rule/flag that fires.
- **Medication log** — anti-sickness meds (name, time), *user-recorded as prescribed*; no dose logic.
- **Care-pathway log** — GP/midwife/day-unit/ED visits, **admissions, IV-fluid sessions, NG/enteral episodes** (user-entered), results/notes.
- **Mood check-in / screen series** — timestamped, non-diagnostic; feeds D11 watch.
- **Recovery marker** — user-recorded "symptoms easing" (drives content shift back toward standard D1 as she improves).
- Inherited D1 fields (EDD/GA, appointments, BP-if-logged, kick/contraction sessions, etc.) all retained; the D1 weight-*gain* band is de-emphasised while HG weight-*loss* view is foregrounded, and re-emphasised as she recovers.

---

## I. Personalization rules (layered on the D1 pregnancy base; hidden-but-reachable)

**D15 does not re-onboard.** It activates *on top of* an existing D1 pregnancy context when severe vomiting / HG is recorded — additive emphasis, nothing hidden or removed, but the home *reprioritises* toward HG tools and *softens* celebratory content in survival mode.

**Activation (wizard delta, short & editable/resettable — personalize, never restrict).**
1. Trigger: user **logs severe/persistent vomiting** (e.g., a high vomiting count or "I can't keep fluids down"), completes a **PUQE screen in the severe range**, or records *"my clinician told me I have HG."* D1 may *offer* the HG layer proactively when severe-vomiting logs appear — framed as support, never a diagnosis.
2. Quick set-up: preferred **weight units**; whether to turn on **low-effort/rest mode** (minimised notifications, quiet home); **reminder preferences** (default: minimal); who (if anyone) she shares with (X2 partner — offered as a way to help them understand severity).
3. Optional: enter **pre-pregnancy weight** if not already in record (weight-loss baseline).

**Home configuration (GA-driven, inherited from D1, with HG layer on top).**
- **Onset / survival mode (peak weeks):** the "This is not just morning sickness" validation primer and the **episode + intake + weight logs** are foregrounded as the primary quick-actions; the **dehydration red-flag box** is pinned; the **PUQE screen** is one tap away; the D1 week-by-week card is **still present but de-emphasised/collapsible** (she can still get baby content if she wants it, but it does not dominate); celebratory milestones and cheery nudges are suppressed; mental-health check-in surfaced gently.
- **Treatment/medication recorded:** antiemetic-education + medication log + needle/IV/NG-anxiety modules surfaced.
- **Recovery / easing (often ~T2):** as she logs symptoms easing, the home **gently shifts back toward the standard D1 experience** — week-by-week content re-foregrounded, weight-*gain* band re-emphasised, HG tools quiet down but remain reachable; a validating "you got through the hardest part" note (no false promises).
- **T3 (inherited, if reached still symptomatic or not):** kick counter + contraction timer + birth-prep surface as in D1.
- **Post-delivery:** HG tools quiet; a gentle bridge to postpartum (E), plus optional trauma/mental-health follow-up and future-pregnancy recurrence education.

**Hidden-but-reachable rule.** Nothing is locked. The full D1 pregnancy experience remains intact and reachable; HG tools are *added* and *prioritised* during survival mode, and every article/tool stays in the library and search regardless of persona. She can collapse the HG layer or the baby content, whichever she needs, without losing either.

**Continuity.** Her D1 pregnancy record (EDD/GA, appointments, weight, symptoms) and core history (prior HG, mental-health history) seed D15 automatically — no separate app, no re-entry; a one-time *"your pregnancy history is here, this just adds tools to track how severe your sickness is and keep you safe, and it's all private"* note.

---

## J. Adaptation triggers (state transitions)

D15 **inherits all universal events** from the Master Adaptation Model §6 (positive test, pregnancy loss, mood-screen-high/crisis, red-flag symptom, disengagement/"taking a break," toggle-off, age-of-consent). Only the **D15-specific** transitions are specified here.

**INTO D15 (from D1):**
- **Severe / persistent-vomiting log, severe-range PUQE, or user records "clinician diagnosed HG"** → offer to add the HG layer to her existing pregnancy mode; carry all D1 context; enter low-effort/rest mode if chosen; **privacy step:** reassure that her HG, hospital-admission, and mental-health data is never sold, never employer/insurer-visible (she is often already penalised at work), and confirm partner-sharing scope. Additive emphasis — **do not diagnose HG**; frame as *"you've told us you're vomiting severely / your clinician diagnosed HG — here's validation, tracking, safety information, and when to seek care."*
- **Prior-HG pre-surfacing:** if a prior-HG flag is in her record, D1 may *offer* early HG validation/education in a new pregnancy (never a prediction, never a diagnosis).

**Within pregnancy (additive blends, never restriction, never diagnosis):**
- **Dehydration red-flags / weight loss / can't-keep-fluids-down logged** → fire the universal red-flag handler with the HG-tuned "seek care now" box (day unit / ED / emergency number as education); log stays raw; never an app triage.
- **Repeated low-mood logs, positive mood screen, or self-harm/intrusive-thought language** → **mental-health watch → D11** antenatal anxiety/depression emphasis (screening framing); any self-harm or "ending the pregnancy to make it stop" signal fires the **universal crisis path immediately** (crisis resources, regardless of score). HG's strong depression/PTSD link makes this watch central, not optional.
- **Symptoms easing logged** → home **gently reverts toward standard D1** (see I); HG tools remain reachable; no false "it's over" promises.
- **Other complications co-recorded** (e.g., GDM, thyroid, pre-eclampsia signs) → blend the relevant D-layer (D3/D7/D6) additively; safety layers **union** per the blending rules; most-acute emphasis wins the hero.
- All D1 content stays fully available; the resolver blends emphasis.

**OUT of pregnancy:**
- **Delivery/birth logged** → transition to **Postpartum (E1)**: HG physical symptoms typically resolve at delivery, so HG tools quiet down (reachable), and — given HG's mental-health/PTSD link — carry forward a **gentle trauma/mental-health follow-up** (→ **E3** if mood elevated) and **future-pregnancy recurrence** education; **E2** if breastfeeding.
- **Pregnancy loss / stillbirth logged** (incl. where unbearable HG leads to termination of a wanted pregnancy) → **universal loss handler**: immediate, dignified transition to **loss/grief (E6)**; **instant suppression of all pregnancy + HG reminders** (intake/weight/med/appointment prompts); grief + mental-health resources; no re-prompting; extra sensitivity given HG-related trauma and any guilt.
- **Reset/withdraw:** she can drop the HG layer or exit pregnancy mode anytime; data retained per her privacy settings, nothing forced.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention claims, no medical-device functionality. The vomiting-episode log, intake log, weight log, PUQE screen and medication log are **tracking + screening aids for user-entered data**, explicitly *not* tests, not diagnostic tools, and not able to judge whether she has HG, is dehydrated, or needs hospital — copy must state this (avoids medical-device classification per femio-compliance-privacy skill).
- **PUQE = screening, discuss with clinician:** rendered as a severity *screen* she shares, never an app verdict, and it **never auto-escalates** to a care decision.
- **No dosing / no titration / no calculators:** categorically **no antiemetic dose calculator, no dose recommendation, no "take/start/switch to X."** Medication content is general, cited, ordered only as *"what guidelines describe a clinician might discuss,"* and defers every decision to the care team.
- **Weight-loss framing (sensitive):** the >5% figure and weight-loss view are **educational context**, non-alarmist, never a scored "fail" state; paired with "seek care" routing when loss + inability to hydrate co-occur.
- **Ketosis handled carefully:** copy notes ketones are a **clinical measure a clinician assesses**, not a self-score — Femio never asks her to grade herself by ketones (aligns with guideline nuance that ketonuria is not a reliable severity marker).
- **Red-flag routing (dehydration core):** dehydration signs, dark/no urine, inability to keep fluids down, continued weight loss, vomiting blood use **"seek care now"** framing pointing to maternity provider / day unit / local emergency number; never reassures ("you're fine / your baby is fine"), never alarms with a diagnosis.
- **Mental-health safety (central):** given HG's strong depression/anxiety/PTSD link and documented intrusive/termination thoughts, mood is watched gently (screening framing), crisis resources are attached to any high mood-screen, and **any self-harm or "end the pregnancy to make it stop" signal fires the universal crisis path immediately** regardless of score.
- **Anti-dismissal, validating, non-judgmental tone (sensitive topic):** the defining tone requirement — copy explicitly affirms HG is real and not "just morning sickness," not weakness, and not her fault; no toxic positivity ("just think of the baby!"), no minimising, no cheery milestone content forced during survival mode.
- **Privacy-by-design (GDPR/PDPL, health data):** HG status, **hospital admissions**, and **mental-health data** are highly sensitive, layered on sensitive pregnancy data — minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility** (she may already face workplace penalty for sickness). Partner sharing opt-in and granular. Loss/withdrawal → immediate suppression of all pregnancy + HG reminders and honored deletion.
- **Content provenance:** every medical claim medically reviewed + cited to Tier-1 (MedlinePlus/NIH/NHS) / Tier-2 (ACOG/RCOG, HER Foundation); review dates surfaced; no clickbait, no sponsored content interleaved with medical guidance.
- **i18n/RTL:** all safety/red-flag and validation copy human-reviewed in AR/EN/FR/ES (not machine-only) given clinical + emotional stakes; antiemetic names and maternity-day-unit pathways localized per region.
- **Open items:** resolve **[NEEDS SOURCE]** citations (ACOG PB 189 permalink; NHS HG page permalink; region antiemetic naming/availability; localized crisis directories + day-unit pathways) before content freeze.

---

## Sources

- [MedlinePlus — Hyperemesis gravidarum (Medical Encyclopedia)](https://medlineplus.gov/ency/article/001499.htm)
- [NCBI StatPearls — Hyperemesis Gravidarum](https://www.ncbi.nlm.nih.gov/books/NBK532917/)
- [RCOG — The Management of Nausea and Vomiting of Pregnancy and Hyperemesis Gravidarum (Green-top Guideline No. 69)](https://www.rcog.org.uk/media/y3fen1x1/gtg69-hyperemesis.pdf)
- [BJOG (Nelson-Piercy) — GTG No. 69, 2024 update](https://obgyn.onlinelibrary.wiley.com/doi/10.1111/1471-0528.17739)
- [PMC4382206 — Norwegian PUQE identifies HG and poor nutritional intake (validation study)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4382206/)
- [Remedy BNSSG ICB (NHS) — Hyperemesis Gravidarum (dehydration signs, PUQE, ketonuria nuance)](https://remedy.bnssg.icb.nhs.uk/adults/gynaecology/hyperemesis-gravidarum/)
- [RCEMLearning — Hyperemesis Gravidarum (emergency assessment reference)](https://www.rcemlearning.co.uk/reference/hyperemesis-gravidarum/)
- [PMC7037589 — Treatment options for hyperemesis gravidarum (antiemetic review)](https://pmc.ncbi.nlm.nih.gov/articles/PMC7037589/)
- [ACOG guideline summary — Nausea and Vomiting of Pregnancy (PB 189; first-line B6/doxylamine, ondansetron, thiamine-before-dextrose)](https://reference.medscape.com/cc2/p10/acog-guideline-nausea-vomiting-pregnancy-2026a1000g0v)
- [The ObG Project — Nausea/Vomiting in Pregnancy: Management Options (ACOG)](https://www.obgproject.com/2016/08/05/nausea-vomiting-pregnancy-management-options-provide-relief-prevent-hyperemesis-gravidarum/)
- [PMC9161510 — Antiemetic treatment of HG in 1,064 Norwegian women (metoclopramide warning, side-effect profiles)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9161510/)
- [HER Foundation — Healing after the trauma of Hyperemesis Gravidarum](https://www.hyperemesis.org/hg-management/healing-after-the-trauma-of-hyperemesis-gravidarum/)
- [HER Foundation — HG Facts (fact sheet)](https://www.hyperemesis.org/wp-content/uploads/2020/05/HER_HGFacts_v4.pdf)
- [Mother.ly — Severe pregnancy sickness linked to higher depression and PTSD risk](https://www.mother.ly/pregnancy/new-study-hyperemesis-gravidarum-mental-health-impact/)
- [PMC3514078 — Posttraumatic stress symptoms following pregnancy complicated by hyperemesis gravidarum](https://pmc.ncbi.nlm.nih.gov/articles/PMC3514078/)
- [MGH Center for Women's Mental Health — Understanding the Psychological Consequences of Hyperemesis Gravidarum](https://womensmentalhealth.org/posts/understanding-the-psychological-consequences-of-hyperemesis-gravidarum/)
- [Seleni Institute — More Than Morning Sickness](https://seleni.org/advice-support/2018/3/19/more-than-morning-sickness)
- [CDC — Urgent Maternal Warning Signs (HEAR HER Campaign)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [MSD Manual (Professional) — Hyperemesis Gravidarum](https://www.msdmanuals.com/professional/gynecology-and-obstetrics/antenatal-complications/hyperemesis-gravidarum)

*[NEEDS SOURCE]* ACOG Practice Bulletin 189 (Nausea and Vomiting of Pregnancy) exact permalink; NHS "severe sickness in pregnancy / hyperemesis gravidarum" page permalink; region-specific antiemetic naming/availability for MENA localization; localized crisis directories + maternity day-unit pathways per region; exact prevalence range primary source (WHO/large cohort) for the ~0.3–3% figure.
