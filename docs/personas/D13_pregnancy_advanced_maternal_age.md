# Persona D13 — Pregnancy at Advanced Maternal Age (≥35, especially ≥40)

Prepared: 2026-07-17 · Wave 3 · Status: research + spec
Layered on: **D1 (uncomplicated pregnancy)** — inherits its week-by-week spine, tools, red-flag layer, and privacy posture. Read D1 first; this file specifies only the AMA-specific additions.
Aligns with: 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · 09_MASTER_ADAPTATION_MODEL · 03_COMPETITOR_ANALYSIS · 04_MEDICAL_DATA_SOURCES · femio-compliance-privacy · femio-medical-content skills
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Red-flag symptoms get prominent "seek care now" framing, never a diagnosis. Screeners = "screening, discuss with clinician."**

---

## A. Persona snapshot

**Who she is.** A pregnant woman who is **35 or older at expected delivery** — the age at which she will hear the clinical label "advanced maternal age" (AMA), and possibly the older, stigmatizing "geriatric pregnancy." A meaningful sub-group is **≥40 ("very advanced maternal age," VAMA)**, where several risks rise more steeply. She is otherwise often low-risk and healthy; AMA is a **statistical risk context, not a diagnosis**. She is disproportionately a first-time mother who conceived later by choice or circumstance (career, later partnership, fertility treatment, secondary infertility), frequently a **prior Femio TTC / infertility / loss user** whose account converts on a positive test — so she may arrive already anxious and screening-literate, or already grieving a prior outcome.

**Core job.** "Tell me honestly what my age does and doesn't change about this pregnancy, help me understand my screening options (NIPT, first-trimester screen, amniocentesis/CVS) so I can make my own informed decisions with my clinician — and do it without fear-mongering, without the 'geriatric' insult, and without making me feel like a walking risk statistic."

**Emotional arc (layered over D1's).**
- **T1 (wk 4–13):** the label hits ("advanced maternal age" / "high-risk" stamped on her chart); acute focus on **genetic screening decisions** — NIPT timing (from ~10 wk), what it can and can't tell her, whether to add diagnostic testing (CVS/amnio) and its small miscarriage risk; miscarriage anxiety amplified by age-related figures she has already Googled; guilt/defensiveness about "waiting too long."
- **T2 (wk 14–27):** results-processing (NIPT "high chance" vs diagnostic confirmation; false-positive anxiety); anatomy scan carries extra weight; early/tighter **gestational-diabetes** and **blood-pressure/pre-eclampsia** awareness; possible **low-dose aspirin** conversation with her clinician.
- **T3 (wk 28–40+):** heightened **stillbirth** awareness and the emotionally loaded **induction-around-39–40-weeks** discussion; more frequent monitoring / growth scans; wanting the increased attention framed as **care, not alarm**.

**Context.** Web-first, mobile-heavy, Arabic-first/RTL primary with EN/AR/FR/ES. High information appetite and high health-literacy on average, but emotionally raw around age framing. Values calm, numerate, non-patronizing content — real numbers with real context, not vague reassurance and not doom.

**Success = she feels respected (never "geriatric"), genuinely screening-literate, and able to make her own informed choices** — understanding that most AMA pregnancies are healthy, that raised relative risks are still usually small absolute risks, and that any genuine red flag is surfaced loudly and routed to her clinician.

---

## B. Needs & questions (voice-of-user)

Mined from AMA / "35+ pregnancy" / "geriatric pregnancy" community threads (Reddit r/BabyBumps, r/AdvancedMaternalAge-style groups, What to Expect "35+" birth-month boards) and app-store reviews. Verbatim-style paraphrases.

**The label & the stigma (dominant emotional signal, unique to D13)**
- "My chart literally says *geriatric pregnancy* — I'm 36, not 96. Why is this still a word?"
- "The doctor called me 'advanced maternal age' in the first thirty seconds and I felt like a problem, not a person."
- "I'm so tired of the 'ticking clock' and the risk lecture. Can someone just tell me the actual numbers calmly?"

**Genetic / chromosomal screening literacy (the defining job-to-be-done)**
- "What's the difference between NIPT, the first-trimester combined screen, and amnio — and which do I actually need at 38?"
- "My NIPT came back 'high risk / high chance' for Down syndrome — does that mean my baby *has* it?" (huge false-positive anxiety)
- "Is the amnio miscarriage risk worth it if NIPT is already 'low risk'?"
- "What does 'low fetal fraction' / 'no call' mean and should I panic?"
- "At my age is NIPT enough or do I need the diagnostic test to be sure?"

**Age-specific risk, in proportion (numerate reassurance)**
- "What's *my* actual chance of Down syndrome at 35 vs 40 — real odds, not 'increased risk'?"
- "Everyone says higher risk of stillbirth, gestational diabetes, pre-eclampsia — how much higher, really?"
- "Is 35 a real cliff or just an arbitrary line?" (it is largely a threshold of convenience)

**Monitoring & interventions**
- "Why do I get extra scans / earlier glucose test / more BP checks — is something wrong or is this just because of my age?"
- "My clinician mentioned baby aspirin — why?"
- "They want to induce me at 39 weeks just for my age — do I have to?"

**Cross-cutting frustrations with existing apps (design brief for Femio)**
- Generic apps treat 35+ as an afterthought or bolt on a scary "high-risk" banner with no education behind it.
- Screening content is thin: apps say "you may be offered NIPT" but don't explain screening-vs-diagnostic, false positives, or how to decide.
- Fear-first tone around age; or the opposite — toxic positivity that dodges her real questions.
- The "geriatric"/"elderly" language showing up in content or nowhere-addressed.
- Wanting continuity from her TTC/infertility/loss history rather than a fresh, amnesiac pregnancy silo.

---

## C. Competitor teardown

Focus: how existing apps handle **AMA support** and **genetic-screening literacy** — the two gaps D13 exploits. (General pregnancy-feature teardown is inherited from D1 §C; not repeated.)

| Capability (AMA/screening lens) | What to Expect | BabyCenter | Pregnancy+ | Ovia | Flo (preg mode) |
|---|---|---|---|---|---|
| Dedicated "35+/AMA" content track | Article-level only; no tailored home | Article-level; some "over 35" hub content | Minimal | Some personalized-by-age insights | Minimal |
| Screening-vs-diagnostic explainer | Present but shallow, ad-wrapped | Present, commercialized | Basic | Basic | Basic |
| NIPT literacy (false positive, fetal fraction, "chance not diagnosis") | Thin | Thin | Thin | Thin | Thin |
| Amnio/CVS risk in context (miscarriage ~0.1–0.3%) | Rarely quantified | Rarely quantified | No | No | No |
| Numerate, in-proportion age-risk figures | Rare (relative-risk scare framing) | Rare | No | Age-personalized but shallow | No |
| Non-stigmatizing language commitment | Not stated | Not stated | Not stated | Not stated | Not stated |
| Continuity from TTC/infertility/loss | Siloed | Siloed | Siloed | Partial | Partial |

**Gaps Femio exploits for D13.**
1. **Genetic-screening literacy is universally underserved** — every major app gestures at NIPT but none teaches *screening vs diagnostic*, *false positives*, *fetal fraction / no-call*, or *how to decide about amnio/CVS* at the depth a 38-year-old actually wants. AAMC and clinician sources confirm portal results like "high chance" or "low fetal fraction" routinely trigger panic with no context. (See D.)
2. **No competitor commits to non-stigmatizing language** — "geriatric" still appears in charts and casual content, and 65–68% of surveyed women say the term heightens anxiety and undermines confidence. Femio can make a stated, brand-level commitment (K).
3. **Age risk is presented as scare (relative risk) or dodged** — Femio presents **absolute** figures with context (most AMA pregnancies are healthy).
4. Inherited D1 wedges (privacy-by-design, one-account continuity, referenced honest content, Arabic-first/RTL, red-flag-forward calm UX) all apply and matter more here because she often arrives from TTC/infertility/loss.

---

## D. Clinical grounding (cited)

All figures are **education, not medical advice**; app copy must attribute to these bodies and defer every decision/dose to the user's clinician. AMA is a **risk context, not a diagnosis** — copy must say so.

**Definition & the "35" line.** Advanced maternal age = **35 or older at delivery**; **≥40 = "very advanced maternal age."** 35 is largely an arbitrary/administrative threshold — risk rises gradually and continuously with age, with several risks not climbing steeply until the 40s. → Femio frames 35 as "a line clinicians use to offer extra options, not a cliff." [ACOG OCC 2022; Cleveland Clinic; Evidence Based Birth]

**Chromosomal-condition risk (present without a generic table).**
- Aneuploidy risk increases along a continuum with maternal age, but exact estimates differ by condition, gestational age, population, and whether the denominator is pregnancies or live births. Femio therefore publishes no age-to-Down-syndrome table or reciprocal percentage. It offers neutral screening/diagnostic-test education and individualized clinician/genetic-counselor discussion. [ACOG/SMFM Obstetric Care Consensus No. 11, August 2022, reaffirmed 2025](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2022/08/pregnancy-at-age-35-years-or-older). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Screening options — the core D13 education.**
- **ACOG now recommends that prenatal screening (serum ± NT ultrasound, or cell-free DNA/NIPT) *and* diagnostic testing (CVS or amniocentesis) be discussed and offered to *all* pregnant patients regardless of age or risk** — the old "only offer to 35+" rule is retired. → For D13 this is a *reassurance*: her options are the same menu everyone gets, just chosen with age-informed context. [ACOG "Screening for Fetal Chromosomal Abnormalities" 2026; ACOG NIPT current guidance]
- **NIPT / cell-free DNA** is the **most sensitive/specific screening** for common aneuploidies, from **~10 weeks**, via maternal blood analyzing placental DNA fragments. It is **a screen, not a diagnosis** — it estimates *chance*, and has **false positives and false negatives**. A "high chance"/"positive" result is **not** a diagnosis. [ACOG; Cleveland Clinic; UT Southwestern; AAMC]
- **Fetal fraction / "no-call"**: results can be inconclusive ("low fetal fraction," "no call") — this is a testing-logistics issue, **not** a result about the baby; the step is to discuss a repeat/next option with the clinician. [AAMC; UT Southwestern]
- **Diagnostic tests (CVS ~10–13 wk; amniocentesis ~15+ wk)** *can* diagnose; they carry a **small procedure-related miscarriage risk — historically quoted ~1 in 200 (0.5%), with recent systematic-review estimates lower, ~0.1–0.3% (~1 in 300–1000)**. → Framed as *her informed choice with her clinician*, never a Femio recommendation. [NHS; MedlinePlus amniocentesis; ACOG]
- **Positive screen → next step**: genetic counseling + comprehensive ultrasound + option of diagnostic testing to confirm. Femio routes to "discuss with your clinician / genetic counselor," never interprets a result. [ACOG]

**Pregnancy complications more common with AMA (present in proportion, not as verdicts).**
- **Gestational diabetes** — risk rises with age; adjusted odds roughly **~1.4× at 35–39 and ~2.3–2.5× at ≥40** vs younger. → May prompt **earlier/additional glucose screening** per clinician. [PMC cohort studies; Japan Environment & Children's Study]
- **Pre-eclampsia / gestational hypertension** — **age ≥40 is a *moderate* risk factor** in NICE's schema; higher rates at 40+ (e.g. ~13% vs ~6% in one cohort). [NICE; ACOG; Finland registry study]
- **Stillbirth** — modestly increased risk at term with AMA (independent of other factors), part of why term timing is discussed. [ACOG OCC 2022; ACOG Management of Stillbirth]
- Also higher: **cesarean, preterm birth, low birth weight, postpartum hemorrhage, chromosomally-related miscarriage.** All framed as *raised chance, usually still a healthy outcome.* [PMC cohort; ACOG]

**Monitoring & interventions her clinician may discuss (education, never a Femio instruction).**
- **Low-dose aspirin** (commonly 150 mg from ~12 wk to birth, per NICE) when age ≥40 combines with **one additional** pre-eclampsia risk factor — **her clinician decides and doses**; Femio never doses. [NICE; RCOG]
- **Serial growth ultrasounds** for fetal growth/wellbeing (esp. ≥40). [RCOG/TOG]
- Delivery timing is individualized. *Clinician-facing guideline context, not user-facing copy:* ACOG/SMFM recommends delivery at 39+0 to 39+6 weeks for a well-dated pregnancy when anticipated delivery age is 40 years or older. Femio does not surface that window as a schedule, generalize it to everyone aged 35+ or to other countries, or ever schedule delivery; the user-facing surface says delivery timing is a conversation with her maternity team. [ACOG/SMFM OCC No. 11, reaffirmed 2025](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2022/08/pregnancy-at-age-35-years-or-older).

*Source register resolved:* use [ACOG/SMFM OCC No. 11 (2022; reaffirmed 2025)](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2022/08/pregnancy-at-age-35-years-or-older) for age-related counseling and screening options, and [NICE NG133](https://www.nice.org.uk/guidance/ng133/chapter/recommendations) within the UK hypertension/pre-eclampsia module. No global aneuploidy table, aspirin instruction, serial-scan schedule, delivery schedule, or MENA pathway is published. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

Inherits the full D1 feature spine (week-by-week home, referenced library, appointment/checklist tracker, symptom/mood log, weight-gain guidance, red-flag safety layer, kick counter, contraction timer, partner view). **D13 adds:**

**P0 — must-have (the D13 layer)**
1. **Genetic-screening literacy hub** — the flagship D13 module: interactive *screening-vs-diagnostic* explainer; NIPT / first-trimester combined / CVS / amnio compared (what each tells you, timing, accuracy, false-positive meaning, procedure risk in absolute terms); a **non-directive "questions to ask my clinician/genetic counselor" builder**. Never recommends an option.
2. **In-proportion age-risk explainers** — her age-band figures shown as **absolute odds + the reciprocal** ("~99% of babies are not affected"), with a clear "35 is a threshold, not a cliff" frame. Static education keyed to her entered age; **not** a personalized risk *calculator* (that would edge toward diagnosis).
3. **Respectful-framing layer** — app never uses "geriatric"/"elderly"; a short "About the term 'advanced maternal age'" explainer that validates the stigma feeling and reframes.

**P1 — high value**
4. **Screening-results companion** — a place to *log* (user-entered) her NIPT/screen results and read a plain-language "what this type of result generally means + discuss with your clinician" explainer, incl. **"low fetal fraction / no-call"**. Strictly non-interpretive of *her* specific number.
5. **AMA monitoring primer** — why extra scans / earlier glucose test / BP monitoring / aspirin conversation / 39-wk induction discussion may come up; each framed as *care and shared decision-making*.
6. **Blend hooks** — one-tap surfacing of **D3** (GDM), **D6** (pre-eclampsia/gestational HTN), **D2** (pregnancy-after-loss tone) education when her data/history warrants (see J).

**P2 — differentiators / later**
7. Decision-aid worksheet (PDF export) summarizing screening options + her questions, to take to an appointment.
8. Curated, moderated 35+ peer content/Q&A (privacy-safe, only if moderation quality guaranteed).

**Explicitly out of scope (compliance):** any tool that outputs *her* personalized numeric risk as a result (Down-syndrome probability calculator, pre-eclampsia risk score) — that is screening/diagnosis; any "you should get the amnio / skip the amnio" recommendation; any interpretation of her actual NIPT value; any "your pregnancy is high-risk" auto-verdict banner. Femio educates and routes; the clinician decides.

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL). Delivered GA-gated but always searchable. Adds to D1's set:

- **"About advanced maternal age"** — what the term means, why 35, that it's a risk *context* not a diagnosis, and an honest, validating note on the "geriatric" label. Tone: respectful, numerate, calm.
- **Genetic-screening hub (flagship):**
  - *Screening vs diagnostic — the key difference* (chance vs answer).
  - *NIPT / cell-free DNA explained* — timing (~10 wk), what it screens, **false positives/negatives**, "high chance ≠ diagnosis," **fetal fraction / no-call**.
  - *First-trimester combined screen & anatomy scan.*
  - *Amniocentesis & CVS* — what they diagnose, timing, **miscarriage risk in absolute terms**, how to weigh it.
  - *If a screen comes back "high chance"* — next steps (genetic counseling, ultrasound, optional diagnostic), all "discuss with your clinician."
  - *Deciding what's right for you* — non-directive values/questions prompt.
- **Age & risk, in proportion** — Down syndrome and other aneuploidy **absolute odds by age** + reciprocal reassurance; GDM, pre-eclampsia, stillbirth "how much higher, really" explainers with context.
- **AMA monitoring & choices** — extra scans, earlier glucose screening, BP/pre-eclampsia watch, the **low-dose aspirin** conversation (education, never a dose), and the **39–40-week induction discussion** as shared decision-making.
- **Warning-signs hub (inherited from D1)** — CDC Hear Her list; pre-eclampsia symptoms-to-report foregrounded a bit more given raised chance; reduced-movement → contact provider today.
- **Emotional wellbeing** — validating later-motherhood choice; countering "waited too long" guilt; normal vs support-needing worry (soft EPDS-based screening pointer = "screening, discuss with clinician").
- **Continuity note** — "your TTC / infertility / loss history is here and private" (many D13 users arrive from C/loss).

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

Inherits all D1 tools/logs/alerts and the reusable **red-flag box**. D13 additions:

**Logs & tools**
- **Screening-results log** (user-entered): which test, date, and *her* recorded result. Femio shows a **generic** "what this *kind* of result means + discuss with your clinician/genetic counselor" note — **never interprets her specific number**. "No-call / low fetal fraction" gets its own plain-language explainer + "discuss a next step with your clinician."
- **Screening-decision questions builder** → PDF export for appointments (non-directive).
- **BP log** surfaced a little earlier/more prominently (pre-eclampsia awareness) with D1's non-diagnostic framing; elevated readings → surface warning-signs + D6 awareness, never a diagnosis.
- (Glucose log via D3 blend if GDM recorded.)

**Alerts (opt-in, calm, non-alarmist)**
- Gentle milestone nudges tied to *options*, not fear: "~10 weeks — NIPT is one screening option available now; here's how it works" (educational, never "get tested").
- Monitoring-context nudges only when she has logged the relevant appointment (e.g., "your growth scan is coming up — here's what it checks").
- **No** "you're high-risk" pushes, **no** risk-score alerts, **no** predictive/diagnostic alerts.

**Red-flag box** — inherited verbatim-in-spirit from D1 §G (bleeding, severe/persistent headache, vision changes, trouble breathing/chest pain, severe belly pain, fever ≥38°C, sudden severe swelling, reduced fetal movement after ~28 wk, thoughts of self-harm). Placement unchanged; pre-eclampsia-symptom callouts appear on the AMA-monitoring and BP content.

---

## H. EMR fields (core vs persona-specific)

Inherits D1's core + pregnancy fields. **D13-specific additions/emphasis:**
- **Maternal age at EDD** — the field that sets the D13 layer (≥35 → AMA emphasis; ≥40 → VAMA sub-emphasis). Derived from DOB + EDD; single source for age-band content.
- **VAMA flag** (≥40) — unlocks the steeper-risk framing + aspirin/serial-scan/induction education emphasis.
- **Screening-plan / results log** — tests offered/chosen, dates, user-entered results (NIPT, first-tri combined, CVS, amnio), and fetal-fraction/no-call notes. Stored as **user notes, never app interpretation**.
- **Genetic-counseling referral flag** (user-entered).
- **Aspirin-conversation flag** (user-entered "clinician discussed low-dose aspirin") — education only, no dose stored as instruction.
- **Serial-growth-scan / additional-monitoring appointments** (via appointment log).
- Carried-in from TTC/infertility/loss history where present (seeds D2 tone / PAI emphasis).

All entry-only; surfaced-or-hidden, never destroyed (adaptation-model rule §3).

---

## I. Personalization rules (wizard → home config)

**Wizard (inherits D1's; the AMA layer is set by *age*, additively).**
- D1's pregnancy wizard already asks EDD/LMP and "any conditions your clinician is watching?" — **D13 needs no extra scary question**: it is inferred from **DOB + EDD ≥35 at delivery**. On inference, Femio *offers* (never forces) the AMA content emphasis: *"Because of your age at your due date, your clinician may offer some extra options and monitoring. Want Femio to include respectful, in-depth education on screening and what's relevant at 35+? You can turn this off anytime."*
- ≥40 → adds the VAMA emphasis (aspirin/serial-scan/induction education) — same offered, reversible pattern.

**Home configuration (GA + age-band driven; D1 spine intact).**
- **T1 home:** D1 T1 home **+** genetic-screening hub foregrounded (NIPT/first-tri/diagnostic), "about AMA" reassurance card, in-proportion age-risk explainer.
- **T2 home:** D1 T2 **+** screening-results companion (if results logged), earlier-glucose/BP awareness, aspirin-conversation education (VAMA).
- **T3 home:** D1 T3 **+** AMA-monitoring primer, kick counter (inherited), the 39–40-wk **induction-discussion** shared-decision explainer, pre-eclampsia symptoms slightly foregrounded.

**Hidden-but-reachable & personalize-never-restrict:** every module (incl. screening hub) is always in the library/search for any user; the AMA layer only changes emphasis, defaults, and tone — never access. She can toggle the AMA emphasis off and keep full library access.

**Continuity:** TTC/infertility/loss history carries in automatically (many D13 users arrive from C-track); one-time "your history is here and private" note; if a prior-loss flag is set, tone shifts anxiety-aware (D2 blend).

---

## J. Adaptation triggers (state transitions)

**Inherits all universal events** from Master Adaptation Model §6 (positive test, loss/grief instant suppression, high mood-screen → crisis path, red-flag → "seek care now," disengagement, toggle-off, age-of-consent). Only **D13-specific** transitions below.

**INTO D13:**
- **From D1 on age** — the primary entry: an existing/incoming pregnancy record whose **maternal age at EDD ≥35** additively layers D13 emphasis over the unchanged D1 core (offered, reversible). ≥40 adds VAMA emphasis.
- **From C-track on positive test** — a TTC / infertility / prior-loss user (often older) logs a positive test → universal positive-test handler fires (suppress fertile-window/OPK/TWW/BBT, carry all data, re-confirm privacy) → lands in D1 **with D13 layered by age**, carrying any C-track emotional context (PAI / anxiety-aware / D2 tone).

**Within pregnancy — blends (additive emphasis, never restriction, never diagnosis):**
- **+D3 (GDM)** — GDM / abnormal glucose screen recorded (raised chance at AMA) → blend D3 glucose tools/content. Distinct from pre-existing diabetes (D4), keyed on diabetes-recorded-*before*-pregnancy.
- **+D6 (pre-eclampsia / gestational HTN)** — elevated BP readings or clinician-noted gestational hypertension → D6 awareness; foreground warning-signs and the aspirin-conversation education; **never diagnose**.
- **+D2 tone (pregnancy after loss)** — prior-loss flag or arrival from a loss/infertility persona → anxiety-aware tone, gentle framing, no "risk-stat" bluntness. (Most common D13 blends: **D3, D6, D2**.)
- **+D5, D7, D9, D12, etc.** — any other condition recorded blends per D1 §J; AMA emphasis stacks with them (union of safety layers, most-acute wins the hero, per adaptation-model §8).

**OUT of pregnancy:**
- **Delivery/birth logged → Postpartum (E1)**; if her course was complicated, carry forward to **E4** (e.g., GDM→postpartum T2DM screen reminder; HTN/pre-eclampsia→BP follow-up). Breastfeeding → E2 emphasis; elevated mood screen → E3 watch. AMA itself does not change the postpartum destination — the *carried complication flags* do.
- **Pregnancy loss / stillbirth logged → E6 grief** — **instant** suppression of all pregnancy/milestone/screening reminders, Gentle Mode, grief resources, no re-prompting; retain data; gentle later path to **D2 (pregnancy after loss)** if she conceives again. (Age-related figures make loss anxiety acute here — silence-over-risk on grief paths is doubly important.)
- **Reset/withdraw:** she can toggle the AMA emphasis off or exit pregnancy mode anytime; data retained per her privacy settings; nothing forced.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. **AMA is a risk *context*, not a diagnosis** — copy must never state or imply that her age makes her pregnancy "high-risk" as a verdict. No screening tool outputs *her* personalized numeric risk; no recommendation for/against any test.
- **Respectful, non-stigmatizing language (D13's signature compliance/brand rule):**
  - **Never use "geriatric pregnancy" or "elderly primigravida/mother"** anywhere in product, content, notifications, or metadata (EN/AR/FR/ES). Use **"advanced maternal age" / "pregnancy at 35+"** or, in user-facing copy, plain phrasing like "pregnancy after 35." Provide a short explainer that *names and validates* the stigma (surveyed women: ~65% say the term heightens anxiety, ~68% say it undermines confidence).
  - **In proportion, never fear-first:** present raised risks as **absolute odds + the reciprocal** ("~99%+ of babies at 35 are not affected"), and state that **most AMA pregnancies are healthy** and that **35 is a threshold, not a cliff.** No "ticking clock," no doom, and equally no toxic positivity that dodges her real questions.
  - **Age-neutral respect:** no "waited too long"/blame framing; validate later-motherhood choices.
- **Screening literacy without steering:** all screening content is **non-directive** — screening = "estimates chance, discuss with clinician"; diagnostic-test decision and any procedure-risk weighing is **her informed choice with her clinician/genetic counselor**. Femio never interprets her specific NIPT/screen result and never recommends amnio/CVS or opting out. "High chance" ≠ diagnosis; "no-call/low fetal fraction" = logistics, not a result about the baby.
- **No dosing / no prescribing:** low-dose aspirin, and all monitoring/induction content, is **education about what guidelines describe** and defers timing/dose/decision entirely to the clinician (e.g., "your clinician may discuss…"), never "take 150 mg."
- **Red-flag routing:** inherited from D1 — "seek care now" framing, points to provider/local emergency number, never reassures ("your baby is fine") and never alarms with a diagnosis. Pre-eclampsia symptoms foregrounded proportionately, not alarmingly.
- **Privacy-by-design (GDPR/PDPL):** age, screening results, and genetic-testing data are special-category and often emotionally sensitive; minimal collection, explicit granular consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility**. Screening-results and genetic data are entry-only and never shared without scoped, revocable consent (partner sharing opt-in). Loss/withdrawal → immediate reminder suppression + data-deletion honoring.
- **Content provenance:** every claim medically reviewed + cited Tier-1 (NIH/CDC/NHS/MedlinePlus) / Tier-2 (ACOG/RCOG/NICE); review dates surfaced; no clickbait, no sponsored content near screening/loss content.
- **i18n/RTL:** all age-risk, screening, and red-flag copy human-reviewed in AR/EN/FR/ES (not machine-only); ensure the "geriatric" prohibition holds across translations and that absolute-risk phrasing survives localization.
- **Medical-review boundary:** primary ACOG/SMFM and NICE sources are pinned in §D. Screening, aspirin, surveillance, and delivery decisions remain clinician/country-module content; urgent routing uses the country selector and local maternity/emergency destination. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Tier-1 (NIH / CDC / NHS / MedlinePlus)**
- [MedlinePlus — Amniocentesis (Amniotic Fluid Test)](https://medlineplus.gov/lab-tests/amniocentesis-amniotic-fluid-test/)
- [CDC — Urgent Maternal Warning Signs (HEAR HER)](https://www.cdc.gov/hearher/maternal-warning-signs/index.html) (inherited red-flag list)
- [NHS — Amniocentesis (current test information; accessed 24 July 2026)](https://www.nhs.uk/tests-and-treatments/amniocentesis/) — Femio does not reproduce a universal procedure-related miscarriage percentage.
- [ACOG/SMFM — Pregnancy at Age 35 Years or Older, OCC No. 11 (August 2022; reaffirmed 2025)](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2022/08/pregnancy-at-age-35-years-or-older)

**Tier-2 (ACOG / RCOG / NICE)**
- [ACOG — Pregnancy at Age 35 Years or Older (Obstetric Care Consensus, 2022)](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2022/08/pregnancy-at-age-35-years-or-older)
- [ACOG — Screening for Fetal Chromosomal Abnormalities (Practice Advisory, 2026)](https://www.acog.org/clinical/clinical-guidance/practice-advisory/articles/2026/01/screening-for-fetal-chromosomal-abnormalities)
- [ACOG — Current ACOG Guidance on Non-Invasive Prenatal Testing](https://www.acog.org/advocacy/policy-priorities/non-invasive-prenatal-testing/current-acog-guidance)
- [ACOG — Management of Stillbirth (Obstetric Care Consensus)](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2020/03/management-of-stillbirth)
- [NICE — Hypertension in pregnancy, NG133 recommendations](https://www.nice.org.uk/guidance/ng133/chapter/recommendations) — UK clinician guidance; Femio does not prescribe aspirin.
- [RCOG / TOG — Very advanced maternal age (Howell, 2021)](https://obgyn.onlinelibrary.wiley.com/doi/abs/10.1111/tog.12710) (serial scans, 39-wk induction discussion)

**Clinical education & literacy**
- [Cleveland Clinic — Advanced Maternal Age: Pregnancy After 35](https://my.clevelandclinic.org/health/diseases/22438-advanced-maternal-age)
- [Johns Hopkins Medicine — Advanced Maternal Age](https://www.hopkinsmedicine.org/health/conditions-and-diseases/advanced-maternal-age)
- [Cleveland Clinic — NIPT Test: What To Expect](https://my.clevelandclinic.org/health/diagnostics/21050-nipt-test)
- [UT Southwestern — What NIPT can (and can't) tell you](https://utswmed.org/medblog/prenatal-genetic-testing-nipt/)
- [AAMC — Prenatal screenings can lead to false positives, heightened anxiety](https://www.aamc.org/news/prenatal-screenings-can-lead-false-positives-heightened-anxiety)
- [Evidence Based Birth — Pregnancy at Age 35 and Older](https://evidencebasedbirth.com/advanced-maternal-age/)
- [The ObG Project — Pregnancy at Age 35 Years or Older](https://www.obgproject.com/2022/10/27/pregnancy-at-age-35-years-or-older/)

**Risk-in-context / epidemiology**
- [PMC — The Impact of Advanced Maternal Age on Pregnancy Complications and Neonatal Outcomes](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12347501/)
- [PMC — Chromosomal Abnormalities in Miscarriages and Maternal Age (7118 cases)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11720377/)
- [PMC — Very advanced maternal age with GDM and adverse infant outcomes (NVSS 2014–2019)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9999489/)
- [PubMed — Advanced maternal age is a risk factor for early and late GDM (JECS)](https://pubmed.ncbi.nlm.nih.gov/39797691/)
- [PMC — Preeclampsia complicated by advanced maternal age (Finland registry)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3495042/)

**Language / stigma (non-stigmatizing-framing evidence, §K)**
- [Medscape — New Push to Stop Using 'Geriatric' to Describe Pregnant Women Over 35 (2026)](https://www.medscape.com/viewarticle/new-push-stop-using-geriatric-describe-pregnant-women-older-2026a100088c)
- [Psychology Today — The Label Expectant Mothers Over 35 Don't Want to Hear](https://www.psychologytoday.com/us/blog/singletons/202410/the-label-expectant-mothers-over-35-dont-want-to-hear)
- [Motherly — Geriatric Pregnancy: Ageism in Healthcare](https://www.mother.ly/pregnancy/geriatric-pregnancy-ageism-in-healthcare/)
- [HuffPost — The Term 'Geriatric Pregnancy' Isn't Just Offensive](https://www.huffpost.com/entry/geriatric-pregnancy-offensive-term_l_639b5e1ce4b044143045625f)

**Competitor / privacy (inherited from D1 §C)** — see D1_pregnancy_uncomplicated.md Sources (What to Expect, BabyCenter, Pregnancy+, Ovia, Flo teardown + privacy posture).
