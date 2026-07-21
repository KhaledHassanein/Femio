# Persona E7 — Postpartum Thyroiditis (PPT) Watch

> Femio persona spec. Cohort: Postpartum (E) · Layered on **E1** (postpartum recovery spine) with a **thyroid-watch layer**. Last research pass: 2026-07-21
> Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent.** Screeners = "screening — discuss with your clinician." Red flags get prominent "seek care now" framing, never a diagnosis. **TSH/lab and medication logs are educational self-tracking, entry-only — no interpretation as verdicts, no dosing advice, ever.**
> **Destination state of D7's `ppt_watch_flag`** — E7 is where a D7 (thyroid-in-pregnancy) user lands at delivery when antibody-positive or thyroid-diagnosed (D7 §J.3), and where an E1 user routes when PPT-suggestive symptoms or risk factors surface. The EMR is **constant**: the thyroid lab log and medication history continue uninterrupted from pregnancy; the content library re-skins to the postpartum-thyroid year.

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Salma," 31 |
| **Age band** | ~25–40 (childbearing years; PPT risk is antibody/autoimmunity-driven, not age-driven) |
| **Stage** | 0–12 months postpartum, at **elevated risk of postpartum thyroiditis** or experiencing possible PPT symptoms. Three entry pictures: (1) **flagged in pregnancy** — TPO-antibody-positive, known Hashimoto's/Graves', or on thyroid medication (arrives from D7 with `ppt_watch_flag`); (2) **risk-factor carrier** — type 1 diabetes, prior PPT episode, family history of thyroid disease (self-declared at E-track onboarding); (3) **symptom-first** — an E1 user whose logged fatigue/palpitations/mood/weight pattern surfaces the PPT-awareness path ("could this be my thyroid? discuss with your clinician"). |
| **Goal (top JTBD)** | *"Everyone — including me — assumes my exhaustion, anxiety, and weight changes are just new-mom life. Help me track my symptoms and my TSH results in one place, understand what postpartum thyroiditis is and its phases, know when a symptom is worth a blood test, keep my mood checked too (because it could be both), and remind me about follow-up — including the yearly thyroid check nobody told me I'd need."* |
| **Health literacy** | Bimodal. The D7 arrival is highly literate and vigilant (she has tracked TSH for a year already). The symptom-first E1 arrival often has **never heard of PPT** — the condition is one of the most under-recognized in postpartum care — and needs low-literacy, reassurance-heavy education from zero. |
| **Tech context** | Web-first, one-handed, 2 a.m. feeding sessions (inherits E1 context). Today she has **no app at all** for this: pregnancy apps have expired, baby apps ignore her, thyroid apps have no postpartum spine, and her TSH results live in a patient portal she checks alone. |
| **Locale** | Arabic-first / RTL first-class; EN/AR/FR/ES. Postpartum thyroid awareness content in Arabic is nearly nonexistent — high-leverage localization. |
| **Emotional state** | Confused and self-doubting. The defining feeling: *"I can't tell whether I'm sick or just a tired mother."* If she had a hyper phase, she may have been told she was "anxious"; in the hypo phase she may be told she's "depressed" — and either, both, or neither may be true. She needs an app that takes the ambiguity seriously without resolving it into a diagnosis. |
| **What she is NOT** | Not diagnosed by Femio — PPT is a clinician's call on labs. Not necessarily ill at all (most at-risk women never develop PPT). Not a hypochondriac to be soothed away — her symptoms deserve a lab, not a platitude. |
| **Primary signals she brings** | `ppt_watch_flag` + antibody status + thyroid lab/med history (from D7); postpartum week, delivery record, EPDS history, feeding status (from E1); new-onset symptom clusters (palpitations/heat intolerance/anxiety vs. fatigue/cold/constipation/weight gain); user-entered TSH results. |
| **Success = she feels watched-over, not alarmed** | She understood the phases, logged symptoms + TSH in one timeline, took the EPDS *alongside* the thyroid watch, walked into her 3- and 6-month checks with an export and questions, and — whether PPT resolved, turned permanent, or never happened — left with the **annual-TSH habit** and a record that will seed her next pregnancy's D7 from day one. |

**Persona thesis.** PPT affects roughly **5–10% of postpartum women** — millions per year — yet it is a product ghost: **no pregnancy, postpartum, or thyroid app addresses it** (§C). Its symptoms are camouflaged as normal postpartum life and as PPD, so it is routinely missed; its hypothyroid phase overlaps the exact window when EPDS screening happens; and **~20–30% (some series up to 50%) of affected women develop permanent hypothyroidism**, with guidelines describing **annual TSH checks thereafter** that almost nobody remembers to do. E7 is small in build cost — it is a watch-layer over E1 reusing D7's lab-log machinery — and large in differentiation: it completes Femio's flagship arc **C8 → D7 → E7 → (B17 / next-pregnancy D7)** and proves the one-account lifespan promise on the least-served condition in the postpartum year.

---

## B. Needs & questions (voice-of-user)

Mined from r/Hypothyroidism, r/Hashimotos, r/thyroidhealth, r/beyondthebump, r/NewParents PPT threads, thyroid-community forums (ThyForLife, Paloma, Mamapedia-type boards), and app-store reviews of postpartum + thyroid apps. Phrasing is representative/composite (community norms; not quoting individuals).

**The signature confusion — "sick, or just a new mom?" (the persona's core):**
- *"Exhausted, freezing, gaining weight, can't think straight at 5 months postpartum. Everyone says 'welcome to motherhood.' My TSH was 28."*
- *"I lost weight fast and felt wired and shaky at 3 months — I thought I was just anxious and under-eating. Turned out to be the hyper phase."*
- *"How is anyone supposed to notice this? Every single symptom is also just… having a baby."*

**The PPD overlap (the second core — often both directions):**
- *"My doctor put me on antidepressants at my 6-week check. Nobody ran a thyroid panel. A year later they found the hypothyroidism."*
- *"Is my low mood postpartum depression or my thyroid? Can it be both?"* (yes — and both deserve attention; Femio routes both, never either/or)
- *"The hyper phase felt exactly like postpartum anxiety. I was told to meditate."*

**Understanding the phases and the arc:**
- *"My endo says I'm in the 'hyper phase' and it will swing hypo. What does that actually look like? When?"*
- *"Do I need medication or does this go away on its own?"* (phase-dependent, clinician's call — education only)
- *"They said it usually resolves in a year. Usually. How do I know if mine is the permanent kind?"*
- *"Why do I keep getting re-tested every few weeks? When does this end?"*

**The at-risk-but-asymptomatic picture (D7 arrivals):**
- *"I'm TPO-positive and just delivered. My endo said 'we'll check you at 3 and 6 months.' What am I watching for in between?"*
- *"I have type 1 diabetes — my OB mentioned my thyroid risk once, at discharge, in a hallway."*
- *"I had PPT after my first baby. What are the odds it happens again?"* (high — recurrence commonly described; education + early-watch framing)

**Follow-up amnesia (the long tail nobody owns):**
- *"My PPT 'resolved' two years ago. I just learned I was supposed to get a TSH every year forever. Nobody told me."*
- *"I was started on levothyroxine postpartum — do I take this for life or do we re-test? I never got a follow-up appointment."*
- *"Planning baby #2 — does my PPT history change anything about the next pregnancy?"* (yes — early thyroid checks; routes to D7-early education)

**Breastfeeding + medication questions (educational only):**
- *"Can I take levothyroxine while breastfeeding?"* (guidelines describe it as compatible — educational framing, clinician confirms)
- *"They offered me a beta blocker for palpitations while nursing — is that safe?"* (strictly "ask your clinician/LactMed" routing)
- *"Does a radioactive uptake scan mean I have to stop breastfeeding?"* (a real clinician conversation — Femio explains that the question exists, never answers it prescriptively)

**Anti-needs / trust-breakers:**
- Being told "that's normal, all moms are tired" by an app — reassurance theatre on a symptom that deserves a lab.
- Being told "you probably have a thyroid condition" by an app — a diagnosis Femio must never make.
- An either/or framing of thyroid vs. PPD — she needs **both** tracks held open.
- Doom content ("permanent hypothyroidism!") without the honest counterweight: most cases resolve, treatment (if needed) is straightforward and clinician-managed.
- Any dosing advice, or a TSH shown as a pass/fail verdict.
- Privacy creep on combined reproductive + mental-health + chronic-disease data.

**Feature requests recurring in communities:**
- One timeline of **symptoms + TSH results + medication + mood** across the postpartum year — "so I can show my doctor the pattern."
- A plain-language phases explainer she can send to a partner/mother who thinks she's "just tired."
- Reminders for the **3-month, 6-month, and annual** thyroid checks (she will forget; everyone forgets).
- "What to ask at my appointment" prompts for the endocrinology conversation she never expected to have.

---

## C. Competitor teardown

The decisive finding: **postpartum thyroiditis is complete whitespace.** It falls into a triple gap — postpartum apps don't do thyroid, thyroid apps don't do postpartum, and pregnancy apps have expired by the time PPT presents (peak onset 1–8 months after delivery).

| Product | Postpartum spine (weeks, recovery, EPDS) | Thyroid labs (TSH entry/trend) | PPT-specific content | PPD-overlap handling | Follow-up reminders (3/6-mo, annual TSH) | Gap for E7 |
|---|---|---|---|---|---|---|
| **Ovia (Postpartum Experience)** | Strong 12-month program, symptom checks, mental health | No structured TSH/lab tracker | None found | PPD content only — no thyroid cross-reference | No | The best postpartum peer never sees a TSH; PPT invisible |
| **Flo (postpartum mode)** | Cycle-return focus, some postpartum content | No | Passing mention in articles at most | PPD content only | No | Thyroid data has no home; privacy history compounds distrust |
| **What to Expect / BabyCenter** | Editorial + community; app pivots to baby | No | Occasional editorial article | Editorial only | No | Mother's labs are not a product surface at all |
| **ThyForLife** | **None** — no postpartum week, no EPDS, no delivery context | **Deep** (TSH/FT4/FT3/antibodies, trends) | A blog explainer exists; no product flow | None | Generic lab reminders only | Thyroid depth with zero postpartum context; can't route mood |
| **BOOST Thyroid** | None | Deep | None in-product | None | Generic | Same — Hashimoto's-focused, postpartum-blind |
| **Paloma Health** | None (US telehealth) | Labs via test kits | Blog content on PPD–thyroid link | Editorial only | Follow-up within their paid care model, US-only | Care-model lock-in; no free tracking spine; no EPDS; US-only |
| **Baby trackers (Huckleberry etc.)** | Baby only | No | No | No | No | The mother — let alone her thyroid — does not exist |

**Whitespace map (the E7 opening).**
- **Nobody** offers: postpartum-week spine **+** TSH entry/trend log **+** PPT phases education **+** dual-routing of overlapping symptoms to *both* thyroid awareness *and* EPDS **+** 3-month/6-month/annual follow-up reminders **+** next-pregnancy continuity — in one account, in Arabic, privacy-first.
- The **annual-TSH long tail** is unowned by any product on the market: after PPT "resolves," every app relationship has ended, but the guideline-described yearly check continues indefinitely. A lifespan account is structurally the only product that can own this — it is Femio's continuity thesis in its purest form.
- E7 is also **cheap**: the lab log, med log, and export are D7 components; the postpartum spine, EPDS, and red-flag layer are E1 components. E7 is mostly *content + routing + reminder cadence*.

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio does **not** diagnose PPT, interpret a TSH, or advise on treatment; it educates, tracks, and routes to clinicians. Numeric figures vary across sources and guideline editions — cite live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH — reconcile 2017 ATA pregnancy/postpartum guideline vs. any later update.]**

**What PPT is, and how common:**
- Postpartum thyroiditis is an inflammation of the thyroid in the first year after delivery (described as also occurring after miscarriage — relevant to E6 sensitivity). NIDDK describes it affecting about **1 in 20 (~5%)** women in the first year; commonly cited ranges are **~5–10%**. ([NIDDK — Thyroid Disease & Pregnancy](https://www.niddk.nih.gov/health-information/endocrine-diseases/pregnancy-thyroid-disease); [ATA — Postpartum Thyroiditis](https://www.thyroid.org/postpartum-thyroiditis/); [Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/15294-postpartum-thyroiditis))
- It is autoimmune in nature — considered a variant of Hashimoto's-type thyroiditis unmasked by the postpartum immune rebound. ([StatPearls (NCBI) — Postpartum Thyroiditis](https://www.ncbi.nlm.nih.gov/books/NBK557646/); [Endotext (NCBI) — Postpartum Thyroiditis](https://www.ncbi.nlm.nih.gov/books/NBK278999/))

**The classic phase pattern (the flagship teaching point):**
- **Hyperthyroid phase:** stored hormone leaks from the inflamed gland; typically appears ~1–4 months (sources: 1–6 months) after delivery and lasts weeks up to ~3 months. Often mild or unnoticed: anxiety, palpitations, irritability, heat intolerance, tremor, insomnia, unintentional weight loss. ([NIDDK](https://www.niddk.nih.gov/health-information/endocrine-diseases/pregnancy-thyroid-disease); [Johns Hopkins](https://www.hopkinsmedicine.org/health/conditions-and-diseases/postpartum-thyroiditis))
- **Hypothyroid phase:** the depleted/damaged gland underproduces; typically ~4–8 months postpartum, lasting up to ~a year: fatigue, cold intolerance, constipation, low mood, brain fog, muscle cramps, weight gain, dry skin. ([Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/15294-postpartum-thyroiditis); [Johns Hopkins](https://www.hopkinsmedicine.org/health/conditions-and-diseases/postpartum-thyroiditis))
- **Not everyone gets both phases.** Some have only hyper, some only hypo, some the full biphasic swing — roughly thirds in commonly cited series. **[NEEDS SOURCE — exact phase-distribution split from primary series at publish.]** ([NIDDK](https://www.niddk.nih.gov/health-information/endocrine-diseases/pregnancy-thyroid-disease))
- **Usual resolution — with an honest asterisk:** thyroid function typically returns to normal within ~12–18 months of onset, **but ~20–30% of affected women (some series 20–50%) develop permanent hypothyroidism**, sometimes years later. This is why follow-up never fully ends. ([ATA](https://www.thyroid.org/postpartum-thyroiditis/); [StatPearls](https://www.ncbi.nlm.nih.gov/books/NBK557646/); [Keely, PMC — PPT predicts future thyroid health](https://pmc.ncbi.nlm.nih.gov/articles/PMC4989649/))

**Risk factors (who gets the watch-layer):**
- **TPO-antibody positivity** is the strongest predictor — described in ~60–85% of PPT cases; women TPO-positive in early pregnancy have a markedly elevated PPT risk (D7 cites up to ~50%). Risk correlates with antibody level. ([StatPearls](https://www.ncbi.nlm.nih.gov/books/NBK557646/); [ATA](https://www.thyroid.org/postpartum-thyroiditis/))
- **Type 1 diabetes**, **prior PPT episode**, **personal history of thyroid dysfunction**, and **family history of thyroid disease** — high-risk groups with prevalence described around ~19–20% (T1DM, family history). ([StatPearls](https://www.ncbi.nlm.nih.gov/books/NBK557646/); [NIDDK](https://www.niddk.nih.gov/health-information/endocrine-diseases/pregnancy-thyroid-disease))
- **Recurrence:** after a prior PPT episode, recurrence in a subsequent pregnancy is high — figures described range ~20% (ATA patient materials) to ~40–70% (reviews; higher in TPO-positive women who recovered). Frame as "substantially more likely — your clinician will likely watch early." **[NEEDS SOURCE — reconcile recurrence figures against primary at publish.]** ([ATA](https://www.thyroid.org/postpartum-thyroiditis/); [Keely, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC4989649/))

**Why it's missed (the product's reason to exist):**
- Symptoms are non-specific and overlap ordinary postpartum life (fatigue, mood, weight, hair, sleep) — culture normalizes maternal exhaustion, so neither mothers nor clinicians reach for a TSH. PPT is widely described as under-diagnosed. ([StatPearls](https://www.ncbi.nlm.nih.gov/books/NBK557646/); [AAFP — Thyroiditis: Evaluation and Treatment](https://www.aafp.org/pubs/afp/issues/2021/1200/p609.html))

**The PPD overlap (route both — never either/or):**
- The hypothyroid phase and postpartum depression share fatigue, low mood, poor concentration, and withdrawal; the hyperthyroid phase mimics postpartum anxiety. Literature describes evaluating thyroid function in women presenting with postpartum mood symptoms, and the two conditions **can coexist**. Femio's rule: PPT-suggestive mood symptoms trigger *both* thyroid-awareness education *and* the EPDS path (E3), in parallel — a thyroid explanation must never delay depression screening, and an EPDS score must never close the thyroid question. ([Thyroid Predictors of Postpartum Mood Disorders, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10586527/); [StatPearls](https://www.ncbi.nlm.nih.gov/books/NBK557646/)) **[NEEDS SOURCE — exact ATA/guideline wording on thyroid testing in postpartum depression at publish.]**

**Monitoring & follow-up (educational cadence — the reminder engine's basis):**
- The Endocrine Society guideline describes **TSH screening at ~3 and ~6 months postpartum** in high-risk women (TPO-positive, type 1 diabetes, prior PPT); ATA materials describe checking at 6–12 weeks in some high-risk groups. ([Endocrine Society CPG — Management of Thyroid Dysfunction during Pregnancy and Postpartum](https://academic.oup.com/jcem/article/97/8/2543/2823170); [ATA](https://www.thyroid.org/postpartum-thyroiditis/))
- During an episode, TSH is typically re-checked every ~4–8 weeks as phases evolve — "your clinician sets the schedule." ([StatPearls](https://www.ncbi.nlm.nih.gov/books/NBK557646/))
- **After PPT: annual TSH indefinitely** — because permanent hypothyroidism can develop years later. This is the single highest-value reminder Femio can own. ([ATA](https://www.thyroid.org/postpartum-thyroiditis/); [Endocrine Society CPG](https://academic.oup.com/jcem/article/97/8/2543/2823170); [Keely, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC4989649/))

**Treatment landscape (education only — never advice):**
- The hyper phase is transient leakage, **not Graves'** — antithyroid drugs are described as not useful; symptomatic treatment (e.g., beta blockers) is a clinician decision, including breastfeeding considerations. Distinguishing PPT-thyrotoxicosis from new/relapsed Graves' is a clinician task (and a reason Femio never labels a phase). ([Endotext](https://www.ncbi.nlm.nih.gov/books/NBK278999/); [AAFP](https://www.aafp.org/pubs/afp/issues/2021/1200/p609.html))
- The hypo phase may be treated with levothyroxine (often ~6–12 months, then a clinician-supervised re-evaluation/taper to see whether the thyroid recovered) — entirely clinician-managed; Femio logs, never doses. ([StatPearls](https://www.ncbi.nlm.nih.gov/books/NBK557646/))
- **Levothyroxine and breastfeeding:** LactMed describes replacement-dose levothyroxine as compatible with breastfeeding, with adequate thyroid hormone also supporting normal lactation — educational framing, confirm with clinician. ([LactMed — Levothyroxine](https://www.ncbi.nlm.nih.gov/books/NBK501003/); [LactMed — Thyroid](https://www.ncbi.nlm.nih.gov/books/NBK501739/))
- Women **started on levothyroxine during pregnancy** (D7 arrivals) face a separate postpartum question — whether to continue, reduce, or stop and re-test — described in the literature as an individualized clinician decision. Femio surfaces "ask about your postpartum medication plan," never an instruction. ([Postpartum Management of Women Begun on Levothyroxine during Pregnancy, PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4663256/))

**Postpartum general (inherited from E1, in scope):** CDC Hear Her urgent warning signs (up to a year); EPDS screening framing incl. the Q10 rule; ACOG fourth-trimester care model; LAM/return-of-fertility education. (See E1 §D.)

---

## E. Feature set (prioritized)

Inherits the full **E1 postpartum spine** (mother-centered home, week-indexed recovery guide, red-flag layer, EPDS, maternal symptom log, visit tracker) and **reuses D7 components** (lab log, med log, export pack). E7 adds a thin, high-leverage **thyroid-watch layer**.

**P0 — must-have (defines E7):**
1. **PPT-watch home strip** on the E1 postpartum home — watch status ("your clinician may check your thyroid around 3 and 6 months"), latest TSH if logged (with lab range, no verdict), next thyroid-check reminder. Quiet by design: for most at-risk users nothing ever happens, and the strip must feel like a seatbelt, not a siren.
2. **TSH log (entry-only), continuous from D7** — TSH ± Free T4/Free T3/antibodies, value + unit + date + lab reference range + postpartum-week-at-draw; trend chart over the postpartum year. No interpretation beyond neutral "outside your lab's range — worth discussing with your clinician."
3. **Phases explainer + "where things stand" timeline** — the hyper → hypo → usual-recovery arc as a visual over her own postpartum weeks, honestly caveated (not everyone gets both phases; ~20–30% permanence; only labs and a clinician can say which phase, if any, she's in). **Never** labels her current state a phase.
4. **Dual-routing symptom log ("sick or just a new mom?")** — the E1 symptom log extended with the thyroid-overlap cluster (palpitations, heat/cold intolerance, tremor, hair loss, weight change, fatigue, anxiety, low mood, brain fog). A PPT-suggestive cluster triggers *awareness* ("these can be ordinary postpartum — they can also be thyroid-related; a simple blood test can help your clinician tell — worth raising") **and, when mood symptoms are present, the EPDS in parallel**. Never either/or, never a diagnosis.
5. **Follow-up reminder engine** — the guideline-described **~3-month and ~6-month** postpartum TSH checks for high-risk users; during an episode, a user/clinician-set re-check cadence; after resolution, the **annual-TSH-for-life** reminder (the long-tail crown jewel — persists after E7 is archived, into B1/B17). Copy always: "your clinician sets your actual schedule."
6. **Medication log (educational), continued from D7** — levothyroxine (or clinician-prescribed symptomatic meds) entry-only, dose-change history, the postpartum "ask about your medication plan" prompt for women who started levothyroxine in pregnancy, breastfeeding-compatibility *education* (LactMed-cited) with clinician routing. **No dosing advice.**
7. **EPDS integration (inherited E1/E3, E7-tuned)** — full E1 EPDS with Q10 crisis rule; E7 adds the two-way education: a high score surfaces "mood symptoms can also have physical contributors like thyroid — mention this screen *and* your thyroid history to your clinician"; a thyroid concern with mood symptoms surfaces the EPDS. Both tracks stay open (E3 co-activation).
8. **Clinician export pack (reused from D7)** — TSH trend + symptom timeline + med history + EPDS dates (consent-gated) + postpartum context + question list, for the GP/OB/endocrinologist conversation.

**P1 — high value:**
9. **Appointment question builder** — "what to ask" lists per moment (first abnormal TSH; starting/stopping levothyroxine; the 12-month re-evaluation; planning the next pregnancy).
10. **Partner/support-person explainer share** — a sendable plain-language "this is postpartum thyroiditis, this is why she's not 'just tired'" card (privacy-gated, no personal data).
11. **Recurrence & next-pregnancy primer** — prior-PPT users get "next time, your clinician will likely check your thyroid early in pregnancy" education; sets the flag that seeds D7-early on a future positive test.
12. **Symptom–TSH correlation view** (descriptive only, reused from D7).

**P2 — enrichment:**
13. Localized endocrinology-navigation content per market (who orders a TSH; AR modesty-aware clinician scripts). 14. "PPT stories" editorial (moderated, non-advice) normalizing the missed-then-found arc. 15. Weaning-window education (symptom timing vs. breastfeeding changes — commonly confused in communities).

**Explicitly OUT of scope for E7 (guardrail):**
- Diagnosing PPT, labeling her current state as "hyper phase"/"hypo phase," or interpreting any TSH as a verdict.
- Any medication advice — starting, stopping, tapering, dosing, or breastfeeding safety *decisions* (education + LactMed citation + clinician routing only).
- Distinguishing PPT from Graves' or from PPD — explicitly framed as clinician tasks.
- Predicting whether her PPT will resolve or become permanent.

---

## F. Content modules

Inherits all **E1 content modules** (body-after-birth, warning signs, emotions & mental health, pelvic floor, sleep, feeding, cycle return, visits, "what nobody told me") and adds the **postpartum-thyroid set**. Medically reviewed, referenced, grade 6–8, EN/AR/FR/ES, RTL-first AR. Every card: citations + "not medical advice / discuss with your clinician"; med/lab cards add "educational, not a prescription."

- **"Your thyroid after birth"** (flagship) — what PPT is, the ~5–10% figure, the immune-rebound story in plain language, and the honest arc: usually temporary, sometimes not, always clinician-managed.
- **"The two phases"** — hyper (~1–4 mo) and hypo (~4–8 mo) explained with symptoms, the "not everyone gets both" caveat, and "only a blood test can tell which — if either — is happening."
- **"Tired mom or thyroid? (or both?)"** — the disambiguation card: which overlaps are ordinary, why a TSH is a cheap and reasonable ask, scripts for raising it ("I'd like a thyroid check — I'm at higher risk / my symptoms fit").
- **"Thyroid and your mood"** — the PPD overlap, honestly: thyroid problems can look like depression, depression is real regardless of thyroid, both can coexist, both deserve care; EPDS + TSH are complementary, not competing. Crisis resources per E1 rules.
- **"Am I at higher risk?"** — TPO antibodies, prior thyroid disease, type 1 diabetes, family history, prior PPT; what the 3/6-month checks are for; "watch" ≠ "will happen."
- **"If you're started on thyroid medication"** — what levothyroxine is, the typical treat-then-re-evaluate arc *as guidelines describe it*, breastfeeding compatibility (LactMed-cited), adherence basics (empty stomach / iron-calcium spacing, carried from D7) — never a dose.
- **"When it doesn't go away"** — permanent hypothyroidism without doom: ~20–30%, manageable, lifelong clinician care, what changes (a daily pill, periodic labs) and what doesn't (her life). Hands off to B17.
- **"The yearly check"** — why annual TSH after PPT, forever; how Femio will remind her; what to tell any new doctor ("I had postpartum thyroiditis in [year]").
- **"Next pregnancy and your thyroid"** — recurrence honestly framed; early-pregnancy thyroid checks as the likely plan; how her Femio history travels with her (→ D7-early).
- **Reachable-but-hidden:** full E1 postpartum library, D7 thyroid-in-pregnancy history content, and full-lifespan library stay one search away.

---

## G. Tools, logs & alerts (compliant framing)

**Logs:** E1 set (recovery, mood, sleep, feeding, EPDS) **plus** thyroid layer:
- **Lab log** (continuous from D7): TSH, Free T4, Free T3, TPOAb, TGAb — value/unit/date/lab range/postpartum week. Entry-only.
- **Medication log** (continuous from D7): levothyroxine or other clinician-prescribed meds, user-entered dose, dose-change history, adherence + spacing flags.
- **Thyroid-overlap symptom cluster** in the symptom log (palpitations, tremor, heat/cold intolerance, hair loss, weight trend, fatigue, anxiety, low mood, brain fog) — tagged so the dual-routing logic can see patterns.

**Tools:** TSH trend chart over postpartum weeks (lab range shown, no verdict) · phases timeline overlay (educational, never "you are here") · symptom–TSH correlation (descriptive) · clinician export pack · appointment question builder · E1 tools inherited.

**Alerts / nudges (opt-in, calm, quiet-by-default, localized/RTL):**
- **~3-month & ~6-month check reminders** (high-risk users): "Guidelines describe a thyroid blood test around now for people with your risk profile — worth asking your clinician." 
- **Episode cadence reminders** (only if she logs an abnormal TSH / active follow-up): user/clinician-set re-check reminders.
- **Annual TSH reminder** (post-PPT, indefinite, survives track changes): "Your yearly thyroid check — a 5-minute blood test your past self scheduled for you."
- **Symptom-cluster nudge** (rate-limited, gentle): "You've logged [fatigue + cold + weight gain] several times — these can be ordinary postpartum, and they can also be thyroid-related. A simple blood test can help your clinician tell." + EPDS offer if mood present.
- **Post-delivery med prompt** (D7-on-levothyroxine arrivals): "Many people's thyroid medication needs change after birth — ask your clinician about your postpartum plan." (Routing, not instruction.)
- **No** diagnostic alerts, **no** phase labels, **no** "your TSH is abnormal" verdicts, **no** dose suggestions.

**Red-flag box (E1 pattern, thyroid-tuned).**
> **⚠ Seek care now**
> Contact your doctor or local emergency number if you have: a racing or pounding heartbeat that won't settle, chest pain, or trouble breathing · fever · severe neck pain or a rapidly swelling neck · confusion or extreme agitation · heavy bleeding, severe headache, or vision changes · thoughts of harming yourself or your baby (any answer other than "never" on the last EPDS question counts — help is available now).
> *Most thyroid changes after birth are gradual and mild — but severe or sudden symptoms always deserve immediate care. This app cannot diagnose or treat.*

**Mandatory compliance wording:** lab surfaces carry the D7 "shown with your lab's reference range — not a diagnosis" line; med surfaces carry the "Femio does not recommend, prescribe, or change medication" line; every screener carries "screening, not diagnosis — discuss with your clinician."

---

## H. EMR fields (core vs persona-specific)

**Core (constant lifespan spine — unchanged through D7→E7):** identity/locale/RTL/consent, DOB, menstrual + pregnancy history, conditions_flagged, medications, `symptoms[]`, `mood[]`, `screener_results[]`, content history. Nothing from D7 is dropped: `labs[]`, `thyroid_meds[]`, `antibody_status`, dose-change history all persist and stay surfaced.

**Postpartum layer (inherited from E1):** delivery date/type, `postpartum_week` (primary key), complication flags, feeding status, EPDS history + Q10 flag, visit tracking, cycle-return date.

**E7-specific (thin layer over E1 + carried D7 fields):**
- `ppt_watch_flag` (arrived from D7, or set at E-onboarding) + `ppt_watch_source` {d7_handoff / risk_declared / symptom_pattern}.
- `ppt_risk_factors[]` {tpo_positive, tg_positive, prior_thyroid_disease, t1dm, family_history, prior_ppt}.
- `labs[]` — same schema as D7, with `pp_week_at_draw` replacing `GA_at_draw`.
- `ppt_episode` {status: none / clinician_followup_active / resolved_reported / permanent_hypo_reported — **all user/clinician-reported, never inferred**, episode_notes, resolution_date}.
- `thyroid_check_reminders` {three_month_done, six_month_done, episode_cadence, `annual_tsh_reminder` {active: bool, anchor_date}} — `annual_tsh_reminder` is **track-independent**: it survives graduation to B1/B17 and any future track.
- `next_pregnancy_thyroid_flag` (prior PPT / permanent hypo → seeds D7-early on a future positive test).
- Provider fields + `clinician_export_history[]` (reused from D7).
- Audit flags: `ppt_education_shown`, `dual_route_fired[]` (records that symptom nudges were awareness + EPDS, not verdicts).

*Sensitivity: reproductive + mental-health (EPDS) + chronic-disease/lab data combined = maximum-sensitivity set; elevated handling per §K.*

---

## I. Personalization rules (wizard → home config)

**Entry resolution (no re-onboarding for D7 arrivals):**
1. **From D7 (primary path):** delivery logged with `ppt_watch_flag` or thyroid dx → E7 auto-offered in the same confirmation as the E-track switch ("Your thyroid history comes with you — Femio will keep a gentle watch this year"). Labs/meds continue; 3/6-month reminders scheduled from delivery date.
2. **From E-track onboarding:** the E1 wizard's conditions question adds "thyroid condition, thyroid antibodies, type 1 diabetes, or thyroid problems in a past pregnancy/postpartum?" → any yes offers the E7 layer.
3. **From E1 in-life (symptom path):** thyroid-overlap symptom cluster logged repeatedly → Femio *offers* the watch layer ("Want to learn about thyroid changes after birth and track this? You can undo anytime.") — offered, never forced (Z1 rule).

**Home config:** E1 postpartum home (recovery hero by week + EPDS cadence + red flags) **plus the PPT-watch strip**. Emphasis by state:
- **Watch-only (most users):** strip is minimal — next-check reminder + one education card. No daily thyroid presence; do not manufacture anxiety.
- **Active follow-up (abnormal TSH / clinician episode reported):** strip promotes to a thyroid card — latest TSH trend, re-check reminder, export shortcut, phase education foregrounded.
- **On medication:** med reminder + adherence surface joins the quick-log row (carried D7 patterns).
- **Symptom-first arrivals:** lead with the low-literacy "Your thyroid after birth" + "Tired mom or thyroid?" sequence before any data-entry ask.
- **Months 9–12:** resolution-awareness content ("many cases settle by a year — your clinician confirms with labs") + annual-habit priming.
- **Hidden-but-reachable:** everything else one tap/search away, per the master model.

**Adaptive tone:** validating and de-gaslighting without alarming. The voice says: *your symptoms are worth a blood test, and they are probably also just a hard season — both can be true.* Never "you're fine," never "you're sick." Mood content is always dignified: a thyroid explanation is never offered as a way to *dismiss* depression.

---

## J. Adaptation triggers (state transitions)

Universal events (positive test, loss, mood-crisis, red-flag, disengagement, toggle-off) are **inherited** from the Master Adaptation Model §6. E7-specific transitions:

### J.1 — INTO E7

| Trigger | Detection | Femio response |
|---|---|---|
| **D7 delivery hand-off (primary)** | Birth logged while `ppt_watch_flag` or thyroid dx active (D7 §J.3) | Offer E7 with the E-track switch; carry labs/meds/antibody status unchanged; schedule 3/6-month check reminders; fire post-delivery medication-plan prompt (routing, not instruction); PPT education sequenced gently over first weeks |
| **Risk declared at E-onboarding** | Wizard: TPO+/thyroid history/T1DM/family history/prior PPT | Activate watch layer over E1; set `ppt_risk_factors[]`; schedule check reminders |
| **E1 symptom pattern** | Repeated thyroid-overlap cluster in symptom log | *Offer* the watch layer + "worth a blood test" education; if mood symptoms present, EPDS offered in the same flow (dual-route) |

### J.2 — WITHIN E7

| Trigger | Femio response |
|---|---|
| **TSH logged outside lab range** | Neutral, non-diagnostic: "outside your lab's reference range — a good thing to discuss with your clinician"; promote strip to active-follow-up state; raise export prominence. No phase label, no verdict |
| **Symptoms + mood logged together** | **Dual route (mandatory):** thyroid-awareness education **and** EPDS screen offered in parallel (E3 co-activation — PPT and PPD can coexist; neither closes the other). Q10 rule fires independently per E1 |
| **EPDS elevated (≥10/≥13)** | Full E1/E3 handling **plus** one-line education: "mood screens and thyroid checks are complementary — mention both to your clinician." Never delays or dilutes the mood-support routing |
| **Medication started/changed (user-logged)** | Record in dose-change history; "labs are often re-checked after changes — your clinician sets timing"; breastfeeding-compatibility education if feeding status = breastfeeding. No commentary on correctness |
| **Severe symptom (racing heart, chest pain, neck swelling, confusion)** | Red-flag layer → seek care now; never "that's your thyroid," never reassurance |
| **Weaning / feeding change logged** | Gentle education: symptom shifts around weaning are common and multi-causal — thyroid remains one possibility for the clinician list |

### J.3 — OUT of E7

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Resolution reported** | User/clinician-reported "thyroid back to normal" (`ppt_episode.status = resolved_reported`) | Celebrate quietly; archive episode (reachable); **activate the indefinite annual-TSH reminder** + "the yearly check" education; graduate with E1 at ~12 months | **B1** (general cycle) or **B17** (thyroid-condition cycle track) with `annual_tsh_reminder` persisting across tracks |
| **Permanent hypothyroidism reported** | User records ongoing clinician-managed hypothyroidism | Supportive "when it doesn't go away" content — no doom; thyroid med/lab logging continues as a lifelong layer | **B17** (living-with-hypothyroidism track), full history intact |
| **Next pregnancy** | Positive test (universal handler) with prior-PPT / thyroid history | Universal positive-test handling **plus** `next_pregnancy_thyroid_flag` → **D7 entered early** with recurrence-aware education ("your clinician will likely check your thyroid early — here's your history, exportable"); labs/meds seed D7 on day one | **D7** (early activation) |
| **Never-developed watch expiry** | ~12 months postpartum, no episode, checks done/declined | Watch layer quietly retires with E1 graduation; risk factors retained on the core record; no annual reminder unless PPT occurred (risk-only users get a one-time "mention your thyroid risk at future checkups" card) | **B1** / prior track |
| **New pregnancy loss** | Universal loss handler | E6 grief handling; thyroid watch data retained silently (PPT can follow pregnancy loss — surfaced only later, gently, never in acute grief) | **E6**, thyroid layer dormant-but-intact |

*All transitions: constant EMR, explicit user confirmation, clinician-referral language, no diagnosis or prescription anywhere.*

---

## K. Compliance flags

1. **No diagnosis — including no phase labels (top guardrail).** Femio never says "you have postpartum thyroiditis," "you're in the hyper/hypo phase," or renders any TSH verdict. Episode status is **user/clinician-reported, never inferred** from labs or symptoms. The phases timeline is population education, never a personal "you are here."
2. **Dual-routing is a safety requirement, not a feature.** Thyroid-overlap mood symptoms must trigger the EPDS path in parallel — thyroid education may never be offered as an alternative to depression screening. EPDS Q10 rule (any non-zero → immediate crisis resources) fires independently of everything, per E1. Crisis resources locale-specific. **[NEEDS SOURCE — vetted crisis directories per locale, incl. Arabic-speaking regions (shared E1 gap).]**
3. **No medication advice.** Levothyroxine/beta-blocker content is educational + LactMed-cited; starting/stopping/tapering/dosing and breastfeeding decisions are clinician-only. The post-delivery "ask about your medication plan" prompt is routing, never an instruction. Non-prescription disclaimer on every med surface.
4. **Reminder ≠ prescription.** The 3/6-month, episode-cadence, and annual-TSH reminders are framed as "guidelines describe / your clinician sets your schedule" — Femio prompts a conversation, it does not order labs. Screening-cadence figures re-verified against live ATA/Endocrine Society text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH — 2017 ATA guideline vs. any later update; Endocrine Society 2012 CPG status.]**
5. **Anxiety-minimization by design.** Most watch-users never develop PPT. The watch layer is quiet-by-default, symptom nudges rate-limited, and permanence statistics always paired with "manageable, clinician-treated, most cases resolve." No fear-based engagement.
6. **Uncertainty honesty.** Figures vary across sources (prevalence 5–10%; permanence 20–30% vs. up-to-50% in some series; recurrence 20–70% depending on population) — content uses ranges and "studies describe," never false precision. Phase-distribution split flagged **[NEEDS SOURCE]** in §D.
7. **Grief sensitivity.** PPT can follow pregnancy loss; any PPT content surfaced on the E6 path obeys the universal loss handler (silence-first, opt-in, never in acute grief).
8. **Privacy — maximum-sensitivity data set.** Reproductive + postpartum mental-health (EPDS) + chronic-disease lab/med data combined: explicit granular revocable consent, no ad/analytics SDK exposure, no employer/insurer visibility, partner-share scoped (explainer card contains no personal data), export/delete honored; GDPR/PDPL special-category handling with regional residency (AR/MENA). Inherits E1's elevated EPDS handling and D7's lab-photo retention rules.
9. **Cross-track reminder persistence.** The annual-TSH reminder outlives E7 (into B1/B17/future tracks) — this persistence must itself be consented, visible in settings, and cancellable anytime (no zombie nudges).
10. **Content integrity.** All clinical content medically reviewed, cited Tier-1 (NIDDK/NCBI/LactMed/CDC) + Tier-2 (ATA/Endocrine Society/AAFP), grade 6–8, EN/AR/FR/ES with RTL parity; safety and crisis copy human-reviewed per locale; reviewer + review date shown.
11. **App-store / device scope.** Tracking + education framing keeps E7 out of regulated-device territory (no diagnostic claims, no phase detection, no treatment guidance); legal review before ship. **[NEEDS SOURCE — current Apple/Google health-app policy mapping at submission (shared D7 gap).]**

---

## Sources

**Clinical — Tier 1 (NIH / NIDDK / NCBI / CDC):**
- [NIDDK — Thyroid Disease & Pregnancy (includes postpartum thyroiditis)](https://www.niddk.nih.gov/health-information/endocrine-diseases/pregnancy-thyroid-disease)
- [StatPearls (NCBI Bookshelf) — Postpartum Thyroiditis](https://www.ncbi.nlm.nih.gov/books/NBK557646/)
- [Endotext (NCBI Bookshelf) — Postpartum Thyroiditis](https://www.ncbi.nlm.nih.gov/books/NBK278999/)
- [Keely (PMC) — Postpartum thyroiditis: an autoimmune thyroid disorder which predicts future thyroid health](https://pmc.ncbi.nlm.nih.gov/articles/PMC4989649/)
- [PMC — Symptoms and Signs Associated with Postpartum Thyroiditis](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4227325/)
- [PMC — Thyroid Predictors of Postpartum Mood Disorders](https://pmc.ncbi.nlm.nih.gov/articles/PMC10586527/)
- [PMC — Postpartum Management of Women Begun on Levothyroxine during Pregnancy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4663256/)
- [LactMed (NCBI) — Levothyroxine](https://www.ncbi.nlm.nih.gov/books/NBK501003/) · [LactMed — Thyroid](https://www.ncbi.nlm.nih.gov/books/NBK501739/)
- [CDC Hear Her — Urgent Maternal Warning Signs](https://www.cdc.gov/hearher/maternal-warning-signs/index.html) (inherited via E1)

**Clinical — Tier 2 (ATA / Endocrine Society / AAFP / academic centers):**
- [American Thyroid Association — Postpartum Thyroiditis (patient page)](https://www.thyroid.org/postpartum-thyroiditis/)
- [Endocrine Society — Management of Thyroid Dysfunction during Pregnancy and Postpartum: Clinical Practice Guideline (JCEM)](https://academic.oup.com/jcem/article/97/8/2543/2823170) · [PubMed record](https://pubmed.ncbi.nlm.nih.gov/22869843/)
- [2017 ATA Guidelines for Thyroid Disease During Pregnancy and the Postpartum (Thyroid/Liebert)](https://www.liebertpub.com/doi/10.1089/thy.2016.0457) (shared with D7)
- [AAFP — Thyroiditis: Evaluation and Treatment (2021)](https://www.aafp.org/pubs/afp/issues/2021/1200/p609.html)
- [Johns Hopkins Medicine — Postpartum Thyroiditis](https://www.hopkinsmedicine.org/health/conditions-and-diseases/postpartum-thyroiditis)
- [Cleveland Clinic — Postpartum Thyroiditis](https://my.clevelandclinic.org/health/diseases/15294-postpartum-thyroiditis)
- [NHS Lothian RefHelp — Post-partum Thyroiditis (referral guideline)](https://apps.nhslothian.scot/refhelp/guidelines/endocrinology/postpartumthyroiditis/) *(nearest NHS-family source found; [NEEDS SOURCE — dedicated NHS.uk / MedlinePlus PPT patient page if one exists at publish])*
- [JCEM — Postpartum Thyroiditis (review)](https://academic.oup.com/jcem/article/87/9/4042/2846380)
- [Annals of Thyroid — Postpartum thyroid disorders (Azizi)](https://aot.amegroups.org/article/view/4336/html)

**PPD-overlap / community-adjacent:**
- [Paloma Health — Postpartum Depression and Your Thyroid: The Hidden Connection](https://www.palomahealth.com/learn/postpartum-depression-thyroid-hidden-connection)
- [ThyForLife — What is postpartum thyroiditis?](https://www.thyforlife.com/postpartum-thyroiditis/)
- [PMC — Postpartum Psychosis as a Consequence of Thyroiditis Versus Relapse: A Diagnostic Dilemma](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10867710/)

**Competitor landscape:**
- [Ovia Health — Postpartum Experience](https://www.oviahealth.com/blog/introducing-ovia-healths-new-postpartum-experience/) · [Ovia Cycle & Pregnancy Tracker (App Store)](https://apps.apple.com/us/app/ovia-cycle-pregnancy-tracker/id570244389)
- [Flo](https://flo.health/) · [ThyForLife](https://www.thyforlife.com/) · [BOOST Thyroid](https://www.boostthyroid.com/) · [Paloma Health](https://www.palomahealth.com/)

*Community insight (r/Hypothyroidism, r/Hashimotos, r/thyroidhealth, r/beyondthebump PPT threads, thyroid-community forums, app-store reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. Cross-links: D7 (arrival via `ppt_watch_flag`, lab/med log continuity), E1 (postpartum spine), E3 (mood co-activation), E6 (loss sensitivity), B1/B17 (graduation + annual-TSH persistence), D7-early (next pregnancy). Numeric figures (prevalence, phase timing/distribution, permanence 20–30% vs. up-to-50%, recurrence range, screening cadence) re-verified against live ATA/Endocrine Society primary text at publish — **[NEEDS SOURCE VERIFICATION AT PUBLISH]**.*
