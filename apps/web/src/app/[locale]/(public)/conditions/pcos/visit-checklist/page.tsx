/**
 * The printable PCOS visit checklist (R13.6, owner action 37), under the PCOS hub.
 * This route gathers the page's frame: heading, the checklist, the guides it quotes
 * with their sources, the wellness line and the hand-off to the app. The guides and
 * sources are read from the built content, so they follow every guide revision.
 */
import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { ArrowLeft, Info } from "lucide-react";
import { PcosVisitChecklist } from "@/components/checklists/pcos-visit-checklist";
import { JsonLd } from "@/components/seo/json-ld";
import { AppHandoffCard } from "@/components/site/app-handoff-card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";
import { PCOS_CHECKLIST_PATH, pcosChecklistGuides } from "@/lib/checklists/pcos";
import { getContentBySlug, type ContentDoc } from "@/lib/cms/client";
import { siteConfig } from "@/lib/seo/config";
import { breadcrumbJsonLd } from "@/lib/seo/jsonld";
import { pageMetadata } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };
type Source = NonNullable<ContentDoc["sources"]>[number];

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "pcosChecklist" });
  return pageMetadata({ locale, path: PCOS_CHECKLIST_PATH, title: t("metaTitle"), description: t("metaDescription") });
}

export default async function PcosVisitChecklistPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("pcosChecklist");
  const learn = await getTranslations("learn");

  const found = await Promise.all(pcosChecklistGuides().map((slug) => getContentBySlug("articles", locale, slug)));
  const guides = found.filter((doc): doc is ContentDoc => doc !== null);
  // Several guides cite the same page; list each address once, under its first title.
  const sources = new Map<string, Source>();
  for (const source of guides.flatMap((g) => g.sources ?? [])) {
    const id = source.url ?? source.title;
    if (!sources.has(id)) sources.set(id, source);
  }
  const url = `${siteConfig.baseUrl}/${locale}${PCOS_CHECKLIST_PATH}`;

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-4 py-6 md:px-6 md:py-12 print:max-w-none print:gap-4 print:p-0 print:[color-scheme:light]">
      <JsonLd
        data={breadcrumbJsonLd([
          { name: t("back"), url: `${siteConfig.baseUrl}/${locale}/conditions/pcos` },
          { name: t("title"), url },
        ])}
      />
      <Link href="/conditions/pcos" className="inline-flex items-center gap-1 text-sm text-text-link rtl:flex-row-reverse print:hidden">
        <ArrowLeft className="size-4 rtl:rotate-180" aria-hidden />
        {t("back")}
      </Link>
      <div className="flex flex-col gap-2">
        {/* The paper has no site header, so it names where it came from. */}
        <p dir="ltr" className="hidden text-sm font-semibold print:block rtl:text-right">
          femio · {new URL(siteConfig.baseUrl).host}
        </p>
        <h1 className="font-display text-3xl leading-tight tracking-tighter text-text rtl:tracking-normal print:text-2xl">
          {t("title")}
        </h1>
        <p className="text-lg font-semibold text-text">{t("intro")}</p>
        <p className="text-sm text-text-muted">{t("note")}</p>
      </div>

      <PcosVisitChecklist />

      <section aria-labelledby="guides-title" className="flex flex-col gap-2 border-t border-border pt-4 print:hidden">
        <h2 id="guides-title" className="text-sm font-semibold text-text">
          {t("guidesTitle")}
        </h2>
        <ul className="flex flex-col gap-1 text-sm">
          {guides.map((g) => (
            <li key={g.slug}>
              <Link href={`/learn/${g.slug}`} className="text-text-link underline">
                {g.title}
              </Link>
            </li>
          ))}
        </ul>
      </section>

      <section aria-labelledby="sources-title" className="flex flex-col gap-2 border-t border-border pt-4">
        <h2 id="sources-title" className="text-sm font-semibold text-text">
          {learn("sources")}
        </h2>
        {/* Source titles are the publishers' own English titles in every locale. */}
        <ul lang="en" dir="ltr" className="flex flex-col gap-1 break-words text-sm text-text-muted print:gap-0 print:text-2xs">
          {[...sources.entries()].map(([id, s]) => {
            const link = (chunks: React.ReactNode) =>
              s.url ? (
                <a href={s.url} rel="noreferrer" target="_blank" className="text-text-link underline">
                  {chunks}
                </a>
              ) : (
                chunks
              );
            return (
              <li key={id}>
                {s.tier ? learn.rich("sourceWithTier", { title: s.title, tier: s.tier, source: link }) : link(s.title)}
              </li>
            );
          })}
        </ul>
      </section>

      <Alert variant="info" icon={<Info className="size-5" />}>
        <AlertDescription>{learn("disclaimer.general")}</AlertDescription>
      </Alert>

      <div className="print:hidden">
        <AppHandoffCard />
      </div>
    </main>
  );
}
