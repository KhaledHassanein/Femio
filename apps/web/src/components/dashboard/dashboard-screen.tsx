"use client";

import { useFormatter, useTranslations } from "next-intl";
import { fertileWindow } from "@/lib/calculators";
import { todayISO } from "@/lib/calculators/dates";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { predictionBand } from "@/lib/cycle/band";
import { currentCycleDay, topSymptoms } from "@/lib/cycle/insights";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { modeFromTrack, showsCyclePredictions, type PersonaMode } from "@/lib/persona/state";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";
import { PregnancyPanel } from "@/components/pregnancy/pregnancy-panel";
import { MenopausePanel } from "@/components/menopause/menopause-panel";
import { HeroCard } from "@/components/dashboard/hero-card";

const KNOWN_SYMPTOMS = new Set<string>(SYMPTOM_GROUPS.flatMap((g) => g.symptoms));

type Pregnancy = { id: string; edd: string | null; status: string } | null;

/**
 * The dashboard, reading its own data in the browser (P4.0, ADR-048).
 *
 * Unchanged from the server version in what it shows and hides — pregnancy and
 * menopause still get their own panels rather than cycle tools plus an apology
 * (ADR-041/043). The only difference is where the reads happen, which is what makes
 * the screen shippable to iOS/Android.
 */
export function DashboardScreen() {
  const t = useTranslations("dashboard");
  const st = useTranslations("symptoms");
  const format = useFormatter();
  const today = todayISO();

  const query = useSupabaseQuery(async (supabase) => {
    const [state, cycles, symptoms] = await Promise.all([
      unwrap(supabase.from("persona_state").select("track").maybeSingle()),
      unwrap(
        supabase.from("cycles").select("period_start").order("period_start", { ascending: false }),
      ),
      unwrap(
        supabase
          .from("symptom_logs")
          .select("type")
          .order("logged_at", { ascending: false })
          .limit(200),
      ),
    ]);

    const mode: PersonaMode = modeFromTrack(state?.track as string | null);

    // Only the pregnancy dashboard needs this, and only one pregnancy is active at a time.
    const pregnancy: Pregnancy =
      mode === "pregnancy"
        ? await unwrap(
            supabase
              .from("pregnancy")
              .select("id, edd, status")
              // Most recent regardless of status: an ended pregnancy still decides what
              // the panel should say, and "no active row" must not silently mean
              // "start again".
              .order("updated_at", { ascending: false })
              .limit(1)
              .maybeSingle(),
          )
        : null;

    return {
      mode,
      pregnancy,
      starts: (cycles ?? []).map((c) => c.period_start as string),
      top: topSymptoms(((symptoms ?? []) as { type: string }[]).map((s) => s.type)),
    };
  });

  if (query.status === "loading") {
    return (
      <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12" aria-busy="true">
        <div className="h-8 w-40 animate-pulse rounded-md bg-surface-sunken" />
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="h-24 animate-pulse rounded-md bg-surface-sunken" />
          <div className="h-24 animate-pulse rounded-md bg-surface-sunken" />
        </div>
      </main>
    );
  }

  if (query.status === "error") {
    return (
      <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        {/* Never render an empty dashboard on a failed read: to someone looking at her
            own health record, "nothing here" and "we could not load it" are very
            different statements (ADR-046). */}
        <Alert variant="danger">
          <AlertDescription className="flex flex-col items-start gap-3">
            <span>{t("loadError")}</span>
            <Button variant="outline" onClick={query.refresh}>
              {t("retry")}
            </Button>
          </AlertDescription>
        </Alert>
      </main>
    );
  }

  const { mode, pregnancy, starts, top } = query.data;
  const stItem = st as unknown as (key: string) => string;
  const symptomLabel = (type: string) =>
    KNOWN_SYMPTOMS.has(type) ? stItem(`items.${type}`) : type;
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });
  /**
   * Day and month only, for the hero. A prediction is never more than a couple of
   * months out, so the year is noise — and it is expensive noise: "Aug 28, 2026 and
   * Sep 1, 2026" wraps the headline onto three lines on a 390px screen.
   */
  const fmtShort = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), {
      day: "numeric",
      month: "short",
      timeZone: "UTC",
    });

  const prediction = predictNextPeriod(starts);
  const cycleDay = currentCycleDay(starts, today);
  const lastStart = starts.length > 0 ? [...starts].sort().at(-1)! : null;
  const fertile =
    mode === "ttc" && lastStart ? fertileWindow(lastStart, prediction?.averageLength ?? 28) : null;

  // The band draws the range the prediction already returns; when the geometry
  // can't be computed the sentence stands on its own (lib/cycle/band.ts).
  const periodBand =
    lastStart && prediction
      ? predictionBand({
          cycleStart: lastStart,
          windowStart: prediction.windowStart,
          windowEnd: prediction.windowEnd,
          today,
        })
      : null;
  const fertileBand =
    lastStart && fertile
      ? predictionBand({
          cycleStart: lastStart,
          windowStart: fertile.windowStart,
          windowEnd: fertile.windowEnd,
          today,
        })
      : null;

  /**
   * The one line under the band. Order matters: a window that has already passed
   * is the most useful thing to say, and a confidence grade would be beside the
   * point once it has. Never a day count — no "late" counter (product rule 3).
   */
  const periodFootnote = () => {
    if (!prediction) return undefined;
    if (periodBand?.pastWindow) return t("windowPassed");
    if (prediction.irregular) return t("irregularNote");
    return t(`confidence.${prediction.confidence}`);
  };

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-6">
      {/* A compact title row, not a masthead. At 36px display type "Your dashboard"
          wrapped to two lines on a 390px screen and pushed the answer below it —
          the brand bar above already says where you are, so the heading's job here
          is orientation and an h1, nothing more. */}
      <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <Badge variant="primary">{t(`modeLabel.${mode}`)}</Badge>
      </div>

      {/* TTC leads with the fertile window — it is the question she opened the app
          with — and keeps the next-period estimate as a secondary card below. */}
      {mode === "ttc" ? (
        <HeroCard
          tone="ttc"
          eyebrow={t("fertileHeading")}
          headline={
            fertile
              ? t("fertileWindow", {
                  start: fmtShort(fertile.windowStart),
                  end: fmtShort(fertile.windowEnd),
                })
              : t("needData")
          }
          footnote={fertile ? t("fertileNote") : undefined}
          band={fertileBand}
        />
      ) : null}

      {showsCyclePredictions(mode) && mode !== "ttc" ? (
        <HeroCard
          tone="cycle"
          eyebrow={cycleDay ? t("cycleDay", { day: cycleDay }) : t(`modeLabel.${mode}`)}
          headline={
            prediction
              ? t("window", {
                  start: fmtShort(prediction.windowStart),
                  end: fmtShort(prediction.windowEnd),
                })
              : t("needData")
          }
          footnote={periodFootnote()}
          band={periodBand}
        />
      ) : null}

      {/* Pregnancy gets its own dashboard rather than cycle tools plus an apology.
          A cycle-day counter and a next-period prediction are meaningless to someone
          who is pregnant, and the second one is alarming (P1.13b). */}
      {mode === "pregnancy" ? <PregnancyPanel pregnancy={pregnancy} today={today} /> : null}

      {/* Perimenopause/menopause gets its own view too: a next-period prediction is
          the least useful thing to show someone whose cycles are stopping (P1.13c). */}
      {mode === "menopause" ? (
        <MenopausePanel starts={starts} symptomCounts={top} today={today} />
      ) : null}

      {/* The primary action, full width and inside thumb reach. It used to be a
          small button beside the title, in the hardest corner of the screen to
          hit one-handed — and logging is the whole daily interaction. It sits
          *after* the panels so every mode leads with its answer rather than with
          a button (P1.28.4). */}
      <Button asChild variant="accent" className="w-full">
        <Link href="/track">{t("logCta")}</Link>
      </Button>

      {/* Secondary detail. In cycle/general mode the hero already carries the cycle
          day (eyebrow) and the window (headline), so repeating them in cards below
          it was the flatness the redesign is fixing (P1.28.2). What is left is the
          supporting number — and, in TTC, the next-period estimate the hero gave up
          its place to. Gated on `prediction`: with no history these cards had
          nothing to say and said it in a fallback sentence about a different
          number. */}
      {showsCyclePredictions(mode) && prediction ? (
        <div className="grid gap-4 sm:grid-cols-2">
          {mode === "ttc" ? (
            <Card>
              <CardContent className="flex min-h-24 flex-col gap-1 p-6">
                <p className="text-sm text-text-muted">{t("nextPeriod")}</p>
                <p className="font-display text-md text-text">
                  {t("window", {
                    start: fmt(prediction.windowStart),
                    end: fmt(prediction.windowEnd),
                  })}
                </p>
                {prediction.irregular ? (
                  <p className="text-sm text-warning-text">{t("irregularNote")}</p>
                ) : null}
              </CardContent>
            </Card>
          ) : null}

          <Card>
            <CardContent className="flex min-h-24 flex-col justify-center gap-1 p-6">
              <p className="text-sm text-text-muted">{t("avgLengthHeading")}</p>
              <p className="font-display text-lg text-text">
                {t("avgLengthDays", { days: prediction.averageLength })}
              </p>
            </CardContent>
          </Card>
        </div>
      ) : null}

      {top.length > 0 && mode !== "menopause" ? (
        <section className="flex flex-col gap-2">
          <h2 className="text-md font-semibold text-text">{t("topSymptomsHeading")}</h2>
          <div className="flex flex-wrap gap-2">
            {top.map((s) => (
              <Badge key={s.type} variant="primary">
                {symptomLabel(s.type)} · {s.count}
              </Badge>
            ))}
          </div>
        </section>
      ) : null}
    </main>
  );
}
