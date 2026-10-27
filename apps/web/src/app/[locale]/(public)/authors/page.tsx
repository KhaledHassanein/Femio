import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { listPeople } from "@/lib/cms/client";
import { Link } from "@/i18n/navigation";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

export const revalidate = 3600; // content changes only with a deploy now (repo snapshot, D3)

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "authors" });
  return {
    title: t("title"),
    description: t("subtitle"),
    alternates: localizedAlternates(locale, "/authors"),
  };
}

// Authors & medical reviewers index (P1.9b.3b). Empty until the first bios are
// published in the CMS alongside the P1.9 articles — the empty state says so
// rather than showing a broken page.
export default async function AuthorsPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("authors");
  const nav = await getTranslations("nav");
  const people = await listPeople(locale);

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-1 flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-3xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("subtitle")}</p>
      </div>

      {people.length > 0 ? (
        <ul className="flex flex-col gap-4">
          {people.map((person) => (
            <li key={person.id}>
              <Link
                href={`/authors/${person.slug}`}
                className="block rounded-md border border-border p-4 hover:bg-surface-sunken"
              >
                <h2 className="font-display text-lg text-text">
                  {person.name}
                  {person.credentials ? (
                    <span className="text-text-muted">{`, ${person.credentials}`}</span>
                  ) : null}
                </h2>
                {person.jobTitle ? (
                  <p className="mt-1 text-sm text-text-muted">{person.jobTitle}</p>
                ) : null}
              </Link>
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-sm text-text-muted">{t("empty")}</p>
      )}

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
