# Persona F5 — Premature / early menopause (living through menopause a decade+ before peers)

> Femio product + UX research spec. Scope guardrail: **wellness / education / tracking ONLY.** Femio never diagnoses, treats, prevents, or contracepts. Screeners (incl. MRS) are framed as *"screening — discuss with your clinician."* HRT/MHT content is **educational, never prescriptive** — no dose, no start/stop/switch instruction. Femio does not run, order, or interpret medical tests, and **never labels a user "in menopause," "postmenopausal," or "infertile."** Menopause stage is a **clinician's determination**; Femio helps a user who *already has, or is being evaluated for,* early/premature menopause understand it, protect her long-horizon health, and be held steady through grief.
> Persona code: **F5** · Track: **F (menopause / hormone-health lifespan)** · Bands: **premature menopause <40**, **early menopause 40–45** · Last research pass: 2026-07-21
> **Sibling persona (read together):** **C16 (POI / early ovarian decline <40)** is the **fertility-track lens** on early ovarian failure — fertility-first, dual-need, donor-egg/family-building, grief-of-an-assumed-future. **F5 is the menopause-track lens on the same underlying event** — hormone-health-first: long-horizon bone/CV/cognitive protection, HRT-until-natural-menopause-age, symptom management, identity/healthy-aging. A single woman <40 may be served by **either lens depending on her leading need**, and many hold both at once. The two specs are deliberately **consistent and cross-linked, with distinct emphases** — never contradictory, never duplicative. (See §J for the F5⇄C16 hand-off rules.)

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Rania," 38 (bands: **premature <40** — core 34–39, tail into 20s; **early 40–45**). |
| **Age band** | **The defining variable is *how far ahead of schedule* she is.** Menopause before 40 = **premature**; 40–45 = **early**. Average natural menopause is ~51, so she is living the transition **a decade or more before her peers.** [Office on Women's Health; NICE NG23] |
| **Stage** | Menopausal transition or post-menopause reached **young** — by natural early decline, or **abruptly** via surgery (bilateral oophorectomy → F4 origin), chemo/radiation, or POI. Often already told her periods have stopped "for good" at an age when friends are pregnant or chasing toddlers. |
| **Relationship** | Mixed: partnered, single, LGBTQ+. Family-building may be complete, in progress, foreclosed, or never-started — but for F5 the *leading* wound is usually **identity + long-term health + isolation**, not primarily the fertility question (that is C16's leading wound). |
| **Goal (top JTBD)** | *"I've hit menopause 10–15 years early. Help me protect the decades ahead — my bones, heart, and brain that now face far more time without estrogen — understand why HRT until my early 50s is about protection not just symptoms, manage symptoms no one my age talks about, and stop feeling broken, old, and completely alone among friends who are having babies."* |
| **Health literacy** | Variable and **whiplashed**. Blindsided; frequently dismissed ("you're far too young for menopause"); then handed content written for 52-year-olds that ignores the *extra decades of exposure* and the *different HRT risk/benefit* that being young creates. Needs **plain-language, referenced, uncertainty-honest** framing that centers **long-horizon protection** and **age-appropriate** reality. |
| **Tech context** | Web-first; also phone. Often arrives from a menopause app that assumes she's in her 50s (peer + content mismatch), from a cycle tracker endlessly flagging "irregular," or **from a Femio sibling state** (see origins below). |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. In many AR/MENA markets "early menopause" layers an **aging / "defective" / "no longer a real woman" stigma** on top of any fertility stigma — acute, private. Dignity paramount. |
| **Emotional state** | **Grief + identity rupture + premature-aging fear + isolation.** Nearly **1 in 3** women with premature ovarian insufficiency report depressive symptoms; drivers include younger age, symptom severity, grief, and **lack of emotional support** — and hormone therapy does *not* by itself fix mood, so psychosocial care is essential. [Menopause psychosocial literature; POI depression study] Grief here is often **disenfranchised** — a loss others don't recognize as a loss. |
| **Origins (how she reaches F5)** | **From C16** (POI, once hormone-health becomes her leading need); **from F1** (perimenopause, when early signs resolve to an unusually young transition); **from F4** (surgical/induced menopause at a young age); or via **Z1** nearest-persona match on young age + menopausal symptoms + stopped/stopping periods. |
| **What she is NOT** | Not a standard 50-something menopause user — she has **more decades of estrogen deficiency ahead**, a **different HRT risk/benefit calculus**, and an **age-mismatched peer world.** Not (primarily) a fertility-decision persona — that leading-fertility framing is **C16**. Not diagnosed *by Femio*. Not someone to be told "at least it's over" or "lucky you, no more periods." |
| **Success = she leaves us (or stays, held) because…** | She's **informed and steady** — understands her long-horizon risks and what protects her, HRT-educated and continuous (until ~natural-menopause age), symptoms managed, grief metabolized, no longer isolated (age-matched support), carrying one unbroken record that will **flow into the standard F-cohort (F2) at ~51 with no restart.** |

**Persona thesis.** F5 is the woman for whom menopause arrived **early and out of order** — and who is then handed a menopause world built entirely for women a decade or two older. Three things drive the whole spec: (1) **Long-horizon health protection is the headline, not symptom relief.** Because she loses estrogen so young, she faces **more years of exposure** and higher long-term risk to **bone, cardiovascular, and cognitive** health — so the product's center of gravity is *protecting the decades ahead*, framed as "know your risks, discuss screening," never as prevention/treatment. [Climacteric 2015 review; cardiometabolic meta-analysis; cognition review] (2) **HRT-until-natural-menopause-age is a different conversation** — for early/premature menopause, HRT is generally recommended at least until ~51 as **replacement of hormones her body would normally still make**, with a risk/benefit profile *unlike* starting HRT in one's late 50s; the "HRT causes cancer" fear she inherited from headlines mostly does not apply to her. [NICE NG23] (3) **The emotional register is grief + premature-aging + isolation among baby-having peers** — and menopause apps deepen that isolation by assuming she's 52. **Nobody** offers a referenced, age-appropriate, long-horizon-health-forward, grief-calibrated, Arabic-first companion for menopause-a-decade-early, carried on one lifelong account. That whitespace — the **menopause-track mirror of C16's fertility-track whitespace** — is F5's Femio thesis.

---

## B. Needs & questions (voice-of-user)

Mined from Daisy Network community, r/menopause (young/early-menopause threads), r/PrematureMenopause, surgical-menopause and BRCA/oophorectomy forums, and app-store reviews of menopause apps. Phrasing is representative/composite (community norms; not quoting individuals).

**"What does this mean for the rest of my life?" — the long-horizon epicenter (F5's center of gravity, distinct from C16's fertility epicenter):**
1. *"I'm 37 and postmenopausal. I'll have decades without estrogen — what does that do to my bones and heart, and what can I actually do about it?"*
2. *"Someone said early menopause raises my risk of osteoporosis and heart disease. Is that true, and how worried should I be?"*
3. *"Does going through this young affect my brain / memory / dementia risk later?"* (Handle gently, evidence-honest — see §D.)
4. *"Do I need a bone-density scan now? A heart check? At 38?"* (Awareness + "discuss screening," never a Femio order.)

**HRT — a different question than my mum's:**
5. *"Why is everyone telling me to take HRT when the news says it causes breast cancer?"* (The young-menopause risk/benefit is different — see §D.)
6. *"How long am I supposed to stay on HRT — forever?"* (Generally until ~51, the average natural-menopause age, then reassess.)
7. *"Is HRT for me the same as HRT for a 55-year-old?"* (No — for her it's replacing hormones she'd normally still have.)
8. *"My doctor offered HRT or the pill — what's the difference for someone my age?"*

**Symptoms, at the "wrong" age:**
9. *"Hot flushes and night sweats at 36 — and everyone assumes I'm hungover or stressed."*
10. *"Vaginal dryness, no libido, brain fog in my 30s. I feel 60 in a 34-year-old's body."*
11. *"How do I even bring this up with friends who are on maternity leave?"*

**Identity, grief & isolation (the emotional core):**
12. *"I feel like my body skipped a decade. I'm mourning the version of me that was supposed to still be young."*
13. *"Everyone I know is having babies or complaining about being 30. I have literally no one who gets this."*
14. *"People say 'lucky you, no more periods' and it's like a slap. This is a loss."*
15. *"Is it normal to grieve this even though I wasn't planning more kids?"* (Yes — disenfranchised grief.)

**Origin-specific (surgical / induced / from POI):**
16. *"They took my ovaries during my hysterectomy and I woke up in full menopause overnight — no warning, no gradual anything."* (F4 origin — abrupt, often more severe.)
17. *"Menopause from chemo — is this permanent or might it come back?"* (Sometimes reversible — route to clinician.)
18. *"I have POI and I've made my peace with the fertility part — now I just need to look after my hormones and health for the next 20 years."* (The C16→F5 hand-off in her own words.)

**Reach / trust / privacy:**
19. *"Every menopause app is built for women in their 50s. The community, the content, all of it — I don't fit."*
20. *"Why is the good info always $80–100 a year?"*
21. *"I don't want my symptom and hormone data sold."* (Post-Flo distrust.)

**Anti-needs / trust-breakers (churn drivers):**
- Being told (or having an app imply) she's *just* like a 52-year-old menopause user — content, community, and HRT framing that ignore her extra decades and different risk/benefit.
- "At least it's over," "no more periods, lucky you," "at least you already have kids" — toxic positivity that erases grief.
- A cycle tracker flagging "late/irregular" indefinitely with no explanation or off-ramp.
- Being dismissed ("too young for menopause") — she's had enough of that.
- Fertility-first framing pushed at her when her leading need is health/identity (that's the C16 lens — offer it, don't force it).
- Privacy creep on hormone + reproductive data.

**Feature requests recurring in reviews/forums:**
- A **long-term-health module** (bone/CV/cognition) that treats her extra decades as the headline, framed protectively.
- **HRT-for-early-menopause education** that explains *why until ~51* and *why her risk/benefit differs*, plus an HRT log — educational, never a dose.
- **Age-appropriate symptom tracking + MRS**, validating that these symptoms are real at her age.
- **Age-matched community / support** — the antidote to "everyone I know is 30 and pregnant."
- **Grief support built for premature-aging / disenfranchised loss**, not generic sadness cards.
- A **healthy-aging framing** — "you have a long, good life to protect," not "you're old now."
- A clean **bridge to C16** for fertility questions, and forward continuity into **F2** at ~51.

---

## C. Competitor teardown

Focused on the **age-mismatch gap**: menopause apps are overwhelmingly designed, contentned, and *communitied* for women in their late 40s–50s. They may get the hormone/symptom layer roughly right, but they (a) ignore the **extra decades of exposure** that make long-horizon bone/CV/cognitive protection the headline for F5, (b) apply an **older-menopause HRT risk/benefit** framing that misleads a 35-year-old, and (c) surround her with **50+ peers**, deepening the very isolation she came to escape. General cycle trackers actively *hurt* her (endless "irregular" flags). POI charities own the young-onset literacy but aren't apps.

| App | Built for | Long-horizon health (bone/CV/cognition) | HRT framing for a *young* user | Age-appropriateness / community fit | Where it fails F5 |
|---|---|---|---|---|---|
| **Balance** (Newson Health) | Peri/menopause 40s–50s; symptom + med tracking; GP-ready report; free core | General bone/heart education, but framed for standard-age menopause, not "decades of extra exposure" | Strong HRT content, but perceived **HRT-forward** and pitched at typical-age risk/benefit; little "why until ~51 / why your risk differs" for the young | Content + community skew 50+; a 35-year-old is an outlier | No young-onset long-horizon framing; no age-matched peers; no explicit early-vs-standard HRT distinction; not Arabic-first |
| **Caria** | Peri/menopause coaching, CBT, symptom score; ~$78/yr after trial | Lifestyle/symptom focus; not long-horizon-risk-led | Educational, coaching-led; standard-age lens | Reviews show **younger users do arrive** (e.g., a 38-yo with premature menopause) but the app isn't *designed* for them — mixed-age community by accident, not design | Age-appropriateness is incidental, not intentional; paywalled depth; no bone/CV/cognition-forward protection model; not Arabic-first |
| **Perry** | Peri-focused, community-first, expert content | Educational | Educational | **Strong peer community — but peers skew 40s+**; young-onset women remain a minority | No young-onset health-protection model, no MRS/structured tracker, no Arabic-first, no forward-continuity account |
| **Health & Her** | Life-stage-adaptive self-care toolkit (CBT, breathing, pelvic floor); ORCHA-rated | Self-care, not risk-protection-led | Educational | Standard-age framing | No long-horizon protection headline, no age-matched support, no MRS scoring, not Arabic-first |
| **Midday / Midi-style** | Menopause care/coaching for midlife women | General | Clinician-linked (geo-limited) | Explicitly **midlife** branding — the mismatch is in the name | Assumes midlife; no young-onset lens; geo-locked; not Arabic-first |
| **Daisy Network / POI charities (web)** | Peer support + referenced POI/early-menopause info | **Best-in-class young-onset literacy**, incl. HRT-until-natural-age and long-term health | Excellent, young-onset-correct | **Best age-matched community** for young onset — but it's a website/charity, not a personalized tracking app | Not an app: no logs, no home state, no MRS trend, no Arabic-first localization, no lifelong account — a content/community peer, not a product competitor |
| **Flo / Clue (menopause modes)** | Mass-market cycle + added peri/menopause features | Thin | Thin/education-light | No young-onset pathway; she's a data anomaly | Endless "irregular" flags with no off-ramp; **Flo FTC (2021) + class settlement (2025)** trust damage; no long-horizon or age-appropriate model |

**Cross-cutting failure #1 — the age-mismatch gap (F5's core wedge).** The whole menopause-app category is calibrated to the **standard-age** user. For a woman a decade+ early, that produces three compounding mismatches: **content** (ignores extra decades of exposure and the different HRT calculus), **community** (surrounds her with 50+ peers, deepening isolation), and **framing** (a "winding down" life-stage tone when she needs a "protect the long road ahead" one). Femio's wedge is an **explicitly young-onset, long-horizon-health-forward, age-matched** experience.

**Cross-cutting failure #2 — quality (inherited from F1's teardown).** A **systematic review of 28 menopause apps (BMC Women's Health, 2023)** found only ~**22.7%** used evidence-based information and medical-professional involvement in only ~**27.3%** — the category is broadly thin and low-quality. Femio's referenced, medically-reviewed, grade 6–8, multilingual content is a direct wedge, *amplified* for F5 by young-onset-correct clinical framing.

**Cross-cutting failure #3 — reach & price.** The strongest apps gate depth at ~$80–100/yr; the deep-and-free options are rare. Femio's free, reachable core + Arabic-first/RTL opens an underserved market — the young-onset slice of which is served by *no one*.

---

## D. Clinical grounding (cited)

> All claims below are **patient-education framing.** Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, order tests, or interpret results — it explains, in plain language, what early/premature menopause *is*, what a clinician-directed evaluation and management involve, and routes every specific concern to "discuss with your clinician." **Menopause stage, its cause, HRT, and every lab value are context for a clinician conversation — never a Femio verdict, label, or dose.**

**Definitions (the band that defines F5):**
- **Premature menopause** = menopause before **age 40**; medically overlapping with **primary ovarian insufficiency (POI)**. **Early menopause** = menopause between **40 and 45**. Natural menopause averages **~51**, so F5 is living the transition **a decade or more early.** [Office on Women's Health — Early or premature menopause; NICE NG23]
- **Relationship to C16/POI (kept consistent, distinct lens):** the *<40 premature* band is the **same underlying event** C16 covers; **C16 is the fertility-track lens** (fertility grief, donor-egg decisions, dual-need), **F5 is the menopause-track lens** (long-horizon health, HRT-until-natural-age, identity/healthy-aging). POI's caveat that **ovarian function can fluctuate and ~5–10% conceive** still holds and is cross-linked — so F5 must **never** state "you can't get pregnant," and any fertility question routes to the **C16 lens** and a clinician. [NICE NG23; C16 spec §D]

**Causes (answer "why me?" — category-level, never assigned):**
- **Spontaneous/idiopathic** (often no identified cause), **genetic** (e.g., Turner syndrome, FMR1/fragile-X premutation), **autoimmune**, and **iatrogenic** — **surgical** (bilateral oophorectomy, an **F4** origin: abrupt, "overnight," often **more severe** symptoms), **chemotherapy** (esp. alkylating agents), or **pelvic radiation** (sometimes reversible). Risk factors include family history, smoking, low BMI. [Office on Women's Health; surgical-menopause literature; cancer-treatment menopause resources] *Femio explains categories and why a clinician tests for them; it never assigns a cause and handles any genetic result with elevated privacy (see C16 §H/§K).*

**Long-horizon health — the F5 headline (decades more low-estrogen exposure):**
- **Overarching:** long-term consequences of premature/early menopause include adverse effects on **cognition, mood, cardiovascular, bone, and sexual health, and increased early-mortality risk** — because these women spend **more years of life without the protective effects of estrogen.** Hormone therapy lessens *some* but not all of these risks. [Climacteric 2015 — *Long-term health consequences of premature or early menopause*; PubMed 25845383]
- **Bone:** estrogen is central to bone maintenance; early loss accelerates bone-density decline, raising **osteopenia/osteoporosis and fracture** risk over the extra decades. [Climacteric 2015; bone-health literature]
- **Cardiovascular:** premature/early menopause is associated with **higher long-term risk of cardiovascular and cardiometabolic disease** (including earlier heart disease and stroke). [Cardiometabolic systematic review & meta-analysis, PMC10072266]
- **Cognition:** early estrogen loss is associated with **higher risk of cognitive decline/dementia**; some evidence frames HRT before ~60 as a possible "window of opportunity" for brain health — evidence is **evolving and must be presented honestly, not as a promise.** [Cognitive-decline review, PMC10095144]
- *Femio framing:* **"know your long-term risks, and discuss screening (e.g., bone-density/DXA, lipids, blood pressure) with your clinician"** — education and awareness only, **never** a prevention/treatment claim, never a Femio-ordered test.

**HRT/MHT for early/premature menopause — a *different* conversation (load-bearing, distinct from older-menopause HRT):**
- **HRT is generally recommended at least until the average age of natural menopause (~51)**, whether or not she has symptoms — as **replacement** of hormones her body would normally still be producing, to protect **bone and cardiovascular** (and likely brain/genitourinary) health and relieve symptoms. [NICE NG23; Office on Women's Health]
- **The "HRT causes cancer" headlines she inherited largely do not apply to her:** per NICE, the risks associated with HRT are **relevant to women over the natural-menopause age**, not to younger women taking it as replacement; and overall, HRT is **unlikely to affect life expectancy.** The young-onset risk/benefit is therefore **more favorable** than the older-initiation picture — a crucial correction Femio surfaces as education. [NICE NG23]
- **HRT vs the combined pill:** both can supply estrogen; some clinicians use the **combined oral contraceptive** as an alternative source, especially for younger women — differences are a **clinician conversation.** [NICE NG23; C16 spec §D]
- **Not contraception (inherited caveat):** HRT is **not a contraceptive**, and in POI-band F5 (<40) ovulation can occur intermittently, so **pregnancy remains possible** — Femio states this plainly and routes to a clinician (see C16 §D/§K). [NICE NG23]
- **HRT does not fix mood by itself:** psychosocial/emotional support is a **separate, necessary** strand — HRT is not a substitute for grief and mental-health care. [POI depression literature] *Femio never states a dose, never says start/stop/switch; always "discuss with your clinician."*

**Symptoms (the standard menopause set, at a young age):**
- Hot flushes/night sweats (VMS), irregular or stopped periods, sleep disruption, mood changes (anxiety/irritability/low mood), cognitive "brain fog," **vaginal dryness / genitourinary syndrome, low libido, dyspareunia**, joint aches, palpitations, headaches. **Surgical/induced onset is typically abrupt and often more severe** than gradual natural transition. [Office on Women's Health; surgical-menopause literature] Femio tracks these as **awareness**, feeding the **MRS** as a *screening/tracking* instrument (11 items, 3 domains, total 0–44) — never a diagnosis (MRS detail inherited from F1 §D).

**Psychosocial impact (grounds the support features):**
- Early/premature menopause carries **grief, identity rupture, a sense of premature aging, and isolation** — often **disenfranchised grief** (a loss others don't recognize). **Nearly 1 in 3** women with POI report depressive symptoms; drivers include **younger age at diagnosis, symptom severity, fertility grief, and lack of emotional support**, and **HRT does not by itself curb depression** — underscoring the need for dedicated psychosocial care. Being **out of sync with peers** (friends still in reproductive years) is a specific, repeatedly-named isolation driver. [Premature-menopause psychosocial review, PubMed 21854296; POI depression study; C16 spec §D]

*Femio applies all of this as **educational routing and organization**, always ending "discuss with your clinician" — never a diagnosis, cause assignment, result interpretation, HRT dose, or menopause/fertility verdict.*

**[NEEDS SOURCE VERIFICATION AT PUBLISH]** — pin at publish, with medical-review sign-off and per-locale check: (a) exact age-band definitions and the HRT-until-~51 wording to **live NICE NG23 / Office on Women's Health / Menopause Society** primary text; (b) the cognition/"window of opportunity" claim — present as *evolving evidence*, not established prevention; (c) any HRT dose examples — keep as *"what guidelines describe,"* never instruction; (d) prevalence and cardiometabolic/fracture magnitude figures against live Tier-1/Tier-2 sources; (e) POI intermittent-function / ~5–10% conception figure (shared with C16).

---

## E. Feature set (prioritized)

*Builds an **F-cohort hormone-health spine tuned for young onset** — long-horizon protection at the center, age-appropriate throughout. **Bold = F5-defining.** Symptom/MRS/HRT-log/cycle-uncertainty mechanics are **inherited from F1**; F5 re-weights them around long-horizon health, HRT-until-natural-age, and identity/isolation.*

**P0 — Must-have (defines the persona; ship first):**
1. **Long-horizon health-protection module (the F5 centerpiece)** — bone, cardiovascular, and cognitive health framed around *decades of extra estrogen-deficient exposure*: what the long-term risks are, what protects (movement, nutrition, not smoking, and **"discuss screening — DXA/lipids/BP — with your clinician"**), presented **protectively, never alarmist, never as prevention/treatment.** This is F5's headline and the clearest divergence from a standard-age menopause app.
2. **HRT-for-early-menopause education + log (educational)** — *why* HRT until ~51 (replacement, not just symptom relief), *why her risk/benefit differs* from older-menopause HRT (the "HRT causes cancer" correction), HRT-vs-pill, duration/reassessment — plus an HRT log for continuity/visit-prep. **Never a dose, never start/stop/switch, always "discuss with your clinician."**
3. **Age-appropriate symptom tracker + MRS (inherited F1 mechanics)** — the full menopausal symptom set logged and viewed together, MRS trend framed strictly as screening — validating that these are **real at her age**.
4. **Identity, grief & premature-aging support layer (built for THIS grief)** — cards tuned to **disenfranchised, premature-aging, out-of-sync-with-peers** grief; a mood/anxiety **screener** (screening-framed + localized crisis resources); **healthy-aging reframe** ("a long life to protect," not "you're old"). Explicitly avoids "at least it's over" / "lucky you, no periods."
5. **Age-matched community / support surface** — the antidote to "everyone I know is 30 and pregnant": young-onset-matched, moderated, referenced, guarded against false-hope/false-doom. (Directly answers the competitor age-mismatch gap.)
6. **Clinician visit-prep pack** — exportable timeline: symptom/MRS trend + HRT log + **long-term-health/screening questions** + cycle history — tuned for the young-onset conversation (and, where relevant, a *second* fertility conversation via C16).
7. **POI-aware / uncertainty-first cycle mode (inherited F1/C16)** — no "late"/"irregular" shaming; degrades gracefully to symptom + trend; carries the *not-contraception + pregnancy-still-possible* caveat for the <40 band.
8. **Validation + young-onset orientation** — names and normalizes the experience ("menopause can come early; this is real; you are not broken or alone"), and offers the **C16 fertility lens** as a reachable companion rather than forcing it.
9. **Privacy-by-design** — hormone/reproductive (and any genetic) data special-category; no ad-SDK/third-party sharing; export/delete. **Free, reachable core** — depth not paywalled to exclusion.

**P1 — Strong differentiators (fast follow):**
10. **Surgical/induced-onset framing (F4 origin)** — recognizes **abrupt, often more severe** onset; skips gradual-transition narrative; earlier/heavier emphasis on bone/CV + HRT education, sensitively.
11. **Clinical-results home (self-entered, entry-only, never interpreted)** — DXA/bone density, lipids, BP, FSH/E2 trends (young-onset context) — category explainers, genetic results elevated-privacy (per C16).
12. **CBT-based programs** (inherited F1) for VMS, sleep, low mood/anxiety — NICE/NAMS-grounded, self-help framing; especially relevant given HRT doesn't fix mood.
13. **Healthy-aging content track** — nutrition, strength/weight-bearing movement, sleep, cardiometabolic basics — framed as protecting a long life, not managing decline.
14. **Partner/family explainer (optional, scoped)** — helps her not-yet-menopausal-age peers/partner understand; consent-gated, revocable.
15. **Timeline / continuity view** — one portable narrative that carries her into **F2** at ~natural-menopause age with zero restart.

**P2 — Nice-to-have / later:**
16. Stigma-aware AR/MENA content (early-menopause "aging/defective" shame de-escalation; privacy/dignity).
17. Journal / decision-notes space (identity and health decisions are heavy).
18. Region-aware cost/coverage education (HRT access, DXA screening) — education only.
19. Oncofertility / cancer-survivorship cross-link for iatrogenic onset.

**Explicitly OUT of scope for F5 (guardrail):**
- **Diagnosing or labeling** "menopause," "postmenopausal," "premature/early menopause," "infertile," or a cause. Femio serves a user who *has, or is being evaluated for,* a clinician's determination; it **never** declares it.
- Ordering, running, or **interpreting** any test (DXA/FSH/E2/lipids/BP) — categories explained; only her clinician interprets *her* results.
- Any **HRT dose, start/stop/switch instruction**, or "this regimen is right for you." Education only.
- Any **contraception / "safe day"** framing — *and* for the <40 band Femio actively states the opposite (pregnancy remains possible; HRT ≠ contraception).
- **Fertility-decision management** (donor-egg/IVF cycle support) — that leading-fertility work is the **C16 lens** (offer/bridge, don't absorb).
- Any **prevention or treatment claim** for osteoporosis, heart disease, or dementia — long-horizon content is *awareness + "discuss screening,"* only.

---

## F. Content modules

Medically reviewed, referenced, grade 6–8, all four locales, RTL-first for AR. Each card carries citations, a medical-review byline + date, and "not medical advice / discuss with your clinician." Content is **young-onset-correct** — never lifted from standard-age menopause copy.

- **"Menopause came early — what this means for you"** — premature (<40) vs early (40–45) vs standard-age; the decade+ difference; that it's real and not "too young"; the healthy-aging reframe. [Office on Women's Health; NICE NG23]
- **"Protecting the decades ahead — bones, heart, and brain"** (the flagship) — why more years of low estrogen matter; what protects; **"discuss screening (DXA, lipids, BP) with your clinician"**; framed protectively, evidence-honest on cognition. [Climacteric 2015; PMC10072266; PMC10095144]
- **"HRT and early menopause — why, how long, and why your risks are different"** — replacement-until-~51 rationale, the young-onset risk/benefit correction (the "HRT causes cancer" myth-bust *for her age*), HRT-vs-pill, reassessment — **no doses as advice.** [NICE NG23]
- **"Menopause symptoms in your 30s and 40s"** — VMS, sleep, mood, brain fog, vaginal dryness/GSM, libido — that they're real at her age; coping + when to seek care.
- **"Why did this happen? — causes of early menopause"** — spontaneous/idiopathic, genetic (Turner, FMR1 — gently, with family implications per C16), autoimmune, surgical/chemo/radiation; category-level, no cause assignment. [Office on Women's Health]
- **"Surgical and treatment-induced menopause"** (F4-origin) — the abrupt, often-more-severe onset; what's different; sensitive support. [surgical-menopause literature]
- **"The grief no one prepared you for"** — disenfranchised/premature-aging grief, identity, isolation among baby-having peers; coping; when to seek mental-health support; de-escalating "at least it's over." [PubMed 21854296; POI depression study]
- **"You're not alone — finding people who get it"** — age-matched community, Daisy Network and peer support; countering isolation. [Daisy Network]
- **"Fertility questions with early menopause"** — brief, honest, and **hands off to the C16 lens** for anyone whose leading need is family-building; states the *pregnancy-still-possible / not-contraception* caveat for the <40 band. [C16 spec; NICE NG23]
- **"Getting the most from your appointment"** — visit-prep for the young-onset conversation (symptoms + MRS + HRT + long-term-health/screening questions); advocating if dismissed.
- **Stigma-aware module (AR/MENA-first)** — early-menopause "aging/defective" shame de-escalation; privacy and dignity.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable — the **standard F-cohort (F2) menopause library** she'll grow into, the **C16 POI/fertility library**, contraception *education* — one search/tap away. F5 never feels boxed in.

---

## G. Tools, logs & alerts (compliant framing)

**Logs (inputs):**
- **Cycle/bleed log in uncertainty-first / POI-aware mode** — no "late"/"irregular" language; trend + range; days-since-last-bleed for the 12-month milestone; the *not-contraception* caveat for <40.
- **Menopausal-symptom tracker (inherited F1 34+ set)** — VMS, night sweats, sleep, mood, cognitive/brain fog, vaginal dryness/GSM, libido, joints, palpitations, headaches — awareness only, viewable together.
- **HRT/MHT log (educational)** — regimen name, form (oral/transdermal/vaginal/pill), start/stop dates *as the user records them*, symptom response — continuity/visit-prep artifact, **never a Femio-prescribed schedule or dose.**
- **Clinical-results (self-entered, entry-only, never interpreted)** — **DXA/bone-density, lipids, BP**, FSH/E2 (young-onset context); trend views for awareness, never scoring. Genetic results (if any) elevated-privacy per C16.
- Lifestyle logs (movement, sleep, nutrition, alcohol/caffeine) for healthy-aging + trigger insight.
- Mood/anxiety screener history (scores + dates, screening-only).
- `emotional_state_tags` incl. **premature_aging_distress / disenfranchised_grief / isolation / identity_rupture / hrt_decision / long_term_health_anxiety** (drive support-card selection).

**Tools:**
- Long-horizon health-protection module + DXA/lipid/BP trend (awareness + "discuss screening").
- HRT-for-early-menopause education + log (never a dose).
- Menopausal-symptom tracker + MRS screener (3 domain sub-scores + total 0–44, trend) → screening-framed output.
- Uncertainty-first / POI-aware cycle mode.
- Age-matched community/support surface (moderated, referenced).
- Identity/grief support cards + healthy-aging reframe.
- Clinician visit-prep generator (long-term-health-aware; one-tap export/print).
- Timeline/continuity view; PDF/image export.
- Mood/anxiety screener (PHQ-2/GAD-2-style) → screening-framed output + localized crisis resources.

**Alerts / nudges (opt-in, tone-calibrated, dismissible, revocable, RTL-aware):**
- "It might be worth discussing **hormone therapy and bone/heart health** with your clinician — here's what the guidelines describe for early menopause." (awareness routing, **never** "start HRT")
- "New DXA / lipid / BP result to log? Add it to see your trend and read what this category means." (awareness, never interpretation)
- **12-month amenorrhea milestone** (inherited F1) → "Clinically this is often when menopause is confirmed — a good time to check in with your clinician." (educational; can route toward F2 framing over time — see §J)
- Identity/grief/isolation support cards matched to current `emotional_state_tag`; age-matched-community nudge.
- Screening follow-up (re-check mood in N weeks) + crisis resources on any low screen.
- **Never:** "you are in / have reached menopause"; "you are postmenopausal / infertile"; "you can't get pregnant"; any HRT dose/start/stop; contraception/"safe day" language (and for <40, actively state the opposite — pregnancy remains possible, HRT is not contraception); never a disease-prevention claim for bone/heart/brain; never "you're too young for this to be real"; never "at least it's over."

**Mandatory compliance wording on relevant surfaces:**
- *"Femio helps you understand and organize your care — it does not diagnose menopause, order tests, interpret your results, or prescribe hormone therapy. Only your clinician can do that."*
- On long-horizon-health surfaces: *"Early menopause can raise long-term risks to bone, heart, and brain health because of more years with less estrogen. This is general information about risks and screening to discuss with your clinician — not a diagnosis, prediction, or prevention plan for you."*
- On HRT surfaces: *"For early or premature menopause, hormone therapy is often used until around the average age of menopause as replacement. The risks you may have read about mostly apply to older women — but any doses or regimens shown are what guidelines describe, for education only. Never start, stop, or change hormone therapy without your clinician."*
- For the <40 band, on fertility/HRT surfaces: *"Pregnancy is still possible before 40, and hormone therapy is not a contraceptive. If you want to avoid pregnancy, or if you hope to conceive, discuss it with your clinician."*
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine, per Master Model §3):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags, account mode/state.
- `cycle{period_start/end, cycle_length_history[], flow[]}`; `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (non-diagnostic); `content_history[]`, `screener_results[]` (timestamped, non-diagnostic).

**F5 persona-specific (F-cohort menopause layer, young-onset weighted; bold = F5 delta):**
- `menopause_onset_band` = `premature_<40` | `early_40_45` — **user-reported context, never a Femio label**; drives young-onset content weighting and the C16-lens offer.
- `onset_type` = `spontaneous` | `surgical` (F4 origin) | `chemo_radiation` | `poi_C16_origin` — user-recorded; drives abrupt-onset framing where relevant; no cause assignment.
- **`long_term_health[]`** {test_type: DXA_tscore | lipids | BP, value, date} — trend-enabled (bone/CV monitoring awareness); the F5-headline data class.
- **`menopausal_symptoms[]`** {symptom, severity_self_report, date} + **`mrs_records[]`** {item scores, 3 domain sub-scores, total 0–44, date} — awareness/screening only, no severity "diagnosis."
- **`hrt_log[]`** {regimen_name, form, start_date, stop_date, symptom_response, source_note} — user-recorded, educational, **never a Femio-prescribed schedule or dose.**
- `ovarian_labs[]` {FSH | E2, value, unit, date} — entry-only, young-onset context, **never used to declare menopause.** (Shared shape with C16.)
- `genetic_results[]` {karyotype | FMR1, result_note, date} — **elevated-privacy class**, entry-only, no interpretation (per C16 §H/§K).
- `fertility_intent` = `not_applicable` | `resolved` | `still_a_question` — if `still_a_question`, **offer the C16 lens** (fertility-first), never absorb it.
- `emotional_state_tags[]` (**premature_aging_distress / disenfranchised_grief / isolation / identity_rupture / hrt_decision / long_term_health_anxiety** / waiting) — drives support-card selection.
- `amenorrhea_counter` (days since last bleed) → 12-month milestone + eventual F2 framing.
- `appointments[]`, `visit_questions[]`, `visit_prep_exports[]`, `mood_screen_history[]`, `partner_link_id` + `partner_scope` + `partner_consent_ts`.

*Data-minimization & heightened sensitivity: hormone + reproductive (+ any genetic) data is special-category health data with **compounded** stigma (young-infertility + "early-aging/defective"); encrypted, user-deletable, never shared with ad networks/analytics; strict retention on uploaded lab PDFs/genetic reports; genetic data = highest tier. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into F5 — young age + menopause context is the pivot; inherits Master Model §4 Q6 menopause branch):**
1. Menopause branch (Q6) → symptoms / cycles stopping or stopped / **age <45**. Age **<45** is the fork from a standard-age F1/F2 user.
2. "Has a clinician talked to you about early or premature menopause, primary ovarian insufficiency, or menopause at a young age?" → *diagnosed* / *being evaluated* / *not sure* — **all enter F5 young-onset framing; Femio never confirms it itself.**
3. "How did this begin?" (gradually / after surgery to remove ovaries / after chemo or radiation / I have POI) ⇒ sets `onset_type`; surgical/chemo ⇒ abrupt-onset framing (F4 origin).
4. "What matters most to you right now?" (my long-term health / my symptoms / understanding what this is / how I'm feeling about it) ⇒ sets which module *leads* the home (all remain present).
5. "Are fertility or family-building still an open question for you?" → *yes* ⇒ **offer the C16 fertility-first lens** (reachable companion, not forced); *no / resolved* ⇒ keep F5 hormone-health-forward. **Optional, skippable, grief-safe.**
6. "Are you currently using HRT/MHT?" → yes ⇒ surface HRT log (educational); no ⇒ surface balanced HRT-for-early-menopause education (the *why-until-~51* + risk-correction), never push.
7. "Involve a partner?" → optional scoped partner mode.
8. Consent & privacy choices (hormone + reproductive + any genetic notice; genetic = highest tier).

**Home config for F5:**
- **Hero = long-horizon health-protection card** (per Q4 default for most F5 users) — "protect the decades ahead: bones, heart, brain" + any DXA/lipid/BP trend + "discuss screening." New/shocked users default to the **"menopause came early — what this means" orientation** as hero.
- Secondary = menopausal-symptom log + MRS trend; HRT-for-early-menopause education/log card; identity/grief support card matched to current `emotional_state_tag`; age-matched-community surface.
- **Uncertainty-first / POI-aware cycle mode ON by default:** no "late"/"irregular" nudges; trend + symptom view; *not-contraception* caveat for <40.
- **De-emphasize** any fertile-window/TTC hero (misleading; and if fertility is her leading need, that's the **C16 lens**) — keep reachable, always with the caveat.
- **Hidden-but-reachable:** full lifespan library, the **F2 standard-menopause library** (she'll grow into it), the **C16 POI/fertility library**, contraception *education* — one search/tap away.

**Adaptive tone:** validating, steady, honest, **grief-aware, healthy-aging-framed, never doom, never toxic-positive.** Never "you're old now," never "at least it's over," never "you're too young for this to be real," never a menopause/fertility verdict. Escalate emotional-support prominence around new onset, HRT decisions, premature-aging distress, and isolation; surface mental-health module + resources if mood screens trend low. Lead with long-horizon *protection* (agency), not decline.

---

## J. Adaptation triggers (state transitions)

*Inherits all **universal events** from the Master Adaptation Model §6 (positive test, loss, mood-crisis, red-flag, disengagement, mode-off, age-of-consent). Listed below are **F5-specific** transitions, plus the explicit **F5⇄C16 lens** and **→F2** continuity this persona owns.*

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Arrives at early/premature menopause** | wizard: age <45 + menopause context / clinician conversation; or **from C16, F1, or F4**; or **Z1** nearest-persona match on young age + menopausal symptoms + stopped/stopping cycles | Activate F5 young-onset F-cohort: long-horizon health hero, HRT-for-early-menopause education, MRS/symptom log, uncertainty-first cycle mode, identity/grief support, age-matched community. **Femio never confirms the diagnosis.** | **Become F5** (this persona) |
| **From C16 — fertility resolved / hormone-health becomes leading need** | user in C16 records fertility path chosen (donor/adoption/child-free peace) *or* shifts focus to long-term hormone/bone/CV health | **Warm hand-off C16→F5** (same account, no restart): re-weight home to long-horizon health + HRT-until-natural-age + identity/healthy-aging; C16 fertility layer stays **reachable**, not erased. | **C16 → F5** (menopause-track lens) |
| **Fertility becomes an open question again** | user sets `fertility_intent = still_a_question` or engages fertility content | **Offer the C16 fertility-first lens** (reachable companion), carrying all data; never absorb fertility-decision work into F5. State *pregnancy-still-possible / not-contraception* for <40. | **Offer C16** (fertility-track lens) |
| **From F1 — early signs resolve to unusually young transition** | F1 user under ~45 with stopping cycles / young-onset signals | Re-layer F1 perimenopause into F5 young-onset framing (long-horizon health + HRT-until-natural-age emphasis added). | **F1 → F5** |
| **From F4 — surgical/induced menopause at young age** | user reports oophorectomy/chemo/radiation onset while young | Recognize **abrupt, often more severe** onset; skip gradual-transition narrative; earlier/heavier bone/CV + HRT education, sensitively. | **F4 → F5** (young-onset overlay) |
| **HRT education engaged / user starts HRT (reports)** | user logs an HRT regimen or opts into HRT education | Raise HRT-for-early-menopause + long-horizon-health modules; enable HRT log (continuity, **never a dose**); note HRT doesn't fix mood → keep grief/mental-health support present. | Stay F5, raise HRT + long-horizon emphasis |
| **New DXA / lipid / BP result logged** | user adds a long-term-health result | Show category explainer + trend (awareness); surface "discuss screening/results with your clinician." **Never interpret.** | Stay F5, raise long-horizon health |
| **Reaches ~natural-menopause age (~51)** | age crosses ~average-menopause band | **The bridge completes:** offer graceful continuity into the **standard F-cohort (F2, menopause/postmenopause)** on the **same account, no restart**; HRT conversation shifts from "replacement-until-natural-age" toward standard menopause framing (education); all history carried. | **→ F2** (standard menopause/postmenopause) |
| **Comorbidity signals** (thyroid, diabetes, CVD, autoimmune, prior high-risk) | user records a condition | Layer condition-aware content + symptom-overlap explainers; keep young-onset core. | **Route to / blend F3** (menopause + comorbidity) |
| **12 consecutive months amenorrhea logged** | amenorrhea counter | Milestone prompt: clinically often when menopause is confirmed → "discuss with your clinician"; shift cycle UI to trend-only; keep long-horizon-health emphasis. | Stay F5 (or begin F2 framing if age ~51) |
| **Grief spike / premature-aging distress / isolation** | `emotional_state_tag` or mood screen trends low | Universal handler + F5 grief layer: disenfranchised/premature-aging content, healthy-aging reframe, age-matched community, mental-health module + localized crisis resources; screening-framed. | Stay F5, raise grief/isolation support |
| **Spontaneous positive pregnancy test** (<40 band, the ~5–10% path) | `hpt` positive or user confirms | Universal positive-test handler; offer **Pregnancy mode, PAI-flagged**; suppress "you can't conceive" entirely; carry hormone context; note HRT must be reviewed with clinician (education, never a stop-instruction). | **D-track, PAI-flagged** |
| **Pregnancy loss reported** | user reports loss | Universal loss handler: instant suppression of celebratory nudges, Gentle Mode, grief resources, retain data; layer with F5 grief sensitivity. | **E6 grief** (young-onset-grief-aware) |
| **Mood screen trends low / crisis flag** | screener threshold crossed | Universal handler: mental-health module + crisis resources; screening-framed. (F5 baseline sensitivity is high — young-onset depression risk.) | Stay F5 |
| **Taking a break / user toggles off** | inactivity / "pause" / mode-off | Universal handler: pause nudges; preserve all data; gentle wellness content; revert to generic logic on toggle-off. | Retain / generic band |

*All routes preserve data continuity (one account) and always end with clinician-referral language — never a diagnosis, cause assignment, result interpretation, HRT dose, or menopause/fertility verdict. **F5 is the menopause-track anchor of the young-onset story:** it receives from C16/F1/F4, offers the C16 fertility lens for anyone whose leading need is family-building, and flows continuously into **F2** at ~natural-menopause age — the same account carrying her across the whole hormone-health lifespan without a restart.*

---

## K. Compliance flags

1. **No diagnosis / treatment / prevention; no test ordering or interpretation; no prescribing (highest-priority guardrail).** Femio serves a user who *has, or is being evaluated for,* a **clinician's** determination of early/premature menopause. It **never** declares menopause, postmenopause, infertility, or a cause; never interprets *her* DXA/FSH/E2/lipids/BP; **never states an HRT dose or start/stop/switch.** Diagnosis-related fields are **user-reported, entry-only** with category-level education. **[NEEDS SOURCE — confirm current app-store medical-claims + medical-device scope wording at ship.]**
2. **Long-horizon health = "know your risks, discuss screening," never prevention/treatment.** Bone/CV/cognition content is **awareness + routing** only — no claim that Femio (or any action within it) prevents or treats osteoporosis, heart disease, or dementia. Cognition/"window of opportunity" framing presented as **evolving evidence**, not established fact. [Climacteric 2015; PMC10072266; PMC10095144]
3. **HRT content is education, never a prescription — with the young-onset correction stated honestly.** Femio explains the replacement-until-~51 rationale and that the older-menopause HRT risks *mostly don't apply to her age*, but **never** states a dose or start/stop/switch; always "discuss with your clinician." The HRT log is a *bring-to-clinician* artifact. [NICE NG23]
4. **HRT is not contraception; pregnancy remains possible (<40 band).** For premature-band F5, Femio must state that **pregnancy remains possible** and **HRT is not a contraceptive** — the inverse of a "safe day" claim — routing both pregnancy-avoiders and pregnancy-seekers to a clinician (and to the C16 fertility lens). [NICE NG23; C16 §D/§K]
5. **Consistency with C16 (sibling-persona discipline).** F5 and C16 describe the **same underlying event through different lenses** — F5 must never contradict C16's POI facts (intermittent function, ~5–10% conception, HRT-not-contraception) and must **hand fertility-leading users to the C16 lens** rather than duplicating or overriding it. Cross-links are explicit and bidirectional. [C16 spec]
6. **MRS & all screeners:** always return "This is a screening tool, not a diagnosis — discuss your results with a clinician." Never output "You are in / postmenopausal" or "You have depression."
7. **Genetic data = highest sensitivity tier** (if karyotype/FMR1 recorded): elevated privacy, explicit granular consent, strict retention, user-deletion, **never** shared with ad networks/analytics (per C16). **[NEEDS SOURCE — align to Femio privacy skill / DPA at implementation.]**
8. **Hormone + reproductive data privacy (elevated + compounded stigma).** Learn from **Flo (FTC 2021 + class settlement 2025)** and **Premom (FTC 2023)**: no third-party sharing; data minimization; explicit, revocable consent; strict retention/deletion. **[NEEDS SOURCE — FTC primary docs.]**
9. **GDPR / PDPL — special-category (+ any genetic) data.** Lawful basis + explicit consent; DSAR/export/delete; regional data-residency (esp. AR/MENA); DPIA before launch. **[NEEDS SOURCE — align to Femio privacy skill / DPA.]**
10. **Age is context, never a verdict.** "Under 45" routes to young-onset education; it never triggers a Femio declaration of menopause. No countdowns, no "you're old now," no score.
11. **Emotional safety (premature, disenfranchised grief + isolation + premature-aging distress).** Young-onset carries elevated depression risk (worse with younger age, symptom severity, and lack of support; HRT does *not* fix mood). Tone avoids doom, toxic positivity, "at least it's over," and "lucky you, no periods"; healthy-aging reframe; age-matched support to counter isolation; crisis resources on any low mood screen. [PubMed 21854296; POI depression study]
12. **Bridge/continuity discipline.** C16→F5, F1→F5, F4→F5 inbound and **F5→F2** at natural-menopause age must be **additive, reversible, one account, zero data loss** (Master Model §1–§3) — no restart, no re-diagnosis, full history carried; the C16 fertility lens stays reachable when offered.
13. **Stigma-aware localization.** AR/MENA-first framing de-escalates early-menopause "aging/defective/no-longer-a-real-woman" shame; maximum privacy/dignity by default.
14. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1/Tier-2 primary sources, grade 6–8, localized in 4 languages with RTL parity. Numeric/definitional claims (age bands, HRT-until-~51 wording, cognition framing, prevalence, cardiometabolic/fracture magnitudes, ~5–10% conception) re-verified against live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH]**
15. **App-store health-app policy.** Meet Apple/Google health-app & medical-disclaimer requirements; no over-claiming (no menopause-predictive or HRT-prescriptive claims); legal review before store submission. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

**Clinical — Tier 1 (NIH / NIA / NHS / MedlinePlus / gov):**
- [Early or premature menopause — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/menopause/early-or-premature-menopause)
- [Menopause — MedlinePlus (NIH)](https://medlineplus.gov/menopause.html)
- [Symptoms of menopause and perimenopause — NHS](https://www.nhs.uk/conditions/menopause-and-perimenopause/symptoms/)
- [Menopausal symptoms and cancer treatment — Cancer Research UK](https://www.cancerresearchuk.org/about-cancer/coping/physically/sex/women/menopausal-symptoms)

**Clinical — Tier 2 (NICE / Menopause Society / ESHRE / Daisy Network / peer-reviewed):**
- [Menopause: identification and management — NICE guideline NG23 (incl. POI/early-menopause HRT-until-natural-age)](https://www.nice.org.uk/guidance/ng23/chapter/recommendations)
- [Best practice for HRT: unpicking the evidence — PMC (HRT until average menopause age for POI/early menopause; young-onset risk/benefit)](https://pmc.ncbi.nlm.nih.gov/articles/PMC5198659/)
- [Long-term health consequences of premature or early menopause and considerations for management — Climacteric 2015 (PubMed 25845383)](https://pubmed.ncbi.nlm.nih.gov/25845383/)
- [The risk of long-term cardiometabolic disease in women with premature or early menopause: systematic review & meta-analysis — PMC10072266](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10072266/)
- [Cognitive Decline in Early and Premature Menopause — PMC10095144](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10095144/)
- [Premature menopause: a comprehensive understanding of psychosocial aspects — PubMed 21854296](https://pubmed.ncbi.nlm.nih.gov/21854296/)
- [4 Things to Know About Early and Premature Menopause — Yale Medicine](https://www.yalemedicine.org/news/early-and-premature-menopause)
- [Bilateral oophorectomy and premature menopause — The American Journal of Medicine](https://www.amjmed.com/article/S0002-9343(05)00915-0/fulltext)
- [Loneliness and Social Isolation Can Take a Toll on Women's Cognitive Abilities — The Menopause Society](https://menopause.org/press-releases/loneliness-and-social-isolation-can-take-a-toll-on-womens-cognitive-abilities)

**Community & support (young-onset / early menopause):**
- [Daisy Network — Supporting women with Premature Ovarian Insufficiency (UK charity; young-onset community, HRT & long-term-health info)](https://daisynetwork.org/)
- [Daisy Network — About Us](https://daisynetwork.org/about-us/)
- [The Silent Grief of Premature Menopause — MQ Mental Health](https://www.mqmentalhealth.org/the-silent-grief-of-premature-menopause/)
- [Why Early Menopause Hits Hardest Emotionally — Psychiatrist.com (POI depression drivers; HRT does not curb depression)](https://www.psychiatrist.com/news/why-early-menopause-hits-hardest-emotionally/)

**App-quality evidence & competitor / app landscape (directional; verify before public claims):**
- [A systematic review of menopause apps with an emphasis on osteoporosis — BMC Women's Health (2023) / PMC10542256](https://pmc.ncbi.nlm.nih.gov/articles/PMC10542256/)
- [The 10 Best Menopause Apps — The Flow Space (Balance, Caria, Health & Her, Perry, Midday landscape)](https://www.theflowspace.com/reproductive-health/menopause/best-menopause-apps-2941944/)
- [Caria: Menopause & Midlife — App Store (incl. 38-yo premature-menopause user review = age-mismatch signal)](https://apps.apple.com/us/app/caria-menopause-midlife/id1477621356)
- [Best Perimenopause App 2026 (HRT trackers) — Go-Go Gaia](https://www.go-go-gaia.com/blog/best-perimenopause-tracking-app.html)
- Balance / Caria / Perry / Health & Her / Clue / Flo competitor detail cross-referenced from **F1 spec §C** (shared menopause-app teardown); Flo **FTC 2021 + class settlement 2025** referenced via F1 privacy sources.

**Cross-references (internal):**
- `docs/personas/C16_premature_ovarian_insufficiency.md` — **sibling persona (fertility-track lens on the same <40 event); F5 hands fertility-leading users here and inherits POI clinical facts.**
- `docs/personas/F1_perimenopause.md` — inbound origin + inherited MRS / symptom-tracker / uncertainty-first-cycle / menopause-app-teardown mechanics.
- `docs/09_MASTER_ADAPTATION_MODEL.md` — inherited invariants (§1), state object (§2), core data (§3), universal events (§6), Z1 fallback (§5), blending (§8).
- F4 (surgical/induced menopause) — inbound origin for abrupt young-onset; F2 (standard menopause/postmenopause) — forward continuity at ~51; F3 (menopause + comorbidity) — blend target.

*Community insight (Daisy Network, r/menopause young-onset threads, r/PrematureMenopause, surgical-menopause / BRCA-oophorectomy forums, menopause-app reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. Named-app young-onset gaps are directional from category knowledge and secondary sources — verify before any public claim. **[NEEDS SOURCE].** Definitional/numeric claims (age bands, HRT-until-~51, cognition/"window of opportunity," prevalence, cardiometabolic/fracture magnitude, ~5–10% conception) must be pinned to live Tier-1/Tier-2 primary text at publish, with medical-review sign-off. **[NEEDS SOURCE VERIFICATION AT PUBLISH].***
