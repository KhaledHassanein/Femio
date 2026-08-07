"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { saveOrQueue } from "@/lib/offline/sync";
import { todayISO } from "@/lib/calculators/dates";
import { FLOWS, type Flow } from "@/lib/cycle/calendar";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { chipVariants } from "@/components/ui/chip";

/**
 * The date is owned by the Track screen so the day strip and this field are the
 * same choice (P1.28.3) — the strip covers the last two weeks, the field covers
 * anything older, and neither can disagree with the other. `onSaved` re-reads the
 * screen; `router.refresh()` did nothing here after P4.0 (ADR-052).
 */
export function LogPeriod({
  date,
  onDateChange,
  onSaved,
}: {
  date: string;
  onDateChange: (iso: string) => void;
  onSaved?: () => void;
}) {
  const t = useTranslations("track");
  const tf = useTranslations("track.flow");
  const router = useRouter();
  const [flow, setFlow] = useState<Flow | null>(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [queued, setQueued] = useState(false);
  const [saved, setSaved] = useState(false);

  const save = async () => {
    setSaving(true);
    setError(null);
    setQueued(false);
    setSaved(false);
    const supabase = createClient();
    // getSession reads the cached session without a network call, so this works
    // offline (unlike getUser).
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      router.push("/welcome");
      return;
    }
    const res = await saveOrQueue("cycles", {
      profile_id: session.user.id,
      period_start: date,
      ...(flow ? { flow } : {}),
    });
    setSaving(false);
    if (res === "synced") {
      setFlow(null);
      setSaved(true);
      onSaved?.();
    } else if (res === "queued") {
      setFlow(null);
      setQueued(true);
    } else {
      setError(res.error);
    }
  };

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <h2 className="text-md font-semibold text-text">{t("logHeading")}</h2>
        <div className="flex flex-col gap-2">
          <Label htmlFor="period-date">{t("logDateLabel")}</Label>
          <Input
            id="period-date"
            type="date"
            max={todayISO()}
            value={date}
            onChange={(e) => onDateChange(e.target.value)}
          />
        </div>
        <div className="flex flex-col gap-2">
          <span className="text-sm font-medium text-text">{tf("label")}</span>
          <div className="flex flex-wrap gap-2" role="group" aria-label={tf("label")}>
            {FLOWS.map((f) => (
              <button
                key={f}
                type="button"
                aria-pressed={flow === f}
                onClick={() => setFlow((prev) => (prev === f ? null : f))}
                className={chipVariants({ selected: flow === f })}
              >
                {tf(f)}
              </button>
            ))}
          </div>
        </div>
        {error ? (
          <Alert variant="danger">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        ) : null}
        {queued ? (
          <Alert variant="info">
            <AlertDescription>{t("savedOffline")}</AlertDescription>
          </Alert>
        ) : null}
        {saved ? (
          <Alert variant="success">
            <AlertDescription>{t("periodSaved")}</AlertDescription>
          </Alert>
        ) : null}
        <Button onClick={save} disabled={saving || !date} className="w-full">
          {t("logButton")}
        </Button>
      </CardContent>
    </Card>
  );
}
