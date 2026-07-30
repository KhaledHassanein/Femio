# Persona D11 — Antenatal Depression and/or Anxiety (during pregnancy)

Prepared: 2026-07-17 · Wave 3 (condition layer over the pregnancy spine) · Status: research + spec
Layered on: **D1 (uncomplicated pregnancy)** · Distinct from: **E3 (postpartum mood/mental-health support)** · Inherits: `09_MASTER_ADAPTATION_MODEL` (seven invariants, state object, constant core, universal events, Z1 fallback, blending) · Companion skills: femio-compliance-privacy, femio-medical-content
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Femio never diagnoses, treats, or prevents. Screeners = "screening, discuss with your clinician." Any self-harm signal routes immediately to crisis resources. No diagnostic label, no medication dose, no "you have depression" is ever shown.**

> Sensitivity note (governs every line of this spec): perinatal mental health is a high-stakes, high-shame topic. Copy must be warm, non-judgemental, and free of both doom and toxic positivity. It must never imply a woman is failing her baby, never say "your baby is at risk because of your mood," and never reassure ("you're fine") in place of routing her to a human. Silence-over-risk on any ambiguous signal.

---

## A. Persona snapshot

**Who she is.** A pregnant woman (any trimester, singleton or otherwise) who is experiencing — or is at elevated risk of — **depression and/or anxiety during pregnancy** (antenatal / prenatal mood). She may have a prior history of depression or anxiety that has resurfaced, or she may be experiencing it for the first time in pregnancy. She is *still pregnant* — this is what separates her from E3 (postpartum). She is layered on the D1 pregnancy record: she still wants week-by-week content, appointments, and warning-sign safety, **plus** a private, judgement-free way to check on her mood and know what to do with the result.

**Why this persona exists.** Antenatal mood is common, under-detected, and badly served by existing apps. Roughly **1 in 5 women** experience a mental-health problem during pregnancy or the year after birth ([NHS](https://www.nhs.uk/pregnancy/mental-health-in-pregnancy-and-after-the-birth/mental-health/); [RCOG](https://www.rcog.org.uk/news/rcog-welcomes-rcm-perinatal-mental-health-roadmap/)). Yet pregnancy apps "track anxiety" with a slider and no support, coping content, or signposting ([JMIR review](https://www.jmir.org/2022/3/e31831)). Femio's wedge is a *validated screening + coping + crisis-safe* layer that stays inside the one-account pregnancy record.

**Core job.** "Let me check — privately and without judgement — whether what I'm feeling is more than normal pregnancy worry, tell me clearly what the result does and doesn't mean, give me real coping tools and honest information, and make it obvious how to reach a human — including right now if I'm in a dark place — without labelling me, scaring me, or selling my data."

**Emotional arc (layered over D1's trimesters).**
- **T1:** first-trimester overwhelm — nausea + fatigue + hormonal shift colliding with "I should be happy and I'm not," miscarriage-fear-driven anxiety, guilt/shame at not enjoying pregnancy, ambivalence about the pregnancy itself.
- **T2:** the "golden trimester" narrative can *deepen* isolation for someone who still feels low ("everyone says this is the good part"); rumination, intrusive worry about the baby, sleep disturbance separate from physical discomfort.
- **T3:** anticipatory anxiety about birth, health of the baby, becoming a parent; low mood compounded by insomnia and physical load; heightened need for a plan and for reassurance that help exists postpartum too.

**Context.** Web-first, mobile-heavy, often used privately at night. Arabic-first / RTL primary with EN/AR/FR/ES — trustworthy, non-stigmatising perinatal-mental-health content in Arabic is especially scarce, which sharpens Femio's differentiation and its duty of care.

**Success =** she feels *seen and not judged*; she understands a screen is a screen, not a verdict; she has coping content and a clear, warm path to professional help; and if she ever indicates thoughts of self-harm, crisis resources appear immediately and unmissably. The whole pregnancy record (D1) stays intact around her.

---

## B. Needs & questions (voice-of-user)

Synthesized from perinatal-mental-health communities (r/BabyBumps, r/PregnantAfterLoss, perinatal-anxiety and antenatal-depression threads), app-store reviews, and clinical coverage. Paraphrased/representative, not verbatim attributions.

**"Is this normal, or is it more than that?" (the dominant posture)**
- "I'm pregnant and I feel nothing but dread — everyone says this is supposed to be the happiest time. What's wrong with me?"
- "How do I tell the difference between normal pregnancy hormones/worry and actual depression or anxiety?"
- "I cry every day and I'm terrified something is wrong with the baby constantly. Is this an anxiety disorder?"
- "I don't feel connected to my pregnancy at all and I feel horribly guilty about it."

**Shame, isolation, and disclosure fear**
- "I'm scared that if I tell my midwife I feel this low, they'll think I'm an unfit mother / social services will get involved."
- "I can't say this out loud to anyone. I just need somewhere private to be honest about how I feel."
- "Will they force me onto medication? I don't want to harm the baby."

**Coping and "what do I actually do"**
- "What can I do *right now* when the anxiety spirals at 3am?"
- "Are there breathing / grounding techniques that are safe in pregnancy?"
- "Is therapy the only option? What actually helps antenatal depression?"

**Medication in pregnancy (high-anxiety, must stay educational)**
- "Is it safe to stay on my antidepressant while pregnant? I stopped cold turkey and now I'm worse."
- "My doctor and I are weighing medication — what are the trade-offs?" (→ Femio never advises dose; frames as "a decision to make with your clinician, who weighs the risks of untreated illness against medication.")

**"What happens if I say I've had dark thoughts?"**
- "If I admit I've thought about not being here, what happens?" (→ this is exactly the Q10 path: immediate, warm crisis resources; never punitive framing.)

**Cross-cutting frustrations with existing apps (design brief)**
- Apps that let you *log* anxiety on a slider but give "no further information, support, or signposting" ([JMIR](https://www.jmir.org/2022/3/e31831)).
- "No single app addresses depression, anxiety, stress and loneliness together" even though they co-occur ([mHealth systematic review](https://mhealth.amegroups.org/article/view/152947/html)).
- Cheery, milestone-heavy, fruit-of-the-week tone that makes a struggling woman feel *more* broken.
- Privacy dread — mental-health status is the most sensitive data she has; she fears it being sold, shared, or visible to an employer/partner.
- Crisis content that is absent, buried, or US-only (useless in MENA/other locales).

---

## C. Competitor teardown (antenatal mental-health support gaps)

Focus: where do pregnancy and femtech apps fail the *antenatal* mood user specifically — validated screening framed safely, coping content, and crisis routing.

| Product | Antenatal mood screening | Coping / intervention content | Crisis / self-harm routing | Framing & privacy | Gap Femio exploits |
|---|---|---|---|---|---|
| **What to Expect** | None structured; editorial articles only | Editorial coping tips; community threads | Generic "call your doctor," US-centric | Ad-supported; data-sale history (see D1 teardown) | No validated screen; anxiety content is editorial, not tracked or acted on; privacy scars |
| **BabyCenter** | None structured | Editorial + very large (variably moderated) forums | Minimal, generic | Data-broker scrutiny (D1) | Forum drama can *worsen* anxiety; no screening, no safe routing |
| **Pregnancy+ (Philips)** | None | Minimal wellbeing content | None prominent | Ad data-sharing history (D1) | Beautiful fetal visuals, essentially no mental-health layer |
| **Ovia Pregnancy** | Some mood content/checks; "Critical Alert" pattern on risky symptoms | Some coping content | Alert pattern exists but not a transparent EPDS/GAD-7 flow | Labcorp-owned; employer-sponsored data optics | Closest peer, but not a transparent validated-screen flow, not Arabic-first, privacy optics |
| **Flo (pregnancy mode)** | Some mental-wellbeing content | Some content; premium | Limited | FTC-settlement history; "Anonymous Mode" (D1) | Mental health shallow vs its cycle core; trust deficit |
| **Dedicated perinatal-MH apps (e.g. Powerly, Carea, "Fourth Trimester"-type)** | Some use PHQ/EPDS/GAD; research-stage | Stronger CBT/coping ethos | Varies | Often not integrated with a full pregnancy record; not Arabic-first; few RCT-validated ([PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12933385/)) | Strong on coping but **siloed** from the pregnancy record and cycle/postpartum continuity; not Arabic-first |

**Evidence of the gap (cited).**
- A maternity-professional review of pregnancy anxiety apps found information on anxiety was "limited to user input to track anxiety symptoms with no further information, support, or signposting available," and no resources to build coping strategies ([JMIR 2022](https://www.jmir.org/2022/3/e31831); [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8987965/)).
- A systematic review found **no single app** simultaneously addressed depression, anxiety, stress and loneliness despite their co-occurrence ([mHealth review](https://mhealth.amegroups.org/article/view/152947/html)).
- Most pregnancy apps "are rarely helpful in addressing mental health," and can "unintentionally increase stress or feelings of isolation" ([Carea](https://www.careaapp.com/blog/best-pregnancy-apps-for-anxiety-why-most-fall-short-and-how-carea-helps/)).
- Commercially available perinatal depression/anxiety apps are largely unvalidated by RCT ([PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12933385/)).

**Femio's differentiated position for D11.**
1. **Validated screening done honestly** — EPDS and GAD-7 offered *in pregnancy*, framed strictly as screening, with transparent, non-diagnostic result bands and mandatory Q10 self-harm routing — inside the pregnancy record, not a separate silo.
2. **Screening → coping → human**, not screening → dead end. Every result hands off to referenced coping content and a clear, warm route to professional help (self-referral options where they exist, e.g. NHS Talking Therapies).
3. **Crisis-safe by design** — localized crisis resources appear immediately on any self-harm signal; never buried, never US-only.
4. **Continuity** — the antenatal-mood layer flows forward into **E3 postpartum** mood support with history intact (the single most valuable continuity in perinatal mental health, since antenatal mood is the strongest predictor of postpartum mood).
5. **Privacy-by-design for the most sensitive data class** — no data sale, no ad SDKs, no employer/partner visibility unless explicitly and granularly shared; screening data is elevated-sensitivity.
6. **Arabic-first / RTL** non-stigmatising perinatal-mental-health content — a near-empty space.

---

## D. Clinical grounding (cited)

*All items are education/screening context for Femio content. Femio presents these as general information and screening prompts, never as diagnosis, and defers all treatment/medication decisions to the user's clinician.*

**Antenatal mood is common.** NIMH: as many as **18% of pregnant women experience depressive symptoms**, and **13–15% develop a major depressive episode** during pregnancy through the first three months postpartum; perinatal depression is "more than the baby blues" and is a treatable medical condition ([NIMH — Perinatal Depression](https://www.nimh.nih.gov/health/publications/perinatal-depression)). Meta-analytic estimates put depression prevalence at roughly **7.4% (T1), 12.8% (T2), 12.0% (T3)**, higher in low- and middle-income settings ([PMC systematic reviews](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8545620/)). Antenatal **anxiety** is at least as common — pooled prevalence estimates commonly cited at **~10–24%**, and mood–anxiety **comorbidity reaches ~40%** in the perinatal period ([BJPsych meta-analysis](https://www.cambridge.org/core/journals/the-british-journal-of-psychiatry/article/prevalence-of-antenatal-and-postnatal-anxiety-systematic-review-and-metaanalysis/9CF2AC0D36E9FF13A32022460FCBA7EE); [PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7079581/)). → App framing: "you are far from alone; these feelings are common and help works."

**Symptoms to help her recognise (education, not a checklist-to-diagnose).** Persistent sadness, anxiety, guilt or hopelessness; sleep and appetite changes beyond normal pregnancy; loss of enjoyment; difficulty concentrating; irritability/restlessness; feeling disconnected from the pregnancy; and thoughts of harming oneself ([NIMH](https://www.nimh.nih.gov/health/publications/perinatal-depression); [NHS — Mental health in pregnancy](https://www.nhs.uk/pregnancy/mental-health-in-pregnancy-and-after-the-birth/mental-health/)). Distinguishing normal pregnancy worry from a disorder is *exactly what a screen + clinician conversation is for* — Femio helps her have that conversation, it does not adjudicate it.

**Screening is recommended in pregnancy — for BOTH depression and anxiety.** ACOG's 2023 Clinical Practice Guideline recommends that all patients be screened for **depression and anxiety** using standardized, validated instruments **at the initial prenatal visit, later in pregnancy, and at postpartum visits** ([ACOG 2023 CPG](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2023/06/screening-and-diagnosis-of-mental-health-conditions-during-pregnancy-and-postpartum)). Anxiety is common perinatally and may precede depression — hence screening for both. → Femio surfaces screening *aligned to these touchpoints* as an educational prompt, never a mandate, always "screening — discuss with your clinician."

**EPDS is validated for use in pregnancy (not only postnatally).** The Edinburgh Postnatal Depression Scale is a 10-item self-report screen validated in antenatal as well as postnatal populations ([PMC antenatal validation](https://pmc.ncbi.nlm.nih.gov/articles/PMC3222089/); [Australian perinatal validation](https://pmc.ncbi.nlm.nih.gov/articles/PMC12569127/)).
- **Thresholds (screening, never labels):** Femio does not apply one universal diagnostic threshold. A configured health-system module may use its reviewed local protocol. As a cited example, NSW Health monitors/repeats scores of 10–12, arranges further assessment at 13 or more, and requires immediate further mental-health assessment for a positive Question 10 response, with urgent action if suicidal ideation is disclosed. Global copy shows the score without a diagnostic label and routes to clinician follow-up. ([NSW Health EPDS guidance](https://www.mhcs.health.nsw.gov.au/publications/epds/english); instrument rules in [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md); reviewed Mohamed K., 23 July 2026.)

**EPDS Question 10 — the self-harm item (mandatory safety rule).** Q10 asks about "the thought of harming myself," scored **Never = 0, Hardly ever = 1, Sometimes = 2, Yes, quite often = 3**. **Any non-zero answer (1, 2, or 3) requires immediate further evaluation** — it flags possible suicide risk and must be acted on **regardless of the total score** ([EPDS scoring guides — Black Dog Institute](https://www.blackdoginstitute.org.au/wp-content/uploads/2020/04/edinburgh-postnatal-depression-scale.pdf); [AAP scoring PDF](https://downloads.aap.org/AAP/PDF/Postnatal%20Depression%20Scale.pdf); [IPD meta-analysis on the self-harm item](https://www.nature.com/articles/s41598-023-29114-w)). → In Femio this is a hard rule: **Q10 ≥ 1 → immediate crisis-resource surface + warm urgent-care messaging, independent of total.** Suicide is a leading cause of maternal death through the perinatal year, which is why this can never be soft-pedalled ([RCOG](https://www.rcog.org.uk/news/rcog-welcomes-rcm-perinatal-mental-health-roadmap/)).

**GAD-7 for anxiety (educational screen).** The original validation study describes cut points of **5, 10, and 15**, with **10** a reasonable threshold for further evaluation. Femio uses screening framing and clinician follow-up, not a pregnancy-specific diagnostic cutoff. **GAD-7 has no self-harm item** and cannot be described as detecting suicide risk. GAD-7 and EPDS may be used only as complete, unmodified instruments with validated production-language versions and attribution under [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md). ([Spitzer et al., 2006](https://jamanetwork.com/journals/jamainternalmedicine/articlepdf/410326/ioi60000.pdf); [ACOG CPG 4, June 2023](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2023/06/screening-and-diagnosis-of-mental-health-conditions-during-pregnancy-and-postpartum); reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)

**Treatment framing (educational only — Femio never treats).** Guidelines favour **psychological therapy first-line for mild–moderate** antenatal depression/anxiety: NICE CG192 recommends facilitated self-help for subthreshold–moderate depression and **CBT for moderate–severe**, with assessment within 2 weeks of referral ([NICE CG192](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations)). NHS notes CBT helps and that a woman can **self-refer to NHS Talking Therapies** without a GP ([NHS — Mental health in pregnancy](https://www.nhs.uk/pregnancy/mental-health-in-pregnancy-and-after-the-birth/mental-health/)). **Medication decisions must be individualized with a clinician**, balancing the risks of *untreated* illness against medication exposure — Femio presents this trade-off as a *conversation to have with her clinician*, never a recommendation, never a dose, and never advises stopping/continuing a medication ([RCOG good-practice guidance](https://www.rcog.org.uk/media/4gikqggv/managementwomenmentalhealthgoodpractice14.pdf); [NICE CG192](https://www.nice.org.uk/guidance/cg192)).

**Non-judgemental disclosure matters clinically.** RCOG advises women be **asked sensitively** at booking about mental-health history, self-harm, abuse, and support, because stigma suppresses disclosure ([RCOG good-practice](https://www.rcog.org.uk/media/4gikqggv/managementwomenmentalhealthgoodpractice14.pdf)). → Femio's tone and privacy posture are not just UX niceties; they are the mechanism that makes honest self-report — and therefore safe routing — possible.

*Resolved source set:* global EPDS/GAD-7 presentation and instrument terms follow [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md); CBT/self-help wording links to [NICE CG192 recommendations](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations); crisis routing follows [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). *(Reviewed Mohamed K., 23 July 2026.)*

---

## E. Feature set (prioritized)

D11 **inherits the entire D1 feature set** (week-by-week home, referenced library, appointments/checklists, weight guidance, warning-signs safety layer, kick counter/contraction timer in T3). It **adds** a mental-health layer:

**P0 — must ship (safety + core wedge)**
1. **Antenatal mood-screening tool (EPDS in pregnancy; optional GAD-7)** — compliant framing, transparent non-diagnostic result bands, **mandatory Q10 self-harm routing**, offered aligned to ACOG touchpoints (booking / later pregnancy) as an *opt-in* prompt, never forced.
2. **Crisis-resource surface** — localized, always reachable, and auto-surfaced on any self-harm signal or high screen; warm, non-punitive, never US-only.
3. **Screening → support handoff** — every result routes to referenced coping content and a clear "how to reach help" path (self-referral options where they exist), plus "discuss this result with your clinician" language.
4. **Antenatal mental-wellbeing content hub** (see F) — coping/self-help, "normal worry vs when to seek support," medication-in-pregnancy *educational* explainer, and reassurance/de-stigmatising content.
5. **Private mood/thoughts log** — lightweight daily check-in (continuous with cycle-era mood log), elevated-sensitivity privacy handling.

**P1 — high value**
6. **Coping toolkit** — pregnancy-safe grounding/breathing/relaxation exercises, CBT-informed *educational* self-help (framed as general wellbeing, not therapy), sleep-and-worry content; "for 3am" quick-access set.
7. **Gentle screening re-check cadence** — optional, opt-in reminders aligned to trimester touchpoints; never nagging; suppressible.
8. **Support-plan / "who I can talk to"** — user-saved clinician, perinatal-MH service, trusted person, crisis line — as *her* saved contacts (education, not triage).
9. **Continuity bridge to E3** — carry antenatal mood history + screening trend forward to postpartum.

**P2 — enrichment / later**
10. Partner/support-person share (privacy-gated, opt-in, revocable) — so a partner can *support* without surveilling.
11. Export (PDF) of mood/screening trend for her to bring to an appointment (her data, her choice).
12. Curated, moderated peer support — **only** if moderation quality and safety are guaranteed (unmoderated forums can worsen anxiety).

**Explicitly out of scope (compliance)**
- Any diagnosis or "you have antenatal depression/anxiety" labelling.
- Any medication recommendation, dose, or "safe to take / stop" advice.
- Any claim to *treat* or *prevent* depression/anxiety; coping content is general wellbeing education, not therapy.
- Any automated "risk score" presented as a clinical judgement.
- Storing/sharing screening data without explicit, granular consent.

---

## F. Content modules (medically-reviewed, referenced, grade 6–8, EN/AR/FR/ES, RTL)

1. **Your emotions in pregnancy — what's common, and what deserves support.** Normalises low mood/worry; explains that ~1 in 5 women experience perinatal mental-health difficulties; distinguishes "normal pregnancy worry" from signs worth discussing — framed as *reasons to talk to someone*, never self-diagnosis. ([NHS](https://www.nhs.uk/pregnancy/mental-health-in-pregnancy-and-after-the-birth/mental-health/); [NIMH](https://www.nimh.nih.gov/health/publications/perinatal-depression))
2. **What a screening questionnaire is (and isn't).** Plain-language explainer of EPDS/GAD-7: a conversation-starter, not a diagnosis; why Q10 matters; what a "higher score" does and doesn't mean.
3. **Coping toolkit (general wellbeing, pregnancy-safe).** Grounding, breathing, relaxation, worry-time, sleep hygiene, gentle movement; CBT-informed self-help *education* framed as wellbeing, with "this isn't a substitute for therapy or care." (NICE favours self-help/CBT — presented as *what care can offer*, [NICE CG192](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations).)
4. **Getting help — your options.** Talking therapies/CBT; how to raise it with a midwife/GP; self-referral routes where they exist (e.g. NHS Talking Therapies); what a perinatal mental-health service does. Reassures that asking for help is safe and does not mean losing her baby. ([NHS](https://www.nhs.uk/pregnancy/mental-health-in-pregnancy-and-after-the-birth/mental-health/))
5. **Medication in pregnancy — how the decision is made (educational).** Explains that this is an *individualized clinician decision* weighing untreated illness vs medication; never advises starting, stopping, or dosing; explicitly warns against stopping medication abruptly *without* clinician input. ([RCOG](https://www.rcog.org.uk/media/4gikqggv/managementwomenmentalhealthgoodpractice14.pdf))
6. **When to seek help now — crisis & self-harm.** Always-reachable module with localized crisis lines and "if you are thinking of harming yourself, reach out now" framing; warm, non-judgemental. (See G/K.)
7. **Anxiety-specific content.** Intrusive worry about the baby, health anxiety, birth anxiety; grounding for spirals; when anxiety is more than normal.
8. **Continuity note.** "Your pregnancy record is all here, and this is private." Explains sensitive-data handling and how mood history carries forward to postpartum support (E3).

*Every module: medically-reviewed, cited, dated, reviewer + review-date shown; human-reviewed AR/EN/FR/ES with Arabic-first/RTL — machine-only translation is not acceptable for mental-health/crisis copy.*

---

## G. Tools, logs & alerts (compliant framing; screening + crisis routing)

**Mood/wellbeing log (private, sensitive).**
- Lightweight daily one-tap check-in (mood, sleep, worry), continuous with the cycle-era mood log. Educational self-tracking only — no risk score presented as a medical judgement. Elevated-sensitivity storage; consent-gated.

**Antenatal screening tool — EPDS (in pregnancy) + optional GAD-7.**
- **Intro copy:** *"This is a short screening questionnaire — not a diagnosis. Your answers can help you and your clinician talk about how you've been feeling. There are no right or wrong answers."*
- **Result copy:** scores shown as **neutral ranges/bands, never labels.** Higher bands prompt *"It may help to discuss how you're feeling with your midwife, GP, or clinician — the sooner you talk to someone, the sooner you can get the right support."* Never "you have depression/anxiety." Always notes thresholds vary and only a clinician can assess.
- **Offered, not forced:** surfaced as an optional prompt aligned to ACOG touchpoints (early pregnancy, later pregnancy); fully skippable and suppressible.
- **Consent:** no storage or sharing of screening results without explicit consent; partner sharing (if any) is opt-in, scoped, revocable, and *excludes* screening/self-harm data by default.

**EPDS Q10 — self-harm safety rule (hard, non-negotiable).**
- **Any non-zero answer to Q10 (Hardly ever / Sometimes / Yes, quite often) → immediately surface the crisis-resource screen + warm urgent-care messaging, regardless of total score.** The flow does not wait for the total, does not minimise, and does not reassure ("you're fine"). It routes to a human.
- Q10 crisis copy (pattern):
  > **You don't have to face this alone — help is available right now.**
  > You answered that you've had thoughts of harming yourself. That takes courage to acknowledge, and support is available.
  > • If you are in immediate danger, contact your local emergency number now.
  > • [Localized crisis line — auto-selected by locale] — free, confidential, available now.
  > • Reach out to your midwife, GP, or maternity team today — they will listen without judgement.
  > [Show my saved crisis/clinician contacts] [Local crisis resources]
  > *Femio can't provide medical or crisis care, but these people can. You and your baby matter.*
- **Locale-aware:** use the reviewed global routing and explicit country selector in [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). Never infer country from language and never use a US-only fallback. Named national and maternal-support services may appear only in country-specific content after their availability and service description are re-verified. ([WHO, 18 September 2024](https://www.who.int/news-room/questions-and-answers/item/suicide); reviewed Mohamed K., 23 July 2026.)
- Screening data + Q10 flag receive elevated privacy handling (femio-compliance-privacy).

**High-score routing (below Q10 severity).**
- A high EPDS/GAD-7 band (without Q10 signal) surfaces the mental-health support module, "discuss with your clinician," coping content, and help-options — supportively, never alarmingly, never diagnostically.

**Alerts (all opt-in, calm, suppressible).**
- Optional gentle screening re-check aligned to trimester touchpoints; content nudges to coping tools. **No** "you seem depressed" pushes, **no** predictive/diagnostic alerts, **no** streak-shaming on mood logging.

**Inherited D1 red-flag box** still applies for physical warning signs; its "thoughts of harming yourself" line links directly into the crisis surface above.

---

## H. EMR fields (core vs persona-specific)

**Core lifespan fields (shared, carried in):** identity/locale/RTL, age/DOB, consent & data-sharing flags, reproductive history, chronic conditions, medications/allergies, cycle history, prior pregnancies/outcomes, saved clinician/emergency contact. **All D1 pregnancy fields** (EDD/gestational age, prenatal visit log, etc.) remain active — D11 is additive.

**D11 persona-specific fields (all elevated-sensitivity, consent-gated).**
- **Mental-health history flags** (self-reported: prior depression/anxiety, prior perinatal MH difficulty, current/prior treatment) — routing/emphasis only, never a diagnosis.
- **Screening results:** EPDS score + date + **per-item store of Q10** (self-harm flag); optional GAD-7 score + date. Stored as timestamped, non-diagnostic screener results.
- **Q10 self-harm flag** (boolean + timestamp) — triggers crisis routing; highest-sensitivity handling.
- **Mood/worry/sleep log series.**
- **Coping-tool usage** (optional, for surfacing "what's helped you before").
- **Support plan:** saved clinician, perinatal-MH service, trusted person, crisis line (user-entered).
- **Medication-for-mood flag** (educational context only — presence/absence, never dose guidance).
- **Screening cadence preferences** (opt-in reminders on/off).

*Sensitive fields (screening results, Q10, mood, MH history) are the highest-sensitivity data class in Femio; consent for any storage/sharing is explicit and granular, and excluded from partner sharing by default.*

---

## I. Personalization rules (wizard → home config)

**Entry (offered, reversible — personalize, never restrict).** D11 is a **layer over D1**, entered when:
- In the D1 wizard, "Any conditions your clinician is watching / anything on your mind?" includes low mood, anxiety, or a mental-health history; **or**
- She opts into a mood screen from D1's "Emotional wellbeing" module; **or**
- Repeated low-mood logs or an elevated screen surface an *offer*: *"Would you like Femio to bring supportive mental-wellbeing content forward? You can turn this off anytime."*

Entry is always **offered and confirmed**, never auto-forced, and fully reversible. Nothing in D1 is removed.

**Home configuration (gestational-age-driven, mood-layer added).**
- Keeps the D1 week-by-week hero, appointments, and warning-signs safety layer.
- **Adds** a calm, non-alarming "How are you feeling?" entry point to the mood check-in + coping toolkit, and foregrounds the antenatal mental-wellbeing hub.
- **Tone shifts** to extra-gentle: no "golden trimester" toxic-positivity framing; celebratory milestone cards are softened and can be dialled down.
- **Trimester emphasis:** T1 — normalising overwhelm + first screening touchpoint offer; T2 — counter the "you should be glowing" narrative, coping tools; T3 — birth-anxiety content + a *forward look to postpartum support (E3)*, "help continues after birth."

**Hidden-but-reachable.** All coping tools, screens, and crisis resources are always reachable via library/tools/search regardless of state; crisis resources are *persistently* reachable (never gated behind a screen result).

**Continuity.** Cycle/TTC/D1 history seeds personalization; mood history and screening trend are retained and **carry forward into E3 postpartum** — the clinically important bridge, since antenatal mood is the strongest predictor of postpartum mood.

---

## J. Adaptation triggers (state transitions)

D11 **inherits all universal events** from `09_MASTER_ADAPTATION_MODEL §6` — notably: **Mood screen high / crisis flag** (surface mental-health module + localized crisis resources; screening framing; **EPDS Q10 non-zero → immediate crisis path regardless of total**), **Red-flag symptom**, **Pregnancy loss** (instant milestone suppression + grief resources → E6), **Disengagement / "taking a break"** (pause nudges, keep data), and **Toggle mode off**. Only **D11-specific** transitions are listed here.

| Trigger | Condition | System action |
|---|---|---|
| **Enter D11 (from D1)** | Low-mood/anxiety logged, MH history disclosed, or user opts into mood support/screening | **Offer** (confirm, reversible) the antenatal mental-wellbeing layer over D1; keep all D1 content; extra-gentle tone; elevated-sensitivity consent for mood data |
| **Elevated EPDS/GAD-7 band (no Q10 signal)** | Score in higher band, Q10 = 0 | Surface support module + "discuss with your clinician" + coping content + help-options; supportive, non-diagnostic; keep screening framing; offer gentle re-check |
| **EPDS Q10 non-zero** | Any self-harm response (1/2/3) | **Immediate** localized crisis-resource surface + warm urgent-care messaging, **independent of total score**; show saved crisis/clinician contacts; log Q10 flag (highest-sensitivity); never reassure-in-place-of-routing |
| **Repeated low-mood logs** | Sustained low mood over time | Gently offer a screening check and coping content; never auto-label; never nag |
| **Continue to postpartum (→ E3)** | Delivery/birth recorded | Carry antenatal mood + screening history forward to **E3 postpartum mood support**; re-baseline to postpartum EPDS cadence; retain continuity (antenatal mood predicts postpartum mood) |
| **Pregnancy loss (→ E6)** | Loss/stillbirth recorded | Inherit universal loss handler: instant milestone suppression, Gentle Mode, grief resources; **retain mental-health support + crisis resources** (grief + prior mood need care); no re-prompting; later optional PAL (D2) path |
| **Escalation blends (other D-personas)** | GDM/HTN/thyroid/etc. recorded alongside mood | Union of safety layers per blending rules (§8); most-acute physical emphasis takes hero, mood layer persists as supportive strip |
| **Toggle mood layer off** | User opts out | Revert to D1 emphasis; retain data per privacy settings; crisis resources remain reachable; nothing forced |

*All routing is content/UX routing, not clinical triage. Femio surfaces resources and prompts; clinicians decide.*

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, no treatment, no prevention claims, no medical-device functionality. Screening tools are **screens, not diagnostic tests**; coping content is **general wellbeing education, not therapy**. Avoid any "medical device"–triggering or predictive-medical language (femio-compliance-privacy).
- **Screening framing (mandatory):** EPDS/GAD-7 presented strictly as *"screening — discuss with your clinician."* Scores shown as **ranges/bands, never labels**; thresholds noted to vary by setting/language; never "you have depression/anxiety."
- **EPDS Q10 self-harm rule (mandatory, hard):** any non-zero Q10 → **immediate** crisis resources + warm urgent-care messaging, **independent of total score**. This flow must fire even if the screen is abandoned after Q10. Never reassure in place of routing; never punitive/alarmist framing.
- **Crisis resources — global and never US-only:** follow [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md): keep the urgent route persistently reachable, use an explicit country selector for a maintained directory, and retain the WHO-aligned emergency-services fallback if lookup fails. Maternal-support services must be labelled separately when they are not crisis lines. *(WHO, 18 September 2024; Find A Helpline accessed 23 July 2026; reviewed Mohamed K., 23 July 2026.)*
- **No medication guidance:** medication-in-pregnancy content is *educational only* — never a dose, never "safe to take/stop," never advising starting/stopping; explicitly directs medication decisions (incl. never stopping abruptly) to the clinician, framed as a risk–benefit conversation (RCOG/NICE).
- **Tone / anti-stigma:** warm, non-judgemental; no toxic positivity, no doom; never implies unfit motherhood or harm-to-baby-because-of-mood; silence-over-risk on ambiguous signals. This is a clinical-safety requirement (stigma suppresses disclosure), not only UX.
- **Sensitive data (highest class):** screening results, Q10 flag, mood, and MH-history fields receive elevated privacy handling; explicit granular consent for any storage/sharing; **excluded from partner sharing by default**; no third-party ad/data-broker leakage; GDPR/PDPL special-category handling; data export/delete honored.
- **Instrument governance:** use only complete, unmodified, validated production-language EPDS/GAD-7 forms with their attribution and notices; do not improvise translations or items. Source and access rules are pinned in [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md). *(Reviewed Mohamed K., 23 July 2026.)*
- **Content integrity:** every clinical statement medically-reviewed, cited, dated, reviewer + review-date visible; **crisis and screening copy human-reviewed in EN/AR/FR/ES (never machine-only)** given the stakes.
- **Distinct from E3:** D11 is *antenatal* (still pregnant); E3 is *postpartum*. The resolver must not conflate them — keyed on pregnancy-vs-delivered status — while ensuring seamless carry-forward D11 → E3.
- **Pinned implementation controls:** global non-diagnostic score presentation and instrument governance come from [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md); [NICE CG192 recommendations](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations) is the CBT/self-help permalink; global urgent routing comes from [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md).

---

## Sources

**Tier-1 (NIH/NIMH/NHS/MedlinePlus)**
- [NIMH — Perinatal Depression](https://www.nimh.nih.gov/health/publications/perinatal-depression)
- [NIMH — Depression in Women: 4 Things to Know](https://www.nimh.nih.gov/health/publications/depression-in-women)
- [NIMH — Population Study Finds Depression Is Different Before, During, and After Pregnancy](https://www.nimh.nih.gov/news/science-updates/2023/population-study-finds-depression-is-different-before-during-and-after-pregnancy)
- [NHS — Mental health in pregnancy and after the birth](https://www.nhs.uk/pregnancy/mental-health-in-pregnancy-and-after-the-birth/mental-health/)
- [NHS — Depression in pregnancy](https://www.nhs.uk/pregnancy/mental-health-in-pregnancy-and-after-the-birth/depression/)
- [NHS — Mental health problems and pregnancy](https://www.nhs.uk/pregnancy/keeping-well/mental-health/)

**Tier-2 (ACOG / RCOG / NICE + instrument validation)**
- [ACOG — Screening and Diagnosis of Mental Health Conditions During Pregnancy and Postpartum (2023 Clinical Practice Guideline)](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2023/06/screening-and-diagnosis-of-mental-health-conditions-during-pregnancy-and-postpartum)
- [ACOG — Patient Screening (Perinatal Mental Health)](https://www.acog.org/programs/perinatal-mental-health/patient-screening)
- [NICE CG192 — Antenatal and postnatal mental health: Recommendations](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations)
- [NICE CG192 — Overview](https://www.nice.org.uk/guidance/cg192)
- [NICE CG192 — Depression: information for the public](https://www.nice.org.uk/guidance/cg192/ifp/chapter/depression)
- [RCOG / RCM — Perinatal mental health roadmap (1 in 5; suicide a leading cause of maternal death)](https://www.rcog.org.uk/news/rcog-welcomes-rcm-perinatal-mental-health-roadmap/)
- [RCOG — Management of Women with Mental Health Issues during Pregnancy and the Postnatal Period (good-practice)](https://www.rcog.org.uk/media/4gikqggv/managementwomenmentalhealthgoodpractice14.pdf)
- [Patient.info (clinician) — Antenatal Mental Health Problems](https://patient.info/doctor/mental-health/antenatal-mental-health-problems)

**EPDS / GAD-7 validation, thresholds, and Q10 self-harm item**
- [Simplified EPDS for Antenatal Depression — validity as a pre-screen (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3222089/)
- [Validation of the EPDS in pregnancy and postpartum, Australia (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12569127/)
- [EPDS validated against DSM-5 and ICD-10 (BMC Psychiatry)](https://link.springer.com/article/10.1186/s12888-018-1965-7)
- [Antenatal EPDS timeline and cut-off scores (BMC Pregnancy & Childbirth)](https://link.springer.com/article/10.1186/s12884-022-04740-w)
- [EPDS accuracy with/without the self-harm item, pregnant & postpartum (Taylor & Francis)](https://www.tandfonline.com/doi/full/10.1080/0167482X.2024.2404967)
- [IPD meta-analysis — EPDS accuracy with vs without the self-harm item (Scientific Reports)](https://www.nature.com/articles/s41598-023-29114-w)
- [EPDS scoring guide with Q10 self-harm handling (Black Dog Institute PDF)](https://www.blackdoginstitute.org.au/wp-content/uploads/2020/04/edinburgh-postnatal-depression-scale.pdf)
- [EPDS scoring (AAP PDF)](https://downloads.aap.org/AAP/PDF/Postnatal%20Depression%20Scale.pdf)
- [GAD-7 diagnostic validity among pregnant women (PLOS One)](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0125096)
- [GAD-7 as a screening tool for anxiety in pregnant women (ScienceDirect)](https://www.sciencedirect.com/science/article/abs/pii/S0165032720332195)
- [Anxiety scales used in pregnancy — systematic review (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6343118/)

**Prevalence**
- [Prevalence of antenatal and postnatal anxiety — systematic review & meta-analysis (BJPsych)](https://www.cambridge.org/core/journals/the-british-journal-of-psychiatry/article/prevalence-of-antenatal-and-postnatal-anxiety-systematic-review-and-metaanalysis/9CF2AC0D36E9FF13A32022460FCBA7EE)
- [Prevalence and factors of antenatal depression at first ANC visit (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8545620/)
- [Perinatal mental health screening/intervention protocol — prevalence context (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7079581/)

**Competitor / app-landscape gaps**
- [JMIR — Review of Mobile Apps for Women With Anxiety in Pregnancy](https://www.jmir.org/2022/3/e31831) · [PMC mirror](https://pmc.ncbi.nlm.nih.gov/articles/PMC8987965/)
- [mHealth apps for maternal mental well-being — systematic review (mHealth/AMEGroups)](https://mhealth.amegroups.org/article/view/152947/html)
- [Smartphone Applications to Support Perinatal Mental Health (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12933385/)
- [Best Pregnancy Apps for Anxiety: Why Most Fall Short (Carea)](https://www.careaapp.com/blog/best-pregnancy-apps-for-anxiety-why-most-fall-short-and-how-carea-helps/)
- [Best Maternal Mental Health Apps (Phoenix Health)](https://joinphoenixhealth.com/resourcecenter/best-maternal-mental-health-apps/)

*Reviewed source set:* EPDS/GAD-7 thresholds and use terms are governed by [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md); self-help/CBT wording uses the [NICE CG192 recommendations permalink](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations); urgent routing uses [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
