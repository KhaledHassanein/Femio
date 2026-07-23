# Persona A5 — Teen With Absent or Late Periods (Amenorrhea Concern, ~13–17)

Persona ID: **A5** · Track A (Puberty / Adolescent) · Mode: **Teen mode (minor tier)** (no ads, minimal data, no community DMs, trusted-adult involvement, GDPR age-of-consent, extra-gentle tone)
Prepared: 2026-07-21 · Status: research + spec · Wave 3
Inherits Femio scope guardrail: **wellness / education / tracking only. Never diagnose, treat, prevent disease, or act as contraception. Screeners = "screening, discuss with a clinician."**
Inherits from `09_MASTER_ADAPTATION_MODEL.md`: seven invariants, state object, constant core, universal events (§6), Z1 fallback, blending rules. This spec adds only A5-specific layers.

---

## A. Persona snapshot

| | |
|---|---|
| **Who** | Two arrival stories, one persona. **"Salma," 15** — never had a period. Breasts started developing at ~11–12, friends all menstruate, she doesn't, and she's quietly convinced something is wrong with her (primary-amenorrhea concern: no period by ~15, or 3+ years after breast development began). **Or "Dana," 16** — started at 13, had a handful of periods, then nothing for 4+ months (teen secondary-amenorrhea concern: gaps beyond the ~90-day flag). Both usually arrive via the A1 "no-period-by-15 watch" or the A2 long-gap pattern. |
| **Emotional state** | Worried, often silently. "Am I broken? Am I not a real girl? Will I be able to have kids someday?" Shame about being *different from every friend*; fear of the doctor's visit itself; sometimes months of private googling that made it worse. Needs **calm first, facts second**. |
| **Health literacy** | Low–moderate. Has usually encountered scary terms online (Turner syndrome, "no uterus," infertility) without context or base rates. May hold the misconception that absent periods are always permanent or always serious. |
| **Privacy needs** | Very high. This feels more "wrong with me" than a normal period does — she may not have told friends, sometimes not even a parent. Shared devices common. **But** clinician routing for a minor requires a parent, so Femio must gently help her *bring a parent in*, on her terms. |
| **Device / context** | Web-first, short private sessions; often arrives from a worried search ("15 no period is something wrong"). A **parent** may be the one driving (worried mother searching on her behalf) — both audiences matter. |
| **Language** | May be Arabic-first / RTL. In MENA contexts an absent period carries extra stigma weight (marriageability/fertility anxieties voiced by family) — tone must protect her from that pressure, not amplify it. |
| **Primary jobs-to-be-done** | (1) "Tell me honestly whether this is a real flag — and don't panic me." (2) "Explain what could cause it, gently." (3) "Tell me exactly what happens at the doctor so I'm not scared to go." (4) "Help me talk to my mum/dad about it." (5) "Track what I *do* have (discharge, growth, symptoms) so the visit is useful." |
| **What success feels like** | She understands the thresholds are *screening points, not verdicts*; she knows normal variation is possible while checking is still worthwhile; she books and attends a visit with an appropriate trusted adult where required, prepared and unafraid; whatever the outcome, Femio adapts with her. |
| **Anti-goals (things that break trust)** | A "you are X days late" counter; alarming language ("this could mean infertility/Turner syndrome" as a headline); implying a diagnosis from logs; lecturing her about weight or eating; fertility/pregnancy framing pointed at a minor; making the parent conversation feel like a confession. |

**Design tension to hold:** A5 is the persona where “reassurance-first” and “take it seriously” must coexist. Normal variation is possible, and the same thresholds exist because an evaluation can distinguish it from causes that need care. Femio’s job is to say: *“This threshold is not a verdict or an emergency by itself. It is genuinely worth checking, and here is how to prepare.”*

---

## B. Needs & questions (voice-of-user)

Mined from teen forum threads (r/Periods, r/AskDocs-style "I'm 15/16 and never had a period"), Center for Young Women's Health Q&As, parent forum threads ("my daughter is 15 and hasn't started"), children's-hospital patient education (Boston Children's, CHOP, Nationwide, Stanford), and adolescent-amenorrhea reviews. Two voices: **the teen** and **the worried parent**.

**The teen — "Is something wrong with me?" (dominant emotion: private fear)**
- "I'm 15 and I've never had a period. All my friends have. Am I normal?" → *ACOG reports that 98% have started by 15, which is why age 15 is a check-in point—not a diagnosis or emergency by itself (§D).*
- "My boobs started growing three years ago and still nothing." → *That's the second check-in marker (menarche usually follows breast budding within ~2–3 years); worth an appointment, calmly (§D).*
- "Does this mean I can't have kids?" → *Do NOT dodge; answer honestly at teen level: an absent period by itself doesn't tell you that; most causes don't mean that; that's precisely what an evaluation sorts out. Never promise, never doom.*
- "I read about Turner syndrome / not having a uterus and I'm terrified." → *Explain that many different causes are possible and a clinician evaluates them step by step; a missing period alone does not identify the cause. De-escalate the 2am-google spiral (§D, §F).*
- "I got my period at 13, had like five, and now it's been four months." → *Teen cycles skip — but a gap beyond ~90 days is the evidence-based point to raise with a clinician even in the first gynecologic years (A2 §D inherited).*

**The teen — "What will the doctor actually do to me?" (fear of the visit)**
- "Will they do an internal exam?" → *Usually not first: typical evaluation is questions, growth/exam, blood tests, and an abdominal (over-the-tummy) ultrasound — demystify each step (§D, §F).*
- "Will they weigh me / judge my eating / make me quit my sport?" → *Handle with extreme care (ED-adjacency): the doctor asks about food, training, and stress because energy balance genuinely affects periods — framed as fueling, never as blame (§B below, §K).*
- "What do I even say? It's embarrassing." → *Appointment-prep tool: her timeline + a questions list she brings along (§G).*

**The teen — the low-energy / ED-adjacent thread (handle with the most care in the whole spec)**
- "I run/dance a lot and my period stopped — is that actually a thing?" → *Yes: when the body gets less fuel than it uses, it can pause periods to save energy (functional hypothalamic amenorrhea / RED-S). Framed as the body protecting itself, fixable, and worth telling a clinician — never as "you're doing something wrong" and never with weights, calories, or BMI numbers (§D, §K).*
- "If I tell someone, they'll make it a big deal about food." → *Non-triggering door: supportive resources offered quietly, "a lot of strong, driven people experience this," clinician + trusted adult routing without accusation (§J).*
- What Femio must never do here: calorie math, weight targets, "eat more" prescriptions, ED labels, or any language NEDA-style safe-messaging guidance flags as triggering.

**The teen — "Help me tell my parents."**
- "I've been hiding this for a year because I didn't want to worry my mum." → *Conversation-starter scripts ("Mum, can I ask you something about my body?"), plus the reassuring fact that late periods often run in families — asking mum when she started is literally part of the medical history.*
- "Can I go to the doctor without making it a whole family drama?" → *Parent-inclusive by design for a minor: Femio helps her choose the adult and the words; it never sends her alone and never goes around her.*

**The parent — voice-of-caregiver (often the account-adjacent worrier)**
- "My daughter is 15 and hasn't started — should I be worried?" → *Calm threshold education: 15 / three-years-after-breasts / 90-day gaps are check-in points; most evaluations find a late-but-normal body; booking the visit is the loving next step, not an alarm.*
- "What will they test her for? Will it be invasive?" → *Plain walkthrough of the standard workup (§D) so the parent can reassure, not transmit anxiety.*
- "Could it be her diet/sport? How do I raise it without giving her a complex?" → *Parent-side safe-messaging guidance: focus on fueling and energy, never appearance or weight; let the clinician lead.*
- "It ran in our family — I was 15 too." → *Validated: family history of late menarche genuinely supports constitutional delay, and is worth telling the doctor — but doesn't replace the check.*

> **Key research insight:** the teen's biggest barrier is not information but **fear of what the evaluation might find and of the visit itself** — teens sit on this worry for months. Demystifying the workup step-by-step and scripting the parent conversation is the highest-value intervention Femio can make; the reassurance is what gets her *through the clinic door*, which is the actual goal.

---

## C. Competitor teardown

How existing products serve — or fail — a worried 13–17-year-old with absent/late periods and her parent. The category-wide failure is structural: **period trackers are built around bleeding that exists.** A teen with no periods has nothing to log, gets a broken/empty experience, and — worst of all — mainstream apps show "late" counters and confident predictions that read as daily accusations.

| Product | A5 fit | Strengths for A5 | Fails A5 on |
|---|---|---|---|
| **Flo / Clue / mainstream trackers** | Poor. | Some "missed period causes" articles in libraries. | Entire UX assumes a cycle: "period is X days late" counters and confident predicted dates are actively anxiety-generating for amenorrhea; fertility/TTC framing wrong for a minor; ad/data pressure (Flo/Meta FTC history); no evaluation-prep or parent layer; age floors and adult tone. |
| **Luna (teen app)** | Partial — closest in spirit. | Irregular-cycle-friendly stance (patterns over rigid predictions); parent guides incl. discharge/first-period timing; doctor-made teen tone. | Still tracker-first for cycles that exist; no structured amenorrhea education path (thresholds → causes → what the workup is → appointment prep); English-centric, not Arabic-first/RTL; no ED-safe routing architecture. |
| **MagicGirl / Teena / teen trackers** | Poor. | Teen-styled logging. | Built around having periods; community/UGC safeguarding risks; no referenced amenorrhea content; nothing for "I have nothing to track." |
| **KidsHealth / Center for Young Women's Health / children's-hospital pages** | Excellent content, wrong container. | Tier-1-grade plain-language amenorrhea guides (CYWH's is genuinely teen-voiced); accurate thresholds and workup descriptions. | Static; she must find them mid-panic via Google (adjacent to the scary results); no personalization, tracking of non-period signs, appointment prep, parent layer, or Arabic. |
| **Dr. Google / TikTok / forums** | The de facto incumbent. | Instant, anonymous, peer voices ("I was 16, I'm fine now"). | Worst-case-first ordering (Turner/MRKH/infertility headlines without base rates); unvetted; the 2am spiral is the direct competitor Femio must beat with calm, referenced, contextual answers. |
| **ED-recovery apps (Recovery Record etc.)** | Wrong entry point. | Genuine support for the ED-adjacent subset. | Require self-identifying with an ED first — exactly what an athletic teen with FHA won't do; no bridge from "my period stopped" to support. |

**White space Femio can own for A5:**
1. **The no-period home that isn't broken** — a first-class experience with nothing to bleed-log: milestones, body signs, readiness, evaluation journey. No "late" counter, ever (a Master-Model invariant, applied literally here).
2. **The evaluation-demystifier** — step-by-step "what actually happens at the doctor" (questions → exam → blood tests → tummy ultrasound) that no tracker offers; converts fear into a plan.
3. **Reassurance with integrity** — constitutional-delay-first framing *with* honest thresholds, against Google's worst-case-first ordering.
4. **Parent-bridge tooling** — scripts, shareable timeline summary, family-history prompts; parent-inclusive clinician routing built for minors.
5. **ED-safe by design** — the only product in the space applying safe-messaging principles (no numbers, no blame, quiet supportive doors) to the exercise/eating-adjacent amenorrhea path.
6. **Arabic-first / RTL** — absent-period stigma content for MENA families is a near-empty niche; protect the teen from family fertility-pressure framing while still involving a parent.

---

## D. Clinical grounding (cited)

The reviewed thresholds below are patient education, not diagnosis. Femio uses the signed adolescent section of [`MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md) and routes concerns to a qualified clinician. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

**Evaluation thresholds (screening language, NOT verdicts)**
- **Primary amenorrhea — evaluate if:** no menarche by **age 15**, or **not within 3 years of thelarche** (breast budding) (ACOG Committee Opinion 651 "Menstrual Cycle as a Vital Sign"; StatPearls Primary Amenorrhea).
- **Also evaluate:** **no breast development by age 13** (ACOG 651; MedlinePlus delayed puberty) — this is the A1 watch that feeds A5.
- Context: menarche typically occurs **2–3 years after thelarche**, and ACOG reports that **98%** of females have menstruated by age 15. These are population context and evaluation prompts, not a diagnosis or personal prediction. [ACOG Committee Opinion 651]
- **Teen secondary amenorrhea / long gaps:** once menstruating, a gap **> ~90 days** is the evidence-based raise-it point even in early gynecologic years (ACOG 651, 95th-percentile cycle length — inherited from A2 §D); children's-hospital patient education commonly describes secondary amenorrhea as periods stopping **≥3 months** (Nationwide, Stanford; some sources use 6 months — Femio teaches the conservative ~3-month raise-it point). A missed-period check in a sexually active teen includes a pregnancy test as a routine first step — Femio states this neutrally as "a standard first test," no assumptions, no judgment (StatPearls; AAFP).

**Causes — taught gently, grouped, never as a checklist of dooms**
- **Constitutional delay / normal variation** is one possible explanation, and family timing is useful history, but Femio does not call it the most likely cause for an individual or publish clinic-cohort cause percentages. Evaluation distinguishes normal variation from energy-related, endocrine, ovarian, anatomical, and other causes.
- **Energy/stress-related (functional hypothalamic amenorrhea, incl. RED-S)** — the brain's cycle signals pause when the body has less fuel than it needs: intensive sport (ballet, running, gymnastics, skating), restricted eating, weight loss, or significant stress; **reversible**, but matters now because estrogen supports **bone building during the teen years** (Cleveland Clinic hypothalamic amenorrhea; PMC FHA-in-adolescent-athletes reviews; NEDA athletes resource). *Framing rule: "your body is protecting itself and asking for more fuel" — never blame, never numbers (§K).*
- **Hormonal / endocrine** — thyroid over- or under-activity; elevated prolactin; PCOS-pattern hormone imbalance (more typical of irregular-than-absent, adjacent A4) (Cleveland Clinic amenorrhea; Boston Children's; CHOP).
- **Ovarian** — the ovaries starting to work differently than expected, including **Turner syndrome** and primary ovarian insufficiency — uncommon, and exactly what blood tests check for; taught with base-rate calm (Endotext; StatPearls).
- **Anatomical** — rarely, a structural difference (e.g., an imperforate hymen blocking flow — often with monthly cramps but no bleeding — or a uterus/vagina that developed differently, e.g., MRKH, ~1 in 4,500, ~10–15% of primary amenorrhea) — found on exam/ultrasound (StatPearls Primary Amenorrhea; PMC MRKH literature). *Taught only inside "why doctors examine and scan — so nothing is missed," never as a headline.*
- **Medicines & other** — some medications and chronic illnesses can pause periods (Cleveland Clinic; Harvard Health).

**What the evaluation actually looks like (the demystifier — A5's core content)**
Per StatPearls, ASRM committee opinion (2024), AAFP, and children's-hospital patient education, a typical first evaluation is:
1. **Talking:** her period/development timeline, family history (when mum/sisters started), sport, eating, stress, medicines, illnesses.
2. **An individualized assessment:** growth and pubertal development may be reviewed; the clinician explains whether any examination is needed.
3. **Selected tests:** depending on history and development, a clinician may use pregnancy testing where biologically applicable, hormone blood tests, or imaging. Femio does not promise one blood draw, one imaging route, or a universal test list.
4. **Follow-up:** the clinician may recommend observation, further testing, referral, or treatment based on the findings; Femio does not set a fixed follow-up interval.

Femio teaches this as *"what guidelines describe — your doctor decides your steps."* Never a home lab interpretation, never a Femio verdict on any entered result.

**Why it's worth checking (motivation without fear)**
- Finding the cause early matters mainly for **bone health** (low estrogen during peak bone-building years) and for treating treatable causes early — framed as investment in her body, not as threat (PMC FHA bone reviews; ACOG 651's "cycle as vital sign" logic).

---

## E. Feature set (prioritized: must-have → nice-to-have)

**Must-have (MVP for A5)**
1. **Minor-tier teen mode by default** — inherited A1/A2 architecture: no ads, strict data minimization, no community/DMs/UGC, trusted-adult linkage, GDPR-K/COPPA handling.
2. **"Nothing to track is still a real home"** — a no-period home surface that leads with reassurance + the check-in guide, not an empty bleed calendar. **Absolutely no "late" counter or predicted-date UI** (Master-Model invariant 5, strictest application).
3. **Calm threshold check-in guide** — the §D screening points (15 / 3-years-after-breasts / no-breasts-by-13 / ~90-day gap) as a gentle, personal "where you are" explainer, always ending in *"worth discussing with a clinician — here's how, together with a parent."* Never a result, never a label.
4. **Causes explainer, gentle-ordered** — constitutional-first, grouped as in §D, base-rate honest, designed to out-rank the 2am google spiral (§F).
5. **The evaluation demystifier** — step-by-step "what happens at the doctor" (§D walkthrough) with "it's usually not an internal exam first" and "one blood draw" plain-speak.
6. **Parent-bridge kit** — conversation scripts for telling a parent, family-history prompt ("ask your mum when she started — it's part of the medical picture"), and a parent-facing calm guide mirroring the teen content.
7. **Appointment-prep tool** — auto-assembles her development timeline (breast-bud age, growth, discharge, any periods/gaps, sport/stress context *she chooses to include*) + a questions checklist she can show the clinician (her choice, her control).
8. **ED-safe low-energy pathway** — if logs/answers suggest intensive training, restrictive eating, or big weight change alongside absent periods: quiet, non-triggering education ("fuel and periods"), supportive resources, and clinician routing — **no numbers, no blame, no ED labels** (§J, §K).
9. **Full-library reachability + Arabic-first/RTL** — inherited; stigma-reducing framing that shields her from family fertility-pressure narratives.

**Should-have**
10. **Milestone/body-signs log** (A1-style, extended): breast development stage (self-noticed), growth, discharge (its arrival often precedes menarche), monthly cramp-without-bleed notes (a specific ask-the-doctor sign), mood/energy — self-knowledge framing, feeds the appointment-prep tool.
11. **"While you wait" companion** — content for the watchful-waiting months between 6-month re-checks: what re-checks look for, it's-normal-to-feel-impatient support.
12. **Peer-story reassurance content** (editorially curated, not UGC): "I was 16 when mine started" narratives — the forum comfort without the forum risks.
13. **Myth-busting**: "no period = infertile," "no period = not a real woman," "you must have done something wrong," "it will definitely never come."
14. **Gap-tracker for the secondary path** — for Dana: days-since-last-period shown only as calm context inside the check-in guide (never as a home-screen "late" anxiety widget).

**Nice-to-have**
15. Questions-for-my-doctor notebook synced with the prep tool.
16. Post-visit "what my doctor said" note + optional next-appointment reminder.
17. Bone-health-through-the-teens explainer (why this decade of bone-building matters — motivation content).
18. Cultural add-ons for Arabic-first families (handling relatives' questions; period ≠ marriageability framing for parents).

---

## F. Content modules (reading order)

Reassurance → honest thresholds → causes (gentle) → the visit → the parent talk → waiting well → boundaries. Grade 6–8, extra-gentle, referenced, medically reviewed, 4 languages.

1. **"Your body isn't broken" (start here)** — bodies start on very different schedules; a late or paused period is a *question to check*, not a verdict; the most common answer is a healthy body taking its time. *(Reassurance with integrity: also says plainly why checking is worthwhile.)*
2. **The check-in ages, explained calmly** — where 15, "3 years after breasts," 13-no-breasts, and the ~90-day gap come from; they're the points where doctors like to *have a look*, not alarms.
3. **Why periods can be late or pause** — the §D cause groups in gentle order: late-starter bodies (most common, runs in families) → fuel/stress/sport → hormone signals (thyroid, prolactin, PCOS-pattern) → the rarer ovarian and structural reasons ("this is why doctors examine and scan — so nothing gets missed").
4. **What happens at the doctor (no surprises)** — the §D walkthrough, step-by-step, with the fears answered head-on: usually no internal exam first; one blood draw; the ultrasound is over your tummy and painless; often the plan is simply "let's re-check in 6 months."
5. **Telling your mum/dad (scripts included)** — why a parent comes with you, exact opening lines, and the family-history angle that turns the conversation into teamwork.
6. **Fuel, sport, stress and periods** — the energy-availability story told safely: your body pauses periods to protect you when fuel runs low; it's reversible; strong athletes experience this; telling your doctor (and a trusted adult) is the strong move. *No weights, calories, BMI, or body talk (§K).*
7. **"Will I be able to have kids?" (the honest page)** — the question she's actually carrying: an absent period alone doesn't answer it; most causes don't mean no; the evaluation exists to give real answers instead of 2am guesses.
8. **Waiting well** — for the watchful-waiting path: what re-checks involve, what to log meanwhile, and that impatience/envy of friends is normal and okay to feel.
9. **Myth-busting** — the §E list, corrected with references.
10. **Your body, your privacy** — inherited A2 module + A5-specific: what the appointment-prep summary contains, that *she* chooses what to share and with whom.
11. **Curious about more? (open door)** — inherited gateway to the wider library; reachable, never pushed.

---

## G. Tools, logs & alerts (with compliant framing)

**Logs (optional, self-knowledge / preparedness framing — she may have no cycle to log)**
- Milestone/body-signs log (§E.10): development signs, growth, discharge, cyclic-cramps-without-bleed, mood/energy, notes.
- For the secondary path: last-period date + gap length — stored as history/context, surfaced **only inside the check-in guide**, never as a home "late" counter.
- Optional context fields (sport hours, big life stress, appetite changes) — **free of numbers-based weight/calorie fields by design**; used solely to personalize education and the prep summary.
- **Data minimization (highest tier):** only what she chooses; no location; minor-tier retention limits.

**Tools**
- **Check-in guide** — maps her situation (age, thelarche timing, gap length) to §D screening education → always outputs *"this is worth discussing with a clinician, together with a parent — here's the calm guide,"* never a probability, cause-guess, or label.
- **Evaluation demystifier** — interactive walk-through of the §D workup.
- **Appointment-prep builder** — assembles timeline + questions; export/share is user-initiated and scoped.
- **Parent-bridge scripts** — teen-side and parent-side versions.
- **Low-energy pathway (B16-style gentle router)** — when ED-adjacent signals co-occur with absent periods: surfaces the "fuel and periods" module + supportive resources (helpline/organization links per locale) + trusted-adult/clinician encouragement. Quiet placement, dismissible, re-offerable; **never** an alert-styled warning, never an ED label, never numbers.

**Alerts (rare, private, gentle, non-clinical wording)**
- Content nudges only ("New here? Start with 'Your body isn't broken'"). Neutral lock-screen text.
- **Soft check-in prompt** when a §D threshold is met/persisting: *"Some families like to check this with a doctor — here's exactly what a visit looks like."* One-time, gentle, parent-inclusive; no repetition-nagging, no alarm styling.
- Optional user-set reminder for a booked appointment or 6-month re-check.
- **Never:** "you are late" messaging; countdowns; predicted period dates while amenorrheic; fertility/TTC framing; weight/eating prompts; ads.

---

## H. EMR fields (core vs. persona-specific)

**Core (shared)** — inherited: pseudonymous ID, DOB/age band, locale/RTL, consent + guardian linkage, symptom/mood log, privacy/state flags (minor_tier, ads_off, trusted-adult link + scope).

**Persona-specific (A5)** — all optional, self-reported, non-diagnostic:
- **Amenorrhea context type:** `primary_concern` (no menarche) vs `secondary_concern` (menarche then ≥~90-day gap) — drives which content path leads.
- **Thelarche age (approx)** + **menarche status/date** (inherited from A1/A2 where present) → derives the "3-years-after" watch.
- **Watch booleans (non-diagnostic, education/adaptation only):** no_period_by_15_watch (inherited from A1), no_breasts_by_13_watch, three_years_post_thelarche_watch, long_gap_pattern (inherited from A2), cyclic_pain_no_bleed_flag (ask-the-doctor sign).
- **Low-energy context flags (non-diagnostic, ED-safe):** high_training_load (self-described), appetite/eating-change self-report (free text/choices, **no weights/calories/BMI stored**), high_stress — gate the gentle B16-style routing only.
- **Evaluation journey state:** not_discussed / parent_told / appointment_booked / evaluated_watchful_waiting / diagnosis_recorded(user-entered label, uninterpreted) — drives "while you wait" vs prep content.
- **Appointment-prep summary** (user-assembled, user-shared only) + questions list.
- Explicitly **NOT** stored for A5: fertility/ovulation intent, contraception fields, sexual-activity data by default, any weight/calorie/BMI numerics.

---

## I. Personalization rules (wizard config + hidden-but-reachable)

**Resolves A5 when:** (a) A1 user's no-period-by-15 or 3-years-post-thelarche watch fires; (b) A2 user's >90-day gap pattern persists; (c) wizard/self-select: "I haven't gotten my period and I'm worried" / "my periods stopped"; (d) a parent onboards a teen for this concern. Age band ~13–17 ⇒ minor tier ON.

**Home is configured to lead with (extra-gentle):**
1. Reassurance card ("Your body isn't broken — start here").
2. Check-in guide ("where you are + what checking looks like").
3. Evaluation demystifier + parent-bridge kit.
4. Milestone/body-signs log (not a bleed calendar).
5. Privacy quick-controls.

**Defaults set by the wizard:**
- Minor tier ON (ads OFF, no DMs/UGC, guardian linkage per jurisdiction).
- **Prediction UI fully OFF** — no windows, no dates, no counters, until cycles exist and stabilize (then A2-style ranges).
- Tone = calm, honest, non-alarmist, non-infantilizing; **gentle_mode-adjacent** styling on flags (soft cards, never red alerts).
- ED-safe content rules ON globally for this persona (no numeric weight/food content surfaces by default anywhere in her skin).
- Neutral notification text; shared-device quick-hide; Arabic-first/RTL + stigma-reducing framing where selected.
- Parent-awareness encouraged and scaffolded (bridge kit) but sharing remains **her** choice, transparent and scoped — clinician routing is always framed as "with a parent/trusted adult."

**Hidden-but-reachable (personalize, never restrict):**
- TTC/pregnancy/contraception/adult-condition content off her home, fully reachable via search in age-appropriate framing (invariant 1).
- Deep-cause pages (Turner, MRKH, POI) are *reachable* and written teen-safe, but never pushed, previewed, or notification-linked — she meets them only inside the calm causes module or by her own search.
- Community/DMs/UGC gated (minor safeguarding), reason stated plainly.
- "Skip / not sure" → Z1, with nearest-persona offering back to A5 as signals accrue.

---

## J. Adaptation triggers (state transitions)

Universal events (§6 of the Master Model) are **inherited** — positive-test, loss, mood-crisis, red-flag, disengagement, toggle-off, age-of-consent handlers all apply. A5-specific transitions:

**Into A5:**
- **From A1:** no-period-by-15 watch or 3-years-post-thelarche watch fires → offered (never forced) A5 skin: *"Want calm guidance on late periods? You can undo this anytime."*
- **From A2:** persistent >90-day gap pattern → offered A5 secondary path (A2's amenorrhea-screening nudge lands here).
- **Wizard/parent onboarding** as in §I.

**Out of / branch from A5:**
- **Period arrives (primary path) or periods normalize (secondary path)** → celebrate calmly, tone-matched ("it came — here's what's normal next") → **A5 → A2** (newly/again menstruating: gentle logging + uncertainty-honest windows + irregular-is-expected reassurance). Watches archived-but-reachable; if gaps recur, the A5 offer returns without judgment.
- **Low-energy / ED-adjacent signals** (high training load + appetite/weight-change self-report + absent periods) → **stay in A5** + activate the gentle B16-style routing (§G): "fuel and periods" education, supportive resources, trusted-adult + clinician encouragement — quiet, dismissible, never labeled, never numeric. If mood screening is elevated alongside → universal mood-crisis handler also applies.
- **Diagnosis recorded by user** (post-evaluation, user-entered, uninterpreted) → offer the relevant track/modifier: thyroid → thyroid modifier content skin; PCOS label (clinician-given) → **A4**; POI/Turner/MRKH or other → condition-education modifier + "living with your diagnosis" support skin, clinician-led framing `[future personas as defined in taxonomy]`. Femio adapts to the *recorded* diagnosis; it never infers one.
- **Evaluation → watchful waiting recorded** → "while you wait" content mode + optional 6-month re-check reminder; stays A5.
- **Cyclic pain without bleeding logged repeatedly** → gentle ask-the-doctor prompt (outflow-question education) — screening framing only, no anatomy speculation.
- **Turning 16 / age-of-consent** → universal handler (re-confirm consent, relax minor gating; knowledge access unchanged); remains A5 while the concern is active.
- **Nothing resolved, user disengages** → universal disengagement handler; data kept; silent.

---

## K. Compliance flags

- **Scope:** wellness/education/tracking only. A5 tools must never diagnose; every threshold output is **"screening — discuss with a clinician (with a parent),"** never a cause-guess. This is the persona most tempted toward "it's probably X" — resist absolutely; over-flagging a frightened minor causes real harm, as does false reassurance. Hold the §A tension in every string.
- **No "late" UI:** counters, countdowns, or confident predicted dates are prohibited in A5 (Master invariant 5 at maximum strength). Amenorrhea + a "3 days late" badge is an anxiety machine and an implied medical claim.
- **ED-safe messaging (NEDA/NEDC-aligned):** no weights, BMIs, calories, or numeric food/exercise targets stored or displayed; no appearance-based language; no ED labels or "warning signs you have anorexia" framing; low-energy routing is supportive, quiet, dismissible, and pairs resources with clinician/trusted-adult encouragement. Use the explicit country selector and eating/body-image topic route in [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md); availability varies, and urgent risk always uses the separate emergency route. *(Find A Helpline topic directory accessed 23 July 2026; reviewed Mohamed K., 23 July 2026.)*
- **Fertility honesty without doom or promise:** the "will I have kids?" content must neither guarantee nor grimly speculate; it answers at teen level and routes to evaluation. No TTC/fertility-optimization framing at a minor, ever.
- **Minor privacy (COPPA/GDPR-K, strictest):** inherited A1/A2 tier in full — no ads, minimal data, no DMs/UGC, guardian linkage, retention limits, no location, no brokering. The appointment-prep summary is user-assembled and **user-shared only**; it is never auto-sent to a parent or clinician.
- **Parent-inclusive ≠ parent-surveillance:** clinician routing requires a parent for a minor, and Femio scaffolds that — but sharing scope stays transparent and hers; the bridge kit helps her *choose to tell*, it never tells for her.
- **Sensitive-cause content:** Turner/MRKH/POI pages must be suitable as a teen’s first exposure: explain that these are possibilities clinicians may evaluate, avoid probability claims, include living-well framing, and undergo clinical and lived-experience editorial review before publication.
- **Pregnancy-test step neutrality:** the workup walkthrough mentions the routine pregnancy test factually and without assumption or judgment — omitting it would misdescribe the visit; over-focusing on it would shame her.
- **Non-restriction principle:** teen mode governs data/ads/social, not knowledge; deep-cause and adjacent content stays reachable so the 2am spiral happens inside referenced, calm pages instead of on Google.
- **Referenced content:** the 98%-by-15 statistic, evaluation thresholds, and conservative workup description are pinned to ACOG in [`MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md). Unsupported cause percentages were removed. Urgent support uses the global policy in [`CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md); partner-review recruitment is an editorial task, not a clinical claim. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
- **Cultural sensitivity (Arabic-first/RTL):** absent periods attract family fertility/marriageability pressure in some target markets — parent-facing content must actively counter that framing ("this is about her health today, not her future family"), and the teen surface must never echo it.

---

## Sources

**Thresholds & evaluation (Tier-1/Tier-2)**
- [ACOG Committee Opinion 651 — Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)
- [AAP/Pediatrics — Menstruation in Girls and Adolescents (vital sign)](https://publications.aap.org/pediatrics/article/118/5/2245/69874/Menstruation-in-Girls-and-Adolescents-Using-the)
- [ACOG FAQ — Amenorrhea: Absence of Periods](https://www.acog.org/womens-health/faqs/amenorrhea-absence-of-periods)
- [StatPearls (NCBI) — Primary Amenorrhea](https://www.ncbi.nlm.nih.gov/books/NBK554469/)
- [StatPearls (NCBI) — Delayed Puberty](https://www.ncbi.nlm.nih.gov/books/NBK544322/)
- [ASRM — Current evaluation of amenorrhea: a committee opinion (2024)](https://www.asrm.org/practice-guidance/practice-committee-documents/current-evaluation-of-amenorrhea/)
- [AAFP — Amenorrhea: A Practical Approach to Diagnosis and Management](https://www.aafp.org/afp/2026/0700/amenorrhea)
- [MedlinePlus — Delayed puberty in girls](https://medlineplus.gov/ency/article/007694.htm)
- [Pediatric Endocrine Society — Delayed Puberty (Girls)](https://pedsendo.org/patient-resource/delayed-puberty-girls/)
- [Merck Manual (Consumer) — Delayed Puberty](https://www.merckmanuals.com/home/children-s-health-issues/hormonal-disorders-in-children/delayed-puberty)
- [Merck Manual (Professional) — Amenorrhea](https://www.merckmanuals.com/professional/gynecology-and-obstetrics/abnormal-uterine-bleeding/amenorrhea)
- [Pediatric Medicine — Amenorrhea in adolescents: a narrative review](https://pm.amegroups.org/article/view/4922/html)
- [Medscape — Menstruation Disorders in Adolescents: Workup](https://emedicine.medscape.com/article/953945-workup)

**Teen/parent-facing patient education (tone models)**
- [Center for Young Women's Health — Amenorrhea](https://youngwomenshealth.org/guides/amenorrhea/)
- [Boston Children's Hospital — Amenorrhea](https://www.childrenshospital.org/conditions-treatments/amenorrhea)
- [CHOP — Amenorrhea in Teens](https://www.chop.edu/conditions-diseases/amenorrhea-teens)
- [Nationwide Children's — Amenorrhea in Teens](https://www.nationwidechildrens.org/conditions/health-library/amenorrhea-in-teens)
- [Stanford Medicine Children's Health — Amenorrhea in Teens](https://www.stanfordchildrens.org/en/topic/default?id=amenorrhea-in-teens-90-P01579)
- [WebMD — My Teen Is 15 and Hasn't Started Her Period](https://www.webmd.com/children/children-no-period-15)
- [Harvard Health — Never Started Menstrual Periods (decision guide)](https://www.health.harvard.edu/decision_guide/never-started-menstrual-periods)
- [Harvard Health — Amenorrhea A to Z](https://www.health.harvard.edu/womens-health/amenorrhea-a-to-z)
- [Cleveland Clinic — Amenorrhea](https://my.clevelandclinic.org/health/diseases/3924-amenorrhea)
- [Nemours KidsHealth (Teens) — Irregular Periods](https://kidshealth.org/en/teens/irregular-periods.html)
- [UPMC HealthBeat — Talking to Your Teen About Her First Period (period anxiety)](https://share.upmc.com/2025/05/teen-period-anxiety/)

**Causes deep-grounding (constitutional, ovarian, anatomical)**
- [Endotext (NCBI) — Abnormalities of Female Pubertal Development](https://www.ncbi.nlm.nih.gov/books/NBK278950/)
- [PMC — Müllerian Agenesis (MRKH) case literature](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6079514/)
- [PMC — Clinical spectrum and causes of delayed puberty (endocrine-clinic cohort)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8866913/)

**Low-energy / FHA / RED-S / ED-safe messaging**
- [Cleveland Clinic — Hypothalamic Amenorrhea](https://my.clevelandclinic.org/health/diseases/24431-hypothalamic-amenorrhea)
- [PMC — Functional hypothalamic amenorrhea in adolescent athletes impairs bone accrual](https://pmc.ncbi.nlm.nih.gov/articles/PMC12722922/)
- [PMC — Functional hypothalamic amenorrhea: bone and neuropsychiatric outcomes](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9355702/)
- [NEDA — Eating Disorders and Athletes](https://www.nationaleatingdisorders.org/eating-disorders-and-athletes-2/)
- [NEDA — Social Media Community Guidelines (safe-messaging model)](https://www.nationaleatingdisorders.org/social-media-guidelines/)
- [NEDC (Australia) — Eating Disorder Safe Principles](https://nedc.com.au/eating-disorder-resources/ed-safe)
- [NEDC — Communication for public health and media](https://nedc.com.au/eating-disorders/preventing-eating-disorders/communication)

**Competitor / market context**
- [luna app — Is there a period tracker for irregular periods?](https://weareluna.app/parents/guides/periods-and-hormones/is-there-a-period-tracker-for-irregular-periods/)
- [SheKnows — Yes, Your Teen Should Be Tracking Their Period — But Are the Apps Safe?](https://www.sheknows.com/health-and-wellness/articles/1234806403/period-tracking-apps-teens/)
- [Protect Young Eyes — Best Period Tracking Apps for Young Girls](https://www.protectyoungeyes.com/blog-articles/the-best-period-tracking-apps-for-young-girls)
- [KFF Health News — Should You Worry About Period-Tracking App Data?](https://kffhealthnews.org/news/period-tracking-apps-data-privacy/)
