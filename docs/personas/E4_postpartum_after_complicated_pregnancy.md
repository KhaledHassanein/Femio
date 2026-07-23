# Persona E4 — Postpartum After a Complicated Pregnancy (Condition Follow-Up)

> Femio persona spec. Scope: **wellness / education / tracking only.** Femio never diagnoses, treats, or prevents disease. All screeners are framed as *screening — discuss results with your clinician*, and all red flags carry prominent *seek-care-now* framing. This document is a product/UX + clinical-grounding brief, not medical advice.
>
> E4 is the **destination persona** of the D-track condition specs: D3 (GDM), D4 (pre-existing diabetes), D5 (chronic hypertension), D6 (pre-eclampsia / gestational hypertension), and D8 (prior preterm / NICU). It co-activates **on top of E1** (general postpartum recovery) — it is a follow-up *layer*, not a replacement for recovery care. D7 (thyroid) routes to its own E7 postpartum-thyroiditis watch.

---

## A. Persona snapshot

**Who she is.** A woman 0–12 months after giving birth whose pregnancy was complicated — gestational diabetes, pre-existing diabetes, chronic hypertension, pre-eclampsia/gestational hypertension, a preterm birth or NICU stay, or several at once. She is doing everything E1 is doing (bleeding, healing, mood, feeding, sleep deprivation) **while also carrying condition follow-up obligations that routine postpartum care frequently drops**: the 4–12-week OGTT, the 72-hour and 7–10-day BP checks, medication reviews, lifelong screening schedules, and a risk profile that quietly reshapes her long-term cardiovascular and metabolic health.

**Core emotional state.** Relieved the pregnancy is over, but not *released*: "my GDM is gone, right?" collides with "you now need lifelong diabetes screening." Vigilance fatigue after months of glucose pricks or BP cuffs; guilt-tinged risk anxiety ("did I cause this? will it come back?"); and for postpartum pre-eclampsia risk, a genuinely dangerous knowledge gap — many women don't know PE can *begin* after birth. NICU mothers add trauma, grief for the expected birth, and total self-neglect while living at the incubator.

**The "postpartum cliff."** During pregnancy she was watched weekly; after delivery the system's attention transfers to the baby and her condition follow-up evaporates. Only ~25–50% of women with GDM complete the recommended postpartum glucose test, and even women whose infants were in tertiary NICUs are no more likely to get the recommended 7–10-day BP check. Femio's one-account continuity is built to bridge exactly this cliff — as education and reminders, never as care itself.

**Jobs to be done.**
- "Tell me exactly which follow-up tests I need and when — and remind me, because nobody else will."
- "Keep my glucose/BP log running after delivery instead of ending it at birth."
- "Tell me which symptoms after birth are an emergency — I didn't know pre-eclampsia could start *after* delivery."
- "Explain what GDM/pre-eclampsia means for the rest of my life — honestly, without doom."
- "When I'm ready for another baby, help me start that conversation prepared."

**Context of use.** Same as E1: web-first, one-handed, 2 a.m. sessions, EN/AR/FR/ES with Arabic-first/RTL. Added context: lab appointments to juggle with a newborn (a 2-hour OGTT with a baby in tow is a real logistical barrier — a documented reason tests get skipped), and possibly a home BP cuff or glucometer already on the shelf from pregnancy.

**Femio's wedge for E4.** The condition layer (glucose[], BP[], med log, red-flag logic) that ran through her D-track pregnancy **does not die at delivery** — it carries forward, re-tuned to postpartum cadence and thresholds, then relaxes into long-horizon annual-screening reminders. No competitor's consumer product does this; condition apps end at birth and baby apps never knew about the condition.

---

## B. Needs & questions (voice-of-user)

Synthesized from GDM/pre-eclampsia/NICU communities (r/GestationalDiabetes, r/preeclampsia, r/NICUParents and similar), Preeclampsia Foundation patient materials, app reviews, and the postpartum-screening barriers literature. Quotes are representative of recurring themes, not verbatim attributions.

**GDM aftermath.**
- "Is it really gone now that the baby's out?" — the most common belief, and the documented reason women skip the postpartum test ("thought it would disappear after delivery").
- "Nobody ever ordered my 6-week glucose test. Do I chase it myself?"
- "How am I supposed to sit in a lab for a 2-hour OGTT with a newborn?" (childcare/work barriers are cited in the screening-gap research).
- "They said I'm at risk of type 2 forever now. What do I actually *do* with that?"
- "Can I eat normally again? Do I keep testing my sugar?" (some clinicians ask for a short user-recorded monitoring period — varies).

**Hypertension / pre-eclampsia aftermath.**
- "My BP was fine at discharge — then I was readmitted on day 5." Postpartum PE most often strikes within the first week; many women never learned it could.
- "Is this headache normal new-mom exhaustion or the dangerous kind?"
- "How long do I keep using the cuff? What numbers mean call someone?"
- "I read pre-eclampsia doubles my heart-disease risk. Why did no one mention that at any appointment?"
- Chronic-HTN mothers (D5): "My meds are being changed again — which ones are OK while breastfeeding?"

**Pre-existing diabetes (D4).**
- "My insulin needs crashed after delivery — my numbers are all over the place while breastfeeding."
- "I'm exhausted and hypo-prone at 3 a.m. feeds. How do I stay safe?" (education + clinician framing only).

**Post-preterm / NICU (D8).**
- "I recover in a hospital chair. My own checkup felt like an afterthought." NICU mothers show ~34–51% rates of postpartum depression/anxiety symptoms and high birth-trauma rates.
- "Everyone asks about the baby. Nobody asks about me."
- "Will my next pregnancy be preterm too? What can be checked before I try again?"

**Cross-cutting.**
- "Give me one list: which tests, which weeks, which symptoms are emergencies."
- "Tell me the truth about my long-term risk without making me feel doomed or blamed."
- "When we want another baby, what should happen differently from the start?"

**What "good" looks like to her.** One checklist that survives the chaos; her pregnancy logs continuing seamlessly; red-flag knowledge *before* day 5, not after readmission; risk education framed as agency ("what screening catches early") not fate; and a warm handoff into next-pregnancy planning when she chooses.

---

## C. Competitor teardown (the whitespace: postpartum condition follow-up)

| Product | Pregnancy condition support | Postpartum condition follow-up | Long-term risk education | Interpregnancy continuity | Gap for E4 |
|---|---|---|---|---|---|
| **Malama (GDM app)** | Strong GDM glucose/food logging in pregnancy; has added generic "postpartum wellness" | No structured OGTT/lifelong-screening pathway; users request BP tracking it lacks | Minimal | None — single-condition, single-episode | The archetype: condition app that effectively **ends at birth** |
| **Babyscripts myBloodPressure / hospital RPM programs** | Postpartum BP monitoring exists — but as **clinician-prescribed remote-monitoring programs**, cuff issued at discharge | Yes, but only inside a health-system contract; not consumer-accessible; typically 6-week horizon | No | No | Proves the need; unavailable to women outside enrolled systems (and most of MENA); not a consumer product |
| **Ovia (postpartum)** | Personalizes postpartum content to delivery type & conditions; "Critical Alert" pattern | Content-level only; no continued glucose/BP logging engine or test-date checklist | Some content | Reproductive-planning content | Closest peer, still no structured follow-up *tracker*; employer-channel privacy optics; not Arabic-first |
| **Flo / Clue** | Cycle-first; thin postpartum, no condition layer | None | None | Cycle continuity only | Condition history doesn't inform anything |
| **mySugr / diabetes apps** | Lifelong diabetes logging (D4-relevant) | Not postpartum-aware (no breastfeeding/insulin-shift context, no OGTT concept) | T2DM-centric | None | No bridge from GDM episode to lifelong screening |
| **Baby trackers (Huckleberry etc.)** | None | None | None | None | The mother's medical follow-up simply does not exist |
| **Preeclampsia Foundation resources** | Excellent education (incl. "Still at Risk" postpartum initiative) | Education only, no tracking/reminders | Yes (CVD risk) | Yes (content) | Validates the message; no product layer — a content ally, not a competitor |

**Teardown takeaways.**
1. **True whitespace.** Structured *consumer* postpartum condition follow-up — test checklist + continued logging + red-flag education + long-term risk framing in one place — is done by **nobody**. Clinical RPM programs prove efficacy but are gated behind health systems.
2. **Continuity is the product.** E4 is only possible because Femio held the D-track data; a standalone app cannot know she had GDM at 28 weeks. The D→E4→B/C→D-again loop is the moat.
3. **The educational gap is a safety gap.** Even obstetricians under-communicate post-PE cardiovascular risk (documented awareness gaps); referenced, calm, Arabic-available education here is both wedge and public-health contribution.

---

## D. Clinical grounding (cited)

*All items are education/tracking context for Femio content — presented to users as general information and screening prompts, never diagnosis or treatment.*

**After GDM: the 4–12-week test, then lifelong screening.**
- ACOG and the ADA recommend a **75-g 2-hour OGTT at 4–12 weeks postpartum** for everyone who had GDM, then — if normal — **repeat screening every 1–3 years for life** (ADA: annual HbA1c or fasting glucose, or triennial OGTT). ([AAFP summary of ACOG/ADA guidance](https://www.aafp.org/pubs/afp/issues/2023/0900/gestational-diabetes.html); [ObG Project — GDM postpartum follow-up](https://www.obgproject.com/2023/04/10/gdm-postpartum-follow-screening/))
- UK pathway differs: NICE NG3 recommends **fasting plasma glucose at 6–13 weeks**, or **HbA1c after 13 weeks** (HbA1c is inaccurate before 13 weeks), then **annual** testing; NHS offers referral to the Diabetes Prevention Programme. ([NICE NG3 recommendations](https://www.nice.org.uk/guidance/ng3/chapter/recommendations)) Femio must present the schedule as *"guidelines describe… your clinician sets your exact plan"* with regional variants.
- **Why it matters:** GDM confers roughly **~50% (range 35–60%) risk of type 2 diabetes over the following 10–20 years**, and up to ~70% without intervention; up to a third have impaired glucose metabolism already at the postpartum screen. ([CDC PCD — postdelivery intervention after GDM](https://www.cdc.gov/pcd/issues/2022/22_0055.htm); [Franciscan Health citing CDC](https://www.franciscanhealth.org/community/blog/gestational-diabetes-and-your-health))
- **The gap is real:** completion of the postpartum glucose test runs **~25–53%** across cohorts; SMFM has made it a formal quality metric. Barriers: belief GDM "disappears," the 2-hour lab visit with a newborn, work/childcare. ([SMFM quality-metric statement](https://www.ajog.org/article/S0002-9378(22)02601-1/fulltext); [retrospective cohort, 47.2% completion](https://pmc.ncbi.nlm.nih.gov/articles/PMC12094375/); [screening-rate study](https://pmc.ncbi.nlm.nih.gov/articles/PMC3991991))
- GDM is also associated with higher rates of **postpartum depression** — mood screening matters extra here. ([CDC — GDM and postpartum depression](https://www.cdc.gov/diabetes/about/gestational-diabetes-postpartum-depression.html))

**After hypertensive disorders: BP follow-up and postpartum pre-eclampsia.**
- ACOG recommends blood-pressure evaluation **no later than 7–10 days postpartum** after a hypertensive disorder of pregnancy; people with **severe hypertension should be seen within 72 hours**. This is not “both checks for every user”; the clinician sets the plan. ([ACOG — Optimizing Postpartum Care](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/05/optimizing-postpartum-care); [reviewed global rule](../compliance/PREGNANCY_BP_SAFETY.md); reviewed Mohamed K., 23 July 2026.)
- **Postpartum pre-eclampsia can begin after a completely normal pregnancy**: consider new-onset hypertension **48 hours to 6 weeks after delivery**, most often within the **first 7 days**. Delivery is the acute treatment of PE, **not a cure**. ([Preeclampsia Foundation — Postpartum Preeclampsia](https://preeclampsia.org/postpartum-preeclampsia); [AJOG review](https://www.ajog.org/article/S0002-9378(20)31201-1/fulltext); [ACOG — 3 conditions to watch for after childbirth](https://www.acog.org/womens-health/experts-and-stories/the-latest/3-conditions-to-watch-for-after-childbirth))
- Warning signs (mirror D5/D6 red-flag layer, postpartum-tuned): severe/persistent headache, vision changes, upper-abdominal pain, sudden swelling of hands/face, shortness of breath, readings ≥140/90 (call clinician) with **≥160/110 as emergency-territory framing**, seizure. Consistent with CDC's urgent maternal warning signs, which apply **up to a year after birth**. ([CDC Hear Her](https://www.cdc.gov/hearher/maternal-warning-signs/index.html))

**Long-term cardiovascular risk (the honest, non-doom education layer).**
- A history of pre-eclampsia or gestational hypertension is associated with higher later cardiovascular and kidney risk, so it belongs in the user's long-term health history and follow-up conversations. Femio presents this as a reason for ongoing prevention and monitoring, not a personal prognosis. ([ACOG FAQ, reviewed April 2025](https://www.acog.org/womens-health/faqs/preeclampsia-and-high-blood-pressure-during-pregnancy); [NICE quality standard QS35](https://www.nice.org.uk/guidance/qs35/chapter/Quality-statements))
- Magnitudes to teach carefully: history of pre-eclampsia ≈ **71% higher lifetime risk of death from heart disease/stroke**; HDP → **2–8× risk of chronic hypertension**, ~2× coronary disease and stroke; **about 1 in 5** women with HDP develop hypertension within 15 years. ([HDP→CVD meta-analysis, PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8787919/); [systematic review, PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9333537/))
- Framing mandate: these are **population statistics that make screening worth doing**, not personal verdicts. Even clinicians under-discuss this. ([Knowledge/care gap study, PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10837265/); [obstetrician-awareness study, PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8918160/))

**Interpregnancy care (the on-ramp to the next D-track).**
- ACOG/SMFM Obstetric Care Consensus #8: the interpregnancy period is a care opportunity; advise **avoiding intervals <6 months** and counsel on risks/benefits of **<18 months**; condition-specific interpregnancy testing and goals for diabetes, GDM, chronic/gestational hypertension, and pre-eclampsia; prior PE and prior preterm birth raise recurrence risk in future pregnancies. ([ACOG — Interpregnancy Care](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2019/01/interpregnancy-care); [AAFP summary](https://www.aafp.org/pubs/afp/issues/2019/0715/p121.html))
- Breastfeeding is associated in the literature with lower later T2DM risk after GDM — presented as gentle, pressure-free education. *[NEEDS SOURCE: CDC/NIH breastfeeding-and-T2DM-after-GDM citation.]*

**Post-preterm / NICU maternal load.**
- NICU mothers carry heavy comorbid mental-health burden (in one sample: **51% postpartum anxiety, 35% depression, 40% post-traumatic stress**) and report unmet needs for their *own* primary care, mental-health screening, and lactation support; HDP mothers with NICU infants were **no more likely** to receive the 7–10-day BP check. ([Peripartum trauma in NICU mothers, PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10529597/); [scoping review, Frontiers](https://www.frontiersin.org/journals/health-services/articles/10.3389/frhs.2026.1845396/full))
- The general postpartum spine (ACOG contact ≤3 weeks, comprehensive visit ≤12 weeks; CDC warning signs to 1 year) is inherited from E1. ([ACOG CO 736](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/05/optimizing-postpartum-care); [CDC Hear Her](https://www.cdc.gov/hearher/maternal-warning-signs/index.html))

---

## E. Feature set (prioritized)

**P0 — must ship (this persona's reason to exist).**
1. **Condition follow-up checklist** — auto-built from her carried D-track flags: which tests, which week windows, done/not-done state, with "ask your clinician to order it" self-advocacy scripts. (Directly attacks the ~50–75% miss rate.)
2. **Postpartum-PE red-flag education + box** — surfaced to *every* E4 (and E1) user in weeks 0–6, most prominently days 0–14; postpartum-tuned wording of the shared D5/D6 red-flag layer.
3. **Continued BP log** (D5/D6 carriers) — same tool as pregnancy, postpartum cadence; educational reference bands, clinician-confirmed, never verdicts.
4. **Continued glucose log** (D3/D4 carriers) — D4: ongoing, breastfeeding-aware education; D3: optional short monitoring period if her clinician asked, then the tool quiets down but stays reachable.
5. **EPDS with E4 emphasis** — inherited from E1, foregrounded earlier and re-prompted more for GDM/NICU/traumatic-birth history; Q10 rule mandatory.

**P1 — high value.**
6. **Long-term risk education hub** — "What GDM/pre-eclampsia means for your future health": screening-as-agency framing, lifelong-cadence reminders (annual/1–3-year), heart-health basics.
7. **Annual-screening reminder engine** — the long tail: after graduation from postpartum mode, low-frequency nudges ("guidelines suggest a yearly glucose check after GDM — worth raising at your next visit").
8. **Medication & breastfeeding education** (D4/D5) — general class education, "your clinician decides," never dose or start/stop advice.
9. **NICU-mother mode** (D8 carriers) — self-care-while-at-the-NICU content, trauma-informed tone, mood screening, and her *own* follow-up kept alive while life happens at the incubator.

**P2 — enrichment.**
10. **Interpregnancy planning module** — surfaced only on her signal (TTC intent or curiosity): spacing education, condition-specific "questions for a preconception visit," warm handoff to condition-flagged C/D-track.
11. Test-logistics micro-content ("bringing a newborn to a 2-hour OGTT: what helps"). 12. Partner/family share of red-flag education (privacy-gated). 13. Exportable follow-up summary to hand a new GP.

**Explicitly out of scope.** Diagnosis or triage of readings; dosing/titration; risk calculators presented as personal prognosis; contraception prescribing (education only); any claim to replace the postpartum visit.

---

## F. Content modules (medically-reviewed, referenced, grade 6–8, 4 languages)

1. **Your follow-up map** — per-condition test/timing explainers (OGTT 4–12 wks; BP 72 h + 7–10 days; regional variants like NICE FPG/HbA1c) + why each exists + self-advocacy scripts.
2. **Pre-eclampsia can start after birth** — the flagship safety module: 48 h–6 wks window, first-week peak, symptom list, "delivery treats it, doesn't cure it," seek-care-now framing.
3. **After gestational diabetes** — "is it gone?"; the postpartum test; lifelong screening rhythm; T2DM risk as motivation-not-fate; food/movement basics; breastfeeding context; anti-self-blame thread throughout.
4. **After high blood pressure or pre-eclampsia** — BP follow-up; med review & breastfeeding compatibility (educational); your heart in the long run (AHA framing).
5. **Your heart, your future** — pregnancy as a window into future health; what annual checks catch; shared with F-track later life stages.
6. **After a preterm birth or NICU stay** — your own recovery while the baby is hospitalized; trauma and mood; your follow-up still matters; next-pregnancy questions (recurrence, what clinicians can assess).
7. **Diabetes and the fourth trimester** (D4) — postpartum insulin-need shifts, hypo-awareness during night feeds, breastfeeding — all "discuss with your team."
8. **Thinking about the next baby** — interpregnancy spacing, preconception visits, condition-specific preparation; contraception framed as a clinician conversation.
9. **Inherited from E1:** body-after-birth, warning signs, emotions & EPDS, pelvic floor, cycle return.

*Every module: medically-reviewed, cited, dated, reviewer + review-date visible; EN/AR/FR/ES with Arabic-first/RTL QA; safety copy human-translated.*

---

## G. Tools, logs & alerts (compliant framing)

**Follow-up reminder engine (condition-specific).** Reminders are calendar education, never orders; each carries a *why* + *"your clinician sets your exact plan."*

| Carried flag | Reminder cadence (defaults, editable) |
|---|---|
| **D3 (GDM)** | Week 2: "book your 4–12-week glucose test" (region-aware wording) → week 6 & 10 gentle re-prompts if not marked done → after result logged: "share/discuss with your clinician" → long-tail: annual (or 1–3-year) screening nudge, ongoing after graduation |
| **D4 (pre-existing diabetes)** | Week 1: "diabetes-team review of your postpartum plan" prompt; glucose log continues uninterrupted; breastfeeding/hypo education cards; no gap, no graduation of the diabetes layer |
| **D5/D6 (BP)** | Day 3: "72-hour BP check" prompt · days 7–10: "follow-up BP check" prompt · weeks 0–6: BP log foregrounded + PE red-flag box pinned · week 6+: taper to periodic BP-awareness + annual CV-check education |
| **D8 (preterm/NICU)** | Weeks 0–3: "your own checkup" prompt (ACOG ≤3-week contact) · EPDS earlier + repeated · comprehensive-visit (≤12 wk) nudge · later: interpregnancy "questions about recurrence" content on her signal |

Marking a test **done** (+ optional user-entered result, entry-only, uninterpreted) retires that reminder and updates the checklist. Nothing re-prompts after loss, withdrawal, or "stop reminding me."

**Postpartum-PE red-flag box (P0 pattern — pinned weeks 0–6 for D5/D6 carriers, inline for all E-track).**

> **Pre-eclampsia can start *after* birth — most often in the first week, up to 6 weeks.** Seek care now — call your clinician or emergency services — if you have: a severe or persistent headache; vision changes (spots, blurring, light sensitivity); pain in your upper belly; sudden swelling of your face or hands; trouble breathing; or a blood pressure reading of 160/110 or higher. A reading of 140/90 or higher is worth a same-day call. Don't wait to see if it passes — being recently pregnant is the risk. *(Sources: Preeclampsia Foundation; CDC Hear Her; ACOG.)*

**Logs.** BP (postpartum series continues the pregnancy series on one timeline), glucose (D3 optional / D4 ongoing), meds (entry-only), symptoms, mood/EPDS, feeding context, test-result entries (raw, uninterpreted). All logs = educational self-tracking; no safe/danger scoring; severe entries trigger the seek-care box, never a verdict.

**Inherited from E1:** CDC warning-sign surface (to 12 months), EPDS with Q10 crisis rule, locale-specific emergency/crisis resources.

**Non-negotiables.** Femio never says "your OGTT is normal/abnormal," never doses, never triages. Every alert = symptoms/timing + seek-care or discuss-with-clinician action.

---

## H. EMR fields (core vs persona-specific)

**Core lifespan fields:** as E1 (identity/locale/consents, reproductive history, conditions, meds, cycle history, prior pregnancies/outcomes).

**E4 persona-specific fields (layered on E1's delivery-event fields):**
- `carried_condition_flags[]`: {GDM, preexisting_diabetes(T1/T2), chronic_HTN, gestational_HTN, preeclampsia(±severe/HELLP), preterm_birth(gest_age), NICU_stay} — inherited from D-track, never self-generated by the app.
- `followup_checklist[]`: per item {test_type (OGTT/FPG/HbA1c/BP-check/med-review/postpartum-visit), guideline_window, region_variant, reminder_state, done_date, user_entered_result (raw), discussed_with_clinician?}.
- `bp_log[]` (continues pregnancy series; postpartum-tagged) · `glucose_log[]` (D3 optional / D4 ongoing) · `med_log[]` incl. breastfeeding-compatibility-discussed flag (educational).
- `longterm_screening_schedule[]`: {annual glucose (post-GDM), periodic BP/CV check (post-HDP)} — persists after E-track graduation as a low-touch layer.
- `lifetime_risk_flags[]` (non-diagnostic, education-routing only): {hx_GDM, hx_preeclampsia, hx_gestational_HTN, hx_preterm} — permanent, feeds B-track and F-track content emphasis and the next D-track.
- `interpregnancy`: {ttc_intent, spacing_education_shown, preconception_questions_saved[]}.
- `nicu_context` (D8): {baby_in_NICU?, discharge_date, trauma-informed-tone flag}.

*Sensitive handling: all of the above is special-category health data; results are stored raw and uninterpreted; elevated privacy per femio-compliance-privacy.*

---

## I. Personalization rules (wizard → home config)

**Entry data:** normally inherited automatically from the D-track hand-off. Cold-start wizard path (she's new, recently delivered): Q5 asks "Was anything being watched in your pregnancy?" (multi-select: blood sugar / blood pressure or pre-eclampsia / thyroid → E7 / early birth or NICU / none) → sets carried flags without diagnosing.

**Home configuration (postpartum-week × condition-driven; E4 layers onto the E1 week-indexed rail).**
- **Hero:** E1 recovery hero stays primary (most-acute-emphasis rule) with a **follow-up checklist strip** directly beneath — "2 of 4 follow-ups done."
- **Weeks 0–2:** postpartum-PE red-flag box pinned (D5/D6; shown once to all); 72-h/7–10-day BP prompts; D4 glucose continuity card; NICU self-care card (D8); GDM "book your test" card appears.
- **Weeks 2–6:** OGTT window countdown-free reminder ("your test window is open"); EPDS foregrounded (earlier than E1 default for GDM/NICU); BP taper education.
- **Weeks 6–12:** comprehensive-visit nudge annotated with her condition agenda ("things to raise: your glucose test result, BP plan, contraception, mood"); long-term-risk hub unlocked gently.
- **Months 3–12:** "your future health" education; annual-screening schedule set; interpregnancy module on signal; cycle-return education (E1).
- **Multiple flags:** union of safety layers, merged not double-counted (master-model rule); checklist merges all items on one timeline.
- **Tone:** anti-self-blame everywhere (GDM guilt is documented); trauma-informed for D8; risk copy always pairs a statistic with an action.

**Hidden-but-reachable.** Pregnancy-mode tools are archived-but-reachable; the checklist and risk education never block E1 recovery content; everything one–two taps via Explore.

---

## J. Adaptation triggers (state transitions)

*E4 inherits all universal events (master model §6): positive test, loss, mood-crisis, red-flag, disengagement, toggle-off, consent milestones. Below are E4-specific transitions only.*

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Enter E4 (from D-track)** | Delivery logged while D3/D4/D5/D6/D8 flags active | Co-activate E4 on E1; build follow-up checklist from carried flags; keep BP/glucose/med logs running on one timeline; pin postpartum-PE red-flag layer (D5/D6); set condition reminder cadences (§G) | **E1 ⊕ E4** |
| **Enter E4 (cold start)** | Wizard Q5 complication multi-select | Same, from self-reported flags; never generates a diagnosis | **E1 ⊕ E4** |
| **Follow-up test marked done** | Checklist item completed (± user-entered result, raw) | Retire that reminder; celebrate lightly ("one thing off your plate"); prompt "discuss the result with your clinician"; advance checklist | Stay |
| **Abnormal / concerning result entered** | User flags result as "clinician said abnormal" or enters values she's worried about | **No interpretation.** "This is one to go over with your clinician soon" + booking prompt + relevant education (e.g., prediabetes-explainer, BP follow-up); tone calm, zero verdict | Stay + clinician-discussion framing |
| **Test window closing, not done** | GDM item undone at wk 10; BP check undone at day 10 | One warmer, barrier-aware re-prompt ("hard to do with a newborn — here's what can help; it's still worth booking") then respect silence | Stay |
| **Postpartum-PE red flag** | PE-symptom logged or reading ≥160/110 entered, weeks 0–6 | **Seek-care-now** box (postpartum-tuned) + saved emergency/maternity contact; log stays raw; inherited universal handler with E4 wording | Emergency messaging (content only) |
| **EPDS elevated / Q10** | Inherited E1 thresholds; E4 prompts earlier/more often for GDM/NICU/trauma flags | Universal mood handler; route to **E3** support track | **⊕ E3** |
| **Checklist complete + week >12** | All acute follow-ups done/declined | Shift emphasis from acute checklist to **long-term layer**: annual-screening schedule live, risk-education hub, lighter home | Stay (long-tail E4) |
| **Graduation (~12 months / cycle return)** | E1 graduation triggers fire | Graduate to **condition-aware B-track**: general cycle home + persistent `lifetime_risk_flags` driving annual glucose (post-GDM) and CV-check (post-HDP) nudges + risk education skin; postpartum content archived-but-reachable | **B1 + lifelong-risk layer** |
| **TTC intent set** | She signals trying again / opens interpregnancy module | Interpregnancy education (spacing, preconception visit scripts, condition-specific prep); route to condition-aware C-track | **C1** (+condition context) |
| **Next positive pregnancy test** | Universal handler | Celebrate (tone-matched); **carry risk flags forward so the D-track starts condition-aware from week 1** — prior GDM → early-screen education (D3-aware D1), prior PE/HTN → D5/D6-aware setup incl. aspirin-*education*, prior preterm → D8-aware; never predicts recurrence, only primes earlier conversations | **D-track, condition-flagged early** |
| **New diagnosis recorded** | User records clinician dx (T2DM, chronic HTN, thyroid) at any point | Acknowledge without alarm; route to the matching condition-persona layer (B-track condition mode / D4-equivalent lifelong logging); follow-up checklist adapts | Condition persona layer |
| **Loss / withdrawal** | Universal handlers | Instant suppression of **all** checklist/test/BP/glucose reminders (not just milestones); condition *care* content retained quietly if she keeps it; grief routing | **E6** / retain, silent |

*All routing is content/UX routing, never triage. The next-pregnancy edge (E4 → condition-flagged D-track) closes Femio's signature loop: one account, one record, every pregnancy smarter than the last — as context for her clinician, never as prediction.*

---

## K. Compliance flags

1. **Scope guardrail.** Wellness/education/tracking only. The checklist is a *reminder of guideline-described care*, not an order set; logs are user-entered tracking aids, not monitoring devices; no result interpretation, no risk calculators presented as personal prognosis (medical-device-scope avoidance per femio-compliance-privacy).
2. **Reminders ≠ care.** Copy must never imply Femio substitutes for the postpartum visit or clinician follow-up; every reminder carries "your clinician sets your exact plan." Regional guideline variants (ACOG/ADA vs NICE) must be locale-correct, never mixed.
3. **Red-flag prominence is a safety requirement.** Postpartum-PE education must reach users in weeks 0–6 *before* symptoms (first-week peak); seek-care framing calm, prominent, never falsely reassuring, never a diagnosis. Identical in spirit to D5/D6; union-merged when flags overlap.
4. **Risk statistics with care.** GDM→T2DM and PE→CVD numbers are population statistics framed as *reasons screening works*, paired with actions; no doom, no fate language, no personal probability claims. Anti-self-blame thread mandatory (GDM guilt, PE "did I cause it," preterm-birth guilt are all documented).
5. **No dosing / no start-stop-switch.** Insulin-shift, antihypertensive, and breastfeeding-compatibility content is general class education; every decision defers to the clinician; never undermine prescribed adherence.
6. **Screeners = screening.** EPDS (Q10 rule mandatory), any glucose/BP entry, any checklist result: "discuss with your clinician," never verdicts.
7. **Mood & trauma safety.** GDM and NICU cohorts carry elevated depression/anxiety/PTS burden — earlier EPDS, trauma-informed D8 tone, crisis resources locale-specific; loss instantly suppresses **all** condition reminders (a GDM-test nudge after a stillbirth is the catastrophic failure mode — suppression must cover the full checklist).
8. **Privacy-by-design (GDPR/PDPL).** Condition history + results + mood = deeply sensitive; minimal collection, explicit granular revocable consent, no ad SDKs, no employer/insurer visibility (explicit contrast with employer-channel competitors); partner sharing scoped; export/delete honored including `lifetime_risk_flags`.
9. **Lifetime flags are user-owned.** `lifetime_risk_flags` persist across tracks by design — but she can view, understand, and remove them; removal downgrades emphasis, never punishes.
10. **Content integrity + i18n.** All clinical claims medically reviewed, cited Tier-1 (CDC/NIH/NHS/MedlinePlus) + Tier-2 (ACOG/ADA/AHA/NICE/SMFM/Preeclampsia Foundation), reviewer + date visible; EN/AR/FR/ES with human-reviewed RTL safety copy; MENA localization of emergency numbers and test-pathway wording.
11. **Medical-source resolution (23 July 2026):** postpartum BP timing and later cardiovascular-risk wording are pinned in [`PREGNANCY_BP_SAFETY.md`](../compliance/PREGNANCY_BP_SAFETY.md). Breastfeeding/T2DM, regional glucose pathways, and directory implementation remain separately tracked items. Global emergency fallback and country-selectable destinations replace hard-coded country numbers. Reviewer Mohamed K.; next review 23 July 2027.

---

## Sources

**Tier-1 (CDC / NIH / NHS / MedlinePlus / NICE):**
- [CDC PCD — Postdelivery Intervention to Prevent Type 2 Diabetes After GDM](https://www.cdc.gov/pcd/issues/2022/22_0055.htm)
- [CDC — Gestational Diabetes and Postpartum Depression](https://www.cdc.gov/diabetes/about/gestational-diabetes-postpartum-depression.html)
- [CDC Hear Her — Urgent Maternal Warning Signs](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [NICE NG3 — Diabetes in pregnancy: postnatal recommendations](https://www.nice.org.uk/guidance/ng3/chapter/recommendations)
- [PMC — HDP and later cardiovascular outcomes](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8787919/)
- [PMC — CVD risk after HDP, systematic review/meta-analysis](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9333537/)
- [PMC — Knowledge & care gaps re: long-term CV risk after HDP/GDM](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10837265/)
- [PMC — Obstetrician awareness of long-term risk after PE/HELLP](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8918160/)
- [PMC — Postpartum glucose follow-up screening cohort (47.2%)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12094375/)
- [PMC — Peripartum trauma & mental health in NICU mothers](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10529597/)
- [Frontiers — Postpartum wellbeing of NICU parents, scoping review](https://www.frontiersin.org/journals/health-services/articles/10.3389/frhs.2026.1845396/full)

**Tier-2 (ACOG / SMFM / ADA / AHA / Preeclampsia Foundation):**
- [ACOG — Optimizing Postpartum Care (CO 736)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/05/optimizing-postpartum-care)
- [ACOG — Interpregnancy Care (Obstetric Care Consensus #8)](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2019/01/interpregnancy-care)
- [ACOG — 3 Conditions to Watch for After Childbirth](https://www.acog.org/womens-health/experts-and-stories/the-latest/3-conditions-to-watch-for-after-childbirth)
- [SMFM — Quality metric: postpartum diabetes screening after GDM](https://www.ajog.org/article/S0002-9378(22)02601-1/fulltext)
- [AJOG — Postpartum preeclampsia/eclampsia: place and management](https://www.ajog.org/article/S0002-9378(20)31201-1/fulltext)
- [Preeclampsia Foundation — Postpartum Preeclampsia](https://preeclampsia.org/postpartum-preeclampsia)
- [AHA Newsroom — CVD in pregnancy needs care before/during/postpartum](https://newsroom.heart.org/news/aha-statement-pregnant-women-with-cvd-need-specialized-care-before-during-and-postpartum)
- [ACC — Adverse Pregnancy Outcomes & CVD Risk (AHA 2021 update summary)](https://www.acc.org/Latest-in-Cardiology/Articles/2021/05/12/11/57/Adverse-Pregnancy-Outcomes-and-CV-Disease-Risk-From-the-AHA)
- [AAFP — GDM screening/diagnosis/management (ACOG/ADA summary)](https://www.aafp.org/pubs/afp/issues/2023/0900/gestational-diabetes.html)
- [AAFP — Interpregnancy Care guidelines summary](https://www.aafp.org/pubs/afp/issues/2019/0715/p121.html)
- [ObG Project — GDM postpartum follow-up screening](https://www.obgproject.com/2023/04/10/gdm-postpartum-follow-screening/)

**Market / community context:**
- [Malama — Gestational Diabetes (App Store)](https://apps.apple.com/us/app/malama-gestational-diabetes/id1626320933)
- [PubMed — Postpartum remote BP monitoring via mobile app (Babyscripts)](https://pubmed.ncbi.nlm.nih.gov/38512155/)
- [Bridge to Prevention (BU) — Arranging postpartum glucose testing (barriers)](https://sites.bu.edu/bridge-to-prevention/101-2/arranging-for-postpartum-glucose-testing)
- [Gestational Diabetes UK — Post-birth diabetes testing](https://www.gestationaldiabetes.co.uk/post-birth-testing/)
