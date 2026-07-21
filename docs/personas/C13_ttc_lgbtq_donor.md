# C13 — TTC, LGBTQ+ / Donor-Conception (Same-Sex Couple, Solo-by-Choice via Donor, Reciprocal IVF / IUI / At-Home Insemination)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window and insemination-timing features support **conception awareness**, and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, or prevents disease, and never provides medical, legal, or clergy advice — it educates, helps users track, and routes to a clinician / fertility-law professional. Screeners are framed as *"screening — discuss results with a clinician."*
> Persona code: **C13** · Cohort: Conception (C) · Wave 3 · Last research pass: 2026-07-17
> Inherits: seven invariants, state object, constant core, universal events, Z1 fallback, blending rules (see `09_MASTER_ADAPTATION_MODEL.md`). This spec adds only C13-specific layers.

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Alex & Sam," 32 & 34 (a two-mom couple); also stands in for a solo-by-choice woman using a donor |
| **Age band** | ~28–40 (spans the ACOG/NICE 35 threshold; many queer TTC journeys start later after coming-out, partnership, and cost/logistics planning) |
| **Stage** | Actively trying to conceive **via a third-party route** — donor sperm (bank or known donor) using at-home insemination (ICI/IVI), clinic **IUI**, or **reciprocal IVF** (one partner's eggs, other partner carries). No presumption of a diagnosed fertility problem. |
| **Family structure** | Same-sex female couple, OR single woman by choice, OR a woman with a non-cis partner who does not produce sperm. There is **no male partner who provides sperm** — the defining structural fact. |
| **Goal (top JTBD)** | *"Time our donor insemination precisely, understand our route (home vs IUI vs reciprocal IVF), and do it in an app that doesn't assume there's a man in the bed."* |
| **Health literacy** | Moderate–high; often already deeply researched (queer TTC forums are information-dense and self-taught). Wants sources + logistics, not romance-of-conception framing. |
| **Tech context** | Web-first; frequently arrives *already* churned-off a mainstream tracker whose onboarding erased her. Cross-references r/queerception, r/lesbianTTC, FertilityIQ. |
| **Locale** | EN/FR/ES/AR. **Acute cultural + legal sensitivity:** donor conception and same-sex family-building are legally restricted or socially unsafe in several Femio markets (esp. MENA). Language and outreach must be non-assuming and non-exposing. |
| **Emotional state** | Determined, logistics-heavy, financially stressed (donor vials, clinic cycles, legal fees). Grief of a negative cycle is compounded by cost-per-attempt and, sometimes, by minority stress and lack of family support. |
| **What she is NOT** | Not necessarily an "infertility patient" — she may have no fertility problem at all and simply *lacks sperm*. Framing donor conception as a medical failure is a core trust-breaker. Also **not** assumed to be partnered, married, or to want a known donor. |
| **Primary signals** | OPK/LH strips (the dominant home-insemination timing tool), BBT, cervical mucus, cycle length; for medicated/monitored cycles: clinic ultrasound/bloods, trigger-shot timing; donor-vial inventory + thaw window. |
| **Success = leaves us because…** | She conceived (→ Pregnancy mode, with correct legal-parent + donor-record continuity), OR she moved into monitored treatment we supported (→ C10 IUI/IVF), OR she completed her family. |

**Persona thesis.** C13 is the clearest **inclusivity whitespace** in the whole TTC category. Nearly every mainstream tracker hard-codes a male partner: the only "partner" option is male, "sex" is the only conception input, and the 5-day fertile window assumes fresh sperm continuously present. For a woman using **one or two thawed donor vials per cycle**, that model is actively wrong — thawed sperm survives ~12–24h, so *timing the single insemination to the LH surge/ovulation matters far more than a 6-day window*. C13 needs (1) insemination-event logging (not "sex"), (2) route literacy (home ICI/IVI vs IUI vs reciprocal IVF), (3) donor/known-donor logistics awareness, (4) genuinely non-heteronormative language, and (5) a **partner-mode that fits her family** — including "carrying partner + genetic partner" in reciprocal IVF, a co-parent who isn't pregnant, or **no partner at all**. Serve this and Femio earns fierce loyalty in an underserved, high-word-of-mouth community; assume-a-man and she churns on the onboarding screen.

---

## B. Needs & questions (voice-of-user)

Mined from r/queerception, r/lesbianTTC, r/QueerTTC, FertilityIQ's lesbian-family-building guides, and app-store / forum critique of tracker heteronormativity. Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD (donor-conception TTC):**
1. *"With frozen donor sperm I get one shot per cycle — when EXACTLY do I inseminate?"* (thawed-sperm timing is unforgiving; the whole game is hitting the LH surge / ovulation).
2. *"Home insemination (ICI/IVI) vs IUI at a clinic vs reciprocal IVF — what's the difference, success rates, and cost?"*
3. *"Bank donor vs known donor — what do I need to know medically and legally?"* (STI/genetic screening, quarantine, known-donor agreements, legal parenthood).
4. *"How many vials / cycles should I budget before switching from home to IUI to IVF?"*
5. *"Reciprocal IVF: how do we decide who provides eggs and who carries? How are the two cycles synced?"*
6. *"Am I ovulating regularly?"* — confirmation, so no vial is wasted on a mis-timed cycle.
7. *"How do I log this in an app that only lets me say I had 'sex' with a 'male partner'?"* (the erasure complaint).
8. *"How do I include my wife/partner who isn't the one being inseminated?"* (co-parent involvement without a body-centric role).
9. *"Is my known donor's sperm safe? What screening should I insist on?"*
10. *"After a negative, how do I cope — this cost us money and there's no 'just keep trying naturally.'"*

**Emotional arc (per cycle) — design must respect this:**
- **Pre-window / planning:** vial logistics, donor selection, clinic scheduling, shipping/thaw planning — a *project-management* headspace mainstream trackers ignore.
- **Insemination window:** high-stakes precision (a mistimed thaw = a wasted, expensive vial); performance pressure is financial and logistical, not romantic.
- **Two-week wait (TWW):** same obsessive symptom-spotting as C1, plus cost-anxiety and, often, doing this with less mainstream support.
- **Cycle end:** positive → joy + new questions (legal parenthood, birth-certificate, second-parent adoption); negative → grief that is compounded by cost and, sometimes, minority stress. [ASRM: infertility-related stress can rival that of serious medical diagnoses; queer patients also carry minority stress — NEEDS SOURCE for a specific minority-stress-in-TTC citation.]

**Anti-needs / trust-breakers (what makes her churn):**
- **Heteronormative defaults:** "partner (male)" as the only option; "had sex" as the only conception event; onboarding that asks about "your husband's sperm." Community reports this erases queer *and* solo users on the first screen.
- **A 5-/6-day fertile-window model presented as the plan** when she is doing a single timed frozen-vial insemination — it's misleading for her route.
- Framing donor conception as an infertility diagnosis / medical failure.
- **Outing / privacy exposure:** any partner-sharing, marketing, or default label that could disclose orientation or a donor-conceived family to family/employer/state — especially dangerous in restrictive markets.
- Assuming a **known** donor, or assuming an **anonymous** bank donor — she may have either, or be undecided.
- Legal over-reach: telling her what her parental rights *are* (varies wildly by jurisdiction) rather than routing her to a fertility-law professional.

**Feature requests recurring in forums/reviews:**
- An **"insemination" event type** (home ICI/IVI, clinic IUI) distinct from "sex," with sub-fields (fresh/frozen, vial ID, thaw time).
- **Frozen-sperm timing mode:** single-point insemination guidance tied to LH surge, not a broad window.
- **Donor & vial tracker:** donor ID, bank, screening status, vials remaining, shipment/storage.
- **Route explainers** with honest success rates and a "when to step up" ladder (home → IUI → IVF).
- **Reciprocal-IVF understanding:** who's egg-provider ("genetic mother"), who carries ("gestational/birth mother"), and how the two bodies' cycles are synchronized.
- **Flexible partner mode:** name the roles the couple chooses; support co-parent-who-isn't-pregnant and solo (no partner) equally.
- **Neutral, choose-your-own language** for relationship/anatomy, never presumed.

---

## C. Competitor teardown

Feature-by-feature, focused on **inclusivity** (the C13 axis). Key insight: **the entire mainstream category is built around a heterosexual couple having timed intercourse.** The differentiators C1 exploited (signal depth, honest prediction, privacy) still matter, but C13's whitespace is starker — *almost no one models donor conception as a first-class flow.*

| App | Non-hetero partner logging | Insemination-as-event (not "sex") | Frozen-sperm / single-timing mode | Donor / vial tracking | Reciprocal-IVF or route literacy | Inclusive onboarding language | Notable positioning |
|---|---|---|---|---|---|---|---|
| **Flo** | "Flo for Partners" is light and framed around a (typically male) partner; period/pregnancy focus | No — logs "sex" | No | No | No | Historically heteronormative onboarding; added Anonymous Mode after **FTC 2021** settlement | Huge reach, shallow for donor TTC |
| **Clue** | Better science-comms + LGBTQIA+ content articles; but sex-partner logging long criticised as male-only/limited | Partial (logging is cycle-centric) | No | No | Educational articles only | More inclusive tone than most; still not a donor-conception tool | Strong privacy posture (EU/GDPR); TTC-signal-shallow |
| **Premom** | Male-partner assumption in TTC flows | No — "intercourse" | No (window-based, LH-anchored) | No | No | Standard hetero TTC framing | **Best-in-class OPK photo reading** (relevant: LH timing is C13's core need); **FTC 2023** settlement |
| **Ovia Fertility** | Some partner visibility; hetero-default | No | No | No | Some LGBTQ content via employer channel | Improving but couple-with-man default | Employer/health-plan B2B2C |
| **Fertility Friend / Kindara** | Chart-sharing with partner/practitioner; FAM-purist, body-signal centric | No (BBT/CM/"intercourse") | No — FAM assumes fresh sperm continuously present | No | No | Neutral-ish but hetero-FAM heritage | Power-user charting gold standard; dated UX |
| **Natural Cycles** | Contraception/planning; hetero-default | No | No | No | No | N/A | **FDA-cleared contraceptive** — out of Femio scope entirely |
| **Glow** | Partner linking (hetero default) | No | No | No | Some | Community-heavy | Historic privacy scrutiny |
| **Stork / Dadi / niche queer-TTC tools** | Emerging niche donor/queer-family tools exist but are fragmented, US-centric, English-only, and not lifespan apps | Some | Some | Some | Some | Better | No AR/RTL, no lifespan continuity, thin privacy track record — **NEEDS SOURCE (verify current niche apps at build)** |

**Whitespace map (the opening for Femio):**
- **No mainstream app models a donor-insemination event** distinct from "sex," or a **frozen-vial single-timing** mode — yet community explicitly says the 5-day-window model is wrong for thawed sperm and "there's probably nothing available."
- **No mainstream app tracks donor/vial logistics or teaches the route ladder** (home ICI/IVI → IUI → reciprocal IVF) with honest success rates.
- **Onboarding erasure is a documented, repeated churn driver** for queer and solo users — a low-cost fix competitors keep failing.
- **Nobody** combines: inclusive non-heteronormative UX + insemination/frozen-sperm timing + donor logistics + a partner-mode that fits reciprocal-IVF and co-parent and solo structures + privacy-by-design that protects against outing + Arabic-first RTL + one lifespan account. **That intersection is C13's Femio thesis.**

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources (Tier-1: NHS/MedlinePlus/NIH; Tier-2: ASRM/ESHRE/HFEA). Femio does **not** diagnose, treat, prevent, or provide legal advice; it educates, helps users track, and routes to a clinician / fertility-law professional.

**The fertile window & timing — but adapted for donor insemination:**
- The fertile window is the ~6-day interval ending on ovulation day (sperm survive ~5 days, egg ~12–24h) — this is the *natural-intercourse* model. [ASRM *Optimizing Natural Fertility*; NHS; MedlinePlus] **Critical adaptation for C13:** with **frozen–thawed donor sperm**, thawed sperm is viable only ~12–24 hours, so the relevant target narrows to **the day of the LH surge / ovulation**, not the full 6-day window. Fresh (known-donor) sperm behaves closer to the natural model (viable a few days). [Community + fertility-clinic guidance — **NEEDS SOURCE: a Tier-1/Tier-2 citation for thawed-vs-fresh sperm viability at publish**]
- **OPK/urinary LH** is the primary home-insemination timing tool; LH surge typically precedes ovulation by ~24–36h. Combining LH + CM + BBT confirmation improves accuracy. [ASRM; MedlinePlus]

**IUI (intrauterine insemination) — the clinic route:**
- In IUI, screened, "washed" donor sperm is placed directly into the uterus, timed to ovulation — either a natural cycle (tracked by LH/bloods, "usually 12–16 days before the next period") or a lightly stimulated/trigger-timed cycle. Quick (~10 min), usually mild cramping. [NHS — Intrauterine insemination]
- **Donor sperm is frozen, quarantined and screened** for infections and inherited conditions before release; UK/HFEA quarantine is a minimum of 180 days with donor re-testing. [NHS; HFEA]
- Outcomes: studies find **no significant difference in IUI-with-donor-sperm outcomes between female couples and heterosexual couples** (e.g., live-birth rates broadly comparable, ~25–30% range in cited cohorts). [PMC cohort studies — see Sources]

**Reciprocal IVF (shared / partner-assisted motherhood):**
- Eggs are retrieved from **one partner** (the genetic/egg-provider), fertilised with **donor sperm** in the lab, and the resulting embryo is transferred to **the other partner**, who carries and gives birth (the gestational/birth parent). Lets both partners have a bodily connection to the child. [HFEA — Reciprocal IVF; ASRM]
- It differs from standard IVF mainly in that the egg-provider and the carrier are two different people, which requires **cycle synchronization** between the two partners (or use of a frozen-embryo transfer to decouple timing). [HFEA; ASRM Today podcast — see Sources]

**At-home insemination (ICI / IVI) — safety:**
- Home insemination (intracervical/intravaginal) using screened bank sperm can be effective; cited community/clinic data suggest meaningful per-attempt success, though generally lower per-cycle than clinic IUI. [Clinic guidance — **NEEDS SOURCE for a Tier-1 success-rate figure at publish**]
- **Infection risk with unscreened / known-donor sperm is real:** unscreened semen can transmit HIV, hepatitis B/C, syphilis, chlamydia, gonorrhoea and others; many donors are asymptomatic. Responsible practice = documented recent full STI screen (and genetic screening), mirroring what licensed banks quarantine and test for. [NHS/HFEA on screening & quarantine; NCBI *Donor insemination* review — see Sources]

**When to seek help / step up the route (educational routing — critical for §J):**
- General TTC thresholds still apply as *awareness*: evaluate after **12 months** of trying if **<35**, **6 months** if **≥35**, and **without delay** at **≥40** or with known risk factors (irregular/absent cycles, known reproductive-tract disease). [ACOG; NHS; ASRM] **C13 nuance:** because each donor attempt is costly and time-limited, many step up from home → IUI → IVF *before* those calendar thresholds; Femio frames the ladder as options to discuss with a clinician, never a verdict.
- **Access is a right, not a diagnosis:** ASRM's Ethics Committee holds that fertility services should be available irrespective of marital status, sexual orientation, or gender identity, and that child well-being is not markedly affected by parents' orientation/marital status. [ASRM Ethics Committee opinion, 2021] Femio's tone reflects this: *needing a donor is not infertility.*

*Femio applies all thresholds and route-ladders as **educational routing**, always ending "discuss with your clinician / a fertility-law professional" — never as a diagnosis or legal opinion.*

Flagged for medical-review sign-off before ship: thawed-vs-fresh sperm viability window, home-insemination success rates, reciprocal-IVF synchronization detail, and LH-to-ovulation interval — cite live primary text at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH]** for any figure stated without a per-locale reviewed citation.

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Non-heteronormative onboarding & language** — no assumed male partner, no assumed marriage, no assumed "sex" as the conception route. Relationship, partner role, and conception method are all chosen, never presumed. Solo-by-choice is a first-class path. *(The single highest-leverage fix vs. the whole category.)*
2. **Insemination-as-event logging** — distinct event types: **at-home ICI/IVI**, **clinic IUI**, **reciprocal-IVF transfer** — replacing/augmenting the "sex" event. Sub-fields: fresh vs frozen, donor/vial reference, thaw time, provider.
3. **Frozen-sperm timing mode** — when the user marks frozen donor sperm, prediction UI shifts from a broad 6-day window to **single-point insemination guidance anchored to the LH surge / confirmed ovulation** ("aim to inseminate within ~24h of your positive OPK — thawed sperm is short-lived"). Honest, awareness-framed, never contraceptive.
4. **OPK/LH-centric timing** (inherits C1's photo-assisted OPK reading) — the dominant home-insemination trigger; plus BBT/CM cross-check to confirm ovulation and avoid wasting a vial.
5. **Route literacy hub** — plain-language explainers + honest success rates + cost/effort framing for **home insemination → IUI → reciprocal IVF → IVF**, with a "questions to ask your clinic" ladder.
6. **Flexible partner mode** — supports: (a) two-mom couple with a carrying partner + a non-carrying co-parent; (b) **reciprocal IVF** roles (egg-provider partner + carrying partner) shown correctly; (c) solo (no partner). Consent-gated, scoped, revocable, **and privacy-protective by default** (§K).
7. **Two-Week-Wait (TWW) experience** — inherits C1's DPO counter and anxiety-aware tone, adapted so cost/logistics stress is acknowledged, not amplified.

**P1 — Strong differentiators (fast follow):**
8. **Donor & vial tracker** — donor ID/bank, known-vs-bank, screening/quarantine status (informational), vials remaining, shipment/storage-tank notes. Data-minimized, user-deletable.
9. **Reciprocal-IVF understanding module + two-body timeline** — explains genetic vs gestational roles and the two-partner synchronization concept (educational; the actual protocol is the clinic's).
10. **Known-donor "what to check" checklist** — routes to (not replaces) STI/genetic screening with a clinician and a **known-donor / co-parenting agreement with a fertility-law professional** (§K). Never legal advice.
11. **Cycle history + ovulation-confirmation insights** (inherits C1) — luteal-phase length, ovulation-day variance — so she times the next vial better.
12. **Chart / cycle export (PDF/image)** for a fertility clinic when she steps up to monitored care.
13. **Preconception optimization** (inherits C1: folic acid 400 mcg, lifestyle) — for the carrying partner / gestational parent.

**P2 — Nice-to-have / later:**
14. Community or moderated Q&A, privacy-safe and queer-affirming (with strict outing protections).
15. Localized, culture-aware content variants (esp. discreet framing for restrictive markets — §K).
16. Second-parent-adoption / birth-certificate **information** signposting by jurisdiction (informational routing only).

**Explicitly OUT of scope for C13 (guardrails):**
- Any "safe days / avoid pregnancy / contraception" mode. **Never.**
- **Legal advice** on parenthood, donor rights, or custody — Femio routes to a fertility-law professional; it never states what her rights *are*.
- Diagnosis of infertility (thresholds/route-ladder *flag & route*, never diagnose — §K).
- Matching users with donors / operating as a donor marketplace (out of scope; liability + safety).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries citations, "not medical/legal advice — discuss with your clinician / a fertility-law professional," and inclusive, non-assuming language.

- **Routes to parenthood, honestly** — at-home ICI/IVI vs clinic IUI vs reciprocal IVF vs IVF: what each involves, honest success rates, cost/effort, and how people step up.
- **Timing a frozen-vial insemination** — why thawed sperm is short-lived, why the LH surge is the target, how to combine OPK + CM + BBT so a vial isn't wasted.
- **Understanding reciprocal IVF (shared motherhood)** — egg-provider vs carrier roles, why two bodies' cycles are synced, what to ask the clinic.
- **Choosing donor sperm** — bank vs known donor; screening, quarantine, ID-release vs anonymous, genetic panels.
- **Known-donor safety & agreements** — the STI/genetic screening to insist on; why a written known-donor agreement drafted with a fertility-law professional matters; that Femio can't give legal advice.
- **Legal parenthood basics (informational, jurisdiction-varying)** — why *where and how* you conceive (licensed clinic vs private arrangement) can affect legal parenthood, and why to consult a fertility-law professional. Explicitly signposts that laws differ by country/market. [HFEA general education, framed as "varies by jurisdiction"]
- **The two-week wait** (inherits C1) — adapted for the donor-cycle emotional + cost arc.
- **Preconception starter** (inherits C1) — folic acid, lifestyle — for the gestational parent.
- **You're not "infertile" — you need a donor** — de-medicalizing framing; ASRM access-as-a-right tone.
- **When to consider stepping up** — the route-ladder and 12-mo/6-mo awareness content, calm and non-alarming.
- **Reachable-but-hidden library:** full-lifespan women's-health content stays searchable so C13 is never boxed into "donor TTC only."

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception)

**Logs (inputs):**
- **Insemination events** {type: home_ICI | home_IVI | clinic_IUI | reciprocal_IVF_transfer; sperm: fresh | frozen; donor_ref; vial_ref; thaw_time; provider}, OPK/LH result + photo, CM type, BBT (with quality flags), cervical position (optional), period flow, mood/symptoms, meds/supplements, trigger-shot timing (if monitored), HPT results, donor-vial inventory.
- **Note:** an "intercourse" input is *not* assumed or required; insemination is the primary conception event.

**Tools:**
- Fertile-window estimator with a **frozen-sperm single-timing mode** (range + confidence, or narrowed to the LH-surge/ovulation target when frozen sperm is selected), coverline/thermal-shift detector, LH-progression plotter, sympto-thermal ovulation-confirmation, DPO/TWW counter, test-timing helper, cross-cycle overlay, PDF export, **donor/vial tracker**, **route-ladder explainer**, **reciprocal-IVF two-body timeline** (educational).

**Alerts / nudges (all opt-in, tone-calibrated, revocable, privacy-safe — see §K):**
- Frozen mode: *"Your OPK looks positive — thawed sperm is short-lived, so plan your insemination within about a day. This is guidance, not a guarantee."*
- Fresh/known-donor mode: window-style awareness nudge (closer to C1).
- "Time to take today's OPK / temperature."
- "Thermal shift detected — ovulation likely occurred; your window is *probably* closing."
- Partner nudge (consent-gated, role-appropriate, generic wording that doesn't disclose orientation on a lock screen).
- TWW: "It may still be too early to test — a negative now isn't conclusive."
- Preconception: folic-acid reminder (gestational parent).

**Mandatory compliance wording on every predictive/insemination surface:**
- *"Predictions are estimates based on your data — not a guarantee, and **not a method of birth control**."*
- No "safe day," "infertile day," or "you can't get pregnant today" language — **ever**.
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*
- Legal/donor surfaces: *"This is general information, not legal advice. Laws differ by country — speak with a fertility-law professional."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):** `user_id`, `dob`/`age_band`, `locale`, `rtl_pref`, consent flags, account mode/state; `cycle{period_start, period_end, cycle_length_history[], flow[]}`; `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (non-diagnostic); `content_history[]`, `screener_results[]`.

**C13 persona-specific (additive layer; surfaced or hidden, never destroyed):**
- `ttc_start_date` (drives awareness-clock, but route-ladder often steps up before it).
- `conception_route` {home_ICI | home_IVI | clinic_IUI | reciprocal_IVF | ivf}, mutable over time (records the step-up ladder).
- `family_structure` {same_sex_couple | solo_by_choice | other_no_sperm_partner} — self-selected, never inferred.
- `partner_role_model` {carrying_partner, non_carrying_coparent} OR reciprocal-IVF {egg_provider_partner, carrying_partner} OR none — drives partner-mode display.
- `insemination_log[]` {type, sperm_fresh_or_frozen, donor_ref, vial_ref, thaw_time, provider, timestamp}.
- `donor[]` {donor_type: bank | known, bank_name?, screening_status (informational), id_release_pref?, genetic_panel_note?, vials_remaining, storage_note} — **data-minimized, user-deletable, never shared**.
- `opk_results[]`, `bbt_readings[]`, `cm_log[]`, `ovulation_confirmed[]`, `coverline[]`, `luteal_phase_length[]`, `dpo_current`, `hpt_results[]` (inherited from C1).
- `reciprocal_ivf{egg_provider_user_ref, carrier_user_ref, sync_stage_note}` (educational/logistics only — not a clinical protocol).
- `predicted_window[]` {start, end, confidence} **plus** `frozen_timing_target` {date, confidence} when frozen sperm selected.
- `partner_link_id`, `partner_scope`, `partner_consent_ts` (role-aware; may be null for solo).
- `preconception_checklist_state`, `folic_acid_start_date` (gestational parent).
- `legal_info_ack` (records she was shown "info-not-advice / see a fertility-law professional" — no legal content stored as advice).

*Data-minimization: donor identity, vial photos/IDs, and family-structure fields collected only as needed, encrypted, strict retention, user-deletable. These are high-sensitivity outing-risk fields (§K).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C13) — inclusive by construction:**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "How are you trying / planning to conceive?" → neutral multi-choice incl. **"With donor sperm (at-home)," "With donor sperm (clinic / IUI)," "Reciprocal IVF / shared motherhood," "IVF," "Not sure yet."** *(No "with my husband" default; "sex with a partner" is one option among several, not the frame.)* → sets `conception_route`.
3. "Who's involved?" → **"Just me," "Me and a partner," "Me and a partner — we're both involved in carrying/genetics (reciprocal IVF)."** → sets `family_structure` + `partner_role_model`. Never asks partner's gender to gate anything.
4. "Are you using a sperm bank or a known donor?" (optional, skippable) → sets `donor.donor_type`, unlocks donor/vial tracker + relevant safety content.
5. Age capture → sets awareness thresholds + tone (not a gate).
6. "How do you want to track?" (OPK / BBT / CM / insemination-only / minimal) → enables chosen logs; others reachable.
7. Consent & privacy choices — **including an explicit "discreet mode / who can see this device" step** given outing risk.

**Home config for C13:**
- Hero = **route-aware timing card.** Frozen-donor route → *frozen-sperm single-timing* card (LH-anchored, "plan your insemination" action). Fresh/known-donor → window-style card. Reciprocal-IVF → two-body timeline + next-clinic-step card.
- Quick-log row = OPK / BBT / CM / **Insemination** (not "sex").
- Secondary = donor/vial tracker, route-ladder explainer, TWW/DPO card post-insemination, preconception checklist (gestational parent), relevant content.
- Partner strip = role-appropriate (co-parent view, reciprocal-IVF two-role view, or hidden for solo).
- **Hidden-but-reachable:** full lifespan library, contraception *education*, condition pages, perimenopause — one tap away. C13 is configured, not walled in.

**Adaptive tone:** affirming, logistics-competent, de-medicalizing ("you need a donor, not a diagnosis"); cost/effort-aware without pity; escalates to *validating + route-ladder* framing as cycles/vials accumulate — never alarmist, never toxic-positive.

---

## J. Adaptation triggers (state transitions)

> Inherits all **universal events** from `09_MASTER_ADAPTATION_MODEL.md §6` (positive test → Pregnancy carrying modifiers; loss → instant suppression + Gentle Mode + grief; mood-screen high → crisis path; red-flag → seek-care box; break → pause; toggle-off → generic; age-of-consent → re-confirm). Only **C13-specific** transitions below.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **Steps up to monitored treatment (IUI / IVF / reciprocal IVF)** | user sets/updates `conception_route` to clinic_IUI / ivf / reciprocal_IVF, or logs clinic monitoring/trigger | Switch home to treatment-cycle support (monitoring log, trigger-timing, transfer date, two-week-wait); keep donor/vial + cycle history; re-confirm privacy scope | **→ C10** (IUI/IVF treatment persona), carrying C13's donor + family-structure modifiers |
| **Positive pregnancy test** | `hpt_results` = positive / user confirms | Universal celebrate-and-switch; **carry donor record, conception_route, and family-structure/legal-info context** into Pregnancy; surface early-pregnancy content (continue folic acid) + a **"legal parenthood / birth-registration — see a fertility-law professional"** info card; suppress fertile-window/insemination surfaces | → Pregnancy (D-track) with donor-conception + family-structure modifiers |
| **Reciprocal-IVF role clarified** | user sets `egg_provider_partner` vs `carrying_partner` | Configure two-body timeline; ensure the **carrying** partner gets gestational-parent preconception content; both partners' involvement reflected in partner mode | Stay C13 (reciprocal-IVF sub-mode) → C10 on cycle start |
| **Known-donor selected** | `donor.donor_type = known` | Surface known-donor **safety checklist** (STI/genetic screening) + **known-donor-agreement / legal-info** routing (info, not advice); never assume co-parenting intent | Stay + safety/legal content |
| **Vial / cycle exhausted without conception** | vials_remaining = 0 or repeated negative timed cycles | Calm, non-diagnostic route-ladder card: "It can be worth talking to a clinic about next options (IUI/IVF)"; offer export; **never** auto-label "infertile" | → C10 / clinician routing (educational) |
| **12 mo (<35) / 6 mo (≥35) of trying** | awareness clock crosses threshold | Same calm route-ladder framing as C1, adapted to donor context | → C10 / clinician (educational, not diagnosis) |
| **Pregnancy loss reported** | user reports loss | Universal instant-suppression + Gentle Mode + grief resources; retain donor/vial + cycle data; offer **RPL / Pregnancy-After-Loss (PAL)** pathway when/if she returns | → E6 grief, later optional C5 (RPL) / D2 (PAL) |
| **Privacy/outing-risk context detected** (restrictive market or user enables discreet mode) | locale flag or user setting | Tighten default sharing to minimum; generic notification wording; hide orientation/donor labels from any surface a third party could see | Stay, privacy-hardened |

*All routes preserve data continuity (one account), protect against outing, and always end with clinician / fertility-law-professional routing — never a diagnosis or legal opinion.*

---

## K. Compliance flags

1. **Inclusive, non-assuming language (persona-defining guardrail).** Never presume a male partner, marriage, "sex" as the conception route, a known donor, or an anonymous donor. Relationship, partner role, donor type, and method are **always user-selected, never inferred.** Solo-by-choice and both reciprocal-IVF roles are first-class. Onboarding erasure is a documented churn driver — treat inclusive copy as a P0 compliance item, reviewed in all four locales incl. AR/RTL.
2. **Regional legal & cultural sensitivity (MENA and beyond).** Donor conception and same-sex family-building are **legally restricted and/or socially unsafe** in several Femio markets; under mainstream Sunni jurisprudence and OIC Fiqh-Academy positions, third-party gamete donation is impermissible, and some markets criminalize same-sex relationships. Femio must: (a) present donor-conception content **neutrally and without judgement**, as education not endorsement/prescription; (b) **never out a user** via UI, notifications, marketing, or partner-sharing defaults; (c) offer a **discreet mode** and generic notification wording; (d) avoid pushing donor-conception features to users in markets where surfacing them could create legal/social risk — surface on request, don't force. Femio takes **no moral position**; it neither promotes nor condemns, and routes value-laden questions to the user's own clinician/community/faith leader. **[NEEDS SOURCE — per-market legal review before any AR/MENA launch of donor-conception content.]**
3. **Donor data handling (high-sensitivity, outing-risk).** Donor identity, vial IDs/photos, known-donor details, and family-structure fields are **special-category + outing-risk** data: explicit granular consent, encryption, strict retention, user-deletable, **never** shared with ad networks/analytics (learn from **Flo FTC 2021**, **Premom FTC 2023**), employers, insurers, or the state. Partner-sharing is scoped, revocable, and defaults to non-disclosing. Data-residency considered per market. Do **not** operate as a donor-matching marketplace.
4. **Not legal advice.** Legal parenthood, donor rights, second-parent adoption, and birth registration **vary by jurisdiction** and change over time. Femio provides **general information only**, always ending "laws differ by country — speak with a fertility-law professional." Never state what her rights are.
5. **Not contraception.** Insemination-timing and frozen-sperm mode are conception-awareness only; ban "safe/infertile day" language; every predictive surface carries "not a method of birth control." Keeps Femio out of the regulated contraceptive-device lane. **[NEEDS SOURCE — confirm app-store medical-claims + FTC health-claims wording at ship.]**
6. **No diagnosis / treatment / prevention.** "You need a donor" is not an infertility diagnosis. The route-ladder and 12-mo/6-mo thresholds are *educational routing*, not verdicts. Known-donor safety content routes to clinician screening; it does not clear anyone as safe.
7. **Uncertainty honesty.** Frozen-sperm single-timing guidance still displays confidence and "estimate, not a guarantee"; no false precision on ovulation day.
8. **Emotional safety + minority stress.** Donor-cycle grief is compounded by cost and, often, minority stress and reduced family support; tone avoids both doom and toxic positivity; loss handled with grief-aware UX. Crisis resources on any high mood-screen. **[NEEDS SOURCE — minority-stress-in-TTC citation.]**
9. **Medical review + citations.** All clinical content medically reviewed, cited to Tier-1 (NHS/MedlinePlus/NIH) + Tier-2 (ASRM/ESHRE/HFEA), grade 6–8, localized in 4 languages with RTL parity. Numeric claims (thawed-sperm viability, home-insemination success, IUI outcomes, LH-to-ovulation interval, reciprocal-IVF sync) re-verified at publish. **[NEEDS SOURCE VERIFICATION AT PUBLISH]**
10. **App-store health-app policy.** Meet Apple/Google health-app & medical-disclaimer requirements; no over-claiming. **[NEEDS SOURCE — map to current store policies at submission.]**

---

## Sources

**Tier-1 (NHS / MedlinePlus / NIH):**
- [NHS — Intrauterine insemination (IUI)](https://www.nhs.uk/tests-and-treatments/intrauterine-insemination-iui/)
- [NHS inform (Scotland) — Intrauterine insemination (IUI)](https://www.nhsinform.scot/tests-and-treatments/surgical-procedures/intrauterine-insemination-iui/)
- [MedlinePlus — Pregnancy: Identifying Fertile Days](https://medlineplus.gov/ency/article/007015.htm)
- [NCBI Bookshelf (NICE/Fertility guideline) — Donor insemination](https://www.ncbi.nlm.nih.gov/books/NBK45921/)
- [PMC — Pregnancy success rates for lesbian women undergoing IUI](https://pmc.ncbi.nlm.nih.gov/articles/PMC8441558/)
- [PMC — IUI success rates using donor sperm: heterosexual vs female couples (cohort)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12694971/)
- [PMC — Impact of cryopreserved sperm on IUI outcomes (frozen vs fresh)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10264626/)
- [PMC — Laboring to Conceive: reducing barriers to fertility care for same-sex mothers](https://pmc.ncbi.nlm.nih.gov/articles/PMC10702875/)

**Tier-2 (ASRM / ESHRE / HFEA):**
- [HFEA — Reciprocal IVF](https://www.hfea.gov.uk/treatments/explore-all-treatments/reciprocal-ivf/)
- [HFEA — Legal implications of using donated sperm](https://www.hfea.gov.uk/treatments/explore-all-treatments/using-donated-eggs-sperm-or-embryos-in-treatment/legal-implications-of-using-donated-sperm/)
- [HFEA — Becoming the legal parents of your child](https://www.hfea.gov.uk/treatments/explore-all-treatments/becoming-the-legal-parents-of-your-child/)
- [HFEA — FAQs relating to unregulated (known-donor) sperm donation](https://www.hfea.gov.uk/about-us/media-centre/faqs-relating-to-unregulated-sperm-donation)
- [ASRM — Access to fertility treatment irrespective of marital status, sexual orientation, or gender identity: Ethics Committee opinion (2021)](https://www.asrm.org/practice-guidance/ethics-opinions/access-to-fertility-treatment-irrespective-of-marital-status-sexual-orientation-or-gender-identity-an-ethics-committee-opinion-2021/)
- [ASRM — Access to fertility services by transgender and nonbinary persons: Ethics Committee opinion (2021)](https://www.asrm.org/practice-guidance/ethics-opinions/access-to-fertility-services-by-transgender-and-nonbinary-persons-an-ethics-committee-opinion-2021/)
- [ASRM Today — Reciprocal IVF (podcast)](https://www.asrm.org/news-and-events/podcasts/asrm-today/asrm-today-reciprocal-ivf/)
- [ASRM — Optimizing Natural Fertility: A Committee Opinion](https://www.asrm.org/practice-guidance/practice-committee-documents/optimizing-natural-fertility-a-committee-opinion-2021/) *(fertile-window biology, inherited from C1)*
- [ACOG — Trying to Get Pregnant? Here's When to Have Sex](https://www.acog.org/womens-health/experts-and-stories/the-latest/trying-to-get-pregnant-heres-when-to-have-sex) *(timing thresholds, inherited)*

**Inclusivity / whitespace evidence (community + critique — synthesized as aggregate voice-of-user):**
- [Medium — Maggie Delano, "I tried tracking my period and it was even worse than I could have imagined"](https://medium.com/@maggied/i-tried-tracking-my-period-and-it-was-even-worse-than-i-could-have-imagined-bb46f869f45) *(male-only partner logging; queer erasure)*
- [Our Bodies Ourselves — Period Tracking Apps: The Good and the Bad](https://ourbodiesourselves.org/blog/period-tracking-apps-the-good-and-the-bad)
- [VICE — The Strange Sexism of Period Apps](https://www.vice.com/en/article/the-strange-sexism-of-period-apps/)
- [Autostraddle — Apps to Track and Predict Your Period (queer-user lens)](https://www.autostraddle.com/5-apps-to-track-and-predict-your-period-and-more-265766/)
- [Taylor & Francis — "A fertility app for two?" Women's perspectives on sharing conceptive work with partners](https://www.tandfonline.com/doi/full/10.1080/13691058.2021.2002414)
- [Clue — LGBTQIA+ content hub](https://helloclue.com/articles/lgbtqia)
- [FertilityIQ — Selecting Sperm Donors (lesbian family-building)](https://www.fertilityiq.com/fertilityiq/lesbian-women-becoming-moms/selecting-sperm-donors)

**Regional / cultural context (MENA / Islamic jurisprudence — for sensitivity framing, not endorsement):**
- [NCBI Bookshelf — Assisted Reproductive Technology: Islamic Perspective (Contemporary Bioethics)](https://www.ncbi.nlm.nih.gov/books/NBK500175/)
- [PMC — Making Muslim babies: IVF and gamete donation in Sunni vs Shi'a Islam](https://pmc.ncbi.nlm.nih.gov/articles/PMC1705533/)
- [PMC — Religious aspects of assisted reproduction](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5096425/)

**Legal-logistics (informational only — Femio does not give legal advice):**
- [Klein Fertility Law — Understanding Sperm Donor Contracts / known-donor agreements](https://www.kleinfertilitylaw.com/sperm-donor-lawyer/sperm-donor-contracts)
- [PMC — Paternity Law: Sperm Donors, Surrogate Mothers and Child Custody](https://pmc.ncbi.nlm.nih.gov/articles/PMC6170122/)

*Community insight (r/queerception, r/lesbianTTC, r/QueerTTC, FertilityIQ, app-store/forum critique) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. FTC actions vs. Flo (2021) and Premom (2023) referenced via C1's privacy sources; verify against primary FTC press releases at implementation. **[NEEDS SOURCE — FTC primary docs; per-market MENA legal review; Tier-1/2 citations for thawed-vs-fresh sperm viability, home-insemination success rates, and minority-stress-in-TTC].**
