# Owner's dashboard notes, pass 1 (R6.14) — evidence, 2026-10-29

**What the notes asked for** (items `phone-check`, `legal-placeholders`, `vercel-env-clean`,
`branch-protection` on the go-live dashboard): a language switcher, the reviewer as
"Dr. Khaled M., MD" with no CPC, every contact as info@femioapp.com, the legal blanks filled, a
verdict on the leftover Vercel variables and on GitHub's branch-protection message.

**What was built** — `pnpm gate` green: 687 web tests, every guard (log in the session scratchpad,
`gate-switcher-2.log`).

| Check | Result | Evidence |
|---|---|---|
| Header menu, Arabic, light, 390×844 | four languages in their own script, العربية ticked, menu aligned to the end side | `ar-menu-light.png` |
| Header menu, Arabic, dark | same, tokens hold in dark | `ar-menu-dark.png` |
| Header menu, English, light | left-to-right mirror of the above | `en-menu-light.png` |
| Footer row, Arabic | four plain links, current one bold | `ar-footer-light.png` |
| Header row at 390 px after the fix | "Get the app" / "حمّلي التطبيق" on one line again (the new button had made it wrap) | `ar-header-light.png`, `en-header-light.png` |
| Switching keeps the page | /ar/privacy → English link → /en/privacy (checked in the browser pane) | — |
| Legal values | /ar/privacy prints "تاريخ السريان: 2026-10-29 · الإصدار 1", "KM Digital Labs … info@femioapp.com" | accessibility snapshot in the session |
| Reviewer credentials | `MBBCh` and `CPC` absent from `apps/web/src`, `packages/content`, `apps/mobile/assets` after `pnpm content:build` | `grep -rl` empty |
| Dev console | only Fast Refresh and the React DevTools notice | `.playwright-mcp` console logs (not kept) |

**Not verified:** the mailbox info@femioapp.com receiving mail (owner); the deployed site (not
deployed yet at the time of writing); French and Spanish pages beyond the strings (same component).

Screenshots are synthetic (local dev server, no real use).
