import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { getContentBySlug } from "@/lib/cms/client";
import { metaDescription } from "@/lib/cms/format";
import { ContentArticle } from "@/components/cms/content-article";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string; slug: string }> };

export const revalidate = 300;
export const dynamicParams = true;
export function generateStaticParams() {
  return [];
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const doc = await getContentBySlug("articles", locale, slug);
  if (!doc) return { title: "Not found", robots: { index: false, follow: false } };
  return {
    title: doc.title,
    description: metaDescription(doc),
    alternates: localizedAlternates(locale, `/learn/${slug}`),
  };
}

export default async function ArticlePage({ params }: PageProps) {
  const { locale, slug } = await params;
  setRequestLocale(locale);
  const doc = await getContentBySlug("articles", locale, slug);
  if (!doc) notFound();
  const t = await getTranslations("learn");

  return (
    <ContentArticle
      doc={doc}
      locale={locale}
      sectionTitle={t("title")}
      sectionHref="/learn"
      description={metaDescription(doc)}
    />
  );
}
