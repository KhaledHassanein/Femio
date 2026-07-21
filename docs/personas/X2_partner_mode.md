# X2 — Partner Mode (Cross-Cutting MODE, Not a Life-Stage Persona)

> Femio mode spec. Scope guardrail: **wellness / education / tracking only.** Femio never diagnoses, treats, or prevents. Fertile-window features are conception-awareness only, **never contraception**.
> **Mode law (the X2 constitution):** partner access is **consent-gated, scoped by HER, instantly revocable, and never exposes more than she grants.** Revocation and scope reduction are **silent and safe** — the partner is never notified of what changed, because the partner may be abusive. Her account is always the source of authority; X2 is a *view she projects*, never a door into her record.
> Mode code: **X2** · Type: cross-cutting mode (composes with C/D/E-track states) · Inherits: `09_MASTER_ADAPTATION_MODEL.md` (seven invariants, state object, constant core, universal events, blending). Complements partner-side fields already specced from HER side in C1 §H, C9 §E/§H, D1 §E (P1-9). · Last research pass: 2026-07-21

---

## A. Who the partner is (mode snapshot)

X2 is not a persona with its own life-stage spine — it is the **scoped shared view** granted by a primary (female) account holder to one linked partner, active whenever her state is in the C (TTC), D (pregnancy), or E (postpartum/loss) tracks, and dormant-but-linkable elsewhere.

| Field | Value |
|---|---|
| **Name (composite)** | "Omar," 31 — the modal case: male partner of a C1/C9/D1 user. |
| **Who he may be** | Usually a male partner (husband/boyfriend). **C13/C14-aware:** may be a **female partner** (same-sex couple — content must not assume "his sperm," and male-fertility modules simply don't surface), or **absent entirely** (single mother by choice, donor conception, widowed, separated) — in which case X2 never activates and no her-side surface ever nags about it. May also, at her choice, be a non-romantic support person; the sharing model is identical. |
| **Relationship to the account** | **Secondary, invited, subordinate.** He has his own login/identity, his own private logs (his data is his), but sees of *her* only what she scoped. He is a guest in her record and a first-class user of his own. |
| **Engagement pattern** | Bursty and shallow by default (checks a "today" card, reads a weekly digest), deepening at moments of acuity: fertile window, SA results (C9), scan days, third trimester, birth, loss. Design for a 30-second session. |
| **Health literacy** | Typically lower than hers on reproductive topics; often has never been anyone's patient in this journey. Doesn't know what a luteal phase is and doesn't want to be quizzed about it. Wants plain answers, male/peer voice, no lecturing. |
| **Emotional state** | Wants to help, doesn't know how; feels like a spectator ("it's all happening to her, my job is unclear"); in C9, carries shame/masculinity threat; in TWW/infertility, carries his own unspoken grief; postpartum, is himself at risk (≈1 in 10 partners develop paternal postpartum depression). |
| **Goal (top JTBD)** | *"Tell me, today, how to be useful and kind — without making me the manager of her body, and without her having to narrate everything to me."* |
| **What he is NOT** | Not a co-owner of her data. Not an auditor of her logging. Not a coach who gets a dashboard of her body. Not the account's emergency contact by default. Not entitled to anything — every pixel he sees exists because she granted it. |
| **Locale** | Same 4 locales, RTL-first for AR. MENA framing: partner mode must never become a channel for family/male surveillance of her body — heightened default privacy in AR markets (inherits C9 §K.7). |
| **Success = ** | She reports feeling *supported, not surveilled*; he reports feeling *included, not useless*; and the couple's timing/appointments/support actually improve — measured on her side, because her experience is the success metric of X2. |

**Mode thesis.** Every competitor's partner feature fails in one of two directions: it either turns the partner into a **spectator of her raw data** (Flo/Glow "partner mirror" — leaking her body to him and inviting pressure/surveillance dynamics) or it exiles him to a **disconnected dad-app** (Daddy Up, Who's Your Daddy) with zero connection to her actual journey. X2's thesis: give the partner **derived, contextual guidance** ("good day to be supportive," "her scan is Thursday — here's what happens at one") computed from her data but **not disclosing it**, unless she deliberately raises his scope — plus his **own** education, logging, and mental-health support. The partner gets a *role*, not a *readout*.

---

## B. Needs & questions (voice-of-user, both sides)

Mined from r/TryingForABaby and r/predaddit partner threads, dad-app store reviews, r/maleinfertility (via C9), Tommy's/PSI partner resources, and the male-fertility HCI literature. Representative/composite phrasing.

**HER needs from partner mode (she is the customer of X2 — his experience is the product, her consent is the platform):**
1. *"I want him to just KNOW when the window is, so I don't have to initiate the conversation every month."* — offload the narrator burden.
2. *"I don't want him watching my chart like a stock ticker."* — data without surveillance; the #1 reported failure of chart-sharing.
3. *"When the test is negative, I need him to not say 'next month!' — I need him to know what NOT to say."* — partner education as emotional protection for her.
4. *"I want to share the pregnancy, not my cervical mucus."* — granular scoping; milestone-level vs signal-level sharing are different universes.
5. *"If we break up, I want him gone from my data with one tap — and I don't want him to get a notification about it."* — silent, instant revocation (abuse-safety; see §K).
6. *"He should have his own homework."* (C9) — his SA, his lifestyle checklist, his appointments — in *his* view, not as chores she assigns.
7. *"I don't want the app to assume there IS a partner."* — solo-by-default; X2 is invited, never presumed.

**HIS needs (the invited experience):**
1. *"When does it actually matter this cycle — and what am I supposed to do about it?"* — timing literacy without her raw signals: a traffic-light, not a chart.
2. *"How do I help without being annoying / making sex feel like a job?"* — anti-pressure coaching is the core content need; community threads are full of partners who became a pressure source while trying to help.
3. *"What is the two-week wait and why is she a different person during it?"* — TWW emotional literacy; what to say/not say after a negative.
4. *"What's MY side of fertility? Should I be doing anything?"* — male preconception factors (heat, smoking, alcohol, weight); in C9, his SA results in plain language, in *his own* private space (masculinity-safe, per r/maleinfertility: men want information more than conversation).
5. *"What happens at the appointment and should I come?"* — appointment reminders + what-to-expect + questions-to-ask, per visit.
6. *"Nobody asks how I'M doing."* — his own mental health: TWW/infertility strain, partner grief after loss ("everyone asked how she was; no one asked about him" — double-disenfranchised grief), and paternal PPD awareness (≈1 in 10; presents as irritability/withdrawal/overwork).
7. *"Give it to me in dad-voice, fast."* — dad-app reviews consistently praise brevity + humor + peer tone and punish patronizing or her-app-copy-pasted content.

**Anti-needs / trust-breakers (both sides — these define the anti-patterns):**
- **Gamifying her body:** streaks, scores, "fertility points," leaderboards, "you hit the window 3/5 days!" — banned. Her body is not his game.
- **Pressure dynamics:** any nudge to him that reads as "go initiate sex tonight" converts support into demand. Nudges must be *support-framed* ("a good day to take something off her plate"), never *performance-framed*.
- **Data leakage:** him seeing anything she didn't grant — mood logs, symptoms, weight, HPT results, her library reading — is a catastrophic trust breach and, in abusive relationships, a safety incident.
- **Partner-as-spectator:** a read-only mirror of her app with nothing of his own (the Flo failure mode) → he disengages in a week.
- **Partner-as-manager:** framing him as the supervisor of her folic acid, weight, or logging compliance. Never.
- **Assuming the partner exists, is male, or is the genetic father.** (C13/C14, donor conception, absent partner.)

---

## C. Competitor teardown (partner modes + dad apps)

Key insight: the market is split between **her-app appendages** (partner sees her data, has nothing of his own) and **standalone dad apps** (his own content, zero connection to her). **Nobody** ships derived-not-raw context + her-controlled granular scoping + his own logging/mental-health + silent-safe revocation.

| Product | What the partner sees | His own space (education/logging) | Scoping & consent | Gap for X2 |
|---|---|---|---|---|
| **Flo for Partners** | Her period/ovulation/fertile predictions, "how she may be feeling" notifications, tips/quizzes | Education-lite, quizzes; no logging of his own | Binary link, on/off; partner effectively mirrors her cycle | Broadcasts her cycle phases to him wholesale; no granularity; support tips exist but sit on top of raw-phase disclosure. |
| **Glow (partner mirror)** | Full mirror of her fertility cycle; can "add suggestions and daily recommendations" | Some his-fertility tips | Mirror model — near-total visibility | The cautionary tale: partner can *comment on her cycle*; maximal surveillance + pressure surface. |
| **Ovia (partner sharing)** | Pregnancy progress sharing; partner follows along | Thin | Coarse | Employer-channel privacy posture (D1 §C) compounds concern; partner is a viewer. |
| **Premom / Fertility Friend / Kindara** | Full chart shared with partner/practitioner | None | Share-the-chart, all or nothing | Chart-stalking-by-partner; raw BBT/OPK exposure; no derived layer. |
| **Daddy Up / Who's Your Daddy / ProDaddy (dad apps)** | Nothing of hers — week-by-week baby content keyed to a due date he types in | Strong dad-voice weekly content, checklists, contraction counter (WYD) | N/A — no link to her at all | Proves demand for dad-voice content, but totally disconnected: due date can drift from reality; no TTC phase; no consent model because there's no her. |
| **DuoSync-class couple apps** | Shared cycle calendar for couples | Moderate | Couple-account model | Symmetric-couple framing erases her ownership; no her-controlled asymmetric scoping. |

**Whitespace map (the X2 opening):** her-controlled **granular scope tiers** + **derived context instead of raw data** at the default tier + **his own first-class track** (male preconception, C9 SA/lifestyle, TWW/loss/PPD partner mental health) + **silent instant revocation** + C13/C14-aware framing + Arabic/RTL. No competitor has any two of these together; none has the abuse-safe revocation model at all.

---

## D. Clinical grounding (cited)

> Patient-education framing only; medically reviewed; Femio interprets and prescribes nothing — for him too.

**Why a partner mode is clinically warranted (not just a growth feature):**
- Male factor is implicated in roughly **one-third of infertility cases alone and up to half combined** — conception is a couple matter, and evaluation involves both partners. [CDC Infertility FAQ; NICHD men's reproductive health; AUA/ASRM via C9 §D]
- Male partners' involvement yields **direct and indirect health benefits for the woman and child** (shared health practices, family-planning participation, improved child outcomes). [NICHD; AAP *Fathers' Roles in the Care and Development of Their Children* — reaffirmed 2022, which urges clinicians to engage fathers early because failure to connect predicts poorer downstream involvement]
- Fertility-related stress is real for **both** partners; male partners in infertility report significant fertility pressure and distress, amplified by insecure attachment and partner dynamics. [BMC Psychiatry 2024; ASRM stress framing via C1 §B]

**Fertile-window literacy for the partner (what he needs to understand — no more):**
- The fertile window is ~6 days ending on ovulation day; intercourse every 1–2 days in the window (or 2–3×/week throughout — the lower-pressure framing Femio leads with for partners) maximizes chances; supportive presence matters more than precision timing. [ASRM Optimizing Natural Fertility; ACOG; via C1 §D]
- His modifiable factors: smoking, excess alcohol, obesity, heat exposure, sedentary lifestyle may impair semen quality; improvements are judged over the ~2–3-month spermatogenesis horizon. [NHS/UHB; AUA/ASRM; via C9 §D — spermatogenesis figure **[NEEDS SOURCE — confirm at publish]**]
- C9 composition: SA literacy (WHO 2021 reference limits as *benchmark not pass/fail*; repeat testing standard) surfaces in **his** view when C9 is active and she has enabled the couple scope. [AUA/ASRM 2020/2024; WHO 6th ed. **[NEEDS SOURCE — primary manual]**]

**Partner mental health (the under-served clinical core of X2):**
- **Paternal perinatal depression:** ~**8–10% of fathers/partners** develop depression during pregnancy or the first postpartum year (meta-analytic total ~8.4%; peaks up to ~25% at 3–6 months postpartum); **5–15%** develop an anxiety disorder. Presents atypically: irritability, anger, withdrawal, overworking, substance use — and is heavily underdiagnosed. Maternal PPD is the strongest single risk factor for paternal PPD. [PSI Help for Dads; MDPI 2024 systematic review; PMC meta-analyses] **[NEEDS SOURCE — pin one primary prevalence citation per locale at publish]**
- **Partner grief after loss:** fathers/partners experience genuine, often *disenfranchised* grief after miscarriage/stillbirth — minimized both because pregnancy loss is minimized and because men are expected to be stoic support structures; men seek support less often. [BMC Pregnancy & Childbirth 2019 systematic review of men's grief; Tommy's partner-loss resources; Sands; PSI Loss & Grief]
- Crisis routing: any high partner mood-screen → localized crisis resources + PSI helpline-type signposting, same universal handler as her side. [PSI]

**Abuse-safety grounding (why revocation must be silent — see §K):**
- **Reproductive coercion** is a recognized form of intimate partner violence: partners sabotage contraception, pressure pregnancy, and **monitor phones/apps/cycles** as control. CDC's stalking definition explicitly includes using apps/technology to monitor a partner's activities. ACOG recommends routine IPV screening in reproductive care precisely because these dynamics concentrate around pregnancy. **Design consequence: a partner-facing view of a woman's cycle is a potential surveillance instrument and must be engineered as if the partner may be an abuser.** [ACOG Committee Opinion — Reproductive and Sexual Coercion (2013); ACOG — Intimate Partner Violence (2012); CDC NISVS]

---

## E. Feature set (prioritized)

**P0 — Must-have (defines the mode; nothing ships without all of these):**
1. **Scoped sharing engine (the platform).** Her-side scope picker with named tiers (§G); every partner-visible surface resolves through the scope filter server-side; default tier is the *most private* useful tier. Scope changes apply instantly; **no diffs, badges, or notifications to him on reduction/revocation, ever.**
2. **"Today for you two" card (his home).** One derived card/day: a support state — `supportive-presence day` / `ordinary day` / `gentle day (she may want space)` / `appointment day` — computed from her data but **not disclosing it** (no cycle day, no phase name, no DPO, no symptoms) at the default tier. This is the "good day to be supportive, not raw data" requirement made concrete.
3. **Anti-pressure guardrails (baked into copy engine).** No nudge to him may reference intercourse as an instruction, count/streak anything about her body, or imply her data. Template lint rule: partner notifications are *support-verbs only* ("cook," "ask," "listen," "come along"), never *performance-verbs*.
4. **His own education track** — full library in male/peer voice (§F), gated by nothing, keyed to the couple's composed state (TTC vs TWW vs C9 vs pregnancy week vs postpartum vs loss).
5. **His own logging (his data, his ownership):** mood check-in, his lifestyle checklist (sleep/alcohol/smoking/exercise/heat), and — when C9 composes — `semen_analysis[]` entry with the C9 glossary/benchmark viewer, private-by-default with *his* choice to share to her (consent is symmetric for HIS data; see §H).
6. **Appointment reminders (shared-calendar slice).** Appointments she marks "shared" appear in his view with reminders + a per-visit "what happens / questions to ask / should I come?" card. Only shared ones; her unshared appointments don't exist in his world.
7. **Silent, instant revocation + breakup-safe teardown** (§J) — one tap on her side; his app quietly degrades to generic education; cached her-data purged from his clients; no notification to him beyond eventual passive absence.

**P1 — Strong differentiators:**
8. **Partner mental-health module** — periodic gentle mood check-ins for him (screening framing), paternal-PPD awareness content from D3 (her third trimester) through E-track, PSI-style helpline signposting, crisis routing on high screens.
9. **TWW companion for him** — parallel (data-free) TWW guidance: what she may be feeling, what to say/not say on test day, his own coping.
10. **Loss/grief partner path** — when the universal loss handler fires on her account, his view *simultaneously and automatically* drops all celebratory content and swaps to partner-grief support (his own grief acknowledged, not just "support her") — no scope change needed, this is a safety default (§I).
11. **"Ask them to log" is BANNED; "moments" sharing instead** — she can push one-off moments (scan photo, milestone card, "we heard the heartbeat") to his view without raising his standing scope.
12. **C13-aware female-partner variant** — identical mechanics; content swaps male-fertility modules for co-mother/reciprocal-IVF-relevant support content; no gendered copy anywhere in the shared surfaces.

**P2 — Nice-to-have / later:**
13. Dad-voice weekly digest (opt-in email/notification): one short weekly card per pregnancy week — the Daddy-Up jobs-to-be-done, but synced to her real EDD scope.
14. Couple check-in prompts (both opt in): lightweight "one question for you both this week."
15. His wearable/lifestyle import for his own checklist.

**Explicitly OUT of scope for X2 (guardrails):**
- Partner write-access to ANY of her fields. He never logs, edits, comments on, or annotates her data. (Glow's "partner suggestions" is the named anti-feature.)
- Partner visibility into her raw signals (BBT/OPK/CM/intercourse/mood/symptoms/HPT/weight/library history) at any tier below the explicit maximal tier — and **intercourse logs, HPT results, mood logs, and reading history are never shareable at ANY tier** (see §G).
- Any streak/score/gamification of her body or "couple performance."
- Partner as default emergency contact, account-recovery contact, or consent proxy. Never.

---

## F. Content for the partner (his library)

Male/peer, non-lecturing voice (C9's proven register); grade 6–8; 4 locales, RTL-first AR; female-partner (C13) variants strip gendered framing; every card cited + "not medical advice."

- **"Your role, honestly"** (founding card) — what a supportive partner actually changes (timing help, load-sharing, emotional steadiness) and what he can't control; explicitly de-pressurizing.
- **Fertile-window 101 for partners** — the 6-day window concept, why the app shows *him* a support state rather than her chart, why 2–3×/week beats scheduling heroics; "her data is hers — here's what you actually need."
- **"Don't become the pressure"** — the core anti-pattern card: how well-meaning partners turn timing into demand; what pressure looks like from her side.
- **The two-week wait, for partners** — why she's tense, symptom-spotting psychology, what to say/not say after a negative ("next month!" is on the not-say list), his own disappointment is allowed.
- **Your side of fertility** — male preconception factors (heat, smoking, alcohol, weight, exercise), the 2–3-month horizon; agency-framed. (Suppressed in C13 composition.)
- **C9 pack (composes in):** SA-101 his-view, "You're still you" (masculinity/identity), "What you can do" lifestyle checklist — inherited from C9 §F male-facing variants.
- **Pregnancy, week by week, for partners** — what's happening (scoped to what she shares — week-level if granted, trimester-level otherwise), what she may be feeling, his job this week; appointment explainers (anatomy scan, glucose screen) + "should I come?".
- **Birth prep for partners** — labour signs, his role in the plan, hospital-bag co-checklist.
- **After the baby: your first 12 weeks** — practical load-sharing, sleep strategy, feeding support (E2-aware), relationship after birth.
- **"Partners get it too" (paternal PPD)** — 1-in-10 framing; irritability/withdrawal/overwork presentation; her PPD as his risk factor; screening-framed self-check; helpline signposting. Surfaced proactively from late D-track through E-track.
- **When loss happens** — partner-grief pack: your grief is real (disenfranchised-grief framing), supporting each other without scorekeeping, when/where to get help (Sands/PSI-type resources per locale). Auto-foregrounded by the loss handler.
- **Reachable-but-hidden:** the education layer of the full library remains searchable from his view (invariant 1 applies to him for *knowledge*) — but knowledge-access never means data-access; her record is not "library."

---

## G. Tools & the sharing model (scoping — the heart of X2)

**Architecture principle: derive, don't disclose.** The partner client never receives her raw fields. A server-side **scope resolver** consumes her state + granted tier and emits only *derived artifacts* (support state, shared-appointment list, granted milestone cards). There is no partner-side query path to her tables; scope is enforced at the API layer, not the UI layer.

**Scope tiers (she picks per-category, presets provided; default = Tier 1):**

| Tier | Name (her UI) | Partner sees | Explicitly does NOT see |
|---|---|---|---|
| 0 | **Education only** | His own track: education, his logs, his checklists. Nothing derived from her. | Any signal she exists in a cycle at all. |
| 1 | **Support cues** *(default)* | Daily derived support state (no phase names, no dates ahead, no cycle math he could reverse-engineer — states are deliberately fuzzed ±, and "gentle day" fires for many reasons so it can't be mapped to menstruation) + shared appointments. | Cycle day, phase, fertile window dates, DPO, any log. |
| 2 | **Windows & milestones** | Fertile-window band as a coarse range ("these few days matter this cycle"); TWW-active flag; pregnancy week number + week card; milestone moments she pushes. | All raw signals, symptoms, mood, test results. |
| 3 | **Couple data (opt-up, per-field)** | Individually toggled fields: e.g. cycle calendar, BBT/OPK charts, kick-count summaries. Each field is a separate switch with its own consent timestamp. | Anything untoggled. |
| — | **Never-shareable class** | — | `intercourse_log`, `hpt_results` (until she announces via a moment card), `mood[]`, `symptoms[]` detail, `content_history`, screener results, free-text notes. **No tier exposes these. Not configurable.** |

**Scope mechanics:**
- **Per-category, not global:** TTC-cues, pregnancy-progress, appointments, moments are scoped independently.
- **Raise = explicit consent ceremony** (she confirms what he'll now see, with preview-as-partner). **Lower/revoke = one tap, zero friction, zero confirmation beyond undo-toast, zero partner notification.** Asymmetric by design.
- **Preview-as-partner:** she can render his exact view anytime — the trust feature no competitor has.
- **State transitions re-confirm scope** (model invariant 6): positive test, loss, entering E-track each pause partner surfaces in the *new* data class until she re-grants (loss additionally auto-converts his view; §I/§J).
- **His tools:** today card, shared calendar + reminders, his checklist, his mood check-in, C9 SA tools (his data), TWW companion, weekly digest.
- **His alerts:** appointment reminders (shared only), support-cue (max 1/day, quiet hours, support-verbs only), his checklist nudges, his mood check-in cadence. All opt-in, all revocable by *either* side (she can silence categories of his alerts about the shared journey; he controls alerts about his own data).

---

## H. Data / consent fields (EMR additions)

**On HER account (extends the partner fields already specced in C1/C9):**
- `partner_link_id`, `partner_link_status` (invited / active / paused / revoked / dissolved), `partner_consent_ts` (hers, per grant).
- `partner_scope{}` — per-category tier map + per-field toggles (Tier 3), each with `granted_ts`, `last_modified_ts`; full immutable **scope-change audit log** (visible to her only).
- `partner_display_context` (what she's told him exists: e.g. TTC visible vs "just cycle wellness") — supports her choosing to link a partner *without* disclosing TTC intent.
- `shared_appointments[]` (subset flags on her `appointments[]`), `shared_moments[]` {card_ref, ts}.
- `safety_flags` { `quick_revoke_enabled` (default true), `panic_unlink_available` } — no field may ever record "suspected abuse"; we build the *capability*, we never build the *label*.

**On HIS account (his data — he is a data subject in his own right):**
- `partner_user_id`, own auth, `locale`, `rtl_pref`, `partner_gender_context` (drives C13 content variant; optional).
- `p_mood[]` (his check-ins), `p_screener_results[]` (screening-framed, non-diagnostic), `p_lifestyle_checklist_state`, `p_appointments[]` (his own, e.g. urology).
- **C9 composition:** `semen_analysis[]` {…as C9 §H…} — **canonical home moves to HIS account** when he has one; her C9 view reads it only via HIS share-back consent (`p_share_to_partner{}` map + `p_consent_ts`). If he has no account (she solo-enters, C9 solo mode), it lives on hers as third-party data per C9 §K.2. Migration on link: she's offered "hand his SA records to his account."
- `p_content_history[]` — **never visible to her** either; privacy is bidirectional.

**Consent ledger (shared infrastructure):** every grant, in both directions, is a timestamped consent record {who, what class, tier, ts, revoked_ts} — exportable to each party *for their own data only*. Revocations are recorded but **never messaged**.

*Data-minimization: X2 adds no new collection about her; it only adds projection controls. His data is minimal, purpose-bound, deletable.*

---

## I. Composition with C/D/E-track states (how the mode re-skins by her state)

X2 has no state of its own — it **derives** from her resolved `UserState` through the scope filter. Per-track composition:

| Her state | His experience (within granted scope) |
|---|---|
| **B-track / F-track (no TTC/pregnancy)** | X2 dormant-lite: Tier 0/1 only; general "understanding her cycle/menopause as a partner" education if she keeps the link warm. Never surfaces TTC framing she hasn't disclosed (`partner_display_context`). |
| **C1 (TTC general)** | Today-card support states; fertile-window coarse band at Tier 2; TWW companion; "don't become the pressure"; his preconception checklist. |
| **C9 (male factor)** | Full C9 male on-ramp composes in: his SA tracker + glossary, lifestyle checklist on spermatogenesis horizon, "You're still you," couple roadmap (the C9 "we" view is the one genuinely *shared* surface). Non-blaming law inherited. |
| **C2/C4/C5/C10 (infertility / RPL / treatment)** | Treatment-phase support content (what an IUI/IVF cycle involves for partners, injection-support, appointment cadence); heightened emotional-support framing; **his** distress acknowledged (fertility pressure is bilateral); C5/RPL composes the grief-aware tone into his view too. |
| **C13/C14 (female partner / solo)** | C13: identical mechanics, degendered copy, male-fertility modules suppressed, co-mother support content. C14 (no partner): X2 never activates; zero partner nags anywhere. |
| **D-track (pregnancy)** | Week-keyed partner content at granted granularity (week vs trimester); shared-appointment explainers (anatomy scan, glucose screen); D2/PAL composes anxiety-aware tone into his copy; condition sub-layers (D3–D7) surface *only* as "her clinician is monitoring something — here's how to support" **only if she shares that data class** — complication status is among the most sensitive fields. T3: birth-prep pack + paternal-PPD awareness begins. |
| **E1/E2/E3 (postpartum)** | Load-sharing content, feeding support, relationship-after-birth; his mood check-ins foreground (peak paternal-PPD window 3–6 mo); if her EPDS path activates (E3), his view gets "how to support + your own risk rises" — **without ever disclosing her screen results** (never-shareable class). |
| **E6 (loss)** | **Safety default, not a scope decision:** the universal loss handler propagates to his view *instantly and automatically* — all celebratory/week/milestone content suppressed, partner-grief pack foregrounded, tone → Gentle. Rationale: a stale "week 12 for dads!" card reaching him after a loss is the same competitor failure D1 §B documents, doubled. His grief path acknowledges *him* (disenfranchised grief), with resources, not only "support her." She controls any further detail; the *suppression* is unconditional. |

**Blending rule (model §8) applies:** his content emphasis follows her most-acute state; safety layers union (loss suppression + crisis routing always win).

---

## J. Lifecycle (link → scope changes → revocation → breakup → transitions)

| Event | Handling |
|---|---|
| **Invite** | She initiates (invite link/QR); he creates his own credentialed account; link activates only after BOTH: her scope confirmation + his acceptance of terms covering his own data. She sets `partner_display_context` and initial tiers in the same flow, with preview-as-partner. He can never initiate a link *to* her. |
| **Scope raise** | Explicit ceremony on her side (see §G); takes effect immediately; he sees new surfaces appear without fanfare (no "she unlocked X for you!" — grants are also unannounced to avoid pressure-to-grant dynamics). |
| **Scope lower / pause** | One tap; instant server-side; his view quietly loses surfaces. **No notification, no changelog, no "content unavailable" tombstones** — removed surfaces simply don't render, and the today-card degrades gracefully to generic support content so nothing looks conspicuously missing. `paused` keeps the link but projects Tier 0. |
| **Revocation (unlink by her)** | Instant: all derived artifacts stop; server invalidates his tokens for any her-derived resource; **remote purge of her-derived cache on his clients**; his account survives with HIS data (his SA, his moods, his content) intact + generic education. He is never notified; his app behaves as if she paused sharing indefinitely. Silent-and-safe is the contract (§K.1). |
| **Breakup / dissolution** | Same as revocation + she may bulk-delete `shared_moments` and his display context from her record. His copies of *his own* data persist (he's a data subject); artifacts derived from her data do not. Either party can dissolve; **his** dissolution does notify her (asymmetry is deliberate: notifying her is safe; notifying him may not be). |
| **Her state transitions** | Universal handlers propagate (per §I): positive test → his surfaces for the new data class pause pending her re-grant (celebration reaches him only via her moment-card — *she* announces, not the app); loss → unconditional suppression + grief pack; delivery → E-track composition; her mode-off/Z1 → X2 → dormant-lite. |
| **His disengagement** | Inactivity → his nudges stop (universal disengagement handler); her side is never guilt-tripped about it ("your partner hasn't opened the app" is banned analytics-to-UX leakage). |
| **New partner** | One active partner link at a time (v1). Re-linking after dissolution = fresh invite, fresh consent, zero inheritance of the previous partner's grants; prior partner's link is irreversibly dead (no re-activation path that could be socially engineered). |
| **Account deletion (his)** | His data deleted per DSAR; SA records she references lose the share-back (she's told her *view* of them ended — a rare her-side notification, safe by direction). |

---

## K. Compliance flags

1. **Abuse-safe revocation (highest-priority X2 guardrail).** Reproductive coercion and technology-facilitated partner surveillance are documented IPV patterns (ACOG 2013; CDC NISVS). Therefore: revocation/scope-reduction is **silent** (no partner notification, no diff, no tombstone), **instant** (server-side, cache-purged), **frictionless** (one tap, reachable in ≤2 taps from her home via quick-revoke), and **unrecoverable by him** (no appeal/request-access flow he could weaponize; no "ask her to re-share" button). Femio never builds a "report abuse" label into the data model — capability without labeling. Her scope audit log is visible to her only. Threat-model review of every partner surface for inference leaks (e.g., support-state patterns must not be reverse-mappable to menstruation/fertile days at Tier 1 — fuzzing is a safety control, not UX polish) is a ship-blocking checklist item. **[NEEDS SOURCE — adopt a formal IPV tech-safety framework, e.g. IBM/Clinic to End Tech Abuse or NNEDV Safety Net guidance, at design review.]**
2. **Her consent is the platform.** Nothing about her renders to him without a logged, granular, revocable grant (GDPR Art. 9 explicit consent; PDPL equivalents). Consent ceremonies on raise; state transitions re-confirm scope for new data classes (model invariant 6). **[NEEDS SOURCE — align with femio-compliance-privacy skill / DPA at implementation.]**
3. **He is a data subject too.** His SA, moods, screeners are HIS special-category data: his own consent, export, deletion; she sees his data only via his share-back grant (bidirectional privacy). Third-party-data handling when she solo-enters his SA inherits C9 §K.2.
4. **Never-shareable class is hard-coded.** Intercourse logs, HPT results, mood/symptom detail, screener results, reading history cannot be shared at any tier — removing the possibility removes the coercion vector ("show me the app" cannot expose what the app cannot show).
5. **No pressure, no gamification of her body.** Partner nudges are support-framed only; no streaks/scores/counters over her data; copy-lint enforced. This is an emotional-safety *and* a non-manipulation compliance stance.
6. **No diagnosis/treatment — for him too.** His SA context is benchmark-not-verdict (C9 §K.3); his mood check-ins are screening-framed with clinician routing; paternal-PPD content is awareness, not assessment. Crisis routing localized per locale. **[NEEDS SOURCE — per-locale partner/men's crisis directories, esp. AR/MENA.]**
7. **Loss propagation is a safety requirement,** not a feature toggle: celebratory suppression must reach his surfaces in the same transaction that fires on hers.
8. **MENA cultural safety.** Partner mode must not become family/male surveillance; AR-market defaults are the most private tier; his C9 diagnosis privacy inherits C9 §K.7 (never out him either — dignity is bidirectional).
9. **C13/C14 inclusivity.** No surface assumes a partner exists or is male; degendered shared-surface copy; female-partner variant content-complete at launch of X2, not deferred.
10. **Privacy-by-design inherited.** No partner-mode data to ad networks/analytics SDKs (FTC v. Flo 2021 / Premom 2023 lessons); no "partner engagement" growth-hacking on her body's data; app-store health-policy compliance for the partner app surface too. **[NEEDS SOURCE — FTC primary docs; store policy mapping at submission.]**
11. **Medical review + citations.** All partner-facing clinical content (fertile-window, male factors, paternal-PPD prevalence, grief) medically reviewed, cited, grade 6–8, 4 locales, RTL parity. **[NEEDS SOURCE VERIFICATION AT PUBLISH]** for all flagged figures.

---

## Sources

**Tier-1 (CDC / NIH / NHS / MedlinePlus):**
- [CDC — Infertility: Frequently Asked Questions](https://www.cdc.gov/reproductive-health/infertility-faq/index.html)
- [NICHD — About Men's Reproductive Health](https://www.nichd.nih.gov/health/topics/factsheets/menshealth) · [NICHD — Male infertility: how common / causes](https://www.nichd.nih.gov/health/topics/menshealth/conditioninfo/infertility)
- [CDC — NISVS (stalking/technology-facilitated monitoring definitions)](https://www.cdc.gov/nisvs/faq/index.html)
- [MedlinePlus — Male infertility](https://medlineplus.gov/maleinfertility.html) (via C9)
- [NHS/UHB — Improving sperm quality](https://www.uhb.nhs.uk/media/3dljknhq/pi_pathology_improving-sperm-quality.pdf) (via C9)

**Tier-2 (ACOG / ASRM / AAP / PSI):**
- [ACOG — Reproductive and Sexual Coercion (Committee Opinion, 2013)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2013/02/reproductive-and-sexual-coercion)
- [ACOG — Intimate Partner Violence (Committee Opinion, 2012)](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2012/02/intimate-partner-violence)
- [ACOG — Finding Emotional Support After Pregnancy Loss](https://www.acog.org/womens-health/experts-and-stories/the-latest/finding-emotional-support-after-pregnancy-loss)
- [AAP — Fathers' Roles in the Care and Development of Their Children: The Role of Pediatricians (reaffirmed 2022)](https://publications.aap.org/pediatrics/article/138/1/e20161128/52467/Fathers-Roles-in-the-Care-and-Development-of-Their)
- [PSI — Help for Dads](https://postpartum.net/get-help/help-for-dads/) · [PSI — Loss & Grief in Pregnancy & Postpartum](https://postpartum.net/get-help/loss-grief-in-pregnancy-postpartum/)
- [ASRM — Optimizing Natural Fertility](https://www.asrm.org/practice-guidance/practice-committee-documents/optimizing-natural-fertility-a-committee-opinion-2021/) (via C1)
- [AUA/ASRM — Male Infertility Guideline (2020, amended 2024)](https://www.auanet.org/documents/Guidelines/PDF/2024%20Guidelines/Male%20Infertility%20Unabridged%20Final.pdf) (via C9)

**Partner mental health & grief:**
- [MDPI — Postpartum Depression in Fathers: A Systematic Review (2024)](https://www.mdpi.com/2077-0383/13/10/2949)
- [PMC — Prevalence of perinatal depression among fathers (meta-analyses)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7677771/) · [PMC — Paternal PPD in Saudi Arabia primary-care study](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11978359/)
- [BMC Pregnancy & Childbirth — Men's grief following pregnancy/neonatal loss: systematic review (2019)](https://bmcpregnancychildbirth.biomedcentral.com/articles/10.1186/s12884-019-2677-9)
- [Tommy's — Partner support after baby loss](https://www.tommys.org/baby-loss-support/dads-and-partners/supporting-your-partner-after-baby-loss) · [Tommy's — Miscarriage support for dads and partners](https://www.tommys.org/baby-loss-support/dads-and-partners/miscarriage-support)
- [Return to Zero: H.O.P.E. — Fathers Grieve, Too](https://rtzhope.org/blog/fathers-grieve-too) · [Houston Center — Fathers' grief after pregnancy loss (disenfranchised grief)](https://www.houstoncenterforvaluedliving.com/blog/fathers-grief-after-pregnancy-loss/)
- [BMC Psychiatry (2024) — Fertility pressure in male partners under infertility treatment](https://doaj.org/article/dd8d7d9f77f247b0a5af98d2d3676878)

**Competitor / market:**
- [Flo — Flo for Partners product tour](https://flo.health/product-tour/flo-for-partners) · [Flo for Partners — Google Play listing](https://play.google.com/store/apps/details?id=org.iggymedia.periodtracker&listing=males_track&hl=en-US)
- [Glow — official site (partner mirror)](https://glowing.com/) · [intech.media — Glow app review](https://intech.media/en/healthcare-tech/app-review-glow-2/)
- [Daddy Up — App Store](https://apps.apple.com/us/app/dad-pregnancy-guide-daddy-up/id1097347717) · [daddyup.app](https://daddyup.app/)
- [FamilyEducation — 12 Best Pregnancy Apps for Dads-to-Be](https://www.familyeducation.com/family-life/dad-life/pregnancy-apps-for-dad) · [ConceiveAbilities — Top 10 Pregnancy Apps for Dad](https://www.conceiveabilities.com/about/blog/top-10-pregnancy-apps-for-dad)
- [DuoSync — Flo-for-Partners alternatives](https://duosync.io/flo-for-partners-alternatives-7-better-apps-for-couples/)
- [Planned Parenthood — IPV & Reproductive Coercion fact sheet](https://www.plannedparenthood.org/files/3613/9611/7697/IPV_and_Reproductive_Coercion_Fact_Sheet_2012_FINAL.pdf)

*Community insight (r/TryingForABaby partner threads, r/predaddit, r/maleinfertility via C9, dad-app store reviews) synthesized as aggregate voice-of-user; representative phrasing, not individual quotes. FTC v. Flo (2021) / Premom (2023) inherited from C1 §K. All flagged figures **[NEEDS SOURCE VERIFICATION AT PUBLISH]**.*
