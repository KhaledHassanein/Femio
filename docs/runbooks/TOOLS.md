# Tool notes (read only when using the tool)

Moved out of `CLAUDE.md` on 2026-10-27 so every session does not pay for them.

## ui-ux-pro-max (`.claude/skills/ui-ux-pro-max/`)
A searchable local UI/UX corpus (styles, palettes, font pairings, 119 UX guidelines, per-stack rules
for `nextjs` and `flutter`). Query it from the repo root:

```bash
python .claude/skills/ui-ux-pro-max/scripts/search.py "<query>" --domain ux
```

Python 3 only, no dependencies, no network. Useful as a checklist and a second opinion on
accessibility, contrast, focus and interaction. **It does not outrank Femio's own system:** tokens
are `assets/brand/tokens/femio.tokens.css`, screen conventions are `docs/22` and
`docs/33_REBUILD_V3/02_DESIGN_SPEC.md`. **Never run its `--design-system --persist` generator against
this repo**; it writes a competing token set. Its suggestions are input to a decision, never the
decision.

## shadcn MCP (`.mcp.json`)
Pinned to `shadcn@4.18.0` rather than `@latest` because `add` is a destructive verb and its behaviour
must not change under us on a CLI release. Deliberately not a devDependency (a dev-time tool that
never ships). Pinned to `--cwd apps/web`, where `components.json` lives. Use it to *read* the registry
and to add primitives we do not have. **Never let it `add` over an existing
`apps/web/src/components/ui/*` file**: ours carry Femio semantic tokens (`bg-primary-solid`), a 44px
touch target and press feedback; upstream would silently revert all three. Anything pulled in fresh
still needs the token pass and the logical-property pass (`ms-`/`me-`, never `left`/`right`).

## Generators and guards (`scripts/`)
- `design/tokens-to-dart.mjs` — CSS tokens → `apps/mobile/lib/theme/tokens.g.dart` (`--check` in the gate).
- `mobile/sync-log-vocabulary.mjs` — log vocabulary and labels → Dart (`--check` in the gate).
- `mobile/arb-untranslated-lint.mjs` — every ARB value compared with English; cognates allowlisted by key.
- `content/reading-level.mjs` — Flesch-Kincaid on the English wedge guides, ceiling grade 9.0 (`--report` lists each); its test validates the formula.
- `store/listing-check.mjs` — the Play listing files in `docs/store` against Play's limits, gate marks, wordmark, disclaimer.
- `claims-lint.mjs`, `crisis-compliance.mjs` (also checks the app ARB sentences verbatim), `wordmark-lint.mjs`
  (the wordmark is Latin `femio` even in Arabic), `content-lint.mjs`, `i18n/untranslated-lint.mjs`,
  `seo/sitemap-check.mjs` — the guards that have caught real errors. When one fails, fix the code,
  never the rule.
- Line endings are LF everywhere (`.gitattributes`); if a generator guard fails with no visible
  diff, check for CRLF first.

## Flutter on this PC
`C:\src\flutter\flutter` (3.47.8 stable on 2026-10-27). The app needs Dart ≥ 3.13.4; if `flutter pub
get` fails on the SDK constraint, run `flutter upgrade`. No emulator is required for the gate:
`flutter analyze && flutter test` in `apps/mobile`. The owner tests the APK on a real phone.
