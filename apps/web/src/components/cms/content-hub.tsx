import type { ContentDoc } from "@/lib/cms/client";
import { Link } from "@/i18n/navigation";
import { PageView } from "@/components/analytics/page-view";

// Shared list view for a content collection hub (articles, conditions, …).
export function ContentHub({
  title,
  subtitle,
  emptyText,
  items,
  hrefBase, // locale-less, e.g. "/conditions"
  lede,
}: {
  title: string;
  subtitle: string;
  emptyText: string;
  items: ContentDoc[];
  hrefBase: string;
  lede: (doc: ContentDoc) => string | null | undefined;
}) {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-col gap-6 px-6 py-12">
      <PageView area="library" />
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-3xl text-text">{title}</h1>
        <p className="text-sm text-text-muted">{subtitle}</p>
      </div>

      {items.length > 0 ? (
        <ul className="flex flex-col gap-4">
          {items.map((doc) => {
            const summary = lede(doc);
            return (
              <li key={doc.id}>
                <Link
                  href={`${hrefBase}/${doc.slug}`}
                  className="block rounded-md border border-border p-4 hover:bg-surface-sunken"
                >
                  <h2 className="font-display text-lg text-text">{doc.title}</h2>
                  {summary ? <p className="mt-1 text-sm text-text-muted">{summary}</p> : null}
                </Link>
              </li>
            );
          })}
        </ul>
      ) : (
        <p className="text-sm text-text-muted">{emptyText}</p>
      )}
    </main>
  );
}
