/**
 * Which message namespaces are sent to the browser (P1.11.2), and **where**.
 *
 * `NextIntlClientProvider` with no `messages` prop hands the **entire** catalog to the
 * client, and next-intl serialises it into every page's HTML. That was ~32 KB of English
 * on every page and ~51 KB of Arabic — over half the weight of `/en/learn` — including the
 * privacy policy, the terms, the MFA copy and the insights dashboard on a page that renders
 * none of them. Core Web Vitals is a ranking signal, so on a site whose whole point is
 * organic search that is not a rounding error.
 *
 * Only **client** components need messages in the browser: anything rendered on the server
 * with `getTranslations` has already become text by the time the HTML is sent.
 *
 * ## Two lists, because one list was quietly undoing the saving
 *
 * Converting the tracker to client rendering (P4.0, ADR-048) moved several namespaces into
 * the client payload — `dashboard`, `menopause`, then `experience` and `pregnancyMovements`.
 * They are needed, but only inside the signed-in app, and shipping them from the root layout
 * put them on `/learn` too. The page-weight e2e budget caught it: `/en/learn` went 39 → 51 KB
 * and `/ar/learn` 45 → 58 KB, both over budget, on the pages the entire SEO strategy rests on.
 * Raising the budget would have hidden a real regression on the most important public page.
 *
 * So the payload is scoped:
 *
 * - `PUBLIC_CLIENT_NAMESPACES` — provided by the root locale layout, so every page has them.
 * - `APP_CLIENT_NAMESPACES` — provided **additionally** by the `(app)` route-group layout,
 *   so the tracker's strings never reach a content page.
 *
 * Adding a namespace to the app list now costs a public content page nothing. That is the point,
 * and it matters going into Phase 2, which adds most of the app's screens and therefore most
 * of its strings.
 *
 * KEEPING IT CORRECT: a missing namespace is not a build error, it is a runtime error in
 * somebody's browser, which is the worst place to find out. `pnpm i18n-client-lint`
 * cross-checks these lists against every `useTranslations("…")` in the source and fails CI on
 * a namespace that is used but not listed, or listed but no longer used.
 */

/** Sent on every page, public and signed-in alike. */
export const PUBLIC_CLIENT_NAMESPACES = [
  "appNav",
  "calculators",
  "notFound",
  "onboarding",
  "resetPassword",
  "signIn",
  "theme",
] as const;

/**
 * Sent only under `/[locale]/(app)/*` — the signed-in tracker. Every one of these is on a
 * `robots: noindex` page, so the SEO-weight argument that motivated P1.11.2 does not apply
 * to them; the cost is paid only by someone actually using the app.
 */
export const APP_CLIENT_NAMESPACES = [
  // First-run period entry and the cycle phase strip. App-only on purpose: adding it to the public
  // list would ship it to /learn, which is the regression the page-weight budget
  // caught the last time tracker strings leaked onto a content page.
  "firstRun",
  "flowStrip",
  // The Tools hub (R3.2.1/2.3) — signed-in only, so it never reaches /learn.
  "tools",
  "phaseEducation",
  "phaseStrip",
  "admin",
  "dashboard",
  "experience",
  "postpartum",
  "appointments",
  "fertility",
  "mrs",
  "epds",
  "moodScreeners",
  "offer",
  "medications",
  "contractions",
  "weight",
  "teen",
  "menopause",
  "mfa",
  "pregnancy",
  "pregnancyMovements",
  "pregnancySymptoms",
  "settings",
  "symptoms",
  "track",
  "visitSummary",
] as const;

/** Union — every namespace that reaches a browser anywhere. */
export const CLIENT_NAMESPACES = [
  ...PUBLIC_CLIENT_NAMESPACES,
  ...APP_CLIENT_NAMESPACES,
] as const;

type Messages = Record<string, unknown>;

function pick(messages: Messages, namespaces: readonly string[]): Messages {
  const picked: Messages = {};
  for (const namespace of namespaces) {
    if (namespace in messages) picked[namespace] = messages[namespace];
  }
  return picked;
}

/** Narrow a full catalog to what every page needs (root locale layout). */
export function pickClientMessages(messages: Messages): Messages {
  return pick(messages, PUBLIC_CLIENT_NAMESPACES);
}

/**
 * Narrow to what the signed-in app needs. Returns the **union** with the public set, because
 * a nested `NextIntlClientProvider` replaces the context rather than extending it — returning
 * only the app namespaces would break `appNav` inside the app shell.
 */
export function pickAppClientMessages(messages: Messages): Messages {
  return pick(messages, CLIENT_NAMESPACES);
}
