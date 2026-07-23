# Persona A4 — Teen With PCOS-Type Signs (Never Labeled)

Persona ID: **A4** · Track A (Puberty / Adolescent) · Mode: **Teen mode** (no ads, minimal data, no community DMs, trusted-adult opt-in)
Prepared: 2026-07-21 · Status: research + spec · Wave 3
Inherits Femio scope guardrail: **wellness / education / tracking only. Never diagnose, treat, prevent disease, or act as contraception. Screeners = "screening — discuss with a clinician."**

> **CRITICAL CLINICAL CAUTION (governs everything below):** Irregular cycles are normal in the first year after menarche. The 2023 international guideline allows an adolescent diagnosis only when **both** time-defined irregular cycles and clinical/biochemical hyperandrogenism are present after mimicking conditions are excluded; pelvic ultrasound and AMH must not be used to diagnose PCOS in adolescence. Femio’s role is **screening awareness and clinician routing—never a label.**

---

## A. Persona snapshot

| | |
|---|---|
| **Who** | "Nour," 15. Menarche at 12. Three years in, her cycles have **not** settled: still 40–60+ days apart, sometimes a skipped season. On top of that: stubborn jawline/back acne that skincare doesn't touch, dark hair appearing on her chin and stomach, and weight that's shifted despite nothing changing. |
| **Emotional state** | Confused and quietly scared. She googled "irregular periods + chin hair" at 1 a.m. and fell into a wall of infertility horror stories, "cysts," and before/after weight photos. Now she half-believes something is deeply wrong with her and half-hopes that if she ignores it, it goes away. |
| **Self-esteem load** | High. The visible signs (acne, facial/body hair, weight) hit exactly where teenage body-image pressure already lives. She's been teased about her skin; she plucks/hides the hair and tells no one. Research shows adolescents with PCOS-type presentations carry roughly double the depression risk and ~half report body-image dissatisfaction (§D). |
| **Health literacy** | Fragmentary and fear-skewed: TikTok "PCOS face" videos, a cousin's diagnosis story, SEO listicles. She knows the scary word but not the reassuring context (that no one can or should diagnose her yet, and that every sign has a management path). |
| **Privacy needs** | Very high — this is more sensitive to her than periods alone, because it touches appearance. Shared family device likely. She would rather suffer than have a sibling find "PCOS" in her browser history. |
| **Support system** | A parent who could help but whom she hasn't told, partly from embarrassment, partly from fear of being dismissed ("it's just puberty") or over-alarmed. Getting to a clinician realistically **requires a parent** — Femio must help her start that conversation, not bypass it. |
| **Language / context** | Possibly Arabic-first / RTL; hirsutism and weight are high-shame topics; facial-hair stigma can be intense. Web-first, short private sessions. |
| **Primary jobs-to-be-done** | (1) "Tell me honestly whether this is still normal or worth checking — without scaring me or labeling me." (2) "Let me track my cycles + skin + hair + energy in one private place so I have *evidence*, not vibes." (3) "Help me talk to my mum/dad and a doctor without dying of embarrassment." (4) "Make me feel less alone and less broken about how I look." |
| **What success feels like** | She understands why nobody should diagnose her yet, has a calm one-page summary she showed a parent, saw a clinician who took her seriously, and — whatever the outcome — never once felt the app call her sick, abnormal, or "at risk of infertility." |
| **Anti-goals (trust-breakers)** | A "you may have PCOS" result screen (the Flo/Clue failure, §C); infertility framing aimed at a 15-year-old; weight-loss messaging; before/after imagery; leaking "PCOS" in notifications on a shared device; telling her parent anything without her opt-in. |

**Design tension to hold:** she genuinely may need clinical follow-up (persistent pattern beyond the normal window is exactly what guidelines say to evaluate) **and** she must never be labeled (diagnosis is clinically impossible and psychologically harmful at her stage). Femio's answer: **pattern-tracking + calm education + "worth discussing with a clinician, with a parent's help" — full stop.**

---

## B. Needs & questions (voice-of-user)

Mined from teen threads on r/PCOS ("am I too young?" posts), r/Periods, teen health Q&A boards, app reviews, and adolescent-PCOS qualitative literature. Paraphrased; each mapped to what Femio surfaces.

**"Is something wrong with me?" (the dominant fear)**
- "It's been 3 years and my periods are still all over the place. Everyone said they'd settle." → *Honest framing: most cycles settle within ~1–3 years; a persistent pattern after that window is worth a clinician conversation — worth checking ≠ something is wrong (§D).*
- "I googled my symptoms and now I'm convinced I have PCOS and can never have kids." → *Direct myth-defusing: no one can diagnose you at your stage; even diagnosed PCOS is manageable and is NOT a sentence of infertility. Fertility framing is otherwise kept off her experience entirely.*
- "The internet says I have cysts on my ovaries. Do I need a scan?" → *Education: guidelines specifically say ultrasound is NOT used to check for this in teens (unreliable until ~8 years after first period) — so no, a scan is not the next step, a conversation is (§D).*
- "My period app said I might have PCOS and I've been crying." → *Femio's core anti-pattern. We never do this (§C, §K).*

**"Why do I look like this?" (body image — where it hurts most)**
- "I have a beard. I'm 15 and I have a beard." → *Hirsutism education: what drives it (androgens — hormones everyone has), how common it is, that it's a describable, checkable, manageable thing — not a failure of femininity. Removal/management options exist and are a clinician + personal-choice topic.*
- "My acne isn't like my friends' acne. It's jaw and back and it never leaves." → *Pattern education: persistent jawline/trunk acne can be hormone-related — one more reason a check-in is useful; also just: acne is not your fault.*
- "I eat the same as my friends and I'm the one gaining weight." → *Insulin-resistance education in non-blaming language; weight change can be a hormone signal, not a discipline failure. NO weight-loss prescriptions (§K).*
- "I hate my body." → *Body-image + mood support module, mood screening (screening-framed), crisis resources if screens are high (§G, universal handler).*

**"What do I actually do?" (agency)**
- "What do I even say to a doctor? Last time they said 'it's just puberty.'" → *Visit-prep: her tracked pattern as a printable one-pager + question list — the evidence that gets a teen taken seriously (adapted from B6's visit-prep, teen edition).*
- "How do I tell my mum without it being a whole thing?" → *Conversation-starter scripts + optional trusted-adult sharing of exactly and only what she chooses (§E, §G).*
- "Which doctor is it even? A gynecologist?? I'm 15." → *Education: start with a qualified local primary-care, adolescent-health, pediatric, or gynecology clinician, depending on the health system. The clinician chooses whether an examination or tests are needed; Femio does not promise a universal visit sequence.*
- "Can I fix this myself with supplements TikTok showed me?" → *Myth-busting: no teen should self-treat off social media; what "lifestyle helps" actually means (sleep, movement, eating patterns — framed as health, never thinness); anything more is a clinician topic.*

**"Don't tell anyone." (privacy)**
- "If my brother sees 'PCOS' on the shared tablet I will actually die." → *Discreet UX: neutral notifications, quick-hide, per-profile privacy; the word never appears on lock screens or in share-sheets by default.*
- "Will this app tell my parents?" → *Never without her explicit opt-in; trusted-adult sharing is granular and transparent (teen mode).*

> **Key research insight:** the harm loop for this persona is *symptom → Google → catastrophic content → shame → silence → no care*. Femio's job is to break the loop at step 2–3 with calm, referenced, non-labeling answers, and to convert silence into a supported parent+clinician conversation. The 2023 guideline explicitly builds an "**at risk, manage symptoms, reassess later**" pathway for exactly her situation — Femio's UX is that pathway in product form (§D, §J).

---

## C. Competitor teardown

The market fails this persona in a uniquely dangerous way: **apps that label, and apps that ignore.**

| App / source | What she gets | How it fails A4 |
|---|---|---|
| **Flo (PCOS health assessment)** | A quiz that can output "your symptoms may indicate PCOS — see a doctor." | **The anti-pattern.** No clinical validation; one month, ~38% of 636k quiz-takers were flagged to see a doctor vs. a true prevalence of ~5–8% — question wording pushed toward false positives; symptoms overlap normal puberty, so teens are the worst-served group. A labeling quiz aimed at a 15-year-old is exactly what adolescent guidelines say not to do. Plus ads/upsell + FTC/Meta data-sharing history (see A2). |
| **Clue (PCOS info/assessment)** | Science-forward content; some PCOS material. | Its PCOS assessment was criticized for shoddy validation (virtual-patient testing); adult-oriented; no adolescent-specific "your irregularity may still be normal" framing; paywalled predictions; no teen mode. |
| **Generic period trackers** | "Late" counters and red exclamation marks on her 55-day cycle. | Treat adolescent irregularity as anomaly → daily micro-message that she's broken. No hyperandrogenic-sign tracking at all (acne/hair/weight invisible to the app). |
| **Allura / PCOS-specific trackers** | PCOS-tuned logging for irregular bodies. | Built for **diagnosed adults**; the entire frame assumes the label she must not be given; fertility/TTC adjacency; no safeguarding. |
| **Allara Health (US telehealth)** | Real PCOS clinical care. | Adults, US-only, paid; irrelevant to a 15-year-old in Femio's markets — but proves demand for the "taken seriously" journey Femio's visit-prep feeds. |
| **TikTok / "PCOS face" content** | Her current de-facto source. | Catastrophizing, appearance-shaming, supplement-selling, zero adolescent-diagnosis nuance. The competitor Femio is really displacing. |
| **KidsHealth / hospital pages (Nemours, Boston Children's, CHOP-type)** | Genuinely good, calm adolescent PCOS education. | Static pages: no tracking, no pattern evidence for her visit, no privacy-safe personal space, English-centric, and she has to already know to look there. |

**White space Femio owns for A4:**
1. **The only tracker with an adolescent "at-risk-aware, never-labeling" mode** — implements the 2023 guideline's at-risk pathway as UX instead of a diagnosis quiz.
2. **Pattern-evidence generation**: cycles + skin + hair + energy in one exportable teen visit-prep sheet — the artifact that converts "it's just puberty" dismissal into evaluation.
3. **Body-image-first tone**: hirsutism/acne/weight content written to reduce shame, with zero weight-loss or before/after framing — no incumbent does this for teens.
4. **Parent-bridge tooling**: conversation scripts + opt-in scoped sharing — competitors offer either surveillance or nothing.
5. **Arabic-first/RTL** adolescent hormone education — effectively empty niche, in markets where facial-hair stigma is highest.

---

## D. Clinical grounding (cited)

Tier-1 and Tier-2 sources; URLs in **Sources**. Everything below is surfaced in-product as *education + screening awareness*, never diagnosis.

**Why a teen must not be labeled (the load-bearing facts)**
- Irregular cycles are **developmentally normal for ~1–3 years post-menarche** (many cycles anovulatory) — inherited grounding from A2 (ACOG vital-sign opinion; KidsHealth; Johns Hopkins).
- **Do not diagnose from irregularity alone.** Irregular cycles are normal in the first post-menarcheal year, and adolescent diagnosis requires both guideline-defined irregular cycles and hyperandrogenism after excluding mimics. [2023 International Evidence-based PCOS Guideline]
- **2023 International Evidence-based PCOS Guideline — adolescent-specific criteria:** diagnosis in adolescents requires **both** (1) irregular menstrual cycles *defined by time post-menarche* and (2) clinical or biochemical **hyperandrogenism**, after excluding mimics. **Pelvic ultrasound and AMH must NOT be used for diagnosis in adolescents** — polycystic ovarian morphology is unreliable until ~**8 years post-menarche** (Human Reproduction / JCEM 2023; BMC Medicine 2025 adolescent recommendations; ASRM summary).
- **The "at risk" designation (Femio's A4 backbone):** an adolescent with only **one** feature (irregular cycles *or* hyperandrogenism) — or with features inside the ambiguous window — can be considered "**at risk of PCOS**": manage the symptoms, follow up over time, and **reassess at or before ~8 years post-menarche** when diagnostic clarity improves. This is an internationally sanctioned "watch and support, don't label" pathway (2023 Guideline; BMC Medicine 2025).

**What counts as "irregular" by time post-menarche (screening-awareness thresholds, guideline-derived)**
- <1 year post-menarche: irregularity is **normal** — no flag.
- 1–3 years post-menarche: cycles persistently **<21 or >45 days** are outside the expected range.
- >3 years post-menarche: adult criteria begin to apply (**<21 or >35 days**, or **<8 cycles/year**).
- Any stage: **>90 days for any single cycle** (after year one) is a "raise with a clinician" flag (shared with A2/A5).
- Primary amenorrhea by 15 / >3 years post-thelarche routes to A5 pathway.
These bands reproduce recommendation 1.1.1 of the 2023 International Evidence-based PCOS Guideline. Femio uses them only to support a clinician conversation, never to diagnose. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

**Hyperandrogenic signs (education, described neutrally)**
- **Hirsutism** (coarse dark hair in a male-type pattern: face, chest, abdomen, back), **moderate–severe or persistent acne** (especially jawline/trunk), and in some, **acanthosis nigricans** (dark velvety skin at neck/armpits — an insulin-resistance sign) (Office on Women's Health; KidsHealth; Nemours; PMC adolescent reviews).
- Biochemical confirmation (blood tests) is a **clinician** matter; Femio only explains that such tests exist and are simple.

**Mimics — why "check" ≠ "PCOS"**
- Thyroid dysfunction, hyperprolactinemia, non-classic congenital adrenal hyperplasia, and **eating disorders / over-exercise / stress** can all cause the same picture; exclusion is part of any evaluation — one more reason a quiz can't diagnose and a clinician visit is worthwhile whatever the cause (2023 Guideline; PMC reviews). Guideline also advises **eating-disorder assessment consideration** in this group — Femio must never respond to weight logs with restriction messaging.

**Mental health & body image (why tone is a clinical feature)**
- Adolescents with PCOS(-type presentations) show roughly **2× odds of depression** vs. peers (meta-analysis, Frontiers in Endocrinology 2024); anxiety findings are mixed but prevalent in cohorts; **~49% body-image dissatisfaction** reported in adolescent PCOS cohorts; obesity/insulin-resistance features worsen body-image scores, which mediate mood symptoms (Children/MDPI 2024).
- The 2023 guideline recommends **routine anxiety/depression screening** in adolescents in this pathway — Femio implements this as optional, screening-framed check-ins with clinician routing (§G).

**Management landscape (EDUCATIONAL only — Femio never treats)**
- **Healthy-lifestyle support is first-line** for at-risk adolescents — framed around energy, sleep, movement, and balanced eating for health, with explicit **weight-stigma awareness**; guidelines warn against making weight the message (2023 Guideline).
- Clinicians *may* discuss combined hormonal therapy or metformin for symptom management in adolescents — Femio explains that these conversations exist so she isn't blindsided, with a clear "clinician-only, never from an app" frame; **never** a recommendation, and for a minor **never** contraception framing (§K).
- Fertility content is **excluded from A4 defaults** entirely: developmentally irrelevant, anxiety-producing, and the single most reported Google-spiral fear. Reachable in the library like everything else (never-restrict), but nothing in her experience pushes it.

---

## E. Feature set (prioritized)

**P0 — must-have**
1. **Teen mode (inherited, default ON):** no ads, minimal data, no community DMs, trusted-adult opt-in, neutral notifications, quick-hide, shared-device safety.
2. **Persistent-pattern tracker (the core A4 tool):** cycle log that understands **gynecologic age** — evaluates her regularity against the *right* post-menarche band (§D), never against an adult 28-day norm, never shows "late."
3. **Sign log (body-image-safe):** optional acne (location/severity), unwanted-hair (areas, her words), skin changes (acanthosis-type darkening described neutrally as "skin changes to mention"), energy, cravings, mood. Weight is **optional, off by default, never prompted**.
4. **"At-risk-aware" screening surface (never a label):** when a persistent pattern (irregularity beyond her band **plus/or** hyperandrogenic signs) is logged over time, Femio surfaces: *"Patterns like yours are worth discussing with a clinician — not because something is wrong, but because a check-in now answers questions Google can't. Here's how to bring it up with a parent."* Output is **always** this; never "you may have PCOS."
5. **Teen visit-prep pack:** printable/exportable one-pager — cycle history vs. expected-for-her-age ranges, sign timeline, her questions — plus "what the appointment will actually be like" education. Built to defeat "it's just puberty" dismissal.
6. **Parent-bridge kit:** conversation-starter scripts ("ways to bring this up"), an optional parent-facing explainer page (what clinicians check and why teens aren't diagnosed early), and **opt-in, scoped** trusted-adult sharing (she picks exactly what's visible).
7. **Calm education hub (§F):** the anti-Google. Leads with "why no one can diagnose you yet" and "every sign on your list has an explanation and a management path."
8. **Uncertainty-honest prediction:** wide window + plain reason; in her irregular state the UI degrades gracefully to trend view + "this is expected at your stage" (Master model invariant 5).

**P1 — strong differentiators**
9. **Body-image & mood support module:** normalizing content on hirsutism/acne/weight, self-compassion framing, optional mood screening (screening-framed) with crisis resources on high screens (universal handler).
10. **Myth-busting: "What TikTok got wrong about PCOS"** — infertility catastrophizing, "cysts," supplement cures, PCOS-face.
11. **Reassess-later timeline:** a gentle, private view of her own pathway — "your body is still calibrating; here's when clarity typically comes (up to ~8 years post-menarche); here's what we're keeping track of for that conversation." Turns the guideline's follow-up recommendation into felt continuity instead of limbo.
12. **Arabic-first/RTL** versions of all of the above, with hirsutism content culturally reviewed (highest-shame topic).

**P2 — nice-to-have**
13. Optional private photo log for skin/hair progress (local/private, never shared by default, never analyzed as "diagnosis").
14. "Questions I'm embarrassed to ask" anonymous Q&A content format.
15. Journal + questions-for-my-doctor notes (shared with A2).

---

## F. Content modules (reading order)

Reassurance-first, grade 6–8, referenced, medically reviewed, 4 languages, body-image-safe imagery (no before/afters, no idealized skin).

1. **"First: nobody can diagnose you right now — and that's official."** The 2–3-year window, the 8-year ultrasound rule, and why that's protective, not dismissive. The single most important page; defuses the Google spiral.
2. **"Your cycles, by *your* clock."** Gynecologic age; what irregular means at 1, 2, 3+ years post-menarche; when a pattern becomes worth a conversation (the §D bands, framed calmly).
3. **"Why the acne and the hair."** Androgens explained (everyone has them); hirsutism and hormonal acne described neutrally; you did nothing wrong; management options exist and are a clinician + personal-choice topic.
4. **"Weight, energy, cravings — when it's hormones."** Insulin resistance in plain words; skin darkening (acanthosis) as a sign to mention; explicitly non-blaming; food/movement framed as energy and health, **never** thinness.
5. **"What 'at risk' means (and doesn't)."** The guideline's watch-and-support pathway; "at risk" = "worth keeping an eye on together," not "sick," not "will develop it."
6. **"What a check-up actually looks like."** Which clinician, what happens (talking, maybe blood tests; **no scan** — guidelines say not at your age), what mimics they rule out and why that's good news.
7. **"How to tell your parent."** Scripts, timing ideas, what to show them (her visit-prep sheet), a page she can hand them.
8. **"Your feelings are part of this."** Mood, body image, being teased; why guidelines literally recommend checking on mental health in this pathway; where support lives (module + crisis resources).
9. **"Myths vs. facts."** Infertility catastrophizing ("PCOS ≠ you can't have kids — and you're not even diagnosable yet"), "cysts aren't cysts," supplements, PCOS-face TikTok.
10. **"Tracking without obsessing."** Logging as evidence-gathering, not surveillance of her own body; it's okay to take breaks.
11. **Open door (inherited from A2):** the whole library stays reachable — including adult PCOS content (B6's modules) if she goes looking; teen mode governs data/ads/social, never reading.

---

## G. Tools, logs & alerts (compliant framing)

**Logs**
- Cycle: start/end, flow; derived cycle length vs. **her post-menarche band**; longest-gap counter.
- Signs: acne (site/severity), unwanted hair (areas), skin changes, energy, cravings, sleep, mood; **weight optional, off by default, never nudged**.
- All optional, minimal, encrypted; no location; deletable.

**Tools**
- **Gynecologic-age-aware pattern view** — her trend against age-appropriate ranges; "expected at your stage" annotations; no "late," no red alarms.
- **Uncertainty-honest predictor** — wide window + reason; degrades to trend view when irregular (never a countdown, never a "late" counter).
- **Teen visit-prep generator** — one-tap export of cycle history + sign timeline + her questions; a parent-facing explainer attachable **by her choice**.
- **Screeners (screening-framed, never a result-label):**
  - *Pattern-awareness check* — output is only ever: "This pattern is worth discussing with a clinician — a parent or trusted adult can help you book that. This is screening, not a diagnosis; only a clinician can figure out what's going on."
  - *Mood screen* (adolescent-appropriate) → "screening, not diagnosis" + support module; **high score → crisis resources immediately** (universal handler).

**Alerts (private, neutral, dismissible)**
- Notification text never contains "PCOS," "hormones," or body-sign words; lock-screen-safe.
- Gentle pattern prompt only after **persistence** (recurring out-of-band cycles and/or sustained sign logs — never a single data point): *"You've been tracking something worth a conversation. Want help planning it?"*
- Reassurance nudges post-log ("a 50-day cycle at your stage: here's the honest picture").
- **Never:** "you may have PCOS," infertility warnings, weight-loss prompts, fertile-window/"safe day" anything (minor + not-contraception, §K), ads, TTC upsell.

---

## H. EMR fields (core vs. persona-specific)

**Core:** inherited unchanged (pseudonymous ID, DOB/age band, locale/RTL, consent + minor tier, cycle log, symptom/mood log, screener history — all per Master model §3).

**Adolescent layer (inherited from A-track):** gynecologic age, menarche date (approx OK), cycle-regularity status, longest-gap, trusted-adult link + scope, adjacent-flag booleans.

**A4-specific (all non-diagnostic, surfaced-not-destroyed):**
- `pcos_pattern_watch` (boolean, internal): persistent out-of-band irregularity **plus** hyperandrogenic sign logs — drives education emphasis + gentle prompts only. **Never rendered to her as a status/label; never named "PCOS risk score."**
- Hyperandrogenic sign log: acne (site/severity/time), unwanted-hair areas, skin-changes flag.
- Metabolic self-report (optional): energy, cravings; weight only if she enables it.
- `at_risk_discussed` marker: she recorded that a clinician said "at risk / recheck later" → unlocks the reassess-later timeline (§E-11) and softens prompts (she's already in care).
- Reassessment horizon (derived: menarche date + guideline window) — powers the timeline view, never a countdown.
- Mood-screen history (scores + dates, screening-only).
- Visit-prep exports history; parent-explainer shared y/n.
- Explicitly **NOT** stored: fertility/ovulation intent, contraception fields, any clinician-diagnosis inference. If she reports an actual clinician diagnosis, that's a §J transition, not an A4 field.

---

## I. Personalization rules

**Wizard/resolver routes to A4 when:** A-track teen (minor tier ON) **and** persistent irregularity beyond her post-menarche band **plus** hyperandrogenic signs — usually arriving **from A2** via logged pattern (§J), or via wizard self-report ("my periods never settled and I have acne/extra hair I'm worried about"). A single irregular stretch or acne alone does **not** resolve to A4 (stays A2; blending rule §8 of Master model — screening vs. label kept distinct).

**Home config:**
1. Calm hero: pattern view + "expected at your stage / worth a conversation" honest framing (never an alarm).
2. One-tap discreet log (cycle + signs).
3. "Start here: why nobody can diagnose you yet" (§F-1) pinned.
4. Parent-bridge + visit-prep card (rises in prominence as pattern persists).
5. Body-image/mood support card (rises if mood logs/screens trend low).

**Defaults:** teen mode ON (all A2 protections inherited); predictions = wide windows/trend view; tone = straight-talking, non-infantilizing, body-neutral; imagery neutral and diverse (no idealized skin/bodies); weight logging OFF; fertility/TTC/contraception content hidden-but-reachable; Arabic-first/RTL if selected, hirsutism copy culturally reviewed.

**Hidden-but-reachable:** the full library including adult PCOS (B6) content, TTC, contraception education — reachable via search, never pushed. Teen mode gates social/data/ads only (invariant 1).

---

## J. Adaptation triggers (state transitions)

**Universal events inherited** from Master model §6 (positive test, loss, mood-crisis, red-flag, disengagement, toggle-off, age-of-consent) — not restated. A4-specific:

| Trigger | System response | Route |
|---|---|---|
| **From A2:** persistent PCOS-adjacent pattern (out-of-band cycles sustained beyond the 2–3-yr window **plus** hyperandrogenic signs) | Gentle offer, explicit confirm, reversible: "Want Femio to focus on tracking this pattern and help you plan a check-in?" — screening framing, no label | A2 → **A4** |
| **Clinician says "at risk — recheck later"** (she logs it) | Set `at_risk_discussed`; unlock reassess-later timeline; soften clinician-prompts (she's in care); keep symptom support + follow-up nudges at her chosen cadence | Stay A4 ("supported watch" sub-state) |
| **Clinician evaluation finds another cause** (thyroid, etc.) or "all normal" | Celebrate the clarity; offer to dial A4 emphasis down; keep history; route condition education if she wants it | A4 → A2/B1 (or condition modifier) |
| **Cycles regularize** and signs settle | Reassurance ("this is what settling looks like"); offer step-down | A4 → A2 → B1 in time |
| **Turns 16 / age-of-consent** | Universal handler: re-confirm consent/privacy tier; teen gating relaxes per jurisdiction; A4 pattern-watch continues unchanged | Stay A4 (adult-consent tier) |
| **Reaches adulthood with pattern persisting, or reports a clinician PCOS diagnosis** | Warm handoff: "Everything you've tracked comes with you." Enable adult PCOS mode; entire A4 history (cycles, signs, screens) carries into the B6 layer — constant-EMR, zero rebuild | A4 → **B6** (the canonical A-track→B-track continuity edge) |
| **Adulthood, no diagnosis, still irregular** | B-track irregular mode without PCOS framing unless/until clinically raised | A4 → B6-adjacent irregular mode |
| **>90-day gaps dominate without hyperandrogenic signs** | Re-weight toward amenorrhea screening education | A4 ↔ **A5** blend |
| **Heavy-bleeding / severe-pain pattern** | A3 education + clinician prompt layered on (union of safety layers, Master §8) | A4 ⊕ A3 modifier |
| **Mood screens trend low / body-image distress signals** | Body-image & mood module to top of home; screening + support routing; crisis resources on high screens (universal) | Stay A4 + support emphasis |
| **Weight-log behavior suggests restriction/over-tracking** (e.g., very frequent weight entries + falling mood) | Never diet feedback; surface eating-disorder-aware support content + "worth talking to someone you trust" routing (guideline: ED assessment consideration in this group) | Stay A4, gentle_mode |
| **She toggles A4 emphasis off** | Revert to A2/generic teen experience; preserve all history | A4 → A2 |

All transitions: offered, confirmed, reversible, never phrased as diagnosis (invariant 3).

---

## K. Compliance flags

- **Scope (hardest constraint of any persona):** wellness/education/tracking only — and for A4 specifically, **no output may ever assert or imply she has PCOS**. The pattern-awareness screener has exactly one output class: "worth discussing with a clinician, with a parent's help." No risk scores shown to her, no percentages, no "likely."
- **The Flo/Clue lesson is codified:** unvalidated PCOS quizzes generated ~38% "see a doctor for PCOS" flags against ~5–8% prevalence. Femio's screener fires only on **persistent, guideline-derived patterns**, is worded to avoid false-positive pressure, and never names a condition as her probable state.
- **Adolescent diagnostic caution as product law:** the 2–3-year post-menarche window and the no-ultrasound/AMH-until-8-years rule must be *taught* in content and *respected* in logic (no A4 resolution inside the normal-irregularity window from cycles alone).
- **Minor privacy (inherited, full A2 stack):** teen mode default — no ads, minimal data, no community DMs, trusted-adult **opt-in + transparent + scoped**, GDPR age-of-consent handling, shared-device safety, neutral notifications. Additionally for A4: the strings "PCOS"/hirsutism/body-sign words never appear in notifications, share-sheets, or page titles visible in browser history where avoidable.
- **Body image & eating-disorder safety:** weight optional and never prompted; no weight-loss messaging, calorie framing, or before/after imagery; restriction-pattern signals route to support, never to diet content; copy weight-stigma-reviewed (2023 guideline).
- **Not contraception / no fertility framing:** no fertile-window, "safe day," or fertility-risk messaging in the A4 experience; infertility myths addressed only reactively in myth-busting content, reassurance-framed.
- **Mental health:** until an exact validated adolescent instrument, production-language version, clinical follow-up pathway, and self-harm response are approved, use non-instrument wellbeing check-ins plus clinician/support routing. Any later PHQ-9 adolescent workflow must follow [`docs/compliance/MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md); urgent routing follows the global crisis policy. *(ACOG 2017; AAP GLAD-PC reaffirmed June 2025; reviewed Mohamed K., 23 July 2026.)*
- **Safeguarding vs. surveillance:** parent-bridge features empower *her* to involve an adult; nothing is disclosed to a parent without her explicit scoped opt-in (per-jurisdiction guardian-consent law may add requirements — legal review per launch market).
- **Referenced content:** every clinical claim cited + medically reviewed; grade 6–8; 4 languages; Arabic hirsutism/weight content gets dedicated cultural review.
- **Verification register:** cycle bands are pinned to the 2023 International Guideline; mental-health instruments follow [`MENTAL_HEALTH_SCREENERS.md`](../compliance/MENTAL_HEALTH_SCREENERS.md). Local provider pathways and competitor claims remain separate operational/research tasks and must not be presented as universal facts.

---

## Sources

**Clinical — Tier 1 (NIH / MedlinePlus / OWH / patient-grade institutional)**
- [Polycystic ovary syndrome — Office on Women's Health (womenshealth.gov)](https://womenshealth.gov/a-z-topics/polycystic-ovary-syndrome)
- [PCOS — MedlinePlus (NIH)](https://medlineplus.gov/polycysticovarysyndrome.html)
- [Nemours KidsHealth (Teens) — PCOS](https://kidshealth.org/en/teens/pcos.html)
- [Nemours Children's Health — PCOS Treatment for Teens](https://www.nemours.org/conditions-treatments/polycystic-ovary-syndrome.html)
- [Boston Children's Hospital — PCOS](https://www.childrenshospital.org/conditions-treatments/polycystic-ovary-syndrome-pcos)
- [St. Louis Children's Hospital — PCOS symptoms in teens](https://www.stlouischildrens.org/health-resources/pulse/pcos-symptoms-in-teens)
- [Children's Health (Dallas) — Polycystic ovarian syndrome, adolescent gynecology](https://www.childrens.com/specialties-services/conditions/polycystic-ovarian-syndrome)

**Clinical — Tier 2 (guidelines / peer-reviewed, adolescent-specific)**
- [2023 International Evidence-based Guideline for the Assessment and Management of PCOS — Human Reproduction](https://academic.oup.com/humrep/article/38/9/1655/7241786)
- [2023 PCOS Guideline Recommendations — J Clin Endocrinol Metab](https://academic.oup.com/jcem/article/108/10/2447/7242360)
- [International evidence-based recommendations for PCOS in adolescents — BMC Medicine (2025)](https://link.springer.com/article/10.1186/s12916-025-03901-w) · [PubMed](https://pubmed.ncbi.nlm.nih.gov/40069730/)
- [Adolescent PCOS according to the international evidence-based guideline — BMC Medicine (2020) / PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7092491/)
- [2023 Guideline — ASRM practice-guidance summary](https://www.asrm.org/practice-guidance/practice-committee-documents/recommendations-from-the-2023-international-evidence-based-guideline-for-the-assessment-and-management-of-polycystic-ovary-syndrome/)
- [Monash — PCOS Guideline Summary 2023 (PDF)](https://www.monash.edu/__data/assets/pdf_file/0003/3371133/PCOS-Guideline-Summary-2023.pdf)
- [ESPE 2023 — International guidelines: recommendations in adolescent girls](https://abstracts.eurospe.org/hrp/0097/hrp0097rfc7.2)
- [Update on diagnosis of PCOS during adolescence — Fertility & Sterility / ScienceDirect (2025)](https://www.sciencedirect.com/science/article/abs/pii/S0015028225019016)
- [Polycystic Ovarian Syndrome in Adolescents — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9951123/)
- [PCOS in Adolescence: Challenges in Diagnosis and Management — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9948137/)
- [The Diagnosis of PCOS in Adolescents — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3218544/)
- [NYU Langone — Diagnosing PCOS in Adolescents](https://nyulangone.org/conditions/polycystic-ovary-syndrome-in-adolescents/diagnosis)
- [ACOG — Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)

**Mental health / body image in adolescent PCOS**
- [Depression, anxiety and self-esteem in adolescent girls with PCOS: systematic review & meta-analysis — Frontiers in Endocrinology (2024)](https://www.frontiersin.org/journals/endocrinology/articles/10.3389/fendo.2024.1399580/full) · [PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11471625/)
- [Body Image and Other Mood Vulnerabilities in Adolescents with PCOS and Metabolic Alterations — Children (MDPI, 2024)](https://www.mdpi.com/2227-9067/11/5/521) · [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11119722/)
- [Body Perception, Self-Esteem, and Comorbid Psychiatric Disorders in Adolescents with PCOS — J Pediatr Adolesc Gynecol / ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1083318820303156)
- [Self-esteem/self-compassion mediating body dissatisfaction and depression in adolescents with PCOS — Frontiers in Public Health (2024)](https://www.frontiersin.org/journals/public-health/articles/10.3389/fpubh.2024.1420532/full)

**Competitor / app-labeling failure**
- [Advisory Board — Did your period-tracking app say you have a disorder? Why it could be wrong](https://www.advisory.com/daily-briefing/2019/11/11/pcos)
- [Vice — Period tracker apps like Clue are giving PCOS advice based on shoddy science](https://www.vice.com/en/article/8xw74x/period-app-clue-gives-pcos-advice-based-on-shoddy-science)
- [Healthy Debate — An app I use to track my period says I might have PCOS. Should I trust it?](https://healthydebate.ca/2020/02/topic/period_tracking_app_feb2020/)
- [CCLI — PCOS? The reason your period app can't tell](https://ccli.org/2019/11/pcos-the-reason-your-period-app-cant-tell/)
- Competitor privacy/teen-market grounding inherited from A2 (Flo FTC/Meta history, Clue, Stardust, Spot On) and B6 (Allara, Allura, PCOS-tracker landscape) — see those specs' Sources.
