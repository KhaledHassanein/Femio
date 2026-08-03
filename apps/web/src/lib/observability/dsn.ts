/**
 * Sentry DSN validation (P1.4.2).
 *
 * Error reports carry request context, so they are personal data and belong under
 * the same residency rule as everything else (docs/13 §6, DATA_MAP): **EU only**.
 * Sentry runs separate US and EU ingest clusters and the *US host is the default* —
 * a DSN copied from the wrong org silently ships an international transfer with no
 * mechanism behind it, and nothing in the app would look wrong.
 *
 * So a non-EU DSN **fails the build**, exactly like the PostHog host guard and the
 * crisis directory link. Pure so it is unit tested without an environment.
 */

/** Sentry's EU ingest domain. `de` is the EU region's cluster suffix. */
const EU_INGEST_SUFFIX = ".ingest.de.sentry.io";

export function isApprovedSentryDsn(value: string): boolean {
  let parsed: URL;
  try {
    parsed = new URL(value);
  } catch {
    return false;
  }
  return (
    parsed.protocol === "https:" &&
    parsed.hostname.endsWith(EU_INGEST_SUFFIX) &&
    // A DSN is https://<publicKey>@<host>/<projectId> — anything else is malformed.
    parsed.username.length > 0 &&
    parsed.pathname.length > 1
  );
}

/**
 * The origin a DSN sends to, for the CSP `connect-src` allow-list. Returns null
 * for anything unparseable, so a bad value can never widen the policy.
 */
export function sentryConnectOrigin(value: string | undefined): string | null {
  if (!value) return null;
  try {
    const parsed = new URL(value);
    return `${parsed.protocol}//${parsed.hostname}`;
  } catch {
    return null;
  }
}
