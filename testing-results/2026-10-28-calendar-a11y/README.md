# Calendar keyboard and accessibility pass — 2026-10-28

**Automated (passes, real browser, local build):** `apps/web/e2e/calculators.spec.ts`, Chromium via Playwright.

| Check | EN | AR |
|---|---|---|
| Exactly one day in the tab order (roving tabindex), and it is today (`aria-current="date"`) | pass | pass |
| Tab reaches the grid; ArrowRight/ArrowLeft move one day in the visual direction (ArrowLeft = next day in Arabic) | pass | pass |
| ArrowUp moves exactly seven days | pass | pass |
| Enter selects the focused day (`aria-selected` on one gridcell) and a result appears in a `role="status"` region | pass | pass |
| Every day button has a full-date accessible name, never only a number | pass | pass |
| Week starts on Saturday, Western digits | — | pass |
| axe-core (WCAG 2.x) on `/en/calculators/fertile-window`, `/ar/calculators/fertile-window`, `/ar/calculators/due-date` and 17 other pages (`e2e/a11y.spec.ts`) | pass | pass |

**Not done here:** a real screen reader. NVDA is not installed on this PC; owner action 8 in
`docs/runbooks/OWNER_ACTIONS.md` describes the 20-minute listening session and where to write the notes.
