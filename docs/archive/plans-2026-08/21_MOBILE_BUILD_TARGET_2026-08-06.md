# P4.0 Step 2 — the build-target decision (2026-08-06)

Follows `docs/20_MOBILE_PATH_SPIKE_2026-08-06.md`, which established that
`output: "export"` works for the app half. This decides the **shape** that ships it,
and what Phase 2 must obey so the shape stays reachable.

---

## 1. Evidence: the seam already exists

A transitive import trace from each route group (following `@/` aliases through the
whole reachable graph, not just direct imports) over `src/lib` and `src/components`:

| | Modules |
|---|---|
| **App-only (16)** | `components/{account,admin,app-nav,auth,cycle,menopause,offline-sync,pregnancy}`, `lib/{account,auth,cycle,i18n,insights,menopause,offline,pregnancy}` |
| **Public-only (7)** | `components/{calculators,cms,seo,site,theme-toggle}`, `lib/{cms,seo}` |
| **Shared (10)** | `components/{analytics,ui}`, `lib/{analytics,calculators,consent,crisis,env,observability,supabase,utils}` |

75 files reachable from the app routes, 66 from the public routes, and the overlap is
**ten leaf modules totalling roughly 2,300 lines** — plus `src/i18n/*` (5 files), the
four `messages/*.json` catalogs, and one hook.

This matters more than any argument: **the split is not a refactor, it is a move.**
The tracker and the content site were built without entangling, and the shared set is
exactly the infrastructure you would expect to share — UI primitives, the Supabase
clients, consent, crisis, analytics, env.

## 2. The decision

**Target shape: two thin Next apps over shared workspace packages.**

- `packages/core` — the 10 shared modules, `src/i18n`, `messages/`. (`packages/` exists
  in `pnpm-workspace.yaml` and is currently empty, so there is nowhere to share from
  today; creating it is the first move.)
- `packages/tracker` — the tracker **screens** as components. Route files in each app
  become one-line re-exports. This is the part that stops the split from duplicating
  product code, which is the failure mode a naive two-app split walks into.
- `apps/web` — public content site, server-rendered, SEO unchanged. Mounts the tracker.
- `apps/native` — `output: "export"`, mounts the tracker only.

**Why not one app with a build-time route prune** (what the Step 1 spike did by hand):
it works, but every new route silently needs classifying, the pruning is invisible
during normal development, and a misclassification ships a broken bundle discovered on
a device. That is a permanent tax to avoid a one-time move.

**Why the one-app path is worse than it looks:** making it work requires
`learn/[slug]` and `conditions/[slug]` to become build-time static, so **publishing an
article in the CMS would stop changing the site without a rebuild.** That trades away
CMS-driven publishing to serve a device build that does not want those routes at all.

**Webview-onto-live-URL is rejected**, not deferred. The export works; there is no
reason to accept no-offline plus Apple 4.2 risk.

## 3. What is NOT being done now, and why that is the point

**The split is not executed yet.** Executing it today would be a large mechanical change
across the whole tree, for a Phase 4 deliverable, at a moment when there are no users
and no store presence — and the owner is right that a store presence buys nothing today.

What must happen now is only this: **Phase 2 code must not make the split more
expensive.** Once the tracker screens are client-rendered and server-free, moving them
into a package is mechanical. If Phase 2 adds twenty more server components first, it
is not.

So Step 2's real deliverable is a constraint, made enforceable.

## 4. The rule Phase 2 follows, and the guard that enforces it

**Rule:** code in the tracker path is client-rendered and reads data through the
browser Supabase client. No server-side reads, no `force-dynamic`, no Server Actions,
no `searchParams` page props, and no reliance on middleware for auth or locale.

`pnpm native-readiness-lint` (`scripts/native-readiness-lint.mjs`, wired into CI)
enforces it. It was written as a **ratchet** because at the time the tracker violated
all four rules — 13 violations across 6 files — recorded in
`scripts/native-readiness-baseline.json`. The guard fails on a **new** violation
(Phase 2 drift) and equally on a **stale** baseline entry (a file that no longer
violates but is still listed), so the list can only shrink and can never over-claim.

Watched failing before being trusted, in all three states: passing at baseline, failing
on an injected violation, failing on a stale entry. It also immediately earned its keep
by catching an error in `docs/20` — see §3 there.

**Superseded by §6:** P4.0.3 cleared all 13, so the baseline is empty and the guard is
now a plain gate. The ratchet machinery stays for future deliberate exceptions.

The middleware finding from Step 1 is why this exists at all: the native build fails
*quietly*, so nothing else would have told us.

## 5. Open, deliberately

**Supabase auth against a `capacitor://` origin** is the next real unknown, and Step 1
sharpened it: `createBrowserClient` is cookie-based and the middleware session refresh
is gone on device. Not scoped here. It is the first thing P4.1 must answer, and it does
not block Phase 2.

**The `ui_strings` overlay is a non-problem.** It is a staff translation portal; on
device, ship the JSON catalogs and let translations ride a normal app release. Recorded
so it does not get designed.

---

## 6. Steps 3 and 4 — executed and verified (2026-08-06)

**Step 3 is done: the tracker path is server-free.** All 13 baselined violations
cleared across 6 files. `pnpm native-readiness-lint` now reports
*"the tracker path is server-free"* and, with an empty baseline, has become a plain
gate rather than a ratchet.

The pattern each screen follows:

- `page.tsx` stays a **server** component but does only `generateMetadata` +
  `setRequestLocale`. Metadata resolves at build time and exports fine, so keeping it
  server-side costs nothing and preserves titles and `robots` directives.
- The screen itself is a client component reading through `useSupabaseQuery` /
  `unwrap` (`src/lib/supabase/use-query.ts`).
- `AuthGate` replaces the server `redirect()`. It renders nothing while checking,
  because flashing an app shell at a signed-out visitor is a privacy tell. **RLS
  remains the security boundary**; the gate only decides what to show.

**A side effect worth having on the web, not just on device:** all six tracker routes
now prerender as static HTML instead of rendering per request.

**Accepted cost:** the `dashboard` and `menopause` namespaces now ship in the client
i18n payload. These are `robots: noindex` pages that never carried SEO weight, so the
P1.11.2 argument for keeping them server-side does not apply here.

### Step 4 — it runs, not just builds

The Step 1 write-up deliberately refused to claim runtime. It can now. The export was
rebuilt from the **real converted code** (no stubs; only the routes excluded by build
target were removed), served as **plain files with no Next runtime**, and driven with
Playwright:

| Check | Result |
|---|---|
| Dashboard bundle boots; `AuthGate` withholds content when signed out | pass |
| Arabic export is RTL (`dir=rtl lang=ar`) | pass |
| Sign-in form renders from the static bundle | pass |
| `?error=1` read client-side with no server to parse it | pass |
| `AuthGate` redirects a signed-out visitor to `/en/welcome` | pass |
| The redirect target resolves as a static file | **failed, then fixed** |

**The one real finding, and it would have cost a session in P4.1.** A default static
export emits `welcome.html`, so the client router's push to `/en/welcome` **404s** when
served from the filesystem — exactly what a Capacitor WebView does. `trailingSlash: true`
makes Next emit `welcome/index.html` instead; rebuilt with it, all six checks pass.

This must be **native-build-only**. Turning it on for the web would change every public
URL, which is an SEO change, not a build detail.

### Two smoke-test failures that were the test's fault

Recorded because both are the "a test that tells you what you expected" shape:

1. The first content check used Playwright's `textContent("body")`, which **includes
   `<script>` contents** — so it matched the serialized i18n catalog and reported the
   dashboard as leaking to signed-out visitors. `innerText` reflects what is rendered.
2. A check asserted the bundle makes a Supabase network call. It never could: with no
   stored session, `supabase-js` resolves `getUser()` locally and never hits the
   network. The assertion was wrong, not the app.

Neither was a product defect, and in both cases the failing check was investigated
rather than relaxed.
