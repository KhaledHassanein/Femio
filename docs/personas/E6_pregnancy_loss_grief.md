# Persona E6 — Pregnancy Loss & Stillbirth Grief: The Immediate and Ongoing Aftermath

> Femio persona spec. **Maximum-sensitivity persona — the destination state of the universal loss handler (Master §6).** E6 is where every pregnancy-track persona routes on a reported loss (miscarriage at any trimester, stillbirth, or neonatal death), and where the loss-suppression contract (C5 §G) lands the user. Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, prevent, or contracept.** Screeners = *"screening — discuss with your clinician."* Red flags = *"seek care now,"* never a diagnosis.
> Tone guardrail — **the strictest in the entire product:** silence-over-risk; nothing celebratory, ever; no baby-content pushed, ever; no fixing, no silver linings, no "at least…," no "everything happens for a reason," no timelines imposed on grief. The default register is **quiet, acknowledging, and opt-in.** When in doubt, say less.
> Persona code: **E6** · Cohort: Postpartum/aftermath (E) · Entered from: **any D-track state, C-track pregnancy, or wizard** · Downstream (only if she chooses): **C5** (recurrent workup) · **TTC-after-loss / D2** (PAL) · or **staying held in E6 indefinitely** — a first-class outcome, not a failure state.
> Last research pass: 2026-07-21

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Mariam," 31 |
| **Age band** | Any reproductive age (~18–45+). Grief is age-independent. |
| **Stage** | Days to months (sometimes years) after a **miscarriage (any trimester), stillbirth, or neonatal death**. May have just left the hospital; may be navigating the first anniversary; may have been carrying this quietly for a long time and only now telling an app. |
| **How she arrives** | (a) **In-app transition** — she was in any D-track state (D1–D17, incl. D2) or early C-track pregnancy and reported a loss → universal loss handler fires → E6. (b) **Wizard entry** — a new user selects "I've experienced the loss of a pregnancy or baby" (offered plainly, without euphemism, without forced detail). (c) **Return after silence** — she deleted/abandoned the app at the loss and comes back weeks later. |
| **Goal (top JTBD)** | *"Don't make this worse. Tell me what my body is doing and when to worry. Let me grieve at my own pace, in my own way, in my own faith. Don't rush me anywhere. And never, ever surprise me with something cheerful."* |
| **Relationship** | Often partnered — partner grieves too, usually differently and usually invisibly. Solo users first-class. Family/in-law dynamics can add pressure (esp. MENA: pressure to "move on" or "try again," or conversely, silence and stigma). |
| **Health literacy** | Highly variable — from a first pregnancy ended at 7 weeks with no warning, to a mother who spent weeks in a NICU and can read a discharge summary. Content must work at grade 6–8 without ever being patronizing. |
| **Tech context** | Web-first, phone-heavy, often at night. **App-wounded:** she may have just been re-traumatized by a happy-path app that kept counting down to a due date that no longer exists. Deep mistrust of notifications is the default assumption. |
| **Locale** | Arabic-first / RTL first-class; EN/FR/ES. In AR/MENA contexts loss may be private/stigmatized, mourning is often religiously structured (see §D cultural grounding), and lactation-after-loss is close to unspeakable. Modesty-, faith-, and privacy-aware framing is essential. |
| **Emotional state** | Acute grief: shock, numbness, waves of sorrow, guilt/self-blame ("what did I do?"), anger, envy of pregnant friends, empty-arms ache. Grief is **nonlinear** — it does not proceed in stages and it resurges at anniversaries, due dates, and out of nowhere. After later loss: the physical aftermath (bleeding, milk coming in) collides with the emotional one. Neonatal death adds NICU trauma and decisions no parent should have to make. |
| **What she is NOT** | Not "over it" by any deadline. Not obligated to heal, try again, seek answers, or memorialize. Not a risk to be managed or a funnel to be converted. Not the same as every other bereaved mother — some want information, some want silence, some want ritual, some want none. |
| **Primary signals she brings** | Loss record {date, gestation, type} (all optional), physical-recovery status (bleeding, pain, milk), mood, key dates (due date, loss date), faith/cultural preferences (only if volunteered), whether she wants check-ins at all. |
| **Success = …** | Femio was **the one surface that never hurt her.** It stayed quiet when she needed quiet, answered "is this normal?" about her body without flinching, told her when to seek care, honored her baby exactly as much as she chose, held her partner too, and — months or years later, only if and when *she* opened the door — walked with her to C5, TTC-after-loss, or D2. Or she simply stayed, held, indefinitely. Any of these is success. |

**Persona thesis.** E6 is the **sacred contract** of the entire product. Research on 166 pregnancy apps found **72% do not account for loss at all**, 18% let you report it and then abandon you, and only 10% passively link elsewhere ([The Conversation, 2021](https://theconversation.com/pregnancy-apps-and-online-spaces-fail-to-support-individuals-grieving-a-pregnancy-loss-heres-what-to-do-about-it-171337)). The category's worst failure — "your baby is the size of a banana" arriving after the baby has died — is Femio's founding anti-pattern. But E6 must be more than suppression: after a later loss her body goes through **postpartum without a baby** — bleeding, afterpains, and milk coming in, which almost no one warns her about and which she may experience as a devastating betrayal by her own body. E6's job is threefold: (1) **absolute emotional safety** (instant, atomic, fail-safe silence on everything celebratory — forever, until she says otherwise); (2) **gentle, honest physical-recovery and "what happened" education** with clear seek-care routing; (3) **grief held without agenda** — nonlinear, faith-aware, partner-inclusive, anniversary-respecting, with professional-support routing when grief signals it — and **paths forward that exist only behind doors she opens herself.**

---

## B. Needs & questions (voice-of-user)

Mined from r/Miscarriage, r/babyloss, r/ttcafterloss, r/NICUParents, Sands / Tommy's / Miscarriage Association communities, PSI loss groups, Star Legacy and Return to Zero communities, and app-store reviews. Phrasing is representative/composite (community norms; not quoting individuals).

**The immediate aftermath — her body:**
1. *"How long will I bleed? How much is too much?"* — the most common physical question at every gestation.
2. *"Nobody told me my milk would come in. I was standing in the shower and it happened and I broke."* — after later loss (~16+ weeks), lactation arrives regardless; almost universally unanticipated, deeply distressing, and unspoken. She needs to know **before** it happens, what her options are (suppression, comfort measures, or — for some — expressing/donating as part of grieving), and that whatever she feels about it is okay.
3. *"When will the pregnancy symptoms stop? When will the test go negative?"* — the cruelty of a body that lags the truth.
4. *"Do I still need my postnatal check? What do I say when they ask about the baby?"* — she still needs postpartum care; walking into a clinic full of newborns is its own wound.
5. *"When will my period come back? What does my first period after this feel like?"* — cycle-return questions, asked warily.

**What happened — gentle medical education:**
6. *"Why did this happen? Was it something I did — the coffee, the lifting, the stress, the flight?"* — guilt and self-blame are near-universal; needs cited, gentle myth-vs-evidence ("most miscarriages are caused by chromosomal chance, not by anything you did").
7. *"What do these words mean — 'missed miscarriage,' 'incomplete,' 'D&C,' 'expectant management'?"* — she may have been given options at the worst moment of her life with no glossary.
8. *"Will they investigate? Why won't anyone test after one loss?"* — honest education on when workups are typically offered (recurrent loss; any stillbirth usually gets a review/post-mortem offer) — routed to C5 education **only if she asks**.
9. *(Stillbirth/neonatal)* *"What is a post-mortem / placenta review? Do I have to decide now?"* — decision-support education, never pressure in any direction.

**Grief — hers, theirs, everyone's:**
10. *"Am I grieving wrong? It's been [X] and I'm worse, not better."* — nonlinear grief needs normalizing; also honest education on when grief may need professional support (prolonged grief, depression, trauma symptoms).
11. *"My husband seems fine. Is he? We can't talk about it."* — partner grief asymmetry: partners often grieve delayed, practically, silently; society often doesn't grant them grief at all.
12. *"Everyone else has moved on. People say 'you can try again' like my baby was replaceable."* — the loneliness of disenfranchised grief; the wounding vocabulary of comforters.
13. *"The due date is coming. I'm dreading it and no one else remembers."* — anniversary/due-date dread; she wants **control**: mute it, mark it privately, or have it silently held.
14. *"Was my baby a person? Can I name them? Is it strange to keep the scan photo?"* — memorial ambivalence; some want memory-making, some can't bear it, many change their minds later. All valid.
15. *(Faith/MENA)* *"What does my religion say — is there a burial, a prayer, a mourning period? Will my baby be waiting for me?"* — religious frameworks can be a profound comfort (e.g., Islamic teachings honoring the miscarried child) or a source of pressure; Femio informs gently and never adjudicates.

**Paths forward — only if she opens the door:**
16. *"When is it physically safe to try again? When will I be *ready*?"* — two different questions; both education, neither a push.
17. *"This is my second/third loss. I want answers."* — the C5 doorway.
18. *"I'm scared to ever be pregnant again."* — also valid; not everyone routes forward, and Femio never implies she should.

**Anti-needs / trust-breakers (each one is severe, potentially unforgivable harm):**
- **Any celebratory, milestone, baby-development, fruit-size, countdown, or "congratulations" surface after the loss.** One leak destroys all trust.
- **Being asked to re-explain or re-confirm the loss.** State it once; the system remembers; no re-prompting ("are you still pregnant?" is a knife).
- **Baby-content ambush** — ads, community posts, "related articles" with bump photos or newborns.
- **Grief timelines** — "you should be feeling better by now," stage models presented as a schedule, streaks/gamification of any kind.
- **Silver linings** — "at least it was early," "at least you know you can conceive," "everything happens for a reason," "he's in a better place" (unless *her* faith framing, chosen by her).
- **Auto-routing to trying again** — any unprompted "ready to try again?" nudge is a betrayal. The door to C-track opens from her side only.
- **Data exposure** — loss data is among the most sensitive and, in some jurisdictions and social contexts (incl. MENA stigma and, in some places, legal scrutiny of pregnancy outcomes), highest-risk data a product can hold.

**What "good" looks like to her.** An app that went quiet the moment she told it — and stayed quiet. A single gentle surface that says her name for the loss only in her words. Answers about bleeding and milk at 3 a.m. without a single cheerful pixel. A private place for the date that matters. Something for her partner. And doors — closed, unlocked, hers.

---

## C. Competitor teardown

**Key insight for Femio:** loss handling is the category's most documented failure. Research: of 166 pregnancy apps analyzed, **72% ignore loss entirely; 18% accept a loss report and provide nothing; 10% link out passively** ([The Conversation](https://theconversation.com/pregnancy-apps-and-online-spaces-fail-to-support-individuals-grieving-a-pregnancy-loss-heres-what-to-do-about-it-171337)). Northeastern's analysis of 4,000+ reviews of six popular pregnancy apps found pervasive complaints that apps "assume every pregnancy ends in a live birth" and keep sending baby-size updates after a loss ([Northeastern, 2024](https://news.northeastern.edu/2024/12/04/pregnancy-tracking-apps-research/)). Nobody serves the *aftermath itself* — the bleeding, the milk, the grief, the faith, the partner, the anniversary — as a first-class product state.

| Product | Loss aftermath support | Physical recovery after loss | Lactation-after-loss | Grief support | Notable gap |
|---|---|---|---|---|---|
| **BabyCenter / What to Expect / Pregnancy+** | None — loss = delete the app; countdown emails keep firing | None | None | Forums only (announcement-trigger-heavy) | The archetypal harm surface; ad-supported baby content everywhere |
| **Flo** | Loss loggable; limited reconfiguration; pregnancy content repopulates awkwardly | Minimal | None | Light articles | Happy-path core; FTC 2021 privacy history; no aftermath state |
| **Ovia** | Users report marking loss as a "period" to silence prompts | None | None | Minimal | No true loss state (C5 teardown); employer channel data optics |
| **Clue** | Pregnancy-end loggable; low harm surface (less baby machinery) | Some neutral content (has a stillbirth article) | Mentioned editorially | No journey | Not built for the aftermath; no grief/faith/partner surface |
| **Peanut (community)** | Loss/TTC-after-loss community groups | None | None | Peer support (unmoderated-risk; announcement exposure) | Community ≠ care pathway; no tracking, no education spine |
| **Pregnancy After Loss App (PALS)** | **The tone bar** for pregnancy *after* loss | N/A (next-pregnancy focus) | N/A | PAL-specific daily support | Starts at the *next* pregnancy — the aftermath itself is out of scope; EN-only; no lifespan account |
| **Specialist orgs (Sands, Tommy's, Miscarriage Association, PSI, Star Legacy, Return to Zero, M.E.N.D., CLIMB)** | **The content/support gold standard** — helplines, memory boxes, bereavement midwife model, loss-specific groups (incl. dads, NICU, multiples, TFMR) | Excellent leaflets | Sands/Star Legacy/LLL cover it | Best-in-class | Not apps; no tracking; largely EN; Femio should **bridge to them, never replace them** |

**The opening for Femio.** No product offers **one account** where the loss is (a) absorbed instantly and safely (suppression contract), (b) followed by an actual aftermath experience — physical-recovery education with red-flag routing, lactation-after-loss education *before the milk arrives*, gentle "what happened" explainers, (c) grief held nonlinearly with faith-aware (incl. Islamic/MENA) and partner-inclusive framing, (d) anniversaries under her control forever, (e) professional-support routing when grief needs it, and (f) doors to C5 / TTC-after-loss / D2 that open **only from her side** — in four languages, RTL-first, privacy-by-design. E6 is not a feature; it is the proof of the brand.

---

## D. Clinical & cultural grounding (cited)

> All claims are patient-education framing, medically reviewed and cited. Femio does **not** diagnose, treat, prevent, or contracept. Every hard statement below ends, in product, with "discuss with your clinician" or "seek care now" as appropriate.

**Definitions (locale-honest).**
- Miscarriage/stillbirth thresholds differ between countries and between clinical care, registration, and international statistics: CDC's U.S. public guidance uses 20 weeks, while WHO uses 28 weeks for international comparison and says the national definition should be used where relevant. Femio does not infer a legal category or rank a loss; it uses the family's/care team's term and explains that local definitions vary. **Neonatal death** means death of a live-born baby within the first 28 days. ([CDC, August 2025](https://www.cdc.gov/stillbirth/about/index.html); [WHO stillbirth](https://www.who.int/health-topics/stillbirth); [reviewed rule](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md); reviewed Mohamed K., 23 July 2026.)

**Physical recovery after miscarriage.**
- Bleeding for up to ~2–3 weeks, with lighter bleeding/spotting up to ~4–6 weeks; cramping, tiredness, and hormonal shifts are expected. Pads (not tampons) while bleeding to reduce infection risk. ([NHS inform — Early miscarriage](https://www.nhsinform.scot/illnesses-and-conditions/pregnancy-and-childbirth/losing-a-baby/early-miscarriage/); [Miscarriage Association — After a miscarriage](https://www.miscarriageassociation.org.uk/information/miscarriage/after-a-miscarriage/); [Tommy's — What happens to my body](https://www.tommys.org/baby-loss-support/miscarriage-information-and-support/your-options-and-decisions/what-happens-my-body-during-miscarriage))
- **Seek care now:** very heavy bleeding (soaking pads hourly), large clots, severe pain, fever ≥38°C / flu-like symptoms (possible endometritis), foul-smelling discharge, feeling faint. ([NHS inform](https://www.nhsinform.scot/illnesses-and-conditions/pregnancy-and-childbirth/losing-a-baby/early-miscarriage/))
- Management pathways she may have experienced or be choosing between — **expectant, medical, or surgical** — are explained as a glossary, never a recommendation. Eligibility, medicine, procedures, and follow-up come from her early-pregnancy service. [NICE NG126, updated 17 June 2026](https://www.nice.org.uk/guidance/ng126/chapter/management-of-miscarriage). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
- Bleeding, pregnancy-test results, hCG follow-up, and return of cycles vary with the type of loss and management. Femio gives no clearance or first-period timeline; it mirrors the service’s follow-up plan. NICE advises a home pregnancy test at 3 weeks in specified miscarriage pathways and individualized review for a positive result or ongoing symptoms. [NICE NG126](https://www.nice.org.uk/guidance/ng126/chapter/management-of-miscarriage). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Physical recovery after stillbirth / later loss (postpartum without a baby).**
- Her body does **many of the same things as after a live birth** — heavy lochia narrowing over weeks, afterpains, perineal or cesarean healing, night sweats. Bereaved mothers say they wish someone had told them this. ([Tommy's — Physical effects and recovery after stillbirth](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/physical-effects-stillbirth); [Pregnancy Birth & Baby (AU) — Your body after stillbirth or neonatal death](https://www.pregnancybirthbaby.org.au/your-body-after-stillbirth-or-neonatal-death))
- **Red flags mirror postpartum (E1/CDC Hear Her):** soaking a pad in 1–2 hours, clots larger than ~a £2 coin/golf ball, fever ≥38°C, severe headache/vision change, chest pain/breathlessness, one-leg swelling/pain, wound infection signs, thoughts of self-harm. ([Tommy's](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/physical-effects-stillbirth); [CDC Hear Her — Urgent Maternal Warning Signs](https://www.cdc.gov/hearher/maternal-warning-signs/index.html))
- **Postnatal care still applies:** community/bereavement midwife follow-up and a postnatal check ~6–8 weeks; Femio nudges (opt-in, gently) because bereaved mothers often skip their own care. ([Tommy's — Postnatal care after a stillbirth](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/postnatal-care-after-stillbirth))

**Lactation after loss — the devastating, unspoken one (E6's signature education).**
- After a loss from roughly **16–18 weeks onward**, milk usually comes in a few days after delivery, driven by the placental hormone drop — regardless of intention. Warning her **in advance** is itself care. ([Breastfeeding Support — Lactation after stillbirth and infant loss](https://breastfeeding.support/lactation-after-stillbirth-infant-loss/); [Infant Journal — Management of lactation following the death of a baby](https://www.infantjournal.co.uk/journal_article.html?id=7197))
- **Her options (education only, all valid):** gradual/comfort-based suppression, clinician-assessed medication, continued expression, or milk donation where available. NHS guidance describes a supportive bra, cold packs, gradual reduction when supply is established, and clinician assessment for cabergoline, which may not suit everyone. Femio never recommends or doses it. There is no emotionally “correct” choice. ([Leeds Teaching Hospitals NHS Trust](https://www.leedsth.nhs.uk/patients/resources/lactation-following-pregnancy-or-infant-loss/); [RCOG Green-top 55](https://www.rcog.org.uk/media/0fefdrk4/gtg_55.pdf); [reviewed rule](../compliance/REPRODUCTIVE_TREATMENT_SAFETY.md); reviewed Mohamed K., 23 July 2026.)
- Mastitis/engorgement warning signs get seek-care framing (inherited from E2 content, stripped of all baby-feeding context).

**Why it happened — gentle education against self-blame.**
- Most early miscarriages are caused by **chromosomal chance** (~50% of miscarriages involve embryo chromosome anomalies) — not by stress, working, lifting, sex, exercise, or ordinary coffee. It is **not her fault**. (Carried from C5 grounding: [NHS inform — Miscarriage causes]; [Tommy's]; [StatPearls — NCBI](https://www.ncbi.nlm.nih.gov/books/NBK554460/))
- After **late intrauterine fetal death/stillbirth**, the maternity/bereavement team explains available examinations, investigations, consent, and review according to local law and service policy. Femio provides a neutral question list, not a universal test or post-mortem menu, and prompts the user to tell the team about time-sensitive family or faith needs. [RCOG Green-top Guideline No. 55, second edition, reviewed 29 October 2024](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/care-of-late-intrauterine-fetal-death-and-stillbirth-green-top-guideline-no-55/). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
- **Workup honesty:** a single early miscarriage typically doesn't trigger investigation; **2+ losses** may (C5 education); **any stillbirth/neonatal death** typically receives case review. Framed as "what care systems usually offer — ask your team," never a verdict.

**Grief — nonlinear, and when it needs more.**
- Grief after pregnancy/baby loss is intense, wave-like, and **does not follow ordered stages**; anniversary and due-date reactions are normal, not relapse. ([Tommy's — Grieving for your baby after stillbirth](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/coping-grief-after-loss-baby-parents); NICU grief literature: [PubMed 15960010](https://pubmed.ncbi.nlm.nih.gov/15960010/))
- **Prolonged grief disorder (education, never a self-diagnosis):** DSM-5-TR describes persistent, pervasive longing/preoccupation plus accessory symptoms, functionally impairing, **≥12 months** after the loss and exceeding cultural/religious norms; loss of a child is a recognized high-risk category. Femio's framing: *"Grief has no deadline. But if grief is making daily life impossible — especially many months on — support exists and helps. This is a screening conversation for a professional, not a label."* ([Weill Cornell — DSM-5-TR PGD criteria](https://endoflife.weill.cornell.edu/advanced-directives/dsm-5-tr-consensus-criteria-prolonged-grief-disorder); [PMC — PGD in ICD-11 and DSM-5-TR](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10881750/))
- **Depression/anxiety/PTSD** risk is elevated after loss (esp. stillbirth/neonatal death); mood screening (EPDS-family, non-diagnostic) with the universal **Q10/self-harm → immediate crisis path**. ([PMC — distress, PTS after perinatal death](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12315086/); ACOG perinatal mental-health CPG, inherited from D2/E3.)

**Partner grief (asymmetry is the norm, not a problem to fix).**
- Fathers/partners report fewer overt grief symptoms but grieve **qualitatively differently and often delayed** — absorbed by practical demands (funeral arrangements, income, "staying strong") and denied social permission to grieve; grief asymmetry can strain couples, though many report growing closer over the first year. ([PMC — Men's grief following pregnancy loss and neonatal loss: systematic review](https://pmc.ncbi.nlm.nih.gov/articles/PMC6953275/); [Fathers' experiences meta-ethnography](https://www.tandfonline.com/doi/full/10.1080/07481187.2025.2452486); [Perinatal Support WA — Dads Grieve Too](https://perinatalsupport.org/dads-grieve-too-5-ways-to-acknowledge-and-support-grieving-fathers-in-the-aftermath-of-pregnancy-and-infant-loss/))

**Cultural & religious mourning (MENA-aware; inform, never adjudicate).**
- **Islamic frameworks** honor pregnancy loss: depending on gestation/formation, the baby may be named, washed, wrapped, and buried; janazah prayer applies to a baby who showed signs of life; condolence (ta'ziyah) is traditionally ~3 days; burial is prompt. Teachings that the lost child intercedes for/awaits the parents are a source of deep comfort for many. Practices vary by school (madhhab) and region — Femio presents this as *"what many families and scholars describe — your imam/community can guide you,"* never a ruling. ([National Burial Council — Islamic funeral rites for miscarriage and stillbirth](https://nbc.org.uk/islamic-funeral-rites-for-miscarriage-and-stillbirth/); [PMC — Rituals of infant death: Islamic personhood](https://pmc.ncbi.nlm.nih.gov/articles/PMC3992898/); [Sands — Muslim care box](https://www.sands.org.uk/support-you/how-we-offer-support/memory-box))
- Faith/cultural notes are optional and descriptive, never universal. No claim about a community’s beliefs, blame, mourning period, burial practice, or pressure to conceive is published without a named local reviewer and source; otherwise the module says only “your chosen faith/community adviser can guide you.” *(Approved Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Memorial choices (all optional, reversible, hers).**
- Memory-making — seeing/holding the baby (later loss), photos, hand/footprints, naming, memory boxes (Sands provides memory boxes incl. a **Muslim care box**), certificates of loss where jurisdictions offer them, remembrance events (e.g., Baby Loss Awareness Week, Wave of Light) — is associated with meaning-making and continuing bonds for many parents; **and** some parents decline, or change their minds later. Both honored. ([Sands — Memory box](https://www.sands.org.uk/support-you/how-we-offer-support/memory-box); [Tommy's — Remembering your baby](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/remembering-your-baby-after-stillbirth); [NBCP](https://www.nbcpathway.org.uk/wp-content/uploads/2024/03/NBCP-Stillbirth-July-2022.pdf))

**Trying again — physical vs. emotional readiness (education behind her door only).**
- **Trying again is individualized:** Femio publishes no universal waiting interval and no claim that conceiving within a particular number of months improves outcomes. Physical recovery, treatment/follow-up completion, the type of loss, medical conditions, and emotional readiness all matter; the treating clinician and the user decide when to discuss trying again.
- **Ongoing condition care continues:** thyroid, diabetes, hypertension medication/monitoring do not stop with the pregnancy — E6 retains prescribed-med reminders and routes "your medication plan may change now — contact your clinician" (education, never a dose). (Inherited from D7/D4/D5 layers per Master §6 loss handler.)

*Publication rule after medical review:* the global persona does not give a medication regimen, an individual hCG-clearance prediction, PGD eligibility criteria, or a fixed interval before trying again. It uses qualitative urgent-care language (“heavy or worsening bleeding, severe pain, fever, fainting, or feeling very unwell”) and tells the user to follow her own maternity/early-pregnancy service’s discharge instructions. Management and follow-up education is anchored to [NICE NG126, updated 17 June 2026](https://www.nice.org.uk/guidance/ng126); later-loss care is anchored to [RCOG Green-top Guideline No. 55, second edition, reviewed 29 October 2024](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/care-of-late-intrauterine-fetal-death-and-stillbirth-green-top-guideline-no-55/). Medicine, investigation, post-mortem, and faith/practice details remain clinician- or jurisdiction-specific modules. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — Must-have (the sacred contract + the aftermath itself):**
1. **The loss-suppression contract, executed and permanent (inherited C5 §G — the single most important behavior in Femio).** On loss report from any state: instant, atomic, pre-render suppression of ALL celebratory/milestone/countdown/baby-development/fertile-window/TWW content and notifications; no "log it as a period" hack; no re-prompting, ever; data preserved intact; fail-safe defaults to silence. Suppression is **permanent by default** — cheerful surfaces return only when she explicitly enters a new state.
2. **Quiet acknowledging home.** A single, still surface: a soft acknowledgment in her chosen words (she can name the baby, or not; "your loss" is the default), one optional check-in affordance, physical-recovery access, seek-care access, and nothing else. No streaks, no badges, no cards vying for attention.
3. **"Your body now" — physical-recovery guide, gestational-severity-aware.** Branches by loss type/gestation: early miscarriage (bleeding arc, pain, hCG/test lag, management-pathway glossary) vs. later loss/stillbirth/neonatal (full postpartum-without-a-baby arc: lochia, afterpains, wound care, night sweats — E1's recovery content re-authored with all baby context removed). Embedded red-flag boxes throughout.
4. **Lactation-after-loss module — surfaced *proactively and gently before the milk comes in* for losses ≥ ~16 weeks.** "Your milk may come in — this is your body responding to birth, not a cruelty aimed at you. Here are your options." Suppression comfort measures, medication-exists education (clinician-routed, never dosed), and the donation path (faith-aware). This module is E6's signature act of care — the thing nobody else says out loud.
5. **Red-flag / seek-care system.** Physical (hemorrhage, infection, clot signs — CDC Hear Her-aligned, active up to 12 months) + emotional (self-harm thoughts → immediate crisis resources, locale-specific). Never diagnosis; always "seek care now" + who to contact.
6. **Grief support & routing.** Validating, nonlinear-grief content ("grief has no schedule; waves are normal"); opt-in gentle check-ins; mood screening (EPDS-family, screening-framed, Q10 crisis rule); **warm routing** to specialist support: Sands, Tommy's, Miscarriage Association, PSI loss programs, Star Legacy, Return to Zero: H.O.P.E., M.E.N.D., CLIMB (multiples), + per-locale/Arabic-language equivalents. Femio is never the therapy.
7. **Date-control center (inherited C5, foregrounded).** Loss date, due date that will never come, delivery date, anniversaries: each **mute / privately mark / hide** — set once, honored forever, nothing ever auto-fires. Default = silence.
8. **Opt-in everything.** Every E6 surface beyond the quiet home and safety layer is opt-in: check-ins, content depth, memorial features, partner mode, faith content. Her first setting: *"How much would you like from us right now?"* → "just the essentials / gentle support / more." Changeable anytime; "just the essentials" is fully respected.

**P1 — Strong differentiators:**
9. **"What happened" gentle explainers.** Cause education against self-blame ("it was not the coffee, the lifting, the stress"); terminology glossary (missed/incomplete miscarriage, D&C/MVA, expectant management, post-mortem, placental histology); what care systems typically offer and when (single loss vs. recurrent vs. stillbirth review) — honest, cited, never a verdict.
10. **Partner grief mode.** Optional, consent-gated, revocable partner surface that supports **the partner's own grief** (delayed, practical, socially unpermitted) — not "how to help her." Includes dads/partners-specific resources (Star Legacy dads' groups, Sands for partners). Solo users first-class; never nudged toward a partner.
11. **Faith & mourning module (MENA-aware).** Opt-in cultural/religious content: Islamic rites and comforts around pregnancy/infant loss (gestation-sensitive; madhhab-variance acknowledged; "your imam/community can guide you"), mourning-period customs, faith-sensitive notes on post-mortem timing and milk donation; parallel modules per launch locale. Never asserted, never assumed from locale — **she chooses whether faith content appears at all.**
12. **Memorial space (opt-in, reversible).** A private place to name the baby, keep notes/photos/scan images, mark remembrance dates, and learn about memory-making options (memory boxes, certificates, Wave of Light). Fully deletable; declining it is never revisited unless she opens it.
13. **Postnatal-care companion.** Gentle reminders (opt-in) for her own follow-up (bereavement midwife contact, ~6-week check), plus "what to expect at appointments as a bereaved mother" scripts (e.g., asking reception to flag her file so no one asks about the baby).
14. **Continuity of condition care.** Carried thyroid/diabetes/BP layers keep running (per Master §6); one gentle prompt: "your medication or monitoring plan may change now — please contact your clinician."

**P2 — Later:**
15. **Prolonged-grief awareness module** — ~12-month-mark gentle education (only if she's engaged; never an alarm): "if grief is still making daily life impossible, specialized support helps" → routing.
16. Moderated loss-specific peer support (announcement-proof by design; separate spaces for miscarriage / stillbirth / neonatal / TFMR / multiples).
17. Localized grief-counselor and support-group directories per market (Arabic-language priority).
18. PDF export of her physical-recovery + loss record for clinicians (incl. C5 workup handoff).
19. Anniversary remembrance rituals library (cultural variants; opt-in).

**Explicitly OUT of scope for E6 (guardrails):**
- **Any celebratory surface, baby content, or countdown. Ever.** Including "related content" leakage and community exposure.
- **Any unprompted "try again" / TTC / fertility nudge.** The C-track door opens only from her side.
- **Grief timelines, stages-as-schedule, streaks, gamification, engagement mechanics.** E6 success is measured by absence of harm, not engagement.
- **Diagnosing** cause of loss, PGD, depression, or anything else. Screeners flag & route.
- **Any medication instruction** (incl. lactation suppression — "medication options exist; ask your clinician," never a name-dose recommendation in tool form).
- Replacing therapy, religious authority, or bereavement services — Femio routes to all three, supplants none.
- Contraception advice. **Never.**

---

## F. Content modules

> Authored per femio-medical-content (grade 6–8, cited, 4 locales, RTL-first). Every card: sensitivity label = **maximum**, muted visual language (no pinks-and-confetti, no stock photos of babies/bumps anywhere in E6), reviewer + date shown, "not medical advice." Tone spec on every card: **quiet, honest, zero silver linings, zero timelines.** All modules opt-in beyond safety + physical recovery.

1. **"We're so sorry" (arrival card)** — one screen; acknowledges; explains what Femio has done (gone quiet) and that she controls everything from here. Nothing else.
2. **"Your body after an early loss"** — bleeding arc, pain, tests staying positive, management-pathway glossary (expectant/medical/surgical), period return, red flags.
3. **"Your body after a later loss"** — postpartum-without-a-baby: lochia, afterpains, perineal/cesarean healing, night sweats, the 6-week check still matters, red flags.
4. **"Your milk may come in"** (≥ ~16w losses, surfaced proactively) — why it happens, that it's not cruelty, comfort measures, medication-exists education, the donation option, mastitis warning signs. Faith-aware note on donation.
5. **"It was not your fault"** — chromosomal-chance education; myth-vs-evidence on coffee/stress/lifting/sex/travel; gentle, cited, non-dismissive.
6. **"Understanding the words"** — glossary of everything said to her in the hospital, incl. post-mortem/placental-review choices (stillbirth/neonatal) with "you have time to decide" framing.
7. **"Grief has no schedule"** — nonlinear grief, waves, anniversary reactions, numbness, anger, envy — all normal; grieving differently from your partner is normal.
8. **"For partners"** — the partner's own grief: delayed, practical, unwitnessed; permission to grieve; when to seek support; how couples commonly drift and reconnect.
9. **"Mourning in your faith"** (opt-in) — Islamic rites and comforts (gestation-sensitive, madhhab-aware, community-routed); parallel per-locale modules; validation against stigma and pressure.
10. **"Remembering — if and how you choose"** — memory-making options; that declining is equally loving; that changing your mind later is allowed.
11. **"When grief needs more support"** — depression/anxiety/PTSD signs; prolonged-grief education (≥12 months, function-impairing → specialized help exists and works); crisis resources always one tap away.
12. **"Facing the world"** — going back to work, answering "how's the baby?", pregnant friends and baby showers, social-media self-defense (muting triggers), scripts for what to tell people.
13. **"Your follow-up care"** — bereavement-midwife/clinic follow-up, what happens at the postnatal check, questions to ask (incl. review results after stillbirth).
14. **"If you ever want answers"** (behind her door) — when workups are typically offered; what C5's binder does; "no pressure, no timeline."
15. **"If you ever think about trying again"** (behind her door) — physical vs. emotional readiness; the honest evolving evidence on timing; that fear is normal; that never trying again is a valid choice; what D2's gentle mode would look like.
16. **Reachable-but-hidden library:** the entire lifespan library stays searchable — she is never boxed in — but **nothing pregnancy- or baby-related is ever pushed**, and search results in E6 apply the sensitivity skin (no celebratory imagery).

---

## G. Tools, logs & alerts (the gentlest configuration in the product)

> Governing principle: **opt-in everything, date-control, quiet check-ins, silence as the default.** E6 inherits the C5 §G reminder-suppression contract as its founding act and adds almost nothing that makes noise.

**Logs (all optional; nothing required, ever):**
- Loss record {date, gestation, type (miscarriage/stillbirth/neonatal/ectopic/molar/TFMR), her words for it, baby's name (optional)} — entered once, never re-prompted.
- Physical recovery: bleeding trend, pain, temperature, wound/perineum status, breast/lactation status (comfort/engorgement/mastitis-sign), sleep.
- Mood / gentle check-in ("how are you today?" — a word or a color, not a score, unless she opts into screening).
- EPDS-family screener results (opt-in, consent-gated, timestamped, non-diagnostic).
- Key dates {loss date, due-date-that-was, delivery date, anniversaries} each with display_pref (mute/mark/hide; default mute).
- Prescribed meds (carried condition layers + any loss-related prescriptions) — adherence only.
- Memorial content {name, notes, photos} — private, encrypted, user-deletable.

**Tools:**
- Quiet-home controller (the E6 state itself) · physical-recovery guide (gestation-branched) · lactation-after-loss module · red-flag/seek-care surface · gentle check-in · mood screener (opt-in) · date-control center · grief-resource router (locale-aware) · partner mode (consent-gated) · faith module (opt-in) · memorial space (opt-in) · postnatal-visit companion (opt-in) · PDF export.

**Alert policy — the inverse of every other persona:**
- **Default state: zero notifications.** E6 begins with all nudges off. Each alert below exists only if she turns it on:
  - *Gentle check-in* (frequency she sets — daily/weekly/never): "Thinking of you. No need to reply."
  - *Physical-recovery safety prompts* (time-boxed to the recovery window): "If bleeding gets heavier rather than lighter, it's worth calling your midwife/doctor."
  - *Lactation heads-up* (one-time, losses ≥ ~16w, within ~48h): "Your milk may come in over the next few days. When you're ready, we have gentle information about your options." — the only proactive E6 notification that defaults ON, because *not* warning her is the greater harm; dismissible and suppressible.
  - *Follow-up care* (opt-in): "Your check-up is this week. We can share tips for making it easier."
  - *Med adherence* (carried, prescribed-only): unchanged, tone-muted.
  - *Marked dates only*: if she chose "mark": "We're remembering with you today." Nothing more. Never public, never automatic.
- **Crisis exception (always on, inherited universal):** self-harm indication (screener Q10 or logged) → immediate crisis resources + urgent seek-care, locale-specific. This is the one surface that never waits for opt-in.
- **Suppression durability:** cheerful/celebratory logic remains dead in E6 **permanently**; no time-based auto-revival; no "it's been a while — ready to start tracking again?" resurrection prompts. Exit from E6 happens only by her explicit action (§J).

**Mandatory compliance wording:** screening framing on all screeners; "not medical advice — contact your clinician" on all recovery/lactation content; "seek care now" red-flag pattern; no predictive claims of any kind in E6.

---

## H. EMR / data fields (core vs persona-specific)

**Core (one-account spine, inherited):** `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, consent flags, account mode/state, `cycle{...}`, `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]`, `content_history[]`, `screener_results[]`.

**Carried forward on entry (never overwritten, per Master §3):** the full pregnancy layer she came from (`edd`, `gestational_age` at loss, condition sub-layers D3–D17), C5 fields if present (`pregnancy_losses[]`, `rpl_loss_count`, workup data), prescribed `medications[]`, `partner_link` fields. Pregnancy layer is **archived-but-reachable**, never deleted.

**E6 persona-specific:**
- `loss_event` {date, gestational_age, type (miscarriage_t1/t2 | stillbirth | neonatal_death | ectopic | molar | tfmr), delivery_mode (if later loss: vaginal/cesarean — drives recovery content), her_words:string?, baby_name:string?, entered_from_state} → appends to `pregnancy_losses[]`.
- `e6_state` {is_active, entered_ts, reminders_suppressed:true (immutable while active), home_variant:"quiet", support_level ("essentials" | "gentle" | "more")}.
- `physical_recovery` {bleeding_log[], pain_log[], temp_log[], wound_status[], recovery_window_end_estimate, red_flag_events[]}.
- `lactation_after_loss` {applicable:bool (gestation ≥ ~16w), heads_up_shown_ts, path_chosen? (comfort_suppression | clinician_medication | donation | undisclosed), comfort_log[]} — education-tracking only; no medication field beyond prescribed-adherence.
- `key_dates[]` {type (loss_date | due_date_that_was | delivery_date | anniversary | custom), date, display_pref (mute/mark/hide; default mute), recurrence:bool}.
- `grief_support` {checkin_pref (off/weekly/daily), checkin_log[], screener_results[] (consent-gated), routed_to_support[] {org, ts}, prolonged_grief_content_shown:bool}.
- `partner_grief` {partner_link_id?, scope, consent_ts, partner_checkin_log[]} — partner sees **only** partner-mode content; never her logs without explicit scope.
- `faith_prefs` {faith_content_opt_in:bool (default false), tradition?:enum, locale_variant} — **never inferred from locale**; set only by her.
- `memorial` {enabled:bool (default false), name, notes[], media_refs[] (encrypted), remembrance_dates[]} — user-deletable in one action.
- `forward_doors` {c5_door_opened_ts?, ttc_door_opened_ts?, d2_entry_ts?} — records only *her* actions; no system-side scoring of "readiness," ever.

*Data-minimization: loss records, grief data, faith preference, and memorial content are the most sensitive data Femio holds — special-category plus acute social/legal risk in some jurisdictions. Collect only what powers a used feature; encrypt memorial media; one-tap delete; export on demand; no analytics events on E6 content beyond aggregate, de-identified safety metrics. (§K)*

---

## I. Personalization rules (entry → home config; maximum gentleness)

**Entry paths (trauma-informed, minimal, everything skippable):**
- **In-app loss report (primary):** from any pregnant state — a single, calm flow: "We're so deeply sorry." → optional capture {when, how far along} ("share only what you want; you can add or change this anytime") → suppression already executed before this screen rendered → support-level question ("How much would you like from us right now? Just the essentials / gentle support / more") → date-control defaults confirmed (all muted) → done. **Total: ≤3 screens, all skippable after the first.**
- **Wizard entry (new user):** "I've experienced the loss of a pregnancy or baby" → same flow + locale/consent. No euphemisms in the option label; no forced classification of the loss.
- **Return after silence:** if she reappears after abandonment-at-loss (pregnancy state stale, long absence), the app **never** resumes pregnancy UI; it opens on a neutral, quiet screen: "Welcome back. If your circumstances have changed, you can tell us here — or just look around." (Ambiguity defaults to silence per Master §6.)

**Home configuration by sub-state:**
- **Acute (first days–weeks):** quiet acknowledgment + "Your body now" (gestation-branched) + red-flag access + (≥16w) lactation heads-up + one opt-in check-in affordance. Nothing else. **No library carousel, no explore feed.**
- **Early aftermath (weeks–~3 months):** adds (per support level): grief content rail (muted design), partner mode offer (once), faith module offer (once, never repeated if declined), follow-up-care companion, "facing the world" content.
- **Ongoing (months+):** quiet steady state; check-ins at her cadence; anniversary handling per prefs; cycle-return education available (neutral, in library — cycle tracking re-enables **only if she turns it on**; the return of her period is never celebrated, and never used as a "fresh start" hook).
- **~12 months (only if engaged):** prolonged-grief awareness content becomes *available* (never pushed as an alert); mood re-screen offered gently.
- **The two doors (always visible in settings, never on home):** "Looking for answers" (→ C5 education/workup) and "Thinking about the future" (→ TTC-after-loss / D2 education). Doors are labeled neutrally, live under her control, and generate zero nudges.

**Sub-state branching by loss type:**
- **Early miscarriage:** early-loss recovery arc; no lactation module (unless ≥ ~16w); management-glossary emphasized.
- **Later miscarriage / stillbirth:** full postpartum-without-a-baby arc + lactation module + postnatal-care companion + post-mortem/review glossary + memory-making content (offered once, gently).
- **Neonatal death:** as stillbirth, plus NICU-aftermath content (leaving the unit, medical-review meetings, sibling questions) and NICU-loss-specific routing (Star Legacy, NICU Helping Hands).
- **Ectopic/molar:** these remain distinct events in the data model, but global copy gives no hCG schedule, treatment, conception interval, or clearance criterion. Ectopic education follows [NICE NG126, updated 17 June 2026](https://www.nice.org.uk/guidance/ng126); molar follow-up is shown only from the user’s specialist service or a separately verified country module.

**Tone (absolute):** quiet, plain, warm, unhurried. Muted palette; no illustrations of babies, bumps, or storks anywhere in E6; Arabic copy reviewed for register (formal-tender, not clinical-cold). Every surface passes the test: *"Could this wound a mother on the worst day of her life?" If unsure → cut it.*

---

## J. Adaptation triggers (state transitions)

> **Inherits all universal event handlers (Master §6).** E6 *is* the destination of the universal pregnancy-loss handler; the entry row below specifies its receiving side. All exits are **user-initiated only** — E6 is the one state Femio never routes you out of on its own.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Enter E6 — loss reported from any pregnancy state** (D1–D17 incl. D2, or early C-track pregnancy) | user reports loss / taps "I've experienced a loss" | **Suppression contract executes atomically pre-render** (all celebratory/milestone/baby/fertility notifications dead); pregnancy layer archived-but-reachable; condition layers (thyroid/diabetes/BP) **kept running** with "plan may change — contact your clinician" prompt; quiet home; ≤3-screen gentle capture; date prefs default-muted | **E6 active** |
| **Enter E6 — wizard / returning user** | wizard loss branch, or stale-pregnancy return resolved as loss | Same as above minus in-app carryover; ambiguous returns default to neutral silence, never resumed pregnancy UI | **E6 active** |
| **Physical red flag logged** | heavy bleeding (pad/hr), clots, fever ≥38°C, severe headache/vision, chest pain/breathless, leg swelling/pain, wound infection signs | Prominent **"seek care now"** interstitial + locale emergency/maternity contact; log stays raw; active through the 12-month window | Emergency messaging (content only) |
| **Loss ≥ ~16 weeks recorded** | `loss_event.gestational_age` ≥ threshold | One-time gentle lactation heads-up (~48h window); lactation-after-loss module surfaced; mastitis warning signs active | Stay E6 |
| **Mood screen elevated / any self-harm signal** | screener threshold; Q10-equivalent non-zero; free-text flag | **Immediate** crisis resources + urgent seek-care (locale-specific), independent of totals; grief-support routing deepened; screening framing held | Crisis path; E3-style support co-activation |
| **Prolonged-grief signal** | ≥ ~12 months + sustained high-distress check-ins/screens + functional-impact self-report | Gentle availability (never an alarm) of "when grief needs more support" content; routing to grief-specialized professionals & orgs; *"this is a conversation for a professional, not a label"* | Professional-support routing (stay E6) |
| **Partner joins** | partner-mode consent completed | Partner receives partner-grief surface only (own-grief support, resources); scope-limited; revocable | Partner mode active |
| **Anniversary / due-date-that-was approaches** | `key_dates[]` + display_pref | Apply her preference **only** (mute = nothing; mark = one soft private line; hide = date never referenced) | Date-control (no auto-fire) |
| **She opens the "answers" door — recurrent pattern + seeking** | user taps "Looking for answers"; `pregnancy_losses[]` count ≥2 (excl. ectopic/molar per C5 rules) strengthens the offered education | RPL education ("2+ losses is called recurrent loss; a workup can look for causes — your clinician decides"); offer C5's binder/appointment-prep; **never auto-suggested from loss count alone without her door-tap** | **→ C5** (her choice) |
| **She opens the "future" door — TTC-after-loss** | user taps "Thinking about the future" | Readiness education (physical vs emotional; honest timing evidence); gentle minimal tracking offer; E6 grief surfaces remain available in parallel — grief and trying coexist | **→ TTC-after-loss (C-track gentle variant)** (her choice) |
| **Positive pregnancy test while in E6** | test logged / user reports | Universal positive-test handler **with anxiety-aware, muted tone — no loud celebration**; offer D2 (PAL) carrying full loss history, prescribed meds, date prefs; suppression net re-arms inside D2 | **→ D2** (her confirmation) |
| **She asks to return to general tracking** | settings action ("I'd like to track my cycle again") | Re-enable cycle surfaces in neutral (non-TTC) tone; E6 content stays reachable; memorial & date prefs persist for life of account | **→ B-track (gentle skin)** (her choice) |
| **Disengagement / silence** | inactivity | **Nothing.** No win-back campaigns, no "we miss you" — E6 users are permanently excluded from re-engagement marketing. Data retained per retention policy; quiet if she returns | Retain, silent |
| **Another pregnancy later ends in loss again** | loss reported from D2/any state | Re-enter E6; deepen support (recurrent-loss aware); C5 door surfaced slightly more visibly (still her tap); never "at least" framing | E6 (recurrence-aware) |

*All routes preserve the one-account record, default to silence over risk, and keep every exit in her hands. E6 has no time limit, no graduation prompt, and no failure condition.*

---

## K. Compliance flags

1. **The suppression contract is an internal P0 product-safety requirement (inherited C5 §G, owned by E6), not an external medical claim.** It is atomic, pre-render, fail-safe-to-silence, permanent until user action, and covered by automated P0 tests plus manual QA on every release touching notifications, feeds, email, CRM, marketing, or push. Marketing/analytics audiences must consume the suppression flag before rendering or sending. The implementation runbook and test evidence are release artifacts; this requirement does not need an external clinical citation. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
2. **No re-engagement mechanics on E6 users.** No win-back emails, no streaks, no "we miss you," no engagement-optimized experiments. E6 KPIs are harm-absence and safety-path integrity, not retention. Written into the analytics/growth policy.
3. **No diagnosis / treatment / prevention / contraception.** No cause-of-loss verdicts; no PGD/depression labels (screeners flag & route); no medication instruction — lactation-suppression medication is described as *an option that exists; your clinician decides*; comfort measures framed as general self-care education.
4. **Tone safety — the strictest content policy in Femio.** Banned: all celebratory language, "at least…," "everything happens for a reason," "you can try again," "move on," stage-model-as-schedule, any implied timeline, any baby imagery. Faith framings appear only inside the opt-in faith module and only descriptively. Every E6 card passes emotional-safety review in all four languages, with **Arabic register review** (formal-tender) and MENA cultural review mandatory.
5. **Faith content = describe, route, never rule.** No religious-practice claim ships globally. A locale module requires a named community/religious reviewer, dated source, documented variant/scope, and medical/legal review where burial or post-mortem timing is implicated; otherwise Femio routes to the user’s chosen adviser. This is an internal publication control. *(Approved Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Exceptional data sensitivity—the highest tier Femio holds.** Loss events, grief logs, faith preferences, and memorial media are never sent to ad networks, used for targeted advertising, or used for content-level behavioral profiling. Require granular/revocable product permissions, encryption, independent memorial deletion, export, minimum retention, and purpose-limited processor access under [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). Country-specific pregnancy-outcome law and residency rules require local counsel; global copy makes no generalized criminal/legal-risk claim. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
7. **Crisis pathways use a maintained global directory.** Self-harm routing follows [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md): an explicit country selector, a maintained crisis directory, and the WHO-aligned local-emergency-services or nearest-emergency-department fallback. Language never determines country; Arabic and RTL copy requires human linguistic review. *(WHO, 18 September 2024; Find A Helpline accessed 23 July 2026; reviewed Mohamed K., 23 July 2026.)*
8. **Screening framing (inherited, mandatory).** EPDS-family tools = screening only; ranges not labels; Q10/self-harm any-non-zero → immediate crisis path independent of total; consent-gated storage.
9. **Not therapy, not bereavement services.** Femio supports and routes; it never presents itself as counseling or a substitute for bereavement care. Global support uses the explicit country selector and grief/loss topic route in [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). Named organizations appear only in separately verified country content, and non-crisis support stays visually separate from urgent routing. *(Find A Helpline grief/loss directory accessed 23 July 2026; reviewed Mohamed K., 23 July 2026.)*
10. **Medical review + citations.** Global clinical content is limited to education and routing, with [NICE NG126, updated 17 June 2026](https://www.nice.org.uk/guidance/ng126) governing early-pregnancy loss/ectopic management and [RCOG Green-top Guideline No. 55, second edition, reviewed 29 October 2024](https://www.rcog.org.uk/guidance/browse-all-guidance/green-top-guidelines/care-of-late-intrauterine-fetal-death-and-stillbirth-green-top-guideline-no-55/) governing later intrauterine fetal death/stillbirth education. Femio does not publish universal bleeding quantities, medicine instructions, individualized hCG timelines, PGD criteria, a fixed interpregnancy interval, or jurisdiction-dependent post-mortem rules. Those require a verified local clinical module and the user’s treating team. Crisis routing remains centralized in [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
11. **App-store & ads policy.** Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md): no health, loss, grief, pregnancy, baby, or parenting signal is used for targeted advertising; sensitive-content controls apply; required disclosures and Google’s health-app declaration are completed. Apple bars targeted/behavioral advertising based on sensitive health data. Re-check both store policies immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Failure evidence / category research**
- [The Conversation — Pregnancy apps and online spaces fail to support individuals grieving a pregnancy loss (166-app analysis)](https://theconversation.com/pregnancy-apps-and-online-spaces-fail-to-support-individuals-grieving-a-pregnancy-loss-heres-what-to-do-about-it-171337)
- [Northeastern — Are pregnancy tracking apps helpful or hurtful? (4,000+ review analysis)](https://news.northeastern.edu/2024/12/04/pregnancy-tracking-apps-research/)
- [Pregnancy After Loss Support — Pregnancy After Loss App](https://pregnancyafterlosssupport.org/pregnancy-after-loss-app/)

**Physical recovery**
- [NHS inform — Early miscarriage](https://www.nhsinform.scot/illnesses-and-conditions/pregnancy-and-childbirth/losing-a-baby/early-miscarriage/)
- [Miscarriage Association — After a miscarriage](https://www.miscarriageassociation.org.uk/information/miscarriage/after-a-miscarriage/)
- [Tommy's — What happens to my body during and after a miscarriage?](https://www.tommys.org/baby-loss-support/miscarriage-information-and-support/your-options-and-decisions/what-happens-my-body-during-miscarriage)
- [ACOG — What Happens After a Miscarriage? An Ob-Gyn Discusses the Options](https://www.acog.org/womens-health/experts-and-stories/the-latest/what-happens-after-a-miscarriage-an-ob-gyn-discusses-the-options)
- [MedlinePlus — Miscarriage](https://medlineplus.gov/ency/article/001488.htm)
- [Tommy's — Physical effects and recovery after stillbirth](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/physical-effects-stillbirth)
- [Tommy's — Postnatal care after a stillbirth](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/postnatal-care-after-stillbirth)
- [Pregnancy Birth & Baby (AU) — Your body after stillbirth or neonatal death](https://www.pregnancybirthbaby.org.au/your-body-after-stillbirth-or-neonatal-death)
- [CDC Hear Her — Urgent Maternal Warning Signs](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)

**Lactation after loss**
- [Breastfeeding Support — Lactation after stillbirth and infant loss](https://breastfeeding.support/lactation-after-stillbirth-infant-loss/)
- [Infant Journal — Management of lactation following the death of a baby (RCOG-referenced dopamine-agonist guidance)](https://www.infantjournal.co.uk/journal_article.html?id=7197)
- [La Leche League USA — Lactation After Loss](https://lllusa.org/lactation-after-loss/)
- [Star Legacy Foundation — Lactation After a Loss](https://starlegacyfoundation.org/lactation/)
- [PMC — Breast milk donation after perinatal loss: Israeli Arab women and Islamic legal-ethical perspectives](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12733250/)

**Grief, prolonged grief, mental health**
- [Tommy's — Grieving for your baby after a stillbirth](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/coping-grief-after-loss-baby-parents)
- [Weill Cornell — DSM-5-TR consensus criteria for Prolonged Grief Disorder](https://endoflife.weill.cornell.edu/advanced-directives/dsm-5-tr-consensus-criteria-prolonged-grief-disorder)
- [PMC — Prolonged grief disorder in ICD-11 and DSM-5-TR: prevalence and criteria differences](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10881750/)
- [PMC — PGD in DSM-5-TR: early predictors](https://pmc.ncbi.nlm.nih.gov/articles/PMC9131400/)
- [PMC — Psychological distress, post-traumatic stress after a perinatal death](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12315086/)
- [PubMed 15960010 — Grieving parents in the NICU: identifying and understanding the grief response](https://pubmed.ncbi.nlm.nih.gov/15960010/)
- [PMC — Parental needs in infant end-of-life and bereavement in NICU](https://ncbi.nlm.nih.gov/pmc/articles/PMC4960769)

**Partner grief**
- [PMC — Men's grief following pregnancy loss and neonatal loss: systematic review and theoretical model](https://pmc.ncbi.nlm.nih.gov/articles/PMC6953275/)
- [Taylor & Francis — Fathers' experiences of perinatal death: meta-ethnography (2025)](https://www.tandfonline.com/doi/full/10.1080/07481187.2025.2452486)
- [ScienceDirect — New understandings of fathers' grief following stillbirth and neonatal death: scoping review](https://www.sciencedirect.com/science/article/abs/pii/S0266613819302177)
- [Perinatal Support Washington — Dads Grieve Too](https://perinatalsupport.org/dads-grieve-too-5-ways-to-acknowledge-and-support-grieving-fathers-in-the-aftermath-of-pregnancy-and-infant-loss/)

**Cultural / religious mourning**
- [National Burial Council (UK) — Islamic funeral rites for miscarriage and stillbirth](https://nbc.org.uk/islamic-funeral-rites-for-miscarriage-and-stillbirth/)
- [PMC — Rituals of infant death: defining life and Islamic personhood](https://pmc.ncbi.nlm.nih.gov/articles/PMC3992898/)
- [MCC East Bay — Funeral for a miscarried fetus in Islam](https://mcceastbay.org/fetus/)
- [Sands — Memory box and Muslim care box](https://www.sands.org.uk/support-you/how-we-offer-support/memory-box)

**Memorial & bereavement-care pathways**
- [Tommy's — Remembering your baby after a stillbirth](https://www.tommys.org/baby-loss-support/stillbirth-information-and-support/remembering-your-baby-after-stillbirth)
- [National Bereavement Care Pathway — Stillbirth pathway (2022 PDF)](https://www.nbcpathway.org.uk/wp-content/uploads/2024/03/NBCP-Stillbirth-July-2022.pdf)
- [Sands — National Bereavement Care Pathway](https://www.sands.org.uk/professionals/projects-improve-bereavement-care/national-bereavement-care-pathway)
- [ScienceDirect — Memory making and preserving the identity of parenthood after perinatal bereavement](https://www.sciencedirect.com/science/article/pii/S1871519225000368)

**Support-organization routing**
- [PSI — Loss & Grief in Pregnancy & Postpartum](https://postpartum.net/get-help/loss-grief-in-pregnancy-postpartum/)
- [Star Legacy Foundation — Resources](https://starlegacyfoundation.org/resources/)
- [Return to Zero: H.O.P.E.](https://rtzhope.org/2024-provider-spotlight/postpartum-support-international)
- [NICU Helping Hands — Resources for bereaved parents](https://nicuhelpinghands.org/resources/resources-for-bereaved-parents/)

**Trying again (behind her door)**
- [Miscarriage Association — Trying to conceive after miscarriage: when is the 'right time'?](https://www.miscarriageassociation.org.uk/blog/trying-to-conceive-after-miscarriage-when-is-the-right-time/)
- [Tommy's — Trying again after a miscarriage](https://www.tommys.org/baby-loss-support/miscarriage-information-and-support/pregnancy-after-miscarriage/getting-pregnant-after-miscarriage)
- [March of Dimes — Thinking about pregnancy after the death of your baby](https://www.marchofdimes.org/find-support/topics/miscarriage-loss-grief/thinking-about-pregnancy-after-death-your-baby)

*Community insight (r/Miscarriage, r/babyloss, r/ttcafterloss, r/NICUParents, loss-support communities, and app-store reviews) is internal aggregate voice-of-user research, not clinical evidence or attributable quotation. Public support routing uses the explicit country selector and maintained directory in [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md); named organizations, local clinical thresholds, and culturally specific practice guidance appear only in separately verified country modules. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
