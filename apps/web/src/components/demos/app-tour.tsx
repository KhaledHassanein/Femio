"use client";

/**
 * The app tour (R2.10): real app screens in a drawn phone, one per step, that play on
 * their own and can be picked by hand.
 *
 * Why it exists: the website is the app's front door, and the app is not on Google Play
 * yet, so this is where a visitor sees the product. The screens are the app's own test
 * renders (synthetic data, `testing-results/2026-11-24-*`), never a mock-up, so the site
 * cannot show a screen the app does not have.
 *
 * Behaviour:
 * - Steps are a tab list (arrow keys move between them, WAI-ARIA tabs pattern).
 * - The tour advances every few seconds until she picks a step, pauses, or prefers
 *   reduced motion; it never moves while the pointer or focus is inside it.
 * - A screen taller than the phone pans slowly from top to bottom (motion-safe only);
 *   with reduced motion the phone screen scrolls instead.
 * - Strings arrive as props from the server wrapper, so no catalog ships to the browser.
 */
import { useCallback, useEffect, useId, useRef, useState } from "react";
import { Pause, Play } from "lucide-react";

import { cn } from "@/lib/utils";

export type TourStepView = {
  key: string;
  label: string;
  title: string;
  body: string;
  alt: string;
  light: string;
  dark: string | null;
  /** Image height divided by width, from the render size. */
  ratio: number;
};

export type AppTourStrings = { pause: string; play: string; synthetic: string; languagesNote: string };

/** How long each step stays before the tour moves on, in ms. */
const STEP_MS = 7000;
/** The phone screen's height divided by its width (390 × 844). */
const SCREEN_RATIO = 844 / 390;

export function AppTour({ steps, strings }: { steps: TourStepView[]; strings: AppTourStrings }) {
  const [index, setIndex] = useState(0);
  const [playing, setPlaying] = useState(true);
  const [held, setHeld] = useState(false);
  const [reduced, setReduced] = useState(false);
  const tabs = useRef<(HTMLButtonElement | null)[]>([]);
  const baseId = useId();

  useEffect(() => {
    const query = window.matchMedia("(prefers-reduced-motion: reduce)");
    const sync = () => setReduced(query.matches);
    sync();
    query.addEventListener("change", sync);
    return () => query.removeEventListener("change", sync);
  }, []);

  const running = playing && !held && !reduced;
  useEffect(() => {
    if (!running) return;
    const timer = window.setTimeout(() => setIndex((i) => (i + 1) % steps.length), STEP_MS);
    return () => window.clearTimeout(timer);
  }, [running, index, steps.length]);

  const select = useCallback(
    (next: number, focus = false) => {
      const i = (next + steps.length) % steps.length;
      setIndex(i);
      setPlaying(false);
      if (focus) tabs.current[i]?.focus();
    },
    [steps.length],
  );

  const onKeyDown = (e: React.KeyboardEvent) => {
    // Arrow keys follow the reading direction: "next" is to the left in Arabic.
    const rtl = (e.currentTarget as HTMLElement).closest("[dir=rtl]") !== null;
    if (e.key === "ArrowRight") select(index + (rtl ? -1 : 1), true);
    else if (e.key === "ArrowLeft") select(index + (rtl ? 1 : -1), true);
    else if (e.key === "Home") select(0, true);
    else if (e.key === "End") select(steps.length - 1, true);
    else return;
    e.preventDefault();
  };

  const step = steps[index]!;
  // How far a tall screen pans, as a share of the image's own height.
  const pan = Math.max(0, (1 - SCREEN_RATIO / step.ratio) * 100);

  return (
    <div
      className="flex flex-col items-center gap-8 md:flex-row md:items-start md:gap-12"
      onPointerEnter={() => setHeld(true)}
      onPointerLeave={() => setHeld(false)}
      onFocus={() => setHeld(true)}
      onBlur={(e) => {
        if (!e.currentTarget.contains(e.relatedTarget as Node | null)) setHeld(false);
      }}
    >
      <div className="relative w-[260px] shrink-0 rounded-[2.75rem] bg-[#1d0f1c] p-2.5 shadow-[0_30px_80px_-20px_rgb(0_0_0/0.55)] ring-1 ring-white/15">
        <div className="absolute start-1/2 top-3.5 z-10 h-4 w-16 -translate-x-1/2 rounded-pill bg-black rtl:translate-x-1/2" aria-hidden />
        <div
          id={`${baseId}-panel`}
          role="tabpanel"
          aria-labelledby={`${baseId}-tab-${index}`}
          className={cn(
            "relative overflow-hidden rounded-[2.25rem] bg-bg",
            reduced && "overflow-y-auto",
          )}
          style={{ aspectRatio: `390 / 844` }}
          tabIndex={reduced ? 0 : -1}
        >
          {/* The key restarts the pan when the step changes. */}
          <div
            key={step.key}
            className="tour-pan"
            style={{ "--tour-pan": `-${pan}%`, animationPlayState: held || !playing ? "paused" : "running" } as React.CSSProperties}
          >
            {/* Plain img: the files are pre-sized WebP; next/image would add nothing here. */}
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={step.light}
              alt={step.alt}
              width={390}
              height={Math.round(390 * step.ratio)}
              className={cn("block h-auto w-full", step.dark && "dark:hidden")}
              decoding="async"
            />
            {step.dark && (
              // eslint-disable-next-line @next/next/no-img-element
              <img
                src={step.dark}
                alt={step.alt}
                width={390}
                height={Math.round(390 * step.ratio)}
                className="hidden h-auto w-full dark:block"
                decoding="async"
              />
            )}
          </div>
        </div>
      </div>

      <div className="flex w-full max-w-md flex-col gap-5">
        <div role="tablist" aria-orientation="horizontal" className="flex flex-wrap gap-2" onKeyDown={onKeyDown}>
          {steps.map((s, i) => (
            <button
              key={s.key}
              ref={(el) => {
                tabs.current[i] = el;
              }}
              id={`${baseId}-tab-${i}`}
              role="tab"
              type="button"
              aria-selected={i === index}
              aria-controls={`${baseId}-panel`}
              tabIndex={i === index ? 0 : -1}
              onClick={() => select(i)}
              className={cn(
                "relative min-h-11 overflow-hidden rounded-pill border px-4 text-xs font-semibold transition-colors duration-fast",
                i === index
                  ? "border-primary bg-primary-soft text-primary-soft-text"
                  : "border-border bg-surface text-text hover:bg-surface-sunken",
              )}
            >
              {s.label}
              {i === index && running && (
                <span
                  key={`p-${index}`}
                  className="tour-progress absolute inset-x-0 bottom-0 h-0.5 origin-left bg-primary rtl:origin-right"
                  style={{ animationDuration: `${STEP_MS}ms` }}
                  aria-hidden
                />
              )}
            </button>
          ))}
          <button
            type="button"
            onClick={() => setPlaying((p) => !p)}
            className="flex size-11 items-center justify-center rounded-pill border border-border bg-surface text-text hover:bg-surface-sunken"
            aria-label={playing ? strings.pause : strings.play}
            hidden={reduced}
          >
            {playing ? <Pause className="size-4" aria-hidden /> : <Play className="size-4 rtl:-scale-x-100" aria-hidden />}
          </button>
        </div>

        {/* Announced only when she picked the step; a playing tour would talk over her. */}
        <div aria-live={running ? "off" : "polite"} className="flex flex-col gap-2">
          <h3 className="font-display text-lg text-text rtl:font-bold">{step.title}</h3>
          <p className="text-sm leading-relaxed text-text-muted">{step.body}</p>
        </div>
        <p className="text-2xs text-text-subtle">
          {strings.synthetic} {strings.languagesNote}
        </p>
      </div>
    </div>
  );
}
