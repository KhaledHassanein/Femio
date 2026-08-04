import { getFormatter, getTranslations } from "next-intl/server";
import type { ContentDoc } from "@/lib/cms/client";
import { RichText } from "@/lib/cms/lexical";
import { Link } from "@/i18n/navigation";
import type { Byline } from "@/lib/cms/client";
import { JsonLd } from "@/components/seo/json-ld";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { articleJsonLd, breadcrumbJsonLd, faqPageJsonLd, medicalWebPageJsonLd } from "@/lib/seo/jsonld";
import { extractFaqs } from "@/lib/cms/faq";
import { siteConfig } from "@/lib/seo/config";
import { PageView } from "@/components/analytics/page-view";

// Shared renderer for a single CMS content doc (articles, conditions, …). The
// common editorial chrome (reviewed badge, sources, disclaimer) lives in the
// `learn` message namespace; the calling page supplies its own section
// title/href for the breadcrumb + back link.
export async function ContentArticle({
  doc,
  locale,
  sectionTitle,
  sectionHref,
  description,
}: {
  doc: ContentDoc;
  locale: string;
  sectionTitle: string;
  sectionHref: string; // locale-less, e.g. "/conditions"
  description: string;
}) {
  const t = await getTranslations("learn");
  const format = await getFormatter();
  const disclaimer =
    doc.disclaimerType && doc.disclaimerType !== "none" ? t(`disclaimer.${doc.disclaimerType}`) : null;
  const url = `${siteConfig.baseUrl}/${locale}${sectionHref}/${doc.slug}`;
  const faqs = extractFaqs(doc.body);

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <PageView area="library" />
      <JsonLd
        data={medicalWebPageJsonLd({ title: doc.title, description, url, locale, lastReviewed: doc.lastReviewed })}
      />
      <JsonLd
        data={articleJsonLd({
          headline: doc.title,
          description,
          url,
          locale,
          authors: (doc.authors ?? []).map((a) => ({
            name: a.name,
            credentials: a.credentials,
            url: `${siteConfig.baseUrl}/${locale}/authors/${a.slug}`,
          })),
          reviewer: doc.medicalReviewerProfile
            ? {
                name: doc.medicalReviewerProfile.name,
                credentials: doc.medicalReviewerProfile.credentials,
                url: `${siteConfig.baseUrl}/${locale}/authors/${doc.medicalReviewerProfile.slug}`,
              }
            : null,
          datePublished: doc.firstPublishedAt,
          dateModified: doc.updatedAt,
        })}
      />
      <JsonLd
        data={breadcrumbJsonLd([
          { name: sectionTitle, url: `${siteConfig.baseUrl}/${locale}${sectionHref}` },
          { name: doc.title, url },
        ])}
      />
      {/* FAQPage is what earns the expandable FAQ result in search. Every authored
          article carries a Q&A section and none of it was reaching Google. Emitted only
          when the body actually contains pairs, so a page without an FAQ never claims one. */}
      {faqs.length > 0 ? <JsonLd data={faqPageJsonLd(faqs)} /> : null}

      <nav className="text-sm text-text-muted">
        <Link href={sectionHref} className="text-text-link underline">
          {sectionTitle}
        </Link>
      </nav>

      <div className="flex flex-col gap-2">
        <h1 className="font-display text-3xl text-text">{doc.title}</h1>
        <Byline authors={doc.authors ?? []} reviewer={doc.medicalReviewerProfile ?? null} />
        {/* Boundary first, guidance second: a reader should know what this is
            before she acts on it, not after (health product, not a medical one). */}
        <p className="text-sm text-text-subtle">{t("boundaryNote")}</p>
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

/**
 * Named author + named clinician reviewer, each linked to their bio (doc 15 §8).
 * Renders nothing until the CMS has people attached, so an article published
 * before its bios exist degrades to the reviewed badge rather than to "By ,".
 */
async function Byline({ authors, reviewer }: { authors: Byline[]; reviewer: Byline | null }) {
  const t = await getTranslations("learn");
  if (authors.length === 0 && !reviewer) return null;

  const name = (p: Byline) => (p.credentials ? `${p.name}, ${p.credentials}` : p.name);

  return (
    <p className="flex flex-wrap items-center gap-x-2 gap-y-1 text-sm text-text-muted">
      {authors.length > 0 ? (
        <span>
          {t("byline")}{" "}
          {authors.map((a, i) => (
            <span key={a.slug}>
              {i > 0 ? ", " : ""}
              <Link href={`/authors/${a.slug}`} className="text-text-link underline">
                {name(a)}
              </Link>
            </span>
          ))}
        </span>
      ) : null}
      {reviewer ? (
        <span>
          {t("reviewedBy")}{" "}
          <Link href={`/authors/${reviewer.slug}`} className="text-text-link underline">
            {name(reviewer)}
          </Link>
        </span>
      ) : null}
    </p>
  );
}
