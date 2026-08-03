"use client";

import { useEffect } from "react";
import { useLocale } from "next-intl";
import { track } from "@/lib/analytics/track";
import type { Area } from "@/lib/analytics/events";
import type { Locale } from "@/i18n/routing";

/**
 * Reports that a coarse product **area** was viewed (P1.20.4).
 *
 * Deliberately not a route-aware hook. `usePathname()` would give us the URL,
 * and the moment a URL is in hand somebody eventually sends it — at which point
 * `/learn/endometriosis-symptoms` becomes a health inference attached to a
 * pseudonymous id, which is the failure this whole layer exists to prevent
 * (ADR-017, ADR-025). So the *page* declares its area as a literal, the type
 * system restricts it to the catalog's seven values, and there is no code path
 * from a path to an event.
 *
 * Renders nothing. Safe on every page: `track()` no-ops without configuration
 * and consent, so mounting this on a public page costs a consenting user one
 * event and everyone else nothing at all.
 */
export function PageView({ area }: { area: Area }) {
  const locale = useLocale() as Locale;

  useEffect(() => {
    void track("page_viewed", { area, locale });
    // Area and locale are stable for the life of the page; re-firing on every
    // render would inflate counts rather than measure views.
  }, [area, locale]);

  return null;
}
