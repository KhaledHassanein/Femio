# SEO and Google tooling launch audit, femioapp.com (2026-11-25)

Method: the live site (548 URLs from the live sitemap, each fetched and parsed by script, 100% HTTP 200) plus the code in `apps/web`. Numbers below are **from the deployed site** unless marked "code". Lighthouse was **not run** (not installed locally): Core Web Vitals are **not verified**.

## What passed (live)

- `robots.txt`: allow all, disallow `/api/`, sitemap and host lines present.
- `sitemap.xml`: 548 URLs, four locales, with hreflang alternates. All 548 return 200, canonical equals the URL, `<html lang>` equals the locale.
- Canonical and hreflang (en, ar, fr, es, x-default) present on every page type: home, learn, conditions, calculators, authors, legal, app.
- JSON-LD parses on every page (0 syntax errors). Home: WebSite and Organization. Articles: MedicalWebPage, Article (reviewedBy, datePublished, dateModified), BreadcrumbList, FAQPage when the article has FAQs. Calculators: WebApplication and FAQPage. Authors: Person and BreadcrumbList.
- Open Graph image (1200x630, per locale, about 355 KB), `twitter:card=summary_large_image`, favicon (ico, svg, png sizes), apple-touch-icon and manifest (192/512/maskable) all present and served 200.
- `ads.txt` and `app-ads.txt` both exist and say "no advertising configured" / "no app advertising configured": nothing implies app ads (ADR-080). Nothing stale found.
- Root `/` redirects to `/en`; `http` and `www` redirect to `https://femioapp.com`.
- "Get the app" path: the Play link is not live and degrades to the `/app` page and a "Coming soon" badge. No dead link.

## Found and fixed in this pass (code only; not committed, not deployed)

1. **88 pages shared the home page's social card.** Every page that set a title and description without its own Open Graph block (about, editorial policy, medical review, privacy, terms, consumer health data, learn index, conditions index, authors, author pages, calculators index, 10 calculators, app) inherited `og:title="femio"`, `og:url=/{locale}` and the home `og:description`. A shared link to `/en/privacy` previewed as the home page. Fix: new `pageMetadata()` in `apps/web/src/lib/seo/metadata.ts`; all those pages and `components/site/legal-page.tsx` now use it.
2. **55 titles over 60 characters and 44 descriptions over 160** (the 60-character template suffix `— femio` pushed article titles over). Fix: `fitTitle()` drops the suffix only when the suffixed title would pass 60; `fitDescription()` cuts at the last whole sentence. Applied to `learn/[slug]`, `conditions/[slug]`, the home layout and every page above.
3. **Home title was just "femio" in all four locales** (no search keywords), and the home description was 167/194/168 characters in en/fr/es. New titles and shorter descriptions in `apps/web/messages/{en,ar,fr,es}.json` (`meta.title`, `meta.description`). **Owner to approve the wording.**
4. **Sitemap listed 26 `noindex` URLs** (5 condition hubs x 4 locales, 6 English teen guides). Search Console would report "Submitted URL marked noindex". Fix in `apps/web/src/app/sitemap.ts`: skip any document whose `seo.noIndex` is set in that locale, and drop it from the hreflang cluster.
5. **Sitemap `lastmod` was "now" for every static page and the same build time for others**, which teaches Google to ignore `lastmod`. Static pages now omit it; content pages keep their real `updatedAt`.
6. **Sitemap alternates had no `x-default`**, while the pages do. Added, matching `localizedAlternates`.
7. **Bing verification** had no path in code. Added optional `NEXT_PUBLIC_BING_SITE_VERIFICATION` (emits `msvalidate.01`) in `apps/web/src/lib/env.ts` and `apps/web/src/app/[locale]/layout.tsx`. Google's existing `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` is unchanged.
8. **Play switch was one place for one button only.** `apps/web/src/lib/site.ts` `PLAY_STORE_URL` fed only the hand-off card; the `/app` badge and the home hero line were hard-coded "Coming soon". Both now read `PLAY_STORE_URL` too, with new keys `getApp.androidLive` and `getApp.bodyLive` in four locales.

Tests added: `apps/web/src/lib/seo/metadata.test.ts` (fitDescription, fitTitle, pageMetadata), `apps/web/src/app/sitemap.test.ts` (no noindex URLs, x-default everywhere, no invented lastmod).

## To switch on when the Play listing is public (one edit)

Set `PLAY_STORE_URL` in `apps/web/src/lib/site.ts` to `https://play.google.com/store/apps/details?id=com.femioapp.femio`. The hand-off card, the `/app` badge and the home hero line follow. Then: check the sentence "Coming to Google Play" is gone from the Android badge copy (`getApp.bodyLive` is used automatically), and add the Play URL to the Organization `sameAs` (see below).

## Left to do, ranked by impact

1. **Owner: verify Search Console and submit the sitemap.** No verification tag is live (no `google-site-verification` on any page). Either set `NEXT_PUBLIC_GOOGLE_SITE_VERIFICATION` in Vercel, or verify the domain by DNS TXT (preferred: covers all subdomains and survives code changes). Then submit `https://femioapp.com/sitemap.xml`. Bing: import from Search Console (no code needed) or set the new Bing variable.
2. **Owner decision: the 5 condition hubs are `noindex` in all four locales, and their titles and descriptions duplicate the learn article of the same slug.** They are CLAUDE.md's "5 condition hubs". As built, Google will never index them. Either index them with their own titles (a content task) or leave them as navigation pages; I did not change the flag.
3. **Owner decision: six English teen guides are `noindex` while their ar/fr/es versions are indexable and `status: published` in the Markdown.** The English flag comes from the old CMS snapshot overriding the Markdown (`scripts/content/build-content.mjs`, `fromSnapshot`). Probably stale; if intended, apply it to all four locales.
4. **Article JSON-LD has `reviewedBy` but no `author`.** A unit test says authorship is omitted when none is recorded, so this is deliberate until Khaled names the author in front matter (`written_by`). Also missing: `image` (recommended, not required) and Organization `sameAs` (add the Play listing and any social profile when they exist). Not changed because they are claims about people and profiles.
5. **Page weight (not verified).** The English page preloads four font files, apparently including both IBM Plex Sans Arabic weights; the layout comment still says "Arabic is the first language", which conflicts with the no-"Arabic-first" rule (wording in a code comment only). Run Lighthouse on `/en`, `/ar`, one article and one calculator after deploy. OG images are about 355 KB; many chat apps prefer under 300 KB.
6. **Descriptions under 70 characters**: the Arabic terms page, the Arabic calculators index and the four author pages (e.g. "Medical Doctor - Co Founder"). Cosmetic.
7. **`/` redirects with 307** to `/en`. Fine for now; a 308 or a locale-aware landing is optional.
8. The ar/fr/es home titles and the `androidLive` strings are my translations; run them past the translation review before deploy.

## Gate

- `npx vitest run --maxWorkers=2` in apps/web: 40 files, 759 tests passed. `tsc --noEmit` and `next lint`: clean.
- `pnpm gate`: **fails at `mobile-untranslated-lint`**, not in web: `ar/fr/es: leavePlayHeading is still English: "Google Play"` in `apps/mobile/lib/l10n/app_*.arb`. That key comes from another session's uncommitted work in apps/mobile (not touched here); fix is to add `leavePlayHeading` to ALLOWED in `scripts/mobile/arb-untranslated-lint.mjs` (a cognate) or translate it. Every stage before it passed, and the five stages after it (native-readiness, chart-literals, dead-modules, content-build, app-strings), run by hand, all pass.
