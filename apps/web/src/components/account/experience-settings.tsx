"use client";

import { useEffect, useState } from "react";
import { useTranslations } from "next-intl";
import { createClient } from "@/lib/supabase/client";
import {
  PERSONA_MODES,
  readPersonaState,
  switchMode,
  type PersonaMode,
} from "@/lib/persona/state";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

/**
 * "Your Femio experience" — change life-stage mode, or switch to general
 * (docs/09 §4, which specified this from Settings and which nothing implemented).
 *
 * Why this is not a cosmetic setting: `persona_state.track` was written once at
 * onboarding and never again, so a wrong answer at signup was permanent, and a
 * real life change — pregnant, no longer pregnant, periods stopping — had no way
 * of reaching the app. Femio's whole claim is one record across a life.
 *
 * The copy carries the promise the code has to keep: **nothing is deleted and
 * nothing is hidden.** Switching mode re-layers what is emphasised over an
 * unchanged record, and every tool stays reachable from any mode (product rules
 * 2 and 5). Saying so matters as much as doing it — someone who has recorded a
 * pregnancy will not touch this control if she thinks it might erase it.
 */
export function ExperienceSettings() {
  const t = useTranslations("experience");
  const [current, setCurrent] = useState<PersonaMode | null>(null);
  const [pending, setPending] = useState<PersonaMode | null>(null);
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    void (async () => {
      const state = await readPersonaState(createClient());
      if (!cancelled) setCurrent(state.mode);
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const apply = async () => {
    if (!pending || pending === current) return;
    setSaving(true);
    setError(null);
    const result = await switchMode(createClient(), pending);
    setSaving(false);
    if (!result.ok) {
      setError(result.error);
      return;
    }
    setCurrent(result.mode);
    setPending(null);
    setSaved(true);
  };

  if (current === null) {
    return <div className="h-24 animate-pulse rounded-md bg-surface-sunken" aria-busy="true" />;
  }

  const selected = pending ?? current;

  return (
    <div className="flex flex-col gap-4">
      <div className="flex flex-col gap-2" role="radiogroup" aria-label={t("heading")}>
        {PERSONA_MODES.map((mode) => {
          const active = selected === mode;
          return (
            <button
              key={mode}
              type="button"
              onClick={() => {
                setPending(mode);
                setSaved(false);
              }}
              // Radio, not a toggle: exactly one life stage applies, and this is the
              // same control the wizard uses (P1.28.5/.6). `aria-pressed` announced
              // "pressed" instead of "3 of 5 selected", and the two screens have to
              // behave identically — Settings is where a wrong answer gets corrected.
              role="radio"
              aria-checked={active}
              className={cn(
                "flex flex-col items-start gap-1 rounded-md border p-4 text-start",
                "transition-[background-color,border-color,transform] duration-fast",
                "motion-safe:ease-spring motion-safe:active:scale-[0.99]",
                active
                  ? "border-primary bg-primary-soft text-primary-soft-text"
                  : "border-border bg-surface text-text hover:bg-surface-sunken",
              )}
            >
              <span className="font-medium">{t(`modes.${mode}.label`)}</span>
              <span className="text-sm text-text-muted">{t(`modes.${mode}.desc`)}</span>
              {mode === current ? (
                <span className="text-2xs text-text-subtle">{t("currentBadge")}</span>
              ) : null}
            </button>
          );
        })}
      </div>

      {/* The reassurance is the feature. See the component note. */}
      <p className="text-sm text-text-muted">{t("nothingLost")}</p>

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

      <Button
        variant="accent"
        className="self-start"
        onClick={apply}
        disabled={saving || !pending || pending === current}
      >
        {saving ? t("saving") : t("apply")}
      </Button>
    </div>
  );
}
