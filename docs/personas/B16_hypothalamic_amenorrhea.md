# Persona B16 — Functional hypothalamic amenorrhea (HA) — low energy availability, over-exercise, stress; eating-disorder- / RED-S-adjacent

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician."
> Research date: 2026-07-21 · Persona band: B (reproductive-age, non-TTC) · Inherits: `09_MASTER_ADAPTATION_MODEL.md`
> Siblings: `B5_irregular_absent_cycles.md` (the undiagnosed upstream state that routes *into* B16 on a low-energy/stress/high-training cluster); `B6_pcos_not_ttc.md` (format reference; different mechanism — B16 is under-fuelling/over-exercise, not androgen excess).
> **WELLBEING-CRITICAL PERSONA.** This spec touches eating disorders, disordered eating, and over-exercise. All content here is recovery-oriented and non-triggering by design: **no calorie targets, no weight-loss framing, no restriction language, weight fields optional and non-shaming.** See §K for the full safeguard set and the National Alliance for Eating Disorders resourcing.

---

## A. Persona snapshot

**Who she is.** "Dana," 24. A dedicated runner and gym-goer who has, over the last year, gradually eaten less and trained more. Her period first got lighter, then irregular, and now it's been gone for five months. She doesn't think of herself as "sick" — she feels disciplined, fit, in control. She's read one line online that says losing your period can be "normal for athletes," and another that says it's serious, and she doesn't know which is true for her. She is **not** trying to conceive. Part of her is quietly relieved not to bleed; part of her is scared something is wrong. Arabic-first (also reads English), web on her phone.

**What she lives with.**
- **A missing period she's half-normalised** — the central signal. She may see it as convenient rather than as her body signalling it's running on empty.
- **Low energy availability (LEA)** — under-fuelling relative to her training load, whether deliberate, accidental (didn't realise she needed more), or driven by disordered eating. The energy her body has left after exercise is too low to run the reproductive system.
- **Over-exercise / high training load** — exercise is identity and coping, not just fitness; the idea of resting or "doing less" feels like loss, not relief.
- **Stress** — perfectionism, life/academic/work pressure layered on top of the physical deficit.
- **Body-image tension and possible disordered eating** — on a spectrum from "just trying to be healthy" through orthorexia/over-control to a diagnosable eating disorder; she may not recognise or may actively hide it. **This is the wellbeing fault-line of the whole persona.**
- **Bone-health blind spot** — no idea that months without a period can be quietly costing her bone, or that "fit" and "low bone density" can coexist.

**Core emotional drivers.** Wants to understand what her missing period *means* without being shamed, alarmed, or told to "just eat more" in a way that lands as a threat to her control. Wants an app that treats the absent period as important information — a health signal worth acting on *with a clinician* — while being gentle enough that it doesn't trigger more restriction, more compensatory exercise, or a spiral. Needs the recovery message ("usually this means more rest and more fuel") delivered so it feels like care and permission, not like weight gain being forced on her.

**Jobs-to-be-done.**
1. Understand that a period stopping is a **health signal to address**, not a badge of fitness or a problem to ignore — gently, without alarm.
2. Learn *why* it happens (low energy availability + exercise + stress switching the cycle off) in a non-shaming, non-triggering way.
3. Understand that recovery usually means **more rest and more fuel and less exercise** — framed as restoring the body, never as weight loss or a diet.
4. Grasp the bone-health stakes (and other long-term stakes) enough to take it seriously — without fear-mongering.
5. Get routed to the right care: a clinician for evaluation, and — where disordered eating is in the picture — a specialist and supportive resources, offered gently.
6. Track her cycle and context (fuel, training, rest, stress, mood) meaningfully **without** a "late" counter, weight pressure, or anything that feeds restriction.

**Success = she stops treating the missing period as normal-or-nothing, understands it as a signal, feels safe rather than judged, and takes it to a clinician (and, where relevant, an eating-disorder specialist) with her body's story in hand — while Femio has added zero fuel to any disordered behaviour.**

---

## B. Needs & questions (voice-of-user)

Mined from HA-recovery communities and resources (No Period. Now What? / the r/xxfitness and HA-recovery discussion space, The HA Society, dietitian HA-recovery writing), RED-S / female-athlete-triad material, and eating-disorder-recovery guidance (see Sources). Paraphrased to avoid quoting individuals, and deliberately filtered to exclude any restriction/numbers talk.

**On normalising vs. worrying (the defining tension):**
- "I'm an athlete — isn't losing your period just part of training hard?"
- "Honestly it's kind of convenient not to have it. Is that bad?"
- "One article says it's fine for athletes, the next says it's dangerous. Which is it for me?"
- "My period's been gone months but I feel completely fine. If nothing hurts, is it really a problem?"

**On the recovery message (and fear of it):**
- "Everyone just says 'eat more and train less' like it's simple. It isn't simple for me."
- "I don't want to gain weight. Is there a way to get my period back without that?"
- "Do I really have to stop running? Running is how I cope."
- "How much rest, for how long? Will I lose all my fitness?"

**On the body / eating (approached with great care):**
- "I don't think I have an eating disorder, I'm just careful about what I eat."
- "I feel like admitting I under-eat means admitting I failed at being healthy."

**On bone health and long-term stakes:**
- "Can not having a period actually hurt my bones? I'm young and fit."
- "I keep getting little injuries / a stress fracture — is that connected?"

**On tracking without triggers:**
- "Every app screams 'YOU'RE 140 DAYS LATE' at me. It makes me feel broken."
- "I don't want to log my weight every day. I just want to understand my body."

**Top recurring questions Femio must answer in-product (all non-triggering, clinician-routed):**
1. Is a missing period actually a problem, or is it normal for someone who exercises a lot?
2. Why do periods stop when you're under-fuelled / over-training / stressed?
3. What does recovery usually involve — and why is *rest and fuel* the direction, not restriction?
4. What is this doing to my bones and long-term health?
5. Who do I see, and what happens at that visit?
6. How do I know if food/exercise has tipped into something I need specialist support for — and where do I get that support, kindly?

---

## C. Competitor teardown

Feature-by-feature, focused on where general trackers actively *fail or endanger* the under-fuelled / HA / eating-disorder-adjacent user — a group most trackers are not merely unhelpful for, but can be quietly harmful to.

| App | Model | HA / under-fuelling handling | "Late" / prediction behaviour | ED / wellbeing safety | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | No HA-aware mode; treats a long gap as a prediction miss or a pregnancy question; nudges toward TTC framing | Shows confident dates and a **"days late" counter** — precisely the badge that makes an HA/ED-recovery user feel broken and can feed compensatory behaviour | Broad symptom logging but **no low-energy-availability or ED-safe framing**; weight/food logging can cut the wrong way | **FTC settlement (2021) for sharing period/pregnancy data; ~$56M class settlement (2025)** — trust damage | HA-aware mode, **no "late" counter**, recovery-oriented non-triggering content, ED-safe design |
| **Clue** | Freemium, science-forward | Adapts to variable cycle length; still surfaces a predicted period; no HA-recovery lane | More conservative than Flo but still predicts a cycle that isn't coming; can imply "late" | Neutral taxonomy, but no ED-aware guardrails | Better EU/GDPR posture | HA/RED-S education skin + bone-health awareness + gentle specialist routing + Arabic-first/RTL |
| **Ovia** | Freemium, health-plan tie-ins | Fertility/pregnancy-oriented; not built for the athlete who *isn't* trying and *is* under-fuelled | Standard confident predictions | Limited; **employer/health-plan data model** especially wrong for this sensitive context | Employer/insurer visibility concerns | Non-TTC, non-employer, privacy-first, wellbeing-safe |
| **MyFitnessPal / calorie-and-exercise trackers** | Freemium, calorie/deficit model | *Actively counter-therapeutic here* — the entire model is intake-vs-burn deficits, the exact frame HA recovery must undo | N/A (not a cycle app) | **High risk**: calorie counting and "net calories" are widely cited as disordered-eating triggers | Ad-driven | Femio is explicitly **not** a calorie/deficit product; models fuel/rest as *support*, never math to minimise |
| **Fitness / training-load apps (Strava, Garmin, etc.)** | Activity/performance | Reward *more* training and streaks; nothing about energy availability or when to rest for health | N/A | Streak/PR mechanics can reinforce over-exercise | Varies | Femio reframes rest and fuelling as legitimate, health-positive, and celebrated — the opposite of streak pressure |
| **Generic symptom-checker sites** | Ad-driven articles | List "athletic amenorrhea" as benign in some places, dangerous in others — the exact contradiction users report | N/A | Overwhelming, sometimes triggering ("lose weight" cross-content) | Ad-tracked | Calm, single, recovery-oriented explanation + bone-health stakes + kind routing, no ad-SDK |

**Cross-cutting failure — the exact B16 gap.** General trackers are *prediction* products; calorie/fitness apps are *deficit/performance* products. For an under-fuelled, over-exercising, possibly ED-adjacent user, both categories are wrong in the same direction: they either (a) invent a "days late" status that makes her feel broken and can trigger compensatory restriction/exercise, (b) push a pregnancy/TTC narrative she doesn't want, or (c) actively reinforce the calorie-deficit and training-streak behaviours that *caused* the amenorrhea. None of them frames the missing period as a **health signal that recovery — more fuel, more rest, less exercise — usually reverses**, and none is built to be safe for someone in or near eating-disorder territory. Femio's answer: **an HA-aware, no-"late"-counter, recovery-oriented, ED-safe experience that treats the absent period as information to act on *with a clinician*, protects bone health awareness, and routes gently to specialist support and the National Alliance for Eating Disorders where disordered eating is in the picture.**

---

## D. Clinical grounding (cited)

> Framing: everything below is presented in-product as **wellness education + screening + "discuss with your clinician."** Femio never tells Dana she has FHA, an eating disorder, or RED-S, never gives a calorie target, and never frames anything as weight loss. FHA is a **diagnosis of exclusion** made by a clinician.

**What functional hypothalamic amenorrhea (FHA) is.** FHA is a form of chronic anovulation *not* due to identifiable organic causes, commonly associated with **stress, weight loss, excessive exercise, or a combination** — the hypothalamic–pituitary–ovarian (HPO) axis is down-regulated so the cycle effectively switches off to conserve resources. It is a **diagnosis of exclusion** requiring history, exam, and work-up [Endocrine Society FHA Clinical Practice Guideline, JCEM 2017; MSD Manual]. Secondary amenorrhea itself = no periods for **≥3 months** (previously regular) or **≥6 months** (previously irregular); an absence of periods for 3+ months warrants evaluation [ACOG — Menstrual Cycle as a Vital Sign; MedlinePlus].

**Why the period stops — low energy availability (LEA).** The mechanism is an **energy deficit**: exercise alone doesn't stop periods — it's the *combination* of exercise and not eating enough, so that too little energy is left over for physiological functions including reproduction, and the body "turns off" the cycle to conserve resources [Cleveland Clinic; UPMC]. In sports-science terms, **low energy availability** is the driver: laboratory work links menstrual disturbance to energy availability below **~30 kcal/kg fat-free mass/day**, with roughly **≥45 kcal/kg FFM/day** associated with normal function — *and higher intake often needed to support bone*. **Femio presents this concept qualitatively only — "your body needs enough fuel for the energy you spend" — and never as a number the user should hit or a target to track, to avoid any restriction framing** [IOC RED-S consensus 2018/2023; energy-availability literature — see Sources]. `[NEEDS SOURCE]` confirm exact EA thresholds/wording before any user-facing copy; thresholds are research constructs, not personal targets.

**Female Athlete Triad and RED-S (the athlete context).** The **Female Athlete Triad** (ACSM) is the interrelationship of **low energy availability (with or without disordered eating), menstrual dysfunction (incl. FHA), and low bone mineral density**. The IOC broadened this to **Relative Energy Deficiency in Sport (RED-S)** — impaired functioning across metabolic rate, menstrual function, bone health, immunity, protein synthesis and cardiovascular health, all stemming from LEA [IOC RED-S consensus 2014/2018/2023; female-athlete-triad literature]. Amenorrhea here is a **flag for RED-S/triad**, warranting evaluation — not a sign of successful training.

**Recovery — the core, safety-critical message.** The guideline-endorsed direction is **correcting the energy imbalance to restore HPO-axis function**, via **increased energy intake, and/or improved nutrition, and/or reduced exercise**, plus **psychological support (e.g., CBT)** where appropriate — i.e., a **multidisciplinary team** (medical + dietitian + mental-health), ideally HA/ED-experienced [Endocrine Society FHA Guideline 2017]. Recovery communities and dietitians consistently frame this as **more fuel, more rest, less/paused intense exercise** [The HA Society; dietitian HA-recovery sources]. **Femio delivers this as restoring the body and permission to rest and fuel — never as a diet, a calorie number, or weight change.** Return of menses can take **months**, and fertility commonly normalises with recovery [Cleveland Clinic; recovery literature].

**Bone health (the under-appreciated stake).** Hypoestrogenism from FHA lowers bone mineral density and raises risk of **stress/fragility fractures**, and — in adolescents — can impair peak bone-mass accrual. The Endocrine Society suggests a **baseline DXA** in anyone with **6+ months of amenorrhea** (earlier with nutritional-deficiency/skeletal-fragility concern), plus adequate **protein, calcium, and vitamin D** [Endocrine Society FHA Guideline 2017; bone-health-in-FHA literature]. Importantly, guidelines favour restoring energy balance first; if hormone therapy is used for bone, evidence favours **transdermal 17β-estradiol with cyclic progestin over combined oral contraceptives** — and a bleed *induced* by the pill can give a **false sense of recovery** that masks ongoing energy deficit. **All of this is educational and clinician-decided — Femio never recommends or doses anything** [Endocrine Society FHA Guideline; Society for Endocrinology; ED-recovery sources].

**The disordered-eating overlap (wellbeing-critical).** LEA may be **inadvertent** (under-fuelling without an eating disorder) *or* driven by **disordered eating / a diagnosable eating disorder** — the two sit on a spectrum and often can't be told apart from the outside; amenorrhea is a recognised sign/complication of eating disorders [National Alliance for Eating Disorders; ACUTE; Endocrine Society FHA Guideline]. Because of this, Femio treats every B16 user with **ED-safe design by default** and routes gently to specialist support (see §K), never labelling her.

**Why tracking still matters (done safely).** A documented picture of the cycle gap plus context (training load, rest, fuelling *qualitatively*, stress, mood, injuries) is exactly what helps a clinician evaluate FHA — itself a diagnosis of exclusion — and sharpens the visit [ACOG vital-sign framing; Endocrine Society FHA Guideline].

*Reviewed threshold policy:* ASRM 2024 provides the 3-month/6-month secondary-amenorrhea definition; Endocrine Society recommends evaluation at 3 months for suspected FHA and clinician-directed DXA at 6 months or earlier with higher-risk features; IOC 2023 rejects one universal EA threshold. Femio displays no EA number or personal target. See [`docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md). *(Reviewed Mohamed K., 23 July 2026.)*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch (and to be safe).**
1. **HA-aware cycle mode (non-triggering variant)** — set at onboarding; disables 28-day assumptions, **never shows a "late"/"days overdue" counter**, models the gap as a **health signal** rather than a countdown, and never asks for a weight or a calorie number to function.
2. **"Your period is a signal" education core** — the calm, central reframe: a period stopping is meaningful information worth addressing *with a clinician*, neither a fitness badge to keep nor a catastrophe. Non-alarming, non-shaming.
3. **Recovery-direction education (ED-safe)** — "recovery usually means more fuel, more rest, and less intense exercise," framed as **restoring your body and giving it permission**, explicitly **never** weight loss, dieting, or calorie counting. No numbers, no targets.
4. **Bone-health awareness module** — why months without a period can quietly affect bone, why a clinician may suggest a DXA around 6 months, and the protein/calcium/vitamin-D framing — supportive, not fear-based.
5. **Gentle specialist + support routing** — offers clinician evaluation always; where an ED-concern screen or self-report suggests disordered eating, gently surfaces specialist routing **and the National Alliance for Eating Disorders helpline (1-866-662-1235)** plus crisis resources — always as care, never as a verdict.
6. **Non-TTC default** — no "trying to conceive?" nudges; TTC/pregnancy reachable but never assumed. (TTC context flagged as needing a clinician — see §J.)
7. **ED-safe design guardrails everywhere** — no calorie/deficit fields, no weight-loss copy, weight optional and non-shaming, no streaks/goals that could reward under-eating or over-exercise. (See §K.)
8. **Privacy-by-design** — local-first where possible, no ad-SDK sharing; especially sensitive given ED/mental-health data.

**P1 — strong differentiators.**
9. Referenced, medically-reviewed HA/RED-S/bone-health content library (Arabic-first + EN/FR/ES), recovery-oriented and non-triggering.
10. **Context tracking, ED-safe:** cycle gap + rest days, training/movement (logged as activity and *rest*, never as calories burned), sleep, stress, mood, injuries/stress-fracture history, fuelling logged **qualitatively** (e.g., "ate regularly today" / "skipped meals") — **never** calorie counts, macros, or weight-as-goal.
11. Mental-health / body-image support module (screening + coping), stigma- and ED-aware, with the "rest and fuel are health" reframe.
12. Gentle "narrow it down with your clinician" routing that *offers* related lanes when signals cluster (e.g., recovery → cycles return → B1; a co-existing PCOS question → B6) — always an offer, never a verdict.

**P2 — depth / retention.**
13. **Recovery-progress framing that celebrates rest and fuelling** (e.g., "rest days logged," "meals not skipped," "return-of-cycle watch") — reframing the reward system away from streaks/deficits and toward restoration. Designed with ED-clinician review.
14. User-entered lab/result tracker (e.g., DXA result, FSH/LH, estradiol, TSH, prolactin, hCG) — entry only, no interpretation.
15. Cycle-and-context "story" view she can screenshot for a visit.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages, ED-safe)

1. **Your period is a signal, not a scoreboard** — a missing period is meaningful information about energy and stress, worth addressing with a clinician; it isn't a sign of being "fit enough" to skip, and it isn't a reason to panic. Sets the calm, non-alarming tone.
2. **Why periods stop when you're under-fuelled or over-training** — LEA + exercise + stress explained qualitatively ("not enough energy left over for everything, so the body pauses the cycle"). **No calories, no weight, no restriction language.**
3. **What recovery usually looks like** — more fuel, more rest, less intense exercise, and support — framed as **restoring your body and permission to rest**, never as a diet or weight change. Honest that it can take months and that fertility usually returns. Explicitly non-triggering, weight-neutral.
4. **Rest and fuel are training too** — reframes rest days and adequate eating as legitimate, health-positive, and strong — countering streak/deficit culture. Athlete-affirming without endorsing over-exercise.
5. **Your bones and a missing period** — how low estrogen from an absent cycle can quietly affect bone, why a clinician may suggest a DXA around 6 months, and the protein/calcium/vitamin-D picture. Supportive, not scary.
6. **RED-S and the female athlete triad in one page** — for athletes: LEA + menstrual changes + bone as connected signals; amenorrhea as a flag to check, not a trophy.
7. **When it's more than "being careful" — and where to get kind support** — gently names the disordered-eating spectrum, normalises asking for help, and routes to specialists and the **National Alliance for Eating Disorders** helpline. Zero judgement, zero numbers.
8. **A pill "period" isn't the same as your period returning** — why a withdrawal bleed on hormonal medication can mask an ongoing energy deficit; why clinicians weigh transdermal estradiol vs. the pill for bone. Educational only, no dosing.
9. **Getting a real evaluation** — what a work-up looks like (history, exam, and labs such as pregnancy test, FSH/LH, estradiol, TSH, prolactin), that FHA is a diagnosis of exclusion, which team helps (clinician + dietitian + mental-health), and how to advocate.
10. **Stress, perfectionism, and your cycle** — the stress arm of FHA; coping and support; when to seek mental-health help.
11. **Tracking that helps your clinician (safely)** — what to log — gap, rest, activity, stress, mood, injuries, *qualitative* fuelling — and, deliberately, **what not to obsess over** (no calorie/weight fixation).
12. **Myths vs. evidence** — "losing your period is normal for athletes," "no period is convenient/harmless," "you can be too fit to have healthy bones," "an app can tell you what's wrong," "eat more = just gain weight."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, **ED-clinician review sign-off**, and — where relevant — an inline support-resource line.

---

## G. Tools, logs & alerts (compliant + ED-safe framing)

**Logs (ED-safe by design)**
- Cycle/bleed log (flow, spotting; **gap shown as a neutral "days since last period" *health-signal* view, never "late"/"overdue"**).
- Context log: rest days, activity/training (as activity **and** rest — **no calories-burned**), sleep, stress, mood/anxiety, injuries / stress-fracture history, fuelling **qualitatively** ("ate regularly" / "skipped meals" — **no calorie counts, macros, or portion targets**).
- Weight: **optional, off by default, non-shaming, never required**, and — for known ED-history users — *suppressible entirely*; **no weight-goal or weight-trend-toward-a-target UI**.
- Optional lab/result entry (DXA, FSH, LH, estradiol, TSH, prolactin, hCG) — entry only, no interpretation.

**Tools**
- **Health-signal cycle view** — shows the gap and context as information to bring to a clinician; **no "late" counter, no prediction pressure, no fertile/"safe" window.**
- **Cycle-and-context insight** — descriptive, supportive correlations ("your longer gaps appear alongside high-training, low-rest, high-stress logs"), framed as *pattern to discuss*, never "caused by," never a nudge to restrict.
- **Recovery-support view** — celebrates rest and fuelling and a return-of-cycle watch; **reward system deliberately inverted away from streaks/deficits.** ED-clinician-reviewed.
- **Visit-prep generator** — one-tap export/print: cycle gap + context trends + questions + standard-work-up checklist + "which team" pointer (clinician + dietitian + mental-health).
- **Screeners (framed as screening, not diagnosis — ED-safe):**
  - Mood/anxiety screen (PHQ-2 / GAD-2 style) → "This is a screening tool, not a diagnosis — consider discussing with a clinician." + crisis resources.
  - **Disordered-eating concern check-in, handled with extra care** → use supportive, non-scored questions written for this product; never call them a validated screen and never return a label. Route to a clinician and the country-selected eating/body-image support path. **Do not reproduce, translate, shorten, or adapt SCOFF** without documented permission and validation; see [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md). *(Morgan et al., 2000 copyright notice; reviewed Mohamed K., 23 July 2026.)*
  - HA-awareness checklist → surfaces "signs worth discussing," always clinician-routed, and *offers* the HA education lane rather than asserting FHA.

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL, ED-safe)**
- **Health-signal check-in prompt** — at a prolonged gap, "It's been about 3 months since your last logged period — many clinicians suggest checking in around this point, and here's why," citing the vital-sign concept. Warm, not scary; offers visit-prep and the "could this be pregnancy?" neutral helper.
- **Bone-health awareness nudge** — around 6 months of amenorrhea, gently notes a clinician may suggest a DXA; supportive, not fear-based.
- **Gentle support surfacing** — if the ED-concern screen or self-report flags disordered eating, surface specialist routing + the National Alliance for Eating Disorders helpline + crisis resources, framed as care.
- Optional log reminders that respect an irregular cadence — **never "your period is late."**
- **Never:** any calorie/weight-loss/deficit prompt; any streak or goal that rewards under-eating or over-exercise; contraception/fertile-window "safe day" claims; disease-prevention claims; "you have FHA / an eating disorder / RED-S."

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — see `09_MASTER_ADAPTATION_MODEL.md` §3)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, **HA-aware mode ON, cause context = low-energy/exercise/stress, non-diagnostic**).
- Cycle events: bleed start/end, flow, spotting; computed gap (health-signal framing, **no "late"**).
- Generic symptom log; mood/energy/sleep.

**Persona-specific (B16 — HA / low-energy / over-exercise, ED-adjacent)**
- **Cause-context = low-energy-availability / over-exercise / stress** (self-report, non-diagnostic) + free "what I've been told" note.
- Context signals (self-report, non-diagnostic, **ED-safe**): training/activity load, **rest days**, sleep, stress level, **qualitative** fuelling regularity ("ate regularly" / "skipped meals" — *no numeric intake*), recent injuries / stress-fracture history, recent significant life stress.
- **ED-concern flag** (from screen or self-report) — drives gentle specialist + helpline surfacing; **never rendered as a diagnosis; suppressible; extra-sensitive privacy**.
- **Amenorrhea/gap counter** (days since last bleed) driving the health-signal and bone-awareness prompts — displayed neutrally, **never as "late."**
- **Bone-health context** (self-report/labs): stress-fracture history, DXA result if entered (entry only, no interpretation).
- Weight: **optional, off-by-default, non-shaming, no goal/target field, fully suppressible for ED-history users, never required.**
- User-entered labs (FSH, LH, estradiol, TSH, prolactin, hCG, DXA) — entry only, no interpretation.
- TTC intent flag = **false** (drives non-TTC UX); reachable toggle (TTC context → clinician routing, see §J).

*All health fields optional, encrypted, user-deletable; weight and any intake/fuelling detail are explicitly not required to use the app, and ED-sensitive fields are suppressible.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B16):** (from `09` §4, Q2 "irregular-or-absent" path → B5, refined by the low-energy/stress/high-training cluster)
- Q: life stage → "tracking my cycle / general." Q: cycles regular / **irregular-or-absent** / a condition I know of → **irregular-or-absent** ⇒ HA-aware mode candidate.
- Q: "Have your periods stopped or become very infrequent?" → **yes** and Q: "Any of these lately?" (multi-select, **framed neutrally and non-judgementally**: training a lot / hard, eating less or skipping meals, high stress, recent weight change, feeling run-down or getting injuries) ⇒ **low-energy/exercise/stress cluster ⇒ resolves toward B16 (HA education lane).** No cause is asserted.
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false; suppress fertile-window & pregnancy nudges.
- **Wellbeing-safe onboarding rule:** the wizard **never** asks for a calorie target, a weight goal, or a weight to proceed; the food question is **qualitative only**; tone is warm and non-alarming throughout; an ED-concern signal quietly seeds the gentle support-surfacing logic (never a pop-up label).

**Home configuration (default for B16):**
- Hero = **"your period is a signal" health-signal card** (gap + gentle "here's why checking in matters") — **no "late" counter, no prediction pressure.**
- Pinned: HA/recovery education, bone-health awareness, visit-prep, ED-safe context log.
- Cards ordered by her concern selection (e.g., bone-health surfaced if she flagged injuries; mental-health/stress surfaced if she flagged high stress).
- Fertile-window / pregnancy widgets **hidden by default**; neutral "could this be pregnancy?" helper available on demand.
- **Reward/celebration surfaces reframed** to rest and fuelling and return-of-cycle — never streaks, deficits, or activity PRs.

**Hidden-but-reachable principle:** Femio never removes knowledge. TTC guidance, pregnancy tracking, contraception education, PCOS/thyroid/perimenopause content all remain **discoverable** via search and an "Explore other life stages / causes" entry — surfaced when relevant, never forced.

**Adaptive tuning (all *offers*, never verdicts; all ED-safe):**
- Prolonged/recurring gap ⇒ raise the health-signal check-in and (around 6 months) bone-health awareness + visit-prep prominence — gently.
- ED-concern signal crosses a care threshold ⇒ **gently surface** specialist routing + the National Alliance for Eating Disorders helpline + crisis resources: "If your relationship with food or exercise feels hard right now, you don't have to handle it alone — here's kind, specialist support." Below threshold ⇒ keep it available in the support module, don't push.
- Mood/ED screens trend concerning ⇒ surface mental-health module + localized resources immediately.
- **Recovery signals** (cycle returns, more rest logged, fewer skipped meals) ⇒ celebrate supportively and, on sustained return of regular cycles, **offer** the standard cycle experience (→ B1) with history intact.

---

## J. Adaptation triggers (life-stage & recovery routing)

> **Inherits all universal events** from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive pregnancy test → D-track carrying modifiers; pregnancy loss → E6 Gentle Mode; **mood-screen high / crisis flag → surface mental-health module + localized crisis resources**; red-flag symptom → "seek care" content; disengagement → pause nudges; toggle-off → generic + preserve history; age-of-consent → re-confirm privacy). B16 also inherits the **B5 diagnostic-crossroads pattern** (it *is* one of B5's downstream lanes) and adds the HA/recovery-specific and **wellbeing-specific** transitions below. **Every transition requires explicit user confirmation, preserves data continuity, is reversible, and never locks her out of other content. Support-surfacing transitions are offered gently, never as a diagnosis.**

| Trigger | System response | Route |
|---|---|---|
| **Low-energy / over-exercise / stress cluster + absent/very-infrequent periods** (self-report: heavy training, skipped meals, high stress, run-down/injuries) | *Offer* HA-education lane (signal reframe + recovery direction + bone awareness), **all ED-safe, non-triggering**; clinician routing; FHA is a diagnosis of exclusion — never asserted | **Enter / stay B16** (from B5 or wizard) — additive layer |
| **ED-concern screen elevated OR disordered-eating self-report** | **Handle with extra care:** no label; gently surface **specialist routing + National Alliance for Eating Disorders helpline (1-866-662-1235) + crisis resources**; suppress any weight/food-count UI; reinforce "rest and fuel are health"; keep tone warm | **Gentle specialist / support routing**; stay B16, raise support prominence |
| **Mood screen high / any crisis flag** | Universal handler — surface mental-health module + **localized crisis resources** immediately (e.g., 988 Suicide & Crisis Lifeline in the US + local lines); screening framing | Stay + support routing (per `09` §6) |
| **Prolonged amenorrhea (~90+ days) / ~6 months** | Non-alarming health-signal check-in (vital-sign framing) + "could this be pregnancy?" neutral helper + (around 6 months) **bone-health awareness / DXA-with-clinician** prompt + visit-prep | Stay B16, raise screening prominence gently |
| **Recovery → cycles return** (regular cycles resume, sustained) | Celebrate supportively (rest/fuel framing, no weight talk); **offer** the standard cycle experience with full history intact | **→ B1 (general cycle tracking)** — additive, reversible; B16 layer archived-but-reachable |
| **Sets TTC intent = true ("start trying")** | **TTC-with-HA context needs a clinician:** confirm; explain gently that conceiving with an absent cycle is usually best addressed *with a clinician* (recovery of the cycle often precedes/aids conception; ovulation induction is clinician-managed); enable TTC content **with strong caveats**; **no fertile-window false precision** | **→ C-track with HA/clinician-routing flag** (C1, clinician-first) — additive TTC layer, wellbeing safeguards retained |
| **Suddenly missed period / pregnancy suspected** | Auto-offer neutral "Could this be pregnancy?" helper first; non-TTC | Stays B16 until a positive test fires the universal **positive-pregnancy-test** handler → **D-track** |
| **Co-existing androgen-sign / PCOS question** (self-report) | Clarify that HA and PCOS are different mechanisms and can be confused; *offer* PCOS education for a clinician discussion; do not assert either | **→ B6 education offer** (distinguish, don't conflate) |
| **User confirms an FHA (or ED) diagnosis from her clinician** | Retire "cause-context = self-report"; carry all history into the confirmed care lane unchanged; keep recovery + bone + support framing | → confirmed HA/recovery lane, data intact |
| **User toggles off HA-aware mode** | Revert to standard cycle logic; preserve all history | General reproductive-age band / Z1 |

The through-line: **B16 holds Dana safely while her body is under-fuelled — reframing the missing period as a signal, pointing recovery toward rest and fuel, protecting her bones and her wellbeing, and routing her kindly to a clinician (and, where needed, specialist ED support) — then, as her cycle returns, hands her whole record forward to B1.** It is never a place that pushes restriction, weight loss, or performance.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.) FHA is a **diagnosis of exclusion** made by a clinician — Femio never asserts it, RED-S, or an eating disorder.

- **WELLBEING SAFEGUARDS (eating-disorder / disordered-eating / over-exercise — the defining compliance surface of this persona):**
  - **No restriction, weight-loss, dieting, or calorie/deficit framing anywhere** — not in content, tools, logs, prompts, or notifications. No calorie fields, no macro targets, no "net calories," no intake-vs-burn math, no weight goals, no weight-trend-toward-a-target UI. Fuelling is logged **qualitatively only**.
  - **Weight fields optional, off by default, non-shaming, never required**, and **fully suppressible for users with ED history/flag.**
  - **Recovery framing is restoration and permission, never weight change** — "more fuel, more rest, less intense exercise" is presented as caring for the body, never as gaining weight or as a diet.
  - **No calorie/energy-availability numbers presented as user targets** — LEA/EA thresholds are research constructs for education only, never something the user is asked to hit or track.
  - **Reward mechanics inverted away from streaks/deficits/PRs** — the app celebrates rest and fuelling and cycle return, never activity streaks or under-eating.
  - **Tone is recovery-oriented, supportive, non-triggering, non-alarming, weight-stigma-aware** throughout; ED-clinician review sign-off required on B16 content and reward/celebration surfaces before release.
- **Amenorrhea framed gently as a health signal to address with a clinician** — never as a fitness achievement or catastrophe. The 3-month and 6-month prompts follow the reviewed global threshold policy and are educational awareness/routing, never verdicts.
- **Eating-disorder support resourcing (safety-critical):** do not hard-code or reuse legacy helpline numbers. Use the explicit country selector and eating/body-image topic route in [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md); availability varies by country and service. Immediate danger always uses the separate urgent route. *(Find A Helpline eating/body-image directory accessed 23 July 2026; reviewed Mohamed K., 23 July 2026.)*
- **ED-concern and mood check-ins:** the ED check-in is non-scored and not called a validated screen; it never outputs an eating-disorder/FHA/RED-S label. It routes gently to a clinician and country-selected support. A future validated instrument must follow the central screener policy.
- **Bone-health & hormone content:** DXA-around-6-months and transdermal-estradiol-vs-pill teaching is **educational only, clinician-decided, never a dose or recommendation**; explicitly teach that a **pill-induced bleed is not the same as cycle recovery** and can mask ongoing energy deficit.
- **Predictions:** must display uncertainty; **no "days late"/"overdue" counter in this persona** (it is both inaccurate and potentially triggering); degrade to an honest health-signal view; never present a fertile/"safe" window as reliable for contraception ("not for contraception" note wherever fertility appears).
- **Pregnancy handling:** neutral non-TTC "could this be pregnancy?" helper; **TTC-with-HA is routed clinician-first** (conception with an absent cycle is a clinician conversation); a positive test uses the universal handler; a loss instantly triggers Gentle Mode per `09` §6.
- **Mental health:** anxiety/perfectionism/body-image are core here — crisis resources on any high/low screen; localized per region/language; ED and mental-health data treated as extra-sensitive.
- **Privacy (GDPR/PDPL health data):** health data = special-category; **ED and mental-health flags are especially sensitive** — explicit granular consent, purpose limitation, no ad-SDK/third-party sharing (post-Flo trust), no employer/insurer visibility, local-first where feasible, full export/delete, and suppressible ED-sensitive fields. Data-mapping + DPIA required before launch.
- **Content integrity:** all medical content referenced, medically reviewed (byline + date) **and ED-clinician-reviewed**, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education keeps out of regulated-device territory; ED-safety review + legal review before store submission.
- **Reviewed source set:** amenorrhea, REDs/LEA, and clinician-directed DXA wording is pinned in [`docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md). SCOFF and static regional directories remain excluded. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH / NHS / MedlinePlus / OWH / gov):**
- [Absent menstrual periods — secondary | MedlinePlus (NIH)](https://medlineplus.gov/ency/article/001219.htm)
- [National Eating Disorders Awareness Week | Office on Women's Health](https://womenshealth.gov/nedaw)
- [988 Suicide & Crisis Lifeline | SAMHSA](https://www.samhsa.gov/mental-health/988)
- [988 Suicide & Crisis Lifeline (about)](https://988lifeline.org/)

**Clinical — Tier 2 (Endocrine Society / ACOG / IOC / society / peer-reviewed):**
- [Functional Hypothalamic Amenorrhea: An Endocrine Society Clinical Practice Guideline — JCEM (2017)](https://academic.oup.com/jcem/article/102/5/1413/3077281)
- [Hypothalamic Amenorrhea Guideline Resources | Endocrine Society](https://www.endocrine.org/clinical-practice-guidelines/hypothalamic-amenorrhea)
- [Endocrine Society issues clinical practice guideline on FHA — Healio summary](https://www.healio.com/news/endocrinology/20170327/endocrine-society-issues-clinical-practice-guideline-on-functional-hypothalamic-amenorrhea)
- [New guidance: Bone health front and center in FHA care — MDedge](https://medauth2.mdedge.com/content/new-guidance-bone-health-front-and-center-functional-hypothalamic-amenorrhea-care)
- [Hormones for bone health in functional hypothalamic amenorrhoea — Society for Endocrinology](https://www.endocrinology.org/endocrinologist/151-spring-24/features/hormones-for-bone-health-in-functional-hypothalamic-amenorrhoea/)
- [Bone health in FHA: what the endocrinologist needs to know — Frontiers in Endocrinology](https://www.frontiersin.org/journals/endocrinology/articles/10.3389/fendo.2022.946695/full)
- [FHA: impact on bone and neuropsychiatric outcomes — Frontiers in Endocrinology / PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9355702/)
- [FHA in adolescent athletes impairs bone accrual and increases fracture risk — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12722922/)
- [IOC consensus statement on Relative Energy Deficiency in Sport (RED-S), 2018 — PDF](https://stillmed.olympics.com/media/Documents/Athletes/Medical-Scientific/Consensus-Statements/REDs/IOC-consensus-statement-Relative-Energy-Deficiency-in-Sport-2018.pdf)
- [The Female Athlete Triad / Relative Energy Deficiency in Sports (RED-S) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10304901/)
- [Relative Energy Deficiency in Sport (RED-S) — Physiopedia](https://www.physio-pedia.com/Relative_Energy_Deficiency_in_Sport_(RED-S))
- [Female Athlete Triad and RED-S: Nutritional Management — Nutrients / PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10857508/)
- [Energy availability and menstrual/ovulatory function (racewalkers/runners <35 kcal·kg FFM) — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10690956/)
- [Contributing factors to low energy availability in female athletes — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8912784/)
- [Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign — ACOG](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)
- [Amenorrhea — MSD Manual Professional (definitions, differential, FHA)](https://www.msdmanuals.com/professional/gynecology-and-obstetrics/abnormal-uterine-bleeding/amenorrhea)
- [Is it normal to lose your period because of exercise? — Cleveland Clinic](https://health.clevelandclinic.org/is-it-normal-to-lose-your-period-because-of-exercise)
- [How exercise affects your menstrual cycle — UPMC HealthBeat](https://share.upmc.com/2023/10/how-exercise-affects-your-menstrual-cycle/)
- [FHA and dietary intervention: a systematic review (amenorrheic women without overt ED) — ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0271531725000867)

**Eating-disorder support & wellbeing (safety-critical resourcing):**
- [National Alliance for Eating Disorders — find treatment / helpline 1-866-662-1235](https://www.allianceforeatingdisorders.com/find-treatment/)
- [What is an eating disorder helpline? — National Alliance for Eating Disorders](https://www.allianceforeatingdisorders.com/what-is-an-eating-disorder-helpline/)
- [Amenorrhea & menstrual abnormalities in eating-disorder patients — National Alliance for Eating Disorders](https://www.allianceforeatingdisorders.com/amenorrhea-eating-disorders/)
- [Amenorrhea in eating-disorder patients — ACUTE](https://www.acute.org/resources/amenorrhea-absence-menstruation-eating-disorder)
- [How to get your period back in eating-disorder recovery — Equip Health](https://equip.health/articles/treatment-and-recovery/amenorrhea-and-eating-disorders)
- [NEDA phases out human helpline (2023 — why Femio must NOT use NEDA helpline) — NPR/WUNC](https://www.wunc.org/2023-05-31/national-eating-disorders-association-phases-out-human-helpline-pivots-to-chatbot)
- [Eating disorder helpline shuts down AI chatbot that gave bad advice — CBS News](https://www.cbsnews.com/news/eating-disorder-helpline-chatbot-disabled/)

**HA-recovery communities & practitioner resources (voice-of-user; non-triggering framing):**
- [Everything you need to know about exercise and HA — The HA Society](https://www.thehasociety.com/articles/everything-you-need-to-know-about-exercise-and-hypothalamic-amenorrhea)
- [What is the best diet for hypothalamic amenorrhea? — The HA Society](https://www.thehasociety.com/articles/what-is-the-best-diet-for-hypothalamic-amenorrhea)
- [Hypothalamic amenorrhea: information & recovery tips — Dietetically Speaking](https://dieteticallyspeaking.com/what-is-hypothalamic-amenorrhea-recovery-tips/)
- [How to get your period back and recover from HA — Sarah King](https://sarahlizking.com/how-to-get-your-period-back/)
- [Disordered eating and missing periods — Nutritionist Resource](https://www.nutritionist-resource.org.uk/articles/disordered-eating-and-missing-periods)
- [No Period. Now What? — HA recovery resource (Nicola Rinaldi)](https://www.noperiodnowwhat.com/)

**Competitor / app landscape:**
- [Flo — FTC action & class settlement context (see B5/B6 spec sources)](https://www.ftc.gov/news-events/news/press-releases/2021/01/developer-popular-womens-fertility-tracking-app-settles-ftc-allegations-it-misled-consumers-about)
- [Clue — variable-cycle handling](https://helloclue.com/)
- [Stardust — privacy-forward cycle app](https://stardust.app/)
- [Relative Energy Deficiency in Sport and Eating Disorders — NEDA (RED-S/ED overlap reference)](https://www.nationaleatingdisorders.org/relative-energy-deficiency-in-sport-red-s/)
