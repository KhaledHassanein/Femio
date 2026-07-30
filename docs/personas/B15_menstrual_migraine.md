# Persona B15 — Reproductive-age woman with menstrual migraine (cycle-linked migraine)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician." Medication content is educational, never a dose or a recommendation.
> Research date: 2026-07-21 · Persona band: B (reproductive-age, non-TTC default) · Inherits: `09_MASTER_ADAPTATION_MODEL.md`

---

## A. Persona snapshot

**Who she is.** "Nadia," 31. For years her worst migraines have landed in the two days before her period and the first day or two of bleeding — like clockwork. She has learned not to schedule anything important for those days. She keeps a headache note in one app, her period in another, and can never line the two up to prove to herself (or her doctor) that they are connected. About a third of her attacks come with a visual aura — shimmering zig-zag lines that creep across her vision 20 minutes before the pain. Arabic-first, also reads English, lives on the web on her phone.

**What she lives with.**
- **Cycle-locked attacks** — the heaviest, longest, least treatment-responsive migraines cluster in the perimenstrual window (roughly day −2 to +3). She dreads her period not for the bleeding but for the head pain.
- **Aura in some attacks** — visual aura (and occasionally tingling or word-finding trouble) that resolves before or as the headache starts. She does not know that aura status changes what is safe for her.
- **Failed generic tracking** — period apps treat headache as one checkbox among forty symptoms; migraine apps ignore her cycle. Neither shows her the overlay she actually needs.
- **Treatment frustration** — the triptan that works the rest of the month often does nothing during her period; she wants to understand why and what her options are.
- **Uncertainty about her own future** — she has heard perimenopause can make it worse and menopause better, and that pregnancy "changes things," but has no clear picture.

**Core emotional drivers.** Wants to feel *validated* — to see the correlation in a chart she can hand to a clinician, not just "feel" it. Wants to *anticipate* bad days instead of being ambushed. Wants to understand her body and her options without being told what to take, and — critically — wants to know if any of her choices carry hidden risk (the aura + estrogen question she has never been asked about).

**Jobs-to-be-done.**
1. Log headaches and periods in one place and *see them overlaid* to confirm (or rule out) a cycle link.
2. Understand the difference between pure menstrual migraine and menstrually-related migraine — and why the estrogen drop matters.
3. Learn her trigger landscape (hormonal + non-hormonal) so perimenstrual days aren't a black box.
4. Understand treatment and prevention approaches (acute, mini-prophylaxis, hormonal) as *education* to bring to a clinician.
5. Understand the aura + estrogen-contraception safety conversation — framed as "raise this with your clinician," never as advice.

**Success = she stops screenshotting a headache diary and a period app separately, and walks into her appointment with a single overlay chart and the right questions — including whether her aura changes her contraceptive options.**

---

## B. Needs & questions (voice-of-user)

Mined from migraine communities (Reddit r/migraine, patient.info forums, migraine.com, Association of Migraine Disorders), app-store reviews of migraine/period trackers, and patient-burden studies. Paraphrased to avoid quoting individuals.

**On seeing the connection (the #1 pain):**
- "I *know* my worst migraines are period migraines but my apps won't show me the two together. I have to eyeball a headache diary next to my period app."
- "My doctor wanted a diary showing the timing. Getting that out of a period app that buries headache in a symptom list was impossible."
- "I want the overlay: headaches on top of my cycle, so I can finally see the pattern instead of guessing."

**On predictability + dread:**
- "It's predictable, which sounds helpful, but it just means I spend the whole week before my period dreading it."
- "I plan travel and big days around it because I know I'll be useless for those two days."

**On treatment not working:**
- "My triptan works great the rest of the month. During my period, all bets are off — it does nothing."
- "These attacks are longer, worse, and more frequent than my other migraines and I don't understand why."

**On understanding the biology:**
- "Is it low estrogen or the *drop* in estrogen? I keep reading both."
- "What even is the difference between 'menstrual migraine' and just getting migraines that happen to be near my period?"

**On aura + hormones (often not knowing to ask):**
- "Nobody ever asked me if my migraines have aura before putting me on the pill."
- "I read somewhere that aura + the pill is a stroke thing? Is that real? Should I be worried?"

**On the life course:**
- "Will perimenopause wreck this? I've heard it gets worse before it gets better."
- "What happens in pregnancy — do they stop or get worse?"

**On privacy:**
- "After the Flo/Facebook story I don't want my health data sold. Headaches plus cycle is sensitive."

**Top recurring questions Femio must answer in-product:**
1. Are my headaches actually linked to my cycle — can I see it?
2. What is the difference between pure menstrual migraine and menstrually-related migraine?
3. Why do attacks cluster right before/at the start of my period? Is it the estrogen drop?
4. Why do my usual meds fail during my period, and what approaches exist (acute, "mini-prophylaxis," hormonal)?
5. Does my aura change what's safe for me — especially estrogen-containing contraception?
6. What will perimenopause, pregnancy, and menopause do to my migraines?

---

## C. Competitor teardown

Feature-by-feature, focused on the **headache-cycle correlation gap**: migraine apps under-model the cycle; period apps under-model the headache. Almost no consumer product treats the *overlay* as the hero for this user.

| App | Model | Headache depth | Cycle depth | Correlation / overlay | Aura + estrogen safety framing | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|---|
| **Migraine Buddy** | Freemium migraine diary (neurologist-built) | Deep: triggers, aura, duration, intensity, meds, pain map, sleep graph | Shallow: menstrual data only *imported* from Oura / Health Connect; not a native cycle model | Correlates sleep/lifestyle well; cycle correlation depends on external sync and is not the centrepiece | None — not a contraception context | Health-data sensitive; migraine-cohort dataset | Native cycle model + first-class headache-cycle overlay + aura-aware safety education, Arabic-first |
| **N1-Headache / Curelator** | Migraine diary + individual trigger/protector analytics | Deep trigger analytics | Limited native cycle model | Statistical trigger association, but hormonal cycle is one input among many, not an overlay hero | None | Health-data sensitive | Cycle-centred overlay for the woman whose #1 trigger *is* the cycle |
| **Flo** | Freemium cycle app, AI predictions | Shallow: headache is one symptom checkbox | Deep cycle model | Can show symptom-vs-cycle patterns, but headache is buried; no migraine-grade logging (aura, intensity, med response) | Not surfaced as a safety flag | **FTC settlement (2021) for sharing period/pregnancy data; ~$56M class settlement (2025)** — trust damage | Migraine-grade headache log + explicit aura + estrogen education + privacy-by-design |
| **Clue** | Freemium, science-forward cycle app | Shallow: headache tag among many | Strong cycle model; adapts to variable length | Symptom-pattern views exist but not migraine-specialised; no aura/med-response depth | Not surfaced | Better GDPR posture | Referenced migraine content + overlay as hero + multilingual/RTL |
| **Stardust** | Privacy-forward, local-first cycle app | Symptom tags only | Cycle tracking | Low prediction emphasis; no migraine specialisation | None | **Strong: local-first** | Clinical credibility + migraine depth + aura safety education |
| **Nettle / hormone-tracking apps** | Niche hormonal-symptom trackers | Varies | Varies | Some hormone-symptom correlation; not migraine-grade, not referenced-content led | Rarely | Unclear | Referenced content + compliant screener + full-lifespan account |

**Product rationale:** Femio combines cycle timing with user-entered headache, aura, intensity, and response detail and surfaces a clinician conversation about aura and estrogen-containing contraception. This is a direct description of Femio’s intended design, not a claim that no current competitor offers equivalent features.

*Competitive-claims boundary:* named-app feature parity changes with releases and is not used in public copy. Any future comparison requires a dated capture from the product’s own documentation and compliance review. *(Claim cut; reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## D. Clinical grounding (cited)

**Definitions (ICHD / IHS classification).** Migraine attacks tied to menstruation fall into two patterns:
- **Pure menstrual migraine** — attacks occur *exclusively* on day 1 ± 2 (i.e. days −2 to +3) of menstruation in at least two of three cycles, and at no other time of the cycle.
- **Menstrually-related migraine (MRM)** — attacks occur perimenstrually in at least two of three cycles *but also* at other times of the cycle. MRM is by far the more common pattern [American Migraine Foundation; PMC review, PMC10512516].

Either can occur **with or without aura**; menstrually-triggered attacks are most often *without* aura, but a woman can have aura in some attacks and not others [American Migraine Foundation].

**The hormonal mechanism — estrogen withdrawal.** The trigger is the **perimenstrual drop in estrogen**, not a low absolute level. It is the *speed and magnitude of the fall* following the late-luteal decline that provokes the attack (the "estrogen withdrawal" hypothesis) [PMC10512516; Cleveland Clinic; Mayo Clinic]. This is why attacks cluster in the day −2 to +3 window and why stabilising estrogen (e.g. continuous/extended contraceptive regimens or estrogen add-back around the hormone-free interval) is a strategy clinicians discuss [American Migraine Foundation; Norton Healthcare].

**Burden — why these attacks feel worse.** Perimenstrual migraine attacks are, on average, **longer, more severe, more frequent, and less responsive to acute treatment** than a woman's non-menstrual attacks [Healio, 2026 reporting on burden study; migraine.com]. Patient-reported symptoms commonly include difficulty concentrating, fatigue, nausea, and light/sound sensitivity.

**Aura + estrogen-containing contraception — the safety point.** CDC U.S. MEC 2024 classifies combined hormonal contraception as **category 4** for migraine with aura: an unacceptable health risk if the method is used. Femio presents that primary guideline fact and asks the user to discuss aura and contraception promptly with a clinician. It does not diagnose aura, tell an individual to start/stop/switch, or turn a population guideline into a personal eligibility verdict. Progestogen-only and non-hormonal methods have different CDC classifications, but method choice remains clinical. ([CDC U.S. MEC 2024 classifications](https://www.cdc.gov/contraception/hcp/usspr/classifications-mec-contraception.html); [reviewed global rule](../compliance/CONTRACEPTION_SAFETY.md))

**Management landscape (EDUCATIONAL framing only — Femio does not treat or dose).**
- **Acute/preventive landscape:** clinicians may discuss NSAIDs, triptans, or short-term perimenstrual prevention. Femio names the strategy only and supplies no drug, dose, start day, duration, or eligibility instruction. ([American Migraine Foundation](https://americanmigrainefoundation.org/resource-library/menstrual-migraine-treatment-and-prevention/))
- **Preventive/hormonal:** stabilising the perimenstrual estrogen fall — e.g. extended/continuous combined regimens or estrogen add-back during the hormone-free interval — is a clinician-led option, **subject to the aura contraindication above** [American Migraine Foundation; ClinicalTrials NCT01251263].
- **Non-drug:** consistent sleep, magnesium, riboflavin, hydration, and stress/CBT approaches are discussed as adjuncts [Cleveland Clinic; Mayo Clinic].
- **CGRP-pathway therapies** are part of the broader migraine-prevention landscape a clinician may discuss [UPMC; American Migraine Foundation].

**Life-course changes.**
- **Perimenopause:** erratic hormone swings often **worsen** frequency/severity before menopause [American Migraine Foundation; Society for Women's Health Research].
- **Menopause:** once hormones stabilise at a low level, many women find attacks **decrease or stop** [American Migraine Foundation].
- **Pregnancy:** migraine (especially without aura) frequently **improves**, particularly in the 2nd/3rd trimester as estrogen rises and stabilises, though the picture varies and aura can newly appear — all clinician-monitored [American Migraine Foundation, "Migraine Through a Woman's Life"].

**Red-flag / when-to-seek-care education (content only, never triage).** A *change* in aura — new onset, aura lasting >60 minutes, aura with one-sided weakness, speech loss, or the "worst/sudden thunderclap" headache, or vision loss — warrants urgent medical attention to exclude stroke and other serious causes [Mayo Clinic; American Migraine Foundation; American Headache Society].

**Femio scope guardrail restated:** everything above is presented as **wellness education, tracking, and screening**, with consistent "discuss with your clinician" routing. Femio is not contraception, does not recommend or dose medication, and does not claim to prevent disease.

**Medical-source resolution.** User-facing copy uses the accessible primary CDC category-4 wording and does not quote secondary characterizations of an ACOG bulletin. All medication doses and timing windows remain excluded. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Headache-cycle overlay (the hero).** A single view that plots logged headaches/migraines on top of the cycle timeline, highlighting the perimenstrual window (day −2 to +3). "X of your last Y attacks fell in your perimenstrual window" — descriptive, not diagnostic.
2. **Migraine-grade headache log** — per-attack: onset, duration, intensity, **aura y/n + aura type**, location, associated symptoms (nausea, photophobia, phonophobia), medication taken + whether it helped, and free-trigger notes.
3. **Aura flag + safety-education surfacing** — logging aura on any attack sets an `aura_ever = true` marker that surfaces the **aura + estrogen-contraception clinician-conversation card** (education only; see §K).
4. **Menstrual vs menstrually-related education** — plain-language explainer keyed to her own overlay pattern ("your attacks so far look menstrually-related — they cluster near your period but also happen at other times").
5. **Non-TTC default** — no "trying to conceive?" nudges; TTC/pregnancy reachable but never assumed.
6. **Privacy-by-design** — local-first where feasible, no ad-SDK sharing; headache + cycle is special-category data.

**P1 — strong differentiators.**
7. Referenced, medically-reviewed migraine + hormone content library (Arabic-first + EN/FR/ES).
8. **Anticipation nudge (opt-in, gentle):** as her predicted perimenstrual window approaches, an optional "your higher-risk days may be coming — here's your trigger/plan content" prompt. Never a countdown of dread; dismissible; framed as preparation, not prediction of pain.
9. Trigger-awareness module (hormonal + non-hormonal: sleep, skipped meals, stress, dehydration) with descriptive correlation ("appears associated with," never "caused by").
10. Treatment/prevention **education** module (acute vs perimenstrual mini-prophylaxis vs hormonal vs non-drug) — all clinician-routed, no doses.
11. **Visit-prep pack** — exportable/printable overlay chart + attack summary + suggested questions (incl. "does my aura affect my contraceptive options?").

**P2 — depth / retention.**
12. Aura-pattern insight (frequency/duration trend) with a built-in "if your aura changes, seek care" education footer.
13. Medication-response tracker (which acute med helped which attack — for her own pattern awareness and visit prep, not a recommendation engine).
14. Life-course preview cards (perimenopause / pregnancy / menopause outlook) reachable from content.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Menstrual migraine 101** — what it is, the day −2 to +3 window, how common it is.
2. **Pure vs menstrually-related migraine** — the two patterns, the "2 of 3 cycles" idea, why it matters for treatment choice.
3. **Why the estrogen *drop* triggers it** — withdrawal mechanism explained (it's the fall, not the level).
4. **Aura — what it is and why it matters** — visual/sensory/speech aura; how it differs from stroke; why aura status changes the contraception conversation. Prominent "discuss with your clinician" framing.
5. **Migraine, aura & estrogen-containing contraception (education only)** — the stroke-risk association, the ACOG/WHO-MEC position in plain language, the ongoing debate, and a clear "this is a decision for you and your clinician — bring up your aura." **No recommendation of any method.**
6. **Treatment & prevention landscape (education only)** — acute meds, perimenstrual "mini-prophylaxis," hormonal stabilisation, non-drug options (sleep, magnesium, riboflavin, CBT). Clear non-prescription, non-dose disclaimer.
7. **Why my usual med fails during my period** — the burden/severity picture; what to discuss with a clinician.
8. **Triggers beyond hormones** — sleep, meals, stress, dehydration; how to track without self-blame.
9. **Migraine across your life** — perimenopause (may worsen), pregnancy (often improves, aura caveat), menopause (often settles). Reachable, non-alarming.
10. **When a headache needs urgent care** — thunderclap/worst-ever, new or changed aura, aura >1 hour, one-sided weakness, speech/vision loss. Education, not triage.
11. **Getting the most from your appointment** — how to use the overlay chart, questions to ask, advocating if dismissed.

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- **Migraine/headache log (migraine-grade):** date/time, duration, intensity, **aura y/n + type (visual / sensory / speech)**, location, associated symptoms (nausea, photophobia, phonophobia), medication taken + relief y/n, free-text triggers.
- Cycle/bleed log (flow, spotting, cycle-length range) — shared with the core cycle model.
- Optional trigger log (sleep, meals, stress, hydration).
- Optional med/supplement log (educational; no dosing guidance).

**Tools**
- **Headache-cycle correlation log / overlay (flagship tool).** Plots attacks against the cycle timeline; shades the perimenstrual window (day −2 to +3); summarises descriptively: *"N of your last M attacks began in your perimenstrual window (day −2 to +3). This looks menstrually-related. A clinician can confirm and discuss options."* Never outputs a diagnosis, never "you have menstrual migraine."
- **Uncertainty-honest window preview** — shows the *estimated* upcoming perimenstrual window as a range with a confidence band (degrades gracefully for irregular cycles; no "late" counter).
- **Visit-prep generator** — one-tap export/print: overlay chart + attack list + aura history + suggested questions (including the aura + contraception question).
- **Screeners (framed as screening, not diagnosis):**
  - **Aura-awareness checklist** → "These features can indicate aura. Aura status matters for some decisions — please discuss with a clinician." Sets `aura_ever` surfacing.
  - Mood/anxiety screen (optional; migraine + chronic-pain burden) → "This is a screening tool, not a diagnosis." + crisis resources.

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL)**
- **Perimenstrual-window preparation prompt (opt-in):** "Your higher-risk days may be approaching — here's your plan/trigger content." Preparation, not a pain countdown; fully dismissible.
- **Aura + estrogen safety education card** — fired once when `aura_ever` is first set (and re-surfaced if she logs contraception interest): "You've logged migraine with aura. This can matter for contraceptive choices — worth raising with your clinician." Education + clinician routing; **never** "don't take the pill" / "stop your pill."
- **Red-flag / urgent-care education box** — surfaced from content and on logging a *new or changed* aura (new one-sided weakness, aura >1 hour, worst-ever/sudden headache, speech/vision loss): "These can be signs to seek urgent care." Saved emergency contact shown as *education*, never triage.
- Optional log-reminder around the predicted window (respecting irregular cadence).
- **Never:** contraceptive/method advice; never "safe day"/contraception claims; never disease-prevention claims; never "you have migraine with aura" as a diagnosis; never a medication dose.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, **menstrual-migraine mode ON**).
- Cycle events: bleed start/end, flow, spotting; computed personal cycle-length range + variability.
- Generic symptom/mood/sleep log.

**Persona-specific (menstrual migraine)**
- **Headache/migraine attacks[]:** timestamp, duration, intensity, **aura y/n + aura_type**, location, associated symptoms, medication + relief y/n, triggers (entry only).
- **`aura_ever` boolean** (set true if aura logged on any attack or via aura-awareness checklist) — drives safety-education surfacing. Non-diagnostic.
- **Perimenstrual-correlation summary** (computed): count/proportion of attacks in day −2 to +3 window; pattern hint (menstrual-like / menstrually-related-like / not-cycle-linked) — descriptive, non-diagnostic.
- **Migraine pattern self-report:** diagnosed migraine (with/without aura) y/n; year; clinician-following y/n.
- **Trigger log** (hormonal + non-hormonal).
- **Medication/supplement log** — entry only, educational, no interpretation as dosing.
- **Contraception-context flag** (self-report: using / considering / not) — used *only* to time the aura safety-education card and route to B13 education; never to advise a method.
- TTC intent flag = **false** (drives non-TTC UX); reachable toggle.

*All health fields optional, encrypted, user-deletable. `aura_ever` and correlation summaries are non-diagnostic awareness markers, never verdicts.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B15):**
- Q: life stage → "reproductive age / tracking my cycle." Q: cycles regular/irregular → sets prediction-UI mode.
- Q: "Do you get headaches or migraines you think are linked to your cycle?" → **Yes** ⇒ set **menstrual-migraine mode ON**, surface headache log + overlay as hero.
- Q: "Do any of your migraines come with warning signs like flashing lights, zig-zags, blind spots, tingling, or trouble speaking (aura)?" → **Yes/Sometimes** ⇒ set `aura_ever = true`, queue the aura + estrogen safety-education card (§K).
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false; suppress fertile-window/pregnancy nudges.
- Q: top concerns (multi-select: seeing the pattern, understanding triggers, treatment options, contraception + safety, life-stage changes) ⇒ orders home modules.

**Home configuration (default for B15):**
- Hero = **headache-cycle overlay** + perimenstrual-window preview (range, not a pain-date; no "late" counter).
- Cards prioritised by concern selection (e.g. treatment-education card surfaced if she flagged treatment; aura-safety card pinned if `aura_ever`).
- Migraine log + visit-prep pinned.
- Fertile-window/pregnancy widgets hidden by default.

**Hidden-but-reachable principle:** Femio never removes knowledge. TTC guidance, pregnancy tracking, **contraception education (B13)**, and perimenopause/menopause content remain discoverable via search and "Explore other life stages" — surfaced only when relevant (e.g. contraception-context flag) but never gated.

**Adaptive tuning:** if the overlay shows a strong perimenstrual cluster, raise the "menstrual vs menstrually-related" explainer and visit-prep prominence. If she logs a *new or changed* aura, raise the urgent-care education box. If she flags considering/using contraception, surface the aura safety-education card + route to B13 education.

---

## J. Adaptation triggers (life-stage routing)

Inherits all **universal events** from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive test, loss, mood-screen high, red-flag symptom, disengagement, mode-off, age-of-consent). Only **B15-specific** transitions listed here.

| Trigger | System response | Route |
|---|---|---|
| **Logs aura on any attack / passes aura checklist** (`aura_ever` → true) | Set marker; surface aura + estrogen-contraception **education** card ("worth raising with your clinician"); add aura-change urgent-care education. **Never** advise a method. | Stay B15, safety-education raised |
| **Flags considering/using contraception** | Surface aura safety-education card (if `aura_ever`); route to **B13 contraception education**; keep migraine tracking | Stay B15 + link B13 (education only) |
| **New or changed aura** (new onset, aura >1 hr, one-sided weakness, speech/vision loss, worst-ever headache) | Prominent urgent-care **education** box + saved emergency contact as education; log stays raw | Stay B15; emergency messaging (content only) |
| **Sets TTC intent = true** | Confirm; enable ovulation/fertile-window with uncertainty caveats; surface **migraine-in-pregnancy education** (often improves; aura caveat; med-safety = clinician); carry migraine log forward | Route to **C-track** (TTC), migraine modifier retained |
| **Positive pregnancy test** (universal handler) | Suppress fertile-window/TWW; carry migraine + aura history; re-confirm privacy; surface pregnancy-migraine education (improvement pattern + aura caveat, all clinician-monitored) | → **D-track**, migraine modifier retained |
| **Perimenopause overlap** (late 30s+/40s, changing cycles, vasomotor symptoms) | Introduce perimenopause-migraine education (**may worsen** with erratic swings, often settles after menopause); clarify overlap; keep overlay + irregular-cycle logic | Blend B15 + perimenopause content; offer route to **F1** |
| **Reaches menopause / 12-mo amenorrhea** | Migraine-and-menopause education (attacks often decrease with stable low hormones); retire perimenstrual-window prediction; keep headache log | Route to **F2**, migraine modifier retained |
| **Mood/anxiety screen trends low / crisis flag** (universal) | Surface mental-health module + localized crisis resources; screening-framed | Stay B15 |
| **User toggles off menstrual-migraine mode** | Revert to standard cycle logic; preserve all headache history (archived-but-reachable) | General reproductive-age band |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **THE SAFETY POINT — aura + estrogen-containing contraception (educational, clinician-routed).** When a user logs possible migraine with aura, Femio surfaces that CDC U.S. MEC 2024 places combined hormonal contraception in category 4 for migraine with aura and asks her to raise this promptly with her clinician. Femio **must never** diagnose aura; tell her to start, stop, switch, or avoid a method; state that a method is personally safe/unsafe; or present the flag as an individualized verdict. ([CDC primary table](https://www.cdc.gov/contraception/hcp/usspr/classifications-mec-contraception.html))
- **Screeners:** aura-awareness checklist and mood screen both return "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs "you have migraine with aura" or "you have menstrual migraine."
- **Correlation output:** the overlay describes association ("N of your attacks fell in your perimenstrual window; this looks menstrually-related"), never diagnoses. Predictions of the perimenstrual window are uncertainty-honest ranges, never certain pain-dates; no "late" counter.
- **Medication content (triptans, NSAIDs, hormonal prevention, CGRP, magnesium/riboflavin):** educational context only — what they are and why a clinician might discuss them. **No recommendation, no dose, no timing instruction** (perimenstrual "mini-prophylaxis" described only as a strategy clinicians use, with no doses). Clear non-prescription disclaimer + clinician routing.
- **Red-flag education:** urgent-care box for new/changed aura or thunderclap headache is *educational awareness*, never triage or diagnosis; saved emergency contact shown as education.
- **Mental health:** crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** headache + aura + cycle data = special-category; explicit granular consent, purpose limitation, no ad-SDK/third-party sharing (post-Flo trust), local-first where feasible, full export/delete. Contraception-context flag is sensitive — extra consent care. Data-mapping + DPIA required before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** framing as tracking/education keeps out of regulated-device territory; the aura safety card must read as education + "see your clinician," not clinical decision support — legal review before store submission.
- **Medical-source resolution (23 July 2026):** CDC U.S. MEC category 4 is pinned; inaccessible/secondary ACOG wording is not reproduced; medication doses/timing are excluded. Competitor feature parity remains a separate research/compliance item. *(Reviewed Mohamed K.; next review 23 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH/CDC/NHS/MedlinePlus/gov + major hospital patient-ed):**
- [Menstrual migraine is caused by estrogen withdrawal: revisiting the evidence — PMC (NIH)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10512516/)
- [Migraine with aura increases the risk of stroke — PMC (NIH)](https://pmc.ncbi.nlm.nih.gov/articles/PMC4540227/)
- [Acute and Preventive Management of Migraine during Menstruation and Menopause — PMC (NIH)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8197159/)
- [Menstrual Migraines (Hormone Headaches) — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/8260-menstrual-migraines-hormone-headaches)
- [Migraine with aura — Symptoms & causes — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/migraine-with-aura/symptoms-causes/syc-20352072)
- [Headaches and hormones: What's the connection? — Mayo Clinic](https://www.mayoclinic.org/diseases-conditions/chronic-daily-headaches/in-depth/headaches/art-20046729)
- [Prevention of Menstrual Migraines: Estrogen Add-back During the HFI — ClinicalTrials.gov (NCT01251263)](https://clinicaltrials.gov/study/NCT01251263)

**Clinical — Tier 2 (society / guideline / peer-reviewed):**
- [Hormonal & Menstrual Migraine — American Migraine Foundation](https://americanmigrainefoundation.org/resource-library/hormonal-menstrual-migraine/)
- [Menstrual Migraine Treatment and Prevention — American Migraine Foundation](https://americanmigrainefoundation.org/resource-library/menstrual-migraine-treatment-and-prevention/)
- [Migraine Through A Woman's Life — American Migraine Foundation](https://americanmigrainefoundation.org/resource-library/migraine-through-a-womans-life/)
- [Migraine and Menopause — American Migraine Foundation](https://americanmigrainefoundation.org/resource-library/migraine-and-menopause/)
- [Migraine and Stroke: Reducing Your Risk — American Migraine Foundation](https://americanmigrainefoundation.org/resource-library/migraine-stroke-reducing-risk/)
- [Migraine with Aura, Contraceptives and Stroke Risk — American Headache Society](https://americanheadachesociety.org/news/migraine-with-aura-contraceptives-and-stroke-risk)
- [Migraine with Aura — American Headache Society (primary care resource)](https://americanheadachesociety.org/resources/primary-care/migraine-with-aura)
- [Migraine headache and hormonal contraception (ACOG contraindication) — Contemporary OB/GYN](https://www.contemporaryobgyn.net/view/migraine-headache-and-hormonal-contraception)
- [Combined hormonal contraceptives and migraine: an update on the evidence — Cleveland Clinic J Med](https://www.ccjm.org/content/84/8/631)
- [Hormonal contraceptives and ischemic stroke in women with migraine — EHF/ESC consensus, PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5662520/)
- [Menopause, Perimenopause, and Migraine — Society for Women's Health Research](https://swhr.org/menopause-perimenopause-and-migraine/)
- [Menstrual migraine more burdensome than other migraines — Healio (2026)](https://www.healio.com/news/neurology/20260430/menstrual-migraine-more-burdensome-than-other-migraines)

**Patient journey / needs (community + patient-ed):**
- [Why Did I Have Trouble Treating My Menstrual Migraine? — migraine.com](https://migraine.com/living-migraine/trickiness-treating-menstrual-triggered-attack)
- [Two years of menstrual migraines, looking for insight from others — patient.info forum](https://patient.info/forums/discuss/two-years-of-menstrual-migraines-looking-for-insight-from-others-721359)
- [Hormones, Menstrual Migraine & Treatment Protocols — Association of Migraine Disorders](https://www.migrainedisorders.org/hormones-menstrual-migraine-treatments/)
- [Headaches and Hormones: Hidden Truths about Menstrual Migraines — UNM Health](https://unmhealth.org/stories/2025/05/headaches-and-hormones.html)
- [Living With Hormonal Headaches — UPMC HealthBeat](https://share.upmc.com/2025/11/living-with-hormonal-headaches/)

**Competitor / app landscape:**
- [Migraine Buddy — official site](https://migrainebuddy.com/)
- [Migraine Buddy (Aptar Digital Health) — feature overview incl. cycle/Health Connect sync](https://aptardigitalhealth.com/products/migrainebuddy-leading-app-for-migraine-and-headache/)
- [Reviewed: Top 5 Migraine Tracking Apps — Axon Optics](https://axonoptics.com/blogs/post/top-5-migraine-tracking-apps)
- [How to Track Your Migraine Triggers: Apps, Journals & What to Look For — SEC Headache](https://www.secheadaches.com/post/how-to-track-your-migraine-triggers-apps-journals-what-to-look-for)
- [Period-tracking app — Wikipedia (Flo FTC/settlement context)](https://en.wikipedia.org/wiki/Period-tracking_app)
