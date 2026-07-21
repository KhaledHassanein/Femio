# Femio V2 — Figma UX Flows (Phase 0.5)
Prepared: 2026-07-16 · Status: living · Evidence for master-TODO P0.20 · Built from `09_MASTER_ADAPTATION_MODEL.md`

These are the holistic flow charts of how Femio's UI starts and adapts. Built as FigJam boards (editable in Figma). They translate the Master Adaptation Model into visual form: the welcome wizard, how wizard answers personalize the app, and how the UI dynamically re-layers as a user's state changes.

## Boards

1. **Master Adaptation State Map** — every life-stage persona as a state, every transition as an edge, from the wizard through Z1 fallback to the C8→D7 flagship. The single "how the whole app moves" picture.
   https://www.figma.com/board/JKxPGN49AddwAwUx9dMewq

2. **Welcome Wizard Decision Tree** — how onboarding answers (Q1 life stage → refinement Qs) resolve into a starting persona; the editable/resettable panel; and "Skip / not sure" → Z1 with progressive nearest-persona offers.
   https://www.figma.com/board/oRddpLiy6BJrNBxxDkLrj3

3. **Flagship Transition C8 → D7** — the thyroid-TTC → positive-test → thyroid-aware-pregnancy re-layering: constant EMR, continued lab/med logs, home/tools/content/alerts changing, guardrails held (no dose, no verdict).
   https://www.figma.com/board/wGLrIwECD2o2txQcR3Dhyk

## Status & next
- Done (P0.20a): the three holistic flow charts above.
- Pending (P0.20b): high-fidelity **screen mockups** — welcome-wizard screens, personalized home per spine persona (A2/B6/C1/D1/E1/F1), and the adaptive thyroid-aware pregnancy home — built on the Femio design system (`femio-design-system` tokens: violet #7C3AED, Inter/Fraunces, Arabic IBM Plex Sans Arabic, RTL, cards, uncertainty-honest prediction UI).
- Note: current Figma plan seat is "View"/starter — high-fidelity design-file authoring may need a seat upgrade; screens can alternatively be delivered as design-system HTML mockups and ported. Decision pending with Khaled.
