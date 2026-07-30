# Persona E1 — General Postpartum Recovery (Mother-Centered)

> Femio persona spec. Scope: **wellness / education / tracking only.** Femio never diagnoses, treats, or prevents disease. All screeners are framed as *screening — discuss results with your clinician*, and postpartum red flags carry prominent *seek-care* framing. This document is a product/UX + clinical-grounding brief, not medical advice.

---

## A. Persona snapshot

**Who she is.** A woman 0–12 months after giving birth (vaginal or cesarean), focused on **her own** recovery — not only the baby. She is navigating a body that has changed, disrupted sleep, feeding demands, shifting hormones, and a heavy invisible "mental load." She may be a first-time mother in the "newborn trenches" or a second/third-time mother who knows the drill for the baby but is again unsure about her own healing.

**Core emotional state.** Depleted, needed-every-second, sometimes anxious or low, seeking *reassurance* ("is this normal?") and *permission* to prioritize herself. She toggles between acute worry (bleeding, pain, mood) and slow-burn questions (when will I feel like myself, when will my cycle return).

**Jobs to be done.**
- "Tell me whether what my body is doing right now is normal — or a reason to call someone."
- "Help me check on my mood without judgment, and tell me what to do with the result."
- "Give me recovery guidance matched to *how* I delivered and *how many weeks* out I am."
- "Keep me — the mother — at the center, even though every other app is about the baby."
- "Help me understand sleep, feeding, and when my cycle/fertility comes back."

**Context of use.** Web-first, often one-handed, phone in hand while feeding or during a 2 a.m. wake. Short sessions, high emotional stakes. Arabic-first/RTL and EN/AR/FR/ES matter — many users will read health guidance in Arabic where trustworthy, referenced content is scarce.

**Femio's wedge for E1.** One continuous account across the female lifespan means the postpartum phase is **not a separate app that expires** — it flows out of her pregnancy/delivery record and back into cycle/TTC or a follow-up track when her body transitions. The mother stays the subject; the baby is context, not the product.

---

## B. Needs & questions (voice-of-user)

Synthesized from postpartum communities (r/beyondthebump and similar), app-store reviews, and postpartum-wellness coverage. Direct quotes are paraphrased/representative of recurring themes, not verbatim attributions.

**The recovery arc (what she actually asks, week by week).**
- **Weeks 0–2:** "How much bleeding is too much?" "My stitches / C-section incision — is this healing or infected?" "When can I poop without fear?" "Is it normal to cry this much / feel this flat?"
- **Weeks 2–6:** "When can I lift / drive / have sex / exercise?" "Why do I leak when I sneeze — will it stop?" "The baby blues should be gone by now… is this something more?"
- **Weeks 6–12:** "My six-week check felt like it was all about the baby and lasted five minutes." "When will my period come back if I'm breastfeeding?" "Can I get pregnant before my period returns?"
- **Months 3–12:** "Night sweats, hair falling out, joints ache — nobody warned me." "I still don't feel like myself." "Is my low mood postpartum depression or just exhaustion?"

**Recurring pain points (the mental-load theme).**
- **The mother disappears.** Every tracker she downloads is about the baby — feeds, naps, diapers. Her own bleeding, mood, pelvic floor, and healing have *no home*. She is "needed every second" yet has nowhere to log herself.
- **"Is this normal?" anxiety.** The single most common posture. She wants a fast, credible, non-alarmist normal-vs-seek-care signal, not a search-engine rabbit hole.
- **Under-served mental health.** Emotional and mental wellness "go completely unaddressed" and shape every moment of her experience. She wants a private, judgment-free way to check in — and to be *told what the number means and what to do next*.
- **The six-week cliff.** After one brief postpartum visit, care effectively ends, even though problems can arise up to a year out. She wants continuity, not a discharge.
- **Fragmented, low-trust info.** Forums are warm but anecdotal; clinical sites are authoritative but cold and English-only. She wants warm *and* referenced — especially in Arabic.

**What "good" looks like to her.** Mother-centered home screen; symptom logging for *her*; a mood check she trusts; guidance tuned to her delivery type and postpartum week; clear red-flag boxes that tell her when to stop scrolling and call someone; and everything reachable in one or two taps.

---

## C. Competitor teardown (feature by feature — where the MOTHER is missing)

| Product | Postpartum / maternal-health depth | Mother's recovery tracking | Mood screening | Return-of-cycle / fertility | Clinical referencing | Gap for E1 |
|---|---|---|---|---|---|---|
| **Ovia (Postpartum Experience)** | Strongest peer: 12-month program covering birth recovery, complications, reproductive planning, return-to-work, mental health; personalized to delivery type & conditions; "Critical Alert" on risky symptoms | Yes — daily symptom check personalized to delivery/history | Yes (mood content/checks) | Yes (reproductive planning) | Moderate; employer-sponsored data-access scrutiny (Labcorp-owned). Standalone Ovia Pregnancy app being retired (~Mar 2026), consolidating into Ovia Cycle & Pregnancy | Privacy optics (employer/de-identified data); not Arabic-first/RTL; product churn/consolidation; less referenced-content transparency |
| **Flo (postpartum mode)** | Polished period/cycle app with pregnancy & some postpartum content | Limited maternal recovery logging beyond cycle/symptoms | Some mental-wellbeing content | Strong on cycle return (its core) | Content-forward but **notable privacy history** (2021 FTC settlement re: data sharing; 2025 class-action settlement reported) | Trust deficit on health-data privacy; postpartum recovery is shallow vs. its cycle core; not mother-recovery-first; not Arabic-first |
| **What to Expect** | Broad pregnancy→baby content + community | Minimal structured *maternal* recovery tracking | Editorial content only | Editorial content only | Editorial/brand voice; community-heavy | Community over personalization; the mother's *logged* recovery isn't the product; ad-supported |
| **The Fourth Trimester–type apps** | Explicitly mother-focused recovery/wellness (e.g., meditation, coaching) | Wellness-oriented, not clinical symptom logging | Mindfulness/coping tools | Rarely | Wellness framing, light clinical referencing | Strong ethos, thin on structured screening + red-flag safety + cycle/fertility continuity |
| **Huckleberry** | Baby-centric (AI sleep/feed/diaper). Reviews note it *indirectly* helps mom by reducing mental load | **None** for maternal health | None | None | Pediatric-expert framing (baby) | The archetype of "mother disappears": no maternal recovery, mood, or fertility surface at all |
| **Baby Tracker / Glow Baby / similar** | Baby logs (feeds, sleep, diapers, growth) | **None** | None | None (Glow ecosystem covers cycle elsewhere) | Utility trackers | Same gap — the woman is a data-entry clerk for the infant, not a patient in her own right |

**Teardown takeaways for Femio.**
1. **Whitespace = mother-recovery-first + referenced + Arabic/RTL + privacy-by-design.** Ovia is the only serious maternal-recovery peer, and it carries privacy-optics baggage and is not Arabic-first; baby trackers ignore the mother entirely.
2. **Continuity is a differentiator.** Competitors either expire (baby apps end; Ovia consolidating) or silo cycle vs. postpartum. Femio's one-lifespan account makes the transition *postpartum → cycle/TTC → next pregnancy* seamless.
3. **Trust is contestable.** Two of the biggest names carry data-privacy scars. Femio's privacy-by-design + medically-reviewed, cited content is a direct wedge.

---

## D. Clinical grounding (cited)

*All items below are education/tracking context for Femio content. Femio presents these as general information and screening prompts, not diagnosis.*

**Postpartum care is a process, not a single visit ("the fourth trimester").** ACOG recommends contact with a maternal care provider **within the first 3 weeks** postpartum, ongoing care as needed, and a **comprehensive visit no later than 12 weeks** — a paradigm shift from the single 6-week check. ([ACOG, Optimizing Postpartum Care, Committee Opinion 736](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/05/optimizing-postpartum-care)) The NHS frames the first postpartum check within ~6 weeks of delivery. ([NHS inform, You and your body after birth](https://www.nhsinform.scot/ready-steady-baby/early-parenthood/your-wellbeing-after-the-birth/you-and-your-body-after-birth/))

**Urgent maternal warning signs (can occur up to a year after birth).** CDC's Hear Her lists signs that warrant **immediate** care: severe/worsening headache; dizziness or fainting; **thoughts of harming yourself or your baby**; vision changes; **fever ≥100.4°F / 38°C**; extreme swelling of hands/face; trouble breathing; chest pain or fast-beating heart; severe nausea/vomiting; severe belly pain; **heavy vaginal bleeding or leaking fluid**; leg swelling/redness/pain; overwhelming tiredness. More than 80% of pregnancy-related deaths are considered preventable. ([CDC Hear Her — Urgent Maternal Warning Signs](https://www.cdc.gov/hearher/maternal-warning-signs/index.html))

**Normal physical recovery (to calibrate "is this normal?").**
- **Lochia (bleeding):** red for the first ~3–7 days, then lightens to pink/brown, typically stopping over ~3–6 weeks. ([NHS/UHS patient info; womenshealthsussex.org](https://womenshealthsussex.org/maternity/after-the-birth/your-body/))
- **Perineum / tears / episiotomy:** swelling, bruising, and discomfort are common; dissolvable stitches; keep clean and dry to reduce infection risk. ([NHS inform](https://www.nhsinform.scot/ready-steady-baby/early-parenthood/your-wellbeing-after-the-birth/you-and-your-body-after-birth/))
- **Pelvic floor:** pelvic-floor muscle exercises support continence and healing; do them several times daily. ([NHS inform](https://www.nhsinform.scot/ready-steady-baby/early-parenthood/your-wellbeing-after-the-birth/you-and-your-body-after-birth/)) C-section recovery and wound-care content must follow the [NHS Caesarean recovery guidance](https://www.nhs.uk/tests-and-treatments/caesarean-section/recovery/) rather than a fixed Femio timeline. *(Reviewed Mohamed K., 23 July 2026.)*

**Mood screening — EPDS.** EPDS is a 10-item screen, not a diagnosis. Femio does not apply one universal diagnostic threshold: a configured health-system module may use its reviewed local protocol. As a cited example, NSW Health monitors/repeats scores of 10–12, arranges further assessment at 13 or more, and requires immediate further mental-health assessment for a positive Question 10 response, with urgent action if suicidal ideation is disclosed. Use only the complete, unmodified instrument and a validated language version with attribution under [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md). ([NSW Health EPDS guidance](https://www.mhcs.health.nsw.gov.au/publications/epds/english); reviewed Mohamed K., 23 July 2026.)

**Return of fertility & lactational amenorrhea (LAM).** CDC requires all three LAM criteria: (1) amenorrhea, (2) fully/nearly-fully breastfeeding with intervals no longer than 4 hours by day or 6 hours by night, and (3) under 6 months postpartum. Femio explains these criteria but never produces a protection verdict. When one no longer holds, it routes a user who wants to avoid pregnancy to current local contraception information and a clinician/pharmacist. Fertility can return before the first period. ([CDC LAM appendix, updated September 2025](https://www.cdc.gov/contraception/hcp/usmec/lactational-amenorrhea-method.html); [reviewed global rule](../compliance/CONTRACEPTION_SAFETY.md); reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)

---

## E. Feature set (prioritized)

**P0 — must ship (safety + core wedge).**
1. **Mother-centered postpartum Home** — configured by delivery type + postpartum week; her recovery, not the baby, is the subject.
2. **"Is this normal?" recovery guide** — week-indexed cards on bleeding/lochia, perineum or C-section healing, pain, discharge, afterpains — each with an embedded **red-flag box**.
3. **Red-flag / seek-care system** — persistent, prominent CDC-aligned warning-sign surface with locale-appropriate emergency/crisis resources.
4. **EPDS screening** — compliant framing, Q10 safety routing, result → "discuss with clinician," never a diagnosis.
5. **Maternal symptom & wellbeing log** — bleeding, pain, mood, sleep, feeding context — logged *for her*.

**P1 — high value.**
6. **Pelvic-floor & healing hub** — Kegel guidance/reminders, gradual return-to-activity education.
7. **Return-of-cycle & fertility-awareness education** — LAM criteria explainer, "fertility can return before your period" reassurance, gentle transition prompts.
8. **Postpartum visit tracker** — nudges aligned to ACOG "process" model (≤3 weeks contact; comprehensive ≤12 weeks).
9. **Sleep & feeding *context*** — framed around the mother's recovery and mood, not baby-tracking.

**P2 — enrichment.**
10. Personalized content feed by week/history. 11. Reassurance/education micro-content ("what nobody told me": hair shedding, night sweats). 12. Partner/support-person share (privacy-gated). 13. Save/bookmark for quick 2 a.m. access.

**Explicitly out of scope for E1.** Full baby-tracking suite (feeds/naps/diapers as a product), diagnosis/treatment engines, medication dosing, any predictive medical claim.

---

## F. Content modules (medically-reviewed, referenced, grade 6–8, 4 languages)

1. **Your body after birth (week-indexed):** lochia timeline; perineum/tear/episiotomy care; C-section incision care; afterpains; discharge & odor; hemorrhoids/constipation.
2. **Warning signs — when to seek care now:** CDC-aligned, plain-language, RTL-ready, with escalation framing.
3. **Your emotions & mental health:** baby blues vs. postpartum depression/anxiety; what EPDS is and isn't; where to get help; crisis resources.
4. **Pelvic floor & moving again:** Kegels how-to; when/how to resume activity, lifting, driving, sex (general education + "ask your clinician").
5. **Sleep & rest for the mother:** realistic expectations, protecting maternal sleep, mood link.
6. **Feeding & your body:** breastfeeding/pumping/formula from the *mother's* wellbeing angle; engorgement/mastitis warning signs (seek-care framed).
7. **Cycle & fertility return:** LAM criteria; unpredictability; contraception-is-a-clinician-conversation framing.
8. **Your postpartum visits:** ACOG "process" model; what to raise; advocating for yourself ("Hear Her").
9. **What nobody told me:** hair shedding, night sweats, joint aches, hormonal shifts — normalized + referenced.

*Every module: medically-reviewed, cited, dated, reviewer + review-date shown; localized EN/AR/FR/ES with Arabic-first/RTL layout.*

---

## G. Tools, logs & alerts (compliant framing)

**Logs (for the mother).**
- Bleeding/lochia (amount + color trend), pain level & site, perineum/incision status, mood, sleep, feeding context, physical symptoms (swelling, headache, fever), pelvic-floor exercise streak.
- Logs are **educational self-tracking**, not monitoring or diagnosis; no risk scores presented as medical judgments.

**EPDS tool (compliant).**
- Intro: *"This is a screening questionnaire, not a diagnosis. Your answers help you and your clinician talk about how you're feeling."*
- Scoring bands shown as ranges with neutral language; **≥10 / ≥13** prompt *"consider discussing with your clinician."*
- **Q10 safety rule:** any non-zero self-harm response → immediately surfaces crisis resources + urgent-care messaging, regardless of total. Route to **E3 mood-support** track.
- No storage/sharing of screening data without explicit consent (privacy-by-design).

**Red-flag boxes (pattern).** Appear inline in relevant content and after concerning logs. Example copy:

> **Seek care now.** Call your doctor or emergency services if you have: soaking a pad in an hour or passing large clots; fever of 38°C/100.4°F or higher; severe or worsening headache; vision changes; trouble breathing or chest pain; swelling/redness/pain in one leg; a wound that's hot, swollen, or leaking; or thoughts of harming yourself or your baby. Problems can happen up to a year after birth. *(Source: CDC Hear Her.)*

**Non-negotiables.** Femio never says "you have X." Alerts describe *symptoms* + *seek-care action*, mirroring Ovia's "Critical Alert" pattern but without any diagnostic claim. Crisis/emergency numbers are locale-specific.

---

## H. EMR fields (core vs persona-specific)

**Core lifespan fields (shared across personas).**
- Identity/locale (language, RTL pref), age/DOB, consent flags & data-sharing preferences.
- Reproductive history (gravidity/parity), chronic conditions, medications/allergies, clinician/care-team (optional).
- Cycle history (pre-pregnancy), prior pregnancies/outcomes.

**E1 persona-specific fields.**
- **Delivery event:** date of birth (delivery), delivery type (vaginal / assisted / cesarean), perineal tear degree or episiotomy (optional), complications flags (hemorrhage, pre-eclampsia/hypertension, infection, GDM) → feeds E4 follow-up.
- **Postpartum week** (derived from delivery date) — primary personalization key.
- **Recovery logs:** lochia trend, pain, incision/perineum status, pelvic-floor activity.
- **Feeding status:** breastfeeding (exclusive/partial) / formula — drives LAM logic & feeding content.
- **Mood:** EPDS scores + dates + Q10 flag (consent-gated, sensitive-data handling).
- **Visit tracking:** first-contact done? comprehensive visit scheduled/done?
- **Cycle return:** first postpartum period date (nullable) — trigger for transition.
- **Contraception intent** (education flag only, not prescribing).

*Sensitive fields (EPDS, Q10, mood) receive elevated privacy handling; see femio-compliance-privacy.*

---

## I. Personalization rules (wizard → home config)

**Onboarding wizard captures:** delivery date, delivery type, complications (optional), feeding status, current concerns (recovery / mood / sleep / cycle), language/RTL.

**Home configuration logic (postpartum-week-driven).**
- **Derive `postpartum_week` from delivery date** and select the week-indexed content set as the primary rail.
- **Weeks 0–2:** lead with bleeding/healing "is this normal?" + red-flag box; feeding-body basics; gentle mood normalization (baby blues).
- **Weeks 2–6:** foreground EPDS prompt (baby-blues window closing); pelvic floor; return-to-activity; first-contact visit nudge.
- **Weeks 6–12:** comprehensive-visit nudge; cycle/fertility return education; mood re-check; longer-arc symptoms.
- **Months 3–12:** "still not myself" mood re-screen; cycle-return watch; "what nobody told me" content.
- **Delivery-type branch:** cesarean → incision-care module surfaced; vaginal/tear → perineum module surfaced.
- **Feeding branch:** exclusive breastfeeding → LAM criteria + mastitis warning content; formula/partial → adjust cycle-return expectations.

**Hidden-but-reachable principle.** Non-active modules aren't deleted — they're demoted, not hidden behind dead ends. Cycle/TTC, pregnancy, and follow-up tracks remain **one to two taps away** via a persistent "Explore" surface, so nothing feels amputated and transitions are frictionless. Everything reachable = Femio's continuity promise.

---

## J. Adaptation triggers

| Trigger | Condition | System action |
|---|---|---|
| **Enter E1** | Delivery event recorded (from pregnancy persona hand-off, or self-declared at onboarding) | Instantiate postpartum home; set `postpartum_week`; carry complication flags forward |
| **EPDS elevated** | Score ≥10 (watch) / ≥13 (stronger prompt) | Surface "discuss with clinician" + supportive content; **route to E3 mood-support** track; keep screening framing |
| **EPDS Q10 non-zero** | Any self-harm response | **Immediate** crisis resources + urgent seek-care; escalate to E3; independent of total score |
| **Red-flag symptom logged** | Matches CDC warning-sign set (e.g., heavy bleeding, fever, severe headache, leg pain) | Prominent seek-care interstitial + locale emergency info; no diagnosis |
| **Return of cycle** | First postpartum period date recorded (or breastfeeding wind-down) | Offer transition **back to cycle / TTC modes**; re-enable fertility-awareness surfaces |
| **Complicated-pregnancy/delivery history** | Hemorrhage, pre-eclampsia/hypertension, infection, GDM flags present | Route to / co-activate **E4 follow-up** track (longer-horizon monitoring content, still education-only) |
| **12-month horizon** | `postpartum_week` > ~52 with no active recovery needs | Graduate to general cycle/lifespan home; retain records; keep postpartum content reachable |

*All routing is content/UX routing, not clinical triage. Femio surfaces resources and prompts; clinicians decide.*

---

## K. Compliance flags

- **Scope guardrail:** wellness/education/tracking only. No diagnosis, treatment, or prevention claims anywhere in E1. Avoid "medical device"–triggering language and predictive medical claims (see femio-compliance-privacy).
- **Screening framing:** EPDS/PHQ presented strictly as *screening — discuss with a clinician*; scores shown as ranges, never labels. **Q10 self-harm rule is mandatory** and must fire independently of total.
- **Crisis resources:** use the reviewed global routing and maintained country selector in [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md) wherever self-harm, red flags, or high EPDS appear. Never substitute a US-only number or a static country list. *(WHO, 18 September 2024; Find A Helpline directory accessed 23 July 2026; reviewed Mohamed K., 23 July 2026.)*
- **Red-flag prominence:** hemorrhage, pre-eclampsia signs, infection, and severe mood/self-harm get high-visibility seek-care framing; can occur up to 12 months postpartum (CDC).
- **Sensitive data:** EPDS, mood, Q10, and reproductive fields = elevated privacy handling; explicit consent for any storage/sharing; privacy-by-design and data-minimization (GDPR/PDPL). No third-party ad/data leakage — a deliberate contrast with competitors' privacy histories.
- **Content integrity:** every clinical statement medically-reviewed, cited, dated, with reviewer + review-date visible; localized EN/AR/FR/ES with Arabic-first/RTL QA.
- **Pinned source set:** [NHS Caesarean recovery](https://www.nhs.uk/tests-and-treatments/caesarean-section/recovery/), [NIMH Perinatal Depression](https://www.nimh.nih.gov/health/publications/perinatal-depression), [NICE CG192](https://www.nice.org.uk/guidance/cg192), and [WHO postnatal-care recommendations (2022)](https://www.who.int/publications/i/item/9789240045989). Postpartum sexual-pain education is pinned to [ACOG, "When Sex Is Painful"](https://www.acog.org/womens-health/faqs/when-sex-is-painful) and routes to B12 rather than being restated here. Crisis routing is governed by [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md). *(Reviewed Mohamed K., 23 July 2026; sexual-pain source added 24 July 2026; next review 24 July 2027.)*

---

## Sources

- [ACOG — Optimizing Postpartum Care (Committee Opinion 736)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/05/optimizing-postpartum-care)
- [ACOG — When Sex Is Painful](https://www.acog.org/womens-health/faqs/when-sex-is-painful) (postpartum sexual pain; detailed handling in B12)
- [ACOG Committee Opinion No. 736 — full text (Green Journal)](https://journals.lww.com/greenjournal/fulltext/10.1097/aog.0000000000002633~acog-committee-opinion-no-736-optimizing-postpartum-care)
- [CDC Hear Her — Urgent Maternal Warning Signs and Symptoms](https://www.cdc.gov/hearher/maternal-warning-signs/index.html)
- [CDC Hear Her — Campaign overview](https://www.cdc.gov/hearher/index.html)
- [CDC US-MEC — Lactational Amenorrhea Method (Appendix G)](https://www.cdc.gov/contraception/hcp/usmec/lactational-amenorrhea-method.html)
- [Lactational amenorrhoea method for family planning — review (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6823189/)
- [NHS inform — You and your body after birth](https://www.nhsinform.scot/ready-steady-baby/early-parenthood/your-wellbeing-after-the-birth/you-and-your-body-after-birth/)
- [NHS/UHS — Blood loss (lochia): what to expect after birth (PDF)](https://www.uhs.nhs.uk/Media/UHS-website-2019/Patientinformation/Pregnancyandbirth/Blood-loss-what-to-expect-after-the-birth-of-your-baby-743a-PIL.pdf)
- [Women's Health Sussex — Your body after birth / lochia](https://womenshealthsussex.org/maternity/after-the-birth/your-body/)
- [MGH Center for Women's Mental Health — Using the EPDS to measure severity](https://womensmentalhealth.org/posts/using-epds-measure-postpartum-depression-severity/)
- [MGH Center for Women's Mental Health — ACOG increased care, fourth trimester](https://womensmentalhealth.org/posts/acog-increased-care-fourth-trimester/)
- [EPDS scoring (AAP PDF)](https://downloads.aap.org/AAP/PDF/Postnatal%20Depression%20Scale.pdf)
- [Ovia Health — Introducing the new Postpartum Experience](https://www.oviahealth.com/blog/introducing-ovia-healths-new-postpartum-experience/)
- [Best Period Tracker App — Clue vs Flo vs Ovia comparison](https://www.go-go-gaia.com/blog/how-to-choose-period-tracker-app.html)
- [Huckleberry: Baby Tracker — App Store reviews](https://apps.apple.com/us/app/huckleberry-baby-tracker/id1169136078)
- [Top Wellness Apps for New Mothers (2026 guide)](https://www.mamazen.com/post/top-wellness-apps-for-new-mothers)
- [Best Maternal Mental Health Apps — Phoenix Health](https://joinphoenixhealth.com/resourcecenter/best-maternal-mental-health-apps/)
