# Persona B10 — Vaginal & pelvic health: recurrent BV, yeast (candidiasis) & UTIs

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician." Medication content is educational only.
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC-default) · **Discreet-mode aware** (intimate topic, Arabic-first/MENA discretion)
> Inherits: the seven invariants, state object, constant core, universal events, Z1 fallback, and blending rules of `09_MASTER_ADAPTATION_MODEL.md`. This spec adds only B10-specific fields, config, content skin, red-flags, and non-universal transitions.

---

## A. Persona snapshot

**Who she is.** "Nour," 29. Over the last 18 months she has had what feels like a revolving door of "down there" problems — a fishy odor and grey discharge that keeps coming back weeks after antibiotics (BV), a couple of intensely itchy episodes with thick white discharge she self-treated with an over-the-counter cream (yeast), and two rounds of burning-when-she-pees urgency (UTI). She can't always tell which is which, has treated the wrong one more than once, and is exhausted and embarrassed. Arabic-first (also reads English), uses the web on her phone, and would be mortified if anyone glanced at her screen or a notification — this is the single most privacy-sensitive area of her health.

**What she lives with.**
- **Recurrence.** BV recurs in up to ~50% of women within 12 months of treatment; ~5% of women get ≥4 yeast infections a year (recurrent vulvovaginal candidiasis, RVVC); recurrent UTI = ≥2 in 6 months or ≥3 in a year [CDC; OWH; AUA/CUA/SUFU]. The loop itself is the defining burden.
- **Confusion between three different conditions that need different care.** BV (bacterial imbalance), yeast (fungal overgrowth), and UTI (urinary bacteria) overlap in her mind but are treated completely differently. Guessing wrong wastes weeks and money.
- **Misinformation & myths.** Douching, "feminine hygiene" washes, yogurt, and aggressive cleaning are widely believed to help — several actively raise BV risk [OWH; Cleveland Clinic].
- **Embarrassment & discretion.** Odor and intimate symptoms carry heavy shame, amplified in MENA/Arab contexts where intimate health is "ayb" (taboo) — a major barrier to seeking care [New Arab; ACM CHI "Digital Majlis"; UNFPA].

**Core emotional drivers.** Wants to *finally tell these three apart* without shame, to know what actually prevents recurrence vs. what's a myth, and to know *when the loop means "see a clinician," not another OTC guess*. Wants total discretion — nothing on screen or in a notification that outs her.

**Jobs-to-be-done.**
1. Log intimate symptoms (discharge character, odor, itch, urinary symptoms) privately and quickly, without cringe.
2. Understand *which* of BV / yeast / UTI a symptom cluster resembles — as **education**, never a diagnosis or a green light to self-treat.
3. Learn evidence-based prevention/self-care and have myths (douching, scented products) debunked.
4. Know the recurrence thresholds that mean "this warrants a clinician," and prep for that visit.
5. Do all of the above in a mode discreet enough to use in a shared household.

**Success = she stops buying the wrong OTC product on a guess, and walks into her clinician with a clear symptom timeline instead of shame.**

---

## B. Needs & questions (voice-of-user)

Mined from vaginal-health communities, app-store reviews, r/Healthygamergg-style anxiety framing, and qualitative studies (see Sources). Paraphrased to avoid quoting individuals.

**On telling them apart (the #1 pain):**
- "Is this BV or a yeast infection? The itch says yeast but the smell says BV and I have no idea."
- "I used Monistat and it did nothing — turns out it was BV, not yeast, the whole time."
- "How do I know if the burning is a UTI or just irritation from the yeast?"
- "Every symptom list online sounds like all three at once."

**On recurrence & feeling stuck:**
- "It comes back every single month right after my period / after sex. I'm so tired."
- "Three courses of antibiotics this year and it keeps returning. Is something wrong with me?"
- "At what point is this 'too many' and I need to push my doctor for a real work-up?"

**On myths & self-care:**
- "My mum swears by douching but I read it makes it worse — which is true?"
- "Do probiotics / boric acid / cranberry actually work or is it all marketing?"
- "What am I doing wrong? Is it my underwear, soap, my partner?"

**On embarrassment & discretion:**
- "I was too embarrassed to describe the smell to my doctor."
- "I'd die if my sister saw a period/discharge app notification pop up on my phone."
- "I want to track this but I don't want the word 'discharge' anywhere visible."

**On pregnancy / life-stage worry:**
- "I'm pregnant and got BV — does it hurt the baby?" (BV/UTI matter more in pregnancy — see D/J.)
- "Since menopause I keep getting UTIs and I'm dry — are these connected?" (GSM overlap — see D/J.)

**Top recurring questions Femio must answer in-product:**
1. What's the difference between BV, a yeast infection, and a UTI — and why do they need different care?
2. How can I tell which one my symptoms most resemble? (educational, non-diagnostic)
3. What actually prevents recurrence, and what myths (douching, scented washes) make it worse?
4. When does recurrence mean I should see a clinician rather than self-treat again?
5. Are OTC treatments okay, and when are they *not* okay (pregnancy, uncertainty, UTI)?
6. Does this matter more when I'm pregnant, or around menopause?

---

## C. Competitor teardown

Focused on where trackers fail on **vaginal-symptom depth, BV/yeast/UTI differentiation, myth-correction, and discretion** — the whitespace Femio targets.

| App / product | Model | Vaginal-symptom depth | BV/yeast/UTI differentiation | Myth-busting / prevention | Discretion | Gap Femio exploits |
|---|---|---|---|---|---|---|
| **Flo** | Freemium cycle app, AI | Broad symptom logging incl. discharge; centered on cycle/fertility | Some educational articles; not a differentiation tool; TTC-leaning | Generic tips | Weak — cycle/fertility framing, **FTC settlement (2021) for data-sharing; class settlement (2025)** | Purpose-built vaginal-health tracker + explicit (non-diagnostic) BV-vs-yeast-vs-UTI education + discreet mode + privacy-by-design |
| **Clue** | Freemium, science-forward | Neutral symptom taxonomy incl. discharge/fluid | Good general education, not a symptom-differentiator | Reasonable, evidence-based | Better GDPR posture | Condition-specific differentiation layer, recurrence-aware routing, Arabic-first/RTL |
| **Evvy** | At-home vaginal microbiome test (mNGS) + telehealth, ~$99–129/test | Deep (sequences 700+ microbes); symptom tracking of itch/discharge/odor | Strongest clinically — but **lab-test + Rx product, US-only, paid** | Content strong | Discreet packaging; still a paid test kit | Femio = free, global, web-first *education + tracking* layer that helps her decide when to seek testing/care — not a test or Rx |
| **Stardust** | Privacy-forward cycle app | Symptom/flow logs | Minimal | Minimal | **Strong: local-first, privacy-forward** | Clinical credibility + condition depth + differentiation education |
| **Uqora** | UTI-focused supplements + education | UTI-centric | UTI only; product-selling incentive | UTI prevention content (commerce-biased) | Consumer brand | Neutral, non-commercial, referenced content covering all three conditions |
| **"Feminine hygiene" brand apps/sites** | Product marketing | Shallow | None | **Often perpetuate myths** (washes/douches) | Varies | Actively debunks the myths these brands sell |

**Cross-cutting whitespace:** No mainstream free tracker treats **BV / yeast / UTI differentiation, recurrence-routing, and myth-correction** as a first-class, discreet, referenced module. Cycle apps bury discharge inside fertility framing; the best differentiation product (Evvy) is a paid US test kit. Femio's opening: a **discreet, referenced, non-diagnostic vaginal-health mode** that helps her tell the three apart, correct myths, and know when the loop warrants a clinician — globally and Arabic-first.

---

## D. Clinical grounding (cited)

All framing below is **educational**. Femio does not diagnose, does not treat, and does not tell her which condition she has or what to take. Where a symptom pattern is described, it is always paired with "these can overlap; only a clinician/test can confirm."

**The three conditions differ in cause, symptoms, and care — this is the core teaching.**

| | Bacterial vaginosis (BV) | Vaginal yeast (candidiasis) | Urinary tract infection (UTI) |
|---|---|---|---|
| **Cause** | Imbalance/overgrowth of vaginal bacteria (loss of protective lactobacilli) | Overgrowth of *Candida* fungus | Bacteria in the urinary tract (usually *E. coli*) |
| **Typical symptoms** | Thin grey/white discharge, **fishy odor** (often stronger after sex), possible itch/irritation | **Intense itch**, thick white "cottage-cheese" discharge, soreness; usually **no strong odor** | **Burning on urination**, urinary urgency/frequency, lower-abdomen pressure; usually **no change in discharge** |
| **Usual care (educational)** | Prescription antibiotics — e.g. metronidazole or clindamycin (oral or vaginal) [CDC 2021 STI Guidelines] | Antifungals — OTC or prescription (e.g. azoles); oral fluconazole avoided in pregnancy [OWH; ACOG] | Diagnosed by urine test; treated with antibiotics [MedlinePlus; AUA] |
| **Key point** | OTC yeast creams **do not** treat BV | Antibiotics **do not** treat yeast (and can trigger it) | Neither a vaginal cream nor an antifungal treats a UTI |

Sources: [CDC BV STI Treatment Guidelines](https://www.cdc.gov/std/treatment-guidelines/bv.htm); [OWH — Vaginal yeast infections](https://womenshealth.gov/a-z-topics/vaginal-yeast-infections); [MedlinePlus — UTIs](https://medlineplus.gov/urinarytractinfections.html); [MedicalNewsToday — BV vs yeast](https://www.medicalnewstoday.com/articles/bacterial-vaginosis-vs-yeast-infection).

**Why differentiation matters (the misdiagnosis trap).** BV and yeast share itch/discharge but need opposite treatments (antibiotic vs antifungal); self-treating the wrong one wastes time and can worsen the balance. The evidence-based message: **if symptoms are new, uncertain, recurrent, or don't resolve, get it checked rather than guessing** [OWH; CDC].

**Recurrence — the defining feature of this persona.**
- **BV:** up to ~50% recur within 12 months of treatment; there is currently no US-approved therapy specifically for *preventing* recurrence [PMC review; medRxiv trials].
- **Yeast (RVVC):** ~5% of women get ≥4 per year; recurrence warrants clinician evaluation for risk factors (e.g. diabetes, immune issues) [OWH; ACOG Practice Bulletin 215].
- **UTI (recurrent):** ≥2 in 6 months or ≥3 in 12 months; warrants clinician management and possibly a work-up [AUA/CUA/SUFU 2019/2025 Guideline; PMC].

**Prevention & self-care (evidence-based) vs. myths.**
- **Do NOT douche** — douching disrupts the natural bacterial balance and **raises** BV risk [OWH; Cleveland Clinic].
- **Avoid scented "feminine hygiene" washes/sprays**, which can irritate and disrupt flora [Cleveland Clinic].
- UTI-modifiable factors a clinician may discuss: sexual activity and **spermicide** use; hydration; wiping/voiding habits [AUA]. **Cranberry evidence is conflicting** — no firm recommendation for or against [AUA/CUA/SUFU].
- **Probiotics / boric acid / vaginal lactobacillus** for recurrent BV: promising but still-limited evidence; a preference-sensitive option to **discuss with a clinician**, not a Femio recommendation [PMC narrative review; LACTIN-V trials].
- Condoms may reduce BV recurrence; routine treatment of male partners is **not** currently CDC-recommended for BV [CDC].

**Pregnancy interplay (matters more — see §J).** The [CDC STI Treatment Guidelines, 2021](https://www.cdc.gov/mmwr/volumes/70/rr/RR7004a1.htm) state that symptomatic BV in pregnancy is associated with adverse outcomes including premature rupture of membranes, preterm birth, intra-amniotic infection, and postpartum endometritis, and recommend evaluation and treatment of symptomatic pregnant patients. Routine screening of asymptomatic pregnant people to prevent preterm birth is not recommended. Femio gives no odds ratio, trimester-specific risk, diagnosis, or regimen and routes pregnancy symptoms to a clinician before self-treatment. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

**Menopause interplay — GSM overlap (see §J).** After menopause, falling estrogen thins genitourinary tissue (**genitourinary syndrome of menopause, GSM**), causing dryness, irritation, and **recurrent UTIs**; symptoms can mimic or coexist with infection. Local vaginal estrogen is a clinician-managed option. This is the bridge to persona **F6** (menopause / GSM) [Johns Hopkins; StatPearls; Cleveland Clinic].

**When to see a clinician (educational routing, never triage).** New/uncertain symptoms; first-ever episode; symptoms not resolving after appropriate care; **recurrence** at the thresholds above; pregnancy; fever/pelvic or back pain/blood in urine (possible upper-UTI red flag); or simply not being sure which condition it is [OWH; MedlinePlus; AUA].

**Femio scope guardrail restated:** all of the above is presented as **wellness education, symptom tracking, and screening**, with consistent "discuss with your clinician" routing. Femio never says "you have BV/yeast/a UTI," never tells her which product to use or dose, and is not contraception.

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Vaginal-health mode + Discreet mode** — a dedicated, opt-in mode that surfaces symptom logging and BV/yeast/UTI education; pairs with a **Discreet mode** (neutral app name/icon label option, generic/neutral notification text with no intimate words, quick-hide/blur, optional PIN). Default copy in this mode avoids explicit terms on any surface visible without unlocking.
2. **Intimate-symptom tracker** — quick, low-cringe logging of discharge (amount, color, consistency incl. "cottage-cheese"/"grey/thin"), **odor** (none/fishy/other), **itch/irritation**, and **urinary symptoms** (burning, urgency, frequency), plus timing relative to period/sex.
3. **"Tell them apart" educational explainer** (non-diagnostic) — an interactive, referenced comparison of BV vs yeast vs UTI based on her logged pattern, always returning "this resembles X patterns — but these overlap; only a clinician/test can confirm. Here's when to get it checked."
4. **Recurrence tracker + clinician-routing** — counts episodes over rolling windows and, at evidence-based thresholds (≥4 yeast/yr; ≥2 UTI/6mo or ≥3/yr; BV returning after treatment), surfaces a non-alarming "many clinicians suggest a check-in — here's why" prompt + visit-prep.
5. **Myth-busting prevention library** — douching, scented washes, cranberry, probiotics, boric acid — evidence-based, clearly separating "reduces risk," "conflicting evidence," and "can make it worse."
6. **Privacy-by-design** — special-category health data; no ad/analytics-SDK sharing; local-first where feasible; export/delete; discreet notifications by default.

**P1 — strong differentiators.**
7. Referenced, medically-reviewed content library (Arabic-first + EN/FR/ES), grade 6–8.
8. **OTC-vs-clinician decision education** — when OTC antifungal is reasonable vs when to see a clinician first (first episode, uncertainty, recurrence, pregnancy, UTI symptoms — UTIs need a clinician/urine test).
9. Visit-prep pack — exportable symptom timeline, odor/discharge/urinary summary, questions, and recurrence count to hand to a clinician (counters "too embarrassed to describe it").
10. Pregnancy-aware and menopause(GSM)-aware content surfacing (routes to D-track flags and F6).

**P2 — depth / retention.**
11. Trend correlations ("your BV-pattern logs cluster in the week after your period / after sex") — descriptive pattern insight, never causal/diagnostic.
12. Trigger/self-care journal (products used, response) to help her and her clinician spot patterns.
13. Gentle reminder to finish a full course of care and re-check symptoms (educational adherence support, never dosing).

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **BV vs yeast vs UTI — the essential differences** — cause, symptoms, and why each needs different care; the "wrong OTC" trap.
2. **What's normal discharge?** — healthy variation across the cycle vs. changes worth noting; reduces false alarm and shame.
3. **Bacterial vaginosis explained** — what it is, the fishy-odor pattern, why it recurs, care landscape (educational).
4. **Yeast infections explained** — the itch/cottage-cheese pattern, OTC vs clinician, recurrent (RVVC) and when to seek evaluation.
5. **UTIs explained** — why urinary symptoms need a urine test and clinician, upper-UTI red flags (fever/back pain/blood).
6. **Recurrence: why it happens & when to get help** — the thresholds (≥4 yeast/yr; ≥2 UTI/6mo; BV returning), what a work-up can involve.
7. **Prevention that works vs. myths** — **don't douche**; skip scented washes; the truth on cranberry (conflicting), probiotics/boric acid (limited, discuss with clinician), condoms/spermicide.
8. **Self-care & comfort** — evidence-based soothing, cotton underwear, avoiding irritants — framed as comfort, not cure.
9. **Talking to your clinician without embarrassment** — how to describe odor/discharge/urinary symptoms, what to bring, advocating if dismissed (discretion-aware).
10. **Vaginal health in pregnancy** — why BV/UTI matter more; see a clinician before treating; medication-safety notes (educational; fluconazole avoided).
11. **Vaginal & urinary changes around menopause (GSM)** — dryness, recurrent UTIs, the estrogen link; bridges to menopause content (F6).
12. **Myths & culture** — gentle, respectful correction of common intimate-hygiene beliefs; affirming that these conditions are common and not shameful.

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer. Discreet-mode copy variant for titles/notifications.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Intimate-symptom log: discharge (amount/color/consistency), odor (none/fishy/other), itch/irritation, urinary symptoms (burning/urgency/frequency), pain, timing vs period/sex.
- Episode log: suspected-pattern label (self-selected, non-diagnostic), care taken (OTC/prescription/none — educational record), response/resolution date.
- Optional product/trigger journal; optional private notes.

**Tools**
- **"Tell them apart" explainer** (non-diagnostic) — maps her logged pattern to BV/yeast/UTI *education*, always with overlap caveat + "when to get checked."
- **Recurrence counter** — rolling-window episode counts per condition against educational thresholds.
- **Visit-prep generator** — one-tap export/print: symptom timeline + odor/discharge/urinary summary + recurrence count + questions.
- **Screeners (framed as screening, not diagnosis):**
  - Symptom-pattern checklist → "These can be signs to discuss; symptoms overlap and only a clinician/test can confirm."
  - Recurrence check → routes to clinician-check prompt + visit-prep when thresholds crossed.

**Alerts (all non-alarming, screening-framed, dismissible, localized/RTL, discreet-mode copy)**
- Recurrence-threshold clinician-check prompt (educational, cites why recurrence warrants a check).
- **Red-flag box** (education only, not triage): fever, pelvic/lower-back pain, blood in urine, symptoms in pregnancy, or symptoms not resolving → "seek care" messaging + saved contact as education.
- Optional "re-check symptoms after finishing care" nudge (adherence support, never dosing).
- **Never:** "you have BV/yeast/a UTI"; never names a specific product/dose to take; never a douching/scented-product suggestion; never a disease-prevention or contraception claim.

**Discreet-mode behavior:** notifications use neutral wording ("Femio check-in") with no intimate terms; hero/labels use neutral language until unlocked; quick-hide gesture; optional PIN/biometric.

---

## H. EMR / data fields (constant core + persona layer)

**Constant core (inherited — see model §3):** account/age/locale/RTL/units; consent & privacy flags (incl. `discreet_mode`, `ads_off`); cycle events; generic symptom/mood log; meds_supplements[]; conditions_flagged[] (non-diagnostic); screener_results[] (timestamped).

**Persona layer (B10 — vaginal & pelvic health), additive & non-destructive:**
- `vaginal_health_mode` flag (ON) + `discreet_mode` flag.
- Discharge log: amount, color, consistency (structured options incl. cottage-cheese/thin-grey).
- Odor log: none / fishy / other.
- Itch/irritation log; vulvovaginal pain.
- Urinary-symptom log: burning, urgency, frequency, blood-in-urine flag (red-flag routing).
- Episode records: date, self-selected pattern label (non-diagnostic), care-taken (educational record: OTC/prescription/none), resolution date.
- Recurrence counters per condition (rolling 6/12-month windows) — drive awareness prompts.
- Product/trigger journal (e.g. washes, spermicide, condoms) — self-report, non-judgmental.
- User-entered results (e.g. clinician diagnosis note, urine/swab result) — **entry only, no interpretation as diagnosis**.
- Life-stage interplay flags: `pregnancy_flag` (elevates BV/UTI content), `gsm_overlap_flag` (menopause bridge → F6).
- TTC intent flag = **false** by default (reachable toggle).

*All health fields optional, encrypted, user-deletable; nothing about intimate symptoms is ever required to use the app; discreet mode governs all visible surfaces.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B10):**
- Q life stage → "tracking my cycle / general" or "a specific concern"; Q concern → **"vaginal/intimate or urinary symptoms"** ⇒ set **vaginal_health_mode ON**.
- Q "Would you like Discreet mode?" (explained: neutral labels + notifications, quick-hide) ⇒ set `discreet_mode` (defaulted ON for MENA/Arabic locales, user-confirmable).
- Q "What's bothering you most?" (multi-select: discharge/odor, itch, urinary symptoms, recurrence, prevention/myths) ⇒ orders home modules.
- Q "Are you pregnant?" / age signals ⇒ set pregnancy or GSM interplay flags (route emphasis, not access).

**Home configuration (default for B10):**
- Hero = quick intimate-symptom log + "Tell them apart" explainer entry (neutral-labeled in discreet mode).
- Cards prioritized by her concern selection (e.g. myth-busting surfaced if she flagged prevention; recurrence card if she flagged recurrence).
- Visit-prep and recurrence tools pinned.
- Cycle/fertility widgets present but not centered; fertile-window/pregnancy widgets hidden by default (non-TTC default).

**Hidden-but-reachable principle:** Femio never removes knowledge. Cycle tracking, TTC, pregnancy, and menopause content stay discoverable via search and "Explore other life stages." Explicit content is reachable but discreet-labeled until unlocked.

**Adaptive tuning:** repeated same-pattern episodes → raise the matching condition's education + recurrence-check prominence. Any urinary red-flag or pregnancy flag → elevate "seek care" content. Age/symptom signals of GSM → surface menopause-overlap module and offer F6 route.

---

## J. Adaptation triggers (life-stage routing)

Inherits all **universal events** (positive test, loss, mood-crisis, red-flag symptom, disengagement, toggle-off, age-of-consent) from model §6. Below are **B10-specific** transitions only.

| Trigger | System response | Route |
|---|---|---|
| **Recurrence threshold crossed** (≥4 yeast/yr; ≥2 UTI/6mo or ≥3/yr; BV returning after treatment) | Non-alarming "many clinicians suggest a check-in — here's why" prompt + recurrence-aware content + auto-populated visit-prep pack | **Stay B10**, raise clinician-routing prominence |
| **Urinary red-flag** (fever, back/flank pain, blood in urine) | Prominent educational "seek care now" box + saved contact as education; log stays raw; never triage/diagnosis | Stay B10 (emergency messaging, content only) |
| **Positive pregnancy test logged** | Universal positive-test handler + **elevate BV/UTI stakes**: surface "vaginal health in pregnancy" (preterm/PROM context), "see a clinician before treating," fluconazole-avoided note; carry symptom logs | **Route to D-track**, `pregnancy_flag`; BV/UTI content **weighted up** (matters more) |
| **Sets TTC intent = true** | Confirm; keep vaginal-health tracking; add preconception + "treat infections before/around conception" education (clinician-led) | Route to C-track, keep B10 layer |
| **Menopause / GSM overlap** (age 40s+, vaginal dryness, painful sex, recurrent UTIs) | Introduce GSM education; clarify infection-vs-atrophy overlap; explain local-estrogen option (educational); keep symptom logic | **Blend B10 + menopause; offer route to persona F6** |
| **Repeated wrong-OTC pattern** (e.g. logs antifungal use then unresolved BV-pattern symptoms) | Surface "BV vs yeast — why OTC yeast creams don't treat BV" + gentle "get it checked to be sure" | Stay B10, raise differentiation education |
| **Mood screen trends low / crisis flag** | Universal handler: mental-health module + localized crisis resources (recurrence + shame carry real distress) | Stay B10 |
| **User toggles off vaginal-health / discreet mode** | Revert to generic logic; preserve all history (archived-but-reachable) | General reproductive-age band / Z1 |

All transitions require **explicit, reversible confirmation**, preserve data continuity, and never lock her out of prior/other content.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking ONLY. No diagnosis, no treatment, no disease-prevention claim, not contraception. The "Tell them apart" explainer is **educational pattern information**, never a diagnosis or a treatment green light. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — symptoms overlap; discuss with a clinician." Never outputs "You have BV / yeast / a UTI."
- **Medication content** (metronidazole, clindamycin, antifungals/azoles, fluconazole, boric acid, probiotics, cranberry): **educational context only** — what it is and why a clinician might discuss it; no recommendation, no dosing, no "take this." Explicit non-prescription disclaimer + clinician routing. **UTI content must direct to a clinician/urine test** (not self-treatable OTC).
- **Pregnancy safety:** pregnancy content must say "see a clinician before treating"; flag oral fluconazole as generally avoided in pregnancy (educational, cite OWH/ACOG); never suggest a self-treatment in pregnancy.
- **Myth-correction integrity:** actively debunk douching and scented "feminine hygiene" products with sourced rationale; clearly grade evidence (reduces risk / conflicting / can worsen). Never surface a myth as advice.
- **Red flags:** fever, flank/back pain, blood in urine, pregnancy symptoms, non-resolving symptoms → educational "seek care" messaging, never triage.
- **Mental health:** recurrence + intimate shame carry real distress; crisis resources on any low screen; localized per region/language.
- **Discretion / cultural sensitivity:** Discreet mode (neutral labels + notifications, quick-hide, optional PIN) available and defaulted-on for Arabic/MENA locales; no intimate terms on any surface visible without unlocking; respectful, non-shaming, "ayb"-aware copy. Arabic-first with RTL QA.
- **Privacy (GDPR/PDPL health data):** intimate/sexual-health data = special-category and among the most sensitive; explicit granular consent, purpose limitation, **no ad-SDK/third-party sharing** (post-Flo distrust); local-first where feasible; full export/delete; no partner/employer/insurer visibility. DPIA required before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** framing as tracking/education (not diagnosis/device); legal review before store submission.
- **Claims boundary resolved:** no trimester-specific BV odds, competitor prediction/accuracy statistic, or competitor recurrence-rate statistic is public. Pregnancy wording is limited to the [CDC STI Treatment Guidelines, 2021](https://www.cdc.gov/mmwr/volumes/70/rr/RR7004a1.htm) association and clinician-routing scope above. *(Reviewed Mohamed K., 24 July 2026; next review 24 July 2027.)*

---

## Sources

**Clinical — Tier 1 (CDC/NIH/NHS/MedlinePlus/OWH):**
- [Bacterial Vaginosis — CDC STI Treatment Guidelines, 2021](https://www.cdc.gov/std/treatment-guidelines/bv.htm)
- [STI Treatment Guidelines, 2021 — MMWR (CDC)](https://www.cdc.gov/mmwr/volumes/70/rr/rr7004a1.htm)
- [Vaginal yeast infections — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/a-z-topics/vaginal-yeast-infections)
- [Urinary Tract Infections — MedlinePlus (NIH)](https://medlineplus.gov/urinarytractinfections.html)
- [Genitourinary Syndrome of Menopause — StatPearls (NCBI Bookshelf)](https://www.ncbi.nlm.nih.gov/books/NBK559297/)

**Clinical — Tier 2 (ACOG/IDSA/AUA / society / peer-reviewed):**
- [Diagnosis & Management of BV: evidence for 2021 CDC STI Guidelines — Clinical Infectious Diseases (IDSA-adjacent)](https://academic.oup.com/cid/article/74/Supplement_2/S144/6567952)
- [Recurrent Uncomplicated UTIs in Women: AUA/CUA/SUFU Guideline (2025)](https://www.auanet.org/guidelines-and-quality/guidelines/recurrent-uti)
- [AUA/CUA/SUFU Recurrent UTI Guideline — Journal of Urology](https://www.auajournals.org/doi/10.1097/JU.0000000000000296)
- [ACOG Practice Bulletin 215 — Vaginitis in Nonpregnant Patients (PDF)](https://www.aruplab.com/files/resources/infectious-disease/ACOG_Practice_Bulletin_Number_215.pdf)
- [Guidelines for diagnosis & management of recurrent UTI in women — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3202002/)
- [Recurrent Bacterial Vaginosis: Case Report & Review of Management — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10169974/)
- [Probiotics as a Preventive Strategy for Recurrent BV: Narrative Review — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12423726/)
- [Response to antibiotic treatment predicts LACTIN-V effectiveness in recurrent BV — medRxiv](https://www.medrxiv.org/content/10.1101/2023.10.19.23297283.full.pdf)
- [Genitourinary Syndrome of Menopause — Johns Hopkins Medicine](https://www.hopkinsmedicine.org/health/expert-qa/genitourinary-syndrome-of-menopause)
- [BV during pregnancy & preterm birth / pregnancy loss — Contemporary OB/GYN](https://www.contemporaryobgyn.net/view/bacterial-vaginosis-during-pregnancy-may-heighten-risk-of-preterm-birth-pregnancy-loss)
- [Maternal & fetal outcomes of pregnant women with BV — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC9968788/)
- [Bacterial Vaginosis: Causes, Symptoms & Treatment — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/3963-bacterial-vaginosis)
- [Recurrent (Chronic) UTIs — Cleveland Clinic](https://my.clevelandclinic.org/health/diseases/recurrent-uti)

**Patient journey / needs & differentiation (patient-facing + comparative):**
- [Bacterial vaginosis vs. yeast infection: how to tell — Medical News Today](https://www.medicalnewstoday.com/articles/bacterial-vaginosis-vs-yeast-infection)
- [Yeast infection vs UTI — Evvy](https://www.evvy.com/blog/yeast-infection-vs-uti)
- [8 Tips to Stop BV From Recurring — UW Medicine (Right as Rain)](https://rightasrain.uwmedicine.org/well/health/bacterial-vaginosis)

**Competitor / app & product landscape:**
- [Evvy — Vaginal Microbiome Test & Care](https://www.evvy.com/)
- [Remote BV Management via Metagenomic Testing & Telemedicine — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12298078/)
- [Flo FTC / data-sharing context — (see B6 spec Sources; verify before public use)]

**Cultural / MENA discretion:**
- [From taboo to revelation: Arab women find sexual freedom online — The New Arab](https://www.newarab.com/features/taboo-revelation-arab-women-find-sexual-freedom-online)
- [Digital Majlis: Fostering Conversations on Intimate Health among Arab Muslim Women — ACM CHI](https://dl.acm.org/doi/10.1145/3772318.3790913)
- [Understanding Cultural & Religious Values Relating to Women's Intimate Health among Arab Muslims — ACM CHI](https://dl.acm.org/doi/fullHtml/10.1145/3613904.3642207)
- [AI chatbots as 'pocket doctors': intimate health support for young women in Lebanon — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12625598/)
- [First menstruation often accompanied by fear, shame — UNFPA](https://www.unfpa.org/news/first-menstruation-often-accompanied-fear-shame-lack-information-women-and-girls-arab-states)
