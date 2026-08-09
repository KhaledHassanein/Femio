# Resume prompt — paste this into a new chat

---

Read `CLAUDE.md`, `docs/HANDOVER_STATE_2026-08-04.md`, `docs/07_MASTER_TODO.md` and
`docs/runbooks/OWNER_MANUAL_TASKS.md`. That handover supersedes the 2026-07-30 one and
explains where everything stands.

**First, verify one thing before building anything.** The last session adopted Payload
migrations after a schema change took the CMS down for about an hour (ADR-029). At handover
the production API was healthy (200) but the migration had **not** applied — meaning the
deploy of the publishing fields had failed rather than shipped, and a later commit
(`31644cf`) fixed the likely cause (the migrate guard was failing preview builds). Check:

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://femio-cms.vercel.app/api/articles?limit=1
```

- **500** → code deployed without its schema again. Recover with `pnpm --filter cms migrate`
  (`apps/cms/.env.local` has the production DATABASE_URL), then confirm 200.
- **200 with the migration still missing** (`payload.payload_migrations` contains only
  `dev`, no `payload.articles_rels` table) → the deploy hasn't run yet; check Vercel's
  `femio-cms` build logs, and if needed apply it deliberately with the same command.
- **200 with both migrations recorded and `articles_rels` present** → all good, move on.

**Then do these two, in order — the owner has approved both.**

1. **`scripts/content-lint.mjs` (P1.9.1).** 31 article drafts are in
   `docs/content/articles/`, written against `docs/content/CODEX_AUTHORING_BRIEF.md`.
   Reviewing 60 by hand is slow and degrades; make the mechanical half a script, in the same
   ratchet pattern as `claims-lint`/`crisis-lint`/`analytics-lint` (and make sure each rule
   actually fails when deliberately broken — a guard that can't fail is decoration).
   It should check: front-matter key parity + required keys, `status: draft`,
   author/reviewer `PENDING` not invented, forbidden claim verbs (diagnose/treat/prevent/
   contracept as something *Femio* does), ≥2 sources with ≥1 Tier-1 and resolvable URLs,
   `meta_title`/`meta_description` uniqueness across the whole set, slug ↔ `canonical_url`
   agreement, internal links resolving to routes that exist, the structural contract
   (answer-first opening, "When to see a doctor", red-flag box where a symptom can be an
   emergency), and health-not-medical framing per **ADR-028**. Known signals: 7 files use
   medical framing that post-dates that ADR; `how-endometriosis-is-assessed.md` mentions
   "diagnos" — read it in context, describing clinical assessment is allowed.

2. **Markdown → Payload importer (P1.9.2).** There is currently no way to get these drafts
   into the CMS; the alternative is a human pasting 60 articles and silently dropping the
   front-matter fields P1.6.6 added columns for (sources, SEO title/description, disclaimer
   type, author/reviewer relationships). Make it refuse malformed input so the brief's
   schema becomes a specification. Everything imports as **draft** — publication stays
   behind the CMS review gate, which only a medical reviewer can pass.

Then report a review of batches 1–3 to the owner: what passes, what needs a correction
round from the content assistant, and anything that needs a clinician's judgement.

**After that**, the queue is: P1.11.1 CWV/Lighthouse budget in CI and P1.11.2 trimming the
i18n payload, then the CMS/SEO recommendations P1.6.7–P1.6.13.

**Working agreement:** small commits with conventional messages; update
DECISIONS/CHANGELOG/MASTER_TODO in the same change; verify with build, typecheck, lint, the
four guards, unit tests and **`CI=1` e2e** before pushing; push to `main` (both Vercel
projects auto-deploy). Read the "Environment gotchas" section of the handover before your
first command — several of those cost hours to learn.
