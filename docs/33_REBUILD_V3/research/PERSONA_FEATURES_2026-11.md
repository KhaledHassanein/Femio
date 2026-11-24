# Persona-driven feature review — 2026-11-24 (lead synthesis)

**For agents.** Khaled reads the HTML page published from this file, not the file itself:
https://claude.ai/artifact/6debjUMkBygKcNuQntDW8T (private).
**Asked by:** the owner on 2026-11-24 ("summon the team and the market researcher and business
development agents to check the personas and enhance the features accordingly"), with his own
requests listed in §1. **Accepted items** are R8.x lines in `docs/33_REBUILD_V3/PROGRESS.md`.
Nothing here changes code.

**Evidence base.**
- `research/2026-11-persona-review/01_MARKET_RESEARCH.md`: market researcher (Sonnet, competitor-analyst
  agent). 22 pages read, 14 not verified. Lead spot-checks: Clue Plus page (Analysis tab, Perimenopause
  Mode, Clue Connect, custom tags) and Sahiba's App Store listing (no account, local by default,
  weekly pregnancy, postpartum records, "should not be used as contraception") both match. One
  agent-flagged error fixed in its §9.
- `research/2026-11-persona-review/02_BUSINESS_DEVELOPMENT.md`: business development (Sonnet).
  About 20 claims verified, about 20 not verified or hypotheses. Lead spot-checks: Flo's Saudi
  App Store prices (SAR 9.99 to 249.99) match. The Luni price (SAR 179.99 a year) is **mis-cited**:
  it is credited to Flo's listing, which does not mention Luni, so it counts as not verified.
  Google's carrier-billing page served its US version, so Egypt's carriers (Vodafone, e&) are not
  re-verified by the lead.
- The code as of `e5695a9` (ADR-080), read by the lead. "Exists" claims below were checked in
  `apps/mobile/lib/`.
- Personas: `docs/personas/` (C6, C1, D1 and B6 §E read in full; others through the researcher);
  `docs/hackathon/persona_coverage/`. Stitch designs: `testing-results/2026-11-24-stitch-compare/`
  on branch `claude/firebase-hackathon-eligibility-833c52`.

**No new medical facts are introduced here.** Every content item reuses reviewed guides or
register rules (MR-xx), or is marked `[NEEDS SOURCE]`.

---

## 0 · What the code already does (corrects the brief)

| Belief | Code says | Consequence |
|---|---|---|
| "No week-by-week pregnancy content" | **37 published guides, weeks 4 to 40, in EN/AR/FR/ES** (`docs/content/articles/pregnancy-week-*.md`). Each has the same sections: *Your baby this week*, *Your body this week*, *What you may notice*, *What care usually happens around now*, *This week's tip*, *When to see a doctor* (verified: 37 of 37 in EN and AR). They are bundled in the app's Learn tab. | The weekly view is **assembly, not authoring**. Effort drops from L to S–M. No new medical content is needed. |
| "Week should turn over on the LMP weekday" | It already does. `pregnancyProgress` counts from the due date, and 280 days is 40 × 7, so the due date falls on the LMP weekday (`domain/pregnancy.dart:39`). | What remains: a fixture case, and checking that every surface (hero, tips, weekly card, calendar circle) calls the same function. |
| "Ovulation day must be inside the fertile window" | Already true in the rule: the window is 6 days ending on ovulation day (`domain/fertility.dart:45-46`, MR-07). The calendar draws estimates only from today forward (`domain/day_marks.dart`), so a window that is half over looks cut off. | Add an invariant to the golden fixture (`window ⊇ ovulation` for every case) and audit the calendar and the website calculator by screenshot. |
| "No LH logging" | The Log screen has OPK chips (`features/log/log_screen.dart:159`, `opkResults`). There are 5 discharge terms. A BBT chart sits on Today in TTC mode (`features/today/period_hero.dart:103`). | No logging gap. The gap is **seeing the signs together per cycle** (R8.8). |
| Menopause symptoms | Hot flashes, night sweats, brain fog, joint pain, insomnia and vaginal dryness exist. **Palpitations does not.** | One term to add (R8.20). |
| Postpartum | `Profile.birthDate` exists; the pregnancy hero switches to "weeks since birth"; tips have a postpartum stage. Onboarding has **no** postpartum entry, and there is no pregnancy-ended path (scope A-07, MR-35 still open). | A postpartum view and a loss path are new work, but on an existing field. |
| PCOS | The profile has **no conditions field** (scope A-05 still open). | This is the biggest record-state gap; it also unblocks 220 catalogue candidates (`persona_coverage`). |
| Predicted periods | The calendar marks only the **next** predicted period. | The owner's request is real new work (R8.10). |
| Placeholders | `sayItHint` and `askHint` are one string each, for every mode. | Real (R8.4). |

## 1 · The owner's requests (2026-11-24), each placed

| # | Request | Where | Note |
|---|---|---|---|
| O1 | Each persona gets its own views | R8.1 | View registry by stage, plus condition overlays. Every block stays reachable from "All tools" (rule 2). |
| O2 | Pregnancy: calendar with the current week circled | R8.6 | The calendar in pregnancy mode shows weeks; the current week row is ringed. |
| O3 | Pregnancy: detailed tips per week for mother and baby | R8.6 | From the 37 reviewed week guides, by section. |
| O4 | Week turns over on the LMP weekday | R8.7 | Already true in the domain; lock it with a fixture and one function everywhere. |
| O5 | No ovulation or period items in pregnancy mode | R8.7 | Hide fertile, OPK, BBT and period predictions. **Bleeding stays loggable**, renamed "bleeding or spotting", and it links to the warning-signs screen, because vaginal bleeding is on the pregnancy red-flag card (MR-29, R4.14). Hidden items remain under "All log items" (rule 2). |
| O6 | Placeholder text changes by mode | R8.4 | One hint per stage for "Say it" and "Ask femio", in four languages. |
| O7 | Ovulation day always inside the fertile window | R8.9 | Invariant plus screenshot audit (see §0). |
| O8 | Predicted next periods shown after she logs | R8.10 | Next 3 periods as widening ranges (MR-01). None when irregular or no confident window (MR-06). Recomputed on every save. |
| O9 | Home: dashboard blocks on top, then "Tips for you", privacy and emergency notices at the bottom | R8.2 | The **Help now button stays in every header** (MR-38: always reachable, never gated). The bottom notice is extra, not a move. |
| O10 | AI ("Ask femio", "Say it to log") more prominent and appealing; first use opens a full GDPR-grade consent, then AI turns on in Settings | R8.3 | See the reconciliation below. |

**O10 reconciliation (lead).** Under ADR-079 and ADR-080 there are two kinds of AI:
- **On-device AI** ("Say it", "Ask femio" with Gemini Nano, or the rules fallback) sends nothing,
  so it needs no consent.
- **Cloud boost** sends data, so it needs explicit consent, one box per purpose, with a receipt.

Recommended flow:
1. The first tap on either AI entry opens one sheet. It says plainly what runs on the phone, and
   it offers Cloud boost through the existing ADR-080 consent screen (`cloud_boost_screen.dart`),
   with every box unticked.
2. Her choice is mirrored in Settings > Assistant.

Making on-device AI wait behind a consent wall would add friction for no legal reason. Making Cloud
boost default-on would break ADR-080. **Owner check:** if he wants the full consent sheet shown even
for on-device use, that is allowed. It costs taps, not rules.

## 2 · Views by persona (the frame for R8.1)

| View | Personas served | Top blocks (in order) | Hidden by default, still reachable |
|---|---|---|---|
| **Cycle** | B1–B5, B7–B11, B13 (as a period tracker only), B14–B19 | Period range, next periods, quick log, Patterns teaser, tips | Fertile window (off unless she turns it on), TTC tools |
| **Cycle + PCOS** (overlay) | B6, B5 | Cycle-length spread, symptom cluster (acne, hair, mood, energy), 90-day prompt (MR-10), visit pack | Fertile window, TTC nudges (B6 §E P0-4) |
| **Trying to conceive** | C1–C5, C11, C12, C13, C14 | Window range or "no confident window", signs this cycle (BBT, OPK, mucus), test timing, seek-help clock (MR-13) | Pregnancy tools |
| **TTC + PCOS** (overlay) | C6, C7, C8 | As TTC, plus no clock (MR-14), evaluation-prep, PCOS guides | — |
| **Pregnancy** | D1–D17 (condition overlays later) | Week ring and weekly card, red-flag entry, quick log (movements, weight, symptoms), next appointment, tips | Period, fertile, OPK, BBT |
| **Postpartum** | E1–E4, E7 | Weeks since birth, recovery guide of the week, after-birth warning signs (MR-50), mood check-in, bleeding log | Fertile window |
| **Loss** (gentle) | E6, C5 | Her own words, a kind screen, reminders stopped, guides, Help now (MR-35) | Every pregnancy-week card |
| **Perimenopause / menopause** | F1–F6 | Irregular cycles still visible, symptom frequency, visit pack | Fertile window |
| **Not served (by rule)** | A1–A6 (under 18, MR-48), X1–X2 (partner or parent modes, no server), B12 (sexual wellness, MR-47), E5 (contraception) | — | Guides stay open to everyone on the website |

## 3 · Ranked features per persona group

Columns: **V** = value (H/M/L), **E** = effort (S/M/L), **Rules** = product rules or MR rows it
must pass, **Evidence** = source, **ID** = PROGRESS line (accepted) or a status.

### 3.0 Cross-cutting (every view)

| Rank | Feature | V | E | Rules | Evidence | ID |
|---|---|---|---|---|---|---|
| 1 | View registry per stage and overlay; "All tools" sheet (Stitch's 5th "Tools" tab) | H | M | 2, 5 | Owner O1; Stitch onboarding (6 stages) and Tools tab; teardown OD-13 | R8.1 |
| 2 | Home order: dashboard → Tips for you → privacy and emergency notices at the bottom; Help now stays in the header | H | S | MR-38 | Owner O9 | R8.2 |
| 3 | AI entry card on Today and a mic field on Log; first-use sheet; Cloud boost consent per ADR-080 | H | M | 4, ADR-079/080 | Owner O10; Stitch Today ("Say it to log", "Ask femio · Cited library answers") | R8.3 |
| 4 | Mode-aware placeholders for Say it and Ask | M | S | — | Owner O6 | R8.4 |
| 5 | **Patterns screen**: cycle-length history with range, symptoms by phase "seen in N of M cycles", BBT, OPK and mucus per cycle, weight and movements in pregnancy, symptom frequency in menopause. Counts only, no cause words, no verdict | H | M–L | 1, 3 | Stitch gap (screen 7 missing); Clue Plus Analysis tab (paywalled, lead-verified); Maya, Ovia, Tahara (01 §4) | R8.5 |
| 6 | "What can leave this phone" page in Settings: list of every network path (Cloud boost only), linking the privacy policy | H | S | 4 | Sahiba and Nana make the same local-only claim (01 §7), so femio needs visible proof | R8.21 |

### 3.1 Trying to conceive and PCOS (C1, C6, C2, C3, C11, C12; B6, B5)

| Rank | Feature | V | E | Rules | Evidence | ID |
|---|---|---|---|---|---|---|
| 1 | **"My health" switch**: PCOS, irregular cycles, thyroid, endometriosis; self-reported, never inferred. It changes the window rule and seek-help (MR-14), the tips triggers and the Patterns emphasis | H | M | 1, MR-14 | Scope A-05 (open); C6 §E P0-1, P0-6; B6 §E P0-1; 220 catalogue candidates need record state (`persona_coverage`) | R8.11 |
| 2 | **Signs this cycle**: BBT shift, OPK and mucus side by side per cycle. It never says "you ovulated" | H | M | MR-16, MR-17, MR-18 | C6 §E P0-2 (the C6 differentiator); C1 P0-5; Stitch "Evidence of ovulation so far"; Flo and Premom (01 §1) | R8.8 |
| 3 | Ovulation always inside the window: fixture invariant plus calendar and calculator audit | M | S | MR-07 | Owner O7 | R8.9 |
| 4 | Next 3 predicted periods as ranges after each log | H | S–M | 3, MR-01, MR-06 | Owner O8 | R8.10 |
| 5 | Two-week-wait card: days since her logged signs, test-day rule (MR-21), anxiety-aware tips. No day-past-ovulation counter on an assumed ovulation | M | S | 3, MR-20, MR-21 | C1 §E P0-6; C6 P0-4 | R8.12 |
| 6 | Lab entries (progesterone, PdG, HbA1c, AMH, TSH) in the lab's own units; never labelled; never "day 21" | M | M | MR-18 | C6 P1-12; B6 P2-12; scope v1.1 item 3. **Stitch's "day 21–24 progesterone" question breaks MR-18; do not copy it** | R8.13 |
| — | Partner follow-along | M | L | 4 (no server) | Natural Cycles, Premom, Flo, Clue Connect (01 §1) | DEFERRED: needs a no-server design (a file she sends); OD-8 |
| — | Wearable or Health Connect temperature import | L | L | 4 | Natural Cycles, Clue, Stardust (01 §1) | DEFERRED: not used much in the target markets |
| — | LH strip photo reading | M | L | MR-16 | Premom (01 §1) | DEFERRED; any automatic interpretation is rejected (§4) |

### 3.2 Pregnancy (D1, D2, D3, D11, D13, D15)

| Rank | Feature | V | E | Rules | Evidence | ID |
|---|---|---|---|---|---|---|
| 1 | **Pregnancy weekly view**: a calendar that shows weeks with the current one ringed; a "This week" card with tabs *Baby / Your body / What you may notice / Care around now / Tip*, each section taken word for word from that week's reviewed guide in her language; "Read the full week" link | H | S–M | 1, MR-24, MR-29 | Owner O2, O3; every pregnancy app read (01 §2: Flo, Clue Plus, Ovia, BabyCenter, WTE, Pregnancy+, Tahara); content exists (§0) | R8.6 |
| 2 | **Pregnancy mode cleanup**: one week function everywhere (fixture); no fertile, OPK, BBT or period items; "bleeding or spotting" links to the warning signs | H | S | 2, MR-29 | Owner O4, O5 | R8.7 |
| 3 | **Pregnancy ended**: "I had my baby" goes to the postpartum view; "My pregnancy has ended" gets her own words, a kind screen, reminders stopped and data kept | H | M | 5, MR-35 | Scope A-07 (open); no competitor offers a loss path (01 §3), so femio can lead | R8.14 |
| 4 | Weekly pregnancy reminder (neutral text "femio" / "Open the app") | M | S | 4 (neutral notifications, ADR-079 §4) | Scope A-11; retention benefit not verified (02 §4) | R8.15 |
| 5 | Planning checklists: hospital bag, birth-plan questions, and "questions for this visit" from the visit-question catalogue | M | M | 1 | BabyCenter, Pregnancy+ (01 §2); D1 P2-11; checklist items `[NEEDS SOURCE]` | R8.16 |
| 6 | Baby size by week: only sizes the reviewed week guide already states, with a drawn object (no photos of people) | M | M | 1, MR-47 (no photos) | WTE, Pregnancy+, Ovia, Stardust (01 §2); measurement source `[NEEDS SOURCE]` unless the guide states it | R8.17 |
| 7 | Ultrasound dating overrides other methods when her clinician gave it | M | M | MR-27 | Scope v1.1 item 5 | R8.18 |
| — | Blood-pressure log with the fixed reference text only | M | M | MR-32 | Scope v1.1 item 8; D5, D6 | DEFERRED (v1.1 order kept) |
| — | Bump photo diary (local) | L | M | 4 | Pregnancy+ (01 §2) | DEFERRED: backup size, photo privacy |
| — | Baby names; vaccination schedules by country | L | M | content | Altibbi Mama (2021 press release only) | DEFERRED; schedules would need ministry sources `[NEEDS SOURCE]` |

### 3.3 Postpartum and loss (E1, E2, E3, E6)

| Rank | Feature | V | E | Rules | Evidence | ID |
|---|---|---|---|---|---|---|
| 1 | **Postpartum view**: onboarding entry "I recently had a baby" (writes `birthDate`; rule 5); weeks since birth; the recovery guide for that week; after-birth warning signs (MR-50) one tap away; mood check-in; a bleeding log in the existing vocabulary | H | M | 5, MR-50 | Natural Cycles, Ovia, Stardust and Sahiba have a postpartum mode (01 §3; Sahiba lead-verified); Stitch onboarding lists Postpartum | R8.19 |
| 2 | Loss path (shared with R8.14) | H | M | MR-35 | 01 §3 | R8.14 |
| 3 | EPDS mood check: validated Arabic version, unmodified items, score shown without a label, routed to a clinician; item 10 opens Help now | H | M | MR-36 | Scope v1.1 item 1; D-04 | Existing v1.1 item; owner needs the licence and the validated Arabic version |
| — | Baby feeding and sleep log | M | M | — | WTE, BabyCenter (01 §3) | DEFERRED: baby-care tracking is outside the "her record" scope for now |
| ✗ | Detecting returning ovulation after birth | — | — | 3, rule 1 | Natural Cycles' Postpartum frames it for contraception (01 §3, §9) | REJECTED: contraception use (E5 conflict). Logging her first period after birth and restarting the ranges is fine, and is part of R8.19 |

### 3.4 Cycle tracking (B1, B2, B3, B4, B7; B6 through the overlay)

| Rank | Feature | V | E | Rules | Evidence | ID |
|---|---|---|---|---|---|---|
| 1 | Patterns (R8.5) | H | M–L | 1, 3 | 01 §4 | R8.5 |
| 2 | Next periods as ranges (R8.10) | H | S–M | 3 | Owner O8 | R8.10 |
| 3 | "What you usually notice in this phase" card, worded as her own past pattern ("seen in 4 of 6 cycles"), never a forecast of her health | M | M | 1, 3 | Clue and Maya symptom forecasts (01 §4); Stitch "Personal insight" | R8.22 |
| 4 | Custom tags (her own words, stored locally; Say it can map them) | M | S–M | MR-47 (register) | Clue Plus (lead-verified) | R8.23 |
| 5 | PCOS-not-TTC overlay (B6): no TTC nudges, symptom cluster in Patterns | H | via R8.11 | 2 | B6 §E P0-1..4 | R8.11 |
| ✗ | Daily "wellbeing battery" or single score | — | — | 3 (no verdicts) | Flo (01 §4) | REJECTED |

### 3.5 First periods and teens (A1, A2, A3)

Kept out of the app (MR-48: the tracker is 18+). The researcher found no verified competitor
example of teen privacy done well (01 §5). The Stitch onboarding shows a "First periods" choice;
**do not copy it.** Any opening to under-18s is an owner and legal decision (`03_LEGAL_PACK.md`).
Guides on the website stay open to everyone. **Status: DEFERRED, owner decision.**

### 3.6 Perimenopause and menopause (F1, F2, F3)

| Rank | Feature | V | E | Rules | Evidence | ID |
|---|---|---|---|---|---|---|
| 1 | Perimenopause as its own view: irregular cycles stay visible as ranges; symptom frequency by month in Patterns; visit pack at least equal to Balance's free Health Report; "palpitations" added to the vocabulary | M | M | 1, 3 | Clue Plus Perimenopause Mode (lead-verified); Natural Cycles perimenopause page; Balance (01 §6) | R8.20 |
| ✗ | Perimenopause score, stage algorithm or menopause timeline | — | — | 1 (no diagnosis or staging) | Flo, Natural Cycles (01 §9) | REJECTED |

## 4 · Rejected (and the rule each breaks)

| Idea | Seen in | Rule |
|---|---|---|
| Birth-control mode, "plan to avoid", fertile days "to avoid", detecting returning ovulation after birth | Natural Cycles, Hawwa (01 §9) | 1, 3: never a way to avoid pregnancy |
| Symptom checker or AI that names conditions; "medical diagnosis" purchase; PCOS AI that "interprets" strips | Flo Premium, Daleela, Premom (01 §9) | 1: no diagnosis |
| Single daily scores (fertility score, wellbeing battery, perimenopause score) | Ovia, Flo | 3: ranges, no verdicts |
| "Plan 12 cycles ahead", "late period" reminders | Clue Plus, Nana | 3, MR-02 |
| Ads, cross-app tracking, attribution SDKs, sponsor access to data | Most large apps and the Arabic apps (01 §8–9; 02 §7) | 4, ADR-080 |
| Community, forums, "secret chats" | Flo, BabyCenter, WTE, Balance | 5 (OD-8) |
| Intimacy diary, sex logging, sexual-health sessions | Maya, Ovia, Balance+ | MR-47 |
| Ramadan, fasting or prayer tools | Sahiba, Nana | Owner ruling 2026-11-24 |
| Accounts, cloud sync hosted by femio | Nabta, Daleela, Balance | 4 |
| Online doctor consultations | Daleela, Altibbi, Tahara | Out of scope: a services business |
| A teen first-period mode in the app | Flo (snippet), Stitch | MR-48, pending an owner and legal decision |
| Paywalling guides, red flags, Help now, the weekly pregnancy view or basic Patterns | BD bundle draft (02 §5) | 2: every article and tool stays reachable |
| Stitch copy taken as is (Help-now symptom list, "day 21–24 progesterone", "Share on WhatsApp" for the visit pack) | Stitch screens 8, 9 | MR-29/MR-39 (sourced lists only), MR-18; sharing must go through Android's share sheet, which she chooses, not a WhatsApp button that implies a destination |

## 5 · femio Plus (R7.12, the owner decides)

The business-development draft put the weekly pregnancy pack and Patterns into Plus. That **breaks
rule 2**: both are tools and content. The lead's recommendation is that **Plus sells convenience and
depth, never access**:

| In Plus (recommendation) | Why it passes the rules | Running cost | Evidence |
|---|---|---|---|
| PDF or print export of the visit pack and Patterns (made on the phone, shared through the system sheet) | 1, 4: she makes and sends the file herself | none | Flo, Natural Cycles and Tahara offer doctor PDFs (01 §4); willingness to pay not verified |
| Home-screen widget (neutral on the lock screen) | 4 | none | Sahiba pregnancy widgets (lead-verified); retention not verified |
| Themes and an alternative app icon (also a privacy feature: a discreet icon) | — | none | not verified |
| Extra reminder types (supplement time, appointment, weekly pregnancy recap) | 4 (neutral text) | none | not verified |
| Cloud boost beyond a free monthly allowance | 4 (consent per ADR-080) | about $0.0005–0.002 per call (02 §5, the agent's arithmetic from Google's pricing page; model routing changes on 2026-12-01, check which model is called) | 02 §5 |

**Price hypothesis** (02 §5, not derived from evidence): yearly SAR 49.99 / EGP 249.99, or lifetime
SAR 99 / EGP 399. The only lead-verified anchor is Flo's Saudi App Store ladder (SAR 9.99–249.99,
plan lengths not labelled). Calibrate with Play Console's regional price templates once Plus has
features. Egypt has Play carrier billing on Vodafone and e& (agent-read, not re-verified); Saudi
carrier billing today is not verified.

## 6 · Growth notes (business development, owner-side)

- Channels, judged from reach plus fit with the rules (02 §3); conversion is **not verified**:
  1. TikTok, organic, by Dr Khaled (ad reach: KSA 34.1 M, Egypt 41.3 M; DataReportal 2025).
  2. The website's guides sending readers to the app.
  3. Snapchat in KSA and Facebook/Instagram in Egypt.
  Test each with its own landing path counted by Vercel Web Analytics (no SDK).
- Clinic QR card: an OB-GYN hands out a link and nothing flows back (rule 4). No evidence either way.
- Market: Egypt is 88–91% Android (StatCounter). KSA is about 69% Android but the StatCounter
  views conflict, so the iOS plan matters more in KSA.
- Still unknown: Play top charts for KSA and Egypt, Flo's prices on Play in SAR and EGP, any
  retention benchmark for period or pregnancy apps, and the Play service fee rate.

## 7 · Build order (recommended)

1. **Wave A** (owner requests, mostly reuse; about one week of sessions): R8.2, R8.4, R8.7, R8.9,
   R8.10, R8.6, R8.3, R8.21.
2. **Wave B** (record state, the persona unlock): R8.1, R8.11, R8.14, R8.19, R8.8, R8.5.
3. **Wave C** (depth): R8.12, R8.13, R8.15–R8.18, R8.20, R8.22, R8.23. Plus items once the owner decides R7.12.

Every UI item is judged at 390×844, light and dark, in Arabic. Rule changes go through
`lib/domain/` with golden fixtures (ADR-070).
