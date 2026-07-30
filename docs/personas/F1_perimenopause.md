# Persona F1 — Woman in perimenopause with irregular cycles and emerging symptoms

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, or prevents disease. HRT/MHT content is **educational, not prescriptive**. Screeners (incl. MRS) are framed as "screening — discuss with a clinician."
> Research date: 2026-07-16 · Persona band: F (menopause lifespan) · Stage: perimenopause / menopausal transition (STRAW+10 stages −2 to −1)

---

## A. Persona snapshot

**Who she is.** "Nadia," 47. For about two years her once-predictable cycle has gone haywire — 24 days one month, 45 the next, then a skipped month, then a flood. She wakes at 3am drenched, forgets words mid-sentence, snaps at her kids, and feels a low hum of anxiety she never had before. Her GP ran a "normal" blood test and suggested an antidepressant. She left feeling unseen. Arabic-first (also reads English), lives on her phone's browser, private about her body.

**What she lives with (34+ trackable symptoms; her core cluster):**
- **Menstrual irregularity** — the defining feature; cycle-length variability ≥7 days progressing toward ≥60-day gaps. The exact thing that breaks generic 28-day apps.
- **Vasomotor symptoms (VMS)** — hot flashes and night sweats; the "classic" but not universal signal.
- **Sleep disruption** — early waking, night sweats, unrefreshing sleep → daytime fatigue.
- **Mood changes** — new/worsened anxiety, irritability, low mood, tearfulness.
- **Cognitive ("brain fog")** — word-finding, concentration, short-term memory lapses.
- Plus: joint aches, palpitations, headaches, vaginal dryness, low libido, weight/body changes, heavier/flooding bleeds.

**Core emotional drivers.** Wants to feel **believed** and **not be told she's imagining it or "just stressed."** Wants **validation** ("this is real, it's perimenopause, you're not going crazy"), **pattern insight** (proof her symptoms cluster and track a transition), and **honest education on all her options — including HRT/MHT** — without being sold a single answer. Wants everything **reachable**, not hidden behind a paywall or a fertility-first UX.

**Jobs-to-be-done.**
1. Track lengthening/erratic cycles **without** being told she's "late" every month.
2. Track her wider symptom cluster (34+) and *see them together* over time.
3. Understand what's happening to her body (STRAW+10, "am I in perimenopause?").
4. Get honest, referenced education on options — HRT/MHT, non-hormonal, CBT, lifestyle — to discuss with a clinician.
5. Prepare for and get taken seriously at appointments (she's been dismissed once already).
6. Feel validated and less alone.

**Success = she walks into her next appointment with a clear symptom timeline + MRS score + questions, and is finally heard — instead of screenshotting a period app that keeps telling her she's 20 days late.**

---

## B. Needs & questions (voice-of-user)

Mined from r/Menopause, r/Perimenopause, menopause forums, and app-store reviews (see Sources). Paraphrased to avoid quoting individuals; themes are strongly and repeatedly attested.

**On prediction failure (the #1 tracking pain):**
- "My period app has told me I'm 18 days late for three months straight. It's useless now."
- "It keeps predicting a fertile window and a period date that never come. Perimenopause broke it."
- "I don't want a confident wrong date. Just show me my real history and that my cycles are getting longer."
- "Every app assumes I want to get pregnant or that I have a 28-day cycle. Neither is true anymore."

**On being dismissed / medical gaslighting:**
- "My doctor ran one blood test, said it was normal, and offered me antidepressants. I don't think I'm depressed — I think I'm in perimenopause."
- "It took me years and three doctors to even hear the word perimenopause."
- "I felt like I was going crazy until I found a list of symptoms and realized this is a *thing*."
- "I need something to hand my GP so I'm not dismissed in a 10-minute slot."

**On validation & pattern:**
- "Seeing my hot flashes, bad sleep, and mood dips line up on one chart made me feel sane again."
- "I just want proof it's not all in my head."

**On options & HRT/MHT:**
- "I'm terrified of HRT because of what I heard years ago, but also told it could help — I don't know what to believe."
- "Is HRT safe for me? What are the actual risks vs benefits? Nobody explains it in plain language."
- "What are my options if I *can't* or *don't want* to take hormones?"

**On reach / cost:**
- "Why is every menopause app $80–100 a year and still shallow?"
- "The good info is always locked behind a subscription."

**On privacy:**
- "I don't want my symptom and hormone data sold or shared."

**Top recurring questions Femio must answer in-product:**
1. Am I in perimenopause? What stage, and how long might this last?
2. Why are my cycles so unpredictable now — and when is bleeding "not normal" (flooding, very frequent)?
3. Are these symptoms (brain fog, anxiety, palpitations) really perimenopause or something else?
4. What is HRT/MHT — real benefits, real risks, and is it "safe"? (education only)
5. What non-hormonal and lifestyle options exist (CBT, SSRIs/SNRIs, fezolinetant, etc.)?
6. What about my long-term bone and heart health?
7. How do I prepare so my clinician actually takes me seriously?

---

## C. Competitor teardown

Feature-by-feature, focused on where apps fail a perimenopausal user on **prediction honesty, symptom depth, HRT/MHT education, price, and reach.**

| App | Model / price | Perimenopause handling | Prediction honesty | Symptom depth | HRT/MHT education | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Balance** (Newson Health) | Freemium; ~£8.99/mo or ~$98.99/yr for advanced; ORCHA-certified | Purpose-built for peri/menopause; dashboard for symptoms, mood, periods, meds; downloadable **Health Report** for GP | N/A (not a fertility predictor) — good, but little cycle-uncertainty modeling | Broad symptom + med tracking | Strong expert content (Dr Louise Newson), but perceived as **HRT-forward/pro-hormone** framing | Balanced, referenced education across *all* options; Arabic-first/RTL; free core reach; uncertainty-honest cycle view |
| **Caria** | Freemium; free trial then ~$29.99/qtr or ~$78/yr | Peri/menopause coaching; **CBT-based** programs; published RCT (2025) showing reduced hot-flash distress & depressive symptoms | N/A | Symptom tracking + guided programs | Educational, coaching-led | Femio matches CBT + evidence bar, adds MRS, referenced multi-option content, multilingual, full-lifespan account |
| **Perry** | Free; community-first | Peri-focused; expert blogs/podcasts (Faubion, Kling), strong **peer community** | N/A | Moderate tracking | Educational content | Femio adds structured tracker (34+), MRS, referenced medical review, Arabic-first, privacy-by-design |
| **Stella** (Vira Health) | Freemium; virtual clinic + human coach | Peri→post support; CBT, sleep, mindfulness; **human coach chat**; symptom tracker; ~75% report improved symptoms | N/A | Good symptom tracking | Clinician-linked (UK) | Femio = accessible web-first education/tracking that *feeds* clinician visits, globally + Arabic; no geo-locked clinic dependency |
| **Health & Her** | Freemium; **ORCHA #1** rated | Adapts across life stages incl. peri/menopause; CBT, guided imagery, pelvic-floor, breathing toolkit; daily assessments | N/A | Strong self-care toolkit | Educational | Femio adds MRS scoring, referenced citations w/ review byline, 4-language/RTL, uncertainty-honest cycle logic |
| **Clue** (Perimenopause mode) | Freemium; peri mode is **Clue Plus (paid)** | Cycle View **adapts to changing/longer cycle length** and flags changes — one of the better cycle-aware peri handlers | Better than most; still degrades on highly irregular cycles; peri mode paywalled | Strong, neutral symptom taxonomy | Thin on HRT/MHT decision content | Femio matches cycle-adaptivity but adds deep option education, MRS, referenced content, Arabic-first, free core |
| **Flo** | Freemium; **Perimenopause Score** assessment | Added perimenopause support + score; tracks irregular cycles, VMS, mood; content library | Low for peri — AI/calendar model trained on regular cycles; some peri features paywalled | Broad logging, TTC-leaning legacy framing | Limited/education-light | **FTC settlement (2021) + ~$56M class settlement (2025)** for data-sharing → trust damage. Femio wins on privacy-by-design, honest predictions, depth, Arabic-first |

**Cross-cutting failure #1 — prediction:** general trackers (Flo, and to a lesser degree Clue) are built on ~28-day-cycle assumptions and keep surfacing confident period/ovulation dates that **collapse in perimenopause**, then label the user "late." The correct product answer is an **uncertainty-first cycle view** (range/trend, "your cycles are lengthening — this is expected"), not a point date.

**Cross-cutting failure #2 — quality:** a **systematic review of 28 menopause apps (BMC Women's Health, 2023)** found only **22.7% used evidence-based information**, medical-professional involvement in only **27.3%**, mean functionality **4.57/11** and mean quality **3.1/5**, with readability suited to university graduates. Menopause apps are broadly **thin and low-quality** — Femio's referenced, medically-reviewed, grade 6–8, multilingual content is a direct wedge.

**Cross-cutting failure #3 — reach & price:** the strongest apps (Balance, Caria) gate depth behind ~$80–100/yr; the free/deep options are rare. Femio's free, reachable core + Arabic-first/RTL opens an underserved market.

---

## D. Clinical grounding (cited)

**Perimenopause / menopausal transition — definition & staging.**
- **WHO:** natural menopause = permanent cessation of menstruation from loss of ovarian follicular activity, recognized **retrospectively after 12 consecutive months of amenorrhea** with no other cause; **perimenopause** = the time immediately before menopause (when endocrine/biological/clinical features begin) through the first year after the final menstrual period (FMP); it can last several years [WHO fact sheet].
- **STRAW+10 (2012)** is the gold-standard staging system. The **menopausal transition** spans **stage −2 (early:** cycle-length variability ≥7 days**) → stage −1 (late:** ≥60 days of amenorrhea**)**; **stage +1a** marks the end of the 12-month post-FMP window that retrospectively defines menopause [STRAW+10, ASRM/PMC]. Perimenopause typically begins mid-40s and lasts ~4–8 years.
- **Diagnosis is clinical, not biochemical:** per **NICE NG23**, diagnose perimenopause/menopause from **vasomotor symptoms + age**; **FSH testing is not required in women ≥45**, and is reserved for age <45 (possible POI) or specific scenarios. A single "normal" blood test does **not** rule out perimenopause — clinically important given how often these users are dismissed [NICE NG23].

**Symptoms.** Hot flashes/night sweats (VMS) are the most common menopausal symptom (~3 in 4 women; VMS prevalence reported ~50–80%+), but perimenopause also commonly includes **irregular periods, sleep problems, mood changes (anxiety/irritability/low mood), cognitive "brain fog," vaginal dryness, joint aches, palpitations, headaches, and libido changes** [MedlinePlus/NIH; NHS; Office on Women's Health].

**Menopause Rating Scale (MRS).** Validated 11-item self-report across **3 domains — somato-vegetative** (hot flashes, heart discomfort, sleep, joint/muscle; max 16), **psychological** (depressive mood, irritability, anxiety, exhaustion; max 16), **urogenital** (bladder, vaginal dryness, sexual problems; max 12). Each item 0–4; **total 0–44**, higher = more severe. Femio uses MRS as a **screening/tracking instrument**, never a diagnosis [Heinemann et al.; MRS methodological review].

**MHT / HRT (EDUCATIONAL framing only — Femio never prescribes or recommends).**
- Per **The Menopause Society (NAMS) 2022 Hormone Therapy Position Statement**, HT remains the **most effective treatment for VMS and genitourinary syndrome of menopause**, and prevents bone loss/fracture. **Benefit–risk is favorable for symptomatic women aged <60 or within 10 years of menopause onset** with no contraindications ("timing hypothesis"); it becomes **less favorable when initiated >10 years from onset or age >60** (greater absolute risk of CHD, stroke, VTE, dementia). **Transdermal routes and lower doses may reduce VTE/stroke risk.** Care is **individualized, shared decision-making** [NAMS 2022].
- Femio explains what MHT is, estrogen-only vs combined, routes/doses, and the risk–benefit picture — always routing to a clinician. It is **not** a recommendation to start or stop any therapy.

**Non-hormonal options (educational).** Per **The Menopause Society (NAMS) 2023 Nonhormone Therapy Position Statement**, Level-I evidence supports **CBT, clinical hypnosis, SSRIs/SNRIs** (e.g., paroxetine — low-dose paroxetine 7.5 mg is the only FDA-approved non-hormonal for VMS — plus escitalopram, venlafaxine, desvenlafaxine), **gabapentin**, and **fezolinetant** (Veozah, an NK3-receptor antagonist, FDA-approved May 2023). **NICE NG23** likewise supports **menopause-specific CBT** for VMS and low mood, and fezolinetant when HRT is unsuitable [NAMS 2023; NICE NG23]. This grounds Femio's **CBT-based programs**.

**Long-term health (bone & cardiovascular).** Estrogen decline accelerates **bone resorption**; up to ~**20% of bone loss** can occur in the years around menopause, raising **osteoporosis** risk. Estrogen loss is also linked to increased **cardiovascular** risk postmenopause. Perimenopause is the window to build bone/heart-protective habits and awareness [NIH/PMC; society reviews]. Femio frames this as **education + "discuss screening with your clinician,"** never disease prevention claims.

**Antidepressants-instead-of-menopause gap.** Widely documented that women presenting with perimenopausal mood symptoms are frequently offered **antidepressants first**, partly because only a minority of OB-GYN residencies include formal menopause training. This validates F1's lived experience and Femio's **visit-prep + validation** value [secondary/clinical commentary — see note].

*Publication exclusion (medical review): the residency-training percentage, “years to diagnosis” figures, and named-app prediction-accuracy figures are removed from public copy because the cited material does not establish them with suitable primary evidence. Femio may describe the user-reported care gap and its own uncertainty-first design without quantifying competitors or clinicians. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Perimenopause / transition mode** — set at onboarding; **disables 28-day predictions**, never labels her "late," models cycle length as a widening personal range and highlights the *trend* (lengthening/skipping) as expected.
2. **34+ symptom tracker** — full menopausal symptom set (VMS, sleep, mood, cognitive, urogenital, joints, palpitations, bleeding changes) logged and **viewable together** over time.
3. **MRS screener + score** — periodic 11-item MRS with domain sub-scores and trend, framed strictly as screening → "discuss with a clinician."
4. **Uncertainty-first cycle view** — trend + range with plain-language framing ("Your cycles are getting longer and less predictable — this is normal in perimenopause"). Suppress fertile-window/TTC framing by default (reachable).
5. **Referenced, medically-reviewed education across *all* options** — perimenopause 101, HRT/MHT (educational), non-hormonal, CBT, lifestyle, bone/heart — grade 6–8, Arabic-first + EN/FR/ES.
6. **Clinician visit-prep pack** — exportable/printable timeline: symptom trends + MRS score + cycle history + questions + "what a work-up may involve." Directly counters being dismissed.
7. **Validation layer** — onboarding + insights that name and normalize the experience ("this is perimenopause; you're not imagining it").
8. **Privacy-by-design** — no ad-SDK/third-party sharing of symptom/hormone data; clear controls; addresses post-Flo distrust.
9. **Free, reachable core** — depth not paywalled to the point of exclusion.

**P1 — strong differentiators.**
10. **CBT-based programs** for VMS, sleep, and low mood/anxiety (NICE/NAMS-grounded, education/self-help framing).
11. **HRT/MHT tracking log (educational)** — if she is already on MHT (clinician-prescribed), log type/route/dose + symptom response to bring to appointments. Never suggests starting/changing.
12. **Pattern insight** — descriptive correlations ("night sweats cluster with your poor-sleep and low-mood logs").
13. **Flooding/abnormal-bleeding awareness prompt** — non-alarming, screening-framed clinician-check nudge.

**P2 — depth / retention.**
14. Bone & heart health habit module (movement, nutrition, "ask about screening").
15. Partner/family explainer export (optional) to reduce isolation.
16. Community/expert-content surface (Perry-style) — moderated, referenced.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Perimenopause 101** — what it is, STRAW+10 stages in plain language, how long it lasts, why a "normal" blood test doesn't rule it out (NICE: clinical diagnosis).
2. **Why my cycles are unpredictable now** — anovulation/hormone fluctuation; what changing cycles mean; when bleeding (flooding, very frequent, bleeding after 12 months' gap) warrants a clinician check.
3. **The 34+ symptoms** — VMS, sleep, mood, brain fog, urogenital, joints, palpitations — normalizing each and linking to the transition.
4. **"Am I going crazy?" — mood, anxiety & brain fog in perimenopause** — validation + coping + when to seek help.
5. **Understanding HRT / MHT (education only)** — what it is, estrogen-only vs combined, routes (transdermal vs oral) and doses, the **timing hypothesis**, benefits (VMS, GSM, bone) and risks (CHD/stroke/VTE/dementia by age/timing) — plain language, clear non-prescription disclaimer, "discuss with your clinician."
6. **Non-hormonal options** — CBT, SSRIs/SNRIs, gabapentin, **fezolinetant**, clinical hypnosis — what they are and why a clinician might discuss them. Education only.
7. **CBT for menopause** — self-help program for hot flashes, sleep, and low mood (NICE/NAMS-grounded).
8. **Lifestyle that actually helps** — sleep hygiene, movement, nutrition, alcohol/caffeine/VMS triggers, stress — non-shaming.
9. **Bone & heart health at midlife** — why estrogen matters, what protects you, "ask about bone-density/cardio screening."
10. **Getting taken seriously at your appointment** — how to prepare, what to bring (your Femio report), what a work-up may involve, how to advocate if dismissed.
11. **Myths vs evidence** — "HRT causes cancer," "it's just hot flashes," "there's nothing you can do," "you're too young for menopause."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, and **no prescriptive/dosing language for MHT.**

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Cycle/bleed log** — flow, spotting, flooding flag, cycle-length **range/trend** view (no "late" language); days-since-last-bleed counter for the 12-month milestone.
- **34+ symptom tracker** — VMS (frequency/severity), night sweats, sleep quality/waking, mood (anxiety, irritability, low mood), cognitive/brain fog, joint aches, palpitations, headaches, vaginal dryness, libido, weight/body changes, plus free symptoms — all toggleable and viewable together.
- **HRT/MHT log (educational)** — if clinician-prescribed: type (estrogen-only/combined), route (transdermal/oral/vaginal), dose, start date, and symptom response over time. Bring-to-clinician artifact only; **no recommendation to start/stop/change.**
- Optional lifestyle logs (sleep, alcohol/caffeine, movement) for trigger insight.

**Tools**
- **MRS screener** — 11 items, 3 domain sub-scores + total (0–44), trend chart → result copy: "This is a screening tool, not a diagnosis. Consider discussing your score with a clinician."
- **Uncertainty-first cycle view** — trend + range, plain-language caveat; fertile-window hidden by default.
- **Pattern insight** — descriptive correlations only ("appears associated with," never "caused by," never "you have menopause").
- **Visit-prep generator** — one-tap export/print: symptom timeline + latest MRS + cycle trend + questions + work-up checklist.
- **CBT program** — structured self-help modules (education/self-management framing).

**Alerts (non-alarming, screening-framed, dismissible, localized/RTL)**
- **12-month amenorrhea milestone** prompt → "You've logged ~12 months without a period. Clinically this is often when menopause is confirmed — a good time to check in with your clinician." (educational; triggers F2 routing — see J).
- **Abnormal-bleeding awareness** → flooding / very frequent bleeding / any bleeding after a 12-month gap: "Some bleeding patterns are worth discussing with a clinician." (screening-framed).
- Optional log reminders that **respect irregular cadence** — never "your period is late."
- Low-mood screen follow-up nudge + localized crisis resources.
- **Never:** contraception/"safe day" claims (fertility is reduced but *not zero* in perimenopause — flag educationally); never disease-prevention claims; never "you have/are in menopause" as a diagnosis; never "start/stop HRT."

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off); export/delete.
- Life-stage / mode flag (here: **perimenopause / transition mode ON**; STRAW+10 stage hint −2/−1).
- Cycle events: bleed start/end, flow, spotting; computed personal cycle-length **range + variability + trend**; days-since-last-bleed.
- Generic symptom log; mood/energy/sleep.

**Persona-specific (perimenopause)**
- Menopause stage self-report (perimenopause / uncertain) + STRAW+10-derived hint (early vs late transition) from cycle variability & amenorrhea gaps.
- **34+ symptom fields:** VMS frequency/severity, night sweats, sleep metrics, mood (anxiety/irritability/low mood), cognitive/brain fog, joint/muscle, palpitations, headaches, vaginal dryness, libido, weight/body changes, flooding flag.
- **MRS records:** item scores, 3 domain sub-scores, total, date (history for trend).
- **HRT/MHT log (educational):** on-therapy y/n, type (estrogen-only/combined), route, dose, start/stop dates, symptom response — entry only, no interpretation as recommendation.
- Non-hormonal/CBT usage self-report (optional).
- Bone/CV context self-report (optional): family history, prior DEXA/lipids the *user* enters — entry only, no diagnosis.
- **TTC intent flag = false** by default (drives non-fertility UX); reachable toggle; contraception-awareness note (fertility reduced, not zero).
- Amenorrhea counter (days since last bleed) driving the 12-month milestone prompt.

*All health fields optional, encrypted, user-deletable; MHT log is educational tracking, not a medication-management/dispensing feature.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (F1):**
- Q: life stage / age → 40s–50s **and/or** "my cycles are changing" ⇒ offer **perimenopause / transition mode**.
- Q: cycles regular / getting irregular / skipping / stopped ⇒ sets STRAW+10 hint and **disables 28-day prediction**; "skipping/long gaps" ⇒ late-transition emphasis.
- Q: "Are you currently trying to conceive?" → **No** (default for F1) ⇒ suppress fertile-window/TTC UI; keep reachable + contraception-awareness note.
- Q: top symptoms (multi-select: hot flashes, sleep, mood/anxiety, brain fog, periods, dryness/libido, joints) ⇒ orders home cards and content.
- Q: "Are you currently using HRT/MHT?" → yes ⇒ surface **HRT log (educational)**; no ⇒ surface balanced options education (never push hormones).

**Home configuration (default for F1):**
- **Hero = uncertainty-first cycle trend** ("cycles lengthening — normal in perimenopause") + days-since-last-bleed — **no "late" counter, no confident next-period date.**
- **MRS card** (take/re-take + trend) pinned.
- Symptom-cluster tracker + "see your patterns" pinned.
- Cards reordered by her selected top symptoms (e.g., sleep + CBT-for-sleep surfaced if she flagged sleep).
- Options-education and visit-prep pinned.
- **Fertile-window / pregnancy / TTC widgets hidden by default.**

**How the prediction UI shifts to uncertainty-first (key F1 design rule):**
- Replace the point-date "your period is due on X" with a **trend + range + narrative**: "Your recent cycles: 24, 41, skipped, 38 days. They're lengthening and less predictable — this is expected in perimenopause. We won't guess an exact date."
- Confidence band **widens** as variability rises; when a 60-day gap appears, copy shifts to "late-transition" education.
- **Never** show a red "X days late" state; reframe as "days since last period" neutrally.

**Hidden-but-reachable principle:** Femio never removes knowledge. TTC/fertility, contraception education, pregnancy, and postmenopause content stay **discoverable** via search and an "Explore other life stages" entry — just not pushed. She can enable fertile-window display or TTC mode anytime.

**Adaptive tuning:** rising MRS psychological sub-score ⇒ surface mood/CBT module + resources. Repeated flooding logs ⇒ raise abnormal-bleeding awareness + visit-prep. On-MHT + logging symptom relief ⇒ surface "prepare for your review" (annual-review framing per NICE).

---

## J. Adaptation triggers (life-stage routing)

| Trigger | System response | Route |
|---|---|---|
| **Cycles lengthen / start skipping** (variability ≥7 days → ≥60-day gaps) | Shift STRAW+10 hint from early→late transition; widen uncertainty band; retire any remaining cycle-prediction UI in favor of trend + education | **Stay F1** (deepen transition mode) |
| **12 consecutive months of amenorrhea logged** | Milestone prompt: menopause is typically confirmed clinically at this point → "discuss with your clinician"; transition content → **postmenopause** content; retire cycle-prediction entirely; emphasize bone/CV + GSM long-term health | **Route to F2 (menopause / postmenopause)** |
| **Comorbidity signals** (e.g., existing PCOS, thyroid, diabetes, CVD, or high-risk history entered) | Layer condition-aware content and symptom-overlap explainers (PCOS-vs-peri, thyroid-vs-peri); keep perimenopause core | **Route to / blend F3 (menopause + comorbidity)** |
| **Surgical / induced menopause** (oophorectomy, chemo/radiation, GnRH therapy self-reported) | Recognize **abrupt, often more severe** onset; skip gradual-transition framing; surface induced-menopause + earlier bone/CV + MHT-education content sensitively | **Route to F4 (surgical / induced menopause)** |
| **Sets TTC intent = true** | Confirm; enable fertility features **with strong perimenopause-fertility-decline caveats**; surface age/fertility education | Blend F1 + TTC layer |
| **Abnormal bleeding (flooding / post-12-month-gap bleeding)** | Non-alarming clinician-check prompt + awareness content + visit-prep | Stay F1, raise screening prominence |
| **MRS psychological sub-score trends high / crisis flag** | Surface mood/CBT module + localized crisis resources; screening-framed | Stay F1 |
| **User toggles off perimenopause mode** | Revert to standard cycle logic; preserve all history | General band |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, **not contraception**. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **MRS & all screeners:** always return "This is a screening tool, not a diagnosis — discuss your results with a clinician." Never output "You are in menopause/perimenopause" or "You have depression."
- **HRT/MHT content & log:** **educational only** — explain what MHT is, benefits/risks, routes/doses, timing hypothesis; **never recommend, initiate, dose, or advise stopping/changing** therapy. The HRT log is a *bring-to-clinician* tracking artifact, not medication management. Clear non-prescription disclaimer everywhere hormones appear.
- **Non-hormonal/medication content** (SSRIs/SNRIs, gabapentin, fezolinetant): educational context only; no recommendation or dosing; clinician routing.
- **Predictions:** uncertainty-first; **never** present a fertile/"safe" window as reliable — add explicit "perimenopause reduces but does not eliminate fertility; not for contraception" note wherever fertility appears.
- **Clinical-diagnosis framing:** reflect NICE NG23 — perimenopause is diagnosed clinically; a normal blood test does not exclude it. Content must not imply lab tests are required or that Femio can confirm stage.
- **Bone/CV & long-term health:** framed as "know your risks, discuss screening" — no prevention/treatment claims.
- **Mental health:** localized crisis resources on any low mood screen or high MRS psychological sub-score.
- **Privacy (GDPR/PDPL health data):** symptom, MRS, and HRT data = special-category; explicit consent, purpose limitation, **no ad-SDK/third-party sharing** (post-Flo trust); local-first where feasible; full export/delete; DPIA + data-mapping before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; tracking/education framing keeps out of regulated-device territory — legal review before store submission.
- **Claims boundary:** no public residency-training percentage, diagnosis-delay duration, or competitor prediction-accuracy figure is permitted without a dated primary study that directly measures the stated population and outcome. The unsupported figures in Section D are cut. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH / CDC / WHO / NHS / MedlinePlus / gov):**
- [Menopause — WHO fact sheet](https://www.who.int/news-room/fact-sheets/detail/menopause)
- [Menopause — MedlinePlus (NIH)](https://medlineplus.gov/menopause.html)
- [Menopause overview — NIH MedlinePlus Magazine (PDF)](https://magazine.medlineplus.gov/pdf/Menopause_overview.PDF_.final_.083023.pdf)
- [Symptoms of menopause and perimenopause — NHS](https://www.nhs.uk/conditions/menopause-and-perimenopause/symptoms/)
- [Menopause basics — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/menopause/menopause-basics)
- [Menopause symptoms and relief — Office on Women's Health](https://womenshealth.gov/menopause/menopause-symptoms-and-relief)
- [Bone and the Perimenopause — PMC (NIH)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3920744/)

**Clinical — Tier 2 (Menopause Society/NAMS, NICE, staging, peer-reviewed):**
- [The 2022 Hormone Therapy Position Statement of The North American Menopause Society — Menopause (journal)](https://journals.lww.com/menopausejournal/fulltext/2022/07000/the_2022_hormone_therapy_position_statement_of_the.4.aspx)
- [The 2023 Nonhormone Therapy Position Statement of The North American Menopause Society — PubMed](https://pubmed.ncbi.nlm.nih.gov/37252752/)
- [Menopause: identification and management — NICE guideline NG23](https://www.nice.org.uk/guidance/ng23/chapter/recommendations)
- [NICE NG23 recommendations (Guideline Central summary)](https://www.guidelinecentral.com/guideline/4543751/)
- [Executive summary of the Stages of Reproductive Aging Workshop +10 (STRAW+10) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3340903/)
- [STRAW+10 executive summary — ASRM](https://www.asrm.org/practice-guidance/practice-committee-documents/executive-summary-of-the-stages-of-reproductive-aging-workshopd10-addressing-the-unfinished-agenda-of-staging-reproductive-aging-2012/)
- [The Menopause Rating Scale (MRS): reliability of scores — PubMed](https://pubmed.ncbi.nlm.nih.gov/11910611/)
- [The Menopause Rating Scale (MRS): a methodological review — ResearchGate](https://www.researchgate.net/publication/8368268_The_Menopause_Rating_Scale_MRS_scale_A_methodological_review)
- [FDA approves Veozah (fezolinetant): a new nonhormonal option — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12401328/)

**App-quality evidence (systematic review):**
- [A systematic review of menopause apps with an emphasis on osteoporosis — BMC Women's Health (2023)](https://bmcwomenshealth.biomedcentral.com/articles/10.1186/s12905-023-02612-9)
- [Same review — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10542256/)
- [Period tracker applications: what menstrual cycle information are they giving women? — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8504278/)

**Patient journey / needs (voice-of-user, dismissal, antidepressants):**
- [It's Time to End the Medical Gaslighting of Menopausal Women — Yahoo/News commentary](https://www.yahoo.com/news/time-end-medical-gaslighting-menopausal-084718283.html)
- [Antidepressants and menopause — Dr Louise Newson](https://www.drlouisenewson.co.uk/knowledge/antidepressants-and-menopause)
- [Are Antidepressants Overused in Menopause? — Hone Health](https://honehealth.com/edge/antidepressants-hrt-menopause-mood/)
- [Perimenopause symptoms, severity, and healthcare seeking in women in the US — npj Women's Health](https://www.nature.com/articles/s44294-025-00061-3)

**Competitor / app landscape:**
- [Balance — Newson Health menopause app](https://www.balance-menopause.com/balance-app/)
- [Balance — Menopause & Hormones (App Store)](https://apps.apple.com/us/app/balance-menopause-hormones/id1503345959)
- [Caria / best perimenopause tracking app comparison — Go-Go Gaia](https://www.go-go-gaia.com/blog/best-perimenopause-tracking-app.html)
- [5 Best Menopause Tracking Apps 2026 — GeekExtreme](https://www.geekextreme.com/best-menopause-tracking-apps/)
- [Stella — Menopause relief (guide)](https://us.onstella.com/the-latest/long-term-health/a-guide-to-using-the-stella-app/)
- [Health & Her App — free hormone health tracker](https://healthandher.com/en-us/pages/menopause-perimenopause-app)
- [What's Clue Perimenopause mode? — Clue Support](https://support.helloclue.com/hc/en-us/articles/13059487439261-What-s-Clue-Perimenopause-mode)
- [Introducing Clue Perimenopause — helloclue.com](https://helloclue.com/articles/menopause/introducing-clue-perimenopause)
- [Flo Health launches in-app perimenopause support — Future Femhealth](https://www.futurefemhealth.com/p/flo-health-launches-in-app-perimenopause)
- [NC° Perimenopause — Natural Cycles](https://www.naturalcycles.com/perimenopause)
