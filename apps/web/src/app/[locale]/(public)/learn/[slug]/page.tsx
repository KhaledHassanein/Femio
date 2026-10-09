import type { Metadata } from "next";
import { OG_IMAGES } from "@/lib/seo/config";
import { contentTitle, isIndexable } from "@/lib/seo/content-index";
import { notFound } from "next/navigation";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { availableLocales, getContentBySlug, allSlugs, listContent } from "@/lib/cms/client";
import { rankOf, topicOf } from "@/lib/content/topics";
import { metaDescription } from "@/lib/cms/format";
import { ContentArticle } from "@/components/cms/content-article";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string; slug: string }> };

// ISR, revalidated hourly (P0.6, 2026-10-07). This page was `force-dynamic`, so every
// view, bots included, was a serverless render plus several CMS calls, and the CMS
// was exhausting Supabase's session pool (`EMAXCONNSESSION`, hundreds a day). The
// reason it was dynamic (an unknown slug returning 500 instead of 404) is fixed twice
// over: the client-side `[locale]/not-found.tsx`, and `setRequestLocale` in the
// `(public)` layout, without which the header and footer read `headers()` during a
// cached render. Verified against the live CMS: an article goes MISS → HIT, and an
// unknown slug is a 404 in en and ar. Publishing shows up within the hour.
export const revalidate = 3600;
export const dynamicParams = true;
// Every published slug is prerendered at build: content lives in the repo snapshot,
// so building it costs no request to anything (D3 step 1).
export function generateStaticParams() {
  return allSlugs("articles").map((slug) => ({ slug }));
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const doc = await getContentBySlug("articles", locale, slug);
  if (!doc) return { title: "Not found", robots: { index: false, follow: false } };
  // CMS overrides win where an editor filled them; the page's own copy is the
  // fallback, so an unfilled field never yields an empty tag (P1.6.6).
  const seo = doc.seo ?? {};
  // Payload falls back to English for an untranslated locale, so /ar/… renders English.
  // Good for a reader who lands there, bad for search: indexing it would publish the
  // same article three more times as "Arabic", "French" and "Spanish" (P1.6.15).
  const available = await availableLocales("articles", slug);
  const translated = available.includes(locale);
  return {
    title: contentTitle(doc),
    description: seo.metaDescription || metaDescription(doc),
    alternates: seo.canonicalOverride
      ? { canonical: seo.canonicalOverride }
      : localizedAlternates(locale, `/learn/${slug}`, available),
    ...(isIndexable(doc, translated) ? {} : { robots: { index: false, follow: true } }),
    openGraph: {
      images: [...OG_IMAGES],
      title: seo.socialTitle || contentTitle(doc),
      description: seo.socialDescription || seo.metaDescription || metaDescription(doc),
    },
  };
}

export default async function ArticlePage({ params }: PageProps) {
  const { locale, slug } = await params;
  setRequestLocale(locale);
  const doc = await getContentBySlug("articles", locale, slug);
  if (!doc) notFound();
  // Which language the text is really in (English is the fallback for every locale).
  const contentLocale = (await availableLocales("articles", slug)).includes(locale) ? locale : "en";
  const t = await getTranslations("learn");
  const hub = await getTranslations("learnHub");
  const topic = topicOf(slug);
  // "Read next": the nearest guides in the same topic, in the hub's own order, so a
  // week-by-week page leads to the next week and a TTC guide to the next TTC guide.
  const siblings = (await listContent("articles", locale, { fields: ["slug", "title"] }))
    .filter((d) => d.slug !== slug && topicOf(d.slug) === topic)
    .sort((a, b) => rankOf(a.slug) - rankOf(b.slug));
  const after = siblings.filter((d) => rankOf(d.slug) > rankOf(slug));
  const related = [...after, ...siblings.filter((d) => !after.includes(d))]
    .slice(0, 3)
    .map((d) => ({ slug: d.slug, title: d.title, topic }));

  return (
    <ContentArticle
      doc={doc}
      locale={locale}
      sectionTitle={t("title")}
      sectionHref="/learn"
      description={metaDescription(doc)}
      contentLocale={contentLocale}
      topic={
        topic === "more"
          ? undefined
          : { key: topic, label: hub(`topics.${topic}`), href: `/learn#${topic}` }
      }
      related={related}
    />
  );
}
