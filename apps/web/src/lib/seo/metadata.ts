import type { Metadata } from "next";
import { routing } from "@/i18n/routing";

/**
 * Self-referencing canonical for the current locale + a full hreflang cluster
 * (all locales + x-default). Path is locale-less, e.g. "/calculators". Returned
 * URLs are relative; the layout's metadataBase makes them absolute.
 */
export function localizedAlternates(
  locale: string,
  path = "/",
): NonNullable<Metadata["alternates"]> {
  const clean = path === "/" ? "" : path.replace(/\/$/, "");
  const languages: Record<string, string> = {};
  for (const l of routing.locales) languages[l] = `/${l}${clean}`;
  languages["x-default"] = `/${routing.defaultLocale}${clean}`;
  return { canonical: `/${locale}${clean}`, languages };
}
