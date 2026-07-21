# Persona D17 — Rh-Negative Pregnancy (Rh Incompatibility / Risk of Alloimmunization)

Prepared: 2026-07-17 · Wave 3 · Status: research + spec
Layered on: **D1 (uncomplicated pregnancy)** — inherits its week-by-week spine, appointment/checklist engine, red-flag safety layer, and all D1 content unless overridden here.
Aligns with: 09_MASTER_ADAPTATION_MODEL · 08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX · D1_pregnancy_uncomplicated · femio-compliance-privacy · femio-medical-content skills
Scope guardrail (inherited, non-negotiable): **wellness / education / tracking only. Never diagnose, treat, or prevent. Screeners = "screening — discuss with your clinician." Medication and immunoglobulin content (anti-D / Rh immune globulin) is educational only — never a dose, never an instruction to take or skip it.**

---

## A. Persona snapshot

**Who she is.** A pregnant woman whose booking blood test shows she is **RhD-negative** (roughly 15% of people of European ancestry, lower in African and Asian populations — worth localizing). She is otherwise low-risk (a D1 pregnancy in every other respect): the RhD-negative status is a *modifier layered on D1*, not a separate track. Two clearly distinct sub-populations sit inside this persona and must never be conflated:

- **D17-a — RhD-negative, NOT sensitized (the large majority, ~99% with modern care).** Her pregnancy is managed almost identically to D1. Her only additions are: understanding what Rh-negative means, an **awareness of the anti-D immunoglobulin schedule** (routine dose around 28 weeks; a postnatal dose if the baby is confirmed RhD-positive; extra doses after "sensitizing events"), and knowing which events should prompt a call to her clinician. Her dominant need is **reassurance** — this is a well-solved, highly preventable problem, and first pregnancies are rarely affected.
- **D17-b — already SENSITIZED (has anti-D / red-cell antibodies; the small minority).** Anti-D no longer helps her (it only *prevents* sensitization). Her pregnancy involves **closer monitoring** — antibody titre tracking and, if a critical titre is reached, specialist fetal surveillance (middle-cerebral-artery Doppler) for haemolytic disease of the fetus and newborn (HDFN). Her emotional load is higher; her content skin is heavier and calmer. The resolver keys D17-b on a **user-recorded "clinician told me I have antibodies / I'm sensitized" flag**, never on app inference.

**Core job (D17-a).** "Tell me plainly what Rh-negative means, why it usually only matters for a *future* baby, what the anti-D injections are for and roughly when they happen, and what kinds of events (a bump, bleeding, a procedure) mean I should ring my midwife — without scaring me, because I've read frightening things online."

**Core job (D17-b).** "My clinician says I have antibodies. Help me keep track of my monitoring appointments and understand my titres and scans as *education*, and route me to my specialist team calmly — don't pretend it's routine, and don't catastrophize."

**Emotional arc.** RhD-negative status is discovered at booking and can trigger disproportionate anxiety, fed by frightening or pseudoscientific web content ("Rh-negative causes miscarriage," blood-type mysticism). The evidence is reassuring: an unsensitized first pregnancy is generally unaffected, and combined antenatal + postnatal anti-D prophylaxis is ~99% effective at preventing sensitization. Femio's job is to **defuse, not amplify** — and to gently correct the common myth that Rh-negative blood type itself causes early miscarriage (it does not). For D17-b the arc is genuinely heavier and the tone shifts to steady, appointment-anchored support.

**Context.** Web-first, mobile-heavy, Arabic-first / RTL with EN/AR/FR/ES. She may open the app anxiously right after her booking bloods, then intermittently around the 28-week dose and any incident. Success = she understands her status, is *aware* of (never instructed on) the anti-D schedule, knows the "when to call" triggers, keeps her injection/appointment state in one place, and feels calmer rather than more frightened.

---

## B. Needs & questions (voice-of-user)

Mined from r/BabyBumps and pregnancy forums (Mumsnet, What to Expect / BabyCenter community), plus lay-education FAQs (ACOG, Cleveland Clinic, KidsHealth). Representative paraphrases, grouped by job-to-be-done.

**"What does Rh-negative even mean?" (orientation, dominant early)**
- "My notes say I'm A-negative — the midwife said I'll need an injection. What is this and should I worry?"
- "Both my partner and I are negative — do I still need anything?" (if father is confirmed RhD-negative, the baby is RhD-negative and anti-D isn't needed — but this is a clinician's determination)
- "Why does it matter for the *next* baby and not this one?"

**Reassurance + myth-correction (strong signal)**
- "I had a miscarriage and I'm Rh-negative — did my blood type cause it?" (recurring, painful; answer: an Rh-negative group is *not* a cause of early first-pregnancy loss)
- "The internet says Rh-negative people are 'different' / at huge risk — is any of this true?"
- "This is my first pregnancy, everyone says the first is fine — is that right?"

**Anti-D injection awareness (the practical core of D17-a)**
- "When do I get the anti-D / RhoGAM shot?" (routine dose ~28 weeks; postnatal dose within 72h if baby is RhD-positive)
- "Is the injection safe? What's actually in it?" (it's a blood product — educational framing, defer safety questions to clinician)
- "I got anti-D at 28 weeks — why might I need *another* one after birth?"
- "Do I need it if I'm having a planned C-section / after a bleed / after my amnio?"
- "There's a blood test that can tell if my baby is Rh-positive so I can skip the injection if not — is that available where I am?" (cell-free fetal RHD genotyping — offered in some health systems)

**Sensitizing-event triggers ("should I call?")**
- "I had some bleeding at 25 weeks — do I need the injection now, not just at 28?"
- "I fell / was in a minor car accident / had a bump to my belly — do I need to be checked?"
- "I'm booked for an amniocentesis / had an ECV to turn the baby — does that need anti-D?"

**Already-sensitized subgroup (D17-b, smaller but higher-need)**
- "My bloods show antibodies — what does a 'titre' mean and why are they checking it every few weeks?"
- "They mentioned an MCA Doppler scan — what is it looking for?"
- "Anti-D won't work for me now — why?"
- "What is HDFN and how worried should I be?"

**Cross-cutting frustrations (design brief for Femio)**
- Rh-negative content online is either terrifying, pseudoscientific, or so clinical it's unreadable — nobody explains it *calmly* at a grade 6–8 level.
- Apps forget her blood type / don't connect it to her appointment reminders.
- Loss handled badly (an Rh-negative user who miscarries is exactly who the "did my blood type do this?" myth hurts most — tone must be gentle and corrective).

---

## C. Competitor teardown

Inherits D1's full teardown (What to Expect, BabyCenter, Pregnancy+, Ovia, Flo, The Bump) and its **privacy wedge** (data-sale / ad-SDK / employer-visibility failures across the incumbents). Focus here is the **Rh-specific education gap**.

| Capability (Rh-specific) | Incumbent apps | Gap Femio exploits |
|---|---|---|
| Explains "what Rh-negative means" at grade 6–8 | Usually a single generic article buried in a library; rarely surfaced to the RhD-negative user specifically | Surface a **status-aware primer** the moment blood type = negative is on record |
| Anti-D schedule *awareness* (28-wk / postnatal / events) | Mostly absent or a passing mention; no schedule-linked reminders | Optional, opt-in **anti-D awareness card + appointment reminders**, framed as education not instruction |
| Sensitizing-event "when to call" guidance | Effectively absent | Dedicated **sensitizing-event explainer + red-flag routing** |
| Myth-correction (Rh-negative ≠ miscarriage cause) | Absent; forums actively spread the myth | Explicit, gentle myth-correction module, loss-aware |
| Already-sensitized monitoring education (titres, MCA Doppler, HDFN) | Absent | Calm **D17-b education skin**, appointment-anchored, non-diagnostic |
| Fetal RHD genotyping / targeted prophylaxis awareness | Absent | Educational "this test exists in some systems — ask your clinician" note |
| Arabic-first / RTL Rh education | Absent (EN-centric) | Femio's core differentiator |

**Femio's differentiated position for D17.** (1) The only calm, cited, myth-correcting Rh-negative explainer done at reading level and in Arabic-first RTL. (2) Anti-D injection *awareness* wired into the appointment engine — reminders that a dose is *usually scheduled* around now, always "your clinic sets the plan," never "take your dose." (3) A distinct, dignified path for the sensitized minority instead of pretending everyone is the same. (4) Continuity: her blood type lives on the one account, connected to reminders and loss-handling.

---

## D. Clinical grounding (cited)

All figures are **education, not medical advice**; app copy attributes to these bodies and defers all decisions and dosing to the user's clinician. Tier-1 = NIH/MedlinePlus/CDC/NHS; Tier-2 = ACOG/RCOG/NICE.

**What Rh-negative means & why it matters.** RhD is a protein on red blood cells; "RhD-negative" means it is absent. If an RhD-negative woman carries an RhD-positive baby, fetal red cells crossing into her bloodstream (mainly at delivery, but also with bleeding, trauma, or procedures) can prompt her immune system to make anti-D antibodies — "sensitization" / alloimmunization. In a **first, unsensitized pregnancy the baby is generally unaffected** because antibodies haven't yet formed; the risk is chiefly to a **future** RhD-positive baby, where maternal antibodies can cross the placenta and destroy fetal red cells, causing **haemolytic disease of the fetus and newborn (HDFN)** — anaemia, jaundice, and in severe cases serious harm. [MedlinePlus; NHS; ACOG FAQ; Cleveland Clinic] → App framing: lead with reassurance + "this is a well-understood, highly preventable situation."

**Scale of the problem, and how well prophylaxis works.** Before prophylaxis, ~10–20% of RhD-negative mothers carrying RhD-positive infants became sensitized; with routine anti-D immune globulin the risk is now **under 1%**, and combined antenatal + postnatal prophylaxis is roughly **99% effective** at preventing sensitization. [Medscape; RhoGAM/PMC HDFN review; NHS] → Reassurance backbone.

**Anti-D immunoglobulin — what it is and the schedule (AWARENESS, not instruction).** Anti-D immunoglobulin (Rh immune globulin; brand e.g. RhoGAM) is a blood product that "hides" any RhD-positive fetal cells from the mother's immune system, preventing her from making anti-D. It only **prevents** sensitization — it does nothing once antibodies already exist. Typical schedule for an unsensitized RhD-negative woman:
- **Routine antenatal dose around 28 weeks** (some regimens: one dose ~28–30 wk; others two doses, ~28 and ~34 wk). [NHS; NICE TA156; ACOG PB181]
- **Postnatal dose if the baby is confirmed RhD-positive**, ideally **within 72 hours of birth**. [NHS; ACOG PB181]
- **After a potentially sensitizing event** (see below), a dose ideally **within 72 hours** — and, if that window is missed, still worthwhile up to ~10 days (effectiveness diminishing). [NHS/BSH; ACOG PB181]
→ App framing: an **awareness card + optional reminder** ("a routine anti-D dose is usually offered around now — your clinic decides"), never "take your anti-D." Safety/what's-in-it questions defer to clinician.

**Potentially sensitizing events (the "when to contact your clinician" list).** Events where fetal-maternal bleeding can occur and anti-D is typically considered for an unsensitized RhD-negative woman: **vaginal bleeding / antepartum haemorrhage**; **abdominal trauma** (a fall, a knock to the bump, a car accident); **miscarriage or threatened miscarriage, ectopic pregnancy, termination**; **invasive procedures — amniocentesis, chorionic villus sampling (CVS), cordocentesis**; **external cephalic version (ECV)** to turn a breech baby; **molar-pregnancy evacuation**; and **birth itself**. As little as **0.1 mL** of RhD-positive fetal cells can be sensitizing; amniocentesis and ECV each carry a ~2–6% fetomaternal-haemorrhage risk. For events after ~20 weeks a **Kleihauer test** estimates the bleed size. [ACOG PB181; NHS/BSH; RCOG] → These populate Femio's sensitizing-event explainer and a red-flag "contact your maternity team" box — framed as *reasons to call promptly so your team can decide about anti-D*, never as diagnosis.

**Cell-free fetal RHD genotyping (targeted prophylaxis).** A maternal blood test can determine the baby's RhD type from fetal DNA in the mother's blood (high accuracy — ~99.9% sensitivity in meta-analysis). Where offered (e.g. parts of the UK/Europe per NICE DG25), an RhD-negative baby means routine anti-D isn't needed. Availability varies by health system. [NICE DG25; NIHR/NCBI HTA] → Educational "this test exists in some places — ask your clinician," never a recommendation.

**If already sensitized (D17-b) — closer monitoring (education only).** Anti-D is not used. Care shifts to surveillance for HDFN: **maternal antibody titres**, commonly monitored **monthly until ~24 weeks then every 2 weeks** while below a critical titre; once a **critical titre** is reached (or in a pregnancy after a previously affected baby, where titres stop being a reliable guide), specialist **middle-cerebral-artery (MCA) Doppler** ultrasound assesses fetal anaemia — an MCA peak systolic velocity **>1.5 MoM** flags significant anaemia and prompts consideration of fetal blood sampling / intrauterine transfusion by a fetal-medicine team. [SMFM/UC alloimmunization protocol; RCOG Red-Cell Antibodies; Medscape] → App framing: explain titres, MCA Doppler, and HDFN as *what her specialist team monitors and why*; anchor her monitoring appointments; never interpret a titre or MoM value, never reassure or alarm — route to her fetal-medicine/specialist team.

*[NEEDS SOURCE]* flags to pin before content freeze: exact **RCOG Green-top / BSH 2014 anti-D guideline** permalink for the 72-hour + 10-day windows and event list; **ACOG Practice Bulletin 181** canonical ACOG URL (not the third-party PDF); **NICE TA156** and **DG25** overview URLs; region-specific dose values (IU vs mcg: e.g. 1500 IU UK vs 300 mcg US) to localize without implying a dose; and locale-specific RhD-negative prevalence figures for MENA framing.

---

## E. Feature set (prioritized)

Inherits the entire **D1 P0–P2 feature set** (week-by-week home, referenced library, appointment/checklist tracker, symptom/mood log, weight-gain guidance, red-flag safety layer, kick counter, contraction timer, partner view, exports). D17 **adds**:

**P0 — must-have (the D17 layer)**
1. **RhD-status primer card** — auto-surfaced when blood type on record = RhD-negative: "What Rh-negative means," calm + reassuring, first-pregnancy context, myth-correction.
2. **Anti-D awareness + schedule reminders** — optional, opt-in card noting the *typical* schedule (routine ~28-wk dose; postnatal-if-baby-positive; after events) and gentle reminders, always "your clinic sets the plan / this is not medical advice."
3. **Sensitizing-event explainer + "when to contact your team" red-flag box** — the event list (bleeding, trauma, procedures, ECV, loss) with prompt-to-call framing.
4. **Anti-D / injection log** — user records doses given (date, type: routine/postnatal/event) so she and her clinician can see her own record; purely a log, no scoring.

**P1 — high value**
5. **Sensitized (D17-b) education skin** — titres, MCA Doppler, HDFN explainers + specialist-appointment anchoring, unlocked by the user-recorded "sensitized" flag.
6. **Baby-blood-type / postnatal-dose follow-through** — after birth, an educational note that if baby is confirmed RhD-positive a postnatal dose is usually offered within 72h (routes into E1 postpartum).
7. **Fetal RHD genotyping awareness note** — "in some health systems a blood test can check the baby's Rh type — ask your clinician."

**P2 — differentiators / later**
8. Partner RhD-status educational note (if father confirmed RhD-negative by a clinician, anti-D may not be needed — framed as "discuss with your clinician," never an app determination).
9. Export of anti-D/appointment log (PDF) for her maternity notes.

**Explicitly out of scope (compliance):** any tool that tells her to take, skip, or dose anti-D; any interpretation of a titre or MCA MoM value as "safe/dangerous"; any app determination of the baby's Rh type or that she does/doesn't need the injection; any "you are/aren't sensitized" auto-classification (the sensitized flag is *user-recorded from her clinician*, never inferred).

---

## F. Content modules

Authored per femio-medical-content skill (grade 6–8, referenced, 4 languages, RTL). Additive to D1's modules; delivered when RhD-negative is on record but always searchable for everyone.

- **"What Rh-negative means"** — the protein, positive vs negative, why it's on your booking bloods. Calm, one screen.
- **"Why it usually only matters for a future baby"** — first-pregnancy reassurance; how sensitization happens.
- **Myth-buster: Rh-negative and miscarriage** — an Rh-negative blood group does **not** cause early first-pregnancy loss; most early losses are random chromosomal events. Loss-aware, gentle. (Auto-softened in Gentle Mode / after a logged loss.)
- **"Anti-D immunoglobulin explained"** — what it is (a blood product), what it does ("hides" fetal cells), that it *prevents* not *treats*, the typical schedule (~28 wk / postnatal-if-positive / after events). Framed as awareness; every safety/dose question → "ask your clinician."
- **"Sensitizing events — when to contact your maternity team"** — the event list with prompt-to-call framing and the 72-hour context (as *why timely contact matters*, not a countdown she must self-manage).
- **"After your baby is born"** — cord-blood typing; postnatal dose within 72h if baby RhD-positive (bridges to E1).
- **"A blood test for your baby's Rh type"** — fetal RHD genotyping, availability varies, ask your clinician.
- **Sensitized pathway (D17-b) hub** — "What antibodies/titres mean," "What an MCA Doppler scan looks for," "What HDFN is," "Your monitoring appointments" — all education, all routing to her specialist team.
- **Continuity/privacy note** — "Your blood type is saved here privately and connected to your reminders."

---

## G. Tools, logs & alerts (compliant framing; red-flag boxes)

Inherits D1's logs/tools/alerts. **Adds:**

**Logs & tools**
- **Anti-D dose log** — user records each dose: date, type (routine ~28 wk / postnatal / post-event), notes. Copy: *"A record for you and your clinician — not medical advice. Femio can't tell you when to have anti-D; your maternity team decides."* No scoring, no "missed dose" alarm (a gentle "you haven't logged a routine dose yet — your clinic will advise" at most).
- **Sensitizing-event quick-log** — she can note an event (bleed, bump, procedure) which surfaces the "contact your team" box and lets her log it; never triage.
- **Titre / monitoring log (D17-b only)** — user-entered titre values and MCA Doppler appointment notes, stored raw. Copy: *"Your record only — Femio doesn't interpret titres or scan results. Your specialist team explains what they mean for you."*

**Alerts (all opt-in, calm, non-alarmist)**
- **Anti-D awareness reminder** — around 28 weeks: *"A routine anti-D injection is usually offered around now for Rh-negative mums. Your clinic sets the plan — worth checking at your next appointment."* (education, never "take your dose").
- **Postnatal follow-through nudge** (bridges to E1): *"If your baby is Rh-positive, a dose is usually offered within 72 hours of birth — your team will confirm."*
- **Monitoring-appointment reminders (D17-b)** — anchored to her logged specialist appointments.
- **No** predictive/diagnostic alerts; **no** "you're sensitized / at risk" pushes; **no** dose countdowns.

**Red-flag / "contact your team" box (D17-specific, reuses D1 component).**
> **⚠ Contact your maternity team promptly**
> Because you're Rh-negative, tell your midwife or maternity team **as soon as possible** if you have any of these, so they can decide whether you need anti-D:
> • any vaginal bleeding • a fall, knock, or injury to your bump, or a car accident • before/after a procedure like an amniocentesis, CVS, or a version to turn the baby • any pregnancy loss.
> Anti-D usually works best when given within about 72 hours of an event — so don't wait to get in touch.
> *This is general information, not a diagnosis or treatment. Femio can't decide about anti-D — your clinician does.*
> [Contact my maternity team] [Learn about sensitizing events]

Placement: persistent entry in the RhD-negative home strip; auto-injected at the bottom of the bleeding, trauma, and procedure explainers. Inherits D1's general "Urgent warning signs" box unchanged (this is *additive*, keyed to Rh — not a replacement).

---

## H. EMR fields (core vs persona-specific)

**Core (shared, carried in from cycle/TTC/D1):** identity/locale/units, DOB/age, medical-history flags, meds/allergies/supplements, prior pregnancies/outcomes (incl. prior-loss flag), consent/privacy, emergency/maternity contact. **Blood type & RhD status** already exists in D1's persona fields — here it becomes the **trigger for the D17 layer**.

**Persona-specific (D17, layered on D1's pregnancy fields):**
- **RhD status** = negative (the layer trigger; user-entered from booking bloods).
- **Sensitized flag** (boolean, *user-recorded from clinician*: "my clinician told me I have antibodies") → routes to D17-b skin. Never app-inferred.
- **Anti-D dose log[]** — {date, type: routine28 / postnatal / post-event / other, notes}.
- **Sensitizing-event log[]** — {date, event type, notes} (bleed, trauma, procedure, ECV, loss).
- **Baby RhD status if known** (user-entered, e.g. from fetal RHD genotyping or postnatal cord bloods) — informs the postnatal-dose educational note; never an app determination.
- **Partner/father RhD status** (optional, user-entered) — supports the "if father is RhD-negative" educational note only.
- **Titre series[]** and **MCA Doppler appointment notes[]** (D17-b only, entry-only, no interpretation).

Rule (inherited §3): every field is **surfaced or hidden**, never destroyed. If she is later found RhD-positive-baby-negative, or exits pregnancy, the layer archives but remains reachable.

---

## I. Personalization rules (wizard → home config)

**Wizard.** No new top-level branch — D17 is reached from **D1's Q4 "any conditions your clinician is watching?"** and, more reliably, from the **blood-type field on her record**. When RhD status = negative:
- Home gains the **RhD-status primer card** (T1/early) and, from ~mid-pregnancy, the **anti-D awareness card**.
- A one-time calm intro: *"Your notes show you're Rh-negative. That's common and very manageable — here's what it means for you."*
- **Sub-branch:** a single optional question — *"Has a clinician told you that you have antibodies (that you're 'sensitized')?"* → **Yes → D17-b** skin (monitoring hub, titre/MCA education, appointment anchoring, calmer heavier tone); **No/Not sure → D17-a** (reassurance + anti-D awareness). Reversible anytime.

**Home configuration (layered on D1's GA-driven home).**
- **T1:** D1 development card + **RhD primer** + reassurance + (loss-aware) myth-buster; sensitizing-event "contact your team" entry available.
- **T2:** D1 home + **anti-D awareness card warms up** approaching 28 wk; if any procedure (amnio/CVS) is on her appointment log, surface the event explainer.
- **~28 wk:** **anti-D awareness reminder** foregrounded ("usually offered around now — your clinic decides").
- **T3 / birth prep:** D1 T3 home + **postnatal-dose follow-through** note (baby-typing → within-72h education), bridging to E1.
- **D17-b anytime:** monitoring hub replaces the anti-D card as the primary strip (anti-D doesn't apply once sensitized); appointment-anchored, calm.

**Hidden-but-reachable rule (inherited).** Nothing is locked. All Rh content is in the library/search for any user; the D17 layer only changes *emphasis, defaults, tone, reminders* — never access.

**Continuity.** Blood type carried on the one account from booking; connected to reminders and (critically) to **loss handling** — an RhD-negative user who logs a loss is exactly who the miscarriage myth harms, so the myth-buster is available and Gentle Mode softens tone.

---

## J. Adaptation triggers (state transitions)

**Inherits all universal events (Master Model §6)** — positive-test handler, **pregnancy-loss/grief instant suppression**, mood-screen/crisis routing, red-flag routing, disengagement, toggle-off, age-of-consent. Only **D17-specific** transitions are listed here.

**INTO D17 (a layer on D1, never a separate track):**
- **Booking blood type recorded as RhD-negative** (or D1 Q4 flags it) → apply D17 layer over the existing D1 pregnancy state; add RhD primer + anti-D awareness; carry all D1 data unchanged; one-time calm intro. `modifiers += [rh_negative]`.
- **User records the "sensitized / has antibodies" flag** (from her clinician) → switch to **D17-b** skin: suppress the anti-D awareness card (no longer applicable), foreground the monitoring hub (titres, MCA Doppler, HDFN education), anchor specialist appointments, shift tone to steady/heavier. `modifiers += [rh_sensitized]`. Reversible.

**Within D17:**
- **User logs a sensitizing event** (bleed, abdominal trauma, amnio/CVS/cordocentesis, ECV, loss) → immediately surface the **"contact your maternity team promptly"** box (anti-D usually best within ~72h) + let her log it; **never triage or decide** — routing only.
- **Procedure appears on appointment log** (amniocentesis/CVS/ECV scheduled) → proactively surface the event explainer beforehand ("this is a reason anti-D is often given — ask your team").
- **Baby RhD status entered as negative** (e.g. fetal RHD genotyping) → educational note that routine anti-D may not be needed *if her clinician agrees*; soften the anti-D card. Never an app determination.

**Blending (Master Model §8).** `rh_negative` is a composable modifier and stacks with any other pregnancy modifier without conflict (e.g. D1 ⊕ rh_negative ⊕ thyroid → hero = pregnancy timeline; strips = thyroid monitoring + Rh awareness; union of red-flag sets, merged not double-counted). Most-acute emphasis still wins the hero; Rh awareness rides as a secondary strip. D17-b's monitoring intensity raises its emphasis but never overrides a more-acute co-occurring complication.

**OUT of / onward from D17:**
- **Delivery/birth logged → E1 (postpartum)**, carrying a **postnatal-anti-D follow-through** reminder: if baby confirmed RhD-positive, a dose is usually offered within 72h (educational; her team confirms). D17-b carries its monitoring/HDFN context into postpartum neonatal-jaundice awareness education.
- **Pregnancy loss / stillbirth logged →** universal **E6 grief** handler fires (instant suppression of all milestone/anti-D reminders). Additionally: the **Rh-negative-and-loss educational note** ("anti-D is often offered after a loss too — your team will advise; and being Rh-negative did not cause this loss") is made *available, not pushed*, in Gentle Mode. Retain blood-type record for any future pregnancy (where a prior sensitizing event matters).
- **Future pregnancy** → prior sensitizing events / any recorded antibodies carry forward on the one account, informing whether she enters D17-a or D17-b next time (user-confirmed with her clinician, never auto-decided).
- **Toggle off / exit pregnancy** → revert to generic logic; RhD status and logs retained per privacy settings, archived-but-reachable.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. No diagnosis, treatment, or prevention claims; no medical-device functionality. The anti-D log and sensitizing-event log are **records/aids**, explicitly *not* instructions to take, skip, or dose anti-D and *not* tests of fetal wellbeing.
- **Medication / immunoglobulin content is educational only:** anti-D immunoglobulin is described (what it is, what it does, typical schedule) but Femio **never** tells her to take it, when exactly to take it, at what dose, or that she may skip it — all such decisions defer to her clinician. No IU/mcg dose is presented as an instruction; any regional dose figure is clearly "what guidelines describe," not guidance to her.
- **No app inference of clinical status:** the **sensitized flag** and **baby's RhD type** are *user-recorded from a clinician*, never inferred by Femio. No "you are/aren't at risk," no "you don't need the injection" determinations.
- **Screeners / tests = "screening — discuss with clinician":** antibody titres, MCA Doppler, Kleihauer, fetal RHD genotyping all framed as clinician-run tests; Femio never interprets a titre or MoM value.
- **Red-flag routing:** sensitizing-event and bleeding/trauma content uses "contact your maternity team promptly" framing (with the ~72-hour context as *why timely contact matters*, not a self-managed countdown); points to her provider / local emergency number; never reassures ("your baby is fine") and never alarms with a diagnosis.
- **Emotional safety / myth-correction:** the Rh-negative↔miscarriage myth is corrected gently and is loss-aware; after a logged loss, Gentle Mode softens tone and the universal E6 handler suppresses anti-D/milestone reminders instantly.
- **Privacy-by-design (GDPR/PDPL, health data):** blood type and Rh/antibody status are special-category data — minimal collection, explicit consent, **no data sale, no ad-targeting SDKs, no employer/insurer visibility**. Partner RhD status is optional and granular. Loss/withdrawal → immediate reminder suppression + data-deletion honoring.
- **Content provenance:** every claim medically reviewed + cited to Tier-1/Tier-2; review dates surfaced; no clickbait, no sponsored content near emotionally loaded Rh material.
- **i18n/RTL:** all Rh safety, anti-D, and sensitizing-event copy human-reviewed in AR/EN/FR/ES (not machine-only) given clinical stakes; localize dose units and RhD-negative prevalence framing per region.
- **Open items:** resolve the §D **[NEEDS SOURCE]** items (RCOG/BSH anti-D guideline permalink; canonical ACOG PB181 URL; NICE TA156 + DG25 URLs; region dose values IU vs mcg; locale RhD-negative prevalence) before content freeze; confirm per-locale availability language for fetal RHD genotyping (offered in some systems, not others).

---

## Sources

**Tier-1 (NIH / MedlinePlus / CDC / NHS)**
- [MedlinePlus — Rh Incompatibility (Erythroblastosis Fetalis)](https://medlineplus.gov/rhincompatibility.html)
- [MedlinePlus — Hemolytic Disease of the Newborn](https://medlineplus.gov/ency/article/001298.htm)
- [NHS — Rhesus Disease: Prevention (anti-D immunoglobulin)](https://www.nhs.uk/conditions/rhesus-disease/prevention/)

**Tier-2 (ACOG / RCOG / NICE) + specialist guidance**
- [ACOG — The Rh Factor: How It Can Affect Your Pregnancy (patient FAQ)](https://www.acog.org/womens-health/faqs/the-rh-factor-how-it-can-affect-your-pregnancy)
- [ACOG — Prevention of Rh D Alloimmunization (Practice Bulletin 181)](https://www.acog.org/clinical/clinical-guidance/practice-bulletin/articles/2017/08/prevention-of-rh-d-alloimmunization)
- [ACOG PB181 — full text (Green Journal / Obstetrics & Gynecology)](https://journals.lww.com/greenjournal/fulltext/2017/08000/practice_bulletin_no__181__prevention_of_rh_d.54.aspx)
- [The ObG Project — When to Administer Anti-D Immune Globulin (sensitizing-event summary of ACOG PB181)](https://www.obgproject.com/2018/03/14/administer-anti-d-immune-globulin-prevent-rh-d-alloimmunization/)
- [NICE TA156 — Routine Antenatal Anti-D Prophylaxis for RhD-negative Women](https://www.nice.org.uk/Guidance/TA156)
- [NICE DG25 — High-throughput non-invasive prenatal testing for fetal RHD genotype (systematic review / HTA)](https://www.ncbi.nlm.nih.gov/books/NBK488001/)
- [RCOG / RANZCOG — Red Cell Antibodies During Pregnancy (management incl. titres, MCA Doppler)](https://ranzcog.edu.au/wp-content/uploads/RCOG-Red-Cell-Antibodies-During-Pregnancy.pdf)
- [SMFM-aligned protocol — Management of Alloimmunization in Pregnancy (titre + MCA Doppler thresholds, Univ. of Cincinnati)](https://med.uc.edu/docs/default-source/obstetrics-and-gynecology-docs/ob-mfm-protocols/a-d/alloimmunization.pdf)

**Reference / lay-education & effectiveness**
- [Cleveland Clinic — Rhesus (Rh) Factor](https://my.clevelandclinic.org/health/diseases/21053-rh-factor)
- [Nemours KidsHealth — Rh Factor Incompatibility in Pregnancy](https://kidshealth.org/en/parents/rh.html)
- [MSD Manual (Consumer) — Rh Incompatibility](https://www.msdmanuals.com/home/quick-facts-women-s-health-issues/complications-of-pregnancy/rh-incompatibility)
- [Medscape — Rh Incompatibility: Treatment & Management](https://emedicine.medscape.com/article/797150-treatment)
- [RhoGAM — FAQs and Resources (how Rh immune globulin works)](https://www.rhogam.com/faqs-and-resources/)
- [PMC — HDFN due to Rh(D) incompatibility: a preventable disease (effectiveness of prophylaxis)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7371205/)
- [Cloudnine — "Did I miscarry because I'm Rh-negative?" (myth-correction, patient-facing)](https://www.cloudninefertility.com/blog/did-i-miscarry-because-im-rh-negative)
- [Mumsnet — Second Rh Negative pregnancy (community voice-of-user)](https://www.mumsnet.com/talk/pregnancy/4977290-second-rh-negative-pregnancy)

*[NEEDS SOURCE]* to pin before content freeze: canonical RCOG Green-top / BSH 2014 anti-D guideline permalink (72-hour + 10-day windows, full event list); official NHS/BSH sensitizing-event list URL; region-specific anti-D dose values (1500 IU UK vs 300 mcg US) for localization without implying a dose; locale-specific RhD-negative prevalence figures (esp. MENA) for Arabic-first framing.
