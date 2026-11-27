# Study 08 — Strategy, market and research documents

**Area:** strategy, market and research docs. **Date:** 2026-10-27. **Repo:** `E:\Femio\.claude\worktrees\femio-repo-study-planning-88d7c9` (branch `claude/femio-repo-study-planning-88d7c9`). Nothing was changed except the two output files of this study.

**Labels used throughout.** **Checked** = I measured it or read it myself in the repo. **From the docs** = a project file says it; I did not verify it. **Hypothesis** = my reading, not a fact. **[NEEDS SOURCE]** = a claim with no citation I could follow. Two external pages were opened (see section 7); no other links were opened.

**What was read in full:** `docs/00`, `01`, `02`, `03`, `05`; `docs/30_REVAMP/01`, `02`, `03`, `00_README`, `PROGRESS` (first open line only), `delegated/2026-10-08-competitor-benchmark.md` (header); `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` and `00_INDEX.md`; `docs/runbooks/OWNER_ACTIONS.md`; the decision text of D1–D8 in `docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md` §0. **Skimmed by heading:** `docs/28_TEARDOWN/01–10, 12` and `docs/29_REBUILD/00–07`. **Read in part:** `docs/archive/2026-11/31_RESET/01_INVENTORY.md` (first 50 lines and summary), `docs/STATE.md` (first 40 lines), `docs/DECISIONS.md` (ADR-012, 028, 058, 060, 070 and the ADR index). **Grep only:** `docs/06`, `docs/compliance/PROCESSOR_REGISTER.md`, `docs/compliance/PRIVATE_LAUNCH_V1.md`, `docs/04`, `docs/personas/` (file names), `docs/30_REVAMP/04_ANDROID_APP_SPEC.md`.

---

## 1. Purpose in one paragraph

This area is the reasoning behind Femio: who it is for, which market it enters first, what competitors do, what the owner decided, and why. It exists so that a new session does not have to rebuild the strategy from chat history. The area has been rewritten several times in eight weeks. The July 2026 pack (docs 00–05) was web-first with Capacitor wrapping for mobile and a broad four-language, whole-life product. The October 2026 revamp (docs/30_REVAMP) narrowed it to one wedge, one market and one date. On the same day, 2026-10-07, the owner's decisions D7 and D8 (ADR-070) replaced the revamp's web-first route with a private Android app, no accounts and a closed web tracker. The strategy is now clear in its core choices. Its supporting documents still describe the earlier plans, so a reader can find two different products in the same folder.

---

## 2. Inventory

**Status legend** (applied to each document as a whole): `live` = in force; `dead` = superseded; `duplicate` = overlaps another document; `unknown` = partly stale, so the owner or a later study has to settle it; `app-only` = describes the closed web tracker. **Still binding?** says whether the document's main content still governs work: yes / partly / no.

| Path | Lines | One-line purpose | Status | Still binding? |
|---|---|---|---|---|
| `docs/archive/2026-11/00_EXECUTIVE_SUMMARY.md` | 17 | July index of the Phase-0 pack; "web-first, Capacitor for mobile" | dead | No (Capacitor replaced by Flutter, ADR-060) |
| `docs/archive/2026-11/01_V1_LESSONS_LEARNED.md` | 32 | Why the Flutter V1 was archived, and what to carry forward | live (as lessons) | Partly: "headless CMS, not code" is reversed by D3 |
| `docs/archive/2026-11/02_MARKET_USER_RESEARCH.md` | 64 | July market size, user segments, pain points, sources | unknown | Partly: its market-size numbers are superseded by docs/30_REVAMP/02 |
| `docs/archive/2026-11/03_COMPETITOR_ANALYSIS.md` | 196 | July competitor tables (A–G) plus the August craft teardown (H) | unknown | Partly: H is live evidence; A–G are July and unsourced per row |
| `docs/archive/2026-11/05_PRODUCT_STRATEGY_PLAN.md` | 44 | July positioning, monetisation, phases (community, AI tier, Shopify) | dead | No (community, AI tier and Shopify conflict with OD-8, OD-9, D3/D7) |
| `docs/archive/2026-11/30_REVAMP/00_README.md` | 26 | Index of the revamp; launch table | unknown | Partly: its Android row still says "Google Play via TWA" (D2), which D8 replaced |
| `docs/archive/2026-11/30_REVAMP/01_AUDIT_AND_CRITIQUE.md` | 179 | 2026-10-07 agency audit of code, site and docs: keep, change, remove | live | Yes |
| `docs/archive/2026-11/30_REVAMP/02_MARKET_RESEARCH_2026-10.md` | 654 | Current market research, competitor table, SWOT, ranked gaps, wedge, features, deferrals | live | Yes, with contradictions listed in section 8 |
| `docs/archive/2026-11/30_REVAMP/03_REVAMP_PLAN.md` | 276 | Strategy (wedge, market, platform), Dusk Bloom design, architecture, phases | unknown | Partly: §2.3 (web first, TWA) is stale after D8 |
| `docs/30_REVAMP/04_ANDROID_APP_SPEC.md` | 96 | Spec for the private Android app under D7/D8 | live | Yes (not studied in depth here; grep only for monetisation and accounts) |
| `docs/archive/2026-11/30_REVAMP/PROGRESS.md` | 70 | Work queue; first open line is the work | live | Not read (outside this study's scope) |
| `docs/archive/2026-11/30_REVAMP/delegated/2026-10-08-competitor-benchmark.md` | 326 | Sonnet desk pass on the Arabic wedge; lead review accepted it on 2026-10-08 | live | Yes (header read; body not read) |
| `docs/archive/2026-11/28_TEARDOWN/00_INDEX.md` | 81 | Reading guide to the Flo teardown; lists the four owner directions | live | Yes |
| `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` | 269 | Owner directions OD-1…16, corrections C-1…14, judgements, evidence index, method rules | live | Yes (binding record); its counts are stale (section 8) |
| `docs/archive/2026-11/28_TEARDOWN/01_METHOD_AND_EVIDENCE.md` | 85 | How the teardown was done; boundary of what may be copied | live | Yes (skimmed) |
| `docs/archive/2026-11/28_TEARDOWN/02_FLO.md` | 626 | Flo torn down: engine, onboarding graph, design, content, monetisation, privacy | live (evidence) | Yes as reference (skimmed by heading) |
| `docs/archive/2026-11/28_TEARDOWN/03_PREGNANCY_TRACKER.md` | 213 | Pregnancy Tracker (com.teamthree) torn down | live (evidence) | Yes as reference (skimmed) |
| `docs/archive/2026-11/28_TEARDOWN/04_GO_FLO.md` | 104 | GO Flo: ad stack, permissions, localisation claim corrected | live (evidence) | Yes as reference (skimmed) |
| `docs/archive/2026-11/28_TEARDOWN/05_FEMIO_CURRENT_STATE.md` | 217 | Femio measured in August | unknown | Partly: counts were later corrected (C-10) |
| `docs/archive/2026-11/28_TEARDOWN/06_COMPARISON_MATRICES.md` | 228 | Four-way comparison matrices | unknown | Partly: built on the August counts |
| `docs/archive/2026-11/28_TEARDOWN/07_GAP_REGISTER.md` | 250 | Ranked parity gaps TD-01…16; reference only (OD-1) | live | Yes as reference |
| `docs/archive/2026-11/28_TEARDOWN/08_DIFFERENTIATION.md` | 215 | "Beyond parity" layer D1–D9 from our own persona corpus | live | Yes (skimmed) |
| `docs/archive/2026-11/28_TEARDOWN/09_BUILD_PLAN.md` | 160 | Old sequenced build plan | dead | No (sequence replaced by 30_REVAMP/03 §5) |
| `docs/archive/2026-11/28_TEARDOWN/10_FLO_RUNNING.md` | 608 | Flo running on an emulator; live-vs-binary; owner directions on tone, calendar, paywall | live (evidence) | Yes (skimmed) |
| `docs/archive/2026-11/28_TEARDOWN/12_THE_OTHER_TWO_RUNNING.md` | 145 | Petal "Safe Period" label; pregnancy tracker install failure | live (evidence) | Yes as reference (skimmed) |
| `docs/archive/2026-11/29_REBUILD/00_INDEX.md` | 58 | Index of the rebuild plan | dead | No (its sequence is superseded; 30_REVAMP/00_README says so) |
| `docs/archive/2026-11/29_REBUILD/01_PRINCIPLES.md` | 117 | Six product rules and architecture rule restated | live | Yes (skimmed) |
| `docs/archive/2026-11/29_REBUILD/02_DATA_MODEL.md` | 344 | Data model spec (cycles, symptoms, predictions, patterns) | live | Yes per 30_REVAMP/03 (skimmed) |
| `docs/archive/2026-11/29_REBUILD/03_EXPERIENCE_ENGINE.md` | 349 | ExperienceConfig and surfaces spec | live | Yes per 30_REVAMP/03 (skimmed) |
| `docs/archive/2026-11/29_REBUILD/04_CONTENT.md` | 182 | Content and Learn surface spec (OD-12) | live | Yes per 30_REVAMP/03 (skimmed) |
| `docs/archive/2026-11/29_REBUILD/05_DESIGN_SYSTEM.md` | 239 | Design system spec (tokens, motion, charts) | live | Yes per 30_REVAMP/03 (skimmed); Dusk Bloom replaces its palette |
| `docs/archive/2026-11/29_REBUILD/06_SCREENS.md` | 222 | Screen specs (dashboard, calendar, log, learn, onboarding) | live | Yes per 30_REVAMP/03 (skimmed) |
| `docs/archive/2026-11/29_REBUILD/07_SEQUENCE.md` | 194 | Phase A–G sequence | dead | No (30_REVAMP/03 §5 replaces it) |
| `docs/archive/2026-11/29_REBUILD/PROGRESS.md` | 153 | Old progress log for the rebuild | unknown | Not read |
| `docs/archive/2026-11/31_RESET/01_INVENTORY.md` | 168 | 2026-10-27 inventory: why work drifts, cost to resume, critical path | live (dated today) | Yes, but its "lawyer on the critical path" line conflicts with the same-day OWNER_ACTIONS |
| `docs/archive/2026-11/31_RESET/02_SPEC_V1_DRAFT.md` | 109 | Draft v1 spec | unknown | Not read |
| `docs/STATE.md` | 233 | Resume file; "direction changed (D7 + D8, ADR-070)" | live (dated 2026-10-07) | Partly: Payload and Supabase lines are stale |
| `docs/DECISIONS.md` | 526 | ADR log | live | Yes; D3 (retire Payload) is not yet an ADR |
| `docs/runbooks/OWNER_ACTIONS.md` | 43 | Four things only Khaled can do; rewritten 2026-10-27 | live | Yes |
| `docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md` | 125 | Holds D1–D8 with alternatives not taken; old owner list | dead (except §0 decisions) | §0 yes; rest no |
| `docs/archive/plans-2026-08/23_STRATEGIC_REVIEW_2026-08-09.md` | 345 | August strategic review | dead | No (not read; grep found no SWOT in archive) |
| `docs/archive/2026-11/06_TECH_STACK_SKILLS_CHECKLIST.md` | 70 | Stack, Shopify advice, payments advice (grep) | dead in part | No for payments (Stripe primary) and Shopify |
| `docs/04_MEDICAL_DATA_SOURCES.md` | 49 | Medical data sources (not in this study's scope) | unknown | Not read |
| `docs/compliance/PRIVATE_LAUNCH_V1.md` | 139 | Why the v1 private design lowers the legal exposure (grep only) | live | Yes (grep only) |
| `docs/compliance/PROCESSOR_REGISTER.md` | 29 | Processor list; line 16 names "Stripe / Paddle" for billing (grep) | unknown | Conflicts with owner's payment rule |
| `CLAUDE.md` (repo, read in session context) | n/a | Project constitution; still names Payload, Supabase, accounts, Shopify and OWNER_ACTIONS §A | unknown | Partly: stale on D3, D7, D8 |

Folders not listed one by one: `docs/personas/` holds 73 persona files (groups in section 3.5) and `docs/archive/` holds superseded plans. Neither was studied beyond counts and file names.

**Graph file:** `docs/32_STUDY/graph/08-strategy-market.json`, 104 nodes and 175 edges, checked for unique ids, valid endpoints and allowed kinds. The template's node types do not fit decisions, so decisions and owner directions use type `doc`, competitors `service`, markets and regulatory facts `module`, and persona groups `doc`. Edge kinds are the three requested here (`supports`, `contradicts`, `supersedes`) plus `documents` from the template. Node ids carry a prefix (`dec-`, `dir-od-`, `comp-`, `mkt-`, `persona-group-`, `doc-`) so the kind is visible.

---

## 3. Key documents, decisions and facts

### 3.1 Decisions register

Decisions were taken by the owner in chat and written into files. Where a row says "not an ADR", the decision has a cost that a later session could reverse by accident, which is the bar for an ADR in CLAUDE.md. The bar is not met yet.

| ID | Decision | Date | Where recorded | Status now |
|---|---|---|---|---|
| D1 | Launch wedge: trying to conceive → pregnancy, with PCOS and irregular cycles as depth. Every stage stays reachable; the wedge sets emphasis, not access | 2026-10-07 | archived OWNER_ACTIONS §0 (D1); `30_REVAMP/03` §2.1 | live (owner accepted the default) |
| D2 | Route to stores: web PWA first, then Google Play via TWA, then Flutter after a launch signal | 2026-10-07 | archived §0 (D2); `03` §2.3 | **dead in part**: the TWA step was replaced by D8 in the same file |
| D3 | Retire Payload CMS; publish articles from Markdown in the repo | 2026-10-07 | archived §0 (D3); `03` §4 I-1 | live as a decision, **not an ADR**. ADR-012 still stands. `STATE.md` says Payload stays the editor until P2.8 |
| D4 | Markets: Saudi Arabia and Egypt, Arabic first; UAE next; EU web-only | 2026-10-07 | archived §0 (D4); `02` §10.1 | live |
| D5 | Soft launch target: week of 2026-11-30, 50–100 women | 2026-10-07 | archived §0 (D5) | live per git log (`adee59e` put it back to 30 Nov after `098e18e` moved it to 4 Jan 2027) and `31_RESET/01`. No live document states the date |
| D6 | Visual direction "Dusk Bloom" (plum, rose, peach, saffron on porcelain) | 2026-10-07 | archived §0 (D6); `03` §3 | live, to be checked at the Phase-1 checkpoint |
| D7 | Private launch: health records stay on the phone; no accounts in v1; tracker 18+ at launch | 2026-10-07 | archived §0 (D7); ADR-070; `compliance/PRIVATE_LAUNCH_V1.md` (grep) | live |
| D8 | Website promotes the Android app; web beta closes; development moves to a local-first Flutter Android app. Replaces D2's TWA step | 2026-10-07 | archived §0 (D8); ADR-070; `STATE.md` | live |
| ADR-060 | Mobile is Flutter; "the backend owns decisions"; web is also a real product | 2026-08-09 | `DECISIONS.md` line 178 | **partly superseded** by ADR-070 (the backend rule and "web is also a product") |
| ADR-070 | The product is a private Android app; records on the phone; web closes; "the specification owns decisions" | 2026-10-07 | `DECISIONS.md` line 460 | live |
| ADR-012 | Payload CMS as a separate app and content source of truth | 2026-07-23 | `DECISIONS.md` line 35 | dead once D3 is recorded |
| ADR-028 | Femio is a health product, not a medical one; reduce framing, keep the boundary | 2026-08-03 | `DECISIONS.md` line 82 | live; supports the conservative register |
| ADR-058 | "57 of 73 personas are resolvable now" | 2026-08-07 | `DECISIONS.md` line 172 | live, but contradicted by the 28 ledger (24 wired; section 8, C-25) |
| — | Launch date 4 Jan 2027 | commit `098e18e` | git log | dead (reversed by `adee59e`) |

### 3.2 Owner directions (OD-1…OD-16, from `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` §1)

| OD | Direction (2026-08-23 unless stated) | Still binding? |
|---|---|---|
| OD-1 | Gap register stays reference-only; no TD line enters the master TODO until approved | Yes |
| OD-2 | Depth on the experience surface; inventory the plumbing | Yes |
| OD-3 | The "beyond parity" layer comes from our own corpus (73 personas, adaptation model, EMR, RTL, privacy) | Yes |
| OD-4 | Capture the visual layer by extracting assets from the APKs; later run the apps on an emulator | Yes for study; the storage and licence question is open (section 10) |
| OD-5 | **Conservative register.** No "sex" logging categories; "intercourse" or "conception" day worded conservatively in every language; clinical symptoms stay under clinical names | **Yes. Strongest product rule in the set** |
| OD-6 | Onboarding: good-looking, detailed, joyful, simple, short, no overselling, ethical. Flo's is "extensive, soliciting and boring" | Yes |
| OD-7 | Monetisation is freemium: a useful free tier, then monetise. Specific model to be decided later | Yes (model still open) |
| OD-8 | **No messaging and no chat.** Not planned, not wanted | Yes; **conflicts with docs/05 (community v1 in Phase 2)** |
| OD-9 | AI assistant is post-V1 | Yes; **conflicts with docs/05 (AI tier at ~$9.99)** |
| OD-10 | Dashboard: fewer items than Flo, far more than Femio has; persona-relevant tools surfaced, all still reachable | Yes |
| OD-11 | The calendar is more prominent than in Flo | Yes |
| OD-12 | Learn section follows Flo's Insights structure with our citations, clinician names and four languages | Yes |
| OD-13 | The thesis: the experience should change as the persona changes, with resources to match | Yes (the thesis) |
| OD-14 | Gate: Femio must be at least as good as the three apps combined, then carry features none of them have | Yes (a gate, not an ambition) |
| OD-15 | Calendar detail: every period day, first and last day, whole fertile window, expected ovulation, all distinct | Yes |
| OD-16 | Build order: the mobile-first web app first, tested in the browser | **Superseded by D8 / ADR-070** (development moves to the Flutter Android app) |

### 3.3 Competitor set

Market figures are as the docs give them. "Better at" is what the docs say the competitor does better than Femio today. Evidence labels: **Checked** where the docs show a store listing or a scraped page; otherwise From the docs.

| Competitor | Market | What it does better (per the docs) | Evidence |
|---|---|---|---|
| Flo | Global; SA, EG | Scale (420M+ lifetime; 77M MAU claimed); symptom patterns; perimenopause and Premium suite; daily releases; 400 concurrent experiments. **Does not list Arabic** | App Store SA listing (Checked by benchmark 10-08); MAU and revenue from a secondary aggregator |
| Clue | Global | Arabic among 27 languages; science credibility; 1M paid subscribers; partner view (Clue Connect) | App Store SA and homepage (From the docs) |
| Stardust | Gen-Z | Aesthetic; brand. Privacy damaged: removed E2E claim; sends health data to RudderStack (Mozilla, Jul 2026) | Mozilla via press (secondary) |
| Natural Cycles | Contraception | FDA-cleared algorithm, six clearances, own band, Garmin | Press (From the docs). **Femio must stay out of this lane (rule 1)** |
| Premom | Fertility | OPK strip photo analysis; Arabic in listing; FTC settlement 2023 **[NEEDS SOURCE]** | Benchmark 10-08 (listing); FTC unsourced |
| Fertility Friend | Fertility | Deepest BBT charting and education | docs/03 (July, unsourced) |
| Ovia | Pregnancy and parenting (B2B2C) | Lifecycle concept closest to Femio, but three apps and employer-funded | docs/03 §H.4; Labcorp owns it since 2021 |
| Pregnancy+ (Philips) | Pregnancy | 3D visuals, polish, 80M+ downloads | App Store via Philips (From the docs) |
| BabyCenter, What to Expect | Pregnancy | Editorial content, community. Ad-funded; data-broker criticism **[NEEDS SOURCE]** | docs/03 §C (unsourced); 02 gives "100M+ monthly" (conflicts with 03's "400M users", C-17) |
| Balance (Newson) | Menopause | Named clinician on the page; ORCHA; UNFPA partnership; 1M+ users | balance-app.com (From the docs) |
| Caria | Menopause | CBT programmes; a published study **[NEEDS SOURCE]** | docs/03 §D (unsourced) |
| Stella (Vira) | Menopause, South Africa | HRT pathway; Discovery bundle | Discovery press release (From the docs) |
| Midday (Lisa Health, Mayo) | Menopause, US | AI plus wearable hot-flash detection | Mayo news, Femtech Insider (From the docs) |
| Midi Health | Menopause care, US | Care delivery; $150M run-rate. **Round described wrong in 02** (C-20) | Femtech Insider, 3 Oct 2025 (**Checked**, scraped) |
| Oura, Whoop | Wearables | Biometric-to-insight layer; Perimenopause Check-In with provider report | Android Authority, 9to5Google (From the docs) |
| Apple Health, Samsung Health | OS-native | Free tracking floor; retrospective ovulation from wrist temperature | TechCrunch, Samsung (From the docs) |
| Al-Malika (الملكة) | Arabic cycle and pregnancy | Tracking plus paid OB-GYN consult ($19) and forum; the closest model in Arabic | App Store US (From the docs) |
| Hawaa (حواء) | Arabic period tracker | Simple, Arabic-native; 4.2★ on 545 ratings | App Store (From the docs) |
| Pregnancy calculator (حاسبة الحمل) | Arabic pregnancy | 2.5M+ downloads, 344K ratings; Hijri dates; consult access. Ad-funded; reported intrusive ads and IVF-dating errors | mwm.ai (From the docs) |
| Altibbi | Arabic telehealth and content | Owns Arabic medical search; 1,500+ doctors; $44M Series B. Traffic per benchmark: 3.3M visits/month in SA (Semrush estimate) | pharmaphorum; Semrush via benchmark |
| Sehhaty (Saudi MoH) | Government super-app | 27M+ beneficiaries; default for every Saudi resident | MoH (2023 news link; figure dated) |
| Vezeeta | Booking, EG | The booking rail for gyn teleconsults | Vezeeta (price unverified) |
| Nabta Health (UAE) | Hybrid women's health, corporate | $4.5M raised; clinical partnerships | Wamda (From the docs) |
| Mumzworld | Mother and baby commerce | $29–35M sales; the commerce rail | ECDB (From the docs) |
| Muslim cycle apps (Sila, Nisa Care, Tuhr, Dhibic, CyclePray, Afifa) | Faith-aware tracking | Prove demand for haid and prayer-aware tracking. Indie, fiqh-only, crowding | App Store, mwm.ai; App IDs suggest 2026 launches (**Hypothesis**) |
| Glow / Eve | Community | Community; 2024 breach **[NEEDS SOURCE]** | docs/02, docs/03 (no link) |
| Peanut | Community | Community only; scale unverified | Digital Trends (old figure) |
| Maven Clinic | B2B employer care, US | $1.7B valuation (per docs; a link slug suggests a $125M raise, unverified) | Fierce, Axios, Forge (From the docs) |
| IMC Women's Health (Jeddah) | Hospital app | Clinical brand; PCOS, BP, glucose | Madhyamam (From the docs) |
| Healthline, WebMD, Mayo, Cleveland Clinic, NHS | Content (SEO) | Own the search terms. docs/03 §F says "no interactive tools" **[NEEDS SOURCE]**; Hypothesis: several publish calculators, not checked | docs/03 §F |

### 3.4 Markets

| Market | Role | Key numbers (label) | Gate or risk |
|---|---|---|---|
| Saudi Arabia | Revenue first (D4) | 34.4M internet users, 99.0% (DataReportal, From the docs). Snapchat female share 43.5%. Flo SAR 9.99–249.99 tiers. GCC in-app spend >$700M in Q2 2025, +20% YoY (Sensor Tower, From the docs). 48 PDPL violation decisions in 2025 (From the docs) | SDAIA enforcement live. Mawthooq licence for paid influencers (SAR 15,000) |
| Egypt | Volume, content, clinicians (D4) | 98.2M internet users, 82.7%; Snapchat female share 57.0%; 1.9M births in 2024 (CAPMAS via Egyptian Streets, From the docs). Flo EGP 69.99–1,499.99 tiers | **PDPL enforcement from 31 Oct 2026** (4 days from today). Licence for sensitive data; applicability to a foreign controller is unresolved (02 §12) |
| UAE | Fast follower (D4) | UAE in-app spend +26% (Sensor Tower) | Federal Law 2/2019: health data from UAE health services stays in UAE. A clinician marketplace would trigger it |
| EU and global web | Content and SEO only (D4) | Arabic is the content language of 0.6% of websites (W3Techs, From the docs) | Only context for the web surface |
| MENA overall | Context | Femtech in MENA $1.2B (Emergen; methodology not public). Women's-health VC is tiny (Nabta: $2M pre-Series A) | Commercial estimates; low confidence |
| US | Context, the leaders' home market | Women's-health health-tech VC fell to $478M in 2025 (−56%) while health-tech rose ~30% (Deloitte/PitchBook, From the docs) | One lens among several disagreeing sources |

### 3.5 Persona groups (`docs/personas/`, counted by Checked file listing)

| Group | Count | Track (docs/08) | Note |
|---|---|---|---|
| A | 6 | Puberty and adolescent (teen mode: no ads, minimal data) | Teen mode deferred until legal (02 §11.2) |
| B | 19 | Cycle and gynae health (not TTC, not pregnant) | Includes PCOS (B6), endo, fibroids, PMDD |
| C | 16 | Trying to conceive (TTC) | The wedge's first half; C15 fertility preservation |
| D | 17 | Pregnancy | The wedge's second half; D1 is the uncomplicated pregnancy |
| E | 7 | Postpartum | "Next layer" after the wedge (02 §10.1) |
| F | 6 | Perimenopause and menopause | Deferred as a module (02 §11.2) |
| X | 2 | Cross-cutting modes (partner, guardian) | X2 partner mode is "cleared for closed beta, not public launch" (ADR-069) |
| Total | **73** | | 24 wired in August (28 ledger) vs 57 "resolvable" (ADR-058): C-25 |

### 3.6 The wedge (D1): the reasoning in brief

From `02` §10.2 and §9 (scores are judgement; each is size × right to win × speed, max 125):

- **Where the job is.** Arabic listings and review counts say women open these apps to get pregnant and to follow a pregnancy. Period tracking for its own sake is a more Western framing (inference from listings, not measured).
- **Where Femio is already built.** Fertility logs, the pregnancy lifecycle, appointments, weight, screeners, partner sharing and the visit summary exist (CLAUDE.md, `01`).
- **Founder authority.** A clinician's voice on ovulation, PCOS and pregnancy is credible.
- **A chain, not a single moment.** TTC → pregnancy → postpartum → return of cycles is a multi-year arc; PCOS is a reason to stay before and after.
- **Revenue and reach split.** Gulf users pay near Western prices; Egypt brings births and cheaper creators.
- **Why not menopause first.** Crowded (Flo, Oura, Balance, Stella, Midi); stigma means content must come first.
- **Why not the EU first.** No distribution advantage there.

Ranked gaps (`02` §9): 1 Arabic-first TTC→pregnancy companion (100); 2 honest irregular-cycle/PCOS mode in Arabic (80); 3 Ramadan health hub (75); 4 verifiable privacy for MENA (64); 5 clinician bridge (48); 6 postpartum mental health in Arabic (36); 7 Arabic perimenopause education (36); 8 faith-aware worship-day counters (24). The arithmetic checks out (e.g. 5×5×4 = 100).

**Wedge premise that carries most weight:** "Flo has no Arabic." The evidence is the Saudi App Store listing (21 languages, Arabic not one) and Flo's help-centre reply. **Nobody ran Flo in Arabic on a device.** The 28 ledger's own method rule says reading and running differ in six of seven cases. Hypothesis: the Flo binary has no locale folders and renders strings server-side (28 ledger §3 item 9), so Arabic could be served without an app update. This is the most important unverified premise in the area.

### 3.7 Monetisation

- **Decided in principle:** freemium (OD-7). **Not decided:** the model and the price.
- **Free forever (candidate list, `03` §2.5):** tracking, predictions, pregnancy weeks, calculators, the library, privacy features, the Ramadan hub.
- **Paid (candidate list):** PCOS programme, pattern insights, the full visit pack, partner extras.
- **Timing conflict:** `03` §2.5 says "launch free, paywall designed but off". `02` §11.1 says "put depth behind the paywall" at launch. CLAUDE.md says "billing until retention data". See C-08.
- **Price anchors (From the docs):** RevenueCat health and fitness median $9.99/month and $39.94/year; 2.9% download→paid by day 35 (P90 12.1%); Clue Plus $39.99/yr; Balance+ $49.99–98.99/yr; Stella $79.99/yr; Natural Cycles ~$80–100/yr; Al-Malika $7/mo or $29/yr; Hawaa $4.99/mo. Docs/05 names Pro at $4.99/mo or $34.99/yr with no source (U-15).
- **Payments (owner rule, from the global instructions, not a project doc):** PayPal, Paddle or Google Play Billing only. Stripe and LemonSqueezy are not available to an Egyptian seller and must not be suggested. **Conflict:** `docs/06` makes Stripe the primary processor, names Paddle or LemonSqueezy, and adds Paymob or Tap for Egypt. `PROCESSOR_REGISTER` line 16 lists "Stripe / Paddle" for billing in Phase 2. **PayPal appears in no project document.** (C-06)
- **Store fees:** `docs/06` line 70 mentions Apple and Google fees with no figures. Unknown.
- **Shopify:** `CLAUDE.md` and `05` put a headless Shopify store in Phase 3. `06` recommends Shopify Basic at $39/month. `02` §11.2 says e-commerce is affiliate-only (Mumzworld owns the rail). (C-07)

### 3.8 V1 lessons (`docs/01`) and whether they still hold

| Lesson | Status now |
|---|---|
| No backend; everything on device (root cause #1) | **Reversed on purpose**: v1 has no backend by design (D7). Hypothesis: the lesson was about reach and sync; "no accounts" changes the problem rather than solving it |
| Content baked into code; no CMS | **Reversed**: D3 publishes from repo Markdown, not an admin portal |
| No SEO surface | Still binding (the web content is the acquisition engine) |
| Naive predictions | Still binding (product rule 3; ranges and confidence) |
| No multilingual pipeline | Still binding; Arabic content is still 0 articles (benchmark, Checked) |
| Firebase never configured; dead buttons | Lesson on discipline; carried into CLAUDE.md rules |
| Privacy as a headline | Still binding; now "verifiable privacy" (02 §9 gap 4) |
| Carry forward: four life-stage onboarding; condition profiles; doctor PDF | Partly carried (visit pack, 02 §11.1 item 6) |

### 3.9 Previous SWOTs

- **One formal SWOT exists in the area:** `02` §8 (2026-10-07, "blunt, as asked", written by the same author as the research). **Strengths:** clinician founder; Arabic and RTL from line one; product rules that are also market advantages; privacy architecture built; more product than a pre-launch company. **Weaknesses:** one person; no mobile app; no users or evidence; AI-built codebase with unvalidated quality; 100 English articles, 25 reviewed; 73 personas as a liability; single medical reviewer; legal and billing deferred. **Opportunities:** Flo's Arabic gap; PCOS in the Gulf (18.8%, low-quality evidence); Ramadan; Egypt births; privacy enforcement; payers in year 2; menopause awareness. **Threats:** Flo adds Arabic; ChatGPT Health and wearables commoditise "ask about my body"; regulatory gates; local incumbents and faith-app wave; influencer licensing; device-scope creep; founder bandwidth.
- **The July pack (docs 00, 05) has no SWOT.** Grep found none in `docs/archive` either.
- **`docs/03` §A–E** has strength and weakness columns per app; these are competitor SWOTs, not a SWOT for Femio.
- Note: the October SWOT says "31 bylined articles" in strengths and "100 articles" in weaknesses in the same section (C-19).

### 3.10 What we know for sure

Each item is labelled. "For sure" here means: two or more project documents agree, or a decision record says it, or I checked it. It does not mean an external source was verified.

1. **Wedge (D1):** TTC → pregnancy with PCOS depth; every other stage reachable. **From the docs** (owner accepted the defaults on 2026-10-07; recorded in archived OWNER_ACTIONS §0 and `30_REVAMP/03` §2.1).
2. **Markets (D4):** Saudi Arabia then Egypt, Arabic first; UAE next; EU web-only. **From the docs** (same record).
3. **Product shape (D7, D8, ADR-070):** a private Android app, no accounts in v1, records on the phone; the website is content, calculators and the way to the app; the web tracker is closed in production. **From the docs.** The `31_RESET` inventory says it checked `/en/sign-in` → 307 → `/en/app` on 2026-10-27 (not re-checked here).
4. **Register (OD-5, ADR-028):** conservative; no sexual-wellness product surface; clinical names kept. **From the docs**, repeated in four documents.
5. **No chat, no messaging (OD-8); AI assistant after V1 (OD-9).** **From the docs**, repeated in `CLAUDE.md` and `02` §11.2. Conflicts with `05` (C-10).
6. **Freemium in principle (OD-7).** The model and price are not decided. **From the docs.**
7. **Flo's store listing has no Arabic.** **Checked** on the listing (per the 2026-10-08 benchmark; the Saudi listing was re-checked by the lead). **Not tested in the running app** (section 3.6).
8. **Clue and Premom list Arabic in their store listings.** **From the docs** (benchmark 10-08, App Store). This contradicts the ledger's "no competitor has real Arabic" (C-12).
9. **The Femio site has 100 English articles, 0 Arabic, 25 with a named clinician reviewer.** **Checked** by the audit on 2026-10-07 and by the benchmark's read of the snapshot on 2026-10-08 (26 authors, 25 reviewers).
10. **Saudi internet 99.0% of 34.4M; Egypt 82.7% of 98.2M users (ad reach, late 2025); Snapchat is the highest female-share platform in both.** **From the docs** (DataReportal Digital 2026). Single source.
11. **43–87% of pregnant Muslim women fast at least one day (setting-dependent).** **From the docs** (two cited studies).
12. **Egypt PDPL executive regulations: licensing for sensitive data; enforcement from 31 Oct 2026.** **From the docs** (CMS and Al Tamimi; ADR-070 says the same grace period ends that day). **Time-critical.**
13. **SDAIA issued 48 violation decisions in 2025.** **From the docs** (one source: Global Privacy Blog).
14. **Women's-health health-tech VC fell 56% to $478M in 2025 (Deloitte/PitchBook).** **From the docs**, one lens. Other lenses disagree; the docs say so.
15. **The market-size numbers disagree by up to 7× depending on definition.** **From the docs** (`02` §0, the Oct research). This is the honest reading.
16. **V1 (Flutter) is archived and not to be built on.** **From the docs** (`01`, ADR-060 context); the Codex-built Flutter app is reference only (ADR-071).
17. **Persona files: 73, in groups A6 B19 C16 D17 E7 F6 X2.** **Checked** (file listing).
18. **Midi Health: $50M Series C (Oct 2025), ~$150M total, $150M revenue run-rate.** **Checked** (scraped Femtech Insider article, 3 Oct 2025). Contradicts `02` §2.3 (C-20).

---

## 4. Data flow

**Where facts enter:** (1) store listings and app pages (App Store SA, US, EG; Google Play, not read); (2) data-publisher reports (DataReportal, Sensor Tower, RevenueCat, Deloitte, PitchBook, Rock Health, W3Techs, WEF/BCG, GASTAT, CAPMAS via Egyptian Streets); (3) press and secondary aggregators (New Market Pitch for Flo's MAU and revenue; The Star for the Mozilla study; mwm.ai; Heepsy); (4) regulator and law-firm notes (SDAIA, CMS, Al Tamimi, Dorda, King & Spalding, Faegre Drinker, SFDA); (5) the owner, in chat.

**How they move:** owner chat → decision recorded in a runbook file (`OWNER_ACTIONS`) → an ADR in `DECISIONS.md` (only some) → `STATE.md` and `PROGRESS.md` → code. Market research flows `02` (research) → `03` (plan) → positioning copied into `02` §10.3 and `03` §2.4. The wedge statement is repeated in at least six files (`00_README`, `02`, `03`, OWNER_ACTIONS, CLAUDE.md, STATE.md); the copies have drifted (section 8).

**Services these documents name** (for the security and cost review): Vercel (hosting; `01` §3.5, STATE), Supabase (the free plan was restricted with HTTP 402 on 2026-10-06; ADR-070, STATE), Payload CMS (ADR-012, D3), Shopify (`06`), Stripe, Paddle, LemonSqueezy, Paymob, Tap (`06`, `PROCESSOR_REGISTER`), PostHog and Sentry (`01` §3.5), RevenueCat (benchmarks only), Google Play Console, App Store, Semrush and Ahrefs (tried, refused on plan or credits), Business Insider (via Femtech Insider). No runtime data flow exists in the strategy documents themselves.

**Health data:** none in these documents. The strategy documents contain no patient data (checked by reading). The Flo teardown and its evidence index point to decompiled APKs in `E:/re/` outside the repo.

---

## 5. Dependencies

- `30_REVAMP/03` depends on `01` (audit), `02` (market), `24` (architecture), `28` (evidence), `29` chapters 02–06 (specifications), and the OD list. It explicitly supersedes `29/07` and all earlier plans (`23`, `25`–`27`).
- `30_REVAMP/00_README` depends on `03`; it is stale on the Android row after D8.
- `CLAUDE.md` (repo) depends on `30_REVAMP` and `docs/STATE.md` for status. It still points to `OWNER_ACTIONS §A`, which no longer exists after the 2026-10-27 rewrite.
- `OWNER_ACTIONS.md` (current) depends on `ADR-070` and `compliance/PRIVATE_LAUNCH_V1.md`; its D1–D8 text lives in the archive.
- `05` depends on the July pack (`00`, `01`, `02`, `03`, `04`, `06`). Nearly everything in `05` is superseded.
- `28_TEARDOWN/*` depends on the Flo binary and emulator runs. `29_REBUILD/*` depends on `28` (gap IDs TD-nn, OD directions).
- The benchmark (`delegated/2026-10-08`) depends on `02` and `28/06–07`, and was accepted by the lead on 2026-10-08.
- Imports into code: none. This area is documents only.

---

## 6. Strings and i18n

This area holds no product strings. Relevant text:

- Arabic taglines, to be tested, not yet reviewed by a native speaker or clinician: `02` lines 593–594 (Arabic; the document says so).
- Arabic keyword candidates for ASO and SEO, with unverified volumes: `02` lines 383–393.
- Positioning and voice rules, in English: `03` §2.4 (lines 63–79) and `02` §10.3 (lines 581–590).
- "Arabic UI, English content" is the product's real state: `01` §3.2 (line 84). `docs/30_REVAMP/01` line 34 says Arabic RTL is built in.
- The four-language promise appears in `05` line 37 and in CLAUDE.md. The revamp defers full FR and ES until Arabic parity (`02` line 634). This is a stated conflict (C-11).

---

## 7. Tests and verification

No automated tests cover documents. What was checked, and how:

- **Checked:** line counts (`wc -l`) for every file in the inventory; persona file count and group split (`ls` plus `uniq`: 73, A6 B19 C16 D17 E7 F6 X2); grep for payment processors (Stripe, Paddle, LemonSqueezy, PayPal, Google Play Billing, Shopify); grep for SWOT across docs and archive (one SWOT in the area); reading of the full OD table in the ledger; reading of decisions D1–D8 and ADR-060, ADR-070.
- **Checked by opening external pages (two):** (1) VICE, "You Probably Shouldn't Follow Medical Advice From Your Period Tracker", published 28 Oct 2019. It reports (via the New York Times, 2019) that Flo "reportedly" recommended about 38% of assessment completers see a doctor about PCOS. **The attribution to Flo in `02` §4.1 is correct, but the source is a 2019 secondary report of a 2019 NYT report, not a VICE investigation.** (2) Femtech Insider, 3 Oct 2025: Midi Health raised **$50M Series C** (led by Advance Venture Partners), ~$150M total, $150M revenue run-rate. No Series D is mentioned. **`02` §2.3 ("Feb 2026, $100M Series D") does not match its cited article.**
- **Not verified:** any market figure against its primary source; App Store claims; all prices; Maven, Nabta, Altibbi, Sehhaty figures; Egypt and Saudi platform split; Flo's Arabic in the running app.

---

## 8. Smells, risks, contradictions and unsourced claims

### 8.1 Time-critical (from today, 2026-10-27)

- **Egypt PDPL enforcement starts 31 Oct 2026, four days away.** The docs call it a gate, not a checked fact (`02` §2.3, §12; ADR-070). The owner's file rewrite on the same day removed the lawyer step (C-23). Whether the private design avoids the licence is a counsel question (`02` §12: "launch-blocking"), and no counsel has been named.
- **Legal gate, two directions on the same day:** `OWNER_ACTIONS` (27 Oct, paraphrased) says the lawyer, DPO and DPIA sign-off is "replaced by legal pages and a short regulatory note" that a session drafts. `31_RESET/01` (27 Oct, its summary) says the critical path "is not code. It is the lawyer, the Arabic reviewer and Google Play's closed-test window". Both cannot be the plan.
- **Launch date 30 Nov:** live only in git subjects and `31_RESET`; no live document states it.

### 8.2 Contradictions between documents

Ordered by how much they would change a decision. The "wins" column says which source the evidence supports, or "owner" when a decision record settles it.

| # | Contradiction | Sides | Which wins / note |
|---|---|---|---|
| C-01 | **Platform route.** Capacitor (00, July) → Flutter (ADR-060, Aug) → web PWA then TWA then Flutter (03 §2.3, Oct) → Flutter Android first (02 §10.1, Oct) → Flutter Android local-first, web closed (D8, ADR-070, 7 Oct) | `00`, `03` §2.3, `30_REVAMP/00_README` Android row vs `02` §10.1, D8 | **D8 wins** (same-day decision record). `03` §2.3 and `00_README` are stale |
| C-02 | **Web product.** `03` §2.3 "web (PWA) is the product of record"; `02` §8 "the web product is an acquisition surface, not the product"; ADR-060 "web is also a real product"; CLAUDE.md "web is also a real product" | vs D8 "web beta closes" | **D8 wins** |
| C-03 | **Backend and accounts.** CLAUDE.md: Supabase (Postgres, RLS, auth, EU), "backend owns decisions"; `05`: accounts at MVP; `01` lesson 1: "no backend" was a root cause | vs D7 "no accounts in v1"; ADR-070 "the specification owns decisions"; the lead's brief for this study: "no Supabase at runtime" | **D7 / ADR-070 win**; CLAUDE.md and `05` are stale |
| C-04 | **Architecture rule.** "The backend owns decisions" (CLAUDE.md, ADR-060/061) | vs "the specification owns decisions" (ADR-070) | **ADR-070 wins**; CLAUDE.md is stale |
| C-05 | **Content and CMS.** CLAUDE.md: "Payload CMS for content"; `01` §3.4 and D3: retire Payload; `01` lesson 2: "headless CMS, all content managed from the admin portal, not code"; ADR-012: Payload is the source of truth; STATE: Payload stays the editor until P2.8 | D3 says publish from repo Markdown | **D3 wins as decision**, but it is not an ADR and ADR-012 still stands |
| C-06 | **Payments.** `06` line 17 and 56: Stripe primary, Paddle or LemonSqueezy, Paymob or Tap. `PROCESSOR_REGISTER` line 16: "Stripe / Paddle" for billing | vs owner's global rule: PayPal, Paddle or Google Play Billing only; Stripe and LemonSqueezy unavailable. No doc mentions PayPal | **Owner's rule wins** (it is the user's standing instruction). `06` and `PROCESSOR_REGISTER` need correcting |
| C-07 | **Store and Shopify.** CLAUDE.md "headless Shopify (Phase 3)"; `05` Phase 3 "store (Shopify)"; `06` §3 "Shopify Basic $39/mo" | vs `02` §11.2 "e-commerce: partner (affiliate) only; Mumzworld owns the rail" | **Unresolved.** `02` is later and is a research view; no decision record |
| C-08 | **Monetisation timing.** `03` §2.5: "launch free, paywall designed but off"; CLAUDE.md: "billing until retention data" | vs `02` §11.1: "put depth behind the paywall" at launch (PCOS programme, full visit pack, pattern insights) | **Unresolved.** Needs an owner decision |
| C-09 | **Prices.** `05`: Pro $4.99/mo or $34.99/yr, AI $9.99/mo (no source). `03` §A: Flo ~€33/yr. `02` §5.1: Flo "$39.99-ish" (Subger, secondary). `02` §5.1: Clue Plus $39.99/yr; `03`: Clue "~€10/mo" | Several figures, none sourced to a primary | **`02` (Oct) is the working set**; `05` prices are dead |
| C-10 | **Community and AI.** `05` Phase 2 "community v1" and AI tier at $9.99; CLAUDE.md "AI chat deferred (OD-9)" and "messaging/community deferred (OD-8)" | vs OD-8, OD-9, `02` §11.2 (community Year 2 "if ever"; AI chat after EU AI Act review) | **OD-8 and OD-9 win**; `05` is dead |
| C-11 | **Languages at launch.** `05` and CLAUDE.md: four languages (EN, AR, FR, ES) at MVP | vs D4 (Arabic first), `02` §11.2 ("full FR/ES after Arabic parity") | **D4 / `02` win** |
| C-12 | **Competitor Arabic.** `28` ledger §2 C-2: "No competitor has real Arabic". §4: "Arabic and RTL is genuinely unopposed" | vs `02` §3.1 (Clue: Arabic among 27 languages, "the only global leader with Arabic"), §3.2 (Al-Malika, Hawaa, pregnancy calculator are Arabic-native), benchmark 10-08 (Premom also lists Arabic) | **The ledger overstates.** "Real" is not defined. Fix the ledger's wording to "no competitor serves a clinician-led, referenced Arabic product" if that is the claim |
| C-13 | **Lifecycle uniqueness.** `03` §G.1 "nobody owns the full lifecycle"; §H.5 "not one of them markets continuity"; `00` "no competitor covers the full lifespan" | vs `02` §2.3 ("whole life" alone no longer unique: Flo perimenopause and Premium suite, Jul 2025 and May 2026); `28` ledger §3 item 4: Flo "repositioning onto our Track E" | **`02` and `28` win**: the uniqueness claim is weaker than `00` and `03` say |
| C-14 | **"The only company."** `03` §H.4: "The only company attempting Femio's product is funded by pointing women's reproductive data at their employers" | vs `02` §11.1 #9 (Flo for Partners and Clue Connect show partner-sharing demand) | **Overclaim.** Ovia's employer model is real; "the only company" is not. Reword |
| C-15 | **Web-first is uncontested.** `03` §G.4: "top trackers are app-only" | vs `03` §A: Flo "iOS/Android/web(lite)" in the same document | **`03` §A wins** on Flo; the claim is true only for some competitors |
| C-16 | **Market size.** `02` (Jul) "~USD 5–6B in 2025, to $25–29B by 2034/35" | vs `02` Oct: femtech narrow $8.56–9.12B (2025) to $18.98–41.14B (2031–34), women's-health apps $12.87B by 2030 | **Definitional** disagreement; the Oct doc names it (§0). The July figures are dead |
| C-17 | **BabyCenter scale.** `03` §C: "400M users" | vs `02` Oct: "100M+ people monthly (all surfaces)" | **Different metrics** (lifetime vs monthly). Pick one and state the metric |
| C-18 | **Flo scale.** `00` and `03`: "320M+ users" | vs `02` Oct: "420M+ lifetime"; "77M MAU (2026)" from a secondary aggregator | **Dated** (July vs Oct). `02` Oct is newer but its MAU figure is secondary |
| C-19 | **Article counts.** `28` ledger §4: "105 authored / 31 live". `02` Oct §8 strengths: "31 bylined articles" | vs `01` §2 and benchmark: 100 published, 25 reviewers; `02` Oct §8 weaknesses: "100 articles" in the same section | **`01` and the benchmark win** (checked). 31 is a stale count in two files |
| C-20 | **Midi Health round.** `02` §2.3 (Feb 2026): "$100M Series D; $150M run-rate". Cited URL: Femtech Insider, 3 Oct 2025: "$50M Series C; ~$150M total; $150M run-rate" | Scraped source | **The cited source does not support the Series D or the Feb 2026 date.** Fix or find a source for the Series D |
| C-21 | **VICE 38% PCOS.** `02` §4.1 "a VICE investigation" | Scraped source: 2019 VICE piece reporting a 2019 NYT report | **Attribution correct; source is old and secondary.** Say so in the doc |
| C-22 | **Egypt price ratio.** `02` §5.2: Egypt subscriptions "sell at a quarter or less of Gulf prices" | The same section's Flo figures (EGP annual tiers about US$15–30; top SAR tier 249.99, about US$67) give a top-tier ratio of roughly 0.2–0.45. The bottom tiers (EGP 69.99 vs SAR 9.99) give roughly 0.5–0.75. Conversion unverified | **Loose.** Hypothesis: the claim is not wrong but is not shown. Show the arithmetic or soften it |
| C-23 | **Legal and lawyer.** CLAUDE.md "Legal (P0.12) is now a launch condition ... OWNER_ACTIONS.md §A". `02` §10.2 and §12: "counsel questions, launch-blocking" | vs `OWNER_ACTIONS` (27 Oct): no §A; lawyer "replaced by legal pages"; `31_RESET/01` (27 Oct): critical path "is the lawyer" (its summary) | **Unresolved and time-critical.** Pick one and fix CLAUDE.md's pointer |
| C-24 | **Launch date.** D5 (7 Oct): week of 30 Nov. Git `098e18e`: 4 Jan 2027. Git `adee59e`: back to 30 Nov. `31_RESET`: "34 days away" | No live document states the date | **30 Nov** per the latest commit and `31_RESET`. Record it in a live file |
| C-25 | **Persona count.** ADR-058 (7 Aug): "57 of 73 resolvable". `28` ledger §4 (23 Aug): "24 of 73 wired"; "two-thirds unwired" | | **Different definitions** ("resolvable" vs "wired"). Name the definition in both |
| C-26 | **Study counts.** `28` index: "16 owner directions" and "the 7 corrections". Ledger §7: "Fourteen owner directions recorded. Seven corrections made." Ledger table: OD-1…16 and C-1…14. Index "Owner directions recorded during this study": four | | **Internal miscount.** The tables are the truth; fix §7 and the index |
| C-27 | **Stardust.** `03` (Jul) §A: "privacy framing" (a strength) | vs `02` Oct: privacy damaged; removed E2E claim; sends health data to RudderStack (Mozilla, Jul 2026) | **Oct wins** (newer and sourced to Mozilla) |
| C-28 | **Decision ledger vs ADRs.** D3 (retire Payload) and D5 (launch date) are decisions with cost and are not in `DECISIONS.md` | `DECISIONS.md` | Add an ADR for D3 (it reverses ADR-012) |
| C-29 | **Acquisition surface.** `00` "competitors' weakest surface is web/SEO" | vs `02` §11.1 #10 and §8 ("Arabic is 0.6% of the web"; "100 English articles, 0 Arabic") | Not a contradiction: the web is the acquisition engine but has no Arabic content yet. Note the gap in the plan |

### 8.3 Claims without a source (or with a source that does not support them)

Each entry gives the claim, where it sits, and what is missing. Entries marked **[ADDRESSED]** are corrected by a later document.

| # | Claim | Where | Gap |
|---|---|---|---|
| U-01 | ~1.1 billion women menopausal by 2025 (WHO estimate) | `02` (Jul) line 7 | No link |
| U-02 | Menstrual health apps are the largest segment | `02` (Jul) line 6 | No link |
| U-03 | Endometriosis diagnosis delay 7–10 years | `02` (Jul) line 16 | No link. Widely quoted; cite it or mark [NEEDS SOURCE] |
| U-04 | Saudi 99% internet penetration | `02` (Jul) line 8 | No link; DataReportal (Oct) supports 99.0% — **[ADDRESSED]** in `02` Oct |
| U-05 | Flo 320M+ users; Flo ~€33/yr; Clue ~€10/mo; Balance $99/yr | `03` §A and §D | Table rows with no per-row link. Several are dated |
| U-06 | FTC actions: Flo 2021; Premom 2023 settlement | `02` (Jul) line 30; `03` §A, §B | No link |
| U-07 | Glow data breach 2024 | `02` (Jul) line 30; `03` §A | No link. `02` Oct cites "docs/02" only |
| U-08 | What to Expect "sells personal data" (Mozilla flagged); BabyCenter data-broker practice (2024 Senate inquiry) | `03` §C lines 29–30 | No links |
| U-09 | Caria has a published clinical study; Afifa "proves the niche" | `03` §D line 38; §E line 43 | No links |
| U-10 | Clue: peer-reviewed algorithm; GDPR and Berlin positioning | `03` §A line 8 | No link |
| U-11 | Healthline, WebMD and content sites "offer no interactive tools" | `03` §F line 48 | No link. Hypothesis: several publish calculators; not checked |
| U-12 | Post-Dobbs anxiety persists in the US | `02` (Jul) line 28 | No link |
| U-13 | IVF: "almost no mainstream app covers IVF" | `02` (Jul) line 19 | No link. Competitor list in `03` §B is also unsourced per row |
| U-14 | Teen apps "most apps 17+" | `02` (Jul) line 13 | No link |
| U-15 | Pro $4.99/mo or $34.99/yr; AI tier $9.99/mo | `05` lines 23–24 | No source. Nothing in `02` Oct supports these |
| U-16 | Success metrics: D30 retention > 25%; free→Pro conversion 2–5% | `05` line 44 | No source. The 2–5% sits next to RevenueCat's 2.9% download→paid by day 35, which is a different metric |
| U-17 | Apple guideline 5.1.3; Google Play health declaration | `05` line 33 | No link |
| U-18 | Flo ~$200M 2024 bookings; ~700 staff; 6.6M Premium sign-ups | `02` Oct §3.1 table | Secondary aggregator. `02` §12 flags only the MAU and revenue, not staff or sign-ups |
| U-19 | Flo ARPU ~$40 | `02` Oct §5.1 | Secondary (New Market Pitch); flagged in part |
| U-20 | Nabta "TIME HealthTech 2025" | `02` Oct §3.2 | No link in the row |
| U-21 | Ovia "~$20M revenue at acquisition" | `02` Oct §3.1 | No link in the row |
| U-22 | Maven "$1.7B valuation (Series F, Oct 2024)" | `02` Oct §3.1 | Sources are news headlines; one URL slug says $125M. Verify the valuation |
| U-23 | Saudi: 47.9% of a national sample use health apps | `02` Oct §4.2 | Source is a university staff-page abstract (Benha). Weak |
| U-24 | 90.4% of Saudi women use WhatsApp | `02` Oct §6.1 | Via a news site citing a "Saudi Internet 2025" report not linked. Weak |
| U-25 | Sehhaty: 27M+ beneficiaries; 11M+ appointments | `02` Oct §3.2 | Link is a 2023 MoH news item. Dated |
| U-26 | Egypt is Android-heavy; Saudi Android share "material" | `02` Oct §10.1 | Explicitly **unverified** in the doc. D8 (Android first) depends on it |
| U-27 | "Flo has no Arabic at all" | `01` §2; `02` Oct §1; benchmark | Store listing and help-centre text only. **Not tested in the running app.** See section 3.6 |
| U-28 | Femio's "k-anonymous insights", "offline queue", "31 bylined articles" | `02` Oct §8 strengths | Product and count claims without a link. Count is stale (C-19) |
| U-29 | Egypt subscriptions sell "at a quarter or less of Gulf prices" | `02` Oct §5.2 | No calculation shown (C-22) |
| U-30 | Gulf PCOS prevalence 18.8% | `02` Oct §1, §4.2 | Doc says low-quality evidence. Keep the caveat |
| U-31 | Arabic-native apps "ad-funded calculators with reported accuracy and login problems" | `02` Oct §9 gap 1 | Partly from store reviews (not sampled); mark as reported |
| U-32 | Founder "MBBCh" and clinical credentials | `02` Oct §8 | Owner's own statement; nothing to check, but name the credential in the public reviewer block once it is published |
| U-33 | Flo "revenue $157.6M–$275M (third-party)" | `02` Oct §12 | Flagged as secondary in §12 |
| U-34 | Natural Cycles "six FDA clearances; sixth Jul 2026" | `02` Oct §3.1 | One trade-press link. Cite the FDA database |
| U-35 | FDA Jan 2026 guidance: "relaxing oversight of low-risk wellness tools" | `02` Oct §2.3 | Two law-firm summaries. Cite the guidance |
| U-36 | "Freemium ... a useful free tier that shows what Femio can do" | `05` and `28` | Judgement, not a claim. Fine |

Claims that are sourced but whose source is weak (not unsourced, but the reader should know): Flo's "no Arabic" (store plus help centre); Midi (corrected); Clue's 1M paid subscribers (Clue's own press page); Balance's "1.5M downloads" (App Store, not re-checked).

### 8.4 Other risks and hypotheses

- **Hypothesis, schedule:** the revamp's phases (`03` §5: about 1 week, 1–2 weeks, 2–3 weeks, 1 week overlapping) add up to 5–7 weeks of full-time work. The owner's standing budget is 1–3 hours a day (global instructions). A 30 Nov soft launch is at risk unless scope is cut further. This is a judgement, not measured.
- **Hypothesis, regulatory:** the TTC feature (fertile window, "conception-day" logging) sits next to contraception. Flo's own disclaimer says its fertility number "cannot be used as a method of contraception or to aid conception" (`28` ledger §3 item 10). Femio's docs rely on framing alone. A TTC product should carry the same wording at the point of risk. Check with counsel.
- **Hypothesis, platform:** D8 (Android first) rests on an unverified platform split (U-26).
- **Risk, copyright and reverse engineering:** the study decompiled Flo (35,196 classes), Pregnancy Tracker and GO Flo APKs (`28` ledger §5). The copyright boundary in §6 says nothing is copied into Femio. OD-4 says to extract visual assets from the APKs. The stored evidence (`E:/re/`) is outside the repo, which is correct; whether reverse engineering a competitor's app is allowed under its terms is an owner or counsel question.
- **Risk, single point of failure:** one medical reviewer for every article, in four languages (`02` §8). The audit's 25 reviewed articles are the owner's own reviews.
- **Risk, store-policy readiness:** Apple 5.1.3 and Google Play health declarations are named but not planned (U-17).
- **Risk, Arabic content parity:** zero Arabic articles against a wedge built on Arabic (benchmark, Checked). The benchmark's own recommendation is P4.0 (Arabic top-50 first).

---

## 9. Keep, rebuild or delete: verdict per document

Judged against the current direction: private Android app (Flutter, records on the phone, no accounts); website as a static teaser that points to the app; no Supabase at runtime; wedge = Arabic-first TTC → pregnancy with PCOS depth, Saudi and Egypt.

- **`archive/2026-11/00_EXECUTIVE_SUMMARY.md`:** delete (or mark dead). Its thesis is kept in `02`; its web-first and Capacitor plan is wrong.
- **`archive/2026-11/01_V1_LESSONS_LEARNED.md`:** keep the lessons (privacy as a headline, honest predictions, discipline rules). Rewrite lessons 1 and 2, which D7 and D3 reverse.
- **`archive/2026-11/02_MARKET_USER_RESEARCH.md` (Jul):** delete or archive. Market size and pain-point numbers are superseded by `30_REVAMP/02`. Keep its user-segment table as a reference only.
- **`archive/2026-11/03_COMPETITOR_ANALYSIS.md`:** keep §H (craft teardown) and §E (MENA). Rebuild §A–G from `30_REVAMP/02` §3 with a source column. Fix §G.4 and §H.4–H.5 (C-13 to C-15).
- **`archive/2026-11/05_PRODUCT_STRATEGY_PLAN.md`:** delete. Its phases, accounts, community, AI tier and Shopify are superseded by D7, D8, OD-8, OD-9 and D3. Keep the success-metric idea but rebuild the metrics with sources.
- **`archive/2026-11/30_REVAMP/00_README.md`:** keep and fix the Android row (D8) and the web row (closed tracker).
- **`archive/2026-11/30_REVAMP/01_AUDIT_AND_CRITIQUE.md`:** keep. The best single document in the area: measured, dated, and it says what was stale.
- **`archive/2026-11/30_REVAMP/02_MARKET_RESEARCH_2026-10.md`:** keep as the current research. Fix C-20 (Midi), C-19 (article count), C-22 (price ratio), C-14 (the "only company" claim), C-07 (Shopify), C-08 (paywall timing), §10.1 (platform, to match D8 wording), and add sources for U-03/U-04-type claims where missing.
- **`archive/2026-11/30_REVAMP/03_REVAMP_PLAN.md`:** keep §1–2.2, §2.4, §3 (design), §4 (architecture). Rewrite §2.3 for D8 (no TWA; Flutter Android local-first) and §4 I-1 for the D3 decision record. §5 phase durations need the time-budget check (section 8.4).
- **`30_REVAMP/04_ANDROID_APP_SPEC.md`:** keep; the current spec. Not studied in depth here.
- **`archive/2026-11/30_REVAMP/PROGRESS.md`:** keep (not studied here).
- **`archive/2026-11/30_REVAMP/delegated/2026-10-08-competitor-benchmark.md`:** keep. The best-evidenced competitor note in the area; its Arabic-listing check should go into `03` §A.
- **`archive/2026-11/28_TEARDOWN/00_INDEX.md`:** keep; update the counts (C-26) and point to the ledger.
- **`28_TEARDOWN/11_FINDINGS_LEDGER.md`:** keep; the binding record. Fix §7 counts (C-26), C-2 and §4 "unopposed" wording (C-12), and OD-16 status (superseded by D8).
- **`28_TEARDOWN/01–04, 07, 08, 10, 12`:** keep as reference. `28/07` stays reference-only per OD-1.
- **`28_TEARDOWN/05` and `06`:** rebuild on the corrected counts (C-10), or mark them as the August state.
- **`archive/2026-11/28_TEARDOWN/09_BUILD_PLAN.md`:** delete. Superseded by `30_REVAMP/03` §5.
- **`29_REBUILD/00` and `07`:** delete or archive. `29/01–06`: keep as specifications (per `30_REVAMP/03`), but mark the palette in `05` as superseded by Dusk Bloom (D6).
- **`31_RESET/01` and `02`:** keep `01` as the dated inventory. Fix the "lawyer on the critical path" line once the legal position is settled (C-23).
- **`CLAUDE.md` (repo):** fix the stale points: Payload (D3), Supabase and accounts (D7), "backend owns decisions" (ADR-070), the `OWNER_ACTIONS §A` pointer (C-23), the Shopify Phase-3 line (C-07), and the four-language promise (C-11).
- **`docs/STATE.md`:** keep; update the Payload and Supabase lines.
- **`docs/DECISIONS.md`:** keep; add ADRs for D3 (retire Payload, reverses ADR-012) and D5 (launch date). Consider ADR-070's relation to ADR-060 explicitly.
- **`docs/runbooks/OWNER_ACTIONS.md`:** keep (short and current).
- **`docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md`:** keep §0 (the only written record of D1–D8). The rest is dead.
- **`docs/archive/2026-11/06_TECH_STACK_SKILLS_CHECKLIST.md`:** delete or rewrite. Its payment advice conflicts with the owner's rule (C-06). Its Shopify advice is not current (C-07).
- **`docs/compliance/PROCESSOR_REGISTER.md`:** fix line 16 (C-06).
- **`docs/compliance/PRIVATE_LAUNCH_V1.md`:** keep (not read in full here; the basis of D7).

---

## 10. Open questions (for the owner, or a deeper read)

1. **Payments.** Confirm the owner's rule (PayPal, Paddle or Google Play Billing only; no Stripe, no LemonSqueezy) and let a session correct `06` and `PROCESSOR_REGISTER`. Does the owner want Paymob or Tap considered for Egypt? (`06` mentions them; not on the owner's list.)
2. **Legal, four days before Egypt enforcement.** Lawyer or no lawyer? If the private design avoids the Egyptian licence for a foreign controller, who confirms it in writing? (C-23; `02` §12.)
3. **Launch date.** Confirm 30 Nov 2026 and record it in a live file (C-24).
4. **The Flo Arabic premise.** Has anyone run Flo with an Arabic device locale? If not, a 30-minute check settles the wedge's main competitive claim (section 3.6).
5. **Monetisation at launch.** Free with the paywall off (`03` §2.5), or depth behind a paywall (`02` §11.1)? Store fees will be needed for the answer (`06` gives none). (C-08.)
6. **Fertility-feature wording.** Does the TTC fertile-window feature carry Flo-style "not contraception" wording at the point of risk? Counsel question. (Hypothesis, section 8.4.)
7. **Android first.** Is there a measured Egyptian and Saudi platform split? D8 depends on it (U-26).
8. **Deferred items.** Confirm community, AI chat and Shopify are out of v1 (OD-8, OD-9; `02` §11.2) and remove them from `05` and `CLAUDE.md`.
9. **Record D3 as an ADR.** It reverses ADR-012. Owner to confirm it wants the ADR.
10. **Extracted competitor assets and decompiled code.** Where they are stored (`E:/re/`), who may see them, and whether the study is within the competitor's terms. Owner or counsel question (copyright boundary, `28` §6).
11. **Time budget.** Is a 30 Nov soft launch possible on 1–3 hours a day? If not, which phase is cut? (Section 8.4.)
12. **Mozilla and July 2026 privacy findings.** Two docs cite a Mozilla study via press. Read the Mozilla report itself before using it in the public privacy page.

---

*Study notes, not a plan. Nothing in this report changes a decision; it lists where the documents disagree and what the owner has to settle.*
