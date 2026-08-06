"use client";

import { useFormatter, useTranslations } from "next-intl";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { fertileWindow } from "@/lib/calculators";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import type { Flow } from "@/lib/cycle/calendar";
import { todayISO } from "@/lib/calculators/dates";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { LogPeriod } from "@/components/cycle/log-period";
import { LogSymptoms } from "@/components/cycle/log-symptoms";
import { CycleCalendar } from "@/components/cycle/cycle-calendar";
import { LogPregnancySymptoms } from "@/components/pregnancy/log-pregnancy-symptoms";

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
  const format = useFormatter();

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

    return {
      // Pregnancy mode gets a different symptom vocabulary and its own urgency
      // handling — asking someone who is pregnant about period cramps is the least
      // of it (P1.13d).
      isPregnancy: (personaState?.track as string | undefined) === "D",
      cycles: (cycles ?? []) as { id: string; period_start: string; flow: Flow | null }[],
      symptoms: (symptoms ?? []) as { id: string; type: string; logged_at: string }[],
    };
  });

  if (query.status === "loading") {
    return (
      <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12" aria-busy="true">
        <div className="h-8 w-32 animate-pulse rounded-md bg-surface-sunken" />
        <div className="h-28 animate-pulse rounded-md bg-surface-sunken" />
        <div className="h-40 animate-pulse rounded-md bg-surface-sunken" />
      </main>
    );
  }

  if (query.status === "error") {
    return (
      <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        {/* History failed to load — but logging must not be blocked by that. Someone
            with a symptom to record should be able to record it now; the queue will
            carry it either way (P1.14). */}
        <Alert variant="danger">
          <AlertDescription className="flex flex-col items-start gap-3">
            <span>{t("loadError")}</span>
            <Button variant="outline" onClick={query.refresh}>
              {t("retry")}
            </Button>
          </AlertDescription>
        </Alert>
        <LogSymptoms />
      </main>
    );
  }

  const { isPregnancy, cycles, symptoms } = query.data;
  const stItem = st as unknown as (key: string) => string;
  const symptomLabel = (type: string) =>
    KNOWN_SYMPTOMS.has(type) ? stItem(`items.${type}`) : type;
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  const starts = cycles.map((c) => c.period_start);
  const periodDays = cycles.map((c) => ({ date: c.period_start, flow: c.flow ?? null }));
  const prediction = predictNextPeriod(starts);
  // Fertile-window awareness (conception planning only — never contraception).
  const lastStart = starts[0] ?? null;
  const fertile = lastStart ? fertileWindow(lastStart, prediction?.averageLength ?? 28) : null;

  const confidenceText = prediction
    ? prediction.confidence === "high"
      ? t("prediction.confidenceHigh", { count: prediction.cyclesAnalyzed })
      : prediction.confidence === "medium"
        ? t("prediction.confidenceMedium", { count: prediction.cyclesAnalyzed })
        : t("prediction.confidenceLow")
    : null;

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <h1 className="font-display text-2xl text-text">{t("title")}</h1>

      {/* A next-period prediction is meaningless to someone who is pregnant, and
          alarming besides — the same reason the dashboard hides it (P1.13b). */}
      {isPregnancy ? null : (
        <section>
          <h2 className="mb-2 text-md font-semibold text-text">{t("prediction.heading")}</h2>
          {prediction ? (
            <div className="flex flex-col gap-2 rounded-md border border-dashed border-border bg-surface-sunken p-4">
              <p className="font-display text-lg text-text">
                {t("prediction.window", {
                  start: fmt(prediction.windowStart),
                  end: fmt(prediction.windowEnd),
                })}
              </p>
              <p className="text-sm text-text-muted">
                {t("prediction.averageLength", { days: prediction.averageLength })}
              </p>
              <p className="text-sm text-text-muted">{confidenceText}</p>
              {prediction.irregular ? (
                <p className="text-sm text-warning-text">{t("prediction.irregularNote")}</p>
              ) : null}
            </div>
          ) : (
            <p className="text-sm text-text-muted">{t("prediction.needMore")}</p>
          )}
        </section>
      )}

      {isPregnancy ? <LogPregnancySymptoms /> : <LogSymptoms />}

      {isPregnancy ? null : <LogPeriod />}

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
          today={todayISO()}
        />
      ) : (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("history.heading")}</h2>
          <p className="text-sm text-text-muted">{t("history.empty")}</p>
        </section>
      )}
    </main>
  );
}
