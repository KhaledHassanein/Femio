import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { getContentBySlug } from "@/lib/cms/client";
import { metaDescription } from "@/lib/cms/format";
import { ContentArticle } from "@/components/cms/content-article";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string; slug: string }> };

// Rendered per-request, not ISR. `notFound()` thrown during a static/ISR render
// makes next-intl resolve the locale from `headers()` in the not-found pass — a
// dynamic API, illegal there — so every unknown slug returned **500 instead of
// 404** in production (dev renders dynamically, which is why it looked fine).
// The CMS fetch keeps its own 5-minute cache, so this costs HTML assembly, not
// round-trips. Revisit when next-intl v4 lands (P1.23.2).
export const dynamic = "force-dynamic";
export const dynamicParams = true;
export function generateStaticParams() {
  return [];
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const doc = await getContentBySlug("articles", locale, slug);
  if (!doc) return { title: "Not found", robots: { index: false, follow: false } };
  // CMS overrides win where an editor filled them; the page's own copy is the
  // fallback, so an unfilled field never yields an empty tag (P1.6.6).
  const seo = doc.seo ?? {};
  return {
    title: seo.seoTitle || doc.title,
    description: seo.metaDescription || metaDescription(doc),
    alternates: seo.canonicalOverride
      ? { canonical: seo.canonicalOverride }
      : localizedAlternates(locale, `/learn/${slug}`),
    ...(seo.noIndex ? { robots: { index: false, follow: true } } : {}),
    openGraph: {
      title: seo.socialTitle || seo.seoTitle || doc.title,
      description: seo.socialDescription || seo.metaDescription || metaDescription(doc),
    },
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
