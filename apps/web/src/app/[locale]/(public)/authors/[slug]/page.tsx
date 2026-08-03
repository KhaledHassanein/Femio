import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { getPersonBySlug, type PersonDoc } from "@/lib/cms/client";
import { lexicalToPlainText, RichText } from "@/lib/cms/lexical";
import { Link } from "@/i18n/navigation";
import { JsonLd } from "@/components/seo/json-ld";
import { Badge } from "@/components/ui/badge";
import { breadcrumbJsonLd, personJsonLd } from "@/lib/seo/jsonld";
import { siteConfig } from "@/lib/seo/config";
import { localizedAlternates } from "@/lib/seo/metadata";
import { PageView } from "@/components/analytics/page-view";

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

function summarize(person: PersonDoc): string {
  return (
    person.jobTitle || lexicalToPlainText(person.bio ?? null) || person.affiliation || person.name
  ).slice(0, 160);
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale, slug } = await params;
  const person = await getPersonBySlug(locale, slug);
  if (!person) return { title: "Not found", robots: { index: false, follow: false } };
  return {
    title: person.credentials ? `${person.name}, ${person.credentials}` : person.name,
    description: summarize(person),
    alternates: localizedAlternates(locale, `/authors/${slug}`),
  };
}

// Author / medical-reviewer bio page carrying Person schema (doc 15 §7/§8, P1.9b.3b).
export default async function AuthorPage({ params }: PageProps) {
  const { locale, slug } = await params;
  setRequestLocale(locale);
  const person = await getPersonBySlug(locale, slug);
  if (!person) notFound();
  const t = await getTranslations("authors");
  const nav = await getTranslations("nav");

  const url = `${siteConfig.baseUrl}/${locale}/authors/${person.slug}`;
  const links = (person.sameAs ?? []).filter((l) => l.url);

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-1 flex-col gap-6 px-6 py-12">
      <PageView area="library" />
      <JsonLd
        data={personJsonLd({
          name: person.name,
          url,
          description: summarize(person),
          credentials: person.credentials,
          jobTitle: person.jobTitle,
          affiliation: person.affiliation,
          sameAs: links.map((l) => l.url),
        })}
      />
      <JsonLd
        data={breadcrumbJsonLd([
          { name: t("title"), url: `${siteConfig.baseUrl}/${locale}/authors` },
          { name: person.name, url },
        ])}
      />

      <nav className="text-sm text-text-muted">
        <Link href="/authors" className="text-text-link underline">
          {t("title")}
        </Link>
      </nav>

      <div className="flex flex-col gap-2">
        <h1 className="font-display text-3xl text-text">
          {person.name}
          {person.credentials ? (
            <span className="text-text-muted">{`, ${person.credentials}`}</span>
          ) : null}
        </h1>
        <div className="flex flex-wrap items-center gap-2 text-sm text-text-muted">
          {(person.roles ?? []).map((role) => (
            <Badge key={role} variant={role === "medical_reviewer" ? "success" : "neutral"}>
              {t(`roles.${role}`)}
            </Badge>
          ))}
          {person.jobTitle ? <span>{person.jobTitle}</span> : null}
          {person.affiliation ? <span>{person.affiliation}</span> : null}
        </div>
      </div>

      {person.bio ? (
        <div className="text-md">
          <RichText content={person.bio} />
        </div>
      ) : null}

      {links.length > 0 ? (
        <section className="flex flex-col gap-2 border-t border-border pt-4">
          <h2 className="text-sm font-semibold text-text">{t("profiles")}</h2>
          <ul className="flex flex-col gap-1 text-sm text-text-muted">
            {links.map((l, i) => (
              <li key={i}>
                <a href={l.url} rel="noreferrer" target="_blank" className="text-text-link underline">
                  {l.label || l.url}
                </a>
              </li>
            ))}
          </ul>
        </section>
      ) : null}

      <nav className="flex flex-wrap gap-4 border-t border-border pt-4 text-sm">
        <Link href="/editorial-policy" className="text-text-link underline">
          {nav("editorial")}
        </Link>
        <Link href="/medical-review" className="text-text-link underline">
          {nav("medicalReview")}
        </Link>
      </nav>
    </main>
  );
}
