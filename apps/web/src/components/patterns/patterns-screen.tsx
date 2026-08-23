"use client";

import { useTranslations } from "next-intl";
import { symptomPatterns } from "@/lib/cycle/symptom-patterns";
import { KNOWN_SYMPTOMS } from "@/lib/cycle/symptoms";
import { coOccurrences } from "@/lib/patterns/co-occurrence";
import { severityTrends } from "@/lib/patterns/severity";
import type { PatternConfidence } from "@/lib/patterns/confidence";
import { setConsent } from "@/lib/consent/actions";
import { isGranted } from "@/lib/consent/purposes";
import { useSupabaseQuery, unwrap } from "@/lib/supabase/use-query";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { AppScreen, ScreenError } from "@/components/patterns/app-screen";
import { LoadingState } from "@/components/patterns/loading-state";

/**
 * What her own entries show, read back to her (P2.5).
 *
 * `docs/03` §H.3 calls this *"the one feature I would actually pay for, gated"*,
 * and three things about how it is built follow from that being true rather than
 * from it being asked for.
 *
 * **It gets its own screen rather than a dashboard card.** Three dimensions with
 * their evidence attached is more than a card can carry honestly, and the
 * dashboard's rule is *dense with her data, never dense with cards* (`docs/27`).
 * A pattern is also not a daily answer — it is something she comes to look at.
 *
 * **Every claim arrives with its denominator and its confidence.** "In 4 of your
 * last 6 cycles" is the claim; "cramps on day 2" without it is a rule about her
 * body that Femio has no standing to state. Product rule 3 forbids a single
 * certain date for a prediction; this is the same rule applied to an observation.
 *
 * **Nothing here interprets.** No cause, no diagnosis, no projection, and no
 * "worse" — severity moves *higher* or *lower*, which is a fact about her entries
 * rather than a judgement about her health (`docs/09` invariant 7, and the same
 * refusal P2.4 made about adherence scores).
 *
 * ## Why it is behind the `insights` consent
 *
 * `insights` reads *"Use my entries to show me patterns and insights"* — this
 * feature is the literal thing that sentence describes, and it is the only screen
 * in Femio for which that is true. Gating it here means the consent means
 * something rather than sitting unused, and the refusal is explained with the
 * switch offered inline (the R3.0.8 pattern) rather than the screen just being
 * empty.
 */

function ConfidenceBadge({ level }: { level: PatternConfidence }) {
  const t = useTranslations("patterns");
  // One accent per screen (`docs/25` §5a): confidence is information, not emphasis,
  // so all three levels use the neutral badge and the *word* carries the meaning.
  return <Badge variant="neutral">{t(`confidence.${level}`)}</Badge>;
}

export function PatternsScreen() {
  const t = useTranslations("patterns");
  const ts = useTranslations("symptoms");
  const tsp = useTranslations("symptomPatterns");

  const query = useSupabaseQuery(async (supabase) => {
    const [consent, cycles, logs] = await Promise.all([
      unwrap(
        supabase.from("consent_records").select("purpose, granted, granted_at, revoked_at"),
      ),
      unwrap(
        supabase.from("cycles").select("period_start").order("period_start", { ascending: true }),
      ),
      unwrap(
        supabase
          .from("symptom_logs")
          .select("type, severity, logged_at")
          .order("logged_at", { ascending: false })
          .limit(1000),
      ),
    ]);

    const entries = ((logs ?? []) as { type: string; severity: number | null; logged_at: string }[])
      .map((r) => ({ type: r.type, date: r.logged_at.slice(0, 10), severity: r.severity }));
    const starts = ((cycles ?? []) as { period_start: string }[]).map((c) => c.period_start);

    return {
      insights: isGranted((consent ?? []) as Parameters<typeof isGranted>[0], "insights"),
      timing: symptomPatterns(
        entries.map((e) => ({ type: e.type, date: e.date })),
        starts,
      ),
      together: coOccurrences(entries, starts),
      severity: severityTrends(entries, starts),
    };
  });

  const label = (type: string) => (KNOWN_SYMPTOMS.has(type) ? ts(`items.${type}`) : type);

  if (query.status === "loading") {
    return (
      <AppScreen busy>
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
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

  const { insights, timing, together, severity } = query.data;

  if (!insights) {
    return (
      <AppScreen>
        <div className="flex flex-col gap-1">
          <h1 className="font-display text-lg text-text">{t("title")}</h1>
          <p className="text-sm text-text-muted">{t("intro")}</p>
        </div>
        {/* Explained and fixable in place, rather than an empty screen she cannot
            account for — the shape R3.0.8 established for the analytics gate. */}
        <Alert variant="info">
          <AlertDescription className="flex flex-col items-start gap-3">
            <span>{t("consent.body")}</span>
            <Button
              variant="outline"
              onClick={async () => {
                const res = await setConsent("insights", true);
                if (res.ok) query.refresh();
              }}
            >
              {t("consent.cta")}
            </Button>
          </AlertDescription>
        </Alert>
      </AppScreen>
    );
  }

  const nothingYet = timing.length === 0 && together.length === 0 && severity.length === 0;

  return (
    <AppScreen>
      <div className="flex flex-col gap-1">
        <h1 className="font-display text-lg text-text">{t("title")}</h1>
        <p className="text-sm text-text-muted">{t("intro")}</p>
      </div>

      {nothingYet ? (
        // "Not yet" is a real answer and says what would change it. An empty screen
        // that looks broken is the failure ADR-046 names.
        <Card>
          <CardContent className="flex flex-col gap-2 p-6">
            <h2 className="font-display text-lg text-text">{t("empty.heading")}</h2>
            <p className="text-sm text-text-muted">{t("empty.body")}</p>
          </CardContent>
        </Card>
      ) : null}

      {timing.length > 0 ? (
        <Card>
          <CardContent className="flex flex-col gap-3 p-6">
            <div className="flex flex-col gap-1">
              <h2 className="font-display text-lg text-text">{t("timing.heading")}</h2>
              <p className="text-xs text-text-muted">{t("timing.note")}</p>
            </div>
            <ul className="flex flex-col gap-3">
              {timing.map((p) => (
                <li key={p.type} className="flex flex-col gap-1">
                  <span className="text-sm text-text">
                    {p.from === p.to
                      ? tsp("onDay", { symptom: label(p.type), day: p.from })
                      : tsp("onDays", { symptom: label(p.type), from: p.from, to: p.to })}
                  </span>
                  <span className="text-xs text-text-muted">
                    {tsp("evidence", { cycles: p.cycles, ofCycles: p.ofCycles })}
                  </span>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      ) : null}

      {together.length > 0 ? (
        <Card>
          <CardContent className="flex flex-col gap-3 p-6">
            <div className="flex flex-col gap-1">
              <h2 className="font-display text-lg text-text">{t("together.heading")}</h2>
              {/* The sentence that keeps this the right side of product rule 1.
                  Co-occurrence is the shape people read as causation. */}
              <p className="text-xs text-text-muted">{t("together.note")}</p>
            </div>
            <ul className="flex flex-col gap-3">
              {together.map((p) => (
                <li key={`${p.a}|${p.b}`} className="flex flex-col gap-1">
                  <span className="flex flex-wrap items-center gap-2 text-sm text-text">
                    {t("together.pair", { a: label(p.a), b: label(p.b) })}
                    <ConfidenceBadge level={p.confidence} />
                  </span>
                  <span className="text-xs text-text-muted">
                    {t("together.evidence", { cycles: p.cycles, ofCycles: p.ofCycles })}
                  </span>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      ) : null}

      {severity.length > 0 ? (
        <Card>
          <CardContent className="flex flex-col gap-3 p-6">
            <div className="flex flex-col gap-1">
              <h2 className="font-display text-lg text-text">{t("severity.heading")}</h2>
              <p className="text-xs text-text-muted">{t("severity.note")}</p>
            </div>
            <ul className="flex flex-col gap-3">
              {severity.map((s) => (
                <li key={s.type} className="flex flex-col gap-1">
                  <span className="flex flex-wrap items-center gap-2 text-sm text-text">
                    {t(`severity.${s.direction}`, { symptom: label(s.type) })}
                    <ConfidenceBadge level={s.confidence} />
                  </span>
                  <span className="text-xs text-text-muted">
                    {t("severity.evidence", {
                      recent: s.recentMean,
                      earlier: s.earlierMean,
                      cycles: s.recentCycles + s.earlierCycles,
                    })}
                  </span>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
      ) : null}

      {/* Last, and not optional. Every dimension above is a count; this is the
          sentence that stops a count becoming a finding. */}
      <p className="text-2xs leading-relaxed text-text-subtle">{t("limit")}</p>
    </AppScreen>
  );
}
