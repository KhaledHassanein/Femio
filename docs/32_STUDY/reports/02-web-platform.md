# 02 — Web platform plumbing (apps/web)

Study date 2026-10-27, worktree `femio-repo-study-planning-88d7c9`. Marks: **Checked** = I read the file or ran a command on it; **From the docs** = a comment or doc says so and I did not verify it independently; **Hypothesis** = my reading. I read every file listed in the brief except the bodies of the unit-test files (I read headers/imports only), the component trees under `src/components/**` (outside this area, only sampled for who-calls-what), and the full message catalogs (I listed namespaces and sizes only). I did not run the build, the tests or the dev server, and I did not render the icons.

## 1. Purpose in one paragraph

`apps/web` is a Next.js 15 (App Router, React 19) site that currently plays two roles. Role one is the public content site: a home page, 100 cited articles, 5 condition pages, seven calculators, search, legal and trust pages, a crisis page (`/help-now`) and a "get the Android app" page (`/app`), in four locales (en, ar, fr, es; Arabic is right-to-left). Role two is a full signed-in web tracker (about 19 routes, Supabase auth and database, offline queue, partner sharing, push, an admin back-office), which the owner has already **closed** by decision D8 / ADR-070: unless the build sets `NEXT_PUBLIC_WEB_APP_ENABLED=1` (only CI does), middleware redirects every tracker route to `/{locale}/app`. This area is the plumbing under both roles: routing and middleware, the locale layout and fonts, the i18n loader, SEO (metadata, hreflang, sitemap, JSON-LD), security headers and CSP, the PWA manifest and service worker, error monitoring, analytics gating and the Tailwind/token wiring.

## 2. Inventory table

Status values: live, app-only (closed web tracker), dead, duplicate, unknown. "Lines" are `wc -l`. Where a row says `+test`, a co-located `*.test.ts` exists (listed in section 7).

### 2.1 Routes, layouts and metadata files — `src/app/**` (Checked)

| path | lines | one-line purpose | status |
|---|---|---|---|
| `app/[locale]/layout.tsx` | 126 | Root layout: html lang/dir, 4 Google fonts via `next/font`, metadata (title template, hreflang, OG, twitter), theme + crisis providers, public-only client messages | live |
| `app/[locale]/(public)/layout.tsx` | 35 | Public shell: SiteHeader, SiteFooter, SignedInTabs; calls `setRequestLocale` (needed for static render) | live |
| `app/[locale]/(public)/page.tsx` | 427 | Home page (hero, goals, calculators, trust, close); WebSite + Organization JSON-LD; CTAs go to `/app` | live |
| `app/[locale]/(public)/app/page.tsx` | 120 | "Get the app" page: Android "coming soon", iOS later, phone mock, features, links to calculators and learn | live |
| `app/[locale]/(public)/about/page.tsx` | 31 | Trust page (via `TrustPage` component) | live |
| `app/[locale]/(public)/editorial-policy/page.tsx` | 31 | Trust page | live |
| `app/[locale]/(public)/medical-review/page.tsx` | 31 | Trust page | live |
| `app/[locale]/(public)/privacy/page.tsx` | 42 | Privacy policy, marked draft, `noindex`, out of sitemap | live |
| `app/[locale]/(public)/terms/page.tsx` | 40 | Terms, draft, `noindex`, out of sitemap | live |
| `app/[locale]/(public)/authors/page.tsx` | 75 | Authors index (ISR 1h), `PageView` | live |
| `app/[locale]/(public)/authors/[slug]/page.tsx` | 144 | Author/reviewer bio, Person + Breadcrumb JSON-LD, `generateStaticParams` | live |
| `app/[locale]/(public)/calculators/layout.tsx` | 17 | Scopes calculator strings to `/calculators/*` | live |
| `app/[locale]/(public)/calculators/page.tsx` | 61 | Calculators hub | live |
| `app/[locale]/(public)/calculators/{bmi,cycle-length,due-date,fertile-window,gestational-age,period,pregnancy-test}/page.tsx` | 38 each (7 files) | One calculator each via `CalculatorLayout` | live |
| `app/[locale]/(public)/conditions/page.tsx` | 38 | Conditions hub (ISR) | live |
| `app/[locale]/(public)/conditions/[slug]/page.tsx` | 73 | Condition page from snapshot | live |
| `app/[locale]/(public)/faq/page.tsx` | 58 | FAQ page; collection is empty (0 rows), hidden from nav/sitemap | live (empty) |
| `app/[locale]/(public)/glossary/page.tsx` | 63 | Glossary page; empty (0 rows), hidden from nav/sitemap | live (empty) |
| `app/[locale]/(public)/learn/page.tsx` | 26 | Learn hub | live |
| `app/[locale]/(public)/learn/[slug]/page.tsx` | 72 | Article page: ISR 1h, prerenders all 100 slugs, noindex on untranslated locales | live |
| `app/[locale]/(public)/search/page.tsx` | 40 | Search page (`noindex`); includes tool results that link to closed app routes | live |
| `app/[locale]/help-now/page.tsx` | 33 | Crisis page, server-rendered, `noindex`, no header/footer | live |
| `app/[locale]/components/page.tsx` | 142 | Design-system gallery. Not in `WEB_APP_SEGMENTS`, no `noindex`, not in sitemap, not linked | unknown (dev tool shipped to prod) |
| `app/[locale]/not-found.tsx` | 40 | Client-component localized 404 (fix for a prod-only 500) | live |
| `app/[locale]/(app)/layout.tsx` | 33 | Tracker shell: second `NextIntlClientProvider` with app namespaces, AppNav, OfflineSync, PageView | app-only |
| `app/[locale]/(app)/{appointments,calendar,dashboard,fertility,medications,mfa,patterns,settings,shared-with-me,sharing,summary,tools,track}/page.tsx` | 22–25 each (13 files) | Thin pages: metadata + `AuthGate` + one client screen; `noindex` | app-only |
| `app/[locale]/(app)/screeners/page.tsx` | 36 | PHQ-9 / GAD-7 screeners | app-only |
| `app/[locale]/(app)/admin/insights/page.tsx` | 112 | Staff-only aggregate product insights (`force-dynamic`, server Supabase) | app-only |
| `app/[locale]/(app)/admin/translations/page.tsx` | 61 | Staff-only translation portal (`force-dynamic`, server Supabase) | app-only |
| `app/[locale]/sign-in/{layout,page}.tsx` | 16 + 24 | Sign-in, auth namespaces | app-only |
| `app/[locale]/welcome/{layout,page}.tsx` | 16 + 22 | Onboarding wizard | app-only |
| `app/[locale]/reset-password/{layout,page}.tsx` | 16 + 23 | Password reset | app-only |
| `app/api/auth/callback/route.ts` | 29 | Supabase magic-link / OAuth code exchange | app-only |
| `app/api/reading/route.ts` (+test) | 56 | Which of a persona's reading-list articles are published (called by the dashboard) | app-only |
| `app/api/search-index/[locale]/route.ts` (+test) | 38 | Static per-locale search index JSON (`force-static`) | live |
| `app/global-error.tsx` | 116 | Last-resort error page; bundled 4-language copy, inline styles | live |
| `app/globals.css` | 334 | Tailwind layers, focus ring, reduced-motion, safe-area, print, aurora/reveal/band-breathe components | live |
| `app/icon.svg` | 22 | Favicon; six-petal bloom, violet-magenta-amber gradient | live (stale brand, see section 8) |
| `app/manifest.ts` | 24 | PWA manifest (one SVG icon, theme `#7C3AED`) | live (stale brand) |
| `app/robots.ts` | 10 | `allow /`, `disallow /api/`, sitemap link | live |
| `app/sitemap.ts` | 93 | 18 static paths x 4 locales + articles/conditions/authors in the locales that really exist | live |
| `app/sw.ts` | 75 | Serwist service worker: precache + default runtime cache + web-push handlers | live (push part app-only) |

### 2.2 Middleware, i18n, instrumentation, hooks (Checked)

| path | lines | purpose | status |
|---|---|---|---|
| `src/middleware.ts` | 31 | Closed mode: closed segments -> 307 to `/{locale}/app`, else next-intl. Open mode: next-intl then Supabase `getUser()` on every request | live |
| `src/i18n/routing.ts` (+test) | 25 | Locales en/ar/fr/es, `localePrefix: always`, `getDir` | live |
| `src/i18n/request.ts` | 41 | Loads `messages/{locale}.json`; for ar/fr/es overlays approved rows from Supabase `ui_strings`; pins Arabic to Western digits | live (contains a Supabase read) |
| `src/i18n/navigation.ts` | 7 | Locale-aware Link/redirect/useRouter | live |
| `src/i18n/client-namespaces.ts` | 178 | Which message namespaces go to the browser, in four scoped lists | live |
| `src/i18n/numbering.test.ts` | 51 | Arabic digit rule | live (test) |
| `src/instrumentation.ts` | 30 | Server Sentry init, only with an EU DSN | live |
| `src/instrumentation-client.ts` | 40 | Browser Sentry init, no tracing, no replay, scrubbed | live |
| `src/hooks/use-crisis-help.ts` | 3 | Re-export of the crisis provider hook | live |

### 2.3 Libraries — `src/lib/**` (Checked: headers and key bodies read)

| path | lines | purpose | status |
|---|---|---|---|
| `lib/web-app.ts` (+test) | 54 | `webAppEnabled()` flag and the list of closed route segments | live |
| `lib/env.ts` | 108 | Zod-validated env; **requires** Supabase URL and key | live (needs surgery) |
| `lib/utils.ts` | 7 | `cn()` | live |
| `lib/supabase/{client,server,middleware}.ts` | 11 / 33 / 39 | Browser, server and middleware Supabase clients | app-only |
| `lib/supabase/use-query.ts` | 131 | Client read hook with 15 s timeout | app-only |
| `lib/auth/{mfa,require-staff,roles}.ts` (+tests for mfa, roles) | 87 / 40 / 38 | Staff guard, roles, MFA | app-only |
| `lib/consent/{actions,purposes}.ts` (+test purposes) | 91 / 80 | Consent ledger (Supabase) and purposes | app-only |
| `lib/account/{export-data,visit-summary}.ts` (+test visit-summary) | 45 / 148 | GDPR export; doctor-visit summary | app-only |
| `lib/partner/{actions,index}.ts` (+test index) | 260 / 215 | Partner sharing; `index.ts` is pure "tier 2" logic a Dart twin must match | app-only |
| `lib/notifications/{actions,index}.ts` (+test index) | 178 / 164 | Push preferences; `index.ts` pure tier-2 rules | app-only |
| `lib/offline/{queue,sync,use-online}.ts` | 69 / 55 / 42 | IndexedDB queue, `saveOrQueue` into Supabase | app-only |
| `lib/beta/gate.ts` (+test) | 65 | Private-beta invite code on `/welcome` | app-only |
| `lib/analytics/consent.ts` | 49 | Reads analytics consent from Supabase | app-only |
| `lib/analytics/{events,guard,host,sanitize,track,transport,use-calculator-used}.ts` (+tests guard, sanitize, track) | 108 / 159 / 27 / 88 / 87 / 106 / 30 | Closed-schema product analytics: configured -> consent -> allow-list; PostHog loaded by dynamic import | live (no-op unless key set) |
| `lib/observability/{dsn,noise,scrub}.ts` (+test scrub) | 45 / 36 / 123 | Sentry EU-only DSN rule, noise filters, event scrubber | live |
| `lib/seo/{config,metadata,jsonld}.ts` (+tests metadata, jsonld, article-jsonld) | 18 / 29 / 178 | Site config, hreflang, JSON-LD builders | live |
| `lib/cms/{client,faq,format,lexical}.ts(x)` (+tests faq, lexical, select) | 206 / 66 / 12 / 109 | Content client over the committed snapshot; Lexical renderer | live |
| `lib/content/{topics,unpublished-sections}.ts` (+tests) | 175 / 30 | Learn hub topics; hides empty sections | live |
| `lib/search/{index,corpus,library}.ts` (+tests index, library) | 140 / 93 / 92 | Client-side ranker, tool corpus (links into closed routes), static library index | live (corpus half app-only) |
| `lib/i18n/ui-strings-loader.ts` | 77 | Supabase `ui_strings` overlay for ar/fr/es | unknown (live but only Supabase read left in public render) |
| `lib/i18n/{ui-strings,csv,translation-actions}.ts` (+tests ui-strings, csv) | 58 / 78 / 85 | Pure flatten/overlay; translation CSV; portal server actions | ui-strings: unknown; csv, actions: app-only |
| `lib/ui/range-band.ts` (+test), `lib/ui/contrast.test.ts` | 82 / 142 / 101 | Range-bar geometry (tracker); contrast test reads token CSS | range-band app-only; contrast test live |

### 2.4 Config, tests, assets (Checked)

| path | lines / bytes | purpose | status |
|---|---|---|---|
| `package.json` | 54 | Deps: next 15.5, next-intl 4, `@supabase/ssr` + `supabase-js`, `@sentry/nextjs`, `posthog-js`, `next-themes`, radix slot, cva, lucide; dev: serwist, playwright, axe, vitest | live |
| `next.config.mjs` | 127 | next-intl + Serwist plugins, CSP and security headers | live |
| `vercel.json` | 7 | Region `dub1`, `ignoreCommand` script | live |
| `tailwind.config.ts` | 68 | Token preset + opacity-modifier wrapper + font families | live |
| `postcss.config.mjs`, `tsconfig.json`, `components.json`, `.eslintrc.json`, `.prettierrc.json` | 6 / 28 / 21 / - / - | Standard | live |
| `vitest.config.ts` | 39 | Node env, `src/**/*.test.ts`, placeholder Supabase env | live |
| `playwright.config.ts` | 30 | One worker, dev or `pnpm start` on :3000 | live |
| `.env.example` | 29 | Env template | live |
| `messages/{en,ar,fr,es}.json` | 118,916 / 155,033 / 135,195 / 126,957 bytes | 67 top-level namespaces each | live |
| `e2e/*.spec.ts` | 20 files, 960 lines + `helpers/onboarding.ts` 59 | Playwright specs (section 7) | mixed |
| `public/art/*.svg` | 10 files, 2,345 bytes each, all different | Gradient-bloom topic art for the Learn hub | live |
| `public/icons/app-icon.svg` | 1,627 bytes | Manifest icon + JSON-LD logo; same drawing as `app/icon.svg` | duplicate |
| `public/sw.js` | (build output, git-ignored) | Compiled service worker | live (generated) |
| `src/content/snapshot/*.json` | 1.7 MB total | Published content committed in the repo (outside my list, read because the content client reads it) | live |

There is **no** `favicon.ico`, no `apple-touch-icon`, no PNG icon, no maskable icon, no OG/Twitter image, no font files in `public/` (**Checked**: `find public -type f` lists only the 10 art SVGs and one icon SVG). Fonts come from `next/font/google`, which downloads and self-hosts them at build time.

## 3. Key modules and responsibilities

1. **`middleware.ts` + `lib/web-app.ts`** — Input: every non-API, non-asset request. Output: closed mode redirects 18 tracker segments (admin, appointments, calendar, dashboard, fertility, medications, mfa, patterns, reset-password, screeners, settings, shared-with-me, sharing, sign-in, summary, tools, track, welcome) to `/{locale}/app` with a 307, otherwise hands off to next-intl; open mode also refreshes the Supabase session (a network call per request). A unit test fails if a new `(app)` folder is not added to the segment list. `/help-now` is deliberately never gated.
2. **`[locale]/layout.tsx`** — Sets `lang`/`dir`, loads Plus Jakarta Sans + Newsreader (Latin) and IBM Plex Sans Arabic + Noto Naskh Arabic (Arabic faces not preloaded), imports `@femio/tokens/tokens.css` and `globals.css`, builds site-wide metadata, wraps everything in the theme and crisis providers, and passes only the public message namespaces to the browser (page-weight discipline). Passes `locale` explicitly because the crisis provider branches on it.
3. **`i18n/request.ts` + `lib/i18n/ui-strings-loader.ts`** — Loads the JSON catalog; for non-English locales overlays human-approved rows from Supabase (`unstable_cache`, 1 h, falls back to JSON on any error). This is the one Supabase read left in the public render path.
4. **`i18n/client-namespaces.ts`** — Four lists (public, calculators, auth, app) decide what is serialised to the browser. About 28 KB of the 97 KB (compact) English catalog is teaser content; about 69 KB belongs to tracker namespaces (my split, **Checked** by script over top-level keys).
5. **`lib/cms/client.ts` + `src/content/snapshot`** — Since D3 step 1 (2026-10-07) every article, condition, FAQ, glossary and author read comes from committed JSON: no network. Same function names as the old Payload client. Content is English only: 100 articles, 5 conditions, 1 author, 0 FAQ, 0 glossary, and 0 in ar/fr/es (**Checked** from the snapshot).
6. **`app/sitemap.ts`, `robots.ts`, `lib/seo/*`** — SEO plumbing, section 4.5.
7. **`app/api/search-index/[locale]/route.ts` + `lib/search/*` + `components/search`** — A static JSON index per locale; the browser ranks locally. Replaces a Supabase RPC per keystroke.
8. **`next.config.mjs`** — Builds the CSP from the same env the app reads (connect-src lists Supabase https+wss, PostHog host and the Sentry ingest origin only if configured), plus HSTS (2 years, no preload), X-Frame-Options DENY, nosniff, strict-origin-when-cross-origin, a restrictive Permissions-Policy. `script-src` keeps `'unsafe-inline'` on purpose (static generation over nonces).
9. **`lib/analytics/*`** — Three gates before any event: PostHog EU key configured, user consented (read from Supabase), payload allow-listed against a closed schema. PostHog is imported dynamically only after consent. With no key (today) it is a no-op. Calculators and home call it.
10. **`instrumentation*.ts` + `lib/observability/*`** — Sentry only with an EU DSN; no tracing, no replay, `sendDefaultPii:false`, scrubber on every event.
11. **`app/sw.ts` + Serwist config** — Precaches build assets, applies Serwist's `defaultCache`, handles push and notification clicks. Registered automatically by `@serwist/next` (default). Disabled in dev.
12. **`lib/env.ts`** — The single env reader. Fails the build on non-EU Sentry/PostHog values or a bad crisis-directory URL, and on missing Supabase URL/key.
13. **`tailwind.config.ts`** — Imports the preset from the workspace package `@femio/tokens` (`assets/brand/tokens`), wraps every `var(...)` colour so `/NN` opacity modifiers work (Tailwind 3 silently emitted no CSS for `bg-bg/85` before), maps font families to the self-hosted variables, dark mode on `[data-theme="dark"]` or `.dark`.
14. **`app/global-error.tsx` and `not-found.tsx`** — Both avoid depending on the machinery that may be broken (bundled copy / client component reading the already-provided messages).

## 4. Data flow

### 4.1 Route tree

**Public (all `noindex` marked where noted; all under `/{en|ar|fr|es}`):** `/`, `/app`, `/about`, `/editorial-policy`, `/medical-review`, `/privacy` (noindex, draft), `/terms` (noindex, draft), `/authors`, `/authors/[slug]`, `/calculators` and 7 calculators (period, pregnancy-test, due-date, fertile-window, gestational-age, bmi, cycle-length), `/conditions`, `/conditions/[slug]`, `/faq`, `/glossary` (both empty), `/learn`, `/learn/[slug]`, `/search` (noindex), `/help-now` (noindex, no site chrome), `/components` (gallery, unguarded). Special files: `not-found`, `global-error`, `sitemap.xml`, `robots.txt`, `manifest.webmanifest`, `icon.svg`, `sw.js`. API: `/api/search-index/{locale}` (static).

**Closed tracker (redirected to `/app` when the flag is off):** `(app)` group of 16 pages: admin/insights, admin/translations, appointments, calendar, dashboard, fertility, medications, mfa, patterns, screeners, settings, shared-with-me, sharing, summary, tools, track; plus `sign-in`, `welcome`, `reset-password` outside the group; API `/api/auth/callback` and `/api/reading`. Every `(app)` page is `noindex`.

Rendering mode (**Checked** from `revalidate`/`dynamic`/`generateStaticParams`): learn, conditions, authors, faq, glossary use ISR (3600 s); `learn/[slug]`, `conditions/[slug]`, `authors/[slug]` prerender every slug; search-index is `force-static` for the four locales; admin pages are `force-dynamic`; everything else is static.

### 4.2 Middleware (Checked)

Matcher excludes `api`, `_next`, `_vercel` and any path with a dot. Production default (flag unset, inlined at build): redirect closed segments, else next-intl locale redirect/cookie. No Supabase call. With the flag on (CI): next-intl then `updateSession` -> `supabase.auth.getUser()` on every matched request including public pages.

### 4.3 Every runtime call to an external service

| service | where | when it actually fires | notes |
|---|---|---|---|
| **Supabase** (server, anon key) | `i18n/request.ts` -> `ui-strings-loader.ts` -> table `ui_strings` | At build and on each ISR revalidation, for ar/fr/es only, cached 1 h per locale via `unstable_cache` | **Fires in production today** even though the web app is closed (**Checked**: nothing gates it). Errors are swallowed and the JSON is used. |
| Supabase (edge) | `middleware.ts` -> `updateSession` | Only if `NEXT_PUBLIC_WEB_APP_ENABLED=1` | Not in prod |
| Supabase (browser) | `signed-in-tabs.tsx` (`getSession`), all tracker screens, `offline/sync.ts`, `analytics/consent.ts`, `consent/actions.ts`, `partner`, `notifications`, `account/export-data.ts` | `SignedInTabs` returns null when flag is off. Analytics: `track()` checks "configured" first, so `consent.ts` is reached only if a PostHog key exists | The public calculators and home still **import** the code path (bundled) but do not call it today |
| Supabase (server actions / route) | `api/auth/callback`, `lib/auth/require-staff`, `lib/i18n/translation-actions`, admin pages | Only when those routes are reachable | App-only |
| **PostHog EU** | `analytics/transport.ts` | Needs key + EU host + user consent; dynamic import; localStorage, no cookies, no autocapture, no pageview URL | Not configured today (**From the docs**: "P1.20.APPLY") |
| **Sentry EU ingest** | `instrumentation*.ts` | Needs an EU DSN | Not configured per `.env.example`; I could not see the deployed env |
| **Google Fonts** | `[locale]/layout.tsx` | Build time only; `next/font` self-hosts | No runtime request to Google |
| **CMS origin** (`NEXT_PUBLIC_CMS_URL`) | `next.config.mjs` img-src only | Not fetched; content comes from the snapshot | `.env.example` still tells developers to set it and says pages render empty without it, which is no longer true |
| findahelpline.com | crisis directory link | Optional outbound link, validated in `env.ts` | Link, not a fetch |
| Vercel | hosting, region `dub1`, `ignoreCommand` script | Platform | No `@vercel/analytics` or speed-insights dependency present |
| same-origin `/api/search-index/{locale}` | `components/search/search-screen.tsx` | First search | Static file on the CDN |

### 4.4 PWA and service worker (Checked, behaviour not run)

Serwist compiles `src/app/sw.ts` to `public/sw.js` (git-ignored) with `skipWaiting`, `clientsClaim`, `navigationPreload`, and `defaultCache` as the runtime cache. It registers automatically in production builds. Offline reading of previously visited pages comes from the default cache (**Hypothesis**: exact strategies are Serwist's defaults; not tested). The push and notification-click handlers are tracker features: they only matter if `NEXT_PUBLIC_VAPID_PUBLIC_KEY` is set and a user subscribes through Settings (app-only), and use `/icon.svg` as icon and badge. Manifest: `start_url: "/"`, `display: standalone`, `name/short_name: Femio`, `description: "One account for a woman's whole health life."`, one SVG icon `sizes:any`, `theme_color #7C3AED`, `background_color #FAFAF9`. `manifest-src 'self'` is in the CSP.

### 4.5 SEO plumbing (Checked)

- **Metadata:** root `generateMetadata` gives title template `%s — Femio`, description, OG, Twitter `summary_large_image` (no image supplied anywhere: `grep` for `images:`/opengraph finds nothing), canonical + hreflang via `localizedAlternates` (all four locales + `x-default`, or only the locales that exist for content), Google verification token from env.
- **Per-page:** each public page sets its own `alternates`; articles add `noindex` when the locale has no real translation (always the case today for ar/fr/es), honour CMS SEO overrides.
- **Sitemap:** 18 static paths x 4 locales, hreflang clusters, articles/conditions listed only in locales that exist (en only today), authors; `/privacy`, `/terms`, `/search`, `/help-now`, and empty `/faq`, `/glossary` excluded. Static pages use `lastModified: now`. ~178 URLs (**Hypothesis**: 72 static + 100 + 5 + 1, computed by hand).
- **robots:** allow all, disallow `/api/`, sitemap + host. Closed routes rely on per-page `noindex` and the redirect, not robots.
- **JSON-LD:** WebSite + Organization (home), WebApplication (each calculator, `offers price 0`), MedicalWebPage + Article + BreadcrumbList + FAQPage (articles), Person + BreadcrumbList (authors), FAQPage, DefinedTermSet. Organization `logo` points to `/icons/app-icon.svg`.
- **Not present:** OG image, favicon.ico, apple-touch-icon.

### 4.6 Tailwind and tokens wiring (Checked)

`assets/brand/tokens` is a pnpm workspace package `@femio/tokens` (`femio.tokens.css` 431 lines, `.json` 680, `.tailwind.preset.js` 140). The root layout imports `@femio/tokens/tokens.css` then `globals.css`; `tailwind.config.ts` uses the preset (with the opacity wrapper) and `content: ./src/**/*.{ts,tsx}`. Current token palette is plum (`--primary: var(--plum-600)`), i.e. "Dusk Bloom", which does not match the web icon and manifest (section 8).

## 5. Dependencies

**This area imports from elsewhere:** `@/components/**` (site header/footer, calculators, crisis, cms, ui, auth, app-nav, dashboard, etc. — the tracker is ~15 component folders), `@/lib/crisis` (content + directory validator, imported by `env.ts` and `help-now`), `@/lib/calculators/*` (range-band), `@/lib/persona/*`, `@/lib/onboarding/*`, `@/lib/experience/*`, `@/lib/insights/*` (from the app-only side), `@femio/tokens`, `src/content/snapshot`. **Imported by:** every page and component in `apps/web`. Supabase importers outside `lib/supabase` are ~45 files, all under `components/{account,appointments,auth,cycle,dashboard,experience,fertility,log,medications,menopause,patterns,postpartum,pregnancy,screeners}`, `offline-sync.tsx`, `signed-in-tabs.tsx`, plus `lib/{account,analytics/consent,auth,consent,experience,i18n/translation-actions,insights,notifications,offline,onboarding,partner,patterns,persona}` (**Checked** by grep for `@/lib/supabase`). Public calculators import only `lib/analytics` (gated). Scripts at repo root enforce this area: `i18n-client-lint` (client-namespaces), `analytics-lint`, `tokens-parity-lint`, `sitemap-check`.

**External packages that become unnecessary for a no-Supabase teaser:** `@supabase/ssr`, `@supabase/supabase-js`, possibly `posthog-js` (if analytics is dropped), `next-themes` stays (theme toggle), `@serwist/next`+`serwist` (if SW is dropped).

## 6. Strings and i18n

- User text is in `messages/{locale}.json` (67 namespaces, identical key set in all four per my namespace count) and read via next-intl; the content itself (articles) is English-only JSON.
- Crisis copy is in `lib/crisis` (outside the catalogs, owner-reviewed per ADR-013/063).
- **Hard-coded user-facing text found:**
  - `app/manifest.ts:9-11` — `name`, `short_name`, `description` literal English; manifest is not localized.
  - `lib/seo/config.ts:6` — `tagline` literal English ("One account for a woman's whole health life.").
  - `app/[locale]/(public)/learn/[slug]/page.tsx:30`, `conditions/[slug]/page.tsx:30`, `authors/[slug]/page.tsx:43` — `title: "Not found"` in metadata of a noindex 404.
  - `app/global-error.tsx:20-41` — four bundled translations plus inline `femio` wordmark at line 73. Intentional (cannot depend on next-intl when the root layout failed) but it is a second copy of text outside the catalog.
  - `components/site/site-header.tsx:38` — literal wordmark `femio` (brand rule: always English; acceptable).
- Catalog sizes: en 118,916 bytes, ar 155,033, fr 135,195, es 126,957. Top-level namespaces in all four: meta, home, theme, gallery, calculators, onboarding, track, states, symptoms, dashboard, visitSummary, admin, signIn, resetPassword, learnHub, learn, conditions, teen, appointments, fertility, mrs, medications, contractions, weight, epds, offer, moodScreeners, postpartum, experience, faq, glossary, nav, footer, about, editorialPolicy, medicalReview, privacy, terms, authors, insights, notFound, mfa, search, settings, appNav, prediction, pregnancy, menopause, pregnancyMovements, pregnancySymptoms, phaseStrip, firstRun, flowStrip, tools, phaseEducation, symptomPatterns, cycleReport, cycleVariability, partnerSharing, partnerShared, patterns, notifications, vitals, modules, calendar, log, getApp.
- **Teaser-relevant namespaces:** meta, home, theme, calculators, learnHub, learn, conditions, faq, glossary, nav, footer, about, editorialPolicy, medicalReview, privacy, terms, authors, notFound, search, getApp (+ appNav and tools only because search and calculators borrow them). **Tracker-only (~44 namespaces):** everything else, plus `gallery` (dev).
- Arabic digits pinned to Western via `ar-u-nu-latn` in `i18n/request.ts` (owner decision R3.5.2).
- hreflang to untranslated content is suppressed, which is correct SEO behaviour but means the Arabic site has Arabic chrome around English articles.

## 7. Tests

**Unit (vitest, `src/**/*.test.ts`; Node environment, no DOM):** `app/api/reading/route.test.ts`, `app/api/search-index/[locale]/route.test.ts`, `i18n/{numbering,routing}.test.ts`, `lib/web-app.test.ts` (includes a filesystem check of the `(app)` folders), `lib/account/visit-summary.test.ts`, `lib/analytics/{guard,sanitize,track}.test.ts`, `lib/auth/{mfa,roles}.test.ts`, `lib/beta/gate.test.ts`, `lib/cms/{faq,lexical,select}.test.ts` (select tests the snapshot client), `lib/consent/purposes.test.ts`, `lib/content/{topics,unpublished-sections}.test.ts`, `lib/i18n/{csv,ui-strings}.test.ts`, `lib/notifications/index.test.ts`, `lib/observability/scrub.test.ts`, `lib/partner/index.test.ts`, `lib/search/{index,library}.test.ts`, `lib/seo/{article-jsonld,jsonld,metadata}.test.ts`, `lib/ui/{contrast,range-band}.test.ts`. 29 test files in my area (counted from the listing; I did not run them).

**E2E (Playwright, Chromium, 1 worker, 20 specs):** public-site specs with no tag: a11y (axe), authors, crisis, home, learn, legal, not-found, page-weight, search, security-headers, sign-in. Tagged `@live` (need a live Supabase and the flag on): admin, consent, mfa, offline, onboarding, summary, symptoms, track, and one sitemap test. `@cms` tags are on three sitemap tests (they assert content in the sitemap). CI sets `NEXT_PUBLIC_WEB_APP_ENABLED=1` and placeholder Supabase env, so CI tests the tracker, not the shipped (closed) configuration; the `home` spec does assert that "Get the app" lands on `/en/app` (**Checked**). The `sitemap.spec` header says CI leaves the CMS URL unset, which is stale now that content is a snapshot.

**Untested (no test file found):** `middleware.ts` redirect behaviour (only the segment helper is tested), `i18n/request.ts`, `ui-strings-loader.ts` (the Supabase overlay path), `sitemap.ts` logic (e2e only), `manifest.ts`, `sw.ts`, `next.config.mjs` CSP builder (e2e `security-headers` covers the header output), `lib/consent/actions.ts`, `lib/offline/*`, `lib/supabase/*`, `lib/partner/actions.ts`, `lib/notifications/actions.ts`, `lib/search/corpus.ts` (indirectly via index test).

## 8. Smells, risks, dead code

1. **The public site still reads Supabase.** `i18n/request.ts:25` -> `lib/i18n/ui-strings-loader.ts:22-40` queries `ui_strings` on every ISR revalidation and build for ar/fr/es. This is the same class of egress that exhausted the free plan on 2026-10-06 (per `lib/cms/client.ts:9-14`). Low volume now (cached 1 h, 3 locales), but it contradicts "zero Supabase" and fails silently into JSON if the project is restricted.
2. **`lib/env.ts:19-20` makes the Supabase URL and key mandatory.** A build without them throws `Invalid environment variables`. `vitest.config.ts:31-35` papers over it with fake values. A Supabase-free teaser must make these optional or delete them first, and also `NEXT_PUBLIC_CMS_URL`, `NEXT_PUBLIC_ENABLE_GOOGLE_AUTH`, `NEXT_PUBLIC_VAPID_PUBLIC_KEY`.
3. **The Supabase client and consent code are bundled into public pages.** `calculators/*` -> `use-calculator-used.ts` -> `track.ts` -> `consent.ts:18` `createClient`. Unreachable without a PostHog key, but dead weight in the JS and a trap if someone sets the key. `PageView` is also rendered on home, authors, faq, glossary.
4. **Search corpus points at closed routes.** `lib/search/corpus.ts:37-69` lists ten tools (`/patterns`, `/fertility`, `/screeners`, `/track`, `/calendar`, `/summary`, `/medications`, `/appointments`, `/settings/sharing`, `/calculators`). Nine land on `/app` through the redirect; `/settings/sharing` is not even a route (the real one is `/sharing`). `components/search/search-screen.tsx` shows them as results.
5. **`/components` gallery ships to production** (`app/[locale]/components/page.tsx`, 142 lines): not noindex, not gated by `WEB_APP_SEGMENTS`, not linked, not in sitemap. Anyone can reach `/en/components`. It uses the `gallery` namespace (1,013 bytes en).
6. **Icon and manifest are on the retired palette.** `app/icon.svg:4-5` gradient `#7C3AED -> #E11D74 -> #F59E0B` and centre `#6D28D9`; `manifest.ts:7` comment says "violet-600" and `theme_color #7C3AED`. The tokens are plum (`--primary: var(--plum-600)`) and CLAUDE.md says the stock violet was retired. A newer "dusk" icon exists at `assets/brand/logo/femio-app-icon-dusk.svg` and `femio-app-icon-dusk-512.png` but the web does not use it (**Checked** file list; I did not open the dusk SVG or render either).
7. **Icon set is minimal and probably not installable on all targets.** One SVG used as favicon (via both the `icon.svg` file convention and `icons:{icon:"/icon.svg"}` in layout.tsx:80, a duplicate declaration), manifest icon, push icon and JSON-LD logo; `public/icons/app-icon.svg` duplicates `app/icon.svg` (identical after whitespace strip). No 192/512 PNG, no maskable, no apple-touch-icon, no favicon.ico. **Hypothesis:** Safari/iOS home screen and some crawlers/older browsers will show a generic icon; Chrome's install criteria historically want PNG 192+512 (not verified against current Chrome).
8. **No OG/Twitter image** while `twitter.card` is `summary_large_image` (`layout.tsx:84`). Shared links will show no picture. Every social share of a calculator or article is imageless.
9. **The site is an installable PWA that says "One account for a woman's whole health life"** (`manifest.ts:11`), with `display: standalone` and a service worker, while the product direction is "send people to the Android app, no accounts". The manifest description and the idea of installing the website compete with the app CTA. **Hypothesis**, owner call.
10. **`sw.ts:44-69` push handlers** serve a feature that needs the tracker (VAPID key + Supabase-stored subscriptions). `sw.ts` and `skipWaiting`+`clientsClaim` means a bad SW deploy takes over every open tab; no unit test.
11. **CI tests the closed configuration only in part:** `ci.yml:24` turns the flag on so e2e exercises `/track`; nothing in CI proves the production (flag off) build makes zero Supabase calls. The `home.spec` covers the CTA redirect only.
12. **Stale docs in code:** `.env.example:21-26` (CMS URL "without it pages render empty") and `sitemap.spec.ts` header (CMS not in CI) describe the pre-snapshot world; `lib/cms/client.ts` options `throwOnFailure` and `CmsUnavailableError` are now no-ops kept for callers (`sitemap.ts:79-85` still passes them).
13. **Misleading file name/location:** `lib/cms/*` is not a CMS client any more; it is a snapshot reader. Payload is retired (D3) but `/api/reading`, sitemap and comments still say "CMS".
14. **`next.config.mjs:77`** `script-src 'unsafe-inline'` is a conscious trade (documented). Acceptable for a static content site; revisit only if inline scripts disappear.
15. **Sitemap `lastModified: now`** for all static pages (`sitemap.ts:60`) makes every page look modified hourly. Minor SEO noise.
16. **Content gap vs wedge:** articles/conditions are English-only (0 Arabic), so `/ar` is Arabic chrome around English or around noindex pages; for the Arabic-first wedge the sitemap currently advertises zero Arabic article URLs.
17. **Tier-2 twin files in the web tree:** `lib/notifications/index.ts`, `lib/partner/index.ts`, `lib/ui/range-band.ts` say a Dart twin reads/mirrors them. Deleting them from web could orphan the golden fixtures; check before removing.
18. **Lines over 300:** `app/[locale]/(public)/page.tsx` 427 lines (single home page with embedded sections); `app/globals.css` 334. Exceeds the 300-line house rule.
19. **Dead-code candidates once the tracker goes:** everything in section 9 marked delete, ~45 files importing Supabase, 44 message namespaces (~69 KB en), the second/third `NextIntlClientProvider` layers (`(app)`, auth), `AUTH_CLIENT_NAMESPACES`, `APP_CLIENT_NAMESPACES`, `PageView area="app"`, `OFFLINE_FLUSHED_EVENT` listeners.

## 9. Keep / rebuild / delete verdict

Judged against: private Android app (Flutter, on-phone records, no accounts) is the product; website is a static teaser (articles, calculators, SEO, `/app`, legal, help-now); no Supabase at runtime; wedge Arabic-first TTC -> pregnancy with PCOS depth, Saudi + Egypt.

**Keep (the teaser):**
- `app/[locale]/(public)/**` all pages and the layout — this is the teaser. Fix `/privacy` and `/terms` text before launch (owner/legal).
- `app/[locale]/layout.tsx` — keep; drop nothing structural. Re-pick fonts only if the Arabic-first brand changes.
- `app/[locale]/help-now`, `not-found.tsx`, `global-error.tsx`, `lib/crisis` — keep; `/help-now` must never be gated.
- `app/sitemap.ts`, `robots.ts`, `lib/seo/*` — keep; add OG image and fix `lastModified`.
- `app/api/search-index/[locale]` + `lib/search/{index,library}.ts` — keep (it is already static and Supabase-free).
- `lib/cms/*` + `src/content/snapshot` — keep; rename to `lib/content-snapshot` later (cosmetic). Remove the no-op `throwOnFailure` options.
- `lib/content/*` — keep.
- `i18n/{routing,navigation,client-namespaces}.ts` — keep; collapse `client-namespaces` to the public + calculators lists.
- `i18n/request.ts` — keep but **simplify to JSON only** (see rebuild).
- `lib/observability/*`, `instrumentation*.ts` — keep if Sentry is wanted on the teaser (EU-only DSN, scrubbed). Optional.
- `lib/analytics/{events,guard,host,sanitize,track,transport,use-calculator-used}.ts` — keep **only if** the owner wants product analytics on the teaser; otherwise delete the whole folder together with `PageView`. Either way `consent.ts` must go (it reads Supabase).
- `lib/web-app.ts` + middleware flag — keep the flag logic until the tracker routes are physically deleted, then delete both (see delete).
- `lib/utils.ts`, `hooks/use-crisis-help.ts`, `components.json`, `postcss.config.mjs`, `tailwind.config.ts`, `tsconfig.json`, `vitest.config.ts`, `playwright.config.ts` (trim), `package.json` (trim), `vercel.json`, `next.config.mjs` (CSP trimmed) — keep.
- `messages/*.json` — keep the ~20 teaser namespaces (about 28 KB en); remove the rest.
- `public/art/*.svg`, `e2e` public specs (a11y, authors, crisis, home, learn, legal, not-found, page-weight, search, security-headers, sitemap) — keep.
- `app/globals.css` — keep (check later that the "aurora/reveal" utilities used only by the tracker can go).
- `assets/brand/tokens` — keep (shared with Flutter via token parity lints).

**Rebuild / change:**
- `lib/env.ts` — remove the Supabase, Google-auth, VAPID and CMS-URL vars; keep APP_URL, Sentry/PostHog/crisis-directory validators; update `.env.example`, `vitest.config.ts`.
- `i18n/request.ts` + `lib/i18n/ui-strings-loader.ts` — replace the Supabase overlay with JSON only (translations reviewed in the repo). Delete `ui-strings-loader.ts`; `ui-strings.ts` and `csv.ts` go if the translation portal goes.
- `lib/search/corpus.ts` — remove the TOOLS list (or point only to `/calculators/*`), which also fixes the `/settings/sharing` dead link.
- `middleware.ts` — reduce to next-intl only (drop `webAppEnabled`, redirect and `updateSession`). Redirect old tracker URLs to `/app` with Vercel `redirects` in `vercel.json` if old links matter (Hypothesis: sign-in and welcome were public).
- `app/icon.svg`, `public/icons/app-icon.svg`, `manifest.ts` — replace with the dusk icon set: PNG 192/512 (plus maskable), `apple-touch-icon` 180, `favicon.ico`, theme colour from tokens; remove the duplicate SVG; fix JSON-LD logo URL.
- Add an OG image (per-locale ideally) and wire `openGraph.images` / `twitter.images`.
- `manifest.ts` — decide: either drop the manifest and the service worker (teaser should not be an installable PWA competing with the app) or keep an offline-reading SW but with a localized, teaser description. Recommended: drop `manifest.ts` and push handlers; the offline value is small next to the risk of a stale SW.
- `app/sw.ts` + Serwist — delete unless offline reading is wanted (owner call).
- `app/[locale]/components/page.tsx` — delete from production (or keep behind `notFound()` unless `NODE_ENV!=='production'`) and drop the `gallery` namespace.
- `app/[locale]/(public)/page.tsx` (427 lines) — split into section components when the home is redesigned for the Arabic-first wedge.
- `lib/seo/config.ts` tagline — localize or remove.

**Delete once the web tracker is removed (all app-only):**
- Routes: `app/[locale]/(app)/**` (16 pages + layout), `sign-in`, `welcome`, `reset-password` (6 files), `app/api/auth/callback`, `app/api/reading`.
- Libs: `lib/supabase/*`, `lib/auth/*`, `lib/consent/*`, `lib/account/*`, `lib/partner/*`, `lib/notifications/*`, `lib/offline/*`, `lib/beta/*`, `lib/analytics/consent.ts`, `lib/i18n/{translation-actions,csv,ui-strings-loader}.ts`, `lib/ui/range-band.ts` (+tests), `lib/web-app.ts` (+test), and the Supabase-importing components (`signed-in-tabs.tsx`, `offline-sync.tsx`, `components/{account,appointments,auth,cycle,dashboard,experience,fertility,log,medications,menopause,patterns,postpartum,pregnancy,screeners,admin}`, `app-nav.tsx`) — those components are outside this area but are what makes `@supabase/*` removable.
- `SignedInTabs` in `(public)/layout.tsx`; `PageView area="app"`; the `(app)` and auth `NextIntlClientProvider` layers; app/auth lists in `client-namespaces.ts`.
- Messages: the ~44 tracker namespaces in all four catalogs (about 69 KB en).
- E2E: all `@live` specs (admin, consent, mfa, offline, onboarding, summary, symptoms, track) plus `sign-in.spec.ts` and `helpers/onboarding.ts`; CI `NEXT_PUBLIC_WEB_APP_ENABLED` and the Supabase secrets.
- Packages: `@supabase/ssr`, `@supabase/supabase-js`; `posthog-js` if analytics is dropped.
- CSP `connect-src` Supabase entries (they are derived from env, so they vanish with the env var).

**Before deleting, check:** the tier-2 files `lib/notifications/index.ts` and `lib/partner/index.ts` (and anything under `lib/persona`, `lib/experience`, `lib/crisis` not in my area) have verified Dart twins and golden fixtures in the mobile app, otherwise archive rather than delete.

**Is the teaser truly Supabase-free after this?** Only if all of the following are done: env vars optional/removed, `ui-strings-loader` removed, `SignedInTabs` removed, `analytics/consent.ts` removed, middleware Supabase branch removed. Until then, production still makes one Supabase read per non-English locale per hour (item 8.1) and still bundles `supabase-js`.

## 10. Open questions

1. Does the owner want product analytics (PostHog) on the teaser at all? It is unconfigured today; deleting `lib/analytics` removes ~650 lines of source and the consent-read dependency. If kept, consent needs a non-Supabase home (browser banner) because there are no accounts.
2. Keep Sentry on the teaser? DSN presence in Vercel env is not visible to me (not verified).
3. Is anything in the live Supabase `ui_strings` table (human-reviewed ar/fr/es overrides) newer than the repo JSON? If yes, export it into the JSON before cutting the overlay. I did not query the database.
4. Should the website remain an installable PWA (manifest + service worker) or only link to the app? My lean: drop it (items 8.7, 8.9).
5. Arabic content: 0 Arabic articles exist; for an Arabic-first wedge, does the teaser launch with English articles under Arabic chrome, or wait for Arabic translations? This changes what the sitemap advertises.
6. `/privacy` and `/terms` are draft and noindex; Egypt PDPL licensing is a launch condition per CLAUDE.md. With no accounts and no server, what must the teaser's policy cover (cookies/analytics only)?
7. Should old tracker URLs (`/sign-in`, `/welcome`, `/track`, ...) keep redirecting to `/app` after deletion (cheap, in `vercel.json`), or 404?
8. Are `lib/notifications/index.ts`, `lib/partner/index.ts`, `lib/ui/range-band.ts` mirrored in `apps/mobile` with shared golden fixtures (`lib/golden-fixtures.test.ts` exists at `src/lib/`)? That decides delete versus archive.
9. Which icon is the final brand mark: the violet bloom currently on the web, or `femio-app-icon-dusk`? I did not render either.
10. Could the teaser be a pure static export (`output: 'export'`)? **Hypothesis:** blocked mainly by next-intl middleware locale redirect (`/` -> `/en`) and ISR; Vercel redirects plus `generateStaticParams` could cover it, but I did not test. Staying on Next on Vercel is the zero-risk path and costs nothing at this traffic.
