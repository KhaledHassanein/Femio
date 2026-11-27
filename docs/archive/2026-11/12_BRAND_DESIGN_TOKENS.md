# Femio V2 — Brand & Design Tokens (P0.11)
Prepared: 2026-07-16 · Status: living · Source of truth: `assets/brand/tokens/femio.tokens.css`
Supersedes the v1 tokens in the `femio-design-system` skill (this is the refined, production system).

Goal: every surface **screenshot-worthy** — calm, premium, medically trustworthy. Clue's clarity + Stardust's polish, never clinical-cold or pink-cliché. This document is the human-readable rationale; the machine truth lives in the token files.

## Token files (what to use where)
| File | Purpose | Consumed by |
|---|---|---|
| `femio.tokens.css` | **Canonical** — primitives + semantic (light/dark) as CSS custom properties | imported once globally; every component reads semantic vars |
| `femio.tokens.json` | W3C-format mirror (machine-readable) | build tooling, native (Capacitor) export, Figma variable import |
| `femio.tailwind.preset.js` | Maps semantic tokens into Tailwind theme | `tailwind.config.js` (Next.js app, P1.2/P1.5) |
| `logo/femio-logo.svg` | Logo concept (mark + wordmark) | brand surfaces (concept — outline to paths at handoff) |
| `brand-preview.html` | Visual showcase of the full system | design review |

**Architecture — two tiers.** Primitives (`--violet-600`, raw scales) are never used in components. Components use **semantic** tokens (`--primary`, `--surface`, `--danger`) which reference primitives. Dark mode remaps only the semantic layer. This keeps one dial per decision and guarantees theme + a11y consistency.

## Color

**Brand.** Violet `#7C3AED` (primary) — authority + warmth, deliberately **not** stereotype pink. Raspberry `#E11D74` (accent) — energy, reserved for CTAs. Teal `#0D9488` — health/success/fertile-window. Amber `#D97706` — warnings + prediction uncertainty. Each ships as a **full 50–950 ramp** (see `femio.tokens.css`) so UI has proper tonal range instead of tints-on-the-fly.

**Neutrals are warm, faintly violet-tinted** (not cold gray) — cohesive with the brand and softer/more trustworthy. Surface is a warm off-white `#FAFAF9`; ink is `#1E1B2E`.

**Semantic cycle phases** (a Femio signature): menstrual = raspberry, follicular = teal, ovulatory = `#F59E0B`, luteal = violet. Predicted days are **never** rendered as certain — the `--prediction-band` amber tone is always shown soft/dotted (see §Predictions).

**Dark mode.** Surface `#17151F`, cards `#211E2E`; never pure black except the OLED user setting (`[data-oled="true"]`). Brand steps one lighter (violet-500) for contrast on dark.

**Accessibility (verified — programmatic contrast audit, 2026-07-16).** All text pairs were computed, not assumed:

| Pair | Ratio | AA normal (4.5) |
|---|---|---|
| `--text` #1E1B2E on surface #FFF | 16.78 | ✅ |
| `--text-muted` #6E6880 on surface | 5.31 | ✅ |
| `--text-subtle` **#787189** on surface | **4.64** | ✅ *(fixed — was #928BA3 = 3.26, failed)* |
| `--text-link` violet-700 on surface | 7.10 | ✅ |
| white on `--primary-solid` violet-600 | 5.70 | ✅ |
| white on `--accent-solid` rasp-600 | 4.54 | ✅ |
| white on `--success-solid` teal-700 | 5.47 | ✅ *(text fills use teal-700; teal-600 white = 3.74, large/graphics only)* |
| danger / success / warning text on soft | 6.0–6.7 | ✅ |
| \[dark] `--text` on card | 14.53 | ✅ |

Two audit findings were **fixed in tokens**: `--text-subtle` darkened to `#787189` (neutral-550), and dedicated **`--primary-solid` / `--accent-solid` / `--success-solid`** fill tokens added that carry white text at AA in both themes. Rule: use the `*-solid` tokens for buttons/labels; the raw `--primary`/`--success` and teal-600 are for large hero fills, icons, and graphics (AA-large 3:1). Never rely on color alone — status always pairs an icon/label (cycle phases, red-flags). Focus is a visible 3px ring (`--focus-ring`), never removed. Full both-theme sign-off is automated at P1.5.

## Typography
- **Latin UI — Inter.** Neutral, legible, excellent at 16px body (our minimum).
- **Display — Fraunces.** Optical-size serif for editorial headlines: warmth + authority without being clinical. Use for hero/section headlines only; never for dense UI.
- **Arabic — IBM Plex Sans Arabic.** First-class, not an afterthought. Body line-height **1.7**; RTL verified per screen.
- **Scale** (px): 12 · 14 · 16 · 18 · 22 · 28 · 36 · 48 · 60 · 72. Body 16 min. Max two families per surface. Display sizes carry negative tracking (`-0.02em`) for a tighter, premium set.

## Space, radius, elevation, motion
- **Spacing** on a strict **4px grid** (`--space-1..32`). Generous whitespace — density is the enemy of trust (≥40% breathing room on marketing surfaces).
- **Radii**: cards 16 (`--radius-md`), inputs/chips 10, sheets/hero 24–32, pills 999. Cards over tables for user data.
- **Elevation**: soft, layered, faint-violet ambient shadows (`--shadow-xs..xl`) — never hard borders or harsh drops. `--shadow-primary-glow` gives CTAs a subtle lift.
- **Motion**: 150–250ms, `--ease-standard`; `--ease-spring` for micro-interactions (log confirmations, streaks). All durations collapse to 0 under `prefers-reduced-motion`.

## Predictions (compliance-linked visual rule)
Predictions are **uncertainty-honest by design**: ranges/bands + confidence, never a single certain date, never a "late" counter in irregular modes. The token system encodes this — predicted days use the soft `--prediction-band`, rendered dotted/gradient, visually distinct from logged/certain data. This is a brand rule *and* a regulatory guardrail (avoids medical-device-style certainty claims).

## Logo — "Bloom" (chosen direction, 2026-07-16)
The mark is a six-petal **Bloom**: a blossom that is also the **cycle turning** — life blooming, phases, continuity — with a soft center **today/"you" dot** echoing the app's cycle-ring UI. Feminine through floral form (not pink cliché); the shared "dawn" gradient (violet→raspberry→amber) makes each petal catch a different hue. Wordmark is lowercase **femio** in Fraunces (softer, contemporary). Chosen from three explored directions (Bloom / Venus continuum / Lune — see `logo/femio-logo-concepts.html`).

**The logo wordmark is always English "femio"** — never transliterated to Arabic. In RTL layouts the English lockup is used as-is; the app's UI and content stay fully Arabic/RTL (that's an i18n concern, not a brand one), but the brand mark is fixed Latin.

**Produced set** (`assets/brand/logo/`): `femio-logo.svg` (primary horizontal) · `femio-logomark.svg` (mark only) · `femio-logo-stacked.svg` · `femio-logo-mono.svg` (single-ink + reversed) · `femio-app-icon.svg` (512, warm squircle) · `femio-logo-lockups.html` (full board + clearspace + min-size). Clearspace = center-dot diameter all sides; min mark 20px digital / 8mm print; below that, mark alone. Never recolor petals, stretch, add effects, translate the wordmark, or place the gradient mark on busy/low-contrast backgrounds (use mono/reversed).

## Do / Don't
- **Do** use semantic tokens; **don't** hardcode hex/px in components (CI should flag raw values — P1.5 DoD).
- **Do** reserve raspberry for CTAs; **don't** flood UI with accent.
- **Do** render predictions soft/uncertain; **don't** show confident single-date predictions or a "late" counter.
- **Do** treat Arabic/RTL as first-class (test every screen); **don't** ship LTR-only layouts.
- **Do** keep imagery warm, diverse, non-clinical, discreet-mode-swappable; **don't** use anatomical-shock or glitter-baby clichés.

## Open items → next
- [ ] Logo: outline to paths + full lockup set + favicon/app-icon + safe-area/clearspace spec (brand handoff).
- [ ] Trademark clearance for "Femio" with counsel — preliminary scan found no direct femtech collision but close marks exist (*Femi*, *FemTec*, *Feminée*) → **P0.12 legal**.
- [ ] Contrast audit sign-off across all semantic pairs in both themes (automated, P1.5).
- [ ] Figma: import `femio.tokens.json` as Variables once a Full seat is added (P0.20c).
