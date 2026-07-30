# C11 — TTC After Stopping Contraception (Pill / IUD / Implant / Injection)

> Femio persona spec. Scope guardrail: **wellness / education / tracking only.** Fertile-window features support **conception awareness**, and are **explicitly NOT contraception / birth control**. Femio never diagnoses, treats, prevents, or contracepts. Screeners are framed as *"screening — discuss results with a clinician."*
> Persona code: **C11** · Cohort: Conception (C) · Last research pass: 2026-07-17

---

## A. Persona snapshot

| Field | Value |
|---|---|
| **Name (composite)** | "Layla," 30 |
| **Age band** | ~24–37. Most below the 35 help-seeking threshold; a meaningful minority ≥35 who feel time pressure *and* just stopped a long-acting method. |
| **Stage** | Just stopped (or about to stop) hormonal/LARC contraception to start trying. Cycle 0–6 post-stop. No diagnosed fertility problem. |
| **Method just left** | Combined pill / POP, hormonal or copper IUD, implant (Nexplanon), or the injection (Depo-Provera / Sayana Press). The **method she came off** is the single most important routing signal in this persona. |
| **Relationship** | Usually partnered; often a deliberate, planned "we've decided" moment. Partner engagement variable. |
| **Goal (top JTBD)** | *"I've spent years preventing pregnancy — now how do I flip the switch? When will my cycle come back, is my fertility ok after all this time, and how do I actually start tracking?"* |
| **Health literacy** | Moderate–high but carrying **contraception-era myths** ("the pill made me infertile," "I need to detox/cleanse first," "wait 3 months for the hormones to clear"). Actively Googling; vulnerable to fear-content. |
| **Tech context** | Web-first; likely already has a period tracker she used in *contraception/reminder* mode and needs to re-point at conception. |
| **Locale** | AR-first / RTL first-class; also EN/FR/ES. Modesty/privacy sensitivity high in AR markets; contraception history can be socially sensitive. |
| **Emotional state** | Excited + a specific, distinctive **anxiety about the unknown re-entry**: "is my body still working?" Amplified for Depo users who get *no period at all* for months and read that as failure. |
| **What she is NOT (yet)** | Not infertile. Not "late." A post-stop absent/irregular cycle is **expected recovery**, not a red flag — mislabeling it is the core trust-breaker. |
| **Primary devices for signals** | Often starting from zero on tracking hardware. Will adopt OPK/LH strips, BBT thermometer, CM observation as Femio teaches them. |
| **Success = leaves us because…** | Her cycle returned and she flowed into C1 (general TTC), OR she conceived (→ Pregnancy), OR the method-specific window elapsed with no cycle return and we routed her, calmly, to a clinician. |

**Persona thesis.** C11 is the **on-ramp to the entire conception cohort** — the moment a contraception-mindset user becomes a conception-mindset user. Her defining problem is not "which days are fertile" (that's C1); it is **"what happens to my body now that the hormones are gone, and is it normal?"** She needs (1) myth-correction ("post-pill infertility" is not real; no detox needed), (2) honest, **method-specific** expectations (no clinically important delay described after pill/IUD/implant use; DMPA can delay return for up to about one year), and (3) a gentle handoff into real tracking. Get the *recovery-is-normal* framing right and she trusts Femio for the whole journey. Get it wrong — show a "your period is late" counter to a woman 4 months off DMPA — and you manufacture panic and churn. **Once her cycle resumes and she's in a normal TTC rhythm, C11 dissolves into C1.**

---

## B. Needs & questions (voice-of-user)

Mined from r/TryingForABaby, r/birthcontrol, r/Depo, TTC forums, and app-store reviews. Phrasing is representative/composite (community norms; not quoting individuals).

**The core JTBD (post-contraception re-entry):**
1. *"I just stopped the pill / had my IUD out / stopped Depo — how long until my period comes back?"*
2. *"Did years of birth control ruin my fertility? Is 'post-pill infertility' a real thing?"* (the #1 fear)
3. *"Do I need to wait / detox / let the hormones clear before trying?"* (widespread myth)
4. *"It's been [X] months off Depo and still no period — is something wrong with me?"* (Depo-specific distress)
5. *"My cycles are all over the place since stopping — is that normal or a problem?"*
6. *"Can I get pregnant before my first real period comes back?"* (yes — ovulation precedes the bleed)
7. *"I never tracked before because I was ON birth control — how do I even start? What's an OPK?"*
8. *"When does the folic acid start — now, or once my cycle is back?"* (answer: now)
9. *"My periods were irregular *before* I ever went on the pill — will they just go back to that?"*
10. *"When should I actually be worried and see a doctor?"* (method-aware routing)

**Emotional arc (this persona's distinctive shape):**
- **Decision / stop moment:** relief + excitement — "we're really doing this."
- **The waiting-for-return limbo:** the acute pain point unique to C11. No cycle yet = no data = no window to track = *"am I even working?"* Worst for Depo (months of amenorrhea) and for anyone whose bleed is slow to return.
- **First cycle back:** relief and a pivot — now she becomes a normal TTC user (→ C1 arc: window, TWW, etc.).
- **If return is slow:** creeping fear of infertility, heavily fed by internet horror stories, especially Depo forums.

**Anti-needs / trust-breakers (what makes her churn):**
- A **"your period is late / X days late" counter** during expected post-stop recovery — reads as failure/alarm when the app should say *"this is expected."*
- Reinforcing the **"post-pill infertility" myth** or implying she damaged her fertility.
- Suggesting a **"detox," "cleanse," or mandatory wait** before trying (no evidence; contradicts guidance).
- Being pushed into **infertility/IVF framing** during a normal Depo return window.
- Any hint the fertile-window feature is or was **contraception** ("safe days") — especially jarring for someone leaving actual contraception.
- Treating all methods the same (telling an implant user to expect the Depo delay, or vice-versa) — she can tell, and it destroys credibility.

**Feature requests recurring in reviews/forums:**
- A **method-specific "what to expect" timeline** ("you stopped Depo on [date] — here's the honest range").
- Reassurance content that is **calm and cited**, not fear-bait.
- A gentle **"switch from preventing to trying"** flow (re-point the tracker, turn off pill reminders, turn on conception awareness).
- A **"getting started with tracking"** onboarding for people who never charted before.
- Honesty that **ovulation can happen before the first period**, so tracking should start now.

---

## C. Competitor teardown

The key gap: most competitors treat "TTC" as beginning at a *regular cycle*. Almost none own the **post-contraception transition** — the limbo between stopping a method and having a trackable cycle — with method-specific, myth-correcting, uncertainty-honest content. That transition is C11's Femio thesis.

| App | Post-stop transition content | Method-specific timelines | Myth-correction ("post-pill infertility"/detox) | "Preventing→trying" mode switch | Depo-amenorrhea handling | Notable posture |
|---|---|---|---|---|---|---|
| **Flo** | Has articles ("what happens after stopping birth control," "ovulation after stopping the pill") | Partial — pill vs IUD vs shot noted in content, weakly in-product | Yes in blog ("no need to detox") | Log birth-control method; switch to TTC goal | Weak — generic tracker can still show "late" states | Huge reach, shallow in-product transition logic; FTC 2021 settlement (data to Facebook/Google), added Anonymous Mode. |
| **Clue** | Good science-comms articles on stopping hormonal contraception | Partial, content-level | Yes, well-written | Goal switch | Content acknowledges post-Depo delay | Strong privacy posture; less TTC-signal depth; transition handled as content not as an adaptive state. |
| **Natural Cycles** | Onboarding explicitly asks about hormonal-contraception recent use (their algo needs cleared cycles) | Yes — but for the **contraception/planning** (regulated) posture Femio avoids | Implicit | N/A (device is the method) | Excludes/flags disrupted cycles | FDA-cleared *contraceptive*; **out of Femio scope**. |
| **Premom / Fertility Friend / Kindara** | Minimal transition framing; assume a cycle exists to chart | No | No | No | Poor — charting tools flounder with no ovulation yet | Deep signal tools, but they start *after* the cycle returns — i.e. they begin where C11 ends. |
| **Ovia Fertility** | Some "getting started / off birth control" content | Light | Some | Goal switch | Light | Employer channel; generous free tier. |
| **NHS / clinic leaflets** | **Best clinical content** (method-by-method return-of-fertility, Depo up-to-1-year) | **Yes, authoritative** | Yes, explicit | N/A | Explicit | Trustworthy but static, not a tracker, not personalized, not AR-first. |

**Fragmentation map (the opening for Femio):**
- **Authoritative method-specific timelines** live in NHS/clinic leaflets — static, impersonal, not tracked.
- **Tracking depth** lives in Premom/Fertility Friend/Kindara — but they *presume a cycle already exists*.
- **Reach + some transition content** live in Flo/Clue — but the "preventing→trying" moment is treated as an article, not an **adaptive in-product state** with a personalized, method-anchored, uncertainty-honest recovery timeline and myth-correction.
- **Nobody** combines: a method-specific honest recovery timeline + active myth-correction + a graceful "no cycle yet, and that's expected" tracking-degradation + a clean handoff into full C1 TTC + trustworthy privacy + Arabic-first RTL + one account that keeps all other women's-health knowledge reachable. **That gap is C11's Femio thesis.**

---

## D. Clinical grounding (cited)

> All claims below are patient-education framing. Femio content is medically reviewed and cites primary sources. Femio does **not** diagnose, treat, prevent, or contracept; it educates and helps users track.

**"Post-pill / post-contraception infertility" — myth vs reality (the anchor teaching):**
- **Reversible contraception does not cause long-term infertility.** A systematic review/meta-analysis found the pooled 12-month pregnancy rate after discontinuing contraception was **83.1%** (95% CI 78.2–88.0), and this was **not significantly different** between hormonal methods and IUDs; contraceptive use — regardless of type or duration — **does not have a lasting negative effect on the ability to conceive**. [Girum & Wasie, *Contracept Reprod Med* 2018 (PMC6055351)]
- **No "detox," "cleanse," or mandatory waiting period** is needed before trying; you can conceive as soon as you stop. Historic advice to "wait a few months" is **not** evidence-based. [NHS; Flo Health]
- Prior duration of use is **not** a predictor of future infertility. [Girum & Wasie 2018; general clinical consensus]

**Return of cycles/fertility BY METHOD (the routing backbone — critical for §J):**
- **Combined/progestogen pill, IUD/IUS, and implant:** FSRH guidance does not describe a clinically important delay in return of fertility after stopping or removal. Ovulation can occur before the first period, so Femio does not make the first bleed a prerequisite for trying. ([FSRH — Contraception for Young People, 2019](https://www.fsrh.org/Common/Uploaded%20files/documents/fsrh-guideline-contraception-young-people-may-2019.pdf))
- **Injection (DMPA):** return of fertility can be delayed and may take up to about one year after discontinuation. Timing varies, and this delay is not evidence of permanent infertility. Femio does not publish the unsupported 18-month/2-year extension, conception percentages, or a median ovulation date. ([FSRH injectable guideline, amended July 2023](https://www.fsrh.org/Common/Uploaded%20files/documents/progestogen-only-injectable-december-2014-amended-11july2023.pdf); [NHS](https://www.nhs.uk/contraception/methods-of-contraception/contraceptive-injection/what-is-it/))

**Starting to try — what to do NOW (in scope):**
- **Start folic acid 400 micrograms daily when you begin trying**, through 12 weeks of gestation; do not wait for the first period. Higher-dose regimens are clinician-directed. ([WHO](https://www.who.int/tools/elena/interventions/folate-periconceptional))
- Because **ovulation precedes the first bleed**, begin conception-awareness tracking (CM ± OPK/LH ± BBT) **now**, not after the period returns. [MedlinePlus; ASRM — Optimizing Natural Fertility]
- Cervical mucus is especially useful when cycles have not yet regularized (no calendar history to anchor a prediction). [ASRM; NHS]

**WHEN to seek help (method-aware routing — critical for §J):**
- Standard TTC thresholds still apply once cycles have returned: evaluate after **12 months** (<35 y) or **6 months** (≥35 y) of regular unprotected intercourse; **≥40 y** consider evaluation without delay. [ACOG; ASRM; NHS]
- **No-cycle-return watch:** Femio does not create a method-specific diagnostic deadline. It routes persistent absent bleeding or concern to a clinician and applies the general amenorrhea criteria in [`MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md), while explaining that DMPA can delay return for up to about one year.

*Femio applies all thresholds as **educational routing**, always ending "discuss with your clinician" — never as a diagnosis.*

**Medical-source resolution.** Unsupported DMPA percentages/median and 18-month/2-year wording are excluded; pill timing is qualitative; the folic-acid recommendation matches WHO. See [`CONTRACEPTION_SAFETY.md`](../compliance/CONTRACEPTION_SAFETY.md). *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the persona; ship first):**
1. **Method-anchored "what to expect" recovery timeline** — user enters *which method* and *stop/removal/last-injection date*; Femio gives the cited qualitative guidance for that method, never a promised bleed, ovulation, or conception date.
2. **Myth-correction module, front and center** — "post-pill infertility isn't real," "no detox/wait needed," "you can conceive before your first period," cited and calm. This is the persona's signature content and must be unmissable in onboarding.
3. **"Recovery-is-expected" cycle UI** — when no cycle has returned yet, prediction UI **degrades gracefully to trend + "this is expected for your method"**; **never** shows a "period late / X days late" counter (per adaptation-model invariant #5).
4. **"Preventing → trying" switch flow** — one guided step that turns **off** any contraception/pill-reminder framing and turns **on** conception-awareness tracking + folic-acid reminder; re-confirms privacy scope for the new (conception) data class.
5. **"Start tracking from zero" onboarding** — for users who never charted (because they were on contraception): teaches CM first (works without cycle history), then OPK/LH and BBT; light and non-intimidating.
6. **Immediate preconception starter** — folic-acid 400 mcg reminder begins at "we're trying," not at first period.
7. **"When to talk to a clinician" routing card** — uses the general amenorrhea criteria, symptoms, and user concern rather than an unsupported method-specific countdown.

**P1 — Strong differentiators (fast follow):**
8. **Depo-specific companion track** — because Depo is the hard case: a longer, reassurance-forward timeline, "no period yet is normal here," and *no* premature infertility framing before ~12 months.
9. **Bridge into C1 tooling** — once a cycle returns, auto-offer the full C1 fertile-window + BBT/OPK/CM + TWW stack (this is the C11→C1 handoff).
10. **"Was your cycle irregular *before* contraception?"** capture — sets honest expectations that pre-existing irregularity (e.g. PCOS-adjacent) may re-emerge, and soft-routes to relevant content without labeling.
11. **Partner mode** (inherited from C1) — window + "today" nudges once tracking is live; consent-gated, revocable.
12. **Chart/timeline export (PDF/image)** — hand to a clinician *if/when* the method window elapses.

**P2 — Nice-to-have / later:**
13. Community / moderated Q&A (privacy-safe) — post-Depo cohort especially seeks peer reassurance.
14. Localized coaching by market (AR modesty-aware framing; contraception history is sensitive).
15. Custom trackables for the transition (spotting, breakthrough bleeding patterns).

**Explicitly OUT of scope for C11 (guardrail):**
- Any "safe days / avoid pregnancy / contraception" mode — **never**, and especially not for a user literally leaving contraception.
- No advice to **stop, continue, restart, or change** a contraceptive method (that's a clinician decision) — Femio educates on *what to expect after* a decision she has made.
- No diagnosis of anovulation/PCOS/infertility (screeners may *flag & route*, never diagnose — §K).

---

## F. Content modules

Medically reviewed, referenced, grade 6–8 reading level, all four locales, RTL-first for AR. Each card carries citations and "not medical advice / discuss with your clinician."

- **"Does birth control cause infertility?"** — the myth-buster: reversible contraception has **no long-term effect** on fertility; no detox/wait needed. (Anchor card.)
- **"When will my cycle come back?" — by method** — one card per method (pill, IUD, implant, injection) with the honest return range. Depo card is the longest and most reassuring.
- **"The DMPA timeline, honestly"** — dedicated: why the injection is different, that return can be delayed for up to about one year, and that individual timing varies.
- **"You can get pregnant before your first period"** — why ovulation comes first, so start folic acid + tracking now.
- **"Starting to track from scratch"** — CM-first primer for never-tracked users, then OPK and BBT (links to C1's CM-101/OPK-101/BBT-101).
- **"Preconception starter"** — folic acid 400 mcg now, lifestyle, caffeine/alcohol (shared with C1, cited).
- **"Were your periods irregular before birth control?"** — expectations-setting on pre-existing patterns re-emerging.
- **"When to consider seeing a clinician"** — method-aware routing content, calm and non-alarming.
- **Reachable-but-hidden library:** full-lifespan women's-health content — including **contraception *education*** (she's just left a method and may have questions), gynae conditions, PCOS, perimenopause — stays searchable so C11 never feels boxed into "TTC only."

---

## G. Tools, logs & alerts (compliant framing — awareness, not contraception)

**Logs (inputs):**
- `contraception_method_stopped` + `stop_date` (the anchor), spotting/breakthrough bleeding, period flow (when it returns), CM, OPK/LH (+ photo), BBT, intercourse, mood/symptoms, meds/supplements, HPT results.

**Tools:**
- Method-anchored recovery-timeline estimator (range + confidence), "cycle not returned yet" trend view (no late-counter), CM-first ovulation-awareness helper, folic-acid tracker, method-aware clinician-routing card, then the full C1 stack (fertile-window estimator, coverline/thermal-shift, LH plotter, DPO/TWW counter) **unlocked on first confirmed cycle**.

**Alerts / nudges (all opt-in, tone-calibrated, revocable):**
- "You stopped [method] on [date]. For this method, cycles usually return [honest range]. We'll track it with you." (awareness, method-specific)
- "It's normal not to have a period yet after [method] — this can take time, especially after the injection." (Depo-aware reassurance; **replaces** any "late" nudge)
- "Start taking 400 mcg folic acid daily now — no need to wait for your period." (cited)
- "Your first cycle is here — want to turn on full fertile-window tracking?" (C11→C1 handoff)
- Method-window routing: "It's been [X] since you stopped [method]. If your period hasn't returned, it can be worth talking to a clinician." (non-diagnostic)

**Mandatory compliance wording on every predictive/timeline surface:**
- *"These are estimates based on your method and your data — not a guarantee, and **not a method of birth control**."*
- **No "late" / "overdue" language** during the expected post-stop recovery window.
- No "safe day," "infertile day," or "you can't get pregnant today" language — **ever**.
- Screener outputs: *"This is a screening tool, not a diagnosis. Please discuss results with a clinician."*

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across all Femio personas — the one-account spine):**
- `user_id`, `dob` / `age_band`, `locale`, `rtl_pref`, consent flags (`data_use`, `partner_share`, `notifications`), account mode/state.
- `cycle`: `period_start`, `period_end`, `cycle_length_history[]`, `flow[]`.
- `symptoms[]`, `mood[]`, `meds_supplements[]`, `conditions_flagged[]` (from screeners, non-diagnostic).
- `content_history[]`, `screener_results[]` (timestamped + "non-diagnostic" tag).

**C11 persona-specific:**
- `contraception_method_stopped` {pill_combined | pill_pop | iud_hormonal | iud_copper | implant | injection}.
- `contraception_stop_date` (removal / last-pill / last-injection date — the routing anchor).
- `expected_return_window[]` {method, range_start, range_end, confidence} — stored explicitly, method-derived.
- `first_cycle_returned` {bool, date} — the **C11→C1 handoff trigger**.
- `pre_contraception_cycle_regularity` (self-report: regular / irregular / unknown).
- `folic_acid_start_date`.
- `cm_log[]`, `opk_results[]`, `bbt_readings[]`, `intercourse_log[]`, `hpt_results[]` (shared with C1; activated at "start tracking").
- `ttc_start_date` (inherited; the standard 12-/6-mo clock begins once cycles are regular — see §J).
- `predicted_window[]` {start, end, confidence} — populated after cycle return.

*Data-minimization: contraception history is sensitive (see §K); collect only what powers the recovery timeline + routing, with strict retention and user-deletability.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard (branch into C11):**
1. "What brings you to Femio?" → *Trying to conceive.*
2. "Have you recently stopped, or are you about to stop, birth control?" → **yes → C11 branch** (else → C1).
3. "Which method?" → sets `contraception_method_stopped` (drives the whole timeline + routing).
4. "When did you stop / have it removed / have your last injection?" → sets `contraception_stop_date`.
5. **Immediate myth-correction interstitial** — "Good news first: reversible birth control doesn't harm long-term fertility, and you don't need to detox or wait." (cited; defuses the #1 fear up front.)
6. "Were your periods regular *before* you started birth control?" → sets `pre_contraception_cycle_regularity`, soft-routes expectations.
7. Age capture → sets 12-/6-mo threshold and tone (applies once cycles return).
8. "Have you tracked ovulation before?" → if no, enables the **start-from-zero** CM-first onboarding.
9. "Involve a partner?" → partner-mode setup or defer.
10. Consent & privacy choices (re-confirm the new conception data class).

**Home config for C11 (two phases):**
- **Phase 1 — pre-cycle-return (the C11-defining state):** Hero = **method-anchored recovery timeline** ("you stopped [method] on [date] — here's the honest range") + folic-acid reminder + myth-correction card. Cycle UI shows **trend + "this is expected," never a late-counter.** Quick-log = CM + spotting + (optional) OPK.
- **Phase 2 — post-cycle-return:** on `first_cycle_returned`, **offer the C1 home** (fertile-window hero + BBT/OPK/CM quick-log + TWW). This is the handoff.
- **Hidden-but-reachable:** full lifespan library, contraception *education*, condition pages, perimenopause — one search/tap away.

**Adaptive tone:** reassuring + normalizing throughout Phase 1 (especially Depo); shifts to standard C1 optimism/validation in Phase 2. Never alarmist, never "your body is failing," never toxic-positive.

---

## J. Adaptation triggers (state transitions)

> Inherits all **universal events** from the Master Adaptation Model §6 (positive test, loss, mood-crisis, red-flag, disengagement, mode-off, age-of-consent). Only **C11-specific** transitions are listed here.

| Trigger | Detection | Femio response | Routes to |
|---|---|---|---|
| **First cycle returns / regular TTC rhythm reached** | `first_cycle_returned = true` (or several logged ovulatory cycles) | Celebrate the milestone calmly; **offer switch to C1** with full fertile-window + BBT/OPK/CM + TWW stack; start/continue the standard `ttc_start_date` clock. | **C1 (TTC general)** — the primary handoff |
| **Positive pregnancy test** | `hpt_results` = positive (or user confirms) | Universal positive-test handler: celebrate; suppress fertile-window/TWW; continue folic acid; carry all data; re-confirm privacy; offer Pregnancy mode. | **Pregnancy (D)** |
| **No cycle return** | General amenorrhea criterion, associated symptom, or user concern | Calm, non-diagnostic card: "periods can take time to re-establish; it is reasonable to discuss this with a clinician." Offer eval-prep content + timeline export. **No infertility label.** | **Screening → clinician**; if cycles then appear irregular/absent long-term → C6 (PCOS-adjacent) / relevant condition content |
| **DMPA user, no period yet** | DMPA + no bleed | Explain that return can be delayed and may take up to about one year; keep clinician contact available and do not infer protection. | Stay in C11 (DMPA companion track) |
| **Pre-existing irregularity re-emerges** | `pre_contraception_cycle_regularity = irregular` & logged cycles vary widely / anovulatory | Non-diagnostic: "your cycles look irregular, as they may have been before — a screener/clinician can help." | Screener → clinician; C6/condition content |
| **≥35 and post-stop** | age ≥ 35 & stopped | Gentler urgency: emphasize starting tracking now + the 6-mo threshold once cycles return; do **not** rush her while still in the method-return window. | Stays C11 → C1, tighter clock |
| **Pregnancy loss reported** | user reports loss | Universal loss handler: Gentle Mode; suppress celebratory/timeline nudges; grief resources; retain data. | E6 grief → later C5/PAL |

*All routes preserve data continuity (one account) and always end with clinician-referral language, never a diagnosis. The defining C11 route is the **calm handoff to C1 on cycle return**; the second is **method-aware "no return" routing to a clinician.***

---

## K. Compliance flags

1. **Not contraception (highest-priority guardrail).** Fertile-window features are conception-awareness only. Femio gives **no advice to stop, continue, or switch a method** and offers no “safe/infertile day” framing. Every predictive/timeline surface says *“not a method of birth control.”* Apply [`HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md`](../compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md). Intended-use limits reduce claim risk but do not determine regulatory classification; launch-market legal review remains required. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
2. **No diagnosis / treatment / prevention.** The recovery timeline and method thresholds are **educational routing/awareness**, not verdicts. "No cycle return in window" routes to a clinician; it never diagnoses infertility. Depo delay is framed as **expected recovery, not damage.**
3. **Myth-correction must be accurate + cited.** Reversible contraception is not presented as causing permanent infertility; DMPA's possible delay is stated separately. No detox claim is used as treatment advice. Unsupported method-specific figures are excluded. *(Reviewed Mohamed K., 23 July 2026.)*
4. **Uncertainty honesty + no "late" counter.** Post-stop recovery UI must display ranges + confidence and **must not** show "period late / overdue" during the expected window (Master invariant #5). No false-precise return date.
5. **Privacy-by-design / reproductive-data sensitivity.** Treat contraception, cycle, and fertility data as sensitive health/reproductive data. Do not disclose it to ad networks or use it for targeted advertising. Collect only what the feature needs; make optional sharing granular, informed, revocable, and deletable; and re-confirm its scope when switching from preventing to trying. This product rule follows the FTC’s primary Flo (2021) and Premom/Easy Healthcare (2023) matters and the central claims/data policy. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
6. **Privacy-law implementation.** For EEA processing, reproductive health data falls within GDPR Article 9’s special-category framework; identify an applicable Article 6 basis and Article 9 condition and provide access, export, correction, and deletion workflows as applicable. Other markets require a launch-country assessment; do not claim universal “GDPR/PDPL compliance” or promise regional residency without approved architecture and legal review. See the [GDPR official text](https://eur-lex.europa.eu/eli/reg/2016/679/oj) and the central claims/data policy. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*
7. **Partner mode consent.** Partner sees only what the user grants; consent logged, scope-limited, instantly revocable.
8. **Medical review + citations.** Return-of-fertility and folic-acid wording is pinned in [`CONTRACEPTION_SAFETY.md`](../compliance/CONTRACEPTION_SAFETY.md); reviewer Mohamed K., 23 July 2026; next review 23 July 2027.
9. **Non-alarming emotional safety.** The post-stop limbo (esp. Depo amenorrhea) is anxiety-loaded; tone must reassure without toxic positivity, and never imply a failing body. Loss handled with grief-aware UX.
10. **App-store health-app policy.** Follow current [Apple App Review Guidelines §§1.4.1–1.4.2](https://developer.apple.com/app-store/review/guidelines/) and [Google Play Health Content and Services](https://support.google.com/googleplay/android-developer/answer/16679511): substantiate health claims, avoid misleading or harmful functionality, include the required non-medical-device disclaimer and clinician prompt where applicable, and complete Google’s health-app declaration. Re-check both policies immediately before submission. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Tier-1 (NHS / MedlinePlus / CDC / NIH):**
- [NHS — When will my periods come back after I stop taking the pill?](https://www.nhs.uk/conditions/contraception/when-periods-after-stopping-pill/)
- [NHS — Who can get the contraceptive injection (return of fertility up to ~1 year)](https://www.nhs.uk/contraception/methods-of-contraception/contraceptive-injection/who-can-get-it/)
- [NHS — Folic acid: pregnancy, breastfeeding and fertility](https://www.nhs.uk/medicines/folic-acid/pregnancy-breastfeeding-and-fertility-while-taking-folic-acid/)
- [NHS — Planning your pregnancy](https://www.nhs.uk/pregnancy/trying-for-a-baby/planning-your-pregnancy/)
- [MedlinePlus — Pregnancy: Identifying Fertile Days](https://medlineplus.gov/ency/article/007015.htm)
- [CDC — About Folic Acid](https://www.cdc.gov/folic-acid/about/index.html) · [CDC — Folic Acid: Facts for Clinicians](https://www.cdc.gov/folic-acid/hcp/clinical-overview/index.html)

**Peer-reviewed / NIH-indexed (return of fertility by method; Depo delay):**
- [Girum & Wasie — Return of fertility after discontinuation of contraception: a systematic review and meta-analysis, *Contracept Reprod Med* 2018 (PMC6055351)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6055351/)
- [Return to fertility after IUD removal for planned pregnancy (PubMed 4085244)](https://pubmed.ncbi.nlm.nih.gov/4085244/)
- [The relationship between contraceptive method use and return of fecundity (PMC10529236)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10529236/)

**Tier-2 (ACOG / ASRM / FSRH) — for publish-time citation:**
- [ASRM — Optimizing Natural Fertility: A Committee Opinion](https://www.asrm.org/practice-guidance/practice-committee-documents/optimizing-natural-fertility-a-committee-opinion-2021/)
- [ACOG — Prepregnancy Counseling](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2019/01/prepregnancy-counseling) · [ACOG — Trying to Get Pregnant? Here's When to Have Sex](https://www.acog.org/womens-health/experts-and-stories/the-latest/trying-to-get-pregnant-heres-when-to-have-sex)
- [FSRH — Contraception for Young People, May 2019 (§5.4)](https://www.fsrh.org/Common/Uploaded%20files/documents/fsrh-guideline-contraception-young-people-may-2019.pdf)
- [FSRH — Progestogen-only Injectable Contraception, amended July 2023 (§11.3)](https://www.fsrh.org/Common/Uploaded%20files/documents/progestogen-only-injectable-december-2014-amended-11july2023.pdf)

**Competitor / community context (voice-of-user, secondary):**
- [Flo — Understanding ovulation when you stop birth control](https://flo.health/getting-pregnant/trying-to-conceive/tracking-ovulation/signs-of-ovulation-after-stopping-the-pill) · [Flo — What to expect when going off birth control](https://flo.health/menstrual-cycle/sex/birth-control/what-happens-after-stopping-birth-control)
- [HealthPartners — How long after stopping birth control can you get pregnant?](https://www.healthpartners.com/blog/getting-pregnant-after-birth-control/)
- [Medical News Today — Contraception and infertility: Is there a link?](https://www.medicalnewstoday.com/articles/contraception-and-infertility)
- Depo-specific post-stop return timeline (community/clinical review, verify at publish): [Ubie — Get pregnant after the Depo shot](https://ubiehealth.com/doctors-note/get-pregnant-after-depo-shot-cycle-return-plans-6733e1)

*Community material (TTC, birth-control, and Depo forums and app reviews) is internal qualitative research used only to shape questions, tone, and workflow. Wording is editorial paraphrase—not quotation, prevalence evidence, or a public factual claim—so no live-thread attribution is implied. Privacy controls use the [FTC Flo](https://www.ftc.gov/legal-library/browse/cases-proceedings/192-3133-flo-health-inc) and [FTC Premom](https://www.ftc.gov/legal-library/browse/cases-proceedings/202-3186-easy-healthcare-corporation-us-v) matters. Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.*
