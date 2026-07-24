import type { CrisisContent } from "@/lib/crisis/content";

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
}: {
  content: CrisisContent;
  directoryUrl?: string;
  headingId?: string;
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
