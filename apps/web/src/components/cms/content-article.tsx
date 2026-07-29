import { getFormatter, getTranslations } from "next-intl/server";
import type { ContentDoc } from "@/lib/cms/client";
import { RichText } from "@/lib/cms/lexical";
import { Link } from "@/i18n/navigation";
import { JsonLd } from "@/components/seo/json-ld";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { breadcrumbJsonLd, medicalWebPageJsonLd } from "@/lib/seo/jsonld";
import { siteConfig } from "@/lib/seo/config";

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

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <JsonLd
        data={medicalWebPageJsonLd({ title: doc.title, description, url, locale, lastReviewed: doc.lastReviewed })}
      />
      <JsonLd
        data={breadcrumbJsonLd([
          { name: sectionTitle, url: `${siteConfig.baseUrl}/${locale}${sectionHref}` },
          { name: doc.title, url },
        ])}
      />

      <nav className="text-sm text-text-muted">
        <Link href={sectionHref} className="text-text-link underline">
          {sectionTitle}
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
