# Persona D9 — Pregnant with Multiples (Twins / Triplets / Higher-Order)

Prepared: 2026-07-17 · Wave 3 · Status: research + spec
Base layer: **D1 (uncomplicated pregnancy)** — D9 inherits all of D1 and re-layers multiple-gestation content, tools, and alerts on top.
Aligns with: 09_MASTER_ADAPTATION_MODEL · 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · D1_pregnancy_uncomplicated · femio-compliance-privacy · femio-medical-content skills
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening, discuss with clinician."** Higher baseline risk in multiples raises the *volume* of red-flag awareness — it never turns Femio into a triage or diagnostic tool.

---

## A. Persona snapshot

**Who she is.** A pregnant woman carrying **two or more babies** (most commonly twins; also triplets / higher-order). Her pregnancy is, by definition, **higher-risk** than a singleton: more appointments, more scans, elevated rates of pre-eclampsia, gestational diabetes (GDM), anemia, and preterm birth, and a shorter expected pregnancy. A pivotal, twin-specific fact she learns early is **chorionicity/amnionicity** (whether the babies share a placenta and/or sac) — this single classification drives how intensively she is monitored. She arrives at D9 in one of three ways: (1) a prior Femio D1 user whose dating/anatomy scan reveals multiples, (2) a TTC/IVF user (multiples are more common after fertility treatment) who converts on a positive test and later confirms two sacs, or (3) she onboards already knowing.

**Core job.** "I'm carrying more than one baby — walk me through a *twin* pregnancy specifically: what's different, why I have so many extra scans, what chorionicity means for me, how much weight and iron I actually need, what the warning signs are, and when 'preterm' becomes my normal — without pretending I'm having a singleton and without scaring me."

**Emotional arc (layered on D1's arc, compressed and intensified).**
- **T1 (wk 4–13):** the singleton excitement/anxiety of D1 **plus** the "wait — there are two?" adjustment; a strong hunger for twin-specific information; early fixation on the **chorionicity result** (di/di vs mono/di vs mono/mono) once she learns it determines her monitoring; heightened miscarriage/vanishing-twin worry.
- **T2 (wk 14–27):** more scans than her singleton friends (growth + TTTS surveillance for monochorionic); **anatomy scan is bigger** (two+ babies); GDM screening and anemia bloodwork loom larger; weight-gain and nutrition questions become urgent and *different* from singleton norms; NICU/preterm reality starts to feel real.
- **T3 (wk 24–37):** discomfort arrives **earlier and harder** (she is "measuring" much further along); intense preterm-labour vigilance; birth-planning is complex (mode of birth, which hospital, NICU capability); the calendar is short — **twins are commonly delivered ~36–37 weeks, triplets earlier**, so her "finish line" is weeks before a singleton's and post-dates anxiety is replaced by *"will they come too early?"*

**Context.** Web-first, mobile-heavy, Arabic-first / RTL primary with EN/AR/FR/ES. Opens the app very frequently (appointment density + information hunger). Often **blends** with other complication personas: **D3** (GDM), **D6** (pre-eclampsia/gestational HTN), **D8** (preterm-birth risk/history), and IVF/AMA context (D13). Wants a partner who can follow the more intense schedule (X2).

**Success = she feels informed as a *twin* mum specifically** (not a singleton user with a "×2" bolted on), understands her extra monitoring instead of being frightened by it, keeps a busy appointment/scan calendar in one place, gets twin-correct weight/nutrition guidance, and trusts that a genuine red flag (preterm labour, pre-eclampsia, reduced movement in *either* baby) is surfaced loudly and routed to care.

---

## B. Needs & questions (voice-of-user)

Mined from r/parentsofmultiples, twin-pregnancy community threads (BabyCenter/What to Expect multiples groups, Twins Trust / Twiniversity forums) and app-store reviews. Representative paraphrases, grouped by job-to-be-done. **Bold = twin-specific need not covered by D1.**

**Reassurance / "is this normal for twins?"**
- "Everyone keeps telling me twin-pregnancy stuff based on *their* singleton — is any of this app actually for me?"
- **"I'm mono-di — what does that even mean and why do I need scans every 2 weeks?"**
- **"I'm terrified of TTTS. What are the actual signs and when do I call?"**
- "One twin measured smaller than the other — is that normal or a problem?" (growth discordance)

**Twin-specific development & why-so-many-appointments**
- **"Why do twin mums get so many more scans than singleton mums?"**
- **"Can I track each baby separately — Baby A and Baby B — their own size and position?"** (recurring, strong signal; singleton apps can't)
- "How big are they *each* this week, not combined?"
- **"When do twins usually arrive? Everyone says don't expect 40 weeks."**

**Weight & nutrition (different numbers from singletons)**
- **"How much weight should I gain with twins? The app keeps giving me singleton numbers and I feel like I'm failing."** (very common frustration)
- **"How many extra calories / how much iron and folate for twins?"**
- "I'm so anemic — is that a twin thing?" (yes — far more common)

**Complication vigilance (higher baseline)**
- **"Twins = higher pre-eclampsia and GDM risk — what am I watching for and when do they test me?"**
- "My blood pressure is creeping up / I passed protein — what does that mean?" (→ D6 blend, never diagnosis)
- **"How do I tell Braxton Hicks from actual preterm labour? I've heard twins come early."** (→ D8 blend)

**Appointments, scans & logistics**
- **"I have MFM + regular OB + growth scans + TTTS scans — I can't keep the calendar straight."**
- "What actually happens at a twin anatomy scan vs a singleton one?"
- **"Which hospital — does it have a NICU / level-3 unit? What questions do I ask?"**

**Birth & NICU prep**
- **"Vaginal vs C-section for twins — what decides it?"** (framed as "discuss with your clinician")
- **"How do I prepare for a possible NICU stay / premature babies?"**
- "Hospital bag for twins — anything different?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- **Singleton-only design:** most apps assume one baby; twin content is an afterthought or absent. "It literally won't let me say I'm having twins."
- **Wrong weight-gain guidance** (singleton IOM bands shown to twin mums → feels judged/failing).
- **No per-baby tracking** (can't log Baby A / Baby B growth, position, or scan results separately).
- Being forced into singleton milestone framing ("40-week countdown") when her babies will likely arrive weeks earlier — the countdown becomes a source of anxiety, not delight.
- Same D1 frustrations amplified: ad clutter, privacy dread, poor handling of loss (incl. **loss of one twin** — a scenario virtually no app handles with dignity).

---

## C. Competitor teardown

Twin-pregnancy support is the single biggest content/UX gap in the category. Most mainstream apps are **singleton-first**; dedicated twin apps exist but are niche, English-only, and weak on privacy and clinical rigor. This is a clean wedge for Femio.

| Capability (twin lens) | What to Expect | BabyCenter | Pregnancy+ | Ovia | Flo | Twiniversity (dedicated) | Twins Trust (charity) |
|---|---|---|---|---|---|---|---|
| Declares/handles multiples at all | Content exists, UI singleton-first | **Added dedicated twin features late 2024** (twin weekly content, twin community, comparative size) | Singleton-first | **Dual-baby tracking** (per-twin weight/growth/milestones) — strongest mainstream | Weak; singleton-first | **Twin Pregnancy Mode + Twins Mode** — purpose-built | Twin pregnancy countdown + charity info, not a full tracker |
| Per-baby (A/B) tracking | No | Partial | No | **Yes** | No | Partial | No |
| Twin-specific weight/nutrition | Thin | Thin | No | Some | No | Some | Good info content |
| Chorionicity / TTTS education | Minimal | Some articles | Minimal | Some | Minimal | Yes (community-grade) | **Strong, clinically-informed** |
| Twin scan/appointment density support | Generic | Generic | Reminders | Better logging | Reminders | Some | No tracker |
| Privacy posture | Sells data (reported) | Sells data (reported; 2024 Senate inquiry) | Ad-SDK sharing (reported) | Labcorp-owned; employer-plan visibility concern | 2021 FTC settlement | Unclear/niche | Charity, non-commercial |
| Languages / RTL | EN-centric | Multi (no true Arabic-first) | Multi | EN-centric | Multi | EN only | EN only |
| Handles loss of one twin | No | No | No | No | No | No | Bereavement info content |

**Content-quality gaps Femio exploits (twin-specific).**
1. **Singleton-first everything** — twin mums are chronically underserved by the big apps and pushed to niche EN-only tools that lack privacy discipline and clinical citation.
2. **Wrong weight-gain numbers** shown to twin mums (a recurring, emotionally loaded failure).
3. **No dignified per-baby model** — can't represent Baby A / Baby B, growth discordance, or loss of one twin.
4. **Chorionicity/TTTS literacy is thin** in the mainstream apps despite being the defining fact of a twin mum's monitoring.

**Femio's differentiated position for D9.**
1. **True multiples support on one account** — declares 2+ babies, tracks **Baby A / Baby B (…C)** separately (size, position, scan notes), and re-skins content to twin-correct facts — not a "×2" hack. Inherits D1's continuity (cycle/TTC/IVF history carries in).
2. **Twin-correct guidance** — IOM twin weight-gain bands, twin nutrition/iron/folate education, twin monitoring schedule, chorionicity + TTTS awareness — all cited.
3. **Privacy-by-design** — no data sale, no ad SDKs, no employer visibility (vs Ovia/BabyCenter/Flo history).
4. **Arabic-first / RTL** done properly — no twin app does this.
5. **Dignity for the hard paths** — loss of one twin, NICU/preterm reality, and an *honest short countdown* (expects ~36–37 wk, not a 40-week delight-countdown that becomes dread).

---

## D. Clinical grounding (cited)

All figures are **education, not medical advice**; app copy attributes to these bodies and defers all dosing/decisions/diagnoses to the user's clinician and maternal-fetal-medicine (MFM) team. Multiple-gestation care is specialist-led — Femio's job is to explain and organize it, never to run it.

**Chorionicity / amnionicity — the defining classification.** Determining chorionicity (do the babies share a placenta?) and amnionicity (do they share a sac?) **as early as possible — ideally before 14 weeks (ultrasound <13w6d identifies it in ~95% of cases)** — is central to counseling and monitoring, because **monochorionic** (shared-placenta) twins carry substantially higher risk. → Femio explains di/di, mono/di, mono/mono in plain grade 6–8 language, and lets her record her result so content and scan-cadence education matches her type. Never interprets an image; she enters what her clinician told her. [ACOG/SMFM Practice Bulletin 231; ISUOG 2025; NICE NG137]

**Monitoring schedule (why so many appointments).** Multiple pregnancies get **more antenatal visits and extra growth scans** than singletons. **Monochorionic twins are scanned about every 2 weeks from ~16 weeks** to watch for TTTS, growth discordance, and selective fetal growth restriction; dichorionic twins are scanned less often (commonly ~every 4 weeks from the second trimester). Growth scans in multiples are allotted extra time (NICE: ≥30 min). → Femio frames a *typical* twin schedule as an editable checklist, always "your MFM team sets your plan; this is general." [NICE NG137; NHS "Antenatal care with twins"; ACOG PB231]

**Twin-to-twin transfusion syndrome (TTTS) awareness.** TTTS is a complication of **monochorionic (shared-placenta)** twins in which blood flows unequally between the babies through shared placental vessels — one "donor" gets too little, one "recipient" too much. It **affects roughly 10–15% of monochorionic twins**, can range from mild to serious, and when serious is treated at specialist centers (e.g., fetoscopic laser). This is *why* mono twins get 2-weekly scans. → Femio provides **awareness and "signs to report / seek care" education**, never a self-diagnosis tool and never image interpretation; any concerning symptom routes to "contact your maternity/MFM team." [MedlinePlus TTTS; NHS; SMFM Consult Series #72]

**Preterm birth & timing of birth.** Preterm birth is the norm to *prepare for*, not fear as failure: twins commonly deliver earlier than singletons. NICE frames planned birth (to minimize perinatal risk) at **~37 weeks for uncomplicated dichorionic**, **~36 weeks for monochorionic** twins, with **triplets earlier still**; many arrive spontaneously before these dates. → Femio's timeline honestly centers a *shorter* pregnancy, foregrounds **preterm-labour awareness (blend D8)** and NICU-prep education, and avoids a singleton 40-week countdown. [NICE NG137]

**Higher rates of the "big three" complications (surface as awareness, never diagnosis).**
- **Pre-eclampsia** — markedly more common in twins (reported ~14% vs ~3% in singletons; relative risk ~2.6). → Foreground D1's warning-signs hub + **D6 pre-eclampsia awareness**; support optional BP logging with "seek care now" framing.
- **Gestational diabetes** — roughly **double** the singleton rate (reported ~18% in twin pregnancies). → **D3 GDM awareness**; glucose-screen prep.
- **Anemia** — iron-deficiency anemia is ~**2.4–4× more common** and folate-deficiency anemia ~**8× more common** in twins. → Twin nutrition/iron/folate education (below). [Springer/Oxford twin-GDM series; twin pre-eclampsia risk-factor studies; twin nutrition reviews — see Sources]

**Weight gain (2009 IOM twin ranges, by pre-pregnancy BMI — *distinct from singleton D1 bands*).**
- Normal (BMI 18.5–24.9): **16.8–24.5 kg (37–54 lb)**
- Overweight (25–29.9): **14.1–22.7 kg (31–50 lb)**
- Obese (≥30): **11.3–19.1 kg (25–42 lb)**
- Underweight (<18.5): the 2009 IOM/National Academies report did not provide a separate twin range because evidence was insufficient; route to an individualized clinician-set target. The source for the twin table is [*Weight Gain During Pregnancy: Reexamining the Guidelines* (National Academies/IOM, 2009)](https://nap.nationalacademies.org/catalog/12584/weight-gain-during-pregnancy-reexamining-the-guidelines). Femio uses non-judgmental, no-pass/fail framing. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Twin nutrition / supplements.** [NICE NG137, updated 9 April 2024](https://www.nice.org.uk/guidance/ng137/chapter/Recommendations) says to give the same diet, lifestyle, and nutritional-supplement advice as routine antenatal care, while recognizing a higher incidence of anemia and adding a full blood count at 20–24 weeks (plus the routine 28-week test). Femio gives no extra-calorie or iron/folate dose for twins; the maternity team uses results and local guidance to prescribe supplementation. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Mode & place of birth.** Determined by chorionicity, presentation, growth, and complications; delivery is planned at units able to care for premature/multiple babies (NICU/level-appropriate). → Femio educates on the *factors* and "questions to ask," framed as "discuss with your clinician/MFM team," never a recommendation. [NICE NG137; ACOG PB231]

*Source register resolved:* twin weight education uses the [National Academies/IOM 2009 report](https://nap.nationalacademies.org/catalog/12584/weight-gain-during-pregnancy-reexamining-the-guidelines); diet/supplement and anemia-monitoring education uses [NICE NG137, updated 9 April 2024](https://www.nice.org.uk/guidance/ng137/chapter/Recommendations). Antenatal contacts and destinations are country-module content; no generic MENA schedule or supplement dose is published. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

Inherits the entire D1 feature spine; adds multiples-specific capability.

**P0 — must-have (the D9 additions)**
1. **Multiples flag + per-baby model** — declare 2+ babies; **Baby A / Baby B (/C…)** as first-class entities she can name/label and track separately (size-per-baby, position, scan notes, discordance). *This is the headline gap versus every mainstream competitor.*
2. **Twin-correct "This week" home** — twin development content and **per-baby** size (cm/g each, not just combined), twin body-changes, twin-typed timeline that **honestly centers ~36–37 wk**.
3. **Chorionicity/amnionicity record + explainer** — she stores di/di, mono/di, or mono/mono; content and scan-cadence education adapt to it.
4. **Twin monitoring calendar** — typical twin schedule (incl. 2-weekly mono scans, growth scans, MFM visits, TTTS surveillance) as an editable checklist across multiple providers.
5. **Twin weight-gain guidance** — **IOM twin bands** by pre-pregnancy BMI (never singleton bands), same non-judgmental framing.
6. **Twin nutrition/iron/folate education module** — twin-specific energy/iron/folate awareness (educational, no dosing).
7. **Elevated red-flag safety layer** — D1's warning-signs hub **plus** twin-weighted awareness: preterm-labour signs, pre-eclampsia signs, and **reduced movement in *either* baby**; TTTS "signs to report" for monochorionic users.

**P1 — high value**
8. **Preterm-prep & NICU-readiness content** (blend D8) — signs of preterm labour, corticosteroid education ("your team may offer targeted steroids — discuss"), what a NICU stay involves, hospital-selection questions.
9. **Per-baby kick/movement awareness** (T3) — movement education acknowledging two babies; "if *either* baby moves less than usual, contact your provider today."
10. **Partner/shared view (X2)** — follow the denser schedule together.
11. **Rich twin visuals** — illustrations showing two babies and positions.

**P2 — differentiators / later**
12. Twin birth-plan builder (mode-of-birth factors, NICU-aware hospital bag) + export (PDF) of per-baby scan/weight logs for MFM appointments.
13. Curated, moderated twin-parent Q&A/community (privacy-safe) — only with guaranteed moderation.
14. Loss-of-one-twin dignified handling (see J) — retain the surviving baby's timeline while suppressing the lost baby's milestone cues.

**Explicitly out of scope (compliance):** any tool that **interprets** scans, discordance, or Doppler as TTTS / growth restriction / "your babies are fine/at risk"; any "your twin pregnancy is high/low risk" auto-verdict; any dosing calculator (iron/folate/steroids); labour/TTTS "diagnosis." All of these are education + "seek care / discuss with clinician" only.

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL). Inherits all D1 modules; **adds** the twin skin below. Gestational-age-gated but always searchable.

- **"You're having twins" orientation hub** — what changes vs a singleton pregnancy; why more appointments; the emotional adjustment; roadmap for the trimesters.
- **Chorionicity & amnionicity explainer** — di/di vs mono/di vs mono/mono in plain language; why it decides her monitoring; how to record her result.
- **Twin "This week" development** — per-baby size (cm/g each) + optional metaphor; what each baby is doing; twin-typed body changes; honest **shorter-timeline** framing.
- **Twin monitoring & scans** — what growth scans, TTTS surveillance, and MFM visits are and why; what a twin anatomy scan involves; "screening vs diagnostic" reminder inherited from D1.
- **TTTS awareness (monochorionic)** — what it is, that it affects ~10–15% of mono twins, that 2-weekly scans exist to catch it, **signs to report / seek care** — never a self-diagnosis tool.
- **Twin weight-gain guidance** — IOM twin bands, why they differ from singleton, non-judgmental.
- **Twin nutrition & supplements** — energy/iron/folate/calcium education for twins; anemia-awareness; "your clinician sets doses."
- **Higher-risk complication awareness** — pre-eclampsia (→D6), GDM (→D3), anemia; symptoms-to-report framing, never diagnosis.
- **Preterm birth & NICU prep** (→D8) — signs of preterm labour, targeted-steroid education, what NICU is, hospital-selection questions; honest "twins often arrive early."
- **Birth for twins** — mode-of-birth *factors*, presentation, place of birth; "discuss with your clinician."
- **Movement for twins** (T3) — how movement works with two babies; "reduced movement in *either* baby = contact provider today."
- **Emotional wellbeing (twin-weighted)** — the specific overwhelm of a higher-risk, appointment-dense, shorter pregnancy; soft pointer to EPDS-based screening ("screening, discuss with clinician").
- **Loss of one twin** — dignified education for the uniquely hard scenario of losing one baby while carrying another (grief + ongoing care), reachable but never auto-pushed.

---

## G. Tools, logs & alerts (compliant framing; twin-specific red-flags)

Inherits all D1 tools/logs; adds per-baby structure and twin-weighted alerts.

**Logs & tools**
- **Per-baby records (Baby A / B / C…)** — label, chorionicity/amnionicity (once, at record level), per-baby estimated size, position, and user-entered scan notes/results (no app interpretation, no discordance verdict).
- **Twin weight log** → trend vs **IOM twin band**. Copy: *"This is general guidance from IOM twin ranges — different from singleton ranges. Your clinician sets what's right for you."* No pass/fail.
- **Twin appointment/scan calendar** — multi-provider (OB + MFM + growth/TTTS scans), typical-twin-schedule checklist + custom, reminders.
- **BP log (optional)** — for pre-eclampsia awareness (twins = higher risk); elevated readings surface warning-sign content + D6 awareness, never diagnosis.
- **Movement log (T3)** — acknowledges multiple babies; *her own* pattern trend. Copy: *"A tracking aid, not a medical test. If **either** baby is moving less than usual, contact your provider today — don't wait."*
- **Contraction timer (T3)** — inherited; twin framing foregrounds preterm-labour awareness earlier. Copy unchanged: *"A timing tool, not a diagnosis of labour."*
- **Optional export (PDF)** of per-baby scan/weight logs for MFM visits.

**Alerts (opt-in, calm, non-alarmist)**
- Twin scan/appointment reminders (denser cadence, incl. 2-weekly for mono users who record that type).
- Gestational-milestone nudges tuned to a **shorter timeline** (e.g., preterm-prep and hospital-bag nudges arrive *earlier* than for a singleton).
- Content nudges (twin "this week" ready).
- **No** predictive/diagnostic alerts. **No** "you're at risk" or "TTTS detected" pushes.

**Red-flag box pattern (reusable component — twin-augmented).**
> **⚠ Seek care now**
> Contact your maternity/MFM provider or local emergency number immediately if you have: heavy vaginal bleeding or fluid leaking · a severe headache that won't go away or vision changes · sudden severe swelling of face/hands · trouble breathing or chest pain · severe belly pain · fever of 38°C/100.4°F or higher · **regular tightenings/cramping or low back pressure before your babies are due (possible early labour)** · **(after ~26–28 wk) *either* baby moving noticeably less than usual** · thoughts of harming yourself.
> *Twin pregnancies are watched more closely for a reason — you know your body best. If something feels wrong, get it checked. This app can't diagnose or treat.*
> [Save my maternity/MFM contact] [Learn the warning signs]

Placement: persistent nav entry + auto-injected on every twin symptom/complication explainer with an associated danger sign (bleeding, headache, swelling, movement, abdominal pain/tightenings). For monochorionic users, the TTTS-awareness module carries a "signs to report / when to seek care" callout (never a diagnostic checklist).

---

## H. EMR fields (core vs persona-specific)

**Core (shared — carried in from D1/cycle/TTC/IVF).** Unchanged from D1: identity/account, locale/units, DOB/age, height, pre-pregnancy weight & BMI, menstrual history/LMP, medical-history flags, meds/allergies/supplements, gravida/para incl. prior-loss flag, consent/privacy, emergency contact. (IVF/AMA history commonly present → informs D13 blend.)

**Persona-specific (multiples / D9 — additive over D1's pregnancy layer)**
- **Number of fetuses** (2 / 3 / 4+) — the D1→D9 switch marker.
- **Chorionicity & amnionicity** (di/di, mono/di, mono/mono, or "not yet known") — drives scan-cadence and TTTS-awareness content.
- **Per-baby entities: Baby A / B / C…** — label/name, per-baby estimated size series, position, user-entered scan notes/results (no interpretation).
- **Twin weight-gain series** — trended vs IOM twin band.
- **Twin monitoring calendar** — multi-provider visits + growth/TTTS scan log.
- **EDD / gestational age** — inherited single source of truth, but **expected-delivery framing is shorter** (typical planned birth window recorded as education: ~36 wk mono / ~37 wk di / earlier for triplets).
- **BP series** (optional; pre-eclampsia awareness), **glucose notes** (GDM awareness), **anemia/iron notes** — all entry-only, non-diagnostic; elevated values surface D6/D3 awareness content.
- **Complication-awareness flags** carried as *blends*, not diagnoses: pre-eclampsia (D6), GDM (D3), preterm-risk (D8).
- **Loss-of-one-twin flag** (see J) — suppresses the lost baby's milestone cues while retaining the surviving baby's timeline; never mislogged as anything else.

Rule (inherited from master model §3): every field is **surfaced or hidden, never destroyed**. Exiting multiples (delivery/loss) archives the layer, reachable on return.

---

## I. Personalization rules (wizard → home config)

**Wizard (short, editable/resettable — personalize, never restrict).** Inherits D1's pregnancy wizard; the twin path is set by **Q4 "How many babies?"** (in the master model's D-branch) → 2+ sets D9. Follow-ups (all optional, "add later" allowed):
1. Confirmed pregnant (inherited from D1).
2. EDD/LMP (inherited) — but twin timeline reframes to the shorter expected window once multiples is set.
3. **How many babies?** → 2+ → D9.
4. **Do you know your chorionicity?** (di/di · mono/di · mono/mono · not yet) → tunes scan-cadence + TTTS content; "not yet" shows the explainer and a gentle "you'll usually learn this at an early scan."
5. Any conditions your clinician is watching? → GDM/BP/preterm history stack **D3/D6/D8** emphasis without hiding anything.
6. Partner sharing (X2); notification/privacy preferences.

**Home configuration (gestational-age-driven, twin-skinned).**
- **T1 home:** twin-development card (per-baby), "you're having twins" orientation, **chorionicity explainer/record prompt**, early twin-appointment prep, reassurance + warning-signs entry.
- **T2 home:** per-baby development, **twin monitoring/scan cadence foregrounded** (2-weekly for mono), twin weight-gain + nutrition/iron guidance, GDM/pre-eclampsia awareness prep, anatomy-scan (twin) prep.
- **T3 home (starts feeling "late" earlier):** per-baby development, **contraction timer + preterm-labour awareness surfaced earlier than singleton**, movement (either-baby) awareness, **NICU/birth-prep + hospital selection**, warning-signs prominent, honest short-countdown.
- **Monochorionic skin:** 2-weekly scan cadence + TTTS-awareness module foregrounded. **Dichorionic skin:** lighter scan cadence, TTTS module still reachable.
- **Triplets/higher-order:** even shorter timeline, denser monitoring, heavier preterm/NICU emphasis; content notes higher complexity and defers strongly to the MFM team.

**Hidden-but-reachable rule (inherited).** Nothing is locked. Tools surfaced by GA/type (2-weekly scan reminders, TTTS module for mono, contraction timer) remain reachable earlier via tools/search with an "usually used later / for monochorionic twins" note. Singleton D1 content stays fully in the library.

**Continuity.** Cycle/TTC/IVF history seeds GA and personalization; discovering multiples **re-layers** twin content over the unchanged core with a one-time "your history is here and private" note — no re-onboarding.

---

## J. Adaptation triggers (state transitions)

**Inherits all universal events** from the master adaptation model §6 (positive test; pregnancy loss/stillbirth → E6 grief with instant reminder suppression; mood-screen high / crisis; red-flag symptom; disengagement; toggle-off; age-of-consent). Only **D9-specific** transitions are specified here.

**INTO D9:**
- **From D1** — user records **2+ babies** (typically at dating/anatomy scan) or toggles "I'm having twins" → offer transition to multiples mode; **re-layer** twin content/tools/calendar over the unchanged D1 core; **switch weight-gain guidance to IOM twin bands**; prompt (optionally) for chorionicity; reframe the timeline to the shorter expected window. Reversible.
- **From C/IVF (D13-adjacent)** — a fertility-treatment user's positive test that later confirms multiples enters D9 carrying IVF/AMA context as a **blend**, not a relabel.

**Within D9 — additive complication blends (emphasis shift, never restriction, never diagnosis):**
- **Chorionicity recorded as monochorionic** → foreground 2-weekly scan cadence + **TTTS-awareness** module; keep everything else reachable.
- **Abnormal glucose screen / GDM recorded** → blend **D3** (GDM is ~2× more common in twins).
- **Elevated BP / clinician-noted pre-eclampsia or gestational HTN** → blend **D6** (pre-eclampsia ~2.6× more common); foreground warning-signs; never diagnose.
- **Preterm-labour signs logged / prior preterm history / short-cervix noted** → blend **D8** preterm-birth emphasis; surface preterm-prep + NICU content earlier.
- **Thyroid → D7; high BMI → D12; AMA (≥35) → D13; hyperemesis → D15** — same additive-emphasis rule as D1.
- All escalations are **additive emphasis**; D9 (and D1) content stays fully available; the resolver blends per master model §8 (union of safety layers, most-acute wins the hero).

**OUT of D9:**
- **Delivery/birth logged → Postpartum.** Route to **E1**; because multiples raise complication and preterm rates, most D9 users carry forward to **E4** for follow-up (GDM→postpartum OGTT reminder, BP follow-up, anemia) and **E2** if breastfeeding (twin feeding is its own challenge). **Delivery is commonly earlier** (~36–37 wk twins, earlier for triplets), so the birth event and postpartum transition typically fire **weeks before** a singleton's — postpartum + possible **NICU-stay** context should be surfaced without alarm.
- **Loss of one twin** → **dignified partial-suppression**: instantly suppress the lost baby's milestone/celebratory cues and enter Gentle Mode for that baby, **while retaining the surviving baby's ongoing timeline and care** (a scenario no competitor handles). Offer grief resources; never mislog; never re-prompt about the lost baby. This is a D9-unique elaboration of the universal loss handler.
- **Loss of all babies / stillbirth** → universal loss handler → **E6** grief (instant full suppression, Gentle Mode, retain data, no re-prompting, later optional D2/PAL path).
- **Reset/withdraw:** she can exit multiples mode anytime; data retained per privacy settings; nothing forced.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, treatment, prevention, or medical-device functionality. **Higher baseline risk raises red-flag *awareness volume*, not Femio's role** — per-baby tracking, movement/contraction tools, and TTTS content are tracking/education aids, explicitly *not* tests of fetal wellbeing, TTTS, growth restriction, or labour. Copy must state this (avoids medical-device classification per femio-compliance-privacy skill).
- **No interpretation of scans/discordance/Doppler:** per-baby size and scan notes are **user-entered records**, never app-computed verdicts on growth discordance, TTTS, or fetal wellbeing.
- **No dosing / no prescribing:** twin nutrition, iron, folate, and targeted-steroid content is general, cited, and defers all doses/decisions to the clinician/MFM team.
- **Screeners = "screening, discuss with clinician":** NIPT/first-tri, glucose, EPDS, and any twin-specific screening framed as screening, never verdicts.
- **Red-flag routing:** twin-weighted danger signs (preterm labour, pre-eclampsia, reduced movement in *either* baby, TTTS symptoms for mono) use "seek care now" framing pointing to her provider/MFM/local emergency number; never reassures ("your babies are fine") and never alarms with a diagnosis.
- **Weight guidance:** **IOM twin bands** (not singleton), non-judgmental, no scoring, no "you failed" states — the singleton-numbers-shown-to-twin-mums failure is explicitly designed out.
- **Loss handling (twin-specific):** loss of one twin gets dignified partial-suppression (retain surviving baby, suppress lost baby's cues); loss of all → universal E6 grief handler; immediate reminder suppression; honor data deletion/withdrawal.
- **Privacy-by-design (GDPR/PDPL, health data):** minimal collection, explicit granular consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility**; pregnancy + multiples status is sensitive data. Partner sharing opt-in and scoped.
- **Content provenance:** every twin medical claim medically reviewed + cited Tier-1/Tier-2; review dates surfaced; no clickbait, no sponsored content.
- **i18n/RTL:** all twin safety/red-flag copy human-reviewed in AR/EN/FR/ES (clinical stakes; no twin competitor does true Arabic-first — a differentiator *and* a QA obligation).
- **Source/country boundary:** National Academies 2009 and NICE NG137 are pinned in §D. Global copy has no twin-specific calorie/supplement dose, antenatal schedule, or static emergency number; local maternity and emergency routing requires a verified country module. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Tier-1 (NIH / CDC / NHS / MedlinePlus)**
- [NHS — Antenatal care with twins](https://www.nhs.uk/pregnancy/your-pregnancy-care/antenatal-care-with-twins/)
- [MedlinePlus — Twin-to-twin transfusion syndrome](https://medlineplus.gov/ency/article/001595.htm)
- [NCBI Bookshelf (NIH) — Twin and triplet pregnancy (NICE NG137 full guideline)](https://www.ncbi.nlm.nih.gov/books/NBK546070/)
- [StatPearls (NCBI/NIH) — Twin-to-Twin Transfusion Syndrome](https://www.ncbi.nlm.nih.gov/books/NBK563133/)

**Tier-2 (ACOG / RCOG / NICE / SMFM / ISUOG)**
- [NICE NG137 — Twin and triplet pregnancy (overview)](https://www.nice.org.uk/guidance/ng137)
- [ACOG Practice Bulletin 231 — Multifetal Gestations: Twin, Triplet, and Higher-Order Multifetal Pregnancies (SMFM copy)](https://publications.smfm.org/publications/385-acog-practice-bulletin-231-multifetal-gestations-twin-triplet/)
- [ACOG PB231 — Guideline Central summary](https://www.guidelinecentral.com/guideline/308483/)
- [ISUOG Practice Guidelines (2025) — role of ultrasound in twin pregnancy](https://obgyn.onlinelibrary.wiley.com/doi/10.1002/uog.29166)
- [SMFM Consult Series #72 — Twin-twin transfusion syndrome and twin anemia-polycythemia sequence](https://www.ajog.org/article/S0002-9378(24)00760-9/fulltext)
- [BAPM — New NICE Guideline on Twin and Triplet Pregnancies (summary)](https://www.bapm.org/articles/67-new-nice-guideline-on-twin-and-triplet-pregnancies)

**Nutrition / weight / complication rates**
- [Brigham & Women's Hospital — Nutritional Goals During a Twin Pregnancy](https://www.brighamandwomens.org/campaigns/mfm-nicu/nutritional-goals-during-a-twin-pregnancy)
- [perinatology.com — Nutrition in Twin Pregnancies (IOM twin weight-gain bands, iron/folate)](https://www.perinatology.com/Reference/Twins%20Nutrition%20eng.pdf)
- [PMC — Review of Dietary Recommendations for Twin Pregnancy](https://pmc.ncbi.nlm.nih.gov/articles/PMC8953105/)
- [Oxford/JES — Twin Pregnancy Complicated by Gestational Diabetes: Maternal and Neonatal Outcomes](https://academic.oup.com/jes/article/8/6/bvae075/7646748)
- [Springer — Maternal and neonatal outcomes of twin pregnancies complicated by GDM](https://link.springer.com/article/10.1007/s12020-023-03588-0)
- [PMC — Clinical risk factors for preeclampsia in twin pregnancies](https://pmc.ncbi.nlm.nih.gov/articles/PMC8049247/)

**Competitor / community (twin support gap)**
- [Twiniversity — Best Twin Pregnancy App (dedicated Twin Pregnancy Mode + Twins Mode)](https://www.twiniversity.com/best-twin-pregnancy-app/)
- [Twins Trust — Pregnancy Countdown Tool (charity twin resource)](https://twinstrust.org/information/pregnancy-and-birth/finding-out/pregnancy-countdown-tool.html)
- [Irish Twins Momma — Best Pregnancy Apps for Twins 2025 (Ovia dual-baby, BabyCenter 2024 twin features)](https://irishtwinsmomma.com/best-pregnancy-app-for-twins-top-7-apps-in-2025/)
- [Le Baby — baby tracker designed for multiples (per-baby switching)](https://www.lebaby.app/a-recommended-baby-tracker-app-for-multiple-babies)
- (D1-inherited privacy sources: Consumer Reports pregnancy-app privacy analysis; Flo FTC settlement — see D1 §Sources)

*Medical-review note:* public clinical content uses the National Academies/IOM 2009 and NICE NG137 sources above. Community material is internal aggregate design input, not attributable quotation or clinical evidence. Country schedules/destinations require local review. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
