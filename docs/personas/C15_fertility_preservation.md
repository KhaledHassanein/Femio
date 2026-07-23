# C15 — Fertility Preservation: Elective Egg Freezing OR Pre-Oncology / Medical Preservation

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Femio never diagnoses, treats, or prevents disease, is **not contraception**, and **never provides medication dosing**. It does not run, order, adjust, or interpret medical tests, protocols, or medications. It helps a user **organize, understand, remember, and emotionally survive** a stimulation-and-retrieval cycle that her clinic (and, for medical cases, her oncology/gender-affirming team) directs. Every protocol, medication, monitoring, and result surface is framed as *"your clinic directs this — confirm every dose, date, and instruction with them."* Screeners and thresholds are *"screening / education — discuss with your clinician."*
> Persona code: **C15** · Cohort: Conception (C) · Shares the stimulation/retrieval engine with **C10 (ART/IVF)** — reuses the P3.1 protocol/med calendar, results log, and OHSS safety layer, re-skinned for *storing for the future* rather than *transferring now* · Last research pass: 2026-07-17

---

## A. Persona snapshot

C15 covers **two distinct paths that share one clinical engine** (ovarian stimulation → egg/embryo retrieval → freeze/store), but differ sharply in urgency, emotional load, and coordination. Femio must detect the path early and adapt.

| Field | **Path 1 — Elective ("planned") egg freezing** | **Path 2 — Medical / oncofertility preservation** |
|---|---|---|
| **Name (composite)** | "Nadia," 34 | "Salma," 31 (newly diagnosed breast cancer) — *also covers pre–gender-affirming and other medical reasons* |
| **Age band** | Late 20s–early 40s; often 33–39, deciding under a "reserve declines with age" clock. | Any reproductive age; onco cases skew younger (AYA — adolescents & young adults). Includes teens/young adults with a trusted-adult layer. |
| **Trigger to act** | Proactive, self-directed: "buying time," no current partner or not ready, career/life timing, a low AMH result, family history of early menopause. | **Reactive and time-critical:** a new diagnosis (cancer, or a condition needing gonadotoxic treatment) *or* an imminent start of **gender-affirming hormone therapy**, radiation, chemotherapy, or ovary-affecting surgery. Preservation must happen **before** treatment starts. |
| **Stage** | **One (or a few) stimulation-and-retrieval cycles to bank eggs (or embryos) for later.** Same injectables, monitoring, trigger, and retrieval as IVF — but she stops at the freezer; there is **no transfer, no two-week wait, no beta-hCG** this cycle. | Same physical cycle, but often on a **"random-start" protocol** that begins *immediately* (any day of the cycle) to fit inside a narrow window before treatment. May bank **eggs or embryos**; may add **ovarian tissue freezing** if there's no time to stimulate. |
| **Relationship** | Often solo-by-choice (a defining feature — she's freezing *because* the timing/partner piece isn't settled); also partnered, same-sex. | Varies. Embryo vs. egg freezing decision may hinge on a partner + on ethical/religious views; oocyte freezing is the strong default for those without a partner or with objections to embryo storage. |
| **Goal (top JTBD)** | *"Help me decide if and when to do this, set honest expectations about my age and how many eggs I really need, then run the injection-and-monitoring cycle without a mistake — and hold my frozen-egg count and storage details so future-me knows exactly what I banked."* | *"I'm terrified and on a clock. Help me move fast, keep my stimulation cycle straight while I coordinate with oncology, understand what I'm storing and my honest odds, watch me for OHSS — and don't make me feel like my whole future rides on this."* |
| **Health literacy** | Moderate–high, research-heavy; has read blogs/Reddit; anxious about "how many eggs is enough" and cost. | Overwhelmed, compressed learning curve; absorbing a diagnosis *and* a fertility decision in days. Needs plain, calm, fast orientation. |
| **Tech context** | Web-first + heavy phone; juggling a clinic portal, a paper med calendar, egg-count "calculators," and cost spreadsheets. | Same, plus a **second care team** (oncology / gender clinic) whose calendar constrains everything. Coordination and speed are the whole game. |
| **Locale** | Arabic-first / RTL first-class; also EN/FR/ES. Elective freezing carries stigma and secrecy pressure in many AR/MENA markets (often unmarried women); frequently self-funded. | Same, intensified. In some markets, unmarried egg freezing and embryo freezing raise legal/religious questions — Femio stays educational and secrecy-respecting, never advises on legality. |
| **Emotional state** | Ambivalence + relief + "insurance-policy" anxiety; grief about *needing* to do this; decision fatigue; cost strain; fear the eggs won't be "enough." | **Very high, acute distress** — layered on a cancer/serious diagnosis or a long-awaited transition. Grief, urgency, fear of delaying treatment, guilt, and hope all at once. Distress comparable to serious medical illness. |
| **What she is NOT** | Not trying to conceive *now* (no fertile-window, no TWW, no beta). Not in an evaluation-for-infertility workup (C2/C4). Not someone Femio doses or manages. | Not a patient Femio treats or triages. Femio never advises delaying/proceeding with cancer or hormone treatment, never interprets her cancer or her labs. |
| **Primary signals she brings** | Protocol type + start date, a **medication list with clinic-set timing**, monitoring appointments, streaming results (E2/estradiol, LH, follicle counts/sizes), **trigger date/time**, **retrieval date + eggs collected + eggs frozen (mature/MII)**, and **storage/consent details** (clinic, storage term, renewal dates). Plus a **cost ledger**. | All of the above, plus: a **treatment-start deadline**, an **oncology/gender-clinic contact**, possible **embryo count** (if fertilized), and possible **ovarian-tissue** note. Often a **random-start** flag. |
| **Success = she leaves us because…** | Cycle(s) complete → eggs/embryos banked → **she pauses tracking or returns to a C-cohort / general (B) state**, re-engaging years later when she thaws to try (→ C10 FET-style use) or transitions to menopause tracking (F). | Preservation done → **hands off to oncology/transition care**; Femio moves to a **low-touch, sensitive "we're here when you're ready" state**, retaining everything for a possible future return (thaw-to-use, survivorship, or condition tracking). |

**Persona thesis.** C15 is a **high-stakes, underserved, and structurally distinct** moment: the stimulation-and-retrieval machinery of IVF, but pointed at *the future*, not a pregnancy now. The market is lopsided — mainstream cycle trackers (Flo/Premom/Fertility Friend) go silent the instant stimulation starts and keep uselessly predicting a "fertile window"; the interesting players are **clinic/egg-freezing services** (Cofertility, Kindbody, Extend Fertility) that own acquisition, egg-count *calculators*, and member-advocate hand-holding — but they are **provider-locked, US-first, English-first, single-episode, and not privacy-/Arabic-first**, and none carry the user forward on one lifelong account. That is the whitespace. C15's unmet needs: (1) an **honest decision + expectation layer** (age → eggs-needed → probability *ranges*, never a promise); (2) a **clinic-mirroring protocol + medication calendar** with **non-dosing** injection/timing reminders (reused from C10); (3) a **results + retrieval log** that captures the outcome that matters here — **how many mature eggs / embryos were frozen** — in plain language, no verdict on her numbers; (4) **storage understanding** (how long, consent-renewal dates, what "stored" means); (5) a loud, referenced **OHSS red-flag safety layer**; (6) a **cost tracker**; and — for the medical/oncofertility path — (7) **urgent, sensitive, coordinate-with-your-other-team framing** that never makes her feel her entire future hinges on this one cycle. No mainstream women's-health app owns this on a privacy-first, Arabic-first, whole-lifespan account. That is C15's Femio thesis.

---

## B. Needs & questions (voice-of-user)

Mined from r/eggfreezing, r/fertility, r/IVF (freeze-all/FP threads), oncofertility communities, egg-freezing-service reviews (Cofertility, Kindbody, Extend Fertility), and clinic patient blogs. Phrasing is representative/composite (community norms; not quoting individuals). Community caveat noted in research: forum posts **skew toward the harder experiences** (rough reactions, lower-than-hoped egg counts), because distress drives people to post — Femio's tone must counterbalance without dismissing.

**Decision & expectation-setting (the elective-path hunger, before the cycle even starts):**
1. *"Should I even do this? Is 34 too late, or am I overthinking it — how much does one year actually change my odds?"*
2. *"How many eggs do I need to freeze to feel safe? Everyone quotes a different number."*
3. *"My clinic says I might get 12 eggs but only some are 'mature' — what's the difference and how many will actually survive the thaw?"*
4. *"How much is this really going to cost me — the cycle, the meds, AND the yearly storage fees no one mentions?"*
5. *"Is one cycle enough or will I need two? How do I know?"*

**Protocol & medication logistics (shared with C10, the cycle-critical layer):**
6. *"I have a paper calendar from the nurse, three med boxes, and a portal — I need one place that shows me what to take tonight."*
7. *"What time is my trigger shot? I'm terrified of getting the timing wrong and wasting the whole cycle."*
8. *"How do I do this injection, and how do I rotate sites so I stop bruising?"* (education, not dosing)
9. *"Which meds are the stims, which is the one that stops early ovulation, which is the trigger?"* (category education)

**Monitoring, retrieval & the number that matters here:**
10. *"My clinic called with my estradiol and follicle count — where do I write it down to see the trend?"*
11. *"They retrieved 14 eggs but only froze 9 — why? Is 9 good for my age?"* (wants category-level context, not a verdict)
12. *"What actually happens at retrieval? Will I be under? How sore after? And then what — I just… go home and they're frozen?"*

**Storage understanding (unique to C15 — the piece other apps drop):**
13. *"How long can my eggs stay frozen? Is there a legal limit? Do I have to renew consent?"*
14. *"Where are they actually stored, and what happens if I move, or if I never use them?"*
15. *"Frozen eggs vs. frozen embryos — which did I do, and why does it matter for later?"*

**Medical / oncofertility path (urgent, high-load, coordinating):**
16. *"I was just diagnosed and they say I have to decide about my fertility in a few days — before chemo. How is that even possible this fast?"*
17. *"Will freezing my eggs delay my cancer treatment? I'm scared to lose time."* (routes to oncology — Femio never advises on timing)
18. *"They mentioned a 'random start' so I don't have to wait for my period — what is that?"*
19. *"I'm about to start hormones for my transition — everyone says freeze eggs first. What does that involve and do I have to?"*
20. *"If there's no time to stimulate, they mentioned freezing ovarian tissue — what is that?"*

**Safety fears (the red-flag layer, shared with C10):**
21. *"My belly is swelling and tight after retrieval and I feel breathless — is this OHSS? When do I call vs. go to the ER?"*

**Emotional-arc needs (design must respect this):**
- Elective: ambivalence and grief that she *needs* an insurance policy at all; decision fatigue; the loneliness of often doing this solo; "is my number good enough" spirals.
- Medical/onco: a compressed, terrifying decision *on top of* a diagnosis; guilt about "spending time on fertility"; fear the cycle competes with treatment; hope she'll want a family on the other side of survivorship.
- Secrecy/stigma (esp. AR/MENA, unmarried women, workplaces) — she may be doing all of this while telling no one.

**Anti-needs / trust-breakers (churn drivers):**
- **Anything that looks like dosing or medical direction.** No dose, no dose change, no "your estradiol is too low," no "skip tonight's injection." Clinic's job, full stop.
- **False certainty on outcomes** — "freezing guarantees a baby later." It does not. Over-promising here is both a trust and an ethics failure.
- Toxic positivity or doom about her egg count / her odds.
- **For onco: any hint of triage, or of advising for/against/delaying treatment.** Femio never weighs in on her cancer or her transition timeline.
- A generic period-tracker still predicting a "fertile window" as if timed intercourse were the plan.
- Privacy creep — egg/embryo counts, a cancer or gender-identity flag, and storage records are among the most sensitive, stigmatized data a person can hold (post-Flo/Premom FTC distrust).
- Burying the OHSS warning-sign information when she's frightened after retrieval.
- Dropping her the moment the cycle ends, with no dignified "we'll keep this safe until you're ready" state.

**Feature requests recurring in reviews/forums:**
- An **honest egg-count / age → probability** explainer (ranges, "eggs needed rises steeply with age"), positioned as *education, not a guarantee*.
- A **medication calendar with reminders** mirroring the clinic protocol + **injection technique / site-rotation** guidance (educational).
- A **results + retrieval log** capturing eggs retrieved, **mature (MII) eggs frozen**, embryos (if any), across cycles.
- A **storage tracker** — clinic, storage start, consent-renewal reminders, term.
- A **cost/med-cost tracker** including recurring storage fees.
- Clear, calm **OHSS "when to call / when to seek emergency care"** guidance.
- For onco: a **fast-start orientation** and a **"coordinate with your oncology team"** framing.

---

## C. Competitor teardown

Feature-by-feature, focused on **the preservation cycle + the decision + storage + safety**. Key insight: unlike IVF (where dedicated trackers exist), egg-freezing's most sophisticated players are **service/clinic brands** that own the funnel with calculators and human advocates — but they are provider-locked, English-/US-first, single-episode, and not privacy- or Arabic-first. Nobody carries her forward on one lifelong, privacy-by-design account, and the **oncofertility urgency layer is almost entirely unserved by consumer software**.

| Product | What it's built for | Decision / expectation layer | Protocol / med calendar & injection reminders | Retrieval & storage log | Cost tracking | OHSS / safety | Onco / medical urgency | Where it fails C15 |
|---|---|---|---|---|---|---|---|---|
| **Cofertility (Freeze / Keep)** | Egg-freezing service + egg-sharing model + Member Advocate + peer community | Strong marketing-grade content + advocate guidance | Advocate/clinic-driven, not an in-app clinic-mirroring calendar | Service-side records | Pricing transparency (its model) | Educational content | None specific | US-first, English-first, provider-/service-locked; not a personal lifelong tracker; not privacy-/Arabic-first; no OHSS safety module; no onco urgency flow |
| **Kindbody** | Full-service fertility clinic + employer benefit; egg freezing | Egg-count **calculator** (how many eggs needed) | Clinic pushes schedule via its portal, locked to Kindbody | Strong **for its own patients**, siloed | Package pricing | Clinic messaging | Clinic handles onco referrals offline | Locked to one provider; results-only; English-/US-first; not portable, privacy-first, or Arabic-first; no lifespan continuity |
| **Extend Fertility** | Egg-freezing clinic | Egg-freezing **calculator** (age + indicators → eggs/cycle → cost) | Clinic portal | Siloed to clinic | Cost estimator | Basic | None | Single-clinic, English-/US-first; results-only; no independent, portable, multilingual account |
| **Embie / Berry Fertility / Stork (IVF trackers)** | ART cycle companions (some include egg-freezing mode) | Thin; IVF-outcome-oriented | Strong: med reminders, injection tutorials, stim tracking | Log results; **oriented to transfer/beta, not freeze-count/storage** | Limited | Some (Embie) — but edges toward "out of range" interpretation | None | English-first, US-centric, single-episode; freeze/storage & onco are afterthoughts; not privacy-/Arabic-first; no lifespan carry-forward |
| **Fertility-clinic patient portals** | Running *this* cycle at *this* clinic | None | Clinic pushes protocol — locked to that clinic | Strong for that clinic, siloed | No | No | Clinic-dependent | Locked to one provider; results-only; not portable/multilingual; you lose it if you switch clinics |
| **Flo / Ovia / Glow / Premom / Fertility Friend** | Mass-market cycle + fertile-window / OPK-BBT | None (assumes conception-now) | None for a stim protocol | No structured retrieval/storage home | No | No | No | Built for *timing* she's moved past; **FTC-era (Flo 2021, Premom 2023)** distrust for this most-sensitive data; abandons her at stimulation; irrelevant to freezing |

**The fragmentation map (the opening for Femio / P3.1-reuse):**
- **Timing tools** are irrelevant the day stimulation starts and mis-frame her as "trying now."
- **Egg-freezing services** (Cofertility/Kindbody/Extend) own the *funnel and the calculator* but are provider-locked, single-episode, English-/US-first, and not privacy- or Arabic-first.
- **IVF trackers** have the med-reminder/injection machinery but are oriented to transfer-and-beta, treat freeze/storage as an afterthought, and ignore oncofertility urgency.
- **Nobody** offers: an **honest decision + expectation** layer + a **clinic-mirroring protocol/med calendar** with **non-dosing** reminders + a **retrieval + mature-egg/embryo count + storage/consent-renewal tracker** + a **cost tracker (incl. storage fees)** + a loud, referenced **OHSS red-flag safety layer** + a **sensitive, urgent oncofertility "coordinate with your other team" flow** + **Arabic-first/RTL** + **privacy-by-design for ultra-sensitive data** + **one account that pauses gracefully and carries her forward** (thaw-to-use years later, survivorship, or menopause tracking). *That is C15's Femio thesis.*

---

## D. Clinical grounding (cited)

> All claims below are **patient-education framing**. Femio content is medically reviewed and cites primary sources. Femio does **not** direct protocols, dose or time medications, interpret *her* results, or advise on cancer/transition timing — it explains, in plain language, what a preservation cycle involves and routes every specific instruction to *"your clinic directs this — confirm with them."*

**What egg / embryo freezing is (the phase C15 is in):**
- **Fertility preservation** is saving or protecting eggs, embryos, or reproductive tissue to enable biological children in the future. [NCI; ACS; ReproductiveFacts]
- **Egg (oocyte) freezing:** mature eggs are retrieved from the ovary and frozen — now nearly always by **vitrification** (ultra-rapid freezing that prevents ice-crystal damage), which markedly improved egg-freezing outcomes. Eggs are thawed later, fertilized, and transferred as embryos. Works without a partner. [NCI; ACS; MedlinePlus]
- **Embryo freezing:** eggs are retrieved and **fertilized** (with partner or donor sperm) into embryos, which are frozen. It has the **strongest effectiveness data** of the cryopreservation options but requires sperm and raises embryo-status considerations some decline. [ASCO; NCI]
- **Ovarian tissue freezing:** a minimally invasive surgery removes and freezes ovarian tissue (containing immature eggs); usable when there is **no time to stimulate** (urgent onco cases) or before puberty; may later be re-implanted. Increasingly established but still specialized. [NCI; ACS]

**The stimulation-and-retrieval cycle, step by step (education only — the clinic sets every date/dose; identical machinery to C10 up to the freezer):**
1. **Ovarian stimulation:** injectable gonadotropins (FSH ± LH) stimulate multiple follicles, monitored by blood tests and ultrasound. [MedlinePlus; NCI]
2. **Monitoring:** serial **transvaginal ultrasounds** (follicle number/size) and **bloods** (estradiol/E2, LH) track response and time the trigger. [MedlinePlus]
3. **Trigger shot:** when follicles reach target size, a **trigger** (hCG or GnRH-agonist) matures the eggs; **retrieval occurs ~35–36 hours later** — timing is exact and clinic-set. A GnRH-agonist trigger is one of the clinic's OHSS-risk-reduction tools. [education sources; ASRM]
4. **Egg retrieval:** a minor transvaginal-ultrasound-guided procedure (usually under sedation) aspirates follicular fluid to collect eggs. [MedlinePlus]
5. **Freeze (the C15 endpoint):** mature (**MII**) eggs are vitrified and stored — *or* eggs are fertilized and the resulting **embryos** frozen. **There is no transfer, no two-week wait, and no beta-hCG this cycle** (the key clinical difference from C10). [NCI; ACS]

**"Random-start" stimulation (central to the oncofertility path — see §I/§J):**
- **Random-start** stimulation begins **regardless of menstrual-cycle phase**, often within **~24–48 hours** of consult, instead of waiting for the early-follicular phase. This shortens the time to retrieval — critical when cancer treatment must start soon — with **oocyte yield and maturity comparable** to conventional-start. [PubMed 28786354; PMC9345281; ScienceDirect]
- Conventional protocols take **~2 weeks** of stimulation before retrieval; random-start lets urgent patients preserve inside a narrow pre-treatment window. [PMC; PubMed]

**Oncofertility urgency & coordination (grounds the medical-path tone — see §G/§I):**
- Providers should **discuss fertility as early as possible** — **at diagnosis and before treatment** — to allow the widest array of options; and again through survivorship. [ASCO 2025 guideline update]
- **Embryo and oocyte cryopreservation are established methods**; embryo has the strongest effectiveness data, but the **egg-vs-embryo choice is the patient's**, after counseling on effectiveness, personal wishes, cost, ethics/religion, and legal landscape. Oocyte freezing is favored without a partner or where embryo storage is objectionable. [ASCO]
- Timing matters biologically: because of oocyte-development timelines, there may be **no usable oocyte yield within ~3 months of the last chemotherapy dose** — reinforcing "before treatment." [ASCO]
- **Femio guardrail:** Femio never advises whether to preserve, whether to delay treatment, or egg-vs-embryo — it **explains options and routes the decision to her oncology + fertility teams.**

**Gender-affirming-care path (a medical/elective hybrid — see §I):**
- **WPATH, the Endocrine Society, and ASRM** all recommend fertility-preservation **counseling before starting gender-affirming hormone therapy**, which may compromise gonadal function. Egg/embryo (or, for others, sperm) freezing before hormones is the common route; successful stimulation and pregnancies have been reported even after prior testosterone use. Uptake remains low (<5%). [ASRM Ethics Committee 2021; WPATH/Endocrine Society; PMC reviews]
- **Femio guardrail:** supportive, affirming, educational; never advises on transition timing or medication.

**Storage understanding (a C15-specific pillar other apps drop — see §F/§H):**
- Frozen eggs/embryos can be stored **long-term**; regulations vary by country. In the **UK**, since **1 July 2022**, eggs/sperm/embryos can be stored for **up to 55 years**, but consent must be **renewed every ~10 years**; clinics must lawfully dispose of gametes once consent lapses/expires. [HFEA] Other regions differ — Femio presents this as **region-dependent education**, never legal advice.
- What "stored" means, consent-renewal, moving/transferring storage, and disposition choices are core patient questions Femio should explain (educationally). [HFEA; clinic education]

**Success / expectation honesty by age (grounds the uncertainty-honest tone — see §I/§K):**
- **Thaw survival:** ASRM modeling assumes ~**95%** oocyte survival for age **<36** and ~**85%** for **≥36**; real-world warming survival is high but declines with age (e.g., ~**93–94%** at 35–37 vs. ~**80%** at ≥43). [PMC oocyte-cryo reviews; Extend Fertility data]
- **Live birth per thaw case** falls with **age at freezing**: roughly ~**64% at ≤35**, ~**42% at 36–39**, ~**18% at ≥40** (cohort figures; vary by dataset). [PMC cohort/reviews; HFEA]
- **"How many eggs" rises steeply with age:** to reach ~**70%** probability of at least one live birth, models suggest ~**10 mature eggs at ≤35**, but roughly ~**20 at 38**, ~**35 at 40**, and ~**55 at 42**. [Human Reproduction counseling model, Goldman et al.] HFEA-cited figures similarly show under-35 freezing of ~12 eggs ≈ 40–50% chance, ~20 eggs ≈ 75–80%.
- **Design implication:** always show **ranges + "per eggs frozen at your age," not a guarantee**; "freezing is an insurance policy, not a promise"; more than one cycle is often needed; **a frozen egg is not a guaranteed baby.** [ASRM; HFEA; Hum Reprod model]

**OHSS — Ovarian Hyperstimulation Syndrome (the shared red-flag safety spine — see §G):**
- OHSS is an **uncommon but potentially serious complication** of ovarian stimulation, where the ovaries over-respond and fluid shifts into the abdomen (and, in severe cases, the chest). [ASRM/ReproductiveFacts; MedlinePlus; RCOG]
- **Mild:** bloating, mild abdominal discomfort, nausea, slight weight gain. **Moderate–severe:** rapidly worsening abdominal swelling/tightness and pain, persistent vomiting, **shortness of breath / difficulty breathing**, **reduced/dark urine**, rapid weight gain, and **calf/leg pain or swelling** (possible clot). [ASRM 2023; MedlinePlus; NHS trust leaflets; Mayo]
- **Timing:** can appear in the days after **egg collection**; note that in *pure freezing cycles there is no pregnancy to prolong it*, so the later, pregnancy-driven onset seen in fresh-transfer IVF is **not** a factor here — but post-retrieval OHSS still requires the full warning-sign vigilance. [NHS leaflets; ASRM]
- **Seek-care framing (education):** contact the fertility clinic promptly for new or worsening possible OHSS symptoms. Seek urgent local care for breathing difficulty, chest pain, a swollen/tender leg, severe or worsening abdominal pain, persistent vomiting, or markedly reduced/dark urine. Femio does not grade severity or advise staying home. ([RCOG OHSS](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/ovarian-hyperstimulation-syndrome/); [ASRM 2023 guideline](https://www.asrm.org/practice-guidance/practice-committee-documents/prevention-of-moderate-and-severe-ovarian-hyperstimulation-syndrome-a-guideline-2023/); [reviewed rule](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md))

**Emotional impact (grounds the support layer):**
- Distress around fertility preservation is high; the **onco/medical path adds acute grief and time pressure** on top of a diagnosis, and elective freezing carries ambivalence, decision fatigue, cost strain, and (often) the loneliness of doing it solo. Distress in this space can be **comparable to serious medical illness.** [ASRM/SART patient guidance; oncofertility literature]

*Femio applies all of this as **education, organization, reminders, honest expectation-setting, and emotional support**, always ending *"your clinic directs your treatment — confirm every dose, date, and instruction with them; your oncology/transition team owns those decisions"* — never as a dose, a protocol decision, a result interpretation, a diagnosis, or advice on cancer/transition timing.*

**Open numeric/legal items:** thaw survival, per-age live-birth estimates, eggs-needed targets, random-start/retrieval timing, storage terms, and egg-vs-embryo effectiveness remain separately tracked. The OHSS symptom/action list is resolved in [`REPRODUCTIVE_TREATMENT_SAFETY.md`](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md) and does not assert a region-specific onset window.

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; largely reuses the C10 / P3.1 engine, re-skinned to "freeze & store"):**
1. **Honest decision & expectation layer (the C15 signature).** An **education-only** explainer that maps **age → thaw survival → eggs-needed → probability *ranges*** for at least one future live birth, plus "one cycle may not be enough" and "a frozen egg is not a guaranteed baby." Framed as *insurance policy, not promise*; **never a personalized prediction or a verdict on her AMH/egg count.**
2. **Protocol & medication calendar (clinic-mirroring, non-dosing).** Reused from C10: enter the clinic's protocol (antagonist / mini / **random-start**), med names, days, and **clinic-set times**; Femio renders "tonight / tomorrow / trigger day." **Never suggests, supplies, or changes a dose/time.** Supports **random-start** (no cycle-day anchor) for medical cases.
3. **Injection & timing reminders (educational, never dosing).** Opt-in reminders at *user-entered, clinic-set* times, **prominent exact trigger reminder**, plus injection technique / site-rotation education.
4. **Retrieval & storage log (the C15-specific endpoint).** Capture **eggs retrieved, mature (MII) eggs frozen** (and/or **embryos frozen**), plus **storage details**: clinic/bank, storage-start date, **consent-renewal date + reminder**, storage term, disposition notes — each with plain-language explainers, **no verdict on her counts.** Comparable across cycles.
5. **OHSS red-flag safety layer (see §G).** Reused from C10: always-reachable, unmissable "warning signs & when to seek care," auto-surfaced **stimulation → post-retrieval**, with a **"seek care now"** box + saved clinic/emergency contact (education, not triage).
6. **Cost tracker (incl. recurring storage fees).** Log cycle, medication, and **annual storage** charges; per-cycle and cumulative totals; region-aware; **education only.**
7. **Medical / oncofertility urgency flow (the sensitive, time-critical path).** When the path is medical/onco/pre-transition: fast-start orientation, a **"coordinate with your oncology / gender-affirming team"** framing, an **other-team contact + treatment-start deadline** field, calmer "your future doesn't hinge on one number" tone, and **never** advice on treatment timing or egg-vs-embryo.
8. **Emotional-support layer, path-calibrated.** Elective: ambivalence/decision-fatigue/"is my number enough"/solo-journey support. Medical: acute-diagnosis, urgency, and grief support; mood/anxiety **screener** (screening-framed, localized crisis resources).

**P1 — Strong differentiators (fast follow):**
9. **Referenced content library** on every component (egg vs. embryo vs. tissue, stimulation, random-start, monitoring, retrieval, vitrification, storage/consent, OHSS, oncofertility, gender-affirming preservation, honest odds) — grade 6–8, 4 languages, RTL-first.
10. **Cycle timeline & cross-cycle comparison** (e.g., two banking cycles), portable to any provider.
11. **Storage "vault" summary card** — a durable, at-a-glance record of what she banked, where, and when consent renews — designed to **survive years of dormancy** so future-her (or a future clinician) can pick it up.
12. **Partner mode** (embryo-freezing or supportive partner) — calendar view, injection-night reminders, consent-gated, revocable.
13. **Data/timeline export (PDF/image)** for any clinician of her choosing.
14. **Graceful pause + return** — a first-class "banked, tracking paused, we'll be here" state (see §J).

**P2 — Nice-to-have / later:**
15. Moderated, privacy-safe preservation community (guarded against dosing advice and false-hope/doom; counterbalancing forum negativity-skew).
16. Egg-count / cost planning **educational calculators** (ranges only, no promise).
17. Stigma-aware AR/MENA content (elective freezing for unmarried women; embryo/legal considerations framed as *educational, discuss locally*).
18. AYA / trusted-adult layer for adolescent onco preservation.

**Explicitly OUT of scope for C15 (guardrail):**
- **Any medication dose, dose change, timing decision, or "skip/take" instruction.** Femio mirrors and reminds the *clinic's* schedule; never originates or alters it.
- **Advising whether to preserve, whether to delay/proceed with cancer or hormone treatment, or egg-vs-embryo.** Those belong to her oncology/fertility/gender teams.
- **Interpreting her results** (E2, follicle counts, AMH, egg/embryo counts) — category education only.
- Diagnosing, triaging, or managing **OHSS** — educate + "seek care now," never assess severity.
- **Predicting her personal outcome** or promising a future baby. Ranges + "not a guarantee" only.
- **Legal advice** on storage terms, embryo status, or eligibility — region-dependent education only.
- Any "safe day / avoid pregnancy / contraception" framing. **Never.**

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries source citations, a medical-review byline + date, and *"not medical advice — your clinic directs your treatment; your oncology/transition team owns those decisions; confirm every dose and date with them."*

- **"Thinking about freezing your eggs?"** — what it is, who does it and why (elective vs. medical), what to expect — calm, non-directive.
- **"Egg freezing vs. embryo freezing vs. ovarian tissue"** — what each *is*, what each needs (sperm? time? surgery?), why someone might choose each (never "you should do X").
- **"How many eggs is 'enough'? Honest expectations by age"** — thaw survival, eggs-needed *ranges*, "insurance policy, not a promise," one-cycle-may-not-be-enough. **No personal prediction.**
- **"Your stimulation cycle, step by step"** — stims → monitoring → trigger → retrieval → freeze (calm; note *no transfer/TWW/beta this time*).
- **"Random-start stimulation — starting right away"** — for time-critical (onco/pre-transition) cases: what it is, why it lets you start now.
- **"Your medications, by category"** — stims (FSH/LH), the antagonist, the trigger: *what each type does.* **No doses, no schedules — those come from your clinic.**
- **"Injections: technique & comfort"** — how injections are given, site rotation, needle-anxiety coping (educational how-to, not dosing).
- **"The trigger shot — why timing is exact"** — what it does, why retrieval is ~35–36h later; confirm your exact time with your clinic.
- **"Monitoring: your scans & bloods"** — what estradiol, LH, follicle counts/sizes *measure* (not what *your* number means).
- **"Egg retrieval — what to expect"** — procedure, sedation, aftercare, normal soreness vs. warning signs (links to OHSS module).
- **"After retrieval: what 'frozen and stored' means"** — mature (MII) eggs, vitrification, and then storage.
- **"Storage, consent & how long eggs can stay frozen"** — region-dependent (e.g., UK 55-year limit, 10-year consent renewal), what happens if you move/never use them — *education, discuss locally, not legal advice.*
- **"OHSS — warning signs & when to seek care"** *(safety-critical; see §G)* — mild vs. severe, the **"seek care now"** list, timing after retrieval.
- **Oncofertility — "Preserving fertility before cancer treatment"** — the urgency, the options, coordinating with your oncology team; *your cancer decisions are theirs and yours, not Femio's.* Sensitive, hopeful-but-honest.
- **Gender-affirming care — "Fertility preservation before starting hormones"** — affirming, educational; counseling-recommended; never advises on transition timing.
- **"The emotional side of preserving your fertility"** — ambivalence, solo-journey, diagnosis-grief, urgency, couple communication, when to seek mental-health support; crisis resources.
- **"Cost of preservation (education)"** — cycle + meds + **recurring storage fees**; planning across cycles (no financial advice).
- **Stigma-aware module (AR/MENA-first)** — preservation as a private medical matter; secrecy-respecting design; embryo/legal considerations framed as *discuss locally*.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so C15 never feels boxed into "freezing only."

---

## G. Tools, logs & alerts (compliant framing)

**Logs (inputs):**
- **Path flag:** elective | medical-onco | pre-gender-affirming | other-medical (drives tone, urgency, other-team fields).
- **Protocol setup:** protocol type (antagonist / mini / **random-start** / other), cycle start date, **treatment-start deadline** (medical path), medication *list* with **user-entered, clinic-set** days & times.
- **Medication log:** taken/missed check-off per scheduled item (a memory aid — **never a dose recommendation**), injection-site rotation notes.
- **Monitoring results (self-entered, entry-only, never machine-interpreted):** estradiol/E2, LH, follicle counts & sizes, dates.
- **Procedure & outcome log:** trigger date/time, retrieval date + eggs collected, **mature (MII) eggs frozen**, **embryos frozen** (if fertilized), ovarian-tissue note (if applicable).
- **Storage record:** clinic/bank, storage-start date, **consent-renewal date**, storage term, disposition notes.
- **Appointments:** monitoring visits, procedure dates, which are fasting/early; **other-team (oncology/gender-clinic) contact + appointments** for the medical path.
- **Cost ledger:** cycle, medication, and **recurring storage** charges; per-cycle and cumulative.
- **Symptom/side-effect & mood log** (hormonal effects, injection-site reactions); mood/anxiety screener history (scores + dates, screening-only).

**Tools:**
- **Honest expectation explainer** (age → survival → eggs-needed **ranges**; "not a guarantee").
- **Protocol & medication calendar** (clinic-mirroring; "tonight / tomorrow / trigger day"; **random-start** shape).
- **Results log** with plain-language category explainers + cross-appointment / cross-cycle trend view.
- **Retrieval & storage "vault" card** (eggs/embryos frozen, where, consent-renewal countdown).
- **Cost tracker** (per-cycle + cumulative + storage fees).
- **Cycle timeline & comparison**; PDF/image export.
- **OHSS safety module** (always reachable; auto-surfaced stims→post-retrieval).
- **Medical-path coordination card** (other-team contact + treatment-start deadline; "coordinate with them").
- Mood/anxiety screener (PHQ-2 / GAD-2-style) → screening-framed output + localized crisis resources.

**Alerts / nudges (all opt-in, tone-calibrated, dismissible, revocable, RTL-aware):**
- **Injection & timing reminders** *at the user-entered, clinic-set times only:* e.g. *"Evening injections tonight at the time your clinic set — as directed by them. Confirm anything you're unsure of with your clinic."* **No dose is ever stated or suggested by Femio.**
- **Trigger-shot reminder (prominent, exact):** *"Your clinic set your trigger for [time you entered]. Timing is important — double-check the exact time with your clinic."*
- **Monitoring reminders:** *"Monitoring scan tomorrow morning — add last results so your log is current."*
- **Consent-renewal reminder (C15-specific):** *"Your storage consent may be due for renewal around [date you entered]. Check with your clinic so your eggs/embryos stay stored — rules vary by country."*
- **Emotional-arc cards:** decision-support (elective), fast-start reassurance (medical), stims-fatigue, pre-retrieval steadying, post-retrieval recovery, results/egg-count support (honest, never a verdict).
- **Screening follow-up** + crisis resources on any low screen.

**OHSS red-flag "seek care now" box (safety-critical, mandatory):**
> **⚠️ Watch for OHSS.** Some bloating and mild discomfort after your injections or egg collection can be normal. **But contact your fertility clinic promptly if your tummy swelling or pain is clearly getting worse, you're vomiting and can't keep fluids down, or you're passing much less (or very dark) urine.**
> **Seek urgent / emergency care now if you have: shortness of breath or trouble breathing, severe or constant abdominal pain, or pain/swelling in a calf or leg.**
> These can be signs of OHSS, an uncommon but serious complication of fertility medication. In a freezing cycle there's no pregnancy to prolong it, but the days after egg collection still need this vigilance. *This is general information, not a diagnosis — your clinic and emergency services decide what you need.* [ASRM 2023; MedlinePlus; RCOG]

- Saved **clinic + emergency contact** shown as *education/quick-reach*, never triage or a severity assessment. Femio **does not grade OHSS or tell her to stay home** — worsening/severe symptoms always route to "seek care now."

**Mandatory compliance wording on relevant surfaces:**
- *"Femio helps you organize and remember the treatment your clinic directs — it does not prescribe, dose, time, adjust, or interpret your medications, tests, or results. Only your clinic can do that."*
- On every medication/reminder surface: *"Doses and timing come from your clinic. Femio never changes them — confirm anything you're unsure of with your clinic."*
- Medical/onco surfaces: *"Decisions about your cancer or hormone treatment — including timing — belong to you and your oncology / gender-affirming team. Femio does not advise on them."*
- Expectation surfaces: *"Estimates and ranges only — not a guarantee. Freezing is an insurance policy, not a promise of a future baby. Your clinic can explain your specific chances."*
- Storage surfaces: *"Storage rules and time limits vary by country and clinic — this is general information, not legal advice. Confirm your terms and renewal dates with your clinic."*
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (from screeners, non-diagnostic).
- `content_history[]`, `screener_results[]` (with timestamp + "non-diagnostic" tag).

**C15 persona-specific (reuses the P3.1 IVF schema, adds preservation/storage fields):**
- `preservation_cycle[]` {cycle_number, **path: elective | medical_onco | pre_gender_affirming | other_medical**, freeze_type: **eggs | embryos | ovarian_tissue**, protocol_type: antagonist | mini | **random_start** | other, cycle_start_date, status: active/complete/cancelled}.
- `medical_context` {reason_note (free text; **stored with elevated sensitivity**), other_care_team: {type: oncology | gender_affirming | other, contact}, treatment_start_deadline} — **entry-only; a diagnosis/gender flag is ultra-sensitive (§K).**
- `protocol_medications[]` {med_name, med_category (stim/antagonist/agonist/trigger/other), days[], **user_entered_time**, source_note} — **entry-only; Femio stores/reminds the clinic's schedule, never a dose it originates or recommends.**
- `medication_log[]` {med_ref, date, taken/missed, injection_site, note}.
- `monitoring_results[]` {type (E2, LH, follicle_count, follicle_sizes[]), value, unit, date} — **entry-only, no interpretation.**
- `retrieval_outcome[]` {trigger_datetime, retrieval_date, eggs_collected, **mature_eggs_frozen (MII)**, embryos_frozen, ovarian_tissue_note} — **entry-only, no verdict.**
- `storage_record[]` {clinic_or_bank, freeze_type, storage_start_date, **consent_renewal_date**, storage_term, disposition_note, status} — drives the vault card + renewal reminder.
- `appointments[]` {clinic, type (monitoring/procedure/other_team), datetime, fasting_flag, status}.
- `cost_ledger[]` {item, category (meds/procedure/**storage_fee**/other), amount, currency, date, recurring?} — education only.
- `ohss_watch_flag` (active stims→post-retrieval), `ohss_ack_ts`.
- `expectation_ack_ts` (she has seen the honest "not a guarantee" framing).
- `emotional_state_tags[]` (deciding / stims / pre-retrieval / post-retrieval / results / banked-paused) — drives support-card selection.
- `mood_screen_history[]` {tool, score, date} (screening-only).
- `cycle_outcome` {banked: eggs/embryos/tissue → **paused_state_ref**; or cancelled}.
- `partner_link_id`, `partner_scope`, `partner_consent_ts` (embryo/support cases).

*Data-minimization & heightened sensitivity: egg/embryo counts, a **cancer or gender-identity flag**, and storage records are among the most stigma-sensitive special-category health data; encrypted, user-deletable, never shared with ad networks/analytics; retention limits on any uploaded protocol sheets/photos. The medical-context reason and gender-identity flags get the strictest handling. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C15 — direct, or routed from B1/C1/a screening/"my clinician told me" entry):**
1. "What brings you to Femio?" → *Trying to conceive / fertility* → *"I'm freezing my eggs or embryos to use later (fertility preservation)."*
2. **Path split (critical):** "Is this **elective** (planning ahead), or for a **medical reason** — before cancer treatment, before starting gender-affirming hormones, or another medical reason?" ⇒ sets `path`, tone, urgency, and whether the **other-care-team + deadline** fields appear.
3. "What are you freezing?" → **eggs / embryos / (ovarian tissue)** ⇒ `freeze_type`.
4. "Has your clinic given you a protocol?" → protocol type incl. **random-start** + cycle start ⇒ shapes the calendar (random-start has no cycle-day anchor).
5. "Want to add your medication schedule?" → guided entry of med **names, days, clinic-set times** (with the *"we mirror your clinic; we never dose"* notice) ⇒ builds reminders.
6. Age capture ⇒ **honest expectation explainer** (age → survival → eggs-needed ranges; "not a guarantee"); records `expectation_ack_ts`.
7. "Where are you in this?" (deciding / stims / post-retrieval / banked) ⇒ home emphasis, **OHSS watch**, emotional-phase tag.
8. **(Medical path only)** "Who's your other care team, and is there a treatment-start date?" ⇒ coordination card + calmer "your future doesn't hinge on one cycle" framing.
9. "Involve a partner?" → partner mode (calendar view, injection-night reminders), consent-gated.
10. Consent & privacy choices (explicit sensitivity notice; **extra care for a cancer/gender flag**; secrecy/stigma notice).

**Home config for C15:**
- **Elective, deciding phase:** hero = **honest expectation explainer + "is this right for me" content**; secondary = cost planning, cycle-overview content.
- **In-cycle (both paths):** hero = **today's protocol** (what's due tonight/tomorrow, next monitoring, days-to-trigger/retrieval); persistent **OHSS safety card** while `ohss_watch_flag` active.
- **Medical path:** add a **coordination card** (other-team contact + treatment-start deadline) high on the home; tone = urgent-but-calming, sensitive; **suppress "how many eggs is enough" spirals** in favor of "you're doing what you can, on your timeline."
- **Post-retrieval / banked:** hero → **storage vault card** (what you banked, where, consent-renewal countdown); then a graceful **"tracking paused — we'll be here"** state.
- **De-emphasize** any fertile-window / TWW / beta hero — **there is no two-week wait or beta in a freezing cycle**; keep general content reachable, never the narrative.
- **Hidden-but-reachable:** full lifespan library, condition pages, contraception *education*, perimenopause — one search/tap away.

**Adaptive tone:** steady, precise, warm, honest. **Elective:** validate ambivalence and the solo journey; never pressure; honest about odds without doom. **Medical/onco:** gentle urgency, acute-diagnosis sensitivity, hope-without-false-promise, and a constant "your cancer/transition decisions belong to your other team." Surface mental-health module + resources if mood screens trend low. **Never** toxic-positive, **never** a verdict on her egg count, **never** medical direction about meds or treatment timing.

---

## J. Adaptation triggers (state transitions)

C15 **inherits all universal events** from the Master Adaptation Model §6 (positive test, loss, mood-screen-high/crisis, red-flag symptom, disengagement/"taking a break," toggle-mode-off, age-of-consent). The table below adds only **C15-specific** transitions.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Arrives into preservation (direct, or from B1/C1)** | user reports freezing eggs/embryos; picks a path (elective / medical-onco / pre-transition / other) | Sensitive confirm; **path-split** sets tone/urgency; activate expectation explainer, protocol/med calendar, injection/timing reminders, results log, storage record, cost tracker, OHSS safety card; carry all prior data forward. | **Become C15** (P3.1 reuse) |
| **Medical / oncofertility path selected** | path = medical_onco or pre_gender_affirming; other-team + deadline entered | Urgent-but-calming tone; surface **coordination card**; sensitive framing ("your cancer/transition decisions belong to your other team; your future doesn't hinge on one number"); AYA/trusted-adult layer if minor. | Stay C15 (medical variant) |
| **Random-start protocol** | user enters random-start (no cycle-day anchor) | Calendar adapts to immediate start; explain random-start; raise readiness for compressed timeline. | Stay C15 |
| **Trigger scheduled** | user enters trigger date/time | Prominent exact-time reminder (*of her entry*); pre-retrieval steadying content; raise OHSS watch. | Stay C15 (retrieval sub-phase) |
| **Post-egg-retrieval** | retrieval date logged | Aftercare content; **OHSS red-flag card foregrounded**; prompt to log eggs collected + **mature eggs / embryos frozen**. | Stay C15 (OHSS-watch high) |
| **Eggs / embryos banked (cycle complete)** | freeze counts + storage record logged | Honest, warm close ("you did this — an insurance policy, not a promise"); build **storage vault card** + **consent-renewal reminder**; offer **another cycle** (if more eggs wanted) or the **graceful pause state**. | Stay C15 → **paused/banked** or next cycle |
| **Banked → tracking paused ("return later")** | user opts to pause after banking | Suppress cycle nudges; **keep everything**; low-touch wellness content; keep consent-renewal reminder live; "we'll be here when you're ready." | **Paused state** (returns later to C-cohort thaw-use, or B1/F menopause tracking) |
| **Returns years later to use frozen eggs/embryos** | user reports thawing/using stored eggs | Reactivate as a **C10 FET-style / ART use flow**, carrying the stored-count + storage history forward unchanged. | **C10** (thaw-to-transfer) |
| **Cycle cancelled / poor response** | user records cancellation or very low yield | Grief-aware, non-blaming tone ("this happens; it isn't failure"); explain options; offer another cycle; retain everything. | Stay C15 (retry) or paused |
| **OHSS warning signs reported/severe** | user logs worsening/severe symptoms | Foreground **"seek care now"** box + saved clinic/emergency contact as *education* (never triage/severity grading); log stays raw. | Emergency messaging (content only), stay C15 |
| **Onco path — post-preservation handoff to treatment** | user indicates starting cancer treatment | Sensitive handoff; move to **low-touch survivorship-aware state**; suppress cycle nudges; retain all data (incl. storage); "we're here when you're ready." | **Paused / survivorship-aware**, later optional C-cohort or condition tracking |
| **Cost strain / considering stopping** | user flags cost concern or "pausing" | Cost-education content (no financial advice); pause nudges if pausing; preserve all data. | Retain, low-touch |
| **Mood screen trends low / crisis flag** | screener threshold crossed | Surface mental-health module + localized crisis resources; screening-framed. | Stay C15 |

*All routes preserve data continuity (one account) and always route medical/medication/results/OHSS specifics to the clinic, and cancer/transition-timing decisions to her oncology/gender-affirming team — never a dose, protocol decision, result interpretation, diagnosis, or treatment-timing advice. Post-preservation, C15 is designed to **pause gracefully and hold everything** for a possible return years later.*

---

## K. Compliance flags

1. **No diagnosis / treatment / prevention; no dosing; no test/result/protocol interpretation (highest-priority guardrail).** Femio **mirrors and reminds** the clinic's protocol/medication schedule and **organizes** results/counts — it never prescribes, doses, times, adjusts, selects a protocol, or interprets *her* values (E2, follicle counts, AMH, egg/embryo counts). Medication content is **educational (category-level), never a dose.** **[NEEDS SOURCE — confirm current app-store medical-claims + medical-device scope wording at ship.]**
2. **No advice on cancer or gender-affirming treatment (C15-critical).** Femio **never** advises whether to preserve, whether to delay/proceed with treatment, egg-vs-embryo, or transition timing. These belong to the user and her oncology / fertility / gender-affirming teams. Every medical-path surface routes decisions there. [ASCO 2025; ASRM] **[NEEDS SOURCE VERIFICATION AT PUBLISH.]**
3. **OHSS safety layer is mandatory and must not be buried.** Use the reviewed RCOG-aligned symptom/action list in [`REPRODUCTIVE_TREATMENT_SAFETY.md`](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md), show the saved clinic and local-emergency route, and never grade severity or advise staying home. No region-specific onset window is asserted. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
4. **Not contraception.** Any retained cycle surface is awareness/education only; never "safe/infertile day" language.
5. **Uncertainty honesty / no false hope — "insurance policy, not a promise."** Age-anchored thaw-survival and eggs-needed **ranges**; "a frozen egg is not a guaranteed baby"; multiple cycles common. Never a personalized outcome prediction; never doom. [ASRM; HFEA; Goldman et al. Hum Reprod] **[NEEDS SOURCE VERIFICATION AT PUBLISH — per-age survival/eggs-needed figures.]**
6. **Storage is region-specific education, not legal advice.** Storage terms, consent-renewal, embryo status, and eligibility vary by country (e.g., UK 55-year limit + 10-year renewal ≠ US ≠ AR/MENA); Femio localizes as education and routes to clinic/local rules. [HFEA] **[NEEDS SOURCE — localize per region at publish.]**
7. **Ultra-sensitive data (cancer flag + gender-identity flag + embryo counts + storage).** These are among the most stigma-sensitive special-category health data with acute secrecy risk (esp. AR/MENA, workplaces, and for trans users, safety risk). Learn from **Flo (FTC 2021)** and **Premom (FTC 2023)**: no ad-network/third-party-analytics sharing; strict data-minimization; explicit, granular, revocable consent; strict retention & user-deletion; strongest handling for the medical-reason and gender-identity fields. **[NEEDS SOURCE — FTC primary docs.]**
8. **GDPR / PDPL — special-category health data.** Lawful basis + explicit consent; DSAR/export/delete; regional data-residency (esp. AR/MENA); DPIA before launch; extra scrutiny for the cancer/gender flags. **[NEEDS SOURCE — align to Femio privacy skill / DPA at implementation.]**
9. **Partner mode consent.** Partner (embryo/support) sees only granted scope; consent logged, scope-limited, instantly revocable.
10. **Cost tracker = logging, not advice.** No financial/insurance/coverage *advice*; education only (incl. recurring storage fees).
11. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NIH/NCI/NHS/MedlinePlus/ACS) + Tier-2 (ASRM/ESHRE/ASCO/HFEA/RCOG), grade 6–8, localized in 4 languages with RTL parity. Numeric claims (survival/eggs-needed, random-start/retrieval timing, storage terms, OHSS symptoms/timing) re-verified against live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH]**
12. **Emotional safety.** Distress here is high — the onco/medical path layers acute grief + time pressure on a diagnosis; elective carries ambivalence, cost strain, and often solitude. Tone avoids doom and toxic positivity; forum-negativity-skew counterbalanced without dismissal; crisis resources on any low mood screen; cancelled cycles and poor response handled with non-blaming, grief-aware UX. AYA/trusted-adult handling for adolescent onco cases.
13. **Affirming care for trans/nonbinary users.** Language is affirming and non-pathologizing; preservation framed as an option supported by professional guidance, never a gatekeeping requirement; heightened privacy/safety for gender data.
14. **Stigma-aware localization.** AR/MENA-first framing treats preservation as a private medical matter; secrecy-respecting, maximum-privacy defaults; embryo/legal considerations framed as *discuss locally*.
15. **App-store health-app policy.** Meet Apple/Google health-app & medical-disclaimer requirements; no over-claiming (esp. around medication reminders, success odds, and OHSS); legal review before store submission. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

**Clinical — Tier 1 (NIH / NCI / NHS / MedlinePlus / ACS / gov):**
- [NCI — Female Fertility and Cancer (fertility preservation options)](https://www.cancer.gov/about-cancer/treatment/side-effects/fertility-women)
- [American Cancer Society — Preserving Fertility in Women (before cancer treatment)](https://www.cancer.org/cancer/managing-cancer/side-effects/fertility/preserving-fertility-in-women.html)
- [MedlinePlus — In vitro fertilization (IVF)](https://medlineplus.gov/ency/article/007279.htm)
- [MedlinePlus — Ovarian hyperstimulation syndrome](https://medlineplus.gov/ency/article/007294.htm)
- [Memorial Sloan Kettering — Fertility Preservation Before Cancer Treatment (people with ovaries/uterus)](https://www.mskcc.org/cancer-care/patient-education/fertility-preservation-females-starting-treatment)
- [NHS trust OHSS patient leaflets (Leeds Teaching Hospitals)](https://www.leedsth.nhs.uk/patients/resources/ovarian-hyperstimulation-syndrome-ohss/)

**Clinical — Tier 2 (ASCO / ASRM / ESHRE / HFEA / RCOG / peer-reviewed):**
- [ASCO — Fertility Preservation in People With Cancer: Guideline Update (JCO 2025)](https://ascopubs.org/doi/10.1200/JCO-24-02782)
- [ASCO — Fertility Preservation Guideline Clinical Insights (JCO Oncology Practice 2025)](https://ascopubs.org/doi/10.1200/OP-25-00223)
- [ASCO — Press release: updated fertility-preservation guideline](https://www.asco.org/about-asco/press-center/news-releases/asco-updates-clinical-practice-guidelines-fertility-preservation)
- [ASRM — Prevention of moderate and severe OHSS: a guideline (2023)](https://www.asrm.org/practice-guidance/practice-committee-documents/prevention-and-treatment-of-moderate-and-severe-ovarian-hyperstimulation-syndrome-a-guideline/)
- [ASRM / ReproductiveFacts — Female Cancers, Cryopreservation and Fertility (fact sheet)](https://www.reproductivefacts.org/news-and-publications/fact-sheets-and-infographics/female-cancers-cryopreservation-and-fertility/)
- [ASRM — Access to fertility services by transgender and nonbinary persons: Ethics Committee opinion (2021)](https://www.asrm.org/practice-guidance/ethics-opinions/access-to-fertility-services-by-transgender-and-nonbinary-persons-an-ethics-committee-opinion-2021/)
- [RCOG — Ovarian Hyperstimulation Syndrome (patient information)](https://www.rcog.org.uk/for-the-public/browse-our-patient-information/ovarian-hyperstimulation-syndrome/)
- [HFEA — Egg freezing (fertility preservation)](https://www.hfea.gov.uk/treatments/fertility-preservation/egg-freezing/)
- [HFEA — Egg freezing: a factsheet](https://www.hfea.gov.uk/about-us/media-centre/egg-freezing-a-factsheet)
- [HFEA — Changing storage limits for eggs/sperm/embryos (55-year / 10-year renewal)](https://www.hfea.gov.uk/about-us/news-and-press-releases/2022/hfea-briefing-health-and-care-bill-changing-the-storage-limits-for-human-eggs-sperm-and-embryos/)
- [Goldman et al. — Predicting the likelihood of live birth for elective oocyte cryopreservation: a counseling tool (Human Reproduction)](https://academic.oup.com/humrep/article/32/4/853/2968357)
- [Oocyte Cryopreservation for Medical and Planned Indications: A Practical Guide (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10218997/)
- [Oocyte cryopreservation review: medical vs. planned outcomes (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8740039/)
- [Random-Start Ovarian Stimulation for Oocyte/Embryo Cryopreservation prior to gonadotoxic therapy (PubMed 28786354)](https://pubmed.ncbi.nlm.nih.gov/28786354/)
- [Random Start Ovarian Stimulation (PMC review)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9345281/)
- [Oocyte cryopreservation for fertility preservation in transgender/gender-diverse individuals: a SWOT analysis (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12559567/)
- [Fertility preservation in transgender and non-binary adolescents and young adults (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8916634/)

**Competitor / app & service landscape:**
- [Cofertility — Freeze (egg-freezing service, Member Advocate, peer community)](https://www.cofertility.com/freeze)
- [Cofertility — Egg Freezing Reddit Threads: what they get right (and wrong)](https://www.cofertility.com/freeze-learn/egg-freezing-reddit-threads-what-they-get-right-and-wrong)
- [Kindbody — Egg Freezing & Fertility Preservation (egg-count calculator)](https://kindbody.com/egg-freezing/)
- [Extend Fertility — Egg freezing outcomes by age / calculator](https://extendfertility.com/egg-freezing-outcomes-by-age/)

*Community insight (r/eggfreezing, r/fertility, r/IVF preservation threads, oncofertility communities, and egg-freezing-service reviews for Cofertility / Kindbody / Extend Fertility) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. Noted skew: forum posts over-represent harder experiences (rough reactions, low egg counts) — tone must counterbalance without dismissing. FTC actions vs. Flo (2021) and Premom (2023) referenced via prior specs' privacy sources; verify against primary FTC press releases at implementation. **[NEEDS SOURCE — FTC primary docs].** All numeric claims (thaw survival, per-age live-birth, eggs-needed targets, random-start/retrieval timing, UK storage terms, OHSS symptoms/timing) are directional from the Tier-1/Tier-2 sources above and must be re-verified against live primary text (ASCO 2025, ASRM, ESHRE oncofertility, HFEA, NCI/MedlinePlus/ACS, Goldman et al.) per locale before any user-facing publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH].***
