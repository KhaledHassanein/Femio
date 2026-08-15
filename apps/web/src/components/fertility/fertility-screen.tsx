"use client";

import { useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { todayISO } from "@/lib/calculators/dates";
import {
  bbtChart,
  CM_TYPES,
  isEmptyEntry,
  OPK_RESULTS,
  recentFirst,
  unitOf,
  type CmType,
  type FertilityEntry,
  type OpkResult,
} from "@/lib/fertility";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { chipVariants } from "@/components/ui/chip";
import { AppScreen, ScreenError } from "@/components/patterns/app-screen";
import { LoadingState } from "@/components/patterns/loading-state";

/**
 * The TTC toolkit (P2.1) — BBT, OPK and cervical mucus.
 *
 * `public.fertility_logs` has existed since schema v1 with nothing writing to it
 * (`docs/23` §3.2). Its schema comment states the guardrail this screen is built
 * around: *fertile-window is conception awareness, never contraception.*
 *
 * ## What the chart does and does not say
 *
 * It draws her temperatures. It draws nothing else — no shift line, no "ovulation
 * day", no shaded fertile band, no colour that means anything. `lib/fertility`
 * cannot produce those and this screen could not render them if it wanted to.
 *
 * That is not caution for its own sake. A thermal-shift reading is a clinical
 * inference from a home measurement (product rule 1), and the feature everyone
 * builds next on top of one is "days you could avoid" — which is the medical-device
 * line *and* the contraception line in a single step. Her own numbers, drawn
 * honestly, next to the OPK result she read off the stick herself, is the whole
 * product here. Interpretation is hers and her clinician's.
 *
 * ## Not a TTC-only screen
 *
 * Reachable from Settings in every mode, like appointments. Someone tracking
 * temperature through perimenopause, or charting before a fertility appointment
 * without calling herself "trying", is not served by a feature locked behind a
 * mode (product rule 2).
 */

type Draft = {
  loggedAt: string;
  bbt: string;
  opk: OpkResult | null;
  cm: CmType | null;
  intercourse: boolean;
};

export function FertilityScreen() {
  const t = useTranslations("fertility");
  const format = useFormatter();
  const today = todayISO();

  const [draft, setDraft] = useState<Draft>({
    loggedAt: today,
    bbt: "",
    opk: null,
    cm: null,
    intercourse: false,
  });
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);

  const query = useSupabaseQuery(async (supabase) => {
    const [logs, cycles] = await Promise.all([
      unwrap(
        supabase
          .from("fertility_logs")
          .select("id, logged_at, bbt, opk_result, cm_type, intercourse")
          .order("logged_at", { ascending: false })
          .limit(120),
      ),
      unwrap(
        supabase
          .from("cycles")
          .select("period_start")
          .order("period_start", { ascending: false })
          .limit(1),
      ),
    ]);

    const entries = ((logs ?? []) as Record<string, unknown>[]).map(
      (r): FertilityEntry => ({
        id: r.id as string,
        loggedAt: r.logged_at as string,
        bbt: r.bbt === null || r.bbt === undefined ? null : Number(r.bbt),
        opk: (r.opk_result as OpkResult | null) ?? null,
        cm: (r.cm_type as CmType | null) ?? null,
        intercourse: (r.intercourse as boolean | null) ?? null,
      }),
    );
    const cycleStart = ((cycles ?? [])[0]?.period_start as string | undefined) ?? null;
    return { entries, cycleStart };
  });

  const save = async () => {
    setSaving(true);
    setError(null);
    setSaved(false);

    const bbtValue = draft.bbt.trim() === "" ? null : Number(draft.bbt);
    if (bbtValue !== null && (Number.isNaN(bbtValue) || unitOf(bbtValue) === null)) {
      // A chart built on a typo is worse than a missing day.
      setError(t("invalidBbt"));
      setSaving(false);
      return;
    }
    if (isEmptyEntry({ bbt: bbtValue, opk: draft.opk, cm: draft.cm, intercourse: draft.intercourse })) {
      setError(t("nothingToSave"));
      setSaving(false);
      return;
    }

    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      setSaving(false);
      setError(t("saveFailed"));
      return;
    }

    const { error: insertError } = await supabase.from("fertility_logs").insert({
      profile_id: session.user.id,
      logged_at: draft.loggedAt,
      bbt: bbtValue,
      opk_result: draft.opk,
      cm_type: draft.cm,
      intercourse: draft.intercourse || null,
    });

    setSaving(false);
    if (insertError) {
      setError(t("saveFailed"));
      return;
    }
    setDraft({ loggedAt: today, bbt: "", opk: null, cm: null, intercourse: false });
    setSaved(true);
    query.refresh();
  };

  if (query.status === "loading") {
    return (
      <AppScreen busy>
        <LoadingState label={t("loading")} />
      </AppScreen>
    );
  }

  if (query.status === "error") {
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

  const { entries, cycleStart } = query.data;
  const chart = bbtChart(entries, cycleStart);
  const list = recentFirst(entries).slice(0, 30);
  const fmt = (iso: string) =>
    format.dateTime(new Date(`${iso}T00:00:00Z`), { dateStyle: "medium", timeZone: "UTC" });

  return (
    <AppScreen>
      <h1 className="font-display text-lg text-text">{t("title")}</h1>

      {/* Said at the top, not buried: this is awareness, and it is never a way to
          avoid pregnancy. The schema has carried that sentence since v1; this is
          the first screen that can say it to her. */}
      <Alert variant="info">
        <AlertDescription>{t("boundary")}</AlertDescription>
      </Alert>

      <Card>
        <CardContent className="flex flex-col gap-4 p-5">
          <h2 className="text-md font-semibold text-text">{t("log.heading")}</h2>

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="fertility-date">{t("log.date")}</Label>
            <Input
              id="fertility-date"
              type="date"
              max={today}
              value={draft.loggedAt}
              onChange={(e) => setDraft({ ...draft, loggedAt: e.target.value })}
            />
          </div>

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="fertility-bbt">{t("log.bbt")}</Label>
            <Input
              id="fertility-bbt"
              type="number"
              inputMode="decimal"
              step="0.01"
              placeholder={t("log.bbtPlaceholder")}
              value={draft.bbt}
              onChange={(e) => setDraft({ ...draft, bbt: e.target.value })}
            />
            <p className="text-2xs text-text-subtle">{t("log.bbtHint")}</p>
          </div>

          <fieldset className="flex flex-col gap-2">
            <legend className="text-sm font-medium text-text">{t("log.opk")}</legend>
            <p className="text-2xs text-text-subtle">{t("log.opkHint")}</p>
            <div className="flex flex-wrap gap-2">
              {OPK_RESULTS.map((result) => (
                <button
                  key={result}
                  type="button"
                  aria-pressed={draft.opk === result}
                  onClick={() => setDraft({ ...draft, opk: draft.opk === result ? null : result })}
                  className={chipVariants({ selected: draft.opk === result })}
                >
                  {t(`opk.${result}`)}
                </button>
              ))}
            </div>
          </fieldset>

          <fieldset className="flex flex-col gap-2">
            <legend className="text-sm font-medium text-text">{t("log.cm")}</legend>
            <div className="flex flex-wrap gap-2">
              {CM_TYPES.map((type) => (
                <button
                  key={type}
                  type="button"
                  aria-pressed={draft.cm === type}
                  onClick={() => setDraft({ ...draft, cm: draft.cm === type ? null : type })}
                  className={chipVariants({ selected: draft.cm === type })}
                >
                  {t(`cm.${type}`)}
                </button>
              ))}
            </div>
          </fieldset>

          <label className="flex min-h-11 cursor-pointer items-center gap-3 text-sm text-text">
            <input
              type="checkbox"
              className="size-5 shrink-0 accent-primary-solid"
              checked={draft.intercourse}
              onChange={(e) => setDraft({ ...draft, intercourse: e.target.checked })}
            />
            <span>{t("log.intercourse")}</span>
          </label>

          {error ? (
            <Alert variant="danger">
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          ) : null}
          {saved ? (
            <Alert variant="success">
              <AlertDescription>{t("saved")}</AlertDescription>
            </Alert>
          ) : null}

          <Button onClick={save} disabled={saving} variant="accent" className="w-full">
            {saving ? t("saving") : t("save")}
          </Button>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="flex flex-col gap-3 p-5">
          <h2 className="text-md font-semibold text-text">{t("chart.heading")}</h2>
          {chart ? (
            <>
              {/* Dots and an axis. No line of best fit, no shift marker, no shaded
                  band — the chart shows her numbers and says nothing about them. */}
              <div
                className="relative h-40 w-full rounded-md border border-border bg-surface-sunken"
                role="img"
                aria-label={t("chart.alt", { count: chart.points.length })}
              >
                {chart.points.map((point, index) => (
                  <span
                    key={point.entryId}
                    className="absolute size-2 -translate-x-1/2 translate-y-1/2 rounded-full bg-primary-solid"
                    style={{
                      left: `${((index + 0.5) / chart.points.length) * 100}%`,
                      bottom: `${point.y * 100}%`,
                    }}
                  />
                ))}
              </div>
              <div className="flex justify-between text-2xs text-text-muted">
                <span>{t(`chart.unit.${chart.unit}`, { value: chart.low.toFixed(1) })}</span>
                <span>{t(`chart.unit.${chart.unit}`, { value: chart.high.toFixed(1) })}</span>
              </div>
              <p className="text-2xs leading-relaxed text-text-subtle">{t("chart.note")}</p>
            </>
          ) : (
            <p className="text-sm text-text-muted">{t("chart.needData")}</p>
          )}
        </CardContent>
      </Card>

      {list.length > 0 ? (
        <section className="flex flex-col gap-3">
          <h2 className="text-md font-semibold text-text">{t("historyHeading")}</h2>
          {list.map((row) => (
            <Card key={row.id}>
              <CardContent className="flex flex-wrap items-baseline gap-x-3 gap-y-1 p-4">
                <span className="text-sm font-medium text-text">{fmt(row.loggedAt)}</span>
                {row.bbt !== null ? (
                  <span className="text-sm text-text-muted">
                    {t(`chart.unit.${unitOf(row.bbt) ?? "c"}`, { value: row.bbt.toFixed(2) })}
                  </span>
                ) : null}
                {row.opk ? (
                  <span className="text-sm text-text-muted">{t(`opk.${row.opk}`)}</span>
                ) : null}
                {row.cm ? <span className="text-sm text-text-muted">{t(`cm.${row.cm}`)}</span> : null}
                {row.intercourse ? (
                  <span className="text-sm text-text-muted">{t("log.intercourse")}</span>
                ) : null}
              </CardContent>
            </Card>
          ))}
        </section>
      ) : null}
    </AppScreen>
  );
}
