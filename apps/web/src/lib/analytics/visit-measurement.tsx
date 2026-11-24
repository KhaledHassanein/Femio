"use client";

import { Analytics, type BeforeSend } from "@vercel/analytics/next";

/**
 * Visit counting with Vercel Web Analytics (owner decision 2026-11-24, amends ADR-075).
 *
 * Why this and not Tag Manager / GA4 / the Meta pixel: no tracking tool may learn which
 * health page a visitor opened. Vercel Web Analytics sets no cookie, builds no profile
 * across sites and sends nothing to a third party: the script and its beacon are served
 * from this site's own origin (`/_vercel/insights/*`), so counts stay aggregate.
 *
 * It is the ONLY measurement code on the site, and it has no custom events: nothing a
 * visitor typed or tapped is ever reported.
 */

/**
 * Keeps only `origin + path` of a URL: the query string and the hash are dropped, so a
 * `?utm_…`, a search term or an anchor can never travel with a page view.
 * Returns the input unchanged if it is not a parseable absolute URL (never throws).
 */
export function stripQueryAndHash(url: string): string {
  try {
    const parsed = new URL(url);
    return `${parsed.origin}${parsed.pathname}`;
  } catch {
    return url.replace(/[?#].*$/, "");
  }
}

/** `beforeSend` hook for `<Analytics />`: rewrites the URL to path only. */
export const pathOnly: BeforeSend = (event) => ({ ...event, url: stripQueryAndHash(event.url) });

/**
 * Renders the Vercel Analytics script in production builds only, so development and
 * tests make no request and print no debug noise. On a host that is not Vercel the
 * script URL simply 404s and nothing is collected.
 */
export function VisitMeasurement() {
  if (process.env.NODE_ENV !== "production") return null;
  return <Analytics beforeSend={pathOnly} />;
}
