# Persona E3 — Postpartum Mood Disorder (PPD / Anxiety / Intrusive Thoughts / Rage)

Prepared: 2026-07-21 · Wave 3 (mood layer over the postpartum spine) · Status: research + spec
Layered on: **E1 (general postpartum recovery)** · Antenatal sibling: **D11 (antenatal depression/anxiety)** — E3 is the postpartum continuation of the same mental-health thread · Inherits: `09_MASTER_ADAPTATION_MODEL` (seven invariants, state object, constant core, universal events, Z1 fallback, blending) · Companion skills: femio-compliance-privacy, femio-medical-content
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Femio never diagnoses, treats, or prevents. Screeners = "screening — discuss with your clinician." Any self-harm signal routes immediately to crisis resources. No diagnostic label, no medication dose, no "you have postpartum depression" is ever shown. Postpartum-psychosis content is education + urgent routing only.**

> Sensitivity note (governs every line of this spec — HIGHEST tier in Femio). Postpartum mental health combines three of the most sensitive things a product can touch: a mother's mood, self-harm risk, and fears about her baby's safety. Copy must be warm, non-judgemental, and shame-free. It must never imply she is a bad or dangerous mother, never sensationalize intrusive thoughts, never reassure ("you're fine") in place of routing to a human, and never make categorical confidentiality claims about any helpline (say "free" and describe the service; do not promise "confidential/anonymous" as an absolute). Silence-over-risk on ambiguous signals. Crisis and psychosis copy is human-reviewed in every language before shipping.

---

## A. Persona snapshot

**Who she is.** A woman in the first postpartum year whose emotional state has gone beyond the expected "baby blues" — persistent low mood, loss of joy, anxiety that won't switch off, frightening intrusive thoughts, uncharacteristic rage, difficulty bonding, or some combination. She may have arrived here three ways: (1) from **E1**, when an EPDS check-in came back elevated or her mood logs trended down; (2) from **D11**, carrying an antenatal mood history forward (antenatal mood is the strongest predictor of postpartum mood — this continuity is the clinically valuable bridge); or (3) directly, self-declaring at onboarding "I recently gave birth and I'm not okay."

**What she is dealing with (the PMAD spectrum, education-framed).**
- **Postpartum depression** — persistent sadness, emptiness, hopelessness, exhaustion beyond sleep deprivation, guilt/worthlessness, difficulty bonding; distinct from the blues by *severity and persistence beyond ~2 weeks*.
- **Postpartum anxiety** — constant worry, racing thoughts, physical symptoms, inability to rest even when the baby sleeps; frequently co-occurs with depression.
- **Intrusive thoughts** — unwanted, distressing thoughts or images of harm coming to the baby (accidental or, disturbingly, by her own hand). These are **extremely common** (reported by the large majority of new mothers) and **having them does not mean she will act on them** — but they generate intense shame and disclosure fear, and at OCD-level frequency/distress they deserve clinical support.
- **Postpartum rage** — sudden, intense, out-of-proportion anger/irritability; a common but under-named symptom of postpartum mood/anxiety difficulties.
- **Postpartum psychosis** — rare (~1–2 per 1,000 births), rapid-onset, and a **medical emergency**. E3 covers it as *education + urgent routing only*: what the warning signs are (for her and, critically, for her family), and that it needs same-day emergency care. Femio never screens for or monitors psychosis.

**Core job.** "Help me understand what I'm feeling — is this still the blues, or something more — without judging me. Let me track my mood over time so I can *see* it and show my clinician. Tell me the truth about intrusive thoughts so I stop believing I'm a monster. Show me that treatment exists, works, and can be compatible with breastfeeding. Help my partner and family understand what's happening. And if I'm ever in a dark place, put help in front of me immediately."

**Emotional state.** Shame ("I'm supposed to be happy"), fear ("if I tell anyone, they'll take my baby"), depletion, isolation, and — underneath — a persistent love for her baby that the illness makes her doubt. The single most important tonal job of E3 is to separate *her* from *the illness*: she is not failing; she has a common, treatable condition.

**Context of use.** Web-first, one-handed, at 3 a.m.; short sessions with very high stakes. Arabic-first/RTL with EN/AR/FR/ES — non-stigmatising postpartum-mental-health content in Arabic is nearly nonexistent, which sharpens both the differentiation and the duty of care.

**Femio's wedge for E3.** One account, one thread: her antenatal mood history (D11), her delivery record (E1), her EPDS trend, and her postpartum mood support live in the same record — no silo, no expiring app, no starting over. Plus: transparent validated screening, honest intrusive-thoughts education, partner-facing education, and crisis-safe, localized routing — none of which the baby-tracker ecosystem offers.

---

## B. Needs & questions (voice-of-user)

Synthesized from postpartum mental-health communities (r/postpartumdepression, r/beyondthebump, r/Mommit PPD threads), app-store reviews, and maternal-mental-health coverage. Paraphrased/representative, not verbatim attributions.

**"Is this still the blues, or is something wrong with me?"**
- "Everyone said the baby blues pass in two weeks. It's week six and I cry every day."
- "I don't feel sad exactly — I feel *nothing*. Is that still depression?"
- "I love my baby but I don't feel the rush everyone describes. Am I broken?"
- "I'm fine during the day and fall apart every night. Does that count?"

**Intrusive thoughts — the highest-shame theme (recurs constantly, always hedged)**
- "I keep seeing horrible images of dropping the baby down the stairs. I would never. Why does my brain do this?"
- "I had a thought about hurting my baby and I've been terrified of myself since. I can't tell anyone."
- "Does having these thoughts mean I'm becoming psychotic?" (→ education must clearly separate ego-dystonic intrusive thoughts from psychosis.)
- "I'm scared that if I tell my doctor, CPS will take my baby away." (→ documented, widespread disclosure barrier; honest, careful framing required — see K.)

**Rage — under-named, guilt-laden**
- "I screamed into a pillow because the baby wouldn't latch. I've never been an angry person."
- "Nobody warned me about the rage. I thought PPD meant crying, not fury."

**Getting help — fear and logistics**
- "Will they force medication on me? Can I even take antidepressants while breastfeeding?"
- "I told my OB at the six-week visit and got a pamphlet. Now what?"
- "Therapy waitlists are months long. What do I do *today*?"
- "How do I even say this out loud? Give me the words."

**Partner/family — the second audience**
- "My husband thinks I just need more sleep. How do I explain this is an illness?"
- "My mother says in her day women just got on with it." (→ culturally aware family-education content matters, especially in Arabic.)
- "What should my partner watch for if I get worse and can't see it myself?"

**What "good" looks like to her.** A private mood record she controls; an EPDS she can repeat and *see over time*; plain-language education that names intrusive thoughts and rage without flinching; treatment information that respects breastfeeding; words to use with her clinician and her family; crisis help that is one tap away and never buried; and a tone that never once implies she is dangerous or failing.

---

## C. Competitor teardown (postpartum mental-health gaps)

Builds on the E1 and D11 teardowns; focus here is the *postpartum mood* layer specifically.

| Product | Postpartum mood screening | Intrusive-thoughts / rage education | Crisis routing | Partner-facing content | Gap Femio exploits |
|---|---|---|---|---|---|
| **Ovia (Postpartum Experience)** | Mood checks within 12-month program; "Critical Alert" pattern | Some mental-health content; not intrusive-thoughts-forward | Alert pattern, not a transparent EPDS-trend flow | Limited | Closest peer; but no transparent longitudinal EPDS trend, privacy optics (employer/Labcorp), not Arabic-first, product consolidating |
| **Flo (postpartum mode)** | Some wellbeing content | Shallow | Limited | No | Mental health thin vs cycle core; FTC-settlement trust deficit |
| **What to Expect / BabyCenter** | None structured; editorial + forums | Editorial only; forums can worsen shame/anxiety | Generic, US-centric | Editorial | No screening, no trend, no safe routing; ad/data models |
| **Baby trackers (Huckleberry, Glow Baby…)** | None | None | None | None | The mother's mind does not exist in these products at all |
| **Dedicated PMAD apps (Mavida-type, "Fourth Trimester"-type, Carea-type)** | Some use EPDS/PHQ; often research-stage | Stronger ethos; variable depth | Varies; often US-only | Occasionally | Siloed from the pregnancy/postpartum/cycle record; not Arabic-first; few validated by RCT ([PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12933385/)) |
| **PSI resources (postpartum.net)** | Directory + helpline + 50+ support groups — the gold-standard *human* resource, not an app | Strong educational pages | Explicitly routes crises to 988/emergency (helpline is not a crisis line) | Yes — partner/family resources | Not a tracking product; Femio should **integrate/point to PSI**, not compete with it |

**Femio's differentiated position for E3.**
1. **Longitudinal EPDS trend** — repeatable screening with a visible, exportable trend line (antenatal D11 scores included), framed as "something to show your clinician," not a verdict. No competitor offers this transparently inside a full lifespan record.
2. **Honest intrusive-thoughts education** — naming the most shameful symptom directly, with evidence that these thoughts are common and are not intent, plus clear "when it deserves clinical support" framing. Near-total whitespace.
3. **Rage named as a symptom** — under-served everywhere.
4. **Partner/family education surface** — opt-in share of *educational content* (never her data by default), including psychosis warning signs for the household — because in psychosis the mother often cannot self-identify.
5. **Crisis-safe, localized, never US-only** — PSI + 988 (US), locale equivalents elsewhere; honest framing of what each line is (support vs crisis) and no categorical confidentiality promises.
6. **Arabic-first / RTL** de-stigmatising postpartum mental-health content — near-empty space, and culturally aware family-education content is the hardest and most valuable part.

---

## D. Clinical grounding (cited)

*All items are education/screening context for Femio content. Femio presents these as general information and screening prompts, never diagnosis, and defers all treatment decisions to the user's clinician.*

**Prevalence — "you are far from alone."** About **1 in 8** women with a recent live birth report symptoms of postpartum depression ([CDC — Symptoms of Depression Among Women](https://www.cdc.gov/reproductive-health/depression/index.html); [OWH — Postpartum depression](https://womenshealth.gov/mental-health/mental-health-conditions/postpartum-depression); [OWH — Talking PPD campaign](https://womenshealth.gov/TalkingPPD)). NIMH frames perinatal depression (pregnancy through ~first year) as common, real, and treatable — "more than the baby blues" ([NIMH — Perinatal Depression](https://www.nimh.nih.gov/health/publications/perinatal-depression)). NHS cites **more than 1 in 10** women within a year of birth, and notes partners/fathers can be affected too ([NHS — Postnatal depression overview](https://www.nhs.uk/mental-health/conditions/post-natal-depression/overview/)).

**Baby blues vs PPD vs psychosis (the core educational distinction).**
- **Baby blues:** up to ~85% of new mothers; tearfulness, mood swings, worry; begins days after birth and **resolves within ~2 weeks** without treatment ([NIMH](https://www.nimh.nih.gov/health/publications/perinatal-depression); [APA — What is peripartum depression](https://www.psychiatry.org/patients-families/peripartum-depression/what-is-peripartum-depression)).
- **PPD:** more severe symptoms lasting **beyond 2 weeks** (or starting later in the first year): persistent sadness/emptiness, anxiety, exhaustion that impairs daily care, sleep/appetite change beyond newborn life, guilt/worthlessness, difficulty bonding, thoughts of self-harm; generally does not resolve without support/treatment ([NIMH](https://www.nimh.nih.gov/health/publications/perinatal-depression); [MedlinePlus — Postpartum depression [NEEDS SOURCE: confirm exact MedlinePlus URL/wording]](https://medlineplus.gov/postpartumdepression.html)).
- **Postpartum psychosis:** rare — roughly **1–2 per 1,000 deliveries** — usually rapid onset in the first days–weeks; hallucinations, delusions (often about the baby), confusion, mania/severe mood swings, not needing sleep, behavior markedly out of character. It is a **psychiatric emergency requiring same-day care**, and the mother often cannot recognize it herself — which is why family education matters ([StatPearls — Postpartum Psychosis (NCBI)](https://www.ncbi.nlm.nih.gov/books/NBK544304/); [PMC review — Phenomenology/epidemiology of postpartum psychosis](https://pmc.ncbi.nlm.nih.gov/articles/PMC7824357/); NHS treats postnatal psychosis as a medical emergency — [NEEDS SOURCE: NHS postpartum-psychosis page exact URL]).

**Intrusive thoughts are common and are not intent (the anti-shame cornerstone).** Studies report that **the large majority of new mothers (~70–100%)** experience unwanted intrusive thoughts of infant-related harm — accidents, SIDS, contamination — and **up to about half** report intrusive thoughts of *intentionally* harming the infant; these thoughts are ego-dystonic (distressing precisely because she doesn't want them) and research indicates they **do not, by themselves, predict harming the baby** ([BMC Psychiatry study protocol / research program on maternal intrusive thoughts](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6429780/); [Cambridge — new mothers' responses to postpartum harm thoughts](https://www.cambridge.org/core/journals/behavioural-and-cognitive-psychotherapy/article/correlates-and-predictors-of-new-mothers-responses-to-postpartum-thoughts-of-accidental-and-intentional-harm-and-obsessive-compulsive-symptoms/09A0A67F64C58ABFE2247EFFB54192C8); [MGH Center for Women's Mental Health — postpartum OCD & intrusive thoughts](https://womensmentalhealth.org/posts/understanding-postpartum-ocd-and-intrusive-thoughts/)). Distinct from psychosis: intrusive thoughts are recognized as unwanted "brain noise"; psychotic thoughts are experienced as real/reasonable. When intrusive thoughts become frequent, ritualized, and disabling, that pattern is associated with **postpartum OCD (~1.7–7%)** and deserves clinical support ([Policy Center for Maternal Mental Health — Maternal OCD](https://policycentermmh.org/maternal-ocd/)). *[NEEDS SOURCE: pin a Tier-1/Tier-2 patient-facing intrusive-thoughts page (e.g., PSI or RCPsych) for user-facing citation rather than journal links.]*

**Postpartum rage.** Significant anger is reported by roughly **1 in 4–5** postpartum women and is described in the literature as a common, overlooked feature of postpartum mood disturbance — a symptom pattern, not a DSM diagnosis ([Cleveland Clinic — Postpartum rage](https://my.clevelandclinic.org/health/diseases/24768-postpartum-rage); UBC research coverage — [NEEDS SOURCE: primary UBC/peer-reviewed citation for postpartum anger prevalence]). → Framed as: "rage can be part of the same picture; it is a signal, not a character flaw."

**Screening — EPDS, repeated over time.** ACOG's 2023 guideline recommends screening for depression and anxiety with validated instruments at the initial prenatal visit, later in pregnancy, **and at postpartum visits** ([ACOG 2023 CPG](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2023/06/screening-and-diagnosis-of-mental-health-conditions-during-pregnancy-and-postpartum)). AAP recommends pediatric-visit PPD screening with the EPDS at the **1, 2, 4, and 6-month** well-child visits — useful context for Femio's gentle re-check cadence ([AAP — perinatal depression screening policy [NEEDS SOURCE: exact AAP policy URL]](https://publications.aap.org/pediatrics/article/143/1/e20183259/37241)). EPDS thresholds (present as **bands, never labels**): **≥10** possible depression (widening detection), **≥13** likely depressive illness; thresholds vary by language/setting ([MGH — Using the EPDS](https://womensmentalhealth.org/posts/using-epds-measure-postpartum-depression-severity/); [EPDS scoring, AAP PDF](https://downloads.aap.org/AAP/PDF/Postnatal%20Depression%20Scale.pdf)). **Q10 (self-harm): any non-zero answer requires immediate attention regardless of total score** — inherited hard rule from E1/D11 ([Black Dog Institute EPDS PDF](https://www.blackdoginstitute.org.au/wp-content/uploads/2020/04/edinburgh-postnatal-depression-scale.pdf)).

**Treatment awareness (educational only — Femio never treats).**
- **Therapy:** CBT and interpersonal therapy reduce postpartum depressive symptoms; NICE CG192 supports facilitated self-help for milder presentations and CBT for moderate–severe ([AAFP — CBT for postpartum depression](https://www.aafp.org/pubs/afp/issues/2019/0815/p244.html); [NICE CG192](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations)).
- **Medication + breastfeeding:** many antidepressants are considered compatible with breastfeeding; sertraline is among the best-studied, with low levels in milk (LactMed) — presented strictly as *"effective treatments exist, and many are compatible with breastfeeding — your clinician can help you weigh options,"* never a recommendation or dose, never "safe to take/stop," never advising abrupt discontinuation ([LactMed — Sertraline](https://www.ncbi.nlm.nih.gov/books/NBK501191/); [NHS — Postnatal depression: treatment](https://www.nhs.uk/mental-health/conditions/post-natal-depression/treatment/)).
- **PPD-specific medications exist:** FDA has approved neuroactive-steroid treatments specifically for PPD (zuranolone, oral, 2023; brexanolone, IV, 2019 — reported no longer commercially available in the US as of 2025). Educational takeaway only: *the field is advancing; ask your clinician what's available where you live* ([Obstetrics & Gynecology — zuranolone/brexanolone review](https://journals.lww.com/greenjournal/fulltext/2026/01000/zuranolone_and_brexanolone_for_the_treatment_of.22.aspx); [PMC — zuranolone review](https://pmc.ncbi.nlm.nih.gov/articles/PMC11535317/)). *[NEEDS SOURCE: verify commercial-availability status and regional relevance per launch market before publishing; omit drug names in locales where unavailable to avoid false hope.]*
- **Untreated PPD matters:** framed as "getting support helps you *and* your family," never as "your low mood is harming your baby."

**Partner/family role.** NHS and third-sector guidance: partners help by listening, taking on night care/housework, encouraging (not forcing) help-seeking, and knowing the psychosis warning signs; partners/fathers can themselves develop postnatal depression ([NHS — Postnatal depression overview](https://www.nhs.uk/mental-health/conditions/post-natal-depression/overview/); [Tommy's — Looking after your partner's mental health after birth](https://www.tommys.org/pregnancy-information/dads-and-partners/your-partners-mental-health-after-the-birth); [Action on Postpartum Psychosis — partner guide (PDF)](https://maternalmentalhealthalliance.org/media/filer_public/2e/09/2e095442-4ebf-4e5b-b9c9-65ebb577f0f0/postpartum-psychosis-a-guide-for-partners.pdf)).

**Support & crisis resources (US anchors; localize per market).** **PSI HelpLine 1-800-944-4773** (call/text; English/Spanish) — free support, resources, and connection to local providers; **explicitly not a crisis line** (staffed hours; crises → 988/emergency) ([PSI — Get help](https://postpartum.net/get-help/)). **988 Suicide & Crisis Lifeline** for crisis (US). **National Maternal Mental Health Hotline 1-833-852-6262 (1-833-9-TLC-MAMA)**, 24/7 ([NIMH perinatal-depression publication references the maternal hotline](https://www.nimh.nih.gov/health/publications/perinatal-depression)). Femio describes services factually ("free," "24/7" where true) and **never makes categorical confidentiality/anonymity claims** about any line. *[NEEDS SOURCE: vetted per-locale directory — esp. Arabic-speaking/MENA maternal-mental-health and crisis lines — the single most safety-critical open item, shared with D11/E1.]*

---

## E. Feature set (prioritized)

E3 **inherits the full E1 feature set** (mother-centered postpartum home, week-indexed recovery guide, red-flag system, symptom log, visit tracker). It **adds** the postpartum mood layer:

**P0 — must ship (safety + core wedge)**
1. **EPDS over time** — repeatable EPDS with a longitudinal trend view (including antenatal D11 scores where they exist), band-based non-diagnostic results, **mandatory Q10 crisis routing**, gentle opt-in re-check cadence (see G).
2. **Crisis-resource surface** — localized; auto-surfaced on any self-harm signal or high band; persistently reachable; honest service descriptions (support line vs crisis line); no categorical confidentiality claims.
3. **Blues vs PPD vs psychosis education** — the core "what is this?" explainer, with the 2-week blues boundary, PPD's persistence, and psychosis as a rare, distinct **emergency** (see F1/F5).
4. **Intrusive-thoughts education** — "scary thoughts are common and are not intent"; when the pattern deserves clinical support; clearly distinguished from psychosis (F2).
5. **Screening → support handoff** — every result routes to coping content, "how to talk to your clinician" scripts, PSI/local resources, and warm help-options; never a dead end.
6. **Private mood log** — continuous with the D11/E1 mood thread; rage and anxiety loggable as first-class feelings; elevated-sensitivity privacy.

**P1 — high value**
7. **Self-compassion & coping toolkit** — grounding for anxiety spirals, "put the thought down" intrusive-thought coping education, rage pressure-valve strategies (step away, baby-safe pause), sleep-protection content; a "for 3 a.m." quick set.
8. **Partner & family education surface** — shareable *educational* pages (opt-in link, never her data): what PPD/PPA is, how to help, what rage and intrusive thoughts mean, and the **psychosis warning-sign card for the household**; culturally aware framing for family elders (AR-first).
9. **Treatment-awareness hub** — therapy types, medication-and-breastfeeding education (never a dose), PPD-specific treatments exist, waitlist-era "what can I do today" options (PSI groups, self-help).
10. **"Words to say" scripts** — how to tell a clinician / partner / mother what's happening, including disclosing intrusive thoughts.
11. **Gentle persistent follow-up** — low-pressure check-ins that don't lapse when she goes quiet (see G alerts); disengagement never triggers guilt copy.

**P2 — enrichment**
12. Exportable EPDS-trend + mood summary (PDF) for appointments — her data, her choice.
13. PSI online-support-group signposting by situation and language.
14. Bookmark/save for 3 a.m.; audio versions of coping content for hands-busy listening.

**Explicitly out of scope (compliance)**
- Diagnosis or labels ("you have PPD/PPA/OCD/psychosis"); any risk score presented as clinical judgment.
- Psychosis screening/monitoring of any kind — education + urgent routing only.
- Medication recommendations, doses, "safe to take/stop" verdicts.
- Treatment or prevention claims; coping content is general wellbeing education, not therapy.
- Partner sharing of screening/mood *data* by default (educational content only unless she explicitly, granularly shares).

---

## F. Content modules (medically-reviewed, referenced, grade 6–8, EN/AR/FR/ES, RTL)

1. **Baby blues, postpartum depression, or something else?** The 2-week boundary; PPD symptom picture (including numbness and bonding difficulty, not just sadness); "1 in 8 — you are far from alone"; anxiety as an equal citizen; framed as *reasons to talk to someone*, never self-diagnosis. (CDC/OWH/NIMH/NHS)
2. **Scary thoughts: what intrusive thoughts are (and aren't).** The flagship anti-shame module. Most new mothers have unwanted thoughts of harm coming to the baby; the thoughts are distressing *because* they're against her values; having them is not intent and not psychosis; when frequency/rituals/avoidance suggest OCD-level support would help; exact words to disclose to a clinician. Reviewed with extra care in all languages.
3. **Postpartum rage.** Naming it; it's a recognized symptom pattern of postpartum mood/anxiety difficulty, amplified by sleep deprivation and being under-supported; safe pressure-valves; when to bring it to a clinician.
4. **What a screening questionnaire is (and isn't).** EPDS explainer; why Femio shows a trend, not a verdict; why Q10 matters; what happens (and doesn't) when she answers honestly.
5. **Postpartum psychosis — rare, serious, treatable (for her AND her family).** Rare (~1–2 in 1,000); rapid onset; warning signs (hallucinations, beliefs that don't match reality, confusion, not needing sleep, dramatic behavior change); **same-day emergency care**; the person affected often can't see it — which is why this page is built to be shared with the household; recovery is expected with treatment. Tone: calm, factual, zero horror framing.
6. **Getting help — your options.** Talking therapies; how to raise it at any visit (not just the 6-week check); PSI HelpLine + groups; National Maternal Mental Health Hotline (US); self-referral routes where they exist; "waitlist survival" — what she can do while waiting; asking for help does not mean losing her baby (careful, honest framing — see K).
7. **Medication and breastfeeding — how the decision is made (educational).** Many treatments are compatible with breastfeeding; well-studied options exist; PPD-specific medications exist in some countries; the decision weighs untreated illness vs exposure and belongs to her and her clinician; never stop medication abruptly without clinician input. Never a dose, never a verdict.
8. **Self-compassion & recovery.** Separating her from the illness; "a good mother who feels terrible is still a good mother"; realistic recovery arcs (non-linear); protecting sleep as a clinical need, not a luxury.
9. **For partners & family.** What she's experiencing; what helps (listen, take the night shift, don't say "just sleep when the baby sleeps"); what to watch for (worsening mood, talk of self-harm, psychosis signs → emergency); partners can be affected too; culturally aware version for extended family (AR-first priority).
10. **When to seek help now.** Always-reachable crisis module: self-harm thoughts → crisis line/988-equivalent + emergency; psychosis signs → emergency now; honest descriptions of each resource.

*Every module: medically-reviewed, cited, dated, reviewer + review-date shown; crisis, intrusive-thoughts, and psychosis copy human-reviewed in EN/AR/FR/ES — machine-only translation prohibited.*

---

## G. Tools, logs & alerts (compliant framing; EPDS trend + crisis rules)

**EPDS over time (the E3 signature tool).**
- **Intro copy:** *"This is a short screening questionnaire — not a diagnosis. Repeating it over time helps you and your clinician see how you've been feeling. There are no right or wrong answers."*
- **Trend view:** timestamped scores plotted across the perinatal thread — antenatal (D11) scores carried in, postpartum scores added — shown as **neutral bands** (no red "danger" styling; calm color ramps), with band explanations ("higher scores make it more worth discussing with your clinician; thresholds vary by setting"). Exportable (PDF) by her choice.
- **Cadence:** opt-in gentle re-checks, defaulted to a rhythm consistent with clinical touchpoints (e.g., around 2–6 weeks postpartum, then roughly monthly through month 6, then opt-in) — suppressible, never nagging, and framed as "a check-in," not surveillance. AAP's 1/2/4/6-month pediatric-visit screening rhythm is the design anchor. *[NEEDS SOURCE: finalize cadence with medical reviewer.]*
- **Result routing:** every result — including low scores — hands off to support content ("glad things feel steadier — here's what to watch for") so no branch is a dead end.

**EPDS Q10 — self-harm safety rule (hard, non-negotiable, inherited from E1/D11).**
- **Any non-zero Q10 answer → immediate crisis-resource surface + warm urgent-care messaging, regardless of total score, even if the screen is abandoned after Q10.**
- Crisis copy (pattern):
  > **You don't have to face this alone — help is available right now.**
  > You answered that you've had thoughts of harming yourself. Saying that takes courage, and support exists.
  > • If you are in immediate danger, contact your local emergency number now.
  > • [Localized crisis line — auto-selected by locale; US: 988 Suicide & Crisis Lifeline — free, 24/7.]
  > • [US: National Maternal Mental Health Hotline, 1-833-852-6262 — free, 24/7, for pregnant and postpartum moms.]
  > • Tell your doctor, midwife, or health visitor today — they will listen without judgement.
  > [Show my saved contacts] [Local resources]
  > *Femio can't provide medical or crisis care, but these people can. You matter — to your baby, and on your own.*
- **No categorical confidentiality claims** anywhere in this surface: describe lines as "free," "24/7" (where true), and what they do — never promise "completely confidential/anonymous."

**High band (no Q10 signal).** Supportive module + "discuss with your clinician" + coping content + PSI/local help options; trend view shown so she can *see* the pattern; never alarmist, never diagnostic.

**Intrusive-thoughts check-in (careful design).** The mood log offers an optional "scary thoughts" tag. Logging it surfaces the F2 education ("these are common and are not intent") + "worth mentioning to your clinician, especially if they're frequent or you're arranging your day around them." **Distress about the thoughts + any self-harm signal → crisis path.** Thoughts logged are never labeled as risk, never trigger alarm styling, and are excluded from any sharing by default.

**Psychosis red-flag education (urgent — education only, never monitoring).**
- A static, always-reachable urgent card in the mood hub and in partner-facing content:
  > **Rare but urgent.** If you — or someone caring for you — notice: seeing or hearing things others don't, strong beliefs that don't match reality, severe confusion, not needing sleep for days, or behavior that's dramatically out of character, **treat it like any medical emergency and get same-day care now.** Postpartum psychosis is rare (about 1–2 in 1,000 births), it is no one's fault, and with urgent treatment recovery is expected.
- Femio performs **no psychosis screening, scoring, or symptom-pattern detection**. The card is educational, shareable to the household, and localized.

**Rage & anxiety logging.** First-class one-tap feelings in the mood log; rage logging routes to F3 education + pressure-valve coping, framed as signal-not-flaw; repeated high-anxiety logs gently offer the EPDS/coping tools.

**Gentle persistent follow-up (the E3 alert philosophy).** If she engaged with E3 and goes quiet, Femio sends at most sparse, warm, guilt-free check-ins ("No pressure — whenever you're ready, your space is here"), then respects silence (universal disengagement handler). **No** streak-shaming, **no** "you seem depressed" pushes, **no** predictive alerts. Crisis resources remain reachable throughout.

**Inherited E1 red-flag box** (CDC Hear Her physical warning signs) stays active; its "thoughts of harming yourself or your baby" line links into the crisis surface above.

---

## H. EMR fields (core vs persona-specific)

**Core lifespan fields (shared, carried in):** identity/locale/RTL, age/DOB, consent & sharing flags, reproductive history, chronic conditions, meds/allergies, cycle history, prior pregnancies/outcomes, saved clinician/emergency contacts. **All E1 postpartum fields remain active** (delivery event/type, postpartum_week, recovery logs, feeding status, visit tracking, cycle return) — E3 is additive.

**E3 persona-specific fields (all elevated-sensitivity, consent-gated; highest data class in Femio).**
- **Perinatal mood history thread:** carried-forward D11 fields where present (antenatal EPDS/GAD-7 scores + dates, MH-history flags, support plan) — one continuous series, never re-entered.
- **EPDS series (postpartum):** score + date + per-item Q10 store; trend metadata (cadence prefs, last-offered date).
- **Q10 self-harm flag** (boolean + timestamp) — crisis routing; highest sensitivity.
- **Mood/anxiety/rage/"scary thoughts" log series** (self-report tags; never risk-scored).
- **Feeding status × treatment-education flag** — surfaces breastfeeding-compatible treatment *education* (from E1's feeding field; adds nothing new, reads existing).
- **Support plan:** saved clinician, therapist/perinatal-MH service, trusted person, PSI/local line (user-entered).
- **Partner/family education-share state:** opt-in link issued (content-only), scope, revocable — **screening/mood data excluded from sharing by default**.
- **Coping-tool usage** (optional — powers "what's helped you before").
- **Follow-up preferences** (check-in cadence on/off; quiet-mode state).

*Screening results, Q10, mood, and MH-history fields: explicit granular consent for storage/sharing, excluded from partner sharing by default, GDPR/PDPL special-category handling, export/delete honored (femio-compliance-privacy).*

---

## I. Personalization rules (wizard → home config)

**Entry (offered, reversible — personalize, never restrict).** E3 layers over E1 when:
- **From E1:** EPDS ≥10 band, Q10 signal (crisis path first, then E3 offer), or sustained low-mood logs → *"Would you like Femio to bring supportive mental-wellbeing content forward? You can turn this off anytime."*
- **From D11 continuity:** delivery recorded while the D11 mood layer is active → E3 is offered **by default** with her antenatal history pre-threaded ("Your support space continues after birth — everything you tracked in pregnancy is still here").
- **Direct:** wizard Q5 "I recently gave birth" + mood concern selected, or she opts into a mood screen from E1.

Entry is always offered and confirmed, never forced; declining leaves E1 untouched and crisis resources reachable.

**Home configuration (postpartum-week-driven, mood layer added).**
- Keeps E1's mother-centered hero, recovery rail, and red-flag layer. **Adds** a calm "How are you feeling?" entry point, the EPDS-trend card, and the mood-support hub.
- **Weeks 0–2:** blues-normalization forward ("crying now is common — here's the 2-week guide"); psychosis-awareness card quietly present for the household; screening not pushed yet unless D11 history exists (then an early gentle check-in is offered).
- **Weeks 2–8:** the pivotal window — "still feeling this way past two weeks is worth a check-in"; first EPDS offer foregrounded; intrusive-thoughts and rage education surfaced; 6-week-visit script ("what to say").
- **Months 2–6:** trend view matures; treatment-awareness hub; partner/family share; monthly gentle re-checks.
- **Months 6–12:** "still not myself" framing; late-onset validity ("PPD can start anytime in the first year"); recovery/self-compassion arc; graduation watch (see J).
- **Tone:** extra-gentle everywhere; celebratory baby-milestone content softened/dial-downable; no toxic positivity ("enjoy every moment") anywhere in the E3 skin.
- **Feeding branch:** breastfeeding → medication-education framing emphasizes compatibility questions to ask; not breastfeeding → that framing quietly drops (never "you could take meds since you're not nursing").

**Hidden-but-reachable.** All E1 content, cycle/TTC surfaces, and the full library stay one–two taps away; crisis resources are persistently reachable and never gated behind a screen result.

---

## J. Adaptation triggers (state transitions)

E3 **inherits all universal events** from `09_MASTER_ADAPTATION_MODEL §6` — notably **Mood screen high / crisis flag** (EPDS Q10 non-zero → immediate crisis path regardless of total), **Red-flag symptom**, **Positive pregnancy test**, **Pregnancy loss**, **Disengagement**, and **Toggle mode off**. Only **E3-specific** transitions are listed here.

| Trigger | Condition | System action |
|---|---|---|
| **Enter E3 (from E1)** | EPDS ≥10 band, Q10 signal (crisis first), or sustained low-mood logs in E1 | **Offer** (confirm, reversible) the mood layer over E1; keep all E1 content; extra-gentle tone; elevated-sensitivity consent for mood data |
| **Enter E3 (from D11)** | Delivery recorded with D11 layer active | Offer E3 by default with antenatal mood + screening history pre-threaded; re-baseline to postpartum EPDS cadence; continuity copy ("support continues after birth") |
| **EPDS Q10 non-zero** | Any self-harm response (1/2/3), any time | **Immediate** localized crisis surface + warm urgent messaging, independent of total; show saved contacts; log flag (highest sensitivity); fires even mid-screen; never reassure-in-place-of-routing |
| **Crisis escalation (non-screen)** | Self-harm or harm-fear language in logs/notes; user taps "I need help now" | Same crisis surface; no analysis or labeling of the entry; silence-over-risk — when ambiguous, show resources without alarm framing |
| **Psychosis-education red flag (self/family report)** | User or shared-link viewer opens "urgent signs" flow and indicates signs match | Education-only urgent interstitial: **same-day emergency care now** + emergency number + partner guidance; no assessment, no storage of viewer input beyond the visit; never diagnosis |
| **Worsening trend** | EPDS band rising across ≥2 checks, or sustained deterioration in logs | Gently strengthened "worth talking to your clinician soon" prompt + help options; never alarmist, never auto-escalated to anyone |
| **Improvement → E1** | EPDS bands settling + user reports feeling steadier | **Offer** stepping the mood layer back ("keep the check-ins light?"); demote to background with periodic optional re-checks; all history retained; E3 re-offerable instantly if logs turn |
| **12-month horizon** | postpartum_week > ~52, mood stable | Inherit E1 graduation to general cycle/lifespan home; mood thread archived-but-reachable; optional continued mood log |
| **Next pregnancy (→ D-track, D11-aware)** | Positive pregnancy test (universal handler) | Route to D-track with **D11 offered proactively** — prior perinatal mood history is a known risk factor, so the antenatal mood layer is pre-suggested (never forced); entire EPDS/mood thread carries forward; tone = supportive, not fatalistic ("many women with a previous episode stay well — support from the start helps") |
| **Loss during E3 period / bereavement** | Universal loss handler context | Inherit E6 grief routing; **retain** mood support + crisis resources (grief + prior mood need continued care); no re-prompting |
| **Physical-complication blends** | E4 flags (BP/diabetes follow-up) or E7 (thyroid) active alongside E3 | Blending rules (§8): union of safety layers; most-acute physical need can take the hero; mood layer persists as a supportive strip; thyroid note — mood symptoms overlap with postpartum thyroiditis, surfaced as "worth mentioning both to your clinician" education (never adjudicated) |
| **Toggle mood layer off** | User opts out | Revert to E1 emphasis; retain data per privacy settings; crisis resources remain reachable; re-entry always open |

*All routing is content/UX routing, not clinical triage. Femio surfaces resources and prompts; clinicians decide.*

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, treatment, or prevention claims; no medical-device-triggering language; screeners are screens; coping content is general wellbeing education, not therapy (femio-compliance-privacy).
- **EPDS framing (mandatory):** results as **bands/ranges, never labels**; trend view is "something to discuss with your clinician," never a clinical judgment; thresholds noted to vary by language/setting.
- **Q10 rule (mandatory, hard):** any non-zero Q10 → immediate crisis surface, independent of total, even on abandoned screens. Never soft-pedaled, never punitive.
- **Psychosis = education + urgent routing ONLY.** No screening, scoring, monitoring, or pattern detection for psychosis anywhere in Femio. The urgent card must be calm, factual, shareable, and localized. Any drift toward "detecting" psychosis is a compliance stop-ship.
- **Intrusive-thoughts content (highest editorial sensitivity):** must simultaneously (a) normalize without minimizing, (b) never imply thoughts = intent or danger, (c) clearly distinguish from psychosis, (d) name when clinical support is warranted, and (e) never promise what a clinician will or won't do on disclosure. On the "will they take my baby" fear: acknowledge the fear honestly, state that intrusive thoughts without intent are recognized by perinatal clinicians as common symptoms, and **never make categorical legal/CPS promises** — jurisdictions differ. *[NEEDS SOURCE: per-locale review of mandatory-reporting realities before finalizing this copy.]*
- **No categorical confidentiality claims about helplines** (global Femio rule, doubly enforced here): describe lines factually ("free," "24/7" where true, what they offer); PSI HelpLine described as support (not crisis) with crises routed to 988/local emergency.
- **Crisis resources — localized, never US-only:** vetted per-locale directory incl. Arabic-speaking/MENA maternal-MH and crisis lines. **[NEEDS SOURCE — the single most safety-critical open item, shared with E1/D11; block content freeze on it.]**
- **Medication content:** educational only — never a dose, never "safe/unsafe" verdicts, never start/stop advice; breastfeeding-compatibility framed as a clinician conversation grounded in LactMed-class references; verify regional availability before naming PPD-specific drugs per locale.
- **Sensitive data (highest class):** EPDS series, Q10, mood/rage/scary-thoughts tags, MH history — explicit granular consent, excluded from partner sharing by default (partner share = educational content only unless she explicitly shares data), no ad/data-broker leakage, GDPR/PDPL special-category handling, export/delete honored.
- **Partner/family surface:** content-only by default; revocable; must never become surveillance of her; psychosis card is shareable *education*, not a reporting channel.
- **Tone (clinical-safety requirement):** warm, shame-free, separates mother from illness; no doom, no toxic positivity, no "your baby needs you to get better" guilt levers; silence-over-risk on ambiguity.
- **Content integrity:** every clinical statement medically-reviewed, cited, dated, reviewer + review-date visible; crisis/intrusive-thoughts/psychosis copy **human-reviewed in EN/AR/FR/ES** (machine-only prohibited).
- **Distinct-from siblings:** D11 = antenatal (pregnant), E3 = postpartum (delivered) — resolver keys on delivery status with seamless D11→E3 carry-forward; E1 = general recovery (E3 is its mood layer, not a replacement).
- **Instrument governance:** EPDS licensing/attribution terms confirmed before in-product use **[NEEDS SOURCE — shared with D11]**.
- **Open items before content freeze:** per-locale crisis directory; EPDS licensing + locale thresholds; screening-cadence sign-off; MedlinePlus/NHS psychosis page URLs; AAP policy permalink; UBC postpartum-anger primary citation; per-locale mandatory-reporting copy review; PPD-drug availability per market.

---

## Sources

**Tier-1 (NIMH / CDC / OWH / NHS / MedlinePlus)**
- [NIMH — Perinatal Depression](https://www.nimh.nih.gov/health/publications/perinatal-depression)
- [CDC — Symptoms of Depression Among Women (Reproductive Health)](https://www.cdc.gov/reproductive-health/depression/index.html)
- [CDC Hear Her — Urgent Maternal Warning Signs](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [OWH — Postpartum depression](https://womenshealth.gov/mental-health/mental-health-conditions/postpartum-depression)
- [OWH — Talking Postpartum Depression campaign](https://womenshealth.gov/TalkingPPD)
- [NHS — Postnatal depression: overview](https://www.nhs.uk/mental-health/conditions/post-natal-depression/overview/)
- [NHS — Postnatal depression: treatment](https://www.nhs.uk/mental-health/conditions/post-natal-depression/treatment/)
- [MedlinePlus — Postpartum depression](https://medlineplus.gov/postpartumdepression.html) *[NEEDS SOURCE: confirm exact page/wording]*

**Tier-2 (ACOG / PSI / AAP / NICE / professional)**
- [ACOG — Screening and Diagnosis of Mental Health Conditions During Pregnancy and Postpartum (2023 CPG)](https://www.acog.org/clinical/clinical-guidance/clinical-practice-guideline/articles/2023/06/screening-and-diagnosis-of-mental-health-conditions-during-pregnancy-and-postpartum)
- [Postpartum Support International — Get Help (HelpLine 1-800-944-4773; not a crisis line)](https://postpartum.net/get-help/)
- [PSI — Help for Perinatal Individuals](https://postpartum.net/get-help/help-for-moms/)
- [AAP — EPDS scoring PDF](https://downloads.aap.org/AAP/PDF/Postnatal%20Depression%20Scale.pdf)
- [AAP — Incorporating recognition and management of perinatal depression into pediatric practice](https://publications.aap.org/pediatrics/article/143/1/e20183259/37241) *[NEEDS SOURCE: confirm permalink]*
- [NICE CG192 — Antenatal and postnatal mental health](https://www.nice.org.uk/guidance/cg192/chapter/Recommendations)
- [APA — What is Peripartum (formerly Postpartum) Depression?](https://www.psychiatry.org/patients-families/peripartum-depression/what-is-peripartum-depression)
- [AAFP — Cognitive Behavior Therapy for Postpartum Depression](https://www.aafp.org/pubs/afp/issues/2019/0815/p244.html)

**Psychosis, intrusive thoughts, rage (clinical/research)**
- [StatPearls — Postpartum Psychosis (NCBI Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK544304/)
- [Phenomenology, Epidemiology and Aetiology of Postpartum Psychosis — review (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC7824357/)
- [Action on Postpartum Psychosis — a guide for partners (Maternal Mental Health Alliance PDF)](https://maternalmentalhealthalliance.org/media/filer_public/2e/09/2e095442-4ebf-4e5b-b9c9-65ebb577f0f0/postpartum-psychosis-a-guide-for-partners.pdf)
- [Maternal unwanted/intrusive thoughts of infant-related harm — study protocol (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6429780/)
- [Correlates and predictors of new mothers' responses to postpartum harm thoughts (Cambridge)](https://www.cambridge.org/core/journals/behavioural-and-cognitive-psychotherapy/article/correlates-and-predictors-of-new-mothers-responses-to-postpartum-thoughts-of-accidental-and-intentional-harm-and-obsessive-compulsive-symptoms/09A0A67F64C58ABFE2247EFFB54192C8)
- [MGH Center for Women's Mental Health — Postpartum OCD and intrusive thoughts](https://womensmentalhealth.org/posts/understanding-postpartum-ocd-and-intrusive-thoughts/)
- [MGH — Using the EPDS to measure severity](https://womensmentalhealth.org/posts/using-epds-measure-postpartum-depression-severity/)
- [Policy Center for Maternal Mental Health — Maternal OCD](https://policycentermmh.org/maternal-ocd/)
- [Cleveland Clinic — Postpartum rage](https://my.clevelandclinic.org/health/diseases/24768-postpartum-rage)
- [Black Dog Institute — EPDS scoring incl. Q10 handling (PDF)](https://www.blackdoginstitute.org.au/wp-content/uploads/2020/04/edinburgh-postnatal-depression-scale.pdf)

**Treatment awareness (educational grounding)**
- [LactMed — Sertraline (NCBI Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK501191/)
- [Zuranolone and Brexanolone for PPD — Obstetrics & Gynecology review](https://journals.lww.com/greenjournal/fulltext/2026/01000/zuranolone_and_brexanolone_for_the_treatment_of.22.aspx)
- [Current developments in PPD treatment: zuranolone (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11535317/)

**Partner/family & landscape**
- [Tommy's — Looking after your partner's mental health after the birth](https://www.tommys.org/pregnancy-information/dads-and-partners/your-partners-mental-health-after-the-birth)
- [Mind — Postnatal depression: partners](https://www.mind.org.uk/information-support/types-of-mental-health-problems/postnatal-depression-and-perinatal-mental-health/partners/)
- [Smartphone applications to support perinatal mental health (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12933385/)
- [Best Maternal Mental Health Apps — Phoenix Health](https://joinphoenixhealth.com/resourcecenter/best-maternal-mental-health-apps/)

*[NEEDS SOURCE] consolidated:* per-locale vetted crisis/maternal-MH directory (esp. Arabic/MENA); EPDS licensing + locale thresholds; NHS postpartum-psychosis page URL; MedlinePlus PPD page confirmation; AAP policy permalink; UBC postpartum-anger primary study; per-locale mandatory-reporting copy review; PPD-specific drug availability per market; screening-cadence medical sign-off.
