# Handover → Claude Code

Everything Claude Code needs is already in the repo (`CLAUDE.md` + `docs/`). Below is a ready-to-paste opening prompt for your first Claude Code session, plus the safe-move checklist.

---

## Before you switch (safe move — no context lost)
1. **Push to GitHub** (P0.10.2) so there's a remote backup:
   ```powershell
   cd E:\Femio
   git remote add origin https://github.com/<your-username>/femio.git   # create the empty repo first, no README/gitignore
   git push -u origin main
   ```
   (If you don't want a remote yet, skip — local history is intact either way.)
2. **Install the Femio skills/plugin in Claude Code** (same marketplace/plugin these came from) so it has the 7 `femio-*` standards skills. `CLAUDE.md` points to the docs as backup if a skill is missing.
3. Open the `E:\Femio` folder in Claude Code (or `claude` in that directory). It auto-reads `CLAUDE.md`.

---

## Paste this as your first message in Claude Code

> You are taking over the **Femio** project at `E:\Femio` from a planning session. It's a web-first women's-health platform (Next.js 15 + TS + Tailwind + shadcn/ui + next-intl + PWA, Supabase EU backend, Payload CMS).
>
> **First, read, in order:** `CLAUDE.md`, `docs/07_MASTER_TODO.md`, `docs/09_MASTER_ADAPTATION_MODEL.md`, `docs/14_SYSTEM_ARCHITECTURE.md`, `docs/13_LEGAL_COMPLIANCE.md`, `docs/12_BRAND_DESIGN_TOKENS.md`. Skim `docs/08_…` and a few files in `docs/personas/` to see the spec shape. Use the `femio-*` skills.
>
> **Status:** Phase 0 + 0.5 complete (73 persona specs, adaptation model, brand + design tokens, Bloom logo). `docs/13` (legal) and `docs/14` (architecture) are written. Local git repo on `main`. The 454 `[NEEDS SOURCE]` flags (P0.22) are DEFERRED — a medical reviewer clears them before any persona content goes user-facing; do not block scaffolding on that.
>
> **Your task: P1.2 — scaffold the monorepo** exactly per `docs/14_SYSTEM_ARCHITECTURE.md`: Next.js 15 App Router + TypeScript + Tailwind (wire `assets/brand/tokens/femio.tailwind.preset.js` + import `femio.tokens.css` globally) + shadcn/ui + next-intl for EN/AR/FR/ES with RTL + PWA manifest/service worker. Then P1.3 (Supabase schema v1 + RLS + auth incl. anonymous mode) and P1.4 (GitHub Actions CI: lint/typecheck/test/preview).
>
> **Rules:** obey the 6 non-negotiable product rules in `CLAUDE.md` (wellness-only, personalize-never-restrict, uncertainty-honest, privacy-by-design, constant-EMR, Arabic-RTL first-class / English logo). Work in **small commits = restore points** (`feat:`/`docs:`/`fix:`), and in the same change update `docs/07_MASTER_TODO.md`, `docs/DECISIONS.md`, and `docs/CHANGELOG.md` per the agency governance. Never invent medical facts — cite Tier-1/2 or flag `[NEEDS SOURCE]`. Fill the compliance review gate on anything touching data or claims. Ask me before any destructive or irreversible action.
>
> Confirm you've read the docs and give me a short scaffold plan (folders, packages, config) before writing code.

---

## Working style to keep (from this session, which Khaled liked)
- Small, verified chunks; commit after each as a restore point.
- Mark TODO items `[~]`→`[x]` with doc links; log ADRs for decisions.
- Present a plan / ask on genuine forks; otherwise proceed on sensible defaults.
- Don't overwrite existing work; verify before and after batches.
