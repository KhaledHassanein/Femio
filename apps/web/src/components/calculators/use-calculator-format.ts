"use client";

import { useFormatter } from "next-intl";

/**
 * Date formatting shared by the calculators. Dates are ISO calendar dates with no
 * time, so they are rendered in UTC to keep the day the user tapped; the locale's
 * own formats (and Western digits in Arabic, pinned in `i18n/request.ts`) apply.
 */
export function useCalculatorFormat() {
  const format = useFormatter();
  const day = (iso: string) => format.dateTime(new Date(`${iso}T00:00:00Z`), { day: "numeric", month: "long", timeZone: "UTC" });
  const long = (iso: string) => format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "long", timeZone: "UTC" });
  /**
   * "15 – 20 October" / "October 15 – 20" in the locale's own order (Intl.formatRange).
   * In Arabic the dash between two numbers resolves to right-to-left and the pair
   * reads "20 – 15"; a left-to-right mark on each side of the dash keeps the order
   * (Unicode bidi rule N1: numbers act as R on neutrals).
   */
  const range = (startISO: string, endISO: string) =>
    format
      .dateTimeRange(new Date(`${startISO}T00:00:00Z`), new Date(`${endISO}T00:00:00Z`), { day: "numeric", month: "long", timeZone: "UTC" })
      .replace(/(\d+)(\s*[–—-]\s*)(\d+)/, "$1‎$2‎$3");
  return { day, long, range };
}
