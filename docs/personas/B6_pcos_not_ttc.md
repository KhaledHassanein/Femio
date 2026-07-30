# Persona B6 — Reproductive-age woman with PCOS, NOT trying to conceive

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician."
> Research date: 2026-07-16 · Persona band: B (reproductive-age, non-TTC)

---

## A. Persona snapshot

**Who she is.** "Layla," 27. Diagnosed with PCOS at 23 after ~4 years of being told her irregular periods were "just stress." Cycles run anywhere from 21 to 90+ days, sometimes skipping entirely. She is **not** trying to conceive and is tired of every app assuming she is TTC or pregnant the moment she logs an irregular cycle. Arabic-first (also reads English), uses the web on her phone.

**What she lives with.**
- **Oligo/amenorrhea** — unpredictable, long, or absent cycles; the core reason generic 28-day apps fail her.
- **Insulin resistance / weight** — worried about weight gain, sugar cravings, and long-term type 2 diabetes risk; may be lean-PCOS and still insulin resistant.
- **Hyperandrogenism** — hirsutism (chin, jawline, abdomen), adult acne, hair thinning; high emotional load.
- **Mental health** — elevated anxiety/depression and body-image distress; feels dismissed by clinicians.

**Core emotional drivers.** Wants to feel *believed* and *in control*, not "fixed." Wants an app that says "we're not sure, and that's normal for PCOS," rather than a confident-but-wrong ovulation date. Wants knowledge without being force-funneled into a fertility or pregnancy narrative — but doesn't want other life-stage knowledge hidden from her either.

**Jobs-to-be-done.**
1. Track long/irregular cycles and symptom clusters *without* being told she's "late" or "trying."
2. Understand her PCOS (what it is, what raises her long-term risk, what lifestyle levers actually do).
3. Prepare for and get more out of specialist visits (she's been dismissed before).
4. Get uncertainty-honest predictions and gentle pattern insight — not false precision.
5. Support mental health and body image without shame or weight-loss pressure.

**Success = she stops screenshotting three different apps and a Notes file to bring to her endocrinologist.**

---

## B. Needs & questions (voice-of-user)

Mined from r/PCOS, PCOS forums, app-store reviews, and qualitative studies (PLOS One, BMC, Verity APPG report — see Sources). Paraphrased to avoid quoting individuals.

**On prediction & tracking (the #1 pain):**
- "Every app assumes a 28-day cycle and marks me 'late' on day 30 when my normal is 45."
- "It keeps predicting ovulation and a period that never come. It's demoralizing to be told I'm 40 days late every month."
- "I don't want a fake fertile window. Just show me my actual history and stop guessing."
- "The moment I log an irregular cycle it asks if I'm trying to get pregnant. I'm not."

**On being taken seriously / visit prep:**
- "It took years to get diagnosed — everyone said it was stress or that I should just lose weight."
- "I forget half my symptoms in the 10-minute appointment. I need a summary to hand over."
- "What tests should I even ask for? I don't know what a normal work-up looks like."

**On symptoms beyond periods:**
- "I want to track acne flares, hair growth, energy crashes, and cravings together — not just bleeding."
- "Are my mood swings the PCOS or something else? I want to see if they track my cycle."

**On lifestyle without shame:**
- "Just tell me what actually helps without telling me to lose weight in the first sentence."
- "I have insulin resistance — I want food/movement info that respects that, not another diet."

**On mental health:**
- "The anxiety and the body-image stuff are the hardest part and no app addresses it."

**On privacy:**
- "After the Flo/Facebook thing I don't trust these apps with my reproductive data."

**Top recurring questions Femio must answer in-product:**
1. Is my cycle length "normal for PCOS," and when should long/absent cycles worry me?
2. What raises my long-term risk (diabetes, heart, endometrial) and what lowers it?
3. What lifestyle changes are actually evidence-based vs. wellness noise?
4. What is metformin / inositol and why might a doctor bring them up? (education only)
5. How do I prepare for my appointment and what tests are standard?
6. Is this symptom PCOS or should I get it checked?

---

## C. Competitor teardown

Feature-by-feature, focused on where general trackers fail PCOS users on prediction accuracy and framing.

| App | Model | Irregular/PCOS handling | Prediction honesty | Symptom-cluster depth | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | Has a "PCOS/irregular" mode + symptom insights, but core UX still centers a predicted cycle & fertile window | Low for PCOS — calendar/AI predictions trained on regular cycles perform poorly on irregular cycles; presents dates with false confidence | Broad symptom logging, TTC-leaning framing | **FTC settlement (2021) for sharing period/pregnancy data with Facebook/Google; ~$56M class settlement (2025)** — trust damage | Uncertainty-honest predictions; privacy-by-design; non-TTC default |
| **Clue** | Freemium, science-forward | Adapts to variable cycle length better than most; still surfaces predicted period/fertile window | More conservative than Flo but still degrades on highly irregular cycles | Strong, neutral symptom taxonomy | Better reputation, EU/GDPR posture | Referenced medical content + PCOS-specific insight layer + Arabic-first/RTL |
| **Ovia** | Freemium, health-plan tie-ins | Cycle + health tracking; strongly fertility/pregnancy-oriented | Standard predictions | Good logging | Employer/health-plan data model raises concerns | Non-TTC, non-employer, privacy-first |
| **Stardust** | Privacy-forward, local-first, astronomy theme | Tracks symptoms/flow; less about hard predictions | Low emphasis on prediction (good) but astrology framing dilutes clinical trust | Moderate | **Strong: local storage, privacy-forward** | Clinical credibility + referenced content + condition depth |
| **Allara Health** | US telehealth membership ($125–149/mo), MD + dietitian | Real PCOS clinical care, not a tracker | N/A (clinician-led) | Care plans, labs | US-only, paid, insurance-gated | Femio = accessible web-first education/tracking layer that *feeds* clinician visits, globally + Arabic |
| **Allura** | PCOS-specific tracker app | Built explicitly for non-28-day bodies; symptom/mood/energy/temp logs | Advanced forecasts (premium) — still forecasts | PCOS-tuned logging | Unclear | Femio matches PCOS focus but adds referenced content, multilingual, uncertainty-honest framing, full-lifespan account |
| **Vira Health (Nyra)** | Women's health, menopause focus | Not PCOS-primary | N/A | N/A | — | Femio covers PCOS band explicitly |

**Cross-cutting failure of general trackers for PCOS:** calendar/AI models trained on ~28-day cycles produce low-accuracy predictions on irregular cycles, then present them as confident dates. This is the exact gap Femio's **irregular-cycle/PCOS mode + uncertainty-honest predictions** targets. Reported accuracy for calendar-style prediction on PCOS cycles is very low; the correct product answer is a **range with a confidence band**, not a point date.

---

## D. Clinical grounding (cited)

**Definition & prevalence.** PCOS is a common endocrine/metabolic condition affecting ~8–13% of reproductive-age women; up to ~70% remain undiagnosed [Office on Women's Health; WHO]. Cause is multifactorial — hormones, insulin resistance, genetics [MedlinePlus].

**Diagnosis (Rotterdam, updated by the 2023 International Evidence-based Guideline / ESHRE-ASRM-Endocrine Society).** Requires **two of three**: (1) clinical or biochemical **hyperandrogenism**, (2) **ovulatory dysfunction** (irregular cycles), (3) **polycystic ovarian morphology** on ultrasound. 2023 updates: **AMH may substitute for ultrasound in adults**; where irregular cycles **and** hyperandrogenism are both present, ultrasound/AMH are **not required**. PCOS is a diagnosis of exclusion — no single test [2023 Guideline, Human Reproduction / JCEM].

**Core symptoms.** Irregular/absent periods, hyperandrogenism (hirsutism, acne, scalp hair thinning), weight changes, insulin resistance [Office on Women's Health; MedlinePlus].

**Comorbidities / long-term risks (why tracking + visit prep matter).**
- **Type 2 diabetes & insulin resistance** — markedly elevated risk; screen with OGTT/HbA1c per clinician [2023 Guideline; NIH/PMC].
- **Cardiovascular** — increased risk of MACE independent of obesity; a >170,000-woman study showed ~26% higher risk vs matched controls [Wiley Clin Endocrinol; PMC].
- **Metabolic** — dyslipidemia, hypertension, MASLD (fatty liver), sleep apnea [2023 Guideline; PMC].
- **Endometrial** — prolonged amenorrhea/unopposed estrogen raises endometrial hyperplasia/cancer risk — clinical relevance of very long cycles [narrative reviews; discuss with clinician].
- **Mental health** — significantly higher anxiety, depression, and body-image distress; guideline recommends routine screening [2023 Guideline; PMC narrative review].

**Management (EDUCATIONAL framing only — Femio does not treat).**
- **Lifestyle is first-line**: healthy eating, regular activity (~150 min/wk), and — for those with higher weight — modest weight change (~5–10%) can improve metabolic and menstrual regularity. Guideline stresses this **alongside explicit awareness of weight stigma** [2023 Guideline; ASRM].
- **Metformin** — clinician-considered for metabolic features, esp. BMI ≥25; *educational context only, Femio never recommends or doses* [2023 Guideline].
- **Inositol** — limited but low-harm evidence; a preference-sensitive option to discuss with a clinician [2023 Guideline]. *Educational only.*
- Hormonal/anti-androgen therapies for cycle regulation and hirsutism are clinician-prescribed — Femio explains, never prescribes.

**Femio scope guardrail restated:** all of the above is presented as **wellness education and screening**, with consistent "discuss with your clinician" routing. Femio is not contraception and does not claim to prevent disease.

*Competitive-claims boundary:* no named-app prediction-accuracy figure for PCOS or irregular-cycle cohorts is public without a peer-reviewed, population-matched validation study. Femio describes only its own uncertainty behavior: wide ranges, no “late” verdict, and no contraceptive claim. *(Claim cut; reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Irregular-cycle / PCOS mode** — set at onboarding; disables 28-day assumptions, never labels her "late," models cycle length as a personal range.
2. **Uncertainty-honest predictions** — show predicted period/ovulation as a **range with a confidence band** and plain-language uncertainty ("Your cycles vary a lot — this is a wide estimate, not a date"). Suppress fertile-window framing unless she opts in.
3. **Symptom-cluster tracking** — periods + acne, hirsutism, mood, energy, cravings, sleep, weight (optional) logged and viewable *together* over time.
4. **Non-TTC default** — no "trying to conceive?" nudges; TTC and pregnancy are reachable but never assumed.
5. **Specialist-visit prep pack** — auto-generated, exportable/printable summary (cycle history, symptom trends, questions, standard-work-up checklist).
6. **Privacy-by-design** — local-first where possible, no ad-SDK data sharing, clear data controls; explicitly addresses post-Flo distrust.

**P1 — strong differentiators.**
7. Referenced, medically-reviewed PCOS content library (Arabic-first + EN/FR/ES).
8. Long-cycle / amenorrhea awareness prompt (e.g., "It's been 90+ days — many clinicians suggest checking in; here's why," non-alarming, screening-framed).
9. Mental-health & body-image support module (screening + coping content, stigma-aware).
10. Lifestyle support that is insulin-resistance-aware and explicitly non-shaming (no default weight-loss messaging).

**P2 — depth / retention.**
11. Trend correlations ("your low-energy logs cluster in your longer cycles") — pattern insight, not diagnosis.
12. Lab/result tracker (she enters her own labs to bring context to visits).
13. Hirsutism/acne photo-optional progress log (private, local).

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **PCOS 101** — what it is, the 2-of-3 diagnosis picture, why it's a spectrum (incl. lean PCOS).
2. **Why my cycles are irregular** — anovulation explained; what "normal for PCOS" looks like; when long/absent cycles warrant a clinician check (endometrial context).
3. **Insulin resistance & PCOS** — what it is, its link to weight and cravings, what helps (non-shaming).
4. **Long-term health & PCOS** — type 2 diabetes, cardiometabolic, mental health, sleep apnea; framed as "know your risks, discuss screening."
5. **Lifestyle that's actually evidence-based** — food patterns, movement, sleep; weight-stigma-aware; "modest changes matter."
6. **Understanding your options (education only)** — hormonal therapy, anti-androgens, metformin, inositol — what they are and why a clinician might discuss them. Clear non-prescription disclaimer.
7. **Hirsutism & acne** — what drives them, management landscape, self-care.
8. **PCOS & mental health / body image** — normalizing, coping strategies, when to seek support.
9. **Getting the most from your appointment** — what tests are standard, questions to ask, how to advocate if dismissed.
10. **Myths vs. evidence** — "just lose weight," "you can't have PCOS if you're thin," "PCOS = infertility."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Cycle/bleed log (flow, spotting, cycle-length range view — no "late" language).
- Symptom cluster log: acne, hirsutism, hair thinning, mood, anxiety, energy, cravings, bloating, sleep, weight (optional/toggleable).
- Optional lab/result entry; optional private photo progress (local).

**Tools**
- **Uncertainty-honest predictor** — range + confidence band, plain-language caveat.
- **Cycle-pattern insight** — descriptive trends and correlations ("appears associated with," never "caused by").
- **Visit-prep generator** — one-tap export/print summary + questions + standard work-up checklist.
- **Screeners (framed as screening, not diagnosis):**
  - Mood/anxiety screen (e.g., PHQ-2/GAD-2 style) → result: "This is a screening tool, not a diagnosis. Consider discussing with a clinician." + crisis resources.
  - PCOS-symptom awareness checklist → "These can be signs to discuss; only a clinician can diagnose."

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL)**
- Long-cycle / prolonged-amenorrhea awareness prompt (educational, cites endometrial context, suggests clinician check).
- Optional log reminders (respect irregular cadence — never "your period is late").
- Screening follow-up nudge (e.g., re-check mood in N weeks).
- **Never:** contraception/fertile-window "safe day" claims; never disease-prevention claims; never "you have PCOS."

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, PCOS mode ON).
- Cycle events: bleed start/end, flow, spotting; computed personal cycle-length range + variability.
- Generic symptom log; mood/energy/sleep.

**Persona-specific (PCOS, non-TTC)**
- PCOS status (self-reported diagnosed / suspected / screening) + year of diagnosis.
- Phenotype hints (self-reported): irregular cycles y/n, hyperandrogenism signs y/n, prior ultrasound/AMH mention.
- Hyperandrogenism log: hirsutism area/severity, acne, scalp hair thinning.
- Metabolic self-report: insulin-resistance flag, weight (optional, toggleable, never mandatory), cravings.
- Mental-health screen history (scores + dates, screening-only).
- User-entered labs (HbA1c, glucose/OGTT, testosterone, AMH, lipids) — **entry only, no interpretation as diagnosis**.
- Prolonged-amenorrhea counter (days since last bleed) for awareness prompts.
- TTC intent flag = **false** (drives non-TTC UX); reachable toggle.

*All health fields optional, encrypted, user-deletable; weight is explicitly not required to use the app.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B6):**
- Q: life stage → "reproductive age." Q: cycles regular/irregular/absent → **irregular or absent** ⇒ set **PCOS/irregular mode ON**.
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false, suppress fertile-window & pregnancy nudges.
- Q: PCOS status → diagnosed / suspected / just exploring ⇒ tunes content depth and screener prominence.
- Q: top concerns (multi-select: cycles, weight/insulin, skin/hair, mood, appointment prep) ⇒ orders home modules.

**Home configuration (default for B6):**
- Hero = cycle-length range view + uncertainty-honest next-window estimate (band, not date). No "late" counter.
- Cards prioritized by her concern selection (e.g., mood support surfaced if she flagged mental health).
- Visit-prep and symptom-cluster tools pinned.
- Fertile-window / pregnancy widgets **hidden by default**.

**Hidden-but-reachable principle:** Femio never *removes* knowledge. TTC guidance, pregnancy tracking, contraception education, and perimenopause content remain **discoverable** via search and a "Explore other life stages" entry — just not pushed. She can opt into fertile-window display or TTC mode anytime.

**Adaptive tuning:** if she logs 90+ day amenorrhea repeatedly, raise endometrial-awareness content and visit-prep prompts (educational). If mood screens trend low, surface mental-health module + resources.

---

## J. Adaptation triggers (life-stage routing)

| Trigger | System response | Route |
|---|---|---|
| Sets **TTC intent = true** ("start trying") | Ask to confirm; enable ovulation/fertile-window features **with PCOS uncertainty caveats retained**; surface PCOS-and-fertility education | **Route to persona C6 (PCOS + TTC)** — keep PCOS mode, add TTC layer |
| **Positive pregnancy test logged** | Confirm sensitively; switch to **pregnancy + PCOS** experience; carry PCOS metabolic-risk context (GDM awareness) into pregnancy content; retire prediction widgets | Pregnancy band (PCOS-flagged) |
| **Perimenopause overlap** (age/symptom signals: late 30s+, changing cycles, vasomotor symptoms) | Introduce perimenopause education; clarify PCOS-vs-perimenopause symptom overlap; keep irregular-cycle logic | Blend PCOS + perimenopause content; offer route to menopause band |
| **Prolonged amenorrhea (90+ days, recurring)** | Non-alarming clinician-check prompt + endometrial-awareness content + visit-prep | Stay B6, raise screening prominence |
| **Mood screen trends low / crisis flag** | Surface mental-health module + localized crisis resources; screening-framed | Stay B6 |
| **User toggles off PCOS/irregular mode** | Revert to standard cycle logic but preserve history | General reproductive-age band |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs "You have PCOS/depression."
- **Predictions:** must display uncertainty; never present a fertile/"safe" window as reliable for contraception. Add explicit "not for contraception" note wherever ovulation/fertility appears.
- **Medication content (metformin/inositol/hormonal/anti-androgen):** educational context only; no recommendation, dosing, or "take this." Clear non-prescription disclaimer + clinician routing.
- **Weight/body image:** weight fields optional and never required; no default weight-loss messaging; weight-stigma-aware copy per 2023 guideline.
- **Mental health:** crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** health data = special-category; explicit consent, purpose limitation, no ad-SDK/third-party sharing of cycle/health data (post-Flo trust); local-first where feasible; full export/delete. Data-mapping + DPIA required before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education keeps out of regulated-device territory — legal review before store submission.
- **Claims boundary resolved:** named-app prediction-accuracy statistics are excluded from public copy. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH/CDC/WHO/NHS/MedlinePlus/gov):**
- [Polycystic ovary syndrome — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/a-z-topics/polycystic-ovary-syndrome)
- [PCOS | MedlinePlus (NIH)](https://medlineplus.gov/polycysticovarysyndrome.html)
- [Polycystic Ovary Syndrome (PCOS) | FDA](https://www.fda.gov/consumers/womens-health-topics/polycystic-ovary-syndrome-pcos)

**Clinical — Tier 2 (guidelines / society / peer-reviewed):**
- [2023 International Evidence-based Guideline for the Assessment and Management of PCOS — Human Reproduction](https://academic.oup.com/humrep/article/38/9/1655/7241786)
- [2023 PCOS Guideline Recommendations — J Clin Endocrinol Metab](https://academic.oup.com/jcem/article/108/10/2447/7242360)
- [2023 PCOS Guideline — PubMed](https://pubmed.ncbi.nlm.nih.gov/37580314/)
- [2023 PCOS Guideline recommendations — ASRM practice guidance](https://www.asrm.org/practice-guidance/practice-committee-documents/recommendations-from-the-2023-international-evidence-based-guideline-for-the-assessment-and-management-of-polycystic-ovary-syndrome/)
- [ESHRE 2023: PCOS – Update of the International Guidelines (Ciplamed summary)](https://www.ciplamed.com/quick-reads/conferencehighlights/eshre-2023-pcos-update-of-the-international-guidelines)
- [Long-term health outcomes in young women with PCOS — Clinical Endocrinology (Wiley)](https://onlinelibrary.wiley.com/doi/full/10.1111/cen.14609)
- [Risk of T2DM, MASLD and Cardiovascular Disease in People Living With PCOS — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12012816/)
- [T2DM in Patients With PCOS — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10637759/)
- [PCOS and multidimensional impacts on mental health: narrative review — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11191963/)
- [Lifestyle management in PCOS – beyond diet and physical activity — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC9841505/)
- [Polycystic ovary syndrome: update on diagnosis and management — Cleveland Clinic J Med](https://www.ccjm.org/content/93/3/176)

**Patient journey / needs (qualitative studies + advocacy):**
- [Treatment pathways traversed by PCOS patients (mixed-method) — PLOS One](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0255830)
- ["I felt like she didn't take me seriously" — patient satisfaction with PCOS care, Canada — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8864824/)
- [What can be done to improve PCOS healthcare? Interviews with women in Canada — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9092874/)
- [Gaps and opportunities in PCOS care — a qualitative study — ScienceDirect](https://www.sciencedirect.com/science/article/pii/S2666334125000947)
- [PCOS patients report feeling dismissed by providers — Contemporary OB/GYN](https://www.contemporaryobgyn.net/view/pcos-patients-report-feeling-dismissed-by-health-care-providers)
- [Addressing Systemic Failures in PCOS Diagnosis (Verity APPG report, 2025) — PDF](https://www.verity-pcos.org.uk/uploads/6/7/0/2/6702442/verity_appg_pcos_report_sept25.pdf)
- [Monash PCOS Question Prompt List (patient visit-prep) — PDF](https://www.monash.edu/__data/assets/pdf_file/0009/1401768/pcos-qpl-v5-14-09-2020.pdf)

**Competitor / app landscape:**
- [Allara Health (telehealth for PCOS)](https://www.allarahealth.com/)
- [Allura — PCOS Period Tracker (App Store)](https://apps.apple.com/us/app/allura-pcos-period-tracker/id6760195370)
- [Stardust — privacy-forward cycle app](https://stardust.app/)
- [Flo vs Clue vs Glow for PCOS / TTC](https://ovul.ai/flo-vs-clue-vs-glow/)
- [Best PCOS Tracking App 2026 (irregular cycles)](https://www.go-go-gaia.com/blog/best-pcos-tracking-app.html)
- [Best Ovulation Tracker for PCOS — app reviews](https://app.pcosmealplanner.com/knowledge-articles/any/best-ovulation-tracker-for-pcos-app-reviews-2025)
- [Menstrual tracking app reveals broader PCOS symptoms — Healio](https://www.healio.com/news/endocrinology/20210511/menstrual-tracking-app-reveals-clues-of-broader-pcos-symptoms)
- [Period-tracking app said you have a disorder? Why it could be wrong — Advisory Board](https://www.advisory.com/daily-briefing/2019/11/11/pcos)
