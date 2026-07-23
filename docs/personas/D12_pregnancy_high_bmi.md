# Persona D12 — Pregnancy with High BMI / Obesity

Prepared: 2026-07-17 · Wave 3 · Status: research + spec
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 09_MASTER_ADAPTATION_MODEL · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills
Layers on: **D1 (uncomplicated pregnancy)** — D12 is *additive, weight-inclusive risk-education emphasis on the D1 spine*, never a separate silo. Blends with **D3 (GDM)** and **D6 (pre-eclampsia/gestational HTN)** when those are recorded.
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening, discuss with clinician." Weight and weight-gain content is educational and weight-inclusive — never a target she is pushed toward, never a pass/fail score, never shaming.**

---

## A. Persona snapshot

**Who she is.** A pregnant woman whose pre-pregnancy BMI is 30 or above (recorded at her booking visit), who has been told her pregnancy will be watched more closely and has likely been labelled "high-risk." She may be a first-time or repeat mother; she is often a **prior D1 user** (sometimes a prior C/TTC user before that) whose booked BMI simply carries into pregnancy. She is not sick — she is a healthy pregnant woman in a larger body — but she now faces extra scans, consultant-led care, GDM screening, and conversations about weight that too often land as judgment rather than support. Many D12 users arrive already braced for shame: research documents that roughly **1 in 5 pregnant and postpartum women report weight stigma in healthcare, most often from their obstetrician**, and that experiencing weight stigma at childbirth is associated with higher odds of cesarean. She wants respectful, honest information and to feel supported, not graded.

**Core job.** "My BMI means my pregnancy gets watched more closely and I keep getting weight talked *at* me. Explain the actual risks to me plainly and kindly, help me keep my extra appointments and scans in one place, tell me what healthy weight gain looks like *for my body* without making me feel like a failure, and be loud and clear when something genuinely needs a doctor — without shaming me, scaring me, or selling my pregnancy to advertisers."

**Emotional arc.**
- **Booking / entry point:** the "high-risk" label lands. Relief that she is being watched, tangled with defensiveness, self-consciousness, and often a history of medical weight stigma ("here we go again"). She braces for lectures. First-appointment prep matters more here because the appointments themselves can be fraught.
- **T1 (wk 4–13):** the usual early anxiety plus extra risk conversations (aspirin discussion, VTE risk, early GDM screening if flagged). Wants risks framed as *"here's what your team watches for and why,"* not *"your body is a problem."*
- **T2 (wk 14–27):** anatomy scan (sometimes harder to image; may be repeated), the **24–28 wk glucose screen** (she is offered it because of raised BMI, higher GDM chance), and weight-gain conversations she often dreads. This is where non-shaming weight-gain guidance matters most.
- **T3 (wk 28–40+):** extra **growth/position scans (often ~32 and ~36 wk)** because a larger body can make it harder to feel the baby's size and position; discussions of birth setting, anaesthetic review (offered around BMI ≥40), induction talk, and heightened warning-sign vigilance (pre-eclampsia, VTE/leg symptoms, reduced movement).
- **Postpartum tail:** continued VTE-risk awareness after birth, wound-care if cesarean, feeding, and a gentle, non-judgmental return to whatever wellbeing goals *she* chooses (never an app-imposed "lose the weight" push).

**Context.** Web-first, mobile-heavy. Arabic-first / RTL primary with EN/AR/FR/ES. Opens the app around baseline D1 frequency, spiking around appointments and scans. Values, above almost everything, an experience that treats her body with respect — she has usually been let down on this by clinicians and by other apps.

**Success = she feels respected, informed, and supported, not judged.** Her extra appointments, scans and any added care (aspirin, VTE prophylaxis discussions) live in one private place; she understands the real risks *and* that they are watched and often reducible; genuine red flags are surfaced loudly and routed to care — never diagnosed, never trivialized, and never wrapped in shame.

---

## B. Needs & questions (voice-of-user)

Mined from plus-size / "fat-positive" pregnancy communities (r/PlusSizedPregnancy, Facebook "plus size mama" and "big & pregnant" groups, Sara Wickham's plus-size-pregnancy writing) and the qualitative weight-stigma-in-maternity-care literature. Verbatim-style paraphrases, grouped by job-to-be-done.

**Respect & anti-shame (dominant emotional need at entry)**
- "I just want one appointment where my weight isn't the first and only thing they mention."
- "They told me I'm high-risk before they told me congratulations."
- "I felt judged and shamed the second I walked in — I dread every appointment now." (feeling judged/shamed is the most-reported theme in the literature)
- "I eat well and I'm active — why does everyone assume I don't?"
- "Please don't send me a diet-app that yells at me in red for eating a sandwich."

**Understanding the real risks (without fear-mongering)**
- "What does 'high-risk' actually mean for me and my baby — in plain numbers, not scare stories?"
- "Why do they keep saying gestational diabetes / pre-eclampsia / blood clots — how much more likely is it really?"
- "Is my baby actually in danger or is this just box-ticking?"
- "Why was I offered aspirin? Is that normal?"

**Weight gain (the fraught one)**
- "How much weight *should* I gain — everyone gives me a different number and a look."
- "My clinic wants me to gain almost nothing — is that even safe?"
- "I'm terrified of being weighed at every visit and getting a lecture."
- "Is it true bigger women are 'supposed' to gain less? Why?"

**Extra appointments, scans & monitoring**
- "Suddenly I have consultant appointments, extra growth scans, an anaesthetic review — how do I keep track of it all?"
- "Why do I get extra scans at 32 and 36 weeks?"
- "They couldn't see everything on the anatomy scan and want me back — is that bad?"

**Medication / prophylaxis (educational anxiety)**
- "They put me on baby aspirin — what's it for and is it safe?"
- "They mentioned blood-thinner injections after birth — why me?"

**Birth & delivery**
- "Will I be 'allowed' the birth I want, or does my BMI decide for me?"
- "Why do they keep steering me toward induction / a C-section?"
- "Will the epidural work / be harder because of my size?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Diet/weight apps that **penalise with red warnings** and treat pregnancy like a weight-loss project — described as psychologically damaging.
- Pregnancy apps that surface a single generic weight number or a "you're gaining too fast" nudge with no kindness and no context.
- Being reduced to a BMI category everywhere, in an already-stigmatising world.
- Privacy dread — "I don't want my weight *and* pregnancy sold or visible to my employer/insurer."
- Nobody offering respectful, weight-inclusive risk education in one calm place.

---

## C. Competitor teardown

Two failure modes collide for D12: **pregnancy trackers** (nice baby content, but weight handled bluntly or as an afterthought) and **diet/weight-gain apps** (weight-loss-app DNA that shames a pregnant body). **Respectful, weight-inclusive risk education is the whitespace.**

| Capability | What to Expect | Ovia Pregnancy | Pregnancy+ | Flo (preg mode) | Diet/weight apps (MyFitnessPal-type) | Weight-gain trackers (Pregnancy Pounds / Weight Gain Tracker) |
|---|---|---|---|---|---|---|
| Week-by-week fetal content | Strong | Strong + insights | Best-in-class visuals | Good | **None** | **None** |
| Weight-gain guidance | IOM band, generic | IOM band + insights | Basic tracker | Basic | **Weight-loss algorithm — wrong + harmful in pregnancy** | IOM curve, minimal framing |
| Non-shaming / weight-inclusive framing | Weak — generic nudges | Weak; employer "wellness" overtones | Neutral but bare | Weak | **Actively shaming (red warnings, "over budget")** | Neutral-to-clinical, little warmth |
| High-BMI-specific risk education | Article-level only | Article-level | Article-level | Article-level | None | None |
| Extra-appointment / scan tracking | Basic | Better | Reminders | Reminders | No | No |
| Aspirin / VTE-prophylaxis context | No | No | No | No | No | No |
| Clinician-shareable report | No | Limited | No | No | No | Limited |
| Languages / RTL | EN-centric | EN-centric | Multi | Multi | Multi (no true Arabic-first) | EN-centric |
| Privacy posture | Reported data sale | Labcorp-owned; employer-visibility concern | Reported ad-SDK sharing | 2021 FTC settlement | Ad/data-heavy | Ad-supported |

**What existing apps get wrong for D12 specifically.** Standard food/weight apps carry weight-loss-app logic into pregnancy — red "over budget" warnings and shaming nudges that clinicians describe as psychologically damaging and clinically wrong for a pregnant metabolism. Pregnancy apps treat weight as one bland number and offer no respectful, larger-body-specific risk education, no scan/appointment scaffolding for the added monitoring, and no context for aspirin or VTE-prophylaxis discussions. None are weight-inclusive by design, and none are Arabic-first.

**Whitespace Femio owns (D12):** *the only calm, privacy-first, Arabic-first app that layers respectful, weight-inclusive, cited risk education and the extra-monitoring scaffolding (scans, consultant visits, aspirin/VTE context) onto real week-by-week pregnancy content in one account* — with weight-gain guidance framed as a supportive educational band, never a target or a grade, and never a diet.

**Compliance contrast to note:** the diet-app red-warning / "over budget" pattern is exactly what Femio must NOT do. Femio shows weight as **user-recorded tracking data against a supportive IOM educational band** — no scoring, no "too fast," no diet plan, no shame.

---

## D. Clinical grounding (cited)

All figures below are **education, not medical advice**; app copy must attribute to these bodies, frame every risk non-stigmatizingly (a raised BMI raises *chances*, it is not a verdict on her or her baby), and defer every decision to her care team. Weight-inclusive language throughout (see K).

**What "high BMI in pregnancy" means / how it's handled.** A pre-pregnancy or booking **BMI ≥ 30** is commonly classed as obesity and prompts closer monitoring, not a diagnosis of illness. NHS/RCOG describe more closely monitored, often **consultant-led antenatal care at BMI ≥ 30**, an **obstetric-anaesthetic review around BMI ≥ 40** (to discuss analgesia/operative options in advance), and **additional growth/position scans (commonly ~32 and ~36 weeks)** because a larger body can make it harder to feel the baby's size and position. App framing: explain *what the extra care is and why*, as reassurance ("your team is watching closely"), never as a problem-label. [NHS; RCOG GTG 72] Note: IOM/guidelines do **not** differentiate class I (30–34.9), II (35–39.9), III (≥40) obesity for weight-gain advice — a documented limitation, worth honest framing. [ACOG; NAM/IOM 2009]

**Gestational weight gain — the IOM 2009 band for BMI ≥ 30 (singleton).**
- Underweight (BMI < 18.5): 12.5–18 kg (28–40 lb)
- Normal (18.5–24.9): 11.5–16 kg (25–35 lb)
- Overweight (25–29.9): 7–11.5 kg (15–25 lb)
- **Obese (≥ 30): 5–9 kg (11–20 lb)** ← D12's band
→ Present as a **supportive educational band**, computed from her booked pre-pregnancy BMI, always "your clinician sets what's right for you." Never a scored pass/fail, never a target she is pushed toward, never a "you're gaining too fast" nudge. The band is the same across all obesity classes (guideline limitation — say so). [IOM/NAM 2009 via CDC & ACOG]

**Higher chances the care team watches for (honest, non-fear-mongering).** A raised BMI is associated with higher *chances* of: **gestational diabetes** (NHS: ~3× more likely at BMI ≥ 30 vs < 25 → she is offered the 24–28 wk glucose screen, sometimes earlier); **pre-eclampsia / gestational hypertension**; **venous thromboembolism (VTE / blood clots)**; and, around birth, higher chances of **cesarean, wound infection, and postpartum hemorrhage**, plus potential **anaesthetic** considerations. Crucially, these are chances that are actively **monitored and often reducible** — always paired with the true, reassuring message that most women with a higher BMI have healthy pregnancies and babies. [NHS; RCOG GTG 72; ACOG "Obesity and Pregnancy"; StatPearls] These overlaps set the D12 → **D3** (GDM) and **D12 → D6** (pre-eclampsia) blends.

**Low-dose aspirin & pre-eclampsia (educational context, no dosing).** Guidelines class **obesity (BMI > 30) as a *moderate* risk factor for pre-eclampsia**; a combination of moderate factors (e.g., obesity + first pregnancy + age ≥ 35 + family history) may lead a clinician to offer **low-dose aspirin (commonly 81 mg/day in the US), started between 12 and 28 weeks (ideally before 16 weeks) and continued to delivery**. Femio explains *what aspirin is for and why a clinician might offer it* — **never** a dose instruction, never "you should take it." [USPSTF; ACOG Practice Advisory (low-dose aspirin)]

**VTE / blood-clot awareness (educational context, no dosing).** A raised BMI is an important, independent risk factor for VTE in pregnancy and especially **postpartum**. RCOG risk-assessment guidance (GTG 72 / 37a) describes that a woman with **BMI ≥ 30 plus two or more additional risk factors** may be considered for prophylactic **low-molecular-weight heparin (LMWH)**, with weight-based dosing decided by her team. Femio content explains *what VTE is, the leg/chest warning signs to report, and why a clinician might discuss clot-prevention injections* — **never** doses or titration. Leg pain/swelling/redness (usually one leg) and chest pain/breathlessness are **report-now** signs. [RCOG GTG 72 & 37a; NICE risk-assessment tool]

**Weight stigma is a clinical-safety issue (why the tone rules exist).** Roughly **1 in 5 pregnant/postpartum women report weight stigma in care, most often from obstetricians**; experiencing weight stigma is linked to feeling shamed, disempowered and unheard, to weight-based disparities in respectful care, and — at childbirth — to **higher odds of cesarean**. Weight-inclusive practice (reduce the focus on the number, use person-first/preferred language, respectful imagery, non-judgmental framing) measurably improves experience. This is the evidence base for D12's non-shaming design, not a nicety. [BMC Pregnancy & Childbirth (weight-stigma experiences; cesarean odds); person-first language guides]

Medical-review resolution: guideline permalinks are pinned to ACOG PB230 (June 2021, reaffirmed 2025), RCOG Green-top 72 (22 November 2018; second edition in development), NICE NG247 (15 January 2025), and the National Academies’ 2009 report. Femio does not publish a MENA-specific glucose table or fixed BMI-based scan/anaesthetic pathway; those remain clinician- and system-specific. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

D12 = the **D1 spine (week content, appointments, warning-signs, weight-gain band)** + a **weight-inclusive risk-education & extra-monitoring layer**. Nothing from D1 is removed; the emphasis is respect.

**P0 — must-have (the D12 layer)**
1. **Weight-inclusive weight-gain guidance** — her **IOM band for BMI ≥ 30 (5–9 kg / 11–20 lb)** shown as a *supportive* educational range with trend, no score, no "too fast/too slow" alarm, no diet plan, weighing fully optional. Explicit anti-shame copy (see K). *This is the flagship differentiator vs both diet apps and generic trackers.*
2. **"Higher-BMI pregnancy, explained" education hub** — respectful, cited, non-fear-mongering risk education (GDM, pre-eclampsia, VTE, birth) with the honest counter-message that these are watched and often reducible (see F).
3. **Clinician-directed appointment & scan tracker** — records the visits, scans, screening, or anaesthetic review the user’s care team schedules; Femio does not generate fixed gestational-week or BMI triggers.
4. **Aspirin & VTE context cards (educational)** — *what they are, why a clinician might discuss them* — no dose, no instruction.
5. **Clinician-shareable export (PDF/CSV)** — appointments, scans, weight trend, any user-recorded meds — the thing her team asks for.
6. **Red-flag safety layer (inherited + D12-tuned)** — persistent warning-signs; contextual boxes for pre-eclampsia signs, **VTE/leg-and-chest signs**, reduced fetal movement.

**P1 — high value**
7. **Optional medication log (educational)** — record aspirin / LMWH *as prescribed* for her own pattern-tracking + export. **No dose suggestions.**
8. **Respect toolkit** — a short, optional module: her rights to respectful care, how to state a weight-communication preference to her team, how to decline routine weighing if her guidelines allow (framed as "discuss with your clinician").
9. **Kick counter / contraction timer (from D1, T3)** — unchanged.
10. **Appointment-prep + advocacy prompts** — question banks tuned to the fraught conversations (weight, birth choices).

**P2 — differentiators / later**
11. Body-inclusive, diverse imagery library (larger bodies represented respectfully across all pregnancy content).
12. Gentle, moderated plus-size-pregnancy peer support / curated Q&A (privacy-safe, only if moderation is guaranteed) — communities are a major support source here.
13. Postpartum bridge card → **E1/E4** (continued VTE awareness, wound-care if cesarean, self-chosen wellbeing — never an imposed weight-loss push).
14. Culturally-literate nutrition education (MENA staples), weight-neutral, dietitian-reviewed — *supportive*, never a restrictive plan.

**Explicitly out of scope (compliance):** any **diet plan, calorie/weight-loss target, or "over budget" warning**; any "you're gaining too much/fast" auto-verdict; any BMI-driven "your pregnancy is high/low risk" verdict presented as a diagnosis; any aspirin/LMWH **dose calculator**; any prediction of macrosomia/cesarean/outcome. Weight and meds are **user-recorded tracking data with educational context only.**

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL). Additive, weight-inclusive hub on the D1 library; always searchable.

- **"A higher BMI and your pregnancy" primer** — respectful, plain-language: what the "high-risk" label does and doesn't mean, that most women with a higher BMI have healthy pregnancies, that closer monitoring is *support not judgment*, and an explicit *this app will never shame you or put you on a diet* note.
- **The extra care you may be offered** — consultant-led care, additional growth/position scans (~32/36 wk and why), anaesthetic review (~BMI ≥ 40), early/routine GDM screening — each explained as reassurance, with "what to ask."
- **Healthy weight gain, without the shame** — the IOM band for BMI ≥ 30, *why* ranges differ by starting BMI, honest note that guidelines don't distinguish obesity classes, and firm anti-shame framing ("this is a guide, not a grade; your clinician sets what's right for you; weighing is your choice").
- **The chances your team watches for, explained kindly** — GDM, pre-eclampsia, VTE, birth considerations — real, cited, non-catastrophic, each paired with "this is watched and often reducible" and a link to the relevant warning signs. Sets D3/D6 blends.
- **Low-dose aspirin, explained (educational)** — what it is, why a clinician might offer it when moderate risk factors combine, safety questions to ask. No dose.
- **Blood clots (VTE), explained (educational)** — why a raised BMI raises the chance (especially after birth), the leg/chest warning signs to report today, what clot-prevention injections are and why a clinician might discuss them. No dose.
- **Birth choices and your body** — honest, gentle: induction/cesarean conversations, epidural/anaesthetic considerations, and her right to be part of the decision — never "your BMI decides."
- **Getting respectful care** — naming weight stigma, that she deserves respect, how to set a communication preference with her team, how to ask questions and advocate.
- **Warning-signs hub (inherited)** — CDC Hear Her list always reachable; **pre-eclampsia** and **VTE/leg-and-chest** signs foregrounded as symptoms-to-report, never diagnosis.
- **After birth** — continued VTE awareness, wound-care if cesarean, feeding, and a *self-directed*, non-judgmental note on wellbeing (bridges to E1/E4) — no imposed weight-loss agenda.
- **Emotional wellbeing** — validating the stigma/anxiety many carry; soft pointer to mood screening ("screening, discuss with clinician"); when to seek support.

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Logs & tools**
- **Weight log → supportive IOM band (BMI ≥ 30: 5–9 kg / 11–20 lb).** Shows *her own* trend against the educational band. Copy: *"This is general guidance based on IOM ranges — a guide, not a grade. Your clinician sets what's right for you, and weighing yourself is completely your choice. Femio will never score you, judge you, or tell you you're gaining 'too much.'"* No pass/fail, no red "over" state, no diet, weighing skippable.
- **Extra-appointment / scan log** — consultant visits, growth scans, anaesthetic review, extra screening; provider, notes, results (user-entered), reminders.
- **Medication log (educational, optional)** — aspirin / LMWH *as prescribed*, name + time, user-recorded for pattern-tracking + export. Copy: *"Record only. Femio never recommends or adjusts doses — follow your clinician."*
- **Export (PDF/CSV)** — appointments, scans, weight trend, meds, notes for her care team.
- **Kick counter / contraction timer (T3, inherited from D1)** — unchanged, same compliant framing.

**Alerts (all opt-in, calm, non-alarmist, never weight-focused)**
- Appointment / scan reminders.
- Gestational-milestone + content nudges (inherited).
- Optional aspirin reminder **only if she chooses to set one** (she records it; Femio never prompts a dose).
- **No** weight nudges, **no** "you're gaining too fast," **no** predictive/diagnostic or "you're high-risk" auto-verdicts, **no** diet prompts.

**Red-flag box pattern (reusable component, D12-tuned — adds VTE signs).**
> **⚠ Seek care now**
> Contact your maternity provider or local emergency number right away if you have: pain, swelling, redness or warmth in one leg (calf/thigh) · chest pain, trouble breathing or coughing up blood · a severe headache that won't go away or vision changes · severe swelling of your face/hands · pain in the upper-right of your tummy · heavy vaginal bleeding or fluid leaking · fever of 38°C/100.4°F or higher · (after ~28 wk) your baby moving noticeably less than usual · thoughts of harming yourself.
> *You know your body best — if something feels wrong, get it checked. This app can't diagnose or treat.*
> [Save my maternity/emergency contact] [Learn the warning signs]

Placement: persistent nav entry + auto-injected on the VTE and pre-eclampsia content, and on any symptom explainer with an associated danger sign (leg symptoms, headache, swelling, movement, breathlessness).

---

## H. EMR fields (core vs persona-specific)

**Core (shared across all Femio personas — carried in from cycle/TTC/D1)**
- Identity/account, locale/language, units (kg/lb).
- DOB / age; height; **pre-pregnancy / booking weight & BMI** (the field that resolves D12).
- Menstrual history; LMP.
- Medical-history flags (diabetes, hypertension, thyroid, **prior VTE**, PCOS, prior GDM, prior pre-eclampsia).
- Medications, allergies, supplements.
- Prior pregnancies/outcomes (gravida/para); prior large baby.
- Consent/privacy settings; emergency/maternity contact (optional).
- **Weight-communication preference** (e.g., "don't show me the number / don't nudge me about weight") — a respect-first setting, honored app-wide.

**Persona-specific (high BMI — layered over the constant core EMR, on top of D1's pregnancy fields)**
- **Booking BMI band = obese (≥ 30)** — the D1 → D12 resolver key; used only to *surface education and monitoring scaffolding*, never to render a risk verdict. Optionally obesity class (I/II/III) if she enters it, noting guidelines often don't differentiate.
- **IOM weight-gain band** = 5–9 kg / 11–20 lb (auto from BMI, clinician-adjustable, editable, clearly labeled a guide).
- **Weight series** — user-entered, optional; trend vs band for *her own* reference only.
- **Care-pathway flags** (user-recorded): consultant-led care, extra growth scans (~32/36 wk), anaesthetic review offered, early GDM screen offered.
- **Prophylaxis context flags** (user-recorded, educational only): aspirin discussed/prescribed; VTE-risk assessment / LMWH discussed.
- **Medication log** — aspirin / LMWH, name + time, *user-recorded as prescribed*; no dose logic.
- **Extra-visit / scan log** — consultant, growth scans, anaesthetic review, results (user-entered).
- **Birth-planning notes** — induction/cesarean/anaesthetic discussion, preferences (user-entered).
- Inherited D1 fields (EDD/GA, BP-if-logged, kick/contraction sessions, symptom/mood series) all retained.

---

## I. Personalization rules (layered on the D1 pregnancy base; hidden-but-reachable)

**D12 does not re-onboard.** It activates *on top of* an existing D1 pregnancy context when a booking BMI ≥ 30 is present — additive, respectful emphasis, nothing hidden or removed.

**Activation (wizard delta, short & editable/resettable — personalize, never restrict).**
1. Trigger: booking BMI ≥ 30 already in her record (carried from cycle/TTC/booking), or she indicates her clinician is monitoring her more closely because of her weight. Offered gently: *"Because of your booking BMI you may be offered some extra care. Want Femio to add respectful, plain-language info and a place to track it? No judgment, no diet — you can turn this off anytime."*
2. Quick set-up: **weight-communication preference** (show/hide the number; nudge me or never) — asked *first* and honored throughout; units (kg/lb); who (if anyone) she shares with (X2 partner).
3. Optional: enter clinician-adjusted weight-gain range (else default educational band, clearly labeled editable and a guide, not a grade).

**Home configuration (GA-driven, inherited from D1, with a respectful D12 layer on top).**
- **Entry / early:** the "A higher BMI and your pregnancy" primer and "the extra care you may be offered" are foregrounded, tone dialed firmly to respect + reassurance; the appointment/scan tracker surfaced.
- **T1:** aspirin/VTE educational context cards available (if relevant to her recorded factors), warning-signs (incl. VTE) primed.
- **T2:** extra-scan/appointment tracking and the (non-shaming) weight-gain module foregrounded; GDM-screening prep (she is offered it) — if GDM is later recorded, **blend D3**.
- **T3:** growth-scan (~32/36 wk) and birth-choices content surface; kick counter + contraction timer as in D1; pre-eclampsia (**blend D6** if signs/BP recorded) and VTE warning-signs prominent.
- **Weight-communication preference honored everywhere:** if she opted out of seeing the number, the weight tool shows trend-only or is hidden, and no weight nudge ever fires.

**Hidden-but-reachable rule.** Nothing is locked. The full D1 pregnancy experience stays intact and foregrounded; the D12 layer is *added*, every article/tool stays in the library and search, and she can collapse/de-emphasize the risk layer (or the weight tool entirely) without losing it.

**Continuity.** Her D1 pregnancy record and core history (booking BMI, prior GDM/pre-eclampsia/VTE, PCOS) seed D12 automatically — no separate app, no re-entry; a one-time *"your pregnancy history is here, this just adds respectful info and tracking for the extra care you may be offered, and it's all private"* note.

---

## J. Adaptation triggers (state transitions)

Universal events (positive test, loss, mood-screen-high, red-flag, disengagement, mode-off) are **inherited from the Master Adaptation Model §6** and not restated. Below are the **D12-specific** transitions.

**INTO D12:**
- **From D1** — booking BMI ≥ 30 present, or user indicates closer weight-related monitoring → offer to add the weight-inclusive risk/monitoring layer to her existing pregnancy mode; carry all D1 context; **privacy step:** reassure her weight + pregnancy status is never sold, never employer/insurer-visible, and confirm partner-sharing scope. Additive emphasis — **never a diagnosis, never a "you are high-risk" verdict**; frame as *"here's respectful info and a place to track the extra care you may be offered."*
- **From C/TTC via positive test (inherited universal handler)** — if booking BMI ≥ 30, the positive-test transition lands in D1 flagged toward D12 emphasis from the start.

**Within pregnancy (additive blends, never restriction, never diagnosis):**
- **GDM diagnosis / abnormal glucose screen recorded** → **blend D3** (glucose/meal/appointment tools); higher-BMI raises GDM chance so this link is primed. Education + tracking, never a verdict.
- **Elevated BP / pre-eclampsia signs recorded** → **blend D6** (gestational HTN/pre-eclampsia awareness); foreground warning-signs. Education + "seek care," never a diagnosis. (D12 ⊕ D3 ⊕ D6 is a realistic stacked blend — safety layers **union-merged** per Master Model §8.)
- **Aspirin / LMWH recorded** → surface the matching educational card + optional med log (still D12, no dosing).
- **Repeated low-mood logs / positive mood screen** → **D11** antenatal anxiety/depression emphasis (screening framing) — stigma-related distress is common here, watch gently.
- All D1 content stays fully available; the resolver blends emphasis.

**OUT of pregnancy:**
- **Delivery/birth logged (inherited universal handler)** → transition to **Postpartum (E1)**; carry forward **continued VTE-risk awareness** and, if she had a complicated course (GDM→ E4 OGTT reminder; HTN → BP follow-up), the relevant E4 carries; **E2** if breastfeeding; wound-care content if cesarean. Any wellbeing/weight content postpartum is **self-directed and non-judgmental** — never an app-imposed weight-loss push.
- **Pregnancy loss / stillbirth logged (inherited universal handler)** → immediate, dignified transition to **loss/grief (E6)**: stop all pregnancy reminders instantly; **suppress all weight/appointment prompts**; grief resources; no re-prompting.
- **Reset/withdraw:** she can drop the D12 layer (or just the weight tool) or exit pregnancy mode anytime; data retained per her privacy settings, nothing forced.

---

## K. Compliance flags

- **Weight-stigma-aware, non-shaming copy (per femio-compliance-privacy + femio-medical-content skills) — the defining D12 rule.** All weight and risk content must be **weight-inclusive and non-judgmental**, grounded in the evidence that weight stigma harms care (≈1 in 5 report it; linked to higher cesarean odds and disrespectful care). Concretely: **person-first / preferred language** (honor her weight-communication preference; offer "higher weight / larger body" rather than loaded terms); **reduce the focus on the number** (weighing optional, number hideable, trend-only mode); **no diet, no calorie/weight-loss target, no "over budget" or "gaining too fast" warning, no red/fail states, no gamified grading**; risks stated plainly but **always paired with "watched and often reducible" and "most higher-BMI pregnancies are healthy."** Never belittling, never exceptionalizing. Copy human-reviewed for tone in all four languages.
- **Weight-gain guidance is an educational IOM band, not a target or grade:** BMI ≥ 30 → 5–9 kg / 11–20 lb, shown as a guide, clinician-adjustable, editable; app never scores her or says she is gaining "too much/too little."
- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention claims, no medical-device functionality. The weight log and medication log are **tracking aids for user-entered data**, not tests or verdicts; the app never renders a "high-risk" diagnosis from BMI.
- **No dosing / no calculators:** categorically no aspirin or LMWH dose recommendation, no titration. Medication content is general, cited, and defers every decision to the clinician.
- **Screeners = "screening, discuss with clinician":** GDM glucose screen and any mood screen framed as screening, never verdicts.
- **Red-flag routing:** pre-eclampsia signs, **VTE leg/chest signs**, reduced fetal movement use "seek care now" framing pointing to her provider / local emergency number; never reassures ("your baby is fine"), never alarms with a diagnosis.
- **Privacy-by-design (GDPR/PDPL, health data):** BMI/weight is sensitive data layered on sensitive pregnancy data — minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility** (acute here: weight + pregnancy is highly sensitive to employer/insurer exposure). Partner sharing opt-in and granular. Loss/withdrawal → immediate suppression of all pregnancy + weight reminders and honored deletion.
- **Content provenance:** every medical claim medically reviewed + cited to Tier-1 (CDC/NIH/MedlinePlus/NHS) / Tier-2 (ACOG/RCOG/NICE); review dates surfaced; no clickbait, no sponsored/diet content interleaved with medical guidance.
- **i18n/RTL + inclusive imagery:** all safety/red-flag copy human-reviewed in AR/EN/FR/ES (not machine-only) given clinical stakes; imagery represents larger bodies respectfully; nutrition examples culturally adapted (MENA staples) and weight-neutral, never a restrictive plan.
- **Reviewed source set:** ACOG PB230, RCOG Green-top 72, NICE NG247, and the National Academies’ 2009 report are pinned in Sources. Fixed regional glucose, scan, anaesthetic, and emergency-service pathways are not generated by Femio; clinician plans are entry-only and urgent symptoms use the global urgent-routing policy. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## Sources

- [ACOG — Obesity and Pregnancy (patient FAQ)](https://www.acog.org/womens-health/faqs/obesity-and-pregnancy)
- [ACOG — Weight Gain During Pregnancy (Committee Opinion; IOM ranges)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2013/01/weight-gain-during-pregnancy)
- [ACOG — Low-Dose Aspirin Use for the Prevention of Preeclampsia (Practice Advisory, 2021)](https://www.acog.org/clinical/clinical-guidance/practice-advisory/articles/2021/12/low-dose-aspirin-use-for-the-prevention-of-preeclampsia-and-related-morbidity-and-mortality)
- [USPSTF — Aspirin Use to Prevent Preeclampsia (recommendation; obesity as moderate risk factor)](https://www.uspreventiveservicestaskforce.org/uspstf/recommendation/low-dose-aspirin-use-for-the-prevention-of-morbidity-and-mortality-from-preeclampsia-preventive-medication)
- [NICE / RCOG — Obstetric thromboprophylaxis risk-assessment tool (NG89 resource)](https://www.nice.org.uk/guidance/ng89/resources/royal-college-of-obstetricians-and-gynaecologists-risk-assessment-tool-pdf-4787150509)
- [RCOG — Care of Women with Obesity in Pregnancy (Green-top Guideline No. 72)](https://obgyn.onlinelibrary.wiley.com/doi/pdfdirect/10.1111/1471-0528.15386)
- [RCOG — Being Overweight in Pregnancy and After Birth (patient information)](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/being-overweight-in-pregnancy-and-after-birth/)
- [NHS — Overweight and Pregnant](https://www.nhs.uk/pregnancy/keeping-well/overweight/)
- [NCBI StatPearls — Obesity in Pregnancy](https://www.ncbi.nlm.nih.gov/books/NBK572113/)
- [PMC — Obesity in Pregnancy: Risks and Management](https://pmc.ncbi.nlm.nih.gov/articles/PMC4989730/)
- [PMC — The Relationship between Obesity and Pre-Eclampsia](https://pmc.ncbi.nlm.nih.gov/articles/PMC9101603/)
- [ScienceDirect — Venous Thromboembolism in Pregnant Obese Individuals](https://www.sciencedirect.com/science/article/abs/pii/S1521693424000178)
- [NAM/IOM 2009 — Weight Gain During Pregnancy: Reexamining the Guidelines](https://www.nationalacademies.org/read/12584/chapter/2)
- [CDC — Gestational Weight Gain (US data; IOM ranges)](https://www.cdc.gov/mmwr/preview/mmwrhtml/mm6443a3.htm)
- [Sara Wickham — Plus-Size Pregnancy: Why Weight Stigma Matters](https://www.sarawickham.com/articles-2/weight_stigma/)
- [BMC Pregnancy & Childbirth — Pregnant and Postpartum Women's Experiences of Weight Stigma in Healthcare](https://bmcpregnancychildbirth.biomedcentral.com/articles/10.1186/s12884-020-03202-5)
- [PMC — Experiencing Weight Stigma During Childbirth Increases the Odds of Cesarean Birth](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11846236/)
- [PMC — Weight-Based Disparities in Perinatal Care (Canadian survey: respect, autonomy, mistreatment, BMI)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11549742/)
- [PMC — Prenatal Care Experiences Among Pregnant Women with Obesity (qualitative QI)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7885492/)
- [EASO — Person-First Language Guide: Addressing Weight Bias](https://easo.org/wp-content/uploads/2024/05/Person-First-Language-guide-addressing-Weight-Bias.pdf)
- [Collectif Vital — Guide for Using Weight-Inclusive and Non-Stigmatizing Language](https://collectifvital.ca/files/P2-Enjeux_poids/Trousse-anglais/2_New_langage%20inclusif_ang.pdf)
- [BMC Pregnancy & Childbirth — Reducing Weight Stigma in Perinatal Care (unintended consequences of measuring GWG)](https://bmcpregnancychildbirth.biomedcentral.com/articles/10.1186/s12884-025-07898-1)
- [CDC — Urgent Maternal Warning Signs (HEAR HER Campaign)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)

*Primary links: [ACOG Practice Bulletin 230—Obesity in Pregnancy (June 2021; reaffirmed 2025)](https://www.acog.org/clinical/clinical-guidance/practice-bulletin/articles/2021/06/obesity-in-pregnancy); [RCOG Green-top Guideline 72 (22 November 2018)](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/care-of-women-with-obesity-in-pregnancy-green-top-guideline-no-72/); [NICE NG247 (15 January 2025)](https://www.nice.org.uk/guidance/ng247/chapter/Recommendations); [National Academies—Weight Gain During Pregnancy (2009)](https://nap.nationalacademies.org/catalog/12584/weight-gain-during-pregnancy-reexamining-the-guidelines). Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.*
