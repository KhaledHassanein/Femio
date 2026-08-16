"use client";

import { useEffect, useState } from "react";
import { useLocale } from "next-intl";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";
import { READING_LIST_LIMIT, articleSlugsFor } from "@/lib/experience/reading";

type Article = { slug: string; title: string };

/**
 * The reading card, driven by what the persona foregrounded (P2.3c).
 *
 * `ExperienceConfig.content.foreground` has been written since R2.1 and read by
 * nothing; this is the screen that reads it. The topic → slug mapping and the
 * counted gaps live in `lib/experience/reading.ts`, and the published/unpublished
 * question is answered by `/api/reading`.
 *
 * **It shows the pending line rather than an empty card.** A card with a heading and
 * no links reads as broken; a sentence saying the guides are being written is true,
 * and it stops being shown the moment the reviewer publishes them. Nothing here can
 * link to an unpublished draft, because the route never returns one.
 *
 * Copy comes in as props: the two callers already own `reading.*` keys in their own
 * namespaces, and adding a third namespace to the client bundle for two strings would
 * cost every page (P1.11.2).
 */
export function ReadingList({
  foreground,
  heading,
  pending,
}: {
  foreground: readonly string[];
  heading: string;
  pending: string;
}) {
  const locale = useLocale();
  const [articles, setArticles] = useState<Article[]>([]);
  const slugs = articleSlugsFor(foreground);
  const key = slugs.join(",");

  useEffect(() => {
    if (!key) return;
    const controller = new AbortController();
    fetch(`/api/reading?locale=${encodeURIComponent(locale)}&slugs=${encodeURIComponent(key)}`, {
      signal: controller.signal,
    })
      .then((res) => (res.ok ? res.json() : { articles: [] }))
      .then((data: { articles?: Article[] }) => setArticles(data.articles ?? []))
      // An unreachable CMS leaves the pending line in place. A reading card is the
      // least important thing on this screen and must never be able to break it.
      .catch(() => {});
    return () => controller.abort();
  }, [key, locale]);

  return (
    <Card>
      <CardContent className="flex flex-col gap-2 p-6">
        <h2 className="font-display text-lg text-text">{heading}</h2>
        {articles.length === 0 ? (
          <p className="text-sm text-text-muted">{pending}</p>
        ) : (
          <ul className="flex flex-col gap-1 text-sm">
            {articles.slice(0, READING_LIST_LIMIT).map((article) => (
              <li key={article.slug}>
                <Link href={`/learn/${article.slug}`} className="text-text-link underline">
                  {article.title}
                </Link>
              </li>
            ))}
          </ul>
        )}
      </CardContent>
    </Card>
  );
}
