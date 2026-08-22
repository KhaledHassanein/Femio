"use client";

import { useFormatter, useTranslations } from "next-intl";

import { Card, CardContent } from "@/components/ui/card";
import type { CycleReport } from "@/lib/cycle/cycle-report";

/**
 * The cycle that just ended (`docs/27` phase 3.3).
 *
 * Both incumbents produce one; `docs/26` §6 lists it as table stakes Femio was
 * missing. It also lands at the one moment in the month when she is naturally
 * looking back rather than forward.
 *
 * **It describes and does not grade.** No score, no "good cycle", no tick for
 * regularity, no arrow saying she improved. `docs/25` §5a rejected the ring
 * because a ring implies a target; a graded cycle report implies it more
 * explicitly, and 31 days is not worse than 28.
 *
 * The only comparison is to *her own* earlier cycles, and it is stated as a
 * signed difference — "three days longer than your usual" — rather than labelled.
 * Whether that matters is a clinician's call and hers, not the card's.
 */
export function CycleReportCard({
  report,
  label,
}: {
  report: CycleReport | null;
  label: (type: string) => string;
}) {
  const t = useTranslations("cycleReport");
  const format = useFormatter();
  if (!report) return null;

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  return (
    <Card>
      <CardContent className="flex flex-col gap-3 p-6">
        <div className="flex flex-col gap-0.5">
          <h2 className="font-display text-md text-text">{t("heading")}</h2>
          <p className="text-2xs text-text-muted">
            {t("range", { start: fmt(report.start), end: fmt(report.end) })}
          </p>
        </div>

        <p className="text-sm text-text">{t("length", { days: report.length })}</p>

        {report.deltaFromUsual !== null && report.deltaFromUsual !== 0 ? (
          <p className="text-sm text-text-muted">
            {report.deltaFromUsual > 0
              ? t("longer", { days: report.deltaFromUsual })
              : t("shorter", { days: Math.abs(report.deltaFromUsual) })}
          </p>
        ) : null}

        {report.bleedDays > 0 ? (
          <p className="text-sm text-text-muted">{t("bleedDays", { days: report.bleedDays })}</p>
        ) : null}

        {report.symptoms.length > 0 ? (
          <p className="text-sm text-text-muted">
            {t("symptoms", {
              list: report.symptoms.map((s) => `${label(s.type)} (${s.count})`).join(", "),
            })}
          </p>
        ) : null}
      </CardContent>
    </Card>
  );
}
