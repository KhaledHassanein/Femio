/**
 * Which message namespaces are sent to the browser (P1.11.2).
 *
 * `NextIntlClientProvider` with no `messages` prop hands the **entire** catalog to the
 * client, and next-intl serialises it into every page's HTML. That was ~32 KB of English
 * on every page and ~51 KB of Arabic — over half the weight of `/en/learn` — including the
 * privacy policy, the terms, the MFA copy and the insights dashboard on a page that renders
 * none of them. Core Web Vitals is a ranking signal, so on a site whose whole point is
 * organic search that is not a rounding error.
 *
 * Only **client** components need messages in the browser: anything rendered on the server
 * with `getTranslations` has already become text by the time the HTML is sent. So this list
 * is the namespaces reached by `useTranslations` — and nothing else.
 *
 * KEEPING IT CORRECT: a missing namespace is not a build error, it is a runtime error in
 * somebody's browser, which is the worst place to find out. So `pnpm i18n-client-lint`
 * (scripts/i18n/client-namespaces-lint.mjs) cross-checks this list against every
 * `useTranslations("…")` in the source and fails CI on a namespace that is used but not
 * listed — or listed but no longer used. Add the namespace here when you add the hook; the
 * guard will tell you if you forget.
 */
export const CLIENT_NAMESPACES = [
  "admin",
  "appNav",
  "calculators",
  "mfa",
  "notFound",
  "onboarding",
  // Only `pregnancy.setup` is client-side (the dashboard panel is a server component),
  // but the payload is narrowed per top-level namespace, and ~1 KB is not worth splitting.
  "pregnancy",
  "pregnancySymptoms",
  "resetPassword",
  "settings",
  "signIn",
  "symptoms",
  "theme",
  "track",
  "visitSummary",
] as const;

type Messages = Record<string, unknown>;

/** Narrow a full catalog to the namespaces the browser actually needs. */
export function pickClientMessages(messages: Messages): Messages {
  const picked: Messages = {};
  for (const namespace of CLIENT_NAMESPACES) {
    if (namespace in messages) picked[namespace] = messages[namespace];
  }
  return picked;
}
