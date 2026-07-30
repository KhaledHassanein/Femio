# Persona B13 — Contraception method user (adherence + side-effect tracking)

> Femio product + UX research spec. Wellness / education / tracking scope only. **Femio is NOT a contraceptive**: it never claims to prevent pregnancy, never provides "safe days," and never replaces a clinician-prescribed method. It supports adherence reminders + side-effect awareness + balanced method education ONLY. Screeners are framed "discuss with a clinician." Medication content is educational.
> Research date: 2026-07-21 · Persona band: B (reproductive-age, non-TTC) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (§1 invariants, §2 state object, §3 core, §6 universal events, §5 Z1, §8 blending)

---

## A. Persona snapshot

**Who she is.** "Noor," 24. She is on a clinician-prescribed contraceptive method and has been for about a year. Depending on the sub-variant she is on the **combined pill** (daily, most common), or a **progestogen-only pill / mini-pill** (daily, tighter window), or the **patch** (weekly), **ring** (monthly), **injection/DMPA** (every ~12–13 weeks), **implant** (multi-year), or a **hormonal or copper IUD** (multi-year). She is **not** trying to conceive and is **not** using Femio to *decide* whether she's protected — her method does that. She wants Femio to help her (1) not miss a dose/appointment and (2) make sense of the side effects she's living with. Arabic-first (also reads English), web on her phone.

**What she lives with.**
- **Adherence load** — remembering a daily pill at the same time, a weekly patch change, a monthly ring, or *booking* the next injection / implant-or-IUD check before the method lapses. Missing is the #1 source of anxiety.
- **Bleeding changes** — breakthrough/irregular spotting (pill/patch/ring first months), unpredictable or prolonged bleeding (implant, injection), lighter/absent periods (hormonal IUD, injection), heavier/crampier periods (copper IUD). She doesn't know what's "normal for my method" vs worth checking.
- **Mood / libido / physical side effects** — mood changes, headaches, nausea, breast tenderness, acne changes, weight worry. She wants to see whether these track with her method, not just guess.
- **Method-fit uncertainty** — "is this the right method for me, or should I ask about switching?" She wants balanced education, not a sales pitch or scare stories.

**Core emotional drivers.** Wants to feel *on top of it* and *reassured*, not alarmed. Wants a neutral, believable read on what's normal vs worth raising — many apps and forums either catastrophize side effects or dismiss them. Wants her data organized enough to have a real conversation at her next appointment.

**Jobs-to-be-done.**
1. Never miss a pill / patch change / ring change — and never let an injection, implant, or IUD silently lapse without a booked appointment.
2. Log and understand side effects (bleeding, mood, headaches) and see whether they're settling or persisting.
3. Learn what her specific method does, common side effects, and the settling-in timeline — balanced, referenced.
4. Know the difference between "expected and usually settles" and "worth contacting a clinician" (incl. emergency red flags).
5. Prepare for a method-review or switch conversation with her clinician.

**Success = she keeps her method on schedule, feels informed rather than anxious about side effects, and walks into her review with a clear log — and she never once mistakes Femio for the thing that's protecting her.**

---

## B. Needs & questions (voice-of-user)

Mined from r/birthcontrol and r/PCOS-adjacent threads, app-store reviews of pill-reminder apps, and clinical patient-education pages (see Sources). Paraphrased to avoid quoting individuals.

**On reminders / adherence (the #1 practical pain):**
- "I need it to keep nagging me until I actually take it, not one notification I swipe away half-asleep."
- "I take my pill at different times because of shift work — I need a reminder that respects the real window, especially on the mini-pill."
- "I completely forgot my patch was due for a change until day 9. I need the *weekly* and *monthly* stuff handled, not just daily pills."
- "Nobody reminds you the injection is running out. I want a heads-up to *book* the next shot weeks early, not the day it lapses."
- "Discreet reminders — I don't want 'TIME FOR YOUR BIRTH CONTROL' on my lock screen at dinner."

**On side effects / what's normal:**
- "I've been spotting for two months on the implant. Is that normal or is something wrong?"
- "My period vanished on the hormonal IUD and I panicked — turns out that's expected, but no app told me."
- "I want to log my mood and headaches and actually see if it's the pill or just life."
- "How long until these side effects settle? Everyone says 'three months' but I want to track *my* three months."

**On method education / switching:**
- "I want the pros and cons of switching methods without a brand trying to sell me one."
- "Is it the pill making me anxious? I want balanced info, not horror stories or 'it's all in your head.'"
- "What do I even ask my doctor if I want to change methods?"

**On the boundary (this is the whole point of K):**
- "If I miss a pill, what's my *actual* risk?" → Femio must route this to the method's own missed-pill instructions / clinician / pharmacist, **never** compute a risk or a "safe day."
- "Which days am I safe?" → Femio must **refuse to answer as contraception** and redirect to her method + clinician.

**Top recurring questions Femio must answer in-product (all educational, none as contraceptive advice):**
1. What does *my* method do, and what are its common side effects?
2. Is this bleeding/mood/headache change normal for my method, or worth checking?
3. How long do side effects usually take to settle?
4. When should I contact a clinician — and what are the emergency red flags?
5. What are my options if I want to switch, and how do I raise it?
6. I missed a dose / I'm late for my patch/ring/injection — *what do I do?* (→ route to method instructions + clinician/pharmacist, never a Femio verdict)

---

## C. Competitor teardown

Focused on method reminders + side-effect tracking, and on the scope line most competitors blur.

| App | Model | Method-reminder depth | Side-effect tracking | Scope / claims posture | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **myPill** | Free + premium | Strong: supports pill, ring, patch, IUD, shot; knows the pill-free break; repeat "until taken" reminders | Basic logging | Reminder-first; doesn't claim to be contraception | Adequate; ad-supported tiers | Referenced method education + settling-timeline framing + AR-first + full-lifespan account |
| **Lady Pill Reminder** | Free + premium | Strong for *pills* (same-time daily, repeat nags); weak for non-daily methods | Minimal | Pill-adherence utility only | Unclear ad posture | Multi-method reminders (weekly/monthly/injection-booking) + side-effect insight |
| **CareClinic** | Freemium | Good: dose reminders, refill alerts | Strong: side effects, mood, symptoms, exportable clinician report | General health tracker, not BC-specific | Health-data heavy | BC-specific method logic + normal-vs-check framing + balanced method library |
| **MyTherapy** | Free | Reliable dose reminders + refill alerts | Symptom check + charts | Generic med reminder | Reasonable | Contraception-specific education + red-flag framing |
| **Flo** | Freemium, AI | Has hormonal-method modes + pill reminders | Broad symptom logging, TTC-leaning framing | Cycle/fertility-centric; **FTC 2021 settlement + ~$56M class settlement (2025)** for data-sharing | **Trust-damaged** | Privacy-by-design; non-TTC default; no fertility upsell; explicit not-contraception line |
| **Clue** | Freemium | Pill/method reminders + "Clue Birth Control" mode | Strong neutral symptom taxonomy | Cycle-science framing; better privacy posture | Better reputation | Referenced medical content + AR-first/RTL + method-switch education |
| **Natural Cycles** | Paid, **FDA-cleared medical device** | N/A — it *is* a contraceptive (fertility-awareness algorithm) | Temp/cycle inputs | **Claims pregnancy prevention** — regulated Class II device; "typical use" ~6.5% failure | — | **The anti-model.** Femio must NOT become this: no pregnancy-prevention claim = stays education/tracking, out of device regulation. See K. |

**Cross-cutting gaps Femio exploits:**
1. **Multi-method reminder logic.** Most reminder apps are pill-centric. Femio treats the patch (weekly), ring (monthly), injection (book-ahead before the ~12–13-week window closes), and implant/IUD (multi-year *check/expiry* reminder) as first-class — because a lapsed appointment method is the real-world failure mode.
2. **"Normal for my method vs worth checking" framing.** Competitors log side effects but rarely contextualize them per method with a settling timeline and a red-flag boundary. This is Femio's differentiator, done with referenced content.
3. **Explicit scope discipline.** No competitor foregrounds the *"we are not your contraception, we don't do safe days"* line. For a women's-health app under health-data and medical-device scrutiny, making that boundary a feature (not a buried disclaimer) is both compliant and trust-building post-Flo.

*Publication rule: the table is internal product-discovery material, not an approved public comparison. No named-app feature, price, privacy, or scope claim may be copied into user-facing or marketing content without a dated capture of the official listing and privacy policy plus compliance approval. Femio’s own controls stand independently of competitor behavior. *(Approved Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## D. Clinical grounding (cited)

All framed as **education**. Femio never prescribes, doses, computes contraceptive protection, or issues "safe days."

**Methods & how they're used (adherence surface).**
- **Combined pill (estrogen + progestogen):** daily; a pill-free/placebo break pattern; missed-pill rules depend on the product [NHS; ACOG].
- **Progestogen-only pill (mini-pill):** daily, with a **tighter same-time window** for some formulations — adherence precision matters more [NHS; FSRH].
- **Patch:** changed **weekly**; **Ring:** typically **monthly** [ACOG; NHS].
- **Injection (DMPA):** given on a product- and jurisdiction-specific schedule. Femio uses the recorded clinic due date for a book-ahead reminder and never supplies a universal late window; current instructions and a pharmacist/clinician control. ([CDC U.S. SPR 2024](https://www.cdc.gov/contraception/hcp/usspr/injectables.html); [global rule](../compliance/CONTRACEPTION_SAFETY.md))
- **Implant and IUD/IUS:** licensed duration varies by product and country. Femio stores the clinician/product due date and surfaces a check/expiry reminder, not a universal duration or reinsertion decision. ([global rule](../compliance/CONTRACEPTION_SAFETY.md))

**Common side effects (what to normalize, per method).**
- **Combined pill / patch / ring:** breakthrough bleeding/spotting (common in the first ~3 months), headache, nausea, breast tenderness, bloating, mood changes; most settle as the body adjusts [NHS combined pill/patch; ACOG].
- **Implant:** highly variable bleeding — ~20% have no bleeding, ~50% infrequent or prolonged bleeding; generally not harmful but can be bothersome [NHS inform; CDC].
- **Injection (DMPA):** irregular bleeding then often amenorrhea; delayed return of fertility after stopping; bone-density considerations are a clinician discussion [CDC; MSD Manual].
- **Hormonal IUD/IUS:** irregular bleeding early, then lighter or absent periods; headache, breast tenderness, mood changes, ovarian cysts possible [NHS IUS; CDC].
- **Copper IUD:** heavier, longer, or crampier periods, especially early [CDC; NHS].
- **Mood:** experiences are individual and the evidence does not support a single prevalence figure suitable for global product copy. Femio lets users track changes and discuss bothersome symptoms with a clinician; it does not claim that a method caused depression. ([FSRH — Contraception for Young People, 2019](https://www.fsrh.org/Common/Uploaded%20files/documents/fsrh-guideline-contraception-young-people-may-2019.pdf))

**What's usually normal vs worth checking (educational routing, not triage).**
- **Usually settles:** spotting/irregular bleeding and mild systemic side effects in the **first ~3 months** of a new method [NHS; ACOG].
- **Worth a (non-urgent) clinician/pharmacist chat:** side effects persisting or bothersome **beyond ~3–4 months**; bleeding that continues to be a problem (e.g., NHS notes seeing a clinician if irregular/heavy bleeding on the IUS lasts **>6 months**) — Femio surfaces these as *awareness prompts*, not verdicts [NHS combined pill; NHS IUS].
- **Emergency red flags (combined hormonal methods) — "ACHES," seek urgent care:** **A**bdominal severe pain; **C**hest pain/shortness of breath; **H**eadache that is sudden/severe; **E**ye — vision loss/blurring; **S**evere leg pain/swelling. These can signal blood clot (VTE/PE), stroke, or cardiovascular events. Absolute risk is low (and lower than in pregnancy) but the boxes are non-negotiable [ACOG; ASRM VTE guideline; nursing ACHES references]. Femio presents ACHES as **education + "seek care now,"** never as triage or diagnosis.

**Missed dose / late appointment (hard scope line).** Femio routes "I missed a pill / I'm late for my patch/ring/injection" to the **current instructions supplied with the exact product + a pharmacist/clinician**. If unprotected sex may have occurred, it states that emergency contraception is time-sensitive and routes promptly; it never computes residual pregnancy risk or says whether the user is protected. Regional rules differ, so the global product does not mirror one static decision tree. ([CDC U.S. SPR 2024](https://www.cdc.gov/mmwr/volumes/73/rr/rr7303a1.htm); [reviewed global rule](../compliance/CONTRACEPTION_SAFETY.md); reviewed Mohamed K., 23 July 2026.)

**Femio scope guardrail restated:** everything above is **wellness education + adherence support + side-effect awareness**, with consistent "discuss with your clinician / pharmacist" routing. Femio is **not** contraception, does not prevent pregnancy, and does not provide "safe days."

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Multi-method reminder engine** — per-method cadence: daily pill (same-time, **repeat-until-confirmed** nags, discreet copy), mini-pill tight-window mode, **weekly** patch-change, **monthly** ring in/out, **injection book-ahead** (nudge to *schedule* the next DMPA before the window closes), **implant/IUD check-or-expiry** reminder (weeks ahead). Snooze/quiet-hours; neutral lock-screen text.
2. **Side-effect tracker** — bleeding pattern (none/spotting/light/normal/heavy/prolonged), mood, headache, nausea, breast tenderness, acne, libido, weight (optional). Viewable together over time with a **"settling-in" timeline** view (are my side effects trending down since I started?).
3. **"Normal for my method vs worth checking" layer** — contextual, referenced explainer tied to her logged method + duration-on-method; surfaces awareness prompts (e.g., "spotting in the first 3 months is commonly reported" / "bothersome bleeding past ~3–4 months is worth raising"). Never a verdict.
4. **Red-flag / ACHES education card** — always reachable, surfaced prominently for combined-hormonal-method users; "seek care now" framing, saved emergency contact as *education*.
5. **Missed-dose / late-appointment helper** — routes to method-specific patient instructions + pharmacist/clinician + EC *education*; **explicitly refuses to calculate protection or safe days.**
6. **Not-a-contraceptive boundary, as UX** — onboarding statement + persistent, non-nagging footer wherever method/reminders appear: "Femio helps you remember and track. It does not prevent pregnancy — your method does."
7. **Privacy-by-design** — no ad-SDK sharing of method/health data; discreet notifications; export/delete.

**P1 — strong differentiators.**
8. Balanced, referenced **method-education library** (per method: how it's used, common side effects, settling timeline, switching considerations) — AR-first + EN/FR/ES.
9. **Method-review / switch prep pack** — exportable summary (method, time on it, side-effect trends, questions) for a clinician conversation.
10. **Mood screen** (screening-framed, crisis resources on low results) — because mood is a leading reason people consider switching.
11. **Adherence insight** — "you've logged your pill on time 26/30 days" (supportive, never shaming), gentle patterns.

**P2 — depth / retention.**
12. Correlation view ("your headache logs cluster in your pill-free week") — descriptive, never causal/diagnostic.
13. Refill / pharmacy pickup reminder for supply-based methods.
14. Optional method-satisfaction check-in over time (feeds switch-prep, not a recommendation).

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Your method, explained** — a card per method (combined pill, mini-pill, patch, ring, injection, implant, hormonal IUD, copper IUD): how it's used, what to expect. Educational; not instructions to start/stop.
2. **Common side effects & the settling-in timeline** — what's frequently reported per method, and the typical ~3-month adjustment window.
3. **Bleeding changes on contraception** — spotting, irregular, absent, heavier; what's commonly expected per method vs when bleeding is worth raising (incl. the IUS >6-month note).
4. **Mood, headaches & your method** — balanced, individual-variation framing; no "causes depression" claim; when to seek support.
5. **Warning signs — when to seek urgent care (ACHES)** — the emergency red-flag module, clearly separated from everyday side effects.
6. **Missed a dose or late for your method?** — routes to method-specific instructions + pharmacist/clinician + what emergency contraception is (education). **No safe-day math.**
7. **Thinking about switching?** — balanced pros/cons landscape, what to weigh, how to raise it with a clinician. No brand push, no recommendation.
8. **Emergency contraception 101** — what it is, that it's time-sensitive, where to get it — education only, distinct from her ongoing method.
9. **Myths vs evidence** — "the pill causes infertility," "you must take breaks from the pill," "no period on the IUD means something's wrong."
10. **Femio and contraception — what we do and don't do** — the plain-language scope explainer (mirrors K).

Every module: referenced citations, medical-review byline + date, "discuss with your clinician/pharmacist" footer.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Method log: current method + start-date-on-method (drives reminder cadence + settling-timeline).
- Adherence log: dose/patch/ring taken-confirmations; missed-dose entries (raw, non-judgmental).
- Side-effect log: bleeding pattern, mood, headache, nausea, breast tenderness, acne, libido, weight (optional/toggleable).
- Appointment log: next injection / implant-or-IUD check / review date.

**Tools**
- **Multi-method reminder engine** (see E1) — cadence-aware, repeat-until-confirmed, discreet.
- **Settling-in timeline view** — side-effect trend since method start.
- **"Normal vs worth checking" explainer** — contextual, referenced, never a verdict.
- **Missed-dose / late-appointment helper** — routing only; refuses protection/safe-day computation.
- **Method-review / switch prep generator** — one-tap export/print.
- **Screeners (framed as screening, not diagnosis):**
  - Mood screen (PHQ-2/GAD-2 style) → "This is a screening tool, not a diagnosis. Consider discussing with a clinician." + crisis resources.

**Alerts (all non-alarming, dismissible, localized/RTL, discreet copy)**
- Adherence reminders per method cadence (repeat-until-confirmed for daily; book-ahead for injection; expiry-window for implant/IUD).
- Refill / supply reminders.
- Side-effect awareness prompts (e.g., "bothersome side effects past ~3–4 months are commonly worth raising with a clinician").
- Review-due nudge.
- **Never:** a "safe day," a fertile-window presented as contraception, a residual-pregnancy-risk number after a missed dose, a "you're protected/not protected" statement, or any pregnancy-prevention claim.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — from `09_MASTER_ADAPTATION_MODEL.md` §3)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, non-TTC, **contraception-method mode ON**).
- Cycle/bleed events (repurposed as bleeding-pattern log; no "late" language, no fertile-window as contraception).
- Generic symptom log; mood/energy/sleep.
- `ttc_intent = false`.

**Persona-specific (contraception method)**
- `method_type` (combined pill / POP / patch / ring / injection-DMPA / implant / hormonal IUD / copper IUD) + `method_start_date`.
- `reminder_cadence` (derived: daily+time / weekly / monthly / ~12–13-week book-ahead / multi-year expiry).
- Adherence records: taken-confirmations, missed-dose entries, snooze history.
- Appointment records: next injection date, implant/IUD check-or-expiry date, review date.
- Side-effect log: bleeding pattern, mood, headache, nausea, breast tenderness, acne, libido, weight (optional).
- Mood-screen history (scores + dates, screening-only).
- Method-satisfaction check-ins (optional; feeds switch-prep, not recommendations).
- `not_a_contraceptive_ack` (onboarding acknowledgement that Femio is not the protective method).

*All health fields optional, encrypted, user-deletable. Femio stores **no** derived "protection status" field — by design, it does not compute one.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B13):**
- Q: life stage → "tracking my cycle / general" → Q2 refine.
- Q: "Are you using a contraceptive method you'd like reminders for?" → **Yes** ⇒ set **contraception-method mode ON**, `ttc_intent = false`.
- Q: which method? ⇒ sets `method_type` → derives `reminder_cadence` and the method's education skin + side-effect context.
- Q: when did you start this method? ⇒ sets `method_start_date` → powers settling-in timeline.
- Q: reminder preferences (time, discreet copy, repeat-until-confirmed, quiet hours).
- **Scope moment (mandatory):** a clear, one-tap onboarding card — "Femio helps you remember and track your method and its side effects. **It does not prevent pregnancy and can't tell you which days are 'safe' — your method and your clinician do that.**" Sets `not_a_contraceptive_ack`.

**Home configuration (default for B13):**
- Hero = next action for her method (today's pill / patch-due / ring-due / "book your next injection" / "IUD check due in N weeks") + confirm button.
- Cards: side-effect quick-log, settling-in timeline, "normal vs worth checking," method-education, review-prep.
- ACHES / red-flag card reachable always; surfaced for combined-hormonal-method users.
- Persistent, quiet not-a-contraceptive footer on method/reminder surfaces.
- Fertile-window / ovulation / "safe day" widgets **suppressed** (not just hidden) in this mode.

**Hidden-but-reachable principle:** TTC guidance, pregnancy tracking, fertility-awareness *education* (clearly labelled "not offered by Femio as contraception"), and other life-stage content remain discoverable via search / "Explore other life stages" — just not pushed. She can switch modes anytime.

**Adaptive tuning:** repeated missed-dose logs → surface (supportively) method-education on adherence + "some people find a different method fits their routine — worth discussing" (education, not a push). Persistent bothersome side effects past ~3–4 months → raise switch-education + review-prep prominence. Low mood screens → surface mental-health module + resources.

---

## J. Adaptation triggers (life-stage routing)

Inherits all **universal events** from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive pregnancy test, pregnancy loss, mood-screen-high/crisis, red-flag symptom, disengagement/"taking a break," toggle-mode-off, age-of-consent milestone). B13-specific additions below.

| Trigger | System response | Route |
|---|---|---|
| **Stops / plans to stop her method** ("coming off it") | Confirm sensitively; suppress method reminders; retain history; surface *educational* "what to expect coming off [method]" (return of cycle/fertility varies, esp. delayed after DMPA); re-confirm privacy scope | **Route to B14 (stopping-contraception / return-of-cycle persona)**; keep bleeding + symptom logs running |
| **Side-effect intolerance** (persistent bothersome side effects, or low mood screens tied to method) | Raise **method-switch education** + review-prep pack; screening-framed mood support if relevant; **route the decision to clinician**, never recommend a specific method | Stay B13, raise switch-education prominence → clinician |
| **Wants to conceive** (sets `ttc_intent = true`) | Confirm; suppress method reminders; explain method-specific return-of-fertility (education); enable TTC/cycle features with uncertainty-honest framing | **Route to B14 → C1** (or C-variant by history); carry data |
| **Missed dose / late for appointment** | Missed-dose helper: route to method instructions + pharmacist/clinician + EC *education*; **no protection/safe-day computation** | Stay B13 (content-only routing) |
| **Injection / implant / IUD approaching expiry** | Book-ahead reminder to schedule the appointment (weeks early); does not decide re-insertion | Stay B13 |
| **User toggles off contraception-method mode** | Revert to standard cycle logic; preserve all history | General reproductive-age band / Z1 |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

**THE BOUNDARY (highest-priority for this persona):**
- **Femio is NOT a contraceptive and is not a medical device.** It must **never** claim to prevent pregnancy, indicate that the user is "protected," compute residual pregnancy risk after a missed/late dose, or present any "safe days" / fertile-window-as-contraception. This is the line that separates Femio (education/tracking, unregulated-as-device) from a product like **Natural Cycles**, which *is* FDA-cleared as a Class II contraceptive **precisely because it makes a pregnancy-prevention claim**. Making that claim would pull Femio into medical-device regulation and directly violate its scope. The not-a-contraceptive statement is a **first-class UX element** (onboarding ack + persistent footer), not a buried disclaimer.
- **No "safe day" logic anywhere.** Fertile-window/ovulation prediction is **suppressed** in B13 mode. Any fertility-awareness content that exists elsewhere in Femio must be clearly labelled *education, not offered by Femio as a method of contraception.*
- **Femio supports the method; it is not the method.** Its role is limited to: adherence reminders, side-effect tracking, and balanced education. The clinician-prescribed method provides contraception.

**Other compliance flags (inherited invariants + persona specifics):**
- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Missed-dose / late-appointment:** route to the method's own patient instructions + pharmacist/clinician + emergency-contraception *education*; never a Femio calculation or verdict.
- **Red flags (ACHES):** emergency warning-sign education is "seek care now" framing + saved emergency contact as education — never triage or diagnosis. Kept visibly separate from everyday side effects.
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never "you have depression."
- **Medication/method content (pill/patch/ring/injection/implant/IUD, emergency contraception):** educational context only; no recommendation, no dosing, no "start/stop this." Clear non-prescription disclaimer + clinician routing. Switching is always routed to a clinician, never recommended.
- **Mental health:** crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** health data = special-category; explicit granular consent, purpose limitation, **no ad-SDK/third-party sharing** of method/adherence/side-effect data (post-Flo trust); discreet notifications; full export/delete. Femio stores no "protection status" field by design. Data-mapping + DPIA required before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device and contraception-claim trigger language; framing as reminders/tracking/education keeps out of regulated-device territory — legal review before store submission.
- **Medical-source resolution (23 July 2026):** missed/late actions, licensed durations, mood prevalence, and injection windows follow the reviewed global rule in [`CONTRACEPTION_SAFETY.md`](../compliance/CONTRACEPTION_SAFETY.md). No global numeric mood prevalence or universal product window is published. Competitor/privacy claims remain a separate research/compliance review item. *(Reviewed Mohamed K.; next review 23 July 2027.)*

---

## Sources

**Clinical — Tier 1 (CDC / NHS / MedlinePlus / OWH / gov):**
- [Contraception — CDC (methods, effectiveness, guidance hub)](https://www.cdc.gov/contraception/)
- [U.S. Selected Practice Recommendations for Contraceptive Use, 2024 — CDC MMWR](https://www.cdc.gov/mmwr/volumes/73/rr/rr7303a1.htm)
- [Implants — CDC US-SPR](https://www.cdc.gov/contraception/hcp/usspr/implants.html)
- [Side effects and risks of the combined pill — NHS](https://www.nhs.uk/contraception/methods-of-contraception/combined-pill/side-effects/)
- [Side effects and risks of the contraceptive patch — NHS](https://www.nhs.uk/contraception/methods-of-contraception/contraceptive-patch/side-effects-and-risks/)
- [Side effects and risks of an IUS (hormonal coil) — NHS](https://www.nhs.uk/contraception/methods-of-contraception/ius-hormonal-coil/side-effects-and-risks/)
- [Contraceptive implant — NHS inform](https://www.nhsinform.scot/healthy-living/contraception/contraceptive-implant/)

**Clinical — Tier 2 (ACOG / FSRH / society / peer-reviewed):**
- [Combined Hormonal Birth Control: Pill, Patch, and Ring — ACOG](https://www.acog.org/womens-health/faqs/combined-hormonal-birth-control-pill-patch-ring)
- [CDC — Injectables, U.S. SPR 2024](https://www.cdc.gov/contraception/hcp/usspr/injectables.html)
- [FSRH Guideline — Quick Starting Contraception (2017)](https://www.cosrh.org/Common/Uploaded%20files/documents/1fsrh-guideline-quick-starting-contraception-april-2017.pdf)
- [Combined hormonal contraception and the risk of VTE: a guideline — ASRM (2016)](https://www.asrm.org/practice-guidance/practice-committee-documents/combined-hormonal-contraception-and-the-risk-of-venous-thromboembolism-a-guideline-2016/)
- [Progestin Contraceptive Injections — MSD Manual (Professional)](https://www.msdmanuals.com/professional/gynecology-and-obstetrics/family-planning/progestin-contraceptive-injections)
- [ACHES birth-control warning-sign mnemonic — Lecturio (nursing reference)](https://www.lecturio.com/nursing/free-cheat-sheet/aches-birth-control-adverse-effects/)
- [Hormonal birth control and blood clots — Clue (science explainer)](https://helloclue.com/articles/sex/hormonal-birth-control-and-blood-clots)

**Side effects / mood / patient education:**
- [Birth control and depression — Healthline (research summary)](https://www.healthline.com/health/birth-control/birth-control-and-depression)
- [Switching birth control pills — Healthline](https://www.healthline.com/health/switching-birth-control-pills)
- [Why am I bleeding on the pill? — Superdrug Online Doctor](https://onlinedoctor.superdrug.com/bleeding-and-period-contraceptive-pill.html)

**Scope boundary (contraception-claim = medical device):**
- [FDA clears Natural Cycles as first digital contraceptive — pharmaphorum](https://pharmaphorum.com/news/contraception-app-natural-cycles-approved)
- [Natural Cycles effectiveness review (typical-use ~6.5% failure) — FACTS](https://www.factsaboutfertility.org/natural-cycles-app-effectiveness-to-prevent-pregnancy-a-review-of-research/)

**Competitor / app landscape (reminders + side-effect tracking):**
- [myPill Birth Control Reminder — App Store](https://apps.apple.com/us/app/mypill-birth-control-reminder/id425632209)
- [CareClinic — Best Birth Control Reminder App](https://careclinic.io/birth-control-reminder/)
- [MyTherapy — Birth Control Pill Reminder App](https://www.mytherapyapp.com/contraceptive-pill-reminder-app)
- [9 of the best pill reminder apps — Medical News Today](https://www.medicalnewstoday.com/articles/pill-reminder)
- [Birth control reminder app roundup — Healthline](https://www.healthline.com/healthy/birth-control-reminder-app)
