"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { SEVERITY_LEVELS, SYMPTOM_GROUPS, type Severity } from "@/lib/cycle/symptoms";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
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
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [severity, setSeverity] = useState<Severity | null>(null);
  const [note, setNote] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const toggle = (key: string) =>
    setSelected((s) => {
      const next = new Set(s);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });

  const save = async () => {
    if (selected.size === 0) return;
    setSaving(true);
    setError(null);
    const supabase = createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      router.push("/welcome");
      return;
    }
    const rows = [...selected].map((type) => ({
      profile_id: user.id,
      type,
      severity,
      note: note || null,
    }));
    const { error: insertError } = await supabase.from("symptom_logs").insert(rows);
    if (insertError) {
      setError(insertError.message);
      setSaving(false);
      return;
    }
    setSelected(new Set());
    setSeverity(null);
    setNote("");
    setSaving(false);
    router.refresh();
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

        <div className="flex flex-col gap-2">
          <p className="text-sm font-medium text-text-muted">{t("severityLabel")}</p>
          <div className="flex flex-wrap gap-2">
            {SEVERITY_LEVELS.map((lvl) => (
              <button
                key={lvl}
                type="button"
                onClick={() => setSeverity((s) => (s === lvl ? null : lvl))}
                aria-pressed={severity === lvl}
                className={chip(severity === lvl)}
              >
                {t(`severity.${lvl}`)}
              </button>
            ))}
          </div>
        </div>

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

        <Button onClick={save} disabled={saving || selected.size === 0} className="self-start">
          {t("save")}
        </Button>
      </CardContent>
    </Card>
  );
}
