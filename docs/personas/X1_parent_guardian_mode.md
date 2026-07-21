# Mode X1 — Parent/Guardian Mode (Trusted Adult Supporting a Daughter Through Puberty)

Mode ID: **X1** · Cross-cutting **MODE**, not a life-stage persona · Implements the **adult side** of the trusted-adult link defined (teen side) in A1 §I/§K and A2 §G/§K
Prepared: 2026-07-21 · Status: research + spec · Wave 3
Inherits Femio scope guardrail: **wellness / education / tracking only. Never diagnose, treat, prevent disease, or act as contraception. Screeners = "screening, discuss with a clinician."**
Inherits the seven invariants, state object, universal events, and blending rules of `09_MASTER_ADAPTATION_MODEL.md`.

> **North-star rule (non-negotiable):** X1 is a **support-and-learn layer for the adult**, never a window into the teen. The parent sees **only what the teen explicitly, granularly, revocably shares — and the teen always sees exactly what is shared**. Femio's parent mode must be the anti-surveillance counterexample in a market where "parent modes" are surveillance-shaped (§C). Minors' privacy is paramount; when parent convenience and teen privacy conflict, **teen privacy wins, every time**.

---

## A. Who she is (mode snapshot)

| | |
|---|---|
| **Who** | "Mona," ~38–48. Mother (occasionally aunt, grandmother, or legal guardian) of a girl who is pre-menarche (A1, ~9–12) or newly menstruating (A2, 12–15). Often the person who onboarded her daughter to Femio in the first place, or was invited by her. |
| **Two hats** | She may **also be a Femio user in her own right** — typically a B-track (cycle/gynae) or F-track (perimenopause) persona. X1 is a **mode layered onto her own account**, not a separate account: one person, one login, two contexts ("My health" / "Supporting [daughter's name]"). If she is not otherwise a user, X1 can run standalone on a minimal account. |
| **Emotional state** | Wants to do better than her own mother did ("I found out at menarche, terrified — she won't"). Anxious about saying the wrong thing, starting too early, or making it weird. In MENA contexts, may carry her own inherited *aib* (عيب) shame around the topic and need de-shaming **for herself first**. Also quietly worried: "how do I know if something is actually wrong?" |
| **Health literacy** | Moderate but patchy and often outdated ("we didn't learn this"); may hold the same myths her daughter hears. UNFPA Arab-region data: ~40% of women/girls had **no information before menarche**, and ~two-thirds got support from mothers/friends only **after** the first period — she is often repeating a cycle of "too little, too late" unless helped (§D). |
| **Privacy posture** | Two-sided: she wants reassurance her child is safe in the app (no ads, no strangers, no data selling) **and** she may expect visibility into her daughter's activity — an expectation Femio must **gently re-educate** (visibility is the teen's to grant), because covert monitoring measurably erodes trust and adolescent autonomy (§C, §D). |
| **Device / context** | Web-first; her own phone; sometimes the same family tablet her daughter uses (per-profile isolation matters on both sides). |
| **Language** | May be Arabic-first / RTL. The MENA framing is central: mothers are the **main source** of menstrual information yet the topic is high-shame, so a private, referenced, culturally-aware coach for the *mother* is a near-empty niche (§C, §D). |
| **Primary jobs-to-be-done** | (1) "Teach **me** how to talk about puberty and periods without fear or shame — scripts, timing, what's normal at each stage." (2) "Show me what my daughter *chooses* to share, so I can support her — nothing more." (3) "Remind me of her checkups and help me prepare questions." (4) "Tell me calmly which patterns are worth a doctor visit — and which are normal so I stop worrying." |
| **What success feels like** | The talks happen early, in small natural doses, without embarrassment on either side; her daughter comes *to her* (because the app never went behind the daughter's back); she knows the wide-normal ranges and the few real flags; the clinician visit happens on time with good questions. |
| **Anti-goals (things that break the product)** | A dashboard of the daughter's logs or reading history; covert alerts about the daughter's data; "monitor your teen" marketing; guilt-tripping her for not sharing; any framing of the daughter's cycle as the *parent's* data; fear-based red-flag messaging; preachy or Western-assumptive tone on cultural questions. |

**Design tension to hold:** Mona's instinct (and the market's default) is *visibility = safety*. The evidence says the opposite: control-shaped monitoring erodes trust, drives teens to hide (or to worse sources), and stunts the self-management the adolescent years exist to build (§D). Femio resolves the tension by **redirecting her energy from watching to learning**: X1's core product is *her* education and *her* conversation toolkit — the daughter's shared cards are a bonus the daughter controls, not the point.

---

## B. Her needs (voice-of-parent)

Mined from parent guides (KidsHealth/Nemours, HealthyChildren/AAP, CHOC, UNICEF Parenting), parent-community advice threads and expert Q&As on "the talk," teen-app parent reviews, and MENA menstrual-communication research. Each mapped to what X1 surfaces.

**"How do I even start?" (the dominant need — her own education)**
- "When should I start talking about periods? She's only 9." → *Start early, in small doses; not one Big Talk — a series of natural, age-layered conversations (KidsHealth, UNICEF; §D). X1 gives stage-matched starter prompts.*
- "What words do I use? I get embarrassed." → *Plain anatomical language, calm/neutral delivery; side-by-side activities (car rides, cooking) lower the eye-contact pressure (§D). Scripts provided, incl. Arabic ones that model non-shaming vocabulary.*
- "My mother never spoke to me about this — I don't have a model." → *De-shaming content for HER first: her own menarche story, naming the inherited taboo, why breaking it protects her daughter (UNFPA; §D).*
- "What is actually normal at her age? Everything I know is 30 years old." → *A parent's mirror of the A1/A2 wide-normal content: puberty sequence, timing ranges, irregular-early-cycles, discharge-before-menarche (§D).*
- "What do I say when she asks about prayer/fasting on her period?" → *Culturally-aware, educational answers for Arabic-first families — respectful, non-preachy, clearly framed as cultural/religious information, not Femio rulings.*

**"Is she okay?" (worry — needs calm flag literacy, not alarms)**
- "Her periods are all over the place — do I take her to a doctor?" → *Irregular is expected the first 1–3 years; the real flags are the §D thresholds (>~90-day gaps, soaking >q1–2h, pain that stops school, no period by 15 / no breasts by 13, signs before 8).* 
- "She's 8 and developing — is that too early?" / "She's 13 and nothing yet." → *Screening thresholds framed reassurance-first: most variants are benign; "worth checking together," never alarm (§D).* 
- "How heavy is too heavy?" → *Concrete parent-visible signals (product changes >q1–2h, doubling up, big clots, dizziness/fatigue) → "discuss with a clinician" (NHS/ACOG; §D).*

**"Help me support her practically."**
- "Remind me about her checkup / help me prepare." → *Her own reminders for the daughter's clinician visits (data SHE enters — see §G boundary), plus the ACOG 13–15 initial-visit explainer incl. what to expect (usually no internal exam) and why the clinician will speak to her daughter alone (§D).*
- "What should be in her school period kit? What do I buy?" → *Parent's version of the A1 readiness kit checklist.*
- "She shared her cycle summary with me — what do I do with it?" → *A 'how to respond well' companion for every shared card: what it means, what NOT to say, one good opening line.*

**"Reassure me the app is safe — and tell me honestly what I can't see."**
- "Can I see what she reads/tracks?" → *No — and here's why that's the design, not a gap: transparent-sharing model explained up front (Luna's split is the precedent; the research on monitoring is the reason; §C, §D). What she CAN receive: exactly what her daughter chooses to share, always visible to the daughter.*
- "Are there ads? Strangers? Is her data sold?" → *Minor tier guarantees restated plainly: no ads, no DMs/community for minors, data minimization, no brokering (§K).* 

**Two-hats needs (when she's also a B/F-track user herself)**
- "Keep my perimenopause world and her puberty world separate — I don't want her stuff mixed into my tracking, or mine visible to her." → *Hard context separation: distinct home tab, separate notification channel, nothing about the daughter inside her own health surfaces and vice versa (§I).*
- "Funny timing — I'm perimenopausal while she hits puberty." → *An optional, genuinely useful explainer: two hormonal transitions under one roof (mood, cycles changing at both ends) — empathy content, never shared data.*

---

## C. Competitor teardown — parent modes in teen apps

The market's parent layers cluster into two failed shapes: **surveillance-shaped** (parent sees the child's data/activity — the dominant anti-pattern) and **absent** (adult trackers with no parent story at all). Almost nobody builds the third shape Femio needs: **parent-as-learner with teen-controlled sharing**.

| Product | Parent-layer shape | Strengths | Fails on |
|---|---|---|---|
| **Luna (weareluna.app)** | Closest precedent: linked parent account manages subscription, sees only **top-level** info (e.g., count of articles read), previews the teen app; teen's reads/questions/tracking stay private. Strong parent guide library. | Explicit "teens have their own private space" stance; parent education content; setup guide for adding a teen. | Even article-*counts* leak reading behavior (Femio goes stricter: engagement metadata is not shared by default); English-centric, not Arabic/RTL; parent guides are marketing-adjacent, not referenced to Tier-1; no teen-controlled granular sharing scopes; no MENA cultural layer. |
| **Bark / Life360 (parental-control category)** | Pure surveillance: content scanning, alerts, location. Named here as the **anti-pattern**, not a comparable. | Illustrates the market default parents arrive expecting. | Research-documented harms: ~89% of parental-app features serve parental control vs ~11% teen self-regulation; monitoring linked to eroded trust and harmed autonomy; kids lack any rights over their own data (§D sources). Life360's history of selling location data to brokers is the exact data-ethics failure Femio's minor tier exists to prevent. |
| **MagicGirl / tween trackers** | Some ship parent visibility into the tween's cycle data by default. | Age-styled onboarding. | Parent-visible-by-default is covert-adjacent (tween may not grasp scope); community/UGC safeguarding risk; unreferenced; not Arabic-first. `[NEEDS SOURCE — verify MagicGirl's current parent-visibility mechanics before citing in public copy]` |
| **Oky (UNICEF)** | Deliberately **no** parent layer: girl-only, local-only storage, no PII, discreet icon. | The gold standard for teen privacy; proof that a minors' period app needs no parent window to be safe. | Solves privacy by omission — offers the parent nothing: no education, no conversation support, no consent workflow; leaves the "mother is the main source" lever unpulled. |
| **Flo / Clue (adult trackers)** | No real parent mode. Flo has teen content but its FTC/Meta data-sharing history disqualifies it as a trust model; Clue is GDPR-strong but adult-oriented. | — | The parent of a 10-year-old has nowhere to go in either; neither implements guardian consent as a *product*, only as a legal checkbox. |
| **Spot On (Planned Parenthood)** | Teen-facing only; parent resources live on the PP website, disconnected from the app. | Reputable education. | Brand is a non-starter for many Arabic-first/conservative families; contraception-forward; no in-product parent layer. |

**White space Femio can own with X1:**
1. **The parent-as-learner mode nobody builds** — conversation coaching, stage-matched "what's normal," de-shaming for the parent herself — instead of a dashboard.
2. **Teen-controlled, teen-visible sharing** — stricter than Luna (no engagement metadata), warmer than Oky (the mother is engaged, not excluded).
3. **Arabic-first / MENA cultural coaching for mothers** — the single emptiest niche found in this research: mothers are the main source, the topic is *aib*, and no product coaches the mother in her own language.
4. **Consent as ceremony, not checkbox** — verifiable parental consent (COPPA/GDPR-K) doubling as the moment both sides learn the sharing model.
5. **Two-hats architecture** — one account, parent mode + her own B/F persona, cleanly separated; no competitor supports the mother's own health journey alongside her support role.

---

## D. Clinical & communication grounding (cited)

Tier-1 (KidsHealth/NHS/MedlinePlus/UNICEF) and Tier-2 (AAP/HealthyChildren, ACOG) sourced; URLs in **Sources**. Surfaced as *education for the parent*, never diagnosis. X1 inherits the full A1 §D (puberty sequence/timing) and A2 §D (adolescent cycle norms) evidence base rather than restating it; below is what is **parent-specific**.

**How parents should communicate (the evidence-based method X1 teaches)**
- **Early, small, and often — not one Big Talk.** Start before changes begin and layer age-appropriate talks over years; children should hear it from a parent before peers/internet (KidsHealth "Talking to Your Child About Periods"; UNICEF Parenting).
- **Before menarche, not after.** Unprepared girls disproportionately report fear, shame, and withdrawal at first period; preparation education measurably improves knowledge and emotional response and lowers anxiety (menarche-preparedness studies, inherited from A1 §D). WebMD/AAP-aligned guidance: waiting until it happens means she meets it terrified.
- **Plain anatomical words, calm delivery.** Correct terms (vulva, vagina, period), neutral facial expression, physiology framing ("natural, healthy body process") to reinforce normalcy (KidsHealth; Planned Parenthood parent blog).
- **Lower the pressure.** Side-by-side settings (car, kitchen) where eye contact is optional make awkward topics easier for both sides (parenting-expert guidance; `[secondary]`).
- **Talk to sons too** — de-stigmatization is a household project (KidsHealth; UNICEF).
- **MENA reality X1 must address head-on:** ~40% of Arab-region women/girls had *no* information before menarche; support typically arrives only *after* the first period; mothers are the main source across Egypt, Jordan, Saudi studies, and maternal education level predicts daughter preparedness (UNFPA Arab States; IJWH Saudi readiness study; mother-daughter-relationship studies). X1's Arabic conversation coaching directly targets this gap — including de-shaming the **mother's** own inherited framing first.

**Why the sharing model must not be surveillance (evidence)**
- Parental-control tooling is overwhelmingly control-shaped (~89% of features parent-control vs ~11% teen self-regulation) and children describe it as invasive (UCF children's-reviews study; arXiv "Surveillance Disguised as Protection").
- Continuous tracking is associated with damaged parent-teen trust and hindered autonomy development; researchers advocate joint/cooperative oversight over unilateral control (Scientific American on GPS-tracked teens; "From Parental Control to Joint Family Oversight").
- AAP's social-media-and-youth guidance: restrictive monitoring undermines the problem-solving and self-regulation adolescence is supposed to build; open communication outperforms covert checking (AAP Center of Excellence Q&A).
- Monitored children often lack any rights over their own collected data — an injustice Femio's teen-owned-data model is designed against (§H, §K).

**When a parent should seek care (parent-framed screening thresholds — inherited numbers, parent-visible signals)**
All framed *"worth discussing with a clinician — usually reassuring,"* never alarm:
- **Puberty signs before 8** (progressive breast development ± rapid growth/pubic hair) → evaluation-worthy, though many variants are benign (AAP *Pediatrics* referral guidance; KidsHealth Precocious Puberty — A1 §D).
- **No breast development by ~13; no period by ~15** (or ~3 years after breast budding), or **no period by 13 with no other puberty signs** (NHS Starting Periods; MedlinePlus delayed puberty; ACOG — A1/A2 §D).
- **Heavy bleeding a parent can spot:** product change more often than every 1–2 hours, doubling up, flooding through clothes/bedding, clots larger than ~a 10p coin / ~2.5 cm, a period regularly >7 days, or dizziness/exhaustion (NHS Heavy Periods; ACOG adolescent HMB; KidsHealth parent guide). Untreated → iron-deficiency-anemia education.
- **Pain that stops life** — missed school, vomiting → not something to push through (CHLA/Cleveland Clinic — A2 §D).
- **Gaps > ~90 days** after cycles have begun (ACOG 95th-percentile — A2 §D).
- **The routine visit:** ACOG recommends an **initial reproductive-health visit at 13–15**; usually **no internal pelvic exam**; parents should expect and support **confidential one-on-one time** between clinician and teen — X1 explicitly prepares her to welcome, not resist, that confidentiality (ACOG Initial Reproductive Health Visit; ACOG Confidentiality in Adolescent Health Care).

**Non-diagnostic discipline.** X1 never tells a parent "your daughter may have X." It teaches thresholds generically as education; the only daughter-specific signal a parent ever receives is content the **daughter chose to share** (§G).

---

## E. Feature set (prioritized: must-have → nice-to-have)

**Must-have (MVP for X1)**
1. **Mode toggle, not new account** — "Supporting [name]" context added to her existing account (or a minimal standalone account). Hard separation from her own health context (§I).
2. **Guardian consent & linking ceremony** — the COPPA/GDPR-K verifiable-consent flow, designed as a *shared onboarding*: both parent and teen see the same plain-language screen stating exactly what the parent will and won't see; teen (age-appropriately) acknowledges; consent recorded (§H, §K).
3. **Conversation coach ("How to talk about it")** — stage-matched (matched to daughter's *self-declared broad stage* only, or parent's own estimate — see §G): starter scripts, timing guidance, plain-vocabulary bank (incl. Arabic non-shaming vocabulary), "what she's probably wondering," what-not-to-say. The core of the mode.
4. **Parent mirror of "what's normal"** — parent-voiced versions of A1/A2 §D: puberty sequence/timing, discharge-before-menarche, first-1–3-years irregularity, all referenced, grade 6–8 clarity.
5. **Calm red-flag guide for parents** — the §D thresholds as parent-visible signals + "how to raise it with her without scaring her" + "what the doctor visit will look like."
6. **Her own reminders** — clinician appointments *she* schedules for her daughter (parent-entered data, stored on the parent's side only), first-visit-at-13–15 nudge, "kit restock before school year" type prompts. Never derived from the daughter's logs.
7. **Shared-cards inbox** — the receiving end of the teen's opt-in sharing (§G): renders exactly what the daughter shared, with a "how to respond well" companion per card type. Empty state says why it's empty and never guilt-trips.
8. **Transparency panel** — always-available "What I can and cannot see" screen mirroring, word-for-word, the panel the daughter sees. The two views can never disagree (single source of truth: the scope object, §H).
9. **Arabic-first / RTL + MENA cultural layer** — mother-focused de-shaming module ("your daughter's *aib*-free start begins with you"), prayer/fasting educational answers, tone that respects conservative families without endorsing shame.
10. **No surveillance surface, by design** — no reading history, no login/activity indicators, no engagement metadata, no notifications triggered by the daughter's logging. (A deliberate *absence* is a feature and is marketed as one.)

**Should-have**
11. **First-period readiness for parents** — parent's checklist companion to A1's readiness kit (what to buy, what to put in the school bag, the "when it happens" script, celebrating calmly).
12. **"Ask together" mode** — parent-initiated co-reading sessions of A1/A2 content (the A1 "do it together" layer's adult side): both read the same article on their own devices or one shared screen; session is explicit and visible to both.
13. **Questions-for-the-doctor builder** — parent's version; can merge (only with the teen's consent) with the teen's own question list before a visit.
14. **Myth-check for parents** — the misconceptions *she* may carry (tampons/virginity myths, "periods sync," hygiene myths), corrected with references.
15. **Two-transitions explainer** (two-hats users): perimenopause + daughter's puberty under one roof.

**Nice-to-have**
16. Multi-child support (one X1 mode per linked child, scopes independent).
17. Second-guardian support (e.g., father or grandmother; each link separately consented by the teen-side flow, each scope independent, teen sees the full list).
18. Printable/exportable conversation cards for offline talks.
19. Localized directory-style education on school policies / period products availability per market. `[NEEDS SOURCE per launch market]`

---

## F. Content modules for HER (reading order)

Parent-voiced, referenced, medically reviewed, EN/AR/FR/ES, grade 6–8 clarity (she is busy, not a clinician). Sequenced: de-shame her → equip her → calm her → prepare logistics → boundaries.

1. **"You're her first and best source — and it's not too early" (start here)** — the evidence that early, small talks work; the cost of "too little, too late"; permission to be imperfect. *(MENA edition leads with her own story: "How did you find out? She deserves better — and you can give it.")*
2. **What's happening in her body (parent mirror)** — puberty sequence, wide-normal timing, what comes ~6–12 months before a first period; what stage-appropriate heads-ups sound like.
3. **How to actually have the talks** — scripts by stage (before signs / early signs / around menarche / after); vocabulary bank; side-by-side settings; recovering from an awkward moment; talking to sons too.
4. **De-shaming, in your culture** — naming *aib* without shaming *her* culture; religiously/culturally aware answers (prayer, fasting, family privacy); how shame drives girls to worse sources.
5. **The first period: your plan as a parent** — kit, the day-of script, calm celebration, what NOT to do (announcements, jokes, panic).
6. **What's normal after periods start** — first-1–3-years irregularity, skipped months, why the app shows her daughter *windows not dates* (so the parent doesn't demand false certainty).
7. **When to see a doctor — the calm list** — §D thresholds, parent-visible signals, "how to raise it with her," and the 13–15 first-visit explainer incl. why the clinician sees her alone and why that's good.
8. **What Femio shows you — and what it never will** — the sharing model in plain words; why no reading history; what the research says about monitoring vs. trust; how to earn being shared-with (spoiler: by responding well).
9. **Responding well to shared cards** — for each card type: what it means, one good sentence to open with, three sentences to avoid.
10. **Growing with her** — what changes as she matures in the app (scope stays hers, gating relaxes at age-of-consent, the link eventually dissolves) so the ending is expected, not felt as loss (§J).

---

## G. Tools & the sharing model (the heart of the mode)

**The sharing model — five rules (implements A1 §I/§K and A2 §G/§K from the adult side):**
1. **Teen-initiated, opt-in, granular.** Nothing is shared by default. The teen (from her own surface) picks **card types**, not a data feed. A1-age children get a simplified, guided version of the chooser (parent-awareness is *expected* at A1 per the persona, but the mechanism is identical — explicit cards, never ambient access).
2. **Scoped to summaries, never raw logs.** Shareable card types: *cycle summary* ("period started / ~expected window"), *"know your normal" summary* (A2 §G tool), *readiness-plan progress* (A1), *a specific article she wants to read together*, *questions-for-the-doctor list*, *a free-text note*. **Never shareable at all (no toggle exists):** reading/search history, symptom/mood raw logs, screener answers/results, notes, anything sexual-health-related.
3. **Transparent to the teen, always.** The teen's privacy panel and the parent's transparency panel render from the **same scope object** (§H) — the teen sees every active card type, every linked adult, and a log of what was sent when. No silent scope changes: any change notifies both sides.
4. **Revocable in one tap, without drama.** Teen revokes any card type or the whole link instantly; parent sees a neutral "sharing has changed" state — **never** the reason, **never** a "win her back" prompt. Femio never nags the teen to share or tells the parent how to pressure her.
5. **Asymmetric by design.** The parent can *request* ("I'd love to know roughly when your period's due so I can have supplies") — the request appears gently on the teen's side, ignorable without notice of refusal. Refusal is silent; only acceptance is visible. Pressure has no surface to grow on.

**X1 tools**
- **Shared-cards inbox** — receives cards; each renders with its "respond well" companion; no history analytics, no trends computed on shared data beyond what the card itself contains.
- **Conversation coach** — stage-matched scripts (stage from the parent's own input or the teen's self-declared broad stage *if the teen shares it as a card*; defaults to age-band guessing from parent input alone).
- **Parent reminders** — appointment/kit reminders on parent-entered data only. Explicitly **not** connected to the daughter's cycle logs (Femio never says "her period is late — book a doctor" from her data; it teaches thresholds generically and lets shared cards speak for themselves).
- **Doctor-visit prep** — ACOG 13–15 visit explainer + question builder + (consented) merge with the teen's list.
- **"Ask together" launcher** — proposes a co-read; teen accepts/declines; both sides see the session.

**Alerts (parent-side; sparse, calm)**
- Her own reminders (appointments, kit restock, "new stage-matched conversation guide available").
- Card-received notifications (neutral lock-screen text: "Femio: you have an update" — no health detail; the daughter's name never appears in a notification).
- **Never:** alerts derived from the daughter's logging, inactivity, reading, screener results, or revocations-as-alarms. **Never** ads in X1 context (it touches a minor's ecosystem).

---

## H. Data / consent fields (mode-specific)

**On the PARENT'S account (X1 layer)**
- `x1_mode: on` + `linked_minors[]` — each: `link_id`, child display-name (parent-chosen label), child pseudonymous ref (no duplicate PII).
- `guardian_consent_record` per link: consent artifact (jurisdiction-appropriate verification method), timestamp, jurisdiction, version of the sharing-model text consented to. Retained per legal-record rules even after link dissolution (§J, §K).
- `parent_entered_events[]` — appointments, kit reminders (parent's data, parent's side only).
- `received_cards[]` — shared cards as delivered (retention short + purge-on-revocation policy: revoking a card type deletes previously delivered cards of that type from the parent surface `[decision: recommended — confirm with legal whether delivered-card purge is retroactively enforceable per market]`).
- `own_persona` — her B/F-track state, fully independent (§I).

**On the TEEN'S account (owning side — the scope object lives HERE)**
- `trusted_adult_links[]` — each: adult pseudonymous ref, relationship label, `scope{card_type: on/off}` (all default **off**), created/modified timestamps, `share_log[]` (what was sent when — visible to the teen).
- `pending_requests[]` — parent card-requests awaiting the teen (silently expirable).
- Consent acknowledgment state (age-appropriate assent record alongside the guardian consent).

**Single-source-of-truth rule:** the scope object exists **only** on the teen's side; the parent surface is a pure read-model of it. There is no parent-side override, no admin path, no support-ticket path that widens scope without the teen-side flow. The teen's data remains the **teen's**: at age-of-consent it is wholly hers with no parent residue (the anti-pattern of parental-control apps where children never gain rights over their own data — §D).

**Explicitly NOT stored / NOT derivable in X1:** daughter's reading/search history, raw logs, screener data, mood data, any inference about the daughter computed on the parent side, daughter's DOB beyond age-band needed for consent jurisdiction logic.

---

## I. How the mode composes with A1/A2 (and with her own persona)

**With A1 (pre-menarche child, ~9–12):**
- A1 expects parent-awareness; X1 is where that awareness *lives*. The A1 "do it together" toggle (A1 §I) pairs with X1's "Ask together" launcher.
- Guardian consent for the child's account runs **through** X1's linking ceremony (or creates a minimal X1 account for a non-user parent) — consent UX doubles as sharing-model education for both.
- A1's guided simplified sharing chooser offers: readiness-plan progress, co-read articles, "first period happened" milestone (the child controls even this — the A1 spec's "parent gently in the loop without surveillance").
- A1's soft timing prompts ("some families like to check this with a doctor") remain **child-side**; X1 carries the matching *generic* education so that when the child/family raises it, the parent is already calm and informed. Femio never routes a child's timing-watch flag to the parent directly.

**With A2 (newly menstruating teen, 12–15):**
- A2's trusted-adult layer is **opt-in** (stricter than A1) — X1 must function fully with **zero** shared cards: pure parent-education mode. The empty inbox states this is normal and healthy.
- A2's "know your normal" summary (A2 §G) is the flagship shareable card — designed to be shown to a parent/clinician *by her choice*.
- A2 red-flag prompts stay teen-side ("mention it to a trusted adult or clinician"); X1 equips the adult to receive that conversation well. The two halves meet **in the family's kitchen, not in a data pipe** — that is the design.

**With her own persona (two hats):**
- `UserState` gains `modes[]`: X1 stacks on her `persona_id` (B*/F*) without touching it. Home shows her own hero (her persona wins the hero per §8 blending — X1 is a pinned secondary context tab, never the hero of a health persona's home).
- Strict context isolation: her B/F surfaces never mention the daughter; X1 surfaces never mention her own health data. Separate notification channels. If the daughter ever uses the mother's device, per-profile isolation (A1/A2 shared-device rules) applies in both directions.
- If she is *only* an X1 user, home = X1 education + inbox; her own wizard remains one tap away ("Femio is for you too") — a natural B/F acquisition path, never forced.

**With the resolver:** X1 sets no track and no flags on the teen's state. It is invisible to the teen's resolver except as `trusted_adult_link` presence + scope — which per the Master Model only ever affects *sharing*, never content, tone, or access on the teen's side.

---

## J. Lifecycle (the link is designed to dissolve gracefully)

X1 is the only Femio surface **designed for planned obsolescence** — success = the daughter no longer needs a mediated layer.

| Event | Handling |
|---|---|
| **Link created** (consent ceremony) | Both sides see identical scope language; teen assents age-appropriately; all card types start OFF. |
| **Daughter's menarche (A1 → A2)** | No automatic parent notification. If the child had the milestone card ON, the parent receives it (with the "respond well" companion + first-period parent plan). X1 content re-skins from "preparing" to "supporting." |
| **Teen tightens/revokes scope** | Instant; neutral parent-side state; no reasons, no alarms, no nagging (see §G rule 4). Universal "toggle off" event semantics inherited. |
| **Teen reaches age-of-consent (per jurisdiction, e.g., 13–16 GDPR-K / market-specific)** | Master-model universal event fires on the teen's side: consent re-confirmed, minor gating relaxes. **The trusted-adult link does not auto-survive:** the teen is asked, alone, in neutral framing, whether to keep, narrow, or end each link. Silence = link lapses to dormant (no new cards) after a grace period. `[decision: recommended default — confirm grace-period length with legal/UX]` |
| **Link dissolves** (age-out, teen revocation, or either side's account deletion) | Parent side: delivered cards purged per retention policy; a warm, pre-seeded goodbye state ("You did the job — she's got it from here"), pointing her to her own health journey (B/F). Teen side: link disappears; her data was always solely hers, so nothing to migrate. Consent *records* (not health data) are retained as legal artifacts only. |
| **Parent deletes her account** | Teen notified neutrally; scope object cleaned; teen's data unaffected. |
| **Safeguarding edge** | Femio is not a reporting tool and never surveils; standard abuse/safeguarding resource content remains reachable to both sides as education. Any market-specific mandatory-reporting posture: `[NEEDS SOURCE per launch jurisdiction — legal review]`. |
| **Multi-child / re-entry** | Each child link has its own lifecycle; a dissolved link can only be re-created through a fresh full ceremony (no resurrection shortcuts). |

---

## K. Compliance flags (minor privacy is the headline)

- **Scope:** wellness / education / tracking only. X1 never diagnoses the daughter, never triages from her data, never tells a parent "she may have X." All thresholds are generic education → "discuss with a clinician."
- **Minor privacy is paramount (COPPA / GDPR-K):**
  - **Verifiable parental consent** implemented as the linking ceremony (method per jurisdiction: `[NEEDS SOURCE — confirm accepted verification methods per launch market: card micro-charge, ID, signed form, etc.]`); consent text versioned and archived.
  - **Consent ≠ access.** Legally required guardian consent for the child's account **does not** grant the guardian visibility into the child's data. These are decoupled on purpose and stated plainly to the parent. (COPPA grants parents rights to review/delete a child's collected data on request — this is honored as a **rights workflow** (support-mediated, logged, disclosed to the teen age-appropriately), not as an in-app browsing surface. `[legal review: reconcile COPPA parental-review right with teen-transparency design per market]`.)
  - **Data minimization both directions:** parent side stores no duplicate child PII; teen side stores only the scope object + share log.
  - **Teen data is teen-owned at majority/consent-age** — no parental residue, no orphaned parent copies (the parental-control-app anti-pattern, §D).
- **Anti-surveillance guarantees (product-level, testable):** no reading/search history exposure; no activity/inactivity signals; no raw-log access; no notifications derived from the teen's data; no scope change without teen-side action; teen's transparency panel and parent's panel render from one scope object; revocation is silent and instant. **Any feature request that violates one of these is rejected at design time, not mitigated.**
- **No ads in X1 context** (touches a minor's ecosystem); no analytics SDKs on any surface carrying link/scope/card data; no brokering (Flo/Meta FTC anti-pattern inherited from A2 §K).
- **Not a parental-control product:** marketing and store listings must never use "monitor," "track your teen," "keep an eye on"; category positioning is parent *education* + consent-based sharing. (Also keeps Femio clear of parental-control app-store policy regimes.)
- **Not contraception / not fertility:** no fertile-window or pregnancy framing anywhere near the daughter context; shared cycle cards show period/expected-window education only (A2 §K inherited).
- **Predictions uncertainty-honest on shared cards too:** any shared window renders as a range + "teen cycles vary — this is normal," so the parent never treats a date as a fact or a "late" signal.
- **Cultural sensitivity (Arabic-first/RTL):** de-shaming must target the taboo, never the family or faith; religious-practice content is educational information, not rulings; conversation scripts localized (not translated) for MENA registers. Crisis/clinician-directory localization: `[NEEDS SOURCE per locale — inherited from Master Model §11]`.
- **Referenced content:** every clinical/communication claim in §D/§F medically reviewed + cited; `[NEEDS SOURCE]` items resolved before publish.
- **`[NEEDS SOURCE]` register:** MagicGirl parent-visibility mechanics (§C); per-market verifiable-consent methods (§K); COPPA parental-review-right reconciliation (§K); age-of-consent numbers + lapse grace period per jurisdiction (§J); mandatory-reporting posture per market (§J); delivered-card purge enforceability (§H); per-market school/period-product info (§E.19).

---

## Sources

**Parent-teen menstrual/puberty communication (Tier-1/Tier-2)**
- [Nemours KidsHealth (Parents) — Talking to Your Child About Periods](https://kidshealth.org/en/parents/talk-about-menstruation.html)
- [Nemours KidsHealth (Parents) — Talking to Your Child About Puberty](https://kidshealth.org/en/parents/talk-about-puberty.html)
- [UNICEF Parenting — Talking about periods at home](https://www.unicef.org/parenting/health/talking-about-periods-at-home)
- [HealthyChildren.org (AAP) — Physical Development in Girls: What to Expect During Puberty](https://www.healthychildren.org/English/ages-stages/gradeschool/puberty/Pages/Physical-Development-Girls-What-to-Expect.aspx)
- [CHOC — A parent's ultimate guide to periods](https://health.choc.org/a-parents-ultimate-guide-to-periods/)
- [WebMD — Daughter's First Period: How to Prepare](https://www.webmd.com/parenting/features/daughters-first-period-how-to-prepare) `[secondary]`
- [Planned Parenthood — Talking with your kid about periods](https://www.plannedparenthood.org/blog/talking-with-your-kid-about-periods)

**Clinician-visit guidance & adolescent confidentiality**
- [ACOG Committee Opinion — The Initial Reproductive Health Visit (ages 13–15)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2020/10/the-initial-reproductive-health-visit)
- [ACOG Committee Opinion — Confidentiality in Adolescent Health Care](https://journals.lww.com/greenjournal/fulltext/10.1097/aog.0000000000003770~confidentiality-in-adolescent-health-care-acog-committee)
- [ACOG — Your First Gynecologic Visit (FAQ)](https://www.acog.org/womens-health/faqs/your-first-gynecologic-visit)
- [ACOG — Should My Teen See an Ob-Gyn? Here's What I Tell Parents](https://www.acog.org/womens-health/experts-and-stories/the-latest/should-my-teen-see-an-ob-gyn-heres-what-i-tell-parents)

**When parents should seek care (thresholds; parent-visible signals)**
- [NHS — Starting your periods](https://www.nhs.uk/conditions/periods/starting-periods/)
- [NHS — Heavy periods](https://www.nhs.uk/conditions/heavy-periods/)
- [ACOG — Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)
- [ACOG — Screening and Management of Bleeding Disorders in Adolescents With Heavy Menstrual Bleeding](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2019/09/screening-and-management-of-bleeding-disorders-in-adolescents-with-heavy-menstrual-bleeding)
- [AAP Pediatrics — Evaluation and Referral of Children With Signs of Early Puberty](https://publications.aap.org/pediatrics/article/137/1/e20153732/52918/Evaluation-and-Referral-of-Children-With-Signs-of)
- [MedlinePlus — Delayed puberty in girls](https://medlineplus.gov/ency/article/007694.htm)
- (Full puberty-timing and adolescent-cycle evidence base inherited from A1 §D and A2 §D sources.)

**Monitoring vs. trust (why the sharing model is not surveillance)**
- [arXiv — Surveillance Disguised as Protection: comparative analysis of parental-control apps](https://arxiv.org/pdf/2504.16087)
- [UCF (Ghosh et al.) — What Children Have to Say about Mobile Apps for Parental Control](https://www.cs.ucf.edu/~jjl/pubs/pn1838-ghoshA.pdf)
- [arXiv — From Parental Control to Joint Family Oversight](https://arxiv.org/html/2204.07749v2)
- [Scientific American — How GPS Tracking of Teens 24/7 Impacts Parent-Child Relationships](https://www.scientificamerican.com/article/how-gps-tracking-of-teens-24-7-impacts-parent-child-relationships/)
- [AAP Center of Excellence — Parental Controls & Digital Monitoring Q&A](https://www.aap.org/en/patient-care/media-and-children/center-of-excellence-on-social-media-and-youth-mental-health/qa-portal/qa-portal-library/qa-portal-library-questions/parental-controls--digital-monitoring/)
- [arXiv — Towards Resilience and Autonomy-based Approaches for Adolescents Online Safety](https://arxiv.org/pdf/2504.15533)

**MENA / Arabic mother-daughter context**
- [UNFPA Arab States — Women and girls share their first experiences with menstruation](https://arabstates.unfpa.org/en/news/women-and-girls-share-their-first-experiences-menstruation)
- [IJWH (Dove/PMC) — Assessment of the Readiness, Beliefs, and Practices Regarding Menstruation Among Women in Saudi Arabia](https://pmc.ncbi.nlm.nih.gov/articles/PMC11559417/)
- [PJPR — Knowledge/Practices Related to Menstruation Among Female Students: Role of Mother-Daughter Relationship](https://pjpr.scione.com/cms/fulltext.php?id=154)
- [PLOS One — Adolescent sexual and reproductive health literacy in Saudi Arabia: school type and maternal education](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0347429)
- (Plus A1 §Sources MENA set: Palestinian-camps preparedness study, Saudi menstrual-education studies, Motherbeing.)

**Competitor parent-modes**
- [Luna — Advice for parenting teens and tweens (parent hub)](https://weareluna.app/parents/)
- [Luna — Choosing a period tracker for your daughter](https://weareluna.app/parents/guides/periods-and-hormones/choosing-a-teen-period-tracker/)
- [Luna — Which is the safest period tracker app?](https://weareluna.app/parents/guides/periods-and-hormones/teen-period-tracking-app-safety-guide/)
- [UNICEF Office of Innovation — Oky: Trailblazing Girl-Centered Tech](https://www.unicef.org/innovation/stories/oky-trailblazing-girl-centered-tech)
- [UNICEF Digital Impact — Oky menstruation education and period tracker app](https://www.unicef.org/digitalimpact/oky-menstruation-education-and-period-tracker-app-girls-girls)
- [The Case for Her — Meet Oky](https://thecaseforher.medium.com/meet-oky-14207f86892)
- (Flo/Clue/Spot On/MagicGirl assessments inherited from A1/A2 §C sources, incl. FTC/Flo-Meta reporting.)

**Minor privacy / compliance**
- [FTC — When it comes to health data, comply with COPPA – no kidding](https://www.ftc.gov/business-guidance/blog/2022/03/when-it-comes-health-data-comply-coppa-no-kidding)
- [Pandectes — Children's Online Privacy Rules: COPPA, GDPR-K, and Age Verification](https://pandectes.io/blog/childrens-online-privacy-rules-around-coppa-gdpr-k-and-age-verification/)
- [BigID — Data Minimization for COPPA](https://bigid.com/blog/data-minimization-for-coppa-compliance/)
