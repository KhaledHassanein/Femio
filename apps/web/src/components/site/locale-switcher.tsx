"use client";

import { useEffect, useId, useRef, useState } from "react";
import { Check } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import { Link, usePathname } from "@/i18n/navigation";
import { routing, type Locale } from "@/i18n/routing";
import { LOCALE_FLAGS, LOCALE_NAMES } from "@/lib/locales";
import { cn } from "@/lib/utils";

/**
 * The language switcher (owner's go-live note, 2026-10-29): the one component that lists
 * the site's languages, in two shapes so the header and the footer can never disagree.
 *
 *  - "menu": the header control. A button showing the current language's flag (and its
 *    name from the tablet width up) opens a short list under it; Escape, a click outside
 *    or a choice closes it. A disclosure, not an ARIA menu: the items are ordinary links.
 *  - "inline": the footer row. Four plain links, always visible, for a reader who scrolls
 *    to the end and for crawlers.
 *
 * Every link points at the same page in the other language (`usePathname` strips the
 * locale prefix; `Link` adds the new one). A guide that is not yet translated falls back
 * to English on that path (lib/cms/client), so a switch never lands on a 404. Each name
 * carries `lang` and `hrefLang`, and the current language is marked with aria-current.
 * Every entry is flag + name (owner decision, 2026-10-29); the flag is decorative and the
 * name is the accessible text, see lib/locales.ts.
 */

/** The small flag that sits before a language name. Decorative: the name is the text. */
function Flag({ locale, className }: { locale: Locale; className?: string }) {
  return (
    <img
      src={`/flags/${LOCALE_FLAGS[locale]}.svg`}
      alt=""
      width={20}
      height={15}
      loading="lazy"
      decoding="async"
      className={cn("h-[15px] w-5 shrink-0 rounded-[2px] shadow-xs", className)}
    />
  );
}
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
                  "inline-flex min-h-11 items-center gap-2 text-white/70 transition-colors duration-fast hover:text-white",
                  l === locale && "font-semibold text-white",
                )}
              >
                <Flag locale={l} />
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
        <Flag locale={locale} />
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
                  "flex h-11 items-center gap-3 rounded-md px-3 text-sm text-text hover:bg-surface-sunken",
                  l === locale && "font-semibold",
                )}
              >
                <Flag locale={l} />
                <span className="flex-1">{LOCALE_NAMES[l]}</span>
                {l === locale ? <Check className="size-4 text-primary" aria-hidden /> : null}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
    </div>
  );
}
