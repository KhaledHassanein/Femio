"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { X } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { saveOrQueue } from "@/lib/offline/sync";
import {
  buildSymptomRows,
  KNOWN_SYMPTOMS,
  MAX_CUSTOM_SYMPTOM_LENGTH,
  normalizeCustomSymptom,
  SEVERITY_LEVELS,
  SYMPTOM_GROUPS,
  type Severity,
} from "@/lib/cycle/symptoms";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { cn } from "@/lib/utils";

const chip = (active: boolean) =>
  cn(
    "rounded-pill border px-3 py-1.5 text-sm transition-colors",
    active
      ? "border-primary bg-primary-soft text-primary-soft-text"
      : "border-border bg-surface text-text hover:bg-surface-sunken",
  );

export function LogSymptoms() {
  const t = useTranslations("symptoms");
  const router = useRouter();
  // Insertion-ordered: symptom key → its own severity (null = not set).
  const [selected, setSelected] = useState<Map<string, Severity | null>>(new Map());
  const [custom, setCustom] = useState("");
  const [note, setNote] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [queued, setQueued] = useState(false);

  const label = (key: string) => (KNOWN_SYMPTOMS.has(key) ? t(`items.${key}`) : key);

  const toggle = (key: string) =>
    setSelected((prev) => {
      const next = new Map(prev);
      if (next.has(key)) next.delete(key);
      else next.set(key, null);
      return next;
    });

  const setSeverity = (key: string, lvl: Severity) =>
    setSelected((prev) => {
      const next = new Map(prev);
      next.set(key, next.get(key) === lvl ? null : lvl);
      return next;
    });

  const addCustom = () => {
    const value = normalizeCustomSymptom(custom, selected.keys());
    if (!value) return;
    setSelected((prev) => new Map(prev).set(value, null));
    setCustom("");
  };

  const reset = () => {
    setSelected(new Map());
    setCustom("");
    setNote("");
  };

  const save = async () => {
    if (selected.size === 0) return;
    setSaving(true);
    setError(null);
    setQueued(false);
    const supabase = createClient();
    const {
      data: { session },
    } = await supabase.auth.getSession();
    if (!session) {
      router.push("/welcome");
      return;
    }
    const rows = buildSymptomRows(session.user.id, selected, note);
    const res = await saveOrQueue("symptom_logs", rows);
    setSaving(false);
    if (res === "synced") {
      reset();
      router.refresh();
    } else if (res === "queued") {
      reset();
      setQueued(true);
    } else {
      setError(res.error);
    }
  };

  return (
    <Card>
      <CardContent className="flex flex-col gap-4 p-6">
        <h2 className="text-md font-semibold text-text">{t("heading")}</h2>

        {SYMPTOM_GROUPS.map((g) => (
          <div key={g.group} className="flex flex-col gap-2">
            <p className="text-sm font-medium text-text-muted">{t(`groups.${g.group}`)}</p>
            <div className="flex flex-wrap gap-2">
              {g.symptoms.map((key) => (
                <button
                  key={key}
                  type="button"
                  onClick={() => toggle(key)}
                  aria-pressed={selected.has(key)}
                  className={chip(selected.has(key))}
                >
                  {t(`items.${key}`)}
                </button>
              ))}
            </div>
          </div>
        ))}

        {/* Custom (user-defined) symptom. */}
        <div className="flex flex-col gap-2">
          <label htmlFor="custom-symptom" className="text-sm font-medium text-text-muted">
            {t("custom.label")}
          </label>
          <div className="flex gap-2">
            <Input
              id="custom-symptom"
              value={custom}
              maxLength={MAX_CUSTOM_SYMPTOM_LENGTH}
              placeholder={t("custom.placeholder")}
              onChange={(e) => setCustom(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  e.preventDefault();
                  addCustom();
                }
              }}
            />
            <Button variant="outline" onClick={addCustom} disabled={!custom.trim()} className="shrink-0">
              {t("custom.add")}
            </Button>
          </div>
        </div>

        {/* Selected symptoms, each with its own optional intensity. */}
        {selected.size > 0 ? (
          <div className="flex flex-col gap-3 rounded-md border border-border bg-surface-sunken p-4">
            <p className="text-sm font-medium text-text">{t("selectedHeading")}</p>
            {[...selected].map(([key, sev]) => (
              <div key={key} className="flex flex-col gap-1.5">
                <div className="flex items-center justify-between gap-2">
                  <span className="text-sm text-text">{label(key)}</span>
                  <button
                    type="button"
                    onClick={() => toggle(key)}
                    aria-label={t("remove", { symptom: label(key) })}
                    className="rounded-sm p-1 text-text-muted hover:bg-surface focus-visible:outline-none"
                  >
                    <X className="size-4" aria-hidden />
                  </button>
                </div>
                <div
                  className="flex flex-wrap gap-1.5"
                  role="group"
                  aria-label={`${label(key)} — ${t("severityLabel")}`}
                >
                  {SEVERITY_LEVELS.map((lvl) => (
                    <button
                      key={lvl}
                      type="button"
                      onClick={() => setSeverity(key, lvl)}
                      aria-pressed={sev === lvl}
                      className={cn(
                        "rounded-pill border px-2.5 py-1 text-2xs transition-colors",
                        sev === lvl
                          ? "border-primary bg-primary-soft text-primary-soft-text"
                          : "border-border text-text-muted hover:bg-surface",
                      )}
                    >
                      {t(`severity.${lvl}`)}
                    </button>
                  ))}
                </div>
              </div>
            ))}
          </div>
        ) : null}

        <Textarea
          aria-label={t("noteLabel")}
          placeholder={t("noteLabel")}
          value={note}
          onChange={(e) => setNote(e.target.value)}
        />

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

        <Button onClick={save} disabled={saving || selected.size === 0} className="self-start">
          {t("save")}
        </Button>
      </CardContent>
    </Card>
  );
}
