# Persona A3 — Teen With Heavy or Very Painful Periods (12–17)

Persona ID: **A3** · Track A (Puberty / Adolescent) · Mode: **Teen mode** (no ads, minimal data, trusted-adult, extra privacy)
Prepared: 2026-07-21 · Status: research + spec · Wave 3
Inherits Femio scope guardrail: **wellness / education / tracking only. Never diagnose, treat, prevent disease, or act as contraception. Screeners = "screening, discuss with a clinician."**
Inherits from `09_MASTER_ADAPTATION_MODEL.md`: seven invariants, state object, constant core, universal events (§6), Z1 fallback, blending rules. This spec adds only A3-specific layers.

---

## A. Persona snapshot

| | |
|---|---|
| **Who** | "Mariam," 14. Periods since 12. Every month: soaks through a super pad in under 2 hours, passes clots, has bled through her school trousers twice, and misses 1–2 school days from pain — sometimes vomiting from cramps. Everyone (mother, aunt, school nurse, even a GP) has told her some version of "heavy painful periods are normal, they run in the family — you'll grow out of it." |
| **Emotional state** | Exhausted, embarrassed, and starting to believe the dismissal — "maybe I'm just weak." Dreads her period. Anxious about leaking in public. Increasingly angry that nobody takes it seriously, but has no vocabulary or evidence to push back with. |
| **Health literacy** | Low, and *actively miscalibrated*: she has been taught that her abnormal is normal. Doesn't know terms like HMB, dysmenorrhea, anemia, or that "pain that stops your life" is a recognized medical flag. |
| **Physical state** | Likely iron-depleted: tired, pale, dizzy on stairs, poor concentration — often attributed to "being a teenager" rather than blood loss. |
| **Privacy needs** | Very high (all A2 shared-device/discreet-use needs apply) — **but with a twist**: unlike A2 she often *wants* a parent involved, because she needs an adult to book and back the doctor's visit. The barrier is not secrecy; it's being believed. |
| **Device / context** | Web-first, often a shared or hand-me-down device. Logs mid-crisis (bathroom at school, in bed with a heat pack). |
| **Language** | May be Arabic-first / RTL. In high-stigma contexts, dismissal is amplified ("we don't talk about this") and clinician access requires a parent — making the parent-facing summary even more load-bearing. |
| **Primary jobs-to-be-done** | (1) "Tell me honestly whether this is normal — stop gaslighting me." (2) "Help me *prove* it — count the pads, the hours, the missed days." (3) "Give me something I can show my mum and a doctor that they'll take seriously." (4) "Explain why I'm so tired." (5) "Tell me what to ask the doctor." |
| **What success feels like** | Validation ("what you're describing has a name and is worth checking"), a bleeding/pain record a clinician respects, a parent who finally says "let's book an appointment," and less fear of the next period. |
| **Anti-goals (things that break trust)** | Another voice saying "periods are just like that"; scary disease-naming ("you might have a bleeding disorder/endometriosis!"); minimizing tone; a tracker that only does dates and can't capture soaking/clots/flooding; data leaking to family before *she* chooses to share. |

**Design tension to hold:** A3 needs **validation without alarm**. The core failure mode of the market is binary: either dismissal ("normal!") or dread (disease lists). Femio's job is the calm middle: *"this pattern is worth a clinician's look — here's your evidence, here's how to bring a trusted adult in."* Same personalize-never-restrict rule as A2; teen mode gates data/ads/social, never knowledge.

---

## B. Needs & questions (voice-of-user)

Mined from teen/parent threads (r/Periods, r/AskDocs-style, Mumsnet-type parent forums), clinical-center patient education (CHLA, UT Southwestern, CHOP), UK school-attendance research, and app-store reviews of trackers used for symptom evidence. Phrased in her (and her parent's) voice.

**"Is this actually normal?" (validation-seeking — the dominant need)**
- "I soak a pad in an hour and pass clots the size of coins. My mum says hers were the same." → *Objective thresholds (§D): soaking through every 1–2 hours, clots ~larger than a grape/2.5 cm, bleeding >7 days = worth a clinician's look — even if it runs in the family (family clustering can itself be a clue, §D).* 
- "I bled through my clothes at school again. Is that just bad luck?" → *Flooding/leaking through doubled-up protection is a recognized heavy-bleeding signal, not clumsiness.*
- "My period lasts 9–10 days. Everyone says periods are a week." → *>7 days is the education threshold (§D).*
- "The pain makes me throw up / faint. My friends take a paracetamol and go to PE." → *Pain that causes vomiting, fainting, or missed school is not baseline dysmenorrhea to push through (§D).*

**"Why am I like this?" (tired, dizzy, foggy)**
- "I'm exhausted all the time and nearly fainted on the stairs." → *Iron-deficiency/anemia education: heavy periods lose iron; fatigue/pallor/dizziness/poor concentration are describable signs — a clinician can check with a simple blood test (§D). Never "you are anemic."*
- "Why do I get so pale and shaky during my period?"

**"Nobody believes me." (dismissal — the emotional core)**
- "The doctor said it's normal for teenagers." → *Research shows most women's period symptoms get dismissed at least once; ~90% of adolescents with HMB are never screened for bleeding disorders despite guidelines (§D). Femio arms her with objective data, not just adjectives.*
- "How do I make my mum understand it's not like her periods?" → *Shareable summary: pads/hours, clots, flooding events, missed days, pain scores over months — chosen and initiated by her.*
- "What do I even say at the appointment?" → *Doctor-visit prep: questions checklist + her data summary.*

**"What could it be?" (curiosity — handle without alarm)**
- "My cousin has von Willebrand. Could I?" → *Educational: bleeding disorders are more common than people think among teens whose periods have been very heavy since the first ones; there are simple screening questions and blood tests a clinician can do (§D). Screening awareness only — never a suggestion she has it.*
- "Can teenagers get endometriosis? TikTok says yes." → *Yes — teen endo is real and often dismissed; the flag is period pain that doesn't respond to usual measures and disrupts life. Framed as "worth discussing," never as a probable diagnosis (§D).*

**"Help me survive today." (coping)**
- "How do I get through a school day on my heaviest day?" → heavy-flow kit, change schedule, backup clothes, telling a teacher/nurse.
- "What actually helps this pain?" → heat, movement, OTC pain relief *per label / with a trusted adult* — education, never a Femio dose or treatment plan; plus "if the usual things don't touch it, that itself is worth telling a doctor" (§D).
- "Can I be excused from PE / exams?" → know-your-rights style practical content, locale-aware.

**Parent voice (A3 is Femio's first strongly parent-inclusive persona)**
- "Is my daughter's bleeding normal or am I overreacting?" → parent-facing explainer of the same thresholds.
- "She's missing school every month — what do I ask the pediatrician?" → visit-prep for parents.
- "Her iron came back low — what does that have to do with periods?" → anemia-HMB link education.

> **Key research insight:** dysmenorrhea is the **leading cause of recurrent short-term school absence in adolescent girls**, and heavy/prolonged bleeding measurably harms attendance and exam results — yet the majority of affected teens never seek care because they (and their families) believe it's normal. The single highest-value thing Femio can do for A3 is **recalibrate "normal" and generate evidence**. (§D, sources.)

---

## C. Competitor teardown

The A2 teardown (Flo, Clue, Stardust, Spot On, Eve, Simple Design — see `A2_teen_newly_menstruating.md` §C) applies wholesale. A3-specific findings — this is a niche the teen-app market **actively avoids**:

| Capability A3 needs | State of the market |
|---|---|
| **Objective bleeding quantification** (pads/hours, soak level, clots, flooding — PBAC-style) | Essentially absent from consumer apps. Flo/Clue log flow as light/medium/heavy dots — useless as clinical evidence. PBAC-style pictorial scoring exists only in clinical/research tools (WFH e-learning charts, paper charts); no teen-friendly consumer implementation. **Wide-open white space.** |
| **"Not normal" education** | Consumer apps stay vague to avoid medical-claim risk; teen-oriented apps (Spot On) skip HMB/dysmenorrhea red-flag literacy almost entirely. Clinical sites (CHLA, UT Southwestern, CHOP) have excellent content but no tracking attached. |
| **Doctor/parent-shareable report** | Some adult apps export cycle charts; none produce an adolescent HMB/pain summary structured around what clinicians actually ask (bleeding since menarche? soak frequency? family history? missed school?). |
| **Bleeding-disorder screening awareness** | No consumer app touches it, despite ACOG's screening questions being simple and public. Fear of scope creep leaves teens unscreened (~90% miss rate, §D). Femio can do this *as education + clinician routing* within scope. |
| **Teen endo acknowledgment** | Endo apps exist for diagnosed adults; teen trackers don't mention it. Teens learn about it from TikTok — unreferenced and often alarmist. |
| **Pain-impact tracking** (missed school, vomiting, functional limits) | Generic symptom tags at best. No app tracks *functional disruption*, which is exactly what ACOG says clinicians should ask about. |

**White space Femio can own for A3:** the only teen-mode app that (1) quantifies bleeding objectively (PBAC-informed, teen-friendly), (2) tracks pain by *life impact*, (3) teaches evidence-based "not normal" thresholds calmly, (4) produces a parent/clinician-ready summary, and (5) does bleeding-disorder + endo *awareness* strictly as screening → clinician — all privacy-by-default, Arabic-first capable.

---

## D. Clinical grounding (cited)

Tier-1 (NIH/NHS/MedlinePlus/KidsHealth/CDC) + Tier-2 (ACOG/AAP/children's-hospital) sources; URLs in **Sources**. Everything surfaces as *education/screening*, never diagnosis.

**What counts as heavy menstrual bleeding (HMB) — the education thresholds**
- HMB is commonly defined as bleeding lasting **>7 days** or **>80 mL blood loss per cycle** (CHOP; NICE-aligned UK sources). Since mL can't be self-measured, the practical proxies are:
  - **Soaking through a pad/tampon every 1–2 hours or more often** (ACOG; CHLA; UT Southwestern).
  - **Needing to double up** protection or **change overnight**.
  - **Flooding / bleeding through clothes**; **clots about the size of a quarter/grape (~2.5 cm) or larger** (ACOG; UT Southwestern). `[NEEDS SOURCE — confirm exact clot-size wording per ACOG vs NHS before publishing copy]`
- **PBAC (Pictorial Blood Loss Assessment Chart):** validated pictorial scoring of pads/tampons (light 1 / medium 5 / heavy 10 points, + clots and flooding); a score **>100 ≈ >80 mL/cycle**, with self-assessed sensitivity ~86% and specificity ~89% for HMB. This is the evidence base for Femio's bleeding tracker design — Femio computes a *pattern indicator for discussion*, never a diagnosis.
- HMB is common: reported by roughly **20–40% of adolescent females** depending on population and definition (Brazilian multicenter study ~20.5%; reviews up to ~40%) — common ≠ normal-to-ignore.

**Bleeding disorders (screening awareness only — the core "since menarche" signal)**
- **~20% of adolescents presenting with HMB — and ~33% of those hospitalized for it — have an underlying bleeding disorder** (ACOG Committee Opinion 785). Most common: **von Willebrand disease**, platelet function defects, thrombocytopenia, clotting-factor deficiencies.
- **About half of adolescents with bleeding disorders present with heavy bleeding at menarche** — "very heavy since my very first periods" is a key screening cue (ACOG 785).
- Other cues ACOG lists: easy bruising, frequent/prolonged nosebleeds, bleeding after dental work/surgery, **family history** of a bleeding disorder or of heavy periods/hysterectomy-for-bleeding in relatives.
- **~90% of adolescents with HMB are never screened for von Willebrand disease** despite long-standing guidance (ObG Project) — the screening gap Femio's awareness content addresses.
- Femio's framing: *"Doctors have a short list of questions and a simple blood test for this — worth asking about, with a trusted adult."* Never "you may have VWD."

**Dysmenorrhea — what's NOT just cramps**
- Dysmenorrhea affects a majority of adolescents (prevalence ranges ~50–90%+); **~15% describe severe pain**, and **one-third to one-half miss school or work at least once per cycle** (Pediatric Medicine review; ACOG 760). It is the **leading cause of recurrent short-term school absenteeism in adolescent girls** (ACOG 760).
- **Functional disruption is the clinical flag ACOG tells clinicians to ask about**: missing school, sports, or activities because of period pain is itself reason to seek care (ACOG 760; UT Southwestern). Vomiting or fainting from pain likewise.
- **Pain that does not improve with usual first-line measures (NSAIDs per label / hormonal options prescribed by a clinician) within ~3–6 months should prompt investigation for secondary causes — notably endometriosis** (ACOG 760). Femio teaches this timeline as *"if the usual things aren't helping over a few months, that's information — tell your doctor."*

**Endometriosis in adolescents is real (education, never suggestion)**
- ACOG 760: endometriosis **does occur in adolescents**, is a leading cause of secondary dysmenorrhea/chronic pelvic pain in teens, and diagnosis is often delayed for years partly because teen pain is normalized. Flags include progressive/worsening pain, pain not responding to first-line measures, **family history in a first-degree relative**, school absence, and GI/fatigue-type accompanying symptoms.
- Femio's framing: *"Period pain that keeps disrupting your life and doesn't respond to the usual measures deserves investigation — teen endometriosis exists and asking about it is legitimate."* Never a probability, never a label.

**Iron deficiency & anemia (awareness + describable signs)**
- Every ~1 mL of blood lost costs ~0.4–0.5 mg iron; adolescents with HMB are at high risk: iron deficiency is near-universal in teens presenting to emergency care with HMB, and in general adolescent populations iron deficiency affects on the order of **up to ~40% of adolescent females** (US/Swedish data), with IDA in ~7%.
- Describable signs to log + mention to a clinician: fatigue, paleness, dizziness/light-headedness, headaches, poor concentration, shortness of breath on exertion (CHLA; KidsHealth-level framing). Confirmed only by a **blood test a clinician orders** — Femio never infers anemia from logs.
- Emerging clinical discussion supports ferritin/Hb screening for menstruating adolescents `[NEEDS SOURCE — cite the specific guideline if/when one is issued; currently review-level]`.

**Dismissal is measurable (grounds the validation tone)**
- UK research: heavy/prolonged bleeding → **48% higher odds of persistent school absence** and measurable exam-result harm; ~9 in 10 women can't name the signs of heavy bleeding; half report having period symptoms dismissed. Intergenerational normalization ("runs in the family — it's fine") is documented — and ironically, familial heavy bleeding can be a bleeding-disorder clue (ACOG 785).

**Never in scope:** hormonal-treatment recommendations, NSAID dosing, iron-supplement dosing, "you have HMB/anemia/VWD/endo" statements. All thresholds above are **educational routing to a clinician visit with a trusted adult.**

---

## E. Feature set (prioritized)

**Must-have (MVP for A3)**
1. **Teen mode by default** (all A2 §E-1 protections inherited: no ads, minimal data, no community DMs, trusted-adult opt-in, GDPR age-of-consent, shared-device discretion).
2. **Objective bleeding log (PBAC-informed, teen-friendly)** — per product change: product type + soak level (pictorial: light/medium/soaked), clots (small/large), flooding/leak events, overnight changes, doubling up. Auto-derives pads-per-day, soak-interval, bleed duration. Presented as *"your pattern,"* never a score-with-verdict; the >100-type indicator surfaces only as "this pattern is the kind doctors ask to see — worth a visit."
3. **Pain-impact log** — pain 0–10 *plus functional impact*: missed school / skipped sport / couldn't leave bed / vomited / fainted; what she tried and whether it helped (education-framing, not treatment tracking).
4. **"Is this normal?" recalibration content** — the §D thresholds taught calmly and plainly; explicit myth-piercing of "heavy painful periods are just normal / run in the family," including "running in the family can itself be worth mentioning."
5. **Doctor-visit summary (the hero artifact)** — a one-page, clinician-literate export: bleeding pattern (soak frequency, duration, clots, flooding), pain + functional impact over time, missed-school count, energy/dizziness symptoms, "heavy since first period?" flag, family-history checklist (self-entered), and her questions. **She generates and shares it — by her choice** — with a parent and/or doctor.
6. **Gentle clinician routing** — when logs cross §D thresholds: *"What you're logging is the kind of thing doctors want to know about. It could be worth booking a visit with a trusted adult — here's your summary to bring."* Calm, never alarming, never diagnostic; repeated dismissal-resilience framing ("if you're told it's normal but it keeps disrupting your life, it's okay to ask again or ask someone else").
7. **Anemia-awareness module** — the iron-loss link + describable signs + "a simple blood test can check"; optional energy/dizziness logging feeding the summary.
8. **Bleeding-disorder screening-awareness module** — ACOG's screening cues as education ("heavy since the very first period," nosebleeds, bruising, family history, dental-work bleeding) → *"ask your doctor whether a bleeding-disorder check makes sense."*
9. **Full-library reachability + Arabic-first/RTL** (inherited).

**Should-have**
10. **Trusted-adult share flow tuned for A3** — unlike A2 (privacy-first), A3's flow foregrounds *"want help telling a parent?"*: a parent-facing explainer page she can show ("what heavy bleeding actually means — from medical sources") that does the arguing for her.
11. **Heavy-day survival kit** — school-day plan for heaviest days: supplies list, change schedule, backup clothes, talking to the school nurse, leak-response script.
12. **Pain-coping education** — heat, movement, sleep, OTC per label/with a trusted adult; plus the "if it doesn't help over months, that's a signal" teaching (§D).
13. **Teen-endo awareness article** — validating, calm, referenced; reachable from pain content, never pushed as a scare.
14. **Appointment prep + debrief** — questions checklist before; "what the doctor said" notes after; if dismissed, gentle "you can seek a second opinion" education.

**Nice-to-have**
15. Missed-school counter with term/semester view (powerful evidence artifact for parents).
16. Period-product cost/consumption awareness (heavy bleeders' hidden burden).
17. Localized school-rights content (PE excusal, exam considerations) per launch market.
18. Post-visit pathway content: "what tests/next steps often look like" (educational).

---

## F. Content modules (reading order)

Sequenced validation → thresholds → body literacy → evidence-building → advocacy. Grade 6–8, referenced, medically reviewed, 4 languages. Tone: **believing, calm, never scary** — every "not normal" statement paired with "and it's checkable."

1. **"You're not exaggerating" (start here)** — validation; dismissal is common and documented; pain/bleeding that disrupts your life is worth medical attention; you deserve to be taken seriously.
2. **How much is too much? The honest bleeding guide** — the §D proxies (soak frequency, duration >7 days, clots, flooding, doubling up) in plain words; "runs in the family ≠ nothing to check."
3. **Pain that's more than cramps** — normal dysmenorrhea vs. life-disrupting pain; vomiting/fainting/missed school as flags; the "usual measures didn't help over months" signal.
4. **Why you might be so tired** — iron and periods; anemia signs; the simple blood test; food sources of iron (education only, no supplement dosing).
5. **Tracking as evidence** — how the bleeding + impact logs work and why doctors respect this kind of record.
6. **Talking to your mum/dad (or another trusted adult)** — scripts, the shareable explainer, handling "mine were the same."
7. **At the doctor's** — what to bring (your summary), what they may ask (including "heavy since your first period?" and family bleeding history), questions to ask, what tests often look like; being persistent if dismissed.
8. **Could it be something specific? (calm, optional reading)** — bleeding disorders (VWD et al.) and teen endometriosis as *things doctors can screen for* — awareness, prevalence honestly stated, zero self-diagnosis framing.
9. **Surviving heavy days** — school-day logistics, leak response, heat/comfort, sleep.
10. **Your body, your privacy** (inherited from A2) — what's stored, what a trusted adult sees only if *she* shares.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Everything in A2 §G, plus: per-change bleeding detail (product, soak level pictorially, clots small/large, flooding, overnight/double-up), pain 0–10 + functional-impact tags (missed school, skipped activity, vomited, fainted, bed-bound), what-helped notes, energy/dizziness, missed-school days.
- Data minimization holds: all optional, no location, nothing leaves the account without explicit share action.

**Tools**
- **Bleeding-pattern view** — PBAC-informed visual of her cycle: soak-interval trend, duration, clot/flooding events. Copy: *"a pattern doctors ask about"* — never "abnormal result."
- **Doctor-visit summary generator** (§E-5) — one page, printable/PDF/shareable link with expiry; she previews exactly what's in it before sharing.
- **Screeners** — heavy-bleeding pattern screener, pain-impact screener, bleeding-disorder awareness checklist (ACOG-cue questions, self-completed), all outputting **"this is screening — please discuss with a clinician, ideally with a trusted adult"**; no scores presented as results.
- **Uncertainty-honest predictor** (inherited) — with heavy-day heads-up: "your heavier days often start around day 2 — pack extra."

**Alerts (private, gentle)**
- Neutral lock-screen text always (inherited).
- **Soft threshold prompt** when logs cross §D lines: *"You've logged soaking through every hour today. That's something doctors like to know about — your summary is ready if you want to show someone."* Never sirens, never disease names in notifications.
- **Escalating-gently rule:** if threshold patterns repeat across ≥2 cycles without a logged doctor visit, one calm nudge per cycle max — encouragement, never nagging or fear.
- **Acute-symptom education box** (universal red-flag handler, §6 master model): fainting, soaking a pad every hour for several hours, or dizziness-with-heavy-bleeding surfaces a prominent *"tell an adult now and seek care"* education box. Content, not triage.
- **Never:** ads, "you might have X" notifications, fertility framing, or auto-sharing anything with a parent.

---

## H. EMR fields (core vs. persona-specific)

**Core:** inherited unchanged (see A2 §H / master model §3).

**Persona-specific (A3 layer — additive over the A-track layer)**
- **Bleeding detail log[]**: product type, soak level, clots (S/L), flooding events, overnight changes, double-up flag → derived: soak-interval, pads/day, bleed-duration, PBAC-informed pattern indicator (internal, non-diagnostic).
- **Pain-impact log[]**: pain score, functional-impact tags, what-tried/what-helped (free text), vomit/faint booleans.
- **Missed-school counter** (user-entered).
- **Energy/anemia-adjacent symptom log**: fatigue, dizziness, pallor self-report.
- **"Heavy since menarche" flag** (self-report boolean — key bleeding-disorder screening cue).
- **Family-history checklist** (self-entered, non-diagnostic): heavy periods in relatives, known bleeding disorder, relative with endometriosis, nosebleeds/bruising pattern.
- **Screener history**: which awareness checklists completed + timestamps (never "results").
- **Clinician-journey markers**: visit logged, summary generated/shared (+scope), "was told normal" flag (drives dismissal-resilience content, gently).
- **Trusted-adult share state**: what artifact shared, when, revocable.
- Explicitly **NOT** stored: any diagnosis label (VWD/endo/anemia may only exist as *user-entered* "my doctor told me" conditions_flagged, per core), medication doses, treatment plans.

---

## I. Personalization rules

**Wizard resolves A3 when:** minor + menstruating **and** reports heavy bleeding signals (soaking fast / clots / flooding / >7-day bleeds) **or** pain that causes missed school/vomiting — via wizard question or via A2-side pattern detection (§J).

**Home leads with:**
1. Validation card ("what you're describing is worth taking seriously") + this-cycle bleeding/pain snapshot.
2. One-tap bleeding + pain quick-log (built for mid-crisis use: big targets, 3 taps max).
3. **Doctor-visit summary** tile (always visible — the hero artifact).
4. Content rail in §F order (validation → thresholds → tiredness).
5. Privacy quick-controls (inherited).

**Defaults:**
- Teen mode ON (inherited full set). Tone = believing, steady, zero alarm.
- Trusted-adult flow foregrounded as *help*, still strictly opt-in.
- Predictions as windows (inherited) + heavy-day heads-up ON.
- Neutral notifications; Arabic-first/RTL per locale; culturally-aware parent-explainer variant for high-stigma markets.

**Hidden-but-reachable:** TTC/pregnancy/contraception/adult condition-management content off-home but searchable (inherited). Endo/bleeding-disorder deep content is *reachable and linked from pain/bleeding articles* but never pushed to the home feed unprompted — curiosity-driven, not fear-driven.

---

## J. Adaptation triggers (state transitions)

Universal events inherited from master model §6 (positive test, mood/crisis, red-flag, disengagement, toggle-off, age-of-consent). A3-specific:

**Into A3:**
- Wizard match (above), or
- **From A2 on pattern** (mirrors A2 §J): heavy-bleeding pattern (soaking >q1–2h / doubling up / flooding / clots / >7-day bleeds) or severe-dysmenorrhea pattern (missed school / vomiting) across logs → gentle offer: *"Want Femio to focus on heavy or painful periods? You can undo this anytime."* Never forced, never framed as "something is wrong with you."

**Out of / branch from A3:**
- **Bleeding-disorder screening-awareness path** → not a persona change: surfaces the ACOG-cue awareness checklist + *"discuss a bleeding-disorder check with your clinician"* routing. If she later enters a clinician-given diagnosis, it becomes a `conditions_flagged` modifier layered on A3 (education skin adjusts; still never treatment advice).
- **Endo-possibility education path** → likewise not a persona change: persistent life-disrupting pain + "usual measures not helping over months" + (optionally) family-history flag → teen-endo education + *"worth investigating with your clinician."* Clinician-entered endo dx later layers as a modifier (→ adult endo persona at age).
- **Anemia-adjacent pattern** (fatigue/dizziness cluster + heavy logs) → anemia-awareness content + blood-test education + clinician prompt. Never a persona change, never an inferred diagnosis.
- **Improves** — bleeding/pain normalizes into typical ranges across ≥3 cycles (with or without clinician care) → offer transition **back toward A2** (if still in early gynecologic years) or **B1** at age/regularity maturity; A3 layer archived-but-reachable, celebration-free acknowledgment ("your recent cycles look more comfortable — want the standard view?").
- **Turning 16 / age-of-consent** → universal handler: minor gating relaxes, consent re-confirmed; if patterns persist she moves to the **adult HMB/dysmenorrhea persona (B-track)** carrying her full history — the multi-year record is precisely what an adult workup values.
- **Long gaps appear instead** (>~90 days) → A5 nudge (inherited A-track logic).
- **PCOS-adjacent signs** → A4 screening nudge (inherited; heavy irregular bleeding + hyperandrogenic signs handled per A2 §D caution — screening only).
- **Acute severe event logged** (fainting, soaking hourly for several hours) → universal red-flag handler: immediate "tell an adult + seek care" education box; no state change; log stays raw.

---

## K. Compliance flags

All of A2 §K inherited (scope, not-contraception, uncertainty-honest predictions, minor privacy highest-tier, shared-device safety, safeguarding-vs-surveillance, non-restriction, referenced content, cultural sensitivity). A3 additions:

- **Screening ≠ diagnosis, hardest test in the app:** the PBAC-informed indicator, bleeding-disorder checklist, and endo education sit closest to the medical-device line. Copy discipline: outputs are *patterns/questions to bring to a clinician*, never scores-with-meaning, risk percentages, or condition suggestions ("you may have…" is banned copy). Internal indicator values never rendered as clinical results.
- **Validation without alarm:** dismissal-countering language must not tip into fear or anti-clinician sentiment. "It's okay to ask again" — never "doctors are wrong / demand X test."
- **No treatment content as instruction:** heat/movement/OTC framed per-label/with-a-trusted-adult; iron content is dietary education only — **no supplement or NSAID dosing, ever** (minor + dosing = double red line).
- **Parent-share integrity:** every share is teen-initiated, previewed, scoped, revocable; the parent explainer contains education, not her raw diary unless she includes it. No covert parent visibility even when a trusted-adult link exists.
- **Doctor-summary honesty:** the export must state it is self-reported tracking data from a wellness app, not a medical record or diagnosis.
- **Acute-symptom messaging:** the "seek care now" education box follows the universal handler — content only, no triage claims, localized emergency framing per market.
- **`[NEEDS SOURCE]` register:** exact clot-size threshold wording (ACOG vs NHS "quarter/2.5 cm/grape" variants); formal guideline citation for adolescent ferritin/Hb screening if adopted; NHS page URL for HMB definition to pair with CHOP for UK-market copy; per-locale school-rights content sourcing; medical-review sign-off on all §D numbers before content freeze (add to master reviewer checklist, model §11).

---

## Sources

**Teen HMB thresholds & bleeding disorders (Tier-2 clinical)**
- [ACOG Committee Opinion 785 — Screening and Management of Bleeding Disorders in Adolescents With Heavy Menstrual Bleeding](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2019/09/screening-and-management-of-bleeding-disorders-in-adolescents-with-heavy-menstrual-bleeding)
- [AAFP — Heavy Menstrual Bleeding in Adolescents: ACOG Management Recommendations](https://www.aafp.org/pubs/afp/issues/2020/0515/p633.html)
- [Contemporary OB/GYN — ACOG Guidelines at a Glance: Heavy Menstrual Bleeding in Adolescents](https://www.contemporaryobgyn.net/view/acog-guidelines-glance-heavy-menstrual-bleeding-adolescents)
- [ACOG Committee Opinion — Von Willebrand Disease in Women](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2013/12/von-willebrand-disease-in-women)
- [The ObG Project — Are We Meeting ACOG Screening Guidelines for VWD in Adolescents with Menorrhagia? (~90% unscreened)](https://www.obgproject.com/2018/07/10/should-we-screen-for-von-willebrand-disease-more-often/)
- [PMC — Diagnosis of Bleeding Disorders in Adolescents Hospitalized for Heavy Menstrual Bleeding](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9512591/)
- [CHOP — Heavy Menstrual Bleeding (Menorrhagia): >7 days / >80 mL definition](https://www.chop.edu/conditions-diseases/heavy-menstrual-bleeding-menorrhagia)
- [Children's Hospital Los Angeles — Teens With Heavy Menstruation Don't Need to Suffer in Silence](https://www.chla.org/blog/advice-experts/teens-heavy-menstruation-dont-need-suffer-silence-period)
- [UT Southwestern — Heavy periods aren't normal in teens and might indicate a serious concern](https://utswmed.org/medblog/heavy-periods-young-women/)
- [UChicago Medicine — Heavy Menstrual Bleeding in Teens & Preteens](https://www.uchicagomedicine.org/comer/conditions-services/pediatric-adolescent-gynecology/heavy-menstrual-bleeding)

**Dysmenorrhea & adolescent endometriosis (Tier-2 clinical)**
- [ACOG Committee Opinion 760 — Dysmenorrhea and Endometriosis in the Adolescent](https://journals.lww.com/greenjournal/fulltext/10.1097/aog.0000000000002978~acog-committee-opinion-no-760-dysmenorrhea-and-endometriosis) · [PubMed record](https://pubmed.ncbi.nlm.nih.gov/30461694/)
- [Pediatric Medicine — Dysmenorrhea in adolescents (prevalence, severe-pain ~15%, school absence)](https://pm.amegroups.org/article/view/4941/html)
- [PubMed — Primary Dysmenorrhea in Adolescents: Prevalence, Impact and Recent Knowledge](https://pubmed.ncbi.nlm.nih.gov/26841639/)
- [PMC — Dysmenorrhea in adolescents requires careful investigation of endometriosis (case-control)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10491014/)
- [Dayton Children's — Primary dysmenorrhea in adolescents](https://www.childrensdayton.org/the-hub/primary-dysmenorrhea-adolescents)

**Anemia / iron deficiency (Tier-1/peer-reviewed)**
- [ASH Blood — Iron deficiency and anemia are almost universal in adolescents in the ED with HMB](https://ashpublications.org/bloodrci/article/2/1/100045/557439)
- [PubMed — Iron Deficiency Anemia in Adolescents Who Present with Heavy Menstrual Bleeding](https://pubmed.ncbi.nlm.nih.gov/27789349/)
- [AJOG — The relationship between HMB, iron deficiency, and iron deficiency anemia](https://www.ajog.org/article/S0002-9378(23)00024-8/fulltext)
- [PMC — Is it time to offer routine screening for iron deficiency in healthy adolescent females?](https://pmc.ncbi.nlm.nih.gov/articles/PMC12512079/)
- [PMC — Iron Deficiency Anemia in Teenage Girls: Impact of Menarche and Nutritional Care](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12204737/)

**Objective bleeding measurement (PBAC)**
- [PubMed — PBAC diagnostic accuracy vs alkaline hematin (sens 86% / spec 89%)](https://pubmed.ncbi.nlm.nih.gov/21228538/)
- [PMC — Pictorial methods to assess heavy menstrual bleeding: systematic review](https://pmc.ncbi.nlm.nih.gov/articles/PMC7011238/)
- [World Federation of Hemophilia — PBAC chart resource](https://elearning.wfh.org/resource/pictorial-blood-loss-assessment-chart/)
- [PMC — Heavy or healthy? Assessing menstrual bleeding and bleeding tendency in Dutch adolescents](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12666817/)

**Dismissal, school impact & lived experience**
- [AOL/PA — Heavy periods harm exam results and school attendance (48% higher odds persistent absence)](https://www.aol.com/news/heavy-periods-harm-exam-results-104636798.html)
- [AOL/PA — Nine in 10 women don't know signs of heavy periods](https://www.aol.com/news/nine-10-women-don-t-002059094.html)
- [PMC — Menstrual pattern and self-reported abnormal uterine bleeding in Brazilian adolescents (~20.5% HMB)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12553103/)
- [PMC — Hidden burden of dysmenorrhea among adolescent girls: well-being and academic performance](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10918951/)
- [Johns Hopkins Medicine — Menstrual Cycle Management in Adolescents](https://www.hopkinsmedicine.org/health/conditions-and-diseases/menstrual-conditions/menstrual-cycle-management-in-adolescents)
- [Cleveland Clinic — Why Are My Teen's Periods So Heavy?](https://health.clevelandclinic.org/why-are-my-teens-periods-so-heavy-should-i-be-concerned)

**Competitor & privacy context** — inherited from `A2_teen_newly_menstruating.md` §Sources (Flo/Clue/Stardust/Spot On teardown, FTC/Meta privacy record).
