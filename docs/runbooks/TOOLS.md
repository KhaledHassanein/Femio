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
- `web/sync-app-strings.mjs` — the app's own sentences (ARB) → the website's `appDemo.app` catalog block, four locales (`--check` in the gate as `app-strings-lint`). Add a key to its list, never a copied sentence.
- `web/dead-modules-lint.mjs` — every module under `apps/web/src/lib` must be reached from a page, component, script or the fixture runner.
- `store/listing-check.mjs` — the Play listing files in `docs/store` against Play's limits, gate marks, wordmark, disclaimer.
- `claims-lint.mjs`, `crisis-compliance.mjs` (also checks the app ARB sentences verbatim), `wordmark-lint.mjs`
  (the wordmark is Latin `femio` even in Arabic), `content-lint.mjs`, `i18n/untranslated-lint.mjs`,
  `seo/sitemap-check.mjs` — the guards that have caught real errors. When one fails, fix the code,
  never the rule.
- Line endings are LF everywhere (`.gitattributes`); if a generator guard fails with no visible
  diff, check for CRLF first.

### Privacy tripwire (`analytics-lint.mjs` + `lib/android-tripwire.mjs`)
`pnpm analytics-lint` (or `node scripts/analytics-lint.mjs`) runs in the gate. Besides the web and
Dart checks it covers the Android side (R14.14, ADR-083):
- **Native network code:** any `.kt`/`.java` under `apps/mobile/android` that imports `java.net` or
  `javax.net`, opens a URL connection or socket, or uses OkHttp, Ktor, Retrofit, Volley, Cronet,
  gRPC, a WebView or DownloadManager fails, except in `kotlin/com/femioapp/femio/assistant/`
  (the Firebase AI Logic bridge). Comments are ignored.
- **Gradle:** every dependency the app module declares must be on `ALLOWED_GRADLE_DEPENDENCIES`
  and every plugin on `ALLOWED_GRADLE_PLUGINS`; analytics, ads, attribution and crash-reporting
  coordinates fail in any Gradle file. A dependency written as a version-catalog alias fails
  until it is a literal `"group:artifact:version"`. Plugins pulled in through pub packages are
  not Gradle lines here: the pubspec check and the merged manifest cover them.
- **Merged manifest:** read from `apps/mobile/build/app/intermediates/merged_manifest*/**/AndroidManifest.xml`
  when it is newer than the source manifest, `build.gradle.kts` and `pubspec.lock`. It fails on
  an ad-ID or personal permission, ad or analytics `<meta-data>`, or a component not on
  `ALLOWED_COMPONENTS` (each can use INTERNET). Google's `datatransport` components are a
  warning, not a failure, until the device traffic capture settles them (SEC-5).
  To run it: `cd apps/mobile && flutter build apk --debug`, then the tripwire. A stale or missing
  merged manifest is a warning locally; a release job sets `FEMIO_REQUIRE_MERGED_MANIFEST=1` (or
  passes `--require-merged-manifest`) so it fails instead.
- **Release signing:** `flutter build apk --release` / `appbundle` fails without
  `android/key.properties`. For a local debug-signed release only:
  `flutter build apk --release -P allowDebugSigning=true` (or `FEMIO_ALLOW_DEBUG_SIGNING=1`).

## Flutter on this PC
`C:\src\flutter\flutter` (3.47.8 stable on 2026-10-27). The app needs Dart ≥ 3.13.4; if `flutter pub
get` fails on the SDK constraint, run `flutter upgrade`. No emulator is required for the gate:
`flutter analyze && flutter test` in `apps/mobile`. The owner tests the APK on a real phone.
