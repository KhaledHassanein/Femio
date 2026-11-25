"use client";

import { useEffect, useState } from "react";
import { Phone, Play, Square } from "lucide-react";
import { useFormatter, useTranslations } from "next-intl";
import { formatDuration, inProgress, summarize, timeContractions, type Contraction } from "@/lib/contractions";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { CalculatorCard, ResultSentence, RuleLine } from "./calculator-card";

const TICK_MS = 1000;
const MS_PER_SECOND = 1000;

/**
 * The website's contraction timer (R13.4, MR-31): start when one begins, stop when it
 * eases; each one's length and the time from the previous start, and the averages over
 * the last five. It gives no labour verdict and no "5-1-1" rule; the call line sits
 * above the numbers, always. Nothing is saved: the times live in this page's memory
 * and a refresh clears them (the app keeps them on the phone).
 *
 * The arithmetic is `lib/contractions` (golden fixture `contractions.json`, shared with
 * the app); the typed `ContractionSummary` is what a later "AI view" would read.
 */
export function ContractionTimer() {
  const t = useTranslations("contractions");
  const tc = useTranslations("calculators.contractionTimer");
  const format = useFormatter();
  const [contractions, setContractions] = useState<Contraction[]>([]);
  const [now, setNow] = useState(() => Date.now());

  const timed = timeContractions(contractions);
  const running = inProgress(timed);
  const summary = summarize(timed);

  useEffect(() => {
    if (!running) return undefined;
    const id = window.setInterval(() => setNow(Date.now()), TICK_MS);
    return () => window.clearInterval(id);
  }, [running]);

  const toggle = () => {
    const stamp = new Date().toISOString();
    setNow(Date.now());
    if (running) {
      setContractions((all) => all.map((c) => (c.id === running.id ? { ...c, endedAt: stamp } : c)));
    } else {
      setContractions((all) => [...all, { id: `c${all.length + 1}`, startedAt: stamp, endedAt: null }]);
    }
  };

  const clock = (iso: string) => format.dateTime(new Date(iso), { timeStyle: "short" });
  const elapsed = running ? Math.max(0, Math.round((now - Date.parse(running.startedAt)) / MS_PER_SECOND)) : 0;

  return (
    <CalculatorCard>
      <Alert variant="info" icon={<Phone className="size-5" />}>
        <AlertDescription>
          <span className="block font-semibold">{t("contact.heading")}</span>
          {t("contact.body")}
        </AlertDescription>
      </Alert>

      <div className="flex flex-col items-center gap-3 py-2">
        <p className="text-sm text-text-muted" aria-live="polite">
          {running ? t("running") : t("idle")}
        </p>
        <p className="font-display text-4xl tabular-nums text-text" aria-hidden={!running}>
          <bdi>{formatDuration(elapsed)}</bdi>
        </p>
        <Button type="button" size="lg" variant={running ? "outline" : "primary"} onClick={toggle} className="min-w-56 gap-2">
          {running ? <Square className="size-5" aria-hidden /> : <Play className="size-5" aria-hidden />}
          {running ? t("stop") : t("start")}
        </Button>
        <p className="text-center text-xs text-text-subtle">{tc("sessionNote")}</p>
      </div>

      {summary.counted > 0 && (summary.averageDurationSeconds !== null || summary.averageIntervalSeconds !== null) ? (
        <ResultSentence
          eyebrow={t("summary.heading", { count: summary.counted })}
          headline={summary.averageIntervalSeconds !== null ? t("summary.interval", { value: formatDuration(summary.averageIntervalSeconds) }) : t("summary.duration", { value: formatDuration(summary.averageDurationSeconds ?? 0) })}
          lines={summary.averageIntervalSeconds !== null && summary.averageDurationSeconds !== null ? [t("summary.duration", { value: formatDuration(summary.averageDurationSeconds) })] : []}
        >
          <RuleLine>{t("summary.note")}</RuleLine>
        </ResultSentence>
      ) : null}

      {timed.length > 0 ? (
        <section aria-labelledby="ct-times" className="flex flex-col gap-2 border-t border-border pt-4">
          <h2 id="ct-times" className="font-display text-lg text-text">
            {tc("listHeading")}
          </h2>
          <ol className="flex flex-col gap-2">
            {[...timed].reverse().map((c) => (
              <li key={c.id} className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1 rounded-md border border-border bg-surface px-3 py-2 text-sm">
                <span className="text-text-muted">{tc("startedAt", { time: clock(c.startedAt) })}</span>
                <span className="flex gap-4 tabular-nums text-text">
                  <span>
                    {tc("length")}: <bdi>{c.durationSeconds !== null ? formatDuration(c.durationSeconds) : "…"}</bdi>
                  </span>
                  <span>
                    {tc("apart")}: <bdi>{c.intervalSeconds !== null ? formatDuration(c.intervalSeconds) : "—"}</bdi>
                  </span>
                </span>
              </li>
            ))}
          </ol>
          <div className="flex justify-end">
            <Button type="button" variant="ghost" size="sm" onClick={() => setContractions([])}>
              {tc("clear")}
            </Button>
          </div>
        </section>
      ) : null}
    </CalculatorCard>
  );
}
