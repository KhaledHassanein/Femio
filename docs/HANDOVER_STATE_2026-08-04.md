# Femio — Session State & Handover (2026-08-04)

Supersedes `HANDOVER_STATE_2026-07-30.md`. Read this + `CLAUDE.md` +
`docs/07_MASTER_TODO.md` + `docs/runbooks/OWNER_MANUAL_TASKS.md` first.

## TL;DR

Femio is live on Vercel (EU): a content-first public site (`femio-web.vercel.app`,
domain `femioapp.com` purchased, **not yet connected**) with the tracker app as its
portal, plus a Payload CMS on the shared Supabase Postgres. Since the last handover the
security pass finished (audit at **0 advisories**, CSP/headers, staff MFA, Sentry,
analytics), the content pipeline was commissioned, and **31 article drafts** have arrived
from the content assistant.

**Two things are mid-flight and need attention first — see "Start here".**

## Start here (in this order)

1. **Schema is APPLIED — verified 2026-08-04.** `payload.payload_migrations` contains both
   `20260803_123841_baseline_existing_schema` and `20260803_123901_p1_6_6_publishing_fields`;
   `payload.articles_rels` and `articles.first_published_at` exist; `/api/articles` and
   `/api/conditions` both return 200. Nothing to repair.
2. **`payload migrate` blocks on an interactive prompt — solved (ADR-030).** Two earlier
   readings of this were wrong and are superseded: it is neither "does not complete in this
   setup" (`685d25f`) nor "completes its work but never exits" (the first version of this
   section). It waits for someone to type `y`. `@payloadcms/drizzle`'s `migrate()` calls
   `prompts()` unconditionally whenever `payload.payload_migrations` holds a row with
   `batch = -1` — the `dev` row left from the push-mode era (ADR-018) — and asks *"It looks
   like you've run Payload in dev mode… data loss will occur. Would you like to proceed?"*
   A build has no one to answer, so it waits; **45 minutes was Vercel's timeout, not
   Payload's runtime.**
   The evidence, in order: `migrate:status` at 08:52 showed both migrations **`No`**; a plain
   `migrate` at 08:53 printed the prompt, emitted no migration output, and was still blocked
   at 300s; with `y` piped in at 09:13 both applied in **under two seconds and the process
   exited 0**; `migrate:status` at 09:14 showed both `Yes`, batch 1. So the migrations had
   *not* applied before the prompt was answered, and the process *did* exit once it was —
   which is what rules out the non-exit theory. (The schema looked applied to a session
   checking at 09:14 because it had been written at 09:13.)
   → Use **`pnpm --filter cms migrate:apply`** (`apps/cms/scripts/migrate-apply.mjs`), which
   answers the prompt and explains why that is safe here. Read the migration's `up()` first,
   per ADR-029 — both current ones are purely additive, every `DROP` is in `down()`.
   → **Trap:** `--force-accept-warning` looks like the fix and is not. Payload's CLI forwards
   it only to `migrate:create` and `migrate:fresh`, never to plain `migrate`.
   → **Permanent fix, needs an owner decision** (it writes to production): delete the
   `batch = -1` row. After that plain `payload migrate` is non-interactive and
   `migrate-on-deploy.mjs` could safely go back into the deploy. Until then the CMS build
   stays plain `next build` (`685d25f` — the right call, for a reason it didn't have yet).
3. **Confirm one clean CMS deploy** (~60s, not 45 minutes). The deployed code carries
   `publishing: true` and the schema now matches it. If `/api/articles` 500s afterwards,
   something else is wrong — the schema is no longer the suspect.
4. **`NEXT_PUBLIC_APP_URL` may still be queued.** At handover the live site still advertised
   `https://femio-web.vercel.app` as canonical/og:url/sitemap host while serving on
   `femioapp.com` (the old host does 308-redirect correctly). Check after the queue drains:
   ```bash
   curl -s https://femioapp.com/en | grep -o 'rel="canonical" href="[^"]*"'
   ```
   Want `https://femioapp.com/en`. Then Google Search Console: Domain property, DNS TXT,
   submit `sitemap.xml`.
5. **P1.9.1 and P1.9.2 are done** (ADR-031) — see "Open" below for what is next.

## Done since 2026-07-30 (lead commits)

- **P1.9b.3a/b** privacy + terms as marked drafts (ADR-015); author/reviewer bio pages
  with Person schema (ADR-016).
- **P1.6.4/C3.7** CMS admin bootstrap script — no admin existed, publishing was impossible
  (ADR-018). **P1.20.2** consent manager; **P1.20.3** first-party k-anonymous insights
  dashboard with secondary suppression (ADR-020, migration 0006 applied).
- **P1.23.1** dependency ratchet + security headers (ADR-021) — and the **500-instead-of-404**
  fix on every unknown content URL, plus the localized 404 (P1.2.2).
- **P1.23.2** next-intl v3→v4 (ADR-022) — audit now **0 advisories**. Tested and disproved
  that v4 fixes `notFound()` under ISR, so the three CMS detail routes stay `force-dynamic`
  (P1.23.2b).
- **P1.23.3** staff MFA, enforced on `/admin/*` (ADR-023) + **P1.23.3b** recovery script;
  **P1.2.4** global-error boundary (ADR-024).
- **P1.20.1/P1.20.4** PostHog wired and emitting (ADR-025, ADR-027) — URL stripped from
  every event; the page declares its area as a literal so no code path turns a path into an
  event. **P1.4.2** Sentry (ADR-026) — route patterns, no bodies/user/extra, EU-only DSN.
- **P1.6.6** public bylines + SEO fields; **P1.6.5/P1.6.6b** Payload **migrations adopted**
  after those fields took production down for ~1h (ADR-029 — read it, the lesson is about
  verification, not Payload).
- **ADR-028** health-not-medical positioning (owner direction): decorative "medical"
  framing → clinician-framed; disclaimers keep the word verbatim; boundary line moved above
  the article body.
- **P1.9** commissioned: `docs/content/CODEX_AUTHORING_BRIEF.md` is the assistant's working
  prompt. **31 drafts** now in `docs/content/articles/`.

## Open, in recommended order

1. **Run the import** (`pnpm content-import -- --apply`). Everything is built and the guard
   is green; nobody has written the 31 drafts into the CMS yet. Dry run first — it is the
   default. Then create the `medical_reviewer` account (**P1.9.0**), because an `admin`
   self-approving satisfies the software gate but not doc 15's independent-review intent.
2. **The remaining 29 articles** from the content assistant (31 of 60 delivered). The guard
   now runs on delivery, so a correction round is a command rather than a reading session.
3. **P1.11.1 CWV/Lighthouse budget in CI** and **P1.11.2** trimming the i18n payload (every
   page ships the whole locale catalog; `/en/learn` was ~56 KB and embedded privacy/terms
   copy it never renders).
4. **P1.6.7–P1.6.13** — the CMS/SEO recommendations, incl. publication-gate hardening
   (needs a health/marketing content split first) and review-expiry surfacing.
5. Optional follow-ups the content work surfaced: wire `content-lint` into CI beside the
   other three guards, and consider whether the **PMDD pillar** should name premenstrual
   suicidal ideation explicitly — see "For the clinician" below.

## Batch 1–3 review (31 drafts, 2026-08-04)

**Mechanically clean.** `pnpm content-lint` is green across all 31, and
`pnpm content-lint:urls` resolved **all 75 source URLs** (0 dead links). Front-matter key
parity is exact (30/30 keys, no extras, no omissions); every file is `status: draft` with
`written_by`/`medically_reviewed_by` = `PENDING` and all four date fields `null` — nothing
invented. Sourcing is strong: ≥2 sources each, 73 of 75 Tier-1, no forbidden hosts. No
`meta_title`, `meta_description`, `slug` or `primary_query` collides across the set, so
there is no keyword cannibalisation. Every internal link resolves against the real App
Router, and every prose link is declared in `internal_links`. Lengths conform (pillars
1,245–1,400 words, clusters 746–1,111); reading level is grade **5.9–8.0**, consistent with
the brief's 6–8 claim. **Zero uncited statistics** — every block containing a number carries
an inline citation or names its guideline body.

**One correction round, applied here.** Nine files used "medical review process/page" as the
link label for `/en/medical-review` — decorative framing that post-dates ADR-028. Renamed to
"clinician review process/page", matching the site's own vocabulary ("How we review",
"Clinician reviewed"). This is a label rename with no medical content implication, so it did
not need to go back to the assistant. The URL is deliberately unchanged (ADR-028).

**The `how-endometriosis-is-assessed.md` "diagnos" flag is a false alarm — no action.** The
only occurrence of `diagnos*` in all 31 files is inside a *source title*: "NICE:
Endometriosis: diagnosis and management", the actual name of guideline NG73. Changing it
would misrepresent the citation.

**Safety routing is correct.** Four articles touch self-harm or staying safe
(`pms-pmdd`, `track-pms-pmdd-symptoms`, `pregnancy-warning-signs`, `pregnancy-basics`); all
four link `/en/help-now` and **none** contains a phone number, per §8. All 18
`disclaimer_type: emergency` articles carry a `**Seek care now:**` red-flag box.

### For the clinician (judgement, not mechanics)

The guard checks nothing about whether the medicine is *right*. Three things to put in front
of the reviewer:

- **PMDD and suicidality.** `pms-pmdd.md` handles safety well at the red-flag level ("if you
  may harm yourself… contact local emergency services"), but never states that PMDD carries
  elevated risk of suicidal ideation, which major guidance treats as a defining severity
  signal. Omitting it may be the right call for a general-audience page, or a gap. A
  clinician should decide — this is exactly the kind of question mechanical checks cannot ask.
- **Scope of "care options" pages.** `menopause-care-options.md` and
  `period-pain-care-options.md` describe drug *classes* without dosages, as the brief
  requires. Whether the balance of options shown matches current guidance needs a clinician.
- **The two Tier-2 citations are the same document, and may be mis-tiered.** Both
  `how-pcos-is-assessed.md` and `pcos-and-fertility.md` cite "ASRM: 2023 International
  Evidence-based Guideline for PCOS" as Tier 2. That guideline is co-published with **ESHRE**,
  which the brief names explicitly as Tier 1. If it should be Tier 1, the tier is wrong in
  two files; if the assistant downgraded it deliberately (it linked the ASRM-hosted PDF
  rather than the ESHRE copy), that reasoning is worth recording. Either way both articles
  independently satisfy the ≥1 Tier-1 rule, so nothing is blocked on it.

## Owner tasks outstanding (`docs/runbooks/OWNER_MANUAL_TASKS.md`)

- **Custom domain** `femioapp.com` → task F, four steps. Do it **before** the content push:
  every article's canonical/hreflang/sitemap entry is built from `NEXT_PUBLIC_APP_URL`.
- **Remove `PAYLOAD_DB_PUSH`** from the femio-cms Vercel env (now ignored by code, but tidy).
- **PostHog DPA** + "Discard client IP data"; **ThroughLine** confirmation email (drafted at
  `docs/compliance/THROUGHLINE_LINK_CONFIRMATION.md`).
- **P0.12 legal/DPO gate** — the long-lead item; blocks real users. Includes **P0.12.4**
  (replace the draft privacy/terms text, then un-noindex and add to the sitemap).

## Environment gotchas (hard-won)

- **Run e2e in CI mode before pushing:** `CI=1 pnpm --filter web test:e2e:ci` after a fresh
  build. `next dev` renders everything dynamically, so a green local run proves nothing
  about production — that gap hid the 500-instead-of-404 for weeks.
- **`pkill -f "next start"` does NOT kill the server on Windows.** Kill by port:
  `Get-NetTCPConnection -LocalPort 3000 -State Listen | %{ Stop-Process -Id $_.OwningProcess -Force }`.
  A stale server serving an old build invalidates every measurement taken after it.
- **Underscore-prefixed folders (`__foo/`) are private in the App Router** — a scratch route
  named that way never registers and 404s, which looks like a passing test.
- **i18n catalogs are CRLF.** Use start-of-line regex anchors, never substring anchors: a
  two-space `  "learn": {` also matches inside the six-space nested `home.sections.learn`,
  which silently put keys in the wrong namespace across all four locales.
- **Verify against the deployed thing, not just the code.** The CMS build never connects to
  the database, so builds and 154 unit tests all passed while production was broken. Hit the
  API after a CMS deploy.
- **`apps/cms/.env.local` holds the PRODUCTION connection string.** Any command that
  migrates from a local build touches live data — that is why `migrate-on-deploy.mjs` runs
  only when `VERCEL_ENV === "production"`.
- Supabase project `wnthtqtcajkhskdygbgo` (EU). Both Vercel projects auto-deploy from `main`.

## How to resume (new chat)

Open `E:\Femio` and paste the prompt in `docs/HANDOVER_PROMPT_2026-08-04.md`.
