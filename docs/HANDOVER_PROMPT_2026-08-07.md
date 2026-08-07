# Femio — handover (2026-08-07)

Read this, then `CLAUDE.md`, then `docs/07_MASTER_TODO.md`. Before writing any app UI,
read `docs/22_APP_UI_ARCHITECTURE.md` — it is the conventions doc for the tracker
screens and it exists so the next session does not re-derive them. Read
`docs/19_PROJECT_AUDIT_2026-08-06.md` for how the current priorities were set and
`docs/21_MOBILE_BUILD_TARGET_2026-08-06.md` for the architecture decision that governs
all tracker code.

## How to work here — read this first, it is not optional

**Build. Do not discuss.** The owner's instruction, verbatim: *"only talk if something
needed manual or info or decision but be short and to the point."* No progress
narration, no options essays, no philosophy. Do the work, run the gate, commit, and
report in a few lines. Speak up only when you need a decision, a credential, or a
manual step performed.

**Do not overcomplicate a simple task.** A previous session built scaffolding around a
one-line problem and was rightly pulled up for it. Match the size of the solution to the
size of the problem.

**Do not lose context.** Read the docs before proposing anything. The strategy,
personas, adaptation model and architecture are all written down. Most "new ideas" are
already decided in `docs/` — find the decision rather than re-inventing it.

**Small commits, conventional messages.** Update `DECISIONS.md` / `CHANGELOG.md` /
`07_MASTER_TODO.md` in the same change, but keep the ratio sane: an ADR is for a
decision that cost something or that a future session could reverse by accident — not
for every change.

---

## What Femio is, and what it is *for*

One account for a woman's **whole health life** — puberty → cycles → conditions →
trying to conceive/IVF → pregnancy → postpartum → perimenopause → menopause. Four
languages (EN/AR/FR/ES), Arabic RTL first-class.

**The point is not "a cycle tracker with extra screens."** The point is a **one-stop
app that is genuinely better than every competitor at each life stage and, uniquely,
across all of them.** That is why ~73 personas were specified in `docs/personas/` and
why `docs/09_MASTER_ADAPTATION_MODEL.md` exists. Those documents are the product
specification. Read them before designing any screen.

### Mobile is the destination. Web was the sketch.

The owner's words: the web app was chosen first **because it is easier and more
feasible to sketch**. The product is **Android and iOS**. Treat web as the fast way to
build and validate the real app — not as the deliverable.

**Consequence for prioritisation:** the public content site, the Payload CMS and SEO
are *support functions*. They exist to bring people to the app. Do not spend a session
on them. If you are deep in CMS tooling, you have drifted.

### The six product rules — these gate every feature

1. **Wellness, education and tracking only.** Never diagnose, treat, prevent disease or
   act as contraception. Keeps Femio out of medical-device regulation (FDA SaMD / EU
   MDR). Screeners are "a starting point to discuss with your clinician".
2. **Personalize, never restrict.** The UI adapts per life stage; every article and tool
   stays reachable from every mode.
3. **Uncertainty-honest predictions.** Ranges and confidence, never a single certain
   date, never a "late" counter in irregular modes.
4. **Privacy by design.** Health data is special-category. No ad or analytics SDK ever
   touches it; granular consent; export and delete; EU hosting.
5. **Constant EMR, additive layers.** One record spans a life. A life-stage change
   re-layers the UI over an unchanged core — it never rebuilds or deletes.
6. **Arabic/RTL is first-class** — but the logo wordmark is always English "femio".

Two worked examples of the standard to match, because prose about rules is cheaper than
either of these:

- **Menopause dashboard.** Reports *months since your last period* and states the
  twelve-month clinical convention, then stops — because the convention includes "with
  no other cause", and deciding which cause applies is diagnosis. The arithmetic is
  ours; the conclusion is hers and her clinician's.
- **Pregnancy movement log (ADR-049).** Deliberately *not* a count-to-ten kick counter.
  Femio's own reviewed article says there is no normal number and that reduced movement
  must not wait — so a target would give false reassurance to exactly the woman who
  should be phoning. No verdict column exists in the schema; the maternity-contact route
  is never gated behind finishing a count.

---

## The owner's assessment of the current state — take it at face value

> *"There is no app till now and the website sucks and the design is from first look AI
> generated and user experience sucks."*

He is not wrong, and this is the most important paragraph in this document.

What exists is a **working skeleton with weak design and shallow product depth**. The
engineering underneath is sound — tested, guarded, privacy-correct, and now genuinely
portable to mobile. What is missing is everything that would make a woman choose it over
Flo or Clue: **visual craft, interaction quality, and life-stage depth.**

Do not treat design as a polish pass at the end. It is a workstream, and it is behind.

---

## Verified state (2026-08-07)

**Live:** `femioapp.com` (web) and `femio-cms.vercel.app` (Payload CMS) on Vercel,
sharing a Supabase Postgres in the EU. 31 articles published with structured data.

**Architecture — settled, and it constrains everything you write (ADR-048):**

- Every tracker screen is **client-rendered and server-free**. `page.tsx` does only
  `generateMetadata` + `setRequestLocale`; the screen is a client component reading via
  `useSupabaseQuery`/`unwrap` (`lib/supabase/use-query.ts`); `AuthGate` replaces the
  server `redirect()`. **RLS is the security boundary**, not the gate.
- `pnpm native-readiness-lint` enforces this in CI. Baseline empty — it is a plain gate.
  No server Supabase reads, no `force-dynamic`, no Server Actions, no `searchParams`
  page props anywhere in the tracker path.
- The static export is **proven to run**: 41 pages, four locales, RTL intact, served as
  plain files with no Next runtime and driven with Playwright (`docs/20`, `docs/21`).
- **`trailingSlash: true` is required for the native build** (a default export emits
  `welcome.html`, so client routing 404s from the filesystem) and must be
  **native-only** — enabling it for web changes every public URL.
- Client i18n payload is split: root layout ships `PUBLIC_CLIENT_NAMESPACES`, the
  `(app)` layout adds `APP_CLIENT_NAMESPACES`. Add app strings freely; they no longer
  weigh on public pages.
- Target packaging shape, **decided but deliberately not executed**: `packages/core` +
  `packages/tracker`, `apps/web` + `apps/native`. Do it in Phase 4. Until then just obey
  the gate.

**Built and working:** onboarding wizard (4 life-stage modes); cycle tracking with
honest ranges and irregular mode; symptom logging with severity and custom entries; four
dashboards (cycle, TTC, pregnancy, menopause); full pregnancy lifecycle including
urgency-tiered symptom logging and ending a pregnancy; pregnancy movement log; export and
delete; offline IndexedDB queue; consent manager; staff MFA; k-anonymous insights; visit
summary; **Settings → "Your Femio experience"** to change life-stage mode or choose
General at any time.

**Owner manual tasks: none outstanding.** Migrations `0006` and `0007` are both applied
and verified.

---

## The three things that actually matter next

### 1. Design and UX — the named gap (currently untracked, start here)

The owner's first-look verdict is "AI generated" and "UX sucks". Before adding features,
fix what a woman sees in the first ten seconds.

- `docs/12_BRAND_DESIGN_TOKENS.md` is the token system; `assets/brand/tokens/` holds the
  canonical CSS/JSON/Tailwind preset; `assets/mockups/femio_personalized_screens.html`
  has the intended screens. The tokens are decent — the *application* of them is not.
- Study the competitors honestly (`docs/03_COMPETITOR_ANALYSIS.md`) and be specific
  about what Flo/Clue/Ovia do better visually and interactionally.
- Judge on a **phone viewport first**, not a desktop browser. This is a mobile product.
- Expect this to be several sessions. Track it in `07_MASTER_TODO.md` as a real
  workstream with subtasks before starting.

### 2. The persona/adaptation model — the biggest gap between the spec and the product

`P1.27.4`. The app maps 4 modes to 4 hardcoded personas (`B1/C1/D1/F1`) plus `Z1`. The
~73-persona resolver in `docs/09` §5 does not exist. `persona_state.confidence` and
`modifiers` columns exist and are unused. Also open: `P1.27.3` wizard re-entry, `P1.27.5`
Z1 progressive nearest-persona matching, `P1.27.6` composable modifiers + transition
graph, `P1.27.7` the wizard's "Skip / I'm not sure" → Z1 exit.

Without this, the personas were an expensive document rather than a product.

### 3. Phase 2 depth, in engagement order

Pregnancy week-by-week (**blocked on reviewed medical content — do not hand-write it**)
and the rest of P2.2 (contraction timer, weight, appointments — the `appointments` table
has existed since v1 and is still unused) → postpartum (P2.3, does not exist) → TTC
toolkit (P2.1, currently just a fertile-window estimate) → menopause depth (P2.4) →
pattern engine (P2.5, the stated differentiator, not built).

---

## Deferred by owner decision — do not treat as blocking

- **P0.12 legal** (entity, DPO, privacy/terms text). Everything is pre-gathered in
  `docs/compliance/P0_12_LEGAL_INTAKE_FORM.md`. One caveat recorded, not an objection:
  the trigger is the first real user, not incorporation — signup is open on a live
  domain, so gate it before outside testers (**P0.12.5**).
- **P0.22** — a medical reviewer must clear the 454 `[NEEDS SOURCE]` flags before any
  persona content goes user-facing.
- Localized slugs — decided against, slugs stay English (ADR-045).
- Billing, store compliance, community.

---

## The gate — run all of it before pushing

```
pnpm build && pnpm typecheck && pnpm lint
pnpm claims-lint && pnpm crisis-lint && pnpm analytics-lint
pnpm i18n-client-lint && pnpm content-lint && pnpm native-readiness-lint
pnpm i18n-untranslated-lint && pnpm tokens-parity-lint
pnpm test
CI=1 pnpm --filter web test:e2e:ci     # after a fresh build
```

## Environment traps that have each cost real time

- **`next dev` renders everything dynamically**, so a green local e2e proves nothing.
  Always run the CI-mode e2e after a fresh build.
- **Check the deployed thing.** Every serious defect in recent sessions was invisible
  from inside the build: an interactive migrate prompt, connection-pool exhaustion, a
  sitemap that silently emptied, articles 404ing during a CMS outage.
- **A loop that makes one network call per document** is an outage waiting for the
  collection to grow. It took the CMS down at 30 articles.
- **Editing the Tailwind preset alone does not invalidate Next's PostCSS cache.**
  `assets/brand/tokens/femio.tailwind.preset.js` is a workspace package, but the cache
  is keyed on the CSS entrypoint — change only the preset and `pnpm build` reports
  success while shipping the previous stylesheet. `rm -rf apps/web/.next/cache` first,
  then grep `.next/static/css` for the class you expect (ADR-054).
- **A Tailwind utility with no theme entry emits nothing — silently.** `rounded-round`
  looked fine in the source and produced square radio dots, because `--radius-round`
  was a token but was never mapped in the preset. If a token "doesn't work", check the
  preset's map before anything else.
- **The i18n catalogs are Prettier-formatted**, and some maps are on a single line.
  Insert keys as text; never re-serialise with `json.dumps` — it produces a 400-line
  reformat diff. Verify the file still parses after every edit.
- **`apps/cms/.env.local` holds the PRODUCTION connection string.** Any local migrate
  touches live data.
- **Windows:** `pkill` does not kill `next start`; kill by port.
- `07_MASTER_TODO.md` has some stale entries (e.g. P1.11.2 is done but still shows
  open). Trust `DECISIONS.md` and `CHANGELOG.md` where they conflict.

## Verification honesty

Guards have caught real errors in this project's own work, repeatedly — including a
claim in a handover doc that was based on a grep run over an already-modified tree, and
a page-weight regression on the SEO-critical `/learn` page that would have been hidden by
raising the budget. **Watch a new guard fail before trusting it.** Prefer assertions that
break loudly over ones that can silently pass. When a guard fails, fix the code — do not
narrow the rule.

## First action

No plan document, no options memo. Pick up the design/UX workstream: add it to
`07_MASTER_TODO.md` with concrete subtasks, then start on the highest-impact screen.
Report in a few lines when there is something to see.
