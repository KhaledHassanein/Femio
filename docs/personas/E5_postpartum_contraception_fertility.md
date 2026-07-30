# Persona E5 — Postpartum Contraception & Return of Fertility

> Femio product + UX research spec. Wellness / education / tracking scope only. **Femio is NOT a contraceptive**: it never claims to prevent pregnancy, never provides "safe days," never computes LAM protection status, and never replaces a clinician-chosen method. Its role here is **education (return-of-fertility, LAM criteria and limits, method-timing landscape, birth-spacing awareness) + tracking + clinician routing** — the contraception decision and the contraception itself belong to her clinician and her method. Screeners are framed "discuss with a clinician."
> Research date: 2026-07-21 · Persona band: E (postpartum) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (§1 invariants, §2 state object, §3 core, §5 Z1, §6 universal events, §8 blending) · Siblings: E1 (general recovery), E2 (feeding), B13 (method support), C1 (TTC)

---

## A. Persona snapshot

**Who she is.** "Mariam," 29, gave birth 7 weeks ago. She is breastfeeding (mostly, with an evening formula bottle), has not had a period since delivery, and is starting to think about sex again — and immediately about pregnancy. Her mother and half her group chat have told her "you can't get pregnant while nursing." Her own gut, and one alarming forum thread about babies born 11 months apart, tell her otherwise. She hasn't decided whether she wants another child soon, later, or at all; right now she just wants to **not be surprised**. Arabic-first (reads English too), web on her phone, one-handed while feeding.

**What she's navigating.**
- **The invisibility of returning fertility.** Ovulation comes back **before** the first period, so the usual signal ("my period's back") arrives *after* she's already been fertile. Non/partially-breastfeeding mothers can ovulate as early as ~week 3–4. She has no idea where she is on that curve.
- **The LAM half-truth.** Breastfeeding *can* suppress ovulation — but only while three criteria hold simultaneously. Long feeding intervals, supplementation, return of menses, or reaching 6 months can mean they no longer all hold.
- **A method decision under time pressure and fog.** Her six-week visit included a 90-second contraception question she wasn't ready for. She's heard the mini-pill is "the breastfeeding one," that estrogen is "not allowed yet," that IUDs can go in "right away or later" — fragments without a map.
- **Spacing questions she's embarrassed to ask.** "If I *do* want another, how soon is too soon?" She's heard everything from 6 months to 2 years.

**Core emotional drivers.** Fear of an accidental too-soon pregnancy while her body is still healing; guilt/confusion about contraception while breastfeeding ("will it hurt my milk?"); annoyance at being lectured; desire for a **neutral, referenced map** she can take into a real clinician conversation. She does not want an app to tell her she's "safe" — she wants to understand why nobody can tell her that.

**Jobs-to-be-done.**
1. Understand **when fertility can return** for her situation (feeding pattern, weeks postpartum) — as honest ranges, not a prediction of protection.
2. Understand **what LAM actually requires**, whether her current feeding pattern plausibly meets it, and get an **awareness prompt when a criterion breaks** (baby hits 6 months, period returns, feeding pattern changes) — framed as "the described criteria no longer all hold — good time to talk with your clinician," never "you are/aren't protected."
3. Get a **balanced, referenced map of method options and their postpartum timing** (progestin-only ≈ anytime; combined-estrogen delayed for VTE risk; IUD within 48h or after ~4 weeks) — education for the clinician conversation, not a recommendation.
4. Learn what **ACOG/WHO describe about birth spacing** so she can plan (or plan to wait) deliberately.
5. If she chooses a method → get B13-style reminder + side-effect support. If she wants another baby → move to TTC with spacing education. If her cycle returns → resume cycle tracking with postpartum-honest uncertainty.

**Success = no surprise: she knows fertility can precede the first period, knows exactly what LAM does and doesn't promise, walks into her postpartum visit with a method shortlist and questions, and never once treats Femio as the thing preventing pregnancy.**

---

## B. Needs & questions (voice-of-user)

Mined from postpartum/breastfeeding communities (r/beyondthebump, r/breastfeeding, r/birthcontrol), app-store reviews, and patient-education comment threads. Paraphrased to recurring themes, not verbatim.

**The myth, live and everywhere:**
- "My mom swears you can't get pregnant while nursing. My cousin has two babies 13 months apart. Who's right?"
- "I'm exclusively breastfeeding and haven't had a period — do I even need to think about this yet?"
- "I got pregnant at 5 months postpartum with no period ever coming back. Nobody told me ovulation comes first."
- Surprise-pregnancy-while-breastfeeding stories are a staple of postpartum forums; the absence of a period is repeatedly mistaken for absence of fertility.

**On LAM specifically:**
- "What actually counts as 'exclusive'? We do one formula bottle at night."
- "Baby started sleeping 8 hours — does the night gap break the rules?" (Yes — the described criterion is feeds no more than ~6h apart at night.)
- "Baby turns 6 months next week and started solids. So… now what?"
- "I pump at work — does pumping count the same as nursing?" (Femio asks about actual feeding intervals and supplementation; it does not invent a pumping-specific protection rule.)

**On method timing / choice:**
- "My OB offered the mini-pill at 2 weeks. Isn't it too early for hormones?"
- "Why can't I have my usual combined pill yet?" (VTE risk window — education.)
- "Can I get the IUD at delivery or do I have to wait? I don't want another appointment with a newborn."
- "Will hormonal birth control tank my milk supply?" (Wants balanced evidence framing, clinician-routed.)
- "The 6-week visit asked me to pick a method on the spot. I froze."

**On spacing:**
- "How long should I *actually* wait before trying again? I'm 36 and feel the clock."
- "We want them close in age — what are the real risks of back-to-back?"
- "After my C-section, is there a different waiting time?" (Clinician question; Femio surfaces it as one.)

**The boundary questions Femio must refuse-and-route:**
- "Am I safe right now if I meet the LAM rules?" → Femio explains the criteria and their limits, then routes to a clinician. **Never a protection verdict.**
- "Can you tell me my fertile days so I can avoid them?" → No "safe days," ever. Fertility-awareness content is labelled education-only; postpartum cycles make FAM especially unreliable (FSRH).
- "We had an accident last night — am I okay?" → Emergency-contraception *education* (time-sensitive, see pharmacist/clinician now); no risk math.

**Top questions Femio must answer in-product (all educational):**
1. When can fertility return after birth — for my feeding pattern? (Ranges, honestly.)
2. Can I really rely on breastfeeding? What are LAM's three criteria and what breaks them?
3. What method options exist postpartum and when can each typically start? (Landscape, not advice.)
4. Does contraception affect breastfeeding/milk? (Balanced, clinician-routed.)
5. How long do guidelines suggest waiting before the next pregnancy — and why?
6. What do I ask at my postpartum visit so I don't freeze again?

---

## C. Competitor teardown

Focused on the postpartum fertility-return + contraception-education seam — a corridor almost every product either ignores or handles dangerously.

| Product | Postpartum fertility-return education | LAM handling | Method-timing education | Spacing education | Scope posture | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Ovia** | Best peer: postpartum program includes reproductive planning + short-IPI content | Mentioned in content | Some, in employer-benefit context | Yes (short-IPI guide) | Education; employer-data optics, not AR-first; product consolidating | Referenced, privacy-clean, Arabic-first version of what Ovia gestures at |
| **Flo** | Cycle-return oriented; postpartum mode shallow | Thin | Thin | Minimal | Cycle-prediction DNA — risk of implying predictive confidence in the exact window (postpartum) where predictions are least valid; privacy scars (FTC 2021, 2025 class settlement) | Uncertainty-honest postpartum mode: **no fertile-window UI at all** until cycles re-establish |
| **Natural Cycles** | Explicit postpartum mode (red days until first detected ovulation) | Addressed within its algorithm | N/A — it *is* the method | No | **FDA-cleared contraceptive** — makes the pregnancy-prevention claim | **The anti-model** (see K). Femio must never drift here; its postpartum value is education + routing, not protection |
| **Baby trackers (Huckleberry, Glow Baby, etc.)** | None | None — despite logging the exact feeding data LAM criteria depend on | None | None | Baby-utility | The irony: they hold the feeding-interval data and say nothing. Femio (with E2 feeding context) can ethically surface *awareness*, clinician-routed |
| **What to Expect / BabyCenter** | Editorial articles + forums (where the myth thrives *and* gets debunked anecdotally) | Editorial | Editorial | Editorial | Ad-supported content | Structured, personalized, referenced vs. forum roulette |
| **Pill-reminder apps (myPill etc.)** | None | None | None | None | Utility | No bridge from "postpartum, deciding" to "on a method, supported" — Femio's E5→B13 hand-off is that bridge |

**Cross-cutting takeaways:**
1. **The corridor is empty.** Between baby trackers (feeding data, zero fertility context) and cycle apps (fertility UI, zero postpartum honesty) nobody serves the mother in the ovulation-before-first-period gap — precisely where surprise pregnancies happen.
2. **The honest-uncertainty position is defensible and differentiating.** Natural Cycles took the regulated-device path; Flo risks over-confident prediction. Femio's "we will not show you a fertile window right now, and here is why" is both safer and more trustworthy.
3. **Awareness prompts from feeding data are the ethical unlock** — but only as "criteria described by guidelines no longer all hold → clinician conversation," never as protection status.

*Publication rule: competitor details in §C are internal discovery notes and are not approved for public comparison. Any future named-app feature, regulatory-status, price, or privacy claim requires a dated official listing/regulator/policy capture and compliance review; otherwise omit it. Femio’s contraception-safety boundary stands independently. *(Approved Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## D. Clinical grounding (cited)

All framed as **education**. Femio never computes protection, never issues safe days, never recommends a method.

**Return of ovulation — before the first period, earlier than expected.**
- In **non-breastfeeding** women, ovulation returns on average ~6 weeks postpartum but can occur as early as ~day 25; ~40% ovulate by 6 weeks, and ovulation precedes first menses by ~2 weeks — so first fertility is invisible. ([Jackson & Glasier, systematic review, PubMed](https://pubmed.ncbi.nlm.nih.gov/21343770/); [ACOG PCA Initiative, Postpartum Contraception & Breastfeeding](https://pcainitiative.acog.org/wp-content/uploads/Postpartum-Contraception-and-Breastfeeding-1.pdf))
- NHS: **pregnancy is possible from 3 weeks (21 days) after birth**, including while breastfeeding and before any period, because ovulation comes ~2 weeks before a period; contraception (if desired) is described as starting by day 21. ([NHS — Sex and contraception after birth](https://www.nhs.uk/baby/support-and-services/sex-and-contraception-after-birth/))
- FSRH: contraception is not required in the first 21 days; from day 21 fertility must be assumed unless **all** LAM criteria are met. Fertility-awareness methods are described as **difficult/unreliable** postpartum and during breastfeeding (signs of ovulation are obscured). ([FSRH Guideline — Contraception After Pregnancy](https://www.fsrh.org/Public/Public/Standards-and-Guidance/Current-Clinical-Guidance.aspx); [exec summary PDF](https://www.cosrh.org/Common/Uploaded%20files/documents/contraception-after-pregnancy-executive-summary-final27feb.pdf))
- Breastfeeding **delays but does not reliably prevent** return of ovulation; timing varies enormously with feeding intensity — months to over a year. ([LAM review, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6823189/))

**LAM — the three criteria, all simultaneously, and what breaks them.**
- ≥98% described effectiveness **only while all three hold**: (1) **amenorrhea** (no period since ~day 56 postpartum), (2) **fully or nearly-fully breastfeeding** — day feeds no more than ~4h apart, night feeds no more than ~6h apart, minimal supplementation, and (3) **infant under 6 months**. ([CDC US-MEC — LAM appendix](https://www.cdc.gov/contraception/hcp/usmec/lactational-amenorrhea-method.html); [LAM review, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6823189/))
- Criterion breakers include return of menses, feeding intervals beyond the stated day/night limits, moving away from fully/nearly-fully breastfeeding, or reaching 6 months postpartum. CDC does not give pumping a separate protection rule in this appendix, so Femio asks about actual feeding intervals and supplementation and does not claim that pumping itself preserves or reduces effectiveness. ([CDC LAM appendix, updated September 2025](https://www.cdc.gov/contraception/hcp/usmec/lactational-amenorrhea-method.html); [reviewed global rule](../compliance/CONTRACEPTION_SAFETY.md); reviewed Mohamed K., 23 July 2026.)
- US survey data show widespread **misunderstanding** of LAM among pregnant women — the myth is documented, not anecdotal. ([Understanding of LAM among U.S. pregnant women, PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10460681/))

**Method timing postpartum (educational landscape — the clinician decides).**
- **Progestin-only methods** (POP/mini-pill, implant, DMPA injection): described by NHS/FSRH/CDC as **startable immediately after birth**, including while breastfeeding (implant/injection can be given before hospital discharge; POP straight away). ([NHS — Sex and contraception after birth](https://www.nhs.uk/baby/support-and-services/sex-and-contraception-after-birth/); [CDC US-MEC summary chart](https://www.cdc.gov/contraception/media/pdfs/2024/07/us-mec-summary-chart-color-508.pdf))
- **IUD/IUS (hormonal or copper)**: described as insertable **within 48 hours of delivery** or otherwise deferred to **~4 weeks** postpartum. ([NHS](https://www.nhs.uk/baby/support-and-services/sex-and-contraception-after-birth/); [ACOG — Postpartum Birth Control FAQ](https://www.acog.org/womens-health/faqs/postpartum-birth-control))
- **Combined hormonal (estrogen-containing) methods**: **not <21 days postpartum** for anyone (postpartum VTE risk is 22–84× baseline in the first 42 days); 21–42 days depends on breastfeeding status and other VTE risk factors; generally usable **after 42 days**. FSRH: not before 6 weeks if breastfeeding. ([CDC MMWR — revised postpartum CHC recommendations](https://www.cdc.gov/mmwr/preview/mmwrhtml/mm6026a3.htm); [CDC US-SPR — combined hormonal contraceptives](https://www.cdc.gov/contraception/hcp/usspr/combined-hormonal-contraceptives.html); [FSRH Contraception After Pregnancy](https://www.cosrh.org/Common/Uploaded%20files/documents/contraception-after-pregnancy-guideline-oct2020.pdf))
- **Breastfeeding + hormones:** guidelines describe progestin-only methods as compatible with breastfeeding; evidence on milk-supply effects is a clinician conversation, not a Femio verdict. ([ACOG PCA — Immediate Postpartum Contraception and Breastfeeding](https://pcainitiative.acog.org/wp-content/uploads/Immediate-Postpartum-Contraception-and-Breastfeeding_Updated.pdf))
- Femio presents all of the above as **"what guidelines describe" + "your clinician will weigh your history"** — never eligibility screening, never a start/stop instruction.

**Birth spacing / interpregnancy interval (IPI) — awareness, not gatekeeping.**
- **ACOG/SMFM Obstetric Care Consensus No. 8 (Interpregnancy Care):** advises **avoiding IPI < 6 months** and counseling on risks/benefits of conceiving **< 18 months** after a birth; short IPI is associated with preterm birth, low birth weight, SGA and maternal risks. ([ACOG — Interpregnancy Care, OCC #8](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2019/01/interpregnancy-care); [PubMed](https://pubmed.ncbi.nlm.nih.gov/30575677/))
- **WHO (2005 technical consultation):** recommends waiting **at least 24 months** after a live birth before the next pregnancy (~33-month birth interval); ≥6 months after miscarriage. ([WHO — Report of a technical consultation on birth spacing](https://www.who.int/publications/i/item/WHO-RHR-07.1))
- Framing rule: spacing content is **information for her plan**, tone-neutral toward whatever she chooses (including trying sooner—age, fertility history, and priorities belong in the clinician conversation). Femio informs; it never scolds. For a prior cesarean, the [ACOG/SMFM Interpregnancy Care consensus](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2019/01/interpregnancy-care) says shorter intervals are associated with increased uterine-rupture, maternal-morbidity, and transfusion risks among people considering labour after cesarean. Femio does not calculate individual VBAC eligibility or prescribe a waiting period. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Emergency contraception (education and rapid routing only).** If a postpartum user asks about emergency contraception, Femio says that options are time-sensitive and immediately routes her to a pharmacist or clinician. It does not decide eligibility, choose a method, calculate pregnancy risk, or advise interruption of breastfeeding. NHS states that the emergency contraceptive pill can be used while breastfeeding; method and postpartum-timing details remain clinician/pharmacist decisions. ([NHS, *Who can take the emergency contraceptive pill*](https://www.nhs.uk/contraception/methods-of-contraception/emergency-contraceptive-pill-morning-after-pill/who-can-take-it/); [NHS SPS, *Using emergency contraception during breastfeeding*](https://www.sps.nhs.uk/articles/using-emergency-contraception-during-breastfeeding/), accessed 24 July 2026) *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — must ship.**
1. **"Your fertility can return before your first period" explainer surface** — the persona's core teaching moment, shown early in E-track (from ~week 3), personalized by feeding status. Honest ranges; **no fertile-window or ovulation UI anywhere in E5 mode** (suppressed, not merely hidden — postpartum prediction would be false confidence).
2. **LAM criteria checker — awareness edition.** Shows the three criteria as an educational checklist against her logged context (baby's age from delivery date, bleeding log, feeding pattern from E2 if logged). Output is only ever: "all three described criteria currently appear to hold" / "criterion X no longer holds — guidelines describe LAM as no longer reliable; a good moment to talk with your clinician." **Never a protection percentage, never "you're covered."** Persistent not-a-contraceptive footer on this exact surface.
3. **Criterion-break awareness prompts** — baby approaching/reaching 6 months; first postpartum bleed logged; feeding-pattern change (night gap > ~6h, supplementation logged) → gentle, non-alarming prompt + clinician routing. Opt-in-able off.
4. **Method options & timing map (educational)** — per-method cards: what it is, when guidelines describe it as startable postpartum (immediate vs 48h/4wk IUD windows vs 21/42-day estrogen constraints), breastfeeding compatibility as described, common side effects. Neutral, referenced, no recommendation ranking.
5. **Postpartum-visit contraception prep pack** — "don't freeze at the 6-week visit": her feeding pattern, bleeding status, intentions (another child? when-ish?), shortlisted questions, exportable. Pairs with E1's visit tracker.
6. **Not-a-contraceptive boundary as UX** — onboarding ack for E5 mode + persistent footer on LAM/method surfaces: "Femio helps you understand and prepare. It does not prevent pregnancy and can't tell you which days are safe."

**P1 — differentiators.**
7. **Birth-spacing explainer + planning card** — ACOG (<6mo avoid; <18mo counsel) and WHO (24mo) presented side-by-side, tone-neutral, with "your age, history and cesarean status change this conversation — bring it to your clinician."
8. **Myth-vs-evidence module** — "can't get pregnant while nursing," "no period = no fertility," "the mini-pill doesn't work," "breastfeeding hormones make BC unsafe."
9. **EC education card** — always reachable, time-sensitivity forward, pharmacist/clinician routing, zero risk math.
10. **Bleeding-vs-lochia-vs-period log clarity** — helps her (and her clinician) distinguish tail-end lochia from a true first period (which matters for the LAM amenorrhea criterion) — logged raw, interpreted only as education.

**P2 — depth.**
11. Partner-share of the method-prep pack (consent-gated, revocable). 12. "What changes at 6 months" pre-brief (solids + LAM expiry + method conversation, one card). 13. **No global method-availability claim:** a method may be shown as locally available only when a dated country module names the regulator or public-health/formulary source, access route, and review date; otherwise the app says availability varies and routes to a local clinician or pharmacist. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Explicitly out of scope.** Any protection/safe-day computation; LAM as an offered method; fertile-window UI in E5; method recommendation or eligibility scoring; EC risk assessment; dosing.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, EN/AR/FR/ES, Arabic-first/RTL)

1. **When fertility comes back** — ovulation-before-period; day-21 possibility; how feeding changes the curve; why nobody can give you a date.
2. **Breastfeeding and pregnancy: the truth about LAM** — three criteria, all at once; what can mean they no longer hold (long intervals, supplementation, return of menses, 6 months); no protection verdict; "your clinician can help you choose contraception."
3. **Your method options after birth** — per-method education cards with postpartum timing windows (progestin ≈ immediate; IUD 48h-or-~4wk; combined ≥21/42 days per risk profile) and breastfeeding notes.
4. **Hormones and your milk** — balanced evidence framing; clinician-routed; no verdicts.
5. **Spacing your pregnancies** — ACOG + WHO intervals, why they exist, and why your personal answer is a clinician conversation (age, cesarean, health history). Tone-neutral to her choice.
6. **Emergency contraception after birth** — what, when, where; time-sensitive; pharmacist/clinician now.
7. **Myths vs evidence** — the nursing myth headliner + siblings.
8. **Your 6-week (and beyond) contraception conversation** — what to expect, questions to bring, your right to not decide on the spot.
9. **Femio and contraception — what we do and don't do** — plain-language scope explainer (mirrors K), shared with B13.

Every module: citations, medical-review byline + date, clinician-routing footer.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Bleeding log (lochia tail vs suspected first period — user-tagged, education-assisted, never auto-adjudicated).
- Feeding pattern (from E2 layer if active: exclusive/partial/formula; night-gap; solids/supplementation start) — doubles as LAM-criteria context.
- Intentions field: "another child?" (yes-soon / yes-later / unsure / no) — drives content emphasis only.
- Method status: none-yet / deciding / chosen (→ hands off to B13 fields).
- Sexual-activity resumed flag (optional, private, drives timing of contraception-education prominence).

**Tools**
- LAM awareness checklist (educational; see E-2/E-3; no protection output; footer always on).
- Method options & timing map + comparison view (neutral order, no ranking).
- Postpartum-visit contraception prep pack (export/print).
- Spacing planner card (informational timeline from delivery date against ACOG/WHO described intervals — a calendar overlay, not advice).

**Alerts (dismissible, discreet, localized/RTL)**
- ~Week 3: "fertility can return from now — even before a period" education prompt (gentle; tone-matched; suppressed in E6 grief contexts).
- LAM criterion-break prompts (6-month birthday approaching; bleed logged; feeding-pattern change) → "worth a clinician conversation."
- Postpartum-visit prep nudge (aligns with E1's ACOG visit cadence).
- **Never:** "you are protected," "safe days," a conception-probability, a method recommendation, or an alarm implying current pregnancy risk.

---

## H. EMR / data fields (core vs persona-specific)

**Core (from `09_MASTER_ADAPTATION_MODEL.md` §3):** identity/locale/RTL, consent flags, cycle history (pre-pregnancy, archived-reachable), reproductive history (gravidity/parity), conditions, meds, mood, delivery event + postpartum_week (shared with E1).

**E5-specific (additive layer over E1):**
- `feeding_status` + `feeding_intensity` (exclusive / nearly-full / partial / formula; night-gap hours; solids_started, supplementation) — shared with E2, drives LAM education context.
- `lam_criteria_context` {infant_age<6mo: derived; amenorrhea: from bleed log; feeding_full: from feeding log} — **stored as educational context only; no derived protection-status field exists, by design** (mirrors B13).
- `first_postpartum_bleed_date` (nullable; user-confirmed as "think it's a period" vs "spotting/lochia").
- `contraception_intent` (deciding / chosen / not-now) + `method_shortlist[]` (user notes for clinician).
- `pregnancy_intent` (another-soon / later / unsure / no) + `spacing_awareness_shown` flag.
- `sexual_activity_resumed` (optional, elevated privacy).
- `not_a_contraceptive_ack` (E5 onboarding acknowledgement).
- On method chosen → instantiate B13 fields (`method_type`, `method_start_date`, `reminder_cadence`) — one record, additive.

*Feeding, bleeding, sexual-activity and intent fields = special-category, elevated privacy, consent-gated, exportable/deletable.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Entry:** from E1/E2 (postpartum weeks advancing, or user opens "cycle & contraception after birth" card), or wizard Q5 follow-up: "Are you thinking about contraception or when your fertility returns?" → E5 layer ON (additive to E1 — E5 is a **layer over recovery**, not a replacement; hero stays recovery-appropriate per §8 most-acute rule).

**Scope moment (mandatory, mirrors B13):** one-tap card — "Femio can explain when fertility can return, what breastfeeding does and doesn't do, and your method options. **It does not prevent pregnancy, can't tell you 'safe days,' and can't confirm LAM is working — your clinician and your chosen method do that.**" Sets `not_a_contraceptive_ack`.

**Home config (E5 emphasis within postpartum home):**
- Weeks 3–6: "fertility can return before your period" card + method-timing map + visit-prep prompt (comprehensive visit approaching).
- Breastfeeding + amenorrheic: LAM education checklist card prominent, footer always on; criterion-watch prompts armed.
- Not/partially breastfeeding: earlier-return-of-fertility framing leads; LAM card demoted (criteria can't hold) but reachable.
- `pregnancy_intent = another-soon`: spacing explainer promoted, contraception cards de-emphasized (never removed); tone stays neutral.
- Month ~5: "what changes at 6 months" pre-brief (LAM expiry + solids + method conversation).
- Cycle returned: offer B1 transition; **prediction UI stays degraded** (trend-only, “postpartum cycles can be irregular,” no “late” counter). There is no fixed three-cycle unlock. Any future prediction feature must meet its validated data-sufficiency and uncertainty criteria for postpartum users; otherwise it remains unavailable. *(Internal safety default approved Mohamed K., 24 July 2026; next review 24 July 2027.)*
- **Suppressed in E5:** fertile-window/ovulation prediction, conception-probability, any "safe day" adjacent widget.

**Hidden-but-reachable:** TTC content, general cycle tools, and fertility-awareness *education* (labelled "not offered by Femio as contraception; described as unreliable postpartum — FSRH") remain searchable. Nothing amputated.

---

## J. Adaptation triggers (life-stage routing)

Inherits all **universal events** from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive pregnancy test → D-track with tone-matching — for E5 this includes acknowledging a possibly-unplanned conception gently, no celebration-by-default until she confirms how she feels; pregnancy loss → E6; mood-screen-high/crisis → E3; red-flag symptom; disengagement; toggle-off; age-of-consent). E5-specific additions:

| Trigger | System response | Route |
|---|---|---|
| **Chooses a method** (`contraception_intent = chosen`, method recorded) | Congratulate neutrally; instantiate B13 reminder engine + side-effect tracking for her method (postpartum context retained — e.g., breastfeeding note on side-effect cards); keep E1 recovery layer active | **→ B13-style support layered on E-track**; full B13 on E-track graduation |
| **Wants another baby** (`pregnancy_intent = another-soon` or sets TTC intent) | Confirm sensitively; surface **spacing education** (ACOG <6/18mo counsel-framing, WHO 24mo) as information-not-gatekeeping + "discuss timing with your clinician (age, cesarean, history)"; suppress contraception-method prompts; enable TTC features with postpartum-honest uncertainty | **→ C1** (with spacing-education card pinned; C-variant by history) |
| **Cycle returns** (first period confirmed) | Update LAM context (amenorrhea criterion broken → awareness prompt); offer cycle-tracking resumption with degraded/trend-only prediction; re-confirm privacy scope | **→ B1** (postpartum-irregularity framing) or stay E5 if still deciding on a method |
| **LAM criterion breaks** (baby 6mo; bleed logged; feeding pattern drops below described thresholds) | Gentle awareness prompt: "guidelines describe LAM as reliable only while all three criteria hold — one no longer does. Good time to talk with your clinician about next steps." Surface method-timing map + visit-prep. **No protection verdict, no alarm** | Stay E5; clinician routing |
| **Unprotected sex / "accident" concern** | EC **education** card (what it is, time-sensitive, pharmacist/clinician **now**); no risk computation; supportive tone | Stay E5 (content-only routing) |
| **Positive pregnancy test** (universal, E5-flavored) | Tone-check first ("How are you feeling about this?") before celebratory framing; carry data; if IPI < ~6mo, later surface short-IPI *education* in D-track as clinician-conversation material, never as doom | **→ D1** (short-IPI education modifier; D2 if prior-loss history) |
| **Stops breastfeeding entirely** | Update feeding fields (E2 sync); LAM context ends → awareness prompt; earlier-fertility-return framing | Stay E5 / E1 |
| **12-month horizon** (postpartum_week > ~52) | Graduate: E5 collapses into B13 (if on a method) or B1/C1 by intent; postpartum content archived-reachable | → B-track / C-track |

All transitions explicitly confirmed, reversible, data-continuous.

---

## K. Compliance flags

**THE BOUNDARY (highest priority — E5 is the persona where Femio is most tempted to cross it):**
- **Femio is NOT a contraceptive and must never behave like one — and E5 is the maximum-risk surface.** A LAM "checker" is one careless sentence away from being a contraceptive algorithm. The rule: Femio may display **what guidelines describe** about LAM's criteria and show whether her logged context matches those descriptions, but it must **never** output a protection status, a probability, a "you're covered/not covered," a green/red day, or any statement a user could reasonably act on *as contraception*. Copy on the LAM surface is compliance-reviewed word-by-word; the not-a-contraceptive footer is **structurally attached** to that surface (cannot be dismissed independently).
- **No safe days, no fertile-window UI in E5 — suppressed, not hidden.** Postpartum is precisely when cycle prediction is least valid (FSRH describes FAM as difficult/unreliable postpartum); showing any window here would be both unsafe and false confidence. Fertility-awareness content elsewhere is labelled *education, not offered by Femio as contraception.*
- **The Natural Cycles line:** making a pregnancy-prevention claim (which an implicit "LAM is currently protecting you" would be) is what makes a product an FDA Class II contraceptive device. Femio stays on the education side of that line by design: **no derived protection-status field exists in the data model** (H), so the claim cannot even be computed.
- **Method timing content is a landscape, never eligibility screening.** US-MEC/FSRH categories are presented as "what guidelines describe"; Femio never maps *her* profile to an eligibility category or a recommended method. The clinician decides; Femio preps the conversation.
- **EC:** education + immediate pharmacist/clinician routing only; never risk math, never "you're probably fine."

**Other flags (inherited + persona-specific):**
- **Scope:** wellness/education/tracking only; no diagnosis/treatment/prevention; screeners → "discuss with a clinician."
- **Spacing content is information, not gatekeeping:** ACOG/WHO intervals shown neutrally; never shaming a short IPI, never blocking TTC features, never implying a past short interval harmed her child. Post-cesarean/VBAC timing explicitly clinician-routed.
- **Unplanned-pregnancy sensitivity:** positive-test handler in E5 must tone-check before celebrating; if conception occurred despite LAM confidence, zero "we told you so" energy — support + clinician routing.
- **Feeding data ethics:** using E2 feeding logs for LAM *awareness* requires its own consent moment (purpose limitation — data logged for feeding support is being re-read in a fertility context).
- **Privacy (GDPR/PDPL):** sexual-activity, intent, feeding and bleeding fields = special-category; granular consent; no ad-SDK/third-party sharing; partner-sharing scoped + revocable; export/delete. DPIA covers the E5 layer explicitly.
- **Content integrity:** every clinical statement referenced + medically reviewed with byline/date; grade 6–8; EN/AR/FR/ES with Arabic-first RTL QA — the nursing myth is especially prevalent where Arabic-language referenced content is scarce; this module is a flagship AR-first asset.
- **App-store / device-regulation posture:** no contraception-claim trigger language anywhere in E5 strings; legal review of the LAM surface specifically before store submission.
- **Medical/source resolution:** LAM wording follows [`CONTRACEPTION_SAFETY.md`](../compliance/CONTRACEPTION_SAFETY.md), with no pumping-specific efficacy claim. Emergency-contraception routing is pinned to the NHS sources in §D; post-cesarean interval wording to ACOG/SMFM; the fixed cycle-regularity heuristic was removed; method availability requires a dated country module; competitor claims are internal-only under the rule above; and global postnatal context uses the [WHO 2022 recommendations](https://www.who.int/publications/i/item/9789240045989). *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (CDC / NHS / WHO / gov):**
- [CDC US-MEC — Lactational Amenorrhea Method (appendix)](https://www.cdc.gov/contraception/hcp/usmec/lactational-amenorrhea-method.html)
- [CDC US-MEC summary chart (2024, PDF)](https://www.cdc.gov/contraception/media/pdfs/2024/07/us-mec-summary-chart-color-508.pdf)
- [CDC MMWR — Revised recommendations: contraceptive use during the postpartum period (CHC timing, VTE)](https://www.cdc.gov/mmwr/preview/mmwrhtml/mm6026a3.htm)
- [CDC US-SPR — Combined hormonal contraceptives](https://www.cdc.gov/contraception/hcp/usspr/combined-hormonal-contraceptives.html)
- [NHS — Sex and contraception after birth](https://www.nhs.uk/baby/support-and-services/sex-and-contraception-after-birth/)
- [WHO — Report of a technical consultation on birth spacing (WHO/RHR/07.1)](https://www.who.int/publications/i/item/WHO-RHR-07.1)

**Clinical — Tier 2 (ACOG / FSRH / peer-reviewed):**
- [ACOG — Postpartum Birth Control (patient FAQ)](https://www.acog.org/womens-health/faqs/postpartum-birth-control)
- [ACOG/SMFM — Obstetric Care Consensus No. 8: Interpregnancy Care](https://www.acog.org/clinical/clinical-guidance/obstetric-care-consensus/articles/2019/01/interpregnancy-care) · [PubMed](https://pubmed.ncbi.nlm.nih.gov/30575677/)
- [ACOG PCA Initiative — Postpartum Contraception and Breastfeeding (PDF)](https://pcainitiative.acog.org/wp-content/uploads/Postpartum-Contraception-and-Breastfeeding-1.pdf)
- [ACOG PCA Initiative — Immediate Postpartum Contraception and Breastfeeding (PDF)](https://pcainitiative.acog.org/wp-content/uploads/Immediate-Postpartum-Contraception-and-Breastfeeding_Updated.pdf)
- [FSRH Guideline — Contraception After Pregnancy (2017/2020 PDF)](https://www.cosrh.org/Common/Uploaded%20files/documents/contraception-after-pregnancy-guideline-oct2020.pdf) · [Executive summary](https://www.cosrh.org/Common/Uploaded%20files/documents/contraception-after-pregnancy-executive-summary-final27feb.pdf)
- [Jackson & Glasier — Return of ovulation and menses in postpartum nonlactating women: systematic review (PubMed)](https://pubmed.ncbi.nlm.nih.gov/21343770/)
- [Lactational amenorrhoea method for family planning — review (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6823189/)
- [Understanding of LAM as a contraceptive method among U.S. pregnant women (PMC)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10460681/)
- [Grandi et al. — Postpartum contraception: a matter of guidelines (IJGO 2024)](https://obgyn.onlinelibrary.wiley.com/doi/full/10.1002/ijgo.14928)

**Spacing / context:**
- [Mayo Clinic — Family planning: pregnancy spacing facts](https://www.mayoclinic.org/healthy-lifestyle/getting-pregnant/in-depth/family-planning/art-20044072)
- [Ovia Health — Short interpregnancy interval guide](https://www.oviahealth.com/guide/111958/preg-health-birth-spacing-short-ipi/)
- [Effectiveness of WHO's interpregnancy interval advice — Lancet Global Health](https://www.thelancet.com/journals/langlo/article/PIIS2214-109X(23)00402-3/fulltext)

**Scope boundary / competitor landscape:**
- [Natural Cycles — postpartum/breastfeeding mode (help center)](https://help.naturalcycles.com/hc/en-us/articles/360003291094-How-to-use-the-app-while-breastfeeding)
- [FDA clears Natural Cycles as first digital contraceptive — pharmaphorum](https://pharmaphorum.com/news/contraception-app-natural-cycles-approved)
- [La Leche League — Lactational amenorrhea: fertility, birth control and breastfeeding](https://llli.org/news/lactational-amenorrhea-fertility-birth-control-and-breastfeeding/)
- [Patient.info — Postpartum contraception (professional reference)](https://patient.info/doctor/obstetrics/postpartum-contraception)
