import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";

import { AppTourSection, TryDemosSection } from "@/components/demos/demo-sections";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";
import { pageMetadata } from "@/lib/seo/metadata";
import { APP_PAGE } from "@/lib/site";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "demoPage" });
  return pageMetadata({ locale, path: "/demo", title: t("metaTitle"), description: t("intro") });
}

/**
 * `/demo`: every scripted demo of the Android app on one page (owner 2026-11-28).
 *
 * It reuses the existing sections (the screen tour, next periods, Say it, Ask femio),
 * so no new medical text exists here. None of them calls a network, a model or an API:
 * they are canned and run in the browser, and each carries a visible "Demo" label.
 */
export default async function DemoPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("demoPage");
  const tNav = await getTranslations("nav");

  return (
    <main className="flex w-full flex-1 flex-col">
      <section className="mx-auto flex w-full max-w-5xl flex-col gap-4 px-6 pb-4 pt-12">
        <h1 className="font-display text-2xl leading-tight text-text sm:text-3xl rtl:font-bold rtl:leading-relaxed">
          {t("title")}
        </h1>
        <p className="max-w-2xl text-sm leading-relaxed text-text-muted">{t("intro")}</p>
        <div className="flex flex-wrap gap-3">
          <Button asChild>
            <Link href={APP_PAGE}>{tNav("getApp")}</Link>
          </Button>
        </div>
      </section>
      <AppTourSection locale={locale} />
      <TryDemosSection locale={locale} />
    </main>
  );
}
