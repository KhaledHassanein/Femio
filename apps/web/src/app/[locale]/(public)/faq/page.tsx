import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { listContent } from "@/lib/cms/client";
import { RichText, lexicalToPlainText } from "@/lib/cms/lexical";
import { JsonLd } from "@/components/seo/json-ld";
import { faqPageJsonLd } from "@/lib/seo/jsonld";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

export const revalidate = 3600; // content changes only with a deploy now (repo snapshot, D3)

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "faq" });
  return { title: t("title"), description: t("subtitle"), alternates: localizedAlternates(locale, "/faq") };
}

export default async function FaqPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("faq");
  const faqs = await listContent("faqs", locale);

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      {faqs.length > 0 ? (
        <JsonLd
          data={faqPageJsonLd(
            faqs.map((f) => ({ question: f.question ?? "", answer: lexicalToPlainText(f.answer ?? null) })),
          )}
        />
      ) : null}

      <div className="flex flex-col gap-1">
        <h1 className="font-display text-3xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("subtitle")}</p>
      </div>

      {faqs.length > 0 ? (
        <dl className="flex flex-col gap-6">
          {faqs.map((f) => (
            <div key={f.id} className="flex flex-col gap-2 border-b border-border pb-6 last:border-0">
              <dt className="font-display text-lg text-text">{f.question}</dt>
              <dd className="text-md">
                <RichText content={f.answer ?? null} />
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
