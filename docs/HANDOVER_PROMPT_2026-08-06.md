# Resume prompt — paste this whole file into a new chat

---

You are continuing work on **Femio**. Read `CLAUDE.md`, then
`docs/19_PROJECT_AUDIT_2026-08-06.md` (the audit that set the current priorities), then
`docs/07_MASTER_TODO.md`. `docs/HANDOVER_STATE_2026-08-04.md` still holds useful
environment detail but its "what's next" is superseded by the audit.

## What Femio is — hold this, it decides most judgement calls

Femio is a **women's health app**: one account for a woman's whole health life — puberty →
cycles → conditions → trying to conceive/IVF → pregnancy → postpartum → perimenopause →
menopause. It is **cross-platform by design**: a web app today, with iOS and Android
shipping from the same codebase via Capacitor (Phase 4). Four languages (EN/AR/FR/ES) with
Arabic RTL as a first-class experience, not an afterthought.

**The app is the product.** There is also a public content library (31 published articles)
which is the SEO and acquisition engine, and a Payload CMS behind it. Those exist to bring
people to the app. The owner has said this explicitly and it is the single most important
piece of context in this document:

> *"We are doing very much for content and CMS rather than the app... I need to build the
> app we are making all this for in the first place."*

**If you find yourself three hours into CMS tooling, you have drifted.** Content work
happens when it blocks something, or in small batches between app work.

### The six product rules — these gate every feature

1. **Wellness, education and tracking only.** Never diagnose, treat, prevent disease, or
   act as contraception. This is what keeps Femio out of medical-device regulation
   (FDA SaMD / EU MDR). Screeners are "a starting point to discuss with your clinician".
2. **Personalize, never restrict.** The UI adapts per life stage; every article and tool
   stays reachable.
3. **Uncertainty-honest predictions.** Ranges and confidence, never a single certain date,
   never a "late" counter in irregular modes.
4. **Privacy by design.** Health data is special-category. No ad or analytics SDK ever
   touches it; explicit granular consent; export and delete; EU hosting.
5. **Constant EMR, additive layers.** One record spans a life. A life-stage change
   re-layers the UI over an unchanged core — it never rebuilds or deletes.
6. **Arabic/RTL is first-class** — but the logo wordmark is always English "femio".

A worked example of rules 1 and 3 in practice, because it is the standard to match: the
menopause dashboard reports *months since your last period* and states the twelve-month
clinical convention, then stops — because the convention includes "with no other cause",
and deciding which cause applies is diagnosis. The arithmetic is ours; the conclusion is
hers and her clinician's.

## Where things actually stand

**Live and working.** `femioapp.com` (web) and `femio-cms.vercel.app` (Payload CMS), both
on Vercel, sharing a Supabase Postgres in the EU. 31 articles published, in the sitemap,
with Article/MedicalWebPage/BreadcrumbList/FAQPage structured data.

**The app (Phase 1 MVP — essentially complete).** Onboarding across four life-stage modes;
cycle tracking with honest ranges and an irregular mode; symptom logging with severity and
custom entries; **four real dashboards** (cycle, TTC, pregnancy, menopause); a full
pregnancy lifecycle (due date → weeks/trimester → urgency-tiered symptom logging → ending
a pregnancy for birth, loss or other); export and delete; offline logging via an IndexedDB
queue; consent manager; staff MFA; k-anonymous insights; visit summary.

**Phase 2 has not started, and Phase 2 is where the product actually lives** — TTC toolkit,
pregnancy week-by-week and kick counter, postpartum, menopause depth, the pattern engine,
validated screeners, notifications, billing.

## Start here — the audit's top finding, and it is architectural

**Every screen of the tracker is a server-rendered React Server Component that reads the
database on the server** (`force-dynamic` + `createClient()` from `lib/supabase/server` on
`/dashboard`, `/track`, `/settings`, `/summary`).

**Capacitor has no server.** It ships a static bundle to the device. So the Phase 4 plan —
"wrap the same codebase for iOS and Android" — cannot run as the app is currently built.
This has never surfaced because nothing has tried to build for mobile yet.

**Do this first, before Phase 2 features:** take `/track` and `/dashboard` and convert them
to client-side data fetching against Supabase (the offline sync layer already talks to
Supabase from the browser, so the pattern exists), then confirm offline sync still behaves.
It is a small, reversible experiment. It answers whether the cross-platform plan holds, and
every server component added to the tracker before it makes the answer more expensive.

Three possible outcomes, in the audit: webview onto the live URL (cheap, risks Apple 4.2
rejection, no offline), static export (effectively a rewrite), or a client-rendered app
shell with the public content site staying server-rendered (the honest middle path).

After that, Phase 2 in engagement order: pregnancy week-by-week and kick counter →
postpartum → TTC toolkit → menopause depth → pattern engine.

## Immediately available smaller work

- **P1.13d remainder:** the `appointments` table has existed since schema v1 and is
  completely unused. Natural next pregnancy feature (visit dates, questions to ask, results
  due) and it feeds the existing visit-summary export.
- **P1.9.6:** `meet-femio` — the one hand-entered article — has no sources and no SEO
  fields. It is the page a first-time reader most likely lands on.
- **P1.9b.3d:** `/{locale}/admin` 404s. `/admin/insights` and `/admin/translations` exist
  but there is no index. The owner hit this.
- **P1.2.3:** no component/render tests. The four dashboards have well-tested logic and
  zero rendering coverage, so a broken layout would not fail CI.

## Deferred by owner decision — do not treat these as blocking

- **P0.12 legal** (entity, DPO, privacy/terms text). The owner will incorporate once the
  product is worth it. Everything needed is pre-gathered in
  `docs/compliance/P0_12_LEGAL_INTAKE_FORM.md`. **One caveat recorded, not an objection:**
  the trigger is not the company, it is the first real user — signup is open on a live
  domain, so gate it before outside testers (P0.12.5).
- **Localized slugs** — decided: slugs stay English in all four locales (ADR-045).
  `docs/16` §5 is superseded and marked as such.
- Billing, store compliance, community.

## How to work here

Small commits with conventional messages. Update `DECISIONS.md` / `CHANGELOG.md` /
`07_MASTER_TODO.md` in the same change — **but keep the ratio sane**: an ADR is for a
decision that cost something or that a future session could reverse by accident, not for
every change. The audit flagged governance overhead as real.

Before pushing: `pnpm build`, `pnpm typecheck`, `pnpm lint`, the five guards
(`claims-lint`, `crisis-lint`, `analytics-lint`, `i18n-client-lint`, `content-lint`),
`pnpm test`, and **`CI=1 pnpm --filter web test:e2e:ci`** after a fresh build.

### Environment traps that have each cost real time

- **`next dev` renders everything dynamically**, so a green local e2e run proves nothing
  about production. Always run the CI-mode e2e. This gap hid a 500-instead-of-404 on every
  unknown content URL for weeks.
- **Check the deployed thing.** Every serious defect in the last session was invisible from
  inside the build: an interactive migrate prompt, connection-pool exhaustion, a sitemap
  that silently emptied, articles 404ing during a CMS outage. The guards that caught real
  problems were the ones pointed at production (`pnpm sitemap-check`).
- **A loop that makes one network call per document is an outage waiting for the collection
  to grow.** It took the CMS down at 30 articles.
- **Killing a `payload` command's shell leaves the node child alive holding a DB
  connection.** Check for orphans when a CMS script fails on an unrelated-looking query.
- **The i18n catalogs are Prettier-formatted.** Insert keys as text; re-serialising with
  `json.dumps` produces a 400-line reformat diff.
- **`apps/cms/.env.local` holds the PRODUCTION connection string.** Any local migrate
  touches live data.
- **Windows:** `pkill` does not kill `next start`; kill by port.

### Verification honesty

Two mistakes last session came from tests that told me what I expected rather than what was
true: a `.get('docs', [])` that returned `[]` from an *error* response and looked like a
clean result, and a pool setting justified by confident reasoning that was never checked
against the deployed API. **Watch a new guard fail before trusting it**, and prefer
assertions that would break loudly over ones that can silently pass.

## First message to send back

A short plan for the mobile-path experiment (`/track` and `/dashboard` client-side), plus
anything in the audit you disagree with — the owner values being told when a premise is
wrong more than being agreed with.
