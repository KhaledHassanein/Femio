"use client";

import { Minus, Plus } from "lucide-react";

/**
 * A number stepper that is a real `spinbutton` (02_DESIGN_SPEC §2.4, §2.11).
 *
 * The buttons disable at the bounds rather than clamping silently, because a
 * cycle length that was quietly changed is a number she did not enter. Arrow keys
 * step, Home/End jump to the bounds, and the value is announced with its unit.
 */
export function Stepper({
  id,
  label,
  value,
  min,
  max,
  unit,
  valueText,
  decrementLabel,
  incrementLabel,
  onChange,
}: {
  id: string;
  label: string;
  value: number;
  min: number;
  max: number;
  /** Shown beside the number ("days"). */
  unit: string;
  /** Spoken value ("28 days"). */
  valueText: string;
  decrementLabel: string;
  incrementLabel: string;
  onChange: (value: number) => void;
}) {
  const set = (next: number) => onChange(Math.min(max, Math.max(min, next)));
  const onKeyDown = (event: React.KeyboardEvent) => {
    const map: Record<string, number> = { ArrowUp: value + 1, ArrowRight: value + 1, ArrowDown: value - 1, ArrowLeft: value - 1, Home: min, End: max };
    const next = map[event.key];
    if (next === undefined) return;
    event.preventDefault();
    set(next);
  };
  return (
    <div className="flex items-center justify-between gap-3">
      <span id={`${id}-label`} className="text-sm font-semibold text-text">
        {label}
      </span>
      <div className="flex items-center gap-2">
        <button
          type="button"
          aria-label={decrementLabel}
          disabled={value <= min}
          onClick={() => set(value - 1)}
          className="flex size-11 items-center justify-center rounded-round bg-surface-sunken text-text transition-[background-color,transform] duration-instant hover:bg-border motion-safe:active:scale-95 disabled:opacity-40 disabled:hover:bg-surface-sunken focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-primary/50"
        >
          <Minus className="size-4" aria-hidden />
        </button>
        <div
          id={id}
          role="spinbutton"
          tabIndex={0}
          aria-labelledby={`${id}-label`}
          aria-valuenow={value}
          aria-valuemin={min}
          aria-valuemax={max}
          aria-valuetext={valueText}
          onKeyDown={onKeyDown}
          className="flex min-w-16 items-baseline justify-center gap-1 rounded-sm px-1 focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-primary/50"
        >
          <span className="text-xl font-semibold tabular-nums text-text">{value}</span>
          <span className="text-sm text-text-muted">{unit}</span>
        </div>
        <button
          type="button"
          aria-label={incrementLabel}
          disabled={value >= max}
          onClick={() => set(value + 1)}
          className="flex size-11 items-center justify-center rounded-round bg-surface-sunken text-text transition-[background-color,transform] duration-instant hover:bg-border motion-safe:active:scale-95 disabled:opacity-40 disabled:hover:bg-surface-sunken focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-primary/50"
        >
          <Plus className="size-4" aria-hidden />
        </button>
      </div>
    </div>
  );
}
