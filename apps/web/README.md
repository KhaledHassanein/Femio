# @femio/web

Femio's web PWA — Next.js 15 (App Router) · TypeScript (strict) · Tailwind v3 ·
next-intl (EN/AR/FR/ES, RTL) · shadcn/ui · Serwist PWA.

## Commands

Run from the **repo root** (pnpm workspace):

```bash
pnpm install        # install all workspace deps
pnpm dev            # start the web app (http://localhost:3000 → /en)
pnpm build          # production build
pnpm lint           # ESLint
pnpm typecheck      # tsc --noEmit
pnpm test           # Vitest
```

## Layout

```
src/
  app/[locale]/     # locale-prefixed routes; layout sets <html lang dir>
  app/globals.css   # Tailwind layers + token-based base styles
  app/manifest.ts   # PWA web manifest
  app/sw.ts         # Serwist service worker source → public/sw.js (build)
  i18n/             # next-intl routing / request / navigation
  components/ui/    # shadcn/ui components (Femio-tokenized)
  lib/              # env (zod), utils (cn)
messages/           # per-locale JSON (swap point for the DB portal — P1.19)
```

## Conventions

- **Design tokens only** — styling flows through `@femio/tokens` (canonical in
  `assets/brand/tokens`); no raw hex/px in components (docs/12).
- **No hardcoded user-facing strings** — everything via next-intl message keys.
- **RTL** — Arabic is first-class; use logical properties (`ms-`/`me-`,
  `start`/`end`), never `ml-`/`left`.

See `CLAUDE.md` and `docs/archive/2026-11/14_SYSTEM_ARCHITECTURE.md` for the full picture.
