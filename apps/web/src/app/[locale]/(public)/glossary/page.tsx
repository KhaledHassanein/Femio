import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { listContent } from "@/lib/cms/client";
import { RichText, lexicalToPlainText } from "@/lib/cms/lexical";
import { JsonLd } from "@/components/seo/json-ld";
import { definedTermSetJsonLd } from "@/lib/seo/jsonld";
import { localizedAlternates } from "@/lib/seo/metadata";
import { siteConfig } from "@/lib/seo/config";
import { PageView } from "@/components/analytics/page-view";

type PageProps = { params: Promise<{ locale: string }> };

export const revalidate = 300;

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "glossary" });
  return { title: t("title"), description: t("subtitle"), alternates: localizedAlternates(locale, "/glossary") };
}

export default async function GlossaryPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("glossary");
  const terms = [...(await listContent("glossary", locale))].sort((a, b) =>
    (a.term ?? "").localeCompare(b.term ?? "", locale),
  );

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <PageView area="library" />
      {terms.length > 0 ? (
        <JsonLd
          data={definedTermSetJsonLd({
            name: t("title"),
            url: `${siteConfig.baseUrl}/${locale}/glossary`,
            terms: terms.map((g) => ({ term: g.term ?? "", definition: lexicalToPlainText(g.definition ?? null) })),
          })}
        />
      ) : null}

      <div className="flex flex-col gap-1">
        <h1 className="font-display text-3xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("subtitle")}</p>
      </div>

      {terms.length > 0 ? (
        <dl className="flex flex-col gap-5">
          {terms.map((g) => (
            <div key={g.id} id={g.slug} className="flex flex-col gap-1 border-b border-border pb-5 last:border-0">
              <dt className="font-display text-lg text-text">{g.term}</dt>
              <dd className="text-sm text-text-muted">
                <RichText content={g.definition ?? null} />
              </dd>
            </div>
          ))}
        </dl>
      ) : (
        <p className="text-sm text-text-muted">{t("empty")}</p>
      )}
    </main>
  );
}
