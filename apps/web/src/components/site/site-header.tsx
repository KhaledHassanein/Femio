import { getTranslations } from "next-intl/server";
import { LifeBuoy, Search } from "lucide-react";
import { Link } from "@/i18n/navigation";
import { ThemeToggle } from "@/components/theme-toggle";
import { getCrisisContent } from "@/lib/crisis/content";
import { isUnpublishedSection } from "@/lib/content/unpublished-sections";
import { APP_PAGE } from "@/lib/site";

// Persistent public-site header (P1.9b.1, v3 P1.5). Rendered by the (public) layout, so
// it appears on every marketing/content page but not on the signed-in app (which has
// its own AppNav).
//
// v3: one row of actions and one row of sections, never three wrapped rows at 390px.
// The sections scroll sideways when they do not fit, which keeps every one of them one
// tap away (rule 2) without a hamburger hiding them.
const LINKS = [
  { href: "/learn", key: "learn" },
  { href: "/conditions", key: "conditions" },
  { href: "/calculators", key: "calculators" },
  { href: "/faq", key: "faq" },
  { href: "/glossary", key: "glossary" },
] as const;

export async function SiteHeader({ locale }: { locale: string }) {
  const t = await getTranslations({ locale, namespace: "nav" });
  // The approved, verbatim crisis copy (ADR-013), not a new string: a woman looking
  // for help reads the same words here as on the launcher and in the dialog.
  const crisis = getCrisisContent(locale);

  return (
    <header className="sticky top-0 z-sticky border-b border-border/70 bg-bg/85 backdrop-blur-md supports-[backdrop-filter]:bg-bg/70">
      <div className="mx-auto flex w-full max-w-5xl items-center gap-2 px-4 pt-3 sm:px-6">
        <Link
          href="/"
          className="me-auto font-display text-2xl font-medium lowercase leading-none tracking-tight text-primary"
        >
          femio
        </Link>
        {/* Search leads (D4): a search page nobody can navigate to is the defect R1.9l
            cost a session on. Icon-only here, labelled for assistive tech. */}
        <Link
          href="/search"
          aria-label={t("search")}
          className="inline-flex size-11 items-center justify-center rounded-pill text-text-muted hover:bg-surface-sunken hover:text-text"
        >
          <Search className="size-5" aria-hidden />
        </Link>
        {/* A link to the help page, not a second "button" with the launcher's name:
            the floating launcher still opens the dialog on every page (ADR-013). */}
        <Link
          href="/help-now"
          lang={crisis.isFallback ? crisis.lang : undefined}
          className="hidden h-9 items-center gap-1.5 rounded-pill px-3 text-sm font-medium text-text-muted hover:bg-surface-sunken hover:text-text sm:inline-flex"
        >
          <LifeBuoy className="size-4" aria-hidden />
          {crisis.strings.launcher}
        </Link>
        <ThemeToggle />
        {/* One action: the app (D8). */}
        <Link
          href={APP_PAGE}
          data-track="get_app_click"
          data-placement="header"
          className="inline-flex h-9 items-center rounded-pill bg-primary-solid px-4 text-sm font-semibold text-primary-fg-solid hover:bg-primary-hover"
        >
          {t("getApp")}
        </Link>
      </div>
      <nav
        aria-label={t("sections")}
        className="mx-auto w-full max-w-5xl overflow-x-auto px-4 pb-2 pt-1 [scrollbar-width:none] sm:px-6 [&::-webkit-scrollbar]:hidden"
      >
        <ul className="flex w-max items-center gap-1 text-sm">
          {LINKS.filter((l) => !isUnpublishedSection(l.href)).map((l) => (
            <li key={l.href}>
              <Link
                href={l.href}
                className="inline-flex h-9 items-center rounded-pill px-3 text-text-muted hover:bg-surface-sunken hover:text-text"
              >
                {t(l.key)}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
    </header>
  );
}
