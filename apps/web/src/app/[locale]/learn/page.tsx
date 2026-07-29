import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { listContent } from "@/lib/cms/client";
import { Link } from "@/i18n/navigation";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

// Public content hub. Reads published articles from the CMS; renders a graceful
// empty state when the CMS is unset or has no published content yet.
export const revalidate = 300;

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "learn" });
  return {
    title: t("title"),
    description: t("subtitle"),
    alternates: localizedAlternates(locale, "/learn"),
  };
}

export default async function LearnPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("learn");
  const articles = await listContent("articles", locale);

  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-3xl text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("subtitle")}</p>
      </div>

      {articles.length > 0 ? (
        <ul className="flex flex-col gap-4">
          {articles.map((a) => (
            <li key={a.id}>
              <Link
                href={`/learn/${a.slug}`}
                className="block rounded-md border border-border p-4 hover:bg-surface-sunken"
              >
                <h2 className="font-display text-lg text-text">{a.title}</h2>
                {a.excerpt ? <p className="mt-1 text-sm text-text-muted">{a.excerpt}</p> : null}
              </Link>
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-sm text-text-muted">{t("empty")}</p>
      )}
    </main>
  );
}
