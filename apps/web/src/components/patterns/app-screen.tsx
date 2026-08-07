import type { ReactNode } from "react";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

/**
 * The shell every signed-in screen sits in (P1.28 cleanup).
 *
 * The same `<main>` class string had nine copies. That is not just untidy: when
 * P1.28.2 retuned the shell for a phone (`gap-5 px-5 py-6`) it changed the *ready*
 * branch of the dashboard and Track and missed their own loading and error
 * branches, so the page visibly reflowed — 48px of vertical padding collapsing to
 * 24px — the moment the query resolved. One component, and the three states of a
 * screen cannot disagree about its geometry again.
 *
 * Deliberately thin. It owns the frame and nothing else; the screens keep their
 * own headings and content, because those are the parts that differ.
 */
export function AppScreen({
  children,
  className,
  busy,
}: {
  children: ReactNode;
  className?: string;
  /** Sets `aria-busy` while a query is in flight. */
  busy?: boolean;
}) {
  return (
    <main
      aria-busy={busy || undefined}
      className={cn("mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-6", className)}
    >
      {children}
    </main>
  );
}

/**
 * The failed-read state, shared by every screen that reads its own data.
 *
 * Distinct from `patterns/ErrorState`, which is a centred full-bleed panel for a
 * page that has nothing at all — this one is the inline "we could not load it,
 * try again" alert that sits under a screen's real heading. Both exist on purpose.
 *
 * The heading is not optional: to someone looking at her own health record,
 * "nothing here" and "we could not load it" are very different statements
 * (ADR-046), and the heading is what stops the page reading as the former.
 */
export function ScreenError({
  title,
  message,
  retryLabel,
  onRetry,
  children,
}: {
  title: string;
  message: string;
  retryLabel: string;
  onRetry: () => void;
  /** Anything that must stay usable despite the failed read — Track keeps its logger. */
  children?: ReactNode;
}) {
  return (
    <>
      <h1 className="font-display text-lg text-text">{title}</h1>
      <Alert variant="danger">
        <AlertDescription className="flex flex-col items-start gap-3">
          <span>{message}</span>
          <Button variant="outline" onClick={onRetry}>
            {retryLabel}
          </Button>
        </AlertDescription>
      </Alert>
      {children}
    </>
  );
}
