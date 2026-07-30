# Persona B19 — Gynecologic (or Breast) Cancer Survivor / In Active Treatment

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Femio is **not** oncology care. It never diagnoses, treats, prevents, or stages cancer; never interprets scans, tumor markers, or pathology; never advises on chemotherapy, radiation, surgery, or endocrine-therapy decisions; and **never doses medication**. Femio's role is **supportive**: symptom and side-effect tracking, survivorship education, help managing **treatment-induced menopause / GSM / sexual after-effects**, gentle surveillance-appointment reminders (of dates *she* enters), and emotional support — always routing clinical questions to *"your oncology team directs your cancer care — bring this to them."* Screeners and thresholds are *"screening / education — discuss with your clinician."*
> Persona code: **B19** · Cohort: B (gynae/condition band) with a heavy F-track (menopause) overlay · Emotionally high-acuity (cancer diagnosis/treatment, mortality fear, fertility loss, altered sexuality). Shares the treatment-induced-menopause engine with **F4 (surgical/induced menopause)**, the sexual-health/GSM layer with **B12/F6**, and inherits fertility-preservation history from **C15 (oncofertility)** · Last research pass: 2026-07-21

---

## A. Persona snapshot

**Who she is.** "Mariam," 44. Fourteen months ago she found out an abnormal bleed was **endometrial cancer** (the composite also covers **cervical, ovarian, and breast** survivors). She had surgery — a hysterectomy with removal of both ovaries — followed, in her case, by a course of pelvic radiation. Overnight, at 43, she was thrown into **surgical/treatment-induced menopause**: hot flushes that soak the sheets, a vagina that now feels dry, tight, and painful, sex that has quietly stopped, and a grief she can't name because "at least you're alive." She is Arabic-first (also reads English), uses the web on her phone, and is now in **surveillance** — the every-few-months scans and exams, and the spike of terror before each one. She is **not** looking for a second oncologist. She is looking for somewhere to put everything her oncology team doesn't have time for.

**The spectrum she represents (Femio adapts within it):**

| Axis | Range B19 must handle |
|---|---|
| **Cancer type** | Endometrial · cervical · ovarian · vulvar/vaginal · **breast** (shares the treatment-induced-menopause + GSM + endocrine-therapy load). |
| **Phase** | **In active treatment** (chemo/radiation/surgery ongoing) → **early survivorship** (just finished, raw) → **long-term survivorship** (years out, late effects + surveillance) → and, sensitively held, **advanced / recurrent / palliative**. |
| **Menopause status** | Surgical (bilateral oophorectomy) · chemo-induced (may be permanent or temporary) · radiation-induced (usually permanent) · or on **endocrine therapy** (tamoxifen / aromatase inhibitors) driving symptoms — see F4 overlap. |
| **Fertility status** | May have **preserved fertility before treatment** (inherits C15 history) · may be grieving **fertility loss** with no preservation · may be past childbearing but still grieving the abruptness. |

**What she lives with.**
- **Treatment-induced menopause** — abrupt, often more severe than natural menopause: intense vasomotor symptoms (hot flushes, night sweats), sleep disruption, mood swings, joint aches, brain fog, bone-health worry. HRT/MHT is complicated and sometimes contraindicated by her cancer type — a source of real distress. *(→ F4 / F-track engine.)*
- **Genitourinary syndrome of menopause (GSM) & sexual after-effects** — vaginal dryness, thinning, tightening, shortening or scarring (esp. after pelvic radiation), painful sex (dyspareunia), loss of desire, altered body image. Commonly undiagnosed, under-discussed, and under-treated — the after-effect she is most alone with. *(→ B12/F6 sexual-health layer.)*
- **Surveillance & fear of recurrence (FCR)** — the dominant emotional load: recurring exams/scans, "scanxiety," hyper-vigilance to every twinge, uncertainty about the future.
- **Fatigue, cognitive changes, lymphedema, bone loss** and other **late/long-term effects** that arrive months-to-years out and that no one warned her about.
- **Emotional & identity load** — grief, altered femininity and sexuality, fear of mortality, fertility loss, "survivor" pressure to be grateful, relationship and intimacy strain, isolation.

**Core emotional drivers.** She wants to be **seen as a whole woman, not a chart** — the after-effects nobody warned her about, held with dignity and without either doom or forced positivity. She wants a **calm, private place** to track symptoms and side-effects, understand what's normal-for-survivorship vs. worth flagging, prepare for surveillance visits, and quietly work on the intimacy and menopause pieces her oncologist skips. She does **not** want Femio to weigh in on her cancer.

**Jobs-to-be-done.**
1. Track treatment side-effects and survivorship symptoms over time — and carry a clean summary into oncology visits.
2. Understand **treatment-induced menopause** and what (non-hormonal and, where appropriate, hormonal) options exist to discuss with her team.
3. Get real, gentle help with **GSM and sexual after-effects** — the thing she's too embarrassed to raise and her team didn't offer.
4. Hold surveillance dates and prep for the "scanxiety" of each check, without Femio ever triaging her.
5. Carry the emotional load — FCR, grief, fertility loss, body image — with tone that neither catastrophizes nor chirps.
6. Keep her whole record (incl. any C15 fertility-preservation history) in one private account, forever.

**Success = she stops carrying a mental list of "things I'll mention if there's time," because Femio already holds the symptom log, the questions, and the after-effects she was too tired or too shy to raise — and she feels, for once, like a person and not a scan result.**

---

## B. Needs & questions (voice-of-user)

Mined from gynecologic- and breast-cancer survivor communities (r/cancer, r/ovariancancer, r/EndometrialCancer, r/cervicalcancer, r/breastcancer, Macmillan/Cancer Research UK forums, ACS Cancer Survivors Network), survivorship-app reviews, and qualitative literature on unmet needs, sexual health, and fear of recurrence (see Sources). Phrasing is representative/composite — community norms, **not** quoting individuals. Research caveat: survivor forums **over-represent the harder days and the unaddressed after-effects** (that's what drives people to post) — Femio's tone must hold that pain without amplifying doom.

**On treatment-induced menopause (the overnight shock):**
1. *"I went from having periods to full menopause in one surgery. No transition, no warning — just hot flushes and a body I don't recognize."*
2. *"The flushes are worse than anything my mother described. Is that because it happened all at once?"*
3. *"Can I even take HRT with my kind of cancer? Everyone gives me a different answer and I'm scared to ask."*
4. *"What can I do for the night sweats if hormones are off the table for me?"* (non-hormonal education)

**On GSM & sex — the after-effect she's most alone with:**
5. *"Sex is painful now and nobody warned me. My oncologist saved my life and then just... never mentioned this."*
6. *"After radiation everything feels tight and dry. They gave me dilators and no real explanation."*
7. *"Is vaginal estrogen safe for me, or will it bring the cancer back? I can't get a straight answer."* (routes to team; education only)
8. *"I don't even recognize my body as sexual anymore. Is that ever coming back?"*
9. *"How do I bring this up with my doctor? I get too embarrassed and the appointment ends."*

**On surveillance & fear of recurrence:**
10. *"Every scan I'm convinced it's back. The week before, I can't function."* (scanxiety)
11. *"What symptoms actually mean recurrence vs. just... a normal ache? I panic over everything now."* (education, never triage)
12. *"When are my follow-ups supposed to be? I've lost track and I'm scared to miss one."*
13. *"Is it normal to feel MORE anxious now that treatment is over and I'm 'done'?"*

**On late/long-term effects nobody warned about:**
14. *"The fatigue two years later is real and everyone acts like I should be over it."*
15. *"My legs swell now — is that the lymphedema they mentioned once?"*
16. *"They said something about my bones after all this. What am I supposed to watch for?"*
17. *"Brain fog. I can't find words. Is that the chemo or am I imagining it?"*

**On the emotional & identity load:**
18. *"Everyone wants me to be grateful and inspiring. I'm allowed to grieve too, right?"*
19. *"I can't have children now and I'm mourning that on top of everything."* (fertility loss)
20. *"I'm alive but I feel like I lost the woman I was."*

**On fertility (if she preserved, or wishes she had):**
21. *"I froze eggs before chemo — where do I even keep track of that now, years later?"* (inherits C15 storage record)
22. *"No one talked to me about fertility before treatment and now it's gone. I'm furious and heartbroken."*

**On privacy & trust:**
23. *"A cancer diagnosis is the most sensitive thing about me. I need to know this app won't sell it or leak it."*

**Anti-needs / trust-breakers (churn drivers):**
- **Anything that looks like oncology.** No staging, no scan/marker interpretation, no "your CA-125 means…," no treatment recommendations, no "you should/shouldn't do chemo/HRT."
- **Triage of recurrence fear.** Femio must never tell her a symptom is or isn't cancer coming back — education + "bring this to your team," never reassurance-that-could-be-wrong or alarm.
- **Toxic positivity** ("everything happens for a reason," "stay strong, warrior") **or doom.**
- **Silence on sex and menopause** — the exact gap she came for; burying it repeats her clinicians' failure.
- **Being treated as a diagnosis, not a woman.**
- **Privacy creep** — a cancer flag is among the most stigma-sensitive, insurance-relevant, employment-relevant data a person holds (post-Flo/Premom distrust).
- **Losing her data** if she pauses during a hard stretch, or if she becomes a long-term survivor and "graduates."

**Feature requests recurring in reviews/forums:**
- A **side-effect & symptom tracker** built for survivorship (fatigue, flushes, pain, neuropathy, swelling, mood), viewable as trends and exportable for visits.
- A **treatment-induced-menopause module** with honest, cancer-aware options (incl. non-hormonal), framed for "discuss with your team."
- A **GSM / sexual after-effects** module that actually names the problem — lubricants, moisturizers, dilator education, pelvic-floor, and how to raise it with a clinician.
- A **surveillance organizer** — her appointment dates, a visit-prep question builder, and gentle (never alarming) reminders.
- A **late-effects library** (fatigue, lymphedema, bone health, cognition) so she stops feeling gaslit.
- An **emotional-support layer** for FCR, grief, fertility loss, and body image, with crisis resources.
- **Ironclad privacy** for the cancer flag.

---

## C. Competitor teardown

Feature-by-feature, focused on **survivorship after-effects (menopause, GSM/sex, surveillance, emotional load)** for a woman on **one lifelong, privacy-first, Arabic-first account.** Key insight: **general women's-health apps abandon survivors entirely** (they assume cycles, fertility, or natural menopause), while **oncology apps** exist but are treatment-navigation / clinical-trial / community tools — **US-/English-first, disease-navigation-oriented, and largely silent on the female-specific after-effects** (treatment-induced menopause, GSM, sexual health, fertility grief) that define this persona. Nobody owns the **whole-woman survivorship after-effects layer** on a portable, multilingual, privacy-by-design account.

| Product | Built for | Treatment-induced menopause / GSM | Sexual after-effects | Surveillance / visit-prep | Emotional / FCR support | Privacy & scope | Where it fails B19 |
|---|---|---|---|---|---|---|---|
| **Outcomes4Me** | Cancer treatment navigation; NCCN-guideline explainer, symptom tracking, trial matching | Minimal; general symptom tracking, not menopause-specific | Not a focus | Some symptom tracking; treatment-decision oriented | Limited | US-first, English-first; oncology-navigation scope | Treatment-decision engine, not a survivorship after-effects companion; no menopause/GSM/sexual-health depth; not Arabic-/privacy-first or whole-lifespan |
| **Belong.Life (BELONG)** | Cancer community + support groups + trial matching | No | No | No structured survivorship organizer | **Strong peer community** | Community data model | Community-first, not a private personal tracker; no menopause/GSM/sexual-health modules; English-first |
| **OWise** | Breast-cancer support; treatment info, symptom/well-being tracking, appointment recording | Some well-being tracking; not menopause-specialized | Not a focus | Appointment support (breast) | Some well-being | EU/GDPR posture (better) | Breast-only, treatment-phase oriented; thin on GSM/sexual after-effects and gynae survivorship; not Arabic-first or whole-lifespan |
| **CancerAid / Ada / general cancer apps** | Symptom tracking, education, navigation | Generic | No | Generic tracking | Some | Varies | Generic oncology tracking; none own the female after-effects layer; English-/US-first |
| **Flo / Clue / Ovia (general women's health)** | Cycles, fertility, pregnancy, natural menopause | Assumes **natural** menopause; no cancer-aware framing | No survivorship framing | No | No | **FTC-era distrust (Flo 2021)** | **Abandon survivors entirely** — no cycle to track post-hysterectomy/oophorectomy; menopause content assumes natural transition and unrestricted HRT; no cancer awareness or GSM-after-radiation depth |
| **Menopause apps (Balance, Caria, Vira/Nyra)** | Perimenopause/menopause symptom tracking + MHT education | Natural-menopause framing; **not** cancer-aware (HRT may be contraindicated) | Some GSM content, not survivor-calibrated | No | Some | Varies | Not cancer-aware — can present HRT as straightforwardly available; no surveillance layer, no oncofertility carry-forward, English-first |
| **Hospital survivorship-care-plan PDFs** | A static care summary handed at discharge | Listed as a possible late effect | Rarely detailed | A schedule on paper | None | N/A | Static, one-time, paper; not a living tracker; drops the after-effects into a list and walks away |

**The fragmentation map (the opening for Femio):**
- **General cycle/fertility apps** are built for a body B19 no longer has and go silent (or worse, keep predicting periods) after her treatment.
- **Menopause apps** assume a *natural* transition with *available* HRT — dangerous framing for a survivor whose cancer may contraindicate hormones; none are cancer-aware.
- **Oncology apps** own treatment-navigation, community, and trials — but treat the **female-specific after-effects (treatment-induced menopause, GSM, sexual health, fertility grief)** as afterthoughts, and are US-/English-first.
- **Care-plan PDFs** name the after-effects once and never track them.
- **Nobody** offers: a **survivorship after-effects companion** — treatment-induced-menopause + GSM/sexual-health modules that are **cancer-aware**, a **side-effect/symptom tracker with visit-prep**, a **gentle surveillance organizer**, an **FCR / grief / fertility-loss / body-image emotional layer**, **oncofertility carry-forward from C15**, **Arabic-first/RTL**, **privacy-by-design for a cancer flag**, and **one account that holds everything across active treatment → survivorship → the rest of her life.** *That is B19's Femio thesis.*

---

## D. Clinical grounding (cited)

> All claims below are **patient-education framing**, medically reviewed and cited to primary sources. Femio does **not** provide oncology care, interpret *her* results, recommend or dose any treatment (incl. HRT/vaginal estrogen), or advise on whether a therapy is safe *for her* — it explains, in plain language, what survivors commonly experience and routes every specific decision to *"your oncology team directs your cancer care — confirm options with them."*

**Cancer survivorship & late/long-term effects (the phase B19 is in):**
- A person is a **"cancer survivor" from diagnosis through the rest of life**; survivorship includes those in treatment, in remission, and living with advanced disease. [NCI]
- **Late effects** are side effects that appear **months to years after treatment ends** and vary by treatment: they can include **fatigue, cognitive changes ("brain/chemo fog"), lymphedema, bone loss/osteoporosis, heart and lung effects, and pelvic/sexual effects.** Survivorship care aims to watch for, and help manage, these. [NCI — Late Effects; NCCN Patient — Survivorship]
- **Cancer-related fatigue** is common and can persist for **months to years** after treatment; ~20–25% of survivors report it years later. [NCI; ACS]
- Late symptoms are well-documented in **long-term gynecologic-cancer survivors after radiation** (bowel, urinary, and vaginal/sexual effects), often persisting for years. [population-based cohort, PMC]

**Treatment-induced menopause (the F4/F-track overlap — a defining B19 feature):**
- Cancer treatments — **bilateral oophorectomy (surgical), gonadotoxic chemotherapy (esp. alkylating agents), and pelvic radiotherapy** — commonly induce **premature ovarian insufficiency or early menopause.** Surgical and radiation-induced menopause are usually **permanent**; chemo-induced menopause may be permanent or temporary. [Lancet — *Managing menopause after cancer*; Canadian Cancer Society; Australasian Menopause Society]
- Treatment-induced menopause is often **more abrupt and more severe** than natural menopause, with pronounced **vasomotor symptoms (hot flushes, night sweats), sleep disturbance, mood change, musculoskeletal symptoms, fatigue, cognitive symptoms, and sexual dysfunction**; vasomotor symptoms are typically more severe/frequent after **surgical** menopause. [Lancet 2023; BGCS–British Menopause Society guideline 2024]
- **Endocrine therapy** (tamoxifen, aromatase inhibitors) in breast-cancer survivors drives menopausal symptoms and GSM as well. [PMC — GSM in breast cancer survivors]
- **Management is genuinely complex and cancer-type-dependent:** systemic HRT/MHT is the most effective treatment for vasomotor symptoms but its use in survivors requires **specialist, individualized decision-making** and may be **contraindicated** for some cancers. Non-hormonal options exist. **Femio guardrail:** Femio explains that these options *exist* and belong to a conversation with her oncology/menopause team; it **never** recommends, doses, or tells her HRT is or isn't safe *for her.* [Lancet 2023; BGCS–BMS 2024; Menopause Society]

**Genitourinary syndrome of menopause (GSM) & sexual after-effects (the B12/F6 overlap):**
- **GSM** — vaginal dryness, burning, irritation, thinning, and **painful sex (dyspareunia)**, plus urinary symptoms — is **more prevalent, often earlier, and frequently undiagnosed/untreated** in cancer survivors because of treatment-induced estrogen loss. [PMC — GSM in breast cancer survivors]
- **Pelvic radiation** can damage the vaginal lining (thin, fragile), cause **scarring, shortening, and narrowing (stenosis)**, and make penetrative sex painful or difficult — sometimes long-term. [ACS — How Radiation Therapy Can Affect Sex for Women]
- **First-line management is non-hormonal:** **water- or silicone-based lubricants and vaginal moisturizers** are recommended first-line for dryness and dyspareunia in survivors, per **ASCO/ACS survivorship guidance.** **Vaginal dilators** (regular use) are recommended for women who have had **pelvic radiation** to help maintain vaginal length/elasticity and make sex and exams more comfortable; **pelvic-floor** work and Kegels can help. [ASCO/ACS survivorship; ACS; OncoLink]
- **Vaginal (local) estrogen** for refractory GSM: evidence shows **minimal systemic absorption** and, in available studies, **no clear increase in recurrence** for many survivors — **but it remains controversial**, is **not definitively established as safe** (esp. on **aromatase inhibitors**), and is an **individualized, specialist decision.** Newer options (e.g., vaginal DHEA/prasterone) are being studied. **Femio guardrail:** category-level education only; the safety question is explicitly routed to her team. [AUA News 2024; PubMed reviews; PMC]
- Sexual concerns are **common and under-addressed**: most survivors report **minimal communication with providers** about sexual health — the exact gap Femio's education + "how to raise it" content targets. [UCF/EurekAlert; Journal of Cancer Survivorship mixed-methods study]

**Surveillance & follow-up (the organizer layer — dates *she* enters):**
- After curative-intent treatment, gynecologic-cancer survivors enter **structured post-treatment surveillance** (history, exams, and — depending on cancer/stage — selected tests), with schedules that **vary by cancer type, stage, and risk.** Surveillance intensity is debated (e.g., the endometrial **TOTEM** trial); **the schedule is set by her oncology team, not by Femio.** [SGO clinical practice statement 2025; ACS — Living as an Endometrial Cancer Survivor]
- **Femio guardrail:** Femio stores and gently reminds her of the dates *she* enters and helps her prep questions; it **does not** define the schedule, order tests, or interpret whether a symptom means recurrence. Recurrence-symptom content is **awareness + "bring it to your team,"** never triage or reassurance.

**Fear of cancer recurrence (FCR) & emotional load (the support layer):**
- **Fear of recurrence** is among the **most common and persistent unmet needs**, reported regardless of cancer type or years survived; unmet psychosocial needs (FCR, uncertainty, concerns about partners/family, sexual changes) drive **anxiety, depression, and reduced quality of life.** "Scanxiety" around surveillance is well-described. [Dove/CMAR unmet-needs analysis; UCF]
- **Emotional functioning often scores lowest** in survivor quality-of-life studies; **fatigue, insomnia, and pain** are prevalent; the transition **out** of active treatment can *increase* anxiety ("who's watching me now?"). [research syntheses in Sources]
- **Fertility loss** compounds grief for many gynecologic/breast survivors — either mourned directly, or held alongside any **C15 fertility-preservation** history. [see C15]

**Fertility-preservation history (C15 carry-forward):**
- Survivors who did **oncofertility preservation before treatment** (egg/embryo/ovarian-tissue freezing, often random-start) carry a **storage record** that must persist for years and resurface when relevant. Femio holds this on the one account (see C15) — including **consent-renewal reminders** — without ever advising on use. [see C15; ASCO fertility-preservation guideline]

*Femio applies all of this as **education, tracking, organization, gentle reminders, honest framing, and emotional support**, always ending *"your oncology team directs your cancer care and your treatment options — bring this to them"* — never as a diagnosis, a staging, a result interpretation, a treatment or HRT recommendation, a dose, or a recurrence verdict.*

**Resolved publication boundary:** Femio publishes no treatment-induced-versus-natural severity statistic, per-cancer HRT eligibility rule, vaginal-estrogen/prasterone safety verdict, surveillance schedule, dilator protocol, late-effect prevalence, or fear-of-recurrence prevalence. The oncology team owns cancer-specific care. Menopause uncertainty routes under [NICE NG23, updated 15 April 2026](https://www.nice.org.uk/guidance/ng23/chapter/Recommendations); breast-cancer systemic-HRT wording follows [NICE NG101](https://www.nice.org.uk/guidance/ng101/chapter/Recommendations); breast-cancer urogenital-symptom education follows [ACOG Clinical Consensus No. 2, December 2021](https://www.acog.org/clinical/clinical-guidance/clinical-consensus/articles/2021/12/treatment-of-urogenital-symptoms-in-individuals-with-a-history-of-estrogen-dependent-breast-cancer) and remains a treating-team decision. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona):**
1. **Survivorship side-effect & symptom tracker.** Log the symptoms that actually matter here — **hot flushes/night sweats, sleep, mood, fatigue, joint/muscle pain, neuropathy, swelling/lymphedema signs, vaginal dryness/pain, urinary symptoms, appetite/weight, brain fog** — viewable as **trends**, exportable for oncology/menopause visits. Non-diagnostic; no "this means recurrence."
2. **Treatment-induced-menopause module (F4/F-track engine, cancer-aware).** Honest education on why it happened (surgical/chemo/radiation/endocrine), what's typical, and the **full option landscape incl. non-hormonal** — with **explicit, cautious "HRT decisions in survivors are specialist and cancer-type-dependent — discuss with your team"** framing. Surfaces the **F-track symptom log (34+ menopause symptoms)** re-skinned for survivors.
3. **GSM & sexual after-effects module (B12/F6 layer).** Names the problem plainly. First-line **non-hormonal** education (lubricants, moisturizers), **vaginal-dilator** education (esp. post-radiation), **pelvic-floor** basics, and **"how to raise this with your clinician"** scripts. Vaginal-estrogen/prasterone framed as **category-level education, routed to team** (controversial safety). Warm, non-clinical, shame-free, private.
4. **Surveillance organizer & visit-prep.** Store **her** follow-up dates; gentle, **non-alarming** reminders; a **question-builder** and one-tap **symptom-summary export** for each visit. Recurrence-awareness content is **"what to mention to your team,"** never triage. **Never defines the schedule.**
5. **Emotional-support layer (FCR / grief / fertility loss / body image).** Sensitive content + a mood/anxiety **screener** (screening-framed, localized crisis resources), scanxiety support, grief and fertility-loss support, body-image and intimacy support. Neither doom nor toxic positivity.
6. **Late/long-term-effects library.** Fatigue, cognition, lymphedema, bone health, pelvic effects — "you're not imagining it; here's what survivors experience and what to raise."
7. **Privacy-by-design for a cancer flag.** The diagnosis flag and survivorship data are **ultra-sensitive**; strict handling (see §K).
8. **Oncofertility carry-forward (from C15).** If she preserved fertility, hold the **storage vault card + consent-renewal reminder** unchanged; if she's grieving fertility loss, fold it into the support layer.

**P1 — Strong differentiators (fast follow):**
9. **Referenced content library** on every component (survivorship, treatment-induced menopause, GSM/sexual health, late effects, surveillance, FCR) — grade 6–8, 4 languages, RTL-first.
10. **Phase-aware home** that adapts across active-treatment → early → long-term survivorship (and holds advanced/palliative with maximum gentleness).
11. **Partner/support-person mode** (intimacy and menopause are relational) — consent-gated, scoped, revocable.
12. **Data/timeline export (PDF/image)** for any clinician of her choosing.
13. **Graceful pause + return** — a first-class "I need a break" and a "long-term survivor, low-touch" state that keeps everything.

**P2 — Nice-to-have / later:**
14. Moderated, privacy-safe survivor community (guarded against medical advice + doom/false-hope; counterbalancing forum negativity-skew).
15. Stigma-aware AR/MENA content (cancer secrecy, sexual-health taboo framed sensitively; "discuss locally/privately").
16. AYA / trusted-adult layer for adolescent/young-adult survivors.
17. Optional integration hooks for a clinician-shared summary (export-first, never auto-transmit).

**Explicitly OUT of scope for B19 (guardrail):**
- **Any oncology function** — staging, scan/marker/pathology interpretation, treatment or trial recommendations, prognosis, "is this recurrence."
- **Recommending, dosing, or ruling in/out HRT, vaginal estrogen, or any medication.** Category education only; the safety-for-her question always routes to her team.
- **Defining or altering her surveillance schedule**, or ordering/interpreting tests.
- **Triaging symptoms as recurrence** or reassuring her they're not — education + "bring it to your team," never a verdict.
- Diagnosing, treating, or preventing anything. Not contraception (and post-hysterectomy/oophorectomy framing must not assume cycles).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries source citations, a medical-review byline + date, and *"not medical advice — your oncology team directs your cancer care; confirm all treatment and medication options, including HRT, with them."* Tone: sensitive, whole-woman, neither doom nor toxic positivity.

- **"You're a survivor from day one"** — what survivorship means (in treatment, in remission, living with advanced disease); that all of it is valid.
- **"Treatment-induced menopause — why it happened and what's typical"** — surgical vs. chemo vs. radiation vs. endocrine-therapy; why it can feel more abrupt/severe than natural menopause.
- **"Managing hot flushes & night sweats after cancer"** — non-hormonal strategies first; that **HRT decisions in survivors are specialist and depend on your cancer type — discuss with your team.** *(Never presents HRT as straightforwardly available.)*
- **"Menopause, hormones & my cancer — the honest, complicated version"** — why the answer is individualized; what questions to ask your oncology/menopause team.
- **"GSM: dryness, pain, and sex after cancer — you're not alone"** — naming it; that it's common, under-discussed, and manageable.
- **"First things to try: lubricants & vaginal moisturizers"** — non-hormonal first-line, how they differ, how to choose (education). [ASCO/ACS]
- **"Vaginal dilators after pelvic radiation"** — what they're for, why regular use helps, gentle how-to — *your team/physio guides your specifics.*
- **"Pelvic floor & comfort"** — pelvic-floor basics, positions, pacing; when to ask for pelvic-health physio.
- **"Vaginal estrogen and other options — what the evidence says (and doesn't)"** — category-level, honest about the controversy, **routed to your specialist**; never "this is safe for you."
- **"How to talk to your doctor about sex and menopause"** — scripts and prompts to raise the thing that's easy to skip.
- **"Body image, intimacy & feeling like yourself again"** — identity, desire, relationships; that grief for the old you is allowed.
- **"Fear it comes back — and the anxiety around scans"** — normalizing FCR/scanxiety; coping strategies; when to seek mental-health support; crisis resources.
- **"Your follow-up visits — getting the most from surveillance"** — what surveillance is, prepping questions, tracking symptoms to mention; *your schedule comes from your team.*
- **"Symptoms to mention to your team"** — awareness (e.g., new bleeding, pain, swelling) framed as **"tell your team,"** explicitly **not** "this is/ isn't recurrence."
- **"Late effects: fatigue, brain fog, lymphedema, bone health"** — you're not imagining it; what survivors experience; what to raise.
- **"Fertility after cancer — grief, and what you preserved"** — sensitive; folds in **C15** storage history if present; holds fertility loss with dignity.
- **"The emotional side of survivorship"** — grief, the pressure to be grateful, isolation, couples, when to get support.
- **Stigma-aware module (AR/MENA-first)** — cancer and sexual-health privacy; secrecy-respecting design; *discuss locally/privately.*
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so she's never boxed into "cancer only."

---

## G. Tools, logs & alerts (compliant framing)

**Logs (inputs):**
- **Diagnosis/context flag (ultra-sensitive):** cancer type, phase (active treatment / early / long-term survivorship / advanced), treatment(s) received (surgery / chemo / radiation / endocrine therapy) — **entry-only, no interpretation, elevated sensitivity (§K).**
- **Menopause-status flag:** surgical / chemo-induced / radiation-induced / endocrine-therapy-driven / natural — drives F-track re-skin.
- **Survivorship symptom log:** vasomotor (flushes/sweats), sleep, mood, fatigue, joint/muscle pain, neuropathy, swelling/lymphedema signs, vaginal dryness/pain, urinary symptoms, bowel changes, appetite/weight, brain fog — each with severity + date; trends.
- **Sexual-health log (optional, private):** dryness, dyspareunia, desire, dilator use, moisturizer/lubricant use — supportive, non-judgmental.
- **Surveillance appointments (entry-only):** her follow-up dates, visit type, provider; question list per visit.
- **Meds/supplements log (educational):** current medications incl. endocrine therapy — **memory aid, never a dose recommendation or interpretation.**
- **Screener history:** mood/anxiety (scores + dates, screening-only); FCR-awareness check.
- **Fertility-preservation record (from C15, if present):** storage vault + consent-renewal.
- **Emotional-phase tags** (in-treatment / early / long-term / scanxiety-window / grieving) — drive support-card selection.

**Tools:**
- **Survivorship symptom-trend view** + **one-tap visit-summary export** (PDF/image).
- **Treatment-induced-menopause module** (F-track symptom tracker + cancer-aware education).
- **GSM / sexual-health module** (education + optional private log + "how to raise it" scripts).
- **Surveillance organizer + visit-prep question-builder.**
- **Emotional-support hub** (FCR/scanxiety, grief, fertility loss, body image) + mood/anxiety screener → screening-framed output + localized crisis resources.
- **Late-effects library** + **oncofertility vault card** (from C15).

**Alerts / nudges (all opt-in, gentle, dismissible, revocable, RTL-aware, non-alarming):**
- **Surveillance reminder (soft):** *"You noted a follow-up around [date you entered]. Want help prepping questions and a symptom summary?"* — never "your scan is due" alarm-framing, never implying risk.
- **Consent-renewal reminder (if C15 storage present):** *"Your storage consent may be due around [date] — check with your clinic; rules vary by country."*
- **Menopause/GSM check-in:** *"How have the hot flushes / dryness been this week? Logging helps your next visit."*
- **Scanxiety support card** in the window before a surveillance date (calming, optional).
- **Screening follow-up** + crisis resources on any low mood screen.
- **Never:** a recurrence-risk score, a "this symptom means…" alert, an HRT/medication recommendation, or a cycle/period/fertile-window nudge.

**Mandatory compliance wording on relevant surfaces:**
- *"Femio supports you alongside your cancer care — it does not provide oncology care, interpret your scans, markers, or pathology, recommend or rule out any treatment (including HRT), or tell you whether a symptom is recurrence. Your oncology team does that."*
- On menopause/HRT surfaces: *"Whether hormone therapy is right after your cancer is a specialist decision that depends on your cancer type. Femio explains options in general — your team decides with you."*
- On sexual-health/vaginal-estrogen surfaces: *"The safety of vaginal estrogen after cancer is individualized and still debated — bring it to your oncology or menopause specialist. This is general information, not advice for you."*
- On surveillance/symptom surfaces: *"Femio holds the dates you enter and helps you prepare — it doesn't set your follow-up schedule or decide what a symptom means. Tell your team about anything new or worrying."*
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle` (may be **inactive/archived** post-hysterectomy/oophorectomy — retained, never assumed live).
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamp + "non-diagnostic" tag).

**B19 persona-specific:**
- `oncology_context` {cancer_type (endometrial | cervical | ovarian | vulvar_vaginal | breast | other), phase (active_treatment | early_survivorship | long_term_survivorship | advanced), treatments[] (surgery | chemo | radiation | endocrine_therapy), **stored with elevated sensitivity**} — **entry-only, no interpretation, no staging.**
- `menopause_status` {type: surgical | chemo_induced | radiation_induced | endocrine_driven | natural, onset_date, permanence_note} — drives F4/F-track re-skin.
- `survivorship_symptoms[]` {type, severity, date} (vasomotor, sleep, fatigue, pain, neuropathy, lymphedema-signs, GSM/dryness, urinary, bowel, cognition, weight).
- `sexual_health_log[]` {dryness, dyspareunia, desire, dilator_use, moisturizer_lubricant_use, date} — **optional, private, supportive.**
- `surveillance_appointments[]` {date, type, provider, questions[], status} — **entry-only; Femio never generates the schedule.**
- `endocrine_therapy` {agent_category (tamoxifen | aromatase_inhibitor | other), note} — **entry-only, category-level, never dosed/interpreted.**
- `emotional_phase_tags[]` (in_treatment / early / long_term / scanxiety_window / grieving) — drives support-card selection.
- `mood_screen_history[]` {tool, score, date} (screening-only); `fcr_check_history[]`.
- `fertility_preservation_ref` → **C15 `storage_record[]` + `consent_renewal_date`** (carried forward unchanged), OR `fertility_loss_flag` (folds into support layer).
- `partner_link_id`, `partner_scope`, `partner_consent_ts` (intimacy/menopause support cases).
- `care_plan_notes` (free text; user's own summary of what her team told her) — **her notes, not Femio's advice.**

*Data-minimization & heightened sensitivity: a **cancer diagnosis flag**, treatment history, and sexual-health data are among the most stigma-, insurance-, and employment-sensitive special-category data a person holds; encrypted, user-deletable, never shared with ad networks/analytics; strongest handling for the oncology-context and sexual-health fields. (§K)*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into B19 — direct, or routed from an F-track menopause entry, a B-band entry, or "my situation changed"):**
1. "What brings you to Femio?" → *A health condition / cancer* → *"I've been diagnosed with, am being treated for, or have survived a gynecologic or breast cancer."* (sensitive, opt-in, clearly private)
2. **Phase split:** "Where are you right now?" → in active treatment / recently finished / years out / living with advanced disease ⇒ sets tone, home emphasis, and reminder cadence.
3. "What treatment(s) have you had or are you having?" (multi-select: surgery / chemo / radiation / endocrine therapy) ⇒ shapes menopause + late-effects content.
4. **Menopause capture:** "Has treatment affected your periods or brought on menopause?" ⇒ sets `menopause_status`, activates the **F-track symptom engine** re-skinned for survivors.
5. "Would you like support with any of these?" (multi-select: **menopause symptoms · sexual health / intimacy · surveillance & appointments · fatigue & late effects · emotional support · fertility**) ⇒ orders home modules to what she actually wants.
6. **(If fertility flagged)** "Did you preserve fertility before treatment?" → yes ⇒ carry **C15 storage vault**; unsure/no ⇒ hold gently, fold into support.
7. Consent & privacy (explicit ultra-sensitivity notice for the cancer flag; secrecy/stigma-aware defaults).

**Home config for B19:**
- **In active treatment:** hero = **side-effect tracker + "what's typical" reassurance**; calm, low-demand; surveillance/menopause modules present but not pushed.
- **Early survivorship:** hero = **treatment-induced-menopause + symptom trends**; GSM/sexual-health and emotional-support surfaced (this is the raw window); surveillance organizer pinned.
- **Long-term survivorship:** hero = **surveillance organizer + late-effects + ongoing menopause/GSM management**; low-touch, "we're here" cadence.
- **Advanced / palliative:** maximum gentleness; symptom-comfort + emotional-support + practical content; **suppress** anything milestone-y or falsely upbeat; no surveillance pressure.
- **Module ordering** follows her §5 selections (e.g., if she flagged sexual health, GSM module rises to the top).
- **De-emphasize / suppress:** cycle prediction, fertile-window, period/pregnancy nudges (her body may have no cycle); menopause content is **cancer-aware**, never "here's HRT."
- **Hidden-but-reachable:** full lifespan library, condition pages, general menopause content — one search/tap away; nothing is deleted.

**Adaptive tone:** steady, warm, whole-woman, unhurried. Validate grief and the pressure to "be grateful"; name the after-effects nobody warned her about; **never** toxic-positive ("stay strong, warrior"), **never** doom, **never** a recurrence verdict or an HRT recommendation. Surface the mental-health module + resources if mood screens trend low or in the scanxiety window. Sexual-health content is shame-free and opt-in.

---

## J. Adaptation triggers (state transitions)

B19 **inherits all universal events** from the Master Adaptation Model §6 (positive test, pregnancy loss, mood-screen-high/crisis, red-flag symptom, disengagement/"taking a break," toggle-mode-off, age-of-consent). The table below adds only **B19-specific** transitions. All routes **preserve data continuity (one account)** and **always route cancer/treatment/HRT/recurrence questions to her oncology team** — never a dose, staging, result interpretation, treatment recommendation, or recurrence verdict.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Arrives into B19** (direct, or from F-track/B-band/"my situation changed") | user reports a gynae/breast cancer diagnosis, treatment, or survivorship; picks a phase | Sensitive confirm (private, opt-in); set phase/tone; activate side-effect tracker, treatment-induced-menopause module, GSM/sexual-health module, surveillance organizer, emotional-support layer; carry all prior data forward; re-confirm privacy scope for the cancer flag. | **Become B19** |
| **Treatment-induced menopause recorded** | menopause_status = surgical / chemo / radiation / endocrine-driven | Activate the **F-track menopause symptom engine (34+)** re-skinned cancer-aware; menopause + vasomotor content; **cautious HRT-is-specialist framing.** | **B19 ⊕ F4/F-track overlay** |
| **Sexual after-effects / GSM flagged** | user selects sexual-health support, or logs dryness/dyspareunia/dilator use | Surface **GSM/sexual-health module (B12/F6 layer)**: non-hormonal first-line education, dilator/pelvic-floor content, "how to raise it" scripts; vaginal-estrogen routed to team. | **B19 ⊕ B12/F6 overlay** |
| **Fertility-preservation history present** | C15 storage record exists / user confirms she preserved | Carry **C15 storage vault card + consent-renewal reminder** forward unchanged; fold into fertility-support content. | **B19 ⊕ C15 carry-forward** |
| **Fertility loss (no preservation)** | user indicates fertility lost to treatment | Gentle, grief-aware fertility-loss support; suppress any fertility/cycle nudges; no re-prompting. | Stay B19 (support-forward) |
| **Surveillance date entered** | user adds a follow-up appointment | Store it; offer **visit-prep question-builder + symptom-summary export**; **soft, non-alarming** reminder; surface **scanxiety support** in the pre-visit window. | Stay B19 (surveillance sub-flow) |
| **Recurrence-worry symptom logged** (e.g., new bleed, pain, swelling) | user logs a symptom she's anxious about | Surface **"tell your team" awareness content** + saved contact as *education*; **never** "this is/ isn't recurrence"; log stays raw; offer emotional-support card. | Awareness messaging (content only), stay B19 |
| **Phase change: active treatment → early survivorship** | user marks treatment finished | Shift home to survivorship after-effects (menopause/GSM/late-effects/emotional); gentle "the after-treatment dip is real" support. | Stay B19 (early-survivorship config) |
| **Phase change: → long-term survivorship** | time elapsed / user updates | Low-touch config; surveillance + late-effects + ongoing menopause management; "we're here." | Stay B19 (long-term config) |
| **Phase change: → advanced / recurrent / palliative** | user indicates advanced/recurrent disease | **Maximum gentleness**: symptom-comfort + emotional + practical support; suppress milestones and upbeat framing; no surveillance pressure; crisis/psychosocial resources prominent. | Stay B19 (palliative-sensitive config) |
| **Mood screen trends low / crisis flag** | screener threshold crossed (inherits universal) | Surface mental-health module + localized crisis resources; screening-framed; hold FCR/grief gently. | Stay B19 |
| **Disengagement / "taking a break"** (inherits universal) | user pauses | Suppress nudges; **keep everything**; low-touch wellness content; "we'll be here when you're ready." | Paused state |
| **Post-treatment "graduation" / long remission** | user wishes to step back to general use | Offer low-touch general/menopause (F) tracking while **retaining full survivorship record**; nothing deleted. | Retain, low-touch (→ F-track or general) |

*Post-diagnosis, B19 is designed to **hold everything with dignity across active treatment → survivorship → the rest of her life**, always routing cancer, treatment, HRT, and recurrence questions to her oncology team, and never assuming a cycle her body may no longer have.*

---

## K. Compliance flags

1. **No oncology care; no diagnosis / staging / prognosis / result interpretation (highest-priority guardrail).** Femio never interprets scans, tumor markers, or pathology; stages cancer; selects treatment; or rules recurrence in or out. It tracks, educates, organizes, and routes questions to the oncology team under [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). Classification still requires launch-market legal review.
2. **No medication dosing or HRT/vaginal-estrogen recommendation (B19-critical).** Menopause/GSM medication content is category-level education only. Femio must not recommend, calculate a dose, or say whether HRT, vaginal estrogen, or prasterone is safe for an individual cancer survivor. It asks the user to discuss the question with her oncology/menopause team and may mirror only a schedule entered by the user or her authorized clinician. Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md); no cancer-specific medicine conclusion may be published without a separately reviewed guideline citation. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
3. **No surveillance-schedule authorship or recurrence triage.** Femio stores dates entered by the user or authorized clinician and helps prepare questions; it does not define or alter follow-up, order or interpret tests, or label/reassure about recurrence. New, persistent, or concerning symptoms route to the oncology team or urgent local care according to that team’s instructions. No global cancer-type schedule is shipped. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
4. **Emotional safety is paramount (high-acuity persona).** Cancer diagnosis/treatment, mortality fear, fertility loss, and altered sexuality mean tone must avoid **both doom and toxic positivity**; no "warrior/inspiration" pressure; grief and the "after-treatment dip" validated; advanced/palliative handled with maximum gentleness (suppress milestones/upbeat framing); crisis resources on any low mood screen; scanxiety supported. Silence-over-harm on grief paths.
5. **Ultra-sensitive data (cancer flag + treatment history + sexual-health data).** Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): never send these data to ad networks or use them for targeted advertising; minimize collection; use clear, granular, revocable product permissions; enforce purpose-limited processors, retention, export, deletion, and security controls; and provide no employer/insurer access. The primary warnings are the [FTC Flo matter](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom matter](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Privacy-law implementation.** For EEA processing, cancer, reproductive, and sexual-health data fall within GDPR Article 9; document an Article 6 basis and Article 9 condition, complete a DPIA where Article 35 requires it, and implement applicable data-subject rights. Other markets require launch-country counsel review. Do not promise universal “GDPR/PDPL compliance” or residency without approved architecture/contracts. ([GDPR official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj); [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
7. **Not contraception; no cycle assumption.** Post-hysterectomy/oophorectomy, Femio must **not** assume or predict a cycle; retained cycle history is archived, never surfaced as a live prediction; never "safe/fertile day" framing.
8. **Sexual-health content: dignified, evidence-based, opt-in.** NCI lists lubricants/moisturizers, pelvic-muscle exercises, and—when treatment has affected the vagina—clinician-directed dilator use; it says vaginal estrogen may be appropriate for some cancer types. Femio therefore offers neutral education and routes every hormonal or individualized intervention to the cancer/gynecology team; it does not prescribe a sequence. ([NCI, Sexual Health Issues in Women with Cancer](https://www.cancer.gov/about-cancer/treatment/side-effects/sexuality-women); reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)
9. **Fertility loss & C15 carry-forward.** Fertility-preservation storage records (incl. consent-renewal) persist on the one account, unchanged; fertility loss held with grief-aware, non-blaming UX. [see C15]
10. **Partner mode consent.** Partner/support-person sees only granted scope; consent logged, scope-limited, instantly revocable.
11. **Medical review + citations.** Global public content is limited to education, tracking, question preparation, and oncology-team routing. It uses [NICE NG23](https://www.nice.org.uk/guidance/ng23/chapter/Recommendations), [NICE NG101](https://www.nice.org.uk/guidance/ng101/chapter/Recommendations), and [ACOG Clinical Consensus No. 2](https://www.acog.org/clinical/clinical-guidance/clinical-consensus/articles/2021/12/treatment-of-urogenital-symptoms-in-individuals-with-a-history-of-estrogen-dependent-breast-cancer) only within their stated populations. Cancer-type treatment/surveillance, quantitative late effects, and individual hormone safety require a separately reviewed country/clinical module and cannot be inferred by the app. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
12. **Stigma-aware localization.** AR/MENA-first framing treats a cancer diagnosis and sexual-health matters as private; secrecy-respecting, maximum-privacy defaults; sensitive content framed as *discuss privately/locally.*
13. **App-store health-app policy.** Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): no diagnosis, recurrence prediction, HRT recommendation, result interpretation, or treatment selection; substantiate all health claims; complete the Google health-app declaration and required privacy/disclaimer disclosures. Re-check the linked Apple and Google policies and obtain launch-market legal review immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH / NCI / NHS / MedlinePlus / ACS / gov):**
- [NCI — Coping: Late Effects of Cancer Treatment](https://www.cancer.gov/about-cancer/coping/survivorship/late-effects)
- [American Cancer Society — Living as an Endometrial Cancer Survivor (follow-up care)](https://www.cancer.org/cancer/types/endometrial-cancer/after-treatment/follow-up.html)
- [American Cancer Society — How Radiation Therapy Can Affect Sex for Women (pelvic radiation)](https://www.cancer.org/cancer/managing-cancer/side-effects/sexual-side-effects/pelvic-radiation.html)
- [Johns Hopkins Kimmel Cancer Center — What You Should Know About Cancer Survivorship](https://www.hopkinsmedicine.org/kimmel-cancer-center/patient-and-family-services/patient-information/cancer-survivorship)
- [Canadian Cancer Society — Treatment-induced menopause](https://cancer.ca/en/treatments/side-effects/treatment-induced-menopause)

**Clinical — Tier 2 (ASCO / NCCN Patient / Menopause Society / BGCS–BMS / SGO / peer-reviewed):**
- [NCCN — Survivorship: Cancer-Related Late and Long-Term Effects (Patient Guideline PDF, 2024)](https://www.nccn.org/patients/guidelines/content/PDF/survivorship-crl-patient.pdf)
- [Lancet — Managing menopause after cancer (2023)](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(23)02802-7/fulltext)
- [British Gynaecological Cancer Society & British Menopause Society — Management of Menopausal Symptoms after Gynaecological Cancer (2024, PDF)](https://www.bgcs.org.uk/wp-content/uploads/2024/09/BGCS-BMS-Guidelines-on-Management-of-Menopausal-Symptoms-after-Gynaecological-Cancer-09.09.24.pdf)
- [Menopause Society — Management of genitourinary syndrome of menopause (position statement PDF)](https://menopause.org/wp-content/uploads/2024/09/Management_of_genitourinary_syndrome_of_menopause.97565-2.pdf)
- [Management of genitourinary syndrome of menopause in breast cancer survivors: an update — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8894268/)
- [Maintaining Sexual Health throughout Gynecologic Cancer Survivorship: A Comprehensive Review and Clinical Guide — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC4835814/)
- [Clinical practice guidelines: sexual dysfunction in gynecological cancer patients — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12401004/)
- [SGO — Updates to post-treatment surveillance after curative-intent treatment for gynecologic cancers: a clinical practice statement (Gynecologic Oncology, 2025)](https://www.gynecologiconcology-online.net/article/S0090-8258(25)01098-4/fulltext)
- [Menopause in gynecologic cancer survivors: evidence for decision-making — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11805534/)
- [Late symptoms in long-term gynaecological cancer survivors after radiation therapy: a population-based cohort — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3171018/)
- [Vaginal Estrogen Safety for GSM in Breast Cancer Survivors — AUA News (2024)](https://auanews.net/issues/articles/2024/june-extra-2024/vaginal-estrogen-safety-for-genitourinary-syndrome-of-menopause-in-breast-cancer-survivors)
- [Therapeutic Choices for GSM in Breast Cancer Survivors: A Systematic Review and Update — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10142093/)
- [Australasian Menopause Society — Early Menopause Due to Chemotherapy and Radiotherapy](https://www.menopause.org.au/hp/information-sheets/early-menopause-due-to-chemotherapy-radiotherapy)
- [OncoLink — Survivorship: Late Effects After Radiation for Gynecologic Cancers](https://www.oncolink.org/cancers/gynecologic/support-and-survivorship/survivorship-late-effects-after-radiation-for-gynecologic-cancers)

**Patient journey / unmet needs / emotional load (qualitative + reviews):**
- [The Impact of Unmet Needs on Fear of Cancer Recurrence in Cancer Survivors — CMAR / Dove Medical Press](https://www.dovepress.com/the-impact-of-unmet-needs-on-fear-of-cancer-recurrence-in-cancer-survi-peer-reviewed-fulltext-article-CMAR)
- [Breast cancer survivor's sexual health unmet supportive care needs: a mixed-methods study — Journal of Cancer Survivorship](https://link.springer.com/article/10.1007/s11764-025-01926-x)
- [From Sexual Dysfunction to Anxiety, Cancer Survivors Struggle Post Treatment — University of Central Florida / EurekAlert](https://www.ucf.edu/news/sexual-dysfunction-anxiety-many-cancer-survivors-struggle-post-treatment/)
- [Physical and Psychological Long-Term and Late Effects of Cancer — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC7047657/)

**Competitor / app landscape:**
- [Outcomes4Me — Cancer Care (App Store)](https://apps.apple.com/us/app/outcomes4me-cancer-care/id1404382419)
- [Publicly available apps for cancer survivors: a scoping review — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6773350/)
- [Mobile Health Apps for Breast Cancer: Content Analysis and Quality Assessment (incl. OWise) — JMIR mHealth](https://mhealth.jmir.org/2023/1/e43522)
- [Belong.Life (BELONG) — cancer community app](https://belong.life/)

*Community material (cancer forums, survivor networks, and app reviews) is internal qualitative research used only to shape questions, tone, and workflow; wording is editorial paraphrase, not quotation or prevalence evidence. Public copy excludes any unpinned treatment, HRT, surveillance, dilator, late-effect, or fear-of-recurrence number. Sexual-health education is pinned to NCI above; privacy controls use the [FTC Flo](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v) matters. Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
