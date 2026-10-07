import { NextResponse } from "next/server";

import { listContent, translatedSlugs } from "@/lib/cms/client";
import { routing } from "@/i18n/routing";
import { libraryDocs, type LibraryIndex } from "@/lib/search/library";

/**
 * The library's search index for one locale, built once at build time (P2.2).
 *
 * `force-static` with every locale prerendered means this is a file on Vercel's CDN,
 * not a function: a search costs no server time and no database request. Before
 * this, search called `search_content` in Supabase on every keystroke. The index is
 * small: titles, one-line summaries and section headings (see `lib/search/library`).
 */
export const dynamic = "force-static";
export const dynamicParams = false;

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export async function GET(_request: Request, { params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const [articles, conditions, glossary, translated] = await Promise.all([
    listContent("articles", locale),
    listContent("conditions", locale),
    listContent("glossary", locale),
    Promise.all(["articles", "conditions", "glossary"].map((c) => translatedSlugs(c))),
  ]);

  const body: LibraryIndex = {
    locale,
    englishOnly:
      locale !== routing.defaultLocale && translated.every((byLocale) => !byLocale[locale]?.size),
    docs: libraryDocs({ articles, conditions, glossary }),
  };
  return NextResponse.json(body);
}
