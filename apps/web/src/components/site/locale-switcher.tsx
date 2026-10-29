"use client";

import { useEffect, useId, useRef, useState } from "react";
import { Check, Languages } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import { Link, usePathname } from "@/i18n/navigation";
import { routing, type Locale } from "@/i18n/routing";
import { LOCALE_NAMES } from "@/lib/locales";
import { cn } from "@/lib/utils";

/**
 * The language switcher (owner's go-live note, 2026-10-29): the one component that lists
 * the site's languages, in two shapes so the header and the footer can never disagree.
 *
 *  - "menu": the header control. An icon button (the language name beside it from the
 *    tablet width up) opens a short list under it; Escape, a click outside or a choice
 *    closes it. A disclosure, not an ARIA menu: the items are ordinary links.
 *  - "inline": the footer row. Four plain links, always visible, for a reader who scrolls
 *    to the end and for crawlers.
 *
 * Every link points at the same page in the other language (`usePathname` strips the
 * locale prefix; `Link` adds the new one). A guide that is not yet translated falls back
 * to English on that path (lib/cms/client), so a switch never lands on a 404. Each name
 * carries `lang` and `hrefLang`, and the current language is marked with aria-current.
 */
export function LocaleSwitcher({ variant = "menu" }: { variant?: "menu" | "inline" }) {
  const locale = useLocale() as Locale;
  const pathname = usePathname();
  const t = useTranslations("locale");

  if (variant === "inline") {
    return (
      <nav aria-label={t("label")}>
        <ul className="flex flex-wrap gap-x-4 gap-y-2 text-sm">
          {routing.locales.map((l) => (
            <li key={l}>
              <Link
                href={pathname}
                locale={l}
                lang={l}
                hrefLang={l}
                aria-current={l === locale ? "true" : undefined}
                className={cn(
                  "inline-flex min-h-11 items-center text-white/70 transition-colors duration-fast hover:text-white",
                  l === locale && "font-semibold text-white",
                )}
              >
                {LOCALE_NAMES[l]}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
    );
  }

  return <LocaleMenu locale={locale} pathname={pathname} label={t("label")} />;
}

function LocaleMenu({ locale, pathname, label }: { locale: Locale; pathname: string; label: string }) {
  const [open, setOpen] = useState(false);
  const root = useRef<HTMLDivElement>(null);
  const listId = useId();

  // Close on a click outside or on Escape, the two ways people expect a small list to
  // go away without choosing.
  useEffect(() => {
    if (!open) return;
    const onPointer = (e: PointerEvent) => {
      if (root.current && !root.current.contains(e.target as Node)) setOpen(false);
    };
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setOpen(false);
    };
    document.addEventListener("pointerdown", onPointer);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("pointerdown", onPointer);
      document.removeEventListener("keydown", onKey);
    };
  }, [open]);

  return (
    <div ref={root} className="relative">
      <button
        type="button"
        aria-label={label}
        aria-expanded={open}
        aria-controls={listId}
        onClick={() => setOpen((v) => !v)}
        className="inline-flex h-11 min-w-10 items-center gap-1.5 rounded-pill px-2 text-sm font-medium text-text-muted hover:bg-surface-sunken hover:text-text sm:px-2.5"
      >
        <Languages className="size-5" aria-hidden />
        <span lang={locale} className="hidden sm:inline">
          {LOCALE_NAMES[locale]}
        </span>
      </button>
      <nav
        id={listId}
        aria-label={label}
        hidden={!open}
        className="absolute end-0 top-full z-dropdown mt-1 w-48 rounded-lg border border-border bg-surface-raised p-1 shadow-lg"
      >
        <ul className="flex flex-col">
          {routing.locales.map((l) => (
            <li key={l}>
              <Link
                href={pathname}
                locale={l}
                lang={l}
                hrefLang={l}
                aria-current={l === locale ? "true" : undefined}
                onClick={() => setOpen(false)}
                className={cn(
                  "flex h-11 items-center justify-between rounded-md px-3 text-sm text-text hover:bg-surface-sunken",
                  l === locale && "font-semibold",
                )}
              >
                {LOCALE_NAMES[l]}
                {l === locale ? <Check className="size-4 text-primary" aria-hidden /> : null}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
    </div>
  );
}
