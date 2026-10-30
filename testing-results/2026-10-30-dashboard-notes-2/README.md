# Owner's dashboard notes, pass 2 (R6.15) — evidence, 2026-10-30

**What the notes asked for** (dashboard items `phone-check`, `gtm-import`, `content-decisions`,
`feedback-form`, `url-inspection`, 2026-10-29/30): flags beside the language names instead of the
"translate" icon; no more "Arabic-first / Saudi Arabia and Egypt" on the public site; Learn cards
without cut-off art or uneven boxes; "iPhone: coming soon"; the Tag Manager import that failed with
"File format is invalid"; the four content decisions "as recommended"; which feedback form; whether
pages can be auto-indexed.

| Check | Result | Evidence |
|---|---|---|
| Tag Manager container | the file failed Tag Manager's validator for a real reason: seven event tags used the retired `TAG_REFERENCE` on `measurementIdOverride`, and `consentSettings` was shaped like a parameter. Both fixed; `node scripts/gtm-container-lint.mjs` passes and runs in `pnpm gate` | guard output in the gate log; shapes confirmed against the Tag Manager API Tag resource and a 2026 export sample |
| Header, Arabic, 390×844 | Saudi flag button, one row | `ar-learn-flags.png` |
| Menu, Arabic | flag + name per language, current ticked | `ar-menu-flags.png` |
| Footer, Arabic | four flag + name links; "عن femio", "© 2026 femio" | `ar-footer-flags.png` |
| Learn cards | 2:1 art box, whole bloom visible, equal heights in a row | `ar-learn-flags.png` |
| App page, English, full page | "Four languages" feature, iPhone "Coming soon", GB flag in header, flags in footer, no "Arabic first" | `en-app-page.png` |
| Wordmark | "Femio" → "femio" in all four web catalogues (124 places) and the app's ARB files (40) | gate + `flutter test` |

**Gate:** see the session log `gate-notes2b.log` (web) and `app-wordmark.log` (app); results are
in the ledger row for 2026-10-30.

**Not verified:** French and Spanish pages beyond the strings; the dashboard's re-download step on
the owner's machine; the live site until deployed. Screenshots are synthetic (local dev server).
