# P4.0 Step 1 — mobile-path build spike (2026-08-06)

Timeboxed spike on branch `spike/static-export`, **not merged**. Question: can
`apps/web` produce the static bundle Capacitor needs, and what does it cost?

**Answer: yes, for the app half.** `FEMIO_NATIVE=1 next build` with `output: "export"`
produced a real `out/` — 41 HTML pages across all four locales, `dir="rtl"` and
`lang="ar"` intact on the Arabic pages, the Supabase URL inlined into the client
chunks, and no Next server runtime anywhere in the artifact.

That result is a **build** claim, not a runtime claim. See "What is still unproven".

---

## 1. What had to be removed to get there

This list *is* the conversion cost estimate. Each item is either genuinely absent
from a device build, or a contained code change.

| # | Blocker | Verdict | Cost |
|---|---|---|---|
| 1 | `src/app/manifest.ts`, `robots.ts`, `sitemap.ts` | Web-only. A device build has no sitemap or robots. | None — excluded by build target |
| 2 | `src/app/api/auth/callback/route.ts` | Route handler; hard-blocks export | Real work — becomes deep-link handling (see §4) |
| 3 | `dynamicParams: true` on `learn/[slug]`, `conditions/[slug]`, `authors/[slug]` | The content site. Should not be in a device bundle. | None — excluded by build target |
| 4 | Server Action in `src/lib/i18n/translation-actions.ts` (`/admin/translations`) | Staff-only tool | None — excluded by build target |
| 5 | `force-dynamic` + server Supabase reads on `/dashboard`, `/track`, `/settings`, `/summary`, `/mfa` | The known conversion | **The actual Step 3 work** |
| 6 | `await searchParams` in `/sign-in`, `/mfa`, `/settings` | Not previously identified | Small — `useSearchParams` + a `Suspense` boundary, ×3 |
| 7 | `dashboard` namespace absent from `CLIENT_NAMESPACES` | Follows from #5 | One line, and `i18n-client-lint` enforces it |

Item 5 was stubbed with client-rendered placeholders, two of them realistic —
`/dashboard` does a browser-client Supabase read through
`predictNextPeriod`, `/track` keeps the real `LogSymptoms` child. Both exported and
rendered. **The client-fetch pattern works under static export.** That is the single
most useful thing the spike establishes.

## 2. The finding that would have bitten us later

**Middleware does not fail the export. It is silently disabled with a warning:**

```
⚠ Statically exporting a Next.js application via `next export` disables API routes and middleware.
✓ Exporting (2/2)
```

The build goes green and emits `out/`. But `src/middleware.ts` is doing two jobs, and
both vanish on device:

- **next-intl locale routing.** Confirmed downstream: the export has no root
  `index.html`. Opening the bundle root on a device dead-ends. Needs a client-side
  locale bootstrap or a Capacitor start-path.
- **Supabase `updateSession` cookie refresh.** This is the auth one, and it is why
  §4 matters.

A green build that has quietly dropped session refresh is exactly the "test that tells
you what you expected" failure mode. Worth a guard if we take this path.

## 3. Prediction scoring

Predictions were written before the first build (verification honesty). Score: **4 of 6
right, 2 misses, and the two misses were the interesting ones.**

- Right: middleware, the route handler, `force-dynamic`, dynamic content routes.
- Right but under-rated: the next-intl request config — see §4; it never blocked the
  build.
- **Miss:** metadata routes (`manifest.webmanifest`, `robots.txt`) were the *first*
  failure and I had filed them as "watch for", not blockers.
- **Miss:** `await searchParams` in `/sign-in`. I had scanned for `force-dynamic` and
  not for dynamic APIs generally.
  - **Corrected 2026-08-06 (P4.0.2):** this write-up originally said "one file, and
    the fix is contained". Wrong — it is **three** (`/sign-in`, `/mfa`, `/settings`).
    The grep I based that on was run *after* I had already stubbed `/mfa` and
    `/settings`, so it searched the stubs and found nothing. The Step 2 guard found
    the other two. A search over a tree you have already modified is not evidence
    about the tree you started with.
- Also missed pre-build, caught on reading the config: `async headers()` — the entire
  CSP is delivered that way and has no equivalent on device.

## 4. What is still unproven — Step 2 follow-ons

1. **Auth against a `capacitor://` origin.** The next unknown after build shape, and
   the middleware finding makes it sharper: `@supabase/ssr`'s `createBrowserClient` is
   cookie-based and the server-side refresh is gone. Named, not scoped.
2. **Runtime.** `out/` was verified as an artifact, not exercised in a browser with a
   real session. That is Step 4.
3. **The `ui_strings` overlay is a non-problem** and should not become a design
   project. It is a staff translation portal; on device, ship the JSON catalogs and let
   translations flow through a normal app release.

## 5. Recommendation into Step 2

Items 1, 3 and 4 above are all "not in a device build" — which is the same statement
four times, and it points at the **second-app / separate build target** shape on merit,
not as a fallback from a failed export.

The corroborating argument is stronger than the spike itself: making the one-app path
work requires `learn/[slug]` and `conditions/[slug]` to become build-time static, so
**publishing an article in the CMS would no longer change the site without a rebuild.**
That trades away CMS-driven publishing to serve a device build that does not want those
routes anyway. Step 2 should evaluate the split on that basis.

Webview-onto-live-URL was not reached as a conclusion and should not be adopted by
default — the export works.
