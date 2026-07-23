# Persona B5 — Irregular or absent cycles, NOT yet attributed to a specific diagnosis

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician."
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC) · Inherits: `09_MASTER_ADAPTATION_MODEL.md`
> Sibling: `B6_pcos_not_ttc.md` (shares irregular-cycle prediction logic; B5 is the *undiagnosed* upstream state that routes into B6 and others).

---

## A. Persona snapshot

**Who she is.** "Noor," 29. Her cycles have never been dependable — sometimes 24 days, sometimes 55, occasionally a 3-month gap with nothing. No one has told her *why*. She hasn't been diagnosed with anything; she's had a "let's wait and see" from one GP and a "probably stress, lose a little weight" from another. She is **not** trying to conceive. She isn't even sure her pattern counts as a "problem" — she just knows every app she's tried is confidently, repeatedly wrong about her, and she wants to actually understand her own body. Arabic-first (also reads English), web on her phone.

**What she lives with.**
- **Unpredictability itself** — the core burden. She can't plan, and she can't tell "normal-for-me variation" from "something to check."
- **The diagnostic void** — she's at a crossroads with many possible explanations (PCOS, thyroid, stress/low-energy-availability, perimenopause if older, pregnancy, primary ovarian insufficiency) and no map of which one is hers.
- **Low-grade anxiety** — is a missing period a pregnancy? A disease? Nothing? Each gap reopens the question.
- **Feeling dismissed** — "just stress / just lose weight" without evaluation; she doesn't know what a proper work-up even looks like or when she's entitled to ask for one.

**Core emotional drivers.** Wants to *understand*, not be *reassured into inaction* or *alarmed into panic*. Wants an app that says "your cycles vary a lot — here's your actual pattern, here's the range of things that cause this, and here's the point at which it's worth a clinician's eyes," instead of a fake ovulation date or a red "LATE" badge. Wants to walk into an appointment able to say "here is my history and here is what I want checked."

**Jobs-to-be-done.**
1. Track long/irregular/absent cycles *meaningfully* without being told she's "late" or "trying."
2. Understand the **many** possible causes of irregular/absent cycles — without self-diagnosing.
3. Learn where the real thresholds are (the ~90-day flag; new sudden change; other red-flag symptoms) so she knows when "wait and see" ends.
4. Get uncertainty-honest predictions — a range and a plain "we can't be precise, and that's expected."
5. Prepare for a clinician visit so she isn't dismissed again, and know which specialist/tests fit which cause.

**Success = she stops guessing, has a clear picture of her own pattern, understands the branch points, and either gets meaningful reassurance or gets routed to the right clinician at the right time.**

---

## B. Needs & questions (voice-of-user)

Mined from irregular-cycle / amenorrhea / "why is my period late but not pregnant" communities, period-tracker app reviews, and qualitative studies on tracker accuracy and anxiety (see Sources). Paraphrased to avoid quoting individuals.

**On prediction & tracking (the #1 pain):**
- "The app swears my period is coming Tuesday. It's been three Tuesdays."
- "It marks me 'X days late' every single month when 'late' means nothing for me — I don't have a due date to be late for."
- "I just want to see my real history instead of a prediction that's always wrong. Show me the pattern, not a fake date."
- "The second I log an irregular cycle it asks if I'm trying to get pregnant. I'm not. Stop it."

**On not knowing why (the defining anxiety of this persona):**
- "I don't even have a diagnosis. Is it PCOS? Thyroid? Stress? Am I in early menopause at 34? Nobody will say."
- "Every missed period, my brain goes: pregnant, or dying, or nothing. I can't tell which."
- "I googled 'no period not pregnant' and got ten different conditions. Which one is me?"

**On being taken seriously / when to worry:**
- "One doctor said 'it's just stress,' another said 'lose weight' — neither actually tested anything."
- "How long is too long to go without a period before I *should* push for tests?"
- "What would a proper check-up even look like? What do I ask for?"

**On symptoms beyond bleeding:**
- "I want to see if my missing periods line up with stress, travel, under-eating, or over-training."
- "Are the hot flashes / the acne / the fatigue connected to my cycles or separate?"

**Top recurring questions Femio must answer in-product:**
1. Is my irregularity within "normal variation," or is it the kind worth checking?
2. What are the possible causes of irregular/absent periods, and how do they differ?
3. When exactly should absent periods prompt a clinician visit (the ~90-day flag, sudden change, other symptoms)?
4. Could this be pregnancy — and how do I rule that in/out first?
5. Which specialist and which tests fit which suspected cause?
6. How do I track this so the data is actually useful to a doctor?

---

## C. Competitor teardown

Feature-by-feature, focused on where general trackers fail the *undiagnosed irregular-cycle* user specifically — the person the apps are, by their makers' own admission, worst at.

| App | Model | Irregular/undiagnosed handling | Prediction honesty | Causes education | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | Has an "irregular" toggle, but core UX still centers a predicted cycle + fertile window; funnels toward TTC/pregnancy framing on any gap | Low for irregular cycles — models trained on ~28-day cycles; still shows confident dates and a "days late" counter | Thin on the *differential* of causes; nudges toward pregnancy | **FTC settlement (2021) for sharing period/pregnancy data with Facebook/Google; ~$56M class settlement (2025)** — trust damage | Uncertainty-first UI, no "late" counter, non-TTC default, causes-differential education |
| **Clue** | Freemium, science-forward | Adapts to variable cycle length better than most; still surfaces a predicted period/fertile window | More conservative than Flo but still degrades badly on highly irregular/absent cycles; can't predict a cycle that isn't coming | Good general cycle science; not organized as "why might mine be irregular" | Better EU/GDPR posture | Diagnostic-crossroads framing + referenced causes library + Arabic-first/RTL + clinician-routing |
| **Ovia** | Freemium, health-plan tie-ins | Cycle + health tracking; strongly fertility/pregnancy-oriented | Standard confident predictions | Limited | Employer/health-plan data model raises concerns | Non-TTC, non-employer, privacy-first, honest uncertainty |
| **Stardust** | Privacy-forward, local-first | Tracks flow/symptoms; de-emphasizes hard predictions (good) | Low prediction emphasis, but astrology framing dilutes clinical trust | Minimal clinical causes content | **Strong: local storage, privacy-forward** | Clinical credibility + referenced causes content + when-to-see-a-clinician thresholds |
| **Natural Cycles** | Paid, FDA-cleared birth-control | Explicitly requires *regular-ish* data; struggles with irregular; not a fit for undiagnosed absent cycles | Honest that it's not for everyone, but it's a contraception product, not education | N/A | Regulated device | Femio is education/tracking, *not* contraception; serves exactly the users NC excludes |
| **Generic symptom-checker sites** | Ad-driven articles | List causes but no personal tracking, no pattern insight | N/A | Broad but overwhelming ("ten conditions") and anxiety-inducing | Ad-tracked | Personalized pattern + calm, ordered differential + no ad-SDK |

**Cross-cutting failure — the exact B5 gap.** Every general tracker is a *prediction* product first. Their own field admits accuracy collapses on irregular cycles — only a small minority of users say their app "always" gets the date right, and predictions are more likely to run *late* than early, precisely for the people who most need help. For an **undiagnosed** irregular-cycle user the failure compounds: the app is not only wrong, it (a) invents a "late" status that is meaningless for her, (b) funnels her toward a pregnancy/TTC narrative on every gap, and (c) offers no map of *why* her cycles do this or *when* it's worth a clinician. Femio's answer: **uncertainty-first UI with no "late" counter + a calm causes-differential + explicit clinician-routing thresholds.**

---

## D. Clinical grounding (cited)

> Framing: everything below is presented in-product as **wellness education + screening + "discuss with your clinician."** Femio never tells Noor which cause is hers.

**What counts as irregular / absent.**
- Normal adult cycle length is **~21–35 days**; individual cycles can vary and still be "regular" — within a year the gap between a woman's shortest and longest cycle can be up to ~7–9 days and remain in the normal range (FIGO frames normal variation as roughly ±4 days around her average). So *some* variation is expected and not a problem [ACOG — Abnormal Uterine Bleeding; Clue/FIGO summary].
- **Oligomenorrhea** = infrequent periods, typically cycles **>35 days apart** [Cleveland Clinic; StatPearls].
- **Amenorrhea (secondary)** = no periods for **≥3 months** in someone who previously had regular cycles, or **≥6 months** in someone with previously irregular cycles [MSD Manual; StatPearls; ASRM 2024].

**The ~90-day flag (the key educational threshold).** The 95th percentile for cycle length is about **3 months / 90 days**; it is statistically uncommon to go beyond that, and **≥3 months without a period warrants evaluation** [ACOG — Menstrual Cycle as a Vital Sign]. Tier-1 patient guidance echoes this: contact a provider if you've **missed a period for three or more months** (or 3 consecutive missed periods) [MedlinePlus; Cleveland Clinic; NICHD]. Femio uses ~90 days as an *awareness/routing* prompt, never a diagnosis.

**Menstrual cycle as a "vital sign."** ACOG frames menstrual pattern as a health indicator to be monitored over time — which is exactly the reframe B5 needs: her pattern is *data worth tracking*, not a broken prediction [ACOG — Menstrual Cycle as a Vital Sign].

**The differential — the many causes (education, ordered, non-diagnostic).** Irregular or absent cycles are a *symptom with many possible causes*, not a diagnosis. Common ones taught in Tier-1/Tier-2 sources:
- **Pregnancy** — the most common cause of a suddenly missed period; rule-in/out first [MedlinePlus; MSD Manual].
- **PCOS** — a very common cause of chronic irregular/anovulatory cycles + hyperandrogenism signs → *routes to B6* [MedlinePlus; MSD Manual].
- **Thyroid disease** (hypo- or hyperthyroidism) — can disrupt cycles → *routes to B17/thyroid modifier* [MedlinePlus; MSD Manual].
- **Functional hypothalamic amenorrhea (FHA)** — chronic anovulation from stress, weight loss, low energy availability, and/or excessive exercise; a diagnosis of *exclusion* needing history + work-up; carries bone/cardiovascular/fertility implications → *routes to B16/HA* [Endocrine Society FHA Guideline 2017, JCEM].
- **Perimenopause** — in the 40s (sometimes late 30s), changing/irregular cycles are often the *first* sign of the menopausal transition; cycle length can vary by 7+ days → *routes to F1* [ACOG; Cleveland Clinic; Menopause Society].
- **Primary ovarian insufficiency (POI)** — ovaries under-function **before age 40**; first sign is usually irregular/missed periods; evaluated if periods are absent/abnormal under 40 → *routes to clinician / POI education* [MedlinePlus; NICHD].
- **Other** — high prolactin, medications/hormonal contraception (incl. post-Depo delay), significant illness/stress, breastfeeding, structural causes (e.g., Asherman's) [MedlinePlus; MSD Manual; Cleveland Clinic].

**What a work-up typically looks like (visit-prep education, not instruction).** History (diet, exercise, weight change, stress, mood, meds, cycle history) + exam + labs commonly including a **pregnancy test, FSH, LH, TSH/thyroid, prolactin**, and — depending on the suspected cause — androgens/AMH or pelvic ultrasound. FHA and PCOS are both **diagnoses of exclusion** [AFP amenorrhea approach; Endocrine Society FHA Guideline; MSD Manual]. Femio explains this so Noor can advocate; it never orders, interprets, or diagnoses.

**Why tracking matters even without a diagnosis.** A documented pattern (cycle lengths, gaps, symptom co-occurrence, weight/exercise/stress context) is precisely what shortens and sharpens an evaluation and helps a clinician tell "normal-for-her" from a change worth investigating [ACOG vital-sign framing].

*Public-copy decision:* Femio publishes no numerical competitor/tracker-accuracy claim. The clinician-review prompt follows ASRM 2024: more than 3 months without menses after previously regular cycles, or 6 months after previously irregular cycles, requires investigation; pregnancy should be considered sooner where possible. This is a conversation prompt, not a diagnosis. ([ASRM 2024](https://www.asrm.org/practice-guidance/practice-committee-documents/current-evaluation-of-amenorrhea/); reviewed Mohamed K., 23 July 2026.)

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Irregular-cycle mode (undiagnosed variant)** — set at onboarding; disables 28-day assumptions, **never labels her "late,"** models cycle length as a personal range, and *does not assume a cause*.
2. **Uncertainty-first prediction UI** — see §G/§I. Show pattern + a wide **range with confidence band** and plain-language honesty ("Your cycles vary a lot — this is a rough window, not a date"). **No "days late" counter, ever.** When no cycle is reasonably predictable, degrade gracefully to "we can't predict this one — that's expected for your pattern."
3. **Causes-differential education hub ("Why might my cycles be irregular?")** — the ordered, calm, non-diagnostic map of PCOS / thyroid / stress-FHA / perimenopause / pregnancy / POI / other, each with "signs that point here" and "what a clinician would check" — explicitly *not* a diagnosis engine.
4. **When-to-check-in awareness (the ~90-day flag)** — non-alarming prompt at prolonged amenorrhea, plus "sudden change / new symptoms" guidance, all screening-framed and citing the vital-sign concept.
5. **"Could this be pregnancy?" first-step helper** — calm, neutral: for a suddenly-missed period, surfaces "pregnancy is the most common cause of a suddenly missed period — a test rules it in or out" before any disease content. Educational, never a nudge toward TTC.
6. **Non-TTC default** — no "trying to conceive?" nudges; TTC/pregnancy reachable but never assumed.
7. **Specialist-visit prep pack** — exportable/printable summary (cycle-length history + gaps, symptom/context trends, "questions to ask," and a standard-work-up checklist she can bring).
8. **Privacy-by-design** — local-first where possible, no ad-SDK sharing, clear controls; addresses post-Flo distrust.

**P1 — strong differentiators.**
9. Referenced, medically-reviewed causes/education library (Arabic-first + EN/FR/ES).
10. Symptom-and-context tracking: bleeding + mood, energy, stress, sleep, weight (optional), exercise load, hot flashes, skin/hair — logged and viewed *together* to reveal correlations (e.g., gaps clustering with high-stress/low-intake months → FHA-relevant context, framed as pattern, not diagnosis).
11. Mental-health / anxiety support module (screening + coping), because "not knowing why" is itself the stressor.
12. Gentle "narrow it down with your clinician" routing that *offers* the matching persona lane (B6/B17/B16/F1) when signals cluster — always as an offer, never a verdict.

**P2 — depth / retention.**
13. Trend correlations ("your longer gaps appear alongside your high-stress and low-sleep logs") — descriptive pattern insight only.
14. User-entered lab tracker (TSH, FSH, LH, prolactin, androgens, AMH, hCG) — entry only, no interpretation.
15. Cycle-history "story" view she can screenshot for a visit.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **What "irregular" actually means** — normal cycle range (~21–35 days), how much variation is normal (±~4 days / up to ~7–9-day spread), and where "irregular" begins. Reframes her pattern as trackable data, not a defect.
2. **Why my cycles might be irregular — the big picture** — the calm, ordered differential (PCOS, thyroid, stress/low-energy FHA, perimenopause, pregnancy, POI, other), each with "what points toward it" and "what a clinician checks." Explicitly non-diagnostic; every path ends in "discuss with a clinician."
3. **Could it be pregnancy?** — the most common cause of a suddenly missed period; how a test rules it in/out; neutral and non-TTC.
4. **When absent periods are worth a check-in** — the ~90-day flag, sudden change, and other red-flag symptoms; menstrual cycle as a vital sign.
5. **Stress, exercise, and under-fuelling (FHA basics)** — how low energy availability and stress can switch cycles off; why it matters for bones and long-term health; non-shaming.
6. **Thyroid and your cycle** — how thyroid over/under-activity disrupts periods; what a thyroid check involves.
7. **PCOS in one page** — the 2-of-3 picture and when irregular cycles + androgen signs point there (bridges to B6).
8. **Perimenopause and changing cycles** — for late-30s/40s: why cycles get unpredictable as the first sign of the transition (bridges to F1).
9. **Primary ovarian insufficiency (POI)** — irregular/absent periods before 40; why it's checked; distinct from menopause.
10. **Getting a real evaluation** — what a standard work-up looks like (pregnancy test, TSH, FSH/LH, prolactin, sometimes androgens/AMH/ultrasound), which specialist fits which suspicion, and how to advocate if dismissed.
11. **Tracking that helps your doctor** — what to log so your history is useful.
12. **Myths vs. evidence** — "it's just stress, ignore it," "irregular = infertile," "you're too young for menopause," "an app can tell you what's wrong."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Cycle/bleed log (flow, spotting; **cycle-length range view + gap counter framed neutrally**, never "late").
- Symptom + context log: mood, anxiety, energy, sleep, stress level, exercise load, appetite/intake context, hot flashes/night sweats, acne/hair, weight (optional/toggleable).
- Optional lab-entry (TSH, FSH, LH, prolactin, androgens, AMH, hCG); entry only.

**Tools**
- **Uncertainty-first predictor** — range + confidence band + plain caveat; graceful "can't predict this one — expected for your pattern" state. **No "days late" element.**
- **Causes-differential explorer** — interactive, calm map; each cause shows "points toward / clinician checks"; ends every branch in clinician routing. Not a diagnosis engine.
- **"Could this be pregnancy?" helper** — neutral first-step for a suddenly missed period.
- **Cycle-pattern insight** — descriptive trends/correlations ("appears associated with," never "caused by").
- **Visit-prep generator** — one-tap export/print: cycle history + gaps + symptom/context trends + questions + standard-work-up checklist + "which specialist" pointer.
- **Screeners (framed as screening, not diagnosis):**
  - Mood/anxiety screen (PHQ-2 / GAD-2 style) → "This is a screening tool, not a diagnosis. Consider discussing with a clinician." + crisis resources.
  - Irregular-cycle awareness checklist → surfaces which cause-lanes her signals touch, always as "signs to discuss — only a clinician can diagnose," and *offers* (never forces) the matching persona lane.

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL)**
- **Prolonged-amenorrhea awareness prompt (~90 days)** — "It's been about 3 months since your last logged period. Many clinicians suggest checking in around this point — here's why," citing the vital-sign concept; offers the "could this be pregnancy?" helper and visit-prep.
- **Sudden-change awareness** — if a markedly new pattern appears, gentle "a clear change is worth mentioning to a clinician."
- Optional log reminders that respect an irregular cadence — **never "your period is late."**
- Screening follow-up nudge (e.g., re-check mood in N weeks).
- **Never:** contraception / fertile-window "safe day" claims; never disease-prevention claims; never "you have PCOS / thyroid disease / POI."

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — see `09_MASTER_ADAPTATION_MODEL.md` §3)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, **irregular-cycle mode ON, cause = undetermined**).
- Cycle events: bleed start/end, flow, spotting; computed personal cycle-length range + variability + gap counter.
- Generic symptom log; mood/energy/sleep.

**Persona-specific (B5 — undiagnosed irregular/absent)**
- **Cause status = undetermined** (the defining B5 field) + free "what I've been told" note (e.g., "GP said stress").
- Context signals (self-report, non-diagnostic): stress level, exercise load, intake/appetite change, recent weight change, hot flashes/night sweats, androgen-type signs (acne/hirsutism), recent hormonal-contraception stop.
- **Prolonged-amenorrhea counter** (days since last bleed) driving the ~90-day awareness prompt.
- **Signal cluster hints** (non-diagnostic booleans that drive *offers* to B6/B17/B16/F1 lanes): androgen-signs, thyroid-symptom cluster, low-energy/stress cluster, age-40+/vasomotor cluster, under-40-menopausal-symptom cluster.
- User-entered labs (TSH, FSH, LH, prolactin, androgens, AMH, hCG) — entry only, no interpretation.
- TTC intent flag = **false** (drives non-TTC UX); reachable toggle.

*All health fields optional, encrypted, user-deletable; weight is explicitly not required to use the app.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B5):** (from `09` §4, Q2 "irregular-or-absent" path)
- Q: life stage → "tracking my cycle / general." Q: cycles regular / **irregular-or-absent** / a condition I know of → **irregular-or-absent** ⇒ set **irregular-cycle mode ON**.
- Q: "Do you already have a diagnosis or a known reason?" → **No / not sure** ⇒ **cause = undetermined ⇒ resolves to B5** (a "yes" routes to B6/B17/etc.).
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false; suppress fertile-window & pregnancy nudges.
- Q: top concerns / any of these signs? (multi-select: long gaps, skin/hair changes, feeling wired/tired or thyroid-type symptoms, high stress / hard training / eating changes, hot flashes or age 40+, appointment prep) ⇒ orders home modules **and seeds the non-diagnostic signal-cluster hints** used only to *offer* narrower lanes later.

**Home configuration (default for B5):**
- Hero = **cycle-length range + pattern view** with an uncertainty-first next-window estimate (band, not date). **No "late" counter.** When unpredictable: honest "can't predict this one" state.
- Pinned: causes-differential explorer, visit-prep, symptom/context log.
- Cards ordered by her concern selection (e.g., stress/energy module surfaced if she flagged hard training / eating changes).
- Fertile-window / pregnancy widgets **hidden by default**; "Could this be pregnancy?" helper available on demand and auto-offered on a *suddenly* missed period.

**Hidden-but-reachable principle:** Femio never removes knowledge. TTC guidance, pregnancy tracking, contraception education, PCOS/thyroid/perimenopause/POI deep content all remain **discoverable** via search and an "Explore other life stages / causes" entry — surfaced when relevant, never forced.

**Adaptive tuning (all *offers*, never verdicts):**
- Repeated 90+ day gaps ⇒ raise the ~90-day awareness prompt + visit-prep prominence.
- Signal cluster crosses a confidence threshold ⇒ **offer** the matching lane: "Some of what you're logging lines up with things people ask about PCOS / thyroid / stress-related cycle changes / perimenopause. Want education tailored to that? You can undo anytime." Below threshold ⇒ **blend** emphasis, commit to nothing (mirrors `09` §5 Z1 resolver behavior).
- Mood screens trend low ⇒ surface mental-health module + localized resources.

---

## J. Adaptation triggers (life-stage & diagnostic-crossroads routing)

> **Inherits all universal events** from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive pregnancy test → D-track carrying modifiers; pregnancy loss → E6 Gentle Mode; mood-screen high/crisis → resources; red-flag symptom → "seek care" content; disengagement → pause nudges; toggle-off → generic + preserve history; age-of-consent → re-confirm privacy). B5 adds the **diagnostic-crossroads** transitions below — its defining role as the bridge state. **Every transition requires explicit user confirmation, preserves data continuity, is reversible, and never locks her out of other content.**

| Trigger | System response | Route |
|---|---|---|
| **Androgen-sign cluster + chronic irregular/anovulatory pattern** (self-report: hirsutism/acne/scalp thinning) | *Offer* PCOS-tailored education + screening; keep irregular-cycle logic; never assert PCOS | **→ B6 (PCOS, non-TTC)** — additive layer |
| **Thyroid-symptom cluster** (self-report: weight/energy/heat-cold/heart-rate changes) or user-entered abnormal TSH | *Offer* thyroid-and-cycle education + visit-prep for a thyroid check | **→ B17 / thyroid modifier** |
| **Low-energy / stress / high-training cluster** (weight loss, under-fuelling, heavy exercise, high stress, absent periods) | *Offer* FHA-basics education (bone/long-term-health framing, non-shaming) + clinician routing; FHA is a diagnosis of exclusion | **→ B16 (hypothalamic amenorrhea education lane)** |
| **Age 40+ (or late-30s) + changing cycles ± vasomotor symptoms** | *Offer* perimenopause education; clarify perimenopause-vs-other overlap; keep irregular-cycle logic | **→ F1 (perimenopause)** |
| **Menopausal-type symptoms + absent/irregular periods under age 40** | Surface POI education framed as "worth a clinician's evaluation"; **prompt clinician check** (do not label) | **→ clinician routing + POI education**; stay B5 |
| **Suddenly missed period (was more regular) / pregnancy suspected** | Auto-offer "Could this be pregnancy?" helper first; neutral, non-TTC | Stays B5 until a positive test fires the universal **positive-pregnancy-test** handler → **D-track** |
| **Sets TTC intent = true** ("start trying") | Confirm; enable fertile-window features **with strong irregular-cycle uncertainty caveats**; surface fertility-with-irregular-cycles education | **→ C-track** (C1, or C6 if PCOS lane already offered) — additive TTC layer |
| **Prolonged amenorrhea (~90+ days, esp. recurring)** | Non-alarming clinician-check prompt (vital-sign framing) + "could this be pregnancy?" + visit-prep | Stay B5, raise screening prominence; escalate messaging if it persists |
| **User confirms a diagnosis from her clinician** | Retire "cause = undetermined"; carry all history into the confirmed lane unchanged | → the confirmed persona (B6/B17/F-track/etc.), data intact |
| **User toggles off irregular-cycle mode** | Revert to standard cycle logic; preserve all history | General reproductive-age band / Z1 |

The through-line: **B5 is a waypoint, not a destination.** Its whole job is to hold her calmly and usefully *while the cause is unknown*, then hand her — with her whole record intact — to the right lane the moment it clarifies (or keep her indefinitely in a rich, honest generic experience if it never does — a valid first-class state per `09` §5).

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **No-diagnosis discipline is heightened for B5.** Because the persona *is* an undiagnosed differential, the causes-differential explorer must never resolve to "you have X." It shows "signs that point toward / what a clinician checks," always ends in clinician routing, and only ever *offers* a tailored education lane — it never asserts a condition.
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs "You have PCOS / thyroid disease / POI / depression."
- **Predictions:** must display uncertainty; **no "days late" counter** in this persona; degrade to an honest "can't predict this one" state; never present a fertile/"safe" window as reliable for contraception (add explicit "not for contraception" note wherever ovulation/fertility appears).
- **The ~90-day flag** is framed as *educational awareness/routing* (menstrual-cycle-as-vital-sign), never a verdict or an alarm; verify exact 3-month vs 6-month wording per ACOG/ASRM before user-facing copy.
- **Pregnancy handling:** the "could this be pregnancy?" helper is neutral and non-TTC; a positive test uses the universal handler; a loss instantly triggers Gentle Mode per `09` §6.
- **Weight/body image:** weight fields optional and never required; no default weight-loss messaging; the FHA/low-energy content must be explicitly non-shaming (weight-stigma-aware).
- **Mental health:** "not knowing why" is a documented stressor here — crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** health data = special-category; explicit granular consent, purpose limitation, no ad-SDK/third-party sharing of cycle/health data (post-Flo trust); local-first where feasible; full export/delete. Data-mapping + DPIA required before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education keeps out of regulated-device territory — legal review before store submission.
- **Reviewed controls:** no public tracker-accuracy statistic; amenorrhea wording follows ASRM 2024; crisis routing follows the global maintained-directory policy. See [`docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md). *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH / NHS / MedlinePlus / OWH / gov):**
- [Absent menstrual periods — secondary | MedlinePlus (NIH)](https://medlineplus.gov/ency/article/001219.htm)
- [Absent menstrual periods — primary | MedlinePlus (NIH)](https://medlineplus.gov/ency/article/001218.htm)
- [Primary Ovarian Insufficiency (POI) | MedlinePlus (NIH)](https://medlineplus.gov/primaryovarianinsufficiency.html)
- [About Primary Ovarian Insufficiency (POI) | NICHD — NIH](https://www.nichd.nih.gov/health/topics/poi/conditioninfo)
- [Primary Ovarian Insufficiency fact sheet | NICHD — NIH](https://www.nichd.nih.gov/health/topics/factsheets/poi)
- [Amenorrhoea — NHS Lothian RefHelp (referral pathway)](https://apps.nhslothian.scot/refhelp/guidelines/gynaecology/amenorrhoea/)
- [Primary amenorrhoea pathway — North Central London ICB (NHS)](https://gps.northcentrallondon.icb.nhs.uk/cdn/serve/pathway-downloads/1497264919-df332699adff8570337aee9e762e687f.pdf)

**Clinical — Tier 2 (ACOG / RCOG / NICE / society / peer-reviewed):**
- [Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign — ACOG Committee Opinion (the ~90-day / 95th-percentile flag)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)
- [Amenorrhea: Absence of Periods — ACOG (patient FAQ)](https://www.acog.org/womens-health/faqs/amenorrhea-absence-of-periods)
- [Abnormal Uterine Bleeding — ACOG (normal cycle range)](https://www.acog.org/womens-health/faqs/abnormal-uterine-bleeding)
- [My Periods Have Changed. Is Menopause Around the Corner? — ACOG (perimenopause)](https://www.acog.org/womens-health/experts-and-stories/the-latest/my-periods-have-changed-is-menopause-around-the-corner)
- [Current Evaluation of Amenorrhea: a committee opinion (2024) — ASRM](https://www.asrm.org/practice-guidance/practice-committee-documents/current-evaluation-of-amenorrhea/)
- [Functional Hypothalamic Amenorrhea: An Endocrine Society Clinical Practice Guideline — JCEM (2017)](https://academic.oup.com/jcem/article/102/5/1413/3077281)
- [Endocrine Society — Hypothalamic Amenorrhea guideline resources](https://www.endocrine.org/clinical-practice-guidelines/hypothalamic-amenorrhea)
- [Amenorrhea: A Systematic Approach to Diagnosis and Management — AFP (work-up)](https://www.aafp.org/afp/2019/0701/p39)
- [Oligomenorrhea — StatPearls, NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK560575/)
- [Secondary Amenorrhea — StatPearls, NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK431055/)
- [Amenorrhea — MSD Manual Professional (definitions, differential)](https://www.msdmanuals.com/professional/gynecology-and-obstetrics/abnormal-uterine-bleeding/amenorrhea)
- [Oligomenorrhea — Cleveland Clinic](https://my.clevelandclinic.org/health/symptoms/22834-oligomenorrhea)
- [Amenorrhea — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/3924-amenorrhea)
- [Perimenopause — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/21608-perimenopause)
- [Perimenopause — The Menopause Society](https://menopause.org/patient-education/menopause-topics/perimenopause)
- [What's "normal"? Menstrual cycle length and variation — Clue (FIGO ±4-day framing)](https://helloclue.com/articles/cycle-a-z/what's-normal-menstrual-cycle-length-and-variation)

**Tracker accuracy / patient experience (why generic trackers fail irregular cycles):**
- [A survey of women's experiences of using period tracker applications: accuracy, feelings and behaviours — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC9047811/)
- [Period tracker applications: what menstrual cycle information are they giving women? — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8504278/)
- [Period tracking apps failing users in basic ways, study finds — UW News](https://www.washington.edu/news/2017/05/02/period-tracking-apps-failing-users-in-basic-ways-study-finds/)
- [Period-tracking apps get a failing grade: inaccurate and way too pink — STAT](https://www.statnews.com/2017/05/02/period-tracking-apps-flaws/)
- [Can I trust my period-tracking app? — The Conversation](https://theconversation.com/can-i-trust-my-period-tracking-app-heres-what-it-can-tell-you-and-what-to-watch-out-for-238422)
- [The Impact of Irregular Menstruation on Health: A Review — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10733621/)

**Competitor / app landscape:**
- [Flo — FTC action & class settlement context (see B6 spec sources)](https://www.ftc.gov/news-events/news/press-releases/2021/01/developer-popular-womens-fertility-tracking-app-settles-ftc-allegations-it-misled-consumers-about)
- [Clue — variable-cycle handling](https://helloclue.com/)
- [Stardust — privacy-forward cycle app](https://stardust.app/)
- [Natural Cycles — "a birth control app, not a period tracker" (excludes irregular users)](https://www.naturalcycles.com/cyclematters/a-birth-control-app-not-a-period-tracker)
