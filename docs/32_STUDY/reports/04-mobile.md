# Study report 04 — the Flutter Android app (`apps/mobile/**`)

Reader: Khaled (clinician, not a programmer). Labels: **Checked** = I read the file or counted it; **From the docs** = a repo document says so; **Hypothesis** = my reading. **Run result (Checked, 2026-10-27):** I ran `flutter pub get`, `flutter analyze` and `flutter test` on a copy of `apps/mobile` in a scratch folder (Flutter 3.47.8, Dart 3.13.7, this Windows machine): **analyze reported no issues; all 61 tests passed** (this is a synthetic-fixture result: the code does not break; it says nothing about real use). Nothing in the repo was changed by that run. I did not run the app on a phone or emulator, so screens were judged from code and tests, not by eye.

## 1. Purpose in one paragraph

`apps/mobile` is the Femio Android app (Flutter, application ID `com.femioapp.femio`, version 0.4.0+4). It is the product the 2026-10 revamp chose (D7/D8/ADR-070): a private tracker whose records live on the phone, with no account and no network use. In its current state it does onboarding in under a minute, then three tabs (Today, Calendar, Log) in four languages (Arabic, English, French, Spanish; Arabic is right-to-left). It has period and fertile-window prediction as ranges with a confidence word, a TTC toolkit (ovulation-test log, waking-temperature chart, pregnancy-test timing), and four pregnancy tools (movement log, contraction timer, appointments, weight log). Its maths are Dart copies ("twins") of TypeScript code on the website, held together by shared JSON test files. It is a clean, honest first build of roughly 3,100 hand-written Dart lines. It is not yet a shippable product: it has no backup, no app lock, no reminders, no settings, no in-app articles, no Hijri dates, no crash reporting, and the release build is still signed with the debug key.

## 2. Inventory table

All 113 tracked files were listed with `git ls-files`. Line counts are `wc -l`. "(gen)" marks generated files.

### lib/ (Dart)

| path | lines | purpose | status |
|---|---|---|---|
| `lib/main.dart` | 17 | Entry point; loads the saved record; pins Arabic to Western digits (ADR-069) | live |
| `lib/app.dart` | 92 | `FemioController` (the one state object) + `FemioApp` (MaterialApp, locales, light/dark) | live |
| `lib/data/store.dart` | 66 | `FemioStore` interface; `FileStore` (one JSON file); `MemoryStore` (tests) | live |
| `lib/data/profile.dart` | 217 | `Profile`, `DayLog`, enums; JSON in/out | live |
| `lib/domain/dates.dart` | 37 | ISO-date helpers in UTC; the `toISO` timezone fix | live |
| `lib/domain/cycle_prediction.dart` | 169 | Next-period window + confidence (twin of `web/lib/cycle/predict.ts`) | live |
| `lib/domain/fertility.dart` | 20 | Fertile window = 14 days before predicted period (twin) | live |
| `lib/domain/pregnancy.dart` | 77 | Gestational age, trimester, due date from LMP / conception / IVF (twin) | live |
| `lib/domain/contractions.dart` | 103 | Contraction duration and interval averages, no labour verdict (twin) | live |
| `lib/domain/movements.dart` | 82 | Fetal-movement pattern against her own median (twin) | live |
| `lib/domain/weight.dart` | 89 | Weight chart geometry, no target band (twin) | live |
| `lib/domain/bbt.dart` | 77 | Temperature chart geometry, no shift or ovulation marker (twin) | live |
| `lib/domain/appointments.dart` | 95 | Appointment sorting and "results due" (twin) | live |
| `lib/domain/day_marks.dart` | 49 | What each calendar day shows (facts vs estimates). App-only, no web twin | live |
| `lib/domain/log_vocabulary.g.dart` | 72 | (gen) the 51 loggable terms, flow levels, OPK results | live |
| `lib/features/home/home_shell.dart` | 62 | Bottom navigation: Today / Calendar / Log | live |
| `lib/features/onboarding/onboarding_flow.dart` | 589 | The 11-step onboarding state machine and all its screens | live |
| `lib/features/onboarding/widgets.dart` | 260 | `StepScaffold`, `OptionTile`, `NumberStepper`, `DateCard` | live |
| `lib/features/today/today_screen.dart` | 478 | Today: hero card per goal, TTC cards, pregnancy tool list, "Start over" | live |
| `lib/features/calendar/calendar_screen.dart` | 190 | Month grid with logged vs predicted marks | live |
| `lib/features/log/log_screen.dart` | 317 | One-day log: flow, mood, symptoms, discharge, OPK, temperature | live |
| `lib/features/pregnancy/contraction_timer_screen.dart` | 211 | Start/stop timer, summary, last 12 | live |
| `lib/features/pregnancy/movement_log_screen.dart` | 129 | Tap-counter sessions and pattern notice | live |
| `lib/features/pregnancy/appointments_screen.dart` | 294 | List + editor (type, clinician, time, questions, results-due) | live |
| `lib/features/pregnancy/weight_screen.dart` | 178 | Weight entry, chart, history | live |
| `lib/widgets/readings_chart.dart` | 94 | CustomPaint dot chart used by weight and temperature | live |
| `lib/widgets/bbt_chart.dart` | 48 | Temperature card wrapper | live |
| `lib/widgets/notice_card.dart` | 48 | Urgent / caution / quiet boxed notice | live |
| `lib/widgets/bloom.dart` | 69 | The logo mark drawn in code | live |
| `lib/theme/femio_theme.dart` | 122 | Material 3 theme from the palette; fonts; button shapes | live |
| `lib/theme/tokens.g.dart` | 782 | (gen) 191 colours x light/dark from the web token CSS | live |
| `lib/l10n/app_en.arb`, `app_ar.arb`, `app_fr.arb`, `app_es.arb` | 429 / 249 / 249 / 249 | The strings: 247 keys per language | live |
| `lib/l10n/app_localizations.dart` + `_en`, `_ar`, `_fr`, `_es` | 1622 / 912 / 944 / 918 / 912 | (gen) Flutter's generated string classes | live |
| `lib/l10n/log_labels.g.dart` | 78 | (gen) term key to localised label | live |

### test/

| path | lines | purpose | status |
|---|---|---|---|
| `test/golden_fixtures_test.dart` | 152 | Runs 8 shared JSON fixtures through the Dart twins; fails if a fixture file has no runner | live |
| `test/screens_test.dart` | 271 | Widget walk-throughs at 390x844, en/ar, light/dark; saves screenshots only with `--update-goldens` | live |
| `test/day_marks_test.dart` | 43 | Calendar facts vs estimates; save/load round trip | live |
| `test/dates_test.dart` | 21 | The `toISO` timezone fix | live |

### Config, build, assets

| path | lines | purpose | status |
|---|---|---|---|
| `pubspec.yaml` | 45 | Version 0.4.0+4; 2 runtime packages (`path_provider`, `intl`) + Flutter SDK; bundled fonts | live |
| `pubspec.lock`, `l10n.yaml`, `analysis_options.yaml` (34, stock `flutter_lints`), `README.md` (23), `.gitignore`, `.metadata` | - | tooling | live |
| `android/app/build.gradle.kts` | 49 | App ID, SDK levels from Flutter, release signed with the debug key (lines 34-36) | live |
| `android/app/src/main/AndroidManifest.xml` | 45 | No permissions declared; no backup settings | live |
| `android/app/src/debug/` and `profile/AndroidManifest.xml` | 7 each | INTERNET permission, for Flutter dev tooling only | live |
| `android/` rest (Gradle wrapper and settings, `MainActivity.kt`, launch backgrounds, 5 launcher icons, 2 styles XML) | ~16 files | Standard Flutter scaffold + Dusk Bloom icon | live |
| `assets/fonts/` (9 files) | - | Newsreader, Plus Jakarta Sans, IBM Plex Sans Arabic (4 weights) + 3 OFL licences; bundled, no runtime fetch | live |
| `ios/` (36 files: Runner, storyboards, icons, Xcode project, `RunnerTests.swift`) | - | Flutter's default iOS scaffold; never built or tested; ADR-060 puts iOS later | dead (scaffold) |

### Outside `apps/mobile` but part of the mobile system (Checked)

| path | lines | purpose | status |
|---|---|---|---|
| `fixtures/domain/*.json` (12 files, 69 KB) | - | Shared expected values. Dart runs 8 of them (35 cases); 4 (`phase`, `persona-resolution`, `signals-from-rows`, `experience-config`) are listed "not yet ported" | live |
| `scripts/design/tokens-to-dart.mjs` | 136 | CSS tokens to `tokens.g.dart`; `--check` is a CI gate (`tokens-dart-lint`) | live |
| `scripts/mobile/sync-log-vocabulary.mjs` | 257 | Web vocabulary + web message catalogues to Dart terms, labels and ~75 shared ARB strings in 4 locales; `--check` is a gate (`mobile-vocab-lint`) | live |
| `docs/30_REVAMP/04_ANDROID_APP_SPEC.md` | 120 | The spec the app is measured against in section 9 | live |

## 3. Key modules and responsibilities

1. **`FemioController` (`lib/app.dart`).** One `ChangeNotifier` holding the `Profile` and the language. Input: a `FemioStore`. Every screen does `controller.save(profile.copyWith(...))`, which writes the whole file and notifies listeners. It also owns "reset" (wipe). Simple and adequate for v1.
2. **`Profile` / `DayLog` (`lib/data/profile.dart`).** The entire record: goal, birth year, bleed days, daily logs by ISO date, contractions, movement sessions, weights, appointments. Pure data plus `toJson/fromJson`. `withDayLog` keeps `periodStarts` in step with logged flow.
3. **`FileStore` (`lib/data/store.dart`).** Writes `femio-record.json` to the app's private support directory via write-temp-then-rename. The only persistence in the app.
4. **`cycle_prediction.dart`.** Groups logged bleed days into periods (10-day merge), averages the last 6 cycles, gives a window of plus/minus max(2, half the spread) days and a high/medium/low confidence. With fewer than two periods it falls back to her stated length (21-35) plus/minus 4 days, always "low". Called by Today and `day_marks`.
5. **`day_marks.dart`.** Turns a profile into per-day booleans (bleed, spotting, logged, predicted, fertile, ovulation); estimates only from today forward. Called by Calendar. It imports `data/profile.dart`, so the domain layer depends on the data layer (small layering inversion).
6. **`onboarding_flow.dart`.** Steps: welcome, goal, birth year, (under-18 stop), last period, period length, cycle length, trying-for, due-date method, due date, menopause last period. Builds the `Profile` in `_finish()`. The progress bar is derived from the path for the chosen goal.
7. **`today_screen.dart`.** The hero card differs by goal (fertile window, next period, pregnancy week, months since last period, weeks postpartum). Also holds the "see a clinician" nudge rule, the pregnancy-test timing card and the pregnancy tool list (contractions first from week 36).
8. **`calendar_screen.dart` and `log_screen.dart`.** Calendar draws facts filled, estimates outlined. Log saves on every tap; the vocabulary is generated, so every term is available whatever the goal (product rule 2).
9. **Pregnancy tools (4 screens + 4 domain files).** Each carries an urgent "call your maternity unit" notice above the tool. By design none gives a verdict: no labour test, no kick target, no weight band.
10. **`femio_theme.dart` + `tokens.g.dart`.** `context.palette` gives named colours (for example `p.primarySolid`); no screen writes a hex colour. 191 tokens are generated; the app uses a fraction.
11. **`log_vocabulary.g.dart`, `log_labels.g.dart`, `app_*.arb`.** Generated from the website so the term list and wording cannot drift.
12. **`golden_fixtures_test.dart`.** The twin-logic enforcer (next subsection).

### How the twin-logic discipline works (Checked)

The same maths exist twice: TypeScript on the website (`apps/web/src/lib/...`) and Dart in the app. To stop them drifting, the expected answers are written once as JSON in `fixtures/domain/*.json` (input and expected output per case). `apps/web/src/lib/golden-fixtures.test.ts` loads them for TypeScript; `test/golden_fixtures_test.dart` loads the same files for Dart. Each Dart file's header names its TypeScript twin. A rule in the Dart test fails if someone adds a fixture file and neither wires it up nor lists it as deferred, so nothing is skipped silently. Two generators do the same job for non-maths content: `tokens-to-dart.mjs` (colours) and `sync-log-vocabulary.mjs` (log terms plus ~75 clinician-reviewed strings copied from the web message files); both have `--check` modes run as gates, so a stale generated file fails the build.

Weaknesses: the fixtures are thin (7 cases for cycle prediction, 2 for appointments) and prove only that the two copies agree on those cases, not that either is right. The discipline also exists only because there are two clients of the maths; once the website is a static teaser, the TypeScript twins matter only for the web calculators.

## 4. Data flow

**Enters:** only what she types or taps (onboarding answers, day logs, timers, appointments, weights) plus the device clock and locale. **Checked:** no code in `lib/` opens a network connection; the only runtime packages are `path_provider` and `intl`; the release manifest declares no permissions (INTERNET appears only in the debug and profile manifests, which Flutter adds for hot reload).

**Stored:** one file, `<app support dir>/femio-record.json`, holding the whole `Profile` as plain JSON, rewritten on every tap. The schema is stamped `"v": 1`, but the version is never read back. **Not encrypted by the app.** `store.dart:17-19` says Android sandboxes the file and encrypts it at rest through the phone's file-based encryption, and that Keystore encryption and an app lock "come with P3.8". That protects a locked phone; it does not protect against someone who unlocks it, or against a backup.

**Leaves:** nothing by design, with one likely exception. **Hypothesis (high likelihood):** the manifest sets neither `android:allowBackup="false"` nor data-extraction rules (grep found neither), and Android's default is to include app files in Google Drive auto-backup. That would copy her record to her Google account, contradicting "never leaves the phone". There is no export, so she also has no way to take her data out herself.

**External services touched:** none at runtime (no Supabase, Vercel, Sentry, PostHog, CDN or Google Fonts; fonts are bundled). At build time the generators read from `apps/web` (messages and vocabulary) and `assets/brand/tokens`. CI uses the `subosito/flutter-action`.

**Date handling (Checked, `lib/domain/dates.dart`).** Dates are `YYYY-MM-DD` strings in the domain; arithmetic goes through UTC midnight, so daylight-saving never shifts a day. The bug fixed in commit `79a0e4f` (2026-10-27): Flutter date pickers return local midnight; the old `toISO` converted to UTC first, so on a phone east of UTC (Egypt, Saudi Arabia) a picked date came back one day earlier. The fix reads the `DateTime`'s own year, month and day fields in its own zone. Timestamps are stored differently by feature: contractions and movements as UTC ISO instants (shown with `.toLocal()`), appointments as zone-less local wall time (`2026-10-12T09:30`), everything else as plain dates. Each choice is reasonable, but they are not written down in one place.

**Weakness in the regression test:** `test/dates_test.dart` says its tests "hold in any time zone", but CI runs on `ubuntu-latest` (UTC), where local time equals UTC, so the old buggy code would also pass there. **Hypothesis** (from reading; I did not force a time zone to prove it): the test catches the bug only on a developer machine in an eastern time zone.

## 5. Dependencies

- **Imports from elsewhere in the repo (build time only):** `assets/brand/tokens/femio.tokens.css` (colours); `apps/web/src/lib/experience/v2/vocabulary.ts` and `apps/web/messages/{en,ar,fr,es}.json` (log terms and ~75 strings, through the sync script); `fixtures/domain/*.json` (tests). The Dart code itself imports nothing outside `apps/mobile`.
- **Imported by:** nothing. The web app does not import the app. Root `package.json` has two lint scripts (`tokens-dart-lint`, `mobile-vocab-lint`), and CI has the `verify-mobile` job.
- **Reverse coupling to watch:** if `apps/web` is slimmed to a static teaser or its message files are restructured, `sync-log-vocabulary.mjs` breaks (it throws on a missing web string path) and the app loses the source of its shared Arabic wording. Decide which side owns that wording before touching the web messages.
- **Pub packages:** `path_provider 2.1.6` (pinned), `intl: any`, `flutter_localizations`, `flutter_lints ^6.0.0`. Small and sensible; no analytics, ads or crash SDK.

## 6. Strings and i18n

- **Catalogue:** 4 ARB files with **247 message keys each and no missing or extra keys between locales** (Checked with a script). `en` also carries 25 `@key` placeholder blocks (it is the template). Arabic uses proper ICU plural forms (`=1`, `=2`, `few`, `other`), for example `daysValue`.
- **Same as English:** only brand or unit strings (`appTitle`, `rangeValue` in all; `weightUnitKg/Lb` in fr and es) and a few French words that are genuinely identical (`logConstipation`, `logFatigue`, `logIrritable`, `logSpotting`, `legendSpotting`). Nothing looks left untranslated by accident.
- **Arabic quality, 28 keys spot-checked (Checked by reading; I am not a native reviewer, so a native clinician should still sign off):** natural Modern Standard Arabic, not machine-sounding. Feminine second person is used (`سجّلتِ`, `اتّصلي`), plural forms are right, the medical sentences are well built (`pregRedFlagsBody`, `contractionsContactBody`, `movementsUrgentBody`). Issues found:
  - `contractionsContactBody` glosses waters breaking as "ماء الرأس", which in everyday Arabic usually means hydrocephalus, not amniotic fluid. "نزول ماء الجنين" or just "نزول السائل الأمنيوسي" is safer. A clinical-wording question for the owner.
  - Mixed addressing: most strings use the feminine (`كنتِ`, `لكِ`) but `seeClinicianTtc` says `كان عمرك` and `movementsSlowerBody` ends `ليطمئن أحدهم عليك`.
  - The register is formal MSA throughout; the wedge markets (Egypt, Saudi) may prefer a lighter register on Today and onboarding. A product call.
- **Hard-coded user-facing strings (Checked by grep):** none of consequence. Intentional: the wordmark `'femio'` (`app.dart:71`, `onboarding_flow.dart:497`, `today_screen.dart:58`, always English by rule 6); `'—'` placeholders (`contraction_timer_screen.dart:165-166`, `appointments_screen.dart:236`); the `'36.5'` hint (`log_screen.dart:275`). **Real miss:** the stepper tooltips `'−'` and `'+'` (`widgets.dart:212,219`) are not localised, so a screen reader reads a bare symbol. The language names in `onboarding_flow.dart:482` are endonyms on purpose.
- **Digits:** Arabic is forced to Western digits (`main.dart:17`, ADR-069); the calendar's `'$day'` is consistent with that.
- **Hijri:** none (section 9).
- **RTL:** logical directions are used almost everywhere (`EdgeInsetsDirectional`, `AlignmentDirectional`); charts are deliberately left-to-right inside their own `Directionality`. `_CycleBand` and `_PregnancyBar` flip positions by hand with `left:` (`today_screen.dart`), which works but is where RTL bugs hide.

## 7. Tests

| file | what it covers | not covered |
|---|---|---|
| `golden_fixtures_test.dart` | Dart twins match 8 shared fixture files, 35 cases (cycle prediction 7, BBT 3, contractions 5, movements 5, weight 4, appointments 2, EDD-from 5, gestational age 4); guards against orphan fixture files | the 4 deferred fixtures (persona, phase, signals, experience config); fixtures are thin |
| `screens_test.dart` | Onboarding walk-through (TTC path only) in en/ar, light/dark; Today for 4 goals; calendar + log + temperature typo refusal; the 4 pregnancy tools end to end; asserts data lands in the saved record | under-18 stop; the period, pregnant (six due-date methods) and menopause onboarding paths; "Start over"; date pickers; postpartum |
| `day_marks_test.dart` | facts vs estimates; no estimate on past days; logging a bleed feeds the prediction; `Profile` JSON round trip | month boundaries; year rollover |
| `dates_test.dart` | `toISO` for local and UTC values | does not fail in UTC (section 4) |

**Untested entirely:** `FileStore` (no test that a saved record loads from disk, that a corrupt file is handled, or that two quick saves do not collide); `Profile.fromJson` on old or hostile data; the theme; layout assertions; accessibility semantics. Screenshots are produced only under `--update-goldens` and are not committed, so CI does not catch a visual regression. `screens_test.dart:40` loads `MaterialIcons` from `$FLUTTER_ROOT` with a default of `/root/sdk/flutter` (a Linux cloud-session path), (it still passed on this Windows machine, so `FLUTTER_ROOT` was set here; a machine without it would fail). The pregnancy test uses the real clock (documented in a comment), so it is not strictly reproducible.

## 8. Smells, risks, dead code

**Data safety (highest priority)**
1. **"Start over" wipes everything with one tap, no confirmation, and there is no backup.** `today_screen.dart:62-65`: the overflow menu's only item calls `controller.reset()` on selection, which deletes the file (`store.dart:47-50`). A mis-tap loses her whole record.
2. **A corrupt record is silently treated as "no record".** `store.dart:30-34` returns `null` on `FormatException`, so the app shows onboarding and her first save overwrites the old file. Other failures inside `Profile.fromJson` (a missing key, or an unknown enum value from a future version at `profile.dart:186`, `Goal.values.byName`) are not caught and would crash at launch (`main.dart:11`). Code is Checked; the crash itself is a **Hypothesis** (not executed).
3. **No schema versioning.** `'v': 1` is written (`profile.dart:166`) and never read. The first format change needs a migration path that does not exist.
4. **Probable save race (Hypothesis).** Every tap calls `save()`, which writes the same `.tmp` path and renames it. Two taps in quick succession start two overlapping writes to one temp file, and the second rename can fail. Nothing serialises saves.
5. **Likely cloud backup of the record** (section 4). Plaintext on disk apart from device encryption; no app lock; the spec called for SQLite + Keystore.
6. **The release build is signed with the debug key** (`build.gradle.kts:34-36`, the Flutter template TODO). It cannot go to Google Play like this.

**Product and logic**
7. **Settings do not exist, but the UI promises them.** `goalSub` says "You can change this any time", yet `Profile.copyWith` (`profile.dart:120`) cannot change goal, due date, birth date, cycle length, period length or the irregular flag, and there is no settings screen. The only way to change goal is "Start over". Language cannot be changed after onboarding either.
8. **Medical rules sit inside screens, against the repo's own architecture rule** (the backend decides, clients render). `today_screen.dart:199-200` holds the "talk to a clinician" nudge (over 12 months, or 6-12 months and age 35+); the pregnancy-test timing card and the week-36 reordering of the pregnancy tools are also decided in the widget. They belong in `domain/` with fixtures, so the website and app cannot disagree.
9. **Irregular cycles and PCOS depth are thin for the wedge.** `Profile.irregular` is stored but only used to show a note, and only when there is no prediction (`today_screen.dart:184`). The fertile window is still "14 days before the predicted period" (`fertility.dart`) even when cycles are irregular, which is when that assumption is weakest (**Hypothesis**, a clinical point for the owner). There is no PCOS entry point in the app.
10. **"Log period today" always writes flow `medium`** (`today_screen.dart:86`), overwriting a heavy or light flow already logged that day.
11. **Pregnancy to postpartum is a dead end.** After "I've had my baby" Today shows only "N weeks postpartum" (`today_screen.dart:220-223`); the pregnancy tools and the period button are hidden, and there is no postpartum tool.
12. **Pregnancy tools are reachable only through Today, only in the `pregnant` goal.** TTC users get no appointments or reminders; there is no Tools tab.
13. **The calendar's "logged" dot ignores days with only a temperature or ovulation test** (`day_marks.dart:30` checks `terms` only).
14. **Log date navigation is day-by-day arrows only** (`log_screen.dart:89-107`); no jump to a date.

**Code quality against Effective Dart and the repo's own standards**
15. **Hand-written files over about 300 lines:** `onboarding_flow.dart` 589, `today_screen.dart` 478, `log_screen.dart` 317; `appointments_screen.dart` 294 is on the line.
16. **File headers.** The repo rule is a short header on every file. Only about 6 of the 28 hand-written Dart files open with a true top-of-file comment (`profile`, `appointments`, `contractions`, `dates`, `movements`, `weight`). Many put the explanation after the imports, where it attaches to the first class (`bbt.dart:5`, `cycle_prediction.dart:5`, `fertility.dart:3`, `pregnancy.dart:3`, `day_marks.dart:6`); `main.dart`, `app.dart`, `store.dart`, `home_shell.dart`, most screens and `femio_theme.dart` have none at the top. `analysis_options.yaml` is the stock template: no extra lints.
17. **Docstrings.** The "why" comments, especially on medical reasoning, are excellent. Many public functions have none: `fromISO`, `isValidISODate`, `addDays`, `diffDays`, `unitOf`, `bbtChart`, `predictNextPeriod`, `pregnancyProgress`, `eddFromLmp`, `weightChart`, `FemioController.load/save/reset`, every `FemioStore` method. Inputs, outputs and failure cases are not documented as the global standard asks.
18. **Magic numbers.** The domain mostly uses named constants (`_statedMarginDays`, `_recentCycles`, `lutealPhaseDays`, `slowerRatio`). Misses: `cycle_prediction.dart:117` (21/35) and `:139-146` (2, 9, 6, 3, 4 confidence thresholds); `pregnancy.dart:43` (315), `:57-58` (98, 196), `:66` (266); `weight.dart:36` (25/300/55/660) and `:75` (2, 4); `fertility.dart:19` (5, 1); `today_screen.dart` (36 weeks, 35 years, `~/ 30` months at `:247`, 120 clamp); `onboarding_flow.dart` (age limit, year range, 120/300/365/400-day windows). In the UI, radii (16/18/20/24/28), paddings and font sizes (`fontSize: 48/32/15`) are inline literals everywhere: colours are fully tokenised, spacing and radius are not. `Colors.white` appears 15 times for text on the gradient.
19. **Widget / logic separation.** Good in the domain (no Flutter imports in `lib/domain`, except `day_marks` importing `data/profile`). Weak in `onboarding_flow.dart` (profile assembly and path logic live in a widget state and are untested) and `today_screen.dart` (rules in item 8). `FemioController` lives in `app.dart`, so `app.dart` imports the screens and every screen imports `app.dart`: a circular-looking import graph.
20. **Duplication.** The card decoration (surface, border, radius 24) is hand-written about 10 times; the list-row style, `DateFormat` locale boilerplate and tile helpers repeat across screens.
21. **Dead code:** none found in `lib/`. Dead scaffold: `ios/`. `MemoryStore` is used only by tests (reasonable). `FemioColors.lerp` snaps instead of interpolating (harmless).
22. **Gradle and manifest:** leftover template TODO comments (`build.gradle.kts:18,34`); SDK levels follow Flutter's defaults (what they resolve to was not checked); no R8/ProGuard or bundle settings.

## 9. Keep / rebuild / delete verdict

Judged against: a private Android app, records on the phone, no accounts; website as a static teaser; no Supabase at runtime; wedge = Arabic-first TTC to pregnancy with PCOS depth, Saudi and Egypt.

| module | verdict | reason |
|---|---|---|
| `domain/dates.dart` | **Keep** | Small and correct; the fix is right. Add a test that forces a time zone, and a header. |
| `domain/cycle_prediction`, `pregnancy`, `contractions`, `movements`, `weight`, `bbt`, `appointments`, `fertility` | **Keep** (name constants, add docstrings, grow fixtures) | Faithful twins with strong "never a verdict" reasoning. Revisit `fertility.dart` for irregular / PCOS cycles (needs clinical review). |
| `domain/day_marks.dart` | **Keep, small refactor** | Move it so domain does not import data. App-only; add year-boundary tests. |
| `data/profile.dart` | **Refactor** | Add schema version and migrations, defensive `fromJson`, editable fields (goal, due date, lengths), a conditions/PCOS flag and postpartum state. |
| `data/store.dart` | **Rebuild** | Needs encrypted storage (spec: SQLite + Keystore key, or at least an encrypted file), serialised saves, corruption quarantine (never silently overwrite), export/import. Keep the `FemioStore` interface. |
| `app.dart` (`FemioController`) | **Refactor** | Fine for v1; add settings, a load-failure state, language persistence, an app-lock gate. |
| `features/onboarding/*` | **Refactor** | The flow follows the spec well. Extract profile assembly into a tested domain function, split the 589-line file (one widget per step), add the reminders step, test all four goal paths. |
| `features/today/today_screen.dart` | **Refactor** | Split into hero per goal + tool list; move the clinician nudge and test-timing rules to `domain/` with fixtures; confirm before reset; add postpartum content. |
| `features/home/home_shell.dart` | **Refactor** | Add the tabs the spec lists (Learn, Tools, settings/backup). |
| `features/calendar/calendar_screen.dart` | **Keep** | Good fact-vs-estimate rendering; later add Hijri secondary label, a logged dot for any entry, jump to month. |
| `features/log/log_screen.dart` | **Keep, trim** | Works; split the chip and temperature field into widgets; add date jump. |
| `features/pregnancy/*` (4 screens) | **Keep** | The safe-by-design behaviour is the product's strongest asset. Add appointment reminders; reach them from a Tools tab. |
| `widgets/*` | **Keep** | Small and tidy; add spacing/radius tokens and a shared card widget. |
| `theme/*`, `tokens.g.dart` | **Keep** | Generated tokens are a real strength; `assets/brand/tokens` stays the source. |
| `l10n/*.arb` and generated classes | **Keep** | Four complete languages, good Arabic. Fix the items in section 6; decide who owns the shared wording once the web is a teaser. |
| `scripts/mobile/sync-log-vocabulary.mjs` | **Keep for now, flag** | Valuable while web messages are the reviewed source; becomes a liability if web messages are restructured or retired. |
| `scripts/design/tokens-to-dart.mjs` | **Keep** | Cheap and safe. |
| `test/*` | **Keep, extend** | Add FileStore, `fromJson`, the other onboarding paths, a forced-time-zone date test. |
| `android/*` | **Refactor** | Real release signing (key outside git), `allowBackup=false` / data-extraction rules, App Bundle build for Play. |
| `ios/*` | **Delete or freeze** | Unused scaffold; `flutter create` can regenerate it later. Owner's call. |

**Missing versus `docs/30_REVAMP/04_ANDROID_APP_SPEC.md` (Checked against the spec text and the code):**

| spec item | state |
|---|---|
| Onboarding steps 0-3 and first prediction | Done |
| Step 4: reminders (local notifications) | **Missing** (P3.8); no notification package in `pubspec.yaml` |
| Encrypted local store (SQLite + Keystore) | **Missing**; plain JSON file |
| App lock | **Missing** |
| Backup export / import | **Missing** |
| Articles in the app (snapshot), Learn tab | **Missing** (P3.7); no content assets |
| Condition cards, PCOS hub, Settings "My health" | **Missing** (P3.7) |
| Hijri alongside Gregorian | **Missing** (P3.10); no Hijri code or package |
| Crash reporting without content | **Missing** (P3.8) |
| Ultrasound dating | **Missing** (P3.10) |
| Period tools: cycle history and length chart, period calculator, doctor-visit summary | **Missing** |
| TTC tools: ovulation calendar, LH log, BBT chart, mucus log, test timing | Done. Trying-time tracker: partial (stored, used for one nudge) |
| Pregnancy: week-by-week, baby size, due-date calculator, hospital-bag checklist | **Missing** (week and due date shown, no content). Kick counter, contraction timer, appointments, weight log: done |
| After birth: bleeding and recovery log, mood check (EPDS) | **Missing** |
| Menopause: symptom tracker, MRS screener | Partial (hot flashes etc. in the shared log); screener missing |
| A "Tools" tab | **Missing**; tabs are Today, Calendar, Log |

**Bottom line.** Keep the domain, theme, strings, calendar, log and pregnancy tools. Rebuild the data layer. Refactor the three big screens and the app shell. Before any build that holds real records, add the launch conditions: encrypted store, backup, app lock, reminders, a real signing key, and a confirmed "Start over".

## 10. Open questions

1. **Cloud backup.** Opt out of Android's Google Drive auto-backup (my recommendation, so "never leaves the phone" stays true) or allow it because it rescues a lost phone? This changes the privacy statement either way.
2. **What does "private" promise on an unlocked or borrowed phone?** If the answer is app lock plus an encrypted file, the store rebuild is needed now; if device encryption is enough for v1, the privacy text must say so.
3. **Is Dart now the primary home of the maths** (web calculators the secondary client), or do both stay equal? That decides whether to keep growing fixtures and TypeScript twins.
4. **Arabic review:** who is the native reviewer, and what is the preferred phrase for waters breaking (`contractionsContactBody` should be reviewed first)? Formal MSA, or a lighter Egyptian / Gulf register on Today and onboarding?
5. **Irregular cycles / PCOS:** what should the fertile-window card show when cycles are irregular? A clinician decision. Today it still shows a 14-days-before-period window.
6. **Under 18:** the hard stop means a 17-year-old gets no tracker, only guides. Confirm that is intended for the Saudi and Egypt launch.
7. **Does the wedge include postpartum?** "I've had my baby" lands on a near-empty screen today.
8. **iOS scaffold:** delete or keep?
9. **Release signing key and Play listing:** who creates and stores the upload key (an OWNER_ACTIONS item)? Nothing can ship before that.
10. **Does the app need its own settings screen first** (change goal, language, due date, cycle length), given the UI already promises "change this any time"?
