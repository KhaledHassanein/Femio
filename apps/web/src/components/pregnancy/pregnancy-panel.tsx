import { getFormatter, getTranslations } from "next-intl/server";
import { pregnancyProgress } from "@/lib/pregnancy";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";
import { SetDueDate } from "./set-due-date";
import { EndPregnancy } from "./end-pregnancy";

/**
 * The pregnancy dashboard (P1.13b).
 *
 * Replaces the "fuller pregnancy tracking is coming soon" card that half the onboarding
 * modes landed on — which also showed a cycle-day counter and a next-period prediction,
 * both of which are meaningless to someone who is pregnant and one of which is alarming.
 *
 * A server component on purpose: it renders text from a date, so there is nothing for the
 * browser to do and no reason to add to the client bundle we just spent P1.11.2 shrinking.
 *
 * What it deliberately does NOT do: interpret. It counts days against a due date she was
 * given and names the trimester, which is arithmetic. It does not say whether anything is
 * going well, does not compare her to anyone, and puts the warning-signs route in front of
 * her rather than waiting to be asked — pregnancy red flags are the one place in Femio
 * where surfacing information late is the harmful choice (brief §8).
 */
export async function PregnancyPanel({
  pregnancy,
  today,
}: {
  pregnancy: { id: string; edd: string | null; status: string } | null;
  today: string;
}) {
  const t = await getTranslations("pregnancy");
  const format = await getFormatter();

  // A pregnancy that has ended must not be met with "Set up your pregnancy". Showing a
  // fresh form to someone who has just recorded a loss is the kind of default that reads
  // as indifference, and the cost of getting it wrong is entirely hers (P1.13d).
  if (pregnancy && pregnancy.status !== "active") {
    return (
      <Card>
        <CardContent className="flex flex-col gap-3 p-6">
          <h2 className="font-display text-lg text-text">{t(`ended.${pregnancy.status}.heading`)}</h2>
          <p className="text-sm text-text-muted">{t(`ended.${pregnancy.status}.body`)}</p>
          <p className="text-sm text-text-subtle">{t("ended.changeFocus")}</p>
        </CardContent>
      </Card>
    );
  }

  const edd = pregnancy?.edd ?? null;
  const progress = edd ? pregnancyProgress(edd, today) : null;

  // No due date yet, or one that no longer describes a pregnancy — ask, don't guess.
  if (!progress) {
    return (
      <Card>
        <CardContent className="flex flex-col gap-4 p-6">
          <div className="flex flex-col gap-1">
            <h2 className="font-display text-lg text-text">{t("setup.heading")}</h2>
            <p className="text-sm text-text-muted">{t("setup.body")}</p>
          </div>
          <SetDueDate />
        </CardContent>
      </Card>
    );
  }

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  return (
    <div className="flex flex-col gap-4">
      <Card>
        <CardContent className="flex flex-col gap-4 p-6">
          <div className="flex flex-wrap items-baseline justify-between gap-2">
            <p className="font-display text-2xl text-text">
              {t("weeksDays", { weeks: progress.weeks, days: progress.days })}
            </p>
            <p className="text-sm text-text-muted">{t(`trimester.${progress.trimester}`)}</p>
          </div>

          {/* Presentational only — the numbers above carry the meaning for a screen reader. */}
          <div className="h-2 w-full overflow-hidden rounded-full bg-surface-sunken" aria-hidden="true">
            <div
              className="h-full rounded-full bg-accent"
              style={{ width: `${Math.round(progress.fraction * 100)}%` }}
            />
          </div>

          <div className="flex flex-col gap-1 text-sm text-text-muted">
            <p>{t("due", { date: fmt(edd!) })}</p>
            <p>
              {progress.overdue
                ? t("overdue", { days: Math.abs(progress.daysUntilDue) })
                : t("daysToGo", { days: progress.daysUntilDue })}
            </p>
            <p>{t("termFrom", { date: fmt(progress.termStart) })}</p>
          </div>

          {/* Every estimate in Femio says it is one (product rule 3). */}
          <p className="text-sm text-text-subtle">{t("estimateNote")}</p>

          {/* Quiet on purpose: this control should be findable, not prominent. */}
          <EndPregnancy pregnancyId={pregnancy!.id} />
        </CardContent>
      </Card>

      {/* Not tucked at the bottom: in pregnancy, late is the harmful direction. */}
      <Alert variant="danger">
        <AlertDescription className="flex flex-col gap-2">
          <span className="font-medium">{t("redFlags.heading")}</span>
          <span>{t("redFlags.body")}</span>
          <Link href="/learn/pregnancy-warning-signs" className="text-text-link underline">
            {t("redFlags.link")}
          </Link>
        </AlertDescription>
      </Alert>

      <Card>
        <CardContent className="flex flex-col gap-2 p-6">
          <h2 className="font-display text-lg text-text">{t("reading.heading")}</h2>
          <ul className="flex flex-col gap-1 text-sm">
            {[
              { href: "/learn/pregnancy-basics", key: "basics" },
              { href: "/learn/early-pregnancy-changes", key: "changes" },
              { href: "/learn/first-pregnancy-appointment", key: "appointment" },
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
