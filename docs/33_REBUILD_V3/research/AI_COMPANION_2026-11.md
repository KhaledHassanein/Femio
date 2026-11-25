# The AI companion: uses, boundary and build order (2026-11-24)

**For agents.** Khaled reads the summary in chat, not this file. Nothing here changes code; the
proposed PROGRESS lines (§7) are not yet in `PROGRESS.md`.

**Asked by:** the owner, 2026-11-24. His rule: use hybrid AI **for privacy**, so she gets the full
benefit of AI-assisted, personalised help across the app, Learn included. The AI is a
**companion**: it never touches the main features or sections, and it never receives the
sensitive data or the whole context. He calls it "a surgical operation".

**What that means here:**
- Every feature works fully with AI off.
- The AI reads only through a narrow, typed context: on the device for anything drawn from her
  record; through Cloud boost only a redacted general question she approved, or the four-band
  `PseudonymisedProfile`.
- It never writes to her record without her confirmation.
- Rules (red flags, the contraception refusal) run first and always win.
- Wellness and education only.

**Evidence base.**
- The code at `d46f0c2`: `lib/domain/assistant/`, `lib/data/assistant_channel.dart`,
  `lib/features/assistant/`, `lib/features/today/tips_card.dart`, the Kotlin bridge, and the
  tripwire at `scripts/analytics-lint.mjs` §3c.
- ADR-078, ADR-079 and ADR-080; PROGRESS R7 and R8; `research/PERSONA_FEATURES_2026-11.md`;
  `research/2026-11-persona-review/01_MARKET_RESEARCH.md` and `02_BUSINESS_DEVELOPMENT.md`;
  `research/REGISTRY_COVERAGE_2026-11.md`.
- The persona specs C1, C6, D1 and B6 (sections B and E).
- Web pages read on 2026-11-24, listed in §8.

**Medical facts:** this file adds none. Any content a use needs comes from reviewed guides, the
registry or the rules register (MR-xx); anything else is marked `[NEEDS SOURCE]`.

---

## 0 · What the code says today (and why it matters for the companion)

| Fact (checked in code) | Consequence |
|---|---|
| `AssistantBridge.runPrivate(String prompt)` (`lib/data/assistant_channel.dart`) accepts **any string**. Screens build their own prompts: `tips_card.dart:86`, `ask_screen.dart:113`, `say_it_sheet.dart:72`, `visit_summary_screen.dart:82`. | The cloud side is typed (`CloudPrompt`). The on-device side is not: any screen could pass the whole record to Nano. The boundary is surgical for the cloud only. §5 closes this with a `PrivatePrompt` type. |
| Ask femio sends to the cloud only when the phone has **no** Gemini Nano (`ask_screen.dart`: `canRunPrivate` first, then the hybrid call). `toCloudSafe` refuses any first-person question. | The ADR-078 §3 step ("Nano rewrites her personal question into a general one") can never run where the cloud is used. On a phone without Nano, a question like "my period is late, why?" never gets a cloud summary. She sees the passages word for word. Use U09 fills this gap with rules. |
| Gemini Nano through Firebase AI Logic: single-turn, about 4,000 tokens in, output under 256 tokens recommended, foreground only, a per-app quota (`BUSY`, battery quota), **validated for English and Korean only**, no audio input on the device. Source: the Firebase hybrid docs (§8 S1). | Every on-device use must ask the model for **ids, keys or cited picks**, never Arabic prose ("the model reads; femio speaks", ADR-079 §4). Generated prose is English-only and labelled. A multi-turn chat companion is not possible on the device. |
| `DayLog` has flow, terms, OPK and BBT only. **No free-text note.** `Appointment.prep` holds her questions as free text. | A journal (U37) needs new record state (schema v3). Visit capture (U27) can write to existing appointment fields. |
| The tripwire forbids `RECORD_AUDIO` (`analytics-lint.mjs:277`). | Voice logging with femio's own microphone (U20) needs an ADR. The keyboard's own dictation (U19) needs no permission. |
| The glossary (`docs/content/GLOSSARY_TERMS.md`, about 131 terms × 4 languages, plain definitions) exists but is not loaded (R3.9). There are 37 reviewed week guides × 4 languages, each with fixed sections. | Several "AI" wins need **no model**: glossary on tap, and the weekly digest built from the week guides. |
| Nano runs only on recent flagship phones (the ML Kit device list names Pixel 10/11, Galaxy S26 and specific Snapdragon, Dimensity and Exynos chips; §8 S2). How many phones in Egypt and Saudi Arabia have Nano: **not verified**. | Most women will see the **rules tier**. Each use must be worth having without a model; the model only improves order and wording choice. |

## 1 · The design in one paragraph

The companion is a **layer over the app, not a feature of it**. Each use has a typed context with a
fixed list of fields, built on the phone by a pure function. The model receives only that context
and may only **pick, order, extract or cite** from what it was offered. What she reads is femio's
reviewed text in her language, or a passage quoted word for word with its source. Anything that
would change her record comes back as a **draft** she confirms. If the model is missing, slow,
wrong or switched off, the same screen shows the rules result.

We also use AI at **authoring time** (tier **A** below): summaries, follow-up questions and plain
versions are drafted by agents, reviewed like any guide, and shipped as content. This gives Arabic
the same depth as English without trusting Nano with Arabic prose at runtime.

Tiers used below:
- **R:** rules only; no model.
- **D:** on the device (`ONLY_ON_DEVICE`), falling back to R.
- **CQ:** Cloud boost with an approved general question (`CloudSafeText`).
- **CB:** Cloud boost with the four bands.
- **A:** authoring time; no runtime model, reviewed content.
- **N:** a system feature with no model of ours (for example, the keyboard's dictation).

## 2 · Ranked top 15

Impact: H/M/L (how many personas, how sharp the pain). Effort: S (one session), M (2–3), L (more,
or needs an ADR). The uses (U-numbers) are in the full table in §3.

| Rank | Companion feature | Uses | Impact | Effort | Why this rank |
|---|---|---|---|---|---|
| 1 | **The boundary itself**: typed contexts, `PrivatePrompt`, one gateway, drafts with confirmation, kill switches, manifest test | §5 | H | M | Every other item depends on it. It closes the untyped `runPrivate(String)` gap. It makes the owner's "surgical" rule testable. |
| 2 | **Visit companion**: her worry in her words becomes catalogue questions plus her own sentence; the pack printed in two languages (hers and the doctor's) | U25, U26 | H | S–M | The visit pack exists and every wedge persona asks for it (B6, C6, D1). Mostly rules. Low risk. |
| 3 | **Transparency**: "Why am I seeing this?", "What the AI can see" and a local AI ledger of every model call | U12, U34 | H | S–M | Proof of privacy is the wedge: Ayla makes the same "on-device, offline" claim (§8 C4), and the Arabic apps found disclose tracking. It is also the owner's surgical rule made visible. |
| 4 | **Patterns in plain words**, plus "ask my patterns" | U22, U23 | H | M | It turns R8.5's counts into sentences she can read. Clue sells this (Analysis tab); B6 and C1 ask for it. It needs R8.5 first. |
| 5 | **Weekly digest**, built on the phone (the pregnancy week card plus her week; a cycle week summary) | U14, U13 | H | M | The owner named it. D1 §E P0-1. It reuses the 37 week guides word for word. It needs R8.6. |
| 6 | **Learn helpers**: glossary on tap, plus a reviewed "In short" summary per guide | U01, U02 | H | M | No runtime model, all four languages, offline. It reaches every reader, including those without Nano. |
| 7 | **Say it, upgraded**: several days in one note, and voice through the keyboard's dictation | U18, U19 | H | S–M | Logging is the core habit. Dictation needs no permission; femio's own microphone (U20) waits for an ADR. |
| 8 | **Two-week-wait companion** and cycle-end kindness | U29, U30 | M–H | S–M | C1 and C6 describe the two-week wait as the hardest part. It reuses R8.12; the lines need sources. |
| 9 | **Question generaliser** for Cloud boost on phones without Nano | U09 | M–H | M | It repairs the dead ADR-078 §3 path. Her words never leave the phone; she approves a reviewed general question. |
| 10 | **Myth check**: "What trusted sources say about this" | U07 | M | S | A thin layer on Ask femio. D1, C6 and B6 all ask "what is real evidence?" |
| 11 | **After-visit capture**: next date, results-due date and follow-up questions from her note | U27 | M | M | D1: "I keep losing track". Never stores a result. Draft and confirm. |
| 12 | **Your next read**: a reading path ordered for her stage and logs | U06 | M | S–M | Personalise, never restrict (rule 2). It uses the same trigger engine as the tips. |
| 13 | **Calendar explainers**: "Explain this day" and "What changed after my log" | U16, U17 | M | S | Uncertainty-honest predictions explained (rule 3; C1 and B6 trust-breakers). Rules only. |
| 14 | **Guide follow-ups**: reviewed "Questions people ask next" and "Ask about this guide" | U04, U05 | M | M | The owner's Learn example. Answers still come from the registry (ADR-078 §1, ADR-079). |
| 15 | **Reflective journal prompts** (private, never read by a model unless she asks) | U37 | M | M | B6: "The anxiety and the body-image stuff are the hardest part and no app addresses it". It needs a new record field. |

**Next after the 15:** U35 (a coach for neutral reminder wording), U31 (postpartum check-in, after
R8.19), U03 ("Explain simpler", English only), U20 (femio's own on-device microphone, ADR), U21
(custom-tag mapping, after R8.23), U36 (onboarding in her words), U38 (a partner card she shares
herself).

**Hackathon slice** (deadline 2026-11-30, if the owner wants a companion demo): rank 1, plus 2, 3
and 7. All four run on rules on any phone and show the model's part on a phone with Nano.

## 3 · Full table

Columns:
- **Benefit / pain (evidence):** a persona line, the market research or a verified competitor page.
- **Tier:** the first tier listed is the fallback chain's top; R is always the floor.
- **Data it may see:** the data-minimisation column.

Persona citations give the file in `docs/personas/` and its section.

### 3.1 Learn

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U01 | **Glossary on tap**: underlined terms open a plain definition | C1 §B q6: "What does 'egg-white cervical mucus' actually look like?" (the literacy gap). The glossary already exists in four languages (R3.9) | R | The tapped word. Nothing from her record | Definitions word for word from the reviewed glossary; no model prose | S–M (after R3.9) | L |
| U02 | **"In short"**: three reviewed lines at the top of each guide | D1 §B: frustration with "clickbait / anxiety-inducing content". Flo's short daily stories from week 4 (01 §2, Flo help page) | A → R | None | Each line must restate a sentence of the guide (checked at review); reading-level gate (R3.3); reviewed with the guide (ADR-077 flow) | M (440 guides; Haiku drafts, lead review) | L |
| U03 | **"Explain this simpler"** on one paragraph | The owner's example | D, **English only** (Nano validated for EN/KO). Arabic, French and Spanish get U01 and U02 | The paragraph text only (public) | Labelled "Simplified on your phone". The output is discarded and the original shown if it adds a number, a medicine or a word not supported by the paragraph (token-overlap check) | S–M | M (adds facts) |
| U04 | **"Questions people ask next"**: three reviewed follow-ups per guide | The owner's example. C6 §B q8: she wants "to walk in informed, not be prescribed by an app" | A → R | None | Each question maps to a registry topic; tapping it runs Ask femio (rules first) | M | L |
| U05 | **"Ask about this guide"**: Ask femio opened from a guide | Context saves typing. The registry is now 87% strong on a synthetic set (REGISTRY_COVERAGE) | D / CQ | Her question, plus the guide's **topic ids** (public) as a retrieval hint. "Find in this guide" jumps to the best paragraph (rules, `guide_search.dart`) | Answers come from registry passages, not the guide (owner, ADR-078 §1). Same rules as Ask: safety first, contraception refusal, cite or discard | S | L |
| U06 | **"Your next read"**: guides ordered for her | Persona views (R8.1); personalise, never restrict (rule 2) | R (triggers → guide slugs) + D (order) + CB (order over **every** guide for her stage, as `CloudPrompt.tips` does) | On the device: stage, symptom categories (30 days), pregnancy or postpartum week. Cloud: the four bands and the whole stage list | Every guide stays reachable; no condition inferred. A new cloud purpose means bumping `cloudConsentVersion` | S–M | L |
| U07 | **Myth check**: "What trusted sources say about this" | D1 §B: "What foods do I actually have to avoid, and what's overblown?" B6 §B q3: "evidence-based vs. wellness noise". C6 §B q7 | D / CQ | Her typed claim (on the device), or her approved, redacted claim (cloud), plus public passages | Never the words "true", "false" or "myth" as a verdict; shows what the source says, cited; "Not covered yet" when no passage matches. Safety and contraception rules first | S (reuses Ask) | M (sounds like a verdict) |
| U08 | **Read aloud** | Accessibility; reading in a second language | N (Android TextToSpeech) | The text on screen | Reads reviewed text only. Whether the TTS engine sends text off the phone: **not verified** | S | L |

### 3.2 Ask femio

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U09 | **Question generaliser** for Cloud boost | On a phone without Nano, a first-person question never reaches the cloud summary (§0). Persona questions are mostly first person (C1 §B q10 "I'm 8 DPO…") | R (the topic lexicon picks a reviewed general question per topic, four languages) → CQ after she approves | Her question stays on the phone. Only the template she picked and approved leaves, after `toCloudSafe` | She sees and can edit the exact text; consent purpose `questions` (ADR-080); contraception refusal first | M | L |
| U10 | **"Do I have X?"**: a fixed reply, then a next step | R7.14 is open. B6 §B q6: "Is this symptom PCOS or should I get it checked?" | R | Her question (on the device) | Fixed wording before any lookup; offers a visit question and the guide; never names a condition for her (rule 1) | S (wording needs the clinician) | L |
| U11 | **Follow-up chips** after an answer | Less typing | R (topic → related topics) | The answer's topic ids | Same as Ask | S | L |

### 3.3 Today

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U12 | **"Why am I seeing this?"** on every tip, digest line and reading suggestion | Trust. D1 §B: "privacy dread". The owner's surgical rule, made visible | R (trigger → a plain sentence: "You logged cramps on 3 days in the last 30") | The trigger that fired (on the device) | Shows only her own logged facts, never anything a model inferred | S | L |
| U13 | **Weekly cycle digest** | Something worth opening weekly without nagging. Clue and Maya forecast symptoms (01 §4); here it is the past only | R (template strings with counts) + D (order the highlights) | Last 7 days' counts, the next-period range, the next appointment. No free text | Past pattern only (rule 3); no "late" (MR-02); neutral notification text (ADR-079 §4) | M | L |
| U14 | **Weekly pregnancy digest** | The owner's example. D1 §E P0-1: a "This week" card. Flo's daily stories from week 4 (01 §2) | R (R8.6 week sections word for word, plus her week: movement sessions, weight entries, appointments, saved questions) + D (order) | Completed week, her week's counts, appointment dates. **Never sent to the cloud** | Week text verbatim from the reviewed guide; red-flag entry on the card (MR-29); never "on track" or "normal" (scope §4 output table); stops at once on a loss (MR-35) | M (after R8.6) | L |
| U15 | **Daily check-in**: chips plus optional words | Lower-friction logging; R8.19's mood check-in | R + D (extraction, as in Say it) | Today's chips and words | Safety rules on the words; crisis → Help now; a draft she confirms; no EPDS score (MR-36) | M | M |

### 3.4 Calendar

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U16 | **"Explain this day"** | C1 §B trust-breaker: "Being told a prediction is a fact". B6 §B: "Just show me my actual history and stop guessing" | R (MR-01/06/51 wording from the ARB files) | The marks on that day | Range plus a confidence word; the MR-06 sentence; never "late" | S | L |
| U17 | **"What changed after my log"** | Owner O8 (predictions after each log) | R (the difference between `upcomingPeriods` before and after) | The two prediction results | Ranges only, never one date | S | L |

### 3.5 Log

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U18 | **Say it, several days at once** ("cramps since Monday, spotting yesterday") | Fast logging; the most-used assistant feature | D + R (`log_phrases.dart` floor) | Her note (with a character limit), the allowed keys, and a 7-day date window | Keys must be in the vocabulary; intercourse is never parsed (OD-5); safety first; **each day is a draft she confirms** | M | M (wrong day) |
| U19 | **Voice through the keyboard's dictation**: a hint and a mic glyph pointing to it | Hands busy, one hand after birth, lower literacy | N (her keyboard app; femio asks for no microphone permission) | Nothing new for femio | Say on screen that the keyboard's own policy applies. Whether Gboard dictation stays on the phone: **not verified** | S | L |
| U20 | **femio's own on-device speech** | Same need, with no third-party keyboard | D (ML Kit GenAI Speech Recognition: Basic on API 31+; Advanced on flagship phones, `ar-SA` beta; alpha library; §8 S2) | Audio, transcribed on the phone, never stored; then U18 | Needs `RECORD_AUDIO`, which the tripwire forbids: an ADR plus an exception scoped to the Kotlin assistant | L | M |
| U21 | **Custom-tag helper**: suggests an existing term before she creates a tag | Clue Plus custom tags (01 §4, lead-verified). B6 §B: "track acne flares, hair growth, energy crashes… together" | D + R | Her new tag text and the vocabulary | MR-47 register check; tags never go to the cloud and never enter the four bands | S–M (after R8.23) | L |

### 3.6 Patterns

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U22 | **Patterns in plain words** ("Cramps: seen in 5 of your last 6 cycles, mostly on days 1–2") | B6 §E P2-11: "your low-energy logs cluster in your longer cycles". C1 §E P1-10. Clue Plus Analysis tab (01 §1) | R (template statements) + D (pick the top 3 statement ids) | A `PatternsSummary`: counts and ranges computed on the phone | Past pattern only; "seen together", never "because"; the minimum-cycles rule goes into the register first (R8.5); no verdict; **no cloud** | M (after R8.5) | M (reads as a cause) |
| U23 | **"Ask my patterns"** | She asks in her words instead of reading charts | D (returns a statement id) / R (keyword match) | Her question plus the statement list | The answer is one statement word for word, or "I can't see that in your log" | M | M |
| U24 | **Signs this cycle, narrated** | C6 §B q2: "Am I even ovulating this cycle?" C1 §B q3 and q5 | R | This cycle's BBT, OPK and mucus days | Never "you ovulated" (MR-16, MR-17, MR-18) | S (with R8.8) | M |

### 3.7 Visit pack and appointments

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U25 | **Visit questions from her own words** | B6 §B: "I forget half my symptoms in the 10-minute appointment". C6 §B q12: "one summary… to hand my OB/endocrinologist". D1 §B: "what should I ask?" | D (map her worry to catalogue ids) + R (the rule bank); her own sentence is kept word for word as an extra question | Her typed worry, `VisitSummary.factsInEnglish()` (counts and keys) and the catalogue ids | The model only picks ids; her words go into `Appointment.prep` only after she confirms; safety first | S–M | L |
| U26 | **Bilingual visit pack**: her language plus a second one she picks for the clinician | B6 §E P0-5, C6 §E P0-7. That clinicians in Egypt and Saudi Arabia often read English is a **hypothesis, not verified** | R (all strings already exist in four languages; counts are numbers) | The visit summary | Western digits (ADR-069); no interpretation; shared only through Android's share sheet (R8 §4) | S | L |
| U27 | **After-visit capture**: next date, results-due date and questions to follow up, from her note | D1 §B: "I keep losing track of appointments and results across texts and portals" | D | Her note after the visit | Writes only `datetime`, `resultsDue` and `prep`; **never a result or a diagnosis** (`appointments.dart` rule); a condition she mentions offers the self-reported "My health" switch (R8.11) and never sets it; draft and confirm | M | M |

### 3.8 Life-stage uses

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U29 | **Two-week-wait companion** (TTC) | C1 §B q10: "I'm 8 DPO and my boobs hurt — is this a symptom?" C1's emotional arc ("obsessive symptom-spotting"). C6 §B q13. C1 §E P0-6 | R (the R8.12 card; reviewed daily lines chosen by days since her logged signs) + D (pick line ids) | Days since her logged signs; the test-day rule's inputs | MR-20 banned lines; MR-21 test day; no counter on an assumed ovulation; never says a symptom means pregnant or not. Factual lines `[NEEDS SOURCE]` | S–M | M (tone) |
| U30 | **Cycle-end kindness** (a period starts while TTC) | C1 §B: "private grief 'no one else sees'" | R | Period start logged in TTC mode | MR-20; MR-13/14 framing; never "infertile" | S | M (owner wording) |
| U31 | **Postpartum check-in** | R8.19. Sahiba has a postpartum mood record (01 §3, lead-verified) | R + D | Mood chips and today's words; postpartum week | MR-50 Hear Her signs; crisis → Help now; no EPDS (MR-36) | M (after R8.19) | M |
| U32 | **Perimenopause monthly symptom story** | Balance's free Health Report sets the floor (01 §6). F1 persona | R | Monthly counts | No score and no stage (rejected in R8 §3.6) | S (with R8.20) | L |
| U33 | **Quiet mode after a loss**: every pregnancy use stops at once | D1 §B: apps that handle loss badly, with "stale reminders after a loss" | R | The "pregnancy ended" state (R8.14) | MR-35 | S (with R8.14) | L |

### 3.9 Settings, onboarding and cross-cutting

| ID | Use | Benefit / pain (evidence) | Tier | Data it may see | Safety rule | Effort | Risk |
|---|---|---|---|---|---|---|---|
| U34 | **"What the AI can see"** plus a **local AI ledger** | R8.21. Ayla makes the same offline-AI claim (§8 C4). Clue's AI processes tracked health data on AWS Bedrock (§8 C2). femio must show proof, not claim it | R | Call metadata (use, tier, where it ran, time); for cloud calls, the exact text sent, kept as her receipt | The ledger never leaves the phone; cleared by delete-everything; at most 50 entries | S–M | L |
| U35 | **Reminder wording coach** | D1 §B: "visible to my employer". ADR-079 §4 keeps notification text neutral | R (a health-word check on the lexicon) + D (suggest a neutral rewrite) | Her reminder text | Lock-screen text must pass the neutral check; she chooses | S (after custom reminders, R8.24) | L |
| U36 | **Onboarding in her words** | A faster start | D (extract goal, cycle length, last period, time trying) | Her free-text introduction | The age gate stays explicit (MR-48; never inferred); every answer confirmed on the normal step screens; Nano may not be downloaded at first run | M | M |
| U37 | **Reflective journal prompts** | B6 §B: "The anxiety and the body-image stuff are the hardest part and no app addresses it". C6 §B q13–14 | R (a reviewed prompt bank chosen by stage, phase and logged mood) | To pick a prompt: stage, phase and today's mood chips. **Her journal text is never read by a model** unless she taps "Make log entries from this" (U18) | New encrypted record field (schema v3) in her backup; on save, crisis words show Help now gently; never the cloud; prompts make no therapy claim. Any benefit of journaling is `[NEEDS SOURCE]` | M | M |
| U38 | **Partner card she shares herself** (no server) | Partner modes are common (01 §8). C1 §B q7 | R (neutral text through the share sheet) | Only what she ticks on the card | Range wording (MR-07); OD-8; R8.25 keeps partner mode deferred | S | M |

(U28 was merged into U26 during drafting; the number is not reused.)

## 4 · Competitor AI, verified 2026-11-24

| App | What its AI does | Where it runs | Source |
|---|---|---|---|
| Flo | "Flo Health Assistant": "an interactive dialogue tool that provides educational information". It uses what she logs; it shares "possible reasons for a late period"; it has a disclaimer | Not stated on the page (cloud implied) | §8 C1 |
| Clue | AI features that process "the health data I track" with her questions, for "personalised insights and answers". Opt-in, can be switched off | Cloud: AWS Bedrock, an Anthropic model per the policy | §8 C2 |
| Premom | Fertility AI (free, general answers) and Fertility AI Pro (Premium): reads LH strips and BBT and "highlights your ovulation day" | Not stated | §8 C3 |
| Ayla | "on-device AI assistant", "100% offline and private"; Arabic page | Claims the phone. Model and languages not stated | §8 C4 |
| Daleela (Cairo) | Free 24/7 AI Q&A; sells a "medical diagnosis" purchase | Cloud; discloses cross-app tracking | 01 §7 |
| Aziza (Egypt) | "Experimental AI-assisted symptom analysis" | Not stated; tracking disclosed | 01 §7 |
| Ovia, What to Expect, BabyCenter | No user-facing AI, per a competitor's blog | — | §8 C5 (third-party claim, **not verified**) |

**What femio can claim that none of these show:** (1) answers only from bundled, cited public
sources ("not covered" otherwise); (2) safety rules that run before the model; (3) the model picks
and femio speaks, in four reviewed languages; (4) nothing written to her record without her tap;
(5) a visible ledger of every AI call. Being on the device is no longer unique (Ayla).

## 5 · Boundary architecture ("surgical")

### 5.1 The flow every use follows

```
her action ─► gate (safety rules: crisis, red flags, MR-49/50, contraception, "do I have X")
                │ stop → Help now / fixed reply          (never reaches a model)
                ▼
             policy (master switch, build flag, use policy, consent purpose, circuit breaker)
                │ off → rules result
                ▼
             context = buildXContext(profile, today)     (pure, typed, fixed field list)
                ▼
             rules result (always computed first; this is the fallback)
                ▼
             PrivatePrompt.x(context) ─► gateway ─► bridge.runPrivate      (ONLY_ON_DEVICE)
             CloudPrompt.answer/tips  ─► gateway ─► bridge.runHybrid       (consent + approval)
                ▼
             parser: output must be ids/keys/statements it was offered, or a cited answer
                │ invalid → rules result (and count toward the circuit breaker)
                ▼
             femio speaks: ARB text / verbatim passage / reviewed content
                ▼
             change to her record? → RecordDraft ─► confirm sheet ─► controller.apply(draft, confirmation)
```

### 5.2 Files and modules

These extend the existing assistant code rather than start a second copy (pillar 2).

| Where | What | Notes |
|---|---|---|
| `lib/domain/assistant/uses.dart` (new) | `enum AssistantUse` and `const usePolicies`: for each use, the allowed tiers, consent purpose, write kind (none or draft), input limit, output kind and fallback | One table read by the gateway, the "What the AI can see" screen, the tests and this doc. Named constants only |
| `lib/domain/assistant/contexts/` (new, one file per context) | `SayItContext`, `VisitContext`, `PatternsContext`, `DigestContext`, `ReadingContext`, `ParagraphContext`, `QuestionContext`. Private constructors; built only by pure `build…Context(Profile, today)` functions; each has `manifest()` (field → plain-language key) | The same pattern as `PseudonymisedProfile`. A context never holds `Profile`, a date it does not need, or free text the use did not take |
| `lib/domain/assistant/private_prompt.dart` (new) | `PrivatePrompt` with a private constructor; one factory per context; the only caller of the prompt builders in `prompts.dart` | Moves prompt building out of `tips_card.dart`, `ask_screen.dart`, `say_it_sheet.dart` and `visit_summary_screen.dart` (pillar 2: the UI never calculates) |
| `lib/domain/assistant/outputs.dart` (new) | `IdPick`, `LogDraftSet`, `StatementPick`, `CitedAnswer` (moved from `prompts.dart`) and their parsers; every parser takes the offered set and rejects anything outside it | `parseQuestionIds` and `mergeDrafts` already work this way; generalise them |
| `lib/domain/assistant/drafts.dart` (new) | `sealed class RecordDraft` (`LogDraft`, `AppointmentDraft`, `TagDraft`); `Profile applyDraft(Profile, RecordDraft, Confirmation)` | `Confirmation` is created only by the confirm sheet (tripwire). No other path writes a model's output |
| `lib/domain/assistant/gate.dart` (new) | `gate(AssistantUse, String? text, Profile?, today)`: `safety.dart` first, then the contraception rule, then the R7.14 "do I have X" rule | Every free-text use goes through it, the journal included |
| `lib/data/assistant_gateway.dart` (new) | The **only** caller of `AssistantBridge.runPrivate` and `runHybrid`. It enforces the master switch, build flag, policy, consent (`CloudConsent.allows`) and status; a timeout (named constant); one retry on `BUSY`; and a per-use circuit breaker (3 invalid outputs in a row → rules for the session). It returns `AssistantResult<T>{value, ranOn: rules / phone / cloud}` and appends to the ledger | Screens call the gateway, never the bridge |
| `lib/data/assistant_channel.dart` (change) | `runPrivate(PrivatePrompt)` instead of `runPrivate(String)` | Mirrors `runHybrid(CloudPrompt)`. The Kotlin side is unchanged |
| `lib/data/assistant_ledger.dart` (new) and `AppSettings.assistant` (change) | Ledger entries (use, tier, ranOn, UTC time; the exact sent text for cloud calls); master switch `assistantOn` (default on: on-device use sends nothing, so it needs no consent, per the R8.3 reconciliation) | Kept in the sealed record; cleared by delete-everything; not carried by a restored backup (like `CloudConsent.afterRestore`) |
| `lib/features/assistant/confirm_sheet.dart`, `why_this_sheet.dart`, `ai_manifest_screen.dart`, `companion_entry.dart` (new) | The confirm sheet (the only place a `Confirmation` exists); "Why am I seeing this?"; "What the AI can see" plus the ledger; the R8.3 entry pill | All strings go in ARB × 4 locales; RTL-safe |
| `scripts/analytics-lint.mjs` §3c (extend) | (a) `runPrivate(`/`runHybrid(` only in `assistant_gateway.dart`; (b) `PrivatePrompt._` only in its file; (c) no file under `lib/features/` imports `assistant_channel.dart` except `assistant_scope.dart`; (d) `Confirmation(` only in `confirm_sheet.dart`; (e) files under `contexts/` import neither Flutter nor `dart:io` | The privacy tripwire already guards `CloudPrompt` this way |
| `android/…/assistant/FemioAssistant.kt` | Unchanged; optionally a per-call output-token cap passed from the policy | Firebase stays in Kotlin only (ADR-078 §5) |

### 5.3 Kill switches

1. **Hers:** Settings > Assistant > "Use AI" (off → every use shows its rules result). Cloud boost
   stays a separate, per-purpose consent (ADR-080).
2. **Build:** `const assistantEnabled = bool.fromEnvironment('FEMIO_ASSISTANT', defaultValue: true)`.
   With it off, a release ships rules only. A missing `assistant.env` already means "not set up".
3. **Per use:** the circuit breaker in the gateway. Each policy row also has `enabled`, so one use
   can be turned off in a release without touching the others.
4. **By state:** quiet mode after a loss (MR-35) turns off every pregnancy use. An under-18
   record never reaches the app (MR-48).
5. **No remote switch.** Remote Config would be network code of our own (rule 4, ADR-080).
   Rejected; an app update is the switch.

### 5.4 Offline fallbacks

The rules result is computed **before** the model call and is the screen's default state. The
model can only reorder or pick within it, or be ignored. Every use in §3 starts with R or A except
U03 (falls back to the original paragraph plus U01), U20 (falls back to typing or U19) and U36
(falls back to the normal onboarding steps). A test renders every assistant surface with
`OfflineAssistant` and checks it is not empty.

### 5.5 Tests that make "surgical" a fact

- `test/assistant_manifest_test.dart`: a golden list of every context's fields. Adding a field
  fails the test until the golden, the Settings manifest and this doc change together.
- `test/assistant_context_fuzz_test.dart`: random profiles (synthetic). No context holds an ISO
  date, a birth year or free text unless its policy allows it. No intimate term (OD-5) ever
  appears.
- `test/assistant_drafts_test.dart`: a model reply alone never changes `Profile`; only
  `applyDraft` with a `Confirmation` does.
- `test/assistant_offline_parity_test.dart`: every surface with `OfflineAssistant` against the
  fake bridge; same layout, rules content.
- Output parsers: ids not offered, keys outside the vocabulary, uncited answers and dates outside
  the window are all rejected (extends `prompts` tests).

### 5.6 Cost and quota

- Cloud boost runs only for U05, U07 and U09 (approved questions) and for U06 and the tips (the
  bands). Each call costs about $0.0005–0.002 (02 §5, the agent's arithmetic from Google's price
  page; the model routing changes on 2026-12-01).
- AICore has a per-app quota (§8 S1). Digests and patterns are therefore computed once when the
  app opens and cached for the week or until the next log, not on every frame.

## 6 · Gaps: what the companion should fill, and what it must not

### 6.1 Gaps in the current app the companion can fill

1. The on-device path is untyped (`runPrivate(String)`), and prompts are built in four screens (§0).
2. On phones without Nano, personal questions get no summary: the ADR-078 §3 rewrite never runs
   there (U09).
3. The visit pack lacks her own words, after-visit capture and a second language for the
   clinician (U25–U27).
4. R8.5 Patterns will show counts with no plain sentence; R8.6 will show the week with no link to
   her own week (U22, U14).
5. Learn has no glossary in the app, no short summary, and no way to ask about the guide she is
   reading (U01, U02, U04, U05).
6. She has no way to see what any AI saw, or why a tip appeared (U12, U34).
7. No voice input; the tripwire bans the microphone. The keyboard's dictation is the free route
   (U19).
8. The two-week wait and the end of a cycle have no support content (U29, U30).
9. Logging is one day at a time (U18).
10. Reminder text is fixed. Once custom reminders exist (R8.24), nothing keeps them neutral (U35).

### 6.2 What the companion must not try to fill (and the rule each would break)

| Must not | Rule |
|---|---|
| Name a condition, answer "do I have X", give a risk score or a symptom checker | Rule 1; R7.14 fixed reply |
| Confirm ovulation from BBT or OPK, read LH strips, interpret labs | MR-16, MR-17, MR-18 |
| Predict periods or ovulation with a model, or replace the domain rules | Rule 3; ADR-070 (the specification owns decisions) |
| Say a pregnancy, a symptom, a movement count or a weight is "normal", "fine" or "on track" | D1 §E out of scope; the scope §4 output table |
| Answer anything about avoiding pregnancy, "safe days" or returning ovulation after birth | Rule 1; fixed refusal; R8 §3.3 |
| Counsel a crisis, a loss or grief; score mood (EPDS) | MR-35, MR-36, MR-38: Help now and people, not a model |
| Give a medicine, dose or supplement plan; log medication | Rule 1; ADR-079 §4 |
| Coach weight loss or diets | B6 and C6 anti-needs (no weight-first messaging); `[NEEDS SOURCE]` |
| Act as a free chat friend with memory of her history | Nano is single-turn and has no fallback for multi-turn (§8 S1); "the whole context" is what the owner forbids; OD-8 |
| Write her record, or a notification, from model text | The owner's confirm rule; ADR-079 §4 neutral notifications |
| Send a journal, note, tag or log to the cloud, even redacted | Rule 4; ADR-079 §3 (only `CloudSafeText` or the four bands) |
| Serve under-18s, partners or parents as users | MR-48; X1–X2 out of scope |

## 7 · Rejected list (with reasons)

| Idea | Reason |
|---|---|
| Open-ended chat companion ("talk to femio") | Multi-turn is unsupported on the device and does not fall back (S1); it would need her whole context; free chat is deferred (OD-8); rule 1 risk |
| Runtime Arabic, French or Spanish prose from Nano | Validated for English and Korean only (S1). Use authoring-time content (tier A) and ARB text |
| Runtime machine translation of guides | Reviewed text only; library parity is already reached (R3.8) |
| Premom-style "AI highlights your ovulation day" | MR-16/17/18; rule 3 |
| Symptom forecasts ("you will feel low tomorrow") | Rule 3; R8.22 allows only the past pattern |
| Mood or wellbeing score, fertility score | Rejected in R8 §3.4 and §4 |
| AI-written notification text, even personalised | ADR-079 §4: notifications stay neutral |
| Cloud reading help (sending a guide paragraph) under the current consent | It reveals what she reads, a health interest; not one of the two ADR-080 purposes. It would need a new purpose and `cloudConsentVersion` 2. Defer |
| Photo features (strip reading, food photos, bump photos to a model) | The camera is forbidden by the tripwire; MR-16; MR-47 (no photos of people) |
| Remote kill switch (Remote Config) | Network code of our own (rule 4) |
| AI on the website (Chrome's built-in model for "explain simpler") | The static site has no AI code and its privacy notice lists none; browser support varies. Deferred, owner decision |
| A partner-facing AI or a shared server space | Rule 4; OD-8; R8.25 deferred |
| AI for teens or a first-period mode | MR-48 |

## 8 · Sources (read 2026-11-24)

**Platform**
- S1. Firebase AI Logic, hybrid on Android (last updated 2026-11-18):
  https://firebase.google.com/docs/ai-logic/hybrid/android/get-started. Covers the 4,000-token
  limit, English and Korean validation, foreground only, no multi-turn fallback, the per-app
  quota (`BUSY`, battery), no on-device audio input, and the advice to keep output under 256
  tokens.
- S2. ML Kit GenAI Speech Recognition (Android):
  https://developers.google.com/ml-kit/genai/speech-recognition/android. Basic mode on API 31+;
  Advanced mode on the listed flagship phones and chips; `ar-SA` in beta; library `1.0.0-alpha2`.
- S3. ML Kit GenAI overview (summarization, proofreading, rewriting, speech, text to speech):
  https://developers.google.com/ml-kit/genai. Search excerpt of the official page; the page
  itself was not opened.
- S4. `SpeechRecognizer.createOnDeviceSpeechRecognizer`, added in API 31:
  https://developer.android.com/reference/android/speech/SpeechRecognizer. Search excerpt of
  the official page.

**Competitors**
- C1. Flo Health Assistant help page:
  https://help.flo.health/hc/en-us/articles/360052676191-How-do-I-chat-with-Flo-Health-Assistant
  (fetched). The page does not say whether it is free or Premium. Flo's AI statement page
  (https://flo.health/privacy-portal/ai-statement) was fetched, but its content did not load:
  **not verified**.
- C2. Clue privacy policy §3.1.7, "To use AI based service features": https://helloclue.com/privacy
  (fetched). It covers the consent sentence, the AWS Bedrock processor and the Anthropic model,
  and that the feature can be switched off.
- C3. Premom Fertility AI: https://premom.com/premoms-fertility-ai/ (fetched; published
  2025-10-16, updated 2025-11-10).
- C4. Ayla (Arabic page): https://aylatracker.com/ar (fetched). Its claims are its own
  marketing, not audited.
- C5. myCocoon, "AI in pregnancy apps, ranked" (reviewed 23 June 2026):
  https://trymycocoon.com/blog/ai-pregnancy-apps-ranked/. Search excerpt only; it is a
  competitor's own claim; **not verified**.
- Daleela, Aziza, Sahiba, Balance, Clue Plus and Flo's pregnancy-mode stories:
  `research/2026-11-persona-review/01_MARKET_RESEARCH.md` (its 22 pages, read 2026-11-24, with
  URLs).

**Not verified:**
- the share of phones in Egypt and Saudi Arabia that have Gemini Nano;
- whether Gboard dictation or the system TTS sends anything off the phone;
- whether clinicians in Egypt and Saudi Arabia prefer an English visit pack;
- any retention effect of a weekly digest;
- any wellbeing benefit of journaling or of the two-week-wait lines (`[NEEDS SOURCE]` before
  any user-facing claim).

## 9 · Proposed PROGRESS lines: "R10 · AI companion" (not yet added; the lead adds them)

```
## R10 · AI companion (owner 2026-11-24: "a surgical operation") — `research/AI_COMPANION_2026-11.md`

The companion picks, orders, extracts and cites; femio speaks. Every use works with AI off, reads one
typed context, writes only through a confirmed draft, and runs the safety rules first (ADR-078/079/080).

- [ ] R10.1 · Boundary: `uses.dart` policy table, typed contexts with manifests, `PrivatePrompt` (runPrivate no longer takes a String), `outputs.dart` parsers, `drafts.dart` + confirm sheet, `gate.dart`, `assistant_gateway.dart` (switch, build flag, consent, timeout, BUSY retry, circuit breaker), ledger; prompts moved out of tips_card/ask/say-it/visit screens; tripwire §3c extended; manifest, fuzz, drafts and offline-parity tests (needs an ADR: "the companion boundary")
- [ ] R10.2 · (A) Visit companion: her worry → catalogue question ids + her own sentence (confirmed into `Appointment.prep`); visit pack in two languages chosen by her, shared via the system sheet (U25, U26; ADR-069)
- [ ] R10.3 · (A) Transparency: "Why am I seeing this?" on tips, digests and reading suggestions; Settings > "What the AI can see" generated from the manifest; local AI ledger (cloud text kept as her receipt; cleared by delete-everything; not restored from backup) (U12, U34; folds into R8.21)
- [ ] R10.4 · (B) Patterns in plain words: template statements "seen in N of M cycles", top 3 picked on the phone; "Ask my patterns" answers with one statement or "not in your log"; no cause words; after R8.5 and its register row (U22, U23)
- [ ] R10.5 · (B) Weekly digests built on the phone: pregnancy (R8.6 sections verbatim + her week's counts + saved questions + red-flag entry, stops on loss MR-35) and cycle (counts, next-period range MR-51); neutral notification (U13, U14)
- [ ] R10.6 · (A) Learn helpers: glossary on tap from the reviewed glossary (needs R3.9), "In short" three lines per guide drafted at authoring time and reviewed, ×4 languages, reading-level gate (U01, U02)
- [ ] R10.7 · (A) Say it, several days in one note (each day a draft) + keyboard-dictation hint; four locales; synthetic phrase tests incl. Egyptian and Gulf Arabic (U18, U19)
- [ ] R10.8 · (C) Two-week-wait companion lines and cycle-end kindness, reviewed and sourced, MR-20/21, no counter on assumed ovulation; with R8.12 (U29, U30) — lines `[NEEDS SOURCE]` until sourced
- [ ] R10.9 · (A) Question generaliser: topic → reviewed general question ×4 languages; she approves the exact text before Cloud boost; fixes the ADR-078 §3 path on phones without Nano (U09)
- [ ] R10.10 · (A) Myth check in Ask femio: "What trusted sources say", cited or "not covered", no verdict words (U07)
- [ ] R10.11 · (C) After-visit capture into appointment date, results-due date and follow-up questions; never a result or diagnosis; draft and confirm (U27)
- [ ] R10.12 · (B) "Your next read": trigger-ordered guides; on-device order; Cloud boost order over the whole stage list only after a consent-text version bump (U06)
- [ ] R10.13 · (A) Calendar explainers: "Explain this day" and "What changed after my log", rules only (U16, U17)
- [ ] R10.14 · (C) Guide follow-ups: three reviewed questions per guide → Ask femio; "Ask about this guide" uses the guide's topics as a retrieval hint and answers from the registry (U04, U05)
- [ ] R10.15 · (C) Reflective journal: reviewed prompt bank; new encrypted note field (schema v3, migration, backup); never read by a model unless she asks for log entries; Help now on crisis words (U37) — owner check on scope
- [ ] R10.16 · (C) Reminder wording coach for custom reminders (after R8.24), postpartum check-in (after R8.19), perimenopause monthly story (after R8.20), quiet mode on loss (with R8.14) (U35, U31, U32, U33)
- [DEFERRED] R10.17 · femio's own on-device speech (ML Kit GenAI; RECORD_AUDIO needs an ADR and a scoped tripwire exception), "Explain simpler" (English only), onboarding in her words, partner card, website AI (U20, U03, U36, U38)
```
