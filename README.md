# Femio

[![CI](https://github.com/KhaledHassanein/Femio/actions/workflows/ci.yml/badge.svg)](https://github.com/KhaledHassanein/Femio/actions/workflows/ci.yml)

Web-first women's-health platform — one account for a woman's whole health life
(EN/AR/FR/ES, RTL-native). Wellness / education / tracking only. See `CLAUDE.md`.

## Repo map
- `docs/` — numbered strategy docs, `07_MASTER_TODO.md` (single source of truth),
  `DECISIONS.md`, `CHANGELOG.md`, `runbooks/`, `compliance/`, `personas/`
- `apps/web/` — Next.js 15 PWA (TS, Tailwind, next-intl, shadcn/ui, Serwist)
- `supabase/` — versioned SQL migrations (schema + RLS)
- `assets/brand/` — design tokens (`@femio/tokens`) + Bloom logo
- `skills/` — installable Femio `.skill` packages
- `references/` — archived V1 Flutter (learning only)

## Develop
Prerequisite: Node ≥ 20, pnpm. From the repo root:
```bash
pnpm install
pnpm dev         # http://localhost:3000 → /en
pnpm lint && pnpm typecheck && pnpm test && pnpm build && pnpm claims-lint
```
Applying database migrations: `docs/runbooks/supabase_apply_migrations.md`.
