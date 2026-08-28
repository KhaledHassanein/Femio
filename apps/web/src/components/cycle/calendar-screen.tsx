"use client";

import { useState } from "react";
import { useFormatter, useLocale, useTranslations } from "next-intl";

import { AppScreen, ScreenError } from "@/components/patterns/app-screen";
import { LoadingState } from "@/components/patterns/loading-state";
import { CalendarMonth } from "@/components/cycle/calendar-month";
import { Card, CardContent } from "@/components/ui/card";
import { buildMonthGrid, weekStartForLocale } from "@/lib/cycle/calendar";
import { dayStates, type FlowLevel } from "@/lib/cycle/day-states";
import { todayISO } from "@/lib/calculators/dates";
import { currentCycleDay } from "@/lib/cycle/insights";
import { bleedStarts } from "@/lib/cycle/predict";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";

/**
 * The calendar, promoted from an icon to a tab (RB-C5, `docs/29_REBUILD/06` §2).
 *
 * One scrolling screen — month grid, then the selected day beneath it. Flo's
 * structure, and the right one: the grid answers "when", the detail answers "what
 * happened", and putting the second behind a navigation step means she never sees
 * it.
 *
 * ## First consumer of two Phase-A tables
 *
 * `period_days` (`0015`) gives per-day flow, so a spotting day and a heavy day
 * look different — no competitor does this. `predictions` (`0018`) carries both
 * probability tiers, which the grid draws as two treatments rather than one.
 * Nothing read either table before this screen.
 *
 * ## Reads that are allowed to fail
 *
 * `period_days` and `predictions` are wrapped so a missing table degrades to an
 * empty grid rather than an error page. Both ship in migrations the owner applies,
 * and between deploying a client and running a migration the calendar should show
 * her month with nothing on it — not refuse to render. Her *cycles*, by contrast,
 * go through `unwrap`: those are her record, and an empty month that silently
 * means "the request failed" is the lie ADR-046 forbids.
 */
export function CalendarScreen() {
  const t = useTranslations("calendar");
  const locale = useLocale();
  const format = useFormatter();
  const today = todayISO();
  const [selected, setSelected] = useState<string>(today);

  const query = useSupabaseQuery(async (supabase) => {
    const [cycles, periodDays, predictions, symptoms] = await Promise.all([
      unwrap(supabase.from("cycles").select("period_start").order("period_start")),
      supabase
        .from("period_days")
        .select("day, flow")
        .then((r) => (r.error ? [] : ((r.data ?? []) as { day: string; flow: FlowLevel }[]))),
      supabase
        .from("predictions")
        .select("kind, window_start, window_end, likely_start, likely_end")
        .eq("kind", "period")
        .order("computed_at", { ascending: false })
        .limit(1)
        .then((r) => (r.error ? null : ((r.data?.[0] ?? null) as PredictionRow | null))),
      unwrap(supabase.from("symptom_logs").select("logged_at")),
    ]);

    return {
      starts: (cycles ?? []).map((c) => c.period_start as string),
      periodDays,
      prediction: predictions,
      logDates: ((symptoms ?? []) as { logged_at: string }[]).map((s) => s.logged_at.slice(0, 10)),
    };
  });

  if (query.status === "loading") return <LoadingState label={t("title")} />;
  if (query.status === "error") {
    return (
      <ScreenError
        title={t("title")}
        message={t("loadError")}
        retryLabel={t("retry")}
        onRetry={query.refresh}
      />
    );
  }

  const { starts, periodDays, prediction, logDates } = query.data;

  /**
   * `buildMonthGrid` is used for **layout only** — the week-start rules and the
   * leading/trailing cells are already correct in it and worth reusing. Its own
   * period/window/fertile marking is v1's and is deliberately not passed: the
   * seven day-states come from `dayStates`, which is tier-2 and tested, so the
   * two encodings cannot disagree about what a day is.
   */
  const grid = buildMonthGrid(Number(today.slice(0, 4)), Number(today.slice(5, 7)) - 1, {
    weekStartsOn: weekStartForLocale(locale),
  });
  const dates = grid.weeks.flat().map((cell) => cell.iso);
  const days = dayStates({
    dates,
    periodDays,
    logDates,
    prediction: prediction
      ? {
          windowStart: prediction.window_start,
          windowEnd: prediction.window_end,
          likelyStart: prediction.likely_start,
          likelyEnd: prediction.likely_end,
        }
      : null,
    todayISO: today,
  });

  const selectedDay = days.find((d) => d.date === selected) ?? null;
  // Her own bleeds define the cycle, collapsed the same way every other surface
  // collapses them — one answer to "when did her periods begin" (R3.1.9).
  const cycleDay = currentCycleDay(bleedStarts([...starts]), selected);

  return (
    <AppScreen>
      <h1 className="font-display text-lg text-text">{t("title")}</h1>

      <CalendarMonth days={days} selected={selected} onSelect={setSelected} />

      <Card>
        <CardContent className="flex flex-col gap-2 p-6">
          <h2 className="font-display text-md text-text">
            {format.dateTime(new Date(`${selected}T00:00:00Z`), {
              dateStyle: "long",
              timeZone: "UTC",
            })}
          </h2>

          {cycleDay !== null ? (
            <p className="text-sm text-text-muted">{t("detail.cycleDay", { day: cycleDay })}</p>
          ) : null}

          {selectedDay?.period ? (
            <p className="text-sm text-text">
              {t(`a11y.flow.${selectedDay.period.flow}`)}
            </p>
          ) : null}

          {selectedDay?.predictedLikely ? (
            <p className="text-sm text-text">{t("a11y.likely")}</p>
          ) : selectedDay?.predictedPossible ? (
            <p className="text-sm text-text-muted">{t("a11y.possible")}</p>
          ) : null}

          {selectedDay && !selectedDay.period && !selectedDay.hasLogs ? (
            <p className="text-sm text-text-muted">{t("detail.nothingLogged")}</p>
          ) : null}
        </CardContent>
      </Card>
    </AppScreen>
  );
}

type PredictionRow = {
  window_start: string | null;
  window_end: string | null;
  likely_start: string | null;
  likely_end: string | null;
};
