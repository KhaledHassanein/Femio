import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

/**
 * The calculator's card: the one raised element on the page (02_DESIGN_SPEC §2.8).
 * 24px radius, 12px padding on a phone so the seven-column grid gets its full
 * width, 24px from the tablet breakpoint.
 */
export function CalculatorCard({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <section className={cn("flex flex-col gap-4 rounded-lg border border-border/70 bg-surface p-3 shadow-sm md:p-6", className)}>
      {children}
    </section>
  );
}

/** The accessible statement of a result: eyebrow, headline, detail lines (§2.5). */
export function ResultSentence({
  eyebrow,
  headline,
  lines,
  confidence,
  confidenceTone,
  children,
}: {
  eyebrow: string;
  headline: string;
  lines?: readonly string[];
  confidence?: string;
  confidenceTone?: "medium" | "low";
  children?: ReactNode;
}) {
  return (
    // A status region: a screen reader announces the result when a day is chosen,
    // without moving focus away from the grid (R2.7).
    <div role="status" className="flex flex-col gap-2 border-t border-border pt-4">
      <p className="text-sm text-text-muted">{eyebrow}</p>
      <p className="font-display text-xl font-semibold leading-snug text-text">
        <bdi>{headline}</bdi>
      </p>
      {lines?.map((line) => (
        <p key={line} className="text-sm text-text-muted">
          <bdi>{line}</bdi>
        </p>
      ))}
      {confidence ? (
        <p className={cn("text-sm font-semibold", confidenceTone === "low" ? "text-confidence-low" : "text-confidence-medium")}>{confidence}</p>
      ) : null}
      {children}
    </div>
  );
}

/** A register sentence under a result (MR-15, MR-16, MR-24 …): quiet, always present. */
export function RuleLine({ children }: { children: ReactNode }) {
  return <p className="text-sm text-text-muted">{children}</p>;
}
