# 09 — Plans, decisions and architecture (study report)

Study date: 2026-10-27 · Branch `claude/femio-repo-study-planning-88d7c9` · Read-only study; the only files written are this report and `docs/32_STUDY/graph/09-plans-architecture.json`.

Labels: **Checked** = I measured it today with a command. **From the docs** = a project file says it; I did not re-verify. **Hypothesis** = my reading. Anything about the running code beyond a few listings is **not verified**. When I wrote this, only one other study report existed (`reports/05-data-cms.md`); I used it in one place (section 5, marked "per report 05") and nothing else.

Not read in full: `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` (only the OD-1..16 table), `docs/DECISIONS.md` ADR-001..059 (titles plus the bodies that matter for supersession; ADR-060..071 in full), `docs/07_MASTER_TODO.md` (structure, counts and the open sections, not every line), `docs/30_REVAMP/PROGRESS.md` (read in full except that a few very long lines, notably P3.6, were cut at 900 characters).

---

## 1. Purpose in one paragraph

This area is the project's "why and where": the constitution (`CLAUDE.md`, `AGENTS.md`), the living state (`STATE.md`), the October 2026 revamp plan and progress ledger, the reset/inventory that tried to stop the drift, the owner's action list, the decision log (71 ADRs), the older architecture and design documents, the queue (`07_MASTER_TODO`) and the changelog. It exists so a new session (human or agent) can find out in minutes what Femio is, what was decided, what is next and what is forbidden. The central finding of this study: **the direction is clear and narrow (a private Android app, Arabic-first, TTC to pregnancy, launch the week of 30 Nov 2026), but a large part of the document set still describes the previous product (a web-first, account-based, server-decided, whole-life platform).** Section 4 lists 41 places where documents disagree and which side the newest document implies.

**What is true today (From the docs, newest wins):** Femio is a private Android app (Flutter, `apps/mobile`, v0.4.0, health records on the phone, no accounts, no analytics or ads SDK). The website `femioapp.com` is the shop window: 100 cited articles, calculators and a "get the app" page; the web tracker is closed. Wedge: trying to conceive, then pregnancy, with PCOS depth. Markets: Saudi Arabia and Egypt, Arabic first. Look: "Dusk Bloom". The owner is the only person in every role (owner, clinical reviewer, legal approver). The soft launch is the week of 30 Nov 2026; the critical path is the build plus Google Play's 14-day closed test, not lawyers.

---

## 2. Inventory table (documents read)

Status: **live** = still binding or still the working reference; **app-only (closed web tracker)** = applies only to the web tracker that D8 closed; **dead** = superseded; **duplicate**; **unknown**.

| path | lines | one-line purpose | status |
|---|---|---|---|
| `CLAUDE.md` | 84 | Project constitution: product rules, repo map, skills | live, but its identity and architecture paragraphs are stale (C-01 to C-04) |
| `AGENTS.md` | 19 | Pointer to CLAUDE.md and a 4-step orientation | live (names a missing `docs/00_WHERE_WE_ARE.md`, C-37) |
| `docs/STATE.md` | 233 | Resume prompt, working loop, gate, environment traps | live; header says updated 2026-10-07 but holds 8 Oct notes (C-23) |
| `docs/30_REVAMP/00_README.md` | 26 | One-page revamp orientation, "three launches" | live but wrong on Android and TWA (C-05, C-06) |
| `docs/30_REVAMP/03_REVAMP_PLAN.md` | 276 | Strategy, Dusk Bloom, infrastructure, phases 0-5 | live for strategy and design; platform order and phases 3-5 superseded by D7/D8 |
| `docs/30_REVAMP/04_ANDROID_APP_SPEC.md` | 96 | What Android v1 is: onboarding, tools by goal, architecture | live (newest product spec); architecture section not yet met by code (C-08) |
| `docs/30_REVAMP/PROGRESS.md` | 70 | Checkpoint ledger P0-P4; first open line is the work | live |
| `docs/31_RESET/01_INVENTORY.md` | 168 | 27 Oct snapshot: why work drifts, token cost, critical path | live as a snapshot; its section 7 dates were re-set the same day |
| `docs/31_RESET/02_SPEC_V1_DRAFT.md` | 109 | Draft scope lock, launch dates, doc fixes, loop change | **DRAFT, nothing decided until the owner approves** |
| `docs/runbooks/OWNER_ACTIONS.md` | 43 | Rewritten 27 Oct: four manual actions; owner is every role | live (newest owner direction) |
| `docs/archive/runbooks-2026-10/OWNER_ACTIONS_2026-10-07.md` | 125 | Original owner file; the only full text of D1-D8 | dead as a task list; **live as the only home of D1-D6 text** |
| `docs/DECISIONS.md` | 526 | 71 ADRs (064/065 out of order; 066+ use a different format) | live |
| `docs/24_REVAMP_PLAN.md` | 198 | Three tiers, `ExperienceConfig`, golden fixtures | live as principle; mechanism dormant after ADR-070 (C-13) |
| `docs/22_APP_UI_ARCHITECTURE.md` | 269 | Conventions for the signed-in web tracker UI | app-only (closed web tracker); parts contradict ADR-060 (C-12) |
| `docs/14_SYSTEM_ARCHITECTURE.md` | 105 | Phase-1 architecture: ERD, RLS, API, i18n | app-only (closed web tracker) and stale (C-11) |
| `docs/12_BRAND_DESIGN_TOKENS.md` | 77 | v2 token rationale (violet, Fraunces, Inter) | dead for values (replaced by Dusk Bloom); live for logo rules and the contrast method (C-14) |
| `docs/09_MASTER_ADAPTATION_MODEL.md` | 238 | Persona "brain": invariants, wizard, Z1, events, state graph | app-only (closed web tracker); the seven invariants live on as product rules |
| `docs/femio_state_machine.mermaid` | 55 | Stand-alone copy of the state graph | duplicate of 09 section 7 with different labels (C-10) |
| `docs/07_MASTER_TODO.md` | 470 | Historical queue; header says new work is in PROGRESS | live as history; large parts stale (C-27) |
| `docs/CHANGELOG.md` | 178 | One `[Unreleased]` block, 71 bullets, 2 dates in total | live but misleading (C-36) |
| `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md` | 269 | Source of OD-1..16 (only that table read) | live as evidence |
| `docs/archive/plans-2026-08/25_DESIGN_DIRECTION_BRIEF.md` | 255 | Source of the rejected-ring rule and band/strip/stack vocabulary | archived but still cited as binding |
| `docs/compliance/PRIVATE_LAUNCH_V1.md` | 139 | Legal reasoning for D7 (only the opening read) | live (cited by ADR-070) |
| `docs/29_REBUILD/PROGRESS.md` | 153 | August web rebuild ledger (phases A-G; only headings and G read) | dead (sequence superseded 7 Oct); its G1 line is stale (C-33) |

---

## 3. The binding-decisions ledger (as of 2026-10-27)

"Still binding?" is my reading of the newest documents. **Superseded-by** names the document that replaced it.

### 3.1 Owner decisions D1-D8 (full text only in the archived 2026-10-07 owner file)

| ID | Decision (one line) | Date | Still binding? | Superseded / amended by |
|---|---|---|---|---|
| D1 | Wedge: trying to conceive, then pregnancy, PCOS and irregular cycles as depth; every stage stays reachable (sets emphasis, not access) | 2026-10-07 | **yes** | none. 02_SPEC proposes moving menopause and postpartum goals out of onboarding (draft only) |
| D2 | Route: web PWA first, Play via TWA, Flutter after launch signal | 2026-10-07 | **superseded** | D8 and ADR-070 the same day: the TWA step is replaced by the real Flutter app, built now. The 03 plan and 00_README still teach D2 |
| D3 | Retire Payload CMS; publish articles from Markdown in the repo | 2026-10-07 | **yes, decided, not finished** | P2.1 done (snapshot in repo); P2.8 (retire the CMS Vercel project) open. ADR-012 ("Payload is source of truth") is superseded by it with no ADR saying so |
| D4 | Markets: Saudi Arabia + Egypt, Arabic first; UAE next; EU web-only | 2026-10-07 | **yes** | none |
| D5 | Soft launch (50-100 women) the week of 2026-11-30 | 2026-10-07 | **yes** | Briefly re-dated to the week of 4 Jan 2027 (commit `098e18e`), then restored (commit `adee59e`; **Checked** in `git log`) |
| D6 | Visual direction "Dusk Bloom" (plum, rose, peach, saffron on porcelain) | 2026-10-07 | **yes** | Phase 1 built it; the owner review D-1 is still "pending" in PROGRESS; no ADR (ADR-006 still says violet) |
| D7 | Private launch: records stay on the phone, no accounts, predictions run on the phone, backup is a file, tracker 18+ | 2026-10-07 | **yes** | none (ADR-070) |
| D8 | Website promotes the Android app; web beta closes; development moves to the Flutter app | 2026-10-07 | **yes** | none (ADR-070) |

### 3.2 ADR-060 to ADR-071

| ADR | Decision (one line) | Status | Later superseded or amended? |
|---|---|---|---|
| 060 (2026-08-09) | Mobile is Flutter; "the backend owns decisions, the clients render them"; ADR-048's Capacitor packaging retired; `native-readiness-lint` repointed to "no medical logic in a client component" | **Flutter and the Capacitor retirement: yes. "Backend owns decisions": no** | Amended by ADR-070: decisions run on the device from a specification; tier 1 returns only when sync does |
| 061 (2026-08-09) | Personas reach the screen as a versioned `ExperienceConfig` document rendered through a module registry, never as `mode ===` branches; the type cannot express "hidden" | **partly**: the "rules are data, no restriction field" principle yes; the served-document mechanism is dormant | ADR-070. **Checked**: `apps/mobile/lib` has no persona or experience code (only the generated vocabulary file mentions the word) |
| 062 (2026-08-09) | Queue and archive are separate; one living STATE; an ADR only for a decision that cost something or could be reversed by accident | **yes** | none |
| 063 (2026-08-11) | Review gates move from before the build to during testing; the owner (clinician, Arabic speaker) is the recorded reviewer | **yes** | Re-affirmed by OWNER_ACTIONS 2026-10-27 |
| 064 (2026-08-11) | English is the master and lives in the repo; the `ui_strings` DB overlay never applies to the source locale | **yes** (moot at runtime once `ui_strings` leaves Supabase) | none |
| 065 (2026-08-16) | E3 (postpartum mood) resolves from what she said, never from her EPDS score; E5 is not a persona | **yes** (closed web tracker) | docs/09 and the mermaid file still say "E1 to E3: EPDS elevated" (C-10) |
| 066 (2026-08-21) | Name cycle phases only when her own cycles support it; ovulation estimated backwards (length minus 14); a window, never a day; the visual is a strip, not a ring | **yes** | Whether the Dart app follows it: **not verified** |
| 067 (2026-08-22) | WITHDRAWN: B12 was raised on a misreading. Lesson kept: quote the whole sentence before declaring two documents in conflict | **n/a** | withdrawn the same day |
| 068 (2026-08-23) | Partner sees a curated server-rendered view; the v1 RLS policy that showed him her scope is dropped; the never-shareable class is a DB constraint | **dormant** | Partner sharing deferred by ADR-070; the warning (do not add the policy back) still protects the code |
| 069 (2026-08-23) | (1) Partner sharing cleared for the closed beta only; (2) the in-app hero keeps its gradient; (3) Arabic uses Western digits | (1) dormant; (2) closed web app only; **(3) yes** | (3) echoed by the Android spec ("Western digits kept") |
| 070 (2026-10-07) | The product is a private Android app; records live on the phone; the website promotes it; the web beta closes; "the specification owns decisions" | **yes: the current top-level decision** | none |
| 071 (2026-10-27) | The Codex-built Flutter app is reference only (archived under `E:\_Archive\2026-10\`); `apps/mobile` continues and may mine it | **yes** | Title still says "Phase G starts fresh on the served contract", which contradicts ADR-070 (C-33) |

### 3.3 Owner directions OD-1 to OD-16 (August 2026 teardown, `docs/28_TEARDOWN/11_FINDINGS_LEDGER.md`)

| OD | Direction (one line) | Still binding? | Note |
|---|---|---|---|
| 1 | Gap register stays reference-only (exception to the TODO covenant) | historical | Spent; PROGRESS now sequences work |
| 2 | Depth: deep on the experience surface, inventory the plumbing | historical | Scope of the teardown |
| 3 | "Beyond parity" comes from our own corpus (73 personas, adaptation model, EMR-for-life, RTL, privacy) | **weakened** | The persona corpus is dormant in the Android app (Checked: no persona code in `apps/mobile/lib`) |
| 4 | Capture the visual layer by extracting assets from APKs, later by running the apps | historical | Method |
| 5 | Register: professional and conservative; no "sex" log categories; conservative intercourse or conception-day markers | **yes** | The Android log has "one intimacy marker kept visually quiet" (P3.4); whether its wording passes OD-5 in four languages: **not verified** |
| 6 | Onboarding: good-looking, joyful, simple, short, no overselling, ethical | **yes** | Realised as the 5-question flow in the Android spec |
| 7 | Monetisation: freemium; model later | **yes** | Paywall designed but off; billing deferred |
| 8 | No messaging, no chat: "not planned, not wanted" | **yes, and permanent** | The 03 plan (section 6) and CLAUDE.md say only "deferred"; TODO still lists P2.9 community/forum (C-26) |
| 9 | AI assistant is post-V1 | **yes** | TODO P3.5 "guardrailed AI tier" still open |
| 10 | Dashboard: fewer items than Flo, many more than today, persona tools surfaced, everything still reachable | **yes** | Realised as "Today" |
| 11 | Calendar more prominent than Flo's | **yes** | Calendar is a tab |
| 12 | Learn follows Flo's Insights tab structurally (search, question chips, rows, illustrated cards) | **yes** for the website; articles inside the app are P3.7 (open) | Website Learn hub done (P2.4) |
| 13 | Thesis: the experience should visibly adapt to the persona | **in tension** | The Android spec deliberately does not ask about conditions at onboarding and has no persona engine (C-09) |
| 14 | Femio must be at least as good as the three apps combined, then have features none has (a gate) | **yes in principle, narrowed in practice** | The wedge (D1) and the scope lock (02_SPEC) cut breadth; no document says how the gate is judged for a narrow v1 |
| 15 | Calendar detail is not optional (every period day, first/last distinguished, whole fertile window, ovulation marked) | **yes** | P3.4 says built; not verified on a phone |
| 16 | Build the mobile-first web app first, then iOS and Android | **superseded** | D7/D8 reversed it one day after the 03 plan said "OD-16 stands" (C-25) |

### 3.4 ADR-001 to ADR-059 (compact; "live" unless noted)

| ADR | Title / decision | Status |
|---|---|---|
| 001 | Web-first PWA + Supabase; Capacitor wrap in phase 4 | **superseded** (Capacitor by 060; web-first by 070) |
| 002 | Store via headless Shopify | live but deferred (Phase 3, unscheduled) |
| 003 | Project root E:\Femio | live |
| 004 | Persona-driven adaptive UX: constant EMR + additive layers, Z1 fallback, seven invariants | invariants live; mechanism dormant |
| 005 | No external multi-agent platform yet | live |
| 006 | Two-tier design tokens, CSS canonical, AA-verified; palette violet | structure live; **palette superseded** by D6 with no ADR |
| 007 | Constant-core EMR on Supabase, server-side resolver | **superseded in part** by 070 (device-side) |
| 008 | Pin Tailwind v3 | live |
| 009 | i18n JSON catalogs now | live (amended by 014, 064) |
| 010 | Anonymous mode via native Supabase anonymous auth | **moot** (no accounts, D7) |
| 011 | Migrations as versioned SQL applied by the owner | live for the website's DB; moot if Supabase is paused |
| 012 | Payload CMS as a separate app and content source of truth | **superseded** by D3 (not finished) |
| 013 | Global crisis-safety routing; account-less; collects nothing | **yes**; the Android entry point is not specified (open question) |
| 014 | DB-overlay i18n loader | live (amended by 064) |
| 015 | Privacy and Terms as noindex drafts until P0.12 | live until legal pages are published (P4.1, V1-08) |
| 016 | Author/reviewer bios as a `people` collection | live (CMS side moot after D3) |
| 017 | Analytics as a closed enum catalog | live (website only) |
| 018 | CMS staff roles bootstrapped out of band | moot after D3 |
| 019 | Consent is a reduction over an append/revoke ledger | live for the website; the app has no accounts |
| 020 | First-party aggregate-only product dashboard | dormant |
| 021 | Dependency ratchet, headers, content routes dynamic | live (dynamic part superseded by P2.1 static snapshot) |
| 022 | next-intl v4; ISR/notFound workaround stays | live |
| 023, 024 | Two-step sign-in for staff; MFA recovery outside the app | moot when the CMS retires |
| 025 | PostHog lazy-loaded after consent, EU | live (website only; **no analytics SDK in the app**, ADR-070) |
| 026 | Sentry scrubbed, EU | live (website); app crash reporting "without content" is P3.8 |
| 027 | Event call sites declare an area | live (website) |
| 028 | Health product, not a medical one: "clinician reviewed" framing, keep boundary sentences | **yes** |
| 029, 030, 035, 036 | CMS schema-push and interactive-prompt incidents and fixes | moot after D3 |
| 031 | Executable authoring brief: content guard and refusing importer | live |
| 032 | Owner holds the `medical_reviewer` role | **yes**, re-affirmed 27 Oct |
| 033 | A concurrent session reverted MASTER_TODO: habit | live lesson |
| 034 | Clear the dependency ratchet; override targets bounded | live |
| 037 | Ship only needed message namespaces | live |
| 038, 039 | FAQPage structured data; untranslated locale not indexable | live |
| 040, 044, 046 | CMS connection pool constraints; a sitemap must fail loudly | moot after D3 (sitemap rule live) |
| 041, 042, 043, 047 | Pregnancy dashboard; menopause count without conclusion; pregnancy endable; red-flag symptoms are not log entries | live as product behaviour; web tracker closed, ideas reused in the app |
| 045 | Slugs stay English in all locales | **yes** |
| 048 | Tracker ships as a package | **retired** by 060 |
| 049 | Kick counter is a pattern log with no pass mark | **yes** (reused in Dart: P3.6 movement log) |
| 050 | Adaptation model wired; payload split | app-only (closed web tracker) |
| 051 | Design gap is a workstream; shell and hero; text off decorative gradients | rules live; palette superseded |
| 052-056 | Day strip and touch targets; pregnancy term window not a finish line; real radio group; reduced motion global; duplication removed | live rules (web tracker) |
| 057, 058 | Resolver that cannot restrict; correction: 57 of 73 personas resolvable | live (dormant) |
| 059 | Wizard becomes medical triage (conditions question) | **overridden for the app** by the Android spec (C-09) |

Gap in the ledger itself (**Checked**): decisions D1-D6 were never written as ADRs. Only D7/D8 appear in `DECISIONS.md` (via ADR-070). The current `OWNER_ACTIONS.md` says "the full text is in the archived file". Dusk Bloom (D6), the retirement of Payload (D3) and the launch date (D5) therefore have no entry a future session would find by reading the decision log.

---

## 4. Contradictions across documents, with the resolution the newest document implies

Severity: **H** = a session can build the wrong thing; **M** = misleading, costs time; **L** = cosmetic or historical. "Newest" means the later of the two documents by date, and where dates tie, the one closer to the owner's own words (27 Oct `OWNER_ACTIONS.md`, then `ADR-070`, then `04_ANDROID_APP_SPEC.md`).

`02_SPEC_V1_DRAFT.md` section 5 already proposes fixes for C-01 to C-04 and C-05. **Checked: none is applied** (this branch's `CLAUDE.md` and `00_README.md` still carry the old text) and the draft says "nothing is decided until you approve it".

### 4.1 Product identity and platform

| # | Sev | Documents | What they say | Resolution implied by the newest |
|---|---|---|---|---|
| C-01 | H | `CLAUDE.md` "What Femio is" vs ADR-070, D7, D8, `OWNER_ACTIONS.md` | CLAUDE: one account for a whole health life; "web is also a real product"; the public site and CMS are support functions. ADR-070: the product is a private Android app; the web tracker is closed | The product is the private Android app. Whole-life stays a long-term ambition, not the launch |
| C-02 | H | `CLAUDE.md` architecture rule, ADR-060, `docs/24` vs ADR-070 | "The backend owns decisions; the clients render them" vs "the specification owns decisions", run on the device by TypeScript and Dart twins | ADR-070: rules live as versioned data plus golden fixtures, executed on the phone. Tier 1 (Edge Functions) returns only with sync |
| C-03 | M | `CLAUDE.md` governance ("read STATE.md, then the TODO") vs the same file's "How to work here", `STATE.md`, the `07_MASTER_TODO` header | Two read orders in one file | Read `STATE.md` then `30_REVAMP/PROGRESS.md`. The TODO is history |
| C-04 | M | `CLAUDE.md` "Next up: Phase 1 ... Dusk Bloom" vs `PROGRESS.md` | Phase 1 was finished 2026-10-07 | The next work is the first open line: P3.2 (rest), P3.6 (rest), P3.7, P3.8, P3.10; then P4 |
| C-05 | H | `03_REVAMP_PLAN` section 2.3 and phase table, D2, `00_README`, OD-16 vs D8, ADR-070, `04` | Web PWA first, Play via TWA within days, Flutter "after launch signal" vs Flutter Android app now, Play listing is the real app, no TWA | Flutter now (D8 says it "replaces D2's Play via TWA step") |
| C-06 | M | `00_README` "Android: Not started" vs `PROGRESS`, `01_INVENTORY` | Not started vs v0.4.0 | **Checked**: `apps/mobile` has 37 Dart files, 10,519 lines in `lib/`, 4 test files, `version: 0.4.0+4` |
| C-07 | M | `03` phases 3-4 and section 2.5, vs ADR-070 and `OWNER_ACTIONS` 27 Oct | Phase 3 builds the wedge app as a web PWA; Phase 4 has invite gate, Supabase Pro, SMTP, "analytics funnels visit to D7"; Phase 5 starts "when the beta shows retention"; premium switches on "after retention data" | Phases 3-4 are replaced by `PROGRESS` Phase 3-4. **New gap**: the app has no analytics SDK by design, so no document says how retention (the trigger for iOS and for monetisation) will be measured |
| C-08 | M | `04` section 5 vs `PROGRESS` P3.1 and the code | Spec: SQLite encrypted with a key in the Android Keystore behind a `Store` interface. Code: **Checked** `pubspec.yaml` has only `path_provider`; P3.1 says "private-file implementation"; Keystore encryption and app lock wait for P3.8 | The spec describes the target; today's store is an unencrypted private file. Treat encryption and backup as launch blockers (02_SPEC V1-05) |
| C-09 | H | ADR-059, OD-13, `docs/09` wizard vs `04` sections 1 and 3, PROGRESS P3.3 | ADR-059 (owner: the wizard is medical triage, "anything your clinician is watching?") vs `04`: conditions are not asked in onboarding; they are offered later; the old wizard is criticised | `04` wins for the app. ADR-059 survives only in the closed web wizard. PCOS depth (D1) is reached by choice, not by questionnaire. Nothing records that the owner's August triage instruction is now reversed for the app |
| C-10 | L | `docs/09` section 7 and `femio_state_machine.mermaid` vs ADR-065 | Both graphs say "E1 to E3: EPDS elevated"; ADR-065 says E3 never resolves from a score. The two graph copies also differ in labels | ADR-065. Neither graph file was updated. (Dormant in the app) |

### 4.2 Architecture documents

| # | Sev | Documents | What they say | Resolution implied by the newest |
|---|---|---|---|---|
| C-11 | M | `docs/14` vs ADR-010, ADR-012, D3, ADR-070, migration `0024` | Capacitor mobile; `device_key` anonymous mode; `content`/`content_i18n` tables; `rpc.resolve_state`; Payload as source of truth; Resend and DeepL | Anonymous auth became native (010); content tables were dropped (`0024`); resolver is an Edge Function; Payload is being retired (D3); the whole backend is dormant (ADR-070) |
| C-12 | M | `docs/22` sections 1 and 10 vs ADR-060, ADR-070 | "Every signed-in screen is a client component ... `native-readiness-lint` enforces it (ADR-048)"; "Mobile is the destination; the web is how we build it (ADR-048)" | ADR-048 is retired; ADR-060 repoints the lint; ADR-070 closes the web app. `docs/22` is now only a reference for the closed tracker. What `native-readiness-lint` enforces today: **not verified** |
| C-13 | M | `docs/24` ("decided", tier 1 is authority, Flutter consumes the endpoint) vs ADR-070 | Not annotated as amended | Mechanism dormant. **Checked**: the phone has no `ExperienceConfig` client. The web guards for it (`persona-branch-lint`, `tier1-portability-lint`, `tools-completeness-lint`) still run in `pnpm gate` (**Checked** in root `package.json`) |
| C-34 | L | `DECISIONS.md` form | ADR-065 sits before ADR-064; 066+ use a different heading style; 067 is withdrawn; 071 was renumbered from a local 070; D1-D6 have no ADR | Fix by an index, not by renumbering. Add ADRs for D3, D5/launch date and D6 only if a future session could reverse them by accident (D6 and D3 could) |

### 4.3 Design language

| # | Sev | Documents | What they say | Resolution implied by the newest |
|---|---|---|---|---|
| C-14 | M | `docs/12` and ADR-006 vs `03` section 3 and `femio.tokens.css` | Violet `#7C3AED`, raspberry `#E11D74`, teal, Fraunces and Inter; "supersedes the v1 tokens"; CLAUDE.md says docs/12 "supersedes the skill's v1 tokens". **Checked**: the CSS is now plum/rose/peach/saffron/sage with Newsreader, Plus Jakarta Sans, Noto Naskh Arabic | Dusk Bloom (D6). `docs/12` values are dead; the CSS is canonical. `docs/12` also says the Bloom mark "echoes the app's cycle-ring UI" while rings are rejected (C-19) |
| C-15 | L | `03` section 3.2 starting values vs `femio.tokens.css` (**Checked**) | Plan primary `#6B2558` (that is plum-700) but `--primary` is plum-600 `#8A3572`; dark primary plan `#E7A9CF` vs `--primary` plum-300 `#DDA2C8`; accent plan `#D9466F` (rose-500) vs `--accent` rose-600 `#BF2F59`; peach plan `#F2A07B` vs peach-400 `#F2956B`; fertile plan `#3D8B7A` (sage-500) vs phase sage-600 `#2F7163`. Ground, night, ink, surface, gold match | The plan said "starting point, contrast-checked"; the CSS was adjusted for contrast and is canonical |
| C-16 | M | `03` principle 6 vs `PROGRESS` P1.5, `docs/22` section 5, ADR-013 | Plan: crisis entry moves from a floating pill to header, menu and red-flag content, "no longer covers the product". Built: a compact 44px lifebuoy launcher (ADR-013 "kept") plus a visible "Need help now?" header link; `docs/22` still lifts the launcher over bottom bars | P1.5 is the newest evidence: both exist. **Open**: the Android app's crisis / help-now entry is not specified in `04` (ADR-013 says reachable everywhere) |
| C-17 | L | `25` section 5a vs `03` section 3.3 | Arabic display = IBM Plex Sans Arabic semibold ("a transliterated substitute would be worse than none") vs Noto Naskh Arabic 600-700 for Arabic display | `03` (newer). Checked in CSS: `--font-display` lists Noto Naskh Arabic |
| C-18 | L | `25` section 5a, ADR-051, ADR-069 vs `03` aurora | Dawn gradient = marketing only; hero gradients mark the answer card in the app; aurora is for "hero moments only" | Compatible if aurora stays on the four named moments (home hero, onboarding arrival, first prediction, each pregnancy week). Whether the Android app uses aurora on its first-prediction screen: **not verified** |
| C-19 | L | `25` section 5a (rings rejected; band, strip, stack) and ADR-066 vs `docs/12` ("cycle-ring UI") and the history of a half-built ring | Docs disagree on rings | Rings stay rejected (section 7.8) |
| C-41 | L | `25`: Fraunces never below 22px | Rule written for Fraunces; Newsreader replaced it | Not restated anywhere. Treat as carried (display type only at 22px and above): **Hypothesis**, confirm with the owner |

### 4.4 Launch, legal and people

| # | Sev | Documents | What they say | Resolution implied by the newest |
|---|---|---|---|---|
| C-20 | H | `01_INVENTORY` section 7, `02_SPEC` section 4, archived owner file, git history | Soft launch the week of 30 Nov (D5). Inventory (27 Oct, earlier): lawyer brief by 31 Oct, closed test must start by about 16 Nov. Then the commit `098e18e` re-dated to 4 Jan 2027, then `adee59e` returned to 30 Nov. 02_SPEC: release candidate 9 Nov, closed test 11 to 25 Nov | Week of 30 Nov, with 02_SPEC section 4's dates. Caveat: those dates are a **proposal** in a document marked DRAFT; only D5's week is a decided date |
| C-21 | M | `03` section 2.2, archived owner file (A1 lawyer, A2 DPO, A3 crisis sign-off, B1 Arabic reviewer), `PROGRESS` P4.0/P4.1, `CLAUDE.md` ("OWNER_ACTIONS section A") vs `OWNER_ACTIONS` 27 Oct | Legal and an Arabic reviewer are launch conditions vs "I will be the only one in charge of everything"; sessions draft the legal pages and note; Khaled approves | 27 Oct. PROGRESS P4.0/P4.1 and CLAUDE.md still point at roles and a section that no longer exist. Residual risk the owner accepts (02_SPEC): legal pages are not a lawyer's opinion |
| C-32 | L | ADR-015 (privacy/terms are noindex drafts until P0.12) | Still true on the website | Flipped by V1-08 / P4.1 when the new pages are approved |
| C-35 | M | CLAUDE.md rule 2 ("teen mode gates only ads/social/data, never knowledge") vs D7/`04` | Under-18 cannot use the tracker at all (18+ at launch); articles stay open | D7 wins for the tracker (compliance); knowledge stays open, so rule 2's intent holds. Worth one sentence in CLAUDE.md |
| C-40 | M | CLAUDE.md rules 4-5 vs ADR-070 | Rule 5 "one record spans life; never rebuilds or deletes" and rule 4 "export/delete, EU hosting" vs on-device records where "a lost phone without a backup loses the record" (ADR-070 says it bends rule 5) | ADR-070 wins; backup file is the only protection, hence V1-05 as a launch blocker |

### 4.5 Facts and numbers

| # | Sev | Documents | What they say | Resolution implied by the newest |
|---|---|---|---|---|
| C-22 | M | `CLAUDE.md` (100 articles, 940 tests), `STATE.md` (971 tests), `07_MASTER_TODO` (105 articles, 721 tests, 11 guards, dated 23 Aug), `29_REBUILD/PROGRESS` (756 tests, 23 Aug), `CHANGELOG` ("105 guides"), `01_INVENTORY` (93 test files) | Counts differ and none was re-run on 27 Oct (inventory says so) | Use `STATE.md` / `PROGRESS` (100 articles, 971 tests, from the docs). 105 vs 100 may be 100 articles plus 5 condition hubs: **Hypothesis**. **Not verified**: I ran no tests |
| C-23 | M | `STATE.md` header "Last updated 2026-10-07" vs its own body | Body contains 2026-10-08 (Android app, PR #26); says Supabase is restricted (402) until the billing reset; names branch `claude/epic-planck-5y8geb` (six commits not on `main`: **Checked** with `git log main..origin/claude/epic-planck-5y8geb`) | Treat `STATE.md` as about 3 weeks old. `01_INVENTORY` (27 Oct) is the freshest account of reality |
| C-38 | L | `STATE.md` "ten guards", TODO "11 guards" vs root `package.json` | **Checked**: `pnpm gate` chains typecheck, lint, test and 14 lint scripts | Use `package.json` as the source |
| C-39 | L | Root `package.json` description "web-first women's-health platform"; `dev`, `build`, `start`, `lint`, `typecheck`, `test` scripts all target `apps/web` | Nothing in root scripts builds or tests the mobile app (CI has a `verify-mobile` job, from the docs) | Cosmetic; mentioned because a new session reads it first |
| C-36 | M | `CHANGELOG.md` | One `[Unreleased]` block (71 bullets, 2 dates) describing dozens of web-tracker features (partner sharing, reminders, patterns, dashboard) as user-visible, plus only two lines about the Android pivot. No Android release notes | The changelog no longer describes what a user can do. Cut a block per release and mark the web-tracker entries as closed |

**The last 30 changelog bullets by theme (newest first; there are no dates):** (1-2) the Android pivot and the new homepage; (3-4) two new calculators and drawn results; (5-17) web-tracker features: patterns three ways, reminders, naming the partner, partner sharing, cycle variation summary, last-cycle summary, phase explanation, Tools tab, visit-summary separation, cycle-length question, phase strip, two-tap setup; (18-27) fixes: search without the database, crisis dialog in Arabic, visit summary printing and loading, recent-cycle averages, age-question consent, logging every period day, offline logging, consent overlap, honest load errors; (28-30) library: 105 guides live, the menopause warning page, ten teen guides. Everything from bullet 5 on describes a product D8 has closed.

### 4.6 Process and the queue

| # | Sev | Documents | What they say | Resolution implied by the newest |
|---|---|---|---|---|
| C-24 | M | `STATE.md` working loop ("Build in large steps ... Do not stop to summarise") and the owner's saved memory ("build, do not report", several items per pass) vs `02_SPEC` section 6 (one item per session, then stop and show Khaled; merge to `main` the same day; nothing outside section 2 before the launch; one builder) | Opposite habits | 02_SPEC is a proposal awaiting approval. The evidence in `01_INVENTORY` (work stopped 9 Oct; 6 commits not on `main`; two Flutter apps built in parallel) supports it. It needs an explicit owner yes because it reverses a stated preference |
| C-25 | M | OD-16 ("web app first") and `03` ("OD-16 stands") vs D8 | Same day | D8 |
| C-26 | M | OD-8 ("no messaging and no chat. Not planned, not wanted"), OD-9 vs `03` section 6 and CLAUDE.md ("deferred") vs `07_MASTER_TODO` P2.9 community/forum, P3.5 AI tier, P1.21 comment queue | Permanent no vs "after launch" vs still on the list | OD-8 is a permanent no; mark P2.9 (and the messaging parts of P1.21) `[DEPRECATED]` with the owner's word, per the covenant |
| C-27 | M | `07_MASTER_TODO` R5.1-R5.3 (Flutter over the tier-1 endpoint, Supabase session on device), P0.12.5 (gate signup), P1.24 (beta of 20-50 users) vs D7 | Accounts, endpoint, signup gate | All moot with no accounts; the beta becomes the Play closed test then the 50-100 soft launch (P4.3). The TODO header already says new work is in PROGRESS; nothing marks these lines `[DEPRECATED]` |
| C-28 | L | `03` section 4 I-6 (staging Supabase), I-7 (Supabase Pro), I-9 (SMTP), `STATE.md` (`@live` e2e need a staging project) vs `OWNER_ACTIONS` 27 Oct, C5 ("no longer needed") | Infra to-dos | Not needed. The `@live` e2e specs run against production and should be retired (per report 05, they still exist) |
| C-29 | M | CLAUDE.md "Payload CMS for content", ADR-012, `STATE.md` "Payload stays the editor until P2.8" vs D3 and `04` section 5 | Who is the editor | D3: Markdown in the repo is the source; the owner approves by saying "publish". Until P2.8 the CMS still exists; report 05 lists a safe 8-step sequence and warns the 25 reviewer names and review dates must be copied into frontmatter first |
| C-30 | L | D8 ("single call to action: get the Android app") vs P2.7 | The CTA leads to a "coming soon" page until a Play listing exists | Expected before launch. Becomes live at P4.2 |
| C-31 | M | `02_SPEC` section 3 (menopause and postpartum goals "show coming soon") vs `04` section 3 and `PROGRESS` P3.3 (both built and shot) | Drafted proposal would hide built features | Undecided (draft). Hypothesis: if the aim is "finish what is built and polish the wedge", hiding built paths adds work; the owner decides |
| C-33 | L | ADR-071 title "Phase G starts fresh on the served contract", `29_REBUILD/PROGRESS` G1 "Flutter clients on the served documents" vs ADR-070 | "Served documents" is the pre-ADR-070 architecture | ADR-070 |
| C-37 | L | `AGENTS.md` history text, `03` Phase 0 ("`00_WHERE_WE_ARE.md` pointed here") | Names `docs/00_WHERE_WE_ARE.md` | **Checked**: the file does not exist. Remove the mention |

---

## 5. Architecture: as the documents describe it, versus as the code is

Template mapping (this is a documents area, so sections 3-7 of the standard template are adapted): "key modules" = the ledger (section 3) and this section; "data flow" = 5.3; "dependencies" = section 8; "strings and i18n" and "tests" = section 8.

### 5.1 What the newest documents say the architecture is (ADR-070 + `04_ANDROID_APP_SPEC.md`)

- **Phone (the product):** Flutter, Android first, iOS from the same code later (ADR-060). A local store behind a `Store` interface (spec: SQLite encrypted with a Keystore key). Predictions and pregnancy maths run on the phone. Backup is an export file she saves; import on a new phone. No account, no analytics SDK, no ads SDK; crash reporting without user content. The article snapshot ships inside the app.
- **Rules as data, shared:** one specification plus golden JSON fixtures in `fixtures/domain`, run by the TypeScript code (website calculators) and the Dart code (app). A rule change lands as a fixture first.
- **Website (the shop window):** Next.js 15 on Vercel, four languages, static content from a snapshot in the repo, calculators, a "get the app" page. No sign-in, no tracker, no health data. Web tracker kept in the code behind `NEXT_PUBLIC_WEB_APP_ENABLED` (off in production, on in CI).
- **Dormant:** Supabase (Postgres, RLS, 3 Edge Functions) and the `ExperienceConfig` tier-1 engine (ADR-061); partner sharing; accounts. They come back only with sync and "a new ADR and the compliance package" (ADR-070).
- **Retiring:** Payload CMS (D3) and its Vercel project; the `ui_strings` overlay.

### 5.2 What I could verify about the code (Checked, cheap listings only; no build, no tests, no live site)

| Docs say | Code today | Verdict |
|---|---|---|
| Flutter app, Android first | `apps/mobile`: `version: 0.4.0+4`; 37 Dart files, 10,519 lines in `lib/`; 4 test files (`dates_test`, `day_marks_test`, `golden_fixtures_test`, `screens_test`) | matches |
| Tier-2 maths twinned with the web | `lib/domain/`: appointments, bbt, contractions, cycle_prediction, dates, day_marks, fertility, movements, pregnancy, weight (+ generated `log_vocabulary.g.dart`). `fixtures/domain/` holds 12 JSON files (appointments, bbt-chart, contractions, cycle-prediction, edd-from, experience-config, gestational-age, movement-pattern, persona-resolution, phase, signals-from-rows, weight-chart). Which of them Dart runs: **not verified**. PROGRESS P3.2 says the persona, phase and experience fixtures are deferred for Dart | matches, partly |
| Features: onboarding, Today, Calendar, Log, TTC, pregnancy tools | `lib/features/`: calendar, home, log, onboarding, pregnancy, today | matches (no articles, backup, lock, reminders, PCOS or Hijri folder: they are P3.7, P3.8, P3.10, open) |
| Local store: SQLite + Keystore | `data/store.dart`, `data/profile.dart`; `pubspec.yaml` has only `path_provider` among storage packages | **spec not met** (C-08) |
| Persona / `ExperienceConfig` rendering | No persona or experience code in `apps/mobile/lib` | dormant on the phone by design |
| Design tokens are one source | `assets/brand/tokens/femio.tokens.css` (431 lines) is canonical; `scripts/design/tokens-to-dart.mjs` generates `lib/theme/tokens.g.dart`; `tokens-parity-lint` and `tokens-dart-lint` are in `pnpm gate` | matches |
| Log vocabulary shared with the web | `scripts/mobile/sync-log-vocabulary.mjs` generates `log_vocabulary.g.dart` and `log_labels.g.dart`; `mobile-vocab-lint` is in the gate | matches |
| Web tracker is closed | `apps/web/src/lib/web-app.ts`: `webAppEnabled()` reads `NEXT_PUBLIC_WEB_APP_ENABLED === "1"`; `WEB_APP_SEGMENTS` lists the app routes; `APP_PAGE = "/app"`. Route folders `(app)`, `(public)`, `help-now`, `sign-in`, `welcome`, `reset-password` still exist | matches (the closure is a switch, not a deletion) |
| Content from the repo | `scripts/content/snapshot-cms.mjs` exists; `apps/cms` still exists | D3 half done |
| Supabase backend | `supabase/migrations`: 25 files (0001 to 0025); `supabase/functions`: `experience`, `partner-view`, `patterns` | present and dormant |
| One gate | Root `package.json` `gate` = typecheck, lint, test and 14 lint scripts (17 steps). Scripts are all web-centred; the mobile checks that exist in the gate are `tokens-dart-lint` and `mobile-vocab-lint` | matches the docs' claim of "a gate", but the docs say "ten guards" (C-38) |

Per report 05 (Checked by that agent, not by me): the public website makes exactly one live Supabase read (the hourly `ui_strings` overlay for ar/fr/es); the closed tracker is the only other consumer; the CMS is needed only to edit and to run the snapshot; **the Android app uses nothing from Supabase**.

**Not verified at all:** that `pnpm gate`, the unit tests, e2e and `flutter test` pass today (`01_INVENTORY` also did not run them); that the live site matches `main`; that the APK runs on a phone; whether the Dart code follows ADR-066 (phase naming) and ADR-049 (no pass mark); any crisis entry point in the app.

### 5.3 Data flow, as documented (v1, private)

1. **In:** she types onboarding answers and daily logs on the phone. Nothing is sent.
2. **Stored:** the local store on the phone (today a private file; target encrypted).
3. **Out:** (a) her own export file, saved where she chooses; (b) a doctor-visit summary she shares by PDF or WhatsApp (P3 plan, from the docs); (c) crash reports "without user content" (P3.8, not built). Everything else (analytics, ads, sync, partner sharing) is forbidden by ADR-070 until a new ADR.
4. **Website:** articles and calculators run in the browser; calculators compute locally ("private-calculation note" in the unmerged audit commits). External services named in the docs: Vercel (hosting), Supabase (one remaining read), Sentry EU and PostHog EU (consent-gated), Google Play (distribution), Google Fonts are **not** used (fonts self-hosted through `next/font`, per `03` section 3.3).

---

## 6. The launch path and dates

All dates 2026 unless stated. Today = Tue 27 Oct. "From the docs" unless marked.

| Date | Day | What | Who | Source | Days from today |
|---|---|---|---|---|---|
| 31 Oct | Sat | Egypt's data-protection licensing becomes enforceable (the plan's reason for legal urgency). `[NEEDS SOURCE]` here: I did not verify it | n/a | `03` 2.2, archived owner file | 4 |
| by 7 Nov | Sat | V1-05 backup and app lock, V1-06 articles in the app, V1-07 reminders and crash reporting, V1-08 legal pages built or drafted | Sessions | `02_SPEC` 4 (proposal) | 11 |
| **9 Nov** | Mon | **Release-candidate APK on the owner's phone**; Play Console account created; store listing AR/EN drafted | Owner (install, $25 account); sessions (listing) | `02_SPEC` 4 | 13 |
| **11 Nov** | Wed | Play closed test starts: 12 testers keep the app installed for 14 days | Owner finds the testers | `02_SPEC` 4, `OWNER_ACTIONS` #3 | 15 |
| 25 Nov | Wed | Closed test ends (14 days, **Checked**: 11 to 25 Nov is 14 days). Fix round; apply for production access (Google's review time is `[NEEDS CHECK]`) | Sessions, owner | `02_SPEC` 4 | 29 |
| **Week of 30 Nov** | Mon 30 | **Soft launch to 50-100 women, Egypt and Saudi Arabia (D5)** | Owner | D5 | 34 |
| ~8 Feb 2027 | | Ramadan 2027 expected to begin; the Arabic Ramadan-and-pregnancy / PCOS / gestational diabetes set is due before it | Owner reviews | `03` Phase 4, PROGRESS P4.0 | 104 |

**How the date moved (Checked in `git log`, plus the docs):** D5 set the week of 30 Nov on 7 Oct. On 27 Oct the inventory (before the owner removed the lawyer and reviewer roles) said a 31 Oct lawyer brief was needed and the closed test must start by about 16 Nov. A commit re-dated the soft launch to the week of 4 Jan 2027 (`098e18e`). The owner then removed every role but his own, and `adee59e` put the launch back to the week of 30 Nov. `02_SPEC` section 4 carries that second state.

**What moves the date, day for day (`02_SPEC`):** the release candidate slipping past 9 Nov; the closed test starting after 11 Nov. If Google's production review is slow the launch becomes the week of 7 Dec. Do not shorten the 14-day closed test.

**Blockers that only the owner can clear (`OWNER_ACTIONS.md`, 4 items):** install each test APK and report; create the Play Console account; find 12 testers; say "publish" on the legal pages and articles.

**Hypothesis (my reading, for the owner to test):** the date is feasible only if the four unbuilt launch blockers (V1-05 to V1-08) are built in the next 11 days. On `main` today they are all unbuilt (`PROGRESS` P3.7, P3.8 open; P4.1 open; `01_INVENTORY` notes work stopped on 9 Oct). Six commits (public-site audit fixes and the article template, P2.4) sit on `origin/claude/epic-planck-5y8geb` and are **not on `main`** (Checked); Vercel deploys `main`, so the live site does not have them. Whether to merge them is an open owner decision (`02_SPEC` section 7, item 2).

---

## 7. The "Dusk Bloom" design language: a reference a designer can work from

Sources: `03_REVAMP_PLAN.md` section 3 (intent), `assets/brand/tokens/femio.tokens.css` (**Checked**, canonical values), `PROGRESS.md` P1.1-P1.7 (what was built), `docs/22` (conventions), ADR-049/053/055/066/069, and the archived `25_DESIGN_DIRECTION_BRIEF.md` section 5a (the rejected patterns). Where the plan and the CSS disagree, the CSS wins (C-15).

### 7.1 One-paragraph brief
Modern, feminine without cliché pink, cinematic where it earns it, Arabic-native. The palette comes from dusk: deep plum, rose, peach and a thread of saffron over warm porcelain. It should read Gulf and Levantine, adult and calm. Her data is the hero; decoration never competes with it. Premium, but never clinical-cold.

### 7.2 Palette (canonical hex from `femio.tokens.css`)

| Family | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 |
|---|---|---|---|---|---|---|---|---|---|---|
| Plum | FBF3F8 | F5E3EF | EBC6DE | DDA2C8 | C56EA7 | A84A8A | **8A3572** | 6B2558 | 551D46 | 3F1534 |
| Rose | FFF1F4 | FFE0E7 | FFC2D0 | F996AE | EE6A8C | D9466F | **BF2F59** | 9E2449 | 7E1D3B | 63172F |
| Peach | FFF5EF | FFE7DA | FDCDB5 | F7B394 | F2956B | E7784B | C95E33 | A2482A | 7E3822 | n/a |
| Saffron | FCF7EC | F7EBCF | EFD59E | E5BC6B | D9A446 | C08A2E | A06F22 | 7F561D | 63431B | n/a |
| Sage | EFF7F4 | D7ECE5 | AFD8CB | 7FBFAD | 57A592 | 3D8B7A | 2F7163 | 275A50 | 214841 | 1B3A35 |

Plum 950 `#260A1F`, rose 950 `#3D0919`, sage 950 `#0F2420`. Neutrals are warm porcelain, faintly plum: 0 `#FFFFFF`, 50 `#FBF7F3`, 100 `#F4EDE8`, 200 `#E9DFD9`, 300 `#D8CBC4`, 400 `#B5A5A9`, 500 `#8E7B86`, 550 `#6F5E68`, 600 `#5E4D57`, 700 `#4E3F48`, 800 `#33262F`, 900 `#24141F`, 950 `#160C13`. Dark surfaces: `#140D14` (ground), `#1E1520` (card), `#281C2A` (raised), `#000000` only as the OLED user setting.

**Semantic roles (light | dark):**

| Role | Light | Dark | Use |
|---|---|---|---|
| Ground `--bg` | porcelain `#FBF7F3` | `#140D14` | page |
| Surface | `#FFFFFF` (sunken `#F4EDE8`) | `#1E1520` (raised `#281C2A`, sunken `#19111A`) | cards |
| Ink `--text` | `#24141F` | `#F6EEF2` | text (muted `#5E4D57` | `#C9B8C2`; subtle `#6E5D67` | `#A08F99`) |
| Primary | plum-600 `#8A3572` (link, soft fills, glow) | plum-300 `#DDA2C8` | brand, primary actions; solid fills carry white text (white on plum-600 = 7.41:1) |
| Accent | rose-600 `#BF2F59` | rose-400 `#EE6A8C` | period, highlights; **one accent element per view; never body text** (white on rose-600 = 5.58:1) |
| Phases | menstrual rose-600; follicular sage-600; ovulatory saffron-500; luteal plum-600 | ovulatory saffron-300 | the cycle strip only |
| Prediction band | saffron-400 | saffron-300 | every predicted window |
| Success / fertile | sage-600 (solid sage-700) | sage-300 | fertile window, success |
| Warning / danger / info | amber-600 / red-600 / plum-600 | amber-400 / red-400 / plum-200 | status; always with an icon or label |
| Aurora (hero only) | ground plum-900 + four blurred lights: rose-400 .78, peach-300 .55, saffron-300 .38, plum-400 .62; grain 14% | same (not themed: a hero is dark in both themes) | home hero, onboarding arrival, first prediction, each pregnancy week |
| Gradients | `--gradient-dawn` plum-700 to rose-500 to saffron-400 (marketing signature, never inside the app); hero gradients plum-800 to plum-600 (cycle), sage-800 to sage-700 (TTC), rose-700 to rose-600 (warm): every stop is AA under white | | text may sit only on hero gradients |

Rules: semantic token **names** never change (`bg-primary-solid` etc.), so a re-skin is a token change. Components use semantic tokens only, never primitives and never raw hex. Status is never colour alone.

### 7.3 Type

| Role | Latin | Arabic | Notes |
|---|---|---|---|
| Display (editorial) | **Newsreader** | **Noto Naskh Arabic** 600-700 | `--font-display`; headlines only; the old rule "never below 22px" is not restated (C-41) |
| UI / body | **Plus Jakarta Sans** | **IBM Plex Sans Arabic** | per-glyph font stacks, no locale branching. Arabic line-height 1.7 |
| Mono | JetBrains Mono | | rare |

Scale (px): 12, 14, 16, 18, 22, 28, 36, 48, 60, 72; body 16 minimum; display sizes use tracking -0.02em. Weights 400/500/600/700. All fonts are self-hosted via `next/font` (no runtime Google request). Rejected: Instrument Serif (cramped at UI sizes, P1.2), stock Inter/Fraunces pairing (replaced). The wordmark is always lowercase English **femio**, never transliterated, in every language.

### 7.4 Shape, space, elevation
4px spacing grid (4 to 128). Radii: 6, 10 (chips, inputs), 16, **24 (cards)**, 32 (sheets, hero), pill 999 (buttons). Inputs 48px; **touch targets 44px minimum** (WCAG 2.2 AA). Pill buttons carry a soft plum glow (`0 8px 24px rgb(138 53 114 / .28)`). Elevation is soft and plum-tinted: xs to xl; large shadows only for overlays and sheets. Rule from the brief: **one raised element per screen** (the hero); sunken for grouped or inert content. Frosted header (`saturate(180%) blur(20px)`), sticky. Breakpoints 360, 480, 768, 1024, 1440; judge everything on **390x844** first.

### 7.5 Motion

- **Spend it on four moments only:** home hero, onboarding arrival, the first prediction, each pregnancy week. Everywhere else is still, fast and legible.
- **Durations:** instant 80/100ms (press, toggle), fast/quick 150 (hover, focus), base/standard 250 (default), slow/deliberate 400 (sheets, a module entering), slower 600. **Easing:** standard `(.2,0,0,1)` for things that move; out `(0,0,.2,1)`; in `(.4,0,1,1)`; spring `(.34,1.56,.64,1)` for things that appear (log confirmation).
- **Aurora:** CSS only, one composited layer, drifts 22s alternate, with a grain tile; text on it stays white (>= 6.9:1 measured). Paused offscreen.
- **`.reveal`:** a section rises 16px and settles (scale .985 to 1) as it scrolls in, driven by `animation-timeline: view()`, gated by `@supports`. **Movement only, never a fade**, because a half-faded line fails contrast.
- **`.band-breathe`:** the prediction window's light swells and settles over 4.8s. The one uncertain thing is the one thing that moves.
- **Press feedback** on every Button (`motion-safe:active:scale-[0.98]`); hover does not exist on a phone.
- **Reduced motion is enforced globally** (all durations collapse to 0.01ms), **and** transforms keep a `motion-safe:` prefix anyway because a zero duration makes a scale instant, not absent.
- No JavaScript animation library unless CSS cannot do it; if needed, `motion` (Framer), lazy-loaded on that route only. Archived idea (`25` 5a): the band draws in from the axis on first paint at the slow duration. Whether it shipped: **not verified**.

### 7.6 Imagery and illustration
Own abstract-organic illustration from the Bloom mark (petals, moon, spark; `motifs.tsx` on the web), soft gradients and grain; **no photographs of people, no stock**. Plan: 12 Learn covers, 6 hero/onboarding pieces, 40 pregnancy-week size motifs (dates and pomegranates beside the usual fruit). Built so far: `TopicArt` covers generated by `scripts/design/generate-topic-art.mjs` from `--art-*` tokens (not themed: "like a printed book cover"; text never sits on art). The full set (P2.5) and owner approval (D-2) are open. Logo: six-petal Bloom with a "you/today" centre dot; never recolour petals, stretch, add effects or translate the wordmark.

### 7.7 Data-visualisation vocabulary
The prescribed shapes: the **band** (a horizontal range with fading edges and a today marker), the **strip** (30/60/90 days of one variable as a row of marks, size and opacity so colour is not the only channel; phases as segments with soft edges), and the **stack** (co-occurrence over a cycle). They mirror in RTL for free. Uncertainty is always drawn soft (fade, dotted, reduced opacity), never in numbers alone.

### 7.8 Rejected patterns (do not reintroduce; each cost something)

1. **Rings and circular progress**, everywhere (cycle ring, kick-counter ring, "complete" rings): a ring implies a target and a completion; a cycle is not a task, a pregnancy has no pass mark. A ring was half-built once before this was found (ADR-066). Note `docs/12` still mentions a "cycle-ring UI" (C-19).
2. **A single certain date, hard edges, "safe day" framing, a "late" counter in irregular modes** (product rule 3, ADR-066: a window, never a day; ovulation is cycle length minus 14, never day 14).
3. **A pregnancy bar that fills toward the due date** (draw the 37-42 week term window instead, ADR-053) and **any bar toward the 12-month menopause mark** (none at all).
4. **Pass marks, verdicts and scores:** no count-to-ten kick target, no screener grade, no "this looks like labour" (ADR-049, ADR-053, EPDS/MRS rules).
5. **Stock Tailwind violet** (retired) and stock-Inter look; **text on decorative gradients** (only hero gradients carry text); gradient text.
6. **Photographs of women and stock portraiture.**
7. **More than one raised element per screen; more than one accent element per view; hard borders and harsh drops.**
8. **A floating crisis pill covering the product** (relocated to header + menu + a compact lifebuoy lifted clear of bars; it must never be the thing that gets covered).
9. **Colour as the only channel** for status.
10. **Sexual-wellness imagery or "sex" log labels** (OD-5); anatomical-shock and glitter-baby clichés.
11. **Arabic-Indic digits** (ADR-069: Western digits in Arabic, pinned by a test); **transliterating the wordmark.**
12. **Physical `left`/`right`** in layout: use logical properties (`ms-`/`me-`, `start`/`end`).
13. Re-typing the Tailwind preset without clearing `.next/cache` (build "passes" with the old CSS; ADR-054) and token names that are not mapped in the preset (silently emit nothing).

### 7.9 Accessibility and RTL checklist
Contrast measured on rendered pixels with alpha composited (gradients and rgba backgrounds fool `getComputedStyle`); focus ring visible, 3px, never removed; reduced motion honoured; 44px targets; Arabic checked on every screen, mirrored, Saturday-first calendar in Arabic; English-fallback articles carry `lang`/`dir` plus a "not translated yet" note; judge on 390x844 in light, dark and Arabic.

### 7.10 What a designer cannot yet find in the docs
Dusk Bloom for the **Android app** (Flutter) is only derivable: colours are generated into `tokens.g.dart` (191 colours, light and dark) and the app uses the same type, but there is no Flutter-specific motion, aurora or component spec. The first-prediction "cinematic moment" on the phone is not specified. No ADR records the palette change.

---

## 8. Dependencies between documents, strings, tests, and the queue

### 8.1 Authority order the newest documents imply (highest first)
1. `docs/runbooks/OWNER_ACTIONS.md` (27 Oct): who does what; the owner is every role.
2. `docs/DECISIONS.md` ADR-070, ADR-071; D1-D8 (archived text).
3. `docs/30_REVAMP/04_ANDROID_APP_SPEC.md`: what v1 is.
4. `docs/30_REVAMP/PROGRESS.md`: the work order. `docs/31_RESET/02_SPEC_V1_DRAFT.md` sits here but is a **draft**.
5. `docs/STATE.md`: gate, traps, resume prompt (stale in places).
6. `docs/30_REVAMP/03_REVAMP_PLAN.md`: strategy (wedge, markets, positioning, voice) and the design language remain current; its platform order and phases 3-5 do not.
7. Reference only: `docs/24`, `09`, `14`, `22`, `12` (values), `29_REBUILD`, `28_TEARDOWN`, the archive.

Reading chain a new session actually follows: `AGENTS.md` to `CLAUDE.md` to `STATE.md` to `PROGRESS.md` (about 43 KB, 11,000 tokens, per `01_INVENTORY`). Two of those four files (`CLAUDE.md`, `STATE.md`) carry the stale identity paragraphs, so the first 30 KB a session reads partly describe the old product. Imports among documents: `AGENTS.md` documents `CLAUDE.md`; `00_README` documents `03`, `PROGRESS`, `OWNER_ACTIONS`; `04` depends on ADR-070 and `PRIVATE_LAUNCH_V1`; `02_SPEC` depends on `01_INVENTORY`; ADR-071 depends on ADR-070; the TODO header points to `PROGRESS`. The graph file has these edges.

### 8.2 Strings and i18n (as the documents govern them)
Rule (CLAUDE.md pillar 3, ADR-009/014/064): zero hard-coded user strings, keyed catalogues, ICU plurals (Arabic has six forms), RTL-safe logical properties, English is the master and lives in the repo, Western digits in Arabic. Four locales: EN/AR/FR/ES (web catalogues, app ARB files). The archived Codex app also had Turkish; it is "future option only" (ADR-071). **Arabic content gap (From the docs):** 0 of 100 articles exist in Arabic; the wedge is Arabic-first; the owner is the Arabic reviewer; first drafts exist for Ramadan and pregnancy (6 `[NEEDS SOURCE]` flags each). This document set contains no hard-coded UI strings to report; the one code-adjacent doc finding is C-08/C-16 (crisis entry in the app not specified).

### 8.3 Tests (what checks keep the documents honest)
Mechanically enforced facts: token parity (CSS to Tailwind preset to Dart: `tokens-parity-lint`, `tokens-dart-lint`), log vocabulary sync (`mobile-vocab-lint`), the closed-web-app route list (a test fails if a new `(app)` route is not covered, per P2.7), golden fixtures (TypeScript and Dart), the claims, crisis and content guards. **Nothing checks that the planning documents agree with each other**, which is how 41 contradictions accumulated in three weeks. I do not recommend a new tool (the owner's rule is value over infrastructure). The cheap fix is the five edits in `02_SPEC` section 5, plus an "amended by" line under ADR-060, ADR-061, `docs/24`, `docs/22`, `docs/14` and `docs/12` pointing at ADR-070 and the CSS.

### 8.4 The queue, counted

| Source | Open | In progress | Done | Other | Note |
|---|---|---|---|---|---|
| `30_REVAMP/PROGRESS.md` (**Checked**, line-start markers) | **11** | **4** | **22** | 0 | The live ledger. In progress: P2.4, P3.2, P3.6, P4.0. Open: P2.5, P2.8, P3.7, P3.8, P3.9, P3.10, P4.0b, P4.1, P4.2, P4.3, P4.4 |
| `07_MASTER_TODO.md` (**Checked**, marker occurrences) | 68 | 26 (19 at line start) | 95 | 1 BLOCKED, 3 DEFERRED, 4 DEPRECATED | Historical queue. Its own readiness header (dated 23 Aug) says 84 done, 16 in flight, 69 open, 2 deferred. A marker count is approximate: one line can carry several |
| `02_SPEC_V1_DRAFT.md` | 4 unbuilt launch blockers | | 4 built groups | 7 items proposed for v1.1 | V1-05 backup + lock, V1-06 articles in app, V1-07 reminders + crash reporting, V1-08 legal pages |

**Open items relevant to the app (PROGRESS, in order):** P3.2 finish the Dart maths (period-forecast and test-timing calculators; persona/phase/experience fixtures deferred); P3.6 finish pregnancy (week-by-week content needs sourced drafting); **P3.7 articles in the app + PCOS hub**; **P3.8 backup export/import, app lock, reminders, crash reporting without content**; P3.10 Hijri dates alongside Gregorian and ultrasound dating; P3.9 owner checkpoint walk-through in Arabic (D-4); P4.1 legal pages; P4.2 Play Console listing, Data safety answer "health data not collected", Health apps declaration, 18+ audience, closed test; P4.3 soft launch; P4.4 iOS.

**Open items relevant to the site:** P2.4 (article template refresh: the commit exists only on the unmerged branch); P2.5 illustration set; P2.8 Lighthouse >= 95 mobile and LCP < 2.0 s, and retire the CMS project; P4.0 Arabic top-50 (Ramadan set first, due before ~8 Feb 2027); P4.0b reviewer bylines on the other 75 English guides; from the TODO: R3.7 (glossary and FAQ sections were empty yet promoted in nav and sitemap, status unknown today), R3.8 (library English-only, Arabic readers silently get English), P1.11.GSC (Search Console, optional per 27 Oct), P1.9.6 (`meet-femio` sources and SEO fields), P1.11.1 (Lighthouse/CWV budget), P1.6.11 and P1.6.12 (content QA in CI; surface review expiry), P0.12.4 (replace draft privacy/terms; folds into V1-08).

**TODO lines that now contradict a decision and should be marked `[DEPRECATED, approved <date>]` (owner's word needed, per the covenant):** R5.1-R5.3 (Flutter over a tier-1 endpoint, Supabase session on device), P0.12.5 (gate signup), P1.24 (20-50 user beta, replaced by the Play closed test and soft launch), P2.9 (community/forum, OD-8), P3.6 partner mode (D7), the messaging part of P1.21, P2.10 billing (deferred), P2.11 ads (the app has no ads SDK).

---

## 9. Smells, risks and stale text (concrete)

1. `CLAUDE.md:5-6` "What Femio is" and `CLAUDE.md:17` tech stack describe the web-first whole-life product; `CLAUDE.md:19-20` states "the backend owns decisions"; `CLAUDE.md:55` says "read STATE.md, then the TODO"; `CLAUDE.md:69-84` "Current status" and "Next up: Phase 1" are 20 days old. Every session reads this file first. (C-01 to C-04.)
2. `docs/30_REVAMP/00_README.md:18-19` says Android "Not started" and Play "via TWA". (C-05, C-06.)
3. `docs/30_REVAMP/03_REVAMP_PLAN.md:48-50` "OD-16 stands"; phases 3-4. (C-05, C-07, C-25.)
4. `docs/STATE.md:3` "Last updated 2026-10-07" and `docs/STATE.md:67` "Do not stop to summarise" versus the reset's proposed loop. (C-23, C-24.)
5. **D1-D6 live only in an archived file.** If that file is ever cleaned out, the wedge, markets, launch date and look lose their record. `OWNER_ACTIONS.md` points at it by path.
6. **Two Flutter builds in October** (the archived Codex app and `apps/mobile`) is the strongest evidence for the "one builder" rule; ADR-071 records the cost.
7. **Work not on `main`:** six commits on `origin/claude/epic-planck-5y8geb` (Checked). The live site is built from `main`, so audit fixes (Arabic links that 404'd, honest review labels) should not be live (from the docs; I did not check the live site). `STATE.md` still names that branch as the working branch.
8. **No way to measure retention** in an app with no analytics SDK, while monetisation and iOS are gated on retention (C-07). The Play Console's own aggregate install and uninstall figures are the only source the docs imply; no document says so.
9. **Legal exposure accepted by the owner, in his own words:** legal pages drafted by a session from the published laws, not a lawyer's opinion (02_SPEC section 4; OWNER_ACTIONS "Moved, not dropped"). The Egypt enforcement date (31 Oct 2026) and the claim that on-device storage removes most licensing duties are from `PRIVATE_LAUNCH_V1.md` and not verified by me (`[NEEDS SOURCE]` in this report; the Egypt lawyer skill could check them).
10. **Unencrypted private file today** versus an encrypted-store claim in the spec (C-08). The privacy promise on the website ("records stay on this phone") is true; "encrypted" must not be claimed until P3.8.
11. **A "single call to action: get the Android app"** that leads to "coming soon" until Play exists (C-30). Fine now; a risk if the launch date slips and the site keeps promising.
12. **Memory index mismatch:** the owner's saved memory lists `docs/STATE.md` as the resume pointer and says "personas are write-only today; R1 design -> R2 engine -> R3 depth", which is two product directions old. Not a project file, but it feeds new sessions.

---

## 10. Keep / rebuild / delete verdict, per document

Judged against the current direction: a private Android app (Flutter, records on the phone, no accounts), the website as a static teaser, no Supabase at runtime, wedge Arabic-first TTC to pregnancy with PCOS depth, Saudi + Egypt. Delete means "move to `docs/archive/` with a pointer", never destroy (the covenant).

| Document | Verdict | Reason |
|---|---|---|
| `CLAUDE.md` | **Rebuild (small edit)** | Apply `02_SPEC` section 5: product identity, "the specification owns decisions", read order, current status; move the ~4 KB of shadcn / ui-ux-pro-max trivia out; keep the six product rules, adding one sentence for C-35 and C-40 |
| `AGENTS.md` | Keep (delete the `00_WHERE_WE_ARE` mention) | Pointer file working as intended |
| `docs/STATE.md` | **Rebuild (rewrite in place)** | Re-date, replace the 402 and branch notes, keep the gate and traps (still valuable), apply the reset's loop once the owner approves it |
| `00_README.md` | Rebuild (10 lines) | Fix the three-launches table (C-05, C-06) |
| `03_REVAMP_PLAN.md` | Keep sections 1, 2.1, 2.2, 2.4, 2.5, 3; mark 2.3, 4, 5 phases 3-5 superseded | Strategy and design language are current |
| `04_ANDROID_APP_SPEC.md` | Keep | Newest product spec; add a line that storage is not yet encrypted |
| `PROGRESS.md` | Keep | The working ledger; update P4.0/P4.1 wording for the owner-only roles |
| `31_RESET/01_INVENTORY.md` | Keep as a dated snapshot | Honest and useful |
| `31_RESET/02_SPEC_V1_DRAFT.md` | **Decide**, then keep or fold into PROGRESS | It is the only place the launch dates and scope lock live; it is still a draft |
| `OWNER_ACTIONS.md` | Keep | Short and right; add a pointer to the archived D1-D8 text or restore the D1-D8 table in it |
| `archive/.../OWNER_ACTIONS_2026-10-07.md` | Keep in archive | Only home of D1-D6 text (until ADRs exist) |
| `DECISIONS.md` | Keep; add "amended by ADR-070" lines to 060 and 061; consider ADRs for D3 and D6 | Honest log; the order oddities are cosmetic |
| `24_REVAMP_PLAN.md` | Keep as reference; add a header note | Principles (rules as data, golden fixtures, no restriction field) are the on-device design too; the tier-1 mechanism is dormant |
| `22_APP_UI_ARCHITECTURE.md` | Keep for the closed tracker; header note | Do not use for the Flutter app; reusable rules (44px, logical properties, dates, motion) should be copied into an app UI note when the app UI is next touched |
| `14_SYSTEM_ARCHITECTURE.md` | Archive when Supabase is paused | Schema and RLS reference for the dormant backend |
| `12_BRAND_DESIGN_TOKENS.md` | **Rebuild** around section 7 of this report, or archive and let the CSS plus `03` section 3 be the spec | Its values are wrong; its logo rules and contrast method are right |
| `09_MASTER_ADAPTATION_MODEL.md` and the mermaid file | Keep the invariants; archive the rest with the closed tracker; delete the duplicate mermaid file (keep one) | Fix the EPDS label first (ADR-065) |
| `07_MASTER_TODO.md` | Keep as history; mark the lines in 8.4 `[DEPRECATED]` | Covenant: nothing is deleted |
| `CHANGELOG.md` | Rebuild | Cut a first real block for the Android pivot, mark web-tracker entries closed |
| `28_TEARDOWN/11_FINDINGS_LEDGER.md` | Keep | Evidence; mark OD-16 superseded |
| `29_REBUILD/*` | Archive | Superseded sequence; chapters 02-06 are specs for a closed product |

---

## 11. Open questions (for the owner or a deeper read)

1. **Approve `02_SPEC_V1_DRAFT.md`?** Specifically: the scope lock (section 2), what moves to v1.1 (section 3, including hiding menopause and postpartum goals, C-31), the dates (section 4), the five doc fixes (section 5), and the one-item-per-session loop (section 6, C-24). Until then nothing in it binds.
2. **Merge `origin/claude/epic-planck-5y8geb` into `main`?** Six commits, not reviewed by anyone in this study.
3. **Is the ADR-059 triage question really dropped for the app?** `04` says conditions are not asked at onboarding and that PCOS depth is reached by choice. OD-13 and the owner's August instruction pull the other way. A one-line owner confirmation would settle C-09.
4. **How will retention be measured** without an analytics SDK, given that iOS and pricing wait for it (C-07)?
5. **Which crisis entry does the Android app have?** ADR-013 says reachable everywhere; `04` does not mention it; P3.6 has a red-flag card only.
6. **Does the data store need to be encrypted before the closed test,** or is a private app-sandbox file acceptable for v1 (C-08)? This changes what the privacy policy may claim.
7. **Should D3, D5 and D6 become ADRs** so the decision log is complete (C-34)?
8. **OD-8 is a permanent "no chat".** May I mark P2.9 and the messaging parts of P1.21 `[DEPRECATED]`?
9. **Play Console account type.** The docs assume a personal account (12 testers x 14 days). An organisation account avoids that but needs a D-U-N-S number. Is the Femio / KM Digital Labs entity set up? `[NEEDS CHECK]`: I did not verify Google's current rules.
10. **Does the 9 Nov release candidate include the legal pages, articles and backup?** If any are cut, the launch date or the scope must move; 02_SPEC does not say which gives way first.
11. **Aurora and the "cinematic moments" on the phone:** are they in scope for v1, or web only (section 7.10)?
12. **Is the Fraunces "never below 22px" rule carried to Newsreader** (C-41)? And is the band's draw-in animation (archived brief) still wanted?
13. **Counts** (100 or 105 articles; 940 or 971 tests) should be re-measured once (C-22).
