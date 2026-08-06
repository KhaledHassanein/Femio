"use client";

import { useFormatter, useTranslations } from "next-intl";
import { buildVisitSummary } from "@/lib/account/visit-summary";
import { KNOWN_SYMPTOMS } from "@/lib/cycle/symptoms";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { PrintButton } from "@/components/account/print-button";
import { Link } from "@/i18n/navigation";

const TRACK_TO_MODE: Record<string, string> = {
  B: "cycle",
  C: "ttc",
  D: "pregnancy",
  F: "menopause",
};

/**
 * The visit summary, client-rendered so it can run without a server (P4.0, ADR-048).
 *
 * This is the screen where a failed read matters most: it is printed and taken to an
 * appointment. A summary that silently omits a section because a query errored would
 * be a document that misrepresents her record to a clinician, so every read goes
 * through `unwrap` and any failure replaces the page rather than thinning it.
 */
export function SummaryScreen() {
  const t = useTranslations("visitSummary");
  const ts = useTranslations("symptoms");
  const tflow = useTranslations("track.flow");
  const format = useFormatter();

  const query = useSupabaseQuery(async (supabase) => {
    const [state, cycles, symptoms, meds, conditions, keyDates] = await Promise.all([
      unwrap(supabase.from("persona_state").select("track").maybeSingle()),
      unwrap(
        supabase
          .from("cycles")
          .select("period_start, flow")
          .order("period_start", { ascending: false }),
      ),
      unwrap(
        supabase
          .from("symptom_logs")
          .select("type, severity, logged_at")
          .order("logged_at", { ascending: false }),
      ),
      unwrap(supabase.from("meds_supplements").select("name, active")),
      unwrap(supabase.from("conditions_flagged").select("condition_code, source")),
      unwrap(
        supabase.from("key_dates").select("label, date, display_pref").order("date", {
          ascending: false,
        }),
      ),
    ]);

    return buildVisitSummary(
      {
        cycles: cycles ?? [],
        symptoms: symptoms ?? [],
        meds: meds ?? [],
        conditions: conditions ?? [],
        keyDates: keyDates ?? [],
        track: (state?.track as string) ?? null,
      },
      new Date().toISOString(),
    );
  });

  if (query.status === "loading") {
    return (
      <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12" aria-busy="true">
        <div className="h-8 w-56 animate-pulse rounded-md bg-surface-sunken" />
        <div className="h-32 animate-pulse rounded-md bg-surface-sunken" />
        <div className="h-32 animate-pulse rounded-md bg-surface-sunken" />
      </main>
    );
  }

  if (query.status === "error") {
    return (
      <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12">
        <h1 className="font-display text-2xl text-text">{t("title")}</h1>
        {/* Deliberately replaces the summary rather than rendering a partial one. A
            printed record with a section silently missing is worse than no record. */}
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

  const summary = query.data;
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });
  const tsItem = ts as unknown as (key: string) => string;
  const symptomLabel = (type: string) => (KNOWN_SYMPTOMS.has(type) ? tsItem(`items.${type}`) : type);
  const severityLabel = (sev: number | null) => (sev ? tsItem(`severity.${sev}`) : "—");
  const flowLabel = (flow: string | null) => {
    if (!flow) return "—";
    try {
      return (tflow as unknown as (k: string) => string)(flow);
    } catch {
      return flow;
    }
  };
  const mode = summary.track ? (TRACK_TO_MODE[summary.track] ?? null) : null;

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-6 px-6 py-12 print:py-4">
      <div className="flex items-start justify-between gap-4">
        <div className="flex flex-col gap-1">
          <h1 className="font-display text-2xl text-text">{t("title")}</h1>
          <p className="text-sm text-text-muted">
            {t("generatedOn", {
              date: format.dateTime(new Date(summary.generatedAt), { dateStyle: "long" }),
            })}
            {mode ? ` · ${t(`modes.${mode}`)}` : ""}
          </p>
        </div>
        <PrintButton />
      </div>

      {/* Cycle */}
      <section className="flex flex-col gap-2">
        <h2 className="text-md font-semibold text-text">{t("cycleHeading")}</h2>
        {summary.cycle.logged > 0 ? (
          <>
            <p className="text-sm text-text">
              {t("cycleLogged", { count: summary.cycle.logged })}
              {summary.cycle.lastPeriod
                ? ` · ${t("lastPeriod", { date: fmt(summary.cycle.lastPeriod) })}`
                : ""}
            </p>
            {summary.cycle.averageLength ? (
              <p className="text-sm text-text-muted">
                {t("averageLength", { days: summary.cycle.averageLength })}
                {summary.cycle.rangeLow != null && summary.cycle.rangeHigh != null
                  ? ` · ${t("range", { low: summary.cycle.rangeLow, high: summary.cycle.rangeHigh })}`
                  : ""}
              </p>
            ) : null}
            {summary.cycle.recent.length > 0 ? (
              <table className="mt-1 w-full max-w-sm text-start text-sm">
                <thead>
                  <tr className="text-text-muted">
                    <th scope="col" className="py-1 text-start font-medium">
                      {t("colDate")}
                    </th>
                    <th scope="col" className="py-1 text-start font-medium">
                      {t("colFlow")}
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {summary.cycle.recent.map((c, i) => (
                    <tr key={`${c.start}-${i}`} className="border-t border-border">
                      <td className="py-1 text-text">{fmt(c.start)}</td>
                      <td className="py-1 text-text-muted">{flowLabel(c.flow)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            ) : null}
          </>
        ) : (
          <p className="text-sm text-text-muted">{t("noneLogged")}</p>
        )}
      </section>

      {/* Symptoms */}
      {summary.symptoms.length > 0 ? (
        <section className="flex flex-col gap-2">
          <h2 className="text-md font-semibold text-text">{t("symptomsHeading")}</h2>
          <table className="w-full max-w-md text-start text-sm">
            <thead>
              <tr className="text-text-muted">
                <th scope="col" className="py-1 text-start font-medium">
                  {t("colSymptom")}
                </th>
                <th scope="col" className="py-1 text-start font-medium">
                  {t("colIntensity")}
                </th>
                <th scope="col" className="py-1 text-start font-medium">
                  {t("colDate")}
                </th>
              </tr>
            </thead>
            <tbody>
              {summary.symptoms.map((s, i) => (
                <tr key={`${s.type}-${i}`} className="border-t border-border">
                  <td className="py-1 text-text">{symptomLabel(s.type)}</td>
                  <td className="py-1 text-text-muted">{severityLabel(s.severity)}</td>
                  <td className="py-1 text-text-muted">{fmt(s.date)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      ) : null}

      {/* Medications & supplements */}
      {summary.meds.length > 0 ? (
        <section className="flex flex-col gap-2">
          <h2 className="text-md font-semibold text-text">{t("medsHeading")}</h2>
          <ul className="flex flex-col gap-1 text-sm text-text">
            {summary.meds.map((m, i) => (
              <li key={`${m.name}-${i}`}>
                {m.name}
                {m.active ? "" : ` · ${t("inactive")}`}
              </li>
            ))}
          </ul>
        </section>
      ) : null}

      {/* Flagged conditions (self-reported, non-diagnostic) */}
      {summary.conditions.length > 0 ? (
        <section className="flex flex-col gap-2">
          <h2 className="text-md font-semibold text-text">{t("conditionsHeading")}</h2>
          <ul className="flex flex-col gap-1 text-sm text-text">
            {summary.conditions.map((c, i) => (
              <li key={`${c.code}-${i}`}>
                {c.code} · {t(`conditionSource.${c.source}`)}
              </li>
            ))}
          </ul>
          <p className="text-2xs text-text-subtle">{t("conditionsNote")}</p>
        </section>
      ) : null}

      {/* Key dates */}
      {summary.keyDates.length > 0 ? (
        <section className="flex flex-col gap-2">
          <h2 className="text-md font-semibold text-text">{t("keyDatesHeading")}</h2>
          <ul className="flex flex-col gap-1 text-sm text-text">
            {summary.keyDates.map((k, i) => (
              <li key={`${k.date}-${i}`}>
                {fmt(k.date)}
                {k.label ? ` · ${k.label}` : ""}
              </li>
            ))}
          </ul>
        </section>
      ) : null}

      <p className="border-t border-border pt-4 text-2xs text-text-subtle">{t("disclaimer")}</p>

      <Link href="/settings" className="text-sm text-text-link underline print:hidden">
        {t("backToSettings")}
      </Link>
    </main>
  );
}
