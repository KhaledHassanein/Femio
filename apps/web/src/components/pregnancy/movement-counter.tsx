"use client";

import { useCallback, useEffect, useState } from "react";
import { useFormatter, useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { saveOrQueue } from "@/lib/offline/sync";
import {
  comparePattern,
  minutesPerMovement,
  MIN_SESSIONS_FOR_PATTERN,
  type MovementSession,
} from "@/lib/pregnancy/movements";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";

/**
 * Movement pattern log (P2.2).
 *
 * Read `lib/pregnancy/movements.ts` first — it explains why this is not a
 * count-to-ten kick counter. Three rules this component exists to hold:
 *
 * 1. **No verdict, ever.** There is no target, no progress bar toward a number,
 *    and no "all good" state. The published guidance is that there is no normal
 *    number; the only meaningful comparison is against her own pattern.
 * 2. **The help route is never gated.** The maternity-contact panel is rendered
 *    above the counter and is present before, during and after a session. An app
 *    that says "finish your count first" would be actively harmful, because the
 *    published answer to "should reduced movement wait?" is *no*.
 * 3. **A session can always be saved unfinished.** Someone who stops counting
 *    because she is worried is the person this feature is for, and her record
 *    should show that she stopped.
 */
export function MovementCounter({ pregnancyId }: { pregnancyId: string | null }) {
  const t = useTranslations("pregnancyMovements");
  const format = useFormatter();

  const [startedAt, setStartedAt] = useState<string | null>(null);
  const [count, setCount] = useState(0);
  const [elapsedMs, setElapsedMs] = useState(0);
  const [recent, setRecent] = useState<MovementSession[] | null>(null);
  const [saving, setSaving] = useState(false);
  const [queued, setQueued] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const loadRecent = useCallback(async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("fetal_movement_sessions")
      .select("id, started_at, ended_at, movement_count")
      .order("started_at", { ascending: false })
      .limit(12);
    setRecent(
      (data ?? []).map((r) => ({
        id: r.id as string,
        startedAt: r.started_at as string,
        endedAt: (r.ended_at as string | null) ?? null,
        movementCount: (r.movement_count as number | null) ?? null,
      })),
    );
  }, []);

  useEffect(() => {
    void loadRecent();
  }, [loadRecent]);

  // Tick the visible timer. Derived from the start timestamp rather than
  // accumulated, so a backgrounded tab or a locked phone cannot lose time.
  useEffect(() => {
    if (!startedAt) return;
    const tick = () => setElapsedMs(Date.now() - new Date(startedAt).getTime());
    tick();
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);
  }, [startedAt]);

  const start = () => {
    setStartedAt(new Date().toISOString());
    setCount(0);
    setElapsedMs(0);
    setQueued(false);
    setError(null);
  };

  const finish = async () => {
    if (!startedAt) return;
    setSaving(true);
    setError(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    const result = await saveOrQueue("fetal_movement_sessions", {
      profile_id: user?.id,
      pregnancy_id: pregnancyId,
      started_at: startedAt,
      ended_at: new Date().toISOString(),
      movement_count: count,
    });

    setSaving(false);
    if (typeof result === "object") {
      setError(result.error);
      return;
    }
    setQueued(result === "queued");
    setStartedAt(null);
    setCount(0);
    if (result === "synced") await loadRecent();
  };

  const mmss = (ms: number) => {
    const total = Math.max(0, Math.floor(ms / 1000));
    return `${Math.floor(total / 60)}:${String(total % 60).padStart(2, "0")}`;
  };
  const fmtDate = (iso: string) =>
    format.dateTime(new Date(iso), { dateStyle: "medium", timeStyle: "short" });

  const pattern = recent ? comparePattern(recent) : null;

  return (
    <section className="flex flex-col gap-4">
      <div className="flex flex-col gap-1">
        <h2 className="text-md font-semibold text-text">{t("heading")}</h2>
        <p className="text-sm text-text-muted">{t("intro")}</p>
      </div>

      {/* Rule 2: above the counter, always rendered, never conditional on a count.
          "Should reduced movement wait until tomorrow? No." — the published article,
          and this panel is the app saying the same thing in the same place. */}
      <Alert variant="danger">
        <AlertDescription className="flex flex-col gap-2">
          <span className="font-medium">{t("urgent.heading")}</span>
          <span>{t("urgent.body")}</span>
          <Link href="/learn/pregnancy-warning-signs" className="text-text-link underline">
            {t("urgent.link")}
          </Link>
        </AlertDescription>
      </Alert>

      <Card>
        <CardContent className="flex flex-col items-center gap-4 p-6">
          {startedAt ? (
            <>
              <p className="font-display text-4xl tabular-nums text-text" aria-live="off">
                {mmss(elapsedMs)}
              </p>
              <p className="text-sm text-text-muted">{t("counted", { count })}</p>
              <Button
                variant="accent"
                className="h-24 w-full text-lg"
                onClick={() => setCount((c) => c + 1)}
              >
                {t("tap")}
              </Button>
              <div className="flex w-full flex-col gap-2">
                <Button variant="outline" onClick={finish} disabled={saving}>
                  {saving ? t("saving") : t("finish")}
                </Button>
                {/* Rule 3: leaving is always allowed and always saves. */}
                <p className="text-center text-2xs text-text-subtle">{t("finishNote")}</p>
              </div>
            </>
          ) : (
            <>
              <p className="text-sm text-text-muted">{t("startBody")}</p>
              <Button variant="accent" onClick={start}>
                {t("start")}
              </Button>
            </>
          )}

          {error ? (
            <Alert variant="danger">
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          ) : null}
          {queued ? (
            <Alert variant="info">
              <AlertDescription>{t("queued")}</AlertDescription>
            </Alert>
          ) : null}
        </CardContent>
      </Card>

      {/* Her own pattern. Deliberately phrased as a comparison she can act on, not
          as a judgement: "longer than usual for you", never "abnormal". */}
      {pattern?.status === "comparable" && pattern.slower ? (
        <Alert variant="warning">
          <AlertDescription className="flex flex-col gap-2">
            <span className="font-medium">{t("pattern.slowerHeading")}</span>
            <span>{t("pattern.slowerBody")}</span>
          </AlertDescription>
        </Alert>
      ) : null}

      {recent && recent.length > 0 ? (
        <div className="flex flex-col gap-2">
          <h3 className="text-sm font-semibold text-text">{t("recentHeading")}</h3>
          <ul className="flex flex-col gap-1 text-sm">
            {recent.slice(0, 6).map((s, i) => {
              const rate = minutesPerMovement(s);
              return (
                <li key={s.id ?? i} className="flex justify-between gap-4 border-b border-border py-1">
                  <span className="text-text">{fmtDate(s.startedAt)}</span>
                  <span className="text-text-muted">
                    {s.movementCount === null
                      ? t("unfinished")
                      : t("sessionSummary", {
                          count: s.movementCount,
                          minutes: rate === null ? 0 : Math.round(rate),
                        })}
                  </span>
                </li>
              );
            })}
          </ul>
          {pattern?.status === "insufficient" ? (
            <p className="text-2xs text-text-subtle">
              {t("pattern.needMore", { count: MIN_SESSIONS_FOR_PATTERN })}
            </p>
          ) : null}
        </div>
      ) : null}
    </section>
  );
}
