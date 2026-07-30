# C1 — TTC, General (Early Journey, No Diagnosed Fertility Problem)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window features support **conception awareness**, and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, or prevents disease. Screeners are framed as *"screening — discuss results with a clinician."*
> Persona code: **C1** · Cohort: Conception (C) · Last research pass: 2026-07-16

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Nour," 29 |
| **Age band** | ~25–34 (below the ACOG/NICE 35 threshold that shortens the help-seeking window) |
| **Stage** | Actively trying to conceive, cycle 1–6. No diagnosed fertility problem, no red-flag history. |
| **Relationship** | Partnered; wants partner involved but partner is less engaged / less informed. |
| **Goal (top JTBD)** | *"Tell me the days that matter this cycle, honestly, without pretending you're certain — and help us actually hit them."* |
| **Health literacy** | Moderate–high, motivated, actively Googling. Wants sources, not vibes. |
| **Tech context** | Web-first; also uses phone. May migrate from a period-tracker (Flo/Clue) she already has. |
| **Locale** | Arabic-first / RTL a first-class case; also EN/FR/ES. Modesty and privacy sensitivity high in AR markets. |
| **Emotional state** | Hopeful + excited early; escalating anxiety with each negative; the two-week wait (TWW) is the acute pain point. |
| **What she is NOT (yet)** | Not an infertility patient. Pushing clinical-infertility framing at her prematurely is a trust-breaker and a churn driver. |
| **Primary devices for signals** | Oral BBT thermometer, OPK/LH strips (often Easy@Home), self-observed cervical mucus (CM). |
| **Success = leaves us because…** | She got pregnant (→ Pregnancy mode), OR she crossed the 12-mo / 6-mo (≥35) line and we routed her, with dignity, toward evaluation. |

**Persona thesis.** C1 is the *high-volume, low-acuity* front door of the conception cohort. She is the modal TTC user. Get her onboarding, fertile-window honesty, and the TWW emotional experience right, and she becomes the trunk from which every other conception persona branches (see §J). Over-medicalize her and she churns to a period tracker; under-serve her signals (BBT/OPK/CM) and she churns to Premom/Fertility Friend.

---

## B. Needs & questions (voice-of-user)

Mined from r/TryingForABaby, r/TFABChartStalkers, TTC forums, and app-store reviews. Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD (early TTC):**
1. *"When is my fertile window **this** cycle?"* — and how sure are you?
2. *"We had sex on the right days — why isn't this working yet?"* (managing the gap between effort and outcome)
3. *"Am I even ovulating?"* — confirmation, not just prediction.
4. *"How do I read this OPK? Is this line dark enough?"* (line-eye anxiety)
5. *"My temps are all over the place — did I ovulate or not?"* (BBT noise: sleep, alcohol, illness, thermometer)
6. *"What does 'egg-white cervical mucus' actually look like?"* (CM literacy gap)
7. *"How do I get my partner to care / test his side / show up on the right days?"*
8. *"What should I be doing to optimize — folic acid, caffeine, lube, timing?"*
9. *"Is it too early to worry? When is 'not working' actually a problem?"*
10. *"I'm 8 DPO and my boobs hurt — is this a symptom?"* (the TWW obsession)

**Emotional arc (per cycle) — design must respect this:**
- **Follicular / pre-window:** planning, optimism, "let's do this."
- **Fertile window:** urgency, performance pressure ("timed intercourse" can feel clinical/unromantic).
- **Two-week wait (TWW):** obsessive symptom-spotting, "am I / aren't I," high anxiety. Community consensus: *every cycle is a full emotional arc — hope at ovulation, obsessive analysis in the TWW, elation or private grief at the end.* [ASRM notes infertility-related stress can rival that of serious medical diagnoses.]
- **Cycle end:** either positive (→ joy, new fears) or negative (→ grief "no one else sees") and reset.

**Anti-needs / trust-breakers (what makes her churn):**
- Being told a prediction is a fact ("You WILL ovulate on the 14th") when the app can't know.
- Being pushed into "infertility," "IVF," or clinic-referral framing in month 2. Premature medicalization = anxiety + churn.
- Any hint the fertile-window feature is a **contraceptive** ("safe days") — she may be TTC, but mis-framing erodes trust and is out of scope.
- Data-privacy creep (see FTC actions vs. Flo and Premom, §C) — reproductive data leaking to ad networks.
- Toxic-positivity ("just relax!") or, conversely, clinical doom-framing.

**Feature requests recurring in reviews/forums:**
- OPK photo-reading that improves over time (Premom's moat).
- Overlay/compare charts across cycles; "chart stalking" community wants shareable charts.
- Honest confidence on the window, not a single glowing "fertile day."
- Real partner involvement (not a read-only afterthought).
- Export chart as PDF/image for a clinician *if/when* needed.

---

## C. Competitor teardown

Feature-by-feature. Key insight for Femio: **the category is fragmented** — no single app does honest-prediction + deep BBT/OPK/CM + genuine partner mode + trustworthy privacy + Arabic/RTL + reachable full-lifespan content. C1 today often stacks 2–3 apps (e.g., Flo for cycle + Premom for OPK + Fertility Friend for BBT charting).

| App | BBT charting | OPK reading | CM logging | Fertile-window algo | Partner mode | Integrations | Notable privacy / positioning |
|---|---|---|---|---|---|---|---|
| **Premom** | Yes (basic) | **Best-in-class** — photographs strip, analyses line darkness, LH-progression charts; tuned for Easy@Home | Yes | LH-anchored + calendar | Limited | Easy@Home ecosystem, wearables | **FTC settlement 2023** for sharing fertility/period data with 3rd-party analytics; since updated. |
| **Flo** | Basic | Manual | Yes | Cycle/statistical | "Flo for Partners" (light) | Wearables, Apple Health | **FTC settlement 2021** (data to Facebook/Google); added **Anonymous Mode**. Huge reach, shallow TTC depth. |
| **Clue** | Basic | Manual | Yes | Science-communication-led | Light | Apple Health | Strong, well-regarded privacy policy (PII stored separately from health data); EU/GDPR posture. Less TTC-signal depth. |
| **Ovia Fertility** | Yes | Manual | Yes | Data-rich (weight, sleep, stress, nutrition) | Some visibility | Employer/health-plan channel; wearables | Generous free tier; B2B2C via employers. |
| **Glow** | Yes | Manual/some | Yes | Cycle + community | Partner linking | Apple Health | Community-heavy; historic privacy scrutiny. |
| **Natural Cycles** | **Core** (BBT/wearable) | Add-on | Some | **FDA-cleared** algorithm — but that clearance is for **contraception/planning**, a *regulated* posture Femio deliberately avoids | Light | Wearables (Oura, Apple Watch temp) | Regulated medical-device path; **out of Femio scope** as a contraceptive. |
| **Fertility Friend** | **Best-in-class** — 25 yrs of FAM/BBT charting, coverline, cross-checks | Manual entry | Deep | FAM (BBT + CM cross-check, "3 over 6") | Sharing | Data export | Power-user gold standard; dated UX; the "chart-stalker" home. |
| **Kindara** | Deep (FAM), Wink thermometer | Manual | Deep (CM + cervical position) | FAM (Marquette-ish/sympto-thermal) | **Share full chart with partner/practitioner** | Wink BBT device | FAM purist community; strong partner/practitioner sharing. |
| **Read Your Body** | Manual (customisable) | Manual | Deep, fully user-defined | User-driven FAM (no auto-interpretation by design) | Partner app on roadmap | Minimal | **Privacy-first / no-cloud-marketing** ethos; no algorithmic overreach. |

**Fragmentation map (the opening for Femio):**
- **Signal depth** lives in Fertility Friend / Kindara / Premom — but with dated UX, single-purpose scope, no lifespan continuity.
- **Reach & polish** live in Flo / Clue — but with shallow TTC signal handling and (historically) privacy problems.
- **Regulated contraception** is Natural Cycles' lane — Femio stays out of it entirely.
- **Nobody** combines: honest/uncertainty-aware window + deep BBT+OPK+CM + true partner mode + trustworthy privacy-by-design + Arabic-first RTL + one account that keeps *all other women's-health knowledge reachable*. **That gap is C1's Femio thesis.**

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, or prevent; it educates and helps users track.

**Fertile window (the biology):**
- The fertile window is the **~6-day interval ending on the day of ovulation** (5 days pre-ovulation + ovulation day), because sperm can survive ~5 days and the egg ~12–24 h. [ASRM *Optimizing Natural Fertility*; NHS; MedlinePlus]
- Cervical mucus volume/character correlates with the fertile window and CM monitoring is among the most reliable self-detection methods; CM typically peaks 1–2 days before ovulation. [ASRM; NHS]
- BBT tracking is mainly **retrospective**: a sustained temperature pattern may support that ovulation has already occurred, but it does **not** predict ovulation forward or guarantee it. [ASRM *Optimizing Natural Fertility* (2022)]
- Combining methods (CM + BBT + urinary LH/OPK) improves ovulation detection accuracy. [ASRM; MedlinePlus]

**Conception timing & frequency:**
- Highest pregnancy rates: intercourse **every 1–2 days** during the fertile window; **2–3×/week** is nearly equivalent and less pressured. [ASRM; ACOG]
- The 3–4 days **before** ovulation are the highest-yield days. [ACOG]
- Coital position and lying supine afterward have **no proven effect**. Some lubricants affect sperm in laboratory testing, but prospective studies have not shown lower cycle fecundability among lubricant users. If lubricant is wanted, discuss or select a product specifically labelled for use while trying to conceive; Femio does not endorse a brand. [ASRM *Optimizing Natural Fertility* (2022)]

**Preconception health (optimize naturally — in scope):**
- **Folic acid 400 micrograms (0.4 mg) daily** from when a person begins trying to conceive through 12 weeks of pregnancy. Higher-dose regimens require an individualized clinician recommendation. [WHO, updated 9 August 2023]
- Moderate caffeine intake—about one or two cups of coffee per day—has no apparent adverse effect on fertility or pregnancy outcomes in the ASRM review; Femio does not impose one global milligram cutoff. Avoid alcohol during pregnancy, and discuss alcohol, smoking, medicines, and other preconception risks with a clinician. [ASRM *Optimizing Natural Fertility* (2022); WHO]
- General preconception care (chronic-condition review, medication review, vaccination, dental) belongs with a clinician. [ACOG Prepregnancy Counseling; NICHD]

**WHEN to seek help (the routing rule — critical for §J):**
- **Under 35:** begin evaluation after **12 months** of regular unprotected intercourse without conception. **Age 35 or older:** begin after **6 months**. **Over 40:** more immediate evaluation may be warranted. [ASRM *Fertility Evaluation of Infertile Women* (2021)]
- Seek help **without delay, regardless of duration**, with known risk factors such as irregular/absent cycles, known or suspected uterine-tubal-peritoneal disease or endometriosis, or known/suspected male subfertility. Local referral pathways may differ. [ASRM (2021)]

*Femio applies these thresholds as **educational routing**, always ending "discuss with your clinician" — never as a diagnosis.*

Medical-review resolution: BBT, lubricant, caffeine, folic-acid, and evaluation wording follows [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Uncertainty-honest fertile-window predictor** — shows a *window with confidence*, not a false-precise single day. Language: "most likely fertile days," "prediction, not a guarantee." Learns from her own logged data (cycle length, LH, CM, BBT confirmation).
2. **BBT charting** — daily temp entry, auto coverline/thermal-shift detection, ovulation-confirmation marker, cross-cycle overlay, noise flags (illness/alcohol/short sleep/late reading).
3. **OPK / LH logging + photo-assisted reading** — capture strip, estimate line intensity, plot LH progression, mark peak; manual override always available.
4. **Cervical mucus (CM) logging with a visual literacy guide** — dry→sticky→creamy→watery→egg-white scale with images/illustrations and RTL-friendly labels.
5. **Sympto-thermal cross-check** — combine CM + BBT + LH to *confirm* ovulation (educational, FAM-style), clearly labelled awareness-not-contraception.
6. **Two-Week-Wait (TWW) experience** — DPO counter, gentle daily cards, honest "too early to test" guidance, anxiety-aware tone, test-timing helper.
7. **Partner mode** — invited partner sees the window + "today: yes/maybe/rest" nudge, shared calendar, optional male-preconception tips; consent-gated, revocable.

**P1 — Strong differentiators (fast follow):**
8. **Preconception optimization plan** — folic acid reminder, lifestyle checklist, sperm-friendly-lube note, all cited (§D).
9. **Chart export (PDF/image)** — hand to a clinician *if/when* she chooses.
10. **Cycle history + pattern insights** — "your luteal phase averages 13 days," ovulation-day variance, without alarmism.
11. **Wearable / device import** — Apple Health, temp-capable wearables (Oura/Apple Watch), Easy@Home-style strips.
12. **"Am I on track?" honesty module** — a calm, non-clinical explainer on normal time-to-pregnancy (many healthy couples take several months), pre-empting premature panic.

**P2 — Nice-to-have / later:**
13. Community or moderated Q&A (privacy-safe).
14. Custom trackable symptoms (Read-Your-Body-style flexibility).
15. Cervical-position logging (FAM power users).
16. Localized coaching content by market (AR modesty-aware framing).

**Explicitly OUT of scope for C1 (guardrail):**
- Any "safe days / avoid pregnancy / contraception" mode. **Never.**
- Diagnosis of anovulation/PCOS/infertility (screeners may *flag & route*, never diagnose — §K).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries source citations and "not medical advice / discuss with your clinician."

- **CM-101:** "What cervical mucus tells you" — the dry→egg-white scale, with illustrations.
- **BBT-101:** "Reading your temperature chart" — what a thermal shift means, why BBT confirms (doesn't predict), common noise sources.
- **OPK-101:** "How to read an ovulation test" — LH surge, timing sex after a positive, why a positive ≠ ovulation happened.
- **The fertile window, honestly** — the 6-day window, why we show a *range*, sperm/egg lifespan.
- **Timing & frequency** — every 1–2 days vs 2–3×/week; reducing "timed-sex" pressure.
- **Preconception starter** — folic acid 400 mcg, lifestyle, caffeine/alcohol, lube choice (all cited).
- **The two-week wait** — what's real vs. myth in "symptoms," when to test, coping with the wait.
- **Partner's role** — male-factor basics, lifestyle, showing up on the right days (partner-facing variant).
- **"Is this normal?" / how long is normal** — time-to-pregnancy expectations; the 12-mo (6-mo if ≥35) guidance framed as *education*, not a verdict.
- **When to consider seeing a clinician** — the routing content (§J/§D), calm and non-alarming.
- **Reachable-but-hidden library:** full-lifespan women's-health content (periods, contraception education, gynae conditions, perimenopause) remains searchable so C1 never feels boxed into "TTC only."

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception)

**Logs (inputs):**
- BBT (°C/°F, time of reading, quality flags), OPK/LH result + photo, CM (type), cervical position (optional), intercourse, period flow, mood/symptoms, meds/supplements, weight/sleep (optional), test results (HPT).

**Tools:**
- Fertile-window estimator (range + confidence), coverline/thermal-shift detector, LH-progression plotter, sympto-thermal ovulation-confirmation, DPO/TWW counter, test-timing helper, cross-cycle chart overlay, PDF export, preconception checklist.

**Alerts / nudges (all opt-in, tone-calibrated, revocable):**
- "Your fertile window is *likely* opening — consider intercourse in the next few days." (awareness language)
- "Time to take today's OPK / temperature."
- "Thermal shift detected — ovulation likely occurred; your window is *probably* closing." (retrospective, honest)
- Partner nudge: "Today looks like a good day." (consent-gated)
- TWW: "It may still be too early to test — a negative now isn't conclusive."
- Preconception: daily folic-acid reminder.

**Mandatory compliance wording on every predictive surface:**
- *"Predictions are estimates based on your data — not a guarantee, and **not a method of birth control**."*
- No "safe day," "infertile day," or "you can't get pregnant today" language — **ever** (that would imply contraception, which is out of scope/regulated).
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (from screeners, non-diagnostic).
- `content_history[]`, `screener_results[]` (with timestamp + "non-diagnostic" tag).

**C1 persona-specific:**
- `ttc_start_date` (drives the 12-mo / 6-mo routing clock).
- `bbt_readings[]` {value, unit, time, quality_flags}.
- `opk_results[]` {result, line_intensity_estimate, photo_ref, timestamp}.
- `cm_log[]` {type, timestamp}, optional `cervical_position[]`.
- `intercourse_log[]` {timestamp} (fertile-timing + partner nudges).
- `ovulation_confirmed[]` {cycle, method, day}, `coverline[]`, `luteal_phase_length[]`.
- `dpo_current`, `hpt_results[]`.
- `partner_link_id`, `partner_scope` (what partner may view), `partner_consent_ts`.
- `preconception_checklist_state`, `folic_acid_start_date`.
- `predicted_window[]` {start, end, confidence} — store confidence explicitly.

*Data-minimization: collect only what powers a used feature; photo strips stored with strict retention + user-deletable. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C1):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "How long have you been trying?" → sets `ttc_start_date`, seeds the routing clock. (<3 mo = "just starting"; buckets feed §J.)
3. Age capture → sets 12-mo vs 6-mo threshold and tone.
4. "Any of these apply?" (irregular/absent cycles, known condition, prior loss, partner known issue) → if yes, soft-route toward C2/C3/C4 content *without* labeling her "infertile."
5. "How do you want to track?" (BBT / OPK / CM / minimal) → enables just those logs; others stay **reachable** via "Add tracking."
6. "Involve a partner?" → partner-mode setup or defer.
7. Consent & privacy choices.

**Home config for C1:**
- Hero = **fertile-window card (with confidence)** + today's action ("test OPK," "good day," or "rest").
- Quick-log row = the trackers she chose (BBT/OPK/CM/intercourse).
- Secondary = TWW/DPO card when post-ovulation; preconception checklist; latest relevant content module.
- **Hidden-but-reachable:** full lifespan library, contraception *education*, condition pages, perimenopause — one search/tap away. C1 is configured, not walled in.

**Adaptive tone:** early cycles = optimistic/light; as cycles accumulate, tone shifts to *validating + normalizing* (many take several months) — never alarmist, never toxic-positive.

---

## J. Adaptation triggers (state transitions)

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Positive pregnancy test** | `hpt_results` = positive (or user confirms) | Celebrate; offer switch to **Pregnancy mode**; pause fertile-window/TWW surfaces; surface early-pregnancy content (incl. continue folic acid). | Pregnancy persona |
| **12 months, no conception (<35)** | `now − ttc_start_date ≥ 12 mo` & not pregnant | Calm, non-diagnostic card: "It can be worth talking to a clinician now." Offer eval-prep content + chart export. Deepen signal support. | **C2/C3/C4** (infertility personas) — *educational routing, not diagnosis* |
| **6 months, no conception (≥35)** | age ≥ 35 & `≥ 6 mo` | Same as above, 6-mo threshold. | **C2/C3/C4** |
| **Red-flag at onboarding or via screener** | irregular/absent cycles, suspected PCOS/endo, known male factor, prior tubal/uterine issue | Soft, early route to relevant condition content + "consider earlier evaluation"; **never** auto-label "infertile." | C2/C3/C4 + condition modules |
| **Pregnancy loss reported** | user reports loss | Switch tone; grief-aware content; offer **RPL / Pregnancy-After-Loss (PAL)** pathway; suppress celebratory nudges. | RPL / PAL persona |
| **Cycle irregularity emerges over time** | logged cycles vary widely / anovulatory pattern | Non-diagnostic "your cycles look irregular — a screener/clinician can help" | Screener → clinician; relevant content |
| **Disengagement / stepping back** | inactivity, "taking a break" flag | Pause nudges; keep data; offer wellness content. | Retain, low-touch |

*All routes preserve data continuity (one account) and always end with clinician-referral language, never a diagnosis.*

---

## K. Compliance flags

1. **Not contraception (highest-priority guardrail).** Fertile-window features are conception-awareness only. Ban “safe/infertile day,” “you can’t get pregnant today,” and pregnancy-avoidance framing. Every prediction says “not a method of birth control.” Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md); classification remains a launch-market legal determination.
2. **No diagnosis / treatment / prevention.** Screeners flag & route ("screening, discuss with a clinician"); the 12-mo/6-mo thresholds are *educational routing*, not an infertility diagnosis. Avoid disease-treatment claims.
3. **Uncertainty honesty.** Predictions must display confidence and "estimate, not a guarantee." No false precision on ovulation day. (Trust + non-misleading-claims compliance.)
4. **Privacy-by-design / reproductive-data sensitivity.** Learn from category history: **Flo (FTC 2021, data to Facebook/Google)** and **Premom (FTC 2023, data to analytics firms).** No sharing of cycle/fertility data with ad networks or third-party analytics. Data minimization; explicit, granular, revocable consent; local/anonymized options; strict retention & user-deletion for OPK photos.
5. **Privacy-law implementation.** For EEA processing, fertility/reproductive data falls within GDPR Article 9; document an Article 6 basis and Article 9 condition and implement applicable access, correction, portability, and erasure workflows. Other markets—including MENA—require launch-country counsel review. Do not claim universal “GDPR/PDPL compliance” or promise residency without approved architecture/contracts. ([GDPR official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj); [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Partner mode consent.** Partner sees only what the user grants; consent logged, scope-limited, instantly revocable; no partner access to non-shared history.
7. **Medical review + citations.** Clinical content is reviewed and cited to primary sources, with the approved BBT, lubricant, caffeine, folic-acid, and fertility-evaluation wording pinned in [`FERTILITY_AWARENESS_SAFETY.md`](../compliance/FERTILITY_AWARENESS_SAFETY.md). Translation must preserve the meaning and be locale-QA’d before publication. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
8. **Non-alarming emotional safety.** TTC/TWW is emotionally loaded (ASRM: stress comparable to serious diagnoses). Tone must avoid both doom-framing and toxic positivity; loss handled with grief-aware UX.
9. **App-store health-app policy.** Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): predictions are estimates and never contraception; claims must be substantiated; required privacy/disclaimer disclosures and Google’s health-app declaration must be completed. Re-check the linked Apple/Google policies immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

- [ASRM — Optimizing Natural Fertility: A Committee Opinion (2022)](https://www.asrm.org/practice-guidance/practice-committee-documents/optimizing-natural-fertility-a-committee-opinion-2021/) · [Fertility & Sterility full text](https://www.fertstert.org/article/S0015-0282%2821%2902130-0/fulltext)
- [ASRM — Prepregnancy Counseling (2019)](https://www.asrm.org/practice-guidance/practice-committee-documents/prepregnancy-counseling-2019/)
- [ACOG — Prepregnancy Counseling (Committee Opinion)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2019/01/prepregnancy-counseling)
- [ACOG — Trying to Get Pregnant? Here's When to Have Sex](https://www.acog.org/womens-health/experts-and-stories/the-latest/trying-to-get-pregnant-heres-when-to-have-sex)
- [CDC — About Folic Acid](https://www.cdc.gov/folic-acid/about/index.html) · [CDC — Folic Acid: Facts for Clinicians](https://www.cdc.gov/folic-acid/hcp/clinical-overview/index.html) · [CDC — Planning to Get Pregnant? Get 400 mcg](https://www.cdc.gov/folic-acid/php/toolkit_hispanic/400-mcg-of-folic-acid.html)
- [MedlinePlus — Pregnancy: Identifying Fertile Days](https://medlineplus.gov/ency/article/007015.htm)
- [NICHD (NIH) — Pre-Pregnancy and Prenatal Care](https://www.nichd.nih.gov/health/topics/factsheets/preconceptioncare)
- [StatPearls (NCBI) — Physiology, Ovulation and Basal Body Temperature](https://www.ncbi.nlm.nih.gov/books/NBK546686/)
- [NICE evidence review — high-dose folic acid before/during early pregnancy (NCBI Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK612331/)
- [PMC — The timing of the "fertile window" in the menstrual cycle](https://pmc.ncbi.nlm.nih.gov/articles/PMC27529/)
- [March of Dimes — Getting ready for pregnancy: Preconception health](https://www.marchofdimes.org/find-support/topics/planning-baby/getting-ready-pregnancy-preconception-health)
- [Kindara — Fertility Awareness / features](https://www.kindara.com/) · [Kindara App Store listing](https://apps.apple.com/us/app/kindara-fertility-tracker/id522674372)
- [Read Your Body — App Store listing](https://apps.apple.com/us/app/read-your-body/id1488117813)
- [Natural Womanhood — Fertility app data-privacy review](https://naturalwomanhood.org/can-you-trust-fertility-tracking-apps-with-your-data-femtech-privacy-efficacy-2020/)
- [DuoSync — Flo-for-Partners alternatives / partner apps](https://duosync.io/flo-for-partners-alternatives-7-better-apps-for-couples/)
- [Go-Go-Gaia — Best Fertility Tracking Apps 2026 (comparison)](https://www.go-go-gaia.com/blog/best-fertility-tracking-app.html) · [Best Ovulation Tracker App 2026](https://www.go-go-gaia.com/blog/best-ovulation-tracker-app.html)
- [Illume Fertility — Coping with the Two-Week Wait](https://www.illumefertility.com/fertility-blog/how-to-cope-with-two-week-wait)
- [Cofertility — The Two-Week Wait: survival](https://www.cofertility.com/family-learn/two-week-wait-survival)

*Community material (TTC/charting forums and app-store reviews) is internal qualitative research used only to shape questions, tone, and workflow; wording is editorial paraphrase, not quotation or prevalence evidence. Privacy controls use the [FTC Flo](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v) matters. Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
