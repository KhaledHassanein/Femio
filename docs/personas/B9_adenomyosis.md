# Persona B9 — Reproductive-age woman with adenomyosis

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician." Red-flag symptoms (uncontrolled bleeding, signs of significant anemia) route to "seek care."
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC by default) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (invariants §1, state object §2, core §3, universal events §6, Z1 §5, blending §8). Base cycle-tracking layer inherited from **B1**; shares its bleeding-quantifier + anemia layer with **B4 (HMB)** and its pain/structural-condition framing with **B8 (fibroids)**.

---

## A. Persona snapshot

**Who she is.** "Rana," 36. For years her periods have meant days of deep, dragging pelvic pain that painkillers barely touch, bleeding heavy enough to flood overnight, and a lower belly that swells so much by day two she's been asked more than once when she's "due" — a "pregnant-looking" bloat that doesn't go away with sleep or food ("adenomyosis belly"). Sex hurts. She's been told it's "just bad periods," offered the pill, screened for endometriosis, scanned for fibroids, and still nobody named what was wrong — until a sonographer who knew what to look for mentioned adenomyosis, a word she'd never heard despite living with it. She is not currently trying to conceive. Arabic-first (also reads English), uses the web on her phone.

**What she lives with.**
- **Severe cramping / dysmenorrhea** — deep, boggy pelvic pain that often outlasts the bleed; chronic pelvic pain between periods; **dyspareunia** (pain with sex).
- **Heavy menstrual bleeding** — soaking, flooding, clots, overnight changes; same objective-bleeding problem as B4, plus the anemia/fatigue tail.
- **Enlarged / tender "boggy" uterus & bloating** — the visible, distressing "adenomyosis belly"; pressure and fullness.
- **Diagnostic limbo & confusion with endo/fibroids** — under-recognized condition, symptoms overlap with and co-occur with endometriosis and fibroids; she genuinely doesn't know which she has, or whether it's more than one.
- **Emotional load** — years of being dismissed; higher rates of anxiety and low mood than women with fibroids; grief when told hysterectomy is the only "cure."

**Core emotional drivers.** Wants a **name and validation** for something that has been minimized for years, and language to distinguish adenomyosis from endometriosis and fibroids so she can ask the right questions. Wants to **quantify** the pain and bleeding objectively so it can't be waved away. Wants to understand the **treatment landscape** (from hormonal options through to hysterectomy) at an educational level — including how her fertility wishes and her age change the picture — without being rushed toward surgery or funneled into a pregnancy narrative.

**Jobs-to-be-done.**
1. **Track pain** (severity, location, timing, dyspareunia, non-period pelvic pain) *and* **bleeding** (objective product/soak/clot/flooding score) together, over time.
2. Understand **what adenomyosis is** and how it differs from — and overlaps with — endometriosis and fibroids.
3. Connect heavy bleeding to **fatigue / anemia** awareness and know when tiredness is a "get checked" signal.
4. Understand the **treatment landscape** (educational only): NSAIDs/tranexamic acid, hormonal (LNG-IUS, pill, progestogens, GnRH), uterine artery embolization, ablation, hysterectomy — and why fertility wishes and age matter.
5. Understand **diagnosis** — why imaging (transvaginal ultrasound, MRI) matters and why it's often a *presumptive* diagnosis.
6. Prepare for and get more out of appointments; know which tests/imaging are standard; feel **believed**.

**Success = she walks in with one page that names her likely condition-cluster, shows her pain and bleeding objectively, and asks: "Could this be adenomyosis, and how do we tell it apart from endo and fibroids?"**

---

## B. Needs & questions (voice-of-user)

Mined from r/adenomyosis and adjacent endometriosis/HMB communities, qualitative symptom-impact studies, and app-store reviews of endo/adeno trackers (see Sources). Paraphrased to avoid quoting individuals.

**On being named / validated (the #1 pain):**
- "I'd never even heard the word adenomyosis until a scan picked it up — why did it take years and so many doctors?"
- "I was told it was 'just bad periods' and to take ibuprofen. It is not just bad periods."
- "I don't know if I have endo, fibroids, adenomyosis, or all three — nobody will give me a straight answer."

**On pain (distinct from the HMB persona):**
- "The cramps are a deep, dragging, all-over-my-pelvis pain, not a normal period ache — and it lasts days after the bleeding stops."
- "Sex hurts and I've never seen an app that lets me even log that."
- "I want to mark *where* it hurts and how bad, not just tap a sad face."

**On the belly / bloating:**
- "By day two my stomach looks six months pregnant. Strangers ask. It's humiliating and no tracker captures it."

**On bleeding & fatigue:**
- "I flood, I pass clots, and I'm exhausted — turned out I was anemic and nobody had connected it."

**On causes / distinguishing conditions:**
- "How is adenomyosis different from endometriosis? They sound the same and I have symptoms of both."
- "Is my enlarged uterus adenomyosis or fibroids? How do they even tell?"

**On treatment (educational):**
- "Is hysterectomy really the only cure? What's in between the pill and surgery?"
- "I might still want kids — what does adenomyosis mean for that, and do my options change?"

**On visit prep:**
- "I freeze in the appointment and forget how bad the month actually was."
- "What imaging should I ask for? What does a proper work-up look like?"

**On privacy:**
- "After the Flo/Facebook thing I don't trust these apps with this kind of data."

**Top recurring questions Femio must answer in-product:**
1. What is adenomyosis, and how is it different from endometriosis and fibroids (which I might also have)?
2. Are my pain and bleeding "objectively" severe — and how do I show that to a clinician?
3. How is adenomyosis diagnosed (ultrasound, MRI), and why is it so often missed or presumptive?
4. What are my treatment options in plain language (hormonal → procedures → hysterectomy), and how do age and fertility wishes change them?
5. Am I at risk of anemia, and when should I ask about iron/ferritin testing?
6. When is this a "seek care now" situation vs. a routine visit — and how do I prepare so I'm taken seriously?

---

## C. Competitor teardown

Adenomyosis is a genuine **whitespace**: mainstream trackers ignore it, and the niche condition-trackers treat it as a bolt-on tag to an *endometriosis* product rather than a first-class condition with its own pain-and-bleeding model. None combines objective bleeding quantification + structured pain/dyspareunia mapping + adenomyosis-vs-endo-vs-fibroid education + anemia awareness + Arabic-first referenced content in one lifespan account.

| App | Model | Adenomyosis handling | Pain / dyspareunia capture | Bleeding quantification | Distinguishes adeno vs endo vs fibroids | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | None specific; general symptom tags | Basic pain tag, no body-map, no dyspareunia field | Light/medium/heavy taps only | No | **FTC action (2021); ~$56M class settlement (2025)** — trust damage | First-class adenomyosis model; objective bleeding score; pain map; condition-distinction education; privacy-by-design |
| **Clue** | Freemium, science-forward | None specific | Better neutral symptom taxonomy; no structured pain-map | User-interpreted light/medium/heavy | No | Better GDPR posture | Adenomyosis depth + PBAC-style quantification + Arabic-first RTL |
| **ENdi / Endira / Endolog / EndoTracker** (niche condition-trackers) | Freemium symptom journals | Adenomyosis listed as a **secondary tag** alongside endo/PCOS/PMDD; some offer pain-mapping (ENdi "36+ symptoms," body pain map) | Some do body-map/pain-location well (their strongest feature) | Varies; generally symptom-journal flow, not a validated bleeding score | Weak — endo-primary framing; adenomyosis is an afterthought | Unclear / varies; independent devs | Adenomyosis as **primary** persona; validated bleeding quantifier + anemia layer; referenced medically-reviewed content; multilingual; full-lifespan EMR |
| **QENDO** (nonprofit, AU) | Free, community-built | Covers endo, adeno, PCOS, pelvic pain, infertility — genuinely inclusive | Good symptom + pain logging | Symptom-level, not validated volume score | Partial (education-oriented) | Nonprofit posture | Femio adds objective bleeding score, uncertainty-honest cycle logic, Arabic-first, and a lifespan account that carries forward |
| **Endometriosis & Adenomyosis** (small App Store apps) | Paid/freemium journals | Names adenomyosis in title | Basic logging | Basic | Marketing-level, thin content | Unclear | Referenced Tier-1/Tier-2 content, medical review, compliance discipline |
| **Ovia / Stardust / generic 3-dot trackers** | Various | None | None structured | None to minimal | No | Employer-model (Ovia) / local-first (Stardust) | Everything above |

**Cross-cutting failure:** the mass-market trackers don't model adenomyosis at all, and the condition-specific apps are **endometriosis products that append "adenomyosis" as a tag** — so a woman who is actually dealing primarily with adenomyosis (deep dysmenorrhea + HMB + boggy enlarged uterus + the confusion of overlapping conditions) has no product built around *her*. Femio's answer: adenomyosis as a first-class persona that unifies **structured pain + dyspareunia mapping**, the **objective bleeding quantifier and anemia layer inherited from B4**, and **referenced education that explicitly distinguishes and relates adenomyosis, endometriosis, and fibroids** — none of which the incumbents deliver together.

*[NEEDS SOURCE] — per-app feature claims are from app-store listings and review roundups; verify against current app versions before any public comparative claim.*

---

## D. Clinical grounding (cited)

**Definition.** Adenomyosis is the presence of ectopic endometrial glands and stroma **within the myometrium** (the muscular wall of the uterus), surrounded by reactive smooth-muscle hyperplasia — which is what makes the uterus enlarged and "boggy" [StatPearls/NCBI; MedlinePlus/Mayo Clinic]. The NHS describes it plainly as the lining of the womb starting to **grow into the muscle in the wall of the womb** [NHS].

**Prevalence & recognition.** Estimates vary widely (historically ~**20–35%** of women, with figures sensitive to how and when it is diagnosed) because definitive diagnosis has traditionally required histology after hysterectomy; it is **more commonly diagnosed in women over 30** and is widely described as **under-recognized** [Cleveland Clinic; NHS; PMC "underacknowledged cause of abnormal uterine bleeding and pelvic pain"]. Up to **~1 in 3 women with adenomyosis may be asymptomatic** [StatPearls].

**Core symptoms.** The most common are **heavy menstrual bleeding** and **painful periods (dysmenorrhea)**; less commonly **chronic pelvic pain** and **dyspareunia (pain with sex)**. NHS figures: about **4–5 in 10** women with adenomyosis have heavy periods and **1–3 in 10** have painful periods, with irregular bleeding more rare [NHS; StatPearls; Mayo Clinic]. On examination the uterus is classically **enlarged, tender and "boggy"** — and a **tender** uterus is more characteristic of adenomyosis than of a fibroid uterus [StatPearls; Medscape]. Patients also frequently report **bloating / abdominal distension ("adenomyosis belly")** that can look like early pregnancy [patient-experience literature; clinical patient education].

**Distinguishing from — and overlap with — endometriosis and fibroids.**
- **Adenomyosis vs endometriosis:** both involve endometrium-like tissue where it doesn't belong, but adenomyosis is **inside the uterine muscle** while endometriosis is **outside the uterus**; they share symptoms, often **co-occur**, and are debated as possibly related phenotypes [MDPI/PMC "Are Adenomyosis and Endometriosis Phenotypes of the Same Disease Process?"].
- **Adenomyosis vs fibroids (leiomyoma):** fibroids are discrete benign **muscle tumors**; they can cause similar bleeding/pressure symptoms and an enlarged uterus, but are structurally different — a fibroid uterus is typically firm/irregular, an adenomyotic uterus diffusely enlarged and **tender** [StatPearls; Pelvic Rehab overview].
- **Co-occurrence is common:** in cohort data, **endometriosis was identified in ~40%** of those with adenomyosis; adenomyosis, endometriosis and fibroids frequently overlap, which is a major reason for diagnostic confusion [cohort data via review sources; eClinicalMedicine on endo–fibroid co-occurrence]. This maps directly onto **FIGO PALM-COEIN** (adenomyosis is the "A," fibroids the "L" — the shared bleeding framework inherited from B4).

**Diagnosis (imaging).** **Transvaginal ultrasound (TVUS)** is the first-line imaging modality and, in trained hands, is reliable; accuracy improves when combined with **MRI**, especially in complex or coexisting-pathology cases [PMC "From Clinical Symptoms to MR Imaging"; TVUS studies]. On MRI, a **junctional-zone thickness ≥ ~12 mm** is the most cited criterion, with reported diagnostic accuracy around **85%** [MRI pictorial reviews, PMC]. Crucially, adenomyosis is **still rarely definitively diagnosed before hysterectomy**, so management often proceeds on a **presumptive (imaging-based) diagnosis** — an important nuance for honest, non-diagnostic framing [Medscape/StatPearls]. *Femio presents imaging as "what a clinician may use," never interprets scans, and never asserts a diagnosis.*

**Anemia / iron (why fatigue matters).** As with any cause of HMB, adenomyosis is a common driver of **iron deficiency and iron-deficiency anemia**; symptoms include fatigue (most common), breathlessness, dizziness, headache, brain fog, pica (e.g. ice craving) and restless legs — and iron deficiency can cause fatigue **before** anemia develops. A **full blood count / ferritin** is the key baseline test [inherited from B4: AJOG 2023; PMC6500811; NICE NG88]. *Femio surfaces this as awareness + "ask your clinician about iron/ferritin," never a diagnosis or a supplement dose.*

**Management (EDUCATIONAL framing only — Femio does not treat or dose).** Management is typically **stepwise and preference-/fertility-sensitive**:
- **Symptom-directed medical:** NSAIDs (e.g. ibuprofen, mefenamic acid) for pain; **tranexamic acid** for bleeding [Medscape; NICE NG88 as applied to HMB].
- **Hormonal (first-line for many):** the **levonorgestrel intrauterine system (LNG-IUS / Mirena)** to thin the lining and reduce pain and bleeding; combined or progestogen-only pills, the patch, oral progestogens (e.g. **dienogest**), and **GnRH agonists/antagonists** for refractory cases [NHS; Medscape; StatPearls; dienogest trial NCT03890042].
- **Uterine-sparing procedural:** **uterine artery embolization (UAE)** as a potential alternative to hysterectomy; **adenomyomectomy** in selected fertility-preserving cases [PMC UAE review; fertility-preserving surgery literature].
- **Endometrial ablation:** an option for some, but **less reliable for adenomyosis** because it doesn't reach tissue deep in the myometrium [Cleveland Clinic; Medscape].
- **Hysterectomy:** the **definitive** treatment, for those who have completed childbearing [NHS; StatPearls].
- Femio explains *what each is and why a clinician might discuss it*, notes that **choice depends on symptoms, age and fertility wishes**, and always routes to a clinician — it never recommends, ranks, or doses.

**Fertility & pregnancy context.** Adenomyosis is associated with **reduced fertility** — lower implantation rates, higher miscarriage risk, and reduced IVF/ICSI success — and is found in a meaningful share of women investigated for infertility (secondary sources cite figures around a quarter of infertile women) [PMC "From Diagnosis to Fertility"; IVF-outcome studies]. This makes the **TTC transition** clinically important (see §J). *Educational framing only.*

**Menopause.** Adenomyosis is **estrogen-dependent**, and symptoms commonly **improve or resolve after menopause** — relevant for the perimenopause/menopause transition and for tone (there is a "this often eases later" message that is honest and hopeful) [patient education; clinical reviews].

**Mental health.** Women with adenomyosis show **higher rates of anxiety and depression** than women with uterine fibroids, reflecting chronic pain and long diagnostic delay [PMC comparative study]. Qualitative work reports a **mean ~5.7 years** of symptoms before diagnosis and widespread feelings of being **dismissed** [PMC symptom-impact study]. *Femio surfaces mood screening (screening-framed) + validation content + crisis resources.*

**Femio scope guardrail restated:** all of the above is presented as **wellness education, tracking, and screening**, with consistent "discuss with your clinician" routing and explicit "seek care now" red-flags. Femio is not contraception and does not claim to prevent, diagnose, or treat disease.

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Pain tracker with body-map + timing + dyspareunia.** Log pain **severity** (0–10), **location** (pelvic body-map: lower abdomen, deep pelvic, back, radiating), **type** (cramping/dragging/sharp), **timing relative to cycle** (period vs mid-cycle vs constant), **dyspareunia** (pain with sex), and **duration beyond the bleed** → trend view. This is the field the HMB persona doesn't emphasize and mainstream trackers lack.
2. **Objective bleeding quantifier (PBAC-style / product-count)** — inherited from **B4**: products used, soak level, clots (size reference), flooding, double-protection, overnight changes → semi-objective daily + per-period score, framed as "a way to describe your bleeding to your clinician," never a diagnosis.
3. **"Adenomyosis vs endometriosis vs fibroids" education engine** — referenced explainers that define each, show how they overlap and co-occur, and frame the distinction as clinician-assessed (imaging). Directly answers her #1 confusion.
4. **Anemia-symptom awareness layer** (inherited from B4) — optional fatigue/breathlessness/dizziness/pica/restless-legs logging → non-alarming "ask about iron/ferritin" education when heavy-bleeding + symptoms cluster.
5. **Treatment-landscape education (educational only)** — hormonal → UAE/ablation → hysterectomy, with an explicit **"how age & fertility wishes change the picture"** frame; clear non-prescription disclaimer.
6. **Diagnosis-and-imaging explainer** — why TVUS/MRI are used, what "junctional zone" means in plain language, and why adenomyosis is often a *presumptive* diagnosis (sets honest expectations).
7. **Specialist-visit prep pack** — exportable/printable one-pager: pain-map + severity trend, bleeding score, clot/flooding flags, anemia-symptom summary, bloating log, cycle history, questions to ask, standard-work-up checklist (FBC/ferritin, TVUS/MRI).
8. **Non-TTC default** + **Privacy-by-design** (local-first where feasible, no ad-SDK sharing) — inherited invariants; addresses post-Flo distrust.

**P1 — strong differentiators.**
9. **"Adenomyosis belly" / bloating & bulk log** — optional daily distension/pressure rating (and optional private local photo) to make a dismissed, visible symptom trackable and visit-ready.
10. **Validation & mental-health module** — normalizing content on diagnostic delay + anxiety/depression screening (screening-framed) + coping content; acknowledges the "years of being told it's normal" experience.
11. Referenced adenomyosis content library (Arabic-first + EN/FR/ES).
12. Quality-of-life / days-affected tracker (work, exercise, intimacy, social) to quantify impact.

**P2 — depth / retention.**
13. Trend correlations ("your deep-pelvic pain logs extend ~3 days past your heaviest bleeding") — descriptive insight, not diagnosis.
14. Lab/imaging-result tracker (she enters her own FBC/ferritin and imaging notes for visit context).
15. Condition-education deep-dives that unlock as she flags relevant history (e.g., flags known endometriosis → surface overlap/co-occurrence content and blended B7-type layer).

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **What is adenomyosis?** — plain-language definition (lining growing into the muscle), why the uterus becomes enlarged/tender/"boggy," how common and how often it's asymptomatic, and why it's so often under-recognized.
2. **Adenomyosis vs endometriosis vs fibroids.** — a clear side-by-side: where the tissue is, how symptoms overlap, how they co-occur, and why only imaging/a clinician can tell them apart. Directly targets her core confusion.
3. **Understanding your pain.** — dysmenorrhea, chronic pelvic pain, dyspareunia; why the pain can outlast the bleed; how to describe and map it for a clinician.
4. **"Adenomyosis belly" & bloating.** — what causes the distension and pressure, that it's a real physical change (not "just bloat"), and that it's worth logging and raising.
5. **Heavy periods & your iron.** — the bleeding→iron-loss→fatigue link; symptoms of iron deficiency/anemia; "ask about a full blood count and ferritin." (Shared with B4.)
6. **How adenomyosis is diagnosed.** — transvaginal ultrasound, MRI (junctional zone in plain words), why it's frequently a *presumptive* diagnosis, and what a work-up may involve.
7. **Understanding your options (education only).** — NSAIDs, tranexamic acid, LNG-IUS/hormonal, GnRH, uterine artery embolization, ablation (and its limits for adenomyosis), hysterectomy; **how age and fertility wishes change the conversation.** Clear non-prescription disclaimer.
8. **Adenomyosis & fertility.** — associations with implantation, miscarriage and IVF outcomes; that many people do conceive; why to raise it early if planning pregnancy. (Educational; links to TTC transition.)
9. **Adenomyosis & menopause.** — that symptoms often ease after menopause (honest, hopeful), and how perimenopause can muddy the picture.
10. **When to seek care.** — routine-visit signs vs red-flag "seek care now" (uncontrolled soaking, fainting, severe breathlessness, post-menopausal bleeding). (Shared red-flag set with B4.)
11. **Getting the most from your appointment.** — standard tests/imaging, questions to ask, how to advocate after years of being dismissed, how to use your Femio summary.
12. **Adenomyosis & your mental health.** — normalizing the toll of chronic pain and diagnostic delay; coping strategies; when to seek support.
13. **Myths vs. evidence.** — "it's just bad periods," "adenomyosis and endometriosis are the same thing," "hysterectomy is the only option," "you can't get pregnant with adenomyosis."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, and (where relevant) a red-flag "seek care" callout.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Pain log (core B9 addition):** severity (0–10), **pelvic body-map location**, pain **type** (cramping/dragging/sharp/pressure), **timing** (period / mid-cycle / constant), **dyspareunia** flag + severity, days-of-pain-beyond-bleed → trend view. Non-alarming; descriptive.
- **Bleeding quantifier (inherited from B4):** per-day products used, soak level per product, clots + size reference, flooding toggle, double-protection toggle, overnight-change toggle → computed **PBAC-style daily + per-period score** and duration; trend over cycles.
- **Bloating / "adenomyosis belly" log:** optional daily distension/pressure rating; optional **private, local** photo progress.
- Standard cycle/bleed log (start/end, spotting, cycle length) inherited from B1.
- **Anemia-symptom log (inherited from B4):** fatigue, weakness, breathlessness, dizziness, headache, pica, restless legs — optional, toggleable.
- Quality-of-life / days-affected log (work, exercise, intimacy, social) — optional.
- Optional lab/imaging-result entry (FBC/hemoglobin, ferritin; imaging notes) — **entry only, no interpretation as diagnosis.**

**Tools**
- **Pain-and-bleeding severity summary** — shows pain-map + severity trend alongside the PBAC-style bleeding band, in plain language ("your logs this period reached levels often associated with heavy bleeding and significant pain — worth discussing with a clinician"). Never a diagnosis; always clinician-routed.
- **Condition-distinction explainer tool** — interactive "adenomyosis vs endo vs fibroids" education (not a diagnostic quiz; explicitly "only a clinician can tell these apart, usually with imaging").
- **Visit-prep generator** — one-tap export/print: pain-map + severity trend, bleeding score + product counts + clot/flooding flags, bloating log, anemia-symptom summary, cycle history, questions, standard-work-up checklist (FBC/ferritin, TVUS/MRI).
- **Cycle/symptom-pattern insight** — descriptive trends ("appears associated with," never "caused by").
- **Screeners (framed as screening, not diagnosis):**
  - **HMB / practical-signs checklist** → "These are signs to discuss; only a clinician can assess the cause." (Shared with B4.)
  - **Anemia-symptom awareness checklist** → "These can be signs of low iron — not a diagnosis. Consider asking about a full blood count and ferritin."
  - **Adenomyosis-symptom awareness checklist** (heavy bleeding + severe cramping + chronic pelvic pain + dyspareunia + bloating/enlarged-uterus sensation) → "These can be signs worth discussing — including whether imaging is right for you. Only a clinician can diagnose."
  - Mood/anxiety screen (PHQ-2/GAD-2 style) → screening-framed + crisis resources.

**Alerts (all non-alarming unless red-flag; screening-framed; dismissible; localized/RTL)**
- **Red-flag "seek care now" box** (prominent) when logged bleeding indicates **uncontrolled heavy loss** (soaking through protection hourly for several hours) or **anemia red flags** (fainting, severe breathlessness, chest pain, racing heart) → "seek care" education + saved emergency contact. *Content only, never triage/diagnosis.* (Shared with B4.)
- **Persistent pain + heavy-bleeding awareness prompt** (multiple consecutive cycles scoring high on both) → non-alarming "worth a clinician visit; here's what a work-up may involve" + visit-prep + condition-distinction education.
- **Anemia-awareness prompt** when heavy-score periods + fatigue cluster → "many clinicians suggest checking iron — here's why" (educational, screening-framed).
- **Dyspareunia / chronic-pelvic-pain awareness prompt** → gentle "pain with sex or between periods is worth raising; it can be part of conditions like adenomyosis or endometriosis" (educational, screening-framed).
- Optional pain/bleeding-log reminders during a period (respect her cadence).
- **Never:** "you have adenomyosis/endometriosis/fibroids/anemia"; never disease-prevention or contraception claims; never a supplement or medication dose.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — inherited from constant core §3 / B1)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, **adenomyosis mode ON**).
- Cycle events: bleed start/end, flow, spotting; computed cycle-length + variability.
- Generic symptom log; mood/energy/sleep.

**Persona-specific (adenomyosis)**
- **Pain fields:** severity (0–10), body-map location(s), pain type, timing (period/mid-cycle/constant), **dyspareunia** flag + severity, days-of-pain-beyond-bleed.
- **Bleeding-quantification fields (shared with B4):** products-used count/type, soak level, clot count + size band, flooding flag, double-protection flag, overnight-change flag, bleed-duration days; **computed PBAC-style score** + heavy-band flag (non-diagnostic).
- **Bloating / distension:** daily rating (optional); optional private local photo reference.
- **Anemia-symptom log (shared with B4):** fatigue/weakness/breathlessness/dizziness/pica/restless-legs (scores + dates, awareness-only).
- **Quality-of-life impact:** days affected, activities missed (work/exercise/intimacy/social).
- **Condition-history hints (self-report):** self-reported adenomyosis (diagnosed / suspected / exploring) + year; **co-occurring endometriosis / fibroids** flags; prior imaging (TVUS/MRI) mention; enlarged/tender-uterus note. These drive overlap-education surfacing and blending toward B7 (endo/other gynae) / B8 (fibroids).
- **User-entered labs/imaging:** hemoglobin/FBC, ferritin, imaging notes — **entry only, no interpretation as diagnosis.**
- **Fertility-intent context:** TTC intent flag (default **false**; reachable toggle) — surfaces fertility-relevance education when set true.

*All health fields optional, encrypted, user-deletable; photos stored locally.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B9):**
- Q: life stage → "reproductive age / tracking my cycle." Q: cycles regular/irregular/**a condition I know of** → selects **"adenomyosis"** (or "severe cramps + heavy periods," or "a condition my clinician mentioned") ⇒ set **adenomyosis mode ON** (bleeding-quantifier + pain-map both enabled).
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false, suppress fertile-window/pregnancy nudges (reachable).
- Q: quick symptom check (severe cramps? heavy/flooding? pain between periods? pain with sex? bloating/"pregnant-looking" belly? tiredness/breathlessness?) ⇒ tunes which logs and awareness prompts surface.
- Q: condition-history hints (told you have endometriosis? fibroids? had a scan? enlarged uterus?) ⇒ tunes overlap-education and whether B7/B8 layers blend in.
- Q: top concerns (multi-select: pain, bleeding/proof, fatigue/iron, understanding-the-condition, treatment-options, appointment prep, fertility) ⇒ orders home modules.

**Home configuration (default for B9):**
- **Hero = combined pain-and-bleeding view** (pain-map + severity trend alongside bleeding-score trend) with plain-language band and "share with your clinician" action. No "late" or fertile-window framing.
- Cards prioritized by concern selection (condition-distinction education surfaced if she flagged "understanding"; anemia-awareness if she flagged fatigue; treatment-landscape if she flagged options; fertility card if flagged).
- **Visit-prep, pain tracker, and bleeding-quantifier tools pinned.**
- Fertile-window / pregnancy widgets **hidden by default.**

**Hidden-but-reachable principle:** Femio never *removes* knowledge. TTC guidance, pregnancy tracking, contraception education, endometriosis/fibroid content and perimenopause content remain **discoverable** via search and "Explore other life stages / related conditions" — just not pushed. She can opt into fertile-window/TTC mode anytime.

**Adaptive tuning:** repeated high pain + heavy-band periods → raise persistent-symptom + visit-prep prominence and condition-distinction education. Heavy-band + clustered fatigue logs → raise anemia-awareness + iron-nutrition education. Flags co-occurring endo/fibroids → blend B7/B8 education layers. Dyspareunia/chronic-pelvic-pain logs → surface related awareness (educational). Red-flag thresholds → immediate "seek care" box regardless of settings.

---

## J. Adaptation triggers (life-stage routing)

Inherits **all universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive pregnancy test; pregnancy loss; mood-screen high/crisis; **red-flag symptom / severe reading → "seek care now" content**; disengagement; toggle-off; age-of-consent). The table below adds **B9-specific** transitions only.

| Trigger | System response | Route |
|---|---|---|
| **Logged bleeding hits red-flag threshold** (soaking through protection hourly for several hours; flooding with fainting/severe breathlessness) | Fire universal red-flag handler: prominent **"seek care now"** box + saved emergency contact as *education*; log stays raw; no diagnosis/triage | Emergency messaging (content only); stay B9 |
| **Persistent severe pain + heavy bleeding** (multiple consecutive cycles high on both) | Non-alarming clinician-check prompt + condition-distinction & diagnosis-imaging education + visit-prep pack | Stay B9, raise screening/visit-prep prominence |
| **Heavy-band periods + clustered fatigue/anemia symptoms** | Surface **anemia-symptom awareness** + "ask your clinician about FBC/ferritin" (screening-framed); **link to iron/nutrition education** | Stay B9; **→ nutrition/iron-education module** (shared with B4) |
| **Dyspareunia / chronic pelvic pain logged** | Gentle awareness: "pain with sex or between periods is worth raising"; add to visit-prep questions | Stay B9; pain-education deepened |
| **Flags co-occurring endometriosis** | Surface adenomyosis–endometriosis overlap/co-occurrence education; blend endometriosis layer | **→ blend B7-type (endometriosis/other gynae) content**, additive |
| **Flags co-occurring / suspected fibroids or enlarged uterus** | Surface adenomyosis–fibroid distinction/overlap education; blend fibroid layer | **→ blend B8-type (fibroids/structural) content**, additive |
| **Sets TTC intent = true** ("start trying") | Confirm; enable ovulation/fertile-window features **with uncertainty caveats**; **retain pain + bleeding logs**; surface **adenomyosis-and-fertility** education (implantation/miscarriage/IVF associations, "raise it early") | **Route to TTC band** — keep adenomyosis layer, add TTC layer (fertility-relevance flagged) |
| **Positive pregnancy test logged** | Fire universal positive-test handler: celebrate tone-matched; suppress fertile-window/OPK/BBT; **carry adenomyosis context** (bleeding/pain history) into pregnancy content; retire prediction widgets; re-confirm privacy scope | Pregnancy band (adenomyosis-flagged) |
| **Perimenopause overlap** (40s+, changing cycles, vasomotor symptoms) | Introduce perimenopause education; clarify adenomyosis-vs-perimenopause symptom overlap; **surface honest "symptoms often ease after menopause" message**; keep bleeding-quantifier + **post-menopausal-bleeding = seek care** red-flag | Blend adenomyosis + perimenopause content; offer route to menopause band |
| **User toggles off adenomyosis mode** | Revert to standard cycle logic (B1) but preserve all pain + bleeding history | General reproductive-age band |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content. Cross-persona note: adenomyosis sits at the center of the structural/overlap cluster — it **shares its bleeding-quantifier + anemia layer with B4 (HMB)**, **blends toward B7 (endometriosis/other gynae) and B8 (fibroids)** on co-occurrence, carries forward into the **TTC and pregnancy bands** (fertility relevance), and **eases toward the menopause band** — always additive, never replacing the constant core.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. Pain and bleeding scores are **tracking/communication aids**, explicitly **not** diagnostic outputs. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Condition naming:** Femio never states "you have adenomyosis / endometriosis / fibroids." The condition-distinction content is framed as education + "only a clinician can tell these apart, usually with imaging." Self-reported condition status is user-entered context, never a Femio verdict.
- **Bleeding/pain quantifiers:** framed as "a way to describe your symptoms to your clinician"; score bands use "often associated with heavy bleeding / significant pain," never "abnormal" or a verdict.
- **Imaging content:** Femio explains what TVUS/MRI are and why clinicians use them; it **never interprets a scan** or asserts findings; it notes adenomyosis is often a *presumptive* diagnosis to set honest expectations.
- **Red-flags:** uncontrolled heavy bleeding and anemia red-flags trigger clear **"seek care now"** education (content only) + saved emergency contact; never triage, never "you're hemorrhaging/anemic."
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs "You have adenomyosis/anemia/endometriosis/fibroids."
- **Anemia / iron content:** awareness + "ask about FBC/ferritin" + general dietary-iron education only; **never** a supplement recommendation or dose; iron repletion described as clinician-managed. (Shared with B4.)
- **Medication/procedure content (NSAIDs, tranexamic acid, LNG-IUS, hormonal, GnRH, UAE, ablation, hysterectomy):** educational context only; no recommendation, ranking, dosing, or "take/do this"; the fertility/age framing is educational context, not advice. Clear non-prescription disclaimer + clinician routing.
- **Fertility content:** associations (implantation/miscarriage/IVF) presented as education with uncertainty honesty; never a prognosis for the individual; "many people conceive" balance to avoid harm/doom.
- **Predictions:** no fertile/"safe" window presented as reliable; add "not for contraception" note wherever ovulation/fertility appears.
- **Mental health:** crisis resources on any low mood screen; validation content acknowledges diagnostic delay without inducing alarm; localized per region/language.
- **Privacy (GDPR/PDPL health data):** health data = special-category; explicit granular consent, purpose limitation, no ad-SDK/third-party sharing of cycle/pain/bleeding/health data (post-Flo trust); local-first where feasible (incl. any bloating photos); full export/delete. Data-mapping + DPIA required before launch. Export/print of the visit-prep pack is user-initiated and scoped.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education keeps out of regulated-device territory — legal review before store submission.
- **[NEEDS SOURCE]** flags: (a) precise prevalence range to display publicly (estimates vary widely, ~20–35%) — verify wording with medical review; (b) whether to show the MRI junctional-zone ≥12 mm figure to users or keep it clinician-facing only; (c) per-app competitor feature claims; (d) exact PBAC cut-off to display (≥100 vs ≥150) — carried from B4; (e) the "~24% of infertile women" and "~40% endometriosis co-occurrence" figures are from secondary/cohort sources — verify against primary peer-reviewed sources before any public claim; (f) per-locale crisis directories and emergency numbers; (g) localized "coin/quarter-sized clot" wording.

---

## Sources

**Clinical — Tier 1 (NIH/NHS/MedlinePlus/gov):**
- [Adenomyosis — NHS](https://www.nhs.uk/conditions/adenomyosis/)
- [Adenomyosis — NHS inform (Scotland)](https://www.nhsinform.scot/healthy-living/womens-health/girls-and-young-women-puberty-to-around-25/periods-and-menstrual-health/adenomyosis)
- [Adenomyosis — StatPearls, NCBI Bookshelf (NIH)](https://www.ncbi.nlm.nih.gov/books/NBK539868/)
- [Adenomyosis — Symptoms & causes — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/adenomyosis/symptoms-causes/syc-20369138)
- [Adenomyosis — Diagnosis & treatment — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/adenomyosis/diagnosis-treatment/drc-20369143)

**Clinical — Tier 2 (guidelines / society / peer-reviewed / specialist):**
- [Adenomyosis — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/14167-adenomyosis)
- [Adenomyosis: Diagnosis and Management — American Family Physician (AAFP)](https://www.aafp.org/afp/2022/0100/p33)
- [Uterine Adenomyosis — MSD Manual Professional Edition](https://www.msdmanuals.com/professional/gynecology-and-obstetrics/miscellaneous-gynecologic-disorders/uterine-adenomyosis)
- [Adenomyosis Treatment & Management — Medscape](https://emedicine.medscape.com/article/2500101-treatment)
- [Adenomyosis Clinical Presentation — Medscape](https://emedicine.medscape.com/article/2500101-clinical)
- [Adenomyosis — Johns Hopkins Medicine](https://www.hopkinsmedicine.org/health/expert-qa/adenomyosis)
- [Management of uterine adenomyosis: current trends and uterine artery embolization — PMC6486932](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6486932/)
- [Adenomyosis: an underacknowledged cause of abnormal uterine bleeding and pelvic pain — PMC11959650](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11959650/)

**Diagnosis / imaging:**
- [From Clinical Symptoms to MR Imaging: Diagnostic Steps in Adenomyosis — PMC5733957](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5733957/)
- [MRI for adenomyosis: a pictorial review — PMC5707223](https://pmc.ncbi.nlm.nih.gov/articles/PMC5707223/)
- [Transvaginal ultrasound or MRI for diagnosis of adenomyosis — PubMed 18007126](https://pubmed.ncbi.nlm.nih.gov/18007126/)
- [2D/3D transvaginal ultrasound findings in symptomatic women — PMC8341039](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8341039/)

**Overlap with endometriosis & fibroids:**
- [Are Adenomyosis and Endometriosis Phenotypes of the Same Disease Process? — PMC10812963 / MDPI](https://pmc.ncbi.nlm.nih.gov/articles/PMC10812963/)
- [Co-occurrence of endometriosis and uterine fibroids: systematic review & meta-analysis — eClinicalMedicine](https://www.thelancet.com/journals/eclinm/article/PIIS2589-5370(25)00443-2/fulltext)
- [The Overlap of Fibroids and Adenomyosis — Pelvic Rehabilitation Medicine](https://pelvicrehabilitation.com/the-overlap-of-fibroids-and-adenomyosis-what-you-need-to-know/)
- [Systemic comorbidities in patients with adenomyosis — Reproductive BioMedicine Online](https://www.rbmojournal.com/article/S1472-6483(25)00309-8/fulltext)

**Fertility / pregnancy / menopause:**
- [From Diagnosis to Fertility: Optimizing Treatment of Adenomyosis for Reproductive Health — PMC11355825](https://pmc.ncbi.nlm.nih.gov/articles/PMC11355825/)
- [Impact of adenomyosis and endometriosis on IVF/ICSI outcome (GnRH agonist + FET) — PMC10130073](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10130073/)
- [Fertility/obstetric outcomes of ART in women with adenomyosis after GnRH agonist therapy — PMC10552683](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10552683/)
- [Dienogest for Treatment of Adenomyotic Uteri — ClinicalTrials NCT03890042](https://clinicaltrials.gov/study/NCT03890042)

**Patient experience / diagnostic delay / mental health:**
- [Experience of Symptoms and Disease Impact in Patients with Adenomyosis — PMC5948244](https://pmc.ncbi.nlm.nih.gov/articles/PMC5948244/)
- [Higher Risk of Anxiety and Depression in Women with Adenomyosis vs Uterine Leiomyoma — PMC9099604](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9099604/)

**Bleeding quantification & anemia (shared with B4):**
- [Pictorial methods to assess heavy menstrual bleeding: systematic review — PMC7011238](https://pmc.ncbi.nlm.nih.gov/articles/PMC7011238/)
- [Heavy menstrual bleeding: assessment and management — NICE guideline NG88 (PDF)](https://www.nice.org.uk/guidance/ng88/resources/heavy-menstrual-bleeding-assessment-and-management-pdf-1837701412549)
- [Relationship between HMB, iron deficiency, and iron-deficiency anemia — AJOG 2023](https://www.ajog.org/article/S0002-9378(23)00024-8/fulltext)
- [Prevalence and impacts of HMB on anemia, fatigue and QoL — PMC6500811](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6500811/)

**Competitor / app landscape:**
- [Endometriosis & Adenomyosis — App Store](https://apps.apple.com/gb/app/endometriosis-adenomyosis/id6759827829)
- [ENdi: Endometriosis Tracker — App Store](https://apps.apple.com/us/app/endi-endometriosis-tracker/id1533158272)
- [Endolog: Endometriosis Tracker — App Store](https://apps.apple.com/us/app/endolog-endometriosis-tracker/id6756697164)
- [Endometriosis Tracker (Endira) — App Store](https://apps.apple.com/us/app/endometriosis-tracker/id6743563939)
- [The QENDO App — endo/adeno/PCOS/pelvic-pain symptom tracker](https://www.qendo.org.au/qendo-app)
- [Good-Quality mHealth Apps for Endometriosis Care — PubMed 39918848](https://pubmed.ncbi.nlm.nih.gov/39918848/)
