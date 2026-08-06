"use client";

import { useFormatter, useTranslations } from "next-intl";
import { fertileWindow } from "@/lib/calculators";
import { todayISO } from "@/lib/calculators/dates";
import { predictNextPeriod } from "@/lib/cycle/predict";
import { currentCycleDay, topSymptoms } from "@/lib/cycle/insights";
import { SYMPTOM_GROUPS } from "@/lib/cycle/symptoms";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";
import { PregnancyPanel } from "@/components/pregnancy/pregnancy-panel";
import { MenopausePanel } from "@/components/menopause/menopause-panel";

const KNOWN_SYMPTOMS = new Set<string>(SYMPTOM_GROUPS.flatMap((g) => g.symptoms));
type Mode = "cycle" | "ttc" | "pregnancy" | "menopause";
const TRACK_TO_MODE: Record<string, Mode> = { B: "cycle", C: "ttc", D: "pregnancy", F: "menopause" };

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

    const mode = TRACK_TO_MODE[(state?.track as string) ?? "B"] ?? "cycle";

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

  const prediction = predictNextPeriod(starts);
  const cycleDay = currentCycleDay(starts, today);
  const lastStart = starts.length > 0 ? [...starts].sort().at(-1)! : null;
  const fertile =
    mode === "ttc" && lastStart ? fertileWindow(lastStart, prediction?.averageLength ?? 28) : null;

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
      <div className="flex items-center justify-between gap-3">
        <div className="flex flex-col gap-1">
          <h1 className="font-display text-2xl text-text">{t("title")}</h1>
          <p className="text-sm text-text-muted">{t(`modeLabel.${mode}`)}</p>
        </div>
        <Button asChild variant="accent">
          <Link href="/track">{t("logCta")}</Link>
        </Button>
      </div>

      {/* Pregnancy gets its own dashboard rather than cycle tools plus an apology.
          A cycle-day counter and a next-period prediction are meaningless to someone
          who is pregnant, and the second one is alarming (P1.13b). */}
      {mode === "pregnancy" ? <PregnancyPanel pregnancy={pregnancy} today={today} /> : null}

      {/* Perimenopause/menopause gets its own view too: a next-period prediction is
          the least useful thing to show someone whose cycles are stopping (P1.13c). */}
      {mode === "menopause" ? (
        <MenopausePanel starts={starts} symptomCounts={top} today={today} />
      ) : null}

      {mode === "pregnancy" || mode === "menopause" ? null : (
        <div className="grid gap-4 sm:grid-cols-2">
          <Card>
            <CardContent className="flex min-h-24 flex-col justify-center p-6">
              {cycleDay ? (
                <p className="font-display text-xl text-text">{t("cycleDay", { day: cycleDay })}</p>
              ) : (
                <p className="text-sm text-text-muted">{t("cycleDayUnknown")}</p>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardContent className="flex min-h-24 flex-col gap-1 p-6">
              <p className="text-sm text-text-muted">{t("nextPeriod")}</p>
              {prediction ? (
                <>
                  <p className="font-display text-lg text-text">
                    {t("window", {
                      start: fmt(prediction.windowStart),
                      end: fmt(prediction.windowEnd),
                    })}
                  </p>
                  <p className="text-sm text-text-muted">
                    {t("avgLength", { days: prediction.averageLength })}
                  </p>
                  {prediction.irregular ? (
                    <p className="text-sm text-warning-text">{t("irregularNote")}</p>
                  ) : null}
                </>
              ) : (
                <p className="text-sm text-text-muted">{t("needData")}</p>
              )}
            </CardContent>
          </Card>
        </div>
      )}

      {fertile ? (
        <Card>
          <CardContent className="flex flex-col gap-1 p-6">
            <p className="text-sm text-text-muted">{t("fertileHeading")}</p>
            <p className="font-display text-lg text-text">
              {t("fertileWindow", {
                start: fmt(fertile.windowStart),
                end: fmt(fertile.windowEnd),
              })}
            </p>
          </CardContent>
        </Card>
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
