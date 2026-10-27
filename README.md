# Femio

[![CI](https://github.com/KhaledHassanein/Femio/actions/workflows/ci.yml/badge.svg)](https://github.com/KhaledHassanein/Femio/actions/workflows/ci.yml)

A private women's-health app (Flutter, Android first) whose records never leave her phone, and the
website that is its front door (articles, calculators, no database). Arabic-first; EN/AR/FR/ES UI,
RTL-native. Wellness, education and tracking only. See `CLAUDE.md`.

## Repo map
- `docs/33_REBUILD_V3/` — the live plan and ledger (`PROGRESS.md`)
- `docs/32_STUDY/` — the 2026-10-27 study: reports, knowledge graph (`graph/index.html`), synthesis
- `docs/` — `STATE.md` (read first), `DECISIONS.md`, `CHANGELOG.md`, `compliance/`, `personas/`,
  `content/articles/` (the content source), `runbooks/OWNER_ACTIONS.md`
- `apps/mobile/` — the Flutter app
- `apps/web/` — the Next.js teaser site
- `fixtures/domain/` — golden fixtures shared by the TypeScript and Dart maths
- `assets/brand/` — design tokens and the Bloom logo

## Develop
Prerequisites: Node ≥ 20, pnpm 11, Flutter ≥ 3.47.
```bash
pnpm install
pnpm dev                       # website at http://localhost:3000 → /en
pnpm gate                      # typecheck, lint, tests and every web guard, one exit code
cd apps/mobile && flutter analyze && flutter test
```
