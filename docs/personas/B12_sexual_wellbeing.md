# Persona B12 — Sexual wellbeing: low libido, painful sex (dyspareunia), vaginismus & pelvic-floor concerns

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician."
> Research date: 2026-07-21 · Persona band: B (reproductive-age & lifespan overlay) · **Discreet-mode aware** · **Non-judgemental, never medicalizes normal variation**
> Inherits: `09_MASTER_ADAPTATION_MODEL.md` (seven invariants, state object, constant core, universal events, Z1 fallback, blending). This spec adds only B12-specific layers.

---

## A. Persona snapshot

**Who she is.** "Nour," 31. Married three years. Sex has become something she quietly dreads — penetration hurts (a burning, "hitting a wall" feeling), her desire has faded, and she has started avoiding intimacy, which is straining her marriage. She has never said the words "painful sex" out loud to anyone, least of all a doctor. She is Arabic-first (also reads English), searches privately late at night on her phone, and clears her browser history. She is terrified someone — a partner, a family member, a nosy notification — will see what she is looking at.

This persona is deliberately **archetype-plural**. B12 also covers:
- **"Huda," 24, newly married**, unable to consummate; involuntary muscle tightening at any attempt (vaginismus) — a leading cause of unconsummated marriage in MENA.
- **"Salma," 39, postpartum**, sex painful and libido flat since her second baby (scar/pelvic-floor + hormonal + exhaustion).
- **"Amira," 54, perimenopausal/menopausal**, dryness and burning with sex (GSM) that she assumed she "just had to live with."
- **"Layal," 29**, whose low desire tracks her stress, her relationship, and an SSRI — and who mainly needs to know this is common and not a defect.

**What she lives with.**
- **Low / absent desire** — often distressing, often situational, sometimes tangled with relationship, mood, fatigue, medication, or hormones.
- **Pain with sex (dyspareunia)** — superficial (entry) or deep, from many possible causes (dryness/GSM, pelvic-floor tension, infection, endometriosis, postpartum healing, skin conditions).
- **Vaginismus** — involuntary pelvic-floor tightening making penetration painful or impossible; heavy shame and marital pressure, especially in MENA.
- **Pelvic-floor concerns** — tension, weakness, or coordination issues; poorly understood by most women.
- **Silence and shame** — the overarching condition. Cultural taboo ("ayb"), fear of judgement, and lack of vocabulary keep her from care for years.

**Core emotional drivers.** Wants to feel *normal, private, and not broken*. Wants a discreet, non-judgemental place to name what is happening, learn that it is common and often treatable, understand what kind of clinician helps, and quietly track patterns — without anyone knowing, without being told she has a "disorder," and without being pushed toward either "just relax" dismissal or clinical alarm.

**Jobs-to-be-done.**
1. Privately name and understand what she is experiencing (desire / arousal / pain / muscle) without shame.
2. Learn that this is common, has real causes, and is usually improvable — and that normal desire varies enormously.
3. Track patterns (pain type/location, desire, mood, cycle, sleep, stress, medications, life events) discreetly.
4. Learn pelvic-floor and self-care basics (relaxation, breathing, lubricant/moisturizer literacy, dilator concept) as *awareness*, not prescription.
5. Know **who** to see (GP, gynecologist, pelvic-floor physiotherapist, psychosexual/sex therapist) and how to raise it — with discretion.
6. Do all of this in a mode that hides content behind a discreet cover and never leaves an obvious trail.

**Success = she goes from years of silent avoidance to (a) understanding her situation has a name and a route, and (b) booking or preparing for the right clinician — without ever feeling judged or exposed.**

---

## B. Needs & questions (voice-of-user)

Mined from women's sexual-health communities (r/vaginismus, r/sex, r/DeadBedrooms, r/TwoXChromosomes), pelvic-health forums, app reviews, MENA sexual-health features, and qualitative literature (Arab-Muslim vaginismus case series; "ayb"/taboo reporting — see Sources). Paraphrased to avoid quoting individuals.

**On pain (dyspareunia / vaginismus):**
- "It feels like he's hitting a wall. Is something wrong with me physically?"
- "We've been married a year and haven't been able to. I can't tell anyone. I feel like a failure."
- "It burns at the entrance every single time — is that dryness, or something else?"
- "The doctor just said 'relax and have a glass of wine.' That's not advice, and I don't drink."

**On low desire:**
- "I love my partner but I have zero interest in sex. Am I broken? Is this hormonal?"
- "My drive tanked after I started my antidepressant / after the baby / in menopause — no one warned me."
- "How much desire is 'normal'? I don't want a pill, I want to know if this is even a problem."

**On being dismissed / not knowing who to see:**
- "I've been told it's in my head. It is NOT just in my head — it physically hurts."
- "I didn't even know pelvic-floor physiotherapists existed until years in."
- "What kind of doctor do I even ask for? I can't say 'painful sex' at a family clinic here."

**On postpartum & menopause:**
- "Six months after birth and it still hurts. Everyone acts like that's normal — is it?"
- "Since menopause it's like sandpaper. I thought that was just my life now."

**On privacy & discretion (amplified vs. other personas):**
- "I would never install an app with a sexy name on my phone. Someone would see it."
- "I clear my history every time. I need this hidden."
- "After the Flo/Facebook thing — I will not have *this* data leaked. Ever."

**On culture / shame (MENA):**
- "There's no way to talk about this at home. It's 'ayb'. I learned everything wrong."
- "My mother said pain the first time is normal and I just have to bear it."

**Top recurring questions Femio must answer in-product:**
1. Why does sex hurt — and what are the different kinds of pain and causes?
2. Is my low desire "normal"? How much variation is normal? When is it worth discussing?
3. What is vaginismus / pelvic-floor tension, and what actually helps?
4. What is a pelvic-floor physiotherapist, a psychosexual/sex therapist — and which do I need?
5. Could this be from my medication / postpartum healing / menopause (GSM)?
6. How do I bring this up with a clinician, discreetly, and what can I expect?
7. How do I keep all of this completely private?

---

## C. Competitor teardown

Sexual wellbeing for women is a **structural gap**: the market splits into (1) *pleasure/education apps* (audio, mindfulness, CBT — Western, English-first, subscription, not clinical, not tracking-led, culturally explicit branding) and (2) *cycle trackers* (barely touch sexual pain/desire, no discreet mode). Almost nothing serves a MENA, Arabic-first, discretion-first user who needs stigma-free education + pattern tracking + clinician routing for **pain and low desire**.

| App | Model | Sexual-pain / vaginismus depth | Low-desire framing | Tracking of symptoms | Discretion / privacy | Culture / language | Gap Femio exploits |
|---|---|---|---|---|---|---|---|
| **Rosy** | US, clinician/psychologist-built, subscription | Some pain content + coaching | Good, distress-aware | Light | Standard | English, US-centric; **shutting down Nov 2025** | Persistence, tracking, Arabic-first, discreet mode |
| **Ferly** | UK, pleasure + CBT/mindfulness, audio | Anxiety-around-sex content, not clinical pain workup | Strong on desire *as pleasure*, less on medical causes | Minimal | Standard | English, Western pleasure framing | Clinical grounding, pain-cause literacy, clinician routing, discretion |
| **Emjoy** | Audio "sexual wellcare," subscription | Low | Desire/self-esteem audio | Minimal | Standard | English/EU; explicit branding | Discreet cover, tracking, condition literacy, Arabic |
| **Coral** | Couples-focused, science-backed exercises | Low | Connection/anxiety focus | Minimal | Standard | English, partner-centric | Solo, private, non-partner-dependent path; discretion |
| **OMGYes** | Web, female-pleasure techniques, one-time fee | None (pleasure, not pain) | N/A | None | Standard | Explicit; English | Entirely different job — Femio covers pain/desire/clinical route |
| **Cycle trackers (Flo/Clue/etc.)** | Freemium | Almost none — a symptom tag at best | Almost none | Cycle-linked only | Flo carries **FTC/Facebook trust damage** | Some AR; no discreet mode | Dedicated sexual-wellbeing layer, discreet mode, uncertainty-honest, privacy-by-design |
| **Pelvic-floor apps (e.g. Kegel trainers)** | Freemium | Kegels only (can *worsen* hypertonic/vaginismus) | N/A | Exercise streaks | Standard | English | **Correct framing** (relaxation vs. strengthening), education not prescription, clinician routing |

**Cross-cutting failures Femio targets:**
1. **No discreet-first product.** Sexual-wellness apps *announce themselves* on the home screen — a dealbreaker for a MENA/discretion user. Femio's discreet mode (neutral name/icon, cover screen, hidden content) is a first-class differentiator.
2. **Pleasure-washing vs. pain literacy.** The category optimizes for pleasure/desire coaching and under-serves *painful sex and vaginismus* with clinically grounded, cause-aware education and correct routing.
3. **Kegel harm risk.** Generic pelvic-floor apps push strengthening, which can worsen hypertonic pelvic-floor/vaginismus. Femio must teach **down-training/relaxation vs. strengthening** and route to a pelvic-floor physiotherapist.
4. **No Arabic-first, culturally-sensitive option** for a problem (vaginismus/unconsummated marriage) that is disproportionately prevalent and silenced in MENA.
5. **Trust.** Post-Flo, a user will not hand *this* data to an ad-funded app.

*[NEEDS SOURCE] — precise user counts, subscription prices, and shutdown dates for named apps are from secondary/marketing sources; verify before any public claim. Rosy shutdown (Nov 2025) per app-review coverage — confirm.*

---

## D. Clinical grounding (cited)

> Framing discipline: Femio presents this as **wellness education + screening + tracking**, never diagnosis or treatment. **Desire varies enormously between people and across life; low or variable desire is not automatically a disorder** — it is only clinically relevant when *the woman herself* is distressed by it. Femio never labels normal variation as pathology.

**Female sexual function is multi-domain.** Concerns cluster into **desire, arousal, orgasm, and pain**, and are considered relevant when they cause **personal distress**. Sexual difficulties affect roughly **30–40% of women** at some point; **low desire is the single most common complaint** [MSD Manual (Merck) Consumer; ACOG Practice Bulletin, Female Sexual Dysfunction]. Causes are commonly a **mix of physical, hormonal, psychological, relational, and social factors** — rarely one thing [MSD Manual; ACOG].

**Low desire / HSDD (framed carefully).** Persistently absent or reduced sexual desire *that causes personal distress* for **≥6 months**, not better explained by another cause, is described in the literature as **Hypoactive Sexual Desire Disorder (HSDD)**, estimated at ~**10% of adult women** [ISSWSH Expert Consensus / Mayo Clinic Proceedings; ISSWSH Process of Care]. Contributing/associated factors include mood and stress, relationship context, fatigue, life stage (postpartum, menopause), and **medications — notably SSRIs/SNRIs** [ISSWSH; ACOG]. Treatments exist (e.g., psychotherapy/sex therapy, addressing contributors; FDA-approved **flibanserin** for premenopausal generalized acquired HSDD; **off-label testosterone** for some postmenopausal women) — **all clinician-led; Femio presents these as *education only*, never a recommendation or dose** [ISSWSH; ICSM 2024 recommendations].

**Dyspareunia (painful sex).** Medical term for pain in the genital/pelvic area during or after sex; classified as **superficial/entry** or **deep**. Common contributors: **vaginal dryness / GSM**, infection or inflammation, **endometriosis** (often deep pain), **pelvic-floor muscle dysfunction**, skin/vulvar conditions, postpartum healing/scarring, and **psychological factors including anxiety, stress, or a history of trauma** [Mayo Clinic; Cleveland Clinic; patient.info (NHS-aligned); NHS Lothian women's-health physiotherapy]. It is common and **usually treatable once the cause is identified** — hence the value of clinician evaluation [Mayo Clinic; Cleveland Clinic].

**Vaginismus.** Involuntary tightening/contraction of the pelvic-floor muscles on attempted vaginal penetration, making it painful or impossible; contributors are **physical, psychological, or both** (e.g., prior painful/traumatic experience, fear/anxiety, insufficient sexual knowledge) [Cleveland Clinic; patient.info; Physiopedia]. **NHS-described management** centers on **vaginal dilators (graded desensitization), pelvic-floor physiotherapy, relaxation techniques, and psychosexual counselling/CBT**; pelvic-floor physical therapy shows high reported success in the literature [NHS Lothian; patient.info; Cleveland Clinic]. *Femio explains these approaches as awareness/education and routes to a clinician/physiotherapist — it does not prescribe a dilator protocol.*

**Pelvic-floor physiotherapy.** A specialist can teach exercises to **relax and coordinate** (not just strengthen) pelvic-floor muscles and reduce pain; it is a first-line, evidence-supported route for sexual pain, vaginismus, and many pelvic-floor concerns [Cleveland Clinic; Physiopedia; ACOG general management]. **Key safety nuance Femio must teach: for tight/hypertonic pelvic floors, generic Kegel *strengthening* can worsen symptoms — "down-training"/relaxation is often what's needed. Only a clinician can tell which.**

**Genitourinary Syndrome of Menopause (GSM).** 2014 consensus term (replacing "vulvovaginal atrophy/atrophic vaginitis") for genital, sexual, and urinary changes from low estrogen — vaginal **dryness, burning, irritation, painful sex, and urinary symptoms**; affects **>50% of postmenopausal women** and is under-recognized. First-line = **non-hormonal lubricants and moisturizers**; **local vaginal estrogen** is a mainstay for those who need more; managed with a clinician [NCBI StatPearls; Cleveland Clinic J Med; AUA/SUFU/AUGS 2025 Guideline]. *Femio: education + "discuss with clinician," never a prescription.*

**Postpartum sexual pain / low desire.** Common in the months after birth (tissue healing/scar, pelvic-floor changes, hormonal shifts incl. lactational low estrogen causing dryness, fatigue, mood) — **often improves, but persistent pain warrants clinician review** rather than being dismissed as "just normal." *Femio frames as expected-but-checkable; routes from the E-track.* [ACOG; general clinical consensus — [NEEDS SOURCE] for a single Tier-1 postpartum-specific citation.]

**Cultural / MENA context (clinically documented).** Vaginismus is a **leading cause of unconsummated marriage** across Arab/Muslim countries (reported in ~**20–67%** of unconsummated-marriage couples in various studies); **insufficient sexual knowledge** and **cultural taboo about pain/bleeding at first intercourse** are documented risk/aggravating factors; culturally-adapted therapy improves outcomes [Ann Saudi Med, vaginal penetration phobia in Arab women; Cambridge, *Cultural aspects of vaginismus therapy: Arab-Muslim case series*].

**Femio scope guardrail restated:** everything above is **education, screening, and tracking**, with consistent "discuss with your clinician" routing. Femio is **not contraception**, does not diagnose sexual dysfunction, does not prescribe dilator protocols or medications, and **never frames normal desire variation as disease**.

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to trust and switch.**
1. **Discreet mode (flagship for B12).** Optional neutral app name/icon, a plausible cover screen, PIN/biometric lock, quick-exit ("panic switch"), no revealing lock-screen notifications, discreet content thumbnails/titles. On by default when B12 is entered via the wizard.
2. **Stigma-free sexual-wellbeing education library** — desire, arousal, pain (superficial vs deep), vaginismus, pelvic-floor basics, GSM, postpartum — grade 6–8, Arabic-first, warm and clinical, zero shame, zero explicit branding.
3. **"Normal is a wide range" desire framing** — content and any screener explicitly normalize variation; only *self-reported distress* elevates it to "worth discussing," never the app deciding.
4. **Discreet symptom/pattern tracking** — pain (yes/no, entry vs deep, burning/tight/etc.), desire level, arousal/lubrication, mood, stress, sleep, cycle phase, medications, life events — viewable together over time.
5. **Clinician-routing module** — plain-language "who does what": GP/gynecologist, **pelvic-floor physiotherapist**, **psychosexual/sex therapist**, and how to raise it discreetly; visit-prep summary (exportable/printable, discreet).
6. **Pelvic-floor & self-care awareness** — relaxation/breathing basics, **relaxation-vs-strengthening** explainer (Kegel-harm safety note), lubricant/moisturizer literacy, dilator *concept* — all as education, all routed to a clinician for a real plan.
7. **Privacy-by-design, hardened** — no ad/analytics-SDK access to this data, local-first where feasible, granular consent, full export/delete; explicit "this data is never shared" assurance.

**P1 — strong differentiators.**
8. Cause-aware pain explainer ("kinds of pain and what they can mean — this is not a diagnosis") that maps symptoms to *questions to ask a clinician*, not to verdicts.
9. Medication-awareness content (e.g., SSRIs and libido) — educational, "don't stop meds; discuss with your clinician."
10. Mental-health & relational overlay — screening (mood/anxiety) + coping content; gentle, optional "relationship strain" resources; crisis resources on any low screen; **trauma-sensitive** copy and an easy skip.
11. Life-stage-aware skins — postpartum (from E-track) and menopause/GSM (from F-track) versions of the pain/dryness content.

**P2 — depth / retention.**
12. Trend insight ("your low-desire and high-stress logs cluster together" / "entry pain logs align with your driest cycle days") — descriptive, never causal/diagnostic.
13. Optional partner-education content she can *choose* to share (scoped, revocable) — never partner-visible by default.
14. Guided relaxation/breathing audio (discreetly titled), framed as self-care/awareness, not therapy.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Your sexual wellbeing, without shame** — sets tone: common, varied, not "ayb," not a moral failing; what this space is (education/tracking) and isn't (diagnosis).
2. **Desire is a spectrum** — how much desire is "normal" (a lot of variation), spontaneous vs responsive desire, when *you* might want to discuss it (distress, not a number).
3. **Why sex can hurt (dyspareunia)** — superficial vs deep; common causes (dryness/GSM, pelvic-floor tension, infection, endometriosis, postpartum, skin); "pain is a signal to get checked, not something to endure."
4. **Vaginismus explained** — what the muscle response is, why it happens, that it's common and *often very treatable*; the roles of physiotherapy, dilators, relaxation, and counselling (education only). MENA-sensitive version addressing unconsummated marriage with dignity.
5. **Your pelvic floor 101** — what it is, tension vs weakness, **relaxation vs strengthening (and why Kegels can backfire)**, breathing basics; when to see a pelvic-floor physiotherapist.
6. **Lubricants & moisturizers 101** — types, what they do, dryness/GSM context — practical, non-judgemental.
7. **Sex after birth** — expected changes, what's common, and when persistent pain/dryness deserves a clinician (links to E-track).
8. **Sex and menopause (GSM)** — dryness/burning/pain, that it's treatable, first-line options as *education* (links to F-track).
9. **Could it be my medication or my mood?** — SSRIs and libido, stress, depression/anxiety; "don't stop meds — discuss."
10. **Who can help & how to ask** — GP, gynecologist, pelvic-floor physio, psychosexual/sex therapist; scripts for raising it discreetly; what a first visit is like.
11. **When it's tangled with the relationship** — communication basics, that this is common; optional couples/relational resources.
12. **Myths vs. evidence** — "pain the first time is just normal," "low desire means you don't love your partner," "it's all in your head," "just relax."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, and a **trauma-sensitive / skip-friendly** design. Discreet-mode-safe titles and thumbnails.

---

## G. Tools, logs & alerts (compliant framing)

**Logs (all optional, discreet, toggleable)**
- Sexual-wellbeing log: desire level, arousal/lubrication, whether intimacy occurred (optional), **pain** (present/absent, entry vs deep, quality: burning/tight/aching), avoidance.
- Context log: mood, anxiety, stress, sleep, fatigue, cycle phase, medications (esp. new starts), major life events.
- Pelvic-floor self-care log (relaxation/breathing practice) — framed as awareness, never a prescribed protocol or streak-pressure.
- Optional private notes; optional lab/clinician-note entry (entry only, no interpretation).

**Tools**
- **Pattern insight** — descriptive correlations ("appears associated with," never "caused by"); explicitly not diagnostic.
- **"What kind of clinician?" router** — a short, non-diagnostic guide (not a triage engine) mapping concern → who typically helps → how to ask.
- **Discreet visit-prep generator** — one-tap export/print summary (patterns, questions, "who to see"), with a neutral filename/format.
- **Screeners (framed as screening, not diagnosis):**
  - Distress-anchored desire/sexual-wellbeing check (e.g., a brief validated-style screen) → result: "This is a screening tool, not a diagnosis. **Low or variable desire is very common and often normal** — this only flags that you might find it helpful to discuss. Consider talking to a clinician." + resources.
  - Mood/anxiety screen (PHQ-2/GAD-2 style) → screening result + crisis resources; trauma-sensitive framing and skip.

**Alerts (all non-alarming, discreet, dismissible, localized/RTL, screening-framed)**
- Gentle "worth checking" nudge for **persistent pain** (e.g., pain logged repeatedly over time, or postpartum pain persisting) → "Ongoing pain is worth discussing with a clinician — here's why and who." Never alarmist.
- Optional self-care reminders (relaxation/breathing) — no pressure, no streaks, easy to silence.
- Screening follow-up nudge (re-check mood in N weeks).
- **Never:** "you have vaginismus/HSDD"; never a dilator dose/schedule as instruction; never "your desire is too low"; never contraception/fertile-window claims; never disease-prevention claims; never partner-visible alerts.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — inherited)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off); **discreet-mode flags (cover on, lock type, quick-exit)**.
- Life-stage / mode flag (here: sexual-wellbeing overlay; may co-exist with B/E/F track).
- Cycle events (if she tracks them); generic mood/energy/sleep.

**Persona-specific (B12 sexual-wellbeing layer)**
- Concern focus (self-report, multi-select): low/variable desire · arousal/lubrication · pain with sex · difficulty with penetration/muscle tightening · pelvic-floor concern · post-birth · menopause-related. **Distress flag (self-reported)** — the only thing that elevates "worth discussing."
- Pain detail (self-report): present/absent, superficial vs deep, quality, situational vs persistent.
- Desire/arousal self-report; avoidance frequency (optional).
- Context modifiers: medications (SSRIs etc., self-report), postpartum week (from E-track), menopause/GSM signals (from F-track), relationship-strain flag (optional), trauma-sensitive flag (drives gentler copy, never stored as diagnosis).
- Mental-health screen history (scores + dates, screening-only).
- Pelvic-floor self-care activity (awareness only).
- User-entered clinician notes/labs — entry only, no interpretation.

*All fields optional, encrypted, user-deletable. This data class is treated as the most sensitive in Femio: no ad-SDK access, no third-party sharing, discreet-mode-protected, and re-confirmed on any new sharing scope.*

---

## I. Personalization rules (wizard → home config; discreet + hidden-but-reachable)

**Entry into B12.** B12 is an **overlay**, reachable from multiple points, not a single wizard branch:
- Wizard "top concerns" multi-select includes a discreetly worded "**Intimacy & sexual wellbeing**" option (available across reproductive, postpartum, and menopause branches).
- Searching sexual-pain/desire terms in the library offers: "Want to set up a private space for this? Discreet mode can hide it. You can undo anytime."
- Postpartum (E) and menopause (F) flows surface it contextually ("Some people notice changes in comfort/desire — want gentle info?").

**On entry, offer discreet mode first** — before any content loads — explaining the cover, lock, and quick-exit. Explicit, reversible confirmation (per invariant §3).

**Onboarding (B12 overlay) — minimal, gentle, skippable:**
- Q: what would you like support with? (multi-select concern focus; all optional; "just exploring" is valid).
- Q: is this causing you distress? (anchors framing — but never gates access, never labels).
- Q: any context you want me to know? (postpartum / menopause / new medication / prefer extra-gentle content) — all optional; the trauma-sensitive toggle simply softens copy.
- Q: privacy — turn on discreet mode? (default yes for this overlay).

**Home configuration (B12 default):**
- Hero = a calm, non-explicit "Your sexual wellbeing" card with reassurance + "understand / track / who can help" entry points. No imagery that would be awkward on a glanced screen.
- Cards ordered by her concern selection (pain → pain-cause + pelvic-floor + routing surfaced; desire → desire-spectrum + medication/mood; postpartum/menopause → the E/F skins).
- Clinician-router and discreet visit-prep pinned.
- Nothing celebratory, nothing gamified.

**Hidden-but-reachable principle.** Femio never removes knowledge. All other content stays discoverable; conversely, B12 content is fully reachable from search even if the overlay isn't "on." Discreet mode hides *presentation*, never *access*.

**Adaptive tuning:** repeated persistent-pain logs → raise "worth checking" + routing prominence (educational). Low mood screens → surface mental-health module + resources. New SSRI logged → gently surface the medication-and-libido explainer ("don't stop meds; discuss"). Postpartum week / menopause signals → swap in the E/F content skin.

---

## J. Adaptation triggers (life-stage routing)

> Inherits all **universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive test, loss → instant suppression, mood-crisis path, red-flag box, disengagement, mode-off, age-of-consent). Below are **B12-specific** transitions only. Every transition is explicitly confirmed, reversible, and data-preserving.

| Trigger | System response | Route |
|---|---|---|
| **Postpartum sexual pain / low desire** (persona active while in/after E-track) | Swap to postpartum skin: "changes are common and often improve; persistent pain is worth checking"; carry pelvic-floor + healing content; keep discreet mode | Blend **B12 ⊕ E-track**; if pain persists, raise clinician-routing prominence |
| **Menopause / GSM signals** (age/symptom: dryness, burning, painful sex, 40s+) | Introduce **GSM** education skin (dryness/pain treatable; lubricant/moisturizer + local-estrogen as *education*); clarify GSM-vs-other-cause | Blend **B12 ⊕ F-track (→ F6/menopause-symptom persona)** |
| **Pain pattern suggests a specific cause** (e.g., cyclical deep pain, or entry pain + other flags) | Non-diagnostic "kinds of pain / questions to ask"; strengthen routing; **if endometriosis-type or other gynae pattern, offer relevant condition education** | Offer **B10 / B7** (pelvic-pain / gynae-condition personas) as *content routes*, if indicated — education only, never a diagnosis |
| **Vaginismus / penetration difficulty focus** | Vaginismus + pelvic-floor + dilator-concept education (awareness); MENA-sensitive unconsummated-marriage content; strong routing to pelvic-floor physio + psychosexual therapist | Stay B12, raise pelvic-floor + therapy routing; discreet visit-prep |
| **New SSRI/SNRI or other libido-affecting med logged** | Surface medication-and-libido explainer; "don't stop meds — discuss with your clinician" | Stay B12, educational nudge |
| **Relationship-strain flag / relational focus** | Surface communication + optional couples/relational resources; keep it optional and non-judgemental | Stay B12; optional relational content overlay |
| **Mood screen trends low / trauma-sensitive flag / crisis** | Universal mood-crisis handler + localized crisis resources; trauma-sensitive copy; easy skip; silence-over-risk | Stay B12 + mental-health routing (inherited universal) |
| **Sets TTC intent / positive test** | Inherited universal handlers; sexual-wellbeing content remains reachable but de-emphasized unless she keeps it on | → C / D-track (B12 overlay archived-but-reachable) |
| **User toggles discreet mode or overlay off** | Revert presentation; **preserve all history**; re-confirm nothing is exposed | Generic band; B12 data retained, reachable |

**Blending note (per §8):** B12 is an **overlay** that composes with B/E/F personas rather than replacing them (e.g., a menopausal user is F-track *with* a B12 GSM/sexual-wellbeing layer). Most-acute-emphasis rule applies to the hero; safety/red-flag and clinician-routing layers are unioned, not double-counted.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis (of HSDD, vaginismus, dyspareunia, GSM, or "dysfunction"), no treatment, no dilator/medication protocol, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Never medicalize normal variation.** Desire/arousal content and screeners must explicitly normalize wide variation; only *self-reported distress* frames something as "worth discussing." Never output "your desire is too low" or "you have HSDD."
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician," with the normalize-variation caveat. Never diagnoses.
- **Medication content (flibanserin, testosterone, local estrogen, SSRIs):** educational context only; no recommendation, dosing, or "take/stop this." Explicit "don't stop prescribed meds without your clinician." Clinician routing.
- **Pelvic-floor / dilator content:** framed as *awareness*, not a prescribed regimen; **must teach relaxation-vs-strengthening and the Kegel-harm caution**; route real plans to a pelvic-floor physiotherapist. Never a "do this protocol" instruction.
- **Trauma-sensitivity:** all sexual-pain and history content is skip-friendly and gently worded; no forced questions about trauma; trauma flag never stored/exported as a diagnosis.
- **Discreet mode & privacy (elevated):** this is Femio's **most sensitive data class**. Discreet cover/lock/quick-exit; no revealing notifications; no ad/analytics-SDK access; no third-party sharing of sexual-wellbeing data; local-first where feasible; granular consent; full export/delete; re-confirm scope on any new sharing. DPIA + data-mapping required before launch (post-Flo trust context explicit).
- **Cultural sensitivity (MENA/Arabic-first):** respectful, non-judgemental, "ayb"-aware copy; dignity-first vaginismus/unconsummated-marriage content; culturally-adapted routing; Arabic-first + RTL QA. Avoid explicit branding/imagery.
- **Mental health:** crisis resources on any low screen; localized per region/language; EPDS/PHQ crisis-item logic inherited.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** framing as tracking/education (not device/diagnosis) keeps out of regulated-device territory; discreet-mode app-naming must still comply with store policies — legal review before store submission.
- **[NEEDS SOURCE]** flags: (a) competitor user counts / prices / Rosy shutdown date; (b) a single Tier-1 postpartum-sexual-pain citation; (c) exact vaginismus PT success-rate figure (systematic-review number is secondary — verify before public use); (d) precise MENA unconsummated-marriage prevalence range (studies vary widely — cite specific study).

---

## Sources

**Clinical — Tier 1 (NIH/NHS/MedlinePlus/OWH/gov & major consumer-clinical):**
- [Overview of Sexual Function and Dysfunction in Women — MSD/Merck Manual Consumer](https://www.msdmanuals.com/home/women-s-health-issues/sexual-function-and-dysfunction-in-women/overview-of-sexual-function-and-dysfunction-in-women)
- [Genitourinary Syndrome of Menopause — StatPearls, NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK559297/)
- [Painful intercourse (dyspareunia): symptoms & causes — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/painful-intercourse/symptoms-causes/syc-20375967)
- [Dyspareunia (painful intercourse) — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/12325-dyspareunia-painful-intercourse)
- [Vaginismus: causes, symptoms, diagnosis & treatment — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/15723-vaginismus)
- [Dyspareunia (pain having sex) — patient.info (NHS-aligned)](https://patient.info/sexual-health/dyspareunia-pain-having-sex)
- [Vaginismus and dyspareunia (sexual pain) — NHS Lothian Women's Health Physiotherapy (PDF)](https://services.nhslothian.scot/womanshealthphysiotherapy/wp-content/uploads/sites/152/2024/12/Vaginismus_and_dyspareunia_sexual_pain.pdf)
- [Dyspareunia (pain when having sex) — Royal Berkshire NHS FT (PDF)](https://www.royalberkshire.nhs.uk/media/dannd4hk/dyspareunia_oct24.pdf)

**Clinical — Tier 2 (guidelines / society / peer-reviewed):**
- [Female Sexual Dysfunction — ACOG Practice Bulletin](https://www.acog.org/clinical/clinical-guidance/practice-bulletin/articles/2019/07/female-sexual-dysfunction)
- [Hypoactive Sexual Desire Disorder (HSDD): ISSWSH Expert Consensus Panel Review — Mayo Clinic Proceedings](https://www.mayoclinicproceedings.org/article/S0025-6196(16)30596-1/fulltext)
- [ISSWSH Process of Care for Management of HSDD in Women — ScienceDirect (Mayo Clin Proc)](https://www.sciencedirect.com/science/article/pii/S0025619617307991)
- [ISSWSH — HSDD Expert Consensus Panel Review (society page)](https://www.isswsh.org/resources/publications/370-mayo-clinic-proceedings-hypoactive-sexual-desire-disorder-hsdd-isswsh-expert-consensus-panel-review)
- [Evaluation and management of HSDD in women — 5th International Consultation on Sexual Medicine (ICSM 2024), Sexual Medicine Reviews](https://academic.oup.com/smr/article/14/1/qeaf057/8286982)
- [Genitourinary Syndrome of Menopause: AUA/SUFU/AUGS Guideline (2025)](https://www.auanet.org/guidelines-and-quality/guidelines/genitourinary-syndrome-of-menopause)
- [Genitourinary syndrome of menopause: common problem, effective treatments — Cleveland Clinic J Med](https://www.ccjm.org/content/85/5/390)
- [The Genitourinary Syndrome of Menopause: overview of recent data — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7212735/)
- [Vaginismus — Physiopedia](https://www.physio-pedia.com/Vaginismus)

**Cultural / MENA & patient-journey (qualitative + reporting):**
- [Management of vaginal penetration phobia in Arab women: a retrospective study — Annals of Saudi Medicine](https://www.annsaudimed.net/doi/10.5144/0256-4947.2015.120)
- [Cultural aspects of vaginismus therapy: a case series of Arab-Muslim patients — the Cognitive Behaviour Therapist (Cambridge Core)](https://www.cambridge.org/core/journals/the-cognitive-behaviour-therapist/article/cultural-aspects-of-vaginismus-therapy-a-case-series-of-arabmuslim-patients/EB14A87F556D7D4B82D76A1BA8013C96)
- [How vaginismus is affecting the sex lives of Muslim women — Amaliah](https://www.amaliah.com/post/66193/how-vaginismus-affecting-sex-lives-of-muslim-women)
- [The relationship between sexual health and Middle Eastern women is changing — Daye](https://www.yourdaye.com/vitals/cultural-musings/sexual-health-and-middle-eastern-women/)
- [From taboo to revelation: Arab women find sexual freedom online — The New Arab](https://www.newarab.com/features/taboo-revelation-arab-women-find-sexual-freedom-online)
- [How to overcome vaginismus (patient feature) — patient.info](https://patient.info/features/sexual-health/how-to-overcome-vaginismus)

**Competitor / app landscape:**
- [Rosy (women's sexual health platform)](https://meetrosy.com/)
- [Natural Womanhood review of the Rosy app](https://naturalwomanhood.org/rosy-app/)
- [Ferly — sexual wellbeing app](https://weareferly.com/)
- [Emjoy — Female wellcare (App Store)](https://apps.apple.com/us/app/emjoy-sexual-wellness/id1467274919)
- [8 popular sexual wellness apps to improve low libido — First Impressions](https://firstimpressionsclinic.ca/2022/09/12/8-popular-sexual-wellness-apps-to-improve-low-libido/)
- [7 best sexual wellness apps and websites — Flossy](https://feelflossy.com/blogs/news/7-best-sexual-wellness-apps-and-websites)
