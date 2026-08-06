"use client";

import { useFormatter, useTranslations } from "next-intl";
import { cycleVariability, sinceLastPeriod, MENOPAUSE_SYMPTOMS } from "@/lib/menopause";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";

/**
 * The perimenopause / menopause dashboard (P1.13c).
 *
 * Replaces the "coming soon" card that this mode shared with pregnancy until today.
 *
 * The whole design question here is what Femio is allowed to say. The clinical
 * convention is twelve consecutive months without a period *with no other cause*, and
 * that last clause is the reason this screen reports a count and stops. Pregnancy,
 * thyroid disease, some medicines and several other things also stop periods; deciding
 * which applies is diagnosis, and diagnosis is outside what Femio is (product rule 1).
 *
 * So: the arithmetic is ours, the conclusion is hers and her clinician's. The count is
 * shown plainly, the convention is named as a convention, and the next step offered is a
 * conversation rather than a verdict.
 *
 * Was a server component — it renders text from dates, so there was nothing for the
 * browser to do. Now a client component, because a server one cannot run in a Capacitor
 * bundle and this screen has to ship to iOS/Android (P4.0, ADR-048).
 */
export function MenopausePanel({
  starts,
  symptomCounts,
  today,
}: {
  starts: string[];
  symptomCounts: { type: string; count: number }[];
  today: string;
}) {
  const t = useTranslations("menopause");
  const st = useTranslations("symptoms");
  const stItem = st as unknown as (key: string) => string;
  const format = useFormatter();

  const lastStart = starts.length > 0 ? [...starts].sort().at(-1)! : null;
  const since = sinceLastPeriod(lastStart, today);
  const variability = cycleVariability(starts);

  const relevant = symptomCounts
    .filter((s) => (MENOPAUSE_SYMPTOMS as readonly string[]).includes(s.type))
    .slice(0, 6);

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  return (
    <div className="flex flex-col gap-4">
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          {since ? (
            <>
              <p className="font-display text-2xl text-text">
                {since.months < 1
                  ? t("sinceDays", { days: since.days })
                  : t("sinceMonths", { months: since.months })}
              </p>
              <p className="text-sm text-text-muted">{t("lastLogged", { date: fmt(lastStart!) })}</p>

              {/* The convention, named as a convention — never as a conclusion about her. */}
              <p className="text-sm text-text-muted">
                {since.pastConventionalMarker ? t("markerPassed") : t("markerAhead")}
              </p>
              <p className="text-sm text-text-subtle">{t("notDiagnosis")}</p>
            </>
          ) : (
            <>
              <h2 className="font-display text-lg text-text">{t("empty.heading")}</h2>
              <p className="text-sm text-text-muted">{t("empty.body")}</p>
            </>
          )}
        </CardContent>
      </Card>

      {variability ? (
        <Card>
          <CardContent className="flex flex-col gap-1 p-6">
            <p className="text-sm text-text-muted">{t("variability.heading")}</p>
            <p className="font-display text-lg text-text">
              {t("variability.range", { shortest: variability.shortest, longest: variability.longest })}
            </p>
            <p className="text-sm text-text-muted">
              {variability.irregular ? t("variability.irregular") : t("variability.steady")}
            </p>
          </CardContent>
        </Card>
      ) : null}

      {relevant.length > 0 ? (
        <section className="flex flex-col gap-2">
          <h2 className="text-md font-semibold text-text">{t("symptoms.heading")}</h2>
          <div className="flex flex-wrap gap-2">
            {relevant.map((s) => (
              <Badge key={s.type} variant="primary">
                {stItem(`items.${s.type}`)} · {s.count}
              </Badge>
            ))}
          </div>
          <p className="text-sm text-text-subtle">{t("symptoms.note")}</p>
        </section>
      ) : null}

      <Card>
        <CardContent className="flex flex-col gap-2 p-6">
          <h2 className="font-display text-lg text-text">{t("reading.heading")}</h2>
          <ul className="flex flex-col gap-1 text-sm">
            {[
              { href: "/learn/perimenopause-explained", key: "perimenopause" },
              { href: "/learn/menopause-explained", key: "menopause" },
              { href: "/learn/menopause-care-options", key: "care" },
              { href: "/learn/track-perimenopause-symptoms", key: "tracking" },
            ].map((item) => (
              <li key={item.key}>
                <Link href={item.href} className="text-text-link underline">
                  {t(`reading.${item.key}`)}
                </Link>
              </li>
            ))}
          </ul>
        </CardContent>
      </Card>
    </div>
  );
}
