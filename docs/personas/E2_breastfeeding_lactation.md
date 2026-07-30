# Persona E2 — Breastfeeding / Lactation (Mother-Centered)

> Femio persona spec. Scope: **wellness / education / tracking only.** Femio never diagnoses, treats, or prevents disease. All screeners are framed as *screening — discuss results with your clinician*; medication-and-breastfeeding content is educational and clinician-routed (LactMed is a reference, never a green light from Femio). Mastitis-spectrum content carries prominent *seek-care* framing. This document is a product/UX + clinical-grounding brief, not medical advice.

Inherits: the seven invariants, state object, constant core, universal events, Z1 fallback, and blending rules from `09_MASTER_ADAPTATION_MODEL.md`. E2 is typically a **layer co-active with E1** (postpartum recovery) rather than a replacement — feeding is one axis of the same postpartum record.

---

## A. Persona snapshot

**Who she is.** A postpartum mother establishing or sustaining lactation — exclusively breastfeeding, combination feeding, exclusively pumping, relactating, or beginning to wean. She might be day 3 with cracked nipples and a screaming cluster-feeder, month 4 pumping in a stairwell at work, or month 14 deciding how to stop. Her feeding method may change several times; E2 follows *her*, not the method.

**Core emotional state.** High-stakes and identity-laden. Breastfeeding is framed everywhere as "natural," so every difficulty reads as personal failure. The dominant anxiety is **"is my baby getting enough?"** — invisible intake, no gauge on the breast. Layered on top: physical pain (latch, engorgement, mastitis fear), logistical exhaustion (pumping schedules, triple feeding), and social pressure from every direction — family pushing formula "to let you rest," culture or clinicians pushing exclusivity, guilt whichever way she moves. Triple feeding (nurse + pump + bottle every 2–3 hours) is repeatedly described in communities as mental-health-destroying and sustainable only briefly.

**Jobs to be done.**
- "Tell me if this pain / lump / fever is normal, fixable at home, or a reason to seek care today."
- "Help me trust — or verify — that my baby is getting enough, without turning me into a data clerk."
- "Make pumping logistics survivable: sessions, storage rules, back-to-work planning."
- "Tell me what I can take for pain / cold / mood while breastfeeding — or at least who to ask and where the evidence lives."
- "Support whatever feeding path I'm on (or moving to) without judgment — including stopping."
- "Explain what breastfeeding does to my cycle and fertility, because nobody mentioned I can ovulate before my first period."

**Context of use.** One hand, 3 a.m., baby latched on the other side. Sessions of 30–90 seconds. Web-first, Arabic-first/RTL matters acutely: MENA has near-universal breastfeeding initiation but ~20% exclusive-breastfeeding rates and heavy family influence on feeding decisions — referenced Arabic lactation content is scarce.

**Femio's wedge for E2.** Every feeding app on the market logs the *baby's* intake. Nobody tracks the *mother's* lactation health — her breast symptoms, her pain, her supply worry, her mood under feeding pressure, her cycle's return. Femio keeps the mother the subject: the feeding log is deliberately minimal (context for HER body), while breast health, emotional load, meds questions, and fertility-return get first-class treatment inside her lifelong record.

---

## B. Needs & questions (voice-of-user)

Synthesized from breastfeeding/pumping communities (r/breastfeeding, r/ExclusivelyPumping and similar), app reviews, and qualitative literature on breastfeeding and exclusive expression. Quotes are paraphrased/representative of recurring themes.

**Establishing (weeks 0–6).**
- "It's supposed to be natural — why does it hurt this much?" Latch pain, cracked/bleeding nipples, lipstick-shaped or blanched nipples after feeds.
- "Cluster feeding all evening — is he starving or is this normal?"
- "My milk hasn't 'come in' / my breasts stopped feeling full — did my supply crash?" (Softening breasts after regulation is the classic false alarm.)
- "We're triple feeding and I'm losing my mind. How long can anyone do this?"
- "Nipple shields, tongue tie, football hold, breast compressions — which of this actually matters?"

**Sustaining (months 2–12).**
- "Hard, hot, painful spot on one breast and I feel like I have the flu — mastitis? Do I need antibiotics *today*?"
- "Recurring blocked ducts — I dread every morning." (Users still swap aggressive-massage folklore that ABM 2022 now advises against.)
- "How do I keep supply when I go back to work? How many pumping sessions? What are the milk storage rules again?"
- "Can I take ibuprofen / antihistamines / antidepressants / this antibiotic while breastfeeding?" — the single most common meds anxiety; answers online are contradictory.
- "My mother-in-law keeps saying my milk is 'weak' and pushing formula." / conversely: "Everyone judges me for supplementing."
- "I got my period back at 5 months — does that mean my milk is ruined / I can get pregnant now?"

**Winding down (any time).**
- "How do I wean gradually and look after both my breasts and my wellbeing?" (The product validates mixed emotions without attributing them to an unverified hormonal mechanism.)
- "I stopped and I feel weirdly grief-stricken / relieved / both. Is that normal?"
- "Exclusively pumping: when is my freezer stash big enough to stop?"

**What "good" looks like to her.** Fast is-this-normal answers per breast symptom; a mastitis-spectrum guide that says clearly when home measures stop and care-seeking starts; a feeding log that takes two taps, not a spreadsheet; meds questions routed to real evidence (LactMed) plus "ask your clinician/pharmacist"; zero guilt in copy about combination feeding, formula, or stopping; and a heads-up about fertility returning before her period.

---

## C. Competitor teardown (feature by feature — nobody supports the MOTHER's lactation health)

| Product | Feeding logging | Mother's breast/lactation health | Meds & breastfeeding | Emotional load / mood | Cycle & fertility return | Gap for E2 |
|---|---|---|---|---|---|---|
| **Medela Family (MyMedela)** | Strong: nursing + pumping sessions, milk storage, smart-pump sync | Thin — expert articles exist, but no structured breast-symptom tracking, no mastitis-spectrum guidance surface | No | No | No | Hardware-funnel app: the pump is the customer; the mother's breast health and mood are not tracked; no cycle continuity |
| **Pump Log** | Best-in-class for exclusive pumpers; freezer-stash countdown to quitting | None | No | No | No | A niche logistics utility; brilliant single feature, no health layer, expires when pumping ends |
| **Huckleberry / Baby Tracker / Glow Baby** | Baby-centric feed/sleep/diaper logs | **None** | No | No | No | The archetype: the mother is the data-entry clerk for the infant's intake; her lactating body doesn't exist in the product |
| **Flo / Ovia (postpartum modes)** | Light feeding context | Some articles; no per-breast symptom logs or mastitis routing | Editorial only | Some mood content | Yes (their core) | Cycle apps with a postpartum veneer; lactation is content, not a tracked health domain; Flo privacy history, Ovia employer-data optics (see E1 §C) |
| **LactApp** | Yes | Closest peer: lactation Q&A engine, IBCLC-built, mother-focused | Some | Some | Limited | Strongest lactation depth on market, but Spain-centric, not Arabic/RTL, not one-lifespan-account; Q&A-bot model rather than tracked continuity |
| **WIC / La Leche League / KellyMom (content sites)** | n/a | Authoritative content, no product | Reference only | Peer support (LLL) | Content only | Warm or referenced but static; no logging, personalization, or continuity |

**Teardown takeaways for Femio.**
1. **The whitespace is exactly the brief:** structured tracking of the *mother's* lactation health (per-breast symptoms, pain, mastitis-spectrum education with seek-care routing, weaning support, mood-under-feeding-pressure) — no mainstream product does it.
2. **Keep the feeding log thin on purpose.** Baby-intake logging is a commodity Medela/Huckleberry do better; Femio logs feeding as *context for her body* (frequency band, method mix, pumping sessions), not diapers and ounces.
3. **Continuity kills the expiry problem.** Pump Log ends at the freezer stash; Medela ends with the pump; Femio flows E2 → weaning → cycle return → B1/C1 in one record.
4. **Meds-and-breastfeeding is an unserved trust surface.** Nobody routes users to LactMed-grade evidence plus a clinician conversation; forums fill the vacuum. Educational, clinician-routed meds content is a differentiator that must stay rigorously non-prescriptive.

---

## D. Clinical grounding (cited)

*All items are education/tracking context. Femio presents these as general information and seek-care prompts, never diagnosis or treatment instructions.*

**Recommendation frame.** WHO and the AAP (2022 policy) recommend exclusive breastfeeding for ~6 months, complementary foods thereafter, and continued breastfeeding "as long as mutually desired" — AAP now aligned with WHO's "2 years or beyond." Femio presents this as background, always paired with support-any-path framing. ([AAP Policy Statement 2022](https://publications.aap.org/pediatrics/article/150/1/e2022057988/188347/Policy-Statement-Breastfeeding-and-the-Use-of); [NICHD breastfeeding recommendations](https://www.nichd.nih.gov/health/topics/breastfeeding/conditioninfo/recommendations))

**Latch & positioning.** Signs of a good latch: baby's mouth wide, lips flanged out, chin touching breast, more areola visible above than below, audible swallowing; feeding should not be persistently painful — pinched, cracked, blanched or "lipstick" nipples suggest a shallow latch and warrant lactation support. ([OWH — Getting a good latch](https://womenshealth.gov/breastfeeding/learning-breastfeed/getting-good-latch); [USDA WIC — Steps and signs of a good latch](https://wicbreastfeeding.fns.usda.gov/steps-and-signs-good-latch))

**"Is baby getting enough?" (supply reassurance).** Newborns feed ~8–12 times/24h; adequate wet/dirty diapers, contentment after feeds, and weight checks with the pediatrician are the reliable signals — breast "fullness" is not: softer breasts after supply regulates are normal and the most common false alarm. Persistent worry → lactation consultant / baby's clinician. ([CDC — How much and how often to breastfeed](https://www.cdc.gov/infant-toddler-nutrition/breastfeeding/how-much-and-how-often.html); [OWH — Making breastmilk](https://womenshealth.gov/breastfeeding/learning-breastfeed/making-breastmilk))

**Common challenges (engorgement, nipple pain, oversupply, low supply).** OWH and ACOG catalogue the frequent problems and first-line comfort measures, all framed as "get help from a lactation consultant / clinician early — delaying feeds because of pain worsens both pain and supply." ([OWH — Common breastfeeding challenges](https://womenshealth.gov/breastfeeding/breastfeeding-challenges/common-breastfeeding-challenges); [ACOG — Breastfeeding Challenges, Committee Opinion 820](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2021/02/breastfeeding-challenges))

**Mastitis spectrum (ABM Clinical Protocol #36, 2022).** Reframes engorgement → ductal narrowing ("blocked duct") → inflammatory mastitis → bacterial mastitis → phlegmon/abscess as one inflammation spectrum. Key education points Femio must reflect: continue feeding on demand; **avoid aggressive massage, excessive pumping "to empty," and deep heat** (old folklore that can worsen inflammation); use cold, rest, and normal feeding patterns; seek care when systemic symptoms persist or worsen. ([ABM Protocol #36, PubMed](https://pubmed.ncbi.nlm.nih.gov/35576513/)) NHS: see a GP if a red/hot/painful area plus flu-like symptoms don't improve within 12–24 hours of continued feeding + home measures, or if worsening; feeling seriously unwell/dizzy/confused with mastitis symptoms → urgent care (possible sepsis). ([NHS — Mastitis](https://www.nhs.uk/conditions/mastitis/); [NHS Best Start — Mastitis while breastfeeding](https://www.nhs.uk/best-start-in-life/baby/feeding-your-baby/breastfeeding/breastfeeding-challenges/mastitis/)) *Note: a 2023 commentary debates parts of ABM #36 ([Int Breastfeed J commentary](https://pmc.ncbi.nlm.nih.gov/articles/PMC10481477/)) — content must stick to consensus basics and route management to clinicians.*

**Pumping & milk storage.** CDC’s current table states that freshly expressed milk can be stored at room temperature (77°F/25°C or colder) for up to **4 hours**, refrigerated for up to **4 days**, and frozen for about **6 months for best quality** or up to **12 months as acceptable**. The card also includes CDC handling qualifications; it is not reduced to durations alone. ([CDC — Breast Milk Storage and Preparation, 25 March 2026](https://www.cdc.gov/breastfeeding/breast-milk-preparation-and-storage/handling-breastmilk.html); [CDC — Pumping breast milk](https://www.cdc.gov/infant-toddler-nutrition/breastfeeding/pumping-breast-milk.html)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Weaning.** CDC recommends weaning over several weeks or more and starting by replacing one breast-milk feeding a day, then replacing additional feeds over time. Femio presents this as general pacing education, not a medical guarantee against engorgement or mastitis. A neutral wellbeing check-in remains available during any feeding transition, but global copy makes no claim that weaning hormones cause a mood change. ([CDC — Weaning From Breastfeeding, 16 April 2026](https://www.cdc.gov/infant-toddler-nutrition/breastfeeding/weaning.html)) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Lactational amenorrhea & return of fertility (education, not contraception advice).** LAM is ≥98% effective only while **all three** criteria hold: amenorrhea + fully/nearly-fully breastfeeding (day feeds ≤4h apart, night ≤6h) + <6 months postpartum. Ovulation can precede the first postpartum period, so fertility may return silently; any criterion breaking = LAM no longer applies → "discuss contraception options with your clinician." ([CDC US-MEC — LAM](https://www.cdc.gov/contraception/hcp/usmec/lactational-amenorrhea-method.html); [LAM review, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6823189/))

**Medications & breastfeeding.** LactMed (NIH/NLM) is the peer-reviewed, fully referenced database of drug levels in milk and infant effects, including supplements/herbals; most medications have compatible options but the decision belongs to her clinician/pharmacist with LactMed-grade evidence in hand. Femio links and explains — never clears or contraindicates a drug. ([LactMed — NCBI Bookshelf](https://www.ncbi.nlm.nih.gov/books/NBK501922/); [LactMed fact sheet](https://www.ncbi.nlm.nih.gov/books/NBK547437/))

**Cultural context (MENA).** Near-universal initiation but pooled exclusive-breastfeeding prevalence ~20% across Middle Eastern countries; grandmothers/mothers-in-law are dominant feeding influencers (early formula/water/herbal introduction), and family inclusion in education is a documented lever. Shapes Femio's Arabic content and "involve your support circle" framing. ([UAE systematic review, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12085000/); [Immigrant Muslim Arab women study, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10515608/); [Jazan, Saudi Arabia barriers study](https://doi.org/10.4103/jfmpc.jfmpc_73_22))

---

## E. Feature set (prioritized)

**P0 — must ship (safety + core wedge).**
1. **Lactation home (mother-centered)** — configured by feeding method (nursing / combo / exclusive pumping / weaning) + postpartum week; her breasts, body, and mood are the subject.
2. **Breast symptom log (per breast)** — pain, redness/hot area, lump/hard area, nipple damage, fever/flu-feeling — with inline mastitis-spectrum education and the **red-flag box (§G)** after concerning entries.
3. **"Is baby getting enough?" reassurance module** — CDC/OWH-based signals checklist (diapers, feeding frequency, weight checks with pediatrician), explicit "softer breasts ≠ lost supply" myth-buster, always routed to lactation consultant / clinician for persistent worry. Educational framing only — never an adequacy verdict.
4. **Simple feeding log** — two taps: method (breast L/R / pump / bottle-expressed / formula), time, optional duration/volume. Deliberately minimal; exists to power LAM education, supply-pattern context, and weaning pacing — not a baby tracker.
5. **Meds-and-breastfeeding education surface** — plain-language explainer of how compatibility is assessed, deep links to LactMed records, and a mandatory "confirm with your clinician or pharmacist" close on every card. No compatibility verdicts from Femio.

**P1 — high value.**
6. **Pumping planner** — session schedule builder (incl. back-to-work mode), storage-rules quick card, hands-free tips; freezer-stash awareness (Pump Log's loved feature, generalized).
7. **Mastitis-spectrum guide** — ABM-2022-aligned home-measure education (feed normally, cold, rest; *not* aggressive massage/heat/extra pumping) with clear escalation timing (12–24h no improvement → clinician).
8. **Weaning planner** — gradual drop-one-session pacing education, engorgement/mastitis-risk awareness, mood check-in during weaning, "stopping is a valid choice" framing.
9. **Return-of-cycle & LAM education** — three-criteria explainer with live criterion status from her own logs (amenorrhea? feeding intervals? <6 months?) framed as *awareness, not contraception*; "fertility can return before your first period."
10. **Emotional-load support** — feeding-pressure check-ins, triple-feeding sustainability education ("short-term tool — discuss an exit plan with your provider"), guilt-free combination/formula content, family-pressure scripts (culturally localized).

**P2 — enrichment.**
11. Nipple-care and latch troubleshooting library with visual guides. 12. Lactation-consultant prep sheet (symptoms + feeding pattern export for her IBCLC/clinician). 13. Support-circle share card (privacy-gated) — referenced content *for grandmothers/partners* in Arabic/EN. 14. Relactation and induced-lactation educational content. 15. 2 a.m. quick-answer bookmarks.

**Explicitly out of scope for E2.** Full baby-tracking (diapers, sleep, growth curves), any milk-adequacy or intake verdicts, medication compatibility rulings or dosing, mastitis diagnosis/antibiotic advice, contraception advice (education about LAM criteria only), galactagogue recommendations.

---

## F. Content modules (medically-reviewed, referenced, grade 6–8, 4 languages)

1. **Getting started: latch & positioning** — good-latch signs, positions, when pain means get help; nipple shield and tongue-tie *awareness* (evaluation belongs to clinicians/IBCLCs).
2. **Is my baby getting enough?** — reliable signs vs. false alarms; cluster feeding; growth-spurt frequency jumps; supply regulation ("soft breasts are normal"); when to see a lactation consultant.
3. **Your breasts: engorgement to mastitis** — the mastitis spectrum in plain language; what helps at home (ABM 2022: keep feeding, cold, rest) and what old advice to skip (aggressive massage, heat, over-pumping); embedded red-flag box; abscess awareness.
4. **Pumping & storing milk** — hygiene, session patterns, storage durations, back-to-work survival, exclusive-pumping validation ("it counts, and it's hard").
5. **Medications, caffeine & breastfeeding** — how compatibility evidence works, what LactMed is, common-question walkthroughs (pain relief, cold meds, antidepressants, antibiotics) each ending in clinician routing; never a verdict.
6. **Feeding your baby, feeding yourself** — maternal nutrition, hydration, thirst; no strict "breastfeeding diet" myths.
7. **The emotional side** — feeding pressure, guilt, triple feeding, identity; combination and formula feeding without shame; when feeding struggle + low mood means a mood check-in (→ E3).
8. **Family, culture & your feeding choices** — navigating grandmother/mother-in-law advice, "weak milk" myths, involving your support circle; Arabic-first cultural adaptation with religious-cultural sensitivity (e.g., breastfeeding norms in Islam) reviewed by local advisors.
9. **Your cycle & fertility while breastfeeding** — LAM's three criteria; ovulation-before-first-period; what changing feeding patterns do to cycle return; contraception = clinician conversation.
10. **Weaning, your way** — CDC-aligned gradual pacing, night-weaning questions, breast-comfort education, and a neutral wellbeing check-in; no claimed hormonal cause for mood.

*Every module: medically-reviewed, cited, dated, reviewer + review-date shown; localized EN/AR/FR/ES with Arabic-first/RTL layout.*

---

## G. Tools, logs & alerts (compliant framing)

**Logs (for the mother).**
- **Per-breast symptom log:** pain (0–10 + site), redness/heat, lump/hardness, nipple condition (intact / cracked / bleeding / blanched), fever/chills/flu-feeling, leaking.
- **Feeding log (minimal):** method + side + time; optional duration/pumped volume. Powers LAM-criteria display, weaning pace, and pattern context — never an intake-adequacy score.
- **Pumping sessions** (count/times; optional volume trend shown as *her* data, no "enough milk" judgments).
- **Mood + feeding-pressure check-in** (links to EPDS surface shared with E1/E3).
- All logs are **educational self-tracking**; no risk scores presented as medical judgments.

**Mastitis red-flag box (required pattern — appears in §F3 content and after any log combining breast symptoms with systemic symptoms):**

> **Breast symptom — when to seek care.**
> A tender, hard, or red area with mild soreness often improves with continued normal feeding, cold packs, and rest. **Contact your doctor or midwife today if:** the red, hot, painful area is not improving after 12–24 hours; you have fever ≥38°C / 100.4°F, chills, or flu-like aching; there are red streaks, pus, or blood in milk; or a hard lump isn't softening.
> **Seek urgent care now if:** you feel seriously unwell, dizzy, or confused, your heart is racing, or symptoms are getting rapidly worse — mastitis can rarely progress to a serious infection that needs immediate treatment.
> Keep feeding or expressing as usual unless a clinician tells you otherwise — stopping suddenly can make it worse. Femio can't tell you what this is; a clinician can. *(Sources: NHS Mastitis; ABM Protocol #36.)*

**Supply-worry pattern.** Repeated "not enough milk" concern logs → reassurance module + "a lactation consultant or your baby's clinician can assess this properly — here's what to bring" prep sheet. Never "your supply is fine/low."

**Meds surface.** Every meds card: educational summary → LactMed link → *"Show this to your clinician or pharmacist — they'll advise for your situation."* No traffic-light compatibility icons (implies a verdict).

**LAM awareness strip.** Displays the three criteria with her logged status and one line: *"If any of these no longer applies, this method no longer offers protection — talk with your clinician about contraception."* Educational awareness only; Femio never advises relying on LAM.

**Non-negotiables.** Femio never says "you have mastitis," never clears a medication, never scores milk supply, never advises on contraception. Alerts describe symptoms + seek-care actions; crisis/emergency numbers are locale-specific.

---

## H. EMR fields (core vs persona-specific)

**Core lifespan fields:** as defined in `09_MASTER_ADAPTATION_MODEL.md` §3 (identity/locale/RTL, consent flags, cycle history, meds/supplements, conditions, screener history).

**E2 persona-specific fields (layered over the E1 postpartum layer).**
- **Feeding status & intent:** current method (exclusive BF / combo / exclusive pumping / formula / weaning), start date, intent/goal (private, judgment-free, editable).
- **Feeding log entries:** method, side, timestamp, optional duration/volume.
- **Breast symptom log:** per-breast structured entries + timestamps (drives red-flag logic and clinician prep sheet).
- **Lactation events:** mastitis-symptom episodes (self-reported, non-diagnostic), clinician visits for breast symptoms, IBCLC consultations (optional).
- **Pumping profile:** sessions/day, back-to-work date (optional), storage preference notes.
- **Weaning state:** weaning_started date, pace, completed date → fires E2-exit handling.
- **LAM criteria snapshot (derived):** amenorrhea? / feeding-interval criterion? / <6 months? — display-only, educational.
- **Cycle return:** first postpartum period date (shared field with E1; nullable).
- **Meds questions asked** (content history only; sensitive handling).
- **Feeding-pressure / mood check-ins** (shared EPDS surface with E1/E3; consent-gated, sensitive).

*Feeding intent, mood, and meds-related fields = elevated privacy handling. Dropping the E2 layer (weaning complete) archives it reachable, per the constant-EMR rule.*

---

## I. Personalization rules (wizard → home config)

**Onboarding capture (or hand-off from E1 wizard Q5 "feeding" answer):** feeding method + intent, baby age / postpartum week, current struggles (pain / supply worry / pumping logistics / pressure / thinking about stopping), back-to-work date, language/RTL.

**Home configuration logic.**
- **Method branch:**
  - *Exclusive/partial nursing* → latch + "is baby getting enough" + breast-symptom log pinned.
  - *Exclusive pumping* → pumping planner hero, session log pinned, validation-forward tone ("pumping counts"), stash awareness.
  - *Combination* → zero-guilt framing default; both surfaces available, neither moralized.
  - *Weaning* → weaning planner hero, engorgement/mastitis watch elevated, mood check-in cadence up, cycle-return education foregrounded.
- **Week/phase branch:** weeks 0–2 latch + cluster-feeding normalization + engorgement education; weeks 2–8 supply-regulation myth-busting + mastitis awareness; months 2–6 pumping/back-to-work + LAM strip active; months 6+ solids-alongside-milk context, LAM strip retires (<6mo criterion broken) with a one-time "fertility awareness" nudge; 12+ months extended-feeding normalization (AAP/WHO framing) — no "why are you still nursing" undertones ever.
- **Struggle branch:** pain → latch troubleshooting + IBCLC-finder education; supply worry → reassurance module first, not more logging; pressure/guilt → emotional-load module + support-circle share card (AR-localized family content).
- **Concurrent E1:** E2 is a co-active layer — postpartum-recovery hero retains priority in weeks 0–6 (most-acute-wins rule, §8 of master model); E2 takes the hero if she entered via a feeding-specific concern.
- **Hidden-but-reachable:** formula/stopping content is never buried for exclusive nursers, and vice versa — method changes are one tap, no lectures.

---

## J. Adaptation triggers

Universal events (positive test, loss, mood-crisis, red-flag, disengagement, toggle-off) are **inherited** from `09_MASTER_ADAPTATION_MODEL.md` §6. E2-specific notes on two universals: **positive pregnancy test while breastfeeding** → D-track offer carries a "nursing while pregnant" education card (clinician conversation, not instruction); **infant loss / cessation of feeding due to loss** → immediate Gentle Mode + *lactation-suppression-after-loss is a clinician conversation* resource, all feeding surfaces suppressed instantly.

| Trigger | Condition | System action |
|---|---|---|
| **Enter E2** | From E1 wizard/hand-off: feeding intent = breastfeeding/pumping/combo; or self-declared feeding concern | Activate E2 layer over E1; set method branch; pin breast-symptom + feeding logs |
| **Mastitis-sign pattern** | Breast symptom log matches red-flag set (red/hot/hard area + fever/flu-feeling, or no improvement flagged at 12–24h) | Prominent seek-care interstitial (§G box) + clinician prep sheet; no diagnosis; log episode |
| **Repeated supply-worry logs** | ≥3 "not enough milk" concern entries in 14 days | Reassurance module + lactation-consultant routing; suppress any surface that could read as adequacy scoring |
| **Feeding struggle + low mood** | Feeding-pressure check-in elevated AND mood check-in low (or EPDS ≥10 with active feeding struggles) | **E3 watch**: surface mood support tied to feeding pressure ("feeding difficulties and low mood often travel together"); EPDS with standard framing; Q10 rule inherited |
| **Weaning started** | weaning_state set, or feeding logs taper | Weaning planner hero; engorgement/mastitis watch up; mood check-in cadence up; cycle-return education on |
| **Weaning complete** | weaning completed date set | Archive E2 layer (reachable); hand focus to **E1** residual recovery or general track; cycle-return watch active; weaning-grief normalization card once |
| **Return of fertility signals** | First postpartum period logged, OR any LAM criterion breaks (≥6 months, feeding intervals lengthen, bleeding) | LAM strip updates + one-time "fertility can return now — contraception is a clinician conversation" card; offer transition to **B1** (cycle) or **C1** (if TTC intent) per E1's return-of-cycle handler |
| **Back-to-work date approaching** | Date within 3 weeks | Pumping planner + storage rules + rights/logistics education foregrounded |
| **12-month+ continued feeding** | postpartum_week > 52, feeding active | Stay in E2 (extended feeding is first-class); content shifts to toddler-feeding-and-her-body; E1 graduates independently |

*All routing is content/UX routing, not clinical triage. Femio surfaces resources and prompts; clinicians decide.*

---

## K. Compliance flags

- **Scope guardrail:** wellness/education/tracking only. No diagnosis (esp. mastitis), no treatment advice (no antibiotic/antifungal guidance, no galactagogues), no prevention claims, no medical-device-triggering language (no "monitors supply," no adequacy algorithms).
- **Meds content is the highest-risk surface:** every medication card must be educational, cite LactMed/Tier-1, carry the clinician/pharmacist routing close, and never render a compatibility verdict or icon. Legal review of this surface before launch.
- **No infant-feeding adequacy judgments or commercial promotion:** Femio never states or implies that the baby is or is not getting enough. It accepts no manufacturer sponsorship, targeted promotion, samples, coupons, lead-generation, or product-placement for breast-milk substitutes or other products within the Code’s scope. Neutral feeding education must not be formula-shaming and must not be presented as personalized adequacy assessment. The [WHO 2023 digital-marketing guidance](https://www.who.int/publications/i/item/9789240084490) informs this product rule; launch counsel must separately map the stricter or different national implementation in each market. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
- **LAM = education, never contraception advice:** criteria display is awareness-only with mandatory clinician routing; no efficacy promises tied to her data.
- **Mastitis red-flag prominence:** §G box mandatory in all mastitis-spectrum content and after qualifying logs; sepsis-warning line included; locale emergency numbers.
- **Mood coupling:** feeding-struggle + low-mood pathway inherits all E1/E3 EPDS rules including the mandatory Q10 crisis rule.
- **Sensitive data:** feeding intent, meds questions, mood, and breast-symptom logs = special-category handling; explicit consent for storage/sharing; support-circle share cards are scoped + revocable; no ad/analytics SDK exposure (GDPR/PDPL; see femio-compliance-privacy).
- **Cultural review:** Arabic family-pressure and religious-context content reviewed by regional advisors alongside medical review.
- **Content integrity:** every clinical statement medically-reviewed, cited, dated, reviewer visible; EN/AR/FR/ES with Arabic-first/RTL QA.
- **Publication controls:** current CDC storage and weaning pages and WHO digital-marketing guidance are pinned above. The unsupported post-weaning hormonal-mood claim is excluded. Mastitis copy stays with consensus basics and clinician routing; any named lactation-consultant directory or national Code implementation must be verified in a dated country module before display. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

- [AAP — Policy Statement: Breastfeeding and the Use of Human Milk (2022)](https://publications.aap.org/pediatrics/article/150/1/e2022057988/188347/Policy-Statement-Breastfeeding-and-the-Use-of)
- [NICHD — What are the recommendations for breastfeeding?](https://www.nichd.nih.gov/health/topics/breastfeeding/conditioninfo/recommendations)
- [HealthyChildren (AAP) — Where We Stand: Breastfeeding](https://www.healthychildren.org/English/ages-stages/baby/breastfeeding/Pages/Where-We-Stand-Breastfeeding.aspx)
- [OWH — Getting a good latch](https://womenshealth.gov/breastfeeding/learning-breastfeed/getting-good-latch)
- [OWH — Making breastmilk](https://womenshealth.gov/breastfeeding/learning-breastfeed/making-breastmilk)
- [OWH — Common breastfeeding challenges](https://womenshealth.gov/breastfeeding/breastfeeding-challenges/common-breastfeeding-challenges)
- [USDA WIC Breastfeeding Support — Steps and signs of a good latch](https://wicbreastfeeding.fns.usda.gov/steps-and-signs-good-latch)
- [USDA WIC Breastfeeding Support — Common breastfeeding challenges](https://wicbreastfeeding.fns.usda.gov/common-breastfeeding-challenges)
- [CDC — How much and how often to breastfeed](https://www.cdc.gov/infant-toddler-nutrition/breastfeeding/how-much-and-how-often.html)
- [CDC — Pumping breast milk](https://www.cdc.gov/infant-toddler-nutrition/breastfeeding/pumping-breast-milk.html)
- [CDC — Breast Milk Storage and Preparation (25 March 2026)](https://www.cdc.gov/breastfeeding/breast-milk-preparation-and-storage/handling-breastmilk.html)
- [CDC — Weaning](https://www.cdc.gov/infant-toddler-nutrition/breastfeeding/weaning.html)
- [WHO — Guidance on regulatory measures aimed at restricting digital marketing of breast-milk substitutes (2023)](https://www.who.int/publications/i/item/9789240084490)
- [CDC US-MEC — Lactational Amenorrhea Method](https://www.cdc.gov/contraception/hcp/usmec/lactational-amenorrhea-method.html)
- [Lactational amenorrhoea method — review (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6823189/)
- [ACOG — Breastfeeding Challenges (Committee Opinion 820, 2021)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2021/02/breastfeeding-challenges)
- [ABM Clinical Protocol #36: The Mastitis Spectrum, Revised 2022 (PubMed)](https://pubmed.ncbi.nlm.nih.gov/35576513/)
- [Commentary on ABM Protocol #36 (Int Breastfeed J, PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10481477/)
- [NHS — Mastitis](https://www.nhs.uk/conditions/mastitis/)
- [NHS Best Start in Life — Mastitis while breastfeeding](https://www.nhs.uk/best-start-in-life/baby/feeding-your-baby/breastfeeding/breastfeeding-challenges/mastitis/)
- [La Leche League GB — Mastitis, blocked ducts, and engorgement](https://laleche.org.uk/mastitis/)
- [LactMed — Drugs and Lactation Database (NCBI Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK501922/)
- [LactMed — Fact sheet (NCBI)](https://www.ncbi.nlm.nih.gov/books/NBK547437/)
- [Unseen, unheard: women's experiences of exclusively expressing breast milk (qualitative)](https://pmc.ncbi.nlm.nih.gov/articles/PMC8960073)
- [Breastfeeding practices among immigrant Muslim Arab women in the US (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10515608/)
- [Systematic review: breastfeeding rates and influences in the UAE (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12085000/)
- [Barriers to exclusive breastfeeding, Jazan, Saudi Arabia (J Family Med Prim Care)](https://doi.org/10.4103/jfmpc.jfmpc_73_22)
- [La Leche League International — Islamic and cultural practices in breastfeeding](https://llli.org/news/islamic-cultural-practices-breastfeeding-2/)
- [Medela Family app (Google Play)](https://play.google.com/store/apps/details?id=com.medela.mymedela.live&hl=en_US)
- [Pump Log — exclusive pumping tracker](https://pumplogapp.com/)
- [Best breast pumping apps comparison — exclusivepumping.com](https://exclusivepumping.com/breast-pumping-apps-which-is-the-best/)
- [Healthline — Let's talk about exclusively pumping moms](https://www.healthline.com/healthy/lets-talk-about-exclusively-pumping-moms-more-shall-we)
