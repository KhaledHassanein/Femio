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

The `.report.html` files are the full reports.
