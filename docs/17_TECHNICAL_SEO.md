# Femio V2 — Technical SEO (P1.11)
Prepared: 2026-07-23 · Status: living · Owners: SEO + Engineering
Basis: `femio-seo-aso`, `16_CONDITION_LIBRARY_IA.md`, `15_EDITORIAL_MEDICAL_REVIEW_POLICY.md`. Implementation in `apps/web/src/lib/seo/`, the locale layout, `sitemap.ts`, and `robots.ts`.

Femio's growth is organic search in a YMYL category, so the technical foundation must be correct before content scales. This documents what's implemented and what's left (some steps are Khaled's — Search Console, domain).

## 1. What's implemented (P1.11)
- **metadataBase + canonical.** Every page has a **self-referencing canonical** for its locale (`/{locale}{path}`), resolved against `NEXT_PUBLIC_APP_URL`.
- **hreflang cluster.** Every page emits `<link rel="alternate" hreflang>` for `en/ar/fr/es` **+ `x-default`** → the default locale (`femio-seo-aso` multilingual). Rendered by Next from `alternates.languages` (as `hrefLang`, which crawlers read case-insensitively).
- **Title + meta.** Title template `%s — Femio`; benefit-led per-page titles; localized descriptions; `applicationName`.
- **OpenGraph + Twitter.** `og:type/site_name/title/description/url/locale` (locale-mapped) and `summary_large_image` cards.
- **Schema.org (JSON-LD).** `WebSite` + `Organization` on the home page; `WebApplication` (HealthApplication, free) on each calculator. Builders for `BreadcrumbList` ready. `MedicalWebPage` + `FAQPage` land with content pages (P1.9).
- **Sitemap.** `/sitemap.xml` lists every static route in **all four locales**, each with `alternates.languages` (hreflang in the sitemap). Extends from the CMS when content ships.
- **robots.** `/robots.txt` allows all, disallows `/api/`, points to the sitemap, sets host.
- **Search Console hook.** `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` (env) renders the Google verification meta when set.

## 2. URL & i18n
Locale-prefixed subdirectories on one domain (`/en /ar /fr /es`), per `16_CONDITION_LIBRARY_IA.md` §5. Localized slugs (translated, not transliterated) for content pages; AR renders RTL. hreflang keeps the locale cluster consolidated.

## 3. Core Web Vitals budget
Targets (`femio-seo-aso`): **LCP < 2.0s · CLS < 0.05 · INP < 200ms**. Current posture: self-hosted fonts via `next/font` with `display: swap`; static generation (SSG) of public pages; token-based CSS (no runtime CSS-in-JS); minimal client JS (calculators are the only interactive islands). Still to enforce: `next/image` (AVIF/WebP, dimensioned) once imagery lands, and a **Lighthouse/CWV budget check in CI** (tracked with the a11y/axe work, P1.5.2 / P1.22).

## 4. Schema coverage plan (with content, P1.9)
| Page type | Schema |
|---|---|
| Home | WebSite + Organization ✅ |
| Calculator | WebApplication ✅ + BreadcrumbList |
| Condition (pillar) | MedicalWebPage + BreadcrumbList |
| Article (cluster) | Article (author + reviewer `Person`) + MedicalWebPage |
| FAQ | FAQPage (real Q&A only) |
| Glossary | DefinedTerm |
Author/reviewer **bio pages** carry `Person` schema with credentials (E-E-A-T, doc 15 §8).

## 5. Open items → next
- **P1.11.GSC (Khaled):** verify the domain in **Google Search Console** (set `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` in Vercel, or use DNS), then **submit `/sitemap.xml`**. Repeat for a custom domain when chosen.
- **Custom domain (Khaled):** point a production domain at Vercel; update `NEXT_PUBLIC_APP_URL` so canonical/sitemap/OG use it (currently `femio-web.vercel.app`).
- Content-page schema (MedicalWebPage/FAQPage/Article/DefinedTerm) + dynamic sitemap from the CMS — with **P1.9**.
- CWV/Lighthouse budget + axe checks in CI — with **P1.5.2 / P1.22**.
- Per-locale keyword research (Semrush/Ahrefs) feeding titles/slugs — with **P1.9**.
