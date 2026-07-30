# Persona B8 — Reproductive-age woman with uterine fibroids (leiomyomas / myomas)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician." Red-flag symptoms (severe/uncontrolled bleeding, symptoms of significant anemia, acute severe pelvic pain, rapid growth with weight loss) route to "seek care."
> Research date: 2026-07-18 · Persona band: B (reproductive-age) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (invariants §1, state object §2, core §3, universal events §6, Z1 §5, blending §8). Base cycle-tracking layer inherited from **B1** (general reproductive-age cycle tracking); **shares the HMB bleeding-quantification layer with B4** (heavy menstrual bleeding).

---

## A. Persona snapshot

**Who she is.** "Amira," 38. Two years ago her periods turned heavy and long, and she started feeling a constant low-belly heaviness — like she is "always a little bloated" and "carrying something." Her waistband got tighter even though her weight barely changed; a colleague asked if she was expecting. She pees constantly, gets up twice a night to go, and feels pressure and fullness when her bladder is barely half full. Some days there is a dull dragging ache low in her pelvis and pain during sex. An ultrasound for her heavy bleeding found "multiple fibroids." She was told they are benign and "we can watch them" — but nobody explained what type she has, what watching means, or what her options are if it gets worse. She is Arabic-first (also reads English), uses the web on her phone, and — as a woman of MENA background — is in a group where fibroids are more common and often more symptomatic.

**What she lives with.**
- **Heavy / prolonged bleeding** — flooding, clots, long periods (shared with B4); often the fibroid's most disruptive symptom and a driver of anemia.
- **Pelvic pressure & "bulk" symptoms** — a persistent heaviness, fullness, or dragging sensation low in the abdomen; visible abdominal swelling / "looking pregnant" when fibroids are large.
- **Bloating & bowel pressure** — abdominal distension, constipation, or rectal pressure when a fibroid presses backward.
- **Urinary symptoms** — frequency, urgency, nocturia, and a sense of incomplete emptying when a fibroid presses on the bladder (reported by a majority of women presenting for fibroid treatment).
- **Pelvic pain / dyspareunia** — cramping, a dull ache, or pain with sex; occasional acute pain (e.g., a degenerating fibroid).
- **Fatigue / anemia risk** — the downstream cost of heavy bleeding (shared with B4).
- **Fertility / pregnancy worry** — uncertainty about whether fibroids will affect conception, and what type/location means for her.
- **Diagnostic vagueness & dismissal** — "we'll watch it" with no map of what that means, what could change, or when to act.

**Core emotional drivers.** Wants to **understand what she actually has** (type, size, location, why *these* symptoms) instead of a vague "you have fibroids." Wants to **track more than bleeding** — the pressure, bloating, and bladder symptoms that generic period apps ignore entirely. Wants to know what "watchful waiting" really involves and what the **realistic options** are (from doing nothing, to medication, to procedures) — as education, not a sales funnel. Wants to be **believed and taken seriously**, especially against the backdrop that in her community heavy periods and pelvic pain get normalized ("we normalize pain").

**Jobs-to-be-done.**
1. **Track the full fibroid symptom picture** — not just bleeding, but pelvic pressure/heaviness, bloating/abdominal size, urinary frequency/urgency/nocturia, bowel pressure, and pelvic pain — over time.
2. **Quantify bleeding objectively** (product counts / PBAC-style score, clots, flooding — the B4 layer) so heavy bleeding can't be dismissed.
3. Understand **what fibroids are, and the types** (submucosal / intramural / subserosal, and why location drives which symptoms she has).
4. Understand the **treatment landscape** at an educational level — watchful waiting, medication, uterine artery embolization (UAE), myomectomy, hysterectomy — so she walks into a visit informed.
5. Understand the **fertility / pregnancy** implications of fibroids and which types matter most, without being funneled into a TTC narrative she isn't in.
6. Prepare for and get more from appointments; know which tests/imaging are standard (ultrasound, full blood count / ferritin) and track fibroid size/imaging over time.
7. Know the **red flags** that mean "seek care now" vs. "book a routine visit."

**Success = she walks into her gynecology visit with a one-page, objective summary of her bleeding *and* her pressure/bladder/pain symptoms and their trend, understands her type and options in plain language, and gets a real conversation instead of another "let's just watch it."**

---

## B. Needs & questions (voice-of-user)

Mined from fibroid communities and forums, qualitative studies with women who have fibroids (incl. Black women and Latinas on normalized pain), reviews of fibroid-tracking apps, and clinic patient-education material (see Sources). Paraphrased to avoid quoting individuals.

**On the symptoms generic apps ignore (the #1 gap):**
- "Every app tracks my bleeding but nothing lets me log the *pressure* — the heaviness and bloating that never fully goes away."
- "I need to record how many times I pee and that I'm up all night — my doctor didn't connect it to the fibroid until I said it out loud."
- "I look pregnant by the evening. I want to track my belly and the bloating, not just periods."
- "There's the bleeding, and then there's the ache and the fullness and the peeing — I want them all in one place."

**On understanding what she has:**
- "They said 'you have fibroids' and nothing else. What type? Does it matter? Why do I have these symptoms and my friend has none?"
- "Nobody explained submucosal vs. the other kinds or why mine cause so much bleeding."

**On 'watchful waiting' and options:**
- "'We'll watch it' — watch it for what? How do I know if it's getting worse?"
- "What's between doing nothing and a hysterectomy? I keep hearing about embolization and myomectomy but don't understand them."
- "I don't want my uterus removed — what preserves it? What preserves fertility?"

**On fertility / pregnancy:**
- "Will this stop me getting pregnant? Does the location matter?"
- "I'm not trying now but I want to know before I decide anything."

**On being believed / normalized pain:**
- "In my family heavy periods and pain are just 'part of being a woman.' I want proof it's not normal."
- "It took years and a lot of pushing to be taken seriously."

**On fatigue / anemia (shared with B4):**
- "I'm exhausted and breathless on the stairs — is that the bleeding?"

**On privacy:**
- "After the Flo/Facebook thing I don't trust these apps with this kind of data."

**Top recurring questions Femio must answer in-product:**
1. What are fibroids, what type/location might I have, and why do they cause *my* particular symptoms (bleeding vs. pressure vs. bladder)?
2. How do I track and show my pressure, bloating, and bladder symptoms — not just bleeding?
3. Is my bleeding objectively heavy, and am I at risk of anemia? (shared with B4)
4. What does "watchful waiting" involve, and when should symptoms prompt me to act?
5. What are my treatment options in plain language — medication, UAE, myomectomy, hysterectomy — and what preserves the uterus/fertility?
6. Can fibroids affect my fertility or a future pregnancy, and does type matter?
7. When is a symptom a "seek care now" red flag?
8. How do I prepare for my appointment, and how do I track fibroid size/imaging over time?

---

## C. Competitor teardown

Feature-by-feature, focused on where trackers fail fibroid users on **non-bleeding "bulk"/pressure/bladder symptom capture**, **fibroid-type/imaging tracking**, and **options education**.

| App | Model | Bleeding capture | Pressure / bloating / bladder / bowel capture | Fibroid type & imaging tracking | Options education | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | Light/medium/heavy taps; no product count or validated score | No dedicated pressure/bloating-severity, bladder-frequency, or "belly size" logging | None | Generic articles, TTC-leaning | **FTC action (2021) for sharing period/pregnancy data; ~$56M class settlement (2025)** — trust damage | Full fibroid symptom set (pressure/bladder/bowel/pain) + objective bleeding score + type/imaging tracker + referenced options library + privacy-by-design |
| **Clue** | Freemium, science-forward | Plus tier: flow heaviness/color/spotting | Better symptom taxonomy but no pressure-severity, bladder-frequency, or abdominal-size model | None | Neutral encyclopedia; no fibroid-type mapping | Better GDPR posture | Fibroid-specific pressure/bladder logging + type-to-symptom education + Arabic-first/RTL |
| **Ovia** | Freemium, health-plan tie-ins | Standard flow | No fibroid-bulk capture | None | Generic | Employer/health-plan data model concerns | Non-TTC-default, non-employer, privacy-first, fibroid-specific |
| **Stardust** | Privacy-forward, local-first | Flow/symptom logging; astrology framing | No fibroid model | None | Minimal clinical | **Strong: local storage** | Clinical credibility + fibroid depth |
| **EZ Myoma** (fibroid-specific) | Free, pharma-sponsored | Tracks period flow intensity | Tracks pelvic-pressure and cramp pain levels; **fibroid-aware** | Medication-cycle & treatment-outcome tracking; limited imaging/size | Sponsor-framed | Sponsor/pharma origin, unclear multilingual/RTL | Femio matches fibroid focus but adds objective bleeding score, bladder/bowel/abdominal-size logging, referenced neutral options library, multilingual Arabic-first, full-lifespan account |
| **Uterine Fibroids Journey / Fibroids Care / UterineKind** (niche fibroid apps) | Various, privacy-forward | Heavy-bleeding logging; some anemia focus | Some log pelvic pressure, bladder pressure, fatigue; "wellness score" | Varies; some track UFE/myomectomy recovery | Patient-advocate-authored, variable citations | Some encrypted/privacy-focused | Femio unifies objective bleeding score + full pressure/bladder/bowel/pain set + type/imaging tracker + referenced medically-reviewed content + visit-prep + one lifespan account, Arabic-first |
| **Generic "flow = 3 dots" trackers** | — | Three-level flow only | None | None | None | Varies | The core failure Femio targets |

**Cross-cutting failure for fibroid users:** mainstream trackers are built around *bleeding and cycle prediction* and have **no vocabulary for the "bulk" symptoms that define fibroids** — the persistent pelvic pressure/heaviness, bloating and visible abdominal enlargement, urinary frequency/urgency/nocturia, and bowel pressure. There is also **no way to record fibroid type/size or track imaging over time**, and no neutral, referenced education mapping *type → symptoms → options*. Fibroid-specific niche apps exist but are fragmented, often single-sponsor or single-founder, rarely multilingual/RTL, and inconsistent on citations and privacy. Femio's answer: the **B4 objective bleeding quantifier reused**, **plus a dedicated fibroid pressure/bladder/bowel/pain + abdominal-size symptom set**, a **fibroid-type & imaging/size tracker**, and a **referenced options library** — in one privacy-first, Arabic-first, full-lifespan account.

*Publication rule: competitor details in §C are internal discovery notes and are not approved for public comparison. Any future named-app feature, sponsor, language, citation, or privacy claim requires a dated official product/policy capture and compliance review; otherwise omit it. Femio’s fibroid symptom/imaging record stands on its own requirements. *(Approved Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## D. Clinical grounding (cited)

**Definition.** Uterine fibroids (leiomyomas / myomas) are **benign (non-cancerous) growths of the smooth-muscle and connective tissue of the uterine wall**. They are very common and are rarely cancerous; they are slow-growing and usually **shrink after menopause** [NICHD/NIH; Office on Women's Health; NHS]. Malignant change (leiomyosarcoma) is very rare [NHS].

**Prevalence.** Extremely common: by menopause a large majority of women will have had fibroids — commonly cited as roughly **70% of White women and >80% of Black women** developing fibroids by their late 40s/menopause; up to **~75%** of women with fibroids have **no symptoms** [NICHD/NIH; NHS; ScienceDirect racial-disparities review]. In the Middle East, a systematic review/meta-analysis estimated pooled fibroid prevalence around **30.6%** among the populations studied — relevant to Femio's MENA-salient audience [Frontiers/PMC Middle East gynecological-conditions meta-analysis]. *Population and case-definition strongly affect these figures.*

**Types & why location drives symptoms (FIGO leiomyoma sub-classification).** Fibroids are grouped by location, which predicts the symptom pattern [FIGO/Munro; radiology reviews]:
- **Submucosal (FIGO 0–2)** — bulge into the uterine cavity/endometrium. **Least common (~5%)** but cause the **most bleeding** and the **greatest impact on fertility/implantation**.
- **Intramural (FIGO 3–5)** — within the muscular uterine wall. Most common; cause heavy bleeding, cramping, uterine enlargement and **bulk symptoms** (bloating, urinary frequency).
- **Subserosal (FIGO 6–7)** — bulge outward from the uterus. Often cause **pressure symptoms** (on bladder/bowel/pelvis) rather than heavy bleeding; pedunculated (stalked) types can occasionally twist and cause acute pain.
- **Other (FIGO 8)** — atypical sites (e.g., cervical, broad-ligament, parasitic). Hybrid/transmural fibroids touch both cavity and outer surface. *Femio explains type→symptom mapping as education, never assigns a woman a type.*

**Symptoms.** Most fibroids are asymptomatic; when symptomatic, common features are [NICHD/NIH; Office on Women's Health; NHS]:
- **Heavy and/or prolonged menstrual bleeding** — flooding, clots, longer periods (see B4).
- **Pelvic pressure / "bulk" symptoms** — heaviness, fullness, a dragging ache; **abdominal enlargement/"looking pregnant"** when fibroids are large.
- **Bladder symptoms** — frequent urination, urgency, nocturia, incomplete emptying (fibroids compress the bladder, reducing functional capacity). In fibroid-treatment cohorts a **majority** report bothersome urinary frequency [FUSS study / clinic sources].
- **Bowel pressure** — constipation or rectal pressure.
- **Pelvic pain / dysmenorrhea / dyspareunia** — cramping, chronic ache, pain with sex; **acute severe pain** can occur when a fibroid degenerates.
- **Anemia / fatigue** — from heavy bleeding (see B4 anemia layer): tiredness, weakness, breathlessness, dizziness [NHS].

**Fertility & pregnancy (educational).** Most women with fibroids conceive normally and have uncomplicated pregnancies, but fibroids **can** affect fertility and pregnancy depending on **size and location** — especially those **distorting the uterine cavity (submucosal/cavity-distorting)**, which are associated with reduced implantation and pregnancy rates and are the type most often considered for removal when fertility is a goal [PMC "Impact and Management of Fibroids for Fertility"; ACOG]. In pregnancy most fibroids cause no problems, but possible associations include **pain (e.g., red degeneration), increased cesarean rate, malpresentation, and (less commonly) preterm labor or postpartum hemorrhage** [Sampat 2018, *The Obstetrician & Gynaecologist*; case series]. **Myomectomy** is the fibroid procedure most often chosen when future fertility is desired [ACOG; fertility review]. *Femio presents all of this as education + "discuss with your clinician," never a personal prognosis.*

**When to seek care.** Book a clinician visit for periods that have become **significantly heavier or more painful**, a **hard lump/"mass" or persistent bulk/pressure**, constant urinary pressure, or **tiredness/breathlessness** (possible anemia) [NHS; ACOG]. **Seek urgent care** for: bleeding so heavy it soaks through protection hourly for several hours; signs of significant blood loss / severe anemia (fainting, severe breathlessness, chest pain, racing heart); or **sudden severe pelvic pain** [NHS; ACOG; Mayo Clinic — shared B4 red-flags]. A **rapidly enlarging mass, especially with weight loss or after menopause**, warrants prompt review (rarely, to exclude sarcoma) [NHS]. **Postmenopausal bleeding** is always a "seek care" flag [ACOG; NHS]. *Femio presents these as red-flag "seek care" education, never triage or diagnosis.*

**Treatment landscape (EDUCATIONAL framing only — Femio does not treat, rank, or dose).**
- **Watchful waiting / expectant management** — for **asymptomatic or mildly symptomatic** fibroids, monitoring with periodic pelvic exam/imaging is a standard, valid option, since fibroids are benign, slow-growing, and often shrink after menopause [Office on Women's Health; NICHD/NIH].
- **Medication (symptom-directed, does not remove fibroids):** NSAIDs and **tranexamic acid** for bleeding/pain; **hormonal options** (combined pill, progestogens, **LNG-IUS** when the cavity is suitable) to reduce bleeding; and **GnRH agonists** and newer **oral GnRH antagonist combination therapy** (e.g., relugolix combination) to reduce bleeding and shrink fibroids, often used pre-operatively or short/medium-term. **Ulipristal acetate** is a selective progesterone-receptor modulator used in some countries but restricted due to rare serious liver injury [NHS; FIGO medical-treatment best-practice guidance; NEJM relugolix]. *Educational context only — Femio never recommends or doses.*
- **Uterine artery embolization (UAE / UFE)** — an interventional-radiology procedure that blocks blood flow to fibroids so they shrink; **uterus-preserving**, with limited/mixed data on subsequent fertility, so counseling is advised [ACOG; RCOG UAE guidance; StatPearls].
- **Myomectomy** — surgical removal of fibroids while **preserving the uterus**; the option most often chosen when future fertility is desired (may lead to cesarean birth; small recurrence/scarring risk) [ACOG].
- **Hysterectomy** — removal of the uterus; the only definitive **cure**, used when other options have failed/aren't suitable or fibroids are very large, and only when childbearing is complete [NICHD/NIH; ACOG].
- Other procedures (e.g., radiofrequency ablation, MRI-guided focused ultrasound, endometrial ablation for the bleeding component) exist and vary by region/availability. Femio explains *what each is and why a clinician might discuss it*, with a clear non-prescription/non-recommendation disclaimer and clinician routing — it never recommends, ranks, or doses.

**Health-equity note (culturally salient).** Fibroids are **more prevalent and often more severe/earlier-onset in Black women**, who are also more likely to have recurrence and complications; drivers include biological, environmental (e.g., stress, pollutant exposure) and **structural/access/bias factors** [ScienceDirect & Michigan Medicine racial-disparities reviews; AJOG "fibroid crisis in Black women"]. Pain and heavy bleeding are frequently **normalized** in some Black and Latina communities ("we normalize pain") [PMC qualitative study], and fibroids are also **more common in MENA/Arab populations** [Middle East meta-analysis]. Femio's job here is validation ("this is common *and* worth taking seriously"), plain-language education, and visit-prep that helps her be heard — never fatalism.

**Femio scope guardrail restated:** all of the above is presented as **wellness education, tracking, and screening**, with consistent "discuss with your clinician" routing and explicit "seek care now" red-flags. Femio is not contraception and does not claim to prevent, diagnose, or treat disease.

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Fibroid symptom tracker — the differentiator (pressure + bladder + bowel + pain + abdominal size).** Log **pelvic pressure/heaviness** (severity + location), **bloating / abdominal enlargement** (optional waist/belly note or "looked pregnant" flag), **urinary frequency / urgency / nocturia / incomplete emptying**, **bowel pressure / constipation**, and **pelvic pain / dyspareunia** (severity, type, timing), viewable **together over time** and against her cycle.
2. **Objective bleeding quantifier (PBAC-style / product-count) — reused from B4.** Products used/day, soak level, clots (with size reference), flooding, double-protection, overnight changes → **semi-objective daily + per-period score** and trend, framed as "a way to describe your bleeding to your clinician," not a diagnosis.
3. **Fibroid-type & imaging/size tracker.** Optional entry of what she's been told (self-reported type/location — submucosal/intramural/subserosal/"don't know"), number, and **size from her own ultrasound/MRI reports over time**, so she can see change and bring a timeline to visits (entry only, no interpretation).
4. **Anemia-symptom awareness layer (reused from B4).** Optional linked logging of fatigue/breathlessness/dizziness/pica; heavy-bleeding + symptom clusters surface non-alarming "ask your clinician about iron/ferritin" education.
5. **Fibroid education library** — what fibroids are; **type→symptom mapping**; watchful waiting; the full options landscape (medication, UAE, myomectomy, hysterectomy) as **education only**; fertility/pregnancy interplay (referenced, medically-reviewed).
6. **Red-flag "seek care" logic** — prominent, dismissible "seek care now" box for uncontrolled bleeding, anemia red-flags, **sudden severe pelvic pain**, and rapid-growth-with-weight-loss/postmenopausal-bleeding education (content only, never triage).
7. **Specialist-visit prep pack** — exportable/printable one-pager: bleeding score trend, **pressure/bladder/bowel/pain symptom summary**, abdominal-size/imaging timeline, anemia-symptom summary, cycle history, questions to ask, standard-work-up checklist (ultrasound, FBC/ferritin).
8. **Non-TTC default** — no "trying to conceive?" nudges; TTC/pregnancy reachable but never assumed. Fibroid-and-fertility education is available on demand.
9. **Privacy-by-design** — local-first where feasible, no ad-SDK data sharing, clear controls; explicitly addresses post-Flo distrust.

**P1 — strong differentiators.**
10. **Quality-of-life / days-affected tracker** (activities missed, sleep disrupted by nocturia, clothes/bloating impact) to make the burden visible and visit-ready.
11. Referenced fibroid content library (Arabic-first + EN/FR/ES), with a **culturally-aware "your symptoms are common but worth taking seriously"** framing for MENA/Black audiences (anti-normalization, non-fatalist).
12. **Options decision-prep helper (educational)** — a neutral "questions to ask about each option" sheet (watchful waiting / medication / UAE / myomectomy / hysterectomy) including uterus-/fertility-preservation questions — never a recommender.
13. Mental-health / body-image support content (abdominal-size distress, chronic-symptom burden), stigma-aware.

**P2 — depth / retention.**
14. Trend correlations ("pressure and nocturia logs rose over the last 3 cycles") — descriptive insight, not diagnosis.
15. Lab/result tracker (she enters her own FBC/ferritin) alongside the imaging/size timeline.
16. Post-procedure/recovery mode (educational) if she has UAE/myomectomy — symptom-recovery logging (unlocks only if she flags a procedure; never assumed).

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **What are fibroids?** — benign muscle growths of the uterus; how common; that most cause no symptoms; benign vs. the rare sarcoma; usually shrink after menopause.
2. **Types of fibroids and why they cause different symptoms.** — plain-language submucosal / intramural / subserosal (and "other"); how **location predicts** whether you get more bleeding or more pressure/bladder symptoms.
3. **Tracking the pressure — not just bleeding.** — why bulk symptoms (heaviness, bloating, abdominal size, urinary frequency/nocturia, bowel pressure) matter and how to log them for your clinician.
4. **Heavy periods & your iron (shared with B4).** — bleeding→iron-loss→fatigue; "ask about a full blood count and ferritin."
5. **Measuring your bleeding (PBAC-style, shared with B4).** — how the product-count/soak score works as a clinician conversation tool.
6. **Understanding your options (education only).** — watchful waiting; medication (NSAIDs, tranexamic acid, hormonal/LNG-IUS, GnRH agonist/antagonist therapy, ulipristal where used); UAE; myomectomy; hysterectomy — what each is, what it does/doesn't do to the fibroid, and why a clinician might discuss it. Clear non-prescription/non-recommendation disclaimer.
7. **Fibroids, fertility & pregnancy.** — most women conceive and carry normally; how size/location (esp. cavity-distorting) can matter; what's typically monitored in pregnancy; which option preserves fertility. Educational, not a personal prognosis.
8. **When to seek care.** — routine-visit signs vs. red-flag "seek care now" (uncontrolled soaking, fainting/severe breathlessness, sudden severe pelvic pain, postmenopausal bleeding, rapidly enlarging mass with weight loss).
9. **Getting the most from your appointment.** — standard work-up (ultrasound, FBC/ferritin), tracking fibroid size/imaging over time, questions to ask about each option, how to advocate if dismissed, how to use your Femio summary.
10. **You're not alone — and it's not "just normal."** — culturally-aware module for communities where fibroids are common and pain is normalized (Black, MENA/Arab): validation + why symptoms deserve attention + how to advocate. Non-fatalist.
11. **Living with fibroids.** — practical tips for pressure/bloating/bladder days, sleep and nocturia, work and social life, intimacy, body-image.
12. **Myths vs. evidence.** — "fibroids always mean a hysterectomy," "fibroids are cancer," "nothing can be done but surgery," "heavy periods and pressure are just normal."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, and (where relevant) a red-flag "seek care" callout.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Fibroid symptom log (core differentiator):**
  - **Pelvic pressure / heaviness** — severity scale + optional location (low belly / one side / rectal).
  - **Bloating / abdominal enlargement** — severity + optional "clothes tighter / looked pregnant" flag + optional self-measured waist note (entirely optional).
  - **Urinary symptoms** — frequency (count/day), urgency, **nocturia** (times up at night), sense of incomplete emptying.
  - **Bowel pressure** — constipation / rectal pressure toggle + severity.
  - **Pelvic pain / dyspareunia** — severity, type (dull/dragging vs. sharp/acute), timing vs. cycle.
- **Bleeding quantifier (shared with B4):** per-day products used/type, **soak level per product**, **clots with size reference**, **flooding** toggle, **double-protection** toggle, **overnight-change** toggle → computed **PBAC-style daily + per-period score** and duration; trend view.
- Standard cycle/bleed log (start/end, spotting, cycle length) inherited from B1.
- **Anemia-symptom log (shared with B4):** fatigue, weakness, breathlessness, dizziness, headache, pica, restless legs — optional, toggleable.
- **Fibroid-type & imaging/size log:** self-reported type/location + number + size(s) from her own ultrasound/MRI reports, dated → **size-over-time timeline** (entry only, no interpretation).
- Quality-of-life / days-affected log (activities missed, sleep disrupted) — optional.
- Optional lab/result entry (FBC/hemoglobin, ferritin) — **entry only, no interpretation as diagnosis**.

**Tools**
- **Fibroid symptom-summary view** — pressure/bladder/bowel/pain trends alongside the bleeding-score trend and imaging timeline; descriptive language ("appears associated with," never "caused by").
- **PBAC-style bleeding-severity summary (shared with B4)** — score trend + plain-language band ("often associated with heavy bleeding — worth discussing"), never a diagnosis, always clinician-routed.
- **Visit-prep generator** — one-tap export/print: bleeding score + product counts + clot/flooding flags + **pressure/bladder/bowel/pain summary** + abdominal-size/imaging timeline + anemia-symptom summary + cycle history + questions (incl. per-option and uterus-/fertility-preservation questions) + standard-work-up checklist (ultrasound, FBC/ferritin).
- **Screeners (framed as screening, not diagnosis):**
  - **Fibroid-symptom awareness checklist** (heavy bleeding? pressure/bulk? urinary frequency/nocturia? bloating/abdominal size? pelvic pain?) → "These can be signs to discuss; only a clinician can assess the cause."
  - **Anemia-symptom awareness checklist (shared with B4)** → "ask your clinician about a full blood count and ferritin."
  - Optional mood/anxiety screen (PHQ-2/GAD-2 style) → screening-framed + crisis resources.

**Alerts (all non-alarming unless red-flag; screening-framed; dismissible; localized/RTL)**
- **Red-flag "seek care now" box** (prominent) when logs indicate **uncontrolled heavy loss** (soaking hourly for several hours), **anemia red flags** (fainting, severe breathlessness, chest pain, racing heart), or **sudden severe pelvic pain** → "seek care" education + saved emergency contact. Postmenopausal-bleeding and rapid-growth-with-weight-loss education surfaced as "see your clinician promptly." *Content only, never triage/diagnosis.*
- **Anemia-awareness prompt (shared with B4)** when heavy-score periods + fatigue cluster → "many clinicians suggest checking iron — here's why" → links to iron/nutrition education.
- **Escalating-symptom awareness prompt** — if pressure/bladder/pain or bleeding-score trends worsen over consecutive cycles (relevant to the "watchful waiting" context) → non-alarming "worth a check-in with your clinician; here's what to note" + visit-prep. *Framed as awareness, never "your fibroids are growing."*
- Optional symptom/bleeding-log reminders (respect her cadence).
- **Never:** "you have fibroids / anemia / a growing tumor"; never disease-prevention or contraception claims; never a supplement or medication dose; never a size/type interpretation.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — inherited from constant core §3 / B1)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC default, **fibroid mode ON**).
- Cycle events: bleed start/end, flow, spotting; computed cycle-length + variability.
- Generic symptom log; mood/energy/sleep.

**Persona-specific (fibroids)**
- **Fibroid symptom fields:** pelvic-pressure severity + location; bloating/abdominal-enlargement severity + "looked pregnant"/clothes-tighter flag + optional waist note; urinary frequency count / urgency / nocturia count / incomplete-emptying flag; bowel-pressure/constipation flag + severity; pelvic-pain severity + type (dull/acute) + dyspareunia flag.
- **Bleeding-quantification fields (shared with B4):** products-used count/type per day, soak level, clot count + size band, flooding flag, double-protection flag, overnight-change flag, bleed-duration days; **computed PBAC-style score** + heavy-band flag (non-diagnostic).
- **Fibroid-type & imaging fields (self-report):** type/location (submucosal / intramural / subserosal / other / unknown), number, size(s) with date from her own reports; **size-over-time series** (entry only).
- **Anemia-symptom log (shared with B4):** fatigue/weakness/breathlessness/dizziness/pica/restless-legs (scores + dates, awareness-only).
- **Quality-of-life impact:** days affected, activities missed, sleep disrupted (optional).
- **History hints (self-report):** known/suspected fibroids, prior fibroid procedure (UAE/myomectomy/other), heavy-since-menarche y/n (coagulopathy education trigger, shared with B4), copper-IUD/anticoagulant use (iatrogenic bleeding context).
- **User-entered labs:** hemoglobin/FBC, ferritin — **entry only, no interpretation as diagnosis**.
- **TTC intent flag = false by default** (drives non-TTC UX); reachable toggle.

*All health fields optional, encrypted, user-deletable; abdominal/waist measurement is explicitly optional and never required.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B8):**
- Q: life stage → "reproductive age / tracking my cycle." Q: cycles regular / irregular / **a condition I know of** → selects **"fibroids"** (or reaches B8 from B4's "known/suspected fibroids" flag) ⇒ set **fibroid mode ON** (bleeding-quantifier layer + fibroid pressure/bladder/bowel/pain layer both on).
- Q: "Are you currently trying to conceive?" → **No (default)** ⇒ TTC intent = false, suppress fertile-window/pregnancy nudges; fibroid-and-fertility education remains available on demand.
- Q: which symptoms bother you most? (multi-select: **heavy bleeding**, **pelvic pressure/heaviness**, **bloating/abdominal size**, **bladder/urinary**, **bowel**, **pelvic pain**, **fatigue/iron**, **fertility questions**, **appointment prep**) ⇒ orders home modules and which trackers are pinned.
- Q: do you know your fibroid type/size, or have you had imaging? (yes → prompt to add type/size timeline; no/unsure → surface "types of fibroids" education) ⇒ tunes type/imaging tracker prominence.
- Q: history hints (prior fibroid procedure? heavy since first period? on a copper IUD / blood thinner?) ⇒ tunes which education surfaces (recovery mode / coagulopathy / iatrogenic).

**Home configuration (default for B8):**
- **Hero = combined fibroid symptom snapshot** — her top-flagged symptoms (e.g., pressure + bladder trend) plus the bleeding-score trend, with a "share with your clinician" action. No "late" or fertile-window framing.
- Cards prioritized by her concern selection (pressure/bladder tracker surfaced if she flagged bulk symptoms; bleeding quantifier + anemia-awareness if she flagged bleeding/fatigue; options library if she flagged "what are my choices"; fertility education if she flagged that).
- **Visit-prep, fibroid symptom tracker, and bleeding quantifier pinned; type/imaging timeline surfaced if she has imaging.**
- Fertile-window / pregnancy widgets **hidden by default**.

**Hidden-but-reachable principle:** Femio never *removes* knowledge. TTC guidance, pregnancy tracking, contraception education, and perimenopause/menopause content remain **discoverable** via search and "Explore other life stages" — just not pushed. She can opt into fertile-window/TTC mode anytime.

**Adaptive tuning:** worsening pressure/bladder/pain or bleeding-score trends over consecutive cycles → raise escalating-symptom + visit-prep prominence (framed as awareness in the watchful-waiting context, never "growing"). Heavy-band + clustered fatigue → raise anemia-awareness + iron education. Red-flag thresholds → immediate "seek care" box regardless of settings. If she adds a fibroid procedure → offer educational recovery/symptom-tracking mode.

---

## J. Adaptation triggers (life-stage routing)

Inherits **all universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive pregnancy test; pregnancy loss; mood-screen high/crisis; **red-flag symptom / severe reading → "seek care now" content**; disengagement; toggle-off; age-of-consent). The table below adds **B8-specific** transitions only.

| Trigger | System response | Route |
|---|---|---|
| **Logged bleeding hits red-flag threshold** (soaking through protection hourly for several hours; flooding with fainting/severe breathlessness) | Fire universal red-flag handler: prominent **"seek care now"** box + saved emergency contact as *education*; log stays raw; no diagnosis/triage | Emergency messaging (content only); stay B8 |
| **Sudden severe pelvic pain logged** (fibroid-specific, e.g., possible degeneration/torsion context) | Fire universal red-flag handler: **"seek care now"** education + saved emergency contact; log stays raw | Emergency messaging (content only); stay B8 |
| **Heavy-band periods + clustered fatigue/anemia symptoms** (shared with B4) | Surface **anemia-symptom awareness** + "ask your clinician about FBC/ferritin" (screening-framed); **link to iron/nutrition education** | Stay B8; **→ nutrition/iron-education module** |
| **Escalating pressure/bladder/pain or bleeding-score trend** over consecutive cycles (watchful-waiting context) | Non-alarming "worth a check-in; here's what to note" + cause/options education + visit-prep. **Never "your fibroids are growing."** | Stay B8, raise screening/visit-prep prominence |
| **Adds a fibroid procedure** (UAE / myomectomy / other) | Offer **educational recovery/symptom-tracking mode**; surface post-procedure "what to expect / when to seek care" education; retain all history | Stay B8 + recovery layer (opt-in) |
| **"Heavy since my first period" flag** (shared with B4) | Surface **coagulopathy/bleeding-disorder education** (e.g., von Willebrand context) as "worth discussing"; add to visit-prep questions | Stay B8; cause-education deepened |
| **Sets TTC intent = true** ("start trying") | Confirm; enable ovulation/fertile-window features; **carry the full fibroid context** (type/size timeline, bleeding + pressure logs); surface **fibroids-and-fertility** education (cavity-distorting/submucosal relevance; myomectomy-for-fertility context) | **Route to TTC band — keep fibroid layer, add TTC layer** (C-band, fibroid-flagged) |
| **Positive pregnancy test logged** | Fire universal positive-test handler: celebrate (tone-matched); suppress fertile-window/TWW/OPK/BBT; **carry fibroid context into pregnancy** (fibroid-in-pregnancy education: pain/red-degeneration, monitoring, mode-of-birth discussion); re-confirm privacy scope | Pregnancy band (**fibroid-flagged**, e.g., D1 + fibroid modifier) |
| **Perimenopause / menopause overlap** (40s+, changing cycles, vasomotor symptoms) | Introduce perimenopause education; explain that **fibroids commonly shrink after menopause** and bulk/bleeding symptoms often ease; **keep bleeding-quantifier; keep red-flag "postmenopausal bleeding = seek care" education** | Blend fibroid + perimenopause content; offer route to menopause band |
| **User toggles off fibroid mode** | Revert to standard cycle logic (B1) but preserve all fibroid, bleeding, and imaging history | General reproductive-age band |

Cross-persona note: B8 **shares the HMB bleeding-quantification + anemia layer with B4** (a woman can carry both HMB and fibroid framing simultaneously — structural cause of her heavy bleeding), and bridges toward **B9-type structural conditions (adenomyosis)** and **B7** (other cycle/gynae conditions) as those layers surface. All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. The PBAC-style score and all symptom trackers are **tracking/communication aids**, explicitly **not** diagnostic outputs. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Symptom trackers & score:** framed as "a way to describe your symptoms/bleeding" and "discuss with your clinician"; never "you have fibroids," "your fibroids are growing," or "this is abnormal." Trend language uses "appears associated with," never verdicts. The fibroid-type/size tracker stores **her own reported imaging** and never interprets it.
- **Red-flags:** uncontrolled bleeding, anemia red-flags, and sudden severe pelvic pain trigger clear **"seek care now"** education (content only) + saved emergency contact; postmenopausal bleeding and rapid-growth-with-weight-loss surfaced as "see your clinician promptly." Never triage, never "you're hemorrhaging / it's cancer."
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs "You have fibroids / anemia / a bleeding disorder."
- **Anemia / iron content (shared with B4):** awareness + "ask about FBC/ferritin" + general dietary-iron education only; **never** a supplement recommendation or dose.
- **Medication/procedure content (NSAIDs, tranexamic acid, hormonal/LNG-IUS, GnRH agonist/antagonist therapy, ulipristal, UAE, myomectomy, hysterectomy):** educational context only; no recommendation, ranking, dosing, or "take/do this." Note that **ulipristal has restricted use due to rare serious liver injury** where discussed. Clear non-prescription disclaimer + clinician routing.
- **Fertility/pregnancy content:** educational only; never a personal prognosis ("your fibroid will/won't affect fertility"); always "discuss with your clinician."
- **Predictions:** no fertile/"safe" window presented as reliable; add "not for contraception" note wherever ovulation/fertility appears.
- **Health equity / cultural framing:** validation-and-advocacy tone for higher-prevalence/higher-impact groups (Black, MENA/Arab); **anti-normalization but non-fatalist**; avoid stereotyping or deterministic race-as-biology language; frame disparities as prevalence + access/structural context, not destiny.
- **Mental health:** crisis resources on any low mood screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** health data = special-category; explicit granular consent, purpose limitation, no ad-SDK/third-party sharing of cycle/bleeding/symptom/imaging data (post-Flo trust); local-first where feasible; full export/delete. Data-mapping + DPIA required before launch. Export/print of the visit-prep pack is user-initiated and scoped. Self-entered imaging/lab data is stored as user notes, not clinical records.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education keeps out of regulated-device territory — legal review before store submission.
- **Resolved publication rule:** do not display a PBAC diagnostic cut-off, race/region prevalence percentage, coin-size clot comparison, named-treatment availability claim, or unverified competitor feature claim. Track bleeding pattern and quality-of-life impact and route concerns to a clinician, consistent with [NICE NG88](https://www.nice.org.uk/guidance/ng88/chapter/Recommendations), which prioritizes impact rather than a public blood-loss score. Treatment availability requires a current launch-country regulator/formulary source. Urgent mental-health routing follows [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md), never a hard-coded global number. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH/NICHD/NHS/MedlinePlus/OWH/FDA):**
- [Uterine Fibroids — NICHD / NIH (condition information)](https://www.nichd.nih.gov/health/topics/uterine)
- [What are the treatments for uterine fibroids? — NICHD / NIH](https://www.nichd.nih.gov/health/topics/uterine/conditioninfo/treatments)
- [Uterine fibroids — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/a-z-topics/uterine-fibroids)
- [Uterine Fibroids — FDA (women's health topics)](https://www.fda.gov/consumers/womens-health-topics/uterine-fibroids)
- [Fibroids — NHS](https://www.nhs.uk/conditions/fibroids/)
- [Fibroids: Treatment — NHS](https://www.nhs.uk/conditions/fibroids/treatment/)
- [Overview: Uterine fibroids — InformedHealth.org / NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK279535/)
- [Uterine Fibroids Research Overview — DiscoverWHR / NIH](https://discoverwhr.nih.gov/research/uterine-fibroids/)

**Clinical — Tier 2 (guidelines / society / peer-reviewed):**
- [Uterine Fibroids — ACOG patient FAQ](https://www.acog.org/womens-health/faqs/uterine-fibroids)
- [Management of Symptomatic Uterine Leiomyomas — ACOG Practice Bulletin (Obstetrics & Gynecology, 2021)](https://journals.lww.com/greenjournal/fulltext/2021/06000/management_of_symptomatic_uterine_leiomyomas__acog.36.aspx)
- [Uterine-Artery Embolization or Myomectomy for Uterine Fibroids — NEJM (FEMME trial)](https://www.nejm.org/doi/full/10.1056/NEJMoa1914735)
- [Uterine Fibroid Embolization — StatPearls / NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK519016/)
- [Uterine Artery Embolization for Symptomatic Fibroids: A Review of the Evidence — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3955520/)
- [Diagnosis and classification of uterine fibroids — Lakabi, Int J Gynecol Obstet 2025 (FIGO sub-classification)](https://obgyn.onlinelibrary.wiley.com/doi/full/10.1002/ijgo.70538)
- [MRI-based pictorial review of the FIGO classification of uterine fibroids — UNC/Gomez 2021 (PDF)](https://rads.web.unc.edu/wp-content/uploads/sites/12234/2021/07/Gomez2021_Article_MRI-basedPictorialReviewOfTheF.pdf)
- [Medical treatment of fibroids: FIGO best practice guidance — Diaz, Int J Gynecol Obstet 2025](https://obgyn.onlinelibrary.wiley.com/doi/10.1002/ijgo.70497)
- [Treatment of Uterine Fibroid Symptoms with Relugolix Combination Therapy — NEJM (LIBERTY)](https://www.nejm.org/doi/full/10.1056/NEJMoa2008283)
- [Use of oral GnRH antagonists combined therapy in symptomatic uterine fibroids — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10392112/)
- [Currently Available Treatment Modalities for Uterine Fibroids — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11205795/)

**Fertility & pregnancy:**
- [The Impact and Management of Fibroids for Fertility: an evidence-based approach — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3608270/)
- [Fibroids in pregnancy: management and outcomes — Sampat 2018, The Obstetrician & Gynaecologist (Wiley)](https://obgyn.onlinelibrary.wiley.com/doi/abs/10.1111/tog.12491)
- [Navigating Pregnancy With Uterine Fibroids: A Case Study — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11330289/)

**Symptom burden (pressure / bladder / bulk):**
- [Fibroids and Urinary Frequency: bladder symptoms women overlook (FUSS study summary) — Surgical Associates](https://sacmd.com/fibroids-urinary-frequency-bladder-symptoms/)
- [Fibroids — Johns Hopkins Medicine (symptoms incl. pressure/bloating)](https://www.hopkinsmedicine.org/health/conditions-and-diseases/uterine-fibroids)
- [Uterine Fibroids: Causes, Symptoms & Treatment — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/9130-uterine-fibroids)

**Health equity / cultural salience (Black & MENA populations):**
- [Racial disparities in uterine fibroids and endometriosis: a systematic review — ScienceDirect (Fertility & Sterility)](https://www.sciencedirect.com/science/article/pii/S0015028223000602)
- [Understanding Racial Disparities for Women with Uterine Fibroids — Michigan Medicine / IHPI](https://www.michiganmedicine.org/health-lab/understanding-racial-disparities-women-uterine-fibroids)
- [The fibroid crisis in Black women: more work to be done! — AJOG](https://www.ajog.org/article/S0002-9378(24)00739-7/fulltext)
- ["In our community, we normalize pain": menstruation and fibroids with Black women and Latinas — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11010402/)
- [Prevalence of Common Gynecological Conditions in the Middle East: Systematic Review and Meta-Analysis — Frontiers / PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC9580651/)

**Competitor / app landscape:**
- [EZ Myoma App — fibroid symptom tracker (Zuellig Pharma / FibroidsConnect)](https://fibroidsconnect.zuelligpharma.com/symptoms/ezmyomaapp/)
- [Uterine Fibroids Journey — Google Play](https://play.google.com/store/apps/details?id=uterine.fibroids.journey)
- [Fibroids Care App](https://fibroidscare.org/)
- [What Your Doctor Wants You to Track With Fibroids — HealthCentral](https://www.healthcentral.com/condition/uterine-fibroids/what-your-doctor-wants-you-to-track)
- [Clue — Period & Cycle Tracker (App Store)](https://apps.apple.com/us/app/clue-period-cycle-tracker/id657189652)
- [Flo — period/cycle app](https://flo.health/)

**Shared HMB / bleeding-quantification & anemia grounding (see B4 for full list):**
- [Heavy Menstrual Bleeding — ACOG patient FAQ](https://www.acog.org/womens-health/faqs/heavy-menstrual-bleeding)
- [Heavy menstrual bleeding: assessment and management — NICE guideline NG88 (PDF)](https://www.nice.org.uk/guidance/ng88/resources/heavy-menstrual-bleeding-assessment-and-management-pdf-1837701412549)
- [FIGO classification (PALM-COEIN) for abnormal uterine bleeding — Munro 2011, Int J Gynecol Obstet](https://obgyn.onlinelibrary.wiley.com/doi/10.1016/j.ijgo.2010.11.011)
- [Pictorial methods to assess heavy menstrual bleeding: systematic review (PBAC) — PMC7011238](https://pmc.ncbi.nlm.nih.gov/articles/PMC7011238/)
- [Relationship between HMB, iron deficiency, and iron-deficiency anemia — AJOG 2023](https://www.ajog.org/article/S0002-9378(23)00024-8/fulltext)
