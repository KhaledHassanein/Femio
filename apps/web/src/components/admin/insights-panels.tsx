import { getTranslations } from "next-intl/server";
import { WITHHELD_BUCKET, isFullyWithheld, maxVisible, type Bucket } from "@/lib/insights/k-anon";
import type { RetentionRow } from "@/lib/insights/queries";
import { Card, CardContent } from "@/components/ui/card";

/**
 * Presentation for the first-party insights dashboard (P1.20.3). Server-rendered:
 * these numbers are aggregates about the product, and there is nothing to
 * interact with, so no client bundle carries them.
 *
 * A withheld cell is drawn as an em dash with a title, never as 0 — "no data" and
 * "too few people to show" are different statements, and conflating them would
 * quietly invite someone to read a suppressed cell as an empty one.
 */

function Withheld({ label }: { label: string }) {
  return (
    <span className="text-text-subtle" title={label} aria-label={label}>
      —
    </span>
  );
}

export async function OverviewTiles({
  metrics,
}: {
  metrics: { key: string; value: number | null }[];
}) {
  const t = await getTranslations("insights");

  return (
    <div className="grid gap-3 sm:grid-cols-3">
      {metrics.map((m) => (
        <Card key={m.key}>
          <CardContent className="flex flex-col gap-1 p-4">
            <p className="text-xs text-text-muted">{t(`overview.${m.key}`)}</p>
            <p className="font-display text-2xl text-text">
              {m.value === null ? <Withheld label={t("withheldHint")} /> : m.value}
            </p>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}

export async function BreakdownTable({
  title,
  note,
  rows,
  labelFor,
}: {
  title: string;
  note?: string;
  rows: Bucket[];
  labelFor: (bucket: string) => string;
}) {
  const t = await getTranslations("insights");
  const max = maxVisible(rows);

  return (
    <section className="flex flex-col gap-2">
      <div className="flex flex-col gap-0.5">
        <h2 className="font-display text-lg text-text">{title}</h2>
        {note ? <p className="text-xs text-text-muted">{note}</p> : null}
      </div>

      {rows.length === 0 || isFullyWithheld(rows) ? (
        <p className="text-sm text-text-muted">{t("tooFew")}</p>
      ) : (
        <table className="w-full text-sm">
          <caption className="sr-only">{title}</caption>
          <thead>
            <tr className="text-start text-xs text-text-muted">
              <th scope="col" className="py-1 text-start font-normal">
                {t("group")}
              </th>
              <th scope="col" className="py-1 text-end font-normal">
                {t("people")}
              </th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.bucket} className="border-t border-border">
                <th scope="row" className="py-2 text-start font-normal text-text">
                  {r.bucket === WITHHELD_BUCKET ? t("withheldGroup") : labelFor(r.bucket)}
                </th>
                <td className="py-2 text-end tabular-nums text-text">
                  {r.users === null ? (
                    <Withheld label={t("withheldHint")} />
                  ) : (
                    <span className="inline-flex items-center gap-2">
                      <span
                        aria-hidden
                        className="h-1.5 rounded-full bg-primary-soft"
                        style={{ width: `${max > 0 ? Math.round((r.users / max) * 96) : 0}px` }}
                      />
                      {r.users}
                    </span>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}

export async function RetentionTable({ rows, locale }: { rows: RetentionRow[]; locale: string }) {
  const t = await getTranslations("insights");
  const month = new Intl.DateTimeFormat(locale, { month: "short", year: "numeric" });

  return (
    <section className="flex flex-col gap-2">
      <div className="flex flex-col gap-0.5">
        <h2 className="font-display text-lg text-text">{t("retention.title")}</h2>
        <p className="text-xs text-text-muted">{t("retention.note")}</p>
      </div>

      {rows.length === 0 ? (
        <p className="text-sm text-text-muted">{t("tooFew")}</p>
      ) : (
        <table className="w-full text-sm">
          <caption className="sr-only">{t("retention.title")}</caption>
          <thead>
            <tr className="text-xs text-text-muted">
              <th scope="col" className="py-1 text-start font-normal">
                {t("retention.cohort")}
              </th>
              <th scope="col" className="py-1 text-end font-normal">
                {t("retention.size")}
              </th>
              <th scope="col" className="py-1 text-end font-normal">
                {t("retention.month1")}
              </th>
              <th scope="col" className="py-1 text-end font-normal">
                {t("retention.month2")}
              </th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.cohort} className="border-t border-border">
                <th scope="row" className="py-2 text-start font-normal text-text">
                  {month.format(new Date(r.cohort))}
                </th>
                {[r.cohort_size, r.month_1, r.month_2].map((v, i) => (
                  <td key={i} className="py-2 text-end tabular-nums text-text">
                    {v === null ? <Withheld label={t("withheldHint")} /> : v}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </section>
  );
}
