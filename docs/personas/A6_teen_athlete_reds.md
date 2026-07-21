# Persona A6 — Teen athlete with low energy availability / RED-S signs (intense sport + under-fuelling → irregular/missing periods, fatigue, injuries)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician."
> Research date: 2026-07-21 · Persona band: A (Adolescent) · Mode: **Teen mode** (no ads, minimal data, trusted-adult, extra privacy) · Inherits: `09_MASTER_ADAPTATION_MODEL.md`
> Conventions inherited from: `A2_teen_newly_menstruating.md` (teen-mode + reassurance-first + shared-device + Arabic-first patterns). Adjacent: `A5_late_absent_periods.md` (the >90-day-gap sibling A6 draws its long-gap patterns from). **Adult sibling:** `B16_hypothalamic_amenorrhea.md` (RED-S/LEA/FHA grounding and the full wellbeing-safe design system — A6 is B16's teen-athlete upstream; she ages *into* a B16-adjacent adult state).
> **WELLBEING-CRITICAL + MINOR PERSONA.** This spec touches eating disorders, disordered eating, over-exercise, and body image in a **minor athlete**. All content here is recovery-oriented, athlete-affirming, and non-triggering by design: **no calorie targets, no weight-loss framing, no restriction language, weight fields optional and non-shaming.** See §K for the full safeguard set and the National Alliance for Eating Disorders resourcing. This is the highest-sensitivity combination in Femio: a minor *and* ED/RED-S-adjacent.

---

## A. Persona snapshot

| | |
|---|---|
| **Who** | "Yara," 15. Competitive distance runner (also common: gymnastics, dance, swimming, figure skating, rowing, cross-country). Trains 6 days/week, often twice a day in season. Menarche at 12; periods came for a while, then got lighter and spaced out, and now it's been ~4 months with nothing. She feels fit and disciplined and a little proud of how "low-maintenance" her body is. Someone on her team — maybe a coach, maybe an older teammate — told her losing your period is "just what happens when you train hard." She half-believes it, half-worries. |
| **Emotional state** | Driven, self-critical, tired in a way she's normalised. Oscillates between "this is what being a serious athlete feels like" and a quiet unease about the missing period, the new injuries, and feeling flat in races she used to win. |
| **Health literacy** | Low-to-moderate on cycles; **high on training culture**, which is exactly the problem — her sport's folklore ("lighter is faster," "no period is normal for us") is louder and more trusted than any health class. |
| **Privacy needs** | Very high (minor). **May share a device** (family tablet, team iPad). Does not want a parent, sibling, coach, or teammate seeing this. No ads, no data sold. |
| **Device / context** | Web-first on her phone, in short private bursts (locker room, bus, bedroom after practice). |
| **Language** | May be Arabic-first / RTL; menstruation is culturally sensitive → shame/secrecy pressure higher, information access lower. |
| **Primary jobs-to-be-done** | (1) "Tell me the truth: is losing my period *actually* normal for athletes, or not?" (2) "Explain what's happening to me without making me feel like I did something wrong or scaring me." (3) "Help me see that fuelling and rest make me a *better* athlete — not a weaker one." (4) "Tell me if this could be hurting my bones / causing these stress fractures." (5) "Help me bring this to a doctor and a trusted adult without it being a huge scary thing." (6) "Let me track my cycle and training without a 'you're late' counter or anything about calories or weight." |
| **What success feels like** | She stops treating the missing period as a badge, understands it as her body running low on fuel, feels *athlete-affirmed* rather than shamed, and takes it — with a trusted adult — to a clinician and (where relevant) a sports dietitian. Femio added zero fuel to any restriction or over-training. |
| **Anti-goals (things that break trust)** | Being told to "just eat more" like it's simple; any calorie/weight/deficit framing; a "days late" counter; being surveilled by a parent or coach by default; pink-flowers infantilising UI; being scared with catastrophe language; being told she has RED-S / an eating disorder; fertility/TTC framing aimed at a 15-year-old; being blocked from reading something out of curiosity. |

**Design tension to hold (three-way):** she needs **protection** (teen mode, minimal data, trusted-adult pathways, safeguarding) **and** **non-restriction** (full library reachable) **and** **wellbeing safety** (ED-safe, athlete-affirming, no restriction/weight framing). A6 = A2's teen-mode architecture ⊕ B16's wellbeing-safe RED-S design, tuned for a minor athlete inside a sport culture that actively normalises the harm.

---

## B. Needs & questions (voice-of-user)

Mined from RED-S / female-athlete-triad recovery material, teen-athlete and parent/coach guidance (HealthyChildren.org/AAP, AboutKidsHealth, Boston Children's, CHOP, Center for Young Women's Health), athlete-recovery blogs, and adolescent-athlete amenorrhea literature (see Sources). Paraphrased to avoid quoting individuals, and deliberately filtered to exclude any restriction/numbers talk.

**On the defining myth (sport culture vs. her body):**
- "My coach/teammates say losing your period is normal when you train this hard. Is that true?"
- "Everyone on my team is the same — none of us really get regular periods. So it's fine, right?"
- "It's honestly kind of convenient not to deal with a period during meets. Is that bad?"
- "One website says athletic amenorrhea is harmless, the next says it's dangerous. Which is it for *me*?"

**On what's happening (wants truth, not alarm):**
- "Why did my period stop? I didn't do anything different except train more."
- "Can training really switch off my period? I thought that only happened if you were sick."
- "I feel fine most of the time. If nothing hurts, is it actually a problem?"

**On performance and injuries (the athlete-positive hook):**
- "I keep getting little injuries — I've had a stress fracture. Is that connected to my period?"
- "I've been slower and more tired lately even though I train harder. What's going on?"
- "Does eating more actually make you faster, or just heavier?" *(the reframe opportunity)*

**On the recovery message (and her fear of it):**
- "Everyone says 'eat more, train less.' I don't want to gain weight or lose my fitness."
- "Do I really have to stop my sport? It's my whole life."
- "If I fix my eating, will my period come back? How long does that take?"

**On the body / eating (approached with great care):**
- "I don't have an eating disorder, I'm just careful because it's my sport."
- "Admitting I under-eat feels like admitting I'm not disciplined enough."

**On bones (the under-appreciated stake):**
- "Can not having a period hurt my bones? I'm 15 and fit."
- "Why do I keep getting stress fractures when I'm so healthy?"

**On tracking + privacy (minor + athlete):**
- "Every app yells 'YOU'RE 120 DAYS LATE.' It makes me feel broken."
- "I don't want to log my weight. I just want to understand my body."
- "How do I keep this private so my mum / my coach / my teammates don't see it?"

**Top recurring questions Femio must answer in-product (all non-triggering, minor-safe, clinician-routed):**
1. Is losing my period actually normal for athletes, or is that a myth?
2. Why do periods stop when you train hard and don't eat enough?
3. Does fuelling actually make me a *better* athlete? (yes — the core reframe)
4. Could this be causing my stress fractures / hurting my bones during the years they're still forming?
5. What does getting better usually look like — and why is it *rest and fuel*, not restriction?
6. How do I take this to a doctor and a trusted adult without it becoming a huge scary thing?

> **Key research insight:** awareness of RED-S among athletes, coaches, and trainers is low, and a large share of young athletes say they **would not seek help** for unexplained amenorrhea — often because their culture has told them it's normal. Reassurance-plus-truth ("this is common in your sport, *and* it's a signal worth acting on") is the core clinical-adjacent value for A6. (PMC 8609260; §D sources.)

---

## C. Competitor teardown

The A6 white space sits in a double gap: **sports/performance apps track training but ignore the cycle-as-health-signal (and reward *more* training); cycle apps track periods but ignore the athlete (and invent a "late" counter or push fertility).** For an under-fuelled *minor* athlete, both categories are wrong in the same direction — and none is built teen-safe *and* wellbeing-safe.

| App | Category | Athlete/teen fit | RED-S / under-fuelling handling | "Late" / prediction behaviour | ED / wellbeing safety | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Cycle, freemium | Min age 13 (16 EU); adult/fertility-first | No RED-S mode; treats a long gap as a prediction miss or pregnancy question | Confident dates + a **"days late" counter** — the exact badge that makes an athlete feel broken and can feed compensatory training/restriction | Broad symptom logging, **no LEA/ED-safe framing**; weight/food logging can cut the wrong way | RED-S-aware, **no "late" counter**, athlete-affirming + ED-safe, teen mode by default |
| **Clue** | Cycle, freemium, science-forward | Popular with teens; non-infantilising | Adapts to variable length; no RED-S/athlete lane | More conservative but still predicts a period that isn't coming; can imply "late" | Neutral taxonomy, no ED guardrails | Not teen-*designed*, no trusted-adult layer; Femio adds RED-S skin + bone-health + gentle specialist routing |
| **FitrWoman** | Athlete cycle app | Rated "Everyone," athlete-oriented, free | **Phase-based performance/nutrition tips** — assumes a *functioning* cycle to sync to; nothing for the athlete whose cycle has *stopped* from under-fuelling | Predicts phases; not built for amenorrhea | Performance-optimisation framing; **no ED-safe guardrails, no minor safeguarding** | Femio serves the athlete whose cycle is *absent* — the one FitrWoman's phase model can't help — and does it teen-safe + ED-safe |
| **Wild.AI** | Athlete hormones/fitness | Adult female athletes | Adjusts workout intensity/recovery to cycle phase/life-stage | Cycle-phase based | **Performance/training-load framing; not minor-appropriate, no ED-safety** | Femio reframes rest+fuel as *health*, not just performance; teen-safe, ED-safe, non-TTC |
| **Strava / Garmin / training-load apps** | Performance/activity | Ubiquitous with teen athletes | Reward *more* training, streaks, PRs; nothing on energy availability or when to rest for health | N/A | **Streak/PR mechanics can reinforce over-exercise** — directly counter-therapeutic here | Femio inverts the reward system: rest days and fuelling are celebrated, not streaks |
| **MyFitnessPal / calorie trackers** | Calorie/deficit | Common among appearance/endurance-sport teens | *Actively counter-therapeutic* — intake-vs-burn deficit is the exact frame RED-S recovery must undo | N/A | **High risk**: calorie counting widely cited as a disordered-eating trigger, especially in minors | Femio is explicitly **not** a calorie/deficit product; fuel/rest are *support*, never math to minimise |
| **Generic period-tracker apps** | Cycle, ad-driven | Default teen download | None | Exact-date predictions + "late" status that mislead irregular teens | Ads, data-brokering (bad for minors), no red-flag literacy | Privacy-by-default teen mode + uncertainty-honest + ED-safe + RED-S-aware |

**Cross-cutting failure — the exact A6 gap.** Sports apps say *train more and here's your phase*; cycle apps say *you're late, are you pregnant?*; calorie/fitness apps say *widen the deficit and keep your streak*. For an under-fuelled minor athlete whose period has stopped, every one of these either invents a broken-making "late" status, pushes a fertility narrative irrelevant to a 15-year-old, or actively reinforces the over-training/under-fuelling that caused the amenorrhea — inside a sport culture already telling her it's normal. **None** frames the missing period as a **health signal that recovery — more fuel, more rest, smarter training — usually reverses**, none protects a minor's privacy by default, and none is ED-safe. Femio's answer: **a teen-mode, RED-S-aware, no-"late"-counter, athlete-affirming, ED-safe experience that treats the absent period as information to act on *with a clinician and a trusted adult*, protects the bone-health window that's open only in adolescence, celebrates fuelling and rest as performance, and routes gently to a sports clinician / dietitian and the National Alliance for Eating Disorders where disordered eating is in the picture.**

**White space Femio can own for A6:**
1. **The only app for the athlete whose cycle has *stopped*** — not phase-syncing a working cycle, but treating an absent one as a signal.
2. **Teen-safe + wellbeing-safe together** — privacy-by-default minor mode ⊕ ED-safe design ⊕ athlete-affirming tone.
3. **Fuelling-as-performance reframe** — meets sport culture on its own terms (be better) instead of fighting it (be careful).
4. **Bone-health-window education** — the adolescence-specific stake competitors never mention.
5. **Arabic-first / RTL athlete-health education** — a near-empty niche.

---

## D. Clinical grounding (cited)

> Framing: everything below is surfaced in-product as **wellness education + screening + "discuss with your clinician (and a trusted adult)."** Femio never tells Yara she has RED-S, the female athlete triad, FHA, or an eating disorder; never gives a calorie target; never frames anything as weight loss. Diagnosis is a clinician's job; FHA is a diagnosis of exclusion.

**Losing your period is NOT normal for athletes — the core myth-correction.** Most teens who play sports have regular periods; an occasional skipped period can happen, but **regularly missing periods is not normal and is a sign the body isn't getting enough energy**, not a marker of fitness. When energy is too low, the body conserves it by switching off the reproductive hormones that drive the cycle [Center for Young Women's Health; Girlology; AboutKidsHealth]. Awareness of this is low among athletes *and* coaches/trainers, and a large share of young athletes say they would not seek help for unexplained amenorrhea [PMC 8609260].

**Low energy availability (LEA) is the driver.** Exercise alone doesn't stop periods — it's the **combination of high training load and not eating enough**, so too little energy is left for functions including reproduction, and the body pauses the cycle to conserve resources [Cleveland Clinic; UPMC; §B16]. In sports-science terms this is **low energy availability**; menstrual disturbance is linked to energy availability below research thresholds, with higher intake needed to support bone. **Femio presents this concept qualitatively only — "your body needs enough fuel for the training you do" — and never as a number to hit or track**, to avoid any restriction framing [IOC RED-S consensus 2018/2023]. `[NEEDS SOURCE]` confirm exact EA thresholds/wording before user-facing copy; thresholds are research constructs, **never personal targets**, and especially never shown to a minor.

**Female Athlete Triad → RED-S (the athlete context).** The **Female Athlete Triad** is the interrelationship of **low energy availability (with or without disordered eating), menstrual dysfunction, and low bone mineral density**; the IOC broadened this in 2014 to **Relative Energy Deficiency in Sport (RED-S)**, covering impaired bone, metabolic, menstrual, immune, cardiovascular, and performance function stemming from LEA [AAP *Pediatrics* 2016 "The Female Athlete Triad"; IOC RED-S 2014/2018/2023; PMC 10304901]. In this frame, **amenorrhea is a red flag for RED-S/triad — not a sign of successful training**.

**Warning signs (for her, and for trusted adults).** Feeling tired/weak, irregular or missing periods, **frequent or recurring injuries including stress fractures**, declining performance, trouble concentrating, irritability/low mood or anxiety, getting sick often, and — sometimes — significant weight loss [HealthyChildren.org/AAP; Boston Children's; eatright.org]. **Declining performance and recurring injury are the athlete-facing hooks** that often land better than the period itself.

**Bone health — the adolescence-specific, time-limited stake.** Low estrogen from an absent cycle lowers bone mineral density and raises stress/fragility-fracture risk — and in adolescence it **impairs peak bone-mass accrual during the exact window when most bone is built.** More than **~90% of peak bone mass is achieved by age ~18**, so deficits sustained in the teen years may be **partly permanent** — with recovery and return of menses some catch-up is possible, but not always full, which is why **early intervention in adolescent athletes matters most** [AAP 2016; Frontiers in Endocrinology 2025 — FHA in adolescent athletes impairs bone accrual and increases fracture risk; CHOP]. BMD can decline as missed cycles accumulate. A clinician may suggest a **DXA** with prolonged amenorrhea, plus adequate **protein, calcium, and vitamin D**. **Femio frames this supportively, never as fear.**

**Recovery — the core, safety-critical message (ED-safe).** The guideline-endorsed direction is **correcting the energy imbalance to restore cycle function**: **more fuel, more rest, and reduced/adjusted training load**, plus **psychological support** where appropriate — i.e., a **multidisciplinary team** (sports/adolescent clinician + sports dietitian + mental-health), ideally RED-S/ED-experienced [AAP 2016; Endocrine Society FHA Guideline 2017; eatright.org]. **Femio delivers this as restoring the body and permission to fuel and rest — never as a diet, a calorie number, or weight change** — and, crucially for this persona, **reframed as improving performance and durability**, which meets sport culture where it is. Return of periods can take **months**; catch-up bone accrual may be partial.

**The disordered-eating overlap (wellbeing-critical, higher stakes in a minor).** LEA may be **inadvertent** (under-fuelling without an eating disorder — very common when growth + training demands are underestimated) *or* driven by **disordered eating / a diagnosable eating disorder**; the two sit on a spectrum and often can't be told apart from the outside. Certain sports (endurance, aesthetic/lean-emphasis — running, gymnastics, dance, figure skating) carry elevated risk. Amenorrhea is a recognised sign of eating disorders [AAP eating-disorders clinical report; National Alliance for Eating Disorders; ACUTE]. Femio treats every A6 user with **ED-safe design by default** and routes gently to specialist support (see §K), never labelling her.

**Menstrual cycle as a vital sign (legitimises the whole persona).** ACOG/AAP endorse treating the adolescent cycle as a vital sign — which makes gentle tracking + "know your normal" + raising an absent period with a clinician a **clinically supported behaviour**, exactly Femio's A6 value [ACOG vital-sign committee opinion; AAP].

*`[NEEDS SOURCE]` register: exact ACOG/AAP amenorrhea-evaluation wording (3 vs 6 months) in the adolescent-athlete context; exact LEA/EA thresholds and RED-S 2023 wording (**never as user targets, never shown to a minor**); DXA-timing wording; peak-bone-mass "~90% by 18" exact phrasing; SCOFF/locale-appropriate ED-screener licensing; per-locale (esp. Arabic/MENA) ED + crisis directories — all before any user-facing copy.*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona (and to be safe).**
1. **Teen mode by default (age 12–15)** — no ads, minimal data, **no community DMs**, trusted-adult involvement **opt-in and transparent**, GDPR age-of-consent handling, shared-device discreteness (per-profile privacy, quick-hide, neutral naming, no lock-screen leakage). *(A2 inheritance.)*
2. **RED-S-aware cycle mode (non-triggering variant)** — set at onboarding; disables 28-day assumptions, **never shows a "late"/"days overdue" counter**, models the gap as a **health signal**, and never requires a weight or calorie number to function. *(B16 inheritance.)*
3. **"Losing your period isn't normal for athletes" myth-correction core** — the calm, central reframe that meets sport culture head-on: it's a common thing in her sport *and* a signal worth acting on — neither a badge to keep nor a catastrophe.
4. **Fuelling-as-performance education (ED-safe, athlete-affirming)** — "fuel and rest make you a stronger, more durable athlete," recovery framed as **restoring your body and unlocking performance**, explicitly **never** weight loss, dieting, or calorie counting. This is the wedge that gets a driven athlete to listen.
5. **Bone-health-window awareness module** — why the teen years are the once-only window for building bone, how an absent period quietly costs it, the stress-fracture connection, and the protein/calcium/vitamin-D + possible-DXA framing — supportive, not fear-based.
6. **Gentle specialist + trusted-adult + support routing** — offers clinician (sports/adolescent medicine) + sports-dietitian evaluation, **always paired with encouragement to loop in a trusted adult**; where an ED-concern screen/self-report suggests disordered eating, gently surfaces specialist routing **and the National Alliance for Eating Disorders helpline (1-866-662-1235)** + crisis resources — as care, never a verdict.
7. **Uncertainty-honest / no-"late" prediction** — for irregular or absent cycles, a health-signal view (never a confident date, never a "late" counter, **never a fertile/"safe" window** — not contraception, §K).
8. **ED-safe design guardrails everywhere** — no calorie/deficit fields, no weight-loss copy, weight optional/off-by-default/non-shaming/suppressible, **no streaks/PRs/goals that reward under-eating or over-training.**
9. **Full-library reachability** — teen mode governs data/ads/social, **not reading**; every topic reachable via search (personalize-never-restrict).
10. **Privacy-by-design** — special-category health + ED/mental-health data; no ad-SDK sharing; especially strict for a minor.
11. **Arabic-first / RTL** + EN/FR/ES; culturally sensitive tone.

**P1 — strong differentiators.**
12. Referenced, medically-reviewed RED-S / triad / bone-health / fuelling content library (Arabic-first + EN/FR/ES), recovery-oriented, athlete-affirming, non-triggering.
13. **ED-safe context tracking:** cycle gap + rest days, training/movement (as activity **and rest** — **never calories burned**), sleep, stress/school-load, mood, **injuries / stress-fracture history**, fuelling logged **qualitatively** ("ate regularly," "skipped meals around training") — **never** calorie counts, macros, or weight-as-goal.
14. **Performance-and-injury insight (athlete-affirming):** descriptive, supportive correlations ("your longer gaps and injuries show up alongside high-training, low-rest, skipped-meal logs") framed as *a pattern to discuss with a clinician* — never "caused by," never a nudge to restrict.
15. Mental-health / body-image support module (screening + coping), stigma- and ED-aware, minor-appropriate.
16. **Cycle-and-context "story" view** she can (by her choice) show a trusted adult, doctor, or dietitian.
17. Gentle "narrow it down with your clinician" routing that *offers* related lanes when signals cluster.

**P2 — depth / retention.**
18. **Recovery-progress framing that celebrates rest and fuelling** ("rest days logged," "meals not skipped," "return-of-cycle watch") — reward system deliberately inverted away from streaks/PRs/deficits. ED-clinician reviewed.
19. Coach/parent-facing **shareable education** (opt-in, by her choice) — a neutral "what RED-S is / why fuelling is performance" explainer she can hand a trusted adult, helping shift team culture. Never covert monitoring.
20. User-entered lab/result tracker (DXA, FSH, LH, estradiol, TSH, prolactin, hCG) — entry only, no interpretation.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages, teen-safe + ED-safe + athlete-affirming)

Sequenced reassurance/truth → mechanism → athlete reframe → stakes → routing → boundaries.

1. **"Is losing your period normal for athletes?" (start here)** — the honest answer: it's *common* in hard-training sport, but it isn't *normal or safe* — it's your body telling you it's low on fuel. Calm, non-shaming, meets the myth head-on. *(Reassurance-plus-truth.)*
2. **Why periods stop when you train hard and don't eat enough** — LEA + training + stress, explained qualitatively ("not enough energy left over, so your body pauses the cycle"). **No calories, no weight, no restriction language.**
3. **Fuelling is training too** — the reframe: eating enough and resting make you *faster, stronger, and less injured*, not weaker or "heavier." Athlete-affirming; counters "lighter is faster" folklore with performance, not fear.
4. **Your period is a signal, not a scoreboard** — a missing period is information worth acting on with a clinician and a trusted adult; neither a fitness trophy nor a reason to panic.
5. **Your bones have a deadline** — why adolescence is the once-only window for building most of your lifetime bone, how an absent period quietly costs it, the stress-fracture connection, and why a doctor may suggest a DXA and the protein/calcium/vitamin-D picture. Supportive, motivating, not scary.
6. **Stress fractures and injuries — the hidden connection** — for the athlete who's noticed recurring injuries: how under-fuelling and low estrogen weaken bone and slow recovery. Uses the injury she already cares about as the door in.
7. **RED-S and the female athlete triad in one page** — LEA + menstrual changes + bone + performance as connected signals; amenorrhea as a flag to check, not a trophy.
8. **What getting better usually looks like** — more fuel, more rest, smarter (not zero) training, and support — framed as **restoring your body and unlocking performance**, never a diet or weight change. Honest that it can take months and that periods usually return.
9. **When it's more than "being careful about food" — and where to get kind help** — gently names the disordered-eating spectrum, normalises asking for help, routes to specialists and the **National Alliance for Eating Disorders** helpline. Zero judgement, zero numbers, minor-appropriate.
10. **Talking to a coach, a parent, or a doctor** — how to raise this with a trusted adult and what a clinic visit / sports-dietitian visit looks like (history, exam, labs); who's on the team (clinician + dietitian + mental-health); how to advocate. Includes the opt-in shareable explainer.
11. **Tracking that helps your clinician (safely)** — what to log (gap, rest, training, sleep, stress, mood, injuries, *qualitative* fuelling) and, deliberately, **what not to obsess over** (no calorie/weight fixation).
12. **Myths vs. evidence** — "no period is normal for athletes," "lighter is faster," "no period is convenient/harmless," "you can be too fit to have weak bones," "eating more just makes you slower/heavier," "an app can tell you what's wrong."
13. **Your body, your privacy** — what Femio does/doesn't do with her data, keeping it private on a shared device, and what a trusted adult / coach would and wouldn't see. *(A2 inheritance, teen-critical.)*

Every module: referenced citations, medical-review byline + date, **ED-clinician review sign-off**, "discuss with your clinician and a trusted adult" footer, and — where relevant — an inline support-resource line.

---

## G. Tools, logs & alerts (compliant + teen-safe + ED-safe framing)

**Logs (minimal, discreet, ED-safe, self-knowledge framing)**
- Cycle/bleed log (flow, spotting; **gap shown as a neutral "days since last period" *health-signal* view, never "late"/"overdue"**).
- Context log: rest days, training/activity (as activity **and rest** — **no calories-burned**), sleep, stress/school-load, mood, **injuries / stress-fracture history**, fuelling **qualitatively** ("ate regularly," "skipped meals around training" — **no calorie counts, macros, or portion targets**).
- Weight: **optional, off by default, non-shaming, never required**, fully suppressible (default-suppressed for any ED-flag user); **no weight-goal / weight-trend-to-target UI**. *(Extra strict for a minor.)*
- Optional lab/result entry (DXA, FSH, LH, estradiol, TSH, prolactin, hCG) — entry only, no interpretation.
- **Data minimization:** only what she chooses; no location; no default cloud-of-brokers.

**Tools**
- **Health-signal cycle view** — shows the gap + context as information to bring to a clinician / trusted adult; **no "late" counter, no prediction pressure, no fertile/"safe" window.**
- **Performance-and-context insight** — supportive, descriptive correlations ("longer gaps + injuries appear alongside high-training, low-rest, skipped-meal logs"), framed as *a pattern to discuss*, never "caused by," never a restriction nudge.
- **Recovery-support view** — celebrates rest and fuelling and a return-of-cycle watch; **reward system deliberately inverted away from streaks/PRs/deficits.** ED-clinician reviewed.
- **Visit-prep / talk-to-an-adult generator** — one-tap export: cycle gap + context trends + questions + "which team" pointer (sports/adolescent clinician + dietitian + mental-health) + the opt-in "what RED-S is" explainer for a trusted adult.
- **Screeners (framed as screening, not diagnosis — ED-safe, minor-appropriate):**
  - Mood/anxiety screen (PHQ-2 / GAD-2 style) → "This is a screening tool, not a diagnosis — consider discussing with a clinician and a trusted adult." + crisis resources.
  - **Disordered-eating concern screen (SCOFF-style), handled with extra care in a minor** → never returns a label or "you have an eating disorder"; returns "These are things worth discussing with a clinician who supports eating and body concerns," and surfaces the **National Alliance for Eating Disorders helpline (1-866-662-1235)** + crisis resources, gently. `[NEEDS SOURCE]` confirm SCOFF licensing/wording + locale-appropriate + minor-appropriate ED screeners before use.
  - RED-S / LEA-awareness checklist (LEAF-questionnaire-informed, adapted, non-triggering) → surfaces "signs worth discussing," always clinician + trusted-adult routed, *offers* the RED-S education lane rather than asserting anything.

**Alerts (private, gentle, non-alarming, screening-framed, dismissible, localized/RTL, teen-safe + ED-safe)**
- **Health-signal check-in** at a prolonged gap (~3 months): "It's been about 3 months since your last logged period — many doctors suggest checking in around now, and here's why," vital-sign framing. Warm, not scary; offers visit-prep + a neutral "could this be pregnancy?" helper. *(For a minor, worded plainly and non-judgementally.)*
- **Bone-health awareness nudge** around ~6 months of amenorrhea — gently notes a doctor may suggest a DXA; supportive, motivating, not fear-based.
- **Injury/stress-fracture prompt** — if she logs a stress fracture or recurring injuries, gently connect it to the fuelling/period signal and *offer* the education + visit-prep.
- **Gentle support surfacing** — if the ED-concern screen/self-report flags disordered eating, surface specialist routing + National Alliance helpline + crisis resources, as care.
- Neutral notification text (no health detail on lock screen); optional log reminders that respect an irregular/absent cadence — **never "your period is late."**
- **Never:** ads; any calorie/weight-loss/deficit prompt; any streak/PR/goal rewarding under-eating or over-training; fertility/TTC upsell; "safe day"/contraception framing; disease-prevention claims; "you have RED-S / the triad / an eating disorder."

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all personas — see `09` §3)**
- Account: pseudonymous ID, age/DOB (drives teen-mode gating), language/locale, RTL flag, consent records (incl. age-of-consent + guardian linkage state).
- Cycle log: period start/end, flow, spotting; computed gap (health-signal framing, **no "late"**).
- Symptom log: mood, energy, sleep, notes (all optional).
- Privacy/state: teen-mode flag, ads-off flag, trusted-adult link (opt-in) + scope, data-minimization settings.

**Persona-specific (A6 — teen athlete / low energy availability / RED-S-adjacent)**
- **Gynecologic age** (months/years since menarche) — key adolescent variable.
- **Athlete context** (self-report, non-diagnostic): sport/discipline, training load/frequency, in-season/off-season, **rest days**.
- **Cause-context = high-training / under-fuelling / stress** (self-report, non-diagnostic) + free "what I've been told (e.g., by a coach)" note.
- Context signals (self-report, non-diagnostic, **ED-safe**): sleep, stress/school-load, **qualitative** fuelling regularity (**no numeric intake**), **injuries / stress-fracture history**, recent significant life/training-load change.
- **Amenorrhea / gap counter** (days since last bleed) — displayed neutrally, **never "late"**; drives the health-signal + bone-awareness + injury prompts.
- **Bone-health context** (self-report/labs): stress-fracture history, DXA result if entered (entry only, no interpretation).
- **ED-concern flag** (from screen/self-report) — drives gentle specialist + helpline surfacing; **never rendered as a diagnosis; default-suppressible; extra-sensitive privacy (minor + ED = highest tier).**
- **Adjacent-flag markers** (non-diagnostic booleans, education/adaptation only): long-gap-pattern (→A5), RED-S-cluster, disordered-eating-concern, bone-health-watch.
- Weight: **optional, off-by-default, non-shaming, no goal/target field, default-suppressed for ED-flag users, never required.**
- User-entered labs (FSH, LH, estradiol, TSH, prolactin, hCG, DXA) — entry only, no interpretation.
- **Trusted-adult involvement** status + exactly what is shared (opt-in, transparent).
- TTC/ovulation intent = **false** (and not a concept surfaced to a minor); explicitly **NOT** stored: fertility/ovulation intent, contraception-as-contraception fields, sexual-activity data by default (content reachable, not defaulted logging).

*All health fields optional, encrypted, user-deletable; weight and any fuelling detail are explicitly not required to use the app; ED-sensitive fields suppressible; minor + ED data treated at the highest privacy tier.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Wizard resolves A6 when:** age 12–15 (teen mode ON) **and** an adolescent-cycle path (recent menarche / irregular-or-absent) **and** a self-reported **high-training + under-fuelling/stress cluster** with absent/very-infrequent periods.
- From `09` §4: Q1 life stage → "recently started periods / adolescent"; the cycle-regularity refinement → **irregular-or-absent**; then the athlete/energy refinement: *"Do you train intensely or play a competitive sport?"* → **yes**, plus *"Have your periods stopped or become very infrequent?"* → **yes**, plus a neutral multi-select (*training a lot / hard, eating less or skipping meals around training, high stress, recent injuries or a stress fracture, feeling run-down or slower than usual*) ⇒ **resolves toward A6 (RED-S education lane)**. No cause is asserted.
- **Wellbeing-safe + minor-safe onboarding rule:** the wizard **never** asks a minor for a calorie target, a weight goal, or a weight to proceed; the food question is **qualitative only**; tone is warm, athlete-affirming, non-alarming; an ED-concern signal quietly seeds the gentle support-surfacing logic (never a pop-up label). Trusted-adult involvement is *offered*, never defaulted-on.

**Home is configured to lead with:**
1. **Myth-correction + health-signal hero** ("Is losing your period normal for athletes?" + gap shown as a signal, **no "late" counter, no prediction pressure**).
2. **Fuelling-as-performance** card (the athlete-affirming reframe).
3. Bone-health-window + injury-connection card (surfaced higher if she flagged injuries/stress fractures).
4. Visit-prep / talk-to-a-trusted-adult tool + ED-safe context log.
5. Privacy quick-controls (hide, what's shared).

**Defaults set by the wizard:**
- Teen mode ON (ads OFF, minimal data, no community DMs, trusted-adult opt-in).
- RED-S-aware cycle mode ON; predictions degrade to health-signal view; **no "late" counter.**
- Fertile-window / pregnancy widgets hidden by default; neutral "could this be pregnancy?" helper on demand.
- **Reward/celebration surfaces reframed** to rest + fuelling + return-of-cycle — never streaks, PRs, or deficits.
- Notifications = neutral text; tone = plain, grown-up, athlete-affirming, non-infantilising; imagery neutral (not pink-flowers-only).
- Locale = Arabic-first/RTL if selected.

**Hidden-but-reachable (personalize, never restrict):** TTC / pregnancy / contraception / condition-grade content (PCOS, endo, adult HA/B16) is **not on her home** but **fully reachable via search/library**. Teen mode governs data/ads/social, **not reading**. Adult-community/DMs are the *only* things genuinely gated (safeguarding), reason stated plainly. "Skip / not sure" → Z1 generic, then progressive nudge toward A6 as she logs.

**Adaptive tuning (all *offers*, never verdicts; all ED-safe + minor-safe):**
- Prolonged/recurring gap ⇒ raise the health-signal check-in and (around 6 months) bone-health awareness + visit-prep prominence — gently.
- Logged injury / stress fracture ⇒ surface the injury-connection education + visit-prep — supportively.
- ED-concern signal crosses a care threshold ⇒ **gently surface** specialist routing + National Alliance helpline + crisis resources + encouragement to tell a trusted adult. Below threshold ⇒ keep available in the support module, don't push.
- Mood/ED screens trend concerning ⇒ surface mental-health module + localized resources immediately.
- **Recovery signals** (cycle returns, more rest logged, fewer skipped meals) ⇒ celebrate supportively (rest/fuel/performance framing, no weight talk); on sustained return of regular cycles, **offer** the standard cycle experience (→ B1/A-graduation) with history intact.

---

## J. Adaptation triggers (life-stage & recovery routing)

> **Inherits all universal events** from `09` §6 (positive pregnancy test → D-track carrying modifiers; pregnancy loss → E6 Gentle Mode; **mood-screen high / crisis flag → surface mental-health module + localized crisis resources**; red-flag symptom → "seek care" content; disengagement → pause nudges; toggle-off → generic + preserve history; **age-of-consent milestone → re-confirm privacy tier, relax minor gating, knowledge access unchanged**). A6 also inherits the **A2 teen-transition patterns**, the **A5 long-gap patterns**, and the **B16 wellbeing/recovery patterns**, adding the athlete-specific and minor-specific transitions below. **Every transition is gentle, transparent, reversible, requires explicit confirmation, preserves data continuity, and never locks her out of content or phrases anything as a diagnosis. Support-surfacing is offered kindly, never as a verdict.**

| Trigger | System response | Route |
|---|---|---|
| **High-training / under-fuelling / stress cluster + absent/very-infrequent periods** (self-report: heavy training, skipped meals around training, high stress, recent injuries) | *Offer* RED-S education lane (myth-correction + signal reframe + fuelling-as-performance + bone-window + injury connection), **all teen-safe + ED-safe, non-triggering**; clinician + trusted-adult + dietitian routing; nothing asserted | **Enter / stay A6** (from A2, A5, or wizard) — additive layer |
| **ED-concern screen elevated OR disordered-eating self-report** (extra stakes: minor) | **Handle with highest care:** no label; gently surface **specialist routing + National Alliance for Eating Disorders helpline (1-866-662-1235) + crisis resources**; encourage looping in a trusted adult; default-suppress any weight/food-count UI; reinforce "fuel and rest are health"; warm tone | **Gentle specialist / support routing**; stay A6, raise support prominence |
| **Mood screen high / any crisis flag** | Universal handler — surface mental-health module + **localized crisis resources** immediately (e.g., 988 Suicide & Crisis Lifeline US + local lines); screening framing; trusted-adult encouragement | Stay + support routing (per `09` §6) |
| **Logged stress fracture / recurring injuries** | Gently connect to the fuelling/period signal; *offer* the bone-health + injury-connection education + visit-prep | Stay A6, raise bone/injury prominence |
| **Prolonged amenorrhea (~90+ days) / ~6 months** | Non-alarming health-signal check-in (vital-sign framing) + neutral "could this be pregnancy?" helper + (around 6 months) **bone-health awareness / DXA-with-clinician** prompt + visit-prep | Stay A6, raise screening prominence gently; overlaps **A5** (offer A5 late/absent-period education) |
| **Persistent long gap without the athlete/energy cluster** | Surface general amenorrhea *screening* education | **→ A5 offer** (late/absent periods) |
| **Recovery → cycles return** (regular cycles resume, sustained) | Celebrate supportively (rest/fuel/performance framing, no weight talk); **offer** the standard adolescent cycle experience with full history intact | **→ A2/B1** (general cycle tracking) — additive, reversible; A6 layer archived-but-reachable |
| **Turning 16 / age-of-consent** | Relax strict minor teen-mode gating per **GDPR age-of-consent** (re-confirm consent/privacy); knowledge access unchanged; RED-S/wellbeing safeguards **retained** | Stay A6 (older-teen) or → B1, safeguards intact |
| **Ages into adult athlete still under-fuelled / amenorrheic** | Carry the whole record forward; the RED-S/LEA framing, bone-health, and ED-safe design become the **adult HA lane** | **→ B16-adjacent** (adult FHA / RED-S), data + wellbeing safeguards intact |
| **Co-existing androgen-sign / PCOS question** (self-report) | Clarify RED-S/under-fuelling and PCOS are different mechanisms and easily confused; *offer* PCOS education for a clinician discussion; assert neither | **→ A4 education offer** (distinguish, don't conflate) |
| **Content signals exploring sexual activity / contraception** | Keep content reachable + age-appropriate; **do not** convert to a contraception persona; surface trusted-adult/clinician education (Femio is never contraception — §K) | Stay A6, content reachable |
| **User confirms a RED-S / triad / ED diagnosis from her clinician** | Retire "cause-context = self-report"; carry all history into the confirmed care lane unchanged; keep recovery + bone + support framing | → confirmed care lane, data intact |
| **User toggles off RED-S-aware mode** | Revert to standard adolescent cycle logic; preserve all history | General adolescent band / Z1 |

The through-line: **A6 holds Yara safely while a sport culture tells her the missing period is a badge — correcting the myth with the truth *and* an athlete-affirming reframe (fuel and rest make you better), protecting the once-only adolescent bone-building window, connecting her injuries to the real cause, and routing her kindly to a clinician, a sports dietitian, and a trusted adult — then, as her cycle returns, hands her whole record forward to A2/B1, or, if under-fuelling persists into adulthood, into the B16 adult-HA lane. It is never a place that pushes restriction, weight loss, or more training.**

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. Femio never asserts RED-S, the female athlete triad, FHA, or an eating disorder — all are clinician determinations; FHA is a diagnosis of exclusion. All screeners output **"screening — discuss with a clinician (and a trusted adult)."**

- **MINOR SAFEGUARDS (highest privacy tier — this is a minor):** teen mode by default (age 12–15) — **no ads, minimal data, no community DMs, trusted-adult opt-in and transparent, GDPR age-of-consent** handling, guardian consent/linkage where a jurisdiction requires it. Privacy-by-design; data minimization; no location; no selling/brokering (the anti-pattern behind Flo/Meta FTC actions). Shared-device safety: per-profile isolation, quick-hide, no sensitive lock-screen/notification content. **Safeguarding, never surveillance:** trusted-adult (and any coach-facing) involvement is **opt-in and transparent**, never covert monitoring of the teen.

- **WELLBEING SAFEGUARDS (eating-disorder / disordered-eating / over-exercise — compounded by minor status):**
  - **No restriction, weight-loss, dieting, or calorie/deficit framing anywhere** — not in content, tools, logs, prompts, or notifications. No calorie fields, macros, "net calories," intake-vs-burn math, weight goals, or weight-trend-to-target UI. Fuelling logged **qualitatively only**.
  - **Weight fields optional, off by default, non-shaming, never required**, and **default-suppressed for any ED-flag user.**
  - **Recovery framing is restoration + performance + permission, never weight change** — "more fuel, more rest, smarter training" is caring for the body and getting *better* at your sport, never a diet or weight gain.
  - **No calorie/energy-availability numbers as user targets — ever, and especially never shown to a minor;** LEA/EA thresholds are research constructs for education only.
  - **Reward mechanics inverted away from streaks/PRs/deficits** — the app celebrates rest, fuelling, and cycle return, never activity streaks or under-eating.
  - **Tone: recovery-oriented, athlete-affirming, supportive, non-triggering, non-alarming, weight-stigma-aware** throughout; **ED-clinician review sign-off required** on A6 content and reward/celebration surfaces before release.

- **Amenorrhea framed gently as a health signal to address WITH a clinician and a trusted adult** — never a fitness achievement, never a catastrophe; the ~90-day and ~6-month prompts are **educational awareness/routing** (menstrual-cycle-as-vital-sign), never verdicts or alarms. Verify exact ACOG/AAP 3-vs-6-month wording in the adolescent-athlete context before user-facing copy.

- **Eating-disorder support resourcing (safety-critical):** because the widely-known **NEDA helpline is defunct (shut down 2023)**, Femio must **NOT** direct users to a NEDA helpline. The primary US ED resource is the **National Alliance for Eating Disorders helpline — 1-866-662-1235** (licensed therapists; free treatment referrals; Mon–Fri) [allianceforeatingdisorders.com]. Pair with the **988 Suicide & Crisis Lifeline** for crisis, plus **locale-appropriate** ED and crisis resources per region/language (esp. Arabic/MENA), and — for a minor — youth-appropriate resources. `[NEEDS SOURCE]` compile a per-locale, minor-appropriate ED + crisis directory before launch.

- **ED-concern & mood screeners:** framed as screening, never diagnosis; **never** output "you have an eating disorder / RED-S / the triad / depression"; every ED-concern or low-mood result surfaces supportive specialist routing + the National Alliance helpline + crisis resources + trusted-adult encouragement, gently. Confirm SCOFF (or locale/minor-appropriate ED screener) licensing/wording before use.

- **Bone-health & hormone content:** DXA-around-6-months and any transdermal-estradiol-vs-pill teaching is **educational only, clinician-decided, never a dose or recommendation**; teach that a **pill-induced bleed is not the same as cycle recovery** and can mask ongoing energy deficit. Bone-window content is motivating, not fear-based.

- **Predictions = uncertainty-honest:** never a single confident date; **no "days late"/"overdue" counter in this persona** (inaccurate for irregular/absent adolescent cycles and potentially triggering); degrade to an honest health-signal view.

- **Not contraception:** for a minor especially, **no fertile-window / "safe day" framing** and no implication that tracking prevents pregnancy; a neutral "could this be pregnancy?" helper only; a positive test uses the universal handler; a loss instantly triggers Gentle Mode per `09` §6.

- **Non-restriction principle:** teen mode governs data/ads/social — it must **not** block knowledge; every topic stays reachable via library/search (prevents pushing her to worse sources like sport-culture folklore or pro-ED spaces).

- **Mental health:** perfectionism, body image, and sport pressure are core here — crisis resources on any high/low screen; localized per region/language; ED and mental-health data treated as extra-sensitive (minor + ED = highest tier).

- **Privacy (GDPR/PDPL health data):** health data = special-category; **minor + ED + mental-health flags are the most sensitive combination in Femio** — explicit granular consent, purpose limitation, no ad-SDK/third-party sharing, no employer/insurer/coach visibility by default, local-first where feasible, full export/delete, suppressible ED-sensitive fields. Data-mapping + DPIA required before launch.

- **Content integrity:** all medical content referenced, medically reviewed (byline + date) **and ED-clinician-reviewed**, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.

- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education keeps out of regulated-device territory; ED-safety + minor-safety + legal review before store submission.

- **`[NEEDS SOURCE]` register:** exact ACOG/AAP adolescent-athlete amenorrhea-evaluation wording (3 vs 6 months); exact LEA/EA thresholds + RED-S 2023 wording (**never as user targets, never shown to a minor**); DXA-timing wording; "~90% of peak bone mass by ~18" exact phrasing; SCOFF/locale/minor-appropriate ED-screener licensing; LEAF-questionnaire adaptation for non-triggering use; per-locale (esp. Arabic/MENA) minor-appropriate ED + crisis directories and emergency numbers — all before shipping copy.

---

## Sources

**Clinical — Tier 1 (NIH / NHS / MedlinePlus / OWH / gov):**
- [Absent menstrual periods — secondary | MedlinePlus (NIH)](https://medlineplus.gov/ency/article/001219.htm)
- [988 Suicide & Crisis Lifeline | SAMHSA](https://www.samhsa.gov/mental-health/988)
- [988 Suicide & Crisis Lifeline (about)](https://988lifeline.org/)

**Clinical — Tier 2 (AAP / ACOG / IOC / society / peer-reviewed):**
- [The Female Athlete Triad — AAP, *Pediatrics* (2016)](https://publications.aap.org/pediatrics/article/138/2/e20160922/52440/The-Female-Athlete-Triad)
- [RED-S in Young Athletes: A Parent's Guide — HealthyChildren.org (AAP)](https://www.healthychildren.org/English/health-issues/injuries-emergencies/sports-injuries/Pages/Female-Athlete-Triad.aspx)
- [Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign — ACOG](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)
- [The female athlete triad: special considerations for adolescent female athletes — Translational Pediatrics](https://tp.amegroups.org/article/view/14901/15749)
- [IOC consensus statement on Relative Energy Deficiency in Sport (RED-S), 2018 — PDF](https://stillmed.olympics.com/media/Documents/Athletes/Medical-Scientific/Consensus-Statements/REDs/IOC-consensus-statement-Relative-Energy-Deficiency-in-Sport-2018.pdf)
- [The Female Athlete Triad / Relative Energy Deficiency in Sports (RED-S) — PMC 10304901](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10304901/)
- [Female Athlete Triad and RED-S: Nutritional Management — Nutrients / PMC 10857508](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10857508/)
- [Functional Hypothalamic Amenorrhea: An Endocrine Society Clinical Practice Guideline — JCEM (2017)](https://academic.oup.com/jcem/article/102/5/1413/3077281)
- [Is it normal to lose your period because of exercise? — Cleveland Clinic](https://health.clevelandclinic.org/is-it-normal-to-lose-your-period-because-of-exercise)
- [How exercise affects your menstrual cycle — UPMC HealthBeat](https://share.upmc.com/2023/10/how-exercise-affects-your-menstrual-cycle/)

**Bone health in adolescent athletes (the time-limited stake):**
- [FHA in adolescent athletes impairs bone accrual and increases fracture risk — Frontiers in Endocrinology (2025)](https://www.frontiersin.org/journals/endocrinology/articles/10.3389/fendo.2025.1709695/full)
- [FHA in adolescent athletes impairs bone accrual and increases fracture risk — PMC 12722922](https://pmc.ncbi.nlm.nih.gov/articles/PMC12722922/)
- [Risk Factors, Diagnosis and Management of Bone Stress Injuries in Adolescent Athletes — PMC 8073721](https://pmc.ncbi.nlm.nih.gov/articles/PMC8073721/)
- [The Connection between Diet, Periods and Bone Stress Injuries in Female Athletes — CHOP](https://www.chop.edu/news/health-tip/connection-between-diet-periods-and-stress-fractures-female-athletes)

**Teen-athlete / parent / coach RED-S education & awareness (voice-of-user + culture):**
- [Menstrual Period: Relative Energy Deficiency in Sports — Center for Young Women's Health](https://youngwomenshealth.org/guides/female-athlete-triad/)
- [Why Female Athletes Stop Getting Their Period (And Why It Matters) — Girlology](https://girlology.com/why-female-athletes-stop-getting-their-period-and-why-it-matters/)
- [Relative energy deficiency in sports (RED-S) — AboutKidsHealth (teens)](https://teens.aboutkidshealth.ca/relative-energy-deficiency-in-sports-red-s)
- [Relative Energy Deficiency in Sport (REDs) — Boston Children's Hospital](https://www.childrenshospital.org/conditions-treatments/reds)
- [Preventing Relative Energy Deficiency in Young Female Athletes — eatright.org (Academy of Nutrition and Dietetics)](https://www.eatright.org/fitness/sports-and-athletic-performance/beginner-and-intermediate/preventing-relative-energy-deficiency-in-young-female-athletes)
- [Absence of menstruation in female athletes: why they do not seek help — PMC 8609260](https://pmc.ncbi.nlm.nih.gov/articles/PMC8609260/)
- [The LEAF questionnaire as a screening tool for the Triad/RED-S in young football players — PMC 8420870](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8420870/)
- [RED-S in Adolescents — A Practical Review — PubMed 36122585](https://pubmed.ncbi.nlm.nih.gov/36122585/)
- [RED-S Disorder: When Athletes Don't Fuel Enough — Avera](https://www.avera.org/balance/sports-medicine-and-performance-training/female-athlete-triad-disorder-to-red-s-athletes/)

**Eating-disorder support & wellbeing (safety-critical resourcing):**
- [National Alliance for Eating Disorders — find treatment / helpline 1-866-662-1235](https://www.allianceforeatingdisorders.com/find-treatment/)
- [Amenorrhea & menstrual abnormalities in eating-disorder patients — National Alliance for Eating Disorders](https://www.allianceforeatingdisorders.com/amenorrhea-eating-disorders/)
- [Amenorrhea in eating-disorder patients — ACUTE](https://www.acute.org/resources/amenorrhea-absence-menstruation-eating-disorder)
- [NEDA phases out human helpline (2023 — why Femio must NOT use NEDA helpline) — WUNC/NPR](https://www.wunc.org/2023-05-31/national-eating-disorders-association-phases-out-human-helpline-pivots-to-chatbot)

**Competitor / app landscape (sports apps ignore the stopped cycle; cycle apps ignore the athlete):**
- [FitrWoman — athlete cycle/phase app (assumes a functioning cycle)](https://www.fitrwoman.com/)
- [Wild.AI — hormones & fitness for female athletes (adult, performance-framed)](https://wild.ai/)
- [Period Tracking for Female Athletes — Triathlete (limits of period apps for athletes)](https://www.triathlete.com/training/period-tracking-for-female-athletes/)
- [Flo — FTC action & class-settlement context](https://www.ftc.gov/news-events/news/press-releases/2021/01/developer-popular-womens-fertility-tracking-app-settles-ftc-allegations-it-misled-consumers-about)
- [Clue — variable-cycle handling](https://helloclue.com/)
