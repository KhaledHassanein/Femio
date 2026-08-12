"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import { CONDITIONS_BY_MODE, type ConditionCode } from "@/lib/persona/conditions";
import { reanswerTriage, type PersonaMode } from "@/lib/persona/state";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { chipVariants } from "@/components/ui/chip";
import { cn } from "@/lib/utils";

/**
 * "Re-answer the questions" (P1.27.3).
 *
 * `docs/09` §4 promised a wizard re-openable from Settings and nothing implemented
 * it, so a wrong answer at signup was permanent — which is the worst possible
 * property for a screen whose whole job is to describe her accurately.
 *
 * Deliberately **not** the whole wizard. Account creation and consent already
 * happened; re-asking them would be theatre and would make correcting a typo feel
 * like starting over. What she re-answers is what actually decides her experience:
 * the stage (owned by the picker above this) and the triage answers here.
 *
 * The copy has to carry two true things at once — that this *replaces* what she
 * previously said about her conditions, and that it touches nothing else. Someone
 * who has recorded a pregnancy or months of symptoms will not press a button she
 * suspects might reset her.
 */
export function ReanswerTriage({
  mode,
  onDone,
}: {
  mode: PersonaMode;
  onDone?: () => void;
}) {
  const t = useTranslations("experience.reanswer");
  const tc = useTranslations("onboarding.triage.conditions");

  const offered = CONDITIONS_BY_MODE[mode];
  const [open, setOpen] = useState(false);
  const [selected, setSelected] = useState<ConditionCode[]>([]);
  const [loaded, setLoaded] = useState(false);
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Pre-fill from what she already told us — this is a correction, not a fresh
  // form, and showing her an empty list would imply we had forgotten.
  useEffect(() => {
    if (!open || loaded) return;
    let cancelled = false;
    void (async () => {
      const { data } = await createClient()
        .from("conditions_flagged")
        .select("condition_code")
        .eq("source", "self");
      if (cancelled) return;
      const codes = (data ?? []).map((r) => r.condition_code as ConditionCode);
      setSelected(codes.filter((c) => offered.includes(c)));
      setLoaded(true);
    })();
    return () => {
      cancelled = true;
    };
  }, [open, loaded, offered]);

  const toggle = (code: ConditionCode) => {
    setSaved(false);
    setSelected((prev) => (prev.includes(code) ? prev.filter((c) => c !== code) : [...prev, code]));
  };

  const save = async () => {
    setSaving(true);
    setError(null);
    const result = await reanswerTriage(createClient(), mode, selected);
    setSaving(false);
    if (!result.ok) {
      setError(result.error);
      return;
    }
    setSaved(true);
    onDone?.();
  };

  if (!open) {
    return (
      <div className="flex flex-col gap-2">
        <Button variant="outline" className="self-start" onClick={() => setOpen(true)}>
          {t("open")}
        </Button>
        <p className="text-2xs text-text-subtle">{t("openHint")}</p>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-4 rounded-md bg-surface-sunken p-4">
      <div className="flex flex-col gap-1">
        <h3 className="text-sm font-semibold text-text">{t("heading")}</h3>
        <p className="text-2xs leading-relaxed text-text-muted">{t("intro")}</p>
      </div>

      {offered.length === 0 ? (
        <p className="text-2xs text-text-muted">{t("noneOffered")}</p>
      ) : (
        <div className="flex flex-wrap gap-2">
          {offered.map((code) => {
            const on = selected.includes(code);
            return (
              <button
                key={code}
                type="button"
                aria-pressed={on}
                onClick={() => toggle(code)}
                className={cn(chipVariants({ selected: on }))}
              >
                {tc(code)}
              </button>
            );
          })}
        </div>
      )}

      {/* The promise the code keeps, stated where she is deciding whether to press
          the button — not in a footnote she will not read. */}
      <p className="text-2xs leading-relaxed text-text-muted">{t("replacesNote")}</p>

      {error ? (
        <Alert variant="danger">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      ) : null}
      {saved ? (
        <Alert variant="info">
          <AlertDescription>{t("saved")}</AlertDescription>
        </Alert>
      ) : null}

      <div className="flex flex-wrap gap-2">
        <Button variant="accent" onClick={save} disabled={saving || !loaded}>
          {saving ? t("saving") : t("save")}
        </Button>
        <Button variant="ghost" onClick={() => setOpen(false)} disabled={saving}>
          {t("cancel")}
        </Button>
      </div>
    </div>
  );
}
