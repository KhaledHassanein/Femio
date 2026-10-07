# 23 — Strategic review (2026-08-09)

**Commissioned by Khaled**, in his words: *"I feel VS Code chat with Claude there messed the
project after thorough planning… please advise, criticise, plan."* Alongside it he restated
the original intent, and the restatement matters more than the complaint, so it is recorded
verbatim in §1.

**Scope of the read:** `CLAUDE.md`, all 30 top-level docs, `docs/compliance/`, the 265-line
`07_MASTER_TODO.md`, the audit and handover chain, the 989-line SQL schema, and a
representative slice of the ~12,900 lines under `apps/web/src` — the persona resolver,
signals and state modules, the dashboard, settings, navigation, the token layer, the eight CI
guards and the four message catalogs — plus the live site at `femioapp.com`.

**Answer up front, because it is not the one that was expected:**

> **The project was not damaged.** 184 conventional commits, a coherent history, no abandoned
> rewrites, no half-migrations, nothing overwritten. The engineering underneath is better than
> most funded seed-stage health products.
>
> **Three real things went wrong, and none of them is "a tool broke it":** work drifted into
> CMS/SEO/governance for roughly two weeks; the documentation grew faster than the product;
> and — the one that actually matters — **the personalization engine was specified in extreme
> detail and never built**, so the 73-persona pack that is Femio's entire reason to exist is
> currently an expensive document rather than a product.

Khaled's instinct that something is wrong is correct. The diagnosis is different from the fear.

---

## 1. The original intent, restated by the owner (2026-08-08)

Recorded because every judgment below is measured against it, not against the docs:

1. A **female companion through any stage and condition**, menarche → menopause, including
   pregnancy and everything between.
2. A **welcome wizard** that identifies the persona — or **General** when no defined persona
   fits.
3. **70+ personas**, each getting a personalized experience: *"having all features like the
   general one but priority and the way the app features are presented and shown personalized
   to what she needs at the given time"* — with the ability to **move persona** (TTC → pregnant),
   **re-run the wizard**, or **change manually**.
4. A **complete, flexible app** with deep settings controlling everything from themes to
   functions.
5. A **web app on a shared backend**, that backend also serving **Flutter Android/iOS apps**.
   *"The web is not a priority (actually mobile is priority) but web is easier to develop and
   audit and test by you, so it is like a sketch and added value later."* **Android first.**

Point 3 is the product. Point 5 contradicts what the repository has decided; §5 resolves it.

---

## 2. What is genuinely good — and must survive any revamp

**The six product rules are enforced by machines, not by memory.** Eight guards run in CI —
`claims-lint`, `crisis-lint`, `analytics-lint`, `content-lint`, `i18n-client-lint`,
`i18n-untranslated-lint`, `tokens-parity-lint`, `native-readiness-lint` — plus `rls-audit`
against the live database and `sitemap-check` against production. Each was watched failing
before it was trusted. This is why the medical-device boundary has held for six months without
anyone policing it by hand, and it is the single most valuable non-obvious asset in the repo.

**Privacy engineering is real, not claimed.** Owner-only RLS proven by an automated audit that
attempts the escalations; an append-only consent ledger where withdrawal stamps the grant *and*
appends a revocation, because the ledger is evidence; k-anonymity with **secondary** suppression
after the first validation run proved primary suppression alone leaks by arithmetic; Sentry
normalised to route patterns so a URL cannot become a health disclosure; a deny-by-default
analytics sanitizer that blocks properties future SDK versions have not invented yet; and a
non-EU ingest host that **fails the build**.

**The medical judgment is the best thing here.** Three decisions are worth naming because they
are what separates this from a tracker with a health skin:

- Menopause reports *months since your last period* and states the twelve-month convention,
  then stops — because the convention includes "with no other cause", and choosing the cause is
  diagnosis.
- The movement log is deliberately **not** a count-to-ten kick counter. There is no target, and
  no `result` column exists anywhere in the schema, because a target would give false
  reassurance to exactly the woman who should be phoning.
- Pregnancy symptoms are urgency-tiered, the urgent entry still saves, and the maternity-contact
  route is never gated behind finishing anything.

**The schema is ahead of the application.** 23 tables spanning a life — `labs`, `vitals`,
`fertility_logs`, `appointments`, `screener_results`, `partner_links`, `subscriptions`,
`key_dates`. Phase 2 is almost entirely application work, which is the cheap kind.

**Content and SEO are a genuine acquisition asset.** 31 cited, clinician-approved articles
live with structured data; a sitemap that now carries 99 URLs including 26 articles and 5
conditions (verified live, 2026-08-09); FAQPage extraction that works in Arabic punctuation.

**Arabic is translated — correcting a stale claim.** `docs/19_PROJECT_AUDIT_2026-08-06.md` §4
states "every Arabic string is currently an English placeholder". Measured over the catalogs on
2026-08-09: of 698 leaf values, **AR differs from EN in 694 (99%)**, FR in 677 (97%), ES in 687
(98%). The catalogs are translated. What is missing is **human review**, which is a different
and smaller task (P1.19.3, P1.26.2). The crisis copy is the real exception and is correctly
gated to the EN fallback by design.

**The code explains itself.** Comments state *why*, including why an obvious alternative was
rejected. A session can resume here cold, which is not true of most codebases this size.

---

## 3. What is wrong, ranked by cost

### 3.1 The persona engine is write-only — this is the core failure

`lib/persona/resolver.ts` is well built: hard gates, weighted signals, Z1 as a first-class
answer, and a result type that structurally *cannot* express restriction. It runs exactly once,
at onboarding (`lib/onboarding/complete.ts`), writes `persona_id`, `modifiers` and
`emotional_context` into `persona_state` — **and nothing in the application ever reads them
back.**

Every screen reads one column. `dashboard-screen.tsx`, `track-screen.tsx` and
`summary-screen.tsx` all select `persona_state.track` and pass it through `TRACK_TO_MODE` in
`lib/persona/state.ts`, which knows five entries:

```
B → cycle    C → ttc    D → pregnancy    F → menopause    Z → general
```

Four consequences follow, and together they are why the persona pack has not become a product:

- **Tracks A (adolescent) and E (postpartum) have no mode at all.** They are absent from the
  map, so they fall through to `general`. The resolver can return A2, E1 or E6 — and the UI
  cannot change a single pixel in response. Two of the six life-stage tracks are unreachable.
- **The five outputs the specification names do not exist.** `docs/09` §2 defines the state
  object as driving home config, surfaced tools/logs, content-library skin, alert logic and EMR
  view. None of the five exists as a layer. Personalization today is a `mode ===` comparison
  inside a React component, so **adding persona #6 means editing `dashboard-screen.tsx`.** That
  is not a route to 73.
- **`modifiers` and `emotionalContext` are dead on arrival.** The resolver computes
  `pregnancy_after_loss`, `irregular_cycles`, `prior_loss`, `waiting` and each recorded
  condition — the exact inputs invariant 7 (emotional safety) needs — and writes them to a
  column no screen consults. Grief-aware tone is specified, computed, stored, and never applied.
- **The two writers of `persona_state` disagree.** Onboarding writes the resolver's answer;
  `switchMode` in Settings writes `personaIdFromMode(next)` — the track's *first* persona,
  B1/C1/D1/F1/Z1 — leaving the resolver's `confidence` and `modifiers` behind as stale values
  describing a persona that is no longer stored. Nothing is corrupted, but the record now
  contains two disagreeing accounts of who she is.

ADR-058 diagnosed the *input* half of this correctly and honestly: only 15 personas have rules
because the wizard asks one question of six, and nothing writes `conditions_flagged`. That
diagnosis is right and the fix (P1.27.8) is underway. It is only half the problem. Even the 15
that resolve collapse into 4 modes on screen, so widening the wizard alone would produce a
better-informed resolution that still changes nothing a user can see.

**Cost of leaving it:** every Phase 2 feature written against `mode ===` has to be rewritten
when the engine lands. This is the same shape of mistake P4.0 was run to avoid — and it is
larger, because Phase 2 is where most of the app gets written.

### 3.2 Product depth is one stage deep

Measured by what the tables know versus what the app does. `appointments`, `fertility_logs`,
`screener_results` and `vitals` appear in exactly one file each — `lib/account/export-data.ts`,
the GDPR export list. There is **no write path and no read path** for any of them anywhere in
`apps/web/src`. `partner_links` and `content_history` appear nowhere at all.

| Promised in `docs/05` | State today |
|---|---|
| TTC toolkit (BBT, OPK, cervical mucus) | a fertile-window estimate; `fertility_logs` unused |
| Pregnancy week-by-week, contraction timer, weight, appointments | movement log only; `appointments` unused since v1 |
| Postpartum mode (recovery, EPDS, feeding/sleep) | does not exist — Track E has no mode |
| Menopause depth (34-symptom set, MRS, HRT log) | months-since count + a symptom filter |
| Pattern engine — *the stated differentiator* | not built |
| Validated screeners (PHQ-9, GAD-7, EPDS, DRSP, PBAC) | not built; `screener_results` unused |
| Notifications | none — no reason to return between sessions |
| Billing / Pro tier | none; `subscriptions` unused |

This — not the CMS — is the gap a woman comparing Femio to Flo would feel in ten seconds.

### 3.3 Design is thin, and there is no design source of truth

The **token layer is fine**: 159 semantic custom properties, AA-verified in both themes, a
Tailwind preset with a parity guard that fails the build when a token has no utility. The
recent P1.28 work is competent and genuinely mobile-first — a bottom tab bar, 44px targets,
logical properties for RTL, reduced motion enforced globally, a hero card that leads with the
answer.

The **composition is not**. Verified live on a 375px viewport, 2026-08-09: the homepage is a
hero sentence followed by five visually identical link cards — Learn, Conditions, Calculators,
FAQ, Glossary. That is a sitemap with a headline on top. There is no product proof, no screen
imagery, no differentiation, no reason to trust it, and nothing that speaks to a specific woman
in a specific stage. Inside the app: three tabs, cards of equal visual weight, a 2px band as
the only data visualisation in the entire product, no illustration, no photography, no motion
identity, no empty state with any personality. **Nothing anywhere says "this was built for
me"** — which is precisely the promise.

Underneath the symptom is a process defect: **there is no design source of truth.** Figma was
deferred at P0.20c; the Phase-0.5 HTML mockups (`assets/mockups/`) were never fully built and
are now a year of decisions behind; so every session re-derives visual choices from the token
file. `docs/22` is an excellent *code conventions* document and is doing a job design should be
doing.

The owner's verdict — *"the design is from first look AI generated and user experience sucks"*
— is fair, and the reason is that no one has ever designed a Femio screen. They have been
assembled from primitives, one ADR at a time.

### 3.4 The mobile plan is unresolved, and is currently taxing the web product

`docs/06`, `ADR-048` and `docs/21` decide a **Capacitor wrap of this Next.js codebase**;
`docs/06` explicitly rejects Flutter. The owner says the destination is **Flutter**, Android
first. These are not reconcilable, and one of them is governing the code today:
`native-readiness-lint` forbids server-side reads, `force-dynamic`, Server Actions and
`searchParams` anywhere in the tracker path.

That guard is well built and was correct under its own premise. Under the owner's stated premise
— **web is also a real product**, answered 2026-08-08 — it inverts: the web app pays a permanent
cost (browser-side request waterfalls on every tracker screen, a larger client bundle, no server
rendering available even where it would help) to buy a mobile path the owner may not take. §5
resolves this.

### 3.5 Governance has outgrown its usefulness

A 265-line `MASTER_TODO` whose entries are paragraph-length post-mortems — some over 700 words.
59 ADRs. Seven dated handover documents. A handover that instructs the reader to *"trust
DECISIONS.md and CHANGELOG.md where they conflict"*, which is an admission that the single
source of truth is no longer true. The 2026-08-06 audit measured 46 documentation touches
against 40 application touches in one session.

The covenant that produced this ("every task gets a line the moment it is identified; nothing is
silently dropped") is **right and should be kept**. What broke is that the queue and the archive
were never separated, so the document that is supposed to answer *"what do I do next?"* now
takes twenty minutes to read. That is a real form of "the project got messed up" — just not the
form that was feared, and it is cheap to fix.

### 3.6 Zero real users

P1.24 has not started. Every quality judgment in this document, including the owner's, is
internal. Signup is open on a live domain while legal is deliberately deferred; P0.12.5 — the
cheap gate before outside testers — is still open. **The single highest-information action
available to this project is putting it in front of ten women**, and it has been available for
weeks.

### 3.7 Loose ends — list them, do not agonise

`meet-femio`, the first article a reader is likely to land on, has no sources and no SEO fields
(P1.9.6). `/{locale}/admin` returns **404** (verified live) while `/admin/insights` works.
PWA icons are SVG-only. AR/FR/ES crisis copy still renders the EN fallback pending linguistic
sign-off. The reviewer bio is blocked on credentials the owner has not supplied (P1.9.7), which
blocks bylines on all 30 imported drafts (P1.9.8).

---

## 4. So did the previous sessions "mess it up"?

No — and the distinction matters for how to proceed.

**What the evidence shows:** every commit is conventional, scoped and documented; every
significant decision has an ADR; several ADRs record the session's *own* errors and correct them
(ADR-034 on unbounded override ranges, ADR-044 reversing its own earlier advice about the
connection pooler, ADR-046 on a sitemap that silently emptied, ADR-058 correcting ADR-057's
reasoning with counts). A codebase where the record of mistakes is this legible is not a
mismanaged one.

**What actually happened** is that the work optimised for the thing that was measurable —
guards, coverage, compliance, articles published, advisories cleared — and those are all
genuinely valuable, but none of them is the product. Meanwhile the one thing that is the product
(persona-driven experience) had no test that could fail and no guard that could catch its
absence, so it stayed a document while everything around it was hardened. **The verification
culture that is this project's greatest strength also chose its priorities**, because what can
be verified gets built.

That is the lesson to carry forward, and it is why §5's recommendation puts the persona engine
behind a contract with tests — so that from now on, its absence *can* fail.

---

## 5. The mobile decision, and why it is the same decision as the persona engine

The owner asked for a recommendation rather than a choice. It is:

> **Flutter for Android and iOS — but not until the domain logic stops living inside the web
> client.**

**The framework is the second question.** The first is *where decisions get made*. With two
first-class clients, two independent implementations of cycle prediction, urgency tiers, red-flag
thresholds and persona resolution is a **safety** problem, not a code-duplication problem: drift
means one client tells a pregnant woman something the other does not, and nothing in either
codebase would notice. So the architecture must be **the backend owns decisions; clients render
them.**

Once that is true, the mobile framework becomes a UI choice rather than a rewrite — and Flutter
wins on native feel, offline behaviour, push, App Store 4.2 exposure, and it matches both the
owner's stated intent and his V1 Flutter experience (367 Dart files, `docs/01`). If instead the
logic stays in the client, Capacitor wins by default, and the result is a webview app competing
against Flo on feel — a fight it loses.

**The seam, in three tiers** (detailed in `docs/24`):

| Tier | Lives | Holds | Why there |
|---|---|---|---|
| 1 — Decisions | Supabase Edge Functions, TypeScript, reusing today's code **verbatim** | persona resolution, home configuration, alert and red-flag sets, content skin, screener scoring | one implementation of anything medical; Flutter never re-implements medicine |
| 2 — Offline math | twin TS + Dart implementations bound by **shared golden JSON fixtures both must pass in CI** | cycle prediction windows, gestational age, calendar geometry (~900 of the current 2,425 domain lines) | must run instantly and offline; drift prevented mechanically, not by discipline |
| 3 — Rendering | each client | UI, i18n, navigation, offline queue | genuinely per-platform |

**Tier 1's output is a versioned `ExperienceConfig` document** — hero, ordered module list,
surfaced trackers, pinned tools, alert set, content skin, tone — cached on the device so it works
offline. **That document *is* the persona presentation layer.** Personas become data instead of
code; the five outputs of `docs/09` §2 finally exist; and one mechanism answers both open
questions at once. It is the highest-leverage change available to this project.

**What this retires, explicitly:** ADR-048's packaging plan (`packages/tracker`, `apps/native`).
`native-readiness-lint` is *repointed* rather than deleted — from "no server reads in the
tracker", which now contradicts the architecture, to "no medical decision logic inside a client
component", which is the constraint that actually protects the product. The P4.0 work is not
wasted: client-side reads and `AuthGate` are good on their own merits, and the static-export
proof is knowledge worth having and cheap to keep.

---

## 6. Recommended order from here

Sequenced so each step ships something and makes the next one cheaper. Tracked as workstreams
R1–R6 in `07_MASTER_TODO.md`; the architecture is `docs/24`, the design brief is `docs/25`.

1. **R1 — Design direction, before another screen is built.** An honest competitor teardown at
   390px, a designed reference set on the existing tokens, owner approval, *then* implementation
   starting with the public homepage and the app shell. Several sessions. This is the named gap
   and nothing else should jump it.
2. **R2 — The `ExperienceConfig` engine, proven end-to-end on pregnancy.** D1/D2/D3/D4/D7 plus
   the thyroid, prior-loss and diabetes modifiers, including the flagship C8→D7 transition from
   `docs/09` §9. One stage, all the way through.
3. **R3 — Depth per stage, riding the engine.** Pregnancy week-by-week (blocked on reviewed
   content — do not hand-write it), appointments, weight → **postpartum, which does not exist
   today** → TTC toolkit → menopause depth → validated screeners wired to the crisis layer that
   is already built. Wizard Q2–Q6 land here, taking persona coverage from 15 toward ~57.
4. **R4 — Pattern engine and notifications.** The differentiator; it needs data volume, so it
   follows depth. Notifications are the first real reason to return between sessions.
5. **R5 — Flutter Android**, then iOS. By then it is tier-3 work: UI, auth on device (the open
   P4.0.5 unknown), push, biometric lock, store compliance.
6. **R6 — Beta with real users** (gate signup first, P0.12.5), then legal and entity, then
   revenue.

Continuous alongside: human Arabic review, medical review at publish, the eight guards, and
content only in small batches between app work.

---

## 7. The three things to stop doing

1. **Stop treating design as a polish pass.** It is a workstream, it is behind, and it is the
   first thing a user judges. `docs/25` makes it tracked work.
2. **Stop writing a post-mortem into the task queue.** Keep the covenant, split the archive.
   An ADR is for a decision that cost something or that a future session could reverse by
   accident; a commit message is for everything else.
3. **Stop building against `mode ===`.** Every screen written that way before R2 is a screen
   that gets rewritten after it.
