"use client";

import { useTranslations } from "next-intl";

/**
 * A clinical strip — the module that makes D3, D4 and D7 different screens
 * (R1.6, `assets/mockups/R1.6_pregnancy_dashboard_reference.html`).
 *
 * ## The rule this component exists to hold
 *
 * **A strip is a row of facts, never a verdict.** It shows the value, the unit and
 * the lab's own reference range, and then it stops. There is deliberately no
 * `status`, `inRange`, `severity` or `trend` prop, and no colour encodes a
 * judgement — because deciding whether a number is good is diagnosis, and D7 §G
 * states the boundary verbatim: *"Lab values are shown with your lab's reference
 * range for your records — this is not a diagnosis. Discuss results with your
 * clinician."*
 *
 * The type is the enforcement, in the same way `Resolution` cannot express
 * restriction (ADR-057) and the movement log has no `result` column (ADR-049). If
 * a future feature wants to interpret a value, that is a product decision needing
 * its own ADR, not a prop added here.
 */

export type StripCell = {
  /** i18n key under the strip's namespace. */
  label: string;
  /** The value as she recorded it — never rounded, never re-scaled. */
  value: string;
  /** Her lab's range, or the timing note. Shown as context, not as a threshold. */
  context?: string;
};

export function ClinicalStrip({
  title,
  when,
  cells,
  note,
}: {
  title: string;
  when?: string;
  cells: readonly StripCell[];
  /** The boundary sentence. Required — a strip without one is a strip that implies. */
  note: string;
}) {
  return (
    <section className="flex flex-col gap-3 rounded-md border border-border bg-surface p-4 shadow-xs">
      <div className="flex items-center justify-between gap-3">
        <h2 className="text-xs font-semibold text-text">{title}</h2>
        {when ? <span className="text-2xs text-text-muted">{when}</span> : null}
      </div>

      <div className="flex gap-3">
        {cells.map((cell) => (
          <div key={cell.label} className="flex-1 rounded-sm bg-surface-sunken p-3">
            <span className="block text-2xs text-text-muted">{cell.label}</span>
            <span className="block font-display text-md leading-tight text-text">{cell.value}</span>
            {cell.context ? (
              <span className="block text-2xs text-text-subtle">{cell.context}</span>
            ) : null}
          </div>
        ))}
      </div>

      <p className="text-2xs leading-relaxed text-text-muted">{note}</p>
    </section>
  );
}

/**
 * The empty state, which is the one a woman sees first and the one that has to
 * avoid implying she is behind. It offers, it does not nag.
 */
export function EmptyStrip({ titleKey, ctaKey }: { titleKey: string; ctaKey: string }) {
  const t = useTranslations("experience.strips");
  return (
    <section className="flex flex-col gap-2 rounded-md border border-border bg-surface p-4 shadow-xs">
      <h2 className="text-xs font-semibold text-text">{t(titleKey)}</h2>
      <p className="text-2xs leading-relaxed text-text-muted">{t(ctaKey)}</p>
    </section>
  );
}
