"use client";

import { useFormatter, useTranslations } from "next-intl";
import { GESTATION_DAYS, pregnancyProgress } from "@/lib/pregnancy";
import { addDays } from "@/lib/calculators/dates";
import { predictionBand } from "@/lib/ui/range-band";
import { HeroCard } from "@/components/ui/hero-card";
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
 * Was a server component on purpose — it renders text from a date, so there was nothing
 * for the browser to do and no reason to grow the bundle P1.11.2 shrank. That reasoning
 * was right and is now outranked: a server component cannot run in a Capacitor bundle,
 * so keeping it server-side meant this screen could never ship to iOS/Android
 * (P4.0, ADR-048). The cost is the `pregnancy` namespace in the client payload, which
 * it already paid for `setup`.
 *
 * What it deliberately does NOT do: interpret. It counts days against a due date she was
 * given and names the trimester, which is arithmetic. It does not say whether anything is
 * going well, does not compare her to anyone, and puts the warning-signs route in front of
 * her rather than waiting to be asked — pregnancy red flags are the one place in Femio
 * where surfacing information late is the harmful choice (brief §8).
 *
 * **Split for the experience engine (R2.3, ADR-061).** The hero, the red-flag panel
 * and the reading list are now exported separately, because the engine decides
 * which modules a persona sees and in what order — D7 wants a thyroid strip between
 * the hero and the rest, and that is impossible while they are welded together. The
 * *pre-conditions* stay here: an ended pregnancy and a missing due date are not
 * modules, they are reasons there is no dashboard yet.
 */
export function PregnancyPanel({
  pregnancy,
  today,
}: {
  pregnancy: { id: string; edd: string | null; status: string } | null;
  today: string;
}) {
  const t = useTranslations("pregnancy");

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

  return (
    <div className="flex flex-col gap-4">
      <PregnancyHero edd={edd!} today={today} />
      <PregnancyWarningSigns />
      <PregnancyReading />
      {/* Quiet on purpose: findable, never prominent. It moved out of the summary
          card only because that card is now a gradient hero, and a control that
          records a loss has no business competing with it. */}
      <EndPregnancy pregnancyId={pregnancy!.id} />
    </div>
  );
}

/**
 * The hero: weeks and days as clinicians write them, and a band drawing **37w–42w**
 * rather than progress toward the due date (P1.28.4, ADR-053).
 *
 * The old bar filled toward the EDD, which drew one date as a finish line — the
 * single-certain-date framing product rule 3 exists to prevent, and the thing
 * `estimateNote` underneath had to keep apologising for. Term is a five-week range;
 * most births land inside it rather than on the date, so the range is both the
 * honest picture and the kinder one. `pad: 7` keeps 42w near the end of the axis
 * because 42w is a real outer bound, not an arbitrary edge.
 */
export function PregnancyHero({ edd, today }: { edd: string; today: string }) {
  const t = useTranslations("pregnancy");
  const format = useFormatter();
  const progress = pregnancyProgress(edd, today);
  if (!progress) return null;

  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const band = predictionBand({
    axisStart: addDays(edd, -GESTATION_DAYS),
    windowStart: progress.termStart,
    windowEnd: addDays(edd, 14), // 42w0d
    today,
    pad: 7,
  });

  return (
    <HeroCard
      tone="warm"
      eyebrow={t(`trimester.${progress.trimester}`)}
      headline={t("weeksDays", { weeks: progress.weeks, days: progress.days })}
      band={band}
      footnote={t("estimateNote")}
    >
      <div className="flex flex-col gap-0.5 text-2xs opacity-90">
        <p>{t("due", { date: fmt(edd) })}</p>
        <p>
          {progress.overdue
            ? t("overdue", { days: Math.abs(progress.daysUntilDue) })
            : t("daysToGo", { days: progress.daysUntilDue })}
        </p>
        <p>{t("termFrom", { date: fmt(progress.termStart) })}</p>
      </div>
    </HeroCard>
  );
}

/**
 * Not tucked at the bottom: in pregnancy, late is the harmful direction. Carries no
 * phone number — the global-only crisis posture applies here too (P1.26.1).
 */
export function PregnancyWarningSigns() {
  const t = useTranslations("pregnancy");
  return (
    <Alert variant="danger">
      <AlertDescription className="flex flex-col gap-2">
        <span className="font-medium">{t("redFlags.heading")}</span>
        <span>{t("redFlags.body")}</span>
        <Link href="/learn/pregnancy-warning-signs" className="text-text-link underline">
          {t("redFlags.link")}
        </Link>
      </AlertDescription>
    </Alert>
  );
}

export function PregnancyReading() {
  const t = useTranslations("pregnancy");
  return (
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
  );
}
