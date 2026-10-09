"use client";

import { useLocale } from "next-intl";
import { Link, usePathname } from "@/i18n/navigation";
import { routing } from "@/i18n/routing";

/** Each language in its own name and script, so it is findable by someone who reads only it. */
const NATIVE: Record<string, string> = {
  en: "English",
  ar: "العربية",
  fr: "Français",
  es: "Español",
};

/**
 * The same page in the other three languages (public audit F22: four languages were
 * promised and no control switched between them). Plain links, so it works without
 * JavaScript and a crawler sees the alternates too.
 */
export function LanguageSwitcher({ label }: { label: string }) {
  const locale = useLocale();
  const pathname = usePathname();
  return (
    <nav aria-label={label} className="flex flex-wrap items-center gap-1 text-sm">
      {routing.locales
        .filter((l) => l !== locale)
        .map((l) => (
          <Link
            key={l}
            href={pathname}
            locale={l}
            lang={l}
            hrefLang={l}
            className="inline-flex h-9 items-center rounded-pill px-3 text-text-muted hover:bg-surface-sunken hover:text-text"
          >
            {NATIVE[l]}
          </Link>
        ))}
    </nav>
  );
}
