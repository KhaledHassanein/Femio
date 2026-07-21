---
name: femio-design-system
description: Femio V2 design system - brand tokens, typography (incl. Arabic), components, RTL, high-end UI/UX and graphic design standards. Use whenever designing or building ANY Femio UI - pages, components, emails, social/marketing graphics, app store assets.
---

# Femio Design System

Goal: every screen "screenshot-worthy" — calm, premium, medically trustworthy. Think Clue's clarity + Stardust's polish, never clinical-cold or pink-cliché.

## Brand tokens (v1 — refine in P0.11, keep tokens as single source of truth)
```css
:root {
  --femio-primary: #7C3AED;      /* violet 600 — authority + warmth, not stereotype pink */
  --femio-primary-soft: #EDE9FE;
  --femio-accent: #E11D74;       /* raspberry — energy, CTAs only */
  --femio-teal: #0D9488;         /* health/success, fertile-window */
  --femio-amber: #D97706;        /* warnings, predictions uncertainty */
  --femio-ink: #1E1B2E;          /* text on light */
  --femio-surface: #FAFAF9;      /* warm off-white bg */
  --femio-radius: 16px;          /* cards */
  --femio-radius-sm: 10px;
}
```
Dark mode: surface `#17151F`, cards `#211E2E`, never pure black except OLED user setting. Semantic colors for cycle phases: menstrual `--femio-accent`, follicular `--femio-teal`, ovulatory `#F59E0B`, luteal `--femio-primary`.

## Typography
- Latin: **Inter** (UI) + **Fraunces** (editorial headlines — warmth/authority).
- Arabic: **IBM Plex Sans Arabic** (UI) + matching weights; line-height 1.7 for AR body.
- Scale: 12/14/16/18/22/28/36/48. Body 16px min. Never more than 2 families per surface.

## Layout & feel
- 4px spacing grid; generous whitespace — density is the enemy of trust.
- Cards over tables for user data; soft shadows (`0 1px 3px rgb(0 0 0 / .08)`), no hard borders.
- Motion: 150–250ms ease-out; micro-interactions on log actions (subtle scale/confetti on streaks); respect `prefers-reduced-motion`.
- Charts: rounded, filled-gradient area charts; always label uncertainty visually (dotted/soft bands for predicted days — predictions NEVER rendered as certain).
- Every list/page ships with designed empty, loading (skeleton, no spinners), and error states.

## RTL rules
- All layout via logical properties/flow (`text-align: start`, `margin-inline-start`); icons with direction meaning get flipped variants; numerals: Western Arabic digits by default (locale-configurable); test every screen in AR before done.

## Voice & imagery
- Warm, direct, never infantilizing; "you," never "the patient."
- Illustration style: soft duotone line illustrations, diverse skin tones, no anatomical shock imagery on entry pages; discreet-mode swaps explicit imagery/wording for neutral.
- Graphic/marketing assets (social, ads, store screenshots) use the same tokens + Fraunces headlines; export at platform sizes; keep a 40%+ whitespace ratio.

## Definition of done for any UI
- [ ] Tokens only (no raw hex/px), both themes, AR-RTL verified, a11y AA, empty/loading/error designed, mobile-first responsive (360px → 1440px).
