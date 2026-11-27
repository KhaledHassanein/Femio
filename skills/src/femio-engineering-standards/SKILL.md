---
name: femio-engineering-standards
description: Femio V2 engineering standards for lean, professional, store-compliant code. Use for ANY code written for the Femio project (Next.js/TypeScript/Supabase) — writing, reviewing, or refactoring. Triggers - Femio code, component, API, migration, PR review, refactor.
---

# Femio Engineering Standards

You are writing production code for Femio, a women's health platform. Code must read like a senior team wrote it — minimal, intentional, documented. Never generate filler, speculative abstractions, or "vibe-coded" bulk.

## Hard rules
1. **Least code that fully works.** Before writing, check if an existing component/util/package already covers it. Delete dead code on sight; never commit commented-out code or unused imports/deps/vars.
2. **TypeScript strict.** No `any` (use `unknown` + narrowing). Exported functions get explicit return types. Zod-validate all external input (API bodies, form data, env vars via a typed `env.ts`).
3. **Next.js:** Server Components by default; `"use client"` only when interaction demands it. Data access in server code — never expose Supabase service keys client-side. Route handlers thin; logic in `lib/`.
4. **Supabase:** every table has RLS enabled with an explicit policy — no exceptions. Migrations are versioned SQL files, never dashboard-only changes. Health data columns documented in the data map (compliance skill).
5. **Zero hardcoded user-facing strings** — everything through the i18n layer (see femio-i18n-workflow). Zero magic numbers — named constants. Zero inline hex colors — design tokens only (see femio-design-system).
6. **File ceilings:** components ≤200 lines, modules ≤300; split when exceeded. One component per file. Naming: kebab-case files, PascalCase components, camelCase functions.
7. **Errors:** never swallow. Typed error results or thrown + Sentry-captured. User-facing errors are friendly, localized, actionable.
8. **Accessibility is not optional:** WCAG 2.2 AA — semantic HTML, labels on all inputs, focus states, 44px touch targets, works with keyboard, RTL-safe (logical properties: `ms-`/`me-`, `start`/`end`, never `ml-`/`left` for layout).
9. **Tests:** every util/business-logic function gets unit tests (Vitest); every user flow touched gets/updates a Playwright e2e. Prediction/medical-logic code requires table-driven tests with edge cases (irregular cycles, missing data).
10. **Commits:** Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`). PR description states what/why/testing done. Update `docs/DECISIONS.md` for any architectural choice.
11. **No new dependency** without one-line justification in the PR; prefer stdlib/platform. Check bundle impact.
12. **Master TODO discipline:** any newly discovered task gets added to `archive/2026-11/07_MASTER_TODO.md` — nothing is skipped silently.

## Review checklist (run before declaring done)
- [ ] `pnpm lint && pnpm typecheck && pnpm test` clean
- [ ] No hardcoded strings/colors/numbers
- [ ] RLS covered for any new table/column
- [ ] RTL + dark mode verified for UI changes
- [ ] i18n keys added for all 4 locales (EN/AR/FR/ES)
- [ ] Docs/TODO updated
