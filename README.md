# Femio

[![CI](https://github.com/KhaledHassanein/Femio/actions/workflows/ci.yml/badge.svg)](https://github.com/KhaledHassanein/Femio/actions/workflows/ci.yml)

Web-first women's-health platform — one account for a woman's whole health life
(EN/AR/FR/ES, RTL-native). Wellness / education / tracking only. See `CLAUDE.md`.

## Repo map
- `docs/30_REVAMP/` — the live plan (audit, market research, revamp plan, `PROGRESS.md`)
- `docs/` — `STATE.md` (read first), architecture and specs, `DECISIONS.md`, `CHANGELOG.md`,
  `runbooks/OWNER_ACTIONS.md` (everything the owner does), `compliance/`, `personas/`
- `apps/web/` — Next.js 15 PWA (TS, Tailwind, next-intl, shadcn/ui, Serwist)
- `apps/cms/` — Payload 3 CMS (being retired in favour of repo-published content, D3)
- `supabase/` — versioned SQL migrations (schema + RLS)
- `assets/brand/` — design tokens (`@femio/tokens`) + Bloom logo
- `skills/` — installable Femio `.skill` packages

## Develop
Prerequisite: Node ≥ 20, pnpm. From the repo root:
```bash
pnpm install
pnpm dev         # http://localhost:3000 → /en
pnpm gate        # typecheck, lint, tests and every guard, one exit code
```
Applying database migrations: `docs/runbooks/supabase_apply_migrations.md`.
