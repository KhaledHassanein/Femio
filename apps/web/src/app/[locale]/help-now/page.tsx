import type { Metadata } from "next";
import { setRequestLocale } from "next-intl/server";
import { CrisisContentView } from "@/components/crisis/crisis-content-view";
import { getCrisisContent } from "@/lib/crisis/content";
import { env } from "@/lib/env";
import { localizedAlternates } from "@/lib/seo/metadata";

type PageProps = { params: Promise<{ locale: string }> };

// Public, account-less crisis page. It collects nothing (no questionnaire, no
// health data) and is intentionally kept OUT of search: `noindex` here + excluded
// from sitemap.ts. Fully server-rendered so it works with JS disabled and offline.
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { locale } = await params;
  const content = getCrisisContent(locale);
  return {
    title: content.strings.dialogTitle,
    alternates: localizedAlternates(locale, "/help-now"),
    robots: { index: false, follow: false },
  };
}

export default async function HelpNowPage({ params }: PageProps) {
  const { locale } = await params;
  setRequestLocale(locale);
  const content = getCrisisContent(locale);

  return (
    <main className="mx-auto flex w-full max-w-lg flex-col gap-6 px-6 py-12">
      <CrisisContentView content={content} directoryUrl={env.NEXT_PUBLIC_CRISIS_DIRECTORY_URL} />
    </main>
  );
}
