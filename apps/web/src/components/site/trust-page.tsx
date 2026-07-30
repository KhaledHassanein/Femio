import { Link } from "@/i18n/navigation";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";

// Shared layout for static trust pages (about, editorial policy, medical review,
// privacy, terms): a title, intro, an optional status notice, a list of
// heading/body points, and related-page links.
export function TrustPage({
  title,
  intro,
  notice,
  points,
  related,
  footnote,
}: {
  title: string;
  intro: string;
  // Status banner above the content — used by the privacy/terms pages to state, in
  // the open, that the text is a draft pending counsel (P1.9b.3 / P0.12).
  notice?: { title: string; body: string };
  points: { heading: string; body: string }[];
  related?: { href: string; label: string }[];
  footnote?: string;
}) {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-1 flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-2">
        <h1 className="font-display text-3xl text-text">{title}</h1>
        <p className="text-md text-text-muted">{intro}</p>
      </div>
      {notice ? (
        <Alert variant="warning">
          <AlertTitle>{notice.title}</AlertTitle>
          <AlertDescription>{notice.body}</AlertDescription>
        </Alert>
      ) : null}
      <div className="flex flex-col gap-5">
        {points.map((p, i) => (
          <section key={i} className="flex flex-col gap-1">
            <h2 className="font-display text-lg text-text">{p.heading}</h2>
            <p className="text-sm text-text-muted">{p.body}</p>
          </section>
        ))}
      </div>
      {footnote ? <p className="text-2xs text-text-subtle">{footnote}</p> : null}
      {related && related.length > 0 ? (
        <nav className="flex flex-wrap gap-4 border-t border-border pt-4 text-sm">
          {related.map((r) => (
            <Link key={r.href} href={r.href} className="text-text-link underline">
              {r.label}
            </Link>
          ))}
        </nav>
      ) : null}
    </main>
  );
}
