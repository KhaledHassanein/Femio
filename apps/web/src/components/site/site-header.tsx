import { getTranslations } from "next-intl/server";
import { Link } from "@/i18n/navigation";
import { ThemeToggle } from "@/components/theme-toggle";

// Persistent public-site header (P1.9b.1). Rendered by the (public) layout, so it
// appears on every marketing/content page but not on the signed-in app (which has
// its own AppNav).
const LINKS = [
  /**
   * Search leads (D4). It is the entry point to everything after it, and a search
   * page nobody can navigate to is the defect R1.9l cost a session on — a feature
   * that exists, passes its tests, and is unreachable from the running app.
   */
  { href: "/search", key: "search" },
  { href: "/learn", key: "learn" },
  { href: "/conditions", key: "conditions" },
  { href: "/calculators", key: "calculators" },
  { href: "/faq", key: "faq" },
  { href: "/glossary", key: "glossary" },
] as const;

export async function SiteHeader() {
  const t = await getTranslations("nav");
  return (
    <header className="border-b border-border bg-surface">
      <div className="mx-auto flex w-full max-w-5xl flex-wrap items-center justify-between gap-x-4 gap-y-2 px-6 py-3">
        <Link href="/" className="font-display text-lg lowercase tracking-tight text-primary">
          femio
        </Link>
        <nav className="flex flex-wrap items-center gap-x-4 gap-y-1 text-sm">
          {LINKS.map((l) => (
            <Link key={l.href} href={l.href} className="text-text-muted hover:text-text">
              {t(l.key)}
            </Link>
          ))}
        </nav>
        <div className="flex items-center gap-3">
          <Link href="/sign-in" className="text-sm text-text-link underline">
            {t("signIn")}
          </Link>
          <ThemeToggle />
        </div>
      </div>
    </header>
  );
}
