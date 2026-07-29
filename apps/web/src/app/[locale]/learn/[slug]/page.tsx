import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getFormatter, getTranslations, setRequestLocale } from "next-intl/server";
import { getContentBySlug } from "@/lib/cms/client";
import { lexicalToPlainText, RichText } from "@/lib/cms/lexical";
import { Link } from "@/i18n/navigation";
import { JsonLd } from "@/components/seo/json-ld";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { breadcrumbJsonLd, medicalWebPageJsonLd } from "@/lib/seo/jsonld";
import { localizedAlternates } from "@/lib/seo/metadata";
import { siteConfig } from "@/lib/seo/config";

type PageProps = { params: Promise<{ locale: string; slug: string }> };

// Content pages render on demand and cache (ISR); no build-time list needed since
// the CMS may be empty at build.
export const revalidate = 300;
export const dynamicParams = true;
export function generateStaticParams() {
  return [];
}

function description(doc: { excerpt?: string | null; body?: Parameters<typeof lexicalToPlainText>[0] }) {
  return (doc.excerpt || lexicalToPlainText(doc.body ?? null)).slice(0, 160);
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const doc = await getContentBySlug("articles", locale, slug);
  if (!doc) return { title: "Not found", robots: { index: false, follow: false } };
  return {
    title: doc.title,
    description: description(doc),
    alternates: localizedAlternates(locale, `/learn/${slug}`),
  };
}

export default async function ArticlePage({ params }: PageProps) {
  const { locale, slug } = await params;
  setRequestLocale(locale);
  const doc = await getContentBySlug("articles", locale, slug);
  if (!doc) notFound();

  const t = await getTranslations("learn");
  const format = await getFormatter();
  const disclaimer =
    doc.disclaimerType && doc.disclaimerType !== "none" ? t(`disclaimer.${doc.disclaimerType}`) : null;
  const url = `${siteConfig.baseUrl}/${locale}/learn/${slug}`;

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <JsonLd
        data={medicalWebPageJsonLd({
          title: doc.title,
          description: description(doc),
          url,
          locale,
          lastReviewed: doc.lastReviewed,
        })}
      />
      <JsonLd
        data={breadcrumbJsonLd([
          { name: t("title"), url: `${siteConfig.baseUrl}/${locale}/learn` },
          { name: doc.title, url },
        ])}
      />

      <nav className="text-sm text-text-muted">
        <Link href="/learn" className="text-text-link underline">
          {t("title")}
        </Link>
      </nav>

      <div className="flex flex-col gap-2">
        <h1 className="font-display text-3xl text-text">{doc.title}</h1>
        <div className="flex flex-wrap items-center gap-2 text-sm text-text-muted">
          <Badge variant="success">{t("reviewed")}</Badge>
          {doc.lastReviewed ? (
            <span>
              {t("lastReviewed", {
                date: format.dateTime(new Date(doc.lastReviewed), { dateStyle: "medium" }),
              })}
            </span>
          ) : null}
        </div>
      </div>

      <article className="text-md">
        <RichText content={doc.body ?? null} />
      </article>

      {disclaimer ? (
        <Alert variant={doc.disclaimerType === "emergency" ? "danger" : "info"}>
          <AlertDescription>{disclaimer}</AlertDescription>
        </Alert>
      ) : null}

      {doc.sources && doc.sources.length > 0 ? (
        <section className="flex flex-col gap-2 border-t border-border pt-4">
          <h2 className="text-sm font-semibold text-text">{t("sources")}</h2>
          <ul className="flex flex-col gap-1 text-sm text-text-muted">
            {doc.sources.map((s, i) => (
              <li key={i}>
                {s.url ? (
                  <a href={s.url} rel="noreferrer" target="_blank" className="text-text-link underline">
                    {s.title}
                  </a>
                ) : (
                  s.title
                )}
                {s.tier ? ` · ${t("tier", { tier: s.tier })}` : ""}
              </li>
            ))}
          </ul>
        </section>
      ) : null}

      <p className="text-2xs text-text-subtle">{t("footerNote")}</p>
    </main>
  );
}
