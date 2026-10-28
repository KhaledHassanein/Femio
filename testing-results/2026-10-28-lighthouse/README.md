# Lighthouse, mobile, live site — 2026-10-28 (deployment a2040fd)

Lighthouse 13.6.0 via `npx lighthouse --form-factor=mobile`, headless Chrome, from Cairo.
Numbers are from **real use** (the deployed site), one run each; mobile throttling makes
single runs vary by a few points.

| Page | Perf | A11y | Best practices | SEO | LCP | TBT | Speed Index |
|---|---|---|---|---|---|---|---|
| /ar | 93 | 100 | 96 | 100 | 1.46 s | 230 ms | 4.7 s |
| /ar/calculators/fertile-window | 87 | 98 | 96 | 91 | 1.00 s | 530 ms | 1.9 s |
| /ar/learn/pcos-and-fertility | 89 | 100 | 96 | 100 | 1.51 s | 320 ms | 4.7 s |
| /en | 94 | 100 | 100 | 100 | 1.05 s | 230 ms | 4.7 s |

What the low audits said, and what was done the same day:
- **heading-order** on the calculator: the month title was an `h3` straight after the `h1` → now `h2`.
- **meta-description** scored 0 on the calculator although the HTML carries one; not reproduced
  by hand (`curl` shows the tag). Re-check on the next run.
- **Speed Index 4.7 s** on pages with the aurora hero: the drifting gradient keeps the page
  "changing" for the whole trace. The drift is now slower and smaller, and off under
  `prefers-reduced-motion`. Re-measure after deploy.
- **TBT 530 ms** on the calculator: hydration of the calendar + calculator client bundle
  (chunk 276, ~450 ms of script on a throttled CPU). Open: trim the client bundle (one
  calculator per route, fewer months pre-rendered).
- Article pages had no `og:image` and a Twitter card that fell back to the site title
  (Next replaces the layout's `openGraph`/`twitter` objects). Fixed with `socialMetadata()`.

## Run 2 — after the fixes (deployment 791d809, same method)

| Page | Perf | A11y | Best practices | SEO | LCP | TBT | Speed Index |
|---|---|---|---|---|---|---|---|
| /ar | 93 | 100 | 96 | 100 | 1.13 s | 261 ms | 4.2 s |
| /ar/calculators/fertile-window | 98 | 100 | 96 | 91 | 1.16 s | 144 ms | 1.8 s |
| /ar/learn/pcos-and-fertility | 91 | 100 | 96 | 100 | 1.48 s | 269 ms | 4.7 s |
| /en | 94 | 100 | 100 | 100 | 1.04 s | 284 ms | 2.2 s |

What run 2 showed:
- The calculator went from 87 to 98 and its heading-order audit is clean.
- **Arabic pages keep a Speed Index of 4.2–4.7 s while the same page in English is 2.2 s**: the
  Arabic UI font was not preloaded, so the body text swapped late. Fixed next: preload
  IBM Plex Sans Arabic (two weights).
- **The calculator pages were not prerendered at all** (the only routes with no  in the
  build): the calculators layout read the locale from the request, which makes Next render
  per request and stream the description tag into the body (the SEO 91). Fixed next:
  `setRequestLocale` from `params` in that layout.

## Run 3 — after the prerender and font fixes (deployment 413bfc3, same method)

| Page | Perf | A11y | Best practices | SEO | LCP | TBT | Speed Index |
|---|---|---|---|---|---|---|---|
| /ar | 93 | 100 | 96 | 100 | 1.2 s | 250 ms | 4.4 s |
| /ar/calculators/fertile-window | 97 | 100 | 96 | 100 | 1.4 s | 150 ms | 3.3 s |
| /ar/learn/pcos-and-fertility | 100 | 100 | 96 | 100 | 1.2 s | 70 ms | 2.0 s |
| /en | 96 | 100 | 100 | 100 | 1.0 s | 220 ms | 2.3 s |

What run 3 showed:
- The calculator's SEO is 100: the description tag is in the head because the page is prerendered.
- The Arabic article went from 91 to 100 and its Speed Index from 4.7 s to 2.0 s: the font preload did it.
- The Arabic home stays at 93 with a Speed Index of 4.4 s. The remaining cost is the hero itself
  (the drifting gradient keeps the trace "changing"); the English home has the same hero at 2.3 s,
  so the difference is still Arabic text metrics on first paint. Open, low priority.
- Best practices 96 on Arabic pages is one console error from a third-party font request; not reproduced
  in a browser by hand. Open.

The `.report.html` files are the full reports for run 1; `run3/*.json` are the raw results of run 3.
