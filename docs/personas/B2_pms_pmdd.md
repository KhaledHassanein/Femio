# Persona B2 — Reproductive-age woman with PMS / PMDD (premenstrual dysphoric disorder)

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician." Crisis resources surface on any high mood score or self-harm flag.
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC) · Sensitivity: HIGH (cyclical mental-health, suicidality)

---

## A. Persona snapshot

**Who she is.** "Nour," 31. For years she has felt like "two different people" across the month — capable and steady in the first half of her cycle, then, in the ~10 days before her period, hit by a wave of irritability, hopelessness, anxiety, and physical misery that lifts within a day or two of bleeding. She has been told it's "just PMS," was once started on a daily antidepressant for "depression" that didn't quite fit, and has quietly wondered whether something is wrong with her personality. She recently found the term **PMDD** in an online community and felt seen for the first time. Arabic-first (also reads English), lives on the web on her phone.

**What she lives with.**
- **Cyclical mood symptoms** — marked irritability/anger, depressed mood, hopelessness, anxiety/tension, tearfulness, feeling overwhelmed or "out of control," conflict with people she loves — concentrated in the **luteal phase** (the ~1–2 weeks before menses) and remitting shortly after bleeding starts.
- **Cyclical physical symptoms** — breast tenderness, bloating, joint/muscle aches, headache, fatigue, appetite/food cravings, sleep disturbance.
- **The "why does it keep happening?" gap** — she suspects a cycle link but has never *proven* it to herself or a clinician; retrospective memory is unreliable and gets dismissed.
- **Dark days** — during bad luteal phases she has had passive thoughts that life isn't worth it, then felt "fine and embarrassed" days later. This cyclical suicidality is common in PMDD and is the single most important safety consideration in this persona.

**Core emotional drivers.** Wants **validation that this is real and cyclical**, not a character flaw. Wants a way to *see the pattern* and hand a clinician something credible, so she isn't dismissed or mislabeled again. Wants to know the difference between PMS, PMDD, and "a mood disorder that gets worse before my period" without being told she's being diagnosed by an app. On the worst days she needs to know help exists *right now*.

**Jobs-to-be-done.**
1. Log mood + physical symptoms *daily* and see them plotted against her cycle phase, so the luteal pattern becomes visible.
2. Complete a **generic prospective 2-cycle daily symptom record** she can take to a clinician — useful evidence for discussion, never a diagnostic instrument.
3. Understand PMS vs PMDD vs premenstrual exacerbation (PME) of another condition — in plain language, without self-diagnosing.
4. Learn what actually helps (coping skills, lifestyle, and *what treatments a clinician might discuss* — education only).
5. Feel safe: know that on a bad luteal day there is a crisis resource one tap away, framed with care, never alarm.

**Success = she walks into an appointment with two cycles of prospective daily data and the right vocabulary, and is taken seriously — instead of being handed another "it's just PMS."**

---

## B. Needs & questions (voice-of-user)

Mined from r/PMDD and PMDD/PME communities, IAPMD resources, app-store reviews of PMDD trackers, and qualitative/UX studies (see Sources). Paraphrased to avoid quoting individuals.

**On the cyclical "two people" experience (the core wound):**
- "For ten days a month I don't recognize myself, then my period starts and it lifts like a fog."
- "I need to *prove* it's my cycle — otherwise it just looks like I'm depressed, or difficult."
- "I was put on antidepressants for depression, but my problem isn't every day — it's the week before."

**On tracking & correlation (the #1 product ask):**
- "I want mood and symptoms laid over my cycle so I can finally see the pattern instead of guessing."
- "Retrospective is useless — by the time I feel better I've forgotten how bad it was. I need to log it *that day*."
- "Me v PMDD is the closest thing, but if I miss a day I can't go back and it's stressful; sometimes my data just vanished."
- "General trackers treat mood as one sad-face emoji. I need irritability, anxiety, hopelessness, and 'feeling out of control' as separate things."

**On diagnosis & being believed:**
- "My doctor didn't know what DRSP was. I had to bring the chart myself."
- "It took me over a decade to get the right name for this."
- "How do I know if it's PMDD or my depression getting worse before my period? Nobody explained the difference."

**On treatment awareness (education, not prescription):**
- "I read SSRIs can be taken just in the luteal phase — is that a real thing? I want to ask my doctor properly."
- "Tell me what actually helps that isn't 'do yoga and drink tea.'"

**On the hardest part — safety:**
- "The scariest thing is the intrusive 'I can't do this anymore' thoughts that show up every luteal phase and then disappear."
- "I need to know that on those days there's somewhere to turn *inside the app*, not buried three menus deep."

**On privacy:**
- "This is my mental-health and menstrual data in one place — after the Flo/Facebook scandal I need to know it isn't sold."

**Top recurring questions Femio must answer in-product:**
1. Is what I'm feeling PMS, PMDD, or something else — and how do I tell?
2. How do I do the prospective 2-cycle tracking that a diagnosis actually requires?
3. Why do my symptoms only happen before my period, and why do they lift when it starts?
4. What helps — coping strategies, lifestyle, and what treatments might a clinician discuss? (education only)
5. Is it normal to have dark or hopeless thoughts only in the luteal phase, and where can I get help right now?
6. How do I get my clinician to take this seriously?

---

## C. Competitor teardown

Focused on where trackers fail PMDD users on **daily mood-symptom-to-cycle correlation**, **prospective daily charting**, and **crisis safety**.

| App | Model | Cyclical-mood handling | Prospective/DRSP charting | Symptom-cluster depth | Safety/crisis | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|---|
| **Me v PMDD** | PMDD-specific, paid features | Purpose-built for PMDD; tracks mood + 30+ symptoms, treatment notes, trend graphs | Closest to a DRSP experience of the consumer apps | Deep, PMDD-tuned | Self-love journal + peer-support links | Reasonable | **Reviews report you can't backfill a missed day and data has vanished**; no Arabic/RTL; not referenced/clinical-grade; Femio adds resilient logging, referenced content, multilingual, crisis routing, full-lifespan account |
| **Flo** | Freemium, AI predictions | Improved mood/PMS/anxiety logging + prediction | No true prospective DRSP instrument; framing is prediction, not diagnosis-grade record | Broad but TTC-leaning; mood is shallow vs PMDD needs | Some content; not crisis-first | **FTC settlement (2021) for sharing health data with Facebook/Google; ~$56M class settlement (2025)** | Diagnosis-grade prospective record; uncertainty-honest; privacy-by-design; crisis-first mental-health design |
| **Clue** | Freemium, science-forward | Good neutral symptom taxonomy; clear cross-cycle graphs users bring to appointments | No dedicated DRSP/PMDD 2-cycle instrument | Strong, neutral | Not PMDD/crisis-specific | Strong GDPR posture, doesn't sell data | PMDD-specific DRSP layer + referenced PMS/PMDD content + Arabic-first + crisis design |
| **Bearable** | Symptom/mood tracker (chronic-illness lean) | Flexible mood + factor correlations | Correlation-focused, not a validated PMD instrument | Very customizable | General | Reasonable | Cycle-phase-anchored PMDD framing, referenced content, screening + crisis routing |
| **HealCycle / newer PMDD apps** | PMDD management | Emphasize evidence-based support + coping | Varies; some symptom charting | Moderate–good | Varies | Varies | Referenced medical content, multilingual/RTL, one-account lifespan model, compliant screening framing |
| **IAPMD Symptom Tracker (free PDF/self-screen)** | Nonprofit tool, not an app | DRSP-based, PME-aware framing | Published external instrument; not integrated tracking | N/A | Safety framing + resources | N/A (download) | Femio links to external education but keeps its own record generic unless DRSP permission is documented |

**Cross-cutting failure:** consumer trackers optimize for *prediction of the next period*, not for prospective daily symptoms recorded across cycles for clinician review. Femio targets resilient generic daily records, referenced PMS/PMDD/PME education, and crisis-safe mental-health UX. It does not claim that its record is DRSP, clinically equivalent to DRSP, or capable of diagnosis.

---

## D. Clinical grounding (cited)

**PMS — definition & prevalence.** Premenstrual syndrome is a common cluster of physical and emotional symptoms in the days before a period that ease once bleeding starts; most people who menstruate get some premenstrual symptoms [NHS; Office on Women's Health]. It is common and usually manageable.

**PMDD — definition & severity.** Premenstrual dysphoric disorder is a **severe** form, with intense mood symptoms (marked irritability, depression, anxiety) in the week or two before the period that significantly impair daily life, then remit within a few days of menses onset. PMDD affects roughly **2–5%** (commonly cited "up to ~5%") of reproductive-age women [Office on Women's Health; NHS]. IAPMD estimates ~**115 million** people affected globally [IAPMD Facts & Figures]. Cause is not fully known but is linked to an **abnormal sensitivity to normal hormonal (progesterone/allopregnanolone) fluctuations**, plus genetic factors — not an abnormal hormone *level* [Office on Women's Health; NHS].

**DSM-5 diagnostic picture (educational framing only — Femio does not diagnose).** DSM-5 lists PMDD with a requirement of **≥5 symptoms** in the final week of the luteal phase, improving within a few days of menses onset and minimal/absent in the week post-menses, with at least one being a core affective symptom (marked affective lability, irritability/anger, depressed mood/hopelessness, or anxiety/tension). Crucially, **the diagnosis requires prospective daily symptom ratings across ≥2 symptomatic cycles** — it cannot be made from memory alone [DSM-5; American Journal of Psychiatry: PMDD as a new DSM-5 category].

**DRSP — a published prospective instrument.** The Daily Record of Severity of Problems is a validated instrument described in the clinical literature for prospective daily recording. Femio may explain why prospective records help a clinician, but it does **not** reproduce the DRSP items, scale anchors, domain structure, or a close adaptation without documented permission. [Endicott et al., DRSP reliability & validity, Arch Womens Ment Health 2006; instrument policy in [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md).]

**ISPMD consensus.** The International Society for Premenstrual Disorders holds that **prospective daily symptom rating is the only reliable, validated method** to diagnose and quantify premenstrual disorders, with ~90% of the group favoring the DRSP; a symptom diary should be kept for **~2 months prior to diagnosis**, showing symptoms in the premenstrual phase that are **relieved by menstruation**. ISPMD classifies **Core premenstrual disorder** vs **Variant premenstrual disorders** [ISPMD Montreal consensus; ISPMD 4th consensus / auditable standards].

**PMS vs PMDD vs PME (why the distinction matters — education, not diagnosis).**
- **PMS**: common, milder, physical + emotional, manageable.
- **PMDD**: severe, mood-dominant, functionally impairing, luteal-only with post-menstrual symptom-free week.
- **Premenstrual exacerbation (PME)**: a *pre-existing* condition (e.g., major depression, anxiety, bipolar disorder) that **worsens** premenstrually but does **not** fully clear after menses. An estimated **45–68%** of women with bipolar disorder report premenstrual worsening; roughly **1 in 4** people with PMDD are first mislabeled as bipolar. The practical difference: PME generally needs treatment across the whole cycle and responds poorly to luteal-only dosing, whereas PMDD-specific approaches may. **Only prospective ≥2-cycle charting can distinguish them** — which is exactly why Femio's role is to help her *record*, and a clinician's role is to *interpret* [Premenstrual Exacerbations of Mood Disorders, Curr Psychiatry Rep 2021; MGH Center for Women's Mental Health].

**Underdiagnosis & burden.** Average time to a PMDD diagnosis is ~**12 years**, often across **5–7 providers**; IAPMD cites up to ~90% misdiagnosed. Stigma around both menstruation and mental health drives underdiagnosis [IAPMD Facts & Figures; Marie Claire/KCL coverage].

**Suicidality (the central safety fact).** PMDD and PME carry **significantly elevated, cyclical suicide risk** that intensifies in the luteal phase. A global IAPMD sample reported lifetime **passive suicidal ideation ~79%** and **suicide attempt ~28–34%**; other data show ~**72%** lifetime active ideation, ~**49%** planning, ~**51%** non-suicidal self-injury; women with PMDD were ~**4×** more likely to report suicidal ideation and ~**7×** more likely to attempt suicide vs those without; current ideation in the late luteal phase is reported by ~**40%** [Suicidal Risk in PMS/PMDD systematic review & meta-analysis, PMC8721500; IAPMD self-harm & suicidality; Frontiers in Psychiatry 2024 mixed-methods]. **Implication for Femio:** any high mood-screen score or self-harm flag must route immediately to localized crisis resources, and cyclical suicidality must be treated as a designed-for safety scenario, not an edge case.

**Management (EDUCATIONAL framing only — Femio does not treat).**
- **Lifestyle & coping** — regular exercise, sleep and stress management, dietary patterns, and psychological approaches (e.g., CBT) are commonly described first-line/adjunct supports [ACOG management guidance; NHS].
- **SSRIs** — described in guidelines as first-line pharmacotherapy for moderate–severe PMS/PMDD, notable for a **rapid response at lower doses than for depression** and the option of **luteal-phase (intermittent) or continuous dosing**; ~60–70% respond vs ~30% placebo [ACOG; Psychopharmacology Institute; EMA PMDD guideline]. *Femio explains what these are and that a clinician might discuss them — never recommends, doses, or tells her to start/stop anything.*
- **Other clinician-discussed options** — certain combined hormonal contraceptives (e.g., drospirenone-containing), and, for refractory cases, other hormonal approaches, are clinician-prescribed; Femio explains, never prescribes, and makes **no contraceptive-efficacy claim**.

**Femio scope guardrail restated:** everything above is **wellness education, tracking, and screening**, with consistent "discuss with your clinician" routing and crisis resources on any high/self-harm signal. Femio is not a diagnosis, not treatment, and not contraception.

*Instrument/content decision:* Femio does not reproduce exact DSM criteria, the DRSP item list, or a “DRSP-style” adaptation, and it makes no public PMDD-suicidality percentage claim. It may offer independently written education and a generic prospective daily symptom record for clinician discussion, without presenting it as DRSP or a diagnostic tool. Any later DRSP implementation requires documented commercial reuse and translation permission under [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md). *(Reviewed Mohamed K., 23 July 2026.)*

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to switch.**
1. **Daily mood + symptom log with cycle-phase anchoring** — separate items for irritability/anger, depressed mood/hopelessness, anxiety/tension, affective lability, feeling overwhelmed/out of control, plus core physical symptoms; each on a severity scale; every entry auto-tagged to cycle day/phase.
2. **Cycle-symptom correlation view** — symptom severity plotted against cycle phase across months, making a luteal-clustering pattern visible ("your irritability logs cluster in the ~10 days before your period"). Descriptive, never diagnostic.
3. **Generic prospective 2-cycle record** — a guided, same-day symptom tracker written independently for Femio and explicitly framed as **“a record to share with your clinician—not a validated questionnaire or diagnosis.”** It must not reproduce or closely adapt DRSP items, anchors, or domain structure. Resilient logging (see #4).
4. **Resilient, low-pressure daily logging** — gentle same-day reminders; a clearly-labeled short grace window for late entry that **flags backfilled days as non-prospective** so the record's integrity is preserved; robust local persistence so **data never silently disappears** (directly answering the top Me v PMDD complaint). Missing a day is never punished.
5. **PMS vs PMDD vs PME education** — plain-language explainer of the three, why prospective charting distinguishes them, and why "before-only + relief at menses" is the key pattern.
6. **Mental-health screening + crisis safety** — validated-style mood/anxiety screen framed as screening; **any high score or self-harm item immediately surfaces localized crisis resources**; a persistent, easy-to-reach "**Need help now?**" entry available from the mental-health module at all times.
7. **Privacy-by-design** — mental-health + menstrual data treated as special-category; no ad-SDK sharing; local-first where feasible; export/delete; explicitly addresses post-Flo distrust.

**P1 — strong differentiators.**
8. **Clinician-visit prep pack** — exportable/printable summary: the 2-cycle prospective chart, symptom trends, cycle-relief pattern, screening results (as screening), and questions to ask — so she is believed and not re-dismissed.
9. Referenced, medically-reviewed PMS/PMDD content library (Arabic-first + EN/FR/ES).
10. **Coping-in-the-luteal-window toolkit** — evidence-informed coping skills (sleep, movement, stress, grounding, planning around the hard window), stigma-aware, non-shaming.
11. **Treatment-awareness education (education only)** — what SSRIs/luteal-phase dosing/lifestyle/CBT are and why a clinician might discuss them; clear non-prescription disclaimer + clinician routing.

**P2 — depth / retention.**
12. Personalized "your typical hard window" heads-up (descriptive, opt-in, gentle — "based on your logs this stretch has been harder; here are your coping tools") — **never** a deterministic prediction, never alarmist.
13. Partner/support-person education mode (scoped, revocable) — explaining PMDD's cyclical nature to a trusted person.
14. Symptom-history export in a clinician-friendly format.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages)

1. **PMS 101** — what premenstrual symptoms are, why they happen, how common, what's manageable.
2. **What is PMDD?** — the severe, mood-dominant, luteal-only picture; hormone-*sensitivity* (not imbalance) framing; that it is real and recognized.
3. **PMS vs PMDD vs PME** — how they differ, why "relief when the period starts" matters, and why only prospective charting can tell them apart. Explicit "this helps you understand, not self-diagnose."
4. **Why tracking daily and prospectively matters** — the DRSP/ISPMD standard in plain language; how a 2-cycle record changes an appointment.
5. **PMDD & your mental health** — normalizing cyclical mood and intrusive/hopeless thoughts; that dark luteal thoughts are a known feature and help exists; how to build a safety plan with a clinician. Crisis resources embedded.
6. **Coping through the hard window** — sleep, movement, stress-reduction, planning, grounding; stigma-aware, non-shaming.
7. **Understanding treatment options (education only)** — lifestyle, CBT, SSRIs (continuous vs luteal-phase dosing), hormonal options a clinician might discuss; what they are and why a clinician raises them. Clear non-prescription disclaimer.
8. **Getting the most from your appointment** — bringing your chart, the words to use ("cyclical, luteal, remits at menses"), what to ask, how to advocate if dismissed or mislabeled as depression/bipolar.
9. **When it might be more than PMDD** — PME and comorbid depression/anxiety/bipolar explained supportively; when whole-cycle symptoms suggest a different conversation with a clinician.
10. **Myths vs evidence** — "it's just PMS," "everyone gets moody," "it's all in your head," "antidepressants are the only answer."

Every module: referenced citations, medical-review byline + date, "discuss with your clinician" footer, and — for mental-health modules — a visible crisis-resources block.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Cycle/bleed log (period start/end, flow) — anchors phase tagging.
- **Daily symptom notes** — user-authored mood, physical-symptom, and daily-impact notes with a simple user-selected intensity marker. This is independent product copy, not a reconstruction of DRSP items or domains.
- Optional free-text daily note; optional treatment/med note (user-entered, no interpretation).

**Tools**
- **Cycle-symptom correlation view** — severity vs cycle phase over time; descriptive language ("appears to cluster in your luteal phase," never "this proves PMDD").
- **Generic prospective 2-cycle record** — guided daily, same-day entry; progress indicator; export/print. **Framed on entry and export as: “This is a personal symptom record to share with a clinician—not a validated questionnaire or diagnosis.”** Backfilled days are visibly identified.
- **Visit-prep generator** — one-tap export: 2-cycle chart + trends + cycle-relief pattern + screening results (as screening) + suggested questions.
- **Screeners (framed as screening, not diagnosis):**
  - Premenstrual-symptoms awareness checklist (PSST-style) → "These can be signs to discuss and chart prospectively; only a clinician can diagnose."
  - Mood/anxiety screen (PHQ-2/GAD-2-style) → "This is a screening tool, not a diagnosis. Consider discussing with a clinician." + crisis resources.

**Crisis resources & safety (first-class, not buried)**
- **Any high mood-screen score, or any non-zero self-harm/suicidal-ideation item, immediately surfaces localized crisis resources** (region/language-specific hotlines/text lines) with warm, non-alarming framing — regardless of total score.
- A persistent **"Need help now?"** affordance is reachable at all times from the mental-health module and from any screener result.
- Because PMDD suicidality is **cyclical**, safety content and the crisis affordance stay reachable during and around the luteal window, and screening can be re-offered gently — never in a way that implies she is "broken."
- Crisis routing is **education/support signposting only** — never triage, diagnosis, or emergency dispatch. Saved local emergency numbers are presented as information.

**Alerts (all gentle, screening-framed, dismissible, localized/RTL)**
- Same-day daily-log reminder (supports prospective charting) — kind, never guilt-inducing; missing a day is fine.
- 2-cycle record progress nudge ("you're partway through cycle 2 of your record").
- Optional coping-tools heads-up around her typically-harder window (opt-in, descriptive, non-deterministic).
- **Never:** a diagnosis or "you have PMDD"; never a deterministic "your bad days will be X"; never contraceptive/"safe day" claims; never disease-prevention claims; never a medication instruction/dose.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off); mental-health data flagged special-category.
- Life-stage / mode flag (here: reproductive-age, non-TTC, **PMS/PMDD tracking mode ON**).
- Cycle events: bleed start/end, flow; computed cycle length + luteal-phase estimate for symptom anchoring.
- Generic mood/energy/sleep log.

**Persona-specific (PMS/PMDD)**
- PMD status (self-reported: exploring / suspected / clinician-confirmed) + notes; PME-consideration flag if she reports symptoms that don't fully clear at menses (surfaces "discuss whole-cycle patterns with a clinician" — never a diagnosis).
- **Independent daily symptom-note array** (user-selected symptom, impact/intensity marker, optional note) with a **same-day-vs-backfilled marker per entry**; it must not encode DRSP item/domain wording.
- 2-cycle prospective-record state (start date, days completed, cycle count, completeness).
- Luteal-phase symptom-clustering summary (descriptive analytic output, non-diagnostic).
- Mental-health screen history (scores + dates, screening-only) and **self-harm/crisis-flag events** (timestamped; drive crisis-resource surfacing; retained with heightened privacy).
- User-entered treatment/med notes (educational context; no interpretation).
- Coping-tool usage (optional).

*All health fields optional, encrypted, user-deletable. Mental-health and self-harm flags get the strictest handling: never shared, never used for ads/analytics, purpose-limited to in-app safety surfacing.*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B2):**
- Q: life stage → "tracking my cycle / general" (reproductive age).
- Q: main reason → "mood or symptoms that change with my cycle" ⇒ set **PMS/PMDD tracking mode ON**.
- Q: "Are you currently trying to conceive?" → **No** ⇒ TTC intent = false; suppress fertile-window/pregnancy nudges.
- Q: "Do your hardest symptoms mostly ease once your period starts?" → tunes PMDD-vs-PME framing gently (if "no / they continue all month," surface the "might be more than PMDD / discuss whole-cycle patterns" content — never a diagnosis).
- Q: top concerns (multi-select: mood, irritability/relationships, physical symptoms, appointment prep, safety/support) ⇒ orders home modules.
- Sensitive-intro copy sets tone: "This helps you see patterns and share them with a clinician. It's not a diagnosis. If things ever feel unsafe, help is one tap away."

**Home configuration (default for B2):**
- Hero = **today's quick daily log** (mood + key symptoms) + cycle-phase context, with the correlation view one tap below.
- Cards: 2-cycle prospective-record progress; "PMS vs PMDD vs PME" explainer; coping toolkit; visit-prep. Mental-health/safety card surfaced prominently if she flags mood/safety concerns.
- The **"Need help now?"** affordance is always reachable within the mental-health area.
- Fertile-window / pregnancy widgets **hidden by default** (reachable via "Explore other life stages").

**Hidden-but-reachable principle:** Femio never removes knowledge. TTC, pregnancy, contraception education, and perimenopause content stay discoverable via search — just not pushed.

**Adaptive tuning:**
- If daily logs show a repeated user-visible pattern, raise generic prospective-record and visit-prep education: “You may want to share this record with your clinician.” Do not interpret the pattern as PMDD or compare the record with DRSP.
- If she reports/records symptoms **that don't clear at menses**, raise PME/comorbidity education and "discuss whole-cycle patterns with a clinician" (never a diagnosis).
- If mood screens trend high or any self-harm item fires, surface the mental-health module + **localized crisis resources immediately**, and keep safety content reachable through subsequent luteal windows.

---

## J. Adaptation triggers (life-stage routing)

Universal events are inherited from the Master Adaptation Model §6 (positive pregnancy test, pregnancy loss, **mood-screen-high/crisis flag**, red-flag symptom, disengagement, toggle-off, age-of-consent). B2 adds the following **persona-specific** transitions:

| Trigger | System response | Route |
|---|---|---|
| **Luteal pattern emerges from B1 logs** (a general-tracking user's mood/symptoms consistently cluster premenstrually and ease at menses) | Offer (never force) PMS/PMDD tracking mode: "Your logs seem to cluster before your period — want tools to track this and share it with a clinician?" Confirm explicitly; carry all history | **B1 → B2** (add PMS/PMDD layer over unchanged core) |
| **Symptoms don't remit at menses / whole-cycle pattern** | Surface PME/comorbidity education ("this may be more than PMDD — worth discussing whole-cycle patterns with a clinician"); keep tracking; **never diagnose** | Stay B2, raise PME education |
| **Completes prospective 2-cycle record** | Assemble visit-prep pack (chart + trends + relief pattern + screening results as screening + questions); reinforce "share with a clinician; only a clinician can diagnose" | Stay B2, elevate visit-prep |
| **Mood screen high / any self-harm or suicidal-ideation item** | *(Inherited universal, made central here)* Immediately surface mental-health module + **localized crisis resources**; screening framing; non-zero self-harm item → immediate crisis path regardless of total score; keep safety reachable through luteal windows given cyclical risk | Stay B2 → **crisis routing** (support signposting only) |
| **Sets TTC intent = true** | Confirm; enable TTC/ovulation features with uncertainty caveats; surface education on managing premenstrual mood while TTC and discussing medication changes (e.g., SSRIs) with a clinician **before** conceiving — education only | Route to **C-track (TTC)**, carry PMS/PMDD layer |
| **Positive pregnancy test** | *(Inherited universal)* Celebrate tone-matched; suppress cycle-phase/luteal framing; carry mental-health history; re-confirm privacy scope; note perinatal-mood-watch education (cyclical PMDD context informs postpartum mood vigilance — education, clinician-led) | Route to **D-track**, mental-health modifier retained |
| **Perimenopause overlap** (late 30s–40s+, changing cycles, worsening/lengthening premenstrual symptoms) | Introduce perimenopause education; explain how perimenstrual mood and perimenopausal mood can overlap/intensify; keep symptom tracking | Blend PMS/PMDD + perimenopause; **offer route to F1** (perimenopause) |
| **User toggles off PMS/PMDD mode** | *(Inherited universal)* Revert to general cycle logic; preserve all history (archived-but-reachable) | General reproductive-age band / B1 |

All transitions require **explicit user confirmation**, preserve data continuity, and never lock her out of prior/other content. Crisis routing is the one path that surfaces **proactively without waiting for confirmation**, because safety comes first.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking only. No diagnosis, treatment, disease-prevention, or contraception claim. The generic record is personal documentation to share with a clinician; it is not DRSP, a validated screener, or a diagnostic verdict.
- **Screeners:** every screener returns "This is a screening tool, not a diagnosis — discuss with a clinician." Never outputs "You have PMDD/PMS/depression/bipolar."
- **Mental-health safety (central to B2):** any affirmative self-harm/suicidal-ideation item triggers the urgent route independently of the total; high scores without a self-harm item trigger prompt clinical/support routing, not an inferred suicide-risk result. A "Need help now?" affordance is persistently reachable. Crisis content is signposting/support only — never triage, diagnosis, or emergency dispatch. Follow [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md), using an explicit country selector and WHO-aligned emergency fallback rather than language- or region-inferred numbers. *(WHO, 18 September 2024; reviewed Mohamed K., 23 July 2026.)*
- **Predictions:** any "your harder window" heads-up must be descriptive, opt-in, non-deterministic, and non-alarming; never a certain date; never a contraceptive/"safe day" claim.
- **Medication content (SSRIs, luteal-phase dosing, hormonal options):** educational context only; no recommendation, dosing, or "take/stop this." Clear non-prescription disclaimer + clinician routing. No contraceptive-efficacy claim.
- **Tone / non-stigmatizing:** cyclical mood and intrusive thoughts normalized without sensationalism; avoid both doom and toxic positivity; never imply a character flaw. Silence-over-risk on sensitive content.
- **Privacy (GDPR/PDPL health data):** menstrual + mental-health data = special-category; explicit granular consent; purpose limitation; **no ad-SDK / third-party sharing** of cycle/mood/self-harm data (post-Flo trust); local-first where feasible; full export/delete. Self-harm/crisis flags get the strictest handling and are never used for ads/analytics/employer/insurer visibility. Data-mapping + DPIA required before launch.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8 reading level; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** the independent tracker is positioned as a shareable personal record, not a diagnostic instrument or medical device; legal review remains required before store submission.
- **Controlled exclusions:** exact DSM wording, DRSP items/adaptations, and unsourced public suicidality percentages are excluded. Generic symptom tracking is not labelled DRSP and is not diagnostic. Crisis routing follows the reviewed global policy. *(Instrument governance reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## Sources

**Clinical — Tier 1 (NIH/NHS/MedlinePlus/OWH / gov):**
- [Premenstrual dysphoric disorder (PMDD) — Office on Women's Health](https://womenshealth.gov/menstrual-cycle/premenstrual-syndrome/premenstrual-dysphoric-disorder-pmdd)
- [PMS (premenstrual syndrome) — NHS](https://www.nhs.uk/conditions/pre-menstrual-syndrome/)
- [Is It More than PMS? Learn About PMDD — NIH Office of Disease Prevention (slides)](https://prevention.nih.gov/sites/default/files/PiF/2024/Bohn%20MacDonald/pFocusBohnMacDonaldSlides-FINAL-508.pdf)

**Clinical — Tier 2 (guidelines / society / peer-reviewed):**
- [Premenstrual Dysphoric Disorder: Evidence for a New Category for DSM-5 — American Journal of Psychiatry](https://psychiatryonline.org/doi/10.1176/appi.ajp.2012.11081302)
- [Daily Record of Severity of Problems (DRSP): reliability and validity — Arch Womens Ment Health (Springer)](https://link.springer.com/article/10.1007/s00737-005-0103-y) · [PubMed](https://pubmed.ncbi.nlm.nih.gov/16172836/)
- [DRSP — International Association for Premenstrual Disorders](https://www.iapmd.org/drsp)
- [What is DRSP, and why is it important for PMDD diagnosis and research? — IAPMD FAQ](https://faq.iapmd.org/en/articles/8232981-what-is-drsp-and-why-is-it-important-for-pmdd-diagnosis-and-research)
- [PMS Diagnosis: DRSP vs Premenstrual Symptoms Screening Tool (PSST) — PubMed](https://pubmed.ncbi.nlm.nih.gov/29132173/)
- [Towards a consensus on diagnostic criteria… ISPMD Montreal consensus — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC4134928/)
- [Fourth consensus of the ISPMD: auditable standards for diagnosis and management — PubMed](https://pubmed.ncbi.nlm.nih.gov/27378473/)
- [Premenstrual Syndrome and Premenstrual Dysphoric Disorder — AAFP (AFP)](https://www.aafp.org/pubs/afp/issues/2016/0801/p236.html)
- [ACOG guideline: Management of PMS and PMDD (summary) — The ObG Project](https://www.obgproject.com/2023/12/27/acog-guideline-management-of-premenstrual-syndrome-and-premenstrual-dysphoric-disorder/)
- [Psychopharmacology for PMS and PMDD: luteal-phase dosing and choosing among SSRIs — Psychopharmacology Institute](https://psychopharmacologyinstitute.com/section/psychopharmacology-for-pms-and-pmdd-luteal-phase-dosing-and-choosing-among-ssris-2513-4938/)
- [Guideline on the treatment of PMDD — European Medicines Agency (EMA)](https://www.ema.europa.eu/en/documents/scientific-guideline/guideline-treatment-premenstrual-dysphoric-disorder-pmdd_en.pdf)
- [Management of Premenstrual Dysphoric Disorder: A Scoping Review — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC9790166/)

**PMS vs PMDD vs PME / differential:**
- [Premenstrual Exacerbations of Mood Disorders: Findings and Knowledge Gaps — Curr Psychiatry Rep (PMC)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8502143/)
- [PMS & PMDD — MGH Center for Women's Mental Health](https://womensmentalhealth.org/specialty-clinics/pms-and-pmdd/)
- [Bipolar & PMDD — IAPMD](https://www.iapmd.org/bipolar-pmdd)

**Suicidality / safety:**
- [Suicidal Risk in Women with PMS and PMDD: Systematic Review & Meta-Analysis — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8721500/)
- [Women with PMDD: experiences of suicidal thoughts and behaviours (mixed-methods) — Frontiers in Psychiatry / PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11576155/)
- [Prevalence and correlates of current suicidal ideation in women with PMDD — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8832802/)
- [Lifetime self-injurious thoughts and behaviors in prospectively-confirmed PMDD (global sample) — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8933886/)
- [Self-Harm and Suicidality — IAPMD](https://www.iapmd.org/self-harm-suicidality)

**Prevalence / burden / underdiagnosis:**
- [Facts & Figures — IAPMD](https://www.iapmd.org/facts-figures)
- [PMDD misdiagnosis coverage (KCL / advocacy) — Marie Claire UK](https://www.marieclaire.co.uk/health-fitness/pmdd-misdiagnosis)
- [Towards Better Outcomes for PMDD — King's College London](https://www.kcl.ac.uk/research/towards-better-outcomes-for-premenstrual-dysphoric-disorder-pmdd)

**Patient journey / needs (community + UX studies):**
- [Developing a Mood and Menstrual Tracking App for People With PMDD: User-Centered Design Study — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11687174/)
- [IAPMD Premenstrual Disorders Symptom Tracker (free) — IAPMD](https://www.iapmd.org/shop/p/iapmd-pmds-symptom-tracker)
- [IAPMD PMDs Self-Screen (free) — IAPMD](https://www.iapmd.org/self-screen)
- [Steps to Diagnosis — IAPMD](https://www.iapmd.org/steps-to-diagnosis)

**Competitor / app landscape:**
- [Me v PMDD — Symptom Tracker](https://mevpmdd.com/)
- [Best PMDD Management Apps in 2025 (review) — Medium](https://medium.com/@rahman.maya/best-pmdd-management-apps-27b27b7de21a)
- [Best Apps for Tracking PMS Mood and Anxiety in 2026 (review) — Medium](https://medium.com/@rahman.maya/best-apps-for-tracking-pms-mood-and-anxiety-in-2026-manage-symptoms-and-boost-wellbeing-af6db268d677)
- [The Best Period Tracker Apps of 2025 — Bearable](https://bearable.app/the-best-period-tracker-apps-of-2025/)
