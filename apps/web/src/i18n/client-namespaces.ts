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
  /**
   * `/search` is a **public** route (D4): everything it searches is public, and
   * migration `0022` grants the search function to `anon` precisely so a visitor
   * can look something up before creating an account.
   *
   * `tools` rides along because the results list names Femio's tools, and it uses
   * the launcher's own labels rather than a second copy of them — a duplicate
   * vocabulary is how a tool ends up called one thing in the launcher and another
   * in search. That costs the public pages roughly a kilobyte per locale, which is
   * the right trade for not having two names for the same screen.
   */
  "search",
  "tools",
  "notFound",
  "theme",
] as const;

/**
 * Sent only under `/calculators/*`, by that route's layout (2026-10-08). The calculator
 * set grew to the competitor list with calendar results (P2.6), and shipping its strings
 * from the root layout put ~5 KB on every page, the homepage included, where the page-weight
 * budget caught it. Scoped here, a new calculator costs only the calculator pages.
 */
export const CALCULATOR_CLIENT_NAMESPACES = ["calculators"] as const;

/**
 * Sent only by the sign-in, welcome (onboarding) and reset-password layouts, and inside the
 * app. With the web app closed (D8) these pages redirect away, so the root layout carrying
 * the onboarding wizard's copy on every public page was pure weight.
 */
export const AUTH_CLIENT_NAMESPACES = ["onboarding", "resetPassword", "signIn"] as const;

/**
 * Sent only under `/[locale]/(app)/*` — the signed-in tracker. Every one of these is on a
 * `robots: noindex` page, so the SEO-weight argument that motivated P1.11.2 does not apply
 * to them; the cost is paid only by someone actually using the app.
 */
export const APP_CLIENT_NAMESPACES = [
  /**
   * Accessible names for served modules (RB-C4). Read by `ModuleHost`, which
   * applies `a11y.labelKey` from the v2 document so no module has to remember to
   * label itself. App-only: a served experience document is never resolved on a
   * public content page.
   */
  "modules",
  // First-run period entry and the cycle phase strip. App-only on purpose: adding it to the public
  // list would ship it to /learn, which is the regression the page-weight budget
  // caught the last time tracker strings leaked onto a content page.
  "firstRun",
  "calendar",
  "log",
  "states",
  "prediction",
  // Log term labels span three namespaces (RB-C6): symptoms.items.*,
  // fertility.cm.* and vitals.* — all three must reach the browser or a chip
  // renders with no label.
  "vitals",
  "cycleReport",
  "cycleVariability",
  "flowStrip",
  // Partner sharing (Phase 4.5) — her side and the recipient's side. Both are
  // signed-in-only routes, so neither reaches a public content page.
  "partnerSharing",
  "partnerShared",
  // The pattern engine (P2.5) — its own signed-in screen.
  "patterns",
  // Notification preferences (P2.8), rendered inside Settings.
  "notifications",
  "phaseEducation",
  "phaseStrip",
  "symptomPatterns",
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
  ...CALCULATOR_CLIENT_NAMESPACES,
  ...AUTH_CLIENT_NAMESPACES,
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

/** The public set plus the calculators (the `/calculators` layout). */
export function pickCalculatorClientMessages(messages: Messages): Messages {
  return pick(messages, [...PUBLIC_CLIENT_NAMESPACES, ...CALCULATOR_CLIENT_NAMESPACES]);
}

/** The public set plus sign-in, onboarding and password reset (their layouts). */
export function pickAuthClientMessages(messages: Messages): Messages {
  return pick(messages, [...PUBLIC_CLIENT_NAMESPACES, ...AUTH_CLIENT_NAMESPACES]);
}
