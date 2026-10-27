import { Link } from "@/i18n/navigation";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { PLACEHOLDER_PATTERN } from "@/lib/legal/placeholders";

// Shared layout for static trust pages (about, editorial policy, medical review,
// privacy, terms): a title, intro, an optional effective-date line, an optional
// "in short" box, a list of heading/body points (a point may carry a bullet list
// instead of a body), an optional in-page contents list, and related-page links.

export type TrustPoint = {
  heading: string;
  body?: string;
  /** Bullets, each with an optional bold lead-in ("Records kept by our host."). */
  items?: { lead?: string; body: string }[];
};

/**
 * Text that may contain the unfilled legal markers ([ENTITY], [EMAIL], [DATE], [URL]).
 * Each marker is shown highlighted so the owner cannot publish one by accident. The
 * marker is Latin inside Arabic text, so it is isolated (`dir="ltr"`) or its brackets
 * would flip.
 */
export function MarkedText({ text }: { text: string }) {
  const parts = text.split(PLACEHOLDER_PATTERN);
  return (
    <>
      {parts.map((part, i) =>
        PLACEHOLDER_PATTERN.test(part) ? (
          <mark key={i} dir="ltr" className="rounded-sm bg-warning-soft px-1 text-warning-text">
            {part}
          </mark>
        ) : (
          part
        ),
      )}
    </>
  );
}

export function TrustPage({
  title,
  intro,
  effective,
  summary,
  notice,
  points,
  tocLabel,
  related,
  footnote,
}: {
  title: string;
  intro: string;
  /** "Effective date: [DATE] · Version 1", shown under the title. */
  effective?: string;
  /** The "in short" box: a handful of one-line promises. */
  summary?: { title: string; items: string[] };
  // Status banner above the content, for a page that needs to say it is provisional.
  notice?: { title: string; body: string };
  points: TrustPoint[];
  /** When set, a contents list of the sections is shown under this label. */
  tocLabel?: string;
  related?: { href: string; label: string }[];
  footnote?: string;
}) {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-1 flex-col gap-6 px-6 py-12">
      <div className="flex flex-col gap-2">
        <h1 className="font-display text-3xl text-text">{title}</h1>
        {effective ? (
          <p className="text-sm font-semibold text-text-muted">
            <MarkedText text={effective} />
          </p>
        ) : null}
        <p className="text-md text-text-muted">{intro}</p>
      </div>
      {notice ? (
        <Alert variant="warning">
          <AlertTitle>{notice.title}</AlertTitle>
          <AlertDescription>{notice.body}</AlertDescription>
        </Alert>
      ) : null}
      {summary ? (
        <section aria-labelledby="in-short" className="flex flex-col gap-3 rounded-lg bg-surface-sunken p-5">
          <h2 id="in-short" className="font-display text-lg text-text">
            {summary.title}
          </h2>
          <ul className="flex list-disc flex-col gap-2 ps-5 text-sm text-text">
            {summary.items.map((item, i) => (
              <li key={i}>{item}</li>
            ))}
          </ul>
        </section>
      ) : null}
      {tocLabel ? (
        <nav aria-label={tocLabel} className="flex flex-col gap-2 text-sm">
          <p className="font-semibold text-text">{tocLabel}</p>
          <ol className="flex list-decimal flex-col gap-1 ps-5 text-text-link">
            {points.map((p, i) => (
              <li key={i}>
                <a href={`#section-${i + 1}`} className="underline underline-offset-2">
                  {p.heading}
                </a>
              </li>
            ))}
          </ol>
        </nav>
      ) : null}
      <div className="flex flex-col gap-5">
        {points.map((p, i) => (
          <section key={i} id={`section-${i + 1}`} className="flex scroll-mt-20 flex-col gap-1">
            <h2 className="font-display text-lg text-text">{p.heading}</h2>
            {p.body ? (
              <p className="max-w-[68ch] text-sm text-text-muted">
                <MarkedText text={p.body} />
              </p>
            ) : null}
            {p.items ? (
              <ul className="flex max-w-[68ch] list-disc flex-col gap-2 ps-5 text-sm text-text-muted">
                {p.items.map((item, j) => (
                  <li key={j}>
                    {item.lead ? <strong className="font-semibold text-text">{item.lead} </strong> : null}
                    <MarkedText text={item.body} />
                  </li>
                ))}
              </ul>
            ) : null}
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
