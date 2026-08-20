"use client";

import { useFormatter, useTranslations } from "next-intl";
import { fertileWindow } from "@/lib/calculators";
import { todayISO } from "@/lib/calculators/dates";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { predictionBand } from "@/lib/ui/range-band";
import { currentCycleDay, topSymptoms } from "@/lib/cycle/insights";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { loadExperienceConfig } from "@/lib/experience/client";
import { modeFromTrack, showsCyclePredictions, type PersonaMode } from "@/lib/persona/state";
import { Badge } from "@/components/ui/badge";
import { PregnancyExperience } from "@/components/experience/pregnancy-experience";
import { PostpartumExperience } from "@/components/experience/postpartum-experience";
import { TeenExperience } from "@/components/experience/teen-experience";
import { PersonaOffer } from "@/components/experience/persona-offer";
import { CycleExperience } from "@/components/experience/cycle-experience";
import { QuickLogButton } from "@/components/experience/quick-log-button";
import { TtcExperience } from "@/components/experience/ttc-experience";
import { MenopausePanel } from "@/components/menopause/menopause-panel";
import { HeroCard } from "@/components/ui/hero-card";
import { AppScreen, ScreenError } from "@/components/patterns/app-screen";
import { LoadingState } from "@/components/patterns/loading-state";

const KNOWN_SYMPTOMS = new Set<string>(SYMPTOM_GROUPS.flatMap((g) => g.symptoms));

type Pregnancy = {
  id: string;
  edd: string | null;
  status: string;
  /** The day it ended, as she recorded it (migration 0009). Null is normal. */
  ended_on: string | null;
} | null;

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
    const [state, cycles, symptoms, experience] = await Promise.all([
      unwrap(supabase.from("persona_state").select("track").maybeSingle()),
      unwrap(
        // `flow` comes back for `cycle.flowStrip` (R1.9i). It was not selected
        // before, which is why that module had no data to render and sat listed.
        supabase
          .from("cycles")
          .select("period_start, flow")
          .order("period_start", { ascending: false }),
      ),
      unwrap(
        supabase
          .from("symptom_logs")
          .select("type")
          .order("logged_at", { ascending: false })
          .limit(200),
      ),
      /**
       * The experience document, served rather than built here (R2.4, ADR-060).
       *
       * `persona_id`, `modifiers` and `emotional_context` used to be read straight
       * off `persona_state` and turned into a config inside the pregnancy screen.
       * Now tier 1 resolves them — on the Edge Function, or by the identical local
       * fallback — and the screens render what comes back. This is the last place
       * the dashboard has an opinion about who she is.
       */
      loadExperienceConfig(supabase, { today }),
    ]);

    const mode: PersonaMode = modeFromTrack(state?.track as string | null);

    // Only the pregnancy dashboard needs this, and only one pregnancy is active at a time.
    const pregnancy: Pregnancy =
      mode === "pregnancy"
        ? await unwrap(
            supabase
              .from("pregnancy")
              .select("id, edd, status, ended_on")
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
      config: experience?.config ?? null,
      track: (state?.track as string | null) ?? null,
      starts: (cycles ?? []).map((c) => c.period_start as string),
      /** Newest first, capped in the module. Her own entries, never interpreted. */
      recentPeriods: (cycles ?? []).map((c) => ({
        date: c.period_start as string,
        flow: (c as { flow: string | null }).flow,
      })),
      top: topSymptoms(((symptoms ?? []) as { type: string }[]).map((s) => s.type)),
    };
  });

  if (query.status === "loading") {
    return (
      <AppScreen busy>
        <LoadingState label={t("loading")} />
      </AppScreen>
    );
  }

  if (query.status === "error") {
    // Never an empty dashboard on a failed read — see `ScreenError` (ADR-046).
    return (
      <AppScreen>
        <ScreenError
          title={t("title")}
          message={t("loadError")}
          retryLabel={t("retry")}
          onRetry={query.refresh}
        />
      </AppScreen>
    );
  }

  const { mode, pregnancy, starts, top, config, recentPeriods } = query.data;
  const stItem = st as unknown as (key: string) => string;
  const symptomLabel = (type: string) =>
    KNOWN_SYMPTOMS.has(type) ? stItem(`items.${type}`) : type;
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
  // Computed for anyone with a cycle history, and *rendered* only where a persona
  // contributes `ttc.window` (R1.9c). Gating the arithmetic on `mode === "ttc"` put
  // the decision in the screen; the registry holds it now.
  const fertile = lastStart ? fertileWindow(lastStart, prediction?.averageLength ?? 28) : null;

  // The band draws the range the prediction already returns; when the geometry
  // can't be computed the sentence stands on its own (lib/ui/range-band.ts).
  const periodBand =
    lastStart && prediction
      ? predictionBand({
          axisStart: lastStart,
          windowStart: prediction.windowStart,
          windowEnd: prediction.windowEnd,
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
    <AppScreen>
      {/* A compact title row, not a masthead. At 36px display type "Your dashboard"
          wrapped to two lines on a 390px screen and pushed the answer below it —
          the brand bar above already says where you are, so the heading's job here
          is orientation and an h1, nothing more. */}
      <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <Badge variant="primary">{t(`modeLabel.${mode}`)}</Badge>
      </div>

      {/* Progressive personalization (P1.27.5). Only ever appears in the generic
          state, names a life stage rather than a persona, and says it is
          reversible before she taps. `runnerUp` has been computed since ADR-057
          and rendered by nothing until now. */}
      <PersonaOffer config={config} />

      {/* Track C, rendered from the served document (R1.9c). The fertile-window
          hero and the charting link were two `mode === "ttc"` branches; which woman
          sees them is now her persona's contribution, not a string comparison. */}
      <TtcExperience config={config} fertile={fertile} lastStart={lastStart} today={today} />

      {showsCyclePredictions(mode) && mode !== "ttc" ? (
        <HeroCard
          tone="brand"
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

      {/* Track A, reachable at last (R2.5c). Before this a 13-year-old fell through
          to `general` and got the adult cycle dashboard — a confident-looking
          window and an average-length card, with none of the reassurance A2 §B
          says is the whole value at this age. The window she does get is wide and
          explains itself; A1 gets none, because she is not cycling yet. */}
      {mode === "teen" ? (
        <TeenExperience
          config={config}
          prediction={prediction}
          lastStart={lastStart}
          today={today}
        />
      ) : null}

      {/* Pregnancy gets its own dashboard rather than cycle tools plus an apology.
          A cycle-day counter and a next-period prediction are meaningless to someone
          who is pregnant, and the second one is alarming (P1.13b). */}
      {mode === "pregnancy" ? (
        <PregnancyExperience pregnancy={pregnancy} today={today} config={config} />
      ) : null}

      {/* Perimenopause/menopause gets its own view too: a next-period prediction is
          the least useful thing to show someone whose cycles are stopping (P1.13c). */}
      {/* Track E, reachable at last (R2.5). Before this it fell through to
          `general`, which predicts a period from cycles that stopped months ago. */}
      {mode === "postpartum" ? (
        <PostpartumExperience
          config={config}
          // The real delivery date when she gave one (migration 0009). Null stays
          // null: the follow-up card then lists the checks without claiming to know
          // where she is in them, which is the honest answer rather than a guess
          // built on `updated_at`.
          birthDateISO={pregnancy?.ended_on ?? null}
          todayISO={today}
        />
      ) : null}

      {mode === "menopause" ? (
        <MenopausePanel starts={starts} symptomCounts={top} today={today} config={config} />
      ) : null}

      {/* The primary action, full width and inside thumb reach. It used to be a
          small button beside the title, in the hardest corner of the screen to
          hit one-handed — and logging is the whole daily interaction. It sits
          *after* the panels so every mode leads with its answer rather than with
          a button (P1.28.4).

          Suppressed when the engine already placed a `quickLog` module, which it
          does for pregnancy and postpartum: since R2.3 both screens have rendered
          their own accent "Log" button and then this one immediately below it, two
          identical full-width CTAs stacked. Found while adding Track A, which would
          have inherited it. The test is the served document rather than the mode —
          a mode list here would go stale the next time a registry row changes. */}
      {config?.home.modules.some((m) => m.id === "quickLog") ? null : <QuickLogButton />}

      {/* R1.9a. Track B's two supporting modules, rendered from the served document
          by id rather than composed here. The hand-written pair this replaces drew
          an average-length card off `showsCyclePredictions` and a next-period card
          off `mode === "ttc"` — two mode checks deciding, between them, whether
          Femio was willing to predict for her. That decision is tier 1's, and it is
          now expressed as *which module her persona contributes*: `cycle.window`
          predicts, `cycle.variability` shows her own lengths and declines to, and
          B5 (irregular cycles) contributes only the second. Renders nothing when
          the document carries neither, which is why the block below is unchanged. */}
      <CycleExperience
        config={config}
        prediction={prediction}
        lastStart={lastStart}
        today={today}
        topSymptoms={top}
        symptomLabel={symptomLabel}
        cycleDay={cycleDay}
        recentPeriods={recentPeriods}
      />
    </AppScreen>
  );
}
