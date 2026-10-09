import crisis from "@/lib/crisis/crisis.json";
import type { CrisisContent } from "@/lib/crisis/content";

type NumbersLocale = keyof typeof crisis.emergencyNumbers.labels;

/**
 * Tap-to-call numbers for the markets Femio serves, under the approved copy (public
 * audit 2026-10-09: the page named no number at all, and the external directory did
 * not list Egypt or Saudi Arabia). Region is never inferred: she sees her
 * language's countries first, all of them labelled.
 */
function EmergencyNumbers({ locale }: { locale: string }) {
  const data = crisis.emergencyNumbers;
  // Not until a named reviewer has re-verified every number (CRISIS_RESOURCES.md).
  if (data.review.status !== "approved") return null;
  const l = (locale in data.labels ? locale : "en") as NumbersLocale;
  const labels = data.labels[l] as Record<string, string>;
  const region = new Intl.DisplayNames([l], { type: "region" });
  const checked = new Intl.DateTimeFormat(l, { dateStyle: "medium", timeZone: "UTC" }).format(
    new Date(`${data.checked}T00:00:00Z`),
  );
  return (
    <section className="flex flex-col gap-3">
      <h3 className="text-sm font-semibold text-text">{labels.heading}</h3>
      <ul className="flex flex-col gap-3">
        {data.order[l].map((cc) => (
          <li key={cc} className="flex flex-col gap-1.5">
            <span className="text-xs font-semibold text-text-muted">{region.of(cc)}</span>
            <span className="flex flex-wrap gap-2">
              {(data.countries[cc as keyof typeof data.countries] as string[][]).map(
                ([kind, number]) => (
                  <a
                    key={number}
                    href={`tel:${number}`}
                    className="inline-flex min-h-11 items-center gap-2 rounded-pill border border-border bg-surface px-3 text-sm text-text"
                  >
                    <bdi className="font-semibold tabular-nums">{number}</bdi>
                    <span className="text-text-muted">{labels[kind!]}</span>
                  </a>
                ),
              )}
            </span>
          </li>
        ))}
      </ul>
      <p className="text-2xs text-text-subtle">{labels.checked!.replace("{date}", checked)}</p>
    </section>
  );
}

/**
 * Presentational crisis copy. Deliberately hook-free so it renders identically in
 * a server component (the /help-now page, which must work with JS disabled and
 * offline) and inside the client dialog. All wording comes from `content.strings`
 * (approved copy); this component never invents guidance text.
 *
 * The urgent route (emergency services / nearest emergency department) is always
 * shown and visually primary. The external directory is a clearly-separate,
 * secondary action rendered only when an approved directory URL is configured —
 * so a missing/unvetted link never blanks the crisis screen.
 */
export function CrisisContentView({
  content,
  directoryUrl,
  headingId,
  showNumbers = false,
}: {
  content: CrisisContent;
  directoryUrl?: string;
  headingId?: string;
  /** Country numbers: the /help-now page only; the dialog stays global (CRISIS_RESOURCES.md). */
  showNumbers?: boolean;
}) {
  const { strings, directoryName } = content;
  const [before, after] = strings.directorySentence.split("{directory}");

  return (
    <div lang={content.lang} dir={content.dir} className="flex flex-col gap-6 text-start">
      {/* Urgent route — always present, visually primary. */}
      <section className="flex flex-col gap-2">
        <h2 id={headingId} className="font-display text-lg text-text">
          {strings.immediateHeading}
        </h2>
        <p className="text-md leading-relaxed text-text">{strings.immediateLead}</p>
        <p className="text-sm text-text-muted">{strings.stayWithSomeone}</p>
      </section>

      {showNumbers ? <EmergencyNumbers locale={content.lang} /> : null}

      {/* External directory — separate, secondary, only when a vetted link is set. */}
      {directoryUrl ? (
        <section className="flex flex-col gap-2 rounded-md border border-border bg-surface-sunken p-4">
          <h3 className="text-sm font-semibold text-text">{strings.directoryHeading}</h3>
          <p className="text-sm text-text-muted">
            {before}
            <a
              href={directoryUrl}
              referrerPolicy="no-referrer"
              rel="noreferrer"
              className="font-medium text-primary-soft-text underline underline-offset-2"
            >
              {directoryName}
            </a>
            {after}
          </p>
        </section>
      ) : null}

      {/* Worried about someone else. */}
      <section className="flex flex-col gap-2 border-t border-border pt-4">
        <h3 className="text-sm font-semibold text-text">{strings.worriedHeading}</h3>
        <p className="text-sm text-text-muted">{strings.worriedBody}</p>
      </section>
    </div>
  );
}
