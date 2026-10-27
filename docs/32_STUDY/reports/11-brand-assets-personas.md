# Study 11: brand, design tokens, assets and personas

Worktree: `E:\Femio\.claude\worktrees\femio-repo-study-planning-88d7c9` · Study date: 2026-10-27 · Branch `claude/femio-repo-study-planning-88d7c9`

**How to read the tags.** **Checked** = I opened the file, measured it, or ran the check. **From the docs** = a document says so and I did not verify it. **Hypothesis** = my reading, not proven. Nothing in the repo was changed. I ran four existing checks (read-only) and regenerated the Dart token file into the scratch folder to diff it.

## 1. Purpose

This area is Femio's visual identity in code. A **design token** is a named design value (a colour, a font size, a corner radius) stored once so every screen uses the same one. The canonical token file is `assets/brand/tokens/femio.tokens.css`. Other copies are generated or hand-written for the web (Tailwind, a utility-class CSS framework), for the Flutter app (Dart), and as a W3C-format JSON file (the standard format design tools import). The area also holds the logo and app icons, the mockups, the persona specs (73 research documents, one per life-stage user type), and the registry that turns some of those specs into data the web app reads. It exists so the product looks like one brand on the website, the PWA and the Android and iOS apps, and so the medical rules for each persona are written down in one place.

## 2. Inventory

Status key: live = used by product or gate; app-only = closed web tracker only (not used here); dead = superseded or archived; duplicate = second copy of something canonical; unknown = not traced (a reference or brand source with no code reference). Line counts are `wc -l`; binaries show bytes.

### 2a. Tokens and token tooling

| path | lines | one-line purpose | status |
|---|---|---|---|
| assets/brand/tokens/femio.tokens.css | 431 | Canonical tokens: 297 unique custom-property names, primitives, light and dark semantics, type, space, radius, shadow, motion, log, chart, confidence, skin, gradient, aurora | live |
| assets/brand/tokens/femio.tokens.json | 680 | W3C JSON mirror: 151 values, partial and out of date (see §8, R5) | duplicate |
| assets/brand/tokens/femio.tailwind.preset.js | 140 | Maps CSS tokens to Tailwind names; font names still the old v2 ones (R6) | live |
| assets/brand/tokens/package.json | 11 | Package `@femio/tokens`, exports the CSS, JSON and preset | live |
| scripts/design/tokens-parity-lint.mjs | 202 | Guard: every token family reachable from Tailwind; every themed token has a dark value. Passes now | live |
| scripts/design/tokens-to-dart.mjs | 136 | Writes the Dart colour file from the CSS; `--check` mode fails now (R7) | live |
| scripts/design/generate-topic-art.mjs | 66 | Paints the 10 topic cover SVGs from the CSS tokens | live |
| apps/mobile/lib/theme/tokens.g.dart | 782 | Generated: 191 colours, light and dark, as `FemioPalette` (CRLF line endings) | live |
| apps/mobile/lib/theme/femio_theme.dart | 122 | Flutter Material theme built from the palette; type sizes hard-coded (R8) | live |
| apps/web/tailwind.config.ts | 68 | Imports the preset, adds opacity support, replaces font families with next/font variables | live |
| apps/web/src/app/globals.css | 334 | Global styles, blanket reduced-motion rule (lines 51–58), aurora class | live |
| apps/web/src/app/[locale]/layout.tsx | 126 | Imports the tokens CSS; loads Newsreader, Plus Jakarta Sans, Noto Naskh Arabic, IBM Plex Sans Arabic via next/font | live |
| apps/web/src/components/theme-provider.tsx | 11 | Sets `data-theme` on the page | live |
| apps/web/src/lib/ui/contrast.test.ts | 101 | Test: AA contrast of text tokens on every surface, read from the CSS (not run in this study) | live |

### 2b. Logo, icons and brand files

| path | lines | one-line purpose | status |
|---|---|---|---|
| assets/brand/logo/femio-logo.svg | 23 | Primary horizontal wordmark (named primary in docs/12). Colours are v2 violet #7C3AED, ink #1E1B2E | unknown |
| assets/brand/logo/femio-logomark.svg | 19 | Mark only, v2 colours | unknown |
| assets/brand/logo/femio-logo-stacked.svg | 21 | Stacked lockup, v2 colours | unknown |
| assets/brand/logo/femio-logo-mono.svg | 23 | Single-ink and reversed version, ink #1E1B2E | unknown |
| assets/brand/logo/femio-app-icon.svg | 22 | Older app icon, v2 colours. Identical to the two web copies | duplicate |
| assets/brand/logo/femio-app-icon-dusk.svg | 24 | Dusk Bloom app icon (plum, rose, peach, saffron). The only SVG in the new palette | unknown |
| assets/brand/logo/femio-app-icon-dusk-512.png | 512×512 px, 56,707 B | Dusk icon at 512 px; matches the Android launcher art | unknown |
| assets/brand/logo/concept-bloom.svg | 22 | Logo exploration 1 (the chosen direction's source) | dead |
| assets/brand/logo/concept-lune.svg | 18 | Logo exploration 2 | dead |
| assets/brand/logo/concept-venus.svg | 20 | Logo exploration 3 | dead |
| assets/brand/logo/femio-logo-concepts.html | 82 | Board showing the three explorations | dead |
| assets/brand/logo/femio-logo-lockups.html | 94 | Lockup board with clear-space and minimum-size rules | unknown |
| assets/brand/brand-preview.html | 185 | Brand showcase with its own complete v2 token set (`:root`, lines 12–34) | duplicate |
| apps/web/public/icons/app-icon.svg | 22 | Web copy of the v2 app icon; used by the manifest and the organisation logo in JSON-LD | duplicate |
| apps/web/src/app/icon.svg | 22 | Next.js app icon (served as the page icon), v2 colours | duplicate |
| apps/web/src/app/manifest.ts | 24 | Web app manifest: name, colours, one SVG icon (R2) | live |

### 2c. Web public folder and fonts

| path | lines | one-line purpose | status |
|---|---|---|---|
| apps/web/public/art/ (10 SVGs: ttc, pregnancy, weeks, afterBirth, cycles, teens, conditions, menopause, newborn, more) | 2,345 B each (checked) | Topic cover art in the Dusk palette (sage, saffron, cream), painted by generate-topic-art.mjs; shown by topic-art.tsx | live |
| apps/web/public/ (no favicon.ico, no PNG icons, no OG image) | — | See §8, R13 | — |
| Web fonts | — | Loaded at build by next/font/google (self-hosted), per layout.tsx | live |

### 2d. Mobile assets

| path | lines or size | one-line purpose | status |
|---|---|---|---|
| apps/mobile/assets/fonts/PlusJakartaSans.ttf | 176,288 B | UI font, bundled | live |
| apps/mobile/assets/fonts/Newsreader.ttf | 451,664 B | Display font, bundled | live |
| apps/mobile/assets/fonts/IBMPlexSansArabic-{Regular,Medium,SemiBold,Bold}.ttf | 235,924 to 246,992 B each | Arabic font, four weights, bundled | live |
| apps/mobile/assets/fonts/OFL-*.txt (3 files) | 4.4 to 4.5 KB | Font licences (SIL Open Font Licence) | live |
| apps/mobile/android/app/src/main/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png | 48, 72, 96, 144, 192 px | Launcher icon, Dusk Bloom art (xxxhdpi viewed) | live |
| apps/mobile/android/app/src/main/res/drawable/launch_background.xml (+ drawable-v21) | 12 | Splash: plain `@android:color/white` (R4) | live |
| apps/mobile/android/app/src/main/res/values/styles.xml, values-night/styles.xml | 18 | Launch theme, day and night | live |
| apps/mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset (19 files) | 1024×1024 PNG, 10,932 B | Flutter template icon: blue "F" on white (R3). Not Dusk | live |

### 2e. Mockups (reference only)

| path | lines | one-line purpose | status |
|---|---|---|---|
| assets/mockups/femio_personalized_screens.html | 345 | Personalised screen mockups (P0.20b); own `:root` in v2 colours (lines 11–14) | duplicate |
| assets/mockups/R1.3_homepage_reference.html | 507 | Homepage reference, 8 hard-coded hex values; links the Dusk token file; loads Fraunces and Inter | unknown |
| assets/mockups/R1.4_onboarding_reference.html | 344 | Onboarding reference, 7 hard-coded hex values | unknown |
| assets/mockups/R1.5_cycle_dashboard_reference.html | 544 | Cycle dashboard modules, 11 hard-coded hex values; body colour #1E1B2E (line 14) | unknown |
| assets/mockups/R1.6_pregnancy_dashboard_reference.html | 389 | Pregnancy dashboard modules, 8 hard-coded hex values | unknown |
| assets/mockups/R1.7_menopause_dashboard_reference.html | 503 | Menopause dashboard modules, 11 hard-coded hex values | unknown |
| assets/mockups/R1.8_track_screen_reference.html | 533 | Track/log screen, 11 hard-coded hex values | unknown |

### 2f. Design docs and persona folder

| path | lines | one-line purpose | status |
|---|---|---|---|
| docs/12_BRAND_DESIGN_TOKENS.md | 77 | Brand rationale. Values are still v2 (violet #7C3AED, Inter, Fraunces, dark #17151F) and it names Capacitor (R11) | live |
| docs/archive/plans-2026-08/25_DESIGN_DIRECTION_BRIEF.md | 255 | R1.2 visual language. §5a (lines 173–241) holds the rejected patterns and is still used as the rule set | dead |
| docs/08_PERSONA_TAXONOMY_AND_ADAPTIVE_UX.md | 73 | Persona taxonomy: 73 persona files plus the Z1 fallback, the A–K schema, research waves | live |
| docs/09_MASTER_ADAPTATION_MODEL.md | not read | Master model that the persona specs inherit from | unknown |
| docs/compliance/MENSTRUAL_SAFETY_THRESHOLDS.md, CRISIS_RESOURCES.md, HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md | not read | Cited by persona specs; all three exist | live |
| docs/personas/ (73 files, 23,589 lines in total) | per file 200–420 | One spec per persona. Count by track: A 6, B 19, C 16, D 17, E 7, F 6, X 2 | live |
| docs/personas/A2_teen_newly_menstruating.md | 295 | Read in full | live |
| docs/personas/B1_general_cycle_tracker.md | 312 | Read in full | live |
| docs/personas/B6_pcos_not_ttc.md | 289 | Read in full | live |
| docs/personas/C6_ttc_pcos.md | 323 | Read in full | live |
| docs/personas/D1_pregnancy_uncomplicated.md | 306 | Read in full | live |
| docs/personas/F2_menopause_postmenopause.md | 353 | Read in full | live |
| docs/personas/C1_ttc_general.md (the TTC spine) | not read | Only its registry record and the taxonomy line were read | unknown |

### 2g. Persona registry (the specs as data, web only)

| path | lines | one-line purpose | status |
|---|---|---|---|
| apps/web/src/lib/experience/registry/index.ts | part of 1,865 | Joins the tracks into one registry | live |
| registry/track-a.ts (A1, A2) | — | Track A records | live |
| registry/track-b.ts (B1, B5, B6) | — | Track B records; header cites B1 and B6 | live |
| registry/track-c.ts | 188 | Track C records: C1, C2, C3, C6, C8. C6 default home list holds one module (line 144) | live |
| registry/track-d.ts (D1, D2, D3, D4, D7) | — | Track D records | live |
| registry/track-e.ts (E1, E2, E3, E4, E6, E7) | — | Track E records | live |
| registry/track-f.ts (F1, F2) | — | Track F records | live |
| registry/track-z.ts (Z1) | — | Fallback record | live |
| registry/track-d.test.ts | — | Test of track D (not read) | live |
| apps/web/src/lib/fertility/index.ts | — | Logging-only fertility library; comment says it has no ovulationDay, thermalShift or phase | live |
| apps/web/src/lib/fertility/index.test.ts | — | Test that forbids ovulationDay, thermalShift and isFertile (lines 35–41) | live |
| scripts/persona-branch-lint.mjs | 142 | Fails if a component compares against a persona ID. Passes now | live |

## 3. Key modules and responsibilities

1. **femio.tokens.css** (canonical). Input: none, hand-edited. Output: CSS custom properties. Read by: layout.tsx (imports `@femio/tokens/tokens.css`), globals.css, contrast.test.ts, generate-topic-art.mjs, tokens-to-dart.mjs, tokens-parity-lint.mjs, and the mockups by relative link. Checked.
2. **femio.tailwind.preset.js**. Input: CSS token names. Output: Tailwind theme (colour, radius, shadow, motion names). Read by: apps/web/tailwind.config.ts. Checked.
3. **apps/web/tailwind.config.ts**. Input: the preset. Output: working Tailwind config. Adds `/NN` opacity to token colours and replaces font families with the next/font variables. Checked.
4. **tokens-parity-lint.mjs**. Input: the CSS and the preset. Output: pass or fail. Guards 77 tokens in 11 families and the dark-mode redefinition of log, chart and confidence colours. Ran now: passes. Checked.
5. **tokens-to-dart.mjs**. Input: the CSS. Output: tokens.g.dart. Resolves `var()` chains and writes 191 colours, light and dark. Ran `--check`: fails, see R7. Checked.
6. **tokens.g.dart**. Input: generator output. Output: `FemioPalette.light` and `.dark`. Regenerated to scratch: identical after ignoring line endings (0 differing lines). Checked.
7. **femio_theme.dart**. Input: FemioPalette. Output: Material ThemeData for light and dark: colour scheme, text styles, button shapes. Type sizes are literals (R8). Checked.
8. **layout.tsx**. Input: locale. Output: `<html lang dir>`, four font variables, the tokens import. The place where the web chooses its fonts. Checked.
9. **globals.css**. Output: global rules, including the blanket reduced-motion override (lines 51–58) and the aurora class. Checked.
10. **manifest.ts**. Output: `/manifest.webmanifest` with name, colours and one SVG icon. Checked.
11. **topic-art.tsx + generate-topic-art.mjs**. The generator writes 10 SVGs to public/art from CSS tokens; topic-art.tsx shows them as background images at `/art/<topic>.svg`. Checked.
12. **Persona registry** (registry/index.ts and track files). Input: none at runtime. Output: an ordered list of modules and emphasis per persona, bundled into the web app. Read by the experience components (not traced further). 24 persona IDs present. Checked.
13. **lib/fertility**. Output: logging helpers. Its test is the line that keeps ovulation and fertile-window calculations out of the code. Checked.
14. **persona-branch-lint.mjs**. Guard that stops components from branching on persona IDs. Passes now. Checked.
15. **docs/personas/*.md**. Input: research. Output: specs cited by the registry comments and by future work. Not code. Checked.

## 4. Data flow

- **In.** No user data enters this area. Design values come from a person editing the CSS. Persona specs come from research passes, and each one ends with a "Reviewed" line (R17).
- **Stored.** In git only. Web fonts are downloaded at build time from Google Fonts and self-hosted by next/font (layout.tsx, tailwind.config.ts comment). Mobile fonts are bundled TTF files; the app makes no font request at run time (pubspec comment, checked).
- **Out.** Browsers fetch `/art/*.svg`, `/icons/app-icon.svg` and the manifest. Nothing in this area sends data to a server.
- **External services touched.** Google Fonts: at build time for the web; at view time for the mockups and brand-preview.html, which call fonts.googleapis.com and fonts.gstatic.com (checked, link tags). Vercel hosting: **From the docs**, not checked. No Sentry, PostHog or analytics in this area (checked by reading the files listed).
- **Registry.** Bundled with the web app. No runtime fetch found in the files read (**Hypothesis**: none exists).

## 5. Dependencies

- **Imports from elsewhere in the repo:** layout.tsx imports the tokens CSS through the package export; tailwind.config.ts imports the preset; femio_theme.dart imports tokens.g.dart; registry/track-c.ts names lib/fertility in its comments (checked); persona specs cite docs/compliance/* and docs/09 (all exist).
- **Imported or read by:** the web layout, globals.css, theme-provider.tsx, contrast.test.ts, topic-art.tsx, the six mockups (link), the root package.json gates (`tokens-parity-lint`, `tokens-dart-lint`, `persona-branch-lint`, all in the `gate` script), and the Flutter theme file.
- **Gate chain.** The root `gate` script, which the project runs before commits, includes tokens-parity-lint and tokens-dart-lint. The second one fails now (R7), so the gate as written does not pass on this branch. Checked.

## 6. Strings and i18n

- apps/web/src/app/manifest.ts:9–10 holds the app name and description in English only ("One account for a woman's whole health life."). One manifest serves all locales, so the Arabic install prompt shows English. Checked.
- apps/web/src/app/icon.svg:1–2 and assets/brand/logo/femio-app-icon.svg:1–2 have English `aria-label` and `<title>` ("Femio app icon (Bloom on warm surface)"). Low risk: these are not normally read aloud.
- Arabic display font differs by platform. The web's Arabic headline fallback is Noto Naskh Arabic (layout.tsx); the Flutter app has no Naskh file and falls back to IBM Plex Sans Arabic (pubspec, checked). Same design, two different Arabic headlines.
- femio_theme.dart contains no user-facing strings (checked).
- The mockups and brand-preview.html hold EN and AR copy by design (reference only).
- The brand rule that the wordmark is always the English "femio" (docs/12) is not enforced by any code or test I could find (**Hypothesis**: none exists).

## 7. Tests

**Run in this study (read-only), and the result:**

| check | result |
|---|---|
| `node scripts/design/tokens-parity-lint.mjs` | pass: 77 tokens, 11 families, dark redefinition OK |
| `node scripts/design/tokens-to-dart.mjs --check` | **fail**: "Dart tokens are stale". Content identical; the committed file has CRLF on all 782 lines and the generator writes LF (R7) |
| `node scripts/persona-branch-lint.mjs` | pass |
| `node scripts/tools-completeness-lint.mjs` | pass (outside this area; run for completeness) |

**Test files, not run here:** apps/web/src/lib/ui/contrast.test.ts (AA contrast of text tokens against every surface, read from the CSS); apps/web/src/lib/fertility/index.test.ts (boundary against ovulation and fertile-window fields); apps/web/src/components/experience/module-registry.test.ts and registry/track-d.test.ts (not read).

**Untested, checked by grep:**
- femio.tokens.json: no test or lint reads it (0 hits in apps/web/src, apps/mobile/test and scripts).
- Flutter theme: 0 test files reference FemioPalette or FemioTheme.
- Icons, manifest, favicons: no test.
- Dart type scale and spacing: no test.
- Reduced motion for the `--motion-*` tokens: none at token level (the CSS rule in globals.css covers it; see R10).
- Registry against spec text: no test ties a registry record to its spec (**Hypothesis**: none exists).
- Preset coverage of semantic colours: the parity guard checks only the families in its FAMILIES list; semantic colour names are not checked (see R19).

## 8. Smells, risks, dead code

- **R1. The primary logo and the app icon are still the retired v2 palette.** assets/brand/logo/femio-logo.svg, femio-logomark.svg, femio-logo-stacked.svg, femio-logo-mono.svg (ink #1E1B2E), femio-app-icon.svg; apps/web/src/app/icon.svg; apps/web/public/icons/app-icon.svg. Only femio-app-icon-dusk.svg and the 512 PNG carry Dusk Bloom. docs/12 names femio-logo.svg as primary. **Checked**. Risk: the website and PWA icon look like the old brand; the owner's Dusk decision is not carried into the logo.
- **R2. Manifest colours are v2.** apps/web/src/app/manifest.ts:14 `theme_color: "#7C3AED"` (retired violet; the file's comment calls it violet-600); :13 `background_color: "#FAFAF9"` (old surface; Dusk background is #FBF7F3). **Checked**.
- **R3. iOS and Android icons differ.** Android is Dusk (mipmap). The iOS AppIcon.appiconset 1024 px PNG is Flutter's default blue "F" on white (viewed). **Checked**. Risk: the store listing shows two different icons, and the iOS build ships the template.
- **R4. Splash screen is plain white.** apps/mobile/android/app/src/main/res/drawable/launch_background.xml uses `@android:color/white`. Dusk's ground is plum; the app flashes white before the first screen. **Checked**.
- **R5. The JSON mirror has drifted.** femio.tokens.json: shadows use rgb(30 27 46) (lines 633–641; CSS uses rgb(36 20 31)); phase.ovulatory is #F59E0B (line 466) while the CSS is saffron-500 #C08A2E (femio.tokens.css:251) and dark saffron-300 (line 381); the font families are Inter and Fraunces; only 151 values exist, and there are no log, chart, confidence, skin, aurora, gradient, motion-pairing, stroke or z-index tokens. The file header calls it a "machine-readable mirror". **Checked**.
- **R6. Tailwind preset font names are v2.** femio.tailwind.preset.js:59 `sans: ['Inter', …]`, :60 `display: ['Fraunces', …]`. The web config overrides them (tailwind.config.ts), so the live site is right, but any other consumer of the preset gets the old fonts. **Checked**.
- **R7. The Dart gate fails because of line endings.** Committed tokens.g.dart has CRLF on all 782 lines (`git show HEAD:…` count). The generator writes `lines.join("\n")` (tokens-to-dart.mjs:118) and writes LF (line 134). After ignoring CR, the regenerated file matches exactly. Fix: write CRLF, or compare with line endings normalised. **Checked**.
- **R8. Dart type scale is not from tokens and is off-scale.** femio_theme.dart:55–64 uses 34, 28, 24, 20, 17, 16, 15, 13 px. The CSS scale (fs-*) is 12, 14, 16, 18, 22, 28, 36, 48, 60, 72. The body styles are 17 (line 60), 15 (line 61) and 13 (line 62), and docs/12 says body text is 16 px minimum. **Checked** (code) and **From the docs** (rule).
- **R9. Dart has no spacing, radius or motion tokens.** 75 lines in apps/mobile/lib use literal `EdgeInsets`, `BorderRadius.circular` or `Duration(milliseconds:)` (grep count). **Checked**.
- **R10. The reduced-motion claim is only partly true at token level.** femio.tokens.css:429–431 zeroes the `--dur-*` family only. The `--motion-*` family (lines 119–137) is not zeroed. globals.css:51–58 covers both with a blanket rule, so browser behaviour is right, but docs/12 and 25 §5a say the tokens collapse. Also `--dur-instant` is 80 ms (line 113) while `--motion-instant` is 100 ms (line 130): two different values for the same idea. **Checked**.
- **R11. Stale comments and docs.** femio.tokens.css:343 says "Surface #17151F, cards #211E2E"; the real values are #140D14 and #1E1520 (line 67). globals.css:64 and docs/12 mention a Capacitor wrap (ADR-060 moved the mobile app to Flutter). docs/12's colour and type tables are v2. **Checked**.
- **R12. Duplicate token sets.** brand-preview.html:12–34 holds a full v2 set (violet 50–950, raspberry, teal). femio_personalized_screens.html:11–14 holds a second `:root`. Risk: these drift away from the canonical file, and a reviewer can pick the wrong one. **Checked**.
- **R13. Icon and social set is missing parts.** Checked absent: `favicon.ico`; PNG 16 and 32 px; `apple-touch-icon` PNG 180 px (web); PNG 192 and 512 px for the manifest; a maskable icon (one whose safe area survives circle cropping); an Open Graph / Twitter preview image (layout.tsx:75 sets openGraph and a twitter card with no image, so shared links will show no picture). The manifest lists one SVG with `sizes: "any"`. **Checked**. **Hypothesis**: Chrome's install prompt expects PNG icons; this needs a check against current browser rules before the manifest is redone.
- **R14. Android launcher is legacy-only and not generated.** mipmap PNGs at 48–192 px only. No `mipmap-anydpi-v26` adaptive icon (no foreground and background layers, no monochrome icon). No flutter_launcher_icons entry in pubspec.yaml. So the icon set cannot be regenerated from source. **Checked**.
- **R15. Spec and code disagree on the wedge's core feature.** C6 §E P0-1 and P0-2 and §G ask for a fertile-window predictor and an "ovulation-confirmation engine" (BBT shift, cervical mucus, progesterone and PdG logs). lib/fertility/index.test.ts:35–41 forbids `ovulationDay`, `thermalShift` and `isFertile`. track-c.ts header says the track surfaces "logging and awareness", with the approved wording kept elsewhere. Neither document answers whether a window may be shown, and the code forbids the thing the spec makes its hero. **Checked** on both sides; the decision is the owner's (§10 Q2).
- **R16. The C6 registry record is thin.** track-c.ts:140–144: the default home list has one module, `ttc.conditionContext` with condition "pcos". The spec's hero (confirmation card or honest "no window" prompt), the confirmation layer and the dual visit-prep pack are not in that record. **Checked** (the record as read).
- **R17. Registry gaps on the wedge and on safety.** The registry has 24 persona IDs: A1, A2, B1, B5, B6, C1, C2, C3, C6, C8, D1, D2, D3, D4, D7, E1, E2, E3, E4, E6, E7, F1, F2, Z1. Missing: C4, C5 (recurrent loss), C7, C9–C16 (including C10, the ART route that C6 §J names), D5 and D6 (chronic hypertension and pre-eclampsia, the pregnancy safety pair), D8–D17. **Checked**. Also, my earlier memory note that personas are "write-only" is out of date: the web registry encodes 24 of the 73.
- **R18. Flutter does not read the registry.** apps/mobile/lib has no file that imports the registry; the only "experience" hit is a comment in log_vocabulary.g.dart. ADR-060 wants both clients to render one served document. **Checked**. **Hypothesis**: the registry is web-only by design for now.
- **R19. Colour tokens are not all guarded or mapped.** The parity guard checks the families in its list (radius, stroke, ease, motion, log, chart, confidence, skin, gradient, shadow, z) and not the semantic colours. Seven semantic colours have no Tailwind name: `--divider`, `--overlay-scrim`, `--frost`, `--state-hover`, `--state-press`, `--focus-ring`, `--card-shadow` (preset lines 13–56). Aurora and art tokens are CSS-only by design. **Checked**.
- **R20. Two sources for one value.** Line heights live in both the CSS `--lh-*` tokens and the preset's font-size tuples (preset lines 65–74). Small, but a change to one will not reach the other. **Checked**.
- **R21. Heading font rule points at the wrong font.** docs/25 §5a says "Never Fraunces below 22 px". The live web layout uses Newsreader for display (layout.tsx, font variables near lines 29–35), not Fraunces. The rule is about a font the app no longer uses. **Checked** (code) and **From the docs** (rule).
- **R22. Dead concept files.** concept-bloom.svg, concept-lune.svg, concept-venus.svg and femio-logo-concepts.html. Referenced only by docs/12 (checked by grep). Kept as record; owner to decide.

## 9. Keep / rebuild / delete verdict

### Verdicts

**Token system: incomplete and inconsistent across the four layers.** The CSS is complete and well guarded: 297 names, 90 primitive colours, the dark block, a parity guard that passes, and a complete Dusk Bloom palette in both themes. The other three layers drift from it. The JSON mirror is partial and has old values (R5). The Tailwind preset is right except its font names and seven semantic colours it does not map (R6, R19). The Dart file's colours match the CSS in content, but the gate fails on line endings (R7), and Dart has no type, space, radius or motion tokens (R8, R9).

**Icon and favicon set: missing and mixed.** Missing: favicon.ico, PNG 16 and 32, apple-touch-icon 180, manifest PNG 192 and 512, a maskable icon, and an OG preview image (R13). Mixed: the web and brand icons are v2; the Android icon is Dusk; the iOS icon is Flutter's template (R3); the splash is white (R4). The only Dusk icon source is femio-app-icon-dusk.svg and its 512 PNG.

**Personas for the wedge: C6 and D1 matter most, with C1 as the spine.** See the table below. The specs ask for a window-or-no-window predictor, two-signal ovulation confirmation, a PCOS-aware seek-help threshold, a GA-driven pregnancy home, red-flag boxes and country-aware emergency routing. Several of these are not in the registry, and one (fertile windows) conflicts with the code (R15, R16, R17).

### Persona demands (the wedge)

Every spec follows the same A–K schema (checked in all six): **A** persona snapshot; **B** needs and questions in the user's own words; **C** competitor teardown; **D** clinical grounding with citations; **E** feature set, ranked P0 (must ship), P1, P2; **F** content modules; **G** tools, logs and alerts with compliant wording; **H** data fields, core versus persona-specific; **I** personalisation rules from the onboarding wizard to the home screen; **J** adaptation triggers (state changes); **K** compliance flags. Each also has a Sources list. Terms: OPK = ovulation test strip; BBT = basal body temperature; PdG = a progesterone by-product measured with home monitors; DPO = days past ovulation; TWW = two-week wait; GDM = gestational diabetes; OGTT = glucose drink test; LMP/EDD = last period date and due date; IOM = US weight-gain ranges; ART = assisted reproduction such as IVF; RPL = recurrent pregnancy loss.

| persona (file) | what the app must do for her | conflicts or gaps found |
|---|---|---|
| **C6 TTC with PCOS** (C6_ttc_pcos.md, 323 lines) | Show a confidence-flagged window or say "no confident window this cycle" (never a single day). Log and interpret confirmation signals: BBT shift, cervical mucus, mid-luteal progesterone (value, unit, lab or monitor source), PdG results. Flag PCOS ambiguity on OPK entries (a positive strip is a surge, not proof of ovulation). Long-cycle TTC home with DPO anchored to confirmed ovulation. Medication education only, no dose, clinician routing on every card. Routing to clinician evaluation sooner than the 12-month clock. One visit-prep export for both the OB and the endocrinologist. Consent-gated partner view. "Not a method of birth control" wording on every predictive surface. Handover to pregnancy (GDM-aware) or to ART with all data kept. Strict retention for OPK and hirsutism photos. | Window and BBT confirmation conflict with lib/fertility's test (R15). Registry record is one module (R16). The C10 (ART) route is not encoded (R17). |
| **D1 uncomplicated pregnancy** (D1_pregnancy_uncomplicated.md, 306 lines) | Gestational age computed from LMP or EDD, and it drives the home screen. Week card with real cm and grams, with a metaphor as an option. Referenced library with nothing locked. Appointment and checklist tracker, with user-entered results labelled "as recorded by user". Weight band from IOM ranges, presented as guidance and never as pass or fail. Persistent red-flag box, auto-inserted on relevant articles, with "seek care now" wording and the country selector (no hard-coded emergency number). Kick counter from about week 28 and contraction timer late in the third trimester, both labelled tracking aids. Read-mostly partner view. Loss handler that stops reminders at once. No ad SDK, no employer visibility. | D5 and D6 (hypertension, pre-eclampsia) are not in the registry, though the spec routes to them (R17). D3 (GDM) is encoded. |
| **C1 TTC general** (spine; not read in full) | Hero is the TTC window (the registry shows `ttc.window`). The window's wording must match the owner's decision in §10 Q2. | Only the registry record and taxonomy line were read. |
| **B6 PCOS not TTC** (B6_pcos_not_ttc.md, 289 lines) | Range-based cycle view with no "late" counter. Symptom-cluster log (acne, hair, mood, energy, cravings, weight optional). Visit-prep pack. Fertile-window widgets hidden by default. Long-gap prompt at 90 days. | Feeds C6 via the TTC switch; registry has B6. |
| **B1 general tracker, the hub** (B1_general_cycle_tracker.md, 312 lines) | Logging in five seconds. Range prediction. Phase insight. Non-TTC default. Core features free (no paywall ambush). Export and delete. | Hub for every branch; registry has B1. |

Out of the wedge, read for context only: A2 teen (295 lines; teen mode, no ads, shared-device discretion) and F2 menopause (353 lines; postmenopausal bleeding is always a clinician-check red flag).

### Per-module verdict (one line each)

- femio.tokens.css: **keep**. Canonical; fix the dark comment (R11) and the `--dur-instant` clash (R10).
- femio.tokens.json: **rebuild** as generated output from the CSS, with a parity test. Today it misleads (R5).
- femio.tailwind.preset.js: **keep**; replace Inter and Fraunces with the live families; map the seven unmapped semantic colours (R6, R19).
- tokens-parity-lint.mjs: **keep**; extend to semantic colours and to the JSON mirror.
- tokens-to-dart.mjs: **keep**; fix the line-ending comparison (R7); later add type, space, radius and motion output.
- tokens.g.dart: **keep** (generated).
- femio_theme.dart: **rebuild** the type block to read the scale (R8); add spacing, radius and motion getters (R9).
- layout.tsx and tailwind.config.ts: **keep**; the font choice is right for the live app.
- globals.css: **keep**; remove the Capacitor comment (R11).
- contrast.test.ts: **keep**; the best guard in the area. Run it in CI and check the output (not run here).
- brand-preview.html: **delete** after owner approval (R12); it is a second token source.
- femio_personalized_screens.html: **rebuild** on the canonical tokens, or **delete** after approval (R12).
- R1.3–R1.8 mockups: **keep as reference**; replace hard-coded hex with `var()` references, and the Fraunces and Inter links with the live fonts (R12).
- Logo SVGs (femio-logo, logomark, stacked, mono): **rebuild** in the Dusk palette (R1). Blocked on the owner's logo decision (§10 Q1).
- femio-app-icon-dusk.svg and the 512 PNG: **keep**; they are the source for every icon.
- femio-app-icon.svg, apps/web/public/icons/app-icon.svg, apps/web/src/app/icon.svg: **rebuild** from the Dusk source (R1), and make the web copies one file.
- concept-bloom, concept-lune, concept-venus, femio-logo-concepts.html: **delete** candidates after owner approval (R22). Kept as record for now.
- femio-logo-lockups.html: **keep**; update the colours with the logo.
- manifest.ts: **rebuild**: Dusk colours (R2), PNG 192 and 512 and maskable icons (R13), localised name and description (§6).
- Web favicon and OG image: **add** (R13). Not present.
- iOS AppIcon set: **rebuild** from the Dusk 1024 source (R3).
- Android mipmaps: **keep**; **add** an adaptive icon and a generator script (R14).
- launch_background.xml: **rebuild** to Dusk (R4).
- art/*.svg and generate-topic-art.mjs: **keep**; the most Dusk-faithful assets in the set.
- Persona specs (73): **keep**. Re-check the six read in full against the registry before the wedge build.
- docs/12_BRAND_DESIGN_TOKENS.md: **rebuild** against the CSS (R11), otherwise it misleads the next reader.
- docs/25 §5a: **keep the rules, move them to a live doc**; fix the Fraunces rule (R21).
- registry track files: **keep**; **extend** for C5, C10, D5, D6 and the missing C and D records, and for the C6 hero (R16, R17).
- lib/fertility and its test: **keep** the boundary until the owner decides §10 Q2.

## 10. Open questions

1. **Is the Dusk Bloom mark final for the logo?** If yes, the wordmark and mark files need rebuilding (R1). If no, the Android icon and token file need a decision too.
2. **May the app show a fertile window and a thermal-shift confirmation?** The C1 and C6 specs say yes, with uncertainty and "not contraception" wording; lib/fertility's test says no. This is the medical-device and contraception line, so it needs the owner's written decision before the TTC wedge is built (R15).
3. **Which font is canonical for display: Newsreader or Fraunces?** The live app uses Newsreader; docs/12, the mockups and the 25 §5a rule use Fraunces (R21).
4. **Is 13 and 15 px body text acceptable on Android?** docs/12 says 16 px minimum; femio_theme.dart uses 13 and 15 (R8).
5. **Who is "Mohamed K." in the persona review lines?** Every spec says "Reviewed Mohamed K.". Is this the named clinical reviewer, and does that review cover C6, D1 and B6 (the medical-content rules require a reviewed, cited source)? Not verified in this study.
6. **Which of the missing personas must be in the registry before the wedge ships?** My suggestion: C5, C10, D5 and D6, because the wedge's pregnancy handoff and pre-eclampsia awareness depend on them (R17). Owner to confirm.
7. **Should the Flutter app read the registry or its own copy?** ADR-060 implies one served document for both clients; today only the web reads it (R18).
8. **Archive or delete the concept logos and brand-preview.html?** Both are dead weight in a repo that is meant to hold one source (R12, R22).
9. **Does the iOS launch screen and icon need Dusk before the next store build?** Yes is my reading; needs a decision (R3, R4).

## Not done in this study

- I did not run the test files (contrast, fertility, registry). They are listed as present but not executed.
- I did not read C1, D3, D5, D6, docs/09 or the three compliance docs. Their use is inferred from links and registry records only.
- I did not check Vercel's hosting or any server-side code; this area has none.
- I did not verify the browser rules for manifest icons or the Google Fonts licence terms; both are marked as hypotheses.
