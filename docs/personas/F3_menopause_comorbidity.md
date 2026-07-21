# Persona F3 — Menopause with pre-existing comorbidity (navigating the transition alongside conditions that complicate it)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, or prevents disease. HRT/MHT and all medication content is **educational, not prescriptive**. Screeners (incl. MRS) are framed as "screening — discuss with a clinician."
> Persona code: **F3** · Band: F (menopause lifespan) · Overlay: one or more chronic-condition modifiers (bone, cardiovascular/HTN, diabetes, breast-cancer history, thyroid, obesity) · Inherits the menopause engine from **F1 (perimenopause)** and the postmenopause layer from **F2 (menopause/postmenopause)** · Shared engines: **B17** (thyroid–cycle), **B18** (screening/prevention), **B19** (gynae/breast cancer survivor — routes here for its menopause layer), **F4** (surgical/induced) · Last research pass: 2026-07-21

---

## A. Persona snapshot

**Who she is.** "Mona," 54. She is in the menopause transition — cycles now 4–6 months apart, drenching night sweats, brittle sleep, brain fog — but she is *not* a healthy 54-year-old the menopause apps were built for. She has **type 2 diabetes** (on metformin), **hypertension** (on an ACE inhibitor and a statin), a **DEXA scan last year showing osteopenia**, and her mother had a hip fracture and her sister had breast cancer. She takes five medications a day and sees a GP, an endocrinologist, and a cardiologist who rarely talk to each other. When she asked about HRT for the night sweats, one doctor said "probably fine," another frowned and said "not with your heart," and a third said "ask your GP." She left more confused than before. She wants the flashes to stop, she is frightened of both her bones and her heart, and she cannot work out whether the treatment that would help one thing might harm another. Arabic-first (also reads English), lives on her phone's browser, deeply private about a health record she considers stigma- and insurance-sensitive.

**The spectrum she represents (Femio adapts within it).** F3 is not one condition — it is *menopause layered over any chronic-disease modifier that changes the calculus*. Femio must handle each, singly and stacked:

| Modifier | What it changes about her menopause |
|---|---|
| **Osteoporosis / low bone density** | Estrogen loss accelerates bone loss (~2%/yr in the years around the FMP); fracture fear is high; bone-protective decisions become urgent; MHT is one option among several she'll discuss. |
| **Cardiovascular disease / hypertension** | The menopause transition itself raises CV risk (BP, LDL, visceral fat); MHT timing/route matters (transdermal preferred at elevated risk); established CVD makes systemic MHT less favorable. VMS can be confused with cardiac symptoms. |
| **Type 2 diabetes / insulin resistance** | Estrogen decline worsens glucose control; VMS/night sweats fragment sleep → worse glucose; weight gain compounds it; medication and monitoring interplay. |
| **Breast-cancer history / survivor** | Systemic MHT is **usually contraindicated** (nuanced, clinician-decided); non-hormonal VMS options move to the front. *(B19 survivors arrive here for the menopause layer.)* |
| **Thyroid disease** | Thyroid symptoms (fatigue, weight, mood, palpitations) overlap heavily with menopause — hard to attribute; dose/monitoring context. *(Shares B17 engine.)* |
| **Obesity / high BMI** | Raises VTE risk (transdermal preferred), CV and diabetes risk, and independently drives VMS; weight framing must be non-shaming. |

**What she lives with.**
- **Menopause symptoms** — the F1/F2 core (VMS, sleep disruption, mood, cognitive fog, urogenital/GSM, joints, palpitations, irregular-then-absent bleeding) — but each one is harder to *attribute* because her conditions produce look-alike symptoms.
- **Symptom–condition confusion** — is this a hot flash or a cardiac symptom? menopause anxiety or a glucose swing? peri fatigue or my thyroid? This ambiguity is a defining, distressing feature.
- **A harder MHT decision** — she cannot use the simple "under 60, within 10 years, low risk" story; her comorbidities move the risk–benefit line, sometimes to contraindication.
- **Polypharmacy** — five-plus daily medicines; a real worry about interactions and about "one more drug."
- **Fragmented, multi-specialist care** — GP + endocrinologist + cardiologist + sometimes oncologist; no one owns the whole picture, and menopause falls through the cracks.
- **Fear on two fronts** — bones and heart, or cancer recurrence and hormones — a genuine sense that helping one problem could worsen another.

**Core emotional drivers.** She wants **one honest place** that sees *both* her menopause *and* her conditions — not an app that assumes she's healthy and cheerfully suggests HRT that might be wrong for her. She wants to understand **how her conditions and her menopause interact** (in plain language, educational), to tell her look-alike symptoms apart enough to know what to raise, to **not be sold a single answer**, and to walk into each of her several appointments organized instead of overwhelmed. She wants to feel that her complexity is *handled*, not that she's a problem.

**Jobs-to-be-done.**
1. Track menopause symptoms *and* condition-relevant readings (BP, glucose, weight, bone/DEXA notes, TSH) in one place, viewable together.
2. Understand her menopause **in the context of each condition** — condition-aware education, not generic menopause 101.
3. Understand the **MHT decision as it applies to *her*** — including when it's usually contraindicated (breast-cancer history) and when route/timing matter (CVD/HTN, VTE risk, diabetes) — always clinician-decided.
4. Learn the **non-hormonal** options that matter more for her (CBT, SSRIs/SNRIs, gabapentin, fezolinetant, lifestyle).
5. Build **interaction awareness** (educational) across her medicines and any menopause options — never a dosing or drug-safety verdict.
6. Prep for **multiple specialists** — a shareable, per-visit pack so each doctor sees the whole picture and menopause stops being skipped.
7. Feel that her conditions and her menopause are held together, honestly and safely.

**Success = she attends her endocrinology, cardiology and GP visits with one coherent picture — symptom trends + her condition readings + a short, condition-aware question list — and the menopause conversation finally happens on informed, individualized footing instead of three contradictory shrugs.**

---

## B. Needs & questions (voice-of-user)

Mined from r/Menopause, r/Perimenopause, diabetes + menopause communities (DiaTribe, DiabetesSisters), breast-cancer survivor forums, and menopause-app reviews (see Sources). Paraphrased to avoid quoting individuals; themes are strongly and repeatedly attested.

**On symptom–condition confusion (a signature F3 pain):**
- "Is this a hot flash or is it my heart? My palpitations and my flushes feel identical and I panic every time."
- "My sugars are all over the place since the night sweats started wrecking my sleep. Which is causing which?"
- "I can't tell my thyroid from my menopause — the fatigue, the weight, the mood are the same on both lists."
- "Every symptom could be the menopause or could be one of my conditions. I never know what to worry about."

**On the harder MHT decision:**
- "Every app just says 'ask about HRT.' None of them know I've had breast cancer. I *can't* take it — stop suggesting it."
- "One doctor said HRT was fine, another said absolutely not with my heart. Who do I believe?"
- "I want the patch, not the pill, because of my clot risk — but nobody explained why until I read it myself."
- "Is there anything for the flashes that *isn't* hormones? Because hormones are off the table for me."

**On polypharmacy & interactions:**
- "I already take five tablets. I'm terrified of adding something that clashes with them."
- "Nobody checks whether all my medicines still make sense together."

**On fragmented care:**
- "My GP, my endocrinologist and my cardiologist never talk. I'm the only one holding the whole story."
- "The menopause just gets dropped — every visit is about the diabetes or the blood pressure, never the flushes ruining my life."
- "I need one summary I can hand each of them so I'm not re-explaining everything in a ten-minute slot."

**On being unseen by the apps:**
- "Menopause apps assume you're healthy. I'm not. They feel written for someone else."
- "I want an app that knows I have diabetes *and* I'm in menopause and doesn't pretend one of them isn't there."

**On privacy:**
- "A breast-cancer flag plus a menopause record is exactly the data I never want sold or seen by an insurer."

**Top recurring questions Femio must answer in-product:**
1. How does my menopause interact with my [diabetes / heart / bones / thyroid / cancer history / weight]?
2. Is this symptom the menopause or my condition — and which ones are worth raising?
3. Can I take HRT with my condition — and if not, why, and what else is there? (education only)
4. What do route and timing of MHT mean for someone with clot / heart / diabetes risk? (education only)
5. Could a menopause option interact with the medicines I already take? (awareness only)
6. What should I protect now — bones, heart, glucose — and what screening should I ask about?
7. How do I get all my doctors on the same page and stop the menopause being ignored?

---

## C. Competitor teardown

Focused on the exact gap F3 exposes: **menopause apps assume a healthy user with unrestricted HRT; chronic-disease apps ignore menopause.** Nobody owns the intersection.

| Product | Built for | Comorbidity awareness | MHT framing for at-risk / contraindicated users | Multi-condition tracking | Multi-specialist visit-prep | Privacy & reach | Where it fails F3 |
|---|---|---|---|---|---|---|---|
| **Balance** (Newson Health) | Peri/menopause tracking + MHT education; GP Health Report | Low — assumes a broadly healthy menopause user | Perceived **HRT-forward**; thin on when MHT is contraindicated or how comorbidity shifts route/timing | Symptom + med log; not condition-reading aware (no BP/glucose/DEXA context) | Single GP report; not built for several specialists | ~£8.99/mo advanced; EN-first | Can nudge HRT at a breast-cancer-history or high-CV-risk user; no condition-interaction education; not Arabic-first |
| **Caria** | Peri/menopause CBT coaching (RCT-backed) | Low | Educational/coaching; not condition-stratified | Symptom tracking + programs | No | ~$78/yr; EN-first | Strong on CBT (useful when hormones are off the table) but not condition-aware; no interaction or multi-visit layer |
| **Health & Her** | Menopause self-care toolkit (ORCHA-rated) | Low | Educational | Symptom/daily assessments | No | Freemium; EN-first | Healthy-user assumption; no comorbidity or polypharmacy awareness |
| **Clue (Perimenopause mode)** | Cycle-adaptive peri tracking | None condition-specific | Thin on MHT decisions | Cycle + symptom | No | Freemium (peri paywalled) | No condition layer; no visit-prep; no interaction education |
| **Flo (Perimenopause Score)** | Broad women's health + peri score | None | Education-light | Broad symptom logging | No | **FTC 2021 + ~$56M 2025 settlement** — trust damage | Healthy-user model; abandons comorbid users; privacy history is disqualifying for a stigma-sensitive record |
| **Diabetes apps** (mySugr, One Drop, etc.) | Glucose/diabetes management | Diabetes-deep, **menopause-blind** | N/A | Glucose/meds only | Diabetes-only | Varies | Track the condition but ignore the menopause fragmenting her glucose and sleep |
| **Cardio / BP apps** (blood-pressure trackers) | Hypertension/CV tracking | CV-deep, menopause-blind | N/A | BP only | CV-only | Varies | No menopause context; can't connect VMS/sleep to CV picture |
| **Oncology / survivor apps** (Outcomes4Me, OWise) | Cancer navigation/tracking | Cancer-deep | Menopause treated as a side-effect line item, not owned | Some symptom tracking | Oncology-oriented | US/EN-first | Menopause + GSM are afterthoughts; not Arabic-first or whole-lifespan (see B19) |

**Cross-cutting failure #1 — the intersection is empty.** Menopause apps assume health; disease apps ignore menopause. A woman who is *both* menopausal *and* diabetic/cardiac/osteopenic/a survivor has to run two apps that never speak — and neither tells her how the two interact. Femio owns the intersection: one account, condition-aware menopause education, both symptom trends and condition readings in one view.

**Cross-cutting failure #2 — unsafe MHT framing for at-risk users.** Menopause apps can present HRT as straightforwardly available. For a breast-cancer survivor that is potentially harmful framing; for a high-CV-risk or high-VTE-risk woman it skips the route/timing nuance that matters. Femio's MHT content is **risk-stratified, contraindication-aware, and always clinician-decided** — and foregrounds non-hormonal options where hormones are off the table.

**Cross-cutting failure #3 — no polypharmacy or multi-specialist reality.** None of the menopause apps acknowledge that F3 takes five medicines and sees three doctors. Femio adds **interaction *awareness* (educational)** and a **per-specialist visit-prep pack** so the whole picture travels to each visit and menopause stops being dropped.

**Cross-cutting failure #4 — quality & reach.** Per the BMC Women's Health systematic review of 28 menopause apps (2023), only ~22.7% used evidence-based information and ~27.3% had medical-professional involvement — and essentially none are built for the comorbid user or Arabic-first. Femio's referenced, medically-reviewed, grade 6–8, multilingual, privacy-by-design content is the wedge.

---

## D. Clinical grounding (cited)

> All framing below is **educational**. Femio never diagnoses, never recommends starting/stopping/changing any therapy, never doses, and never issues a drug-interaction or drug-safety verdict. Every item routes to "discuss with your clinician."

**Menopause layers over the F1/F2 core.** Menopause is confirmed clinically and retrospectively after **12 months of amenorrhea**; the transition and its 34+ symptom set are staged by **STRAW+10**, and in women ≥45 diagnosis is **clinical, not biochemical** (NICE NG23). F3 inherits all of this from F1/F2 and adds the condition modifiers below [WHO; NICE NG23; STRAW+10 — see F1 sources].

**MHT risk stratification by age/timing (the baseline the comorbidity modifies).** Per **The Menopause Society (NAMS) 2022 Hormone Therapy Position Statement**, the benefit–risk balance is favorable for **symptomatic women aged <60 or within 10 years of menopause onset with no contraindications**, and **less favorable initiated >10 years out or age >60** (greater absolute risk of CHD, stroke, VTE, dementia). MHT **should not be used for cardiovascular disease prevention**. **Transdermal estradiol and lower doses may reduce VTE/stroke risk** and are generally preferred at elevated thrombotic risk. Care is **individualized, shared decision-making** [NAMS 2022].

**Breast-cancer history — usually a contraindication (nuanced, clinician-decided).** Systemic MHT is generally **contraindicated in breast-cancer survivors**, informed by the **HABITS and Stockholm** trials (HABITS showed increased relapse; reinforced at longer follow-up). For these women, **non-hormonal VMS management moves to first line** — **venlafaxine** is a common first-line non-hormonal agent; **paroxetine, gabapentin, oxybutynin, clonidine** are options; and **CBT, clinical hypnosis, paced breathing, acupuncture** have supporting evidence. The decision (including any localized/vaginal options) is **oncologist/clinician-led** — Femio educates, never advises [Nonpharmacological therapies review, Support Care Cancer 2020; SOGC Guideline No. 422f Menopause and Breast Cancer]. *(B19 survivors route here for this layer.)*

**Cardiovascular disease / hypertension.** The **AHA 2020 Scientific Statement (El Khoudary et al., Circulation)** finds the menopause transition itself — independent of chronological aging — is associated with **accelerated CV risk**: rising **hypertension** (the most prominent modifiable risk factor), adverse **lipid** shifts (↑LDL, ↑ApoB), metabolic syndrome, and vascular remodeling; it frames the transition as an **early-prevention window**. For MHT, **established CVD makes systemic therapy less favorable** (NAMS 2022), and **NICE NG23** directs that women with a personal history of CHD/stroke discuss HRT with a menopause-expert clinician; **transdermal** routes are preferred at elevated VTE/CV risk. Femio frames this as **know-your-risk + discuss screening/monitoring**, never prevention/treatment [AHA 2020; NAMS 2022; NICE NG23].

**Symptom–symptom confusion (VMS vs cardiac vs anxiety).** Hot flashes, palpitations and anxiety/panic **share features** (sudden heat, racing heart, sweating, dread) and are genuinely hard to tell apart; anxiety is strongly associated with VMS frequency/severity. Femio's role is to help her *notice and describe* patterns to raise with a clinician — **never to reassure that a symptom is "just menopause" and not her heart, and never to alarm** [Cleveland Clinic; Harvard Health; anxiety–hot-flash association study, Maturitas/PubMed].

**Type 2 diabetes / insulin resistance.** Falling estrogen is associated with **insulin resistance and higher blood glucose**; **VMS and night sweats fragment sleep**, which further worsens glucose control and drives weight gain; severe VMS has been associated with higher fasting glucose/insulin and higher diabetes risk. The bidirectional loop (glucose ↔ sleep ↔ VMS ↔ weight) is a core F3 education point. Menopause can also change how diabetes medicines and monitoring feel — a **clinician-review** cue, never a dosing change [Menopause and glucose reviews; leptin/adiponectin–IR + hot-flash study, PMC; Endocrine Society patient education].

**Osteoporosis / bone.** Estrogen loss is the **major driver of postmenopausal bone loss**: resorption accelerates **1–2 years before the FMP** and BMD can fall **~2%/yr in the 3–5 years after** it, raising osteoporosis and fracture risk; risk is modified by age, low body weight, smoking, alcohol, corticosteroids and certain endocrine/autoimmune disease. MHT reduces fracture risk and is **one option** clinicians weigh alongside bisphosphonates/denosumab and lifestyle. Femio frames this as **"know your risk, ask about DEXA/bone screening,"** never prevention/treatment [Endocrine Society — Menopause and Bone Loss; Bone and the Perimenopause, PMC/NIH].

**Thyroid overlap.** Thyroid symptoms (fatigue, weight change, mood, palpitations, cognitive change) **overlap heavily** with menopause, making attribution hard; F3 shares the **B17** thyroid–cycle engine and treats labs/dose as **user-entered context, no interpretation** [shares B17 grounding; NICE NG23 on distinguishing causes].

**Obesity / high BMI.** High BMI **raises VTE risk** (NICE NG23 → **transdermal HRT preferred**), compounds CV and diabetes risk, and independently increases VMS burden. Weight content must be **non-shaming**, framed around symptom/health support, never appearance [NICE NG23; NAMS 2022].

**Polypharmacy & multi-specialist coordination.** Managing **five-plus medicines** across multiple specialists is associated with interaction risk, adverse events, and menopause "falling through the cracks"; a coordinating clinician and periodic **medication review/reconciliation** are the recommended answer. Femio supports this with **educational interaction *awareness*** and **per-visit prep** — it is **not** a medication-management, reconciliation, or drug-interaction-checking device [StatPearls — Reducing Polypharmacy in Older Adults; medication-management-in-multimorbidity review, PMC].

*[NEEDS SOURCE] — (a) Any per-condition MHT-eligibility percentages or "how many survivors are told X" figures are directional from secondary/commentary sources; verify against primary data before public use. (b) The exact ordering/first-line status of individual non-hormonal agents varies by guideline and region (SOGC vs NAMS vs NICE) — confirm the specific claim per locale before publishing. (c) Diabetes-medication-and-menopause interplay specifics beyond the sleep/glucose loop are largely secondary sources — verify before public claims.*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Condition-aware menopause mode** — F1/F2 menopause engine (uncertainty-first cycle view where cycles remain, no "late," 34+ symptoms, MRS) **plus** an active **condition record** (bone, CV/HTN, diabetes, breast-cancer history, thyroid, obesity) that skins content, ordering and awareness.
2. **Multi-condition tracking in one view** — menopause symptoms **and** condition-relevant readings the *user* enters (BP, glucose, weight/BMI, DEXA/bone notes, TSH, MHT/med log) viewable together over time — the thing no competitor offers.
3. **Symptom-attribution helper (educational)** — for look-alike clusters (VMS vs cardiac/anxiety; fatigue/mood vs thyroid; glucose swings vs sleep/VMS): describes overlap, helps her *record and characterize* patterns to raise with a clinician; **never attributes, never reassures, never alarms.**
4. **Condition-aware MHT education (risk-stratified, contraindication-aware)** — the NAMS/NICE/AHA picture applied to *her* modifiers: usually-contraindicated with breast-cancer history; route/timing (transdermal, lower-dose) for CV/VTE/obesity risk; diabetes context — always clinician-decided, non-prescriptive.
5. **Non-hormonal options, foregrounded** — CBT, SSRIs/SNRIs (venlafaxine/paroxetine), gabapentin, fezolinetant, clinical hypnosis, lifestyle — surfaced first when hormones are off the table.
6. **Interaction *awareness* (educational)** — flags that "this is worth discussing with your clinician/pharmacist" when menopause options and her recorded medicines are ones commonly reviewed together; **no interaction verdict, no dosing, no safety ruling.**
7. **Multi-specialist visit-prep pack** — generate a per-visit, per-specialist summary (menopause trends + relevant condition readings + condition-tailored questions) so GP, endocrinologist, cardiologist and oncologist each get the whole picture and menopause isn't dropped.
8. **Condition-aware validation + long-term-health framing** — bones, heart, glucose: "know your risk, ask about screening" — no prevention/treatment claims.
9. **Privacy-by-design** — condition flags (esp. breast-cancer history) are among the most stigma/insurance-sensitive data; no ad-SDK/third-party sharing; granular consent; export/delete.
10. **Free, reachable core** — depth not paywalled to exclusion; Arabic-first/RTL + EN/FR/ES.

**P1 — strong differentiators.**
11. **Per-condition education modules** (menopause-with-diabetes, -with-CVD/HTN, -with-osteoporosis, -after-breast-cancer, -with-thyroid, -with-high-BMI) — condition-specific, referenced, medically reviewed.
12. **CBT-based programs** for VMS/sleep/mood — especially valuable when MHT is contraindicated.
13. **MHT/med log (educational)** — if clinician-prescribed, log type/route/dose + symptom response for review; never suggests starting/changing.
14. **Screening-reminder awareness** — DEXA/bone, lipids/BP, HbA1c, mammography (links B18) framed as "ask your clinician about," dismissible, non-alarming.

**P2 — depth / retention.**
15. Condition-state re-layering when a new condition is recorded or a status changes (e.g., new osteoporosis diagnosis, breast-cancer history added → MHT content re-skins).
16. Partner/family explainer export (optional) to reduce isolation.
17. Moderated, referenced community/expert surface.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Menopause when you also have a health condition** — the F3 orientation: your menopause is real *and* your conditions matter; how Femio holds both; why generic menopause advice may not fit you.
2. **Telling your symptoms apart (education)** — VMS vs palpitations/anxiety vs cardiac; menopause fatigue/mood vs thyroid; glucose swings vs sleep/VMS — overlap explained, how to describe patterns to a clinician, when to seek care. Never "it's just menopause."
3. **HRT/MHT when you have a condition (education only)** — the age/timing baseline (NAMS timing hypothesis) and how **breast-cancer history (usually contraindicated), CVD/HTN, VTE/clot risk, diabetes, high BMI** shift route (transdermal), timing and eligibility — always clinician-decided; clear non-prescription disclaimer.
4. **When hormones are off the table — non-hormonal options** — CBT, venlafaxine/paroxetine/SSRIs-SNRIs, gabapentin, fezolinetant, clinical hypnosis, lifestyle — what they are and why a clinician might discuss them. Education only.
5. **Menopause & your heart** — the AHA early-prevention window, BP/lipids/visceral fat, VMS-and-CV context; "know your numbers, ask about screening." No prevention claims.
6. **Menopause & your bones** — estrogen and accelerated bone loss, fracture-risk modifiers, DEXA, the range of options (MHT, bisphosphonates, lifestyle) a clinician may weigh. Education only.
7. **Menopause & your blood sugar** — the estrogen–insulin link and the sleep↔VMS↔glucose↔weight loop; why control may shift; "review with your diabetes team." No dosing.
8. **Menopause after breast cancer** — treatment-induced/natural menopause with a cancer history, why systemic hormones are usually off the table, non-hormonal and GSM options, working with your oncology team. (Bridges B19.)
9. **Menopause & your thyroid** — overlapping symptoms, attribution, working with labs/dose your clinician manages. (Bridges B17.)
10. **Your medicines & the menopause (awareness, not advice)** — why polypharmacy deserves a periodic medication review; questions to ask your pharmacist/clinician; what to bring. No interaction verdicts.
11. **Getting all your doctors on the same page** — coordinating GP + specialists, using your Femio visit-prep pack, making sure menopause isn't skipped.
12. **Myths vs evidence** — "HRT is always dangerous," "you can never take anything if you've had cancer," "menopause has nothing to do with my diabetes/heart," "there's nothing to do but suffer."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, **no prescriptive/dosing language for any medication or MHT**, and **no drug-interaction or drug-safety verdicts.**

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Menopause symptom + cycle log** — inherited F1/F2: 34+ symptoms, VMS frequency/severity, sleep, mood, cognitive, GSM, joints, palpitations; uncertainty-first cycle/bleed view + days-since-last-bleed where cycles remain (no "late").
- **Condition-reading logs (user-entered, no interpretation)** — BP, glucose/HbA1c notes, weight/BMI, DEXA/bone notes, TSH/thyroid labs — all entry-only, no verdicts, viewable alongside menopause symptoms.
- **MHT/medication log (educational)** — if clinician-prescribed: type/route/dose, start/stop, symptom response; plus a user-maintained **medication list** for visit-prep. Bring-to-clinician artifact only; **no medication management, no reconciliation, no interaction checking.**

**Tools**
- **MRS screener** — 11 items, 3 domain sub-scores + total (0–44), trend → "screening, not a diagnosis; discuss with a clinician."
- **Symptom-attribution helper** — descriptive overlap education + pattern-capture for look-alike clusters; outputs *questions to ask*, never attributions.
- **Condition-aware MHT explainer** — interactive education that reflects her recorded modifiers (e.g., surfaces "usually contraindicated — non-hormonal options" for breast-cancer history; "transdermal often preferred at clot/CV risk — discuss") — non-prescriptive.
- **Interaction-awareness surface** — "worth reviewing with your clinician/pharmacist" prompts around recorded medicines + menopause options; **educational only**, links to module 10.
- **Multi-specialist visit-prep generator** — one-tap, per-specialist export: menopause trends + relevant condition readings + condition-tailored question set + medication list.
- **CBT program** — structured self-help (education/self-management framing).

**Alerts (non-alarming, screening-framed, dismissible, localized/RTL)**
- **Symptom-overlap prompt** — when a look-alike cluster is logged (e.g., palpitations + chest awareness): "Some symptoms overlap between menopause and heart/thyroid conditions — worth noting for your clinician." Never triage, never reassure.
- **Screening-awareness nudges** — DEXA/bone, BP/lipids, HbA1c, mammography (links B18): "A good time to ask your clinician about [screening]." Educational.
- **Medication-review awareness** — periodic "many people review their full medication list with a clinician/pharmacist once a year — bring your list." No interaction claims.
- **12-month amenorrhea milestone** (inherited) → menopause typically confirmed clinically; route toward F2 postmenopause + long-term bone/CV/GSM emphasis.
- **Abnormal-bleeding awareness** (inherited) → flooding / very frequent / any bleeding after a 12-month gap: "worth discussing with a clinician."
- Low-mood screen follow-up + localized crisis resources.
- **Never:** an MHT recommendation or a "you can/can't take HRT" verdict; a drug-interaction or drug-safety ruling; a "this symptom is/ isn't your heart/cancer" reassurance or alarm; disease-prevention claims; contraception/"safe day" claims.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off); export/delete.
- Life-stage / mode flag (here: **menopause mode ON**, with **comorbidity layer ON**; STRAW+10 stage hint; peri vs postmenopause).
- Cycle events where present (uncertainty-first range/trend, days-since-last-bleed); generic symptom/mood/energy/sleep log.
- **meds_supplements[]** (constant core) — the medication list F3 leans on for visit-prep.

**Persona-specific (menopause + comorbidity)**
- **Condition record (modifiers[]):** osteoporosis/low-BMD, cardiovascular disease/HTN, type 2 diabetes/IR, breast-cancer history (survivor flag → B19 link), thyroid disease, obesity/high-BMI — each a stackable boolean/state with entry-only detail.
- **34+ menopause symptom fields** (inherited F1/F2): VMS, night sweats, sleep, mood, cognitive, GSM, joints, palpitations, headaches, libido, weight/body changes, bleeding-change flags.
- **Condition-reading fields (entry-only, no interpretation):** BP, glucose/HbA1c notes, weight/BMI, DEXA/bone notes, lipid notes, TSH/thyroid labs.
- **MRS records:** item scores, 3 domain sub-scores, total, date (history/trend).
- **MHT/med log (educational):** on-therapy y/n, type (estrogen-only/combined), route (transdermal/oral/vaginal), dose, start/stop, symptom response — entry only, not medication management.
- **Non-hormonal/CBT usage self-report** (optional).
- **Contraindication-context flags** (derived from condition record, educational): e.g., breast-cancer-history → MHT-usually-contraindicated content skin; high VTE/CV/BMI → transdermal-emphasis content skin. **These skin education only; never a clinical verdict.**
- **TTC intent flag = false** by default; reachable toggle; contraception-awareness note where relevant.
- Amenorrhea counter (days since last bleed) driving the 12-month milestone → F2 route.

*All health fields optional, encrypted, user-deletable. Condition flags — especially breast-cancer history — are high-sensitivity: extra consent friction, never shared, never used for ads/analytics. The MHT/med log and interaction-awareness surface are educational tracking, **not** medication management, reconciliation, or an interaction-checking/medical-device feature.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (F3).** Reached from Q6 (menopause) when **comorbidity** is indicated, or when a condition is recorded from within F1/F2, or when a **B19 survivor** enters the menopause layer:
- Q: life stage / cycles → menopause transition or postmenopause ⇒ menopause engine (inherits F1 uncertainty-first / F2 postmenopause).
- Q: "Do you have any health conditions your doctors are managing?" (multi-select: bone/osteoporosis, heart/blood pressure, diabetes, breast-cancer history, thyroid, weight/obesity, other) ⇒ sets the **condition record (modifiers[])**; each selection layers its content skin and awareness.
- Q: "Are you currently using HRT/MHT?" → yes ⇒ surface **MHT/med log**; no ⇒ surface **condition-aware options education** (non-hormonal foregrounded where a contraindication modifier is present).
- Q: "Which doctors do you see for these?" (GP/endo/cardio/oncology/other) ⇒ configures **multi-specialist visit-prep** targets.
- Q: top symptoms (multi-select) ⇒ orders home cards.

**Home configuration (default for F3):**
- **Hero = condition-aware menopause overview** — menopause trend/MRS status **with** the most-acute condition context surfaced (per blending rule: most-acute-emphasis wins the hero).
- **Multi-condition tracking card** pinned (menopause symptoms + her recorded readings together).
- **MRS card** pinned; **symptom-attribution helper** surfaced when look-alike clusters are logged.
- **Condition-aware MHT/options education** pinned — **non-hormonal foregrounded** when a contraindication modifier (breast-cancer history) is present.
- **Multi-specialist visit-prep** pinned.
- **Screening-awareness + medication-review** cards surfaced by condition record.
- Fertile-window / pregnancy / TTC widgets hidden by default (reachable).

**Modifier blending (per Master §8):**
- **Union of safety layers** — all applicable awareness sets shown; overlapping ones merged, not double-counted (e.g., high-BMI VTE emphasis ⊇ general transdermal emphasis).
- **Most-acute-emphasis wins the hero** — e.g., breast-cancer history + VMS + osteopenia → hero = non-hormonal VMS options + survivor-menopause framing; strips = bone-health awareness + visit-prep; oncology added to visit-prep targets.
- **Distinct paths stay distinct** — natural menopause-with-comorbidity (F3) vs **surgical/induced** (F4) vs **active-treatment survivor** (B19) are kept distinct even when they share the non-hormonal engine; keyed on *how menopause arose* and *treatment status*.

**Adaptive tuning:** new condition recorded ⇒ re-layer content + re-skin MHT education (e.g., breast-cancer history added ⇒ non-hormonal foreground, MHT-usually-contraindicated framing). Rising MRS psychological sub-score ⇒ mood/CBT + crisis resources. Repeated glucose/BP/weight logs alongside VMS ⇒ surface the relevant interplay module + visit-prep. On-MHT + symptom relief ⇒ "prepare for your review."

**Hidden-but-reachable principle:** Femio never removes knowledge. All menopause, condition, MHT, non-hormonal, TTC/fertility and other-life-stage content stays discoverable via search and "Explore other life stages" — condition awareness changes *emphasis and defaults*, never *access*.

---

## J. Adaptation triggers (life-stage routing)

Inherits all **universal events** from Master Adaptation Model §6 (positive test, loss, mood-screen/crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). F3-specific transitions below.

| Trigger | System response | Route |
|---|---|---|
| **New condition recorded** (osteoporosis, CVD/HTN, diabetes, thyroid, high-BMI, or **breast-cancer history**) | Layer the condition's content skin + awareness; **re-skin MHT education** to the new risk picture (breast-cancer history ⇒ MHT-usually-contraindicated + non-hormonal foreground); add specialist to visit-prep targets | **Stay F3**, add/blend modifier |
| **B19 survivor enters the menopause layer** | Adopt F3 menopause engine over the survivor record; systemic-MHT-usually-contraindicated framing; non-hormonal + GSM foregrounded; carry surveillance/oncology into multi-specialist visit-prep | **B19 → F3 (menopause layer)**, survivor flag retained |
| **Condition state changes** (e.g., new DEXA result, BP/glucose control shifts, cancer remission/recurrence status) | Re-layer content + awareness + screening cadence to the new state; update visit-prep; never a verdict on the change | **Stay F3**, re-layer |
| **12 consecutive months of amenorrhea logged** | Milestone prompt (inherited); transition → **postmenopause** content; emphasize long-term bone/CV/GSM given her modifiers; retire cycle prediction | **Route to F2 (postmenopause)**, comorbidity layer retained |
| **Cycles still present / early transition + comorbidity** | Keep F1 uncertainty-first cycle engine under the comorbidity layer | **Blend F1 + F3** |
| **Surgical / induced menopause with comorbidity** (oophorectomy, chemo/radiation, GnRH self-reported) | Recognize abrupt/severe onset; earlier bone/CV emphasis; MHT education per condition + induction; sensitive framing | **Route to / blend F4**, comorbidity retained |
| **Symptom-overlap cluster logged** (VMS+palpitations, fatigue+mood, glucose+sleep) | Surface symptom-attribution helper + relevant interplay module + visit-prep; **never triage/reassure/alarm** | **Stay F3**, raise attribution + screening prominence |
| **MHT/medicine + condition combination recorded** | Surface **interaction-awareness** + medication-review prompt (educational); route to clinician/pharmacist | **Stay F3**, educational only |
| **MRS psychological sub-score trends high / crisis flag** | Mood/CBT module + localized crisis resources (inherited) | **Stay F3** |
| **User toggles off comorbidity layer / menopause mode** | Revert to F1/F2 or general logic; preserve all history and condition record (archived-but-reachable) | General band / F1 / F2 |

All transitions require **explicit user confirmation**, preserve data continuity (constant EMR, additive layers), and never lock her out of prior or other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, **not contraception**, **not medication management**. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **MRS & all screeners:** always "This is a screening tool, not a diagnosis — discuss your results with a clinician." Never output "You are in menopause," "You have [condition]," or "This symptom is/ isn't your heart/cancer."
- **MHT/HRT content & log:** **educational only**, risk-stratified and contraindication-aware — explain how age/timing *and each comorbidity* shift the picture (breast-cancer history usually contraindicated; CV/VTE/obesity → route/timing; diabetes context) — **never recommend, initiate, dose, or advise starting/stopping/changing** therapy, and **never issue an eligibility verdict** ("you can/can't take HRT"). Clear non-prescription disclaimer everywhere hormones appear.
- **Non-hormonal / medication content** (SSRIs/SNRIs, gabapentin, fezolinetant, and all her chronic-condition medicines): educational context only; no recommendation, no dosing, clinician routing.
- **Interaction awareness:** **educational only** — may say "worth reviewing with your clinician/pharmacist"; **never** a drug-interaction, drug-safety, or reconciliation verdict. Not a medication-management or interaction-checking device.
- **Symptom attribution:** the attribution helper educates on overlap and captures patterns to raise with a clinician; it **never** attributes a symptom to a cause, **never reassures** ("just menopause, not your heart"), and **never alarms**.
- **Condition-reading logs (BP, glucose, DEXA, TSH, weight):** entry-only, no interpretation, no thresholds-as-verdicts; awareness prompts route to clinician screening/monitoring.
- **Long-term health (bone/CV/glucose):** framed as "know your risks, discuss screening" — no prevention/treatment claims.
- **Weight/BMI:** non-shaming, health/symptom-framed, never appearance-framed.
- **Mental health:** localized crisis resources on any low-mood screen or high MRS psychological sub-score.
- **Privacy (GDPR/PDPL health data):** menopause symptoms, MRS, MHT/med log **and condition flags (esp. breast-cancer history)** = special-category with extra sensitivity; explicit granular consent, purpose limitation, **no ad-SDK/third-party sharing** (post-Flo trust), no employer/insurer visibility; local-first where feasible; full export/delete; DPIA + data-mapping before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; tracking/education framing keeps out of regulated-device territory — legal review before store submission.
- **[NEEDS SOURCE]** flags retained (see Section D) on per-condition eligibility figures, region-specific non-hormonal first-line ordering, and diabetes-medication interplay specifics until primary sources confirmed.

---

## Sources

**Clinical — Tier 1 (NIH / NIA / NHS / MedlinePlus / gov / society patient-education):**
- [Menopause — WHO fact sheet](https://www.who.int/news-room/fact-sheets/detail/menopause)
- [Menopause — MedlinePlus (NIH)](https://medlineplus.gov/menopause.html)
- [Symptoms of menopause and perimenopause — NHS](https://www.nhs.uk/conditions/menopause-and-perimenopause/symptoms/)
- [Menopause and Bone Loss — Endocrine Society (patient library)](https://www.endocrine.org/patient-engagement/endocrine-library/menopause-and-bone-loss)
- [Bone and the Perimenopause — PMC (NIH)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3920744/)
- [Hot Flashes, Anxiety and Menopause: What's the Connection? — Cleveland Clinic](https://health.clevelandclinic.org/hot-flashes-anxiety)
- [Heart Beat: Hot flashes and the heart — Harvard Health](https://www.health.harvard.edu/newsletter_article/Heart_Beat_Hot_flashes_and_the_heart)

**Clinical — Tier 2 (Menopause Society/NAMS, NICE, AHA, Endocrine Society, SOGC, peer-reviewed):**
- [The 2022 Hormone Therapy Position Statement of The North American Menopause Society — Menopause (journal)](https://journals.lww.com/menopausejournal/fulltext/2022/07000/the_2022_hormone_therapy_position_statement_of_the.4.aspx)
- [2022 NAMS Hormone Therapy Position Statement — PDF (menopause.org)](https://menopause.org/wp-content/uploads/professional/nams-2022-hormone-therapy-position-statement.pdf)
- [The 2022 NAMS Hormone Therapy Position Statement — PubMed](https://pubmed.ncbi.nlm.nih.gov/35797481/)
- [The 2023 Nonhormone Therapy Position Statement of The North American Menopause Society — PubMed](https://pubmed.ncbi.nlm.nih.gov/37252752/)
- [Menopause: identification and management — NICE guideline NG23](https://www.nice.org.uk/guidance/ng23/chapter/recommendations)
- [Menopause Transition and Cardiovascular Disease Risk: Implications for Timing of Early Prevention — AHA Scientific Statement (Circulation, 2020), PubMed](https://pubmed.ncbi.nlm.nih.gov/33251828/)
- [Clinical impact of the 2020 AHA statement on menopause and cardiovascular disease risk — Cleveland Clinic Journal of Medicine](https://www.ccjm.org/content/89/1/13)
- [Guideline No. 422f: Menopause and Breast Cancer — SOGC / J Obstet Gynaecol Can](https://www.jogc.com/article/S1701-2163(21)00747-7/abstract)
- [Nonpharmacological therapies for menopausal vasomotor symptoms in breast cancer survivors — Support Care Cancer (2020), PubMed](https://pubmed.ncbi.nlm.nih.gov/32940768/)
- [Non-hormonal strategies for managing menopausal symptoms in cancer survivors: an update — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6445536/)
- [Managing menopause Part 2: Hormone therapy and breast cancer, cardiovascular disease, and premature ovarian insufficiency — BC Medical Journal](https://bcmj.org/articles/managing-menopause-part-2-hormone-therapy-and-breast-cancer-cardiovascular-disease-and)
- [Circulating leptin/adiponectin, insulin resistance and hot flashes in postmenopausal women — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5407749/)
- [The role of anxiety and hormonal changes in menopausal hot flashes — PubMed](https://pubmed.ncbi.nlm.nih.gov/15879914/)
- [Hormonal Changes During Menopause and Their Impact on Bone Health — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12464279/)

**Polypharmacy / multi-specialist coordination:**
- [Strategies to Reduce Polypharmacy in Older Adults — StatPearls (NCBI)](https://www.ncbi.nlm.nih.gov/books/NBK574550/)
- [Challenges and Strategies in Medication Management for Patients With Multiple Comorbidities — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12257869/)

**App-quality evidence & competitor landscape:**
- [A systematic review of menopause apps with an emphasis on osteoporosis — BMC Women's Health (2023)](https://bmcwomenshealth.biomedcentral.com/articles/10.1186/s12905-023-02612-9)
- [Navigating Menopause and Perimenopause with Diabetes — DiaTribe](https://diatribe.org/diabetes-management/navigating-menopause-and-perimenopause-diabetes)
- [How Menopause Affects Diabetes, Weight, and Your Medications — DiabetesSisters](https://diabetessisters.org/resources/how-menopause-affects-diabetes-weight-and-your-medications/)
- [Balance — Newson Health menopause app](https://www.balance-menopause.com/balance-app/)
- [Outcomes4Me — cancer care navigation](https://www.outcomes4me.com/)

**Cross-references (Femio internal):** F1 (perimenopause engine + full menopause sources), F2 (menopause/postmenopause), F4 (surgical/induced), B17 (thyroid–cycle), B18 (screening/prevention), B19 (gynae/breast-cancer survivor — routes here for menopause layer), Master Adaptation Model §6 (universal events) + §8 (modifier blending).
