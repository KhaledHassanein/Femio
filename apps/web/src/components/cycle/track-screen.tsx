"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { fertileWindow } from "@/lib/calculators";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import type { Flow } from "@/lib/cycle/calendar";
import { todayISO } from "@/lib/calculators/dates";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { modeFromTrack } from "@/lib/persona/state";
import { Badge } from "@/components/ui/badge";
import { DateStrip } from "@/components/cycle/date-strip";
import { LogPeriod } from "@/components/cycle/log-period";
import { LogSymptoms } from "@/components/cycle/log-symptoms";
import { CycleCalendar } from "@/components/cycle/cycle-calendar";
import { AppScreen, ScreenError } from "@/components/patterns/app-screen";
import { LoadingState } from "@/components/patterns/loading-state";
import { LogPregnancySymptoms } from "@/components/pregnancy/log-pregnancy-symptoms";
import { MovementCounter } from "@/components/pregnancy/movement-counter";

const KNOWN_SYMPTOMS = new Set<string>(SYMPTOM_GROUPS.flatMap((g) => g.symptoms));

/**
 * The logging screen, reading its own data in the browser (P4.0, ADR-048).
 *
 * Behaviour is unchanged from the server version, including the pregnancy branch:
 * a pregnant user still gets the pregnancy vocabulary with its urgency tiers, and
 * still does not get a next-period prediction or fertile-window overlay, both of
 * which are wrong and one of which is alarming (ADR-047).
 */
export function TrackScreen() {
  const t = useTranslations("track");
  const st = useTranslations("symptoms");
  const today = todayISO();
  // One date for the whole screen: the strip sets it, the period field sets it,
  // and both loggers write against it (P1.28.3).
  const [date, setDate] = useState(today);

  const query = useSupabaseQuery(async (supabase) => {
    const [personaState, cycles, symptoms] = await Promise.all([
      unwrap(supabase.from("persona_state").select("track").maybeSingle()),
      unwrap(
        supabase
          .from("cycles")
          .select("id, period_start, flow")
          .order("period_start", { ascending: false }),
      ),
      unwrap(
        supabase
          .from("symptom_logs")
          .select("id, type, logged_at")
          .order("logged_at", { ascending: false })
          .limit(24),
      ),
    ]);

    const isPregnancy = modeFromTrack(personaState?.track as string | null) === "pregnancy";

    // Only needed to stamp movement sessions with the pregnancy they belong to,
    // so a later pregnancy never inherits an earlier one's pattern.
    const pregnancyId = isPregnancy
      ? ((
          await unwrap(
            supabase
              .from("pregnancy")
              .select("id")
              .eq("status", "active")
              .order("updated_at", { ascending: false })
              .limit(1)
              .maybeSingle(),
          )
        )?.id as string | undefined) ?? null
      : null;

    return {
      // Pregnancy mode gets a different symptom vocabulary and its own urgency
      // handling — asking someone who is pregnant about period cramps is the least
      // of it (P1.13d).
      isPregnancy,
      pregnancyId,
      cycles: (cycles ?? []) as { id: string; period_start: string; flow: Flow | null }[],
      symptoms: (symptoms ?? []) as { id: string; type: string; logged_at: string }[],
    };
  });

  if (query.status === "loading") {
    return (
      <AppScreen busy>
        <LoadingState label={t("loading")} rows={4} />
      </AppScreen>
    );
  }

  if (query.status === "error") {
    return (
      <AppScreen>
        {/* History failed to load — but logging must not be blocked by that. Someone
            with a symptom to record should be able to record it now; the queue will
            carry it either way (P1.14). */}
        <ScreenError
          title={t("title")}
          message={t("loadError")}
          retryLabel={t("retry")}
          onRetry={query.refresh}
        >
          <LogSymptoms date={date} today={today} />
        </ScreenError>
      </AppScreen>
    );
  }

  const { isPregnancy, pregnancyId, cycles, symptoms } = query.data;
  const stItem = st as unknown as (key: string) => string;
  const symptomLabel = (type: string) =>
    KNOWN_SYMPTOMS.has(type) ? stItem(`items.${type}`) : type;
  const starts = cycles.map((c) => c.period_start);
  const periodDays = cycles.map((c) => ({ date: c.period_start, flow: c.flow ?? null }));
  const prediction = predictNextPeriod(starts);
  // Fertile-window awareness (conception planning only — never contraception).
  const lastStart = starts[0] ?? null;
  const fertile = lastStart ? fertileWindow(lastStart, prediction?.averageLength ?? 28) : null;

  return (
    <AppScreen>
      <h1 className="font-display text-lg text-text">{t("title")}</h1>

      {/* The day strip is above every logging control, because picking the day is
          the first thing you do and it used to be a date field buried mid-form.
          Pregnancy mode has its own date handling inside the movement counter and
          keeps the strip for symptoms. */}
      <DateStrip
        selected={date}
        today={today}
        markedDays={new Set(starts)}
        onSelect={setDate}
        label={t("dateStripLabel")}
      />

      {isPregnancy ? <MovementCounter pregnancyId={pregnancyId} /> : null}

      {isPregnancy ? (
        <LogPregnancySymptoms date={date} today={today} onSaved={query.refresh} />
      ) : (
        <LogSymptoms date={date} today={today} onSaved={query.refresh} />
      )}

      {isPregnancy ? null : (
        <LogPeriod date={date} onDateChange={setDate} onSaved={query.refresh} />
      )}

      <section className="flex flex-col gap-3">
        <h2 className="text-md font-semibold text-text">{st("recentHeading")}</h2>
        {symptoms.length > 0 ? (
          <div className="flex flex-wrap gap-2">
            {symptoms.map((s) => (
              <Badge key={s.id} variant="primary">
                {symptomLabel(s.type)}
              </Badge>
            ))}
          </div>
        ) : (
          <p className="text-sm text-text-muted">{st("recentEmpty")}</p>
        )}
      </section>

      {/* The cycle calendar overlays predicted-period and fertile-window bands, both of
          which are wrong for a pregnancy. Past periods stay visible in history. */}
      {isPregnancy ? null : starts.length > 0 ? (
        <CycleCalendar
          periods={periodDays}
          windowStart={prediction?.windowStart ?? null}
          windowEnd={prediction?.windowEnd ?? null}
          fertileStart={fertile?.windowStart ?? null}
          fertileEnd={fertile?.windowEnd ?? null}
          ovulation={fertile?.ovulation ?? null}
          today={today}
        />
      ) : (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("history.heading")}</h2>
          <p className="text-sm text-text-muted">{t("history.empty")}</p>
        </section>
      )}
    </AppScreen>
  );
}
