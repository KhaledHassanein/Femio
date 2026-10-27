# Study 03: web UI components (`apps/web/src/components/**`)

Scope: the React components under `apps/web/src/components/`. Read-only study. Only this report and its graph file were written.

Labels used below: **Checked** = I read the file or ran a check on this repo. **From the docs** = a repo document says it, I did not verify it in code. **Hypothesis** = my reading, not proven.

Reading method, stated plainly: all 121 files were opened. Full line-by-line reads were done for the public-site and shared pieces (calculators, `ui/`, `site/`, `theme-*`, `crisis/`, `cms/`, `learn/`, `seo/`, `analytics/`, `search/`, `tools/`, `app-nav`, `signed-in-tabs`, `offline-sync`, `auth-gate`, `patterns/app-screen`, `patterns/loading-state`, `charts/primitives` header). The signed-in tracker files were **skimmed** (file header comment, Supabase/fetch calls, colour and magic-number grep) rather than read in full. Strings were swept by grep (quoted phrases, JSX text, attribute values) and each hit was checked to see whether it was code or a comment.

Note on size: the brief said about 150 files. The real count is **121 files, 16,291 lines**.

---

## 1. Purpose in one paragraph

This folder holds every React component the Next.js web app renders. There are two audiences in it. The first is the **public website** (home, learn library, conditions, articles, the five calculators, search, trust pages such as privacy and terms, the crisis help page, the "get the app" page, the header and footer). That site is what stays after the owner's 2026-10 direction, which turns the web into a static teaser that sends people to a private Android app. The second is the **signed-in web tracker** (dashboard, cycle calendar, log, pregnancy, fertility, medications, patterns, screeners, settings, sharing, onboarding, sign-in). That tracker is closed in production: `webAppEnabled()` in `apps/web/src/lib/web-app.ts` returns false unless `NEXT_PUBLIC_WEB_APP_ENABLED=1` (Checked: lib/web-app.ts:12-14), and every app route redirects to `/app`. The tracker code is kept so its tests still run in CI. The `ui/` folder holds the shared building blocks (button, input, card, and so on) that both audiences use. The owner's product direction is a private Flutter Android app, with the website as a static teaser, so the tracker folders are candidates for deletion, while the public-site pieces are candidates to keep.

---

## 2. Inventory table (folder level, because the folder holds more than 60 files)

Status key: **live** = used by the public site or shared by it. **app-only** = closed signed-in web tracker only. **dead** = nothing imports it. **duplicate** = a second copy of something that exists elsewhere. **unknown** = not settled by this read.

| Path | Files | Lines | Purpose (short) | Status |
|---|---|---|---|---|
| `site/` | 5 | 362 | Public header, footer, trust-page layout, drawn phone picture, Bloom/petal motifs | live |
| `calculators/` | 10 | 788 | Five public calculators plus shared layout, mini calendar, pregnancy progress bar | live |
| `cms/` | 2 | 279 | Article renderer (byline, reviewed badge, sources, FAQ schema) and hub list | live |
| `learn/` | 2 | 220 | Learn library hub (search box, question chips, topic rows, week grid) and cover art | live |
| `crisis/` | 2 | 203 | Floating help button, help dialog, shared crisis copy view (ADR-013) | live |
| `seo/` | 1 | 10 | JSON-LD script tag | live |
| `analytics/` | 1 | 34 | Renders nothing; reports a page "area" view (consent-gated) | live |
| `search/` | 1 | 226 | Public search screen over a static index fetched from `/api/search-index/{locale}` | live |
| `ui/` | 12 | 555 | Button, input, label, textarea, card, alert, badge, chip, skeleton, separator, choice-row, hero-card | live (shared), except `choice-row` and `hero-card`, which are app-only |
| `patterns/loading-state.tsx` | 1 of 7 | 26 | Skeleton loading block (used by search too) | live |
| `patterns/error-state.tsx`, `patterns/empty-state.tsx` | 2 of 7 | 69 | Error and empty panels; only the design gallery imports them | duplicate (error) / dead in production (empty) |
| `patterns/` (rest) | 4 of 7 | 470 | Screen frame (`app-screen`), inline read error, pattern screen, finding card, tests | app-only |
| `theme-provider.tsx`, `theme-toggle.tsx` | 2 | 41 | next-themes wrapper; sun/moon button | live |
| `app-nav.tsx`, `signed-in-tabs.tsx`, `offline-sync.tsx` | 3 | 229 | Signed-in top bar and bottom tabs; tab bar shown on public pages only for a signed-in user (never, while closed); offline queue flush | app-only |
| `auth/` | 6 | 549 | Sign-in form and screen, reset password, MFA challenge and screen, auth gate | app-only |
| `account/` | 14 | 2,416 | Settings, consent, notifications, MFA, password, export, delete, sharing, visit summary | app-only |
| `admin/` | 2 | 387 | Internal insights tables and translation editor | app-only |
| `dashboard/` | 1 | 357 | The signed-in home screen | app-only |
| `cycle/` | 14 | 1,943 | Cycle calendar, day strip, period and symptom loggers, phase strip, predictions | app-only |
| `experience/` | 14 | 2,127 | Persona-driven modules (`module-registry`, per-track screens), v2 host, persona offer, tests | app-only |
| `log/` | 3 | 654 | Log screen v2 and severity chip (with one test) | app-only |
| `pregnancy/` | 7 | 1,281 | Pregnancy panel, due date, symptoms, movement counter, contraction timer, weight chart, end pregnancy | app-only |
| `postpartum/` | 1 | 203 | Postpartum mood check (EPDS) | app-only |
| `menopause/` | 2 | 424 | Menopause panel and MRS screener | app-only |
| `fertility/` | 1 | 349 | Fertility toolkit (BBT, OPK, mucus) | app-only |
| `medications/` | 1 | 333 | Medicines and supplements list | app-only |
| `appointments/` | 2 | 412 | Appointments list and next-appointment card | app-only |
| `screeners/` | 2 | 185 | PHQ-9 and GAD-7 screeners, intro | app-only |
| `onboarding/` | 1 | 501 | Onboarding wizard (four steps) | app-only |
| `tools/` | 1 | 124 | Flat list of everything the app can do | app-only |
| `charts/primitives.tsx` | 1 | 414 | Seven chart primitives | dead (no importer) |
| `*.test.ts` (inside `experience/`, `log/`, `patterns/`) | 3 | 182 | Tests for the experience registry, severity chip and screen states | app-only (tests) |

Totals: 121 files, 16,291 lines. Top-level files (5): `app-nav.tsx`, `offline-sync.tsx`, `signed-in-tabs.tsx`, `theme-provider.tsx`, `theme-toggle.tsx` (Checked by `wc -l`).

Per-file status for the public-facing set (the files the teaser needs):

| Path | Lines | Purpose | Status |
|---|---|---|---|
| `site/site-header.tsx` | 86 | Sticky header: search icon, help link, theme toggle, "get the app" button, section links | live |
| `site/site-footer.tsx` | 82 | Three link columns, tagline, help button, rights line | live |
| `site/motifs.tsx` | 57 | Bloom, petal, moon, spark SVG drawings, decorative | live |
| `site/phone-mock.tsx` | 79 | Drawn phone showing a sample Today screen (the teaser's product picture) | live |
| `site/trust-page.tsx` | 58 | Shared layout for about, editorial, medical review, privacy, terms | live |
| `calculators/calculator-layout.tsx` | 64 | Back link, title, intro, the calculator, the app call-to-action, disclaimer | live |
| `calculators/period-calculator.tsx` | 108 | Next period range from last period date, cycle range, period length | live |
| `calculators/due-date-calculator.tsx` | 66 | Due date and term window from last period date | live |
| `calculators/gestational-age-calculator.tsx` | 47 | Weeks and days on a chosen date | live |
| `calculators/ovulation-calculator.tsx` | 75 | Fertile window, ovulation day, next period | live |
| `calculators/pregnancy-test-calculator.tsx` | 102 | When to test, from a period or from a sex date | live |
| `calculators/cycle-length-calculator.tsx` | 75 | Average and range from a list of period start dates | live |
| `calculators/bmi-calculator.tsx` | 83 | BMI with metric or imperial units | live |
| `calculators/mini-calendar.tsx` | 128 | Month grid drawing the results (display only, `aria-hidden`) | live |
| `calculators/pregnancy-progress.tsx` | 40 | Trimester bar, 40 weeks | live |
| `cms/content-article.tsx` | 228 | Article page: byline, reviewed badge, body, disclaimer, sources, FAQ JSON-LD | live |
| `cms/content-hub.tsx` | 51 | List of articles or conditions | live |
| `learn/learn-hub.tsx` | 184 | Learn hub | live |
| `learn/topic-art.tsx` | 36 | Hashed crop of a per-topic SVG cover | live |
| `crisis/crisis-help-provider.tsx` | 140 | Global help button and native `<dialog>` (ADR-013) | live |
| `crisis/crisis-content-view.tsx` | 63 | Crisis copy view (server-safe, no hooks) | live |
| `theme-toggle.tsx` | 30 | Light/dark button | live |
| `theme-provider.tsx` | 11 | next-themes wrapper | live |
| `seo/json-ld.tsx` | 10 | JSON-LD script | live |
| `analytics/page-view.tsx` | 34 | Area view event, renders nothing | live |
| `search/search-screen.tsx` | 226 | Search across the static index plus tools | live |
| `ui/button.tsx` | 54 | Button with Femio tokens | live |
| `ui/input.tsx`, `ui/label.tsx`, `ui/textarea.tsx` | 24 + 19 + 22 | Form primitives | live |
| `ui/card.tsx`, `ui/alert.tsx`, `ui/badge.tsx`, `ui/chip.tsx` | 37 + 45 + 30 + 54 | Surfaces and pills | live |
| `ui/skeleton.tsx`, `ui/separator.tsx` | 10 + 23 | Loading block, divider | live |
| `patterns/loading-state.tsx` | 26 | Skeleton loading with a hidden label | live |

---

## 3. Key modules and responsibilities

**`calculators/calculator-layout.tsx`** (64 lines). Input: title, intro, disclaimer and back-link text (strings from the caller), locale, path, children. Output: the page chrome around the calculator. Calls `PageView` (analytics), `JsonLd` with `webApplicationJsonLd`. Called by seven public calculator pages under `apps/web/src/app/[locale]/(public)/calculators/*`. Checked.

**`calculators/*-calculator.tsx`** (six calculator screens plus BMI). Each is a `"use client"` component holding its own `useState` for inputs as **strings**, converts with `Number(x) || default`, calls one pure function from `@/lib/calculators` (for example `periodForecast`, `estimateDueDate`, `fertileWindow`, `pregnancyTestFromPeriod`, `cycleStats`, `bmi`), and calls `useCalculatorUsed` (analytics). No date maths lives here except small helpers. Checked.

**How dates are entered today (Checked).** Native `<input type="date">` everywhere (period-calculator.tsx:41, due-date-calculator.tsx:32, gestational-age-calculator.tsx:31 and :27, ovulation-calculator.tsx:36, pregnancy-test-calculator.tsx:65, cycle-length-calculator.tsx:35). The cycle-length calculator keeps an array of such fields, starting with two, with an add button and a remove button (cycle-length-calculator.tsx:15, :19, :20, :54). Cycle length, period length and BMI are `type="number"` inputs with min and max from the lib constants (period-calculator.tsx:48-75, due-date-calculator.tsx:38, ovulation-calculator.tsx:42, pregnancy-test-calculator.tsx:72). **There are no dropdowns in any calculator** (grep for `<select>` in the calculators folder found none; the only selects in the folder tree are in `account/notification-settings.tsx:188,207` for quiet hours and `onboarding/onboarding-wizard.tsx:347`). The **MiniCalendar** (`mini-calendar.tsx`) is output only: it draws up to three months from a map of day marks, is `aria-hidden` (line 68), and cannot be typed into. The OS date picker handles the input on a phone.

**`calculators/mini-calendar.tsx`** (128 lines). Input: a map from ISO date to a mark (`period`, `periodMaybe`, `fertile`, `ovulation`, `test`), plus a from and to date. Output: month grids. Week start depends on locale (`WEEK_START`, line 25: Saturday for Arabic, Monday for French and Spanish). Colours come from `STYLE` (lines 16-22). Called by period, ovulation and pregnancy-test calculators. Checked.

**`ui/button.tsx`, `ui/input.tsx`, `ui/card.tsx`, `ui/alert.tsx`, `ui/chip.tsx`** (shared primitives). Input: props plus variant. Output: a styled element with Femio semantic token classes (`bg-primary-solid`, `bg-surface`, `text-text`, and so on). `alert.tsx` has a `danger` variant documented as the red-flag box (lines 5-6). `chip.tsx` is the one selectable pill used by every logger (lines 3-15). Called by almost every screen. Checked.

**`site/site-header.tsx`** (86 lines). Input: locale. Output: sticky header with an icon search link, a "Need help now" link to `/help-now` (hidden under 640px), the theme toggle, and one call-to-action button that points to `/sign-in` if the web app is open, else to `/app` (lines 60-65). Section links come from a fixed list (lines 16-22). Calls `getCrisisContent` and `webAppEnabled`. Called by `(public)/layout.tsx`. Checked.

**`site/site-footer.tsx`** (82 lines). Three columns (explore, trust, legal), a tagline, a help button, and the rights line. Link lists are fixed constants (lines 10-26). Calls `isUnpublishedSection` to hide sections not yet published. Checked.

**`site/phone-mock.tsx`** (79 lines). A drawn picture of the app's Today screen built from tokens, not an image. Takes translated strings as props. It is the public site's product picture until real screenshots exist (From the file header). Checked.

**`crisis/crisis-help-provider.tsx`** (140 lines). Mounted in the locale layout (`app/[locale]/layout.tsx`, Checked). Provides `useCrisisHelp()` (open, close, isOpen) through context, a fixed-position lifebuoy launcher (line 81-98), and a native `<dialog>` (lines 100-137). Its file header states the constraints: `open()` takes no arguments, nothing is recorded, copy is static and bundled, so it works offline. Checked.

**`crisis/crisis-content-view.tsx`** (63 lines). Presentational copy for the crisis route and dialog. Deliberately hook-free so `/help-now` works with JS disabled. Splits a translated sentence on the literal token `{directory}` (line 24) to place an external link. Checked.

**`cms/content-article.tsx`** (228 lines). Server component. Takes a CMS document (`ContentDoc` from `@/lib/cms/client`), renders its body with `RichText` (`@/lib/cms/lexical`), emits up to four JSON-LD blocks, and shows the byline. It says "reviewed in English by" on non-English pages (lines 218-221), a deliberate rule (R3.8 in the comment). Checked.

**`learn/learn-hub.tsx`** (184 lines). Server component. Takes articles and locale, groups them by topic (`@/lib/content/topics`), shows a search form that submits as a plain GET to `/{locale}/search` (lines 46-63), a list of questions, a "start here" row, topic rows, and a 6-or-10-column grid for pregnancy weeks. Checked.

**`search/search-screen.tsx`** (226 lines). Client component. Fetches `/api/search-index/{locale}` once per locale (line 54), ranks in the browser with `@/lib/search`, and shows a fallback notice when the index is English only. Tool titles come from the `tools` message namespace. Checked.

**`analytics/page-view.tsx`** (34 lines). Renders nothing. Calls `track("page_viewed", {area, locale})` on mount with a literal area from a closed set. The file header says there is no route-to-event path (ADR-017, ADR-025). Checked.

**Signed-in tracker modules (skimmed).** `cycle/track-screen.tsx`, `dashboard/dashboard-screen.tsx`, `experience/module-registry.tsx` and the per-track experience screens read Supabase tables through `useSupabaseQuery` and `unwrap` from `@/lib/supabase/use-query` (for example `cycle/track-screen.tsx:82`, `dashboard/dashboard-screen.tsx:53`). They render modules by id from a served `ExperienceConfig` document (ADR-060, ADR-061, From the file headers). None of them is reached by a public route.

---

## 4. Data flow

**Entry points for data**
- Browser to public pages: the page is static or ISR. Public pages read CMS content on the server (`cms/`, `learn/`) through `@/lib/cms` and `@/lib/content` (lib not read in this study).
- Browser to search: `search/search-screen.tsx:54` fetches `/api/search-index/{locale}`, an API route in `apps/web/src/app/api/search-index/[locale]/route.ts` (Checked, route exists).
- Browser to reading list: `experience/reading-list.tsx:55` fetches `/api/reading` (app-only).
- Environment: `crisis/crisis-help-provider.tsx:53` reads `NEXT_PUBLIC_CRISIS_DIRECTORY_URL` and renders it only when set (Checked). `auth/sign-in-form.tsx:32` reads `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH` (app-only).
- User input stays in component state (calculators, search). Calculator inputs are never sent anywhere: the calculators call pure functions in the browser (Checked: no `fetch` or `track` payload carries calculator values; `useCalculatorUsed(boolean)` only reports that a result exists).

**Where it is stored**
- In the browser only, for the app-only parts: `localStorage` for log category order (`log/log-screen-v2.tsx:153`, From its header: "preferences are not health data"), for persona offer dismissals keyed by user id (`experience/persona-offer.tsx:95`, `:118`, `:160-162`, Checked), and for the cached experience document (`account/sign-out-button.tsx:14-16` says it carries recorded conditions, From the comment; the cache code is in `lib/experience`, not read).
- The public calculators store nothing.
- Supabase Postgres holds the tracker data, but only the closed app writes to it (`from("cycles")`, `from("symptom_logs")`, and so on, Checked by grep). Public pages do not query Supabase at all, with one exception described next.

**Where it leaves**
- `signed-in-tabs.tsx:4` imports `createClient` from `@/lib/supabase/client` into the public layout. It calls `createClient()` only when `webAppEnabled()` is true (lines 21 and 30). With the web app closed, no network call is made (Checked). The import still puts the Supabase client code in the public bundle (Hypothesis; bundle size not measured).
- `analytics/page-view.tsx` and `calculator-layout` call `track()` from `@/lib/analytics/track`. Where events go, and whether consent gates them, is in the lib and was not read.
- `crisis-content-view.tsx` renders an external directory link with `referrerPolicy="no-referrer"` (line 44) when configured.
- Fonts: `tailwind.config.ts:24-33` refers to `next/font` variables (`--font-sans-latin`, `--font-plex-arabic`, `--font-display-latin`, `--font-naskh`) loaded in the locale layout (From the config comment; the layout was not read).

**External services named in this area**
- Supabase (auth and Postgres): app-only; the public site only imports the client module (Checked).
- Vercel (hosting): From the docs (CLAUDE.md "Live: femioapp.com ... on Vercel").
- Google sign-in: app-only, behind a flag (Checked, `auth/sign-in-form.tsx:86-101`).
- Sentry, PostHog, Vercel Analytics, gtag or Google Tag Manager: **not found** anywhere in `apps/web/src/components/` (Checked by a case-insensitive grep). Not searched app-wide.
- Fonts CDN: not checked.

---

## 5. Dependencies

**What this area imports from elsewhere (examples, Checked)**
- `@/lib/calculators`, `@/lib/calculators/dates` (all calculators).
- `@/lib/crisis/content` (crisis provider, header).
- `@/lib/seo/jsonld`, `@/lib/seo/config` (calculator layout, cms).
- `@/lib/web-app` (`webAppEnabled`, `APP_PAGE`, header and tabs).
- `@/lib/analytics/track`, `@/lib/analytics/events`, `@/lib/analytics/use-calculator-used` (analytics and calculators).
- `@/lib/cms/client`, `@/lib/cms/lexical`, `@/lib/cms/faq`, `@/lib/cms/format` (cms, learn).
- `@/lib/content/topics`, `@/lib/content/unpublished-sections` (learn, footer, header).
- `@/lib/search`, `@/lib/search/corpus`, `@/lib/search/library` (search).
- `@/lib/supabase/client`, `@/lib/supabase/use-query` (app-only).
- `@/lib/experience/*`, `@/lib/persona/*`, `@/lib/cycle/*`, `@/lib/patterns`, `@/lib/screeners/*`, `@/lib/vitals/*`, `@/lib/fertility`, `@/lib/medications`, `@/lib/menopause`, `@/lib/pregnancy`, `@/lib/contractions`, `@/lib/consent/*`, `@/lib/account/*`, `@/lib/appointments` (app-only; not read).
- `@/i18n/navigation` (`Link`, `usePathname`, `useRouter`), `@/i18n/routing` (types), `next-intl`, `next-themes`, `lucide-react`, `class-variance-authority`, `@radix-ui/react-slot` (button), `@/lib/utils` (`cn`).
- `@/lib/ui/range-band` (type only, hero card).
- Inside the folder: `ui/*` is imported by nearly everything; `patterns/app-screen` by 15 files; `analytics/page-view` by 14; `auth/auth-gate` by 14 (app pages); `calculators/calculator-layout` by 7 public pages.

**What imports this area**
- App Router pages under `apps/web/src/app/[locale]/(public)/**` (calculators, learn, conditions, search, trust pages, app page, home, FAQ, glossary, authors).
- `apps/web/src/app/[locale]/(app)/**` (all tracker routes).
- `apps/web/src/app/[locale]/layout.tsx` (crisis provider, theme provider), `(public)/layout.tsx` (header, footer, signed-in tabs), `help-now/page.tsx` (crisis view), `sign-in/page.tsx`, `welcome/page.tsx`, `reset-password/page.tsx`, `components/page.tsx` (design gallery).
- `apps/web/src/hooks/use-crisis-help.ts` (crisis provider).
- Tests in `apps/web/src/lib/experience/*.test.ts` import `experience/module-registry`.

---

## 6. Strings and i18n

**Standard in this area (Checked):** nearly all user copy goes through `useTranslations` or `getTranslations`. About 837 literal `t("…")` keys are called from these components. The public header, footer, calculators, and crisis copy all come from message keys. The brand wordmark `femio` is typed literally in four places on purpose, as product rule 6 requires: `site/site-header.tsx:35`, `site/site-footer.tsx:57`, `site/phone-mock.tsx:35`, and `app-nav.tsx:117`. The crisis copy is approved text bundled in `lib/crisis/content` (ADR-013).

**Hard-coded user-facing strings and punctuation found in code (not comments)**

| Where | What | Why it matters |
|---|---|---|
| `account/partner-sharing-screen.tsx:387` | `placeholder="ABCD-2345"` | Example code shown in a field, not translated. Low risk, but it is user-visible. |
| `cms/content-article.tsx:164` | `` ` · ${t("tier", { tier: s.tier })}` `` | Literal " · " separator. Not localized. |
| `cms/content-article.tsx:201` | `` `${p.name}, ${p.credentials}` `` | Literal ", " between name and credentials. |
| `cms/content-article.tsx:206` | `", "` between author names | Literal separator. Arabic punctuation would be wrong. |
| `calculators/cycle-length-calculator.tsx:63` | `{t("cycleLength.rangeLabel")}: {days(...)} – {days(...)}` | Literal ": " and en dash "–". |
| `calculators/ovulation-calculator.tsx:61` and `:64` | `{t("ovulation.ovulationLabel")}: {fmt(...)}`, and the same for next period | Literal ": " after a translated label. |
| `calculators/cycle-length-calculator.tsx:38` | `aria-label={`${t("cycleLength.datesLabel")} ${i + 1}`}` | Word order is fixed in code; Arabic may read differently. |
| `account/export-button.tsx:14` | `femio-export-${date}.json` | Download file name is English only. |
| `auth/reset-password-form.tsx`, `account/set-password.tsx` | `const MIN = 8` | Number, not a string. Listed under magic numbers. |

Strings in **comments** that look like copy (for example "Need help now?" in `crisis-help-provider.tsx:21`, "Reviewed by Dr X" in `cms/content-article.tsx:189`, "Step 1 of 3" in `onboarding/onboarding-wizard.tsx:199`, "Femio won't guess a phase" in `experience/cycle-experience.tsx:264`) were checked and are comments, not rendered text.

Code-only English strings that are developer-facing (not user copy): `crisis/crisis-help-provider.tsx:45` (thrown error), `experience/v2/module-registry-v2.tsx:45-46` (console warning), `search/search-screen.tsx:55` (thrown error).

**Locale-specific logic in components (Checked)**
- `calculators/mini-calendar.tsx:25`: week start per locale (`ar: 6`, `fr: 1`, `es: 1`, `en: 0`). Only four locales are listed; the app's locale list comes from `@/i18n/routing` (not read).
- `admin/translation-editor.tsx:18`: `TARGETS = ["ar", "fr", "es"]` duplicates the locale list in code.
- `cms/content-article.tsx:220`: `locale === "en"` decides between two keys.
- `cms/content-article.tsx:56`: `dir` is set to `rtl` only for `ar` (other RTL locales would be missed; the app has none today, From the docs).
- `learn/learn-hub.tsx:33`: article slug `"meet-femio"` is hard-coded and filtered out of the topic rows.

**Direction and RTL.** Layout uses logical properties (`start-`, `end-`, `ps-`, `pe-`, `text-start`, `ms-`), which fits product rule 6 (Checked in `site-header`, `site-footer`, `crisis-help-provider`, `learn-hub`, `choice-row`). Some explicit `rtl:` variants exist (`calculator-layout.tsx:41`, `calculator-layout.tsx:43`, `pregnancy-progress.tsx:34`). `phone-mock.tsx:32` uses `rtl:translate-x-1/2`, which is correct for a mirrored layout.

---

## 7. Tests

**Test files inside this folder (Checked, all read):**
- `experience/module-registry.test.ts` (41 lines). Checks that every module id the Track D registry declares is either implemented or listed as unimplemented, and that the two persona-defining strips are implemented. Imports `IMPLEMENTED` and `UNIMPLEMENTED` from `module-registry.tsx`. Tracker only.
- `log/severity-chip.test.ts` (20 lines). Checks the severity cycle 1→2→3→4→1 and that zero is never reached. Tracker only.
- `patterns/screen-states.test.ts` (121 lines). Reads source text with `readFileSync` and asserts strings (for example `useOnline`, `variant={online ? "danger" : "warning"}`, and offline copy in four locales). It checks source text, not rendering, so it breaks on harmless rewrites and passes on wrong rendering. Tracker only (the file covers `app-screen`).

**Tests that reach public components from elsewhere:** `apps/web/e2e/` (Playwright) has specs whose text mentions calculators, help-now, learn, search, or the home page: `a11y.spec.ts`, `crisis.spec.ts`, `home.spec.ts`, `learn.spec.ts`, `not-found.spec.ts`, `page-weight.spec.ts`, `search.spec.ts`, `sitemap.spec.ts` (matched by grep on text; the specs were not opened in this study).

**Untested in this folder (Checked by listing):** no test file exists for any calculator component, `mini-calendar`, `site-header`, `site-footer`, `phone-mock`, `crisis-help-provider`, `crisis-content-view`, `cms/content-article`, `learn-hub`, `search-screen`, `theme-toggle`, or any `ui/` primitive. The calculators' arithmetic is probably tested in `lib/calculators` (not read here).

**`charts/primitives.tsx`** (414 lines) has no tests and no importer.

---

## 8. Smells, risks, dead code (with path:line)

**Dead code**
- `charts/primitives.tsx` (414 lines): nothing imports it (Checked: grep for `charts/primitives` across `apps/web/src` returns zero). Its header says it was built for "RB-C3" charts. Deleting it is safe.
- `patterns/empty-state.tsx` and `patterns/error-state.tsx`: imported only by `app/[locale]/components/page.tsx` (the design gallery). `error-state` duplicates the purpose of `patterns/app-screen.tsx`'s `ScreenError` (lines 74-107).
- `ui/textarea.tsx`: two importers, one of them the gallery. Keep only if a form needs it.

**Duplication**
- `site/site-header.tsx:16-22` (`LINKS`) and `site/site-footer.tsx:10-16` (`EXPLORE`) list the same five public sections, in two places. A new section must be added twice.
- `calculators/*`: the default cycle length `28` is typed in six places: `period-calculator.tsx:17-18`, `:23`; `due-date-calculator.tsx:17`, `:19`; `ovulation-calculator.tsx:16`, `:18`; `pregnancy-test-calculator.tsx:25`, `:28`. A named constant belongs in `lib/calculators`. The fallback `Number(x) || 5` for period length is at `period-calculator.tsx:21`.
- Two loggers for the same thing: `log/log-screen-v2.tsx` (492 lines) and the `cycle/log-period.tsx` and `cycle/log-symptoms.tsx` pair, plus `pregnancy/log-pregnancy-symptoms.tsx`. Which ones the track screen uses at run time was not fully traced (Hypothesis: they overlap).
- Two rendering paths for experience modules: `experience/module-registry.tsx` (v1) and `experience/v2/module-registry-v2.tsx` (adapter), switched by `useSurfaceVersion` (`cycle/track-screen.tsx:11`, `experience/module-registry.tsx:6-9`). Flagged, not removed.
- Selected-state classes repeated inside `ui/chip.tsx` lines 43 and 49 (the base variant and a compound variant both set the same border and fill).

**Magic numbers and colour literals**
- `calculators/bmi-calculator.tsx:22-23`: `0.453592` (pounds to kilograms) and `2.54` (inches to centimetres), unnamed.
- `calculators/mini-calendar.tsx:58`: `"2026-01-04"` used as a known Sunday anchor. Commented, correct, but a magic date.
- `calculators/pregnancy-progress.tsx:6-11`: segment weeks `14`, `14`, `12` and total `40` (`TERM`); `:34` `size-5`, `border-[3px]`.
- `site/phone-mock.tsx:17-24`: phase days `5`, `7`, `4`, `12`, length `28`, today `12`. These repeat the cycle model in `lib`, so they will drift. `:30` raw colour `#1d0f1c`, a shadow `shadow-[0_30px_80px_-20px_rgb(0_0_0/0.55)]`, and `bg-black` (`:32`). `:30`, `:33`: fixed `w-[248px]`, `h-[500px]`.
- `ui/hero-card.tsx:76`: `Math.max(…, 2)`; `:86` a long arbitrary gradient string; `:90` `inset-y-[-3px] w-[3px]`; `:91` `marginInlineStart: "-1.5px"`.
- `ui/choice-row.tsx:124`: `shadow-[inset_0_0_0_3px_var(--surface)]`.
- `ui/button.tsx:17`: `tracking-[0.005em]` and the whole class string; heights `h-9`, `h-11`, `h-12`, `size-11` at `:31-34`.
- `learn/topic-art.tsx:19-23`: FNV hash constants `2166136261` and `16777619`, unnamed; `:27-28`: `% 101` placement math.
- `search/search-screen.tsx:65`: `DEBOUNCE_MS = 120` (named, fine); `:80` `slice(0, 200)`; `:110` tool hit limit `5`; `:114` library hit limit `20`.
- `onboarding/onboarding-wizard.tsx:51`: `Array.from({ length: 15 }, (_, i) => i + 21)`, the allowed cycle length range (21 to 35), with the source explained in the comment at lines 46-47.
- `pregnancy/contraction-timer.tsx:71` and `pregnancy/movement-counter.tsx:74`: `1000` ms tick.
- `auth/reset-password-form.tsx:15` and `account/set-password.tsx:13`: `const MIN = 8` (password minimum typed in two places).
- `auth/sign-in-form.tsx:176`: `email.length < 4`, a loose email check.
- `admin/insights-panels.tsx:97`: `* 96` pixel bar width.
- `patterns/app-screen.tsx:37`: `px-5 py-6`, which the comment at lines 16-18 says was tuned for phones (fine, but not a token).
- Colour literals found by grep (Checked): raw hex `#1d0f1c` (`site/phone-mock.tsx:30`), a raw `rgb()` inside a shadow (same line), and stock Tailwind colours in 18 places: `text-white`, `bg-white`, `border-white` and `ring-white` (`site/site-footer.tsx:28-72`, `learn/learn-hub.tsx:61-74`, `site/phone-mock.tsx:30`), `bg-black` (`crisis/crisis-help-provider.tsx:111`, `site/phone-mock.tsx:32`), and `text-black/80` (`calculators/mini-calendar.tsx:20`). `#7C3AED` appears only in a comment (`charts/primitives.tsx:39`).
- Most colour is token-based, and the token preset has no key for the stock colours above. The stock colours still work (Tailwind defaults are kept), but they bypass the Dusk Bloom tokens and will not follow the theme (Checked against the preset keys in `assets/brand/tokens/femio.tailwind.preset.js`).

**Comment and doc mismatches**
- `ui/input.tsx:4` says the input is "44px tall (touch target)". The code is `h-12` at line 13. The preset's `spacing.12` is `48px` (Checked, `femio.tailwind.preset.js:78`). So the comment and the code disagree by 4px, and the code is the larger value. The font size claim (16px, to avoid iOS zoom) is right: the preset maps `text-sm` to `16px` (Checked, line 67).
- `ui/alert.tsx`, `ui/badge.tsx` and `ui/chip.tsx` cite `docs/12` for rules. Not checked against that doc.
- `onboarding/onboarding-wizard.tsx:43` sets `TOTAL_STEPS = 4`, while a comment at line 199 mentions "Step 1 of 3" (Hypothesis: stale comment).
- `pregnancy/pregnancy-panel.tsx` (header) and `menopause/menopause-panel.tsx` (header) say the component "cannot run in a Capacitor bundle". The owner's plan moved mobile to Flutter (ADR-060, From CLAUDE.md), so these notes are stale.
- `patterns/app-screen.tsx:44-54` and `:55-73` hold two doc blocks in a row above `ScreenError`; the first one describes the same component and reads as if it belonged to another.
- `crisis/crisis-help-provider.tsx:19-31`: the header comment has a line break in the middle of a sentence ("...and / an accessible native <dialog>"), a formatting nit.

**Risks**
- `signed-in-tabs.tsx:4` pulls Supabase client code into every public page while the web app is closed (Hypothesis; bundle size not measured).
- `experience/persona-offer.tsx:95-162` and `log/log-screen-v2.tsx:153` write to `localStorage`. The persona-offer keys include the user id (`dismissKey(user.id, suggestionId)`, Checked). Health-adjacent data in browser storage is a privacy question for the owner, not a bug as far as this read shows.
- `account/sign-out-button.tsx:14-16` says the cached experience document holds recorded conditions and must be cleared at sign-out. It is cleared (line 26). The storage itself is in `lib/experience`, not read.
- `crisis/crisis-content-view.tsx:24`: the split on `{directory}` assumes the token is present in every translation. A translation without the token leaves `after` undefined and drops the link text. Hypothesis, not tested.
- `app/[locale]/components/page.tsx` (the design gallery, a route in the app tree, not in `components/`): a grep for `notFound`, `NODE_ENV`, or a production check in that file found none (Checked). If the route is deployed, the gallery is public. Owner question.
- `search/search-screen.tsx`: the search index is one JSON file per locale fetched from an API route. If the index fails, tool results still show (lines 107-110, good). A failed index is shown as an error, not "no results" (lines 173-179, good).
- `patterns/screen-states.test.ts`: tests check source text by regex. This is the R1.9l approach, a deliberate choice, but it is brittle.

**Things done well (Checked)**
- Crisis route is never gated; its copy is bundled and it works offline (`crisis-help-provider.tsx:19-31`).
- Calculators hold no health data and send nothing; `useCalculatorUsed` is a boolean.
- Results are shown as numbers and ranges, never as a grade. The BMI screen shows a category label, which is an explicit WHO-style band; that is a judgement the owner may want to review (open question).
- The MiniCalendar is `aria-hidden` and the sentence above it is the accessible result (`mini-calendar.tsx:9-12`).

---

## 9. Keep / rebuild / delete verdict

Judged against the direction: a private Android app (Flutter, records on the phone, no accounts) is the product; the website is a static teaser (articles, calculators, SEO) that sends people to the app; no Supabase at runtime; wedge is Arabic-first TTC to pregnancy with PCOS depth, Saudi and Egypt.

**Keep for the static teaser**
- `site/site-header.tsx`: keep. Rebuild only the duplicated LINKS list (share with the footer) and move colours to tokens.
- `site/site-footer.tsx`: keep. Same link-list fix. Replace `text-white` with tokens.
- `site/phone-mock.tsx`: keep as the teaser's product picture, but take phase counts from the cycle lib, not from literals, and remove `#1d0f1c`. Rebuild to a static image later if the teaser moves to a CDN image.
- `site/motifs.tsx`: keep (decorative, tokenized).
- `site/trust-page.tsx`: keep.
- `calculators/*` (all six plus layout, mini calendar, pregnancy progress): **keep**. The date entry is native inputs, which is the right choice for a static teaser on phones. Do not rebuild as dropdowns; the native picker is better. Fix: named constant for 28 and 5, bmi conversion constants, the ": " and "–" punctuation, and the `/app` call-to-action wording. The mini calendar stays display-only.
- `cms/content-article.tsx`, `cms/content-hub.tsx`: keep the components. **Rebuild the data source** only if the content moves from Payload to the repo (From the docs, D3 says Payload is retired; the lib was not read). Fix the hard-coded separators (lines 164, 201, 206).
- `learn/learn-hub.tsx`, `learn/topic-art.tsx`: keep. Remove the `"meet-femio"` slug filter (line 33) and name the hash constants.
- `crisis/crisis-help-provider.tsx`, `crisis/crisis-content-view.tsx`: keep verbatim. ADR-013 requires it, and the rule forbids gating.
- `search/search-screen.tsx`: keep. The static-index design fits the teaser. Confirm the index is generated at build time, not served by an API route, in the rebuilt site.
- `analytics/page-view.tsx`: keep only if the owner keeps first-party page-area analytics on the teaser (open question 2). Otherwise delete.
- `seo/json-ld.tsx`, `theme-provider.tsx`, `theme-toggle.tsx`, `patterns/loading-state.tsx`: keep.
- `ui/button.tsx`, `ui/input.tsx`, `ui/label.tsx`, `ui/card.tsx`, `ui/alert.tsx`, `ui/badge.tsx`, `ui/chip.tsx`, `ui/skeleton.tsx`, `ui/separator.tsx`: keep. **Rebuild the input height claim**: either make it `h-11` (44px, matching the comment and the touch target) or fix the comment. Remove the duplicated selected classes in `chip.tsx` (lines 43, 49). Do not run `shadcn add` over these files (the components.json still says `baseColor: neutral`, cssVariables true, and the preset has no `primary-foreground`, `muted`, `input`, `ring` or `background` keys, so upstream classes would resolve to nothing; Checked). Upstream shadcn defaults themselves: not verified (the shadcn registry tool returned metadata only).
- `ui/textarea.tsx`: keep if a form needs it, else delete.

**Rebuild (and why)**
- None of the public-site pieces needs a full rebuild. The rebuild items are small: the link lists, token-only colours, named constants, the separators, the input height. Each is listed above.
- `site/phone-mock.tsx` is the one candidate for a larger change, because its numbers are a copy of the cycle model; rebuild as a static image or as a component fed by the lib.

**Delete with the web tracker (closed, app-only, owner's direction is Flutter)**
- `auth/` (6 files, 549 lines), `account/` (14, 2,416), `admin/` (2, 387), `dashboard/`, `cycle/` (14, 1,943), `experience/` (14, 2,127), `log/` (3, 654), `pregnancy/` (7, 1,281), `postpartum/`, `menopause/`, `fertility/`, `medications/`, `appointments/`, `screeners/`, `onboarding/`, `tools/`, `app-nav.tsx`, `signed-in-tabs.tsx`, `offline-sync.tsx`, `patterns/` (apart from `loading-state.tsx`), `ui/choice-row.tsx`, `ui/hero-card.tsx`.
- Reason: the tracker is closed (`webAppEnabled()` is off in production, `lib/web-app.ts:12-14`), and the product is the Flutter app (ADR-060). The tests in `experience/module-registry.test.ts`, `log/severity-chip.test.ts` and `patterns/screen-states.test.ts` cover the tracker and go with it.
- The **ideas** (module registry as a served document, persona offers, distinct logging rules, the crisis-never-gated rule, the offline-not-signed-out rule, "no verdict" rules for pregnancy, the EPDS item-10 routing, the MRS and PHQ-9 "number but no grade" rule) are not in this folder's TSX. They are in the `lib` layer and the docs. Carry them into the Flutter build by writing them down as rules and tests, not by copying TSX. Before deletion, the owner should confirm they are captured in the Flutter spec.

**Delete as dead**
- `charts/primitives.tsx` (414 lines): no importer.
- `patterns/empty-state.tsx`, `patterns/error-state.tsx`: gallery-only. Delete with the gallery, or keep if the gallery stays.
- The `app/[locale]/components/page.tsx` gallery (outside this folder): delete, or gate behind a non-production check. This is a route, not part of `components/`, but it renders these components.

---

## 10. Open questions

1. **Is the design gallery (`/components`) reachable in production?** A grep found no production guard in `app/[locale]/components/page.tsx`. If it is deployed, it is a public page. Owner decision.
2. **Keep first-party page-view analytics on the teaser?** `analytics/page-view.tsx` reports area views. The lib that sends it was not read. Consent and destination need a check against the compliance rules.
3. **Is the web tracker deleted, or kept as a reference for the Flutter build?** The brief says delete with the tracker. Some ideas (served modules, persona offers) may be worth keeping as written rules. Owner to confirm.
4. **Which logger is live?** `log/log-screen-v2.tsx`, `cycle/log-period.tsx`, `cycle/log-symptoms.tsx` and `pregnancy/log-pregnancy-symptoms.tsx` may overlap. The track screen's switching was not fully traced.
5. **BMI category labels.** `calculators/bmi-calculator.tsx:75` shows a WHO-style category. This is a clinical classification shown to a user. Is it cleared under the product rules (no diagnosis), and is a source attached? `[NEEDS SOURCE]` flag if the owner wants it kept.
6. **Health data in localStorage.** `experience/persona-offer.tsx` (dismissals keyed by user id) and `account/sign-out-button.tsx` (cached experience document with recorded conditions, per its comment) both use browser storage. Is that acceptable on a shared device, and does the Flutter build keep it on the phone only (which is what the owner's direction implies)?
7. **Onboarding step count.** `onboarding/onboarding-wizard.tsx:43` sets four steps. The comment at line 199 mentions "Step 1 of 3". Which is current?
8. **Input height.** `ui/input.tsx` is 48px in code and 44px in its comment. Which is the intended touch target? Owner or design to decide; the WCAG minimum is met by both.
9. **Bundle weight of `signed-in-tabs.tsx`.** It imports the Supabase client into the public layout. Is the public page weight in the e2e `page-weight.spec.ts` near its budget? Not measured here.
10. **Does the rebuilt teaser still need `/api/search-index` at run time?** A static index built at deploy time would remove an API route. Owner or next study to confirm the CMS source (Payload vs repo).
11. **Does the teaser keep `crisis/` as a floating button on every page, including calculators?** The rule in ADR-013 says yes. Confirm it still applies to the static teaser.

---

## Graph file

`docs/32_STUDY/graph/03-web-components.json`: 120 nodes and 100 edges (file level for the components, plus cross-area targets such as the public layout, the search index and reading APIs, `lib/web-app`, `lib/calculators`, `lib/crisis/content`, the Supabase client and query hook, the token files, Tailwind config, the shadcn config, the e2e specs, and the Supabase and Vercel services). Edge kinds used: renders, imports, reads, calls, tested-by, documents. Validated: every edge endpoint is a listed node. Some nodes were left out to stay within the 120-node limit: `ui/skeleton`, `ui/separator`, `ui/textarea`, and the help-now, track, period-calculator and locale-layout routes.
