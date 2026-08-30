import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";

import { SearchScreen } from "@/components/search/search-screen";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "search" });
  return {
    title: t("title"),
    description: t("hint"),
    alternates: localizedAlternates(locale, "/search"),
    // A results page has nothing stable to index — every URL would be a thin
    // duplicate of the library it points at, which is what the library pages are
    // already for.
    robots: { index: false, follow: true },
  };
}

/**
 * `/search`, and deliberately **public** (D4).
 *
 * Everything it searches — articles, conditions, the glossary — is public, and
 * migration `0022` grants the search function to `anon` for exactly this reason.
 * Putting it behind the app's auth gate would mean the one place a visitor can
 * look something up requires an account first, which inverts what the content site
 * is for.
 *
 * Tool results link into the signed-in app, so a signed-out visitor who taps one
 * meets `AuthGate`. That is the right behaviour rather than a gap: she searched for
 * a thing Femio does, and the answer is that Femio does it and she needs an account.
 */
export default async function SearchPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  return <SearchScreen />;
}
