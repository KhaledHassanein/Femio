import { Link } from "@/i18n/navigation";

// Shared layout for static trust pages (about, editorial policy, medical review):
// a title, intro, a list of heading/body points, and related-page links.
export function TrustPage({
  title,
  intro,
  points,
  related,
}: {
  title: string;
  intro: string;
  points: { heading: string; body: string }[];
  related?: { href: string; label: string }[];
}) {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-1 flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-2">
        <h1 className="font-display text-3xl text-text">{title}</h1>
        <p className="text-md text-text-muted">{intro}</p>
      </div>
      <div className="flex flex-col gap-5">
        {points.map((p, i) => (
          <section key={i} className="flex flex-col gap-1">
            <h2 className="font-display text-lg text-text">{p.heading}</h2>
            <p className="text-sm text-text-muted">{p.body}</p>
          </section>
        ))}
      </div>
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
