"use client";

import { useCallback, useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import {
  formatDuration,
  inProgress,
  summarize,
  timeContractions,
  type Contraction,
} from "@/lib/contractions";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";

/**
 * The contraction timer (P2.2.3).
 *
 * `pregnancy.contractions` has been in the Track D registry since R2.1, surfaced
 * from around 36 weeks, and rendered nothing. Migration `0008` gives it a table.
 *
 * ## Three rules, and the second is the one that matters
 *
 * 1. **It times; it does not read.** No 5-1-1 evaluation, no "this looks like
 *    labour", no colour that changes when the numbers do. `lib/contractions` cannot
 *    produce a verdict and this screen could not render one.
 * 2. **The maternity-contact route sits above the timer, always.** Before, during
 *    and after. This is copied deliberately from `movement-counter.tsx`, and for
 *    the same reason: an app that implies "finish timing first" would be actively
 *    harmful, because the published answer to "should I call?" is that she should
 *    call when she is worried, not when a number is reached.
 * 3. **A contraction she never stopped is still a real row.** She put the phone
 *    down, or a contraction arrived while she was holding it. `inProgress` only
 *    ever treats the *last* row as live, so an abandoned one does not leave a timer
 *    counting up from two hours ago.
 */
export function ContractionTimer() {
  const t = useTranslations("contractions");
  const [now, setNow] = useState(() => Date.now());
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const query = useSupabaseQuery(async (supabase) => {
    const rows = await unwrap(
      supabase
        .from("contractions")
        .select("id, started_at, ended_at")
        .order("started_at", { ascending: false })
        .limit(40),
    );
    return ((rows ?? []) as Record<string, unknown>[]).map(
      (r): Contraction => ({
        id: r.id as string,
        startedAt: r.started_at as string,
        endedAt: (r.ended_at as string | null) ?? null,
      }),
    );
  });

  const timed = query.status === "ready" ? timeContractions(query.data) : [];
  const running = inProgress(timed);
  const summary = summarize(timed);

  // Derived from the start timestamp rather than accumulated, so a backgrounded
  // tab or a locked phone cannot lose time (same as the movement counter).
  useEffect(() => {
    if (!running) return;
    const id = setInterval(() => setNow(Date.now()), 1000);
    setNow(Date.now());
    return () => clearInterval(id);
  }, [running]);

  const toggle = useCallback(async () => {
    setBusy(true);
    setError(null);
    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      setBusy(false);
      setError(t("saveFailed"));
      return;
    }

    const result = running
      ? await supabase
          .from("contractions")
          .update({ ended_at: new Date().toISOString() })
          .eq("id", running.id)
      : await supabase.from("contractions").insert({
          profile_id: session.user.id,
          started_at: new Date().toISOString(),
        });

    setBusy(false);
    if (result.error) {
      setError(t("saveFailed"));
      return;
    }
    query.refresh();
  }, [running, query, t]);

  const elapsed = running
    ? Math.max(0, Math.round((now - Date.parse(running.startedAt)) / 1000))
    : null;

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-5">
        <div className="flex flex-col gap-1">
          <h2 className="text-md font-semibold text-text">{t("heading")}</h2>
          <p className="text-sm text-text-muted">{t("intro")}</p>
        </div>

        {/* Above the timer, and present in every state. Not conditional on any
            number — see rule 2 in the file comment. */}
        <Alert variant="info">
          <AlertDescription className="flex flex-col gap-2">
            <span className="font-medium">{t("contact.heading")}</span>
            <span>{t("contact.body")}</span>
            <Link href="/learn/pregnancy-warning-signs" className="underline">
              {t("contact.link")}
            </Link>
          </AlertDescription>
        </Alert>

        <div className="flex flex-col items-center gap-2 rounded-md border border-border bg-surface-sunken p-5">
          <p className="font-display text-2xl tabular-nums text-text">
            {formatDuration(elapsed ?? 0)}
          </p>
          <p className="text-sm text-text-muted">{running ? t("running") : t("idle")}</p>
          <Button
            onClick={toggle}
            disabled={busy || query.status === "loading"}
            variant="accent"
            className="w-full"
          >
            {running ? t("stop") : t("start")}
          </Button>
        </div>

        {summary.counted > 0 ? (
          <div className="flex flex-col gap-1">
            <p className="text-2xs font-semibold uppercase tracking-wider text-text-muted">
              {t("summary.heading", { count: summary.counted })}
            </p>
            <p className="text-sm text-text">
              {t("summary.duration", {
                value:
                  summary.averageDurationSeconds === null
                    ? "—"
                    : formatDuration(summary.averageDurationSeconds),
              })}
            </p>
            <p className="text-sm text-text">
              {t("summary.interval", {
                value:
                  summary.averageIntervalSeconds === null
                    ? "—"
                    : formatDuration(summary.averageIntervalSeconds),
              })}
            </p>
            {/* Said plainly, so the absence of a verdict is a statement rather than
                a gap she has to interpret. */}
            <p className="text-2xs leading-relaxed text-text-subtle">{t("summary.note")}</p>
          </div>
        ) : null}

        {error ? (
          <Alert variant="danger">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        ) : null}
        {query.status === "error" ? (
          <Alert variant="warning">
            <AlertDescription>{t("loadError")}</AlertDescription>
          </Alert>
        ) : null}
      </CardContent>
    </Card>
  );
}
