import { getTranslations, setRequestLocale } from "next-intl/server";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { JsonLd } from "@/components/seo/json-ld";
import { organizationJsonLd, websiteJsonLd } from "@/lib/seo/jsonld";
import { Link } from "@/i18n/navigation";
import { PageView } from "@/components/analytics/page-view";

type PageProps = { params: Promise<{ locale: string }> };

// Content-first homepage (P1.9b). Header/footer come from the (public) layout.
const SECTIONS = [
  { key: "learn", href: "/learn" },
  { key: "conditions", href: "/conditions" },
  { key: "calculators", href: "/calculators" },
  { key: "faq", href: "/faq" },
  { key: "glossary", href: "/glossary" },
] as const;

export default async function HomePage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("home");

  return (
    <main className="mx-auto flex w-full max-w-5xl flex-1 flex-col gap-12 px-6 pb-20 pt-10">
      <PageView area="home" />
      <JsonLd data={websiteJsonLd(locale)} />
      <JsonLd data={organizationJsonLd()} />

      {/* Hero */}
      <section className="flex max-w-2xl flex-col gap-5">
        <p className="text-sm font-semibold uppercase tracking-widest text-primary">{t("eyebrow")}</p>
        <h1 className="font-display text-3xl text-text sm:text-4xl">{t("heroTitle")}</h1>
        <p className="text-md text-text-muted">{t("heroBody")}</p>
        <div className="flex flex-wrap items-center gap-4">
          <Button asChild variant="accent" size="lg">
            <Link href="/welcome">{t("cta")}</Link>
          </Button>
        </div>
      </section>

      {/* Library sections */}
      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {SECTIONS.map((s) => (
          <Link key={s.key} href={s.href} className="group rounded-lg">
            <Card className="h-full transition-colors hover:bg-surface-sunken">
              <CardContent className="flex flex-col gap-2 p-6">
                <div className="flex items-center justify-between gap-2">
                  <h2 className="font-display text-lg text-text">{t(`sections.${s.key}.name`)}</h2>
                  <ArrowRight
                    className="size-4 text-text-muted transition-transform group-hover:translate-x-0.5 rtl:-scale-x-100"
                    aria-hidden
                  />
                </div>
                <p className="text-sm text-text-muted">{t(`sections.${s.key}.desc`)}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </section>
    </main>
  );
}
