# Persona B3 — Reproductive-age woman with dysmenorrhea (painful periods)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners and red-flag prompts are framed as "screening / awareness — discuss with a clinician."
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC) · Companion to `09_MASTER_ADAPTATION_MODEL.md`

---

## A. Persona snapshot

**Who she is.** "Nour," 24. Her periods have hurt badly since her mid-teens — cramping that starts the day before bleeding and floors her for the first day or two each cycle. She has been told repeatedly that "period pain is normal" and to "just take a painkiller." She half-believes it, half-doesn't: some months a hot-water bottle and ibuprofen are enough, other months the pain radiates to her back and thighs, she misses work or class, and she quietly wonders whether something is actually wrong. Arabic-first (also reads English), uses the web on her phone.

**What she lives with.**
- **Cyclical pelvic pain** — cramping lower-abdominal pain, often starting hours-to-a-day before flow, peaking on days 1–2, sometimes radiating to lower back and inner thighs; can come with nausea, headache, loose stools, fatigue.
- **Functional impact** — missed school/work, cancelled plans, disrupted sleep; the pain is a monthly tax she plans her life around.
- **Uncertainty about "normal"** — no clear sense of whether her pain is ordinary (primary) or a signal of something treatable underneath (secondary — e.g. endometriosis, adenomyosis, fibroids).
- **Dismissal fatigue** — has been brushed off before; doesn't want to "overreact," but also doesn't want to be gaslit into ignoring a real problem.

**Core emotional drivers.** Wants her pain **believed, quantified, and taken seriously** — not minimized and not catastrophized. Wants to know what actually helps *this cycle* (self-care she can act on tonight) and wants an honest signal for *when* pain has crossed from "common and manageable" into "worth getting checked." Does not want to be told she has a disease by an app; does want to be helped to notice patterns and to walk into a clinic prepared.

**Jobs-to-be-done.**
1. Track pain properly — timing (relative to bleeding, not just the calendar), severity, location, and what relieved it — so it's not just "it hurt a lot."
2. Learn evidence-based self-care and management (heat, NSAID timing, movement — educational) that she can use now.
3. Understand the difference between primary period pain and pain that suggests a secondary cause worth investigating.
4. Get an honest, non-alarming nudge when her pattern (severity, non-response to self-care, pain outside her period, other red flags) is worth a clinician conversation.
5. Prepare for that visit with a clear, exportable pain history so she isn't dismissed again.

**Success = she walks into a clinic with a months-long pain map and severity trend instead of "it just really hurts," and she knows whether she's there for reassurance or for a real work-up.**

---

## B. Needs & questions (voice-of-user)

Mined from period-pain and endometriosis communities, app-store reviews, and qualitative literature on menstrual-pain self-care and diagnostic delay (see Sources). Paraphrased to avoid quoting individuals.

**On being believed / "is this normal?" (the #1 pain):**
- "I've been told my whole life that bad periods are just part of being a woman. Is that true or is something wrong?"
- "How much pain is too much? Where's the line between normal cramps and 'go get this checked'?"
- "It took years for anyone to take my pain seriously — I want proof to show them."

**On tracking the pain itself:**
- "I need to log *where* it hurts and *how bad*, not just tick 'cramps'."
- "The pain starts before my bleeding does — most apps only think in terms of period days."
- "By the time I'm at the appointment I can't remember how many days I was in pain last month."

**On self-care and management (educational):**
- "What actually works — heat, ibuprofen, exercise? And when do I take the painkiller so it works?"
- "I don't want to be on the pill just for cramps without understanding my options first."
- "Is there anything non-drug that genuinely helps, or is that all wishful thinking?"

**On red flags / secondary causes:**
- "When should painful periods make me worry about endometriosis or fibroids?"
- "My pain is getting worse every year and the painkillers barely touch it now — is that a sign?"
- "It hurts during sex and when I go to the bathroom on my period — is that connected?"

**On visit prep:**
- "What do I even say to the doctor so they don't just tell me to take paracetamol again?"
- "What tests or referrals should I be asking about?"

**Top recurring questions Femio must answer in-product:**
1. Is my period pain "primary" (common, no underlying disease) or could it point to a secondary cause?
2. What self-care and management is actually evidence-based, and how do I use it well (e.g. NSAID timing)?
3. When does my pain pattern cross into "worth discussing with a clinician"?
4. What are the red flags that suggest endometriosis / adenomyosis / fibroids?
5. How do I record and present my pain so I'm taken seriously?
6. What might a clinician suggest, and what should I ask for?

---

## C. Competitor teardown

Feature-by-feature, focused on how period-pain and pain-pattern tracking is (under)served by general trackers, and where dedicated endo/pain apps do better.

| App | Model | Pain-tracking depth | Timing (vs bleeding) | Red-flag / secondary-cause framing | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions | General symptom checklist incl. "cramps" with a rough intensity; no dedicated pain map or severity trend built for pain-pattern detection | Cycle-phase aware but pain framed around period days, not pain-onset-vs-flow | Minimal; general "see a doctor" content, no structured escalation on pain pattern | **FTC settlement (2021) for sharing period/pregnancy data with Facebook/Google; ~$56M class settlement (2025)** — trust damage | Structured pain map + severity trend + honest, pattern-based clinician-check nudge; privacy-by-design |
| **Clue** | Freemium, science-forward | Good neutral symptom taxonomy; has endometriosis-symptom tracking guidance content | Handles variable cycles well; pain still one tag among many | Educational endo content; no personalized escalation logic | Better reputation, EU/GDPR posture | Body-map pain location + severity/location trend + red-flag awareness routing; Arabic-first/RTL |
| **Phendo** (Citizen Endo, Columbia) | Free research app | **Deep** — pain intensity, "endo belly," body-map to mark pain locations; built for endo | Detailed self-report | Research-grade characterization, but it's for people who *already* suspect/have endo; not a general first-touch | Academic/research data use | Femio serves the *earlier* woman who doesn't yet know if it's primary or secondary, then bridges her toward B7/B8/B9 awareness |
| **Bearable** | Freemium symptom/mood tracker | Strong general symptom + factor correlation, pain scales | Not menstrual-specific | Generic; no gynae red-flag model | Standard | Menstrual-pain-specific model + referenced gynae content + lifespan account |
| **Flutter / QENDO / Matilda** | Endo-focused apps | Location tags, flare tracking, pain logs | Endo-oriented | Community + endo education; assume endo context | Varies | Femio provides the neutral, pre-diagnosis on-ramp with uncertainty-honest framing and Tier-1/Tier-2 grounding |
| **Generic reminder / calendar apps** | Free | "Cramps: mild/moderate/severe" at best | Period days only | None | Varies | Everything above |

**Cross-cutting failure of general trackers for dysmenorrhea:** they treat pain as a single check-box symptom attached to "period days," with no structured **location** (body map), no **severity trend over months**, no sense of **pain-onset relative to bleeding**, and — critically — **no honest, pattern-based signal for when pain suggests a secondary cause worth investigating**. Dedicated endo apps do the tracking well but assume the user already suspects endometriosis. Femio's opportunity is the **neutral, pre-diagnosis on-ramp**: excellent pain tracking + evidence-based self-care education + an uncertainty-honest bridge toward endometriosis/adenomyosis/fibroids *awareness* (never diagnosis) that routes her to a clinician at the right moment. This matters because endometriosis alone carries a reported ~7–9 year diagnostic delay, much of it driven by normalized, un-quantified pain [EndoFound; PMC].

---

## D. Clinical grounding (cited)

**Definition.** Dysmenorrhea is the medical term for painful periods / menstrual cramps — crampy lower-abdominal pain around menstruation, which may radiate to the lower back and thighs and can be accompanied by nausea, headache, loose stools, and fatigue [MedlinePlus; ACOG]. It is divided into **primary** and **secondary** [Cleveland Clinic; ACOG].

**Primary dysmenorrhea (no underlying pathology).** Painful menstruation **in the absence of pelvic pathology** [ACOG CO 760]. Pain is driven by **prostaglandins** produced in the uterine lining, which cause the uterine muscle and blood vessels to contract, reducing blood/oxygen flow (ischemia) and producing cramping [ACOG; Cleveland Clinic]. Typically begins **6–12 months after menarche** once ovulatory cycles establish; pain starts with or just before bleeding and lasts roughly **8–72 hours**; the pattern is generally **stable or improves** with age. Most adolescents/young women with dysmenorrhea have the primary type and respond to empiric self-care/treatment [ACOG CO 760; AFP 2021].

**Secondary dysmenorrhea (a recognized underlying cause).** Painful menses caused by an identifiable pelvic disorder. Causes include **endometriosis (the leading cause), adenomyosis, uterine fibroids (myomas), pelvic infection (PID), ovarian cysts, and müllerian / obstructive reproductive-tract anomalies** [ACOG CO 760; Medical News Today; MSD Manual]. Features that point toward secondary causes: pain that **begins years after** pain-free periods, pain that **worsens over time**, pain occurring **outside** menstruation (chronic pelvic pain), and pain **poorly responsive** to NSAIDs and/or hormonal management [ACOG CO 760; AFP 2021].

**Red flags suggesting a secondary cause worth investigating (→ "discuss with a clinician").** Compiled from ACOG CO 760, AFP 2021, and MSD/patient.info:
- Pain **not improving within ~3–6 months** of consistent NSAID and/or hormonal management (ACOG's threshold for investigating secondary causes and adherence).
- Pain that is **worsening cycle-on-cycle** or newly severe after years of milder periods.
- **Chronic pelvic pain** — pain on days outside the period, or that no longer maps only to bleeding.
- **Dyspareunia** (pain with sex), **dyschezia** (pain with bowel movements), or **dysuria/bladder pain**, especially cyclical — associated with endometriosis.
- **Abnormal / heavy menstrual bleeding**, bulk symptoms, or a change in bleeding pattern — associated with fibroids/adenomyosis.
- **Fever, abnormal or foul discharge, or intermenstrual bleeding** — possible infection; discuss promptly.
Femio surfaces these as **educational awareness prompts that route to a clinician** — never as a diagnosis. Pelvic ultrasound and specialist evaluation are clinician decisions [ACOG CO 760].

**Management (EDUCATIONAL framing only — Femio does not treat or dose).**
- **Pain-relief medicines:** clinicians commonly discuss NSAIDs for dysmenorrhea, but suitability, timing, contraindications, and dosing are individual. Femio gives no response percentage, drug choice, or dose and routes medicine questions to a clinician/pharmacist.
- **Heat therapy** may provide comfort for some people. Femio presents it as optional self-care without claiming equivalence or superiority to medicine.
- **Exercise and lifestyle** — regular physical activity and several self-care measures are associated with reduced menstrual-pain severity in systematic reviews [PMC self-care/lifestyle reviews].
- **TENS** (transcutaneous electrical nerve stimulation) — reduces pain more than placebo, sometimes comparable to medication, with minimal side effects [AHRQ EHC; medscape].
- **Hormonal options** (e.g. combined hormonal contraceptives, progestogens) reduce menstrual pain and are a clinician-discussed option; Femio explains what they are and why a clinician might raise them — **never prescribes, doses, or frames them as contraception advice** [ACOG; AFP 2021].
- Other supportive measures with variable/limited evidence (acupressure, dietary approaches, sleep) are presented as "may help some people, discuss with your clinician," not as treatment.

**Femio scope guardrail restated:** all of the above is presented as **wellness education, tracking, and screening/awareness**, with consistent "discuss with your clinician" routing. Femio does not diagnose primary vs secondary dysmenorrhea, does not treat, does not prevent disease, and is not contraception.

*Claims boundary:* NSAID response percentages and heat-versus-NSAID comparative efficacy are excluded. Persistent or function-limiting pain and features suggesting a secondary cause route to evaluation; [ACOG Clinical Practice Guideline No. 11, March 2026](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2026/03/diagnosis-of-endometriosis) supplies the current endometriosis diagnostic context. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Structured pain tracking** — per-cycle log of **severity** (consistent 0–10 / mild-moderate-severe scale), **timing relative to bleeding** (e.g. "starts 1 day before flow"), **duration**, and **relief tried + what worked** (heat, NSAID, rest, TENS, movement).
2. **Pain body map** — tap-to-mark pain **location(s)** (lower abdomen, lower back, thighs, pelvic, radiating) with intensity, stored per cycle so location patterns are visible over time.
3. **Severity & pattern trend** — a months-long view of pain severity, duration, and functional impact so escalation or improvement is visible at a glance (not a diagnosis — a trend).
4. **Self-care & management library** (educational) — heat, NSAID timing, movement, TENS, "options a clinician might discuss," with clear non-prescription framing.
5. **Red-flag / secondary-cause awareness** — non-alarming, pattern-based prompts ("pain not easing with self-care over several cycles, or pain outside your period, is worth discussing with a clinician — here's why") that bridge toward endometriosis/adenomyosis/fibroids *awareness* and clinician routing.
6. **Visit-prep pack** — auto-generated, exportable/printable summary: pain map, severity/duration trend, red-flag checklist, questions to ask.
7. **Privacy-by-design** — special-category health data, no ad-SDK sharing, clear controls; addresses post-Flo distrust.

**P1 — strong differentiators.**
8. Referenced, medically-reviewed dysmenorrhea content library (Arabic-first + EN/FR/ES).
9. "Is this primary or secondary?" explainer + interactive awareness checklist (screening-framed, never diagnostic).
10. NSAID/heat **timing coach** — educational reminders around expected pain onset (not a dosing tool).
11. Functional-impact log (missed work/school/sleep) — the "believe me" evidence layer.

**P2 — depth / retention.**
12. Relief-effectiveness insight ("heat + early NSAID appears to line up with your lower-pain cycles" — descriptive, not causal).
13. Optional correlation view (pain vs cycle phase, bleeding heaviness, mood, sleep).
14. Bridge cards to B7 (endometriosis), B8 (fibroids), B9 (adenomyosis) awareness content when patterns warrant.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Period pain 101** — what dysmenorrhea is, why the uterus cramps (prostaglandins), what's common.
2. **Primary vs secondary** — the key distinction, in plain language; why it matters; "only a clinician can tell which."
3. **Self-care that's actually evidence-based** — heat, movement, rest, sleep; what the evidence says and doesn't.
4. **Understanding pain relievers (education only)** — how NSAIDs work, why timing matters, general safety cautions, "not a dose — discuss with your clinician/pharmacist."
5. **Non-drug options** — TENS, exercise, acupressure, heat; realistic expectations.
6. **When period pain is worth checking** — the red flags (worsening, non-responsive, pain outside periods, dyspareunia/dyschezia/dysuria, heavy/abnormal bleeding); framed as "discuss with a clinician."
7. **Could it be endometriosis?** — what it is, why diagnosis is often delayed, how tracking helps; bridge to B7. (Awareness, not diagnosis.)
8. **Fibroids & adenomyosis** — brief, plain-language awareness of these secondary causes; bridge to B8/B9.
9. **Options a clinician might discuss (education only)** — hormonal therapy, further evaluation, imaging, referral — what they are and why. Clear non-prescription disclaimer.
10. **Getting the most from your appointment** — how to describe pain, what to bring, questions to ask, how to advocate if dismissed.
11. **Myths vs evidence** — "bad periods are just normal," "there's nothing you can do," "you're too young for endometriosis."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Cycle/bleed log** (flow, spotting, cycle length) — the anchor for pain-vs-bleeding timing.
- **Pain log (core of this persona):**
  - **Severity** — consistent scale (0–10 and mild/moderate/severe), captured per pain episode/day.
  - **Timing** — onset relative to bleeding (before / with / after flow), start day, duration in hours/days.
  - **Location** — via **pain body map** (tap regions: lower abdomen L/R/central, lower back, inner thighs, pelvic, radiating), each with an intensity marker; stored per cycle for a location-over-time view.
  - **Associated symptoms** — nausea, headache, loose stools, fatigue, dyspareunia, dyschezia/dysuria (flagged as red-flag-relevant), bleeding heaviness.
  - **Relief tried + effect** — heat, NSAID (educational, no dose stored as instruction), TENS, rest, movement; "helped / partly / no."
  - **Functional impact** — missed work/school, disrupted sleep/plans.

**Tools**
- **Pain map & severity trend** — the months-long visual (severity, duration, location, impact).
- **Relief-effectiveness insight** — descriptive association only ("appears associated with," never "caused by / will fix").
- **Visit-prep generator** — one-tap export/print: pain map + trend + red-flag checklist + questions.
- **Screeners / checklists (framed as screening/awareness, not diagnosis):**
  - **Primary-vs-secondary awareness checklist** → "These patterns can be worth discussing; only a clinician can tell what's causing your pain."
  - **Impact / pain-burden self-check** → routes to self-care content and, if high/persistent, to a clinician-check nudge.
  - **Mood/anxiety screen** (chronic pain load) → "screening, not a diagnosis" + crisis resources on low screens.

**Alerts (all non-alarming, screening/awareness-framed, dismissible, localized/RTL)**
- **Self-care nudge** — around expected pain onset, offer relevant educational self-care (heat, early NSAID education) — never a dose or a promise.
- **Clinician-check awareness prompt** — fires on red-flag *patterns*, not single entries: e.g. severe pain persisting despite self-care across **~3+ cycles**, pain logged **outside** the period, worsening severity trend, or logging of dyspareunia/dyschezia/heavy-bleeding flags. Copy: educational, cites why, suggests a clinician conversation, offers the visit-prep pack and B7/B8/B9 awareness content.
- **Never:** "you have endometriosis / a secondary cause"; never contraception/"safe day" claims; never disease-prevention or cure claims; never a medication dose.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, dysmenorrhea/pain-tracking mode ON).
- Cycle events: bleed start/end, flow, spotting; computed cycle-length range.
- Generic symptom log; mood/energy/sleep.

**Persona-specific (dysmenorrhea)**
- **Pain episodes:** date, severity (0–10 + band), onset-relative-to-bleeding, duration, and body-map location set (per episode/cycle).
- **Associated-symptom flags:** nausea, GI, headache, dyspareunia, dyschezia, dysuria, heavy/abnormal bleeding (the last several are red-flag-relevant booleans).
- **Relief log:** measure tried + subjective effect (educational; no dosing instructions stored).
- **Functional-impact log:** missed activity, sleep disruption (counts/dates).
- **Pain-pattern derivations (non-diagnostic):** severity trend direction, non-response-across-N-cycles counter, pain-outside-period flag — used only to drive awareness prompts and visit-prep, never a verdict.
- **Screener history:** impact/awareness checklist + mood-screen results (scores + dates, screening-only).
- **User-entered notes / prior clinician info** (optional, entry-only, no interpretation).
- TTC intent flag = **false** by default (reachable toggle).

*All health fields optional, encrypted, user-deletable. Red-flag booleans drive education/routing only — never a diagnosis label.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B3):**
- Q: life stage → "tracking my cycle / general." Q: cycles regular / irregular / a condition I know of → regular-or-any + **"my periods are painful"** ⇒ set **dysmenorrhea / pain-tracking mode ON**.
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false; suppress fertile-window/pregnancy nudges.
- Q: pain picture (multi-select: severity, misses activities, pain outside period, pain with sex/bowel/bladder, heavy bleeding, worsening over time) ⇒ tunes red-flag-awareness prominence and orders home modules. Selecting red-flag items raises (does not force) the "worth discussing with a clinician" content — never a diagnosis.
- Q: what she wants first (self-care now / understand my pain / prep for a visit) ⇒ orders home cards.

**Home configuration (default for B3):**
- Hero = **quick pain log** (severity + body map + timing) with the current-cycle pain summary and trend.
- Cards: self-care/management library, "primary vs secondary" explainer, visit-prep tool (pinned), pain-trend view.
- Fertile-window / pregnancy widgets **hidden by default** (reachable).

**Hidden-but-reachable principle:** Femio never *removes* knowledge. TTC, pregnancy, contraception education, endometriosis/fibroids/adenomyosis deep content, and other life-stage material remain discoverable via search and "Explore other life stages" — surfaced more prominently only when her logged pattern warrants (still as awareness, never diagnosis).

**Adaptive tuning:** if severe pain persists despite self-care across several cycles, or she logs pain outside her period / dyspareunia / worsening trend, raise secondary-cause **awareness** content (B7/B8/B9 bridges) + visit-prep prominence. If mood screens trend low under chronic-pain load, surface mental-health module + resources.

---

## J. Adaptation triggers (life-stage routing)

Inherits all **universal events** from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive pregnancy test; pregnancy loss; mood-screen-high/crisis; generic red-flag "seek care now"; disengagement; toggle-off; age-of-consent). Only **B3-specific** transitions below.

| Trigger | System response | Route |
|---|---|---|
| **Pain pattern suggests a secondary cause** — severe pain persisting despite self-care across ~3+ cycles, worsening severity trend, or pain logged **outside** the period | Non-alarming, screening-framed clinician-check prompt + "primary vs secondary" education + visit-prep pack; surface endometriosis awareness | **Bridge to B7 (endometriosis)** awareness — stay B3, raise screening prominence; explicit "discuss with a clinician," never a diagnosis |
| **Heavy / abnormal bleeding + bulk symptoms logged alongside pain** | Educational awareness of fibroid-pattern; clinician-check + visit-prep | **Bridge to B8 (fibroids)** awareness — stay B3 |
| **Very heavy, painful periods with a "boggy/enlarged" symptom picture or clinician-mention of adenomyosis** | Educational adenomyosis awareness; clinician-check + visit-prep | **Bridge to B9 (adenomyosis)** awareness — stay B3 |
| **Sets TTC intent = true ("start trying")** | Confirm; enable TTC layer; **carry full pain history forward** so it informs TTC context (pain/endometriosis can be relevant to fertility conversations); retain uncertainty-honest framing | **Route toward C-track (C1, or C7 if endometriosis already in the picture)** — keep pain-tracking, add TTC layer, carry pain EMR |
| **Positive pregnancy test logged** (universal handler) | Confirm sensitively; suppress fertile-window/TWW; carry pain history; note many people's dysmenorrhea changes post-pregnancy (educational) | Pregnancy band, pain history retained/archived-but-reachable |
| **Overlaps with irregular-cycle / PCOS signals** | Introduce irregular-cycle logic; keep pain tracking; clarify overlap | Blend with B6 emphasis; offer route |
| **Perimenopause overlap (late 30s–40s, changing pain/bleeding)** | Introduce perimenopause education; keep pain tracking; clarify overlap (adenomyosis/fibroids more common with age) | Blend toward F-track; offer route |
| **Mood screen trends low under chronic pain / crisis flag** | Surface mental-health module + localized crisis resources; screening-framed | Stay B3 |
| **User toggles off pain-tracking mode** | Revert to standard cycle logic; **preserve all pain history** (archived-but-reachable) | General reproductive-age band / B1 |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis (incl. no "primary vs secondary" verdict), no treatment, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Red-flag / secondary-cause prompts:** framed as **awareness that routes to a clinician**, based on *patterns not single entries*; never output "you have endometriosis/adenomyosis/fibroids." Every prompt ends with "discuss with a clinician."
- **Screeners:** every screener/checklist returns "This is a screening/awareness tool, not a diagnosis — discuss with a clinician." Never a diagnostic label.
- **Medication content (NSAIDs / hormonal / TENS):** educational context only — how it works, why timing matters, general cautions; **no recommendation, no dose, no "take this."** Clear non-prescription disclaimer + clinician/pharmacist routing. Hormonal content never framed as contraception advice.
- **Predictions:** pain-onset self-care nudges are educational reminders, not medical predictions or promises of relief. If any ovulation/fertility surface appears, add "not for contraception."
- **Mental health:** chronic-pain load — crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** health data = special-category; explicit granular consent, purpose limitation, no ad-SDK/third-party sharing of cycle/pain/health data (post-Flo trust); local-first where feasible; full export/delete. Pain-body-map and functional-impact data treated as sensitive. Data-mapping + DPIA before launch; export re-confirms sharing scope.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; framing as tracking/education/awareness keeps out of regulated-device territory — legal review before store submission.
- **Source boundary resolved:** no treatment-response or comparative-efficacy statistic is public. Endometriosis-awareness and referral framing use [ACOG CPG No. 11, March 2026](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2026/03/diagnosis-of-endometriosis); medicine and treatment choices remain clinician-led. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH/MedlinePlus/OWH/AHRQ/gov):**
- [Period Pain / Menstrual Cramps — MedlinePlus (NIH)](https://medlineplus.gov/periodpain.html)
- [Painful menstrual periods — MedlinePlus Medical Encyclopedia](https://medlineplus.gov/ency/article/003150.htm)
- [Period problems — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/menstrual-cycle/period-problems)
- [Period Pain — AHRQ Effective Health Care Program](https://effectivehealthcare.ahrq.gov/health-topics/period-pain)

**Clinical — Tier 2 (guidelines / society / peer-reviewed):**
- [ACOG Committee Opinion No. 760: Dysmenorrhea and Endometriosis in the Adolescent — PubMed](https://pubmed.ncbi.nlm.nih.gov/30461694/)
- [ACOG Committee Opinion No. 760 Summary — Obstetrics & Gynecology](https://journals.lww.com/greenjournal/fulltext/2018/12000/acog_committee_opinion_no__760_summary_.45.aspx)
- [Dysmenorrhea: Painful Periods — ACOG (patient FAQ)](https://www.acog.org/womens-health/faqs/dysmenorrhea-painful-periods)
- [Dysmenorrhea — American Family Physician (AFP 2021)](https://www.aafp.org/pubs/afp/issues/2021/0800/p164.html)
- [Dysmenorrhea — MSD / Merck Manual Professional Edition](https://www.merckmanuals.com/professional/gynecology-and-obstetrics/abnormal-uterine-bleeding/dysmenorrhea)
- [Dysmenorrhoea (Period Pain) — patient.info (professional)](https://patient.info/doctor/gynaecology/dysmenorrhoea)
- [Dysmenorrhea, a Narrative Review of Therapeutic Options — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11332412/)
- [Heat therapy for primary dysmenorrhea: systematic review & meta-analysis — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12876241/)
- [Self-care strategies for dysmenorrhea (12,526 young women): systematic review — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6655766/)
- [Effectiveness of self-care and lifestyle interventions in primary dysmenorrhea — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6337810/)
- [Endometriosis and Adolescence: The Impact of Dysmenorrhea — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10488856/)

**Consumer clinical references:**
- [Dysmenorrhea: Painful Periods, Causes & Treatments — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/4148-dysmenorrhea)
- [Dysmenorrhea — Johns Hopkins Medicine](https://www.hopkinsmedicine.org/health/conditions-and-diseases/dysmenorrhea)
- [When periods are painful — Mayo Clinic Health System](https://www.mayoclinichealthsystem.org/hometown-health/speaking-of-health/when-periods-are-painful)
- [Secondary dysmenorrhea: symptoms, causes, treatment — Medical News Today](https://www.medicalnewstoday.com/articles/secondary-dysmenorrhea)

**Competitor / app landscape & patient journey:**
- [Phendo — Citizen Endo (Columbia University)](https://citizenendo.org/phendo/)
- [The Five Helpful Endometriosis Apps You Need Now — EndoFound](https://www.endofound.org/the-five-helpful-endometriosis-apps-you-need-now)
- [Good-Quality mHealth Apps for Endometriosis Care: systematic search — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11845897/)
- [Best Period Tracker App for Endometriosis Pain — Kymara Health](https://www.kymarahealth.com/blog/best-period-tracker-endometriosis)
- [How to track endometriosis symptoms in Clue — helloclue.com](https://helloclue.com/articles/cycle-a-z/how-to-track-endometriosis-symptoms-with-clue)
