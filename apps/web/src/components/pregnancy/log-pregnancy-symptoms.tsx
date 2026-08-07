"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { saveOrQueue } from "@/lib/offline/sync";
import { loggedAtForDate } from "@/lib/cycle/symptoms";
import {
  EMERGENCY_SYMPTOMS,
  PREGNANCY_SYMPTOM_GROUPS,
  SAME_DAY_SYMPTOMS,
  urgencyOf,
} from "@/lib/pregnancy/symptoms";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Link } from "@/i18n/navigation";
import { chipVariants } from "@/components/ui/chip";

/**
 * Symptom logging for pregnancy mode (P1.13d).
 *
 * The cycle logger asked a pregnant user about period cramps and gave her nowhere to put
 * vomiting, swelling or reduced movements. But the substantive change is not the vocabulary:
 * it is that **the symptoms that matter most in pregnancy are not log entries at all.**
 * Reduced fetal movement, heavy bleeding, a severe headache with vision changes — recording
 * those quietly and returning to the list would be the app filing away the exact thing it
 * should be interrupting for.
 *
 * So urgent symptoms live in their own section, and selecting one replaces the save
 * affordance with guidance to contact care. Two tiers, matching
 * `pregnancy-warning-signs.md` item for item, because an app that shouts "emergency" at
 * everything teaches people to ignore it — and because a reader who checks the app against
 * the article must not find them disagreeing.
 *
 * The entry is still saved. Someone who logs bleeding and then calls her midwife should
 * find it in her history, and a record she can show is often the useful thing.
 */
export function LogPregnancySymptoms({
  date,
  today,
  onSaved,
}: {
  date: string;
  today: string;
  onSaved?: () => void;
}) {
  const t = useTranslations("pregnancySymptoms");
  const router = useRouter();
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [queued, setQueued] = useState(false);
  const [saved, setSaved] = useState(false);

  const urgency = useMemo(() => urgencyOf(selected), [selected]);

  const toggle = (key: string) =>
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });

  const save = async () => {
    setSaving(true);
    setError(null);
    setQueued(false);
    setSaved(false);

    const supabase = createClient();
    // getSession reads the cached session without a network call, so this works offline.
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      router.push("/welcome");
      return;
    }

    // Same rule as the cycle logger: today keeps the column's `now()` default, an
    // earlier day is pinned to local noon (`loggedAtForDate`). This used to write a
    // bare `todayISO()` date, so the day strip above it moved and the entry still
    // landed on today — in pregnancy mode the strip was decoration (P1.28.6).
    const loggedAt = loggedAtForDate(date, today);
    const rows = [...selected].map((type) => ({
      profile_id: session.user.id,
      type,
      ...(loggedAt ? { logged_at: loggedAt } : {}),
    }));

    const result = await saveOrQueue("symptom_logs", rows);
    setSaving(false);
    // SaveResult is "synced" | "queued" | { error }, so a failure is an object.
    if (typeof result === "object") {
      setError(t("saveFailed"));
      return;
    }

    setSelected(new Set());
    if (result === "queued") {
      setQueued(true);
      return;
    }
    // Not `router.refresh()`: no server components on this path, so it did nothing
    // and the history below stayed stale until a full reload (ADR-052).
    setSaved(true);
    onSaved?.();
  };

  const chip = (key: string, tone: "default" | "sameDay" | "emergency") => (
    <button
      key={key}
      type="button"
      onClick={() => toggle(key)}
      aria-pressed={selected.has(key)}
      // One chip component for every logger, so the two screens cannot look like
      // different products again. The urgency tiers are the `tone` variant — the
      // only visual difference between loggers that earns its place.
      className={chipVariants({ selected: selected.has(key), tone })}
    >
      {t(`items.${key}`)}
    </button>
  );

  return (
    <Card>
      <CardContent className="flex flex-col gap-5 p-6">
        <div className="flex flex-col gap-1">
          <h2 className="font-display text-lg text-text">{t("heading")}</h2>
          <p className="text-sm text-text-muted">{t("intro")}</p>
        </div>

        {PREGNANCY_SYMPTOM_GROUPS.map((group) => (
          <fieldset key={group.group} className="flex flex-col gap-2">
            <legend className="text-sm font-medium text-text">{t(`groups.${group.group}`)}</legend>
            <div className="flex flex-wrap gap-2">
              {group.symptoms.map((s) => chip(s, "default"))}
            </div>
          </fieldset>
        ))}

        {/* Separated on purpose: listing these among everyday symptoms would present
            "heavy bleeding" as just another thing to tick. */}
        <fieldset className="flex flex-col gap-2">
          <legend className="text-sm font-medium text-warning-text">{t("groups.sameDay")}</legend>
          <div className="flex flex-wrap gap-2">
            {SAME_DAY_SYMPTOMS.map((s) => chip(s, "sameDay"))}
          </div>
        </fieldset>

        <fieldset className="flex flex-col gap-2">
          <legend className="text-sm font-medium text-danger-text">{t("groups.emergency")}</legend>
          <div className="flex flex-wrap gap-2">
            {EMERGENCY_SYMPTOMS.map((s) => chip(s, "emergency"))}
          </div>
        </fieldset>

        {/* The interruption. Shown instead of a quiet save, above the button, not below. */}
        {urgency ? (
          <Alert variant={urgency === "emergency" ? "danger" : "warning"}>
            <AlertDescription className="flex flex-col gap-2">
              <span className="font-medium">{t(`urgent.${urgency}.heading`)}</span>
              <span>{t(`urgent.${urgency}.body`)}</span>
              <Link href="/learn/pregnancy-warning-signs" className="underline">
                {t("urgent.link")}
              </Link>
              {urgency === "emergency" ? (
                <Link href="/help-now" className="underline">
                  {t("urgent.helpNow")}
                </Link>
              ) : null}
            </AlertDescription>
          </Alert>
        ) : null}

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
        {saved ? (
          <Alert variant="success">
            <AlertDescription>{t("saved")}</AlertDescription>
          </Alert>
        ) : null}

        <div className="flex items-center gap-3">
          <Button onClick={save} disabled={saving || selected.size === 0} variant="accent">
            {saving ? t("saving") : urgency ? t("saveAnyway") : t("save")}
          </Button>
          {urgency ? <span className="text-sm text-text-muted">{t("saveAnywayNote")}</span> : null}
        </div>
      </CardContent>
    </Card>
  );
}
