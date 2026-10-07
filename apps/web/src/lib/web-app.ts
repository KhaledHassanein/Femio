/**
 * Whether the signed-in web app is open (D8, ADR-070).
 *
 * The product is the private Android app; the website is articles, calculators and the
 * way to get the app. The web tracker, sign-in and onboarding stay in the code, closed,
 * so the logic remains testable and can return when sync does. CI turns it on to keep
 * those tests running; production leaves it unset.
 *
 * `NEXT_PUBLIC_` so a client component can read it too. It is inlined at build time,
 * which is the point: a closed build carries no path into the app.
 */
export function webAppEnabled(): boolean {
  return process.env.NEXT_PUBLIC_WEB_APP_ENABLED === "1";
}

/** Where every closed route sends her: the page that explains and links the app. */
export const APP_PAGE = "/app";

/**
 * First path segments (after the locale) that belong to the web app: the `(app)`
 * route group plus the auth and onboarding pages outside it. Anything not listed stays
 * public, including `/help-now`, which must never be behind anything (ADR-013).
 */
export const WEB_APP_SEGMENTS: ReadonlySet<string> = new Set([
  "admin",
  "appointments",
  "calendar",
  "dashboard",
  "fertility",
  "medications",
  "mfa",
  "patterns",
  "reset-password",
  "screeners",
  "settings",
  "shared-with-me",
  "sharing",
  "sign-in",
  "summary",
  "tools",
  "track",
  "welcome",
]);

/** `"/en/track/history"` → `{ locale: "en", segment: "track" }`. */
export function webAppSegment(
  pathname: string,
  locales: readonly string[],
): { locale: string | null; segment: string | null } {
  const parts = pathname.split("/").filter(Boolean);
  const locale = parts[0] && locales.includes(parts[0]) ? parts[0] : null;
  const first = locale ? parts[1] : parts[0];
  return { locale, segment: first && WEB_APP_SEGMENTS.has(first) ? first : null };
}
