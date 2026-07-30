import { getTranslations } from "next-intl/server";
import { Link } from "@/i18n/navigation";

// Persistent public-site footer (P1.9b.1): library nav + crisis link + copyright.
const LINKS = [
  { href: "/learn", key: "learn" },
  { href: "/conditions", key: "conditions" },
  { href: "/calculators", key: "calculators" },
  { href: "/faq", key: "faq" },
  { href: "/glossary", key: "glossary" },
] as const;

export async function SiteFooter() {
  const nav = await getTranslations("nav");
  const t = await getTranslations("footer");
  const year = new Date().getFullYear();

  return (
    <footer className="mt-auto border-t border-border bg-surface">
      <div className="mx-auto flex w-full max-w-5xl flex-col gap-4 px-6 py-8">
        <div className="flex flex-col gap-1">
          <span className="font-display text-lg lowercase tracking-tight text-primary">femio</span>
          <p className="text-sm text-text-muted">{t("tagline")}</p>
        </div>
        <nav className="flex flex-wrap gap-x-5 gap-y-2 text-sm">
          {LINKS.map((l) => (
            <Link key={l.href} href={l.href} className="text-text-muted hover:text-text">
              {nav(l.key)}
            </Link>
          ))}
          <Link href="/about" className="text-text-muted hover:text-text">
            {nav("about")}
          </Link>
          <Link href="/editorial-policy" className="text-text-muted hover:text-text">
            {nav("editorial")}
          </Link>
          <Link href="/medical-review" className="text-text-muted hover:text-text">
            {nav("medicalReview")}
          </Link>
          <Link href="/privacy" className="text-text-muted hover:text-text">
            {nav("privacy")}
          </Link>
          <Link href="/terms" className="text-text-muted hover:text-text">
            {nav("terms")}
          </Link>
          <Link href="/help-now" className="text-text-muted hover:text-text">
            {t("helpNow")}
          </Link>
        </nav>
        <p className="text-2xs text-text-subtle">{t("rights", { year })}</p>
      </div>
    </footer>
  );
}
