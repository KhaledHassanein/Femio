import { getFormatter, getLocale, getTranslations } from "next-intl/server";
import type { ContentDoc } from "@/lib/cms/client";
import { RichText, outlineOf, readingMinutes } from "@/lib/cms/lexical";
import { Link } from "@/i18n/navigation";
import type { Byline } from "@/lib/cms/client";
import { JsonLd } from "@/components/seo/json-ld";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import {
  articleJsonLd,
  breadcrumbJsonLd,
  faqPageJsonLd,
  medicalWebPageJsonLd,
} from "@/lib/seo/jsonld";
import { extractFaqs } from "@/lib/cms/faq";
import { siteConfig } from "@/lib/seo/config";
import { PageView } from "@/components/analytics/page-view";
import { TopicArt } from "@/components/learn/topic-art";
import type { Topic } from "@/lib/content/topics";
import { Button } from "@/components/ui/button";

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
  contentLocale = locale,
  topic,
  related = [],
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
  /** The Learn topic it belongs to: the eyebrow link and the cover art's palette. */
  topic?: { key: Topic; label: string; href: string };
  /** Up to three guides from the same topic, for "Read next". */
  related?: { slug: string; title: string; topic: Topic }[];
}) {
  const t = await getTranslations("learn");
  const format = await getFormatter();
  const disclaimer =
    doc.disclaimerType && doc.disclaimerType !== "none"
      ? t(`disclaimer.${doc.disclaimerType}`)
      : null;
  const url = `${siteConfig.baseUrl}/${locale}${sectionHref}/${doc.slug}`;
  const faqs = extractFaqs(doc.body);
  const outline = outlineOf(doc.body ?? null);
  const minutes = readingMinutes(doc.body ?? null);
  const fallback = contentLocale !== locale;
  // Only the document's own text changes direction; the page chrome stays in hers.
  const contentAttrs = fallback
    ? { lang: contentLocale, dir: contentLocale === "ar" ? ("rtl" as const) : ("ltr" as const) }
    : {};

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <PageView area="library" />
      <JsonLd
        data={medicalWebPageJsonLd({
          title: doc.title,
          description,
          url,
          locale,
          lastReviewed: doc.lastReviewed,
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

      {topic ? (
        <TopicArt topic={topic.key} slug={doc.slug} className="article-cover" />
      ) : null}

      <header className="flex flex-col gap-3">
        <nav className="flex flex-wrap items-center gap-x-2 text-sm text-text-muted">
          <Link href={sectionHref} className="text-text-link underline">
            {sectionTitle}
          </Link>
          {topic ? (
            <>
              <span aria-hidden>·</span>
              <Link href={topic.href} className="text-text-link underline">
                {topic.label}
              </Link>
            </>
          ) : null}
          <span aria-hidden>·</span>
          <span>{t("readingTime", { minutes })}</span>
        </nav>
        {fallback ? (
          <p className="w-fit rounded-pill bg-surface-sunken px-3 py-1 text-2xs text-text-muted">
            {t("englishOnly")}
          </p>
        ) : null}
        {/* 48px on a 390px phone was four lines and the whole first screen; the answer
            the brief puts first (§4) now starts above the fold. */}
        <h1 {...contentAttrs} className="font-display text-2xl text-text md:text-3xl">
          {doc.title}
        </h1>

        {/* Trust in one place: who wrote and reviewed it, that it was reviewed, when,
            and what it is not. It was four loose lines, with the same doctor twice. */}
        <div className="flex flex-col gap-2.5 rounded-lg border border-border bg-surface p-4">
          <Byline authors={doc.authors ?? []} reviewer={doc.medicalReviewerProfile ?? null} />
          <div className="flex flex-wrap items-center gap-2 text-xs text-text-muted">
            {/* "Clinician reviewed" only where a clinician is named: 75 of 100 guides
                showed it with nobody behind it (public audit F06, 2026-10-09). */}
            {doc.medicalReviewerProfile ? (
              <Badge variant="success">{t("reviewed")}</Badge>
            ) : (
              <Badge variant="neutral">{t("reviewPending")}</Badge>
            )}
            {doc.lastReviewed ? (
              <span>
                {t(doc.medicalReviewerProfile ? "lastReviewed" : "updated", {
                  date: format.dateTime(new Date(doc.lastReviewed), { dateStyle: "medium" }),
                })}
              </span>
            ) : null}
          </div>
          {/* Boundary first, guidance second: a reader should know what this is
              before she acts on it, not after (health product, not a medical one). */}
          <p className="text-xs text-text-subtle">{t("boundaryNote")}</p>
        </div>

        {outline.length >= 3 ? (
          <details className="group rounded-lg border border-border bg-surface px-4 py-3">
            <summary className="cursor-pointer list-none text-sm font-semibold text-text marker:hidden">
              {t("contents")} <span className="text-text-muted">({outline.length})</span>
            </summary>
            <ol {...contentAttrs} className="mt-3 flex list-decimal flex-col gap-1.5 ps-5 text-sm">
              {outline.map((h) => (
                <li key={h.id}>
                  <a href={`#${h.id}`} className="text-text-link underline">
                    {h.text}
                  </a>
                </li>
              ))}
            </ol>
          </details>
        ) : null}
      </header>

      <article {...contentAttrs} className="text-md">
        <RichText content={doc.body ?? null} />
      </article>

      {disclaimer ? (
        <Alert variant={doc.disclaimerType === "emergency" ? "danger" : "info"}>
          <AlertDescription>{disclaimer}</AlertDescription>
        </Alert>
      ) : null}

      {/* The website's job is to bring her to the app (D8): every guide ends with the
          next guide to read and one plain way to keep track, never a pop-up. */}
      <section className="flex flex-col gap-4 rounded-xl bg-[var(--aurora-ground)] p-6 text-text-on-brand">
        <h2 className="font-display text-xl">{t("appTitle")}</h2>
        <p className="text-sm opacity-90">{t("appBody")}</p>
        <Button asChild variant="accent" className="w-fit">
          <Link href="/app">{t("appCta")}</Link>
        </Button>
      </section>

      {related.length > 0 ? (
        <section className="flex flex-col gap-3">
          <h2 className="font-display text-xl text-text">{t("readNext")}</h2>
          <ul className="flex flex-col gap-3">
            {related.map((r) => (
              <li key={r.slug}>
                <Link
                  href={`/learn/${r.slug}`}
                  className="flex items-center gap-4 overflow-hidden rounded-lg border border-border bg-surface pe-4 transition-shadow duration-fast hover:shadow-md"
                >
                  <TopicArt topic={r.topic} slug={r.slug} className="article-related-art" />
                  <span dir="auto" className="font-display text-md leading-snug text-text">
                    {r.title}
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </section>
      ) : null}

      {doc.sources && doc.sources.length > 0 ? (
        <section className="flex flex-col gap-2 border-t border-border pt-4">
          <h2 className="text-sm font-semibold text-text">{t("sources")}</h2>
          {/* Source titles are English in every locale (they are the guidelines' own titles). */}
          <ul lang="en" dir="ltr" className="flex flex-col gap-1 text-sm text-text-muted">
            {doc.sources.map((s, i) => (
              <li key={i}>
                {s.url ? (
                  <a
                    href={s.url}
                    rel="noreferrer"
                    target="_blank"
                    className="text-text-link underline"
                  >
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
 *
 * ## On a translated page it says the review was of the English (R3.8)
 *
 * Approval is not a localised field — `review_status`, `medical_reviewer_id` and
 * `last_reviewed` live on the parent row, so a translation inherits them the
 * moment it is written. That is the intended behaviour and it is the owner's
 * call: the clinical substance was reviewed, and re-reviewing a faithful
 * translation of it is not what the two reviewers' time is for.
 *
 * What does not follow is the sentence "Reviewed by Dr X" sitting under Arabic
 * prose Dr X has never read. That is a claim about a **named real person's**
 * professional endorsement, and it is the one part of this that is not Femio's
 * to assert. So on any non-English rendering the label changes to say the review
 * was of the English text. Same reviewer, same link, same authority — described
 * accurately, at no cost to anyone.
 */
async function Byline({ authors, reviewer }: { authors: Byline[]; reviewer: Byline | null }) {
  const t = await getTranslations("learn");
  const locale = await getLocale();
  if (authors.length === 0 && !reviewer) return null;

  const name = (p: Byline) => (p.credentials ? `${p.name}, ${p.credentials}` : p.name);
  const link = (p: Byline) => (
    <Link href={`/authors/${p.slug}`} className="text-text-link underline">
      {/* Isolated, so a Latin name and its commas keep their order inside Arabic. */}
      <bdi>{name(p)}</bdi>
    </Link>
  );
  const initials = (reviewer ?? authors[0]!).name
    .replace(/^(Dr\.?|د\.)\s*/i, "")
    .split(/\s+/)
    .slice(0, 2)
    .map((w) => w.charAt(0))
    .join("");

  // One person who wrote and reviewed it is one line, not the same name twice.
  if (reviewer && authors.length === 1 && authors[0]!.slug === reviewer.slug) {
    return (
      <p className="flex items-center gap-3 text-sm text-text-muted">
        <span
          aria-hidden
          className="flex size-10 shrink-0 items-center justify-center rounded-full bg-primary-soft font-semibold text-primary-soft-text"
        >
          {initials}
        </span>
        <span>
          {t(locale === "en" ? "writtenAndReviewedBy" : "writtenAndReviewedInEnglishBy")} {link(reviewer)}
        </span>
      </p>
    );
  }

  return (
    <p className="flex flex-wrap items-center gap-x-2 gap-y-1 text-sm text-text-muted">
      {authors.length > 0 ? (
        <span>
          {t("byline")}{" "}
          {authors.map((a, i) => (
            <span key={a.slug}>
              {i > 0 ? ", " : ""}
              <Link href={`/authors/${a.slug}`} className="text-text-link underline">
                <bdi>{name(a)}</bdi>
              </Link>
            </span>
          ))}
        </span>
      ) : null}
      {reviewer ? (
        <span>
          {t(locale === "en" ? "reviewedBy" : "reviewedInEnglishBy")}{" "}
          <Link href={`/authors/${reviewer.slug}`} className="text-text-link underline">
            <bdi>{name(reviewer)}</bdi>
          </Link>
        </span>
      ) : null}
    </p>
  );
}
