import type { ReactNode } from "react";
import { getFormatter, getTranslations } from "next-intl/server";
import type { ContentDoc } from "@/lib/cms/client";
import { RichTextNodes, splitAfterFirstSection } from "@/lib/cms/lexical";
import { AdSenseScript } from "@/lib/ads/adsense-script";
import { AdUnit } from "@/lib/ads/ad-unit";
import { adUnitConfig } from "@/lib/ads/placements";
import { env } from "@/lib/env";
import { Link } from "@/i18n/navigation";
import type { Byline } from "@/lib/cms/client";
import { JsonLd } from "@/components/seo/json-ld";
import { BadgeCheck } from "lucide-react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { AppHandoffCard } from "@/components/site/app-handoff-card";
import {
  articleJsonLd,
  breadcrumbJsonLd,
  faqPageJsonLd,
  medicalWebPageJsonLd,
} from "@/lib/seo/jsonld";
import { extractFaqs } from "@/lib/cms/faq";
import { siteConfig } from "@/lib/seo/config";

// Shared renderer for a single CMS content doc (articles, conditions, …). The
// common editorial chrome (review line, sources, disclaimer) lives in the
// `learn` message namespace; the calling page supplies its own section
// title/href for the breadcrumb + back link. Every page ends with the app hand-off
// card (02_DESIGN_SPEC §2.12), and the review line is honest by construction:
// a named reviewer gets "Reviewed by <name>, <date>"; everything else says the
// clinician review is still pending (01_PRODUCT_SCOPE D-07).
export async function ContentArticle({
  doc,
  locale,
  sectionTitle,
  sectionHref,
  description,
  contentLocale = locale,
}: {
  doc: ContentDoc;
  locale: string;
  sectionTitle: string;
  sectionHref: string; // locale-less, e.g. "/conditions"
  description: string;
  /**
   * The language the document's text is actually in. Payload falls back to English
   * for an untranslated locale, so on `/ar/learn/…` the prose can be English inside
   * an RTL page. Without `lang` + `dir` on the content, English sentences were laid
   * out right-to-left and their full stops jumped to the start of the line
   * (".or doctor"), seen in the v3 checkpoint photos.
   */
  contentLocale?: string;
}) {
  const t = await getTranslations("learn");
  const tAds = await getTranslations("ads");
  // R6.8: two placements, each rendered only when its slot and the publisher id are set.
  // The mid unit sits between the first H2 section and the second H2; a body with one
  // section renders in one piece and gets no mid unit.
  const midAd = adUnitConfig("article-mid");
  const endAd = adUnitConfig("article-end");
  const { head, rest } = midAd ? splitAfterFirstSection(doc.body ?? null) : { head: doc.body?.root?.children ?? [], rest: [] };
  const disclaimer =
    doc.disclaimerType && doc.disclaimerType !== "none"
      ? t(`disclaimer.${doc.disclaimerType}`)
      : null;
  const url = `${siteConfig.baseUrl}/${locale}${sectionHref}/${doc.slug}`;
  const faqs = extractFaqs(doc.body);
  const fallback = contentLocale !== locale;
  const sourceLabel = (s: NonNullable<ContentDoc["sources"]>[number], label: ReactNode) =>
    s.url ? (
      <a href={s.url} rel="noreferrer" target="_blank" className="text-text-link underline">
        {label}
      </a>
    ) : (
      label
    );
  // Only the document's own text changes direction; the page chrome stays in hers.
  const contentAttrs = fallback
    ? { lang: contentLocale, dir: contentLocale === "ar" ? ("rtl" as const) : ("ltr" as const) }
    : {};

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <JsonLd
        data={medicalWebPageJsonLd({
          title: doc.title,
          description,
          url,
          locale,
          // Only a named reviewer makes a review date true. `lastReviewed` is set on
          // unreviewed articles too (it is the import date there), so it must not be
          // published to search engines as a review.
          lastReviewed: doc.medicalReviewerProfile ? doc.lastReviewed : null,
        })}
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
        {fallback ? (
          <p className="w-fit rounded-pill bg-surface-sunken px-3 py-1 text-2xs text-text-muted">
            {t("englishOnly")}
          </p>
        ) : null}
        <h1 {...contentAttrs} className="font-display text-3xl text-text">
          {doc.title}
        </h1>
        <Byline authors={doc.authors ?? []} />
        {/* Boundary first, guidance second: a reader should know what this is
            before she acts on it, not after (health product, not a medical one). */}
        <p className="text-sm text-text-subtle">{t("boundaryNote")}</p>
        <ReviewLine doc={doc} locale={locale} />
      </div>

      <article {...contentAttrs} className="text-md">
        <RichTextNodes nodes={head} />
        {midAd && rest.length > 0 ? (
          <div className="my-6">
            <AdUnit config={midAd} label={tAds("label")} />
          </div>
        ) : null}
        {rest.length > 0 ? <RichTextNodes nodes={rest} /> : null}
      </article>

      {disclaimer ? (
        <Alert variant={doc.disclaimerType === "emergency" ? "danger" : "info"}>
          <AlertDescription>{disclaimer}</AlertDescription>
        </Alert>
      ) : null}

      {doc.sources && doc.sources.length > 0 ? (
        <section className="flex flex-col gap-2 border-t border-border pt-4">
          <h2 className="text-sm font-semibold text-text">{t("sources")}</h2>
          {/* Source titles are English in every locale (they are the guidelines' own titles). */}
          <ul lang="en" dir="ltr" className="flex flex-col gap-1 text-sm text-text-muted">
            {doc.sources.map((s, i) => (
              <li key={i}>
                {s.tier
                  ? t.rich("sourceWithTier", {
                      title: s.title,
                      tier: s.tier,
                      source: (chunks) => sourceLabel(s, chunks),
                    })
                  : sourceLabel(s, s.title)}
              </li>
            ))}
          </ul>
        </section>
      ) : null}

      {/* R6.8: the end unit follows the sources and precedes the hand-off, so no ad ever
          sits between the reader and the article's own evidence. */}
      <AdUnit config={endAd} label={tAds("label")} />
      {(midAd || endAd) && <AdSenseScript client={env.NEXT_PUBLIC_ADSENSE_CLIENT} />}

      <AppHandoffCard id="article-handoff" />

      <p className="text-2xs text-text-subtle">{t("footerNote")}</p>
    </main>
  );
}

/**
 * The honest review line (01_PRODUCT_SCOPE D-07, report 07 §9).
 *
 * - A named reviewer: "Reviewed by <name>, <date>", the name linked to the bio. The
 *   date is the document's `lastReviewed`; without a date the line is the name alone.
 * - No named reviewer: "Editorially checked · clinician review pending" (neutral
 *   pill). It never says a clinician reviewed it, and it does not show `lastReviewed`
 *   as a review date (on these articles that field is the import date), only the
 *   last-updated date.
 *
 * ## On a translated page it says the review was of the English (R3.8)
 *
 * Approval is not a localised field, so a translation inherits the reviewer the
 * moment it is written. The clinical substance was reviewed, and re-reviewing a
 * faithful translation is not what a reviewer's time is for. What does not follow is
 * "Reviewed by Dr X" under Arabic prose Dr X has never read: a claim about a named
 * real person's endorsement. So on any non-English page the label says the review was
 * of the English text. Same reviewer, same link, described accurately.
 */
async function ReviewLine({ doc, locale }: { doc: ContentDoc; locale: string }) {
  const t = await getTranslations("learn");
  const format = await getFormatter();
  const reviewer = doc.medicalReviewerProfile ?? null;
  const fmt = (iso: string) => format.dateTime(new Date(iso), { dateStyle: "medium" });

  if (reviewer) {
    const person = (chunks: ReactNode) => (
      <Link href={`/authors/${reviewer.slug}`} className="text-text-link underline">
        {chunks}
      </Link>
    );
    const name = personName(t, reviewer);
    // Plain text beside a check icon, not a coloured pill: the link inside keeps the
    // page's link colour on the page background, where its contrast is known.
    return (
      <p className="flex items-center gap-2 text-sm text-text-muted">
        <BadgeCheck className="size-4 shrink-0 text-success-text" aria-hidden />
        <span>
          {doc.lastReviewed
            ? t.rich(locale === "en" ? "reviewedByOn" : "reviewedInEnglishByOn", {
                name,
                person,
                date: fmt(doc.lastReviewed),
              })
            : t.rich(locale === "en" ? "reviewedByName" : "reviewedInEnglishByName", {
                name,
                person,
              })}
        </span>
      </p>
    );
  }

  return (
    <p className="flex flex-wrap items-center gap-2 text-sm text-text-muted">
      <Badge variant="neutral">{t("editoriallyChecked")}</Badge>
      {doc.updatedAt ? <span>{t("lastUpdated", { date: fmt(doc.updatedAt) })}</span> : null}
    </p>
  );
}

/** "Name, credentials" through the catalogue, so each language owns its punctuation. */
function personName(
  t: (key: "nameWithCredentials", values: { name: string; credentials: string }) => string,
  p: Byline,
): string {
  return p.credentials ? t("nameWithCredentials", { name: p.name, credentials: p.credentials }) : p.name;
}

/**
 * Named authors, each linked to their bio (doc 15 §8). Renders nothing until the CMS
 * has authors attached, so an article published before its bios exist degrades to
 * the review line rather than to "By ,". Names are joined by the locale's own list
 * format (Intl.ListFormat), so Arabic gets its conjunction and comma, not an ASCII ", ".
 */
async function Byline({ authors }: { authors: Byline[] }) {
  const t = await getTranslations("learn");
  const format = await getFormatter();
  if (authors.length === 0) return null;

  const links = authors.map((a) => (
    <Link key={a.slug} href={`/authors/${a.slug}`} className="text-text-link underline">
      {personName(t, a)}
    </Link>
  ));

  return (
    <p className="text-sm text-text-muted">
      {t("byline")} {format.list(links)}
    </p>
  );
}
