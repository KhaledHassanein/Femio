# Persona B4 — Reproductive-age woman with heavy menstrual bleeding (HMB / menorrhagia)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician." Red-flag symptoms (severe/uncontrolled bleeding, symptoms of significant anemia) route to "seek care."
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (invariants §1, state object §2, core §3, universal events §6, Z1 §5, blending §8). Base cycle-tracking layer inherited from **B1** (general reproductive-age cycle tracking).

---

## A. Persona snapshot

**Who she is.** "Nadia," 34. Her periods have always been on the heavier side, but over the last two years they have become "a whole event" — 8–9 days long, soaking through a super tampon *and* a pad in under two hours, flooding overnight so she wakes on a towel, passing clots the size of a coin. She plans her calendar around her period: no light-colored clothes, an aisle seat, a spare outfit in her bag, meetings avoided on her heaviest days. She is exhausted, breathless on the stairs, and has been told twice that "heavy periods are just normal for some women." She is not trying to conceive. Arabic-first (also reads English), uses the web on her phone.

**What she lives with.**
- **Objectively heavy flow** — soaking through protection hourly, "flooding," double-protection, changing products overnight, large clots. Hard to convey to a clinician with words alone.
- **Fatigue / anemia risk** — tiredness, weakness, breathlessness, dizziness, headaches, "brain fog," sometimes pica or restless legs — the downstream cost of iron loss that she and her doctors often disconnect from her periods.
- **Big quality-of-life hit** — bleeding dictates her work, wardrobe, exercise, intimacy, travel and social life; anxiety about accidents in public.
- **Normalization & dismissal** — she (and often her clinician) treats it as something to "put up with"; menstrual taboo keeps her from describing it plainly.

**Core emotional drivers.** Wants to be **believed** and to have proof that her bleeding is not "normal" — an objective number she can hand over, not a vague "it's heavy." Wants to connect the dots between the bleeding and the exhaustion. Wants to understand *why* this is happening (causes) and what the *realistic* options are, without being told to just cope — and without being funneled into a fertility or pregnancy narrative.

**Jobs-to-be-done.**
1. **Quantify** her bleeding objectively (product counts / PBAC-style score, clots, flooding, double-protection, overnight changes) so it can't be dismissed.
2. Connect bleeding severity to **fatigue/anemia** awareness and know when tiredness is a "get checked" signal.
3. Understand the **causes** of HMB (fibroids, adenomyosis, polyps, bleeding disorders, ovulatory/hormonal, etc.) at an educational level.
4. Understand the **treatment landscape** (educational only) so she walks into a visit informed, not blank.
5. Prepare for and get more out of appointments; know which tests are standard (full blood count / ferritin, ultrasound).
6. Know the **red flags** that mean "seek care now" vs. "book a routine visit."

**Success = she stops guessing and hands her clinician a one-page, objective bleeding-and-symptom summary — and gets taken seriously the first time.**

---

## B. Needs & questions (voice-of-user)

Mined from HMB/menorrhagia communities, online-forum thematic analyses, qualitative primary-care studies, and app-store reviews (see Sources). Paraphrased to avoid quoting individuals.

**On quantifying / being believed (the #1 pain):**
- "How do I *prove* it's heavy? My doctor just says 'some women are heavy' — I need a number."
- "I soak a super tampon and a pad every hour and I still got told it was normal."
- "I want to log how many pads/tampons I actually use and how soaked they are, not just tap 'heavy.'"
- "None of the apps let me say I'm *flooding* or doubling up — 'heavy' doesn't cover this."
- "I pass clots bigger than a coin and no app asks about clots."

**On fatigue / anemia:**
- "I'm exhausted all the time and nobody connected it to my periods until I was severely anemic."
- "Is the tiredness/breathlessness the bleeding? When should I get my iron checked?"
- "I crave ice constantly — turns out that's an iron thing."

**On causes and 'what is this':**
- "Is this fibroids? Adenomyosis? A bleeding disorder? I don't even know what to ask about."
- "I've bled heavily since my very first period — could that mean something different?"

**On treatment (educational):**
- "What are my options besides 'just live with it' or 'have surgery'? What's the coil/tranexamic acid I keep hearing about?"
- "I don't want a hysterectomy pushed on me — what's in between?"

**On daily life / dignity:**
- "I plan my whole month around my period. I've ruined clothes at work."
- "The anxiety about bleeding through in public is its own thing."

**On visit prep:**
- "I freeze up in the 10-minute appointment and forget how bad it really was."
- "What tests are normal for this? What should I ask for?"

**On privacy:**
- "After the Flo/Facebook thing I don't trust these apps with this kind of data."

**Top recurring questions Femio must answer in-product:**
1. Is my bleeding actually "heavy" by objective measures — and how do I show that to a clinician?
2. When does heavy bleeding / fatigue become a "seek care now" situation?
3. What causes heavy periods (fibroids, adenomyosis, polyps, bleeding disorders, hormonal/ovulatory)?
4. Am I at risk of anemia, and when should I ask about iron/ferritin testing?
5. What are the treatment options, in plain language (educational)?
6. How do I prepare for my appointment and what tests are standard?

---

## C. Competitor teardown

Feature-by-feature, focused on where trackers fail HMB users on **bleeding quantification** and **anemia awareness**.

| App | Model | Bleeding quantification | Flooding / clots / double-protection | Anemia awareness | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | Flow as light/medium/heavy taps; no product count, no validated severity score | No dedicated "flooding" / clot-size / overnight-change / doubling-up capture | Limited; no structured iron/fatigue linkage | **FTC action (2021) for sharing period/pregnancy data; ~$56M class settlement (2025)** — trust damage | Objective product-count + PBAC-style score; clot/flooding capture; anemia-symptom awareness; privacy-by-design |
| **Clue** | Freemium, science-forward | Plus tier tracks flow heaviness/color/spotting; still user-interpreted light/medium/heavy | Better bleeding taxonomy but no product-soak scoring or flooding tier; users have asked for "flooding" and been unable to log it | Neutral symptom logging, no iron pathway | Better GDPR posture | PBAC-style quantification + anemia red-flag layer + Arabic-first/RTL + referenced HMB content |
| **Ovia** | Freemium, health-plan tie-ins | Standard flow logging | No HMB-specific severity capture | No | Employer/health-plan data model concerns | Non-TTC, non-employer, privacy-first, HMB-specific |
| **Stardust** | Privacy-forward, local-first | Symptom/flow logging; astrology framing | No HMB severity model | No | **Strong: local storage** | Clinical credibility + HMB depth + objective quantification |
| **bleep / iron-tracking & fibroid apps** (niche) | Various | Some fibroid/HMB-niche apps add product counts | Varies; inconsistent | Some fatigue logging | Unclear | Femio unifies objective bleeding score + anemia awareness + referenced content + visit-prep in one lifespan account |
| **Generic "flow = 3 dots" trackers** | — | Three-level flow only | None | None | Varies | The core failure Femio targets |

**Cross-cutting failure for HMB users:** flow is captured as an unvalidated light/medium/heavy tap that "has not been validated against any independent measure of flow volume" and is interpreted differently by every user. There is **no objective, transferable number** to hand a clinician, and the vocabulary (flooding, clots, double-protection, overnight changes, "period products used per day") that HMB users actually live by is missing. Femio's answer: a **PBAC-style / product-count quantifier** that produces a semi-objective score and an exportable summary, plus an **anemia-symptom awareness** layer that connects bleeding to fatigue — neither of which is offered by mainstream trackers.

*[NEEDS SOURCE] — specific per-app feature claims are from app-store listings, review roundups and forum reports; verify against current app versions before any public comparative claim.*

---

## D. Clinical grounding (cited)

**Definition.** Heavy menstrual bleeding (HMB) — historically "menorrhagia" — is excessive menstrual blood loss that interferes with a woman's physical, social, emotional and/or material quality of life. NICE deliberately anchors the definition in **impact on quality of life**, not a lab number, so a woman's own report counts [NICE NG88; NHS]. The classic research threshold is **>80 mL blood loss per period** or **duration >7 days**, but this is impractical to measure in daily life [InformedHealth/NCBI; Mayo Clinic]. Roughly **1 in 10** women experience very heavy periods [InformedHealth/NCBI].

**Practical / self-report signs of HMB (used clinically and for patient education).** Soaking through one or more pads or tampons **every hour for several hours in a row**; needing **double protection** (pad + tampon); needing to **change protection during the night**; bleeding **longer than 7 days**; passing **blood clots the size of a quarter (~2.5 cm) or larger**; flooding; and symptoms of anemia such as tiredness or shortness of breath [ACOG *Heavy Menstrual Bleeding* FAQ; Mayo Clinic].

**Quantification — PBAC.** The **Pictorial Blood loss Assessment Chart (PBAC)** is the most widely used semi-objective tool: the user scores how heavily each pad/tampon is stained plus clots and flooding across the period; a total **≥100 (some use ≥150)** correlates with HMB (>80 mL). It is validated against the alkaline-hematin gold standard with reasonable diagnostic accuracy and is used in clinical trials and primary care to aid treatment/follow-up decisions [PBAC systematic review, PMC7011238; PBAC diagnostic-accuracy study, PubMed 21228538; WFH PBAC resource]. *For Femio, PBAC-style scoring is framed as an educational/tracking aid and a conversation tool for her clinician — never a diagnosis.*

**Causes — FIGO PALM-COEIN.** The FIGO classification organizes causes of abnormal uterine bleeding into **structural (PALM)**: **P**olyp, **A**denomyosis, **L**eiomyoma (fibroids), **M**alignancy/hyperplasia; and **non-structural (COEIN)**: **C**oagulopathy (e.g. von Willebrand disease — notably in those heavy *since menarche*), **O**vulatory dysfunction, **E**ndometrial, **I**atrogenic (e.g. copper IUD, anticoagulants), and **N**ot otherwise classified [FIGO/Munro 2011, Int J Gynecol Obstet; PALM-COEIN overview]. Fibroids and adenomyosis are common structural drivers; a bleeding disorder should be considered especially with lifelong heavy bleeding [Mayo Clinic; ACOG].

**Anemia / iron deficiency (why the fatigue matters).** HMB is a leading cause of iron deficiency and iron-deficiency anemia in reproductive-age women; **up to ~63%** of women with HMB have iron deficiency or iron-deficiency anemia, and iron deficiency can cause fatigue **even before** anemia develops [AJOG 2023; PMC6500811]. Common symptoms: **fatigue (most common), weakness, headache, breathlessness, dizziness, brain fog, pica (e.g. craving ice), restless legs, hair loss** [PMC11869313; Pediatrics Nationwide]. A **full blood count is the key baseline test; iron deficiency should be treated actively** [NICE NG88]. Femio surfaces these as *awareness + "ask your clinician about iron/ferritin testing,"* never a diagnosis or supplement dose.

**When to seek care.** Book a clinician visit for HMB that soaks through protection hourly, lasts >7 days, needs overnight changes, involves large clots, or comes with tiredness/breathlessness [ACOG; NHS]. **Seek urgent care** for: bleeding so heavy it soaks through protection every hour for several hours; signs of significant blood loss / severe anemia (severe breathlessness, chest pain, fainting, racing heart, marked dizziness); or bleeding after menopause [ACOG; Mayo Clinic; NHS]. *Femio presents these as red-flag "seek care" education, never triage or diagnosis.*

**Treatment landscape (EDUCATIONAL framing only — Femio does not treat or dose).**
- **Non-hormonal:** **tranexamic acid** (taken during the period to reduce flow) and **NSAIDs** (e.g. ibuprofen, mefenamic acid) — options when contraception isn't wanted [NICE NG88; AAFP].
- **Hormonal:** the **levonorgestrel-releasing intrauterine system (LNG-IUS, e.g. Mirena)** is a first-line option for many when the cavity is suitable; combined hormonal contraception and oral progestogens also reduce bleeding [NICE NG88].
- **Procedural / surgical:** **endometrial ablation**, treatments targeting **fibroids** (e.g. myomectomy, uterine artery embolization), and **hysterectomy** as a definitive option — choice depends on cause, fertility wishes and preference [NICE NG88; Mirena-vs-ablation RCT].
- **Iron repletion** (oral or IV) is a distinct, important pillar addressing the anemia consequence [NICE NG88; AJOG 2023].
- Femio explains *what these are and why a clinician might discuss them* with a clear non-prescription disclaimer and clinician routing — it never recommends, ranks, or doses.

**Femio scope guardrail restated:** all of the above is presented as **wellness education, tracking, and screening**, with consistent "discuss with your clinician" routing and explicit "seek care now" red-flags. Femio is not contraception and does not claim to prevent or treat disease.

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Objective bleeding quantifier (PBAC-style / product-count).** Log products used per day, soak level per product (lightly/moderately/fully soaked), clots (with size reference, e.g. "coin-sized or larger"), flooding events, double-protection, and overnight changes → produces a **semi-objective daily + per-period score** shown as a trend, framed as "a way to describe your bleeding to your clinician," not a diagnosis.
2. **Anemia-symptom awareness layer.** Optional linked logging of fatigue, breathlessness, dizziness, pica, restless legs; when heavy-bleeding + symptom patterns co-occur, surface non-alarming "many clinicians suggest checking iron/ferritin — here's why" education (screening-framed).
3. **Red-flag "seek care" logic.** Prominent, dismissible "seek care now" box when logged bleeding hits urgent thresholds (soaking hourly for several hours, fainting/severe breathlessness) — education + saved emergency contact, never triage.
4. **HMB cause & treatment education library** (referenced, PALM-COEIN-based; treatment as education only).
5. **Specialist-visit prep pack** — exportable/printable one-pager: bleeding score trend, product counts, clot/flooding flags, anemia-symptom summary, cycle history, questions to ask, standard-work-up checklist (FBC/ferritin, ultrasound).
6. **Non-TTC default** — no "trying to conceive?" nudges; TTC/pregnancy reachable but never assumed.
7. **Privacy-by-design** — local-first where feasible, no ad-SDK data sharing, clear controls; explicitly addresses post-Flo distrust.

**P1 — strong differentiators.**
8. Bleeding-diary "period products used" quick-log widget (fast tap during a heavy day).
9. Referenced HMB content library (Arabic-first + EN/FR/ES).
10. Fatigue/quality-of-life impact tracker (days affected, activities missed) to make the QoL hit visible and visit-ready.
11. Mental-health / anxiety-about-accidents support content (stigma-aware).

**P2 — depth / retention.**
12. Trend correlations ("your heaviest days cluster days 2–3; fatigue logs rise the week after") — descriptive insight, not diagnosis.
13. Lab/result tracker (she enters her own FBC/ferritin to bring context to visits).
14. Cause-education deep-dives that unlock as she flags relevant history (e.g., "heavy since first period" → coagulopathy education).

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **What counts as "heavy"?** — the QoL-based definition, the practical signs (hourly soaking, >7 days, overnight changes, coin-sized clots, flooding, double protection); "you don't need a lab number to be taken seriously."
2. **Measuring your bleeding (PBAC-style).** — how the product-count/soak score works and how to use it as a clinician conversation tool.
3. **Heavy periods & your iron.** — the bleeding→iron-loss→fatigue link; symptoms of iron deficiency and anemia; "ask about a full blood count and ferritin."
4. **Why are my periods heavy? (causes).** — plain-language PALM-COEIN: polyps, adenomyosis, fibroids, (rare) malignancy; coagulopathy/bleeding disorders (esp. heavy since menarche), ovulatory/hormonal, iatrogenic (copper IUD, blood thinners).
5. **Understanding your options (education only).** — tranexamic acid, NSAIDs, LNG-IUS/hormonal, ablation, fibroid procedures, hysterectomy, and iron repletion — what each is and why a clinician might discuss it. Clear non-prescription disclaimer.
6. **When to seek care.** — routine-visit signs vs. red-flag "seek care now" (uncontrolled soaking, fainting, severe breathlessness, post-menopausal bleeding).
7. **Getting the most from your appointment.** — what tests are standard (FBC, ferritin, ultrasound), questions to ask, how to advocate if dismissed, how to use your Femio summary.
8. **Living with heavy periods.** — practical dignity tips, managing accidents/anxiety, work and social life, when "putting up with it" isn't the only choice.
9. **Myths vs. evidence.** — "heavy periods are just normal for some women," "there's nothing to do but a hysterectomy," "clots always mean something serious."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, and (where relevant) a red-flag "seek care" callout.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Bleeding quantifier (core):** per-day period-products used (pads/tampons/cups/period underwear), **soak level per product**, **clot logging with size reference**, **flooding event** toggle, **double-protection** toggle, **overnight change** toggle → computed **PBAC-style daily + per-period score** and duration; trend view over cycles.
- Standard cycle/bleed log (start/end, spotting, cycle length) inherited from B1.
- **Anemia-symptom log:** fatigue, weakness, breathlessness, dizziness, headache, pica (e.g. ice craving), restless legs, hair thinning — optional, toggleable.
- Quality-of-life / days-affected log (activities missed, accidents) — optional.
- Optional lab/result entry (FBC/hemoglobin, ferritin) — **entry only, no interpretation as diagnosis**.

**Tools**
- **PBAC-style bleeding-severity summary** — shows her score trend and a plain-language band ("your logs this period reached a score often associated with heavy bleeding — worth discussing with a clinician"), never a diagnosis, always clinician-routed.
- **Visit-prep generator** — one-tap export/print: bleeding score + product counts + clot/flooding flags + anemia-symptom summary + cycle history + questions + standard-work-up checklist.
- **Cycle/bleeding-pattern insight** — descriptive trends ("appears associated with," never "caused by").
- **Screeners (framed as screening, not diagnosis):**
  - **Anemia-symptom awareness checklist** → "These can be signs of low iron — this is not a diagnosis. Consider asking your clinician about a full blood count and ferritin."
  - **HMB self-assessment** (practical-signs checklist) → "These are signs to discuss; only a clinician can assess the cause."
  - Optional mood/anxiety screen (PHQ-2/GAD-2 style) → screening-framed + crisis resources.

**Alerts (all non-alarming unless red-flag; screening-framed; dismissible; localized/RTL)**
- **Red-flag "seek care now" box** (prominent, not dismissible-away silently) when logged bleeding indicates **uncontrolled heavy loss** (soaking through protection hourly for several hours) or **anemia red flags** (fainting, severe breathlessness, chest pain, racing heart) → "seek care" education + saved emergency contact. *Content only, never triage/diagnosis.*
- **Anemia-awareness prompt** when heavy-score periods + fatigue cluster → "many clinicians suggest checking iron — here's why" (educational, screening-framed) → links to nutrition/iron education (see §J).
- **Persistent-HMB awareness prompt** (e.g., multiple consecutive periods scoring in the heavy band) → non-alarming "worth a clinician visit" + visit-prep.
- Optional bleeding-log reminders during a period (respect her cadence).
- **Never:** "you have anemia/fibroids/a bleeding disorder"; never disease-prevention or contraception claims; never a supplement or medication dose.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — inherited from constant core §3 / B1)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, **HMB mode ON**).
- Cycle events: bleed start/end, flow, spotting; computed cycle-length + variability.
- Generic symptom log; mood/energy/sleep.

**Persona-specific (HMB)**
- **Bleeding-quantification fields:** products-used count/type per day, soak level per product, clot count + size band, flooding event flag, double-protection flag, overnight-change flag, bleed-duration days.
- **Computed PBAC-style score** (daily + per-period) + heavy-band flag (non-diagnostic).
- **Anemia-symptom log:** fatigue/weakness/breathlessness/dizziness/pica/restless-legs (scores + dates, awareness-only).
- **Quality-of-life impact:** days affected, activities missed, accident events (optional).
- **HMB history hints (self-report):** heavy-since-menarche y/n (coagulopathy education trigger), known fibroids/adenomyosis/polyp mention, copper-IUD/anticoagulant use (iatrogenic context).
- **User-entered labs:** hemoglobin/FBC, ferritin — **entry only, no interpretation as diagnosis**.
- **TTC intent flag = false** (drives non-TTC UX); reachable toggle.

*All health fields optional, encrypted, user-deletable.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B4):**
- Q: life stage → "reproductive age / tracking my cycle." Q: cycles regular/irregular/**a concern I know of** → selects **"heavy or long periods"** ⇒ set **HMB mode ON**.
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false, suppress fertile-window/pregnancy nudges.
- Q: quick HMB check (soak hourly? >7 days? overnight changes? large clots? flooding? tiredness/breathlessness?) ⇒ tunes score prominence and anemia-awareness surfacing.
- Q: history hints (heavy since first period? known fibroids? on a copper IUD / blood thinner?) ⇒ tunes which cause-education surfaces.
- Q: top concerns (multi-select: quantifying/proof, fatigue/iron, causes, options, appointment prep) ⇒ orders home modules.

**Home configuration (default for B4):**
- **Hero = bleeding quantifier + per-period score trend** (with plain-language band and "share with your clinician" action). No "late" or fertile-window framing.
- Cards prioritized by concern selection (anemia-awareness surfaced if she flagged fatigue; cause-education if she flagged "why").
- **Visit-prep and bleeding-quantifier tools pinned.**
- Fertile-window / pregnancy widgets **hidden by default**.

**Hidden-but-reachable principle:** Femio never *removes* knowledge. TTC guidance, pregnancy tracking, contraception education and perimenopause content remain **discoverable** via search and "Explore other life stages" — just not pushed. She can opt into fertile-window/TTC mode anytime.

**Adaptive tuning:** repeated heavy-band periods → raise persistent-HMB + visit-prep prominence. Heavy-band + clustered fatigue logs → raise anemia-awareness + iron-nutrition education. Red-flag thresholds → immediate "seek care" box regardless of settings.

---

## J. Adaptation triggers (life-stage routing)

Inherits **all universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive pregnancy test; pregnancy loss; mood-screen high/crisis; **red-flag symptom / severe reading → "seek care now" content**; disengagement; toggle-off; age-of-consent). The table below adds **B4-specific** transitions only.

| Trigger | System response | Route |
|---|---|---|
| **Logged bleeding hits red-flag threshold** (soaking through protection hourly for several hours; flooding with fainting/severe breathlessness) | Fire universal red-flag handler: prominent **"seek care now"** box + saved emergency contact as *education*; log stays raw; no diagnosis/triage | Emergency messaging (content only); stay B4 |
| **Heavy-band periods + clustered fatigue/anemia symptoms** | Surface **anemia-symptom awareness** + "ask your clinician about FBC/ferritin" (screening-framed); **link to iron/nutrition education** | Stay B4; **→ nutrition/iron-education module** |
| **Persistent HMB** (multiple consecutive heavy-band periods) | Non-alarming clinician-check prompt + cause-education + visit-prep pack | Stay B4, raise screening/visit-prep prominence |
| **"Heavy since my first period" flag** | Surface **coagulopathy/bleeding-disorder education** (e.g., von Willebrand context) as "worth discussing"; add to visit-prep questions | Stay B4; cause-education deepened |
| **Known/suspected fibroids or adenomyosis flagged** | Surface structural-cause (PALM) education; visit-prep tuned | **→ cause-education (B8/B9-type structural-condition content)** as those persona layers surface |
| **Sets TTC intent = true** ("start trying") | Confirm; enable ovulation/fertile-window features; retain bleeding-quantifier; surface HMB-and-fertility education (HMB causes can affect conception) | **Route to TTC band** — keep HMB layer, add TTC layer |
| **Perimenopause overlap** (age/symptom signals: 40s+, changing cycles, new-onset heavy bleeding) | Introduce perimenopause education; clarify HMB-vs-perimenopause overlap; **keep bleeding-quantifier; keep red-flag "post-menopausal bleeding = seek care" education** | Blend HMB + perimenopause content; offer route to menopause band |
| **User toggles off HMB mode** | Revert to standard cycle logic (B1) but preserve all bleeding history | General reproductive-age band |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content. Cross-persona note: cause-education surfacing bridges toward **B8/B9** (structural gynae conditions — fibroids/adenomyosis) and **B7** (other cycle/gynae conditions), while anemia awareness bridges to **nutrition/iron education**; these are additive layers, never replacements.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. The PBAC-style score is a **tracking/communication aid**, explicitly **not** a diagnostic output. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Bleeding quantifier:** must be framed as "a way to describe your bleeding" and "discuss with your clinician"; never "you have menorrhagia" or "this is abnormal." Score bands use "often associated with heavy bleeding," not verdicts.
- **Red-flags:** uncontrolled heavy bleeding and anemia red-flags must trigger clear **"seek care now"** education (content only) + saved emergency contact; never triage, never "you're hemorrhaging/anemic."
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs "You have anemia/fibroids/a bleeding disorder."
- **Anemia / iron content:** awareness + "ask about FBC/ferritin" + general dietary-iron education only; **never** a supplement recommendation or dose; iron repletion described as clinician-managed.
- **Medication/procedure content (tranexamic acid, NSAIDs, LNG-IUS, ablation, fibroid procedures, hysterectomy):** educational context only; no recommendation, ranking, dosing, or "take/do this." Clear non-prescription disclaimer + clinician routing.
- **Predictions:** no fertile/"safe" window presented as reliable; add "not for contraception" note wherever ovulation/fertility appears.
- **Mental health:** crisis resources on any low mood screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** health data = special-category; explicit granular consent, purpose limitation, no ad-SDK/third-party sharing of cycle/bleeding/health data (post-Flo trust); local-first where feasible; full export/delete. Data-mapping + DPIA required before launch. Export/print of the visit-prep pack is user-initiated and scoped.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education keeps out of regulated-device territory — legal review before store submission.
- **[NEEDS SOURCE]** flags: (a) exact PBAC cut-off to display (≥100 vs ≥150) and whether to show any numeric threshold publicly — verify with medical review; (b) per-app competitor feature claims; (c) precise "quarter/coin-sized clot" wording localized per region; (d) per-locale crisis directories and emergency numbers.

---

## Sources

**Clinical — Tier 1 (NIH/CDC/NHS/MedlinePlus/gov):**
- [Heavy periods (menorrhagia) overview — InformedHealth.org / NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK279294/)
- [Heavy menstrual bleeding — Symptoms and causes — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/menorrhagia/symptoms-causes/syc-20352829)

**Clinical — Tier 2 (guidelines / society / peer-reviewed):**
- [Heavy Menstrual Bleeding — ACOG patient FAQ](https://www.acog.org/womens-health/faqs/heavy-menstrual-bleeding)
- [Management of Acute Abnormal Uterine Bleeding in Nonpregnant Reproductive-Aged Women — ACOG](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2013/04/management-of-acute-abnormal-uterine-bleeding-in-nonpregnant-reproductive-aged-women)
- [Heavy menstrual bleeding: assessment and management — NICE guideline NG88 (PDF)](https://www.nice.org.uk/guidance/ng88/resources/heavy-menstrual-bleeding-assessment-and-management-pdf-1837701412549)
- [NICE NG88 recommendations (chapter)](https://www.nice.org.uk/guidance/ng88/chapter/recommendations)
- [FIGO classification system (PALM-COEIN) for causes of abnormal uterine bleeding — Munro 2011, Int J Gynecol Obstet](https://obgyn.onlinelibrary.wiley.com/doi/10.1016/j.ijgo.2010.11.011)
- [PALM-COEIN system — abnormal uterine bleeding overview (NP Women's Healthcare)](https://npwomenshealthcare.com/abnormal-uterine-bleeding-in-reproductive-aged-women-utilizing-the-palm-coein-system/)
- [Heavy menstrual bleeding: diagnosis and medical management — PMC5683444](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5683444/)
- [HMB in premenopausal patients and the role of NSAIDs — AAFP](https://www.aafp.org/afp/2020/0801/p147)
- [LNG-IUS (Mirena) vs endometrial ablation (Novasure) RCT — PMC3751634](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3751634/)

**Bleeding quantification (PBAC):**
- [Pictorial methods to assess heavy menstrual bleeding: systematic review — PMC7011238](https://pmc.ncbi.nlm.nih.gov/articles/PMC7011238/)
- [PBAC diagnostic accuracy vs alkaline hematin — PubMed 21228538](https://pubmed.ncbi.nlm.nih.gov/21228538/)
- [PBAC for evaluating HMB in Asian women — PubMed 34949729](https://pubmed.ncbi.nlm.nih.gov/34949729/)
- [Pictorial Blood Loss Assessment Chart (PBAC) — World Federation of Hemophilia eLearning](https://elearning.wfh.org/resource/pictorial-blood-loss-assessment-chart/)

**Anemia / iron deficiency:**
- [Relationship between HMB, iron deficiency, and iron-deficiency anemia — AJOG 2023](https://www.ajog.org/article/S0002-9378(23)00024-8/fulltext)
- [Prevalence and impacts of HMB on anemia, fatigue and QoL — PMC6500811](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6500811/)
- [Iron-deficiency anemia in HMB patients: the patient perspective — PMC11869313](https://pmc.ncbi.nlm.nih.gov/articles/PMC11869313/)
- [Iron deficiency and fatigue among adolescents with HMB — Pediatrics Nationwide](https://pediatricsnationwide.org/2022/01/04/iron-deficiency-and-fatigue-among-adolescents-with-heavy-menstrual-bleeding/)

**Patient journey / needs (qualitative + community):**
- [Women's experiences of HMB and medical treatment: qualitative study in primary care — PMC9997654 / BJGP](https://pmc.ncbi.nlm.nih.gov/articles/PMC9997654/)
- [How women discuss HMB in online forums ("Revenge of the Uterus"): thematic analysis — PMC12268219](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12268219/)
- [Qualitative study on outcomes reflecting women's HMB experiences (core outcome set) — PMC10357648](https://pmc.ncbi.nlm.nih.gov/articles/PMC10357648/)
- [HMB significantly affects quality of life — PubMed 24266506](https://pubmed.ncbi.nlm.nih.gov/24266506/)
- [Prevalence of HMB and wellbeing associations in LMICs (multinational) — Lancet Global Health](https://www.thelancet.com/journals/langlo/article/PIIS2214-109X(23)00416-3/fulltext)

**Competitor / app landscape:**
- [More than blood: app-tracking reveals variability in the HMB construct (Clue data) — PMC10088691](https://pmc.ncbi.nlm.nih.gov/articles/PMC10088691/)
- [Clue — Period & Cycle Tracker (App Store)](https://apps.apple.com/us/app/clue-period-cycle-tracker/id657189652)
- [Clue — bleeding/flow tracking (helloclue)](https://helloclue.com/)
- [Flo — period/cycle app](https://flo.health/)
- [When should you go to the hospital for heavy menstrual bleeding? — Flo (patient-facing)](https://flo.health/menstrual-cycle/health/period/when-should-you-go-to-the-hospital-for-heavy-menstrual-bleeding)
