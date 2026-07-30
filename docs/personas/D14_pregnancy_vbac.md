# Persona D14 — Pregnant with Prior C-Section, Weighing VBAC vs Repeat/Elective Cesarean

Prepared: 2026-07-17 · Wave 3 · Status: research + spec
Layered on: `D1_pregnancy_uncomplicated.md` (base pregnancy spine) · resolves via `09_MASTER_ADAPTATION_MODEL.md`
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · 05_PRODUCT_STRATEGY_PLAN · femio-compliance-privacy · femio-medical-content skills
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Never recommend a birth mode. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners / calculators = "an estimate to discuss with your clinician."**

> **Inheritance note.** D14 is D1 **plus** a birth-decision layer. Everything in D1 (week-by-week home, referenced library, appointment/checklist tracker, symptom/mood log, weight-gain band, kick counter, contraction timer, red-flag safety layer, universal events, privacy-by-design) applies unchanged. This file specifies **only the D14-specific additions**: the birth-choice education + decision-support layer, the prior-cesarean EMR fields, the uterine-rupture-awareness red-flag additions, and the transitions unique to a woman deciding between VBAC (vaginal birth after cesarean) and a planned/elective repeat cesarean (ERCS). Non-directive by design: Femio **educates the tradeoffs and never steers toward a birth mode.**

---

## A. Persona snapshot

**Who she is.** A pregnant woman with **one (occasionally two) prior cesarean birth(s)**, now pregnant again and facing a preference-sensitive choice: attempt a **VBAC** (via a "trial of labour after cesarean," TOLAC) or plan an **elective repeat cesarean (ERCS)**. Medically she may otherwise be low-risk (a D1 course with this one added decision) or she may carry other modifiers (GDM→D3, HTN→D5/D6, AMA→D13, high BMI→D12) that stack on top. She is very often a **prior Femio user** whose account already holds a **prior-cesarean record** from a previous pregnancy's delivery log (E-track) or from her medical-history flags — that record is what routes her here.

**Core job.** "Help me understand my real options for how to give birth this time — the chances a VBAC works for someone like me, the risks of each path including uterine rupture, and what a repeat cesarean means for me and any future pregnancies — laid out honestly and evenly, so I can decide *with my provider*. Don't push me one way. Don't scare me. Then help me prepare for whichever I choose."

**Emotional arc (birth-choice thread layered over the D1 trimester arc).**
- **T1–early T2:** the decision surfaces early but is not urgent; appetite for orientation ("what even are my options?"), processing feelings about the first cesarean (some carry disappointment, trauma, or relief), and learning that this is a *choice* many people get to make.
- **T2:** active information-gathering — success likelihood, rupture risk in plain numbers, recovery differences, future-family-planning implications; discussing with her provider; often researching her hospital's VBAC support/policy.
- **T3 (birth-planning emphasis — the D14 spotlight):** consolidating the decision, birth-preference planning for *either* path, understanding what makes a hospital "VBAC-supportive," planning for the possibility that a planned VBAC becomes an unplanned cesarean, and heightened warning-sign vigilance (rupture awareness) if planning TOLAC.

**Context.** Web-first, mobile-heavy. Arabic-first / RTL primary with EN/AR/FR/ES. High emotional stakes and a strong desire for **non-judgmental, non-directive** information — this population is unusually sensitive to feeling pushed (by apps, forums, or even clinicians) toward one mode. Values a partner who can follow the same balanced material (X2 partner mode).

**Success = she feels she understands both paths evenly, does not feel steered, has her questions organized for her provider, and (whichever she chooses) arrives prepared** — with genuine red flags surfaced loudly and routed to care.

---

## B. Needs & questions (voice-of-user)

Synthesized from recurring questions in birth-choice communities and patient-information resources. The questions below are editorial paraphrases, not quotations or prevalence evidence; no individual social-media post is attributed.

**Orientation / "is this even an option for me?"**
- "I had a C-section last time — am I allowed to try for a vaginal birth, or do I have to have another cesarean?"
- "What's the difference between VBAC, TOLAC, and ERCS? Everyone uses different words."
- "My first was a cesarean for [breech / failure to progress / fetal distress] — does the reason matter for whether VBAC works?"

**Success likelihood (the dominant informational need)**
- "What are the actual odds a VBAC works for someone like me?"
- "Does a previous vaginal birth make it more likely to work?"
- "I saw a 'VBAC calculator' online — is that legit? Should I trust the number?"

**Uterine rupture (the dominant *fear*)**
- "How scared should I actually be of my scar rupturing? Give me the real number, not just 'it's rare.'"
- "What are the warning signs of a rupture — how would I even know?"
- "Does getting induced make rupture more likely?" (recurring, strong signal)

**Repeat cesarean tradeoffs & future family planning**
- "If I just do another C-section, what are the downsides — isn't the 'safe' option?"
- "I want more kids — does having a 3rd/4th cesarean matter for later?" (placenta accreta awareness)
- "How different is the recovery, honestly?"

**Non-directive / not-being-pushed (a defining frustration)**
- "My hospital is 'not VBAC-supportive' and I feel railroaded into a repeat section."
- "I feel judged for *wanting* a repeat cesarean — where's the balanced info?"
- "Every app/forum has an agenda. I just want the facts for BOTH so I can decide."

**Preparation (T3)**
- "How do I write a birth plan that covers *both* a VBAC and a switch to cesarean if needed?"
- "What questions should I ask my provider/hospital about their VBAC support?"
- "What happens if I go past my due date and I'm planning a VBAC?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Generic pregnancy apps treat everyone as a first-time vaginal birth — **no prior-cesarean awareness at all**, no birth-decision support.
- The information that *does* exist online is often **advocacy-skewed** (either VBAC-boosterism or cesarean-fear) rather than balanced.
- Standalone "VBAC calculators" spit out a number with **no context, no uncertainty, and no 'discuss with your clinician' framing** — and the widely used one historically **adjusted for race** (now removed), which erodes trust.
- Nowhere ties her **own prior-cesarean record** into the education (continuity-of-self gap).

---

## C. Competitor teardown

D14's differentiator is a category most competitors simply **do not have**: structured, balanced, non-directive **birth-decision support** for prior-cesarean pregnancies, tied to her own record.

| Capability | What to Expect | BabyCenter | Pregnancy+ | Ovia | Flo (preg) | VBAC-specific tools (VBAC Facts / EBB / MFMU calc) | **Femio D14** |
|---|---|---|---|---|---|---|---|
| Detects prior cesarean & adapts | No | No | No | Partial (logs history) | No | n/a | **Yes — routes from prior-cesarean record** |
| Balanced VBAC vs ERCS education | Articles, generic | Articles, generic | Minimal | Minimal | Minimal | **Deep but advocacy-leaning** | **Deep, cited, deliberately even-handed** |
| Uterine-rupture plain-number + warning signs | Buried | Buried | No | No | No | Yes (VBAC-leaning framing) | **Yes, both-sides, red-flag box** |
| Success-likelihood context | No | No | No | No | No | MFMU calculator (raw number) | **Educational estimate + uncertainty + "discuss with clinician," never a verdict** |
| Future-family-planning / accreta tradeoff | Rare | Rare | No | No | No | Yes | **Yes, cited, neutral** |
| Birth-plan builder covering *both* paths | Basic | Basic | No | Basic | No | n/a | **Yes — dual-path birth plan** |
| "Questions for your provider / is my hospital VBAC-supportive" | No | No | No | No | No | Yes (partisan) | **Yes, neutral checklist** |
| Non-directive stance (no steering) | Neutral-ish but ad-driven | Commercialized | n/a | n/a | n/a | **Explicitly pro-VBAC mission** | **Explicitly non-directive — core design rule (K)** |
| Privacy posture | Sells data | Sells data | Ad-SDK sharing | Employer-visibility concern | FTC-settlement history | Varies | **No data sale, no ad SDKs, no employer visibility** |

**The gap Femio exploits.** Generic apps ignore prior-cesarean status entirely; the good VBAC-specific content lives on **advocacy sites with a mission** (Evidence Based Birth, VBAC Facts — excellent evidence, but a pro-VBAC framing) or in a **decontextualized calculator**. No one offers **balanced, cited, non-directive, both-paths** education tied to the user's own record inside a privacy-safe pregnancy app. That is D14's whole reason to exist.

---

## D. Clinical grounding (cited)

All figures below are **education, not medical advice**; app copy must attribute to these bodies, present **both paths evenly**, and defer every decision to the user's clinician. Absolute risks of *both* TOLAC and ERCS are low — this must be stated up front.

**Terminology (teach it plainly).** **VBAC** = vaginal birth after cesarean (the *outcome* of a successful vaginal birth). **TOLAC** = trial of labour after cesarean (the *attempt*/planned labour). **ERCS / planned repeat cesarean** = choosing a scheduled cesarean instead. Femio uses "planned VBAC (trial of labour)" and "planned repeat cesarean" in user copy. [ACOG; RCOG GTG-45; NCBI StatPearls]

**VBAC success likelihood.** For women attempting a trial of labour after one prior cesarean, roughly **60–80% achieve a vaginal birth** (commonly cited ~72–75% for a straightforward pregnancy with spontaneous labour; one large synthesis ~73.6%). → App framing: a *range*, never a personal guarantee. [ACOG; RCOG GTG-45; NHS; NCBI StatPearls]

**Predictors of a higher chance of successful VBAC** (education, not scoring): **a prior vaginal birth or prior successful VBAC** (strongest positive), **spontaneous onset of labour**, a **non-recurring reason** for the first cesarean (e.g. breech), and factors such as maternal age < 40, BMI < 30, gestation < 40 weeks, and estimated fetal weight < 4 kg. Lower-chance factors: induced/augmented labour, age ≥ 35, BMI ≥ 30, birthweight > 4000 g, gestation > 40 weeks. → Present as "things that make VBAC more or less likely," **never** as a pass/fail score. [ACOG; RCOG GTG-45; PMC "antenatal predictors of success"]

**VBAC success calculators (handle with extreme care).** The MFMU (Maternal-Fetal Medicine Units) calculator estimates individual VBAC probability; ACOG's 2021 practice advisory addresses counselling and its use. The **2007 version included race/ethnicity and was found to propagate disparities; the 2021 revision removed race/ethnicity** (similar accuracy, AUC ~0.75). → **Femio does not run a calculator as a verdict.** If success-likelihood education is shown, it is framed as "an estimate clinicians use, based on factors like these — your provider can calculate and interpret it with you," always with uncertainty. This is the single most compliance-sensitive element of D14. [ACOG 2021 Practice Advisory; PMC race-neutral calculator validation]

**Uterine rupture — the key risk of planned VBAC (plain numbers, both-sides).** With **one prior low-transverse cesarean**, uterine rupture in a planned VBAC is roughly **0.2–1.5%, commonly cited ~1 in 200 (0.5%)**; more recent syntheses put it near **0.3–0.7%**. For comparison, an unscarred uterus is ~0.02% (2 in 10,000). Rupture is a serious emergency and is why TOLAC is recommended **where an emergency cesarean can be performed quickly.** Risk **increases with induction/augmentation (roughly 2–3× with induction), higher maternal age, greater gestation and fetal size, and a short interval (< 12 months) since the last birth.** → Red-flag layer (see G) teaches warning signs and "seek care now"; copy never says "your scar is fine." [ACOG; RCOG GTG-45; FIGO 2025; NHS]

**Repeat-cesarean tradeoffs & cumulative / future-pregnancy risk (present evenly).** A planned repeat cesarean avoids labour-related scar-rupture risk and permits planned timing, but it is surgery and some risks—including placenta accreta spectrum in a later pregnancy—increase with additional cesareans. Femio does not show a by-cesarean-number risk table or turn population estimates into an individual prediction. Because this is preference-sensitive, future family plans belong in a documented discussion with the maternity team, without the app recommending either route. ([RCOG patient information](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/birth-after-previous-caesarean/); [NICE NG192 §1.8](https://www.nice.org.uk/guidance/ng192/chapter/recommendations))

**Comparative outcomes (state as tradeoffs, not a winner).** Versus planned repeat cesarean, a successful VBAC generally means shorter recovery, less blood loss, fewer wound complications, and lower rates of some complications; a *failed* TOLAC ending in unplanned cesarean carries higher morbidity than a planned repeat cesarean. Both have low absolute risk. → The decision hinges on her values, history, and provider assessment — Femio's job is to make the tradeoffs legible. [RCOG GTG-45; PMC maternal morbidity/mortality; NHS]

**When VBAC is generally not offered / needs special counselling** (education, defer to clinician): e.g. prior **classical/high vertical uterine incision**, prior uterine rupture, certain prior uterine surgery, or **three or more prior cesareans** — these are situations where a clinician typically advises repeat cesarean. VBAC after **two** cesareans (VBAC-2) is offered by some services with counselling. → Femio presents these as "situations your clinician will weigh," never as an app determination. [RCOG GTG-45; NHS; PMC VBAC-2]

**Resolved source set.** Clinical wording is anchored to [RCOG Green-top Guideline 45](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/birth-after-previous-caesarean-birth-green-top-guideline-no-45/), its [patient information](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/birth-after-previous-caesarean/), and [NICE NG192 recommendations 1.8.1–1.8.5](https://www.nice.org.uk/guidance/ng192/chapter/recommendations). ACOG Practice Bulletin 205 is paywalled and is not used as the sole support for global patient copy. Community questions are unattributed paraphrases; the unsupported accreta-by-number table was removed. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**Inherits all D1 P0/P1/P2 features.** D14 **adds** the following on top.

**P0 — must-have (the D14 decision layer)**
1. **Birth-options education hub** — plain-language "your options this time" module: planned VBAC (trial of labour) vs planned repeat cesarean, terminology, and the up-front honesty that **both are reasonable, low-absolute-risk choices**. Non-directive by construction.
2. **Balanced tradeoff explainer** — even-handed, cited side-by-side of VBAC vs ERCS: success likelihood, uterine-rupture risk, recovery, and future-family-planning/accreta — **presented as tradeoffs, never a recommendation.**
3. **Uterine-rupture awareness + warning-signs red-flag layer** — what rupture is, plain-number risk, and the danger signs that mean "seek care now" (added to the D1 red-flag box for TOLAC-planning users).
4. **"Discuss with your clinician" decision-prep tool** — a neutral, editable question list she can bring to appointments (see G); captures her provider's guidance and her hospital's VBAC support as *her notes*.
5. **Prior-cesarean-aware EMR fields** (see H) seeding the layer from her record.

**P1 — high value**
6. **Dual-path birth-plan builder** — a birth-preferences tool that covers **both** a planned VBAC *and* a switch to cesarean if needed (the "plan for either" ask). Extends D1's P2 birth-plan builder.
7. **Success-likelihood *education* (not a calculator verdict)** — explains the factors clinicians weigh and that an estimate exists (MFMU), with heavy uncertainty framing and "your provider calculates and interprets this." **No standalone score output presented as a result.**
8. **"Is my hospital/provider VBAC-supportive?" neutral checklist** — questions to ask, logged as her notes; no directory, no recommendation.
9. **Partner/shared view (X2)** — both partners see the same balanced material.

**P2 — differentiators / later**
10. Decision-reflection worksheet (values-clarification style: "what matters to you — recovery, avoiding surgery, future pregnancies, scheduling, birth experience") — surfaces *her own* priorities, never outputs a recommendation.
11. Export (PDF) of her question list + birth plan + logged provider guidance for appointments.

**Explicitly out of scope (compliance):** any tool that **outputs a birth-mode recommendation**, ranks the options, or presents a VBAC-success percentage as a **verdict/result**; any "you are/aren't a VBAC candidate" auto-classification; any labour-management or induction guidance beyond "discuss with your clinician." (See K.)

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL). **Additive to all D1 modules.** Every module in this layer carries the **balanced, non-directive** tone as a hard requirement.

- **"Your birth options this time"** — orientation: VBAC / TOLAC / ERCS defined; the honest frame that both are reasonable and low-absolute-risk; that this is often a personal, values-based choice made with her provider.
- **"How likely is a VBAC to work?"** — the 60–80% range; the factors that raise/lower the chance (prior vaginal birth, spontaneous labour, reason for first cesarean, etc.); explains success calculators exist and their limits (incl. the race-variable history) — **no in-app verdict.**
- **"Understanding uterine rupture"** — what it is, plain-number risk (~1 in 200 range), what raises it (induction/augmentation, short interval, etc.), warning signs, and why VBAC is planned where emergency care is available. Paired with the red-flag box.
- **"What a repeat cesarean means"** — the surgery, recovery, its benefits (avoids labour rupture risk, scheduled), and **cumulative/future-pregnancy risks** including placenta accreta by cesarean number.
- **"VBAC vs repeat cesarean — the tradeoffs"** — the even side-by-side; explicitly states Femio does not recommend either.
- **"Thinking about future pregnancies"** — how family-planning goals factor in (accreta/previa/hysterectomy gradient), neutrally.
- **"Special situations your clinician will weigh"** — prior classical incision, prior rupture, ≥3 prior cesareans, VBAC-2 — framed as clinician-led.
- **"Preparing for either path"** — dual-path birth plan; what a VBAC-supportive setting looks like; planning for an unplanned cesarean; post-dates considerations when planning VBAC.
- **"Questions to ask your provider"** — the decision-prep checklist content.
- **"Processing your last birth"** — brief, gentle acknowledgement that feelings about a prior cesarean (disappointment, trauma, relief) are valid; soft pointer to emotional-wellbeing/EPDS screening ("screening, discuss with clinician") and D11 if needed.

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

**Inherits all D1 tools/logs/alerts.** D14 **adds**:

**Logs & tools**
- **Birth-decision prep list** — editable question set for her provider (e.g. "Am I a candidate for VBAC? What's your/hospital's VBAC support? What's my individual estimate and how did you get it? What would make you advise a repeat cesarean?"). Stored as *her notes*; exportable. **No app answers, no scoring.**
- **Dual-path birth plan** — preferences for a planned VBAC *and* a fallback cesarean; freeform + prompts.
- **Provider-guidance log** — where she records what her clinician advised and her hospital's stance (user-entered facts, not app interpretation).
- **Values-reflection worksheet (P2)** — surfaces her own priorities; outputs *her* reflections, never a recommendation.

**Alerts (all opt-in, calm, non-alarmist)**
- **T3 birth-planning nudges** — "It's a good time to finalize your birth preferences and questions for your provider" (~early T3). Non-directive wording.
- Inherited D1 milestone/appointment/content nudges.
- **No** "recommended birth mode," **no** VBAC-success push notification, **no** risk-scored alert.

**Red-flag box — D14 addition (uterine-rupture awareness, for TOLAC-planning users).** Extends the D1 "Seek care now" box:
> **⚠ Seek care now — signs to never ignore in labour after a previous cesarean**
> If you are planning or in a trial of labour after a cesarean, contact your maternity team or local emergency number immediately for: **sudden or severe, constant belly pain (especially between contractions)** · **pain over your cesarean scar** · **vaginal bleeding** · **a change in your baby's movements** · **feeling faint, a racing heart, or breathlessness** · **contractions that suddenly slow or stop with severe pain.** These can be signs of a problem with your scar and need urgent assessment.
> *You know your body best — if something feels wrong, get checked now. This app can't diagnose or treat, and can't tell you your scar is fine.*
> [Save my maternity/emergency contact] [Learn the warning signs]

Placement: persistent for users with a prior-cesarean record who are planning/considering VBAC; auto-injected on the "Understanding uterine rupture" and labour-signs modules.

---

## H. EMR fields (core vs persona-specific)

**Inherits all D1 core + D1 pregnancy fields.** D14 **adds**:

**Prior-cesarean / birth-decision fields (D14-specific)**
- **Prior cesarean flag + count** (1 / 2 / ≥3) — the primary router into D14 (carried from a prior E-track delivery log or history flags).
- **Prior uterine incision type** (low-transverse / classical-or-high-vertical / unknown) — user-entered; drives which education is foregrounded (classical → "clinician typically advises repeat cesarean"). Never an app determination.
- **Reason for prior cesarean** (recurring vs non-recurring, e.g. breech / failure to progress / fetal distress / maternal choice) — user-entered; education context only.
- **Prior vaginal birth / prior successful VBAC** (yes/no) — strongest success-likelihood context.
- **Interval since last birth** (derived from prior delivery date) — education on short-interval risk.
- **Current birth-choice intent** (considering / leaning VBAC / leaning repeat cesarean / decided-VBAC / decided-ERCS / undecided) — **user-set, freely changeable, never inferred or scored**; drives emphasis + which red-flag layer shows. Purely her stated preference.
- **Future-family-planning intent** (more children desired? yes/no/unsure) — optional; contextualizes the accreta/cumulative-risk education. Sensitive; optional.
- **Hospital/provider VBAC-support notes** — user-entered.
- **Birth-decision question list + dual-path birth plan state.**

Rule (inherited from adaptation model §3): every field is **surfaced or hidden, never destroyed.** If she switches intent or the layer is dropped, data is archived-but-reachable.

---

## I. Personalization rules (wizard → home config)

**Inherits D1 wizard + home logic.** D14 adds one wizard branch and a birth-planning home emphasis.

**Wizard additions (short, editable/resettable — personalize, never restrict).**
- On the D1 "Any conditions/history your clinician is watching?" step, **"I've had a cesarean before"** sets the prior-cesarean flag → offers the D14 birth-options layer. (For a returning Femio user, this is **auto-detected** from her prior delivery log — offered, confirmed, reversible.)
- Optional follow-ups (all skippable, all "I'm not sure" tolerant): how many prior cesareans; incision type if known; prior vaginal birth?; are you thinking about how you'd like to give birth this time? → sets **intent = considering/undecided** by default. **The wizard never asks in a way that implies a "right" answer.**

**Home configuration (gestational-age-driven, D14 overlay).**
- **T1–T2 home:** D1 development card **+** a calm "Your birth options this time" entry card (dismissible, reachable anytime) — orientation, not pressure.
- **T2 home:** foreground the **balanced tradeoff explainer** and **decision-prep question list**; success-likelihood *education*.
- **T3 home (birth-planning emphasis — the D14 spotlight):** foreground the **dual-path birth-plan builder**, the **"prepare for either path"** module, and — if intent is VBAC-leaning/decided — the **uterine-rupture warning-signs** red-flag layer prominently. Inherited kick counter / contraction timer surface as in D1.
- **Intent-driven emphasis, never restriction:** whichever way she is leaning, **both** paths' content stays equally reachable and equally weighted in the tradeoff module. Leaning VBAC surfaces the rupture warning-signs layer (safety); leaning repeat cesarean surfaces recovery + future-planning content. Changing intent re-layers instantly; nothing is hidden.

**Continuity.** Her **prior-cesarean record seeds the whole layer** — no re-entry; a one-time "we've carried your birth history; it's private" note. If she previously used Femio through a prior pregnancy/postpartum, that delivery record is the router.

---

## J. Adaptation triggers (state transitions)

**Inherits ALL universal events** from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive-test handler, pregnancy-loss handler, mood-screen-high, red-flag-symptom, disengagement, toggle-off, age-of-consent) and **all D1 pregnancy transitions**. D14 specifies only its **additions**:

**INTO D14:**
- **From D1 on a prior-cesarean record** — the primary edge. When a pregnancy account holds a prior-cesarean flag (from a previous E-track delivery log **or** history), Femio **offers** the birth-options layer: *"You've had a cesarean before. Want balanced info on your birth options this time? You can turn this off anytime."* Confirmed + reversible. This is **additive emphasis over D1**, not a new silo.
- **From C-track positive test** carrying a prior-cesarean history flag → lands in D1, then offers D14 as above.
- **Late surfacing:** if the prior-cesarean fact is entered mid-pregnancy, the layer is offered then.

**Within D14 (emphasis shifts, never restriction, never a recommendation):**
- **Birth-choice intent changes** (considering ↔ leaning VBAC ↔ leaning ERCS ↔ decided) — re-layer emphasis and which red-flag set shows; **both paths stay fully reachable and evenly weighted**; no nudge toward any option.
- **Stacked modifiers** blend normally (adaptation model §8): +GDM→D3, +HTN→D5/D6, +AMA→D13, +high BMI→D12, +prior loss→D2 tone, +multiples→D9. Union of safety layers; most-acute emphasis wins the hero (e.g. pre-eclampsia red-flags outrank birth-choice content in priority). A recorded **classical incision / prior rupture / ≥3 cesareans** foregrounds "clinician typically advises repeat cesarean" education — as *education*, never an app verdict.

**OUT of D14 (delivery / loss):**
- **Birth logged → Postpartum (E1)**, carrying the updated birth history (this delivery's mode + incision) into the record — which becomes the prior-cesarean router for any *future* pregnancy. If the course had complications or a cesarean with follow-up needs, carry to **E4**; breastfeeding → E2. **A planned VBAC that became an unplanned cesarean, or a successful VBAC, both simply update the delivery record** — no "failure" framing anywhere.
- **Pregnancy loss / stillbirth logged → E6 grief** via the universal handler: instant suppression of all pregnancy/birth-planning reminders (including the birth-decision layer), Gentle Mode, grief resources, data retained, gentle later path to D2 (PAL) if she conceives again.
- **Reset/withdraw:** she can drop the birth-options layer or exit pregnancy mode anytime; the prior-cesarean record is retained per her privacy settings and re-surfaces (offered) in a future pregnancy.

---

## K. Compliance flags

- **Non-directive decision support — the defining D14 rule.** Femio **educates the tradeoffs of VBAC and repeat cesarean and never recommends, ranks, scores, or steers toward a birth mode.** No tool outputs "you should do X," "you are a VBAC candidate," or a VBAC-success percentage as a **verdict/result**. Both paths are always presented **evenly, cited, and reachable**, regardless of her stated leaning. Every decision defers to "you and your clinician." This supports **informed choice without steering** and is a hard design/QA gate.
- **Success calculators = estimate, never a verdict.** Femio does **not** run a standalone VBAC calculator that outputs a result. Success-likelihood content is educational ("factors clinicians weigh; an estimate your provider can calculate and interpret with you"), always with uncertainty, and explicitly notes the MFMU calculator's history (2007 race variable → removed 2021) so users understand the limits.
- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention, no medical-device functionality. The birth-plan builder, question list, and reflection worksheet are **organizing/tracking aids**, explicitly not medical assessments of candidacy or safety.
- **Uterine-rupture / red-flag routing:** rupture and labour warning-signs content uses **"seek care now"** framing pointing to her provider / local emergency number; it **never reassures** ("your scar is fine") and **never diagnoses**. Plain-number risk is given for *both* paths honestly.
- **No dosing / no labour management:** induction, augmentation, and labour-management content is general and cited, deferring all decisions to the clinician (induction's effect on rupture risk is taught as awareness, never as guidance to accept/refuse).
- **Sensitive-topic tone:** no "failed VBAC" language; a planned-VBAC-turned-cesarean is neutral. Feelings about a prior cesarean are validated without pathologizing. No judgment toward *either* choice — this population is acutely sensitive to feeling pushed.
- **Privacy-by-design (GDPR/PDPL, health data):** prior-cesarean status, birth-choice intent, and future-family-planning intent are sensitive; minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility.** Future-family-planning field is optional. Partner sharing opt-in/granular. Loss/withdrawal → immediate reminder suppression + data-deletion honoring.
- **Content provenance:** every claim medically reviewed + cited Tier-1 (NIH/NHS/MedlinePlus) / Tier-2 (ACOG/RCOG/NICE/FIGO); review dates surfaced; balanced framing verified at review; no clickbait, no sponsored content.
- **i18n/RTL:** all safety/red-flag and decision-support copy human-reviewed in AR/EN/FR/ES given clinical + emotional stakes; the "non-directive" balance must be checked per-locale (advocacy connotations differ by language/culture).
- **Publication control:** the RCOG and NICE sources are pinned in §D. No unsourced community quotation, accreta-by-number table, or country-wide claim about VBAC availability is used. Warning signs route through [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md); facility capability and emergency destinations must come from an approved country module. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Tier-1 (NIH / NHS / MedlinePlus)**
- [NCBI StatPearls — Vaginal Birth After Cesarean Delivery](https://www.ncbi.nlm.nih.gov/books/NBK507844/)
- [NHS (NNUH) — Clinical Guideline: Management of Vaginal Birth after Caesarean (VBAC)](https://www.nnuh.nhs.uk/publication/download/vaginal-birth-after-caesarean-section-vbac-ao29-v9/)
- [NHS Cambridge University Hospitals — Birth after caesarean patient information](https://www.cuh.nhs.uk/patient-information/birth-after-caesarean-patient-information/)
- [NHS Bradford Teaching Hospitals — VBAC parent-education module](https://www.bradfordhospitals.nhs.uk/parent-education-modules/vbac/)
- [PMC (NIH) — Delivery After Prior Cesarean: Maternal Morbidity and Mortality (cumulative/accreta risk)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3428794/)
- [PMC (NIH) — VBAC: antenatal predictors of success](https://pmc.ncbi.nlm.nih.gov/articles/PMC7233729/)
- [PMC (NIH) — Prediction of VBAC: a calculator without race and ethnicity](https://pmc.ncbi.nlm.nih.gov/articles/PMC8611105/)
- [PubMed — Vaginal birth after two caesarean sections (VBAC-2)](https://pubmed.ncbi.nlm.nih.gov/19781046/)

**Tier-2 (ACOG / RCOG / NICE / FIGO)**
- [ACOG — Counseling Regarding Approach to Delivery After Cesarean and the Use of a VBAC Calculator (Practice Advisory, 2021)](https://www.acog.org/clinical/clinical-guidance/practice-advisory/articles/2021/12/counseling-regarding-approach-to-delivery-after-cesarean-and-the-use-of-a-vaginal-birth-after-cesarean-calculator)
- [RCOG — Birth After Previous Caesarean Birth (Green-top Guideline No. 45, 2015)](https://www.rcog.org.uk/media/kpkjwd5h/gtg_45.pdf)
- [FIGO — Good Practice Recommendations for Vaginal Birth After Cesarean Section (2025)](https://obgyn.onlinelibrary.wiley.com/doi/10.1002/ijgo.70406)
- [AJOG — TOLAC, VBAC, and the risk of uterine rupture: an expert review](https://www.ajog.org/article/S0002-9378(22)00840-7/fulltext)

**Supporting / community / competitor**
- [American Pregnancy Association — Vaginal Birth After Cesarean (VBAC)](https://americanpregnancy.org/healthy-pregnancy/labor-and-birth/vaginal-birth-after-cesarean/)
- [Cleveland Clinic — Vaginal Birth After Cesarean (VBAC): Facts, Safety & Risks](https://my.clevelandclinic.org/health/articles/21687-vaginal-birth-after-cesarean-vbac)
- [Evidence Based Birth — EBB 113: The Evidence on VBAC](https://evidencebasedbirth.com/ebb-113-the-evidence-on-vbac/)
- [VBAC Facts — Placenta problems after multiple repeat cesareans](https://vbacfacts.com/placenta-multiple-repeat-cesareans/)
- [PMC — Women's decision-making processes on mode of birth after previous caesarean (qualitative)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5773050/)
- [Boyes Turner — VBAC: risks of rupture and RCOG recommendations (plain-number summary)](https://www.boyesturnerclaims.com/news/vaginal-birth-after-caesarean-section-vbac-risks-rupture-and-rcog-recommendations)

*Source resolution: [RCOG Green-top Guideline 45](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/birth-after-previous-caesarean-birth-green-top-guideline-no-45/), [RCOG patient information](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/birth-after-previous-caesarean/), and [NICE NG192 §1.8](https://www.nice.org.uk/guidance/ng192/chapter/recommendations). Social questions are paraphrases and the unsupported accreta-by-number table is excluded. Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
