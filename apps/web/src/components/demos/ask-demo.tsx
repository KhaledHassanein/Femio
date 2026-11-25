"use client";

/**
 * "Ask femio" (R2.10): three sample questions, each showing one of the three ways the
 * app's assistant can answer.
 *
 * Why it exists: the assistant's value is in how it refuses as much as how it answers.
 * The three outcomes are the app's real ones (ADR-079): a short answer that cites the
 * trusted passages it stands on; the safety rule that runs before any model and opens
 * help (MR-50); and "not covered yet" when no trusted passage matches. Every sentence
 * except the sample answer is the app's own string (`appDemo.app`, synced from the ARB
 * files); the sample answer restates the bundled MedlinePlus "Period Pain" passages.
 * Nothing is sent anywhere: the demo is canned and runs in the browser.
 */
import { useEffect, useState } from "react";
import { BadgeCheck, ExternalLink, Phone, Search } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/navigation";
import { ASK_OUTCOME, ASK_QUESTIONS, ASK_SOURCE, type AskQuestion } from "@/lib/demos/samples";
import { cn } from "@/lib/utils";

export type AskDemoStrings = {
  questionsLabel: string;
  questions: Record<AskQuestion, string>;
  intro: string;
  action: string;
  searching: string;
  answerOnPhone: string;
  answer: string;
  clinicianLine: string;
  sourcesTitle: string;
  sourceTitle: string;
  /** "{publisher} · reviewed {date}", already filled in. */
  sourceLine: string;
  safetyHeading: string;
  safetyBody: string;
  rulesFirst: string;
  helpNow: string;
  notCoveredHeading: string;
  notCovered: string;
  again: string;
  demoNote: string;
};

/** How long the demo shows "Reading trusted sources…", in ms. */
const SEARCH_MS = 900;

/** Renders "[1]" markers in an answer as small numbered badges that point at the sources. */
function Cited({ text }: { text: string }) {
  const parts = text.split(/(\[\d+\])/);
  return (
    <>
      {parts.map((part, i) => {
        const n = /^\[(\d+)\]$/.exec(part)?.[1];
        return n ? (
          <sup key={i} className="ms-0.5 inline-flex size-4 items-center justify-center rounded-round bg-primary-solid text-[10px] font-semibold text-primary-fg-solid">
            {n}
          </sup>
        ) : (
          <span key={i}>{part}</span>
        );
      })}
    </>
  );
}

export function AskDemo({ strings }: { strings: AskDemoStrings }) {
  const [question, setQuestion] = useState<AskQuestion | null>(null);
  const [searching, setSearching] = useState(false);

  useEffect(() => {
    if (!searching) return;
    const timer = window.setTimeout(() => setSearching(false), SEARCH_MS);
    return () => window.clearTimeout(timer);
  }, [searching]);

  const ask = (q: AskQuestion) => {
    setQuestion(q);
    // Safety rules answer at once: they run before any search or model.
    setSearching(ASK_OUTCOME[q] !== "safety");
  };

  const outcome = question && !searching ? ASK_OUTCOME[question] : null;

  return (
    <div className="flex flex-col gap-5">
      <div role="radiogroup" aria-label={strings.questionsLabel} className="flex flex-wrap gap-2">
        {ASK_QUESTIONS.map((q) => (
          <button
            key={q}
            type="button"
            role="radio"
            aria-checked={q === question}
            onClick={() => ask(q)}
            className={cn(
              "min-h-11 rounded-pill border px-4 text-xs font-semibold transition-colors duration-fast",
              q === question
                ? "border-primary bg-primary-soft text-primary-soft-text"
                : "border-border bg-surface text-text hover:bg-surface-sunken",
            )}
          >
            {strings.questions[q]}
          </button>
        ))}
      </div>

      <div className="flex flex-col gap-4 rounded-lg border border-border bg-surface p-5 shadow-xs">
        <p className="text-xs leading-relaxed text-text-muted">{strings.intro}</p>
        <div className="flex min-h-11 items-center gap-2 rounded-md border-2 border-primary/60 bg-bg px-4 text-sm text-text">
          <Search className="size-4 shrink-0 text-text-subtle" aria-hidden />
          <span className={cn(!question && "text-text-subtle")}>{question ? strings.questions[question] : strings.action}</span>
        </div>

        <div aria-live="polite" className="flex flex-col gap-4">
          {searching && (
            <p className="flex items-center gap-2 text-xs text-text-muted">
              <span className="size-2 rounded-round bg-primary motion-safe:animate-pulse" aria-hidden />
              {strings.searching}
            </p>
          )}

          {outcome === "answer" && (
            <div className="flex flex-col gap-4 motion-safe:animate-in motion-safe:fade-in">
              <div className="rounded-md border border-border bg-bg p-4">
                <p className="flex items-start gap-2 text-2xs font-semibold text-text-muted">
                  <BadgeCheck className="mt-px size-4 shrink-0 text-success-text" aria-hidden />
                  {strings.answerOnPhone}
                </p>
                <p className="mt-2 text-sm leading-relaxed text-text">
                  <Cited text={strings.answer} />
                </p>
                <p className="mt-3 text-2xs leading-relaxed text-text-muted">{strings.clinicianLine}</p>
              </div>
              <div>
                <p className="text-xs font-semibold text-text">{strings.sourcesTitle}</p>
                <ol className="mt-2 flex flex-col gap-2">
                  {[1, 2].map((n) => (
                    <li key={n} className="flex items-center gap-3">
                      <span className="flex size-6 shrink-0 items-center justify-center rounded-round bg-primary-solid text-2xs font-semibold text-primary-fg-solid">
                        {n}
                      </span>
                      <a
                        href={ASK_SOURCE.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="group flex flex-1 flex-col text-xs"
                      >
                        <span className="inline-flex items-center gap-1 font-semibold text-text-link group-hover:underline" lang="en" dir="ltr">
                          {strings.sourceTitle}
                          <ExternalLink className="size-3" aria-hidden />
                        </span>
                        <span className="text-2xs text-text-muted">{strings.sourceLine}</span>
                      </a>
                    </li>
                  ))}
                </ol>
              </div>
            </div>
          )}

          {outcome === "safety" && (
            <div className="flex flex-col gap-3 motion-safe:animate-in motion-safe:fade-in">
              <div className="flex gap-3 rounded-md border border-danger-border bg-danger-soft p-4 text-danger-text">
                <Phone className="mt-0.5 size-5 shrink-0" aria-hidden />
                <div className="flex flex-col gap-1">
                  <p className="text-sm font-semibold">{strings.safetyHeading}</p>
                  <p className="text-xs leading-relaxed">{strings.safetyBody}</p>
                </div>
              </div>
              <Button asChild className="w-full">
                <Link href="/help-now">{strings.helpNow}</Link>
              </Button>
              <p className="text-2xs leading-relaxed text-text-muted">{strings.rulesFirst}</p>
            </div>
          )}

          {outcome === "notCovered" && (
            <div className="rounded-md border border-border bg-bg p-4 motion-safe:animate-in motion-safe:fade-in">
              <p className="text-sm font-semibold text-text">{strings.notCoveredHeading}</p>
              <p className="mt-1 text-xs leading-relaxed text-text-muted">{strings.notCovered}</p>
            </div>
          )}

          {outcome && (
            <Button type="button" variant="outline" onClick={() => setQuestion(null)} className="w-full">
              {strings.again}
            </Button>
          )}
        </div>
      </div>
      <p className="text-2xs text-text-subtle">{strings.demoNote}</p>
    </div>
  );
}
