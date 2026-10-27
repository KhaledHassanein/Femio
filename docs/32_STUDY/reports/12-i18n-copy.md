# 12 · Internationalisation and copy

Legend: **Checked** = I measured or read it in this session. **From the docs** = a repo document says it. **Hypothesis** = my reading, not run. Terms: *ICU* is the message syntax for plurals and choices in text (`{count, plural, one {…} other {…}}`); *CLDR* is the standard table of plural rules and number formats that Arabic and others use; *ARB* is Flutter's JSON translation file; *gen-l10n* is Flutter's compiler that turns ARB into Dart; *bidi* is the browser's left-to-right/right-to-left mixing; *overlay* means a database value that replaces the JSON value at run time.

Method: counting and comparison scripts ran in the scratchpad (`C:\Users\slash\AppData\Local\Temp\claude\E--Femio--claude-worktrees-femio-repo-study-planning-88d7c9\f8cd43e1-0cfb-4aad-a5ed-c3fa65085958\scratchpad\i18n\`), not in the repo. Nothing in the repo was changed. I did not query the live database, so the state of approved rows in `ui_strings` is **not verified**.

## 1. Purpose

This area is how Femio speaks to a reader in four languages (English, Arabic, French, Spanish). The website reads one JSON catalogue per language from `apps/web/messages/`. The Flutter app reads one ARB file per language from `apps/mobile/lib/l10n/`. Next.js (through the `next-intl` library) decides the language from the URL, loads the right catalogue on the server, and sends only some parts of it to the browser. A translation portal can overwrite individual strings from a database. A generator copies part of the web copy into the app, so the two platforms use the same words for the same log items. Crisis wording lives in its own file and has its own approval gate. The area exists so that a woman in Cairo, Riyadh or Paris reads the same medical and privacy promises in her own language, and so that an Arabic reader is never shown English inside a right-to-left layout.

## 2. Inventory

### 2a. Catalogue measurements

| Measure | Result | Status |
|---|---|---|
| Web catalogues, leaf strings per locale | en 1,692 · ar 1,692 · fr 1,692 · es 1,692 | **Checked** |
| Key parity against English (missing / extra) | ar 0/0 · fr 0/0 · es 0/0 | **Checked** |
| Top-level web namespaces | 67 | **Checked** |
| Namespaces on the public teaser side (21), with 429 keys | see section 9 | **Checked** |
| Namespace gallery (dev page only) | 29 keys | **Checked** |
| `appNav`, listed in the public payload but used only in the app shell | 8 keys | **Checked** |
| Closed-tracker namespaces (44), with 1,226 keys | 72% of the web catalogue | **Checked** |
| Crisis wording (outside `messages`, own file) | 10 strings per locale, all four `approved` | **Checked** |
| Identical to English, ar / fr / es | 14 / 31 / 20 (ar: brand, numbers, symbols only; fr/es: mostly real cognates) | **Checked** |
| Untranslated-copy guard, comparisons | 4,935 across three locales, passes | **Checked** (ran it) |
| ICU plural strings, web | 9 (ar: one with six forms, two with five, six with four) | **Checked** |
| Arabic-Indic digits (٠–٩) in any Arabic string, web or app | 0 of 1,692 and 0 of 247 | **Checked** |
| ARB catalogues, keys per file (en, ar, fr, es) | 247 each, plus 25 `@` metadata entries in en; 0 missing, 0 extra | **Checked** |
| ARB ICU plural strings | 13 (ar: 3 with a `zero` form, 4 with only `few`/`other`) | **Checked** |
| ARB identical to English, ar / fr / es | 2 / 7 / 3 | **Checked** (no lint covers ARB values) |

### 2b. Files

| Path | Lines | One-line purpose | Status |
|---|---|---|---|
| `apps/web/messages/en.json` | 2,564 | English master catalogue, 1,692 strings | live |
| `apps/web/messages/ar.json` | 2,564 | Arabic catalogue | live |
| `apps/web/messages/fr.json` | 2,564 | French catalogue | live |
| `apps/web/messages/es.json` | 2,564 | Spanish catalogue | live |
| `apps/web/src/i18n/routing.ts` | 25 | Four locales, default `en`, always-prefixed URLs, RTL rule | live (imported by 18 files) |
| `apps/web/src/i18n/request.ts` | 41 | Loads catalogue per request, overlays DB, pins Arabic digits | live (see section 8, risk 1) |
| `apps/web/src/i18n/navigation.ts` | 7 | Locale-aware `Link`/`redirect` (41 importers) | live |
| `apps/web/src/i18n/client-namespaces.ts` | 178 | Which namespaces each layout sends to the browser | live |
| `apps/web/src/i18n/numbering.test.ts` | 51 | Pins Western digits for every locale | live (test) |
| `apps/web/src/i18n/routing.test.ts` | 29 | `isLocale` and `getDir` | live (test) |
| `apps/web/src/middleware.ts` | 31 | Locale redirect; closed web app redirects tracker URLs | live |
| `apps/web/src/lib/i18n/ui-strings.ts` | 58 | Pure helpers: flatten, unflatten, overlay | live |
| `apps/web/src/lib/i18n/ui-strings-loader.ts` | 77 | Reads approved DB rows, one cached read per locale | live (dormant unless rows approved; not verified) |
| `apps/web/src/lib/i18n/translation-actions.ts` | 85 | Admin save and CSV import into `ui_strings` | app-only |
| `apps/web/src/lib/i18n/csv.ts` | 78 | CSV for the portal (Excel-safe, BOM) | app-only |
| `apps/web/src/lib/i18n/ui-strings.test.ts` | 56 | Overlay and flatten tests | live (test) |
| `apps/web/src/lib/i18n/csv.test.ts` | 44 | CSV round-trip tests | app-only (test) |
| `apps/web/src/components/admin/translation-editor.tsx` | 225 | Portal screen for translators | app-only |
| `apps/web/src/lib/crisis/content.ts` | 53 | Picks crisis wording by locale; falls back to English | live (header comment is stale, risk 6) |
| `apps/web/src/lib/crisis/crisis.json` | 86 | Approved crisis wording and review metadata, four locales | live |
| `apps/web/src/lib/crisis/directory.ts` | 24 | Crisis directory name | live |
| `apps/web/src/components/crisis/crisis-content-view.tsx` | 63 | Renders crisis wording (also offline) | live |
| `apps/web/src/components/crisis/crisis-help-provider.tsx` | 140 | Launcher and dialog for crisis help on every page | live |
| `apps/web/src/app/[locale]/help-now/page.tsx` | 33 | Public help-now page | live |
| `apps/web/src/app/[locale]/layout.tsx` | 126 | Root layout: `lang`, `dir`, fonts, public client payload | live |
| `apps/web/src/app/[locale]/(app)/layout.tsx` | 33 | Second provider with the tracker's strings | app-only |
| `apps/web/src/app/[locale]/(public)/calculators/layout.tsx` | 17 | Adds calculator strings for calculator pages | live |
| `apps/web/src/app/[locale]/{sign-in,welcome,reset-password}/layout.tsx` | not counted | Adds auth and onboarding strings | app-only (closed, D8) |
| `apps/web/src/app/[locale]/components/page.tsx` | 142 | Component gallery page, six English badge labels hard-coded | unknown |
| `scripts/i18n/client-namespaces-lint.mjs` | 145 | CI guard: client namespace list matches usage | live |
| `scripts/i18n/untranslated-lint.mjs` | 147 | CI guard: fails when a value is still English | live |
| `scripts/i18n/seed-ui-strings.mjs` | 80 | Manual, service-key seed of `ui_strings` | app-only (manual) |
| `scripts/crisis-compliance.mjs` | 98 | CI guard: crisis review dates, metadata, key parity | live |
| `scripts/mobile/sync-log-vocabulary.mjs` | 257 | Copies log vocabulary and 75 strings from web to app | live (its `--check` gate fails here, risk 2) |
| `apps/web/src/lib/experience/v2/vocabulary.ts` | 259 | Canonical list of log terms (source for the generator) | live |
| `apps/mobile/lib/l10n/app_en.arb` | 429 | App master ARB (247 keys + metadata) | live |
| `apps/mobile/lib/l10n/app_ar.arb` | 249 | App Arabic ARB | live |
| `apps/mobile/lib/l10n/app_fr.arb` | 249 | App French ARB | live |
| `apps/mobile/lib/l10n/app_es.arb` | 249 | App Spanish ARB | live |
| `apps/mobile/l10n.yaml` | 5 | gen-l10n settings (template `app_en.arb`) | live |
| `apps/mobile/lib/l10n/app_localizations*.dart` (5 files) | 1,622 / 944 / 912 / 912 / 918 | Generated Dart classes from ARB (tracked in git) | live (generated) |
| `apps/mobile/lib/l10n/log_labels.g.dart` | 78 | Generated: log key to localised label | live (generated) |
| `apps/mobile/lib/domain/log_vocabulary.g.dart` | 72 | Generated: 51 log terms with dimension and sensitivity | live (generated) |
| `apps/mobile/lib/domain/movements.dart` | 82 | Movement pattern logic; `minSessionsForPattern = 3` | live |
| `apps/mobile/lib/features/pregnancy/movement_log_screen.dart` | 129 | Movement screen; passes the session count into a String-typed message | live |
| `apps/mobile/test/screens_test.dart` | 271 | Renders screens in several locales (screenshots) | live (test) |
| `apps/web/src/lib/cycle/calendar.ts` | 97 | `weekStartForLocale`: Arabic starts the week on Saturday | live |
| `apps/web/src/lib/onboarding/complete.ts` | 198 | Saves the chosen locale to `profiles` | app-only (closed web app) |
| `supabase/migrations/0001_schema_v1.sql` | (shared) | `ui_strings` table; `profiles.locale` CHECK in (en, ar, fr, es) | live |

Coverage: I listed every file in these areas that carries i18n logic, and I did not find a duplicate catalogue. I did not open every component that calls `useTranslations`. A scratch script counted call sites per namespace (printed only, not saved), and it is the basis for the public / tracker split.

## 3. Key modules and responsibilities

1. **`routing.ts`** (25 lines). Input: a URL. Output: the locale, or a fallback. Defines `en, ar, fr, es`, `en` as default, and `rtlLocales = ["ar"]`, from which `getDir` derives `dir`. Called by `request.ts`, `navigation.ts`, `middleware.ts`, the crisis resolver and tests.
2. **`request.ts`** (41 lines). Input: the locale from the URL. Output: messages plus formats. Imports the JSON, calls `loadMessages` (DB overlay for ar/fr/es only), and returns `locale: "ar-u-nu-latn"` for Arabic to force Western digits. Called by `next-intl` for every request. See risk 1.
3. **`navigation.ts`** (7 lines). Creates locale-aware `Link`, `redirect`, `useRouter`. Input: a path. Output: a path with the locale prefix. Used in 41 files; **Checked** that no file imports plain `next/link` (0 files).
4. **`middleware.ts`** (31 lines). Input: every request outside API and static files. Output: a redirect or the locale-resolved response. If the web app is closed (`NEXT_PUBLIC_WEB_APP_ENABLED` not `1`), tracker URLs redirect to the page that links the Android app.
5. **`client-namespaces.ts`** (178 lines). Input: the full messages object. Output: the subset each layout sends to the browser. Four lists: public (every page), calculators, auth, and app. Called by each layout. The comment history shows the page-weight budget caught real leaks (P1.11.2).
6. **Root and (app) layouts.** The root layout sets `lang`, `dir`, fonts and provides the public payload. The (app) layout adds a second provider with the tracker's strings. A nested provider replaces the context, so it has to carry the locale too (the root layout comment explains this).
7. **`ui-strings-loader.ts` + `ui-strings.ts`** (135 lines together). Input: locale. Output: the JSON overlaid with DB rows whose `status` is `human_reviewed`. English is never overlaid (`overlaysFromDatabase`). Any DB error returns the JSON unchanged. Cache lasts one hour, and a tag busts it on approval.
8. **`translation-actions.ts` + `csv.ts` + translation editor** (app-only). Input: a translator's edit or a CSV. Output: upserts into `ui_strings` with `status = human_reviewed` or `machine`. Only keys that exist in `en.json` are written.
9. **`crisis/content.ts` + `crisis.json`.** Input: locale. Output: the approved crisis strings, or the English strings tagged `lang="en" dir="ltr"` when a locale is not approved. Kept out of `messages` so the crisis interface works offline.
10. **`crisis-compliance.mjs`.** Input: `crisis.json`. Output: pass or fail on expired review dates, missing reviewer fields, and key parity against English.
11. **`client-namespaces-lint.mjs`.** Input: every `useTranslations("…")` in `apps/web/src`, and the four lists. Output: fails if a used namespace is not shipped, or a shipped one is never used. Result today: 49 shipped, all used, none missing (**Checked**, ran it).
12. **`untranslated-lint.mjs`.** Input: `en.json` and the three other catalogues. Output: fails if a comparable English value is copied, except on an allow-list (8 shared, 18 French, 6 Spanish, none for Arabic). Result: 4,935 comparisons, passes (**Checked**, ran it). It was added after 122 keys of English shipped in three namespaces (its own header, P1.29).
13. **`sync-log-vocabulary.mjs`.** Input: `vocabulary.ts` (`LOG_TERMS`) and the web catalogues. Output: `log_vocabulary.g.dart`, `log_labels.g.dart`, and the generated keys inside all four ARB files. Its `--check` mode is the `mobile-vocab-lint` gate. See section 9c.
14. **`movement_log_screen.dart`.** Input: session count, from `minSessionsForPattern`. Output: the "after N sessions" message through `movementsNeedMore('$minSessionsForPattern')`. The ARB entry has no plural form (risk 3).
15. **`weekStartForLocale` (`calendar.ts:96`)** and its callers in `cycle-calendar.tsx:46` and `calendar-screen.tsx:95`. Input: a locale string. Output: 6 (Saturday) for `ar`, else 1. Depends on the locale value being exactly `ar` (risk 1).

## 4. Data flow

- **Enters:** the author writes English and Arabic in JSON and ARB files. Translators edit in the admin portal (app-only) or via CSV. The owner edits crisis wording in `crisis.json`.
- **Stored:** repo files (web catalogues, ARBs, `crisis.json`), a Supabase table `ui_strings` (portal overlay, not verified as populated), and `profiles.locale` (user's chosen language, CHECK-constrained to `en/ar/fr/es`).
- **Leaves:** into server-rendered HTML (`getTranslations`), into the browser (only the namespaces listed in `client-namespaces.ts`, inside the HTML as serialised JSON), and into the Flutter app as compiled Dart.
- **External services touched by this area:** Supabase (for the overlay read through an anonymous client, and for `profiles` writes in the closed web app). The root layout loads Arabic fonts (Noto Naskh, IBM Plex Sans Arabic) through `next/font/google` with preload off. **From the docs:** `next/font` downloads these at build time and serves them from the site itself, so no browser call to Google is expected at runtime; not checked in a browser. Nothing else leaves the repo at runtime.
- **Generator path:** web catalogues and `vocabulary.ts` → `sync-log-vocabulary.mjs` → ARB and Dart files → `flutter gen-l10n` → `app_localizations*.dart`.

## 5. Dependencies

- Web i18n imports `next-intl` (`^4.13.4` per `apps/web/package.json`), `next/cache`, `@supabase/supabase-js`, and `@/lib/env`. **Checked** by reading the import lines.
- `translation-actions.ts` imports `en.json` directly, to build the set of known keys.
- Every client component that calls `useTranslations` depends on `client-namespaces.ts` through the layout that sends the payload.
- `sync-log-vocabulary.mjs` imports `apps/web/src/lib/experience/v2/vocabulary.ts`. So the app's log list depends on a web TypeScript file.
- Mobile `movement_log_screen.dart` and `log_labels.g.dart` import the generated Dart. Nothing in the web imports mobile code.
- Imported by this area: the crisis resolver reads `routing.ts`; the calendar helper is used by the tracker's calendar screens.

## 6. Strings and i18n

### 6a. Hard-coded strings found (rough search, not exhaustive)

- `apps/web/src/app/[locale]/components/page.tsx:65–70`: six badge labels in English (Neutral, Primary, Accent, Success, Warning, Danger). Dev gallery page; should be removed or moved behind a gate before any public launch.
- `apps/mobile/lib/features/today/today_screen.dart:58` and `apps/mobile/lib/features/onboarding/onboarding_flow.dart:497`: literal `'femio'` as the logo text. This is the brand wordmark, so it is intended.
- My search for JSX text nodes, `aria-label`, `placeholder` and Dart `Text('…')` with capitalised words found nothing else. The search cannot see strings built from variables, so treat this as a lower bound.

### 6b. Arabic copy: how it reads

Method: 30 public-site Arabic strings (home, learn, learnHub, faq, about, editorialPolicy, medicalReview, search, getApp, notFound, footer, privacy, terms, calculators, crisis) and 30 app ARB strings, read against English. Verdicts: ok / weak / wrong.

**Web catalogue (public side)**

| Key | Verdict | Note or better rendering |
|---|---|---|
| home.rail.sub | ok | Clear MSA |
| home.proof.heading | ok | Strong |
| home.proof.band.body | weak | "كلّما نعمت الحواف قلّ يقيننا" reads as a literal translation. Better: "كلّما اتّسع النطاق قلّ يقيننا، وأنتِ تَرَين ذلك." |
| home.proof.late.body | weak | "ولا تُشغّل عدّادًا في وجهكِ" is an idiom that does not carry. Better: "ولا تُظهر لكِ عدّادًا للتأخير." |
| home.proof.pattern.title | ok | "نمطُكِ أنتِ، لا متوسّط الناس" is good, warm, feminine |
| home.hero.title | ok | Imperatives match the feminine address |
| home.hero.body | ok | One long sentence (about 25 words, several clauses); splitting it helps a grade 6–8 reader |
| home.privacy.body | ok | |
| home.disclaimer | ok | Meets product rule 1 (learning and tracking, not contraception) |
| home.trust.items.languages.detail | ok | "لا طبقةً أُلحقت لاحقًا" is stiff |
| learnHub.guides | ok | The only web string with all six Arabic plural forms |
| learn.disclaimer.emergency | ok | Clear safety wording |
| faq.empty | ok | |
| about.intro | weak (consistency) | Uses Latin "Femio" here, فيميو elsewhere |
| about.points[1].body | weak (consistency) | "يساعدكِ Femio على…" mixes scripts mid-sentence |
| editorialPolicy.points[2].body | ok, note | "الصفوف 6–8" is a US grade-level label; check it reads for Egyptian and Saudi readers |
| medicalReview.points[3].heading | weak | "مُطبَّق لا مجرد طموح" is stilted. Better: "مطبّق فعلًا، لا مجرد طموح." |
| search.noResults | weak (typography) | `"{query}"` with straight quotes. Better: `لا نتائج لـ «{query}».` |
| getApp.notMedical | ok | Strong |
| getApp.body | ok | |
| notFound.body | ok | |
| terms.points[0].body | ok | Clear scope, no overclaim |
| privacy.points[2].body | ok | Clear consent wording |
| calculators.bmi.unitImperial | weak (term) | "إمبراطوري" reads as "empire". "إمبريالي" is the usual technical term; confirm with a native editor |
| onboarding.age.note | flag | Claims cycles change "around age forty-five" with no source in the string: `[NEEDS SOURCE]` |
| crisis: immediateLead, worriedBody (ar) | ok | Short, safe, feminine address, clear |

**App ARB (Flutter)**

| Key | Verdict | Note or better rendering |
|---|---|---|
| welcomeTitle | ok | Strong |
| welcomeBody | ok | |
| goalTitle | weak (wordmark) | "ما الذي جاء بكِ إلى femio؟" mixes scripts. Better: "ما الذي جاء بكِ إلى فيميو؟" (depends on the owner's wordmark decision, section 9) |
| goalSub | weak (masculine address) | "يمكنك تغيير هذا في أي وقت." Better: "يمكنكِ تغيير هذا في أي وقت." |
| goalPregnantDesc | weak (unmarked possessive) | "وموعد ولادتك." Better: "وموعد ولادتكِ." |
| goalMenopause | weak (awkward, term drift) | "ما حول انقطاع الطمث وانقطاعه". Better: "ما قبل انقطاع الطمث وانقطاعه", which matches the web (`learnHub.topics.menopause`) |
| birthYearSub | ok | "ما هو متوقّع" is stiff; "ما المتوقَّع" is smoother |
| under18Body | ok | |
| irregularNote | weak (gender) | "دوراتك" should be "دوراتكِ". Product rule (never a late counter) is met |
| implausibleDue | weak (formal) | "يرجى التحقق منه" reads like a form. Better: "تحقّقي من التاريخ من فضلكِ." |
| seeClinicianTtc | weak + flag | "عمرك" is masculine; the sentence is clumsy; the 12-month / 6-month threshold has no source in the ARB metadata (`@seeClinicianTtc` is absent). Better: "المحاولة لأكثر من سنة (أو ستة أشهر إن كان عمركِ 35 عامًا أو أكثر) تستدعي استشارة طبيبة أو طبيب." `[NEEDS SOURCE]` |
| logGumSoreness | weak (diagnosis word) | "التهاب اللثة أو نزفها" names a condition. The English says "Sore or bleeding gums", a symptom. Better: "ألم اللثة أو نزفها." Product rule 1 |
| bbtChartNote | ok | Strong; "حديثٌ بينكِ وبين طبيبكِ" is well judged |
| contractionsContactBody | ok, check | The bracketed lay term "(ماء الرأس)" for amniotic fluid: a clinician should confirm it is the term Egyptian and Saudi women use, or drop it |
| contractionsSummaryNote | ok | Strong |
| movementsUrgentBody | ok | Clear and urgent, correct |
| movementsNeedMore | weak (latent bug) | "بعد {count} جلسات" is right only for 3. The count is passed as a String with no plural form. See risk 3 |
| movementsSlowerBody | weak (gender) | "ليطمئن أحدهم عليك" should be "عليكِ"; "جلساتك" in the same screen is unmarked |
| movementsFinishNote | weak (masculine) | "يمكنك التوقف" should be "يمكنكِ التوقّف" |
| loggedToday | weak (minor) | "تم تحديث التوقّع" should be "التوقّعات" (plural) |
| trimesterLabel | ok, note | Uses a cardinal plural to pick ordinals. Works for 1–3; a `selectordinal` would be right |
| apptInDays | ok | Correct forms: غدًا, بعد يومين, بعد {days} أيام, بعد {days} يومًا |
| testTimingSource | ok | Sourced ("NHS") |
| dueMethodIvf3 | ok | Standard term |
| calendarHint | ok | Clear |
| logIntercourse | ok | "جماع" is clinical and blunt; acceptable |
| apptNoResultsNote | ok | Long but correct |
| pregEstimateNote | ok | Honest "estimate" wording |
| weightNote | ok | |

Counts from the two tables: web, 7 weak; app ARB, 12 weak; the rest are ok or ok-with-note. The rows are a sample of about 30 per side, not the full catalogues.

### 6c. Register and dialect

- **Modern Standard Arabic (MSA)** throughout, both catalogues. No Egyptian or Gulf colloquial in the copy (**Checked**). MSA suits written health material read in both Saudi Arabia and Egypt. The home page says the app is made for women in Saudi Arabia and Egypt, and the copy does not yet show that in its voice.
- **Feminine address** is the default in the public catalogue and most of the app. The masculine or unmarked forms in the list above are the exceptions. The app has about 9 such strings out of 247 (**Checked** by search: `يمكنك`, `عمرك`, `ولادتك`, `دوراتك`, `جلساتك`, `عليك`).
- **Western digits everywhere**: 0 Arabic-Indic digits across 1,939 Arabic strings. This matches the owner's decision (R3.5.2) and is pinned by `numbering.test.ts`.
- **English-style em dashes**: 154 web Arabic strings and 6 app strings contain "—". Arabic prose usually uses "،" and "؛" or a colon. This is a style point, not an error.
- **Brand spelling**: web Arabic uses فيميو in 86 strings and a Latin "Femio" in 44 (no string uses both). App Arabic uses فيميو in 14 strings and Latin in 2. The CLAUDE.md rule 6 (wordmark is always English "femio") governs the logo. It does not say what to do in running text, so the current split is an open decision (section 10).
- **Terms**: "سنّ اليأس" (web `learn.subtitle`) and "ما قبل انقطاع الطمث وانقطاعه" (web `learnHub`) and "ما حول انقطاع الطمث وانقطاعه" (app) all name menopause. Pick one.
- **Crisis copy**: the strongest Arabic in the repo. Short sentences, a clear first action, feminine address where it is right, and a clear note for someone worried about another person.

Overall verdict on Arabic quality: **good, not yet publishable without a second reader.** Native-quality MSA with a clear voice; the weak spots are a handful of gendered forms, two spellings of the brand, some English-shaped sentences, one diagnostic word, and a few unsourced medical thresholds. The crisis wording was approved by the owner (**Checked**: `crisis.json` shows the reviewer for ar, fr and es as "Dr Khaled Hassanein (owner, clinician…)"). I found no independent linguistic reviewer for Arabic in the repo (**Checked** for the crisis file; the portal's approved rows were not queried, so **not verified** for ordinary copy).

## 7. Tests

| Test or guard | What it covers | Result today |
|---|---|---|
| `apps/web/src/i18n/routing.test.ts` | `isLocale`, `getDir` | live (not run here) |
| `apps/web/src/i18n/numbering.test.ts` | Western digits for each locale | live (not run here) |
| `apps/web/src/lib/i18n/ui-strings.test.ts` | Flatten, unflatten, overlay | live (not run here) |
| `apps/web/src/lib/i18n/csv.test.ts` | CSV round-trip | live (not run here) |
| `apps/web/src/lib/crisis/directory.test.ts` | Crisis directory | live (not run here) |
| `apps/web/e2e/crisis.spec.ts` | Crisis launcher and page (includes `[ar]` specs) | live (e2e, not run here) |
| `apps/web/e2e/page-weight.spec.ts` | Page weight budget (caught leaks) | live (e2e, not run here) |
| `scripts/i18n/client-namespaces-lint.mjs` | Namespace list vs usage | **passes** (ran it) |
| `scripts/i18n/untranslated-lint.mjs` | English copied into other locales | **passes** (ran it) |
| `scripts/crisis-compliance.mjs` | Crisis review dates and parity | **passes** (ran it) |
| `scripts/mobile/sync-log-vocabulary.mjs --check` | App log vocabulary is current | **fails here** (ran it; risk 2) |
| `apps/mobile/test/screens_test.dart` | Screens rendered in several locales (screenshots) | live (not run here) |

Untested: the ARB files have no parity or identical-value guard, so the app's 2 / 7 / 3 identical strings are not checked by anything. No test asserts `getLocale()` in a nested layout returns `ar` (risk 1). No test checks the Arabic plural forms for each ICU string. No test checks the crisis strings in Arabic match the approved English meaning (human review only).

## 8. Smells, risks, dead code

1. **Locale value leaks into nested providers (Hypothesis, high confidence on the code path).** `request.ts:39` returns `locale: "ar-u-nu-latn"` for Arabic, to pin digits. The (app), calculators, sign-in, welcome and reset-password layouts call `getLocale()`, which should return that same value, and pass it to a nested `NextIntlClientProvider`. Consequences to check: `weekStartForLocale("ar-u-nu-latn")` returns 1 (Monday) instead of 6 (Saturday) in the calendar screens (`cycle-calendar.tsx:46`, `calendar-screen.tsx:95`); analytics events carry the wrong locale (`page-view.tsx`); and the closed web app's onboarding writes `"ar-u-nu-latn"` to `profiles.locale`, which the CHECK constraint rejects (`0001_schema_v1.sql:36`). `complete.ts` (around lines 116–123) does not check the error from that update, so the failure would be silent. **Test to confirm:** in an Arabic page under `(app)`, log `getLocale()` and `useLocale()`. The fix is to return `ar` from `request.ts` and set digits with `formats`, or to pass `-u-nu-latn` only inside the formatters.
2. **The mobile vocabulary gate fails on a Windows checkout (Checked).** `mobile-vocab-lint` (part of `pnpm gate`) reports the four generated files as stale. The content is identical after line-ending normalisation (**Checked**: I regenerated them in a scratch copy). The cause: git stores LF (`i/lf`), this machine checks out CRLF (`w/crlf`, `core.autocrlf=true`), and the generator writes LF and compares raw text. Fix: compare with line endings normalised, or add a `.gitattributes` with `eol=lf` for these files.
3. **`movementsNeedMore` has no plural form (Checked).** The English is "After {count} sessions…" with `count` typed String. It is correct today only because `minSessionsForPattern = 3` (`movements.dart:30`). If the constant becomes 1, 2, or 11 or more, Arabic is wrong. The same message exists in the web catalogue (`pregnancyMovements.pattern.needMore`) and is copied across by the generator.
4. **`appNav` is in the public payload but used only in the app shell (Checked).** `client-namespaces.ts` lists `appNav` in `PUBLIC_CLIENT_NAMESPACES`. `app-nav.tsx` is rendered only by `(app)/layout.tsx`. Eight keys ship to every public page for nothing. The lint does not catch it because the namespace is used somewhere.
5. **The gallery page is public-looking and has hard-coded English (Checked).** `[locale]/components/page.tsx` has no `notFound()` or `noindex` in the file. Whether it is linked or in the sitemap is **not verified**.
6. **Stale comment in `crisis/content.ts` (Checked).** Lines 5–8 say ar, fr and es are `pending` and fall back to English. `crisis.json` marks all four `approved` and the guard passes. Someone reading the code will believe the Arabic crisis dialog is English. Fix the comment.
7. **Crisis reviewer is the owner for every non-English locale (Checked).** The guard checks dates and parity, not independence. The owner is a clinician and an Arabic speaker, which is a strength, but there is no second reviewer.
8. **Two systems for the same copy.** The generator makes 136 of the app's 247 ARB keys (55%) a copy of the web. So fixes to Arabic copy must go to the web catalogue first, then the generator runs. Editing the ARB by hand is overwritten on the next sync (**Checked** from the generator's `SHARED` map and `arbKey` logic).
9. **Portal overlay is a second, invisible source of truth.** A string approved in `ui_strings` silently replaces the JSON. The repo does not show which rows are approved. The comment in `translation-actions.ts` records a past case where an English seed shadowed new copy. **Not verified** whether any ar/fr/es rows are live.
10. **Oversized files.** `onboarding-wizard.tsx` is 501 lines (project rule: split near 300). `client-namespaces.ts` is 178 lines, fine.
11. **Some Arabic body sentences look long** (for example `home.hero.body` and several privacy and editorial paragraphs). I did not measure reading level; a word count and a readability check should come before the grade 6–8 claim is made.
12. **Latin `femio` inside Arabic sentences** (web 44, app 2): visible in the reader's bidi display as mixed-direction text. Not a bug; a consistency and readability cost.
13. **Dormant code.** The DB overlay, the CSV portal and `seed-ui-strings.mjs` do nothing unless approved rows exist and the closed web app is reopened (D8). They are app-only, not dead code, but they are candidates to remove when the web app stays closed.
14. **Medical claims in copy without a visible source.** `onboarding.age.note` (age forty-five) and `seeClinicianTtc` (12 or 6 months) are unsourced in the file. The product rule is to cite or flag `[NEEDS SOURCE]`.

## 9. Keep / rebuild / delete verdict, and the three answers asked

### 9a. Per module

- `routing.ts`: **keep** (small, correct, the single source of locales).
- `request.ts`: **rebuild the return value** (risk 1); keep the DB overlay call.
- `navigation.ts`: **keep** (41 importers, no plain `next/link` use).
- `client-namespaces.ts`: **keep**; move `appNav` to the app list; extend the lint to check that public-list namespaces are used by public pages.
- `middleware.ts`: **keep**.
- `ui-strings.ts`, `ui-strings-loader.ts`: **keep** while the portal is wanted; they cost one cached read.
- `translation-actions.ts`, `csv.ts`, `translation-editor.tsx`, `seed-ui-strings.mjs`: **keep dormant**; **delete** if the closed web app stays closed past the teaser phase.
- `crisis/*` and `crisis-compliance.mjs`: **keep**, fix the stale comment (risk 6), and add a second-reviewer field.
- `[locale]/components/page.tsx`: **delete** or gate before launch.
- `untranslated-lint.mjs`, `client-namespaces-lint.mjs`: **keep**; add the same identical-value check to ARB files.
- `sync-log-vocabulary.mjs`: **keep**; fix the CRLF comparison (risk 2) so `pnpm gate` passes on Windows.
- Web catalogues: **keep**; correct the gendered and wording items in section 6b.
- Mobile ARBs and generated Dart: **keep**; add plural forms for `movementsNeedMore` (risk 3), and gender fixes.
- `calendar.ts` (`weekStartForLocale`): **keep**, make it accept any `ar*` locale or fix the value upstream (risk 1).

### 9b. Which namespaces survive a static teaser site

Static teaser means: no runtime Supabase, articles, calculators and SEO pages that send people to the app.

- **Keep (teaser needs them, 20 namespaces, 416 keys):** `meta` (2), `home` (84), `nav` (17), `footer` (6), `notFound` (5), `theme` (3), `calculators` (92), `learn` (16), `learnHub` (25), `conditions` (3), `about` (14), `authors` (6), `editorialPolicy` (14), `medicalReview` (10), `privacy` (29), `terms` (27), `faq` (3), `glossary` (3), `getApp` (31), `tools` (26, the labels that the public search results use).
- **Keep, but only if search is rebuilt static (21 namespaces with search, 429 keys in total):** `search` (13 keys). The public search depends on a Postgres function granted to anonymous users (`client-namespaces.ts`, citing migration 0022), so it needs a static index or should be removed for the teaser.
- **Keep outside `messages`:** crisis wording (`crisis.json`, 10 strings per locale). It must survive.
- **Drop from the teaser:** `gallery` (29, dev page), `appNav` (8, app shell only).
- **Drop (closed tracker, 44 namespaces, 1,226 keys, 72%):** everything about symptoms, tracking, logging, cycles, pregnancy tools, postpartum, menopause, fertility, appointments, medications, partner sharing, insights, admin, MFA, settings, auth (`signIn`, `resetPassword`, `onboarding`).

### 9c. The state of Arabic quality

Good MSA with a consistent warm voice and feminine address in most places; the crisis wording is the best piece. Nine gendered or unmarked forms, two brand spellings with no rule, 154 English-style em-dash strings, one diagnostic word, a latent plural bug, several unsourced medical thresholds, and no independent second reader. Fixing these is an afternoon of edits plus the wordmark decision. None of them is a safety fault except the unsourced thresholds and the diagnostic word, which bear on product rule 1.

### 9d. What the shared web to mobile vocabulary generator covers

- **Generated into the app:** 51 log terms (mood, symptom, discharge, intercourse dimensions, with a sensitivity flag, `vitals` excluded), 4 flow levels and their label, 5 ovulation-test results, and 75 web strings copied verbatim (BBT chart, test timing, contractions, pregnancy movements, appointments, weight). That is 136 of the app's 247 ARB keys (55%), plus the two Dart files.
- **Not covered:** the app's goal and onboarding copy, the calendar and legend, the reminder texts, most of the app's own screens (about 111 keys). These are hand-written in the ARB files and not checked against the web except by the untranslated-copy habit.
- **Checked by:** `mobile-vocab-lint` (`--check`), which fails on this machine for a line-ending reason only (risk 2).

## 10. Open questions

1. **Wordmark in Arabic prose:** فيميو everywhere (as the web mostly does), Latin "femio" everywhere, or the logo only? CLAUDE.md rule 6 covers the logo only. The web is split 86 to 44 and the app 14 to 2.
2. **Does `getLocale()` return `ar-u-nu-latn` in nested layouts?** (risk 1). A five-minute check on a local Arabic page settles it, and the fix changes the calendar's week start and the stored profile locale.
3. **Who is the second Arabic reviewer?** The crisis copy is approved by the owner. Ordinary public copy has no reviewer on record in the repo (**not verified** in the portal).
4. **Medical thresholds and sources:** the "45" age claim and the "12 months / 6 months at 35" trying-to-conceive threshold need citations (NICE, ACOG or other tier-1 or tier-2 sources per the medical content rules), or a `[NEEDS SOURCE]` flag.
5. **The lay term "ماء الرأس"** in contraction copy: keep, or use only the clinical term? A clinician should decide.
6. **Should the component gallery page exist on the public site?** Its six English labels are the only hard-coded user text found.
7. **Is the web app staying closed?** If yes, the closed-tracker copy (1,226 keys) can leave the web repo; if no, risk 1 becomes urgent.
8. **Menopause term:** which of the three Arabic phrases is the house term?
9. **Gendered forms:** should the app adopt the feminine form everywhere, or keep a neutral "you" where the sentence allows? The owner's voice is feminine on the public side.
10. **Why does the public payload list `appNav`?** Hypothesis: a leftover from before the app shell had its own layout. Removal is safe if no public page renders it (**Checked**: only the (app) layout renders `AppNav`).
