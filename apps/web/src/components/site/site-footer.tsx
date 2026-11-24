import { getTranslations } from "next-intl/server";
import { LifeBuoy } from "lucide-react";
import { Link } from "@/i18n/navigation";
import { LocaleSwitcher } from "@/components/site/locale-switcher";
import { isUnpublishedSection } from "@/lib/content/unpublished-sections";

// Persistent public-site footer (P1.9b.1, v3 P1.5). Three short columns on a deep plum
// ground (the aurora's base colour, without its light: the light is for hero moments).
// Every link the old footer carried is still here; they are grouped by what a reader
// is looking for rather than listed in one wrapped line.
const EXPLORE = [
  { href: "/learn", key: "learn" },
  { href: "/conditions", key: "conditions" },
  { href: "/calculators", key: "calculators" },
  { href: "/faq", key: "faq" },
  { href: "/glossary", key: "glossary" },
] as const;
const TRUST = [
  { href: "/about", key: "about" },
  { href: "/editorial-policy", key: "editorial" },
  { href: "/medical-review", key: "medicalReview" },
  { href: "/authors", key: "authors" },
] as const;
const LEGAL = [
  { href: "/privacy", key: "privacy" },
  { href: "/terms", key: "terms" },
  { href: "/consumer-health-data", key: "healthData" },
] as const;

const linkClass = "text-white/70 transition-colors duration-fast hover:text-white";

export async function SiteFooter({ locale }: { locale: string }) {
  const nav = await getTranslations({ locale, namespace: "nav" });
  const t = await getTranslations({ locale, namespace: "footer" });
  const year = new Date().getFullYear();

  const column = (title: string, links: readonly { href: string; key: string }[]) => (
    <div className="flex flex-col gap-3">
      <h2 className="text-2xs font-semibold uppercase tracking-wider text-white/65">{title}</h2>
      <ul className="flex flex-col gap-2 text-sm">
        {links
          .filter((l) => !isUnpublishedSection(l.href))
          .map((l) => (
            <li key={l.href}>
              <Link href={l.href} className={linkClass}>
                {nav(l.key)}
              </Link>
            </li>
          ))}
      </ul>
    </div>
  );

  return (
    <footer className="mt-auto bg-[var(--aurora-ground)] text-white">
      <div className="mx-auto flex w-full max-w-5xl flex-col gap-10 px-6 pb-10 pt-12">
        <div className="flex flex-col gap-2">
          {/* The wordmark is always English "femio" (product rule 6). */}
          <span className="font-display text-4xl font-medium lowercase leading-none tracking-tight">
            femio
          </span>
          <p className="max-w-sm text-sm text-white/70">{t("tagline")}</p>
        </div>

        <div className="grid grid-cols-2 gap-x-6 gap-y-8 sm:grid-cols-3">
          {column(t("explore"), EXPLORE)}
          {column(t("trust"), TRUST)}
          {column(t("legal"), LEGAL)}
        </div>

        <div className="flex flex-col gap-4 border-t border-white/15 pt-6 sm:flex-row sm:items-center sm:justify-between">
          <Link
            href="/help-now"
            className="inline-flex h-11 w-fit items-center gap-2 rounded-pill border border-white/25 px-4 text-sm font-medium text-white hover:bg-white/10"
          >
            <LifeBuoy className="size-4" aria-hidden />
            {t("helpNow")}
          </Link>
          <LocaleSwitcher variant="inline" />
          <p className="text-2xs text-white/65">{t("rights", { year })}</p>
        </div>
      </div>
    </footer>
  );
}
