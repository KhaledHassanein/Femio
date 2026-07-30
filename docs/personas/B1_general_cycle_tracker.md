# Persona B1 — General cycle / wellness tracker (reproductive-age, not TTC, not pregnant, no diagnosed condition)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician." Predictions are uncertainty-honest ranges, never certain dates.
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC) · **MVP-core persona — Femio Phase 1**
> Role in the model: **the neutral hub.** B1 is the default reproductive-age state every other B/C/D/F state branches from and returns to. Inherits all seven invariants, the state object, the constant core, universal events, Z1 fallback, and blending rules from `09_MASTER_ADAPTATION_MODEL.md` — this spec adds only B1-specifics.

---

## A. Persona snapshot

**Who she is.** "Nour," 29. Regular-ish cycles (roughly 26–32 days), no diagnosed gynecologic condition, on no hormonal contraception she's tracking around, and **not** trying to conceive and **not** pregnant. She tracks her period the way she tracks steps or sleep: for **awareness and control**. She wants to know when her period is coming so nothing catches her off guard (travel, events, white jeans, an exam), to understand why her energy and mood swing across the month, and to have a private record she trusts. Arabic-first, also reads English; lives on the web on her phone.

**Why she tracks (the real jobs).**
- **No surprises** — a good-enough heads-up on her next period and PMS window so she can plan.
- **Pattern literacy** — "is it my cycle or is it me?" She wants to see mood, energy, cramps, skin, sleep, and libido line up (or not) with her phase.
- **Baseline / early-warning** — a personal normal so that when something *does* change, she notices. The cycle as a monthly vital sign.
- **Fast, low-friction logging** — 5 seconds a day, not a symptom homework assignment.
- **Privacy she doesn't have to think about** — after the Flo headlines, "not creepy" is a feature.

**What she is NOT (and resents apps assuming).** Not TTC. Not pregnant. Not sick. She is the majority-case user that period apps under-serve because they optimize the funnel toward fertility/pregnancy monetization. The moment she logs, most apps ask "trying to conceive?" or push a fertile-window she didn't request.

**Core emotional drivers.** Competence and calm. She wants an app that feels like a smart, discreet personal record — honest when it doesn't know ("your next period is likely around Jun 12–15"), never dramatic, never nagging, never selling her a pregnancy narrative or her data.

**Jobs-to-be-done.**
1. Log a period and a few symptoms in seconds and see a clean prediction.
2. Get an **uncertainty-honest** next-period / PMS estimate she can actually plan around.
3. Understand her cycle phases and what's normal for *her* body.
4. Notice when her pattern shifts — and get calm, screening-framed guidance on whether it's worth a clinician chat.
5. Keep it all private, portable, and free of paywall ambush.

**Success = Femio is the one app she keeps** — because it's fast, it's honest about what it can't predict, it doesn't assume she's trying to get pregnant, and she trusts it with the data. From here, every life change (TTC, a symptom pattern, cycles shifting in her 40s, a positive test) is a *branch off B1*, not a new app.

---

## B. Needs & questions (voice-of-user)

Mined from period-tracking communities (r/TheGirlSurvivalGuide, r/badwomensanatomy-adjacent cycle threads, app-store reviews for Flo/Clue/Stardust), privacy reporting (NPR, CNN, FTC), and cycle-education sources. Paraphrased to avoid quoting individuals.

**On prediction & honesty (the hub pain):**
- "Just tell me roughly when my period is coming so I can pack tampons for the trip. I don't need a fake exact date."
- "It said my period would start Tuesday with total confidence. It came Friday. Now I don't trust any of its dates."
- "I want a window, not a countdown that makes me anxious when I'm one day 'late' and I'm not even trying to get pregnant."

**On being funneled toward pregnancy:**
- "Why does logging a period make it ask if I'm trying to conceive? I'm 24 and I just want to know when my period is."
- "Every screen is baby this, ovulation that. I'm not in that chapter."

**On logging friction & paywall creep:**
- "I loved it until half the symptoms and the good insights went behind a subscription."
- "It takes too many taps to log one period. I stopped bothering."
- "Ads and upsells on an app I use for my body? No."

**On understanding patterns:**
- "Is my low mood the week before my period real or in my head?" (It's real and trackable — luteal-phase mood dip.)
- "My skin breaks out at the same point every month — I want to see that laid out."
- "What actually is a 'normal' cycle? Mine is 31 days, is that fine?"

**On privacy (post-Flo, post-Roe):**
- "After the Flo/Facebook thing I deleted it. I want something that isn't harvesting my period data."
- "I want to be able to just delete everything and have it be gone."

**On when to worry:**
- "My cycle used to be like clockwork and now it's all over the place. Is that something or nothing?"
- "How long is too long to skip a period if I'm not pregnant?"

**Top recurring questions Femio must answer in-product:**
1. When is my next period — honestly, as a range?
2. Is my cycle length / period length / variability normal? What's normal?
3. What are the cycle phases and why do my mood/energy/skin/libido change?
4. Is this PMS, and what helps? When is it more than PMS (PMDD)?
5. My pattern changed — is that worth checking with a clinician?
6. Is my data private, and can I delete it?

---

## C. Competitor teardown

Focused on the general-cycle-tracking job (not PCOS/TTC): prediction honesty, logging UX, privacy, and paywall creep — the four axes B1 users switch over.

| App | Model | Prediction honesty (regular cycles) | Logging UX | Privacy posture | Paywall creep | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI predictions, very large user base | Accurate-ish for regular cycles after ~3 months, but presents a **confident single date**; degrades badly for irregular/peri users while still looking confident | Fast, polished, but heavily TTC/pregnancy-oriented funnel; "trying to conceive?" surfaces early | **FTC settlement (2021)** for sharing period/pregnancy data with Facebook/Google; **~$56M class settlement (2025)**; added "Anonymous Mode" post-Roe as damage control | High — long-time users report features that were free being absorbed into Premium ("bait and switch") | Uncertainty-honest **range + confidence**, non-TTC default, privacy-by-design, no ad-SDK |
| **Clue** | Freemium, science-forward, Berlin/EU | More conservative than Flo; adapts to variable cycle length better; still shows a predicted period/fertile window | Clean, neutral symptom taxonomy; less funnel pressure | **Strong — GDPR/EU jurisdiction**, public commitment not to share reproductive data with US authorities | Moderate — paid tier expanded 2023–24; reviewers note formerly-free features moved behind paywall | Arabic-first/RTL, referenced condition-depth content, full-lifespan single account, honest-range framing |
| **Stardust** | Privacy-forward, local-first, astrology theme | Low emphasis on hard prediction (good for honesty) but **astrology framing dilutes clinical trust** | Simple logging | **Strong — local-first, privacy-forward**, marketed post-Roe | Low — generous free tier is a genuine differentiator | Clinical credibility + referenced content + honest prediction *with* a real evidence base, minus the zodiac |
| **Apple Health / Cycle Tracking** | Built-in, free, on-device | Conservative range-based estimate, on-device privacy | Minimal, no education/insight layer | **Strong — on-device** | None | Education, phase insight, multilingual content, coaching, cross-lifespan continuity |
| **Natural Cycles** | Paid, FDA-cleared *contraception* device | Precise but requires BBT discipline; is a regulated device | High-effort (daily temping) | Regulated-device data model | Subscription-gated | Femio is explicitly **NOT contraception** and stays out of device territory — different job entirely |

**Cross-cutting failures Femio's hub design targets:**
1. **False confidence.** Competitors present a *point date* for an inherently probabilistic event. The correct product answer is a **range with a confidence band** plus plain-language uncertainty — for regular cycles this is a tight window; the same UI degrades gracefully (never a "late" counter) when cycles vary. This is the single biggest trust lever.
2. **Pregnancy-funnel default.** General trackers monetize via TTC/pregnancy and so assume it. B1's default is **non-TTC, non-pregnant** — TTC and fertile-window are reachable, never pushed.
3. **Paywall ambush.** Users churn when free features are clawed back. Femio's core logging + honest prediction + phase education must stay in the free tier; any paid tier adds depth, never removes the basics.
4. **Trust damage.** The Flo FTC/class-action saga is the category's reputational wound. Privacy-by-design (no ad-SDK, export/delete, granular consent) is a *primary acquisition argument* for B1, not a footnote.

*Claims boundary:* Femio does not publish a prediction-accuracy percentage for any named app or imply comparative performance without a peer-reviewed, population-matched validation study. Product design is described directly: predictions are estimates, widen with variability, and are never contraception. *(Claim cut; reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## D. Clinical grounding (cited)

**What a "normal" cycle is (the baseline B1 education rests on).**
- **Cycle length:** counted from day 1 of one period to day 1 of the next. Average ~28 days, with **21–35 days considered normal** for adults [NHS; NIH StatPearls; Cleveland Clinic]. Cycles shorter than 21 days = *polymenorrhea*; longer than 35 days = *oligomenorrhea* [NIH StatPearls].
- **Period (bleed) length:** typically **2–7 days**, average ~5 [NHS].
- **Regularity is about *your* variation, not a fixed number.** ACOG frames the menstrual cycle as a **"vital sign."** Cycles are considered regular if the difference between the shortest and longest cycle is **≤7 days (ages 26–41)** or **≤9 days (ages 18–25 or 42–45)** [ACOG Committee Opinion; ACOG patient FAQ]. This is the correct basis for B1's "normal for you" logic — not a rigid 28-day model.

**The phases (the engine behind phase-based insight).**
- **Two-phase physiology:** follicular/proliferative phase (variable length, ~10–16 days) → ovulation → luteal/secretory phase (relatively **constant ~14 days**) [NIH StatPearls; Endotext]. Because most cycle-length variation lives in the *follicular* phase, ovulation is best described as occurring **~14 days before the next period**, not on a fixed day — a key uncertainty-honesty point.
- **Popular 4-phase framing** (menstrual → follicular → ovulatory → luteal) maps hormone shifts to how many women feel: estrogen rising in the follicular/ovulatory window tends to track higher energy and mood; the late-luteal drop in estrogen and progesterone tracks irritability, low mood, fatigue, and PMS symptoms in many people [educational sources; corroborated by cycle-mood literature]. Femio presents this as **"many people notice / this is common," never "you will feel."**

**PMS / PMDD (framed as screening, never diagnosis).**
- **PMS** = physical and emotional symptoms in the luteal phase that ease after the period starts; very common [educational + clinical review]. Cycle-symptom tracking is exactly the tool clinicians use to distinguish PMS from PMDD and from mood conditions with a non-cyclic pattern [cycle-mood review, PMC].
- **PMDD** = a more severe, impairing pattern (≥5 luteal-phase symptoms including marked mood symptoms that interfere with function) — **discuss with a clinician** [educational + clinical review]. Femio surfaces a symptom-timing view and screening framing; it never labels PMDD.

**What's normal vs. worth checking (the calm red-flag layer).** Speak with a clinician if [NHS; ACOG patient FAQ; Cleveland Clinic]:
- The **usual pattern changes** noticeably (was regular, now not) — irregular periods are often benign but a *change* is worth a check.
- **Cycles shorter than 21 or longer than 35 days**, or **periods lasting longer than 7 days**.
- **Very heavy bleeding** — soaking through a pad/tampon every hour, passing large clots.
- **Bleeding between periods, after sex**, or any **new pelvic pain** apart from usual period pain.
- **No period for 3+ months** when not pregnant (educational threshold for a check-in, not a verdict).

Femio's guardrail: all the above is presented as **wellness education + screening + "discuss with your clinician,"** never as a diagnosis, and never as a reason for alarm. A pattern change raises *content and visit-prep prominence*, not a red banner.

**Scope guardrail restated.** Femio is not contraception, does not identify "safe days," and does not claim to prevent disease. Predictions are uncertainty-honest ranges. Screeners screen; they do not diagnose.

---

## E. Feature set (prioritized)

**P0 — MVP-core; this is Femio Phase 1's spine.**
1. **Fast period logging** — one-tap "period started / ended," flow, spotting; ≤5 seconds; the single most-used action, so it's the hero interaction. Optional quick-add symptom chips right there.
2. **Uncertainty-honest prediction** — next period and PMS window shown as a **range with a confidence band** and plain-language caveat ("Likely Jun 12–15 — cycles naturally vary, so this is an estimate, not a fixed date"). **No "late" counter.** Confidence *tightens* as her personal history accumulates and *widens* honestly when variability rises.
3. **Cycle-phase view + insight** — where she is in her cycle (phase, day), what's common in this phase for mood/energy/skin/libido, framed as "many people notice," personalized descriptively from her own logs over time.
4. **Non-TTC, non-pregnant default** — zero "trying to conceive?" nudges; no fertile-window pushed. TTC/fertile-window and pregnancy are reachable via an "explore" entry, never assumed.
5. **Personal-normal baseline** — her own cycle-length range, period length, and variability, with gentle "this is within the typical range / your pattern shifted recently" context (screening-framed).
6. **Privacy-by-design** — granular consent, no ad/analytics-SDK access to health data, export + one-tap delete, clear plain-language data controls. Marketed, not buried.
7. **Symptom + mood + energy log** — light, optional, together over time; the substrate for phase insight.

**P1 — strong differentiators / retention.**
8. Referenced, medically-reviewed cycle-education library (Arabic-first + EN/FR/ES): what's normal, the phases, PMS vs PMDD, when to check in.
9. **Calm change-awareness prompts** — non-alarming, screening-framed nudges when her pattern shifts (e.g., "Your last few cycles have been longer than your usual — often nothing, sometimes worth a mention at a check-up. Here's why.").
10. Trend/correlation insight ("your low-energy logs tend to cluster in your late-luteal days") — pattern description, never diagnosis or causation.
11. Mood/anxiety screener (PHQ-2/GAD-2 style), screening-framed, with crisis resources — surfaced if mood logs trend low.
12. Optional visit-prep summary (cycle history + symptom trends + questions) she can export/print — the same generator B6/others use, available to everyone.

**P2 — depth.**
13. Optional lab/result entry (entry-only, no interpretation) so the record grows with her.
14. Wellness content aligned to phase (nutrition/movement/rest as general wellness education, non-prescriptive, non-shaming).
15. Reminder customization (period-due heads-up, PMS heads-up, log nudge) — all dismissible, all respecting her cadence.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **Your cycle, explained** — what a cycle is, how it's counted, the 21–35-day normal range, "regular means regular *for you*."
2. **The phases** — menstrual / follicular / ovulatory / luteal; what each phase is hormonally and what many people notice (energy, mood, skin, libido, sleep). Careful "common, not guaranteed" framing.
3. **The cycle as a monthly check-in (vital sign)** — why tracking builds a personal baseline and helps you and your clinician spot change early [ACOG vital-sign framing].
4. **What's normal, what's worth checking** — cycle/period length, heavy bleeding, bleeding between periods, missed periods, pattern change; calm "discuss with your clinician" routing.
5. **PMS and the week before your period** — what PMS is, why the late-luteal mood/energy dip happens, self-care that helps; when it may be PMDD (screening-framed).
6. **Prediction, honestly** — why no app can give a certain date, what a confidence range means, why "late" isn't a useful frame if you're not TTC.
7. **Mood, energy & your cycle** — normalizing cyclic changes; when low mood is more than PMS; how to bring it to a clinician.
8. **Your data, your rules** — plain-language privacy explainer (what Femio does and doesn't do with cycle data; export/delete).
9. **Myths vs. evidence** — "everyone is 28 days," "a late period always means pregnancy," "tracking apps can prevent pregnancy" (they can't — not contraception).
10. **Exploring other chapters (when you're ready)** — soft, non-pushy index into TTC, pregnancy, contraception education, and perimenopause content — discoverable, never forced.

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, YMYL/E-E-A-T compliant.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Period/bleed log (start/end, flow, spotting) — the primary interaction, optimized for speed.
- Symptom log: cramps, headache, bloating, skin/acne, breast tenderness, sleep, libido (all optional/toggleable).
- Mood & energy log (light, quick-select).
- Optional lab/result entry (entry-only, no interpretation).

**Tools**
- **Uncertainty-honest predictor** — next-period + PMS window as range + confidence band + plain-language caveat; confidence adapts to her variability; never a "late" countdown.
- **Cycle-phase indicator** — current phase/day + "commonly noticed in this phase" insight.
- **Personal-normal dashboard** — her cycle-length range, period length, variability, with typical-range context.
- **Pattern insight** — descriptive correlations ("appears associated with," never "caused by").
- **Visit-prep generator** — one-tap export/print summary + questions (shared engine across personas).
- **Screeners (framed as screening, not diagnosis):**
  - Mood/anxiety screen (PHQ-2/GAD-2 style) → "This is a screening tool, not a diagnosis — consider discussing with a clinician." + localized crisis resources.

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL)**
- Period-due heads-up (range-framed: "Your period is likely around [range]") — never "you are N days late."
- PMS-window heads-up (optional).
- Log nudge (gentle, respects her cadence, easy to silence).
- **Change-awareness** prompt when pattern shifts (educational, "often nothing, sometimes worth a mention").
- **Missed-period awareness** (3+ months, not pregnant) → calm clinician-check content — never "you might be pregnant" unless she opts to explore that.
- **Never:** contraception / fertile-window "safe day" claims; never disease-prevention claims; never a certain-date prediction; never a "late" counter for a non-TTC user.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across the Femio account — the constant spine; B1 essentially *is* the core, lightly configured)**
- Account: age/DOB band, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off).
- Life-stage / mode flag (here: reproductive-age, **ttc_intent=false**, **pregnant=false**, no condition modifier — the neutral hub).
- Cycle events: bleed start/end, flow, spotting; computed personal cycle-length range + variability + period-length.
- Generic symptom log; mood / energy / sleep / libido.
- `last_bleed` clock (drives prediction + missed-period awareness).
- Content history; screener results (timestamped, non-diagnostic).

**Persona-specific (B1 adds essentially nothing beyond the core — that's the point)**
- Prediction-confidence state (personal variability band).
- Tracking-intent preferences (what she wants heads-ups for: period, PMS, none).
- Optional user-entered labs (entry only, no interpretation).
- Optional "reasons for tracking" tags from onboarding (awareness / planning / symptoms / just curious) — orders home modules only.

*All health fields optional, encrypted, user-deletable. Because B1 is the neutral core, transitioning her to any other state is purely **additive** — a new layer over this unchanged record, never a rebuild.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B1) — the default reproductive-age path:**
- Q life stage → "Tracking my cycle / general." Q cycles → **regular** (or "not sure") ⇒ standard cycle mode (irregular/absent would route toward B6-family).
- Q "Are you currently trying to conceive?" → **No** ⇒ ttc_intent=false; suppress fertile-window & pregnancy nudges.
- Q "Any condition a clinician is tracking?" → **No** ⇒ no condition modifier; stays pure B1.
- Q "What do you mainly want from tracking?" (multi-select: know when my period's coming / understand my symptoms & mood / keep a private record / general health) ⇒ orders home modules.
- Always offers **"Skip / not sure" → Z1** (generic, progressive) per master model.

**Home configuration (default for B1):**
- Hero = **cycle status + uncertainty-honest next-period estimate** (phase, day, range — *not* a single date, *no* "late" counter).
- Pinned: fast period-log button; cycle-phase insight card.
- Cards ordered by her "reasons for tracking" selection (symptoms/mood surfaced if she flagged them; privacy explainer surfaced if she flagged private-record).
- Fertile-window / pregnancy / TTC widgets **hidden by default**, reachable via "Explore other chapters."

**Hidden-but-reachable principle.** B1 is the neutral hub, so *everything* is reachable from here — TTC guidance, pregnancy tracking, contraception education, PCOS/condition content, perimenopause content — all discoverable via search and an "Explore other life stages / chapters" entry, none of it pushed. She can opt into fertile-window display or TTC mode anytime.

**Adaptive tuning (within B1, no state change):**
- As history accumulates, prediction confidence tightens; if variability rises, the band widens honestly and change-awareness content surfaces.
- If mood logs trend low, surface mental-health module + resources (screening-framed).
- If she logs a pattern shift, raise "what's normal vs worth checking" + visit-prep prominence — still B1, just re-weighted.

---

## J. Adaptation triggers (life-stage routing)

B1 is **the hub**: it inherits every universal event from `09_MASTER_ADAPTATION_MODEL.md` §6 (positive pregnancy test, pregnancy loss, mood-screen crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). Below are the **B1-specific** branches — the spokes off the hub. All require explicit, reversible user confirmation and preserve full data continuity.

| Trigger | System response | Route |
|---|---|---|
| **Sets TTC intent = true** ("start trying / I want to get pregnant") | Confirm; enable ovulation/fertile-window + BBT/OPK/CM tools **with uncertainty caveats**; surface preconception education; carry all cycle history | **→ C1** (general TTC); if a condition/loss later surfaces, C1 re-routes per its own spec |
| **Positive pregnancy test logged** (universal event, hub instance) | Celebrate (tone-neutral, no prior-loss history here); suppress prediction/PMS widgets; carry data; re-confirm privacy scope; offer Pregnancy mode | **→ D1** pregnancy (default), condition modifiers added only if present |
| **Minor / underage signal** (age band indicates <16, or "recently started periods") | Route to age-appropriate mode; **minor tier ON** (gates community/DMs/UGC only, never knowledge); trusted-adult scope offered | **→ A2 / teen mode** |
| **Irregular / absent cycles + PCOS-adjacent signals** (long/absent cycles, hyperandrogenism self-report, high variability) | Offer irregular-cycle mode; disable 28-day assumptions; PCOS-awareness content (screening-framed, never "you have PCOS") | **→ B6** (irregular/PCOS-not-TTC) |
| **Symptom cluster surfaces** — heavy/prolonged bleeding, severe cyclic pain, cyclic-timed mood severity, thyroid-type symptoms | Raise relevant education + visit-prep; offer the matching condition-aware B-persona experience (still additive, non-diagnostic) | **→ B2 / B3 / B4 / B5** as pattern indicates |
| **Cycles changing in 40s+** (age signal + lengthening/shortening/skipping cycles, vasomotor symptoms) | Introduce perimenopause education; clarify what's expected; keep irregular-cycle logic; **no "late" counter** | **→ F1** (perimenopause) |
| **Prolonged amenorrhea (3+ months, not pregnant, recurring)** | Non-alarming clinician-check prompt + relevant education + visit-prep; offer "explore pregnancy" only if she chooses | Stay B1, raise screening prominence (or branch if a condition pattern emerges) |
| **Mood screen trends low / crisis flag** (universal) | Surface mental-health module + localized crisis resources; screening-framed | Stay B1 + support routing |
| **Change in usual pattern (was regular, now not)** | Calm change-awareness content ("often nothing, sometimes worth a mention"); visit-prep | Stay B1, re-weighted |
| **Starts hormonal contraception / wants contraception education** | Provide educational content (Femio is **not** contraception and never claims "safe days"); adjust prediction framing to reflect method | Stay B1, contraception-education layer |
| **Toggles tracking mode / resets wizard** | Revert to chosen logic; preserve all history | Generic band / Z1 |

**Because B1 is the constant core**, every one of these is a *re-layering* over an unchanged record (master model §2–3) — no rebuild, no data loss, fully reversible. Returning to B1 (e.g., postpartum return of cycle from E1, or toggling a condition mode off) simply drops the added layer and archives it, reachable on return.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, **not contraception, no "safe day" / fertile-window reliability claims.** (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Predictions:** must display uncertainty as a **range + confidence band**; never a single certain date; **never a "late" counter** for a non-TTC user; confidence framing must degrade honestly as variability rises. Explicit "not for contraception" note wherever any ovulation/fertility content appears.
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs a condition label. Mood-screen crisis path (any high/crisis flag) surfaces localized crisis resources immediately.
- **Change/red-flag content:** "what's worth checking" is framed as education + "discuss with your clinician," never triage or diagnosis; a pattern change raises content prominence, never a medical alarm.
- **Mental health:** crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** cycle/health data = special-category; explicit granular consent, purpose limitation, **no ad-SDK / third-party sharing** of cycle/health data (directly answers post-Flo/post-Roe distrust — a primary B1 trust argument); local-first where feasible; full export + one-tap delete. Data-mapping + DPIA required before launch. Because B1 is the acquisition entry point, its consent + privacy UX is the reference implementation other states inherit.
- **Paywall integrity (product-compliance):** core logging + honest prediction + phase education stay free; paid tier adds depth only, never claws back basics (explicit anti-"bait-and-switch" stance vs. competitor pattern).
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** avoid medical-device trigger language; tracking/education framing keeps out of regulated-device territory (esp. important given Natural Cycles-style contraception apps ARE regulated devices — Femio must never drift toward that claim); legal review before store submission.
- **Medical-review boundary resolved:** named-app prediction accuracy and PMS/PMDD prevalence figures are excluded from public copy. Cycle and bleeding safety education uses [`MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md); B1 does not duplicate or silently alter its reviewed wording. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH / NHS / MedlinePlus / ACOG-patient / gov):**
- [Periods and period problems — NHS](https://www.nhs.uk/conditions/periods/period-problems/)
- [Irregular periods — NHS](https://www.nhs.uk/symptoms/irregular-periods/)
- [Heavy periods — NHS](https://www.nhs.uk/conditions/heavy-periods/)
- [Heavy and Abnormal Periods — ACOG (patient FAQ)](https://www.acog.org/womens-health/faqs/heavy-and-abnormal-periods)
- [Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign — ACOG Committee Opinion](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)
- [Physiology, Menstrual Cycle — StatPearls (NIH Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK500020/)
- [Proliferative and Follicular Phases of the Menstrual Cycle — StatPearls (NIH Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK542229/)
- [The Normal Menstrual Cycle and the Control of Ovulation — Endotext (NIH Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK279054/)

**Clinical — Tier 2 (society / hospital patient-education / peer-reviewed):**
- [Menstrual Cycle (Normal Menstruation): Overview & Phases — Cleveland Clinic](https://my.clevelandclinic.org/health/articles/10132-menstrual-cycle)
- [Abnormal Menstruation (Irregular Periods) — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/14633-abnormal-menstruation-periods)
- [Normal Menstrual Cycle — UCSF Center for Reproductive Health](https://crh.ucsf.edu/about-fertility/normal-menstrual-cycle)
- [Tracking mood symptoms across the menstrual cycle (EMA + HRV) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12198828/)
- [Variation in menstrual cycle length by age, race/ethnicity, and BMI — large digital cohort (medRxiv)](https://www.medrxiv.org/content/10.1101/2022.09.30.22280382.full.pdf)
- [Characterizing physiological and symptomatic variation in menstrual cycles using self-tracked mobile health data — arXiv](https://arxiv.org/pdf/1909.11211)

**Competitor / app landscape:**
- [Flo vs Clue vs Stardust: Period Apps Ranked (2026) — Unstar blog](https://unstar.app/blog/flo-clue-stardust-apple-health-period-tracking-apps-ranked-2026)
- [I Tried Clue vs Flo vs Glow — Longevity Advice](https://www.longevityadvice.com/best-free-period-tracker/)
- [Clue vs Flo: Which Period Tracker Is Actually Better? — Go-Go-Gaia](https://www.go-go-gaia.com/blog/clue-vs-flo.html)
- [Is Flo Period Tracker Safe? Why I Deleted It & Chose Stardust — Lemon8](https://www.lemon8-app.com/ellahanson/7280521200995238406?region=us)

**Privacy / trust (post-Flo, post-Roe):**
- [How period tracking apps and data privacy fit into a post-Roe climate — NPR](https://www.npr.org/2022/05/10/1097482967/roe-v-wade-supreme-court-abortion-period-apps)
- [Flo developing 'anonymous mode' to quell post-Roe privacy concerns — NPR](https://www.npr.org/2022/06/30/1108814577/period-tracker-app-flo-privacy-roe-v-wade)
- [Period-tracking apps try to reassure users after end of Roe — CNN Business](https://www.cnn.com/2022/07/08/tech/period-tracking-apps-data-privacy/index.html)
- ["I Deleted It After the Overturn of Roe v. Wade": Understanding Women's Privacy Concerns Toward Period-Tracking Apps — FTC PrivacyCon PDF](https://www.ftc.gov/system/files/ftc_gov/pdf/10-Laabadli-Understanding-Womens-Privacy-Concerns-Toward-Period-Tracking-Apps-in-the-Post-Roe-v-Wade-Era.pdf)

**Cross-references (internal):**
- `docs/09_MASTER_ADAPTATION_MODEL.md` — seven invariants, state object, constant core, universal events (§6), Z1 fallback, blending rules.
- `docs/personas/B6_pcos_not_ttc.md` — sibling B-band persona (irregular/PCOS branch off this hub).
