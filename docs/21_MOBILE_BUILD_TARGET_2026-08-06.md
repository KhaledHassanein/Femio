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
enforces it as a **ratchet, not a gate**: the tracker violates all four rules today —
13 violations across 6 files — and that is recorded in
`scripts/native-readiness-baseline.json`. The guard fails on a **new** violation
(Phase 2 drift) and equally on a **stale** baseline entry (a file that no longer
violates but is still listed), so the list can only shrink and can never over-claim.

Watched failing before being trusted, in all three states: passing at baseline, failing
on an injected violation, failing on a stale entry. It also immediately earned its keep
by catching an error in `docs/20` — see §3 there.

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
