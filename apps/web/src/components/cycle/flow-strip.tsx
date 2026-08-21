"use client";

import { useFormatter, useTranslations } from "next-intl";
import { addDays, diffDays } from "@/lib/calculators/dates";

/**
 * The last 30 days of bleeding, as marks (`docs/25` §5a — "the strip").
 *
 * The module has been called `cycle.flowStrip` since R1.9i and rendered a **list
 * of dates with a word beside each one**. A six-row table is not a strip: it says
 * "5 Aug — Medium" where a strip says "here, and here, and this one was heavier",
 * which is the shape of the question people actually ask their own history.
 *
 * Encoding follows §5a exactly: **size *and* opacity, never colour alone**. A
 * strip that distinguished spotting from heavy by hue would be unreadable to the
 * ~1 in 12 women with a colour-vision deficiency, and unreadable in grayscale
 * print — and this is data she may hand to a clinician.
 *
 * What it deliberately does not do is interpret. No average flow, no "heavier
 * than usual", no trend line. Those are readings a clinician makes from a history,
 * and `docs/25` §5a rejected the ring for the same reason: the vocabulary here is
 * hers, rendered back unchanged.
 */

/** Height and opacity per recorded intensity. Two channels, never one. */
const MARK: Record<string, { h: string; o: string }> = {
  spotting: { h: "h-2", o: "opacity-40" },
  light: { h: "h-3", o: "opacity-60" },
  medium: { h: "h-5", o: "opacity-80" },
  heavy: { h: "h-7", o: "opacity-100" },
};

/** A logged day whose intensity she never chose still has to be visible. */
const LOGGED_UNSPECIFIED = { h: "h-4", o: "opacity-70" };

const DAYS = 30;

export function FlowStrip({
  periods,
  today,
}: {
  periods: readonly { date: string; flow: string | null }[];
  today: string;
}) {
  const t = useTranslations("flowStrip");
  const tFlow = useTranslations("track.flow");
  const format = useFormatter();

  const byDate = new Map(periods.map((p) => [p.date, p.flow]));
  const start = addDays(today, -(DAYS - 1));

  const days = Array.from({ length: DAYS }, (_, i) => {
    const date = addDays(start, i);
    return { date, flow: byDate.get(date), logged: byDate.has(date) };
  });

  const loggedCount = days.filter((d) => d.logged).length;

  // One sentence for a screen reader, not thirty. Reading out every empty day
  // would bury the answer in the noise a sighted user's eye skips for free.
  const summary =
    loggedCount === 0
      ? t("a11y.none", { days: DAYS })
      : t("a11y.summary", { count: loggedCount, days: DAYS });

  return (
    <section className="flex flex-col gap-2">
      <div className="flex items-baseline justify-between gap-3">
        <h2 className="text-md font-semibold text-text">{t("heading")}</h2>
        <span className="text-2xs text-text-muted">{t("range", { days: DAYS })}</span>
      </div>

      {/* A flex row, so RTL mirrors it with `dir` and the oldest day sits at the
          reading origin in both directions. No `left`/`right` anywhere. */}
      <div role="img" aria-label={summary} className="flex h-8 items-end gap-[3px]">
        {days.map((d) => {
          const mark = d.logged ? (MARK[d.flow ?? ""] ?? LOGGED_UNSPECIFIED) : null;
          return (
            <div
              key={d.date}
              className={
                mark
                  ? `flex-1 rounded-xs bg-phase-menstrual ${mark.h} ${mark.o}`
                  : "h-1 flex-1 rounded-xs bg-surface-sunken"
              }
              // Native tooltip only — supplementary, never the sole carrier of the
              // information, which is what the aria-label above is for.
              title={
                d.logged
                  ? `${format.dateTime(new Date(`${d.date}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" })}${d.flow ? ` · ${tFlow(d.flow)}` : ""}`
                  : undefined
              }
            />
          );
        })}
      </div>

      <p className="text-2xs text-text-muted">
        {loggedCount === 0 ? t("empty") : t("footnote")}
      </p>
    </section>
  );
}

/** Exported for the test — the strip must never claim a day she did not log. */
export function strippedDays(
  periods: readonly { date: string; flow: string | null }[],
  today: string,
): number {
  const start = addDays(today, -(DAYS - 1));
  return periods.filter((p) => diffDays(start, p.date) >= 0 && diffDays(p.date, today) >= 0).length;
}
