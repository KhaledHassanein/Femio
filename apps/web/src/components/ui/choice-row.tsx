"use client";

import { useRef, type ReactNode } from "react";
import { cn } from "@/lib/utils";

/**
 * A single-choice list of cards — the onboarding wizard's life-stage picker and
 * the identical control in Settings (P1.28 cleanup).
 *
 * Both screens had their own copy, and they had already diverged on the exact axis
 * the change was about: Settings never got the radio dot, whose whole point is that
 * you can see a card is selectable *before* you guess. Settings is where a wrong
 * onboarding answer gets corrected, so it is the last place that should be the
 * weaker version.
 *
 * ## Why the group owns the keyboard
 *
 * `role="radio"` is a promise, and the earlier per-screen versions only kept half
 * of it. WAI-ARIA's radiogroup pattern is a **single tab stop** with arrow keys
 * moving between options; four independently tabbable buttons announce "radio,
 * 2 of 4" and then behave like nothing of the sort. Announcing the role without
 * the behaviour is worse than plain buttons, because it tells a keyboard user to
 * expect something that will not happen. Roving `tabindex` + Arrow/Home/End lives
 * here so no screen can implement half of it again.
 */
export type Choice<T extends string> = {
  value: T;
  name: string;
  desc: string;
  /** Optional trailing line — Settings uses it for "this is your current mode". */
  note?: ReactNode;
};

export function ChoiceGroup<T extends string>({
  label,
  value,
  options,
  onChange,
  className,
}: {
  label: string;
  value: T | null;
  options: readonly Choice<T>[];
  onChange: (value: T) => void;
  className?: string;
}) {
  const refs = useRef<Array<HTMLButtonElement | null>>([]);

  // The tab stop: the selected option, or the first one when nothing is chosen yet,
  // so Tab always lands somewhere useful and never cycles through all of them.
  const activeIndex = Math.max(
    0,
    options.findIndex((o) => o.value === value),
  );

  const move = (from: number, delta: number) => {
    const next = (from + delta + options.length) % options.length;
    onChange(options[next]!.value);
    refs.current[next]?.focus();
  };

  const onKeyDown = (event: React.KeyboardEvent<HTMLButtonElement>, index: number) => {
    // A vertical list, so the horizontal arrows are aliases rather than a second
    // axis — which also means there is nothing to mirror in RTL.
    switch (event.key) {
      case "ArrowDown":
      case "ArrowRight":
        event.preventDefault();
        move(index, 1);
        break;
      case "ArrowUp":
      case "ArrowLeft":
        event.preventDefault();
        move(index, -1);
        break;
      case "Home":
        event.preventDefault();
        move(index, -index);
        break;
      case "End":
        event.preventDefault();
        move(index, options.length - 1 - index);
        break;
      default:
        break;
    }
  };

  return (
    <div
      role="radiogroup"
      aria-label={label}
      aria-orientation="vertical"
      className={cn("flex flex-col gap-3", className)}
    >
      {options.map((option, index) => {
        const selected = option.value === value;
        return (
          <button
            key={option.value}
            ref={(el) => {
              refs.current[index] = el;
            }}
            type="button"
            role="radio"
            aria-checked={selected}
            tabIndex={index === activeIndex ? 0 : -1}
            onClick={() => onChange(option.value)}
            onKeyDown={(event) => onKeyDown(event, index)}
            className={cn(
              "flex w-full items-start gap-3 rounded-md border p-4 text-start",
              "transition-[background-color,border-color,transform] duration-fast",
              "motion-safe:ease-spring motion-safe:active:scale-[0.99]",
              selected
                ? "border-primary bg-primary-soft"
                : "border-border bg-surface hover:bg-surface-sunken",
            )}
          >
            <span
              aria-hidden
              className={cn(
                "mt-0.5 size-5 shrink-0 rounded-round border-2 transition-colors duration-fast",
                selected
                  ? "border-primary bg-primary shadow-[inset_0_0_0_3px_var(--surface)]"
                  : "border-border-strong",
              )}
            />
            <span className="flex min-w-0 flex-col gap-0.5">
              <span
                className={cn("font-semibold", selected ? "text-primary-soft-text" : "text-text")}
              >
                {option.name}
              </span>
              <span className="text-sm text-text-muted">{option.desc}</span>
              {option.note}
            </span>
          </button>
        );
      })}
    </div>
  );
}
