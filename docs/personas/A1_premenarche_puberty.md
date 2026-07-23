# Persona A1 — Pre-Menarche Girl Learning About Puberty (~9–12)

Persona ID: **A1** · Track A (Puberty / Adolescent) · Mode: **Teen mode (minor tier)** (no ads, minimal data, no community DMs, trusted-adult involvement, GDPR age-of-consent, extra-gentle tone)
Prepared: 2026-07-16 · Status: research + spec · Wave 1 (Spine)
Inherits Femio scope guardrail: **wellness / education / tracking only. Never diagnose, treat, prevent disease, or act as contraception. Screeners = "screening, discuss with a clinician."**

---

## A. Persona snapshot

| | |
|---|---|
| **Who** | "Nour," ~10. Hasn't had her first period yet (pre-menarche). Notices *something* changing — a sore lump behind one nipple, a bit of white discharge in her underwear, a growth spurt, new hair, moodier days — and doesn't know if it's normal. |
| **Emotional state** | Curious **and** anxious, sometimes scared. Big underlying questions: "Is this normal? Am I okay? Is it going to hurt? Will people know?" Wants to feel *prepared*, not ambushed. |
| **Health literacy** | Very low — lower than A2. Little to no formal education yet; fragments from a friend, an older sister, a parent (often "not yet, you're too young"), or a scary/adult corner of the internet. Holds concrete misconceptions ("blood every day," "it means I can get pregnant now so it's shameful"). |
| **Privacy needs** | Very high but *different* from A2: she is **using the app with a parent's awareness** and often alongside a parent, yet still wants a private, un-embarrassing space. Likely a **shared family device/tablet**. |
| **Device / context** | Web-first; frequently a shared browser, sometimes handed the parent's phone. Short, supervised-ish bursts. |
| **Language** | May be Arabic-first / RTL. In many target markets pre-menarche talk is **"aib" (عيب / shameful)**; mothers are the main (and often late) source → information access is low, stigma high. |
| **Primary jobs-to-be-done** | (1) "Explain what's happening to my body in a way that isn't scary." (2) "Tell me what a first period is and what to expect so I'm ready." (3) "Reassure me I'm normal." (4) "Let me learn privately, with everything else reachable — don't lock the door on me." |
| **What success feels like** | She understands breast buds / discharge / hair / growth / moods are normal and expected; she has a plain mental model of what a period is and a simple "when it comes, here's what to do" plan; she feels calm and prepared; a parent is gently in the loop without it being surveillance. |
| **Anti-goals (things that break trust)** | Anything scary, clinical, or adult-sexualized; "you're too young to see this"; pink-glitter-only baby framing; ads; any pregnancy/contraception/fertility framing pointed at a child; being made to feel dirty or ashamed; a parent silently watching everything she reads. |

**Design tension to hold:** A1 needs the *gentlest, most reassuring* on-ramp of any persona **and** the same non-restriction principle — the full library stays reachable, teen mode governs *data, ads, and social*, not *knowledge*. The extra A1 nuance vs. A2: **parent-awareness is expected and often welcome**, so the trusted-adult layer is more prominent — but it is still framed as *shared learning*, never covert monitoring. Femio's job for A1 is **anticipatory guidance**: teach the body *before* the event so the first period is met with recognition, not fear.

---

## B. Needs & questions (voice-of-user)

Mined from parent/pediatric puberty guides (KidsHealth, HealthyChildren/AAP, CHOC, Johns Hopkins), "questions girls are afraid to ask" content (American Girl, Always, Motherly), menarche-preparedness studies, and MENA/Arabic menstrual-taboo research. Two voices matter for A1: **the girl** and **the parent in the loop**. Each mapped to what Femio should surface.

**The girl — "Is this normal?" (dominant emotion: reassurance + curiosity + a little fear)**
- "There's a hard, sore lump under one nipple — is something wrong?" → *Normalize: breast buds (thelarche) are usually the **first** sign of puberty; often one side first; tenderness fades (§D).*
- "I have white/clear stuff in my underwear — is that a period? Am I sick?" → *Thin clear/white discharge can be a normal puberty change; it does not predict the exact date of a first period (§D).*
- "I'm growing hair / I smell different / I got taller / I'm moody — what's happening to me?" → *All expected puberty changes; sequence and reassurance (§D, §F).*
- "When will I get my period? Will it hurt? How much blood? Will everyone see?" → *Plain "what to expect," a simple range, and a calm "here's your plan" (§D, §F).*
- "Does my period mean I'm grown up / that something embarrassing is true about me now?" → *Gently de-shame; it's a normal healthy body milestone, not an adult/sexual statement (§K).*

**The girl — "Am I okay?" (worry / early- or late-timing)**
- "My friends have boobs/periods and I don't" **or** "I'm changing way before everyone — am I weird?" → *Wide-normal framing; only a persistent extreme is a "let's ask a doctor together" (§D, §J).*
- "It's going to hurt / be gross / go wrong at school." → *Preparedness = the antidote; a period kit + a plan (§F).*

**The girl — "Please keep this a little bit private."**
- "I don't want my brother/friends to see this on the tablet." → *quick-hide, neutral naming, no lock-screen leakage, per-profile privacy — even with a parent aware.*
- "Can I read about this without an adult reading over my shoulder every time?" → *Yes: parent-awareness ≠ parent-surveillance; trusted-adult layer is transparent and scoped, not a live feed of everything she reads (§I, §K).*

**The parent (aware, often co-using) — voice-of-caregiver**
- "How do I explain this without scaring her? What's age-appropriate?" → *Parent conversation-starters + a "do it together" mode.*
- "What's normal vs. when should I worry?" → *Calm "wide normal" + the §D "talk to a clinician" thresholds (early <8 / late no-breast-by-13), framed as reassurance-first.*
- "Is it safe? Ads? Data? Is she seeing sexual content?" → *Minor tier: no ads, minimal data, no DMs; extra-gentle, non-sexualized default surface.*
- Research reality: **mothers are the main source but often "too little, too late,"** and in MENA markets the topic is *aib*; a private, referenced, gentle tool **lowers the barrier** for both.

> **Key research insight:** menarche-preparedness education **raises knowledge and positive/neutral emotional response and lowers menarche anxiety**; unprepared girls disproportionately report shame, fear, and social withdrawal at first period. For A1, calm anticipatory education *is* the core value — and it works best when a trusted adult is gently involved.

---

## C. Competitor teardown

How existing products serve — or fail — a **pre-menarche 9–12-year-old and her parent**. The recurring failures: products are built for people who **already menstruate** (nothing for the *before*), or they are **general sex-ed** (accurate but broad, video-only, not private/tracked/Arabic), or they are **ad-supported trackers** unsafe for a child.

| Product | A1 fit | Strengths for A1 | Fails A1 on |
|---|---|---|---|
| **AMAZE (amaze.org)** | Aimed at 10–14; genuinely age-appropriate. | Free, animated, medically-accurate, non-cringe puberty explainers ("Am I Normal?", "Boobs and More", body odor, changing bodies); parent resources + conversation starters. | Video library, **not** a private personal space — no tracking, no "what's happening to *me*", no first-period readiness plan; broad sex-ed scope (some parents object for a 9-yo); **English-centric, not Arabic-first/RTL**; not referenced inline for a child. |
| **KidsHealth for Kids / Teens (Nemours)** | Excellent pre-teen reading level. | Tier-1-grade, plain-language "When Will I Get My Period?", puberty, discharge; trustworthy, calm. | Static articles; no personalization, tracking, readiness plan, or privacy layer; not Arabic-first; a curious girl still has to *find* it. |
| **Always #PubertyTalk / period-prep programs** | Classic first-period brand. | Free puberty Q&A, "first period" prep, product familiarity; culturally reaches many markets. | Marketing-led and product-selling; shallow depth; not a private referenced app; limited Arabic-first digital experience; no gentle red-flag literacy. |
| **MagicGirl / "teen period tracker" apps** | Marketed to tweens. | Age-styled tracker + puberty videos + symptom log. | Built around **having** a cycle — thin for the *pre-menarche before*; **community chat/UGC** (a real safeguarding risk for a 9–12-yo); unclear referencing; data/privacy and ad concerns; not Arabic-first/privacy-by-default. |
| **Luna / teen-first apps** | Under-18, doctor-made. | Puberty content, reassurance framing, ask-a-doctor, parent guides — closest in spirit. | English-centric; not Arabic-first/RTL; not privacy-by-default minor tier as specified; referencing depth varies; regional availability. |
| **Clue / Flo (adult trackers w/ teen content)** | Min age 13/16; **below A1's age**. | Large libraries; some first-period content. | **Age floor excludes A1**; fertility/TTC framing; ad/upsell pressure; Flo's data-sharing history (FTC/Meta); wrong default surface for a child. |
| **Spot On (Planned Parenthood)** | Teen-friendly, non-stereotyped. | Plain, non-infantilizing, free. | US-repro-politics brand = non-starter for many Arabic-first/conservative families; contraception-forward (wrong for a 9-yo); English-centric. |

**White space Femio can own for A1:**
1. **The "before" nobody builds for** — anticipatory, *pre*-menarche readiness (breast buds, discharge, hair, growth, moods, "what a period is and your plan for it") as a *personal, private* space, not just a video or a tracker that assumes you already bleed.
2. **Privacy-by-default minor tier with a *welcome* parent layer** — no ads, minimal data, no DMs, quick-hide on shared tablets; trusted-adult involvement that is **transparent shared learning**, not surveillance.
3. **Referenced, medically-reviewed, grade 6–8 (extra-gentle for A1)** — vs. video-only or unreferenced app blurbs.
4. **Arabic-first / RTL, stigma-reducing** puberty education — a near-empty niche where the topic is *aib*; the incumbents are English-centric.
5. **Personalize-never-restrict** — the only app that gives a curious child a gentle, non-scary home surface **and** keeps everything reachable, so she never leaves for a frightening or adult corner of the web.

---

## D. Clinical grounding (cited)

The reviewed thresholds below are patient education, not diagnosis. Femio uses the signed adolescent section of [`MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md) and routes concerns to a qualified clinician. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

**Normal puberty sequence and timing (girls)**
- **Puberty normally begins ~8–13** in girls (average onset ~10–11). Onset before 8 or absence of any breast development by ~13 falls outside the typical window (KidsHealth, HealthyChildren/AAP, Cleveland Clinic).
- **Thelarche (breast buds) is usually the first sign** — a firm, sometimes tender lump under the areola, often **one side before the other**; this is Tanner **stage 2** and is normal (StatPearls Tanner; Healthgrades; HealthyChildren).
- **Typical sequence:** breast buds → pubic/underarm hair (pubarche) + body odor/skin changes → **growth spurt / peak height velocity** → **menarche** (Johns Hopkins; Merck; pediatric-medicine physiology review).
- **Peak height velocity occurs ~1 year *before* menarche** (~Tanner 3, avg peak ~8 cm/yr, mean age ~12); most growth happens before the first period, with ~2–3 inches (5–7.5 cm) typical *after* menarche (Johns Hopkins; UTHSC; Merck).
- **Physiologic discharge** can be thin and clear/white during puberty. Femio describes it as a possible normal change but does not use discharge to predict an exact menarche date. New odor, itching, pain, or other concerning symptoms should be discussed with a clinician.
- **Menarche averages ~12–12.5**, typically **~2–2.5 years after breast buds** (range ~0.5–3 yr), normal window roughly **8–15/16** (KidsHealth; Cleveland Clinic; Tanner reviews).
- **Mood swings, acne, body odor, growth** are expected hormonal changes of this stage (HealthyChildren/AAP; CHOC).

**"Wide normal" reassurance framing (A1's core)**
- Girls develop **at very different rates**; being earlier or later than friends is usually normal. Reassurance that variation is normal is the evidence-based emotional need (menarche-preparedness studies).

**Evidence-based "let's ask a doctor together" thresholds (screening language, NOT diagnosis)**
- **Signs of puberty before age 8** (progressive breast development, or pubic hair/rapid growth) → *precocious puberty* is defined by onset before 8 in girls and warrants **evaluation** — but many early signs are **benign normal variants** (premature thelarche/adrenarche); frame as "worth checking with a doctor," reassurance-first, **never alarm** (AAP *Pediatrics* referral guidance; KidsHealth "Precocious Puberty"; StatPearls).
- **No breast development by ~13**, or **no period by ~15** → *delayed puberty / primary amenorrhea* screening; often constitutional ("late bloomer") but should be **evaluated** (MedlinePlus "Delayed puberty in girls"; Pediatric Endocrine Society; Merck) — adjacent persona **A5**.
- **Very heavy/painful *first* periods, or a first period that is alarming** → once menstruating, A2's §D thresholds apply (soaking >q1–2h, severe pain) → "discuss with a clinician."

**Non-diagnostic, education-only.** For a pre-menarche child especially, Femio must **never** state or imply a condition; timing concerns are surfaced only as gentle, parent-involved "screening — please discuss with a clinician" (§G, §J, §K).

---

## E. Feature set (prioritized: must-have → nice-to-have)

**Must-have (MVP for A1)**
1. **Minor-tier teen mode by default (age <13 / under age-of-consent)** — no ads; strict data minimization; **no community/DMs/UGC**; **verifiable parental consent / trusted-adult linkage** per COPPA/GDPR-K; privacy-by-design.
2. **Extra-gentle "What's happening to my body?" hub** — reassurance-first, grade 6–8, referenced, medically reviewed, non-scary, non-sexualized default (breast buds, discharge, hair, growth, skin, moods, hygiene) — see §F.
3. **First-period readiness kit** — plain "what a period is," "what to expect," "here's your simple plan when it comes" + a "period kit for your bag" checklist. *Anticipatory guidance is the core A1 value.*
4. **"Am I normal?" reassurance engine** — wide-normal framing tied to what she's noticing/optionally logs (e.g., "breast bud on one side first = very common").
5. **Gentle, calm timing literacy** — the §D "wide normal" + soft "let's ask a doctor together" thresholds (early <8 / no-breast-by-13), reassurance-first, **never alarming, never diagnostic**.
6. **Welcome trusted-adult / "do it together" layer** — parent-awareness by design: co-read mode, conversation starters, and **transparent, scoped** involvement (not covert monitoring).
7. **Shared-device discretion** — quick-hide, neutral naming, no sensitive lock-screen/notification content, per-profile privacy even with a parent aware.
8. **Full-library reachability** — search reaches every topic; teen mode governs data/ads/social, **not** reading access (personalize-never-restrict).
9. **Arabic-first / RTL** + EN/FR/ES; stigma-reducing, culturally-aware tone (the *aib* barrier).

**Should-have**
10. **Optional, playful "changes I've noticed" log** (breast changes, discharge, hair, growth, mood) — framed as self-knowledge/preparedness, **not** medical tracking; no cycle math yet (she isn't cycling).
11. **Myth-busting for kids** (counters "blood every day," "it's shameful," "a tampon can get lost/hurt me," "it means I'm grown up now").
12. **Parent guide / conversation-starter pack** (how to talk about it without fear; culturally-aware MENA version).
13. **"When my first period comes" one-tap readiness card** (calm step-by-step for the moment it happens, incl. at school).
14. **Gentle body-literacy illustrations** — neutral, warm, age-appropriate, **not** glitter-baby, **not** clinical/adult.

**Nice-to-have**
15. Optional questions-for-my-doctor / questions-for-my-mum note.
16. Cultural add-ons (what a period means for prayer/fasting later — clearly educational, future-facing).
17. Gentle mood/energy "how am I feeling" check-in (self-knowledge, not diagnosis).
18. Age-appropriate audio/read-aloud for lower literacy.

---

## F. Content modules (reading order)

Sequenced reassurance → what's changing → what a period is → readiness → self-knowledge → boundaries → open door. All grade 6–8 (extra-gentle for A1), referenced, medically reviewed, in 4 languages.

1. **"You're normal, and this is exciting not scary" (start here)** — bodies change on their own schedule; you're not sick, not broken, not "grown up in a scary way." *(Reassurance-first, per preparedness research.)*
2. **What's changing in my body?** — breast buds (often one side first, tender = normal), hair, body odor + hygiene, skin/acne, growth spurt, moods; the usual *order* of changes.
3. **The white stuff in my underwear (discharge)** — what physiologic discharge can look like, why it does not predict an exact first-period date, and which accompanying symptoms merit a clinician conversation.
4. **What is a period? (plain words)** — what it is, that it comes and goes monthly (not every day), how much blood (less than it looks), that it's a healthy normal body thing.
5. **Getting ready: your first-period plan** — your period kit for your bag, using pads, what to do if it starts at school, who you can tell.
6. **"Am I early / late / different from my friends?"** — wide-normal reassurance; the calm "some things are worth asking a doctor about — let's do it together" note (early <8 / no signs by 13), never scary.
7. **Feelings and moods** — why you might feel up and down; it's the hormones, it passes, it's okay.
8. **Myth-busting** — the common scary/wrong things kids hear, corrected gently with references.
9. **Your body, your privacy** — what Femio does/doesn't do with your info; how to keep it private on a shared tablet; what a trusted adult can and can't see (shared learning, not spying).
10. **Curious about more? (open, gentle door)** — respectful, age-appropriate gateway to the wider library so a curious girl never has to go somewhere scary or adult to get an answer. Reachable, never pushed.

---

## G. Tools, logs & alerts (with compliant framing)

**Logs (optional, playful, self-knowledge / preparedness framing — she is *not* cycling yet)**
- "Changes I've noticed": breast changes, discharge, hair, growth, skin, mood — as **milestones**, not medical data.
- **No cycle prediction math** for A1 (no menses yet) — deliberately absent; introduced only at the A1→A2 transition.
- **Data minimization (highest tier):** only what she chooses; **no location**; no default cloud-of-brokers; minor-tier retention limits.

**Tools**
- **"Am I normal?" explainer** — maps a noticed change to wide-normal reassurance + reference; never a result/label.
- **First-period readiness planner** — builds her kit + plan; pure education.
- **Timing "let's check with a doctor together" helper** — if early (<8 signs) or late (no breast by 13) patterns are indicated, outputs **"this is worth screening — please discuss with a clinician,"** reassurance-first, parent-in-the-loop; **never** a diagnosis (§D, §J, §K).
- **Trusted-adult co-learning tool** — shared reading + conversation starters; scope always shown.

**Alerts (rare, private, gentle, non-clinical wording)**
- Reassurance/education nudges only (e.g., "New here? Start with 'You're normal'"). Neutral notification text; no sensitive detail on a shared lock screen.
- **Soft, parent-inclusive timing prompt** if a §D timing threshold is indicated: *"Some families like to check this with a doctor — here's a calm guide,"* + link. **No alarms, no diagnosis, no 'you might have X.'**
- **Never:** ads; any fertility/TTC/contraception messaging; anything sexualizing a child; anything implying a period means readiness for pregnancy.

---

## H. EMR fields (core vs. persona-specific)

**Core (shared across all personas)**
- Account: pseudonymous ID, age/DOB (drives minor-tier gating), language/locale, RTL flag, consent records (incl. age-of-consent + **guardian/parental-consent linkage state**).
- Milestone/symptom log: optional puberty milestones, mood, notes (all optional).
- Privacy/state: teen/minor-mode flag, ads-off flag, trusted-adult link (present + scope), data-minimization settings.

**Persona-specific (A1)**
- **Pubertal stage estimate (self-reported, non-clinical)** — e.g., "noticed breast buds / discharge / hair / growth / none yet" (drives "what's normal next").
- **Age-at-first-sign markers** (approx, optional) — thelarche/pubarche/discharge noticed.
- **Menarche status = PRE-menarche** (the defining A1 flag) + "readiness plan built?" boolean.
- **Timing-watch markers** (non-diagnostic booleans, for education/adaptation only): early-signs-before-8-watch, no-breast-by-13-watch, no-period-by-15-watch (→ A5).
- **Parent/trusted-adult involvement**: linked (usually yes for A1) + **exactly what is shared** + co-learning mode on/off.
- Explicitly **NOT** stored for A1: any cycle/ovulation/fertility data, contraception fields, sexual-activity data (reachable content, but never defaulted or logged for a child).

---

## I. Personalization rules (wizard config + hidden-but-reachable)

**Wizard resolves A1 when:** age ~9–12 **and** "hasn't had a first period yet" — or she/parent self-selects "learning about puberty / getting ready for my first period." (If already menstruating → A2.)

**Home is configured to lead with (extra-gentle):**
1. Reassurance card ("You're normal — start here").
2. "What's happening to my body?" hub.
3. First-period readiness kit + plan.
4. Privacy quick-controls (hide; what a trusted adult can see) + optional "do it together" toggle.

**Defaults set by the wizard:**
- **Minor tier ON** (ads OFF, strictest data minimization, **no community/DMs**, **parental consent / trusted-adult linkage** per jurisdiction).
- **Tone = extra-gentle, warm, reassuring, non-sexualized, non-infantilizing**; imagery neutral (not glitter-baby, not clinical).
- **No cycle predictions** shown (she isn't cycling) — deliberately hidden until A2.
- Notifications = neutral text, no sensitive detail on a shared lock screen.
- Locale = Arabic-first/RTL if selected; **stigma-reducing** framing on (the *aib* barrier).
- Parent-awareness assumed; trusted-adult layer visible but **transparent + scoped** (co-learning, not surveillance).

**Hidden-but-reachable (personalize, never restrict):**
- All cycle-tracking, TTC/pregnancy, contraception, and condition-grade content is **not on her home** but **fully reachable via search/library**, in age-appropriate framing. Minor tier changes *data/ads/social*, **not** what she can read — so a curious child never has to leave for a scary/adult source.
- **Community/DM/UGC features are the only things genuinely gated off** for a minor (safeguarding), reason stated plainly.
- Parent-facing surfaces (conversation starters, "how to talk about it") are reachable to the linked adult, **without** exposing the child's private reading log.
- "Skip / not sure" → Z1 generic gentle experience, then progressive nudge toward A1 as she indicates changes.

---

## J. Adaptation triggers (state transitions)

Events that move her **into** or **out of** A1, or branch to an adjacent persona. All transitions are gentle, transparent, reversible, parent-inclusive where appropriate, and **never** phrased as a diagnosis.

**Into A1:** wizard match (age ~9–12 + pre-menarche) or a parent onboarding a child to "learn about puberty / get ready."

**Out of / branch from A1:**
- **First period arrives (menarche logged)** → **primary transition A1 → A2** (newly menstruating teen): unlock gentle cycle logging + uncertainty-honest *window* predictions + A2's "irregular is normal" reassurance. Celebrate calmly ("you're ready — here's what's next"), preserving minor-tier privacy. This is the headline A1 adaptation.
- **Signs of early puberty (progressive breast development / puberty signs before age 8)** → surface **precocious-puberty *screening*** education, reassurance-first (most are benign variants), parent-inclusive "let's ask a doctor together" — **screening only, never a diagnosis** (§D, §K).
- **Signs of late puberty (no breast development by ~13; no period by ~15)** → surface **delayed-puberty / primary-amenorrhea *screening*** education + nudge toward **A5** + "discuss with a clinician" — often constitutional, framed calmly.
- **Turning 13 / reaching age-of-consent still pre-menarche** → re-confirm consent/privacy tier; remain A1 (pre-menarche) but relax minor gating per **GDPR age-of-consent**; knowledge access unchanged.
- **Content signals curiosity about sex/bodies beyond puberty basics** → keep content reachable + age-appropriate; **do not** re-persona her; surface trusted-adult/clinician-appropriate education. (Femio is never contraception, never sexualizes a child — §K.)

---

## K. Compliance flags

- **Scope:** wellness / education / tracking **only**. A1 content and tools must never diagnose, treat, or prevent disease. All timing concerns output **"screening — discuss with a clinician,"** never a label — critical for a child where over-flagging causes harm.
- **Child-appropriateness (highest tier):** default surface is **non-sexualized, non-scary, extra-gentle**. Puberty education is framed as normal/healthy; no adult/fertility/contraception framing pointed at a child. De-shame menarche (counter "aib"/dirty framing).
- **Not contraception / not fertility:** **no** cycle-prediction, fertile-window, or pregnancy framing for A1 — she isn't cycling and is a minor. Cycle tools appear only at the A1→A2 transition.
- **Minor privacy (COPPA / GDPR-K, strictest):** minor tier by default — **no ads, strict data minimization** (a legal obligation, not best-practice), **no community/DMs/UGC**, **verifiable parental consent / guardian linkage**, GDPR age-of-consent handling, minor-tier retention limits, **no location**, no selling/brokering (the Flo/Meta FTC anti-pattern).
- **Parent-awareness vs. surveillance:** A1 assumes a parent is aware and often co-using — but the trusted-adult layer must be **transparent, scoped, and consent-based shared learning**, **not** covert monitoring of everything the child reads. State plainly what is/ isn't shared.
- **Shared-device safety:** per-profile isolation, quick-hide, neutral naming, no sensitive lock-screen/notification content (family tablet is the norm).
- **Non-restriction principle:** minor tier governs data/ads/social — it must **not** block knowledge; every topic stays reachable via library/search so a curious child never goes to a scary/adult source.
- **Referenced content:** adolescent thresholds and non-diagnostic wording follow [`MENSTRUAL_SAFETY_THRESHOLDS.md`](../compliance/MENSTRUAL_SAFETY_THRESHOLDS.md). *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*
- **Cultural sensitivity (Arabic-first/RTL):** pre-menarche talk is high-shame ("aib") in target markets and mothers are often late sources — tone must reduce stigma and lower the barrier for both girl and parent, without exposing the child.
- **Launch-law separation:** the unsupported “6–12 months” discharge prediction was removed. Age-of-consent and parental-consent mechanics are not medical content and remain a per-jurisdiction legal launch task.

---

## Sources

**Normal puberty stages, Tanner, sequence & timing**
- [Nemours KidsHealth (Parents) — Understanding Puberty](https://kidshealth.org/en/parents/understanding-puberty.html)
- [Nemours KidsHealth (Parents) — Talking to Your Child About Puberty](https://kidshealth.org/en/parents/talk-about-puberty.html)
- [Nemours KidsHealth (Kids) — When Will I Get My Period?](https://kidshealth.org/en/kids/when-period.html)
- [HealthyChildren.org (AAP) — Physical Development in Girls: What to Expect During Puberty](https://www.healthychildren.org/English/ages-stages/gradeschool/puberty/Pages/Physical-Development-Girls-What-to-Expect.aspx)
- [Johns Hopkins Medicine — The Stages of Puberty for Girls](https://www.hopkinsmedicine.org/health/wellness-and-prevention/the-stages-of-puberty-for-girls)
- [Johns Hopkins Medicine — What is a Growth Spurt During Puberty?](https://www.hopkinsmedicine.org/health/wellness-and-prevention/what-is-a-growth-spurt-during-puberty)
- [Cleveland Clinic — Puberty: Tanner Stages for Boys and Girls](https://my.clevelandclinic.org/health/body/puberty)
- [Cleveland Clinic — Menarche (First Period): Overview, Age & What To Expect](https://my.clevelandclinic.org/health/diseases/24139-menarche)
- [StatPearls (NCBI) — Tanner Stages](https://www.ncbi.nlm.nih.gov/books/NBK470280/)
- [Merck Manual (Professional) — Physical Growth and Sexual Maturation of Adolescents](https://www.merckmanuals.com/professional/pediatrics/growth-and-development/physical-growth-and-sexual-maturation-of-adolescents)
- [Pediatric Medicine — Physiology of pubertal development in females](https://pm.amegroups.org/article/view/4978/html)
- [CHOC — Puberty: An ultimate guide for parents](https://health.choc.org/puberty-an-ultimate-guide-for-parents/)

**Discharge before menarche & body changes**
- [KT by Knix — Understanding Vaginal Discharge Before Your Teen's First Period](https://www.knixteen.com/blogs/the-rag/understanding-vaginal-discharge-before-your-teens-first-period) `[secondary]`
- [Luna app — When does discharge start before a first period?](https://weareluna.app/parents/guides/periods-and-hormones/discharge-start-before-first-period/) `[secondary]`
- [American Girl — Questions Girls Are Afraid to Ask About Puberty](https://www.americangirl.com/blogs/articles/questions-girls-are-afraid-to-ask-about-puberty)

**Early / late puberty (screen-and-refer thresholds)**
- [AAP Pediatrics — Evaluation and Referral of Children With Signs of Early Puberty](https://publications.aap.org/pediatrics/article/137/1/e20153732/52918/Evaluation-and-Referral-of-Children-With-Signs-of)
- [Nemours KidsHealth (Parents) — Precocious Puberty](https://kidshealth.org/en/parents/precocious.html)
- [StatPearls (NCBI) — Precocious Puberty](https://www.ncbi.nlm.nih.gov/books/NBK544313/)
- [MedlinePlus — Delayed puberty in girls](https://medlineplus.gov/ency/article/007694.htm)
- [Pediatric Endocrine Society — Delayed Puberty (Girls)](https://pedsendo.org/patient-resource/delayed-puberty-girls/)
- [Merck Manual (Consumer) — Delayed Puberty](https://www.merckmanuals.com/home/children-s-health-issues/hormonal-disorders-in-children/delayed-puberty)

**Menarche preparedness, anxiety & literacy (why gentle education is the core value)**
- [PMC — Improving Female Adolescents' Knowledge, Emotional Response, and Attitude toward Menarche following Menarcheal Preparation Education](https://pmc.ncbi.nlm.nih.gov/articles/PMC6571916/)
- [ScienceDirect — Menarche education and emotional preparedness: cross-sectional survey of Chinese adolescent girls](https://www.sciencedirect.com/science/article/pii/S240584402501285X)
- [PubMed — Preparing girls for menstruation: recommendations from adolescent girls](https://pubmed.ncbi.nlm.nih.gov/8588517/)
- [UPMC HealthBeat — Talking to Your Teen About Her First Period (period anxiety)](https://share.upmc.com/2025/05/teen-period-anxiety/)
- [Alliance for Period Supplies — Preparing for Your First Period](https://allianceforperiodsupplies.org/preparing-for-your-first-period/)

**Arabic-first / MENA cultural context (the "aib" barrier)**
- [PMC — Coming of age: adolescent girls' menstrual preparedness in Palestinian refugee camps (West Bank & Jordan)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9518256/)
- [iMedPub — Effect of Planned Health Educational Program on Menstrual Knowledge among Adolescent Saudi Girls](https://www.imedpub.com/articles/effect-of-planned-health-educational-program-on-menstrual-knowledge-and-practices-among-adolescent-saudi-girls.php?aid=20818)
- [MDPI Healthcare — Determinants of Menstrual Hygiene Practices Among Adolescent Schoolgirls in Saudi Arabia](https://www.mdpi.com/2227-9032/14/2/171)
- [Middle East Monitor — Normalising conversation about Arab women's sexual health (Motherbeing)](https://www.middleeastmonitor.com/20230319-normalising-conversation-about-arab-womens-sexual-health-led-to-threats-and-challenges-motherbeing-co-founder-says/)

**Competitor teardown**
- [AMAZE.org — age-appropriate puberty & sex-ed videos (10–14)](https://amaze.org/)
- [Common Sense Media — Amaze Website Review](https://www.commonsensemedia.org/website-reviews/amaze)
- [Be Prepared Period — Choosing the Best Period App for Tweens](https://www.bepreparedperiod.com/blog/best-period-app-for-tweens/)
- [KT by Knix — The Best Teen and Tween Period Apps (reviewed)](https://www.knixteen.com/blogs/the-rag/the-best-teen-and-tween-period-apps)
- [Protect Young Eyes — The Best Period Tracking Apps for Young Girls](https://www.protectyoungeyes.com/blog-articles/the-best-period-tracking-apps-for-young-girls)
- [Luna app — Choosing a Period Tracker for Your Daughter](https://weareluna.app/parents/guides/periods-and-hormones/choosing-a-teen-period-tracker/)
- [Planned Parenthood — What should I teach my middle schooler about their body?](https://www.plannedparenthood.org/learn/parents/middle-school/what-should-i-teach-my-middle-schooler-about-their-body)

**Minor privacy / compliance (COPPA / GDPR-K)**
- [FTC — When it comes to health data, comply with COPPA – no kidding](https://www.ftc.gov/business-guidance/blog/2022/03/when-it-comes-health-data-comply-coppa-no-kidding)
- [BigID — Data Minimization for COPPA: Why Less is More When It Comes to Kids' Data](https://bigid.com/blog/data-minimization-for-coppa-compliance/)
- [Pandectes — Children's Online Privacy Rules: COPPA, GDPR-K, and Age Verification](https://pandectes.io/blog/childrens-online-privacy-rules-around-coppa-gdpr-k-and-age-verification/)
