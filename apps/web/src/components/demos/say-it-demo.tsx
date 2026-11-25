"use client";

/**
 * "Say it in your words" (R2.10): a sample sentence becomes the log chips she would have
 * tapped, and she unticks anything wrong before it is added.
 *
 * Why it exists: Say it is the assistant's everyday use, and its privacy promise (her words
 * are not saved or sent) is easier to believe once seen. The demo only offers sample
 * sentences, whose chips are the ones the app's rule floor finds in them
 * (`SAY_IT_TERMS`), so it never claims to understand a sentence the app might not.
 * Nothing is stored or sent; the "Add" step only shows the app's confirmation line.
 */
import { useEffect, useState } from "react";
import { Check, Lock, Sparkles } from "lucide-react";

import { Button } from "@/components/ui/button";
import { SAY_IT_SAMPLES, SAY_IT_TERMS, type SayItSample, type SayItTerm } from "@/lib/demos/samples";
import { cn } from "@/lib/utils";

export type SayItDemoStrings = {
  samplesLabel: string;
  samples: Record<SayItSample, string>;
  title: string;
  action: string;
  found: string;
  /** The save button by number of ticked words (1..max), as the app counts it. */
  add: Record<number, string>;
  added: string;
  privateNote: string;
  demoNote: string;
  again: string;
  terms: Record<SayItTerm, string>;
};

type Stage = "idle" | "typing" | "typed" | "found" | "added";

/** Milliseconds per typed character in the demo's typing animation. */
const TYPE_MS = 28;

export function SayItDemo({ strings }: { strings: SayItDemoStrings }) {
  const [sample, setSample] = useState<SayItSample | null>(null);
  const [shown, setShown] = useState("");
  const [stage, setStage] = useState<Stage>("idle");
  const [ticked, setTicked] = useState<Set<SayItTerm>>(new Set());

  // Type the sentence in, unless she prefers reduced motion.
  useEffect(() => {
    if (sample === null || stage !== "typing") return;
    const text = strings.samples[sample];
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches || shown.length >= text.length) {
      setShown(text);
      setStage("typed");
      return;
    }
    const timer = window.setTimeout(() => setShown(text.slice(0, shown.length + 1)), TYPE_MS);
    return () => window.clearTimeout(timer);
  }, [sample, stage, shown, strings.samples]);

  const pick = (s: SayItSample) => {
    setSample(s);
    setShown("");
    setTicked(new Set(SAY_IT_TERMS[s]));
    setStage("typing");
  };

  const toggle = (term: SayItTerm) =>
    setTicked((prev) => {
      const next = new Set(prev);
      if (next.has(term)) next.delete(term);
      else next.add(term);
      return next;
    });

  return (
    <div className="flex flex-col gap-5">
      <div role="radiogroup" aria-label={strings.samplesLabel} className="flex flex-col gap-2">
        {SAY_IT_SAMPLES.map((s) => (
          <button
            key={s}
            type="button"
            role="radio"
            aria-checked={s === sample}
            onClick={() => pick(s)}
            className={cn(
              "min-h-11 rounded-md border px-4 py-2 text-start text-xs transition-colors duration-fast",
              s === sample
                ? "border-primary bg-primary-soft text-primary-soft-text"
                : "border-border bg-surface text-text hover:bg-surface-sunken",
            )}
          >
            “{strings.samples[s]}”
          </button>
        ))}
      </div>

      <div className="flex flex-col gap-4 rounded-lg border border-border bg-surface p-5 shadow-xs">
        <p className="text-sm font-semibold text-text">{strings.title}</p>
        <div
          className="min-h-20 rounded-md border-2 border-primary/60 bg-bg px-4 py-3 text-sm text-text"
          aria-live="polite"
        >
          {shown}
          {stage === "typing" && <span className="ms-0.5 inline-block h-4 w-0.5 translate-y-0.5 bg-primary motion-safe:animate-pulse" aria-hidden />}
        </div>

        {stage === "typed" && (
          <Button type="button" onClick={() => setStage("found")} className="w-full">
            <Sparkles className="size-4" aria-hidden />
            {strings.action}
          </Button>
        )}

        {(stage === "found" || stage === "added") && sample && (
          <div className="flex flex-col gap-3 motion-safe:animate-in motion-safe:slide-in-from-bottom-2">
            <p className="text-xs text-text-muted">{strings.found}</p>
            <ul className="flex flex-wrap gap-2">
              {SAY_IT_TERMS[sample].map((term) => {
                const on = ticked.has(term);
                return (
                  <li key={term}>
                    <button
                      type="button"
                      role="checkbox"
                      aria-checked={on}
                      disabled={stage === "added"}
                      onClick={() => toggle(term)}
                      className={cn(
                        "inline-flex min-h-11 items-center gap-2 rounded-md border px-4 text-sm transition-colors duration-fast",
                        on
                          ? "border-transparent bg-log-period-alt text-log-period"
                          : "border-border bg-surface text-text-muted line-through",
                      )}
                    >
                      <Check className={cn("size-4", !on && "invisible")} aria-hidden />
                      {strings.terms[term]}
                    </button>
                  </li>
                );
              })}
            </ul>
            {stage === "found" ? (
              <Button type="button" onClick={() => setStage("added")} disabled={ticked.size === 0} className="w-full">
                {strings.add[ticked.size] ?? strings.add[1]}
              </Button>
            ) : (
              <>
                <p role="status" className="rounded-md bg-success-soft px-4 py-3 text-xs font-semibold text-success-text">
                  {strings.added}
                </p>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => pick(SAY_IT_SAMPLES[(SAY_IT_SAMPLES.indexOf(sample) + 1) % SAY_IT_SAMPLES.length]!)}
                  className="w-full"
                >
                  {strings.again}
                </Button>
              </>
            )}
          </div>
        )}

        <p className="flex items-start gap-2 text-2xs leading-relaxed text-text-muted">
          <Lock className="mt-0.5 size-3.5 shrink-0" aria-hidden />
          {strings.privateNote}
        </p>
      </div>
      <p className="text-2xs text-text-subtle">{strings.demoNote}</p>
    </div>
  );
}
