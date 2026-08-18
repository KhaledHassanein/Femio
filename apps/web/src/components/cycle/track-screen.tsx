"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { fertileWindow } from "@/lib/calculators";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import type { Flow } from "@/lib/cycle/calendar";
import { todayISO } from "@/lib/calculators/dates";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { modeFromTrack, showsCyclePredictions } from "@/lib/persona/state";
import { loadExperienceConfig } from "@/lib/experience/client";
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

/** The phases whose symptom vocabulary is the pregnancy one, as in `pregnancy-experience`. */
const PREGNANT_PHASES = new Set(["t1", "t2", "t3"]);

/**
 * The logging screen, reading its own data in the browser (P4.0, ADR-048).
 *
 * ## It renders the served document now (R2.10)
 *
 * `ExperienceConfig.tools` has been a real field of twelve `LogKind`s since R2.2 and
 * **no screen had ever read it** — this one branched on `isPregnancy` five times
 * instead, which is the write-only shape `docs/23` §3.1 opened this workstream with,
 * surviving one screen longer than the dashboard. A persona now decides which
 * loggers she is offered by contributing them, exactly as it decides her modules.
 *
 * **Two served fields drive this screen, and collapsing them into one would be a
 * regression.** `tools` says which loggers to surface; `showsCyclePredictions` says
 * whether a prediction may be drawn. E1 (postpartum) offers `period` — she needs to
 * record the return of her cycle — and must never be shown a next-period band built
 * on cycles that have not returned. One check could not express both, and the
 * invented-window defect (ADR-041/042, R2.5) is what it would cost.
 *
 * The symptom *vocabulary* is a third question and keys on `phase`, not on `tools`:
 * asking someone who is pregnant about period cramps is the least of it (P1.13d),
 * and phase is the served field that already means "where she is in a pregnancy".
 */
export function TrackScreen() {
  const t = useTranslations("track");
  const st = useTranslations("symptoms");
  const today = todayISO();
  // One date for the whole screen: the strip sets it, the period field sets it,
  // and both loggers write against it (P1.28.3).
  const [date, setDate] = useState(today);

  const query = useSupabaseQuery(async (supabase) => {
    const [personaState, cycles, symptoms, experience] = await Promise.all([
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
      // Served rather than built here (R2.4): the same document the dashboard renders.
      loadExperienceConfig(supabase, { today }),
    ]);

    const mode = modeFromTrack(personaState?.track as string | null);

    // Only needed to stamp movement sessions with the pregnancy they belong to,
    // so a later pregnancy never inherits an earlier one's pattern.
    /**
     * The active pregnancy, read unconditionally rather than behind a mode check.
     *
     * It is needed to stamp movement sessions so a later pregnancy never inherits
     * an earlier one's pattern — and asking for it is a question about her record,
     * not about which life stage the app has filed her under. The first version of
     * this gated the query on `mode === "pregnancy"`, and `persona-branch-lint`
     * rejected it, correctly: the fix belonged in the layer, not in the rule.
     */
    const pregnancyId =
      ((
        await unwrap(
          supabase
            .from("pregnancy")
            .select("id")
            .eq("status", "active")
            .order("updated_at", { ascending: false })
            .limit(1)
            .maybeSingle(),
        )
      )?.id as string | undefined) ?? null;

    /**
     * What the engine says to surface. A missing document is the honest fallback,
     * not an empty screen: logging must never depend on the Edge Function being
     * reachable, so an absent config keeps every logger rather than none.
     */
    const config = experience?.config ?? null;
    const tools: readonly string[] = config?.tools ?? [
      "symptom",
      "period",
      "movement",
    ];
    const pregnantPhase = config?.phase != null && PREGNANT_PHASES.has(config.phase);

    return {
      tools,
      // The vocabulary question, kept separate from the tool question (P1.13d).
      // With no served document — offline, or signed out mid-session — an active
      // pregnancy row is the honest stand-in for the phase, and it is hers.
      pregnantPhase: pregnantPhase || (config === null && pregnancyId !== null),
      predictions: showsCyclePredictions(mode),
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

  const { tools, pregnantPhase, predictions, pregnancyId, cycles, symptoms } = query.data;
  const offers = (kind: string) => tools.includes(kind);
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

      {offers("movement") ? <MovementCounter pregnancyId={pregnancyId} /> : null}

      {pregnantPhase ? (
        <LogPregnancySymptoms date={date} today={today} onSaved={query.refresh} />
      ) : (
        <LogSymptoms date={date} today={today} onSaved={query.refresh} />
      )}

      {offers("period") ? (
        <LogPeriod date={date} onDateChange={setDate} onSaved={query.refresh} />
      ) : null}

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

      {/* The overlays are a *prediction*, so they key on `showsCyclePredictions` and
          not on whether she is offered a period log. E1 is the case that separates
          them: she logs periods to record their return, and a next-period band built
          on cycles that have not returned is the invented window ADR-041/042 exists
          to stop. Past periods stay visible either way. */}
      {predictions && starts.length > 0 ? (
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
