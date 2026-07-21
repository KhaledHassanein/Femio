# Persona F6 — Genitourinary syndrome of menopause (GSM): vaginal dryness, painful sex, urinary urgency & recurrent UTIs after menopause

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, or prevents disease, and is not contraception. Screeners are framed as "screening — discuss with a clinician." Medication content (local vaginal estrogen, DHEA, ospemifene, moisturizers/lubricants) is **educational only** — never a recommendation, dose, or prescription.
> Research date: 2026-07-21 · Persona band: F (menopause lifespan) · Stage: postmenopause (STRAW+10 stage +1/+2) · **Discreet-mode aware** · Stigma-free, culturally sensitive (Arabic-first / MENA)
> Inherits: the seven invariants, state object, constant core, universal events, Z1 fallback, and blending rules of `09_MASTER_ADAPTATION_MODEL.md §1–§8`. Routes to/from `F1` (perimenopause), `F2` (postmenopause), `F4` (surgical/induced menopause), `B10` (recurrent UTI/vaginal health), `B12` (painful sex/pelvic-floor), and `B19` (cancer survivors). This spec adds only F6-specific fields, config, content skin, red-flags, and non-universal transitions.

---

## A. Persona snapshot

**Who she is.** "Mona," 58. Menopause was five years ago and the hot flashes have mostly faded — but something else crept in and never left. Sex burns and stings so much she has started making excuses to avoid it; she describes it to herself as "like sandpaper" and "hitting raw skin." She feels dry and irritated even walking around. In the last year she has had three urinary infections and now feels a constant urge to pee that sends her hunting for bathrooms. She assumed all of this was "just getting old" and something she has to live with. She has never said any of it out loud — not to her husband, not to her doctor, who she has seen twice this year for the UTIs without either of them connecting the dots. Arabic-first (also reads English), private about her body, uses the web on her phone, and would be mortified if a family member glanced at a notification.

This persona is deliberately **archetype-plural**. F6 also covers:
- **"Fatima," 62**, whose only complaint is recurrent UTIs and urinary urgency — she doesn't connect it to menopause at all, and neither does the urgent-care clinic that keeps handing her antibiotics.
- **"Leila," 49**, surgically menopausal after a hysterectomy-with-oophorectomy, hit hard and fast by dryness and painful sex (routes from **F4**).
- **"Huda," 66**, widowed, not sexually active, who suffers dryness, itching, and burning day-to-day and thinks it's not "worth mentioning" because she's "not even having sex."
- **"Salwa," 55**, a breast-cancer survivor on an aromatase inhibitor, with severe GSM, who has been told hormones are off-limits and doesn't know she has options (routes to **B19** oncology-aware nuance).

**What she lives with.**
- **Vaginal dryness, burning, irritation, itching** — the day-to-day discomfort, present with or without sex.
- **Painful sex (dyspareunia)** — entry burning/tearing sensation; a leading reason for intimacy avoidance and relationship strain.
- **Urinary symptoms** — urgency, frequency, burning, and **recurrent UTIs** — the genitourinary half of GSM that is most often missed.
- **Progression, not resolution.** Unlike hot flashes (which usually fade), **GSM is chronic and usually worsens over time without treatment** [NAMS 2020; Mayo Clinic].
- **Silence and misattribution.** She thinks it's "just aging" and is too embarrassed to raise it; her clinician rarely asks. The result is years of untreated, worsening, highly treatable symptoms.

**Core emotional drivers.** Wants to learn that this is **extremely common, has a name, is NOT "just aging," and is treatable** — and that she is not broken or alone. Wants a discreet, non-judgemental place to name and track it, to understand the options (moisturizers/lubricants, local vaginal estrogen — including that it is low-risk and different from systemic HRT), and above all **help saying it out loud to a clinician**, because that first sentence is the hardest part.

**Jobs-to-be-done.**
1. Privately understand what is happening ("is this normal? is it menopause? is it treatable?") without shame.
2. Learn it is common, progressive, and treatable — and that the urinary symptoms and UTIs can be part of the same thing.
3. Discreetly track symptoms (dryness, burning, pain with sex, urgency/frequency, UTI episodes) and see them over time.
4. Get honest, referenced education on options — non-hormonal moisturizers/lubricants first, then **local vaginal estrogen** (incl. its general safety profile and the breast-cancer nuance → clinician).
5. Learn pelvic-floor awareness and self-care as *education*, not prescription.
6. **Prepare to have the conversation** — a script and a visit-prep summary so she can actually raise it.
7. Do all of this in a mode discreet enough for a shared household.

**Success = she goes from "I just have to live with this" to (a) understanding it's common and treatable, and (b) walking into a clinician visit with the words ready and a symptom timeline in hand — instead of suffering silently or collecting antibiotics that never address the cause.**

---

## B. Needs & questions (voice-of-user)

Mined from menopause communities (r/Menopause, r/Menopause-adjacent forums, menopause charities' patient stories), app-store reviews, and the qualitative barriers literature (REVIVE surveys; female-sexual-health communication studies — see Sources). Paraphrased to avoid quoting individuals; themes are strongly and repeatedly attested.

**On "is this normal / just aging?" (the core misattribution):**
- "I thought dryness and painful sex was just part of getting old and I had to accept it. Nobody told me it's treatable."
- "The hot flashes went away but this got worse every year. Is that normal?"
- "Why did no one warn me this happens after menopause?"

**On saying it out loud (the hardest part):**
- "I've been to the doctor three times this year and never managed to bring it up. How do I even start the sentence?"
- "I was too embarrassed to describe it. I need words to use."
- "My doctor never asks and I never tell. Years have gone by."

**On the urinary / recurrent-UTI connection (the missed link):**
- "I keep getting UTIs since menopause — are these connected to the dryness?"
- "I feel like I always need to pee and it burns, but my urine test came back clear."
- "Three courses of antibiotics and it keeps coming back. Is something else going on?"

**On treatment — moisturizers, lubricants, vaginal estrogen:**
- "What's the difference between a lubricant and a moisturizer, and which do I need?"
- "Is vaginal estrogen safe? I'm terrified of hormones after everything I've read."
- "I had breast cancer and was told no estrogen ever — is that actually true for the vaginal kind?"
- "It changed my life and I'm angry it took years to find out about it."

**On sex, intimacy & the widowed/not-active case:**
- "I've started avoiding my husband. It's hurting our marriage and I can't explain why."
- "I'm not even sexually active — does that mean I just live with the burning?"

**On privacy & discretion (MENA-amplified):**
- "I would never have anything on my phone that names this."
- "This is 'ayb' to talk about — even with a doctor, even with my daughters."

**Top recurring questions Femio must answer in-product:**
1. Is dryness / burning / painful sex after menopause normal — and is it treatable? (Yes and yes.)
2. Are my recurrent UTIs and urinary urgency part of the same thing? (Often — GSM.)
3. Why does this get worse instead of better, unlike hot flashes?
4. What are moisturizers vs lubricants, and when is each used?
5. What is local vaginal estrogen — is it safe, and is it different from HRT? What if I've had breast cancer?
6. What is pelvic-floor physiotherapy and could it help?
7. How do I actually raise this with my clinician without dying of embarrassment?

---

## C. Competitor teardown

**GSM is a structural whitespace.** Menopause apps center on vasomotor symptoms (hot flashes/night sweats), mood, and sleep; the *genitourinary* domain — dryness, painful sex, urinary urgency, recurrent UTIs — is barely covered anywhere as a first-class, trackable, education-led module. Cycle trackers ignore it (wrong life stage). UTI products are commerce-driven and urinary-only. Sexual-wellness apps touch dryness/pain but are pleasure-framed, English-first, and not menopause-grounded. Nothing serves a discreet, Arabic-first, postmenopausal user who needs stigma-free GSM education + symptom tracking + the conversation-starter to seek care.

| App / product | Model / price | GSM depth (dryness/pain) | Urinary / recurrent-UTI coverage | Vaginal-estrogen education (incl. safety + cancer nuance) | Conversation-starter / visit-prep | Discretion | Gap Femio exploits |
|---|---|---|---|---|---|---|---|
| **Balance** (Newson Health) | Freemium; ~£8.99/mo / ~$98.99/yr advanced | Symptom list *includes* vaginal dryness/libido, but GSM not a dedicated depth module | Minimal | HRT-forward content; local-estrogen touched but not a structured safety explainer | Downloadable Health Report (good) | Standard | Dedicated GSM module (dryness+urinary+UTI), vaginal-estrogen safety+cancer-survivor explainer, discreet mode, Arabic-first |
| **Caria** | Freemium; ~$78/yr | CBT/symptom tracking; GSM not a focus | Minimal | Educational, light on GSM specifics | Coaching-led | Standard | GSM-specific tracking + conversation scripts; discreet mode; MENA sensitivity |
| **Health & Her** | Freemium; ORCHA-rated | Broad symptom toolkit incl. pelvic-floor; GSM under-developed | Minimal | Educational | Assessments | Standard | Structured GSM symptom + UTI-recurrence tracking, vaginal-estrogen safety literacy, RTL |
| **Clue / Flo (peri/meno modes)** | Freemium | Symptom tag at best; cycle/fertility DNA | Almost none | Thin | None GSM-specific | Flo carries **FTC (2021) + class settlement (2025)** trust damage | Purpose-built GSM layer; privacy-by-design; uncertainty-honest; discreet |
| **Uqora / UTI-supplement brands** | Supplement commerce | None (not GSM) | UTI prevention, commerce-biased; misses the estrogen/GSM cause | None | None | Consumer brand | Neutral, non-commercial content that connects recurrent UTI → GSM → clinician (incl. vaginal estrogen as UTI-prevention education) |
| **Sexual-wellness apps (Rosy/Ferly/Emjoy)** | Subscription | Dryness/pain touched, pleasure-framed | None | Light | Light | Announce themselves on home screen | Menopause-grounded GSM clinical framing, urinary coverage, discreet cover, Arabic-first |
| **Evvy** | At-home test + telehealth, ~$99–129, US-only | Vaginal-microbiome depth; some menopause content | Some | Some | Some | Discreet packaging; paid test | Free, global, web-first *education + tracking* that decides when to seek care — not a paid test kit |

**Cross-cutting failures Femio targets:**
1. **The genitourinary half is invisible.** Menopause apps optimize for hot flashes and mood; they under-serve dryness, painful sex, and especially the **urinary/recurrent-UTI** dimension of GSM — the exact cluster this persona lives with.
2. **"Just aging" goes uncorrected.** No app leads with the single most important message: this is common, progressive, and **treatable** — reframing it away from inevitable decline.
3. **No vaginal-estrogen safety literacy.** Users are terrified of "hormones" and don't know local vaginal estrogen has a favourable safety profile distinct from systemic HRT, or that **breast-cancer survivors may have options via shared decision-making** — a huge unmet education need.
4. **The conversation is never scaffolded.** The hardest part is saying it out loud; no competitor builds a conversation-starter/script as a first-class feature.
5. **No discreet, Arabic-first, MENA-sensitive option** for a topic that is heavily silenced.
6. **Trust.** Post-Flo, a user will not hand *this* data to an ad-funded app.

*[NEEDS SOURCE] — competitor prices/ratings/settlement dates are from secondary/marketing sources; verify before any public claim.*

---

## D. Clinical grounding (cited)

> Framing discipline: everything below is **wellness education, symptom tracking, and screening**, with consistent "discuss with your clinician" routing. Femio never says "you have GSM," never prescribes or doses, and never frames a treatment as a recommendation. Medication content (local vaginal estrogen, DHEA, ospemifene, moisturizers/lubricants) is educational only.

**What GSM is.** Genitourinary syndrome of menopause (GSM) is the 2014 consensus term (replacing "vulvovaginal atrophy / atrophic vaginitis") for the collection of **genital, sexual, and urinary** symptoms caused by declining estrogen after menopause. It encompasses vaginal **dryness, burning, irritation, and itching**; sexual symptoms of **lack of lubrication, discomfort/pain (dyspareunia), and impaired function**; and urinary symptoms of **urgency, frequency, dysuria (burning), and recurrent urinary tract infections** [The Menopause Society (NAMS) 2020 GSM Position Statement; NCBI StatPearls; Cleveland Clinic; Johns Hopkins].

**Prevalence — extremely common.** GSM affects a large majority of postmenopausal women; reported prevalence ranges **~27% to ~84%**, commonly cited as affecting roughly **half or more of postmenopausal women** (often summarised as ~50–84% symptomatic) [NAMS 2020 GSM Position Statement; NIH/MedlinePlus; NCBI StatPearls]. It is under-recognized and under-treated.

**Progressive, not self-resolving.** Unlike vasomotor symptoms (hot flashes/night sweats), which typically improve over time, **GSM is chronic and progressive and usually worsens without treatment**; symptoms are unlikely to improve spontaneously [NAMS 2020; Mayo Clinic; University Hospitals; AUA/SUFU/AUGS 2025]. This is a core Femio teaching — it reframes "just live with it" into "this gets worse untreated, and it's treatable."

**Massively under-reported and under-treated (the barrier this persona embodies).** In the multinational **REVIVE surveys**, only about **25% of women with GSM symptoms had discussed them with a healthcare provider**, discussions were mostly **patient-initiated** (clinicians rarely raise it), only ~**21% had been clinically diagnosed**, and only ~**24% had ever used any treatment**; in the Pan-Asian REVIVE survey only ~**35%** were even aware GSM is a recognized condition. Documented barriers are **embarrassment**, believing it is a normal/inevitable part of aging, and the belief that the topic is inappropriate to raise [European REVIVE, Nappi et al.; Pan-Asian REVIVE; J Women's Health barriers review]. This directly validates Femio's **conversation-starter + visit-prep** emphasis.

**Treatments (EDUCATIONAL framing only — Femio never prescribes, recommends, or doses).**
- **First-line, non-hormonal:** over-the-counter **vaginal lubricants** (used at the time of sex, for friction) and **vaginal moisturizers** (used regularly, every few days, for ongoing hydration) — these are *different products with different jobs* and are recommended first-line for milder symptoms [NAMS 2020; NHS/menopause charities; Mayo Clinic]. Regular sexual activity and adequate arousal also support tissue health [NAMS 2020].
- **Local (vaginal) estrogen** — a mainstay for women who need more than non-hormonal options; available as cream, tablet/insert, or ring. It restores vaginal tissue and is highly effective for dryness, dyspareunia, and urinary symptoms [NAMS 2020; AUA/SUFU/AUGS 2025; Mayo Clinic].
- **Other prescription options** — vaginal **DHEA (prasterone)** inserts and oral **ospemifene** (a SERM, indicated for dyspareunia) [NAMS 2020].
- **Systemic HRT vs local:** GSM alone is generally treated with *local* therapy; systemic HRT is not required for isolated genitourinary symptoms [NAMS 2020].

**Local vaginal estrogen — general safety profile (educational).** Low-dose **local** vaginal estrogen produces minimal systemic absorption and has a **favourable safety profile** distinct from systemic hormone therapy; it is **not** required to be combined with a progestogen for endometrial protection at standard low doses, and does not carry the same systemic risk framing as oral/transdermal HRT [NAMS 2020 GSM Position Statement]. *Femio explains what it is and its general safety framing, always routing the decision to a clinician; never a recommendation to start.*

**Breast-cancer-survivor nuance (→ B19; oncology-aware).** For women with a history of estrogen-dependent breast cancer and bothersome urogenital symptoms, **non-hormonal therapies (moisturizers/lubricants) are first-line**. **ACOG (Committee Opinion / Clinical Consensus)** states that if non-hormonal options fail, **low-dose vaginal estrogen may be considered after discussion of risks and benefits** — including for those on **tamoxifen** — and, for those on **aromatase inhibitors**, only after **shared decision-making between the patient, her gynecologist, and her oncologist**, at the lowest effective dose for a limited time. Current evidence does not show a clear increase in recurrence risk with vaginal estrogen, but the decision is individualized and **must involve her oncology team** [ACOG, Treatment of Urogenital Symptoms in Individuals With a History of Estrogen-Dependent Breast Cancer; ACOG Committee Opinion 659]. *Femio presents this strictly as education + "this is a decision to make with your oncologist and gynecologist together."*

**Recurrent UTIs & the urinary link (→ B10).** GSM thins and alters genitourinary tissue and vaginal flora, contributing to **urinary urgency, frequency, dysuria, and recurrent UTIs** (recurrent UTI = ≥2 in 6 months or ≥3 in 12 months). The **AUA/SUFU/AUGS 2025 GSM Guideline** and the **AUA/CUA/SUFU recurrent-UTI guideline** state that in peri-/postmenopausal women with recurrent UTIs and GSM, clinicians **should recommend local low-dose vaginal estrogen to reduce the risk of future UTIs** (Moderate Recommendation; Grade B), absent contraindication [AUA/SUFU/AUGS 2025 GSM Guideline; AUA/CUA/SUFU Recurrent UTI Guideline 2019/2025]. *Femio frames this as education explaining why a clinician might discuss vaginal estrogen for recurrent UTIs — never as a self-treatment instruction. UTIs require clinician/urine-test evaluation.*

**Pelvic-floor awareness (→ B12).** Pelvic-floor physiotherapy can help sexual pain, urinary symptoms, and pelvic-floor coordination and is an evidence-supported route often used alongside GSM treatment [AUA/SUFU/AUGS 2025; ACOG]. **Safety nuance Femio must teach: for tight/hypertonic pelvic floors, generic Kegel *strengthening* can worsen symptoms — relaxation/"down-training" may be what's needed, and only a clinician/physiotherapist can tell which** (inherited from B12).

**Red flags requiring clinician evaluation (educational routing, never triage).** **Any postmenopausal vaginal bleeding** (never assume it is GSM — always warrants prompt clinician assessment); UTI with **fever, flank/back pain, or blood in urine** (possible upper-UTI); symptoms not resolving; or uncertainty about the cause [Mayo Clinic; AUA; NAMS]. Postmenopausal bleeding in particular must **never** be attributed to dryness by the app.

**Femio scope guardrail restated:** all of the above is **education, screening, and tracking**, with "discuss with your clinician" routing. Femio does not diagnose GSM, does not prescribe or dose any product (moisturizer, lubricant, vaginal estrogen, DHEA, ospemifene), never tells a breast-cancer survivor whether to use estrogen, and is not contraception.

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to trust and switch.**
1. **GSM mode + Discreet mode.** Opt-in mode surfacing GSM education, symptom logging, and conversation-prep; paired with **Discreet mode** (neutral app name/icon option, neutral notification text with no intimate words, quick-hide/blur, optional PIN/biometric). Defaulted on for Arabic/MENA locales, user-confirmable. On surfaces visible without unlocking, no explicit terms.
2. **"It's common, progressive & treatable — not just aging" reframing layer.** The first thing she sees: validation that this is normal to experience, extremely common, gets worse untreated, and is treatable. Directly counters the misattribution that keeps her silent.
3. **Discreet GSM symptom tracker** — dryness, burning/irritation/itch, **pain with sex** (present/absent, entry vs deep, severity), **urinary symptoms** (urgency, frequency, dysuria), and **UTI episode log** with recurrence counter — logged quickly, low-cringe, viewable together over time.
4. **Conversation-starter + visit-prep pack (flagship for F6).** Ready-to-use opening sentences ("I've been having vaginal dryness and discomfort since menopause and I'd like to talk about it"), a checklist of what to mention, and an exportable/printable discreet symptom timeline + questions. The hardest part is saying it out loud — this feature exists to make that possible.
5. **Referenced, medically-reviewed treatment-options education** — moisturizers vs lubricants (what each is for), **local vaginal estrogen** (what it is, forms, its general safety profile, that it differs from systemic HRT), DHEA/ospemifene, pelvic-floor physio — grade 6–8, Arabic-first + EN/FR/ES, all "discuss with your clinician."
6. **Recurrent-UTI awareness + routing** — recurrence counter (≥2/6mo or ≥3/yr), education that recurrent UTIs can be part of GSM and that a clinician may discuss vaginal estrogen for prevention; urinary red-flag box.
7. **Vaginal-estrogen safety explainer, incl. breast-cancer-survivor nuance** — the general low-risk framing of local estrogen, and the oncology-aware path (non-hormonal first; vaginal estrogen only via shared decision-making with the oncology team) → routes to **B19**.
8. **Privacy-by-design, hardened** — special-category data; no ad/analytics-SDK access; local-first where feasible; granular consent; full export/delete; discreet notifications by default.

**P1 — strong differentiators.**
9. Pelvic-floor & self-care awareness — relaxation/breathing basics, relaxation-vs-strengthening (Kegel-harm caution), lubricant/moisturizer literacy — education, routed to a pelvic-floor physiotherapist for a real plan (inherited from B12).
10. Cause-clarity content — GSM vs infection (BV/yeast/UTI) vs other causes; "these can overlap; only a clinician/test can confirm" (bridges B10).
11. Intimacy & relationship overlay — that avoidance and strain are common; optional, non-judgemental partner-education content she can *choose* to share (scoped, revocable); the not-sexually-active case explicitly validated (GSM still matters day-to-day).
12. Life-stage-aware skins — surgical/induced onset (from **F4**, abrupt/severe), postmenopause continuity (from **F2**).

**P2 — depth / retention.**
13. Trend insight — descriptive correlations ("your dryness and pain-with-sex logs track together"; "UTI episodes cluster over the past 6 months") — never causal/diagnostic.
14. Treatment-response journal (educational) — if a clinician has started her on a moisturizer/lubricant/vaginal estrogen, log symptom response over time to bring to review — a bring-to-clinician artifact, never dosing.
15. Guided relaxation/breathing audio (discreetly titled) as self-care/awareness.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **This is common, treatable, and not "just aging"** — sets the tone: GSM affects most postmenopausal women, worsens untreated, and has effective options; you are not broken or alone.
2. **What is GSM?** — plain-language explanation of the genital + sexual + urinary cluster and the estrogen link; why it replaced "vaginal atrophy."
3. **Vaginal dryness, burning & irritation** — what causes it, that it's present with or without sex, and what helps.
4. **Why sex hurts after menopause (dyspareunia)** — the entry-burning pattern, why it happens, that it's very treatable; avoidance is common and understandable (bridges B12).
5. **The urinary side of GSM — urgency, frequency & recurrent UTIs** — why urinary symptoms and repeat UTIs can be part of the same thing; why a clinician might discuss vaginal estrogen for UTI prevention; upper-UTI red flags (bridges B10).
6. **Moisturizers vs lubricants 101** — the difference, when to use each, practical and non-judgemental (first-line, non-hormonal).
7. **Understanding local vaginal estrogen (education only)** — what it is, forms (cream/tablet/ring), how it differs from systemic HRT, its general safety profile — plain language, clear non-prescription disclaimer, "discuss with your clinician."
8. **Vaginal estrogen if you've had breast cancer** — non-hormonal first; the ACOG shared-decision-making path with your **oncologist + gynecologist**; that this is a decision to make *with your team* (bridges B19). Reassuring, never directive.
9. **Your pelvic floor & GSM** — what pelvic-floor physiotherapy is, relaxation vs strengthening (why Kegels can backfire), when to see a physiotherapist (bridges B12).
10. **Is it GSM, or an infection?** — GSM vs BV/yeast/UTI overlap; when to get checked; "only a clinician/test can confirm" (bridges B10).
11. **Talking to your clinician — the words to use** — opening sentences, what to describe, how to advocate if dismissed, what a first conversation is like; discretion-aware and MENA-sensitive.
12. **Intimacy, your partner & you** — that changes and avoidance are common; communication basics; the not-sexually-active case (GSM still deserves care); optional couples content.
13. **Myths vs evidence** — "it's just old age," "nothing can be done," "vaginal estrogen is dangerous like HRT," "if I'm not having sex it doesn't matter," "UTIs are just bad luck."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, discreet-mode-safe titles/thumbnails, and trauma-/shame-sensitive wording.

---

## G. Tools, logs & alerts (compliant framing)

**Logs (all optional, discreet, toggleable)**
- GSM symptom log: dryness, burning/irritation/itch (severity), **pain with sex** (present/absent, entry vs deep, severity), impact-on-daily-life flag.
- Urinary log: urgency, frequency, dysuria (burning); **UTI episode records** (date, clinician-confirmed y/n, treatment taken — educational record, resolution date) → recurrence counter.
- Treatment-response journal (educational): moisturizer/lubricant/vaginal-estrogen/DHEA/ospemifene use *as entered by the user*, plus symptom response — bring-to-clinician artifact, **no dosing, no recommendation**.
- Optional private notes; optional user-entered clinician note/urine-test result (entry only, no interpretation).

**Tools**
- **Conversation-starter generator** — offers ready opening sentences + a "what to mention" checklist, tailored to her logged symptom cluster; discreet.
- **Discreet visit-prep generator** — one-tap export/print: symptom timeline + urinary/UTI-recurrence summary + questions + "what a work-up may involve," with a neutral filename.
- **Recurrence counter** — rolling-window UTI episode count against the educational threshold → clinician-check prompt.
- **Pattern insight** — descriptive correlations only ("appears associated with," never "caused by," never "you have GSM").
- **Screeners (framed as screening, not diagnosis):**
  - GSM symptom-pattern check → "These are common signs to discuss; this is a screening tool, not a diagnosis. GSM is common and treatable — consider talking to a clinician." + resources.
  - Recurrent-UTI check → routes to clinician-check prompt + visit-prep when threshold crossed.

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL, discreet-mode copy)**
- Gentle "worth discussing" nudge for persistent GSM symptoms → "Ongoing dryness/discomfort is common and treatable — here's how to raise it." Never alarmist.
- Recurrent-UTI-threshold clinician-check prompt (educational; explains why recurrence and GSM may be linked and why a clinician might discuss vaginal estrogen).
- **Red-flag box** (education only, not triage): **any postmenopausal vaginal bleeding** → "This should always be checked with a clinician — it should not be assumed to be dryness"; UTI with fever/flank pain/blood in urine → "seek care" messaging + saved contact as education. Logs stay raw.
- Optional treatment-review nudge (if on clinician-started therapy) — "prepare for your review"; never dosing.
- **Never:** "you have GSM/atrophy/a UTI"; never names a product/dose to take; never tells a breast-cancer survivor to use or avoid estrogen (always → oncology team); never a disease-prevention or contraception claim; never partner-visible alerts.

**Discreet-mode behavior:** notifications use neutral wording ("Femio check-in") with no intimate terms; hero/labels neutral until unlocked; quick-hide gesture; optional PIN/biometric.

---

## H. EMR / data fields (constant core + persona layer)

**Constant core (inherited — see model §3):** account/age/DOB/locale/RTL/units; consent & privacy flags (incl. `discreet_mode`, `ads_off`); life-stage/mode flag; cycle history (archived-but-reachable — she is postmenopausal); generic symptom/mood/sleep log; `meds_supplements[]`; `conditions_flagged[]` (non-diagnostic); `screener_results[]` (timestamped).

**Persona layer (F6 — GSM), additive & non-destructive:**
- `gsm_mode` flag (ON) + `discreet_mode` flag; menopause-stage hint (postmenopause / STRAW+10 +1/+2; or surgical/induced from F4).
- Genital-symptom log: dryness, burning/irritation/itch (severity), day-to-day impact flag.
- Sexual-symptom log: pain with sex (present/absent, entry vs deep, severity), avoidance flag (optional); sexually-active y/n (optional — the "not active" case still surfaces day-to-day GSM content).
- Urinary-symptom log: urgency, frequency, dysuria; **UTI episode records** (date, confirmed y/n, treatment-taken educational record, resolution) + recurrence counters (rolling 6/12-month windows).
- Treatment-response journal (educational): product type as self-entered (moisturizer / lubricant / vaginal estrogen / DHEA / ospemifene) + symptom response — entry only, no interpretation/dose.
- Context/interplay flags: `surgical_induced_flag` (→ F4 emphasis), `breast_cancer_survivor_flag` (→ B19 oncology-aware content; **never** used to make an estrogen recommendation), `pelvic_floor_flag` (→ B12), `infection_overlap_flag` (→ B10 differentiation content).
- User-entered clinician notes / urine or swab results — **entry only, no interpretation as diagnosis**.
- TTC intent flag = **false** (postmenopausal); not surfaced.

*All health fields optional, encrypted, user-deletable. This is among Femio's most sensitive data classes: no ad-SDK access, no third-party sharing, discreet-mode-protected, re-confirmed on any new sharing scope.*

---

## I. Personalization rules (wizard → home config; discreet + hidden-but-reachable)

**Entry into F6.** Reachable from multiple points, not a single branch:
- Menopause wizard branch (Q6): symptoms multi-select includes discreetly-worded "vaginal dryness / discomfort / painful sex" and "urinary urgency / repeated UTIs" ⇒ set `gsm_mode ON`.
- From **F1/F2** (peri/postmenopause) when dryness/painful-sex/urinary symptoms are logged: "Some people notice dryness or urinary changes after menopause — these are common and treatable. Want gentle info?"
- From **B10** (recurrent UTIs at 40s+ with dryness) and **B12** (menopause-related painful sex): offer the F6 route.
- From **F4** (surgical/induced) when GSM symptoms appear (often abrupt/severe).
- Searching GSM/dryness/painful-sex/UTI terms in the library offers: "Want to set up a private space for this? Discreet mode can hide it. You can undo anytime."

**On entry, offer discreet mode first** — before any content loads — explaining cover, lock, and quick-exit. Explicit, reversible confirmation (invariant §3).

**Onboarding (F6 overlay) — minimal, gentle, skippable:**
- Q: what would you like support with? (multi-select: dryness/burning · pain with sex · urinary urgency/frequency · recurrent UTIs · just exploring) ⇒ orders home modules.
- Q: any context you want me to know? (surgically/induced menopause · history of breast cancer · prefer extra-gentle content) — all optional; breast-cancer flag surfaces the B19 oncology-aware skin (never an estrogen recommendation).
- Q: are you currently sexually active? (optional — the "no" path still surfaces day-to-day GSM content; never gates).
- Q: privacy — turn on discreet mode? (default yes for this overlay / MENA locales).

**Home configuration (F6 default):**
- Hero = a calm, non-explicit "Your comfort & intimate health" card leading with **"common, treatable, not just aging"** + "understand / track / talk to a clinician" entry points. No imagery awkward on a glanced screen.
- **Conversation-starter + visit-prep pinned** (flagship).
- Cards ordered by concern selection (dryness → moisturizer/lubricant + vaginal-estrogen education; pain with sex → dyspareunia + pelvic-floor + intimacy; urinary/UTI → urinary-GSM + recurrence + red-flags; breast-cancer flag → B19-aware vaginal-estrogen explainer surfaced).
- Fertility/cycle widgets hidden (postmenopausal); reachable via "Explore other life stages."
- Nothing celebratory, nothing gamified.

**Hidden-but-reachable principle.** Femio never removes knowledge. All other content stays discoverable; F6 content is reachable from search even if the mode isn't "on." Discreet mode hides *presentation*, never *access*.

**Adaptive tuning:** repeated dryness/pain logs → raise treatment-options education + conversation-starter prominence. UTI recurrence threshold crossed → raise urinary-GSM education + recurrence-check + visit-prep. Breast-cancer flag → surface B19-aware content and route the estrogen question to the oncology team. Surgical/induced signals → F4 abrupt-onset skin. Postmenopausal-bleeding log → prominent red-flag "always get this checked" (never attributed to dryness).

---

## J. Adaptation triggers (life-stage routing)

> Inherits all **universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive test, loss → instant suppression, mood-crisis path, red-flag box, disengagement, mode-off, age-of-consent). Below are **F6-specific** transitions only. Every transition is explicitly confirmed, reversible, and data-preserving; nothing is ever deleted (archived-but-reachable).

| Trigger | System response | Route |
|---|---|---|
| **GSM symptoms first logged from peri/postmenopause** (dryness, painful sex, urinary urgency at 40s+/postmeno) | Offer GSM mode + discreet mode; lead with "common, progressive, treatable — not just aging"; surface treatment-options + conversation-starter | Enter/blend **F6** (from **F1/F2**) |
| **Recurrent-UTI threshold crossed** (≥2/6mo or ≥3/yr) | Non-alarming "many clinicians suggest a check-in — recurrent UTIs after menopause can be part of GSM; a clinician may discuss vaginal estrogen for prevention"; auto-populate visit-prep | **Blend F6 ⊕ B10**; raise clinician-routing prominence |
| **Postmenopausal vaginal bleeding logged** | Prominent educational red-flag box: "Any bleeding after menopause should always be checked with a clinician — it should not be assumed to be dryness." Log stays raw; never triage/diagnosis | Stay F6 (emergency messaging, content only) |
| **Urinary red-flag** (fever, flank/back pain, blood in urine) | Prominent educational "seek care now" box + saved contact as education | Stay F6 (content only) |
| **Breast-cancer-survivor flag set / oncology history** | Surface non-hormonal-first content + ACOG shared-decision-making explainer; **never** recommend or discourage estrogen — route the decision to the oncology + gynecology team | **Blend F6 ⊕ B19** (oncology-aware); estrogen question → clinician team |
| **Surgical / induced menopause** (oophorectomy, chemo/radiation, GnRH — often abrupt, severe GSM) | Recognize abrupt/earlier onset; sensitive framing; surface GSM + earlier-onset content | **Route from / blend F4** |
| **Painful-sex / pelvic-floor focus** | Dyspareunia + pelvic-floor awareness (relaxation vs strengthening; Kegel-harm caution); intimacy/relationship content; strong routing to pelvic-floor physio | **Blend F6 ⊕ B12** |
| **Symptom pattern suggests infection vs GSM uncertainty** (itch + discharge, or acute urinary symptoms) | Non-diagnostic "is it GSM or an infection?" education; "these overlap; only a clinician/test can confirm"; UTIs need urine test | **Offer B10** content route (education only) |
| **Treatment started by clinician** (user logs moisturizer/lubricant/vaginal estrogen) | Surface treatment-response journal + "prepare for your review"; educational adherence support, never dosing | Stay F6, review framing |
| **Mood screen trends low / crisis flag** | Universal handler: mental-health module + localized crisis resources (chronic discomfort + intimacy loss + shame carry real distress) | Stay F6 + mental-health routing (inherited universal) |
| **User toggles off GSM / discreet mode** | Revert presentation; **preserve all history** (archived-but-reachable); re-confirm nothing is exposed | Generic menopause band / F2 / Z1 |

**Blending note (per §8):** F6 is a menopause-track persona that composes with overlay layers (B10 recurrent-UTI, B12 pelvic-floor/pain, B19 survivor) rather than replacing them. Most-acute-emphasis wins the hero; safety/red-flag and clinician-routing layers are **unioned, not double-counted** (e.g. urinary red-flags from B10 merge with GSM red-flags). The **breast-cancer-survivor path always defers the estrogen decision to the oncology team** — Femio never resolves it.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis (of GSM, atrophy, dyspareunia, UTI), no treatment, no dosing, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **"Not just aging" reframing must stay educational** — normalize + inform ("common, progressive, treatable; discuss with a clinician"), never "you have GSM." Screeners always return "This is a screening tool, not a diagnosis — discuss with a clinician."
- **Medication content (local vaginal estrogen, DHEA/prasterone, ospemifene, moisturizers/lubricants):** educational context only — what it is, forms, general safety framing, why a clinician might discuss it; **no recommendation, no dosing, no "take/start/stop this."** Clear non-prescription disclaimer + clinician routing everywhere.
- **Vaginal-estrogen safety + cancer nuance:** explain the general low-risk framing of *local* estrogen and that it differs from systemic HRT (educational, cite NAMS 2020). For breast-cancer survivors: present non-hormonal-first + ACOG shared-decision-making, and **always route the estrogen decision to the oncology + gynecology team** — never recommend or discourage it. (→ B19.)
- **UTI framing:** recurrent UTIs need clinician/urine-test evaluation; vaginal estrogen for UTI prevention is presented as *what a clinician may discuss* (cite AUA/SUFU/AUGS 2025), never a self-treatment instruction.
- **Pelvic-floor / dilator content:** awareness only; teach relaxation-vs-strengthening + Kegel-harm caution; route real plans to a pelvic-floor physiotherapist (inherited B12).
- **Red flags:** **any postmenopausal vaginal bleeding** → always-check-with-clinician (never attributed to dryness); UTI with fever/flank pain/blood in urine; non-resolving symptoms → educational "seek care," never triage.
- **Discretion / cultural sensitivity (MENA/Arabic-first):** Discreet mode (neutral labels + notifications, quick-hide, optional PIN) available and defaulted-on for Arabic/MENA locales; no intimate terms on any surface visible without unlocking; respectful, "ayb"-aware, dignity-first copy; the not-sexually-active and widowed cases explicitly validated. Arabic-first with RTL QA. Avoid explicit branding/imagery.
- **Mental health:** chronic discomfort, intimacy loss, and shame carry real distress; crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** GSM/sexual/urinary data = special-category and among the most sensitive; explicit granular consent, purpose limitation, **no ad-SDK/third-party sharing** (post-Flo distrust); local-first where feasible; full export/delete; no partner/employer/insurer visibility; re-confirm scope on any new sharing. DPIA + data-mapping before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** framing as tracking/education (not diagnosis/device); discreet-mode app-naming must comply with store policies — legal review before store submission.
- **[NEEDS SOURCE]** flags: (a) exact GSM prevalence figure to cite publicly (range 27–84% varies by study/definition — pick a specific citation); (b) competitor prices/ratings/settlement dates (secondary/marketing sources); (c) precise REVIVE percentages by survey/region (cite the specific European vs Pan-Asian paper); (d) any public vaginal-estrogen-and-breast-cancer risk figure — cite ACOG consensus directly and keep framing conservative.

---

## Sources

**Clinical — Tier 1 (NIH / NIA / NHS / MedlinePlus / OWH / gov & major consumer-clinical):**
- [Vaginal dryness / atrophy — MedlinePlus (NIH)](https://medlineplus.gov/ency/article/000892.htm)
- [Menopause — MedlinePlus (NIH)](https://medlineplus.gov/menopause.html)
- [Sex and Menopause: Treatment for Symptoms — National Institute on Aging (NIA)](https://www.nia.nih.gov/health/menopause/sex-and-menopause-treatment-symptoms)
- [Menopause and your health — Office on Women's Health](https://womenshealth.gov/menopause/menopause-symptoms-and-relief)
- [Genitourinary Syndrome of Menopause — StatPearls (NCBI Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK559297/)
- [Vaginal atrophy — Diagnosis & treatment — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/vaginal-atrophy/diagnosis-treatment/drc-20352294)
- [Vaginal dryness after menopause: how to treat it? — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/menopause/expert-answers/vaginal-dryness/faq-20115086)
- [Vaginal Dryness: Causes, Symptoms & Treatment — Cleveland Clinic](https://my.clevelandclinic.org/health/symptoms/21027-vaginal-dryness)
- [Genitourinary Syndrome of Menopause — Johns Hopkins Medicine](https://www.hopkinsmedicine.org/health/expert-qa/genitourinary-syndrome-of-menopause)
- [Urinary Tract Infections — MedlinePlus (NIH)](https://medlineplus.gov/urinarytractinfections.html)

**Clinical — Tier 2 (Menopause Society / ACOG / AUA-SUFU-AUGS / peer-reviewed):**
- [The 2020 Genitourinary Syndrome of Menopause Position Statement of The North American Menopause Society (PDF)](https://www.isswsh.org/images/content/2020-NAMS-GSM-Paper.pdf)
- [NAMS publishes the 2020 GSM Position Statement — summary](https://www.news-medical.net/news/20200901/NAMS-publishes-the-2020-Genitourinary-Syndrome-Of-Menopause-Position-Statement.aspx)
- [Genitourinary Syndrome of Menopause: AUA/SUFU/AUGS Guideline (2025) — American Urological Association](https://www.auanet.org/guidelines-and-quality/guidelines/genitourinary-syndrome-of-menopause)
- [The AUA/SUFU/AUGS Guideline on Genitourinary Syndrome of Menopause — Journal of Urology](https://www.auajournals.org/doi/10.1097/JU.0000000000004589)
- [Recurrent Uncomplicated UTIs in Women: AUA/CUA/SUFU Guideline (2025) — American Urological Association](https://www.auanet.org/guidelines-and-quality/guidelines/recurrent-uti)
- [Treatment of Urogenital Symptoms in Individuals With a History of Estrogen-dependent Breast Cancer — ACOG Clinical Consensus (2021)](https://www.acog.org/clinical/clinical-guidance/clinical-consensus/articles/2021/12/treatment-of-urogenital-symptoms-in-individuals-with-a-history-of-estrogen-dependent-breast-cancer)
- [ACOG Committee Opinion No. 659 — The Use of Vaginal Estrogen in Women With a History of Estrogen-Dependent Breast Cancer — PubMed](https://pubmed.ncbi.nlm.nih.gov/26901332/)
- [Genitourinary Syndrome of Menopause: Management Strategies for the Clinician — Mayo Clinic Proceedings](https://www.mayoclinicproceedings.org/article/S0025-6196(17)30639-0/fulltext)
- [Genitourinary Syndrome of Menopause MenoNote — The Menopause Society (PDF)](https://menopause.org/wp-content/uploads/for-women/MenoNote-GSM.pdf)

**Under-reporting / barriers / patient journey (REVIVE surveys, communication):**
- [Vulvar and vaginal atrophy in four European countries — European REVIVE Survey — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4819825/)
- [Genitourinary syndrome of menopause in five Asian countries — Pan-Asian REVIVE survey — PubMed](https://pubmed.ncbi.nlm.nih.gov/28453308/)
- [Female Sexual Health: Barriers to Optimal Outcomes and a Roadmap for Improved Patient–Clinician Communications — Journal of Women's Health](https://www.liebertpub.com/doi/10.1089/jwh.2018.7352)
- [Vaginal Moisturizers and Vaginal Lubricants To Ease Dryness — Breastcancer.org](https://www.breastcancer.org/treatment-side-effects/vaginal-dryness/moisturizers-lubricants)
- [The Surprising Reason You Should Try Vaginal Estrogen (UTIs) — AARP](https://www.aarp.org/health/conditions-treatments/vaginal-estrogen-utis-menopause/)

**App-quality evidence & competitor / app landscape:**
- [A systematic review of menopause apps — BMC Women's Health (2023) / PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10542256/)
- [Menopause apps: personal health tracking, empowerment — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12034958/)
- [Balance — Newson Health menopause app](https://www.balance-menopause.com/balance-app/)
- [Caria — perimenopause/menopause app](https://www.caria.health/)
- [Health & Her — menopause app](https://healthandher.com/en-us/pages/menopause-perimenopause-app)
- [Evvy — Vaginal Microbiome Test & Care](https://www.evvy.com/)

**Cross-persona references (internal):** `09_MASTER_ADAPTATION_MODEL.md`; `F1_perimenopause.md`; `F2` (postmenopause); `F4` (surgical/induced menopause); `B10_vaginal_pelvic_health.md` (recurrent UTI); `B12_sexual_wellbeing.md` (painful sex / pelvic floor); `B19` (cancer survivors — oncology-aware).
