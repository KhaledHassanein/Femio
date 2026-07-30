# Persona B18 — Cancer screening & prevention (gynae/breast, proactive)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners and reminders are framed as "screening — discuss with a clinician," never as diagnosis or a prevention claim.
> Research date: 2026-07-21 · Persona band: B (reproductive-age & beyond, prevention-oriented) · Bridges B11 (HPV) and general prevention.

---

## A. Persona snapshot

**Who she is.** "Nadia," 41. Health-literate, organized, and quietly anxious about cancer — her maternal aunt had breast cancer in her 50s and a cousin had an "abnormal smear" that needed follow-up. Nadia isn't sick and isn't seeking a diagnosis; she wants to be the woman who *stays on top of the boring stuff*: her cervical screening, her first mammogram (she's just entered the age where guidance starts), knowing her breasts well enough to notice a change, and understanding whether her family history means she should ask about genetics. Arabic-first, also reads English; uses the web on her phone and laptop.

**What she's managing (a schedule, not a disease).**
- **Cervical screening (Pap/HPV)** — knows she's "due for a smear" but not the current interval, what HPV-primary means, or why the interval recently changed. Guidelines differ by country, which confuses her.
- **Breast screening** — just turned 41 and hears conflicting things ("start at 40," "start at 50," "every year," "every two years"). Wants to know what's right *for her age and risk*.
- **Breast self-awareness** — was taught "self-exams" years ago; has since heard the advice changed to "awareness." Wants clarity on what she's actually meant to do.
- **HPV & vaccination** — wasn't vaccinated as a teen; wonders if it's "too late" at 41 (bridges B11).
- **Family history / BRCA** — the aunt-and-cousin history nags at her. Doesn't know if it's "enough" to warrant a genetics referral, or how to even raise it.

**Core emotional drivers.** Wants to feel *on top of it and reassured*, not *scared into it*. Screening content aimed at her often reads as fear-based ("don't die of a preventable cancer"); she wants calm, factual, "here's your schedule and what each test is." She wants to convert diffuse cancer anxiety into a small set of concrete, dateable actions — and then stop worrying between them.

**Jobs-to-be-done.**
1. Know *what* screenings apply to her, *when* each is due, and get a gentle reminder — a personal screening calendar.
2. Understand *what each test actually is* (Pap vs HPV test vs co-test; mammogram; clinical breast exam) before she's in the room.
3. Learn breast self-awareness — what "normal for me" feels like and what change is worth a clinician visit.
4. Get HPV and HPV-vaccination facts, including "am I too old?" answered honestly.
5. Assess whether her family history warrants asking about genetic counseling/BRCA — and how to raise it.
6. Have somewhere calm to land when a result comes back "abnormal" that routes her to her clinician, not to Dr. Google panic.

**Success = she walks into appointments knowing what's due and what to ask, stops losing track between screenings, and feels informed rather than frightened — without Femio ever telling her she has, or will get, cancer.**

---

## B. Needs & questions (voice-of-user)

Mined from screening/prevention communities, patient-experience literature, and screening-behavior studies (see Sources). Paraphrased to avoid quoting individuals.

**On tracking & reminders (the core unmet need):**
- "I genuinely cannot remember the last time I had a smear. Was it two years ago? Four? Nothing reminds me."
- "My period app knows everything about my cycle but has never once mentioned I might be due for a Pap."
- "I want one place that tells me: cervical — due; mammogram — not yet; here's when."
- "The recall letter comes from the clinic, but I move house and change GPs and it falls through the cracks."

**On understanding the tests:**
- "What's the difference between a Pap smear and an HPV test? My clinic switched and I don't understand what changed."
- "They told me my interval is now 5 years instead of 3 and I panicked that they were skimping — turns out it's the HPV test. Nobody explained."
- "What actually happens at a mammogram? Does it hurt? How long?"

**On breast awareness:**
- "I was taught to do self-exams on a schedule; now they say don't? So what am I supposed to do?"
- "I feel a lumpiness before my period every month — how do I know what's normal for me and what's a red flag?"

**On HPV & vaccination:**
- "I never got the HPV shot. Am I too old now at 41? Is there any point?"
- "If I have a long-term partner, do I still need HPV screening?"

**On family history / genetics:**
- "My aunt had breast cancer. Does that mean I need genetic testing, or am I overreacting?"
- "How much family history is 'enough' to bring up BRCA with my doctor?"
- "I don't even know how to start that conversation with a GP who's rushing."

**On abnormal results (the anxiety spike):**
- "My HPV test came back positive and I spiraled — I thought it meant cancer. It doesn't, but nobody framed it calmly."
- "Got recalled after a mammogram. The week of waiting was the worst part. I needed something reassuring and factual."

**Top recurring questions Femio must answer in-product:**
1. What screenings apply to me at my age, and when is each one due?
2. What is a Pap test vs an HPV test vs co-testing — and why did my interval change?
3. When should I start mammograms, and how often — and does my family history change that?
4. What does "breast awareness" mean now, and what change should I get checked?
5. Is the HPV vaccine worth it at my age?
6. Does my family history warrant asking about genetic counseling/BRCA?
7. My result was abnormal — what does it mean and what happens next? (calm, clinician-routing)

---

## C. Competitor teardown

Focused on the near-total absence of a *screening-schedule* layer in mainstream women's-health apps. This is B18's clearest whitespace.

| App | Model | Screening-reminder capability | Screening education | Risk-based guidance | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | **No dedicated cervical/breast screening scheduler.** Cycle/ovulation-centric; some general health-article content | Some HPV/cancer articles, not schedule-linked | None age/risk-based for screening | **FTC settlement (2021) for sharing period/pregnancy data; class settlement (2025)** — trust damage | Age/risk-based screening calendar + reminders + calm education; privacy-by-design |
| **Clue** | Freemium, science-forward | No screening-recall scheduler; strong cycle science, neutral tone | Good general health content, not a screening tracker | None | Better GDPR posture | Screening-schedule layer + referenced screening content + Arabic-first/RTL |
| **Ovia** | Freemium, health-plan tie-ins | Health-plan nudges exist but employer-data model; not a neutral personal screening tracker | Some | Limited | Employer/health-plan data concerns | Neutral, non-employer, privacy-first screening reminders |
| **Know Your Lemons** | Nonprofit breast-awareness app | **Breast-awareness focus** + reminder to self-check ~3 days after period; strong breast education | Breast only (no cervical, no full schedule) | Symptom-education, not full risk model | Nonprofit, trusted | Femio matches breast-awareness depth **and** adds cervical + HPV + family-history + a unified schedule |
| **MyChart / patient portals** | Health-system EMR portal | Real recall/reminders *if* your system uses it and you stay in-network | Minimal patient education | Clinician-driven | Institutional | Femio = portable, life-long, cross-provider, multilingual layer that survives moving/changing clinicians |
| **National programme letters** (NHS recall, etc.) | Government screening recall | Postal/email recall by age band — reliable but rigid, region-bound, breaks on address/provider change | Leaflets | Age-band only | Governmental | Femio = personal, always-with-you complement that explains *why* and survives relocation/expat life |
| **Generic reminder/calendar apps** | To-do apps | User must know the interval and enter it themselves | None | None | Varies | Femio pre-loads the *right* interval by age/region/risk and explains each test |

**Cross-cutting failure:** the mainstream cycle apps have effectively **no screening-recall layer** — they optimize the fertile-window/period problem and ignore lifelong preventive gynae/breast screening. The only apps that touch it are single-purpose (breast-only) or institution-bound (portals, national recall) that break when a woman moves, changes providers, or lives between health systems (a major MENA/expat reality). Femio's opening: **a portable, multilingual, age/risk-based screening calendar with calm, referenced education for each test — that never diagnoses and always routes to a clinician.**

---

## D. Clinical grounding (cited)

All figures below are for **average-risk** women unless stated, are **educational/screening-framing only**, and are **region-varying** (see §K). Femio surfaces the applicable guideline transparently and defers to the user's clinician and local programme.

### Cervical screening (Pap / HPV / HPV-primary)
- **USPSTF (US):** ages 21–29 → cytology (Pap) every 3 years; ages 30–65 → **HPV testing every 5 years (preferred)**, or Pap every 3 years, or co-testing (HPV+Pap) every 5 years. Screening not recommended <21, or >65 after adequate prior normal screening, or after total hysterectomy for benign reasons. A 2024 draft update moves toward **HPV-primary as preferred from 30** and adds **self-collected samples** [USPSTF Cervical Cancer Screening](https://www.uspreventiveservicestaskforce.org/uspstf/draft-recommendation/cervical-cancer-screening-adults-adolescents).
- **ACS (US, Tier-2):** begin screening at **age 25**; **primary HPV test every 5 years through 65** (preferred); if unavailable, co-test every 5 years or Pap every 3 years. **Self-collected vaginal HPV samples acceptable** (2025 update) [ACS Cervical Cancer Screening Guidelines](https://www.cancer.org/cancer/types/cervical-cancer/detection-diagnosis-staging/cervical-cancer-screening-guidelines.html); [ACS 2025 update press release](https://pressroom.cancer.org/updated-cervical-cancer-screening-guidelines-2025).
- **WHO (global):** **HPV-DNA as the primary screening test from age 30, every 5–10 years** for the general population; from **25, every 3–5 years** for women living with HIV. Part of the cervical-cancer elimination strategy (90% vaccinated / 70% screened with a high-performance test by 35 and 45 / 90% treated) [WHO: Screening for cervical cancer](https://www.who.int/activities/screening-for-cervical-cancer); [WHO recommends HPV DNA as first-choice test](https://www.who.int/europe/news/item/11-09-2021-who-recommends-dna-testing-as-a-first-choice-screening-method-for-cervical-cancer-prevention).
- **NHS (UK):** ages **25–64**; HPV-primary. From July 2025, HPV-negative women 25–49 recalled at **5-year** (previously 3-year) intervals; 50–64 at 5-year intervals; invitations usually stop at 65 [NHS Cervical Screening Programme](https://www.england.nhs.uk/south-east/info-professionals/public-health/cervical-screening/6374-2/introduction-2/the-nhs-cervical-screening-programme/).

**Teaching point Femio must convey calmly:** the shift to *longer* intervals reflects the HPV test being *more sensitive*, not a reduction in care — a top source of user confusion (§B).

### Breast screening (self-awareness / clinical exam / mammogram by age & risk)
- **USPSTF (US, 2024):** biennial screening mammography for **all women 40–74** (average risk). This upgraded the prior 40–49 "individual decision" to a routine recommendation [USPSTF Breast Cancer Screening](https://www.uspreventiveservicestaskforce.org/uspstf/recommendation/breast-cancer-screening).
- **ACS (US, Tier-2):** option to start annual mammograms at **40–44**; **annual 45–54**; **biennial (or continue annual) 55+** while healthy. ACS and others note annual screening from 40 maximizes lives saved; USPSTF favors biennial — a genuine guideline difference to present neutrally [ACS supports updated USPSTF guidelines](https://pressroom.cancer.org/releases?item=1320).
- **NHS (UK):** routine mammography invitations **50 up to 71st birthday, every 3 years** [NHS: Who breast screening is for](https://www.nhs.uk/tests-and-treatments/breast-screening-mammogram/who-breast-screening-is-for/).
- **Breast self-awareness vs. self-exam:** ACS, NCCN, and ACOG **encourage breast self-awareness** (knowing how your breasts normally look and feel, reporting changes) but **do not recommend routine scheduled breast self-exams**; USPSTF/AAFP **recommend against teaching formal BSE** because it has not reduced mortality and increases benign biopsies. NCCN suggests clinical breast exam every 1–3 years at 25–39, then annually from 40 [Why breast 'awareness' replaced self-exams — Novant Health](https://www.novanthealth.org/healthy-headlines/why-breast-awareness-has-replaced-self-exams); [Breast Self-Examination — StatPearls/NIH](https://www.ncbi.nlm.nih.gov/books/NBK565846/). **Femio therefore teaches awareness, not a scheduled self-exam ritual.**

### HPV & HPV vaccination (bridges B11)
- **CDC/ACIP:** routine HPV vaccination at **11–12 (can start at 9)**; catch-up **through 26** if not adequately vaccinated. For **27–45**, **shared clinical decision-making** — public-health benefit is smaller because many have prior exposure; not licensed **>45**. Vaccination does **not** replace cervical screening [CDC HPV Vaccine Recommendations](https://www.cdc.gov/hpv/hcp/vaccination-considerations/index.html); [CDC/ACIP adults 27–45](https://www.cdc.gov/acip/evidence-to-recommendations/HPV-adults-etr.html).
- **Teaching point for Nadia:** "too old at 41?" → honest answer is *diminishing but individualized benefit; discuss with your clinician* — never a blanket yes/no.

### Family history / BRCA
- **USPSTF:** for women with **personal or family history** of breast, ovarian, tubal, or peritoneal cancer, **or ancestry associated with BRCA1/2 mutations**, use a **brief familial-risk-assessment tool**; if positive → **genetic counseling**, and **if indicated after counseling, genetic testing**. **Against** routine risk assessment/testing for women *not* at increased risk [USPSTF BRCA-Related Cancer](https://www.uspreventiveservicestaskforce.org/uspstf/recommendation/brca-related-cancer-risk-assessment-genetic-counseling-and-genetic-testing).
- **Femio's role:** a **family-history awareness checklist** that helps her decide whether to *raise genetics with her clinician* — explicitly **not** a risk score, not a test, not a verdict. The output is always "these factors are worth discussing with a clinician / genetic counselor."

**Femio scope guardrail restated:** every screening interval, vaccine note, and family-history prompt is presented as **wellness education + a reminder to discuss with a clinician**. Femio makes **no prevention claim** ("do X to prevent cancer"), performs no diagnosis, and never tells a user she is or isn't at risk. Screening reminders are framed as *"many guidelines suggest this may be due — discuss timing with your clinician,"* not *"you must be screened now."*

*Country-schedule rule:* the global persona does not display a MENA, US, or UK screening interval. It provides general education from the [WHO cervical screening guideline, second edition (2021)](https://www.who.int/publications/i/item/9789240040434) and [WHO mammography position paper (2014)](https://www.who.int/publications/i/item/9789241507936), then asks the user to select a country or consult a clinician. A schedule activates only after its national-authority source, effective date, population, exceptions, and local reviewer are recorded. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to adopt.**
1. **Personal screening calendar (age/risk-based)** — a single view of applicable screenings (cervical, breast, +HPV-vaccination status), each with "due / not yet / overdue-to-discuss" status, seeded from her age, region-guideline selection, and self-reported last-screening dates and risk factors. **Framed as reminders to discuss with a clinician, never as medical orders.**
2. **Screening reminders** — gentle, dismissible, region-aware nudges ("Many guidelines suggest cervical screening may be due around now — worth raising at your next visit"). No countdown-of-doom, no "overdue!" alarm language.
3. **"What is this test?" education** — plain-language cards for Pap, HPV test, co-testing, mammogram, clinical breast exam: what it is, what happens, why intervals differ, what results *categories* mean (not interpreting hers).
4. **Breast self-awareness module** — teaches "know your normal," what changes warrant a clinician visit; explicitly *awareness*, not a scheduled self-exam ritual.
5. **Family-history awareness checklist** — non-scored prompts (relatives affected, cancer types, ages, ancestry) → output = "these are worth discussing; ask about genetic counseling," with USPSTF-aligned framing. Never a risk percentage.
6. **Privacy-by-design** — screening/family-history data is special-category; no ad-SDK sharing; granular consent; export/delete.

**P1 — strong differentiators.**
7. **HPV & vaccination hub** (bridges B11) — HPV basics, vaccine ages/catch-up, honest "am I too old?" shared-decision framing, "vaccine ≠ skip screening."
8. **Region/guideline selector** — user picks her country/programme (US-USPSTF, US-ACS, UK-NHS, WHO-default, or "my clinician's advice"); the calendar and intervals adapt transparently.
9. **Abnormal-result support flow** — a calm, referenced explainer ("a positive HPV test is common and usually not cancer; here's what next steps typically look like") that **routes to her clinician** and offers emotional-support/anxiety content. Never interprets her specific result.
10. **Appointment/result log + visit-prep** — record what was done, when, and outcome-category; export a "what's due / what to ask" summary.

**P2 — depth / retention.**
11. Cycle-linked breast-awareness timing tip (for still-cycling users: "breasts often feel lumpier before a period — check-in when settled"), à la Know Your Lemons — optional.
12. Learning tracks: "Prevention 101," "Understanding your HPV result," "Family history & genetics."
13. Life-stage handoff prompts (e.g., approaching mammogram-start age, or aging out of cervical screening) surfaced as education.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Screening 101 — your prevention checklist** — which screenings exist for women, roughly when, and that intervals vary by country and risk.
2. **Cervical screening explained** — Pap vs HPV test vs co-testing; HPV-primary; why intervals lengthened (more sensitive test, *not* less care); self-collection.
3. **HPV: the basics** (bridges B11) — what HPV is, how common, how it relates to cervical cancer, that most infections clear.
4. **HPV vaccination** — who it's for, catch-up to 26, shared decision-making 27–45, "vaccine doesn't replace screening."
5. **Breast screening by age & risk** — mammograms: when to start, how often, USPSTF vs ACS vs NHS differences presented neutrally; what a mammogram is like.
6. **Breast self-awareness** — "know your normal," normal cyclical changes, which changes to get checked; why the guidance moved from scheduled self-exams to awareness.
7. **Family history & BRCA** — what family history matters, what BRCA is, when to ask about genetic counseling; that testing is a counseled, clinician-led decision.
8. **Understanding an abnormal result** — HPV-positive, abnormal Pap categories, mammogram recall: what they commonly mean, that abnormal ≠ cancer, what next steps typically involve — all "discuss with your clinician."
9. **Getting the most from your screening appointment** — what to ask, how to raise family history, keeping your own record.
10. **Myths vs. evidence** — "no symptoms so I don't need screening," "vaccine means I can skip smears," "a longer interval means they're cutting corners," "one relative with cancer means I definitely carry BRCA."

Every module: referenced citations, medical-review byline + date, region-varies note where applicable, and a "discuss with your clinician" footer.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Screening history log:** last cervical screening (type + date), last mammogram/clinical breast exam, HPV-vaccination status/doses, results *category* (normal / abnormal-follow-up / recalled) — entry only, no interpretation.
- **Family-history record:** affected relatives, cancer types, ages at diagnosis, ancestry flags — for the awareness checklist; user-owned, deletable.
- **Breast-awareness notes:** optional "this is normal for me" journal + optional private (local) photo/notes; never a scheduled-exam tracker.

**Tools**
- **Screening-schedule reminders (age/risk-based)** — the flagship. Computes "may be due / not yet / worth discussing" from age + selected region-guideline + last-screening dates + risk flags (family history, prior abnormal → *surfaces tighter-follow-up education*, defers actual interval to clinician). Output language: *"Based on [guideline], cervical screening may be due around [date] — a good thing to raise with your clinician."* Never "You must screen by [date]."
- **Region/guideline selector** — transparently swaps the interval set (USPSTF / ACS / NHS / WHO / "follow my clinician").
- **Breast-awareness guide** — interactive "know your normal" + "changes worth checking" (lump, skin/nipple change, new asymmetry, discharge) framed as *reasons to see a clinician*, not a diagnosis.
- **Family-history awareness checklist** — USPSTF-aligned prompts → "worth discussing genetic counseling," never a score/percentage.
- **Visit-prep / result-log export** — one-tap "what's due + what to ask" summary.
- **Screeners (framed as screening, not diagnosis):**
  - Family-history-for-genetics awareness checklist → "These factors are worth discussing with a clinician or genetic counselor. This is not a risk score or a diagnosis."
  - Optional distress/anxiety check-in around results → "This is a screening tool, not a diagnosis" + crisis resources.

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL)**
- Screening-due reminders (cervical / breast / HPV-vaccination consideration) — calm, "worth discussing," never "overdue" alarm framing.
- Age-milestone education (approaching mammogram-start age; aging out of cervical screening) — informational, clinician-deferring.
- Abnormal-result → support-flow surfacing (calm explainer + clinician routing + emotional support).
- **Never:** "you are at risk of cancer," "this prevents cancer," "you must be screened now," any interpretation of the user's own result, or any diagnostic/BRCA-carrier statement.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account)**
- Account: age/DOB (drives eligibility), language (default AR), locale/RTL, units, region/programme selection.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: prevention-oriented; can co-exist with any B/C/F state).
- Cycle events (if still cycling — used only for optional breast-awareness timing tip).

**Persona-specific (screening & prevention)**
- **Screening schedule state:** per-screening {last-done date, type, result-category, next-suggested window, guideline-source}.
- **Cervical:** last test type (Pap/HPV/co-test), date, HPV status-category (self-entered), interval per selected guideline.
- **Breast:** last mammogram/clinical-exam date, recall/normal category, breast-awareness notes.
- **HPV vaccination:** status (none/partial/complete), doses, age at vaccination.
- **Family-history record:** relatives, cancer types, ages, ancestry flags → drives awareness checklist (not a score).
- **Risk flags (self-report, non-diagnostic):** family history present y/n, prior abnormal result y/n, known high-risk factor mentioned by clinician — used to *raise education prominence and suggest discussing tighter follow-up*, never to compute or assert risk.
- **Region/guideline preference** (US-USPSTF / US-ACS / UK-NHS / WHO / clinician-directed).

*All health/family-history fields optional, encrypted, user-deletable. Family-history data about relatives is treated as sensitive and never shared or used for ads.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B18):**
- Q: primary goal → "Stay on top of screening / prevention" ⇒ set **prevention mode ON** (stackable on any life-stage state).
- Q: age ⇒ seeds which screenings are surfaced (e.g., mammogram education gains prominence approaching the region's start age).
- Q: region / which guidelines to follow ⇒ sets interval set (default WHO if unsure; offer "follow my clinician").
- Q: last cervical screening? last mammogram? HPV vaccinated? ⇒ seeds the schedule.
- Q: family history of breast/ovarian cancer? ⇒ raises family-history checklist + genetics education prominence (never asserts risk).

**Home configuration (default for B18):**
- Hero = **screening calendar card** (what's due / not yet / worth discussing) — calm, no alarm styling.
- Cards prioritized by what's nearest-due and by flagged concerns (e.g., family-history checklist surfaced if she flagged family history).
- Breast-awareness and "what is this test?" education pinned.
- HPV/vaccination hub surfaced if unvaccinated or if she came via B11.

**Hidden-but-reachable principle:** prevention mode is **additive** — it can layer over a cycling (B), TTC (C), or menopause (F) user without removing anything. All other life-stage content remains discoverable. A user can turn prevention reminders off while keeping her logged history.

**Adaptive tuning:** if she logs a prior abnormal result or family history, raise the relevant education and the "discuss tighter follow-up with your clinician" framing (never compute a personal interval). If she approaches mammogram-start age or cervical-screening exit age, surface milestone education. If a result is logged as abnormal/recalled, surface the calm support flow.

---

## J. Adaptation triggers (life-stage & event routing)

Inherits all **universal events** from the Master Adaptation Model §6 (positive pregnancy test, loss, mood-screen-high/crisis, red-flag symptom, disengagement, toggle-mode-off, age-of-consent). B18 adds the following **persona-specific** transitions:

| Trigger | System response | Route |
|---|---|---|
| **Abnormal / positive screening result logged** (HPV+, abnormal Pap, mammogram recall) | Surface **calm abnormal-result support flow**: referenced "abnormal usually ≠ cancer" explainer + **route to clinician for next steps** + offer emotional-support/anxiety content; suppress any celebratory/prevention-y copy; never interpret her specific result | Stay B18, support layer raised; if she reports a diagnosis → **B19** |
| **Confirmed cancer diagnosis reported by user** | Sensitive acknowledgment; retire "screening reminder" framing for that site; **offer route to B19 (cancer diagnosis/survivorship persona)** carrying her record; retain all data | **→ B19 (post-diagnosis / survivorship)** |
| **High family-risk pattern flagged** (checklist indicates multiple affected relatives / young ages / relevant ancestry) | Raise **genetics-referral education**: "these factors are commonly discussed with a clinician or genetic counselor"; provide visit-prep for that conversation; **never assert BRCA status or a risk figure** | Stay B18, genetics-education layer raised |
| **Approaching mammogram-start age** (region-dependent) | Surface breast-screening education + "worth discussing when to start with your clinician" | Stay B18 |
| **Aging out of cervical screening** (e.g., 65 with adequate prior normal screening) | Surface exit-criteria education, defer to clinician confirmation | Stay B18 |
| **Unvaccinated + eligible/decision-age for HPV** | Surface HPV-vaccination shared-decision education (bridges **B11**) | Stay B18 / link B11 |
| **Sets TTC intent / becomes pregnant / enters menopause** | Prevention layer persists additively; screening reminders continue where age-appropriate; hand hero to the life-stage persona | Blend with C* / D* / F* (prevention modifier retained) |
| **Result anxiety / mood screen low around results** | Surface mental-health module + localized crisis resources (universal handler) | Stay B18, support raised |
| **Toggles prevention reminders off** | Pause reminders, preserve all screening history | Retain, silent |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking / reminders ONLY. **No diagnosis, no treatment, no disease-prevention claim, not contraception.** Screening reminders are framed as *"guidelines suggest this may be due — discuss with your clinician,"* never as a medical order or a claim that screening/vaccination "prevents cancer" for the individual.
- **Region-varying guidelines (critical):** screening and vaccination prompts are shown only when a maintained source is approved for the user-selected launch country and risk group. Each prompt displays the issuing body, version/date, and country. If no approved national schedule exists in Femio’s registry—or location is unknown—the app gives no age/interval countdown and says “ask your clinician or national screening programme.” Do not substitute a WHO, US, or UK schedule for an unverified local programme. WHO’s [2021 cervical-screening guideline](https://www.who.int/publications/i/item/9789240040434) and [mammography position paper](https://www.who.int/publications/i/item/9789241507936) are global reference documents, not automatic local schedules. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
- **Screeners / checklists:** the family-history checklist returns *"worth discussing with a clinician/genetic counselor"* — **never a risk score, percentage, or BRCA-carrier statement**. Any distress check-in returns "screening, not diagnosis" + crisis resources.
- **Result interpretation:** Femio **never interprets a user's own HPV/Pap/mammogram result**. Abnormal-result content explains *categories generically* and routes to the clinician.
- **Breast self-awareness (not self-exam):** copy teaches *awareness of normal + when to see a clinician*, consistent with ACS/ACOG/NCCN; must **not** prescribe a scheduled self-exam ritual (USPSTF/AAFP advise against teaching formal BSE).
- **HPV vaccination:** presented as shared-decision education with honest age-based benefit framing; **vaccine ≠ replacement for screening** stated explicitly; no "get vaccinated to prevent cancer" individual-prevention claim — education + clinician routing.
- **Mental health:** result-anxiety is expected; crisis resources on any low screen, localized per region/language; calm, non-fear-based tone throughout (no "don't die of a preventable cancer" messaging).
- **Privacy (GDPR/PDPL health data):** screening history, results, and **family-history data about relatives** are special-category; explicit granular consent, purpose limitation, no ad-SDK/third-party sharing, no employer/insurer visibility; full export/delete; DPIA + data-mapping required before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA; region-varies notes where intervals differ.
- **App-store health policy:** framing as tracking/education/reminders (not diagnosis or medical-device output) keeps out of regulated-device territory; screening-reminder logic must not present as clinical decision support — legal review before store submission.
- **Publication rule:** no MENA national interval, draft recommendation, or claim beyond an approved guideline’s exact scope may be displayed. New country schedules require local clinical/legal sign-off and a recorded effective date before activation.

---

## Sources

**Clinical — Tier 1 (US gov / WHO / NHS / MedlinePlus):**
- [USPSTF — Cervical Cancer: Screening (draft, 2024/25; HPV-primary preferred, self-collection)](https://www.uspreventiveservicestaskforce.org/uspstf/draft-recommendation/cervical-cancer-screening-adults-adolescents)
- [USPSTF — Breast Cancer: Screening (2024; biennial 40–74)](https://www.uspreventiveservicestaskforce.org/uspstf/recommendation/breast-cancer-screening)
- [USPSTF — BRCA-Related Cancer: Risk Assessment, Genetic Counseling & Testing](https://www.uspreventiveservicestaskforce.org/uspstf/recommendation/brca-related-cancer-risk-assessment-genetic-counseling-and-genetic-testing)
- [CDC — HPV Vaccine Recommendations (incl. 27–45 shared decision-making)](https://www.cdc.gov/hpv/hcp/vaccination-considerations/index.html)
- [CDC/ACIP — Evidence to Recommendations, HPV vaccination adults 27–45](https://www.cdc.gov/acip/evidence-to-recommendations/HPV-adults-etr.html)
- [WHO — Screening for cervical cancer (HPV-DNA primary from 30; elimination targets)](https://www.who.int/activities/screening-for-cervical-cancer)
- [WHO/Europe — HPV DNA as first-choice screening method](https://www.who.int/europe/news/item/11-09-2021-who-recommends-dna-testing-as-a-first-choice-screening-method-for-cervical-cancer-prevention)
- [WHO — Cervical cancer fact sheet](https://www.who.int/news-room/fact-sheets/detail/cervical-cancer)
- [NHS — Who breast screening is for (50–71, every 3 years)](https://www.nhs.uk/tests-and-treatments/breast-screening-mammogram/who-breast-screening-is-for/)
- [NHS England — The NHS Cervical Screening Programme (25–64; 5-year HPV-negative interval)](https://www.england.nhs.uk/south-east/info-professionals/public-health/cervical-screening/6374-2/introduction-2/the-nhs-cervical-screening-programme/)
- [Breast Self-Examination — StatPearls / NIH NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK565846/)

**Clinical — Tier 2 (society guidelines / peer-reviewed):**
- [ACS — Cervical Cancer Screening Guidelines (start 25; HPV-primary q5y)](https://www.cancer.org/cancer/types/cervical-cancer/detection-diagnosis-staging/cervical-cancer-screening-guidelines.html)
- [ACS — 2025 update: self-collection & screening exit](https://pressroom.cancer.org/updated-cervical-cancer-screening-guidelines-2025)
- [ACS — statement supporting updated USPSTF breast screening guidelines](https://pressroom.cancer.org/releases?item=1320)
- [ACOG — Human Papillomavirus Vaccination (committee opinion)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2020/08/human-papillomavirus-vaccination)
- [ACOG — Updated Cervical Cancer Screening Guidelines (practice advisory)](https://www.acog.org/clinical/clinical-guidance/practice-advisory/articles/2021/04/updated-cervical-cancer-screening-guidelines)
- [Why breast 'awareness' has replaced self-exams — Novant Health](https://www.novanthealth.org/healthy-headlines/why-breast-awareness-has-replaced-self-exams)
- [Self-collected HPV testing & screening exit — ACS guideline update, CA: Cancer J Clin (Wiley)](https://acsjournals.onlinelibrary.wiley.com/doi/10.3322/caac.70041)

**Patient journey / screening behavior / anxiety (studies + advocacy):**
- [Acceptability of extending HPV-based cervical screening intervals 3→5 years (England interviews) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC9073390/)
- [Anxiety and abnormal mammogram/Pap follow-up — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC4589306)
- [Women overdue for screening: priority & access factors — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC1711115)
- [HPV vaccine behaviors/intentions among women 27–45 (shared decision-making) — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11308683/)

**Competitor / app landscape:**
- [Know Your Lemons — breast-awareness app (self-check timing)](https://knowyourlemons.org/app)
- [Flo — period & ovulation tracker](https://flo.health/)
- [Clue — period & ovulation tracker](https://helloclue.com/)
- [11 Best Period Tracker Apps — CCRM Fertility (feature landscape)](https://www.ccrmivf.com/news/11-best-period-tracker-apps-to-know-your-cycle-according-to-obgyns/)
- [5 Free Period Tracking Apps (reminder capabilities) — HemAware](https://hemaware.org/womens-health/5-free-apps-tracking-your-menstrual-cycle)
