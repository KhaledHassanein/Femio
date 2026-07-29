import { getTranslations, setRequestLocale } from "next-intl/server";
import { Button } from "@/components/ui/button";
import { ThemeToggle } from "@/components/theme-toggle";
import { JsonLd } from "@/components/seo/json-ld";
import { organizationJsonLd, websiteJsonLd } from "@/lib/seo/jsonld";
import { Link } from "@/i18n/navigation";

type PageProps = {
  params: Promise<{ locale: string }>;
};

export default async function HomePage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("home");

  return (
    <div className="flex min-h-dvh flex-col">
      <JsonLd data={websiteJsonLd(locale)} />
      <JsonLd data={organizationJsonLd()} />
      <header className="flex justify-end p-4">
        <ThemeToggle />
      </header>
      <main className="mx-auto flex w-full max-w-3xl flex-1 flex-col justify-center gap-6 px-6 pb-16">
      <p className="text-sm font-semibold uppercase tracking-widest text-primary">
        {t("eyebrow")}
      </p>
      <h1 className="font-display text-3xl text-text">{t("title")}</h1>
      <p className="max-w-prose text-md text-text-muted">{t("body")}</p>
      <div className="flex flex-wrap items-center gap-4">
        <Button asChild variant="accent" size="lg">
          <Link href="/welcome">{t("cta")}</Link>
        </Button>
        <Link href="/learn" className="text-sm text-text-link underline">
          {t("learn")}
        </Link>
        <Link href="/conditions" className="text-sm text-text-link underline">
          {t("conditions")}
        </Link>
        <Link href="/sign-in" className="text-sm text-text-link underline">
          {t("signIn")}
        </Link>
      </div>
      <div className="flex flex-wrap gap-3">
        <span className="rounded-pill bg-primary-soft px-4 py-2 text-sm text-primary-soft-text">
          {t("chips.primary")}
        </span>
        <span className="rounded-pill bg-accent-soft px-4 py-2 text-sm text-accent-soft-text">
          {t("chips.accent")}
        </span>
        <span className="rounded-pill bg-success-soft px-4 py-2 text-sm text-success-text">
          {t("chips.fertile")}
        </span>
        <span className="rounded-pill bg-warning-soft px-4 py-2 text-sm text-warning-text">
          {t("chips.uncertainty")}
        </span>
      </div>
      </main>
    </div>
  );
}
